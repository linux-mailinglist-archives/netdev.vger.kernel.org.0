Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C712710BF
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgISVuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgISVuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:50:09 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4739C0613CE;
        Sat, 19 Sep 2020 14:50:09 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id j10so5147400qvk.11;
        Sat, 19 Sep 2020 14:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hyRAlrt8J6BGlNyQOPrEJ5kGgAcwiPINvnfltt15A0M=;
        b=KlCSprJFAYfexEQg5FWirXfcWfQ7Dssd4Z5GWMsER+Erc+tZ4xAmd3Z++pS6A7Ogjo
         zG7k8aef9k1RxhUgu+PWGFEHevbbzGItxaJXRnasSqPxiE2LI7Ox3iRbxChBk3i7K0nK
         wyC111ojbfSdw3lIshtIpzFzU4lq2cqijwLtT/HuE8wVJJaWxYIu0rZFGVNtbyS4mlK2
         VRX5yidQC9OS/PuV7njjiX3TvO+n4bD3SN274PCIQS9Q4Us1yksgKqm9+tkmGg9hxfFQ
         tBBPMqpGRzUR4jK8Wpc+rpnOEpxhddr2Y0j+vUVTG6PjSbWFCVGSNJbV1CJ/2jfAAwIU
         W+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hyRAlrt8J6BGlNyQOPrEJ5kGgAcwiPINvnfltt15A0M=;
        b=PqqBGLA3lS+Dt495s1+wN/sU5axPGnisWLwlFSauQ9O7k7nOVPMZH3n5VCXK9F/VfQ
         mKuHNQt9cXnwWsbhs5CoQkYhsmMO6FlYjw8SxpBfBR3rcKccMhm16SDfBrDmZmOkWAgB
         6ubhn+jtMW+eH5hgZp9qhPGtJwlzgRA5YgZsIdyiLYLIIgAcibmXIfNPxqnNHaGfFAO0
         AU5rVE775aXfY8aJlSjq4QyeiXbgoGL8qPOoAMpZjwcM0oK/KN5pqQ0HaM64qfVOUK3b
         z+AeHF+EkruCEiSGsrG2iQVx6j6BBMA1t1y1L5ErLQ+ADol1XqvQQcvv4bKRIHSCYBr+
         5bCw==
X-Gm-Message-State: AOAM531WDch4cLhRZwoicIIy9j1ECfgTfUXAvNiNl/KuXn/zpX+Uht/W
        QwoB02yBJbA5jiup8q7Ad5I=
X-Google-Smtp-Source: ABdhPJzzXrVOQ6yFroXqTSfpgunJbma6nmp/ttKWAwgCKfrT4Ttp/rSZO7OEp7oKZvpP+UQUEcXFFQ==
X-Received: by 2002:a05:6214:7a1:: with SMTP id v1mr40316823qvz.19.1600552208970;
        Sat, 19 Sep 2020 14:50:08 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id y30sm5617173qth.7.2020.09.19.14.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 14:50:08 -0700 (PDT)
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
Subject: [PATCH 1/4] mtd: Add nvmem support for mtd nvmem-providers
Date:   Sat, 19 Sep 2020 23:49:35 +0200
Message-Id: <20200919214941.8038-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919214941.8038-1-ansuelsmth@gmail.com>
References: <20200919214941.8038-1-ansuelsmth@gmail.com>
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
 drivers/mtd/mtdcore.c        | 2 +-
 drivers/mtd/parsers/ofpart.c | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 7d930569a7df..72502c990007 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -563,7 +563,7 @@ static int mtd_nvmem_add(struct mtd_info *mtd)
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

