Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC7F3F6BAB
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 00:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238805AbhHXWU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 18:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhHXWU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 18:20:58 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5F2C061757;
        Tue, 24 Aug 2021 15:20:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so2796925pjb.3;
        Tue, 24 Aug 2021 15:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1s9ly3AV9m2sRQyA6TMhsemhhhr5uERchfWnHFSTqgA=;
        b=Ki9v+Tp4RIF7iikzg3iQbG3QTaAwPJlx3zzBojiVvHlkB5nfPNFlfS46mJQQtnRD3f
         k0564Qehjv+G9AoGHKgVxPyOsDb8JhyrlokVeAUxZfTJX2Z0/JHEkbnyExH1iwQIzQ7H
         byFHt/qGU3zB94C/xkXkNGLfBUp3Lu3aY4oBxCsCGH3JLwOELK8ZEFsIC9gx0lvbmXWV
         0kzLNSpC/xCar5DCMkar1iCfkFDvpzGBvhVX20/BPeD9XJb4bZg1XLI4nI0d5E6ZFBIa
         8maWcjxpv4OfulRnyZxAK8yfbiD2W7b8kzQpHsxYpXKSIEDHZbkh1la2YqKc9ckZSdF5
         PLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1s9ly3AV9m2sRQyA6TMhsemhhhr5uERchfWnHFSTqgA=;
        b=D7NaZLYHnRmig9X7H/MPEJFIJRFOedros0cRHE4HZvNdlyjZCthQvXJ2kCUWn0f1ds
         N6lh99xPezizpYQP0odoWXyO2wPRXW/jazWDXdPOgz7mlQKNDSA2KHXV+R9XwIujkFVC
         FSJcIV1i0uTw8B7mh61YI2GdLe4I6f9303uJWH8B15GuAcHTqcb340Tkyj9PgEmiQIhA
         b+iS8TtlMn438PPT3hoKc+hfVKFLn+plyFWF5ESmVrDKWO+DzWxB3Rxs1TyCGcNYNsen
         0jXDdqOolmurnlgVcIsjUuImPfykVTDqa3fmMRaOBaEHGrFi2ttKNYMtj0K7VmeVy2By
         Sbvg==
X-Gm-Message-State: AOAM5323oFdSJkDbm5CN8iObECUSr+lPxTxlNoX7c6OqjpFChSGwbkyL
        Qxw5ICYGr7kdKHFfqz9qRT7D11oWJR5RGlXNkdo=
X-Google-Smtp-Source: ABdhPJy+kCY+EPQ37dj9B65wo0j6R/RKHeuhQ5zltSOAySKaXM84O05Qi2NEPAQWMgttBIuAMsHrCTr58A3cKFzkEcg=
X-Received: by 2002:a17:902:8c90:b0:12f:699b:27 with SMTP id
 t16-20020a1709028c9000b0012f699b0027mr28777516plo.28.1629843613701; Tue, 24
 Aug 2021 15:20:13 -0700 (PDT)
MIME-Version: 1.0
References: <1629774050-4048-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1629774050-4048-1-git-send-email-yangtiezhu@loongson.cn>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 24 Aug 2021 15:20:02 -0700
Message-ID: <CAADnVQJ7P-pH8punF1nw5KHhb15AJND-vQ_gK3s87hAJ1HN59A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: test_bpf: Print total time of test in
 the summary
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 8:00 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> The total time of test is useful to compare the performance
> when bpf_jit_enable is 0 or 1, so print it in the summary.
>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  lib/test_bpf.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index 830a18e..37f49b7 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -8627,9 +8627,10 @@ static int __run_one(const struct bpf_prog *fp, const void *data,
>         return ret;
>  }
>
> -static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
> +static int run_one(const struct bpf_prog *fp, struct bpf_test *test, u64 *run_one_time)
>  {
>         int err_cnt = 0, i, runs = MAX_TESTRUNS;
> +       u64 time = 0;
>
>         for (i = 0; i < MAX_SUBTESTS; i++) {
>                 void *data;
> @@ -8663,8 +8664,12 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
>                                 test->test[i].result);
>                         err_cnt++;
>                 }
> +
> +               time += duration;
>         }
>
> +       *run_one_time = time;
> +
>         return err_cnt;
>  }
>
> @@ -8944,9 +8949,11 @@ static __init int test_bpf(void)
>  {
>         int i, err_cnt = 0, pass_cnt = 0;
>         int jit_cnt = 0, run_cnt = 0;
> +       u64 total_time = 0;
>
>         for (i = 0; i < ARRAY_SIZE(tests); i++) {
>                 struct bpf_prog *fp;
> +               u64 run_one_time;
>                 int err;
>
>                 cond_resched();
> @@ -8971,7 +8978,7 @@ static __init int test_bpf(void)
>                 if (fp->jited)
>                         jit_cnt++;
>
> -               err = run_one(fp, &tests[i]);
> +               err = run_one(fp, &tests[i], &run_one_time);
>                 release_filter(fp, i);
>
>                 if (err) {
> @@ -8981,10 +8988,12 @@ static __init int test_bpf(void)
>                         pr_cont("PASS\n");
>                         pass_cnt++;
>                 }
> +
> +               total_time += run_one_time;
>         }
>
> -       pr_info("Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed]\n",
> -               pass_cnt, err_cnt, jit_cnt, run_cnt);
> +       pr_info("Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed] in %llu nsec\n",
> +               pass_cnt, err_cnt, jit_cnt, run_cnt, total_time);
>
>         return err_cnt ? -EINVAL : 0;
>  }
> @@ -9192,6 +9201,7 @@ static __init int test_tail_calls(struct bpf_array *progs)
>  {
>         int i, err_cnt = 0, pass_cnt = 0;
>         int jit_cnt = 0, run_cnt = 0;
> +       u64 total_time = 0;
>
>         for (i = 0; i < ARRAY_SIZE(tail_call_tests); i++) {
>                 struct tail_call_test *test = &tail_call_tests[i];
> @@ -9220,10 +9230,12 @@ static __init int test_tail_calls(struct bpf_array *progs)
>                         pr_cont("ret %d != %d FAIL", ret, test->result);
>                         err_cnt++;
>                 }
> +
> +               total_time += duration;
>         }
>
> -       pr_info("%s: Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed]\n",
> -               __func__, pass_cnt, err_cnt, jit_cnt, run_cnt);
> +       pr_info("%s: Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed] in %llu nsec\n",
> +               __func__, pass_cnt, err_cnt, jit_cnt, run_cnt, total_time);

I think it only adds noise. Pls use dedicated runners like selftests/bpf/bench
for performance measurements. test_bpf.ko also does some.
