Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95B44E580E
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343930AbiCWSEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343927AbiCWSEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:04:10 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBEF887A2
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:02:40 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s72so1772145pgc.5
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bwIjazYGh/13rqi29xt94fh6HfpqlQOG+ZItpj9cq4E=;
        b=Cwd3KFSI/agyKxOiSZRaQgHH5s9cCIxb9ZH26XhlJyM5Ee2d6GUDYDjDZs0PO2rLTH
         gJUzkgwY9zJA+fmln+Ws0oFxAN9BOZUQUzAnQalMQjyWV8VKY7rEk4sIozlEhASvEw+Z
         l+O76FfmHFmhBZkq6TzwHSapiTXB42l1Q216GY7pimeqSrhBKBAY6W4cpGsohddmy9O1
         cQXw5CJAcX5nyCoUJx5oFWtwvKWj4p91nZKwgg/RnOfjzumXNnpN6hFcVh+lyadz0spw
         yde3nVP2eSdVPJr49xlXbo0AGV1yKIbW55Snrw2AC14xx21YbamBCNDYMISeP3fCxTlG
         HdlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bwIjazYGh/13rqi29xt94fh6HfpqlQOG+ZItpj9cq4E=;
        b=dAFLZ9dzWLh+1UXj9sUmhflLpFN2a3qB0ChUwuBMqtjDDAv3DtCS4c2TdSRUVT/KKs
         fYVkaQPIzdV395Wf3dIS3odFQjJ+IYIF1KpAwhyzIdxfoOl1ELeqOUHFlbKmapds2Me0
         i8kK3/MyH0ozTS4AUOhwss4MDFbg0OMjQMFvPhNIq9kxWUKmcc3UzUaKmJipodfv48qc
         SlI7VSLtzU2HS/YfVdSuwnQTaT1ijln5bHiSYEpKpFS/JGzk25kO3YoVB/ffGD0aCpE4
         pkDP6NqFiNWTXF8tcOrwdbKkSLv2XF9CWk8qrAYpmEaKP9nj5Y9DzvurYR90Ek2X+iRb
         pRsg==
X-Gm-Message-State: AOAM533/QsXcDvezFFhL70pYebbSp89rj8qkFwhlHupxEZNdpDVL0ev/
        MZ3wHb9zI6TJsG/BRPE3XkpKNg==
X-Google-Smtp-Source: ABdhPJwrJ1/ea3VN6pmR/JRCmTVCgRNMBCnuSQS8Q8pTlW8Ye6OQR0MPoEtF95QiHxTVvxg6Oq7Zog==
X-Received: by 2002:a63:6809:0:b0:37c:68d3:1224 with SMTP id d9-20020a636809000000b0037c68d31224mr815631pgc.287.1648058559570;
        Wed, 23 Mar 2022 11:02:39 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id l19-20020a17090aec1300b001c7a31ba88csm1265870pjy.1.2022.03.23.11.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:02:39 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        robh@kernel.org, Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v5 net 3/4] dt-bindings: net: add pcs-handle attribute
Date:   Thu, 24 Mar 2022 02:00:21 +0800
Message-Id: <20220323180022.864567-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220323180022.864567-1-andy.chiu@sifive.com>
References: <20220323180022.864567-1-andy.chiu@sifive.com>
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
index b8e4894bc634..ba720a2ea5fc 100644
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
+		  modes, where "pcs-handle" should be preferably used to point
+		  to the PCS/PMA PHY, and "phy-handle" should point to an
+		  external PHY if exists.
+
 Example:
 	axi_ethernet_eth: ethernet@40c00000 {
 		compatible = "xlnx,axi-ethernet-1.00.a";
-- 
2.34.1

