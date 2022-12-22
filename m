Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EDF6547FA
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 22:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLVVlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 16:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiLVVlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 16:41:24 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2DC23327
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 13:41:23 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-3b48b139b46so42881247b3.12
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 13:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uCFHd6D1KillGb1thxjpKO8HldSHVVHhJaZ2UEX1cRM=;
        b=Ec4Uu+jwmN24pOxJMcurz37VStxcLNcWykBHffwjbBYplEZdNRrYMCC3RMPqRf2vR8
         2ejWwq+4NQAbS+M/WoceYu0glG2V9E32rjZKr0Ex7V5Yoa323MpDYPWPyRlDod2yZfw2
         evKhDsDWMEh5HPkPOBAsoHgV7qsrw9uuZCjy/3E2usR0ms2YRIclPGGFeFgygF1sd9Kd
         VRLPSh3LAcdKAypFwHczgYq5trz3IRSHfTSUG4JTcn5kXEuymORmeGuC7S/RLwvXIUHa
         GOxZ8MWhe0Zvd+x843i2m7GfY9qqnTuT4lbuefH4pGgMmhaJM01EPXKQ+gltKQsSXyHg
         CZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uCFHd6D1KillGb1thxjpKO8HldSHVVHhJaZ2UEX1cRM=;
        b=iUxgLiaj/ZeWC91WMLNomzNQzSmZFKHjlnVDSelQT5J9u8TxdUgUYUf95qu3XCMosy
         1UV/UuQNgiHJlSx5FiE53BGho4HhozUtA2RkJoUyTfy9ymNx1DegRCAxPxdkvpYSkwQj
         3nlNLXUncbvTmbTH5GEiNAOKIkjB8xSTq27ZRA7oKW6FIi3l45mIFCIC3uAi6pXmgUK4
         rc2sVt4yl7WtxEQyjj7+a6BsEmRTzQ5NyRMcpTYYdIOoX4AAu2Q2UQ/h/JS/Tf5+DnZ3
         /f6F4lUsx8nUnDVhC6BFt6bxlxcVCBHv0LpinRqc9kwHFY/eCs2ydtiIN3Ch21TqHZd6
         /ruA==
X-Gm-Message-State: AFqh2koRkqQMD5F7oqYJnRe3iGG3BxA5dbEzYNbsT3cdtv4B8n/bl9On
        GNxSuge387I8Opvtgk+Ct5eH+MaT2+KJdgCf7zU=
X-Google-Smtp-Source: AMrXdXvQotJyRACGs5Uw5gg3ba9m+tK5RqTqV3X4noubqcmVP/v8j5B/AW1qBM6kRgD62KH3W8IEE+GJDPCNEPUoi3w=
X-Received: by 2002:a0d:eb49:0:b0:460:8f19:5ea9 with SMTP id
 u70-20020a0deb49000000b004608f195ea9mr743236ywe.21.1671745282287; Thu, 22 Dec
 2022 13:41:22 -0800 (PST)
MIME-Version: 1.0
References: <20221221151258.25748-1-kuniyu@amazon.com> <20221221151258.25748-3-kuniyu@amazon.com>
In-Reply-To: <20221221151258.25748-3-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 22 Dec 2022 13:41:11 -0800
Message-ID: <CAJnrk1Zc5Zz7c5CY8t14-Mg3SPmGFwCB6TFbPHfSSkexFJW8uw@mail.gmail.com>
Subject: Re: [PATCH RFC net 2/2] tcp: Add selftest for bind() and TIME_WAIT.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
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

