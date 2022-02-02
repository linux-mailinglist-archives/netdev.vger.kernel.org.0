Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1D34A7837
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346759AbiBBSs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346631AbiBBSs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:48:26 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0323C061714;
        Wed,  2 Feb 2022 10:48:26 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id e8so110264ilm.13;
        Wed, 02 Feb 2022 10:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+8viDUjzHqGkpJNPOlqCPdUq8AHMgUcTsfVkZ36F2po=;
        b=lpFbu90A6b6oeRuS9UP8cDToVAxddmymexu2a1yejoyT6sMu8RxwbO2wTcniWb6pnI
         HwkoUfLq1MKpeBnJeM6EgUrn0W+M1dIXED4ntlixW2piLCFHjDDFdXIEYARpLXF6rWm1
         9q1Wjn/wkchrF15uxn3E1/2ixv6PtSiCXOkSHcsTSHu3lRJQ+g8ib6PVpTUBza31vRKR
         9kWJGNsqHmA09I/w81I1L1TmW/YpJffUe/08zs6xQ9l3Gp6lVwLiBqCTbhckibfdifXm
         tTQJqh162neOY0y3Dm9ZbtjBVuYAPhA1BsbSokuBBNZy8QQwekzTejTxZ7r/NZZyRPXL
         JdPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+8viDUjzHqGkpJNPOlqCPdUq8AHMgUcTsfVkZ36F2po=;
        b=Vhmp9kPLGX7KFExTyYHg7yV/hpG3vAsPw6vlxFi9w+7eJmusg9Shp3RS1fTtC9ZNut
         LSxXgfLgw1krwoomy3R+lPni6HUJrBQzRbdKSUD7he28hFsz1ww6uSerQyKw7tWyBfBF
         zYNtGULoPLz8eAO5NxZ03n0Fm6hb+Jm5lu05wFA+HGQjjcsrmMLoJF49e7wj1NvOQXRL
         9J+qig9eEWtGRySvlnY7eVrWo5SZdvqd1DY+XSU38yzgmYc1fJkX3NnxtJ3VZUj3zOuH
         Bd4iKU7DTkc3I5Fwfm/gno3vXBUBDUaXS8p/vUgD+jEtLu+FeFYCIzGu/FrqX1H+ZQ6d
         z8WQ==
X-Gm-Message-State: AOAM531h6Ieg07lB1UU5wxSup3Thms/cd1uMg60E1iNAGt3mFhPxtx8I
        7DP/cIaBYBXIjZWQKvrMIxNq8uvm4bIwKQb231E=
X-Google-Smtp-Source: ABdhPJxIUDDFTxQIiQIOnRmGiKYI7bQ9LRvtQpwfahOU6rKuUo2hrRZNC0ttCLwe+qATkbNAlbggLzmbfy45iG2e3io=
X-Received: by 2002:a05:6e02:2163:: with SMTP id s3mr17354104ilv.252.1643827706231;
 Wed, 02 Feb 2022 10:48:26 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-4-mauricio@kinvolk.io>
In-Reply-To: <20220128223312.1253169-4-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Feb 2022 10:48:14 -0800
Message-ID: <CAEf4BzYW54DRsJxgeXKcHPLSXs45DsCVKumV7WNd2UH=1G4MPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/9] bpftool: Implement btf_save_raw()
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

On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> Helper function to save a BTF object to a file.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---

The logic looks good, but you need to merge adding this static
function with the patch that's using that static function. Otherwise
you will break bisectability because compiler will warn about unused
static function.

>  tools/bpf/bpftool/gen.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 7db31b0f265f..64371f466fa6 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -1096,6 +1096,28 @@ static int do_help(int argc, char **argv)
>         return 0;
>  }
>
> +static int btf_save_raw(const struct btf *btf, const char *path)
> +{
> +       const void *data;
> +       FILE *f =3D NULL;
> +       __u32 data_sz;
> +       int err =3D 0;
> +
> +       data =3D btf__raw_data(btf, &data_sz);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       f =3D fopen(path, "wb");
> +       if (!f)
> +               return -errno;
> +
> +       if (fwrite(data, 1, data_sz, f) !=3D data_sz)
> +               err =3D -errno;
> +
> +       fclose(f);
> +       return err;
> +}
> +
>  /* Create BTF file for a set of BPF objects */
>  static int btfgen(const char *src_btf, const char *dst_btf, const char *=
objspaths[])
>  {
> --
> 2.25.1
>
