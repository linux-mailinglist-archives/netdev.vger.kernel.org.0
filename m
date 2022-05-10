Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F58520A77
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiEJBFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbiEJBFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:05:32 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2930125C62
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:01:35 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2ec42eae76bso163337067b3.10
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 18:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zbn4Fs6SQPnQxwHJ8AwLsB23UvgKn7jtXzqWNlmiBfY=;
        b=TlV3KT04/3Vl8/H1TsAK06gLnqdNvaZoPzSKsHsdk69ofwPAEIfdPIJtArNnBEnmmh
         oNE2w7sakeJDxsiVxhZnMY738nSY72GyVlwITEzypsvsuLwijB7HLTxlhKgMuJTo1fdT
         C0CU2zpPD7d1Yq2jS8VMhTIZPLT25LV5SAvaLT5DgRGYmzgubNIvWrknhKEWeKsnh3+g
         gcQCzQxyImmtbRqrMbdAuQqTStZcwjBNSUazMftctq1XPJl/M5BAED1yUxDc/ZwgM0y/
         0Si40JPQphDnEWkYVZayTo1XxV3/l5OFL6uacZA9NH0V12ugaDTz5vQKNsyq/cGQOO8J
         8I9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zbn4Fs6SQPnQxwHJ8AwLsB23UvgKn7jtXzqWNlmiBfY=;
        b=Vf++aYa0u2IUMDIWoOow9KhIH+7crmlMCC7KPormBip9sTXn3LfSuoYsnYZ7JDr+cG
         XkrxoHO6hTHBy7qoP6kpF6maYOvB9RUwuM0DLcUxrnnDBo1MHkR6yyjYAYBKXYf2E8lj
         A90MOqG7sWVuLcYstm2fWTq/mqTVdRNr8Kg18fQukbIQIGm7UvZDS6xJiJTPL5n5BH7n
         GXwGPddGxgoTOvsU1L4+h6mKw1iLcVq2NhJvOg5eJXV1lDAWKuJU5HcGhyQjPTJeQVHQ
         oEqRuO6nKiVujJMSDmA1wZ7lKQC/L7zm7+TM+GzCI4Y1gXbNsOuIVaJSYxY6IGCmS4WF
         fk4w==
X-Gm-Message-State: AOAM5314CBcEfUzxpYJSY3QYOP47l8dSGBxKQO8jVkrFLDwvv+9vZ5gq
        c87dZTGsferPRl9/qpa7NzSHsPpQZ0JDb0EMEC4pQaUn
X-Google-Smtp-Source: ABdhPJwe5nQAph09pIxb9/gYRwes0W1XWpvgafsSNxEF4T/aI1tfvtjYrJA2elV61vDKpCJMxq+rtZmKChD4zY/oCBU=
X-Received: by 2002:a81:1796:0:b0:2f7:d7bc:5110 with SMTP id
 144-20020a811796000000b002f7d7bc5110mr16242888ywx.12.1652144494161; Mon, 09
 May 2022 18:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220510005316.3967597-1-joannelkoong@gmail.com> <20220510005316.3967597-3-joannelkoong@gmail.com>
In-Reply-To: <20220510005316.3967597-3-joannelkoong@gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Mon, 9 May 2022 18:01:23 -0700
Message-ID: <CAJnrk1Zn2sy=bVC5HBggRHTTkjqqXZAx1VyO1r8PWSkLBY7KRw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] selftests: Add test for timing a bind
 request to a port with a populated bhash entry
