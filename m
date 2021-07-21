Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEDE3D195E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhGUVFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 17:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhGUVFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 17:05:19 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A63FC061575;
        Wed, 21 Jul 2021 14:45:54 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id i18so5263100yba.13;
        Wed, 21 Jul 2021 14:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ewxhe9y6zg8nseS9oPR72pbHVzU7RY2gNLP01JypPQI=;
        b=IpK5CVT8ixclg3F7w0aN2H1KbagZ0kgcQdWAxkiW20vt4/yNQ/V+4+uILc7UYzD5A7
         7zvhThTy9UCZkqgNabIfsrYrGvhvPBxbp0rIy8FNOdYbMdwDvU5Rx+Dclk0tq59F0464
         PV1RsMiNla0v4YMEI3mRrtMfnzmdtQkzqkO9V7jRux2mvOfYby8OaM4aVRZNrFp5peon
         BNgYMKIaoRhqqMXcbhnJj2YRfaIx2FmzuqzUPAAHB3NZNLJ6AKjyDGVrA4HH4Ht8CjQw
         WT04NSoR6J7nv0oUs5aKUqFNbiE2CbkyQ08X04KQNlQyhqOMn3bAfHQQKd/0hZUoeCzI
         LpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ewxhe9y6zg8nseS9oPR72pbHVzU7RY2gNLP01JypPQI=;
        b=BQECWsun0SB4RC2t2lgSj3aYl5hXFJJy/gjSlLa5vfrY71uw6CvXfpC1D85MF59e0u
         zrWzGvtEIiGL6jS57e7r7QVPJQ6qA5h1ovkZmgG29mJkJAs55qd0NLzO1DKaR7fCO3IP
         l+IYNBTy9dVdRMgMUQ3p5pNET5ypiL1HNpSqfkIWjEv90ScMpeliT05TEHcEkdageP4n
         zNivRJrxVBz+qZAGcjkcLk3aXIy7kx8eUhsDh/kExyBlIoR6P5/0Oq5pdOJhX8sKDrfx
         x8+qQjZ8ZZcSJOGSDb9jdCYurUEcI3yyFkDwOJaVJsalPoswzygy5eZfnem+wCoEgAPC
         yJ0A==
X-Gm-Message-State: AOAM532tpMSbo4FMNhisYAvDECVMWjeyNrZz0idblGMafKZ0T2NN93V8
        7TImsKd9wVM3Ur5JETGN15AJzxT6ldIB2Q0jlxo=
X-Google-Smtp-Source: ABdhPJzcksmfd3+9Uv5UZrxjxWZ9b2lOCdWQQM/swpTRGd1Y36WP8U1h33Y9HvQr2NQpgBLJW7/NkTGnIQFXHxH7Bls=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr9727865ybf.425.1626903953596;
 Wed, 21 Jul 2021 14:45:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210721212007.3876595-1-arnd@kernel.org>
In-Reply-To: <20210721212007.3876595-1-arnd@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Jul 2021 14:45:42 -0700
Message-ID: <CAEf4BzavhrBKZHKpZctJt=K=8A0f77qr_W0OdPjqCNgDshjFog@mail.gmail.com>
Subject: Re: [PATCH net-next] bpf: fix pointer cast warning
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Alan Maguire <alan.maguire@oracle.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 2:20 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> kp->addr is a pointer, so it cannot be cast directly to a 'u64'
> when it gets interpreted as an integer value:
>
> kernel/trace/bpf_trace.c: In function '____bpf_get_func_ip_kprobe':
> kernel/trace/bpf_trace.c:968:21: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>   968 |         return kp ? (u64) kp->addr : 0;
>
> Use the uintptr_t type instead.
>
> Fixes: 9ffd9f3ff719 ("bpf: Add bpf_get_func_ip helper for kprobe programs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

I'll take this through the bpf-next tree, if no one objects. Thanks for the fix!


>  kernel/trace/bpf_trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 0de09f068697..a428d1ef0085 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -965,7 +965,7 @@ BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
>  {
>         struct kprobe *kp = kprobe_running();
>
> -       return kp ? (u64) kp->addr : 0;
> +       return kp ? (uintptr_t)kp->addr : 0;
>  }
>
>  static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> --
> 2.29.2
>
