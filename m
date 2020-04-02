Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A0A19C31E
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732875AbgDBNvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:51:42 -0400
Received: from mail-wm1-f97.google.com ([209.85.128.97]:50377 "EHLO
        mail-wm1-f97.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732697AbgDBNvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:51:35 -0400
Received: by mail-wm1-f97.google.com with SMTP id t128so3497472wma.0
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 06:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q3/W4bkJow86eplxYpKXS4NSE8Ye38WZL3vKGQGBJgI=;
        b=CAgKFKEHAoJsPaHDGmKaVIsRzh82piqq/7ouZPBb26H41t0KcqrPl2CICqjvLn/oLR
         jwaUYBzSX8NjGY2u/5QlvbWQONSYK1E90JjoDrPIPmxu26pNsbuXHNYJYrK3EUDMOLjH
         vwx9lI2VZlRy0yBWHzunEo5f9pk3f1WjKZpduZyXDGmLH93THxl0W7rIrXnE4G7VHPYg
         2rG8RsezEpEBYzUrQj7chgzvhwf2LiFj1Xr6611qCqzQPN9Vg3KT3unOqNNGAQrlP2oC
         H8YVIE8UICAksrlv9Q3WZx0C/mRpup0S5UYxPQKrapnVMynBRE3SQDPvmY12EA+igm3k
         olQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q3/W4bkJow86eplxYpKXS4NSE8Ye38WZL3vKGQGBJgI=;
        b=AmOKvXOZMl4VtSqcoug0moAmpZSGGcO4st94LHcdTodmVFtyzl6iHabQLlc+pPNOom
         oCMWcAXX+0OF5Jgnba/NU+6ijh3YXI/zdvZ7vRr0xlUXTRlNx9YTys6lLNxo2HkAjNPy
         7uMZ9TUAgogU0Cj2TnNDKOJ8LDUW7gS7nLF39J3VSVh5NcsrKcD0Eokt30m2kqr/ZhhW
         3i4JTjRViNjS8DQcp3A0AFkXsOUr0eA1vka0vDvX+UsPrC8OW9f7pdiEnFp2lE2tKqza
         Ux7wYGDtzX2Wn4xCcizq+oG4yMQN+CJbH8JoHujDqnOkOe82pwOUtxVstglI6Lv6VlZ/
         we1w==
X-Gm-Message-State: AGi0PuZ2lPG43OjIUqjrRtOmSA2PauuVlJM0YO9BUwK2j2c3YEjS8iN1
        qfWz1j1NNTCtswobi0Ksqff5iYu/jWV3OdOd0pNmuQzYKU+S
X-Google-Smtp-Source: APiQypJVnBj4d11a5FWxkIpNuqoTYc4VqjzLP7kWWP37P/SfWergy0HlMzAspThbw6de+5HNmxfY/MzdZTR1
X-Received: by 2002:a7b:cb8f:: with SMTP id m15mr3616367wmi.162.1585835494158;
        Thu, 02 Apr 2020 06:51:34 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id m13sm65639wml.4.2020.04.02.06.51.34
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 02 Apr 2020 06:51:34 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.12.10] (port=55896 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jK0Fp-0001KP-PX; Thu, 02 Apr 2020 15:51:33 +0200
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
Subject: [PATCH v3 4/4] ARM: dts: imx6: add fec gpr property.
Date:   Thu,  2 Apr 2020 15:51:30 +0200
Message-Id: <1585835490-3813-5-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585835490-3813-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1585835490-3813-1-git-send-email-martin.fuzzey@flowbird.group>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is required for wake on lan on i.MX6

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Reviewed-by: Fugang Duan <fugang.duan@nxp.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index bc488df..65b0c8a 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1045,6 +1045,7 @@
 					 <&clks IMX6QDL_CLK_ENET>,
 					 <&clks IMX6QDL_CLK_ENET_REF>;
 				clock-names = "ipg", "ahb", "ptp";
+				gpr = <&gpr>;
 				status = "disabled";
 			};
 
-- 
1.9.1

