Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B762A3816
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgKCA4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgKCA4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 19:56:50 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5838EC0617A6;
        Mon,  2 Nov 2020 16:56:49 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id u21so6233827iol.12;
        Mon, 02 Nov 2020 16:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KTjcyyNQ1ZVM4tx3K0LcevL4qKFD7CdWvMEsz26zxLs=;
        b=urGyGZDwAcGB98IU2puOY7mrK0waBCxqRry3XEmrzXDj9Q6hRlRUJfO2b2F05g5TJc
         DvrKY/6TnrP3BDNDRR5scEtD34wwZL+/DbaatsHwvuFVLD2zNP8eV41Zhk/SZsSGZiG0
         KNP93y5qaZiMt9uGI9VLgePSHW5BV1MRoO3X+3HxjlJk5RVVCH3lbIy5vXvVHqWfXtoo
         yxkda/TXbJtQOgpH45Ks67EICbILMbOhNaU8dEszugIyoXrVA71YUuwuYSipurs8C6Im
         /o2zz6/ZZl0iaI8Q3nA0be7lcEcyvovkbz6aGOnCCPieB46M2wvZuC+xr/ZM9wFgkFpD
         JD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KTjcyyNQ1ZVM4tx3K0LcevL4qKFD7CdWvMEsz26zxLs=;
        b=kbA7iIrQjSVW9g+QP+/WxK+6yWnze/L8yFw22rrvnkQD6XEoFammrgGx9wBC/rsDQh
         qZk8G5NEBHZ93l9Xmw3+pJK18g/LOU0kLLbfnKSrJglyQ1To2m6cD1QlyheYIIR3VkyB
         njX9deaV4QT+vd93ybGP1YX12Llwph2zRtyXiO+fujwL0kuptBMMcH6sglct8nYhljiv
         IgsJpVNu9C+Ox7+mviDYOsYe004LBcKFaZqQW5PLbDhZlB63VH5iZY0sazXP5JGOhryB
         EVjMEd8+annQkRnnQrhC5CbNjiPnVv4RAN57pz4kpGd+AzoiB1zKX5NSL/ss9V7V0MI3
         aHjQ==
X-Gm-Message-State: AOAM530FjyzlkDKl3TWOI7PNhHaT25h9PdFgusDb9fG+9VsUVZ5fs23c
        pGzJFhRJ64nKn6a3n0il+YUhYNPmLkEMUcHbYLs=
X-Google-Smtp-Source: ABdhPJzISjrCNFZs7hql1HdBG9QLCXjp1yr4/ON4ZxMRhtu2sUPcljI3BShxZor622COiPGRvJtrMQ7A85GNIsrTL2I=
X-Received: by 2002:a6b:e40f:: with SMTP id u15mr11904173iog.88.1604365008586;
 Mon, 02 Nov 2020 16:56:48 -0800 (PST)
MIME-Version: 1.0
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417034457.2823.10600750891200038944.stgit@localhost.localdomain> <20201103004205.qbyabntlc4yl5vwn@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201103004205.qbyabntlc4yl5vwn@kafai-mbp.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 2 Nov 2020 16:56:37 -0800
Message-ID: <CAKgT0Uec9rUxych344UKFF5J1p4aMp3GWfudZ3-mxRq+fqEyNQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH v2 3/5] selftests/bpf: Replace EXPECT_EQ with
 ASSERT_EQ and refactor verify_results
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 4:42 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Sat, Oct 31, 2020 at 11:52:24AM -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > There is already logic in test_progs.h for asserting that a value is
> > expected to be another value. So instead of reinventing it we should just
> > make use of ASSERT_EQ in tcpbpf_user.c. This will allow for better
> > debugging and integrates much more closely with the test_progs framework.
> >
> > In addition we can refactor the code a bit to merge together the two
> > verify functions and tie them together into a single function. Doing this
> > helps to clean the code up a bit and makes it more readable as all the
> > verification is now done in one function.
> >
> > Lastly we can relocate the verification to the end of the run_test since it
> > is logically part of the test itself. With this we can drop the need for a
> > return value from run_test since verification becomes the last step of the
> > call and then immediately following is the tear down of the test setup.
> >
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Thanks for the review.

