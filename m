Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E19383AB9
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbhEQRIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:08:10 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:60161
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236000AbhEQRIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 13:08:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuTnDoEBAVa55ZzrFt/sEgaZy6yFUwUnSO+glZStHPkdVukD2BUkb1/XQ16YJOdKqUvtsi+2QQEEWpmqZVV+VEdtTr9sUQv2ppFOpkK/EV2owvboV7w9x4ArrYzSk9BJ9kmQTil/KlVhPrArt5/G3jESW8RIjUh8+RbWUiisv4fy7ZqA7f0YMD2Jali1EcapflI4eB+63lFAHehf0xgW7Ommrn86L0s2wyEiVnpiRar7coyCKGj87FowGQDCTgyWVPCGJmjFZ5+1ZZm0OZ3nIqwDQkK+4AcCFhsp29jNHUYzK6qchLdHLqlr71qy8Chb9c15ZxdFPT95Zi+3byOlJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xgG8GR39MR9Wl+tWjmDK6zOBkdrdA0kJ0iiF7KZKkY=;
 b=CUGqgTguMOTj/EMnIWeXmiAf4tjJoM9kzVoX/sZJtR88d21iNuajnxxFhtFlJK2/55cwRX2OPQM8U9inGOMlH9CWmEs1fCjk+4kidKskcoflpolWw/tbJ791+D1g+TRXuZcdpTe3LMQGrxbWEPvtj6gBpsoW+bQqE0XKqrK88Cx/f1ABPI5nXa/+tqKNOa/F6TbSJB8yDHg4ru7x1lvrhCT3dBWbS+qPVbm7ujpHOU3ZMKhUUPPr1n1oHbzqD9LdVl6ATKuEphkkXkBvg+WofDLR9QSBXO0838qgPk9bs3mt4DXhoB4x11SQbUGGhYlRZsYP5SF82gOjTVssFfhyYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xgG8GR39MR9Wl+tWjmDK6zOBkdrdA0kJ0iiF7KZKkY=;
 b=C2vW4tuFafuRRfNA9K1WgI2eIr/AX/joONS4yOzLY8UAOr1tZABFZTNhqDFqQtP+XJ5mHptsFWn4pFpwSKs8eTN8Yy+TxE3Fh7axVFo/FyN2SB5j4rMvM7v1jwvlmysXcSnuu+DCHNKT30thh6zn+W9SJceUemS1Gl5Jl3PrB3k=
