Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A02355669
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 16:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345043AbhDFOUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 10:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244479AbhDFOTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 10:19:01 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA89DC06175F;
        Tue,  6 Apr 2021 07:18:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d8so7575494plh.11;
        Tue, 06 Apr 2021 07:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LbWbWwUxe5h4QMRiax70raYE15ondtl5QuCv8uqAlow=;
        b=ozYfLJN+OmcehQ92A311DXwyXKgKpWbY5d0TRISlyhg9Nte0tv+K5rva62BaFJxwfR
         nEDDrZJSZ20Yl9dfTENDC3ZxEQSyDhGNE6QTsCG30QQbpTFJQgcxLUrfUlc54PHEOXz4
         ssfaPg09GQhnaPsLYtwiNvVqf3qtGsMETgiqvkA2NJLlJe86u+K2UIG/WHIll7fF72ny
         4b8aUVgd4/cdEhxg65HkDQzcyISnDG6r0dl5ffjDCJg9d8F7y7VMQ3DaD5Juq17Tb9uC
         0StHqCegFDA/B80U4x0TP1ugQLj6srQtLNKf19HpZnNVcK2a72sWka8kqo9dBrCW2bte
         XiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LbWbWwUxe5h4QMRiax70raYE15ondtl5QuCv8uqAlow=;
        b=RUc7hDFzkpOedamBxjGZkiXFOBgcB4vuOoEVETvVAkW/TiMwbKkRiUbVN5bZDyqxt7
         MjognRDdmAiP9hV5v36P/0tqP4I8BSYutLps+kzqM48CgvdZajmZcdh0x+L16nZJJLL2
         A5rqZXyDWBtLVhypTRsCTCfGmbGpAmdBhVCZPhds0dA9N3doVU/Sprqv3vIDr2OibulV
         M7Fuj5jUec4Z8gKlgiBgdsU9tnjZ97onnJZMI/mcsyj5Cj6EMGJHeKrOFUK45gQGcl+R
         DyTenjYtRdfexIfFwtZe2Mgc6Nw3kM25kaeftDgIHfpul8IVqayQ7iMrWKLvC4uJmaQa
         MqyQ==
X-Gm-Message-State: AOAM533QxzNqfkxhUQ5zRBklGp7zSEGSuQv/bPFUs3/Ef0yAJUIPtb00
        Hz2Gk+/p/e6L0qODE/llARo=
X-Google-Smtp-Source: ABdhPJyvnv9mxAiIu1fMH2/T9kEGB97LJFb36KJSG349MAt3DoEWfadAJykz7w6nvv7FZpkb8HNa5A==
X-Received: by 2002:a17:902:9a45:b029:e6:1444:5287 with SMTP id x5-20020a1709029a45b02900e614445287mr29150408plv.54.1617718730582;
        Tue, 06 Apr 2021 07:18:50 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id u1sm18337581pgg.11.2021.04.06.07.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 07:18:50 -0700 (PDT)
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
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [RFC net-next 3/4] dt-bindings: net: dsa: add MT7530 interrupt controller binding
Date:   Tue,  6 Apr 2021 22:18:18 +0800
Message-Id: <20210406141819.1025864-4-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210406141819.1025864-1-dqfext@gmail.com>
References: <20210406141819.1025864-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree binding to support MT7530 interrupt controller.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
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

