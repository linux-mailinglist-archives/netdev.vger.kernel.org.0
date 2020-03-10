Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1DA7180BDD
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgCJWtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:49:47 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:36576 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgCJWtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:49:47 -0400
Received: by mail-yw1-f68.google.com with SMTP id j71so215312ywb.3;
        Tue, 10 Mar 2020 15:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NQQs5W1LhTDa+nWS8+wt3ZOkdPoaJi67Ndb9ugZKALA=;
        b=LYW1f1mzWI6E+5wO0XQrBT0QZBVkQYIdr9igvqSjyPSL6jMVp9acEFbBXU+Ylpc351
         ZnKzM7LpubaApuhloL57StDJKAZWlWZXk9KdXr0ed6QhNrSPRMIvQYqnas+RCV9X4eoE
         iVK4PG0bZo7yPgsyNtVx++xMFCA/8h5joj9meCPaS88B7Z3KJ+tVZsrDrme6VjfrH34/
         0rLKgwuuOh2Y2Mzbat68m+kkJf7yMXlm249wa9T+BQlfZXmLKDqm7SpoCF9ebaKCCay6
         m/MqQq0Cp4h36FG8vPE1TWeSrMm7tOCFb7r+0Gl+H+un9CeZtg4RMCbco5vBQZTT2fIr
         S1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NQQs5W1LhTDa+nWS8+wt3ZOkdPoaJi67Ndb9ugZKALA=;
        b=cwSG6EagY37bQ7u+wxDtAeIzS77Y+ORA0OSZKmP3nceRAnUJQbIGp2uq1JwxZQbhfQ
         ermf4fy63HKUaN6HOg2Tw6J70SiUIufoCRwpIrW9lIw8jPLI78J5+S04e7vA+3WQSupn
         0F3REIEuJ6kDPVY7uPn7hfVWOIjL0mYPLmjDj0hdGBa0uf+LjBEBG10eceQyNx0uTAkW
         StHIPs4pg7a/Sp9JcrMi96KinlI5QLEG2+jdHX/kUPkbDzQlwccgLnZ52Clr3OtFPJXt
         vK9YTc0c5+92O/+slV/wR0uDFuCxWi+VuUK8OLQXc00+DMlzqHRpJy8bIdH7PFoTITzF
         igzg==
X-Gm-Message-State: ANhLgQ2kZQ+jxjkzDQ9yvtefo7coGSM/YxVn84IsnBn/TH8KdOg9B7Xf
        oPwAzOvjaTroYVMnCdg8ciQnLQP1pRx+y3raTQ==
X-Google-Smtp-Source: ADFU+vvpnwaWNoWtAojVmKw5umhxF9GRV79XyHgfhHGWpeLL4vCktQJ4+MThVr7Atu99Ml1Nn6WsNp7rWLfWrHdUch4=
X-Received: by 2002:a25:aa4f:: with SMTP id s73mr23716ybi.306.1583880584566;
 Tue, 10 Mar 2020 15:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200310055147.26678-1-danieltimlee@gmail.com>
 <20200310055147.26678-3-danieltimlee@gmail.com> <5e6807c39b0b1_586d2b10f16785b8eb@john-XPS-13-9370.notmuch>
