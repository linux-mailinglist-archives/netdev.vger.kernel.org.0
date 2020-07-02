Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A83212BA2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgGBRyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgGBRx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:53:58 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B094CC08C5C1;
        Thu,  2 Jul 2020 10:53:58 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id z63so26420823qkb.8;
        Thu, 02 Jul 2020 10:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=adUOUcaETQkVS7cnauVlN1+FIVTZhn7o3LTKSzYe1bc=;
        b=ZmldpPGGAUupGOjBWcXeGZIszb+8n3NZchM0xyTr1Z5NPEb76YxCQFLl6o6dZN9GSC
         TA1jf3ctAaiaoq8ZLPZU/WgKURo0KWp69XwkMuCvIJerC8NgvOfUCbG2HZorgBQcWOHc
         /KtHoU4JW1J/kVrL7kLtBRV46H3Db9ysJizxf8jjehx3I2uvdmMN1GY1rrtQRc42ARJn
         h5XtniBloV6rmeqvKUpOIUZOvDRfNZZC6+fHJDCY+/lyZtqPRw2rvSZJ4PAp2RzYggzx
         o+G7m77jsgBgtsjWQKhRaNw3gxbM2L0s9F/ljFqLgGw550KGzvNBK95YTZ4qrCQP5Mfp
         RecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=adUOUcaETQkVS7cnauVlN1+FIVTZhn7o3LTKSzYe1bc=;
        b=cOUDxyPIT+9+YMye3VleycM2DXxhOmHGuk4q3u6l2L8NoraRWLwl3VdM2g3irvzeEy
         gD6/Fi7bF+++6UM9VXx6i90Ku5k43rK+oA6fdkcLHfGd/7miSyb7nvaXMrXMdy5uSkIQ
         HJ0GEqKg7k9ZvP4QxhpaPGMR3GF3CaYVbYMsTxtlOts9FQOmU8bWZsYOHoWYyKi8Mb+o
         BFUFwozZDVv0P2Jnyg64WVVfkt/qy1JnDOy8RoQxvTyaPYCKNmMYhleXCfxjyJmsn3fl
         +JU/e40h6hoepzZ32fQ4njwiVTS6gsX/37OTv9Bijbxo6ZNc8FUrIw+XVyNsclPAaykh
         6/3A==
X-Gm-Message-State: AOAM533uEqV07MgC6bQeUhp6Z4gKvZdM459+SstX4Wo13maROOUXYAIg
        HHIoEqcr/xQnKXXVNShaers=
X-Google-Smtp-Source: ABdhPJzIHwAA0Q0Poo8Me3UUZPAvAoi/DLDdPOje48J0iSrJbC+Eib9upIcn4CvPceOSoRL1jothQg==
X-Received: by 2002:a37:a785:: with SMTP id q127mr30241028qke.334.1593712437648;
        Thu, 02 Jul 2020 10:53:57 -0700 (PDT)
Received: from localhost.localdomain ([72.53.229.195])
        by smtp.gmail.com with ESMTPSA id w204sm9149937qka.41.2020.07.02.10.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:53:57 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     shawnguo@kernel.org, fugang.duan@nxp.com, robh+dt@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/3] dt-bindings: fec: add fsl,ptpclk-bypass-pad boolean property
Date:   Thu,  2 Jul 2020 13:53:51 -0400
Message-Id: <20200702175352.19223-2-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702175352.19223-1-TheSven73@gmail.com>
References: <20200702175352.19223-1-TheSven73@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If present, sources the fec's PTP clock straight from
the enet PLL, instead of having to be routed via a SoC pad.

This is only possible on certain SoCs, notably the imx6 (quad) plus.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---

Tree: v5.8-rc3

Patch history: see [PATCH v5 3/3]

To: Shawn Guo <shawnguo@kernel.org>
To: Andy Duan <fugang.duan@nxp.com>
To: Rob Herring <robh+dt@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

 Documentation/devicetree/bindings/net/fsl-fec.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 9b543789cd52..e34df25a38f6 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -39,6 +39,9 @@ Optional properties:
   tx/rx queues 1 and 2. "int0" will be used for queue 0 and ENET_MII interrupts.
   For imx6sx, "int0" handles all 3 queues and ENET_MII. "pps" is for the pulse
   per second interrupt associated with 1588 precision time protocol(PTP).
+- fsl,ptpclk-bypass-pad: If present, sources the fec's PTP clock straight from
+  the enet PLL, instead of having to be routed via a SoC pad. This is only
+  possible on certain SoCs, notably the imx6 (quad) plus.
 
 Optional subnodes:
 - mdio : specifies the mdio bus in the FEC, used as a container for phy nodes
-- 
2.17.1

