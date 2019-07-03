Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA4A5E982
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfGCQrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:47:53 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38663 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCQrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 12:47:53 -0400
Received: by mail-qk1-f195.google.com with SMTP id a27so3308929qkk.5;
        Wed, 03 Jul 2019 09:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2MGLIHa0aPi5UYoxb7mE3cQ9tajA1q6hgevBc/dfVN4=;
        b=NhwKEHnyGpl69IyZCCoBNWrjg8S4Pzv8b+DwsOdpknCtYXKqnKT45sAEnOIWdmQlim
         11RhZnWmWT73mDa+fTOfrYeSsxQuf/nxNc1MVtyQEgRyppRrw903sYe13hxdyNYYU6ig
         tGQAmr5DvpOVN9PE2jDWFBqC8nwMYCoKEFyusyHGrjtpsqWE3Ejb0axD9AwtwX7N4ekD
         V06EhtCjEr/vucX8NI1GyfC5Ut5IpmAuZjNpiMwLvoAYTPUrJY80X+6LowAU/v81Ngy5
         4aLoHBiWl9tPTymjn6R6D8fFTPqcb1O9TI+O7OfnaW/nSWdZbka3U1z4Anz1JEp56sjx
         zLhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2MGLIHa0aPi5UYoxb7mE3cQ9tajA1q6hgevBc/dfVN4=;
        b=oH493H4fagjxzAOBgP78c8di/UyoPrZYqYOICr+eI+U0JUFn2pOmxqhoEJa0LAAsRW
         8ZEh8W5odI9TlYzkDyCU3WCu3tY8mKxGh5PJVfdZmgI/p6ajOKo0VEYYYM5/kGdinxSY
         ZFmEcbf1YEAWqwpE7gsTsBATXa1einWocs7/WXe63lYN3gzXKJRjBatwhQ3hp6HiMvct
         WP12+UYAer90t3viJPL2oUN+5fwIH1Y8/Tq/83JSNO1mUDf88WHXf6se+cXPAeq3ET+w
         iVC1HvgcrNYpGYZKl4SU2rlnpamiIsGZmRN18jjrAaJ7ub7pGuj1qqNgqi3s7hfz26qu
         4NOA==
X-Gm-Message-State: APjAAAX8bqXIGN5QhOGq+LoYpLxMKCRGdtBptwoWlBz7NeipmgssGSkT
        wgMAq0sq4O5BujRzAPUlN4l4EhfV0FlnnARiw/0=
X-Google-Smtp-Source: APXvYqxH5MFFkaonPM3EOnyCoJLCO5xkXuF2ZafYpdsAs93M2r8TnQJ6cLcMXWmBtQgUxs84gqGHUGL0NWZ+h8CfKik=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr31350113qkj.39.1562172471793;
 Wed, 03 Jul 2019 09:47:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190701235903.660141-1-andriin@fb.com> <20190701235903.660141-5-andriin@fb.com>
 <5e494d84-5db9-3d57-ccb3-c619cbae7833@iogearbox.net>
