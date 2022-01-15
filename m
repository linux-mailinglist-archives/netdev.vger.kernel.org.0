Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7138B48F459
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiAOCP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiAOCP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:15:27 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8661FC061574;
        Fri, 14 Jan 2022 18:15:27 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id z17so7862639ilm.3;
        Fri, 14 Jan 2022 18:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LELDX24pXWt+VxdWy43N04obz88QkA8ebt9nQTYjYNs=;
        b=UAILF2PB/7atr+AoynBJfTGul89y6EYlw8FHInMh05b9fnEXCq0zO+CnIWclBbXmM8
         Zhgdi85nt2FvYNB8EfWS1J2+saGr+kULLhiWKYfGTK8vfqSm+LSuvf+thkY+kG7jP/3C
         XBTvLQEvqc62PSKMlgwxC58qeIyigCytecXzZZdB62uP68SxItzPczY+jyq2qf2JAvSV
         m4Nz4MTCzVGWqSbn/+ljv8bh0t6gfEY1t427ov2trLEDLPf9w/X6nAu+IZ0fr6E4rfvw
         HAo+pR9ActRrbSJDUv4m4Hl/zz9mZykGTahLil8hUTs0FOpd2r5HgvcBvSLgEfOnvNnH
         aLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LELDX24pXWt+VxdWy43N04obz88QkA8ebt9nQTYjYNs=;
        b=h+Fkc7FGGfxOIcKhA41kdwKpmLLKFHwJr3bDN+HTS9Uyt4SrqHOTnmXQKf4yA8xpqT
         UbwEicWGHFs+ubPEjNhEFS/hAzZFk8HWFO/u/5Mhd1jSROq+Pv5qK7L12J2SD9YFV/Bu
         EbMFA/7PgaEUDHNmKsP13pJI91IMBGQKZ7aQvDmlQp8WD9dSNm0ZyJ9RCVT6x5pqdqaw
         kitrIHiCdmgrjIL6WSXlqsr6fNWgsW5KcamN1C4WAFOdFEcZXpZueNQT2w8MQDXCYXNr
         RqeDqPGzyWnzfCA1hwL0xbpcO5LKHRpVZG9T3XzDgOljwbwy8nuDBiUYp6GV7n00vuZT
         Ge+Q==
X-Gm-Message-State: AOAM531zHtfChIM1zDAVCCLhLSOeIaRYIHyxrix9CPd/I1Yt/BYJTost
        xU6xCLIa2oo9s7PsQ4M4WciWZwYZwAacUILTwVzVcy18A7I=
X-Google-Smtp-Source: ABdhPJxBSt/Cc7PWmBPnaroQJqTXUkQOqvdHBO/7WWWzpkG3wHrItzH7iwbHvg+FeILMxXvzHqNWonrnO6Yqa78pBq8=
X-Received: by 2002:a05:6e02:1749:: with SMTP id y9mr5791586ill.252.1642212926586;
 Fri, 14 Jan 2022 18:15:26 -0800 (PST)
MIME-Version: 1.0
References: <20220112142709.102423-1-mauricio@kinvolk.io> <20220112142709.102423-7-mauricio@kinvolk.io>
In-Reply-To: <20220112142709.102423-7-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 18:15:15 -0800
Message-ID: <CAEf4BzaFsk_OTKuBC2C_b=uZH4=H=0bNxY+twTM-kB-B2BYNKQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 6/8] bpftool: Implement btfgen()
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
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

On Wed, Jan 12, 2022 at 6:27 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> btfgen() receives the path of a source and destination BTF files and a
> list of BPF objects. This function records the relocations for all
> objects and then generates the BTF file by calling btfgen_get_btf()
> (implemented in the following commits).
>
> btfgen_record_obj() loads the BTF and BTF.ext sections of the BPF
> objects and loops through all CO-RE relocations. It uses
> bpf_core_calc_relo_insn() from libbpf and passes the target spec to
> btfgen_record_reloc() that saves the types involved in such relocation.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/gen.c | 221 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 219 insertions(+), 2 deletions(-)
>

[...]

> +       info =3D btfgen_new_info(src_btf);
> +       if (!info) {
> +               p_err("failed to allocate info structure: %s", strerror(e=
rrno));
> +               err =3D -errno;
> +               goto out;
> +       }
> +
> +       for (int i =3D 0; objspaths[i] !=3D NULL; i++) {
> +               printf("OBJ : %s\n", objspaths[i]);

same as in previous patches, OBJ, DBTF, that's quite cryptic. Is this
used for some parsing of the output or it's just debugging leftovers?

> +
> +               err =3D btfgen_record_obj(info, objspaths[i]);
> +               if (err)
> +                       goto out;
> +       }
> +
> +       btf_new =3D btfgen_get_btf(info);
> +       if (!btf_new) {
> +               err =3D -errno;
> +               p_err("error generating btf: %s", strerror(errno));
> +               goto out;
> +       }
> +
> +       printf("DBTF: %s\n", dst_btf);
> +       err =3D btf_save_raw(btf_new, dst_btf);
> +       if (err) {
> +               p_err("error saving btf file: %s", strerror(errno));
> +               goto out;
> +       }
> +
> +out:
> +       btf__free(btf_new);
> +       btfgen_free_info(info);
> +
> +       return err;
> +}
> +
>  static int is_file(const char *path)
>  {
>         struct stat st;
> --
> 2.25.1
>
