Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F4F21A414
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 17:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgGIPyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 11:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGIPyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 11:54:14 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B982C08C5DC
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 08:54:14 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h22so2949782lji.9
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 08:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=B0zq/bKl/B/aK/u4I86GAE0xtYWSX1WXpbosVZx1clM=;
        b=Hu2axFHOfY4EES+SF3YUr9ImO4b16ieLcNWnopMu89j1bHBipG1zKQdROZkWQCHUXh
         wzzHvxL8Eb+FrE1sJhAvGBDITNV0EmNetkaESNTxjNW1YaEgQYBAYUgB7x1Xk4l+UZxY
         KcDjMGsz0qm99Cri4wqu5gEnRKrz/q1uG5TLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=B0zq/bKl/B/aK/u4I86GAE0xtYWSX1WXpbosVZx1clM=;
        b=ClIfqbFXcdQ676Rzhpmmem+MfImF666ZbzsYi3pLrVUfnHuAaWsMCmmo+WBt0RTZfm
         v2qXZ3XRn4lsd9N7IsGxiHnuANaNm2122xz+54nmRlGtoSPJ7bQw9rw1gWlei0grRtnP
         Ao087AFjzVqFz/rP5pccXjWzeO0UsSwOZ6/Vy8oYFxeVyD00iMd5LxkxVv/K9geVsmln
         50euyKAlbn/2EX65Eq1uiskCygatcV2uknvwzeqQHitfZafrTSqYrURTfByrkF0PfqhR
         xFcWZ5nqd9wK5x93zEqmhKGjPzhbgAigvqupY2aiHROkLoJhlhHfO8RNPktO9xMPxGdi
         TQiA==
X-Gm-Message-State: AOAM530exciH4XLw4OQmYEl3gZiuaQDPRqWwfYN58k65bOd/arHGa/DS
        TgERbq5vBvpLw0mqsXWjhgBnzQ==
X-Google-Smtp-Source: ABdhPJzXdfPmFCeCIiMbd6bkZyMrKrZNHywiVEqTktZ+d898U6XSUOHRf5Uiom/DVs7RMuKW5CuHEg==
X-Received: by 2002:a05:651c:3c2:: with SMTP id f2mr38066237ljp.37.1594310052794;
        Thu, 09 Jul 2020 08:54:12 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id f21sm920120ljj.121.2020.07.09.08.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 08:54:12 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-17-jakub@cloudflare.com> <CACAyw98-DaSJ6ZkDv=7Cr62SK1yjvrJVTnz4CrAcvgT-2qqkug@mail.gmail.com> <87lfk2nkdi.fsf@cloudflare.com> <CAEf4BzawjM=CnCBSbY2boGAD4qn+vMHwaKxT-SB-CzY1Zv507g@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v3 16/16] selftests/bpf: Tests for BPF_SK_LOOKUP attach point
