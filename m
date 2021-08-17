Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E6D3EF031
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhHQQb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:31:27 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:41324 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbhHQQbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 12:31:21 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 760B020CDD44
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next v2 8/8] ravb: Add tx_drop_cntrs to struct
 ravb_hw_info
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
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-9-biju.das.jz@bp.renesas.com>
 <24d63e2c-8f3b-9f75-a917-e7dc79085c84@gmail.com>
 <OS0PR01MB59220310BBD822BB863F642786FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <9b09e2ba-4e92-6e1e-e26b-c2a3152f7fe4@omp.ru>
Date:   Tue, 17 Aug 2021 19:30:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59220310BBD822BB863F642786FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 8/17/21 6:47 PM, Biju Das wrote:

[...]
>>> The register for retrieving TX drop counters is present only on R-Car
>>> Gen3 and RZ/G2L; it is not present on R-Car Gen2.
>>>
>>> Add the tx_drop_cntrs hw feature bit to struct ravb_hw_info, to enable
>>> this feature specifically for R-Car Gen3 now and later extend it to
>> RZ/G2L.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>> ---
>>> v2:
>>>  * Incorporated Andrew and Sergei's review comments for making it
>> smaller patch
>>>    and provided detailed description.
>>> ---
>>>  drivers/net/ethernet/renesas/ravb.h      | 1 +
>>>  drivers/net/ethernet/renesas/ravb_main.c | 4 +++-
>>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index 0d640dbe1eed..35fbb9f60ba8 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>> @@ -1001,6 +1001,7 @@ struct ravb_hw_info {
>>>
>>>  	/* hardware features */
>>>  	unsigned internal_delay:1;	/* RAVB has internal delays */
>>> +	unsigned tx_drop_cntrs:1;	/* RAVB has TX error counters */
>>
>>    I suggest 'tx_counters' -- this name comes from the sh_eth driver for
>> the same regs (but negated meaning). And please don't call the hardware
>> RAVB. :-)
> 
> Agreed. Will change it to 'tx_counters' on next version and comment it as
> /* AVB-DMAC has TX counters */

   The counters belong to E-MAC, not AVB-DMAC.

> Cheers,
> Biju

MBR, Sergey
