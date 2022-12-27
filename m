Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E305656DDB
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 19:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiL0SIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 13:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiL0SIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 13:08:35 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113B11010
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 10:08:35 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-45f4aef92daso193779777b3.0
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 10:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cdy5lnJHEMRm8nW9P/7kpgqO464kgy8tCYbuqRo9Odw=;
        b=Gc1zF069P6aZuWrrV4uMbl2grpDgK8qSqlicKPxb5woC+5mjIOJO3/+wdy9qLowc5D
         YtyxYXr3yHq9Hbsaz1sYqhPtxlcKiDp/EC1nV+WOJCnPuFKIJ6HZGT2wBuH+LSOlxzL9
         5mbj3PQE+S5kP0l0pDwg3kAcLZDa4qf2yz6mlqG6b5UYmXL/L5b7kdeaQx1AKt/x9YPC
         9JC+ySxb9YNdbzv5hwJsSrKEyPr5LMCTTvnOoY9J7G2ZMQXkAfSyBrHS2AJPPiHucY9w
         oWEshu2Q4W2YVbtgm45sTZFCxGlQQxbx9NP2sIsSfciDkSSMbz9BDbuqQ08T3VRz6TKX
         r3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cdy5lnJHEMRm8nW9P/7kpgqO464kgy8tCYbuqRo9Odw=;
        b=CgCIWFtJuQpQK2Gdetmh5Htq7s1TI5ZfVazPixqaCU/JC2VK5Mw/tZUJIapY0dEpDd
         5Tbp/pNDTDOaZFuKaYCrT6PMYGwoHcBa+SDXMyx+fBMJpMtbt+vXI500tBR5OdqDMTVK
         YWbddX9Oje0j5lQfafdCUs/glyJZ7fJkNWtqv3QJh4mU+ZHzGNksM4eUxzTNUNo4Djjb
         4VFAR68ynhCaXLFagYsdKT1Uy1cYraPXl++mt5nIAIYAsnN/VJo6oqEwMUBnK9W55dj+
         sqmGpJVycMrBigM3K3n9NmA9FY51aDzoJ+LuXd3eDyw1oloxHUs5ePrX0x58QhHd6DUG
         ppCw==
X-Gm-Message-State: AFqh2krbOGs6++82t4GabtpIJ9JcUAzJ9eqLkCPfP7jjUF7/v+6US0rC
        kLKu31IGlVTwPJvRb/Rh4PPeZn7idcgkkd0PFB4=
X-Google-Smtp-Source: AMrXdXulnimUvSXIWBRvrWNuuLeytkBm/ecCqmxVvL7LlE35ZbHXGRQscAuVbMKpgFNl2m9iZJA81t48pl6KhKGnfx8=
X-Received: by 2002:a0d:dc86:0:b0:3d5:ecbb:2923 with SMTP id
 f128-20020a0ddc86000000b003d5ecbb2923mr2863353ywe.485.1672164514211; Tue, 27
 Dec 2022 10:08:34 -0800 (PST)
MIME-Version: 1.0
References: <20221226132753.44175-1-kuniyu@amazon.com> <20221226132753.44175-3-kuniyu@amazon.com>
In-Reply-To: <20221226132753.44175-3-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 27 Dec 2022 10:08:22 -0800
Message-ID: <CAJnrk1aWLfvgit5CgoctMK03LtOMc-SuGu5J=jB1LwCPCYNfiA@mail.gmail.com>
Subject: Re: [PATCH v1 net 2/2] tcp: Add selftest for bind() and TIME_WAIT.
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

On Mon, Dec 26, 2022 at 5:29 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> bhash2 split the bind() validation logic into wildcard and non-wildcard
> cases.  Let's add a test to catch future regression.
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

Acked-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  tools/testing/selftests/net/.gitignore      |  1 +
>  tools/testing/selftests/net/bind_timewait.c | 92 +++++++++++++++++++++
>  2 files changed, 93 insertions(+)
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
> index 000000000000..cb9fdf51ea59
> --- /dev/null
> +++ b/tools/testing/selftests/net/bind_timewait.c
> @@ -0,0 +1,92 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Amazon.com Inc. or its affiliates. */
> +
> +#include <sys/socket.h>
> +#include <netinet/in.h>
> +
> +#include "../kselftest_harness.h"
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
