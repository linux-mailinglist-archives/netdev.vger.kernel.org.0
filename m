Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E662F462613
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhK2Wq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbhK2WoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:44:19 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C57C111CE7;
        Mon, 29 Nov 2021 09:39:12 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id v138so44556606ybb.8;
        Mon, 29 Nov 2021 09:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N/h+zmVfAqy959zZ9BMXX2/1A5wdWpzzXEiwOZkidAo=;
        b=Es/C2bASl8GHz5I7lyf6uhdpLBEaXtgpaj8Y00kQuxvSfKKHt2BGvZMwQV2KlZxfXt
         0Jou8XgkBwQDdNUiNftc4seTAyOgmDc+ayN+uI6XZYb2G6tCX9V8OUyr8VG/71jfue67
         oV1L3rJIzxoew96VzZ900MNBB6bO+DINhL7qC378R1LjjbhbsfNCQ+YZE8TnrBudSwJ9
         2MXwoizwcCvvB4qSA3UR+QpEUqeue4FAX6JBvS1rXmvt4aq8VpJP7G/puGG051lOFTbK
         X3rDezDb07PEGRcpnXsPUR0KSQ9eK+AGOsw+A/Ev9BFbvPqwfXKRzdjw4S31kCVurrFK
         MSrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N/h+zmVfAqy959zZ9BMXX2/1A5wdWpzzXEiwOZkidAo=;
        b=7KYOQFp55axLYSqORQrCFZqB8ViMSMcRsF8INiBGcK5vO2k4M3Oo3jWNJ2+lM+/yxg
         P8zXYG+LnPh4Aw4+sDv0jd2Jd/A5t4V/YmJdnxoxX8OKikLWG7k23JQqh1Z46Sds3S/0
         YPMct2BKMYHLLnTsrIOVGp1Wl6S2tdgRUOTedaICk4dU/noX2dkoRWJCVyQp1DjrVrmY
         a0E7ylzODATtwDuZeILkjeLG9Tj6/nQD8gMACB7JHe+OoUDDAuURqtXaW+eb6phntLD6
         RYvR2GE+vOjqmKXgDB0VBq7WcQjjLJy4pvE75NCMnvKw7PivG5TysuYOGJ5NVxu/pcyL
         sJWw==
X-Gm-Message-State: AOAM532Zwf3326YdAo263K9oSbPofrXfO50gHVi+OgWLkW8hsHN05tDo
        RRzVgPFF6ZsE4cmOGdyIrLW4Ai+OmJKa8THUY55YB8P2/ZU=
X-Google-Smtp-Source: ABdhPJzAb+zhz5Hk2/zQvp+Kc9uZ/wFYqmRadUzC5zH2p6qh8JLtGZLeWJejWEerR5rRbl8C/vH8QPL5tIXX6iFhjpU=
X-Received: by 2002:a25:b204:: with SMTP id i4mr36682982ybj.263.1638207552001;
 Mon, 29 Nov 2021 09:39:12 -0800 (PST)
MIME-Version: 1.0
References: <1638180040-8037-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1638180040-8037-1-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Nov 2021 09:39:01 -0800
Message-ID: <CAEf4BzayWEsojyZQsdWmtmaHXS88j8yLyxDV8VC13t5e-Or+kg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: silence uninitialized warning/error in btf_dump_dump_type_data
To:     Alan Maguire <alan.maguire@oracle.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 2:01 AM Alan Maguire <alan.maguire@oracle.com> wrot=
e:
>
> When compiling libbpf with gcc 4.8.5, we see:
>
>   CC       staticobjs/btf_dump.o
> btf_dump.c: In function =E2=80=98btf_dump_dump_type_data.isra.24=E2=80=99=
:
> btf_dump.c:2296:5: error: =E2=80=98err=E2=80=99 may be used uninitialized=
 in this function [-Werror=3Dmaybe-uninitialized]
>   if (err < 0)
>      ^
> cc1: all warnings being treated as errors
> make: *** [staticobjs/btf_dump.o] Error 1
>
> While gcc 4.8.5 is too old to build the upstream kernel, it's possible it
> could be used to build standalone libbpf which suffers from the same prob=
lem.
> Silence the error by initializing 'err' to 0.  The warning/error seems to=
 be
> a false positive since err is set early in the function.  Regardless we
> shouldn't prevent libbpf from building for this.
>
> Fixes: 920d16af9b42 ("libbpf: BTF dumper support for typed data")
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

Arnaldo also complained about this.

Applied to bpf-next, I don't think it needs to be in the bpf tree. Thanks.


>  tools/lib/bpf/btf_dump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index 17db62b..5cae716 100644
> --- a/tools/lib/bpf/btf_dump.c
> +++ b/tools/lib/bpf/btf_dump.c
> @@ -2194,7 +2194,7 @@ static int btf_dump_dump_type_data(struct btf_dump =
*d,
>                                    __u8 bits_offset,
>                                    __u8 bit_sz)
>  {
> -       int size, err;
> +       int size, err =3D 0;
>
>         size =3D btf_dump_type_data_check_overflow(d, t, id, data, bits_o=
ffset);
>         if (size < 0)
> --
> 1.8.3.1
>