In-Reply-To: <5e494d84-5db9-3d57-ccb3-c619cbae7833@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 3 Jul 2019 09:47:40 -0700
Message-ID: <CAEf4BzaHM5432VS-1wDxKJXr7U-9zkM+A_XsU+1p77YCd8VRgg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 5:39 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 07/02/2019 01:58 AM, Andrii Nakryiko wrote:
> > Add ability to attach to kernel and user probes and retprobes.
> > Implementation depends on perf event support for kprobes/uprobes.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > Reviewed-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/lib/bpf/libbpf.c   | 169 +++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/libbpf.h   |   7 ++
> >  tools/lib/bpf/libbpf.map |   2 +
> >  3 files changed, 178 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index bcaa294f819d..7b6142408b15 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4021,6 +4021,175 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> >       return (struct bpf_link *)link;
> >  }
> >
> > +/*
> > + * this function is expected to parse integer in the range of [0, 2^31-1] from
> > + * given file using scanf format string fmt. If actual parsed value is
> > + * negative, the result might be indistinguishable from error
> > + */
> > +static int parse_uint_from_file(const char *file, const char *fmt)
> > +{
> > +     char buf[STRERR_BUFSIZE];
> > +     int err, ret;
> > +     FILE *f;
> > +
> > +     f = fopen(file, "r");
> > +     if (!f) {
> > +             err = -errno;
> > +             pr_debug("failed to open '%s': %s\n", file,
> > +                      libbpf_strerror_r(err, buf, sizeof(buf)));
> > +             return err;
> > +     }
> > +     err = fscanf(f, fmt, &ret);
> > +     if (err != 1) {
> > +             err = err == EOF ? -EIO : -errno;
> > +             pr_debug("failed to parse '%s': %s\n", file,
> > +                     libbpf_strerror_r(err, buf, sizeof(buf)));
> > +             fclose(f);
> > +             return err;
> > +     }
> > +     fclose(f);
> > +     return ret;
> > +}
> > +
> > +static int determine_kprobe_perf_type(void)
> > +{
> > +     const char *file = "/sys/bus/event_source/devices/kprobe/type";
> > +
> > +     return parse_uint_from_file(file, "%d\n");
> > +}
> > +
> > +static int determine_uprobe_perf_type(void)
> > +{
> > +     const char *file = "/sys/bus/event_source/devices/uprobe/type";
> > +
> > +     return parse_uint_from_file(file, "%d\n");
> > +}
> > +
> > +static int determine_kprobe_retprobe_bit(void)
> > +{
> > +     const char *file = "/sys/bus/event_source/devices/kprobe/format/retprobe";
> > +
> > +     return parse_uint_from_file(file, "config:%d\n");
> > +}
> > +
> > +static int determine_uprobe_retprobe_bit(void)
> > +{
> > +     const char *file = "/sys/bus/event_source/devices/uprobe/format/retprobe";
> > +
> > +     return parse_uint_from_file(file, "config:%d\n");
> > +}
> > +
> > +static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> > +                              uint64_t offset, int pid)
> > +{
> > +     struct perf_event_attr attr = {};
> > +     char errmsg[STRERR_BUFSIZE];
> > +     int type, pfd, err;
> > +
> > +     type = uprobe ? determine_uprobe_perf_type()
> > +                   : determine_kprobe_perf_type();
> > +     if (type < 0) {
> > +             pr_warning("failed to determine %s perf type: %s\n",
> > +                        uprobe ? "uprobe" : "kprobe",
> > +                        libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> > +             return type;
> > +     }
> > +     if (retprobe) {
> > +             int bit = uprobe ? determine_uprobe_retprobe_bit()
> > +                              : determine_kprobe_retprobe_bit();
> > +
> > +             if (bit < 0) {
> > +                     pr_warning("failed to determine %s retprobe bit: %s\n",
> > +                                uprobe ? "uprobe" : "kprobe",
> > +                                libbpf_strerror_r(bit, errmsg,
> > +                                                  sizeof(errmsg)));
> > +                     return bit;
> > +             }
> > +             attr.config |= 1 << bit;
> > +     }
> > +     attr.size = sizeof(attr);
> > +     attr.type = type;
> > +     attr.config1 = (uint64_t)(void *)name; /* kprobe_func or uprobe_path */
> > +     attr.config2 = offset;                 /* kprobe_addr or probe_offset */
> > +
> > +     /* pid filter is meaningful only for uprobes */
> > +     pfd = syscall(__NR_perf_event_open, &attr,
> > +                   pid < 0 ? -1 : pid /* pid */,
> > +                   pid == -1 ? 0 : -1 /* cpu */,
> > +                   -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> > +     if (pfd < 0) {
> > +             err = -errno;
> > +             pr_warning("%s perf_event_open() failed: %s\n",
> > +                        uprobe ? "uprobe" : "kprobe",
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return err;
> > +     }
> > +     return pfd;
> > +}
> > +
> > +struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
> > +                                         bool retprobe,
> > +                                         const char *func_name)
> > +{
> > +     char errmsg[STRERR_BUFSIZE];
> > +     struct bpf_link *link;
> > +     int pfd, err;
> > +
> > +     pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
> > +                                 0 /* offset */, -1 /* pid */);
> > +     if (pfd < 0) {
> > +             pr_warning("program '%s': failed to create %s '%s' perf event: %s\n",
> > +                        bpf_program__title(prog, false),
> > +                        retprobe ? "kretprobe" : "kprobe", func_name,
> > +                        libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> > +             return ERR_PTR(pfd);
> > +     }
> > +     link = bpf_program__attach_perf_event(prog, pfd);
> > +     if (IS_ERR(link)) {
> > +             close(pfd);
> > +             err = PTR_ERR(link);
> > +             pr_warning("program '%s': failed to attach to %s '%s': %s\n",
> > +                        bpf_program__title(prog, false),
> > +                        retprobe ? "kretprobe" : "kprobe", func_name,
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return link;
> > +     }
> > +     return link;
> > +}
> > +
> > +struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
> > +                                         bool retprobe, pid_t pid,
> > +                                         const char *binary_path,
> > +                                         size_t func_offset)
> > +{
> > +     char errmsg[STRERR_BUFSIZE];
> > +     struct bpf_link *link;
> > +     int pfd, err;
> > +
> > +     pfd = perf_event_open_probe(true /* uprobe */, retprobe,
> > +                                 binary_path, func_offset, pid);
> > +     if (pfd < 0) {
> > +             pr_warning("program '%s': failed to create %s '%s:0x%zx' perf event: %s\n",
> > +                        bpf_program__title(prog, false),
> > +                        retprobe ? "uretprobe" : "uprobe",
> > +                        binary_path, func_offset,
> > +                        libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> > +             return ERR_PTR(pfd);
> > +     }
> > +     link = bpf_program__attach_perf_event(prog, pfd);
> > +     if (IS_ERR(link)) {
> > +             close(pfd);
> > +             err = PTR_ERR(link);
> > +             pr_warning("program '%s': failed to attach to %s '%s:0x%zx': %s\n",
> > +                        bpf_program__title(prog, false),
> > +                        retprobe ? "uretprobe" : "uprobe",
> > +                        binary_path, func_offset,
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return link;
> > +     }
> > +     return link;
> > +}
>
> Hm, this only addresses half the feedback I had in prior version [0]. Patch 2/9

Hi Daniel,

Yes, and I explained why in reply to your original email, please see [1].

I've started with exactly separation you wanted, but it turned out to
be cumbersome and harder to use user API, while also somewhat more
complicated to implement. Mostly because in that design bpf_link
exists in two states: created-but-not-attached and attached. Which
forces user to do additional clean ups if creation succeeded, but
attachment failed. It also makes it a bit harder to provide good
contextual error logging if something goes wrong, because not all
original parameters are preserved, as some of them might be needed
only for creation, but not attachment (or we'll have to allocate and
copy extra stuff just for logging purposes).

On the other hand, having separate generic attach_event method doesn't
help that much, as there is little common functionality to reuse
across all kinds of possible bpf_link types.


  [1] https://lore.kernel.org/bpf/20190621045555.4152743-4-andriin@fb.com/T/#m6cfc141e7b57970bc948134bf671a46972b95134

> with bpf_link with destructor looks good to me, but my feedback from back then was
> that all the kprobe/uprobe/tracepoint/raw_tracepoint should be split API-wise, so
> you'll end up with something like the below, that is, 1) a set of functions that
> only /create/ the bpf_link handle /once/, and 2) a helper that allows /attaching/
> progs to one or multiple bpf_links. The set of APIs would look like:
>
> struct bpf_link *bpf_link__create_kprobe(bool retprobe, const char *func_name);
> struct bpf_link *bpf_link__create_uprobe(bool retprobe, pid_t pid,
>                                          const char *binary_path,
>                                          size_t func_offset);
> int bpf_program__attach_to_link(struct bpf_link *link, struct bpf_program *prog);
> int bpf_link__destroy(struct bpf_link *link);
>
> This seems much more natural to me. Right now you sort of do both in one single API.

It felt that way for me as well, until I implemented it and used it in
selftests. And then it felt unnecessarily verbose without giving any
benefit. I still have a local patchset with that change, I can post it
as RFC, if you don't trust my judgement. Please let me know.

> Detangling the bpf_program__attach_{uprobe,kprobe}() would also avoid that you have
> to redo all the perf_event_open_probe() work over and over in order to get the pfd

What do you mean by "redo all the perf_event_open_probe work"? In
terms of code, I just reuse the same function, so there is no
duplicate code. And in either design you'll have to open that
perf_event, so that work will have to be done one way or another.

> context where you can later attach something to. Given bpf_program__attach_to_link()
> API, you also wouldn't need to expose the bpf_program__attach_perf_event() from

I'd expose attach_perf_event either way, it's high-level API I want to
provide, we have use cases where user is creating some specific
non-kprobe/non-tracepoint perf events and wants to attach to it. E.g.,
HW counter overflow events for CPU profilers. So that API is not some
kind of leaked abstraction, it's something I want to have anyway.


> patch 3/9. Thoughts?

I believe this hybrid approach provides better usability without
compromising anything. The only theoretical benefit of complete
separation of bpf_link creation and attachment is that user code would
be able to separate those two steps code organization-wise. But it's
easily doable through custom application code (just encapsulate all
the parameters and type of attachment and pass it around until you
actually need to attach), but I don't think it's necessary in practice
(so far I never needed anything like that).

Hope I convinced you that while elegant, it's not that practical. Also
hybrid approach isn't inelegant either and doesn't produce code
duplication (it actually eliminates some unnecessary allocations,
e.g., for storing tp_name for raw_tracepoint attach) :)

>
>   [0] https://lore.kernel.org/bpf/a7780057-1d70-9ace-960b-ff65867dc277@iogearbox.net/
>
> >  enum bpf_perf_event_ret
> >  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> >                          void **copy_mem, size_t *copy_size,
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 1bf66c4a9330..bd767cc11967 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -171,6 +171,13 @@ LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
> >
> >  LIBBPF_API struct bpf_link *
> >  bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> > +LIBBPF_API struct bpf_link *
> > +bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
> > +                        const char *func_name);
> > +LIBBPF_API struct bpf_link *
> > +bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
> > +                        pid_t pid, const char *binary_path,
> > +                        size_t func_offset);
> >
> >  struct bpf_insn;
> >
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 756f5aa802e9..57a40fb60718 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -169,7 +169,9 @@ LIBBPF_0.0.4 {
> >       global:
> >               bpf_link__destroy;
> >               bpf_object__load_xattr;
> > +             bpf_program__attach_kprobe;
> >               bpf_program__attach_perf_event;
> > +             bpf_program__attach_uprobe;
> >               btf_dump__dump_type;
> >               btf_dump__free;
> >               btf_dump__new;
> >
>
