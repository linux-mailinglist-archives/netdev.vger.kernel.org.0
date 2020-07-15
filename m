Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0851221882
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 01:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGOXla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 19:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgGOXla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 19:41:30 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFB7C061755;
        Wed, 15 Jul 2020 16:41:29 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id k27so3891513pgm.2;
        Wed, 15 Jul 2020 16:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=f83y13vnbncbn4bwggM6ZpiVTNiEH8paTQB0tVuqG24=;
        b=Bq1MgkoM2AIWtV0BvVz6hWTWOZlRvtQ1ECih+co+RT5+++eVAs1CQ2glxr2+7liFJv
         slLUx5nT6GW+bbxRfZ1lqC32/nSsjeohcazz4Cjq7kIxWJysyss4QzPFzgjZCLVUl65Z
         GEhTDACHkaPqKdGwr9clWGeA7CSSxU2oUu9+/n1U9cEUnyBcElYWXnpoSS7PHQc9BVAj
         5BPBOuwS7jmQUr5hMniOykgQ37xlvHDnJb9mNjxK7C1Z8fHpnmXEOjYjOWWuTm/W4ZWQ
         JaSefH1Y40CeJvkHsjsENwCeNrnn1ndfHbpJr0T1ZOdRg2Ja0jCtTsiuIIz2RyJxyWOb
         6x5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=f83y13vnbncbn4bwggM6ZpiVTNiEH8paTQB0tVuqG24=;
        b=LJ+JcArMBop1QWOdr4TtR3BwU/jfVK7m3InbuD9ntxoU1ZuLmw6dtLhxeLSR1Dwvp+
         TFkNfs8aBlfG97YtV3mKKbTuolEx4fecYfQerxRYn9EJglKhfKLKnbM2rjTteZlra+Cd
         K3IgvqpsQAUQnNidJyL5W5u+9vGsqNWhzBcavf9BTc9Pqj1C8JFQ8r6ZcZH32h/pTxjf
         ER+Jy01aIHRBxjuxfFu8XAT4Ftfdo4FPkQYIR37hN+WqeFGAXyYACWqxsIy5d5F8q/Nl
         TH9PZy+zHC3cPCrDE5Jv54HsUjN9gcpBSK2+ldLNwl+seCqlJMHN8+RKoAwaxnihTth3
         H99w==
X-Gm-Message-State: AOAM5336baklrU9Ql1CSmSRvzBYAU/Q0q+f9LJRlhHkJfH6US5UWu4UT
        uWWDwSWgnGVgfQx6h5aB//Y=
X-Google-Smtp-Source: ABdhPJwBy5sczSDoS1nv7raxGOXqFi/XXrBi99ZfiJ/WtLAULMs5q1lfvVLW60z0ilxF6eK59zEWRA==
X-Received: by 2002:a05:6a00:2257:: with SMTP id i23mr1334489pfu.25.1594856488276;
        Wed, 15 Jul 2020 16:41:28 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:96f0])
        by smtp.gmail.com with ESMTPSA id e5sm3042099pjy.26.2020.07.15.16.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 16:41:27 -0700 (PDT)
Date:   Wed, 15 Jul 2020 16:41:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add
 new members to bpf_attr.raw_tracepoint in bpf.h
Message-ID: <20200715234123.rr7oj74t5hflzmsn@ast-mbp.dhcp.thefacebook.com>
References: <159467113970.370286.17656404860101110795.stgit@toke.dk>
 <159467114405.370286.1690821122507970067.stgit@toke.dk>
 <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com>
 <87r1tegusj.fsf@toke.dk>
 <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
 <87pn8xg6x7.fsf@toke.dk>
 <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
 <87d04xg2p4.fsf@toke.dk>
 <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
 <874kq9ey2j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874kq9ey2j.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 02:56:36PM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Wed, Jul 15, 2020 at 12:19:03AM +0200, Toke HÃƒÂ¸iland-JÃƒÂ¸rgensen wrote:
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> 
> >> >> However, assuming it *is* possible, my larger point was that we
> >> >> shouldn't add just a 'logging struct', but rather a 'common options
> >> >> struct' which can be extended further as needed. And if it is *not*
> >> >> possible to add new arguments to a syscall like you're proposing, my
> >> >> suggestion above would be a different way to achieve basically the same
> >> >> (at the cost of having to specify the maximum reserved space in advance).
> >> >>
> >> >
> >> > yeah-yeah, I agree, it's less a "logging attr", more of "common attr
> >> > across all commands".
> >> 
> >> Right, great. I think we are broadly in agreement with where we want to
> >> go with this, actually :)
> >
> > I really don't like 'common attr across all commands'.
> > Both of you are talking as libbpf developers who occasionally need to
> > add printk-s to the kernel. That is not an excuse to bloat api that will be
> > useful to two people.
> 
> What? No, this is about making error messages comprehensible to people
> who *can't* just go around adding printks. "Guess the source of the
> EINVAL" is a really bad user experience!
> 
> > The only reason log_buf sort-of make sense in raw_tp_open is because
> > btf comparison is moved from prog_load into raw_tp_open.
> > Miscompare of (prog_fd1, btf_id1) vs (prog_fd2, btf_id2) can be easily solved
> > by libbpf with as nice and as human friendly message libbpf can do.
> 
> So userspace is supposed to replicate all the checks done by the kernel
> because we can't be bothered to add proper error messages? Really?

That's not what I said. The kernel can report unique errno for miscompare
and all nice messages can and _should be_ be printed by libbpf.


On Wed, Jul 15, 2020, Andrii Nakryiko wrote:
>
> Inability to figure out what's wrong when using BPF is at the top of
> complaints from many users, together with hard to understand logs from
> verifier.

Only the second part is true. All users are complaining about the verifier.
No one is complaing that failed prog attach is somehow lacking string message.
The users are also complaing about libbpf being too verbose.
Yet you've refused to address the verbosity where it should be reduced and
now refusing to add it where it's needed.
It's libbpf job to explain users kernel errors.

The same thing is happening with perf_event_open syscall.
Every one who's trying to code it directly complaining about the kernel. But
not a single user is complaing about perf syscall when they use libraries and
tools. Same thing with bpf syscall. libbpf is the interface. It needs to clear
and to the point. Right now it's not doing it well. elf dump is too verbose and
unnecessary whereas in other places it says nothing informative where it
could have printed human hint.

libbpf's pr_perm_msg() hint is the only one where libbpf cares about its users.
All other messages are useful to libbpf developers and not its users.

The kernel verifier messages suck as well. They need to be improved.
But this thread 'lets add strings everywhere and users will be happy' is
completely missing the mark.
