Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326EB26A0F
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbfEVStJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:49:09 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33213 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbfEVStI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:49:08 -0400
Received: by mail-qk1-f196.google.com with SMTP id p18so2203587qkk.0;
        Wed, 22 May 2019 11:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9w2z/UYA71J3Md5pbuqiQS3+dbglt+COmCdXK+qx8bg=;
        b=Chgo2geO0mTosVHqx6kDl8m8xC6Mk6lAjmybvXOfm75Vm4VAw0RMiLzq1YIEzlnULD
         +kHgDk/tdzwy2lAsKSnp5scMSXudI45ZvNVWL8+K6qQiCLDHYnzWSkuC2/T+9bYtgrq0
         BJoNETVbS3wzLIRiAKster294VQ1m71z40bsiBx392bYK3PMFVt/zs4oB33sCscuRR5d
         IDj5/YuqDNaxRlVAzOAUFxi1Tk7NjPgpAYGMeFMfSW6WgAtjIlXv9IulJfKcOlEZtczD
         YwNU+HoNj3kx8KNv+n+MsUF/cvwLeI24MiDkr6yGzlJEfzOIkc8dZEpXBkTjje+t+WeI
         qqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9w2z/UYA71J3Md5pbuqiQS3+dbglt+COmCdXK+qx8bg=;
        b=tarPeHEe+Si807QAJI1pPjesmxqSn2H6FXgOLtT9m2u8uf9ZaDggLq6Ndk18uwO/9Z
         nDvtiGROIkXa6RTqJxnAYR6NSA6TK62jQy1KXazEcrPlPxA7LcM8N99/jYJU6ucWpVyb
         cwW/4aL6HJ/ABHkaxsd+r+pOJcbS6xtRdBI0c0ysQtKhvw7LxnQcpnUjtJK+gBcuq2Dn
         7A9izWicHB/vAqAxo+fL6PQkZUYhdOryM2qgYSG1ZxmKKOfpV4MXIKL4wikALYLPjx1t
         KozJ+cmXZ1UlmELkItbVcQLdOJXpTYIUVS38PAWrXdUAowqoP0xEQBaONKmdGXQ8I1wY
         HHdg==
X-Gm-Message-State: APjAAAXbDfQ9gkgNbc+Q8wkIM5um23SHRSqsuI2Z9mLS4lfWAzl5b87Z
        U2/3+6jlI8MjVvlBEwKaDSMcREPEXzd/LnNLh+A=
X-Google-Smtp-Source: APXvYqywKerPneochQQTFDqYMxP0pdBASXLPJ+GxGlKywgLAOHa4i9UHlVb1NzgyQlMSZrAk8A3EkmpDGE4cewLAZ8o=
X-Received: by 2002:a37:66c7:: with SMTP id a190mr71346562qkc.44.1558550947254;
 Wed, 22 May 2019 11:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190522053900.1663459-1-yhs@fb.com> <20190522053903.1663924-1-yhs@fb.com>
