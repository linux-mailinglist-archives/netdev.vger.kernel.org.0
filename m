Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7565A1CBD
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244224AbiHYWu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244258AbiHYWul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:50:41 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20063.outbound.protection.outlook.com [40.107.2.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DE6BE38;
        Thu, 25 Aug 2022 15:50:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QoMlN9GTM0rwbZQ4BvBSfO5P9NeVh5y8/DGrWaPcEG/kk6Wu7Zg3Blv7x/OgirFSbk3QxEWHwUG9K9JLeYdrfsoZrG24c9P+YqERQrIvrsfbLoXxhOMdOrY1+ZYnHEV/ai3sOLn/70dBtjO2nybSr+XkmniopW/gEld1c5+m8s1tPPCM5N4Q+DjhCHdC8Ak4oT6xh8bDBvUkOUL5qEUg9bgsGvv6baFpE5dKx8/dp5fvVYUsj5rNfjvZ+RuUFbbeQg80jsryMrDue+TsT1tWANP7mGHJlVd3L3Q0w5v5h39lodqsaoqKP+exT5WSyOu2ktB5C1GOLiqROCoikN0/oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbmB6zL1t2na+T13xqBxm2nxSDZw+I4YaL8wimT4Abk=;
 b=juJW3xZH/R3tYqCw0rsTpyQmuHTUxtH3j50iLeBCxwQMCnOzQAXptsHO56LT32HHj10h7iJwr5xxeuGCMUg40/iOsnRhEDoSgPq9YnUlCcDvR2wojIVegT/CTkAbsRXh8uTyXzgeRLxAlTFlEVrvOUOiOxqQa3+Uzmfso9EqUg4RcokJ9fsBUcOa1t7FDnUKMZj9vh0JXXtiyNSw9F+2JQUTHJnIbRestuxxGK/zUssYFL7GQTU9FterD1PhNR3TD38mlEBbo7TB1Rri2bjZ97LX9IUZoUcqMMtpJa9h5QwetHucazMD+c0uZor4qKfZmMn4JrU+SsNno0BhHB5Jrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbmB6zL1t2na+T13xqBxm2nxSDZw+I4YaL8wimT4Abk=;
 b=OjWSHH/fx4LRNCL4yPmQ75v4cUjR4FgshBRwQXSj53P9Rr6vpbkH48YvBJpvck0+JHWpfABCrLpZ0yb8bIgOConzRvp8XrAZrMRuRm4ugnq8MO+4od7SmxogXNlCuwQ00Bspc3SrDyr8CCRKPflPchxo8pJ5qAfjYgkrYpAjxmVn9e3HN0k7GNss++9dlOl8TJ1Nm+ti6OcJVGlb7xq/7GqSE3rviFs3X4iCVN9x2WzHXmLlcig52KCmE8+n1X1PvCZ+J+LKuGDB7kWEr8Q1a0jIVyJUWrxd2RbpTA2ZKzLGrLYOEBGywO2Dk/PH/4ci2H/xpVNgHp2OPRRfT5yYWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4601.eurprd03.prod.outlook.com (2603:10a6:10:16::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 22:50:27 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 25 Aug 2022
 22:50:27 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v3 02/11] net: phy: Add 1000BASE-KX interface mode
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-3-sean.anderson@seco.com>
 <20220818165303.zzp57kd7wfjyytza@skbuf>
 <8a7ee3c9-3bf9-cfd1-67ab-bb11c1a0c82a@seco.com>
 <35779736-8787-f4cb-4160-4ff35946666d@seco.com>
 <20220818171255.ntfdxasulitkzinx@skbuf>
 <cfe3d910-adee-a3bf-96e2-ce1c10109e58@seco.com>
 <20220818195151.3aeaib54xjdhk3ch@skbuf>
 <b858932a-3e34-7365-f64b-63decfe83b41@seco.com>
Message-ID: <68b28596-cd16-2485-87df-b659060b0b0b@seco.com>
Date:   Thu, 25 Aug 2022 18:50:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <b858932a-3e34-7365-f64b-63decfe83b41@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0368.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::13) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 923ee210-e968-44fd-9b4e-08da86ec3419
X-MS-TrafficTypeDiagnostic: DB7PR03MB4601:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S4HegkqtgHjJthx4OKd7EXtJk9Uk7bcQnaqrE0ouMTW3cTpX+3oa2hcHkRay2JkPSI17win5BJsP9b/GoW15wxG/uKkWAuWWhmhyzWiLouxst+O/FO1uhvREi/YeaqixsFYHqNXswIcAmyAJl10KsictaHeHi6F24vsOXEsUV7YpYrQ5VJzReExuO6fZWIE1x1+cFbOMR7ip3VpfbqVwRyBHtebLqotUkhgnL32R8lEuM1u5XkY5RlJ1OE5wNTwhYyezFoyEMyxC1DWxjzaF0wmTR0R9gJe3jgw0gY1Laq06iFgpOH8T6FXlp34CLSU7VdEOVvuRCY6AXWeZLPKAj8wXL/rR1ToDkIoe8TMZWJ4CzyKq28pMlB81WtlLP6f5Y+N76XXnW/lOXx2SiT5s/EoiSNp88dkzgsx//W46mVndHy1gb6j3Z8xr79GvS4NFoaHZ6fFWd/9Umw0LyE/zxMHYGYbXnxTuK/VeSqXq0ZLHPTSmNW/1uG9S9P7R5fd/7dH0KFSwhxoj4+d4KeVpC/vVoeeUc6apcaqKw0V+uyrdFNaVRW22Azyfqg9EoiSSb9bYvEMiRD16ti8oWNLmgFE1QCyH/Sdv/nRfxCjVaL7WcgeizhccUlKcAj3MYBv0bGpUOGa32W6QMOxmsf1CxI09QzwyFCB4pYPDM917vZtcCaP9L0VVPMTKemg8NldZvAEdQDjvRBz5QVN/jR1uxmGW3lsHZkV7XyngKpfqtIeSxVrvmqLvl9t/jS8pM8ei1bzCo23OKRt9xuaDY1FMCYj2DygMniQVsDnOG40c7tjfkh2m/4igGqiIvoxA/LyuaJ+rLKohKBlT6xMXyrysvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39840400004)(396003)(366004)(136003)(376002)(346002)(6916009)(54906003)(186003)(2906002)(316002)(2616005)(31696002)(66946007)(66556008)(66476007)(41300700001)(4326008)(38100700002)(6666004)(38350700002)(8676002)(86362001)(83380400001)(31686004)(6506007)(6486002)(44832011)(36756003)(52116002)(53546011)(5660300002)(6512007)(26005)(478600001)(8936002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkdJcXNsb0YzOWtuTlBsNHMrbTZodVBnbjA0UkNtYnJqekdOcmV0U1dBbFY2?=
 =?utf-8?B?SXpHdkN6UlhtQy9ZV01hMm1EMC9zYjRNRFpvaklkTlNPMzlTbG4zWlJ4TC9t?=
 =?utf-8?B?WnIxZy9QNURqMXFjdndZUnpSQ0xnYXRNM0R1cWM0MVBVQTY3L2RCc2Fpemhi?=
 =?utf-8?B?c2RJVFVvVnc2ajNmQ004ZlBaOW5EV1FpQ0FxN0NLMEVqMmlIWEdtd0xieTc2?=
 =?utf-8?B?UTVTeitjVSs0bXlTYWNNNzdUNzlrKzE0ZEtUdWpyamh5dVBVN0FOUnZlTmFo?=
 =?utf-8?B?N3RENlNaeEVXMWNsbHZWZm8wN2ZxM1ZRNXFJN0Q1WGpqNnVUcVBmdzNOOTBN?=
 =?utf-8?B?L1M1cCtYeEhaS3ZaSDlkamlpcUJsZkhRaEhRbTZFNE9ReGFadmVSM1RaNTRl?=
 =?utf-8?B?TFJTU1lxK3RVZUFqcng5NlFQSU82YUhuMDRiTXNzcmxPaE92Vldhcm1FUk4v?=
 =?utf-8?B?NlVQR05rcGRYSm9IN05sRUlTUmVpOFdaU0xWY29pOWU3S3ZxK05qWE9pdHBW?=
 =?utf-8?B?TkRGNjZxNXI3U2VOaTBJOFRySFY1djV2VjlCYjYxVDAycW5tL1pqNWN6MmIy?=
 =?utf-8?B?SjB3QWFoWXA3cU90Vnd4bVpwV1B4bXNXUnRNcTNmZDRQcEc1SjZudFdPNzFB?=
 =?utf-8?B?M1dWNzFJNEx0VW1KMW9CeDNzQXpCK211K0pWZ3dtVEJDVlp1UE4yTDM3UnFD?=
 =?utf-8?B?dCtVc2l0OFd1SjlKSjUxRTVYMkpReWQ2WnNNWUZ2UExWQWhnU2I2UlUvMXc3?=
 =?utf-8?B?dFFaNFZuZ3BtOG1jS2Q5M1lxRStqZ3kzOW4xaUszWHlPNHJzN1FXdnBXS1pD?=
 =?utf-8?B?RHBiMEkrU1o3ci8vUnpOSU80N2JSRHBrcEJUN0lzZjBaajRBU2lSdDI5ZlRX?=
 =?utf-8?B?SEpVMUV2a0ttakdVUVM5UEJPMFQvSCt1N3Rza1hKZGd0NEp6T2ZOVmhzcmtm?=
 =?utf-8?B?a1AvM0I3c041R3F0dnJNNmJ5K0ZTU0VmZ0NoYnhvdnpDdGRWR29ralRuVzF5?=
 =?utf-8?B?WDYwVndPaHZJUG5aNUNzMUsvVHorbzdrWE9rYXZqRDA2T01xZ1lkQ0FTdWph?=
 =?utf-8?B?S0hINktVODdpOVMxZEc1NlFCVms5ZndWV21CTnhvV1Q4UDVOYno3YVBXVW1o?=
 =?utf-8?B?NHZMUENKR2dmTm9wamxkc0tGOUg4M2xqWkcrNEU1NERqNWNpdGJoR1JxTUtK?=
 =?utf-8?B?NVZoZjZidkIya0ZOZUkzb3VhUVFMQXhWVXZHUXdDMXFNTGRsNVRDZm9TaGZ4?=
 =?utf-8?B?TjBqcVYxVGZ4SzdrMExkcXE3RVVsU1JmNk9GMzdIT0dKYUxBN0h0ZXRDUk0x?=
 =?utf-8?B?MTkwdFJoeDh6ZFZOYmxHY1dtWVVRa3pHKzJVZUhrTldvY3FNN0p6MUN1Q0E1?=
 =?utf-8?B?dzVZUXJ6ZVFwazduUGMzN05rc3lZSTdBbmQvY3lIMzBhWTZrSDVrNzY4VHo4?=
 =?utf-8?B?UW9MUVU2U3dwZmd4QXBVanBuL1ZkVU1vUE9sTXU4Nml5TS9VS25xekdTNFZl?=
 =?utf-8?B?ajZzZ1Y5REJ2V2pQNlBJUHlrOEU0NFRSZHczMXpDRS8wK0NKZTNWM3FCV25x?=
 =?utf-8?B?MWpJTjdoNmtNT293T2lTOTdSMHVYUHNVWHE3QUdoc2N0ZG9PanI2N2g1aFJv?=
 =?utf-8?B?cWdtQjl0N0I1WmlISVF2aDhGc202ZXo4UFBXY24wU2VHRjZkbXZqeWFhS0tL?=
 =?utf-8?B?NGZJRjFpQ3RaOURnYWMvS2ZFRXAxMmVOdExQNFBTd2RvbStIU2RLaW84NCtk?=
 =?utf-8?B?TjFHaGFkSHFYdHhBSFVwUERNTmxOd1p1aDgvc3UyTUJBSkxTeC9KNTRUOWVT?=
 =?utf-8?B?NU1yVzgzOTV1QlFFNm5ObEFFYUN6NmR6cnpoV281bG1yYVhucjlnZUhnWllT?=
 =?utf-8?B?b1JRaXQ3RTZWVWNUaVFEamZCd1pOQ2p2SzBQc2xDWld2YW1WZ0I0cWxudEJU?=
 =?utf-8?B?MHhnYXBZbm51TExIWTE1TGc5ZHZwNWs4SFVXOEVFMHU4eG1MS0YzVjBMSi9W?=
 =?utf-8?B?bXBtckpJT2tKdzR0cjhDMnZQTG9GdDVtdllHNXp2MUphN2EvdFA3SGc1ZjE3?=
 =?utf-8?B?T0t1SThkZjNQOXAwSndRVGdaKzM2YkE3VHdTcHZXWjcvMEx6OS9tQmkrbFZu?=
 =?utf-8?B?NUtvczE2UGxiTGlycDhLSEdEWDlqcnJabFRNSVEwYllOck9XenRNVURCbEhh?=
 =?utf-8?B?ZkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 923ee210-e968-44fd-9b4e-08da86ec3419
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 22:50:27.2562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xI1thXbZuZZkwo2sP7/8khn6ee3XEzgkXWuAOE8nevFnycYWU3wuGyJ22D4/GQj7pU4tmzzA5267sSffECYtjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4601
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 8/18/22 4:40 PM, Sean Anderson wrote:
> On 8/18/22 3:51 PM, Vladimir Oltean wrote:
>> On Thu, Aug 18, 2022 at 01:28:19PM -0400, Sean Anderson wrote:
>>> That's not what's documented:
>>> 
>>> > ``PHY_INTERFACE_MODE_10GBASER``
>>> >     This is the IEEE 802.3 Clause 49 defined 10GBASE-R protocol used with
>>> >     various different mediums. Please refer to the IEEE standard for a
>>> >     definition of this.
>>> > 
>>> >     Note: 10GBASE-R is just one protocol that can be used with XFI and SFI.
>>> >     XFI and SFI permit multiple protocols over a single SERDES lane, and
>>> >     also defines the electrical characteristics of the signals with a host
>>> >     compliance board plugged into the host XFP/SFP connector. Therefore,
>>> >     XFI and SFI are not PHY interface types in their own right.
>>> > 
>>> > ``PHY_INTERFACE_MODE_10GKR``
>>> >     This is the IEEE 802.3 Clause 49 defined 10GBASE-R with Clause 73
>>> >     autonegotiation. Please refer to the IEEE standard for further
>>> >     information.
>>> > 
>>> >     Note: due to legacy usage, some 10GBASE-R usage incorrectly makes
>>> >     use of this definition.
>>> 
>>> so indeed you get a new phy interface mode when you add c73 AN. The
>>> clarification only applies to *incorrect* usage.
>> 
>> I challenge you to the following thought experiment. Open clause 73 from
>> IEEE 802.3, and see what is actually exchanged through auto-negotiation.
>> You'll discover that the *use* of the 10GBase-KR operating mode is
>> *established* through clause 73 AN (the Technology Ability field).
>> 
>> So what sense does it make to define 10GBase-KR as "10Base-R with clause 73 AN"
>> as the document you've quoted does?None whatsoever. The K in KR stands
>> for bacKplane, and typical of this type of PMD are the signaling and
>> link training procedures described in the previous clause, 72.
>> Clause 73 AN is not something that is a property of 10GBase-KR, but
>> something that exists outside of it.
> 
> You should send a patch; this document is Documentation/networking/phy.rst
> 
>> So if clause 73 *establishes* the use of 10GBase-KR (or 1000Base-KX or
>> others) through autonegotiation, then what sense does it have to put
>> phy-mode = "1000base-kx" in the device tree? Does it mean "use C73 AN",
>> or "don't use it, I already know what operating mode I want to use"?
>> 
>> If it means "use C73 AN", then what advertisement do you use for the
>> Technology Ability field? There's a priority resolution function for
>> C73, just like there is one for C28/C40 for the twisted pair medium (aka
>> that thing that allows you to fall back to the highest supported common
>> link speed). So why would you populate just one bit in Technology
>> Ability based on DT, if you can potentially support multiple operating
>> modes? And why would you even create your advertisement based on the
>> device tree, for that matter? Twisted pair PHYs don't do this.
> 
> The problem is that our current model looks something like
> 
> 1. MAC <--               A              --> phy (ethernet) --> B <-- far end
> 2. MAC <-> "PCS" <-> phy (serdes) --> C <-- phy (ethernet) --> B <-- far end
> 3.                                --> C <-- transciever    --> B <-- far end
> 4.                                -->           D                <-- far end
> 
> Where 1 is the traditional MAC+phy architecture, 2 is a MAC connected to
> a phy over a serial link, 3 is a MAC connected to an optical
> transcievber, and 4 is a backplane connection. A is the phy interface
> mode, and B is the ethtool link mode. C is also the "phy interface
> mode", except that sometimes it is highly-dependent on the link mode
> (e.g. 1000BASE-X) and sometimes it is not (SGMII). The problem is case
> 4. Here, there isn't really a phy interface mode; just a link mode.
>
> Consider the serdes driver. It has to know how to configure itself.
> Sometimes this will be the phy mode (cases 2 and 3), and sometimes it
> will be the link mode (case 4). In particular, for a link mode like
> 1000BASE-SX, it should be configured for 1000BASE-X. But for
> 1000BASE-KX, it has to be configured for 1000BASE-KX. I suppose the
> right thing to do here is rework the phy subsystem to use link modes and
> not phy modes for phy_mode_ext, since it seems like there is a
> 1000BASE-X link mode. But what should be passed to mac_prepare and
> mac_select_pcs?
> 
> As another example, consider the AQR113C. It supports the following
> (abbreviated) interfaces on the MAC side:
> 
> - 10GBASE-KR
> - 1000BASE-KX
> - 10GBASE-R
> - 1000BASE-X
> - USXGMII
> - SGMII
> 
> This example of what phy-mode = "1000base-kx" would imply. I would
> expect that selecting -KX over -X would change the electrical settings
> to comply with clause 70 (instead of the SFP spec).

Do you have any comments on the above?

--Sean