On Wed, Dec 21, 2022 at 7:14 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> bhash2 split the bind() validation logic into wildcard and non-wildcard
> cases.  Let's add a test to catch the same regression.
>
> Before the previous patch:
>
>   # ./bind_timewait
>   TAP version 13
>   1..2
>   # Starting 2 tests from 3 test cases.
>   #  RUN           bind_timewait.localhost.1 ...
>   # bind_timewait.c:87:1:Expected ret (0) == -1 (-1)
>   # 1: Test terminated by assertion
>   #          FAIL  bind_timewait.localhost.1
>   not ok 1 bind_timewait.localhost.1
>   #  RUN           bind_timewait.addrany.1 ...
>   #            OK  bind_timewait.addrany.1
>   ok 2 bind_timewait.addrany.1
>   # FAILED: 1 / 2 tests passed.
>   # Totals: pass:1 fail:1 xfail:0 xpass:0 skip:0 error:0
>
> After:
>
>   # ./bind_timewait
>   TAP version 13
>   1..2
>   # Starting 2 tests from 3 test cases.
>   #  RUN           bind_timewait.localhost.1 ...
>   #            OK  bind_timewait.localhost.1
>   ok 1 bind_timewait.localhost.1
>   #  RUN           bind_timewait.addrany.1 ...
>   #            OK  bind_timewait.addrany.1
>   ok 2 bind_timewait.addrany.1
>   # PASSED: 2 / 2 tests passed.
>   # Totals: pass:2 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  tools/testing/selftests/net/.gitignore      |  1 +
>  tools/testing/selftests/net/bind_timewait.c | 93 +++++++++++++++++++++
>  2 files changed, 94 insertions(+)
>  create mode 100644 tools/testing/selftests/net/bind_timewait.c
>
> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> index 9cc84114741d..a6911cae368c 100644
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  bind_bhash
> +bind_timewait
>  csum
>  cmsg_sender
>  diag_uid
> diff --git a/tools/testing/selftests/net/bind_timewait.c b/tools/testing/selftests/net/bind_timewait.c
> new file mode 100644
> index 000000000000..2d40403128ff
> --- /dev/null
> +++ b/tools/testing/selftests/net/bind_timewait.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Amazon.com Inc. or its affiliates. */
> +
> +#include "../kselftest_harness.h"

nit: Not sure if this matters or not, but from looking at the other
selftests/net it seems like the convention is to have relative path
#include defined below absolute path #includes.

> +
> +#include <sys/socket.h>
> +#include <netinet/in.h>
> +#include <netinet/tcp.h>

nit: i don't think we need this netinet/tcp.h include

> +
> +FIXTURE(bind_timewait)
> +{
> +       struct sockaddr_in addr;
> +       socklen_t addrlen;
> +};
> +
> +FIXTURE_VARIANT(bind_timewait)
> +{
> +       __u32 addr_const;
> +};
> +
> +FIXTURE_VARIANT_ADD(bind_timewait, localhost)
> +{
> +       .addr_const = INADDR_LOOPBACK
> +};
> +
> +FIXTURE_VARIANT_ADD(bind_timewait, addrany)
> +{
> +       .addr_const = INADDR_ANY
> +};
> +
> +FIXTURE_SETUP(bind_timewait)
> +{
> +       self->addr.sin_family = AF_INET;
> +       self->addr.sin_port = 0;
> +       self->addr.sin_addr.s_addr = htonl(variant->addr_const);
> +       self->addrlen = sizeof(self->addr);
> +}
> +
> +FIXTURE_TEARDOWN(bind_timewait)
> +{
> +}
> +
> +void create_timewait_socket(struct __test_metadata *_metadata,
> +                           FIXTURE_DATA(bind_timewait) *self)
> +{
> +       int server_fd, client_fd, child_fd, ret;
> +       struct sockaddr_in addr;
> +       socklen_t addrlen;
> +
> +       server_fd = socket(AF_INET, SOCK_STREAM, 0);
> +       ASSERT_GT(server_fd, 0);

If any of these assertions fail, do we leak fds because we don't get
to calling the close()s at the end of this function? Do we need to
have the fds cleaned up in the teardown fixture function?

> +
> +       ret = bind(server_fd, (struct sockaddr *)&self->addr, self->addrlen);
> +       ASSERT_EQ(ret, 0);
> +
> +       ret = listen(server_fd, 1);
> +       ASSERT_EQ(ret, 0);
> +
> +       ret = getsockname(server_fd, (struct sockaddr *)&self->addr, &self->addrlen);
> +       ASSERT_EQ(ret, 0);
> +
> +       client_fd = socket(AF_INET, SOCK_STREAM, 0);
> +       ASSERT_GT(client_fd, 0);
> +
> +       ret = connect(client_fd, (struct sockaddr *)&self->addr, self->addrlen);
> +       ASSERT_EQ(ret, 0);
> +
> +       addrlen = sizeof(addr);
> +       child_fd = accept(server_fd, (struct sockaddr *)&addr, &addrlen);
> +       ASSERT_GT(child_fd, 0);
> +
> +       close(child_fd);
> +       close(client_fd);
> +       close(server_fd);
> +}
> +
> +TEST_F(bind_timewait, 1)
> +{
> +       int fd, ret;
> +
> +       create_timewait_socket(_metadata, self);
> +
> +       fd = socket(AF_INET, SOCK_STREAM, 0);
> +       ASSERT_GT(fd, 0);
> +
> +       ret = bind(fd, (struct sockaddr *)&self->addr, self->addrlen);
> +       ASSERT_EQ(ret, -1);
> +       ASSERT_EQ(errno, EADDRINUSE);
> +
> +       close(fd);
> +}
> +
> +TEST_HARNESS_MAIN
> --
> 2.30.2
>
