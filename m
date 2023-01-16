Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195A066B764
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 07:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjAPGYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 01:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbjAPGYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 01:24:04 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4569ED0;
        Sun, 15 Jan 2023 22:24:02 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30G6NncX061312;
        Mon, 16 Jan 2023 00:23:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673850229;
        bh=NLSIybxmTk+rdAI80QOg2FeWvA2t8VRG7RbnJMEkQaw=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=LFPN3cDErKnVifwF/ckoS5ciAA6dK9sBP6Ke+gIlEIgZAjfGh/9s1thl+Cn6fvjy3
         PORbbmQ3AZ56fB9ez4fodOWsFLfxqy4voXLUMf4MhOTrfWYpvdI3lHrew7GMulbdpS
         ZytJ1Eqibx7LQ5drCEYimVfUmrD5hhJU4Z8UNB4k=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30G6Nn2t016588
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Jan 2023 00:23:49 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 16
 Jan 2023 00:23:48 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 16 Jan 2023 00:23:48 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30G6NhZC028708;
        Mon, 16 Jan 2023 00:23:43 -0600
Message-ID: <60c3af09-f3ed-c721-e1fe-cc8bf272b424@ti.com>
Date:   Mon, 16 Jan 2023 11:53:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nm@ti.com>,
        <kristo@kernel.org>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next 2/5] net: ethernet: ti: am65-cpts: add pps
 support
To:     Roger Quadros <rogerq@kernel.org>
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <20230111114429.1297557-3-s-vadapalli@ti.com>
 <6e691ad5-a919-75d8-ff65-c11820b253ee@kernel.org>
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <6e691ad5-a919-75d8-ff65-c11820b253ee@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Roger,

