Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F4027133F
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgITJ5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 05:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgITJ5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 05:57:43 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22650C061755;
        Sun, 20 Sep 2020 02:57:43 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id di5so5742127qvb.13;
        Sun, 20 Sep 2020 02:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Cp6wGeZB6SS98LJtexBivyXrwvaD2ffDaajHaSACWY=;
        b=ExV2J0dku2JMmlAU9XWVQ6EA1ZpDFcBWqnSgZ52HkNzqXKPznuXV2TscrMYYZshBMA
         KScQZHTuODTN5KaT0FSwOi7O2X3RUWwcXQI+WDJ6bS9rvIyl/ZchqRy5d71W/JPiHwcb
         1Fl1FTnD2W2BHC3sDNv16IeD96xIkM7YPS9RcOhTcWGi1pKFbd27vQX+ec9nyt11mEx+
         drL7pH1LR/HnPBLImJ3r7TQOlyMoDYnfMqyx2Z/YQWlE7iPMRuUIam/1SXMBJm5Me8is
         2tu2UXCrDOBaXBazoAa1+ZuUUmvSFSYNqMjJCI9ctYdCYdvKn5M1l6rIVBJBA9IEHHLM
         Mb3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Cp6wGeZB6SS98LJtexBivyXrwvaD2ffDaajHaSACWY=;
        b=jTskMon6aLTD6+B49F064q5zDh0pFG5k3d2pDg964yCkWcEoY3MEJxnOPqGT0aguJg
         9OyXojztsu2dorNHYvzkafFNYJtGMDzdOM5un8qeqwkPAgSuEp/mw4vcU4zAGafBw8Bk
         MrmLTyZ23NWhDQqe4/23M5yC+XDCGP4iyZiK90f5tz2Ky+ZdWJsdU1K7gCxX+U5Qb6XU
         94avYqgJUZL9j2WGVFUAltVU4sGZX2EBLDSEnH/X2ilrMgEkof2SM93Qi6t0uHPf/ciY
         dVLKx66KbVZ2oM9KMTK8wVjrBuBkWDt/ibfUR/uuq3abPXjaUf41rAtJikMWB1rPfMWV
         WJBw==
X-Gm-Message-State: AOAM530fJgIBUEBf/QHHh43+rH9cG+LNY9DvEOdX3loZb/Rmk4Palo9D
        sfHivPWlB+WxLPGD86MdOA4=
X-Google-Smtp-Source: ABdhPJwEhDyAwUV5UVHjMYtJZMqZWnXncn13LWvoJ+ZoTbYCWu2zx0tKeSvcu7jECySfUWPeBSJS+g==
X-Received: by 2002:a05:6214:1021:: with SMTP id k1mr24205091qvr.62.1600595862353;
        Sun, 20 Sep 2020 02:57:42 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id w6sm6968323qti.63.2020.09.20.02.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2020 02:57:40 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 1/4] mtd: Add nvmem support for mtd nvmem-providers
Date:   Sun, 20 Sep 2020 11:57:19 +0200
Message-Id: <20200920095724.8251-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200920095724.8251-1-ansuelsmth@gmail.com>
References: <20200920095724.8251-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce 2 new bindings for the mtd structure.
Mtd partitions can be set as 'nvmem-provider' and any subpartition defined
with the tag 'nvmem-cell' are skipped by the 'fixed-partitions' parser
and registred as a nvmem cell by the nvmem api.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/mtd/mtdcore.c        | 3 ++-
 drivers/mtd/parsers/ofpart.c | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 7d930569a7df..ba5236db8318 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -551,6 +551,7 @@ static int mtd_nvmem_reg_read(void *priv, unsigned int offset,
 
 static int mtd_nvmem_add(struct mtd_info *mtd)
 {
+	struct device_node *mtd_node = mtd_get_of_node(mtd);
 	struct nvmem_config config = {};
 
 	config.id = -1;
@@ -563,7 +564,7 @@ static int mtd_nvmem_add(struct mtd_info *mtd)
 	config.stride = 1;
 	config.read_only = true;
 	config.root_only = true;
-	config.no_of_node = true;
+	config.no_of_node = !of_property_read_bool(mtd_node, "nvmem-provider");
 	config.priv = mtd;
 
 	mtd->nvmem = nvmem_register(&config);
diff --git a/drivers/mtd/parsers/ofpart.c b/drivers/mtd/parsers/ofpart.c
index daf507c123e6..442e039214bc 100644
--- a/drivers/mtd/parsers/ofpart.c
+++ b/drivers/mtd/parsers/ofpart.c
@@ -61,6 +61,10 @@ static int parse_fixed_partitions(struct mtd_info *master,
 		if (!dedicated && node_has_compatible(pp))
 			continue;
 
+		/* skip adding if a nvmem-cell is detected */
+		if (of_property_read_bool(pp, "nvmem-cell"))
+			continue;
+
 		nr_parts++;
 	}
 
@@ -80,6 +84,10 @@ static int parse_fixed_partitions(struct mtd_info *master,
 		if (!dedicated && node_has_compatible(pp))
 			continue;
 
+		/* skip adding if a nvmem-cell is detected */
+		if (of_property_read_bool(pp, "nvmem-cell"))
+			continue;
+
 		reg = of_get_property(pp, "reg", &len);
 		if (!reg) {
 			if (dedicated) {
-- 
2.27.0

