Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF8C65F41E
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 20:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbjAETKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 14:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjAETKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 14:10:18 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2070.outbound.protection.outlook.com [40.107.14.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C0B5F916;
        Thu,  5 Jan 2023 11:10:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZRS9VLkkNh/ag6U+uV5NiV12ytXHUo/j4x6qzeTAM9ROVHysXfcGdMAIX3nDWQPu0E1FPB/bUJkpI49hh0sa6nFcmMb5973BHUHBaNyIl7tVKTICmZ/KWUxydaX9denVNV0iQxtTJwaMhZ1e57xFTukmk0Q1bnz7ZK+Ird9XTAUhOiXlA/sx1fqB3RVSBsg5dCbGT9ucOeJqZeJvr/JOWWjKJHngDnwRlfpIm3qiGE5Un77r29ibJujpKwEvoHWzPUIqJ+ZystKujAIU2oLLjV1bu9OLj4xvdwKu3LfKzVC/j3v44afEmFWs2hLvpBaqwwXT8JoCB8v9TMVHyVXAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6o1En3WcQBRmOsbBhZXLv5uW/oh+k2BhJhfFSWygzAk=;
 b=gJjcH+UnM0OODcwdn8aA1nProddKt+fgWAq5LFgxlCCJ8DrDmOWpVtWu7vYMbmvjj9bI0Bi1se63BnwHLiOMEdP36074IfwGGLiU106Xp0p5xwNmdxRtF1lQYY2CN/r6sc0TSu01krbyhKEIturSIKgryMb+ChhJCJ1kOWl8GkWwt1+h8brDR20cHW+y3wGWxNG0qllE8OmjECbPv1tAzPqvahMhFnfBnVwEUEKKo2eUEhTAxYetr0b1SA5OqOiwBDmp+E1LqS2fXm1zhfqsy6jzzBD5yKlKQwfvr3X1hx0Iyo1XdufkcWiBML1ccAvJQtwU0Iz4p1kAPRnQMAE9ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6o1En3WcQBRmOsbBhZXLv5uW/oh+k2BhJhfFSWygzAk=;
 b=0qqWe6ZnnVzD7C8JvRqwgkJOiUNRzqpztrGgSSXoscfo8Ffn0McNRn5UKagnaQt+anUVE8M0OYqkUCeuqfB/xoKlHeTFqHwdieUIKFFd60SZYYWOOXSvvqpVZIPvgP+8CRyfIiRXDUvCZLybWoSmkoU338iUCy+9bCoKBFEWziukIzdBAcTh8StP57kzwPKoe/1ojhO+4rsu84nebufkN3QYt9Ky9eSJAgeKjt4Z7QeJk24+wy0+7awhCVDXZjBK84n5ropN9yy41nicjEKZkBJavLFDKW15LTGG3v424A+Mhlfkufh4kIz3V4x2XQjF8fFYFMIGkmgrjpeWXhGpqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DBAPR03MB6551.eurprd03.prod.outlook.com (2603:10a6:10:196::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:10:14 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:10:14 +0000
Message-ID: <bdd84dcd-3f3c-4ed6-2694-bb8252a9a266@seco.com>
Date:   Thu, 5 Jan 2023 14:10:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
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
 <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
 <20230105175206.h3nmvccnzml2xa5d@skbuf>
 <Y7cdMyxap2hdPTec@shell.armlinux.org.uk>
 <18453c4e-484d-5131-36fe-77d3e55d6ac7@seco.com>
 <Y7cfqdVzrCNX6VqE@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y7cfqdVzrCNX6VqE@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0035.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::48) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DBAPR03MB6551:EE_
X-MS-Office365-Filtering-Correlation-Id: 45f93091-63ad-4f7b-e558-08daef507988
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRNcxHFcn2zaAug2tZPLF3qv8OJRRuNXRJssGZ6qav+EnEUdNl6EyyLp0hlfqkxRkmG9BwRrpKt5trMZfJ5gevPbAZs3/BBXFCgi3JAruJdBV5APosVwzgPKEJH4/baHtET8b9dpdLqgl/PS+rwUE7Tffjb2C2R9Ial7n6/vpFIhlNJ1zAnpgPJRndCrCWq1QMm6Qx8e59vf89l14hm8CSEInkHOMA8uc3ofSLXpK7sz4e7VC5O7Z4bOX4TDCvfoV8TPCEmOxVWJ+g08n27Hya8f8eh1Bdp0xMRIXCmkpK2W6Qx9qB39DmwGjy8zRfA9kv1YyM6InRZ23F6BXKWVY6mSug+HQGII9z+dVWoSZlvhDaLAYI+EtxJ2QhDqo88xnGzxO3tM02fXF4nKliroDLIDcr7CzrfD5NE23Iu09y3vQfnwozOQ+IQSQxIdF3bjrlN3Wf0fZv5TSdJWlgYFXSot0f5U6AVTj4FzOhvB0mcsMbWe+F+8ahq4lQwpY44+Mbi/Mv2p+pnBAQlFpyblcAPmeAs2Si4g42LKa92oE/mkCKlkF4oY417I9qH9xIOD2PjOdzoduvuTusdRGo3xvOnc2ZIQ6OS1S9JP+vxSF536bWVg9seozcnySrtxMkRtFbUb8YZHywDIfZNrRF30aIfHuYfL7hwJgc7qRZTzrgWRu1K480FRnCqau7Sq8Vna6gqtpB52wxVr0d0YiSwoy5sXz/EH0OqTM34SoX0erHqyvV6cQpPcrVwodcsTOobfeoy8qc3J6mB1+RBfbrF1tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39840400004)(396003)(376002)(346002)(366004)(451199015)(5660300002)(2906002)(7416002)(31686004)(44832011)(8936002)(41300700001)(4326008)(8676002)(316002)(66476007)(66946007)(6916009)(54906003)(52116002)(6486002)(478600001)(66556008)(53546011)(2616005)(26005)(6512007)(6666004)(6506007)(186003)(38100700002)(38350700002)(31696002)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTJYQ3g2MVFhSHpLTlgwNWpLbkh5SEVGQ3IxVzZmQURYN2lNNFZ3RDA5R2hs?=
 =?utf-8?B?SGRqTkR4TUhXOTlvS1IxSEVKYUl4akhGY2VyR1EvK1VDYUk3eURuWW1sbXQy?=
 =?utf-8?B?OGdVRnFlOWYzQTRSNXFxK0lCZi9KZms2S0RKenBtenRxNnFWeDYyRC91ZCt4?=
 =?utf-8?B?aHQ0RWpmbXhUQzdLRXY3T1IzT1IyZTRYMlBqcVgzQXFuSzFyU09CSE5qWjZl?=
 =?utf-8?B?ZlZzamdwbnZOM3NYMjBUV01BbEIwRThkMjgyK2M2SlpFNGRxNXVWTTBPNE5R?=
 =?utf-8?B?NDYxVGkwbENnTUlnOThlMG1EU3paTGF2YUhzNjN6R3VJRmdCL1ZyeWhqRldr?=
 =?utf-8?B?aW0wK240c1huSS9HUkZLbmt4RmhMSnN2OTUwUjVyV0h6eHhsM1BzUnBoVGM4?=
 =?utf-8?B?Q0g0dW9JT1htL0l1ZVN2dDE3NWR4RkZjNWh5Wm9tVTF4OGF5cUUxZXdqSFZU?=
 =?utf-8?B?Z3hLdVhCcHZ0SkkzcmFobHI4elcvTThWQ0FhMmI4dXI2OW01K250WlZZUjZz?=
 =?utf-8?B?TC9tblZKUGczNTdiV09IM1BCZmY0SithbmFTODM4Q0JpWU9XYkdnQ0lJTnBk?=
 =?utf-8?B?dHErV2xVd1lWTEFxYWJraktTang1UlVlQjllRFFpaWpUekZJQTN6QXR1NVhE?=
 =?utf-8?B?bXdremZ4aGx2NG92dkp3a2ZMVmwxZXdwVEtUYnp4MGlUZ1dwT2hLT0RlQ25Y?=
 =?utf-8?B?ejR6VFZ2bDN6OWJWTVVuUVo3UGMrN1hzNUpsYVozSCtEaytKT1dleWNsQlQ2?=
 =?utf-8?B?UnJKR2xrYWp1cVhDVmxjeFBCNUR3dk5iOVFXOEVTTlA5NWlLSWNKc21raHR6?=
 =?utf-8?B?ZDJrd3lrc1JUSDdtdkhJV1dtcSthRCt1amcyZEEyTWNNZi85bEtuMjYzSjgw?=
 =?utf-8?B?Q3VxbEVLRmhQeVZQLy9vQVV1ZDZEeXhEenU5OThoeUc2b2pLdm8wVDEzNEJl?=
 =?utf-8?B?NFBMSjBveWRpM3g1QnNFTDBhOW9SMy8zdWpkWXg0Z0UwUzVXekRrbGJzbng0?=
 =?utf-8?B?VjEvc01rUkhCU1JsWkc3emJvdkllb3ZqSHNaTnpLRnZVNmFzY0tLekZJdFUv?=
 =?utf-8?B?V3hYbzdNTGFRUkNLNGZRK2xPRE1DNytLZ3d6alFqQlhyc3BrL01NcVcwQ3Vo?=
 =?utf-8?B?SUNUVmthOCtPcmlvbmdGRlZ2dm1vY2tJVmVEL3BXUm41b3JOdzFHWXNkdDlZ?=
 =?utf-8?B?VWpkQ1V6akc4OXE4M281b3VraDdiVUtoLzVKdkZVeTJRNFdXQ0ZLTkxMZWxC?=
 =?utf-8?B?M1pCRnJNQ085U3VOV29XcjFDUXdXNTllNVlBZDg3b004dnFWWmZmdXMvUThP?=
 =?utf-8?B?aGlwTDlXWlcxcjh0eDFnTlN2aVU1TWxOVHB5MjRSZWU3N2ovanlqWUc5S3dx?=
 =?utf-8?B?dlJFM2xCUTNyR0JnMTJ5WkMyaXRJcU9JZnVHV09pdis5UzFpdzBoRzNIVVNS?=
 =?utf-8?B?cFlTK0JOT0dUYTRDOGJhOXRpOFpSRE8zK1lPTGdiQ1hISTQ5dXhNbFlQNFZy?=
 =?utf-8?B?L3VBYytZdjQ0QmlidU4wT2pmQ3hXTmNDcGhqRW9GSy9zL3FNZnZmbVVWMVNU?=
 =?utf-8?B?L3BqMUhnYUFaUEJzTWxidEJRakpJQVVseGl5ZE5jSFN4VmZNVmdjdVhDYjFh?=
 =?utf-8?B?RWFxMWlrT29nMVFZL0kzVndyV24rQ3h4RXJqeWExdGxDeGJlSFlOTXJRWURB?=
 =?utf-8?B?WS9kVlYzaTA5cUpzMEgxM0pJcnJNU25pS0tmTS9peGdQVUhFTWc2ZVBoTUd5?=
 =?utf-8?B?K0lYS0x5WkxScFY4TGVXTWVTc29iRVlQUjB1aThCcWR6dHQ5RWFHUkV3Y3Ax?=
 =?utf-8?B?VlBFTHY0STFpOFVzRktxVFlQY21vK29YL3p5Uytwbkw5N1lxR2xBYkxzTnRt?=
 =?utf-8?B?THJUWHVCTFR4cmF6aVd5UjJyNUg0UlUvbisxWlZNZ29IS2tycWltVVd4cGhk?=
 =?utf-8?B?UDlJLzZKdkR4UWV5anV5ZFlid0tQZWRGalZMZU92Z05KdlE2cXRkdkhHakll?=
 =?utf-8?B?ZnliTG5CT2dOaG1TMGxYM204SDlmMGJFUmF2SGFlZWtFd25QaFZzYkQ3VnRE?=
 =?utf-8?B?ZnJpSEx4VlYwTDN2NjQrY0dUMDBYLzl0N3Jyc3hyQTFWR2htM0hOVWxVTFMz?=
 =?utf-8?B?RnJMV3hEUk5uUFhXZUhUTW1LeE9MWmJTeWFDKzYyV1VDTWFYeDNzL25vMW83?=
 =?utf-8?B?RFE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f93091-63ad-4f7b-e558-08daef507988
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:10:14.3189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXIqXaAH8BtkobDEztl6eFC+wdbzw4yxN3Fp7K6EwjJ+0Q/kqQQa3ciqKIFxihtuJ3Pcwo+JrAcr080dfxRMxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6551
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 14:06, Russell King (Oracle) wrote:
> On Thu, Jan 05, 2023 at 01:59:27PM -0500, Sean Anderson wrote:
>> On 1/5/23 13:55, Russell King (Oracle) wrote:
>> > On Thu, Jan 05, 2023 at 07:52:06PM +0200, Vladimir Oltean wrote:
>> >> On Thu, Jan 05, 2023 at 12:43:47PM -0500, Sean Anderson wrote:
>> >> > Again, this is to comply with the existing API assumptions. The current
>> >> > code is buggy. Of course, another way around this is to modify the API.
>> >> > I have chosen this route because I don't have a situation like you
>> >> > described. But if support for that is important to you, I encourage you
>> >> > to refactor things.
>> >> 
>> >> I don't think I'm aware of a practical situation like that either.
>> >> I remember seeing some S32G boards with Aquantia PHYs which use 2500BASE-X
>> >> for 2.5G and SGMII for <=1G, but that's about it in terms of protocol switching.
>> > 
>> > 88x3310 can dynamically switch between 10GBASE-R, 5GBASE-R, 2500BASE-X
>> > and SGMII if rate adaption is not being used (and the rate adaption
>> > method it supports in non-MACSEC PHYs is only via increasing the IPG on
>> > the MAC... which currently no MAC driver supports.)
>> > 
>> 
>> As an aside, do you know of any MACs which support open-loop rate
>> matching to below ~95% of the line rate (the amount necessary for
>> 10GBASE-W)?
> 
> I'm afraid I haven't paid too much attention to BASE-W, and I'm not
> aware of anything within the realms of phylink/phylib supporting MAC
> drivers having anything for it. I don't even remember mention of it
> in any SoC datasheets.

The mEMAC supports "WAN mode" which does open-loop rate matching, but
it can really only adapt down to 9.5 GBit/s or so.

> Are you aware of a 10GBASE-W setup?

No.

--Sean

