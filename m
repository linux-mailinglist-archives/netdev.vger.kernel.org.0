Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93EA219760
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 06:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgGIE3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 00:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgGIE3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 00:29:05 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B2EC061A0B;
        Wed,  8 Jul 2020 21:29:05 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id di5so394216qvb.11;
        Wed, 08 Jul 2020 21:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sOjoYmzZvYKUf8AanyNz0tUJlETbNj/h4lwDEzvkiGA=;
        b=LWnlW9nVcM9gYN5hR+qyQuaNNx6KvD2dg7gS+NqU61lh8NjCPv0ftjq7GfYDOLM0Pl
         xXepHL6xz9p5O2/7jB8sgIWcjEqFdk68X0/GvxEMmJLI4V3s/xSad2+/zgzno8Lw748c
         elGdm2nclyrjiSopdHw2ZXo2z+htNhAIzs9JW/q2+81IKQCrv0XAOA/C9Z1SLnBhq3CW
         NMOmKMju6nhWQIejo3dYAi36ODrAISMLpdj7ucqQZ4xCcMCQn4DCcglNmRpzO5YgG0Zw
         7wxDCTSruLnCrdPjA09f43qQt0IjkrXkEpsVc1t6GCIp1NpZlQJdHAbSoHHFExh/I++V
         tHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sOjoYmzZvYKUf8AanyNz0tUJlETbNj/h4lwDEzvkiGA=;
        b=GrsNEPL9BrIVcL5oBUBxqKSqmdXeXlA1sll/dECmyyBuXwV3BUesRrZ2wyUZfzmXO7
         k6w+id5JCWxvmat9DXyM2Vsw7mlhPb971ps/v3gRNfRSrDSGiMNRIR4MEn5y3WMfWD1N
         bE19q1DWuhMhJttL/PuWy/uxOJIuI6PUSk8AAYL5e3ym24XeqNgGZLSn4/rhaL1egn0f
         /3VMknhntglJ1pKtbLyIMpqtDedsdR2F7Pyhyf5I+Qm2WP+NrsYKzh7JDD9GoOLUfqhq
         mhnyPYHN2k7/t6od4tgPteu7pUNUuP4etjSH72cTghN05RtON1oPgnxLWTjX8R6PvHf/
         jzLg==
X-Gm-Message-State: AOAM530izppUvQSoY3ScHHiYSPN2DPyh7NmXmU88/tQPLEtWeo7II++i
        S1Jg3Uq6e2wRH5/H6IOn/Nk6a8jZpX4NfaM5tzQ=
X-Google-Smtp-Source: ABdhPJxOooBl8uAErTW+S3riLTUTX0/8CIQkH5s51Fx+vUlmJNMI9890CIk6V487pH6A4wGMVN+fE/UtYVQ5WG+ejhs=
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr59901841qvb.196.1594268944726;
 Wed, 08 Jul 2020 21:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-17-jakub@cloudflare.com>
 <CACAyw98-DaSJ6ZkDv=7Cr62SK1yjvrJVTnz4CrAcvgT-2qqkug@mail.gmail.com> <87lfk2nkdi.fsf@cloudflare.com>
