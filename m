Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8964E26400B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgIJId1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729913AbgIJIY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 04:24:26 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B159FC061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 01:24:13 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id c127so2947473vsc.1
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 01:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eQRoi7azmXw9DhQr/EkZeyb3raZh2+EzD84kCzPcKmQ=;
        b=IQpO+ZJN8hEIxKKXEVX6pnZXoK7U8oJe3Rtm3II8W+/5GYDow3YNmnH96hrHx/wuqG
         SFRb4xr8BLqx8LItlGDnyQjxqZ/ZSlgBH3BGxzq9Os8zm/g0b1gVjHP7PGzx9a5o5B6/
         EDEc9DE5S5gVqIyGLNhaQAsT9VqTWPTwtmUgu+7ANNK1/QFxxXfUCvyzXmxLmQ44BRGh
         tkQjJzv5WFK5eilLOXHbkW70t8ezZlDleZTaVT9xdiks1rnLSwa6yuHa2zX5qbzLvNSU
         Euh7ET4qW9jY4Bw1ryswD3A5u/iQXJd+47RYjxdjBZnNUTUspU1ELTTSyLOg7B8ufiJb
         ZlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eQRoi7azmXw9DhQr/EkZeyb3raZh2+EzD84kCzPcKmQ=;
        b=R01OV2Fn0l0JDOEZJkm1G2EMqmM0Ep4mApeAfn8XOgLEuh3gIxxS9tbHKwU62+s311
         syIzm0e7qkjJoPawpxuucf0L8DZpGbmxt6y09ueNMbGfD33CZd4G3U+ukImBGTgww1io
         Nc/I1u/yExzUDuGqa89rWdzdgf4Mzks0r+pz1JKMbp1a1fdxiEjgczN/9jsxHlsy3l/5
         e3CpbzeIQQ8txm2RROiX5Byuf5iPA2RsbPgmRttwIztTsYjB9B/5fK/Nnl0ufdgMJpBo
         x3U003fWsMshltnvJRO0eSmTqfuuNbSAECyYIjXW5UQ8lre0T1FgKfVgtaw/riblNak6
         6slA==
X-Gm-Message-State: AOAM531uL/qNhONh75Lbt4+/be+c8LV6T6ToDKxDrOp4Pg6p5aaqS/7P
        SD1a7dkrnTHmY4OXJI35QRGHH1+HCF4LvA==
X-Google-Smtp-Source: ABdhPJywtvXnLBlI+6Potbpu4+2OVFOBMVPaUdD/DjZjwdKzKB4U3ElqafrY+7zxbFfO6wdp/W0TOg==
X-Received: by 2002:a67:cf8c:: with SMTP id g12mr3080979vsm.4.1599726251864;
        Thu, 10 Sep 2020 01:24:11 -0700 (PDT)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id 67sm828814vkr.24.2020.09.10.01.24.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 01:24:10 -0700 (PDT)
Received: by mail-vk1-f180.google.com with SMTP id q200so1362576vke.6
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 01:24:10 -0700 (PDT)
X-Received: by 2002:a1f:964c:: with SMTP id y73mr3236074vkd.8.1599726249873;
 Thu, 10 Sep 2020 01:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200910054333.447888-1-xie.he.0141@gmail.com>
In-Reply-To: <20200910054333.447888-1-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 10 Sep 2020 10:23:33 +0200
X-Gmail-Original-Message-ID: <CA+FuTSdcT70_zyJHiMPT_HK8zJbTg72y-AO2XYUXL28RX+tY9A@mail.gmail.com>
Message-ID: <CA+FuTSdcT70_zyJHiMPT_HK8zJbTg72y-AO2XYUXL28RX+tY9A@mail.gmail.com>
Subject: Re: [PATCH net v2] net: Clarify the difference between
 hard_header_len and needed_headroom
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

On Thu, Sep 10, 2020 at 7:44 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> The difference between hard_header_len and needed_headroom has long been
> confusing to driver developers. Let's clarify it.
>
> The understanding on this issue in this patch is based on the following
> reasons:
>
> 1.
>
> In af_packet.c, the function packet_snd first reserves a headroom of
> length (dev->hard_header_len + dev->needed_headroom).
> Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
> which calls dev->header_ops->create, to create the link layer header.
> If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
> length (dev->hard_header_len), and checks if the user has provided a
> header of length (dev->hard_header_len) (in dev_validate_header).

I think if you want to clarify, we have to be exact: [up to]
dev->hard_header_len. For protocols with variable length link layer
headers, the length is at least dev->min_header_len.

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
> setting needed_headroom. This means this usage is already adopted by
> driver developers.
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Brian Norris <briannorris@chromium.org>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Thanks for trying to clarify the behavior.

This patch should target net-next.

> ---
>
> Change from v1:
> Small change to the commit message.
>
> ---
>  include/linux/netdevice.h |  4 ++--
>  net/packet/af_packet.c    | 19 +++++++++++++------
>  2 files changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 7bd4fcdd0738..3999b04e435d 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1691,8 +1691,8 @@ enum netdev_priv_flags {
>   *     @min_mtu:       Interface Minimum MTU value
>   *     @max_mtu:       Interface Maximum MTU value
>   *     @type:          Interface hardware type
> - *     @hard_header_len: Maximum hardware header length.
> - *     @min_header_len:  Minimum hardware header length
> + *     @hard_header_len: Maximum length of the headers created by header_ops
> + *     @min_header_len:  Minimum length of the headers created by header_ops

This does not help imho. The existing definitions were clear and more
exact: hardware (i.e., link layer) headers.

Even more explicit, the hardware headers here must (probably) match
those dictated by dev->type, such as ARPHRD_ETHER.

>   *
>   *     @needed_headroom: Extra headroom the hardware may need, but not in all
>   *                       cases can this be guaranteed
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 2b33e977a905..0e324b08cb2e 100644
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
> @@ -2937,10 +2940,14 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>         skb_reset_network_header(skb);
>
>         err = -EINVAL;
> +       if (!dev->header_ops)
> +               WARN_ON_ONCE(dev->hard_header_len != 0);

Please make clear in the commit message that this is not just a
comment clarification.


>         if (sock->type == SOCK_DGRAM) {
>                 offset = dev_hard_header(skb, dev, ntohs(proto), addr, NULL, len);
>                 if (unlikely(offset < 0))
>                         goto out_free;
> +               WARN_ON_ONCE(offset > dev->hard_header_len);
> +               WARN_ON_ONCE(offset < dev->min_header_len);

This is not necessary. If worthwhile, this would belong inside
dev_hard_header itself.