In-Reply-To: <20190522053903.1663924-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 May 2019 11:48:55 -0700
Message-ID: <CAEf4BzbSvVRFd3ASnOR5kT40mCeH85ir2eFRdzu_rk4xjYky2g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/3] tools/bpf: add a selftest for
 bpf_send_signal() helper
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>
> The test covered both nmi and tracepoint perf events.
>   $ ./test_send_signal_user
>   test_send_signal (tracepoint): OK
>   test_send_signal (perf_event): OK
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  tools/testing/selftests/bpf/bpf_helpers.h     |   1 +
>  .../bpf/progs/test_send_signal_kern.c         |  51 +++++
>  .../selftests/bpf/test_send_signal_user.c     | 212 ++++++++++++++++++
>  4 files changed, 266 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_send_signal_kern.c
>  create mode 100644 tools/testing/selftests/bpf/test_send_signal_user.c
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 66f2dca1dee1..5eb6368a96a2 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -23,7 +23,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>         test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
>         test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
>         test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
> -       test_netcnt test_tcpnotify_user test_sock_fields test_sysctl
> +       test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
> +       test_send_signal_user
>
>  BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
>  TEST_GEN_FILES = $(BPF_OBJ_FILES)
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 5f6f9e7aba2a..cb02521b8e58 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -216,6 +216,7 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
>         (void *) BPF_FUNC_sk_storage_get;
>  static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
>         (void *)BPF_FUNC_sk_storage_delete;
> +static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
>
>  /* llvm builtin functions that eBPF C program may use to
>   * emit BPF_LD_ABS and BPF_LD_IND instructions
> diff --git a/tools/testing/selftests/bpf/progs/test_send_signal_kern.c b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
> new file mode 100644
> index 000000000000..45a1a1a2c345
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
> @@ -0,0 +1,51 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#include <linux/bpf.h>
> +#include <linux/version.h>
> +#include "bpf_helpers.h"
> +
> +struct bpf_map_def SEC("maps") info_map = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .key_size = sizeof(__u32),
> +       .value_size = sizeof(__u64),
> +       .max_entries = 1,
> +};
> +
> +BPF_ANNOTATE_KV_PAIR(info_map, __u32, __u64);
> +
> +struct bpf_map_def SEC("maps") status_map = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .key_size = sizeof(__u32),
> +       .value_size = sizeof(__u64),
> +       .max_entries = 1,
> +};
> +
> +BPF_ANNOTATE_KV_PAIR(status_map, __u32, __u64);
> +
> +SEC("send_signal_demo")
> +int bpf_send_signal_test(void *ctx)
> +{
> +       __u64 *info_val, *status_val;
> +       __u32 key = 0, pid, sig;
> +       int ret;
> +
> +       status_val = bpf_map_lookup_elem(&status_map, &key);
> +       if (!status_val || *status_val != 0)
> +               return 0;
> +
> +       info_val = bpf_map_lookup_elem(&info_map, &key);
> +       if (!info_val || *info_val == 0)
> +               return 0;
> +
> +       sig = *info_val >> 32;
> +       pid = *info_val & 0xffffFFFF;
> +
> +       if ((bpf_get_current_pid_tgid() >> 32) == pid) {
> +               ret = bpf_send_signal(sig);
> +               if (ret == 0)
> +                       *status_val = 1;
> +       }
> +
> +       return 0;
> +}
> +char __license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/test_send_signal_user.c b/tools/testing/selftests/bpf/test_send_signal_user.c
> new file mode 100644
> index 000000000000..0bd0f7674860
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_send_signal_user.c
> @@ -0,0 +1,212 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <signal.h>
> +#include <syscall.h>
> +#include <sys/ioctl.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/wait.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +
> +#include <linux/perf_event.h>
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +
> +#include "bpf_rlimit.h"
> +
> +#define CHECK(condition, tag, format...) ({                            \
> +       int __ret = !!(condition);                                      \
> +       if (__ret) {                                                    \
> +               printf("%s(%d):FAIL:%s ", __func__, __LINE__, tag);     \
> +               printf(format);                                         \
> +               printf("\n");                                           \
> +       }                                                               \
> +       __ret;                                                          \
> +})
> +
> +static volatile int signal_received = 0;
> +
> +static void sigusr1_handler(int signum)
> +{
> +       signal_received++;
> +}
> +
> +static void test_common(struct perf_event_attr *attr, int prog_type,
> +                       const char *test_name)
> +{
> +       int pmu_fd, prog_fd, info_map_fd, status_map_fd;
> +       const char *file = "./test_send_signal_kern.o";
> +       struct bpf_object *obj = NULL;
> +       int pipe_c2p[2], pipe_p2c[2];
> +       char buf[256];
> +       int err = 0;
> +       u32 key = 0;
> +       pid_t pid;
> +       u64 val;
> +
> +       if (CHECK(pipe(pipe_c2p), test_name,
> +                 "pipe pipe_c2p error: %s", strerror(errno)))
> +               return;
> +
> +       if (CHECK(pipe(pipe_p2c), test_name,
> +                 "pipe pipe_p2c error: %s", strerror(errno))) {
> +               close(pipe_c2p[0]);
> +               close(pipe_c2p[1]);
> +               return;
> +       }
> +
> +       pid = fork();
> +       if (CHECK(pid < 0, test_name, "fork error: %s", strerror(errno))) {
> +               close(pipe_c2p[0]);
> +               close(pipe_c2p[1]);
> +               close(pipe_p2c[0]);
> +               close(pipe_p2c[1]);
> +               return;
> +       }
> +
> +       if (pid == 0) {
> +               /* install signal handler and notify parent */
> +               signal(SIGUSR1, sigusr1_handler);
> +
> +               close(pipe_c2p[0]); /* close read */
> +               close(pipe_p2c[1]); /* close write */
> +
> +               /* notify parent signal handler is installed */
> +               write(pipe_c2p[1], buf, 1);
> +
> +               /* make sense parent enabled bpf program to send_signal */
> +               read(pipe_p2c[0], buf, 1);
> +
> +               /* wait a little for signal handler */
> +               sleep(1);
> +
> +               if (signal_received)
> +                       write(pipe_c2p[1], "2", 1);
> +               else
> +                       write(pipe_c2p[1], "0", 1);
> +
> +               /* wait for parent notification and exit */
> +               read(pipe_p2c[0], buf, 1);
> +
> +               close(pipe_c2p[1]);
> +               close(pipe_p2c[0]);
> +               exit(0);
> +       }
> +
> +       close(pipe_c2p[1]); /* close write */
> +       close(pipe_p2c[0]); /* close read */
> +
> +       err = bpf_prog_load(file, prog_type, &obj, &prog_fd);
> +       if (CHECK(err < 0, test_name, "bpf_prog_load error: %s",
> +                 strerror(errno)))
> +               goto prog_load_failure;
> +
> +       pmu_fd = syscall(__NR_perf_event_open, attr, pid, -1,
> +                        -1 /* group id */, 0 /* flags */);
> +       if (CHECK(pmu_fd < 0, test_name, "perf_event_open error: %s",
> +                 strerror(errno)))
> +               goto close_prog;
> +
> +       err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
> +       if (CHECK(err < 0, test_name, "ioctl perf_event_ioc_enable error: %s",
> +                 strerror(errno)))
> +               goto disable_pmu;
> +
> +       err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
> +       if (CHECK(err < 0, test_name, "ioctl perf_event_ioc_set_bpf error: %s",
> +                 strerror(errno)))
> +               goto disable_pmu;
> +
> +       info_map_fd = bpf_object__find_map_fd_by_name(obj, "info_map");
> +       if (CHECK(info_map_fd < 0, test_name, "find map %s error", "info_map"))
> +               goto disable_pmu;
> +
> +       status_map_fd = bpf_object__find_map_fd_by_name(obj, "status_map");
> +       if (CHECK(status_map_fd < 0, test_name, "find map %s error", "status_map"))
> +               goto disable_pmu;
> +
> +       /* wait until child signal handler installed */
> +       read(pipe_c2p[0], buf, 1);
> +
> +       /* trigger the bpf send_signal */
> +       key = 0;
> +       val = (((u64)(SIGUSR1)) << 32) | pid;
> +       bpf_map_update_elem(info_map_fd, &key, &val, 0);
> +
> +       /* notify child that bpf program can send_signal now */
> +       write(pipe_p2c[1], buf, 1);
> +
> +       /* wait for result */
> +       read(pipe_c2p[0], buf, 1);
> +
> +       if (buf[0] == '2')
> +               printf("test_send_signal (%s): OK\n", test_name);
> +       else
> +               printf("test_send_signal (%s): FAIL\n", test_name);
> +
> +       /* notify child safe to exit */
> +       write(pipe_p2c[1], buf, 1);
> +
> +disable_pmu:
> +       close(pmu_fd);
> +close_prog:
> +       bpf_object__close(obj);
> +prog_load_failure:
> +       close(pipe_c2p[0]);
> +       close(pipe_p2c[1]);
> +       wait(NULL);
> +}
> +
> +static void test_tracepoint(void)
> +{
> +       struct perf_event_attr attr = {
> +               .type = PERF_TYPE_TRACEPOINT,
> +               .sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_CALLCHAIN,
> +               .sample_period = 1,
> +               .wakeup_events = 1,
> +       };
> +       int bytes, efd;
> +       char buf[256];
> +
> +       snprintf(buf, sizeof(buf),
> +                "/sys/kernel/debug/tracing/events/syscalls/sys_enter_nanosleep/id");
> +       efd = open(buf, O_RDONLY, 0);
> +       if (CHECK(efd < 0, "tracepoint",
> +                 "open syscalls/sys_enter_nanosleep/id failure: %s",
> +                 strerror(errno)))
> +               return;
> +
> +       bytes = read(efd, buf, sizeof(buf));
> +       close(efd);
> +       if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "tracepoint",
> +                 "read syscalls/sys_enter_nanosleep/id failure: %s",
> +                 strerror(errno)))
> +               return;
> +
> +       attr.config = strtol(buf, NULL, 0);
> +
> +       test_common(&attr, BPF_PROG_TYPE_TRACEPOINT, "tracepoint");
> +}
> +
> +static void test_nmi_perf_event(void)
> +{
> +       struct perf_event_attr attr = {
> +               .sample_freq = 50,
> +               .freq = 1,
> +               .type = PERF_TYPE_HARDWARE,
> +               .config = PERF_COUNT_HW_CPU_CYCLES,
> +       };
> +
> +       test_common(&attr, BPF_PROG_TYPE_PERF_EVENT, "perf_event");
> +}
> +
> +int main(void)
> +{
> +       test_tracepoint();
> +       test_nmi_perf_event();

Tests should probably propagate failure up to main() and return exit
code != 0, if any of the tests failed.

> +       return 0;
> +}
> --
> 2.17.1
>