> > ---
> >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  114 ++++++++------------
> >  1 file changed, 44 insertions(+), 70 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > index 17d4299435df..d96f4084d2f5 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > @@ -10,66 +10,58 @@
> >
> >  static __u32 duration;
> >
> > -#define EXPECT_EQ(expected, actual, fmt)                     \
> > -     do {                                                    \
> > -             if ((expected) != (actual)) {                   \
> > -                     fprintf(stderr, "  Value of: " #actual "\n"     \
> > -                            "    Actual: %" fmt "\n"         \
> > -                            "  Expected: %" fmt "\n",        \
> > -                            (actual), (expected));           \
> > -                     ret--;                                  \
> > -             }                                               \
> > -     } while (0)
> > -
> > -int verify_result(const struct tcpbpf_globals *result)
> > -{
> > -     __u32 expected_events;
> > -     int ret = 0;
> > -
> > -     expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
> > -                        (1 << BPF_SOCK_OPS_RWND_INIT) |
> > -                        (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
> > -                        (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
> > -                        (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
> > -                        (1 << BPF_SOCK_OPS_NEEDS_ECN) |
> > -                        (1 << BPF_SOCK_OPS_STATE_CB) |
> > -                        (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
> > -
> > -     EXPECT_EQ(expected_events, result->event_map, "#" PRIx32);
> > -     EXPECT_EQ(501ULL, result->bytes_received, "llu");
> > -     EXPECT_EQ(1002ULL, result->bytes_acked, "llu");
> > -     EXPECT_EQ(1, result->data_segs_in, PRIu32);
> > -     EXPECT_EQ(1, result->data_segs_out, PRIu32);
> > -     EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
> > -     EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
> > -     EXPECT_EQ(1, result->num_listen, PRIu32);
> > -
> > -     /* 3 comes from one listening socket + both ends of the connection */
> > -     EXPECT_EQ(3, result->num_close_events, PRIu32);
> > -
> > -     return ret;
> > -}
> > -
> > -int verify_sockopt_result(int sock_map_fd)
> > +static void verify_result(int map_fd, int sock_map_fd)
> >  {
> > +     __u32 expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
> > +                              (1 << BPF_SOCK_OPS_RWND_INIT) |
> > +                              (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
> > +                              (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
> > +                              (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
> > +                              (1 << BPF_SOCK_OPS_NEEDS_ECN) |
> > +                              (1 << BPF_SOCK_OPS_STATE_CB) |
> > +                              (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
> > +     struct tcpbpf_globals result = { 0 };
> nit. init is not needed.

I had copied/pasted it from the original code that was defining this.
If a v3 is needed I can drop the initialization.

> >       __u32 key = 0;
> > -     int ret = 0;
> >       int res;
> >       int rv;
> >
> > +     rv = bpf_map_lookup_elem(map_fd, &key, &result);
> > +     if (CHECK(rv, "bpf_map_lookup_elem(map_fd)", "err:%d errno:%d",
> > +               rv, errno))
> > +             return;
> > +
> > +     /* check global map */
> > +     CHECK(expected_events != result.event_map, "event_map",
> > +           "unexpected event_map: actual %#" PRIx32" != expected %#" PRIx32 "\n",
> > +           result.event_map, expected_events);
> > +
> > +     ASSERT_EQ(result.bytes_received, 501, "bytes_received");
> > +     ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
> > +     ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
> > +     ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
> > +     ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
> > +     ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
> > +     ASSERT_EQ(result.num_listen, 1, "num_listen");
> > +
> > +     /* 3 comes from one listening socket + both ends of the connection */
> > +     ASSERT_EQ(result.num_close_events, 3, "num_close_events");
> > +
> >       /* check setsockopt for SAVE_SYN */
> > +     key = 0;
> nit. not needed.

I assume you mean it is redundant since it was initialized to 0 when
we declared key in the first place?

> >       rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
> > -     EXPECT_EQ(0, rv, "d");
> > -     EXPECT_EQ(0, res, "d");
> > -     key = 1;
> > +     CHECK(rv, "bpf_map_lookup_elem(sock_map_fd)", "err:%d errno:%d",
> > +           rv, errno);
> > +     ASSERT_EQ(res, 0, "bpf_setsockopt(TCP_SAVE_SYN)");
> > +
> >       /* check getsockopt for SAVED_SYN */
> > +     key = 1;
> >       rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
> > -     EXPECT_EQ(0, rv, "d");
> > -     EXPECT_EQ(1, res, "d");
> > -     return ret;
> > +     CHECK(rv, "bpf_map_lookup_elem(sock_map_fd)", "err:%d errno:%d",
> > +           rv, errno);
> > +     ASSERT_EQ(res, 1, "bpf_getsockopt(TCP_SAVED_SYN)");
> >  }
