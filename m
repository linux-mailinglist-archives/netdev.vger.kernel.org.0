Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B4221DCBD
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgGMQeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730098AbgGMQeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:34:20 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB8FC061755;
        Mon, 13 Jul 2020 09:34:20 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g20so14250772edm.4;
        Mon, 13 Jul 2020 09:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V6b1O4MyWF2YQ9VWkwh6P/hFU91Nmi+FIyFbjRLkhJI=;
        b=cFumKTxl7VcmaHbAmDbBuCFeyS5aaYGlic1hGm6OQg2qB3yegdxJsgVF0Od3kh35LV
         SHFqfesglpBzFaNn6nxDG1W75nr6xkpXL/IBk5XRCppee6h1j6w7w+I3gcp2BiHlZqtD
         h5qHVPpH6TN63txgza3zdYKERIwME3ryejipcwnPQ3RuVJrktXl32qr03GMqf6cxoIdo
         B+6j1DKD6rcmpzv75ZIMO09KLU3m2PFGg7GUN5zPRlp0VinPJrLE6RKKjh/ELGR5c0Mn
         8eM5aPDoBHuhT1s6k/8pciqXW/+VrFUjpF1j0mEAHJa2PhNeA2C1aVClOjo/jGxU64m3
         iMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V6b1O4MyWF2YQ9VWkwh6P/hFU91Nmi+FIyFbjRLkhJI=;
        b=RdUms0Bgslslpqw7OxNFmFUyUc/SJks2EC+9NjHXHzoXWKwvSqwdZBcL0iUuN/yzVu
         /CI/s+G0cSbjeMSaN2TDty0P0jGphTsi4z+n+r65fdBh7v8nYcini+FEicTLyePU6y9d
         f3QgX55tsjDCTwz+WEY+Mq9yeIUfepawWC0QXLkuoTOWqqt9Ng/USw4xPQ42Q7Zbhjsh
         mg3fdIpEzRv1D4OAOQg3/nCbRUGbr8qLU5bjVApgDOgloOQUoEw8RkvajOalKYDYi2+F
         E2m3mjuzRwAEGEYD/6Icn8nPJC0D6E17c/YK1fxQ644iCqH9Jias0ZHUazVTYiHsEyZf
         wMvw==
X-Gm-Message-State: AOAM53324OJKTkzfi/QNVHdWD1R9WBHnEudFQkGyOFm5L2jzvHoA4/79
        HpPkp4kk91g8s+Ks6AcSfIE=
X-Google-Smtp-Source: ABdhPJyyyZn1l+Y7K+tZsJbus/U2Qm7dTtd/iJwlnnpbKEDamQ3eqqvII8Uhw9ahUjrQQi0gZ1800A==
X-Received: by 2002:aa7:cf94:: with SMTP id z20mr283749edx.82.1594658059250;
        Mon, 13 Jul 2020 09:34:19 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id yj16sm9653772ejb.122.2020.07.13.09.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:34:18 -0700 (PDT)
Date:   Mon, 13 Jul 2020 19:34:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v6 1/4] net: phy: add USXGMII link partner
 ability constants
Message-ID: <20200713163416.3fegjdbrp6ccoqdm@skbuf>
References: <20200709213526.21972-1-michael@walle.cc>
 <20200709213526.21972-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709213526.21972-2-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:35:23PM +0200, Michael Walle wrote:
> The constants are taken from the USXGMII Singleport Copper Interface
> specification. The naming are based on the SGMII ones, but with an MDIO_
> prefix.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Somebody would need to review this patch, as it is introducing UAPI.

>  include/uapi/linux/mdio.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
> index 4bcb41c71b8c..784723072578 100644
> --- a/include/uapi/linux/mdio.h
> +++ b/include/uapi/linux/mdio.h
> @@ -324,4 +324,30 @@ static inline __u16 mdio_phy_id_c45(int prtad, int devad)
>  	return MDIO_PHY_ID_C45 | (prtad << 5) | devad;
>  }
>  
> +/* UsxgmiiChannelInfo[15:0] for USXGMII in-band auto-negotiation.*/
> +#define MDIO_LPA_USXGMII_EEE_CLK_STP	0x0080	/* EEE clock stop supported */
> +#define MDIO_LPA_USXGMII_EEE		0x0100	/* EEE supported */
> +#define MDIO_LPA_USXGMII_SPD_MASK	0x0e00	/* USXGMII speed mask */
> +#define MDIO_LPA_USXGMII_FULL_DUPLEX	0x1000	/* USXGMII full duplex */
> +#define MDIO_LPA_USXGMII_DPX_SPD_MASK	0x1e00	/* USXGMII duplex and speed bits */
> +#define MDIO_LPA_USXGMII_10		0x0000	/* 10Mbps */
> +#define MDIO_LPA_USXGMII_10HALF		0x0000	/* 10Mbps half-duplex */
> +#define MDIO_LPA_USXGMII_10FULL		0x1000	/* 10Mbps full-duplex */
> +#define MDIO_LPA_USXGMII_100		0x0200	/* 100Mbps */
> +#define MDIO_LPA_USXGMII_100HALF	0x0200	/* 100Mbps half-duplex */
> +#define MDIO_LPA_USXGMII_100FULL	0x1200	/* 100Mbps full-duplex */
> +#define MDIO_LPA_USXGMII_1000		0x0400	/* 1000Mbps */
> +#define MDIO_LPA_USXGMII_1000HALF	0x0400	/* 1000Mbps half-duplex */
> +#define MDIO_LPA_USXGMII_1000FULL	0x1400	/* 1000Mbps full-duplex */
> +#define MDIO_LPA_USXGMII_10G		0x0600	/* 10Gbps */
> +#define MDIO_LPA_USXGMII_10GHALF	0x0600	/* 10Gbps half-duplex */
> +#define MDIO_LPA_USXGMII_10GFULL	0x1600	/* 10Gbps full-duplex */
> +#define MDIO_LPA_USXGMII_2500		0x0800	/* 2500Mbps */
> +#define MDIO_LPA_USXGMII_2500HALF	0x0800	/* 2500Mbps half-duplex */
> +#define MDIO_LPA_USXGMII_2500FULL	0x1800	/* 2500Mbps full-duplex */
> +#define MDIO_LPA_USXGMII_5000		0x0a00	/* 5000Mbps */
> +#define MDIO_LPA_USXGMII_5000HALF	0x0a00	/* 5000Mbps half-duplex */
> +#define MDIO_LPA_USXGMII_5000FULL	0x1a00	/* 5000Mbps full-duplex */
> +#define MDIO_LPA_USXGMII_LINK		0x8000	/* PHY link with copper-side partner */
> +
>  #endif /* _UAPI__LINUX_MDIO_H__ */
> -- 
> 2.20.1
> 