Authentication-Results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8808.eurprd04.prod.outlook.com (2603:10a6:10:2e3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 17:06:50 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387%6]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 17:06:50 +0000
Subject: Re: [PATCH net v1] net: taprio offload: enforce qdisc to netdev queue
 mapping
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Michael Walle <michael@walle.cc>
References: <20210511171829.17181-1-yannick.vignon@oss.nxp.com>
 <20210514083226.6d3912c4@kicinski-fedora-PC1C0HJN>
 <87y2ch121x.fsf@vcostago-mobl2.amr.corp.intel.com>
 <20210514140154.475e7f3b@kicinski-fedora-PC1C0HJN>
 <87sg2o2809.fsf@vcostago-mobl2.amr.corp.intel.com>
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
Message-ID: <4359e11a-5f72-cc01-0c2f-13ca1583f6ef@oss.nxp.com>
Date:   Mon, 17 May 2021 19:06:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <87sg2o2809.fsf@vcostago-mobl2.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [109.210.25.135]
X-ClientProxiedBy: AM0PR02CA0100.eurprd02.prod.outlook.com
 (2603:10a6:208:154::41) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.18.89] (109.210.25.135) by AM0PR02CA0100.eurprd02.prod.outlook.com (2603:10a6:208:154::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 17 May 2021 17:06:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f842913b-9fb1-4b2e-73a0-08d919562930
X-MS-TrafficTypeDiagnostic: DU2PR04MB8808:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB8808D715E3326F65CD0CB5E3D22D9@DU2PR04MB8808.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aFFLggBzjvFuOLGc0AUguhAyBOi3H9/5jpEgW8HHSPWG6RdU09w0j6ROsZpdIVkYRBWoxdFJkPsrXeaC1WukHBCHmm3fpeuezhBBXips5swARo0UbDJ7XOT2qOoLMcV5l+19ufE3oahNl1Q61RWnrQniTj8CB5l2Tg0Y6ib9oKvEbBPeU3QJqhHHwp8UkHUdL3kcZyiZfta8FtaKm86c7jeCCnUeStIyjqbgUYJJ46mqSc6EXBY7/QoQuV0nhtOgv1NqcGzipsAuzyL/JMjUsc3eOdsEtfxAY9o8mR5AZnOEb9vytP/CtUYKQf12CYQ7Zy8wuPwIg4kW/zPSHFIesmpMRpvHZ4ToS/BBgrEaHs/slgFdtMYbiy/YZCIc8ZtJaKHzqT7f2deQmkttL2DN/O9AcLIdA+MgisH7Ykl72bPvztr15oVCZRiMhNMShx+gjJDMvug5q3h03bTIrp9sEtPKktyiQqqlFyqpCpoMx5ekd6ZWKftXvF8NW26LFBwC0x5c9OHvhcfODuqbpG3YxLCmPp+sO7LmmhyxoWvrIBHIUsWNFYFd/pxlLvM77Snoj/QG3AsqlCJ3WqfgutzkR1ZzxNbdycVUnYllIQ3y5zaOl0BvwidJXT55gxYltusnjAxj7uoiIv8HzBCo8LQ71HrncxZ0SZObxxcrecQGjSEgQ17ZM7IcFxklcbmQb1ggZK/hQTHiaRmWRyqyaV+HYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(956004)(2616005)(4326008)(38100700002)(31696002)(38350700002)(53546011)(66476007)(2906002)(7416002)(31686004)(52116002)(86362001)(44832011)(6486002)(83380400001)(66556008)(8936002)(16526019)(54906003)(316002)(16576012)(8676002)(110136005)(5660300002)(26005)(478600001)(66946007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cWhOL2xnSzgrM2NsMEZCclFVVmhxTUY0YXZmb0pJeXZSR3lUY1NkemoyVWFw?=
 =?utf-8?B?WXZlZk8ycjZYSVRlMlVHc1M2R0dRdENLZ05oL0RoZU43TG90WWVocks5RnJI?=
 =?utf-8?B?S1ExYVQybEttN3NJNXhhejdteUYzSDJZTXd6c2hoSFg2d3V1WXAxc3owNlhY?=
 =?utf-8?B?TlRBWi9qc0ZaY1M5VVdyanNaZFBNMndaaFhlWVBDTE1WaWdNTjdIRjE4VFFE?=
 =?utf-8?B?R0RBbi9oRHFQUHRUY1NNU080MVRjbzhiMHJGVWI4VmRZV2FTOEg1YzFvWGpD?=
 =?utf-8?B?c3l2empaaTh2YUtsME1XSDM2blNQWXNVMldqQ0Z5QThma25sZ1pqT3Jud3A4?=
 =?utf-8?B?L2pKY092bmZQOXJIdGlRR0FqaWIrMjBPVmV4RVlYOWJ2SlEvaGlTU21JdnBV?=
 =?utf-8?B?dG9CeFpyb2xrUW9kZ0FHTFhzNnpMRDk4SmY1UitQUk9uU3VOcXliaGFva1Mx?=
 =?utf-8?B?YllpSnhtV2hSYllMV0YyTHVTY2VaVTJ3b3E2dkhqTmxQK3VxTzF1VWNENitk?=
 =?utf-8?B?dlgydjUwL2JCYk50emoybHkwMzFPdDYyT2lGVkt1TmVtRjVJVmNibmdSZG94?=
 =?utf-8?B?WEpkL1dOMnJjQ0NXbHQzVU1TWDBFRHFuWFVXZWJvRG45akJZUFFsU2hET1hI?=
 =?utf-8?B?L1Bra0pmTm1CeXFHZWgzc1lDVzlacXJud09Gb1RYVGhvVFBpOFBxQ0hNcmFN?=
 =?utf-8?B?M3JHSGJ5am1sVGt4K2Z0MDBoeTcrcUZTQzJ5cU5qSERwRUFaeURMSjFTdi92?=
 =?utf-8?B?blgzVW5qNTBKYlRFeVFsdGg3bFd1Zm5xL3VYdS82Y1ZsdXFtL2VneEdtV243?=
 =?utf-8?B?b3JKR1pEVnNBRGpPWVI2MW1sdHFmelhKcmJ0RXB6SHBmd25BMGg5aUhxVU5M?=
 =?utf-8?B?bFNFM2I0MWVrRk8waTRlek5scnd6NE9GeXU0WEl3WlFpTlJNN2lsUUl6V0JR?=
 =?utf-8?B?NzZ4TUlMS0NYZ1JrR2ZGbXovUzNiSzMvLzJ1akFsVzdkZU5OTnZrajZVVUFn?=
 =?utf-8?B?SnlESEVJZlFTY2xpVzRMWlRWVzF2Z09hZzhQZTRmUnVVRThMOUJNRERDbXBC?=
 =?utf-8?B?V3J4N1NzOEp0d0VWYUlRaURiVXpLVEExM001YUlEU1FhNGVYT2xwLzBJTVoy?=
 =?utf-8?B?bjM1bjhLZEZLeFk0V0Vsd0VJT1QwY0RHOVJUcS8weFJ3djJCUWp3UmVDQSs3?=
 =?utf-8?B?VnYzbDNzK0EzcnZ5WWZwdjJBZGxYMGwxUFIzd0FENTB1T1Mvb2cxNGRUWVMz?=
 =?utf-8?B?NVhtbmU5bmFXbkRSWFBRQWNlcG42YkwxWGNzRUpqcC9VbmhaYmZTOEFDOE8y?=
 =?utf-8?B?Q1c0dlNjQXJ2Y1FjSXNMbTZCSjJJUlJBWHpRZWw0YzBmRG0zWGxMWmNxNi9W?=
 =?utf-8?B?aERheklGRjRpZ1FQT1VnSlNqZ1NWMktrNG5LWFIzeHJpNUEvMTZSVFIyNUpU?=
 =?utf-8?B?d2NNb2tEaHlEY0pLNS9COWk4QzFWYkNmOFEwZ1Jac0tiQ09pQzlvRzJnRXRN?=
 =?utf-8?B?YlBKZDkyYkJGS3dvQ0tEWHBNeFY2cXcvR0FickJYNnNHVm9FYzhlbTVmaklm?=
 =?utf-8?B?Ti9vVFhhTko2WjBlbW1ZZmJjZW83SVZGTWxPUHZnbk4wNldJOHhZaWp1NmJG?=
 =?utf-8?B?TG9WRXI2ZHArd3RvczF6Qnd2VzVMWGJBVy91a0xVUUN6UXZ0Tzd0UkRSUm1v?=
 =?utf-8?B?VnZQVmFjQmsycms1c1pFYTVVL1FYQVRMUldvVDJwTnp6TkRReHlhVlVOSnFL?=
 =?utf-8?Q?QW8JBJuTpnnePFI30cQ3S42nKjRpY/099VSnQLz?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f842913b-9fb1-4b2e-73a0-08d919562930
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:06:50.0928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MRfC5NAi6NCHMLyhE8LjNY9/CgB97ZCc11vajZ1AG4PYw2NEXeEcwNiK1SgOe/48MeaUsWi45PMWVn2wjd6oTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8808
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/2021 1:47 AM, Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
>> On Fri, 14 May 2021 13:40:58 -0700 Vinicius Costa Gomes wrote:
>>> Jakub Kicinski <kuba@kernel.org> writes:
>>>> You haven't CCed anyone who worked on this Qdisc in the last 2 years :/
>>>> CCing them now. Comments, anyone?
>>>
>>> I guess I should suggest myself as maintainer, to reduce chances of this
>>> happening again.
>>
>> Yes, please.
>>
>>>> This looks like a very drastic change. Are you expecting the qdisc will
>>>> always be bypassed?
>>>
>>> Only when running in full offload mode it will be bypassed.
>>>
>>> And it's kind of by design, in offload mode, the idea was: configure the
>>> netdev traffic class to queue mapping, send the schedule to the hardware
>>> and stay out of the way.
>>>
>>> But as per Yannick's report, it seems that taprio doesn't stay enough
>>> out of the yay.
>>>
>>>> After a 1 minute looks it seems like taprio is using device queues in
>>>> strict priority fashion. Maybe a different model is needed, but a qdisc
>>>> with:
>>>>
>>>> enqueue()
>>>> {
>>>> 	WARN_ONCE(1)
>>>> }
>>>>
>>>> really doesn't look right to me.
>>>

My idea was to follow the logic of the other qdiscs dealing with 
hardware multiqueue, namely mq and mqprio. Those do not have any 
enqueue/dequeue callbacks, but instead define an attach callback to map 
the child qdiscs to the HW queues. However, for taprio all those 
callbacks are already defined by the time we choose between software and 
full-offload, so the WARN_ONCE was more out of extra caution in case I 
missed something. If my understanding is correct however, it would 
probably make sense to put a BUG() instead, since those code paths 
should never trigger with this patch.

OTOH what did bother me a bit is that because I needed an attach 
callback for the full-offload case, I ended up duplicating some code 
from qdisc_graft in the attach callback, so that the software case would 
continue behaving as is.

Those complexities could be removed by pulling out the full-offload case 
into its own qdisc, but as I said it has other drawbacks.

>>> This patch takes the "stay out of the way" to the extreme, I kind of
>>> like it/I am not opposed to it, if I had this idea a couple of years
>>> ago, perhaps I would have used this same approach.
>>
>> Sorry for my ignorance, but for TXTIME is the hardware capable of
>> reordering or the user is supposed to know how to send packets?
> 
> At least the hardware that I am familiar with doesn't reorder packets.
> 
> For TXTIME, we have ETF (the qdisc) that re-order packets. The way
> things work when taprio and ETF are used together is something like
> this: taprio only has enough knowledge about TXTIME to drop packets that
> would be transmitted outside their "transmission window" (e.g. for
> traffic class 0 the transmission window is only for 10 to 50, the TXTIME
> for a packet is 60, this packet is "invalid" and is dropped). And then
> when the packet is enqueued to the "child" ETF, it's re-ordered and then
> sent to the driver.
> 
> And this is something that this patch breaks, the ability of dropping
> those invalid packets (I really wouldn't like to do this verification
> inside our drivers). Thanks for noticing this.
> 

Hmm, indeed, I missed that check (we don't use ETF currently). I'm not 
sure of the best way forward, but here are a few thoughts:
. The problem only arises for full-offload taprio, not for the software 
or TxTime-assisted cases.
. I'm not sure mixing taprio(full-offload) with etf(no-offload) is very 
useful, at least with small gate intervals: it's likely you will miss 
your window when trying to send a packet at exactly the right time in 
software (I am usually testing taprio with a 2ms period and a 4µs 
interval for the RT stream).
. That leaves the case of taprio(full-offload) with etf(offload). Right 
now with the current stmmac driver config, a packet whose tstamp is 
outside its gate interval will be sent on the next interval (and block 
the queue).
. The stmmac hardware supports an expiryTime, currently unsupported in 
the stmmac driver, which I think could be used to drop packets whose 
tstamps are wrong (the packet would be dropped once the tstamp 
"expires"). We'd need to add an API for configuration though, and it 
should be noted that the stmmac config for this is global to the MAC, 
not per-queue (so a config through sch-etf would affect all queues).
. In general using taprio(full-offload) with etf(offload) will incur a 
small latency penalty: you need to post the packet before the ETF qdisc 
wakes up (plus some margin), and the ETF qdisc must wake up before the 
tx stamp (plus some margin). If possible (number of streams/apps < 
number of hw queues), it would be better to just use 
taprio(full-offload) alone, since the app will need to post the packet 
before the gate opens (so plus one margin, not 2).


>>
>> My biggest problem with this patch is that unless the application is
>> very careful that WARN_ON_ONCE(1) will trigger. E.g. if softirq is
>> servicing the queue when the application sends - the qdisc will not
>> be bypassed, right?

See above, unless I'm mistaken the "root" qdisc is never 
enqueued/dequeued for multi-queue aware qdiscs.

>>> I am now thinking if this idea locks us out of anything.
>>>
>>> Anyway, a nicer alternative would exist if we had a way to tell the core
>>> "this qdisc should be bypassed" (i.e. don't call enqueue()/dequeue())
>>> after init() runs.
>>

Again, I don't think enqueue/dequeue are called unless the HW queues 
point to the root qdisc. But this does raise an interesting point: the 
"scheduling" issue I observed was on the dequeue side, when all the 
queues were dequeued within the RT process context. If we could point 
the enqueue side to the taprio qdisc and the dequeue side to the child 
qdiscs, that would probably work (but I fear that would be a significant 
change in the way the qdisc code works).

>> I don't think calling enqueue() and dequeue() is a problem. The problem
>> is that RT process does unrelated work.
> 
> That is true. But this seems like a much bigger (or at least more
> "core") issue.
> 
> 
> Cheers,
> 

