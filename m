Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACA329F25F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgJ2Q61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgJ2Q61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 12:58:27 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CB3C0613CF;
        Thu, 29 Oct 2020 09:58:26 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id g7so3735575ilr.12;
        Thu, 29 Oct 2020 09:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xnsYZSF6HogCYbHLl+fUuPeK2vyc0LkrrayXSJFT0Vk=;
        b=hHceJitFwgt8apZhi26apvaK13rgL102rA8w+s03HxgrGBdWOlBAMf8YBreoBFwwrg
         7zl3bJw4rfrRUe7r/4WoDSlbyKTTNoGlL2B5XucLSSKPpjH0vgh1K0KKN9dajHtfD7nY
         rve8YF1GN7av2zLirWjY0p1VTJVC3c/pkAKLAWSV2KQEgRJroxPxKMtU+UjKoEDU3zyj
         mQIQsreFWko94YsctXBKCAEKcGFMnVJ39Rfkeuz95+AaDBrLoSBIVbv7qM7QuCqWVPsj
         4Ta4icBMYUSdmNjQyWAQZ794zadLwRdIL5AQTXjtfWt1Y7mm5v8uA0RLzQumYeYrd59z
         7OBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xnsYZSF6HogCYbHLl+fUuPeK2vyc0LkrrayXSJFT0Vk=;
        b=PMf1dWbHITVB1jec+7jYHuNDmrKyvEPOOKd+S57p3MjXlo9xYS82vWd5vRNm/zby3m
         ZzqwDIKTr5mU74lj4ZRFJnOgWWTtCeheW00llZHBiOqadRtIwOlpPalaPr5F6EO/LDuq
         euc0TQKT2UdGEgBteDiz0EiOBzYP1JZmYBmj0bWpgYPQVG16HMvZl59spltnoxKkpttA
         Nx2cp2gI2D4bpB7J/SIbu8jBOM+a2wePlUDf7k6F+kfIdXObEeUMx7hDl6jdUJpD/9ym
         Nii/XjaYBwbUGzW/WHmo/5rHfbQ2hbAwPaA2L81EhYUV9RcMOrQRkG0bq5ATMer81hzO
         +2VA==
X-Gm-Message-State: AOAM5306qh0hAvOYdw7cxo37aOARnVReb915knRVjs2JiKCH3ALFdf9k
        Iw1SB4gvNjoeUr0kL8OowBA9OfMZqbZ/PIQIwuU=
X-Google-Smtp-Source: ABdhPJwSg3cMxys945YQIf1ghgPIy2q9zE6R12kksKuHJTGLGIqucuyFuV1aMM9EkJ74brd3/MISU2KZX91I9PmqPJA=
X-Received: by 2002:a92:cb51:: with SMTP id f17mr3803815ilq.64.1603990706132;
 Thu, 29 Oct 2020 09:58:26 -0700 (PDT)
MIME-Version: 1.0
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
 <160384963313.698509.13129692731727238158.stgit@localhost.localdomain> <20201029015115.jotej3wgi3p6yn6u@kafai-mbp>
In-Reply-To: <20201029015115.jotej3wgi3p6yn6u@kafai-mbp>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 29 Oct 2020 09:58:15 -0700
Message-ID: <CAKgT0UcpqQaHOdjcOGybF0pWuZS_ZqYOArQ8kLfvheGFE-ur-w@mail.gmail.com>
Subject: Re: [bpf-next PATCH 2/4] selftests/bpf: Drop python client/server in
 favor of threads
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, brakmo@fb.com,
        alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 6:51 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Oct 27, 2020 at 06:47:13PM -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > Drop the tcp_client/server.py files in favor of using a client and server
