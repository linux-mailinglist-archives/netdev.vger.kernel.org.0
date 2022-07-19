Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C68957A302
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbiGSP2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiGSP2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:28:54 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2048.outbound.protection.outlook.com [40.107.21.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3A756BB1;
        Tue, 19 Jul 2022 08:28:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+dcR7rWWszFAoMdKAwG0avB3gxKcCpuEQoNq4NqpGiIdx0Ck215qEdb/KahCkXJwGhhzZA84Lvml/MwouGPcBqXSrRj5/eVD49o1ClIFgeMUsqu/6k//a2urPISYu5hOiY5LBoGr2+z1GKHlUPZ2FO/CDvj9iae7Ve0o8LDguYVPBpLNzSZs1EjblpyRtrCjbt98QbtbYcobdQkfFPR5h9IYDC+ynfNsHqx0u+Qe9HR72t5vntFKrq0Qec4k/9e3ORpneAAbAAuArqpG8S4NXtJSb9fSmFYNCpAm617c5BdJdTY8PChjnCzbWoTwpn/vU7Es1wJmNScii04KRR84g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5J2/JeInSoO16BTWYute604VeM0gBjpxNRmXKw/1AmQ=;
 b=ktPflGKIl2FY8hpioH+yF03eAdG2kKCF0bAVhyRfx7O6ksct//1SSLaAJA7d8rFJ0bR0Bsc2mAZlcsKkAKyrvtP/rt1gXuMoi0AIvhUfp9pob8PFsaHZ3lzcpt4Y0VDnT+sau6JM+g1e57JQOQIyEbtW6w64X+1Vtqkl74U4HCuhwVfRBCr6K3rp3OCysQ/6cSXmWRwlWS8G3PGokFCzmzvcvfEmd35FWcg7YAnBpDubImg0c4sZf7LfzTXiicPzIDnxXaxwTp9yyyHHJ8fpmREbBObgG179/3IioqE8R2rH9rOQFj4eGdSOqwJmJ71gzO6DhAPVzOcjaoZshZA5Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5J2/JeInSoO16BTWYute604VeM0gBjpxNRmXKw/1AmQ=;
 b=w9OkyFYbbfNkik0qm7hbuhtuRn5YZDyZkPQUd2PL0SMc+2n5ibp3MDX3wpFBGmJrf5VzqWBMa5wrfOlbgqQMuoU44+s1QkRBekJvUYULGMA5bVKsTpwkMF5jOz7A7wQE0Um1dnM8D2kT7sWhEk+exdzczbyu2ZL0N3ouU/uwaTXjsJRccOpQHT3CzSzLA5M79g/l/xZSo7Ti/IWvDE8b/P3pB/Aer8rml5nYJCHIUcZM7h4z3sU7ubfR0akFFn69flWW85vmYjUtc8ImnXDKtCGe/7ko3/DpeqdsjaOx7D2pFYW3pP/0ADUDhASfgLbT/lGkV8pEy5Q2r3xh2egqlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB2909.eurprd03.prod.outlook.com (2603:10a6:802:39::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 15:28:49 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 15:28:48 +0000
Subject: Re: [RFC PATCH net-next 0/9] net: pcs: Add support for devices probed
 in the "usual" manner
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
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220719152539.i43kdp7nolbp2vnp@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <bec4c9c3-e51b-5623-3cae-6df1a8ce898f@seco.com>
Date:   Tue, 19 Jul 2022 11:28:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220719152539.i43kdp7nolbp2vnp@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:208:239::14) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc0675be-7d13-4525-75c0-08da699b6084
X-MS-TrafficTypeDiagnostic: VI1PR03MB2909:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iATbABQ9c5yX6TDxjPnTcXaBog1Jhr0mCwRxfm5d8FAhkZVEKcRVgyWw+/YnrofF98JEQk6Bs17R9cRmFBmcYsQP+qJDXujzWW3yXnPPt5KIom4VCvG06kIb/arcLYYbSgQyz+cEhPWdiR0ASXgN2wdpvnEKHMSpzmZMMLs1k7wjtd6XOcwb0Z6NyWYzfxJ5Ie9l3HSKRdQrrWKErbt9A13Ke2Eh0MxYrtP1hWFZB8HiJtqKjT67WYALtcJBxEtiniaYmeQ2GbuSAsJscA6iGNFyZgmH8xDc+rm1k8hEuhut6FAg+azXm1qPfshpWl0uK36PUZXUPqMtuO3YY8sci2htbRbkqSLDGFDVttoLu0lIm4We4oRVjk4k4E2vK15Ao4vH1TiAPCH46bxVWuQw8ihUA67cxfs5HdAB3vNWAR3hiLxFMVsanI213u1MU24uNTJUOljPk+GHoQ30pKToHy/PK4GQWTRDyJEbbZQu4cz7t15EAB02TgdZKpd8GZ/TfNPWaXfq5dG6z+Gik36EQ1/rB1TKy4Bb9jyq5kVZQBGLHIDInyftXovdrOzdFsFWk/yjuA+pjtx8XJAk6rBc5zqPRWKEPvSc+BZSAmBTXji62jPtADFcEEhwtSZprGGVW8Cw1a4KCf3b9yBPOWLs7lMO2MsEQmm5ysXqkSpkiVEtJhnyAwpk7zxvk0Xl8j/qK+IQ6uZONJqncdR70AL2yRBbkMOPjEfv9HgEvmRLZXylj5/hnxuwS1oHmGTNgZsQDz5kbQUs8TjBI41/lMnZ7lPpqk4fkXyAHZrHAhxzbT38Wc0eqVeuXQ322/Z6FT1gswjEVFZJXp4st1B3f1DYXEtT0kyidP6Nccjh7AyBwOU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(376002)(396003)(346002)(39850400004)(2616005)(5660300002)(86362001)(53546011)(6506007)(2906002)(6486002)(83380400001)(52116002)(31696002)(8936002)(6512007)(26005)(7416002)(41300700001)(44832011)(478600001)(7406005)(4326008)(6666004)(186003)(31686004)(66476007)(36756003)(38100700002)(38350700002)(66556008)(66946007)(8676002)(6916009)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmIvWVlpTUF2NUt0RTVLNjM3UmdWZFJIb2Z3L0NVN0sxWHVrQjdPTUo0SEVZ?=
 =?utf-8?B?eTFHbWxiSk01MjFvNGtWYXV3V2V6cERIU215MDNScVNJTXd3TUM1YndEeTZC?=
 =?utf-8?B?M0VOWHFnSFlMT0hZQVdEYWR1VGNCamU4cE5pTlQyUnVGRVVLZllxZmlFbHpQ?=
 =?utf-8?B?YkxOQ0FkUlV2c1FkYkEyWFNrVUdHNFlCcU1PaHc4ZFJBU0xjWW9uZ0JEcjlv?=
 =?utf-8?B?SW5sQWhMQ013Z2hqVXErbmZ4UFR2UlNJcVU2RXc3ajdYcnE5ekpyc1piVDFV?=
 =?utf-8?B?T05UVW5Cd0l2TlVaVUR2b1hSeUxDV215QlJiNTl6Mmk5elpZMjd0WHZxMDEw?=
 =?utf-8?B?Q280cjVDY3Y0TVZhVmp6Y3lpMWcwUW5pOC9GdjZqRElMalNwbWVJcGlkRUxp?=
 =?utf-8?B?OUZPTGE3WkVhU1Q3ZktySmFXQjk2eHZ6aXlvRFl2UmtQMUR6S0I3b1FTNjFN?=
 =?utf-8?B?bVlEMVNLSll6SktJM3BQR2FaNEVLVkNTSjdIckg5MHpETkZ4QTNITzd3aThj?=
 =?utf-8?B?ZjlmVkdYUTVvK3BjUVFSN3dyMWVrSVZHSGhJQnArU3dwU0FLTW5nVDhFeHdq?=
 =?utf-8?B?NHc1WWpvT1VpVUEveDA4MldOL0xIcEVqRURrdTNSUXpKNnluM0RrQVJNQzRF?=
 =?utf-8?B?SWE4UTcwZWNNSUM2ZmVGMDdDYmVKYWJJOHM3dkhoRm15ZWdGVVRjR1dRdzRy?=
 =?utf-8?B?YjJlbEgyNVpZZ01ZQ043cHJ2RTRsYVZ5RVlmcG42bmFUbjA0aUpwNkpKbmRQ?=
 =?utf-8?B?QU01T1VCZUZneXdIM3p4aDAwRXNVb0g2emc2eDNyL0RzRksxNXdOV05lSVEw?=
 =?utf-8?B?MnRKY3hzYXdGV1lwQkgzZDZ6aTVHRFJiNm1TSWdFeXNaaUNrNXNlTVBvK1Ix?=
 =?utf-8?B?bzVZTVJ0YncrUXI1MXk0V2UycDllUjRNUFdTcG9GRURlMzdqa1lndEtxYTU1?=
 =?utf-8?B?M1o0alRQOEU0c0NRNkF1U3FCMHNIOFhJSWQ3UlpBNW8yVlBtcVBUVG9qeEpY?=
 =?utf-8?B?aThuRVdLalgwOWlhaGNham1adUx4eEVVMFpSS0tGT2I0K09GTDlYTVZZVHhU?=
 =?utf-8?B?dWVyTi80ZzRQMUtQeUt3VitWY09GcjFGV3F5MHdSUHNyQ0lJVXJvUHFJc3Ax?=
 =?utf-8?B?cG1IL0ZLd0ptTUtwYUtnTlJjODFjYXB1UFVLZ3FFL3FTaFhYemhlOE9EZGJ2?=
 =?utf-8?B?WkdUTVZCUHJGWXMrNGVzWFhEV293dWxUTWI0YWVjQjBKaDhHZ0FWTEtKcERZ?=
 =?utf-8?B?RTB2d3BxM3NnYk1DZ0lpaGhGS2YwOEtQc0VhakU3UjRZaTJYUGxaY1Z2S0k3?=
 =?utf-8?B?ZDhZeENBL2dLMjlkY0JJSVExVHlxaUlGOHhvVVlxa014UnV0amR0b1UrWENl?=
 =?utf-8?B?bWIvdFZyKy9ldDVUelcyUzRyb2hRNWZsWDl2d0FFRDJ4bkxZL01NaThSeEJM?=
 =?utf-8?B?eHAxZjNaVWZqMmJTbjNpS3N3Y1BpNldmUlpuMFZYcWJxa2tRcXdTdVg5UXJa?=
 =?utf-8?B?dkVOa0l0NmlHOFdoUWdMTmNQOEtTT2lmQVhLaTRpbU0zODZkRVZNM1FTcm80?=
 =?utf-8?B?MTBtVUhkWlJDeGVOd1VsbnFza0NFb01wVitjVTNXNHZXcDdVeFB0Rkc3ald5?=
 =?utf-8?B?WTdDNDJEcmxqRlNoWnltemN3NnRja1ZUR3VCOGVGVmhtQlE2TWV5UmxsdHFr?=
 =?utf-8?B?aUYyM2pUbDhxeFFkdi8zaWN4SWRrRWJYL0RKUUtXMGxJeGJXNHFlTElsWkJk?=
 =?utf-8?B?WjUxNGI1U0FKNVlHODd3YTFFS2hYOTVIeS81S09qZHdkVXplZEtrcWhtbU9q?=
 =?utf-8?B?eGJlYUE4cHpnWUFCSUlJL3dCekw2MWh1QmJCUmFrck1RMk90VTJ3NkRyT2M5?=
 =?utf-8?B?ZlhRNHdZNm0rYytHUzVvWWFuUUxYWUpENjlYWkpuQ3EzZDMzTHdpaE1jbDFV?=
 =?utf-8?B?UGZZUmM1YjhLV0dTQTF2blJKSUFHVzlyUzUwM2lWWHpFdFV6clptNnVNS3c4?=
 =?utf-8?B?MG5mYkZTZnJrd3pDUjZZamVUaGE1RitrVk1ORVJnY0xhTmJGNk8xVm5kQWFm?=
 =?utf-8?B?S3hVeHpnRDgrSmlBYmozeUdkbnNQY0szcldrbXlVWWNmalR3cnpxTlorRHB6?=
 =?utf-8?B?YkRGamJqUktPaXl4VkpGQWpIUVhSZU9RK0d4d1FBOHJKWjd0ZkdSRHhnTVl1?=
 =?utf-8?B?Q3c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc0675be-7d13-4525-75c0-08da699b6084
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 15:28:48.8206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hQFQTD48rVntuei5qICQw7iNrrO6aM59YKMk4LaNhrL4ZDNgPdnd8ZwhTgMHcyMQcZtBzzLuFPiY8P6pH4sUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB2909
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 7/19/22 11:25 AM, Vladimir Oltean wrote:
> Hi Sean,
> 
> On Mon, Jul 11, 2022 at 12:05:10PM -0400, Sean Anderson wrote:
>> For a long time, PCSs have been tightly coupled with their MACs. For
>> this reason, the MAC creates the "phy" or mdio device, and then passes
>> it to the PCS to initialize. This has a few disadvantages:
>> 
>> - Each MAC must re-implement the same steps to look up/create a PCS
>> - The PCS cannot use functions tied to device lifetime, such as devm_*.
>> - Generally, the PCS does not have easy access to its device tree node
>> 
>> I'm not sure if these are terribly large disadvantages. In fact, I'm not
>> sure if this series provides any benefit which could not be achieved
>> with judicious use of helper functions. In any case, here it is.
>> 
>> NB: Several (later) patches in this series should not be applied. See
>> the notes in each commit for details on when they can be applied.
> 
> Sorry to burst your bubble, but the networking drivers on NXP LS1028A
> (device tree at arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi, drivers
> at drivers/net/ethernet/freescale/enetc/ and drivers/net/dsa/ocelot/)
> do not use the Lynx PCS through a pcs-handle, because the Lynx PCS in
> fact has no backing OF node there, nor do the internal MDIO buses of the
> ENETC and of the switch.
> 
> It seems that I need to point this out explicitly: you need to provide
> at least a working migration path to your PCS driver model. Currently
> there isn't one, and as a result, networking is broken on the LS1028A
> with this patch set.
> 

Please refer to patches 4, 5, and 6.

--Sean
