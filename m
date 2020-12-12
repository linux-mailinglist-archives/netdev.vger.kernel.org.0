Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD442D84E5
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 06:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438350AbgLLFgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 00:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436603AbgLLFgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 00:36:47 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0E6C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 21:36:07 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id t13so10024439ybq.7
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 21:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MJLJtxzOI6HFbFfca8y6i5ZlIt+NBylvopbSMbbFYTM=;
        b=BXytWfgxuevSZCxtU68g4ESmu7e0gpHPtBvQeU08cyNlYW1SKXvKMbz7d5hkT/mlEQ
         1pUPWjqOMtckgVDRiI7/L8vba5zZBGG1OYEBJwr38Hh1+Y2f8JDt7IcBPVn7MhDTyTUG
         Qb61RKN7BYmnSmmNTYUdIea/VQB56NSXDrUr/Ms2NJnnfJ1ZG0EZYx8MjlnrVSGVhOaF
         FrfTc5oPZ6athCvRoSXO35rZoQjoQmGfB6kOF5fkscoy6siZItiW3obTK/eN3Ffo6bvL
         pnKABUbdZzmZ5mEHSMwC9qIrzi4HPFdHXY+EKcGwQa56ESNzdEmhqYIPrzSoSreQvhmW
         nFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MJLJtxzOI6HFbFfca8y6i5ZlIt+NBylvopbSMbbFYTM=;
        b=n5ZXnOGc1YkJD8hcIlcM8vtuPKUuQqajY4OQud/6FrXR7ooKii1mFqnnj0LoPK5kcn
         +Yaqwz4vcD5KCDYgfvuLnCaOgS7eX9/Mgf61MRWpjoLZd3ShGd7wireDE9H3+TcMreQd
         1Noyn3NtpMruFsT76SNIeMvq+fhFHlpuBDmF4pzGCX+bOpzTAmeZSId2Y3hl56c9Gbam
         UZEoQLHqOEHWHU4APYGXda0RLmqkz3vS6OqZttYFWxGlduSuJo0qyvtydSnhXy2SAyel
         oQy7JGO83Wym0kXvtPcgBQruiB0YgHZ8/00foAyFbADfjkG2/H/Jds1eDG6DjzSGifP6
         ER1g==
X-Gm-Message-State: AOAM532Vidz2luYOzAjY0d7xLRnyJjOXW1RAF5RGncn8xOLlcOF3xqSA
        7QkQvhqFrjP1oatSvx0wAK3yftJ3gqEOoBrxC9o=
X-Google-Smtp-Source: ABdhPJwWygwpSjBLwDq268/9vv+mZHcYLwmEewEigYO3dd7B/FUbrrWzQMSpZPrDpyv07vZLIsK+5MDlT7EqeSSE90s=
X-Received: by 2002:a25:2046:: with SMTP id g67mr23088189ybg.199.1607751367082;
 Fri, 11 Dec 2020 21:36:07 -0800 (PST)
MIME-Version: 1.0
References: <20201211122612.869225-1-jonas@norrbonn.se> <20201211122612.869225-8-jonas@norrbonn.se>
In-Reply-To: <20201211122612.869225-8-jonas@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Fri, 11 Dec 2020 21:35:56 -0800
Message-ID: <CAOrHB_CzXgf9mOr+LhSOKcJ1uzTQBqMmWiDCMkutCF7VRJ9Djg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 07/12] gtp: use ephemeral source port
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, laforge@gnumonks.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 4:29 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> All GTP traffic is currently sent from the same source port.  This makes
> everything look like one big flow which is difficult to balance across
> network resources.
>
> From 3GPP TS 29.281:
> "...the UDP Source Port or the Flow Label field... should be set dynamically
> by the sending GTP-U entity to help balancing the load in the transport
> network."
>
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> ---
>  drivers/net/gtp.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index 4a3a52970856..236ebbcb37bf 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -477,7 +477,7 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>         __be32 saddr;
>         struct iphdr *iph;
>         int headroom;
> -       __be16 port;
> +       __be16 sport, port;
>         int r;
>
>         /* Read the IP destination address and resolve the PDP context.
> @@ -527,6 +527,10 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>                 return -EMSGSIZE;
>         }
>
> +       sport = udp_flow_src_port(sock_net(pctx->sk), skb,
> +                       0, USHRT_MAX,
> +                       true);
> +
why use_eth is true for this is L3 GTP devices, Am missing something?

>         /* Ensure there is sufficient headroom. */
>         r = skb_cow_head(skb, headroom);
>         if (unlikely(r))
> @@ -545,7 +549,7 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>                             iph->tos,
>                             ip4_dst_hoplimit(&rt->dst),
>                             0,
> -                           port, port,
> +                           sport, port,
>                             !net_eq(sock_net(pctx->sk),
>                                     dev_net(pctx->dev)),
>                             false);
> --
> 2.27.0
>
