Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A73358DCA
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 21:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhDHTzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 15:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhDHTzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 15:55:38 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33508C061760;
        Thu,  8 Apr 2021 12:55:27 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id w31-20020a9d36220000b02901f2cbfc9743so3497937otb.7;
        Thu, 08 Apr 2021 12:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e2QwQJKQWZmWy3gRHtnxS+91EFAtarH/rsu1NumZysE=;
        b=ueFiwP4SZrzbAXcJ0E6vNE951JWPW+V8b57dczD+Dq0N7oQZ5QcckIXXaskh/gaCFi
         /oOaYP9eMGYSc+1wj91Daz7AiwszvwSBjZYTl5JIgpLgCxtBCaJitgd+Ew7Yim2w3N3V
         aHFftmF8bZZgdAHdvJ6gmKbueeMgatYoARXTLSMKZOFdXZn0v1px1KNeJ+YN2KDLdmgZ
         1Tj5boU6fXDeryS3X/Y2b4s/zSiiGta1feoE7Mk74Dtr+vbOrUd1e/ToMZYUTc3/cv3y
         XSt4a/u6VcmRitzB/YI7UxEAcfzRLSQro2nxOPXqPYNcg+va+VhNwS3fh2EIO5qxNTTB
         YBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e2QwQJKQWZmWy3gRHtnxS+91EFAtarH/rsu1NumZysE=;
        b=oi7tEA1QW3qe0yN0u+g6MHh4P7s3eBw0OI+cD/BRGp6LaGwv7Xn+P38Q7w/+IHLkW/
         8yQWrDUzKU9p6iHoQEghun8iUNA9KJs2aYuHLx+jn74gKV2WINVIEzKd4rCKzWDw1YnL
         prNGv9X7ECECvPt+brmUiXI68ZnbUmHR6qx3RU+gedpFGLMyxU2EUz2kQme0n9RsutXs
         ipgbeySj4QzSjhl0yDfeyJsrRUh3gaU8AF3kDigJqtNBTw1wndMJK+MD2O7aDeJIECDU
         kC+67N6UwD47qrh86mqN1BDQAcYr2ZoJnfqD6+xC0NyaWbmNCT6IucP+sjaT9n4Vjtdk
         V/7g==
X-Gm-Message-State: AOAM5321tLNdzBMNtfAaYL6nO6dIMmnVAnj4UMHB+dkViX4QcsEnB5u1
        f5YAxmRt2hISQUWB77Y64hAuZYz7VL0vgL8RDA==
X-Google-Smtp-Source: ABdhPJx0t1YtFGjhUd9MQ8UFhJ4Hig6z3kx2Htq9LVPrBp1J/A3p9KJFBL553ShD9Wumk7lEFTTQ+Mo7eVjcf0Dj7QQ=
X-Received: by 2002:a05:6830:1d45:: with SMTP id p5mr9165520oth.340.1617911726620;
 Thu, 08 Apr 2021 12:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210408172353.21143-1-TheSven73@gmail.com> <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
 <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
 <CAFSKS=P3Skh4ddB0K_wUxVtQ5K9RtGgSYo1U070TP9TYrBerDQ@mail.gmail.com>
 <820ed30b-90f4-2cba-7197-6c6136d2e04e@gmail.com> <CAGngYiU=v16Z3NHC0FyxcZqEJejKz5wn2hjLubQZKJKHg_qYhw@mail.gmail.com>
 <CAGngYiXH8WsK347ekOZau+oLtKa4RFF8RCc5dAoSsKFvZAFbTw@mail.gmail.com>
In-Reply-To: <CAGngYiXH8WsK347ekOZau+oLtKa4RFF8RCc5dAoSsKFvZAFbTw@mail.gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 8 Apr 2021 14:55:14 -0500
Message-ID: <CAFSKS=PjCU-5YmDhUzjvhXV_+Ln70bThjCt48GUGXtn-NH6HQw@mail.gmail.com>
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 1:35 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>
> Hi George,
>
> On Thu, Apr 8, 2021 at 2:26 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:
> >
> > George, I will send a patch for you to try shortly. Except if you're
> > already ahead :)
>
> Would this work for you? It does for me.

Works for me too.

>
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c
> b/drivers/net/ethernet/microchip/lan743x_main.c
> index dbdfabff3b00..7b6794aa8ea9 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -885,8 +885,8 @@ static int lan743x_mac_set_mtu(struct
> lan743x_adapter *adapter, int new_mtu)
>         }
>
>         mac_rx &= ~(MAC_RX_MAX_SIZE_MASK_);
> -       mac_rx |= (((new_mtu + ETH_HLEN + 4) << MAC_RX_MAX_SIZE_SHIFT_) &
> -                 MAC_RX_MAX_SIZE_MASK_);
> +       mac_rx |= (((new_mtu + ETH_HLEN + ETH_FCS_LEN)
> +                 << MAC_RX_MAX_SIZE_SHIFT_) & MAC_RX_MAX_SIZE_MASK_);
>         lan743x_csr_write(adapter, MAC_RX, mac_rx);
>
>         if (enabled) {
> @@ -1944,7 +1944,7 @@ static int lan743x_rx_init_ring_element(struct
> lan743x_rx *rx, int index)
>         struct sk_buff *skb;
>         dma_addr_t dma_ptr;
>
> -       buffer_length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
> +       buffer_length = netdev->mtu + ETH_HLEN + ETH_FCS_LEN + RX_HEAD_PADDING;
>
>         descriptor = &rx->ring_cpu_ptr[index];
>         buffer_info = &rx->buffer_info[index];
> @@ -2040,7 +2040,7 @@ lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
>                 dev_kfree_skb_irq(skb);
>                 return NULL;
>         }
> -       frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 2);
> +       frame_length = max_t(int, 0, frame_length - ETH_FCS_LEN);
>         if (skb->len > frame_length) {
>                 skb->tail -= skb->len - frame_length;
>                 skb->len = frame_length;
