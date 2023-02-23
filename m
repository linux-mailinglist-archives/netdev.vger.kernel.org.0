Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450516A0E70
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 18:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjBWRNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 12:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBWRNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 12:13:18 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2041.outbound.protection.outlook.com [40.107.13.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6403CE0B;
        Thu, 23 Feb 2023 09:13:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNUtVe4xjc4ERMMU2NOx74k8NBq45Np7FCFVSBQF5/CyU1y33JcLJLXcwuL4oxz79p7tP+Kpafho/BIm7N636xKjfgti4lqZ5SXHPSwFgOHHzmHaexH4GRdVen5VqdKqPEXAuPAUbp2a9VSAtFZtXn7pSiu2GHSK+bNV5xC2fRy7jEio+NYdo3w7DaBZ0wm4dRrCiNxG4CIeratxPPiWuxXv7uvimjRgT/cEdagQCW+MuH71CYRne4TJo5o18dmHZ5SBeTZGDmlxfTAUslPg1w/dzQZ5IgQ9SkVjlyzBIfOgIV1mCvhiATxLVxxgtuvRZ4M4PyaQrqLiEwlAE9996g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7R47jvR7Us9rYYgcPpL+6UX5l2oxEOF+NyskTST6ztY=;
 b=TcFLQxqT06Vq6ps5cHeCyg3Y+D0dH9LdVSgubQb+1SIck+jpRsogfwpB3pK3xsEJEqqYsTVvo1Xs7YFNNwmQzZDSvPxnwcoWp5wK+xEpi2mmPy3YhRAOw/rKC6SXCniLwji/Usw6/WFz/HISpSpX0DbtEINMJa2uMj1g68GSZaIV9XRJCPwWwARc4BR2KWEH82vtmxGbS5ddWXsgwpGbGqBVTxY4+Rr/sXy/B+4bhh9Klw/lZQEbSxoIIZUuqpPYBTrDLoZPnuoNMUlZAEU4va21ROSlsxo3RMbwtYhq1pSPrYXJUUD+QmeMBucco53iBtzKqHqFRoTYx9N6LYorZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7R47jvR7Us9rYYgcPpL+6UX5l2oxEOF+NyskTST6ztY=;
 b=roGV7voGc2xwJYb6XI6sdoPHV7Q3N+XHwQreeXviGQcZdSKaiVskXjA0P5Ya0YO38z7z2/ur17inU0mDjSFU20pxwXT+vFKSMeCj/zhnV3I/rtfhRpj/Nvp+f5NBx1X/yCMvmwpMMG99e7uyqUF2NvsF2E2blZ/V2KwJby3gdR94rBRUnWpayBBs1P9mNsxRh4u4N14ECkV5tcz/W14sR8DLXl5bPeY3ov1eiELIpCvR4LqSgTIGBZbAN0U9PgXiLm+6pZXPW4YBcJ71G+wAQdnI+TwlAvushs23ln77IgwQPTdsR1b3FqyjJfa7ukMtT+XmJYuaCUe71VxMNKwGXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB7110.eurprd03.prod.outlook.com (2603:10a6:20b:23d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Thu, 23 Feb
 2023 17:13:13 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%5]) with mapi id 15.20.6111.021; Thu, 23 Feb 2023
 17:13:12 +0000
Message-ID: <372cbc16-c2da-b9b9-9ac2-f7a2572c426d@seco.com>
Date:   Thu, 23 Feb 2023 12:13:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next] net: pcs: tse: port to pcs-lynx
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
References: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210193159.qmbtvwtx6kqagvxy@skbuf> <Y+ai3zHMUCDcxqxP@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y+ai3zHMUCDcxqxP@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0040.prod.exchangelabs.com
 (2603:10b6:208:25::17) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB7110:EE_
