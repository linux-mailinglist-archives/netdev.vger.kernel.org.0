Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9376C26652B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIKQyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgIKPFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:05:50 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DCEC061370
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:32:39 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id x142so2440946vke.0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NQAm+3y6fCAECF7HBt/KX1e0yG8P1XL6nlxfCnayxHg=;
        b=MK9zQOSXSiWzoI1iCGLugJPqcjKnzVnthtw31ehkWRU8wuFXliRGbnEYo7rng19WYk
         zRH0kxyo+E03zOxAH65S2s6LgeOLL+LhOXPxPlkxFEW7n9Iei6P3gnCB15/LRjTzVPvk
         tQNlg4d6pvUxQYKe08T/4jf/TLzlkPkTWs1/CxSuHA3InGQZlQhgD2ZcBHytKP5UyzEW
         JYeT0jWAOsSl4CRBXKwXi061nO5L/c2UOhNR0YgEPvNFvr2fHMZRnLs3ltOKp27XIlyt
         dYKnaSq4ZdeRkolzLQsIEKTsjx7NAxSGXpnUGYJXg/JtW1tAUYyMX6Bi3f/Wz34zR3f/
         iHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NQAm+3y6fCAECF7HBt/KX1e0yG8P1XL6nlxfCnayxHg=;
        b=rAr/Ftd1h4kmVzJ6n7kdqt+Tnek4f6bC+807ez3eUdmgXRBXUQeSmu1++ilAKRRP5J
         L23J4jxgNxfizVSzbxShttxt62ix0mRh7/zcjOI39sgdxOU8sc+Iss6RcZdIg0c+Ldb/
         inKUS7j0jE8PUK5ac3Q2W7JkbBfXv60A1WrSVbMQxbrssInpQbpuaSkyJLFXgSCVh2Cq
         +89k9YRNFTREWPXoQJplJmk5lmwDrLOP72BUiIztBZ00VGKKB9HP325PNHu2qTINDzU+
         KalDnpNBLTgLoyCV1vWt74YJzVz9CuYZ8dzwz56GRnMEv2gD0vPKLbhKo3ZlHXazoZ1Z
         g/aw==
X-Gm-Message-State: AOAM530JZPDtVOKwEp1QJdflBkkItEQMngDi45gXGyBNKcIq97Le8FxX
        y5eYWZFZnmVJE6pRWBS4j07g//Zcf1mZ1w==
X-Google-Smtp-Source: ABdhPJwCLQdn0glx0QrD2D4VsVCLiux/Li3MfWRPvP64zQFp5hOFY7KiKznMD+u0D6yUUrvvq+gNIw==
X-Received: by 2002:a1f:4357:: with SMTP id q84mr1166983vka.4.1599834752941;
        Fri, 11 Sep 2020 07:32:32 -0700 (PDT)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id j24sm331836uap.3.2020.09.11.07.32.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 07:32:31 -0700 (PDT)
Received: by mail-ua1-f50.google.com with SMTP id u14so3162103uaq.1
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:32:31 -0700 (PDT)
X-Received: by 2002:ab0:60d7:: with SMTP id g23mr1198133uam.122.1599834751042;
 Fri, 11 Sep 2020 07:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200911050359.25042-1-xie.he.0141@gmail.com>
In-Reply-To: <20200911050359.25042-1-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 11 Sep 2020 16:31:54 +0200
X-Gmail-Original-Message-ID: <CA+FuTSeOUKJYOFamA+fKBxEb22VosOXZRWGf2DungBGRorcyfg@mail.gmail.com>
Message-ID: <CA+FuTSeOUKJYOFamA+fKBxEb22VosOXZRWGf2DungBGRorcyfg@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Fix a comment about hard_header_len
 and add a warning for it
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 7:04 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> This patch tries to clarify the difference between hard_header_len and
> needed_headroom by fixing an outdated comment and adding a WARN_ON_ONCE
> warning for hard_header_len.
>
> The difference between hard_header_len and needed_headroom as understood
> by this patch is based on the following reasons:
>
> 1.
>
> In af_packet.c, the function packet_snd first reserves a headroom of
> length (dev->hard_header_len + dev->needed_headroom).
> Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
> which calls dev->header_ops->create, to create the link layer header.
> If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
> length (dev->hard_header_len), and checks if the user has provided a
> header sized between (dev->min_header_len) and (dev->hard_header_len)
> (in dev_validate_header).
> This shows the developers of af_packet.c expect hard_header_len to
> be consistent with header_ops.
>
> 2.
>
> In af_packet.c, the function packet_sendmsg_spkt has a FIXME comment.
> That comment states that prepending an LL header internally in a driver
> is considered a bug. I believe this bug can be fixed by setting
> hard_header_len to 0, making the internal header completely invisible
> to af_packet.c (and requesting the headroom in needed_headroom instead).
>
> 3.
>
> There is a commit for a WiFi driver:
> commit 9454f7a895b8 ("mwifiex: set needed_headroom, not hard_header_len")
> According to the discussion about it at:
>   https://patchwork.kernel.org/patch/11407493/
> The author tried to set the WiFi driver's hard_header_len to the Ethernet
> header length, and request additional header space internally needed by
> setting needed_headroom.
> This means this usage is already adopted by driver developers.
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Brian Norris <briannorris@chromium.org>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  net/packet/af_packet.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index af6c93ed9fa0..93c89d3b2511 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -93,12 +93,15 @@
>
>  /*
>     Assumptions:
> -   - if device has no dev->hard_header routine, it adds and removes ll header
> -     inside itself. In this case ll header is invisible outside of device,
> -     but higher levels still should reserve dev->hard_header_len.
> -     Some devices are enough clever to reallocate skb, when header
> -     will not fit to reserved space (tunnel), another ones are silly
> -     (PPP).
> +   - If the device has no dev->header_ops, there is no LL header visible
> +     above the device. In this case, its hard_header_len should be 0.
> +     The device may prepend its own header internally. In this case, its
> +     needed_headroom should be set to the space needed for it to add its
> +     internal header.
> +     For example, a WiFi driver pretending to be an Ethernet driver should
> +     set its hard_header_len to be the Ethernet header length, and set its
> +     needed_headroom to be (the real WiFi header length - the fake Ethernet
> +     header length).
>     - packet socket receives packets with pulled ll header,
>       so that SOCK_RAW should push it back.
>
> @@ -2936,6 +2939,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>         skb_reset_network_header(skb);
>
>         err = -EINVAL;
> +       if (!dev->header_ops)
> +               WARN_ON_ONCE(dev->hard_header_len != 0);
>         if (sock->type == SOCK_DGRAM) {
>                 offset = dev_hard_header(skb, dev, ntohs(proto), addr, NULL, len);
>                 if (unlikely(offset < 0))

From a quick scan, a few device types that might trigger this

net/atm/clip.c
drivers/net/wan/hdlc_fr.c
drivers/net/appletalk/ipddp.c
drivers/net/ppp/ppp_generic.c
drivers/net/net_failover.c
