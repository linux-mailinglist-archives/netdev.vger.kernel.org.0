Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D836234FC94
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbhCaJWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhCaJWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 05:22:30 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35613C061574;
        Wed, 31 Mar 2021 02:22:30 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id a143so20463711ybg.7;
        Wed, 31 Mar 2021 02:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Io/8COCIMelBlssiGf/QwkSf0NWKvCwN1kFvShgTt3k=;
        b=e9FcEWP/5o1QjN/f0/33JiTVAOPQ3JdICqsdLJtkSrslvLe7BlX4v4Ri0gKlXbMysA
         Vxn6iFcYPzUMVM95+IhGqaeL2jgLeVyqxxtLi2PkTdm2WQqh1uIIKxfe74Yz7mXx6GR/
         HAd7EVV1zWR4aTaAtM46I6Tg5YBw66x8JvdJCnloZ2FdaA4r4/C5Dqxsnvhc5OYzOkk8
         c9A9dZQe5HQj27NG4Sg8eBohonUeb9CtettyYYNjtlyOOmHMF/EH2ma4MiBFUgDAlE1B
         wzUDATrXdAnTql6h9rdcnhwOhF/UQ6vALjOqMw44jawpZmlhCGv9PUUPa5QPzpq7MUeK
         2oEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Io/8COCIMelBlssiGf/QwkSf0NWKvCwN1kFvShgTt3k=;
        b=QaYTHvOfqQzKPonPpfj6Ru9+5trMv4V35LAye/gAKPf138ebjFl5JRczGKGkoh6BI/
         8GUZa62gL5G0GsPsdD/uOuKwPVkiQ1UWZwlCrVCyK8kCW+OD1aVjDs+K+x70Wc91bRSN
         RQ9oLX/tycvIj5vlVhvBxqsZvyi5gcsVKYMzx82Q2E+6vxHILU0zGYGntHregJjE19z4
         DN4Swa2ZAm1EdQukGU6ZyjP0PikBombOfXG50R2SxG0D41rQAfkgZjxoJvgYud4SvyDT
         nZ3OzBF6hbGd6fTsaRoSrj4MzNQkql/OeUYsp5d1qZHCcmR5nlZikx25FzW75obIbnfP
         CC4g==
X-Gm-Message-State: AOAM531fsxQ6PpGJL02XLBrREOmG/VM5VbTnGoO1cI/QQwLAU2LC8Pkt
        qBAYROTvfkkVXWq+vE8psxQR+2R8Ird+suTiVJ4=
X-Google-Smtp-Source: ABdhPJyu9ieNGBg82MYlajy2cM5KBzgiBlcU4P77Qs2Qg8m0lch7OrGnx++N3mC3ia88bCMGMct/gteEy8HLzGXQDqU=
X-Received: by 2002:a25:ba87:: with SMTP id s7mr3183267ybg.222.1617182549547;
 Wed, 31 Mar 2021 02:22:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210330074235.525747-1-Jianlin.Lv@arm.com> <20210330093149.GA5281@willie-the-truck>
In-Reply-To: <20210330093149.GA5281@willie-the-truck>
From:   Jianlin Lv <iecedge@gmail.com>
Date:   Wed, 31 Mar 2021 17:22:18 +0800
Message-ID: <CAFA-uR8_N=RHbhm4PdiB-AMCBdXsoMyM-9WgaPxPQ7-ZF6ujXA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: arm64: Redefine MOV consistent with arch insn
To:     Will Deacon <will@kernel.org>
Cc:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf <bpf@vger.kernel.org>,
        zlim.lnx@gmail.com, catalin.marinas@arm.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 5:31 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Mar 30, 2021 at 03:42:35PM +0800, Jianlin Lv wrote:
> > A64_MOV is currently mapped to Add Instruction. Architecturally MOV
> > (register) is an alias of ORR (shifted register) and MOV (to or from SP)
> > is an alias of ADD (immediate).
> > This patch redefines A64_MOV and uses existing functionality
> > aarch64_insn_gen_move_reg() in insn.c to encode MOV (register) instruction.
> > For moving between register and stack pointer, rename macro to A64_MOV_SP.
>
> What does this gain us? There's no requirement for a BPF "MOV" to match an
> arm64 architectural "MOV", so what's the up-side of aligning them like this?
>
> Cheers,
>
> Will

According to the description in the Arm Software Optimization Guide,
Arithmetic(basic) and Logical(basic) instructions have the same
Exec Latency and Execution Throughput.
This change did not bring about a performance improvement.
The original intention was to make the instruction map more 'natively'.

Jianlin
