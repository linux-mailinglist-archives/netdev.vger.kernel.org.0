Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C48162F9AA
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241407AbiKRPts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiKRPtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:49:47 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2059.outbound.protection.outlook.com [40.107.105.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB438B100
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 07:49:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atdPJ1/L8omNoxAe0Il2liE7EAStBCkmSVTwkco7LWiL8GLyEjVvgxMy0nN0BVsLOCk4NPvSG8h1jHusHE2loEUgwoBHCQJHBw1KOhiN2Zu7EsdFGnEuaBblTPQGnvPEn3yE4fWg2iBj47HW8knlDLm2VGpJcN89SDWd+U34UH+xy7BErQjLM+0hWhCutL2qbj1rQCAXWU9TuAGm6XxFDN8zp6VpHuQFiW66hDjNmJ6kSR/dfVd8mkDCuFmP4GsQQR1UD2s20YjZN7yhZtAfi82UxQ7lTjiSCVqADDwXc4k8/aPyk9SiAOkwrFVb8ZR/IFdg5IkDIaYQQPiqKDXfvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=npM59MhB+rFUKncIxW03EoK7jfIq3+TuUWYklN2fqSQ=;
 b=DdGD20P39xvYIlDHcngy+D0ZJCgIqlS5crq9ZBBObqH2DJOCMuz0GdIDAx64oYrDef6ueHaqhXXBj2XAFrxxpT336FGdyC5MoOJ9eebBCVurEujjZRKUQxZISK4ZgXvPFUMcOOtpOub0Y7T3mTmE/VmMGk3Ool56UazU/wxpokE/1ym1bFO/R7PXxVgAciNSA43fp9YdFHAdhNoQSKzCVYeKv06M4wmtN13N3U4+EndV7CPeqfCPL9bVe8ve+McCLHSaDAfW5jSDezdXX9N4C6yFVOWi1iNPCiMwpSnMigjGDdepC0qwK4ftZ3AXOCXdcNYHSMTgRPGS2lF8V88zog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npM59MhB+rFUKncIxW03EoK7jfIq3+TuUWYklN2fqSQ=;
 b=ar2oujrXU8GQdpv0OmDCC5gD5KNmVwg9GJRHSBtZ/85/D6QNOGiY5AFgiAzXQc1hIyAS6sp8feObSJUgpLaIwlJb9+bMU5dki66rztuuAOxNUHz+tUU8YCcHmOwQGf1pV86CZqzL0hQ6isQoTZj2CYBGEeS5SkddzMRtwAkWugGGjNH9wq233/1JwVDwfyMb/lJ5lBQjUTOdd23CsUa3YZrTMCCgD84difbdpAOAtlMxqv+rLKEZ+7BQxe5SpiZGelPFJcQ9/O0ogFH8SG4yRvFxv+HJApa5PkdSNK3SCbXeFw2peFEdd3Jwml5nYF31LFIdWH0GCdBKWm0Mb3pf+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by VI1PR03MB6144.eurprd03.prod.outlook.com (2603:10a6:800:141::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Fri, 18 Nov
 2022 15:49:42 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 15:49:42 +0000
Message-ID: <0e921aaa-6e71-ba16-faf7-70a4bac5be23@seco.com>
Date:   Fri, 18 Nov 2022 10:49:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 net-next 2/8] net: phylink: introduce generic method to
 query PHY in-band autoneg capability
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-3-vladimir.oltean@nxp.com>
 <4a039a07-ab73-efa3-96d5-d109438f4575@seco.com>
 <20221118154241.w52x6dhg6tydqlfm@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221118154241.w52x6dhg6tydqlfm@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0050.prod.exchangelabs.com (2603:10b6:a03:94::27)
 To DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|VI1PR03MB6144:EE_
X-MS-Office365-Filtering-Correlation-Id: b7609c76-82e3-4416-c85e-08dac97c81e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0N4zi1TSR7aXeLty5XX1jAbdjsKd0UwhzDfjCCjlbbdmuPrJ/ArDRq0IrQNqNnwOQaHqAoM4y6jlLnxqUALTCMhW/GP+ASrK5+qNW+f4YpfWrk+h32/dNupjV7/whmKZLiKR+6bBm9Hx1OvDZuLaj17vwQKiXabWPTtKO2EJkvAUrZHbQhhJCQojuloSjPkukuqXl6Z1GXjx/fLQN4DdrExhZV1rbBRW9MnIfYVAAF4lF6wckwquwRLat8/GNzcec6XlF/GSZzShpW+Cz3P8aMeVgpxqwHZmELxxtcIrIsf566vSB8lKAI5ZEZSD57KqvgHlc7srnLtsUi583CPurl6uDckcUAC9XwIVzJVfYzi80nTqPxOYHDWXpVhMAgzY1fR2sPENQg7KMSf7SG8ZraT6UnIEpJRm3v+kwA4gc62frzo+Tl4TpMfbWjL87g8PMBpsrDtWHULRK75NMDVwaEkQ3sLx8JCWJmWm7U1p6k9/YZuBBqwh90HnuYNNmeyJYUj22gSUkm2K+TgArekITI8cfyWCzlny9tYXddVPLr9V0fz18YOn1koYZQj+pdHwCX3r0xXB9RETA0pI5nMm7DrXQOVbBP3k4sMmLEAojgjTNXOTwmFXuHP+MTicttioQkqzBmoIUlzgHBAJ+cnH90bQ9YnX2wbjjLkn3zFBotvx3DkHZlW83RsM3D0NA9W7xHEzUQQqxoJ8edWsT+HCSE9XMQ5q7oHiXsGpsPDw1Hnh+ItB5NqC16Z0RYQeVxPuhT5gmOy6EW0krkSqr4Zb3ad8GFusk8TlvqUH3WTDxs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(39840400004)(376002)(451199015)(6666004)(6506007)(2906002)(6916009)(54906003)(6512007)(26005)(53546011)(31686004)(52116002)(66476007)(66946007)(41300700001)(8676002)(2616005)(4326008)(5660300002)(8936002)(186003)(6486002)(7416002)(478600001)(44832011)(83380400001)(66556008)(86362001)(31696002)(316002)(36756003)(38100700002)(38350700002)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1Q2R003N0JNR1Q1RUNodUl3ekNMNnl5ZHNWbHlnZWR5OUF1NHVGUS9LcWJ6?=
 =?utf-8?B?bUNDb2p4cHBNeXZVM2k5VzhxUFlLOUo5VE50MndtbXFWN25ETUI3WEk3ZDJk?=
 =?utf-8?B?aklvSnVIcUxDN2VXWThPNGUzeXgwejZGZ0c3d0MyUnRUaFVrTkMyTUN4UHRs?=
 =?utf-8?B?VFluV0MxVXhScFdqRlFmN3ZBbElBNXBqNUVXZ0lFM0FFWEhMTUhBVFA5elBN?=
 =?utf-8?B?eXJQNEorbkt3V1RjWFhSMDJkRUFRY0wvdEx2TlcrWlVmbldYTlRxSWt4clJx?=
 =?utf-8?B?aVpnMzdzb3Y5Wndka3l0TklEYmlsSzlXY3RnNmhhRDVleE9sbnNQaVhWdTdH?=
 =?utf-8?B?VjdBbjR2OGZrTDZIRkhHU3lyV0VsM1hhVS9HQUdkWDFYUys4ek8waEkzczRQ?=
 =?utf-8?B?WFErK3NaOFJaWmZjalhQek9aYWNuMWlycnRBcWkwRDZsYlBVZFFmVGtESFdy?=
 =?utf-8?B?ZkJUaXZFTUJLWVFSVkRLUzZyYnZPbThIT0NOZ2FQbTBXTEhKcVlhN2xlRjEw?=
 =?utf-8?B?YjNTODVDYTdKZ01CL080YnlLenpENHR5U3duMkxqZkZuK0cxcWRuUFd2cC90?=
 =?utf-8?B?S1RuWkt4amFGNjJ2VlR5ZlJQN1Q2aFNkNmhQcEtZSktVaU1KWmhDMWNJY2dX?=
 =?utf-8?B?dTVoKzFseVFtOGlrRFpJY0pnMkVadlh5NUJjWVlGMjdwa2VLQy9IZ1E0WHov?=
 =?utf-8?B?blBLa0RDcDNpb2o0aGxnM1J4RnlLaUJYczQ4d01GUTM4RFF6K2dDTTlKdHo0?=
 =?utf-8?B?bTVudis1S0JVWDhCUmFYbExtVFRFYk10amJocXhPYWZ3a1Fkd0I5ekd4aVZy?=
 =?utf-8?B?SC94Q3RoT29ZYUdxQ2Y2QXB5OUpEck5DWHZUS0xTbTArcTlLeTNKaUVoeDJm?=
 =?utf-8?B?UlU2dTdnVCtCWHV6dVE3Y3UxZVkwbUxoVk1lMXZQalZobTFVaVFsR0lCQjdo?=
 =?utf-8?B?Zk1tQ0hsYUYyVFIzQVNPM0poTDhkY1dRSElvd1lMNnpFc2QreW9yMDlqVW52?=
 =?utf-8?B?ZEV2RlQ2NjJZVDVHL3d4K0ZxREcxUy9jV0kvMFdJUEgrTnFGUm5jQkpuUjlP?=
 =?utf-8?B?NENMRlowVTY0R3QwL2ZjK0ZEUDFjU1BDS1lFUDB3ci9xQjErZUFRcmNyN0xk?=
 =?utf-8?B?alhkd3pWMGE0OGw4YWtaMDVRbk1kL0JqRW5XK3lWQWpwUi9YUGtKSDhFdUtq?=
 =?utf-8?B?OVdBbjJhUUIwdHZQTXJ3R1IyS21oTUxhdUVxbzVkNFVqN0puclFWMFpubXI1?=
 =?utf-8?B?UzRERlVGVHN3NVBJVmpVUlN4a0VaYVlIbE94MGErMW9rT1N0TmxOZjRrOUlZ?=
 =?utf-8?B?aDVlaldCUlZIWlpudUVhVXovV3MvaG5TZW15Ukw4NlZLaHFYZWUrWkZwbWhk?=
 =?utf-8?B?NjdvNUVGY0k1TFRpN2tPN1BILzltRHRRRUpxdXBFSkdqaExVUnhjTVJrWjVx?=
 =?utf-8?B?VTBlSFM3aUNkVmNRTkQ1YXR0UHArNDh3aEtPY1ZiM0pEWVJjdmtHLy82bzRO?=
 =?utf-8?B?TkhLdW5FUjlYQ3VCcFQrNkZsSSthcVhNd1p6WE9hSVMyVHRyRTFUOXY3VHpS?=
 =?utf-8?B?MldoeFNpTmJGcEJSZFIzVUJ3UFJ5bXkwZWNMTzc3eHpwNEhlYXAxa2EvVTg5?=
 =?utf-8?B?dnFYclAvdWd2U3FFN3pLdFFCakxKUmpycU1aUUE4ZW9zTWQyUW9PV1FZWkNx?=
 =?utf-8?B?c2lOdE5SMlptWlFiTE0va1ZFL01NS1g2cHMrM2VJTzFBb2lsNll1Y1NNWmVK?=
 =?utf-8?B?Z212bGs3SGpZWExjZmNFTS8wSCtXS29KbEljeUQzVlJWUzNmUXNEUmZyWm8z?=
 =?utf-8?B?QnNoalppNkcyNUZrVFpOd3lmTFFwNTNEL2R1N3o0VmJHREtwLzI4MnBjUlZD?=
 =?utf-8?B?ek1zL2hWTCtsNmdXTWpUUXFZVk1DZUwzWndWRXhhd3lCRkV1ZnIwdXVNVmh3?=
 =?utf-8?B?TldaZDRIVEV3VFA2ODU5UVJWb01va2RwWnBwdGVXR3loeFM1TmpBazVPZzhR?=
 =?utf-8?B?cmp6bEVKajAwdFkxWmQ4QVFJRERabFMyL2VDNEtHQ01ZOWpOSGhCL3lkZXNY?=
 =?utf-8?B?ZCtDcnpib1E5VldSVVRGaXVjMXd3YXJpYi9SdW5Oa1NEaExRcS9neCtMZno4?=
 =?utf-8?B?MXBkM1VTZHpaLzZXaUo1Qm9kcmpOcUtvaGJLVzVuMm9jTEQwa0JDYTlQamlv?=
 =?utf-8?B?OGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7609c76-82e3-4416-c85e-08dac97c81e7
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 15:49:42.0956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKBr4tdYP+37x3lTWi+UiLxjWRi/HCK5pmLdPMO9nhstKjzsP39pyxES1qTdmNvI2+Bnt8oD5M0k3owMFxcZkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6144
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/22 10:42, Vladimir Oltean wrote:
> On Fri, Nov 18, 2022 at 10:11:06AM -0500, Sean Anderson wrote:
>> > +enum phy_an_inband {
>> > +	PHY_AN_INBAND_UNKNOWN		= BIT(0),
>> 
>> Shouldn't this be something like
>> 
>> 	PHY_AN_INBAND_UNKNOWN		= 0,
>> 
>> ?
> 
> Could be 0 as well. The code explicitly tests against PHY_AN_INBAND_UNKNOWN
> everywhere, so the precise value doesn't matter too much.
> 
>> What does it mean if a phy returns e.g. 0b101?
> 
> You mean PHY_AN_INBAND_ON | PHY_AN_INBAND_UNKNOWN. Well, it doesn't mean
> anything, it's not a valid return code. I didn't make the code too defensive
> in this regard, because I didn't see a reason for making some pieces of
> code defend themselves against other pieces of code. It's a bit mask of
> 3 bits where not all combinations are valid. Even if PHY_AN_INBAND_UNKNOWN
> was defined as 0 instead of BIT(0), it would still be just as logically
> invalid to return PHY_AN_INBAND_ON | PHY_AN_INBAND_UNKNOWN, but this
> would be indistinguishable in machine code from just PHY_AN_INBAND_ON.
> 
> I don't know, I don't see a practical reason to make a change here.

If we have the opportunity, we should try to make invalid return codes
inexpressible. If we remove the extra bit, then all the combinations we
would like to have:

- I don't know what I support
- In-band must be enabled
- In-band must be disabled
- I can support either

are exactly the combinations supported by the underlying data.

--Sean
