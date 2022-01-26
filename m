Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5121049C6DF
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbiAZJtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiAZJtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 04:49:55 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81BFC061744
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 01:49:54 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id t14so19077201ljh.8
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 01:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nsYmZZVmVWqgaLKAmBGCRvkPtBIIUYO7KDL76PCx8zY=;
        b=fjELwJfGvWtFkfklukvBIQ3ks4Y3vrDw0wHWgLA2ad2D9t8u16gxYhTo7fwIf8HMQv
         Z1WUIDnxts7VKzpvVkSFz5K3O9k6r128BRXxycL9ra4As8+tYjW2Qxkpvi3N3U/Q2QzC
         z5H4++UeDhnbAjqraFN2gvcI+1wp9f7NEGeoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nsYmZZVmVWqgaLKAmBGCRvkPtBIIUYO7KDL76PCx8zY=;
        b=DfT627P2zVwmBzJaascVkyaEDTCp8MNc6iRO6V5E8TyTFXW0dheg/dCV0UgewVno74
         mWs5PP7FjaMdn79TgNLuXmbCYO17M1espJV+JDefaxwFwOZmxhBGDfLP1FPwaPj6u9uG
         Qu1dnbIvjE9r6UbDCl4pFehKmwozqQSu7pZV6C7mZIozPHW8ELS7uyMlkK3LAME7wu3C
         YjLg+aTk9GZS0f1BE5YcUyqgDrCQa+KYfn5onpkWyLYZziciTBuo421+ResBa76QoZhy
         4bPfdB9Z216ipSoijWXK9ici3oX4Z+lq0Xit1A1cDubHxv4Hg3jByahTlGCrCNIg1KTJ
         jWaw==
X-Gm-Message-State: AOAM530ULwz8GJ57kibYbsqcxDwrweknI2YrjT0pfssIS+/D9/3DinXd
        Q1DG24q8TpvP5Ftlo2o/m1jfAfty+e8jg3m/VuuF8Q==
X-Google-Smtp-Source: ABdhPJxYlr85SblyBnozf1GKr6NTo2JW/LSIixbq1P1TK1EWw8J1poyqjpZITrAU14nn+s+iNIthF8KizZRPvvdKRVI=
X-Received: by 2002:a2e:9e0a:: with SMTP id e10mr17200025ljk.121.1643190592988;
 Wed, 26 Jan 2022 01:49:52 -0800 (PST)
MIME-Version: 1.0
References: <20220124151146.376446-1-maximmi@nvidia.com> <20220124151146.376446-3-maximmi@nvidia.com>
In-Reply-To: <20220124151146.376446-3-maximmi@nvidia.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 26 Jan 2022 09:49:42 +0000
Message-ID: <CACAyw9_mA-yBWbU6Sf8hq6P46PfiTpEZYTGSKmNG6ZiFWGz=ZQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/4] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 at 15:13, Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> bpf_tcp_gen_syncookie looks at the IP version in the IP header and
> validates the address family of the socket. It supports IPv4 packets in
> AF_INET6 dual-stack sockets.
>
> On the other hand, bpf_tcp_check_syncookie looks only at the address
> family of the socket, ignoring the real IP version in headers, and
> validates only the packet size. This implementation has some drawbacks:
>
> 1. Packets are not validated properly, allowing a BPF program to trick
>    bpf_tcp_check_syncookie into handling an IPv6 packet on an IPv4
>    socket.
>
> 2. Dual-stack sockets fail the checks on IPv4 packets. IPv4 clients end
>    up receiving a SYNACK with the cookie, but the following ACK gets
>    dropped.
>
> This patch fixes these issues by changing the checks in
> bpf_tcp_check_syncookie to match the ones in bpf_tcp_gen_syncookie. IP
> version from the header is taken into account, and it is validated
> properly with address family.
>
> Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/core/filter.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 05efa691b796..780e635fb52a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6774,24 +6774,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
>         if (!th->ack || th->rst || th->syn)
>                 return -ENOENT;
>
> +       if (unlikely(iph_len < sizeof(struct iphdr)))
> +               return -EINVAL;
> +
>         if (tcp_synq_no_recent_overflow(sk))
>                 return -ENOENT;
>
>         cookie = ntohl(th->ack_seq) - 1;
>
> -       switch (sk->sk_family) {
> -       case AF_INET:
> -               if (unlikely(iph_len < sizeof(struct iphdr)))
> +       /* Both struct iphdr and struct ipv6hdr have the version field at the
> +        * same offset so we can cast to the shorter header (struct iphdr).
> +        */
> +       switch (((struct iphdr *)iph)->version) {
> +       case 4:
> +               if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
>                         return -EINVAL;

Wouldn't this allow an arbitrary value for sk->sk_family, since there
is no further check that sk_family is AF_INET?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
