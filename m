Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEDA682E23
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjAaNkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjAaNkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:40:19 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E8E45BDF
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:40:17 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5063029246dso203234427b3.6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sRjRWg8BiQAEYzHJmfFWEdLhQevP1X8g61dDqXlCDRs=;
        b=qOPmkLs0bRQhDaSbiljSJs1LVLsoqJaRtnm/hX/HRxFRYP0Xbzee0a9304zOqaA95W
         yO+bdzHm5XpkKPWWmafdW1iLpl6CSW7Mb/6LGxsgMQT6wp/b0LrCQMv95BBYJhHDEBsM
         WaZGJZ9g3x6RQpM4vSmGXYMasP4xouYhqE6vZChrpXKv/x32Cs+Ntq9c5aPQqSt5LPel
         lKEB5XGsUWsekEhgYqR2oJiqbZa7Pu0bPIqIkl2Y/J5WgPbczsNDAZ53xThkHMFllVT2
         ymelqxZeyQi8x7nU2R9z0ZSTT1mbXdRB0xYvp255LT2OUZIN9Pzd4OuP1e2MoXn6mNqF
         CMYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sRjRWg8BiQAEYzHJmfFWEdLhQevP1X8g61dDqXlCDRs=;
        b=vjQAjic60RA/JDd4hxBDDLQPZbHLQWxjHbgQTt0ECfEdIwUnOGG6PScERqulGmk+eP
         Vds8g6pmR99pNmUrScVv6f4m1kFSEjphpn1o4UWd4YE0eeUyTa18oocH2coC2Lf5KzVQ
         JdhEQoAW3dGnS3mhRd1Wlvb7VcCr8+m9OMF/hDME7B5OmDn6S77Fhi0JAH2UDAeMtQQk
         7IRX4qoiuynlWR1c/59B4dgy86TyIsdCLjYneqm5phE6sktD6w5K1hR7mZxTaj13FPA5
         rLEo1ohc+svYfrQgfL0Ge37mB/EERWjximpAJ9VlTzRJradSrPdJoDj53q2IexgTvxeb
         3N4A==
X-Gm-Message-State: AFqh2krmQ8s5pJ8us2EWvqUBkQYsBFGLWlsuxAxX/liKtC5b7b0nAlCw
        CcF8iDHPiV0YKL7lJtAACfTvw9xPG7rNgGAwO1AA9g==
X-Google-Smtp-Source: AMrXdXs6226+aucJHF/vmsL+nYravuFR4DnXiJdO+R2xk1tGeCiukdkkus6Y//joZTkadUNrLACyc3K7jy7G5YNrhX0=
X-Received: by 2002:a81:4d57:0:b0:4fe:8e35:3c89 with SMTP id
 a84-20020a814d57000000b004fe8e353c89mr4242770ywb.287.1675172416850; Tue, 31
 Jan 2023 05:40:16 -0800 (PST)
MIME-Version: 1.0
References: <20230131130412.432549-1-andrei.gherzan@canonical.com> <20230131130412.432549-4-andrei.gherzan@canonical.com>
In-Reply-To: <20230131130412.432549-4-andrei.gherzan@canonical.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Tue, 31 Jan 2023 08:39:40 -0500
Message-ID: <CA+FuTSe-C+rOx+zUYzhGCm24hnBXUNpAM5iUqf4shVNEL6niSQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] selftests: net: udpgso_bench_tx: Cater for pending
 datagrams zerocopy benchmarking
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 8:06 AM Andrei Gherzan
<andrei.gherzan@canonical.com> wrote:
>
> The test tool can check that the zerocopy number of completions value is
> valid taking into consideration the number of datagram send calls. This can
> catch the system into a state where the datagrams are still in the system
> (for example in a qdisk, waiting for the network interface to return a
> completion notification, etc).
>
> This change adds a retry logic of computing the number of completions up to
> a configurable (via CLI) timeout (default: 2 seconds).
>
> Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> ---
>  tools/testing/selftests/net/udpgso_bench_tx.c | 38 +++++++++++++++----
>  1 file changed, 30 insertions(+), 8 deletions(-)
>
> diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
> index b47b5c32039f..5a29b5f24023 100644
> --- a/tools/testing/selftests/net/udpgso_bench_tx.c
> +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
> @@ -62,6 +62,7 @@ static int    cfg_payload_len = (1472 * 42);
>  static int     cfg_port        = 8000;
>  static int     cfg_runtime_ms  = -1;
>  static bool    cfg_poll;
> +static int     cfg_poll_loop_timeout_ms = 2000;
>  static bool    cfg_segment;
>  static bool    cfg_sendmmsg;
>  static bool    cfg_tcp;
> @@ -235,16 +236,17 @@ static void flush_errqueue_recv(int fd)
>         }
>  }
>
> -static void flush_errqueue(int fd, const bool do_poll)
> +static void flush_errqueue(int fd, const bool do_poll,
> +               unsigned long poll_timeout, const bool poll_err)
>  {
>         if (do_poll) {
>                 struct pollfd fds = {0};
>                 int ret;
>
>                 fds.fd = fd;
> -               ret = poll(&fds, 1, 500);
> +               ret = poll(&fds, 1, poll_timeout);
>                 if (ret == 0) {
> -                       if (cfg_verbose)
> +                       if ((cfg_verbose) && (poll_err))
>                                 fprintf(stderr, "poll timeout\n");
>                 } else if (ret < 0) {
>                         error(1, errno, "poll");
> @@ -254,6 +256,22 @@ static void flush_errqueue(int fd, const bool do_poll)
>         flush_errqueue_recv(fd);
>  }
>
> +static void flush_errqueue_retry(int fd, const bool do_poll, unsigned long num_sends)
> +{
> +       unsigned long tnow, tstop;
> +       bool first_try = true;
> +
> +       tnow = gettimeofday_ms();
> +       tstop = tnow + cfg_poll_loop_timeout_ms;
> +       do {
> +               flush_errqueue(fd, do_poll, tstop - tnow, first_try);
> +               first_try = false;
> +               if (!do_poll)
> +                       usleep(1000);  // a throttling delay if polling is enabled

never reached
