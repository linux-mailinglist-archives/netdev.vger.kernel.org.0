Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4119A271341
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 11:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgITJ5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 05:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgITJ5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 05:57:49 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670BEC061755;
        Sun, 20 Sep 2020 02:57:49 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id z18so5754263qvp.6;
        Sun, 20 Sep 2020 02:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64xYu3WDX6vWiceRdxZMl2E+VlBih2IULY9GL5lmn0U=;
        b=p+WGbfqwHH1OXV5tEzCASV8LZW0RECh7wC89nEJa+Jgn3lNUwPM42+c6NpDjnvUJko
         dzcxyFmqFi9GPNCuazz0U77Hw21k14/X2EtZbyjbdifztLrlQwEyG9YUAFya6uJaxv6G
         Lz7sHNHBujFbHP08PRzbi9Uru/TwB6DsS4feb9FdukmPSc5kR/d8jAzQZo+8p606icDv
         aZldmNlaaV2zhlAqqbD/mKeyUS4BEGnq4REiXhFsuFE0ekVv+4hUL3KKml9tdnHuXPqv
         SW7MdT268hCNfXw5ff/y9GOVVzKHW/pGLJ5SdXdCwCYeGHGbDhk9RCCIRAjOzwrcVn7F
         eK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64xYu3WDX6vWiceRdxZMl2E+VlBih2IULY9GL5lmn0U=;
        b=clWsszOPrHZjOH3X7JZTuNBQBoQj985WdZaoKOI3Chnl8DI4P7kNstD582IdM07Uf4
         5BvdxVUTD7MtS4u5CuJYSdV8HnPvCDSZD12CAYYqxietsmQlBNw+Cx8sBtnCVHTQZhY1
         0CsKMrrF/7gEEsOqJM+EH4d5HJz/1+CCtljnCMpS5iOYu+R+v97pFdOCabeYGoH9ZfS5
         ExHCZ9tb1504Tqq5D+aDmBS2EXUH5OcrlhnWfSmNoaDpyyZLK2xtGuk3zpaEIZrcl2oI
         0Gf/2SKJQRkM8C3+vk5qUCryfLziuK/HL1Okis0ckI2RAqOiAYVGCo6KYfF010fJcd+U
         rS5A==
X-Gm-Message-State: AOAM5327thhZxXkw5MLLPjOh5BBFSI/WM9FiBgfyv45T0OjpBp7UdWis
        Mg3xLsNkw7z8rpbChkkvGzc=
X-Google-Smtp-Source: ABdhPJyTALYmylKCiYZL9A6ya14pzjFRwQqsR7A+AhI03Pvj4NRRfyaxkMbpqweW9bRVphtRSAU7PA==
X-Received: by 2002:ad4:52e3:: with SMTP id p3mr24148392qvu.42.1600595868538;
        Sun, 20 Sep 2020 02:57:48 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id w6sm6968323qti.63.2020.09.20.02.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2020 02:57:47 -0700 (PDT)
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
Subject: [PATCH v3 2/4] dt-bindings: mtd: partition: Document use of nvmem-provider
Date:   Sun, 20 Sep 2020 11:57:20 +0200
Message-Id: <20200920095724.8251-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200920095724.8251-1-ansuelsmth@gmail.com>
References: <20200920095724.8251-1-ansuelsmth@gmail.com>
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

