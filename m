Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D8A5F46AE
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 17:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJDP2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 11:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJDP2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 11:28:31 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80053.outbound.protection.outlook.com [40.107.8.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EFB63F08;
        Tue,  4 Oct 2022 08:28:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkxGOoGG2hdfG/BuGAHv+2m9++bT856VbOhcfT/yd9SN0xRtJM3FPIwqywGw7M5jSVTBRtkrTW+oaTCTeh7WIXBi686XM1cpO+me0nv2M3rErPYIsX7SsfAXxJ7f6K3rbqZJYKDu9ygbBw8FPadH4WYu3CCgYKzcpOTd0IvealqJbuNT2FGzBfsa3zVbme7WYA4Cd2tUMkYDL+NP5i6UO+3U/qy9RqlZFlmk5/G9KuP/kBSs7d9IrBi0njyhMLP6kRGIC/bWSsFta5FLg4Jd5HieiDagIeHKOM/gGQM9jVsQP9/9m8YQCmIQw4VD2DO4LQfzkuMoRpj9pMoX3drYpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=utHeRmrtIn+ml3oqML+dHByEHWwKQl1j4o0RRnJ8zcU=;
 b=i5Ttk1ffNKkWgSdQsRP9dUsW0Jmhj2wX9KukYAUp2MkEYqK3SsV9V9fRputD3apWpKhMu+xyZxRzgp9cvhJw7Wkg7vCKEp/6bVj2HItjWPepYlECW49b9KV1vQAen7b0xPaUlTN9eyvT1PMR0t0HK1I+az3SzqHp/glUfAbDzETAEOXyNtdsXJUDg5eFX0J1cjOlRakoX5UFWt5MAYkt3xTDXFOId94y8C3cXTY8LZ0VBLSW0Fsj0DwVYssLtYXgwZ84l6/ijF/no7Dk6hpWR0mqtOtduAQnZcUR3Wl2zIOgCLjfba8FnCJfcynTnpXZp14gF8isN03UltoCNHxV2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utHeRmrtIn+ml3oqML+dHByEHWwKQl1j4o0RRnJ8zcU=;
 b=LRip58YpOlo06mQMfs7CUYB8vTT5t/rFEK5YZmwFloCpQJ/IEXn9YGf5bL3kPq/Bru2aQ3h9QRQ2YMcU5DGRRDTvXa9EaqTjOqCupfbJPk++Iw5hTkCbh/hG5HUG8lNT5k0v7+CPXkDvDjp90b/TvR60/gbW+MJrQcmXIhVJbSw0cI8GbrB0QG+F7RQ1hqYzsAcTt4Rb4OnYe0UWYIUwI0EgTkkd2gXyztc8+S52hFlRxOlIYxi+fij0lcAWgUfriYzwQK2g89xEk+BxTHhV41dYMYiZb0oVoz8egAcDfG6IlPlOoZlQ1zGVbYqxnpF1rVRPEj76NU8o+wDZqCkhPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PA4PR03MB7392.eurprd03.prod.outlook.com (2603:10a6:102:106::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Tue, 4 Oct
 2022 15:28:24 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 15:28:24 +0000
Subject: Re: [PATCH net-next v6 0/9] [RFT] net: dpaa: Convert to phylink
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
References: <20220930200933.4111249-1-sean.anderson@seco.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <0b47fd86-f775-e6ad-4e5f-e40479f2d301@seco.com>
Date:   Tue, 4 Oct 2022 11:28:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220930200933.4111249-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0026.namprd10.prod.outlook.com
 (2603:10b6:208:120::39) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PA4PR03MB7392:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b5a8244-753b-4a25-3175-08daa61d13d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JVcoEo9aWWcB1bOCOF6wpOJeNchRcPWYftTWa6+yThfOx7sMEhvg125C9Kzlt7gNJAk7MhIeyWWX8sZEyN3hKq08zDPeiB0AoChPGCijdIiktyoWnU5WTxl2X7oizTK7f26EGLRarceLRcKzOzce8M+3YyEC6u3/TBxb9doNeJLtFQeWjpVDLBLSeYCC0Yqw7YXlzN0LopE2uj75LWp8MLPIcvrxrh+MAuLr2OHTmhEEtuwpkSm8S1tDoBlt5WZQcwD4eH4cxmGpduQbe3KvSXrAb64eqLSP/1zIfFnQzfrkHPk2EIcpRN9qiUOLSabQLMdbtcZbdmY8YNoOZOBFx2yYXwfIsxJhB31lmSQ+cI8uivq7who4XQ10bzLpQUg/1z3tANkk4ap61OWH+n8L2+5dDLVJZE8byVxIZJDFM0duMeDUqquOTDr5PZtC7UimF2iA2yzjcq7R69PPupFsTBnX/DDsPWkSUCcjPNBobK0tq8VArVSlNdtjysa4G540Xdy46HlNdqnLvY0qXmX8fLzuECHAHHKEF75akuBCwgq/qjwH7Bo/hd3QKD62zIChYXSf5k42OgxiZIndYr7HlQOp9k1D0ZIvCVQzlrHGeLeg09a3egwJHTs/1e/LUbyW4etO43s5ZJMHOcw8KNCB5KT+dZc1vIejGmHZcLVqN8WE0HoKPqZLyKeydGAxVCf2kI1NgubtZu8XerKRJr2GjhEAK1fg8MNsB1kQtv14RZSLiClYEIvDYhyctELNbTsxoz29D/XstYmcOileGX0b10kZfozVksAqI7E2g0ejFWygCJuAGrmFbqDhdiAboQHU9/pAlMCY0fEtZef9pAw1fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(39850400004)(376002)(451199015)(53546011)(66476007)(2616005)(52116002)(26005)(6666004)(6506007)(6512007)(4326008)(66946007)(54906003)(316002)(8676002)(36756003)(66556008)(478600001)(110136005)(31696002)(38350700002)(38100700002)(86362001)(83380400001)(186003)(6486002)(31686004)(7416002)(5660300002)(8936002)(44832011)(41300700001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWQvTkQySXNDVkRnWjc1alFHS29KNGRUSmhBWjBMd3h3bDFnelNwK0h5VWlI?=
 =?utf-8?B?dVkxUHR0T2Zsd3psZGRLM0twRDN5Zng5dzdyVXNDM2ZKZ0dKYWREdnBaeU4r?=
 =?utf-8?B?WWxmRi93WHYzbFN2T3VrRXl0TlZqOVhDWGJlei9jZVNmaVFvbjdSMVgySWVY?=
 =?utf-8?B?Tjh3Q2Y2eWhrbGFTWjZQZ1k2MVRyTVVQMkpRaTZXVm92ZHZyM09oa0J2em9t?=
 =?utf-8?B?dDRpV1lNaVJsc3VOekNXeC9pMDllRXhxd1BVL3BwL014SGQzOUd4YVdrWEgv?=
 =?utf-8?B?RlluT1VaVEFvcWh3RXpZWmVhamx0V0t3RG53b1hpdEFydXVkSkNkRVI5MFRJ?=
 =?utf-8?B?Sk5WS1lVUWxjVXpYQ0llUmp2Z1EyOFo3MzE1T3Z4VUlaYVIwTm4rYzRHYWpm?=
 =?utf-8?B?K0grVlRYUWtrZGlZSGdCampCVkRkcVNBNFk1S1hnbEYzUDV0VjZPYncyeVc4?=
 =?utf-8?B?U1VHL2RRQVRHdDhTM0d6TkRHT1NQZ2ZINzZzc21FQWNsNk8ycGxMRS9WYkF1?=
 =?utf-8?B?WDhQSWNZN2FnQkI4OWRsMFg3SGRPdk9MNHhEWHVBVE85ZUdGYmZncjRLKzNt?=
 =?utf-8?B?V0gxaWFwNC9Bb25PZ2lzbXk3TXp3VDF3OXhNQ2hmenVVYWFkaFM4aFVVYXpa?=
 =?utf-8?B?R21tNmFWNVo4c0tYaGlPYlFXZHl1WVFnMXBGK290WVZQWWNteVdzMzBzSUx0?=
 =?utf-8?B?eHNaNXdMZmNzd09GT3ZPRTVqUVg4d1UxaXd1cUF3V2VLdjZrY1FXdVFZSksw?=
 =?utf-8?B?TDhMSmVRR0psZzRISDU4QkdoVnFLalN1ekRhOC9ZTzcrQWE0Y3JqOTZqV1JH?=
 =?utf-8?B?S0x2WTBCUjVUOUFDcmpDQzAvV1p4YlBOSGxRZU9xT1dWTHZldm1yTm5ldWpP?=
 =?utf-8?B?NFN3Wjc0WVE4M2tCRG1hM3FSMW5tMFU0WmpDakZEaG5LOHZVVVgzcUdwMWRh?=
 =?utf-8?B?dzJiR3p4NzZxYWplZzJSeTVDMU1UVlJKY1dxWjNSTUNzdGVXME9zc2E3ZTRT?=
 =?utf-8?B?TUs1RytiN3IwREJYSk9YbGxGSmFVVWxybWxzQ2NmQkI0ejhGaXFlbnpqVnRC?=
 =?utf-8?B?T2FpczJIcVkyZDJGdXNqeEd4SzhsTmJwMTdDRk1sYmJRdlVvTWkwdEdzTHc5?=
 =?utf-8?B?K1ZqdkFqUyszT0JEeW1SN2s0S0lsWmxpR2tSSGxLc0ZpbmlDVzQ3T3FPd3V6?=
 =?utf-8?B?dGZvRy9jT2R3bXlZUm0xZkxnTVlIRmJjQlJJajl6Tk45UWVldGpCbHRIbE9U?=
 =?utf-8?B?dERvN3M4UXAyMEg5UEVNMmZWYWdkcXN6cjg5dnlmNk5rM2MyUFVhWWxNOFcx?=
 =?utf-8?B?U2xBN2U3SnFtSmZRN1FkR2EvRGtxWHd1L0YzelFiQi9lemp3SWorMmVOdUFq?=
 =?utf-8?B?TVVGV2RtY2NqNTdISGFrR0V0cnFmS0xydG1aMkdjcnk2SHpoRWREc2Y4a2pp?=
 =?utf-8?B?UUFsUGRBdW5QUGlyS3NWaXNYVEY5cnRhbWlGR1BkQ3ZHMjdyN1VsNjJVL3FM?=
 =?utf-8?B?TE5sL1J3eWl6NkpZMGw0UGFETGVkSmo1N3UzakZHa0FDbFFjR1pkNi8vbHRh?=
 =?utf-8?B?Sys1WkhqSnY3WjNXakNkbngwaG14TUgxZHdiMVFkYW1JTlNpdFI1SGN4bVEx?=
 =?utf-8?B?eW41YnlhdnZFTUR6S1NGalRlc0JpQldNWGJpUE5JRUlnODFNMU1LSmdDU1FJ?=
 =?utf-8?B?cVZRbzdnNm5GVFFQaDFpdTRPQURzVnFOaGFDS2IvWDVpcVYyaWtPNXlldkdq?=
 =?utf-8?B?ZURYcktFcFJFWVdCLzAzSG1KR3FhbldWUEN5Uk9OWHNRUWhpdkl6WE1KUVRp?=
 =?utf-8?B?UGo5RS83YXNWajBYUVJlMjdFbmF5ZExMc3pIbVorNDZhV2QrTVRNcTlDUmxN?=
 =?utf-8?B?dk12ZjNtMzZFZEl6ekJmKzAxL2N3dUx6ZUtZaFFHbTZsdkduVTgyTXQyTndo?=
 =?utf-8?B?ZkpDN1N2aU1IdmZzdkNEdk5QSnJyZ0lYL3NRUU1YbzNpYWVIREZOK1ZvQ1Vv?=
 =?utf-8?B?and6TEpvak9hci9FeG5JbTl2VDZIb1JSa1JNQ3hobEwxTlh2WEdWMWJYbHhi?=
 =?utf-8?B?ejRhSEdpc2JCNHpTMDFSTzRGeXlkWjMvU2hVZEt2TnQ5cjI4VWlQNXBzVTQx?=
 =?utf-8?B?L0xROG9QejcxNG82ZlhmbVZWTnNFNUcxbnNiL0hDTVN1NFd4MUZhVm42dFUx?=
 =?utf-8?B?SkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b5a8244-753b-4a25-3175-08daa61d13d3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 15:28:24.4622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iom7TPJS0rWAzTylNGORceCHH8B3oVC2qPLpys3PDbD4BMM0Mu7diqiTVwyAp/rHE7LQS2IPBsyY1PqehZdjHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7392
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/22 4:09 PM, Sean Anderson wrote:
> This series converts the DPAA driver to phylink.
> 
> I have tried to maintain backwards compatibility with existing device
> trees whereever possible. However, one area where I was unable to
> achieve this was with QSGMII. Please refer to patch 2 for details.
> 
> All mac drivers have now been converted. I would greatly appreciate if
> anyone has T-series or P-series boards they can test/debug this series
> on. I only have an LS1046ARDB. Everything but QSGMII should work without
> breakage; QSGMII needs patches 7 and 8. For this reason, the last 4
> patches in this series should be applied together (and should not go
> through separate trees).
> 
> Changes in v6:
> - Remove unnecessary $ref from renesas,rzn1-a5psw
> - Remove unnecessary type from pcs-handle-names
> - Add maxItems to pcs-handle
> - Fix 81-character line
> - Fix uninitialized variable in dtsec_mac_config
> 
> Changes in v5:
> - Add Lynx PCS binding
> 
> Changes in v4:
> - Use pcs-handle-names instead of pcs-names, as discussed
> - Don't fail if phy support was not compiled in
> - Split off rate adaptation series
> - Split off DPAA "preparation" series
> - Split off Lynx 10G support
> - t208x: Mark MAC1 and MAC2 as 10G
> - Add XFI PCS for t208x MAC1/MAC2
> 
> Changes in v3:
> - Expand pcs-handle to an array
> - Add vendor prefix 'fsl,' to rgmii and mii properties.
> - Set maxItems for pcs-names
> - Remove phy-* properties from example because dt-schema complains and I
>   can't be bothered to figure out how to make it work.
> - Add pcs-handle as a preferred version of pcsphy-handle
> - Deprecate pcsphy-handle
> - Remove mii/rmii properties
> - Put the PCS mdiodev only after we are done with it (since the PCS
>   does not perform a get itself).
> - Remove _return label from memac_initialization in favor of returning
>   directly
> - Fix grabbing the default PCS not checking for -ENODATA from
>   of_property_match_string
> - Set DTSEC_ECNTRL_R100M in dtsec_link_up instead of dtsec_mac_config
> - Remove rmii/mii properties
> - Replace 1000Base... with 1000BASE... to match IEEE capitalization
> - Add compatibles for QSGMII PCSs
> - Split arm and powerpcs dts updates
> 
> Changes in v2:
> - Better document how we select which PCS to use in the default case
> - Move PCS_LYNX dependency to fman Kconfig
> - Remove unused variable slow_10g_if
> - Restrict valid link modes based on the phy interface. This is easier
>   to set up, and mostly captures what I intended to do the first time.
>   We now have a custom validate which restricts half-duplex for some SoCs
>   for RGMII, but generally just uses the default phylink validate.
> - Configure the SerDes in enable/disable
> - Properly implement all ethtool ops and ioctls. These were mostly
>   stubbed out just enough to compile last time.
> - Convert 10GEC and dTSEC as well
> - Fix capitalization of mEMAC in commit messages
> - Add nodes for QSGMII PCSs
> - Add nodes for QSGMII PCSs
> 
> Sean Anderson (9):
>   dt-bindings: net: Expand pcs-handle to an array
>   dt-bindings: net: Add Lynx PCS binding
>   dt-bindings: net: fman: Add additional interface properties
>   net: fman: memac: Add serdes support
>   net: fman: memac: Use lynx pcs driver
>   net: dpaa: Convert to phylink
>   powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
>   powerpc: dts: qoriq: Add nodes for QSGMII PCSs
>   arm64: dts: layerscape: Add nodes for QSGMII PCSs
> 
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |   2 +-
>  .../bindings/net/ethernet-controller.yaml     |  11 +-
>  .../bindings/net/fsl,fman-dtsec.yaml          |  53 +-
>  .../bindings/net/fsl,qoriq-mc-dpmac.yaml      |   2 +-
>  .../devicetree/bindings/net/fsl-fman.txt      |   5 +-
>  .../bindings/net/pcs/fsl,lynx-pcs.yaml        |  40 +
>  .../boot/dts/freescale/fsl-ls1043-post.dtsi   |  24 +
>  .../boot/dts/freescale/fsl-ls1046-post.dtsi   |  25 +
>  .../fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |   3 +-
>  .../boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     |  10 +-
>  .../fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     |  45 ++
>  .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     |  45 ++
>  .../boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |   3 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |   3 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |   3 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      |  10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |   3 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      |  10 +-
>  arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |   4 +-
>  drivers/net/ethernet/freescale/dpaa/Kconfig   |   4 +-
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  89 +--
>  .../ethernet/freescale/dpaa/dpaa_ethtool.c    |  90 +--
>  drivers/net/ethernet/freescale/fman/Kconfig   |   4 +-
>  .../net/ethernet/freescale/fman/fman_dtsec.c  | 460 +++++------
>  .../net/ethernet/freescale/fman/fman_mac.h    |  10 -
>  .../net/ethernet/freescale/fman/fman_memac.c  | 747 +++++++++---------
>  .../net/ethernet/freescale/fman/fman_tgec.c   | 131 ++-
>  drivers/net/ethernet/freescale/fman/mac.c     | 168 +---
>  drivers/net/ethernet/freescale/fman/mac.h     |  23 +-
>  39 files changed, 1076 insertions(+), 1051 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml
>  create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> 

I noticed that this series was marked "RFC" in patchwork. I consider this series
ready to apply. I am requesting *testing*, in particular on 10gec/dtsec boards
(P-series). Since no one seems to have tried that over the past 4 months that
I've been working on this series, perhaps the best way for it to get tested is
to apply it...

--Sean
