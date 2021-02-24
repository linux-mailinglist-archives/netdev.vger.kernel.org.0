Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4C032372A
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 07:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhBXGMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 01:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhBXGMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 01:12:17 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86902C061574;
        Tue, 23 Feb 2021 22:11:37 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id q20so650045pfu.8;
        Tue, 23 Feb 2021 22:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zj6+s1mx4qT4hXPh+NVhs6pnLcrPSvpQ67tRttpHvuE=;
        b=YVXAxRJHtvuM3L+8WKDEVsUFCtWHPk4D8PH0fZ8I0jm/nVJDg9m7sNTKMiclG+1l/d
         rTwMefnFpSb8tXzbsB9FP2YdiTyyorEYnwGWkjI5iVlfn4nHSxmUstfbXC5YOFTrYqNy
         6KI5fdpfStniAtWa4KGwEsubmbGiPsUNJfbI9R/4QE4PvS+G5EIAh6xfM1hIMNPCyJ/Q
         J0vKoJEX56mp/9Lds+B+P3aNTpcddqwuc4+AanL/T1gcQSvu1U0AY/H55lJRf4tCe7kI
         KSUlUj6cmJxHMY9oXRe+xuKNve13f4mZ1OysKLfG8MOMWQIoEru38uwutmJmXZ8/ziZi
         GRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zj6+s1mx4qT4hXPh+NVhs6pnLcrPSvpQ67tRttpHvuE=;
        b=tE/T+lK7Ddcjnw1G3SmXvn184/nPMCxrZudRS6BjznXHSpwzdXeueCzTK5p93VUdpJ
         /Ic+8ykf0WvYnsjDq79+ljWLzxNK3AR+6Zcd+tUZhcrl+XfEZEbHXpb6p0YCtC2/2Ylp
         eBKo2juOZwtcSJSCOKuNLBO8zw7btmcj3TjU/sU+YsK1s+xze4YWzxjWfwT7qEaFX37y
         T7KnLM7lw6uswsc370hxYlVmHWpAbSR0UPdI+KIUv4xJ+FmKObGnftAteo017m1oPhem
         Wnzwm/VuG78vhxiBFdKTkhwuvsASd7P6liTiZxma6acRUbtd7uvDUG6kDtS5Dij+cp19
         TKXg==
X-Gm-Message-State: AOAM53345kPsFsRF2Q2NUU5hofbsezOwrZhnqhH6TeA/0IsCfJIHHqHT
        jWtoufbyGIvG3YYQOOyz/co=
X-Google-Smtp-Source: ABdhPJy2uhG4S1YTka5Y9czANAmaTrDuIei2RSe07gQaRQOPfyi4T3I+X55oMWDMJQQW5pSq/knFEg==
X-Received: by 2002:a62:5a45:0:b029:1e5:4c81:c59 with SMTP id o66-20020a625a450000b02901e54c810c59mr30553661pfb.51.1614147096964;
        Tue, 23 Feb 2021 22:11:36 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:69bf])
        by smtp.gmail.com with ESMTPSA id p8sm1180634pff.79.2021.02.23.22.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 22:11:36 -0800 (PST)
Date:   Tue, 23 Feb 2021 22:11:33 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/8] bpf: add PROG_TEST_RUN support for
 sk_lookup programs
Message-ID: <20210224061133.t4aewwgpzlbhchux@ast-mbp.dhcp.thefacebook.com>
References: <20210216105713.45052-1-lmb@cloudflare.com>
 <20210216105713.45052-5-lmb@cloudflare.com>
 <20210223011153.4cvzpvxqn7arbcej@ast-mbp.dhcp.thefacebook.com>
 <CACAyw99hQgG+=WvUVmDU-E6nGsPvosSuSOWgw9uWDDZ-vFfsqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw99hQgG+=WvUVmDU-E6nGsPvosSuSOWgw9uWDDZ-vFfsqw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 10:10:44AM +0000, Lorenz Bauer wrote:
> On Tue, 23 Feb 2021 at 01:11, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > I'm struggling to come up with the case where running N sk_lookup progs
> > like this cannot be done with running them one by one.
> > It looks to me that this N prog_fds api is not really about running and
> > testing the progs, but about testing BPF_PROG_SK_LOOKUP_RUN_ARRAY()
> > SK_PASS vs SK_DROP logic.
> 
> In a way that is true, yes. TBH I figured that my patch set would be
> rejected if I just
> implemented single program test run, since it doesn't allow exercising the full
> sk_lookup test run semantics.
> 
> > So it's more of the kernel infra testing than program testing.
> > Are you suggesting that the sequence of sk_lookup progs are so delicate
> > that they are aware of each other and _has_ to be tested together
> > with gluing logic that the macro provides?
> 
> We currently don't have a case like that.
> 
> > But if it is so then testing the progs one by one would be better,
> > because test_run will be able to check each individual prog return code
> > instead of implicit BPF_PROG_SK_LOOKUP_RUN_ARRAY logic.
> 
> That means emulating the kind of subtle BPF_PROG_SK_LOOKUP_RUN_ARRAY
> in user space, which isn't trivial and a source of bugs.

I'm not at all suggesting to emulate it in user space.

> For example we rely on having multiple programs attached when
> "upgrading" from old to new BPF. Here we care mostly that we don't drop
> lookups on the floor, and the behaviour is tightly coupled to the in-kernel
> implementation. It's not much use to cobble up my own implementation of
> SK_LOOKUP_RUN_ARRAY here, I would rather use multi progs to test this.
> Of course we can also already spawn a netns and test it that way, so not
> much is lost if there is no multi prog test run.

I mean that to test the whole setup close to production the netns is
probably needed because sockets would mess with init_netns.
But to test each individual bpf prog there is no need for RUN_ARRAY.
Each prog can be more accurately tested in isolation.
RUN_ARRAY adds, as you said, subtle details of RUN_ARRAY macro.

> > It feels less of the unit test and more as a full stack test,
> > but if so then lack of cookie on input is questionable.
> 
> I'm not sure what you mean with "the lack of cookie on input is
> questionable", can you rephrase?
> 
> > In other words I'm struggling with in-between state of the api.
> > test_run with N fds is not really a full test, but not a unit test either.
> 
> If I understand you correctly, a "full" API would expose the
> intermediate results from
> individual programs as well as the final selection? Sounds quite
> complicated, and as
> you point out most of the benefits can be had from running single programs.

I'm not suggesting to return intermediate results either.
I'm looking at test_run as a facility to test one individual program
at a time. Like in tc, cgroups, tracing we can have multiple progs
attached to one place and the final verdict will depend on what
each prog is returning. But there is no need to test them all together
through BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY.
Each prog is more accurately validated independently.
Hence I'm puzzled why sk_lookup's RUN_ARRAY is special.
Its drop/pass/selected sk is more or less the same complexity
as CGROUP_INET_EGRESS_RUN_ARRAY.
