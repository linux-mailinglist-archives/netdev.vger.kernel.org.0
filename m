Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B8F114A18
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 01:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfLFAEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 19:04:33 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39711 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfLFAEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 19:04:32 -0500
Received: by mail-wm1-f66.google.com with SMTP id s14so5628050wmh.4;
        Thu, 05 Dec 2019 16:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SB4mGJSmMgtRXiCcPnqkbQ0iDAYtS0GIndUtNNEVoic=;
        b=lXWvRvmoHhihEyfM5qUUTLXG5+izV2RcrtH8EoqSpDtFcqkqVHy9rT6gMd54n1Nd34
         B71gWLpjasyd3bSA36X4tplDflwp44leVD8HvDze21Ngh1JwWNDap8Ei0nGBVbD0PtQr
         +tBAduf6wnElmxxFItEEh7AUFz7b+x0A6nkqTrT8RWc9rcIGJUcSMahYPAsB+PESLWqK
         qv9CUsrK92xf+2P+3o/AmeYOhDAylDs4qPSjC2sVQp/wGUZfBN8E+pNhOIyYiAQD6oLE
         mSgbEMtBavvl1mtnAD5YzcfCdVEZs0b09qDm/xs8cMSikjX+XsXcfqU5Oo6weV+0sO3j
         imuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SB4mGJSmMgtRXiCcPnqkbQ0iDAYtS0GIndUtNNEVoic=;
        b=c2bS+D50VYHxqawDTubAf8ahhmnP/zC19hq2r4rAGpMDDmKh9fBevGcJYSYBgC9u+k
         J6m7nhUZCqsN+cyRsZwEgbprqni2zP9fDOohfLrquOUX6Wjyi11DQIUzYGcAy0s2uLT6
         uGkmRYb/Zcriz1rqqDJh+/TLIgDnIQNadaQJubkLdeP7nB5I0mYvHL5QCPTLJ+9Bzzaz
         X1OB8JR9hwXRZXTEUyw38R3TLKCjX7m6Qh5zf1gPglUG2uwT+3wQpsQh7MWudhk3W5OF
         QMuISA+L40548ArLJQLwYe0m8ICv20+xdGoi8pOnZlNbPBk6U0jZkxm5czjCXuZwNjsc
         KNiw==
X-Gm-Message-State: APjAAAWypQRt1/Cxe54pPuBbqHEvj2RDHL+QtEKh7arQOPSkWr1q0XW9
        6Lf25msxhJ8OzsSZ5fn9sF6jAHju
X-Google-Smtp-Source: APXvYqySUxIMqETb+4GU/9BLZSHkc0katccRcNlcK1X8zN/xqi6vAeqzCbP4mIxycL2w83FnlIxzRg==
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr7872343wmj.47.1575590669898;
        Thu, 05 Dec 2019 16:04:29 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm14695710wrs.18.2019.12.05.16.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 16:04:29 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@vger.kernel.org
Cc:     grygorii.strashko@ti.com, simon.horman@netronome.com,
        robh+dt@kernel.org, rafal@milecki.pl, davem@davemloft.net,
        andrew@lunn.ch, mark.rutland@arm.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] ARM: dts: BCM5301X: Fix MDIO node address/size cells
Date:   Thu,  5 Dec 2019 16:04:21 -0800
Message-Id: <20191206000421.12541-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDIO node on BCM5301X had an reversed #address-cells and
 #size-cells properties, correct those, silencing checker warnings:

.../linux/arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected

Reported-by: Simon Horman <simon.horman@netronome.com>
Fixes: 23f1eca6d59b ("ARM: dts: BCM5301X: Specify MDIO bus in the DT")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index 372dc1eb88a0..2d9b4dd05830 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -353,8 +353,8 @@
 	mdio: mdio@18003000 {
 		compatible = "brcm,iproc-mdio";
 		reg = <0x18003000 0x8>;
-		#size-cells = <1>;
-		#address-cells = <0>;
+		#size-cells = <0>;
+		#address-cells = <1>;
 	};
 
 	mdio-bus-mux@18003000 {
-- 
2.17.1

