Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35EF91634D0
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbgBRVYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 16:24:46 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45232 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgBRVYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 16:24:46 -0500
Received: by mail-qk1-f194.google.com with SMTP id a2so20981623qko.12;
        Tue, 18 Feb 2020 13:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zg2852gQQh2mFH8QYowdeedt6WFr2dfJk+O113y+1I0=;
        b=ZG0/kECIYt/sSCRD+jvya5g1NGG27MiEL9L30hlgZLPmHQGXHOTU3pMieIqV8ysc1w
         lmL+Wiy2Z8wryv9fCq5s6VgN5iBW4w35Sy/9PLJSklpKP6/wsqHIVXYJrCa1aa399WeM
         tdjPHuyKiHSzeF63I3vTEpRDUmr/QA9GBOOAw14O21AqkWF2eg6u7oz7zcNSKGLZSb/e
         WxA5HC6uFjOZAMwwhstpk9O9lzznr53JK48vbc5oH1meqixDY0yQwejd81tIU0Jw3WiD
         ekN0iA5iTr4fqMOLabXCMdVex4eSs6netfOcgoDpYaXh2FXc5Ec66wyfiY4aS12xYgvZ
         NzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zg2852gQQh2mFH8QYowdeedt6WFr2dfJk+O113y+1I0=;
        b=akPRFujd/Lgho1i3Nlp33t9sv1P+f+icmr0WBZZw7Vloc4lZmf5qF7qJu2KcaMeepq
         jTr/d70IdgbF0WTfoan0XMeLBB8rOttDdcbvp7TGXCcI+aD6FhtesLQf6H3u8A3Brb4B
         YCzlHakBn1sg+EDlgf0d01vLCC3QI11b6+uWAxCTB+9eHOoFGAnmGXPzIC8eqWyT5wN/
         Wqw4Mbtbl2opjAEvjswt8mF/k2mOdXquSAh2tInxF5nnLhe8P7nbUPsHntVNWOIzT3c4
         x+fiboAoyVRmgLxeE0p6ADx7BuDihvVYn81ng484z3aN3nLM92tJvhLhoKwETDT1xQLR
         qF5g==
X-Gm-Message-State: APjAAAVqFmNn3Ebugvdc/QXkzF5JjB0tjtWh6sBxqiH/UuMXNoIZn0BE
        5ftNuehqXAcw3v+Xq1SqIvI+9UkE55wakXkOHhY=
X-Google-Smtp-Source: APXvYqw4sPmZ406Dld5myCG2O7yc+VlGH1P9VqagkA/4u+2BMhKNNjv2z6TSRCXKwSEUSn5Ahnd0A8OrUPl8HYZ+LMQ=
X-Received: by 2002:a37:2744:: with SMTP id n65mr20632222qkn.92.1582061085024;
 Tue, 18 Feb 2020 13:24:45 -0800 (PST)
MIME-Version: 1.0
References: <158194337246.104074.6407151818088717541.stgit@xdp-tutorial>
 <158194341424.104074.4927911845622583345.stgit@xdp-tutorial> <877e0jam7z.fsf@cloudflare.com>
In-Reply-To: <877e0jam7z.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Feb 2020 13:24:34 -0800
Message-ID: <CAEf4BzZ_H7_HVL0uDkxP2hvW7FC=9r_V4X2VzgB+uZMZcxP7aQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: Add support for dynamic program
 attach target
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 8:34 AM Jakub Sitnicki <jakub@cloudflare.com> wrote=
:
>
> Hey Eelco,
>
> On Mon, Feb 17, 2020 at 12:43 PM GMT, Eelco Chaudron wrote:
> > Currently when you want to attach a trace program to a bpf program
> > the section name needs to match the tracepoint/function semantics.
> >
> > However the addition of the bpf_program__set_attach_target() API
> > allows you to specify the tracepoint/function dynamically.
> >
> > The call flow would look something like this:
> >
> >   xdp_fd =3D bpf_prog_get_fd_by_id(id);
> >   trace_obj =3D bpf_object__open_file("func.o", NULL);
> >   prog =3D bpf_object__find_program_by_title(trace_obj,
> >                                            "fentry/myfunc");
> >   bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
> >   bpf_program__set_attach_target(prog, xdp_fd,
> >                                  "xdpfilt_blk_all");
> >   bpf_object__load(trace_obj)
> >
> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> > ---
> >  tools/lib/bpf/libbpf.c   |   34 ++++++++++++++++++++++++++++++----
> >  tools/lib/bpf/libbpf.h   |    4 ++++
> >  tools/lib/bpf/libbpf.map |    2 ++
> >  3 files changed, 36 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 514b1a524abb..0c25d78fb5d8 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
>
> [...]
>
> > @@ -8132,6 +8133,31 @@ void bpf_program__bpil_offs_to_addr(struct bpf_p=
rog_info_linear *info_linear)
> >       }
> >  }
> >
> > +int bpf_program__set_attach_target(struct bpf_program *prog,
> > +                                int attach_prog_fd,
> > +                                const char *attach_func_name)
> > +{
> > +     int btf_id;
> > +
> > +     if (!prog || attach_prog_fd < 0 || !attach_func_name)
> > +             return -EINVAL;
> > +
> > +     if (attach_prog_fd)
> > +             btf_id =3D libbpf_find_prog_btf_id(attach_func_name,
> > +                                              attach_prog_fd);
> > +     else
> > +             btf_id =3D __find_vmlinux_btf_id(prog->obj->btf_vmlinux,
> > +                                            attach_func_name,
> > +                                            prog->expected_attach_type=
);
> > +
> > +     if (btf_id <=3D 0)
> > +             return btf_id;
>
> Looks like we can get 0 as return value on both error and success
> (below)?  Is that intentional?

Neither libbpf_find_prog_btf_id nor __find_vmlinux_btf_id are going to
return 0 on failure. But I do agree that if (btf_id < 0) check would
be better here.

With that minor nit:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> > +
> > +     prog->attach_btf_id =3D btf_id;
> > +     prog->attach_prog_fd =3D attach_prog_fd;
> > +     return 0;
> > +}
> > +
> >  int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz)
> >  {
> >       int err =3D 0, n, len, start, end =3D -1;
>
> [...]
