Return-Path: <netdev+bounces-3354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 187077068EB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:09:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A6F11C20E1A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E145D156D9;
	Wed, 17 May 2023 13:09:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CB318B0D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 13:09:42 +0000 (UTC)
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7091D10E;
	Wed, 17 May 2023 06:09:41 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f22908a082so958212e87.1;
        Wed, 17 May 2023 06:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684328980; x=1686920980;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HiOIFsakx0aMej54eXXoxdRm1SObTd8+GXwcqmC+gDI=;
        b=nQqbckCj40fswXyyoyZANlw32GoODASyRy+I0BEcH8jVTq+9CS8dZsi7KJnYXhUTMu
         T8gm0LELievGmm4DCn0L08Kr+seIoYQuhmH8JJFTb5+4j6v4xFyLpxB3yTdEjB0Uy3Z2
         Pz+zfFv6OWCLZRHo9un5cb4wBQOORGnQ33+GIOY5AyrE1ifnChl7DYc9slDOBybRZmZg
         gCbAeQs15epFThbzR9IlcsDHkEefxmLFxEiAiXvGYvT/RUtOtgRTr8WUlkLx3IalVvtz
         z9gRDvbnTAyhsrgTWhFfApJBf27hSb1sAmfTC4SgGMe2CSQXRh48XoQzExndoLzjP4ca
         NMjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684328980; x=1686920980;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HiOIFsakx0aMej54eXXoxdRm1SObTd8+GXwcqmC+gDI=;
        b=QnY+/zJEti03r0OVFFIInlLbaGUJpcvz4cOhzE5iEKmP6Zi1vYDedadge2bSDVCbyt
         QNroOSL4L1d26pbt9xbtFK+LAMyeU/CBrnv72FqylAt87xktVtAdw7Z7WtH5fjd5R8Py
         H8ffTBtp1A/1Q9bvxZPZBYX3VO7xDqSb8omu7UktBNR8vPLibguLpcFCYFrBcUCUmhtr
         QQNZFA7nmPeyrNhvB179+WBiwXVaH1KrlYs2wZyqMeN8ZvuAxEveKEcKjycgYEg9VHFf
         L3OXekf/cxb+jcgijaRO9msC9ud7Ejn4PGFckAX2nkAthdzk4n+9HO3dViN3Nf62ZKAP
         1v0A==
X-Gm-Message-State: AC+VfDxy3zukX5dlyh1ENfK8hmXzYax7B4ziK+r/2ty3LWly6fp6M6jT
	qlDXwSASp8QOifg3syB4jb4=
X-Google-Smtp-Source: ACHHUZ7xq1vU49+oDj7CrWdxacjqGLeqMxxCfV6ZUVNhzOEYif121viDARlILRPrr/j6HhxvRR0olw==
X-Received: by 2002:a05:6512:21d:b0:4f1:22a2:989b with SMTP id a29-20020a056512021d00b004f122a2989bmr200043lfo.50.1684328979302;
        Wed, 17 May 2023 06:09:39 -0700 (PDT)
Received: from [192.168.1.126] (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id n1-20020a195501000000b004f25129628fsm3372942lfe.151.2023.05.17.06.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 06:09:38 -0700 (PDT)
Message-ID: <f47550f9-73de-f212-fbd3-430ef6bd48a1@gmail.com>
Date: Wed, 17 May 2023 16:09:37 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US, en-GB
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Daniel Scally <djrscally@gmail.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Lars-Peter Clausen
 <lars@metafoo.de>, Michael Hennerich <Michael.Hennerich@analog.com>,
 Jonathan Cameron <jic23@kernel.org>, Andreas Klinger <ak@it-klinger.de>,
 Marcin Wojtas <mw@semihalf.com>, Russell King <linux@armlinux.org.uk>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 =?UTF-8?Q?Jonathan_Neusch=c3=a4fer?= <j.neuschaefer@gmx.net>,
 Paul Cercueil <paul@crapouillou.net>, Wolfram Sang <wsa@kernel.org>,
 Akhil R <akhilrajeev@nvidia.com>, linux-acpi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
 netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
 linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
References: <cover.1684220962.git.mazziesaccount@gmail.com>
 <CACRpkdYPZWNTOW6c0q1+q64JRvxUXswQqm6j5N5KaAWO=sSUaQ@mail.gmail.com>
From: Matti Vaittinen <mazziesaccount@gmail.com>
Subject: Re: [PATCH v4 0/7] fix fwnode_irq_get[_byname()] returnvalue
In-Reply-To: <CACRpkdYPZWNTOW6c0q1+q64JRvxUXswQqm6j5N5KaAWO=sSUaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/17/23 15:43, Linus Walleij wrote:
> On Tue, May 16, 2023 at 9:12 AM Matti Vaittinen
> <mazziesaccount@gmail.com> wrote:
> 
>> The fwnode_irq_get() and the fwnode_irq_get_byname() may have returned
>> zero if mapping the IRQ fails. This contradicts the
>> fwnode_irq_get_byname() documentation. Furthermore, returning zero or
>> errno on error is unepected and can easily lead to problems
>> like:
> 
> Also, zero is not really a valid IRQ, it means NO_IRQ:
> https://lwn.net/Articles/470820/
> 
> I'll apply the pinctrl patches.

Thanks Linus. I guess you noticed but please wait until the patch 1/7 
gets in as the pinctrl patches won't do "the right thing" without it. 
(Just ensuring we are on a same page ;) )

Yours,
	-- Matti

-- 
Matti Vaittinen
Linux kernel developer at ROHM Semiconductors
Oulu Finland

~~ When things go utterly wrong vim users can always type :help! ~~


