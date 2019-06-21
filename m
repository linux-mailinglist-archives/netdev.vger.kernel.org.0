Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D1E4DFC2
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 06:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfFUE2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 00:28:43 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39010 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfFUE2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 00:28:43 -0400
Received: by mail-qt1-f193.google.com with SMTP id i34so5608775qta.6;
        Thu, 20 Jun 2019 21:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2eP+/y29JHK3ytspwFJQwiWLQrOqttwgT1nffFEKuCE=;
        b=alxzvjK2jpTFBjralOuS/TtTAys3BQAI9rBQY7OEhRjI+/ePPcgfkE31oMXFRT48cp
         BgKSSzneHSfkFWAiD/FKdWis3vV4Rnpcu9XBI4MJayx+mSduNhlRCWr+RxxKw5kWedso
         e+4/DtN4P2duQEEp9DfQ2dp4iVH7v6R48GLxp2zssfkqZbChCUBH017VLgtjHUdpurRQ
         21swTKftUq3Qb+4vAM4miLk/gH0/WNL2BJoE//Xu3nvKLWNXRbQniDSBFH2K7cJ/wuKw
         qUP/Nv+kiWfgkJbap/TD5j05Gno/OH/t1pLxDZMfInmRhOrr7dl5C5iXkeg45gTDJnk6
         Mc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2eP+/y29JHK3ytspwFJQwiWLQrOqttwgT1nffFEKuCE=;
        b=SkU8vN1zilC+GbL1+1GXVqUpY3IcHCNccq4MJEtIRBQN0xevpp8JWFLN4rFpTz1rSS
         kcSwgA5x8I8EkL5/bbGo8BH0N/sgN44JOD9SJUpODq2KzSaF5qfYvzc1/TY0AtASU4uD
         +i+ysnhTHFW0vN8BmvIOQlDydvCSLkkiFqirmR/v5IhXZTneoSm12C8Jpu9Zf6UD70hF
         UBX5fJ51rEWkjAyOAFCE9CvfGWJX+BdWr4oZourWqsKISfFBH7Pg7ILU6s0iFoLYQSCR
         C4YD6C7csNoB6KifeDqAbJiyIlGT+vUQRrg/AX4Brf8STqm6DWH59HC+86gEY/JpN2hB
         u1Uw==
X-Gm-Message-State: APjAAAUsBe+1uwHUmjsZG+Fnu6dRnYeYd6/1zVKTH9LZr5raytwpvfpE
        0wpoRbmWiWDqJdsK10sUK8awLylXJ39DLQxTlrQ=
X-Google-Smtp-Source: APXvYqxfvbT9cnDrmBJsCySIeF4GGzpJH7rYWp1rVQeI10AX4+CNh32cCCR3w65UBzDYvAZgNj6Q5IG/NODjDsgjCgw=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr96050955qty.59.1561091321697;
 Thu, 20 Jun 2019 21:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190620230951.3155955-1-andriin@fb.com> <20190620230951.3155955-3-andriin@fb.com>
 <20190621000140.GA1383@mini-arch>
In-Reply-To: <20190621000140.GA1383@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Jun 2019 21:28:30 -0700
Message-ID: <CAEf4Bzaxh4tZB1eVUu-G5bGzwe7ehLVbb5M49c_YeeSuFibTTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/7] libbpf: add ability to attach/detach BPF to
 perf event
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 5:01 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/20, Andrii Nakryiko wrote:
> > bpf_program__attach_perf_event allows to attach BPF program to existing
> > perf event, providing most generic and most low-level way to attach BPF
> > programs.
> >
> > libbpf_perf_event_disable_and_close API is added to disable and close
> > existing perf event by its FD.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c   | 41 ++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/libbpf.h   |  4 ++++
> >  tools/lib/bpf/libbpf.map |  2 ++
> >  3 files changed, 47 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 8ce3beba8551..2bb1fa008be3 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/limits.h>
> >  #include <linux/perf_event.h>
> >  #include <linux/ring_buffer.h>
> > +#include <sys/ioctl.h>
> >  #include <sys/stat.h>
> >  #include <sys/types.h>
> >  #include <sys/vfs.h>
> > @@ -3928,6 +3929,46 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
> >       return 0;
> >  }
> >
> [..]
> > +int libbpf_perf_event_disable_and_close(int pfd)
> nit: why not call it libbpf_perf_event_detach[_and_close]?
> It's usually attach/detach.

I think detach is actually confusing for perf event. Here's what you
do for tracing:

1. open perf event
2. enable perf event
3. attach BPF program to perf event
...
4. <is there a way to detach BPF program?>
5. disable perf event
6. close perf event

So open/close event, enable/disable event, attach / (auto-detach on
close right now) BPF program.

It seems like there should be explicit "detach this BPF program from
perf event without killing event itself", but I haven't found it.

But my point is that for event open/close and enable/disable seems
very complementary.


>
> > +{
> > +     int err;
> > +
> > +     if (pfd < 0)
> > +             return 0;
> > +
> > +     err = ioctl(pfd, PERF_EVENT_IOC_DISABLE, 0);
> > +     close(pfd);
> > +     return err;
> > +}
> > +
> > +int bpf_program__attach_perf_event(struct bpf_program *prog, int pfd)
> > +{
> > +     char errmsg[STRERR_BUFSIZE];
> > +     int bpf_fd, err;
> > +
> > +     bpf_fd = bpf_program__fd(prog);
> > +     if (bpf_fd < 0) {
> > +             pr_warning("program '%s': can't attach before loaded\n",
> > +                        bpf_program__title(prog, false));
> > +             return -EINVAL;
> > +     }
> > +     if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, bpf_fd) < 0) {
> > +             err = -errno;
> > +             pr_warning("program '%s': failed to attach to pfd %d: %s\n",
> > +                        bpf_program__title(prog, false), pfd,
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return err;
> > +     }
> > +     if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
> > +             err = -errno;
> > +             pr_warning("program '%s': failed to enable pfd %d: %s\n",
> > +                        bpf_program__title(prog, false), pfd,
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return err;
> > +     }
> > +     return 0;
> > +}
> > +
> >  enum bpf_perf_event_ret
> >  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> >                          void **copy_mem, size_t *copy_size,
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index d639f47e3110..76db1bbc0dac 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -165,6 +165,10 @@ LIBBPF_API int bpf_program__pin(struct bpf_program *prog, const char *path);
> >  LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *path);
> >  LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
> >
> > +LIBBPF_API int libbpf_perf_event_disable_and_close(int pfd);
> > +LIBBPF_API int bpf_program__attach_perf_event(struct bpf_program *prog,
> > +                                           int pfd);
> > +
> >  struct bpf_insn;
> >
> >  /*
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 2c6d835620d2..d27406982b5a 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -172,5 +172,7 @@ LIBBPF_0.0.4 {
> >               btf_dump__new;
> >               btf__parse_elf;
> >               bpf_object__load_xattr;
> > +             bpf_program__attach_perf_event;
> >               libbpf_num_possible_cpus;
> > +             libbpf_perf_event_disable_and_close;
> >  } LIBBPF_0.0.3;
> > --
> > 2.17.1
> >
