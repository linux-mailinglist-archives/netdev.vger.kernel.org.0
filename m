Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE17F6ED31E
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjDXRGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjDXRGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:06:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B477C4EDF
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:06:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-24b9e5a9a68so1206676a91.3
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682355996; x=1684947996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5EEWS79TKEuhbit6OUpFdqDeF72y6fox6I/RJUsHISU=;
        b=nYjtIykyAI+1fziZyYa0yifeT2qLuD3amhV7ZMtBZY8aNu7bxYIU/DC5vI1qbIh5we
         rDjDRQdzXGu4tZSxfoJJKGJKgFzpL8XN8fnZkH4m3hnkHeRgPROodPtHCqtmINs4ESoj
         anbjxDN5yDGre3E/7IGeDFD4EPfr+mwDYeQgvn/xHgGgbGE4z3TzLv0z2Ft4s4/PKULM
         t2BFoHqQC8euq9cH7R1TFV9rQB61o8s3pCWW5HYDZVrBF/1IINRdWntDuNngvGuL+VGR
         Ke2mQQ9dOvfULt9QwUXWrC8Ylu6S1dmIIpmoQi6yOUWfaXYlKR+WV52l3Ix6ihOSqIo7
         cPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682355996; x=1684947996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5EEWS79TKEuhbit6OUpFdqDeF72y6fox6I/RJUsHISU=;
        b=MG9glIOAEFq3LTXxT5mugkAY1dFb8NwVDzUa8MJkt+B2UYL1k71fO4+tOtYXnaGR+d
         1p2XMrvN8Dr5ZOFdihFc+C8VO50tnb0dq5V1UR37IbEoL8svg9lPwgVhNpeh3fj9OTNn
         P4NLtGM5rDMapFNz4/nu4WQLJZx/5rlIi+9/mUxFgbZihW4kY6gZT3JeRj4dYc4mfOP3
         /Pg40mnqzJg3gHitSt5Vo2IMUFAHnI7ynpihg9Q1JRFvAxoQPaCPsMOp5k1njlurfAb+
         8uaFTEDow6wwBygTfcc+kt0lsSPGPhZZp80pCLEr5ixE2sDqSDU07CBeugA+tHDMDqDs
         XkQw==
X-Gm-Message-State: AAQBX9e5fGcJijy+wuwDDMI/YDOY+mGI1waEinNvLvbfefVtohBIhiNk
        s7FU030KaBOGduHmYnib0WEdQG9iE2tXt/xyF63gXA==
X-Google-Smtp-Source: AKy350Zc5CiL2onGifwnLM4pfmBPls37fOJGhYMfUtixpmHeBYyhKl9G+x8iv8PS4jllJFSREAFMCnVvKRPi95cHqCY=
X-Received: by 2002:a17:90b:297:b0:234:f77:d6d2 with SMTP id
 az23-20020a17090b029700b002340f77d6d2mr13966476pjb.45.1682355995966; Mon, 24
 Apr 2023 10:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230420145041.508434-1-gilad9366@gmail.com> <20230420145041.508434-5-gilad9366@gmail.com>
 <ZEFr1M0PDziB2c9g@google.com> <da23eb41-f3b6-16cb-def7-c87388c55423@gmail.com>
In-Reply-To: <da23eb41-f3b6-16cb-def7-c87388c55423@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 24 Apr 2023 10:06:24 -0700
Message-ID: <CAKH8qBtQepoFJxYKJCm7GxxLpK8C7ghPdghSyTmo+4pnL2jn2w@mail.gmail.com>
Subject: Re: [PATCH bpf,v2 4/4] selftests/bpf: Add tc_socket_lookup tests
To:     Gilad Sever <gilad9366@gmail.com>
Cc:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz,
        eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 2:31=E2=80=AFAM Gilad Sever <gilad9366@gmail.com> w=
rote:
>
>
> On 20/04/2023 19:44, Stanislav Fomichev wrote:
> > On 04/20, Gilad Sever wrote:
> >> Verify that socket lookup via TC with all BPF APIs is VRF aware.
> >>
> >> Signed-off-by: Gilad Sever <gilad9366@gmail.com>
> >> ---
> >> v2: Fix build by initializing vars with -1
> >> ---
> >>   .../bpf/prog_tests/tc_socket_lookup.c         | 341 ++++++++++++++++=
++
> >>   .../selftests/bpf/progs/tc_socket_lookup.c    |  73 ++++
> >>   2 files changed, 414 insertions(+)
> >>   create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_socket_=
lookup.c
> >>   create mode 100644 tools/testing/selftests/bpf/progs/tc_socket_looku=
p.c
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c=
 b/tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
