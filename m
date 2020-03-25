Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE060191DE6
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 01:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgCYAI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 20:08:27 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45359 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbgCYAI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 20:08:27 -0400
Received: by mail-qt1-f195.google.com with SMTP id t17so642661qtn.12;
        Tue, 24 Mar 2020 17:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2DF5coVVXDIgj1IoD87dZv1MBeX8WeUVEnAL7X7UY1Y=;
        b=DwP6Dm6KmE36BJxFyTTwt6kyQSpRXmWc3pcRuQ9sFytELVwzLzFVcih4isCNPYSUfg
         br4bC0VWhGAExZO51nMAcWP/4+v6neawrt+Tfew66PO1T9CYQuOd7QF0j4J59YHZeK3N
         Rl4tzn1Fjk1AhfkPnjCB6Dh1OsBbIgS2EGDnFjwSn9O65CK/jQW09Wrmf/VbgO19vG8B
         BkTwRhmGK1ZLAuFurXkhlbp7ta1xqEp6DupOk8sD9EgyJEOXK/EJ5VR0otkgf0D/Q7GS
         +sMha7+iQfWuVN4YERDQn0A0R2LMWjIoRD5jVefh91NPrHbmS9Jo8YklV46YgL4BvlFS
         /33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2DF5coVVXDIgj1IoD87dZv1MBeX8WeUVEnAL7X7UY1Y=;
        b=QBuZmVL5AnOE8y2Av1aRT9Dpmuw7Rubu+grTM+6XmEUQZ1IE/Or+JbliYs85moxlU1
         7NW9fXSh3w2TCuaw8X0MadFofp2ZbOFIuNELKdu4HbvErjcULV14VCAh87FZz7/j9v9U
         PIqIMwEI4GLMXyamF4osPzwOjA4cnxVJx2dPksRb+Yz2a+W6dWKxR4zYUtzoQd9FFmMS
         qL2xzIk7jju3uVTQspeklHZybI0dACoZJM3XlPaO5jDlaNXawZkaKC3iUxeT3bep63Sp
         EI/haBM7qn1PY5xlAeI6XLjagHBiY1fT8TTdcRSAOfLBx1bsTQb4aRpRVyBrVHumk923
         Zpww==
X-Gm-Message-State: ANhLgQ0Lf2MmI5OChoVPbZN8pufpqZ2tlJo+Yr3Efe7tcwNFuCZfY21s
        GVCzyeMWjax3CislbGDmorq1eMhUkMxi6rHPRsg=
X-Google-Smtp-Source: ADFU+vu8iQAKnXjA7AzGphcraPYrV36T5kQYirRTB0klNKXx8tKQx5pcE9VgAtDnVIkKFtpa+3QN81wDiDyDgTOSXzY=
X-Received: by 2002:ac8:7cb0:: with SMTP id z16mr477248qtv.59.1585094904599;
 Tue, 24 Mar 2020 17:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200324233120.66314-1-sdf@google.com> <CAEf4BzbFOjSDw9YvsoZGtzWVbZykg62atNAgzt19audTXmvprw@mail.gmail.com>
 <20200324235938.GA2805006@mini-arch.hsd1.ca.comcast.net>
