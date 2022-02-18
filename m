Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713ED4BB1E0
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 07:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiBRGWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 01:22:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiBRGWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 01:22:15 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E4A2615
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:21:57 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id s8so2032451oij.13
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JoqaO5OP51pV9FQRoc7TWD8p6Z2gTdhilmjICyDGsSA=;
        b=C0CNlcmFKaW3/FQuAA7p06NXUPdNekXelYojbdshOjqDLitnR7IPwjvZZRLoTMVPQq
         8r955SBCCGjtBBTkgz7X6nFx/xiSkCIJr7EreaDfxANwPbOIcxlJZcMFSudxlpCbB+4f
         Ew+MZXoJlIEvbTgDPzgu9nPu7OvzXBTaCLWA+Hp/RPlD3R8RcmzXyH3DrgGWaV8uvNv2
         9ujd1vtejt3HhQyh6wENgMky6y1QDe/zF3YSblndeKbRHEfI24WqbO6c7VcSjoIAnVu+
         ZFcgW5aDQLCPEbrFr54UJ1uSNVL1OuFxgGdESIfqx2kfY5ex684j8NIy8hL46qxcFQhv
         6Elw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JoqaO5OP51pV9FQRoc7TWD8p6Z2gTdhilmjICyDGsSA=;
        b=pYkz8Th53AM3xXe+CiQ57Ghbdt8Yawj15drPeHI7zK8T2mLsnf0YmYpoLuqFPZhNzH
         3DA7euGqyMgjIZjgTmtoLU33spL+vK9+j8MFAnPQlyodQ3MYZtvhu0XsootDxdTeBYth
         m4YbyniyV0FupdIGnbgjsb0H+icqEKevkvkjdZVTaML5u3UGOkDec2PxD2JaDQiM7s3t
         VpOw5jqUb/06k+38mvwLARqdgC+Ss5iU74FAnLZ6zrKl+4Vg2I/ZCPTQr6fbPO4CmLRm
         VL9v2eyF/XPjnzA3bclLcbiIRdKLlm74CMdbmkwzZTqCvCZRwXaapO23y80pukIqeywL
         5aPQ==
X-Gm-Message-State: AOAM5317Dja/CDaSi1uy8cAYJVSfg+7CTucPA9rMhXBwvzOmDsDN3cTI
        Ljpw5uk6/ks3B+KrqXJ8tpR2qzjhc44iyg==
X-Google-Smtp-Source: ABdhPJzk2ExGUvSw55IsrVlwAGZOOQZWfjH7jM20+kDN76Ml5tbFcKhOss1NkhT8s49g0pnF5zPPPg==
X-Received: by 2002:aca:b78a:0:b0:2d4:8d2c:7ad3 with SMTP id h132-20020acab78a000000b002d48d2c7ad3mr2148322oif.212.1645165316267;
        Thu, 17 Feb 2022 22:21:56 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id i26sm922387oos.35.2022.02.17.22.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 22:21:55 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2] net: dsa: OF-ware slave_mii_bus
Date:   Fri, 18 Feb 2022 03:21:47 -0300
Message-Id: <20220218062147.7672-1-luizluca@gmail.com>
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

