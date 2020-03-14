Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBFD1853E9
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgCNBqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:46:14 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43587 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgCNBqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 21:46:14 -0400
Received: by mail-qk1-f194.google.com with SMTP id x1so11281320qkx.10;
        Fri, 13 Mar 2020 18:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+EY9qhp7hotXZSLbk7ac086JuqC2Kxm6vhj9SAHOe0A=;
        b=gdH4G/f7tMO4ObX3Z2gzriiTVwciNK4yNqkNuBaDkZQ7f3sF1dgd4GxEMto/m7Zhxd
         H2a8vpp8Piuj/qowyuGnj/c8f8+Jsytw1Ka7wRx12mb0XymmeAkG32vFfcdUYTgzkTxw
         IAosI3PyAFOyfQX/gsZLE+W61crrrACXrt9DIOhvtauEmRorj4+ALj9rN5HgHakKp+uq
         67183PTHJ2Uwrw+KWu68ooxddGVfE66nPk6vZSRFSf5zKHPICIBoJq6X5OTQhmAuG/8a
         ZWrvFisSrBtieu2nP/8Cgy2+Wk0sXPi9mco0lISAQGQdbk9gQuFqEJLQWSoEKdEuCNqK
         RNPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+EY9qhp7hotXZSLbk7ac086JuqC2Kxm6vhj9SAHOe0A=;
        b=lMd0Y/WxWad7q8XCkw8VxUSh5HRQra/OhjGPNUsqFQUItUFlCHr//DmbhCU1rO8XDG
         kOwCgo3NBNw2oft31wuNRU4E8KTiE7Pbhlk2523+y7QtsK/0Gxj3pYVSWnlDZzZEbIx8
         3H81+PSf+RdFRmwUs/lBuLUQznfy9qIWf1B+hD4ByEZDMfQT2hBzJEJGWINFKQHAtmTN
         MLlom/C0/DdrjlY/nqHcke2XdzgugYs6U2rmPGXvaAHogr51soHt7mSf/ZU8Yd0kdYBV
         91vLBItArDpPDykPgfWKnxgvWJWM1JdBldaFwe3EyNO2bHpG/91MR6A71epQ9rswXFCp
         udrA==
X-Gm-Message-State: ANhLgQ0m9dMNjiE+eYhaVeJweoyb7LGyrGRjMjJixIun1jzca9g+RdY6
        DdaEaUPlJChMp4tmo6OqbgWKcjfeFz3QoaFxng==
X-Google-Smtp-Source: ADFU+vtL7qdnelgSTlwmLlFuOFNmr8itx3gCZSg9vffQO9IBpXth1zodHX60Y8vFQUfMuYg8Fgdnx/f01gtfLqpuV0A=
X-Received: by 2002:a25:e690:: with SMTP id d138mr21593460ybh.180.1584150372302;
 Fri, 13 Mar 2020 18:46:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200313115220.29073-1-danieltimlee@gmail.com>
 <20200313115220.29073-3-danieltimlee@gmail.com> <CAEf4BzZmkvhb7C=XpUj4_+Mm7MoX8WMkbPAs8Tq6oXzVOrniow@mail.gmail.com>
