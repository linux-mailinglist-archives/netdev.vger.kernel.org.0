Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7592583FA8
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbiG1NLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239072AbiG1NLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:11:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC8F62BDE
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659013870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Peb1snEEyClrr7SAXY+3h09rG7Cc4NL+stHh6RtUqlg=;
        b=Ur2jWaWTaVg30BLhUhgdAkIcJz64UhH9QiDjbVBTXS7Wcb3vcsBidVMWaNhdXRkxZuMGUG
        e4Ib68JwPm8Bm5yX1zU/dVmOWzIieNOpJzJXdfol2ruwmoAFA9/HvwJcTnSeWXFLURZDn/
        317GGgzbSZwqT+aLqmZETUBZeN5fy/E=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-a3mBClbVNO6UoP7SPQHx2Q-1; Thu, 28 Jul 2022 09:11:09 -0400
X-MC-Unique: a3mBClbVNO6UoP7SPQHx2Q-1
Received: by mail-qv1-f70.google.com with SMTP id lt16-20020a056214571000b004740647f736so1281517qvb.14
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Peb1snEEyClrr7SAXY+3h09rG7Cc4NL+stHh6RtUqlg=;
        b=XZwmZ8SIrRAVNN1qQ8pClDXsClsYbLtohpYobU86uoByy16er+DPBhbv8WnDRJTA8b
         UtpLGyVj79ILPHV3x65dSqIlpt3Jc5aJd1osqjM2KyeqmJ3vufVxweVvrR0BOCGlVlqd
         HJu60gYbyhcmjv6vuN0s/mcamQgt7FSn5soa7LlQiMpldJwyYR9/E3o7NMj8sm2SKYC5
         cKVpOd8Rel1rE35Te9Cqt64+arYhV5hAnS2lgISowPPrYe9JoGLL/ZEhMnOc+BtWBa/X
         N8fxuDiUh4yuym1A5T1i/d7bgmTpV8ukYdw5AGrucLlcyqPyREVh5qBObuPR2enSmHS8
         3Ssw==
X-Gm-Message-State: AJIora8XiwIeO39211LC12+Y4vEnzd6BjlB+vfOsk8x+vuqdxEkrHacr
        3Isdu0LyplO6IqrjBXjCWkWApjIwRSzEXIT1xByvHc3xxDtYdk1lRei6u94KFnoZ7zjjecgXY9a
        4vdOhgHbny/cmXc/0
X-Received: by 2002:a05:622a:5c9:b0:31e:ebfa:f192 with SMTP id d9-20020a05622a05c900b0031eebfaf192mr22600191qtb.263.1659013869033;
        Thu, 28 Jul 2022 06:11:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uUGwnkUKAlkb5w7dfKwrYi+F9K3MAAR2oHcQcjWq9dcxCgUGRM2/5AUT0TVb6HvPZP43W81Q==
X-Received: by 2002:a05:622a:5c9:b0:31e:ebfa:f192 with SMTP id d9-20020a05622a05c900b0031eebfaf192mr22600156qtb.263.1659013868626;
        Thu, 28 Jul 2022 06:11:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id t14-20020a37ea0e000000b006b58fce19dasm529103qkj.20.2022.07.28.06.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:11:08 -0700 (PDT)
Message-ID: <e63e6fc511d9d515fcb8501f48f218192f36afd3.camel@redhat.com>
Subject: Re: [PATCH] dn_route: use time_is_before_jiffies(a) to replace
 "jiffies - a > 0"
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yu Zhe <yuzhe@nfschina.com>, davem@davemloft.net, kuba@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        liqiong@nfschina.com
Date:   Thu, 28 Jul 2022 15:11:04 +0200
In-Reply-To: <20220727024600.18413-1-yuzhe@nfschina.com>
References: <20220727024600.18413-1-yuzhe@nfschina.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-07-27 at 10:46 +0800, Yu Zhe wrote:
> time_is_before_jiffies deals with timer wrapping correctly.
> 
> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
> ---
>  net/decnet/dn_route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
> index 552a53f1d5d0..0a4bed0bc2e3 100644
> --- a/net/decnet/dn_route.c
> +++ b/net/decnet/dn_route.c
> @@ -201,7 +201,7 @@ static void dn_dst_check_expire(struct timer_list *unused)
>  		}
>  		spin_unlock(&dn_rt_hash_table[i].lock);
>  
> -		if ((jiffies - now) > 0)
> +		if (time_is_before_jiffies(now))

Uhmm... it looks like the wrap-around condition can happen only in
theory: 'now' is initialized just before entering this loop, and we
will break as soon as jiffies increment. The wrap-around could happen
only if a single iteration of the loop takes more than LONG_MAX
jiffies.

If that happens, we have a completely different kind of much more
serious problem, I think ;)

So this change is mostly for core readability's sake. I personally find
more readable:

		if (jiffies != now)

Cheers,

Paolo

p.s. given the above I guess this is for the net-next tree, right?

