Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545695A134
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfF1Qmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:42:31 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46093 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1Qma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:42:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so6950661qtn.13;
        Fri, 28 Jun 2019 09:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IUIwHUeXo4rhDTxunnx/s8IdsaR74Ym5bPh3s0R0vl0=;
        b=YVk/9h48fxacUxC9NOzxh46x9oIYe+dLZ53LelHTKFlDZcO44F3bgxvLq0Wu3w5HzS
         CTxyKUKlsiUOdnI4XVBP8D3kzPWVnLsfF02e/uia9kiiY1sBEWE5MkwgiL9ho2vBm/z/
         xzNt1Evgb+vFvOkWs+97164UKPZpy00kHw/Ls1BF99oVseQOMHlEbCxJ+XN4bi0GlUDg
         qweKsN8Qqf0YY4prAin7mSvWKbx9/Spss2bo/pTM9tvkB3KZOm65dZx/rFwCHOX5ia12
         UDkQ5ADQXj/q5OtAQLct0in6zdyXFBtJL5392BngR8A1pekpcnbk8f1PtgI3IcT7+Co1
         d67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IUIwHUeXo4rhDTxunnx/s8IdsaR74Ym5bPh3s0R0vl0=;
        b=hqEjnKtxqhrcTYERKkLf0seO+GKliEZJh+HePhq/1SIQHCTRjKLfIoJswjsEb6QPnF
         vWRciBHVnLLznBBwLrUUBXjsiTJrBUN9EDmwDpYbH6Y26/NYnPcIdHCAdc4MpRz2F9G9
         AtGgPO9a6o3emw06Aswgid91BDqdmaG8S4Rq0wEUt/r7okRAOX3E6t53AhI31ySvS3zk
         QNH+ryMmLkoYCt6Gdv7896gm/yPTktlSY+jBM+VCoiyp0Cfie4M1lBaEQPI52q3vPiIk
         M6ciUdSmcO2CgsVke4pVEW7bYPU9FzF2Yl+RcQ1DIgoaCdbDpDK53C+WV9//mwuk+5H7
         CkmQ==
X-Gm-Message-State: APjAAAVnLozUdwCXO+Zx+1rOB5o53i2xz4oFSS4Zts9RV4cz/WgV3Gai
        bcpAmTcM87U5cSwd2AuvnDV52lMeRnalKKfs5EM=
X-Google-Smtp-Source: APXvYqwK34YZBkcZnl3lTCKmgMftDydFY4admd5vzVXrUiezg/fBGFj/IILvzX61sS0a7XYtERE+np9pUG5HzNVkxZE=
X-Received: by 2002:a0c:ae50:: with SMTP id z16mr9031077qvc.60.1561740149411;
 Fri, 28 Jun 2019 09:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-3-andriin@fb.com>
 <20190628160230.GG4866@mini-arch>
In-Reply-To: <20190628160230.GG4866@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 28 Jun 2019 09:42:18 -0700
Message-ID: <CAEf4BzbB6G5jTvS+K0+0zPXWLFmAePHU2RtALogWrh7h7OV03A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/9] libbpf: introduce concept of bpf_link
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

On Fri, Jun 28, 2019 at 9:02 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/27, Andrii Nakryiko wrote:
> > bpf_link is and abstraction of an association of a BPF program and one
> > of many possible BPF attachment points (hooks). This allows to have
> > uniform interface for detaching BPF programs regardless of the nature of
> > link and how it was created. Details of creation and setting up of
> > a specific bpf_link is handled by corresponding attachment methods
> > (bpf_program__attach_xxx) added in subsequent commits. Once successfully
> > created, bpf_link has to be eventually destroyed with
> > bpf_link__destroy(), at which point BPF program is disassociated from
> > a hook and all the relevant resources are freed.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c   | 17 +++++++++++++++++
> >  tools/lib/bpf/libbpf.h   |  4 ++++
> >  tools/lib/bpf/libbpf.map |  3 ++-
> >  3 files changed, 23 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 6e6ebef11ba3..455795e6f8af 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -3941,6 +3941,23 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
> >       return 0;
> >  }
> >
> > +struct bpf_link {
> Maybe call it bpf_attachment? You call the bpf_program__attach_to_blah
> and you get an attachment?

I wanted to keep it as short as possible, bpf_attachment is way too
long (it's also why as an alternative I've proposed bpf_assoc, not
bpf_association, but bpf_attach isn't great shortening).

>
> > +     int (*destroy)(struct bpf_link *link);
> > +};
> > +
> > +int bpf_link__destroy(struct bpf_link *link)
> > +{
> > +     int err;
> > +
> > +     if (!link)
> > +             return 0;
> > +
> > +     err = link->destroy(link);
> > +     free(link);
> > +
> > +     return err;
> > +}
> > +
> >  enum bpf_perf_event_ret
> >  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> >                          void **copy_mem, size_t *copy_size,
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index d639f47e3110..5082a5ebb0c2 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -165,6 +165,10 @@ LIBBPF_API int bpf_program__pin(struct bpf_program *prog, const char *path);
> >  LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *path);
> >  LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
> >
> > +struct bpf_link;
> > +
> > +LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
> > +
> >  struct bpf_insn;
> >
> >  /*
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 2c6d835620d2..3cde850fc8da 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -167,10 +167,11 @@ LIBBPF_0.0.3 {
> >
> >  LIBBPF_0.0.4 {
> >       global:
> > +             bpf_link__destroy;
> > +             bpf_object__load_xattr;
> >               btf_dump__dump_type;
> >               btf_dump__free;
> >               btf_dump__new;
> >               btf__parse_elf;
> > -             bpf_object__load_xattr;
> >               libbpf_num_possible_cpus;
> >  } LIBBPF_0.0.3;
> > --
> > 2.17.1
> >
