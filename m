Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65EE4249E8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239934AbhJFWj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239947AbhJFWio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:44 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95604C06176C;
        Wed,  6 Oct 2021 15:36:43 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id l7so15717740edq.3;
        Wed, 06 Oct 2021 15:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aJj/1qPNuaVQFK3OzLpENkQJhnzkYtyy78uh6Vh8QNI=;
        b=L0TlaMBtITBxzhR1lZHviuIP/bQA5HOgoY9MF28mg2zKUsEhBR0OBg4qyBDW6UYQFK
         h3WVON6cCNud1Cat7h9vWBUhP2OwOOTj6xm9TWzuu9tZod7rsVDqmrRY0RPRnVU333mk
         oldpmbXnjLKEsaIdHF1YcdCctASMZd3pvTXT37JGjY5+rdi0NnHi+rJ9f+AeI1gw3JFa
         qiIcUMnMv+xTOZQ4DNtcjCAi+W8jOcJbWj6sai7XgeGvNd6zCqvmd7/lRSd7ZrzlwqYZ
         M3Lk762vdJfnD2xMzfpvljpuguIGED4unT/+FAEVPfZ7YAof8/HNMgpWgLp5APmJgovQ
         Uqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aJj/1qPNuaVQFK3OzLpENkQJhnzkYtyy78uh6Vh8QNI=;
        b=bplOCCeguD+DvJlfIzKzSUhOSiAxcE/+wdEdAznjmAKoqiVp9pl799bgNHMGGk3Z2u
         fc/rEqu2IItiOd4lTdeewcHkEAj9A9MOZ0qRtAjTEOBQMleH6WrvH3qRWVeCQjT2JLhu
         O3AlojWeaf/mb4HOhZHncwvwgiwZCLPJV+91kr3e+7gm+G1Vf9o7jJf2EWPwPMHtlYZM
         NEGsEO2clCEOPkGRXL/rZgPHxJIBj4qsy30laT5reTVlv0tmmoOt0WobjDEVycZs5wTH
         hElK8E+c4MUUCT56oZGPYfAERSMTwkZ4uAObN8s4LyBND6BP7cTltGWNgBKx9hMothIu
         khHg==
X-Gm-Message-State: AOAM532hApELI7cfOVwMASapc74Pi67ieowbfp82rkb4KMEH72PytiAR
        qWU+jGIshegQMN9buAxStYA=
X-Google-Smtp-Source: ABdhPJxkBNOH1aDqAS8750346rUpHDVKyJa1T5CfAuP5cz9uFbjkqTzrTsIXoRI8jkACY8ggS6wWdA==
X-Received: by 2002:a17:906:7d42:: with SMTP id l2mr1130949ejp.467.1633559802038;
        Wed, 06 Oct 2021 15:36:42 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:41 -0700 (PDT)
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
Subject: [net-next PATCH 13/13] Documentation: devicetree: net: dsa: qca8k: document open drain binding
Date:   Thu,  7 Oct 2021 00:36:03 +0200
Message-Id: <20211006223603.18858-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document new binding qca,power_on_sel used to enable Power-on-strapping
select reg and qca,led_open_drain to set led to open drain mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 550f4313c6e0..4f6ef9f9e024 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,10 @@ Required properties:
 Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
+- qca,package48: Set to 48-pin mode required in some QCA8327 switches.
+- qca,power-on-sel: Enable Power-on-strapping select required in some QCA8327
+  switches.
+- qca,led-open-drain: Set leds to open-drain mode.
 - qca,mac6-exchange: Internally swap MAC0 and MAC6.
 - qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
 - qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
-- 
2.32.0

