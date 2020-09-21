Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A47273635
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbgIUXI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728756AbgIUXI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:08:27 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D077C061755;
        Mon, 21 Sep 2020 16:08:27 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h9so3943319ybm.4;
        Mon, 21 Sep 2020 16:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=z07NfRPeHJi/RvJSQTYawQFk8CEFXzOXw4x/AeiWqak=;
        b=Ye7f96GPaHqaF3CSctwO+rK8Qcjeo/klXNTB9uVEFaTEbXOuelXNzN7sEWvQS+hPX5
         bG4hrUfylh2UTRwcNtbeAtUNU4YcDWU7+wSkmGTj1KbRqFchCRwfwioS/X88BpdfDLBx
         3S1+r00p8fO3SpoPCjwJv9lPP04pvsbFZ13JAFyavG4PFcOgu93j2au8LCS9+pBP90gl
         w5nxLyx8VVwm5Sn9vFWdbH/wPfyvv6ak8ZFEMqFOfX1XSDRoAJoR3TbAHC0VIqImUS5s
         J9pKqzY5T6GFfsGHlnIAYEYSutDeA8ZAc8cZJGxuwCqUG1t2kys7NgwU8XXNc85m+cdE
         6L/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z07NfRPeHJi/RvJSQTYawQFk8CEFXzOXw4x/AeiWqak=;
        b=B1vI3UmlQVSx3FZBNsQMr7JmCXcFZKFQpNa7twhhCKsNHABJSbtnG8T8Wxf6PEu7ch
         ITbT5YbjS6JpYWUpKGgTWWIJRFHp8ERiPTFgqoXgHB9Ge1HXgEOF7tGoz9/6Yleu2XVP
         VJiLIbJMReEnrPFnH1Vc6/TwgZlxYYEUlhWIyvD1AfTDTeW5NEieQAHKY0hNOHHzdl/b
         My2Ad4DQXRl1m6teoOlRdk0M5YqseMJD6++uW3I4bjW/2DgRceMWG864YO0874h1fEyh
         KhehQwwxKrhkcd7JIrEFFHLAf1iA0b8Ow0MgPnoo41dJ3U+Zm9KP4EfyuxXZYhEZVlc1
         0LbQ==
X-Gm-Message-State: AOAM533NudnqGkmtYWwsEikrKkAUrIg5HtnrlZp9nFbc9aCdWdHrcCp/
        dykLjM42G9SyWgm6jb3jBv5MnFAhzu1zCF9FCEs=
X-Google-Smtp-Source: ABdhPJzp9UG9nOxeqORyySxDsY72/U7KreAPUMOhRmloZVL4GUMFIKRQH4tR45Crme5+8bWFXaGIxE1HGM3Paq9I+DQ=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr3101927ybp.510.1600729706370;
 Mon, 21 Sep 2020 16:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <160051618267.58048.2336966160671014012.stgit@toke.dk> <160051618846.58048.6000955286403207701.stgit@toke.dk>
In-Reply-To: <160051618846.58048.6000955286403207701.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 16:08:15 -0700
Message-ID: <CAEf4BzZO3S+HRSC14tvjp3K5scqkXs1MVma7507VFKB2sp+Cjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 05/10] bpf: support attaching freplace
 programs to multiple attach points
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
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This enables support for attaching freplace programs to multiple attach
> points. It does this by amending the UAPI for bpf_link_Create with a targ=
et
> btf ID that can be used to supply the new attachment point along with the
> target program fd. The target must be compatible with the target that was
> supplied at program load time.
>
> The implementation reuses the checks that were factored out of
> check_attach_btf_id() to ensure compatibility between the BTF types of th=
e
> old and new attachment. If these match, a new bpf_tracing_link will be
> created for the new attach target, allowing multiple attachments to
> co-exist simultaneously.
>
> The code could theoretically support multiple-attach of other types of
> tracing programs as well, but since I don't have a use case for any of
> those, there is no API support for doing so.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h            |    2 +
>  include/uapi/linux/bpf.h       |    9 +++-
>  kernel/bpf/syscall.c           |  102 +++++++++++++++++++++++++++++++++-=
------
>  kernel/bpf/verifier.c          |    9 ++++
>  tools/include/uapi/linux/bpf.h |    9 +++-
>  5 files changed, 108 insertions(+), 23 deletions(-)
>

[...]
