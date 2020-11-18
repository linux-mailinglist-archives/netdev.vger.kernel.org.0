Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531392B7491
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 04:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgKRDLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 22:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgKRDK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 22:10:59 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5380C0613D4;
        Tue, 17 Nov 2020 19:10:57 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id k65so308228ybk.5;
        Tue, 17 Nov 2020 19:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QbRb6TdolaYR9gVmqJPH3EZln+nw+IPd1xC0uCpNazs=;
        b=jiVPFiq/QQbl86ISWNxklsb6ILdczlBzU0IgzdMdZR35n5BZFtpIhWmPVK5l11zMxw
         Rp2cyAy2pUwYqAbS3WNhlpSxZoYwfUlnRVsXBBYkR77VFDsX06htERsCABSBvlQs875x
         RRBQC1zqryWOhbmPhNQiAiWW7nDXl8LpPlq8qWO+m63Jz6PMDZrqwRjFH9OpSrkQ1Jqj
         kJQ0oFDGTbMJIIfclF+9hEOQSrnGqobMDLb11ZxXt/o5LUJkRkarHjQw1iZn/XFAWw4R
         n7TKoIdJvCBaYiIg7WIN/i2QVMrjjthsm+95WLq4GpdnVaj8/FJuUIF31IGoX9+M1EKy
         buww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QbRb6TdolaYR9gVmqJPH3EZln+nw+IPd1xC0uCpNazs=;
        b=fE4wddh7JoESyvkY1QgZj5WkNe9WLP/2KSMSy2ugzlFhT7fqadbp9RgP+eNlZW/zxU
         awNWEHXxeaEB3LYO5KQTxl1d/Gf0OWQ5/5/kTos4kQVlpVCKBj28uGj1rLoUDd6DIygH
         O/ubfUwp1t42y0cqLhOkMOrZ1drKI8XRuI75MnY2qQ7gLVYVuyDVt9UERCuY+U2If1L+
         OW04Wfhd+X9WaeWR2/wNWLztoKGbJWNL08/S1JW4bVCXlP+/dnDv68KtQv7LOupqsVnu
         gKX39To02Q4BHhM58w+90lfFZuNTkJ2vNSnj6F4rF/xwe7kvb9a4fJ7hPyEs5J9yE5EW
         vhKQ==
X-Gm-Message-State: AOAM531XeSU4ULQdz+f++fxDH7RF2pB0HGBp71V357E0kybzhBY4z8hZ
        gsD64SgAx0adyQC3npg+NrtL93a5/FG2CTTuJEkSpac3Fw2OQA==
X-Google-Smtp-Source: ABdhPJxk5V8Oq70iOXrMI9eyazdiOG/g0ZX7UfpkSxRYyYCoyR0dk1dedU5lsdJs7iNu4puQJhOSI3zCeDGGvfoNdYg=
X-Received: by 2002:a25:df82:: with SMTP id w124mr4090393ybg.347.1605669057118;
 Tue, 17 Nov 2020 19:10:57 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-6-danieltimlee@gmail.com> <CAEf4BzZBjVw4ptGZE8V9SM4htW_Nf_TjXkUKEHjF9bxgO43DQA@mail.gmail.com>
 <CAEKGpzisb+6nZ8AQ6nOu6tdPPZzjqAox1AzvYYd5-J3c7N9joQ@mail.gmail.com>
In-Reply-To: <CAEKGpzisb+6nZ8AQ6nOu6tdPPZzjqAox1AzvYYd5-J3c7N9joQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 19:10:46 -0800
Message-ID: <CAEf4BzbOLqX-xXjjbzc_5pDKZzKH+X74oAsXgs_1PtWod=3TAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/9] samples: bpf: refactor ibumad program with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
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

