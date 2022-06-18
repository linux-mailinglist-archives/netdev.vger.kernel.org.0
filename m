Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD2C5505EF
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 17:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbiFRPzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 11:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRPzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 11:55:46 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1729FFC;
        Sat, 18 Jun 2022 08:55:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6Va4njxdpEYTDBPuP0lv9WpSJeqXLogyhe3O7YmmZCVJ5XCG9uBSP8A4ogbRN0lL8fing04YCN2Yn0dwOnqyVEn53CO3Nbm9Ecw0LrPVAPPcOIsdp+0K+kTiSGBTkhG66cudvr2bS1RF1R35udhgTbO+A5NVxEnUKqGxnz/DLoZ26VcBA13oTe32sF1yBLNC9O5y85DnUIJvyQIVJ7B+bgOEx7/27MOHy63ju3n2nc3cdNZY6DwnZNobDC5L8mL9jazP/ubB9w11QtjPDIVxsnh09EmDfGmIwD9iZC6/8idOHKb0XZ+hdy4kJOLriD2QSQJ9Xdn77V+V/tEU2k9/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdJMAfg7LM3tfWFrXy7ZeSr66wh7qTUIc73+ayuQQHc=;
 b=c4Q8LTdqqNoFmBmq+dPHOxiAiBJp5SXJDRGuqbCjnLYgBl7gONtlV62nhN+y2e7094zaiX8hSb+lghNeLRV3ASIGfprdl+w8DeNHV4y4fiIxIM+D+VU2zLFGTua9JKi08CQfQZa6BqQGMNpgVW10Mqvb7IegSACDQkHGNPO+TCqaAUuUFLz7c4+RaU1btVIPMhamLiwFT05A+tfJN8l1J5HAjsqMaMZ5DDIZP0L3s8mTGZ04Bnr5NjuONBOTX7gNFqeWr/wuLWHsNtSNeDmPrf8ZLzPLrNan9ujCFbfFKe67zf6sxmgrdomBUhhDWqaCJV69hmTQT+vqNfTE6EHxjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdJMAfg7LM3tfWFrXy7ZeSr66wh7qTUIc73+ayuQQHc=;
 b=ZhKEKX6qZA05VW3mOv80ZCzqYvUL8Qqd36bfogpuGy0fNWAMwcyIwqIaMG5FZLYIieanupuPqBCuMblu6kWTX2eAnMBrIqqHvXxDNtniKI1IGVUkqE0cYtdw+u4VmiibRR6haxEy/mVtQxD5ohQx0ZgXWcVVpMNPKZU/sIGncaqPxvCcbsYOrduWvPLgpqBB8e8o62ZGzgfVbJi7+jXd99QB8LpUMyz6BnlScqRSTW1o7wofv4CsFAzan7rfeAbxw8+O3LCpKFe9mGynBKwrhF+a3WHKPsc//YiMpGCl6E6PdsFok/UDgDdWt4RnUkLs/P0Jd4tpMQVDXJWsFTvSIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4601.eurprd03.prod.outlook.com (2603:10a6:10:16::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Sat, 18 Jun
 2022 15:55:42 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5353.018; Sat, 18 Jun 2022
 15:55:42 +0000
Subject: Re: [PATCH net-next 02/28] dt-bindings: net: fman: Add additional
 interface properties
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-3-sean.anderson@seco.com>
 <d483da73-c5a1-2474-4992-f7ce9947d5ba@linaro.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <4b305b67-7bc1-d188-23b8-6e5c7e81813b@seco.com>
