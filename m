Return-Path: <netdev+bounces-149-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A9C6F57A6
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB2371C20E74
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1CABA48;
	Wed,  3 May 2023 12:12:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622C963DC
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 12:12:04 +0000 (UTC)
X-Greylist: delayed 595 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 May 2023 05:11:59 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4451BFC;
	Wed,  3 May 2023 05:11:59 -0700 (PDT)
Received: from [IPV6:2003:e9:d706:54a1:212b:c98b:d0c5:6c8c] (p200300e9d70654a1212bc98bd0c56c8c.dip0.t-ipconnect.de [IPv6:2003:e9:d706:54a1:212b:c98b:d0c5:6c8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: stefan@datenfreihafen.org)
	by proxima.lasnet.de (Postfix) with ESMTPSA id 82FFAC00AF;
	Wed,  3 May 2023 14:01:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
	s=2021; t=1683115319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jrY4np7MIEvKj3oth8g3qje83iXw5OFsZNJLsl8D7RQ=;
	b=uKEEkxzo4jZwwNqIjEPvwkWPHWvKHNyQL62sEHhuw8fTrst//3B4Jz7HPuLZ53cgZo8hzu
	kFT/KmpufWXNCH4OBKVSVBmBQ49Qt0/qnrmzQztaS0cVHrus38DsOwEkS87hsxtmyNtfdG
	rC03XUGSYEuo3/K+v8eMwq/i3AnFp0KnqeNsvEWkx0Y54BpS7SeltuaO3OyqIdCoh9wRFB
	pIx2GdUF2Ki/lnEcCfgOEwoXHdqHG472NOA0DccePOmMj7wshaWu4qMMavnYPVt84aAd4y
	m+qamR0+DUqmfDd2dAvYAAfLpj8uMGyepMzm6DNtwNX3r5ahAGzJKgzG71PkoQ==
Message-ID: <f5518a73-ebba-32a1-3c70-464c6d233760@datenfreihafen.org>
Date: Wed, 3 May 2023 14:01:58 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] ca8210: move to gpio descriptors
Content-Language: en-US
To: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
 Alexander Aring <alex.aring@gmail.com>
Cc: "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Hauke Mehrtens <hauke@hauke-m.de>,
 linux-wpan@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
 linux-kernel@vger.kernel.org
References: <20230126161737.2985704-1-arnd@kernel.org>
 <57e74219-d439-4d10-9bb5-53fe7b30b46f@app.fastmail.com>
From: Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <57e74219-d439-4d10-9bb5-53fe7b30b46f@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Arnd.

On 26.01.23 17:25, Arnd Bergmann wrote:
> On Thu, Jan 26, 2023, at 17:17, Arnd Bergmann wrote:
> 
>>   	if (ret) {
>> -		dev_crit(&spi->dev, "request_irq %d failed\n", pdata->irq_id);
>> -		gpiod_unexport(gpio_to_desc(pdata->gpio_irq));
>> -		gpio_free(pdata->gpio_irq);
>> +		dev_crit(&spi->dev, "request_irq %d failed\n", priv->irq_id);
>> +		gpiod_put(priv->gpio_irq);
>>   	}
> 
> I just realized that this bit depends on the "gpiolib: remove
> legacy gpio_export" patch I sent to the gpio mailing list earlier.
> 
> We can probably just defer this change until that is merged,
> or alternatively I can rebase this patch to avoid the
> dependency.

I think the gpiolib ependency should be merged now. Do you want to 
rebase this patch against latest? We had some other ca8210 changes 
coming in.

regards
Stefan Schmidt

