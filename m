Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A5741C7B9
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344972AbhI2PCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:02:47 -0400
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:59584
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344958AbhI2PCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:02:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hli/LNSBx30Csp/Nu2PfthAwwq7YWlSZSGC4FtH6/NgVmEA2Dqn6x4phafkFd7mfD32O9aezEaf4brgpf62f2ZExr7XmXpWfFt8oQhcFq/uPPmxfBKtMiiU3kAnBhL8ATxaFB3UXXeML3gqecrezX/XrgWBmAdMTaQijb97BQ15spdui2rMAjWnKTzEd5+6Zzq2CPOryvmgCdiWPA9MRoikNBXwDMjmRdkbNp2YGXdTrldHXucidepKLTgorLCVPCRF+/+Oz/E94zXXxiDC3eQeTQ2HepC1KiUQrJzOdmimkwOF1xhcmxVkUlTzy1QzdJwR71n6qf92E3XNyDchzuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Uh9aYNBBQ6LkexAjitW/VLG5oS1+p18rC+wTYMGoBw4=;
 b=oLiCCFPSGkCMGXTxGmWNAg5UMTXeQ7Goug1jtMIJgcTvjYqNjeVh7nAvvLpZb8EMbeqN9jifl8JlHOlRjmKJwH6dF20PzotQ/F9HUhurXjRP3pjcAJjFPa3X3bv72F6j5ofQxwFrNtcdgX4y4UIsyQZegWJEyWzEPr/Uf4kQR+6U9KfQDjuDuBFXkwuPivFAE2hTyjAiiBZx/HOeWq9W8bTNG9rjmBZIHRo0n0JTmlGpRd7BKM+T8aMZYF9oSlBK/h74iddEwVbkq4ddgNq2+lqYXikTwjZktCkakRZp9x7XT9vde/YBGIL76kF2Z3pjkVYpSb1Jnwhgq5YY5uiSvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uh9aYNBBQ6LkexAjitW/VLG5oS1+p18rC+wTYMGoBw4=;
 b=hQUMDSUaEKoKm3OA9zVZC+mRBwBEL0MyYQg9UQACMtl2mU1/c8sF1jLEKh3pxs5AirtrdM9F6uneIJYWAuGH/bEFfVpULxpLsH+Bv/osjhcm/jzzebV2jHfeBoYLTQqMK0Pj3cObNcvhpPEPkgUBuLLzEZRBNfrw3SPPYvaCd8c=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10) by VI1PR04MB6285.eurprd04.prod.outlook.com
 (2603:10a6:803:fc::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 29 Sep
 2021 15:01:00 +0000
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b]) by VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b%4]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 15:01:00 +0000
Message-ID: <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Date:   Wed, 29 Sep 2021 17:00:56 +0200
In-Reply-To: <20210928133100.GB28632@hoboy.vegasvil.org>
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
         <20210927145916.GA9549@hoboy.vegasvil.org>
         <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
         <20210927202304.GC11172@hoboy.vegasvil.org>
         <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
         <20210928133100.GB28632@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0118.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::23) To VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SOPLPUATS06 (84.102.252.120) by AM0PR01CA0118.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Wed, 29 Sep 2021 15:00:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54470f8b-3db7-43ba-a1cb-08d98359f2b3
