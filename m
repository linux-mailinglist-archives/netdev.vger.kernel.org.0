Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111C763C5FC
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbiK2RBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbiK2RAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:00:46 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2049.outbound.protection.outlook.com [40.107.8.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407E01A237;
        Tue, 29 Nov 2022 08:57:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbWzDrqgLx1kxRnDa6kqVqS0NvaDt6OflK9XcJkI5dYuwas3klzRcTCt6Vh2M7q3xayxQqmKMXRIuhSdzxBGlo79a7JWKo4hRwngPYCx9tlbN+bAmywnCUmPWjlR6gtJlr/jNmWTsodaXqUFmP96XC2tXNcUtepAg5i0iugAd+/aXtL+28JPMo7rKACA13Ey7wf2d2Q8nqtLoIxuUkzBNJSV9Mhptk6VBNVixcK6mwMsALV8OFER4tEnoynUaQeiqsmxq1HhP3AppfnDJkW38xJSElEU5OpKQ15TmHprZBhkficjSojO6pCM6NNrNnN5eR0IWeDR8BqL4OckAidGwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIdslJvIfAXs6XCSP00Wc37CzRHQQFXuvCF9dhPebk4=;
 b=dZETUrCTXFReI0hlxGRrjaXqdniUA2CEgtJgJ7SnjP/DJywywma5HNOWdATikhnA7406g6flFcyXfvlfkr58LebK6bOOp9L5P05zjWMSPHnUNogdALiJTwH751zZwxGh+slpHuBk8b0+vmxq+snHfEOvJpvA6rAqw7MbrCU+wmLcB/tdmrm/vgrUxQJ4ps+1tvAPkjI3UQ9pLnwkqiEKDvuuKzHfWuKyVjsb3MlGTheEven6Q/ur9qPr/NVaKMeLhdxjeBRE1ofZWZmXUqaXQoOYNWe9hnLp+kmHTGPOEcuXIIAV2QI/nAyHeThBiFk6NcbHWpJ8GcHtoOuOycUthw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIdslJvIfAXs6XCSP00Wc37CzRHQQFXuvCF9dhPebk4=;
 b=oPHNqy1hmH1BDPK29TlWoabXzgXy/svnq1q6OmnEX20hzpSD4DJs+SS4R1rzW5UkoRO5/5elPFvaXtxaH3yCRft1umlPXvpzFVbloyUH4+4Ti/A5tfSEhuSaLV7PEryoi5fg1asQkhFwjMYmkjkT1feTDUddLpNYlH4s+BHn1gkQRrJnpGsOsDaD3+7+Q8G1WeAbVD3h5t/NzMIBMkbOR4pZ9BTCYMIE161AFyLi1u2wL2rcooBvcBBMoTg5C1PKXOsW5E9ci/pzBlVKtl5KtZLOcDqlboasU8c3TvflBoyegVJzLzXxoJNscfUVvdV+bFQK9tOwh7aI2XYZU+PUbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PA4PR03MB7503.eurprd03.prod.outlook.com (2603:10a6:102:10e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 16:57:42 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 16:57:42 +0000
Message-ID: <6134025a-5262-bf90-72cf-9a1de7878546@seco.com>
Date:   Tue, 29 Nov 2022 11:57:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net v2 2/2] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20221128195409.100873-1-sean.anderson@seco.com>
 <20221128195409.100873-2-sean.anderson@seco.com>
 <Y4VCz2i+kkK0z+XY@shell.armlinux.org.uk>
 <b25b1d9b-35dd-a645-a5f4-05eb0dbc6039@seco.com>
 <Y4VVhwQqk2iwBzao@shell.armlinux.org.uk>
 <9d4db6a2-5d3f-1e2a-b60a-9a051a61b7da@seco.com>
 <Y4Ywh+0p8tfTMt0f@shell.armlinux.org.uk>
 <10c0545d-d9aa-8d85-e3ba-ee739cb126ef@seco.com>
 <Y4Y3UGBCRtCopMva@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y4Y3UGBCRtCopMva@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:208:236::32) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PA4PR03MB7503:EE_
