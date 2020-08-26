Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94A7253139
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 16:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgHZOZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 10:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbgHZOZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 10:25:34 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355D5C061574;
        Wed, 26 Aug 2020 07:25:34 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id w14so2602066ljj.4;
        Wed, 26 Aug 2020 07:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fUtIj3hzDzLsBqvJCTdE5TL3n5Xu1i/sePosco2yc7g=;
        b=KiE/D0AgpWhG/1MbSVKmVxY7meQYPdEK4JuI7/bYiLZZCAHwNr5KLQJjx+3Nacmlx6
         6wSZvgKEs4XBYgGS0Zx9jhbsAlWYwLXk0CnQ9KOblQ4eBhWE861KPJz3b2L+zOWG3zoV
         /K7Ji13TNwyL3+Vl7sjqIkEwu6tRDdk+Z5uwqAxu1TLQOBdxgvtJD4mEuE9Fx5D/N3+Y
         QSHaZPQWAovWYZvnDtuViquyg8txQ0atPclwJPW2BPBWLs6QcFyR4BrfBzB3iY36ujFg
         4p3CviO2noPkikBq/io54g91htX6Z7dpnOAuesIuN9w5vnIg93LeqstuwfORprQnX4/+
         3TQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fUtIj3hzDzLsBqvJCTdE5TL3n5Xu1i/sePosco2yc7g=;
        b=PI/9DChXrY8I2lPpDRTi60ftcjk93FFfdh1Jo/Ar/o+2Ia3OkjCZc9lCKK1isTsNDx
         UbDd6t2sC8FkITMc8xnCZA2+lN/R0xW0fRS3sATtZeegL1RQtbf7tWtt1bHAgKL8daK0
         RtTS9LuebZFv+se1anVtN/u9T1WL1xTWqT80jrDGMjHspugK3RTOQnsDQANKXcSLa9aA
         Fr/ZkVH8za/N2QPqHR0CYLwoYgw/QXt270N8fesJHFYnehgxjN+P/Tj0pkPvmFMsQA5b
         HFn8YHkgPG+ZlZsH7dtO+tKr9k0MYhkKvvz9MGGqnqJFF/QlOEpcfm1VLftW55nI0Ft+
         oKQQ==
X-Gm-Message-State: AOAM5304GywMiEllqvtTrMqb8KTOjDjXN5/i6FOi18fi00icA1NCFi79
        2LSEd2EgYbMNWCzXrKLcEDNJ/nDt1cozwifcZCii2Aij
X-Google-Smtp-Source: ABdhPJyJ46idCRtmkxHnRB9Jg+3IBsnQtM/eqyN9oMKSA80miG9ffalfVw1LtygAaJ+0Jzd5fNFj4GOu07Elsl0ASes=
X-Received: by 2002:a2e:8e28:: with SMTP id r8mr6861089ljk.290.1598451932616;
 Wed, 26 Aug 2020 07:25:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200826101845.747617-1-jolsa@kernel.org>
In-Reply-To: <20200826101845.747617-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 26 Aug 2020 07:25:21 -0700
Message-ID: <CAADnVQLc5=Y_ssfp53DuJvRRu4YdQ=qdKS9fsP23XhqLXeb-vQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix open call in trigger_fstat_events
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 3:19 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Alexei reported compile breakage on newer systems with
> following error:
>
>   In file included from /usr/include/fcntl.h:290:0,
>   4814                 from ./test_progs.h:29,
>   4815                 from
>   .../bpf-next/tools/testing/selftests/bpf/prog_tests/d_path.c:3:
>   4816In function =E2=80=98open=E2=80=99,
>   4817    inlined from =E2=80=98trigger_fstat_events=E2=80=99 at
>   .../bpf-next/tools/testing/selftests/bpf/prog_tests/d_path.c:50:10,
>   4818    inlined from =E2=80=98test_d_path=E2=80=99 at
>   .../bpf-next/tools/testing/selftests/bpf/prog_tests/d_path.c:119:6:
>   4819/usr/include/x86_64-linux-gnu/bits/fcntl2.h:50:4: error: call to
>   =E2=80=98__open_missing_mode=E2=80=99 declared with attribute error: op=
en with O_CREAT
>   or O_TMPFILE in second argument needs 3 arguments
>   4820    __open_missing_mode ();
>   4821    ^~~~~~~~~~~~~~~~~~~~~~
>
> We're missing permission bits as 3rd argument
> for open call with O_CREAT flag specified.
>
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Fixes: e4d1af4b16f8 ("selftests/bpf: Add test for d_path helper")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Applied. Thanks
