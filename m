Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4887123A24E
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 11:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgHCJuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 05:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgHCJuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 05:50:06 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35934C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 02:50:06 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id m18so8249940vkk.7
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 02:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nr4dnyKxwgCj4faCNYTa9it70VJu2Juk1xNpqFu7M2o=;
        b=oiWYI691wRufMbjVH45ilNvUByiLz8qNtFs2AIAeFmFUDA9x5pTW/Sw6Ffj8KNaXh5
         suB48conFJPB3ZCxr8RrFqIiGefXryt25rGuRT7v/xnpcRWaMaW+TPu7i3lTwZGIEhlo
         ugOnnB9Q2vvc6RFvhXbmPcfH7gKUvPa0L1QTEz+fG1cnkUEa4RPriTbfw6qKFyBXXRr2
         yCSxlJ/tX6DRLTL0qqKz5yH1san1L1SSOp4FcXkBoP96m0ra1WRcAlpbTwx777ua1isd
         EC0xS626QI97KjWg4mhvq22f92sIiuuqSld4Oq8kDuIe45oeTye0iyyI6wtAapnAbSDz
         AZxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nr4dnyKxwgCj4faCNYTa9it70VJu2Juk1xNpqFu7M2o=;
        b=e2ik5ZCuiZkDt18i9bGID/AmgcfOGyqzcao98D5WvaDy210MdCHtH0oofgQ3EPmuw3
         cgMj6M6ngN2gABC3a/7H25Tt6lNk8ckwu5qB2fItaYC4yVmgS/K1t3M8qHKmCxLT37x2
         Cq/RcEIbgJF+xrBy6IsIhGPNf0qDQCzAfI11+0XKAg730vJht2LC/uJS83+FMd9jJUOs
         EqmVIDCMf8F9VhVhow7jlW/RT9MpeuiU3Fb+l9E6hwP6+mqrTLErX17SMN6CfZ97mjmV
         0oQBB9SWjR42ZYsEFj+Pd5USmsAKoHj3IXirQktWOFKhTvBQhtM8PounRX5JWLXR+CPh
         PHNw==
X-Gm-Message-State: AOAM531MijtMdSs+tOCs1Vaj3urF223uQKdr659SvNPpUOArnwRJzDU6
        GUrANrlGoDoeOq8AIsXtzv9s/UXP
X-Google-Smtp-Source: ABdhPJxDP2wdTQdga5jwI0jusJUym+gW3UXfpbrAEdd9ctebbxGDWVLbsPuW5X9hE1wg7o+zbhNm/A==
X-Received: by 2002:a1f:320b:: with SMTP id y11mr2910238vky.57.1596448204868;
        Mon, 03 Aug 2020 02:50:04 -0700 (PDT)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id e14sm2041458vsa.33.2020.08.03.02.50.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 02:50:03 -0700 (PDT)
Received: by mail-vs1-f53.google.com with SMTP id q13so11971323vsn.9
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 02:50:03 -0700 (PDT)
X-Received: by 2002:a67:f454:: with SMTP id r20mr10240727vsn.20.1596448203263;
 Mon, 03 Aug 2020 02:50:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200802195046.402539-1-xie.he.0141@gmail.com>
