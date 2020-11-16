Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD642B3D29
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 07:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgKPGcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 01:32:06 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:21363 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726898AbgKPGcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 01:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605508323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sbf0/qh59VmiqDzK3WYWy8ISDz3g46tPTYSwCcoB8dQ=;
        b=d0rCqY9uXOx/6JGfeS7f5Ocj2WhGv6d1/iN8lyArkHrBhcqCTiTjvW9C30P83KED3kSYtf
        jjy8gmcqiNANoiB21AKTDxqe5nY2E0jZjcH91IQ37xeuMeBrubRc7xE2QY85Qi985glGc+
        6MAjLVK7ZQ666AjGJ5eXcbQ2DMipqcc=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2054.outbound.protection.outlook.com [104.47.1.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-HH0-HTZxP32lxQznKiMTIQ-1; Mon, 16 Nov 2020 07:32:02 +0100
X-MC-Unique: HH0-HTZxP32lxQznKiMTIQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYRo3wMrEFEvDJzy3FC0lE8967jGd5gsCIqN4+LyaH3RXGT3efeQmqDJ00v5FjUW/B1umzMSFkZNAKX5Zo4tIlQG3se8h4boTvNrNI1YiDWkzFDBP/mV+UEJb13l9DVsZNb6reTYJcbRNhkm3HTi4Nvb3ozxfqzYV9DmvDfRjS2MU3p7cBV0EvJZSF1srqvwVjNKit/GjfngAi++PkxmAm0IuBUBw7iyMH2oNNQWpj/4gQGio13F6WzhG+T4py1+I3hjW4EYsGgKwI7P1UY/G7YvFx3zpEYtoJRrPEjr5NYCNv7NvOYM5aMN5LfEuaYv1O6gwT15D5oDvZHHSmIS0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sbf0/qh59VmiqDzK3WYWy8ISDz3g46tPTYSwCcoB8dQ=;
 b=ckc87LvdyVJXOU9hxuifUuFVB32cIYXIlqYfdRxqh/sfaG1jYDl8Una/WErwawJk8prx/5iHxZ0y9b2TFyTYRuvsnaOkg8wfsRZ2qN7XXbQ1sZLXANYMJdIoNxS7hOpDt92igwhoCcjgZwzyWUu15xyEzHglAkj1ADf+Sxg+imUhdhT3C22Z6SIrxwTk3NySs01MloPlRMKam714/rgzp21ZxunfNZM5e42rsn6deOWE+7bMXj8T1BVrP+K6dRwDjTO5Vj3NQalzwfyiprg05m2Nmw4QUduUM86elDgmQzMbE6rcJz9FLF0stoDn2OylaH0cWH0i60SLfTii+py9+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBBPR04MB6154.eurprd04.prod.outlook.com (2603:10a6:10:c8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 06:32:00 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::c84:f086:9b2e:2bf1]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::c84:f086:9b2e:2bf1%7]) with mapi id 15.20.3455.040; Mon, 16 Nov 2020
 06:32:00 +0000
Date:   Mon, 16 Nov 2020 14:31:50 +0800
From:   Gary Lin <glin@suse.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, andreas.taschner@suse.com
Subject: Re: [PATCH RFC] bpf, x64: allow not-converged images when
 BPF_JIT_ALWAYS_ON is set
