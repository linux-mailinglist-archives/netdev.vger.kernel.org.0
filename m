Return-Path: <netdev+bounces-4138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E7370B465
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCF981C2097E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 05:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFDFED7;
	Mon, 22 May 2023 05:15:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC713EC7
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 05:15:09 +0000 (UTC)
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B8DA8;
	Sun, 21 May 2023 22:15:07 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4eed764a10cso6139730e87.0;
        Sun, 21 May 2023 22:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684732506; x=1687324506;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=THeH3RaWIynHSwKlX2svi0BhR2aQmOxVPDuj7iF+9CU=;
        b=ZqV07oiUpM3rILlXqiJZcvZs4BY2Wdo63On6RQdrE8STzFBrWyFHKIPPNXKkRO6Gvt
         mbGkZIkauYLN3xSuiN8fkHrSFbhA5jzMGKeyo484SpfGQruznb6mn7gNrjUeDIrSkIGX
         dlG8V/BzfTXS/r7oxA+5L6h/uyjxk7nNm6BgvUwVwE9MhXQMPf199v/bAmht+pNhU1zC
         t7V83cf6gRnHSU7MAQgZLwlVe3lSVCHlwaECFx2k7IAUpAyNzzwBjU+/v7nzxRXzOG+M
         hgWPMLpCViBPf3MXbqZBF42jGpbw5Gtc93kjHj10ERwx4epMKFiuBx45hsCgEP0H8gZk
         b0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684732506; x=1687324506;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=THeH3RaWIynHSwKlX2svi0BhR2aQmOxVPDuj7iF+9CU=;
        b=SfpEkEjif476u8zfyZJesnvaxCPiAEN6mzzz7TfFlqd1zim/k2O6WrIjO+/dtfCOog
         3df2hKRFd2J7pgQvnqDUO0Bpfozd7RJrdcK3ez1j6eBEvhgUDnjvLEZKVo7f8Dxvnv6k
         MdrRGvlUfsa7sjAoxJ9evMS5o2fa+9rMrSqxsuIX0Dgq49RSXEmoWtgi61Z6Vme/L0m0
         BXr+wsll21KZ48y2so+xXBypajDU7yU3XvUW8xUJlT6xLALakraVNYw57EfeQV4bZiJO
         1yPT8qwMGX6Icwi7izNhBVQqg5qfrw0BgrDjRAytzcCGnVukANxuTahO5G4GloAwWzdL
         937Q==
X-Gm-Message-State: AC+VfDxOYPn7p0B9BQJupUV2dz4uiYOIkNxduKbPd4KTRhLeDjUe5ZJH
	O38H5y3pfAJ1wpwEVQUgrtg=
X-Google-Smtp-Source: ACHHUZ4UnbSyJQIHoo1YS1QPqF9voV5jiWt4nIwqxau8fPKZCINZHH9DSURxTyghpzjZN1YLy1Lpjw==
X-Received: by 2002:ac2:4907:0:b0:4f4:af57:19af with SMTP id n7-20020ac24907000000b004f4af5719afmr576935lfi.2.1684732505853;
        Sun, 21 May 2023 22:15:05 -0700 (PDT)
Received: from [192.168.1.126] (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id n15-20020ac2490f000000b004edc55d3900sm850247lfi.0.2023.05.21.22.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 May 2023 22:15:05 -0700 (PDT)
Message-ID: <6e94c838-886d-3c58-3fa0-175501f57f56@gmail.com>
Date: Mon, 22 May 2023 08:15:01 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5 3/8] net-next: mvpp2: relax return value check for IRQ
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
 <7c7b1a123d6d5c15c8b37754f1f0c4bd1cad5a01.1684493615.git.mazziesaccount@gmail.com>
 <ZGpSpZFEo5cw94U_@surfacebook>
From: Matti Vaittinen <mazziesaccount@gmail.com>
In-Reply-To: <ZGpSpZFEo5cw94U_@surfacebook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andy,

On 5/21/23 20:19, andy.shevchenko@gmail.com wrote:
> Fri, May 19, 2023 at 02:01:47PM +0300, Matti Vaittinen kirjoitti:
>> fwnode_irq_get[_byname]() were changed to not return 0 anymore.
>>
>> Drop check for return value 0.
> 
> ...
> 
>> -		if (v->irq <= 0) {
>> +		if (v->irq < 0) {
>>   			ret = -EINVAL;
> 
> 			ret = v->irq;
> 
> ?

For me that seems to be correct, yes. This, however, would be a 
functional change and in my opinion it should be done separately from 
this API change.

> 
>>   			goto err;
>>   		}
> 

-- 
Matti Vaittinen
Linux kernel developer at ROHM Semiconductors
Oulu Finland

~~ When things go utterly wrong vim users can always type :help! ~~