X-MS-Office365-Filtering-Correlation-Id: 250cc36c-a3b4-4a8a-d093-08db15c13e77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCPtvnjDQ5/3S9xEsHZlRkywkD8P3f3OALXVHORjIQgzdt9reUBdeMNAnfnDLS5nZsjGBtvGIaxV204DALeZlO+KxQS5XSx/XKtJug3sVmhY5W48FKsAAVl3JoaYxU0V0syt3OV3UMaEIbp3HbTWOICkkqDaRNax7oAYVTmIZb7O6A3/YaPkYMQbjzuYqQ0AiGe14oFYZEc+7QMdCfJXVHk4fxwzZrX5GjeqdM277uvuwpNT33vrgQde+3meHQ82G3bqNozx8fEvf0TS8OAUXVD5+89NAXMPXqilpOiK+JutbFlhcDbI+jrMCbbj39kd0v8CRUwFgPOx5sXUSpGw5Ig43yxy1u7KIzixhKMHdGs16BOPMzRuafzTrVruARgWj9XCzTLGq26BIuJSSRzHS6nG94FxloFn+MWxL9apWE+UzbuHitopUrUCsfUrGvwlkExCggpY1KNnwyGydPQ4I7o+LFqBs3vv8Eyt5t64eA8PoDSL2Ucv5c5e8Ka+c56pIC5dSA1xrVB0MZ85mGEaAy7dmX7Ck2Q/0RcxtnnanZ1dESjEatkajBIOCblLeXT6jh2oCtZeqPCxZp8l4bT4D+pP1ehAcYsg/DIxHySwDoeliLwiPHlMIyLQdai+RDB8b0nv6MztGN22nOTsCE+4uLmT279oKGNJwKOXvTmEMZ7M/Z/xkBDAYdmuvTqqIg3Iesos1V4CBIBj7RyZzc3jkv7sDzDRwbwYKrEGGRagf4EqNmbWzm+izX00/yhLKl4i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(376002)(346002)(366004)(39850400004)(451199018)(8936002)(54906003)(316002)(53546011)(6506007)(6512007)(44832011)(86362001)(36756003)(31696002)(966005)(52116002)(6486002)(2906002)(110136005)(6666004)(2616005)(478600001)(38350700002)(38100700002)(5660300002)(7416002)(186003)(26005)(41300700001)(66946007)(66556008)(66476007)(4326008)(8676002)(31686004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVpFeFR2MzdqaDFzTGtHWGV1QUpvbXdHekJxZm1Oc2hFM2VpRzZPWTBCM3RS?=
 =?utf-8?B?eVNacXhQVzgwVm1pdXIzaCtzdXo2VXJVM2NuZzIreFlOL1RkOGJTaFpuNWRj?=
 =?utf-8?B?M0JrOFpKSDNiTy9Vci9oUUlleTdsWEtVQ0ZYYlFHS1o4OERJOHlQVHZmanh1?=
 =?utf-8?B?ejUvZWtXckQvVjlaQ1RpK0tFSk5YSUVabWMvYzNmdUxQbkF5bEE0QkNEaHds?=
 =?utf-8?B?d1RIUFZlUDcwaWdIemljYjJaUHlQOTlkZ3I1MkF4cU4vdTBZSExpcmJwZElI?=
 =?utf-8?B?QkFCZUc2UVBGQThUU0xDMjBLWmNMU1lqMHRaWHVFZWpOUmRSKytySU1BRmZx?=
 =?utf-8?B?bHV6TGNHaHBhRFV1MzlsZjYvNDZpVG5ITklGWXlWZ0dJOE1oYlFQVkpmVjU0?=
 =?utf-8?B?OFpVeFNyaUVTN1c3NjlPNVU2blRmejZvdzZrR21vY2UzQVVtaHExYUwzMlpT?=
 =?utf-8?B?L2o5NERvME9ZS3pGRkZaTi9hZmxZS2gxdXp1U3FtUGZLaEIvZ1VnL2pQSmFQ?=
 =?utf-8?B?WjZFNTJFRmp6TDlWamdIL0lURmg2Rk9zVzkwb2Jiemw2dlVuY21NaHZsZ0lL?=
 =?utf-8?B?MHZPWUJaTEwvZlFpb1E5MktBdklQc2FVNW9FWk4remJYeU5ERCtwcDl6MHd2?=
 =?utf-8?B?by82OUZZL3hoN2E4SUprMWJ0WUZvMkR5NWhzY1lkSTFoN09SWkJ6R2lzOWlu?=
 =?utf-8?B?RXRCVEEyT2dlblZ1UUc1akNRd2FkMld3UmZJS2NuYWJWbTZWZUdlSFJySGxD?=
 =?utf-8?B?dlRTcnRHVS9YSS9tUGNJRHAzdG15bXI3MmJsSS9KTndMc0NVeTVmemxwc2ZI?=
 =?utf-8?B?QWNwajBwVHJ4RndhZmh0WDJnc2l5bzFGbGtOYTJOa1hWQytIa2lSNk1PTVVD?=
 =?utf-8?B?bDVCQ1gyRGN1SmZPeDRmOFV5RWRDOS9TWGV6SVpMTUg1NmJxUDNEbmp0NzV3?=
 =?utf-8?B?eG9Tb1QyeXhiQTVyNHV0MWsyTjljNWd4VTJKS2N0WUk2QVpXL2dkTkIvdFlZ?=
 =?utf-8?B?V01EcEduY1g1U1RuWUdtQTdidGZGRDNGVnYwOHdlekRWQWtJbVk5OTFZdWtK?=
 =?utf-8?B?UDRrVkZjTUhlbUZhcUQ5WkpaWEwvdi80aHg4eXEyL05ERXVUU3A2VG9Kdm1i?=
 =?utf-8?B?UkJTNkNiM1JIdjdlRDhjVjlHY2xTSklUUXFjdjRMaXFPZ3NMWGtDZFpkSlMy?=
 =?utf-8?B?dWUxc3hDdnBuelV4eXJqTXpJTWFCc2Q5N0dwdHd5UHIxN1laMWFyRFZKRUpQ?=
 =?utf-8?B?MHM0eGM1THRxbUhObjZIOUN6enE0S084bU5lS1Y4dzc1TzErKzhvMmJCYVVu?=
 =?utf-8?B?a05sNWpFSXVCRzVaVERqQzVQUkNubGVyN3hvak9ac1ZVQ1UzUzZpT3R5NXhn?=
 =?utf-8?B?UklBWGc5NTgxOGJOZGd3K05oRlBlNTFLUnFJb0g5WnNCZ1ZJb3UvcDJGMFdX?=
 =?utf-8?B?SVVVYzh3dzZhNEtiR3I5d2V3cnZHL3NkOWh0ekQ5QmNLQlUxdGk0bUhRbytm?=
 =?utf-8?B?VHYxVGE0bk5nU2tVQUV2U25UdEs0YmVKbWM1ZUJwTytSeE1MOWoxdUVuWUlD?=
 =?utf-8?B?VWExblFrZEhkbEx6R2dmTHNncXFmS1RhKzRBUHJ0S2ZMTnJ3VmdMTWJad1Fh?=
 =?utf-8?B?akJiUjl1Wnljems1b29Dc2sza3l1TVc0ckdZTzJwTWEyMEpJeUNweEIvdEJF?=
 =?utf-8?B?dFljYXI5cXhxZzYvQ3lNTzR4cGpmRXpIZ0FLSzlGOXJqTFJ1SjZXNDdmYlVt?=
 =?utf-8?B?NVcxSDBKOWV0WTJBL2tVS3ViZUprSDAzZW1pRkxRU0pkTXJobVRMVFhRUmpN?=
 =?utf-8?B?WHloWS9zWXlEcElpZkQ4bTVtVFg1UCt5alBYWk1kY1FJQW42bEVBdGJxbGdZ?=
 =?utf-8?B?M1BKVUlrbFAxODB6SVA3UzdSa0hsL1ljMGsrRWQ1ekFRZ2FvbXlreTk1ck9w?=
 =?utf-8?B?c1NIRTZPbzJTMGdnOWpreVM1U0J3U3hORnZCOVI3VDAyRUpMQ2MyYm1YRUFn?=
 =?utf-8?B?WTlFWVpTc2lqbTg5Y3psSm5OVk51R0E2OGwzc2tQWndnYThkUkVCT0hiRU4x?=
 =?utf-8?B?alk3Z205ZHlveW5jS0NpWTROUlZDeE1tTnlINVBtRnpBc1F5OGJGNkdQNWdR?=
 =?utf-8?B?ZUhQSitRUytPLzhZMzV2NFRpNW5CMjZzdXZmZXlwMzJjeXQrRkdVZGU1OHNj?=
 =?utf-8?B?V1E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 250cc36c-a3b4-4a8a-d093-08db15c13e77
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 17:13:12.5686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6NxsZz05EFXgdsuvnqUTEzq+DVJ4XaIPO5TzwtATNt62h+W8AJHibjSfO5YqMC2TfuvnSKi0qvcjfk0McVEfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7110
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/23 15:02, Andrew Lunn wrote:
> On Fri, Feb 10, 2023 at 09:31:59PM +0200, Vladimir Oltean wrote:
>> On Fri, Feb 10, 2023 at 08:09:49PM +0100, Maxime Chevallier wrote:
>> > When submitting the initial driver for the Altera TSE PCS, Russell King
>> > noted that the register layout for the TSE PCS is very similar to the
>> > Lynx PCS. The main difference being that TSE PCS's register space is
>> > memory-mapped, whereas Lynx's is exposed over MDIO.
>> > 
>> > Convert the TSE PCS to reuse the whole logic from Lynx, by allowing
>> > the creation of a dummy MDIO bus, and a dummy MDIO device located at
>> > address 0 on that bus. The MAC driver that uses this PCS must provide
>> > callbacks to read/write the MMIO.
>> > 
>> > Also convert the Altera TSE MAC driver to this new way of using the TSE
>> > PCS.
>> > 
>> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
>> > ---
>> >  drivers/net/ethernet/altera/altera_tse.h      |   2 +-
>> >  drivers/net/ethernet/altera/altera_tse_main.c |  50 ++++-
>> >  drivers/net/pcs/Kconfig                       |   4 +
>> >  drivers/net/pcs/pcs-altera-tse.c              | 194 +++++++-----------
>> >  include/linux/pcs-altera-tse.h                |  22 +-
>> >  5 files changed, 142 insertions(+), 130 deletions(-)
>> 
>> The glue layer is larger than the duplicated PCS code? :(
> 
> I was wondering if the glue could actually be made generic. The kernel
> has a number of reasonably generic MMIO device drivers, which are just
> given an address range and assume a logical mapping.
> 
> Could this be made into a generic MDIO MMIO bus driver, which just
> gets configured with a base address, and maybe a stride between
> registers?

That's what I originally considered for MACB [1], but I ended up creating
the various encode/decode functions because the PCS didn't have an MDIO
counterpart [2].

--Sean

[1] https://lore.kernel.org/netdev/20211004191527.1610759-11-sean.anderson@seco.com/
    This patch doesn't have a mmap-mdio, as I dropped it before submission.
[2] https://lore.kernel.org/netdev/20211004191527.1610759-8-sean.anderson@seco.com/
