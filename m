Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398584EA586
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiC2Cx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiC2CxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:53:24 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DBB1B30BD
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:51:42 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i11so5109662plg.12
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pp0QDLmVJXQogXrqKnxYnigTDfjr4o8XzBN1Mq4j/TQ=;
        b=BxYROShJo7y5nzQyhJV7J578y5kVFOGTYOK+3CC5PbEh5cH8e8jFtFs2GXQSpKNRLG
         7fYdTBAEEF1g5e4rpP8vc+o13LO/st0vC3u7FpefwaZ2KKVj8MFv9GFq+0m7KxFoeXnC
         Gutf7+2JxCo+sAzxCbqPereILnxs9Qg8HBpHZKKTZjMNbAsGqqlKDr8iPLilOCF8PJzI
         z0KQJgK3OF0IKde8Ixn/KckAuV5YKPlYAW2DQYrlMqeCfiXbHRXETVnxSbNe4akA+KlP
         jMLYGCGAIJNgPN1GIcbzzdywuRHusHxgjlc4qmHRGc/aK75j+rtB4JTRDpkMMnIZeqK9
         oKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pp0QDLmVJXQogXrqKnxYnigTDfjr4o8XzBN1Mq4j/TQ=;
        b=wxktdfxbd8JG6Clm6OxL6LdFWxYDEAgXxumLiyraN6hHL61x5/RBJ8kPhOSkgF4z9I
         T5n9G4NAdPbBFUnKW13+6Ty6mhTUogQm+Cb/QWWE4djAATkfmRt6GdnHmbqlH7N3m332
         7/lRQcYz4aRk7Oy+T61bt9QL+uECM9YcG8AGVTxah9lf8vFTsYe6yEjd/gtBVOFVXmos
         x+XywNaS8CKsX2LDk97AGv01dg0AqncTfRp8AK5DF60naXFQ7EwMvSwL1qO86uWREDHn
         XNvVokYWcdwoujGzBRlBf3Cs+a92M1KEI2b0FBWIU5hY6YyYx8rj4P6f0GsQX3OXH5y6
         yhlg==
X-Gm-Message-State: AOAM531RU4MADQSddcZ824IcKGny0D66/YyxKXzDn8798Vg+39DkRfNo
        Vq0Rts/LdZ8k4D3rsWJjJAUT0g==
X-Google-Smtp-Source: ABdhPJw8ezd01KwgiMsaVFyMC8hb83WSHujUbnbJ6ija7W0AmR/80TSYfsjBsyL2HcbfjmdnYDOsQA==
X-Received: by 2002:a17:90a:889:b0:1c9:8baa:3eeb with SMTP id v9-20020a17090a088900b001c98baa3eebmr2223151pjc.44.1648522301892;
        Mon, 28 Mar 2022 19:51:41 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id f14-20020a63380e000000b0038253c4d5casm14136053pga.36.2022.03.28.19.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 19:51:41 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     kuba@kernel.org, radhey.shyam.pandey@xilinx.com,
        robert.hancock@calian.com, michal.simek@xilinx.com, andrew@lunn.ch
Cc:     davem@davemloft.net, pabeni@redhat.com, robh+dt@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v7 net 3/4] dt-bindings: net: add pcs-handle attribute
Date:   Tue, 29 Mar 2022 10:49:20 +0800
Message-Id: <20220329024921.2739338-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329024921.2739338-1-andy.chiu@sifive.com>
References: <20220329024921.2739338-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

