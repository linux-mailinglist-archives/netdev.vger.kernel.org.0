Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328045F71C9
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 01:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbiJFX3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 19:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiJFX3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 19:29:35 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C84EB7E6;
        Thu,  6 Oct 2022 16:29:33 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id a13so4938815edj.0;
        Thu, 06 Oct 2022 16:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=IVJ+0deY1Eo5hDLD4+mpPE7ASzz+9apYfEsTE2gsvL4=;
        b=YQxoq5MTTWDsImxgICNAkJzTJGmYVyTn4IL3mOyoE+5FU2enkcqbtpg9MJBSS2RVz6
         tG3i+zilBW4trZR6zUZ2eqS1zPG+Gx0zQpHiT/h0E+QO1CGCgtaE+yAzNU82shAs+kqY
         vi58Dk6PAKDYDdqdHf/xVUHVNkDHzxX4zFnaMPp/E4SATtwxkW1Z2pWxu/YamqUxdSMO
         xH9FbevXvD1jJdZzOjKyFKG7qId6MUIb5oUolAMl0vOrfmpgX7ovPj18Mv+qf1nrO5iT
         vi8S6Ts5At3W/BsVwVHU/+5cn7YrtY7Ad0cA21IbDgkp3qevIqdSqyn1K1i/mezLRMyQ
         aZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=IVJ+0deY1Eo5hDLD4+mpPE7ASzz+9apYfEsTE2gsvL4=;
        b=BIDREES/RYAPtiOnkWhLIo2JXKUF1JVNIHv/b6TQZNPVkR5vBcm3QRx8pxl7iOkA7/
         utw2aSI+JTtDsOot8PeKGNDGGdnXjzRlSqEfgMgNCsFBEcrG7C80SqwmgZBO4bOdBwM3
         6lVwkbrVGKRldwEiVw86KB/YN1pgS7FJfFtwwdcizw42ZI1cEagmHjNxeE1qLbbsbOWE
         L2ToBoDJ+1Y7yUbvJ1hOExldGYO4uz/v6Hg53kv5Adawgx3atx0BFmhu1WeWt7F+UnxA
         YgeGdP/lXXiloPR/qmKMRy97CXpy4+jZzKDn7KwerI6wQeO92dIeeyMGPfBoYPafXwOn
         wd6A==
X-Gm-Message-State: ACrzQf37IU47y86DUrnoSmDHmiFeJtBescfwgwS+uFqPHJg3rDa6dPfB
        6mxlCMuhurETfRc++/X7+0Bo8OWScQuUeLsINphliE1i
X-Google-Smtp-Source: AMsMyM5yrhBKwVakPB924RVM8eIXYSaDlNey5os8PDPf23yL3UhiHevakN24lGzfkJ0/ohxbLffO7DcWDGZuim40WO8=
X-Received: by 2002:a05:6402:42c3:b0:459:cebb:8d3a with SMTP id
 i3-20020a05640242c300b00459cebb8d3amr2025530edc.421.1665098971850; Thu, 06
 Oct 2022 16:29:31 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-2-daniel@iogearbox.net>
 <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com> <CAM0EoMnJzP6kbr94utjDT1X=e9G21-uu=Cbqhx2XLfqXE+HDwA@mail.gmail.com>
In-Reply-To: <CAM0EoMnJzP6kbr94utjDT1X=e9G21-uu=Cbqhx2XLfqXE+HDwA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Oct 2022 16:29:20 -0700
Message-ID: <CAADnVQK2tWmZW0=y89mv-r9kO4U2H=azWmbr7g1yqLhU1aX3SQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Joe Stringer <joe@cilium.io>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 6, 2022 at 7:41 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On Thu, Oct 6, 2022 at 1:01 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Oct 05, 2022 at 01:11:34AM +0200, Daniel Borkmann wrote:
>
> >
> > I cannot help but feel that prio logic copy-paste from old tc, netfilter and friends
> > is done because "that's how things were done in the past".
> > imo it was a well intentioned mistake and all networking things (tc, netfilter, etc)
> > copy-pasted that cumbersome and hard to use concept.
> > Let's throw away that baggage?
> > In good set of cases the bpf prog inserter cares whether the prog is first or not.
> > Since the first prog returning anything but TC_NEXT will be final.
> > I think prog insertion flags: 'I want to run first' vs 'I don't care about order'
> > is good enough in practice. Any complex scheme should probably be programmable
> > as any policy should. For example in Meta we have 'xdp chainer' logic that is similar
> > to libxdp chaining, but we added a feature that allows a prog to jump over another
> > prog and continue the chain. Priority concept cannot express that.
> > Since we'd have to add some "policy program" anyway for use cases like this
> > let's keep things as simple as possible?
> > Then maybe we can adopt this "as-simple-as-possible" to XDP hooks ?
> > And allow bpf progs chaining in the kernel with "run_me_first" vs "run_me_anywhere"
> > in both tcx and xdp ?
>
> You just described the features already offered by tc opcodes + priority.

Ohh, right. All possible mechanisms were available in TC 20 years ago.
Moving on.
