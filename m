Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F185A318
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfF1SER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:04:17 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41341 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfF1SEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:04:16 -0400
Received: by mail-qk1-f195.google.com with SMTP id c11so5566284qkk.8;
        Fri, 28 Jun 2019 11:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=stK9hhnvMlQm3QkvH5B79b/ZvbMxlXW1uK3dWcEPTw0=;
        b=gqae7HbJqikHb6mar8LqKvDn1FE7eHhoOxVOG33MS6MuyaZJz+wig6QmrCeSKqEp6m
         bA8W6/Fr6BnKRYFyAlG36V6LbsiG2f6QrXDZMxAtqpzgufUnz7PiVlmzete4ym0Zpj/b
         iEOwqPyFdiBwBjPNmm5j2Vq0l1njRRg2T6kzNHUA/hN7bmmdXAOBV0kXEv7+lhLhqCKL
         VFEFo91ElvmvtiqmcM+N34iNfmdKyo/ENPO1eJ+8NZuqTIzIyCSA8HIztaddYV5VwmQa
         BIbtaLykFY9rPXx8M72ui64cW4ZjHOy43vMhvkCwDCFUz7fFMqULVTRHjXDgU3Sm+s49
         706A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=stK9hhnvMlQm3QkvH5B79b/ZvbMxlXW1uK3dWcEPTw0=;
        b=LmCXpimT8ElvX6tHHaUoWMfkX0sr7tH0nYHDpgeE2fbuVVKbDfsRaI1uQ96c9Qw1A7
         Fo8Kk2ddm1mVznRhey7uloKj8aZ+jJ1NwswRbRl6P3xEPoYtQ9wCib+/PMy7oLsYHgyb
         1hgz0CMxx2IG3Y9B8bAL1wRP3lzaf/0oyCP7MlLCkUsBbrCsud5aoB9e4G92ms3T5Ihe
         CB/m28kAhZExwc6BkD48ryh/IQvlxm8iUcrGLKTNuFCdxXRbRBYK2KcF62kmKP9U9v/z
         TJykuhEscKcYHBode8veJS+PCo2utR1Wnx8tHsY7NoHDULr8C+Z8O9IR75Ys5p9fmu/X
         UXSA==
X-Gm-Message-State: APjAAAWJw5D/pIx8/54bXkN2rUDCkOtIaekaoJzHXGtX+7g7tlcAJsdp
        AG1pqHUles/aE9oosvYbpIAB2DGEGBc8klJBwvAL37h3As8=
X-Google-Smtp-Source: APXvYqy/XZH+NvPY191BdBaPFBbxjjWvN6hzM11tB68onAdEPdKflQQZjPI4VxIDhb+hOOVgm/Te/8UWYsKBANmOIPE=
X-Received: by 2002:a37:a095:: with SMTP id j143mr10277402qke.449.1561745055492;
 Fri, 28 Jun 2019 11:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-4-andriin@fb.com>
 <20190628180010.GA24308@mini-arch>
In-Reply-To: <20190628180010.GA24308@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 28 Jun 2019 11:04:04 -0700
Message-ID: <CAEf4BzZ_1-uSNRco91yZ4OJ2dV+G-yZ_uFPTbQDmPHoNLX9sPw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/9] libbpf: add ability to attach/detach BPF
 program to perf event
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

On Fri, Jun 28, 2019 at 11:00 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/27, Andrii Nakryiko wrote:
> > bpf_program__attach_perf_event allows to attach BPF program to existing
> > perf event hook, providing most generic and most low-level way to attach BPF
> > programs. It returns struct bpf_link, which should be passed to
> > bpf_link__destroy to detach and free resources, associated with a link.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c   | 58 ++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/libbpf.h   |  3 +++
> >  tools/lib/bpf/libbpf.map |  1 +
> >  3 files changed, 62 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 455795e6f8af..606705f878ba 100644
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
> > @@ -3958,6 +3959,63 @@ int bpf_link__destroy(struct bpf_link *link)
> >       return err;
> >  }
> >
> > +struct bpf_link_fd {
> > +     struct bpf_link link; /* has to be at the top of struct */
> > +     int fd; /* hook FD */
> > +};
> > +
> > +static int bpf_link__destroy_perf_event(struct bpf_link *link)
> > +{
> > +     struct bpf_link_fd *l = (void *)link;
> > +     int err;
> > +
> > +     if (l->fd < 0)
> > +             return 0;
> > +
> > +     err = ioctl(l->fd, PERF_EVENT_IOC_DISABLE, 0);
> > +     close(l->fd);
> > +     return err;
> Why not return -errno from ioctl here (as you do elsewhere)?

Good catch, will fix, thanks!

As an aside, this whole returning error on close/destroy is a bit
moot, as there is little one can do if any of teardown steps fail
(except crash, which is not great response :) ). So the strategy would
be to still free all memory and try to close all FDs, before returning
error (again, which one, first, last? eh..).

>
> > +}
> > +
> > +struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> > +                                             int pfd)
> > +{
> > +     char errmsg[STRERR_BUFSIZE];
> > +     struct bpf_link_fd *link;
> > +     int bpf_fd, err;
> > +
> > +     bpf_fd = bpf_program__fd(prog);
> > +     if (bpf_fd < 0) {
> > +             pr_warning("program '%s': can't attach before loaded\n",
> > +                        bpf_program__title(prog, false));
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +
> > +     link = malloc(sizeof(*link));
> > +     if (!link)
> > +             return ERR_PTR(-ENOMEM);
> > +     link->link.destroy = &bpf_link__destroy_perf_event;
> > +     link->fd = pfd;
> > +
> > +     if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, bpf_fd) < 0) {
> > +             err = -errno;
> > +             free(link);
> > +             pr_warning("program '%s': failed to attach to pfd %d: %s\n",
> > +                        bpf_program__title(prog, false), pfd,
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return ERR_PTR(err);
> > +     }
> > +     if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
> > +             err = -errno;
> > +             free(link);
> > +             pr_warning("program '%s': failed to enable pfd %d: %s\n",
> > +                        bpf_program__title(prog, false), pfd,
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return ERR_PTR(err);
> > +     }
> > +     return (struct bpf_link *)link;
> > +}
> > +
> >  enum bpf_perf_event_ret
> >  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> >                          void **copy_mem, size_t *copy_size,
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 5082a5ebb0c2..1bf66c4a9330 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -169,6 +169,9 @@ struct bpf_link;
> >
> >  LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
> >
> > +LIBBPF_API struct bpf_link *
> > +bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> > +
> >  struct bpf_insn;
> >
> >  /*
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 3cde850fc8da..756f5aa802e9 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -169,6 +169,7 @@ LIBBPF_0.0.4 {
> >       global:
> >               bpf_link__destroy;
> >               bpf_object__load_xattr;
> > +             bpf_program__attach_perf_event;
> >               btf_dump__dump_type;
> >               btf_dump__free;
> >               btf_dump__new;
> > --
> > 2.17.1
> >
