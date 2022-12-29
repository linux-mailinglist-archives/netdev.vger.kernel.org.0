Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA066589AE
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 07:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiL2G3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 01:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiL2G3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 01:29:42 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185511055C;
        Wed, 28 Dec 2022 22:29:41 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u7so18069688plq.11;
        Wed, 28 Dec 2022 22:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zu4t5YxLIzncFUTu3p6dUmcuMC3ijQM333rUPrcRni4=;
        b=fsuqFhBPdVqQ1s80bGVmxIXvJEuyhkH3GJHP3GvdiMYDyKPFz7cWsA236aEO19xIIg
         4/56mdOPqV7Me3GGHvdtaRN2FRDrarYk5KyKK+rsx9HpJ4YesoJ0HqBU8R8lqtVVI1A5
         WOpwF4b3mwpwWBVLD9VkJggoIXD0wzQo+sjuLk9aNvY38WUccSc3uyeofAgRDlelnjFZ
         kUTM2SfqS2dM/AB4Eq3F1IarU2buHB+ToRLREJajLU+lzh0ELrBPLq/x9DilY5e8Hlmq
         LhOb+94oxujhlrNiqW20l5oSF7KsNQLDMizDZjakHdSJbBuZeF02Mz2/cfXij5GkwRAl
         Mi8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zu4t5YxLIzncFUTu3p6dUmcuMC3ijQM333rUPrcRni4=;
        b=RdZOaKpnNuXH/OhrVFxI+GW4jVAvyhZsyVmGDQG6BfO5E8ON2ZXIpDWWSC1ozHvSw1
         gGbAtgeBQcQ2LQJ685qY00yn64/cd/O+fZJcB1o7wE1rnnwtiBg7BYBtzY98v9w1Z/5M
         dbvxsNJa/qpqdif1F4Q93Eq2UZtQmZvN0+K6x60GUuB7BEmUBOuDwLnHeiqUkdfNlML2
         NsPe5tXiWXcHMlUGYWK70iOKkILYzXP8cTGRbtjhdFHc0XcjphYORgf7cpZaHFeMK3JW
         Mt6hWFobIPPTQY05xczdniSdg30Brnthmn0dya2GawllUOU2FS7J/d452IxBPEVgeqFC
         JK2A==
X-Gm-Message-State: AFqh2kos+5JxF6vF+3IGiyH4BwxC3KEGjO//KVXj2uVZwAFEKtN7VtGU
        m4RLTffpygd4uOCFouRCQQs=
X-Google-Smtp-Source: AMrXdXv5KtxHW3bDO3U5bYo2QYD+/RfzC2B2UULHY8aCfhPXF6dSCf58WTZv3XbLVMbI5TkgrKJmWA==
X-Received: by 2002:a17:90a:de8e:b0:21e:1282:af42 with SMTP id n14-20020a17090ade8e00b0021e1282af42mr30080723pjv.40.1672295380579;
        Wed, 28 Dec 2022 22:29:40 -0800 (PST)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id j1-20020a17090a3e0100b00218d894fac3sm13104865pjc.3.2022.12.28.22.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 22:29:40 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Brandon Maier <brandon.maier@rockwellcollins.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe
Date:   Thu, 29 Dec 2022 10:29:25 +0400
Message-Id: <20221229062925.1372931-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_phy_find_device() return device node with refcount incremented.
Call put_device() to relese it when not needed anymore.

Fixes: ab4e6ee578e8 ("net: phy: xgmiitorgmii: Check phy_driver ready before accessing")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/phy/xilinx_gmii2rgmii.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/xilinx_gmii2rgmii.c b/drivers/net/phy/xilinx_gmii2rgmii.c
index 8dcb49ed1f3d..7fd9fe6a602b 100644
--- a/drivers/net/phy/xilinx_gmii2rgmii.c
+++ b/drivers/net/phy/xilinx_gmii2rgmii.c
@@ -105,6 +105,7 @@ static int xgmiitorgmii_probe(struct mdio_device *mdiodev)
 
 	if (!priv->phy_dev->drv) {
 		dev_info(dev, "Attached phy not ready\n");
+		put_device(&priv->phy_dev->mdio.dev);
 		return -EPROBE_DEFER;
 	}
 
-- 
2.25.1

