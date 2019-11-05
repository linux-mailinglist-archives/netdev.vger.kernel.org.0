Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AFEF05A0
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390800AbfKETH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:07:26 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41903 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390526AbfKETH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:07:26 -0500
Received: by mail-qk1-f196.google.com with SMTP id m125so22162393qkd.8;
        Tue, 05 Nov 2019 11:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sbdI0Cb2ickUY3rLWAl81DZ9ddzQhH77WugLRbFz7g0=;
        b=B6OBFwIDAhHRhuKHlGWF3vy0byaOkaPBgq+3ki26lN13/Zhlv8gGJwHPFcESwiFEms
         2R5mLBgWnXqt9bjLZqwU94KtiU/MGUKzOQ31ZPc1JsGAuFdnPDl6NCQLUqnAxTTo5NvO
         DKwXgJ6VHuiljPuxIgEY4odop3Lvm2DkJBVAQyqWESDKZZ2ElVSkymFEZjYMwOK+Fimf
         2p0E30mAHLWrvHd4O30CXFHy9HXvb9PuAX5fgpjeHjMbOSZ28d16gd/W0DPX1KEjeYp+
         1a4YMqv4BI1PFgslYhix6dHRSKT+jsZ9y5MjOxieExfI/kuv9lO5zgoov7TudO/oVTCB
         iOUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sbdI0Cb2ickUY3rLWAl81DZ9ddzQhH77WugLRbFz7g0=;
        b=Mte470MOwVD2TeZ3hMGwoRmJSaW0Sd/sCr5ARm2lz/kOKeccebyEOUmztbSKURG2PA
         W2xjFVV9eFoq6j2RPfHhhUjXA3xxsIfb7NhfluR3NFPDONy4XaRXurqEA6uVNXcZgmbA
         gHpNZf6BFNtdWDQ6btezItxfoSwU4T62yc6s2ApnaGCiKIZxdJqMslfNoSfuLm0BL4Vx
         1ac3nuYj/eTrtWSNPblsjbjPVoCPxh+RNFknTdKsPkh9vW0PD69mdzOiae8PU2F3y/Bg
         6EFPsi5kMQAcbf828zdI1T0S8dJeT8II8sFYlkvuk4g5xiVjnOrCG0opwo3deR2K/A4t
         A+aw==
X-Gm-Message-State: APjAAAUmWdRNuKRXZNQBh6OdV8n+15FUtnhrpsUbMrgV2fVO0aUu5gBl
        f3Gv5xcbQRPGQ26Mj75FpkPMdEVOWp+RXepZmt8=
X-Google-Smtp-Source: APXvYqzmwVnkCd9zkwhkjdvMbVyQchyO1qgXPyiABgc1g7keUBW78XTGHTv4iJdQxR5bXGgZ0qSfY4cVOqAllceK+5c=
X-Received: by 2002:a37:9a8a:: with SMTP id c132mr9596411qke.92.1572980844382;
 Tue, 05 Nov 2019 11:07:24 -0800 (PST)
MIME-Version: 1.0
References: <20191105041223.5622-1-ethercflow@gmail.com>
In-Reply-To: <20191105041223.5622-1-ethercflow@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Nov 2019 11:07:13 -0800
Message-ID: <CAEf4Bzbbmfwd1m4F6iz_P2o5qGShd2orTF_vJBK_d-aSUXqkqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] selftests/bpf: test for bpf_get_file_path()
 from raw tracepoint
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 4, 2019 at 8:15 PM Wenbo Zhang <ethercflow@gmail.com> wrote:
>
> trace fstat events by raw tracepoint sys_enter:newfstat, and handle events
> only produced by test_file_get_path, which call fstat on several different
> types of files to test bpf_get_file_path's feature.
>
> v2->v3: addressed Andrii's feedback
> - use global data instead of perf_buffer to simplified code
>
> v1->v2: addressed Daniel's feedback
> - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> helper's names
>
> Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/get_file_path.c  | 171 ++++++++++++++++++
>  .../selftests/bpf/progs/test_get_file_path.c  |  71 ++++++++
>  2 files changed, 242 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_path.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_path.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/get_file_path.c b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
> new file mode 100644
> index 000000000000..26126e55c1f0
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <test_progs.h>
> +#include <alloca.h>
> +#include <sys/stat.h>
> +
> +#ifndef MAX_PATH_LENGTH
> +#define MAX_PATH_LENGTH                128
> +#endif
> +
> +#ifndef TASK_COMM_LEN
> +#define TASK_COMM_LEN          16
> +#endif

Do you really need these ifndefs? Either include headers that have
TASK_COMM_LEN, or don't and just define them directly?

