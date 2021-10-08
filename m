Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6C4426129
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242267AbhJHAZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242632AbhJHAZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:04 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA08CC061766;
        Thu,  7 Oct 2021 17:23:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t16so7774504eds.9;
        Thu, 07 Oct 2021 17:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XJMjxj05cbsAxmZQzWcQJCXUl9rd8lI9atlf1MxmJbs=;
        b=ol+gT4hbjP3GoUVT0BSfUnMzGnMAQNBUPlS0VVzAbOjLtLX58XINMMPBmWmOp3OeBc
         dll1d9xYjHBjo2yYG2lbSsHmxX8vCsHJEoyJokLKixToSGd2d/FCfhLGJNui6F4hGSl2
         e9p8DLDfllnyoya2YARYra0+Erm1TNtnTgXI4UjAPVRkFKdHqhHLYEeMYWOZGo2xAxbG
         zxz4yQvcte6JoNJOIAXZ4B/TLMFA2H6NxeFWm7L7332N/jfk87mA/uTcezvTN6vuz8Bi
         WveXAnV+KJY2qvQuNfXPrhANb6Gqt00ts75aVBoo8uBbosSBxluj94f+XE+m5c2+hgUC
         XBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XJMjxj05cbsAxmZQzWcQJCXUl9rd8lI9atlf1MxmJbs=;
        b=oRVKTFAYYvPAd19IhB3dYINR9fXXAJGWHrmom277SqOFYRwgckXn2FZMYqW6dPDXHz
         YZQaLHgfG6wqe88o74nUOkwJ/gAoUNQKqc/wp45DhHvWpsuVFkfPgODImK0IvsGzympl
         9rkOzubCw8QJAdJ1cTpOf+v91wcGTdAz5hohYp6xx0jveK8Bpg2qYURz2wR3f8YvPTiV
         wpE0i5Wtae4HDx+KZiI7aYP5s2NaAL9mSMyDFzx4bzhbT09YGYbbj+EHTpuoLQG3bc4x
         +zQoAVvocKU7tpbs3OvQC7ZYe2JNaWBZFQJrIggg77tAt9KO2/8WpqKzqVUkIKTPQKFl
         TT3g==
X-Gm-Message-State: AOAM533RQmSwFHuUGu2DO8RePioEuW06XB4HKdRYruzsIvckkTDcxlpV
        K9HXRrtVxeb6Z9sO0VfAgJk=
X-Google-Smtp-Source: ABdhPJwNRp3etoGRF2GU3+4liOfEb0/uIrrvcQbczDZI8boOZQdJ6VQEcpW2JCH3F8VwCU8IER78yQ==
X-Received: by 2002:a17:906:ce2c:: with SMTP id sd12mr141597ejb.488.1633652588159;
        Thu, 07 Oct 2021 17:23:08 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:07 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v2 08/15] dt-bindings: net: dsa: qca8k: Add MAC swap and clock phase properties
Date:   Fri,  8 Oct 2021 02:22:18 +0200
Message-Id: <20211008002225.2426-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add names and decriptions of additional PORT0_PAD_CTRL properties.
Document new binding qca,mac6_exchange that exchange the mac0 port
with mac6.
qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
phase to failling edge.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 9383d6bf2426..208ee5bc1bbb 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,11 @@ Required properties:
 Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
+- qca,mac6-exchange: Internally swap MAC0 with MAC6.
+- qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
+                                Mostly used in qca8327 with CPU port 0 set to
+                                sgmii.
+- qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
 - qca,rgmii0-1-8v: Set the internal regulator to supply 1.8v for MAC0 port.
                    This is needed for qca8337 and toggles the supply voltage
                    from 1.5v to 1.8v. For the specific regs it was observed
-- 
2.32.0