On Tue, Nov 17, 2020 at 7:05 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Wed, Nov 18, 2020 at 11:52 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > This commit refactors the existing ibumad program with libbpf bpf
> > > loader. Attach/detach of Tracepoint bpf programs has been managed
> > > with the generic bpf_program__attach() and bpf_link__destroy() from
> > > the libbpf.
> > >
> > > Also, instead of using the previous BPF MAP definition, this commit
> > > refactors ibumad MAP definition with the new BTF-defined MAP format.
> > >
> > > To verify that this bpf program works without an infiniband device,
> > > try loading ib_umad kernel module and test the program as follows:
> > >
> > >     # modprobe ib_umad
> > >     # ./ibumad
> > >
> > > Moreover, TRACE_HELPERS has been removed from the Makefile since it is
> > > not used on this program.
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > ---
> > >  samples/bpf/Makefile      |  2 +-
> > >  samples/bpf/ibumad_kern.c | 26 +++++++--------
> > >  samples/bpf/ibumad_user.c | 66 ++++++++++++++++++++++++++++++---------
> > >  3 files changed, 65 insertions(+), 29 deletions(-)
> > >
> > > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > > index 36b261c7afc7..bfa595379493 100644
> > > --- a/samples/bpf/Makefile
> > > +++ b/samples/bpf/Makefile
> > > @@ -109,7 +109,7 @@ xsk_fwd-objs := xsk_fwd.o
> > >  xdp_fwd-objs := xdp_fwd_user.o
> > >  task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
> > >  xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
> > > -ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
> > > +ibumad-objs := ibumad_user.o
> > >  hbm-objs := hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
> > >
> > >  # Tell kbuild to always build the programs
> > > diff --git a/samples/bpf/ibumad_kern.c b/samples/bpf/ibumad_kern.c
> > > index 3a91b4c1989a..26dcd4dde946 100644
> > > --- a/samples/bpf/ibumad_kern.c
> > > +++ b/samples/bpf/ibumad_kern.c
> > > @@ -16,19 +16,19 @@
> > >  #include <bpf/bpf_helpers.h>
> > >
> > >
> > > -struct bpf_map_def SEC("maps") read_count = {
> > > -       .type        = BPF_MAP_TYPE_ARRAY,
> > > -       .key_size    = sizeof(u32), /* class; u32 required */
> > > -       .value_size  = sizeof(u64), /* count of mads read */
> > > -       .max_entries = 256, /* Room for all Classes */
> > > -};
> > > -
> > > -struct bpf_map_def SEC("maps") write_count = {
> > > -       .type        = BPF_MAP_TYPE_ARRAY,
> > > -       .key_size    = sizeof(u32), /* class; u32 required */
> > > -       .value_size  = sizeof(u64), /* count of mads written */
> > > -       .max_entries = 256, /* Room for all Classes */
> > > -};
> > > +struct {
> > > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > > +       __type(key, u32); /* class; u32 required */
> > > +       __type(value, u64); /* count of mads read */
> > > +       __uint(max_entries, 256); /* Room for all Classes */
> > > +} read_count SEC(".maps");
> > > +
> > > +struct {
> > > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > > +       __type(key, u32); /* class; u32 required */
> > > +       __type(value, u64); /* count of mads written */
> > > +       __uint(max_entries, 256); /* Room for all Classes */
> > > +} write_count SEC(".maps");
> > >
> > >  #undef DEBUG
> > >  #ifndef DEBUG
> > > diff --git a/samples/bpf/ibumad_user.c b/samples/bpf/ibumad_user.c
> > > index fa06eef31a84..66a06272f242 100644
> > > --- a/samples/bpf/ibumad_user.c
> > > +++ b/samples/bpf/ibumad_user.c
> > > @@ -23,10 +23,15 @@
> > >  #include <getopt.h>
> > >  #include <net/if.h>
> > >
> > > -#include "bpf_load.h"
> > > +#include <bpf/bpf.h>
> > >  #include "bpf_util.h"
> > >  #include <bpf/libbpf.h>
> > >
> > > +struct bpf_link *tp_links[3] = {};
> > > +struct bpf_object *obj;
> >
> > statics and you can drop = {} part.
> >
> > > +static int map_fd[2];
> > > +static int tp_cnt;
> > > +
> > >  static void dump_counts(int fd)
> > >  {
> > >         __u32 key;
> > > @@ -53,6 +58,11 @@ static void dump_all_counts(void)
> > >  static void dump_exit(int sig)
> > >  {
> > >         dump_all_counts();
> > > +       /* Detach tracepoints */
> > > +       while (tp_cnt)
> > > +               bpf_link__destroy(tp_links[--tp_cnt]);
> > > +
> > > +       bpf_object__close(obj);
> > >         exit(0);
> > >  }
> > >
> > > @@ -73,19 +83,11 @@ static void usage(char *cmd)
> > >
> > >  int main(int argc, char **argv)
> > >  {
> > > +       struct bpf_program *prog;
> > >         unsigned long delay = 5;
> > > +       char filename[256];
> > >         int longindex = 0;
> > >         int opt;
> > > -       char bpf_file[256];
> > > -
> > > -       /* Create the eBPF kernel code path name.
> > > -        * This follows the pattern of all of the other bpf samples
> > > -        */
> > > -       snprintf(bpf_file, sizeof(bpf_file), "%s_kern.o", argv[0]);
> > > -
> > > -       /* Do one final dump when exiting */
> > > -       signal(SIGINT, dump_exit);
> > > -       signal(SIGTERM, dump_exit);
> > >
> > >         while ((opt = getopt_long(argc, argv, "hd:rSw",
> > >                                   long_options, &longindex)) != -1) {
> > > @@ -107,10 +109,38 @@ int main(int argc, char **argv)
> > >                 }
> > >         }
> > >
> > > -       if (load_bpf_file(bpf_file)) {
> > > -               fprintf(stderr, "ERROR: failed to load eBPF from file : %s\n",
> > > -                       bpf_file);
> > > -               return 1;
> > > +       /* Do one final dump when exiting */
> > > +       signal(SIGINT, dump_exit);
> > > +       signal(SIGTERM, dump_exit);
> > > +
> > > +       snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > > +       obj = bpf_object__open_file(filename, NULL);
> > > +       if (libbpf_get_error(obj)) {
> > > +               fprintf(stderr, "ERROR: opening BPF object file failed\n");
> > > +               return 0;
> >
> > not really a success, no?
> >
> > > +       }
> > > +
> > > +       /* load BPF program */
> > > +       if (bpf_object__load(obj)) {
> > > +               fprintf(stderr, "ERROR: loading BPF object file failed\n");
> > > +               goto cleanup;
> > > +       }
> > > +
> > > +       map_fd[0] = bpf_object__find_map_fd_by_name(obj, "read_count");
> > > +       map_fd[1] = bpf_object__find_map_fd_by_name(obj, "write_count");
> > > +       if (map_fd[0] < 0 || map_fd[1] < 0) {
> > > +               fprintf(stderr, "ERROR: finding a map in obj file failed\n");
> > > +               goto cleanup;
> > > +       }
> > > +
> > > +       bpf_object__for_each_program(prog, obj) {
> > > +               tp_links[tp_cnt] = bpf_program__attach(prog);
> > > +               if (libbpf_get_error(tp_links[tp_cnt])) {
> > > +                       fprintf(stderr, "ERROR: bpf_program__attach failed\n");
> > > +                       tp_links[tp_cnt] = NULL;
> > > +                       goto cleanup;
> > > +               }
> > > +               tp_cnt++;
> > >         }
> >
> > This cries for the BPF skeleton... But one step at a time :)
> >
>
> I will make sure it'll be updated by using skeleton next time. :D
>
> > >
> > >         while (1) {
> > > @@ -118,5 +148,11 @@ int main(int argc, char **argv)
> > >                 dump_all_counts();
> > >         }
> > >
> > > +cleanup:
> > > +       /* Detach tracepoints */
> > > +       while (tp_cnt)
> > > +               bpf_link__destroy(tp_links[--tp_cnt]);
> > > +
> > > +       bpf_object__close(obj);
> > >         return 0;
> >
> > same, in a lot of cases it's not a success, probably need int err
> > variable somewhere.
> >
>
> I will correct the return code and send the next version of patch.
>
> Thanks for your time and effort for the review.

You don't have to write that every time :) It's an implicit contract:
you contribute your time to prepare, test, and submit a patch.
Maintainers and reviewers contribute theirs to review, maybe improve,
and eventually apply it. Together as a community we move the needle.

>
> --
> Best,
> Daniel T. Lee
