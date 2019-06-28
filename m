Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD615A5B1
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfF1UJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:09:42 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46880 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfF1UJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:09:41 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so7712004qtn.13;
        Fri, 28 Jun 2019 13:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mknOAEnYhfN5QJU+yoNgquD/0lsk0c9w2PFQyJpC7u0=;
        b=DTWxCTupO7POCcIduaipHPjBpi1BefPCDQReZ6LbulKRIMoxXWSVtr8F6i/Pkp3qca
         3nPRI0etvuZCU65/FuK/YYGRvR4q+DWDoXqxBa8E/Yj+eR1BCGn0aGtFw2AK3jOL5u0h
         WilWcEK6Jat0Z2EormH8zWwY0QOgdwwG8jJvR7BHeb4IZyk0iK4YZFkiu7qtO4KKH5zc
         rreU4wjFfzj9Ohuovy9SZh9NBHVwrErYMIUWlY+GdbtFGddyscvNBp6bNRfUIDrdhNS5
         p5gUol0J5L+UlY5LMLvCfZwILrxn8tcCjCQb7maTKAaFuC2/QEb24WdZBHx5hCIZ2NrY
         Y5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mknOAEnYhfN5QJU+yoNgquD/0lsk0c9w2PFQyJpC7u0=;
        b=UJogI2DxmBRo7Uif3uRQilhuEx3PTtYcEcXRq2TyDCVLuR1s7wzHGN+YBnVjPtmsZT
         97y1mykJmfgMhO4KtOWu08OqmManIWF0Va6/taSWNGvH+QgIz0o5Eq82nxaqoEYNb/mg
         DQXSAKV7zyOVaq/YwI/b1y+88EiSfXqzt1ptzkNcf2PiKbKhROT28XBa1dmVw8/cNQ+K
         7krtPrUUC0A5uchvYeAvwC3ASJ+P4zjNlj8xrgj5aHh8qxMYZkUBX7/oJ20E4a9v1Wlt
         9y3a9eOP8JhMlJhcCtgbAPwYApOcxBA9Uzmn2DhxpmJ5XPD/ctGuiH8cmCG266NoOt4B
         VxtA==
X-Gm-Message-State: APjAAAWz/koMIT0qCVi6phHldh+abP8hIPEgTsnUMLj/Z2h9F7vAkIDA
        mIPBOOU573TZ6dk4NhxDAMll2hctKKu9QbHorMVwKeBd
X-Google-Smtp-Source: APXvYqwzkm7ZjoLAOIXqhEC65tkdQvolc73xNCLdfE6w4SziLwIQAEfO0rstS6cZUT7mvOmz03yXWZEy3JjF2X5H5r8=
X-Received: by 2002:aed:3b66:: with SMTP id q35mr9957324qte.118.1561752580907;
 Fri, 28 Jun 2019 13:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-8-andriin@fb.com>
In-Reply-To: <20190628055303.1249758-8-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 13:09:30 -0700
Message-ID: <CAPhsuW4BL9x4F3FMDQNFRe6bcum+ruxJYN8jX2=nmDN7TTz=FQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 7/9] selftests/bpf: switch test to new
 attach_perf_event API
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:53 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Use new bpf_program__attach_perf_event() in test previously relying on
> direct ioctl manipulations.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  .../bpf/prog_tests/stacktrace_build_id_nmi.c  | 31 +++++++++----------
>  1 file changed, 15 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> index 1c1a2f75f3d8..9557b7dfb782 100644
> --- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> +++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> @@ -17,6 +17,7 @@ static __u64 read_perf_max_sample_freq(void)
>  void test_stacktrace_build_id_nmi(void)
>  {
>         int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
> +       const char *prog_name = "tracepoint/random/urandom_read";
>         const char *file = "./test_stacktrace_build_id.o";
>         int err, pmu_fd, prog_fd;
>         struct perf_event_attr attr = {
> @@ -25,7 +26,9 @@ void test_stacktrace_build_id_nmi(void)
>                 .config = PERF_COUNT_HW_CPU_CYCLES,
>         };
>         __u32 key, previous_key, val, duration = 0;
> +       struct bpf_program *prog;
>         struct bpf_object *obj;
> +       struct bpf_link *link;
>         char buf[256];
>         int i, j;
>         struct bpf_stack_build_id id_offs[PERF_MAX_STACK_DEPTH];
> @@ -39,6 +42,10 @@ void test_stacktrace_build_id_nmi(void)
>         if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
>                 return;
>
> +       prog = bpf_object__find_program_by_title(obj, prog_name);
> +       if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
> +               goto close_prog;
> +
>         pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
>                          0 /* cpu 0 */, -1 /* group id */,
>                          0 /* flags */);
> @@ -47,15 +54,12 @@ void test_stacktrace_build_id_nmi(void)
>                   pmu_fd, errno))
>                 goto close_prog;
>
> -       err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
> -       if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n",
> -                 err, errno))
> -               goto close_pmu;
> -
> -       err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
> -       if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n",
> -                 err, errno))
> -               goto disable_pmu;
> +       link = bpf_program__attach_perf_event(prog, pmu_fd);
> +       if (CHECK(IS_ERR(link), "attach_perf_event",
> +                 "err %ld\n", PTR_ERR(link))) {
> +               close(pmu_fd);
> +               goto close_prog;
> +       }
>
>         /* find map fds */
>         control_map_fd = bpf_find_map(__func__, obj, "control_map");
> @@ -134,8 +138,7 @@ void test_stacktrace_build_id_nmi(void)
>          * try it one more time.
>          */
>         if (build_id_matches < 1 && retry--) {
> -               ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
> -               close(pmu_fd);
> +               bpf_link__destroy(link);
>                 bpf_object__close(obj);
>                 printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
>                        __func__);
> @@ -154,11 +157,7 @@ void test_stacktrace_build_id_nmi(void)
>          */
>
>  disable_pmu:
> -       ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
> -
> -close_pmu:
> -       close(pmu_fd);
> -
> +       bpf_link__destroy(link);
>  close_prog:
>         bpf_object__close(obj);
>  }
> --
> 2.17.1
>
