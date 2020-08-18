Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D149248DD3
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgHRST0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHRSTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 14:19:17 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30FBC061389;
        Tue, 18 Aug 2020 11:19:16 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d2so10727355lfj.1;
        Tue, 18 Aug 2020 11:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DVhO3m1ecJwLZaanNyTnU/3QRrHWPXEiN01fwDSt3II=;
        b=R4Dha/xh35QaKp3wBKpeYorGRttzTWi+fRc4JsVdu+Gp83ngvAJxNgnTXWY3kECKa8
         Xi0GuhnI9YOiVbrsy7WTfFVnoa1DzCLbcYlNeNGtHOxZy6Mhx7YxJURywVI5DgHeTRE6
         Z1rCvDRXoKp+VZmHJtVErRim3+IZ5HDQHLRq6aP/dQ7snceB0Ui9rtHqzTOHjKanofrS
         bVHyBa7yRoanalk0ejeP79SbuE+YoMPxl/SkT2mrLnoKCnLWIVpGAj0iEUlx6HOUP2U5
         vKbwro+irLwuYhasXb3uVbs9tzLcbQSnB6U3q+ffCrLQT7ZcHvM/b13ifdrOdmgEN1B2
         Tw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DVhO3m1ecJwLZaanNyTnU/3QRrHWPXEiN01fwDSt3II=;
        b=lWVlL7SobgbRIfaG4/f1aUHVLw48OsL3nS9MZ+DKF734XH3PW1r91DfQNwJauicicI
         VdkxKlC1nWHOCrKRJoxuReA2LQnVpOd9oBgLBYI7ez/wR8KyTtK6POdThD9jBXNj0fU1
         8DpCvCLjnLAV+4mzmhxRrAjuaGB5K+dHhIwSM4U2ei73kjGiFinwmN0lJCza5Zl5VaNA
         VTFTxUXQmk+9ErefRYsODj3G2fBWmpG1U7FEHgvka7RaOJnwhAiF8tJoeNJRjH7EWkdE
         SpKhNxUTdZX9qTLia3oDSS0rloq8ho69er0bKDp06aLVrO6sYsoJjF+sUt0Osx3qB+Kk
         ohHw==
X-Gm-Message-State: AOAM5320VblhHQiGT60gDG+inXnx4jEIjbaAdGW1f5NyTvfVHqAZZXx3
        zOkXYXiLcRgCA+NVK0+2WxK/ILF7xeBlbJ5hFqA=
X-Google-Smtp-Source: ABdhPJyfMAjBgIUQ/M3/FEyIwRAuYUHeINW5hxkOAn5OCxfQAvrCmP7x1XaqNIMe0RZ17E19T4q2wBe/7bLvPxqK+WI=
X-Received: by 2002:a19:cc3:: with SMTP id 186mr10531985lfm.134.1597774754651;
 Tue, 18 Aug 2020 11:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200717103536.397595-1-jakub@cloudflare.com> <87lficrm2v.fsf@cloudflare.com>
In-Reply-To: <87lficrm2v.fsf@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Aug 2020 11:19:03 -0700
Message-ID: <CAADnVQKE6y9h2fwX6OS837v-Uf+aBXnT_JXiN_bbo2gitZQ3tA@mail.gmail.com>
Subject: Re: BPF sk_lookup v5 - TCP SYN and UDP 0-len flood benchmarks
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 8:49 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>          :                      rcu_read_lock();
>          :                      run_array = rcu_dereference(net->bpf.run_array[NETNS_BPF_SK_LOOKUP]);
>     0.01 :   ffffffff817f8624:       mov    0xd68(%r12),%rsi
>          :                      if (run_array) {
>     0.00 :   ffffffff817f862c:       test   %rsi,%rsi
>     0.00 :   ffffffff817f862f:       je     ffffffff817f87a9 <__udp4_lib_lookup+0x2c9>
>          :                      struct bpf_sk_lookup_kern ctx = {
>     1.05 :   ffffffff817f8635:       xor    %eax,%eax
>     0.00 :   ffffffff817f8637:       mov    $0x6,%ecx
>     0.01 :   ffffffff817f863c:       movl   $0x110002,0x40(%rsp)
>     0.00 :   ffffffff817f8644:       lea    0x48(%rsp),%rdi
>    18.76 :   ffffffff817f8649:       rep stos %rax,%es:(%rdi)
>     1.12 :   ffffffff817f864c:       mov    0xc(%rsp),%eax
>     0.00 :   ffffffff817f8650:       mov    %ebp,0x48(%rsp)
>     0.00 :   ffffffff817f8654:       mov    %eax,0x44(%rsp)
>     0.00 :   ffffffff817f8658:       movzwl 0x10(%rsp),%eax
>     1.21 :   ffffffff817f865d:       mov    %ax,0x60(%rsp)
>     0.00 :   ffffffff817f8662:       movzwl 0x20(%rsp),%eax
>     0.00 :   ffffffff817f8667:       mov    %ax,0x62(%rsp)
>          :                      .sport          = sport,
>          :                      .dport          = dport,
>          :                      };

Such heavy hit to zero init 56-byte structure is surprising.
There are two 4-byte holes in this struct. You can try to pack it and
make sure that 'rep stoq' is used instead of 'rep stos' (8 byte at a time vs 4).

Long term we should probably stop doing *_kern style of ctx passing
into bpf progs.
We have BTF, CO-RE and freplace now. This old style of memset *_kern and manual
ctx conversion has performance implications and annoying copy-paste of ctx
conversion routines.
For this particular case instead of introducing udp4_lookup_run_bpf()
and copying registers into stack we could have used freplace of
udp4_lib_lookup2.
More verifier work needed, of course.
My main point that existing approach "lets prep args for bpf prog to
run" that is used
pretty much in every bpf hook is no longer necessary.
