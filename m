Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D6F67220B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjARPuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjARPtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:49:39 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0EB53E71;
        Wed, 18 Jan 2023 07:47:31 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z11so50199082ede.1;
        Wed, 18 Jan 2023 07:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NwgV158VzLBEwnGM/l7d36JtM7My51+lT57j1JGtHIs=;
        b=Pnsqx/b/Md5J6PPDJLVlGUEm4SDbiGA/5a+wIZ0BzNL9kaE71HxuKTBGLEhw2jqzBB
         +FdflJ/gXAOD+DM6pctjHZAjGPJ47Ez/GFUzuQeN5oKlp61oPm5joWM+OmnXssPl7gzb
         31VI8A3Vj1zws4kF05jGunyjE/GKn2Z5hinkrtIm5zijnr3p3aKukkDIRoHGtVJS4luL
         79FPNmvVXFSX1k2/Yyc/z1ubdb2yzY+InxjRRfaFIPN9x6K3jSgR0+BQwt60WN5KTjlq
         K+/0KxPIrzbr7YXVwXGlVylAkPREspEIxHShRN08w0s5B4en6iyrVNVds6guuzq9CJuu
         TQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NwgV158VzLBEwnGM/l7d36JtM7My51+lT57j1JGtHIs=;
        b=iwZMQ8bxUZzcGQdXW62Y2DqPiTG+88skgqNdngpwAGdJEiPnfzB0vYRAYxseSsDJ2q
         nYTTlF/GdFxQ34rsWEHc8Owo4KpJi71bAlhjjxDrOkmrrmethOVvagBzGBwhHjcyP137
         F6zzRVAi6VtwLGlvVkQoEnBr0avkIxV7tXybMyJ0ecjiJ0ZZvttu1y95RmocAR/ZAl+f
         yLuZrb1poLNJHmS/68j79BprkK8R3IpLwMBSKQQm0qBvvO9KbpqcE7znPLpvqBFXmUxf
         E+9O+4TI+ed+tknL/XyyE6u59tD2KXgkK/YL5xiY/LuPxYkMaH4aP2ul306i5TV/vJHD
         swgw==
X-Gm-Message-State: AFqh2kpG/NSaO5x/0yVzUsSu64RNZsYtQBdMqheIFKw3QuTKuUEZ2xJD
        GWWgLCYeoAMxLMRD7NmrXcg=
X-Google-Smtp-Source: AMrXdXuydvQh3hAPzT1cMH4Ifuyjvtw1eBOZaBIdfL5iY7MyZIdfL69czWjCed/hDPV46V9cOshRKg==
X-Received: by 2002:a05:6402:28ca:b0:49c:96f9:417e with SMTP id ef10-20020a05640228ca00b0049c96f9417emr7534101edb.2.1674056849884;
        Wed, 18 Jan 2023 07:47:29 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id v18-20020aa7cd52000000b0047eeaae9558sm6358824edw.60.2023.01.18.07.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:47:29 -0800 (PST)
Date:   Wed, 18 Jan 2023 16:47:31 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: [PATCH v2 net-next 1/1] net: phy: fix use of uninit variable when
 setting PLCA config
Message-ID: <f22f1864165a8dbac8b7a2277f341bc8e7a7b70d.1674056765.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity reported the following:

*** CID 1530573:    (UNINIT)
drivers/net/phy/phy-c45.c:1036 in genphy_c45_plca_set_cfg()
1030     				return ret;
1031
1032     			val = ret;
1033     		}
1034
1035     		if (plca_cfg->node_cnt >= 0)
vvv     CID 1530573:    (UNINIT)
vvv     Using uninitialized value "val".
1036     			val = (val & ~MDIO_OATC14_PLCA_NCNT) |
1037     			      (plca_cfg->node_cnt << 8);
1038
1039     		if (plca_cfg->node_id >= 0)
1040     			val = (val & ~MDIO_OATC14_PLCA_ID) |
1041     			      (plca_cfg->node_id);
drivers/net/phy/phy-c45.c:1076 in genphy_c45_plca_set_cfg()
1070     				return ret;
1071
1072     			val = ret;
1073     		}
1074
1075     		if (plca_cfg->burst_cnt >= 0)
vvv     CID 1530573:    (UNINIT)
vvv     Using uninitialized value "val".
1076     			val = (val & ~MDIO_OATC14_PLCA_MAXBC) |
1077     			      (plca_cfg->burst_cnt << 8);
1078
1079     		if (plca_cfg->burst_tmr >= 0)
1080     			val = (val & ~MDIO_OATC14_PLCA_BTMR) |
1081     			      (plca_cfg->burst_tmr);

This is not actually creating a real problem because the path leading to
'val' being used uninitialized will eventually override the full content
of that variable before actually using it for writing the register.
However, the fix is simple and comes at basically no cost.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Fixes: 493323416fed ("drivers/net/phy: add helpers to get/set PLCA configuration")
Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/phy/phy-c45.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index cff83220595c..9f9565a4819d 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -999,8 +999,8 @@ EXPORT_SYMBOL_GPL(genphy_c45_plca_get_cfg);
 int genphy_c45_plca_set_cfg(struct phy_device *phydev,
 			    const struct phy_plca_cfg *plca_cfg)
 {
+	u16 val = 0;
 	int ret;
-	u16 val;
 
 	// PLCA IDVER is read-only
 	if (plca_cfg->version >= 0)
-- 
2.37.4

