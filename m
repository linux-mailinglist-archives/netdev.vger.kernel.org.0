Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AB12E3718
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 13:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgL1MVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 07:21:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727234AbgL1MVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 07:21:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609157991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BFLa7/fMJxMD+hmxL9RGelfjAN9ACxv2rYzNAsWqtCs=;
        b=Qzpx0fZwNRHY8kZICyZI1gDq6pi2Ig4H2IPIAEgQRhuZW9mnfcaJlSYiEsTYZdKnpV/jy/
        5vcA+/WDIVX+8gfrVdcnD2XekRc3YgHmNMqQ7mY9vQP2828MlpxWcTKtvZhe+OSRCqwd2d
        Y3XEbSGH3UvHHiefPerKbjTrAOx/4V0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-1CFdN_0bPrm9hfOcSZhe3Q-1; Mon, 28 Dec 2020 07:19:50 -0500
X-MC-Unique: 1CFdN_0bPrm9hfOcSZhe3Q-1
Received: by mail-wr1-f69.google.com with SMTP id w5so6278834wrl.9
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 04:19:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BFLa7/fMJxMD+hmxL9RGelfjAN9ACxv2rYzNAsWqtCs=;
        b=Rte7Ojff3As3zlrCofvK/y3tzCUldBN4nf2HhLraA+EFYryFH0+Q7bNIfR+Z3MuXMU
         qzkNd8117HNo/zTaqqQ/xnfpWAcVh+2CqCiRB1km2j3EVcfI9po/BWtH5yAtTwhmho+z
         wI6K8lXmdDj3wNOIND2dxWp3CR50eCCyjOgFOYKNQ1a5VjUU+eyr+VDDA7YQh9C6tK+g
         FeskguVFTvQMVEeSGiYk9cKH/oDZZuBtOiDpnQusgWa/dgAhebEQ7SBkOHNdm/1xYLkT
         XxzQyCYexUHiA3/XHuhdRqtLzGcPbHtr3KJ7MlUABNL6t6faX3LnFVn/p9ddJAcaTb1c
         JgDQ==
X-Gm-Message-State: AOAM531gN1/E+MFXbwSfO4ndFwD1p4ZXeRg0+XRSM78XVs48Exx3uyrT
        vC3DB4bW245186ssJ2YGF2BTjjKSmUox2WGOy1b2dQPkCWHxMSmW4Lq1iJ5kBVz7MMVwvX4Csna
        bLdnX4A6GcGtgUGiw
X-Received: by 2002:adf:9546:: with SMTP id 64mr51864092wrs.343.1609157989160;
        Mon, 28 Dec 2020 04:19:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQuAj8JtF1rda3DQCqKrOZND9lbHxggLWIfd1KjoHhcs91SFpo39C2HjpJzys8kW5RxrTRng==
X-Received: by 2002:adf:9546:: with SMTP id 64mr51864079wrs.343.1609157989021;
        Mon, 28 Dec 2020 04:19:49 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id h3sm20098736wmm.4.2020.12.28.04.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 04:19:47 -0800 (PST)
Date:   Mon, 28 Dec 2020 07:19:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Subject: Re: [PATCH net v5 2/2] vhost_net: fix tx queue stuck when sendmsg
 fails
Message-ID: <20201228071824-mutt-send-email-mst@kernel.org>
References: <1608881073-19004-1-git-send-email-wangyunjian@huawei.com>
 <20201227061916-mutt-send-email-mst@kernel.org>
 <34EFBCA9F01B0748BEB6B629CE643AE60DBA7B3C@DGGEMM533-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34EFBCA9F01B0748BEB6B629CE643AE60DBA7B3C@DGGEMM533-MBX.china.huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 11:55:36AM +0000, wangyunjian wrote:
> > -----Original Message-----
> > From: Michael S. Tsirkin [mailto:mst@redhat.com]
> > Sent: Sunday, December 27, 2020 7:21 PM
> > To: wangyunjian <wangyunjian@huawei.com>
> > Cc: netdev@vger.kernel.org; jasowang@redhat.com;
> > willemdebruijn.kernel@gmail.com; virtualization@lists.linux-foundation.org;
> > Lilijun (Jerry) <jerry.lilijun@huawei.com>; chenchanghu
> > <chenchanghu@huawei.com>; xudingke <xudingke@huawei.com>; huangbin (J)
> > <brian.huangbin@huawei.com>
> > Subject: Re: [PATCH net v5 2/2] vhost_net: fix tx queue stuck when sendmsg
> > fails
> > 
> > On Fri, Dec 25, 2020 at 03:24:33PM +0800, wangyunjian wrote:
> > > From: Yunjian Wang <wangyunjian@huawei.com>
> > >
> > > Currently the driver doesn't drop a packet which can't be sent by tun
> > > (e.g bad packet). In this case, the driver will always process the
> > > same packet lead to the tx queue stuck.
> > 
> > So not making progress on a bad packet has some advantages, e.g. this is
> > easier to debug.
> > When is it important to drop the packet and continue?
> 
> In the case, the VM will not be able to send packets persistently. Services of VM
> are affected.
> 
> Thanks


Well VM can always harm itself right? Just halt the CPU, services will
be affected ;)


> > 
> > 
> > > To fix this issue:
> > > 1. in the case of persistent failure (e.g bad packet), the driver
> > >    can skip this descriptor by ignoring the error.
> > > 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
> > >    the driver schedules the worker to try again.
> > >
> > > Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")
> > 
> > I'd just drop this tag, looks more like a feature than a bug ...
> 
> OK
> 
> > 
> > 
> > > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > > Acked-by: Willem de Bruijn <willemb@google.com>
> > > ---
> > >  drivers/vhost/net.c | 16 ++++++++--------
> > >  1 file changed, 8 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c index
> > > c8784dfafdd7..01558fb2c552 100644
> > > --- a/drivers/vhost/net.c
> > > +++ b/drivers/vhost/net.c
> > > @@ -827,14 +827,13 @@ static void handle_tx_copy(struct vhost_net *net,
> > struct socket *sock)
> > >  				msg.msg_flags &= ~MSG_MORE;
> > >  		}
> > >
> > > -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
> > >  		err = sock->ops->sendmsg(sock, &msg, len);
> > > -		if (unlikely(err < 0)) {
> > > +		if (unlikely(err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS))
> > > +{
> > >  			vhost_discard_vq_desc(vq, 1);
> > >  			vhost_net_enable_vq(net, vq);
> > >  			break;
> > >  		}
> > > -		if (err != len)
> > > +		if (err >= 0 && err != len)
> > >  			pr_debug("Truncated TX packet: len %d != %zd\n",
> > >  				 err, len);
> > >  done:
> > > @@ -922,7 +921,6 @@ static void handle_tx_zerocopy(struct vhost_net
> > *net, struct socket *sock)
> > >  			msg.msg_flags &= ~MSG_MORE;
> > >  		}
> > >
> > > -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
> > >  		err = sock->ops->sendmsg(sock, &msg, len);
> > >  		if (unlikely(err < 0)) {
> > >  			if (zcopy_used) {
> > > @@ -931,11 +929,13 @@ static void handle_tx_zerocopy(struct vhost_net
> > *net, struct socket *sock)
> > >  				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
> > >  					% UIO_MAXIOV;
> > >  			}
> > > -			vhost_discard_vq_desc(vq, 1);
> > > -			vhost_net_enable_vq(net, vq);
> > > -			break;
> > > +			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> > > +				vhost_discard_vq_desc(vq, 1);
> > > +				vhost_net_enable_vq(net, vq);
> > > +				break;
> > > +			}
> > >  		}
> > > -		if (err != len)
> > > +		if (err >= 0 && err != len)
> > >  			pr_debug("Truncated TX packet: "
> > >  				 " len %d != %zd\n", err, len);
> > >  		if (!zcopy_used)
> > > --
> > > 2.23.0

