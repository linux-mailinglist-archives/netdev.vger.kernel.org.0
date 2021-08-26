Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67BE3F85BF
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 12:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241692AbhHZKnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 06:43:06 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:46582 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241276AbhHZKnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 06:43:04 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 2959B206F61A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
 <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
 <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <9b0d5bab-e9a2-d9f6-69f7-049bfb072eba@omp.ru>
Date:   Thu, 26 Aug 2021 13:42:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.08.2021 13:34, Biju Das wrote:

[...]
>>>>> There are some H/W differences for the gPTP feature between R-Car
>>>>> Gen3, R-Car Gen2, and RZ/G2L as below.
>>>>>
>>>>> 1) On R-Car Gen3, gPTP support is active in config mode.
>>>>> 2) On R-Car Gen2, gPTP support is not active in config mode.
>>>>> 3) RZ/G2L does not support the gPTP feature.
>>>>>
>>>>> Add a ptp_cfg_active hw feature bit to struct ravb_hw_info for
>>>>> supporting gPTP active in config mode for R-Car Gen3.
>>>>
>>>>      Wait, we've just done this ion the previous patch!
>>>>
>>>>> This patch also removes enum ravb_chip_id, chip_id from both struct
>>>>> ravb_hw_info and struct ravb_private, as it is unused.
>>>>>
>>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>>>> ---
>>>>>    drivers/net/ethernet/renesas/ravb.h      |  8 +-------
>>>>>    drivers/net/ethernet/renesas/ravb_main.c | 12 +++++-------
>>>>>    2 files changed, 6 insertions(+), 14 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>>>> b/drivers/net/ethernet/renesas/ravb.h
>>>>> index 9ecf1a8c3ca8..209e030935aa 100644
>>>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>>>> @@ -979,17 +979,11 @@ struct ravb_ptp {
>>>>>    	struct ravb_ptp_perout perout[N_PER_OUT];  };
>>>>>
>>>>> -enum ravb_chip_id {
>>>>> -	RCAR_GEN2,
>>>>> -	RCAR_GEN3,
>>>>> -};
>>>>> -
>>>>>    struct ravb_hw_info {
>>>>>    	const char (*gstrings_stats)[ETH_GSTRING_LEN];
>>>>>    	size_t gstrings_size;
>>>>>    	netdev_features_t net_hw_features;
>>>>>    	netdev_features_t net_features;
>>>>> -	enum ravb_chip_id chip_id;
>>>>>    	int stats_len;
>>>>>    	size_t max_rx_len;
>>>>
>>>>      I would put the above in a spearte patch...
>>
>>      Separate. :-)
>>
>>>>>    	unsigned aligned_tx: 1;
>>>>> @@ -999,6 +993,7 @@ struct ravb_hw_info {
>>>>>    	unsigned tx_counters:1;		/* E-MAC has TX counters */
>>>>>    	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has
>> multiple
>>>> irqs */
>>>>>    	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support
>> gPTP
>>>> active in config mode */
>>>>> +	unsigned ptp_cfg_active:1;	/* AVB-DMAC has gPTP support active in
>>>> config mode */
>>>>
>>>>      Huh?
>>>>
>>>>>    };
>>>>>
>>>>>    struct ravb_private {
>>>> [...]
>>>>> @@ -2216,7 +2213,7 @@ static int ravb_probe(struct platform_device
>>>> *pdev)
>>>>>    	INIT_LIST_HEAD(&priv->ts_skb_list);
>>>>>
>>>>>    	/* Initialise PTP Clock driver */
>>>>> -	if (info->chip_id != RCAR_GEN2)
>>>>> +	if (info->ptp_cfg_active)
>>>>>    		ravb_ptp_init(ndev, pdev);
>>>>
>>>>      What's that? Didn't you touch this lie in patch #3?
>>>>
>>>>      This seems lie a NAK bait... :-(
>>>
>>> Please refer the original patch[1] which introduced gPTP support active
>> in config mode.
>>> I am sure this will clear all your doubts.
>>
>>      It hasn't. Why do we need 2 bit fields (1 "positive" and 1 "negative")
>> for the same feature is beyond me.
> 
> The reason is mentioned in commit description, Do you agree 1, 2 and 3 mutually exclusive?
> 
> 1) On R-Car Gen3, gPTP support is active in config mode.
> 2) On R-Car Gen2, gPTP support is not active in config mode.
> 3) RZ/G2L does not support the gPTP feature.

    No, (1) includes (2).

[...]

> Regards,
> Biju

[...]

MBR, Sergey
