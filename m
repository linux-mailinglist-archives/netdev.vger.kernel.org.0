Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4CE2B748A
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 04:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgKRDFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 22:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgKRDFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 22:05:40 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82FCC0613D4;
        Tue, 17 Nov 2020 19:05:40 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id t10so61279oon.4;
        Tue, 17 Nov 2020 19:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W9Uk7sPcGuIWO9E81fPHMswb/wHTCJc4Sr3+u5F/3sU=;
        b=sNzzaYhe6xTS/Q+F1GjTJd7UGiit8PghbDfuDx4pzfqt4ua41RG5gudFj5bCBBghYt
         4x2z/jJiW+0F6GHHR/R5Njeh9Q6dmS+003/WZNZk7moNgTWyzK1vbd/AglhihF0s5XIP
         OHc5dorfnVU1rR0oqvxbRrZctjLVcyI0znqkNrKZsYQaZ1D/MGhCiCWlqf2PBIqTx24E
         of1wwsDsEJPybs/DcHafQs0Nsortu4ggjtGI/OjAbTxcCsAoW8sSzxjvxyxo7XAXPxJK
         pMXDQcKgXEpcIaqQCeLj/J9VlP6r+2u4TMTVfUHRQ0Pj36f/gw74/BgP4N/Ct1I1/Cgk
         CjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W9Uk7sPcGuIWO9E81fPHMswb/wHTCJc4Sr3+u5F/3sU=;
        b=aPNl/r9zZ8N6xvuWGrWMz/bhiUic2aG9bUsPx4tlqUWTSJ/a9aBJVufK6fmXui+/9t
         rHNSVYXIOScQioLFzJsCXCEUqcm96s/HU9JpTM9OzsP2z4SWgY7/eHMPaBntxpUw12rX
         CpLhz4kvOL2Ok76E1/I9wUZmKYGwZGKjaHB6oG9HUFc1Z7keyebtm7F4KHkBcNyyW9wu
         dOEPFV9v3zZc3JTkkQGwQAak3Q2zLyln2BcPtZhB38dWMo9xMDWQmir74fTWe8/++tiI
         zK3DQ0KgBoWZ545acw5HlkXB5fxuKintmL1heWmHnJmtUo10BdFbSorVgTPWA6gF3Ysi
         xhCw==
X-Gm-Message-State: AOAM531Wf6DfYgfuHi0nBEj7N3wpLQCpWC3xVYiT6TTWOBOBONc3GCs6
        Cj2/gGH6SgeyoHye6wXTvYF4ydmRKgh2t0bqXA==
X-Google-Smtp-Source: ABdhPJxMutGeonDLozW4fnsQPpXmbaqSonIztpjQbAb+tG5HBcsmxnW0F540V1pUg6v2MOYBkfnmLM3ldw6WtYiK9As=
X-Received: by 2002:a4a:4085:: with SMTP id n127mr5163812ooa.80.1605668740048;
 Tue, 17 Nov 2020 19:05:40 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-6-danieltimlee@gmail.com> <CAEf4BzZBjVw4ptGZE8V9SM4htW_Nf_TjXkUKEHjF9bxgO43DQA@mail.gmail.com>
