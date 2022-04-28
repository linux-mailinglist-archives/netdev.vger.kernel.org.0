Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF60513653
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiD1OJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbiD1OIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:08:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C583B6454
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 07:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651154699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OxHoR1XOD4W/IjvJCT93NhYkY3XViy+vGcO5L5iVNbQ=;
        b=KAkmA9Q1Mz5OC5goCYx+DINBdTx5eVjykNbjdnhB+aIhuVzjtab89mUbs/ymZ+riaBRwjS
        RT5pwZGVp8GOvIj44VtVF38KxskA50dBglk6M5bIS52wSY/OJPi9ZRy7oQzbsWC63bQ/JN
        uUdMnlkWF+Ke7FqXzSb9CC1JS/O44z0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-kgpRoQ5ROf2mIesaW5dG8w-1; Thu, 28 Apr 2022 10:04:44 -0400
X-MC-Unique: kgpRoQ5ROf2mIesaW5dG8w-1
Received: by mail-wm1-f71.google.com with SMTP id bh11-20020a05600c3d0b00b003928fe7ba07so1583411wmb.6
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 07:04:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OxHoR1XOD4W/IjvJCT93NhYkY3XViy+vGcO5L5iVNbQ=;
        b=Cefrxq48YMnrcd7G1yxmET5k2UZcl6nzRBJ6/YwW0DdCG7yxtx7DFsFrctHtglfdfn
         5qxf6XmKkXSF0ld4J085fXTp3F1GVUwbmXUm39zn3wNeSYfN5mofCWRTKu7NKowzwAtg
         uNsSZFGE+C7GnVNhg2cvDzSY3vN8QtNXKdooFxbtxX4YalsrlMlJRw0+joUzt2icjUTR
         KFPgncTaFXEbG+wZCLsOuMVuUEpT29Of6Ss4eJhlLdekQwm/vjsiZ3qTeEmsYmUiyg3P
         3SYEhzOTH4AAUg7M2BQ3qwjYdrXQUfidQQTYo7IRZmxd6T4m6ya5qPUWtNGFhROS6PCM
         KcxA==
X-Gm-Message-State: AOAM531CdVqBv0HnFT1Zu3THvr8p6GjX8tC+yDZyvRsS/PTnDxIfCiWP
        3EEWQSRCepzkzlkxdh9ijbsMYvr9YUSVP3kdwgrffFv1LgWandz76v9hW6P4sCbpKBPE9ZrcxQt
        xsD+k6EipbN3cY1XU
X-Received: by 2002:a05:6000:144e:b0:20c:3f58:2eaf with SMTP id v14-20020a056000144e00b0020c3f582eafmr1663782wrx.583.1651154683344;
        Thu, 28 Apr 2022 07:04:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9tN3o+GX1JK7xNAAZhBEzcb+Yy+SWq58NQSOnRbLIZaHQMca/yzpkdCnhavJwuHVmm3rAPQ==
X-Received: by 2002:a05:6000:144e:b0:20c:3f58:2eaf with SMTP id v14-20020a056000144e00b0020c3f582eafmr1663766wrx.583.1651154683093;
        Thu, 28 Apr 2022 07:04:43 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-13.dyn.eolo.it. [146.241.96.13])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c3b9000b0039411b2e96fsm1521278wms.30.2022.04.28.07.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:04:42 -0700 (PDT)
Message-ID: <ffc7a45e9c77303b47bf2faaf3498ed8a3c1ab1a.camel@redhat.com>
Subject: Re: [PATCH net-next 01/11] ipv6: optimise ipcm6 cookie init
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Date:   Thu, 28 Apr 2022 16:04:41 +0200
In-Reply-To: <64341db6ca5a1f4d1eebbe86a7ee0b7d7400335e.1651071843.git.asml.silence@gmail.com>
References: <cover.1651071843.git.asml.silence@gmail.com>
         <64341db6ca5a1f4d1eebbe86a7ee0b7d7400335e.1651071843.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-04-28 at 11:56 +0100, Pavel Begunkov wrote:
> Users of ipcm6_init() have a somewhat complex post initialisation
> of ->dontfrag and ->tclass. Not only it adds additional overhead,
> but also complicates the code.
> 
> First, replace ipcm6_init() with ipcm6_init_sk(). As it might be not an
> equivalent change, let's first look at ->dontfrag. The logic was to set
> it from cmsg if specified and otherwise fallback to np->dontfrag. Now
> it's initialising to np->dontfrag in the beginning and then potentially
> overriding with cmsg, which is absolutely the same behaviour.
> 
> It's a bit more complex with ->tclass as ip6_datagram_send_ctl() might
> set it to -1, which is a default and not valid value. The solution
> here is to skip -1's specified in cmsg, so it'll be left with the socket
> default value getting us to the old behaviour.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/net/ipv6.h    | 9 ---------
>  net/ipv6/datagram.c   | 4 ++--
>  net/ipv6/ip6_output.c | 2 --
>  net/ipv6/raw.c        | 8 +-------
>  net/ipv6/udp.c        | 7 +------
>  net/l2tp/l2tp_ip6.c   | 8 +-------
>  6 files changed, 5 insertions(+), 33 deletions(-)
> 
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index 213612f1680c..30a3447e34b4 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -352,15 +352,6 @@ struct ipcm6_cookie {
>  	struct ipv6_txoptions *opt;
>  };
>  
> -static inline void ipcm6_init(struct ipcm6_cookie *ipc6)
> -{
> -	*ipc6 = (struct ipcm6_cookie) {
> -		.hlimit = -1,
> -		.tclass = -1,
> -		.dontfrag = -1,
> -	};
> -}
> -
>  static inline void ipcm6_init_sk(struct ipcm6_cookie *ipc6,
>  				 const struct ipv6_pinfo *np)
>  {
> diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> index 206f66310a88..1b334bc855ae 100644
> --- a/net/ipv6/datagram.c
> +++ b/net/ipv6/datagram.c
> @@ -1003,9 +1003,9 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
>  			if (tc < -1 || tc > 0xff)
>  				goto exit_f;
>  
> +			if (tc != -1)
> +				ipc6->tclass = tc;
>  			err = 0;
> -			ipc6->tclass = tc;
> -
>  			break;
>  		    }

It looks like the above causes a behavioral change: before this patch
cmsg took precedence on socket status, after this patch looks like it's
the opposide.

Am I missing something?

Thanks

Paolo

