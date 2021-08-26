Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349F23F7F2F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhHZABU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 20:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhHZABT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 20:01:19 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269B1C061757;
        Wed, 25 Aug 2021 17:00:33 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id x2-20020a1c7c02000000b002e6f1f69a1eso5536185wmc.5;
        Wed, 25 Aug 2021 17:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Tchv2oY6Cx3fLEGg+fdfAoeAssl1qaeHYeW6E4lQ7Q=;
        b=gc3Iy7HEp9wXG/mB+BJp5EG4H4Pwz07bMEwIxJKOWfozIYqXvlCbd4eKuaCXzmrzVT
         sGKEOZPjrfSgCkPbZpyrmx30hdBuQ/7fZQxP6sI82h3VYrJZqCWYNiBlavh4jdyDUtRR
         IbUt0LxHq/RkPTuJzyStLFdOmHiu3Fo1SFzG5kYZdDBwdLsEPFFZ2qS8mIB+QABG7azh
         L1ldkFxCxhAvPLCMHfIbIwOY+sSONktD3FtlBVVHoxT0tnv4zISg8XaCvhNw+ToQcfme
         Ic/nCsex1MTo4vLATBUG4RkW2QYHbSYf/w2r1wWghna6sYoE4JXHzXsKgjubfU8N3Uqn
         HDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Tchv2oY6Cx3fLEGg+fdfAoeAssl1qaeHYeW6E4lQ7Q=;
        b=ARkESKLnZx7oAB6TAAgJJ6Dc9mI7PYlFWZDkBetzcsg0q+Kbl2D3ra90M6JnyKWEBm
         lA6xgeNGBq0Dx8+rSK9qSzbGAUQMtUXGc3yP3blbM8Ygt1QRoE1nmD3RKOtXa+G1jz1K
         Be2fn8XzPBLWfWV7JE3qglgjJTNSGU2E1NBXEqISN7QbAK0v6yTkJBKTuVArmvJJCTZg
         g3wJwebcy2hhvCQm0RvVM+nHq2HOpmId3Su3/MfBW9RLRfCdS9Ao1tX4xtUvzO85PuGh
         Oh+5768+bxHjkjj5eXiV/QafOEumRDLDGdG6KjJFj+CKJiw3JN7zZFOWScCnQRMGT118
         O83w==
X-Gm-Message-State: AOAM5338s6q0p2UfR1Ylko6plK8MhJbHwz8gO5CgQ5woI2vx7C9a3DdM
        PAH1zyhTryKsjq1bYamWWz/wHsFsPqs=
X-Google-Smtp-Source: ABdhPJxDv4UaIWb/Mq2+rTcw8JbYo2WHdxTa485C/RXoXJrSJcf0XsuVcHphfM7W6O/0DfrBU4FcYg==
X-Received: by 2002:a7b:c041:: with SMTP id u1mr808506wmc.95.1629936031747;
        Wed, 25 Aug 2021 17:00:31 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id q11sm1281281wrx.85.2021.08.25.17.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 17:00:31 -0700 (PDT)
Date:   Thu, 26 Aug 2021 03:00:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] DSA slave with customise netdev features
Message-ID: <20210826000030.dhiwv4puqiqyh3re@skbuf>
References: <20210825083832.2425886-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825083832.2425886-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 04:38:29PM +0800, DENG Qingfang wrote:
> Some taggers, such as tag_dsa.c, combine VLAN tags with DSA tags, which
> currently has a few problems:
>
> 1. Unnecessary reallocation on TX:
>
> A central TX reallocation has been used since commit a3b0b6479700
> ("net: dsa: implement a central TX reallocation procedure"), but for
> VLAN-tagged frames, the actual headroom required for DSA taggers which
> combine with VLAN tags is smaller.

If true, this would be a major failure of the central TX reallocation idea.

However, for this to fail, it would mean that there is a code path in
the network stack that routinely allocates skbs with skb_needed_headroom(skb)
smaller than dev->needed_headroom. That's the only thing that would trigger
reallocs (beside cloned skbs).

The fact that we ask for a dev->needed_headroom that is a bit larger
than what is needed in some cases is not an issue. We should declare the
largest dev->needed_headroom that should cover all cases.

Would you please let me know what is the stack trace when you apply this
patch?

-----------------------------[ cut here ]-----------------------------
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6d6f1aebf1ca..1924025ac136 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -600,6 +600,10 @@ static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
 		/* No reallocation needed, yay! */
 		return 0;
 
+	netdev_err(dev, "%s: skb realloc: headroom %u, tailroom %u, cloned %d, needed_headroom %d, needed_tailroom %d\n",
+		  __func__, skb_headroom(skb), skb_tailroom(skb), skb_cloned(skb), needed_headroom, needed_tailroom);
+	WARN_ON(!skb_cloned(skb));
+
 	return pskb_expand_head(skb, needed_headroom, needed_tailroom,
 				GFP_ATOMIC);
 }
-----------------------------[ cut here ]-----------------------------

>
> 2. Repeated memmoves:
>
> If a both Marvell EDSA and VLAN tagged frame is received, the current
> code will move the (DA,SA) twice: the first in dsa_rcv_ll to convert the
> frame to a normal 802.1Q frame, and the second to strip off the 802.1Q
> tag. The similar thing happens on TX.

I don't think a lot of people use 8021q uppers with mv88e6xxx. At least
the error messages I've seen during the few times when I've booted the
Turris Mox would seem to suggest that.

The code that converts DSA 'tagged' frames to VLAN tags originates from
Lennert Buytenhek himself.

>
> For these tags, it is better to handle DSA and VLAN tags at the same time
> in DSA taggers.

No objection there.

>
> This patch set allows taggers to add custom netdev features to DSA
> slaves so they can advertise VLAN offload, and converts tag_mtk to use
> the TX VLAN offload.
>
> DENG Qingfang (2):
>   net: dsa: allow taggers to customise netdev features
>   net: dsa: tag_mtk: handle VLAN tag insertion on TX
>
>  include/net/dsa.h |  2 ++
>  net/dsa/slave.c   |  3 ++-
>  net/dsa/tag_mtk.c | 46 ++++++++++++++++++++++------------------------
>  3 files changed, 26 insertions(+), 25 deletions(-)
>
> --
> 2.25.1
>
