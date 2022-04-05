Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEF24F35BC
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiDEKyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 06:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244563AbiDEJl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:41:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF22BBE0E
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 02:27:06 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bx5so11241640pjb.3
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 02:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hAzTrJ7TYOW/7My7Eczuhx2BzqKvNDIdBgJ3oBmi7dU=;
        b=dtW21gnuMusLqkmO680J/5X/0yKRePx85V26D+c2iDKZ8Ko+KSEH4DIKHPDR2DUrsP
         E83rzDzXlzds8Ir2XUT1K06UR4JSImVUz6MaBxY34NBeRN4rq2ZWkBCVzUF+nwDYKFuS
         RFW6OpRfPl+SEHmJ4kB6XhZGlCKIg7CfqTfzGBYaVf5p6FmIScT3ViEpwBnZmJVUEAal
         b8DgxoCeGEWeYlZoqWz6S+C1PMAfzlQONYB6q5X0p16pf8MGbJLzN7JG+8UZGuTAEjc+
         dGxtGojsGQW6To23dB+gnG79s/yHrfIpkJ5/QIXLzau0odlPks/9hDB9sL4MOdj9qUQi
         y1Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hAzTrJ7TYOW/7My7Eczuhx2BzqKvNDIdBgJ3oBmi7dU=;
        b=mTiGlvbuo4VRqz3gouNBTRB1w9CY4NDEneR42s41Vw6ipFS87AQ7efZW6FlGajpvdz
         8O5wpupUQ5NilIC5N6LVO38ilEBmzDToK9F1eJkNfGMCOa3QROWzSzoePXfJN5lUOTSF
         ccqkrWLOH574mvRMNM4ekuWqFAj10y2sfT7sskn/xH2Pg2RLxQ26ipS+CKbzBmUAqA4B
         Ub7clZODJVz5kA55eSFyt1+8Kzs/alRfRUSnEjomIXH+wm4hhXkQTCMPZRkKRXHO25E+
         GMK24iTEtG7fGLgWnf9kCKkKOnB38Y/6i3zY4QetubsiZR6aRbkPr4PfGoKusogB6if6
         Rzgg==
X-Gm-Message-State: AOAM533s6c8m+GtGap0jlshcCUkO2wihT2WzXRkIs+S6W0z4vfkA45x5
        Ak/NG7Nb8jFjy2kq0pWlMuM1JQ==
X-Google-Smtp-Source: ABdhPJzPuCBD+ZJ+36IFrh/zFtO1KkIF/xXbqALiJyd7KMcmtlV1feUFefhIFb9nH0EDMn3sJh5hRA==
X-Received: by 2002:a17:90a:888:b0:1ca:a9ac:c866 with SMTP id v8-20020a17090a088800b001caa9acc866mr2897559pjc.203.1649150826412;
        Tue, 05 Apr 2022 02:27:06 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b4-20020aa78704000000b004fe0ce6d6e1sm5824291pfo.32.2022.04.05.02.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 02:27:06 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     andrew@lunn.ch, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v8 net-next 3/4] dt-bindings: net: add pcs-handle attribute
Date:   Tue,  5 Apr 2022 17:19:28 +0800
Message-Id: <20220405091929.670951-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220405091929.670951-1-andy.chiu@sifive.com>
References: <20220405091929.670951-1-andy.chiu@sifive.com>
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
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/ethernet-controller.yaml      | 6 ++++++
 Documentation/devicetree/bindings/net/xilinx_axienet.txt  | 8 +++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 817794e56227..4f15463611f8 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -106,6 +106,12 @@ properties:
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

