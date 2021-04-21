Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E1F367057
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241939AbhDUQlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241399AbhDUQk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 12:40:56 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76702C06174A;
        Wed, 21 Apr 2021 09:40:21 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id d10so30403814pgf.12;
        Wed, 21 Apr 2021 09:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CLHwhKyipeOdMEUwSlBPKOFTL7ssHwYscZIWDf/tAUo=;
        b=D0FmzH805R9NP7K4Nkb0LBVvN9k0GaA82gGttudQT/kHCeFEWVKn75VyicvN+x6QxY
         KI7fQgeRMmA7ByEb2nRZkDuf3ri8Nruk9910gJqNTwcSWph/CJwmmDRRPBOHRERfHsmk
         6mdvTEtDXEoRmedkyLsZ8kiDHat3aV8/pfdK65yvH3OZKoXQHcU88yAnqDBEIg2zFQXK
         IYqL1hzK29GY4ZjxJOkoisjseVBs8Ut9XMdT/I6QPiu2NBXGqNNSTbiT2Q3doZ4J95Ig
         uPZ3pw931XGutzQgSJIxwqTj+TwXLiOQ0/zcv1zHQXGw0lAf7J6UC+tAUxiEogerw/78
         0RxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CLHwhKyipeOdMEUwSlBPKOFTL7ssHwYscZIWDf/tAUo=;
        b=X0rvASA2afkUciRom4huG+x+jnYagxGZ9TQwuJ45AoOJjMQnpM15oP2bVd6hpzbQ67
         4NZTScLjS/E2HJPMQRWRy41VCouYfRsVbdzkyykShdI4deDbbUcTpY7dqxtBAFHLodUJ
         yF+RvhxHyen8IBDTY+BhSdTsode7z32sxqxcMbvymzrNlBOujpJA9i3D32BCEAkx4+yA
         ftDdGCVYJ85sMVm4KquCQ0dKFVtIm2aoDwES6UUf15D64M2/TJBzo8mint9+DvxSxyMf
         Pb8k7F90OkcUo0qsvHoHZG9Wo3Pq+L9z6YEutFZzhcxCW0RBYRTanKQV747I5vuuHQ85
         j+fw==
X-Gm-Message-State: AOAM531G19o1io/KcLmOanmWdhGxJtp88BMMiBaEU7m+0I5Ow4CSWOew
        S3kFTsGIrNi4HNZijDnoX1I=
X-Google-Smtp-Source: ABdhPJxR2Q27DJhcnBTiO0nrP0VQ2wX4zj5cBYj9fAOWVbtRgpBU4VesU42lybe6GmMPFmop45xceg==
X-Received: by 2002:a17:90b:19d1:: with SMTP id nm17mr12028957pjb.218.1619023220996;
        Wed, 21 Apr 2021 09:40:20 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id 195sm2180413pfy.194.2021.04.21.09.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 09:40:20 -0700 (PDT)
Date:   Wed, 21 Apr 2021 19:40:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1] net: dsa: fix bridge support for drivers
 without port_bridge_flags callback
Message-ID: <20210421164009.jylcxlab2evi2gcr@skbuf>
References: <20210421130540.12522-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421130540.12522-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 03:05:40PM +0200, Oleksij Rempel wrote:
> Starting with patch:
> a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
> 
> drivers without "port_bridge_flags" callback will fail to join the bridge.
> Looking at the code, -EOPNOTSUPP seems to be the proper return value,
> which makes at least microchip and atheros switches work again.
> 
> Fixes: a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  net/dsa/port.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 01e30264b25b..6379d66a6bb3 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -550,7 +550,7 @@ int dsa_port_bridge_flags(const struct dsa_port *dp,
>  	struct dsa_switch *ds = dp->ds;
>  
>  	if (!ds->ops->port_bridge_flags)
> -		return -EINVAL;
> +		return -EOPNOTSUPP;
>  
>  	return ds->ops->port_bridge_flags(ds, dp->index, flags, extack);
>  }
> -- 
> 2.29.2
> 

The Fixes: tag should be:

Fixes: 5961d6a12c13 ("net: dsa: inherit the actual bridge port flags at join time")

What we return to the bridge is -EINVAL, via dsa_port_pre_bridge_flags()
(it is a two-step calling convention thing). But dsa_port_bridge_flags()
should never return that -EINVAL to the bridge, because the bridge
should just stop if the "pre" call returned an error.

So the -EINVAL return value from dsa_port_bridge_flags() is just for
callers who don't bother to call "pre".

To be honest I don't know why I wrote dsa_port_inherit_brport_flags this
way. It might be better to just do:

-----------------------------[cut here]-----------------------------
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 01e30264b25b..d5e227a77fbc 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -138,8 +138,12 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
 		if (br_port_flag_is_set(brport_dev, BIT(flag)))
 			flags.val = BIT(flag);
 
+		err = dsa_port_pre_bridge_flags(dp, flags, extack);
+		if (err == -EINVAL)
+			continue;
+
 		err = dsa_port_bridge_flags(dp, flags, extack);
-		if (err && err != -EOPNOTSUPP)
+		if (err)
 			return err;
 	}
 
@@ -159,8 +163,12 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
 		flags.mask = BIT(flag);
 		flags.val = val & BIT(flag);
 
+		err = dsa_port_pre_bridge_flags(dp, flags, NULL);
+		if (err == -EINVAL)
+			continue;
+
 		err = dsa_port_bridge_flags(dp, flags, NULL);
-		if (err && err != -EOPNOTSUPP)
+		if (err)
 			dev_err(dp->ds->dev,
 				"failed to clear bridge port flag %lu: %pe\n",
 				flags.val, ERR_PTR(err));
-----------------------------[cut here]-----------------------------
