Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E0139BA73
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 16:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFDOD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 10:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhFDOD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 10:03:58 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F1AC061767;
        Fri,  4 Jun 2021 07:01:58 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u24so11243374edy.11;
        Fri, 04 Jun 2021 07:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7VXZYVDql9Qt/BRQCLNLiT4UcfVnIy1BL5qjD/tlYhI=;
        b=crrlEbFnIm8IqwZyk3FT8Tmvl80FvdHoCh5U6+HTxWtcRM5O+urcgOo3UHxM0dAFWC
         UKlD4LsvGeqzT7FhQL0dgYvaE8KROgqhi4CPYpFKvEJ0vLz7VpuEjLhONm+mWV9+ujR5
         wzLXnqRv7lzPQvCP7JnxCPf4gKHZlYeru7uN+SlAXQKb9ejY9I1XlddAZdDpRpqAiRct
         hXxzOBE4qTxAbulOMgdGDwcSXegnb1V9xFSQlMvh7Ch321gZCsuIjhSvBgEi0uKUVH7a
         2gijR8p319qJd81yml1MfMAwYAy+q1PvnsEnrir0z3lGk+fl9LY1yAlSlLcfWUMNGQi/
         3IZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7VXZYVDql9Qt/BRQCLNLiT4UcfVnIy1BL5qjD/tlYhI=;
        b=PW3AFNiu5ErjSS3F3nGa/pXm1VqB2yO08tsuPIFY/PXL8+ts/B7erDQTm7Uw85oTR8
         7ox2/eHQYNuIMw1MKnRzDUofNnWQGNSTrKtKOkBwHBNV1ld5Iue/TNLmmwBJFAI5SUd4
         D5afApTRunoyin0rtOrJw4G1hWvkn4OOnOvIUDWQpM7S52UIikTAt2fMNAnv7fnBG8sq
         AOfjTNLNzssMndRdWROI9GjJInuo1FAixyv3/mwaGBaVGL0WyldMVXwPPJYSwHJ2O8hz
         J9LMdWdT9qZD3UKg3JAGFN4GRjgrsYUMwHX+GI/iJsY4B5PiUb2e3iOks/+0wmyYBm9n
         7e5A==
X-Gm-Message-State: AOAM532af/lslCfAmtB1dm1AVnWzPgtMk/qRb/k09/DTqUotKdAN1I3U
        fRO9FhV7JYL+19+f3Gfzq70=
X-Google-Smtp-Source: ABdhPJxyG5JFyFH+HrRWNJPhK8INyjAdKJyTFLu+2dTbquxGAeDV1u220jvCUkATIabwcXg4OikTHw==
X-Received: by 2002:aa7:c545:: with SMTP id s5mr4830045edr.113.1622815316660;
        Fri, 04 Jun 2021 07:01:56 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id a22sm2804513ejv.67.2021.06.04.07.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 07:01:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 1/4] net: phy: introduce PHY_INTERFACE_MODE_REVRMII
Date:   Fri,  4 Jun 2021 17:01:48 +0300
Message-Id: <20210604140151.2885611-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210604140151.2885611-1-olteanv@gmail.com>
References: <20210604140151.2885611-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The "reverse RMII" protocol name is a personal invention, derived from
"reverse MII".

Just like MII, RMII is an asymmetric protocol in that a PHY behaves
differently than a MAC. In the case of RMII, for example:
- the 50 MHz clock signals are either driven by the MAC or by an
  external oscillator (but never by the PHY).
- the PHY can transmit extra in-band control symbols via RXD[1:0] which
  the MAC is supposed to understand, but a PHY isn't.

The "reverse MII" protocol is not standardized either, except for this
web document:
https://www.eetimes.com/reverse-media-independent-interface-revmii-block-architecture/#

In short, it means that the Ethernet controller speaks the 4-bit data
parallel protocol from the perspective of a PHY (it acts like a PHY).
This might mean that it implements clause 22 compatible registers,
although that is optional - the important bit is that its pins can be
connected to an MII MAC and it will 'just work'.

In this discussion thread:
https://lore.kernel.org/netdev/20210201214515.cx6ivvme2tlquge2@skbuf/

we agreed that it would be an abuse of terms to use the "RevMII" name
for anything than the 4-bit parallel MII protocol. But since all the
same concepts can be applied to the 2-bit Reduced MII protocol as well,
here we are introducing a "Reverse RMII" protocol. This means: "behave
like an RMII PHY".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../devicetree/bindings/net/ethernet-controller.yaml          | 1 +
 include/linux/phy.h                                           | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index e8f04687a3e0..d97b561003ed 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -68,6 +68,7 @@ properties:
       - tbi
       - rev-mii
       - rmii
+      - rev-rmii
 
       # RX and TX delays are added by the MAC when required
       - rgmii
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 852743f07e3e..ed332ac92e25 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -93,6 +93,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_TBI: Ten Bit Interface
  * @PHY_INTERFACE_MODE_REVMII: Reverse Media Independent Interface
  * @PHY_INTERFACE_MODE_RMII: Reduced Media Independent Interface
+ * @PHY_INTERFACE_MODE_REVRMII: Reduced Media Independent Interface in PHY role
  * @PHY_INTERFACE_MODE_RGMII: Reduced gigabit media-independent interface
  * @PHY_INTERFACE_MODE_RGMII_ID: RGMII with Internal RX+TX delay
  * @PHY_INTERFACE_MODE_RGMII_RXID: RGMII with Internal RX delay
@@ -126,6 +127,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_TBI,
 	PHY_INTERFACE_MODE_REVMII,
 	PHY_INTERFACE_MODE_RMII,
+	PHY_INTERFACE_MODE_REVRMII,
 	PHY_INTERFACE_MODE_RGMII,
 	PHY_INTERFACE_MODE_RGMII_ID,
 	PHY_INTERFACE_MODE_RGMII_RXID,
@@ -185,6 +187,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "rev-mii";
 	case PHY_INTERFACE_MODE_RMII:
 		return "rmii";
+	case PHY_INTERFACE_MODE_REVRMII:
+		return "rev-rmii";
 	case PHY_INTERFACE_MODE_RGMII:
 		return "rgmii";
 	case PHY_INTERFACE_MODE_RGMII_ID:
-- 
2.25.1

