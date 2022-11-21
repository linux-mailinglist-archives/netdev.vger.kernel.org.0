Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194AF632FF0
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 23:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiKUWnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 17:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiKUWnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 17:43:05 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2068.outbound.protection.outlook.com [40.107.22.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2905E167D4
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 14:42:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZLDElrNshV87zyiqeC6TEVw3fvoJIcnHq2XPWnzzjZp4IWNC1no7f65Uv8kgS8jFwyiO7KKyccwiAMRF34mItlWT8gt8hH8hEpUymvOZFey0XQ4UV2IRrQ3ZJ67oyxpiXJutk2+agA+rFO3XtAaUTgDEtDG2WG0EHjpKiTV/hLaCT8e1Mb/hUfo+06Jip/wRaMxrWnDAiOKr+cqkZAqs+2zpBt5PixbJMK0ONE51MMVNav58/b/bRiRtPEctOYj687dkn6B6MZDAUq0BHCa0Y2rtUoL379lZ+c7CisnJKvntBTMlZzf+CAgcqmEYTvFEKehS/yBHqlyhrE4jWXJiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DH6+4IY06md1PsgOiivcZF++1fkuHFk1zVzLj0mpk2I=;
 b=TX4820V8RPyaiUZk56YcAmtLhs5t6xfTOziv1CY+P9SsLON3VevgcN1UTkc/XhQjX45B41EWKXBm400nkPS8KzOs1NVLAV3eyNM/0yMlVkhZlUCsI6ULiG3QCTuRPlBP61PFeir9mUMToIpZOUbF/x3MRFGJwZWIeOM3AEfUcAjA/puXWIwk26b6PRsPD7AysxRLCkATXXiWGo9615aIrudUrmnP/28waVMcRJcCC0NDJDfUyPc76Sk9JhCSfK4y6hBamiSTBH75m6HnMx5DIuim2+mFmMojCSRAbwkNXC6eTPoPMWTcE+Kjwhf0YuDd5N9G0CXKtxWJW7fmjG4izw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DH6+4IY06md1PsgOiivcZF++1fkuHFk1zVzLj0mpk2I=;
 b=OQ5jKe5PpNEEL8Gk8IrFlRhPDdkGhPnULddpxK8mUokdtqI1CNQk8wiGoRAZP8iBRXPmg9dh3g+sLr0Qd8K/tVZVL0QGhSFJR1HyawElzK3rv7/LtiG3jOjvWDvNlbJk7aDHRhOzytScGcvZgpfDJz64efWDT8/NVpk6iqcetfhlAQjWJp7RgRFmYPnL26/uHzt7dgZlRyY1AgKhM/YTXnQROp9aufX7qVsaWNJdgBjuGf722xx3H7z6JsSkH7WKohOJ+7sM3iKGapttLH5R6vYdBWa3ykrHUzO0K4wQNnLxeQoQOXshyYZYoKXi745Kfciwf73pv28b89r85oxNyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DBBPR03MB6698.eurprd03.prod.outlook.com (2603:10a6:10:1f7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Mon, 21 Nov
 2022 22:42:51 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 22:42:51 +0000
Message-ID: <4bf812ec-f59b-6f64-b1e0-0feb54138bad@seco.com>
Date:   Mon, 21 Nov 2022 17:42:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 net-next 0/8] Let phylink manage in-band AN for the PHY
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
 <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
 <20221121194444.ran2bec6fhfk72lt@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221121194444.ran2bec6fhfk72lt@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0017.prod.exchangelabs.com
 (2603:10b6:207:18::30) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DBBPR03MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: c6531def-d0fb-41c1-1cfa-08dacc11b7dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rBBHiF+TWSWNaYcQrMwcOODcZ4MpOYCZ6TrSMDcYVDIZ1avobtv9IdauMOKC1/Taq/n5SF7dBdqwvOOwREpOYUx9/EQilhbu1+JDwWmhaS4t5omaLgVEe2Ilr/sw5X05pFzNz8rjj//SYNnVdI/tlajwPRtxXgBkG/Bf9cB3665msEyr2s9Mg49h7IpUNiXGxG8W/bw9822zXpyvAM4wMkoiyvus92wCC8/ONyKJqdZeF0FQVwaR8oYDFeVcjannN2B09oY0iHBdc87+CjlNuow1EAD9SYmFyhN4OZxpRtEYdquiicGD9KtxRA7FODIHFaTcRa7bRaysnq97dSqzdjkZaLsEDIj3vlW0mmV6Jz6DMG10XetQ41ya9VqEC1Q/EFIkRoXSW/TxkyS53Fzld7Rblt0BvgRuD6RYOcUQKsULLLtxZr2/8ohA+zIhR+Z0vICJDlfyWPnfRaDJKG7M7J4f/COf2swZmfhv8eL30NNafK3WSlW4QALp4ffy7z/AF8vbjA1yx0o81o2V93xZMLneSPCEOm2JEzuEFrMtDQAzMhtQZixj24hob5QYt1G1CHVmY4NKp4+Bsf0CsUHAECnaj1MagnNIY5pQf4mh08/5ZQMFG4n0NgUzryp8IIq0NraNZzAHmniNL4pdNBV7+/gJ8GLmBoLtuuGXhkPQWaBCcVDtcDlzNWHBNdxXYou4ZMAnG8SRxcEj+6cBvDlY2eJsITNFD6o3JR/uW686vxoyGCCnlDpiMPw2Th7x5yMJ01ohYAkTrHg5Y0b+3H7Z8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(376002)(39850400004)(346002)(451199015)(36756003)(31686004)(31696002)(86362001)(5660300002)(7416002)(44832011)(26005)(2906002)(52116002)(186003)(2616005)(6512007)(38350700002)(38100700002)(83380400001)(53546011)(54906003)(6916009)(66556008)(6486002)(6506007)(41300700001)(8936002)(66476007)(19627235002)(66946007)(4326008)(478600001)(8676002)(6666004)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUlVb2pJM2ZGMHhsbnRzKzNHUU4vTU1qSTMwQmlaSUVmVWU1ejBkT2ZxcHNE?=
 =?utf-8?B?Tld6NkdnUVBLcTZZWFVOSVR3eFpwT3FjWmRya2NGdFFwa09icHRtRmVsZjZM?=
 =?utf-8?B?R09TckVIdWdNUFoyVzBZa0o4dFJOek44T2QyZ1FOeUJvelNDSmNJWUIzQ3Vi?=
 =?utf-8?B?d213ZDErdHd0bUtwKytNdmxtRVBFUU9TQWFLU2Z2VkxieWxsQnlqR2RXdWpF?=
 =?utf-8?B?MGdzNm0rajgrS0pmKy9EM0F5YnNFa0UxM21OWkRPc1BQZUN2RUFTcDVrVlY0?=
 =?utf-8?B?MjNxWTRiaEUvWWZ1RmhhR0xIMkIyVWUzYmNhTUg2M0UwQkFyYlVmbCtRRk5s?=
 =?utf-8?B?Um50cFdZOGgyNm4zUVhROUNOMnMxdisvVGVKMVNqZHhMVFVEZkluUHFrczRD?=
 =?utf-8?B?OXJOaFRlUnA5YVRtSFpjblorZ2EzeldobTNGTERQNHMwZzc1WmEycS9MdUxl?=
 =?utf-8?B?Ny9rdzVqeXlMYldFdWJlZVZhTEV2SW9wSmd2a0dZdys4azhmV244L3lxcjZK?=
 =?utf-8?B?M0h6UU5KaHNhV2xjSTRWVHlQVElDNys4OStXMlMrazBFTktZRk9lMGxlRXFT?=
 =?utf-8?B?dVNJQ25YNGtaTGw2Q2ZNbENyWDNWRTF5VytSb0VSamRKQVlLRkd5Ujg4cnNl?=
 =?utf-8?B?ZzY5NmZ1SkpjWWdRL1RsY0xjTzNhMm1mT2U5UDBZR290ZEdUWGd3bTU2OTNi?=
 =?utf-8?B?NXJ0eDZuNEtaNXZ1UHZPSjVic2JLVHo4ZXhKckVpcVZlZjVwQVZyQ254TUlP?=
 =?utf-8?B?OTNHcUZhT1k4ak5na1A1eXN5dmlaTTl0WVNEK29BaHlvRGNUWDlib3hDV2Jv?=
 =?utf-8?B?Y3ZCWWFlWWhNUzQvTGlyOWUyYlR4VFFhNkxpOGZvR0ZQbUVPMHN2WjlCM1VR?=
 =?utf-8?B?QVU0eTJEKzFCWlhBQ1BrcEplaVFqVVlaMjB4d20xaVJCTUFPTzBnbjVDQlg5?=
 =?utf-8?B?eUVURUxlNTk1bnprUzl1aUpuWmZTK0pUaXdMSWZOUUhxVGw3Vk0yYlNZendT?=
 =?utf-8?B?bzdac1pwdG1FYnRuTHVMS1FMTXdsMWcvOHZ1Z2tmUTN5S0hkWnM3VGpZVVBZ?=
 =?utf-8?B?THBHSWhGMXU5WTI5UjE5QXpLbnZ0NXorckxXbitZZkZFNGNiSWM5WWxqR3VU?=
 =?utf-8?B?eGUyS09aZE9PTEphTFlXM2M2eVFBaEkxaTA0cGdkNHZQUTVPRGNmNzlIWWhC?=
 =?utf-8?B?Zy9aeDk3WlNueWlHNUdxaTcwbmR1bGZpbzk4c2VRSDdTYjFaQlRPaCtDb0VL?=
 =?utf-8?B?TGxFNjdRcUVUbml3bkFBeTRMVFRjSG96SmZRVXJONU9ndlFLVWJVTm1mcDhG?=
 =?utf-8?B?K1h4K25vMlVKaUpwY3lDVVA1UFh4ck95RWE2T0R2UUlSeFJ0ZUVmekhnZG9C?=
 =?utf-8?B?WVd6c2pZMmhyUjdJcUZESUZpN0RsM3FEUVpNbTZSQk9iUHJrQTEwRDFXM0NX?=
 =?utf-8?B?c0prbWNpSFR1ZE8rRlpYSXB4VDhYaVFWYVBMRFJQZnV4VmJOanNGWkJwLy9o?=
 =?utf-8?B?QkJJdTBCaThyNHordFVtVXFSc08rdEp3NVowMXU3YS81ekR1M2w4Ui9Jc3k3?=
 =?utf-8?B?QnNoRlZic01jMERvWGRXZ3BqR0RLTFJCeE1LWHg3RnNLaVUyQWhYSHVUb0lH?=
 =?utf-8?B?RmRkSW96SGRjZmdoYWVrdjRESzVxZXBGdlRDVStnUFBTWEdpY2dpZWw5dElt?=
 =?utf-8?B?K1hBUGV5R2xPbEJ4U216UnQxcCtLei9kQnFOSldrODdSWVQvSERqaEZyT2ZT?=
 =?utf-8?B?TUw5R2tHWFBoTGoyMG82SnhDU0NZcnNSOFB6ZFFHRnY3amxOYW9UcjFtR1Rw?=
 =?utf-8?B?c1FoQ3VYa1BLRXpEU1UwamZrbG9zdW81aDYyZThLM3cyVVJoZk9PaXJIVHZy?=
 =?utf-8?B?TDQ3UmRGam1RTXhJZkhwS21OZmZtckZJd3dZd2U2VTFGTXpna3FNWk9GWVR6?=
 =?utf-8?B?THJHcUc4Q2hRMytjNnFUa0dXSHNaSVllMi9BT3pDa3ozbFEydnFpZ3p5Z2o3?=
 =?utf-8?B?KzNWZkFMNVFXV1d1SmpYTjdES1pSbzJLQzZ4YnI5dGZFRE9wWGZFVFVmM2s3?=
 =?utf-8?B?MzF1L3hzZmViZGxaSUlFbThJa09CbHEra2hXcDBTMDM4ZDdxaUtodXU0VFl3?=
 =?utf-8?B?RHAwSXhZajNTcUZYN0gvRGRvaytxUVF5V3BkbjBNK3ZCWmtkK3hDWG9SdVpS?=
 =?utf-8?B?Vnc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6531def-d0fb-41c1-1cfa-08dacc11b7dc
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 22:42:51.3603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EoUsslARE/0evYfEg64M2q7RCRIzXKfGqwhwbj+ulkCoSpzuXdt6ZdFpXZ3OS9yP6oVylxo2eAld/Tttj+WlXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6698
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 14:44, Vladimir Oltean wrote:
> Hi Sean,
> 
> On Mon, Nov 21, 2022 at 01:38:31PM -0500, Sean Anderson wrote:
>> On 11/17/22 19:01, Vladimir Oltean wrote:
>> > Compared to other solutions
>> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> > 
>> > Sean Anderson, in commit 5d93cfcf7360 ("net: dpaa: Convert to phylink"),
>> > sets phylink_config :: ovr_an_inband to true. This doesn't quite solve
>> > all problems, because we don't *know* that the PHY is set for in-band
>> > autoneg. For example with the VSC8514, it all depends on what the
>> > bootloader has/has not done. This solution eliminates the bootloader
>> > dependency by actually programming in-band autoneg in the VSC8514 PHY.
>> 
>> I tested this on an LS1046ARDB. Unfortunately, although the links came
>> up, the SGMII interfaces could not transfer data:
>> 
>> # dmesg | grep net6
>> [    3.846249] fsl_dpaa_mac 1aea000.ethernet net6: renamed from eth3
>> [    5.047334] fsl_dpaa_mac 1aea000.ethernet net6: PHY driver does not report in-band autoneg capability, assuming false
>> [    5.073739] fsl_dpaa_mac 1aea000.ethernet net6: PHY [0x0000000001afc000:04] driver [RTL8211F Gigabit Ethernet] (irq=POLL)
>> [    5.073749] fsl_dpaa_mac 1aea000.ethernet net6: phy: sgmii setting supported 0,00000000,00000000,000062ea advertising 0,00000000,00000000,000062ea
>> [    5.073798] fsl_dpaa_mac 1aea000.ethernet net6: configuring for phy/sgmii link mode
>> [    5.073803] fsl_dpaa_mac 1aea000.ethernet net6: major config sgmii
>> [    5.075369] fsl_dpaa_mac 1aea000.ethernet net6: phylink_mac_config: mode=phy/sgmii/Unknown/Unknown/none adv=0,00000000,00000000,00000000 pause=00 link=0 an=0
>> [    5.102308] fsl_dpaa_mac 1aea000.ethernet net6: phy link down sgmii/Unknown/Unknown/none/off
>> [    9.186216] fsl_dpaa_mac 1aea000.ethernet net6: phy link up sgmii/1Gbps/Full/none/rx/tx
>> [    9.186261] fsl_dpaa_mac 1aea000.ethernet net6: Link is Up - 1Gbps/Full - flow control rx/tx
>> 
>> I believe this is the same issue I ran into before. This is why I
>> defaulted to in-band.
> 
> Thanks for testing. Somehow it did not come to me that this kind of
> issue might happen when converting a driver that used to use ovr_an_inband
> such as dpaa1, but ok, here we are.
> 
> The problem, of course, is that the Realtek PHY driver does not report
> what the hardware supports, and we're back to trusting the device tree.
> 
> I don't think there were that many more PHYs used on NXP evaluation
> boards than the Realteks, but of course there are also customer boards
> to consider. Considering past history, it might be safer in terms of
> regressions to use ovr_an_inband, but eventually, getting regression
> reports in is going to make more PHY drivers report their capabilities,
> which will improve the situation.

Are you certain this is the cause of the issue? It's also possible that
there is some errata for the PCS which is causing the issue. I have
gotten no review/feedback from NXP regarding the phylink conversion
(aside from acks for the cleanups).

> Anyways, we can still keep dpaa1 unconverted for now, and maybe convert
> it for the next release cycle.
> 
> I also thought of a way of logically combining ovr_an_inband with
> sync_an_inband (like say that ovr_an_inband is a "soft" override, and it
> only takes place if syncing is not possible), but I'm not sure if that
> isn't in fact overkill.
>
> Could you please test the patch below? I only compile-tested it:
> 
> -----------------------------[ cut here ]-----------------------------
> From 025f8dedf10defa6d5fd10b4e3dd2a505fdbd313 Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Mon, 21 Nov 2022 21:34:20 +0200
> Subject: [PATCH] net: phy: realtek: validate SGMII in-band autoneg for
>  RTL8211FS
> 
> Sean Anderson reports that the RTL8211FS on the NXP LS1046A-RDB has
> in-band autoneg enabled, and this needs to be detectable by phylink if
> the dpaa1 driver is going to use the sync_an_inband mechanism rather
> than forcing in-band on via ovr_an_inband.
> 
> Reading through the datasheet, it seems like the SGMII Auto-Negotiation
> Advertising Register bit 11 (En_Select Link Info) might be responsible
> with this.

This is used for SGMII to RGMII bridge mode (figure 4). It doesn't seem
to contain useful information for UTP mode (figure 1).

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/phy/realtek.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 3d99fd6664d7..53e7c1a10ab4 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -24,6 +24,10 @@
>  
>  #define RTL821x_INSR				0x13
>  
> +#define RTL8211FS_SGMII_ANARSEL			0x14
> +
> +#define RTL8211FS_SGMII_ANARSEL_EN		BIT(11)
> +
>  #define RTL821x_EXT_PAGE_SELECT			0x1e
>  #define RTL821x_PAGE_SELECT			0x1f
>  
> @@ -849,6 +853,30 @@ static irqreturn_t rtl9000a_handle_interrupt(struct phy_device *phydev)
>  	return IRQ_HANDLED;
>  }
>  
> +/* RTL8211F and RTL8211FS seem to have the same PHY ID. We really only mean to
> + * run this for the S model which supports SGMII, so report unknown for
> + * everything else.
> + */
> +static int rtl8211fs_validate_an_inband(struct phy_device *phydev,
> +					phy_interface_t interface)
> +{
> +	int ret;
> +
> +	if (interface != PHY_INTERFACE_MODE_SGMII)
> +		return PHY_AN_INBAND_UNKNOWN;
> +
> +	ret = phy_read_paged(phydev, 0xd08, RTL8211FS_SGMII_ANARSEL);

That said, you have to use the "Indirect access method" to access this
register (per section 8.5). This is something like

#define RTL8211F_IAAR				0x1b
#define RTL8211F_IADR				0x1c

#define RTL8211F_IAAR_PAGE			GENMASK(15, 4)
#define RTL8211F_IAAR_REG			GENMASK(3, 1)
#define INDIRECT_ADDRESS(page, reg) \
	(FIELD_PREP(RTL8211F_IAAR_PAGE, page) | \
	 FIELD_PREP(RTL8211F_IAAR_REG, reg - 16))

	ret = phy_write_paged(phydev, 0xa43, RTL8211F_IAAR,
			      INDIRECT_ADDRESS(0xd08, RTL8211FS_SGMII_ANARSEL));
	if (ret < 0)
		return ret;

	ret = phy_read_paged(phydev, 0xa43, RTL8211F_IADR);
	if (ret < 0)
		return ret;

I dumped the rest of the serdes registers using this method, but I
didn't see anything interesting (all defaults). I think it would be
better to just return PHY_AN_INBAND_ON when using SGMII.

--Sean

> +	if (ret < 0)
> +		return ret;
> +
> +	phydev_err(phydev, "%s: SGMII_ANARSEL 0x%x\n", __func__, ret);
> +
> +	if (ret & RTL8211FS_SGMII_ANARSEL_EN)
> +		return PHY_AN_INBAND_ON;
> +
> +	return PHY_AN_INBAND_OFF;
> +}
> +
>  static struct phy_driver realtek_drvs[] = {
>  	{
>  		PHY_ID_MATCH_EXACT(0x00008201),
> @@ -931,6 +959,7 @@ static struct phy_driver realtek_drvs[] = {
>  		.resume		= rtl821x_resume,
>  		.read_page	= rtl821x_read_page,
>  		.write_page	= rtl821x_write_page,
> +		.validate_an_inband = rtl8211fs_validate_an_inband,
>  	}, {
>  		PHY_ID_MATCH_EXACT(RTL_8211FVD_PHYID),
>  		.name		= "RTL8211F-VD Gigabit Ethernet",
