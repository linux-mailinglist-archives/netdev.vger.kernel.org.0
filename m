Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29A91B82AA
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgDYAPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgDYAPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 20:15:38 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF6FC09B049;
        Fri, 24 Apr 2020 17:15:37 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id k28so9165989lfe.10;
        Fri, 24 Apr 2020 17:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1N5YXbQL97SPK+hQrCQ0C0XPFOq+f8Ve7eYt4JHaFEo=;
        b=o4Y/4BMZEVoOUbSDLvEQkeJjOW+h11pHfhICS7S0zllHKqAL+GAsqroYMdzInICDaN
         CgET2odzvyaEFsgA/ld6/IbR28XRZp2h7RNFF1YoUC7X4bzWWtYCLspse2cqfMcwo1EM
         FsWmiQqx/CUYX1ezGiMpZ4A1DsS+7VBE8ohiU1dCpryAuH8R6URzsMhuGHZYTLDjfdeq
         W2iQ8O+39ckiYc8hu9+kVzI96OTkrKaW+gzotheG2bEbxPcwp1h+jN0j+6QbvA0WaJ6U
         YZOOvhCPK3zmw37ch+ObIOMsLBGkaEUJfjL9My/EVVBjAj962mknxqPUMFP/D2f0UXfg
         FErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1N5YXbQL97SPK+hQrCQ0C0XPFOq+f8Ve7eYt4JHaFEo=;
        b=EWWWr6ej5/T+BDvNktyxvtxOFp3/TBrNznZZcXHVgUv7Ld+icFAEhqiQcToL9UGU8J
         ld6jAl1PfFtwS+GhKjpQukvYgghkQ3ArzjPWisPBXjBMkmyLkdoWXuYR2FdA/GvqE0qC
         SdBeAYhCH6QmZoWs13bLvmCnOcLbyjEfiFRVMHnuS6aMgOPyeKGcHJViwuNfmTX9aKqr
         fQTgCrqJp6q6dtgFyAL10S9DTDpK3ejkZtgkZK2EP2dL4WO8ka7iXfGD2X4tA3gAjkGQ
         RYDSWosMDibgl4aCMrIFy31ylu6DyaSydbs+YPE9m61qsEvBwFvlR4mEh/6FgXkQyKwf
         ykiA==
X-Gm-Message-State: AGi0PuZj6xKjhJCL1WOBAdKcNC1IMYJ145bX+kne84zlMsbbPVNcv8vI
        XKOvFWCPuIr+gTqHwNUDlwRleHJDgwqhc2bPdRU=
X-Google-Smtp-Source: APiQypK9VG3bsKL4bwNuhVqet0lBfmbIBxlUQKrjGENUQGzudHH8lDNo67ol74aL8V6zGGnoY0jokBo87jJqF3mOnLY=
X-Received: by 2002:ac2:4426:: with SMTP id w6mr7927786lfl.8.1587773736160;
 Fri, 24 Apr 2020 17:15:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200422173630.8351-1-luke.r.nels@gmail.com>
In-Reply-To: <20200422173630.8351-1-luke.r.nels@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 Apr 2020 17:15:23 -0700
Message-ID: <CAADnVQJHKXgXg3WQc5L5LvV7VvvgU92evjQZSfAOmSoCH9M-yQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/2] bpf, x86_32: Fix incorrect encoding in BPF_LDX zero-extension
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Brian Gerst <brgerst@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Wang YanQing <udknight@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 10:36 AM Luke Nelson <lukenels@cs.washington.edu> wrote:
>
> The current JIT uses the following sequence to zero-extend into the
> upper 32 bits of the destination register for BPF_LDX BPF_{B,H,W},
> when the destination register is not on the stack:
>
>   EMIT3(0xC7, add_1reg(0xC0, dst_hi), 0);
>
> The problem is that C7 /0 encodes a MOV instruction that requires a 4-byte
> immediate; the current code emits only 1 byte of the immediate. This
> means that the first 3 bytes of the next instruction will be treated as
> the rest of the immediate, breaking the stream of instructions.
>
> This patch fixes the problem by instead emitting "xor dst_hi,dst_hi"
> to clear the upper 32 bits. This fixes the problem and is more efficient
> than using MOV to load a zero immediate.
>
> This bug may not be currently triggerable as BPF_REG_AX is the only
> register not stored on the stack and the verifier uses it in a limited
> way, and the verifier implements a zero-extension optimization. But the
> JIT should avoid emitting incorrect encodings regardless.
>
> Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Applied. Thanks
