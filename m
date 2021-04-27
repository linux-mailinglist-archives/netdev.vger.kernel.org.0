Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19ADF36C98D
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237387AbhD0Qhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 12:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbhD0Qhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 12:37:50 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A617EC061574;
        Tue, 27 Apr 2021 09:37:06 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id t94so16896749ybi.3;
        Tue, 27 Apr 2021 09:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kXy7BwT5D1v9Mb1m9OxC7R9BL9JLGyQpAEtt6UUshkI=;
        b=VVio8mfyVpcKSeQt8ZRfxbTvG29GW3pyyMl2CfNO5+JfCRJWw3AbPz7XGFbaj9k6Qp
         OSwopmbS+qdKQTH9VS3HoNWuOsjnlqqUoYEzUVNKjMdIX72Ogrz5Q0lDZnayxIOY5Fnb
         8fS5rs0Tv7BF9UjMUDHrFbyjAmFnFIYia1UxLOGvDek+HZebPjQbfbVsvOzvAv79rQTW
         01f4KLmzyTmraUj0QVmb35Z7e8QVAcdiBea6CpCtS3W6y9h7KFxs+kQUm5VQrLQ4NF2K
         KuUbFw6N4chFql23dcVAp3bpOpBzrGdP21tagQam21JC/eDwswoXDK4MMmJO0jvUA4a3
         7ysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kXy7BwT5D1v9Mb1m9OxC7R9BL9JLGyQpAEtt6UUshkI=;
        b=JSDnMSctXg1D5+0QT5B6azDhtbbOsxDViyRS/EUGgU4V8t7juJt6mt5Rct/uGlIjtx
         Nztr8GhUyoihI9owh0OlPoln6Tv+Kte9ZHkA+Qma+QvDfkZxLq2cDYcvDGIshb+Jedv1
         +YmPpSA4kDaLPvjJxBVXpUj2NWCE62EaQbOuiw+YHfpcPcZ9lHgv8n+g7iLSoF4sYe0S
         KWaTvhcLAsTcJCQLV8AvYI4ikD9OXa/5zd7LiB1wmMdq9gM36O+MROR+wb9kNLm4CP/n
         u4HzLwU1iWBmHCP+mv93GOMMpMMMHSBZwQrKFDUk9bb/DsdmgfGrkMHpq9PvFAAgo4RY
         pTpQ==
X-Gm-Message-State: AOAM532aPNuUZ57h/6oKIbyJLVL9/5IzPn3H9TdP+36FgYq1Kb2XWNM1
        XstZW1mFhvoj1g5lxobZgz838fimsZgWmqY5tQCUMf0S
X-Google-Smtp-Source: ABdhPJwAHvXIwz/rjYCCgUPR2bsyHNIsIHm8se04g/T342TlwGhKcmkr3GF4WtIywO5gLBO47tfar879ZGRDwHjNas0=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr31594621ybg.459.1619541425877;
 Tue, 27 Apr 2021 09:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-10-alexei.starovoitov@gmail.com> <CAEf4BzZ5CJmF45_aBWBHt2jYeLjs2o5VXEA3zfLDvTncW_hjZg@mail.gmail.com>
 <20210427025309.yma2vy4m4qbk5srv@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210427025309.yma2vy4m4qbk5srv@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Apr 2021 09:36:54 -0700
Message-ID: <CAEf4BzbDUwev3Wk7_K=2LDwTR0GN8_So8nDUwa9TfSXS0J+FCg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 09/16] libbpf: Support for fd_idx
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 7:53 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 26, 2021 at 10:14:45AM -0700, Andrii Nakryiko wrote:
> > On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Add support for FD_IDX make libbpf prefer that approach to loading programs.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >  tools/lib/bpf/bpf.c             |  1 +
> > >  tools/lib/bpf/libbpf.c          | 70 +++++++++++++++++++++++++++++----
> > >  tools/lib/bpf/libbpf_internal.h |  1 +
> > >  3 files changed, 65 insertions(+), 7 deletions(-)
> > >
> >

[...]

> > >         for (i = 0; i < obj->nr_programs; i++) {
> > >                 prog = &obj->programs[i];
> > >                 if (prog_is_subprog(obj, prog))
> > > @@ -7256,10 +7308,14 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
> > >                         continue;
> > >                 }
> > >                 prog->log_level |= log_level;
> > > +               prog->fd_array = fd_array;
> >
> > you are not freeing this memory on success, as far as I can see.
>
> hmm. there is free on success below.

right, my bad, I somehow understood as if it was only for error case

>
> > And
> > given multiple programs are sharing fd_array, it's a bit problematic
> > for prog to have fd_array. This is per-object properly, so let's add
> > it at bpf_object level and clean it up on bpf_object__close()? And by
> > assigning to obj->fd_array at malloc() site, you won't need to do all
> > the error-handling free()s below.
>
> hmm. that sounds worse.
> why add another 8 byte to bpf_object that won't be used
> until this last step of bpf_object__load_progs.
> And only for the duration of this loading.
> It's cheaper to have this alloc here with two free()s below.

So if you care about extra 8 bytes, then it's even more efficient to
have just one obj->fd_array rather than N prog->fd_array, no? And it's
also not very clean that prog->fd_array will have a dangling pointer
to deallocated memory after bpf_object__load_progs().

But that brings the entire question of why use fd_array at all here?
Commit description doesn't explain why libbpf has to use fd_array and
why it should be preferred. What are the advantages justifying added
complexity and extra memory allocation/clean up? It also reduces test
coverage of the "old ways" that offer the same capabilities. I think
this should be part of the commit description, if we agree that
fd_array has to be used outside of the auto-generated loader program.


>
> >
> > >                 err = bpf_program__load(prog, obj->license, obj->kern_version);
> > > -               if (err)
> > > +               if (err) {
> > > +                       free(fd_array);
> > >                         return err;
> > > +               }
> > >         }
> > > +       free(fd_array);
> > >         return 0;
> > >  }
> > >
> > > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> > > index 6017902c687e..9114c7085f2a 100644
> > > --- a/tools/lib/bpf/libbpf_internal.h
> > > +++ b/tools/lib/bpf/libbpf_internal.h
> > > @@ -204,6 +204,7 @@ struct bpf_prog_load_params {
> > >         __u32 log_level;
> > >         char *log_buf;
> > >         size_t log_buf_sz;
> > > +       int *fd_array;
> > >  };
> > >
> > >  int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
> > > --
> > > 2.30.2
> > >
>
> --
