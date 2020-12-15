Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92122DA5D3
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 02:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgLOBvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 20:51:54 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:44522 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbgLOBvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 20:51:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607997015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cbIyXZtYgaTzVyr/KhyxdINNB/RQPoZnr1qAmioKoL0=;
        b=BcydWBjse8IxljxiuEKJy47lDQHhZ6ZP9KHeSFH0ZOK3UDsXWOUiBNuhdBR10zWF4vT3fE
        LeSbjwBOz3and64HYjZlJpdlS55HOYTMw6YthwWpDMI5sjiBCgYjXYPkvlSHFWhRyv6+or
        YDWMCm5EWw1a33KFiph8IX0QwD0xPBQ=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-6-8b4b6vMaOyWvDC7lDrnnFQ-1;
 Tue, 15 Dec 2020 02:50:13 +0100
X-MC-Unique: 8b4b6vMaOyWvDC7lDrnnFQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QW38QFH8mEycRxR0EnURSGGo7nlzkndvhiyaeRGAgjn9wsgRwixp7eqbQLktFw4glePqDQwvPSo/89IkEcbBjh55Putqg7/I5N8rUOqIx+iur9YipeCHSRDHYGUTymf0PAO4N0Lx65AoExOQD5vKHTiBFOUdaRLm3uPXaXMN+Q/mHMV2mYUf3a3+GU8BpbNwMI7gzCXY81e6Mwf2f6TuiTMIv5HaZ9jXhdFIZuBPBa2URRVheLbxufFBMlcYv/hI68DVnZU2zs6HtGaifMKmAP8t6P6rVPS8aJvXM6oml6R0JoeQkqQuTKRh4HO0vEUrbI0vTzrZwntieA7cHMv4qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbIyXZtYgaTzVyr/KhyxdINNB/RQPoZnr1qAmioKoL0=;
 b=MnCtTxX4vBEw/KA0KgXzs7rwUblx4x6EaT7Y7Vzcz7JhK1eHW58JmWSO0l7MxsDj0IA0DKd5HRLNlJvR5u9l52HtgItlAT2vsj+Bsf3yGWq9c2K1P+76fIJfpL10ubZwFe3k/XO7BTERVZ3fFHAsDcQHUxw1BHH70ZUTTyhB8btDZcuGAys8Xdfo1AJiKdYbG8YjGE6psUs5oIbliKyCCOn/zYIqOmaggMITcxe/AH52fY5KKArXOegvQp5unLjeueqDr00t//rEbgfiIDbvz9tNvGo7UTh7VFIu7kJw5sdUo602qdpf4Ia7eU+APNEhnrjUu0EjBVWPbiQfuU0VxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 15 Dec
 2020 01:50:12 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 01:50:12 +0000
