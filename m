Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D6C45756B
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 18:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbhKSR2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 12:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKSR2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 12:28:25 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E755C061574;
        Fri, 19 Nov 2021 09:25:23 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id y68so30339328ybe.1;
        Fri, 19 Nov 2021 09:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vsivSR1lJ20GN+/7nsHP6yydKJa6W3R0YLdb9SIpPic=;
        b=NJ/DFDG9JbRqCx39SX1265V+VMlYRyHStIwzcgH4nC4VDmh5fbvGMy+ihE0s19v5T6
         +JM+mrCzFectuDDmHhDT9+Ne2LphFXD02W+90TySDVevshdvNTudXAsfnM2zms9/K19d
         ej9IjfKy/fxiqbFF8pnDvznmfteCeU1/k1Z0VoEesRJ/7lkWr9wKkIjiwT50bxWiTlm2
         2qBOLfSYAC3ZkUzMeycRtfzzOUa6ES6ktl8i/L10QidkCGrYmEVxIzv2OfcEuXzAvzS4
         87s/Ba0huzEmmmJp9kTj69q0KQ0Jult04zr50LinnoQNFmCEQZ+x9tRO/+rLN+4bEg8f
         LgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vsivSR1lJ20GN+/7nsHP6yydKJa6W3R0YLdb9SIpPic=;
        b=TpYwPtm76/fZSkHfxdoHfImBJVMbc4rUd2KYCKaz/9qayHfRgnxx5ZuQUbFh2mX9Nm
         crF/acGellef4eohWE4DkaSaJ64VTjxVXZ79W1QXCcCongpHMWCq2ScVVOYNnnV1mki4
         vLpsL5SdWDiA6XQLiZ6/rNLRvv6UH96TjZySoSTtjphre7Mdu3Myvxu4JAJYErI8WRSQ
         oSAs2l539ZBVarjY47TOct0in4aZ/rJvkp5lb5Vn/r8N8ivZ7RHbD9M5E8YPkeNROprq
         byPM2bhwicbC+qZO+641DNx+jCs/25S36M3XdJQtk1G9p31rmhDzQNYMzIGV+wlfOxF5
         5bSw==
X-Gm-Message-State: AOAM531Zehi99pBtM7IIS/2l4VCYN6aWnlZ3QS4jcPkci4af2AZ8pKqX
        qJDjM5bGeKuBrIQmOEcoP3dH4p0AuFRYigdY5iE=
X-Google-Smtp-Source: ABdhPJwiK/FiipM/uV4ERVm4LXo3j3ZoCPBvBAFJx4H7ZClNRRwQ97pIUZagxUJ6Xn7+kbZ3Wn15XY/R1dqzcAdul4M=
X-Received: by 2002:a25:ccd4:: with SMTP id l203mr16727955ybf.225.1637342722568;
 Fri, 19 Nov 2021 09:25:22 -0800 (PST)
MIME-Version: 1.0
References: <20211116164208.164245-1-mauricio@kinvolk.io> <20211116164208.164245-2-mauricio@kinvolk.io>
 <CAEf4BzZOu4frtBqzqYO0dkmw+bXuhr91qQ7o5Lyrv_44eniN9g@mail.gmail.com>
In-Reply-To: <CAEf4BzZOu4frtBqzqYO0dkmw+bXuhr91qQ7o5Lyrv_44eniN9g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Nov 2021 09:25:11 -0800
Message-ID: <CAEf4BzaZF1sM49UhRQrxBjCOHF1RtxT8hJumtcgZaZ1Np5hinA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/4] libbpf: Implement btf__save_raw()
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 9:25 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 16, 2021 at 8:42 AM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> >
> > Implement helper function to save the contents of a BTF object to a
> > file.
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/lib/bpf/btf.c      | 30 ++++++++++++++++++++++++++++++
> >  tools/lib/bpf/btf.h      |  2 ++
> >  tools/lib/bpf/libbpf.map |  1 +
> >  3 files changed, 33 insertions(+)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index fadf089ae8fe..96a242f91832 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -1121,6 +1121,36 @@ struct btf *btf__parse_split(const char *path, s=
truct btf *base_btf)
> >         return libbpf_ptr(btf_parse(path, base_btf, NULL));
> >  }
> >
> > +int btf__save_raw(const struct btf *btf, const char *path)
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
> > +               fclose(f);
> > +       return libbpf_err(err);
> > +}
> > +
> >  static void *btf_get_raw_data(const struct btf *btf, __u32 *size, bool=
 swap_endian);
> >
> >  int btf__load_into_kernel(struct btf *btf)
> > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > index 5c73a5b0a044..4f8d3f303aa6 100644
> > --- a/tools/lib/bpf/btf.h
> > +++ b/tools/lib/bpf/btf.h
> > @@ -114,6 +114,8 @@ LIBBPF_API struct btf *btf__parse_elf_split(const c=
har *path, struct btf *base_b
> >  LIBBPF_API struct btf *btf__parse_raw(const char *path);
> >  LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct b=
tf *base_btf);
> >
> > +LIBBPF_API int btf__save_raw(const struct btf *btf, const char *path);

Thinking about this some more, I don't feel it's necessary to have
this kind of API in libbpf. Libbpf provides raw bytes and it's not
hard to write dumping byte array to file. We don't have
btf__save_elf() and we probably shouldn't, so I don't see the need for
btf__save_raw() either. It's neither complicated nor frequently used
code to write.


> > +
> >  LIBBPF_API struct btf *btf__load_vmlinux_btf(void);
> >  LIBBPF_API struct btf *btf__load_module_btf(const char *module_name, s=
truct btf *vmlinux_btf);
> >  LIBBPF_API struct btf *libbpf_find_kernel_btf(void);
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 6a59514a48cf..c9555f8655af 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -414,4 +414,5 @@ LIBBPF_0.6.0 {
> >                 perf_buffer__new_deprecated;
> >                 perf_buffer__new_raw;
> >                 perf_buffer__new_raw_deprecated;
> > +               btf__save_raw;
>
> this is a sorted list, please keep it so
>
> >  } LIBBPF_0.5.0;
> > --
> > 2.25.1
> >
