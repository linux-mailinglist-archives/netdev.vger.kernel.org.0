Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5E65A33F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfF1SOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:14:16 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36383 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfF1SOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:14:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so2940048pgg.3
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l4suhY532qZabeWlJJdSjfNC56E3KM6QEJ95/POooNY=;
        b=wwltL8g+ijZDfS1hH0uMS6wqzzJLNRMwqqJnMniwa8qVQmj/TkTitVFVPOj/il7BWl
         vPA74UrFnJwwFh9IIL6D1ZVR0tBRSx3Q2fcWViAKSYdxwDWsm2vWugmjhphXbcIhXG6J
         I4OuWsa9GRkwrZaWK9ap+0EaHaPyekVl9sdnHZ7LJO87l+QCzwLbqeWizluUfkjEOMdJ
         AmtE9Nu6c3p72aMA8ULyKfEs+/9CHXi1SUcrOo//rNzBE/AP+mH1XBaeUiXSl7U2QZ6I
         +PTTkRJgCHKcOOQE5xusaBqssSXE9WNyThcrau0hgvcZEinfQy07CVURpRXY4YUoTmbz
         BZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l4suhY532qZabeWlJJdSjfNC56E3KM6QEJ95/POooNY=;
        b=OlwyuffxLHurDNq1tAjDtmMGe7Cx6TPShgap+NB9FUMa5SK0q2y0TP+zBz4caQNFBC
         lAMGGul6YaGJ0DUw5z0YFWk6CVpUZWxpBJAZAok/J7XH1I7oksILdksE0ikNw2NwqvcM
         aoNYr+9cz+0X3MNHm/sF4bmoFOZSaGx6mTDHTJfvJrKDboXd4id87n+qPYdLW4TG7/mW
         qGB1JV/pxoH4e2dYOGzf1tcXRrRy/BDAgNOsxS8QsqXKxxJDZiLZC+69Jp1Tc1KeAC4Q
         3zwn7A1b8FyawV5rzce6coDZD4on+zYs5PKPOdpcwoiXHF/DuB3wkRbcWvSm7VibyW4y
         KsOg==
X-Gm-Message-State: APjAAAXHbK6aIGflFwAs56NiWi40bDH7QILT9O8naON+RDQtF8dh5Q4Y
        WdP0VlCexqeX8KPSlHdSLfkH1nvKasI=
X-Google-Smtp-Source: APXvYqxH8PmT2cIradFXI3wZX2ZQYHfbu7Oocrgs/om6GRLn2PkPbMh6cgZydxtxtpNbUMGg5Ju5/w==
X-Received: by 2002:a63:c106:: with SMTP id w6mr10646233pgf.422.1561745655784;
        Fri, 28 Jun 2019 11:14:15 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id r15sm2772450pfh.121.2019.06.28.11.14.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:14:15 -0700 (PDT)
Date:   Fri, 28 Jun 2019 11:14:14 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 3/9] libbpf: add ability to attach/detach BPF
 program to perf event
Message-ID: <20190628181414.GC24308@mini-arch>
References: <20190628055303.1249758-1-andriin@fb.com>
 <20190628055303.1249758-4-andriin@fb.com>
 <20190628180010.GA24308@mini-arch>
 <CAEf4BzZ_1-uSNRco91yZ4OJ2dV+G-yZ_uFPTbQDmPHoNLX9sPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ_1-uSNRco91yZ4OJ2dV+G-yZ_uFPTbQDmPHoNLX9sPw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/28, Andrii Nakryiko wrote:
> On Fri, Jun 28, 2019 at 11:00 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 06/27, Andrii Nakryiko wrote:
> > > bpf_program__attach_perf_event allows to attach BPF program to existing
> > > perf event hook, providing most generic and most low-level way to attach BPF
> > > programs. It returns struct bpf_link, which should be passed to
> > > bpf_link__destroy to detach and free resources, associated with a link.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c   | 58 ++++++++++++++++++++++++++++++++++++++++
> > >  tools/lib/bpf/libbpf.h   |  3 +++
> > >  tools/lib/bpf/libbpf.map |  1 +
> > >  3 files changed, 62 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 455795e6f8af..606705f878ba 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -32,6 +32,7 @@
> > >  #include <linux/limits.h>
> > >  #include <linux/perf_event.h>
> > >  #include <linux/ring_buffer.h>
> > > +#include <sys/ioctl.h>
> > >  #include <sys/stat.h>
> > >  #include <sys/types.h>
> > >  #include <sys/vfs.h>
> > > @@ -3958,6 +3959,63 @@ int bpf_link__destroy(struct bpf_link *link)
> > >       return err;
> > >  }
> > >
> > > +struct bpf_link_fd {
> > > +     struct bpf_link link; /* has to be at the top of struct */
> > > +     int fd; /* hook FD */
> > > +};
> > > +
> > > +static int bpf_link__destroy_perf_event(struct bpf_link *link)
> > > +{
> > > +     struct bpf_link_fd *l = (void *)link;
> > > +     int err;
> > > +
> > > +     if (l->fd < 0)
> > > +             return 0;
> > > +
> > > +     err = ioctl(l->fd, PERF_EVENT_IOC_DISABLE, 0);
> > > +     close(l->fd);
> > > +     return err;
> > Why not return -errno from ioctl here (as you do elsewhere)?
> 
> Good catch, will fix, thanks!
> 
> As an aside, this whole returning error on close/destroy is a bit
> moot, as there is little one can do if any of teardown steps fail
> (except crash, which is not great response :) ). So the strategy would
> be to still free all memory and try to close all FDs, before returning
> error (again, which one, first, last? eh..).
Agreed, it's like nobody cares about close() return code. So don't
bother with this fix unless you'd do another respin for a different
reason.

> > > +}
> > > +
> > > +struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> > > +                                             int pfd)
> > > +{
> > > +     char errmsg[STRERR_BUFSIZE];
> > > +     struct bpf_link_fd *link;
> > > +     int bpf_fd, err;
> > > +
> > > +     bpf_fd = bpf_program__fd(prog);
> > > +     if (bpf_fd < 0) {
> > > +             pr_warning("program '%s': can't attach before loaded\n",
> > > +                        bpf_program__title(prog, false));
> > > +             return ERR_PTR(-EINVAL);
> > > +     }
> > > +
> > > +     link = malloc(sizeof(*link));
> > > +     if (!link)
> > > +             return ERR_PTR(-ENOMEM);
> > > +     link->link.destroy = &bpf_link__destroy_perf_event;
> > > +     link->fd = pfd;
> > > +
> > > +     if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, bpf_fd) < 0) {
> > > +             err = -errno;
> > > +             free(link);
> > > +             pr_warning("program '%s': failed to attach to pfd %d: %s\n",
> > > +                        bpf_program__title(prog, false), pfd,
> > > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > > +             return ERR_PTR(err);
> > > +     }
> > > +     if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
> > > +             err = -errno;
> > > +             free(link);
> > > +             pr_warning("program '%s': failed to enable pfd %d: %s\n",
> > > +                        bpf_program__title(prog, false), pfd,
> > > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > > +             return ERR_PTR(err);
> > > +     }
> > > +     return (struct bpf_link *)link;
> > > +}
> > > +
> > >  enum bpf_perf_event_ret
> > >  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> > >                          void **copy_mem, size_t *copy_size,
> > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > index 5082a5ebb0c2..1bf66c4a9330 100644
> > > --- a/tools/lib/bpf/libbpf.h
> > > +++ b/tools/lib/bpf/libbpf.h
> > > @@ -169,6 +169,9 @@ struct bpf_link;
> > >
> > >  LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
> > >
> > > +LIBBPF_API struct bpf_link *
> > > +bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> > > +
> > >  struct bpf_insn;
> > >
> > >  /*
> > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > index 3cde850fc8da..756f5aa802e9 100644
> > > --- a/tools/lib/bpf/libbpf.map
> > > +++ b/tools/lib/bpf/libbpf.map
> > > @@ -169,6 +169,7 @@ LIBBPF_0.0.4 {
> > >       global:
> > >               bpf_link__destroy;
> > >               bpf_object__load_xattr;
> > > +             bpf_program__attach_perf_event;
> > >               btf_dump__dump_type;
> > >               btf_dump__free;
> > >               btf_dump__new;
> > > --
> > > 2.17.1
> > >
