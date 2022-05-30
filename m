Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802E0538541
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbiE3Prz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242725AbiE3PrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:47:22 -0400
Received: from smtp11.infineon.com (smtp11.infineon.com [IPv6:2a00:18f0:1e00:4::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70C5985B7;
        Mon, 30 May 2022 08:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1653922978; x=1685458978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VzB5TwT9laR/+mLY14M2Ys1oLWi5u4DgIFh1SEuLlZM=;
  b=e4eUN8oWlYtviprCi3xOM7POunpEfoTJHBulurq3IZJowq3MOxcgtezq
   MZGp/bhGV95KeIsP4S5w1Z/OBJqgra/4O/w8DUlAHfSZ6wtV2cjipcms/
   Aq/MUNR0du8dZhr/3RX+dJewQy7Q9Cq5ZuHN5SISJtjm1mmzBrJaMsi4d
   k=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="298846059"
X-IronPort-AV: E=Sophos;i="5.91,263,1647298800"; 
   d="scan'208";a="298846059"
Received: from unknown (HELO mucxv003.muc.infineon.com) ([172.23.11.20])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 17:02:54 +0200
Received: from MUCSE822.infineon.com (MUCSE822.infineon.com [172.23.29.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv003.muc.infineon.com (Postfix) with ESMTPS;
        Mon, 30 May 2022 17:02:54 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 30 May
 2022 17:02:54 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 30 May 2022 17:02:53 +0200
From:   Hakan Jansson <hakan.jansson@infineon.com>
CC:     Hakan Jansson <hakan.jansson@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
Subject: [PATCH v3 1/2] dt-bindings: net: broadcom-bluetooth: Add property for autobaud mode
Date:   Mon, 30 May 2022 17:02:17 +0200
Message-ID: <f395ffd03a6594ee11975b708721a33ccf8a4871.1653916330.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1653916330.git.hakan.jansson@infineon.com>
References: <cover.1653916330.git.hakan.jansson@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE808.infineon.com (172.23.29.34) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add property, "brcm,requires-autobaud-mode", to enable autobaud mode
selection.

Some devices (e.g. CYW5557x) require autobaud mode to enable FW loading.
Autobaud mode can also be required on some boards where the controller
device is using a non-standard baud rate when first powered on.

Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
---
V2 -> V3:
  - Rename DT property and modify description
    https://lore.kernel.org/linux-devicetree/e6e83743-1441-dc53-fd1f-cdfb9a24932a@linaro.org/

V1 -> V2:
  - Modify property description

 .../devicetree/bindings/net/broadcom-bluetooth.yaml        | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
index 5aac094fd217..0a58d0fbcbc4 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
@@ -92,6 +92,13 @@ properties:
        pcm-sync-mode: slave, master
        pcm-clock-mode: slave, master
 
+  brcm,requires-autobaud-mode:
+    type: boolean
+    description:
+      Set this property if autobaud mode is required. Autobaud mode is required
+      if the device's initial baud rate in normal mode is not supported by the
+      host or if the device requires autobaud mode startup before loading FW.
+
   interrupts:
     items:
       - description: Handle to the line HOST_WAKE used to wake
-- 
2.25.1

