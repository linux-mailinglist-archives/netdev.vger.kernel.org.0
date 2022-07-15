Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9FF5766AF
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 20:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiGOSXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 14:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiGOSXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 14:23:08 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7340D61103
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 11:23:07 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bp15so10389175ejb.6
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 11:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jWGPKjSYtgm8f+10cydafAEP8xCcYn2Qbj/4JnyviCo=;
        b=MpKZb05FQkIMPdTslS3nS7ENjbJ8d87gVVROcA1t2bLaXeJKIeCYyu0mf1TgIiA+KZ
         w4Xa8uXF9+1zH+/asLT3213y19e1AKppb9uPJKD51sO5wj3SKaL3a8QVV+ZQliGGluc3
         grHUeEAdjwZneZAKWPnrvvLkPmZmYjq+C+GKhbzR8xiRP/Hxp0edLo71y56oarHIsgc1
         O5/xjAbTXfywg66XhkEQmvbR1/JQeAVz0JqoSeHWsS5oVZ1zskojCsVp5O2nmz2YkbH7
         UjqAc7kbzeKJ/cnCwO2fufef60XxgEX5SpNvPIm8yac9GabyRxk+BpJ0aGUrMlwNjowI
         w4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jWGPKjSYtgm8f+10cydafAEP8xCcYn2Qbj/4JnyviCo=;
        b=ZCOqI6qWoVDsmUhwmhcR9BWBOBHsysYbCk5FY8ZbBiATycLpUpUA9cZ6MDqGZEadXJ
         qkTU58SU/CikuUHYwE61TZMcXPmIWLlavW9sOEBLkfkcOLUjYfnEls2pXMER+wyZRhD4
         a12rthje66eAM9w5z5q1/6kYAN5dI2DFQsK4jrcgCnGbs+r0MAR/kp3OR3VXYI/UldT+
         kcaZnfnxzZUvhcSbJgj5h2YJLQQn/ZixEj3ZomH7LRrQaQbS8aCVMz6V78PzWn/Hszk9
         vJtCl7Bz3ltuGX1CQLXf8tpqe/+Qsz4RuWtp+fHHXsGz//7TlPIYEjixYwiUlHsHy973
         lxVA==
X-Gm-Message-State: AJIora/0lEAmgY4YRRX9M2RroJ+uo3TwWbDjnC/hz4N7vColZgEyt/LT
        7K1HLvR4ybkEyrVJULVi6fOUvRM3zLxeo/vQm3/jUjgt
X-Google-Smtp-Source: AGRyM1tNTRwy7wASfWnmnjfeBAN7MUq95UlRVxSuCF9FpYmclEbYgf2i6/a4Vka8+ji3kyxTPSLs0bGfp+XyvyRsy6o=
X-Received: by 2002:a17:907:608f:b0:72b:7db9:4dc6 with SMTP id
 ht15-20020a170907608f00b0072b7db94dc6mr14376793ejc.463.1657909385965; Fri, 15
 Jul 2022 11:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220712235310.1935121-1-joannelkoong@gmail.com>
 <20220712235310.1935121-3-joannelkoong@gmail.com> <5185dff4656a6e4830739c90feeaa3a15a472243.camel@redhat.com>
In-Reply-To: <5185dff4656a6e4830739c90feeaa3a15a472243.camel@redhat.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 15 Jul 2022 11:22:54 -0700
Message-ID: <CAJnrk1YGv-H7HBqvhdNcs+m_ytF+tF+qCHE5qLRORM0-2rp7EQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] selftests/net: Add test for timing a bind
 request to a port with a populated bhash entry
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
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

