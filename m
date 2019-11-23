Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E550B1080B1
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfKWVEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:04:40 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35064 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWVEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:04:40 -0500
Received: by mail-lj1-f195.google.com with SMTP id j6so2284405lja.2;
        Sat, 23 Nov 2019 13:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n+bqr098826ITu9D+AvY5CnxPGDTup0kvus7bNbcpsY=;
        b=S6X8Nd9NwDbGHm1vBUzQjDeM6++hy+lALX/aAkMZPQIhwOlZW47InHIG+Yrd+9SarW
         7l3P4vzCSIDTlLdqGtBj/bTezmxm2PabVQ7JghsSwJHfcSfM5qiYDxRfALElnSnQandO
         l5lSFGQdGb3yHnY1QmVAnO/EDQrVLPJlwovpqQ3qBx3kx3JLnI3Ok135DHyeW2rS5wtr
         x2cR7+1Ner6wMcDmAOm9kECT16ZLfswBis9WGw2EhBMA5zw2QLw3SZiYr+Eb4PkyxoDo
         pi3sofVaOl9bi1H+PGKLJ60asbn6UugIbtnOC+jqnNVVi91B3KQBgUXnc114FCUGknDs
         5XLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n+bqr098826ITu9D+AvY5CnxPGDTup0kvus7bNbcpsY=;
        b=PCC/cGafJJu93ARMjxaMJg104Gkweh8V+XgVy7lIyKhGtkUPgp2MgSINsXjFuSeW6i
         Snwkat7umhfYQTdNfz6m+KJSFahC+EQu4/EN5lV4zZHHEXDOXjAfc+Q6cLUqurW5l3LZ
         9HU1PRDTRF2bqCIefJY6/WpZjDp8S5pW2a1t4azpblqFhjpOr9lYd7GCI0ez4lL2XFY8
         N5Zs4yzFrT76lRBzc0lQscxzMv6rJAHllXHsrkKuCfYBWOXibR5EHKxDX+ga1kK6CABQ
         0PPT7PL0/6d4rda2u3W+TGV5wKDEGSQauHMep3/P3riJbAkMFTZiSaPhpGbX02bfB/qm
         JK7Q==
X-Gm-Message-State: APjAAAUafRfQkWXvtsz1xS8Sc2Sb3gsMXcrnztta7k2Uht8cGgzwgXZp
        SpD89IUxog/IcmPsj1ErgdqMnUsaZoshbUmKilY=
X-Google-Smtp-Source: APXvYqy0r9yf0N41MXogyG4QJYPW4J4tdMBNV1ER68BJ3+sLAkPWMjifiD0dG9Zvk1rGqrBKWgSvPJqrB4JIqAZD2A4=
X-Received: by 2002:a2e:970a:: with SMTP id r10mr17167212lji.142.1574543077686;
 Sat, 23 Nov 2019 13:04:37 -0800 (PST)
MIME-Version: 1.0
References: <40baf8f3507cac4851a310578edfb98ce73b5605.1574541375.git.daniel@iogearbox.net>
In-Reply-To: <40baf8f3507cac4851a310578edfb98ce73b5605.1574541375.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 23 Nov 2019 13:04:26 -0800
Message-ID: <CAADnVQLkMH6NY8phOemtQSF3Y-D4s6k-f34wz6Edq2NjdY+bWg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add bpf_jit_blinding_enabled for !CONFIG_BPF_JIT
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 12:37 PM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
>
> Add a definition of bpf_jit_blinding_enabled() when CONFIG_BPF_JIT is not=
 set
> in order to fix a recent build regression:
>
>   [...]
>   CC      kernel/bpf/verifier.o
>   CC      kernel/bpf/inode.o
> kernel/bpf/verifier.c: In function =E2=80=98fixup_bpf_calls=E2=80=99:
> kernel/bpf/verifier.c:9132:25: error: implicit declaration of function =
=E2=80=98bpf_jit_blinding_enabled=E2=80=99; did you mean =E2=80=98bpf_jit_k=
allsyms_enabled=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>  9132 |  bool expect_blinding =3D bpf_jit_blinding_enabled(prog);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~
>       |                         bpf_jit_kallsyms_enabled
>   CC      kernel/bpf/helpers.o
>   CC      kernel/bpf/hashtab.o
>   [...]
>
> Fixes: bad63c9ea554 ("bpf: Constant map key tracking for prog array pokes=
")
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Reported-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Applied. Thanks
