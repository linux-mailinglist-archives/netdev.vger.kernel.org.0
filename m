Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE12459660
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 22:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239730AbhKVVKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 16:10:18 -0500
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:51392
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231215AbhKVVKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 16:10:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PA6wmEbvf/5+4UYJPaa6bhKe+OPgJk4OScWXWy0gS5WiiJTs24z7itFdZwelWKjyfGPIRT5GzMDJxGrQ0F/bn8mvkU/gmgeo3HGEkpHhGUaLQAf8ehMCut3zICqmnUKIfKolthWROtqO5sXV/ohaU0S2sjcFMl+rDJkS0PGssyIEx32f4IcGs+hzpX51oyNuZr1u0N8bwIMcbHmcpvZD22vBP0thw2Wb709VeNLkJTWjQWM8Ur4OwEo/NSs6MOEA4JoOHDprPaJz2qB/cA++YGI85g53i6h3Vv535BOS+N2D6x6lVq8F3dLcBHUjizLUdIG7swxehPlP0qs2cS/ZtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2ZRxJH5eFKvNeUbhZydJKxqe28jodmEcb47YIF9VH8=;
 b=Krr19fqfVZdTlPY2+FAgjVd15laPyAYsBfuRXD5pvaIF2CEmcdA4fU98hu7lxEB5waXguP904YbbIXh67FZPBTzKvrm0ooyJovJOsyFvFhailnsY3dzdY6gdk1aWU1PI1r6QtHGmjSXgeQY+IQWTRDX8NNa4hu0MINBgkSgdHMYFTNrKqeAmKayBNdYoPJaemVamieW7SIMdZaYurCaLI9zNJnk0fakMUrIX5lrQE6MKuslrIZ8Kxlqkg3nHBhkZ+oN9k1U9W40uKwiuAMzqcLhi1oD6HghbPzSfwcYMnYDACv1dD2XL1azfQQ2eIzxsBx9XGnXhsnczsCaV6BR3cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2ZRxJH5eFKvNeUbhZydJKxqe28jodmEcb47YIF9VH8=;
 b=3/VeRWclcxRx6Ps9Hgv2bDtnlxSGHEn+sp6EG9YRF+Lo8N0wm3raf81yzQ3k3pQXBxVUURTUya3VDS51zNRw2793iXACMjFoHnS4PrhYw+nlxnfIWhofc5xzscjkOHZILbhKVOOf09xhtQ6gvmRFvWrd/EDK2A2lZONoSVp2WwM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4985.eurprd03.prod.outlook.com (2603:10a6:10:32::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 21:07:07 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 21:07:07 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [net-next PATCH v6] net: macb: Fix several edge cases in validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Parshuram Thombare <pthombar@cadence.com>,
        Antoine Tenart <atenart@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Milind Parab <mparab@cadence.com>
References: <20211112190400.1937855-1-sean.anderson@seco.com>
 <YZKOdibmws3vlMUh@shell.armlinux.org.uk>
 <684f843f-e5a7-e894-d2cc-3a79a22faf36@seco.com>
 <YZRLQqLblRurUd4V@shell.armlinux.org.uk>
 <YZZymBHimAhx8lja@shell.armlinux.org.uk>
 <cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com>
 <YZfzSQBECA3Ew+IE@shell.armlinux.org.uk>
 <YZvsTgN8Cx5c1Uta@shell.armlinux.org.uk>
Message-ID: <e86ad436-cb35-d059-6ce6-f88f50b4b676@seco.com>
Date:   Mon, 22 Nov 2021 16:06:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YZvsTgN8Cx5c1Uta@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0335.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::10) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1PR13CA0335.namprd13.prod.outlook.com (2603:10b6:208:2c6::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend Transport; Mon, 22 Nov 2021 21:07:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c37fddd-01ff-4148-806c-08d9adfc0a72
X-MS-TrafficTypeDiagnostic: DB7PR03MB4985:
X-Microsoft-Antispam-PRVS: <DB7PR03MB49851BE3D74662EFE9A28E3A969F9@DB7PR03MB4985.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hccaJb/QYyyONkyLiW4ApAN131f3/BZH+76nHfac3XPOv8Xm9N7dsM/1w6vpbtBqke0gdFLF57Z656YWbLYxhsRsR0auj9nM6oh+MorNH6fpyXjx2tRLR752Bdbfg9dtwS6Z/qj185+unQD3WNzlTzss+38pa5oqWwc+pJhPiw4/mwjoNxEtvwzXO0JEqMrC59Z2zAUErUjItLBsJWlp3N/TOCNdgI0tqUppIgOxqUpwfsGwyDoTNN0CK0+BVFrd6CnC2/zczRmq+eegZUuxcwLExP244rw79MnRQ+NxY+Gu/uvO33y/9WRoInKoXSnmfbO59u9Xn1Oluw1Hml+d/1T2z1kfWrdtp4HPHUHqivvZdJNm6jvd9W1cD0WYl6jBYvtCUD54292yb7WFyQqrEMakXBbpEStaWeRuGKvH7aQS7gfaNbPMCEVSqSFepRYCZLWcETkGhblahFOH7bhnlSz8+x5ThRi8LFASJLg7XncD6U5yOur67DlY4uQahjxAcOJ4b07+hE1wf3wa4UWHv7EDa2vPQbWbAPSdXsAf7CUQsUleeQzF8okfIUNUfuZyQZbcXN4d6PN352Z0zzlhDhwVCTNQNgdkMN9gms0QCpXvWM0aNp2IPZvRiVIKRDJP3IT3VnwGWLxQM6qEVmM+QrvC9/bVbOvrGwUAkVHTX6QZev5uMY9IkPor0SjCrrwNKuhgUpGMCT/PdtScHudDR3yyt4XVPx+rkRfbCVwcgu1ArJYjU/fHKznQVocheYP6KGBZU/DFHZ6ILFePJ689wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66574015)(66476007)(66556008)(186003)(66946007)(31686004)(83380400001)(36756003)(31696002)(44832011)(8676002)(508600001)(38100700002)(38350700002)(86362001)(2906002)(316002)(956004)(15650500001)(8936002)(5660300002)(6916009)(6666004)(16576012)(54906003)(2616005)(6486002)(26005)(53546011)(52116002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eG8zMktBSnBtV05FclRoS2VsNm1PZGxaeGxMT0RwdFFKL1lNNm5yeWlHNWdD?=
 =?utf-8?B?L1BlUTdBQy9sTUJ0dVUzYmNoSEMrczJtRnBnbGtXMHd0TGw1Q2RoUWYyZ2lN?=
 =?utf-8?B?ZittZ3o0NUp4c3plaU11eE5HK2xiTWFtbUs3Vnhoa0JwNFpmY0hoTzJOakFE?=
 =?utf-8?B?ZkNSSGt4MjdJYStiV2xpUjJDSkF6ckdKc2FRMVk2UGcwV202NFpHNUVvYS9M?=
 =?utf-8?B?UlY4VWNWODE0dWVMVy9pdVMzOWpzMWxjaldPV0ExQWN2OGxKSVpUSkIwb0N2?=
 =?utf-8?B?amExM2g3dEp0Q3k0WU9iZm1hd3AvNWpIZm9PbUhqQkFabkROZEUwdzdXazIz?=
 =?utf-8?B?akNvZ3BrbS9ndlp1TGhJbHFnelNSRVVscDVtckxhTE1Bc3NwN3pkc2x1TlhU?=
 =?utf-8?B?R2cxYlRNelVGL3hCT1YxREYwcG5tVUNWZGNKbkl1d3ZGVUxqMTBYMFBqamU4?=
 =?utf-8?B?MlNMR0c2TDZ5QTVYVnlmanREYWdOUDZuOEtBcW9VK1h2dzJkcW01cVkvQ29n?=
 =?utf-8?B?ZTZMaThxZ3FET2VJQ2lZdE9kYVlMNTBRSzZtc1Z3cVdzb3ZNdmd5WGxENjBB?=
 =?utf-8?B?TGNkSUFPUWVzN3V6STlwRGd3bkpKNTh3QkU1ckpObnpmUHBXNVc4NGdoTmIr?=
 =?utf-8?B?NmVXNGZTcUw1d2JsNlMrVnNNY0EvN3l3bFUzRWFndVZ3RGEwekFTV1lQc05p?=
 =?utf-8?B?V21xanZiWjZSQ0xuNGxKekQ2SDl3bHhlZjZsbjJ4OG5UbVNra3J6RTZ5K3RR?=
 =?utf-8?B?a3BYdU4ybzRZUy9ncnRUMUZiR1U4MXliSTB6ZTBvS2JWTDU3YlNPdGdwSU03?=
 =?utf-8?B?NU5MeWkrcUJxamVnaDRPQmJuOTR4bktkOG1PeWcxT3AyVTlSSEFRY3BET0ZM?=
 =?utf-8?B?Q1ZuWkw3Zk4xdDg5bXRwQ2JDWGZwUFdJN2piVWxYS2IxSGRXR2pCY0wxTHNo?=
 =?utf-8?B?VUt5dUVDdXVKeXIyZEJxVFVGdml1SlVONnhmMDFGVEpDV0YxUHVaYTN2ODM0?=
 =?utf-8?B?cityTWZsSXN0anNSRWVLZVl5YmJ6Zy9qdXRmV2dZYWxWWXYvVkpzcjJpc295?=
 =?utf-8?B?M0xHMmJwVkhzQTNYUS8rUFkzRnJxZFN4TnRkSDZUVlZGcVNhSitBRTRXMStl?=
 =?utf-8?B?ekhqMTZxOVJYTFhWMDVzK3hadzNLblBpK216eU9ORzVwTHZ4UWVwV2dlQkRw?=
 =?utf-8?B?dkRCTmVNRWR0ZEdwOFhFWHFGWm10N3FQSVdvaGJWcXJmL0FGT0g1alJjcDI4?=
 =?utf-8?B?SWJrVHo5YVBjTUg4cG9JYnc3dHJ5cFRxV3BMUUVKTkhjWnRVdktuSnRDZ1dk?=
 =?utf-8?B?eG9VYWRtYXhuUHFxZjFjSFR3Q2o0RFN1ODVBT3BHMDQ1VUtCOSs3OHUwRzBI?=
 =?utf-8?B?eWY0b1VPY0xFbE9rNnpYRlh1U1RiQ21sNGlHR0xUYW5UeVpTMHZPTzA4T0pq?=
 =?utf-8?B?T1dhMEhzNkRjOC8vcVNYZ1cwME80MXhtQ05qeEtndXlocTN1QXAwU2NYVHc2?=
 =?utf-8?B?ek9ySkNkQVdScXloUVNHb2ZYSzFldGxPNGJ3U1VGRE1hWG15MGdONzZKTFcr?=
 =?utf-8?B?dEpVZ2ZEb0cxSFF0Njc4MkRTRHFoTkxyb1FPNzlheDN0dTRSSC91VVlaTkdh?=
 =?utf-8?B?bGlHTDJJbzkvL0tmbmRBZndST1QzRTA0NkZsUDBMN2ZtVTR6dmpDWWpPUHhM?=
 =?utf-8?B?UHhxQTZXZmxleWxKMkZwcitheVNQWGd0a1NxYmVCenRLY2hpc25ubHZqRkdB?=
 =?utf-8?B?bndMdGI2NS9lY0MyeVFlQ296cjlWZDgxZ1BCZVhKUkp2VVVOdVZNTXFsL3BR?=
 =?utf-8?B?UEJLdDJuQlJ1Skl5STFWWlBNSmtidmNib3hRYnU4TnQvdFpWZnZFclpwTGMv?=
 =?utf-8?B?bHhaSERMQ0dVaHc4VHRCY0ZlMXpTWUlPNW1lcGlOaVBxL0lYRnplNU84d1RS?=
 =?utf-8?B?VU16WkYxblBBKzRSZVVJMkZVSWhNSmFwcS90SWZCeHhTTFZ2MW9abGRMMHYr?=
 =?utf-8?B?RndpMWp1dlBIalY0emxvTzdkdXNPZU9tNTlqV0RSencrSkgrNjRCYVpSbTBo?=
 =?utf-8?B?VE5hS2FKNzBGc0ZEc3l3VDFUWm1sWTlMWFdLd21ISitkenRwQVJiSFc5cXYv?=
 =?utf-8?B?bXMwSGxpVmpmU1VvcDZ5WmRKcFBZZXY2aXYzMXA3TXJuMXFCWlEzRlR1T3NF?=
 =?utf-8?Q?5cxVO+ibwHuYWtY10t9IT9Q=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c37fddd-01ff-4148-806c-08d9adfc0a72
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 21:07:06.9834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K+EGcN4KptuxSkzr2N1xCDpgusVex1Zs6Cw24J0Vh9Clx2kok2glnlzXXiqYGd8QuIzKvEfYSvXDkAvwQDJLVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4985
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 11/22/21 2:15 PM, Russell King (Oracle) wrote:
> Hi Sean,
>
> Today's update...
>
> On Fri, Nov 19, 2021 at 06:56:09PM +0000, Russell King (Oracle) wrote:
>> > Say that you are a MAC with an integrated PCS (so you handle everything
>> > in the MAC driver). You support GMII full and half duplex, but your PCS
>> > only supports 1000BASE-X with full duplex. The naïve bitmap is
>> >
>> > supported_interfaces = PHY_INTERFACE_GMII | PHY_INTERFACE_1000BASEX;
>> > mac_capabilities = MAC_10 | MAC_100 | MAC_1000;
>> >
>> > but this will report 1000BASE-X as supporting both full and half duplex.
>> > So you still need a custom validate() in order to report the correct link
>> > modes.
>>
>> First, let me say that I've now been through all phylink users in the
>> kernel, converting them, and there are seven cases where the generic
>> helper can't be used. The validate() method isn't going away (at least
>> not just yet) which allows unexpected situations to still be handled.
>> The current state of this conversion is as follows.
>>
>> In terms of network drivers:
>>
>> mvneta and mvpp2: the generic helper is used but needs to be wrapped
>>   since these specify that negotiation must not be disabled in
>>   "1000BASE-X" mode, which includes the up-clocked 2500BASE-X.
>
> Over the weekend, I've been able to eliminate these two with the
> mac_select_pcs() method, and adding a pcs_validate() callback to the
> PCS operations. The updated patches are in the net-queue branch.

That looks good. It looks effectively the same as what I'd prototyped.

>> > > > Right now, "no pcs" is really not an option I'm afraid. The presence
>> > > > of a PCS changes the phylink behaviour slightly . This is one of my
>> > > > bug-bears. The evolution of phylink has meant that we need to keep
>> > > > compatibility with how phylink used to work before we split the PCS
>> > > > support - and we detect that by whether there is a PCS to determine
>> > > > whether we need to operate with that compatibility. It probably was
>> > > > a mistake to do that in hind sight.
>> >
>> > Of course it's an option :)
>>
>> I'm saying that with phylink as it is, phylink does _not_ support there
>> being no PCS in a non-legacy driver, since the presence of a PCS is a
>> flag that the driver is non-legacy. It changes the circumstances in
>> which the mac_config() method is called.
>>
>> If we want the PCS to become optional, then we need phylink to deal with
>> detecting non-legacy drivers some other way (e.g. a legacy-mode flag in
>> struct phylink_config), or we need to eliminate the legacy drivers by
>> either converting them (which is always my preference) or deleting them.
>
> ... and over the weekend, I've implemented a flag "legacy_pre_march2020"
> which is used to flag which drivers predate the changes to add PCS
> support, allowing phylink to know whether they are legacy drivers or
> not irrespective of whether they use a PCS.

Thanks for clarifying this. It was always a little unclear to me exactly
what the implications of unregistering a PCS were.

> So, I've updated the "mac_select_pcs" patch to allow NULL as a valid
> return, and use error-pointers to indicate failure.
>
> Then there's a following patch that adds a "pcs_validate" method which
> gives the PCS an opportunity to have its say in the MAC validation
> without the MAC having code to call the PCS - this change allowed mvneta
> and mvpp2 to use phylink_generic_validate().
>
> So, this is another step towards the end goal.
>
> I'm planning to get lkp chew on the "legacy_pre_march2020" before I send
> those out to netdev (which will be the next batch of patches), and then
> will be the patches that add the ground work to allow DSA drivers to
> become properly non-legacy.
>
> Please have a look at my net-queue - are you happier with the
> mac_select_pcs method now?

Yes. This looks like it can be implemented reasonably. I'm going to hold
off on working on Xilinx PCS for now and wait until your changes have
made their way upstream.

> Once we've got this settled, and remaining drivers converted, my plan is
> to kill off the old .validate method entirely. At that point,
> "mac_capabilities" then becomes exactly that - the capabilities of the
> MAC block irrespective of anything else.
>
> Given bcm_sf2, I may need to add a method which allows the MAC to modify
> those capabilities depending on the interface - bcm_sf2's pause frame
> capabilities appear to be dependent on the interface mode. I'm tempted
> to reverse the logic I have in bcm_sf2 in these patches - set
> MAC_ASYM_PAUSE | MAC_SYM_PAUSE in mac_capabilities, and exclude them for
> interface types that don't support pause frames.

Yeah. I like how phylink_get_linkmodes allows for modifying the
capabilities if necessary.

Thanks for reworking this stuff. I think this will make it a lot easier
to get my changes upstreamed :)

--Sean
