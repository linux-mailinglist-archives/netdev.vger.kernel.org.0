Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977114A8924
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352457AbiBCQ5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbiBCQ5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:57:08 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6F1C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:57:08 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id i62so10833026ybg.5
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1+VFWaHHCHiCMuC4cEMkBvsr2KFignA0T6l4c8M0MAM=;
        b=KYfZk2I/AtqQsroQbtxZ+ul3rE9yp5Cne5hcUgQX8Qrf24NeB4opRJvM3VwEag4Iq6
         6qOkNYSOP0u+aTsQbvPprI5/A8XbaOIp1oIVXFC66duP3YaiEVqBiTbP5RRyQYy9oaWN
         fwlrT75aCmg86cEk535jUQOABM9teoDqX8yeT1tYln8HXnuJjZc7tcF5XReUgoT8Jpa+
         M2R7mpbpDuY46qdYs9rhqd/JRDx+Cj/JTgzZT7pWR46MBXQi4kUpE1p+DTus1RkK2BzQ
         4zaQNmvqz1vNU9AWIzLiwJZz91bsczb26X5PA30TJbfuioVsU9jk0DCJ9NWWTxYo42Vj
         R2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1+VFWaHHCHiCMuC4cEMkBvsr2KFignA0T6l4c8M0MAM=;
        b=N2R+0TH7xpANUlrsXnZ8n4VxPPMVqhuxp7aIK4vo9NxOEvE1Byw6oCFoYMA0yM7igL
         bA3oekO7WLg+yayDVmmbXsXilCoDgO9KAgDPENbchze5Tpgf9WfIkMhvJdKOitThFbU5
         ZMTITi40vjI+9RZQJS/0ovMU+jULMDKdrs+KmB+U1y4hDudKgbs/ncmov7FkWl6SZtxc
         EIWYyx1+5ZxtMMAUkQAolphEpYgeTpUCnbe5bKm2h5006oK2g8H3i2Wy15oK96pKp0T6
         1lUzRNpOVI87apnXPUNRw8SwktHLfpEPPXD27R2XZ/v5EyZYnM2zMyP6mGzzRHKkA+HV
         hJWA==
X-Gm-Message-State: AOAM5300bJZ5HNz3xihGEp2GEr0Hl3jdyRBS3ncIVFBgB9bL3oIYAl5W
        vualJWzE83Ah6Af617TEHpFSZNwE0mK9nIQq7uGeSyCuLdxDfYOprtM=
X-Google-Smtp-Source: ABdhPJwVF1iK0FCEkUNoCN/4Tx/mdJVYP7kmgdURjiYulMzXIYo/aG6kUV+a6q1bBsVo+6o7S5PkRr2ZfJi0JRJEvIE=
X-Received: by 2002:a81:c54:: with SMTP id 81mr5471858ywm.464.1643907427147;
 Thu, 03 Feb 2022 08:57:07 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-2-eric.dumazet@gmail.com> <20220203083407.523721a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203083407.523721a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 08:56:56 -0800
Message-ID: <CANn89iKd-M6Ry+K7m+n5Voo641K7S24qm27SwrP4VAAchVPT4A@mail.gmail.com>
Subject: Re: [PATCH net-next 01/15] net: add netdev->tso_ipv6_max_size attribute
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 8:34 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  2 Feb 2022 17:51:26 -0800 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Some NIC (or virtual devices) are LSOv2 compatible.
> >
> > BIG TCP plans using the large LSOv2 feature for IPv6.
> >
> > New netlink attribute IFLA_TSO_IPV6_MAX_SIZE is defined.
> >
> > Drivers should use netif_set_tso_ipv6_max_size() to advertize their limit.
> >
> > Unchanged drivers are not allowing big TSO packets to be sent.
>
> Many drivers will have a limit on how many buffer descriptors they
> can chain, not the size of the super frame, I'd think. Is that not
> the case? We can't assume all pages but the first and last are full,
> right?

In our case, we have a 100Gbit Google NIC which has these limits:

- TX descriptor has a 16bit field filled with skb->len
- No more than 21 frags per 'packet'

In order to support BIG TCP on it, we had to split the bigger TCP packets
into smaller chunks, to satisfy both constraints (even if the second
constraint is hardly hit once you chop to ~60KB packets, given our 4K
MTU)

ndo_features_check() might help to take care of small oddities.

For instance I will insert the following in the next version of the series:

commit 26644be08edc2f14f6ec79f650cc4a5d380df498
Author: Eric Dumazet <edumazet@google.com>
Date:   Wed Feb 2 23:22:01 2022 -0800

    net: typhoon: implement ndo_features_check method

    Instead of disabling TSO if MAX_SKB_FRAGS > 32, implement
    ndo_features_check() method for this driver.

    If skb has more than 32 frags, use the following heuristic:

    1) force GSO for gso packets
    2) Otherwise force linearization.

    Most locally generated TCP packets will use a small number of fragments
    anyway.

    Signed-off-by: Eric Dumazet <edumazet@google.com>

diff --git a/drivers/net/ethernet/3com/typhoon.c
b/drivers/net/ethernet/3com/typhoon.c
index 8aec5d9fbfef2803c181387537300502a937caf0..216e26a49e9c272ba7483bfa06941ff11ea40e3c
100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -138,11 +138,6 @@ MODULE_PARM_DESC(use_mmio, "Use MMIO (1) or
PIO(0) to access the NIC. "
 module_param(rx_copybreak, int, 0);
 module_param(use_mmio, int, 0);

-#if defined(NETIF_F_TSO) && MAX_SKB_FRAGS > 32
-#warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO
-#undef NETIF_F_TSO
-#endif
-
 #if TXLO_ENTRIES <= (2 * MAX_SKB_FRAGS)
 #error TX ring too small!
 #endif
@@ -2261,9 +2256,23 @@ typhoon_test_mmio(struct pci_dev *pdev)
        return mode;
 }

+static netdev_features_t typhoon_features_check(struct sk_buff *skb,
+                                               struct net_device *dev,
+                                               netdev_features_t features)
+{
+       if (skb_shinfo(skb)->nr_frags > 32) {
+               if (skb_is_gso(skb))
+                       features &= ~NETIF_F_GSO_MASK;
+               else
+                       features &= ~NETIF_F_SG;
+       }
+       return features;
+}
+
 static const struct net_device_ops typhoon_netdev_ops = {
        .ndo_open               = typhoon_open,
        .ndo_stop               = typhoon_close,
+       .ndo_features_check     = typhoon_features_check,
        .ndo_start_xmit         = typhoon_start_tx,
        .ndo_set_rx_mode        = typhoon_set_rx_mode,
        .ndo_tx_timeout         = typhoon_tx_timeout,
