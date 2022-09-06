Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDAA5AF158
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239039AbiIFQ7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiIFQ7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:59:01 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7EF7CB5E;
        Tue,  6 Sep 2022 09:46:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAoa7pqv/N4V9AYPtRA1cdW97gmP+FXhpvJ2OG2G0w8PnpoFfno1yAebAK+UeBVN0PvD2cBPS436WqgTM+M0GOCoQVz6v9RW0+jJrkvD/D2GvdMgqtYinYgu1CUMoze235xid2UnsbSjfu6HoVlZZdahfVi3hb1qPkLhhC7Rz/uaZnwRGBykmxUNL7a9GWY5oSdedahRWmknBBe3oATdnzQzTQijz1VkUx+L5Ie2iCRbhjIyE2Y3DEZlFNN5+HW/1d5AQmOKKPopEZaEiRWGBfjEKcpRdGgCkPZnghm306E7EZblN4oNcsK7TthNqaZ7e1fWvOLneGDT+GA9jzwaKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRIB86J131gnOhGHD+Ij1sVe6zGzgTWTe5TXHgz6gtU=;
 b=Hw/hffgdaygH2+UF1g7WKxRl7chs/MwQUNVgRtqKbtiTarcZ/F2kyzzkQpPPbXm+oDJpUUl/pwrJyBvTZ/6m2pHSIuIpLOjC8Uq9CYpKytNFUCQ++smn/J3b8jJDrDwwFTE8PV5MnRMw2V8ZV/gn/pGLHd4pwPek0hec0MGAcEYHw9r3boqmmCQhBd3ivXAnLyng5ntmIR+wW/nzI7nUTOwfYgtbUKEo/ZFeUlUJnGPYCCvFPN6Wn2lb6n1xoolH/a7hN4/MZm+MCCFM0hpMeaHIOELnT9BBHBMtklWTd/YNHne8N/px2bEUeHSNNm5kzGkKU8n4h22kD0d7vqX8SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRIB86J131gnOhGHD+Ij1sVe6zGzgTWTe5TXHgz6gtU=;
 b=LD7ljC2XNwfDDz5jFFGxrsdhkj2BL/BxKWqidEdmYJuMiV9ahFAEy4Mer0N8cJkeCuL9AHML9c6DWvmbO827MiMCJlOHbp9Dh2BKSwBwtWHG5T1GX9SdVclQZeMlQQOV+ungn4VRLjnDmX4o2H+UkFQRS15cAaBklmPCLVBra0obhy18Ba5rCkQaK6VpfmzLGOEHJiJiX5z5bfD4ci6t0dWAPguAg23rc96YyVVt2c4AYBJWbHxh4lN5jrW2ac79SHR7U9gjHebHtnpI58qPSbxa1xQIJYI789cQYLNEjsc4jSYQvWbLLY4jfFuJ8DBakHqmdsBYdp94YamCqbhDDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PR3PR03MB6555.eurprd03.prod.outlook.com (2603:10a6:102:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 16:46:25 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:46:25 +0000
Subject: Re: [PATCH net-next v4 0/8] [RFT] net: dpaa: Convert to phylink
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
References: <20220804194705.459670-1-sean.anderson@seco.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <06d42270-cada-eb74-63ba-c94168d41913@seco.com>
Date:   Tue, 6 Sep 2022 12:46:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220804194705.459670-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:36e::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5444bcde-ee64-49f7-055f-08da9027565d
X-MS-TrafficTypeDiagnostic: PR3PR03MB6555:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fEItl9MZf11uiqlZJyVFHvqtY8mJ4PIN2dbGNIY41l7aBhgWytwOFrH+NqgDTotYzxozOw9ys++MfBCVRrWPT2+DVSsEL2+i0SeU4FKtg0AslOKh0xSh8d5Rb++Mrr1/lokt/AaSD/6X40AZf2x2vxSYCTGBTKQMduevkAA4y3SOFuyfZYjlnXR2oGnGxGNQHJbpTj7hhZ0nADB67P7EfNC0/Nrblfvrj2PodIvTQfmLip0ilJUiW95ABJSiqa8kzjGEnXbupIC97TvZUVmotftREBE0OMJruH6jY942bLk7inJ2gyc6jN/zHgTD+aSJRIORrWX0+GCHRmISSx7wAy/NfFhvtZWCaOUF4LE/a3sKIKvFPSWaaSUQO1AQ99sZDPK1Ujv1iR7T/xenEFjP+1Jt3rmeu/E89Y2LCaYCq/HXOVSiCTrSLNseZ0IshyIgeORjO0N4kFwRDWoDolml2PaYTIXonaZbm+4x5wujE2TMfI0P7ANZH+ncaD8E3UHMlMBZXrVzK0/XcRZx1UYRJK98vCxNj/AhrjZr6khP1OUKzW4+MzDK+4BsxUELpQqXYmnStv2b6Fud5FnwGlddABSPh1Mj1joUst947PMQcJDRTRRfxMVTzvbRGjGvDJRGyAJ+m8/jemFVUH8yRDklkoJ9K3wpt7MI9IoFbnmeZht5o9M7LOR4uXC5eykmnsZjgFwyfe63dnQeyAm546bBDRj6MwY+zONEFI5M85Zz5aEpZJz+X5D6J0z/yfF53YMFwJeJpx6PgGVRpykPyvkvBSX3aOiIL+0gFKsIGbwNIlSCQhL2vm6LIZ2xqch2lF6cMttH16W+8k9KWYeyj1FNzXGf5FCd00aIVE3EnVm38AE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(396003)(39850400004)(346002)(66476007)(53546011)(4326008)(83380400001)(66946007)(8676002)(8936002)(7416002)(5660300002)(41300700001)(52116002)(66556008)(478600001)(6506007)(26005)(6486002)(6512007)(6666004)(966005)(186003)(2616005)(316002)(31696002)(110136005)(86362001)(54906003)(31686004)(38100700002)(38350700002)(44832011)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1lVcXFsT1F0S2UzOEx5Wmw4Mk1KTGEySHJxeHZLMHM4MlpaNFpiWXNNU3dW?=
 =?utf-8?B?aitHWmtkR1VqeHJ6a2ZPQzhuUHN5ampQNFN3UVJHRUpKYmNndmhoYWZwNXhi?=
 =?utf-8?B?VmdKa1ZkTGxaT2phY3VYYVdSRWtmMnpUQ2ZOVEJPNXhvWmxZaWxKZE1ISjR5?=
 =?utf-8?B?L0syeDhnZlc0THgxckpsMjZ5WG5XekdGOG5TWG41OVlLVHNTZE81Tjl6WFBL?=
 =?utf-8?B?UVBlS3haT0J4VVdMeFU0bnlQbmhZTGVFSTJUcUlQZXJWa3J3bnpGN0N6UjRS?=
 =?utf-8?B?WllzRE1aQ2RPOHhxZm0vSkJreE41Qis4SnBNOGhObDZiQkd5cVg0Q0x0eGlz?=
 =?utf-8?B?b3BTaDJHMk03MjFIb01CamkvNkhIdEhobGR2UzNGcjZJT1hwcE5aTTZpWGZy?=
 =?utf-8?B?VXlEc1hLVVlIYXVZZU11TlR2MlI1Q1l4eXhNZktieDFqakw4Y24xa3lGNnpV?=
 =?utf-8?B?b09hcmNHZlQ0b3dYdTVzK3p1WjdSOFg1ZGMxUXc4akxMOU5qTGh3VUtNTnRs?=
 =?utf-8?B?dXhoMHJsMFJZaWJiK2RqeGY3MEN2OFMwdCtIY2xZMWErUWd4ZXhBVkVRY1px?=
 =?utf-8?B?R3VCOGtkNmpDSjZIVERvTlE4K2xHUmhXdTRNR1dBL2xEOVpSZEtwZHdDeG1u?=
 =?utf-8?B?ZnB4bFJ4OGRjdVhmQ3pOWDVIRWNrVEEwNFBpMlJ6UUlod1U1THloZlg0UFZT?=
 =?utf-8?B?UVZESUJQNzBoYzlNMzBCN1hTT2VSUlpTbkdwTlp4cDZuam9IS0pmREd4RVZw?=
 =?utf-8?B?QzhkM1ZXcDNpWHpValpUZlVaNFVSaUlrOG9qUEl1bnNLTHYwU0tQbGIwMzRj?=
 =?utf-8?B?QmtWUHphZU1RSzhBeGExcjRTSlJPWWRjNEJQOFY5WEpqMkdxWFRSTUFXTGtO?=
 =?utf-8?B?TGwrTjZENFNzNkRhc045TDAzK0dNRlk2Y0thWjhTUnBKb2RkeTRSSUxCOEJ0?=
 =?utf-8?B?RlZFc1NtbjM1ckpKNVRxc1lNQy8zMGRFM1VOSnYxOVh1eENmazNKbU45MEtN?=
 =?utf-8?B?SXhhM2tEck91VlF5N0l3T29oNHVDRWRpN2NGSHVzNVpFUnc0V294MDN6QU5M?=
 =?utf-8?B?b0dqUHUvcS9iYTVSbEhGSTU4SjRrZ3JhRzhUc3h5UXdnUFBVczRxK3lZL2ND?=
 =?utf-8?B?cDJGVktMSmgxNkRweEc5SGZvRkV4aG11YTl4eTh3OGZCdkVKSzZYWFE3TlFZ?=
 =?utf-8?B?c1Q0emNFNWtTbGdHUEkycXNHR0JnT1VSY3crMi9Ca1Fyc0FTaExObDljb0kw?=
 =?utf-8?B?K1RUTEJZTlQzVjVWbzhlZjZCQ3FHMUcwcHorWmZXV0V4anFKSkRtaE9GZUR1?=
 =?utf-8?B?L3pTM1d0cGpoOC84KzlXcmY3Z0ZVaFc0U2lLc1hiRWs4S2ZHZlBXUzFZaUJr?=
 =?utf-8?B?Y09mcHVCZVRpR005cXdEZHVaYWpEU0NyY1kvcTA4VktOSmFvVWVvSkNrNkc1?=
 =?utf-8?B?UndZT09hZUFsekVNamE5ZzVScEtqa0tpYkxsNGUydjhCc2NRYUxGMXlrNFFU?=
 =?utf-8?B?RGJ1Y3lyaDRmZTBMWWdaeFVaUUh6WWlCaHE2czVCRWlkdE4veHFkcGdtZm5Y?=
 =?utf-8?B?UTFhZVhURUtrNlZWZkpyM2xLTnZlSC8yM1E4QlVSblBaOVJoSlZDdEFXTTVP?=
 =?utf-8?B?endTemJNbWI5UFFTV1kxdTg3K1BycXVRbHRWU3ZBZlV5REJWelF0cDBqdGtq?=
 =?utf-8?B?bkYwa3FIdFJpL1lWbFJjbzFwbXFwWlAybHVlZjNWTGw5aTU3UzNYTW9JTXY0?=
 =?utf-8?B?V1NjWmtIT2IvWUhjL2s3b0xnQVB3Y1htNzVDK1BPa1E0ZHVnbVRLR2UzTWkx?=
 =?utf-8?B?SWtnVGVnM1VnYjkyZmdaTFdUMS9OdjRaYU1VN2xNb3g3M0krYTViS3VGbmlp?=
 =?utf-8?B?Q2pUamRtRTlZZ0dVb2M3MHhrWkdtSlQrbENRZWc1ZmkxUFZQbU5mRWJBUlNq?=
 =?utf-8?B?czZpNXBQNFVzNnRUR1VERnRBNkNsSExhQithWXVpaGM3dGJxVEhJcGZpRHAy?=
 =?utf-8?B?UWdhYy8vQmFFdURCNnZ6YTFNREt2QWMxVzlhcmp2RElHQmpxVk5kRlZiZWMz?=
 =?utf-8?B?SlJ0aFhTVFFxNW4xL2tKcUdCMEpIOXNRRXBPTlFHSEJJdkxXdTl4R21FTmtC?=
 =?utf-8?B?VjYwQ2ZjUGtybkZKVkRMMWw1dkI2ZHJRVTRuZWwrVUFtaWpScnlTOEVPbVha?=
 =?utf-8?B?WkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5444bcde-ee64-49f7-055f-08da9027565d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:46:25.5126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jiS/3f+w7z295g3HlQhCivJY5xCAMnAlMaKEUTkwDn+O+SRmvE4z15leSQBjP6NsVtJxR21HjIs27/e9Yftn3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6555
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/22 3:46 PM, Sean Anderson wrote:
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
> This series depends on [1] and [2].
> 
> [1] https://lore.kernel.org/netdev/20220725153730.2604096-1-sean.anderson@seco.com/
> [2] https://lore.kernel.org/netdev/20220725151039.2581576-1-sean.anderson@seco.com/
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
> Sean Anderson (8):
>   dt-bindings: net: Expand pcs-handle to an array
>   dt-bindings: net: fman: Add additional interface properties
>   net: fman: memac: Add serdes support
>   net: fman: memac: Use lynx pcs driver
>   net: dpaa: Convert to phylink
>   powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
>   powerpc: dts: qoriq: Add nodes for QSGMII PCSs
>   arm64: dts: layerscape: Add nodes for QSGMII PCSs
> 
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |   1 +
>  .../bindings/net/ethernet-controller.yaml     |  10 +-
>  .../bindings/net/fsl,fman-dtsec.yaml          |  53 +-
>  .../bindings/net/fsl,qoriq-mc-dpmac.yaml      |   2 +-
>  .../devicetree/bindings/net/fsl-fman.txt      |   5 +-
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
>  .../net/ethernet/freescale/fman/fman_dtsec.c  | 459 +++++------
>  .../net/ethernet/freescale/fman/fman_mac.h    |  10 -
>  .../net/ethernet/freescale/fman/fman_memac.c  | 746 +++++++++---------
>  .../net/ethernet/freescale/fman/fman_tgec.c   | 131 ++-
>  drivers/net/ethernet/freescale/fman/mac.c     | 168 +---
>  drivers/net/ethernet/freescale/fman/mac.h     |  23 +-
>  38 files changed, 1033 insertions(+), 1050 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> 

ping?

This will not apply on net-next/master, so I will resend sometime soon,
but does anyone have any feedback first?

--Sean
