Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93D935D111
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245378AbhDLT3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236717AbhDLT3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:29:12 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D013C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:28:54 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id g5so15467381ejx.0
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=99PE2RIpahpSQznMSl/Z2TmR52GsA2VN16z6J7i9OiY=;
        b=ZPNpciggEi1jwQl2XiT8gtshmjBSdwfPBe5bgqJjFTQr+UrqnZbB1917WEpL0uQG6R
         QTjin3FI0lpvOHGnlI0T9hvllby7QDW1kGKNodE7g0hx7qA360/IcCWLLSrsCow3IJmr
         XILvUwzewXZaB5oX/DNumbeNLSnB72KXm5HynXQd2DLZv4FZUTOjfD+qabCSK66x9rVk
         WyZuXtB5EVS6QDENeIdNrnPbPIii486C951/A84m21s4jrr5JohPT/DKDuOuBX8qVxJc
         4LcSx3CFkMczNjEoju0pince04PdidvUitwXDEsgrSOQcCEc4CuPIjiVPXdmm91LuZvL
         BPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=99PE2RIpahpSQznMSl/Z2TmR52GsA2VN16z6J7i9OiY=;
        b=Jh+NO/8R+zEIWlO80qz3QfA8W4UKTl8Af1Azb1R7CN4Rugnh0UU9lAHDNrvuYjAQh3
         8KKFnDoK32Ys9XbkBkSo+cYlFVVJcdqEkhdRxurSAhkaYDLei+c608SM+FlRYi+OILTf
         wg0c+Zy0LvUMq4LPo0h+LpZL6DPQrgVXe6K2EFtjXVVG7fLd/P0eVRQxmX/nyDO9KKqQ
         1x7uC5jpSxPvqY4L4JsW7SgF63qLgyOrwjo9DBiYg2N8WXEg5MY/lBB+qiJc8mxMn75f
         KqcwsDDe0ITZtgiCz6GRmQFF8WIusSyhziAlEA5GXOIgpMoycR9K17nmkYFF6TrnXQtn
         3brA==
X-Gm-Message-State: AOAM531r9ZwwGae7oAJDif7YsadOonSOSSY8CohQxwf0jMIHQmhFUoUz
        4eEnddxOT6qvmYf7dPHC+sibEqtapKjprQ==
X-Google-Smtp-Source: ABdhPJzS/OCW3HxkE9/i0ldiPQDafVral0cqw2H7dn+3x+7BzrVOpNMnH5pF5yYJAFH1+eGOT3I3kg==
X-Received: by 2002:a17:906:3d62:: with SMTP id r2mr28145496ejf.488.1618255732455;
        Mon, 12 Apr 2021 12:28:52 -0700 (PDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id z4sm7286511edb.97.2021.04.12.12.28.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 12:28:51 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id a6so14103069wrw.8
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:28:50 -0700 (PDT)
X-Received: by 2002:adf:cc8d:: with SMTP id p13mr33618112wrj.50.1618255730180;
 Mon, 12 Apr 2021 12:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210412190845.4406-1-andreas.a.roeseler@gmail.com>
In-Reply-To: <20210412190845.4406-1-andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 12 Apr 2021 15:28:12 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdMpMm9nwFP2u7KDeNUfXXfmQBGMmPfE-MBJTrGs-8stA@mail.gmail.com>
Message-ID: <CA+FuTSdMpMm9nwFP2u7KDeNUfXXfmQBGMmPfE-MBJTrGs-8stA@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: pass RFC 8335 reply messages to ping_rcv
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 3:09 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> The current icmp_rcv function drops all unknown ICMP types, including
> ICMP_EXT_ECHOREPLY (type 43). In order to parse Extended Echo Reply messages, we have
> to pass these packets to the ping_rcv function, which does not do any
> other filtering and passes the packet to the designated socket.
>
> Pass incoming RFC 8335 ICMP Extended Echo Reply packets to the ping_rcv
> handler instead of discarding the packet.
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
>  net/ipv4/icmp.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 76990e13a2f9..8bd988fbcb31 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -1196,6 +1196,11 @@ int icmp_rcv(struct sk_buff *skb)
>                 goto success_check;
>         }
>
> +       if (icmph->type == ICMP_EXT_ECHOREPLY) {
> +               success = ping_rcv(skb);
> +               goto success_check;
> +       }
> +

Do you need the same for ICMPV6_EXT_ECHO_REPLY ?