On Thu, Jul 14, 2022 at 2:18 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-07-12 at 16:53 -0700, Joanne Koong wrote:
> > This test populates the bhash table for a given port with
> > MAX_THREADS * MAX_CONNECTIONS sockets, and then times how long
> > a bind request on the port takes.
> >
> > When populating the bhash table, we create the sockets and then bind
> > the sockets to the same address and port (SO_REUSEADDR and SO_REUSEPORT
> > are set). When timing how long a bind on the port takes, we bind on a
> > different address without SO_REUSEPORT set. We do not set SO_REUSEPORT
> > because we are interested in the case where the bind request does not
> > go through the tb->fastreuseport path, which is fragile (eg
> > tb->fastreuseport path does not work if binding with a different uid).
> >
> > On my local machine, I see:
> > ipv4:
> > before - 0.002317 seconds
> > with bhash2 - 0.000020 seconds
> >
> > ipv6:
> > before - 0.002431 seconds
> > with bhash2 - 0.000021 seconds
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  tools/testing/selftests/net/.gitignore    |   3 +-
> >  tools/testing/selftests/net/Makefile      |   3 +
> >  tools/testing/selftests/net/bind_bhash.c  | 119 ++++++++++++++++++++++
> >  tools/testing/selftests/net/bind_bhash.sh |  23 +++++
> >  4 files changed, 147 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/net/bind_bhash.c
> >  create mode 100755 tools/testing/selftests/net/bind_bhash.sh
> >
> > diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> > index 1257baa79286..5b1adf6e29ae 100644
> > --- a/tools/testing/selftests/net/.gitignore
> > +++ b/tools/testing/selftests/net/.gitignore
> > @@ -37,4 +37,5 @@ gro
> >  ioam6_parser
> >  toeplitz
> >  cmsg_sender
> > -unix_connect
> > \ No newline at end of file
> > +unix_connect
> > +bind_bhash
> > diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> > index ddad703ace34..e678fc3030a2 100644
> > --- a/tools/testing/selftests/net/Makefile
> > +++ b/tools/testing/selftests/net/Makefile
> > @@ -39,6 +39,7 @@ TEST_PROGS += vrf_strict_mode_test.sh
> >  TEST_PROGS += arp_ndisc_evict_nocarrier.sh
> >  TEST_PROGS += ndisc_unsolicited_na_test.sh
> >  TEST_PROGS += stress_reuseport_listen.sh
> > +TEST_PROGS += bind_bhash.sh
> >  TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
> >  TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
> >  TEST_GEN_FILES =  socket nettest
> > @@ -59,6 +60,7 @@ TEST_GEN_FILES += toeplitz
> >  TEST_GEN_FILES += cmsg_sender
> >  TEST_GEN_FILES += stress_reuseport_listen
> >  TEST_PROGS += test_vxlan_vnifiltering.sh
> > +TEST_GEN_FILES += bind_bhash
> >
> >  TEST_FILES := settings
> >
> > @@ -70,3 +72,4 @@ include bpf/Makefile
> >  $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
> >  $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread
> >  $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
> > +$(OUTPUT)/bind_bhash: LDLIBS += -lpthread
> > diff --git a/tools/testing/selftests/net/bind_bhash.c b/tools/testing/selftests/net/bind_bhash.c
> > new file mode 100644
> > index 000000000000..252e73754e76
> > --- /dev/null
> > +++ b/tools/testing/selftests/net/bind_bhash.c
> > @@ -0,0 +1,119 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * This times how long it takes to bind to a port when the port already
> > + * has multiple sockets in its bhash table.
> > + *
> > + * In the setup(), we populate the port's bhash table with
> > + * MAX_THREADS * MAX_CONNECTIONS number of entries.
> > + */
> > +
> > +#include <unistd.h>
> > +#include <stdio.h>
> > +#include <netdb.h>
> > +#include <pthread.h>
> > +
> > +#define MAX_THREADS 600
> > +#define MAX_CONNECTIONS 40
> > +
> > +static const char *bind_addr = "::1";
> > +static const char *port;
> > +
> > +static int fd_array[MAX_THREADS][MAX_CONNECTIONS];
> > +
> > +static int bind_socket(int opt, const char *addr)
> > +{
> > +     struct addrinfo *res, hint = {};
> > +     int sock_fd, reuse = 1, err;
> > +
> > +     sock_fd = socket(AF_INET6, SOCK_STREAM, 0);
> > +     if (sock_fd < 0) {
> > +             perror("socket fd err");
> > +             return -1;
> > +     }
> > +
> > +     hint.ai_family = AF_INET6;
> > +     hint.ai_socktype = SOCK_STREAM;
> > +
> > +     err = getaddrinfo(addr, port, &hint, &res);
> > +     if (err) {
> > +             perror("getaddrinfo failed");
> > +             return -1;
> > +     }
> > +
> > +     if (opt) {
> > +             err = setsockopt(sock_fd, SOL_SOCKET, opt, &reuse, sizeof(reuse));
> > +             if (err) {
> > +                     perror("setsockopt failed");
> > +                     return -1;
> > +             }
> > +     }
> > +
> > +     err = bind(sock_fd, res->ai_addr, res->ai_addrlen);
> > +     if (err) {
> > +             perror("failed to bind to port");
> > +             return -1;
> > +     }
> > +
> > +     return sock_fd;
> > +}
> > +
> > +static void *setup(void *arg)
> > +{
> > +     int sock_fd, i;
> > +     int *array = (int *)arg;
> > +
> > +     for (i = 0; i < MAX_CONNECTIONS; i++) {
> > +             sock_fd = bind_socket(SO_REUSEADDR | SO_REUSEPORT, bind_addr);
> > +             if (sock_fd < 0)
> > +                     return NULL;
> > +             array[i] = sock_fd;
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +int main(int argc, const char *argv[])
> > +{
> > +     int listener_fd, sock_fd, i, j;
> > +     pthread_t tid[MAX_THREADS];
> > +     clock_t begin, end;
> > +
> > +     if (argc != 2) {
> > +             printf("Usage: listener <port>\n");
> > +             return -1;
> > +     }
> > +
> > +     port = argv[1];
> > +
> > +     listener_fd = bind_socket(SO_REUSEADDR | SO_REUSEPORT, bind_addr);
> > +     if (listen(listener_fd, 100) < 0) {
> > +             perror("listen failed");
> > +             return -1;
> > +     }
> > +
> > +     /* Set up threads to populate the bhash table entry for the port */
> > +     for (i = 0; i < MAX_THREADS; i++)
> > +             pthread_create(&tid[i], NULL, setup, fd_array[i]);
> > +
> > +     for (i = 0; i < MAX_THREADS; i++)
> > +             pthread_join(tid[i], NULL);
> > +
> > +     begin = clock();
> > +
> > +     /* Bind to the same port on a different address */
> > +     sock_fd  = bind_socket(0, "2001:0db8:0:f101::1");
>
> I think it's better/nicer if you make this address configurable from
> the command line, instead of hard-codying it here.
I will make this change for v3.
> > +
> > +     end = clock();
> > +
> > +     printf("time spent = %f\n", (double)(end - begin) / CLOCKS_PER_SEC);
> > +
> > +     /* clean up */
> > +     close(sock_fd);
> > +     close(listener_fd);
> > +     for (i = 0; i < MAX_THREADS; i++) {
> > +             for (j = 0; i < MAX_THREADS; i++)
> > +                     close(fd_array[i][j]);
> > +     }
> > +
> > +     return 0;
> > +}
> > diff --git a/tools/testing/selftests/net/bind_bhash.sh b/tools/testing/selftests/net/bind_bhash.sh
> > new file mode 100755
> > index 000000000000..f7794d63efd2
> > --- /dev/null
> > +++ b/tools/testing/selftests/net/bind_bhash.sh
> > @@ -0,0 +1,23 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +NR_FILES=32768
> > +SAVED_NR_FILES=$(ulimit -n)
> > +
> > +setup() {
> > +     ip addr add dev eth0 2001:0db8:0:f101::1
>
> If you add the 'nodad' option here...
>
> > +     ulimit -n $NR_FILES
> > +     sleep 1
>
> ... this should not be needed
Awesome! Thanks, I will add this 'nodad' option.
>
> Also what about ipv4 tests?
I will update this to also include the ipv4 version of the test in v3.
>
>
> Thanks!
>
> Paolo
>
