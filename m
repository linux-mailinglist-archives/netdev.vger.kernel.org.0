Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9B74249CE
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239921AbhJFWim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239794AbhJFWib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:31 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670A7C061755;
        Wed,  6 Oct 2021 15:36:38 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y12so1831252eda.4;
        Wed, 06 Oct 2021 15:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ppZK0xlokOK6wVW0tsp0ryQNeuXsve1XjT4XzytsXi8=;
        b=f43tkDv01r8DZMqvpRZuopz6vpdYE4eJjgXz1kNvewNjwi5UJp5Hd+wWVMDSFNkrVn
         bZtfqdN8td22dr0P1A9F23r6rLZ8nQ+BoNPZ8n3VgMgXc95hCheu6FnJgNviDvAblM+y
         YNz2LucqMBgSLCH9djTbrlamvhrRWUB65/q89dfWmqk762F7rRFcLC7hsGZlbi7jTy7G
         DDxeTdSSen1qninELUbHoKGQZJpMIClhyZo9miN9feIPvw/yYQyy28Woe3J+xwsBfb+P
         3iFM6EzUw27KVD2O8VhoC+Qi5nFrzpGDwjCdGzOcQw88ZEkp4JCEd8o/tEVE1Fd37BZZ
         0nVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ppZK0xlokOK6wVW0tsp0ryQNeuXsve1XjT4XzytsXi8=;
        b=NP4X2R7TMZf8zv+g5CuwpEMyhNoDxRzC+B+0T2lAjweFI9Be+sAN8XD10Xbh++ZAyF
         rhNcF3LoTZKbHUIRPI+f5qvXdaBmJQtpoJj12OGL/02QSzoI/2rmDsqmZUZTEn4Ymr/f
         ftrjkF05kBa76qh8RwWq5UixtjzQCG70jWNsRg/FxgNnfLso8qpW/CcD5xDoJfC6Tiie
         19r8Z0Eg49taFikD03xlaecvXNCGWoiHigVw9RDrwsp5hhbHGT10D5mzmCy2A0zFMt2w
         4+OquRa9SutpGeCCMtivH7TiGJPfqstDhxsWlgcCJwjfaMauLBbcVQ0L6cP4dD5nm/5P
         waBA==
X-Gm-Message-State: AOAM532d8MJvxR2XIXPYJDrSAALcLGjUmoD4Cs14tbnf6Figj5HvScte
        jvSl+vdCglpJlmEIv9vlxVY=
X-Google-Smtp-Source: ABdhPJxGnOt49UtjvDpQ6rPF7ERn4+64c4tCpWEsPHNAwZ9bX8OHZc3cnvkrXGvg706660jR1M17Ng==
X-Received: by 2002:a17:906:a404:: with SMTP id l4mr1066794ejz.175.1633559796867;
        Wed, 06 Oct 2021 15:36:36 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:36 -0700 (PDT)
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
Subject: [net-next PATCH 08/13] dt-bindings: net: dsa: qca8k: Add MAC swap and clock phase properties
Date:   Thu,  7 Oct 2021 00:35:58 +0200
Message-Id: <20211006223603.18858-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
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

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 1f6b7d2f609e..780d1e60c425 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,9 @@ Required properties:
 Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
+- qca,mac6-exchange: Internally swap MAC0 and MAC6.
+- qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
+- qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
 - qca,rgmii0-1-8v: Set the internal regulator to supply 1.8v for MAC0 port
 - qca,rgmii56-1-8v: Set the internal regulator to supply 1.8v for MAC5/6 port
 
-- 
2.32.0

