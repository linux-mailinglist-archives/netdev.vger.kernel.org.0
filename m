Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DA92FCC37
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 09:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbhATIAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 03:00:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730129AbhATH7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611129431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=er7iaXjTuPXAuVg2JyI2Go7WG0KWUxlUDhb5X07oLSI=;
        b=FMBus5WnbJEh0tDySPbMw0BPJCtMLfSgBHACwUEVGmHw3z3+SXd/4EJo7Rs1aB+EwkVZQ8
        iHN0T42pIIKnhiv3YpRaJY8GgEBj7W2ng0KixI7Hx7X4Ccc4tyttmpKABXNsik1Wzmpc+6
        eEGPl3prbsxElP+5FBDUClBlNO/gCg0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-jA2DVmxUNkyscwGjEeMuCA-1; Wed, 20 Jan 2021 02:57:10 -0500
X-MC-Unique: jA2DVmxUNkyscwGjEeMuCA-1
Received: by mail-wr1-f71.google.com with SMTP id o12so10950806wrq.13
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=er7iaXjTuPXAuVg2JyI2Go7WG0KWUxlUDhb5X07oLSI=;
        b=lpmBdEJ8CfFh5eN1oMkaT6ResdkYI3sZLVVOn8T6G42fjdsgBaSt5OZFJB178PFYAA
         WVeql+W4RvsNvZc6ifJXehEz3DFKXm8MsDhYkG6kz1ULIj5oezxw+6H6nMe5ztCWing1
         EHcmraXBSKqL53XKmFzrgUEuoz0FtbRI4IM/xWOYcWmZ6hUN952j7zuZJ3343aDfCCUA
         1I/ysCMID+00MgyrbePnz9+7OWmejYJcs0u54P0v+1+K3ndqLiyaJzYnIjzV95ChIEOm
         Vfhs+eeFIuGGo4HZbciwTi4of/Tu6x4b+fR7uAeNFz3X+BKLGNLqnaWYE1BVu1nmrck5
         9FXA==
X-Gm-Message-State: AOAM531zPjevDAtt5zhOfel3jxLVTdrdYkIgtCTxlsJVJnpuEkWFl9Ol
        v7nJZ6MiczBSdc+Kp2mlzjVYFdX4omj9CD8NNGHxUYjpYGsQ2+irQE9b/7ISCM2RsZu/aczvXTP
        WQR1IKzp2sFptbZM4
X-Received: by 2002:a05:6000:23c:: with SMTP id l28mr7999288wrz.193.1611129429003;
        Tue, 19 Jan 2021 23:57:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUiC5Y9Vg5pC0MU0ECnGIqKfkGRRvWpS4NGc3EA1VxrPUjICeThsn7tnPF+wylrJ5i3NLdeQ==
X-Received: by 2002:a05:6000:23c:: with SMTP id l28mr7999283wrz.193.1611129428857;
        Tue, 19 Jan 2021 23:57:08 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id s24sm2328921wmh.22.2021.01.19.23.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 23:57:08 -0800 (PST)
Date:   Wed, 20 Jan 2021 02:57:05 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com
Subject: Re: [PATCH v1] vdpa/mlx5: Fix memory key MTT population
Message-ID: <20210120025651-mutt-send-email-mst@kernel.org>
References: <20210107071845.GA224876@mtl-vdi-166.wap.labs.mlnx>
 <07d336a3-7fc2-5e4a-667a-495b5bb755da@redhat.com>
 <20210120053619.GA126435@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210120053619.GA126435@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 07:36:19AM +0200, Eli Cohen wrote:
> On Fri, Jan 08, 2021 at 04:38:55PM +0800, Jason Wang wrote:
> 
> Hi Michael,
> this patch is a fix. Are you going to merge it?

yes - in the next pull request.

