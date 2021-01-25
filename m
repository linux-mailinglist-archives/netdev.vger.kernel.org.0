Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696C8302152
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 05:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbhAYEo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 23:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbhAYEoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 23:44:25 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7769DC061574;
        Sun, 24 Jan 2021 20:43:45 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id w14so7697542pfi.2;
        Sun, 24 Jan 2021 20:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T9bTASvod5sbvVwttrc2+CYFICW79RJZhXF8w04wT70=;
        b=YCSjHPhPCUPD8tm7Dj9UBzRUCwjeZAiEG4V4XzUYSWKamjwHrWf0cIComjYQaDAL0d
         4jYpBLKcAeb3yfxNeadJZjiQLq5JOfqZXO+p8J7suMLTsHAbCjRCzM2Jvc9M8duKQK/P
         N0uZY2iP2gcRh47De2AnBtNlScdKOM3dhMCrUlgLTBjfAxgP/agf/oT9aztb/u/EbBMp
         +0/WxaK6gSXmrPnqO5Rmy47k//TdJswKxJZVE/MrTtGDCBZFDyQVBi6xM1D4BXqr29WW
         EgwXCibdCzvDFgMG+2QCR4la+rci4DEsSOTqWW4oqEOazt8aO/8BEhCzuXnB9E9iub0F
         Q/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T9bTASvod5sbvVwttrc2+CYFICW79RJZhXF8w04wT70=;
        b=RoiyWamzAlZazOKqfGDjwgAEVgLfUG1mvtJTtn83aAFJNqfRyIY1+lmp1EsjZ1RYjr
         J/q7ry4lG5F4TeBT2IWZkX8JEDsq4/C/03VZvi41z8Zarry/zvLq/LNfHXzbGzwMsg9I
         EUnR2QmM0ZhMHIBhGDxkuqhAY8PH7QKk+m2wrKbisXUv8FZc6cnKw89Srsjoaubl3gIq
         w8d8JPdp8weXm1aQdZuyRkMV6Ubgs/TUIlxuWbXdCHv6BRrGelZEZNcnoNP+IB9NQ2I7
         h7Pxa+7ro3XGkEYzC3PVNySz6DaR0rPMXr/NSKhsAhWmspBxRTzGep3PThGZAUGrhqNh
         9HAA==
X-Gm-Message-State: AOAM530cZjcdd/FJyT2DUl2jbmf4uGkBJZgngi+A+Mb85yFmaXeks91E
        i+l6ilf98n55oC0s8kswrT0=
X-Google-Smtp-Source: ABdhPJywH2N84xQzNs09L43C4nXwNMfHq/UIzjBrV0gVRmurMCVufNe79/5MllBZPqqzOht3KbM+yw==
X-Received: by 2002:a63:4f01:: with SMTP id d1mr129857pgb.279.1611549825010;
        Sun, 24 Jan 2021 20:43:45 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.26.203])
        by smtp.gmail.com with ESMTPSA id h4sm11913369pfo.187.2021.01.24.20.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 20:43:44 -0800 (PST)
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
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v2 1/2] dt-bindings: net: dsa: add MT7530 GPIO controller binding
Date:   Mon, 25 Jan 2021 12:43:21 +0800
Message-Id: <20210125044322.6280-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125044322.6280-1-dqfext@gmail.com>
References: <20210125044322.6280-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree binding to support MT7530 GPIO controller.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
Changes v1 -> v2:
	No changes.

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

