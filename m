Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3954F2A1A35
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 20:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgJaTDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 15:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgJaTDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 15:03:44 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE78C0617A6;
        Sat, 31 Oct 2020 12:03:44 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s24so4119885ioj.13;
        Sat, 31 Oct 2020 12:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4GHoNxmQhaPWtFwzqLY/JXeM6GSL91vQMyOuXtLDKn0=;
        b=EU6NKdOgG4dY0T/NlFWjINfHs2ZMgboVZvgG7heQdH/uhiqs9Luq512YBaKb0L2l9l
         mh0RCIayPhTTMj1mfn28X2as2nK1ss0SARRLl5CMseWUiY/cP9oVdx3n0LdgGm/4F1xw
         MewvPppWRUedjQ0fPsWGtqXkYeLZnCp3bUM9kQzqpaCKs05Fl5NxVRreNvIWro3Qui5o
         xdGCLimwb6zuBhn/9XBAL9HK8Xe/MlBNezbVaskpVoWybdtiSJuVvFiA4y1+6ulalpKH
         KVGaFZ9UCwamW/masUnEsQ6KcnP5nfEpfmSOJAoX1R6jjPOxrq1hXZu1J7CipHZosXDC
         Mj6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4GHoNxmQhaPWtFwzqLY/JXeM6GSL91vQMyOuXtLDKn0=;
        b=Ll2ESduyWxD7+dWXl1XDVp7qzhrV/7GfUDo8R0WVsgDKyNxJeRtJlYpk9wtyCkp5Q0
         0ILqbfNkKmGZ5nX9bhgAJNcV4MIagydnZT5ZK2bH/PV0rPkMiKCxBHlThso2ibsmn6m0
         7l9y4WpzLmVfLona/iZMqR1aj4JVPJFIUSFg+l2nrFY+vZEcSYMu8GrTnLfRSVX6eBr+
         5cTfW6rHRN2U2Zl4rQgsOcP61pInMqraQhhAghX3yX3FJe228BN9P6htZfHaYL3oCYO5
         z9Hb9AFiO8ricqngmwpikdUC+0VwABlJkw64H1Z3ckg0fvg1kTQGwUaQw1YSvnmga0HI
         x5zg==
X-Gm-Message-State: AOAM533L5mPwQoBAWEqGnN0NKDtpvc4nOU7xRIF+4UtzT5QAtcMBqpKM
        whPou2k0kCCgaMQaAp/cv7YRqZa+cFS28FDfM5dRchRD8WU=
X-Google-Smtp-Source: ABdhPJy8DfNfTJsJ+aQVlJOiZG20+C74xUwN+QY9mnlXw6QdU1cVhFiVIaSerHZHFBZ3OnZB3rKAEbvUaw+fPduN6vM=
X-Received: by 2002:a02:1783:: with SMTP id 125mr6371422jah.121.1604171023017;
 Sat, 31 Oct 2020 12:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
In-Reply-To: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 31 Oct 2020 12:03:32 -0700
Message-ID: <CAKgT0Ue+E6krF8=uqXDGDC095_mcDKNB1T2kc+uow3ywk3-RSQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH v2 0/5] selftests/bpf: Migrate test_tcpbpf_user
 to be a part of test_progs framework
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
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

On Sat, Oct 31, 2020 at 11:31 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> Move the test functionality from test_tcpbpf_user into the test_progs
> framework so that it will be run any time the test_progs framework is run.
> This will help to prevent future test escapes as the individual tests, such
> as test_tcpbpf_user, are less likely to be run by developers and CI
> tests.
>
> As a part of moving it over the series goes through and updates the code to
> make use of the existing APIs included in the test_progs framework. This is
> meant to simplify and streamline the test code and avoid duplication of
> effort.
>
> v2: Dropped test_tcpbpf_user from .gitignore
>     Replaced CHECK_FAIL calls with CHECK calls
>     Minimized changes in patch 1 when moving the file
>     Updated stg mail command line to display renames in submission
>     Added shutdown logic to end of run_test function to guarantee close
>     Added patch that replaces the two maps with use of global variables
>
> ---
>
> Alexander Duyck (5):
>       selftests/bpf: Move test_tcppbf_user into test_progs
>       selftests/bpf: Drop python client/server in favor of threads
>       selftests/bpf: Replace EXPECT_EQ with ASSERT_EQ and refactor verify_results
>       selftests/bpf: Migrate tcpbpf_user.c to use BPF skeleton
>       selftest/bpf: Use global variables instead of maps for test_tcpbpf_kern
>
>
>  .../selftests/bpf/prog_tests/tcpbpf_user.c    | 239 +++++++++---------
>  .../selftests/bpf/progs/test_tcpbpf_kern.c    |  86 +------
>  tools/testing/selftests/bpf/tcp_client.py     |  50 ----
>  tools/testing/selftests/bpf/tcp_server.py     |  80 ------
>  tools/testing/selftests/bpf/test_tcpbpf.h     |   2 +
>  5 files changed, 135 insertions(+), 322 deletions(-)
>  delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
>  delete mode 100755 tools/testing/selftests/bpf/tcp_server.py
>
> --

It looks like the "--to" on the cover page was dropped and it wasn't
delivered to the bpf mailing list. So I am just going to reply to the
one that was delivered to netdev so that it is visible for the people
on the bpf list.

Thanks.

- Alex
