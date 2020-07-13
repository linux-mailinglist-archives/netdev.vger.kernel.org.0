Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A7A21E1B0
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgGMUxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgGMUxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:53:45 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DF5C061755;
        Mon, 13 Jul 2020 13:53:44 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o2so1316328wmh.2;
        Mon, 13 Jul 2020 13:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ALurGzrJJ9wqkP2ke4uTKprfGDnx2zaAQBFzAuepUB4=;
        b=QZaSFTqHdagHJdkMYHPypk8cFC/5FtmTQkGnZ4jgNm69WsJW5rwpDbQqDBInBpO4Ku
         rLSLuXMoRXWxm1KVRHinFg5/kT6aj/3zlewCGDL2THtVzrhGlHDGOxavNY3KXR7oZab/
         UC3MMrG2u6YWtUn21ItZjxZ6+cOW+dgTf6/2FAkI6FA3RHlv2kIR8oMYjRogSWRP1Ixm
         tkf9YgDXo/+D4Evh2U5Td/zJq03vQvZgw/1BJZIi5sThIlxKFQIAiqmtkVNOtUvsCSlC
         GHbVGcmxBPuhkGQK9P7h1qjWyYXx3DZ/vZ9JPZfBpmikhWaUAZL4ixXyIXp33cxLrEKR
         /zCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ALurGzrJJ9wqkP2ke4uTKprfGDnx2zaAQBFzAuepUB4=;
        b=bAC+7iRLhVtvuswNBF87HtYEF/WZ0GyAAfGOlFvMBCiJoTSsIyAs0eZGgCqfci/9nC
         0ZvccCiLZ/3h07L4KVubBKWO90uQp91bLw8yHbNndGDSKXZQ+8eSRMbVmkgmEiSwDKV8
         +IA3lC9nJcoeOXu4G9Rc2urOlv8x9ia2mXmo+9kXxyZmEmT1YcEXMWiyEJewTt8OpMSM
         SJQX0XQkLMa8EMdK6KuH7xZxwGS2FNGP/YDLhhpgYlnEHoKSKa7AhZk6yLXwf/97/XzB
         GiDG5Otc7wmYfCLxLLQE8a0E/7dgAoP0TXK96uDctbwJKsAx9C/HSFKHzBBueDbnMWDl
         psQQ==
X-Gm-Message-State: AOAM533XimZ1zvyyyBRLki8C906kZMBfbyz+HBEFQneilfohL0xQ6gCJ
        mD3snP+qDsxtSeOJowCKUmW/OG6U
X-Google-Smtp-Source: ABdhPJzEX/tt0TMQMf+TPx9VPK4TeJsjDGIiyPDidh58RrSuPoa5tp7YEZ4O2oiNcvM7Dzp8Wh/5og==
X-Received: by 2002:a1c:a4c6:: with SMTP id n189mr1099908wme.173.1594673623480;
        Mon, 13 Jul 2020 13:53:43 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id u20sm1019921wmm.15.2020.07.13.13.53.43
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Mon, 13 Jul 2020 13:53:43 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Matthew Hagan <mnhagan88@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL properties
Date:   Mon, 13 Jul 2020 21:50:26 +0100
Message-Id: <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add names and decriptions of additional PORT0_PAD_CTRL properties.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index ccbc6d89325d..3d34c4f2e891 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,14 @@ Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
 
+Optional MAC configuration properties:
+
+- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.
+- qca,sgmii-rxclk-falling-edge:	If present, sets receive clock phase to
+				falling edge.
+- qca,sgmii-txclk-falling-edge:	If present, sets transmit clock phase to
+				falling edge.
+
 Subnodes:
 
 The integrated switch subnode should be specified according to the binding
-- 
2.25.4

