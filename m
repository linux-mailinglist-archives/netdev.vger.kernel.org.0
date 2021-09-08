Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A624031D7
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 02:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhIHAb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 20:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbhIHAbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 20:31:55 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CA2C061575;
        Tue,  7 Sep 2021 17:30:48 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id r4so633756ybp.4;
        Tue, 07 Sep 2021 17:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NoIsJnCydGtaSbJy2q3NpkAEDY8RVq7kskV7RgG5IQ4=;
        b=BLdOLHV1VZZlU85uky63HhtYR+8vrbAFAiVumRtUcEDtUAOcu/zBpM/vd/8hnLTZXN
         +76Kk8UsLAFNF6IF3MqhrKL0dfZs1WnPRr4h33kg+aY7HBkkO/vML0B4WVDQGWYDHy8L
         ON91ZCgAWuQvG2gHyZNa/ueDTYdifvPuCIY16k5n64nVpMYyUJINNAwCkm6+FevU3dCa
         c+T0R/xGaX4lMlW8PdKRiShtDmVB5hHYQ5KttxQ4J2aDgvewoMgQkfL3rsRkHn4U22fy
         5HuU5ruObXIyLPNiP5RD5q4jvQeYPlDD0H60ic4uxkKp57rmd6HOjpqv14RFGZ30Ymm+
         XrSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NoIsJnCydGtaSbJy2q3NpkAEDY8RVq7kskV7RgG5IQ4=;
        b=jflebgdAnfZgDcmp2ZdXJU9ai7oQlMAf6K/KcOG/nsynifMIK17afmF9WoFGqmrtBd
         Jf+fQP/RZWY/cnETKCRJKae2J4gKeC9yvGkP8H3UcwwhDHLsIgaZB1GSo1LLdijyj514
         xc1XaSEjvBS9XDJ6InGt+cxiQR7lVTIS1tb+H97k4PF4srU0aahXW78MZLWY/A+mJOMc
         ScWvWNB/aeyqAFsBugqY07RjbgIEn32c2RQrw/CpwSXBRt2Ys2YJY0uDfp1XnmQd9xuE
         SkZ71MOCeVHywa3KRKTZcYAiNl7oLaZJ9vOed+7mQwwGlvSQ+0TokOgUp8/sMy9kF+bA
         Er3w==
X-Gm-Message-State: AOAM533rKQKLfUcLUN92kV7PMCCstX7l9qf5aKuKD2OP27SdG4aYKILk
        We3WNv4gbnpGvqr410Ty2heDXL1enJp1VPGmKPQ=
X-Google-Smtp-Source: ABdhPJxKbPWHbl90jciDsWF/P/v3sbAEgYeVjFJC6S+UMVT7CVU0/1uzFK802Q0RChxrU0/4Em/2G8R9UMQ+Xq2WtMM=
X-Received: by 2002:a5b:702:: with SMTP id g2mr1353868ybq.307.1631061048230;
 Tue, 07 Sep 2021 17:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210901114812.204720-1-toke@redhat.com>
In-Reply-To: <20210901114812.204720-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Sep 2021 17:30:37 -0700
Message-ID: <CAEf4BzYatQEJzUz5RNvp5kspG=9eU-mL4mXwkGZxjO+KpNcaFw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] libbpf: don't crash on object files with no symbol tables
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 4:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> If libbpf encounters an ELF file that has been stripped of its symbol
> table, it will crash in bpf_object__add_programs() when trying to
> dereference the obj->efile.symbols pointer.
>
> Fix this by erroring out of bpf_object__elf_collect() if it is not able
> able to find the symbol table.
>
> v2:
>   - Move check into bpf_object__elf_collect() and add nice error message
>
> Fixes: 6245947c1b3c ("libbpf: Allow gaps in BPF program sections to suppo=
rt overriden weak functions")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Applied to bpf-next, thanks.


>  tools/lib/bpf/libbpf.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6f5e2757bb3c..997060182cef 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2990,6 +2990,12 @@ static int bpf_object__elf_collect(struct bpf_obje=
ct *obj)
>                 }
>         }
>
> +       if (!obj->efile.symbols) {
> +               pr_warn("elf: couldn't find symbol table in %s - stripped=
 object file?\n",
> +                       obj->path);
> +               return -ENOENT;
> +       }
> +
>         scn =3D NULL;
>         while ((scn =3D elf_nextscn(elf, scn)) !=3D NULL) {
>                 idx++;
> --
> 2.33.0
>
