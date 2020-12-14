Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995792D940D
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 09:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439180AbgLNIQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 03:16:42 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:32725 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439166AbgLNIQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 03:16:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607933733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kJKBgIJi+rhz0CjN2u2cSpK9GcGiqrY8Jarwb9HpZIo=;
        b=LtJYD9TvUxAIwOe11Hx4fFiGSrkGG8vlrcW0fIthWu8fM8fMj8djWpfxbvcQNsIq5SYsoD
        fR3v4uSE+mYoOTgppbStT9GuAKdJgEpx8zlyjZo6D/sLLcmRaPnxkmOHkmgRaALicbqPS5
        L0SGlmqFK6REpgvdFOHdSXHIBoaNOEk=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-5-TFzkqUPHKQSATAb55dPA-1; Mon, 14 Dec 2020 09:15:30 +0100
X-MC-Unique: 5-TFzkqUPHKQSATAb55dPA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WcX99+y92Id9wuNKeU8jpnkDathXguSH2m20QfqcI1XDnghqtPerkEQ8FGPmLlXrh720QCVY12YVF7KQKxmDww0XdiZ3n1ppWP+SEE0rK/DgB2KLfd2RSgAuSPEi53Z7BC4rh2QH/t4onQDzIdV2wcCRTTn4fhsCB7KWiIikeTB68OreN0xUaspoHJ8b+KNiY6cXYd3c+OS6rBJvAmr9FH+oqQQWhVzVcOso7xfNandd6eAemR3XFIpN9xrIwPPPnBetgFJvUL898/R6NQ4KwQg3yNxngch6eB4J0PmT+fBvOqzHTwgXV+GExtEy9EKjivcCNvnMCqAdMOv8dzUL+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJKBgIJi+rhz0CjN2u2cSpK9GcGiqrY8Jarwb9HpZIo=;
 b=nfIj2vN5uoZ3+6oSvNTh/i99p9tbpcxwYhP4TK2g/ZfwXn1fNeYg7KefSytoq4n1416HNjuZ6Fx6OyO+cN6cqexGnqxByQkUsLCu3T6uOPdgar5JoB1eicgehcccIKbsgOEBcqAYWl1nq6DMWlISS/KFKUaYsiZeQwnHjLD93h6zKqombKkrh8eEa9BUzJxVT3DrdWZWRORLIapRegu5LlRqPPS42Z2qFzp9lo/1A/Xon2nDSXPyhgZbJ7bs0N0yPMbX2nzcr+71j4lT0Xw2YGJIGAZuf2e1n2QYByhsIcY3+rsdzuoC3gXrLIUgWNg1M6zs7+f6OrPFxSz71XVQug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB3PR0402MB3897.eurprd04.prod.outlook.com (2603:10a6:8:12::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Mon, 14 Dec
 2020 08:15:28 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 08:15:28 +0000
Date:   Mon, 14 Dec 2020 16:15:17 +0800
From:   Gary Lin <glin@suse.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        andreas.taschner@suse.com
Subject: Re: [PATCH] bpf,x64: pad NOPs to make images converge more easily
Message-ID: <X9cfFVKMFwtKdbNS@GaryWorkstation>
References: <20201211081903.17857-1-glin@suse.com>
 <61348cb4-6e61-6b76-28fa-1aff1c50912c@iogearbox.net>
 <X9biZvkGPfslPOL4@GaryWorkstation>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9biZvkGPfslPOL4@GaryWorkstation>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM0PR02CA0102.eurprd02.prod.outlook.com
 (2603:10a6:208:154::43) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM0PR02CA0102.eurprd02.prod.outlook.com (2603:10a6:208:154::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 08:15:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d18cfb2-7dab-4610-7f2f-08d8a0086a98
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3897:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB38976A546E8E5D699990D5ADA9C70@DB3PR0402MB3897.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gNfy9sw9qmHskl5ejDia5Xqn8hVNY8WhZGOmGsY1Pl8PlabJ5OxAswZbdqvTwJsrQkxw9x5DZo6FpMwN31koztN2BN4cWCUuV0OG/62wa23LLnmB+jh+5kQ/rKjhCTvYD8RxYLwjddEYM4d03glsh5TOe+knzHbiMo6HgwqA/4vIxMJVXxyDkB8efUO/cmKYdz0DPK1W3xNEf8qg2SuF8VVsetMqcTpTHnIpjTM0MxJyGDFkD1uiOGgLhE7o3huCKCSuiiTXNLoaNVorHeuTBTr8CusAMEZwfEM/00FNL9bbBvAPzaPqhmuwcbuS89LsaXifACRsDp5d1heBoBeRlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(376002)(346002)(136003)(478600001)(8676002)(8936002)(26005)(52116002)(66556008)(186003)(54906003)(5660300002)(316002)(6666004)(6496006)(66476007)(53546011)(83380400001)(107886003)(55236004)(9686003)(86362001)(66946007)(33716001)(2906002)(16526019)(6916009)(956004)(4326008)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VybZ0pquN8KSXjCin6l91WqvF1TCQpCCGD94Xv3jU7ixIUfAH9ImnpJqTWsE?=
 =?us-ascii?Q?TtDI6gjdFL3mLxHwbiKMi0fhWf7ArnmZICUMAcFBlL3tFGHxRSDIUt3qxVzW?=
 =?us-ascii?Q?8nYYdP1wO2bLImRSiUjLtxQKYLY7DrfNO6PO10AmsnfzpxMjH5On40fqGdVJ?=
 =?us-ascii?Q?CysS2qQUfLkf+8H8mSPt/jnSaleVleuzyomczK6B22BDS4kQWiuNmP/2k7zi?=
 =?us-ascii?Q?G4vXX7UCT7zZHmfhT1OwAlKOB+go8gfM/UcwbCKtPgAPbaY2x1NnylRdte51?=
 =?us-ascii?Q?zjalcB51hbyUqG892lPAH1cW9LqIOZfGw8Tt8cFty1fpaDKj8uLOj53v0IT0?=
 =?us-ascii?Q?Kqe/8nL0Il75ONnDOFIllwyfEHTV2bUR2GbxgL09r2bUPTcs0pn7qhON5F8M?=
 =?us-ascii?Q?NlXWMjw4Sx+t/mGBw8laZdZDIm42KwDpaJgJTgFsfpYrH+fLixofjcVxYYV3?=
 =?us-ascii?Q?Vk4MZX9G00lYn2x58+pGEGcbpFQ76ICCFteLuFT2xDeOnVeYVUi12fs0MKQP?=
 =?us-ascii?Q?sDnb2lkir+Zx20PY8w5RQeEzMYSQQbTrGXMuKUsgtEDqGKnjmBaGALIUuUmI?=
 =?us-ascii?Q?Uircpm+uTbLVx2zI8vQ/ZTyiTKr7NZgsVWRGxYRWIxZ7Juyq2ubqRsUBGNpg?=
 =?us-ascii?Q?Usxa52TXzZNwErWZnsDP7YPXUZz/blrLQQFHBx3A5nnuPWBdYaZ4MJPCzZNi?=
 =?us-ascii?Q?GcJpLNtH5lfvrMbPoI0JNBUCovQvXAH6t8TiMy+PYQQH8qPPmRSFUraH3Iol?=
 =?us-ascii?Q?eZKUz/7gO7mViZT56hgCkhZ2o+8Qs9HpbqQpHwjjOpMEMqObtTE3iGZyJSjV?=
 =?us-ascii?Q?zTxOJijASClXEEO6IN5Xwhvnn3ffMYjx4q06CTPYBDMnVFB5d2kVBW5HMUqi?=
 =?us-ascii?Q?/cfof75GUlgFfVyax9OVdyw6qFITy0lC/9kBwobeAt4KYapk7m8V0om1rwZ6?=
 =?us-ascii?Q?ZTAqlDljo9dkmUp4ezhFsTkCA9Do+I3l7OYIlL5Cm1ZvZy/tABKlLrxL3YaO?=
 =?us-ascii?Q?KWHX?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 08:15:27.9957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d18cfb2-7dab-4610-7f2f-08d8a0086a98
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6kY9+ofqA2c2u3XWenT6kUVHh8H6JT03HzK9vKYPfhTA4RT/jCWc0o5vcCSDHP0p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3897
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 11:56:22AM +0800, Gary Lin wrote:
> On Fri, Dec 11, 2020 at 09:05:05PM +0100, Daniel Borkmann wrote:
> > On 12/11/20 9:19 AM, Gary Lin wrote:
> > > The x64 bpf jit expects bpf images converge within the given passes, but
> > > it could fail to do so with some corner cases. For example:
> > > 
> > >        l0:     ldh [4]
> > >        l1:     jeq #0x537d, l2, l40
> > >        l2:     ld [0]
> > >        l3:     jeq #0xfa163e0d, l4, l40
> > >        l4:     ldh [12]
> > >        l5:     ldx #0xe
> > >        l6:     jeq #0x86dd, l41, l7
> > >        l8:     ld [x+16]
> > >        l9:     ja 41
> > > 
> > >          [... repeated ja 41 ]
> > > 
> > >        l40:    ja 41
> > >        l41:    ret #0
> > >        l42:    ld #len
> > >        l43:    ret a
> > > 
> > > This bpf program contains 32 "ja 41" instructions which are effectively
> > > NOPs and designed to be replaced with valid code dynamically. Ideally,
> > > bpf jit should optimize those "ja 41" instructions out when translating
> > > the bpf instructions into x86_64 machine code. However, do_jit() can
> > > only remove one "ja 41" for offset==0 on each pass, so it requires at
> > > least 32 runs to eliminate those JMPs and exceeds the current limit of
> > > passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> > > is set even though it's legit as a classic socket filter.
> > > 
> > > To make the image more likely converge within 20 passes, this commit
> > > pads some instructions with NOPs in the last 5 passes:
> > > 
> > > 1. conditional jumps
> > >    A possible size variance comes from the adoption of imm8 JMP. If the
> > >    offset is imm8, we calculate the size difference of this BPF instruction
> > >    between the previous pass and the current pass and fill the gap with NOPs.
> > >    To avoid the recalculation of jump offset, those NOPs are inserted before
> > >    the JMP code, so we have to subtract the 2 bytes of imm8 JMP when
> > >    calculating the NOP number.
> > > 
> > > 2. BPF_JA
> > >    There are two conditions for BPF_JA.
> > >    a.) nop jumps
> > >      If this instruction is not optimized out in the previous pass,
> > >      instead of removing it, we insert the equivalent size of NOPs.
> > >    b.) label jumps
> > >      Similar to condition jumps, we prepend NOPs right before the JMP
> > >      code.
> > > 
> > > To make the code concise, emit_nops() is modified to use the signed len and
> > > return the number of inserted NOPs.
> > > 
> > > To support bpf-to-bpf, a new flag, padded, is introduced to 'struct bpf_prog'
> > > so that bpf_int_jit_compile() could know if the program is padded or not.
> > 
> > Please also add multiple hand-crafted test cases e.g. for bpf-to-bpf calls into
> > test_verifier (which is part of bpf kselftests) that would exercise this corner
> > case in x86 jit where we would start to nop pad so that there is proper coverage,
> > too.
> > 
> The corner case I had in the commit description is likely being rejected by
> the verifier because most of those "ja 41" are unreachable instructions.
> Is there any known test case that needs more than 15 passes in x86 jit?
> 
Just an idea. Besides the mentioned corner case, how about making
PADDING_PASSES dynamically configurable (sysfs?) and reusing the existing
test cases? So that we can have a script to set PADDING_PASSES from 1 to 20
and run the bpf selftests separately. This guarantees that the padding
strategy will be applied at least in a certain PADDING_PASSES settings.

Gary Lin