To:     netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 5:54 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> This test populates the bhash table for a given port with
> MAX_THREADS * MAX_CONNECTIONS sockets, and then times how long
> a bind request on the port takes.
>
> When populating the bhash table, we create the sockets and then bind
> the sockets to the same address and port (SO_REUSEADDR and SO_REUSEPORT
> are set). When timing how long a bind on the port takes, we bind on a
> different address without SO_REUSEPORT set. We do not set SO_REUSEPORT
> because we are interested in the case where the bind request does not
> go through the tb->fastreuseport path, which is fragile (eg
> tb->fastreuseport path does not work if binding with a different uid).
>
> To run the test locally, I did:
> * ulimit -n 65535000
> * ip addr add 2001:0db8:0:f101::1 dev eth0
> * ./bind_bhash_test 443
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  tools/testing/selftests/net/.gitignore        |   1 +
>  tools/testing/selftests/net/Makefile          |   2 +
>  tools/testing/selftests/net/bind_bhash_test.c | 119 ++++++++++++++++++
>  3 files changed, 122 insertions(+)
>  create mode 100644 tools/testing/selftests/net/bind_bhash_test.c
>
> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> index 21a411b04890..735423136bc4 100644
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@ -36,3 +36,4 @@ gro
>  ioam6_parser
>  toeplitz
>  cmsg_sender
> +bind_bhash_test
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index af7f6e6ff182..b2cf3fa152ad 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -55,6 +55,7 @@ TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
>  TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
>  TEST_GEN_FILES += toeplitz
>  TEST_GEN_FILES += cmsg_sender
> +TEST_GEN_FILES += bind_bhash_test
>
>  TEST_FILES := settings
>
> @@ -63,4 +64,5 @@ include ../lib.mk
>
>  $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
>  $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread
> +$(OUTPUT)/bind_bhash_test: LDLIBS += -lpthread
>  $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
> diff --git a/tools/testing/selftests/net/bind_bhash_test.c b/tools/testing/selftests/net/bind_bhash_test.c
> new file mode 100644
> index 000000000000..252e73754e76
> --- /dev/null
> +++ b/tools/testing/selftests/net/bind_bhash_test.c
> @@ -0,0 +1,119 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * This times how long it takes to bind to a port when the port already
> + * has multiple sockets in its bhash table.
> + *
> + * In the setup(), we populate the port's bhash table with
> + * MAX_THREADS * MAX_CONNECTIONS number of entries.
> + */
> +
> +#include <unistd.h>
> +#include <stdio.h>
> +#include <netdb.h>
> +#include <pthread.h>
> +
> +#define MAX_THREADS 600
> +#define MAX_CONNECTIONS 40
> +
> +static const char *bind_addr = "::1";
> +static const char *port;
> +
> +static int fd_array[MAX_THREADS][MAX_CONNECTIONS];
> +
> +static int bind_socket(int opt, const char *addr)
> +{
> +       struct addrinfo *res, hint = {};
> +       int sock_fd, reuse = 1, err;
> +
> +       sock_fd = socket(AF_INET6, SOCK_STREAM, 0);
> +       if (sock_fd < 0) {
> +               perror("socket fd err");
> +               return -1;
> +       }
> +
> +       hint.ai_family = AF_INET6;
> +       hint.ai_socktype = SOCK_STREAM;
> +
> +       err = getaddrinfo(addr, port, &hint, &res);
> +       if (err) {
> +               perror("getaddrinfo failed");
> +               return -1;
> +       }
> +
> +       if (opt) {
> +               err = setsockopt(sock_fd, SOL_SOCKET, opt, &reuse, sizeof(reuse));
> +               if (err) {
> +                       perror("setsockopt failed");
> +                       return -1;
> +               }
> +       }
> +
> +       err = bind(sock_fd, res->ai_addr, res->ai_addrlen);
> +       if (err) {
> +               perror("failed to bind to port");
> +               return -1;
> +       }
> +
> +       return sock_fd;
> +}
> +
> +static void *setup(void *arg)
> +{
> +       int sock_fd, i;
> +       int *array = (int *)arg;
> +
> +       for (i = 0; i < MAX_CONNECTIONS; i++) {
> +               sock_fd = bind_socket(SO_REUSEADDR | SO_REUSEPORT, bind_addr);
> +               if (sock_fd < 0)
> +                       return NULL;
> +               array[i] = sock_fd;
> +       }
> +
> +       return NULL;
> +}
> +
> +int main(int argc, const char *argv[])
> +{
> +       int listener_fd, sock_fd, i, j;
> +       pthread_t tid[MAX_THREADS];
> +       clock_t begin, end;
> +
> +       if (argc != 2) {
> +               printf("Usage: listener <port>\n");
> +               return -1;
> +       }
> +
> +       port = argv[1];
> +
> +       listener_fd = bind_socket(SO_REUSEADDR | SO_REUSEPORT, bind_addr);
> +       if (listen(listener_fd, 100) < 0) {
> +               perror("listen failed");
> +               return -1;
> +       }
> +
> +       /* Set up threads to populate the bhash table entry for the port */
> +       for (i = 0; i < MAX_THREADS; i++)
> +               pthread_create(&tid[i], NULL, setup, fd_array[i]);
> +
> +       for (i = 0; i < MAX_THREADS; i++)
> +               pthread_join(tid[i], NULL);
> +
> +       begin = clock();
> +
> +       /* Bind to the same port on a different address */
> +       sock_fd  = bind_socket(0, "2001:0db8:0:f101::1");
> +
> +       end = clock();
> +
> +       printf("time spent = %f\n", (double)(end - begin) / CLOCKS_PER_SEC);
> +
> +       /* clean up */
> +       close(sock_fd);
> +       close(listener_fd);
> +       for (i = 0; i < MAX_THREADS; i++) {
> +               for (j = 0; i < MAX_THREADS; i++)
> +                       close(fd_array[i][j]);
> +       }
> +
> +       return 0;
> +}
Eric, this is what I used locally to test the bind request. Depending
on what you think about this bhash2 proposal, I am happy to clean up
this test in a v3 follow-up.
> --
> 2.30.2
>
