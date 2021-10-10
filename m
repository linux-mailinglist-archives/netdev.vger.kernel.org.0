Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6734280BF
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhJJLSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhJJLSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:21 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA290C061773;
        Sun, 10 Oct 2021 04:16:17 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id d3so27933806edp.3;
        Sun, 10 Oct 2021 04:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uPNQWTQgfdkkXKMJr1+g12wykYFN16QL/UUyG9V1XkY=;
        b=Mln2J9Ir+tatNX5V+7MAck1jW68vPWFgrMrDKGS7LUZNCJTaH4S5qgsO393zWlPHlr
         r45k8tCe3AqKnYZnsybM7T0RRFva2JMoF4tX2WbIDwpBgOCfbXpQmKnXtAXGCoha2p/4
         IzSTkxB/PJSk971mweuzg5NvBMcKD2q9NOvcQ6+U2Hj0c5DQflt+FmT9YbN55o57Mjlg
         Y/AVFbKS3HL0ZNT0C6I7hDBj9vttkSuUzCmKJ2KERmDG09m/pyU1nvXja0sKJa/mUKV7
         HeEeaeFPySf+nauyica93LI8M7gsQHDUBmD78Ki1ay733guX6jyMpE+ROZ2gPnVapVsr
         vSAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uPNQWTQgfdkkXKMJr1+g12wykYFN16QL/UUyG9V1XkY=;
        b=AK4CBLJIfsXrQKLDWi2nWThTzYrA6l8VNJCbikJJIjw1Hn5QN3uEDboKQ1vIfWV/UK
         0UJ6QIeeVBdF71abgnEeT8SEbWw1aEp4b4sL5T/7ZmDMPtNHWwXCAYsgX4iRoOyfPAv9
         5yxgwEQLwMXRfTaxLk+Y9IQqjLByAAqEyasRAfAta5mZVABXjVaHrcZ7WzVlJ37CogqX
         U50+vtOBFyfncjWQSGWmSBvmf+ihTyce2YakfR+2A54z4r0QkW6CbpHrQO8DdkE+v43D
         sDuvfgVQlogGCE2OXCGTPJKXLuakGTY1m9lOM7P8vMORXHch4cFF4UJxAmujdGYMqIt+
         a1jQ==
X-Gm-Message-State: AOAM53361+8xTLkyMyHw9zAF+czMQsnVS1OsrhfGrWW166vo+ro/XC8c
        lFbE/zLeCXbJixp++5l8LeY=
X-Google-Smtp-Source: ABdhPJya9nXA8H1mAFMx8f+OoRnPOzWIqfCxdUhkAMu8sahu8TxEWjXacdW953i86sSW6Y/WxjgJWQ==
X-Received: by 2002:a17:906:b6d0:: with SMTP id ec16mr18741674ejb.229.1633864576279;
        Sun, 10 Oct 2021 04:16:16 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:16 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v4 10/13] dt-bindings: net: dsa: qca8k: document open drain binding
Date:   Sun, 10 Oct 2021 13:15:53 +0200
Message-Id: <20211010111556.30447-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document new binding qca,power_on_sel used to enable Power-on-strapping
select reg and qca,led_open_drain to set led to open drain mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 05a8ddfb5483..71cd45818430 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,17 @@ Required properties:
 Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
+- qca,ignore-power-on-sel: Ignore power on pin strapping to configure led open
+                           drain or eeprom presence. This is needed for broken
+                           device that have wrong configuration or when the oem
+                           decided to not use pin strapping and fallback to sw
+                           regs.
+- qca,led-open-drain: Set leds to open-drain mode. This require the
+                      qca,ignore-power-on-sel to be set or the driver will fail
+                      to probe. This is needed if the oem doesn't use pin
+                      strapping to set this mode and prefer to set it using sw
+                      regs. The pin strapping related to led open drain mode is
+                      the pin B68 for QCA832x and B49 for QCA833x
 
 Subnodes:
 
-- 
2.32.0

