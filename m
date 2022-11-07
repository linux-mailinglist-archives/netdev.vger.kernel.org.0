Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9407F6203CB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 00:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiKGXcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 18:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbiKGXcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 18:32:35 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D011741C;
        Mon,  7 Nov 2022 15:32:34 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id k2so34333895ejr.2;
        Mon, 07 Nov 2022 15:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AiLgtkiudUKJTTaGdp3zbpBeZPoePBEReextvb186MI=;
        b=F+912x1YVqzNVZ+r84T1IgOx22zFb0Z/IwAZyy2OHa10ek3R514Rs1677cR+EL1q/j
         wxE8uaHgW2Gvd9YiIKC+dGk06TxagVz2h9sl4lcEY5fvbb0/3uclQxHoerZzRrHdmawJ
         MgcZxqpr6suK1wdHyXEPCbmC+cUFPWE/HQSYZGE47XHq8TGetzN+6taEgUL/3mGcx1HM
         G8Kb8loOisf/avTiK/Fq0InBmKXa/o3ivcd2GD6jjJI3RIU8UzDbxnW5J/P+BMsXNrKe
         qNqamSeiF5MYKL9siv68G90teksoa5S2qHssaQPBMPJ8334Q+Oxldq0XWAlczy/GBe4I
         bhNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AiLgtkiudUKJTTaGdp3zbpBeZPoePBEReextvb186MI=;
        b=ywxHRBXbhY6WnvdTlEuv/H5m2mhNx3d8dBjuqkNRzVcJwR8/LbO33jMYqQGluEgdIU
         5MD+DkhowM2plIrxJWVmdqAicdF3wA4ncVEQpXkDfKw0dLZWcEO1JBNJ7gf8t0KqEjtb
         PKJUd3EwoiUUNBSSwHwb6M1NYwh+5x4S2e1ML7argMfr/Lvoss840LJYsN3qs904ZUUC
         64f8qQDHx+9s6iZWVVNgVdf9wTuJc7l5FHKsuFYQDg3FKW5I0Cy6ldvVCWHcbo08hBis
         sc+/eLkx7gb9RE8FAPqwQgU4YZ2y8RiE9dIfECX/nVxRAsmXcTJTGN1soQLpKkDQH7/Q
         wLvw==
X-Gm-Message-State: ANoB5plRFq8s/lpWm8V3FdxYd+OlQk44bO9VlDufgNxDxv2HvUObLToJ
        SVXucrLNBE/IRlenu18BOfw=
X-Google-Smtp-Source: AA0mqf75QT137g7/iddXAYo402OLTzYbFPikl7JfQ39bSP0WrlaHdQL7Tt0Qql8fqtDDCA22f1f+Ug==
X-Received: by 2002:a17:907:971e:b0:78d:e7ed:7585 with SMTP id jg30-20020a170907971e00b0078de7ed7585mr1937992ejc.258.1667863952532;
        Mon, 07 Nov 2022 15:32:32 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id o19-20020a170906769300b00722e50dab2csm3970132ejm.109.2022.11.07.15.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 15:32:31 -0800 (PST)
Date:   Tue, 8 Nov 2022 01:32:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] net: ethernet: mtk_eth_soc: fix VLAN rx hardware
 acceleration
Message-ID: <20221107233229.qzwuex4nwm44xbe4@skbuf>
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-11-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107185452.90711-11-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 07:54:49PM +0100, Felix Fietkau wrote:
> - enable VLAN untagging for PDMA rx
> - make it possible to disable the feature via ethtool
> - pass VLAN tag to the DSA driver
> - untag special tag on PDMA only if no non-DSA devices are in use
> - disable special tag untagging on 7986 for now, since it's not working yet

What is the downside of not enabling VLAN RX offloading, is it a
performance or a functional need to have it?

> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 36 +++++++++++++--------
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  3 ++
>  2 files changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index ab31dda2cd66..3b8995a483aa 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2015,16 +2015,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  						htons(RX_DMA_VPID(trxd.rxd4)),
>  						RX_DMA_VID(trxd.rxd4));
>  			} else if (trxd.rxd2 & RX_DMA_VTAG) {
> -				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
> +				__vlan_hwaccel_put_tag(skb, htons(RX_DMA_VPID(trxd.rxd3)),

Why make this change? The network stack doesn't like it when you feed it
non-standard VLAN protocols, as you've noticed.

>  						       RX_DMA_VID(trxd.rxd3));
>  			}
> -
> -			/* If the device is attached to a dsa switch, the special
> -			 * tag inserted in VLAN field by hw switch can * be offloaded
> -			 * by RX HW VLAN offload. Clear vlan info.

What is the format of this special tag, what does it contain? The same
thing as what mtk_tag_rcv() parses?

> -			 */
> -			if (netdev_uses_dsa(netdev))
> -				__vlan_hwaccel_clear_tag(skb);

If the DSA switch information is present in the VLAN hwaccel, and the
VLAN hwaccel is cleared, and that up until this change,
NETIF_F_HW_VLAN_CTAG_RX was not configurable, it means that every
mtk_soc_data with MTK_HW_FEATURES would be broken as a DSA master?

>  		}
>  
>  		skb_record_rx_queue(skb, 0);
> @@ -2847,15 +2840,17 @@ static netdev_features_t mtk_fix_features(struct net_device *dev,
>  
>  static int mtk_set_features(struct net_device *dev, netdev_features_t features)
>  {
> -	int err = 0;
> -
> -	if (!((dev->features ^ features) & NETIF_F_LRO))
> -		return 0;
> +	struct mtk_mac *mac = netdev_priv(dev);
> +	struct mtk_eth *eth = mac->hw;
> +	netdev_features_t diff = dev->features ^ features;
>  
> -	if (!(features & NETIF_F_LRO))
> +	if ((diff & NETIF_F_LRO) && !(features & NETIF_F_LRO))
>  		mtk_hwlro_netdev_disable(dev);
>  
> -	return err;
> +	/* Set RX VLAN offloading */
> +	mtk_w32(eth, !!(features & NETIF_F_HW_VLAN_CTAG_RX), MTK_CDMP_EG_CTRL);

Nit: do this only if (diff & NETIF_F_HW_VLAN_CTAG_RX).

> +
> +	return 0;
>  }
>  
>  /* wait for DMA to finish whatever it is doing before we start using it again */
> @@ -3176,6 +3171,15 @@ static int mtk_open(struct net_device *dev)
>  	else
>  		refcount_inc(&eth->dma_refcnt);
>  
> +	/* Hardware special tag parsing needs to be disabled if at least
> +	 * one MAC does not use DSA.
> +	 */

Don't understand why, sorry.

> +	if (!netdev_uses_dsa(dev)) {
> +		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
> +		val &= ~MTK_CDMP_STAG_EN;
> +		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
> +	}
> +
>  	phylink_start(mac->phylink);
>  	netif_tx_start_all_queues(dev);
>  
> @@ -3469,6 +3473,10 @@ static int mtk_hw_init(struct mtk_eth *eth)
>  	 */
>  	val = mtk_r32(eth, MTK_CDMQ_IG_CTRL);
>  	mtk_w32(eth, val | MTK_CDMQ_STAG_EN, MTK_CDMQ_IG_CTRL);
> +	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
> +		val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
> +		mtk_w32(eth, val | MTK_CDMP_STAG_EN, MTK_CDMP_IG_CTRL);
> +	}
>  
>  	/* Enable RX VLan Offloading */
>  	mtk_w32(eth, 1, MTK_CDMP_EG_CTRL);
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> index e09b2483c70c..26b2323185ef 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -93,6 +93,9 @@
>  #define MTK_CDMQ_IG_CTRL	0x1400
>  #define MTK_CDMQ_STAG_EN	BIT(0)
>  
> +/* CDMQ Exgress Control Register */
> +#define MTK_CDMQ_EG_CTRL	0x1404
> +
>  /* CDMP Ingress Control Register */
>  #define MTK_CDMP_IG_CTRL	0x400
>  #define MTK_CDMP_STAG_EN	BIT(0)
> -- 
> 2.38.1
> 
