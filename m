Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849E4CE984
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfJGQnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:43:12 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34088 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbfJGQnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 12:43:11 -0400
Received: by mail-qt1-f196.google.com with SMTP id 3so20160654qta.1;
        Mon, 07 Oct 2019 09:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NKDBVKvk7HklO3S6yXtVYRim3kqnGNYLuGw93b2LDEI=;
        b=C6fillda+CEVSSzy7P0O2Oyp9lICg7XKPSJl/D2iCkB/TL32L944CGbmHtWadDTv4l
         2AuQKErVB6c18Bu96A8DzefRdmhPvl+hMBQI2FCBcgUU7z4WJUVixzIIvaFaPqERHVlI
         8ZSsWGjQuqa6yCk4C1p9pFRMpcBlBBOumwW5oK39o4XxLKMbw4W8NfehzuqTQm4Z92fd
         DMZGAHZ1K9ojViQeq2Nhay/MowUkocSP7yssWCqPAMyHMXQoCDKCQJfnfI+3UCWH5r6B
         elIKls0jkh1l1wI4yaYfcdsXhJRYuPZW9cIPOEkBftWKCeKL4Pan5DmReEBCVVsxW/AL
         /qSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NKDBVKvk7HklO3S6yXtVYRim3kqnGNYLuGw93b2LDEI=;
        b=kO+B1amx21K2nL6qlGNXG0XKDVMtd2aNOmKjzXbV3my5KHFqdOJ0wyC34STrU7COdP
         8Aq+YgdVwrXt22/eKCn4xK36MvbI0GceOMjDsDPbTkXhPf6yFOyENun332MRonTKOIDA
         VLGaL3njVXbDfELJlr9iXHQ7guRNyTclbgPpclwVMvmsqykB9iZbIYLBYPJNEsa48JQr
         x3f3y6r7fDDeh5IoKjuyTaw6t5J00fUP83fZwSsNTD8Dpxn3PbQPKfQKWZVyQ0qC/G0K
         Ti3D+q0QDTw0yRDHPR/jmd/MXHUIRMuQuF7y4fwq/1HP00LzCQtM6xQBfQjR445ES/t8
         zpzQ==
X-Gm-Message-State: APjAAAV5q+X6HVKmPwz8uBBAg4h5psCUYESgrlRTBgrV2me7vF6NNRnI
        EdTZyy4EySdbaYSDm0HF8JB7A1/hGMSFyBcPE5DCWclT
X-Google-Smtp-Source: APXvYqzF3vRRuI8I4hO1tJ6JI/MMOht4eWPtDw10plerRXjN9pjTPpdV1U7LMImVX5ic8NvTb5aN2EG3LOXdqEoAAu0=
X-Received: by 2002:aed:2726:: with SMTP id n35mr30204149qtd.171.1570466590657;
 Mon, 07 Oct 2019 09:43:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191004224037.1625049-1-andriin@fb.com> <20191004224037.1625049-2-andriin@fb.com>
 <20191007161437.GB2096@mini-arch>
In-Reply-To: <20191007161437.GB2096@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Oct 2019 09:42:59 -0700
Message-ID: <CAEf4Bza-8EtVagW8PG1pVVDp+jXGg59kW9FJNbYbWAxar3S6Gg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/4] libbpf: stop enforcing kern_version,
 populate it for users
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 9:14 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 10/04, Andrii Nakryiko wrote:
> > Kernel version enforcement for kprobes/kretprobes was removed from
> > 5.0 kernel in 6c4fc209fcf9 ("bpf: remove useless version check for prog=
 load").
> > Since then, BPF programs were specifying SEC("version") just to please
> > libbpf. We should stop enforcing this in libbpf, if even kernel doesn't
> > care. Furthermore, libbpf now will pre-populate current kernel version
> > of the host system, in case we are still running on old kernel.
>
> [..]
> > This patch also removes __bpf_object__open_xattr from libbpf.h, as
> > nothing in libbpf is relying on having it in that header. That function
> > was never exported as LIBBPF_API and even name suggests its internal
> > version. So this should be safe to remove, as it doesn't break ABI.
> This gives me the following (I don't know why bpftool was allowed to link
> against non-LIBBPF_API exposed function):
>
> + make -s -j72 -C tools/bpf/bpftool
>
> prog.c: In function =E2=80=98load_with_options=E2=80=99:
> prog.c:1227:8: warning: implicit declaration of function =E2=80=98__bpf_o=
bject__open_xattr=E2=80=99; did you mean =E2=80=98bpf_object__open_xattr=E2=
=80=99? [-Wimplicit-function-declaration]
>   obj =3D __bpf_object__open_xattr(&open_attr, bpf_flags);
>         ^~~~~~~~~~~~~~~~~~~~~~~~
>         bpf_object__open_xattr
> prog.c:1227:8: warning: nested extern declaration of =E2=80=98__bpf_objec=
t__open_xattr=E2=80=99 [-Wnested-externs]
> prog.c:1227:6: warning: assignment to =E2=80=98struct bpf_object *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
>   obj =3D __bpf_object__open_xattr(&open_attr, bpf_flags);
>       ^
>

Cool, I somehow didn't find any users of that API, but I looked only
in libbpf and selftests, forgot about bpftool. I'll fix it to use new
APIs.

Thanks for reporting!



> Warning: Kernel ABI header at 'tools/include/uapi/linux/if_link.h' differ=
s from latest version at 'include/uapi/linux/if_link.h'
> /usr/bin/ld: prog.o: in function `load_with_options':
> prog.c:(.text+0x49b): undefined reference to `__bpf_object__open_xattr'
> collect2: error: ld returned 1 exit statu
>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---

[...]
