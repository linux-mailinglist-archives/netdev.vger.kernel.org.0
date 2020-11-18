Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A7E2B7654
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 07:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKRGcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 01:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgKRGcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 01:32:35 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD02C0613D4;
        Tue, 17 Nov 2020 22:32:34 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id u12so1070081wrt.0;
        Tue, 17 Nov 2020 22:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wqgSZ9r2kfTRap69aHQFZm5M1DT8YcVhJNk7kUqL2DY=;
        b=F1w+kD+Ycj6h5wqFwDdP+v6KZD0wQRFvur4V7623BsRHBAQXippuoKHI1wbldMlI8q
         5/j3GgKBDdd3iDpULoXDT1MnIJXy5UdLy10Ek5+Bmym8/8wIcReTxk0lpn1jqLEtpNma
         O91eTm5P31EwuhbXrT0qtQ1hroncRha1CPoquMw+saESEiSC5zLX+hvcHpywi0TNN+hl
         XN5Pk2B83/PDhsK56VLRZvpTJPTnwnSmLE3tIZG9q310w8fzFH661YaHG1L3mxIOi3Ca
         8tXPRQlArZPMaaNseA/ceWfrHwCcu/5tcPiNnFAp51pBK8ZTpeDiZ4pBgyt1PDeO7xBy
         scng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wqgSZ9r2kfTRap69aHQFZm5M1DT8YcVhJNk7kUqL2DY=;
        b=sVWjv8G/b6vKY1Js3vzcOkVY5JdY7Si+ffkeAs9cTh7zf7MEHH4N0c28mS693NyQt7
         BVIvCAZnvjoroxkN9sopwXwpnGekuqYzK8HMYO2KnvI8j8A8XECerPZl1rhgzr8nWz+L
         L/JdxYkxCnvLHJ37zIZ56TZwJdx7b/biRltI439TzJqdDFe+ykMTMvzJVJIelUeV+p4j
         rI93nQmTDpluhQEnCUtlwzsInH2ox23UZ4yeOyY6+CQDw/1yBk4h6GPrNb+wvGADVjoz
         Kj3rCRNlnuuwyfSjkggOzON6JOIBGeHRcS6QX9VPVlCQUJWxlZvWQ9IF0GykFC1Hd0SH
         m2kA==
X-Gm-Message-State: AOAM530Q6jhcnNFHiE61+TbMkULWQl8RqWpclxUx6LAW6PmyOcSGocuQ
        MJ9PWIyXIR8QT8dd/f9k1JKEwV+nDHjXCTNgNDE=
X-Google-Smtp-Source: ABdhPJx/SGBBnXmA99q5yVAio/qHRvzL6aSrJc1+CarckpmICW4YIjM8xB3gt4Fz4hrAv3Nh3u4xmirC7RwsskpkD3M=
X-Received: by 2002:adf:ed04:: with SMTP id a4mr3361502wro.172.1605681153633;
 Tue, 17 Nov 2020 22:32:33 -0800 (PST)
MIME-Version: 1.0
References: <20201117082638.43675-1-bjorn.topel@gmail.com> <20201117082638.43675-3-bjorn.topel@gmail.com>
 <CAEf4BzZYXw8cd53+owz1ctsO9diFNJ9oCzgEEGMqRVUjmsN+ew@mail.gmail.com>
In-Reply-To: <CAEf4BzZYXw8cd53+owz1ctsO9diFNJ9oCzgEEGMqRVUjmsN+ew@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 18 Nov 2020 07:32:21 +0100
Message-ID: <CAJ+HfNj9Ou=ftR__0gN-MnO4NMRLPCJ4krXDNxZk0uEYJAu20A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] selftests/bpf: Avoid running unprivileged
 tests with alignment requirements
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 at 02:43, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>
> On Tue, Nov 17, 2020 at 12:29 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail=
.com> wrote:
> >
> > Some architectures have strict alignment requirements. In that case,
> > the BPF verifier detects if a program has unaligned accesses and
> > rejects them. A user can pass BPF_F_ANY_ALIGNMENT to a program to
> > override this check. That, however, will only work when a privileged
> > user loads a program. A unprivileged user loading a program with this
> > flag will be rejected prior entering the verifier.
>
> I'd include this paragraph as a code comment right next to the check belo=
w.
>
> >
> > Hence, it does not make sense to load unprivileged programs without
> > strict alignment when testing the verifier. This patch avoids exactly
> > that.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/test_verifier.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testin=
g/selftests/bpf/test_verifier.c
> > index 9be395d9dc64..2075f6a98813 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -1152,9 +1152,15 @@ static void get_unpriv_disabled()
> >
> >  static bool test_as_unpriv(struct bpf_test *test)
> >  {
> > -       return !test->prog_type ||
> > -              test->prog_type =3D=3D BPF_PROG_TYPE_SOCKET_FILTER ||
> > -              test->prog_type =3D=3D BPF_PROG_TYPE_CGROUP_SKB;
> > +       bool req_aligned =3D false;
> > +
> > +#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> > +       req_aligned =3D test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCES=
S;
> > +#endif
> > +       return (!test->prog_type ||
> > +               test->prog_type =3D=3D BPF_PROG_TYPE_SOCKET_FILTER ||
> > +               test->prog_type =3D=3D BPF_PROG_TYPE_CGROUP_SKB) &&
> > +               !req_aligned;
>
> It's a bit convoluted. This seems a bit more straightforward:
>
> #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>     if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
>         return false;
> #endif
> /* the rest of logic untouched */
>
> ?
>

Ugh. Yes, indeed. *blush*


Bj=C3=B6rn