In-Reply-To: <20200324235938.GA2805006@mini-arch.hsd1.ca.comcast.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 Mar 2020 17:08:13 -0700
Message-ID: <CAEf4BzbF+QmKAmkhrNMn2EEo0nPMmyb0T=BwLvDm+KFE1ZrhrA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: don't allocate 16M for log buffer by default
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 4:59 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 03/24, Andrii Nakryiko wrote:
> > On Tue, Mar 24, 2020 at 4:31 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > For each prog/btf load we allocate and free 16 megs of verifier buffer.
> > > On production systems it doesn't really make sense because the
> > > programs/btf have gone through extensive testing and (mostly) guaranteed
> > > to successfully load.
> > >
> > > Let's switch to a much smaller buffer by default (128 bytes, sys_bpf
> > > doesn't accept smaller log buffer) and resize it if the kernel returns
> > > ENOSPC. On the first ENOSPC error we resize the buffer to BPF_LOG_BUF_SIZE
> > > and then, on each subsequent ENOSPC, we keep doubling the buffer.
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  tools/lib/bpf/btf.c             | 10 +++++++++-
> > >  tools/lib/bpf/libbpf.c          | 10 ++++++++--
> > >  tools/lib/bpf/libbpf_internal.h |  2 ++
> > >  3 files changed, 19 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > > index 3d1c25fc97ae..53c7efc3b347 100644
> > > --- a/tools/lib/bpf/btf.c
> > > +++ b/tools/lib/bpf/btf.c
> > > @@ -657,13 +657,14 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
> > >
> > >  int btf__load(struct btf *btf)
> > >  {
> > > -       __u32 log_buf_size = BPF_LOG_BUF_SIZE;
> > > +       __u32 log_buf_size = BPF_MIN_LOG_BUF_SIZE;
> > >         char *log_buf = NULL;
> > >         int err = 0;
> > >
> > >         if (btf->fd >= 0)
> > >                 return -EEXIST;
> > >
> > > +retry_load:
> > >         log_buf = malloc(log_buf_size);
> > >         if (!log_buf)
> > >                 return -ENOMEM;
> >
> > I'd argue that on first try we shouldn't allocate log_buf at all, then
> > start allocating it using reasonable starting size (see below).
> Agreed, makes sense.
>
> > > @@ -673,6 +674,13 @@ int btf__load(struct btf *btf)
> > >         btf->fd = bpf_load_btf(btf->data, btf->data_size,
> > >                                log_buf, log_buf_size, false);
> > >         if (btf->fd < 0) {
> > > +               if (errno == ENOSPC) {
> > > +                       log_buf_size = max((__u32)BPF_LOG_BUF_SIZE,
> > > +                                          log_buf_size << 1);
> > > +                       free(log_buf);
> > > +                       goto retry_load;
> > > +               }
> > > +
> > >                 err = -errno;
> > >                 pr_warn("Error loading BTF: %s(%d)\n", strerror(errno), errno);
> > >                 if (*log_buf)
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 085e41f9b68e..793c81b35ccc 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -4855,7 +4855,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> > >  {
> > >         struct bpf_load_program_attr load_attr;
> > >         char *cp, errmsg[STRERR_BUFSIZE];
> > > -       int log_buf_size = BPF_LOG_BUF_SIZE;
> > > +       size_t log_buf_size = BPF_MIN_LOG_BUF_SIZE;
> > >         char *log_buf;
> > >         int btf_fd, ret;
> > >
> > > @@ -4911,7 +4911,13 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> > >         }
> > >
> > >         if (errno == ENOSPC) {
> >
> > same, doing if (!log_buf || errno == ENOSPC) should handle this
> > without any other major changes?
> Yeah, I don't see why it shouldn't. Let me try to see if I hit something
> in the selftests with that approach.
>
> > > -               log_buf_size <<= 1;
> > > +               if (errno == ENOSPC) {
> > > +                       log_buf_size = max((size_t)BPF_LOG_BUF_SIZE,
> > > +                                          log_buf_size << 1);
> > > +                       free(log_buf);
> > > +                       goto retry_load;
> > > +               }
> > > +
> > >                 free(log_buf);
> > >                 goto retry_load;
> > >         }
> > > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> > > index 8c3afbd97747..2720f3366798 100644
> > > --- a/tools/lib/bpf/libbpf_internal.h
> > > +++ b/tools/lib/bpf/libbpf_internal.h
> > > @@ -23,6 +23,8 @@
> > >  #define BTF_PARAM_ENC(name, type) (name), (type)
> > >  #define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
> > >
> > > +#define BPF_MIN_LOG_BUF_SIZE 128
> >
> > This seems way too low, if there is some error it almost certainly
> > will be too short, probably for few iterations, just causing waste.
> > Let's make it something a bit more reasonable, like 32KB or something?
> In this case, maybe start with the existing 16M BPF_LOG_BUF_SIZE?
> My goal here is optimize for the successful case. If there is an error the
> size shouldn't matter that much.

Not feeling strongly. But we already will have a retry loop, so not
too hard to do it in steps. Then also errors do happen in production
as well, and it would be good to not eat too much memory
unnecessarily.
