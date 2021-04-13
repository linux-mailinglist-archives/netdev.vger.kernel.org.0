Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FE135E0DC
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhDMODd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:03:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345086AbhDMOD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 10:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618322586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=swYl2fUsBiiVjxnatT+LNRdbKdi4oKKSZ6QxSoSZPJk=;
        b=KNKXEF4j2U2DUFIATev3ljyo+VC29H7nJJ+WNr35Ts43XDsCU68W2gJqBDO43dUB+Pmt6i
        lztPSnhw1494mGcBrB5v7rRZIdDle9YVGTT1tECyWbeIyYR3+/EpaTpXw1AMitPa/CUQFA
        gW+B1CtSDlTaotAYZk/n8So9Q5XFKMw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-SRhkqbuONn2EOJ_GK2jZ5g-1; Tue, 13 Apr 2021 10:03:01 -0400
X-MC-Unique: SRhkqbuONn2EOJ_GK2jZ5g-1
Received: by mail-wr1-f69.google.com with SMTP id a15so801187wrf.19
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=swYl2fUsBiiVjxnatT+LNRdbKdi4oKKSZ6QxSoSZPJk=;
        b=cspsVJA/qV1bEP9DCnCOBhGN/M2L5Y+JeMKnC15KNoD21Hc7pv/GO2cuSJrn+wmd6Y
         0+DkpNL2DFnQvLHDcZXPJXfI8V8XdFRwX2iRCn98VIow4AJFQWQx2GXKc/qIx6sx1Fhs
         spOSS5wKCISoPBIZ4xlDXS5YZsCi8oUS8HfAhmOgFqwWZEA9VbwMbBOliYw7GcAUDCRm
         bPWaghqNo4NUhAt1MZUY4rVwKNqMmQ+1mRrRRRgSJlUWMbWS5jdLFCYdvbwDQHq6jYvU
         SA1E+rJ6cwlL+7XCo/W85Y52zamdukSjGS56ri6ZnU2vf4VWqvQ8VrNM2+wGgomCYVNE
         +Acg==
X-Gm-Message-State: AOAM532sQDWw/7iF2GE5mvrh9nYIk5PApHQ3UsFSqpY/e2EjHDhDiv9k
        K8NiBTahymL4mtarwefAizwPCGS/SuMTQ0mnoNZaGKg6prv63GsdJnx9k/73Bsj3OTjz2VioDrp
        3fL3yKoOQH0OKtZx8
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr188039wmo.68.1618322579650;
        Tue, 13 Apr 2021 07:02:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytEpDKGiR9o7JztK9xr/CiCIDyo4VVVhCw7mpf/3UO/HzypD1HWJ5i0ZPENNve3YfdPorFWg==
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr188006wmo.68.1618322579419;
        Tue, 13 Apr 2021 07:02:59 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id q20sm2867997wmq.2.2021.04.13.07.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 07:02:58 -0700 (PDT)
Date:   Tue, 13 Apr 2021 10:02:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC v2 3/4] virtio_net: move tx vq operation under tx
 queue lock
Message-ID: <20210413100222-mutt-send-email-mst@kernel.org>
References: <20210413054733.36363-1-mst@redhat.com>
 <20210413054733.36363-4-mst@redhat.com>
 <805053bf-960f-3c34-ce23-012d121ca937@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <805053bf-960f-3c34-ce23-012d121ca937@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 04:54:42PM +0800, Jason Wang wrote:
> 
> 在 2021/4/13 下午1:47, Michael S. Tsirkin 写道:
> > It's unsafe to operate a vq from multiple threads.
> > Unfortunately this is exactly what we do when invoking
> > clean tx poll from rx napi.
> > As a fix move everything that deals with the vq to under tx lock.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/net/virtio_net.c | 22 +++++++++++++++++++++-
> >   1 file changed, 21 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 16d5abed582c..460ccdbb840e 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1505,6 +1505,8 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> >   	struct virtnet_info *vi = sq->vq->vdev->priv;
> >   	unsigned int index = vq2txq(sq->vq);
> >   	struct netdev_queue *txq;
> > +	int opaque;
> > +	bool done;
> >   	if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
> >   		/* We don't need to enable cb for XDP */
> > @@ -1514,10 +1516,28 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> >   	txq = netdev_get_tx_queue(vi->dev, index);
> >   	__netif_tx_lock(txq, raw_smp_processor_id());
> > +	virtqueue_disable_cb(sq->vq);
> >   	free_old_xmit_skbs(sq, true);
> > +
> > +	opaque = virtqueue_enable_cb_prepare(sq->vq);
> > +
> > +	done = napi_complete_done(napi, 0);
> > +
> > +	if (!done)
> > +		virtqueue_disable_cb(sq->vq);
> > +
> >   	__netif_tx_unlock(txq);
> > -	virtqueue_napi_complete(napi, sq->vq, 0);
> 
> 
> So I wonder why not simply move __netif_tx_unlock() after
> virtqueue_napi_complete()?
> 
> Thanks
> 


Because that calls tx poll which also takes tx lock internally ...


> > +	if (done) {
> > +		if (unlikely(virtqueue_poll(sq->vq, opaque))) {
> > +			if (napi_schedule_prep(napi)) {
> > +				__netif_tx_lock(txq, raw_smp_processor_id());
> > +				virtqueue_disable_cb(sq->vq);
> > +				__netif_tx_unlock(txq);
> > +				__napi_schedule(napi);
> > +			}
> > +		}
> > +	}
> >   	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
> >   		netif_tx_wake_queue(txq);

