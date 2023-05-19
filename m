Return-Path: <netdev+bounces-3936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3429F709A1E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5BB9281CA8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495C0C2CE;
	Fri, 19 May 2023 14:41:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5DA5670
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:41:58 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAFA1A7
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:41:55 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f42c865535so33641275e9.1
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1684507314; x=1687099314;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZPCIL09AOSqWQqhHIiNOjpVpg9ys42pH9qllL6EB20s=;
        b=KC0A8M82FSRL/w3Z+0G8RLwuRw/Qk03zulwBFRg3/hdqlst759Rz4XGxUIbHwWBC7E
         fMPl8XZyRJQsIKyw/Wa9pZh//XpMcpfcca39syIFkTwWy3zcy+z1hjLmIcnixYqg7jqB
         ly/61l24DfCGYwaUOmhDUGyMiE8YagWB24R+0fsepwW2SERyDUdFIer47xEM6hjEeKyL
         J99UuswxuJx7VDawy/YNH7aVF3Wp0dnruIPsleqsHFqbG3jNBk1D0JDa88HKiG7mcvW7
         JUrkvOcvMih8bgZznYc2dzP0syFcITerosfUuX3HSWiKW5q2rnPJxVdbadXUTcWCBRBd
         8jzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684507314; x=1687099314;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPCIL09AOSqWQqhHIiNOjpVpg9ys42pH9qllL6EB20s=;
        b=Wykbr+YQky4clccfeS6pTweE3hYSgC++WgFRo87ROpkSy4oSAmtkNVF7PAG7dHd8RE
         qFlx1b0VTwaDhkmexUiYzhwouNFUhqxWNEPJJczhUmyC7+B8Ml5WVb6Uf/yaXC5aUCJJ
         vN9lh0M4XQTFytR0tHveDJdSZAP2ArKcQ0Lt09AB8+s4BUH0djwjfamqE7hGaJQTuoxU
         G7OQBoX8ueY0PC79rGusB0d+FOUNKu3VdEIQw0D1YvbKUCshrB8pVeQ50xW+d44UpFcW
         ORlYICmdK5U38mooMqWACpxEVbM58+uPKzyJsLT4e8ywMYyrRF02VOlfwAGVUPZAgrOK
         4/Dg==
X-Gm-Message-State: AC+VfDwvZCGskfesEEPjgVrZ4M9lQatvZsc3lSXRk/ucYg2GrnD5SZao
	jVXk0eCYmu0XR+NzI2+Vfn/QNg==
X-Google-Smtp-Source: ACHHUZ6Fv1Pzw1Fi3QT/Y7/GISidkfYh+x+0jaaTg7mLE9TBRave9jZ25l6kp6Y5J2PrgmwFWrd8QQ==
X-Received: by 2002:a7b:cbc4:0:b0:3f4:21ff:b91f with SMTP id n4-20020a7bcbc4000000b003f421ffb91fmr1523271wmi.28.1684507314420;
        Fri, 19 May 2023 07:41:54 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m25-20020a7bcb99000000b003f195d540d9sm2638102wmi.14.2023.05.19.07.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 07:41:53 -0700 (PDT)
Message-ID: <4f72f65f-80de-6e15-b314-a4a5e4410d88@arista.com>
Date: Fri, 19 May 2023 15:41:51 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 3/3] crypto: cmac - Add support for cloning
To: Herbert Xu <herbert@gondor.apana.org.au>
References: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
 <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
Content-Language: en-US
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Dmitry Safonov <0x7f454c46@gmail.com>, Andy Lutomirski
 <luto@amacapital.net>, Ard Biesheuvel <ardb@kernel.org>,
 Bob Gilligan <gilligan@arista.com>, Dan Carpenter <error27@gmail.com>,
 David Laight <David.Laight@aculab.com>, Eric Biggers <ebiggers@kernel.org>,
 "Eric W. Biederman" <ebiederm@xmission.com>,
 Francesco Ruggeri <fruggeri05@gmail.com>, Ivan Delalande
 <colona@arista.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 Leonard Crestez <cdleonard@gmail.com>,
 Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
From: Dmitry Safonov <dima@arista.com>
In-Reply-To: <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Herbert,

Thanks for the patches!

On 5/19/23 09:28, Herbert Xu wrote:
> Allow hmac to be cloned.  The underlying cipher needs to support

Small nit ^cmac

> cloning by not having a cra_init function (all implementations of
> aes that do not require a fallback can be cloned).
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

I'll remove per-CPU request allocations and base version7 on this.

Thanks,
         Dmitry


