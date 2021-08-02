Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0049A3DDACC
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhHBOVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbhHBOVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:21:21 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74A5C04F9DF;
        Mon,  2 Aug 2021 07:03:48 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id hs10so22417950ejc.0;
        Mon, 02 Aug 2021 07:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0bXYYFxnPNO/pfVOuHPYq234tNtoiCmbBf5FY6WnzcY=;
        b=gF+P7SG+HU/CPCXEKbyr0lhYPJye9fBFTeL8MkHOoRaP6w1e0y9P9M8hCyCZdmGAQP
         Z9+dVmclWpgw7Nwun4ijCspO7ovs6kHM6rc2VbURh3LY7UGQKJUz67czG+6Shr5SmYS6
         dZutluxuLBsDjrRgCoZdXIIXqb+WsI0ZvQOg8HbaSB0wBx4JpjnKgLz82r1jZ42WIESZ
         H5eNsCvEZpd3zRQDcCbTB89pAVn4SdMIq6VNkxeYQMgWlz1tA4psUF/Pc/QgK52TSkv4
         NoWN1raFLTpGxI3DjYDE00bokD1+Tv0K8SzpTofl8yFpqg6+oEwxMgAeitGRh+arqhym
         XVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0bXYYFxnPNO/pfVOuHPYq234tNtoiCmbBf5FY6WnzcY=;
        b=cb1L8WqDy1jJn89eL3nRIaqlry/g8GnW7y8I6TaN8KAf3/cnPGKNMsisyutaEcSmXu
         LQ+wV48RhC2ehl9yJsgDZIc57DTH8WcgLymw4faB1CMSgC/mr9d6D/7l1uq/JvzpjhkO
         DyqpHTT5Xo7wA2rYFrd2C8NOLiAaur7Sd4hjLqv4ogJ2y9+/n+xuqiL14fqkUhGU9FH3
         mMM8da3S97FBbCPac1bIMPtPucnbtAnj4g9GXgZk03wCpSLabHDKIbabjNIB1bTQZTXV
         se0PCk/+qAVtKAiazxhJpRhdAGbaKxyx7hOHNy9YpZaYecIPuMuaX4a5pGFYW6oBbwBN
         IVUA==
X-Gm-Message-State: AOAM531eSwEYYHme5PwOihiz6meWLv7Ok6uxT16rY9p00r0E77s0KwVe
        A4XPqHYzdcO8FVNFOoyfB8Q=
X-Google-Smtp-Source: ABdhPJz6iXuV0MbF3osxSbgv0YC9e+4XP9MJeLdKWZ6/jYQkjqdbWVTSg2aSSQs6aPrpaVmf93H1cQ==
X-Received: by 2002:a17:906:4b18:: with SMTP id y24mr15240708eju.42.1627913027313;
        Mon, 02 Aug 2021 07:03:47 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id g8sm6170879edw.89.2021.08.02.07.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 07:03:47 -0700 (PDT)
Date:   Mon, 2 Aug 2021 17:03:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/6] net: dsa: qca: ar9331: make proper
 initial port defaults
Message-ID: <20210802140345.zreovwix6nuyjwjy@skbuf>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
 <20210802131037.32326-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802131037.32326-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 03:10:33PM +0200, Oleksij Rempel wrote:
> Make sure that all external port are actually isolated from each other,
> so no packets are leaked.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/qca/ar9331.c | 109 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 108 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index 6686192e1883..2f5673ea3140 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -60,10 +60,20 @@
>  
>  #define AR9331_SW_REG_FLOOD_MASK		0x2c
>  #define AR9331_SW_FLOOD_MASK_BROAD_TO_CPU	BIT(26)
> +#define AR9331_SW_FLOOD_MASK_MULTI_FLOOD_DP	GENMASK(20, 16)
> +#define AR9331_SW_FLOOD_MASK_UNI_FLOOD_DP	GENMASK(4, 0)
>  
>  #define AR9331_SW_REG_GLOBAL_CTRL		0x30
>  #define AR9331_SW_GLOBAL_CTRL_MFS_M		GENMASK(13, 0)
>  
> +#define AR9331_SW_REG_ADDR_TABLE_CTRL		0x5c
> +#define AR9331_SW_AT_ARP_EN			BIT(20)
> +#define AR9331_SW_AT_LEARN_CHANGE_EN		BIT(18)
> +#define AR9331_SW_AT_AGE_EN			BIT(17)
> +#define AR9331_SW_AT_AGE_TIME			GENMASK(15, 0)
> +/* AGE_TIME_COEF is not documented. This is "works for me" value */
> +#define AR9331_SW_AT_AGE_TIME_COEF		6900

Not documented, not used either, it seems.
"Works for you" based on what?

> +
>  #define AR9331_SW_REG_MDIO_CTRL			0x98
>  #define AR9331_SW_MDIO_CTRL_BUSY		BIT(31)
>  #define AR9331_SW_MDIO_CTRL_MASTER_EN		BIT(30)
> @@ -101,6 +111,46 @@
>  	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
>  	 AR9331_SW_PORT_STATUS_SPEED_M)

Is this patch material for "net"? If standalone ports is all that ar9331
supports, then it would better not do packet forwarding in lack of a
bridge device.