In-reply-to: <CAEf4BzawjM=CnCBSbY2boGAD4qn+vMHwaKxT-SB-CzY1Zv507g@mail.gmail.com>
Date:   Thu, 09 Jul 2020 17:54:11 +0200
Message-ID: <87fta0adlo.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 06:28 AM CEST, Andrii Nakryiko wrote:
> On Thu, Jul 2, 2020 at 6:00 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Thu, Jul 02, 2020 at 01:01 PM CEST, Lorenz Bauer wrote:
>> > On Thu, 2 Jul 2020 at 10:24, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> >>
>> >> Add tests to test_progs that exercise:
>> >>
>> >>  - attaching/detaching/querying programs to BPF_SK_LOOKUP hook,
>> >>  - redirecting socket lookup to a socket selected by BPF program,
>> >>  - failing a socket lookup on BPF program's request,
>> >>  - error scenarios for selecting a socket from BPF program,
>> >>  - accessing BPF program context,
>> >>  - attaching and running multiple BPF programs.
>> >>
>> >> Run log:
>> >> | # ./test_progs -n 68
>> >> | #68/1 query lookup prog:OK
>> >> | #68/2 TCP IPv4 redir port:OK
>> >> | #68/3 TCP IPv4 redir addr:OK
>> >> | #68/4 TCP IPv4 redir with reuseport:OK
>> >> | #68/5 TCP IPv4 redir skip reuseport:OK
>> >> | #68/6 TCP IPv6 redir port:OK
>> >> | #68/7 TCP IPv6 redir addr:OK
>> >> | #68/8 TCP IPv4->IPv6 redir port:OK
>> >> | #68/9 TCP IPv6 redir with reuseport:OK
>> >> | #68/10 TCP IPv6 redir skip reuseport:OK
>> >> | #68/11 UDP IPv4 redir port:OK
>> >> | #68/12 UDP IPv4 redir addr:OK
>> >> | #68/13 UDP IPv4 redir with reuseport:OK
>> >> | #68/14 UDP IPv4 redir skip reuseport:OK
>> >> | #68/15 UDP IPv6 redir port:OK
>> >> | #68/16 UDP IPv6 redir addr:OK
>> >> | #68/17 UDP IPv4->IPv6 redir port:OK
>> >> | #68/18 UDP IPv6 redir and reuseport:OK
>> >> | #68/19 UDP IPv6 redir skip reuseport:OK
>> >> | #68/20 TCP IPv4 drop on lookup:OK
>> >> | #68/21 TCP IPv6 drop on lookup:OK
>> >> | #68/22 UDP IPv4 drop on lookup:OK
>> >> | #68/23 UDP IPv6 drop on lookup:OK
>> >> | #68/24 TCP IPv4 drop on reuseport:OK
>> >> | #68/25 TCP IPv6 drop on reuseport:OK
>> >> | #68/26 UDP IPv4 drop on reuseport:OK
>> >> | #68/27 TCP IPv6 drop on reuseport:OK
>> >> | #68/28 sk_assign returns EEXIST:OK
>> >> | #68/29 sk_assign honors F_REPLACE:OK
>> >> | #68/30 access ctx->sk:OK
>> >> | #68/31 sk_assign rejects TCP established:OK
>> >> | #68/32 sk_assign rejects UDP connected:OK
>> >> | #68/33 multi prog - pass, pass:OK
>> >> | #68/34 multi prog - pass, inval:OK
>> >> | #68/35 multi prog - inval, pass:OK
>> >> | #68/36 multi prog - drop, drop:OK
>> >> | #68/37 multi prog - pass, drop:OK
>> >> | #68/38 multi prog - drop, pass:OK
>> >> | #68/39 multi prog - drop, inval:OK
>> >> | #68/40 multi prog - inval, drop:OK
>> >> | #68/41 multi prog - pass, redir:OK
>> >> | #68/42 multi prog - redir, pass:OK
>> >> | #68/43 multi prog - drop, redir:OK
>> >> | #68/44 multi prog - redir, drop:OK
>> >> | #68/45 multi prog - inval, redir:OK
>> >> | #68/46 multi prog - redir, inval:OK
>> >> | #68/47 multi prog - redir, redir:OK
>> >> | #68 sk_lookup:OK
>> >> | Summary: 1/47 PASSED, 0 SKIPPED, 0 FAILED
>> >>
>> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> >> ---
>> >>
>> >> Notes:
>> >>     v3:
>> >>     - Extend tests to cover new functionality in v3:
>> >>       - multi-prog attachments (query, running, verdict precedence)
>> >>       - socket selecting for the second time with bpf_sk_assign
>> >>       - skipping over reuseport load-balancing
>> >>
>> >>     v2:
>> >>      - Adjust for fields renames in struct bpf_sk_lookup.
>> >>
>> >>  .../selftests/bpf/prog_tests/sk_lookup.c      | 1353 +++++++++++++++++
>> >>  .../selftests/bpf/progs/test_sk_lookup_kern.c |  399 +++++
>> >>  2 files changed, 1752 insertions(+)
>> >>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
>> >>  create mode 100644 tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
>> >>
>> >> diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
>> >> new file mode 100644
>> >> index 000000000000..2859dc7e65b0
>> >> --- /dev/null
>> >> +++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
>>
>> [...]
>>
>
> [...]
>
>> >> +static void run_lookup_prog(const struct test *t)
>> >> +{
>> >> +       int client_fd, server_fds[MAX_SERVERS] = { -1 };
>> >> +       struct bpf_link *lookup_link;
>> >> +       int i, err;
>> >> +
>> >> +       lookup_link = attach_lookup_prog(t->lookup_prog);
>> >> +       if (!lookup_link)
>> >
>> > Why doesn't this fail the test? Same for the other error paths in the
>> > function, and the other helpers.
>>
>> I took the approach of placing CHECK_FAIL checks only right after the
>> failure point. So a syscall or a call to libbpf.
>>
>> This way if I'm calling a helper, I know it already fails the test if
>> anything goes wrong, and I can have less CHECK_FAILs peppered over the
>> code.
>
> Please prefere CHECK() over CHECK_FAIL(), unless you are making
> hundreds of checks and it's extremely unlikely they will ever fail.
> Using CHECK_FAIL makes even knowing where the test fails hard. CHECK()
> leaves a trail, so it's easier to pinpoint what and why failed.

I'll convert it in v4. I wrote most of these tests before we chatted
about CHECK vs CHECK_FAIL some time ago and just haven't gotten around
to it so far.

>
>
> [...]

