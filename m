Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF26C34FD5B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbhCaJnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbhCaJmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 05:42:33 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7D4C061760;
        Wed, 31 Mar 2021 02:42:30 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id j2so20514773ybj.8;
        Wed, 31 Mar 2021 02:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uffvPkyMufuNC6hYRdnOdeXZJRXFeHWgbRy9wTM/0dE=;
        b=fcjddm5fklIvWQ7+zv/PDfUmiYRY3GTspAMRBTRMkyzcTg2+kB9GXh02T+A1FzDuT/
         X4MCB0ZTaLLJp9OgtPmT1nmIvYT3SVM1S61nieKujPloYK8hLPtONBp0EZqDqMrVfjJV
         ZSlXxFvEbkzvokEpUsQmczU6ZhMgn7b/2a+MbgoWotzIYNqzow9zSZQo7tGWpXYwLYsQ
         iCJeJgsbotEe3KgJjfSRgjIahFYZHWBCN2cz4L2U8kQ+HxHYOuiMY8/mxM5nFY3IZ48E
         qAyfkeoLANrkiBpGe2REI2fP8itn1VooThBE1g1tnKv4dvO5lZbXwyyUOFfwtWwM7Wxf
         DGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uffvPkyMufuNC6hYRdnOdeXZJRXFeHWgbRy9wTM/0dE=;
        b=CoUGevOVUsmQv4mTpK8gucgnUbKPwIYbz9yUB478Dk42ZUuxwS9kfgq6qaFw06iw9F
         U1MF2q7uo275F4wRC4mzi48Q4iHdy9caVkX9QehMHvyZN0va/yFhY/X8j37sGU+Z2WpL
         Y+fSrDglxyA3Q0+xosb2vQc/aXqlLuBODbc+N9NUzLSf9HbDTfbG7Cq1tAWGoMGnVLFx
         vZ1GoxRpcHUaUVROeg51KrZgIRGt7pp3XFwAtObQ1SWB0AMZ+Fd3ZPMdMKQ89RLdhUep
         /w2fTlK+6aU0KYA1MAnQ8mf7dsNVSrTObRrLyN2ARx1p/zKT23jjCIHRGpmTFaqNaZDj
         DKrg==
X-Gm-Message-State: AOAM532ZU+D6sYvZAoVxTLKJy9pEBLso8kXdNRGmgkFc1F45F1rXUdyG
        5CQzJcZCBRfvvg7WfDYSYPJ+PaZCUgR8FGvqgmY=
X-Google-Smtp-Source: ABdhPJzWPx2jmwXOmbfcxLLLtyZH5lnh+4X/EBIge3CvhLCXGZKTV1b/oGmLSZi89dUc/0KV/cfDM2HhD2lO1RM7Vs4=
X-Received: by 2002:a25:d914:: with SMTP id q20mr3275600ybg.397.1617183749960;
 Wed, 31 Mar 2021 02:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210330074235.525747-1-Jianlin.Lv@arm.com> <20210330093149.GA5281@willie-the-truck>
 <CAFA-uR8_N=RHbhm4PdiB-AMCBdXsoMyM-9WgaPxPQ7-ZF6ujXA@mail.gmail.com> <20210331092844.GA7205@willie-the-truck>
In-Reply-To: <20210331092844.GA7205@willie-the-truck>
From:   Jianlin Lv <iecedge@gmail.com>
Date:   Wed, 31 Mar 2021 17:42:18 +0800
Message-ID: <CAFA-uR_8mEh02647Udqiq1bq8B8KVJ8kc-j2CpzuFuRQEGUS1A@mail.gmail.com>
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

On Wed, Mar 31, 2021 at 5:28 PM Will Deacon <will@kernel.org> wrote:
>
> On Wed, Mar 31, 2021 at 05:22:18PM +0800, Jianlin Lv wrote:
> > On Tue, Mar 30, 2021 at 5:31 PM Will Deacon <will@kernel.org> wrote:
> > >
> > > On Tue, Mar 30, 2021 at 03:42:35PM +0800, Jianlin Lv wrote:
> > > > A64_MOV is currently mapped to Add Instruction. Architecturally MOV
> > > > (register) is an alias of ORR (shifted register) and MOV (to or from SP)
> > > > is an alias of ADD (immediate).
> > > > This patch redefines A64_MOV and uses existing functionality
> > > > aarch64_insn_gen_move_reg() in insn.c to encode MOV (register) instruction.
> > > > For moving between register and stack pointer, rename macro to A64_MOV_SP.
> > >
> > > What does this gain us? There's no requirement for a BPF "MOV" to match an
> > > arm64 architectural "MOV", so what's the up-side of aligning them like this?
> >
> > According to the description in the Arm Software Optimization Guide,
> > Arithmetic(basic) and Logical(basic) instructions have the same
> > Exec Latency and Execution Throughput.
> > This change did not bring about a performance improvement.
> > The original intention was to make the instruction map more 'natively'.
>
> I think we should leave the code as-is, then. Having a separate MOV_SP
> macro s confusing and, worse, I worry that somebody passing A64_SP to
> A64_MOV will end up using the zero register.
>
> Will

OK, your concerns are justified. I have made such mistakes.

Jianlin
