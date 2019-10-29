Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC3EE8317
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 09:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbfJ2ITy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 04:19:54 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39519 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbfJ2ITy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 04:19:54 -0400
Received: by mail-qt1-f195.google.com with SMTP id t8so18961986qtc.6;
        Tue, 29 Oct 2019 01:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PVI2OQ5lGd+deR12IVFnVb/9vuCzshNV43sWHU4PiNM=;
        b=SHYbO8tiuE55WImyXvZMkhiwlSxgF1ecP6g54mh/sslqzxwHDAhhzaWbdI4Lkot+x6
         7WsMSNMCCBeYE2/wzx2GcUCQJGdUEAaCklzKglXCEeJOeH8lW44sPQFWJlqHKt5CfBHU
         BvqE1LTRRdJKei5FZH9Zs1Uon8mWzVGp4ot+ZF38f8+PPVJCABtWHaEBg/koaUfRY542
         apdHgytTm+V1gT0/xobuko012T6TGg0wgT48hegYXVPKGFgoyScYogl7z8rh3KBWzwQF
         eEmPh1RHIuWxP9iBR4qmXrFfJJIEi4DtVvaw/enQHkwRTyLKvx32OW8ybfkNcjquKERB
         Wiig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PVI2OQ5lGd+deR12IVFnVb/9vuCzshNV43sWHU4PiNM=;
        b=kiG6rLYyXBPJB7ups9BmZTdlynGUW2LFkP5iX4ZL0091kgyIo7yfSWV8bk2AQUeXWI
         e1OgYqwGP6IKe03nyu/kUG/nWkJHAXMmNC5TFaAlBFKSW3Nt1zkklgb+OI1T+WvVZ43o
         gLo2Gi21Pw5N/d/BHCeyfLUEXVWgD9WCKOwTkyuBmJKmffi/EFG/l2FJ/PDhgma6Xbzh
         3OruWswOvTPmlfqF0XObmV2eFOJjpgaknTamkh3Zv2z3kP6lxaZgBntm3Z1fyzTGncnA
         kayN/+aTTCmvlOiGjzIYCEg2wAgwUtKiBoWr+DBzKhyta8IukRX5pbSIBmPdJYhSxysL
         NOkQ==
X-Gm-Message-State: APjAAAVBiUEyqMyINaEXFVc4c9gam/e2DS8jBcnBH/QssMkpFsYQtcUf
        5wx3MFKEid3ACNHgBHveFWgkaelLrJtpJ5qkDBU=
X-Google-Smtp-Source: APXvYqzIRO6n4UNkzmiBnah4OuxcFzBzQ+s8JAdrDdxIvfT4haEldEjC55ikFhQmznl7onOx/p2kU7WTGMBxE8OzGIA=
X-Received: by 2002:a05:6214:1ca:: with SMTP id c10mr21843161qvt.233.1572337193364;
 Tue, 29 Oct 2019 01:19:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191029055953.2461336-1-andriin@fb.com>
In-Reply-To: <20191029055953.2461336-1-andriin@fb.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 29 Oct 2019 09:19:41 +0100
Message-ID: <CAJ+HfNgOHwSDpkMh=+Z42V5Y2K+-BsTkuux7XCO=5Qk=d6hSLg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: don't use kernel-side u32 type in xsk.c
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Oct 2019 at 08:26, Andrii Nakryiko <andriin@fb.com> wrote:
>
> u32 is a kernel-side typedef. User-space library is supposed to use __u32=
.
> This breaks Github's projection of libbpf. Do u32 -> __u32 fix.
>
> Fixes: 94ff9ebb49a5 ("libbpf: Fix compatibility for kernels without need_=
wakeup")
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Thanks Andrii!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> ---
>  tools/lib/bpf/xsk.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index d54111133123..74d84f36a5b2 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -161,22 +161,22 @@ static void xsk_mmap_offsets_v1(struct xdp_mmap_off=
sets *off)
>         off->rx.producer =3D off_v1.rx.producer;
>         off->rx.consumer =3D off_v1.rx.consumer;
>         off->rx.desc =3D off_v1.rx.desc;
> -       off->rx.flags =3D off_v1.rx.consumer + sizeof(u32);
> +       off->rx.flags =3D off_v1.rx.consumer + sizeof(__u32);
>
>         off->tx.producer =3D off_v1.tx.producer;
>         off->tx.consumer =3D off_v1.tx.consumer;
>         off->tx.desc =3D off_v1.tx.desc;
> -       off->tx.flags =3D off_v1.tx.consumer + sizeof(u32);
> +       off->tx.flags =3D off_v1.tx.consumer + sizeof(__u32);
>
>         off->fr.producer =3D off_v1.fr.producer;
>         off->fr.consumer =3D off_v1.fr.consumer;
>         off->fr.desc =3D off_v1.fr.desc;
> -       off->fr.flags =3D off_v1.fr.consumer + sizeof(u32);
> +       off->fr.flags =3D off_v1.fr.consumer + sizeof(__u32);
>
>         off->cr.producer =3D off_v1.cr.producer;
>         off->cr.consumer =3D off_v1.cr.consumer;
>         off->cr.desc =3D off_v1.cr.desc;
> -       off->cr.flags =3D off_v1.cr.consumer + sizeof(u32);
> +       off->cr.flags =3D off_v1.cr.consumer + sizeof(__u32);
>  }
>
>  static int xsk_get_mmap_offsets(int fd, struct xdp_mmap_offsets *off)
> --
> 2.17.1
>
