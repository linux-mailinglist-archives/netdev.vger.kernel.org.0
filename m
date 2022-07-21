Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDC057D2C5
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbiGURvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiGURvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:51:17 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F8D820CF;
        Thu, 21 Jul 2022 10:51:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tnp0S3oSbNYSEvwjPtKF81mgwYiKhr/00nlF1+YVUyeIsgeRRlaV25g116q8nDABAsM6KJtM1HrWloGPJUGrP4ku1nkntgf8ZGrwbIKmP7yeY0Yj/AhspxUGrajmxj6t+E4CrV4T3KEPcQeqbQYn2K4Jd3WV6WiQR+qY2bUb9ikJp2GP3/h4hL6YFdDQYE659o9eHohK4By6+rZvv73MlAuWxV2o+3Pq9OQJMdIZQfQL5FrFpXNb5gzUN20VMpAiYjlecMthgPLcMrw0JHus7wWs4uHejoicWgwHUhl33fiWoEOEwfDsTUgKwpXVBPjasSs+ZmDMIQ20xOH2T529Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hqncOF98Bg50ygL/6Z0tNuDX4jxdqJrvDCWsrWjTvo=;
 b=U+64W+dC0OgsZlrjHmbnKU/5mkZDnBlJimSz2YSPrtCJVU5Eb4B4Ew5pS1kdYu7V/FwhkxXGeSaRCi0q+z8XYB5JwjtgDf6NsL5i38BrD7oyDn7gm1a5ZjAUrN6D1qVNrHl0aKGkkV7yW7usCcIKDEJOzOK6vIaJPHMwGpLKImfqy0Sut0c47rGTypG9r6AjkAjUUaoupU3Ru/c6gmqmvNeGSyAoZvZ+fwv0Xv6z1mv+RR0q0MVlQ77ZoroSJUT69YMPwLxLQxiuU5d4T/E2VKOWeShM8ClkbcPoqOQ8gQjMBf9sUPvyKk49+IuC4eZOS/X6tUZ12sdCjrtfKs7HJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hqncOF98Bg50ygL/6Z0tNuDX4jxdqJrvDCWsrWjTvo=;
 b=oMqU1mE61XvxWnxoGIHIzwWfVx5DYLnrgk86uGx9wMsJ1GmsGgZB1p5qxn81+rw3yJzcrNJ9MRh/8lVw+K5UumXhyXX6XuZiZGKS419SiN/1A7SXSmkxOgOw5IwR1C5rf/RcTa2QdX3J0lQ3vxCwohceSbwuiSUX9GnmPze78qeEsBauK2lhrSxdddXJiIxJ/v5jHd1pQnmcPWMmTYAzJCXCmCTRzM2V2JQhwhhdHOWVHOAwu3QUruguqsFiee4Pp7iB23lDTA02d8r0EbFA1F1XQY1vWsTNNXcM9YBmrQSLzdeQH22ibFnGqWfVQe6kjfbDTZhopljOADge2lA5bw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBAPR03MB6664.eurprd03.prod.outlook.com (2603:10a6:10:17d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 17:51:11 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 17:51:11 +0000
Subject: Re: [PATCH net-next v3 42/47] powerpc: dts: qoriq: Add nodes for
 QSGMII PCSs
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-43-sean.anderson@seco.com>
 <VI1PR04MB58079B0A71B13CC3B6D1D289F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <bc2209bd-6b04-1ec1-24e4-5cc095b5df52@seco.com>
Date:   Thu, 21 Jul 2022 13:51:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VI1PR04MB58079B0A71B13CC3B6D1D289F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:208:2d::37) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fa02d9b-8053-48bd-abac-08da6b419925
X-MS-TrafficTypeDiagnostic: DBAPR03MB6664:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQo0jFWt3syZASmgtysfKlXet0zhuZYexnJ0jiSqMYQGWH8Ypp3n6igqxEOqYfZSBfnjwgnaugQKVYXGpi6iPDHtFMkHUcUuwe4hSpUNRmnR7FVZty/fIR3lG7QIfnBkI04EGgxq9Kgq4+n9GpaTUeeJ/oR0ccT6xO7ufnEy+QCYHOG7wceqYnoxDZe1Xua3naowNGnSYDkfbsnHVy+QW3UpCBG3e7IlOc1uqK40JlCvBzpvNzL1YmOGIwRbCB4WpC8SxYx18TKLnDewiJ0iQeSKdeyw+WgeoftE6yDuGMayMMkWsENUXeHC9amKzaAbEK10QPNWjHc5yZ8zUOOFjHhPyr7uywaRXTS/WXcY8WBrjedvwTNsr5ZBWCcgUxpVWCllvq/wtzoDBonMTS8HZh9VHGT371L+moaCU9wh9OeKDe/ntEGuW+EzqSZTW2hAYBf3v7DfSL6aNktEjJcSCuECiY/snU18cy4pf7OBj59w/XCAGNOsgXdFWQpmSDJj0emMoqkXnhtTTf4aPsSGX89wOceCyY1x/Dz3ZySwNOs+o/maPuEd5l/wbGzTeJ8iDaYMmc+C5esmWuC64lgHd52TfiHhhl5Rx8qtgcLslWCLZKQw1wmTkfFDMBBJ28XButQUFrTRcwCECmxKfesl5VlOQMO7jSdUN3nLcyDfoMIbfL/N5mJ5EUP5dKxNZWA2yj98/c4f050ve8akfeWWQT9Km9dcVuUNQSkEcsSi6RNomB01xezC1TywfnuKNVCpKeL5bXSoOKwWWl09SfbcElQkwstlT5+hWGk8y6t0MwzsJCAA7uwWWWKIIx+iJcJsxbulNqqokjFVzeHcEXjBxW13q06kpTCJg4ziuzxjt9I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(366004)(346002)(376002)(39850400004)(44832011)(30864003)(6666004)(6506007)(7416002)(2906002)(41300700001)(5660300002)(86362001)(31696002)(2616005)(6486002)(52116002)(53546011)(8936002)(186003)(478600001)(54906003)(26005)(6512007)(110136005)(38100700002)(38350700002)(316002)(31686004)(36756003)(83380400001)(66556008)(66946007)(66476007)(8676002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmN3RFNsK3pVV0t2aEc4NmV1MS8veGgraUpZWWhhSy9RMFFhUithbEVRcnNK?=
 =?utf-8?B?VG1lWkgyaXpJYUhkcHhSbGt1UnAyaG1tWE0vUTY5SVBHTHhNVWRKWjVVbU9O?=
 =?utf-8?B?ZEhHSHRmMWxOYmUvdkppeEVGZGxyMUVNZHR0WGdOR1lRU3VOcmVNVUNML2Fa?=
 =?utf-8?B?MXNZVnFEVm5Jam1aZkpFTkh3ZlR1c2p2QmM5ODRnbFBsRm9PTWNGYkF1MXlh?=
 =?utf-8?B?ZlBrNDR2VkNIakV4NE81cG1FRTNaK0xVNTVjMW1qbWFDUDVBaDJhUTZQa1dv?=
 =?utf-8?B?bGM0dTFMb0NrcEFFeFdCbXRkQTFXMHExbmlLV3dETzlCRWh4c09XMHluSitx?=
 =?utf-8?B?NEhnVEhiTCs5ck5zSXNJUThLU1hua24yckJDaVRwQ0dkOE5DOWpaV1NEb1Iv?=
 =?utf-8?B?cm1xQjVDck9ZOEhOa2xGdUVHVjFSNkhqMGNkSndOZEx0TlhrNE1nMGxSdk5N?=
 =?utf-8?B?UkxtYWpmNnJRU3o0T1BOd01nWHdaZ1AyRGlBdjVEeEZYL2FyREd1MDc2dW5T?=
 =?utf-8?B?RU1KTFUwbm9CeVpUemdXK04wZDhOVEJHYUFvaTE5RHIwQU1NWTJDZFhNN09j?=
 =?utf-8?B?QmdDSWxBczRKUVJSb3l3d2RQT09ENVdFR2wxZ2RLcExOMG1UWklpWDlBMldN?=
 =?utf-8?B?WWRmK2FFZTV0dXAzUkFvcXNHbm9pOUwxNVo3SjVCVHdHMVRiak5LbmVLa0lV?=
 =?utf-8?B?bzIxSTZVbkJYU2NodFlzdmc4SmdkV1RFdnB1aHIrUjlKaFdmbkR6SmJZOHlV?=
 =?utf-8?B?QW40NkFpSHJKNTd4bVRYSERmRm1WYzNVd2hKZjl4dXdRMWZVa25SaFB1M0wr?=
 =?utf-8?B?MTREV3VuY0twSjVRUTV6N2gySVF2bGdXRzRFN2tPS3hBdmZ4a1VZazRYdlZo?=
 =?utf-8?B?SmUrOEpNR09qbXpCcHZmSCs2VTJubDArcUNuNGlQKzdsZXJUdXNBMTBTbXFE?=
 =?utf-8?B?bEJGck8xeFlpL2JpQmZmdVQ5NXJ6aTBpTlVNaFRQVDRMUFF2ODZBajFMTlZV?=
 =?utf-8?B?WUFLbjRBQlFkRlBHblRKOC9GV3VtUitGd1FLRFpOaFAyYTYycFBPS0JTSVdz?=
 =?utf-8?B?WU1JbWxveWNIQ2FXS1RZRzNna2xDZUNBeVpZSFlOaWdlbElsYnpoUm8rVnU0?=
 =?utf-8?B?ZTVqckZLR0VCdlgxaWIwOFFkZGpZWlhFRWRQM0FHTE9MelcyNTBHcWkySTZQ?=
 =?utf-8?B?eHZ5ejR2QmZza2xrWmx3WWN5cUtmS1d0MmZpYllzd0lZTlNZWG05b3ZVNmow?=
 =?utf-8?B?eWZhWk9hbXkrM1Fqc09GNTR6alpkZnZxYlhVeFRRMXYyamNreHl0cDlNams0?=
 =?utf-8?B?WVhLRlE2c1lqRll3YkIxaGh0M0N6ZmhObEJ4QUtBVTVJK3ZsQktyUkdKZmc1?=
 =?utf-8?B?MEZjWS9XcWh1VGxic1FzTWlzRXNHL3BqT0JnZ2s5YzFXTmkyRFNNT2FyQTFD?=
 =?utf-8?B?c3paWkdzNmFvLzV5dVlxNFMvamVtL2VYVVhoQmJQUk5EYVdvdTZYU2E0SE4w?=
 =?utf-8?B?bys0SHBTelVJREpBMkR2dlhaQkZXZ3NBRFF0MWJ6MDlPS3Q1UWF5M0ZxQXJ4?=
 =?utf-8?B?N0ZRaVRYVHcrYkg1M1dBNDJ5WlhRR0N6Um5idEQra0pVUEFLWWd0ZTcwREFk?=
 =?utf-8?B?RkQ1MityMmhZaVQxdlBVTEw5Nk9kZktaeUhJQ3U3aWdDNTZCSFRqYlFVOHJ3?=
 =?utf-8?B?TjQ5Z1lwVTBIbUs2enlERlNXbWpwcW4zL1VFbTRFUnZQV3pCWXJlTW5OUlc3?=
 =?utf-8?B?V0N3Y3N4bmhXK3RaMnU5VUxpY3d3MExBejI1SGk3amJ0ck12c01BOEs3K1Qy?=
 =?utf-8?B?MVVQVnpBK2pPS3g3Z2tiblZLSVdwdENDY2I1V3d4L1U1dmNYRG1EVnYvTnZB?=
 =?utf-8?B?Q2gzeXZ2Lzc3YklhTXJNV1l4NDdlaEcydHBWVkZodTdhZHJiSUs5NS9OWjc5?=
 =?utf-8?B?SC9oV3dsYWI1dm9vMW1QdWUxZWRmR2NEN1d1Q3NVUXhDcTJLZWFVWlNTOTc4?=
 =?utf-8?B?TjA0OWE5U0tTdHMwcEdXN3o1eVptY2VZalVhYVVlL0JHQXVLcnM4eXpSempV?=
 =?utf-8?B?dEh6eE5tYmxTZSs3Q1VFb0NFSUZIZy81c2ZOYmxnMjF2ek9rUnkrOFBVaFk2?=
 =?utf-8?B?ckJ0ZmFRMVhheEhoamsxVS9wZjFBOVpCS3ljZld1Nlo2Mng3aHdva0E3Nmkv?=
 =?utf-8?B?M0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fa02d9b-8053-48bd-abac-08da6b419925
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 17:51:11.5431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N04/tEHdEezRh8GZt0JWl/ty4cJM5YD/3vWQmR1PrZKFKsnd19w0uXacC6dSEANSe6ADzNt9MBJwtPICIZW6hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6664
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 9:48 AM, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Linuxppc-dev <linuxppc-dev-
>> bounces+camelia.groza=nxp.com@lists.ozlabs.org> On Behalf Of Sean
>> Anderson
>> Sent: Saturday, July 16, 2022 1:00
>> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
>> netdev@vger.kernel.org
>> Cc: devicetree@vger.kernel.org; Leo Li <leoyang.li@nxp.com>; Sean
>> Anderson <sean.anderson@seco.com>; linuxppc-dev@lists.ozlabs.org;
>> Russell King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Eric
>> Dumazet <edumazet@google.com>; Rob Herring <robh+dt@kernel.org>;
>> Paul Mackerras <paulus@samba.org>; Krzysztof Kozlowski
>> <krzysztof.kozlowski+dt@linaro.org>; Paolo Abeni <pabeni@redhat.com>;
>> Shawn Guo <shawnguo@kernel.org>; linux-arm-kernel@lists.infradead.org
>> Subject: [PATCH net-next v3 42/47] powerpc: dts: qoriq: Add nodes for
>> QSGMII PCSs
>> 
>> Now that we actually read registers from QSGMII PCSs, it's important
>> that we have the correct address (instead of hoping that we're the MAC
>> with all the QSGMII PCSs on its bus). This adds nodes for the QSGMII
>> PCSs. They have the same addresses on all SoCs (e.g. if QSGMIIA is
>> present it's used for MACs 1 through 4).
>> 
>> Since the first QSGMII PCSs share an address with the SGMII and XFI
>> PCSs, we only add new nodes for PCSs 2-4. This avoids address conflicts
>> on the bus.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> MAC1 and MAC2 can be XFI on T2080. This needs to be reflected in qoriq-fman3-0-1g-0.dtsi
> and qoriq-fman3-0-1g-1.dtsi
> 
> The two associated netdevs fail to probe on a T2080RDB without "xfi" added to the pcs-names:
> fsl_dpaa_mac ffe4e0000.ethernet (unnamed net_device) (uninitialized): failed to validate link configuration for in-band status
> fsl_dpaa_mac ffe4e0000.ethernet: error -EINVAL: Could not create phylink
> fsl_dpa: probe of dpaa-ethernet.0 failed with error -22

Ah, I missed that this SoC had 10G on MAC1/MAC2. Going with the existing
naming scheme, these MACs should probably go in DTSs named
qoriq-fman3-0-1g-2.dtsi and qoriq-fman3-0-1g-3.dtsi. Alternatively, this
could be done in t2081si-post.dtsi, since it is only for one SoC. I don't
want to add these to qoriq-fman3-0-1g-0.dtsi and qoriq-fman3-0-1g-1.dtsi
because they are used on other SoCs which don't have 10G.

--Sean

>> ---
>> 
>> Changes in v3:
>> - Add compatibles for QSGMII PCSs
>> - Split arm and powerpcs dts updates
>> 
>> Changes in v2:
>> - New
>> 
>>  .../boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |  3 ++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     | 10 +++++++++-
>>  .../boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |  3 ++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |  3 ++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |  3 ++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      | 10 +++++++++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |  3 ++-
>>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      | 10 +++++++++-
>>  18 files changed, 127 insertions(+), 18 deletions(-)
>> 
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
>> index baa0c503e741..db169d630db3 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
>> @@ -55,7 +55,8 @@ ethernet@e0000 {
>>  		reg = <0xe0000 0x1000>;
>>  		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
>>  		ptp-timer = <&ptp_timer0>;
>> -		pcsphy-handle = <&pcsphy0>;
>> +		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
>> +		pcs-names = "sgmii", "qsgmii";
>>  	};
>> 
>>  	mdio@e1000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
>> index 93095600e808..e80ad8675be8 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
>> @@ -52,7 +52,15 @@ ethernet@f0000 {
>>  		compatible = "fsl,fman-memac";
>>  		reg = <0xf0000 0x1000>;
>>  		fsl,fman-ports = <&fman0_rx_0x10 &fman0_tx_0x30>;
>> -		pcsphy-handle = <&pcsphy6>;
>> +		pcsphy-handle = <&pcsphy6>, <&qsgmiib_pcs2>,
>> <&pcsphy6>;
>> +		pcs-names = "sgmii", "qsgmii", "xfi";
>> +	};
>> +
>> +	mdio@e9000 {
>> +		qsgmiib_pcs2: ethernet-pcs@2 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <2>;
>> +		};
>>  	};
>> 
>>  	mdio@f1000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
>> index ff4bd38f0645..6a6f51842ad5 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
>> @@ -55,7 +55,15 @@ ethernet@e2000 {
>>  		reg = <0xe2000 0x1000>;
>>  		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
>>  		ptp-timer = <&ptp_timer0>;
>> -		pcsphy-handle = <&pcsphy1>;
>> +		pcsphy-handle = <&pcsphy1>, <&qsgmiia_pcs1>;
>> +		pcs-names = "sgmii", "qsgmii";
>> +	};
>> +
>> +	mdio@e1000 {
>> +		qsgmiia_pcs1: ethernet-pcs@1 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <1>;
>> +		};
>>  	};
>> 
>>  	mdio@e3000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
>> index 1fa38ed6f59e..543da5493e40 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
>> @@ -52,7 +52,15 @@ ethernet@f2000 {
>>  		compatible = "fsl,fman-memac";
>>  		reg = <0xf2000 0x1000>;
>>  		fsl,fman-ports = <&fman0_rx_0x11 &fman0_tx_0x31>;
>> -		pcsphy-handle = <&pcsphy7>;
>> +		pcsphy-handle = <&pcsphy7>, <&qsgmiib_pcs3>,
>> <&pcsphy7>;
>> +		pcs-names = "sgmii", "qsgmii", "xfi";
>> +	};
>> +
>> +	mdio@e9000 {
>> +		qsgmiib_pcs3: ethernet-pcs@3 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <3>;
>> +		};
>>  	};
>> 
>>  	mdio@f3000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
>> index a8cc9780c0c4..ce76725e6eb2 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
>> @@ -51,7 +51,8 @@ ethernet@e0000 {
>>  		reg = <0xe0000 0x1000>;
>>  		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
>>  		ptp-timer = <&ptp_timer0>;
>> -		pcsphy-handle = <&pcsphy0>;
>> +		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
>> +		pcs-names = "sgmii", "qsgmii";
>>  	};
>> 
>>  	mdio@e1000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
>> index 8b8bd70c9382..f3af67df4767 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
>> @@ -51,7 +51,15 @@ ethernet@e2000 {
>>  		reg = <0xe2000 0x1000>;
>>  		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
>>  		ptp-timer = <&ptp_timer0>;
>> -		pcsphy-handle = <&pcsphy1>;
>> +		pcsphy-handle = <&pcsphy1>, <&qsgmiia_pcs1>;
>> +		pcs-names = "sgmii", "qsgmii";
>> +	};
>> +
>> +	mdio@e1000 {
>> +		qsgmiia_pcs1: ethernet-pcs@1 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <1>;
>> +		};
>>  	};
>> 
>>  	mdio@e3000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
>> index 619c880b54d8..f6d74de84bfe 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
>> @@ -51,7 +51,15 @@ ethernet@e4000 {
>>  		reg = <0xe4000 0x1000>;
>>  		fsl,fman-ports = <&fman0_rx_0x0a &fman0_tx_0x2a>;
>>  		ptp-timer = <&ptp_timer0>;
>> -		pcsphy-handle = <&pcsphy2>;
>> +		pcsphy-handle = <&pcsphy2>, <&qsgmiia_pcs2>;
>> +		pcs-names = "sgmii", "qsgmii";
>> +	};
>> +
>> +	mdio@e1000 {
>> +		qsgmiia_pcs2: ethernet-pcs@2 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <2>;
>> +		};
>>  	};
>> 
>>  	mdio@e5000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
>> index d7ebb73a400d..6e091d8ae9e2 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
>> @@ -51,7 +51,15 @@ ethernet@e6000 {
>>  		reg = <0xe6000 0x1000>;
>>  		fsl,fman-ports = <&fman0_rx_0x0b &fman0_tx_0x2b>;
>>  		ptp-timer = <&ptp_timer0>;
>> -		pcsphy-handle = <&pcsphy3>;
>> +		pcsphy-handle = <&pcsphy3>, <&qsgmiia_pcs3>;
>> +		pcs-names = "sgmii", "qsgmii";
>> +	};
>> +
>> +	mdio@e1000 {
>> +		qsgmiia_pcs3: ethernet-pcs@3 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <3>;
>> +		};
>>  	};
>> 
>>  	mdio@e7000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
>> index b151d696a069..e2174c0fc841 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
>> @@ -51,7 +51,8 @@ ethernet@e8000 {
>>  		reg = <0xe8000 0x1000>;
>>  		fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
>>  		ptp-timer = <&ptp_timer0>;
>> -		pcsphy-handle = <&pcsphy4>;
>> +		pcsphy-handle = <&pcsphy4>, <&pcsphy4>;
>> +		pcs-names = "sgmii", "qsgmii";
>>  	};
>> 
>>  	mdio@e9000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
>> index adc0ae0013a3..9106815bd63e 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
>> @@ -51,7 +51,15 @@ ethernet@ea000 {
>>  		reg = <0xea000 0x1000>;
>>  		fsl,fman-ports = <&fman0_rx_0x0d &fman0_tx_0x2d>;
>>  		ptp-timer = <&ptp_timer0>;
>> -		pcsphy-handle = <&pcsphy5>;
>> +		pcsphy-handle = <&pcsphy5>, <&qsgmiib_pcs1>;
>> +		pcs-names = "sgmii", "qsgmii";
>> +	};
>> +
>> +	mdio@e9000 {
>> +		qsgmiib_pcs1: ethernet-pcs@1 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <1>;
>> +		};
>>  	};
>> 
>>  	mdio@eb000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
>> index 435047e0e250..a3c1538dfda1 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
>> @@ -52,7 +52,15 @@ ethernet@f0000 {
>>  		compatible = "fsl,fman-memac";
>>  		reg = <0xf0000 0x1000>;
>>  		fsl,fman-ports = <&fman1_rx_0x10 &fman1_tx_0x30>;
>> -		pcsphy-handle = <&pcsphy14>;
>> +		pcsphy-handle = <&pcsphy14>, <&qsgmiid_pcs2>,
>> <&pcsphy14>;
>> +		pcs-names = "sgmii", "qsgmii", "xfi";
>> +	};
>> +
>> +	mdio@e9000 {
>> +		qsgmiid_pcs2: ethernet-pcs@2 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <2>;
>> +		};
>>  	};
>> 
>>  	mdio@f1000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
>> index c098657cca0a..c024517e70d6 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
>> @@ -52,7 +52,15 @@ ethernet@f2000 {
>>  		compatible = "fsl,fman-memac";
>>  		reg = <0xf2000 0x1000>;
>>  		fsl,fman-ports = <&fman1_rx_0x11 &fman1_tx_0x31>;
>> -		pcsphy-handle = <&pcsphy15>;
>> +		pcsphy-handle = <&pcsphy15>, <&qsgmiid_pcs3>,
>> <&pcsphy15>;
>> +		pcs-names = "sgmii", "qsgmii", "xfi";
>> +	};
>> +
>> +	mdio@e9000 {
>> +		qsgmiid_pcs3: ethernet-pcs@3 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <3>;
>> +		};
>>  	};
>> 
>>  	mdio@f3000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
>> index 9d06824815f3..16fb299f615a 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
>> @@ -51,7 +51,8 @@ ethernet@e0000 {
>>  		reg = <0xe0000 0x1000>;
>>  		fsl,fman-ports = <&fman1_rx_0x08 &fman1_tx_0x28>;
>>  		ptp-timer = <&ptp_timer1>;
>> -		pcsphy-handle = <&pcsphy8>;
>> +		pcsphy-handle = <&pcsphy8>, <&pcsphy8>;
>> +		pcs-names = "sgmii", "qsgmii";
>>  	};
>> 
>>  	mdio@e1000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
>> index 70e947730c4b..75cecbef8469 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
>> @@ -51,7 +51,15 @@ ethernet@e2000 {
>>  		reg = <0xe2000 0x1000>;
>>  		fsl,fman-ports = <&fman1_rx_0x09 &fman1_tx_0x29>;
>>  		ptp-timer = <&ptp_timer1>;
>> -		pcsphy-handle = <&pcsphy9>;
>> +		pcsphy-handle = <&pcsphy9>, <&qsgmiic_pcs1>;
>> +		pcs-names = "sgmii", "qsgmii";
>> +	};
>> +
>> +	mdio@e1000 {
>> +		qsgmiic_pcs1: ethernet-pcs@1 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <1>;
>> +		};
>>  	};
>> 
>>  	mdio@e3000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
>> index ad96e6529595..98c1d27f17e7 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
>> @@ -51,7 +51,15 @@ ethernet@e4000 {
>>  		reg = <0xe4000 0x1000>;
>>  		fsl,fman-ports = <&fman1_rx_0x0a &fman1_tx_0x2a>;
>>  		ptp-timer = <&ptp_timer1>;
>> -		pcsphy-handle = <&pcsphy10>;
>> +		pcsphy-handle = <&pcsphy10>, <&qsgmiic_pcs2>;
>> +		pcs-names = "sgmii", "qsgmii";
>> +	};
>> +
>> +	mdio@e1000 {
>> +		qsgmiic_pcs2: ethernet-pcs@2 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <2>;
>> +		};
>>  	};
>> 
>>  	mdio@e5000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
>> index 034bc4b71f7a..203a00036f17 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
>> @@ -51,7 +51,15 @@ ethernet@e6000 {
>>  		reg = <0xe6000 0x1000>;
>>  		fsl,fman-ports = <&fman1_rx_0x0b &fman1_tx_0x2b>;
>>  		ptp-timer = <&ptp_timer1>;
>> -		pcsphy-handle = <&pcsphy11>;
>> +		pcsphy-handle = <&pcsphy11>, <&qsgmiic_pcs3>;
>> +		pcs-names = "sgmii", "qsgmii";
>> +	};
>> +
>> +	mdio@e1000 {
>> +		qsgmiic_pcs3: ethernet-pcs@3 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <3>;
>> +		};
>>  	};
>> 
>>  	mdio@e7000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
>> index 93ca23d82b39..9366935ebc02 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
>> @@ -51,7 +51,8 @@ ethernet@e8000 {
>>  		reg = <0xe8000 0x1000>;
>>  		fsl,fman-ports = <&fman1_rx_0x0c &fman1_tx_0x2c>;
>>  		ptp-timer = <&ptp_timer1>;
>> -		pcsphy-handle = <&pcsphy12>;
>> +		pcsphy-handle = <&pcsphy12>, <&pcsphy12>;
>> +		pcs-names = "sgmii", "qsgmii";
>>  	};
>> 
>>  	mdio@e9000 {
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
>> index 23b3117a2fd2..39f7c6133017 100644
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
>> @@ -51,7 +51,15 @@ ethernet@ea000 {
>>  		reg = <0xea000 0x1000>;
>>  		fsl,fman-ports = <&fman1_rx_0x0d &fman1_tx_0x2d>;
>>  		ptp-timer = <&ptp_timer1>;
>> -		pcsphy-handle = <&pcsphy13>;
>> +		pcsphy-handle = <&pcsphy13>, <&qsgmiid_pcs1>;
>> +		pcs-names = "sgmii", "qsgmii";
>> +	};
>> +
>> +	mdio@e9000 {
>> +		qsgmiid_pcs1: ethernet-pcs@1 {
>> +			compatible = "fsl,lynx-pcs";
>> +			reg = <1>;
>> +		};
>>  	};
>> 
>>  	mdio@eb000 {
>> --
>> 2.35.1.1320.gc452695387.dirty
> 
