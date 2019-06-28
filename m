Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE575A34B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfF1SPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:15:44 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46864 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF1SPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:15:44 -0400
Received: by mail-qt1-f194.google.com with SMTP id h21so7275943qtn.13;
        Fri, 28 Jun 2019 11:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8tyoV2DLPjbpVvs3pr7vwz3Iz7a3h78lHhdifv2ifuI=;
        b=I8DagoX+GMMBE9v0KSmmkuD8qlgssDFj0n6ehTjs2lmZ75kK5LwW8dLn9lkMuHRRZh
         c24Aq1U5H7U9CWC0TvJbtZmb52CriOEcgB2E7TMkRo01xvVM4H1mMoQ9Yf4N9Jdb04cf
         TarXlRK8JdvL+eakmikJVC59maw8d9prA3oeLakBsL9SKUsEEVlYrwpMd5p6QGcoar66
         sNZUkm1e0h3+SkFV3H2t4HCqi/21Li1LCco3AW55kSJiIVfJ4s2xA9UuWcwQwa47jaAb
         OnZq8c/mN0Kwxp2iiNFVnveHzzl4l5JKpPPMiHfANMK8Ie8cnffZ5rdXQx8ZEatrR5+4
         Wcsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8tyoV2DLPjbpVvs3pr7vwz3Iz7a3h78lHhdifv2ifuI=;
        b=n8/NPGWLnAKXb5Oyr3yorApxqBtRrvraPo4kxWqmJpybZj6r8nUvg3F6cdZUgIHUX/
         95K7utLrLPXYM9Q+eY1f8PHjEfaRaRCLt9GM9XkgW9aZn2v9sUJOf5ujI71X+l55fEUH
         FjvzvhRBelbtyo7ZuAlNARnVwMWYJtl3ISp8f5RKqIxuMbGS/Y9YiKnhpM90tVJOAgda
         zkclxcTmTu49Y1nfdBUn408mNubJoCW0wAKuwwgDHj+YWkWD4/OA0UVcGIpaha5BWp6C
         uQip/UInmyKcvxMl5tXSzA9I6OG4/iS1q53l91G8bjoJEgP4hBsG26BZhksYdRwXtGma
         erIQ==
X-Gm-Message-State: APjAAAXG5rYTKuh6w0DFBUUSqF81qmOpjsI3jD0/HjyoIS2MP+t0qjAD
        KdIDGsw4r75S7kHZjFsVk291lKiPDvmr46vxhMjnrKHmvic=
X-Google-Smtp-Source: APXvYqwRFpRUJ4dadRIK2lWQghKcpRKh74Jo4GsVw0+DOKpCg5LshNBqYzag+ozK069Lk7W6j95nkwtWmiuOYGEV3A0=
X-Received: by 2002:ac8:2fb7:: with SMTP id l52mr8837932qta.93.1561745743303;
 Fri, 28 Jun 2019 11:15:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-4-andriin@fb.com>
 <20190628180010.GA24308@mini-arch> <CAEf4BzZ_1-uSNRco91yZ4OJ2dV+G-yZ_uFPTbQDmPHoNLX9sPw@mail.gmail.com>
 <20190628181414.GC24308@mini-arch>
In-Reply-To: <20190628181414.GC24308@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 28 Jun 2019 11:15:32 -0700
Message-ID: <CAEf4BzaGOZZ19oR7+gtecVr+cag6YggQNG4BJwG+C7ksChfgPw@mail.gmail.com>
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

