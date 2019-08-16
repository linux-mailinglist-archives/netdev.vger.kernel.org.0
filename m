Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961C68F819
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfHPApX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38594 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfHPApN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so3804639wrr.5;
        Thu, 15 Aug 2019 17:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O+BuAp2dc2x7NLQjist46bsjVgghdM8S/nB8+111tp8=;
        b=orqK9eRGSdYPsVvLabVo5OK7nr7294MjupOxhKPTGmhDM8jiTw9HRcaHUgGn8m0p4r
         ULL3ZT77hpNGGwN1c3F04XZXiQOYZQiaPZEsSPYGUt4lTFltsCfNF/5Bm+xAQiOnlMCW
         +oqmP31rAf6EDdCiJMv+WqeLTnFnIHzQjZgNwTi9dGFs+IPSg/iuqsmp8OA1Fz0O+jB0
         dc2BaVTQN0XbdT0XnIW9L7CuHijfYHKTjOaQWwXdQsL6jmNz9QEbo09Kz0frYoelDTRa
         1avuM10GK1su7G989SYVYfK4CFH3om2SDKTG2JzeHwaYj6HuXtg6UjlasfY4Wk95y0h5
         m7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O+BuAp2dc2x7NLQjist46bsjVgghdM8S/nB8+111tp8=;
        b=J0ymOJNNKit7a1DS9JAe2vm8nvF3JEvr7URxD6D90oc7LTHfzHLcJoYjEzdacB7gwm
         10K7qOpMV9/q5hb5h+CHsI9ONK0I7Ne7DHz9D3sbxK2rm9ASz1v5cmZvbFZqkQUcYoGK
         Jf0PbHFpcAIkrwEDgu522Ay++6hVaHt5U4zq1aK4IP3l9xg0/prpCJ2/4tvany8cQSHA
         Ege/ZoZPwjHj/jQXX7I8SLlh4y6RnZBnlFrjZLpG84Psbxkt4VcKcYw5K7FCYKIyuIHM
         C8Vu3p2fkS9HlOGFy3tlTM1dAJcOY0QpcPuFZ6ZSXAwgiOppg3PNWzPmoa+lEq+2UhTo
         daWQ==
X-Gm-Message-State: APjAAAUV7tbIcG+rW+ddeq/WLTzIrPGynFCKTG91R4n6igYEGigzJ1mO
        FBHrUCq6iE7/s8Ei5ji4Mv5Y8X0Kvuc=
X-Google-Smtp-Source: APXvYqwqyl0zg5KFH2x/77QCr3jJXEclNRTyNbovRIK79aCgSHzmxNxMkXBC06C/sHwYAEqbPVmZFA==
X-Received: by 2002:a5d:628d:: with SMTP id k13mr7726849wru.69.1565916311452;
        Thu, 15 Aug 2019 17:45:11 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 09/11] ARM: dts: ls1021a-tsn: Add debugging GPIOs for the SJA1105 and DSPI drivers
Date:   Fri, 16 Aug 2019 03:44:47 +0300
Message-Id: <20190816004449.10100-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These GPIOs are exported to the expansion pin header at the rear of the
board:

EXP1_GPIO7: row 1, pin 9 from left
EXP1_GPIO6: row 1, pin 8 from left

Experimentally I could only see EXP1_GPIO6 (the pin currently assigned
to the DSPI driver) actually toggle on an analyzer - I don't know why,
but on my board, EXP1_GPIO7 isn't.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 9d4eee986f53..6cec454c484c 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -5,6 +5,7 @@
 
 /dts-v1/;
 #include "ls1021a.dtsi"
+#include <dt-bindings/gpio/gpio.h>
 
 / {
 	model = "NXP LS1021A-TSN Board";
@@ -34,6 +35,8 @@
 
 &dspi0 {
 	bus-num = <0>;
+	/* EXP1_GPIO6 is GPIO4_18 */
+	debug-gpios = <&gpio3 18 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 
 	/* ADG704BRMZ 1:4 SPI mux/demux */
@@ -57,6 +60,8 @@
 		/* SPI controller settings for SJA1105 timing requirements */
 		fsl,spi-cs-sck-delay = <1000>;
 		fsl,spi-sck-cs-delay = <1000>;
+		/* EXP1_GPIO7 is GPIO4_19 */
+		debug-gpios = <&gpio3 19 GPIO_ACTIVE_HIGH>;
 
 		ports {
 			#address-cells = <1>;
-- 
2.17.1

