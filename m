Return-Path: <netdev+bounces-11451-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54EBA73327B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:48:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E8EF281742
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B154718B10;
	Fri, 16 Jun 2023 13:48:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A245B168CB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:48:30 +0000 (UTC)
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4763593;
	Fri, 16 Jun 2023 06:48:27 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686923305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8oK/JD/VfQBaYnT9KJx8BUomsRwXIR/Wq47zzH/xURI=;
	b=N95uKDkFRvrLUoacdiLx3mrcBstb+8fwzdVsf2ul7uf6Ax64ehU/HuBfHioTUQcfai6VdU
	QwWC6u36IDmXlt5k2bwHon2DQo6M+6hGsv5SI0s4cnNnhHxYWbqtb5uQDl8vlNcZl7M5Ys
	yJGDB8+0+hmhrF+Im+MswNcoH7a7Od/7ytGcjOSSFddRP6HI/C8zFDDXUjQZ6iAzRtLk4k
	CddbTmcvec/b2kFDxlFnPJmRiwjw8z27pXSbRLm/erjIHp5vdUW2uuKBJXVeZKt94/gqYj
	9ytK2pvllhb7xJ3erhfBiNnX0Ui+FN5TQaCxqRLEC/4YNaaRhwbK6qk1BrREog==
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id E9A18FF806;
	Fri, 16 Jun 2023 13:48:21 +0000 (UTC)
Message-ID: <71492ab7-9d6b-e41c-e392-1bee04860f18@bootlin.com>
Date: Fri, 16 Jun 2023 15:48:44 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next 3/8] net: stmmac: move PTP interrupt handling to
 IP-specific DWMAC file
To: Simon Horman <simon.horman@corigine.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Jose Abreu <joabreu@synopsys.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Richard Cochran <richardcochran@gmail.com>,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Nicolas Carrier <nicolas.carrier@nav-timing.safrangroup.com>
References: <20230616100409.164583-1-alexis.lothore@bootlin.com>
 <20230616100409.164583-4-alexis.lothore@bootlin.com>
 <ZIxkyfRIuVcmCzmD@corigine.com>
Content-Language: en-US
From: =?UTF-8?Q?Alexis_Lothor=c3=a9?= <alexis.lothore@bootlin.com>
In-Reply-To: <ZIxkyfRIuVcmCzmD@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Simon,

On 6/16/23 15:34, Simon Horman wrote:
> On Fri, Jun 16, 2023 at 12:04:04PM +0200, alexis.lothore@bootlin.com wrote:
>> From: Alexis Lothoré <alexis.lothore@bootlin.com>
>>
>> As for auxiliary snapshot triggers configuration, reading snapshots depends
>> on specific registers addresses and layout. As a consequence, move
>> PTP-specific part of stmmac interrupt handling to specific DWMAC IP file
>>
>> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
> 
> Hi Alexis,
> 
> thanks for your patch.
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
>> index 01c0822d37e6..b36fbb0fa5da 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> 
> ...
> 
>> +static void dwmac4_ptp_isr(struct stmmac_priv *priv)
>> +{
>> +	u32 num_snapshot, ts_status;
>> +	struct ptp_clock_event event;
>> +	unsigned long flags;
>> +	u64 ptp_time;
>> +	int i;
> 
> Please use reverse xmas tree - longest line to shortest - for new
> Networking code.
> 
> 	struct ptp_clock_event event;
> 	u32 num_snapshot, ts_status;
> 	unsigned long flags;
> 	u64 ptp_time;
> 	int i;
> 
ACK
> ...
> 
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
>> index 9e0ff2cec352..92ed421702b9 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
>> @@ -23,9 +23,6 @@
>>  #define	PTP_STSUR	0x10	/* System Time – Seconds Update Reg */
>>  #define	PTP_STNSUR	0x14	/* System Time – Nanoseconds Update Reg */
>>  #define	PTP_TAR		0x18	/* Timestamp Addend Reg */
>> -#define	PTP_ACR		0x40	/* Auxiliary Control Reg */
> 
> Unfortunately this seems to break the build of
> drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> on an x86_64 alllodconfig, as PTP_ACR is used in that file.
> 
>> -#define	PTP_ATNR	0x48	/* Auxiliary Timestamp - Nanoseconds Reg */
>> -#define	PTP_ATSR	0x4c	/* Auxiliary Timestamp - Seconds Reg */
>>  
>>  #define	PTP_STNSUR_ADDSUB_SHIFT	31
>>  #define	PTP_DIGITAL_ROLLOVER_MODE	0x3B9ACA00	/* 10e9-1 ns */

Ouch. thanks for spotting the issue and the providing build details, I'll fix
this and wait a bit for more comments before sending v2
> 
> --
> pw-bot: changes-requested
> 

-- 
Alexis Lothoré, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


