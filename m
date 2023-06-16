Return-Path: <netdev+bounces-11408-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5CE733043
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:45:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B50A71C20F9A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D75FC03;
	Fri, 16 Jun 2023 11:45:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A9C17ACA
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:45:23 +0000 (UTC)
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54AD359D;
	Fri, 16 Jun 2023 04:45:10 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b41e700103so7441931fa.2;
        Fri, 16 Jun 2023 04:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686915909; x=1689507909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rPm5ARXV5BWgDp1lXKxZSY+Q/UaoNS0kZY5vjJcwDOE=;
        b=csvzXr9sxrsEhmtl/f/VnHzabemiaF1sQuQcYkZUW1KFtpaBGsZvTu2wEj5z3fmQV7
         XI2pZ/LySZqysZ7+KB17tTjAz4CsvyutOwJ9BjKOiAfxtf4Ex/FC2m/McWDhvSydOYeK
         xZMW/AeU671DDhe4cpcTU2hGtMA617Y3ZhzMV97reasPuWmYTrzavjANcP/T31g9tlqO
         Pgfdvn3J6jFePmMN+GnO44+e6nUvaC//BJfpP3aAVsfxgaQhvGk4MWJ1BQjJvAQVS+Ho
         t7rEepKY0iZdmj3jy190snVpsdNQOJHP1T6vtktW23QWfv/r1Slt5hM63fv2151wUjjf
         srlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686915909; x=1689507909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rPm5ARXV5BWgDp1lXKxZSY+Q/UaoNS0kZY5vjJcwDOE=;
        b=GgQ+CULVQXxEHQ+7vbLm3MCF+qrBIa8Kt2oZoVSVoy030+l1PShogwz+wH1ALAj7gp
         nrfQUcnndPq/2p3D4ETgjl4/b0jIdBLw+5lIIoAB6r7f8VGS8aZt/C5cBZbTlgwtel8Z
         Nz3BbKk7BP9oPSwgF+rSPxiZOSXcaH5sZB76dkj1OOJ1NUZbApICcG7361YFQcY7g+oI
         PKnK4UlwmOtZl9EFpcXY5znjZ1YvfWyE9v15vH26ZxZrVWxAGLfzcRQs57w3QQGvwxtj
         19dcYa5rNYRF0VRO83nhW+lgprlIbexJvA8SUY9AiOqYtTaRgtyDHInZfHmz32asdTxR
         180Q==
X-Gm-Message-State: AC+VfDzFF1E8RTmZNEW0inGNLjrAhDJ2ihY3UW3lEjejxvnkDZl0Q+Xm
	fKFCWGQStLT1LdOmhmO4lhA=
X-Google-Smtp-Source: ACHHUZ6EqaR+4qrPwwPEnY7bruplRUt/KImSo1+8sT1eJTNzk2+7vjhqwAvCam0CTFxoWfPkaXH0/w==
X-Received: by 2002:a2e:9bd8:0:b0:2b4:5c1a:dd7c with SMTP id w24-20020a2e9bd8000000b002b45c1add7cmr690747ljj.41.1686915908820;
        Fri, 16 Jun 2023 04:45:08 -0700 (PDT)
Received: from ?IPV6:2001:14ba:16f8:1500::1? (dc78bmyyyyyyyyyyyyyyt-3.rev.dnainternet.fi. [2001:14ba:16f8:1500::1])
        by smtp.gmail.com with ESMTPSA id y22-20020a2e3216000000b002a8e8c776e9sm3599447ljy.56.2023.06.16.04.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 04:45:08 -0700 (PDT)
Message-ID: <fb7241d3-d1d1-1c37-919b-488d6d007484@gmail.com>
Date: Fri, 16 Jun 2023 14:45:06 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 0/9] fix fwnode_irq_get[_byname()] returnvalue
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jakub Kicinski <kuba@kernel.org>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Daniel Scally <djrscally@gmail.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Wolfram Sang <wsa@kernel.org>,
 Lars-Peter Clausen <lars@metafoo.de>,
 Michael Hennerich <Michael.Hennerich@analog.com>,
 Jonathan Cameron <jic23@kernel.org>, Andreas Klinger <ak@it-klinger.de>,
 Marcin Wojtas <mw@semihalf.com>, Russell King <linux@armlinux.org.uk>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, =?UTF-8?Q?Jonathan_Neusch=c3=a4fer?=
 <j.neuschaefer@gmx.net>, Linus Walleij <linus.walleij@linaro.org>,
 Paul Cercueil <paul@crapouillou.net>, Akhil R <akhilrajeev@nvidia.com>,
 linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
 netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
 linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
References: <cover.1685340157.git.mazziesaccount@gmail.com>
 <20230530233438.572db3fb@kernel.org>
 <2023061553-urging-collision-32f8@gregkh>
Content-Language: en-US, en-GB
From: Matti Vaittinen <mazziesaccount@gmail.com>
In-Reply-To: <2023061553-urging-collision-32f8@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/15/23 14:37, Greg Kroah-Hartman wrote:
> On Tue, May 30, 2023 at 11:34:38PM -0700, Jakub Kicinski wrote:
>> On Mon, 29 May 2023 09:22:15 +0300 Matti Vaittinen wrote:
>>> The fwnode_irq_get() and the fwnode_irq_get_byname() may have returned
>>> zero if mapping the IRQ fails. This contradicts the
>>> fwnode_irq_get_byname() documentation. Furthermore, returning zero or
>>> errno on error is unepected and can easily lead to problems
>>> like.
>>
>> What's the merging plan? Could patch 1 go to a stable branch
>> and then driver trees can pull it in and apply their respective
>> patches locally?
> 
> I'll take patch 1 now, and then after 6.5-rc1, Matti, can you send the
> cleanup patches to the respective subsystems?

Yes. I can re-spin the rest of the patches.

Yours,
	-- Matti

> 
> thanks,
> 
> greg k-h

-- 
Matti Vaittinen
Linux kernel developer at ROHM Semiconductors
Oulu Finland

~~ When things go utterly wrong vim users can always type :help! ~~


