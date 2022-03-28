Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0FE4E96C2
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242563AbiC1MhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242545AbiC1Mg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:36:59 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA63F4E391
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:35:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id p17so14661740plo.9
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wxuPG5Xa7iJ0fmOshTOWXqRXvkduIvgaK+wC6AjWHwY=;
        b=lCRtdJh7dtozIL02xyp32AvAUCaF0IynNKkSPx54A9PtSa40J2uK/i2UyzW5l16Sy0
         PgQi8OpCBgD4nyxSFC62dbBDwSog2ZdCZyhjFGH9iBtTIg6B61daa9RmS0FrS4NCfjPE
         0ah+t6na76DWOgm+1q5ILK98qCKbOsexX6pj4MfwZ1SIWylUDUhon3mhohFUNJBf/cm7
         YvpIm7PbTnKhIg+tgw48CBPSN4U/azKGU3+cusg1dS1wV3AFNvE/gYJztgytE9A7Adrp
         W1EzVttL5ukvTZq2p6SyTTg1959MMKc3gvZRIsPCSC0Wxru/OlSUW68o6QRAdTzBkR9l
         n3Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wxuPG5Xa7iJ0fmOshTOWXqRXvkduIvgaK+wC6AjWHwY=;
        b=YWddPCXl4HRqdngJWLfpTHAbH+ZnGX5hYeMsMKsTZ5Mr2oGMlD7Tmw7zitEWPBY21L
         qfdDARdmLrq8f/WJqrpQ4LV/vxg7K/Z5tIcUjGj/6xIVvT96jk9TG0/e9LrJvjJy+Vit
         W0koNKGCwu9YfFg4My9MPH8T20yI/P1T0TEfZrkifu8gziSqyVhPatCXiSdgpqIn8k4K
         g06NzBPUiiLcyCHgR6fWz5jhjSIvdyn2V0+TEZ78PRm2tmmzBvAmYBVdWgAIJoD60ZY1
         Zvp+R8o76pXTBGVslH4uhnZ/NcfnyrasmcZ9bI3EtlbkH4kHx5xM3JUO5dTNlhIuGbKJ
         TdEw==
X-Gm-Message-State: AOAM533+JiznsGOSFzPoNOdSNPpTWbWBqcOtStNotniOVz/zsckGlYa0
        tVxVs1yUOF2YCc82xlzD1NJXpg==
X-Google-Smtp-Source: ABdhPJzPRecPZj5bWfKLTfbnr5VDlE1oEFjvl15YfkJqmnX+FzftMW+RAgSWqlF76CJ2bq+6jdR9lg==
X-Received: by 2002:a17:902:f682:b0:154:8500:80bf with SMTP id l2-20020a170902f68200b00154850080bfmr25963461plg.112.1648470916213;
        Mon, 28 Mar 2022 05:35:16 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00170c00b004fab8f3244esm16314597pfc.28.2022.03.28.05.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 05:35:15 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com, andrew@lunn.ch
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v6 net 3/4] dt-bindings: net: add pcs-handle attribute
Date:   Mon, 28 Mar 2022 20:32:37 +0800
Message-Id: <20220328123238.2569322-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328123238.2569322-1-andy.chiu@sifive.com>
References: <20220328123238.2569322-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the new pcs-handle attribute to support connecting to an
external PHY. For Xilinx's AXI Ethernet, this is used when the core
operates in SGMII or 1000Base-X modes and links through the internal
PCS/PMA PHY.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
---
 .../devicetree/bindings/net/ethernet-controller.yaml      | 6 ++++++
 Documentation/devicetree/bindings/net/xilinx_axienet.txt  | 8 +++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 34c5463abcec..978772c04e1c 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -102,6 +102,12 @@ properties:
   phy-mode:
     $ref: "#/properties/phy-connection-type"
 
+  pcs-handle:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Specifies a reference to a node representing a PCS PHY device on a MDIO
+      bus to link with an external PHY (phy-handle) if exists.
+
   phy-handle:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index b8e4894bc634..1aa4c6006cd0 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -26,7 +26,8 @@ Required properties:
 		  specified, the TX/RX DMA interrupts should be on that node
 		  instead, and only the Ethernet core interrupt is optionally
 		  specified here.
-- phy-handle	: Should point to the external phy device.
+- phy-handle	: Should point to the external phy device if exists. Pointing
+		  this to the PCS/PMA PHY is deprecated and should be avoided.
 		  See ethernet.txt file in the same directory.
 - xlnx,rxmem	: Set to allocated memory buffer for Rx/Tx in the hardware
 
@@ -68,6 +69,11 @@ Optional properties:
 		  required through the core's MDIO interface (i.e. always,
 		  unless the PHY is accessed through a different bus).
 
+ - pcs-handle: 	  Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
+		  modes, where "pcs-handle" should be used to point
+		  to the PCS/PMA PHY, and "phy-handle" should point to an
+		  external PHY if exists.
+
 Example:
 	axi_ethernet_eth: ethernet@40c00000 {
 		compatible = "xlnx,axi-ethernet-1.00.a";
-- 
2.34.1

