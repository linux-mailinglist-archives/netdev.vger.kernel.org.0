Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0622E30E6
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 12:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgL0LWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 06:22:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726031AbgL0LWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 06:22:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609068057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CVdBs2xrsrjmHICbemcVljFqnuHXxMjleLXoBb8vV18=;
        b=jSvl/bIKXHCDaT44zny+3yyV0hgnke5mos+3hdLKXZ1hFHDq4GiAArFnmj8+vLPlOBTSD/
        EZK15oNf1/xJJ+6MMlEPaQ+gLR8q9zMp6rQbsuD0QJZRn5NxuLttj30cqvl4RV+kLbKGhQ
        T+9gVz+2OzjUGCTFmqKnWugRM8nSxEQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-U6SFSMqGPl-HUSLSsdrJ1g-1; Sun, 27 Dec 2020 06:20:55 -0500
X-MC-Unique: U6SFSMqGPl-HUSLSsdrJ1g-1
Received: by mail-wr1-f69.google.com with SMTP id u3so4942506wri.19
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 03:20:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CVdBs2xrsrjmHICbemcVljFqnuHXxMjleLXoBb8vV18=;
        b=O/ofLZUITDaFpBi63uaNsGPx6f0mTWKs1N9IIHvEUHSz7DPo4GIY0s3GeW0Zje29fH
         EFrLaoX8us4/g44+OH6/+DtCQHQE4KkHzFwCuU5N3GSk8RFmqi17utwUF6ChGNuNzdyA
         AHDfJbgAKaOIBvti43XG576vl68BJL7Kha23eBqXK96gAeWesJiaNYJc8kTiubarZMp7
         SZ3NjLI815ggOzsnNCOzcLWDZIv908Mv8QJrIXlJVv2XHuB67F3tREF2a7V/4Mj1f0Zg
         p+JaI+Qpyey2H9ZNsEeiCezyKzBq5VwusiAh3rMgWH67ZT/fRAisvHBpmH1XkwK8FMgp
         YoQQ==
X-Gm-Message-State: AOAM533iVcv818K5ql+86BIFi0e9O5Lt0Z8o5/Zg5QotjrZKIzK8LtFI
        k5eOpiZ8H3IsC/Dj64Wz/xszDLYcp3e/ao8LcaIzTAf0kEIgHSgSkjBWCXhCYNcghRZDoKdFWKy
        h25q6VS+Urno4MlIw
X-Received: by 2002:a1c:b608:: with SMTP id g8mr16204743wmf.110.1609068054000;
        Sun, 27 Dec 2020 03:20:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUzl/++4UPXggZtiDjmqg147nueL0wrgEoGxCli7YzJPIkDWw1Vh9nmJu4PWjnGgqGQ5LTkg==
X-Received: by 2002:a1c:b608:: with SMTP id g8mr16204729wmf.110.1609068053804;
        Sun, 27 Dec 2020 03:20:53 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id q143sm15618150wme.28.2020.12.27.03.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 03:20:53 -0800 (PST)
Date:   Sun, 27 Dec 2020 06:20:50 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Subject: Re: [PATCH net v5 2/2] vhost_net: fix tx queue stuck when sendmsg
 fails
Message-ID: <20201227061916-mutt-send-email-mst@kernel.org>
References: <1608881073-19004-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608881073-19004-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 25, 2020 at 03:24:33PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently the driver doesn't drop a packet which can't be sent by tun
> (e.g bad packet). In this case, the driver will always process the
> same packet lead to the tx queue stuck.

So not making progress on a bad packet has some advantages,
e.g. this is easier to debug.
When is it important to drop the packet and continue?


> To fix this issue:
> 1. in the case of persistent failure (e.g bad packet), the driver
>    can skip this descriptor by ignoring the error.
> 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
>    the driver schedules the worker to try again.
> 
> Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")

I'd just drop this tag, looks more like a feature than a bug ...


> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/vhost/net.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index c8784dfafdd7..01558fb2c552 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -827,14 +827,13 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  				msg.msg_flags &= ~MSG_MORE;
>  		}
>  
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>  		err = sock->ops->sendmsg(sock, &msg, len);
> -		if (unlikely(err < 0)) {
> +		if (unlikely(err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS)) {
>  			vhost_discard_vq_desc(vq, 1);
>  			vhost_net_enable_vq(net, vq);
>  			break;
>  		}
> -		if (err != len)
> +		if (err >= 0 && err != len)
>  			pr_debug("Truncated TX packet: len %d != %zd\n",
>  				 err, len);
>  done:
> @@ -922,7 +921,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  			msg.msg_flags &= ~MSG_MORE;
>  		}
>  
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>  		err = sock->ops->sendmsg(sock, &msg, len);
>  		if (unlikely(err < 0)) {
>  			if (zcopy_used) {
> @@ -931,11 +929,13 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>  					% UIO_MAXIOV;
>  			}
> -			vhost_discard_vq_desc(vq, 1);
> -			vhost_net_enable_vq(net, vq);
> -			break;
> +			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> +				vhost_discard_vq_desc(vq, 1);
> +				vhost_net_enable_vq(net, vq);
> +				break;
> +			}
>  		}
> -		if (err != len)
> +		if (err >= 0 && err != len)
>  			pr_debug("Truncated TX packet: "
>  				 " len %d != %zd\n", err, len);
>  		if (!zcopy_used)
> -- 
> 2.23.0

