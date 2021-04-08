Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35407358D40
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 21:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhDHTHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 15:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbhDHTHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 15:07:12 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7E2C061760;
        Thu,  8 Apr 2021 12:07:00 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x15so3270195wrq.3;
        Thu, 08 Apr 2021 12:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Exzdpqp3JyGRVNvIfqFzNBMPcWfx1NoduJ3Nxq4TiKA=;
        b=B/K3c2tQI7mxtYTE4VufIi2709olz3kY8axk8bJVSHRylEznUptfvtxBbOKsI8u9sa
         0RqfyEUV99O6qoZ8KqF/nXLjRJXnIametrn5c8+qA99hiaLT8Ukj+W4VVGtAS7s0/Rdh
         iEZx8l2pD5AqQWbBA+3skkmPYPLOZH8oWD0PucofNk7RIfp6TGRA6rF4a0ETjSZzcFgg
         TqNmQpkEsWvDUiMopAyHCHsobG/DYmHgd8hCg39lzO0R71KxtSALLjevESgp6FwVyPa8
         W2zgTo1lCkSSYTzoOreAHCHXWQFFdHkjEXbEgENUm67KgAFXlLKmsajgTAl++0CZPUD9
         s37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Exzdpqp3JyGRVNvIfqFzNBMPcWfx1NoduJ3Nxq4TiKA=;
        b=gAOY5xXn+xhOpeuK8CL+SSxSwMZLttblw7GJfPtzgq8Up0sUL10jx7+CG9jyIO//Cj
         L9wPSvdefyAJw0XynjELdIrsQ9TQZVcVhvg40B4d9Zm4ZHu7iabXR/lz/HNjvGSW7Jak
         +PV5nfyhpjZUtqtlhex7nnLn1xM0WqgWk0Y/TkTCUgYZWFrJC+f/GuPHtlRqjWEXmx4H
         5ZINrIC9kHBzhlt5iwPePRO8aH0v8/sYdCwzgYcMDpzC9BZ9Pagv2nnMSzWyd0rhlwOS
         ci5u3Ec5FNf1zXYdtsVpxvLmn/+e3mLYU0Je+9j7/H/PF2Zh2VLHAbjvLccWQnSSYL3+
         7FTw==
X-Gm-Message-State: AOAM530kQHEsGv4wID7P3Cdci+X5hnR+yCUYqCr9T4pd1BQG0ZVVrG3A
        51B+4zcfE3sMnyj5foSQF1SSdRsa2vNV0g==
X-Google-Smtp-Source: ABdhPJyiZDI4fHPPI7J6KQ6/9rzw3IvPYZnqX1CEWjf75QBxuJPoW4x1744ktBMFBuj+EiHLpZGevw==
X-Received: by 2002:a5d:6852:: with SMTP id o18mr13842852wrw.173.1617908818720;
        Thu, 08 Apr 2021 12:06:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:6dfe:cdb3:c4f9:2744? (p200300ea8f3846006dfecdb3c4f92744.dip0.t-ipconnect.de. [2003:ea:8f38:4600:6dfe:cdb3:c4f9:2744])
        by smtp.googlemail.com with ESMTPSA id c18sm300097wrp.33.2021.04.08.12.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 12:06:58 -0700 (PDT)
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210408172353.21143-1-TheSven73@gmail.com>
 <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
 <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
 <CAFSKS=P3Skh4ddB0K_wUxVtQ5K9RtGgSYo1U070TP9TYrBerDQ@mail.gmail.com>
 <820ed30b-90f4-2cba-7197-6c6136d2e04e@gmail.com>
 <CAGngYiU=v16Z3NHC0FyxcZqEJejKz5wn2hjLubQZKJKHg_qYhw@mail.gmail.com>
 <CAGngYiXH8WsK347ekOZau+oLtKa4RFF8RCc5dAoSsKFvZAFbTw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
Message-ID: <da81fa46-fbbd-7694-6212-d7eb2c03ac94@gmail.com>
Date:   Thu, 8 Apr 2021 21:06:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAGngYiXH8WsK347ekOZau+oLtKa4RFF8RCc5dAoSsKFvZAFbTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.04.2021 20:35, Sven Van Asbroeck wrote:
> Hi George,
> 
> On Thu, Apr 8, 2021 at 2:26 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>>
>> George, I will send a patch for you to try shortly. Except if you're
>> already ahead :)
> 
> Would this work for you? It does for me.
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

A completely unrelated question:
How about VLAN packets with a 802.1Q tag? Should VLAN_ETH_HLEN be used?


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
> 

