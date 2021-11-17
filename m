Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B4245402C
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 06:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhKQF2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 00:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhKQF2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 00:28:32 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8415C061570;
        Tue, 16 Nov 2021 21:25:34 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id e71so3780398ybh.10;
        Tue, 16 Nov 2021 21:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Gctl7Lkc3igXRBCDfY8pcYxUuUrxwRiXZOBZPfzfPig=;
        b=Aqj8EuNIGd/UvajhEbSMIaTFfA10+wfawzgrMiZEIsQWeq+JpPiHXWwHhEp8Nqu3iL
         wk8o6fCNI/+EN/MEt46OkNPvqZ769l7ztupIvYDUsNkH0UzSJIG90iRgA4E5Xtx2yX2S
         RdpH8SEg871+ZHsVl344yfb5dMnc6GYCaui868FIhi1RloFqX5T9YqCVQW08V6FkHbYp
         w2faY8VMWKvIxcnZ5PGzfAu/r+wnmXelkJaevtPNS+XlJ6ctaZO96zdULqkR+kCezkoz
         SDvMiiBKyH1gP/S2wubh//5CmNZT2wgAUdUWK5qcVt0i9W3pKI4FBMqSoCus96krRVN/
         Gf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Gctl7Lkc3igXRBCDfY8pcYxUuUrxwRiXZOBZPfzfPig=;
        b=Q/J0IWYyRHtSVcJFDBCIOXVd1BBMph1li2piyv7MQHXrh1ZnhTo/HSRfrWszML/qnw
         pmBGWoi3rYhhJhCTLMBZp7KAR+NugHN6Qtvub6DtfzzYVH8tZ7lRFFwIwE/+dwgeThCS
         PH8m/fEqRfRCsiPWakuz6zhkNGXaTEJ5NG2LGVWslQbowxUnY7I++RgOVXx71XI3YidS
         0MZw9Hn26JxJ/AbPNsU9zkU5F0GC/zyxZy7pah6XqLZNRN3nIhTsVGA4dccE//a5uSDL
         3hdJ44NOM8EdypwZHQPItEjU82Vl7TcWXHpXPoq4tqGRvKAc/vtll/Er8Rujdcbe5VGH
         G5EQ==
X-Gm-Message-State: AOAM533nQpoLxNGjAj+LTj5aYksbAozMVsgoyb1MM1Qad7dxuMgRzBw8
        4YBSrJy7Gg7QlW6fcvcc4YMNLz3XbvAsS0uLdxs=
X-Google-Smtp-Source: ABdhPJwe4twla80yWOuUNFrFQ9caQCzMw15KvxdHjj+UKx/5SNaj1I0UExZFccCdEWTX+AobGoj5zvANoDp+l7a1x1k=
X-Received: by 2002:a25:d010:: with SMTP id h16mr16276801ybg.225.1637126733967;
 Tue, 16 Nov 2021 21:25:33 -0800 (PST)
MIME-Version: 1.0
References: <20211116164208.164245-1-mauricio@kinvolk.io> <20211116164208.164245-2-mauricio@kinvolk.io>
In-Reply-To: <20211116164208.164245-2-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Nov 2021 21:25:23 -0800
Message-ID: <CAEf4BzZOu4frtBqzqYO0dkmw+bXuhr91qQ7o5Lyrv_44eniN9g@mail.gmail.com>
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

On Tue, Nov 16, 2021 at 8:42 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> Implement helper function to save the contents of a BTF object to a
> file.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/lib/bpf/btf.c      | 30 ++++++++++++++++++++++++++++++
>  tools/lib/bpf/btf.h      |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 33 insertions(+)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index fadf089ae8fe..96a242f91832 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -1121,6 +1121,36 @@ struct btf *btf__parse_split(const char *path, str=
uct btf *base_btf)
>         return libbpf_ptr(btf_parse(path, base_btf, NULL));
>  }
>
> +int btf__save_raw(const struct btf *btf, const char *path)
> +{
> +       const void *data;
> +       FILE *f =3D NULL;
> +       __u32 data_sz;
> +       int err =3D 0;
> +
> +       data =3D btf__raw_data(btf, &data_sz);
> +       if (!data) {
> +               err =3D -ENOMEM;
> +               goto out;
> +       }
> +
> +       f =3D fopen(path, "wb");
> +       if (!f) {
> +               err =3D -errno;
> +               goto out;
> +       }
> +
> +       if (fwrite(data, 1, data_sz, f) !=3D data_sz) {
> +               err =3D -errno;
> +               goto out;
> +       }
> +
> +out:
> +       if (f)
> +               fclose(f);
> +       return libbpf_err(err);
> +}
> +
>  static void *btf_get_raw_data(const struct btf *btf, __u32 *size, bool s=
wap_endian);
>
>  int btf__load_into_kernel(struct btf *btf)
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 5c73a5b0a044..4f8d3f303aa6 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -114,6 +114,8 @@ LIBBPF_API struct btf *btf__parse_elf_split(const cha=
r *path, struct btf *base_b
>  LIBBPF_API struct btf *btf__parse_raw(const char *path);
>  LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf=
 *base_btf);
>
> +LIBBPF_API int btf__save_raw(const struct btf *btf, const char *path);
> +
>  LIBBPF_API struct btf *btf__load_vmlinux_btf(void);
>  LIBBPF_API struct btf *btf__load_module_btf(const char *module_name, str=
uct btf *vmlinux_btf);
>  LIBBPF_API struct btf *libbpf_find_kernel_btf(void);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 6a59514a48cf..c9555f8655af 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -414,4 +414,5 @@ LIBBPF_0.6.0 {
>                 perf_buffer__new_deprecated;
>                 perf_buffer__new_raw;
>                 perf_buffer__new_raw_deprecated;
> +               btf__save_raw;

this is a sorted list, please keep it so

>  } LIBBPF_0.5.0;
> --
> 2.25.1
>
