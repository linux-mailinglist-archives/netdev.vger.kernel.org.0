Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7A32A4A8F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgKCQBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgKCQBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 11:01:20 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE93C0613D1;
        Tue,  3 Nov 2020 08:01:20 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id n12so7283063ioc.2;
        Tue, 03 Nov 2020 08:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4dKUAsXJBZEUrqdUnF/j4ZiY0ub+/LwLLjcRdluZZDw=;
        b=iCMfic03coleRE/4ylmAhjky/BfHegzHAjSgIclnSUKiu5Ufcq6jSDf2qeA2qsTBTb
         JLDKgUTXFZEmf7tRJ9UkCxIy7790IT3NdCXNuMAsCarjvjE0me09ywCSL5zsZ8wox+61
         MzJOBOXleavsmme8+5iCWj65g19Drci6HS9QtDYN7dvKTr0HE4qadbebfwakrSc2umd9
         FvPmJU4iUc02nXTbcUe/sOBf2nqbFmTax+wcMLf9CojsO9KAoN7M5NyE/+HyqIVGBNyY
         PmjjdIR2nS+6g+JgY+R2XQMBsQK9ZNpegfdpJvADL6+vr0W+TFNYUbd/fc7u54TY8Fzu
         g2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4dKUAsXJBZEUrqdUnF/j4ZiY0ub+/LwLLjcRdluZZDw=;
        b=emvrgBWk5HKhb1oaWBQwqF4qpxErIsL8c+9S2LJ1RVzmY5tUiZNB+1inncIikCtOqH
         WKxUSsN5W/5NNKTo9di3w/uUo9u5WSQ7Nuzm6lWtDAjueeh5QrWtTADcZAo8Yrv3VTPu
         8+LDQEHt3FQC1FTAY8fxcFRW+v8gagnV/xGa1gl8Jbk7RGiD0SFtubn7SF0snJzgxgxq
         jpJlpfEr11HVa85IhIwZ3SpawJJ4XQ+JUYpOjS6zCddP4oKBU9aZ3geNAxUlQP5sT/Z4
         XTpAiSOiuH5NlFUB82jZ9+c0lqyXBHAmiinxGM0wDYodG9ZEf+/iCMmGUIbK9UWhlvGF
         xuig==
X-Gm-Message-State: AOAM531u8mTjl68wyG5ZnYYyA/1rwAl3mtYMRWR6zvFj4c9phuIZ+R4E
        RxG0zD1kCNDKKVPlwDNukzHqGAIWPjZKLi/d1fk=
X-Google-Smtp-Source: ABdhPJyzgj5KUCC5YmsU+8RYrG59gF8arynDcLoU8e9GrUPpPUZrsL3yl7aPJhcOuuZiebPr149/3SR4zF7FfXq0J4o=
X-Received: by 2002:a02:1783:: with SMTP id 125mr16575634jah.121.1604419279517;
 Tue, 03 Nov 2020 08:01:19 -0800 (PST)
MIME-Version: 1.0
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417033818.2823.4460428938483935516.stgit@localhost.localdomain>
 <20201103003836.2ngjz6yqewhn7aln@kafai-mbp.dhcp.thefacebook.com>
 <CAKgT0UceQhVGXbkZWj_aj0+Ew8oOEJMAgwAUE5GLN5EexqAhkQ@mail.gmail.com> <20201103013310.wbs7i3jm5vwnrctn@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201103013310.wbs7i3jm5vwnrctn@kafai-mbp.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 3 Nov 2020 08:01:08 -0800
Message-ID: <CAKgT0Ud4xo0WY9CBesVzgJ06Nw9dnEuYYs_h-WEqzFGXhmJpVw@mail.gmail.com>
Subject: Re: [bpf-next PATCH v2 2/5] selftests/bpf: Drop python client/server
 in favor of threads
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

