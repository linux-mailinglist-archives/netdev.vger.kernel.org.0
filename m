Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F6662458B
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiKJPXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiKJPXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:23:08 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6A42982F;
        Thu, 10 Nov 2022 07:23:04 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id k8so2771206wrh.1;
        Thu, 10 Nov 2022 07:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YoCgFamZ3oP3JJYPHkOJA0uBjFMtT8J75ik2oCT1rQg=;
        b=aYV3Rzw0awhfLHPzJGRKmEZsraFFMvG5HcNQbcwsonQz+InXWFk+B4wRrNtct0YNij
         SkkC/Y+WsR+28Cd42kTW2qbWfYOv8hfwpKEAuAQU7u7AU+OvBQNCy1ywdfVts+z9o65o
         8pTmO6ARD09M32Lxiftf7G9sY7BAdzVAudm+dZVmHC++8x7sJC/0RPjEedxlIRtiPVrM
         XULKHcAoqnpbA7TgECDf/kihCfkmTGVjiTsVQ9GOeSokTCikzMpyMoeRn8bXoSAB6nj+
         3DPk7501J5NebFuICJWwwoqNghy/FjjpZBv9eSVjBfXgjJbkth3lQwUnUmvOjw4QedFl
         ABJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YoCgFamZ3oP3JJYPHkOJA0uBjFMtT8J75ik2oCT1rQg=;
        b=AKD+VruebBz/RJCsFqZd2jNi8F0JvFzQHyNs59ENdU1U8AU7kQzxs8SW3XAKLOHHtf
         rJiqi97O4sm5i3n8d40kVmni2KnE0nFcg9WKPOf4WnPdL510bB/r1dhg9QjJlHyEeP3e
         a/LRaLIT+UvCGR4NYrL7mqk0D6vprSLhGVbqCy1wCqPlBOBAx6X+3sULrppQBiLePUMw
         +8Om1MF7QZZvEpYKJqBDoYOb1NvXzlj2X3lTlQt8Xsm6zRDgkjhLLM4pfbHK93EhCh6U
         9U4ZTwDFHQXeZW+tjMNzLf3yIEInc8hsDPhwfTdGo7+UgLlZ4wz2q/0FvB+7E/JPP25/
         LO1A==
X-Gm-Message-State: ACrzQf1C9T5x/8hVuDjUeGrA7NXY6DSIYBH9wV8UPormoX9rFIhFCtTU
        wXI59uXopAXrj28ANQIM8UA=
X-Google-Smtp-Source: AMsMyM4iDoB01HTPXXbIEP8b+ehSx0hYzAy6B6zKR/jNfq7F9k6OYfd+M7wSUAGZnzhDSpSKMPhYsw==
X-Received: by 2002:adf:f081:0:b0:236:5e7c:4ec2 with SMTP id n1-20020adff081000000b002365e7c4ec2mr40657606wro.641.1668093782237;
        Thu, 10 Nov 2022 07:23:02 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id s12-20020adfeb0c000000b0023657e1b980sm16173719wrn.53.2022.11.10.07.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 07:23:01 -0800 (PST)
Date:   Thu, 10 Nov 2022 17:22:59 +0200
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
Subject: Re: [PATCH net-next v2 09/12] net: ethernet: mtk_eth_soc: fix VLAN
 rx hardware acceleration
Message-ID: <20221110152259.id5gg67wcy3pbart@skbuf>
References: <20221109163426.76164-1-nbd@nbd.name>
 <20221109163426.76164-1-nbd@nbd.name>
 <20221109163426.76164-10-nbd@nbd.name>
 <20221109163426.76164-10-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109163426.76164-10-nbd@nbd.name>
 <20221109163426.76164-10-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 05:34:23PM +0100, Felix Fietkau wrote:
> - enable VLAN untagging for PDMA rx
> - make it possible to disable the feature via ethtool
> - pass VLAN tag to the DSA driver
> - untag special tag on PDMA only if no non-DSA devices are in use
> - disable special tag untagging on 7986 for now, since it's not working yet

Each of these bullet points should be its own patch, really.
"Fix VLAN rx hardware acceleration" isn't doing much to describe them
and their motivation.

> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 99 ++++++++++++++++-----
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  8 ++
>  2 files changed, 84 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 92bdd69eed2e..ffaa9fe32b14 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -23,6 +23,7 @@
>  #include <linux/jhash.h>
>  #include <linux/bitfield.h>
>  #include <net/dsa.h>
> +#include <net/dst_metadata.h>
>  
>  #include "mtk_eth_soc.h"
>  #include "mtk_wed.h"
> @@ -2008,23 +2009,27 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
>  			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
>  
> -		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
> -			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
> -				if (trxd.rxd3 & RX_DMA_VTAG_V2)
> -					__vlan_hwaccel_put_tag(skb,
> -						htons(RX_DMA_VPID(trxd.rxd4)),
> -						RX_DMA_VID(trxd.rxd4));
> -			} else if (trxd.rxd2 & RX_DMA_VTAG) {
> -				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
> -						       RX_DMA_VID(trxd.rxd3));
> -			}
> +		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
> +			if (trxd.rxd3 & RX_DMA_VTAG_V2)
> +				__vlan_hwaccel_put_tag(skb,
> +					htons(RX_DMA_VPID(trxd.rxd4)),
> +					RX_DMA_VID(trxd.rxd4));
> +		} else if (trxd.rxd2 & RX_DMA_VTAG) {
> +			__vlan_hwaccel_put_tag(skb, htons(RX_DMA_VPID(trxd.rxd3)),
> +					       RX_DMA_VID(trxd.rxd3));
> +		}
> +
> +		/* When using VLAN untagging in combination with DSA, the
> +		 * hardware treats the MTK special tag as a VLAN and untags it.
> +		 */
> +		if (skb_vlan_tag_present(skb) && netdev_uses_dsa(netdev)) {
> +			unsigned int port = ntohs(skb->vlan_proto) & GENMASK(2, 0);
> +
> +			if (port < ARRAY_SIZE(eth->dsa_meta) &&
> +			    eth->dsa_meta[port])
> +				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);

Why _noref?

>  
> -			/* If the device is attached to a dsa switch, the special
> -			 * tag inserted in VLAN field by hw switch can * be offloaded
> -			 * by RX HW VLAN offload. Clear vlan info.
> -			 */
> -			if (netdev_uses_dsa(netdev))
> -				__vlan_hwaccel_clear_tag(skb);
> +			__vlan_hwaccel_clear_tag(skb);
>  		}
>  
>  		skb_record_rx_queue(skb, 0);
> @@ -2847,15 +2852,19 @@ static netdev_features_t mtk_fix_features(struct net_device *dev,
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
> +	if (diff & NETIF_F_HW_VLAN_CTAG_RX)
> +		mtk_w32(eth, !!(features & NETIF_F_HW_VLAN_CTAG_RX),
> +			MTK_CDMP_EG_CTRL);
> +
> +	return 0;
>  }
>  
>  /* wait for DMA to finish whatever it is doing before we start using it again */
> @@ -3137,11 +3146,45 @@ static int mtk_device_event(struct notifier_block *n, unsigned long event, void
>  	return NOTIFY_DONE;
>  }
>  
> +static bool mtk_uses_dsa(struct net_device *dev)
> +{
> +#if IS_ENABLED(CONFIG_NET_DSA)
> +	return netdev_uses_dsa(dev) &&
> +	       dev->dsa_ptr->tag_ops->proto == DSA_TAG_PROTO_MTK;
> +#else
> +	return false;
> +#endif
> +}

I see that the pattern of dumpster diving through DSA guts has already
made it into the mtk_eth_soc driver. A "nice" side effect is that now
you need to build the mtk_eth_soc driver as module when DSA is a module.

It would be possible to pass information about ports and their tagging
protocol in use via a new struct netdev_dsa_upper_info (similar to how
netdev_lag_upper_info is used). Since this is propagated via a netdev
notifier chain, no direct access to private DSA structures is performed,
and the mtk driver can cache from these notifiers only what DSA chooses
to expose.

What would this driver need to get rid of the dependency on symbols
exported by DSA (dsa_port_from_netdev)?

