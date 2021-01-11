Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A332F0C9F
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbhAKFpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbhAKFpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 00:45:46 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594FBC061794;
        Sun, 10 Jan 2021 21:45:06 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id f14so7106978pju.4;
        Sun, 10 Jan 2021 21:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hAuWqa9zlPPGWTNtjhAqXZcvz6sHDTbdxmpDtENLE64=;
        b=rVbqmT/X02rO8QBcLBtux6QeipDc3s5TLMhcnvsfAnV0FdYwRR4249B8XlG0gTcLYd
         c9ZL9CdNUraHUjRWCVo8yDXS3mIPiuqp7gkFcOBSStM3l8dnoIOfdUKJqYe9h0ladMAH
         VRWJSUALWmnPTCPXZZele6O3aQIwtlZqp/lGa6H5OLcaGaRMYOtbCneNSSghgma78Ux0
         nFN4zeRq1Pq02ync4HzngCCIc1DiaVTqQr61kmqgd08oiTmig90ol8sU5G//3ImlRBr0
         bVIiUwZ/z38PAoDYNijItNCO8q1+cbF3ShxzHfozfg22e4JDc2ig/QQ4UGa/+4OmAqER
         67gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hAuWqa9zlPPGWTNtjhAqXZcvz6sHDTbdxmpDtENLE64=;
        b=rY9bhtsy/A2KylFy+lS7hFy0wV1Wx8IK2AIhih9PCOaFpGXiJXegqx7SmnCkOPd1gJ
         +zC9llv5IXG4EYtJNSzRQyCSnhSPGuid5oTSDSp8scUnazCS95vI7zoPEO3Wp96oT6O1
         85FTYiq3f7ikPW+kty5kh4Xdg3EQG5yCFU/3ONDv5R9Z0Lps2tXUN0Vzi6N5zBv+VHkP
         sU3Q03c4RI6ZfFCP9Q74KjrFylT6112brlsg65mkG9GPjYfiaMnJL/VB+9ESgI9h/E5z
         Ge5kRpszoo6cgoVBJxI+T/Xt4d1mbUW0Fy/qB/HyrNmjT6fru9ct5LCFoueqBlv1PQbT
         02fw==
X-Gm-Message-State: AOAM530j+ZvB+R/ICGYmFMcPf5HJfscFUEZu6jFViP+b/PLDV3Bufs3P
        rzKc4fBdwSvWwHmPls5up/A=
X-Google-Smtp-Source: ABdhPJzo3wpZfqA6rcjyBlf0VOquXBGwi2+VZQkVOwsgg4IQXYtz5suctAmJgG79C9X13kRDPkqZLg==
X-Received: by 2002:a17:90b:1894:: with SMTP id mn20mr16282586pjb.100.1610343905989;
        Sun, 10 Jan 2021 21:45:05 -0800 (PST)
Received: from container-ubuntu.lan ([218.89.163.70])
        by smtp.gmail.com with ESMTPSA id q16sm17548005pfg.139.2021.01.10.21.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 21:45:05 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next 1/2] dt-bindings: net: dsa: add MT7530 GPIO controller binding
Date:   Mon, 11 Jan 2021 13:44:27 +0800
Message-Id: <20210111054428.3273-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210111054428.3273-1-dqfext@gmail.com>
References: <20210111054428.3273-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree binding to support MT7530 GPIO controller.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/mt7530.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
index 560369efad6c..de04626a8e9d 100644
--- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
+++ b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
@@ -76,6 +76,12 @@ phy-mode must be set, see also example 2 below!
  * mt7621: phy-mode = "rgmii-txid";
  * mt7623: phy-mode = "rgmii";
 
+Optional properties:
+
+- gpio-controller: Boolean; if defined, MT7530's LED controller will run on
+	GPIO mode.
+- #gpio-cells: Must be 2 if gpio-controller is defined.
+
 See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
 required, optional properties and how the integrated switch subnodes must
 be specified.
-- 
2.25.1

