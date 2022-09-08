Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180135B2815
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 23:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiIHVEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 17:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIHVEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 17:04:07 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2062.outbound.protection.outlook.com [40.107.105.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25265E3D7C;
        Thu,  8 Sep 2022 14:04:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHYIFIUZC63zCOdn0duPwEaVo9SBZvBqL0QtNhAxzY9a/T1fKF5NFcxuRjNU8Uw3VSizNYL0s9szY1lXG8TV6CB+ahwBtGop9w9thXv5Rb1+rABlTp1Oq/ccml6aJkT0+JsRUCbdwIokwD22Y00tysekF0GDxEilmxohV2vsU0HF9tyR0spTzcFzvhPPg58+xivSXvznUQV4chy/3ExCYzPun5afm/vBPXqF+Wxwkh1jadxJV78tkNxfQBcLvIxcJkY2eMLCI8NzXBHQUCAf9RXBbdd/ZkMhW6pJ+CU4HRPovtSAY8ca5p9S0SZsknj82Y6hlopbu79hegQbrwqYgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCSWG16+FmhICIODowVZF03tc0tgDffG8pPNOV6YNWk=;
 b=MWGHELLqzdWkK0SVzYX64ah4JnWiVwU56BGalZ4iE314vf/PxI5cH3fdpnX2BJOcLfcT9946wVwhvbGj+Y7dZWoGWRobLSBDD4qO3QoSjdnf+GLhBMhKwiO966RadDLD+EU+MW6Sx/eg+bp/p814Iuae9Te3kbQDwLNBiLtM2I2INVrb6FfKdJ4WsSY33i6zccZBkv0OCeZC/ZWOEMWfuPxYKkFX/KHnfReOkSC74L4BmOqKdGTFgp0Qeto/hsVA76MJndkCpFHnr1fQHGzxWzgac8oA5X7oyoBDMIM9XIhDZjYF7i/e8fUZtSREiZ/uo9hGNeBfViXuT11eJW8jGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCSWG16+FmhICIODowVZF03tc0tgDffG8pPNOV6YNWk=;
 b=ELvMfz/QJKtFKU91IB6XKGgEKReSA3lTQeJxO32O+oQi7j1kTkMXx1+YWngVRW59AKo3iqEU1HdzCftaDGpyPrBLy9idm1sTZj6ewSc7119/iawAXejSx92g9wmbhoXTyW1yubnXoDX31690XGsvFXrhUdNrB5UEQlA8FZEQeLdR4OfhkuncJJvjE+bAqNDZ+hZ3/qPk56X1HMEOvRQ7nXobeEx9SvxlS98MSLhLMAOJV5D+PHu6J+bqhKIEny+bBpvd4iSbaK7PSp0kJr7zkehhghnt7ZgY35/G9THUV4IzNVqX2nQizl3tel2NjcZzuzqWLT3rPc40rxLr/5dCkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5459.eurprd03.prod.outlook.com (2603:10a6:20b:ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.18; Thu, 8 Sep
 2022 21:04:00 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Thu, 8 Sep 2022
 21:04:00 +0000
Subject: Re: [PATCH net-next v5 1/8] net: phylink: Document MAC_(A)SYM_PAUSE
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-2-sean.anderson@seco.com>
 <YxhmnVIB+qT0W/5v@shell.armlinux.org.uk>
 <8cf0a225-31b7-748d-bb9d-ac4bbddd4b6a@seco.com>
 <YxjdQzEFlJPQMkEl@shell.armlinux.org.uk>
 <745dfe6a-8731-02cc-512a-b46ece9169ed@seco.com>
 <YxkGr611ZA1EF58N@shell.armlinux.org.uk>
 <0186263e-bcb6-d144-5e6d-23400179ca38@seco.com>
 <Yxn6erbqg6AJNoAw@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <14dea2bf-91fe-e6db-5031-b7078f0dfe88@seco.com>
Date:   Thu, 8 Sep 2022 17:03:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <Yxn6erbqg6AJNoAw@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P223CA0009.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::14) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6434e013-7da9-4b11-c326-08da91dda6f7
X-MS-TrafficTypeDiagnostic: AM6PR03MB5459:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DPCGAkjhyyivhkM4iCVW1aD5SxcabZXaetYuz3atuqzt1gPXpncjfXjpjxU0m/MK9dUCezMSu4XO4FqrO9K5/0yc5DYGQgSvLkSfYekPOLgos95oa/WWaz244s3qlNl3Yiczj7ywyJIlISQ8C00ht9mFywP/CMTRRVfTdRJf3qPwsBAT8FWpwNEVBoE8XPiY661cSObmHwrzS4LfcJQyNSjUFAydoUfE+RHBrq5yGIoLJifWudriqyzBi4FWTreg1AlIKT6A47OTSWHeQIXN5FF7zkTYeeAJJAoI7D65VKdMOJmDB5XXak37mZgPP+l5vr3yOMsmLprnyhSWoob6Km23LpnpQ16wesjvKyDdHqaYDTF9MjW+mWexVergJAoeDrxgNUPHaRGzHidV9x/DO8bQJA/MBUdNfPAowap6rMXgsr2Ef+RaFOUflfGekyU8VwF+kW4VfBzryic23Cyfac3V89etf1aUOHl5uSlxhnttaUP56dWzdOxCjxZ6tHuNd/cqhyolzoMreXAMCCewM4sLBwinDj/2pLQD4gCwCPDMZQ4b7mHXIzz1G8xBm1cKXS1JIMwZW0/NXAyzZMSt8uPgGWfB46b38sR7BsdYX5l5QxgQXGZb3oeMq8CENITWX8hcCUV8p9hJ0iSm8/0mGKwbQ7qG32fFu7QIQJ0InilR52QvPqYQvk4tUF6QG1brCMeAQ7yE6CdfXgvkqa1ve/1vjoZkzkgZCbVsyPrnvA3zhUYdgFZo2G+LRxpWRJ3tZyJliUanx2VLcHOTi5CmMa4w/Xqew2lXuOuVkQ6ADv2CXVrkeKSdOnQurM4HmhvnKi57pVfgp3pb1lUkPae+kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(396003)(376002)(366004)(6486002)(478600001)(41300700001)(316002)(83380400001)(54906003)(186003)(36756003)(31686004)(6916009)(2616005)(38100700002)(38350700002)(66946007)(66556008)(6506007)(4326008)(8676002)(5660300002)(66476007)(6666004)(52116002)(53546011)(6512007)(8936002)(26005)(44832011)(2906002)(31696002)(7416002)(30864003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TU8wRTVyVE4wdXJTNFN4MzFWZXRWeXF4bnZnZWd2SjNabjMzQXp3Nk9KVkhR?=
 =?utf-8?B?eXBpUndDRnJjTEI5ZjFMd2I1TEk2VVFleCsvbS94MzhkN2ZUYkFGcXZmR2lQ?=
 =?utf-8?B?MVIwLy8wV21STmRpbUtSTCt3bWxkR0s0RnZZeGR6VWNZSys5WEtpUW1xckxF?=
 =?utf-8?B?RitBZHNGZWE1QUNwS0JKaG9pVGtYekNHUVQyTHNWaEYwNkhvaTRaWDJMK0Ev?=
 =?utf-8?B?U0MyT0pQYlpxRzJoemZWcmJWM3NLcCtJT0pOSlppTVF5aXE2Vy9uR1c3ZzV4?=
 =?utf-8?B?WkxjOG5QRXd0ci9YSDNyb0Zlc010cGxmdVFzaDdhMzdnNTB4aHdzL3pRZE1K?=
 =?utf-8?B?Z09raERHRFlBQ2xIMnVzM3d6dWE1azBNMk9nS243MnVaQmpoTXhmbzdESGFu?=
 =?utf-8?B?djhscmwwdE1scDFKc01sNExpa1orSmxxL0s4RFFzanZuMVV4aWg1cVRWYTZk?=
 =?utf-8?B?MitOUkU1d0RoMUI3SzRUMTJiTFdtRTlCTVBqNG9SVDBJenJxT25LaU9WVTBx?=
 =?utf-8?B?enJpdy9hM29mMUhHRm96TGY1YjhXOXBQcnJpRUg1S3k4a1JCeG1GQXlING5R?=
 =?utf-8?B?V0Z1ZnVNUk5FdmpCM3Q4MmJvaldGS1EwaFllR2J4MjkwNGdLUUhaSTZHOFdt?=
 =?utf-8?B?ZVkwaUk2ZWc1d1l6YUVhS2w5Z2J1T3dBZjg5bDNjVEFZR3VWMU50MU9GMGhF?=
 =?utf-8?B?RExjVzl5dU9VQmhRR1hCU015Qnd1OXFtRXpHTUNYTlNQREEyQ29obXkzb1VR?=
 =?utf-8?B?NCtubm9BNkRHTXgyVThZUjI4Wk9Gbm5tMThjYmMxYzJPc3dXM2M4OGpUUjNz?=
 =?utf-8?B?MlRzT2xTekhyN3g5Nk9pOUJJTzl5Q0NrYmY1WStuaHV3N2NMQkx4WG42NjZx?=
 =?utf-8?B?cjNjdzNMVzlpTGN0ckxCa3JOTGlNdS9GUFNZZmRONUNnRURiMG1GWCtQckdU?=
 =?utf-8?B?VnpzeEx5MzdFRXVMTW14VGN2dEdtNmFRVGpJOU44THFFY0duc1JObGRVYU11?=
 =?utf-8?B?bStsQXpzSjVxdU4rYXJzV1haVVZna0xHV04vM0V6R2dVbUthVS82dmFOMXd5?=
 =?utf-8?B?V3J0VXNkcFpMRUFhSml2cUhOdjdsdmpsU2gwalJFRmxHSlNRM0ppcnFsUWZ6?=
 =?utf-8?B?MVBIMm9RRUVIMmdZY1lLUDFRT2dCSDJuNXRMM1Y1aXBwN2p1TWkwRnROMGsz?=
 =?utf-8?B?eFFaeE4rdWxOeEhmVDYrZFNDa3JuZzg1NDdJM2Z0Z3l0Qk5VSWdCSVdMbDA5?=
 =?utf-8?B?Y21nclFWNUZwMnpDcXVpNnl1bU5QbEhTSnFoT3ZWNlFIZWdOdDZ2cS9BWUlY?=
 =?utf-8?B?bmV5VlZRbnBNa1pZdWFDbE5YR3VVdEhWelM2elBwWHJzRWxlVmI1Y1hlVWdX?=
 =?utf-8?B?dWpvLzhkVDZTZE9pVmtNemJsd3VOcmljLzRhTDBWcGRjaURJY21qRFJFaEFn?=
 =?utf-8?B?WmVuVEtxaTZWZTEwNG00RDA0YW9wcWV2WThIdWZTWWJFTkUzYmVBZzRWR0xu?=
 =?utf-8?B?UlZzY2hVVStqSHFERTRxWURvWDB4TElGaWlGTFM2NThEamw2RWFGa3hvZ3RE?=
 =?utf-8?B?d3dQSDVmeVRaVnRxYWpYMHF5ZCswWXIxVEJMbk83ekNuMVJYak5aTEpMVXdi?=
 =?utf-8?B?Vmp1WnMyd0Iya0p0MkRXbVRHL3p6Nm9zYXNXWXZvcyt3SVR1bGNoYTE4MDM5?=
 =?utf-8?B?RTB2QmhMU2tnU2ttenlKYTBQK1MxcUVHUTc3WnRtdCthUFZHQ2NHc0xxSWly?=
 =?utf-8?B?Zi9WOVVFeHJwSzIrRmV4ZGJ3RDFMMVQzTW9aL3BOclNjSFpTU0RiT2VONXYy?=
 =?utf-8?B?cW5mWFRuWVJ4bnBrMVMvb3d1dDhmWjkvejFBZTcxZXZ6eVpPYzRjaHdlak55?=
 =?utf-8?B?elVNaTJnVmZlVmxJWUNLT0loRmZVZncxOVFrNEpjbXJqTzliY2wyWGNBK3JT?=
 =?utf-8?B?SytCcjB4YWI3dzlCOE9EaWlONTNYRmF6MFQ3M2JKS0RSTkdudFFISUdmTTBQ?=
 =?utf-8?B?d1J4ZlpLaDcrcm5jUGlNZGFEdnoyZC9JZ3UrVkhXNVdZMHZRVWJLOGNqUDJS?=
 =?utf-8?B?QmhzR3FmUHc5Uyt3STFBNFpaZU1YWGhwL21Dc1U3NGpPZUl0N0s5NzBUT1hl?=
 =?utf-8?B?alg5bHZlRkNJbm1sUEFOMEZ6Sk53QkErSXk3TkUvMm80VTFTeG55SVZBa1k0?=
 =?utf-8?B?ZlE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6434e013-7da9-4b11-c326-08da91dda6f7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 21:04:00.3901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4rJtt5HrnaRpNbf3vnZZ6ytQo4MjADCfGdDzmHsqads5DVzB7uHJxoACVKfoxE+hZtXKdaoXGPsOguGe/nYaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5459
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/22 10:21 AM, Russell King (Oracle) wrote:
> On Wed, Sep 07, 2022 at 06:39:34PM -0400, Sean Anderson wrote:
>> On 9/7/22 17:01, Russell King (Oracle) wrote:
>> > On Wed, Sep 07, 2022 at 04:11:14PM -0400, Sean Anderson wrote:
>> > > On 9/7/22 2:04 PM, Russell King (Oracle) wrote:
>> > Given that going from tx/rx back to pause/asym_dir bits is not trivial
>> > (because the translation depends on the remote advertisement) it is
>> > highly unlikely that the description would frame the support in terms
>> > of whether the hardware can transmit and/or receive pause frames.
>> 
>> I think it is? Usually if both symmetric and asymmetric pause is
>> possible then there are two PAUSE_TX and PAUSE_RX fields in a register
>> somewhere. Similarly, if there is only symmetric pause, then there is a
>> PAUSE_EN bit in a register. And if only one of TX and RX is possible,
>> then there will only be one field. There are a few drivers where you
>> program the advertisement and let the hardware do the rest, but even
>> then there's usually a manual mode (which should be enabled by the
>> poorly-documented permit_pause_to_mac parameter).
> 
> The problem with "if there is only symmetric pause, then there is a
> PAUSE_EN bit in a register" is that for a device that only supports
> the ability to transmit pause, it would have a bit to enable the
> advertisement of the ASM_DIR bit, and possibly also have a PAUSE_EN
> bit in a register to enable the transmission of pause frames.
> 
> So if you look just at what bits there are to enable, you might
> mistake a single pause bit to mean symmetric pause when it doesn't
> actually support that mode.

Sure, but usually that is noted in the documentation.

> Let's take this a step further. Let's say that a device only has the
> capability to receive pause frames. How does that correspond with
> the SYM (PAUSE) and ASYM (ASM_DIR) bits? The only state that provides
> for receive-only mode is if both of these bits are set, but wait a
> moment, for a device that supports independent control of transmit
> and receive, it's exactly the same encoding!
> 
> Fundamentally, a device can not really be "only capable of receiving
> pause frames" because there is no way to set the local advertisement
> to indicate to the remote end that the local end can not send pause
> frames.

Yup. Only half of the combinations can be expressed.

> The next issue is... how do you determine that a MAC that supports
> transmission and reception of pause frames has independent or common
> control of those two functions? That determines whether ASM_DIR can
> be set along with PAUSE.

This is why I suggested down below that we encode exactly that in the
mac caps.

> So, trying to work back from whether tx and rx are supported to which
> of PAUSE and ASM_DIR should be set is quite a non-starter.
> 
>> However, it is not obvious (at least it wasn't to me)
>> 
>> - That MAC_SYM_PAUSE/MAC_ASYM_PAUSE control to the PAUSE and ASYM_DIR
>>   bits (when MLO_PAUSE_AN is set).
> 
> I'm not sure why, because the linkmodes that the MAC deals with in
> its validate() callback determine what is supported and what is
> advertised, and phylink_caps_to_linkmodes() which is used in the
> implementation of this method does:
> 
>         if (caps & MAC_SYM_PAUSE)
>                 __set_bit(ETHTOOL_LINK_MODE_Pause_BIT, linkmodes);
> 
>         if (caps & MAC_ASYM_PAUSE)
>                 __set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, linkmodes);
> 
> Were you not aware that these two ethtool link mode bits control
> the advertisement?

Yes. I had to dig into the code to determine what these bits were for.
Since there is no documentation (which what this patch aims to address),
that really is the only option. Additionally, the terminology is
different from what IEEE uses (although IMO it better describes the
function of the bits).

>> - How MAC_*_PAUSE related to the resolved pause mode in mac_link_up.
>> 
>> > Note from the table above, it is not possible to advertise that you
>> > do not support transmission of pause frames.
>> 
>> Just don't set either of MAC_*_PAUSE :)
>> 
>> Of course, hardware manufacturers are hopefully aware that only half of
>> the possible combinations are supported and don't produce hardware with
>> capabilities that can't be advertised.
> 
> Well, having read a few (although limited) number of documents on
> ethernet MACs, they tend to frame the support in terms of whether
> symmetric pause being supported or just the whole lot. Given that
> IEEE 802.3's starting point for pause frames is the advertisement
> rather than whether the hardware supports transmission or
> reception, I think it would be rather silly to specify it in terms
> of the tx/rx support.
> 
> If one's reverse engineering, then I think it's reasonable that if
> you determine what the capabilities of the hardware is, it's then
> up to the reverse engineer to do the next step and consult 802.3
> table 28B-3 and work out what the advertisement should be.
> 
>> > > > The following table lists the values of tx_pause and rx_pause which
>> > > > might be requested in mac_link_up depending on the results of> autonegotiation (when MLO_PAUSE_AN is set):>
>> > > > MAC_SYM_PAUSE MAC_ASYM_PAUSE tx_pause rx_pause
>> > > > ============= ============== ======== ========
>> > > >              0              0        0        0
>> > > >              0              1        0        0>                                     1        0
>> > > >              1              0        0        0
>> > > >                                      1        1>             1              1        0        0
>> > > >                                      0        1
>> > > >                                      1        1
>> > > > 
>> > > > When MLO_PAUSE_AN is not set, any combination of tx_pause and> rx_pause may be requested. This depends on user configuration,
>> > > > without regard to the values of MAC_SYM_PAUSE and MAC_ASYM_PAUSE.
>> > 
>> > The above is how I'm viewing this, and because of the broken formatting,
>> > it's impossible to make sense of, sorry.
>> 
>> Sorry, my mail client mangled it. Second attempt:
>> 
>> > MAC_SYM_PAUSE MAC_ASYM_PAUSE tx_pause rx_pause
>> > ============= ============== ======== ========
>> >             0              0        0        0
>> >             0              1        0        0
>> >                                     1        0
>> >             1              0        0        0
>> >                                     1        1
>> >             1              1        0        0
>> >                                     0        1
>> >                                     1        1
> 
> That's fine for the autonegotiation resolution, but you originally stated
> that your table was also for user-settings as well - and that's where I
> originally took issue and still do.
>
> As I've tried to explain, for a MAC that supports the MAC_SYM_PAUSE=1
> MAC_ASYM_PAUSE=1 case, the full set of four states of tx_pause and
> rx_pause are possible to configure when autoneg is disabled _even_
> when there is no way to properly advertise it.

I assume you wrote this before reading the below.

> The point of forcing the pause state is to override autonegotiation,
> because maybe the autonegotiation state is wrong and you explicitly
> want a particular configuration for the link.
> 
>> > So, if a MAC only supports symmetric pause, it can key off either of
>> > these two flags as it is guaranteed that they will be identical in
>> > for a MAC that only supports symmetric pause.
>> 
>> OK, so taking that into account then perhaps the post-table explanation
>> should be reworded to
>> 
>> > When MLO_PAUSE_AN is not set and MAC_ASYM_PAUSE is set, any
>> > combination of tx_pause and rx_pause may be requested. This depends on
>> > user configuration, without regard to the value of MAC_SYM_PAUSE. When
>> > When MLO_PAUSE_AN is not set and MAC_ASYM_PAUSE is also unset, then
>> > tx_pause and rx_pause will still depend on user configuration, but
>> > will always equal each other.
>> 
>> Or maybe the above table should be extended to be
>> 
>> > MLO_PAUSE_AN MAC_SYM_PAUSE MAC_ASYM_PAUSE  tx_pause rx_pause
>> > ============ ============= ==============  ======== ========
>> >            0             0              0         0        0
>> >            0             0              1         0        0
>> >                                                   1        0
>> >            0             1              0         0        0
>> >                                                   1        1
>> >            0             1              1         0        0
>> >                                                   0        1
>> >                                                   1        1
>> >            1             0              0         0        0
>> >            1             X              1         X        X
>> >            1             1              0         0        0
>> >                                                   1        1
>> 
>> With a note like
>> 
>> > When MLO_PAUSE_AN is not set, the values of tx_pause and rx_pause
>> > depend on user configuration. When MAC_ASYM_PAUSE is not set, tx_pause
>> > and rx_pause will be restricted to be either both enabled or both
>> > disabled. Otherwise, no restrictions are placed on their values,
>> > allowing configurations which would not be attainable as a result of
>> > autonegotiation.
>> 

These options are what I propose to do with the table. I think these address
your concern that user-specified behavior was not documented properly. Upon
review, I think using the first table with the second note would be best.

>> IMO we should really switch to something like MAX_RX_PAUSE,
>> MAC_TX_PAUSE, MAC_RXTX_PAUSE and let phylink handle all the details of
>> turning that into sane advertisement.
> 
> I completely disagree for the technical example I gave above, where it
> is impossible to advertise "hey, I support *only* receive pause". Also
> it brings with it the issue that - does "MAC_RXTX_PAUSE" mean that the
> MAC has independent control of transmit and receive pause frames, or
> is it common.
> 
> I'm really sorry, but I think there are fundamental issues with trying
> to frame the support in terms of "do we support transmission of pause
> frames" and "do we support reception of pause frames" and working from
> that back to an advertisement. The translation function from
> capabilities to tx/rx enablement is a one-way translation - there is
> no "good" reverse translation that doesn't involve ambiguity.

Of course. But this reflects what the hardware actually can do.

>> This would also let us return
>> -EINVAL in phylink_ethtool_set_pauseparam when the user requests e.g.
>> TX-only pause when the MAC only supports RX and RXTX.
> 
> As I've said, there is no way to advertise to the link partner that
> RX-only is the only pause setting allowed, so it would be pretty
> darn stupid for a manufacturer to design hardware with just that
> capability..

Well, when the user specifies things we ignore the results of
autonegotiation. So a user could specify tx only on one end of a link
and rx only on the other end and have a working result which couldn't
be the result of autonegotiation. By specifying what the hardware
actually supports, phylink can determine whether what the user requests
is supported, without regard to whether it could be autonegotiated. At
the moment we allow the user to specify configurations which might not
be supported at all. There is no error message when this happens, so a
user can only discover this issue by reading the driver/datasheet or by
sniffing the link traffic.

>> > Adding in the issue of rate adaption (sorry, I use "adaption" not
>> > "adaptation" which I find rather irksome as in my - and apparently
>> > a subsection of English speakers, the two have slightly different
>> > meanings)
>> 
>> 802.3 calls it "rate adaptation" in clause 49 (10GBASE-R) and "rate
>> matching" in clause 61 (10PASS-TL and 2BASE-TS). If you are opposed to
>> the former, then I think the latter could also work. It's also shorter,
>> which is definitely a plus.
>> 
>> Interestingly, wiktionary (with which I attempted to determine what that
>> slightly-different meaning was) labels "adaption" as "rare" :)
> 
> I'm aware of that, but to me (and others) adaption is something that is
> on-going. Adaptation is what animals _have_ done to cope with a changing
> environment.
> 
> For this feature, I much prefer "rate matching" which avoids this whole
> issue of "adaption" vs "adaptation" - you may notice that when we were
> originally discussing this, I was using "rate matching" terminology!

