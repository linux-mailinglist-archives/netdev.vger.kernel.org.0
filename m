Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499A15FDE89
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJMQwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiJMQwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:52:35 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E62310A7D5
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:52:31 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id r22so3043950ljn.10
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWIwo+mIwSXhxLgpwwdJO6e+2GcvcXvg+9gu/sbvq84=;
        b=Xi5DZ5qK+qk1qquLLkpXhdYUNmdfgyLafBxDhrB9rpscC/EIrl+UVUQguUo0PzTfq5
         8K9wmjiGS3GJvD8GrzFFMXpqMchc/FBU7Jaz1btWIhp/ZB54mbEal084Svq3VEEF3UXF
         WUcXAqfju0Af83SfunDSrm2pXxwj4YqGvARML/gBSRq4TntIOyjk51zX14Kym9RRyVD5
         pDqgpGuLwl99Q0pHv+D8QIWvxCtZhnYiWlwN44KdXBACx6nb+jh5+4CHmMcwd66xW5Uj
         UPXDX0PefoIkPA98z6cxVXiQOPv9LESdB1DVb4Eeab6Us2nrXxi11nlmqM+TkysLl6De
         qwLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWIwo+mIwSXhxLgpwwdJO6e+2GcvcXvg+9gu/sbvq84=;
        b=sIOfRAc7ygk73IVqvhUMZBSbRCuUlZh7TezOMP+vVrwS5743utr3URIuyvFUfnxnw2
         XcOWC/153J+kQjuCcVuWLGkw+7mVCoo2sLKACa8SWOG98/BLQ67gs4HG976O68NSGEl/
         tJ2LntFwCyEIDiE+fRccQAQp4q+bX5FQF6muPiv2pQKNG9hrblZHiDV0VSwiiv8dDqBx
         HUQ7JVkRm8m+Tb+5LM5gUmuiECY9JNFG5uMXf74VSHtNb6ZgLeZ8owgDViZ74W6WOh0E
         IGrCCiasULoOWZu5Mnhw1Z1fQNmNybQQ/3f/p6sMl3ja0rL4BEeS34AEI3S1le8L13ON
         69lQ==
X-Gm-Message-State: ACrzQf39qQRUbxIxB0k7NVnnK+CDvs+avBxRtkY+/M744RyUqHwsBbXT
        BpPE9qGLfWavUeo5OVZ3QOvNag==
X-Google-Smtp-Source: AMsMyM63g/W8O1g5lvdBVlFYJvInzSl0E+zJLeXuYwVpee2XRfgYaxeUhNgdwVvtEu+yzg0nEPLNJg==
X-Received: by 2002:a05:651c:1685:b0:26e:e61:9c3f with SMTP id bd5-20020a05651c168500b0026e0e619c3fmr290114ljb.477.1665679949349;
        Thu, 13 Oct 2022 09:52:29 -0700 (PDT)
Received: from fedora.. ([78.10.206.53])
        by smtp.gmail.com with ESMTPSA id k7-20020a2e9207000000b00262fae1ffe6sm540752ljg.110.2022.10.13.09.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 09:52:29 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com
Subject: [PATCH v4 2/3] arm64: dts: marvell: Update network description to match schema
Date:   Thu, 13 Oct 2022 18:51:33 +0200
Message-Id: <20221013165134.78234-3-mig@semihalf.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221013165134.78234-1-mig@semihalf.com>
References: <20221013165134.78234-1-mig@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Wojtas <mw@semihalf.com>

Update the PP2 ethernet ports subnodes' names to match
schema enforced by the marvell,pp2.yaml contents.

Add new required properties ('reg') which contains information
about the port ID, keeping 'port-id' ones for backward
compatibility.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
index d6c0990a267d..7d0043824f2a 100644
--- a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
@@ -58,6 +58,8 @@ config-space@CP11X_BASE {
 		ranges = <0x0 0x0 ADDRESSIFY(CP11X_BASE) 0x2000000>;
 
 		CP11X_LABEL(ethernet): ethernet@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
 			compatible = "marvell,armada-7k-pp22";
 			reg = <0x0 0x100000>, <0x129000 0xb000>, <0x220000 0x800>;
 			clocks = <&CP11X_LABEL(clk) 1 3>, <&CP11X_LABEL(clk) 1 9>,
@@ -69,7 +71,7 @@ CP11X_LABEL(ethernet): ethernet@0 {
 			status = "disabled";
 			dma-coherent;
 
-			CP11X_LABEL(eth0): eth0 {
+			CP11X_LABEL(eth0): ethernet-port@0 {
 				interrupts = <39 IRQ_TYPE_LEVEL_HIGH>,
 					<43 IRQ_TYPE_LEVEL_HIGH>,
 					<47 IRQ_TYPE_LEVEL_HIGH>,
@@ -83,12 +85,13 @@ CP11X_LABEL(eth0): eth0 {
 				interrupt-names = "hif0", "hif1", "hif2",
 					"hif3", "hif4", "hif5", "hif6", "hif7",
 					"hif8", "link";
-				port-id = <0>;
+				reg = <0>;
+				port-id = <0>; /* For backward compatibility. */
 				gop-port-id = <0>;
 				status = "disabled";
 			};
 
-			CP11X_LABEL(eth1): eth1 {
+			CP11X_LABEL(eth1): ethernet-port@1 {
 				interrupts = <40 IRQ_TYPE_LEVEL_HIGH>,
 					<44 IRQ_TYPE_LEVEL_HIGH>,
 					<48 IRQ_TYPE_LEVEL_HIGH>,
@@ -102,12 +105,13 @@ CP11X_LABEL(eth1): eth1 {
 				interrupt-names = "hif0", "hif1", "hif2",
 					"hif3", "hif4", "hif5", "hif6", "hif7",
 					"hif8", "link";
-				port-id = <1>;
+				reg = <1>;
+				port-id = <1>; /* For backward compatibility. */
 				gop-port-id = <2>;
 				status = "disabled";
 			};
 
-			CP11X_LABEL(eth2): eth2 {
+			CP11X_LABEL(eth2): ethernet-port@2 {
 				interrupts = <41 IRQ_TYPE_LEVEL_HIGH>,
 					<45 IRQ_TYPE_LEVEL_HIGH>,
 					<49 IRQ_TYPE_LEVEL_HIGH>,
@@ -121,7 +125,8 @@ CP11X_LABEL(eth2): eth2 {
 				interrupt-names = "hif0", "hif1", "hif2",
 					"hif3", "hif4", "hif5", "hif6", "hif7",
 					"hif8", "link";
-				port-id = <2>;
+				reg = <2>;
+				port-id = <2>; /* For backward compatibility. */
 				gop-port-id = <3>;
 				status = "disabled";
 			};
-- 
2.37.3

