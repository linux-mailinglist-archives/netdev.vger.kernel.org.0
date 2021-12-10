Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3F8470F07
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 00:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240607AbhLJX5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 18:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhLJX5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 18:57:11 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98206C061746;
        Fri, 10 Dec 2021 15:53:35 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id x32so24808295ybi.12;
        Fri, 10 Dec 2021 15:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/2eOgHeVZCKuTcGqR7agjID3iAxlZevAUfvXeGmiThM=;
        b=SqteFdiHMslhw4OwccOCTMHp7PPTt8mU0f5t2WhTVFR/VAe/IkFwgr8yPRApsdhasA
         O2Jg9su+rHIj7r47EhhvAdZdiOmsil43qx569eoj11ewNfFj+VQzIdakHjGhNDdtQAxM
         LagyMiKTMJJmblCr0VZSgObY0vFdLakvW/7sBqr6xyis2oQjKiBQogFveFo0VOJ2zlwT
         wPcb++RMC0TUmYCaRDdSOJ1GI2SEXGJamb7WzojfEHIemOR4n0CPXnEF/SH8oGmB4lqb
         7ruhqMnhQjJDFSfCnL1dRdiJU5WDtid1398O4J72yI19I6m9XdSdOF/pQoFJ2TfvDK6a
         BA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/2eOgHeVZCKuTcGqR7agjID3iAxlZevAUfvXeGmiThM=;
        b=K9X575YlMkpSw6o/Zj+vORMKkj9rjoKMcTNxBq1GtGIqidkelmpOF/lFXqMmoNS/dH
         TLupCHGKsKRHAbq0biB7pUU+ZfAblXHC0iYit4DevfaPzVXDLVQKQRPCq3Z7UV2gPvsy
         ZsacLF0HE2H4TZR7r4Olzyi0b9JA8ZBW87xJo9jEu3+klIOBOzL9mhmBrTYPHMozdaL8
         rQcD+l44BEBtRsyzlZZxkan+nbTykibzc0Wnxvb6xHUHpWkGrC59JeRn8CcrRPSlQyKm
         D3zJjx4YOcb8RZhJ6Ao9R4tSTZzH9h3QJ6kHKSyOuH0ZUwvxNTIuYXrPimfWpZ+oalX1
         +c/g==
X-Gm-Message-State: AOAM533GNRkdVE/aXWQzLJRHeXXj3ltwyWYsRp8Hfy8Q0fBlzeofb7+i
        f6C+2nI796m4Zmehl3lpL2+E/G4a2Ql1SHwwX90=
X-Google-Smtp-Source: ABdhPJzj3xZNO6eWOEPZQVJ5dUrGXIBMypWf5rvFuMPxm7+ZQljmeH+pt9bzlEPt6Tw1JfLFEzxeKxaoai1J4v6+r8o=
X-Received: by 2002:a5b:1c2:: with SMTP id f2mr18873152ybp.150.1639180414869;
 Fri, 10 Dec 2021 15:53:34 -0800 (PST)
MIME-Version: 1.0
References: <20211209092250.56430-1-hanyihao@vivo.com> <877dccwn6x.fsf@toke.dk>
In-Reply-To: <877dccwn6x.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Dec 2021 15:53:23 -0800
Message-ID: <CAEf4Bza3a88pdhFEQdR-FnT_gBPqBh+KL-OP-1P3bVfXv=Gbaw@mail.gmail.com>
Subject: Re: [PATCH v2] samples/bpf: xdpsock: fix swap.cocci warning
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Yihao Han <hanyihao@vivo.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 6:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Yihao Han <hanyihao@vivo.com> writes:
>
> > Fix following swap.cocci warning:
> > ./samples/bpf/xdpsock_user.c:528:22-23:
> > WARNING opportunity for swap()
> >
> > Signed-off-by: Yihao Han <hanyihao@vivo.com>
>
> Erm, did this get applied without anyone actually trying to compile
> samples? I'm getting build errors as:

Good news: I actually do build samples/bpf nowadays after fixing a
bunch of compilation issues recently.

Bad news: seems like I didn't pay too much attention after building
samples/bpf for this particular patch, sorry about that. I've dropped
this patch, samples/bpf builds for me. We should be good now.


>
>   CC  /home/build/linux/samples/bpf/xsk_fwd.o
> /home/build/linux/samples/bpf/xsk_fwd.c: In function =E2=80=98swap_mac_ad=
dresses=E2=80=99:
> /home/build/linux/samples/bpf/xsk_fwd.c:658:9: warning: implicit declarat=
ion of function =E2=80=98swap=E2=80=99; did you mean =E2=80=98swab=E2=80=99=
? [-Wimplicit-function-declaration]
>   658 |         swap(*src_addr, *dst_addr);
>       |         ^~~~
>       |         swab
>
> /usr/bin/ld: /home/build/linux/samples/bpf/xsk_fwd.o: in function `thread=
_func':
> xsk_fwd.c:(.text+0x440): undefined reference to `swap'
> collect2: error: ld returned 1 exit status
>
>
> Could we maybe get samples/bpf added to the BPF CI builds? :)

Maybe we could, if someone dedicated their effort towards making this happe=
n.

>
> -Toke
>
