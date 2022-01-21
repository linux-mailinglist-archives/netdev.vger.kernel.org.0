Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54109496691
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 21:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiAUUqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 15:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiAUUqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 15:46:07 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5944BC06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 12:46:06 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id x7so36225220lfu.8
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 12:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uxTrw+AT4Z4hFq9OQh3UXx0QiOHdIRBcnwHs8G1s3f4=;
        b=bTkkgx/ru/kjbankRrw2xRbbbD6du9RHIAVIUMOfBU4t9A3gfQHVeLaUvdQGw9ubmq
         SXC4mf4OjW9HX/NL2+2Le/RUKYrOLASIRlMIgTHrIRgNprVtF6x1J+fIVUDriVnNbWao
         KUbSXWbd5uPQrA4w8ljByUE+4ZIgBEpqbTGz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uxTrw+AT4Z4hFq9OQh3UXx0QiOHdIRBcnwHs8G1s3f4=;
        b=XK1LFeBEZqSQV3gjacO/5+5lhrj6tgCGha8p+EeE+szVxzoLi7QcTKV6hQCQRdTAS+
         9OGCgUeInvv7BOZP4XjCHiXvROA07SPW+QuFfYPBoX/BNAhgC6rTnYGdT3RRRTfTz4+r
         PvKgBlOHFXqK3sU72BRUTZRVSerRbPM0iv+0ktLAFy73FEcOsFaXvOj59Ehi2D/UTyH3
         MwSLbsGcFLswLTpWfQ31V7npEz28DHEvZy6s8MBQQ/9sOH+tvrlywatqbgHi7F+Vwfyd
         itaE/hLcPUCq7q7pIBrZP139PytSuzFfvOz48GRv3905FdidcIf45TszrLn4ZpisFu4C
         58Gw==
X-Gm-Message-State: AOAM531Ic1A4OpFl6APmCLOWBkjprhtdtSc3cc3VrI4R3RvU0LoPulGv
        rJBx+CLD5ZIlNpHfhplugSb48m00HxFS5FI6EX7kvA==
X-Google-Smtp-Source: ABdhPJyrKkp6VxgHmqOWhq9Zu/IYvR/JTejtQJyAIJpfUjyaGp3WLf+spqeL0H3S/3DvaUyL4/TNUkBU1ckPRvAujGM=
X-Received: by 2002:a05:6512:151b:: with SMTP id bq27mr4777460lfb.56.1642797928816;
 Fri, 21 Jan 2022 12:45:28 -0800 (PST)
MIME-Version: 1.0
References: <20220112142709.102423-1-mauricio@kinvolk.io> <20220112142709.102423-5-mauricio@kinvolk.io>
 <CAEf4BzZN39SM85zuOV+6gP1KK0fdvUGVxL3THpzRNWTOi7KCxw@mail.gmail.com>
In-Reply-To: <CAEf4BzZN39SM85zuOV+6gP1KK0fdvUGVxL3THpzRNWTOi7KCxw@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Fri, 21 Jan 2022 15:45:17 -0500
Message-ID: <CAHap4ztH7vaVjhYMvBKbpkrbVP93egxwNSy08TrNv=GaJWRBGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/8] bpftool: Implement btf_save_raw()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 9:10 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jan 12, 2022 at 6:27 AM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> >
> > Helper function to save a BTF object to a file.
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/bpf/bpftool/gen.c | 30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >
>
> See suggestions, but either way:
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>
>
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index cdeb1047d79d..5a74fb68dc84 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -1096,6 +1096,36 @@ static int do_help(int argc, char **argv)
> >         return 0;
> >  }
> >
> > +static int btf_save_raw(const struct btf *btf, const char *path)
> > +{
> > +       const void *data;
> > +       FILE *f =3D NULL;
> > +       __u32 data_sz;
> > +       int err =3D 0;
> > +
> > +       data =3D btf__raw_data(btf, &data_sz);
> > +       if (!data) {
> > +               err =3D -ENOMEM;
> > +               goto out;
> > +       }
>
> can do just return -ENOMEM instead of goto
>
> > +
> > +       f =3D fopen(path, "wb");
> > +       if (!f) {
> > +               err =3D -errno;
> > +               goto out;
> > +       }
> > +
> > +       if (fwrite(data, 1, data_sz, f) !=3D data_sz) {
> > +               err =3D -errno;
> > +               goto out;
> > +       }
> > +
> > +out:
> > +       if (f)
>
> with early return above, no need for if (f) check
>

After those suggestions I decided to completely remove the out label.



> > +               fclose(f);
> > +       return err;
> > +}
> > +
> >  /* Create BTF file for a set of BPF objects */
> >  static int btfgen(const char *src_btf, const char *dst_btf, const char=
 *objspaths[])
> >  {
> > --
> > 2.25.1
> >