In-Reply-To: <CAEf4BzZmkvhb7C=XpUj4_+Mm7MoX8WMkbPAs8Tq6oXzVOrniow@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 14 Mar 2020 10:45:56 +0900
Message-ID: <CAEKGpzhjXkB5B6i9ZqP6tDKafQqUH5ka9QpaVF-xrn4jNK1M3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/2] samples: bpf: refactor perf_event user
 program with libbpf bpf_link
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 3:48 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Mar 13, 2020 at 4:52 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > The bpf_program__attach of libbpf(using bpf_link) is much more intuitive
> > than the previous method using ioctl.
> >
> > bpf_program__attach_perf_event manages the enable of perf_event and
> > attach of BPF programs to it, so there's no neeed to do this
> > directly with ioctl.
> >
> > In addition, bpf_link provides consistency in the use of API because it
> > allows disable (detach, destroy) for multiple events to be treated as
> > one bpf_link__destroy. Also, bpf_link__destroy manages the close() of
> > perf_event fd.
> >
> > This commit refactors samples that attach the bpf program to perf_event
> > by using libbbpf instead of ioctl. Also the bpf_load in the samples were
> > removed and migrated to use libbbpf API.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> > Changes in v2:
> >  - check memory allocation is successful
> >  - clean up allocated memory on error
> >
> > Changes in v3:
> >  - Improve pointer error check (IS_ERR())
> >  - change to calloc for easier destroy of bpf_link
> >  - remove perf_event fd list since bpf_link handles fd
> >  - use newer bpf_object__{open/load} API instead of bpf_prog_load
> >  - perf_event for _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF
> >  - find program with name explicitly instead of bpf_program__next
> >  - unconditional bpf_link__destroy() on cleanup
> >  - return error code on int_exit
> >
> >  samples/bpf/Makefile           |   4 +-
> >  samples/bpf/sampleip_user.c    | 100 ++++++++++++++++++++++-----------
> >  samples/bpf/trace_event_user.c |  89 ++++++++++++++++++++---------
> >  3 files changed, 131 insertions(+), 62 deletions(-)
> >
> > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > index ff0061467dd3..424f6fe7ce38 100644
> > --- a/samples/bpf/Makefile
> > +++ b/samples/bpf/Makefile
> > @@ -88,8 +88,8 @@ xdp2-objs := xdp1_user.o
> >  xdp_router_ipv4-objs := xdp_router_ipv4_user.o
> >  test_current_task_under_cgroup-objs := bpf_load.o $(CGROUP_HELPERS) \
> >                                        test_current_task_under_cgroup_user.o
> > -trace_event-objs := bpf_load.o trace_event_user.o $(TRACE_HELPERS)
> > -sampleip-objs := bpf_load.o sampleip_user.o $(TRACE_HELPERS)
> > +trace_event-objs := trace_event_user.o $(TRACE_HELPERS)
> > +sampleip-objs := sampleip_user.o $(TRACE_HELPERS)
> >  tc_l2_redirect-objs := bpf_load.o tc_l2_redirect_user.o
> >  lwt_len_hist-objs := bpf_load.o lwt_len_hist_user.o
> >  xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
> > diff --git a/samples/bpf/sampleip_user.c b/samples/bpf/sampleip_user.c
> > index b0f115f938bc..05eca7b00e22 100644
> > --- a/samples/bpf/sampleip_user.c
> > +++ b/samples/bpf/sampleip_user.c
> > @@ -10,21 +10,23 @@
> >  #include <errno.h>
> >  #include <signal.h>
> >  #include <string.h>
> > -#include <assert.h>
> >  #include <linux/perf_event.h>
> >  #include <linux/ptrace.h>
> >  #include <linux/bpf.h>
> > -#include <sys/ioctl.h>
> > +#include <bpf/bpf.h>
> >  #include <bpf/libbpf.h>
> > -#include "bpf_load.h"
> >  #include "perf-sys.h"
> >  #include "trace_helpers.h"
> >
> > +#define __must_check
> > +#include <linux/err.h>
> > +
> >  #define DEFAULT_FREQ   99
> >  #define DEFAULT_SECS   5
> >  #define MAX_IPS                8192
> >  #define PAGE_OFFSET    0xffff880000000000
> >
> > +static int map_fd;
> >  static int nr_cpus;
> >
> >  static void usage(void)
> > @@ -34,9 +36,10 @@ static void usage(void)
> >         printf("       duration   # sampling duration (seconds), default 5\n");
> >  }
> >
> > -static int sampling_start(int *pmu_fd, int freq)
> > +static int sampling_start(int freq, struct bpf_program *prog,
> > +                         struct bpf_link *links[])
> >  {
> > -       int i;
> > +       int i, pmu_fd;
> >
> >         struct perf_event_attr pe_sample_attr = {
> >                 .type = PERF_TYPE_SOFTWARE,
> > @@ -47,26 +50,29 @@ static int sampling_start(int *pmu_fd, int freq)
> >         };
> >
> >         for (i = 0; i < nr_cpus; i++) {
> > -               pmu_fd[i] = sys_perf_event_open(&pe_sample_attr, -1 /* pid */, i,
> > +               pmu_fd = sys_perf_event_open(&pe_sample_attr, -1 /* pid */, i,
> >                                             -1 /* group_fd */, 0 /* flags */);
> > -               if (pmu_fd[i] < 0) {
> > +               if (pmu_fd < 0) {
> >                         fprintf(stderr, "ERROR: Initializing perf sampling\n");
> >                         return 1;
> >                 }
> > -               assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF,
> > -                            prog_fd[0]) == 0);
> > -               assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE, 0) == 0);
> > +               links[i] = bpf_program__attach_perf_event(prog, pmu_fd);
> > +               if (IS_ERR(links[i])) {
>
> links[i] = NULL;
>

Since bpf_program__attach_perf_event will return err code such
as ERR_PTR(-EINVAL), so it is natural to reset the pointer to NULL!
Thank you for the heads up!

> > +                       fprintf(stderr, "ERROR: Attach perf event\n");
> > +                       close(pmu_fd);
> > +                       return 1;
> > +               }
> >         }
> >
> >         return 0;
> >  }
> >
> > -static void sampling_end(int *pmu_fd)
> > +static void sampling_end(struct bpf_link *links[])
> >  {
> >         int i;
> >
> >         for (i = 0; i < nr_cpus; i++)
> > -               close(pmu_fd[i]);
> > +               bpf_link__destroy(links[i]);
> >  }
> >
> >  struct ipcount {
> > @@ -128,14 +134,17 @@ static void print_ip_map(int fd)
> >  static void int_exit(int sig)
> >  {
> >         printf("\n");
> > -       print_ip_map(map_fd[0]);
> > +       print_ip_map(map_fd);
> >         exit(0);
> >  }
> >
> >  int main(int argc, char **argv)
> >  {
> > +       int opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS, error = 0;
> > +       struct bpf_program *prog;
> > +       struct bpf_object *obj;
>
> initialize to NULL here
>

I'll apply this at next version patch.

> > +       struct bpf_link **links;
> >         char filename[256];
> > -       int *pmu_fd, opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS;
> >
> >         /* process arguments */
> >         while ((opt = getopt(argc, argv, "F:h")) != -1) {
> > @@ -163,38 +172,61 @@ int main(int argc, char **argv)
> >         }
> >
> >         /* create perf FDs for each CPU */
> > -       nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
> > -       pmu_fd = malloc(nr_cpus * sizeof(int));
> > -       if (pmu_fd == NULL) {
> > -               fprintf(stderr, "ERROR: malloc of pmu_fd\n");
> > -               return 1;
> > +       nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
> > +       links = calloc(nr_cpus, sizeof(struct bpf_link *));
> > +       if (!links) {
> > +               fprintf(stderr, "ERROR: malloc of links\n");
> > +               error = 1;
> > +               goto cleanup;
> >         }
> >
> > -       /* load BPF program */
> >         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > -       if (load_bpf_file(filename)) {
> > -               fprintf(stderr, "ERROR: loading BPF program (errno %d):\n",
> > -                       errno);
> > -               if (strcmp(bpf_log_buf, "") == 0)
> > -                       fprintf(stderr, "Try: ulimit -l unlimited\n");
> > -               else
> > -                       fprintf(stderr, "%s", bpf_log_buf);
> > -               return 1;
> > +       obj = bpf_object__open_file(filename, NULL);
> > +       if (IS_ERR(obj)) {
>
> obj = NULL;
>

Also again, bpf_object__open_file will return err code of pointer,
and the pointer needs to be set to NULL for bpf_object__close.

> > +               fprintf(stderr, "ERROR: opening BPF object file failed\n");
> > +               error = 1;
> > +               goto cleanup;
> > +       }
> > +
> > +       prog = bpf_object__find_program_by_name(obj, "do_sample");
> > +       if (!prog) {
> > +               fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
> > +               error = 1;
> > +               goto cleanup;
> >         }
> > +
> > +       /* load BPF program */
> > +       if (bpf_object__load(obj)) {
> > +               fprintf(stderr, "ERROR: loading BPF object file failed\n");
> > +               error = 1;
> > +               goto cleanup;
> > +       }
> > +
> > +       map_fd = bpf_object__find_map_fd_by_name(obj, "ip_map");
> > +       if (map_fd < 0) {
> > +               fprintf(stderr, "ERROR: finding a map in obj file failed\n");
> > +               error = 1;
> > +               goto cleanup;
> > +       }
> > +
> >         signal(SIGINT, int_exit);
> >         signal(SIGTERM, int_exit);
> >
> >         /* do sampling */
> >         printf("Sampling at %d Hertz for %d seconds. Ctrl-C also ends.\n",
> >                freq, secs);
> > -       if (sampling_start(pmu_fd, freq) != 0)
> > -               return 1;
> > +       if (sampling_start(freq, prog, links) != 0) {
> > +               error = 1;
> > +               goto cleanup;
> > +       }
> >         sleep(secs);
> > -       sampling_end(pmu_fd);
> > -       free(pmu_fd);
> >
> > +cleanup:
> > +       sampling_end(links);
>
> bpf_object__destroy(obj)
>

Sorry, but I might not following you, but is there bpf_object__destroy
exist in libbpf? I guess you're talking about bpf_object__close, right?

> >         /* output sample counts */
> > -       print_ip_map(map_fd[0]);
> > +       if (!error)
> > +               print_ip_map(map_fd);
> >
> > -       return 0;
> > +       free(links);
> > +       return error;
> >  }
> > diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
> > index 356171bc392b..5f64ff524cc3 100644
> > --- a/samples/bpf/trace_event_user.c
> > +++ b/samples/bpf/trace_event_user.c
> > @@ -6,22 +6,24 @@
> >  #include <stdlib.h>
> >  #include <stdbool.h>
> >  #include <string.h>
> > -#include <fcntl.h>
> > -#include <poll.h>
> > -#include <sys/ioctl.h>
> >  #include <linux/perf_event.h>
> >  #include <linux/bpf.h>
> >  #include <signal.h>
> > -#include <assert.h>
> >  #include <errno.h>
> >  #include <sys/resource.h>
> > +#include <bpf/bpf.h>
> >  #include <bpf/libbpf.h>
> > -#include "bpf_load.h"
> >  #include "perf-sys.h"
> >  #include "trace_helpers.h"
> >
> > +#define __must_check
> > +#include <linux/err.h>
> > +
> >  #define SAMPLE_FREQ 50
> >
> > +/* counts, stackmap */
> > +static int map_fd[2];
> > +struct bpf_program *prog;
> >  static bool sys_read_seen, sys_write_seen;
> >
> >  static void print_ksym(__u64 addr)
> > @@ -136,23 +138,34 @@ static inline int generate_load(void)
> >
> >  static void test_perf_event_all_cpu(struct perf_event_attr *attr)
> >  {
> > -       int nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
> > -       int *pmu_fd = malloc(nr_cpus * sizeof(int));
> > -       int i, error = 0;
> > +       int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
> > +       struct bpf_link **links = calloc(nr_cpus, sizeof(struct bpf_link *));
> > +       int i, pmu_fd, error = 0;
> > +
> > +       if (!links) {
> > +               printf("malloc of links failed\n");
> > +               error = 1;
> > +               goto err;
> > +       }
> >
> >         /* system wide perf event, no need to inherit */
> >         attr->inherit = 0;
> >
> >         /* open perf_event on all cpus */
> >         for (i = 0; i < nr_cpus; i++) {
> > -               pmu_fd[i] = sys_perf_event_open(attr, -1, i, -1, 0);
> > -               if (pmu_fd[i] < 0) {
> > +               pmu_fd = sys_perf_event_open(attr, -1, i, -1, 0);
> > +               if (pmu_fd < 0) {
> >                         printf("sys_perf_event_open failed\n");
> >                         error = 1;
> >                         goto all_cpu_err;
> >                 }
> > -               assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF, prog_fd[0]) == 0);
> > -               assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE) == 0);
> > +               links[i] = bpf_program__attach_perf_event(prog, pmu_fd);
> > +               if (IS_ERR(links[i])) {
> > +                       printf("bpf_program__attach_perf_event failed\n");
> > +                       close(pmu_fd);
> > +                       error = 1;
> > +                       goto all_cpu_err;
> > +               }
> >         }
> >
> >         if (generate_load() < 0) {
> > @@ -161,18 +174,18 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
> >         }
> >         print_stacks();
> >  all_cpu_err:
> > -       for (i--; i >= 0; i--) {
> > -               ioctl(pmu_fd[i], PERF_EVENT_IOC_DISABLE);
> > -               close(pmu_fd[i]);
> > -       }
> > -       free(pmu_fd);
> > +       for (i--; i >= 0; i--)
> > +               bpf_link__destroy(links[i]);
> > +err:
> > +       free(links);
> >         if (error)
> > -               int_exit(0);
> > +               int_exit(error);
> >  }
> >
> >  static void test_perf_event_task(struct perf_event_attr *attr)
> >  {
> >         int pmu_fd, error = 0;
> > +       struct bpf_link *link;
> >
> >         /* per task perf event, enable inherit so the "dd ..." command can be traced properly.
> >          * Enabling inherit will cause bpf_perf_prog_read_time helper failure.
> > @@ -185,8 +198,12 @@ static void test_perf_event_task(struct perf_event_attr *attr)
> >                 printf("sys_perf_event_open failed\n");
> >                 int_exit(0);
> >         }
> > -       assert(ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd[0]) == 0);
> > -       assert(ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE) == 0);
> > +       link = bpf_program__attach_perf_event(prog, pmu_fd);
> > +       if (IS_ERR(link)) {
> > +               printf("bpf_program__attach_perf_event failed\n");
> > +               close(pmu_fd);
> > +               int_exit(0);
> > +       }
> >
> >         if (generate_load() < 0) {
> >                 error = 1;
> > @@ -194,10 +211,9 @@ static void test_perf_event_task(struct perf_event_attr *attr)
> >         }
> >         print_stacks();
> >  err:
> > -       ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
> > -       close(pmu_fd);
> > +       bpf_link__destroy(link);
> >         if (error)
> > -               int_exit(0);
> > +               int_exit(error);
> >  }
> >
> >  static void test_bpf_perf_event(void)
> > @@ -282,6 +298,7 @@ static void test_bpf_perf_event(void)
> >  int main(int argc, char **argv)
> >  {
> >         struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
> > +       struct bpf_object *obj;
> >         char filename[256];
> >
> >         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > @@ -295,9 +312,29 @@ int main(int argc, char **argv)
> >                 return 1;
> >         }
> >
> > -       if (load_bpf_file(filename)) {
> > -               printf("%s", bpf_log_buf);
> > -               return 2;
> > +       obj = bpf_object__open_file(filename, NULL);
> > +       if (IS_ERR(obj)) {
> > +               printf("opening BPF object file failed\n");
> > +               return 1;
> > +       }
> > +
> > +       prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
> > +       if (!prog) {
> > +               printf("finding a prog in obj file failed\n");
>
>
> bpf_object__close(obj);
>

Also, I'll apply this at next version patch.

> > +               return 1;
> > +       }
> > +
> > +       /* load BPF program */
> > +       if (bpf_object__load(obj)) {
>
> close bpf_object (better do goto clean approach, of course)
>

I will modify this with goto cleanup approach.

> > +               printf("loading BPF object file failed\n");
> > +               return 1;
> > +       }
> > +
> > +       map_fd[0] = bpf_object__find_map_fd_by_name(obj, "counts");
> > +       map_fd[1] = bpf_object__find_map_fd_by_name(obj, "stackmap");
> > +       if (map_fd[0] < 0 || map_fd[1] < 0) {
> > +               printf("finding a counts/stackmap map in obj file failed\n");
> > +               return 1;
> >         }
> >
> >         if (fork() == 0) {
> > --
> > 2.25.1
> >

Thank you for your time and effort for the review :)

Best,
Daniel
