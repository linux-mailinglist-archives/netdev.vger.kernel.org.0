Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3C211807A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 07:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfLJGbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 01:31:39 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37198 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfLJGbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 01:31:39 -0500
Received: by mail-qk1-f194.google.com with SMTP id m188so15535398qkc.4;
        Mon, 09 Dec 2019 22:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9iJIcIsuvyaKuPCjR081dtZXW++oZ7hj1JifXMC1F5Q=;
        b=tQOU0We/iItFc8KG52IjN8yKcohDPXKl7RkDmRCr0JGDbwrqD739SRmZx4HGmE4duI
         J0XY+auZyepuaZAvGnbKX4M4p+YIq7Efv67rta+b3j+CyjCd0EZT1RCxCvBb+60Gb9Ck
         VLYhzDBNSrWqlwtit3o2w9SpLFsUDQIwDXzOQFY8+fcGXIIx6EA1NKNgIaDameUMHFSF
         ybar8inmlhJw+69UVINPdq2Q/SvHrsAqgN5f/8AuSxN7phLbDq8Ew0FR+p9hZiy1Bc+T
         dYDqmR70lInb3Av9ACUArifbaKLjrHCfEIaJ1aPxVQlPLmvw3vD97UJBHAGiOHoxK+n+
         YHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9iJIcIsuvyaKuPCjR081dtZXW++oZ7hj1JifXMC1F5Q=;
        b=fO1Xnkb3jyU7aadqxhCI//KwNLph0gqb61NoWMxzazZCsjMWOVa4VzqZ1nrlrwViw7
         OdJs4TRQzFnwm1MtPewLZv/OpTx68gcKjzHJZSSpLjAgo7Y98Nypz4a1Iu7fLwXgW5fN
         ZCKWGXxkQ4AR8Sx+sQRqE4OWvhrmsU8cRU6WTp0nfj33mh82FsPJNZoESxg6tooJh1P6
         CNvr833IkJBlAKe411gaRGGcmRS+tPUY162YZqw4SV8nS3DlJzNdy6BOhBvdiPPUuYXL
         xnRrSW5e1rRim9wHoMWs5BLMbd3BN0uHzHMjIA4boYh6XNI6zO+34Jz1h5PH0cdAboyK
         g/uQ==
X-Gm-Message-State: APjAAAU4FSDS3muOsEMLIyT47NXkrwwQ/mUSOwTWBFj5vLKDNrphiB4J
        2pxfmHXiiRp/jbe5PvsrwW9ZTPPutjqDSA/CFJw=
X-Google-Smtp-Source: APXvYqx3F+LQFuqQ022bdlz/MnN6T1zHXpSEHoXO3K+x8qu9cpOaRxwv+CVqGdE058LR7mSeqLWqg50/WQvlj45HWMQ=
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr31583276qke.297.1575959497981;
 Mon, 09 Dec 2019 22:31:37 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575916815.git.paul.chaignon@gmail.com> <966fe384383bf23a0ee1efe8d7291c78a3fb832b.1575916815.git.paul.chaignon@gmail.com>
 <CAJ+HfNgFo8viKn3KzNfbmniPNUpjOv_QM4ua_V0RFLBpWCOBYw@mail.gmail.com>
In-Reply-To: <CAJ+HfNgFo8viKn3KzNfbmniPNUpjOv_QM4ua_V0RFLBpWCOBYw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 10 Dec 2019 07:31:26 +0100
Message-ID: <CAJ+HfNiqtF9T-C7a1NoSekSAW+Fpr2kH2EghLDiRmf_+-Uat-w@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf, riscv: limit to 33 tail calls
To:     Paul Chaignon <paul.chaignon@orange.com>
Cc:     Paul Burton <paulburton@kernel.org>,
        Mahshid Khezri <khezri.mahshid@gmail.com>,
        paul.chaignon@gmail.com, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 at 20:57, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> =
wrote:
>
> On Mon, 9 Dec 2019 at 19:52, Paul Chaignon <paul.chaignon@orange.com> wro=
te:
> >
> > All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail calls
> > limit at runtime.  In addition, a test was recently added, in tailcalls=
2,
> > to check this limit.
> >
> > This patch updates the tail call limit in RISC-V's JIT compiler to allo=
w
> > 33 tail calls.  I tested it using the above selftest on an emulated
> > RISCV64.
> >
>
> 33! ICK! ;-) Thanks for finding this!
>
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
>

...and somewhat related; One of the tailcall tests fail due to missing
far-branch support in the emitter. I'll address this in the v2 of the
"far branch" series.
