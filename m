Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B51D5C56C
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfGAV6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:58:10 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45647 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbfGAV6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:58:10 -0400
Received: by mail-qk1-f195.google.com with SMTP id s22so12331240qkj.12;
        Mon, 01 Jul 2019 14:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kh6gsF5HfwSDU+S35Aw2h3hcuuoCLXUgS3KWCleQFr0=;
        b=Bze6FLvqNmfotJkZDKkOEMzYGs038eXUIze5VbXJWkwMGgqZwUhaQfkImSxdz4CBKr
         eUeDQ0vEL0gDghwW3QaCFrpuiFObUAdo17ZrCVdPi3bCLvaTxTmYxZ0PdOpz7QspgZmX
         IklVau3SktjTxGWPpxPE4m8bVSEZW2bmmEelCuIKAjU6F4/G9tI94a/1KZF+Ut5CWzrZ
         Jo2lzDKq0JPW+iL6doou4orqNdEjCSPLELNwfG+sAE3gFmeFhmNsKcFVQQjiQrcEMt8p
         vanSYtaMvi7OptLmpOQf3iORnEIC1JjDSwwENhXe32yGqZaMYxwhwK0vpcCsn6/f3pj2
         6CpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kh6gsF5HfwSDU+S35Aw2h3hcuuoCLXUgS3KWCleQFr0=;
        b=L6YDEZ/bKjPag5GlAmH3g21G407nmNBKuQx/xM4PLLD11q8xsAC7FbbIBKNzd5ss50
         7zyCKBnMahWXg+dssN3bh5qBKcIha1iVNtmykq+Yd6m3YyixIXRg8pJA68AoyeY8qSCB
         /7I/TuNpEIQqCFxoD4bPcjbvLaJagluW3JXh0xWd3mHzumJK95tgfzK636lZ9P8ImnBI
         D+kVp2wVrSxvWpjMTzcbe5Rq87DFsMNjR2EtahLwI0nuJ+vmrafAqGExBbsc0nkG6J/h
         F7a6PoIF6q8HFsujK6giZvrOj+VO1pYMBNas8pYOBp6kTgmeh0/8bmZWVybZnl+w3RhV
         GTcw==
X-Gm-Message-State: APjAAAU2BRtLFoFR1LLpKXSbOzRlj9XOP/l4wTSbytJ47pnOXC8tpwkg
        qVPRev/oAXCongdw1ztoZzfxw2phINvgdiQ7qNO82WkKYEgrqw==
X-Google-Smtp-Source: APXvYqzT7IerJNNFMnYRR+Po/i+0kB4BZ+68cayae2x5+Ltrz85wtCyfQyhtm7ywToLvfaVCaZxLzyDNm/4739Q7r10=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr14505828qkf.437.1562018288466;
 Mon, 01 Jul 2019 14:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190629034906.1209916-1-andriin@fb.com> <20190629034906.1209916-4-andriin@fb.com>
 <964c51ff-2b83-98e8-4b20-aaa7336a5536@fb.com>
In-Reply-To: <964c51ff-2b83-98e8-4b20-aaa7336a5536@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jul 2019 14:57:57 -0700
Message-ID: <CAEf4Bzbz+bnM2E8aGP-eWtqDBepQ0Rc_KU-n+FQHnOrnFAWKwg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/9] libbpf: add ability to attach/detach BPF
 program to perf event
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 10:03 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/28/19 8:49 PM, Andrii Nakryiko wrote:
> > bpf_program__attach_perf_event allows to attach BPF program to existing
> > perf event hook, providing most generic and most low-level way to attach BPF
> > programs. It returns struct bpf_link, which should be passed to
> > bpf_link__destroy to detach and free resources, associated with a link.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/lib/bpf/libbpf.c   | 61 ++++++++++++++++++++++++++++++++++++++++
> >   tools/lib/bpf/libbpf.h   |  3 ++
> >   tools/lib/bpf/libbpf.map |  1 +
> >   3 files changed, 65 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 455795e6f8af..98c155ec3bfa 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -32,6 +32,7 @@
> >   #include <linux/limits.h>
> >   #include <linux/perf_event.h>
> >   #include <linux/ring_buffer.h>
> > +#include <sys/ioctl.h>
> >   #include <sys/stat.h>
> >   #include <sys/types.h>
> >   #include <sys/vfs.h>
> > @@ -3958,6 +3959,66 @@ int bpf_link__destroy(struct bpf_link *link)
> >       return err;
> >   }
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
> > +     if (err)
> > +             err = -errno;
> > +
> > +     close(l->fd);
> > +     return err;
> > +}
> > +
> > +struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> > +                                             int pfd)
> > +{
> > +     char errmsg[STRERR_BUFSIZE];
> > +     struct bpf_link_fd *link;
> > +     int prog_fd, err;
> > +
> > +     prog_fd = bpf_program__fd(prog);
> > +     if (prog_fd < 0) {
> > +             pr_warning("program '%s': can't attach before loaded\n",
> > +                        bpf_program__title(prog, false));
> > +             return ERR_PTR(-EINVAL);
> > +     }
>
> should we check validity of pfd here?
> If pfd < 0, we just return ERR_PTR(-EINVAL)?

I can add that. I didn't do it, because in general, you can provide fd
>= 0 which is still not a valid FD for PERF_EVENT_IOC_SET_BPF and
PERF_EVENT_IOC_ENABLE, so in general we can't detect this reliably.

> This way, in bpf_link__destroy_perf_event(), we do not need to check
> l->fd < 0 since it will be always nonnegative.

That check is not needed anyway, because even if pfd < 0, ioctl should
fail and return error. I'll remove that check.

>
> > +
> > +     link = malloc(sizeof(*link));
> > +     if (!link)
> > +             return ERR_PTR(-ENOMEM);
> > +     link->link.destroy = &bpf_link__destroy_perf_event;
> > +     link->fd = pfd;
> > +
> > +     if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, prog_fd) < 0) {
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
> >   enum bpf_perf_event_ret
> >   bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> >                          void **copy_mem, size_t *copy_size,
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 5082a5ebb0c2..1bf66c4a9330 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -169,6 +169,9 @@ struct bpf_link;
> >
> >   LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
> >
> > +LIBBPF_API struct bpf_link *
> > +bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> > +
> >   struct bpf_insn;
> >
> >   /*
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
> >
