Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161352A3801
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgKCAty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgKCAtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 19:49:53 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D487EC0617A6;
        Mon,  2 Nov 2020 16:49:53 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id e16so313145ile.0;
        Mon, 02 Nov 2020 16:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xSgy9CbABoBiAAZ6hK7XGk342xFyQ/b7kK7jPggl0s=;
        b=CLTZup1ae4AbsC/8KNpkLOy9R6Tw7IUUf1L+747Bi2VXG2KwXWlT2EiTKKwBcMRNB1
         o5Rr1MXks/QG7HLaDNpE00UgJ5oNxa/FPmG78T/cguFLvMpYRzIRvDD5U2aoG2SVvdCL
         DGJM3jfA0rIfomXv1bFXdxSsWHuBV1G94PGe43VFOyodI2fqBiqjvl1fHj5EBYnlh/tu
         /mjxculvnHZwQB2AqU+qd5KcxelgEjyKYlTSBBIXeCPEwHuZZ8OtXYlXnSyRzo5KcPbo
         OEf/nIr1K8schTbWuPLBJOYpj+M18tLFz6eERg0pOkqp08xTCTyEjWoR4NhWNXeTRZ0J
         PSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xSgy9CbABoBiAAZ6hK7XGk342xFyQ/b7kK7jPggl0s=;
        b=WJLaC0KIFV9rvQAWskPWMQzDrLBGYVlV1SPmi+ziq58OU7OaLlCM3n+oNEtczAU6DA
         lYHGIRo1SkW21LjxHnbib7ws/N4KxlkrFEulwNb6/VXgcfTfMb0GpEkfSQaY66TpaicW
         2fMfOnATLLWei0x/ohb34x81BSyYX1bCR+4ot83AJl4/5o2NUOgvnboTi64UX2WliFUZ
         VS7WAi8f4t8tgrOznrUAkNIbaQO5G9Xn3BbjQX/rHgjIkkaoZFzlyXLBQYVJqmb3Lu7B
         +gikzqI+B4FWxwuSdJNX3pzsu1dKsnUzdY+nCISoWonsDzc8AxOGi6qRaXgJKYajYPp8
         0+VQ==
X-Gm-Message-State: AOAM530zQEiY98pKU6pIhCt2pSQjviTYBfg2LAlQvxzKjImoiSNNVVoE
        +Ycy5kZ4AwL2mWM82eIudeG/jfYXBiQ38KgmEpNCmRaeBbw=
X-Google-Smtp-Source: ABdhPJxMjceDovOLxrMF8xcP2/2Xj6ZpWDx2co8VbJ/MrCr+keQiMH63EYQUFmIZxGKupyKOBVrqMIZEFDjT8Zy5OBQ=
X-Received: by 2002:a92:ad0f:: with SMTP id w15mr11588503ilh.97.1604364593147;
 Mon, 02 Nov 2020 16:49:53 -0800 (PST)
MIME-Version: 1.0
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417033818.2823.4460428938483935516.stgit@localhost.localdomain> <20201103003836.2ngjz6yqewhn7aln@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201103003836.2ngjz6yqewhn7aln@kafai-mbp.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 2 Nov 2020 16:49:42 -0800
Message-ID: <CAKgT0UceQhVGXbkZWj_aj0+Ew8oOEJMAgwAUE5GLN5EexqAhkQ@mail.gmail.com>
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

