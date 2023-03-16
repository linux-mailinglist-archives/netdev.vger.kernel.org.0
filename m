Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BADA6BDA3D
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjCPUen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjCPUeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:34:37 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1532A25E;
        Thu, 16 Mar 2023 13:34:29 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eh3so12470385edb.11;
        Thu, 16 Mar 2023 13:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678998868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQGw4rmImHopv/OtWPakYC5hznOSVQLQps2bkjQMLxY=;
        b=M4As80V5GmS+0/rX5iSuN5ZUK/V9bl+3vO1ySZaWw4JIVlyzbWpIZXeKOnMyTE3mjz
         f0BI1u/cuPSZRF/kAtzpmP9+UIXqMEbXCu31IpLnL9N3nxD5hcwAKOJpFcYySNPlqdyX
         3PjkOX+3WEfzRL9IFdZqUd7K+0IOA6D7nA1U/Sf9QARQBpeeekW5nWvLv03BxZElSoJa
         Gb3d5UMNiovs5c5VufwtgBCJ55B2YTT8ntGwiWDJThhiPfGVvAYw0ZZy7M49hJ/JPD6C
         H9rmxt9rImNfiMFjGGW4yLdpOx1f5X/8qT4YvIsDxCAkqGkeY1uFR/5qgywanpH8KJWC
         y0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678998868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AQGw4rmImHopv/OtWPakYC5hznOSVQLQps2bkjQMLxY=;
        b=7l1TOrPvVPaHlrk5l8/v1HruGk/L22DEVZ3ELhckiNWMLzYG9OG/YnYJV6SEHGjM3C
         BrceGrEBgAXsVclF1n/FppTrxALw34pnveil7Y2o/yiiSiUOMaSzphR2/LIMOYa402KX
         loqBP5uVBcdH4Xfw5tr+Ctq+6pkcOGw9LbxT0wYO5DZCdoY+jeODWsYaYPWjCqkgC0Ve
         RGVeodXvrHYfqt9VfE+rOiF3rI/vm9qb4mauYwLRToUvtvRnn5vSf2lSOLvomeZRBwya
         oNhPEtRhKPOkd6ZpFBDjIyniaEX6qgSKNmcgC9ByvX89kW5SuQqKSfkpJ6ff16xRK0ss
         Stew==
X-Gm-Message-State: AO0yUKVya5uZ0OyVsXC7654HPQbNmBaqtKqJvfFsQIuvZYTKQAS844gM
        UoFMukIg+kVeOiyEE/ei8NXZbvNqrFb8S54hyLw=
X-Google-Smtp-Source: AK7set8aI6iGyNwk5Eczi8w4DESz0HedhKVVb82+qgKGfYbh8V24F5c7oo1E5oRZCBFS6oA9MIYI4Jy4DA+BqRvia+s=
X-Received: by 2002:a17:907:c28:b0:922:26ae:c68c with SMTP id
 ga40-20020a1709070c2800b0092226aec68cmr385268ejc.5.1678998867959; Thu, 16 Mar
 2023 13:34:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com> <20230315223607.50803-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20230315223607.50803-3-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Mar 2023 13:34:12 -0700
Message-ID: <CAEf4BzbrDu_GWWURnf4U=ji_8r6Cnqp-y8ye89xYuV4rTwzz9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Add test for bpf_kfunc_exists().
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 3:36=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Add load and run time test for bpf_kfunc_exists() and check that the veri=
fier
> performs dead code elimination for non-existing kfunc.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

we have prog_tests/ksyms_btf.c and progs/test_ksyms_weak.c which do
these kind of tests for variable ksyms, let's just add kfunc ksyms
there (user-space part has also checking that captured pointer value
is correct and stuff like that, we probably want that for kfuncs as
well)


>  .../selftests/bpf/progs/task_kfunc_success.c       | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/task_kfunc_success.c b/too=
ls/testing/selftests/bpf/progs/task_kfunc_success.c
> index 4f61596b0242..c0a7774e0c79 100644
> --- a/tools/testing/selftests/bpf/progs/task_kfunc_success.c
> +++ b/tools/testing/selftests/bpf/progs/task_kfunc_success.c
> @@ -17,6 +17,8 @@ int err, pid;
>   *         TP_PROTO(struct task_struct *p, u64 clone_flags)
>   */
>
> +void invalid_kfunc(void) __ksym __weak;
> +
>  static bool is_test_kfunc_task(void)
>  {
>         int cur_pid =3D bpf_get_current_pid_tgid() >> 32;
> @@ -26,7 +28,17 @@ static bool is_test_kfunc_task(void)
>
>  static int test_acquire_release(struct task_struct *task)
>  {
> -       struct task_struct *acquired;
> +       struct task_struct *acquired =3D NULL;
> +
> +       if (!bpf_kfunc_exists(bpf_task_acquire)) {
> +               err =3D 3;
> +               return 0;
> +       }
> +       if (bpf_kfunc_exists(invalid_kfunc)) {
> +               /* the verifier's dead code elimination should remove thi=
s */
> +               err =3D 4;
> +               asm volatile ("goto -1"); /* for (;;); */
> +       }
>
>         acquired =3D bpf_task_acquire(task);
>         bpf_task_release(acquired);
> --
> 2.34.1
>
