Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B208A2B43E5
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 13:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgKPMmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 07:42:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726598AbgKPMmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 07:42:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605530569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ebTze6DX+bt9ao6H/89yHeOnEFANqz0oC2+q+FvQf/4=;
        b=OgrOPH8IOs4DWTuyxIbebon/7SAT9rUfoqLuOtgj5dXNezjBB1Ch+1LN+2IrxLZu3lLb+m
        USCBr/VCaMirS117CLyAGXzvtZFwVkvcfZu5QOiUZJPpiYTqQocKVKzjy76+aISjVFRC/1
        W5rKZ3yszADd/nknW/d+Oq3FYGo9LQE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-S_wHj3GDM1mxp4ui5L5nFA-1; Mon, 16 Nov 2020 07:42:47 -0500
X-MC-Unique: S_wHj3GDM1mxp4ui5L5nFA-1
Received: by mail-wr1-f71.google.com with SMTP id z7so9831696wrl.14
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 04:42:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ebTze6DX+bt9ao6H/89yHeOnEFANqz0oC2+q+FvQf/4=;
        b=WiLgMjy7CMBH1IxQPR64+n8DnbnBY9cX1YMImW4og0/MDv+BydqdA5fSL0XOgcGwTj
         PV34yWM3dKZluJG8ppstIm6ZZQosnRyenzSD4FV8Mlu7JBvzbQZ3HIEple++lONUhx9n
         qOIYzyFgrpA+ONrQOj/P0tE6DYySIxRZUllNW7g6UeD+rLKhKrq6KfTXeiiwnCPaDM5B
         6VaOPSTzjaYIz2e04cnGOXkyNeRS70WFHQpKduqrkgiBvcc3ztf86fysyHPP4RUxvA6f
         XONbh+UFtC+gyACuUDNcmJR5jIDkm3jWslbSZflAX5ZzhFrTqL2AJxI0BMpvJXS5etfd
         tSUQ==
X-Gm-Message-State: AOAM532fgLdMEKPrsJ7AQuAa5Qxb/7GMvjnl6fR7CVe1QEsRiz0YLRT2
        foHipH86XhbJPLJfyxtBdz6c+UHU7/jWGDzfZ0GYWiBprF2C6cJDeQTFR9N+B3Z9Bypt4BLHApy
        +/MeZ1d3N0lvv2SZX
X-Received: by 2002:adf:cd8d:: with SMTP id q13mr19546280wrj.61.1605530566741;
        Mon, 16 Nov 2020 04:42:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvLNvqw2PCiGnQ/AnYIf9wyKk6yla1iwqBK5/HgTes54MIdQk05hIzkeOYR0tQ+cjEhCV+5Q==
X-Received: by 2002:adf:cd8d:: with SMTP id q13mr19546248wrj.61.1605530566524;
        Mon, 16 Nov 2020 04:42:46 -0800 (PST)
Received: from redhat.com ([147.161.8.56])
        by smtp.gmail.com with ESMTPSA id w21sm19377559wmi.29.2020.11.16.04.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 04:42:45 -0800 (PST)
Date:   Mon, 16 Nov 2020 07:42:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        intel-wired-lan@lists.osuosl.org, netanel@amazon.com,
        akiyano@amazon.com, michael.chan@broadcom.com,
        sgoutham@marvell.com, ioana.ciornei@nxp.com,
        ruxandra.radulescu@nxp.com, thomas.petazzoni@bootlin.com,
        mcroce@microsoft.com, saeedm@nvidia.com, tariqt@nvidia.com,
        aelior@marvell.com, ecree@solarflare.com,
        ilias.apalodimas@linaro.org, grygorii.strashko@ti.com,
        sthemmin@microsoft.com, kda@linux-powerpc.org
Subject: Re: [PATCH bpf-next v2 06/10] xsk: propagate napi_id to XDP socket
 Rx path
Message-ID: <20201116073848-mutt-send-email-mst@kernel.org>
References: <20201116110416.10719-1-bjorn.topel@gmail.com>
 <20201116110416.10719-7-bjorn.topel@gmail.com>
 <20201116064953-mutt-send-email-mst@kernel.org>
 <614a7ce4-2b6b-129b-de7d-71428f7a71f6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <614a7ce4-2b6b-129b-de7d-71428f7a71f6@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 01:01:40PM +0100, Bj�rn T�pel wrote:
> 
> On 2020-11-16 12:55, Michael S. Tsirkin wrote:
> > On Mon, Nov 16, 2020 at 12:04:12PM +0100, Björn Töpel wrote:
> > > From: Björn Töpel <bjorn.topel@intel.com>
> > > 
> > > Add napi_id to the xdp_rxq_info structure, and make sure the XDP
> > > socket pick up the napi_id in the Rx path. The napi_id is used to find
> > > the corresponding NAPI structure for socket busy polling.
> > > 
> > > Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > > Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> > 
> > A bunch of drivers just pass in 0. could you explain when
> > is that ok? how bad is it if the wrong id is used?
> > 
> 
> If zero is passed, which is a non-valid NAPI_ID, busy-polling will never
> be performed.
> 
> Depending on the structure of the driver, napi might or might not be
> initialized (napi_id != 0) or even available. When it wasn't obvious, I
> simply set it to zero.
> 
> So, short; No harm if zero, but busy-polling cannot be used in an XDP
> context.
> 
> 
> [...]
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 21b71148c532..d71fe41595b7 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1485,7 +1485,7 @@ static int virtnet_open(struct net_device *dev)
> > >   			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
> > >   				schedule_delayed_work(&vi->refill, 0);
> > > -		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i);
> > > +		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, 0);
> > >   		if (err < 0)
> > >   			return err;
> > 
> > Should this be rq.napi.napi_id ?
> > 
> 
> Yes, if rq.napi.napi_id is valid here! Is it?

What initializes it? netif_napi_add? Then I think yes, it's
initialized for all queues ...
Needs to be tested naturally.

> 
> Cheers,
> Bj�rn