> > thread within the test case. Specifically we spawn a new thread to play the
> > role of the server, and the main testing thread plays the role of client.
> >
> > Doing this we are able to reduce overhead since we don't have two python
> > workers possibly floating around. In addition we don't have to worry about
> > synchronization issues and as such the retry loop waiting for the threads
> > to close the sockets can be dropped as we will have already closed the
> > sockets in the local executable and synchronized the server thread.
> Thanks for working on this.
>
> >
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > ---
> >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  125 +++++++++++++++++---
> >  tools/testing/selftests/bpf/tcp_client.py          |   50 --------
> >  tools/testing/selftests/bpf/tcp_server.py          |   80 -------------
> >  3 files changed, 107 insertions(+), 148 deletions(-)
> >  delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
> >  delete mode 100755 tools/testing/selftests/bpf/tcp_server.py
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > index 5becab8b04e3..71ab82e37eb7 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > @@ -1,14 +1,65 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  #include <inttypes.h>
> >  #include <test_progs.h>
> > +#include <network_helpers.h>
> >
> >  #include "test_tcpbpf.h"
> >  #include "cgroup_helpers.h"
> >
> > +#define LO_ADDR6 "::1"
> >  #define CG_NAME "/tcpbpf-user-test"
> >
> > -/* 3 comes from one listening socket + both ends of the connection */
> > -#define EXPECTED_CLOSE_EVENTS                3
> > +static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
> > +static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
> > +
> > +static void *server_thread(void *arg)
> > +{
> > +     struct sockaddr_storage addr;
> > +     socklen_t len = sizeof(addr);
> > +     int fd = *(int *)arg;
> > +     char buf[1000];
> > +     int client_fd;
> > +     int err = 0;
> > +     int i;
> > +
> > +     err = listen(fd, 1);
> This is not needed.  start_server() has done it.

Okay, I will drop it.

> > +
> > +     pthread_mutex_lock(&server_started_mtx);
> > +     pthread_cond_signal(&server_started);
> > +     pthread_mutex_unlock(&server_started_mtx);
> > +
> > +     if (err < 0) {
> > +             perror("Failed to listen on socket");
> > +             err = errno;
> > +             goto err;
> > +     }
> > +
> > +     client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> > +     if (client_fd < 0) {
> > +             perror("Failed to accept client");
> > +             err = errno;
> > +             goto err;
> > +     }
> > +
> > +     if (recv(client_fd, buf, 1000, 0) < 1000) {
> > +             perror("failed/partial recv");
> > +             err = errno;
> > +             goto out_clean;
> > +     }
> > +
> > +     for (i = 0; i < 500; i++)
> > +             buf[i] = '.';
> > +
> > +     if (send(client_fd, buf, 500, 0) < 500) {
> > +             perror("failed/partial send");
> > +             err = errno;
> > +             goto out_clean;
> > +     }
> > +out_clean:
> > +     close(client_fd);
> > +err:
> > +     return (void *)(long)err;
> > +}
> >
> >  #define EXPECT_EQ(expected, actual, fmt)                     \
> >       do {                                                    \
> > @@ -43,7 +94,9 @@ int verify_result(const struct tcpbpf_globals *result)
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
> > @@ -67,6 +120,52 @@ int verify_sockopt_result(int sock_map_fd)
> >       return ret;
> >  }
> >
> > +static int run_test(void)
> > +{
> > +     int server_fd, client_fd;
> > +     void *server_err;
> > +     char buf[1000];
> > +     pthread_t tid;
> > +     int err = -1;
> > +     int i;
> > +
> > +     server_fd = start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
> > +     if (CHECK_FAIL(server_fd < 0))
> > +             return err;
> > +
> > +     pthread_mutex_lock(&server_started_mtx);
> > +     if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
> > +                                   (void *)&server_fd)))
> > +             goto close_server_fd;
> > +
> > +     pthread_cond_wait(&server_started, &server_started_mtx);
> > +     pthread_mutex_unlock(&server_started_mtx);
> > +
> > +     client_fd = connect_to_fd(server_fd, 0);
> > +     if (client_fd < 0)
> > +             goto close_server_fd;
> > +
> > +     for (i = 0; i < 1000; i++)
> > +             buf[i] = '+';
> > +
> > +     if (CHECK_FAIL(send(client_fd, buf, 1000, 0) < 1000))
> > +             goto close_client_fd;
> > +
> > +     if (CHECK_FAIL(recv(client_fd, buf, 500, 0) < 500))
> > +             goto close_client_fd;
> > +
> > +     pthread_join(tid, &server_err);
> I think this can be further simplified without starting thread
> and do everything in run_test() instead.
>
> Something like this (uncompiled code):
>
>         accept_fd = accept(server_fd, NULL, 0);
>         send(client_fd, plus_buf, 1000, 0);
>         recv(accept_fd, recv_buf, 1000, 0);
>         send(accept_fd, dot_buf, 500, 0);
>         recv(client_fd, recv_buf, 500, 0);

