Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9FF5A5B3
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfF1UKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:10:13 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35796 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfF1UKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:10:13 -0400
Received: by mail-qk1-f195.google.com with SMTP id l128so5969211qke.2;
        Fri, 28 Jun 2019 13:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5r169CPPFzOHX0WqSks+dy0jqaPo+cYH0tY/52n5NPo=;
        b=Y1+DREuzF5OqlROSwUQ5xbDryCCZTv9JC9CbRsCOA/RjbLsjqHofGyjFMXkZKnj4MO
         AnjOTh7WdB9YoXCHAo8jWBLuZjQh8L6hPWs+1l8oy1wWv4kxp+yhluESBMJWs0WK3IQn
         5b1pvKW9q5rpmq8fsSUmdPMDS/WRTN1csLY5uEQVPMHOhLfC49hpd/ivQi81cO2aWjIc
         f4qxTjMo104RM8L3KhllNV/1QyMK715uq41Q92HV9jXyC9k0yiuSzKRCqgaOjOMuDEhF
         yMNAr7km9xj6BXNonUC9wUNyo+Ed0irJBko77MM+uezMjhmSLIj56uTP3v05ZgZr+gbW
         JbmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5r169CPPFzOHX0WqSks+dy0jqaPo+cYH0tY/52n5NPo=;
        b=UhZ2mai4Mmfe99Xho4lQIA4ta6IM3CHf1LHYA+EaHH5bX8d7s2RslnxWJP3lTJ2JW7
         l56MVaxbjyzZJm2jd2kbi99VDFjOcbzJ0hKSOZ4BrDKp+Q8ZKVBgJcWFDIK+YeeEr1ut
         52Vkr9tFqXE8DQREluaRdLAoapmh2m+spqaeCgWueFDnOLGZA9sdC8KQMPk0Nbc9V9hV
         jGlK6FE3Dr2L3ztk/3JXf24lCA9k/8PANeF1W99h5P1Wqx9Y8tCrvUHlebFZcZUrZV/M
         NVqp4YnW3jhN6bDgxHz8fqwiDip8RlP8gqd+2tOFAE1sRQcYI8r2/ku5rmigONYmj+yE
         kTMA==
X-Gm-Message-State: APjAAAUyZSX9i3ZpH7w93fNf3qIznx6QbP7wIhCB8WUW6sGHCZEm+k2s
        kNTvbJSrROAjQwnzmpWjQY4+PO9Do2DMh4USPzs=
X-Google-Smtp-Source: APXvYqz/Fu63JZlTBIvPUHlr8zmihwKDcyniSai/3NSSTg6BMm9gn3PetKDfVrhz4x7UFjmt9bcMxs8vYeu2scoeogA=
X-Received: by 2002:a37:354:: with SMTP id 81mr10456750qkd.378.1561752612331;
 Fri, 28 Jun 2019 13:10:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-9-andriin@fb.com>
In-Reply-To: <20190628055303.1249758-9-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 13:10:01 -0700
Message-ID: <CAPhsuW6HGpJJrjynRvOVJVf+zHeDmHbgVM7E0+cqqw8z8ChqMQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 8/9] selftests/bpf: add kprobe/uprobe selftests
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

