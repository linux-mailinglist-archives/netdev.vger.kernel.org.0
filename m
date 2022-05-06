Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F4A51E1DB
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444749AbiEFWcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiEFWcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:32:46 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99C33FDAB;
        Fri,  6 May 2022 15:29:01 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id h11so5674157ila.5;
        Fri, 06 May 2022 15:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zwndxwZpt7KSFoHB/JllAwgCIQTy+eDrSST89tNr+rw=;
        b=ZpTIt5r3YNWAFCPuKwEPGE1ECe/A6pVYLXW7cHkPiOfdva23H2S1bFvkci9mZvoXaJ
         Kj1N5XAuIQ+zAqmhgMDfoZXgfrZApaETBzC6i0GE8C3cQPu5m761+iVctsMTxYtftuKs
         6Q5MYuuSa9aB+JvGdmDlNqka3JEJ2LBi6zwlY3U7agZj0t8P5g66ZetDF3noo9bVL5t2
         rVa7ukJXMAI3MYojV6HR23NOCfz00F9HhsrpV3RKu2C+mf/FpPR4aJ8jp2NuzOmJ90M/
         Udy9wBY6k0dYtfzFh7EQB9DtSSqUeBCi9OeOqeHfYtRTuPx5PF4gpQ0Qc/qas0ccmTRW
         3rbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zwndxwZpt7KSFoHB/JllAwgCIQTy+eDrSST89tNr+rw=;
        b=Hpu1VrfaON9JhzvzlCrlQaU1GCo0TmGG+kDdyzj/uNHm0oM6aZ3Pql/YzeEfq1tI7M
         8ZHT+N/0nlyUAbnc9CQ4cij0hJ05uFwmdzuvm6fLucCicExdA07mLCg58kD/HM38cdKT
         g1grEFjjjLqecjH8UFOLVEVymp2rqRLhQJ4i3is2aqIRrKtpfCKArYMCen8FGmHlXU1N
         HuTDEW2dVEbXla3AjzKczGC2fQcKl5vaWkjXvqYNyhM4Gz/Sx/yBDB1WZhxI/pSTNECF
         4PwyauK50855zSDDFoPWMOGv4wOzYdNGhoKptNlDpKbZDZ3T9/X4qIoRukSqT47wlFM7
         NeCQ==
X-Gm-Message-State: AOAM533X6QWXfX3M+u5bb1kqlrX9osARNoVNYWYonpccg+hYudwZ6jqu
        /8bNijKSzrqS7iALyNT9Ljyjd+BTM9zbfAjxdBQ=
X-Google-Smtp-Source: ABdhPJz0iJf3Bm4SpkdUJSGvP7ctgom6SdZiNH5T/y1ubDp7Y/sx0N5yMMh7WxL0OxCq91+ofkdt0GN+fNf23hGvFXs=
X-Received: by 2002:a92:cd8b:0:b0:2cf:90f9:30e0 with SMTP id
 r11-20020a92cd8b000000b002cf90f930e0mr15562ilb.252.1651876141122; Fri, 06 May
 2022 15:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 May 2022 15:28:50 -0700
Message-ID: <CAEf4BzY3wtCJa5O-k6e1qmJvu5-WBuq5p6=oBJWdCC5tj17LyA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/8] bpf: mptcp: Support for mptcp_sock and is_mptcp
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev
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

On Mon, May 2, 2022 at 2:12 PM Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
> This patch set adds BPF access to the is_mptcp flag in tcp_sock and
> access to mptcp_sock structures, along with associated self tests. You
> may recognize some of the code from earlier
> (https://lore.kernel.org/bpf/20200918121046.190240-6-nicolas.rybowski@tessares.net/)
> but it has been reworked quite a bit.
>
>
> v1 -> v2: Emit BTF type, add func_id checks in verifier.c and bpf_trace.c,
> remove build check for CONFIG_BPF_JIT, add selftest check for CONFIG_MPTCP,
> and add a patch to include CONFIG_IKCONFIG/CONFIG_IKCONFIG_PROC for the
> BPF self tests.
>
> v2 -> v3: Access sysctl through the filesystem to work around CI use of
> the more limited busybox sysctl command.
>
>
> Geliang Tang (6):
>   bpf: add bpf_skc_to_mptcp_sock_proto
>   selftests: bpf: Enable CONFIG_IKCONFIG_PROC in config
>   selftests: bpf: test bpf_skc_to_mptcp_sock
>   selftests: bpf: verify token of struct mptcp_sock
>   selftests: bpf: verify ca_name of struct mptcp_sock
>   selftests: bpf: verify first of struct mptcp_sock
>

It would be nice to use more consistent with the majority of other
commits "selftests/bpf: " prefix. Thank you.

> Nicolas Rybowski (2):
>   bpf: expose is_mptcp flag to bpf_tcp_sock
>   selftests: bpf: add MPTCP test base
>
>  MAINTAINERS                                   |   2 +
>  include/linux/bpf.h                           |   1 +
>  include/linux/btf_ids.h                       |   3 +-
>  include/net/mptcp.h                           |   6 +
>  include/uapi/linux/bpf.h                      |   8 +
>  kernel/bpf/verifier.c                         |   1 +
>  kernel/trace/bpf_trace.c                      |   2 +
>  net/core/filter.c                             |  27 +-
>  net/mptcp/Makefile                            |   2 +
>  net/mptcp/bpf.c                               |  22 ++
>  scripts/bpf_doc.py                            |   2 +
>  tools/include/uapi/linux/bpf.h                |   8 +
>  .../testing/selftests/bpf/bpf_mptcp_helpers.h |  17 ++
>  tools/testing/selftests/bpf/bpf_tcp_helpers.h |   4 +
>  tools/testing/selftests/bpf/config            |   3 +
>  tools/testing/selftests/bpf/network_helpers.c |  43 ++-
>  tools/testing/selftests/bpf/network_helpers.h |   4 +
>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 272 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/mptcp_sock.c  |  80 ++++++
>  19 files changed, 497 insertions(+), 10 deletions(-)
>  create mode 100644 net/mptcp/bpf.c
>  create mode 100644 tools/testing/selftests/bpf/bpf_mptcp_helpers.h
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
>  create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c
>
>
> base-commit: 20b87e7c29dffcfa3f96f2e99daec84fd46cabdb
> --
> 2.36.0
>
