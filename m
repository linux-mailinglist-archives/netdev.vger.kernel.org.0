Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94282530726
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 03:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349652AbiEWBdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 21:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbiEWBdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 21:33:22 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E579B38BF6
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 18:33:21 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id q10so16253533oia.9
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 18:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ayRBBYoynmQliWAoTGjGtbFZV3/m23/sr6jxvWDOn0k=;
        b=E3Uy3A1KoP76fIW6T5wR2MTZI97IgmlpflsTNomu/+EL4/aRMFGgvBU4uQ7TQWdghx
         k9tpxT6JNEIyxiCplFcuZ6A0vl8Qc/ldtdS8GHaxqtRTloIIs38syaCAiuiPrbYL8gsE
         S3nsiyVJRow+tbye3JiUAOn019CpvuENJMpWtCXfsJwZzoQA43L9ZGjtYqub6bNSgJlH
         qC/6fKew/EaAe7p+YVM+U0MLqqpuTZ7D3a6/FKwNekclWHYlzgLpHmKDP/Pd8H6xLpMe
         1G4bFy6zgKyqrha4s6skp5rQwLf2BwoW25KX07mbYlmwlKV2rBG+gaKT1g5p/wLTdFEH
         g3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ayRBBYoynmQliWAoTGjGtbFZV3/m23/sr6jxvWDOn0k=;
        b=s8Hku3TAMOYagiugtm5D0h2oXCIjKvwzkj8nS8K5d9DQvvxbYkOBFEPxMMIEIFI8R/
         cTPNgIiWx4cQm1/fip0Apu2qm4vWlEAlMSrk58k8uhG/KpzwZEeoPRZYZp+ZzqU7y+Xb
         JGHZx2frk2veRuCx6Lkrh8FYx3sUesXhZXavLAL0bSdkHlKaU5QMXBFDKFYug5WMl2zL
         sd8AJJdSZrTw+KgMGY8WJo2BXHzIg3vMYPW5iGSUCj4r8HafQxdvMTQm9hXLqjZmgVnv
         srTzZqKVpRu8hYi20JulNtNVwBNnhsKlFhnU/WlKXA4ivsVaMdWHE+Y26MwjtgK4NHL6
         ULqA==
X-Gm-Message-State: AOAM530d3MywT8KfAQn6K6LyHpZMeUe9CEglEk8F/oAMhSoHwnZ7hbgV
        I59ToqErsdEFs9cUz4QEAsICcNgQDqk=
X-Google-Smtp-Source: ABdhPJy4LIFHR+gduw2zxuni2V+E5ux5yuPtQLKPLnbMjnuP6a7QmCm1oO5fXqdBAYSo3Zjfh2UWTQ==
X-Received: by 2002:aca:d707:0:b0:32b:4fb:148 with SMTP id o7-20020acad707000000b0032b04fb0148mr6012664oig.194.1653269601068;
        Sun, 22 May 2022 18:33:21 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id z18-20020a4a4912000000b0035eb4e5a6dasm3758617ooa.48.2022.05.22.18.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 May 2022 18:33:20 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next RESEND] net: dsa: OF-ware slave_mii_bus
Date:   Sun, 22 May 2022 22:32:34 -0300
Message-Id: <20220523013233.20045-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.36.0
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index d0a2452a1e24..cac48a741f27 100644
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
@@ -852,6 +853,7 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
+	struct device_node *dn;
 	struct dsa_port *dp;
 	int err;
 
@@ -907,7 +909,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
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
2.36.0

