Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4132719C31F
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbgDBNvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:51:35 -0400
Received: from mail-wr1-f99.google.com ([209.85.221.99]:42600 "EHLO
        mail-wr1-f99.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732586AbgDBNvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:51:33 -0400
Received: by mail-wr1-f99.google.com with SMTP id h15so4282119wrx.9
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 06:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yPUD4F4jhx7/mi0KaztxcsCPAij+5GRCYLwubP4M4n0=;
        b=D8XUasNHDKei7vJxYiYh9CfYGlKQFR5U6+L/aCvM/bY5esrvXd6wHqponjNp/KcOzU
         /0xRh4TUOA9YkKeTs+ZOKjq3fFN1HYOu4yI5qo4LlOQFYOWtsldlguXeVI4dXAtGPaXO
         sdSUwO9qKjYD47nUp/21ad52W627XEk/e53y0zIII32VOQwxNw4SVBmNPNOYrnOr9Nk2
         1rPqyFZO3K+bzoPEEiQOfo+vg0ylABbDX3EsebC+Ma4sHUGgeXuY0luNAjdDJygH9jAB
         79BzSWAb9wYe+i4a+dB02k2FEYQtZUsuz6rMt4lxGA6a0on6lEQfWsqhmer+nxIMXjvb
         mGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yPUD4F4jhx7/mi0KaztxcsCPAij+5GRCYLwubP4M4n0=;
        b=R4x8EfaLbsGLErc3nmU2CW0W2JOf8WwVzd9vFF15OZLWbda8rpAIipmUKZ6JcJsW9P
         snCX4Nnm976NpFnbLrFCP8p0jp4604Ts5/zAAyJWviG/A8vH64CTt3PXNi/qTzRZ3uCL
         Em/voJeNw56muUWmqEKRGiIeyeeUsantLB+ghyK8e6mBgeWWiIX9F01CNU5xQY97qdSp
         GviznHSoN51of/rgwnJIVVAHHKrhdmuz3+YLqWzYqaHfUimn8GizBZ1+3wD29UqG3KTd
         0P61IjfsjEuvzaMrSUVWUz96rWYFKRJTCyRRYKdyJsDxRYChnDq8lwPvNJs9QzTm8FVP
         LPow==
X-Gm-Message-State: AGi0PuYq7Rz5fEf9gRhkA54BbNbQqDI5/6xvZOaiiuxuUJo5s+vaCeRS
        +MTwuL4fWFAY7dw4+9GbsvT4+Hvl1avu8TMKWx2RlUeeQQsY
X-Google-Smtp-Source: APiQypIslmTrvWxc6+PCXCJKisz7gnh6rZeh4pgL0sio8rcxwJXnJbctMlP9ZJsZlMHbYPzTAtusNkZ39+4s
X-Received: by 2002:a5d:474b:: with SMTP id o11mr3505217wrs.4.1585835492767;
        Thu, 02 Apr 2020 06:51:32 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id c9sm95411wrd.85.2020.04.02.06.51.32
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 02 Apr 2020 06:51:32 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.12.10] (port=55896 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jK0Fo-0001KP-Dh; Thu, 02 Apr 2020 15:51:32 +0200
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 2/4] ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on LAN.
Date:   Thu,  2 Apr 2020 15:51:28 +0200
Message-Id: <1585835490-3813-3-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585835490-3813-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1585835490-3813-1-git-send-email-martin.fuzzey@flowbird.group>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to wake from suspend by ethernet magic packets the GPC
must be used as intc does not have wakeup functionality.

But the FEC DT node currently uses interrupt-extended,
specificying intc, thus breaking WoL.

This problem is probably fallout from the stacked domain conversion
as intc used to chain to GPC.

So replace "interrupts-extended" by "interrupts" to use the default
parent which is GPC.

Fixes: b923ff6af0d5 ("ARM: imx6: convert GPC to stacked domains")

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 5 ++---
 arch/arm/boot/dts/imx6qp.dtsi  | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index e6b4b85..bc488df 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1039,9 +1039,8 @@
 				compatible = "fsl,imx6q-fec";
 				reg = <0x02188000 0x4000>;
 				interrupt-names = "int0", "pps";
-				interrupts-extended =
-					<&intc 0 118 IRQ_TYPE_LEVEL_HIGH>,
-					<&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <0 118 IRQ_TYPE_LEVEL_HIGH>,
+					     <0 119 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6QDL_CLK_ENET>,
 					 <&clks IMX6QDL_CLK_ENET>,
 					 <&clks IMX6QDL_CLK_ENET_REF>;
diff --git a/arch/arm/boot/dts/imx6qp.dtsi b/arch/arm/boot/dts/imx6qp.dtsi
index 5f51f8e..d91f92f 100644
--- a/arch/arm/boot/dts/imx6qp.dtsi
+++ b/arch/arm/boot/dts/imx6qp.dtsi
@@ -77,7 +77,6 @@
 };
 
 &fec {
-	/delete-property/interrupts-extended;
 	interrupts = <0 118 IRQ_TYPE_LEVEL_HIGH>,
 		     <0 119 IRQ_TYPE_LEVEL_HIGH>;
 };
-- 
1.9.1

