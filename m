Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4393F7F35
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhHZAEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 20:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhHZAEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 20:04:39 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4AAC061757;
        Wed, 25 Aug 2021 17:03:52 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x12so1967656wrr.11;
        Wed, 25 Aug 2021 17:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KlyUydUojzLZ6p39N0u7umX9ajU71wqXxuDHFIBSfEU=;
        b=Dv6rvcAy935B8kJHZeiXg1EHaPpGS/ccJWcMk4XgNNtcK5Oeydjb2bNPjkQd1lXaIG
         8o+CcNDSyvnJUyWJoGzXTKOa213z8OK3xJroNWMa+lyzzv0G5+ql26itr/qPKAh/ewMU
         wndNGicDyUXxzr10DqhQNJYmbQkzWvdTBVOYRxVc0c/cixHw8AMiC/KytLiuWuzzuJz0
         qmjTm+1jk+qpoGEFqYso4XbtEeGp6TE+QmCUW8DDEvallXyAcVYZDkjfEAql8Kl6B1WV
         y4i6sdlbibCViJNqRMiV8M+lhWYKXg9oQqznY2t8Nti01xPQH3jkfSnO+mHMP2cTxDjq
         KAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KlyUydUojzLZ6p39N0u7umX9ajU71wqXxuDHFIBSfEU=;
        b=SqSg9PlN5ilTySqtq7Pp5IBxrX8ub03QLNBKTKht8CdsJd2pW+LVoyTdgKKMwg+V+6
         VCouCisG6qUcyCdfK8H0hOWZ3/AZ0dKY1EBTbo+ifOTtWcSYe7RwH165W/CU3QKsQ1RL
         EWriY6CObGT+fEAWkySHXXom7CvVDjriZ/u3QJzHd9P1zELfKIdFRIOZNIWZ6LdnWW//
         MvV+HBWNv3ZAxU35AOHyvUv+W4I6HkMZsE/UaIsXbFLhE+2SM6rDF4ZHTSdIAwf5iqy9
         eFgDPh1HDHwURjbd6n8WD9vPAhi0W4XNQ8EmHanSpVK44rlM0MTmOwf57CyvXALQL7Jb
         MqEQ==
X-Gm-Message-State: AOAM5320uQHZ95zPvs0zt4TMXFO4WTo8oWzmhxqKJGWJeQsuHetG/OAZ
        Z0mdpf2+oR++sloRv6eeTcLjRDc9eMU=
X-Google-Smtp-Source: ABdhPJyxsFed58Wr4UAjdzzLGAYuNMTG0LWiYGwosZW+7Y6qfu8vac/6EBVf84Ot+pbxF8R+VrpZIQ==
X-Received: by 2002:adf:90d0:: with SMTP id i74mr637031wri.185.1629936230707;
        Wed, 25 Aug 2021 17:03:50 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id r8sm1353839wrj.11.2021.08.25.17.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 17:03:50 -0700 (PDT)
Date:   Thu, 26 Aug 2021 03:03:49 +0300
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
Subject: Re: [RFC net-next 2/2] net: dsa: tag_mtk: handle VLAN tag insertion
 on TX
Message-ID: <20210826000349.q3s5gjuworxtbcna@skbuf>
References: <20210825083832.2425886-1-dqfext@gmail.com>
 <20210825083832.2425886-3-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825083832.2425886-3-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 04:38:31PM +0800, DENG Qingfang wrote:
> Advertise TX VLAN offload features, and handle VLAN tag insertion in
> the tag_xmit function.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  net/dsa/tag_mtk.c | 46 ++++++++++++++++++++++------------------------
>  1 file changed, 22 insertions(+), 24 deletions(-)
> 
> diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
> index 415d8ece242a..e407abefa06c 100644
> --- a/net/dsa/tag_mtk.c
> +++ b/net/dsa/tag_mtk.c
> @@ -22,7 +22,6 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>  				    struct net_device *dev)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	u8 xmit_tpid;
>  	u8 *mtk_tag;
>  
>  	/* Build the special tag after the MAC Source Address. If VLAN header
> @@ -31,33 +30,31 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>  	 * the both special and VLAN tag at the same time and then look up VLAN
>  	 * table with VID.
>  	 */
> -	switch (skb->protocol) {
> -	case htons(ETH_P_8021Q):
> -		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_8100;
> -		break;
> -	case htons(ETH_P_8021AD):
> -		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_88A8;
> -		break;
> -	default:
> -		xmit_tpid = MTK_HDR_XMIT_UNTAGGED;
> -		skb_push(skb, MTK_HDR_LEN);
> -		dsa_alloc_etype_header(skb, MTK_HDR_LEN);
> -	}
> -

You cannot just remove the old code. Only things like 8021q uppers will
send packets with the VLAN in the hwaccel area.

If you have an application that puts the VLAN in the actual AF_PACKET
payload, like:

https://github.com/vladimiroltean/tsn-scripts/blob/master/isochron/send.c

then you need to handle the VLAN being in the skb payload.