> > 
> > On 2021/1/7 下午3:18, Eli Cohen wrote:
> > > map_direct_mr() assumed that the number of scatter/gather entries
> > > returned by dma_map_sg_attrs() was equal to the number of segments in
> > > the sgl list. This led to wrong population of the mkey object. Fix this
> > > by properly referring to the returned value.
> > > 
> > > The hardware expects each MTT entry to contain the DMA address of a
> > > contiguous block of memory of size (1 << mr->log_size) bytes.
> > > dma_map_sg_attrs() can coalesce several sg entries into a single
> > > scatter/gather entry of contiguous DMA range so we need to scan the list
> > > and refer to the size of each s/g entry.
> > > 
> > > In addition, get rid of fill_sg() which effect is overwritten by
> > > populate_mtts().
> > > 
> > > Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > ---
> > > V0->V1:
> > > 1. Fix typos
> > > 2. Improve changelog
> > 
> > 
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > 
> > 
> > > 
> > >   drivers/vdpa/mlx5/core/mlx5_vdpa.h |  1 +
> > >   drivers/vdpa/mlx5/core/mr.c        | 28 ++++++++++++----------------
> > >   2 files changed, 13 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> > > index 5c92a576edae..08f742fd2409 100644
> > > --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> > > +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> > > @@ -15,6 +15,7 @@ struct mlx5_vdpa_direct_mr {
> > >   	struct sg_table sg_head;
> > >   	int log_size;
> > >   	int nsg;
> > > +	int nent;
> > >   	struct list_head list;
> > >   	u64 offset;
> > >   };
> > > diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> > > index 4b6195666c58..d300f799efcd 100644
> > > --- a/drivers/vdpa/mlx5/core/mr.c
> > > +++ b/drivers/vdpa/mlx5/core/mr.c
> > > @@ -25,17 +25,6 @@ static int get_octo_len(u64 len, int page_shift)
> > >   	return (npages + 1) / 2;
> > >   }
> > > -static void fill_sg(struct mlx5_vdpa_direct_mr *mr, void *in)
> > > -{
> > > -	struct scatterlist *sg;
> > > -	__be64 *pas;
> > > -	int i;
> > > -
> > > -	pas = MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
> > > -	for_each_sg(mr->sg_head.sgl, sg, mr->nsg, i)
> > > -		(*pas) = cpu_to_be64(sg_dma_address(sg));
> > > -}
> > > -
> > >   static void mlx5_set_access_mode(void *mkc, int mode)
> > >   {
> > >   	MLX5_SET(mkc, mkc, access_mode_1_0, mode & 0x3);
> > > @@ -45,10 +34,18 @@ static void mlx5_set_access_mode(void *mkc, int mode)
> > >   static void populate_mtts(struct mlx5_vdpa_direct_mr *mr, __be64 *mtt)
> > >   {
> > >   	struct scatterlist *sg;
> > > +	int nsg = mr->nsg;
> > > +	u64 dma_addr;
> > > +	u64 dma_len;
> > > +	int j = 0;
> > >   	int i;
> > > -	for_each_sg(mr->sg_head.sgl, sg, mr->nsg, i)
> > > -		mtt[i] = cpu_to_be64(sg_dma_address(sg));
> > > +	for_each_sg(mr->sg_head.sgl, sg, mr->nent, i) {
> > > +		for (dma_addr = sg_dma_address(sg), dma_len = sg_dma_len(sg);
> > > +		     nsg && dma_len;
> > > +		     nsg--, dma_addr += BIT(mr->log_size), dma_len -= BIT(mr->log_size))
> > > +			mtt[j++] = cpu_to_be64(dma_addr);
> > > +	}
> > >   }
> > >   static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
> > > @@ -64,7 +61,6 @@ static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct
> > >   		return -ENOMEM;
> > >   	MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
> > > -	fill_sg(mr, in);
> > >   	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
> > >   	MLX5_SET(mkc, mkc, lw, !!(mr->perm & VHOST_MAP_WO));
> > >   	MLX5_SET(mkc, mkc, lr, !!(mr->perm & VHOST_MAP_RO));
> > > @@ -276,8 +272,8 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
> > >   done:
> > >   	mr->log_size = log_entity_size;
> > >   	mr->nsg = nsg;
> > > -	err = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
> > > -	if (!err)
> > > +	mr->nent = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
> > > +	if (!mr->nent)
> > >   		goto err_map;
> > >   	err = create_direct_mr(mvdev, mr);
> > 