In-Reply-To: <20200802195046.402539-1-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 3 Aug 2020 11:49:25 +0200
X-Gmail-Original-Message-ID: <CA+FuTSee5EhrH4FgkWFnAPH9o9O6inh3f+7+qJKJW6PtQw=SAg@mail.gmail.com>
Message-ID: <CA+FuTSee5EhrH4FgkWFnAPH9o9O6inh3f+7+qJKJW6PtQw=SAg@mail.gmail.com>
Subject: Re: [net v3] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 2, 2020 at 9:51 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> In net/packet/af_packet.c, the function packet_snd first reserves a
> headroom of length (dev->hard_header_len + dev->needed_headroom).
> Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
> which calls dev->header_ops->create, to create the link layer header.
> If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
> length (dev->hard_header_len), and assumes the user to provide the
> appropriate link layer header.
>
> So according to the logic of af_packet.c, dev->hard_header_len should
> be the length of the header that would be created by
> dev->header_ops->create.
>
> However, this driver doesn't provide dev->header_ops, so logically
> dev->hard_header_len should be 0.
>
> So we should use dev->needed_headroom instead of dev->hard_header_len
> to request necessary headroom to be allocated.
>
> This change fixes kernel panic when this driver is used with AF_PACKET
> SOCK_RAW sockets. Call stack when panic:
>
> [  168.399197] skbuff: skb_under_panic: text:ffffffff819d95fb len:20
> put:14 head:ffff8882704c0a00 data:ffff8882704c09fd tail:0x11 end:0xc0
> dev:veth0
> ...
> [  168.399255] Call Trace:
> [  168.399259]  skb_push.cold+0x14/0x24
> [  168.399262]  eth_header+0x2b/0xc0
> [  168.399267]  lapbeth_data_transmit+0x9a/0xb0 [lapbether]
> [  168.399275]  lapb_data_transmit+0x22/0x2c [lapb]
> [  168.399277]  lapb_transmit_buffer+0x71/0xb0 [lapb]
> [  168.399279]  lapb_kick+0xe3/0x1c0 [lapb]
> [  168.399281]  lapb_data_request+0x76/0xc0 [lapb]
> [  168.399283]  lapbeth_xmit+0x56/0x90 [lapbether]
> [  168.399286]  dev_hard_start_xmit+0x91/0x1f0
> [  168.399289]  ? irq_init_percpu_irqstack+0xc0/0x100
> [  168.399291]  __dev_queue_xmit+0x721/0x8e0
> [  168.399295]  ? packet_parse_headers.isra.0+0xd2/0x110
> [  168.399297]  dev_queue_xmit+0x10/0x20
> [  168.399298]  packet_sendmsg+0xbf0/0x19b0
> ......
>
> Additional change:
> When sending, check skb->len to ensure the 1-byte pseudo header is
> present before reading it.
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Overall, looks great. A  few nits.

It's [PATCH net v3], not [net v3]

> diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
> index b2868433718f..8a3f7ba36f7e 100644
> --- a/drivers/net/wan/lapbether.c
> +++ b/drivers/net/wan/lapbether.c
> @@ -157,6 +157,9 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
>         if (!netif_running(dev))
>                 goto drop;
>
> +       if (skb->len < 1)
> +               goto drop;
> +

Might be worth a comment along the lines of: /* upper layers pass a
control byte. must validate pf_packet input */

>         switch (skb->data[0]) {
>         case X25_IFACE_DATA:
>                 break;
> @@ -305,6 +308,7 @@ static void lapbeth_setup(struct net_device *dev)
>         dev->netdev_ops      = &lapbeth_netdev_ops;
>         dev->needs_free_netdev = true;
>         dev->type            = ARPHRD_X25;
> +       dev->hard_header_len = 0;

Technically not needed. The struct is allocated with kvzalloc, z for
__GFP_ZERO. Fine to leave if intended as self-describing comment, of
course.

>         dev->mtu             = 1000;
>         dev->addr_len        = 0;
>  }
> @@ -331,7 +335,8 @@ static int lapbeth_new_device(struct net_device *dev)
>          * then this driver prepends a length field of 2 bytes,
>          * then the underlying Ethernet device prepends its own header.
>          */
> -       ndev->hard_header_len = -1 + 3 + 2 + dev->hard_header_len;
> +       ndev->needed_headroom = -1 + 3 + 2 + dev->hard_header_len
> +                                          + dev->needed_headroom;
>
>         lapbeth = netdev_priv(ndev);
>         lapbeth->axdev = ndev;
> --
> 2.25.1
>
