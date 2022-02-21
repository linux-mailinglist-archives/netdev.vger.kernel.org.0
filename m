Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9A14BEB89
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiBUUEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:04:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiBUUEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:04:44 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C658522BDA
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:04:17 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id 189-20020a4a03c6000000b003179d7b30d8so14606057ooi.2
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JoqaO5OP51pV9FQRoc7TWD8p6Z2gTdhilmjICyDGsSA=;
        b=Xf/CWCAyQDi6JP17zzZPun8VMpjx7XsE2ZDmapj25WTZ1n1bD+V7FWu844TxTv8E9P
         izBjcBUcBzRjdXW9cbZBewjoPivIOSanbV0XdWnUYcGcJQ4UQVMiPwnJ57tlbeIE2C2q
         h6aadSbdi03aidKUsszt/5pqhPAe75F5b7tTFRzh46uhH60cfMqsIpCek8BH0kt0Yypf
         8b6Zr8u5uvhrzg8Jme+5S5oYvZd/Yy4UrXlZTxeAd5oGne2VYpukoIssJEOpTJnfgs2x
         XMB8PPLVapXO4U4Fx8bOh+NspukCGGPhrlUUQxe+/xApl6QLM2UpO0dzFa7ySBqMYFYw
         5C6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JoqaO5OP51pV9FQRoc7TWD8p6Z2gTdhilmjICyDGsSA=;
        b=d7jHLOj7wG2UYOdvOwhnOYY5AxcT6VaGQxCX/qsW+Cez2hTHgMJ6ACOKUWuxQO1/SS
         JeIvNlNtPCXEG4F4fdYIjP0rF4MQQBEMjh5nP91q0Jo5BsbwWLS02b8ZR2lT8f2Vhe8j
         3HSkL5mgD2gN5AtS9Ea5RejKyKSZyRYyG9BAgk9ocX8f7Rte5BAJ4CB9guNm7Af+mb1T
         cmx1uNR2xTzCqTC9Ua29zFPsJjoN1zOuFHjdPrNIDDD7t6+G8Xg38A++SfoGtRduqqJo
         /c+u+YI1amDrD8bH9gxj6kY5Mb4V3p49L3nYPqcEaScgOMz64ZMGXvhQQQAJQNra6Ad0
         +2Cw==
X-Gm-Message-State: AOAM5334D+HzgJ2ARXEIXjoIpCoA3QvUVqfPXz9j+XW53iBk8Te6PSUh
        lK+pWUowgQgBObV39kLZJGZRX3OruEDedQ==
X-Google-Smtp-Source: ABdhPJz6e5+DChCACExUVu+daZ8BKLBhIhA894yJMeXmQacewionc5gjd0wJ3htpnAcmAqAm9aOxOw==
X-Received: by 2002:a05:6870:a794:b0:b9:62d0:56fd with SMTP id x20-20020a056870a79400b000b962d056fdmr259658oao.115.1645473856623;
        Mon, 21 Feb 2022 12:04:16 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id g18sm409365otp.17.2022.02.21.12.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 12:04:16 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 2/2] net: dsa: OF-ware slave_mii_bus
Date:   Mon, 21 Feb 2022 17:04:07 -0300
Message-Id: <20220221200407.6378-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If found, register the DSA internally allocated slave_mii_bus with an OF
"mdio" child object. It can save some drivers from creating their
custom internal MDIO bus.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 net/dsa/dsa2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e498c927c3d0..2206e2d2a7b3 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/rtnetlink.h>
 #include <linux/of.h>
+#include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <net/devlink.h>
 #include <net/sch_generic.h>
@@ -869,6 +870,7 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
+	struct device_node *dn;
 	struct dsa_port *dp;
 	int err;
 
@@ -924,7 +926,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 		dsa_slave_mii_bus_init(ds);
 
-		err = mdiobus_register(ds->slave_mii_bus);
+		dn = of_get_child_by_name(ds->dev->of_node, "mdio");
+
+		err = of_mdiobus_register(ds->slave_mii_bus, dn);
+		of_node_put(dn);
 		if (err < 0)
 			goto free_slave_mii_bus;
 	}
-- 
2.35.1

