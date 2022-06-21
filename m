Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E3E55320E
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 14:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349544AbiFUMar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 08:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350439AbiFUMaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 08:30:46 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3C618370;
        Tue, 21 Jun 2022 05:30:45 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id lw20so4814007ejb.4;
        Tue, 21 Jun 2022 05:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2ZYvUIcPgesioC1hHyPm1FyQnzg/VK05K3ea5CbvoAI=;
        b=jNp41uoNzsAu3KCvjI4Nfor3aDBFae+DB8Eqw6W0JhbiGt/c9vk8o9vL5xRzQ9Jvp1
         rYCapUAOPHft/MoL2MqYagXIqie8dNT/R0gSwNKkLtfRZL8mVCkjEBcIQiGe0yL3Cec9
         0KPOK2Dq9Xd44xXyW6b00Pv2zTOFR5fPnUFVuphV+XsQRm6LgzVaPuo/fgdKWLv9/9K0
         pTlA3alMY6x7azXuYNv62i3zG9OQMIyNW5aRcXQ1lP73uVf1W/+Hx2NpMjoyHGZtt5zM
         mgMAyGh3AGCzmOYfJ3rGJeUuQgec1Kl2UBuDaXuHVgV6z+C28bwxJCutMASzF4OJISsC
         pSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2ZYvUIcPgesioC1hHyPm1FyQnzg/VK05K3ea5CbvoAI=;
        b=IFpVu32VQzj1DAI3HlHc5uzY8jOIYyYMlP934YGC+wZ/LuZnKk+MJ4o9xozNGNgq4d
         52E042LcZKtNx8JTd2Pxc7WmaR2rW13vXO0/q+ZE1rUjR/chKhCwA1oLEtdrclaE3t4+
         4CZIkzhL4H0YK2J95wzpySxufb4Q2BNDtE/rDuUqJ8WEJRcN0pakNd/ROFyOwZergACC
         Ij7NBcJIeFTaLaapSJbALb+Yd/DHeJ9qHgdIQ4Ql7K9ortgPLwTfReDbhD6+2BgAJpCx
         cIdWxBzdj/otVdOg99ZHvw419V4+yt5k6MVs9/kg58B6t8UDCxV/9TobTjMuQSU9mk7y
         9tKA==
X-Gm-Message-State: AJIora9kCZBjT80J3Cw7noH/nfelE6u8x4tkpwRtqaSgozl3aF4OMG8c
        rI116lgxl+djcm9HGUeKvic=
X-Google-Smtp-Source: AGRyM1t5NP4Q7+ftb2gJ7eSdql5QKW81iclkgSphg0N6stK85m/Ambr9NA+IC8N/ADX7v2BeuIf42g==
X-Received: by 2002:a17:906:e2d2:b0:704:81fe:3152 with SMTP id gr18-20020a170906e2d200b0070481fe3152mr25004748ejb.411.1655814643924;
        Tue, 21 Jun 2022 05:30:43 -0700 (PDT)
Received: from skbuf ([188.25.159.210])
        by smtp.gmail.com with ESMTPSA id f5-20020a50fe05000000b004356afc7009sm8695130edt.59.2022.06.21.05.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 05:30:43 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:30:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: dsa: qca8k: change only max_frame_size of
 mac_frame_size_reg
Message-ID: <20220621123041.6y7rre26iqhhwdoa@skbuf>
References: <20220618062300.28541-1-ansuelsmth@gmail.com>
 <20220618062300.28541-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220618062300.28541-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 18, 2022 at 08:22:59AM +0200, Christian Marangi wrote:
> Currently we overwrite the entire MAX_FRAME_SIZE reg instead of tweaking
> just the MAX_FRAME_SIZE value. Change this and update only the relevant
> bits.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 8 ++++++--
>  drivers/net/dsa/qca8k.h | 3 ++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 2727d3169c25..eaaf80f96fa9 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -2345,7 +2345,9 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  		return 0;
>  
>  	/* Include L2 header / FCS length */
> -	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
> +	return regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
> +				  QCA8K_MAX_FRAME_SIZE_MASK,
> +				  new_mtu + ETH_HLEN + ETH_FCS_LEN);
>  }
>  
>  static int
> @@ -3015,7 +3017,9 @@ qca8k_setup(struct dsa_switch *ds)
>  	}
>  
>  	/* Setup our port MTUs to match power on defaults */
> -	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
> +	ret = regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
> +				 QCA8K_MAX_FRAME_SIZE_MASK,
> +				 ETH_FRAME_LEN + ETH_FCS_LEN);
>  	if (ret)
>  		dev_warn(priv->dev, "failed setting MTU settings");
>  
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index ec58d0e80a70..1d0c383a95e7 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -87,7 +87,8 @@
>  #define   QCA8K_MDIO_MASTER_MAX_REG			32
>  #define QCA8K_GOL_MAC_ADDR0				0x60
>  #define QCA8K_GOL_MAC_ADDR1				0x64
> -#define QCA8K_MAX_FRAME_SIZE				0x78
> +#define QCA8K_MAX_FRAME_SIZE_REG			0x78
> +#define   QCA8K_MAX_FRAME_SIZE_MASK			GENMASK(13, 0)

What's at bits 14 and beyond? Trying to understand the impact of this change.

>  #define QCA8K_REG_PORT_STATUS(_i)			(0x07c + (_i) * 4)
>  #define   QCA8K_PORT_STATUS_SPEED			GENMASK(1, 0)
>  #define   QCA8K_PORT_STATUS_SPEED_10			0
> -- 
> 2.36.1
> 
