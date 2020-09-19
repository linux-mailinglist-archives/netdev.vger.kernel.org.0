Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BE2271128
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 00:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgISWav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 18:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgISWau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 18:30:50 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B50BC0613CE;
        Sat, 19 Sep 2020 15:30:50 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id h1so5207634qvo.9;
        Sat, 19 Sep 2020 15:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Cp6wGeZB6SS98LJtexBivyXrwvaD2ffDaajHaSACWY=;
        b=cb+cKG1I8bwsm48NEpp4t1JXK45eRJlANrsLdFS6bpoo0AsOub4t4AuMMf+XVSNwxZ
         tyZCcj0lUMNSqqQRpWy4jII5t40ALeYPmirmrzPed4rpGGRLkNMMaJeaGLAIWoXV8oFX
         6nHR3drHjrv5V5XfEhnp5FkZjeRAEFG518Vn611y4+qznw3D879rCK0/XUQoiwT59OmU
         +RNWB/g+Uf3c2SY6SX0jACnJo8UP0Mn0b5ZLa0Rfz0En7iz4xRPXKy9clD+5U+J0e4lL
         H7CjOXXAyq1djZHDcf1z883o4iLm23jg+4ISG6+6T7B+nO++gmGIZEKo77vxmwoH+RPH
         q3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Cp6wGeZB6SS98LJtexBivyXrwvaD2ffDaajHaSACWY=;
        b=GrBvxEouCNSVM04IeS/4wXimTEhsp/yJIzcAte7thdxCySJKYsLlPSCp1tOqwAdiMq
         FRTa5ePVNzIqbj9yWdNskoxQetqZddAaD4i7kt0sIK+8P2MwrwXnZAQOFVpS5ttbxImm
         DIoP98Cm/EJiWXRBscL0yyNUm6r1EE2QUNkbK4nVHI2W6BgXB74yiExfETdRv8f6+I90
         HF4HsyE+f8CnOBt4fH6iFu7HfwALvxvtL2pMKI370133jLQGYh47A28Zcv9SdL4Glv6p
         qzi9er8/luFpO2rmKfq1DF0DGOzcwDlEUgudnB43yatMhi4h4VwL83OA/wgMoJsPpKCz
         ZZaQ==
X-Gm-Message-State: AOAM530CBHSddhlK7eSt8lYWBKusGdvGRuTpAF32/E+y7IWxUyFg3hEN
        WlAaywoedMQbWo8dPNpm1us=
X-Google-Smtp-Source: ABdhPJycBYegZeDbUTMjcO7/HmBDoNX4rCni/FQqn9RIFmTJbrpMXtH1bw4JeAWdpgXYt0a5FTLRGQ==
X-Received: by 2002:a05:6214:929:: with SMTP id dk9mr23719833qvb.60.1600554649519;
        Sat, 19 Sep 2020 15:30:49 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id f24sm2581139qkk.136.2020.09.19.15.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 15:30:48 -0700 (PDT)
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
Subject: [PATCH v2 1/4] mtd: Add nvmem support for mtd nvmem-providers
Date:   Sun, 20 Sep 2020 00:30:20 +0200
Message-Id: <20200919223026.20803-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919223026.20803-1-ansuelsmth@gmail.com>
References: <20200919223026.20803-1-ansuelsmth@gmail.com>
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

