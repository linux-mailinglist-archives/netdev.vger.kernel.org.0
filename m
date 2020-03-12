Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86771828F5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387845AbgCLG1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:27:20 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44976 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387784AbgCLG1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:27:19 -0400
Received: by mail-qk1-f196.google.com with SMTP id f198so4599778qke.11;
        Wed, 11 Mar 2020 23:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wQESYtZATDBwr0tOs6Yf/tnhfDza4uIhIdV498Wok9w=;
        b=iI0pF7mHD/jwbJTpJS3dGK8awNRA3R6qgy8OP4NslJy/sP2tUzFKHyqPnq+uFdTe4G
         hVgkBoTakYXZbhwB0WAN9pydM4LpCl9JiYR7Z7LQOCvgCjzz2g03fKKySiijkKCYbcJZ
         KiA2Eo9sjPXxLj66cSSXu2t6hPvPwdwH/M+Fg+za52t06pnynnAR/vm65JtOFycqf/FQ
         SeRo0zGdcG0TMx6gokrx0YQsls148Vru1rc+80Vaw1SCSv1MJ7/q0/rGxquZSBl2/H+8
         KUSkHEdcGqGPLIwkrCzBNlXI2qCjJiJ4uvfB+Lxq8XoN94E3wq2O6iIJ/07wXENgUYTS
         ltxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wQESYtZATDBwr0tOs6Yf/tnhfDza4uIhIdV498Wok9w=;
        b=SzUpIpzUxyhWa5W5YRCKbGL2jaFti7NzFRZDStTVlnNblagJiy1Q1W+4ba9a0GGbtZ
         7XYUG2x4pEWcAHcLQAn58fmLMdOUOewL21pUxnom47xBwSeKzjhP283lhsqqt8YNTD7o
         1S5pECfasFb2F5zrC1NprepUEmjgvbvMQTyxtwKPaQIILI3utEVgv0WGN/tLPtpQKF36
         6fM6pXTkcMZlTikDCDyE5TV+14Ty6LI2aaMbht5OtcueO1ip+u6G4Kpl26J1reNvVqVt
         ceinRoZCAugSvbeuj+VEQLph7yU5kLoRIqlA8ltzuf846MUh6lkNKYJ+QjZJMBR1vDSC
         D46Q==
X-Gm-Message-State: ANhLgQ2rQzfjEUUA0ZhIihl8bYDJ7OFarWC61oJ+MvmPFvlDFwm4MqdB
        zseF3yNHgORME3RHwcXyNArWj6t4lsJhfwHKoVNLOfL03lA=
X-Google-Smtp-Source: ADFU+vuZ9WHKcSueResqY2r0FT5jzynkXczYnS7Yr/uXd3njpCUnMpZ+0RUl0F/SeP2lo/qbKH8NhJbN0+a+ounyJuA=
X-Received: by 2002:ae9:c011:: with SMTP id u17mr6138525qkk.92.1583994434366;
 Wed, 11 Mar 2020 23:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200310232647.27777-1-danieltimlee@gmail.com>
 <20200310232647.27777-3-danieltimlee@gmail.com> <CAEf4BzYG5f70jYfTWdDdAS_ok4Bj8xJYz-x=zM1ppfRcer3=rQ@mail.gmail.com>
 <CAEKGpzgzeyuMf0AnWK-UeHZxBE9iCUA9FDOFu4iec8Q3cix5dA@mail.gmail.com>
