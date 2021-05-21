Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A3A38C953
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 16:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhEUOkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 10:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhEUOkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 10:40:15 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE31EC061574;
        Fri, 21 May 2021 07:38:51 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id e2so17903137ljk.4;
        Fri, 21 May 2021 07:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LnMbFnk6wz2n1JsVYFaQb0lyltiyPAnw+oRXrYpUg/g=;
        b=Rtj3ntl922b5w4Euk3yiJiVVDv/bytL2l0/oB1aZntdPBgNNflkrLRoxnHA7fomptw
         slhVpFMQRzoDwTUxe366YBcUZIR0MAn7Xa/o0VOKGYETbFbjvcNj+p73zeDuPhOMYmVO
         fpYWZJZfsIYEDbOpjSjOIAv8DeNY17xx6JLyUMNNzXdvDZoWULbXZQtkWRZSvKjN40p8
         55EQtMpPq9r/f+QqivBajM6TyyXINfd5q+xLL+zU0x3T64X3I87zNek6VFabA0O4/4zQ
         RcU/OAllej7N07ohyLx2o8DAcJwMNstqY4tap6E3YeKLeW+o7AY6zoNV6MuBzkLmZY3s
         QLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LnMbFnk6wz2n1JsVYFaQb0lyltiyPAnw+oRXrYpUg/g=;
        b=WYsgBkMk0q3A4eIjgACipIDa8DAcRtS1dE1YB9tGLaLONwGbspCoirXJVanoA6VtKG
         llNy+TQpbJ6tbcbU6Pr603WrphHuarjfwQ6fj+uCF+FLd8+xhq/Vb9khgVzhVUsoiBCT
         vyixfuzuUveyWfHpybH7d92zZ5nTsuSDfkWRVqzrRvmzOeZBzZNU5KklMefie5mDmdyQ
         DzCF0DbrcMi1SlZOfgDiB3OMtrPT2db0+tCCmerRsoLsXx/kiuR8CnOu4lUG2HRgCTPn
         gah6UA3H5ELqa6i8oLHioter5jAtXwreaTbUHDiLHDep+4j9lizd6S16mx9ojcR4aljH
         OoDQ==
X-Gm-Message-State: AOAM530sJdKVcfk+IRou1mKFxc5Mc2Ops0fkP7DpTtPuoQAUHHQ/0m30
        6LmaKJPCg+M+Du3JpPRQzJf02UpUlQR+O3dupTM=
X-Google-Smtp-Source: ABdhPJw8wDOiaQN/WFq+bG1KRUj1zEim4GTbY/xN/ViFC1LMugdFhVrbR6DznmNfdTB5tgXrq2/Z3HDbgrjkJE6y8qI=
X-Received: by 2002:a2e:5813:: with SMTP id m19mr7173417ljb.258.1621607929784;
 Fri, 21 May 2021 07:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 May 2021 07:38:38 -0700
Message-ID: <CAADnVQKmZC_c_y=m1yv4eaQJ6Pyqgju=K4+v=8eR4wAMSfqoMQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 11:55 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> and helpers to operate on it:
> long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> long bpf_timer_del(struct bpf_timer *timer)
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
> This is work in progress, but gives an idea on how API will look.

Forgot to mention the todo list:
- restrict to cap_bpf
- kfree bpf_timer_list
- verifier btf checks
- restrict to array, hash, lru, lpm. per-cpu maps cannot be supported.
- safe interaction with lookup/update/delete operations and iterator
- relax the 'first field only' requirement to allow bpf_timerr in global data.
  kinda without a map.
- check prog_rdonly, frozen, mmaped flags
- decide on a return value from the timer callback
- more tests
