Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D4D1E29AC
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388641AbgEZSHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgEZSHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 14:07:47 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26374C03E96D;
        Tue, 26 May 2020 11:07:47 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id c12so7033836qtq.11;
        Tue, 26 May 2020 11:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uv8aTyB5ZoyUcR4sXkd9GoRt1JQv4QFxfFGzScsfTwU=;
        b=JiZdgFUELlxZMg6BwS/qz1J7Ph/JyOyDGXekw3tgXGqa2ubHTPf7LbuJ64ThRd9ffG
         FP8D04cV928ZuW5ZKuNcl35DvI7xsGVrSbPJIdvV/wPfWCY5j1h/rNYDVH+UCosEJsSB
         I6E05fFj86iXMKZobRR/zWWa/iStZtsdoNgTuSBA2EyGvvt2I/tHMoQkLAef6t+Rfw2A
         xLbMOzbfKFuZ5tapEuH1HQBfmUnB/wIjUDPa2Z81Ft2om+5bduZfLOXVQHT1eEYs7yJ6
         bGWawrndkM8FeZK1k5950+7LIKfq/m9os3m0+RGblQVYhqmcstjrd5vMclEMfoz5hPdd
         38kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uv8aTyB5ZoyUcR4sXkd9GoRt1JQv4QFxfFGzScsfTwU=;
        b=kwvMdPCNEu1BpnO4U7n7h5L0r71jp9fQHqwE8qi+fxU3w3KQgNdXqOKm0RQWDHr0ID
         /69R64clJ8K6lf91Zc3uOELJsyqCQnrdsu6H58tH4PqSLYpgPyYP7V9rPmTO9XAkGR2G
         anu+W+74b+DXZbDbZDPGb3E54ERKqjuagEEjeXJ9yiqTLfpw/YK2OWjWhnEpZ979u9Wd
         gwyHLr/6vRAEtew9+lgqaUcAEs20Y3yFuvEvbaa8wxCX8cf1Dql7Fu2cA63QixVogSW7
         SIQGp61eRCK+mhQ3af3uwg3y3KywYvFHn43g8MzmkBG3HgLsebLwGWEaPSlALsto99F9
         wkEQ==
X-Gm-Message-State: AOAM530j2cFILOV/9LsGrNaOXJyOACsFXUhPU6ocGfhjxTdDs+VXvg8P
        h2y5eL6n1YL07+THPrBQ6L8C1YzVeRw3WVVXUS8=
X-Google-Smtp-Source: ABdhPJzJeUPaze86huw6U9JHcT2Iq9b1tADvMlgofADewlRfE6P/LmBu89vVa8FpDF1GCNRb6zkzeaRqgf88OA47Z/k=
X-Received: by 2002:ac8:424b:: with SMTP id r11mr4501qtm.171.1590516466348;
 Tue, 26 May 2020 11:07:46 -0700 (PDT)
MIME-Version: 1.0
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
 <159033909665.12355.6166415847337547879.stgit@john-Precision-5820-Tower>
In-Reply-To: <159033909665.12355.6166415847337547879.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 May 2020 11:07:35 -0700
Message-ID: <CAEf4BzbDnQKUqmD4VL_PHPGpA3WbUS3cr0jimNf7NhRcA4ZPpg@mail.gmail.com>
Subject: Re: [bpf-next PATCH v5 4/5] bpf, selftests: add sk_msg helpers load
 and attach test
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 9:51 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> The test itself is not particularly useful but it encodes a common
> pattern we have.
>
> Namely do a sk storage lookup then depending on data here decide if
> we need to do more work or alternatively allow packet to PASS. Then
> if we need to do more work consult task_struct for more information
> about the running task. Finally based on this additional information
> drop or pass the data. In this case the suspicious check is not so
> realisitic but it encodes the general pattern and uses the helpers
> so we test the workflow.
>
> This is a load test to ensure verifier correctly handles this case.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Other than perror and CHECK_FAIL nag below, looks good:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/sockmap_basic.c       |   35 +++++++++++++++
>  .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   47 ++++++++++++++++++++
>  2 files changed, 82 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> index aa43e0b..96e7b7f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> @@ -1,7 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0
>  // Copyright (c) 2020 Cloudflare
> +#include <error.h>
>
>  #include "test_progs.h"
> +#include "test_skmsg_load_helpers.skel.h"
>
>  #define TCP_REPAIR             19      /* TCP sock is under repair right now */
>
> @@ -70,10 +72,43 @@ static void test_sockmap_create_update_free(enum bpf_map_type map_type)
>         close(s);
>  }
>
> +static void test_skmsg_helpers(enum bpf_map_type map_type)
> +{
> +       struct test_skmsg_load_helpers *skel;
> +       int err, map, verdict;
> +
> +       skel = test_skmsg_load_helpers__open_and_load();
> +       if (CHECK_FAIL(!skel)) {
> +               perror("test_skmsg_load_helpers__open_and_load");

All test_progs tests use CHECK() macro to test and emit error message
on error, so no need to do silent CHECK_FAIL() and then perror(). Same
below in few places. I don't think you need to send v6 just for this,
but please follow up with a clean up.

> +               return;
> +       }
> +
> +       verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
> +       map = bpf_map__fd(skel->maps.sock_map);
> +
> +       err = bpf_prog_attach(verdict, map, BPF_SK_MSG_VERDICT, 0);
> +       if (CHECK_FAIL(err)) {
> +               perror("bpf_prog_attach");
> +               goto out;
> +       }
> +
> +       err = bpf_prog_detach2(verdict, map, BPF_SK_MSG_VERDICT);
> +       if (CHECK_FAIL(err)) {
> +               perror("bpf_prog_detach2");
> +               goto out;
> +       }
> +out:
> +       test_skmsg_load_helpers__destroy(skel);
> +}
> +

[...]