In-Reply-To: <CAEKGpzgzeyuMf0AnWK-UeHZxBE9iCUA9FDOFu4iec8Q3cix5dA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Mar 2020 23:27:03 -0700
Message-ID: <CAEf4Bza4uhXJR3s1sj7vg0L4uAF__uVbp_A5UTy-2YTVc=YoCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] samples: bpf: refactor perf_event user
 program with libbpf bpf_link
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 11:16 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Wed, Mar 11, 2020 at 1:55 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Mar 10, 2020 at 4:27 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > The bpf_program__attach of libbpf(using bpf_link) is much more intuitive
> > > than the previous method using ioctl.
> > >
> > > bpf_program__attach_perf_event manages the enable of perf_event and
> > > attach of BPF programs to it, so there's no neeed to do this
> > > directly with ioctl.
> > >
> > > In addition, bpf_link provides consistency in the use of API because it
> > > allows disable (detach, destroy) for multiple events to be treated as
> > > one bpf_link__destroy.
> > >
> > > This commit refactors samples that attach the bpf program to perf_event
> > > by using libbbpf instead of ioctl. Also the bpf_load in the samples were
> > > removed and migrated to use libbbpf API.
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > ---
> >
> > Daniel, thanks for this clean up! It's good to see samples be
> > modernized a bit :)
> >
>
> Thank you for your time and effort for the review :)
>
> > > Changes in v2:
> > >  - check memory allocation is successful
> > >  - clean up allocated memory on error
> > >
> > >  samples/bpf/Makefile           |  4 +-
> > >  samples/bpf/sampleip_user.c    | 76 ++++++++++++++++++++++------------
> > >  samples/bpf/trace_event_user.c | 63 ++++++++++++++++++++--------
> > >  3 files changed, 97 insertions(+), 46 deletions(-)
> > >
> > > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > > index ff0061467dd3..424f6fe7ce38 100644
> > > --- a/samples/bpf/Makefile
> > > +++ b/samples/bpf/Makefile
> > > @@ -88,8 +88,8 @@ xdp2-objs := xdp1_user.o
> > >  xdp_router_ipv4-objs := xdp_router_ipv4_user.o
> > >  test_current_task_under_cgroup-objs := bpf_load.o $(CGROUP_HELPERS) \
> > >                                        test_current_task_under_cgroup_user.o
> > > -trace_event-objs := bpf_load.o trace_event_user.o $(TRACE_HELPERS)
> > > -sampleip-objs := bpf_load.o sampleip_user.o $(TRACE_HELPERS)
> > > +trace_event-objs := trace_event_user.o $(TRACE_HELPERS)
> > > +sampleip-objs := sampleip_user.o $(TRACE_HELPERS)
> > >  tc_l2_redirect-objs := bpf_load.o tc_l2_redirect_user.o
> > >  lwt_len_hist-objs := bpf_load.o lwt_len_hist_user.o
> > >  xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
> > > diff --git a/samples/bpf/sampleip_user.c b/samples/bpf/sampleip_user.c
> > > index b0f115f938bc..fd763a49c913 100644
> > > --- a/samples/bpf/sampleip_user.c
> > > +++ b/samples/bpf/sampleip_user.c
> > > @@ -10,13 +10,11 @@
> > >  #include <errno.h>
> > >  #include <signal.h>
> > >  #include <string.h>
> > > -#include <assert.h>
> > >  #include <linux/perf_event.h>
> > >  #include <linux/ptrace.h>
> > >  #include <linux/bpf.h>
> > > -#include <sys/ioctl.h>
> > > +#include <bpf/bpf.h>
> > >  #include <bpf/libbpf.h>
> > > -#include "bpf_load.h"
> > >  #include "perf-sys.h"
> > >  #include "trace_helpers.h"
> > >
> > > @@ -25,6 +23,7 @@
> > >  #define MAX_IPS                8192
> > >  #define PAGE_OFFSET    0xffff880000000000
> > >
> > > +static int map_fd;
> > >  static int nr_cpus;
> > >
> > >  static void usage(void)
> > > @@ -34,7 +33,8 @@ static void usage(void)
> > >         printf("       duration   # sampling duration (seconds), default 5\n");
> > >  }
> > >
> > > -static int sampling_start(int *pmu_fd, int freq)
> > > +static int sampling_start(int *pmu_fd, int freq, struct bpf_program *prog,
> > > +                         struct bpf_link **link)
> >
> > It's not apparent from looking at struct bpf_link **link whether it's
> > an output parameter (so sampling_start is supposed to assign *single*
> > link to return it to calling function) or it's an array of pointers.
> > Seems like it's the latter, so I'd prefer this written as
> >
> > struct bpf_link *links[] (notice also plural name).
> >
> > Please consider this.
> >
>
> This approach looks more apparent!
> I'll update code using this way.
>
> > >  {
> > >         int i;
> > >
> > > @@ -53,20 +53,22 @@ static int sampling_start(int *pmu_fd, int freq)
> > >                         fprintf(stderr, "ERROR: Initializing perf sampling\n");
> > >                         return 1;
> > >                 }
> > > -               assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF,
> > > -                            prog_fd[0]) == 0);
> > > -               assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE, 0) == 0);
> > > +               link[i] = bpf_program__attach_perf_event(prog, pmu_fd[i]);
> > > +               if (link[i] < 0) {
> >
> > link is a pointer, < 0 doesn't make sense and is always going to be
> > false on x86. Use IS_ERR(link[i]). It's also a good idea to set it to
> > NULL, if link creation failed to prevent accidental
> > bpf_link__destroy(link[i]) later on, trying to free bogus pointer.
> >
>
> Failure on link creation is exactly what I was concerned about.
> Thank you for giving me a clear solution!
>
> > > +                       fprintf(stderr, "ERROR: Attach perf event\n");
> > > +                       return 1;
> > > +               }
> > >         }
> > >
> > >         return 0;
> > >  }
> > >
> > > -static void sampling_end(int *pmu_fd)
> > > +static void sampling_end(struct bpf_link **link)
> >
> > same as above, struct bpf_link *links[] would be much better here, IMO.
> >
>
> Also, I'll apply this at next version patch.
>
> > >  {
> > >         int i;
> > >
> > >         for (i = 0; i < nr_cpus; i++)
> > > -               close(pmu_fd[i]);
> > > +               bpf_link__destroy(link[i]);
> > >  }
> > >
> > >  struct ipcount {
> > > @@ -128,14 +130,18 @@ static void print_ip_map(int fd)
> > >  static void int_exit(int sig)
> > >  {
> > >         printf("\n");
> > > -       print_ip_map(map_fd[0]);
> > > +       print_ip_map(map_fd);
> > >         exit(0);
> > >  }
> > >
> > >  int main(int argc, char **argv)
> > >  {
> > > +       int prog_fd, *pmu_fd, opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS;
> > > +       struct bpf_program *prog;
> > > +       struct bpf_object *obj;
> > > +       struct bpf_link **link;
> > >         char filename[256];
> > > -       int *pmu_fd, opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS;
> > > +       int error = 0;
> > >
> > >         /* process arguments */
> > >         while ((opt = getopt(argc, argv, "F:h")) != -1) {
> > > @@ -165,36 +171,54 @@ int main(int argc, char **argv)
> > >         /* create perf FDs for each CPU */
> > >         nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
> >
> > While neither approach is ideal, using number of online CPUs
> > (_SC_NPROCESSORS_ONLN) will probably work in slightly more cases
> > (there are machines configured with, say, 256 possible CPUs, but only
> > 32 available, for instance).
> >
>
> Thank you for pointing me out!
> I've never thought about situation when processors may be offline.
>
> >
> > >         pmu_fd = malloc(nr_cpus * sizeof(int));
> >
> > similar naming nit: pmu_fds?
> >
>
> Same again, apply this at next version patch.
>
> > > -       if (pmu_fd == NULL) {
> > > -               fprintf(stderr, "ERROR: malloc of pmu_fd\n");
> > > -               return 1;
> > > +       link = malloc(nr_cpus * sizeof(struct bpf_link *));
> >
> > Use calloc() to have those links initialized to NULL automatically.
> > Makes clean up so much easier.
> >
>
> About NULL set, like you mentioned, calloc approach looks more neat.
>
> > > +       if (pmu_fd == NULL || link == NULL) {
> > > +               fprintf(stderr, "ERROR: malloc of pmu_fd/link\n");
> > > +               error = 1;
> > > +               goto cleanup;
> > >         }
> > >
> > >         /* load BPF program */
> > >         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > > -       if (load_bpf_file(filename)) {
> > > +       if (bpf_prog_load(filename, BPF_PROG_TYPE_PERF_EVENT, &obj, &prog_fd)) {
> >
> > Using skeleton would be best, but it's probably more appropriate for
> > another patch to integrate skeleton generation with samples/bpf. So
> > the next one would be bpf_object__open_file(), instead of legacy
> > bpf_prog_load().
> >
>
> I'll try skeleton with other sample cleanup. For now, I'll stick with
> bpf_object__{open/load}() instead of bpf_prog_load().
>
> > >                 fprintf(stderr, "ERROR: loading BPF program (errno %d):\n",
> > >                         errno);
> > > -               if (strcmp(bpf_log_buf, "") == 0)
> > > -                       fprintf(stderr, "Try: ulimit -l unlimited\n");
> > > -               else
> > > -                       fprintf(stderr, "%s", bpf_log_buf);
> > > -               return 1;
> > > +               error = 1;
> > > +               goto cleanup;
> > > +       }
> > > +
> > > +       prog = bpf_program__next(NULL, obj);
> >
> > I'm a bit lazy here, sorry, but isn't the name of the program known?
> > bpf_object__find_program_by_title() is preferable.
> >
>
> I also think it is good to specify the program title clearly.
>
> > > +       if (!prog) {
> > > +               fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
> > > +               error = 1;
> > > +               goto cleanup;
> > > +       }
> > > +
> > > +       map_fd = bpf_object__find_map_fd_by_name(obj, "ip_map");
> > > +       if (map_fd < 0) {
> > > +               fprintf(stderr, "ERROR: finding a map in obj file failed\n");
> > > +               error = 1;
> > > +               goto cleanup;
> > >         }
> > > +
> > >         signal(SIGINT, int_exit);
> > >         signal(SIGTERM, int_exit);
> > >
> > >         /* do sampling */
> > >         printf("Sampling at %d Hertz for %d seconds. Ctrl-C also ends.\n",
> > >                freq, secs);
> > > -       if (sampling_start(pmu_fd, freq) != 0)
> > > -               return 1;
> > > +       if (sampling_start(pmu_fd, freq, prog, link) != 0) {
> > > +               error = 1;
> > > +               goto cleanup;
> > > +       }
> > >         sleep(secs);
> > > -       sampling_end(pmu_fd);
> > > -       free(pmu_fd);
> > > +       sampling_end(link);
> > >
> > >         /* output sample counts */
> > > -       print_ip_map(map_fd[0]);
> > > +       print_ip_map(map_fd);
> > >
> > > -       return 0;
> > > +cleanup:
> > > +       free(pmu_fd);
> > > +       free(link);
> >
> >
> > Uhm... you are freeing this only on clean up. Also, you need to
> > bpf_link__destroy() first. And close all pmu_fds. Surely process exit
> > will ensure all this is cleaned up, but it's a good tone to clean up
> > all resources explicitly.
> >
>
> Well, cleanup: could cover link destroy (sampling_end), but I think
> it is strange to clean up the link even though the bpf program is not
> attached to the event. I think it is better to specify the link destroy
> after the sampling starts.

bpf_link__destroy() is designed in such a way that if passed NULL it
will do nothing. So doing unconditional clean up at the end is clean
and straightforward solution. You'll see it in a bunch of places in
selftests.

>
> And, I've missed the link destroy when sampling got error.
> Since sampling_end will destroy the links, so I'll add this on error.
>
>        if (sampling_start(pmu_fd, freq, prog, link) != 0) {
>                error = 1;
> +             sampling_end(links);
>                goto cleanup;
>        }
>
> > > +       return error;
> > >  }
> > > diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
> > > index 356171bc392b..30c25ef99fc5 100644
> > > --- a/samples/bpf/trace_event_user.c
> > > +++ b/samples/bpf/trace_event_user.c
> > > @@ -6,22 +6,21 @@
> > >  #include <stdlib.h>
> > >  #include <stdbool.h>
> > >  #include <string.h>
> > > -#include <fcntl.h>
> > > -#include <poll.h>
> > > -#include <sys/ioctl.h>
> > >  #include <linux/perf_event.h>
> > >  #include <linux/bpf.h>
> > >  #include <signal.h>
> > > -#include <assert.h>
> > >  #include <errno.h>
> > >  #include <sys/resource.h>
> > > +#include <bpf/bpf.h>
> > >  #include <bpf/libbpf.h>
> > > -#include "bpf_load.h"
> > >  #include "perf-sys.h"
> > >  #include "trace_helpers.h"
> > >
> > >  #define SAMPLE_FREQ 50
> > >
> > > +/* counts, stackmap */
> > > +static int map_fd[2];
> > > +struct bpf_program *prog;
> > >  static bool sys_read_seen, sys_write_seen;
> > >
> > >  static void print_ksym(__u64 addr)
> > > @@ -137,9 +136,16 @@ static inline int generate_load(void)
> > >  static void test_perf_event_all_cpu(struct perf_event_attr *attr)
> > >  {
> > >         int nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
> > > +       struct bpf_link **link = malloc(nr_cpus * sizeof(struct bpf_link *));
> >
> > same as above, calloc() is better choice here
> >
>
> Will apply this at next version patch.
>
> > >         int *pmu_fd = malloc(nr_cpus * sizeof(int));
> > >         int i, error = 0;
> > >
> > > +       if (pmu_fd == NULL || link == NULL) {
> > > +               printf("malloc of pmu_fd/link failed\n");
> > > +               error = 1;
> > > +               goto err;
> > > +       }
> > > +
> > >         /* system wide perf event, no need to inherit */
> > >         attr->inherit = 0;
> > >
> > > @@ -151,8 +157,12 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
> > >                         error = 1;
> > >                         goto all_cpu_err;
> > >                 }
> > > -               assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF, prog_fd[0]) == 0);
> > > -               assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE) == 0);
> > > +               link[i] = bpf_program__attach_perf_event(prog, pmu_fd[i]);
> > > +               if (link[i] < 0) {
> > > +                       printf("bpf_program__attach_perf_event failed\n");
> > > +                       error = 1;
> > > +                       goto all_cpu_err;
> > > +               }
> > >         }
> > >
> > >         if (generate_load() < 0) {
> > > @@ -161,11 +171,11 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
> > >         }
> > >         print_stacks();
> > >  all_cpu_err:
> > > -       for (i--; i >= 0; i--) {
> > > -               ioctl(pmu_fd[i], PERF_EVENT_IOC_DISABLE);
> > > -               close(pmu_fd[i]);
> > > -       }
> > > +       for (i--; i >= 0; i--)
> > > +               bpf_link__destroy(link[i]);
> >
> > still need close(pmu_fd[i]);
> >
>
> AFAIK, bpf_link__detach_perf_event() closes the pmu_fd.
> Am I missed something?

