Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6875157D00D
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbiGUPni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiGUPnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:43:23 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70057.outbound.protection.outlook.com [40.107.7.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4538988F0B;
        Thu, 21 Jul 2022 08:39:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LS3kCtJVQGI5Rov6oz6A7g/z7P1DPlGEgzc7SFGWVLC2Z2bdm8uinjHzEsuNA/ZJxZLqPpPxY9Fryu5w4gYSoibUdBCmcs98j/3PG9QqgwyFM0P3LiEr7PnI8ICZ5pmqp0xfCI6JsjWmdCyNNxkqoNvNppJgxHOdKW7bq3lRQh4eWHJ1mk8oIy/0fhY+7xW4vRo4wTQy9UyhAd04/RR2mMMa0G1EOwe+p5Q/Thu6aP44G1bq4hvZPFHR1eHI4LV4X5Ig2hBAfWoqqIDgU+bjc1EKOQBMqGogxZWD2tM5L2v12tYHkvWHq0edLTv2wWgQvn2FAHKhxSfTWTfyjMMgGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOlq98c+xkxD3rKU5H8w750qcGTz3dFQV0ojgQwbWUI=;
 b=YPRg0AMBXCLsjLOZceEs4rQuSfYAbJDOfCo+92sYeF4B7WQHCYip45iK+2Xxl2t9TmR+BMFpNTgzAA9MCyjnD34NA93b7eFcnP04eGjZcYKINip5yf0bSX0MN90RD66a448zzKtFUyFToyKVdqzo1yQYVr/byWRe0wVdGY/jTWGeLtY/4wMmN9CrqEUgUHVZeFUiCjCvk6lSwOLN6DN1Jc3SqXRJN5rmu6eK3vnef5ssvteSqiBokUsofv3hmOuReU3OMQdJiPoVlrgZHbIVqij/SFdhbaZ9L5F02OAR3ymHKjrA6lwMXuHTxVuF7H3xV7BNNSZDsmtykNCZOIvjdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOlq98c+xkxD3rKU5H8w750qcGTz3dFQV0ojgQwbWUI=;
 b=H7aqYSSuwec1xBA9iGFQ49l/ReAbSdCdPl1UId29T0S6Juynp3kj0yp5tkJ/9RjY/Isaqpqj5HYwfjn4Gy2k+ciOWI5iUFMNKyx90Lz3hIGsC4RZEjyHsdbo13fyX9VhM4FjosCFQp6yOyVgk+qQzlCvxlnJBOqV8Ynjt5gpTnluZsIrC2kpMlMH89bJGvpohT7s1Ytvp/5+sgYvjdC7+utQ8Bj2j/BL+CZrDAyVPTgnpRcPKL0Xcd1ENHkfAJkbjtVN82cMJhmm2e4Vti5VAfzaRc5yQmhoPoUWBXWFg57hieSrQcYmCzcEgbMgQnbg6/t2S/iBp21g7bap1UsYzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR0302MB3280.eurprd03.prod.outlook.com (2603:10a6:803:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 15:39:15 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 15:39:15 +0000
Subject: Re: [PATCH net-next v3 00/47] [RFT] net: dpaa: Convert to phylink
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <VI1PR04MB5807612C5CD9C5976FC92C4EF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <7a3556b7-606e-a1ce-e52a-2b3bc9effeb8@seco.com>
Date:   Thu, 21 Jul 2022 11:39:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VI1PR04MB5807612C5CD9C5976FC92C4EF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:208:d4::26) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b18ead1-ca3e-4498-629c-08da6b2f2a72
X-MS-TrafficTypeDiagnostic: VI1PR0302MB3280:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hum1FrEVSGcEkxr+3vifaUbyALQI3G+8P+p1osN2Au3WkieLZ8HZ7qVTzzbTdOe/YFJAEIBEfheIKbKS61mQW3fbXTLObioRF8tBER9XfhjLmDVNvksYIDiYRfQgC0x0UKZDvHNdO1xTBBpArwsgOd61A90liYjNnNPazHtaclHbW1ww70tEaBJtD0EyOjHv+t2pxGjd6Zke8T+g0Yos8t8vdHcuGpC+X37yihf4YhxEGyBCLgpohyXmzL1w81Rg/H0PwmgIcnnD7FebVZVlasWMmLylDugZjPfQMnRYPCVQiPbN0UlKmVfjtKYjfk4DXZ5AoDBFGJBpe2G0BRETc04DjqbMC5ceTSZpjcibP8SnV57RmwSle4LQ+pjKFrUvm4zPBoyO/MFVDmTorxBK2AvkkgK4fKi+lXVmlayR/9EQ9IGiSoq+FPLb+UJ5cdmCkvofRYqwaAHj3bLuC/7AXBPtivYHARoT4UsK/YOhu9zpPfd/oMzLeCBpdSicYxgMrn3z1Pa3oQm+gfBTnYtkg6I5TiAED/Y86w9Oj8WcxGqo3vn/KXsiy58k+sGyFYcp1A0Vko93H0TZycNNmYST9oZ9ASofYawD+8mnGgeLluNRedL3VBEcEGocf5AWOSJuZ01vXWuO0O8auliV+A8cXqjhU0Ij6TBXYxt6nY5gujvdVV91PmJPQ8Wftaw3c3Kr07a0DTHuRSQf/J2TGV6c9LRXcmwqgIngv+DYrezpSif8a9x7dpC02DqgJgGDBYXrnbE2H/fwZqu5JaEry6Zx7H10+QCEc4V4nDcCFN0c1ovX36yt0+A/M7vQZWBJXHKTWvOEq0MFsYaf+HaOr5UmM7ck2PT7+HK4+n6yxkq57R38bCMf++0Fv51XBtikws8vQ2CQOa7ExxoxmFjokDoGkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39850400004)(376002)(136003)(38350700002)(6506007)(52116002)(36756003)(53546011)(8936002)(5660300002)(7416002)(30864003)(44832011)(6486002)(316002)(26005)(31686004)(966005)(478600001)(2616005)(41300700001)(6666004)(6512007)(31696002)(86362001)(83380400001)(186003)(2906002)(110136005)(66556008)(66476007)(8676002)(66946007)(4326008)(38100700002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXJEL0ppT3NDTTl3TG1oUkhYRHdCcDhOSEpXZjk1NDUreDEyQ3F5N09QR0R0?=
 =?utf-8?B?SXdvMTBFblVQUDBlb2puRTBycnJoK3VFRmMwWW50eTgyS1FFbXVIK2hCa0pt?=
 =?utf-8?B?TTVHcUhrWUV2RVBlbU5BM2VJdUJiWFl1djEwN21kMWRDYjU4QXFQbkR5U3dL?=
 =?utf-8?B?cTdKaUx5TDFnUXMwRGJqNnVpWkh0d0hLdURvM0VQczUrYVFGdnBaVW1jbGc5?=
 =?utf-8?B?eks0R0ZVWlJxRVJUQXI5UGJLNjZFMzlWM3Azc3pYSmpPbkR3c09tdlpnMWpP?=
 =?utf-8?B?RFdQeWRNZTdtVG5QQ2VHNGZOUVNVZCt0QWhiNU9WRHBDck9hL0t3cncrckJC?=
 =?utf-8?B?ekVrN2o3RnNCSVZVaDBZWVFqQUp4YUxYTTRtQVZDSGFGK3VRZzNDNUZTYnda?=
 =?utf-8?B?cmxRcm9GUTRvZ0Q4blNKUU9TaytRY2tTLzlVNld5djRaeWpVQTV0RFlCOE5T?=
 =?utf-8?B?NFpBT0psSVR2ZkcvU3FKWmhKQ3BycTJHSjNQSFdVc0NyQWUybjZwV25BLzVD?=
 =?utf-8?B?clFySS83Qk5zTkRxZDUxMnNjNTZhNFlnU0VFeFYvb2JlR3dKZWIrUW5lM0ph?=
 =?utf-8?B?ZkhWaWVFMkxrcHNGSlZZTldvSlJpRk1uSXB3TlRwVXZuVnpjRmhTUE1kbEp0?=
 =?utf-8?B?V3RPTDM0SkdvN1hLTmJOd3R5K3dNOSthaDNDNktGbHY2TjFKN3RSR0VFZHdZ?=
 =?utf-8?B?b0piRno2N256WW9acGpvKzh5am1zM0llU0wzekFqa1VCMWpLVDRmazB0cVV5?=
 =?utf-8?B?aldlQ1l2M2ZZMVBkM0tZWnZPeWd0VGIva1d6Rm8zSjk0d1plUmlMeDMwVDhh?=
 =?utf-8?B?NmZmb0Mxd3JnamYvYWUwaXZ3ZGV0dGhaY29XZzdYY25ocmVZYzNDL2V5b3JY?=
 =?utf-8?B?VndSaVFYQ1JvWWFZemZxcTZjQ1NvdGU2Z0p5N1ZyUGU5K1ZROG5rOUJPd0tr?=
 =?utf-8?B?NDR4emwyVURCZWZRN0ZLSUV6SjhFRTNRdm5uQWw0Tkd2MFUrYU95WG16RVl2?=
 =?utf-8?B?RUlDdlFEcHgyTFBiUlVRdnJwQTkrbWIySVdsNVhjMXRucmkxWTdwc0tiamV1?=
 =?utf-8?B?VnpsL05PdXFWNDBQS3B3UDI4Y3Jkb1VPa2J1N3Y5OGRMNGFZUjVqTnUrTE1P?=
 =?utf-8?B?NXhBYlVwZ2EyaXNld2FmYWE2RXFQbHY3OGZsa0lQdnhPVUFZVk1kZ2xEMitr?=
 =?utf-8?B?Q082eVlaY1ZiV2VlNmRXUkRLb0p4Y01ubmIxMDlrN1h6ZWJWa3MzWUljQkR1?=
 =?utf-8?B?eURrZEVhbXI5anNMZHR2NzI4Mjd0bm11TkFtWkFqUUdDaWZlWEVOWGF5Rll3?=
 =?utf-8?B?cW1MZXFTblIrSm1BTHdUYXA3STlPZG9BR3hENG5lUFZ6bTh1a1FxSlJLYm5w?=
 =?utf-8?B?WWV4SjlweXpvTm1CcnZSSlF5bnJNR0ltWEJmK3lTS3ZYY1VtUXB6TnRrdDFX?=
 =?utf-8?B?dENCQWExUEZVbkMrNHZXeFdqd1VhZHlicHRMMUJHS3NlY3J5VVV1aHFpeUxp?=
 =?utf-8?B?cXFWMk9YN0Nxa0pMa0pTSm51c2lpRG4zZ0ZzYmY5QzlTSU1UaThsU09JdTZE?=
 =?utf-8?B?VnRZdlpOZXNZcmU3SWdHblI1YStnZmhNWWJ0c2FPSVdVcG1mQ2hKWXBNOTFS?=
 =?utf-8?B?bWFXM2N4ekc0RjVISkFwc1R1NDdNYytXN2Jlb1NEMTVBUVdIM21mZlZaOGdp?=
 =?utf-8?B?K0tISUVZZUlNMTJVSUpLSFQ0b0xuVDdiSDFFblpHMDFBNFh2aG5yaWl6OFRS?=
 =?utf-8?B?ZHA0bWU0WnhHRDlVZjBqNE51N3RRTUljZENKdzBaaUxUV2pzNFd6Z1pCS3Vn?=
 =?utf-8?B?dHRwQnM4UG10ZW5TQ2lnUjJrT3pJVmR0UWQrejRhUkZsbk9PUUg4RFNGQVBJ?=
 =?utf-8?B?RkpvMDJqKzVDK1phbWQwQ3Z2NlZHeUh6RWNTNGhKN04yU0lwdSs2YWlFKzNZ?=
 =?utf-8?B?RjJtaUF5cDM4dURGQmlIZXFFbW00UEFrcXZ6YzFYcE93djFOWEFaRElVZEJC?=
 =?utf-8?B?WlZESWdlcFE1c3NxZWVUOFo2Rk90UVMvR255ay9lTGkzUEZSMU91OC9xbXZk?=
 =?utf-8?B?TXpMT1pKZTR5bzJxZi9SdHZBNFVCUnpRc0w0cmgzdm5JR0FXRmNRQVc5VHl6?=
 =?utf-8?B?UWhJNk9hdjZ5K3hyakRBY3QzKzMvbWRMNFVHbVpwaHNTQ1JPbnJtNVhDNDRB?=
 =?utf-8?B?cXc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b18ead1-ca3e-4498-629c-08da6b2f2a72
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 15:39:14.9089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dOFlf9a8p3244IykKD+MQJ1yCl7TUn9m623ytxiEBiAOEXfaHCgExwtqg1f7MGCkdk0dPdSsFvNI4RHJceiSVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3280
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 10:26 AM, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Saturday, July 16, 2022 0:59
>> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
>> netdev@vger.kernel.org
>> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
>> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
>> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
>> <sean.anderson@seco.com>; Alexandru Marginean
>> <alexandru.marginean@nxp.com>; Andrew Lunn <andrew@lunn.ch>;
>> Benjamin Herrenschmidt <benh@kernel.crashing.org>; Heiner Kallweit
>> <hkallweit1@gmail.com>; Ioana Ciornei <ioana.ciornei@nxp.com>; Jonathan
>> Corbet <corbet@lwn.net>; Kishon Vijay Abraham I <kishon@ti.com>;
>> Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>; Leo Li
>> <leoyang.li@nxp.com>; Michael Ellerman <mpe@ellerman.id.au>; Paul
>> Mackerras <paulus@samba.org>; Rob Herring <robh+dt@kernel.org>;
>> Shawn Guo <shawnguo@kernel.org>; Vinod Koul <vkoul@kernel.org>;
>> Vladimir Oltean <olteanv@gmail.com>; devicetree@vger.kernel.org; linux-
>> doc@vger.kernel.org; linux-phy@lists.infradead.org; linuxppc-
>> dev@lists.ozlabs.org
>> Subject: [PATCH net-next v3 00/47] [RFT] net: dpaa: Convert to phylink
>> 
>> This series converts the DPAA driver to phylink. Additionally,
>> it also adds a serdes driver to allow for dynamic reconfiguration
>> between 1g and 10g interfaces (such as in an SFP+ slot). These changes
>> are submitted together for this RFT, but they will eventually be
>> submitted separately to the appropriate subsystem maintainers.
>> 
>> I have tried to maintain backwards compatibility with existing device
>> trees whereever possible. However, one area where I was unable to
>> achieve this was with QSGMII. Please refer to patch 4 for details.
>> 
>> All mac drivers have now been converted. I would greatly appreciate if
>> anyone has QorIQ boards they can test/debug this series on. I only have an
>> LS1046ARDB. Everything but QSGMII should work without breakage; QSGMII
>> needs patches 42 and 43.
>> 
>> The serdes driver is mostly functional (except for XFI). This series
>> only adds support for the LS1046ARDB SerDes (and untested LS1088ARDB),
>> but it should be fairly straightforward to add support for other SoCs
>> and boards (see Documentation/driver-api/phy/qoriq.rst).
>> 
>> This is the last spin of this series with all patches included. After next
>> week (depending on feedback) I will resend the patches broken up as
>> follows:
>> - 5: 1000BASE-KX support
>> - 1, 6, 44, 45: Lynx 10G support
>> - 7-10, 12-14: Phy rate adaptation support
>> - 2-4, 15-43, 46, 47: DPAA phylink conversion
> 
> Please also send patches 15-38 separately from the DPAA1 SerDes and phylink set for easier review

OK.

--Sean

>> Patches 15-19 were first submitted as [1].
>> 
>> [1] https://lore.kernel.org/netdev/20220531195851.1592220-1-sean.anderson@seco.com/
>> 
>> Changes in v3:
>> - Manually expand yaml references
>> - Add mode configuration to device tree
>> - Expand pcs-handle to an array
>> - Incorperate some minor changes into the first FMan binding commit
>> - Add vendor prefix 'fsl,' to rgmii and mii properties.
>> - Set maxItems for pcs-names
>> - Remove phy-* properties from example because dt-schema complains and
>> I
>>   can't be bothered to figure out how to make it work.
>> - Add pcs-handle as a preferred version of pcsphy-handle
>> - Deprecate pcsphy-handle
>> - Remove mii/rmii properties
>> - Add 1000BASE-KX interface mode
>> - Rename remaining references to QorIQ SerDes to Lynx 10G
>> - Fix PLL enable sequence by waiting for our reset request to be cleared
>>   before continuing. Do the same for the lock, even though it isn't as
>>   critical. Because we will delay for 1.5ms on average, use prepare
>>   instead of enable so we can sleep.
>> - Document the status of each protocol
>> - Fix offset of several bitfields in RECR0
>> - Take into account PLLRST_B, SDRST_B, and SDEN when considering whether
>>   a PLL is "enabled."
>> - Only power off unused lanes.
>> - Split mode lane mask into first/last lane (like group)
>> - Read modes from device tree
>> - Use caps to determine whether KX/KR are supported
>> - Move modes to lynx_priv
>> - Ensure that the protocol controller is not already in-use when we try
>>   to configure a new mode. This should only occur if the device tree is
>>   misconfigured (e.g. when QSGMII is selected on two lanes but there is
>>   only one QSGMII controller).
>> - Split PLL drivers off into their own file
>> - Add clock for "ext_dly" instead of writing the bit directly (and
>>   racing with any clock code).
>> - Use kasprintf instead of open-coding the snprintf dance
>> - Support 1000BASE-KX in lynx_lookup_proto. This still requires PCS
>>   support, so nothing is truly "enabled" yet.
>> - Add support for phy rate adaptation
>> - Support differing link speeds and interface speeds
>> - Adjust advertisement based on rate adaptation
>> - Adjust link settings based on rate adaptation
>> - Add support for CRS-based rate adaptation
>> - Add support for AQR115
>> - Add some additional phy interfaces
>> - Add support for aquantia rate adaptation
>> - Put the PCS mdiodev only after we are done with it (since the PCS
>>   does not perform a get itself).
>> - Remove _return label from memac_initialization in favor of returning
>>   directly
>> - Fix grabbing the default PCS not checking for -ENODATA from
>>   of_property_match_string
>> - Set DTSEC_ECNTRL_R100M in dtsec_link_up instead of dtsec_mac_config
>> - Remove rmii/mii properties
>> - Replace 1000Base... with 1000BASE... to match IEEE capitalization
>> - Add compatibles for QSGMII PCSs
>> - Split arm and powerpcs dts updates
>> - Describe modes in device tree
>> - ls1088a: Add serdes bindings
>> 
>> Changes in v2:
>> - Rename to fsl,lynx-10g.yaml
>> - Refer to the device in the documentation, rather than the binding
>> - Move compatible first
>> - Document phy cells in the description
>> - Allow a value of 1 for phy-cells. This allows for compatibility with
>>   the similar (but according to Ioana Ciornei different enough) lynx-28g
>>   binding.
>> - Remove minItems
>> - Use list for clock-names
>> - Fix example binding having too many cells in regs
>> - Add #clock-cells. This will allow using assigned-clocks* to configure
>>   the PLLs.
>> - Document the structure of the compatible strings
>> - Convert FMan MAC bindings to yaml
>> - Better document how we select which PCS to use in the default case
>> - Rename driver to Lynx 10G (etc.)
>> - Fix not clearing group->pll after disabling it
>> - Support 1 and 2 phy-cells
>> - Power off lanes during probe
>> - Clear SGMIIaCR1_PCS_EN during probe
>> - Rename LYNX_PROTO_UNKNOWN to LYNX_PROTO_NONE
>> - Handle 1000BASE-KX in lynx_proto_mode_prep
>> - Remove some unused variables
>> - Fix prototype for dtsec_initialization
>> - Fix warning if sizeof(void *) != sizeof(resource_size_t)
>> - Specify type of mac_dev for exception_cb
>> - Add helper for sanity checking cgr ops
>> - Add CGR update function
>> - Adjust queue depth on rate change
>> - Move PCS_LYNX dependency to fman Kconfig
>> - Remove unused variable slow_10g_if
>> - Restrict valid link modes based on the phy interface. This is easier
>>   to set up, and mostly captures what I intended to do the first time.
>>   We now have a custom validate which restricts half-duplex for some SoCs
>>   for RGMII, but generally just uses the default phylink validate.
>> - Configure the SerDes in enable/disable
>> - Properly implement all ethtool ops and ioctls. These were mostly
>>   stubbed out just enough to compile last time.
>> - Convert 10GEC and dTSEC as well
>> - Fix capitalization of mEMAC in commit messages
>> - Add nodes for QSGMII PCSs
>> - Add nodes for QSGMII PCSs
>> - Use one phy cell for SerDes1, since no lanes can be grouped
>> - Disable SerDes by default to prevent breaking boards inadvertently.
>> 
>> Sean Anderson (47):
>>   dt-bindings: phy: Add Lynx 10G phy binding
>>   dt-bindings: net: Expand pcs-handle to an array
>>   dt-bindings: net: Convert FMan MAC bindings to yaml
>>   dt-bindings: net: fman: Add additional interface properties
>>   net: phy: Add 1000BASE-KX interface mode
>>   [RFT] phy: fsl: Add Lynx 10G SerDes driver
>>   net: phy: Add support for rate adaptation
>>   net: phylink: Support differing link speeds and interface speeds
>>   net: phylink: Adjust advertisement based on rate adaptation
>>   net: phylink: Adjust link settings based on rate adaptation
>>   [RFC] net: phylink: Add support for CRS-based rate adaptation
>>   net: phy: aquantia: Add support for AQR115
>>   net: phy: aquantia: Add some additional phy interfaces
>>   net: phy: aquantia: Add support for rate adaptation
>>   net: fman: Convert to SPDX identifiers
>>   net: fman: Don't pass comm_mode to enable/disable
>>   net: fman: Store en/disable in mac_device instead of mac_priv_s
>>   net: fman: dtsec: Always gracefully stop/start
>>   net: fman: Get PCS node in per-mac init
>>   net: fman: Store initialization function in match data
>>   net: fman: Move struct dev to mac_device
>>   net: fman: Configure fixed link in memac_initialization
>>   net: fman: Export/rename some common functions
>>   net: fman: memac: Use params instead of priv for max_speed
>>   net: fman: Move initialization to mac-specific files
>>   net: fman: Mark mac methods static
>>   net: fman: Inline several functions into initialization
>>   net: fman: Remove internal_phy_node from params
>>   net: fman: Map the base address once
>>   net: fman: Pass params directly to mac init
>>   net: fman: Use mac_dev for some params
>>   net: fman: Specify type of mac_dev for exception_cb
>>   net: fman: Clean up error handling
>>   net: fman: Change return type of disable to void
>>   net: dpaa: Use mac_dev variable in dpaa_netdev_init
>>   soc: fsl: qbman: Add helper for sanity checking cgr ops
>>   soc: fsl: qbman: Add CGR update function
>>   net: dpaa: Adjust queue depth on rate change
>>   net: fman: memac: Add serdes support
>>   net: fman: memac: Use lynx pcs driver
>>   [RFT] net: dpaa: Convert to phylink
>>   powerpc: dts: qoriq: Add nodes for QSGMII PCSs
>>   arm64: dts: layerscape: Add nodes for QSGMII PCSs
>>   arm64: dts: ls1046a: Add serdes bindings
>>   arm64: dts: ls1088a: Add serdes bindings
>>   arm64: dts: ls1046ardb: Add serdes bindings
>>   [WIP] arm64: dts: ls1088ardb: Add serdes bindings
>> 
>>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |    1 +
>>  .../bindings/net/ethernet-controller.yaml     |   10 +-
>>  .../bindings/net/fsl,fman-dtsec.yaml          |  172 +++
>>  .../bindings/net/fsl,qoriq-mc-dpmac.yaml      |    2 +-
>>  .../devicetree/bindings/net/fsl-fman.txt      |  133 +-
>>  .../devicetree/bindings/phy/fsl,lynx-10g.yaml |  311 ++++
>>  Documentation/driver-api/phy/index.rst        |    1 +
>>  Documentation/driver-api/phy/lynx_10g.rst     |   73 +
>>  MAINTAINERS                                   |    6 +
>>  .../boot/dts/freescale/fsl-ls1043-post.dtsi   |   24 +
>>  .../boot/dts/freescale/fsl-ls1046-post.dtsi   |   25 +
>>  .../boot/dts/freescale/fsl-ls1046a-rdb.dts    |   34 +
>>  .../arm64/boot/dts/freescale/fsl-ls1046a.dtsi |  179 +++
>>  .../boot/dts/freescale/fsl-ls1088a-rdb.dts    |   87 ++
>>  .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi |   96 ++
>>  .../fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |    3 +-
>>  .../boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     |   10 +-
>>  .../fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |    3 +-
>>  .../boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |    3 +-
>>  .../boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |    3 +-
>>  .../boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      |   10 +-
>>  .../boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |    3 +-
>>  .../boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      |   10 +-
>>  drivers/net/ethernet/freescale/dpaa/Kconfig   |    4 +-
>>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  132 +-
>>  .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |    2 +-
>>  .../ethernet/freescale/dpaa/dpaa_ethtool.c    |   90 +-
>>  drivers/net/ethernet/freescale/fman/Kconfig   |    4 +-
>>  drivers/net/ethernet/freescale/fman/fman.c    |   31 +-
>>  drivers/net/ethernet/freescale/fman/fman.h    |   31 +-
>>  .../net/ethernet/freescale/fman/fman_dtsec.c  |  674 ++++-----
>>  .../net/ethernet/freescale/fman/fman_dtsec.h  |   58 +-
>>  .../net/ethernet/freescale/fman/fman_keygen.c |   29 +-
>>  .../net/ethernet/freescale/fman/fman_keygen.h |   29 +-
>>  .../net/ethernet/freescale/fman/fman_mac.h    |   34 +-
>>  .../net/ethernet/freescale/fman/fman_memac.c  |  864 +++++------
>>  .../net/ethernet/freescale/fman/fman_memac.h  |   57 +-
>>  .../net/ethernet/freescale/fman/fman_muram.c  |   31 +-
>>  .../net/ethernet/freescale/fman/fman_muram.h  |   32 +-
>>  .../net/ethernet/freescale/fman/fman_port.c   |   29 +-
>>  .../net/ethernet/freescale/fman/fman_port.h   |   29 +-
>>  drivers/net/ethernet/freescale/fman/fman_sp.c |   29 +-
>>  drivers/net/ethernet/freescale/fman/fman_sp.h |   28 +-
>>  .../net/ethernet/freescale/fman/fman_tgec.c   |  274 ++--
>>  .../net/ethernet/freescale/fman/fman_tgec.h   |   54 +-
>>  drivers/net/ethernet/freescale/fman/mac.c     |  653 +--------
>>  drivers/net/ethernet/freescale/fman/mac.h     |   66 +-
>>  drivers/net/phy/aquantia_main.c               |   86 +-
>>  drivers/net/phy/phy.c                         |   21 +
>>  drivers/net/phy/phylink.c                     |  161 +-
>>  drivers/phy/freescale/Kconfig                 |   20 +
>>  drivers/phy/freescale/Makefile                |    3 +
>>  drivers/phy/freescale/lynx-10g.h              |   36 +
>>  drivers/phy/freescale/phy-fsl-lynx-10g-clk.c  |  438 ++++++
>>  drivers/phy/freescale/phy-fsl-lynx-10g.c      | 1297 +++++++++++++++++
>>  drivers/soc/fsl/qbman/qman.c                  |   76 +-
>>  include/linux/phy.h                           |   42 +
>>  include/linux/phylink.h                       |   12 +-
>>  include/soc/fsl/qman.h                        |    9 +
>>  69 files changed, 4408 insertions(+), 2356 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-
>> dtsec.yaml
>>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-
>> 10g.yaml
>>  create mode 100644 Documentation/driver-api/phy/lynx_10g.rst
>>  create mode 100644 drivers/phy/freescale/lynx-10g.h
>>  create mode 100644 drivers/phy/freescale/phy-fsl-lynx-10g-clk.c
>>  create mode 100644 drivers/phy/freescale/phy-fsl-lynx-10g.c
>> 
>> --
>> 2.35.1.1320.gc452695387.dirty
> 
