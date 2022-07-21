Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9712957D2AA
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiGURkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiGURkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:40:42 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60089.outbound.protection.outlook.com [40.107.6.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99044804A9;
        Thu, 21 Jul 2022 10:40:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEOXDDPMPi2+XcOF/5faeZp/C4XphEE43I92QpXQoWlmnkqOsPzJXpy/8JI0f2qhmXBAuDLkt4cxWr5E3Eg3N9sLt4AetbMhqYpxa5SeHPoBIrFEc/eXwlIz/FhlaMWrtRrlh+0YTKRm96GDm8EUeaX20bc1+d5dvJJdrtNgAMJSHg1FFaQU5hxYWazQo6Ye/CYPg01CwlGiTlf/6NC9ewYUwKHCk99fOyjtVLwj1RtNPfZExUO5JQIa3Msh1l7htUMhoyU1Tix3RvTCThUE9jvGQEWyPdqRlncJy46jPrSQFU8MpQlCLS4lJF82JAdlVOEFgFVco92sHqA3BT5Htw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gtLGCQKJIDdYlM9xxF4Qt/M/5MZpBFq+Uauhhr8wWA=;
 b=anyqTH/LM5aDw+eOWaj0p2JhWc3ABeXnO6YtQwst6eB7OUVb9EmaIMIP0y8HVvwbij4P2f/ATfMvfKRRFCoIZfbepjRXfEH3s9Vejd7oCHvVJUych/Hvd7n0FrSx/NP0DvFx22DaXZRuAx+FxkFpSA9Z8lBHPy3Et2c03BKlaIyxdU214Q6s23Bu4rG42mNM5BJ8WT77h0wcsgAdIM1X4tljUj07m2akHtI5rXhFWWRTUB5fxe6ja2nr6ztTZU7TuoaVsoODmrzZ8O+qIz6EukMJXs2CyngPB5sQI/oRDY7noR8WoGtYhFKHdfgIwUThezdERg0ruL9xJ49oInEuDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gtLGCQKJIDdYlM9xxF4Qt/M/5MZpBFq+Uauhhr8wWA=;
 b=p/aZ9/SrKJJ+gVj92n0v3wyjhcsS7/Z6db4g6M1bmxCpmiQ8gW+9M1f+zdhChzEFwbp0T4YcqoA9Xbq8/9551d9yy8eEvFyUi8pY4QGmE8EUNa5hgKQBQZSup5umyZEEHyyu9EFngHcyVAZ7CqMoVCb77j6ksy0lDAkmK/I24kQ8t+s5YPIEyQXUR65k55tkp9zOjPKwdBAJzuiaVKMI+kNoaPgkqHJRkNn4NNjRGo5UIXQUO2RsPPlOuE+DjYV/3dIy08COtNQjydM0QeliSWNmoEV5rw4nIF8NqboPIGJ6VCrfMEou3P90r4+eG49NFkcrH/hHbEeDXKO4wfixLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB3568.eurprd03.prod.outlook.com (2603:10a6:803:35::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 17:40:36 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 17:40:36 +0000
Subject: Re: [PATCH v2 00/11] net: phy: Add support for rate adaptation
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bhadram Varka <vbhadram@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-doc@vger.kernel.org
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <YtfvChkHE6CGyt4x@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <7f4df403-ce41-b3b5-fd26-80e376aa8216@seco.com>
Date:   Thu, 21 Jul 2022 13:40:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YtfvChkHE6CGyt4x@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR10CA0020.namprd10.prod.outlook.com
 (2603:10b6:610:4c::30) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35db99ea-08d6-4af9-a48e-08da6b401ec6
X-MS-TrafficTypeDiagnostic: VI1PR03MB3568:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6O5WUWov2Hk1WmOim/Vl3kpAQ+nfnQhMERUgtEKSI0TskSudar/+lItJJ3beYuMa4d0/NafzlGQdLWcGY/pFzsVCv5DGyVjOJfhXknjlNBNdMCFyySRZ8iaqV7cWc9p3Irs9x+ycBBX+/76GKwfpSvH8xoP0KUVBA5797CHZYM+NtIfIrvfAfWQdiDMOykZgtvnn/Lbrgfmhjj2li5QcUrHaCN1vOsSAHPuVmULwrIylu9lIKfMW6gkK9IP+rWO8bYN/d9dLPYw6w6FzSasde3+ZoV4OAeZ9QomwlUCKEMIhj4hsOOYRHMbI6gVkZ5Wo7pSuqYOuVD1Li1QSVEuXpHmgme1UU/oAXIl6iiMt9BXdFDqphtLQ3fEqaCaIJV9quiHlnW6042CW2p5JAT2Z6n+ftH+T8Ol+a88ymW7osgvuSZ13NQXQnhhFNzgAHkWEJtEPALHf6zHipbR5v3kU6fzcTuJnwkK6agBnpoh7vWCJAEh5Q2R8A/2gndEN7U40c7IBGJfrpbQlfbRN8rPP0sSXNhmBZLnOnrmx7jrDN+Q8WedkjNUh4djL0UGKtCTpzUTfAcvq79zvqoZVVaLW61iNNLMVRjBucpYWqf/bLJUJTuc7edUiUC9H1E+AmXRQR9cJ6tz7zm+vxy1UHle9t+buDpDsoerihsqvr9KK4ROOHyDn/aPwfHRF0r5dEpivZi60Po2ZbYYPJGGPtwZhhSvQc/yGCg9qr4SO7tkdfh/K919MvkNAfbcWoTfabCIAuQqV8hvz/FPoY4W8s0u8r/wLLrCLtCeMauAZoE3HG5Wu7JT3uzCJWNt65uTwNbzQk3JnMylFBUv5aBIVbeV24Ht3e+K3Mo5ebJRyyu4d/95L4Biq0YGBg5ITQ0vIY7UnvWN1PPReut+/bMthl7Tpvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(39850400004)(136003)(346002)(44832011)(5660300002)(8936002)(7416002)(66556008)(66476007)(8676002)(4326008)(66946007)(2906002)(38100700002)(38350700002)(36756003)(31696002)(86362001)(966005)(6486002)(478600001)(41300700001)(6666004)(316002)(45080400002)(6916009)(54906003)(83380400001)(186003)(26005)(6512007)(6506007)(52116002)(53546011)(2616005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wjd1OG1DVlZySmtIM0pybG9wcklXS2l5ZUdoK0xXb2hqbVkwYTJPQlU0bFFO?=
 =?utf-8?B?N3VHTFNSK1JMaVpwdVJrTVdHNXRsQWI2bEJia1hXWFdKZ3ZKRlUrL29UMFF5?=
 =?utf-8?B?TXhGck54NnBpdGRQTFNRcy9sT0JLMmZrbzlLallXRHAyNTJhZTZIQWgvZDZL?=
 =?utf-8?B?TDJWeEtDQW1nSE0vVExJdTlpOWNlL0hPbWdYa0RUYjRjL2wxY0hnYlNDNW1I?=
 =?utf-8?B?Z28rSjVhbFpSNkpKVFdFREpWRHhsRHlIeE11NEszZEJxNHlZSlJiWVhaZGtD?=
 =?utf-8?B?NG9qRjFqTkZsWElEOXFkVlVQTkZDaGl6Nzd2UzBkN3h1aEcweG1KUk5LOEl5?=
 =?utf-8?B?em03ZllmNkRNaDNkWmVYTUU3SnNCS0JwMHM3STdPRFQydGxtREcxelBYSk4y?=
 =?utf-8?B?emIxMnZvZHcrdzVCRFk5WlFSSnVXYnBLcXpOWWlEbmUwV0dDdWp6M0RWQ3Fh?=
 =?utf-8?B?NXJ3N2xwc2Z2ZG9qbHFQT0c0VUp0WnpQR1Bwd21RdXhWd1pDNlNnTVErbUIv?=
 =?utf-8?B?Q2gzeGRSWHRFaTR0Z3V1QTNsUCtta3RQQ2tYRVJMRzhNU3ZtQ1hjNGZLUzV2?=
 =?utf-8?B?YkNaSEpTWlNNOStmZUVPQStCMk5jd2hJY2VnVERxUEZadHNZQlhoMVNyQjQ1?=
 =?utf-8?B?Z1dFdm93c3JZM0w2QXFvQXBjamZOdWczaUdIbUtPa0VpTjlqVlJ0K3IrQTlo?=
 =?utf-8?B?WU1hcmdJRGNtV0VxTi9pT3owdHhwRWJKL3F0YjZrK1h6N1dVZC8wcXhtdUdR?=
 =?utf-8?B?M01SekRwNXR4dmNPYmdJcEhqd25RTWlCZ2JVOGd6MXQvMUlLNzZEU2RhQXlh?=
 =?utf-8?B?TGdiaVRRbjR4TzBuOHpsaGpsU3hiUGhra0V2bUZ6M2k5SmpMTXlQVGdMZE9r?=
 =?utf-8?B?cm5ZM0lJTTdyTTNuWnJRcS8xMG9KaFJTY1loUUMvSjI4bXZEUWN3OURiZEE0?=
 =?utf-8?B?L3gxRzVHNGNDRU1jdllZZUVrM1RyaHcyRm5XbnplSzk5TDA0OXMyaTRGVlJs?=
 =?utf-8?B?Z2duTkFGS3krQk5OUlpjUHNSQklMRGlxTVFCbWhFR2xHcXdZZTBCS0MxNVd4?=
 =?utf-8?B?R1hnMkQ0N0RrcEY4WGRGdW1UcVF5TXg5L3FOQ015R3AvaHVGNGZZVWloVFlz?=
 =?utf-8?B?SjFPVDdLaHRnUmF5UTR1eTVOck5ubUoyL3U3V3YwbTNML0pnMUdncWorL0lG?=
 =?utf-8?B?dDJHVDRCYmtWL3gyM0NyUGRKSkM1TU1saXNnTk1oRjllTXUvQm1GWGlPdVVE?=
 =?utf-8?B?dEg3UDlTa3N6YlZuYUpOWDZFNi9DaTI3amlsOElrZkZXODJ6S3psRC8vejR3?=
 =?utf-8?B?c21GNUZqRkR2a24xS09abHZKYmhtbFl0eHBVaXdnTVdKcm1uam5wWHN1eUZI?=
 =?utf-8?B?VEFkQ0VnTmZVREZrUHc4eEVEeGI3eDZ2WUwrU2loNm5oQ2Riais1YnRxUzdr?=
 =?utf-8?B?TW9MSEE1M1BnOGJ5SzAwRlNEa2RoM1ZpTDhlT2ZNS0RJMHdHbDMvT1dLRzQ3?=
 =?utf-8?B?OGkvSzNoSmdqY2swY3VDTmdFemRPVllqKzFSTzJMUnF2dGM5clpOUTZpZ3Zj?=
 =?utf-8?B?MGlTbGpuZUdnOGZWTUI3SWcwZVpZaWY0cGJWcjhHd2R5N0dSUUd2ZEY5QmdI?=
 =?utf-8?B?Z3JZdmlmSXByenBSbUM4T1RCZlRxblpXSlFwNmt6SHZzekZiS1NtQTlLUVdm?=
 =?utf-8?B?bkdSblY2ZEZNckNUYXB6VWVXK04rakdmMGtxZW1qOEptMllEaXlRUUlJZEdM?=
 =?utf-8?B?ZWJhcFdZbXJpdUhSQVRZVGsvNVpSa3B0NkoxeE8vbFNEWjgvT3J6cytsWmU2?=
 =?utf-8?B?OGNhYlVIb2xWWFRaR3pYa1dvRmxRVkcrVkZTVUdJcStySVdHVDlxMjUwVXpa?=
 =?utf-8?B?SlZFODYzcnIvTW94L2U5dnNKREZrTlRQdVp3NzV2UUJrTDJaeGRkRHFhcG5E?=
 =?utf-8?B?REk1ajRsMHc1RklCYk5uSElOdVdwUFBteXVLUS90OElQZ1I0eGdham5xbElt?=
 =?utf-8?B?VlcwNURvRXZDTms5YmZwWmhiblhGalBiUDVjRVNURVhpTG9wSXZQUEJhd2FZ?=
 =?utf-8?B?RTNVTlpPeHJueFpONUlFL2ROVmdPK1dQRDRERXBHUjYySndXL3JwS0dXTThV?=
 =?utf-8?B?YkkvMno5czA2MGN3R29acFpTS2dIR3g3OUdnWEdTV1FmRWhxQmZITXI2RWYz?=
 =?utf-8?B?MGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35db99ea-08d6-4af9-a48e-08da6b401ec6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 17:40:36.6010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4B2ivs6qdDC7kyboWxshLytoi1uDzxqRN5kkkZp1jXSudet5MaVLeyatXWvlmTSegAryMP4zgd/NGEhzoPINw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3568
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/22 8:03 AM, Russell King (Oracle) wrote:
> On Tue, Jul 19, 2022 at 07:49:50PM -0400, Sean Anderson wrote:
>> Second, to reduce packet loss it may be desirable to throttle packet
>> throughput. In past discussions [2-4], this behavior has been
>> controversial.
> 
> It isn't controversial at all. It's something we need to support, but
> the point I've been making is that if we're adding rate adaption, then
> we need to do a better job when designing the infrastructure to cater
> for all currently known forms of rate adaption amongst the knowledge
> pool that we have, not just one. That's why I brought up the IPG-based
> method used by 88x3310.
> 
> Phylink development is extremely difficult, and takes months or years
> for changes to get into mainline when updates to drivers are required -
> this is why I have a massive queue of changes all the time.
> 
>> It is the opinion of several developers that it is the
>> responsibility of the system integrator or end user to set the link
>> settings appropriately for rate adaptation. In particular, it was argued
>> that it is difficult to determine whether a particular phy has rate
>> adaptation enabled, and it is simpler to keep such determinations out of
>> the kernel.
> 
> I don't think I've ever said that...

You haven't. This mostly stems from

https://lore.kernel.org/netdev/DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com/

where there was some discussion about whose responsibility it was to determine
whether rate adaptation was supported. The implication being that we should
delay support for rate adaptation until we could reliably determine whether
it was supported. This of course is not quite implemented yet. While we can
determine whether rate adaptation is actually in-use, I don't know if we can
determine whether it is available before trying to bring the link up.

>> Another criticism is that packet loss may happen anyway, such
>> as if a faster link is used with a switch or repeater that does not support
>> pause frames.
> 
> That isn't what I've said. Packet loss may happen if (a) pause frames
> can not be sent by a PHY in rate adaption mode and (b) if the MAC can't
> pace its transmission for the media/line speed. This is a fundamental
> fact where a PHY will only have so much buffering capability, that if
> the MAC sends packets at a faster rate than the PHY can get them out, it
> runs out of buffer space. That isn't a criticism, it's a statement of
> fact.

You're right. I mainly wanted to bring up what you just noted: that we may
have packet loss anyway, and that higher-layer protocols already deal with
packet loss. So a MAC unaware of the rate adaptation is not necessarily the
worst thing.

>> I believe that our current approach is limiting, especially when
>> considering that rate adaptation (in two forms) has made it into IEEE
>> standards. In general, When we have appropriate information we should set
>> sensible defaults. To consider use a contrasting example, we enable pause
>> frames by default for switches which autonegotiate for them. When it's the
>> phy itself generating these frames, we don't even have to autonegotiate to
>> know that we should enable pause frames.
> 
> I'm not sure I understand what you're saying, because it doesn't match
> what I've seen.
> 
Sorry, I was unclear here. I meant link partners, not local (DSA) switches.

> "we enable pause frames by default for swithes which autonegotiate for
> them" - what are you talking about there? The "user" ports on the
> switch, or the DSA/CPU ports? It has been argued that pause frames
> should not be enabled for the CPU port, particularly when the CPU port
> runs at a slower speed than the switch - which happens e.g. on the VF610
> platforms.
> 
> Most CPU ports to switches I'm aware of are specified either using a
> fixed link in firmware or default to a fixed link both without pause
> frames. Maybe this is just a quirk of the mv88e6xxx setup.
> 
> "when it's the phy itself generating these frames, we don't even have to
> autonegotiate to know that we should enable pause frames." I'm not sure
> that's got any relevance. When a PHY is in rate adapting mode, there are
> two separate things that are going on. There's the media side link
> negotiation and parameters, and then there's the requirements of the
> host-side link. The parameters of the host-side link do not need to be
> negotiated with the link partner, but they do potentially affect what
> link modes we can negotiate with our link partner (for example, if the
> PHY can't handle HD on the media side with the MAC operating FD). In any
> case, if the PHY requires the MAC to receive pause frames for its rate
> adaption to work, then this doesn't affect the media side
> autonegotiation at all. Hence, I don't understand this comment.
> 
>> Note that
>> even when we determine (e.g.) the pause settings based on whether rate
>> adaptation is enabled, they can still be overridden by userspace (using
>> ethtool). It might be prudent to allow disabling of rate adaptation
>> generally in ethtool as well.
> 
> This is no longer true as this patch set overrides whatever receive
> pause state has been negotiated or requested by userspace so that rate
> adaption can still work.

Right, I forgot to edit this.

> The future work here is to work out whether we should disable rate
> adaption if userspace requests receive pause frames to be disabled, or
> whether switching to another form of controlling rate adaption would be
> appropriate and/or possible.
> 

I'm not sure what the best course here is either.

--Sean