Ah, you are right, I missed that fact. But then you don't need pmu_fd
array at all. Do perf_event_open and then immediately
bpf_program__attach_perf_event().

>
>        static int bpf_link__detach_perf_event(struct bpf_link *link)
>        // TRUNCATED
>                close(link->fd);
>                return err;
>        }
>
> > > +err:
> > >         free(pmu_fd);
> > > +       free(link);
> > >         if (error)
> > >                 int_exit(0);
> >
> >
> > >  }
> > > @@ -173,6 +183,7 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
> > >  static void test_perf_event_task(struct perf_event_attr *attr)
> > >  {
> > >         int pmu_fd, error = 0;
> > > +       struct bpf_link *link;
> > >
> > >         /* per task perf event, enable inherit so the "dd ..." command can be traced properly.
> > >          * Enabling inherit will cause bpf_perf_prog_read_time helper failure.
> > > @@ -185,8 +196,12 @@ static void test_perf_event_task(struct perf_event_attr *attr)
> > >                 printf("sys_perf_event_open failed\n");
> > >                 int_exit(0);
> > >         }
> > > -       assert(ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd[0]) == 0);
> > > -       assert(ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE) == 0);
> > > +       link = bpf_program__attach_perf_event(prog, pmu_fd);
> > > +       if (link < 0) {
> > > +               printf("bpf_program__attach_perf_event failed\n");
> > > +               close(pmu_fd);
> > > +               int_exit(0);
> > > +       }
> > >
> > >         if (generate_load() < 0) {
> > >                 error = 1;
> > > @@ -194,8 +209,7 @@ static void test_perf_event_task(struct perf_event_attr *attr)
> > >         }
> > >         print_stacks();
> > >  err:
> > > -       ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
> > > -       close(pmu_fd);
> > > +       bpf_link__destroy(link);
> > >         if (error)
> > >                 int_exit(0);
> >
> > This will exit with 0 error code and won't notify about error... Pass
> > through err?
> >
>
> You're right. Missed the return code.
> Will apply this at next version patch.
>
> > >  }
> > > @@ -282,7 +296,9 @@ static void test_bpf_perf_event(void)
> > >  int main(int argc, char **argv)
> > >  {
> > >         struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
> > > +       struct bpf_object *obj;
> > >         char filename[256];
> > > +       int prog_fd;
> > >
> > >         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > >         setrlimit(RLIMIT_MEMLOCK, &r);
> > > @@ -295,9 +311,20 @@ int main(int argc, char **argv)
> > >                 return 1;
> > >         }
> > >
> > > -       if (load_bpf_file(filename)) {
> > > -               printf("%s", bpf_log_buf);
> > > -               return 2;
> > > +       if (bpf_prog_load(filename, BPF_PROG_TYPE_PERF_EVENT, &obj, &prog_fd))
> > > +               return 1;
> > > +
> > > +       prog = bpf_program__next(NULL, obj);
> > > +       if (!prog) {
> > > +               printf("finding a prog in obj file failed\n");
> > > +               return 1;
> > > +       }
> > > +
> > > +       map_fd[0] = bpf_object__find_map_fd_by_name(obj, "counts");
> > > +       map_fd[1] = bpf_object__find_map_fd_by_name(obj, "stackmap");
> > > +       if (map_fd[0] < 0 || map_fd[1] < 0) {
> > > +               printf("finding a counts/stackmap map in obj file failed\n");
> > > +               return 1;
> > >         }
> > >
> > >         if (fork() == 0) {
> > > --
> > > 2.25.1
> > >
>
> Thank you for your detailed review!
>
> Best,
> Daniel
