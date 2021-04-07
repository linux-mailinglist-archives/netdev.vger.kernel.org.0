Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0583562B2
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344784AbhDGEvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245635AbhDGEvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 00:51:19 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989B4C06174A;
        Tue,  6 Apr 2021 21:51:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t22so4944799pgu.0;
        Tue, 06 Apr 2021 21:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kob9kM8qKEEzCOzsXAg0KIs7vHQIWVRh0w9PgAne0+0=;
        b=dXTMJsZg/GrMTU0c/AixIr4aU/BTqwR2QxgJV/NuQIgJcB0lxw9kDiw403clhmF4fO
         2aOvAhOEp4uPWww5BxjpbNMunetyw2lgnAHILhPrl1cWpjdFi3zjawLn8xbUGDymzaKF
         RwB+wxHe96459XPgigMcPLBBMNrn8cTytSM1Mcw0WSR1bDNzRzyusv/9PGniwBECy9DS
         VC2KlWjgDdQmS/3rkaTaqkX05KHlcFaJZSiq61cFfIiDE7lMCRkQUToTz5eKGkBxnylh
         Qbw1ARx7qE7XLqlE7ZVnWhRoD3o9wpyINNUIQQzzqpH60RFLWTE3iErbNcucGU8pgrya
         ttOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kob9kM8qKEEzCOzsXAg0KIs7vHQIWVRh0w9PgAne0+0=;
        b=rYKhB6sXd5904t/DwzM+Y2twjA4gFP76pcXAxl9umpts/jlDL1NFvxQj2PxpJ1DxXe
         J9UhLqDG6azPoOQBjVRZTQ+/bEHGvru7adcz9IjNvbFVJZv3mDs7gcKHUlek6HGO6sBo
         dr+O2iCkAp6+Ivx+6MN73TeRLFNJH1NuQXgcaO0WLiIL/mdtrMhZKg4pJAn6cfIhQYaQ
         e57yY6kXK9FHPEvQsJJrpyo6wd6VtppjYsSahlmEp07NJF5372GGfOrUMd8KIA76eS2w
         H1bUw/jrl5Mv2wGx75XSLme8B8kyWYu0ihgw8nYzohVdHqkrVFFtxvIvIG/7TV4gJzp5
         UlOg==
X-Gm-Message-State: AOAM532uzw7klmE/qqyG+IcQpMmL2G7Lf3ztawRtldNnKxoiroPmRb7+
        r1wV82bZV/o4Ug7u1hLWoBk=
X-Google-Smtp-Source: ABdhPJxHn4yrsH/2HhCjyRtJImSN9tdocViiuu22y/xFL0ocTxflw1/WU2qpIbwdS8dCJYJWpo/fmg==
X-Received: by 2002:a63:5458:: with SMTP id e24mr1566769pgm.170.1617771068271;
        Tue, 06 Apr 2021 21:51:08 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id n52sm882679pfv.13.2021.04.06.21.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 21:51:08 -0700 (PDT)
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
Subject: [RFC v2 net-next 3/4] dt-bindings: net: dsa: add MT7530 interrupt controller binding
Date:   Wed,  7 Apr 2021 12:50:37 +0800
Message-Id: <20210407045038.1436843-4-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210407045038.1436843-1-dqfext@gmail.com>
References: <20210407045038.1436843-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree binding to support MT7530 interrupt controller.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
RFC v1 -> RFC v2:
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

