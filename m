Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6335F2710C2
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgISVuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgISVuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:50:16 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E688C0613CE;
        Sat, 19 Sep 2020 14:50:16 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id v54so8752303qtj.7;
        Sat, 19 Sep 2020 14:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64xYu3WDX6vWiceRdxZMl2E+VlBih2IULY9GL5lmn0U=;
        b=fy3PsG2bT7uohMvad4KwkkOj8iV/lS4dBm65Agal/vyFJipHQfJyxHAOYdpYC/5dnF
         RJ5lvHF1Vdq/k67RmOI7ddD3lM2Blo9bRdqEFXd3SaKqlcMRlaVKf/g7N+qByN3KuIws
         zaMZvd8JkeZRa2o23W62yla6fAqqeIcdYmbrYNq5E847448d24bVe3VnJkudo1nyUlOr
         gbRZEJEFYqgmetLHxXt1JmvmThSdG8sPpXaLPaHjq20DSvNrpFr1rlSM9TSJkP6ZgdBg
         nk2/BoyyxGu+v2gkw7qa+YihGgyZWZ2gQCZdptV1dgJCtFTBuFdoQiVB2xkaRK+kHwLV
         FOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64xYu3WDX6vWiceRdxZMl2E+VlBih2IULY9GL5lmn0U=;
        b=Sey2r8N7XS9FQBIh62tHlzVcZA+mqDrMjE9SIBb/l/VYYFu8tCXmwtMLhe3NEzRWYz
         BUXSu3SkNLNtjg7uu6/cM8glO7l2fEB8q3pGs17iY23fMu1gYaoVJ3GWubeESbeAR6WC
         9kJwIX5RH7nS5ny+kIv1WU1SNYM+OQ2Br4GaQ/8L4gmW6IA1lmgNeh9dKxg2MuPHoTL0
         WEP95d85+DUnEjfR6+20XLc9KDENYGP+LuD79v8TinImLMCtQtg6g9Bo6hiEGa4ItHyY
         YnVCx9kGhm7+KMBd8pQTXZ6zMy1JBVEiDpsz2on/5qx+fwC6wMgY1l3VfPq+P+owNUNu
         YpjQ==
X-Gm-Message-State: AOAM530CflYBSCE4WGB+oskXSAywbPieVdKNcpgR87YUqzKOXnAPZ83M
        4Zb0dNqY4bQHUsiz4KN+Uuc=
X-Google-Smtp-Source: ABdhPJwgPfl2zBW0ecdIfpAx8GltCRo8+hWIFLCjALXeEBPL0tomHMI3q6S9Nt1+Xjv61eWvu5/sxA==
X-Received: by 2002:ac8:1b92:: with SMTP id z18mr38396682qtj.265.1600552215409;
        Sat, 19 Sep 2020 14:50:15 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id y30sm5617173qth.7.2020.09.19.14.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 14:50:14 -0700 (PDT)
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
Subject: [PATCH 2/4] dt-bindings: mtd: partition: Document use of nvmem-provider
Date:   Sat, 19 Sep 2020 23:49:36 +0200
Message-Id: <20200919214941.8038-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919214941.8038-1-ansuelsmth@gmail.com>
References: <20200919214941.8038-1-ansuelsmth@gmail.com>
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