X-MS-TrafficTypeDiagnostic: VI1PR04MB6285:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6285111079064559A323E820CDA99@VI1PR04MB6285.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tr7p9Ykoq3BEsfZKaEOoqoS9BcxyEVwfukweb3doO0u60tiUxUD1kJm2o1Hg1+c2PySIJQM/F7lCLLcyzxoEbo3NQ3DTDpMdntbnKM5u86Azwrbn9mY/is6gGJY2EOUnl1xJQ8+xuXwgzu7ELseloSgsI11B2KGa5nMomSGIbpbw4PY/AvUT3quS7HqzkUdw9/JR+0A0k7PCE1wDPJGZCBbFBcuUWnNo4uh4M7xwcfHl3bKGZczo0Bqhv2cC8HQoSWCiTKuG4WKX/cNC0/uHUIA1TJI+NUX5MHs41h3z+9JKTkZU3JWDDG0FuUtyWUYzwFRrZ4m61ZqsqPUtiB8e13UNQ5Sa8FVCQbNyPgyhF5w8pba5+jToqVR//d2bsKpWUe9+MdvHYDF1B49CTLPfinquK4Vg97I91IdK3F88IqhJFM0vxCvcuk5WB64SaX0TgAMkxz56+tfAZRlt7SSrPiJkd5CHPSI9pT9iNBxpVNa+XjiszFNHw109nzrihjvpUfNc+SSyQN87h2vDrt+FC4l/M3lvpaeU2h8OZSRd09nnjOuXwEL4dyK+7mDNaIFZRNaJuPGvAzPJjm8c0Dpy2tynrWgoY+IfGHwwC63H06TX+V3r6G5syjKFXgnv3a2aYmBATcluW3JCBTEpNuwB+HfnlBuNcFLV2SNDY8Qs1LmK9LAeszCagahfE/i8k4KjJb368CmsIkxuWiSC7iEagQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(956004)(2616005)(44832011)(38350700002)(38100700002)(316002)(66946007)(8936002)(6486002)(8676002)(6916009)(4326008)(2906002)(26005)(5660300002)(66476007)(6666004)(66556008)(186003)(52116002)(6496006)(508600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEp3OWE1YlZ3Z1dnM3hGNVEvUUtrTFBuMGZUZ3JoVUJJeWcxSk1lQ2l0MDla?=
 =?utf-8?B?cXZQNlBkSFg2WWFCby9lLzI4MHdVMzFGQTEyS1Y0SmVCWThtTFlvZGx3VHF0?=
 =?utf-8?B?MlhpUVdZQWlXVWtGUlFpZzhvUGcvbVk3ZzByKzFBMEllVVZkQjBmaEJyZ3N6?=
 =?utf-8?B?RnhpZTF5TEtSQ3JnazdYRG5LV3o5MlQ3NTJrbzREdUQ4QW16ejU3aTRFY0xT?=
 =?utf-8?B?RXc4WSsybTFqQ3U5enIvVXk0a29IdGlRNm1UMkIrSEFuVy8vakhSdjB4Nldx?=
 =?utf-8?B?akhBSmhwTDRoOHJjUlE3T25LU21xRTFnYVhzQkcyYlgrWHBoSnV3TGdXMmRp?=
 =?utf-8?B?RVlBb09qalcwZVcvOG15TG1oL2hoNTdDVW00dmdpN1p2NUthQzBCK2NxN09N?=
 =?utf-8?B?QUxsZHptQmxPRk5QUHV4cXRmZW1Sd3MvRkRmL2NRQzQ0aVU2TEtielFyK0ZB?=
 =?utf-8?B?UHNEZ2t5MXN2QjcxZmVrSGlVZ2lXamZERFBmaXI0Q0RERmRCOGF2cjhwMHh3?=
 =?utf-8?B?MUlCckJjbFo0Ym5EYXBzM21vMmZ3M1UvMlovVDRpbndyUjZFUDl4NUY4Z2Rp?=
 =?utf-8?B?dUlmelhsNEcyQzE1anZQeEsrYXgzZTUwRHBwR3BCdEZZSHFBc3VOQ3N0Ukh2?=
 =?utf-8?B?WmlHbDlqQUlxaGRxOUZhTnRybCtQRmNjd2gyV3QrM2dndUppTUFrd3N4bE9u?=
 =?utf-8?B?aDhCZk1sOFh3aTdxMklRM3kxV3AvYWNEODVYbVMrbWQyWklYUERraWZmeG4r?=
 =?utf-8?B?ZGEzV3lrL0V1ZFVDUEszMUkxM1FWV2g0cENwL1FpbzdhdzNMb0NQZkhJZXNw?=
 =?utf-8?B?a1g0b3l0QUZwNG1EVkl4SlVlbnVhMTVIM2V0QmY3UlpEWkFMMjVlRU9SRzVv?=
 =?utf-8?B?MTVDS2dGbWNiMEVGM3BTNXR5MkUvMklaZzBGaERXRzNtR0RORm9wb29EeHMy?=
 =?utf-8?B?REhmVnhFZjRnNjNNb1YvV2t1MmJwV2NFTmhVM0dmc2xGM0RhNXVJajdEQjk5?=
 =?utf-8?B?ZmU1SFlLemF0dWpMMlJ3Q3dkdjFZN2t6WVJQdEI3MDMvcy8zOG4wSmV2VGlV?=
 =?utf-8?B?My9YVUY5S1o0czhsNFdVQXMzdm1BVjViWmNzUS9xTjBPMkNqdDB3QkdwMnln?=
 =?utf-8?B?V1g5NHNCbVY5eklCUyt4clV4ZndVTUxrKzJuR0U3L3NFN24wNWVmbkVWRXB1?=
 =?utf-8?B?MnE4SUt0N1h6VEFDdXAyVW9GeW94cGIvRU1xRSt6UU1uSFlDcTNuK1R5WU1h?=
 =?utf-8?B?UWZuVEZqckFNNHlTUXpvSGZjajNoenJwNFduelZWOG5aRjdVQlRTdmJqbEZp?=
 =?utf-8?B?Q3RCZk1VdkVNczFHU2ZLYkUxUkJvdi92U2duQ2xGTXNvVXY0STFrbXJqcGpS?=
 =?utf-8?B?ZE90MWUrbC95c2l6MXh4NUZncEtVVS9jYlh4VGgvQy90RWtxRTUwYnBkVlhZ?=
 =?utf-8?B?QVl6dUJjL0Y0QnVNaFJLRTNkUTkzQnpnUENsRnZlOHo3ZmN1S3VHT0xJU2pK?=
 =?utf-8?B?TDBYdzZOaTJqa3VrbDQwT0JOemp0UE1SSWlVcmtGczFESyt0dTBIMEJJQ2hr?=
 =?utf-8?B?dXNJU1FId1FEd0RRZGt2WmJ5VXAvTDBTK01nR2pQVk1ZZHBrMnpNeERDa0dP?=
 =?utf-8?B?VTNuZHBTMVR2a0F2Sjl0ZzVucU9lKzFzNXJyWi8rZFdHS2pBQ21Nb2RrMnNM?=
 =?utf-8?B?MkZmN2N5UUNvNlJydWlwbWlVZGE2Mml6SFlYUDlXblU3anBnUWRBbVNTN29h?=
 =?utf-8?Q?rh/NdglkwTk9k9/UCa4YBjasg58iRrCm/z/D4Wd?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54470f8b-3db7-43ba-a1cb-08d98359f2b3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 15:01:00.1960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SvCFUrHIsKYjNYc7yQ733MYG+oFaIEOYWzb7m9vOMMihL6tf93DXD4eEv4E1jEzYWxV4++wfHQHAPc6aA3J+KjJ99B/0SqXnr5EPQRiZp84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6285
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-09-28 at 06:31 -0700, Richard Cochran wrote:
> On Tue, Sep 28, 2021 at 01:50:23PM +0200, Sebastien Laveze wrote:
> > Yes that would do it. Only drawback is that ALL rx and tx timestamps
> > are converted to the N domains instead of a few as needed.
> 
> No, the kernel would provide only those that are selected by the
> program via the socket option API.