X-MS-Office365-Filtering-Correlation-Id: e33f601b-cbc5-4d65-f385-08dad22ad3af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4x8A7PX0bs5fZCWwY93MzOg+8WcPfIeHTKiE09ATmXusfT4N1sJN+Mgn6xndqIMJO8f9uPOgiRb73rEwYxkJFUBy2F+89zQwBTHE/KHZ15R+Bctm2RVJQboZPoq+6p6gryt2gM3yxzHZE1UiK+MJdRTqwaLUk2fTvwvBmxXKlK/6Aj4NM7XolIX5qHzCMYL7CN/cjT8scRq5yQC6Xc2GB0aC2M2CjnjorhsUB2tqoecBQp/583fPtOitLokkACKKTuLXzNoNuB6P1m50KohPj5yLBMV5x68bkXBJL22b3eYJU598fn7TgGYKN70e5XHXx7yz/52meKZVxQoU5G5kkRILwmh6OClsDWldj6H43nwz92djYOvLVQtBEmMeLMWLd68mW2bZ9gkwkQcQe/nvMXZTwSE2Zjhuk3ttGIBxyimjJwpgHpctdspKAngscQPDbjsGDbEvLcKVslKwbeZnkRYr/j99DGZv9vooirmfqEVxeBoOpTEPqHlPlDq2xYO1RmLoIsxx+cHef+hC3RVGue+QARLrbYPJ3flJi9jnXBJGxh1tGE9DnTaKPApNNUdIcS4iqqGlPtf4BUS17OT5K/HZqVD5yjBamYYNU9xPBUwjR2L5P1kiveCWn9g67nAFbAHr9d+VOSm2cIpIr272DtLBDpPtCQXfVerNNIgcFV84Rps1I44+zf6dU50kI79P8tvkQW/hAbe4Aao/7KzfeDq5lhp4RxDtnFS1/SsaX7aa25lMktvLY0zboS0qNXaN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(39850400004)(396003)(136003)(451199015)(316002)(53546011)(7416002)(6512007)(54906003)(52116002)(5660300002)(44832011)(26005)(6916009)(2616005)(41300700001)(36756003)(66556008)(186003)(4326008)(8676002)(66476007)(8936002)(38100700002)(38350700002)(2906002)(66946007)(83380400001)(86362001)(31686004)(31696002)(6666004)(6486002)(478600001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWcxUVVRb3JEc0JXL1oyWnJFcCtKNTdPQnlldENudnZxMTlJUzVLUlJmdGMy?=
 =?utf-8?B?VUR5RW9aNDh3VmVta3NJQk41dmk5Y0ZWblNDNncxNmNMTkdicVJJVnp5cHJV?=
 =?utf-8?B?Q2RjRDVGU2hqeU9UVVNZU0E4NGxPSEVuYmVYMjVlUmFuVmptam0walBhTGFW?=
 =?utf-8?B?ODh1Q1NXN2pacmI5aHBLd3pDZE9qd2Z1WEJFRTJERGVmQXkzVUw4MFRzOWVw?=
 =?utf-8?B?b3NCVnRaUmNoSjh5NUdMc3Qrd2pONnZuUjJkZFZ3ZTZhUlpDMFVYTUQvYzEy?=
 =?utf-8?B?MzNoYTlWQnRJVHk5bHZmNzExWGJtTUdtWkdEaUgyVVBoa0tZM0tpUlBVQVg1?=
 =?utf-8?B?ZWxvcTZ1dTRndVluZ0g0b1RTcUVVSDFCb1NwbWxiT2t5UU43T0pJSzRnZ2M4?=
 =?utf-8?B?Mno1anBPMHk0R1ZoMTJjTDNDWjE1Y2dBVzZmY2ZGRzYyQUdJRFZraXhuT0FN?=
 =?utf-8?B?bFFGQ0x2c2dGRnNjUjd5YU1vcFRjdS9IU2dGajZYcHFLWFZNK3QxZ1RrZk4v?=
 =?utf-8?B?a3VRWEhKb0xCdGY4dTdQRHJicWpLMjAyZzY3Q3p0QzcrNXhNRTlMMW9aNk1t?=
 =?utf-8?B?Y0E2Y3RoTmVCNnNxYW8rNHBESUJKZ054K0Y4MjJ2K096YmRadjJ2NlFJc2hX?=
 =?utf-8?B?REJQcmRNeUtaM0M5UVp5WmhmYTBXelZKNmJaTlo4cTdzUC9UOW5Qbzdxb0pv?=
 =?utf-8?B?ZkVBR1FKeCtvOWVkWEFVMjZucFZGUXprOXh1ZWJZWHd5WG5ya3N1ZWNPeHJP?=
 =?utf-8?B?ZW9wM2RqQTBHeVpFNG05K0xaMW4zYlJoRjdzeHVXYjB4RjRJL09oTVQ5MDc3?=
 =?utf-8?B?YlBuYnlOVGJKKzhVaVRTaWpETUIxL0NFN3o5U3l2Z2VaUEtFQ2pVS1NHblFs?=
 =?utf-8?B?QitOR3NEaFZNNkV2anllUGRjcXkzL1p0SGdybEtEeXo1eXVaWWNaaXdsMTZ6?=
 =?utf-8?B?Mis5M1d2Wjl0NnNkelRKTHRRNUg2bU5uSVIxd3cvcTAxWjBXOTZ4V1FZZ3d1?=
 =?utf-8?B?a0N3UDdhUlV1SklaemlyenFldzNrSlJ4Q1N6SjI4TXQ4NWdXdktXVTFUTHVM?=
 =?utf-8?B?TXp5elZYeWM0d3NKYUdOVmFZUHJnZ1dLV0RwcHpZdG91dkl2SWJNeThUdFJI?=
 =?utf-8?B?K1ZKbk5mK1JLVzRETzR2K29nUXJoMVFURDdhQXhGKzBrRnh4T2ZQdEROdDRz?=
 =?utf-8?B?L2FvcFg1VkhHeSt2NEhIVlBkdUtVNVVKVDdQRjlYVHE3cDBPQ2tpb1NZVFE1?=
 =?utf-8?B?VEp6dk5ZRTJ3dkdRMnQ5eWl6U3Y5Q3ZQVDZNUWt3b284c1dNcEJXZnZhbjY4?=
 =?utf-8?B?SnJJTkQ5b0ZoRDlpcjhwNTJONlJxek03NE5CclowOE83aHFsck40VkZVTEVU?=
 =?utf-8?B?VUhFTVVKbGdybFdGNndIVlg1dGc3MXIwaEJaeXdwQkJIUVNBcGkyYUpNcGxq?=
 =?utf-8?B?QmFNQWlYVFhUY3NkYldORGJ0Mmk5NXR5dGpvMVVuNFJ3TVZkamc4RDFJSnJ5?=
 =?utf-8?B?ckVIcXZEWndXaFJoUGEwSk85dDRkcms4M3hUOVl6dVhvRWE2eHNHVEo1QU85?=
 =?utf-8?B?SVhmRmVnRWd6VmhTM21WOGVLd2ZOVlNRWnJmZ0xraVpXUDZrZUhxOVBST1dk?=
 =?utf-8?B?L0taNEF4bkJyRHNRMWpmdVJDUStCZWVnbEltWERCK1dnb2NwQXoyOXNZTnRC?=
 =?utf-8?B?RkZtZGxMVXVlOGVuUnRRRi9lNnJxcjg1cmQ4N2VwZXVSY1NYczA0bzE1eExh?=
 =?utf-8?B?cldIZDVvL1hhVllXbkhxVUNYL2JWeC9IZnFtVzhOU3lWek9zd3hwVjJoK0do?=
 =?utf-8?B?WWNFb2VrcUtNOVIyem84Z0JCOGRlenhMYXlrb25tY0lyK1dJRlRyYjF1cGc4?=
 =?utf-8?B?ejNFRkI4SEpJYzYzc1l5RFNaUlpZZUJaUHpuY3AvY2Q2N1hQZHBNK3Myd0E5?=
 =?utf-8?B?OE0wUCtSWW9hVENDT2tmbUtlR1Q3ZzNJTHBFNDJ3THQycDJTZTVWQnp6TTRh?=
 =?utf-8?B?YjBaOTZaSGdKR0JGUVFpdGkxRGtURTdIYjJBZWt6emxCdXhGSnYxNE5qekto?=
 =?utf-8?B?dTZvUGNUZkIrVEdva1RPRUdXWjdzTUs5SUQyNW92b1RuZUFNSnlFZjJINU40?=
 =?utf-8?B?anhweTdCMzNNaGszRnBrUStIeTlSbGdTcUI2Q0EveDhZWFhLejNTK3AwaTJy?=
 =?utf-8?B?cGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e33f601b-cbc5-4d65-f385-08dad22ad3af
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 16:57:42.6149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kLP/eKpfbQDmR95e4OBC4MCYDC2LUiVBnyUlllDP/WgDHcJeRpYCnD2MQTpglS5cPAoCazfDdWSMOVvo+khkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7503
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 11:46, Russell King (Oracle) wrote:
> On Tue, Nov 29, 2022 at 11:29:39AM -0500, Sean Anderson wrote:
>> On 11/29/22 11:17, Russell King (Oracle) wrote:
>> > On Tue, Nov 29, 2022 at 10:56:56AM -0500, Sean Anderson wrote:
>> >> On 11/28/22 19:42, Russell King (Oracle) wrote:
>> >> > On Mon, Nov 28, 2022 at 07:21:56PM -0500, Sean Anderson wrote:
>> >> >> On 11/28/22 18:22, Russell King (Oracle) wrote:
>> >> >> > This doesn't make any sense. priv->supported_speeds is the set of speeds
>> >> >> > read from the PMAPMD. The only bits that are valid for this are the
>> >> >> > MDIO_PMA_SPEED_* definitions, but teh above switch makes use of the
>> >> >> > MDIO_PCS_SPEED_* definitions. To see why this is wrong, look at these
>> >> >> > two definitions:
>> >> >> > 
>> >> >> > #define MDIO_PMA_SPEED_10               0x0040  /* 10M capable */
>> >> >> > #define MDIO_PCS_SPEED_2_5G             0x0040  /* 2.5G capable */
>> >> >> > 
>> >> >> > Note that they are the same value, yet above, you're testing for bit 6
>> >> >> > being clear effectively for both 10M and 2.5G speeds. I suspect this
>> >> >> > is *not* what you want.
>> >> >> > 
>> >> >> > MDIO_PMA_SPEED_* are only valid for the PMAPMD MMD (MMD 1).
>> >> >> > MDIO_PCS_SPEED_* are only valid for the PCS MMD (MMD 3).
>> >> >> 
>> >> >> Ugh. I almost noticed this from the register naming...
>> >> >> 
>> >> >> Part of the problem is that all the defines are right next to each other
>> >> >> with no indication of what you just described.
>> >> > 
>> >> > That's because they all refer to the speed register which is at the same
>> >> > address, but for some reason the 802.3 committees decided to make the
>> >> > register bits mean different things depending on the MMD. That's why the
>> >> > definition states the MMD name in it.
>> >> 
>> >> Well, then it's really a different register per MMD (and therefore the
>> >> definitions should be better separated). Grouping them together implies
>> >> that they share bits, when they do not (except for the 10G bit).
>> > 
>> > What about bits that are shared amongst the different registers.
>> > Should we have multiple definitions for the link status bit in _all_
>> > the different MMDs, despite it being the same across all status 1
>> > registers?
>> 
>> No, but for registers which are 95% difference we should at least separate
>> them and add a comment.
>> 
>> > Clause 45 is quite a trainwreck when it comes to these register
>> > definitions.
>> 
>> Maybe they should have randomized the bit orders in the first place to discourage this sort of thing :)
>> 
>> > As I've stated, there is a pattern to the naming. Understand it,
>> > and it isn't confusing.
>> > 
>> 
>> I don't have a problem with the naming, just the organization of the
>> source file.
> 
> The organisation is sane. There are some shared bits in the SPEED
> register between different MMDs.
> 
> If we separate the PMA and PCS with a blink line, do we then seperate
> the register groups with two blank lines? No, people will complain
> about that (they already do if you think about doing that in source
> files.)
> 
> Sorry, but... one has to pay attention to the whole of the macro name,
> not just the last few characters... and think "is something that
> contains "_PCS_" in its name really suitable for use with a PMA/PMD
> MMD register when there's a PCS MMD? Now let me think... umm. no.
> 

