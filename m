Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D152FB8CC
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394725AbhASNsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:48:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30432 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731459AbhASJ5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 04:57:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611050134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e5k+Bd6G3jBkGotE4e2JJUwLMC9njtVsJGU8frM5Op4=;
        b=cCl2UF+SvCbVcLo53Xcru9dUIIeaYTzZIJQGi9J3xonVDnJw091iOqDXsUEcon+k1+QGra
        b8Mr+4l90jfuzEn/7Oi3tab3GSuOQsPPFgJZW02KtJpN+UImNhny1epIGZ8hN37DgYooSZ
        7VjBUSUP0c4JYW7tc3DjhhBD2s9OQjg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-al8kGxPCPbiVpa4HX4H7DQ-1; Tue, 19 Jan 2021 04:55:32 -0500
X-MC-Unique: al8kGxPCPbiVpa4HX4H7DQ-1
Received: by mail-wr1-f72.google.com with SMTP id o17so9648778wra.8
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 01:55:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e5k+Bd6G3jBkGotE4e2JJUwLMC9njtVsJGU8frM5Op4=;
        b=YGZ6UvfFLntl13HLPd7QcbbO0Rzn3yAKzjJnKlNtKnctSzSi9uRtD9wk+AWMsddyn/
         i1F/N/PrKNbPGp9lsiAnykVzn9isgiQKghEqX0h3Ab1vDdBNuyzicdtwdxyBS2FH6Tfb
         vZpOuRSAYWmMzP0lRslRkEK5ftc25NM7XgiLZH+d0eh7Mhpl3a6znMnqfe5pJewKm0s3
         tte4phMQplRB6w8PrP5uo8r/kmLjp0O8eIfq2OVwQMyjUsXrKPfdEcRaLwAELXxsKvb3
         m8hAsNP2xXah54I1zNFth8ZDn+fgzDuc8NL2yxWtp0bdL4pi74AKNIHEiAcgqhPUwtzc
         96lg==
X-Gm-Message-State: AOAM533imlq7RzUf6w/0qw9DWLxkJzAXBTt7yjqR8Th4mBBtStyIXLMV
        sT0NySlfxAiHsR/QLD78nod3rFupf4MsYEzNxs3lB6p8WQ36hl/dKwqs5xx/hENSy2/bjjwoaNU
        fgBVErLgkZuxgIm2W
X-Received: by 2002:a05:600c:21cb:: with SMTP id x11mr3323290wmj.29.1611050131103;
        Tue, 19 Jan 2021 01:55:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKND6Zca35zFaKj21qvuworTdTNrBW2UVMdAEyN6/1tBZVNe5H5LJNjKLvAzdn+brbuTjaAw==
X-Received: by 2002:a05:600c:21cb:: with SMTP id x11mr3323275wmj.29.1611050130907;
        Tue, 19 Jan 2021 01:55:30 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id h14sm34416111wrx.37.2021.01.19.01.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 01:55:30 -0800 (PST)
Date:   Tue, 19 Jan 2021 04:55:27 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Subject: Re: [PATCH net-next v7] vhost_net: avoid tx queue stuck when sendmsg
 fails
Message-ID: <20210119045414-mutt-send-email-mst@kernel.org>
References: <1610685980-38608-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610685980-38608-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 12:46:20PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently the driver doesn't drop a packet which can't be sent by tun
> (e.g bad packet). In this case, the driver will always process the
> same packet lead to the tx queue stuck.
> 
> To fix this issue:
> 1. in the case of persistent failure (e.g bad packet), the driver
>    can skip this descriptor by ignoring the error.
> 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
>    the driver schedules the worker to try again.
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> v7:
>    * code rebase
> v6:
>    * update code styles and commit log
> ---
>  drivers/vhost/net.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 3b744031ec8f..df82b124170e 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -828,14 +828,15 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  				msg.msg_flags &= ~MSG_MORE;
>  		}
>  
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>  		err = sock->ops->sendmsg(sock, &msg, len);
>  		if (unlikely(err < 0)) {
> -			vhost_discard_vq_desc(vq, 1);
> -			vhost_net_enable_vq(net, vq);
> -			break;
> -		}
> -		if (err != len)
> +			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> +				vhost_discard_vq_desc(vq, 1);
> +				vhost_net_enable_vq(net, vq);
> +				break;
> +			}
> +			pr_debug("Fail to send packet: err %d", err);
> +		} else if (unlikely(err != len))
>  			pr_debug("Truncated TX packet: len %d != %zd\n",
>  				 err, len);
>  done:
> @@ -924,7 +925,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  			msg.msg_flags &= ~MSG_MORE;
>  		}
>  
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>  		err = sock->ops->sendmsg(sock, &msg, len);
>  		if (unlikely(err < 0)) {
>  			if (zcopy_used) {
> @@ -933,11 +933,13 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>  					% UIO_MAXIOV;
>  			}
> -			vhost_discard_vq_desc(vq, 1);
> -			vhost_net_enable_vq(net, vq);
> -			break;
> -		}
> -		if (err != len)
> +			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> +				vhost_discard_vq_desc(vq, 1);
> +				vhost_net_enable_vq(net, vq);
> +				break;
> +			}
> +			pr_debug("Fail to send packet: err %d", err);
> +		} else if (unlikely(err != len))
>  			pr_debug("Truncated TX packet: "
>  				 " len %d != %zd\n", err, len);
>  		if (!zcopy_used)
> -- 
> 2.23.0

