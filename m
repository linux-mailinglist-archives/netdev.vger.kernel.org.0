Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76E6670C19
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 23:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjAQWti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 17:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjAQWrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 17:47:49 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE5532520;
        Tue, 17 Jan 2023 13:47:52 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v6so46990252edd.6;
        Tue, 17 Jan 2023 13:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2pVx7h4GXYwRMqM2mQoWvBx9P7rA8jeO4z/gGfLdACY=;
        b=iC3f3HnSOhWbWpnmiHeT4Y1TwZbjcLUEV/+SjFxpwG68ZSWNmjeL8fHcXpAyPK9RLW
         HCX/cez0yt2XzCZqUTCgc2Un7XjcgAuOrzpIk5bB8QfKrT8fQJm3XHO0wzjP23U1MBQt
         HhhY+qq+WHbXokrCaxNzMSs/BAS2vQqzgY8jHK923/9XUq+iN7CZO7uBuCa613ZpRMIY
         Ki7ya2L8zmCgDefO/EJNafKrQkqik9+qa9XZyZpFuKRsIVqMa4KoK6Pw3YhvX8L4QRMD
         JfMhWlsXEFxyULcfNc0EsxU1qopQxfTxCFQI/hCtDoJc0pssp3W94ih/U4jCyeW9eQ5O
         aRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2pVx7h4GXYwRMqM2mQoWvBx9P7rA8jeO4z/gGfLdACY=;
        b=sqj11gCRC8a18cK5eOa46IIY5cwJ1fvM/ZCe3BBmQxRHajFB/U1MmlSdtXBTczXSJQ
         48VsjXzeqwH6E/DqIj3/YlPuY6ntcFPI5Et0yVdCZwPHgd/wom1IF62l7xy4PHZdFj4z
         gM1pNzu980rkkqbP/YA6UlLBliuDqKqzIXJNgsBM6RcQHEs5hXESySI3oqXOaAru/rka
         ECJDa4kR3UigD/ePya/25KAzb6PNxCKNUx2B7oV8iaKu3qUaNog31TgU/oFcvn5YIp0E
         naloBi0n12vcLK1gNfCkhbPq8Oi3tN3BZJkN9K0iKVCuglt55qLrMBn5WJEEGdvjP75I
         ABIg==
X-Gm-Message-State: AFqh2kqS2M+FxDIZeYfBFYcLzLhIA72kpyExiT2H2/vthY304K45g0dq
        CKn2tR7Y3E4upfIRUMmSiy8=
X-Google-Smtp-Source: AMrXdXvVgBgFQ6P9kgPf5tuaC1a6S9fOIotbTpXVz/gBOxTSdClsR515jvZoaFmzs9z5XLKLEXer5g==
X-Received: by 2002:a05:6402:449a:b0:499:376e:6b2b with SMTP id er26-20020a056402449a00b00499376e6b2bmr4744457edb.0.1673992070706;
        Tue, 17 Jan 2023 13:47:50 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id m17-20020a50ef11000000b0049c4e3d4139sm5754220eds.89.2023.01.17.13.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 13:47:50 -0800 (PST)
Date:   Tue, 17 Jan 2023 22:47:53 +0100
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
Subject: [PATCH net-next 1/1] drivers/phylib: fix coverity issue
Message-ID: <5061b6d09d0cd69c832c9c0f2f1a6848d3a5ab1c.1673991998.git.piergiorgio.beruto@gmail.com>
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

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1530573 ("UNINIT")
Fixes: 493323416fed ("drivers/net/phy: add helpers to get/set PLCA configuration")
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