On 13/01/23 15:27, Roger Quadros wrote:
> Hi,
> 
> On 11/01/2023 13:44, Siddharth Vadapalli wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> CPTS doesn't have HW support for PPS ("pulse per second”) signal
>> generation, but it can be modeled by using Time Sync Router and routing
>> GenFx (periodic signal generator) output to CPTS_HWy_TS_PUSH (hardware time
>> stamp) input, and configuring GenFx to generate 1sec pulses.
>>
>>      +------------------------+
>>      |          CPTS          |
>>      |                        |
>>  +--->CPTS_HW4_PUSH      GENFx+---+
>>  |   |                        |   |
>>  |   +------------------------+   |
>>  |                                |
>>  +--------------------------------+
>>
>> Add corresponding support to am65-cpts driver. The DT property "ti,pps"
>> has to be used to enable PPS support and configure pair
>> [CPTS_HWy_TS_PUSH, GenFx].
>>
>> Once enabled, PPS can be tested using ppstest tool:
>>  # ./ppstest /dev/pps0
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>  drivers/net/ethernet/ti/am65-cpts.c | 85 +++++++++++++++++++++++++++--
>>  1 file changed, 80 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
>> index 9535396b28cd..6a0f09b497d1 100644
>> --- a/drivers/net/ethernet/ti/am65-cpts.c
>> +++ b/drivers/net/ethernet/ti/am65-cpts.c
>> @@ -176,6 +176,10 @@ struct am65_cpts {
>>  	u32 genf_enable;
>>  	u32 hw_ts_enable;
>>  	struct sk_buff_head txq;
>> +	bool pps_enabled;
>> +	bool pps_present;
>> +	u32 pps_hw_ts_idx;
>> +	u32 pps_genf_idx;
>>  	/* context save/restore */
>>  	u64 sr_cpts_ns;
>>  	u64 sr_ktime_ns;
>> @@ -319,8 +323,15 @@ static int am65_cpts_fifo_read(struct am65_cpts *cpts)
>>  		case AM65_CPTS_EV_HW:
>>  			pevent.index = am65_cpts_event_get_port(event) - 1;
>>  			pevent.timestamp = event->timestamp;
>> -			pevent.type = PTP_CLOCK_EXTTS;
>> -			dev_dbg(cpts->dev, "AM65_CPTS_EV_HW p:%d t:%llu\n",
>> +			if (cpts->pps_enabled && pevent.index == cpts->pps_hw_ts_idx) {
>> +				pevent.type = PTP_CLOCK_PPSUSR;
>> +				pevent.pps_times.ts_real = ns_to_timespec64(pevent.timestamp);
>> +			} else {
>> +				pevent.type = PTP_CLOCK_EXTTS;
>> +			}
>> +			dev_dbg(cpts->dev, "AM65_CPTS_EV_HW:%s p:%d t:%llu\n",
>> +				pevent.type == PTP_CLOCK_EXTTS ?
>> +				"extts" : "pps",
>>  				pevent.index, event->timestamp);
>>  
>>  			ptp_clock_event(cpts->ptp_clock, &pevent);
>> @@ -507,7 +518,13 @@ static void am65_cpts_extts_enable_hw(struct am65_cpts *cpts, u32 index, int on)
>>  
>>  static int am65_cpts_extts_enable(struct am65_cpts *cpts, u32 index, int on)
>>  {
>> -	if (!!(cpts->hw_ts_enable & BIT(index)) == !!on)
>> +	if (index >= cpts->ptp_info.n_ext_ts)
>> +		return -ENXIO;
>> +
>> +	if (cpts->pps_present && index == cpts->pps_hw_ts_idx)
>> +		return -EINVAL;
>> +
>> +	if (((cpts->hw_ts_enable & BIT(index)) >> index) == on)
>>  		return 0;
>>  
>>  	mutex_lock(&cpts->ptp_clk_lock);
>> @@ -591,6 +608,12 @@ static void am65_cpts_perout_enable_hw(struct am65_cpts *cpts,
>>  static int am65_cpts_perout_enable(struct am65_cpts *cpts,
>>  				   struct ptp_perout_request *req, int on)
>>  {
>> +	if (req->index >= cpts->ptp_info.n_per_out)
>> +		return -ENXIO;
>> +
>> +	if (cpts->pps_present && req->index == cpts->pps_genf_idx)
>> +		return -EINVAL;
>> +
>>  	if (!!(cpts->genf_enable & BIT(req->index)) == !!on)
>>  		return 0;
>>  
>> @@ -604,6 +627,48 @@ static int am65_cpts_perout_enable(struct am65_cpts *cpts,
>>  	return 0;
>>  }
>>  
>> +static int am65_cpts_pps_enable(struct am65_cpts *cpts, int on)
>> +{
>> +	int ret = 0;
>> +	struct timespec64 ts;
>> +	struct ptp_clock_request rq;
>> +	u64 ns;
>> +
>> +	if (!cpts->pps_present)
>> +		return -EINVAL;
>> +
>> +	if (cpts->pps_enabled == !!on)
>> +		return 0;
>> +
>> +	mutex_lock(&cpts->ptp_clk_lock);
>> +
>> +	if (on) {
>> +		am65_cpts_extts_enable_hw(cpts, cpts->pps_hw_ts_idx, on);
>> +
>> +		ns = am65_cpts_gettime(cpts, NULL);
>> +		ts = ns_to_timespec64(ns);
>> +		rq.perout.period.sec = 1;
>> +		rq.perout.period.nsec = 0;
>> +		rq.perout.start.sec = ts.tv_sec + 2;
>> +		rq.perout.start.nsec = 0;
>> +		rq.perout.index = cpts->pps_genf_idx;
>> +
>> +		am65_cpts_perout_enable_hw(cpts, &rq.perout, on);
>> +		cpts->pps_enabled = true;
>> +	} else {
>> +		rq.perout.index = cpts->pps_genf_idx;
>> +		am65_cpts_perout_enable_hw(cpts, &rq.perout, on);
>> +		am65_cpts_extts_enable_hw(cpts, cpts->pps_hw_ts_idx, on);
>> +		cpts->pps_enabled = false;
>> +	}
>> +
>> +	mutex_unlock(&cpts->ptp_clk_lock);
>> +
>> +	dev_dbg(cpts->dev, "%s: pps: %s\n",
>> +		__func__, on ? "enabled" : "disabled");
>> +	return ret;
>> +}
>> +
>>  static int am65_cpts_ptp_enable(struct ptp_clock_info *ptp,
>>  				struct ptp_clock_request *rq, int on)
>>  {
>> @@ -614,6 +679,8 @@ static int am65_cpts_ptp_enable(struct ptp_clock_info *ptp,
>>  		return am65_cpts_extts_enable(cpts, rq->extts.index, on);
>>  	case PTP_CLK_REQ_PEROUT:
>>  		return am65_cpts_perout_enable(cpts, &rq->perout, on);
>> +	case PTP_CLK_REQ_PPS:
>> +		return am65_cpts_pps_enable(cpts, on);
>>  	default:
>>  		break;
>>  	}
>> @@ -926,6 +993,12 @@ static int am65_cpts_of_parse(struct am65_cpts *cpts, struct device_node *node)
>>  	if (!of_property_read_u32(node, "ti,cpts-periodic-outputs", &prop[0]))
>>  		cpts->genf_num = prop[0];
>>  
>> +	if (!of_property_read_u32_array(node, "ti,pps", prop, 2)) {
>> +		cpts->pps_present = true;
>> +		cpts->pps_hw_ts_idx = prop[0];
>> +		cpts->pps_genf_idx = prop[1];
> 
> What happens if DT provides an invalid value. e.g. out of range?
> Better to do a sanity check?

Thank you for pointing it out. The pps_hw_ts_idx values range from 0 to 7, while
the pps_genf_idx values range from 0 to 1. I will implement this check and
default to index 0 if an invalid value is provided, along with a dev_err print
to inform this error.

Regards,
Siddharth.
