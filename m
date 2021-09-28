Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB70941BAD1
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhI1XMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243149AbhI1XMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 19:12:17 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D288C06161C;
        Tue, 28 Sep 2021 16:10:37 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v195so722521ybb.0;
        Tue, 28 Sep 2021 16:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LTTs41NWTC6GrLI59f4t0uamvovFDQOj+/8t5xs/580=;
        b=iyAAGK1uyuFNI+ZFyqyVOKY5uTpx8vyfeiftW2ibuC2k+kqhgpEqUNSz/fS8EcMV9Z
         5BKIxhFjbQBWhpgD4CMnWKti4HO1JvmXpyOi9DYy4vSIT9Ofyt1W2n2GBsCpiB+p9fe1
         G+FRxai4apmdgLgSDc2jG71ZgPMJ6StCj3YDq8svNTi2Jq2W9MQrMPWkVVD5KPsmcYHV
         7ytly12Ql9GUIGIynvbHG06w0xjPE+wp1MTR23ysVYLhlJa8qCyVBm+I1C1LbwiOeFNj
         yOxjvXjSr5EvZcV99ZYLQbAHugNV0yi5OJznggz5JWoBIid3Anp42n2JcS3WIUyf7Sdf
         7j0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LTTs41NWTC6GrLI59f4t0uamvovFDQOj+/8t5xs/580=;
        b=Ksaqj+THeNMxy8rkoB7BIwaQ8i15yOupuIsZa5V3IihBC1qV2XY+zkaOi8tpdkl69M
         bnWoWUWzgQJb+ngdQSrF2gTxeVVVGNV2fbSiypyX9jAIcOs66eU202a2F8u4M3I4+Pyo
         wdOz1zdM1S7hxHXnudGFSM4HjRrjLfUn30GLmQeDayVXxhHv8rxjXBPKMKkMNDTae6x3
         urAjZqetvc7zK8fmmpnrV4J7mgLNevuUoH3itiWgGtCgH8OliSE/Yk+ZOBsjHqgW3W12
         vy/xZbteALzmFMub7kZ0qX+vTK+5S5Tg6z4iK6O7GBshTic2Xw1uUbG0+S1RDTZAojsg
         YVCg==
X-Gm-Message-State: AOAM530eLaejw/NNsIeQcvEuzrqpob7q1cqc+ni7QizLi8feJ22urrpX
        43FgFpC5IVAKl2VcaoIy3wbDGyaKw/3LNJmOvmE=
X-Google-Smtp-Source: ABdhPJxJjKXTIgMXnFWlc0qKisgYjwtpOTliTuY0fYLw9UYG8eOCtDK35NHuzbjuSeqK8rvT7cAFhZHKI9RbtXPm9zg=
X-Received: by 2002:a25:7c42:: with SMTP id x63mr10731355ybc.225.1632870636623;
 Tue, 28 Sep 2021 16:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210928140734.1274261-1-houtao1@huawei.com> <20210928140734.1274261-4-houtao1@huawei.com>
In-Reply-To: <20210928140734.1274261-4-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Sep 2021 16:10:25 -0700
Message-ID: <CAEf4BzYAVhSAERpm7bSuFj1M6LLUWyA=T6fuVY3kbJiGMtr=gg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] bpf/selftests: add test for writable bare tracepoint
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 6:53 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Add a writable bare tracepoint in bpf_testmod module, and
> trigger its calling when reading /sys/kernel/bpf_testmod
> with a specific buffer length. The reading will return
> the value in writable context if the early return flag
> is enabled in writable context.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---


LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 ++++++++
>  .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 ++++++
>  .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
>  .../selftests/bpf/prog_tests/module_attach.c  | 35 +++++++++++++++++++
>  .../selftests/bpf/progs/test_module_attach.c  | 14 ++++++++
>  tools/testing/selftests/bpf/test_progs.c      |  4 +--
>  tools/testing/selftests/bpf/test_progs.h      |  2 ++
>  7 files changed, 83 insertions(+), 2 deletions(-)
>

[...]
