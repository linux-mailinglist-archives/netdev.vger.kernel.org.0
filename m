Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4FF27369B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgIUX0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgIUX0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:26:16 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B1FC061755;
        Mon, 21 Sep 2020 16:26:16 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x10so11482790ybj.13;
        Mon, 21 Sep 2020 16:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OF+8FVJOcX0nhPnapCQtkAgPuZTioEJ95Qg1Q6KEc7E=;
        b=cSREQmRfwhhvazC8M5eotFneglUwjLrY3gVkrI1yFVUk5AtNryw1J8cERbBdQDW3R5
         q+rBR7QIspGxDv4D9i10KJRA1pQCHjgyIm6h1G4iYnB9m3pF+E3TpQTS0qZulRRCKgIW
         C175p8zG62fniqa5/XawuYvZZ61indVqbCcBdlvX80ov4SviGOHExD8eUG5L43UxCMNK
         7KboLIufZdWAJm8N96D3DMH7mM+/o1km1mOO3YYkKboa9KXhjzN1CdrAqK3rIzfQORv8
         3Qn4EH5hFjcTaUxonlJtSr7I1UAyCBbklbwfhnAl43hEOmGohU3V1Kh2qTMFYW8J48Sd
         aPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OF+8FVJOcX0nhPnapCQtkAgPuZTioEJ95Qg1Q6KEc7E=;
        b=QRErZ6GmHCwnyJSDYA8l1iSEhMwnlSKfShQFQZoKe16dKWHAm+mrbHbU48pzEXh1i7
         vM9HpJ0r5ZP9tBUkmrAKz2rdKf2FBAFNYexaO5hQYd8IP1J6uZfJUU3aM06Kc6CZJAwa
         AvMyViLrGEoA3VqMFWdwhPiRWESLQ03qd4vqWmSvaeuDuTCGydA+rdAX2w2Ncx6Qxczo
         ZHQlQAezrl9ev2Yp/q/o1f/uVe6eyVsvWIDiwj47V2T2/+zAuh4uYKouv+vdA/O4BS44
         yTiSHBlhEIGuvIEv6JpQ0niOb4IHwz4MKtBaJiGuKtrM8fFSU5UNMsipNtQqOcARP7AH
         +sJw==
X-Gm-Message-State: AOAM530aJR8C/auXRtmSSh6iTSJPQBnOAqRj8rhI9+FM3uy/jj/rJpaA
        1q3ouASJPw185mS94x1gmqxvQ7+lKP8xA6fHrvo=
X-Google-Smtp-Source: ABdhPJxxd2c9q1eSl3BT+/O/uIVL+l6Hpby6TFYbtDke4mRAD5ArAp6RyXM46sWJH5idfY8AQm70k4hr5P0RGO1Ch5M=
X-Received: by 2002:a25:8541:: with SMTP id f1mr2899621ybn.230.1600730775327;
 Mon, 21 Sep 2020 16:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
In-Reply-To: <160051618267.58048.2336966160671014012.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 16:26:04 -0700
Message-ID: <CAEf4BzZbUrTKS9utppKCiBqkeybBEQQgwjqJhSz8FJyiK32VHA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 00/10] bpf: Support multi-attach for freplace programs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> This series adds support attaching freplace BPF programs to multiple targ=
ets.
> This is needed to support incremental attachment of multiple XDP programs=
 using
> the libxdp dispatcher model.
>
> The first patch fixes an issue that came up in review: The verifier will
> currently allow MODIFY_RETURN tracing functions to attach to other BPF pr=
ograms,
> even though it is pretty clear from the commit messages introducing the
> functionality that this was not the intention. This patch is included in =
the
> serise because the subsequent refactoring patches touch the same code.
>
> The next three patches are refactoring patches: Patch 2 is a trivial chan=
ge to
> the logging in the verifier, split out to make the subsequent refactor ea=
sier to
> read. Patch 3 refactors check_attach_btf_id() so that the checks on progr=
am and
> target compatibility can be reused when attaching to a secondary location=
.
>
> Patch 4 moves prog_aux->linked_prog and the trampoline to be embedded in
> bpf_tracing_link on attach, and freed by the link release logic, and intr=
oduces
> a mutex to protect the writing of the pointers in prog->aux.
>
> Based on these refactorings, it becomes pretty straight-forward to suppor=
t
> multiple-attach for freplace programs (patch 5). This is simply a matter =
of
> creating a second bpf_tracing_link if a target is supplied. However, for =
API
> consistency with other types of link attach, this option is added to the
> BPF_LINK_CREATE API instead of extending bpf_raw_tracepoint_open().
>
> Patch 6 is a port of Jiri Olsa's patch to support fentry/fexit on freplac=
e
> programs. His approach of getting the target type from the target program
> reference no longer works after we've gotten rid of linked_prog (because =
the
> bpf_tracing_link reference disappears on attach). Instead, we used the sa=
ved
> reference to the target prog type that is also used to verify compatibili=
ty on
> secondary freplace attachment.
>
> Patches 7 is the accompanying libbpf update, and patches 8-10 are selftes=
ts:
> patch 8 tests for the multi-freplace functionality itself, patch 9 is Jir=
i's
> previous selftest for the fentry-to-freplace fix, and patch 10 is a test =
for
> the change introduced in patch 1, blocking MODIFY_RETURN functions from
> attaching to other BPF programs.
>
> With this series, libxdp and xdp-tools can successfully attach multiple p=
rograms
> one at a time. To play with this, use the 'freplace-multi-attach' branch =
of
> xdp-tools:
>
> $ git clone --recurse-submodules --branch freplace-multi-attach https://g=
ithub.com/xdp-project/xdp-tools
> $ cd xdp-tools/xdp-loader
> $ make
> $ sudo ./xdp-loader load veth0 ../lib/testing/xdp_drop.o
> $ sudo ./xdp-loader load veth0 ../lib/testing/xdp_pass.o
> $ sudo ./xdp-loader status
>
> The series is also available here:
> https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=3Db=
pf-freplace-multi-attach-alt-07
>
> Changelog:
>
> v7:
>   - Add back missing ptype =3D=3D prog->type check in link_create()
>   - Use tracing_bpf_link_attach() instead of separate freplace_bpf_link_a=
ttach()
>   - Don't break attachment of bpf_iters in libbpf

What was specifically the issue and the fix for bpf_iters?


[...]
