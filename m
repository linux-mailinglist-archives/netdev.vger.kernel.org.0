Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F346A62461C
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiKJPjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiKJPjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:39:42 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2069.outbound.protection.outlook.com [40.107.104.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68EA5F79;
        Thu, 10 Nov 2022 07:39:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkSE84z+qW32pLW8gkc07wZaMRSVDCxpbRWBvJwtpuKyoWTpwlRuAfOOnOkYC8P9illhcWuzEF/2nihPis16B4txuJATPt+EeBwB2LGqPDxyX0ptyW24s1ttIC0Jij4n8Or514fj2SUAK3L3sINvto2CLEh2CJsGNjtuMzybcDVInbTziBp3ll832pDJPJ2zlixAqEDvk2zlErEkUS5Xfpp8/mW5Kgf1bDPaQMq6lc1Tiuvt6Mud7uLoyfVzL/JTD4RVAIddKitrJ06E2AsbopY1naS3PlhYDd4RsTUnRyItnL9G+Q3ceUDiBUCmxCpJR9NRMPMqdg0MjTJilaY43Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9prCzJrLcwbEv44QAmsx2VRfAfVlNOt6Oh+zxo9XsA=;
 b=lyIeCBuIiIj61AZIYjKWLrGK2SvD7SWr0XTi7te5adXXEAHfU7k4CIKq4SE+PlGbp90G2uY8OwcV3ne9naiNlPT1mgPi1Ivqo3JDeodC1fTJikzKgXudvb7aBckvDHPvbPM4UhK6N/T0S7Ii2J9WRrLJw/EbluzItDMI7vKQYqLFWpA8wRtqpYZtChEt24gtiQtkLplBc9tbIkgp+RfBAyMGfq4sOOFOAgvIILh2cpZ/Jye2cigBGI+Fzgu1+AhOYiua83hAe6yDpY8D46gSvghB7fTY9hE04BGLEPCcYWTGNuhEHXGYoosdwkM6hSLfp7474b1nqcnfCNMLnq+I/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9prCzJrLcwbEv44QAmsx2VRfAfVlNOt6Oh+zxo9XsA=;
 b=xzmWxd878KvI0sr9b7mkLdKJMWbdhLFmzQDwkoXYgijolbo6utWR94aOiP6++++KLhO/mYhcVgXVqusba/ucUXbuNWVA7+1itpwJ+jwuq2yCSD7sDlsfZg5RntR9YsuNLiAZ19efEFX+ODGnKpP7H6R0exeAjZsg/eNwgp87tQ8Q4PBpyeoLi3lEtsp4SfJbVsBPUfJ1I6zszMAe4fFdg0kyydgdrrQMgg89K11TJaGw8/q4ztj5Q6ZyQsjrwA2zHUUxAhVUOgCezHvIIFgwjW9eoRxPm56w6jH9lT7TxrLMP2Q//1XcyumXwQaGQ9gebL9IEVSg3/ZEtB/glAOusA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB9673.eurprd03.prod.outlook.com (2603:10a6:20b:5ee::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 10 Nov
 2022 15:39:37 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 10 Nov 2022
 15:39:37 +0000
Message-ID: <7b4fb14f-1ca0-e4f8-46ca-3884392627c2@seco.com>
Date:   Thu, 10 Nov 2022 10:39:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221109224110.erfaftzja4fybdbc@skbuf>
 <bcb87445-d80d-fea0-82f2-a15b20baaf06@seco.com>
 <20221110152925.3gkkp5opf74oqrxb@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221110152925.3gkkp5opf74oqrxb@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0005.prod.exchangelabs.com (2603:10b6:208:10c::18)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB9673:EE_
X-MS-Office365-Filtering-Correlation-Id: 87d86ac0-39b1-4cb0-c708-08dac331c605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cO+C95Rpv6MTYhHzTqZcfuqMPUgujNoITdrmiD4Lz88hmmTeTDFYLUyxO2zoerx0aONG5o3Ux1laCvX64Bx7q5sg7LdKww5hEylFsX18O2CkYZx3ks5jeH68Hi6P0B60VeeEeQTin+aUw6VryuvNWAF5tti4uFqFMHdbplyUNlqPJJGIwd9SmsQySEmeVagUNKzCA+rX3ZS4jHdf+wwL7yWTvEIYoF6uFN98G3PzMh33ynzwVAAFVzXQ0OxJJ8wgTrLQJZfxeURMo6mLaEN/1uxwiS8FPkBijWq85X4fnBO0MFXNd5Onl4QyTmcqWJKSWlhLDqzhe0n2+QmXeEAIF4e1Gh6IT8cMz2MfuP+7I3knzOLPqDhqmllDVpjrrcVIUmwGjLFul5KfjiJJ9VugDwgp+XXd5Q9ngrlBG9O6VcBYw5mKRZX2JTKvesxI1ZahC8qk/HRV4oFAYR73ItyNBbix5mMHvGUJDPYSpKC6u62uVti43YJbL0gxEVTKwDmNJCsiBzAEAtOK8JTlGh1j9rlsgP2Hm7nl/wm4iYlBs/yAF3YRFlQog78tVmkyIUfvEFWzeyfPjz6mxBeqF+zbxL4YBcyBIh/nzMB7K0VXq+Fj0tgvFBu2p4DGsqIFNPtzwLILMF98j21jX/8grz/sjSkM3jPWTc99q4TrveUGx6MceDgalXPWKSv63RBkLVtCcoUC7LxUEmloELD1EsuqGG4MN1+tU+AYN2RG/gxoQRxnJ/Q9qdQCbuJbg461DnSQ+MWN7tAT/c/y5O8txGPMO8i7pAWLhR5Ghaw6TL+3ONHOnl40f/DXGDLGcAyZKySGRC5f+MROcMb87eDoGHJhLiqjlgJYbtYufbRQNOkqRYc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(376002)(39850400004)(136003)(451199015)(44832011)(7416002)(316002)(83380400001)(38350700002)(26005)(7406005)(66946007)(38100700002)(6512007)(2906002)(31696002)(66476007)(6506007)(2616005)(52116002)(4326008)(41300700001)(186003)(478600001)(8936002)(6666004)(66556008)(54906003)(6486002)(86362001)(8676002)(966005)(53546011)(31686004)(36756003)(5660300002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c00wVVAvdWVYUlJSZ1pwcEhsWVFEa01Wc1RwN0xlNjJwRDBzZ0t6LzVtZG9w?=
 =?utf-8?B?dHQ0dnFPODFpVXZUaGo5ZG8vYVd2dDY4ZURsRnZCQ2JNWkNQaTB2UWtobWx4?=
 =?utf-8?B?VkNGZ2E5LzVIUEhQaUhvWjMydVlmWmpKa09ZVjFIT3lMN1IzVTE2REgrZ3RJ?=
 =?utf-8?B?OUlsM3pCVW9nbDY2WWRJaDFja3lmUlRialo3VVBpQzlCZVo5VFg4VUtwUCtx?=
 =?utf-8?B?NFRsSU5FTDRaNXN0NEdVMXpJRWtSNWhCek5MWE96d1JPS01DRFQ5YUR4Mlpy?=
 =?utf-8?B?STA5OEJmZmViWkxxbTNSODFuTE9YaCtHelQyc1FwRXo4RzBsR3dqd29WV2dm?=
 =?utf-8?B?T2dDa2ZhcXQ5NWVzM1RqZlFLbjFzM3hMbERGZk9ldDd2MzQrdEhmUS9FMTll?=
 =?utf-8?B?elozSlJVcE84QkhCL1kwTlRhayt1aGQvZE92S1pZQWpOMVZ6ZEhld0w2MWtE?=
 =?utf-8?B?WFNVRGNNN3VUckZHRk4wZEFFclpvT3R2aUdISEoyTVdRcEQ2YkVndzBaWWhq?=
 =?utf-8?B?d3hMc2d5N0FOaHIwYTMvREZ3Zlc0RUVvT0JDTS9lQzMxV0VQQlNkTm1RV1lW?=
 =?utf-8?B?WXduWGpSMjRMd3JoU3lCcjdhditGSmZQclV5a0JCMVpLMGR5ZkFEdFN3YmlX?=
 =?utf-8?B?YUZ4ZGRZZkhqa3JkVllyeFpJakR3NGpVTTdwemd4dUc2czZwZW1oWmp2NVNh?=
 =?utf-8?B?eWZpbVhYVXBFNVJjN21XcTRZMjZaaGNWQ1IwRCtyTitWL3RiN2xOWEhWUm8w?=
 =?utf-8?B?RDhONStOSzJ6VDJFaWxNT0hDcUZGWnNtRUhPVGdsUUZjb25YZWhTRnFVQ1N2?=
 =?utf-8?B?L2tCcmZlNzBDeUxjdUdYL3FmWTBDbG1JczMyRnYwOGJFZVBPL0NJOTdwUEdi?=
 =?utf-8?B?Qy94UExTWUNBYUViclk4YjUrc1VINStMN3hyZ205SGZZVUp5cnVCNlUxSmw5?=
 =?utf-8?B?eG94UzNVQUNkSXRLV0hXMHFMemRLZFM2V3JPQS9jWHJBclQxYnRHSXZ0RDVD?=
 =?utf-8?B?NmNpV0djU09nZ1cydkJrSGtoV0tkVE1GdU4rNEVIUUYwamRvQmhWSUYzbVRR?=
 =?utf-8?B?ZlhVUDFTQk5xc3UzSjc2L2tGeDhuWGJZQmcwMEZHWTFETlNKRWUxSWppamNp?=
 =?utf-8?B?ckpTVittR1ljZUQ2SU5BR2ZSK3YybURVWlorOWRYdTB3YXFaNy9DU05qTFJF?=
 =?utf-8?B?QXBpZllSaEVLMmxCWS8vN2N5Sk1ueWRyRHZCMU8waGZPTTNGcWpKdzJqZjZq?=
 =?utf-8?B?WlE2am5mcXRPZE5qOWdUdFdwM1RKZmllRlVHbndsMHZSYzV2R0ZKcEtjSkc4?=
 =?utf-8?B?OFVuemJlQTg5UVdsSjI3NWZtUVlnTUdOUWgrTnY0T3JlZTV6bmlueVJ5RGtG?=
 =?utf-8?B?MTd5S054SGNNdkJNbUFLRUZ5VGRyOHp5T3dQamdDM3FnYU1nNUFWRlRxRkwy?=
 =?utf-8?B?UWlsZGJPOW4rZUxyajcweUt6Sm9BUHp2a1QzcG1SdXMxQmpZUGhORGxwdTJX?=
 =?utf-8?B?QnZINm1Cb1Qyc0pPTzVYaEhSYmJ6cFdhbDhtbTNBMkQyOWdtRlBVMkdCb0ho?=
 =?utf-8?B?cnJpcjlJUkNETVU4aTVETG9PVmxPVXU2cmVzMFRQMFpUdnJGMEo5bGZvRTRh?=
 =?utf-8?B?WXpIWHpST3RtOURxOXNQZmVhVjlkeUMwWVZhdWoxNEF1bC8wTkdYaTE5L2Vi?=
 =?utf-8?B?ZEZIUzdjMmp0QWFuMGprNGg3WWNaSXB5SVVVb2c5M25xaXZWTitISURNbFlO?=
 =?utf-8?B?cXlOeDZ3ZUh1S3NSSmZ2SGtIZU9hK0Z6bFRUR21ZOHRueWlqWlhVVlBmS3B5?=
 =?utf-8?B?a29qOFJXbUFCYS9JQnBlVkRteUJQb1Q5c0xWbXYxTHkrakw0RXFtdXgxdTEz?=
 =?utf-8?B?ejQwMXJlY3ArZURiVVVYYWJUdnc1QjE1cmhWOXRrS2hDdzRJd3RqdmY2eEZW?=
 =?utf-8?B?ZGJTMjdQem1hS0pzdVcxREdOaTFYTzFpN085a0U3QTV1ZG5UZytDQmNKcE42?=
 =?utf-8?B?S1Z4S3JFNkx2bXNYcGFUV3V2UmlpYlNEUlZ3V1I1TnhjdlZrQm5jaE00Ti9E?=
 =?utf-8?B?cnFyQ1RuaHdqWGRDWWR5S0FIN2pqTTVlSHEraHZCKzVnalpDZ2VGMGpxdVFs?=
 =?utf-8?B?QUZ4d2NlLzY5em1MM2J5NFRrSVpnZXNHM2FtUFBidFlvYjluaXBYTDhhNGZK?=
 =?utf-8?B?MXc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d86ac0-39b1-4cb0-c708-08dac331c605
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 15:39:37.1615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M8291KueSVAz51cFRxdhbO/M5vDW0L/x4NJRNCCVH0Vv+qntLc1uCXKwj4TK/cijtyKK80GYe5xABkmSc8xTHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB9673
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/22 10:29, Vladimir Oltean wrote:
> On Thu, Nov 10, 2022 at 09:55:32AM -0500, Sean Anderson wrote:
>> On 11/9/22 17:41, Vladimir Oltean wrote:
>> > On Thu, Nov 03, 2022 at 05:06:39PM -0400, Sean Anderson wrote:
>> >> Several (later) patches in this series cannot be applied until a stable
>> >> release has occured containing the dts updates.
>> > 
>> > New kernels must remain compatible with old device trees.
>> 
>> Well, this binding is not present in older device trees, so it needs to
>> be added before these patches can be applied. It also could be possible
>> to manually bind the driver using e.g. a helper function (like what is
>> done with lynx_pcs_create_on_bus). Of course this would be tricky,
>> because we would need to unbind any generic phy driver attached, but
>> avoid unbinding an existing Lynx PCS driver.
> 
> If you know the value of the MII_PHYSID1 and MII_PHYSID2 registers for
> these PCS devices, would it be possible to probe them in a generic way
> as MDIO devices, if they lack a compatible string?

PCS devices are not PHYs, and they do not necessarily conform to the
standard PHY registers. Some PCS devices aren't even on MDIO busses (and
are instead memory-mapped). To implement this, I think we would need to be
very careful. There's also the issue where PCS devices might not be
accessable before their mode is selected by the MAC or SerDes.

>> As I understand it, kernels must be compatible with device trees from a
>> few kernels before and after. There is not a permanent guarantee of
>> backwards compatibility (like userspace has) because otherwise we would
>> never be able to make internal changes (such as what is done in this
>> series). I have suggested deferring these patches until after an LTS
>> release as suggested by Rob last time [1].
>> 
>> --Sean
>> 
>> [1] https://lore.kernel.org/netdev/20220718194444.GA3377770-robh@kernel.org/
> 
> Internal changes limit themselves to what doesn't break compatibility
> with device trees in circulation. DT bindings are ABI. Compared to the
> lifetime of DPAA2 SoCs (and especially DPAA1), 1 LTS release is nothing,
> sorry. The kernel has to continue probing them as Lynx PCS devices even
> in lack of a compatible string.

I believe the idea here is to allow some leeway when updating so that
the kernel and device tree don't have to always be in sync. However, we
don't have to support a situation where the kernel is constantly updated
but the device tree is never updated. As long as a reasonable effort is
made to update (or *not* update) both the kernel and device tree, there
is no problem.

--Sean
