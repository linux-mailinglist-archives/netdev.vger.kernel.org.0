Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0CC358CBE
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbhDHSfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHSfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:35:53 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF4BC061760;
        Thu,  8 Apr 2021 11:35:41 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j5so2193072wrn.4;
        Thu, 08 Apr 2021 11:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YdkqUAqRAdKWRhs+z7FovfLbmEEQLSGL3bUMENm8fL8=;
        b=rVjR2kb2flCiKSmMVDladc7+gTWkhxbapYth3dJcRsrf4QQxQkhJECupTrRn5WoBNN
         ZSVWfyvCuyjAlAm7Q+5pUCvEu4mOhQ6ngDoVTD3VZHt9kmtLeR3dHRXnkXv6Vy1OfZ9I
         BcjJQCr9sJ+63RSy37YH5Xq/9TmgtdZ+1+rlu+x2UKiXU7FAQerTbXf5sF9BfBJBOH7+
         HSyHk65hlU8Cj7K3Y01JNPcXj9ResLBys/wgNn4DdMx4ogbxtAMQtSmoaiJfMaXo1a5e
         bwPA/i2cV0mI04B9F1jYF+Pf3qlzLF50yYtHB5rZOdfIfusC8HTBmQJbpDCqsRo27A1S
         wIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YdkqUAqRAdKWRhs+z7FovfLbmEEQLSGL3bUMENm8fL8=;
        b=CbU5XtCa4c71Wa9cVu2g1gDkjC/JmImkJptqGrJp4PY2TyCSBSyhle0eTsiHy3amTy
         rvvOp6PY7tm8aeMrlCtOJJYjV9BTaaquUrVDnjuiF04u74DzT1l9G81XOda8V26kTHZl
         FqKmpCsP3XDNFq1mFrCqLcvAAl1UtOm7yngpjGGFUNSdUGGqzZUCjwqoiJxvk3yFPLDJ
         L6UCa/Cud46bV3jBoD9SA9eaaaUQaNNaD1O4j8i3Zof3xUCMhEatB1Cmcgxkn6AQEHHY
         a2OEQQq9r5cv7+Y5iV5ew/nOSGPmKRpGaRUp6fWFzhtfIiJfAOpgd8AvR26TyEC6C30V
         gX2A==
X-Gm-Message-State: AOAM533iK5bPjuh8wxl50HA5zrLnLiXAv0xWTHGyWWyIW7uqXMzPP/HA
        JKmaBP4N/jrVGLNiPorGomcoHQgGF9eAac4aRcpJ9GrsRb5+yg==
X-Google-Smtp-Source: ABdhPJzKNmIOZvqyBLFGJdhepG/E74G/6l4BfMor6aCd2A7iVpr40wwezc/BhPTzN81givfID2uD6NpZra00SOK6MNU=
X-Received: by 2002:adf:e48f:: with SMTP id i15mr13552227wrm.197.1617906940268;
 Thu, 08 Apr 2021 11:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210408172353.21143-1-TheSven73@gmail.com> <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
 <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
 <CAFSKS=P3Skh4ddB0K_wUxVtQ5K9RtGgSYo1U070TP9TYrBerDQ@mail.gmail.com>
 <820ed30b-90f4-2cba-7197-6c6136d2e04e@gmail.com> <CAGngYiU=v16Z3NHC0FyxcZqEJejKz5wn2hjLubQZKJKHg_qYhw@mail.gmail.com>
In-Reply-To: <CAGngYiU=v16Z3NHC0FyxcZqEJejKz5wn2hjLubQZKJKHg_qYhw@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 8 Apr 2021 14:35:29 -0400
Message-ID: <CAGngYiXH8WsK347ekOZau+oLtKa4RFF8RCc5dAoSsKFvZAFbTw@mail.gmail.com>
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
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

Hi George,

On Thu, Apr 8, 2021 at 2:26 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>
> George, I will send a patch for you to try shortly. Except if you're
> already ahead :)

Would this work for you? It does for me.

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c
b/drivers/net/ethernet/microchip/lan743x_main.c
index dbdfabff3b00..7b6794aa8ea9 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -885,8 +885,8 @@ static int lan743x_mac_set_mtu(struct
lan743x_adapter *adapter, int new_mtu)
        }

        mac_rx &= ~(MAC_RX_MAX_SIZE_MASK_);
-       mac_rx |= (((new_mtu + ETH_HLEN + 4) << MAC_RX_MAX_SIZE_SHIFT_) &
-                 MAC_RX_MAX_SIZE_MASK_);
+       mac_rx |= (((new_mtu + ETH_HLEN + ETH_FCS_LEN)
+                 << MAC_RX_MAX_SIZE_SHIFT_) & MAC_RX_MAX_SIZE_MASK_);
        lan743x_csr_write(adapter, MAC_RX, mac_rx);

        if (enabled) {
@@ -1944,7 +1944,7 @@ static int lan743x_rx_init_ring_element(struct
lan743x_rx *rx, int index)
        struct sk_buff *skb;
        dma_addr_t dma_ptr;

-       buffer_length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
+       buffer_length = netdev->mtu + ETH_HLEN + ETH_FCS_LEN + RX_HEAD_PADDING;

        descriptor = &rx->ring_cpu_ptr[index];
        buffer_info = &rx->buffer_info[index];
@@ -2040,7 +2040,7 @@ lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
                dev_kfree_skb_irq(skb);
                return NULL;
        }
-       frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 2);
+       frame_length = max_t(int, 0, frame_length - ETH_FCS_LEN);
        if (skb->len > frame_length) {
                skb->tail -= skb->len - frame_length;
                skb->len = frame_length;
