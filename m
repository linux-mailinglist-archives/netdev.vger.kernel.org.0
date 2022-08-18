Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00F1598A78
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344530AbiHRR2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238773AbiHRR2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:28:30 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8EF4BD34;
        Thu, 18 Aug 2022 10:28:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jG+rtYutWwxsgYzh/iu49RGFlTNnCByDw1Nex7kmSjke9cCkLsZQMRQ2rNiu+0+qYJD/S8KMr2ozCm0O7MZmFE0d9hmzln+ezjHo9F7mSyMOJ9oPsHaC/zZHMIGkStDyOkPsHDTt64q9FcNg3Rv1XxDy185pLjC6P6y29kMrqbMb8VrtVVlaOfOFbQMZFnC1gEIhhwk9qbg18/RgzuM4pesLxPkXKzvWMwMaJZX3IfuVvxPPqpLbznmSqjbEt6fmDBK6H8JAwgtiIdNgD/rqcx0Vp03zfUKGwbEPSphZJWdaQLg3Xkq2Timk96ZVK5PRULIcg70UkU4G/eLl8lYVBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWXBu7YWZSUWf6hfFU+DqQJYk4jqylsYgx8WnDhQvzg=;
 b=Cw8LE1ZDgKyTeFcF/U6WnEe1k7YCvj23/JQ3G2vRvRFIscrh20C9jWdYzMxXHDJjDwKZI+mh6mR47gIbBNT/ZI0JffRLGByIqU7GXxf6p96gqY473Vd/Xfa/EM2BygJsH45ZO7R44s1QaLDdo805DaY4N8L9E4/moqW6spHtX1Qt0BIhtz0aquEvOVjsMeoKAtpAV/EhmOs6WA29xY9gfni7Xu3V0SN09aWMxOGfSLPEzUhm6dH3THie31xsljN98bBhUg04G2M70QviCKkv3hRpK2QFc2JYnLZC2z2s2PUqxG0wbZphKQG8mTa3hDR5++DNRpBLQJfH19omihOBoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWXBu7YWZSUWf6hfFU+DqQJYk4jqylsYgx8WnDhQvzg=;
 b=BHk0gM2em39lBnozsBqLWZui/UUZZjFMOcxUgY5rYYePAaV9SARiPMKcTeBu9K4f93Lu6Nq+dGB9B0Xkm1NqHxzxGzoQ182FCp3WmOlLvUkYHO2sr+07Xa1RypemzwxzZLnAtbzE9ciUuuFt5OwdssjMM4uT1vVB2mo7I5/vu4wvsKGzt29TOM70Bj0HJaoDvRSrkUyltUhAP2gy8j4j/kYIzeUT0Us3oP/TaeM43E2tX9iPkKOyBP8vZgs0fAPb0e9NF165g1Qkpgd2djnVTiICShLwZKUGcAsCcx7lZ5p8r+Nb+4ju0Kt7SzAI5QElCz0ToZcjPI34klAjsrn0SA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7125.eurprd03.prod.outlook.com (2603:10a6:20b:23e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 17:28:23 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 17:28:22 +0000
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
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <cfe3d910-adee-a3bf-96e2-ce1c10109e58@seco.com>
Date:   Thu, 18 Aug 2022 13:28:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220818171255.ntfdxasulitkzinx@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0093.namprd02.prod.outlook.com
 (2603:10b6:208:51::34) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb94d86b-1985-4a70-46b2-08da813f0cf4
X-MS-TrafficTypeDiagnostic: AS8PR03MB7125:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y2djc3h/GObUP4TlBf05zNwZX98Kj+GsjDW1D7PKAvC+Glz962LKb9bNiC9I06dPTcmyldzabO0RG0tbuIlV5L35/yiY4LEze9GhAU7NhDvZLX27MW7jirirY0IiWoNy5lHlkApk3oAgnVJRGH9E867Bc3KoRWUWfG+UeLXAh+TNKP4uSQ0Gi4ulKMbZ60BMWZagqg4HiIhxgpcrbxD1r+tXyIDOdrErLbmG4awEQrRR9yRBky//rPA0ShZAW/OKRrDkjp37mnAXb728qjBo1EdTGtfZkkZUBP8OfPiYKVhFU3K2nFg+00u3gJ7o7v+o4NSRi142ZGCDYIw6U4ur6GdNe0OSV2uHwRWHScPdIlSDXgitNIvT1bMRgTWCSHV/cyJcy/E3G3qfG65IJ69YU5PjmGuqentfhFUkDMOKl6XzSF8K+RpcZbzgolZ4qf/AExWBLL7XvYMtuJR4GqGgcy/BCVlODWfhVm3R+l54fsv8zh4pRDMk9stMMJ8OJayOa1rSg2/HxALyuyPxjrjFw6MQ9+4utOM5BKC66KpLc2r4iChceU6K86Mfia6JSu6z9Y4oG4ZcJlZCxMvZ/5ZCSKxWprIt79dW7ZWICIq/Ww2YIkPHp+fed7Ffia55V0W91V3H1+5dzR011rysdTWks9fD3T9BvKrpQ9bg6KGh1qyzjJSq6EVJXXGrCzXmk+41OrDFsaAoWsIaacOMs0YOa6Y/ifBGa/19pR1B9ODTmdF07cZA64g+4PdiCG/I4tLYhcsJgfPg+MjUKiu/5HUDe9p+KFzrYnXGYeDqec1qgGx5L6O9AHvQcdrPJDQtqthaCE2zIZDFBHP+PcVXdwwh0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(346002)(396003)(136003)(366004)(31696002)(2906002)(6486002)(52116002)(6506007)(66556008)(66476007)(53546011)(4326008)(8676002)(66946007)(8936002)(7416002)(5660300002)(44832011)(41300700001)(26005)(6512007)(86362001)(6666004)(478600001)(2616005)(186003)(316002)(31686004)(54906003)(36756003)(6916009)(38350700002)(38100700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkJNNG1tMjJOQTdTL1pWMjVHSm9CRGh6Tys1VlpXMmtsL0JNcFIwV0p0RHJD?=
 =?utf-8?B?cmxjeEtXR24vditFSGhpYnF0NVN3T0wvdU5KcUhRaUZEK093dnpucXA1WGx6?=
 =?utf-8?B?VHlxdjFMK3M1NzdNaGZ5R1E2dWJQd09XdXJ4NlNlUS9oSHZjMnNZeCt3UFR4?=
 =?utf-8?B?WFYrdUFXUmozdTBpajd0NnpRSHFvdk9HZUZYc01QY0QyK2MzQ3BKb3NaVzhJ?=
 =?utf-8?B?VmxxeHc4SEpTOGFhcE5yeXd1NWtjck5SZGJ1SWdrYUI3d3ZyZzVMTm5DNEtn?=
 =?utf-8?B?SzU4dXpheEVPdGwvcWpuZ2piS0d0LzhhRkZETUVPeFJORDZmYmVDMC8xK1Jr?=
 =?utf-8?B?b3ZyK1IrOWIzUXRoWWlBVDZZREt1NExVSHNSalNrMlJkNGw4Wks3VlB0K1Rw?=
 =?utf-8?B?UUlVU2FNRFNMdkNnZEZaSHh2QjkxcTEzbCt5OEZwM3VadVpKUlozOFdNdW5R?=
 =?utf-8?B?cnc5ZXQyY3ZTY0J3QW82TDgvNUhoK1JIOUd0alpxMDY5bXFtOUwyZnFwaHdx?=
 =?utf-8?B?d1RuL0wxZGhuSXplRi9jTzBMSUJPMnVaOEN0QnRpQkJwWVBNRTY0MTI0MEY3?=
 =?utf-8?B?dlhkcU50a0lMMk5IWXpHU2RCS0VhNGpBQ1YyaUlHRUtieWl6WFkwZmhKb0Yy?=
 =?utf-8?B?NEpwOGdaVWJ1N1I4VldPQ05UdHpVbjRXMkwrQm10LzV4M283SW92NVJXSVEw?=
 =?utf-8?B?TkFrVDMrM1paNGZ0cnkvR3AzR2JtT0oyNnU4OFlkcEg5WTExbktHNmxMbFJn?=
 =?utf-8?B?ek9Xa1l0MjMyMzRib2ZNYVI1SEtQY3QxVld5bnNJMkFWOTYvaHhoUEN0aFoz?=
 =?utf-8?B?aThEd3c5cXpxWXp1M2dBRkh4S0hKNU85cmdzUHJ1Y1EvL0dGalU3T2R5cFlj?=
 =?utf-8?B?U3dvVVpRbERxNElUZlVrR2dpdW9ETDRtOVV5b2hPYVJzOXdENnhIN2VaQStG?=
 =?utf-8?B?bHc3WjBReTdpZnZXa0ZVempaUFc5RjFBMWNDRmlZK0Vta1Q1ZVlvODFOWjN6?=
 =?utf-8?B?NGR1RUFSMFJZS29iQnF6Vkd2R3EybjB1eWpzVVd2L0ZGWlRCWmRsR1lQcVVT?=
 =?utf-8?B?UkxuaVoySGU2ayswQWRUUWZrVXlVL1dLQTRkeDBFbU03TVM4c2wvY1dQZ1Q5?=
 =?utf-8?B?dlpqSlhEYWh0WEJOU3BPNnBwUjZldUpGOVduTVplM25nU3dlblBvTnBZa1BG?=
 =?utf-8?B?K3M5Qi95UDc1NVBCVU8rNFhycDljYUphYzZ3em1uelYvL3cxWmR5alFFSk03?=
 =?utf-8?B?K2IydGpRMGJFOVhzclFTbndxUW1icmUxVnVaMWpOVHNqUm9SMkgzSWczVnFJ?=
 =?utf-8?B?d0k4Zll0Q0tRSFNZVXNtdSs0d2Rwa09HMXZqSEFieDhOZGlCWi8vQS9VRFpy?=
 =?utf-8?B?WmJLanNobkl3azIwY3FxdEZQbkoxSmQvd0dPNDVTMGlGRlloNldsUTRoM2NP?=
 =?utf-8?B?ZStaNDRxaDR4MWdrbXZzTG43eFo4N3FpWjJ1UTR4RTlnOE42RDdoWG9PK0Nq?=
 =?utf-8?B?WlRobGplMnJ4NEJBck1veWJvQ0xEVk5oOUl0aW85YXpoSUhORzk0UjBuR2tW?=
 =?utf-8?B?VFJMTTkwUTlieERUaTA1K3BMdmQvSHlJMWFKVG9ORWx2bXpmYllwUFl4aitw?=
 =?utf-8?B?czhFSmtGYlNBdnpmeEFqeFZXVnpOSWRzbktJUEZvQnZ3R0trNzFsbVF5d2Vh?=
 =?utf-8?B?UlBNdnJkbnEwM3R1VlRCL2JWRERmZEJ6MEpHV3R4ZDNweWNUR0Z1V1BxUkxj?=
 =?utf-8?B?M2k2MjUwUzVmam9vY3BOY25OWkw5dCszTHRhQ0ticjdvSStYYkJ6eGk3M3V4?=
 =?utf-8?B?b1RpTjZEeVpVU1ltdlBYT1pFUGhBdUlWTnh6VjlCVm56L2d0Wnh2RVJCZVE0?=
 =?utf-8?B?Z2NrM0UrZzFhdDFlMFowdUYrR1VuQ0ZJV1ZDQkhsMStNM3lDMWdHcEJPYitk?=
 =?utf-8?B?cGFGZUQ1clZRMjhrN1B3WlpxdWM4azY3WnRsTktZNjNpaHZJcjhRWDJPdHQv?=
 =?utf-8?B?VXRaQlcwNFlEUGJ3OVIwNndqUTdTd0RMa3hwcWxRRmljd1JzMXFZVnA1Q1Uv?=
 =?utf-8?B?dURjOHpZeEZ4TzhIWEJHOGUrQ0dIajdWUDJ5TkRwN2IxMzViejBOY3NlQk9Q?=
 =?utf-8?B?ZTFySkkzZzMyamJnMUQ2bzhpUUlQY0pQY3NTc0k4SlErQnNnbFpuWTZUQ0FN?=
 =?utf-8?B?N2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb94d86b-1985-4a70-46b2-08da813f0cf4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 17:28:22.8010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACTLu9VF91qH5tp+I8kMw/VPbNBeURZz4SNZODTpzm45bIx9VkSXEHil+OG6MPmysZ0Cx1R3Uemth/043g+A4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7125
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/22 1:12 PM, Vladimir Oltean wrote:
> On Thu, Aug 18, 2022 at 01:03:54PM -0400, Sean Anderson wrote:
>> Well, I suppose the real reason is that this will cause a merge conflict
>> (or lack of one), since this series introduces phylink_interface_max_speed
>> in patch 7, which is supposed to contain all the phy modes. So depending on
>> what gets merged first, the other series will have to be modified and resent.
>> 
>> To be honest, I had expected that trivial patches like that would have been
>> applied and merged already.
> 
> There's nothing trivial about this patch.

Perhaps "limited in scope and mostly independent" is better, then.

> 1000Base-KX is not a phy-mode
> in exactly the same way that 1000Base-T isn't, either. 

It has different AN from 1000BASE-X (c73 vs c37), and doesn't support half
duplex. This is something the serdes and PCS have to care about. Unfortunately,
we don't have a separate PCS_INTERFACE_MODE so these things become
PHY_INTERFACE_MODEs.

> If you want to
> bring PHY_INTERFACE_MODE_10GKR as a "yes, but" counterexample, it was
> later clarified that 10gbase-r was what was actually meant in that case,
> and we keep 10gbase-kr as phy-mode only for compatibility with some
> device trees.

That's not what's documented:

> ``PHY_INTERFACE_MODE_10GBASER``
>     This is the IEEE 802.3 Clause 49 defined 10GBASE-R protocol used with
>     various different mediums. Please refer to the IEEE standard for a
>     definition of this.
> 
>     Note: 10GBASE-R is just one protocol that can be used with XFI and SFI.
>     XFI and SFI permit multiple protocols over a single SERDES lane, and
>     also defines the electrical characteristics of the signals with a host
>     compliance board plugged into the host XFP/SFP connector. Therefore,
>     XFI and SFI are not PHY interface types in their own right.
> 
> ``PHY_INTERFACE_MODE_10GKR``
>     This is the IEEE 802.3 Clause 49 defined 10GBASE-R with Clause 73
>     autonegotiation. Please refer to the IEEE standard for further
>     information.
> 
>     Note: due to legacy usage, some 10GBASE-R usage incorrectly makes
>     use of this definition.

so indeed you get a new phy interface mode when you add c73 AN. The
clarification only applies to *incorrect* usage.

> I'd suggest resolving the merge conflict without 1000Base-KX and
> splitting off a separate discussion about this topic. Otherwise it will
> unnecessarily detract from PAUSE-based rate adaptation.

Well, no one is using it yet, so hopefully it will not be a problem...

--Sean
