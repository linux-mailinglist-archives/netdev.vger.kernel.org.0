Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87DF2E30DC
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 12:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgL0LLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 06:11:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33487 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbgL0LLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 06:11:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609067381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mMpHyCvuukTc4reZINDYlJOGEPebUzIz94UtOCDP/1Q=;
        b=PSh8d0C6iBLsuHbVohMmr54Iig6pxtDBiFWh6q0RAGc3B9kzB64p6CShSb+4ym7bM1fqlQ
        d5Pm1VaNmkV0xNAtLqOk5A/uvHqarXGC4Wo6vKOEP2+a7Y519FH33jt6C17bXP96kmnWL6
        aumq1fSAwsUPWeQZZcH+nobX+c42zsU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-nAT3ZUr6OHC9DDO-gxVktA-1; Sun, 27 Dec 2020 06:09:38 -0500
X-MC-Unique: nAT3ZUr6OHC9DDO-gxVktA-1
Received: by mail-wr1-f70.google.com with SMTP id g17so4961742wrr.11
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 03:09:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mMpHyCvuukTc4reZINDYlJOGEPebUzIz94UtOCDP/1Q=;
        b=CIdD1Bn8DVpCC2dE/aijz5XYng2cfU+C0V5Ei3EvpGvjBXHqZVvVbEC2SKJ31I0PzQ
         tX7iGGNbuCQrKq7AM5d9TmcsvhPjjKs0pjk7cAFNkm2qyPiAt8+Bu5lkPXkggBCjCUH5
         gvthfBbAsAnqpFcEqiietR7bFkEG4KHnZv6BxbCVraOmKfUOMZCo3xUaB+f3+W0CEKgi
         PSAWxctNtgVUn0QDrimQMDT/+hEd++RAuzUynlNzpttthvEwc++gnTvD6jUeRhqP1sYH
         bcJl2U0+sPjBU9h9Hqah69t4VqxG8nYO/ab8nRGgVUtgnBssWYD3C9jW+a09oMNO8uMl
         hOBw==
X-Gm-Message-State: AOAM533VRakZGJxJad1b/IwJJJCROpsDL+t1TnOVVuzaueMi2IAmi4uA
        vN4jJSbRGhMOk5vEAveTdbOISmmF244/27fnVQ1c6FaDWVVN861/zKqzeVoxySWzWxr2oosFKeM
        2Ayn3szTuP/zZgtT1
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr16269023wmf.134.1609067376927;
        Sun, 27 Dec 2020 03:09:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyblWot66nLLpG2MFt38HIgsgQZlTRFTn4rhCHII0+SK76t/5Yk/vOo9nlDECxlC8Axj8zo9A==
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr16269009wmf.134.1609067376770;
        Sun, 27 Dec 2020 03:09:36 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id u10sm14272328wmd.43.2020.12.27.03.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 03:09:35 -0800 (PST)
Date:   Sun, 27 Dec 2020 06:09:32 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Subject: Re: [PATCH net v5 2/2] vhost_net: fix tx queue stuck when sendmsg
 fails
Message-ID: <20201227060159-mutt-send-email-mst@kernel.org>
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
> 
> To fix this issue:
> 1. in the case of persistent failure (e.g bad packet), the driver
>    can skip this descriptor by ignoring the error.
> 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
>    the driver schedules the worker to try again.
> 
> Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")
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


Hmm, there's the case of link being temporarily down (e.g. for
reconfigure), which IIRC returns EIO.

It's also probably a good idea to keep unlikely(err < 0) around
and then just regular err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS
since that first test can be done faster.


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


same here

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