Well, what I had in mind was

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 75b7257a51e1..d700e9e886b9 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -127,16 +127,36 @@
 #define MDIO_AN_STAT1_PAGE             0x0040  /* Page received */
 #define MDIO_AN_STAT1_XNP              0x0080  /* Extended next page status */
 
-/* Speed register. */
+/* Speed register common. */
 #define MDIO_SPEED_10G                 0x0001  /* 10G capable */
+
+/* PMA/PMD Speed register. */
+#define MDIO_PMA_SPEED_10G             MDIO_SPEED_10G
 #define MDIO_PMA_SPEED_2B              0x0002  /* 2BASE-TL capable */
 #define MDIO_PMA_SPEED_10P             0x0004  /* 10PASS-TS capable */
 #define MDIO_PMA_SPEED_1000            0x0010  /* 1000M capable */
 #define MDIO_PMA_SPEED_100             0x0020  /* 100M capable */
 #define MDIO_PMA_SPEED_10              0x0040  /* 10M capable */
+#define MDIO_PMA_SPEED_10G1G           0x0080  /* 10/1G capable */
+#define MDIO_PMA_SPEED_40G             0x0100  /* 40G capable */
+#define MDIO_PMA_SPEED_100G            0x0200  /* 100G capable */
+#define MDIO_PMA_SPEED_10GP            0x0400  /* 10GPASS-XR capable */
+#define MDIO_PMA_SPEED_25G             0x0800  /* 25G capable */
+#define MDIO_PMA_SPEED_200G            0x1000  /* 200G capable */
+#define MDIO_PMA_SPEED_2_5G            0x2000  /* 2.5G capable */
+#define MDIO_PMA_SPEED_5G              0x4000  /* 5G capable */
+#define MDIO_PMA_SPEED_400G            0x8000  /* 400G capable */
+
+/* PCS et al. Speed register. */
+#define MDIO_PCS_SPEED_10G             MDIO_SPEED_10G
 #define MDIO_PCS_SPEED_10P2B           0x0002  /* 10PASS-TS/2BASE-TL capable */
+#define MDIO_PCS_SPEED_40G             0x0004  /* 450G capable */
+#define MDIO_PCS_SPEED_100G            0x0008  /* 100G capable */
+#define MDIO_PCS_SPEED_25G             0x0010  /* 25G capable */
 #define MDIO_PCS_SPEED_2_5G            0x0040  /* 2.5G capable */
 #define MDIO_PCS_SPEED_5G              0x0080  /* 5G capable */
+#define MDIO_PCS_SPEED_200G            0x0100  /* 200G capable */
+#define MDIO_PCS_SPEED_400G            0x0200  /* 400G capable */
 
 /* Device present registers. */
 #define MDIO_DEVS_PRESENT(devad)       (1 << (devad))

Really, these registers have almost nothing in common except their concept
and sub-address.

On another note: is BIT() allowed in uapi headers?

--Sean
