Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED5A42C166
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 15:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhJMNaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 09:30:21 -0400
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:20803
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231644AbhJMNaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 09:30:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkB4ReUqbzmWBaxdUV3EVwpV/qjyc/k8U5KQ+fXDwNrmVrIreWm9O+8OC4aDv6PbjiUEe+onyXB216e4E0NKXDC6JznBTjOjpgfMA0oh8Qghg89jOaHL+JgMtcNWv+VIU5CGHEO6db91GdqFO3+qi3aoJ/fXb0AmQSG5Cin45SyeEcAwbc7FaDA7HshoqYzyAq5fwIl/+/eH5pPyUNaJ6Ga3tLMywxLjMg949OMayYe78DBwbC0DARtYG5ogc1i1y7eUc4iLP5Xo8zdmHQCgMoeLiWXmt/QcSfprRkytQCo/r9fyTlNz3NzGEE8aBO9ZomY55xoaNOG8g+/0tSYuTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcpAto+Fkwl/ZkoyVAqHMe8bkskTa6Cwe30a6FhtYB4=;
 b=PO1ATLIbJvT/k5jqtD4tkvRtYVDZXekY+owNQYjhf/LYNOfygf97pc0IXVhgfVftQg4D7fJocFLMsX/oRWZdgXcBsLYSK3+aPVg0veXhnIQ3Yfj4VHd5uInk28erKCxWiEKlemIN1cf3D369NTWYbCK0uBih6JHkBixCDifk505XZU2Be1Q+0bDRP10V/WNmT+Cs+PeMeDFgY0dUzgJGAR+NQZ4krQCwyQt5p3Q6wlgwrHXH/ZLVFUcpw1uoZm3USVlTWvlaSGsrGxKwV26oGCDGtKqZNNQJ9b2TFd8AloZtV1doPp2/qDtxZpRNyNTjCwxIUeGm15VqS98n3K5ESA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcpAto+Fkwl/ZkoyVAqHMe8bkskTa6Cwe30a6FhtYB4=;
 b=WP0ABOmH5nu5sFYMRV+4ZuxPZPMVrSLFG9iB4a7v5TC89gg4q9N+gr07OrLiC8nHHK20fOQG94eBYYDLL83hl/t9e3pcBQeZ26ylBKznl8PgcUjeN+BJZiPwj4vzsLQnQ2clIvbH0ZYmlwMeyvc7mtfLHHSqZedzhNj89r4X+W0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB6018.eurprd04.prod.outlook.com (2603:10a6:208:138::18)
 by AM0PR04MB5091.eurprd04.prod.outlook.com (2603:10a6:208:c0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Wed, 13 Oct
 2021 13:28:14 +0000
Received: from AM0PR04MB6018.eurprd04.prod.outlook.com
 ([fe80::9556:9329:ce6f:7e3e]) by AM0PR04MB6018.eurprd04.prod.outlook.com
 ([fe80::9556:9329:ce6f:7e3e%6]) with mapi id 15.20.4587.029; Wed, 13 Oct 2021
 13:28:14 +0000
Message-ID: <646d27a57e72c88bcba7f4f1362d998bbb742315.camel@oss.nxp.com>
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Date:   Wed, 13 Oct 2021 15:28:12 +0200
In-Reply-To: <20211013131017.GA20400@hoboy.vegasvil.org>
References: <20210927202304.GC11172@hoboy.vegasvil.org>
         <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
         <20210928133100.GB28632@hoboy.vegasvil.org>
         <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
         <20210930143527.GA14158@hoboy.vegasvil.org>
         <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
         <20211007201927.GA9326@hoboy.vegasvil.org>
         <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
         <20211011125815.GC14317@hoboy.vegasvil.org>
         <ca7dd5d4143537cfb2028d96d1c266f326e43b08.camel@oss.nxp.com>
         <20211013131017.GA20400@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR04CA0150.eurprd04.prod.outlook.com (2603:10a6:207::34)
 To AM0PR04MB6018.eurprd04.prod.outlook.com (2603:10a6:208:138::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SOPLPUATS06 (84.102.252.120) by AM3PR04CA0150.eurprd04.prod.outlook.com (2603:10a6:207::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Wed, 13 Oct 2021 13:28:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d952778-ad20-4537-2d1c-08d98e4d4f15
X-MS-TrafficTypeDiagnostic: AM0PR04MB5091:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB50917F870A05CA456F398B35CDB79@AM0PR04MB5091.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Dm6BL+teOEcgQG/fD62Pbxguq4QHYAQYsD4JKH3iQillaBkFVsBmrxkc0ao7xu6z/5nyVxu6JNgPP5MFry0yv8W3qbBHiXHzPotGxRkWOU4cFVymLm4bJ5wO4VKIpuHVF4Fg7JyHdCnPsI2kNyjnQVTm67KQjGBrVczZQvfHyvyGTgcvRhlOs/JBKat7jvLvPL2ZD5IlByTxkBaoIqHssX7sySYGOHOspMqybkmdjDrJe0Lz/g4+sEXh/sMegHxGVvl5nrNGPoauP7C+vrl1Dt8a6O4ZSPxZEvAs13wrCjw/af/+2grMOFg3zPCkq+nIbWscSgzHtSIhuh5X0CJsQ/dtH1UvaVOaCqSJTOmhxmXN2/MSbDT/NjrGVaFLdLSJPwnfiN8Y5rYXxjv9qEgOb4dGJLRHgP8qaXOu0lywvyLncV6BgyggbSGQ73QdrmtiQfOX6qxwpS36RhNnkm0mRLpbp/kUYzc94Q/6t7WBiMWSYQvRCkJf272JSvj2bwk82idmBr53Ji19UFRSPmQfRmHlv9pNxjZwvmH6mCZhUlWdsQMQOJsyEiLqkO5AHHk5j6RYc/npkJSTSEdpTZ40U+jupAVNWD13PcvQgaAneEbi9QNvxeQWXTbqpMgOdUVz48yep5rmPUWPmaUrD98nE7foImJvqFLqv1qEXyMRJT21zdKoaVG7JoOC/CLWpv8pnNwl9X/4XvxpZRWjv5cVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6018.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(83380400001)(44832011)(4326008)(26005)(86362001)(6916009)(186003)(956004)(8936002)(5660300002)(4744005)(8676002)(66556008)(66476007)(2906002)(508600001)(6496006)(66946007)(52116002)(6486002)(4001150100001)(38350700002)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEFtTFo4RCtma1laZnY3SUFJOWxRU01MeUVrSUx4eU11NVErZ0FMR3NxdWdH?=
 =?utf-8?B?THkwQnhJTGN6NUVTUHZORWhBcVpvbFlDR0JMbGo2T1pXbHl0KzM3Q1YvalFt?=
 =?utf-8?B?QWFYVWUvN1hjOEc2dHA2cXNFUnA5TUY3TVNONGZ3YWJVV1VJVjB3WVJDTkcw?=
 =?utf-8?B?OFI5MUlVOFNEbWRWbk9qUE5NZmhVWmhoMkEyVG1WV0wwa1pDbDFQQWp3eVhh?=
 =?utf-8?B?UkVTRS9Hc0NnUTJ1RDZzbVM1K2tZbTdCbmJHNTBDeGlIWkxzdm4zeGN5bmZD?=
 =?utf-8?B?eVJyaU45bU94akhabjZCd2JQWVUzQVRuYlJPMlJZWWhKLzVJWWtLSUdJK1Jo?=
 =?utf-8?B?cjRYSzlKV0I0TzgySzhURmM3VlA0dll4TWk3Vk9qeEdud1JxVFc2RTQwVHhq?=
 =?utf-8?B?QkxVZkhlN2pOcDlTZWRQRHFSMjJJaDhiUE9UY2FzMmpHdlpoOFU0TVQ2bE1R?=
 =?utf-8?B?djFiNmRwY09kNHYxU1QxZkxSaWI0MlVmWmtLTlNpZldHcW1zOVJpL0ZTK1NO?=
 =?utf-8?B?UTYzb1dWWFFWcm9lcUo2N2ErZXVFWWlGZisyQWpOZVc3RExaSGxIUTh6YkZJ?=
 =?utf-8?B?c095dVJMemZhMHJseHJEZ2VmZlBERkFlN08zeHJTbTkrSUdKV2JpVUxqVFFU?=
 =?utf-8?B?QzNld3B2NWl2MkNYR0trM2JhVFJlNWRTaW9WNmxueDhpZWJwbUJnbmlkUFVw?=
 =?utf-8?B?WCt1WXFJQVAwUTJWSTRCYnFMTUs1Y3oybEFQU09hcnRhK0NwZlh2RkQ4VTR5?=
 =?utf-8?B?MUVIMGNZM0ZRZFRTcGZnU25QUGhQSU1iRnJyYnN1WExteHM0U3Y0VU5RbkRR?=
 =?utf-8?B?c3BVenU2Snh0a3lnNUtUUERzTGdDNU0xS0NsUTVCYTNUSjRRam5kVTdjWm5S?=
 =?utf-8?B?Smx6dHlJM2FwT3NRU1A3NVNxL3gzNW9oYnlHL2dhUjYrRDZkcStYb1cyeXFZ?=
 =?utf-8?B?UVpIN0Y1VldDd2l2NWxyZExEK2Q0YXRjeHZlTmhTcm5DTGhWemg5VE9Vc0dE?=
 =?utf-8?B?QkY5dHBhNXVHc0JYdGZVa1kyd3kwVzNNL0NEelk0MHN0QU9pTHJUeWlncVNS?=
 =?utf-8?B?QnpMNXlVM082cUMxR05tQjdjM0JOK1F2VmxYaU81YTBpN0E4MGpqRUxTSmRR?=
 =?utf-8?B?aDF0UlQzc01jcDByelhtd0FCVkw4eVdIS0tzYi84UkNCQmZYeEx2NjZJV29H?=
 =?utf-8?B?QVdZY2RPbElqREwzaFpXRFZnKys0WHVORnFQNHhMT0VEeG1rSzlRaDdlcVhU?=
 =?utf-8?B?MXdWa0dMelMwTjVnMVpGSWdyZ2I0K3pFNlcvN0FvL3RBRzNrRklGeVZxUjhs?=
 =?utf-8?B?a2tnaUhVTXpwR0FzUGZEYmlJOGloQ0tPbVlDSVNEaFVzcUplV215QkNWWDdv?=
 =?utf-8?B?UTdzRGdEbnVIbU40Y2x2dk9yYkFwUGJXYTdBeFJyR0oyc3FuTE9jbjY2VGdX?=
 =?utf-8?B?S2pGNFVOd1ZkR3B0dVpDTVBnZmFyZ1BRSFhyZHh3VFZpQ2xkUWZmLzBDNlM4?=
 =?utf-8?B?RlF1VUpMaktqUHI1WXk5d0dOQkNsWGZJYmlaZTgyWDFYTzdqaktZcC9LZVdt?=
 =?utf-8?B?MStGTHJOS1JLUldzUDlGNi9ybFlweXd4eUhGN05Fa3JKdXNjeU0ybkZVY1hB?=
 =?utf-8?B?RWx5YUhzVnhEUks1aTlWSm9MdXIvUllMZHhNOTFqTGxkR0hEOXc0WlVxaGR4?=
 =?utf-8?B?QXp4K1N5blRzU2cwUnZCNjFRakRMamprNzRnbWpXZUo3bVFSWjdWZjdvcCtq?=
 =?utf-8?Q?ArTxq50NTfb3bF0SV3JAfhT34DX4Q3lDvY69EIa?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d952778-ad20-4537-2d1c-08d98e4d4f15
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6018.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 13:28:14.3127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trvbkt/mqeuwf3TIkYdWCkcbQD9pl+MuOfdu3TSg3VMA8eKf0y6lw1DVffCjNWUNY6F87m0SivWqdf/qGkGsElOHven1K54uLrUJnZB2L44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-10-13 at 06:10 -0700, Richard Cochran wrote:
> That means no control over the phase of the output signals.  Super.

You have. There's just a small conversion to go from and to the low-
level hardware counter. (Which also needs to be done for rx/tx
timestamps btw) 
When programming an output signal you use this offset to have the right
phase.

> But you can't make the end users respect that.  In many cases in the
> wild, the GM offset changes suddenly for various reasons, and then the
> clients slew at max adjustment.  So there is no expectation of
> "limited frequency adjustments."

Even if very high, there are already some limitations which are driver
specific.
We wouldn't be changing the current "regular" API but only adding some
limitations in the specific case of virtual clocks usage (added by the
user btw). This is less limitating than preventing any adjustment at
all.

Thanks,
Sebastien