Message-ID: <20201116063150.GU16653@GaryWorkstation>
References: <20201113083852.22294-1-glin@suse.com>
 <CAADnVQ+0m3OJs6eNOyZv4v0PrB3JDxkP=xCK5sbXQpJ9sWqBjw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+0m3OJs6eNOyZv4v0PrB3JDxkP=xCK5sbXQpJ9sWqBjw@mail.gmail.com>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM4PR07CA0034.eurprd07.prod.outlook.com
 (2603:10a6:205:1::47) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM4PR07CA0034.eurprd07.prod.outlook.com (2603:10a6:205:1::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Mon, 16 Nov 2020 06:31:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e89392d0-6013-4136-087f-08d889f95264
X-MS-TrafficTypeDiagnostic: DBBPR04MB6154:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6154D2901D901A8A1FBFD860A9E30@DBBPR04MB6154.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/fTDZFsLbxacwLLdkdOScnfMoDEJwO8feldQjQj/KMKZqUOKp1aR7EeXiZKxXLf0Gu0Oomz3y0Q7ozGzjvaKxTgRZyUg2a44xvXJZ03HJrdVOFJJcapdGqpVEIyGFiKbi3edRtrPbXYvLPqk/gZsBZVLsfOOAbwRMjF1w+I8/jo+FPwnuNMuxo04UNp85uNNkeCr6V0k4ER5TwcbmbOJA9HRDUCG80gC4J1nJsE1MT869IfoLkhaK0On6Lug4ARgCIFOE+L/s5pHWM0ngig0Ory/M/RggwJ/VxTu+aevjXsFm9UnkRS4/4ASRHqDkR2WqmCqaLesElK771Fp8Vdtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(376002)(396003)(366004)(2906002)(107886003)(6666004)(53546011)(16526019)(52116002)(54906003)(83380400001)(33656002)(26005)(6916009)(478600001)(186003)(55236004)(956004)(6496006)(5660300002)(33716001)(8676002)(9686003)(8936002)(55016002)(86362001)(1076003)(66476007)(66556008)(66946007)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FZ5HWw3TdLT+vQhnu69AVM0QzsUcfCou6qpztGH5ZpIsyApRGL6+XRdZtLvBlP8KXK/R4jwM/BX5qdqQoY/A6u/6Ygg1ezR83RGYCJo5rXqFJrBKl6QkHZaFH3KcSmFrQRsXUF/21uLYDuOtee8uLipktSJuX8XHzM7uNdaHyGsH4fFYDiuOYdJHw1EidCuTizTXBl10vHmatzKqC7MzFkZ7MasuigGVZDz9n3BKBdiKopJGb3UvDgLEhDVsdyjsZvf1Z6CYwO+85Avid5wr//koLc6FdJA2TRdVlavgNi9UTnm7UAnb+mHxpP76/u1zzBGV3kPzr4XZcnU+H24psHJreLhEZ0TFGXs3eqogTix46ZotJGG4GSJMwbcPb9866oxr7lg1lVfh4CJry2xG16U9uP8W5fvWR23gPssDoH9z37QhkKmo8LTWn288OL4n3eEoILXjySLdVpMAzKYJQYe7yx5XiidmjA8J56F2JbhIcjBvaaWIH53vwv4slKMjrApzouLJoAM6+uc4wkwXii5dWkfb1r/8Y/qn84sxurRIHYblsnrl3lamFFf08UwyNgxJI9S3DdV2txXB4jCySeBBAZ1H9BODeG2CTYcdi4v/RafwB8tO3tShZrRjfRyS0p59GneFx9+H746WpWGHhA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e89392d0-6013-4136-087f-08d889f95264
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 06:31:59.9482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DjNhqF8hcO/6Oq8y8hX0DJUP8HUqB/doLrZw9NpzSINxUOYfjq+9Cng9rHVZ6q49
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6154
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 05:48:31PM -0800, Alexei Starovoitov wrote:
> On Fri, Nov 13, 2020 at 12:40 AM Gary Lin <glin@suse.com> wrote:
> >
> > The x64 bpf jit expects the bpf images converge within the given passes.
> > However there is a corner case:
> >
> >   l0:     ldh [4]
> >   l1:     jeq #0x537d, l2, l40
> >   l2:     ld [0]
> >   l3:     jeq #0xfa163e0d, l4, l40
> >   l4:     ldh [12]
> >   l5:     ldx #0xe
> >   l6:     jeq #0x86dd, l41, l7
> >   l7:     jeq #0x800, l8, l41
> >   l8:     ld [x+16]
> >   l9:     ja 41
> >
> >     [... repeated ja 41 ]
> >
> >   l40:    ja 41
> >   l41:    ret #0
> >   l42:    ld #len
> >   l43:    ret a
> >
> > The bpf program contains 32 "ja 41" and do_jit() only removes one "ja 41"
> > right before "l41:  ret #0" for offset==0 in each pass, so
> > bpf_int_jit_compile() needs to run do_jit() at least 32 times to
> > eliminate those JMP instructions. Since the current max number of passes
> > is 20, the bpf program couldn't converge within 20 passes and got rejected
> > when BPF_JIT_ALWAYS_ON is set even though it's legit as a classic socket
> > filter.
> >
> > A not-converged image may be not optimal but at least the bpf
> > instructions are translated into x64 machine code. Maybe we could just
> > issue a warning instead so that the program is still loaded and the user
> > is also notified.
> 
> Non-convergence is not about being optimal. It's about correctness.
> If size is different it likely means that at least one jump has the
> wrong offset.
> 
Ah, I see.

> Bumping from 20 to 64 also won't solve it.
> There could be a case where 64 isn't enough either.
True. Increasing the number of passes is just a workaround.

> One of the test_bpf.ko tests can hit any limit, iirc.
Thanks for the pointer. Will look into the tests.

>
> Also we've seen a case where JIT might never converge.
> The iteration N can have size 40, iteration N+1 size 38, iteration N+2 size 40
> and keep oscillating like this.
> 
> I think the fix could be is to avoid optimality in size when pass
> number is getting large.
> Like after pass > 10 BPF_JA could always use 32-bit offset regardless
> of actual addrs[i + insn->off] - addrs[i]; difference.
> There could be other solutions too.
> 
So the size convergence can be ignored if all BPF_JMPs are translated
into 32-bit offset jmp?

Thanks,

Gary Lin

