Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C1452C84F
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiESAEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiESAEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:04:30 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1972569CF7;
        Wed, 18 May 2022 17:04:29 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p74so520025iod.8;
        Wed, 18 May 2022 17:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jyWLC75GTM+OTHBExj7bBZUgP6zoR7HVZUA3rF/6LlI=;
        b=ppAayLSgcNevwTq4JdA4LlNNtyQpBQ0oT0MQUE7It1ss0AUS9RKTpPTQOa7CF4rSjd
         Ejuf3FywE0soKmdyplCOwow6Mu9fakjkhDX/VlY/hpCxMNp5XnSVUoLUIpMIpvaAej1N
         hHt6cmBDsRe2qUZO/d1wmEXqtliGj8n1XfY1PXSTF5sG+dUl2EXLel1S/scILOEVu4m+
         sGkGRtwMJdSe8X3ZtJK4JPNmqorzkc3cIsqQQrgUFd6rN65m0svo64FjUZQeShMdO36R
         pZI9MPxL4fqpd2P9rnSq81iX5X1dSl6kUhOPTQDE6eDkAQKf0lFTIpeQO+s8Z/YCFEMn
         eGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jyWLC75GTM+OTHBExj7bBZUgP6zoR7HVZUA3rF/6LlI=;
        b=VI/hFrbFyGxt4IrLM6bUxnkfjQxzQ4XnEXtHglgXKf94GS+cKwgAOZ1DLIPu9ZxRdw
         LofAfkmlXFyCv+JGhUSahLikn2PjviWgcqYIZqwaFLaV+BAUYTM5+LxTuvqcZOaByDcN
         tiIfJiISePpZlDqIdm77x5kzx/rLvB0zBogzkiCuKD7xTBvbkx3Zv2rtP6oQo0qNT4Kh
         chm95ixEgMMownZB5VfZ/RaB49DnjtijCqWvLBPlHu6F1Sfni4hiu+Miq7iK5bU1yw1O
         yMuNN59MShnGOAsn8EiiW81WfSWR/cBcSa6DK1fHVOCvRgTQFTkamwJF6U0Ea1MweiLa
         RUBA==
X-Gm-Message-State: AOAM532RbdVoHhxh5fO7xsT24A8uO6Ls3F3SKHlOYdevHSGkFb9TRPmp
        FGKw+k0vUxf5PW2CZrg1H672Stcv8KaGjPd/o8u0j3BlDEw=
X-Google-Smtp-Source: ABdhPJxuxwX+Xic8wOUNmzSxm9GLSXsVqqKfAcXWhsKGK/I6cqAIOtENm9E/PsbarQNFvm0zvAgR99uHvCvTmfkJGgk=
X-Received: by 2002:a05:6638:468e:b0:32b:fe5f:d73f with SMTP id
 bq14-20020a056638468e00b0032bfe5fd73fmr1209492jab.234.1652918668509; Wed, 18
 May 2022 17:04:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220515063120.526063-1-ytcoode@gmail.com>
In-Reply-To: <20220515063120.526063-1-ytcoode@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 May 2022 17:04:16 -0700
Message-ID: <CAEf4BzYr+RZ8A00Yn=Pamt6bk-AmoMyjUHxosgJmrTjkYMhShQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Add missing trampoline program
 type to trampoline_count test
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kui-Feng Lee <kuifeng@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Sat, May 14, 2022 at 11:31 PM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> Currently the trampoline_count test doesn't include any fmod_ret bpf
> programs, fix it to make the test cover all possible trampoline program
> types.
>
> Since fmod_ret bpf programs can't be attached to __set_task_comm function,
> as it's neither whitelisted for error injection nor a security hook, change
> it to bpf_modify_return_test.
>
> This patch also does some other cleanups such as removing duplicate code,
> dropping inconsistent comments, etc.
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  include/linux/bpf.h                           |   2 +-
>  .../bpf/prog_tests/trampoline_count.c         | 121 ++++++------------
>  .../bpf/progs/test_trampoline_count.c         |  16 ++-
>  3 files changed, 47 insertions(+), 92 deletions(-)
>

[...]

>
>         /* with E2BIG error */
> -       ASSERT_EQ(err, -E2BIG, "proper error check");
> +       ASSERT_EQ(libbpf_get_error(link), -E2BIG, "E2BIG");
>         ASSERT_EQ(link, NULL, "ptr_is_null");
>
> -       /* and finaly execute the probe */
> -       if (CHECK_FAIL(prctl(PR_GET_NAME, comm, 0L, 0L, 0L)))
> -               goto cleanup_extra;
> -       CHECK_FAIL(test_task_rename());

we stopped testing that kernel function actually can be called
properly, why don't you do bpf_prog_test_run() here to trigger
bpf_modify_return_test in kernel?

> -       CHECK_FAIL(prctl(PR_SET_NAME, comm, 0L, 0L, 0L));
> -
> -cleanup_extra:
> -       bpf_object__close(obj);
>  cleanup:
> -       if (i >= MAX_TRAMP_PROGS)
> -               i = MAX_TRAMP_PROGS - 1;
>         for (; i >= 0; i--) {
> -               bpf_link__destroy(inst[i].link_fentry);
> -               bpf_link__destroy(inst[i].link_fexit);
> +               bpf_link__destroy(inst[i].link);
>                 bpf_object__close(inst[i].obj);
>         }
>  }

[...]