In-Reply-To: <5e6807c39b0b1_586d2b10f16785b8eb@john-XPS-13-9370.notmuch>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 11 Mar 2020 07:49:28 +0900
Message-ID: <CAEKGpziMNonMiPa++zZT2G0QDUGCz_BcstPaboCXC9Jr8tqUWw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] samples: bpf: refactor perf_event user
 program with libbpf bpf_link
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 6:34 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Daniel T. Lee wrote:
> > The bpf_program__attach of libbpf(using bpf_link) is much more intuitive
> > than the previous method using ioctl.
> >
> > bpf_program__attach_perf_event manages the enable of perf_event and
> > attach of BPF programs to it, so there's no neeed to do this
> > directly with ioctl.
> >
> > In addition, bpf_link provides consistency in the use of API because it
> > allows disable (detach, destroy) for multiple events to be treated as
> > one bpf_link__destroy.
> >
> > This commit refactors samples that attach the bpf program to perf_event
> > by using libbbpf instead of ioctl. Also the bpf_load in the samples were
> > removed and migrated to use libbbpf API.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
>
> [...]
>
> >
> >  int main(int argc, char **argv)
> >  {
> > +     int prog_fd, *pmu_fd, opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS;
> > +     struct bpf_program *prog;
> > +     struct bpf_object *obj;
> > +     struct bpf_link **link;
> >       char filename[256];
> > -     int *pmu_fd, opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS;
> >
> >       /* process arguments */
> >       while ((opt = getopt(argc, argv, "F:h")) != -1) {
> > @@ -165,36 +170,47 @@ int main(int argc, char **argv)
> >       /* create perf FDs for each CPU */
> >       nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
> >       pmu_fd = malloc(nr_cpus * sizeof(int));
> > -     if (pmu_fd == NULL) {
> > -             fprintf(stderr, "ERROR: malloc of pmu_fd\n");
> > +     link = malloc(nr_cpus * sizeof(struct bpf_link *));
> > +     if (pmu_fd == NULL || link == NULL) {
> > +             fprintf(stderr, "ERROR: malloc of pmu_fd/link\n");
> >               return 1;
> >       }
> >
> >       /* load BPF program */
> >       snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > -     if (load_bpf_file(filename)) {
> > +     if (bpf_prog_load(filename, BPF_PROG_TYPE_PERF_EVENT, &obj, &prog_fd)) {
> >               fprintf(stderr, "ERROR: loading BPF program (errno %d):\n",
> >                       errno);
> > -             if (strcmp(bpf_log_buf, "") == 0)
> > -                     fprintf(stderr, "Try: ulimit -l unlimited\n");
> > -             else
> > -                     fprintf(stderr, "%s", bpf_log_buf);
> >               return 1;
> >       }
> > +
> > +     prog = bpf_program__next(NULL, obj);
> > +     if (!prog) {
> > +             printf("finding a prog in obj file failed\n");
> > +             return 1;
> > +     }
> > +
> > +     map_fd = bpf_object__find_map_fd_by_name(obj, "ip_map");
> > +     if (map_fd < 0) {
> > +             printf("finding a ip_map map in obj file failed\n");
> > +             return 1;
> > +     }
> > +
> >       signal(SIGINT, int_exit);
> >       signal(SIGTERM, int_exit);
> >
> >       /* do sampling */
> >       printf("Sampling at %d Hertz for %d seconds. Ctrl-C also ends.\n",
> >              freq, secs);
> > -     if (sampling_start(pmu_fd, freq) != 0)
> > +     if (sampling_start(pmu_fd, freq, prog, link) != 0)
> >               return 1;
> >       sleep(secs);
> > -     sampling_end(pmu_fd);
> > +     sampling_end(link);
> >       free(pmu_fd);
> > +     free(link);
>
> Not really a problem with this patch but on error we don't free() memory but
> then on normal exit there is a free() its a bit inconsistent. How about adding
> free on errors as well?

I think you're right.
I'll add free() on errors to keep it consistent.
Will apply feedback right away!

>
> >
> >       /* output sample counts */
> > -     print_ip_map(map_fd[0]);
> > +     print_ip_map(map_fd);
> >
> >       return 0;
> >  }
>
> [...]
>
> >  static void print_ksym(__u64 addr)
> > @@ -137,6 +136,7 @@ static inline int generate_load(void)
> >  static void test_perf_event_all_cpu(struct perf_event_attr *attr)
> >  {
> >       int nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
> > +     struct bpf_link **link = malloc(nr_cpus * sizeof(struct bpf_link *));
>
> need to check if its null? Its not going to be very friendly to segfault
> later. Or maybe I'm missing the check.
>

Also, checking whether it is null will be more safe.
I'll apply and send next version patch.

> >       int *pmu_fd = malloc(nr_cpus * sizeof(int));
> >       int i, error = 0;
> >
> > @@ -151,8 +151,12 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
> >                       error = 1;
> >                       goto all_cpu_err;
> >               }
> > -             assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF, prog_fd[0]) == 0);
> > -             assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE) == 0);
> > +             link[i] = bpf_program__attach_perf_event(prog, pmu_fd[i]);
> > +             if (link[i] < 0) {
> > +                     printf("bpf_program__attach_perf_event failed\n");
> > +                     error = 1;
> > +                     goto all_cpu_err;
> > +             }
> >       }
> >
> >       if (generate_load() < 0) {
> > @@ -161,11 +165,11 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
> >       }
> >       print_stacks();
> >  all_cpu_err:
> > -     for (i--; i >= 0; i--) {
> > -             ioctl(pmu_fd[i], PERF_EVENT_IOC_DISABLE);
> > -             close(pmu_fd[i]);
> > -     }
> > +     for (i--; i >= 0; i--)
> > +             bpf_link__destroy(link[i]);
> > +
> >       free(pmu_fd);
> > +     free(link);
> >       if (error)
> >               int_exit(0);
> >  }
>
> Thanks,
> John

Thank you for your time and effort for the review.

Best,
Daniel