I can take a look at switching it over.

> > +
> > +     err = (int)(long)server_err;
> > +     CHECK_FAIL(err);
> > +
> > +close_client_fd:
> > +     close(client_fd);
> > +close_server_fd:
> > +     close(server_fd);
> > +     return err;
> > +}
> > +
> >  void test_tcpbpf_user(void)
> >  {
> >       const char *file = "test_tcpbpf_kern.o";
> > @@ -74,7 +173,6 @@ void test_tcpbpf_user(void)
> >       struct tcpbpf_globals g = {0};
> >       struct bpf_object *obj;
> >       int cg_fd = -1;
> > -     int retry = 10;
> >       __u32 key = 0;
> >       int rv;
> >
> > @@ -94,11 +192,6 @@ void test_tcpbpf_user(void)
> >               goto err;
> >       }
> >
> > -     if (CHECK_FAIL(system("./tcp_server.py"))) {
> > -             fprintf(stderr, "FAILED: TCP server\n");
> > -             goto err;
> > -     }
> > -
> >       map_fd = bpf_find_map(__func__, obj, "global_map");
> >       if (CHECK_FAIL(map_fd < 0))
> >               goto err;
> > @@ -107,21 +200,17 @@ void test_tcpbpf_user(void)
> >       if (CHECK_FAIL(sock_map_fd < 0))
> >               goto err;
> >
> > -retry_lookup:
> > +     if (run_test()) {
> > +             fprintf(stderr, "FAILED: TCP server\n");
> > +             goto err;
> > +     }
> > +
> >       rv = bpf_map_lookup_elem(map_fd, &key, &g);
> >       if (CHECK_FAIL(rv != 0)) {
> CHECK() is a better one here if it needs to output error message.
> The same goes for similar usages in this patch set.
>
> For the start_server() above which has already logged the error message,
> CHECK_FAIL() is good enough.
>
> >               fprintf(stderr, "FAILED: bpf_map_lookup_elem returns %d\n", rv);
> >               goto err;
> >       }
> >
> > -     if (g.num_close_events != EXPECTED_CLOSE_EVENTS && retry--) {
> It is good to have a solution to avoid a test depending on some number
> of retries.
>
> After looking at BPF_SOCK_OPS_STATE_CB in test_tcpbpf_kern.c,
> it is not clear to me removing python alone is enough to avoid the
> race (so the retry--).  One of the sk might still be in TCP_LAST_ACK
> instead of TCP_CLOSE.
>

After you pointed this out I decided to go back through and do some
further testing. After testing this for several thousand iterations it
does look like the issue can still happen, it was just significantly
less frequent with the threaded approach, but it was still there. So I
will go back through and add this back and then fold it into the
verify_results function in the third patch. Although I might reduce
the wait times as it seems like with the inline approach we only need
in the 10s of microseconds instead of 100s for the sockets to close
out.

> Also, when looking closer at BPF_SOCK_OPS_STATE_CB in test_tcpbpf_kern.c,
> it seems the map value "gp" is slapped together across multiple
> TCP_CLOSE events which may be not easy to understand.
>
> How about it checks different states: TCP_CLOSE, TCP_LAST_ACK,
> and BPF_TCP_FIN_WAIT2.  Each of this state will update its own
> values under "gp".  Something like this (only compiler tested on
> top of patch 4):
>
> diff --git i/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c w/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> index 7e92c37976ac..65b247b03dfc 100644
> --- i/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> +++ w/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> @@ -90,15 +90,14 @@ static void verify_result(int map_fd, int sock_map_fd)
>               result.event_map, expected_events);
>
>         ASSERT_EQ(result.bytes_received, 501, "bytes_received");
> -       ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
> +       ASSERT_EQ(result.bytes_acked, 1001, "bytes_acked");
>         ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
>         ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
>         ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
>         ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
> -       ASSERT_EQ(result.num_listen, 1, "num_listen");
> -
> -       /* 3 comes from one listening socket + both ends of the connection */
> -       ASSERT_EQ(result.num_close_events, 3, "num_close_events");
> +       ASSERT_EQ(result.num_listen_close, 1, "num_listen");
> +       ASSERT_EQ(result.num_last_ack, 1, "num_last_ack");
> +       ASSERT_EQ(result.num_fin_wait2, 1, "num_fin_wait2");
>
>         /* check setsockopt for SAVE_SYN */
>         key = 0;
> diff --git i/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c w/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> index 3e6912e4df3d..2c5ffb50d6e0 100644
> --- i/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> +++ w/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> @@ -55,9 +55,11 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>  {
>         char header[sizeof(struct ipv6hdr) + sizeof(struct tcphdr)];
>         struct bpf_sock_ops *reuse = skops;
> +       struct tcpbpf_globals *gp;
>         struct tcphdr *thdr;
>         int good_call_rv = 0;
>         int bad_call_rv = 0;
> +       __u32 key_zero = 0;
>         int save_syn = 1;
>         int rv = -1;
>         int v = 0;
> @@ -155,26 +157,21 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>         case BPF_SOCK_OPS_RETRANS_CB:
>                 break;
>         case BPF_SOCK_OPS_STATE_CB:
> -               if (skops->args[1] == BPF_TCP_CLOSE) {
> -                       __u32 key = 0;
> -                       struct tcpbpf_globals g, *gp;
> -
> -                       gp = bpf_map_lookup_elem(&global_map, &key);
> -                       if (!gp)
> -                               break;
> -                       g = *gp;
> -                       if (skops->args[0] == BPF_TCP_LISTEN) {
> -                               g.num_listen++;
> -                       } else {
> -                               g.total_retrans = skops->total_retrans;
> -                               g.data_segs_in = skops->data_segs_in;
> -                               g.data_segs_out = skops->data_segs_out;
> -                               g.bytes_received = skops->bytes_received;
> -                               g.bytes_acked = skops->bytes_acked;
> -                       }
> -                       g.num_close_events++;
> -                       bpf_map_update_elem(&global_map, &key, &g,
> -                                           BPF_ANY);
> +               gp = bpf_map_lookup_elem(&global_map, &key_zero);
> +               if (!gp)
> +                       break;
> +               if (skops->args[1] == BPF_TCP_CLOSE &&
> +                   skops->args[0] == BPF_TCP_LISTEN) {
> +                       gp->num_listen_close++;
> +               } else if (skops->args[1] == BPF_TCP_LAST_ACK) {
> +                       gp->total_retrans = skops->total_retrans;
> +                       gp->data_segs_in = skops->data_segs_in;
> +                       gp->data_segs_out = skops->data_segs_out;
> +                       gp->bytes_received = skops->bytes_received;
> +                       gp->bytes_acked = skops->bytes_acked;
> +                       gp->num_last_ack++;
> +               } else if (skops->args[1] == BPF_TCP_FIN_WAIT2) {
> +                       gp->num_fin_wait2++;
>                 }
>                 break;
>         case BPF_SOCK_OPS_TCP_LISTEN_CB:
> diff --git i/tools/testing/selftests/bpf/test_tcpbpf.h w/tools/testing/selftests/bpf/test_tcpbpf.h
> index 6220b95cbd02..0dec324ba4a6 100644
> --- i/tools/testing/selftests/bpf/test_tcpbpf.h
> +++ w/tools/testing/selftests/bpf/test_tcpbpf.h
> @@ -12,7 +12,8 @@ struct tcpbpf_globals {
>         __u32 good_cb_test_rv;
>         __u64 bytes_received;
>         __u64 bytes_acked;
> -       __u32 num_listen;
> -       __u32 num_close_events;
> +       __u32 num_listen_close;
> +       __u32 num_last_ack;
> +       __u32 num_fin_wait2;
>  };
>  #endif

I can look at pulling this in and including it as a patch 5 if you
would prefer. If I find any issues I will let you know.

> I also noticed the bytes_received/acked depends on the order of close(),
> i.e. always close the accepted fd first.  I think a comment
> in the tcpbpf_user.c is good enough for now.

Okay, I can add a comment explaining this.

> [ It does not have to be in this set and it can be done in another
>   follow up effort.
>   Instead of using a bpf map to store the result, using global
>   variables in test_tcpbpf_kern.c will simplify the code further. ]

I assume this comment is about the changes to test_tcpbpf_kern.c? Just
want to clarify as I assume this isn't about adding the comment about
the socket closing order affecting the bytes_received/acked.