On Thu, Jun 27, 2019 at 10:54 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add tests verifying kprobe/kretprobe/uprobe/uretprobe APIs work as
> expected.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  .../selftests/bpf/prog_tests/attach_probe.c   | 155 ++++++++++++++++++
>  .../selftests/bpf/progs/test_attach_probe.c   |  55 +++++++
>  2 files changed, 210 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_probe.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> new file mode 100644
> index 000000000000..f22929063c58
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +
> +ssize_t get_base_addr() {
> +       size_t start;
> +       char buf[256];
> +       FILE *f;
> +
> +       f = fopen("/proc/self/maps", "r");
> +       if (!f)
> +               return -errno;
> +
> +       while (fscanf(f, "%zx-%*x %s %*s\n", &start, buf) == 2) {
> +               if (strcmp(buf, "r-xp") == 0) {
> +                       fclose(f);
> +                       return start;
> +               }
> +       }
> +
> +       fclose(f);
> +       return -EINVAL;
> +}
> +
> +void test_attach_probe(void)
> +{
> +       const char *kprobe_name = "kprobe/sys_nanosleep";
> +       const char *kretprobe_name = "kretprobe/sys_nanosleep";
> +       const char *uprobe_name = "uprobe/trigger_func";
> +       const char *uretprobe_name = "uretprobe/trigger_func";
> +       const int kprobe_idx = 0, kretprobe_idx = 1;
> +       const int uprobe_idx = 2, uretprobe_idx = 3;
> +       const char *file = "./test_attach_probe.o";
> +       struct bpf_program *kprobe_prog, *kretprobe_prog;
> +       struct bpf_program *uprobe_prog, *uretprobe_prog;
> +       struct bpf_object *obj;
> +       int err, prog_fd, duration = 0, res;
> +       struct bpf_link *kprobe_link = NULL;
> +       struct bpf_link *kretprobe_link = NULL;
> +       struct bpf_link *uprobe_link = NULL;
> +       struct bpf_link *uretprobe_link = NULL;
> +       int results_map_fd;
> +       size_t uprobe_offset;
> +       ssize_t base_addr;
> +
> +       base_addr = get_base_addr();
> +       if (CHECK(base_addr < 0, "get_base_addr",
> +                 "failed to find base addr: %zd", base_addr))
> +               return;
> +       uprobe_offset = (size_t)&get_base_addr - base_addr;
> +
> +       /* load programs */
> +       err = bpf_prog_load(file, BPF_PROG_TYPE_KPROBE, &obj, &prog_fd);
> +       if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
> +               return;
> +
> +       kprobe_prog = bpf_object__find_program_by_title(obj, kprobe_name);
> +       if (CHECK(!kprobe_prog, "find_probe",
> +                 "prog '%s' not found\n", kprobe_name))
> +               goto cleanup;
> +       kretprobe_prog = bpf_object__find_program_by_title(obj, kretprobe_name);
> +       if (CHECK(!kretprobe_prog, "find_probe",
> +                 "prog '%s' not found\n", kretprobe_name))
> +               goto cleanup;
> +       uprobe_prog = bpf_object__find_program_by_title(obj, uprobe_name);
> +       if (CHECK(!uprobe_prog, "find_probe",
> +                 "prog '%s' not found\n", uprobe_name))
> +               goto cleanup;
> +       uretprobe_prog = bpf_object__find_program_by_title(obj, uretprobe_name);
> +       if (CHECK(!uretprobe_prog, "find_probe",
> +                 "prog '%s' not found\n", uretprobe_name))
> +               goto cleanup;
> +
> +       /* load maps */
> +       results_map_fd = bpf_find_map(__func__, obj, "results_map");
> +       if (CHECK(results_map_fd < 0, "find_results_map",
> +                 "err %d\n", results_map_fd))
> +               goto cleanup;
> +
> +       kprobe_link = bpf_program__attach_kprobe(kprobe_prog,
> +                                                false /* retprobe */,
> +                                                "sys_nanosleep");
> +       if (CHECK(IS_ERR(kprobe_link), "attach_kprobe",
> +                 "err %ld\n", PTR_ERR(kprobe_link)))
> +               goto cleanup;
> +
> +       kretprobe_link = bpf_program__attach_kprobe(kretprobe_prog,
> +                                                   true /* retprobe */,
> +                                                   "sys_nanosleep");
> +       if (CHECK(IS_ERR(kretprobe_link), "attach_kretprobe",
> +                 "err %ld\n", PTR_ERR(kretprobe_link)))
> +               goto cleanup;
> +
> +       uprobe_link = bpf_program__attach_uprobe(uprobe_prog,
> +                                                false /* retprobe */,
> +                                                0 /* self pid */,
> +                                                "/proc/self/exe",
> +                                                uprobe_offset);
> +       if (CHECK(IS_ERR(uprobe_link), "attach_uprobe",
> +                 "err %ld\n", PTR_ERR(uprobe_link)))
> +               goto cleanup;
> +
> +       uretprobe_link = bpf_program__attach_uprobe(uretprobe_prog,
> +                                                   true /* retprobe */,
> +                                                   -1 /* any pid */,
> +                                                   "/proc/self/exe",
> +                                                   uprobe_offset);
> +       if (CHECK(IS_ERR(uretprobe_link), "attach_uretprobe",
> +                 "err %ld\n", PTR_ERR(uretprobe_link)))
> +               goto cleanup;
> +
> +       /* trigger & validate kprobe && kretprobe */
> +       usleep(1);
> +
> +       err = bpf_map_lookup_elem(results_map_fd, &kprobe_idx, &res);
> +       if (CHECK(err, "get_kprobe_res",
> +                 "failed to get kprobe res: %d\n", err))
> +               goto cleanup;
> +       if (CHECK(res != kprobe_idx + 1, "check_kprobe_res",
> +                 "wrong kprobe res: %d\n", res))
> +               goto cleanup;
> +
> +       err = bpf_map_lookup_elem(results_map_fd, &kretprobe_idx, &res);
> +       if (CHECK(err, "get_kretprobe_res",
> +                 "failed to get kretprobe res: %d\n", err))
> +               goto cleanup;
> +       if (CHECK(res != kretprobe_idx + 1, "check_kretprobe_res",
> +                 "wrong kretprobe res: %d\n", res))
> +               goto cleanup;
> +
> +       /* trigger & validate uprobe & uretprobe */
> +       get_base_addr();
> +
> +       err = bpf_map_lookup_elem(results_map_fd, &uprobe_idx, &res);
> +       if (CHECK(err, "get_uprobe_res",
> +                 "failed to get uprobe res: %d\n", err))
> +               goto cleanup;
> +       if (CHECK(res != uprobe_idx + 1, "check_uprobe_res",
> +                 "wrong uprobe res: %d\n", res))
> +               goto cleanup;
> +
> +       err = bpf_map_lookup_elem(results_map_fd, &uretprobe_idx, &res);
> +       if (CHECK(err, "get_uretprobe_res",
> +                 "failed to get uretprobe res: %d\n", err))
> +               goto cleanup;
> +       if (CHECK(res != uretprobe_idx + 1, "check_uretprobe_res",
> +                 "wrong uretprobe res: %d\n", res))
> +               goto cleanup;
> +
> +cleanup:
> +       bpf_link__destroy(kprobe_link);
> +       bpf_link__destroy(kretprobe_link);
> +       bpf_link__destroy(uprobe_link);
> +       bpf_link__destroy(uretprobe_link);
> +       bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
> new file mode 100644
> index 000000000000..7a7c5cd728c8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
> @@ -0,0 +1,55 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2017 Facebook
> +
> +#include <linux/ptrace.h>
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +struct {
> +       int type;
> +       int max_entries;
> +       int *key;
> +       int *value;
> +} results_map SEC(".maps") = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .max_entries = 4,
> +};
> +
> +SEC("kprobe/sys_nanosleep")
> +int handle_sys_nanosleep_entry(struct pt_regs *ctx)
> +{
> +       const int key = 0, value = 1;
> +
> +       bpf_map_update_elem(&results_map, &key, &value, 0);
> +       return 0;
> +}
> +
> +SEC("kretprobe/sys_nanosleep")
> +int handle_sys_getpid_return(struct pt_regs *ctx)
> +{
> +       const int key = 1, value = 2;
> +
> +       bpf_map_update_elem(&results_map, &key, &value, 0);
> +       return 0;
> +}
> +
> +SEC("uprobe/trigger_func")
> +int handle_uprobe_entry(struct pt_regs *ctx)
> +{
> +       const int key = 2, value = 3;
> +
> +       bpf_map_update_elem(&results_map, &key, &value, 0);
> +       return 0;
> +}
> +
> +SEC("uretprobe/trigger_func")
> +int handle_uprobe_return(struct pt_regs *ctx)
> +{
> +       const int key = 3, value = 4;
> +
> +       bpf_map_update_elem(&results_map, &key, &value, 0);
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> +__u32 _version SEC("version") = 1;
> --
> 2.17.1
>