In-Reply-To: <87lfk2nkdi.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Jul 2020 21:28:53 -0700
Message-ID: <CAEf4BzawjM=CnCBSbY2boGAD4qn+vMHwaKxT-SB-CzY1Zv507g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 16/16] selftests/bpf: Tests for BPF_SK_LOOKUP
 attach point
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 6:00 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Jul 02, 2020 at 01:01 PM CEST, Lorenz Bauer wrote:
> > On Thu, 2 Jul 2020 at 10:24, Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> Add tests to test_progs that exercise:
> >>
> >>  - attaching/detaching/querying programs to BPF_SK_LOOKUP hook,
> >>  - redirecting socket lookup to a socket selected by BPF program,
> >>  - failing a socket lookup on BPF program's request,
> >>  - error scenarios for selecting a socket from BPF program,
> >>  - accessing BPF program context,
> >>  - attaching and running multiple BPF programs.
> >>
> >> Run log:
> >> | # ./test_progs -n 68
> >> | #68/1 query lookup prog:OK
> >> | #68/2 TCP IPv4 redir port:OK
> >> | #68/3 TCP IPv4 redir addr:OK
> >> | #68/4 TCP IPv4 redir with reuseport:OK
> >> | #68/5 TCP IPv4 redir skip reuseport:OK
> >> | #68/6 TCP IPv6 redir port:OK
> >> | #68/7 TCP IPv6 redir addr:OK
> >> | #68/8 TCP IPv4->IPv6 redir port:OK
> >> | #68/9 TCP IPv6 redir with reuseport:OK
> >> | #68/10 TCP IPv6 redir skip reuseport:OK
> >> | #68/11 UDP IPv4 redir port:OK
> >> | #68/12 UDP IPv4 redir addr:OK
> >> | #68/13 UDP IPv4 redir with reuseport:OK
> >> | #68/14 UDP IPv4 redir skip reuseport:OK
> >> | #68/15 UDP IPv6 redir port:OK
> >> | #68/16 UDP IPv6 redir addr:OK
> >> | #68/17 UDP IPv4->IPv6 redir port:OK
> >> | #68/18 UDP IPv6 redir and reuseport:OK
> >> | #68/19 UDP IPv6 redir skip reuseport:OK
> >> | #68/20 TCP IPv4 drop on lookup:OK
> >> | #68/21 TCP IPv6 drop on lookup:OK
> >> | #68/22 UDP IPv4 drop on lookup:OK
> >> | #68/23 UDP IPv6 drop on lookup:OK
> >> | #68/24 TCP IPv4 drop on reuseport:OK
> >> | #68/25 TCP IPv6 drop on reuseport:OK
> >> | #68/26 UDP IPv4 drop on reuseport:OK
> >> | #68/27 TCP IPv6 drop on reuseport:OK
> >> | #68/28 sk_assign returns EEXIST:OK
> >> | #68/29 sk_assign honors F_REPLACE:OK
> >> | #68/30 access ctx->sk:OK
> >> | #68/31 sk_assign rejects TCP established:OK
> >> | #68/32 sk_assign rejects UDP connected:OK
> >> | #68/33 multi prog - pass, pass:OK
> >> | #68/34 multi prog - pass, inval:OK
> >> | #68/35 multi prog - inval, pass:OK
> >> | #68/36 multi prog - drop, drop:OK
> >> | #68/37 multi prog - pass, drop:OK
> >> | #68/38 multi prog - drop, pass:OK
> >> | #68/39 multi prog - drop, inval:OK
> >> | #68/40 multi prog - inval, drop:OK
> >> | #68/41 multi prog - pass, redir:OK
> >> | #68/42 multi prog - redir, pass:OK
> >> | #68/43 multi prog - drop, redir:OK
> >> | #68/44 multi prog - redir, drop:OK
> >> | #68/45 multi prog - inval, redir:OK
> >> | #68/46 multi prog - redir, inval:OK
> >> | #68/47 multi prog - redir, redir:OK
> >> | #68 sk_lookup:OK
> >> | Summary: 1/47 PASSED, 0 SKIPPED, 0 FAILED
> >>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >>
> >> Notes:
> >>     v3:
> >>     - Extend tests to cover new functionality in v3:
> >>       - multi-prog attachments (query, running, verdict precedence)
> >>       - socket selecting for the second time with bpf_sk_assign
> >>       - skipping over reuseport load-balancing
> >>
> >>     v2:
> >>      - Adjust for fields renames in struct bpf_sk_lookup.
> >>
> >>  .../selftests/bpf/prog_tests/sk_lookup.c      | 1353 +++++++++++++++++
> >>  .../selftests/bpf/progs/test_sk_lookup_kern.c |  399 +++++
> >>  2 files changed, 1752 insertions(+)
> >>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> >>  create mode 100644 tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> >> new file mode 100644
> >> index 000000000000..2859dc7e65b0
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
>
> [...]
>

[...]

> >> +static void run_lookup_prog(const struct test *t)
> >> +{
> >> +       int client_fd, server_fds[MAX_SERVERS] = { -1 };
> >> +       struct bpf_link *lookup_link;
> >> +       int i, err;
> >> +
> >> +       lookup_link = attach_lookup_prog(t->lookup_prog);
> >> +       if (!lookup_link)
> >
> > Why doesn't this fail the test? Same for the other error paths in the
> > function, and the other helpers.
>
> I took the approach of placing CHECK_FAIL checks only right after the
> failure point. So a syscall or a call to libbpf.
>
> This way if I'm calling a helper, I know it already fails the test if
> anything goes wrong, and I can have less CHECK_FAILs peppered over the
> code.

Please prefere CHECK() over CHECK_FAIL(), unless you are making
hundreds of checks and it's extremely unlikely they will ever fail.
Using CHECK_FAIL makes even knowing where the test fails hard. CHECK()
leaves a trail, so it's easier to pinpoint what and why failed.


[...]
