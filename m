Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74271C7291
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 16:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgEFORh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 10:17:37 -0400
Received: from terminus.zytor.com ([198.137.202.136]:57243 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbgEFORh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 10:17:37 -0400
Received: from [IPv6:2601:646:8600:3281:d9e2:e16d:2ce4:a5c3] ([IPv6:2601:646:8600:3281:d9e2:e16d:2ce4:a5c3])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 046EGISp3022440
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 6 May 2020 07:16:20 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 046EGISp3022440
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020042201; t=1588774580;
        bh=2t81ix48+XEqIovy4/uuaiJNVpVfGfHkdc5n10MqWF4=;
        h=Date:In-Reply-To:References:Subject:To:From:From;
        b=ETbnGxm8J7xr65vxrUydccH3oDZPr6ssZbQrpdFDLaJeehBoK3COvrkjxemldJ7Kx
         Sa52fbj6LykWgbqsauISnLs58GZlGFQSwp79DKsiE1odTeSOahoIzKxZbKYslRZtx0
         leFQHs/2egU6BRZTlK0L2B6oIkbgaI2b94xuQ4hRk4PQFHIuoTwmGAvAjJP3lp8BMK
         zUtyWynNJ6BlmrLVpoB2QgQIliA5HiCUHfX7pco+BKXdU7t7orRcmmE0/IvCMP0sE0
         PY/U2uGwLk/0CeWvIzDjVdiuqMmSLvMaZFW9KlUXKXXlYlfF7y6ZcnDqnTxh9U/8cl
         nnKRsNJVAHEHA==
Date:   Wed, 06 May 2020 07:16:11 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <20200506140352.37154-1-yanaijie@huawei.com>
References: <20200506140352.37154-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] bpf, i386: remove unneeded conversion to bool
To:     Jason Yan <yanaijie@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, udknight@gmail.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        lukenels@cs.washington.edu, xi.wang@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   hpa@zytor.com
Message-ID: <D11F36F6-BF28-4DEB-8AED-4486477130F8@zytor.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On May 6, 2020 7:03:52 AM PDT, Jason Yan <yanaijie@huawei=2Ecom> wrote:
>The '=3D=3D' expression itself is bool, no need to convert it to bool
>again=2E
>This fixes the following coccicheck warning:
>
>arch/x86/net/bpf_jit_comp32=2Ec:1478:50-55: WARNING: conversion to bool
>not needed here
>arch/x86/net/bpf_jit_comp32=2Ec:1479:50-55: WARNING: conversion to bool
>not needed here
>
>Signed-off-by: Jason Yan <yanaijie@huawei=2Ecom>
>---
> v2: change the name 'x32' to 'i386'=2E
>
> arch/x86/net/bpf_jit_comp32=2Ec | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/net/bpf_jit_comp32=2Ec
>b/arch/x86/net/bpf_jit_comp32=2Ec
>index 66cd150b7e54=2E=2E96fde03aa987 100644
>--- a/arch/x86/net/bpf_jit_comp32=2Ec
>+++ b/arch/x86/net/bpf_jit_comp32=2Ec
>@@ -1475,8 +1475,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int
>*addrs, u8 *image,
> 	for (i =3D 0; i < insn_cnt; i++, insn++) {
> 		const s32 imm32 =3D insn->imm;
> 		const bool is64 =3D BPF_CLASS(insn->code) =3D=3D BPF_ALU64;
>-		const bool dstk =3D insn->dst_reg =3D=3D BPF_REG_AX ? false : true;
>-		const bool sstk =3D insn->src_reg =3D=3D BPF_REG_AX ? false : true;
>+		const bool dstk =3D insn->dst_reg !=3D BPF_REG_AX;
>+		const bool sstk =3D insn->src_reg !=3D BPF_REG_AX;
> 		const u8 code =3D insn->code;
> 		const u8 *dst =3D bpf2ia32[insn->dst_reg];
> 		const u8 *src =3D bpf2ia32[insn->src_reg];

"foo ? true : false" is also far better written !!foo when it isn't totall=
y redundant=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
