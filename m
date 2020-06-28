Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F126820CA72
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 22:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgF1UmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 16:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgF1UmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 16:42:02 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F226CC03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:42:01 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d27so11437026qtg.4
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GvcNsUBR22WO4W7DHcf/YnzoKovAz9TTEYXym4w/jsw=;
        b=NSXa4VAD9yfxU5zuOMIfsjE5SWQRaZYUp6VTxFZ1mr3jJLWRlzE4akZFVCN8uBEYSw
         /Ya9AIiPmw6Ka3hdm/lzpj1jmw8QGUeZFYin9x9tqz3w9Zf2awuGi0OpCCnC0+Vx0uXQ
         W4mI8PmIJhvKbs+aWXxyfPSn9pas+9xpRBWu4joTBpsFLdW5U9VC0apkigjLq3gH6cTg
         bfma1465I9TxVeeO+6xDMCWBpFdyQ0yrc4XiGs33+1yoqu9UYv0oRbhY8zYGi9dHaG2w
         eW+bSw/ZBukTVvp9dJPSevqmGhATKcLoSBvZaj3dTEctWTaFKQL6GBwvIFn9UxlIlgiC
         FHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GvcNsUBR22WO4W7DHcf/YnzoKovAz9TTEYXym4w/jsw=;
        b=nqEtEDloxckC/pQ6NeZEpgbQqOJMaI/qU5YXrXkf4mzngyldWYiT0fsr+4drakky3T
         O8agZnksc3Hmfsw+Z4lb3X4XpiZi1SWUzQlf9tZsrO64OUbs0ib1YgrN5nB9IrCJJUQJ
         lUwtTh0cMX/UgJOAiih7MXAmDZlo5zp4vuzuOS17GX3J0jRM082XYdaop+pjBgjUsdMX
         CG4XXzbfPK1Dj95sE9VxebUu15qhUeRlvPnQY6zDJIv0GgQtY3PcKMuSiiuvupMoTDuc
         Jq+ZSj64rBdcKO1Qu5jB94HNRSW+o2aoCoOxvWswY0Gvn1KGpYHBkx1K3bPqP9M+yXYY
         DQIA==
X-Gm-Message-State: AOAM531sh+8sczyh+LYB2Z5pZVU2dQWK5CKBpyyGGJQhJRwJuuOkPDlq
        iucFSTNhXmu9K3MM4hSrwMWpFgUq
X-Google-Smtp-Source: ABdhPJywl5GR90L+0aGCDZP+KGETfGFC1GXSsIJqsWjkl0sSiQbuaYdvek7gPElYezKjBLx0M4ZpZg==
X-Received: by 2002:ac8:5486:: with SMTP id h6mr12675199qtq.255.1593376920403;
        Sun, 28 Jun 2020 13:42:00 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id o66sm13986313qka.60.2020.06.28.13.41.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 13:41:59 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id j19so4421872ybj.1
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:41:59 -0700 (PDT)
X-Received: by 2002:a25:6885:: with SMTP id d127mr5895559ybc.165.1593376918443;
 Sun, 28 Jun 2020 13:41:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200627080713.179883-1-Jason@zx2c4.com> <20200627080713.179883-2-Jason@zx2c4.com>
In-Reply-To: <20200627080713.179883-2-Jason@zx2c4.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 28 Jun 2020 16:41:21 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdv6scBYK94igDTC8VtcgVj=QB3uyHUOJPnZjVhVg+pbg@mail.gmail.com>
Message-ID: <CA+FuTSdv6scBYK94igDTC8VtcgVj=QB3uyHUOJPnZjVhVg+pbg@mail.gmail.com>
Subject: Re: [PATCH net 1/5] net: ip_tunnel: add header_ops for layer 3 devices
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 4:07 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Some devices that take straight up layer 3 packets benefit from having a
> shared header_ops so that AF_PACKET sockets can inject packets that are
> recognized. This shared infrastructure will be used by other drivers
> that currently can't inject packets using AF_PACKET. It also exposes the
> parser function, as it is useful in standalone form too.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  include/net/ip_tunnels.h  |  3 +++
>  net/ipv4/ip_tunnel_core.c | 19 +++++++++++++++++++
>  2 files changed, 22 insertions(+)
>
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index 076e5d7db7d3..36025dea7612 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -290,6 +290,9 @@ int ip_tunnel_newlink(struct net_device *dev, struct nlattr *tb[],
>                       struct ip_tunnel_parm *p, __u32 fwmark);
>  void ip_tunnel_setup(struct net_device *dev, unsigned int net_id);
>
> +extern const struct header_ops ip_tunnel_header_ops;
> +__be16 ip_tunnel_parse_protocol(const struct sk_buff *skb);
> +
>  struct ip_tunnel_encap_ops {
>         size_t (*encap_hlen)(struct ip_tunnel_encap *e);
>         int (*build_header)(struct sk_buff *skb, struct ip_tunnel_encap *e,
> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> index 181b7a2a0247..07d958aa03f8 100644
> --- a/net/ipv4/ip_tunnel_core.c
> +++ b/net/ipv4/ip_tunnel_core.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
>   * Copyright (c) 2013 Nicira, Inc.
> + * Copyright (C) 2020 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
>   */

It's not customary to append these when touching existing files.
Though I'm not sure what the policy is.

>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -844,3 +845,21 @@ void ip_tunnel_unneed_metadata(void)
>         static_branch_dec(&ip_tunnel_metadata_cnt);
>  }
>  EXPORT_SYMBOL_GPL(ip_tunnel_unneed_metadata);
> +
> +/* Returns either the correct skb->protocol value, or 0 if invalid. */
> +__be16 ip_tunnel_parse_protocol(const struct sk_buff *skb)
> +{
> +       if (skb_network_header(skb) >= skb->head &&
> +           (skb_network_header(skb) + sizeof(struct iphdr)) <= skb_tail_pointer(skb) &&
> +           ip_hdr(skb)->version == 4)
> +               return htons(ETH_P_IP);
> +       if (skb_network_header(skb) >= skb->head &&
> +           (skb_network_header(skb) + sizeof(struct ipv6hdr)) <= skb_tail_pointer(skb) &&
> +           ipv6_hdr(skb)->version == 6)
> +               return htons(ETH_P_IPV6);
> +       return 0;

Perhaps worth stressing that this works in a closed environment that
only handles IP, but not for arbitrary L3 tunnel devices that may
accept a broader set of inner protocols.

Even the ipip device supports MPLS as of commit 1b69e7e6c4da ("ipip:
support MPLS over IPv4"). When injecting MPLS + IP over packet
sockets, a label could easily be misinterpreted. That said, such
processes should pass the protocol explicitly to avoid
misclassification.

Applied strictly to ipip, ip6ip6 this definitely improves packet
socket support for those, and is similar to what tun does:

                if (tun->flags & IFF_NO_PI) {
                        u8 ip_version = skb->len ? (skb->data[0] >> 4) : 0;

Sit is another candidate.



> +}
> +EXPORT_SYMBOL(ip_tunnel_parse_protocol);
> +
> +const struct header_ops ip_tunnel_header_ops = { .parse_protocol = ip_tunnel_parse_protocol };
> +EXPORT_SYMBOL(ip_tunnel_header_ops);
> --
> 2.27.0
>