On Fri, Jun 28, 2019 at 11:14 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/28, Andrii Nakryiko wrote:
> > On Fri, Jun 28, 2019 at 11:00 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 06/27, Andrii Nakryiko wrote:
> > > > bpf_program__attach_perf_event allows to attach BPF program to existing
> > > > perf event hook, providing most generic and most low-level way to attach BPF
> > > > programs. It returns struct bpf_link, which should be passed to
> > > > bpf_link__destroy to detach and free resources, associated with a link.
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  tools/lib/bpf/libbpf.c   | 58 ++++++++++++++++++++++++++++++++++++++++
> > > >  tools/lib/bpf/libbpf.h   |  3 +++
> > > >  tools/lib/bpf/libbpf.map |  1 +
> > > >  3 files changed, 62 insertions(+)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > index 455795e6f8af..606705f878ba 100644
> > > > --- a/tools/lib/bpf/libbpf.c
> > > > +++ b/tools/lib/bpf/libbpf.c
> > > > @@ -32,6 +32,7 @@
> > > >  #include <linux/limits.h>
> > > >  #include <linux/perf_event.h>
> > > >  #include <linux/ring_buffer.h>
> > > > +#include <sys/ioctl.h>
> > > >  #include <sys/stat.h>
> > > >  #include <sys/types.h>
> > > >  #include <sys/vfs.h>
> > > > @@ -3958,6 +3959,63 @@ int bpf_link__destroy(struct bpf_link *link)
> > > >       return err;
> > > >  }
> > > >
> > > > +struct bpf_link_fd {
> > > > +     struct bpf_link link; /* has to be at the top of struct */
> > > > +     int fd; /* hook FD */
> > > > +};
> > > > +
> > > > +static int bpf_link__destroy_perf_event(struct bpf_link *link)
> > > > +{
> > > > +     struct bpf_link_fd *l = (void *)link;
> > > > +     int err;
> > > > +
> > > > +     if (l->fd < 0)
> > > > +             return 0;
> > > > +
> > > > +     err = ioctl(l->fd, PERF_EVENT_IOC_DISABLE, 0);
> > > > +     close(l->fd);
> > > > +     return err;
> > > Why not return -errno from ioctl here (as you do elsewhere)?
> >
> > Good catch, will fix, thanks!
> >
> > As an aside, this whole returning error on close/destroy is a bit
> > moot, as there is little one can do if any of teardown steps fail
> > (except crash, which is not great response :) ). So the strategy would
> > be to still free all memory and try to close all FDs, before returning
> > error (again, which one, first, last? eh..).
> Agreed, it's like nobody cares about close() return code. So don't
> bother with this fix unless you'd do another respin for a different
> reason.

I still want something more meaningful than -1 :) Will renamed bpf_fd as well.

>
> > > > +}
> > > > +
> > > > +struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> > > > +                                             int pfd)
> > > > +{
> > > > +     char errmsg[STRERR_BUFSIZE];
> > > > +     struct bpf_link_fd *link;
> > > > +     int bpf_fd, err;
> > > > +
> > > > +     bpf_fd = bpf_program__fd(prog);
> > > > +     if (bpf_fd < 0) {
> > > > +             pr_warning("program '%s': can't attach before loaded\n",
> > > > +                        bpf_program__title(prog, false));
> > > > +             return ERR_PTR(-EINVAL);
> > > > +     }
> > > > +
> > > > +     link = malloc(sizeof(*link));
> > > > +     if (!link)
> > > > +             return ERR_PTR(-ENOMEM);
> > > > +     link->link.destroy = &bpf_link__destroy_perf_event;
> > > > +     link->fd = pfd;
> > > > +
> > > > +     if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, bpf_fd) < 0) {
> > > > +             err = -errno;
> > > > +             free(link);
> > > > +             pr_warning("program '%s': failed to attach to pfd %d: %s\n",
> > > > +                        bpf_program__title(prog, false), pfd,
> > > > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > > > +             return ERR_PTR(err);
> > > > +     }
> > > > +     if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
> > > > +             err = -errno;
> > > > +             free(link);
> > > > +             pr_warning("program '%s': failed to enable pfd %d: %s\n",
> > > > +                        bpf_program__title(prog, false), pfd,
> > > > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > > > +             return ERR_PTR(err);
> > > > +     }
> > > > +     return (struct bpf_link *)link;
> > > > +}
> > > > +
> > > >  enum bpf_perf_event_ret
> > > >  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> > > >                          void **copy_mem, size_t *copy_size,
> > > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > > index 5082a5ebb0c2..1bf66c4a9330 100644
> > > > --- a/tools/lib/bpf/libbpf.h
> > > > +++ b/tools/lib/bpf/libbpf.h
> > > > @@ -169,6 +169,9 @@ struct bpf_link;
> > > >
> > > >  LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
> > > >
> > > > +LIBBPF_API struct bpf_link *
> > > > +bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> > > > +
> > > >  struct bpf_insn;
> > > >
> > > >  /*
> > > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > > index 3cde850fc8da..756f5aa802e9 100644
> > > > --- a/tools/lib/bpf/libbpf.map
> > > > +++ b/tools/lib/bpf/libbpf.map
> > > > @@ -169,6 +169,7 @@ LIBBPF_0.0.4 {
> > > >       global:
> > > >               bpf_link__destroy;
> > > >               bpf_object__load_xattr;
> > > > +             bpf_program__attach_perf_event;
> > > >               btf_dump__dump_type;
> > > >               btf_dump__free;
> > > >               btf_dump__new;
> > > > --
> > > > 2.17.1
> > > >
