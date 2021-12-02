Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1597466AF7
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 21:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348823AbhLBUlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 15:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243367AbhLBUlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 15:41:10 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D195C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 12:37:47 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id g17so2889460ybe.13
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 12:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n/uzzDP/KEOZb6z5lQcDqcGP9+OgszyEqZbSzyf61YA=;
        b=oBI23LCsNi3hsn88gcxRLJPPcXbVbb1MWSl+Nsm6mftaifdwfiMhJRmWi20FqnG2aa
         RmjhKRiTy5O6/kQ86YmLS9+P+NUW7i0+mdzHwFxWdjBl+/6lYxjVNwBehAJINKkeNJhN
         UUsLKUvZK1EFrC3uRTX4RjXgAjHXcovbvaB474KnVe7IV4Jo1sQGZxt1xS1vk+bKHUK9
         qziZbMczXJMWLbKdGgiY1n2Wgqz+uh77LcZrohbMv4U/4wOxdv37JW+LUVAsgxKIZ0aI
         1h9W2Gn0vmfhcdvRjiDRi91Gp8xKkDlQfCUOEE9GHLw/5jdHbGaXCrTCZbCu0vsEibZ5
         pv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n/uzzDP/KEOZb6z5lQcDqcGP9+OgszyEqZbSzyf61YA=;
        b=ieD/pV1gl1/enetUfL1YHq7IPXO1Sl7wLNhu1KWA8ptpfXvNzRiIdERLjLrTz2gD2v
         bUd6hhnX1+OX1yx7hxgOq2K1Ej/Ik9sEv3UBOrYE8Y7csMotJkcgXTjeRkMvIT17K6b8
         qkajvNuTHke1XOfxLa6InOZ75vKjS4tsSeymNhprNVUWJNMi7PJQM/xInTfFX4o7u01J
         Y6ZhGFJpjWCdQWCUi4MxBgqN8AiiSyuj01JzIyzqlyi/GLhY8H9pdYbuy6Ynsx9gfWXh
         gBt3cg8vXKiMlqJziN1+r9ZOYFXMqufRMJmjkchDQoK3x6ZA85N2Lqxd3I+djjA9UVXG
         ftSA==
X-Gm-Message-State: AOAM533A0dabJHKzKPF9AQTluitIf4Do4tVsY4wKWLG4mUqI/R9jkq9T
        ws4cCkEDLCaAv/arslLUvTskGIV0y3SPq53ojknh5qO52wctIQ==
X-Google-Smtp-Source: ABdhPJxgxHPTwJjoC+sYOh6ONz9LcdiLCKsYjVSb+8uPPDh45Ub7wFeyxH0sphMqDITommqfNCqOTrMOIinx8xt0jOg=
X-Received: by 2002:a25:760d:: with SMTP id r13mr19153112ybc.296.1638477466349;
 Thu, 02 Dec 2021 12:37:46 -0800 (PST)
MIME-Version: 1.0
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com> <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf> <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
In-Reply-To: <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Dec 2021 12:37:35 -0800
Message-ID: <CANn89iJOH0QtRhDfBzJr3fpJPNCQJhbMqT_8sa+vH_6mmZ7xhw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 11:32 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Thanks Vladimir
>
> I think that maybe the issue is that the initial skb->csum is zero,
> and the csum_parttial(removed_block) is also zero.
>
> But the initial skb->csum should not be zero if you have a non " all
> zero"  frame.
>
> Can you double check this in drivers/net/ethernet/freescale/enetc/enetc.c ?


Yes, I am not sure why the csum is inverted in enetc_get_offloads()

Perhaps

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c
b/drivers/net/ethernet/freescale/enetc/enetc.c
index 504e12554079e306e477b9619f272d6e96527377..72524f14cae0093763f8a3f57b1e08e31bc4df1a
100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -986,7 +986,7 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
        if (rx_ring->ndev->features & NETIF_F_RXCSUM) {
                u16 inet_csum = le16_to_cpu(rxbd->r.inet_csum);

-               skb->csum = csum_unfold((__force __sum16)~htons(inet_csum));
+               skb->csum = csum_unfold((__force __sum16)htons(inet_csum));
                skb->ip_summed = CHECKSUM_COMPLETE;
        }

If this does not work, then maybe :

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c
b/drivers/net/ethernet/freescale/enetc/enetc.c
index 504e12554079e306e477b9619f272d6e96527377..d190faa9a8242f9f3f962dd30b9f4409a83ee697
100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -987,7 +987,8 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
                u16 inet_csum = le16_to_cpu(rxbd->r.inet_csum);

                skb->csum = csum_unfold((__force __sum16)~htons(inet_csum));
-               skb->ip_summed = CHECKSUM_COMPLETE;
+               if (likely(skb->csum))
+                       skb->ip_summed = CHECKSUM_COMPLETE;
        }

        if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_VLAN) {
