Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548802AFE16
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgKLFdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbgKLEu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:50:58 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88C3C0613D1;
        Wed, 11 Nov 2020 20:50:57 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id a18so3376800pfl.3;
        Wed, 11 Nov 2020 20:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lNe2OsEAdcO54CudgPlRLNwKxuVOX4BLgvqgD3FGrlw=;
        b=LBwbDZF/j88lLsPr+bH6Hk3PG7vPOwPy89UCbh+pPjAtZrd8COpf/GvKdX106kWV67
         mSXxnegT6oJzGVXoYIsU77b0YlkRZHADJgTPGE1o5PjepZ5Jo7oMR6zl4vrr9qczNZkv
         xjpZnhp862vx3gWgbbL2jGdmDtFl0spAYj7OS4CLltph8gR+4Do4dGFNsqm6oeywKQ9C
         nrA9LaYs4HdvnFwQYtnLa4gHH5s+x/42M8Z1ahAj1ozeAy9dW/u9j1lbkrpDIxQdHYjr
         9gn2OImGn5vItpXJOVLz1zuTjrAvckbGsHy2Ffu9JGh3Y+uCaVZ42jOrFU8wRc+PuYvb
         uTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lNe2OsEAdcO54CudgPlRLNwKxuVOX4BLgvqgD3FGrlw=;
        b=ozL07EzxEoQL3f6xJAS16OvnJNUsuNrrOWq3vMEBnX2LRyUCAkN9ouUzjozBWI9x+x
         0plcG5IFu+y7WuhYmpIkCUrIliye2UWM84FxVoVdm6H8r1Mu8k5S7Km6i26UdOn13uIL
         Thcyqmtl6libk9B3yaShEceS9LL/S1qs7ke0rp5MDMGtjcAeVaNTEXwllkf3Iorj+4xJ
         urcByMB6+nl1UDLhUAnlvDVz9uYgDmuNB4fjArh25xkf5uo4ykXwKDBQlVVKlOR6s58x
         0FMWGsrrsURAGjexm79OYwlirjfKslrUA15jdJRgW7PmXR9Cu47XZAmPixBOdixzke0O
         998A==
X-Gm-Message-State: AOAM5321+GGZO0xIpAH8HDzlRDdHvKrqAXvoyzM6OZkRFiex3fIvkFp6
        UiRD7GZ/xhYl1nhmGcDZ5m2Yy1rA+9Y=
X-Google-Smtp-Source: ABdhPJzRDF53Kv3RDnzhuyq0gQ6T408KCLdt542T7X1UjDo9vGKaPYds3Ls1LskXgcG7Q5D5M2Xxqw==
X-Received: by 2002:a17:90a:ae17:: with SMTP id t23mr7630529pjq.51.1605156657441;
        Wed, 11 Nov 2020 20:50:57 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:50:56 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH v2 03/10] ARM: dts: BCM5301X: Update Ethernet switch node name
Date:   Wed, 11 Nov 2020 20:50:13 -0800
Message-Id: <20201112045020.9766-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112045020.9766-1-f.fainelli@gmail.com>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the switch unit name from srab to ethernet-switch, allowing us to
fix warnings such as:

  CHECK   arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml
arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml:
srab@18007000: $nodename:0: 'srab@18007000' does not match
'^(ethernet-)?switch(@.*)?$'
        From schema:
Documentation/devicetree/bindings/net/dsa/b53.yaml

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index 90c09c48721b..b8d2e8d28482 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -483,7 +483,7 @@ thermal: thermal@2c0 {
 		};
 	};
 
-	srab: srab@18007000 {
+	srab: ethernet-switch@18007000 {
 		compatible = "brcm,bcm5301x-srab";
 		reg = <0x18007000 0x1000>;
 
-- 
2.25.1

