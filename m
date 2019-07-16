Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01396ADCC
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 19:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388273AbfGPRmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 13:42:20 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40331 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbfGPRmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 13:42:20 -0400
Received: by mail-qk1-f196.google.com with SMTP id s145so15261072qke.7;
        Tue, 16 Jul 2019 10:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7y+QgkEqpFwROGLd91BAzTcGL5I8aXk7+F49n2OnW+M=;
        b=QTJxiZQpTuf2lzCg2me4N26oI3XwjXbQBnq8OOUF4Ic9XH9AgLzB/aI4gf7YPqU4wf
         x0Bv3KeQkaf8plMvj8a0Cvq0r3TTQkeQw4fz95NdQczcqHeWk51ofbEAQkgqOnHpI24J
         CywApk6pFpWLsQlyc3jqH+qh6WUUj2GkGZRw9hbajrBfrN0NQCGyf7IV+mcjSnfyqCMh
         wkANfcdtn7E7de0DjBl+6nMfY/uU+QIws5yyQgAtqVPDygFQDxK64XkoivrqOaeJIsRp
         7r2HQFcFh/d9KNi6nwQbfRZxA7Rpyl6trIX3lCB2q7oWYSTUf2KeEJiMsQvLyL2pma7C
         fIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7y+QgkEqpFwROGLd91BAzTcGL5I8aXk7+F49n2OnW+M=;
        b=VY090062OdD1fWuGFqtcXv5jtyRfpeFGOfjj48Wk07WdW88dTnMSPBz8QDtZ5jK7nf
         09KYaldf7BvPotO1nif369AscbGE7qq9DJhJYVJPS3DXl5RQsY1THaTThsCo4GLMbysh
         z45wL4C8wkWpLp5LxBkZx7kJyj0DXjQsbljWVD7Co441aEMiqWuzK+GjYjmvwzKT6uPC
         VfAC2JY6k3gRCy5ZN1zsIBT/DolybYivEW5edvHwsWkZ0PlwdKcc4fEQZ7RxPQSZHtqT
         h06hHLybxYX4UHMoOYDyckC9tfXYQoNhTcSA61h2t1jN3O+mzqxct1hDdhVpA9JaOnUd
         wlhg==
X-Gm-Message-State: APjAAAXg42PvNW6VTGnw2HQIaeHGPT6KHjXmof65Z4dQDZXX0D1uQ96Z
        uDa/X2H6KKF+bamLNwakE2LaCsflyVeP0ZYAESMQbeHLw9qU0w==
X-Google-Smtp-Source: APXvYqysF5ZUOBtuRHcpzX+nPjm8fcC64Kf/NJtmf2Mb6AWi7Vom1l0PN7AJ2S1nMP/Sz1scO2zM8zNLzVS7MbkVNEs=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr23133635qkf.437.1563298938932;
 Tue, 16 Jul 2019 10:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190716125827.24413-1-iii@linux.ibm.com>
In-Reply-To: <20190716125827.24413-1-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Jul 2019 10:42:07 -0700
Message-ID: <CAEf4BzbWVJcQ2pN9UwYagtBpgoL+8Q+DMwwiUt1iCMciH8YUKA@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix perf_buffer on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 5:59 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> perf_buffer test fails for exactly the same reason test_attach_probe
> used to fail: different nanosleep syscall kprobe name.
>
> Reuse the test_attach_probe fix.
>
> Fixes: ee5cf82ce04a ("selftests/bpf: test perf buffer API")
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---

Thanks for the fix!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../testing/selftests/bpf/prog_tests/attach_probe.c  | 12 ++----------
>  tools/testing/selftests/bpf/prog_tests/perf_buffer.c |  8 +-------
>  tools/testing/selftests/bpf/test_progs.h             |  8 ++++++++
>  3 files changed, 11 insertions(+), 17 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> index 47af4afc5013..5ecc267d98b0 100644
> --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> @@ -21,14 +21,6 @@ ssize_t get_base_addr() {
>         return -EINVAL;
>  }
>
> -#ifdef __x86_64__
> -#define SYS_KPROBE_NAME "__x64_sys_nanosleep"
> -#elif defined(__s390x__)
> -#define SYS_KPROBE_NAME "__s390x_sys_nanosleep"
> -#else
> -#define SYS_KPROBE_NAME "sys_nanosleep"
> -#endif
> -
>  void test_attach_probe(void)
>  {
>         const char *kprobe_name = "kprobe/sys_nanosleep";
> @@ -86,7 +78,7 @@ void test_attach_probe(void)
>
>         kprobe_link = bpf_program__attach_kprobe(kprobe_prog,
>                                                  false /* retprobe */,
> -                                                SYS_KPROBE_NAME);
> +                                                SYS_NANOSLEEP_KPROBE_NAME);
>         if (CHECK(IS_ERR(kprobe_link), "attach_kprobe",
>                   "err %ld\n", PTR_ERR(kprobe_link))) {
>                 kprobe_link = NULL;
> @@ -94,7 +86,7 @@ void test_attach_probe(void)
>         }
>         kretprobe_link = bpf_program__attach_kprobe(kretprobe_prog,
>                                                     true /* retprobe */,
> -                                                   SYS_KPROBE_NAME);
> +                                                   SYS_NANOSLEEP_KPROBE_NAME);
>         if (CHECK(IS_ERR(kretprobe_link), "attach_kretprobe",
>                   "err %ld\n", PTR_ERR(kretprobe_link))) {
>                 kretprobe_link = NULL;
> diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> index 3f1ef95865ff..3003fddc0613 100644
> --- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> +++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> @@ -5,12 +5,6 @@
>  #include <sys/socket.h>
>  #include <test_progs.h>
>
> -#ifdef __x86_64__
> -#define SYS_KPROBE_NAME "__x64_sys_nanosleep"
> -#else
> -#define SYS_KPROBE_NAME "sys_nanosleep"
> -#endif
> -
>  static void on_sample(void *ctx, int cpu, void *data, __u32 size)
>  {
>         int cpu_data = *(int *)data, duration = 0;
> @@ -56,7 +50,7 @@ void test_perf_buffer(void)
>
>         /* attach kprobe */
>         link = bpf_program__attach_kprobe(prog, false /* retprobe */,
> -                                         SYS_KPROBE_NAME);
> +                                         SYS_NANOSLEEP_KPROBE_NAME);
>         if (CHECK(IS_ERR(link), "attach_kprobe", "err %ld\n", PTR_ERR(link)))
>                 goto out_close;
>
> diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> index f095e1d4c657..49e0f7d85643 100644
> --- a/tools/testing/selftests/bpf/test_progs.h
> +++ b/tools/testing/selftests/bpf/test_progs.h
> @@ -92,3 +92,11 @@ int compare_map_keys(int map1_fd, int map2_fd);
>  int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len);
>  int extract_build_id(char *build_id, size_t size);
>  void *spin_lock_thread(void *arg);
> +
> +#ifdef __x86_64__
> +#define SYS_NANOSLEEP_KPROBE_NAME "__x64_sys_nanosleep"
> +#elif defined(__s390x__)
> +#define SYS_NANOSLEEP_KPROBE_NAME "__s390x_sys_nanosleep"
> +#else
> +#define SYS_NANOSLEEP_KPROBE_NAME "sys_nanosleep"
> +#endif
> --
> 2.21.0
>