Date:   Sat, 18 Jun 2022 11:55:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <d483da73-c5a1-2474-4992-f7ce9947d5ba@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:208:d4::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1f80fd6-c1a4-42c6-11ac-08da5142ff5c
X-MS-TrafficTypeDiagnostic: DB7PR03MB4601:EE_
X-Microsoft-Antispam-PRVS: <DB7PR03MB46014C5A7061F95CE86124E596AE9@DB7PR03MB4601.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YXXyS1pjrT3WTeCG2EYF6T0ZZnSA/OaZM/D31sKdQjDAStBB7X74+BdpCTKrNRXlyikjXlSolbC0fRYF+5Peb0td66QGQP4r6ChTOyCa838KDFQ0ht6U4UcsBy5utUl3X2UMwhj3F02fhUCgrQjnYdejdGew3AONIA/rhuzfZEalCOmj5gqTzI46fcMSyDdYZfl/fRP2KUU4qYn6zsR0AkhC+P2j/yHFP74JBgf3+KjpGlPDVJPU9zC8y1eTjUc8CJksNe44OOlotdCj91Tqudq9oHy4INvNEYJDNO0M1C1gIKlx+Jwsw+A4ji8R+O64KynX0MgWEsv0hfX7LI45EWW9c2oztEfFNUD4354uUnEiLboXtd6GQmuqexv/Uf+KEvuRe0nSyXKz+LEV0Rci4n1s53HubjW0FVe5LS/KXVhK8+qzLreZVa2cfnU5Kb6NME8TOcLrbJmJBvmcW82cFN0C4X8lWCCzx/fIwQ6zQM6caR7ILf1zc1SVv5D8wLnT22IMcNekbWwePQAX6oxpR5ZAI4uoVR2z7rqjCbSri1NFWCyCyykfl3OyApC8HxuvGO5/sji8um1OXt6BdjoFuz0SHqGM4Y/LXrHzvQVOSIWvcIYdt8Wg0xMWnfvsX/AbwRFX9QnicYCJ+ahHYV3SdNm51knsltpD/Zg13d7p6X7RwD2l3ndCNUcjTB6FvwseGrCQ7FzKEdFGYXqp5WpQAI6mbxrvD2UX3XdbOURxMmI5cGts+QISfGnWbbOrhTbz273bFpsMtrpUe9EONF6z3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6512007)(26005)(66556008)(4326008)(316002)(31696002)(110136005)(53546011)(66476007)(52116002)(86362001)(2906002)(6666004)(6506007)(66946007)(54906003)(8676002)(8936002)(36756003)(31686004)(7416002)(38350700002)(5660300002)(38100700002)(6486002)(44832011)(2616005)(83380400001)(186003)(498600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SG83MWNzMGFBUFB2YkZ3Zit1eWFsekhYTTdpbW1vTDhhSUpoaktzQ2hNRmJq?=
 =?utf-8?B?MFloTDFBd0JpVHVEU3dUYm5FZER4WE9lOHljSkRYZnMwTVlPekg4S1VUWmgv?=
 =?utf-8?B?Qk04NnA3WHQ2RlhtWXN3TzhheVYwMXhLcFdwRTJNUHJOeUNQbkp1T0pLcE9U?=
 =?utf-8?B?RWM0R2MzYkNVdWxnVlE5QmM1djA3Q0F2RXFZWnBlUm5URkpSTklsaFJnNEIv?=
 =?utf-8?B?S1BSRzBSSjZSdzRyeXhJL2p2N2lUakw0bmVRNytzSGFqVHU4SjlVaHoycmdz?=
 =?utf-8?B?bnd6alk0TFgreVJtcVBMRE5lYTFZWnpiVHp3T01FRmJjTmwzWno4VHYvM0Zo?=
 =?utf-8?B?U3JNVGFMU0paQkdQd3QvZDFjRnJYcjFDNHN6VE5LdkJENHA4SEhzZlVXTzc4?=
 =?utf-8?B?eFJHc3RraWtsR3hkazBPNk11V3ppMmZZSndFS2Z6RXBqV0lnS1hteXUwT1p4?=
 =?utf-8?B?WDZsWGpMdkJzSzFhR0dEcklUK3gxUzMxUDFjQnJVaEk3U1h3UktQU290VG9t?=
 =?utf-8?B?RDd3MjE4WFhnRWtLdnVZUjVTcjdDM0tSMktBeHd1UlpYM1VGS2hDSEJOd3V2?=
 =?utf-8?B?UXIvSnZmYi9EWklsMXp1ZkR3Umo4Wlk0bDZUN21YR1R3Ykt2YWwwR1RheFV3?=
 =?utf-8?B?RjRHZldkYk4xcjZEdTNVcDVXdTQ2REIvNG5lMlArQXFvUTAyTnFlZWZMRFNR?=
 =?utf-8?B?R1VHYjVJS2U4OFBZSVdwL1lwQmE1K3pOWWFnR3lma1pWRGgxSjBhOU9NaTl0?=
 =?utf-8?B?VXpIN1c0SUtNNEFXNnJMYTNub1d2YnBzbGc4aFYxdllLN3VVZVJFSlpxWEJF?=
 =?utf-8?B?K1NNb2FIYWNHVUYxWUNHZU15dzc1N2dGdjB2dEU2eElsSDhEQXM1R0ZTL2VQ?=
 =?utf-8?B?QWVSMWkrZyt6LzRNZVlQdUxjYXdFeWZMRWNkUWtOeExycnFPTFJKR0hLVURS?=
 =?utf-8?B?QmRDOXYzTnNzMUY2QnYvV0ZMZkN0SFRGMnZGMnRXN1hQTW4rMUtXdEdwVFhY?=
 =?utf-8?B?MG5sTzA4bEFuTFdYay85TE05VGk5c2w0SzM2Ulh2Z2t0UVl4VVlhV3p0RHBO?=
 =?utf-8?B?NmhXMFNRQUNwY0I4alBUN20vcGE3d0c0SXFlNUFsKzBTQU1uWnZiSUtjUzdG?=
 =?utf-8?B?d2ZNdERiWHNkMFNXVEJKMDJuRTREN2g0VXFMdkV4b1NkQXlFZGpib0RxYXNp?=
 =?utf-8?B?bWZ5alBpZGt3RkZkc1k0Z09JZXNBY2x0cXVrK1Q2MzlFOVdnUktFenJpZ2xE?=
 =?utf-8?B?U25VZW93MzlwZmZxTndBTEhhV3ArWXdXb2dJNXoyY3MreitvTEdHSGpicFgw?=
 =?utf-8?B?K3R4OUQ5Qlc1clNIWUtGT212Yjh4MWp5OW9uc0Jrdm1sVXErRFJnVEplUzJp?=
 =?utf-8?B?blQwRFlIV2k5QWh6N24xeE5qTUNQcS9LRGZvbTZJeUtqaUd1TFZRQ0xHbTB6?=
 =?utf-8?B?TFkvTkl4TnE4UFhQOVNhQk9sV20zVnZIN0hncXdsais1Nk5BSDlHYTlnYkFH?=
 =?utf-8?B?L1NzVkY3OVArSDRwSGNuR3FGYkRZRjB4bWlvalFqaDNFdEhNM3V4Tnp1NXBK?=
 =?utf-8?B?Qm4wMExiNlBKaUhFbFVKM0dTSXZXZ2xqVVdRZnphMU15RFcvd2FXSjZsclly?=
 =?utf-8?B?eVMreGQyTy9GRmcvbEk4VHNyVEZtalYvV0Q0ekNXeVF2SElPMW90UEVXc0JD?=
 =?utf-8?B?ck4xUkJ3dzErV3RJYk9pRWpZME9vbjMwU3dYcVhndEZoS3J4RDBKM1BQUUU2?=
 =?utf-8?B?OTV2UVpTcElIeUFIZHV1a0RDZDBDbDYwOWVyczlYYmFMNmR1NmphaW1rTFk2?=
 =?utf-8?B?WGpwS2RLVnJzOHV1V1hkcktyY1lSWVZEVzY3VitYdDZXL3pXMDRjek9hMWcr?=
 =?utf-8?B?aDNieXlKTXZNdEFyZ0JhUXJNN0VqSDlIa2hybzNQL2lDMFAydVp6b29wY2kx?=
 =?utf-8?B?VmZFcjJENEFkbEgxdGQ0VFl6Y3dkWEVsSFJ5L2tXM21LWGYvSlRsUXBSclpn?=
 =?utf-8?B?ZmR4Zkl1MzNwMTVJcG5oUVFJQWp1dWVaQVFpVTM0NE0rOGM0cWRjdFRvaUJw?=
 =?utf-8?B?TllZN1N4dkpnSTZITGluQ0pLYW9PaXlNcUxWbUxyYlFIaXpsWmJvLzZHQkox?=
 =?utf-8?B?YmNRbkRQOG5xQURycHJ1ZHNVUXFYRVhQNEFSLzBkdXB5b0JsSC9Qb3pESEpH?=
 =?utf-8?B?a2ZPZDhkQUNMa0ViN1VobVNGWm5IYVNiZ1N0SmFocTZ2UjlnOFpVTkhTams2?=
 =?utf-8?B?cVc5cnZTUkhBbkp5WmpFK1JuaVZiQjZUY01iUkhlbzcxYXV5dXBJSWZFL0Er?=
 =?utf-8?B?OGV4bWJCN0xxeEVUMVRZNE5OcmFXSm1EUWViRWpnNkZQMExWQ1NFZ0VkaUZP?=
 =?utf-8?Q?NfHP+JQswk3SH0oU=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f80fd6-c1a4-42c6-11ac-08da5142ff5c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 15:55:42.1667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Je/O0crfQhMUo168Ho1YkYjqFlKDtWyGKDDpzErp48qtvfXuvWE9WnYlNu9310YAw9m74GwINNVZ2TxWTzisTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4601
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On 6/17/22 9:16 PM, Krzysztof Kozlowski wrote:
> On 17/06/2022 13:32, Sean Anderson wrote:
>> At the moment, MEMACs are configured almost completely based on the
>> phy-connection-type. That is, if the phy interface is RGMII, it assumed
>> that RGMII is supported. For some interfaces, it is assumed that the
>> RCW/bootloader has set up the SerDes properly. The actual link state is
>> never reported.
>>
>> To address these shortcomings, the driver will need additional
>> information. First, it needs to know how to access the PCS/PMAs (in
>> order to configure them and get the link status). The SGMII PCS/PMA is
>> the only currently-described PCS/PMA. Add the XFI and QSGMII PCS/PMAs as
>> well. The XFI (and 1GBase-KR) PCS/PMA is a c45 "phy" which sits on the
>> same MDIO bus as SGMII PCS/PMA. By default they will have conflicting
>> addresses, but they are also not enabled at the same time by default.
>> Therefore, we can let the default address for the XFI PCS/PMA be the
>> same as for SGMII. This will allow for backwards-compatibility.
>>
>> QSGMII, however, cannot work with the current binding. This is because
>> the QSGMII PCS/PMAs are only present on one MAC's MDIO bus. At the
>> moment this is worked around by having every MAC write to the PCS/PMA
>> addresses (without checking if they are present). This only works if
>> each MAC has the same configuration, and only if we don't need to know
>> the status. Because the QSGMII PCS/PMA will typically be located on a
>> different MDIO bus than the MAC's SGMII PCS/PMA, there is no fallback
>> for the QSGMII PCS/PMA.
>>
>> MEMACs (across all SoCs) support the following protocols:
>>
>> - MII
>> - RGMII
>> - SGMII, 1000Base-X, and 1000Base-KX
>> - 2500Base-X (aka 2.5G SGMII)
>> - QSGMII
>> - 10GBase-R (aka XFI) and 10GBase-KR
>> - XAUI and HiGig
>>
>> Each line documents a set of orthogonal protocols (e.g. XAUI is
>> supported if and only if HiGig is supported). Additionally,
>>
>> - XAUI implies support for 10GBase-R
>> - 10GBase-R is supported if and only if RGMII is not supported
>> - 2500Base-X implies support for 1000Base-X
>> - MII implies support for RGMII
>>
>> To switch between different protocols, we must reconfigure the SerDes.
>> This is done by using the standard phys property. We can also use it to
>> validate whether different protocols are supported (e.g. using
>> phy_validate). This will work for serial protocols, but not RGMII or
>> MII. Additionally, we still need to be compatible when there is no
>> SerDes.
>>
>> While we can detect 10G support by examining the port speed (as set by
>> fsl,fman-10g-port), we cannot determine support for any of the other
>> protocols based on the existing binding. In fact, the binding works
>> against us in some respects, because pcsphy-handle is required even if
>> there is no possible PCS/PMA for that MAC. To allow for backwards-
>> compatibility, we use a boolean-style property for RGMII (instead of
>> presence/absence-style). When the property for RGMII is missing, we will
>> assume that it is supported. The exception is MII, since no existing
>> device trees use it (as far as I could tell).
>>
>> Unfortunately, QSGMII support will be broken for old device trees. There
>> is nothing we can do about this because of the PCS/PMA situation (as
>> described above).
>>
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> Thanks for the patch but you add too many new properties. The file
> should be converted to YAML/DT schema first.

Perhaps. However, conversion to yaml is a non-trivial task, especially for
a complicated binding such as this one. I am more than happy to rework this
patch to be based on a yaml conversion, but I do not have the bandwidth to
do so myself.

If you have any comments on the binding changes themselves, that would be
much appreciated.

--Sean