OK, I'll rename this in the next spin.

>> > brings with it the problem that when using pause frames,
>> > we need RX pause enabled, but on a MAC which only supports symmetric
>> > pause, we can't enable RX pause without also transmitting pause frames.
>> > So I would say such a setup was fundamentally mis-designed, and there's
>> > little we can do to correct such a stupidity. Should we detect such
>> > stupidities? Maybe, but what then? Refuse to function?
>> 
>> Previous discussion [1]. Right now we refuse to turn on rate adaptation
>> if the MAC only supports symmetric pause. The maximally-robust solution
>> would be to first try and autonegotiate with rate adaptation enabled and
>> using symmetric pause, and then renegotiate without either enabled. I
>> think that's significantly more complex, so I propose deferring such an
>> implementation to whoever first complains about their link not being
>> rate-adapted.
> 
> We can not get away from the fact that the only capabilities that a
> MAC could advertise to say that it supports Rx-only pause mode is
> one where it has both the PAUSE and ASM_DIR bits set. If it doesn't,
> then, if you look at table 28B-3, there are no possible resolutions
> to any other local advertisement state that result in Rx pause only
> being enabled.

Well, what we really want to advertise is MLO_PAUSE_TXRX *without*
MLO_PAUSE_NONE. This is of course not possible to advertise, hence
the retry approach I suggested above.

