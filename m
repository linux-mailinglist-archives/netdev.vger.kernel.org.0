Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F205A2CF
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfF1RyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:54:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33727 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfF1RyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:54:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so3656786plo.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Nhwt/axHUdHXBXGiDoJCxLF2WXQBGDyc/cHN+4A5pRI=;
        b=bboTXl36ifwyZ0IdhfYjTlFmXYNECtzb8X1j/IsPazJ0TUxKdFZPCtxcAcUn1zK5+P
         5cYcvyG2LEyLwcMPP5wMCh6LgpRXSJ3uprdU1f03mfaeVhHzKvriNP+GGayxsWfcd8Sw
         J3qkJzZ8dUSkhcDGFx/2ZQC/ZGtAfoxLUdN/1GVvIraDJRNZCSccAelDR4bmENppam0F
         D44zIvtJSGd1jFBCyUeqnR8G/Zg4FOnl9s0agxQHkLZzFI+qotV9MCpgcLru47HHy3Sv
         vs41EAXcyI7jC7W0tJoClk6xwnUeRe/7qlmXIMZlS49VwlKI/HvKNgzv7Yg7PQI+Z5cB
         QADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Nhwt/axHUdHXBXGiDoJCxLF2WXQBGDyc/cHN+4A5pRI=;
        b=tN0hWAq2b7xTmL+PVdrHS74TLvVdiW3G14vBZN7+AWFT4xXxFk1/O0et7IJgfDB2hx
         HBk2IvWY5E6SAmL5AMwztLebu2meAvSCCLCdTKHZLbF2k2PvyebWB8HKec6AMjjAG/AO
         /xahSgLnTuito8pnenuYrQLZ9YOZNa2IZHdobm0DjlFwfPw44Atrmh3OERRVF/YogPCg
         c8IvLdauwfjCcZER6xkwbvOsWM1Xc0N3R1qGW480tc8OlbBp049vd7RYf5ur2TWq7Ubr
         XnCs8ZdlMZ/Sf05zwQeUgMfKmqZTcRHUS3hAR0ZO7g+dmiMJhEx9o3dLGTfM1vzlz3/S
         rfxA==
X-Gm-Message-State: APjAAAWqrfG9cDAmWqfGB7fPo94cQVQS4ofeWFEyvaEBaNROhkiFH/lR
        +0hjLhxS7LQoVjlR5Yt0C2VvRJQAdRc=
X-Google-Smtp-Source: APXvYqy0vunBdZu4obZ9UpFtSwxR7yw/psTLZH18ZmmzXbFVZPSMcqHcTpSlxC1OvBE9UVRV54KS1w==
X-Received: by 2002:a17:902:2926:: with SMTP id g35mr12976605plb.269.1561744448849;
        Fri, 28 Jun 2019 10:54:08 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id p2sm3920760pfb.118.2019.06.28.10.54.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 10:54:08 -0700 (PDT)
Date:   Fri, 28 Jun 2019 10:54:07 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 3/9] libbpf: add ability to attach/detach BPF
 program to perf event
Message-ID: <20190628175407.GJ4866@mini-arch>
References: <20190628055303.1249758-1-andriin@fb.com>
 <20190628055303.1249758-4-andriin@fb.com>
 <20190628160436.GH4866@mini-arch>
 <CAEf4BzYP+QEERsS6wFCBSVtCSTOCtPKzUBrqds5rh691X5zd_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYP+QEERsS6wFCBSVtCSTOCtPKzUBrqds5rh691X5zd_w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/28, Andrii Nakryiko wrote:
> On Fri, Jun 28, 2019 at 9:04 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
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
> > [..]
> > > +     int fd; /* hook FD */
> > > +};
> > Any cons to storing everything in bpf_link, instead of creating a
> > "subclass"? Less things to worry about.
> 
> Yes, it's not always enough to just have single FD to detach BPF
> program. Check bpf_prog_detach and bpf_prog_detach2 in
> tools/lib/bpf/bpf.c. For some types of attachment you have to provide
> target_fd+attach_type, for some target_fd+attach_type+attach_bpf_fd.
> So those two will use their own bpf_link extensions.
> 
> I haven't implemented those attachment APIs yet, but we should.
> 
> What should go into bpf_link itself is any information that's common
> to any kind of attachment (e.g, "kind of attachment" itself). It's
> conceivable that we might allow "casting" bpf_link into specific
> variation and having extra "methods" on those. I haven't done that, as
> I didn't have a need yet.
You're optimizing for a memory footprint, I guess. I was trying to
point out that maybe it's easier just to put everything in the bpf_link
and don't do any castings. Some events would use attach_type, some
won't. But, OTOH, maybe having a specific bpf_link variation per
attachment is more readable, idk :-)

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