> >> new file mode 100644
> >> index 000000000000..5dcaf0ea3f8c
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
> >> @@ -0,0 +1,341 @@
> >> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> >> +
> >> +/*
> >> + * Topology:
> >> + * ---------
> >> + *     NS1 namespace         |   NS2 namespace
> >> + *                       |
> >> + *     +--------------+      |   +--------------+
> >> + *     |    veth01    |----------|    veth10    |
> >> + *     | 172.16.1.100 |      |   | 172.16.1.200 |
> >> + *     |     bpf      |      |   +--------------+
> >> + *     +--------------+      |
> >> + *      server(UDP/TCP)      |
> >> + *  +-------------------+    |
> >> + *  |        vrf1       |    |
> >> + *  |  +--------------+ |    |   +--------------+
> >> + *  |  |    veth02    |----------|    veth20    |
> >> + *  |  | 172.16.2.100 | |    |   | 172.16.2.200 |
> >> + *  |  |     bpf      | |    |   +--------------+
> >> + *  |  +--------------+ |    |
> >> + *  |   server(UDP/TCP) |    |
> >> + *  +-------------------+    |
> >> + *
> >> + * Test flow
> >> + * -----------
> >> + *  The tests verifies that socket lookup via TC is VRF aware:
> >> + *  1) Creates two veth pairs between NS1 and NS2:
> >> + *     a) veth01 <-> veth10 outside the VRF
> >> + *     b) veth02 <-> veth20 in the VRF
> >> + *  2) Attaches to veth01 and veth02 a program that calls:
> >> + *     a) bpf_skc_lookup_tcp() with TCP and tcp_skc is true
> >> + *     b) bpf_sk_lookup_tcp() with TCP and tcp_skc is false
> >> + *     c) bpf_sk_lookup_udp() with UDP
> >> + *     The program stores the lookup result in bss->lookup_status.
> >> + *  3) Creates a socket TCP/UDP server in/outside the VRF.
> >> + *  4) The test expects lookup_status to be:
> >> + *     a) 0 from device in VRF to server outside VRF
> >> + *     b) 0 from device outside VRF to server in VRF
> >> + *     c) 1 from device in VRF to server in VRF
> >> + *     d) 1 from device outside VRF to server outside VRF
> >> + */
> >> +
> >> +#include <net/if.h>
> >> +
> >> +#include "test_progs.h"
> >> +#include "network_helpers.h"
> >> +#include "tc_socket_lookup.skel.h"
> >> +
> >> +#define NS1 "tc_socket_lookup_1"
> >> +#define NS2 "tc_socket_lookup_2"
> >> +
> >> +#define IP4_ADDR_VETH01 "172.16.1.100"
> >> +#define IP4_ADDR_VETH10 "172.16.1.200"
> >> +#define IP4_ADDR_VETH02 "172.16.2.100"
> >> +#define IP4_ADDR_VETH20 "172.16.2.200"
> >> +
> >> +#define NON_VRF_PORT 5000
> >> +#define IN_VRF_PORT 5001
> >> +
> >> +#define IO_TIMEOUT_SEC      3
> >> +
> >> +#define SYS(fmt, ...)                                               \
> >> +    ({                                                      \
> >> +            char cmd[1024];                                 \
> >> +            snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__); \
> >> +            if (!ASSERT_OK(system(cmd), cmd))               \
> >> +                    goto fail;                              \
> >> +    })
> >> +
> >> +#define SYS_NOFAIL(fmt, ...)                                        \
> >> +    ({                                                      \
> >> +            char cmd[1024];                                 \
> >> +            snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__); \
> >> +            system(cmd);                                    \
> >> +    })
> > [..]
> >
> >> +static int make_socket(int sotype, const char *ip, int port,
> >> +                   struct sockaddr_storage *addr)
> >> +{
> >> +    struct timeval timeo =3D { .tv_sec =3D IO_TIMEOUT_SEC };
> >> +    int err, fd;
> >> +
> >> +    err =3D make_sockaddr(AF_INET, ip, port, addr, NULL);
> >> +    if (!ASSERT_OK(err, "make_address"))
> >> +            return -1;
> >> +
> >> +    fd =3D socket(AF_INET, sotype, 0);
> >> +    if (!ASSERT_OK(fd < 0, "socket"))
> >> +            return -1;
> >> +
> >> +    err =3D setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeo, sizeof(ti=
meo));
> >> +    if (!ASSERT_OK(err, "setsockopt(SO_SNDTIMEO)"))
> >> +            goto fail;
> >> +
> >> +    err =3D setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeo, sizeof(ti=
meo));
> >> +    if (!ASSERT_OK(err, "setsockopt(SO_RCVTIMEO)"))
> >> +            goto fail;
> >> +
> >> +    return fd;
> >> +fail:
> >> +    close(fd);
> >> +    return -1;
> >> +}
> >> +
> >> +static int make_server(int sotype, const char *ip, int port, const ch=
ar *ifname)
> >> +{
> >> +    struct sockaddr_storage addr =3D {};
> >> +    const int one =3D 1;
> >> +    int err, fd =3D -1;
> >> +
> >> +    fd =3D make_socket(sotype, ip, port, &addr);
> >> +    if (fd < 0)
> >> +            return -1;
> >> +
> >> +    if (sotype =3D=3D SOCK_STREAM) {
> >> +            err =3D setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &one,
> >> +                             sizeof(one));
> >> +            if (!ASSERT_OK(err, "setsockopt(SO_REUSEADDR)"))
> >> +                    goto fail;
> >> +    }
> >> +
> >> +    if (ifname) {
> >> +            err =3D setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE,
> >> +                             ifname, strlen(ifname) + 1);
> >> +            if (!ASSERT_OK(err, "setsockopt(SO_BINDTODEVICE)"))
> >> +                    goto fail;
> >> +    }
> >> +
> >> +    err =3D bind(fd, (void *)&addr, sizeof(struct sockaddr_in));
> >> +    if (!ASSERT_OK(err, "bind"))
> >> +            goto fail;
> >> +
> >> +    if (sotype =3D=3D SOCK_STREAM) {
> >> +            err =3D listen(fd, SOMAXCONN);
> >> +            if (!ASSERT_OK(err, "listen"))
> >> +                    goto fail;
> >> +    }
> >> +
> >> +    return fd;
> >> +fail:
> >> +    close(fd);
> >> +    return -1;
> >> +}
> > Any reason you're not using start_server from network_helpers.h?
> > It's because I need to bind the server socket to the VRF device.

I see, thanks, so it's the SO_BINDTODEVICE part. Looks generic enough
to belong to network_helpers.h. WDYT?
Does it make sense to extend __start_server to support it? Or have a
new separate network_helper for this?
