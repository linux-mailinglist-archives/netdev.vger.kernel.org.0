Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAA0624553
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiKJPPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiKJPPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:15:34 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2048.outbound.protection.outlook.com [40.107.20.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF0CFAE3;
        Thu, 10 Nov 2022 07:15:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqaqZvxIyCKdfSSCYkY1P/TRL7EQprRUNMdAVi11G2o9tuQINn6e7c4vmVx+KyB9Ezz+5DkWiItpWCPp/n1rsCR72a82foek0lvu0ivcwJuTOLFkQ/T6e4SLpipt6cwRWxH1GLbDS3ZQKbNGktBtjvQwMAoX/zfm8rXcfzpIUvutmjV/bNNTgsL3MRD3Td5Fke0Jd1tGyQD2A8s6pAiMNlTj6XIViSievoK4nDoOD5Z1x1JruFn1X/ewplCfLgsm8+nuAXnZ/AF0kht5UrLgVIn8JzBXGUx4S7wy6V1xChVixP3PdwoSXF67dEX2TAEoe7IRtFwsdsdugb2g8UFz/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4GtU4/+ulbCcKi1iU0euJKUvKAzjhgh/E2Ei5iJ8l+8=;
 b=jnD8Cn/a5Ep8b9oQ5d2ruigcCs2LBlTReSivJ5JFD5yrk8eZPwEhnE4GIyUzouE4R2P1Ykl4gBpwFFpRDXh1NRGn7l6O4wdF7fdSHR7ZTQKalYFTfcgqvDMHVQKLRVbItzx4FaB9H9VpOG+PkJ0HlhMOTupwU+d1cPcMMxyuCrKhtANrMdGeiNVrpUGGLWgVMzjTb6fMiYGMvAHHyZ5dIXB0Vnsk310CSDHV6cujVnd/bkfKtZlCh88T3fhCe+j3sURoGWVtnZCtgQd3pCaZFC8ODTTfGqLl2mlwJXFSq2u6v8BwF2bIA7qJ7febkQ+Oka3rPg/F524UV4LK/ZjrAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GtU4/+ulbCcKi1iU0euJKUvKAzjhgh/E2Ei5iJ8l+8=;
 b=NtG1zdAV411/MIINwkytbFbauxEJcrI6LayVk6zhE4vpgPNtJ1SLQE8fcGLiYnx8rcM56gHWVBw2VZTQAfnBW8ZEKJAAzA0GvqIvzdpHo6vvTPvy8B7uHi+W8CD5sbgGX+XNjVohBFvXPdO7JYAAIyTzcXfZgrwgUWhOQQ4qUkdM7taeRU2kcEyKxfkH9SexYWlXWvWpPieGR4OSjm0agwMxGB74k8f3NesEveJWOd3hrdq1cxSeWbzEsUUozfnsKK6wq4BTN2uJrE++OC+MW13juh8LtUssrPY+vilHeyioJR4xmVRr/F+agcWmqbaRqnpyYKGPEISZERQuR3P3eg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAVPR03MB9502.eurprd03.prod.outlook.com (2603:10a6:102:305::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Thu, 10 Nov
 2022 15:15:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 10 Nov 2022
 15:15:31 +0000
Message-ID: <3e562df4-6705-87e6-4327-94288e290425@seco.com>
Date:   Thu, 10 Nov 2022 10:15:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
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
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221109225944.n5pisgdytex5s6yk@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221109225944.n5pisgdytex5s6yk@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0420.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::35) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAVPR03MB9502:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f7981df-280f-4627-8be6-08dac32e6845
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HON3kE5j5OH562gfzvgp26kARdFZL3GODRupzvNW5gYHrdHdXYeU6Zkah9w7/6YpsHC27W9Ckr9lzVz7mVVr67ZIlqpo8Zci/yheIP1E9SR4h/GCaKcSB/ER0vO0rlcbn5z9TKPFPkIWVhcqeWxLn3KF+nvD9PHifvT6mVF4XyLAti/aKfQrZ7uw3TDVS3qSDu4PEApmk4vAZdnUsvOSVgMAnQERUjMFnJ/RHDq3jw/XgTYOmkkMrWRk1CPHsPIoLF8r5D7shJwbZf4lMqqs3MRfR7Opxxl3+v3+uEBANywRWWvzdvM7pVlppS5cxSxhjU4kzFXw/vm0QSvBxoOhn+ev0m9XCoIhzZnpjTZX7+HTAdp7IfWAQiNFxBvNEBpLkJnc5eVEf5cMHR4kCnFn/4RVptHbdJR4BZ9haHIRAOogXgqF2Da/zvT++GhrlvLHENffynCdk1o1OXuo+s+fGAv0VW2D2Umgd41tAqjq3yascLo6UpYMLEQoPKCasn/4h5VzMxHYRIoyNcZsEDC9HTE6kSLYHEaolNz4hfhMpKZBSHrgdD2bx9mEGgvAYEV9vd3lLmxuFNp6oYY74INS/rWgc0XL6a3WvCI20Gcx1h168v1pKH+CA47IJKnr4t2HjZ7kuoNLW1WO85BfdFFvqjOkIAKalBtXXqan/O9ZtGpE2NY8Qqgo4afzEXoA2Mbo2g14S/jGXgrE5GtzrisCddcGHMM8DKZVlrwAV+yQrEZA7oqEB70oBqJYOq7pD/XXZU18cMeBf1N1EOGw1LragSOz8t6NRslxQMuRtHtVEhi14wbOQdDWIjEmDaDQPusHuEGZtrO82y+mQ6Rp+gv6DOdf6bSS2P9WiSIPxBGHtHo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39850400004)(346002)(451199015)(36756003)(38350700002)(31696002)(86362001)(31686004)(7416002)(7406005)(26005)(2906002)(44832011)(53546011)(6506007)(6512007)(2616005)(52116002)(6666004)(186003)(83380400001)(66946007)(38100700002)(8676002)(54906003)(66476007)(478600001)(316002)(4326008)(8936002)(6486002)(41300700001)(966005)(5660300002)(6916009)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1B2K1J0Z2Y2c09KTnI0K1FETkhZV2tNdE9qaTNBTVlZT0tEM1kvMjRpSGE0?=
 =?utf-8?B?SytaeDlTY3ZzbjBZR1NCdlRSQndNZVYzNzNFcXlDMjc4aGVzbU56dGlxekR0?=
 =?utf-8?B?a0JMU1BkdTdOQytoYW15WDh5aS9WdUYrMXNWVEFOK0djeTEva3BvR3RjRVRu?=
 =?utf-8?B?cURiNTBEMXVMSUhUZUM0aGRUYStMMEVVb3RpL1NFYWp2bk1YODJpbkJ3dzZX?=
 =?utf-8?B?YVd1Z0lHVDdTLzV6SVpJTlJ3cXVQd0pwQ2liYnd5R2pOVTlpUm5wSzJjOStM?=
 =?utf-8?B?QkZXcGxCVktpSm5wZ0JDK2dFY2VYTWNZZTg4VDI3MytDeWF3Z1E2Y0xiMTVr?=
 =?utf-8?B?eXRMK1BUbXN3bzkzY3FlMzJoZk4rTittZldpK254NVoxU01qWkFCSGYvK1Jw?=
 =?utf-8?B?bW1pTkVhZWdWVStGMG9XUXB0L3dKNVkwckg2TDFvNjBBVm9EUHcvTWhhZU0x?=
 =?utf-8?B?YzA3eTVMQXdUMTZvOEp4WUhaZTYrdVdjV0dSOS9KS0pRaVh6QUU1U2FDSHQy?=
 =?utf-8?B?Rnk1eitQbTl3QjN3QVVrdGIzY011ZGliQ1hCWGJSOFlrd0pSWXlTQURXb0lS?=
 =?utf-8?B?Yk4zYkxKN3VkeEtURWVOZ3Z4eDJkNGp1SzQwRDZKOGFCd215S2xFNGh1dUl3?=
 =?utf-8?B?UGJBdGExVHJEOEVhQUIyRkQ1OHBkaW03Qmh4Ty9SSHlOZk01QkxqUUM1bjhn?=
 =?utf-8?B?RzRMVzZMcG53Q1c2K2d6cU40ZkdiVU16MXhMOFhMdWduMExsWEtiZDlZREdX?=
 =?utf-8?B?SitiUjhrM2JPek81am4yS1g1MEpPYkE5a1BvSmE5QWVvdnhPeVgzd0toVkNN?=
 =?utf-8?B?aHVRRGNsRytrYTYydHZKemhva3lLSG9CTEJQQ1BBZFd4bU1pM1JIZ0VkVG1U?=
 =?utf-8?B?UUZJeXA1YlovaTBaY0FDOHREKzNORDBCWTVVOWJyak1hMjFpR09IL1FmdUd0?=
 =?utf-8?B?eVkwSGRNUzNCZFR5QTVqZ0ZLM3U1OVljR2YwRThKNGM1Z3RzYTlXcmFrYjNs?=
 =?utf-8?B?VjE1aUpUQW51WEdHQ0tpM2NmWi9SeUl3d0xJblpBR1VBNEM1R0hEai9ZU1pD?=
 =?utf-8?B?SjVNWkgyS1ZuNDdNcytaVmtkVDMzTUpTRjk4bERsNjlLd00yVTcrYUorVWVv?=
 =?utf-8?B?cmZCSGQyL245bjlBcWYzRDNaOTZ3cWhEUjdsVzNQWVE2ZkdzYm1qQlF3dlB4?=
 =?utf-8?B?NmticEJTcGNsdk01RjZIS1kxb1MwbWlSUVhMQXBKWERGTVQ1SGtQVnVITWlu?=
 =?utf-8?B?UUdhWU9ETGNuMlZ0ZjNEOU9zcWw2N3Z5dGZSVjMyd2U0WnFKT2sxMkJYc3Qr?=
 =?utf-8?B?K056S293UzRFRXg0TTlLaUNSVmZFU0RFS2s2SHpkMWFBWnBLdS9XQ2gzSndP?=
 =?utf-8?B?Q0FVbDlOVFZzdkR3WEZaeVZIVlNrUzhDaW5vV0pabEYyT3hxZ21UNW05OWFi?=
 =?utf-8?B?TXBrc2RkVWxDdDlYbmk5Q3pUcms4aFU0aHVlOTE2Vyt3U2MwY1BqbGdDMito?=
 =?utf-8?B?VkJSUzNXSVhlRnRsb1cwQW40UFZXdEFPcFFxQ3pTS2ZOMXpFRmlMbDY1WjVS?=
 =?utf-8?B?MDJ4UDZZMVJ4T2tYb0lQUEQrSlczTEpqai82cHZKT3p4TVNRVFg5ZURFcGgx?=
 =?utf-8?B?MVNqS1h4QkNFVy9FdllQYTJ2NlAycCtWamwrelpYUzNPeEMvQUh5cDc1RWZX?=
 =?utf-8?B?aE9rL1VuNmRtbk9CMi9iSWdPSjVWcmlTYVhGNW9wdktpMlBFNnl3OGxKNU5Q?=
 =?utf-8?B?QWdYalJFZ3pJYldwVVNpejdrRXROd1UzWU82NVI2NGpFVHdGdG5IdGhRSEpt?=
 =?utf-8?B?RzBiWXdoQTVCTldycldIZXkvQWwwR0Q2dnVEeE1LVHdUNEg3bFIzaUlvZkFV?=
 =?utf-8?B?RURKT2lVNFpMUlI5eTk3aWxESmRLUXE1c1BZZnRjS3Z5cnVSOU9uMFhGYm53?=
 =?utf-8?B?eEN4RlVEUmpyOVZydjZucmYzYjBBaGhnOE56cURlN3pLYkdydGdJU0tFMktt?=
 =?utf-8?B?eWl6NmVxak54eFIzRVJwUmpzckFGVmtDRS9FL3lxMEVULzlyVmF0Y3RYc2Fj?=
 =?utf-8?B?c0Nlb0dYTkdadkQwTEFySVFxZWlPMEV1UlNEU0oycGQ3ZE56SnlONFFWQVpv?=
 =?utf-8?B?SHlERHF4dGxRQTR1YTZpWnFLREdjQ1lvMUhJcFRnUU51ZGl5VFpWTTREMFRs?=
 =?utf-8?B?U2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f7981df-280f-4627-8be6-08dac32e6845
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 15:15:31.3677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vfYv98NUY/ETO4hNghNNJDUbYj3WXUkKL6VsSDUrc70WDMZeiVYGyq38iy0EQf5CHZMmKiiqDfWsf6f9pzsPfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB9502
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/22 17:59, Vladimir Oltean wrote:
> On Thu, Nov 03, 2022 at 05:06:39PM -0400, Sean Anderson wrote:
>> For a long time, PCSs have been tightly coupled with their MACs. For
>> this reason, the MAC creates the "phy" or mdio device, and then passes
>> it to the PCS to initialize. This has a few disadvantages:
>> 
>> - Each MAC must re-implement the same steps to look up/create a PCS
>> - The PCS cannot use functions tied to device lifetime, such as devm_*.
>> - Generally, the PCS does not have easy access to its device tree node
> 
> Is there a clear need to solve these disadvantages? There comes extra
> runtime complexity with the PCS-as-device scheme.

IMO this is actually simpler for driver implementers and consumers. You
can see this by looking at the diffstats for each of the patches. All of
the consumers are -30 or so. The driver is +30, but that's around the
length of lynx_pcs_create_on_bus (and of course the compatible strings
and driver).

> (plus the extra
> complexity needed to address the DT backwards compatibility problems
> it causes; not addressed here).

New drivers will not need to do this backwards-compatibility dance. They
can be written like almost every other driver in the kernel. There are
parallels here with how phy devices were implemented; first as a library
without drivers (or devices), and gradually converting to devices.

This is also motivated by Xilinx platforms where the PCS can be
implemented on an FPGA. Hard-coding the PCS for the MAC is not
desirable, since the device can change when the bitstream is changed.
Additionally, the devices may need to configure e.g. resets or clocks.

I plan to post a follow-up patch for [1] adding a Xilinx PCS/PMA driver
at some point.

--Sean

[1] https://lore.kernel.org/netdev/20211004191527.1610759-1-sean.anderson@seco.com/
