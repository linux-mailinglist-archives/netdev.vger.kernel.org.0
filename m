Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFB046A4ED
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347553AbhLFSxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhLFSxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:53:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC5EC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 10:50:11 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r11so46691119edd.9
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 10:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n71lfPvsxvn3TFJduCtLrXpjWasGk+AGR3BBfi4DnIM=;
        b=KlJzS19ps0774mXWUhYNw96xpswUtpf3KBkALs+FYxpIjt03kTHmqevZ7NCa2bZgdd
         EJXrapYTEGyzVzAJrJYFXbL/PXOgdsYUFTNvrQFH9vzRbmDY41GzweJDElltx6FKtdEr
         HNMvQMuhh2y/M8u1Pyd3+v7I2C0dKosrc1zM7Vy8bdewI72yyY2M+i0SLvWIp1NZBYhs
         MhF9DAfpsF3yDsnq3tHF/xpQs/Sl7rMkPOGe2DaZE3Yat1ZJGbYHtoJmpd/azFmC6KfX
         81KqrENIOtBhJ456jNx7dL/MFjXIItC0XZKv2OUvydMlAgwmpPFNtPXVCXCDxhYcZ+nE
         ueaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n71lfPvsxvn3TFJduCtLrXpjWasGk+AGR3BBfi4DnIM=;
        b=G3gY4KVf5ETieyXnUuzdKJ+ig2rpDMmK84D4XIRGL4LzecKoekvNa1RmRHXPuFEdUm
         v7fPK4aGEjCCA/iokwkA1l3uj/qkWYD/8YOnDMVTLnMWKqpT+v+zmF6+nx8XcoxzR82C
         kxm5f8uY43LGVXIr6CZh7RO5BO8lj1pfCbk0SYQ6Cjqi/c1ULzhs9xtVhCz8V+VrmoX4
         CA6Ssr5bQTel28ezYmGa30cf2dlcQTM145cZScMXAd7tzS6kpRrqO7arcQley2yBCXSG
         1RHxcQLuMOSLMKufFbbOiUhuUAU/qfNmWA22Nocel8+cKgmC5hXV/1WyPghK2sp+4xGC
         Atxw==
X-Gm-Message-State: AOAM530kuWM5qQvO/c33+f+7c3M+6zVT/Fm40bLHNPRYszgb1rEnpHuz
        N/7j/AMxVud7iYfsawvjJEu4qFGp4Fk=
X-Google-Smtp-Source: ABdhPJw+KCZdSaVdh0LP4Z+SI8lrzuWQbfz3RNXnQ1Kdkj5MB18Po1jsm96MVimXnGFZhocU9i0kGw==
X-Received: by 2002:a17:906:938f:: with SMTP id l15mr48044507ejx.302.1638816610123;
        Mon, 06 Dec 2021 10:50:10 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id gz26sm7111121ejc.100.2021.12.06.10.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:50:09 -0800 (PST)
Date:   Mon, 6 Dec 2021 20:50:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martyn Welch <martyn.welch@collabora.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206185008.7ei67jborz7tx5va@skbuf>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
 <YapE3I0K4s1Vzs3w@lunn.ch>
 <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 06:37:44PM +0000, Martyn Welch wrote:
> On Mon, 2021-12-06 at 20:31 +0200, Vladimir Oltean wrote:
> > On Mon, Dec 06, 2021 at 06:26:25PM +0000, Martyn Welch wrote:
> > > On Mon, 2021-12-06 at 17:44 +0000, Martyn Welch wrote:
> > > > On Fri, 2021-12-03 at 17:25 +0100, Andrew Lunn wrote:
> > > > > > Hi Andrew,
> > > > > 
> > > > > Adding Russell to Cc:
> > > > > 
> > > > > > I'm currently in the process of updating the GE B850v3 [1] to
> > > > > > run
> > > > > > a
> > > > > > newer kernel than the one it's currently running. 
> > > > > 
> > > > > Which kernel exactly. We like bug reports against net-next, or
> > > > > at
> > > > > least the last -rc.
> > > > > 
> > > > 
> > > > I tested using v5.15-rc3 and that was also affected.
> > > > 
> > > 
> > > I've just tested v5.16-rc4 (sorry - just realised I previously
> > > wrote
> > > v5.15-rc3, it was v5.16-rc3...) and that was exactly the same.
> > 
> > Just to clarify: you're saying that you're on v5.16-rc4 and that if
> > you
> > revert commit 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink
> > will
> > control"), the link works again?
> > 
> 
> Correct
> 
> > It is a bit strange that the external ports negotiate at 10Mbps/Full,
> > is that the link speed you intend the ports to work at?
> 
> Yes, that's 100% intentional due to what's connected to to those ports
> and the environment it works in.
> 
> Martyn

Just out of curiosity, can you try this change? It looks like a simple
case of mismatched conditions inside the mv88e6xxx driver between what
is supposed to force the link down and what is supposed to force it up:

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 20f183213cbc..d235270babf7 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1221,7 +1221,7 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
 			if (ds->ops->phylink_mac_link_down)
 				ds->ops->phylink_mac_link_down(ds, port,
-					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
+					MLO_AN_PHY, PHY_INTERFACE_MODE_NA);
 			return dsa_port_phylink_register(dp);
 		}
 		return 0;
-- 
2.25.1

