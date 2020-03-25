Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1601619301A
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgCYSMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:12:05 -0400
Received: from mail-wr1-f99.google.com ([209.85.221.99]:40097 "EHLO
        mail-wr1-f99.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbgCYSMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:12:02 -0400
Received: by mail-wr1-f99.google.com with SMTP id u10so4388532wro.7
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 11:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G61Qe3eJT571EH7x7IhXUIxwlPNKKyhXnXe4ITy6VDY=;
        b=BJCpQeb64ilhKkblw6FOV5x7rvqyn9D/mptuh8QHSv4LCHx1h22tsz8VRicfOKIuy7
         35s2PDgmhbScymVqGByxQVrsHLJq/j6RIv3ZN9aU4o0WZb7B6SFqEnxXJps5QZDa976P
         813Xnt5LQ4xFA7gvgY4LSfSUV6/LS+lHY+tOwPFPM2xZp0NhZXgbyz+l3iI0cfUDGn1Q
         fZwzLwf2H3HWMhqX9GaeOm9oUOvEcbXom84OCu1QYjvKjkEEjdXMfLIZE0Rcnget399+
         imRnWfc8rguyBYzRG8WqYpl66nH71FdYg0QK2vD6lUzCa+uLIujmj9ArAoelFtMcH4jE
         N4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G61Qe3eJT571EH7x7IhXUIxwlPNKKyhXnXe4ITy6VDY=;
        b=f2/qtQU5BY3Szly2+dRJFRjQmVQN4PZqeNs655fXfoxDIwiRdrcKv6tN1WZTgjgoRV
         F27CmqQm6sHEY6oK0jG5wD63AC91V2fRAm91GD902S9Pwdi/nuSmttjBfprKPtYm6unm
         aNgHAnYfxcUaSAaSWF1CjXfuWDHr040RLVhdnF7DNRuCjbZ9WtTyddgTSJd0p+pIDK00
         LWT2Gg6uWzYxpIdptl0BpXZ+JUEaY30zbG3lb464Ulc4QFZH5sP/kfDcJsx/YX/SEJvZ
         ZMSMS4SAOjksA66DOMocbdgKIErasGTKXg/gc8SkzrKZxu0kMyt+bjBv3n7DctveE7ef
         f81w==
X-Gm-Message-State: ANhLgQ1Zv+UrLL+HJrU5CiX39eg1knd33/UoA8KbC5GI54W2yAlCFHjT
        UpzlqIuxFAycJpjRmE6G2qgg+taoC6QFJTlBbwaA13ry3LS4
X-Google-Smtp-Source: ADFU+vub5D0jlsGOnm4YpokUYEZUOEHB6GT1kQnRwz9Q/yK67pONTdN9dt97HprIfogh2eG4adM5QF2KReUu
X-Received: by 2002:a05:6000:114f:: with SMTP id d15mr4897008wrx.143.1585159919696;
        Wed, 25 Mar 2020 11:11:59 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id e16sm328483wrs.81.2020.03.25.11.11.59
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 11:11:59 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.190] (port=39524 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jHAVT-0003Oy-7a; Wed, 25 Mar 2020 19:11:59 +0100
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
Subject: [PATCH v2 2/4] ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on LAN.
Date:   Wed, 25 Mar 2020 19:11:57 +0100
Message-Id: <1585159919-11491-3-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
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
 1 file changed, 2 insertions(+), 3 deletions(-)

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
-- 
1.9.1

