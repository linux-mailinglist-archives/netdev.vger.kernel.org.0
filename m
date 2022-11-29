Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE85763C524
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbiK2Q3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiK2Q3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:29:51 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2045.outbound.protection.outlook.com [40.107.105.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0595A6EE;
        Tue, 29 Nov 2022 08:29:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AmUP9XCwiu4bD9GvAt3vbv71eemyIZ6f8pWmu2Gd/SOOIdbxW0nlGJQxB3k8/W+jsWRf/R60mCPuO207/WbWX0fMYOFsFLs/HXdayI/nxv4LCCpjG5tjzzZkshHM6hO9wJpbsDtSE/EylKLPGDOTn/Y0IDJ7BnAwmQ0VrFw47WOhZP2TvLVLr2T/4XkgRTYsmyMnVUPFXKsCBU6GWzarZ+kbygg7lE1EOVnIO/Btw4uEBoYJF28BI7Kf/zLZi9EnWQTBLUSthn1wMUJLpSk0fVPbaTXSbCixog98x3BFJoFaRgks1EskXhjRPnI+2V9V4EgJ0WET3vICUu+inzIUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zwj288GVMiWeQrXDdbTk9mSctYlTynKvIdmh8bOuh/E=;
 b=C78vJQ9rYH6Y35RqEZHcI4Nd0BxCjuxOEfdM9pF9Y5szA8mY8m54umaClKB0qW81Kg2rAwmBBa/TYStn7fjWtirvJmijJaJj0tnWPqtSUCTAYQg8ZhFq7FSZBDASX+kgmeC2fdrQofWO+UOTy9wZ+B6Gojju86VrEWG5KwqsT98HtXTupp00lmWAqb6isUHGO9DUbs9vTEW5k14DPbdAFUaj2idKYNV2FlMNJ14j8XqAYW+T62CX1jRIibaL5xrEaFcQONmQZ2xfobb78XFSO7zXtrBETBwbcRA8pV8e5rLsLKXnUU2JJIO6B8PfuBgWPAT0YxlnhagzKd/zsO6XjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zwj288GVMiWeQrXDdbTk9mSctYlTynKvIdmh8bOuh/E=;
 b=TuW3mgwwO7mHJjJdWf08RHS7BhO2c43a+VP5I6ok+RqYRO/jAwqyFUwAdNbyhsGBsescW/qUpEGI3gpWJR8VR5aCyOie/mxPhmThjgwFMve/f9gb5mzaCvcbeZyMhE+/mYW9XYXj0/AXj4a4OyzwTWl2vDuHz86LgQqofhqS6TQhiNIPsylipqbzebYuJ2rbm/6dGpaAT+1FtpviNolSD4HdnIUqOME5D0Efndi2WWhojDEXsnpxoEWvHJRnz68m4exxQASJZjzgShHWlNSDGX7yeNi8OBnwnHCg2vQOEds306yitMOz235g2mMh029SILCBaV7/HiquN48K8B3f7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DB9PR03MB7482.eurprd03.prod.outlook.com (2603:10a6:10:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Tue, 29 Nov
 2022 16:29:47 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 16:29:47 +0000
Message-ID: <10c0545d-d9aa-8d85-e3ba-ee739cb126ef@seco.com>
Date:   Tue, 29 Nov 2022 11:29:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net v2 2/2] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20221128195409.100873-1-sean.anderson@seco.com>
 <20221128195409.100873-2-sean.anderson@seco.com>
 <Y4VCz2i+kkK0z+XY@shell.armlinux.org.uk>
 <b25b1d9b-35dd-a645-a5f4-05eb0dbc6039@seco.com>
 <Y4VVhwQqk2iwBzao@shell.armlinux.org.uk>
 <9d4db6a2-5d3f-1e2a-b60a-9a051a61b7da@seco.com>
 <Y4Ywh+0p8tfTMt0f@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y4Ywh+0p8tfTMt0f@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::8) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DB9PR03MB7482:EE_
