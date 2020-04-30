Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980091BEE30
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgD3CP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726286AbgD3CP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 22:15:27 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2CDC035494;
        Wed, 29 Apr 2020 19:15:27 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n17so3342694ejh.7;
        Wed, 29 Apr 2020 19:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ir92wbANJ/6o1M0DWfLzJyw4ihwe64y3qEPUHFY6lx0=;
        b=Sy2EVLT5LzXV8LjxgSJ9G8NxTKngGnW6k+QwFS05l7YTRiqHaKiFHIjRv8pN9ryXFe
         QivSXcLAZLapkBynoOHkxMTUHmd7WXN6Z0QPVzbfxbAtuBNkQaNS+aV98DDRTjyhXQYg
         iG3ultEzl6rv0+APtBW8V9S5v8kc4bakTLgT2I9DtQMJO1Z9GTMGZ1aJwjVF0XrLtzpl
         xJh3hopzCBgIu3C+z74wLopSPRd0C1m8IQd1kUUc4U/h7fstEuEsVeEnEgN1W9Pa3+hH
         U18H78hGtzuQTvYtvUHorogjnpNQIAwM0xMJmqisqANZ5O7gvQVZdiH1TdYTT8vOxRj/
         ktig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ir92wbANJ/6o1M0DWfLzJyw4ihwe64y3qEPUHFY6lx0=;
        b=kZF4B33ZzEWrjo4I+67l/qxLlsFCedSB69iCyO2eJueszItk3WWNnxDd7+aYDQ6AB+
         XNhfWH8o0b98eQe0o8z+FpkUhdOcg763JKW9QGWNpCxEIfxnhkfKstQeKOYcQaEc9FYs
         excZEzFX3qTHXrOCaqmM8xy0w1NvUEl9emY0LyibB4wjwxNkkY2GTz+6Y77E5E7FgN9A
         cHD7+hwDX7B1Q5auRCracPYwHqxGM8wI18bBNJlrUk6PqKzWxt2YG2jMXHQlykFHEUuV
         GaLUYbN2P9RMYBpDDL/fbcJHey9wIo09fEyXBs/UfeDRiDzNq9H52HXDLTR9LOFizvfQ
         virw==
X-Gm-Message-State: AGi0PuZE5UWMLD5EliA6bmhZc8dCWDW6u0ZROiSaythDy6ua0uHVYcLZ
        8JglG0aZ3QS/MbKN/VClm5cWM5t5hXMEKXj4eZA=
X-Google-Smtp-Source: APiQypI11+jX0S3ayO0TfdWyeZ78O5iC/q+eFCrIdKkni4792l/Bh4dBCcV1svLlgxcn4oRSrfXzbY8f15mdCbFl2qw=
X-Received: by 2002:a17:906:2604:: with SMTP id h4mr581932ejc.307.1588212925821;
 Wed, 29 Apr 2020 19:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200430005127.2205-1-luke.r.nels@gmail.com>
In-Reply-To: <20200430005127.2205-1-luke.r.nels@gmail.com>
From:   Xi Wang <xi.wang@gmail.com>
Date:   Wed, 29 Apr 2020 19:14:49 -0700
Message-ID: <CAKU6vybAuF-oziH8oOu1oCv+j8SLOMWq2UdM6_kVCbeggLvxSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, riscv: Fix stack layout of JITed code on RV32
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf@vger.kernel.org, Luke Nelson <luke.r.nels@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 5:51 PM Luke Nelson <lukenels@cs.washington.edu> wrote:
>
> This patch fixes issues with stackframe unwinding and alignment in the
> current stack layout for BPF programs on RV32.
>
> In the current layout, RV32 fp points to the JIT scratch registers, rather
> than to the callee-saved registers. This breaks stackframe unwinding,
> which expects fp to point just above the saved ra and fp registers.
>
> This patch fixes the issue by moving the callee-saved registers to be
> stored on the top of the stack, pointed to by fp. This satisfies the
> assumptions of stackframe unwinding.
>
> This patch also fixes an issue with the old layout that the stack was
> not aligned to 16 bytes.
>
> Stacktrace from JITed code using the old stack layout:
>
>   [   12.196249 ] [<c0402200>] walk_stackframe+0x0/0x96
>
> Stacktrace using the new stack layout:
>
>   [   13.062888 ] [<c0402200>] walk_stackframe+0x0/0x96
>   [   13.063028 ] [<c04023c6>] show_stack+0x28/0x32
>   [   13.063253 ] [<a403e778>] bpf_prog_82b916b2dfa00464+0x80/0x908
>   [   13.063417 ] [<c09270b2>] bpf_test_run+0x124/0x39a
>   [   13.063553 ] [<c09276c0>] bpf_prog_test_run_skb+0x234/0x448
>   [   13.063704 ] [<c048510e>] __do_sys_bpf+0x766/0x13b4
>   [   13.063840 ] [<c0485d82>] sys_bpf+0xc/0x14
>   [   13.063961 ] [<c04010f0>] ret_from_syscall+0x0/0x2
>
> The new code is also simpler to understand and includes an ASCII diagram
> of the stack layout.
>
> Tested on riscv32 QEMU virt machine.
>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Thanks for the fix!

Acked-by: Xi Wang <xi.wang@gmail.com>
