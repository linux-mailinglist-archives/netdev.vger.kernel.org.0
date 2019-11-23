Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6053D107BEA
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKWANr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:13:47 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40070 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfKWANr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:13:47 -0500
Received: by mail-lj1-f195.google.com with SMTP id q2so9298972ljg.7
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 16:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oAs+JmaUc1Xh8VoI1jiWKg76cgJyN1N3rWvMjoZ0nq8=;
        b=gnatq38egwfsVsw2BzsFmBCBQcs8n9IkycpMvXuq2eLUlvy2PwloYud/QHy6EGlYTr
         k+HMaiL8bN6v5a8ibCUmUmn8bV8thSFTzwDNLFPV1mC1JXRCnZ2pGAYea8MpYipWv0O4
         8p2MvvQ7WBITx02PZqfUN3XBixyzQc/nZUBfzQFOmcUg7Mr5XFR6okvxGCnW8ubOh1Jl
         Oh4DN+oZ4BoJU6N0xAlzA7vA901Dg7F5ceAqceITJfvUq6QEaYKWuPnDSsd0f0hdyozY
         PlrhuAIno/bYK/1hr/FOS6bcAlKTExb1dYlqSOEW1TI61EzVwUVeKfvE/zhIxEND953e
         aP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oAs+JmaUc1Xh8VoI1jiWKg76cgJyN1N3rWvMjoZ0nq8=;
        b=FlhGpDdHrbUiceGXHtGOUk7q8TbEjW3vm/nIyMSemaJ+f/s2dpiK2lKXfVKb+66VQd
         JvDRYnvs518yzEG3nohorWuiD4s4qltukDxb/ug3nD4ruKIPFTwUkXUCyu8JpOREox4M
         OTL6JYEtT5iA1mo7MvjQctVkgLd6uU4ULcJNDNZWC1XK6GZSgcB33raS4claHZrteJfU
         2qYGXv7DpOpVg2qdW9fieYcn3BHB9HNj3XWhGPLzi1lvjJzTklnHrnFmhKDkt5UtOvdH
         aKpQhKj4SIG2LFDB3hTHNJwz9Y5h6BhFqEz/wj5DtEnVkvlf6y1lWf27nraz0J0zVSNN
         UcOA==
X-Gm-Message-State: APjAAAUb9+Z9uovBqfWXC2PjCpS7E/L/ysirA5ozJqp0PIj7Oh0CXwv5
        VURj3Jyc2E+zQ2gz8XVUxr1MrA==
X-Google-Smtp-Source: APXvYqzeVIH51PikCC6VhqxCzxBFnRWouvto6+gBS/fJ5YpWjBpJ2e+rCz3sOv6+yMo0plhRphEx7g==
X-Received: by 2002:a2e:8518:: with SMTP id j24mr13089598lji.13.1574468024093;
        Fri, 22 Nov 2019 16:13:44 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z12sm3789202lfi.84.2019.11.22.16.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:13:43 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:13:34 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v2 2/3] cxgb4: add UDP segmentation offload
 support
Message-ID: <20191122161334.44de6174@cakuba.netronome.com>
In-Reply-To: <1638e6bdd3aa9a4536aaeb644418d2a0ff5e5368.1574383652.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
        <1638e6bdd3aa9a4536aaeb644418d2a0ff5e5368.1574383652.git.rahul.lakkireddy@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 06:30:02 +0530, Rahul Lakkireddy wrote:
> Implement and export UDP segmentation offload (USO) support for both
> NIC and MQPRIO QoS offload Tx path. Update appropriate logic in Tx to
> parse GSO info in skb and configure FW_ETH_TX_EO_WR request needed to
> perform USO.
> 
> v2:
> - Remove inline keyword from write_eo_udp_wr() in sge.c. Let the
>   compiler decide.
> 
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> index 76538f4cd595..f57457453561 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> @@ -91,6 +91,7 @@ static const char stats_strings[][ETH_GSTRING_LEN] = {
>  	"rx_bg3_frames_trunc    ",
>  
>  	"tso                    ",
> +	"uso                    ",

Oh wow, the spaces, people's inventiveness when it comes to ethtool free
form strings knows no bounds..

That's not a review comment, I just wanted to say that :)

>  	"tx_csum_offload        ",
>  	"rx_csum_good           ",
>  	"vlan_extractions       ",

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> index e8a1826a1e90..12ff69b3ba91 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> @@ -1136,11 +1136,17 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
>  
>  	if (dev->num_tc) {
>  		struct port_info *pi = netdev2pinfo(dev);
> +		u8 ver, proto;
> +
> +		ver = ip_hdr(skb)->version;
> +		proto = (ver == 6) ? ipv6_hdr(skb)->nexthdr :
> +				     ip_hdr(skb)->protocol;

Checking ip version now looks potentially like a fix?

>  		/* Send unsupported traffic pattern to normal NIC queues. */
>  		txq = netdev_pick_tx(dev, skb, sb_dev);
>  		if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
> -		    ip_hdr(skb)->protocol != IPPROTO_TCP)
> +		    skb->encapsulation ||

The addition of encapsulation check also looks unrelated? 

> +		    (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
>  			txq = txq % pi->nqsets;
>  
>  		return txq;
> @@ -5838,7 +5844,8 @@ static void free_some_resources(struct adapter *adapter)
>  		t4_fw_bye(adapter, adapter->pf);
>  }
>  
> -#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN)
> +#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN | \
> +		   NETIF_F_GSO_UDP_L4)
>  #define VLAN_FEAT (NETIF_F_SG | NETIF_F_IP_CSUM | TSO_FLAGS | \
>  		   NETIF_F_GRO | NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA)
>  #define SEGMENT_SIZE 128