DSA can inform the master driver of the tagging protocol in use.
In turn, the master can write back some fields in the dsa_upper_info
structure, like bool rx_tag_offload, bool tx_tag_offload.

We could then make some optimizations, like add a static_branch key in
dsa_switch_rcv() if we know that the system uses DSA tag offloading, and
keep the code that processes skb_metadata_dst() turned off otherwise.

Such a mechanism would probably be needed in the TX direction anyway,
otherwise DSA has no way of knowing whether to create a metadata_dst or
not.

> +
>  static int mtk_open(struct net_device *dev)
>  {
>  	struct mtk_mac *mac = netdev_priv(dev);
>  	struct mtk_eth *eth = mac->hw;
> -	int err;
> +	int i, err;
> +
> +	if (mtk_uses_dsa(dev)) {
> +		for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
> +			struct metadata_dst *md_dst = eth->dsa_meta[i];
> +
> +			if (md_dst)
> +				continue;
> +
> +			md_dst = metadata_dst_alloc(0, METADATA_HW_PORT_MUX,
> +						    GFP_KERNEL);
> +			if (!md_dst)
> +				return -ENOMEM;
> +
> +			md_dst->u.port_info.port_id = i;
> +			eth->dsa_meta[i] = md_dst;
> +		}
> +	} else {
> +		/* Hardware special tag parsing needs to be disabled if at least
> +		 * one MAC does not use DSA.
> +		 */
> +		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
> +		val &= ~MTK_CDMP_STAG_EN;
> +		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
> +	}
>  
>  	err = phylink_of_phy_connect(mac->phylink, mac->of_node, 0);
>  	if (err) {
> @@ -3469,6 +3512,10 @@ static int mtk_hw_init(struct mtk_eth *eth)
>  	 */
>  	val = mtk_r32(eth, MTK_CDMQ_IG_CTRL);
>  	mtk_w32(eth, val | MTK_CDMQ_STAG_EN, MTK_CDMQ_IG_CTRL);
> +	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
> +		val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
> +		mtk_w32(eth, val | MTK_CDMP_STAG_EN, MTK_CDMP_IG_CTRL);
> +	}
>  
>  	/* Enable RX VLan Offloading */
>  	mtk_w32(eth, 1, MTK_CDMP_EG_CTRL);
> @@ -3686,6 +3733,12 @@ static int mtk_free_dev(struct mtk_eth *eth)
>  		free_netdev(eth->netdev[i]);
>  	}
>  
> +	for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
> +		if (!eth->dsa_meta[i])
> +			break;
> +		metadata_dst_free(eth->dsa_meta[i]);
> +	}

I don't like that metadata dst's are allocated in ndo_open() and freed
in platform_driver::remove(). It suggests memory leaks and worse.

I'm also not sure if you're using the API in the best way (metadata_dst_free()
seems to ignore all other references, have you considered dst_release())?

> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> index 146437ca044b..1c85fbad5bc1 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -22,6 +22,9 @@
>  #include <linux/bpf_trace.h>
>  #include "mtk_ppe.h"
>  
> +#define MTK_MAX_DSA_PORTS	7
> +#define MTK_DSA_PORT_MASK	GENMASK(2, 0)
> +
>  #define MTK_QDMA_NUM_QUEUES	16
>  #define MTK_QDMA_PAGE_SIZE	2048
>  #define MTK_MAX_RX_LENGTH	1536
> @@ -93,6 +96,9 @@
>  #define MTK_CDMQ_IG_CTRL	0x1400
>  #define MTK_CDMQ_STAG_EN	BIT(0)
>  
> +/* CDMQ Exgress Control Register */
> +#define MTK_CDMQ_EG_CTRL	0x1404
> +
>  /* CDMP Ingress Control Register */
>  #define MTK_CDMP_IG_CTRL	0x400
>  #define MTK_CDMP_STAG_EN	BIT(0)
> @@ -1149,6 +1155,8 @@ struct mtk_eth {
>  
>  	int				ip_align;
>  
> +	struct metadata_dst		*dsa_meta[MTK_MAX_DSA_PORTS];
> +
>  	struct mtk_ppe			*ppe[2];
>  	struct rhashtable		flow_table;
>  
> -- 
> 2.38.1
> 