On Mon, Nov 2, 2020 at 4:38 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Sat, Oct 31, 2020 at 11:52:18AM -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > Drop the tcp_client/server.py files in favor of using a client and server
> > thread within the test case. Specifically we spawn a new thread to play the
> The thread comment may be outdated in v2.
>
> > role of the server, and the main testing thread plays the role of client.
> >
> > Add logic to the end of the run_test function to guarantee that the sockets
> > are closed when we begin verifying results.
> >
> > Doing this we are able to reduce overhead since we don't have two python
> > workers possibly floating around. In addition we don't have to worry about
> > synchronization issues and as such the retry loop waiting for the threads
> > to close the sockets can be dropped as we will have already closed the
> > sockets in the local executable and synchronized the server thread.
> >
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > ---
> >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   96 ++++++++++++++++----
> >  tools/testing/selftests/bpf/tcp_client.py          |   50 ----------
> >  tools/testing/selftests/bpf/tcp_server.py          |   80 -----------------
> >  3 files changed, 78 insertions(+), 148 deletions(-)
> >  delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
> >  delete mode 100755 tools/testing/selftests/bpf/tcp_server.py
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > index 54f1dce97729..17d4299435df 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > @@ -1,13 +1,14 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  #include <inttypes.h>
> >  #include <test_progs.h>
> > +#include <network_helpers.h>
> >
> >  #include "test_tcpbpf.h"
> >
> > +#define LO_ADDR6 "::1"
> >  #define CG_NAME "/tcpbpf-user-test"
> >
> > -/* 3 comes from one listening socket + both ends of the connection */
> > -#define EXPECTED_CLOSE_EVENTS                3
> > +static __u32 duration;
> >
> >  #define EXPECT_EQ(expected, actual, fmt)                     \
> >       do {                                                    \
> > @@ -42,7 +43,9 @@ int verify_result(const struct tcpbpf_globals *result)
> >       EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
> >       EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
> >       EXPECT_EQ(1, result->num_listen, PRIu32);
> > -     EXPECT_EQ(EXPECTED_CLOSE_EVENTS, result->num_close_events, PRIu32);
> > +
> > +     /* 3 comes from one listening socket + both ends of the connection */
> > +     EXPECT_EQ(3, result->num_close_events, PRIu32);
> >
> >       return ret;
> >  }
> > @@ -66,6 +69,75 @@ int verify_sockopt_result(int sock_map_fd)
> >       return ret;
> >  }
> >
> > +static int run_test(void)
> > +{
> > +     int listen_fd = -1, cli_fd = -1, accept_fd = -1;
> > +     char buf[1000];
> > +     int err = -1;
> > +     int i;
> > +
> > +     listen_fd = start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
> > +     if (CHECK(listen_fd == -1, "start_server", "listen_fd:%d errno:%d\n",
> > +               listen_fd, errno))
> > +             goto done;
> > +
> > +     cli_fd = connect_to_fd(listen_fd, 0);
> > +     if (CHECK(cli_fd == -1, "connect_to_fd(listen_fd)",
> > +               "cli_fd:%d errno:%d\n", cli_fd, errno))
> > +             goto done;
> > +
> > +     accept_fd = accept(listen_fd, NULL, NULL);
> > +     if (CHECK(accept_fd == -1, "accept(listen_fd)",
> > +               "accept_fd:%d errno:%d\n", accept_fd, errno))
> > +             goto done;
> > +
> > +     /* Send 1000B of '+'s from cli_fd -> accept_fd */
> > +     for (i = 0; i < 1000; i++)
> > +             buf[i] = '+';
> > +
> > +     err = send(cli_fd, buf, 1000, 0);
> > +     if (CHECK(err != 1000, "send(cli_fd)", "err:%d errno:%d\n", err, errno))
> > +             goto done;
> > +
> > +     err = recv(accept_fd, buf, 1000, 0);
> > +     if (CHECK(err != 1000, "recv(accept_fd)", "err:%d errno:%d\n", err, errno))
> > +             goto done;
> > +
> > +     /* Send 500B of '.'s from accept_fd ->cli_fd */
> > +     for (i = 0; i < 500; i++)
> > +             buf[i] = '.';
> > +
> > +     err = send(accept_fd, buf, 500, 0);
> > +     if (CHECK(err != 500, "send(accept_fd)", "err:%d errno:%d\n", err, errno))
> > +             goto done;
> > +
> > +     err = recv(cli_fd, buf, 500, 0);
> Unlikely, but err from the above send()/recv() could be 0.

Is that an issue? It would still trigger the check below as that is not 500.

> > +     if (CHECK(err != 500, "recv(cli_fd)", "err:%d errno:%d\n", err, errno))
> > +             goto done;
> > +
> > +     /*
> > +      * shutdown accept first to guarantee correct ordering for
> > +      * bytes_received and bytes_acked when we go to verify the results.
> > +      */
> > +     shutdown(accept_fd, SHUT_WR);
> > +     err = recv(cli_fd, buf, 1, 0);
> > +     if (CHECK(err, "recv(cli_fd) for fin", "err:%d errno:%d\n", err, errno))
> > +             goto done;
> > +
> > +     shutdown(cli_fd, SHUT_WR);
> > +     err = recv(accept_fd, buf, 1, 0);
> hmm... I was thinking cli_fd may still be in TCP_LAST_ACK
> but we can go with this version first and see if CI could
> really hit this case before resurrecting the idea on testing
> the TCP_LAST_ACK instead of TCP_CLOSE in test_tcpbpf_kern.c.

I ran with this for several hours and saw no issues with over 100K
iterations all of them passing. That is why I opted to just drop the
TCP_LAST_ACK patch.
