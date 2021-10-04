Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4254216D4
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbhJDS4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:56:23 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:51992 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbhJDS4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 14:56:19 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 0D8E422D1FAC
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 07/10] ravb: Add tsrq to struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-8-biju.das.jz@bp.renesas.com>
 <5193e153-2765-943b-4cf8-413d5957ec01@omp.ru>
 <e83b3688-4cfe-8706-bd42-ab1ad8644239@gmail.com>
 <OS0PR01MB59220CAF5B166D4E6887B63486AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <a4c96650-7836-26db-7e12-44ae56dca15a@omp.ru>
Date:   Mon, 4 Oct 2021 21:54:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59220CAF5B166D4E6887B63486AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/21 9:47 PM, Biju Das wrote:

[...]
>>>    The TCCR bits are called transmit start request (queue 0/1), not
>> transmit start request queue 0/1.
>>> I think you've read too much value into them for what is just TX queue
>> 0/1.
>>>
>>>> Add a tsrq variable to struct ravb_hw_info to handle this difference.
>>>>
>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>>> ---
>>>> RFC->v1:
>>>>  * Added tsrq variable instead of multi_tsrq feature bit.
>>>> ---
>>>>  drivers/net/ethernet/renesas/ravb.h      | 1 +
>>>>  drivers/net/ethernet/renesas/ravb_main.c | 9 +++++++--
>>>>  2 files changed, 8 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>>> b/drivers/net/ethernet/renesas/ravb.h
>>>> index 9cd3a15743b4..c586070193ef 100644
>>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>>> @@ -997,6 +997,7 @@ struct ravb_hw_info {
>>>>  	netdev_features_t net_features;
>>>>  	int stats_len;
>>>>  	size_t max_rx_len;
>>>> +	u32 tsrq;
>>>
>>>    I'd call it 'tccr_value' instead.
>>
>>     Or even better, 'tccr_mask'...
> 
> We are not masking anything here right.

    We do -- we pass the TCCR mask to ravb_wait().

[...]

> Regards,
> Biju

MBR, Sergey
