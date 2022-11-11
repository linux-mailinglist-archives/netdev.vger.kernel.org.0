Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891EB6263E8
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 22:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiKKVzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 16:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiKKVys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 16:54:48 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E8319C31
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:54:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ib+bd9pPgTZg5SuEpOOwt41/H3eXp9d/xME0XLBaunntwkD27nqptGtq0lSi0Y8JFc0jRZdYW3zCix7G0CXh4mXcu3/TaiCKlxrcxYNRFRu96/VMTa2yHKNjF6PQjspY4Fh9/s/VW9vMCC9n8bugryrOaXWF/ZxW/6ZPq12BdC+pKQq6gFWfJu6S7nydigSq1r6o06zR0veQKSqAGCaDFA+rEfqUOIriZKSy/LgHcC/qbTrGhFzQKN8Q2DVUs29JCr7r7eJ2oxbFCLSbpjA3nDzEyYLWcDC4fnar6o+0PAsLw77QbYaITv3YfXq/nNVjjljC0ikduptQUlNbRtPYwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGLrwgjR+1NyIlooBpRmth/1yrCobitKqnqxN6bew4M=;
 b=dV5GzPmuHcVs4gjBtB2k5WilXjg4zPMa6+SiEj/ZbU8hOVxU0QNVTK2TNZ7jJOUe6YIoZhdI8qiChIDZFICpOAJbPCHV3UvdgHM4OPnzL8IMfxqxWhoJpoVE/h8bZGkwqFWfyeyHumkK5dXaZaNa4oRlJ+/gHh0qghYTEhe0iDpxTlkYtD9nHACXk46nlBe2LUKKtS0Eei9eFO8LJEWw3ItDHP3GYtWAmDGJJzgo6HhO9RHaL/XpBzhB6kX2BgwAwgFzfYSlt8aKnViFkc6u2o7VnzhZVOq6hhU4fEkHgHka5EPPI1eOZ+T/PUAshWxq0Zk5xiSohvqX9jpRJ5kDkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGLrwgjR+1NyIlooBpRmth/1yrCobitKqnqxN6bew4M=;
 b=ah2QVhFjciRF3MoEcfdoVSaPc0Vc30ptii7T9dZxOvC6E1HyHfTrww9s3r/VEWGVX7nvG6IfBQz8RMfpHltfQt43Gu5a8sYOEUf3DUV0h1uecgMYYV6DVCOqhpH7PKu1lECunYaA+l6jfNf9KYKF+sOvPbPQmAwKFwzzYDNZHQ7Mz/ewaLRZA3DNb9WHYYf3/Er3QfYM7+NpilMC4wxn+X4UkxnI4ybBWOx4tqZaBwkwBTOjrUc5whN36d/xR0P+55xuJwNu0BtpBVs73n4GP3KGkmAql887Grm+3566suCyKxzXzREkborgNmi775f37kSql/1EabHiArBnvLygrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7539.eurprd03.prod.outlook.com (2603:10a6:20b:347::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 21:54:44 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 21:54:43 +0000
Message-ID: <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
Date:   Fri, 11 Nov 2022 16:54:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: status of rate adaptation
Content-Language: en-US
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0002.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB7539:EE_
X-MS-Office365-Filtering-Correlation-Id: 77c8ebbb-ae7e-48cf-422a-08dac42f5758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJFOfPs+//Jk6yh0zTxIcyUTcK7K92rKRkYyQGpHQCrnsUH0YYz6MnjDtzi6834T3lXuozeGlE57jTTmZPjmHLwaP4rHDTqmCmBJs3EGSgcvoweyuGGNaNOmfDjELuWh+k16Qu2TAnJo6bWnMkRuzYRLZm9y6+wSDU3XWmRKs91d/I3vabgzTMwklbkxHjsKBYMNcoEUpV1NV0foR3oJsWrhP/MfPoY++cI14u7ueN6LX30TImvxgjjsM/23i/0UUC2TwmoPoYwF95ddwIwQn//UauU80LC7OFA3dTZcV4CMPYoq+6mBgpSRoo+PYemFn5gULbw7jUBzHTTo2Mq9rkx8aauzsyMp3ZNePstF5khHmleJ/0B7HgICX8hxwXC9yaU9q/D6VToORM0aIsYSOotWlk4R9Q7xTXEj2aj/ivfWZbeSG/BvauVy9ALFCXcBvqCvqTG++jIaNBujjEt9fZPuJCPQ2QmdY0qb3Z4pz3QoII73rUBiaNtXbjIzauaG5IkY91CInUkYZV8whBDEjGImMxNmV/P/2w+zTMgdyMUibeIaz3qUqWecrWKizyha6VmTpQDjdJOwwz3eNlihfYIfHWWOS/v/DWxpPJ+TuwKmhRG5RMNQA21HDnB6B7zxdxoYsbKd24+51KQALxAm48jZkmNYszGzSaYp9iaEd4DyqKraOckOs7gZ/zQzAhJf9w74qxKP8rBqMj2AAJJp2+8qSJtcW9evU/KcQEcLfI8DBwqBP6/SEjPU4+MPXPMsP3eO4W5sRe056bxsVpfHJmqwulWJop2m2dIONaSZVQIHua1Y6e9OgDtbrRXa3GMR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39850400004)(346002)(366004)(136003)(396003)(451199015)(8936002)(5660300002)(2616005)(31696002)(86362001)(41300700001)(3480700007)(38350700002)(38100700002)(2906002)(44832011)(186003)(83380400001)(36756003)(31686004)(6486002)(478600001)(53546011)(6506007)(52116002)(316002)(54906003)(19627235002)(6512007)(6916009)(26005)(4326008)(66476007)(66946007)(8676002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXBPR3luWkhzYlk0ZGtKVG1zMjNhNG5EdzZRR1lmUHUxMHMwQVlIaHlEL2Fp?=
 =?utf-8?B?cUtpblJYSWZ5VTRDN1J4ZENaL0pKSStYbDZtclUxY3JIckQ0WlE4eDErMG9a?=
 =?utf-8?B?ZjhtaFY2MHhpMUw0ZHdEZHk5TmxENlZzbHRyb0M2L01YdjhrcU0rRytFYThv?=
 =?utf-8?B?TEdqbFRpZWIwcFcwYlJlM1FLTlpnU2JMYUpzeWpsQ1FTenFIaTZLUXEvVXhQ?=
 =?utf-8?B?NS9hdlFPdFp5UUpmd1dlc2swZVU3cmQxMVU1T3RaS1lvVkZKR1BsY0Fwcjk1?=
 =?utf-8?B?aDNmcEUvNCtOOHpyNWEzaHNIVzFFc1JJY1pnZm1JRUdMWFFmSEJaRnh5REhj?=
 =?utf-8?B?SUFTZkpiMXkxRitzMFNQMks3bS9LMFB5ZkFQbEU5TFJFZTNGeFg2eXBmS3VW?=
 =?utf-8?B?Nkh3RWNtbXNvV29MT21uWFNjTmpmUUZOVVNZbkNucG9mekRqekFtL0tMTUF4?=
 =?utf-8?B?UGxZOEMvcUpPa2NiZ3JraHpzMG9nSlU2d1c4MCtoTEZURmtUbmhYUnJjTFht?=
 =?utf-8?B?MEdiVEpkUWk5TWJ6MzZ6RjVKckkvbTQ0RmF6bS9uOXJqSXNlUHI1TUVVNG1n?=
 =?utf-8?B?bmFlVys1UWNGOHRSOWw2ZVZ3azJ2aG92US85ZVFYVzNKUklUakZTcTUwY0tY?=
 =?utf-8?B?blM0YmFnYlVvME1MRTBnTldVd3JaWEI4eGtTQ2dWTmNSQzdweXkzY0JVN0g2?=
 =?utf-8?B?OXEvcGxEa1ZUTHkreFhFb2oxKzhaY0RUM3dQWWFrT0VrN29jS3BNQTdyeTJT?=
 =?utf-8?B?MG94QUQ2bXp3UGg2T2dYM0F3ekVPZzgrUW0yU1lMc2s2RUx0TFpyaHFkbjFL?=
 =?utf-8?B?ZEJreW1NVGs1VlE3cTNaRzlRTjRKNEhMZTFaSjQydUVkTW1Ec0ZCRjI4MDNG?=
 =?utf-8?B?bzZYWVY1MDRLT0M0elpBV291alNVL2JaNlRqOUx2a2dwc0t2RHJTbDBlVWtP?=
 =?utf-8?B?bXNkd1N4eVZDNDJ1ZHorTmppTy91djc4dUhpcE1JanNLcEpOUUFHbUdERUhZ?=
 =?utf-8?B?RDhqUG9obmtucUE5NkVsN1JZb2RhYzYzME43S2l3MDBBZVBFUUdFSU9USHRJ?=
 =?utf-8?B?NE84RUk0Q1lNbkNmUDN0ZG8zd3RQR1JRazRub09XckhBMFFVWTBvQU9udWZi?=
 =?utf-8?B?OEl0R09QbHJoOFNycGlhZU5BTUtuZjZYRVVvWUVOdnZZcFdEb2tpZmF1d3JT?=
 =?utf-8?B?MTI0L2lhZ2FsS29zcUNOM1RPOG5xc0FFRjIzSU4zM0NyakM4ZWpIcEovRUdK?=
 =?utf-8?B?eTVoUzFqSW01Q2w4eDhyYWpzTm1SaFNoRktDaFkzTFlYNEFxcFpKWGhuMnFq?=
 =?utf-8?B?bFl1WS95RWZHM1RHOTFHUjkyOXd2NnVxZmNSdlFIUnRPTm4vYXBoR0hjYjl5?=
 =?utf-8?B?bTdoa2NjYjQvUFJrOTFsYkRVWXBDdkJoYTkrenpUc3BVZiszcm51L2FBTzMv?=
 =?utf-8?B?NHZsaUN4SmdvYU5nQlJwOWgzYnlHc3Azcjl0RnJZdGJ6UitLL3VlTFpSSUx3?=
 =?utf-8?B?UjRuSklZeGtGU3IzT0VRTGRFeklqN05vMUZmYnZ4RW01ZG5hRlFidWlZWGFs?=
 =?utf-8?B?dVhvMlRBNWk0ZXBLczhDUkxCL0NHVGZQL3A0ZkdzQks1SmJwcHVldC9xaUxM?=
 =?utf-8?B?QlZGUnovb0RYUTM0dVVNUW55Z1Y1SXJlTmxRbkhENzhhU1B3VVhXNDI0OVVM?=
 =?utf-8?B?QTU5MmtuNkdPRkt0djUyUTBPcDllU2g1OVE3d00ySjVYajVzTmJPcXNMcDUw?=
 =?utf-8?B?WXJmZlRGVUNQYjFPY1M0L1VIV09td2hiZnMxNEpHRmgxdTV0VEEwUC9Ed3Nq?=
 =?utf-8?B?S3RmTGZSQmgzYlVsYUY1SVkwV0NMeER3bm10T0lBQ1BRNHR5dWI3RUNHRUph?=
 =?utf-8?B?WjRncXVINVNNY3pyMWVZcTJwRmhqamxsWmtSTVNDWnBlbFBvdU9XZklHaDhO?=
 =?utf-8?B?ZjlmNGw1N01MMDhuY3NUL1k5aklJUGs0SkdvSUk4M3VDcTZZNkNYRWQwZ2VQ?=
 =?utf-8?B?ZUpCL3ltRVQwNkIvNjU4bkhldk9LUnBYaitjaWtFWXNPSDBqOEFsT3Q4VkND?=
 =?utf-8?B?dXZ2d2E0a1RGVU8ydUkzcmJjWXAraWJZZXJLRjdnOGlhUUZtWXR4clJHSjZk?=
 =?utf-8?B?aENYNEtudmNqV2NvdnVpNFFQckwxUWZXMFFWV3psdk9lS3NmbXhZNS9vZnFP?=
 =?utf-8?B?SHc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c8ebbb-ae7e-48cf-422a-08dac42f5758
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 21:54:43.7536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tSqX0Dtfbws1EPw0zi4+fXVD+jQ+9Oyb+LK5OZFpGhxSHghUOt7Y7pHBw4aftbcZTeSiQPp0EeA+sbS8M7WTHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7539
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/22 16:20, Tim Harvey wrote:
> On Fri, Nov 11, 2022 at 12:58 PM Sean Anderson <sean.anderson@seco.com> wrote:
>>
>> On 11/11/22 15:57, Sean Anderson wrote:
>> > Hi Tim,
>> >
>> > On 11/11/22 15:44, Tim Harvey wrote:
>> >> Greetings,
>> >>
>> >> I've noticed some recent commits that appear to add rate adaptation support:
>> >> 3c42563b3041 net: phy: aquantia: Add support for rate matching
>> >> 7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
>> >> b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
>> >> ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
>> >> 0c3e10cb4423 net: phy: Add support for rate matching
>> >>
>> >> I have a board with an AQR113C PHY over XFI that functions properly at
>> >> 10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4
>> >>
>> >> Should I expect this to work now at those lower rates
>> >
>> > Yes.
> 
> Sean,
> 
> Good to hear - thank you for your work on this feature!
> 
>> >
>> >> and if so what kind of debug information or testing can I provide?
>> >
>> > Please send
>> >
>> > - Your test procedure (how do you select 1G?)
>> > - Device tree node for the interface
>> > - Output of ethtool (on both ends if possible).
>> > - Kernel logs with debug enabled for drivers/phylink.c
>>
>> Sorry, this should be drivers/net/phy/phylink.c
>>
>> >
>> > That should be enough to get us started.
>> >
>> > --Sean
>>
> 
> I'm currently testing by bringing up the network interface while
> connected to a 10gbe switch, verifying link and traffic, then forcing
> the switch port to 1000mbps.
> 
> The board has a CN9130 on it (NIC is mvpp2) and the dt node snippets are:
> 
> #include "cn9130.dtsi" /* include SoC device tree */
> 
> &cp0_xmdio {
>         pinctrl-names = "default";
>         pinctrl-0 = <&cp0_xsmi_pins>;
>         status = "okay";
> 
>         phy1: ethernet-phy@8 {
>                 compatible = "ethernet-phy-ieee802.3-c45";
>                 reg = <8>;
>         };
> };
> 
> &cp0_ethernet {
>         status = "okay";
> };
> 
> /* 10GbE XFI AQR113C */
> &cp0_eth0 {
>         status = "okay";
>         phy = <&phy1>;
>         phy-mode = "10gbase-r";
>         phys = <&cp0_comphy4 0>;
> };
> 
> Here are some logs with debug enabled in drivers/net/phy/phylink.c and
> some additional debug in mvpp2.c and aquantia_main.c:
> # ifconfig eth0 192.168.1.22
> [    8.882437] aqr107_config_init state=1:ready an=1 link=0 duplex=255
> speed=-1 26:10gbase-r
> [    8.891391] aqr107_chip_info FW 5.6, Build 7, Provisioning 6
> [    8.898165] aqr107_resume
> [    8.902853] aqr107_get_rate_matching state=1:ready an=1 link=0
> duplex=255 speed=-1 26:10gbase-r 0:
> [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
> [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
> [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
> supported 00000000,00018000,000e706f advertising
> 00000000,00018000,000e706f
> [    8.934349] mvpp2 f2000000.ethernet eth0: mac link down
> [    8.948812] mvpp2 f2000000.ethernet eth0: configuring for
> phy/10gbase-r link mode
> [    8.956350] mvpp2 f2000000.ethernet eth0: major config 10gbase-r
> [    8.962414] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
> mode=phy/10gbase-r/Unknown/Unknown/none adv=00000000,00000000,00000000
> pause=00 link=0 an=0
> [    8.976252] mvpp2 f2000000.ethernet eth0: mac link down
> [    8.976267] aqr107_resume
> [    8.988970] mvpp2 f2000000.ethernet eth0: phy link down
> 10gbase-r/10Gbps/Full/none/off
> [    8.997086] aqr107_link_change_notify state=5:nolink an=1 link=0
> duplex=1 speed=10000 26:10gbase-r
> [   14.112540] mvpp2 f2000000.ethernet eth0: mac link up
> [   14.112594] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
> - flow control off
> [   14.112673] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   14.118198] mvpp2 f2000000.ethernet eth0: phy link up
> 10gbase-r/10Gbps/Full/none/off
> [   14.139808] aqr107_link_change_notify state=4:running an=1 link=1
> duplex=1 speed=10000 26:10gbase-r
> 
> # ethtool eth0
> Settings for eth0:
>         Supported ports: [ ]
>         Supported link modes:   10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full

10/100 half duplex aren't achievable with rate matching (and we avoid
turning them on), so they must be coming from somewhere else. I wonder
if this is because PHY_INTERFACE_MODE_SGMII is set in
supported_interfaces.

I wonder if you could enable USXGMII? Seems like mvpp2 with comphy
should support it. I'm not sure if the aquantia driver is set up for it.

>                                 1000baseT/Full
>                                 10000baseT/Full
>                                 1000baseKX/Full
>                                 10000baseKX4/Full
>                                 10000baseKR/Full
>                                 2500baseT/Full
>                                 5000baseT/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Full
>                                 10000baseT/Full
>                                 1000baseKX/Full
>                                 10000baseKX4/Full
>                                 10000baseKR/Full
>                                 2500baseT/Full
>                                 5000baseT/Full
>         Advertised pause frame use: Symmetric Receive-only
>         Advertised auto-negotiation: Yes
>         Advertised FEC modes: Not reported
>         Link partner advertised link modes:  100baseT/Half 100baseT/Full
>                                              1000baseT/Half 1000baseT/Full
>                                              10000baseT/Full
>                                              2500baseT/Full
>                                              5000baseT/Full
>         Link partner advertised pause frame use: No
>         Link partner advertised auto-negotiation: Yes
>         Link partner advertised FEC modes: Not reported
>         Speed: 10000Mb/s
>         Duplex: Full
>         Port: Twisted Pair
>         PHYAD: 8
>         Transceiver: external
>         Auto-negotiation: on
>         MDI-X: Unknown
>         Link detected: yes
> # ping 192.168.1.146 -c5
> PING 192.168.1.146 (192.168.1.146): 56 data bytes
> 64 bytes from 192.168.1.146: seq=0 ttl=64 time=0.991 ms
> 64 bytes from 192.168.1.146: seq=1 ttl=64 time=0.267 ms
> 64 bytes from 192.168.1.146: seq=2 ttl=64 time=0.271 ms
> 64 bytes from 192.168.1.146: seq=3 ttl=64 time=0.280 ms
> 64 bytes from 192.168.1.146: seq=4 ttl=64 time=0.271 ms
> 
> --- 192.168.1.146 ping statistics ---
> 5 packets transmitted, 5 packets received, 0% packet loss
> round-trip min/avg/max = 0.267/0.416/0.991 ms
> # # force switch port to 1G
> [  193.343494] mvpp2 f2000000.ethernet eth0: phy link down
> 10gbase-r/Unknown/Unknown/none/off
> [  193.343539] mvpp2 f2000000.ethernet eth0: mac link down
> [  193.344524] mvpp2 f2000000.ethernet eth0: Link is Down
> [  193.351973] aqr107_link_change_notify state=5:nolink an=1 link=0
> duplex=255 speed=-1 26:10gbase-r
> [  197.472489] mvpp2 f2000000.ethernet eth0: phy link up /1Gbps/Full/pause/off

Well, it looks like we have selected PHY_INTERFACE_MODE_NA. Can you send
the value of MDIO_PHYXS_VEND_IF_STATUS (dev 4, reg 0xe812)? Please also
send the global config registers (dev 0x1e, reg 0x0310 through 0x031f)
and the vendor provisioning registers (dev 4, reg 0xc440 through
0xc449).

It's possible that your firmware doesn't support rate adaptation... I'm
not sure what we can do about that.

--Sean

> [  197.472504] mvpp2 f2000000.ethernet eth0: major config
> [  197.472614] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
> mode=phy//1Gbps/Full/pause adv=00000000,00000000,00000000 pause=00
> link=1 an=0
> [  197.479561] aqr107_link_change_notify state=4:running an=1 link=1
> duplex=1 speed=1000 0:
> [  197.484972] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full -
> flow control off
> # ethtool eth0
> Settings for eth0:
>         Supported ports: [ ]
>         Supported link modes:   10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Full
>                                 10000baseT/Full
>                                 1000baseKX/Full
>                                 10000baseKX4/Full
>                                 10000baseKR/Full
>                                 2500baseT/Full
>                                 5000baseT/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Full
>                                 10000baseT/Full
>                                 1000baseKX/Full
>                                 10000baseKX4/Full
>                                 10000baseKR/Full
>                                 2500baseT/Full
>                                 5000baseT/Full
>         Advertised pause frame use: Symmetric Receive-only
>         Advertised auto-negotiation: Yes
>         Advertised FEC modes: Not reported
>         Link partner advertised link modes:  1000baseT/Half 1000baseT/Full
>         Link partner advertised pause frame use: No
>         Link partner advertised auto-negotiation: Yes
>         Link partner advertised FEC modes: Not reported
>         Speed: 1000Mb/s
>         Duplex: Full
>         Port: Twisted Pair
>         PHYAD: 8
>         Transceiver: external
>         Auto-negotiation: on
>         MDI-X: Unknown
>         Link detected: yes
> # ping 192.168.1.146 -c5
> PING 192.168.1.146 (192.168.1.146): 56 data bytes
> 
> --- 192.168.1.146 ping statistics ---
> 5 packets transmitted, 0 packets received, 100% packet loss
> 
> Best Regards,
> 
> Tim