> Therefore, a MAC that only supports Rx pause would be incapable
> of properly advertising that fact to the remote link partner and
> is probably not conformant with 802.3.

Autonegotiation is optional for pause support. I agree that such an
implementation would be unusual.

> I'll also point you to table 28B-2 "Pause encoding":
> 
> |   PAUSE (A5)   ASM_DIR (A6)                   Capability
> |   0            0            No PAUSE
> |   0            1            Asymmetric PAUSE toward link partner
> |   1            0            Symmetric PAUSE
> |   1            1            Both Symmetric PAUSE and Asymmetric PAUSE toward
> |                             local device
> |
> | The PAUSE bit indicates that the device is capable of providing the
> | symmetric PAUSE functions as defined# in Annex 31B. The ASM_DIR bit
> | indicates that asymmetric PAUSE is supported. The value of the PAUSE
> | bit when the ASM_DIR bit is set indicates the direction the PAUSE
> | frames are supported for flow across the link. Asymmetric PAUSE
> | configuration results in independent enabling of the PAUSE receive
> | and PAUSE transmit functions as defined by Annex 31B. See 28B.3
> | regarding PAUSE configuration resolution.
> 
> So here, the capabilities of the local device are couched in terms of
> support for "symmetric pause" and "asymmetric pause" and not whether
> they support transmission of pause frames and reception of pause frames.
> 
> I put it that the use of "is symmetric pause supported" and "is
> asymmetric pause supported" by phylink is the right set of capabilities
> that the MAC should be supplying, and not whether transmission and or
> reception of pause frames is supported.

Well the funky bit is that one can say "I support *only* asymmetric pause"
which is pretty strange. By the above logic, devices supporting asymmetric
pause should be a strict subset of those supporting symmetric pause. And
yet it is not the case. IEEE has decided that this means tx-only devices.
We have some devices like this in Linux already (ksz8795, macb). IMO this
hijacking of meaning is precisely what needs to be documented, and also
makes the symmetric/asymmetric pause distinction less useful.

> As I've pointed out, one can not go from tx and rx pause support to an
> advertisement without ambiguity. That is why we can't advertise a
> correct setting of PAUSE and ASM_DIR bits when using ethtool to
> force a particular state of enables at the local end. To move to
> using "is transmit pause supported" and "is receive pause supported"
> will only _add_ ambiguity, and then we really do need documentation
> to describe the behaviour we implement - because we then fall outside
> of 802.3.

It removes ambiguity from the driver author's perspective. The ambiguity
then shifts to phylink_caps_to_linkmodes, which can handle the translation.

In any case, since you prefer the underspecified representation then go
ahead and keep using it.

--Sean
