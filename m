Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F81D2ACBC3
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731865AbgKJDbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731671AbgKJDbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:41 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2FAC0613D4;
        Mon,  9 Nov 2020 19:31:41 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id e21so8948160pgr.11;
        Mon, 09 Nov 2020 19:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3pKhL02+7n5uS3Xi9y221tTNlJLYEMC8oigF8OT66lc=;
        b=XcXKpUE6xZEQbh+93SRuQd5o8bVaij90B0yXhiimDMhwWLUd/1SyLRJo61qY/xCLoi
         +ljhOT4ZQoiPrwlbVdX+1yGBfL3Zm3yyYcp06wxXHI+foIZVT/eXzfFn0mnjrDcaElR9
         QzlSjdeo4ehd/OxWSzzl3x6RPmO9FAZA+Qb7acfoKifPOlHFn7EW+9smHMK81c01WxQv
         LDvqzWtjAHMhN4sl/VEg4LRNdu4mmqIPVG5dvVf9GEKfbxIDn8kiMFCLw3zgbCvylFVy
         88ODxS+SEHdC5FHzlOfqujH9vUai5pPtcKXXJ23fwfHt9rp43W3q/n1VfYogtuZB/kYF
         JVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3pKhL02+7n5uS3Xi9y221tTNlJLYEMC8oigF8OT66lc=;
        b=IstI7dXcLN7FJdbBnNTqhNeyynskWnLhK6HXsdZU6zJ3lrvDSxC1Zxrp1VF5hQJmDt
         ZY3l65QDoA1Zr4RryZejIjW3LK8CrkdG0TXi+rkmSDCC+pFgRJp+RwTrazRycBlJaUXJ
         tEhhao0CufiH6BstHmzS6IHz280jczKVgKGtp9las5BOI6ewf8ra0fxeQfqWAs5mUbdN
         qDl/jnulSyYGX1rOkfKQqGuxnvu6zdztIEaIgQZexHNaX3Uhg0EDyK/Jc+wSAgMTzIQN
         tZKWOQU4OGuD9g6hNPpE/geDuy5UIQATUjWxgHjCvA1rFdkvmBGLXhBXGUMq2VBIlD+G
         D+rA==
X-Gm-Message-State: AOAM530IdxtqmTmJnWJDDz2QMKYS5F0kuQuD6WJJ3N+3+jcTE196f/2u
        5jnkOmR8FO82UyXZArs+Ia1prSrkNTs=
X-Google-Smtp-Source: ABdhPJzGL+D9yovIwcIWwDoDYGKxmsFX8+Jfp0jWEsh95kKkegHYJpOu1a8iHzBX/D9fA8RKCMHeBA==
X-Received: by 2002:a17:90b:3d5:: with SMTP id go21mr2691320pjb.8.1604979100837;
        Mon, 09 Nov 2020 19:31:40 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:40 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE), Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH 09/10] ARM: dts: NSP: Provide defaults ports container node
Date:   Mon,  9 Nov 2020 19:31:12 -0800
Message-Id: <20201110033113.31090-10-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110033113.31090-1-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide an empty 'ports' container node with the correct #address-cells
and #size-cells properties. This silences the following warning:

arch/arm/boot/dts/bcm958522er.dt.yaml:
ethernet-switch@36000: 'oneOf' conditional failed, one must be fixed:
            'ports' is a required property
            'ethernet-ports' is a required property
            From schema:
Documentation/devicetree/bindings/net/dsa/b53.yaml

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm-nsp.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index 8453865d1439..d75bf37260c2 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -420,6 +420,10 @@ srab: ethernet-switch@36000 {
 			status = "disabled";
 
 			/* ports are defined in board DTS */
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
 		};
 
 		i2c0: i2c@38000 {
-- 
2.25.1

