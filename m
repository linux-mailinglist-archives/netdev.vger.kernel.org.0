Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D30F5726CE
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiGLT5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 15:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiGLT5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 15:57:06 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140047.outbound.protection.outlook.com [40.107.14.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF28C0;
        Tue, 12 Jul 2022 12:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fb5Lxh5+n6F2aHtU0tCEtW44Csfp5uoh4cOaVrk7mtHe4TVDQtvLcsfBoMCCaXoM83jxL3H07dvkojsKX+tsH7BrTepWKKQ/dVAcFuySke2CEm7fXRA4/d0Exr962H6xM+S3SGcs1o8c8DLZ4RkZk672q3NeDUD6xjPss3/apG+PPAL1/5cGA2e2QNFKOABJRLWoG9XXf0LKG85UOYKVbjNlJs3ZYmzz+AIqMJt4AFMx2/Pe29iO9eiRRNMsQOmNN1VTsLLwQA3QAybP/tVpeZi/g0HYh/Es5eYEOuuRtbwYX4FWGp2pTTIw9jEN+N1iv5QoNZ50806lANVJH7jFiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzTreoDUskrcU0OOOwhoigV/Zk0wc5Pw9j3vPl6mLds=;
 b=SS9apZcqbZJbB5mg9xpShlnnEqJGlxzCIVZazQqwDq3Nx1ePBdQQkv9rlLka5scFDkhRc/ARuBzil7TLsmphZ0jI/Jh+FsaKhoZbgEb8EXmVxRjCh2D1c9KB9Ezgkut1uwg51dtF8ze2Je7W7AedsG+X7un/F0SZe4ZWEdhQNgjsTX3RJVY0rWDQ5rElsUlKaANsP/+uKpGBCCfVvJ9VLOiv8wAj17VhzGe/UCgZnDPxWcfJKJu34nX+uiMy2lLDT4+AS71PST0vn/ML8YOWiRnkDI1FaP3BvHyJr6zchOm/8F1NDut/VGGbFysfxFYLPLJVH0hprqZXFQUg9JfRuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzTreoDUskrcU0OOOwhoigV/Zk0wc5Pw9j3vPl6mLds=;
 b=1pfcJ81UJSYWFbQN9roKO8sfhvuO9eqjHJZ/3qcmuIh9KlNJch+XpLPZlZyXBpA/4pdlt19wvCdxT/HSez5aYQE2naxFcQZqJ92s2rnmrQKd+tk0767q95+3HQ6sFsh5spGR2Ku2j+WYS50D+RVLGaO783KNzAt+8GJ1EJPWixqPaQx8QPZp8jFxQCPFIU11eSqNu9QwWuaabBfH0Isyi9/yojN6qVOJgHSGbFbOGDiZV+FV0o05Ky0WeOAY1qBWdikVcVnPWpk5ocE4e47U72ZnapKAoe3KjeRjizHEsvGi1vI7nr+REagpS+VGd1eyXLvO+xps3mjG6rOaYib+Hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB3536.eurprd03.prod.outlook.com (2603:10a6:803:29::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 19:56:57 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 19:56:56 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next v2 03/35] dt-bindings: net: fman: Add additional
 interface properties
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-4-sean.anderson@seco.com>
 <20220630160156.GA2745952-robh@kernel.org>
 <e154ff02-7bcd-916a-0ec4-56bf624ccf7b@seco.com>
 <20220712193651.GL1823936-robh@kernel.org>
Message-ID: <5d3554fa-3fff-2075-96ae-cefa56006884@seco.com>
Date:   Tue, 12 Jul 2022 15:56:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220712193651.GL1823936-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR18CA0030.namprd18.prod.outlook.com
 (2603:10b6:208:23c::35) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d398872-3e59-4a8c-d0b1-08da6440acd1
X-MS-TrafficTypeDiagnostic: VI1PR03MB3536:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YhW10pjAOwQMIhDJ2Mwhnnuc1JyuvSa0WSK0ZEeRGZFqTKAZBMqqpWOu/6szaejjNGQU9OulzhTSfBeY+q1knJZt8NXd+/j0H1r36FMoVNkYhdoTTkphZ0IvoOTFFGfmPApkX2dYFKe95Kw9VdC99p+ALZPYwGPbZgo3W6b6sNZHYNnnTNzCtGG7dzLRFt9WHmgnWhPlNZrW+etOvohv8T2PN05N+5nPknj+55hz+brZn0bgBL2QfDmeKiZyzHsdOJcblYqEORY6AQs2HMGYymRVme+N7rmyXtaQrmIWGi2AhbD5Bbud8fHt5SddOV4IWzb/g/clSR5+KdQb+wI1Q7XwdA11iTnysHduJW0leqFDPbKIEvbl2es5kal4tI1f6leAqjrW3dYzVfQ7y6BwlTftSOdlP+iyi4QgTXfviDBPDItnZo5WhoXMSLPlrQpaxHIC9OGOcnwfJvdOOPqnk+Yk1EHqVpF8SMc3f0YjESHPrRxdsEDRhdPnBS3kZpIZRd4QYlVunt6M133z3hdZwhjKxZJC3p6tvb7vN0DWyh07Nx8im/izz/hgflymu6SxKTPpv8mTNRqmgj3UjUgh/cWgqgXDhhxRW3AZb2RLa/LoV5lYZmf84mWSLNdCySoZSuzYzkxQfxiIWuzS00qT1ESwm2E0shpFWyfgK0EIFE1uI3K85kwoIlRiIssHE94I48B/J01rDm4UttpqLsR+vJI8xJSXX/0Ga3GKlA8KnAzGKpaex8SGTAjzMVORzL6SOb5Pl/qmRIjLG3MoSdoFb1vzjUgyA0lzk8RzMJuUUiypMkY3qqcabw5KFRLDPw6OWu3siLxHfrKf5RyR6b0HynHo97w/udtwCNSDI1qR+U4m5YGmKP3lmIlfJrb5BH+W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(136003)(366004)(2906002)(6486002)(478600001)(38100700002)(31686004)(44832011)(186003)(36756003)(83380400001)(86362001)(316002)(31696002)(54906003)(4326008)(7416002)(66556008)(38350700002)(5660300002)(66476007)(66946007)(8936002)(8676002)(41300700001)(52116002)(6506007)(53546011)(6512007)(2616005)(6666004)(6916009)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnMwYXE1VjhuL3pPUy92TWdNWko4Ym5wK2s2TU4yUnVjYTI3djBRZDB0S3F0?=
 =?utf-8?B?V3VVY00wajFvaUpUTkV0eXZSZnc1YlFwaVh1Zkg3NmlXcmxtanl5aXhGS1Vu?=
 =?utf-8?B?dVhnM3RjK0hOcHd0UkU2UCtLUDdLNkNQM2dyaDZnOWNJTDFxZ2FlbUEvRkdD?=
 =?utf-8?B?bTRzbm96OFpZcURLZTZLSFVYNnYvOE4wSUUvbGZkZXhRZGdzcmgxeHp0YmNW?=
 =?utf-8?B?bCs3bmpwa0g2YUZGZlZTSmEydWg4dTZyQ29HOXdRSElDdDBKaXdWQ05EUldm?=
 =?utf-8?B?TVlsSG5vMFViSnpneUFreUJWR0t6SzlFOGVQd0phZ3J0elNoT3VXWnQ5ay80?=
 =?utf-8?B?N3MwaFllZ09WUC9HK1RaV3dDbkJJaXhtUzF4eXhwK01RUmtsOFFBTzQ0b0tt?=
 =?utf-8?B?eVFhcHRleDlwZENNa2ZGOVoxcUE1WE51dXI3aVBqU2VET1duUGNZQng5aEJZ?=
 =?utf-8?B?SUE3M0ZnMEc3YUhQQU9WOVpKMkM3RmZnVHNSNmIxRzhrMnJsR1NQNHR4OXFQ?=
 =?utf-8?B?SVhNM1pqckZMRzJLeDhOc3lZSk9XeHBLTTh3akY5djU4cCs1M010aXQwU1o2?=
 =?utf-8?B?d0JXaXdzYXNocUQzYVdrSXdRTFpLY3JrdG1CTVQyMTBFbU5malg0cDRQQ2U1?=
 =?utf-8?B?R056YjZHL2hJOGxBTjY0ZDZFSEoxK2NGOVFqY1FBQldZV1prSXFMOWZ3ckdz?=
 =?utf-8?B?OGgxYktXbS9yMmJPOEdKa3h3dDU2TzBGNHZkWndlaElmdFZMV2JnUWcrdkdU?=
 =?utf-8?B?ZVo1aitsL21aR040N0ZxczlKVHNBdWwrYmNsa0Zpcmdoc21BbW0rd29WSUlp?=
 =?utf-8?B?TEs3eFBSZjlHTC82bGZ5V21Sd3o0T3ZLNExVZXdBQzNUTWxkTjZia3V6T3dT?=
 =?utf-8?B?MG51MlZCajdJQ0xaQXZ3U045YTh0TkQ1bGV3a2RFZk16SjF1NTgyVmQ2RERy?=
 =?utf-8?B?ZmZBb0hFS09ZbnF2d0R1Q3FENHowM2ZSSXJ1ODRKd1JnaG9kNi9nc1Zad1Ar?=
 =?utf-8?B?TWNMc2gvN2VSL05CTkdxb2FKdDM2U0ovaURRWWJKbU5WZXlvckhtS2srZk9Z?=
 =?utf-8?B?OVdOSlJEanVXWmp1SGpscmtEQitkcDFvMkk2RTZxQSs5V1g0Z21RUzZwZUdJ?=
 =?utf-8?B?QjB6T0o5WHZUWnlOdStOMVdFd25nVWxUZVlJTzNLRlE4M3JOMUdxSFl6U04z?=
 =?utf-8?B?UEFOdjdwMzZXZHFxc05qQUdHRGlKWHM5VkpBcUFTc2hVOGtYUCsxOHVWd28w?=
 =?utf-8?B?a1liaWRWcXJSWTVLRHBDTkExdkhobHJkeGxSdll6VjNEajkwRFNQS3R2UWVT?=
 =?utf-8?B?MXBsR2wxdTFNSU9zSGVHVGNzMHB2ek9ScHV5WVMvUUVqTU9sZDk3UE9JUG52?=
 =?utf-8?B?OFJqZnRBbW90ejBPcGdaNFg3Q25JUmE1VFNOUndZbm02S2tBaU1XNmQxeHYz?=
 =?utf-8?B?N3ZFRHQydG03T0NjdE9PNm9mSk1OSGpTUS9YUlVnQVk2Q1VNUEo2WHQ3U1Zm?=
 =?utf-8?B?K081djgwcnc3NWV3akExaDJJS2oyYllwZkhnbUdoTkFyM1JDamtUUUZWSjJr?=
 =?utf-8?B?UFVQTDYwTE44ZjNwYTU1NldBSThLdGdMYXplSE5Fa1dESm1LbnBtU3JIb0dj?=
 =?utf-8?B?ZlRaTWtzWTVjYWZDQ0RENTcwajk0M0NaSnd0MkRySFZJRTVFeHdoU0RDa1hK?=
 =?utf-8?B?d3VMUnJLVUxob1RhUFBKMjZjd1Q2c2hCMGFyN0tvNzdOSFQ0WG1QQ1hUNVc2?=
 =?utf-8?B?ZllVZmM2bGMzOEF4eHZoMHFoV1ZQbkwxdE9rQmtrTjlTWXFxU2c4M0dkNlRx?=
 =?utf-8?B?V1IwQkt4TzIxVEVwRjI5NzNpV0hjN1VFR2tWdDNwcWl4ellQWFR6QXdwcUdi?=
 =?utf-8?B?QmlXNFF4L3hpeHNQTUNGY2VCRTdXcEdmM2tjcGFNWisvWlRKeFFadlcvMllu?=
 =?utf-8?B?R0pEaU10VVFZS3l1YUpZOVBxUU5mWFZhcHVucUpHU2VuaFB0cmVNY0F0MFRE?=
 =?utf-8?B?UlFBWXdRWXp5QWRKdEM1QW1rRXU2NS96VkhybC91NFRkZTM1eVVubzB4RlBv?=
 =?utf-8?B?MXhIYVBUM2g4VGJhcmw1Nk5DaHhiSGVndm56TDBDVkFvYUdoYnd0WUM0d0l2?=
 =?utf-8?B?eGdqbzlxMFZCNE80ZEZyeHN4Q28vR0hOaGFwRTV5SVVpTzY4TXdnNDduT25Z?=
 =?utf-8?B?OFE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d398872-3e59-4a8c-d0b1-08da6440acd1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 19:56:56.8025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+j/0KFSRfF5mzUdhmMvNyEF/6sL0I2eCHFpscZPAyixtH4e8GiAYuTlQG9ANt1rqR+a6I/MheEndyRZNULcQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3536
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 7/12/22 3:36 PM, Rob Herring wrote:
> On Thu, Jun 30, 2022 at 12:11:10PM -0400, Sean Anderson wrote:
>> Hi Rob,
>> 
>> On 6/30/22 12:01 PM, Rob Herring wrote:
>> > On Tue, Jun 28, 2022 at 06:13:32PM -0400, Sean Anderson wrote:
>> >> At the moment, mEMACs are configured almost completely based on the
>> >> phy-connection-type. That is, if the phy interface is RGMII, it assumed
>> >> that RGMII is supported. For some interfaces, it is assumed that the
>> >> RCW/bootloader has set up the SerDes properly. This is generally OK, but
>> >> restricts runtime reconfiguration. The actual link state is never
>> >> reported.
>> >> 
>> >> To address these shortcomings, the driver will need additional
>> >> information. First, it needs to know how to access the PCS/PMAs (in
>> >> order to configure them and get the link status). The SGMII PCS/PMA is
>> >> the only currently-described PCS/PMA. Add the XFI and QSGMII PCS/PMAs as
>> >> well. The XFI (and 1GBase-KR) PCS/PMA is a c45 "phy" which sits on the
>> >> same MDIO bus as SGMII PCS/PMA. By default they will have conflicting
>> >> addresses, but they are also not enabled at the same time by default.
>> >> Therefore, we can let the XFI PCS/PMA be the default when
>> >> phy-connection-type is xgmii. This will allow for
>> >> backwards-compatibility.
>> >> 
>> >> QSGMII, however, cannot work with the current binding. This is because
>> >> the QSGMII PCS/PMAs are only present on one MAC's MDIO bus. At the
>> >> moment this is worked around by having every MAC write to the PCS/PMA
>> >> addresses (without checking if they are present). This only works if
>> >> each MAC has the same configuration, and only if we don't need to know
>> >> the status. Because the QSGMII PCS/PMA will typically be located on a
>> >> different MDIO bus than the MAC's SGMII PCS/PMA, there is no fallback
>> >> for the QSGMII PCS/PMA.
>> >> 
>> >> mEMACs (across all SoCs) support the following protocols:
>> >> 
>> >> - MII
>> >> - RGMII
>> >> - SGMII, 1000Base-X, and 1000Base-KX
>> >> - 2500Base-X (aka 2.5G SGMII)
>> >> - QSGMII
>> >> - 10GBase-R (aka XFI) and 10GBase-KR
>> >> - XAUI and HiGig
>> >> 
>> >> Each line documents a set of orthogonal protocols (e.g. XAUI is
>> >> supported if and only if HiGig is supported). Additionally,
>> >> 
>> >> - XAUI implies support for 10GBase-R
>> >> - 10GBase-R is supported if and only if RGMII is not supported
>> >> - 2500Base-X implies support for 1000Base-X
>> >> - MII implies support for RGMII
>> >> 
>> >> To switch between different protocols, we must reconfigure the SerDes.
>> >> This is done by using the standard phys property. We can also use it to
>> >> validate whether different protocols are supported (e.g. using
>> >> phy_validate). This will work for serial protocols, but not RGMII or
>> >> MII. Additionally, we still need to be compatible when there is no
>> >> SerDes.
>> >> 
>> >> While we can detect 10G support by examining the port speed (as set by
>> >> fsl,fman-10g-port), we cannot determine support for any of the other
>> >> protocols based on the existing binding. In fact, the binding works
>> >> against us in some respects, because pcsphy-handle is required even if
>> >> there is no possible PCS/PMA for that MAC. To allow for backwards-
>> >> compatibility, we use a boolean-style property for RGMII (instead of
>> >> presence/absence-style). When the property for RGMII is missing, we will
>> >> assume that it is supported. The exception is MII, since no existing
>> >> device trees use it (as far as I could tell).
>> >> 
>> >> Unfortunately, QSGMII support will be broken for old device trees. There
>> >> is nothing we can do about this because of the PCS/PMA situation (as
>> >> described above).
>> >> 
>> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> >> ---
>> >> 
>> >> Changes in v2:
>> >> - Better document how we select which PCS to use in the default case
>> >> 
>> >>  .../bindings/net/fsl,fman-dtsec.yaml          | 52 +++++++++++++++++--
>> >>  .../devicetree/bindings/net/fsl-fman.txt      |  5 +-
>> >>  2 files changed, 51 insertions(+), 6 deletions(-)
>> >> 
>> >> diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>> >> index 809df1589f20..ecb772258164 100644
>> >> --- a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>> >> +++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>> >> @@ -85,9 +85,41 @@ properties:
>> >>      $ref: /schemas/types.yaml#/definitions/phandle
>> >>      description: A reference to the IEEE1588 timer
>> >>  
>> >> +  phys:
>> >> +    description: A reference to the SerDes lane(s)
>> >> +    maxItems: 1
>> >> +
>> >> +  phy-names:
>> >> +    items:
>> >> +      - const: serdes
>> >> +
>> >>    pcsphy-handle:
>> >> -    $ref: /schemas/types.yaml#/definitions/phandle
>> >> -    description: A reference to the PCS (typically found on the SerDes)
>> >> +    $ref: /schemas/types.yaml#/definitions/phandle-array
>> >> +    minItems: 1
>> >> +    maxItems: 3
>> > 
>> > What determines how many entries?
>> 
>> It depends on what the particular MAC supports. From what I can tell, the following
>> combinations are valid:
>> 
>> - Neither SGMII, QSGMII, or XFI
>> - Just SGMII
>> - Just QSGMII
>> - SGMII and QSGMII
>> - SGMII and XFI
>> - All of SGMII, QSGMII, and XFI
>> 
>> All of these are used on different SoCs.
> 
> So there will be a different PCS device for SGMII, QSGMII, and XFI 
> rather than 1 PCS device that supports those 3 interfaces?

There were always 3 PCSs. There are two things which let the driver get
away with this. The first is that the default address of PCSs is 0, and
the boot hardware would enable only the PCS which was necessary. So you
could pretend that the same PCS would support both SGMII and XFI. In
fact, you can still do this, since the phy driver I add later in this
series is careful to duplicate this. Eventually, I would like to set the
PCS addresses so that both the SGMII and XFI phys will be accessible at
the same time (removing the need to enable/disable them). This is why I
have allowed for a separate XFI PCS.

When QSGMII is enabled, there are 4 QSGMII PCSs on the MDIO bus of one
of the MACs. The base address is, once again, 0. I believe this
overrides the SGMII PCS. When configuring for QSGMII, the driver would
always write to all QSGMII addresses. The MAC with the PCSs on its MDIO
bus would configure the PCSs for the other MACs as well. The other MACs
effectively made dummy writes (since there was nothing listening).
Unfortunately, this only works for writing registers. In order to get
the link status, we need the real QSGMII PCS.

>> >> +    description: |
>> >> +      A reference to the various PCSs (typically found on the SerDes). If
>> >> +      pcs-names is absent, and phy-connection-type is "xgmii", then the first
>> >> +      reference will be assumed to be for "xfi". Otherwise, if pcs-names is
>> >> +      absent, then the first reference will be assumed to be for "sgmii".
>> >> +
>> >> +  pcs-names:
>> >> +    $ref: /schemas/types.yaml#/definitions/string-array
>> >> +    minItems: 1
>> >> +    maxItems: 3
>> >> +    contains:
>> >> +      enum:
>> >> +        - sgmii
>> >> +        - qsgmii
>> >> +        - xfi
>> > 
>> > This means '"foo", "xfi", "bar"' is valid. I think you want to 
>> > s/contains/items/.
>> > 
>> >> +    description: The type of each PCS in pcsphy-handle.
>> >> +
>> > 
>> >> +  rgmii:
>> >> +    enum: [0, 1]
>> >> +    description: 1 indicates RGMII is supported, and 0 indicates it is not.
>> >> +
>> >> +  mii:
>> >> +    description: If present, indicates that MII is supported.
>> > 
>> > Types? Need vendor prefixes.
>> 
>> OK.
>> 
>> > Are these board specific or SoC specific? Properties are appropriate for 
>> > the former. The latter case should be implied by the compatible string.
>> 
>> Unfortunately, there are not existing specific compatible strings for each
>> device in each SoC. I suppose those could be added; however, this basically
>> reflects how each device is hooked up. E.g. on one SoC a device would be
>> connected to the RGMII pins, but not on another SoC. The MAC itself still
>> has hardware support for RGMII, but such a configuration would not function.
> 
> A difference in instances on a given SoC would also be reason for 
> properties rather than different compatible strings. However, we already 
> have such properties. We have 'phy-connection-type' for which mode to 
> use. Do you have some need to know all possible modes? I think there was 
> something posted to allow 'phy-connection-type' to be an array of 
> supported modes instead.

There's no need to know all possible modes. I can drop this if it is
preferred to use phy-connection-type without other checks.

--Sean
