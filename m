Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0F6426515
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 09:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhJHHQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 03:16:02 -0400
Received: from mail-am6eur05on2049.outbound.protection.outlook.com ([40.107.22.49]:30477
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229490AbhJHHQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 03:16:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuZDzrvE6ax9IPzIpIJ3lXRfnX9o70B83WbkKjjCb5Uoq90RiVEVbiI+XfrOBpWeq4q0sd9CJtnzRMTg4LrBaTTuVj4+Vxvtw0231loaV8fw0tU57YDKY/3OkZYvs3XpMOAaTdqo0nRi1bo0GBnyJVRixBG8qQ7ELsjqApA+HL0u2h2Ki//uQXbwsEEmBYi+Cdd6YwWNdbSNB/DmYH6zpCkhHR7ZQYtNJ94oavx7ZL9Zb3Jg79gXcNI4SUlQKQ7DoXO/+XDbPGJQNlj62UzwISeYTm7oUWKFfTB2GI11RtKoADnDADM5+EAXl1DfwkNMxcUfbxPtUIhLT1x3RSK8uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNjLsyaAs35+pK5p24UjcaTHFGYq9C2bvFhz7iaPBWw=;
 b=TQYMHT+i4JKmZ6nx+rJEBRiCI+3rSMTHiRAS9IuPcSWMPHqkFc47ZzWt1zbva3uxks8HLUeZZ/cZkAGD+4rGexMay5t/HFXJ76tlyiYonY7JPnbgNMPivbQbQK3QvhdVqojZv86AMYoM2VILL9OpN+5v0K3CqjZLyaV8IY0dJwSP1KjNueRNKf7sMmFU/Wvl1lj4aj1YPLtzpHqASIi16BtIboWqQgWptoPQAiI934/+nuIRvuy7FhLFRP0yLDXHaaFrPpcIyhz+rh0lS7Yy54ahJOWrM5QPJnIjfjOXsibkSbcKfLwkT1vUbreqxjO25u51b6XGSD9PZkanztfI4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNjLsyaAs35+pK5p24UjcaTHFGYq9C2bvFhz7iaPBWw=;
 b=Hw+dLUN3McCE1A452urDNnT8tsynv/7oOAJU+jg4RJjzipq/1I6EEGOj/yeO0Ev2g4jJ2ZAgpujgPgzm4eUwkJ23hsGkR56pkGUBeNt2EBmq2fUYnEXMIIYy8ZawZFARfDwilldC6jsJNtl/DPpRaWIG2rBvcjwNh1flDe15/Dk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10) by VI1PR04MB6799.eurprd04.prod.outlook.com
 (2603:10a6:803:130::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 07:14:04 +0000
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b]) by VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b%4]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 07:14:03 +0000
Message-ID: <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Date:   Fri, 08 Oct 2021 09:13:58 +0200
In-Reply-To: <20211007201927.GA9326@hoboy.vegasvil.org>
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
         <20210927145916.GA9549@hoboy.vegasvil.org>
         <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
         <20210927202304.GC11172@hoboy.vegasvil.org>
         <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
         <20210928133100.GB28632@hoboy.vegasvil.org>
         <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
         <20210930143527.GA14158@hoboy.vegasvil.org>
         <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
         <20211007201927.GA9326@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0192.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::29) To VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from soplpuats06.ea.freescale.net (81.1.10.98) by AM0PR02CA0192.eurprd02.prod.outlook.com (2603:10a6:20b:28e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Fri, 8 Oct 2021 07:14:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c708460b-934f-45a7-936c-08d98a2b354a
X-MS-TrafficTypeDiagnostic: VI1PR04MB6799:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6799E2CA1550EFB658FDDBA1CDB29@VI1PR04MB6799.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mGiU1CBIMukf2zoryrVqqJ6kjiXsXcoWGn+fdRm9lf8DpKyGmNyzCN1b/bE0JgLC1GxAltjTwqwZSGx+THM0tqNs/ESScYUch5spdDmFkEcSmCqMXfE7jISYwn1oLwb3LpESJ+kTEPhjeMJSYm5MbiMk4OTZNhnuQ5YTSM3HPZD0PJcsmQ00dP6sNJgW4hNqxC1yU9RMAkHAs75IZree3EUBwtACMLoDol5mNeOPkPzIvVqzHQddVUuuV7kw64OcOU9mMhfDV5iqeG+MjDOp4wtVsXFl7uwClwU8g1IJLqCdVjnOH6s5cYpikHloHNM27ilLgD4d4L8kCWULB67GaQuhofCLxGwAlpXvnGEmO1gPzCH6cz1UTpF/WgY5hKlfFQT17WywHDaQnJSaBcv4eW68CXsVmrGYbzU4QCD8qa6ICt+ynXMdElj76qaXx9BBUSVkPMiuGgO+3aMdqrIj1r5hpGGgPcd7ywGiWpb5ZpQsxdNE6752Pc1ftFFW9W6GD+NSG4G8qTMlJkQfKzbjqfPpxPDxcqSMTMuVL8/fby4nbzM2AhjdFsmxAMu+D2GIaPvtp/l2mqCbm7LOGduQ0tfr93KbuvTvAZRP8W4ZGZafjpZvE3LvGLyFFNkhZTYxKwrC62AfABJpwbUoSUh4LMc3fnzoKBT7YDUndpugjKPLFKKvZhjeGfo+imUlIOqrP9c0ns27JR/7QaldhalWiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(6486002)(316002)(508600001)(6916009)(83380400001)(66476007)(66556008)(66946007)(26005)(8936002)(86362001)(186003)(44832011)(2616005)(956004)(4326008)(6666004)(6506007)(6512007)(2906002)(52116002)(38350700002)(38100700002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmlMZm9neEx5TjVWMWsxaEp2RlhoZm53NmVwalpUNm1IT21PTW5TSnNESlNZ?=
 =?utf-8?B?VlpzM0RWT1I4eHI5Mzl5NzJIWGZVNWhaMm1GWENKNER0cER3bytiQlFwNkVu?=
 =?utf-8?B?ZWljNFEveWRIR0V4OVBJc3lPcTdrM2YrZ0Z6NmR0RXVuQ1Z4eUw1TXp3dS9q?=
 =?utf-8?B?eTVTbzV5L2s3VWloZnNYU203cjZtdHBtYWo1cG9STFB1bGtYN1p0YlV2R0dp?=
 =?utf-8?B?ZnNVNkpnZXZLZzNyQzZ1OUEwT0J3aXlKK3ZSWEhFSzJQV3RLMi90YXRuazha?=
 =?utf-8?B?UC81YnltQ2JWSFpqQ3BmRGE4d0xheko3UzRCRmtwN1JJVGpqOTZmWXBtbkRV?=
 =?utf-8?B?RGRDYVg5ZkREVG8ySzM2TVVIL1N5dXJscUhwQUpQNjc2UEUrUFZKcDJOZ21C?=
 =?utf-8?B?OXNvZFl3WDdOeU13aERLL3d4SUU5amJOamlMTGRQWUsyc2xIZFB5MDU0SUI3?=
 =?utf-8?B?TGM0VHRWZmcwOGg3VWJ0Ykk5bHRGVGtma0VLZ3NJeUtiNlVmQ056QSszNGVV?=
 =?utf-8?B?UEJmRG5jRS9SNDFseHUvcnJwNzVZUW1Td0Urb25STCsvK2VYYWd4enZZQ2dS?=
 =?utf-8?B?OWFyZlRVNWpkVUQ5WXRwSjZSczNiRW9mbTBza2RwSlRGWWI3QklCb2pxdkRT?=
 =?utf-8?B?cmtOY0xBdVlqYWkvMXYxVXZnUzhvQzlwSlNHL2FpdkVXck1GQ2gwTFM3VlJo?=
 =?utf-8?B?a2dscGxwaHEvbjUxYWR3T1BCSVZXYUI2Ynh0SUtBZHpnbjQvUEpmVmswRnds?=
 =?utf-8?B?Vkd6WTgxejlGSEpxTjV0MlJERkFZWEc0SWhIYUxxY0NRUzBQNWxXbnJOaU5S?=
 =?utf-8?B?Z2tHVU1ZWk9kSDcrNjQxUzJJaEcxeUYvVmcyY3EydUFPVHFNWjNFZkk4eGhs?=
 =?utf-8?B?Q01RcGtKbDJNcndDZEtNNjVtUElhRG1UVWdvcmcyYzlQRkRPUGNnZGVjNE9Z?=
 =?utf-8?B?UlBrejh5MXhRYjF3ZksyK1NqQ0dzTlRnRDVHaGZpRGhhTGw3SDdnNGI1TG9O?=
 =?utf-8?B?cUZsVi9HUGI3Z1YxeWFlRXFzSk1IWURwbUJGQk1RbktCWkVWbUNpMEI5dlRB?=
 =?utf-8?B?QUZYVE9na1c5YXgrTW5ReEFvMktjSTBDbWMrRFJmREpPTUdETUFyRG9DQXpT?=
 =?utf-8?B?Tk9MMzhHRWVQQ2lXMXRVSnMrbDFDTVkwNmgxcHk1MTliaUJYeUJFTW9iTmNs?=
 =?utf-8?B?eVJ0dkZSZTMxK0NDWnJnUUowT0ZobVZ1Z0FEanA2MCs3TzRNT2d2NjY2RTZP?=
 =?utf-8?B?bEJ0VWttbW40Si9VSkp1amYxdWNIdEwydHhJQkxJSENPYWh2SGxmNFdOcEdD?=
 =?utf-8?B?dVB6Sk1ZM1I4elpuZ3BaL1U0QmhMenA2WC80cG1lTVZwRjl1VTdqWnM2SFB0?=
 =?utf-8?B?SXljbzBnZURWemJ2NG9weXlsTFh0dm5odDIxUjh0WGU4dlFCVTFjUHMvcFpo?=
 =?utf-8?B?TEJQaFZjdEJhMEZiNWI5d3laL2ZqNUhVR1pEcEhMYnk1dlY0U0czNEhwZm15?=
 =?utf-8?B?ZGZaaWRmckM2ajhEU3FreXBOdFhWc3RSbWk0b0xsSE5acElBN0hVdUlxOGhx?=
 =?utf-8?B?eTNQUlhHQjVDeEVYQUIxU2RpU2NQcFJIYWhrcUxSeFV0eUxxWmlka3NvWjNU?=
 =?utf-8?B?WHoyaFpKUWY2VFN4RFFXdUJpUUh6eGpVM2FOeXNOdUFFTWowMUc2VGdudzNh?=
 =?utf-8?B?elZqSGdSOGJVRW91V0lhSi9nVDlsMlFlZ1pRVDczeC93VnNrLzBvclVteW9s?=
 =?utf-8?Q?IZL/Z3uF5lR6ip8m23SszfBEmLpJyDyMw1LDBK5?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c708460b-934f-45a7-936c-08d98a2b354a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 07:14:03.5570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzzIhMow2gWtC7D7IHEcme1HXdd927nfOwGho9o6RTwWcXB6lmR1eDIPb6vZfi2WSRdaHkidk29kkyLq6NgE3UiipCKg7U5Y1PinvCgCukw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6799
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-10-07 at 13:19 -0700, Richard Cochran wrote:
> On Thu, Oct 07, 2021 at 03:31:43PM +0200, Sebastien Laveze wrote:
> > For example:
> > Let's take a worst case, the PHC is adjusted every 10 ms, vclock every
> > 1 sec with 1 ppm error.
> 
> You can't justify adjusting the HW clock and the vclocks
> asynchronously with a single, isolated example.

This was a single worst case example, many asynchronous PHC adjustments
impacting vclocks.

> If two independent processes are both adjusting a clock concurrently,
> asynchronously, and at different control rates, the result will be
> chaos.

This is especially what we want to prove feasible and we think it's
posssible with the following conditions:
-limited frequency adjustments
-offset adjustment in software

> It does not matter that it *might* work for some random setup of
> yours.
> 
> The kernel has to function correctly in general, not just in some
> special circumstances.

Of course, so what tests and measurements can we bring on the table to
convince you that it doesn't lead to chaos ?

Thanks,
Sebastien

