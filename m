Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DB836606B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhDTTwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:52:09 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:37446 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbhDTTwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 15:52:08 -0400
Received: by mail-ot1-f50.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso22821220otm.4;
        Tue, 20 Apr 2021 12:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=91fi6dwzAdBY2nGUmibCb/N6XGFP0Q1yBnL6rpHM38c=;
        b=arcJxCAllwSuqeP1flnenvyC3sZblM/fULlEZVqdRn1Zm4mwdQXejWEnTLB/zKw4Wv
         T2CY1+3i/tXP4EkofyUP6v7/h4U2Cn0AvsRd6vLf2g4KvVqOjaHjcmchiCdZEeGevxLU
         sndkhIqk1l92EYfR0W1l+R3EMd6wUu4TrU/JhuzJJbwyITjQCL8Zm9YoBtehhhopUZsw
         5p+GI4/K6fcP0dEidKNy8VE8UloYUmzswXMVYEHjuZAuye+g0GvaVnD0yMi51kNCYvRK
         fyVVcbf6wjC9gu5IELNA3UA4dxwHTzH9BFjqPWz8b+vRJZlOzQumFFxUWY5Ajp+lu80z
         xykg==
X-Gm-Message-State: AOAM532tIket7OqDlghzOMtd9cD6JzUi0lW0up6EY/NArCmYTc+tBdIg
        DFO1bKJYLUZqm+zjvxRA/w==
X-Google-Smtp-Source: ABdhPJyDOyHsUaTNR8GhgpoBM5E9nKGrXLHVqaHZkgjU1rUdcTZ12QClh2TVTRdYZKw3WqsuwQxNbA==
X-Received: by 2002:a9d:628f:: with SMTP id x15mr5024183otk.186.1618948295051;
        Tue, 20 Apr 2021 12:51:35 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id w141sm3757oie.5.2021.04.20.12.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 12:51:34 -0700 (PDT)
Received: (nullmailer pid 3704908 invoked by uid 1000);
        Tue, 20 Apr 2021 19:51:32 -0000
Date:   Tue, 20 Apr 2021 14:51:32 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next v2 2/2] net: ethernet: mediatek: support custom
 GMAC label
Message-ID: <20210420195132.GA3686955@robh.at.kernel.org>
References: <20210419154659.44096-1-ilya.lipnitskiy@gmail.com>
 <20210419154659.44096-3-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210419154659.44096-3-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 08:46:59AM -0700, Ilya Lipnitskiy wrote:
> The MAC device name can now be set within DTS file instead of always
> being "ethX". This is helpful for DSA to clearly label the DSA master
> device and distinguish it from DSA slave ports.
> 
> For example, some devices, such as the Ubiquiti EdgeRouter X, may have
> ports labeled ethX. Labeling the master GMAC with a different prefix
> than DSA ports helps with clarity.
> 
> Suggested-by: René van Dorst <opensource@vdorst.com>
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 6b00c12c6c43..df3cda63a8c5 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2845,6 +2845,7 @@ static const struct net_device_ops mtk_netdev_ops = {
>  
>  static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
>  {
> +	const char *label = of_get_property(np, "label", NULL);
>  	const __be32 *_id = of_get_property(np, "reg", NULL);
>  	phy_interface_t phy_mode;
>  	struct phylink *phylink;
> @@ -2867,9 +2868,10 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
>  		return -EINVAL;
>  	}
>  
> -	eth->netdev[id] = alloc_etherdev(sizeof(*mac));
> +	eth->netdev[id] = alloc_netdev(sizeof(*mac), label ? label : "eth%d",
> +				       NET_NAME_UNKNOWN, ether_setup);

'label' is generally supposed to correspond to the sticker for the 
device connector for a human to id. I can't really tell if that's the 
case here. I don't see how 'gmacX' vs. 'ethX' maps to DSA master vs. 
slave.

I don't think this should be handled within a specific driver either. If 
we're going to have a way to name things, then fix it in 
alloc_etherdev().

It can also be argued that device naming for userspace is a userspace 
(udev) problem. 

Rob
