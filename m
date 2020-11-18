Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16982B73DA
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKRBnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKRBnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:43:33 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6976C061A48;
        Tue, 17 Nov 2020 17:43:31 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id t33so172977ybd.0;
        Tue, 17 Nov 2020 17:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VNx8kcq1AddWDv911im3ysAsNPKD5/m11Ak4OLU9NIM=;
        b=g6vbYSKUvbtFR/R1/A/Re3Zt72PtMtGCL8jQhc1aRDXYH87/L/Y5bY7B/SIzcgoAfA
         zsHs+gYUvSMYigLWdIAVjupKL99N8Cq/LUZbCCrJ6TyrnFhDdSgU1t1v2d/HjnLbO5T+
         vPXiw/YOr4YkCpdBOxRX9cHZwIX1g+BEbTpd9uX4LnwswKPTbHNSqk7MpEsmnDUEVSY1
         y+0lPvks5dqfwfMz2gkZwg96uDLPjZoq3+gum4EZTP8uM1sOby0r0V1piX6PrRgkVM/q
         gxpxTEt9Oq9bCBo8CgzoQkaXin9qpvCdBosHFL3hDYEtxhXdch1U8wBf2u77omgH0oAo
         vJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VNx8kcq1AddWDv911im3ysAsNPKD5/m11Ak4OLU9NIM=;
        b=stB668EItC5+hTUqnrrQgwlHn/+slUbYh56BvhPPSUGTqMVHydED7JGDpMnQ7Qoi71
         eq/qlmVE8Sl+JTMuqHN3N+noouYkB7ICtauC2Gi1oA2yA5Kk+HdSdtsTrFBoBE0qhJBC
         E3BxEBiD+jvCa8ufktVUJq02dsHrFsf6v5LyGjXnqIZX6xg4B5Vv2ALtebi0nqsYDplH
         vtxsZSio6EhIl6xYsvWgCmdJBz/nyTA9PF4uNoFTf/3Gz+xdIrC1ojoQ+JyvGrHzhtZi
         L+tn9SivZEbeqlFbOlKnVbu+UF1WJ7IP01ahEJwB3fmtz6RGGUAKOXwnMtkU/rSpM7EY
         V9PQ==
X-Gm-Message-State: AOAM532gRX0GWr7G9D/uWEGnqBx0mu7S2H5n6mHg7k8U7aIU6xGNPTZP
        uyrVf1aBRvMlbQi17yNPp0QvOJ1Y9AAeKM9TXSI=
X-Google-Smtp-Source: ABdhPJwbV2VfRXixZfTVNj+jVsO2B5vKVlVnwnRQOVV3A/VY1Rw8KTVsMZjktOGK+hSfSfnGIj/mpS1xXrUDD/UAhtY=
X-Received: by 2002:a25:3d7:: with SMTP id 206mr3614284ybd.27.1605663811168;
 Tue, 17 Nov 2020 17:43:31 -0800 (PST)
MIME-Version: 1.0
References: <20201117082638.43675-1-bjorn.topel@gmail.com> <20201117082638.43675-3-bjorn.topel@gmail.com>
In-Reply-To: <20201117082638.43675-3-bjorn.topel@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 17:43:20 -0800
Message-ID: <CAEf4BzZYXw8cd53+owz1ctsO9diFNJ9oCzgEEGMqRVUjmsN+ew@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] selftests/bpf: Avoid running unprivileged
 tests with alignment requirements
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 12:29 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
>
> Some architectures have strict alignment requirements. In that case,
> the BPF verifier detects if a program has unaligned accesses and
> rejects them. A user can pass BPF_F_ANY_ALIGNMENT to a program to
> override this check. That, however, will only work when a privileged
> user loads a program. A unprivileged user loading a program with this
> flag will be rejected prior entering the verifier.

I'd include this paragraph as a code comment right next to the check below.

>
> Hence, it does not make sense to load unprivileged programs without
> strict alignment when testing the verifier. This patch avoids exactly
> that.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/=
selftests/bpf/test_verifier.c
> index 9be395d9dc64..2075f6a98813 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -1152,9 +1152,15 @@ static void get_unpriv_disabled()
>
>  static bool test_as_unpriv(struct bpf_test *test)
>  {
> -       return !test->prog_type ||
> -              test->prog_type =3D=3D BPF_PROG_TYPE_SOCKET_FILTER ||
> -              test->prog_type =3D=3D BPF_PROG_TYPE_CGROUP_SKB;
> +       bool req_aligned =3D false;
> +
> +#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +       req_aligned =3D test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS;
> +#endif
> +       return (!test->prog_type ||
> +               test->prog_type =3D=3D BPF_PROG_TYPE_SOCKET_FILTER ||
> +               test->prog_type =3D=3D BPF_PROG_TYPE_CGROUP_SKB) &&
> +               !req_aligned;

It's a bit convoluted. This seems a bit more straightforward:

#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
    if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
        return false;
#endif
/* the rest of logic untouched */

?






>  }
>
>  static int do_test(bool unpriv, unsigned int from, unsigned int to)
> --
> 2.27.0
>