On Mon, Nov 2, 2020 at 5:33 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, Nov 02, 2020 at 04:49:42PM -0800, Alexander Duyck wrote:
> > On Mon, Nov 2, 2020 at 4:38 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Sat, Oct 31, 2020 at 11:52:18AM -0700, Alexander Duyck wrote:
> > > > From: Alexander Duyck <alexanderduyck@fb.com>
> > > >
> > > > Drop the tcp_client/server.py files in favor of using a client and server
> > > > thread within the test case. Specifically we spawn a new thread to play the
> > > The thread comment may be outdated in v2.
> > >
> > > > role of the server, and the main testing thread plays the role of client.
> > > >
> > > > Add logic to the end of the run_test function to guarantee that the sockets
> > > > are closed when we begin verifying results.
> > > >
> > > > Doing this we are able to reduce overhead since we don't have two python
> > > > workers possibly floating around. In addition we don't have to worry about
> > > > synchronization issues and as such the retry loop waiting for the threads
> > > > to close the sockets can be dropped as we will have already closed the
> > > > sockets in the local executable and synchronized the server thread.
> > > >
> > > > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > > > ---
> > > >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   96 ++++++++++++++++----
> > > >  tools/testing/selftests/bpf/tcp_client.py          |   50 ----------
> > > >  tools/testing/selftests/bpf/tcp_server.py          |   80 -----------------
> > > >  3 files changed, 78 insertions(+), 148 deletions(-)
> > > >  delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
> > > >  delete mode 100755 tools/testing/selftests/bpf/tcp_server.py
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > > index 54f1dce97729..17d4299435df 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > > @@ -1,13 +1,14 @@
> > > >  // SPDX-License-Identifier: GPL-2.0
> > > >  #include <inttypes.h>
> > > >  #include <test_progs.h>
> > > > +#include <network_helpers.h>
> > > >
> > > >  #include "test_tcpbpf.h"
> > > >
> > > > +#define LO_ADDR6 "::1"
> > > >  #define CG_NAME "/tcpbpf-user-test"
> > > >
> > > > -/* 3 comes from one listening socket + both ends of the connection */
> > > > -#define EXPECTED_CLOSE_EVENTS                3
> > > > +static __u32 duration;
> > > >
> > > >  #define EXPECT_EQ(expected, actual, fmt)                     \
> > > >       do {                                                    \
> > > > @@ -42,7 +43,9 @@ int verify_result(const struct tcpbpf_globals *result)
> > > >       EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
> > > >       EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
> > > >       EXPECT_EQ(1, result->num_listen, PRIu32);
> > > > -     EXPECT_EQ(EXPECTED_CLOSE_EVENTS, result->num_close_events, PRIu32);
> > > > +
> > > > +     /* 3 comes from one listening socket + both ends of the connection */
> > > > +     EXPECT_EQ(3, result->num_close_events, PRIu32);
> > > >
> > > >       return ret;
> > > >  }
> > > > @@ -66,6 +69,75 @@ int verify_sockopt_result(int sock_map_fd)
> > > >       return ret;
> > > >  }
> > > >
> > > > +static int run_test(void)
> > > > +{
> > > > +     int listen_fd = -1, cli_fd = -1, accept_fd = -1;
> > > > +     char buf[1000];
> > > > +     int err = -1;
> > > > +     int i;
> > > > +
> > > > +     listen_fd = start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
> > > > +     if (CHECK(listen_fd == -1, "start_server", "listen_fd:%d errno:%d\n",
> > > > +               listen_fd, errno))
> > > > +             goto done;
> > > > +
> > > > +     cli_fd = connect_to_fd(listen_fd, 0);
> > > > +     if (CHECK(cli_fd == -1, "connect_to_fd(listen_fd)",
> > > > +               "cli_fd:%d errno:%d\n", cli_fd, errno))
> > > > +             goto done;
> > > > +
> > > > +     accept_fd = accept(listen_fd, NULL, NULL);
> > > > +     if (CHECK(accept_fd == -1, "accept(listen_fd)",
> > > > +               "accept_fd:%d errno:%d\n", accept_fd, errno))
> > > > +             goto done;
> > > > +
> > > > +     /* Send 1000B of '+'s from cli_fd -> accept_fd */
> > > > +     for (i = 0; i < 1000; i++)
> > > > +             buf[i] = '+';
> > > > +
> > > > +     err = send(cli_fd, buf, 1000, 0);
> > > > +     if (CHECK(err != 1000, "send(cli_fd)", "err:%d errno:%d\n", err, errno))
> > > > +             goto done;
> > > > +
> > > > +     err = recv(accept_fd, buf, 1000, 0);
> > > > +     if (CHECK(err != 1000, "recv(accept_fd)", "err:%d errno:%d\n", err, errno))
> > > > +             goto done;
> > > > +
> > > > +     /* Send 500B of '.'s from accept_fd ->cli_fd */
> > > > +     for (i = 0; i < 500; i++)
> > > > +             buf[i] = '.';
> > > > +
> > > > +     err = send(accept_fd, buf, 500, 0);
> > > > +     if (CHECK(err != 500, "send(accept_fd)", "err:%d errno:%d\n", err, errno))
> > > > +             goto done;
> > > > +
> > > > +     err = recv(cli_fd, buf, 500, 0);
> > > Unlikely, but err from the above send()/recv() could be 0.
> >
> > Is that an issue? It would still trigger the check below as that is not 500.
> Mostly for consistency.  "err" will be returned and tested for non-zero
> in test_tcpbpf_user().

Okay that makes sense. Now that I have looked it over more it does
lead to an error in the final product since it will attempt to verify
data on a failed connection so I will probably just replaced err with
a new variable such as rv for the send/recv part of the function so
that err stays at -1 until we are closing the sockets.
