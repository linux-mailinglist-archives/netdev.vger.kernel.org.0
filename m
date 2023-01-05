Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F26B65F30E
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbjAERoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbjAERn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:43:56 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2077.outbound.protection.outlook.com [40.107.241.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE923E0F9;
        Thu,  5 Jan 2023 09:43:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GX1y0gNJNGBlm7jTCpL3o68Vn2imvgynROqygUFfhQqcOz2WQSO1ekIWlEMfjjfRN3kxJrod8DhHbPmsflgb4C2Gh4LfOHuKUnMjV+vnjnOSErIND2uE747BXv8+iqbxdY8gSFYF2TAUO/mmz7Z4rkq3+/yj/Nu01T3h9qqlRxR4CoOVok1dAMmE6JqO4fdHyLoM7zKeUKEXp8/b1hbJSzL8ne3YKoZff3eT+P5pnuXBlDH91PWNnZv8hfz1QkkHH/gFSZcTZVTUESJYz5grnNhYL8+AdfMUM6PAQx6zyhSr0p4zPAbjZnsoxxLtQLvQDxOEdGvzAhulY21p6j1bGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZnVNlf9j4FNQ52tQG+v4wJsO0aobPGjxQdAhhqlBD1w=;
 b=k6HuFSSVICgMasIO92y8EtxNyXTmgGOR5jp21qZLJSa4WNX4NXcwxarsyD0mvTuXVaqgR/pwX7+lY1xXg8IistO3sUhgfIBc08NGbz+iwXYL2fT58LajyY7/VlDHksSYaqJLza2fr0qT2/5YaMlWsB7VJ7yewPxBS8tNHwGJUHv2Bdink0JPSc8oEciw1+bVA6SJ6Fz4DycdlB0fPtYlcmq8PA6E2WGk6TrOULrMu9QBHyJcbuURNvZ95XBPlBuGH2b+PbDf3BeRRn+hRb9Ehhz6O27EZgrzDrn/oLY1GmwolcYjl/k/ClhnWg0yWTKUc0QXtoohWYW95o8l2tB/4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnVNlf9j4FNQ52tQG+v4wJsO0aobPGjxQdAhhqlBD1w=;
 b=2yaYPcuBXS5H8NlMgHFAFiwuEglKq3imbSHyVszmbJ4SAWUNrZeVkbjHv0Vj6OH5/1WO2m9kH7+I/Jv2BHsTJIhrAUfY5xiONm+PW1u9OkpYA6sTmwmY9+6LLrp91Q6bgGb2G+HmCp7faY+Iyfhw1M6GR2Fq6gitZepAfYSE1vHMpnCX08cxRW1cyhL3gsp0rNjoWxTm5p8ZwX0/jIAjxRgF0FlAUaFuAt/oRvRcdQX8uje6Ni9qkd+6sfh6WPQBfKjOQkqQPoHgSMjs81o86jEaNVSjrpYVwGDVuVqwgWmDQ7d+h6QBpXMfldI3uk3rB5Vz5bg9C1pIYAFrD3RIxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PAXPR03MB8273.eurprd03.prod.outlook.com (2603:10a6:102:23c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 17:43:51 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 17:43:51 +0000
Message-ID: <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
Date:   Thu, 5 Jan 2023 12:43:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230105173445.72rvdt4etvteageq@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0010.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::23) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PAXPR03MB8273:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cf660a2-d7aa-4c47-d133-08daef446860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qck6ljDd1McSgh5jz+FY4aKBMIk19J2C2chwAL1C8XnZ7XGhMbRtn2VBj0UnO9WKZxPfpFKE+LWnEV/N3uezrah8VnoYbVTZlEY1XRDewRca7fk1p+O7pH+ZS4lw7VYaj1c/acxR6/FNqN9d2gpEzPtBBrEIoY0v3YKFUlCJG4IrQfqaWWAF4AiMUPETBojSWqSObZ1WZyiz0qO3Clxq+Oh1I+Yo5PUFhnImvGSdOAg8ilME5R+2GVnLRlNmHEYag0X9RfOGBnB+LR7W9rNMOwWeKsTbVGFlP2Z4Xlm6j5mUl5w84wl0EVzbQ+uU9DFJZhnJAmIgmWCq7MaOVuSqQ02LiVhiD0q0KAAJmaKLU49Pn6ghqoo2hCZ7GCV6hNn04XOidXmSo2GJJjrrSPRK2pEEakwRoU5bqG1YJKGTrOLJTsnGg83IXCefSussxJQwLZIaDRHbYXd/dduNH7trwAFlOkHiHdRS7Xri9BJyi8U1J9VEXd5AhI0c+BIqn5dfUD5sX6XrWT4nbdrzcVENfPaSUiy2A8QlNu5aqvL4QidTRDVjxfb0RZCx55U2yLdwf4/yLJD+A912ZPuZHuqLYxi3KTzoGsFX3LO6zGVv0lv52HXbYzywMSQ/56Z4OoYtNuUflCsylEAGOv7qE7pVBoPU6t1KLZLGyarJWz0pEIm6AhKT1xB85w7LCwJ3PBNISPuLrfYfDjGYUEkdJjFc6wHnnhzU7DQOcmL9MeJ3HUBGsW3RFZa7xsGzczTRrStWHAHeqQ0XcYhmXGAo7F0lNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39850400004)(346002)(136003)(376002)(451199015)(41300700001)(8936002)(66946007)(4326008)(5660300002)(8676002)(7416002)(54906003)(316002)(19627235002)(2906002)(6916009)(31686004)(66556008)(53546011)(6486002)(52116002)(6506007)(66476007)(6666004)(478600001)(86362001)(31696002)(26005)(6512007)(2616005)(186003)(38100700002)(36756003)(44832011)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDJWdGc3N215SmdZQ3U2UmN5dHhqYVI3L1hham1scUxMYi9nY2FlMSs2SGx3?=
 =?utf-8?B?VlJYUndLZUJ2Yko3YXVtV090T1Z6VjBOTzFYMkdISFhWQXBGdU9rb0xiUjgv?=
 =?utf-8?B?MWtHWkprOVhBa3BNcU9aRFFTZEVMMlBqb0R4dUV5STk2WVBRM05hcTBFNEFB?=
 =?utf-8?B?d0gvSjlwQVlVQnZLemc3K01mOEhKSnNBd083RXBZTjJpTDY3M1o4enBtajFU?=
 =?utf-8?B?T3Jib0VtZ1YvMmRnVEduSnVPQTF1ZWtxempOZE55VFZBckpleWNtK1ZiTVg1?=
 =?utf-8?B?RVlkNi9OZmtiaUZXSFdUSkd0WUE5Q1FWNXJVblFTeU02ckZjWW54R1JOck1y?=
 =?utf-8?B?YlFVR2NjTWt4QU1CMlgrbkp3VWtrY3owVTBSeFA3aFVYV0JBMFFtSlhDUncx?=
 =?utf-8?B?YVVXbnBJSlBzWCtmaW1oRlU5djJCODQ5SVZhK2JOWE9tWFVWUXY5NXl3TnpQ?=
 =?utf-8?B?cW5SbTVlelFlMWtxQndGUUUzY2dtSEVydkFhL3dpRU54MGRVV3NzeVN5cmQ5?=
 =?utf-8?B?OExmNmZ2T0NxNmhJcGd6KzlJMFdvOGdFMHlvK1pIMWl5TGxJWGtVSER2TDVD?=
 =?utf-8?B?cDNsMDVtWi9iUzE1Y2xXSVg1RnN3VzVDZHNLc3Q0MENpb3RvcmYxeGovQWRq?=
 =?utf-8?B?Y3FENmFtRFFMcmJrOE1lOWtuWkhQQTZOUGVUWGZJNzZKT3JTMVJnU25XZ0s0?=
 =?utf-8?B?Qi9TM1MrTTZFV2lGRTNLWi8zUjJ2bWdDdFZJVnZoaEsycVhvbFF0WlBFVGRs?=
 =?utf-8?B?dE81amNyMERFL2ErcWtCVWR2OGhQMjZpcUxhQ2hrVE1STVNUTXdjY1ZGRFBC?=
 =?utf-8?B?d0crQTZZVGNPQnJDU2k5ZENPSjM2TjNXdldqNGN3WjlJMkxDRVZnT0J5eVpi?=
 =?utf-8?B?aVA2SDMreXRzYXcyWmdFeVNFZU1GdW1iL0hvRUVCR3p1SXk4ZU0yYXpVR1d4?=
 =?utf-8?B?ZFd4eE1KUTQ3bjQxcWpORndlTyszSytjS0d1L2ltMW9PQy9teHYxNXBnSWxU?=
 =?utf-8?B?UkFBbVpnWUYvanZmellwazB5YUFDdXEwdi9TUjNMdVpKNnJrazh3Y0ZkQkY2?=
 =?utf-8?B?Uk96L1lCcmFJeUVnMVV4TzY4Q2p2L3dmbFlBSy9WdEg4c0FobEVBNlNGYS9O?=
 =?utf-8?B?N2pJQTl1TEpnQjB5Z2dmWFJubGplTDRUQXQ4V3VENzZteUhldUVYWXRPL1Fz?=
 =?utf-8?B?U1RzOWsvd1BVbjNiSGtyQzg4QzNWTlpkckozM1dNT2llM0FSS2Z3Ym1xVXNY?=
 =?utf-8?B?ZndWT3BOeWVpZ1ZKL0NWOHllUHNxMDNXRHBQYmFCYnc1NDcvdlI1S0tkeDZO?=
 =?utf-8?B?d0lBMXVjZ0NYa2Uvdy8xSW9PQzJSUTJ6eDl5U2o0eXBZZFNIOXpwL2Nad2VB?=
 =?utf-8?B?N1Zab1JKdnNTWjk1KzBxYTRUQmxFWlN1cmZrdTNXUExYTUlJQlBIS2MyNytp?=
 =?utf-8?B?NDRhQlJSNENsVXV5OXUrb0p4eXBMSjhiQVJ3U0VDdzZ5R3J2Z29mVDhIQ2NC?=
 =?utf-8?B?c0FTN0pISU53L0FWekNZaXVIRU03SzF2eUxXN0V4V3lmSXFyeFI0d1FCc00y?=
 =?utf-8?B?YXplWmM5SVYvK2d4eEl0YVJkU2diODBLTEVYUVZvRms1bko4WEU4Y1poa3lF?=
 =?utf-8?B?R3dwS1FSdTZxZUpzWDRud2RxdC9Cc1JqcmNnQUhjL1BLNFNzak9HdkRhRmpP?=
 =?utf-8?B?RDFvUElzQXB6UWRuUlhEVGxNZElhajUzSzBFcFdXM2paZVRMYkMrRUlPYm5y?=
 =?utf-8?B?VlFnS21BcE1EWGlPQ2tXZCtFZW1Oc2tvSjhpc3ZsMkk3ZXhuZHRIdEhtSG0z?=
 =?utf-8?B?STB5OEwvV0tqMEdLL1JaN042Rm41MjFhSmQ0TUdrNTFzbW1BUFV0UTEyVWFo?=
 =?utf-8?B?b1dSRFhod3VVNHMzSXRmeVJtYTl0VDFySTBCV01neW9zZm1PV292TzdxQ0w5?=
 =?utf-8?B?KzQzcjBReVdiL0VZUktPTnNHdVhTVGJPZlFEVGppODQvWDNOa3gwYmZ4eWFG?=
 =?utf-8?B?ZkdveEFtRFIybjVJNm1qYVBZckZRSzJReHNiRHUvaXFPZFhkbVpEQWlsSlJQ?=
 =?utf-8?B?b1p5ZWdkTFUrQk4wYTlCcG1qT3huekJLQVNnT3JSK1ZlTDh0TkUyVExxdmI4?=
 =?utf-8?B?NmNtRHd6UzBkeERadnJmSjZLRi9lL0IrcU56OWpHUG1yZW1xd2RFYTlqRDMw?=
 =?utf-8?B?Q1E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf660a2-d7aa-4c47-d133-08daef446860
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 17:43:51.5910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zeGUHLIundkpSPLKq0wdFqM4Dih1OogeBV2Cfni+4+eR1kBE9pWlkRZ9gD0wOK3+w8qODuuYz/UGuFL1vjdyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB8273
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 12:34, Vladimir Oltean wrote:
> On Thu, Jan 05, 2023 at 11:21:14AM -0500, Sean Anderson wrote:
>> > Your code walks through the speed_table[] of media speeds (from 10M up
>> > until the max speed of the SERDES) and sees whether the PHY was
>> > provisioned, for that speed, to use PAUSE rate adaptation.
>> 
>> This is because we assume that if a phy supports rate matching for a phy
>> interface mode, then it supports rate matching to all slower speeds that
>> it otherwise supports. This seemed like a pretty reasonable assumption
>> when I wrote the code, but it turns out that some firmwares don't abide
>> by this. This is firstly a problem with the firmware (as it should be
>> configured so that Linux can use the phy's features), but we have to be
>> careful not to end up with an unsupported combination.
> 
> When you say "problem with the firmware", you're referring specifically
> to my example (10GBASE-R for >1G speeds, SGMII for <=1G speeds)?

Actually, I am mostly referring to cases where rate adaptation is set up
to use a phy interface mode which isn't supported. In particular, Tim
has a board where the phy is set up to rate adapt using 5GBASE-R (-X?),
even though the host only supports 10GBASE-R.

> Why do you consider this a firmware misconfiguration? Let's say the host
> supports both 10GBASE-R and SGMII, but the system designer preferred not
> to use PAUSE-based rate adaptation for the speeds where native rate
> adaptation was available.

This is supported, you just can't get 5G or 2.5G.

>> > If the PHY firmware uses a combination like this: 10GBASE-R/XFI for
>> > media speeds of 10G, 5G, 2.5G (rate adapted), and SGMII for 1G, 100M
>> > and 10M, a call to your implementation of
>> > aqr107_get_rate_matching(PHY_INTERFACE_MODE_10GBASER) would return
>> > RATE_MATCH_NONE, right?
>> 
>> Correct.
>> 
>> > So only ETHTOOL_LINK_MODE_10000baseT_Full_BIT
>> > would be advertised on the media side?
>> 
>> If the host only supports 10GBASE-R and nothing else. If the host
>> supports SGMII as well, we will advertise 10G, 1G, 100M, and 10M. But
>> really, this is a problem with the firmware, since if the host supports
>> only 10GBASE-R, then the firmware should be set up to rate adapt to all
>> speeds.
> 
> So we lose the advertisement of 5G and 2.5G, even if the firmware is
> provisioned for them via 10GBASE-R rate adaptation, right? Because when
> asked "What kind of rate matching is supported for 10GBASE-R?", the
> Aquantia driver will respond "None".

Correct.

>> > Shouldn't you take into consideration in your aqr107_rate_adapt_ok()
>> > function only the media side link speeds for which the PHY was actually
>> > *configured* to use the SERDES protocol @iface?
>> 
>> No, because we don't know what phy interface modes are actually going to
>> be used. The phy doesn't know whether e.g. the host supports both
>> 10GBASE-R and SGMII or whether it only supports 10GBASE-R. With the
>> current API we cannot say "I support 5G" without also saying "I support
>> 1G". If you don't like this, please send a patch for an API returning
>> supported speeds for a phy interface mode.

Again, this is to comply with the existing API assumptions. The current
code is buggy. Of course, another way around this is to modify the API.
I have chosen this route because I don't have a situation like you
described. But if support for that is important to you, I encourage you
to refactor things.

--Sean