In-Reply-To: <CAEf4BzZBjVw4ptGZE8V9SM4htW_Nf_TjXkUKEHjF9bxgO43DQA@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 18 Nov 2020 12:05:24 +0900
Message-ID: <CAEKGpzisb+6nZ8AQ6nOu6tdPPZzjqAox1AzvYYd5-J3c7N9joQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/9] samples: bpf: refactor ibumad program with libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:52 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > This commit refactors the existing ibumad program with libbpf bpf
> > loader. Attach/detach of Tracepoint bpf programs has been managed
> > with the generic bpf_program__attach() and bpf_link__destroy() from
> > the libbpf.
> >
> > Also, instead of using the previous BPF MAP definition, this commit
> > refactors ibumad MAP definition with the new BTF-defined MAP format.
> >
> > To verify that this bpf program works without an infiniband device,
> > try loading ib_umad kernel module and test the program as follows:
> >
> >     # modprobe ib_umad
> >     # ./ibumad
> >
> > Moreover, TRACE_HELPERS has been removed from the Makefile since it is
> > not used on this program.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/Makefile      |  2 +-
> >  samples/bpf/ibumad_kern.c | 26 +++++++--------
> >  samples/bpf/ibumad_user.c | 66 ++++++++++++++++++++++++++++++---------
> >  3 files changed, 65 insertions(+), 29 deletions(-)
> >
> > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > index 36b261c7afc7..bfa595379493 100644
> > --- a/samples/bpf/Makefile
> > +++ b/samples/bpf/Makefile
> > @@ -109,7 +109,7 @@ xsk_fwd-objs := xsk_fwd.o
> >  xdp_fwd-objs := xdp_fwd_user.o
> >  task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
> >  xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
> > -ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
> > +ibumad-objs := ibumad_user.o
> >  hbm-objs := hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
> >
> >  # Tell kbuild to always build the programs
> > diff --git a/samples/bpf/ibumad_kern.c b/samples/bpf/ibumad_kern.c
> > index 3a91b4c1989a..26dcd4dde946 100644
> > --- a/samples/bpf/ibumad_kern.c
> > +++ b/samples/bpf/ibumad_kern.c
> > @@ -16,19 +16,19 @@
> >  #include <bpf/bpf_helpers.h>
> >
> >
> > -struct bpf_map_def SEC("maps") read_count = {
> > -       .type        = BPF_MAP_TYPE_ARRAY,
> > -       .key_size    = sizeof(u32), /* class; u32 required */
> > -       .value_size  = sizeof(u64), /* count of mads read */
> > -       .max_entries = 256, /* Room for all Classes */
> > -};
> > -
> > -struct bpf_map_def SEC("maps") write_count = {
> > -       .type        = BPF_MAP_TYPE_ARRAY,
> > -       .key_size    = sizeof(u32), /* class; u32 required */
> > -       .value_size  = sizeof(u64), /* count of mads written */
> > -       .max_entries = 256, /* Room for all Classes */
> > -};
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > +       __type(key, u32); /* class; u32 required */
> > +       __type(value, u64); /* count of mads read */
> > +       __uint(max_entries, 256); /* Room for all Classes */
> > +} read_count SEC(".maps");
> > +
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > +       __type(key, u32); /* class; u32 required */
> > +       __type(value, u64); /* count of mads written */
> > +       __uint(max_entries, 256); /* Room for all Classes */
> > +} write_count SEC(".maps");
> >
> >  #undef DEBUG
> >  #ifndef DEBUG
> > diff --git a/samples/bpf/ibumad_user.c b/samples/bpf/ibumad_user.c
> > index fa06eef31a84..66a06272f242 100644
> > --- a/samples/bpf/ibumad_user.c
> > +++ b/samples/bpf/ibumad_user.c
> > @@ -23,10 +23,15 @@
> >  #include <getopt.h>
> >  #include <net/if.h>
> >
> > -#include "bpf_load.h"
> > +#include <bpf/bpf.h>
> >  #include "bpf_util.h"
> >  #include <bpf/libbpf.h>
> >
> > +struct bpf_link *tp_links[3] = {};
> > +struct bpf_object *obj;
>
> statics and you can drop = {} part.
>
> > +static int map_fd[2];
> > +static int tp_cnt;
> > +
> >  static void dump_counts(int fd)
> >  {
> >         __u32 key;
> > @@ -53,6 +58,11 @@ static void dump_all_counts(void)
> >  static void dump_exit(int sig)
> >  {
> >         dump_all_counts();
> > +       /* Detach tracepoints */
> > +       while (tp_cnt)
> > +               bpf_link__destroy(tp_links[--tp_cnt]);
> > +
> > +       bpf_object__close(obj);
> >         exit(0);
> >  }
> >
> > @@ -73,19 +83,11 @@ static void usage(char *cmd)
> >
> >  int main(int argc, char **argv)
> >  {
> > +       struct bpf_program *prog;
> >         unsigned long delay = 5;
> > +       char filename[256];
> >         int longindex = 0;
> >         int opt;
> > -       char bpf_file[256];
> > -
> > -       /* Create the eBPF kernel code path name.
> > -        * This follows the pattern of all of the other bpf samples
> > -        */
> > -       snprintf(bpf_file, sizeof(bpf_file), "%s_kern.o", argv[0]);
> > -
> > -       /* Do one final dump when exiting */
> > -       signal(SIGINT, dump_exit);
> > -       signal(SIGTERM, dump_exit);
> >
> >         while ((opt = getopt_long(argc, argv, "hd:rSw",
> >                                   long_options, &longindex)) != -1) {
> > @@ -107,10 +109,38 @@ int main(int argc, char **argv)
> >                 }
> >         }
> >
> > -       if (load_bpf_file(bpf_file)) {
> > -               fprintf(stderr, "ERROR: failed to load eBPF from file : %s\n",
> > -                       bpf_file);
> > -               return 1;
> > +       /* Do one final dump when exiting */
> > +       signal(SIGINT, dump_exit);
> > +       signal(SIGTERM, dump_exit);
> > +
> > +       snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > +       obj = bpf_object__open_file(filename, NULL);
> > +       if (libbpf_get_error(obj)) {
> > +               fprintf(stderr, "ERROR: opening BPF object file failed\n");
> > +               return 0;
>
> not really a success, no?
>
> > +       }
> > +
> > +       /* load BPF program */
> > +       if (bpf_object__load(obj)) {
> > +               fprintf(stderr, "ERROR: loading BPF object file failed\n");
> > +               goto cleanup;
> > +       }
> > +
> > +       map_fd[0] = bpf_object__find_map_fd_by_name(obj, "read_count");
> > +       map_fd[1] = bpf_object__find_map_fd_by_name(obj, "write_count");
> > +       if (map_fd[0] < 0 || map_fd[1] < 0) {
> > +               fprintf(stderr, "ERROR: finding a map in obj file failed\n");
> > +               goto cleanup;
> > +       }
> > +
> > +       bpf_object__for_each_program(prog, obj) {
> > +               tp_links[tp_cnt] = bpf_program__attach(prog);
> > +               if (libbpf_get_error(tp_links[tp_cnt])) {
> > +                       fprintf(stderr, "ERROR: bpf_program__attach failed\n");
> > +                       tp_links[tp_cnt] = NULL;
> > +                       goto cleanup;
> > +               }
> > +               tp_cnt++;
> >         }
>
> This cries for the BPF skeleton... But one step at a time :)
>

I will make sure it'll be updated by using skeleton next time. :D

> >
> >         while (1) {
> > @@ -118,5 +148,11 @@ int main(int argc, char **argv)
> >                 dump_all_counts();
> >         }
> >
> > +cleanup:
> > +       /* Detach tracepoints */
> > +       while (tp_cnt)
> > +               bpf_link__destroy(tp_links[--tp_cnt]);
> > +
> > +       bpf_object__close(obj);
> >         return 0;
>
> same, in a lot of cases it's not a success, probably need int err
> variable somewhere.
>

I will correct the return code and send the next version of patch.

Thanks for your time and effort for the review.

-- 
Best,
Daniel T. Lee
