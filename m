Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BD5398AF0
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFBNqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:46:19 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:35742 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhFBNqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 09:46:18 -0400
Received: by mail-ej1-f52.google.com with SMTP id h24so3965066ejy.2
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 06:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KWqgYeLlxYZiliOYiaWXQibd9qtFvy48JHYxtD1KSnA=;
        b=S6yRQw4rnLMiXV5km0szS2tt35lFZ9JfMmF+0iGSt8bV9eXz2CH0le8ld8bHSgubyz
         LcjbWvHzPjrVplMMQ7sB6VW82FpG4m5WD9OUUfzEH5di2AxXKBHWa+g3+7Si59p4Ntiy
         gf7H4/00ygt/6Zf7DgL3NliwSCrBEGzP/kF9VeJPYFIJTC9hn5ivfVtNc8t1gx30VjPS
         ObGoSVQ1b1K9IHeOXD5YIGKvHUNlxfw2UzFGjkQuMQ/uEqi/merxplmqidkmtsqCw+tM
         uENNWMtudAhQbxEj12XkdM5P+X34iMwwEzKTb8PBd+kSM5IyYgRIhbjZsY1pdjss4T44
         RESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KWqgYeLlxYZiliOYiaWXQibd9qtFvy48JHYxtD1KSnA=;
        b=RyL4oaX153DmBeX52Fi7qe/3+tKmTp0t83f9T/0F9hN7j+B/EbypsiDuuFS09jC3V5
         Xim9FKcdF+nQJlIhsk9nGHJOJgbxujQtBZHCNrgNMD9PokRnvb58HCaKA33/M2RBchRI
         t5KL7i9fp1T9N7dJhw5UCZ6NGJwm0cKhMXHDoXasXup1aueoN8xKAE3d6be9pMqFN1jC
         86r2QL/EdaOtTrk1xIlZ16nTxyvtdotsY2lbCs4zRpmrI76/0prF9Ub2Zo5h6lJO2w7F
         UHpVtSXyo1Gq6+ByMqWAzUKN1Mq6N3wXVTA5Gm/l6pUacNzeUTFLvRAKh0YUHWJqiK5J
         98jQ==
X-Gm-Message-State: AOAM532uN6CjvbaGFzaQul2s268ztjlQ4rCCbkzketRHN33dCfxU5v0j
        bJgOwkL/JOSAShkCc6f+WRA=
X-Google-Smtp-Source: ABdhPJzqD4SY8CQ8mbBnJy2fSut57oiXF6XTgk5LckhnDCE0iEZz5sAvEgFiDQVwYJPEKBJ/bTRuMQ==
X-Received: by 2002:a17:906:5293:: with SMTP id c19mr1911787ejm.245.1622641403227;
        Wed, 02 Jun 2021 06:43:23 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id s2sm1411108edu.89.2021.06.02.06.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 06:43:22 -0700 (PDT)
Date:   Wed, 2 Jun 2021 16:43:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 9/9] net: pcs: xpcs: convert to
 phylink_pcs_ops
Message-ID: <20210602134321.ppvusilvmmybodtx@skbuf>
References: <20210601003325.1631980-1-olteanv@gmail.com>
 <20210601003325.1631980-10-olteanv@gmail.com>
 <20210601121032.GV30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601121032.GV30436@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 01:10:33PM +0100, Russell King (Oracle) wrote:
> On Tue, Jun 01, 2021 at 03:33:25AM +0300, Vladimir Oltean wrote:
> >  static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
> >  	.validate = stmmac_validate,
> > -	.mac_pcs_get_state = stmmac_mac_pcs_get_state,
> > -	.mac_config = stmmac_mac_config,
> 
> mac_config is still a required function.

This is correct, thanks.

VK, would you mind testing again with this extra patch added to the mix?
If it works, I will add it to the series in v3, ordered properly.

-----------------------------[ cut here]-----------------------------
From a79863027998451c73d5bbfaf1b77cf6097a110c Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Wed, 2 Jun 2021 16:35:55 +0300
Subject: [PATCH] net: phylink: allow the mac_config method to be missing if
 pcs_ops are provided

The pcs_config method from struct phylink_pcs_ops does everything that
the mac_config method from struct phylink_mac_ops used to do in the
legacy approach of driving a MAC PCS. So allow drivers to not implement
the mac_config method if there is nothing to do. Keep the method
required for setups that do not provide pcs_ops.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phylink.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 96d8e88b4e46..a8842c6ce3a2 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -415,6 +415,9 @@ static void phylink_resolve_flow(struct phylink_link_state *state)
 static void phylink_mac_config(struct phylink *pl,
 			       const struct phylink_link_state *state)
 {
+	if (!pl->mac_ops->mac_config)
+		return;
+
 	phylink_dbg(pl,
 		    "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
 		    __func__, phylink_an_mode_str(pl->cur_link_an_mode),
@@ -1192,6 +1195,12 @@ void phylink_start(struct phylink *pl)
 
 	ASSERT_RTNL();
 
+	/* The mac_ops::mac_config method may be absent only if the
+	 * pcs_ops are present.
+	 */
+	if (WARN_ON_ONCE(!pl->mac_ops->mac_config && !pl->pcs_ops))
+		return;
+
 	phylink_info(pl, "configuring for %s/%s link mode\n",
 		     phylink_an_mode_str(pl->cur_link_an_mode),
 		     phy_modes(pl->link_config.interface));
-----------------------------[ cut here]-----------------------------
