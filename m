Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA6C2AFE19
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgKLFdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbgKLEwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:52:39 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CA3C061A47;
        Wed, 11 Nov 2020 20:51:20 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id e7so3339207pfn.12;
        Wed, 11 Nov 2020 20:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T3/kL7oMKroeT3AsOag4R3GIK68Z5RZDB54MdR/Hx5o=;
        b=nXGX6aZ2H3A0vkY/4MCaAYxJHLcYWxKipSSe0wwk/f3p6w7zUkqtHEdCwyUwds7DxA
         Bg4b+pT1ERwjRxxdBWs+x+94k7oYGpBVgVNpd3HG9Ynp2uCzxPZeMBKzu3ymnVYBwGB2
         y+jPHH6P3ctazgeVb34vp8uSg8VgX4sxWb9TmtSDfPybFekp8yRRT2ggCAhwBb7d1wIv
         JoipcRWdNVADFFrs5YnY6GZDjRQd7o/xP5/Gprd4kzlgK9BlLuWwuybHRZmPaA0gslih
         VpLgij0FzPyNcxwPwemS4eHg+ucE//Tpag4vR0qITQ+sB1j8EjmnD6AGTMGEEqnwC3K3
         YFnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T3/kL7oMKroeT3AsOag4R3GIK68Z5RZDB54MdR/Hx5o=;
        b=ozUq5pBXDX/eHy9fT1DyYyEEKlmr2YYY/xMWvNaYCWfDjSS76I+7X4g5wb78rpYu8a
         P800j+4U/NQLV7BdhY6ydfs2nGIq5KU9Rs7gaLku9A4euOGo2u5eJbAoTXrAlVe99+NB
         09QbSNsZyN0eS63iQw1KbPYE1XOvbUrBiWY6IVyLUvaEcBSPKCsWYtRcOLj+TNAQKAkn
         xufV9PccFvr4QQeE7ToRkBg5x9+pw/qLcxpIRJQehi2cVgWsbbid7QVwvelsxhXpzTIO
         cISRrtixm2RalHJ12uWHNd5kgoGMpugjhpHFFHV4f1sH3DRn7epwHjyX6Ca6P0DkNNUj
         NyBQ==
X-Gm-Message-State: AOAM530RLLZhQWZdrm2YS2IoBIc9cJoPjTuBKizk811/BvwCs0YEYQAf
        jo5bTUTKYSIMUyy3EFTUAbA=
X-Google-Smtp-Source: ABdhPJyNlYOln9ETXIA+oKkkJBpwQufACH4dk+Beb6xKVcvdhZzm+D4a5JCoysea2oDhZrnwarJNWw==
X-Received: by 2002:a17:90a:4d47:: with SMTP id l7mr7443073pjh.121.1605156679886;
        Wed, 11 Nov 2020 20:51:19 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:51:19 -0800 (PST)
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
Subject: [PATCH v2 06/10] ARM: dts: NSP: Update ethernet switch node name
Date:   Wed, 11 Nov 2020 20:50:16 -0800
Message-Id: <20201112045020.9766-7-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112045020.9766-1-f.fainelli@gmail.com>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the switch unit name from srab to ethernet-switch, allowing us
to fix warnings such as:

     CHECK   arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml
    arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml:
    srab@18007000: $nodename:0: 'srab@18007000' does not match
    '^(ethernet-)?switch(@.*)?$'
            From schema:
    Documentation/devicetree/bindings/net/dsa/b53.yaml

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index e895f7cb8c9f..e7d08959d5fe 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -385,7 +385,7 @@ ccbtimer1: timer@35000 {
 			clock-names = "apb_pclk";
 		};
 
-		srab: srab@36000 {
+		srab: ethernet-switch@36000 {
 			compatible = "brcm,nsp-srab";
 			reg = <0x36000 0x1000>,
 			      <0x3f308 0x8>,
-- 
2.25.1