> +
> +struct get_path_trace_t {
> +       unsigned long fd;
> +       char path[MAX_PATH_LENGTH];
> +};
> +
> +enum FS_TYPE {
> +       PIPE_0,
> +       PIPE_1,
> +       SOCK,
> +       PROC,
> +       DEV,
> +       LOCAL,
> +       INDICATOR,
> +       MAX_FDS
> +};
> +
> +struct path_info {
> +       int fd;
> +       char name[MAX_PATH_LENGTH];
> +};
> +
> +static struct path_info path_infos[MAX_FDS];
> +static int path_info_index;
> +static int hits;
> +
> +static inline int set_pathname(pid_t pid, int fd)
> +{
> +       char buf[MAX_PATH_LENGTH] = {'0'};

This is not a zero byte, it's a character "0", was this intentional?

> +
> +       snprintf(buf, MAX_PATH_LENGTH, "/proc/%d/fd/%d", pid, fd);
> +       path_infos[path_info_index].fd = fd;

you can just pass path_info_index directly, there is absolutely no
need for global counter for this...

> +       return readlink(buf, path_infos[path_info_index++].name,
> +                       MAX_PATH_LENGTH);
> +}
> +
> +static inline int compare_pathname(struct get_path_trace_t *data)
> +{
> +       for (int i = 0; i < MAX_FDS; i++) {
> +               if (path_infos[i].fd == data->fd) {
> +                       hits++;
> +                       return strncmp(path_infos[i].name, data->path,
> +                                       MAX_PATH_LENGTH);
> +               }
> +       }
> +       return 0;
> +}
> +
> +static int trigger_fstat_events(void)
> +{
> +       int *fds = alloca(sizeof(int) * MAX_FDS);

why do you need alloca()? Doesn't int fds[MAX_FDS] work? But honestly,
you needs fds just to have a loop to close all FDs. You can just as
well have a set of directl close(pipefd); close(sockfd); and so on,
with same amount of code, but more simplicity.

> +       int *pipefd = fds;
> +       int *sockfd = fds + SOCK;
> +       int *procfd = fds + PROC;
> +       int *devfd = fds + DEV;
> +       int *localfd = fds + LOCAL;
> +       int *indicatorfd = fds + INDICATOR;
> +       pid_t pid = getpid();
> +
> +       /* unmountable pseudo-filesystems */
> +       if (pipe(pipefd) < 0 || set_pathname(pid, *pipefd++) < 0 ||
> +               set_pathname(pid, *pipefd) < 0)
> +               return -1;
> +
> +       /* unmountable pseudo-filesystems */
> +       *sockfd = socket(AF_INET, SOCK_STREAM, 0);
> +       if (*sockfd < 0 || set_pathname(pid, *sockfd) < 0)
> +               return -1;
> +
> +       /* mountable pseudo-filesystems */
> +       *procfd = open("/proc/self/comm", O_RDONLY);
> +       if (*procfd < 0 || set_pathname(pid, *procfd) < 0)
> +               return -1;
> +
> +       *devfd = open("/dev/urandom", O_RDONLY);
> +       if (*devfd < 0 || set_pathname(pid, *devfd) < 0)
> +               return -1;
> +
> +       *localfd = open("/tmp/fd2path_loadgen.txt", O_CREAT|O_RDONLY);
> +       if (*localfd < 0 || set_pathname(pid, *localfd) < 0)
> +               return -1;
> +
> +       *indicatorfd = open("/tmp/", O_PATH);
> +       if (*indicatorfd < 0 || set_pathname(pid, *indicatorfd) < 0)
> +               return -1;

on error, you are not closing any file descriptor

> +
> +       for (int i = 0; i < MAX_FDS; i++)
> +               close(fds[i]);
> +
> +       remove("/tmp/fd2path_loadgen.txt");
> +       return 0;
> +}
> +
> +void test_get_file_path(void)
> +{
> +       const char *prog_name = "raw_tracepoint/sys_enter:newfstat";
> +       const char *file = "./test_get_file_path.o";
> +       int pidfilter_map_fd, pathdata_map_fd;
> +       __u32 key, previous_key, duration = 0;
> +       struct get_path_trace_t val = {};
> +       struct bpf_program *prog = NULL;
> +       struct bpf_object *obj = NULL;
> +       struct bpf_link *link = NULL;
> +       __u32 pid = getpid();
> +       int err, prog_fd;
> +
> +       err = bpf_prog_load(file, BPF_PROG_TYPE_RAW_TRACEPOINT, &obj, &prog_fd);
> +       if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
> +               return;
> +
> +       prog = bpf_object__find_program_by_title(obj, prog_name);
> +       if (CHECK(!prog, "find_prog", "prog %s not found\n", prog_name))
> +               goto out_close;
> +
> +       link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
> +       if (CHECK(IS_ERR(link), "attach_tp", "err %ld\n", PTR_ERR(link)))
> +               goto out_close;
> +
> +       pidfilter_map_fd = bpf_find_map(__func__, obj, "pidfilter_map");
> +       if (CHECK(pidfilter_map_fd < 0, "bpf_find_map pidfilter_map",
> +                 "err: %s\n", strerror(errno)))
> +               goto out_detach;
> +
> +       err = bpf_map_update_elem(pidfilter_map_fd, &key, &pid, 0);
> +       if (CHECK(err, "pidfilter_map update_elem", "err: %s\n",
> +                         strerror(errno)))
> +               goto out_detach;
> +
> +       err = trigger_fstat_events();
> +       if (CHECK(err, "trigger_fstat_events", "open fd failed: %s\n",
> +                         strerror(errno)))
> +               goto out_detach;
> +
> +       pathdata_map_fd = bpf_find_map(__func__, obj, "pathdata_map");
> +       if (CHECK_FAIL(pathdata_map_fd < 0))
> +               goto out_detach;
> +
> +       do {
> +               err = bpf_map_lookup_elem(pathdata_map_fd, &key, &val);
> +               if (CHECK(err, "lookup_elem from pathdata_map",
> +                                 "err %s\n", strerror(errno)))
> +                       goto out_detach;
> +
> +               CHECK(compare_pathname(&val) != 0,
> +                         "get_file_path", "failed to get path: %lu->%s\n",
> +                         val.fd, val.path);

Given you control the order of open()'s, you should know the order of
captured paths, so there is no need to find it or do hits++ logic.
Just check it positionally. See also below about global data usage.

> +
> +               previous_key = key;
> +       } while (bpf_map_get_next_key(pathdata_map_fd,
> +                                       &previous_key, &key) == 0);
> +
> +       CHECK(hits != MAX_FDS, "Lost event?", "%d != %d\n", hits, MAX_FDS);
> +
> +out_detach:
> +       bpf_link__destroy(link);
> +out_close:
> +       bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_get_file_path.c b/tools/testing/selftests/bpf/progs/test_get_file_path.c
> new file mode 100644
> index 000000000000..10ec9a70c81c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_get_file_path.c
> @@ -0,0 +1,71 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <linux/ptrace.h>
> +#include <linux/sched.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#include "bpf_helpers.h"
> +
> +#ifndef MAX_PATH_LENGTH
> +#define MAX_PATH_LENGTH                128
> +#endif
> +
> +#ifndef MAX_EVENT_NUM
> +#define MAX_EVENT_NUM          32
> +#endif
> +
> +struct path_trace_t {
> +       unsigned long fd;
> +       char path[MAX_PATH_LENGTH];
> +};
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, MAX_EVENT_NUM);
> +       __type(key, __u32);
> +       __type(value, struct path_trace_t);
> +} pathdata_map SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u32);
> +} pidfilter_map SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u32);
> +} index_map SEC(".maps");

