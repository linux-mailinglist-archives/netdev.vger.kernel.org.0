Return-Path: <netdev+bounces-8017-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF7397226CC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AE36280E79
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BE41952F;
	Mon,  5 Jun 2023 13:04:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B54C6ABC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:04:55 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FC1FD;
	Mon,  5 Jun 2023 06:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685970294; x=1717506294;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nROIitPltbPWMd0kgRZLjZjy+4djGlBLlehlPkk3LwQ=;
  b=MFCFjrbeaazSaqcICVkfwCQTeStGd/SZ3BBeJ4eJcamyZHt7zZsusDce
   vdOhBAkenqNmZOMdhkwtCNYMt3nsZW8jbp7xQjcN1371fCpA3nvekYfO9
   VEY1R+xzK4oXUi7uMz5NlEiN9Jp+p/zeexMNohmDefyZ4Fof8BUwvL5Lk
   5oKREt5bmixHeePJDMpRWXcBoNvLN1eFROJLf0ZQmEGkHzg0xH+2cuFhQ
   G1fhozPQSwA0vOTEM+aSLwERh7/MRlgIrXLGUBAU0+w1OqNt58cpZquBH
   mDUjjHic4UHl78kVvboZzovUdykwg9Rl4ONYq/Sxb0zKYkIE1kFRN0ucz
   w==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="214657607"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jun 2023 06:04:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 5 Jun 2023 06:04:47 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 5 Jun 2023 06:04:41 -0700
Message-ID: <c3f7c08f-272a-5abb-da78-568c408f40de@microchip.com>
Date: Mon, 5 Jun 2023 15:04:34 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 17/21] power: reset: at91-poweroff: lookup for proper pmc
 dt node for sam9x7
Content-Language: en-US
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Varshini Rajendran
	<varshini.rajendran@microchip.com>, <tglx@linutronix.de>, <maz@kernel.org>,
	<robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<conor+dt@kernel.org>, <alexandre.belloni@bootlin.com>,
	<claudiu.beznea@microchip.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <gregkh@linuxfoundation.org>,
	<linux@armlinux.org.uk>, <mturquette@baylibre.com>, <sboyd@kernel.org>,
	<sre@kernel.org>, <broonie@kernel.org>, <arnd@arndb.de>,
	<gregory.clement@bootlin.com>, <sudeep.holla@arm.com>,
	<balamanikandan.gunasundar@microchip.com>, <mihai.sain@microchip.com>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <linux-clk@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: <Hari.PrasathGE@microchip.com>, <cristian.birsan@microchip.com>,
	<durai.manickamkr@microchip.com>, <manikandan.m@microchip.com>,
	<dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
	<balakrishnan.s@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-18-varshini.rajendran@microchip.com>
 <2a538004-351f-487a-361c-df723d186c27@linaro.org>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <2a538004-351f-487a-361c-df723d186c27@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/06/2023 at 08:43, Krzysztof Kozlowski wrote:
> On 03/06/2023 22:02, Varshini Rajendran wrote:
>> Use sam9x7 pmc's compatible to lookup for in the SHDWC driver
>>
>> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
>> ---
>>   drivers/power/reset/at91-sama5d2_shdwc.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/power/reset/at91-sama5d2_shdwc.c b/drivers/power/reset/at91-sama5d2_shdwc.c
>> index d8ecffe72f16..d0f29b99f25e 100644
>> --- a/drivers/power/reset/at91-sama5d2_shdwc.c
>> +++ b/drivers/power/reset/at91-sama5d2_shdwc.c
>> @@ -326,6 +326,7 @@ static const struct of_device_id at91_pmc_ids[] = {
>>        { .compatible = "atmel,sama5d2-pmc" },
>>        { .compatible = "microchip,sam9x60-pmc" },
>>        { .compatible = "microchip,sama7g5-pmc" },
>> +     { .compatible = "microchip,sam9x7-pmc" },
> 
> Why do you need new entry if these are compatible?

Yes, PMC is very specific to a SoC silicon. As we must look for it in 
the shutdown controller, I think we need a new entry here.

Best regards,
   Nicolas

-- 
Nicolas Ferre


