Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3ED4D688A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 19:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350958AbiCKSjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 13:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240230AbiCKSjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 13:39:48 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05C45F8EB;
        Fri, 11 Mar 2022 10:38:42 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id b16so11146388ioz.3;
        Fri, 11 Mar 2022 10:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WFI9p5E2R1wq2NWvgYHqRIb+Zo5MSuZDRoBWnSp8cC0=;
        b=Hz3qF2Jc/oDqlPTyODeX6aJQMsymr4mAoQa/4iAsl+s+AcF7H76WTBaUcvqqHezecW
         Caq83ucTlRONEvHL6A75juWpGkNRjv+7NosLvVgx1Nl2iORThEFQxIN7kKR9QEvz60WL
         ogrT0hc9l+uc2i7OIhyA/mZqv2G9Ztpk9n/ru+8TXm8uFCkk58VYqlVaeNRh0DVdX0ep
         79Gg+qviEwPZHp3ezLtIZSDB+6qicFDbmpHraRxEprWl8R9pCxayyL8Z8ie67DYsxMjh
         O16+Gi5uMiQc5BGr2z06DFg60HsziOkdOvgXL582mcqkh4XZ2o2IWgKYB/4uD5nOInfC
         5Z7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WFI9p5E2R1wq2NWvgYHqRIb+Zo5MSuZDRoBWnSp8cC0=;
        b=rDjWE3tbitOA6MIH8sjY6329LnnEjGqoyDz6neGHZ9AxUHeT80/uKlIf+bjhBhohp7
         0UwFalgu6cQMzq8f02WgMGtIXr3WSVY8PkCwaWMJ3J5iY7iWPFuWPuYGGOW8uUghdjq7
         GUZRlumQ0ZM+XvyLiZO5PVPZ6n/aBB2dByt9Bi4car6qMfEgLAco5covyW+vzup6MoTY
         oc1B0eaYSRKq/CgoSozpVCwnLfAyA/L1JNWWybBgoW8aeJXymJrzQXilFYng2YjKO5mk
         v6b8mo7IWjn725VXIo+rTOVn3rIreQ58azHqzXUWqUveRsEY/oxLqd+WyykKuTI35yXw
         ZerA==
X-Gm-Message-State: AOAM532S/mLYJWgWRr4UViaUCWMvf2Y3u8DZANRYWY30wwJFr9OtBuiW
        5g7Ug0C00TlZUwGXOh/iTyf3Xs92uwlzJ+ovfrs=
X-Google-Smtp-Source: ABdhPJwbmX1TybktyboJLuwffG7A5SMbgfzBhvnTrqO+0vKlPqtv7HOCxy6lefykP99jsDVGZTzRSIQr9pZc5Ok9EDY=
X-Received: by 2002:a02:c00e:0:b0:317:c548:97c with SMTP id
 y14-20020a02c00e000000b00317c548097cmr9696778jai.234.1647023922364; Fri, 11
 Mar 2022 10:38:42 -0800 (PST)
MIME-Version: 1.0
References: <b01130f4-0f9c-9fe4-639b-0dcece4ca09a@iogearbox.net> <20220309033518.1743-1-guozhengkui@vivo.com>
In-Reply-To: <20220309033518.1743-1-guozhengkui@vivo.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Mar 2022 10:38:31 -0800
Message-ID: <CAEf4BzY0F3g8oH7+u14DTs707STVSCi8j=A5_S=hn6VRXHzzXg@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/bpf: fix array_size.cocci warning
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Christy Lee <christylee@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Delyan Kratunov <delyank@fb.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        zhengkui_guo@outlook.com
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

On Tue, Mar 8, 2022 at 7:36 PM Guo Zhengkui <guozhengkui@vivo.com> wrote:
>
> Fix the array_size.cocci warning in tools/testing/selftests/bpf/
>
> Use `ARRAY_SIZE(arr)` in bpf_util.h instead of forms like
> `sizeof(arr)/sizeof(arr[0])`.
>
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>  .../selftests/bpf/prog_tests/cgroup_attach_autodetach.c     | 2 +-
>  .../testing/selftests/bpf/prog_tests/cgroup_attach_multi.c  | 2 +-
>  .../selftests/bpf/prog_tests/cgroup_attach_override.c       | 2 +-
>  tools/testing/selftests/bpf/prog_tests/global_data.c        | 6 +++---
>  tools/testing/selftests/bpf/prog_tests/obj_name.c           | 2 +-
>  tools/testing/selftests/bpf/progs/syscall.c                 | 3 ++-
>  tools/testing/selftests/bpf/progs/test_rdonly_maps.c        | 3 ++-
>  tools/testing/selftests/bpf/test_cgroup_storage.c           | 2 +-
>  tools/testing/selftests/bpf/test_lru_map.c                  | 4 ++--
>  tools/testing/selftests/bpf/test_sock_addr.c                | 6 +++---
>  tools/testing/selftests/bpf/test_sockmap.c                  | 4 ++--
>  11 files changed, 19 insertions(+), 17 deletions(-)
>

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
> index fc8e8a34a3db..a500f2c15970 100644
> --- a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
> +++ b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
> @@ -3,6 +3,7 @@
>
>  #include <linux/ptrace.h>
>  #include <linux/bpf.h>
> +#include <bpf_util.h>

bpf_util.h isn't supposed to be included from BPF source code side. Is
this ARRAY_SIZE() use so important for BPF programs? Maybe just leave
existing code under progs/*.c as is?

>  #include <bpf/bpf_helpers.h>
>
>  const struct {
> @@ -64,7 +65,7 @@ int full_loop(struct pt_regs *ctx)
>  {
>         /* prevent compiler to optimize everything out */
>         unsigned * volatile p = (void *)&rdonly_values.a;
> -       int i = sizeof(rdonly_values.a) / sizeof(rdonly_values.a[0]);
> +       int i = ARRAY_SIZE(rdonly_values.a);
>         unsigned iters = 0, sum = 0;
>
>         /* validate verifier can allow full loop as well */

[...]