Date:   Tue, 15 Dec 2020 09:50:02 +0800
From:   Gary Lin <glin@suse.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        andreas.taschner@suse.com
Subject: Re: [PATCH] bpf,x64: pad NOPs to make images converge more easily
Message-ID: <X9gWStMFulD4DwHR@GaryWorkstation>
References: <20201211081903.17857-1-glin@suse.com>
 <61348cb4-6e61-6b76-28fa-1aff1c50912c@iogearbox.net>
 <X9biZvkGPfslPOL4@GaryWorkstation>
 <X9cfFVKMFwtKdbNS@GaryWorkstation>
 <0aeb3768-7894-1821-0188-25725f9b2296@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0aeb3768-7894-1821-0188-25725f9b2296@iogearbox.net>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM0PR02CA0164.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::31) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM0PR02CA0164.eurprd02.prod.outlook.com (2603:10a6:20b:28d::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 01:50:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8151267-a979-42b1-87aa-08d8a09bc2f1
X-MS-TrafficTypeDiagnostic: DB8PR04MB7163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB71630AA99F2BBF8E48F4E26AA9C60@DB8PR04MB7163.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zm4jiP45ATqZb7UCyulrzI8IcN2TpsB6f3HX5xehrHv9An2sEYpUOcZZe0Vkpe+WKkjjBD/O63frfMI1mW5gbUTZS5eKwOm/lBGsDuimGhDrR7XrvDdcQiNtHFcPBVxDlvxW6VD3SjEvx1qVd2WJgqveDymykwOYgRqxjGXSADpK0pygvMn9sOpZqMj3KgmH0m7KM2oY4Es2S51Ek8r+R3UmdmIURE7+ENs9TCNK+WbDCD4jCb1iuneKbK0ztEFON3VwXLy+o03ob8LbKr0gwfbTw5OHxKRjO/us0ExWiepK4/2i0hTTze6et0ojcoXSujaNMyrjEoQcm0BFNleNIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(396003)(39860400002)(66946007)(956004)(316002)(107886003)(4326008)(54906003)(16526019)(186003)(86362001)(55016002)(8676002)(53546011)(55236004)(6666004)(6496006)(5660300002)(52116002)(33716001)(6916009)(2906002)(9686003)(66556008)(478600001)(26005)(83380400001)(66476007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?87FwE6ntsxZbEkSyrSAUtVymom1zxRUKVOvRDUv690O8cLtMIzHtOJNdHifb?=
 =?us-ascii?Q?4h4om5f9m5wIp3PnmdDX5oAmyT2c1qAUKP9Z3CIZUJ7elY4xBNp+x+UeAsbD?=
 =?us-ascii?Q?S37gq/tZjhNp4M7imRedqfshzzTfxUFWROVml2o/C8RflrPmKhNhxCk1WEuN?=
 =?us-ascii?Q?NkOO4+1vvbmbDj3v3JMhObhsCM3JFSk8ags6Rwg7GKEzPlIZWKt2LXI+E2IX?=
 =?us-ascii?Q?oj2pZGP8iRmgjcPfAJ7AWShxeIN78XFLNZJbITWzVK+xtUaoWm2F0EpB92p0?=
 =?us-ascii?Q?JrZsLeRjlilyX4EISo3JXcfJtV9hr9LvXrBVJFxuynzMCK6dfyqgGWKVrkGV?=
 =?us-ascii?Q?9HZClYUCIdZe5ic69uU1aGQPZ2tNr72gU3AGh1lSGkepzp7U1x+fx1tin/lE?=
 =?us-ascii?Q?Mq7zpczpUK0NcXzRCWsxo88xN4VSn+R4dzU2J3jQYa/EUkf25h2QARUu3c0p?=
 =?us-ascii?Q?S/g1SSFNU3XqsAA30k3IvUc5/ZG76ghztYKo5fof7cvN/AmL0Tvx+4IWG6aq?=
 =?us-ascii?Q?5tNSlh1N1Vsw+ULeqJ/ZQ3C+qju+Hn5IESQaKVfX37HW5yfDx+G1XUmhMx4b?=
 =?us-ascii?Q?nEdZu812rdRaqjTFWQ0w48PdNmr5m16Zh9TYKNqbRVudjx8y7+3tcv8Vngly?=
 =?us-ascii?Q?YCkZSHKrlOb8v9DLT8oa+xmGNUSrUbHetJF35i7pxd3VYQKFtomZZR42ajR0?=
 =?us-ascii?Q?+rzQL3rV/B1GCAqVlNfg1zvMaEHkDBoaGwVLhgz1cu4IpAEunAZLe5eyvCHj?=
 =?us-ascii?Q?+bWK6qvw3TY8zFQiA5JuUSjVHcw8PFIRzMsxXmOOn4JXzqkgSD59MYibTiXV?=
 =?us-ascii?Q?OpqoClEGIDsFlBZU312kzd280X8qyCWmG06SDAEaXKuoL9BxRffVYTyljCKD?=
 =?us-ascii?Q?/hfCrgYp1BsvcMB1F2XLqawWojOjqSJ2Lya3GvY+RBe8ybVhQ1QUk6wPRlLj?=
 =?us-ascii?Q?ERv5mF+Bmmm+zigDQvr51XbKWTLqrzA6pWGvLwZOFrN6tEa9RQJBQUE1hUUR?=
 =?us-ascii?Q?vehJ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 01:50:12.3099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: f8151267-a979-42b1-87aa-08d8a09bc2f1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/wSC+bB0GQM9sV5z8m3NUfkN+hJv/AqE4Kr08N5rxs9LMwSmLtDWSh2xmIOfn4A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7163
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 04:31:44PM +0100, Daniel Borkmann wrote:
> On 12/14/20 9:15 AM, Gary Lin wrote:
> > On Mon, Dec 14, 2020 at 11:56:22AM +0800, Gary Lin wrote:
> > > On Fri, Dec 11, 2020 at 09:05:05PM +0100, Daniel Borkmann wrote:
> > > > On 12/11/20 9:19 AM, Gary Lin wrote:
> > > > > The x64 bpf jit expects bpf images converge within the given passes, but
> > > > > it could fail to do so with some corner cases. For example:
> > > > > 
> > > > >         l0:     ldh [4]
> > > > >         l1:     jeq #0x537d, l2, l40
> > > > >         l2:     ld [0]
> > > > >         l3:     jeq #0xfa163e0d, l4, l40
> > > > >         l4:     ldh [12]
> > > > >         l5:     ldx #0xe
> > > > >         l6:     jeq #0x86dd, l41, l7
> > > > >         l8:     ld [x+16]
> > > > >         l9:     ja 41
> > > > > 
> > > > >           [... repeated ja 41 ]
> > > > > 
> > > > >         l40:    ja 41
> > > > >         l41:    ret #0
> > > > >         l42:    ld #len
> > > > >         l43:    ret a
> > > > > 
> > > > > This bpf program contains 32 "ja 41" instructions which are effectively
> > > > > NOPs and designed to be replaced with valid code dynamically. Ideally,
> > > > > bpf jit should optimize those "ja 41" instructions out when translating
> > > > > the bpf instructions into x86_64 machine code. However, do_jit() can
> > > > > only remove one "ja 41" for offset==0 on each pass, so it requires at
> > > > > least 32 runs to eliminate those JMPs and exceeds the current limit of
> > > > > passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> > > > > is set even though it's legit as a classic socket filter.
> > > > > 
> > > > > To make the image more likely converge within 20 passes, this commit
> > > > > pads some instructions with NOPs in the last 5 passes:
> > > > > 
> > > > > 1. conditional jumps
> > > > >     A possible size variance comes from the adoption of imm8 JMP. If the
> > > > >     offset is imm8, we calculate the size difference of this BPF instruction
> > > > >     between the previous pass and the current pass and fill the gap with NOPs.
> > > > >     To avoid the recalculation of jump offset, those NOPs are inserted before
> > > > >     the JMP code, so we have to subtract the 2 bytes of imm8 JMP when
> > > > >     calculating the NOP number.
> > > > > 
> > > > > 2. BPF_JA
> > > > >     There are two conditions for BPF_JA.
> > > > >     a.) nop jumps
> > > > >       If this instruction is not optimized out in the previous pass,
> > > > >       instead of removing it, we insert the equivalent size of NOPs.
> > > > >     b.) label jumps
> > > > >       Similar to condition jumps, we prepend NOPs right before the JMP
> > > > >       code.
> > > > > 
> > > > > To make the code concise, emit_nops() is modified to use the signed len and
> > > > > return the number of inserted NOPs.
> > > > > 
> > > > > To support bpf-to-bpf, a new flag, padded, is introduced to 'struct bpf_prog'
> > > > > so that bpf_int_jit_compile() could know if the program is padded or not.
> > > > 
> > > > Please also add multiple hand-crafted test cases e.g. for bpf-to-bpf calls into
> > > > test_verifier (which is part of bpf kselftests) that would exercise this corner
> > > > case in x86 jit where we would start to nop pad so that there is proper coverage,
> > > > too.
> > > > 
> > > The corner case I had in the commit description is likely being rejected by
> > > the verifier because most of those "ja 41" are unreachable instructions.
> > > Is there any known test case that needs more than 15 passes in x86 jit?
> > > 
> > Just an idea. Besides the mentioned corner case, how about making
> > PADDING_PASSES dynamically configurable (sysfs?) and reusing the existing
> > test cases? So that we can have a script to set PADDING_PASSES from 1 to 20
> > and run the bpf selftests separately. This guarantees that the padding
> > strategy will be applied at least in a certain PADDING_PASSES settings.
> 
> I think exposing such implementation detail to users is not that great as they
> normally should not need to worry about these things (plus it's also rarely hit
> in practice when developing against llvm). On top of all that, such knob would
> have no meaning in case of other JITs since most other non-x86 ones have a fixed
> number of passes. I think it's probably useful for local testing of the fix, but
> less suitable for exposing as sysctl 'uapi' upstream. Re crafting a test case for
> bpf-2-bpf calls, you could orientate on bpf_fill_maxinsns10() in lib/test_bpf.c
> which is also triggering a high number of passes, port it over to test_verifier
> from selftests and experiment from there to integrate calls.
> 
Thanks for the hint. Will try bpf_fill_maxinsns10().

Gary Lin

