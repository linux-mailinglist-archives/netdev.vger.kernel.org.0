Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BF02BBC38
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 03:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgKUCXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgKUCXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 21:23:50 -0500
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BDEC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 18:23:49 -0800 (PST)
Received: by mail-ua1-x943.google.com with SMTP id v9so3769253uar.11
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 18:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ajnB/6Ke6BvMC6x8hzP0O9oVodSejXg/zQlsUbnO04g=;
        b=kLADDoSh/2yMHlmaaUHmaHxyNI8xNDPBMI8J9gFslOYVQgn4w1vf4dooLIry2EhxwD
         Xbmnyz27nujHRQtqbb/D1m8/Jk4FMnxqFan1b1HleNm9UKXOZs0eqaY1mqC9+jtLyid3
         RaxL5AzgN4ZvTjtTddFXaxHVc5eVQioBcflyh46UWM+T+H4gKuPjyF1N2aqkqCQLct+6
         aPBihtLrf7Et7ta2oKlm4gP1qmGcikyezKfHzamflVcvY+WOQNOJvNRqy5hAJU3yR+6t
         YaXStvMZVdJjHWWrYSjoL8O47TcAsDB1u7DNfmslS3OZjMK4KBsdpTKKJuaCwSsVLA13
         ZSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ajnB/6Ke6BvMC6x8hzP0O9oVodSejXg/zQlsUbnO04g=;
        b=QObdbx4LgTV84VkHwFnWqDaArbcZjiIBD8Vhr+L3jGJ7FRw8qdTUFid7KwBGYpZTUO
         iVrpgS7JcJbCRH+wLi+NQGISuRpq4AC3zcb6ZC++srDndRXYkxpPwOFosbMDunEfCEdp
         e58Icny185TZM/HKRGAlst2K3xj3DvHey3JCIkoWd3p8Q1Avguo/I3TBCRJmaIXvJ+5C
         7KuXU432Uybx9Y5B9Uhf8y7mzZWxB/kARSsVl7ZSWmB0noutlbe2rWbX5YcBkINEjSRa
         gKCp7mAUva7ZjutSd+PY6Nw3D9WxibJwGNp2gKvWkTXNAX7CfnHBI2943juCCFDYu4nP
         9njw==
X-Gm-Message-State: AOAM530K+KLMoHCqCRfsnl6BKnd/yyRmvoV5CPJFMNm0lyjNpbAUFcI1
        Vup2jQvjsuYlI5m1VOKnbdNRBYa7DoY=
X-Google-Smtp-Source: ABdhPJzvEvFj0s7wBZwPmzIHRWcCKOQW7Z96AU+usQ24uATg3dN4j/Zpymvotc9DTsJGEZoVP/3EsQ==
X-Received: by 2002:ab0:1c08:: with SMTP id a8mr15433296uaj.17.1605925427466;
        Fri, 20 Nov 2020 18:23:47 -0800 (PST)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id m205sm645668vkm.9.2020.11.20.18.23.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 18:23:46 -0800 (PST)
Received: by mail-vs1-f48.google.com with SMTP id y78so6098608vsy.6
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 18:23:46 -0800 (PST)
X-Received: by 2002:a67:e210:: with SMTP id g16mr15539273vsa.28.1605925425723;
 Fri, 20 Nov 2020 18:23:45 -0800 (PST)
MIME-Version: 1.0
References: <20201120030412.1646940-1-eyal.birger@gmail.com>
In-Reply-To: <20201120030412.1646940-1-eyal.birger@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 20 Nov 2020 21:23:08 -0500
X-Gmail-Original-Message-ID: <CA+FuTSe5jHJhE=a1uOYi8+Le2-6Naea2nY8iji2GxxjdEEr69Q@mail.gmail.com>
Message-ID: <CA+FuTSe5jHJhE=a1uOYi8+Le2-6Naea2nY8iji2GxxjdEEr69Q@mail.gmail.com>
Subject: Re: [net] net/packet: fix incoming receive for L3 devices without
 visible hard header
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Network Development <netdev@vger.kernel.org>,
        Xie He <xie.he.0141@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 10:05 PM Eyal Birger <eyal.birger@gmail.com> wrote:
