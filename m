Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD2142A4C4
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbhJLMo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbhJLMo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 08:44:28 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AF4C061570;
        Tue, 12 Oct 2021 05:42:26 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r18so80741442edv.12;
        Tue, 12 Oct 2021 05:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=f0gz0/Asq8t/eUGODIPaUfnOamMHCPpxONGQ2bwYsgg=;
        b=oh5ZHhj7HPMp/m3yehJFBSfgfcNQlkB8b0gAAqyX53lDZvL753KDcBfHW+AFaoj61u
         9H98FmjAipM3qcY99+2nU9mZ/MWIE3uBl1E2C7fr6fgmThOvLE+dq9+seqDmqJ4b7Ik2
         LwHVQZCJRz+2PlPEB5mXfVRV1Kqb9yCt7KetZCtCzw+OXFQ0jg+B4IoSQjgB0HRrnGOF
         SIFeJdpPjAfWbtikzutSxBlfdvDCwmUo/8Ls26GywDjqyYewNmwfDzY4+fzSBNJN46m9
         stBdt+1Lr4AQmI4pWyECqhON3jki0CU/6Uvb+bPpb6ipVoIBrDmQD8rKtP527CnG2d8U
         MSXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=f0gz0/Asq8t/eUGODIPaUfnOamMHCPpxONGQ2bwYsgg=;
        b=BY5oWdOvOlXp+AM7kQPxypb73WyO+kwU163eU0R6kUZgmUFWzJt9A7X0ihQynjvLi9
         5n5W6iqAKLYyHcBYY9Gcv0C7uOYaZD7bFyOIPh9WBA42+eSi9xg6CWLbSiZoP6EIITXF
         ZhJe06R/xhR4oXOt9+AY7kVfhPnwUanwp5qNFh25PvnRsQE1e+FTisZEM4faaZbdMUEl
         Gp3tQNcjGhTEiGaEPzHmjPSci53HFe1O6nUNwDysnSXQAnCScB3mIt/SjjhADA7GoaBg
         9JJd2r7O8MiY4NxkjGuxfYtToEYEWxlJYJqbGRHyw6P5Q//GDU8yVe2YzAio/ocGLFg3
         dFAQ==
X-Gm-Message-State: AOAM532i/ZmGsD0GqBuUKV3BTgYRfl7L7g6Yx4ee542RiMN2xxHVpDlb
        0+uFZeC+EfhJCcZhR/k0ZbI=
X-Google-Smtp-Source: ABdhPJxG3HPmOXwcGid5gViw0o4QQqyTWKSLoR1IsTuBkX5hEzaVfcjYdqyo9H7cd3bRyfYEVADWAw==
X-Received: by 2002:a05:6402:1c85:: with SMTP id cy5mr26022958edb.281.1634042544819;
        Tue, 12 Oct 2021 05:42:24 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id v13sm4904358ejh.62.2021.10.12.05.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 05:42:24 -0700 (PDT)
Date:   Tue, 12 Oct 2021 15:42:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/6] net: dsa: move NET_DSA_TAG_RTL4_A to right
 place in Kconfig/Makefile
Message-ID: <20211012124222.hqbxal4xgelvfve7@skbuf>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
 <20211012123557.3547280-3-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211012123557.3547280-3-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 02:35:51PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Move things around a little so that this tag driver is alphabetically
> ordered. The Kconfig file is sorted based on the tristate text.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Another issue that can be treated separately is that LAN9303 is still
not in its alphabetic place.

> 
> RFC -> v1: this patch is new
> 
>  net/dsa/Kconfig  | 14 +++++++-------
>  net/dsa/Makefile |  2 +-
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index bca1b5d66df2..6c7f79e45886 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -92,13 +92,6 @@ config NET_DSA_TAG_KSZ
>  	  Say Y if you want to enable support for tagging frames for the
>  	  Microchip 8795/9477/9893 families of switches.
>  
> -config NET_DSA_TAG_RTL4_A
> -	tristate "Tag driver for Realtek 4 byte protocol A tags"
> -	help
> -	  Say Y or M if you want to enable support for tagging frames for the
> -	  Realtek switches with 4 byte protocol A tags, sich as found in
> -	  the Realtek RTL8366RB.
> -
>  config NET_DSA_TAG_OCELOT
>  	tristate "Tag driver for Ocelot family of switches, using NPI port"
>  	depends on MSCC_OCELOT_SWITCH_LIB || \
> @@ -130,6 +123,13 @@ config NET_DSA_TAG_QCA
>  	  Say Y or M if you want to enable support for tagging frames for
>  	  the Qualcomm Atheros QCA8K switches.
>  
> +config NET_DSA_TAG_RTL4_A
> +	tristate "Tag driver for Realtek 4 byte protocol A tags"
> +	help
> +	  Say Y or M if you want to enable support for tagging frames for the
> +	  Realtek switches with 4 byte protocol A tags, sich as found in
> +	  the Realtek RTL8366RB.
> +
>  config NET_DSA_TAG_LAN9303
>  	tristate "Tag driver for SMSC/Microchip LAN9303 family of switches"
>  	help
> diff --git a/net/dsa/Makefile b/net/dsa/Makefile
> index 67ea009f242c..f78d537044db 100644
> --- a/net/dsa/Makefile
> +++ b/net/dsa/Makefile
> @@ -10,12 +10,12 @@ obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
>  obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
>  obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
>  obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
> -obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
>  obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
>  obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
>  obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
>  obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
>  obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
> +obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
>  obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
>  obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
>  obj-$(CONFIG_NET_DSA_TAG_XRS700X) += tag_xrs700x.o
> -- 
> 2.32.0
> 
