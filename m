Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814B65293BF
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347829AbiEPWrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240965AbiEPWrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:47:46 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00EC40E52;
        Mon, 16 May 2022 15:47:45 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id m6so17618847iob.4;
        Mon, 16 May 2022 15:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iXCsccIRv/oRQ4k5XyZPds/zrCr9HYqlNJkf3+MT3ZU=;
        b=knKjM4jo64KbuqHxsCnj3gpGu9VJneQCaN/SMPJVzUdVIFcgWg83759h0w0wdNO+3B
         U0ZgDckE0iPZK33pREqfzhWhxcrn4DtQM0y5f+Xsn6aDDXBP8alnnVeNB3rXlMeOT8vu
         l0fFvEcDHo82KCMnXpGfh5ebaoGHRrn6cCsYDuJyutcq0QCIgaGbFXaCjxdqz/ynpZqf
         ECZ7fRLV9JcdM50DsAmFeXE3LxGLXyxEDKW8ZyVcAA+B3RgSfSLf9qBMdvky4PaFwILW
         E9sXd5flvwfaGCyVQpdOtxIKwPPR3EIlqHj6NV4widqVc0GMC9dRF3tfjbc0/1gzklgx
         nv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iXCsccIRv/oRQ4k5XyZPds/zrCr9HYqlNJkf3+MT3ZU=;
        b=R6N/xkIqMyXKWTVx6TwHEhSll1MDmZMy2UxJrItKtvKqjBK0PhG7LROoHiyDw4yJFL
         GYlyTt+a4hlJMMvY1/T1Cy6wGj1npoFjKNUoO2/C5dWrydyodrDkMrGZuMmDcUZ8IdZM
         9/sCTsfIeXJdX4yy/F3u7z2edCTINhk2KhXCLw0H/UjQ+pTpd0t+IPBcZfyOFElXTRiC
         nvudDOkLJmQIecyrF47EbJDfrvCfo0s60ODuqoJzT0kQPjZsnyUvZ8fazLN+82FtasP9
         wx4Ago/VSG16YbREyjfxdKs/UW/cqn+8fdnwRmOY4fwm6aijGSHSMwgKpXabzDauXrvf
         Dg+w==
X-Gm-Message-State: AOAM531zs1NgT5Pd6Pcvq8g4fwKZ4SL1TBigUJJxsZNiS9rJMKxWH1df
        qK2TXAgMnce4OiK2uHQUXf6py73p05vEDUGw8Yo=
X-Google-Smtp-Source: ABdhPJzXurvnQTVLbZLmRa1uP13vbh/prUlGz7ViD6y8C0tp2etwbsn1aznZEMOq6h06dLG0px8JjzIx9JhL0kBP7qA=
X-Received: by 2002:a05:6638:468e:b0:32b:fe5f:d73f with SMTP id
 bq14-20020a056638468e00b0032bfe5fd73fmr10707056jab.234.1652741265081; Mon, 16
 May 2022 15:47:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com> <20220513224827.662254-5-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220513224827.662254-5-mathew.j.martineau@linux.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 May 2022 15:47:34 -0700
Message-ID: <CAEf4BzaMz=CR5H=_BXgQ8UfDC6mDawgNbGb5XyYBOBqkkS83Hg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/7] selftests/bpf: test bpf_skc_to_mptcp_sock
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 3:48 PM Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
> From: Geliang Tang <geliang.tang@suse.com>
>
> This patch extends the MPTCP test base, to test the new helper
> bpf_skc_to_mptcp_sock().
>
> Define struct mptcp_sock in bpf_tcp_helpers.h, use bpf_skc_to_mptcp_sock
> to get the msk socket in progs/mptcp_sock.c and store the infos in
> socket_storage_map.
>
> Get the infos from socket_storage_map in prog_tests/mptcp.c. Add a new
> function verify_msk() to verify the infos of MPTCP socket, and rename
> verify_sk() to verify_tsk() to verify TCP socket only.
>
> v2: Add CONFIG_MPTCP check for clearer error messages
> v4:
>  - use ASSERT_* instead of CHECK_FAIL (Andrii)
>  - drop bpf_mptcp_helpers.h (Andrii)
>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  tools/testing/selftests/bpf/bpf_tcp_helpers.h |  5 +++
>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 45 ++++++++++++++-----
>  .../testing/selftests/bpf/progs/mptcp_sock.c  | 23 ++++++++--
>  3 files changed, 58 insertions(+), 15 deletions(-)
>

[...]

> +static int verify_msk(int map_fd, int client_fd)
> +{
> +       char *msg = "MPTCP subflow socket";
> +       int err, cfd = client_fd;
> +       struct mptcp_storage val;
> +
> +       err = bpf_map_lookup_elem(map_fd, &cfd, &val);
> +       if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
> +               return err;
> +
> +       if (val.invoked != 1) {
> +               log_err("%s: unexpected invoked count %d != 1",
> +                       msg, val.invoked);
> +               err++;
> +       }
> +
> +       if (val.is_mptcp != 1) {
> +               log_err("%s: unexpected bpf_tcp_sock.is_mptcp %d != 1",
> +                       msg, val.is_mptcp);
> +               err++;
> +       }

any reason to not use ASSERT_NEQ ?


> +
> +       return err;
> +}
> +
>  static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
>  {
>         int client_fd, prog_fd, map_fd, err;

[...]