>
> In the patchset merged by commit b9fcf0a0d826
> ("Merge branch 'support-AF_PACKET-for-layer-3-devices'") L3 devices which
> did not have header_ops were given one for the purpose of protocol parsing
> on af_packet transmit path.
>
> That change made af_packet receive path regard these devices as having a
> visible L3 header and therefore aligned incoming skb->data to point to the
> skb's mac_header. Some devices, such as ipip, xfrmi, and others, do not
> reset their mac_header prior to ingress and therefore their incoming
> packets became malformed.
>
> Ideally these devices would reset their mac headers, or af_packet would be
> able to rely on dev->hard_header_len being 0 for such cases, but it seems
> this is not the case.
>
> Fix by changing af_packet RX ll visibility criteria to include the
> existence of a '.create()' header operation, which is used when creating
> a device hard header - via dev_hard_header() - by upper layers, and does
> not exist in these L3 devices.
>
> Fixes: b9fcf0a0d826 ("Merge branch 'support-AF_PACKET-for-layer-3-devices'")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Thanks for the fix. This makes sense to me.

Recent discussions on this point also agreed that whether or not
headers are exposed to code above the device driver depends
on dev->hard_header_len and dev->header_ops->create (and
the two have to be consistent with one another).

dev->header_ops->parse_protocol is a best effort approach to
infer a protocol in cases where the caller did not specify it. But
as best effort, its existence or absence does not define the
device header, so testing only header_ops != NULL is insufficient.

> ---
>  net/packet/af_packet.c | 28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index cefbd50c1090..a241059fd536 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -93,8 +93,8 @@
>
>  /*
>     Assumptions:
> -   - If the device has no dev->header_ops, there is no LL header visible
> -     above the device. In this case, its hard_header_len should be 0.
> +   - If the device has no dev->header_ops->create, there is no LL header
> +     visible above the device. In this case, its hard_header_len should be 0.
>       The device may prepend its own header internally. In this case, its
>       needed_headroom should be set to the space needed for it to add its
>       internal header.
> @@ -108,21 +108,21 @@
>  On receive:
>  -----------
>
> -Incoming, dev->header_ops != NULL
> +Incoming, dev->header_ops != NULL && dev->header_ops->create != NULL
>     mac_header -> ll header
>     data       -> data
>
> -Outgoing, dev->header_ops != NULL
> +Outgoing, dev->header_ops != NULL && dev->header_ops->create != NULL
>     mac_header -> ll header
>     data       -> ll header
>
> -Incoming, dev->header_ops == NULL
> +Incoming, dev->header_ops == NULL || dev->header_ops->create == NULL
>     mac_header -> data
>       However drivers often make it point to the ll header.
>       This is incorrect because the ll header should be invisible to us.
>     data       -> data
>
> -Outgoing, dev->header_ops == NULL
> +Outgoing, dev->header_ops == NULL || dev->header_ops->create == NULL
>     mac_header -> data. ll header is invisible to us.
>     data       -> data
>
> @@ -272,6 +272,18 @@ static bool packet_use_direct_xmit(const struct packet_sock *po)
>         return po->xmit == packet_direct_xmit;
>  }
>
> +static bool packet_ll_header_rcv_visible(const struct net_device *dev)
> +{
> +       /* The device has an explicit notion of ll header,
> +        * exported to higher levels
> +        *
> +        * Otherwise, the device hides details of its frame
> +        * structure, so that corresponding packet head is
> +        * never delivered to user.
> +        */
> +       return dev->header_ops && dev->header_ops->create;
> +}
> +

Perhaps a dev_has_header(..) in include/linux/netdevice.h

And then the same in the Incoming/Outgoing comments above.
