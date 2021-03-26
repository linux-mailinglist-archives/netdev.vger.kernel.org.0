Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0988C34AE83
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhCZSYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhCZSYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 14:24:16 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC01C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:24:16 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l4so9778864ejc.10
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ijEhq4Lsy6lZulMLyXOkj6CpCY9gUCZEiMVSmUPQK3c=;
        b=fBF4aZahwaDxaRR/KrANbG1tRos+kbATFt+5sRrDgFATGS389twh2bZrdckIDL5KlX
         pDhHMntlrjlSCyUJds7MaIzm8ORM8HUwGmrnWuq1rwC2IzBMfYoVl6Iq5MIGjBHxqYBW
         jYXVXTjndDn+3O7wLc0Fiy368aFZ/L6hYgaB2/poxmzn7HO+sdTImDY2xqewC2XydnJq
         FMM5V18GeiiTBmy9WEx+L0fxJgeqMf7wDfIHbY+K7JB+qbkWX9AYuKPYWx/bKHabnePT
         nWsdWPxjaPLJmnS18QvoyKoUJk+FXGRbNVyAEEYWObF36vgi4DkByEk/EFFmEG22aLQD
         knYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ijEhq4Lsy6lZulMLyXOkj6CpCY9gUCZEiMVSmUPQK3c=;
        b=HVuCPpwql5kWL45ZWJIX9wxgkXLImT145exr3cS1I2UG9qCZIpTi4tPqkAJYdQeTzN
         8+dzX81DJYuBjIUK9/m8RB/5Urbjl0clhPIhzB8XTBFzHXeHHoH0BMOQjTQMhPslW4Yz
         G1QYsHaaeFTDIBUlgXucH7H/glttu+FvayHDQb7D9ZbLV0Sv42fk//auiV8KyQTF6Lrw
         vYkKpf+BMEov/bD3VMKfEiHMhMKuJma1CZdsqTMfeJdBktdQVkcMePgaO5VECmUKQVqL
         BOwV7gFI8mLQ/zMGZo/pk1JEDJSJTlG1lN/D5D7yEkg/euA9OqXwF/JgxaBx5NMPQvHJ
         vKfQ==
X-Gm-Message-State: AOAM532UkgNqd+VXN3OxuK/cW5yK5WW6lgSIZBo3s8phUwNsG+HZK6m1
        LQS8ggETztiTjZhgmuUgRVZCcxIo6CE=
X-Google-Smtp-Source: ABdhPJzmQdfUhy/kTDWU9swDAnD91AL2xYPXlPoZISW7rBa6BF9m/KeQeOu4tEbGy0lyDspQ0bjnpQ==
X-Received: by 2002:a17:906:a3d1:: with SMTP id ca17mr16912179ejb.92.1616783054510;
        Fri, 26 Mar 2021 11:24:14 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id jv19sm4193219ejc.74.2021.03.26.11.24.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 11:24:13 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id b9so6515670wrt.8
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:24:13 -0700 (PDT)
X-Received: by 2002:adf:ee92:: with SMTP id b18mr15343724wro.275.1616783053337;
 Fri, 26 Mar 2021 11:24:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616692794.git.pabeni@redhat.com> <400ebbc750178183155a9419cd5c3d32f53abcef.1616692794.git.pabeni@redhat.com>
In-Reply-To: <400ebbc750178183155a9419cd5c3d32f53abcef.1616692794.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 26 Mar 2021 14:23:35 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfZnmz7pWQxOtnAEj9Dq1SQiTvpUoz8ySj_Tagmh6HtAQ@mail.gmail.com>
Message-ID: <CA+FuTSfZnmz7pWQxOtnAEj9Dq1SQiTvpUoz8ySj_Tagmh6HtAQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/8] udp: skip L4 aggregation for UDP tunnel packets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 1:24 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> If NETIF_F_GRO_FRAGLIST or NETIF_F_GRO_UDP_FWD are enabled, and there
> are UDP tunnels available in the system, udp_gro_receive() could end-up
> doing L4 aggregation (either SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST) at
> the outer UDP tunnel level for packets effectively carrying and UDP
> tunnel header.
>
> That could cause inner protocol corruption. If e.g. the relevant
> packets carry a vxlan header, different vxlan ids will be ignored/
> aggregated to the same GSO packet. Inner headers will be ignored, too,
> so that e.g. TCP over vxlan push packets will be held in the GRO
> engine till the next flush, etc.
>
> Just skip the SKB_GSO_UDP_L4 and SKB_GSO_FRAGLIST code path if the
> current packet could land in a UDP tunnel, and let udp_gro_receive()
> do GRO via udp_sk(sk)->gro_receive.
>
> The check implemented in this patch is broader than what is strictly
> needed, as the existing UDP tunnel could be e.g. configured on top of
> a different device: we could end-up skipping GRO at-all for some packets.
>
> Anyhow, the latter is a very thin corner case and covering it would add
> quite a bit of complexity.
>
> v1 -> v2:
>  - hopefully clarify the commit message
>
> Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> Fixes: 36707061d6ba ("udp: allow forwarding of plain (non-fraglisted) UDP GRO packets")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

Key is that udp tunnel GRO must take precedence over transport GRO,
but the way the code is structured, the latter is tried first.