This is not global variables, it's just maps. What I had in mind (and
what would still simplify even userspace part of tests, IMO) is
something like this:


struct file_path_test_data {
    pid_t pid;
    int cnt;
    unsigned long fds[MAX_EVENT_NUM];
    char paths[MAX_EVENT_NUM][MAX_PATH_LENGTH];
} data;

> +
> +SEC("raw_tracepoint/sys_enter:newfstat")
> +int bpf_prog(struct bpf_raw_tracepoint_args *ctx)
> +{
> +       struct path_trace_t *data;
> +       struct pt_regs *regs;
> +       __u32 key = 0, *i, *pidfilter, pid;
> +
> +       pidfilter = bpf_map_lookup_elem(&pidfilter_map, &key);
> +       if (!pidfilter || *pidfilter == 0)
> +               return 0;
> +       i = bpf_map_lookup_elem(&index_map, &key);
> +       if (!i || *i == MAX_EVENT_NUM)
> +               return 0;
> +       pid = bpf_get_current_pid_tgid() >> 32;
> +       if (pid != *pidfilter)
> +               return 0;
> +       data = bpf_map_lookup_elem(&pathdata_map, i);
> +       if (!data)
> +               return 0;

here, you'll do:

if (pid != data.pid) return 0;
data.cnt++;
if (data.cnt > MAX_EVENT_NUM) return 0; /* check overflow in userspace */

data.fds[data.cnt - 1] = /* read fd */
bpf_get_file_path(data.paths[data.cnt - 1], ...)


> +
> +       regs = (struct pt_regs *)ctx->args[0];
> +       bpf_probe_read(&data->fd, sizeof(data->fd), &regs->rdi);

This is x86_64-specific, use one of PT_REGS_* macro from bpf_tracing.h header.

> +       bpf_get_file_path(data->path, MAX_PATH_LENGTH, data->fd);
> +       *i += 1;
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.17.1
>
