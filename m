Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE3327112B
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 00:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgISWa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 18:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgISWa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 18:30:56 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B43BC0613CE;
        Sat, 19 Sep 2020 15:30:56 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q63so10862510qkf.3;
        Sat, 19 Sep 2020 15:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64xYu3WDX6vWiceRdxZMl2E+VlBih2IULY9GL5lmn0U=;
        b=UxRNRXL0c3gmNCGQcB1OpKvz1kVKOF1b6fhmhznYWuSPaq0zBOPUzR4GXaxYyxhtVh
         KA2XN1xdaeI8D3KOVfSQJzhfxO8/vNWxgGrWKDBTL8O+bM9mBnWQsjtd2cv7TXgg4BhQ
         umUwu8vdEiPwOxkAzZ95wSY8ISXfwyk27YyA4uAlIbSclw0sZXXfiBjKk4heoITRoAYW
         5TpYU9sk6nADmvAXa6UculR0ocf0MA6ow39ut3k+BfdFcrET2/q4MuqRnI6cZwanTByI
         iFznGYxY2HVjGYgygKAEBTYPpjTOxMKMrsCidaD1M7TuEOmaMyLYqsT4fQQmBwXZtkI3
         As4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64xYu3WDX6vWiceRdxZMl2E+VlBih2IULY9GL5lmn0U=;
        b=pID1Sy2oZX6wBqt34mvWSRydV0G2VeaKiBl9pIY4s3OcHBimlx6QB4u01cnvGEfaWl
         FOIxHhKPL1vV+x+KQdnebYG9SkmzmMzUjJZyRLRvZY1sNB9vkxon/SQPylS14DputNL5
         XteZyJksRHK1vgdIZhHL3HDYI1TwrE/g9pSdQyJFvf6cxgcSkNbz0RrzxRYndBpjdx+T
         dIswAT8K2SYiRfdCLQtq+Qu2YZKtbbSV1qF80iMZuiP7bBy+JdXcPqyU3vyrwFPPA8Gh
         0GfnlV3GzBQdNl4IgOxkCla1IgMqzzomIn0IEZ5yPG4J/4rTDQbNw5u3+wp+u+fpfYAo
         M8PA==
X-Gm-Message-State: AOAM532zE/8lK1cbMIPUbjM1ptOeoXB6+v0sE+wUcJEhf4F65ShtG+GG
        e53p4kdA8IPhyIrEgq5UmOMdhCb3q7mU7A==
X-Google-Smtp-Source: ABdhPJyPapxawX3mTmskaO/Mu+FnvoeGud/hPaQVcm1zqD4t4YwDsmGHKQ5y1cB5vQjbXhvvKKdU3g==
X-Received: by 2002:a05:620a:20db:: with SMTP id f27mr41427656qka.11.1600554655774;
        Sat, 19 Sep 2020 15:30:55 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id f24sm2581139qkk.136.2020.09.19.15.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 15:30:55 -0700 (PDT)
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
Subject: [PATCH v2 2/4] dt-bindings: mtd: partition: Document use of nvmem-provider
Date:   Sun, 20 Sep 2020 00:30:21 +0200
Message-Id: <20200919223026.20803-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919223026.20803-1-ansuelsmth@gmail.com>
References: <20200919223026.20803-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the use of this 2 new bindings, nvmem-provider and nvmem-cell,
used to describe the nvmem cell that the subpartition provide to the
nvmem api and the system. Nvmem cell are direct subnode of the
subpartition and are skipped by the 'fixed-partitions' parser if they
contain the 'nvmem-cell' tag. The subpartition must have the
'nvmem-provider' tag or the subpartition will not register the cell to
the nvmem api.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/mtd/partition.txt     | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/Documentation/devicetree/bindings/mtd/partition.txt b/Documentation/devicetree/bindings/mtd/partition.txt
index 4a39698221a2..66d3a3f0a021 100644
--- a/Documentation/devicetree/bindings/mtd/partition.txt
+++ b/Documentation/devicetree/bindings/mtd/partition.txt
@@ -64,6 +64,16 @@ Optional properties:
 - slc-mode: This parameter, if present, allows one to emulate SLC mode on a
   partition attached to an MLC NAND thus making this partition immune to
   paired-pages corruptions
+- nvmem-provider : Optionally a subpartition can be set as a nvmem-provider. This can
+  be very useful if some data like the mac-address is stored in a special partition
+  at a specific offset. Subpartition that describe nvmem-cell must have set the
+  'nvmem-cell' of they will be treated as a subpartition and not skipped and registred
+  as nvmem cells. In this specific case '#address-cells' and '#size-cells' must be
+  provided.
+- nvmem-cell : A direct subnode of a subpartition can be described as a nvmem-cell and
+  skipped by the fixed-partition parser and registred as a nvmem-cell of the registred
+  nvmem subpartition IF it does contain the 'nvmem-provider tag. If the subpartition
+  lacks of such tag the subnode will be skipped and the nvmem api won't register them.
 
 Examples:
 
@@ -158,3 +168,52 @@ flash@3 {
 		};
 	};
 };
+
+flash@0 {
+	partitions {
+		compatible = "fixed-partitions";
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		partition@0 {
+			label = "u-boot";
+			reg = <0x0000000 0x100000>;
+			read-only;
+		};
+
+		art: art@1200000 {
+			label = "art";
+			reg = <0x1200000 0x0140000>;
+			read-only;
+			nvmem-provider;
+
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			macaddr_gmac1: macaddr_gmac1@0 {
+				nvmem-cell;
+				reg = <0x0 0x6>;
+			};
+
+			macaddr_gmac2: macaddr_gmac2@6 {
+				nvmem-cell;
+				reg = <0x6 0x6>;
+			};
+
+			macaddr_wifi: macaddr_wifi@6 {
+				nvmem-cell;
+				reg = <0x6 0x6>;
+			};
+
+			pre_cal_24g: pre_cal_24g@1000 {
+				nvmem-cell;
+				reg = <0x1000 0x2f20>;
+			};
+
+			pre_cal_5g: pre_cal_5g@5000{
+				nvmem-cell;
+				reg = <0x5000 0x2f20>;
+			};
+		};
+	};
+};
\ No newline at end of file
-- 
2.27.0

