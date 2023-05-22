Return-Path: <netdev+bounces-4139-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D6670B477
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D9E3280E75
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 05:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911FFEC7;
	Mon, 22 May 2023 05:16:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AA7EB8
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 05:16:37 +0000 (UTC)
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4935A1;
	Sun, 21 May 2023 22:16:35 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2ab3e8f4efeso37738321fa.0;
        Sun, 21 May 2023 22:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684732594; x=1687324594;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CYrQOZoyONEufq+LqeQBmXVtdJJKIjdnOxohkmrAY6o=;
        b=edyY9Uwr97Vumn46XigszV1y/m9Gv7cv/j55TMmwIGEBhAFVFRjWdybCzaYU5NixCS
         Oy7lbHC2nES3xXibpgL20jNZZ577FxfG418ggGueA9EsKAShwZ80/RwFfsmDiyfuoofG
         XU5tXwCrBra5Kb2IvMC1SC5YRCcGgqEd8E5TJILGa6uctQYZ4d81y/YWJBbzULtudJv2
         klWuGT31X8OqVVju7bO1OnRz0QH+E15bv0xwtpRZSYjuP4vcqj9KUqB6De6Au5r1ta5M
         t5g3mkhXjYHbCEbcK5SWO7imUJDRp2fJpvWX9EBEPoxFWUNHkX1CKznVwUWPDat7ybXT
         7RXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684732594; x=1687324594;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CYrQOZoyONEufq+LqeQBmXVtdJJKIjdnOxohkmrAY6o=;
        b=Unde6ivhDmImx+1VDzBYxnncnXyEWeSky6TC+qomHv08Czep048XWuHfFodUufv9j8
         LicV1Bb4Xc499ffySw1rwLVuKqpoN03aH4Ffi+WQr/GAkXr2aH/DsC2x8L75QkIhuTlE
         S/+NhnwpJdb3s0H/Dxya1NdLg2y30hMMUaLuHJyF3g0wiLCb5iJUIEPmZaezDTZvECTB
         nDU9fEnDwoKaP2RgHHzb/3YY9t04kgF22+tFtbwPRynPaxcAn1sWRIi92cy1dcjbx2mI
         YxMUSfIEmRtPq1FLRJv5tQSa9Xovk5wRC7HMWbPIbLXU74eHLioUpWYIlE0+a/TBweO8
         qCww==
X-Gm-Message-State: AC+VfDzYnfPrNmiF8q2F7D5tBzTV3R/uTymWGPdP9IBbtFWychMwNtnx
	AJ2Qlt1iAPFqfSRHS8R3qxA=
X-Google-Smtp-Source: ACHHUZ7TbanQlhwifMepu7ORWVh/VP5bZ18ETSV+MsG47HW0VXAqmzXXDf/VvqNJ6H52yVSkjCYq8A==
X-Received: by 2002:a05:6512:3f1e:b0:4f3:a763:ccb7 with SMTP id y30-20020a0565123f1e00b004f3a763ccb7mr3425929lfa.2.1684732593811;
        Sun, 21 May 2023 22:16:33 -0700 (PDT)
Received: from [192.168.1.126] (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id k19-20020ac24573000000b004f00189e1dasm847966lfm.143.2023.05.21.22.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 May 2023 22:16:33 -0700 (PDT)
Message-ID: <44c87ed5-f14d-e690-1e5f-74212370611b@gmail.com>
Date: Mon, 22 May 2023 08:16:32 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5 4/8] pinctrl: wpcm450: relax return value check for IRQ
 get
Content-Language: en-US, en-GB
To: andy.shevchenko@gmail.com
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Daniel Scally <djrscally@gmail.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Wolfram Sang <wsa@kernel.org>,
 Lars-Peter Clausen <lars@metafoo.de>,
 Michael Hennerich <Michael.Hennerich@analog.com>,
 Jonathan Cameron <jic23@kernel.org>, Andreas Klinger <ak@it-klinger.de>,
 Marcin Wojtas <mw@semihalf.com>, Russell King <linux@armlinux.org.uk>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 =?UTF-8?Q?Jonathan_Neusch=c3=a4fer?= <j.neuschaefer@gmx.net>,
 Linus Walleij <linus.walleij@linaro.org>,
 Paul Cercueil <paul@crapouillou.net>, Akhil R <akhilrajeev@nvidia.com>,
 linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
 netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
 linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
References: <cover.1684493615.git.mazziesaccount@gmail.com>
 <42264f1b12a91e415ffa47ff9adb53f02a6aa3ea.1684493615.git.mazziesaccount@gmail.com>
 <ZGpS-13CozLp-p4f@surfacebook>
From: Matti Vaittinen <mazziesaccount@gmail.com>
In-Reply-To: <ZGpS-13CozLp-p4f@surfacebook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/21/23 20:20, andy.shevchenko@gmail.com wrote:
> Fri, May 19, 2023 at 02:02:16PM +0300, Matti Vaittinen kirjoitti:
>> fwnode_irq_get[_byname]() were changed to not return 0 anymore. The
>> special error case where device-tree based IRQ mapping fails can't no
>> longer be reliably detected from this return value. This yields a
>> functional change in the driver where the mapping failure is treated as
>> an error.
>>
>> The mapping failure can occur for example when the device-tree IRQ
>> information translation call-back(s) (xlate) fail, IRQ domain is not
>> found, IRQ type conflicts, etc. In most cases this indicates an error in
>> the device-tree and special handling is not really required.
>>
>> One more thing to note is that ACPI APIs do not return zero for any
>> failures so this special handling did only apply on device-tree based
>> systems.
>>
>> Drop the special (no error, just skip the IRQ) handling for DT mapping
>> failures as these can no longer be separated from other errors at driver
>> side.
> 
> ...
> 
>> The commit message does not mention if choosing not to abort the probe
>> on device-tree mapping failure (as is done on other errors) was chosen
>> because: a) Abort would have broken some existing setup. b) Because skipping
>> an IRQ on failure is "the right thing to do", or c) because it sounded like
>> a way to minimize risk of breaking something.
>>
>> If the reason is a) - then I'd appreciate receiving some more
>> information and a suggestion how to proceed (if possible). If the reason
>> is b), then it might be best to just skip the IRQ instead of aborting
>> the probe for all errors on IRQ getting. Finally, in case of c), well,
>> by acking this change you will now accept the risk :)
> 
> No need to repeat this. As I answered the case c) was in my mind when I made
> that change.

True. I'll drop that if I re-spin. Thanks for pointing it out.


Yours,
	-- Matti

-- 
Matti Vaittinen
Linux kernel developer at ROHM Semiconductors
Oulu Finland

~~ When things go utterly wrong vim users can always type :help! ~~