But _all_ timestamps (rx and tx) are converted when a domain is
selected.

If we consider gPTP,
-using the ioctl, you only need to convert the sync receive timestamps.
PDelay (rx, tx, fup), sync (tx and fup) and signalling don't need to be
converted. So that's for a default sync period of 125 ms, 8 ioctl /
second / domain.
-doing the conversion in the kernel will necessarly be done for every
timestamp handled by the socket. In addition, the vclock device lookup
is not free as well and done for _each_ conversion.

In the end, if the new ioctl is not accepted, I think opening multiple
sockets with bpf filtering and vclock bind is the most appropriate
solution for us. (more details below)

> > 
> Okay, so I briefly reviewed IEEE Std 802.1AS-2020 Clause 11.2.17.
> 
> I think what it boils down to is this:  (please correct me if I'm wrong)
> 
> When running PTP over multiple domains on one port, the P2P delay
> needs only to be measured in one domain.  It would be wasteful to
> measure the peer delay in multiple parallel domains.

From a high-level view, I understand that you would have N
instance/process of linuxptp to support N domains ? CMLDS performed by
one of them and then some signalling to the other instances ?

For our own stack (we work on a multi-OS 802.1AS-2020 implementation)
we took the approach of handling everything in a single process with a
single socket per port (our implementation also supported Bridge mode
with multiple ports).

What we miss currently in the kernel for a better multi-domain usage
and would like to find a solution:
-allow PHC adjustment with virtual clocks. Otherwise scheduled traffic
cannot be used... (I've read your comments on this topic, we are
experimenting things on MCUs and we need to assess on measurements)
-timer support for virtual clocks (nanosleep likely, as yous suggested
IIRC).

Thanks,
Seb

