Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1069A358379
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhDHMkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbhDHMkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 08:40:04 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C1AC061760;
        Thu,  8 Apr 2021 05:39:53 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q5so1706068pfh.10;
        Thu, 08 Apr 2021 05:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VzV7lyQln0XA1JCgSeiUWDox5dSI+LspNrlFJBEvVLU=;
        b=QIWyO0KBwbb5dGIuEFslPQ/f53R82wAXpF7mjSFJR3GGw+u2+NKsqHi1jTpyAmpEkO
         FgRBI8rx08Gqu0SK1G7LMVN7SE2S02IptIAI3MM77KjYfhGVz4i5oKQ8YZ6sf8njcoPS
         IuUBTp4eg1/e0iIrFWpQ1oDnuwJm/krfqAqjlbodf9VbkLxKaPTM68PYtfYNVogTOZrB
         eGdGuDZ9+XA150W4RqNg0DhhTnQwMMNL9nzm1wG+9VPH81sGM5qYKwBEeYrcxyf6ZtiH
         ijK/gkBu893mLqTVPRnXrhgP8rJ7oQGnG/v1isisnlJ3mXVS0vgwMdHRMnuZNvpPwOuz
         ZrvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VzV7lyQln0XA1JCgSeiUWDox5dSI+LspNrlFJBEvVLU=;
        b=jJ5Ac4GQMz6IzBWkd5iNWG47fheh2se51aXbqhPUbdhYK6oRBMe5xJQenWdlmyjOgM
         twGydg4yycSGJH4od2x4kcStpU6UtNvtbNIShBzYHIuxGD3NzsEVWuhf3699D0fyJjN6
         ejKuv22YgSlPLexw4danYtP5ihTtKAp3XA+Wb7Dn2caAqr7ASV53mMPFKuR15sSZjRYD
         Oih+NrY7nL5hnMQLI6DtdZ0CMGuRoXAyGa5VYO9z9WfLcJEXEw4o9uft6PpfEmqtDLMV
         s1OjFUrJeK4zyUoiHYnMfsk6gYnGmC8drIgu1UcV7Xw81VYlEXGZCFxno9X5o22XpI7i
         l3Sg==
X-Gm-Message-State: AOAM532V5zow+79Pxz4HHNaAUSSrPj5ul7mh5irpRT6jpt+Qp5DVvKGe
        3LHinuKW2xnZJuY6Ka5+vUU=
X-Google-Smtp-Source: ABdhPJyp9VaFPFEAmeGKoQRHaTt2iO4zA2XvAzS+8Y/ejS0RpUBAyI51ofexpaE0Z60Yve2L8YNZeQ==
X-Received: by 2002:a63:d449:: with SMTP id i9mr7609621pgj.227.1617885592981;
        Thu, 08 Apr 2021 05:39:52 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id e65sm25831311pfe.9.2021.04.08.05.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 05:39:52 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [RFC v3 net-next 3/4] dt-bindings: net: dsa: add MT7530 interrupt controller binding
Date:   Thu,  8 Apr 2021 20:39:18 +0800
Message-Id: <20210408123919.2528516-4-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210408123919.2528516-1-dqfext@gmail.com>
References: <20210408123919.2528516-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree binding to support MT7530 interrupt controller.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
RFC v2 -> RFC v3:
- No changes.

 Documentation/devicetree/bindings/net/dsa/mt7530.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
index de04626a8e9d..26b34888eb62 100644
--- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
+++ b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
@@ -81,6 +81,11 @@ Optional properties:
 - gpio-controller: Boolean; if defined, MT7530's LED controller will run on
 	GPIO mode.
 - #gpio-cells: Must be 2 if gpio-controller is defined.
+- interrupt-controller: Boolean; Enables the internal interrupt controller.
+
+If interrupt-controller is defined, the following property is required.
+
+- interrupts: Parent interrupt for the interrupt controller.
 
 See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
 required, optional properties and how the integrated switch subnodes must
-- 
2.25.1