X-MS-Office365-Filtering-Correlation-Id: a7f69ba2-4c21-4df0-eb33-08dad226ee5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nxnN7kvJ3RoFGE++xfFUaceXUL1bAcuepCfEr1GjgB9PYRe5TLeKNKTphLIr3yZb0Mj262VAB5ZrQV9tkaG3tWvluktRseAHKr9sZ5sy1kngDN/aXWh8XwgfymJNa/yWal5hkjcHXR8hWDGZ5aQux59FlNHHBHtA85RndLXn3WRM6wF5KF8kTZkWw547gtmRc5rTc01lYeBi1cuX2akMlAxrAYfY4WnWOGS37tHmUmICUmbZuNfApSNriHF2AkEk8rob6FDweH5S5lo3ToRP9i9G/5RFChWPlKZZIK1Zm0LaYMYcgNp1i11vgDRGR2RvpplV4NW0U5CsVloNwM6wKc/Dzue1AF4CiSglebgrmuChMZIBcUJBuH9v6dyU+BpuBahnE2vB7iIrZdMWxBQ0H11QTpAo2Ymw1YNKXWvZOP6CggS5poouhrAyQgSQSHxYX3TtKvEy7YVFWassaRjnU/cVroRpTzsIlSY0oDWNIzqLhozs+3kIGVJwpCt40cKvKIdRzGVwzErcMTm2MjG7oLfFZ7myKX/5uc7pMNHtkEaNOb60k+6JY01PMNbSMgi0QcFda8bNoeNtJO2ZBRUPExWBEfmecB61+vzCKR0w4ASJDfX3yhiPxWa22AtlSLivplXMZsXLmi3fyeIOjjj5B16xnFoRUGdYThHEvqmxGvBArp/tCMxts5Wk3QXoxabiNR7F1pozH0Q+x53Rmg3DqX3PbKOJrp1a+mCMdBfgA2CPEdmKo4sxdOul6e96V9PF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39850400004)(376002)(136003)(396003)(451199015)(52116002)(31686004)(478600001)(6486002)(53546011)(83380400001)(2906002)(54906003)(6916009)(38100700002)(38350700002)(5660300002)(44832011)(7416002)(66946007)(36756003)(8936002)(6506007)(86362001)(41300700001)(2616005)(8676002)(4326008)(66476007)(66556008)(26005)(6666004)(31696002)(6512007)(316002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXp0Q3dlclNhTzRNV1E5U1Rsem0vS0pYU2lESmRBRU9jUkJpeHdPY0pGeFll?=
 =?utf-8?B?ZmxlamNiQXBBaVMwM3ZXaHEvVWVqR1BFL2VtN1NGQ0tibnMzKzZ3NVNRekVC?=
 =?utf-8?B?Wm9Od095Mjg5M24xYk5JdzBac1JZYnU3UDRDOXZqMUZ4NkZIMkxIZ0lBaThN?=
 =?utf-8?B?SXRkS3BZSXlzb0FDSGxtMjFKQVVsVi9BUDlpVkVPTmlPS0ZlMHBNcEVNQ1Fp?=
 =?utf-8?B?Rkc0TWlEQWMrNDJBR2I4cUprZ1VOcDlBcGxDRHRrNU5NcE81TThoWlZFcUNq?=
 =?utf-8?B?UnlpQzZSbTlaWEZ5YytSd1BxaXo4azNZT2JFVThZWjJlMlNYUDZRWDlaajZ3?=
 =?utf-8?B?MUdBemR2eXZBVVRWVGlMWGMrNjBHbmdLMVFIdGJwamYzeFc2Z3ZKVEFxQmtR?=
 =?utf-8?B?TDVSZjllMmV0YzVCbEtEbHpRMU1GZ0owQjcwbjY2Ym5CYU9WQjU5ZUFIWUNW?=
 =?utf-8?B?ZkYybDB4TDR3Mk93Q2cyaW8zVVhVOVBuQ2ZhYjRZOFluM296TlhPR3hmWi9x?=
 =?utf-8?B?dGRPN2JaSllKTTBJTk5XSHpPZ2VZN1hyNWUwdHhUaDBsUlFNZWdqWHVJYWJy?=
 =?utf-8?B?R2NsUDhiWUlsQlVxbnd4aWwrbUpyandsallkMC8rS2NyN0xlM1hJdXhqc0Rr?=
 =?utf-8?B?b1BUK0Q5dmVTYkJWU2hQQ3l4K2x4bzhJQjl4UHJnbXFMek4zaXBHVi80bjM1?=
 =?utf-8?B?U0hKOHF3enBzOG1VaGFnYXRGVTlndEo3MTNVZldFemNGRytsdUpwbUxTc1FZ?=
 =?utf-8?B?WGh6ZFpNbmR4NEc0bStyUWkxVkJMK2t6cUdQenUxeGtnWG93VlQ0cG4wK2Ra?=
 =?utf-8?B?MmRFbXIybDQ2ZDBDa1dnZ1ZERU5GQVdSU2czbHBrREpuRXJkNU9hWXN5UVhs?=
 =?utf-8?B?NWpXZWwvSmJlMGVSejZXeEZiY01wQndOc1BaSFNCZUIrSXVDdmxTY1dyaUVG?=
 =?utf-8?B?L204aFh3M3Z4NTlGc09CV0NCTUtKNHlOdGdST3RhSUFhMFJNcTFtdEI5cXRY?=
 =?utf-8?B?bXdTNnZ6akQrTVY1YUtCb2NCbE0xZ1hIcngyOW9rYWEzRnliKzFKYUkxSmF3?=
 =?utf-8?B?SnVLS3dtS0Y5TUNNQzRCb0pWTVB4MHVUYjhTT240aUs3UEhWY2NHTXY4ZGlD?=
 =?utf-8?B?V0hnOXRjbU85Q1lxNGJveDJyY1BzS05RMW9IdGU4VHE2WHRpUVFhT2RmbVUr?=
 =?utf-8?B?RTIzY0NPTlhtSXJPVkNabEtEUm1wdlBHUGZGK2xhMzg5Q0JXdVdmSUpFZVBL?=
 =?utf-8?B?MWtyRmhhVDkxSEhkTm5NZ1lUMnVIWjBZQ2tsV2RRMFdEelljSDg0N1Zrc3BQ?=
 =?utf-8?B?V3Nnd0FKSkU1dWt6amk2ZGxJbVp4L1YvdWNTTFhKU0JyQ1ZwN1VDek82bHpa?=
 =?utf-8?B?TmpXQlR0LzJUZWl6UFg0YUVnZmo3Nm10bGFmU0tCZk12N0g3eHJZb3k0d2RW?=
 =?utf-8?B?Zi9hQVdPRXgySVQ3cDcyZXE3aXZldWEvRXVoNitGVHR4QWV2L210SnphWmtv?=
 =?utf-8?B?QzZaRGlIejljT3dTM2RmOHVId1I0anQ3RGxOT3NJbHdCTnpyRkJGMXJqeld6?=
 =?utf-8?B?YTVNT1Z4Qlg0OGRhYXF4VmpjeVRuWGZKVUR6OHMyWXNBRXNINmc4Zkc3Slps?=
 =?utf-8?B?VUU2cEZGYWxQalY4TDErRHI3bUN3cnA4QVhiUldBYmtnRFJoQVFKQi8xM1Ra?=
 =?utf-8?B?MllFcDBXNUZacy82a2V1QXhvRzkwNjVjWVh1dGVZUzRKeFE4dUNFSFVtKzFn?=
 =?utf-8?B?blVqdzc1WG9HSklGVGU5YVYrRHlHdHhuMENlQVBaU0lZZU41ZFFFZDNDbmkw?=
 =?utf-8?B?OFprQlVpbHJ5RU8yaDBmWWdSOXB4eENKNFNjU2RHMDBYWnB2QnNNVTRJWGs5?=
 =?utf-8?B?UHRYYk1OSTcvQTBiZG1xTVkreFdwT09aNVl2Z2FOOEtSSTZub1hOTERZd0lY?=
 =?utf-8?B?d2VjWkZ5RFVWMHU1dE5oWWt5TWNLN3I4NUlyTldiNGpSRFlMaXN6c3J2VTM3?=
 =?utf-8?B?SUdDYmRaNklJOE1sU0EvNklTWEl2QTRnQ3RrV3VaZitkeVExWEFWNmk5Ly9U?=
 =?utf-8?B?RXRmUEpPU2dvaDI0ZTBEczk2SEhXTktEcnhudDQ3QWNxd05YWUFMcXJXMG4x?=
 =?utf-8?B?Tzl4a0hRNEowZ3BhYzZpcU5JcFVMRW5HTEIzUm53WGU3blIyR3VaQ2JBTWtF?=
 =?utf-8?B?b2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f69ba2-4c21-4df0-eb33-08dad226ee5f
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 16:29:47.8231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5OHhQAOleaf1jhWVNVizLwv81x+KbP5I5goUryIpxVMXcmP2KTUB7K270pZfaBONMJjFd+kgPYGg50s2U2gBsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7482
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 11:17, Russell King (Oracle) wrote:
> On Tue, Nov 29, 2022 at 10:56:56AM -0500, Sean Anderson wrote:
>> On 11/28/22 19:42, Russell King (Oracle) wrote:
>> > On Mon, Nov 28, 2022 at 07:21:56PM -0500, Sean Anderson wrote:
>> >> On 11/28/22 18:22, Russell King (Oracle) wrote:
>> >> > This doesn't make any sense. priv->supported_speeds is the set of speeds
>> >> > read from the PMAPMD. The only bits that are valid for this are the
>> >> > MDIO_PMA_SPEED_* definitions, but teh above switch makes use of the
>> >> > MDIO_PCS_SPEED_* definitions. To see why this is wrong, look at these
>> >> > two definitions:
>> >> > 
>> >> > #define MDIO_PMA_SPEED_10               0x0040  /* 10M capable */
>> >> > #define MDIO_PCS_SPEED_2_5G             0x0040  /* 2.5G capable */
>> >> > 
>> >> > Note that they are the same value, yet above, you're testing for bit 6
>> >> > being clear effectively for both 10M and 2.5G speeds. I suspect this
>> >> > is *not* what you want.
>> >> > 
>> >> > MDIO_PMA_SPEED_* are only valid for the PMAPMD MMD (MMD 1).
>> >> > MDIO_PCS_SPEED_* are only valid for the PCS MMD (MMD 3).
>> >> 
>> >> Ugh. I almost noticed this from the register naming...
>> >> 
>> >> Part of the problem is that all the defines are right next to each other
>> >> with no indication of what you just described.
>> > 
>> > That's because they all refer to the speed register which is at the same
>> > address, but for some reason the 802.3 committees decided to make the
>> > register bits mean different things depending on the MMD. That's why the
>> > definition states the MMD name in it.
>> 
>> Well, then it's really a different register per MMD (and therefore the
>> definitions should be better separated). Grouping them together implies
>> that they share bits, when they do not (except for the 10G bit).
> 
> What about bits that are shared amongst the different registers.
> Should we have multiple definitions for the link status bit in _all_
> the different MMDs, despite it being the same across all status 1
> registers?

No, but for registers which are 95% difference we should at least separate
them and add a comment.

> Clause 45 is quite a trainwreck when it comes to these register
> definitions.

Maybe they should have randomized the bit orders in the first place to discourage this sort of thing :)

> As I've stated, there is a pattern to the naming. Understand it,
> and it isn't confusing.
> 

I don't have a problem with the naming, just the organization of the
source file.

--Sean
--Sean
