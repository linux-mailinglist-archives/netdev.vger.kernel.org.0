Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44E12612CC
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 16:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgIHO1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 10:27:02 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39750 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729406AbgIHOY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 10:24:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599575089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YjOdee3Q/C2UqkYbF7JyUTOdPT3/RYJMa4NGdcXzk8c=;
        b=FsLvYcLxbE/Yc6Gjkwv5kiyN+1s+GzXxWWndrmQxMPFS+a4dFPDU/BDrwa6Y7PPv0AiEsx
        iR3jUDSLmQSiw8ScFPR1c/NGcJZi0PP2Ht7cIWULqIe4S2/YknQQRcgJLptXsVJLV8NIUw
        OjbVTOcbDTLJZHV+o7GM39JDLiKdORY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-qtNQjH_COfaEukb4uKmHVA-1; Tue, 08 Sep 2020 08:04:41 -0400
X-MC-Unique: qtNQjH_COfaEukb4uKmHVA-1
Received: by mail-wm1-f70.google.com with SMTP id d5so3403707wmb.2
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 05:04:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YjOdee3Q/C2UqkYbF7JyUTOdPT3/RYJMa4NGdcXzk8c=;
        b=XtXVh5V3ICJMzJYQOb1oc1/+0aMEacVoZ6n8ZXPMZ7r1UU1UD6xLucue6ihkmjM69S
         v01qizH6qmb463x1WKF1ZlgaQBJEIFl129ahUacIHYGz5M+QPn/LIW4b1hD0QFzTu64V
         xgg3OLUZCRA0ym9Q8PFfKrZmssSyGed6SpPQ+Gmxb/S499I4Wv/owBxwYr5cmTjXVIFS
         xiGpVeedWI+1fRphf7XiSH3ISTMRakwOfaL+n0E4P905C/cH/Ba6BKCG8T93wXE2ZbPo
         b2+8srJdLZolpjDcpySx+zqcDCvK+9DDy6ZUUskJPIqdENLuMhSVgbhC4hxTRnCt6gL0
         V7Tw==
X-Gm-Message-State: AOAM532nZ40kUGDL5Fcu13KlpVW1Sk/IiXmwCVoS8UzP+Z2uB796o5Jj
        IwtrPoXsY0az4LJC5lHqEAtwPeG4toyqUobRkp/NenASb9aIMou14zTZYTbqjLvTuGKcmQi2oag
        LuRaILgNGWhY6SkD2
X-Received: by 2002:a1c:a557:: with SMTP id o84mr3980903wme.96.1599566679918;
        Tue, 08 Sep 2020 05:04:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfM0XajRaKoImehnmBKZJjqFN0ajTAWb3xXq9shTOYnMiiCcSF9D1X8Yic4i86U+wLx/EFRw==
X-Received: by 2002:a1c:a557:: with SMTP id o84mr3980888wme.96.1599566679700;
        Tue, 08 Sep 2020 05:04:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-221-30.inter.net.il. [80.230.221.30])
        by smtp.gmail.com with ESMTPSA id v204sm32533592wmg.20.2020.09.08.05.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 05:04:38 -0700 (PDT)
Date:   Tue, 8 Sep 2020 08:04:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK
Message-ID: <20200908080428-mutt-send-email-mst@kernel.org>
References: <20200907075136.GA114876@mtl-vdi-166.wap.labs.mlnx>
 <20200907073319-mutt-send-email-mst@kernel.org>
 <20200907114351.GC121033@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907114351.GC121033@mtl-vdi-166.wap.labs.mlnx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 02:43:51PM +0300, Eli Cohen wrote:
> On Mon, Sep 07, 2020 at 07:34:00AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Sep 07, 2020 at 10:51:36AM +0300, Eli Cohen wrote:
> > > If the memory map changes before the driver status is
> > > VIRTIO_CONFIG_S_DRIVER_OK, don't attempt to create resources because it
> > > may fail. For example, if the VQ is not ready there is no point in
> > > creating resources.
> > > 
> > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > 
> > 
> > Could you add a bit more data about the problem to the log?
> > To be more exact, what exactly happens right now?
> >
> 
> Sure I can.
> 
> set_map() is used by mlx5 vdpa to create a memory region based on the
> address map passed by the iotlb argument. If I get successive calls, I
> will destroy the current memory region and build another one based on
> the new address mapping. I also need to setup the hardware resources
> since they depend on the memory region.
> 
> If these calls happen before DRIVER_OK, It means it that driver VQs may
> also not been setup and I may not create them yet. In this case I want
> to avoid setting up the other resources and defer this till I get DRIVER
> OK.
> 
> Let me know if that answers your question so I can post another patch.

it does, pls do.

> > > ---
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > index 9df69d5efe8c..c89cd48a0aab 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -1645,6 +1645,9 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_net *ndev, struct vhost_iotlb *
> > >  	if (err)
> > >  		goto err_mr;
> > >  
> > > +	if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK))
> > > +		return 0;
> > > +
> > >  	restore_channels_info(ndev);
> > >  	err = setup_driver(ndev);
> > >  	if (err)
> > > -- 
> > > 2.26.0
> > 

