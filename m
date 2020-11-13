Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB5E2B1B35
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgKMMfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgKMMfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 07:35:34 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6DBC0613D1;
        Fri, 13 Nov 2020 04:35:34 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id j31so6486551qtb.8;
        Fri, 13 Nov 2020 04:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VKlKeJt6j/nd89hl/EdvrjFiwHbcFs5p36oJMPj3OLA=;
        b=jSHyDfTM+nkmOJFb6Qar7Urz3nLfaOtK4DGeCnk8qfQ3Fj+xnEh5j2QCOoYApqJKwA
         ZwNagcLgId9b7abZd7usvPky6UgCORYqURM5HQNktmDQzBb4B0o6ya8lF6OuumE6uMS9
         mrcxVclr2yr23hniN5Xrdc4frVQnb/n7f7Vvnx2+4rYK2cVJ/Glz6ZLraBSYHtFtBRCS
         uRWANcOI5y88sSMLg75D3Fg8dfh5c/6+Jl310uwTI/wHsgNd97ltgTG/kcGM4rMrPbke
         eV7Kibv334sqrqBZak0Kawx/ooOBAOXmQtMQZ8OhPJDpxinqLyGY2IZIm/eRU/pMrWBa
         4Stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VKlKeJt6j/nd89hl/EdvrjFiwHbcFs5p36oJMPj3OLA=;
        b=fk6FeM3jpwgndXf7bN3uAIl8lnbKl7Ty5n6z/E/XUppGCBREH/v0kIXLW1woH/kRTa
         Ro9OZns8VtCmDH+MJRWLrIooiMk+mH4mZFQ87FvvwweXc5Xb0iiUzGsU7ckfVWifRjK1
         bCPXs5Q1zdj48Alv6OXF/9utQ8WOT8dzniFl/sW0iUpN8Yog2HQPsrYLegmra7dRso5D
         TKdMIiY4yGJaKt6LgZiwSGsg4dwvP9pgvxMqoV92Bby6T2muardswMRjXrDdU3XmP4sM
         kI+B7kxyrtSDwxdPeCK1Ms6mrVOFRWn/EhYwPqzroIZKn5sLI+Zr6yoh1jV1CErbPgVV
         CmBg==
X-Gm-Message-State: AOAM530XlgJoLWZDlGkHOpnOhg8jRx2l9nbFzgDRdd8ZXNPSZbMNXfqe
        ObYUFz7EClvo9lBosyOlXTU=
X-Google-Smtp-Source: ABdhPJx5xluZ9NGeQOx5YFwjwX0lso3xymI79JSzCTvlDDzhIo5Gk9ApxDVoA4IUfNua16U1rXFGEQ==
X-Received: by 2002:ac8:734a:: with SMTP id q10mr1617926qtp.389.1605270933087;
        Fri, 13 Nov 2020 04:35:33 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:9364:c85c:d058:8418:f787])
        by smtp.gmail.com with ESMTPSA id p127sm6429215qkc.37.2020.11.13.04.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 04:35:32 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E24EBC2B35; Fri, 13 Nov 2020 09:35:29 -0300 (-03)
Date:   Fri, 13 Nov 2020 09:35:29 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net] sctp: change to hold/put transport for
 proto_unreach_timer
Message-ID: <20201113123529.GI3913@localhost.localdomain>
References: <7cb07ff74acd144f14a4467c7dddd12a940fbf52.1605259104.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cb07ff74acd144f14a4467c7dddd12a940fbf52.1605259104.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Nov 13, 2020 at 05:18:24PM +0800, Xin Long wrote:
...
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 813d307..0a51150 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -419,7 +419,7 @@ void sctp_generate_proto_unreach_event(struct timer_list *t)
>  		/* Try again later.  */
>  		if (!mod_timer(&transport->proto_unreach_timer,
>  				jiffies + (HZ/20)))
> -			sctp_association_hold(asoc);
> +			sctp_transport_hold(transport);
>  		goto out_unlock;
>  	}
>  

The chunk above covers the socket busy case, but for the normal cases
it also needs:

@@ -435,7 +435,7 @@ void sctp_generate_proto_unreach_event(struct timer_list *t)

 out_unlock:
        bh_unlock_sock(sk);
-       sctp_association_put(asoc);
+       sctp_transport_put(asoc);
 }

  /* Handle the timeout of the RE-CONFIG timer. */

> diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> index 806af58..60fcf31 100644
> --- a/net/sctp/transport.c
> +++ b/net/sctp/transport.c
> @@ -133,7 +133,7 @@ void sctp_transport_free(struct sctp_transport *transport)
>  
>  	/* Delete the ICMP proto unreachable timer if it's active. */
>  	if (del_timer(&transport->proto_unreach_timer))
> -		sctp_association_put(transport->asoc);
> +		sctp_transport_put(transport);
>  
>  	sctp_transport_put(transport);

Btw, quite noticeable on the above list of timers that only this timer
was using a reference on the asoc. Seems we're good now, then. :-)

  Marcelo
