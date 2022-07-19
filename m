Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F1957A406
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 18:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiGSQQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 12:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbiGSQQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 12:16:28 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2068.outbound.protection.outlook.com [40.107.104.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAC34F1B9;
        Tue, 19 Jul 2022 09:16:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KY0B3ylJIpH7bU8Oi3YhnHenqiggvGcE741Tv/q+1tJID+UOP31NOXl0Nvl2RD9TXliPpQfTDqM3BypETXngpXYzoCNlLqWgAQwZs1BoWgpeBwMZ5Rxbe3oHHiN5GH0jFWVGwQ6PHrL2B0VgfcxmBCm4jQ8Q5EHAvTkyG3QEH67l63c1ZublH1LzBMLvVj4ETr3gjjYI9B8boAw/W3gIa1VreLNg3VOjNhEJ3V3aowoeg81mJ6ASbtAxNpAYFfR3C8vgZWhVEWfjMner+e/P1WDNpgyJ9DYhk+aF11yTg5rsVQh0lRa6m+wD5CGyMhu4Cs9uM/zVdvEG7DKltJHbIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+j9Ky+rP7rapo2PrnZVB3F9f/nkTtlWqd8uCTeJL+IM=;
 b=V92RP9bESRKUPlw0EQ7sAcutx2MZhXHgWD/zTsK17ZwUQYL8lOwRmogIZ7F1zm9fchVzaASUAIkpcF0s/z4/cytDx9rhob40Dsr8hPgjmEwWlU/pzkE32WZyr1wqPSXQ+rDorH0AZxxj6tIg4ITcQwju57qbOE2NWTpIFN9AkB9AKF3RuCP9jttnb/CyKKoJmR7fZUlXCIgZu5maZDhL8xnvki0uZXI5nje6Mw4jh2yJwf2ZIMExdhh2aMfyQb5eBOjw31VMuF3jvQCMUPn2d4NsHZuuE8kuY+ebQ31gw2JTBpRAVRAs8f5dV3zG2XpxakagkzQPCmo7RUuOVSqKcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+j9Ky+rP7rapo2PrnZVB3F9f/nkTtlWqd8uCTeJL+IM=;
 b=k17k11Rpuigpy1zMCCkQtAgh2nmZ0cOywVV+mF6qJfa5IqcWSyC3aqLfceqW6qImS6kzmI61ADJPMUJGoxk23LUJbB8trHMxk7WltSu3t29SZcafhmTmAfJZw3/CiPf81Artw6mKh3rso0l4Ts3Zs1ZVh1oTsA5+tXBvzUYiZ6wJ/Gr9mwaZZkUPh/aUp83hrdAwuXoqe1iAbGbWOyMRtuQP477TrqbUpfC0EZ9L+wwDFx1bENTdflUghcGHkoHkIJsKoEqJE9htOe1sqUdQgOjc15MortJZFTgVHKvE9SK+UiBfeUt69D02b0vJ/8xMaBnc7FEd/LeQ5PNV/bjV3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2522.eurprd03.prod.outlook.com (2603:10a6:3:69::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 16:16:22 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 16:16:21 +0000
Subject: Re: [RFC PATCH net-next 4/9] net: pcs: lynx: Convert to an mdio
 driver
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-5-sean.anderson@seco.com>
 <20220719160117.7pftbeytuqkjagsm@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <201ba777-f814-0e3f-6e1e-0327934a7122@seco.com>
Date:   Tue, 19 Jul 2022 12:16:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220719160117.7pftbeytuqkjagsm@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0108.namprd03.prod.outlook.com
 (2603:10b6:208:32a::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2795d4f5-0c62-4d91-032e-08da69a2050f
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2522:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mu729P2q1+8S6o+75oTSLKTgrYrY7jgY0RiYvuLLJQVoKST/PiHxR3A2hIldLxm/Tffr7KIx6gdwQcef4+cuRyhIs/yyFXL2hITWhJXnvFAd53rPFVsKn4v3eBF+SS61ZJLVTX5F93mWSgUtJeXeJuYJRc0A3v7ekvPhRuFmk5Hk8RDxzXuT4gw1iaeP23PJ5xy3hhmNS6z8gjkCwL51cAiI5u7tbDJr3h2ay3dVe7HZ2psV9YmavyUz030zQ3g4BNzxqgQdx0+88TqH+BMDXy9MahEqOPjFhaQmpruVvp4EODBDzKonRUDBfoL3DO9qzRPH/HE0EW5c4CSb1CgketVsrGF2Zciyg7nopA4to8Cb5VTAcbT/z43+HS70WgFRQdR7h1cP4dAw5lnXp4Q7VQOp4J3YBDzrixgEtxOzoLDpQtH+qMJ9kFkUFYFRvzkxPjwtRbx3elgdNoBJO5t9Inc63NivMBf5nWRheBVR4xxtKXWopu4iawHuIDH1onlHCP86PNWkFn+JQTFSlf/NqLB1J9m3irScTKt2NGtqdJLBODBU0VY3RVBG9y295d8iP7BXFQ6wRwP8ev8Q6PWtn/v9x+2V2n0Ar4sRmoVARC8j1VJFNv0b1Qm3VZEMhsaDWlv9n1x5d/EGhorB7wvCG8UrjJUsjFVsZKDcJt0kFmylxvYdrUAa13y3Rb+is2PFW8pmtxF5J8O3QVn2DiaWdKDTnPOYzjsptbv8cXA69n5D7peMzCM6ZM7GjZOdk/EaWXBp9TKKXyJJ3uGH1LAe3Oc+A3SMuPhumX4W+ouH6dKDiZGiqS4s2UE7x8fuqbmoss8phukntAo4eX1GCqOKq3Bazv72QYsEx24iuY2oji0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39850400004)(136003)(376002)(5660300002)(8936002)(31686004)(2906002)(7416002)(44832011)(316002)(45080400002)(31696002)(66556008)(86362001)(36756003)(6916009)(8676002)(38350700002)(6486002)(41300700001)(66476007)(52116002)(26005)(6666004)(478600001)(2616005)(186003)(54906003)(66946007)(4326008)(38100700002)(83380400001)(53546011)(6506007)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUI0R1NPMzFpeS9hT0E2M0MyVXF5RjlRTGpQdE1oWnJZTFZycmVOdHVJV2N6?=
 =?utf-8?B?RkhRcTFGK1U4bHg4elBkRnFzM1E1T2ZQRGhWekxLS0JDUVBKMGpnMkxpTHBF?=
 =?utf-8?B?L3FZWGZaMzZ6S3lLWmNkZWFJTGhpcCtVL0tKRko3eEFaRnJ6RFhTMjVGWEtr?=
 =?utf-8?B?SkZoQzdpTDFKdHAwTll0SGRTNnZTOGRFK3p6L1BwUXp4a3BlSUFBR2xWaXNr?=
 =?utf-8?B?V294L1pkQS9nQWM0TXhnL1J0MjdlTFEzRnV4QXpFRTNaTURYbGMzK0JqRHk1?=
 =?utf-8?B?WXhwY3JNS3R1c3FpdjJJcVRhZk9vTFdEVllJc3JadVhhS0s2ZEF2OE1oU0NH?=
 =?utf-8?B?cnd0c1VzYnlhRHRrUHIvcGlOTEJKakw0dENYd3ZnODdld2s3K05obnQ5eEtR?=
 =?utf-8?B?a3hrb2lMS3pOc1AwU3IrMWFDT1JFd25ES1ZISnd0ZkU3S0orRERCSUJGWmpP?=
 =?utf-8?B?Qkpwd3ZIaHh3VlpWNWFBeG5XZ281cG5BNlJnWUcwRTlvTlBLT2gzS3BKckhw?=
 =?utf-8?B?Z25mbXAveWlQNTlGTjVYSm1vSTVQL0wvKzNHSmdFSlJ3cVZCMEw1QXVucktF?=
 =?utf-8?B?T2taa3NOajk0eC9uZzhsTEhlSU9JVUhuRGJTUHJGZ3ZPNjlaRW5wUE8zd3RG?=
 =?utf-8?B?LzVZWWxqMmhCV2hCL1MwVHM0cmJsUWdTS2w5OFA3K3JCZlAzbDAvaEpyYlA4?=
 =?utf-8?B?QUFCdFhSSHRCbTNyM0VRZElFWEZSZ3BIQTBxVlpENDJsSk55TWgzWWtsMjV3?=
 =?utf-8?B?ZEE3YkdSTlNsbG5JSXZTMEVnQjZobytwcHF5ZGpIS3ZjR3o5dE1ZdDBtU1lU?=
 =?utf-8?B?ZHpuSUp2dEtFWXd3Yjl1Vmh1LzEwSHJ3UzhXem53cWZydnNPV2lncTJDMUxQ?=
 =?utf-8?B?SnlUYitjZmp0M1daMEpQNlh6bTNMN2NFT1A2T1dFenR0QnVwbVlsK2NEbWx5?=
 =?utf-8?B?cWZOb09JaVI1bVk1WlBBWkZ3SjgvMk1xTmptZjhsTnhoMGxnSzZTOU5JYklm?=
 =?utf-8?B?Y0ZIS0c2Sm5EdnpnVEZubmkyVnBVOU1PYW1DR2VHaS9XMkhKenE2QW1jQWl4?=
 =?utf-8?B?b0JwK0ZCVXFEazRlWXBmTHhHZHZQVXhKQWxkSTNwdThYcjQ3UWhtRnRYakU5?=
 =?utf-8?B?U0JGQkEwK0Z3dzlrSWtDQTlIUmNqQUhQNjZCL2RrK2x6cTlmdEFuNU5LK0RW?=
 =?utf-8?B?RUdqaXVvRURSNlNsNU45N1psRWs1NWl0T0loM3k3dCtYdnhOcmRpUytQWE5H?=
 =?utf-8?B?ZlY0aEJrQ3BDWXpRVXlyTHR3VVBaS1VuWkVYZVU2a1IvbHpVQ1BtWFVoZldX?=
 =?utf-8?B?bTdyZkdDSDNLWjdWT0duM29ibm5oVW4vMlVMKzBpS045WENZUk1OSGpGK0tY?=
 =?utf-8?B?SWgzTUdnL092VHFRUkRVQytFeEJ0ZUc5bG54dW9rZzBRYmNwU1FBNmJKdWdw?=
 =?utf-8?B?cVpUWWU4TmxjK3VTeUhpNzNPelhkQldMSDBEeWZkZ3FXUnFnT1VXNFc3R0Jv?=
 =?utf-8?B?UzZPV0VuQTJaZnZGVWFUdFB5UXdiQ01lT3ErN3orbXZaWm5BS0greFhqTk9w?=
 =?utf-8?B?U1AyNTRyNzUyakhNZTZSTlBpWDdUUHRyZnNjeExRb09UWkhUVmRqbkRqaW8x?=
 =?utf-8?B?T1E2Y2JtODdhdWx2alF2eGw2TTFhUEtSeTAzRlg4dm5PdHJsYVE4UXFEdXE5?=
 =?utf-8?B?a1VxZWN3NmNpN04yVlpwZ01kdWkvNHF2MzZEUjZzbEVkTHBFZzFlelc1YnV1?=
 =?utf-8?B?M3VYdXhjd2pPVC9QRGVoNEJBbytwMXNJemJ6ZWR2bGVFb0VTVHJUa1lKOEpN?=
 =?utf-8?B?YjY3YkhjUzUzSHQ5M3Rya1ZFRGtyWThzOUpBUTA4Z1NoQWNHVXJJT0JGUU9i?=
 =?utf-8?B?SjFLZnlvQThnYWxlbGtzYkJXMVJmR2tZZ1p5M3VOdzdjQkN6aCs1cUNGNkhq?=
 =?utf-8?B?WW1tYXRKUSs4OHpmZlgydlg0NVdUM2Q3dlZsaTlVcnBCZU1RbUFwaUJSRDA4?=
 =?utf-8?B?NkRvOFAzTzJ6TWNBbS94YU82YjM2VkRtMklubXdrT0IvNUQ3bWRyTkdhM1J4?=
 =?utf-8?B?M0V1U1d5UWJnc3IzdEk0Y0tuNHpHZDQ1Q0J4bzF1azdtR3UwbFNuYWFWNzlw?=
 =?utf-8?B?ZU4rUzY2ZUUrc1ZIZXMwMTVOS2w2WTRCbTU1Vi9naUNkbm1uSlhseUlrQUtR?=
 =?utf-8?B?NWc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2795d4f5-0c62-4d91-032e-08da69a2050f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 16:16:21.9022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rzj9gOHKrnrqAechITgISzojRpe2/yh83227GVju/455kxb8XwgRIgArQmXK2ouXJHWyLPnS2v6VInF2itOAyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2522
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/19/22 12:01 PM, Vladimir Oltean wrote:
> On Mon, Jul 11, 2022 at 12:05:14PM -0400, Sean Anderson wrote:
>> This converts the lynx PCS driver to a proper MDIO driver. This allows
>> using a more conventional driver lifecycle (e.g. with a probe and
>> remove). For compatibility with existing device trees lacking a
>> compatible property, we bind the driver in lynx_pcs_create. This is
>> intended only as a transitional method. After compatible properties are
>> added to all existing device trees (and a reasonable amount of time has
>> passed), then lynx_pcs_create can be removed, and users can be converted
>> to pcs_get_fwnode.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
> 
> I'm compiling and testing patch by patch now. Here's how things go on
> LS1028A at this stage:
> 
> [    6.317357] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000110
> [    6.326219] Mem abort info:
> [    6.329027]   ESR = 0x0000000096000004
> [    6.332815]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    6.338182]   SET = 0, FnV = 0
> [    6.341252]   EA = 0, S1PTW = 0
> [    6.344436]   FSC = 0x04: level 0 translation fault
> [    6.349378] Data abort info:
> [    6.352273]   ISV = 0, ISS = 0x00000004
> [    6.356154]   CM = 0, WnR = 0
> [    6.359164] [0000000000000110] user address but active_mm is swapper
> [    6.365629] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [    6.371221] Modules linked in:
> [    6.374284] CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.19.0-rc6-07010-ga9b9500ffaac-dirty #3317
> [    6.383364] Hardware name: LS1028A RDB Board (DT)
> [    6.388081] Workqueue: events_unbound deferred_probe_work_func
> [    6.393939] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [    6.400926] pc : __driver_probe_device+0x1c/0x150
> [    6.405646] lr : device_driver_attach+0x58/0xc0
> [    6.410190] sp : ffff8000085639c0
> [    6.413510] x29: ffff8000085639c0 x28: ffffb1a2587dae50 x27: ffff2b6943304bc0
> [    6.420676] x26: ffff2b694330c000 x25: ffff2b69433010a0 x24: ffff2b69bf719898
> [    6.427840] x23: ffff2b6941074000 x22: ffff2b6943304000 x21: ffff2b6943301880
> [    6.435004] x20: ffff2b6943301800 x19: ffffb1a259faf3d0 x18: ffffffffffffffff
> [    6.442168] x17: 000000002b64f81b x16: 000000006d50a0b2 x15: ffff2b6943307196
> [    6.449332] x14: 0000000000000002 x13: ffff2b6943307194 x12: 0000000000000003
> [    6.456497] x11: ffff2b69433018f0 x10: 0000000000000003 x9 : ffffb1a2578b1e08
> [    6.463662] x8 : ffff2b6940b36200 x7 : ffffb1a25a0da000 x6 : 000000003225858e
> [    6.470826] x5 : 0000000000000000 x4 : ffff79c76227a000 x3 : 0000000000000000
> [    6.477989] x2 : 0000000000000000 x1 : ffff2b6943301800 x0 : ffffb1a259faf3d0
> [    6.485153] Call trace:
> [    6.487601]  __driver_probe_device+0x1c/0x150
> [    6.491971]  device_driver_attach+0x58/0xc0
> [    6.496167]  lynx_pcs_create+0x30/0x7c
> [    6.499927]  enetc_pf_probe+0x984/0xeb0
> [    6.503775]  local_pci_probe+0x4c/0xc0
> [    6.507536]  pci_device_probe+0xb8/0x210
> [    6.511470]  really_probe.part.0+0xa4/0x2b0
> [    6.515665]  __driver_probe_device+0xa0/0x150
> [    6.520033]  driver_probe_device+0xb4/0x150
> [    6.524228]  __device_attach_driver+0xc4/0x130
> [    6.528684]  bus_for_each_drv+0x84/0xe0
> [    6.532529]  __device_attach+0xb0/0x1d0
> [    6.536375]  device_initial_probe+0x20/0x2c
> [    6.540569]  bus_probe_device+0xac/0xb4
> [    6.544414]  deferred_probe_work_func+0x98/0xd4
> [    6.548956]  process_one_work+0x294/0x6d0
> [    6.552979]  worker_thread+0x80/0x460
> [    6.556651]  kthread+0x124/0x130
> [    6.559887]  ret_from_fork+0x10/0x20
> [    6.563475] Code: a9bd7bfd 910003fd a90153f3 f9402422 (39444042)
> 
> Disassembly of drivers/base/dd.c shows that dev->p is a NULL pointer,
> and dev->p->dead goes right through it. How did we even get here...
> device_private_init() should be called by device_add().
> 
> Curiously enough, mdio_device_create() only calls device_initialize().
> It's mdio_device_register() that calls device_add(). So after this
> patch, we cannot call lynx_pcs_create() without calling
> mdio_device_register().

OK, so presumably we need to call mdio_device_register after mdio_device_create.
I suppose I should have caught this because patch 5 does exactly this.

--Sean
