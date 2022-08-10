Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E9858EB5D
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 13:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiHJLhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 07:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHJLhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 07:37:08 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E680976943
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 04:37:04 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id B462E7F4A2;
        Wed, 10 Aug 2022 13:37:01 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2ABC34064;
        Wed, 10 Aug 2022 13:37:01 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8981A3405A;
        Wed, 10 Aug 2022 13:37:01 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Wed, 10 Aug 2022 13:37:01 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id 5F8A77F4A2;
        Wed, 10 Aug 2022 13:37:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1660131421; bh=WtNVC4w9WGKnLipu1+C/qnOkQC2CBZL7LqWPDZCnJq8=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=b/ERwLT3VEuCY3xHBG/BmzgixsZV+8r74pst5x+nn9YPDTCQ288c1Yz7ozhGV13mE
         WqZiVKoB1kw3KSLy+ukRAiNZeSDgN02v7NeR2d5fuCvAyOBb3WUX0EDfaPVoL00qxQ
         6Xw9g9ajyWc+UR18lL1SJCJt6+ZpO3sNqZIDSHf11KNyAhgePteN70wi9Eqp92Br9H
         rSEX6M+vngBlLxZcKY6lQCKiRDmVI6VaGDIkwN7t/NrTd0K/38ezAJBlsLt/mYAGhe
         H0UmGu+f999ZgigWb8LqJt9zUWPWxyGW7E8adtUblikZ4uWGUZLt5T8EJ+K3jekkL0
         R7/ghF11RkUHw==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.9; Wed, 10
 Aug 2022 13:37:00 +0200
Message-ID: <299d74d5-2d56-23f6-affc-78bb3ae3e03c@prolan.hu>
Date:   Wed, 10 Aug 2022 13:36:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] fec: Restart PPS after link state change
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
References: <20220809124119.29922-1-csokas.bence@prolan.hu>
 <YvKZNcVfYdLw7bkm@lunn.ch>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <YvKZNcVfYdLw7bkm@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456617062
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022. 08. 09. 19:28, Andrew Lunn wrote:
> On Tue, Aug 09, 2022 at 02:41:19PM +0200, Csókás Bence wrote:
>> On link state change, the controller gets reset,
>> causing PPS to drop out. So we restart it if needed.
>>
>> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
>> ---
>>   drivers/net/ethernet/freescale/fec_main.c | 27 ++++++++++++++++++++++-
>>   1 file changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
>> index ca5d49361fdf..c264b1dd5286 100644
>> --- a/drivers/net/ethernet/freescale/fec_main.c
>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> @@ -954,6 +954,7 @@ fec_restart(struct net_device *ndev)
>>   	u32 temp_mac[2];
>>   	u32 rcntl = OPT_FRAME_SIZE | 0x04;
>>   	u32 ecntl = 0x2; /* ETHEREN */
>> +	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
> 
> Is it safe to hard code this? What if the user configured
> PTP_CLK_REQ_EXTTS or PTP_CLK_REQ_PEROUT?

The fec driver doesn't support anything other than PTP_CLK_REQ_PPS. And 
if it will at some point, this will need to be amended anyways.

> 
>>   	/* Whack a reset.  We should wait for this.
>>   	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
>> @@ -1119,6 +1120,13 @@ fec_restart(struct net_device *ndev)
>>   	if (fep->bufdesc_ex)
>>   		fec_ptp_start_cyclecounter(ndev);
>>   
>> +	/* Restart PPS if needed */
>> +	if (fep->pps_enable) {
>> +		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
>> +		fep->pps_enable = 0;
> 
> If reset causes PPS to stop, maybe it would be better to do this
> unconditionally?

But if it wasn't enabled before the reset in the first place, we 
wouldn't want to unexpectedly start it.

> 
> 	fep->pps_enable = 0;
> 	fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
> 
>> +	if (fep->bufdesc_ex)
>> +		ecntl |= (1 << 4);
> 
> Please replace (1 << 4) with a #define to make it clear what this is doing.

I took it from the original source, line 1138 as of commit #504148f. It 
is the EN1588 bit by the way. I shall replace it with a #define in both 
places then. Though the code is riddled with other magic numbers without 
explanation, and I probably won't be bothered to fix them all.

> 
>> +
>>   	/* We have to keep ENET enabled to have MII interrupt stay working */
>>   	if (fep->quirks & FEC_QUIRK_ENET_MAC &&
>>   		!(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
>> -		writel(2, fep->hwp + FEC_ECNTRL);
>> +		ecntl |= 0x2;
>>   		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
>>   	}
>> +
>> +	writel(ecntl, fep->hwp + FEC_ECNTRL);
>> +
>> +	if (fep->bufdesc_ex)
>> +		fec_ptp_start_cyclecounter(ndev);
>> +
>> +	/* Restart PPS if needed */
>> +	if (fep->pps_enable) {
>> +		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
>> +		fep->pps_enable = 0;
>> +		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
>> +	}
> 
> So you re-start PPS in stop()? Should it keep outputting when the
> interface is down?

Yes. We use PPS to synchronize devices on a common backplane. We use PTP 
to sync this PPS to a master clock. But if PTP sync drops out, we 
wouldn't want the backplane-level synchronization to fail. The PPS needs 
to stay on as long as userspace *explicitly* disables it, regardless of 
what happens to the link.

> 
> Also, if it is always outputting, don't you need to stop it in
> fec_drv_remove(). You probably don't want to still going after the
> driver is unloaded.

Good point, that is one exception we could make to the above statement 
(though even in this case, userspace *really* should disable PPS before 
unloading the module).

> 
>         Andrew

Thanks for the insights,
Bence
