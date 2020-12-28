Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AFB2E667D
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394223AbgL1QN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 11:13:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393505AbgL1QNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 11:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609171917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uvKCkMpLbJBEy4PbLRQSRYxBLiCodoQvuCZpQ8VRVZ4=;
        b=dh3JXaJ/tp9KLKSDrAAuMrV0DTYhV4QmPZo9M9DtLFZEBC3AbPbaDWaQJ9qzEX/LUQV6KR
        MImMyZB3WX2ZjL8w+lOMGc7VnfoppExpl8N5yG9f9+4almd3XkWB0Q/2iPsHJLKFfikMX6
        socBcFgg6YotCvrO9wZNc847L4ZyXdI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-BgaJolq4Nu2fnGRaVsqy5A-1; Mon, 28 Dec 2020 11:11:55 -0500
X-MC-Unique: BgaJolq4Nu2fnGRaVsqy5A-1
Received: by mail-wm1-f72.google.com with SMTP id u9so2608106wmj.1
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:11:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uvKCkMpLbJBEy4PbLRQSRYxBLiCodoQvuCZpQ8VRVZ4=;
        b=IM9vVfySK/HWQAKIRtxLtbAWDZNNDQW5sJWgsyLsgZ7pxeCEAOF2KHMb4UaMfkk0D1
         refbsCbirjC/x6iO/4uLMoiWF4fx0LBJzAdq81D3LXE2N9p/A599idv1aklCdffrsF2j
         /MHD+bBgeM8Ozz/7ntwKrTKyoU1HcuE0VdaKTvUeochs8mqntXu/MzMQ8yAPBDpaOMJn
         MIBCNwQo9agocsUfyFOpenM2OM8K0Tsbbz7EGHeJdXTiCHsDnEeTn5Nl4/xjFo+jnfBt
         v8Mr0SsvvmTQh+Uoypkx2AVKxJ7DL4/Vd2yekJBhU8C/Kr4PuRjzpthP9sag6hfOTP6S
         DS9g==
X-Gm-Message-State: AOAM533uq0/AGeukLhIRcrtBBUECHljYRX68+OcfbZ5ZrZ6FK2IaEMDI
        xy/X30SrgX+stQxyj2oTwM9k6jqGRHDq4p5blTP8YZmLfVtNmyz91UpNUy9advRcRUmzdSgGj42
        a7KjltctbcFLawvbd
X-Received: by 2002:a1c:7218:: with SMTP id n24mr21030858wmc.186.1609171914409;
        Mon, 28 Dec 2020 08:11:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyNOK/usBQvgTV6OkzrGuYREHCDYCUHLEQZiVe+l+R8T4qY+OyVyQWCp96GFBrHRx0AxH7vHQ==
X-Received: by 2002:a1c:7218:: with SMTP id n24mr21030845wmc.186.1609171914257;
        Mon, 28 Dec 2020 08:11:54 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id o124sm20561561wmb.5.2020.12.28.08.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 08:11:53 -0800 (PST)
Date:   Mon, 28 Dec 2020 11:11:50 -0500
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
Message-ID: <20201228111139-mutt-send-email-mst@kernel.org>
References: <1608881073-19004-1-git-send-email-wangyunjian@huawei.com>
 <20201227061916-mutt-send-email-mst@kernel.org>
 <34EFBCA9F01B0748BEB6B629CE643AE60DBA8C53@DGGEMM533-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34EFBCA9F01B0748BEB6B629CE643AE60DBA8C53@DGGEMM533-MBX.china.huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 01:27:42PM +0000, wangyunjian wrote:
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
> Do these two patches need to be sent separately?
> 
> Thanks

Makes sense to me.

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

