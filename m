Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096B349AE28
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 09:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379147AbiAYIgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450731AbiAYIdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:33:23 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A4DC061290;
        Mon, 24 Jan 2022 23:04:41 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id o10so16085994ilh.0;
        Mon, 24 Jan 2022 23:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4mNtJKL4HQgQkY9btV767Gf4EXhzAnjyYSo6Uxupisw=;
        b=SetAMpByN6ia20pJuSAz+LUw5IBghr4Jb4MdiFqfsA4NjQieFHyr++NRMGUPXfLSd3
         CWzH6n3PbWYg/JgOTH1WdtIe3rYUxJf0+MLntbTsAvEFPql+hqSpt3ADIwBK/cvnrrKk
         Sk/ltgwdACLMeUjW8A4UNEL/5l4z7TgDIWsOQpbf2jeizXFWPEFe0Cf128RE9lTMz6cG
         J9dlN/uezqLuah9kGK9VkIubGhOn4ZaxWMyFrGVk5QJv2V9zdu93Q9pS5p/zKbgGpKF8
         MJ2gagpzI8WIJqmAOgRxabikx0IgvVwAJ8SlBTbEH22gvh+jBRaWfa9rF/nlvC2f01fs
         vnBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4mNtJKL4HQgQkY9btV767Gf4EXhzAnjyYSo6Uxupisw=;
        b=Rg60obq8KRb61kRx9AQ4IKsChDety2EWQa+pz70UClm5OztC8xBHDMcpg6NkNsVx/P
         MIx2C1AT6jH5L67+iPJ9zP6+7R0AKUfkxfXglpH5MhOudBQYjliT/d0agJQ0dPk+d16Y
         1xJJoEwZeyOaE9R6pI+pm7lLRfehg/SlornfPtWj9zecyqaKSBIqpYLBm5ffAm+n3XHD
         yU5KuLM0c9cLcwLyAp6LWRR7HePzRp+i777UvBZcJ+DKsHFenI9Fo8Hu5DNu86i4Nf2D
         LGXduD8I+Nig1eUnRXU93gbry5uMAQUXbF9SaFkSWt422ynll42Yh5HWKm8vP3H8NtYI
         7ZMQ==
X-Gm-Message-State: AOAM533WwKZUkS+eQllQUb0aFdOCqTbVr1Aw40Xbs9nxqThsvdKMJlTc
        L4e2ZuStYmTLEmfWZST+pbc=
X-Google-Smtp-Source: ABdhPJzEhNiX4C4ZHSGIxQeH4w9KUxwUEieWmGB615JFoANsY7YXEdWYh3xNztnD3RydwYaQxumY+A==
X-Received: by 2002:a05:6e02:927:: with SMTP id o7mr9936105ilt.43.1643094280888;
        Mon, 24 Jan 2022 23:04:40 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id x1sm8503952ilv.30.2022.01.24.23.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 23:04:40 -0800 (PST)
Date:   Mon, 24 Jan 2022 23:04:35 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <61efa1032e925_274ca208fb@john.notmuch>
In-Reply-To: <20220124151146.376446-3-maximmi@nvidia.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
 <20220124151146.376446-3-maximmi@nvidia.com>
Subject: RE: [PATCH bpf v2 2/4] bpf: Support dual-stack sockets in
 bpf_tcp_check_syncookie
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
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

These programs are all CAP_NET_ADMIN I believe so not so sure this is
critical from a BPF program might trick the helper, but consistency
is nice.

> 
> 2. Dual-stack sockets fail the checks on IPv4 packets. IPv4 clients end
>    up receiving a SYNACK with the cookie, but the following ACK gets
>    dropped.

Agree we need to fix this. Also would be nice to add a test to capture
this case so we don't break it again later. Its a bit subtle so might
not be caught right away without a selftest.

> 
> This patch fixes these issues by changing the checks in
> bpf_tcp_check_syncookie to match the ones in bpf_tcp_gen_syncookie. IP
> version from the header is taken into account, and it is validated
> properly with address family.

Code looks good, would be nice to have a test.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> 
> Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/core/filter.c | 17 +++++++++++++----
