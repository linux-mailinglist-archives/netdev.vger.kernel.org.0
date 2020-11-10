Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404372ACBC1
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731730AbgKJDbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731523AbgKJDbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:35 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4072C0613CF;
        Mon,  9 Nov 2020 19:31:34 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i26so8962873pgl.5;
        Mon, 09 Nov 2020 19:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oI/k1Y1vnOhInWr2aIdnVNbYXv3DIqKXXe4VrD8fpWU=;
        b=u7ufcubs6sfr24KEUDkxibiHdDDbew8aZ7MNJRoSOH7ViJm8pSHSoIzlaiBIaDob8t
         TZxyEnBskPNHZXuv9n1Rm2B6Jk8ABXfXWPgxBn7x1BnXkWBPfhQ+fHdN6E6/BRRQhbF9
         //3d9d/EnDS8xZMsbQiib+oLerwoIjnEwlYZGCcv3iKjuK7UeMWmMM95qv4hefUpsZ1T
         mEx6f0wc5LPA6IiLwx7JWLDvktujLp6t0BgGgSrgeKY0jFBU2XX0umIYGZxz8buVzLjO
         ki0p/05TRq/ROa/+3R/X7TZcD9V+YfK+MOPNBkLN+wneOhKjnuehFwQ8niVhjlCWE0lC
         evhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oI/k1Y1vnOhInWr2aIdnVNbYXv3DIqKXXe4VrD8fpWU=;
        b=gTZbIyA3Ls0HrmKT7yyrmIqk0uijIU1/zFLeF4r2j6afI01EhN7CR6LhqqUSl8EjNz
         QhPNzIkOO6bnV8oG6bugN4aeZg5K5rIIegNZNayJ0PMjOn6BHNcCnNoyikBpNjMwiREL
         mnS80FSH0XlrpdeTpmxFLmID5RPR5kJDagWAB835oYyoGUmQVqSpv88SCxiLD9X32UlQ
         9Tr4wkqhPQXLcsQ1/eFNsZhZ+Id9nj/gZkh/m2ay/LOyq1XmIAWF4OPgB4dqGOeYyPO7
         wSQ9kXkMKL8mZHtf/AoHIbGFU4rSE7ujkcfUY4vMyUz0nIyZYgYxsrfvhyTMvVgFSEUW
         JtBA==
X-Gm-Message-State: AOAM533pgITkpX72vC5yyfiDnTe4dZFp3G2V1p439Ypuvzu0o9JJaSUU
        8+Ug3bBILhke4R8xR19wuC+yjD+yvTs=
X-Google-Smtp-Source: ABdhPJxZlbYZ4H+hxRSigZhhAxvoY+m5ItazqRHNdkO4NQa1xQCl9M6tNjIFRc27QIz/aPZKLNiPHw==
X-Received: by 2002:a05:6a00:158b:b029:18b:fd84:956d with SMTP id u11-20020a056a00158bb029018bfd84956dmr8290555pfk.22.1604979094067;
        Mon, 09 Nov 2020 19:31:34 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:33 -0800 (PST)
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
Subject: [PATCH 06/10] ARM: dts: NSP: Update ethernet switch node name
Date:   Mon,  9 Nov 2020 19:31:09 -0800
Message-Id: <20201110033113.31090-7-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110033113.31090-1-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
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

