Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B91C514102
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 05:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbiD2DTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 23:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbiD2DSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 23:18:48 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C04622BDE;
        Thu, 28 Apr 2022 20:15:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so6143996pjf.3;
        Thu, 28 Apr 2022 20:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w4oIavX7ybBIKhipbmSb7D/VaFUzTRWKgHI15fCRjo8=;
        b=O5QeWgujlX+we6uhRnxkXUrsCKJBY9CxWyUVVj70cg5tfVHqt5i9e4gHCGhUpE0KqN
         6PRojHhRouAfFQVpGn6te1rUNhw11+oH4Itc1DfSoBPec8XuQR86l7FBzzMT8cibcO5F
         lYTSEoMfISYWLRvMYhd8Nka3G6so4vEJ3X5HZ3b/a4xM2qVdFqcz9eVcV+W+h3kRJVz7
         2t4B4ICJzkQJPwbaO/TxnwtACxhEt62nCmn4o2JvD0DpsaRgaGybkTpHW8W4sa+u+BJr
         We2E9J5lBwHzzS/KoUInriJVFZCu1qDoSOarnL0tu+gCB5ajeIcarzW3bLJ0BcNSlB6P
         QzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w4oIavX7ybBIKhipbmSb7D/VaFUzTRWKgHI15fCRjo8=;
        b=tOnNUexhelKqrvtc5jMQ02Lc2BUpVm01j328WE31xUA6R8bQ4PBuH7A7Tm9YvUnDFX
         hXcENBeTErRHR9u3R0SQsm9aSGuaqxwtjUqOYrErGreE8eIw0s5+tlOnEj7Y6aTMgM3q
         18LY04fWO7HT1bHFhukxDN3pYM0GUyh+2gSweGKXHU5ijqljjb9Z4F9zF3Zg0AL6SdQV
         CDhv6rfgTedq6+agDTe54ACfEfqoIXCZ5wy6TeUzuFESnNtbqkGMdeJB3TiJ1CMOZDJR
         Au1fFcnMMylo0WgzRGwC9EkOhkT3NeS40PxdvS7Om318mbv+wklHqaTQqVw+1+PHwenB
         aRaQ==
X-Gm-Message-State: AOAM532pQkprB7us/C2zuKmkeo09j2Tlx99IWPRvK3LmA+gSONCaMpvX
        KpWEKMEXYc5i6eOkcZXNBJAtOSrA0QpGOCtulCc=
X-Google-Smtp-Source: ABdhPJxG/xaKCZURmF4dAlabbfKM+wIVNo1eURmLe/0QdioFyB0liCAJ8fbG1DZTQCB3JZxNGnl6D4y/kLLM5Lgmcxo=
X-Received: by 2002:a17:902:b189:b0:14d:6f87:7c25 with SMTP id
 s9-20020a170902b18900b0014d6f877c25mr36997314plr.31.1651202128854; Thu, 28
 Apr 2022 20:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220428153833.278064-1-maximmi@nvidia.com> <20220428153833.278064-2-maximmi@nvidia.com>
In-Reply-To: <20220428153833.278064-2-maximmi@nvidia.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 28 Apr 2022 20:15:17 -0700
Message-ID: <CAADnVQLw4yz_N3xR59XbSGdCH3ckU-pPWZ93JugomGejfo5hTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 1/6] bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 8:38 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> Instead of querying the sk_ipv6only field directly, use the dedicated
> ipv6_only_sock helper.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: Petar Penkov <ppenkov@google.com>
> ---
>  net/core/filter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 8847316ee20e..207a13db5c80 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7099,7 +7099,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
>          */
>         switch (((struct iphdr *)iph)->version) {
>         case 4:
> -               if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
> +               if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
>                         return -EINVAL;

Please rebase patches before resending.

Applying: bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
Using index info to reconstruct a base tree...
M    net/core/filter.c
Falling back to patching base and 3-way merge...
Auto-merging net/core/filter.c
No changes -- Patch already applied.
Applying: bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Applying: bpf: Allow helpers to accept pointers with a fixed size
Applying: bpf: Add helpers to issue and check SYN cookies in XDP
error: sha1 information is lacking or useless (include/uapi/linux/bpf.h).
error: could not build fake ancestor
Patch failed at 0004 bpf: Add helpers to issue and check SYN cookies in XDP


Also trim your cc. You keep sending to addresses that are bouncing
(Lorenz's and Petar's).

Remove their Ack-s too or fix them with correct emails.
