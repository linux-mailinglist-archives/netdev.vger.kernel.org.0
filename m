Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEAB3D955C
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhG1ShL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhG1ShK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:37:10 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C53C061757;
        Wed, 28 Jul 2021 11:37:08 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id oz16so6138203ejc.7;
        Wed, 28 Jul 2021 11:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yyaUGEWG0nIXC1gfOxeCELARCR9thAOctZo/zZH4m2s=;
        b=mMgX8Hy4SlhLEBjNSXVKoHOlfH6TcnwFisily75X9FC0sDhF7GniXL34l6fQBMmITV
         dmsMsow3QVsCp1sZYlGDb8S0Znrp0GhLwolUuTo6pGxCjaxde1H+gEbl7seSnXG8RykC
         RAmNrxdE7XwSTEXxDJFsvmq3KlROTZoe/nVEtpQaFsMB0mJstomNpoOxDrofBU8TgDo/
         OYMNdoPeJhzxe0pmR2r/E5W8M1HArgNWXrqyw29DySuHfGzHMKhcS2+xnPohWrEpOwkE
         qh5jDsK/W7AMWP1R4YVXLk9u7ormGvbn4cQ2rifzOISSzVIw3DO8b9R0H0gqToCQbylK
         rzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yyaUGEWG0nIXC1gfOxeCELARCR9thAOctZo/zZH4m2s=;
        b=F82SPadsw0zbtyhybQRLY0TCEvrujWpKKv7rLen4FmqMvcQi0n3ee429XS1int9OXA
         FnAc9Qz8uu2RFFqNvn3fmasfNYnBr1vJ7yeJ1AjlgK7vAfu5ot257j3EjsnNMaHly9Rm
         m6EMnfu2uxqieJMD4nw1lrYNuCkirhSDapmax8C7ouJsJfGpn5Sz+4JEmsFkDucVy1I8
         CE/H0AoVVYYheCrIKf5mkc/9OWK0/q/CJ9ZHzBi7pQm6DXRavYDreRYuZXr2T2jZd9sj
         PsZzeuPZ1bMInFd6osGgaMCodhzA6pouB4XM2MXe0La0T0TEEk60eeHUokORk2Zyj126
         L5XQ==
X-Gm-Message-State: AOAM531FuIs+VhUTggO3Ty7SdRb3bXrOOhiOYEmsJ+0PjuLUqizLURyn
        MC6beEhUg7REGlhgaPAapY0=
X-Google-Smtp-Source: ABdhPJxTW797pWzpE94KJHIVp9j8MwGdZkIprfCl79F/7ws+z7OqANa4jht9R/NsoaujTu84CigPdw==
X-Received: by 2002:a17:906:350c:: with SMTP id r12mr851290eja.44.1627497426801;
        Wed, 28 Jul 2021 11:37:06 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id dn18sm229654edb.42.2021.07.28.11.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 11:37:06 -0700 (PDT)
Date:   Wed, 28 Jul 2021 21:37:05 +0300
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
Subject: Re: [RFC net-next 1/2] net: dsa: tag_mtk: skip address learning on
 transmit to standalone ports
Message-ID: <20210728183705.4gea64qlbe64kkpl@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-2-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728175327.1150120-2-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 01:53:25AM +0800, DENG Qingfang wrote:
> Consider the following bridge configuration, where bond0 is not
> offloaded:
> 
>          +-- br0 --+
>         / /   |     \
>        / /    |      \
>       /  |    |     bond0
>      /   |    |     /   \
>    swp0 swp1 swp2 swp3 swp4
>      .        .       .
>      .        .       .
>      A        B       C
> 
> Address learning is enabled on offloaded ports (swp0~2) and the CPU
> port, so when client A sends a packet to C, the following will happen:
> 
> 1. The switch learns that client A can be reached at swp0.
> 2. The switch probably already knows that client C can be reached at the
>    CPU port, so it forwards the packet to the CPU.
> 3. The bridge core knows client C can be reached at bond0, so it
>    forwards the packet back to the switch.
> 4. The switch learns that client A can be reached at the CPU port.
> 5. The switch forwards the packet to either swp3 or swp4, according to
>    the packet's tag.
> 
> That makes client A's MAC address flap between swp0 and the CPU port. If
> client B sends a packet to A, it is possible that the packet is
> forwarded to the CPU. With offload_fwd_mark = 1, the bridge core won't
> forward it back to the switch, resulting in packet loss.
> 
> To avoid that, skip address learning on the CPU port when the destination
> port is standalone, which can be done by setting the SA_DIS bit of the
> MTK tag, if bridge_dev of the destination port is not set.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  net/dsa/tag_mtk.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
> index cc3ba864ad5b..8c361812e21b 100644
> --- a/net/dsa/tag_mtk.c
> +++ b/net/dsa/tag_mtk.c
> @@ -15,8 +15,7 @@
>  #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
>  #define MTK_HDR_XMIT_TAGGED_TPID_88A8	2
>  #define MTK_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
> -#define MTK_HDR_XMIT_DP_BIT_MASK	GENMASK(5, 0)
> -#define MTK_HDR_XMIT_SA_DIS		BIT(6)
> +#define MTK_HDR_XMIT_SA_DIS_SHIFT	6
>  
>  static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>  				    struct net_device *dev)
> @@ -50,7 +49,8 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>  	 * whether that's a combined special tag with 802.1Q header.
>  	 */
>  	mtk_tag[0] = xmit_tpid;
> -	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;

Why stop AND-ing with MTK_HDR_XMIT_DP_BIT_MASK if you were doing that
before? If it's not needed (probably isn't), it would be nice to split
that up.

> +	mtk_tag[1] = BIT(dp->index) |
> +		     (!dp->bridge_dev << MTK_HDR_XMIT_SA_DIS_SHIFT);
>  
>  	/* Tag control information is kept for 802.1Q */
>  	if (xmit_tpid == MTK_HDR_XMIT_UNTAGGED) {
> -- 
> 2.25.1
> 

Otherwise this is as correct as can be without implementing TX
forwarding offload for the bridge (which you've explained why it doesn't
map 1:1 with what your hw can do). But just because a port is under a bridge
doesn't mean that the only packets it sends belong to that bridge. Think
AF_PACKET sockets, PTP etc. The bridge also has a no_linklocal_learn
option that maybe should be taken into consideration for drivers that
can do something meaningful about it. Anyway, food for thought.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
