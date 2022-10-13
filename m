Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026CD5FDE8B
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiJMQwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJMQwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:52:35 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252B910A7C9
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:52:32 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id d6so3371883lfs.10
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6hw2W+lQ+Hv9z48dDP42SJngsa6TM787Uybb56JTsIU=;
        b=ghoFwQTxBbVHDWGz3pu/fVVdmZGCPWS90lwX3nEcU8o2Y1zv1+S4YKeTSmNESQTc6v
         iRO5UImZPCZP7qu1ZfLC/j5rrFtvoEEBjvZgBQVPzI9DvpXQ8FkeuIVOBWkHDpc5fmP3
         1ATgRGOtOgU4JBqWGKYdqSQcOfHDgp5bnC5faThbh8oATv2pgFgKboonbacHOIbATQJH
         rH0Es23nJMcEAS+3TJgRAAUeQ8cvn5VePMhUIbrmhr5EpxIprUUWmAY9Dey+gsSVNWvn
         0E9i+lfXJe5ueJbmHYTiUe/1xqkCkFG1xyudg29Km7t5TTfV8UF0ovgJ8Nc407m2itT1
         01Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6hw2W+lQ+Hv9z48dDP42SJngsa6TM787Uybb56JTsIU=;
        b=ERHrZvJAsDd9LoeBzztqSk0dzU+GpoW+ranFHHSuEughP2pw7ICbUAO65qmyxOVs1V
         VJQA+zS4BmO1by1E5W4tf0oEj2wWG2C4GjAuJPiNxn9JzNItS/+nUXM/xnsi7L6jOm8z
         qIfMC9JvGEbZYVObGrdTWGOf4rsOLBUbfJumYg5ZjY6vvSTgAKwfEAWKgjzFSGohVCNU
         ZMGXxTmSGX5QArXc/bzZdEaYI4ghY5IkyfF13z0B9mio55XKHTjBWBUCNDZIv5Mv1MhX
         HVkexKHshKKmap1CesP2AMpwFhLlgMJlDkyNsCxr4EzjxEvgPVWiawkevvg1Wk1e6Vt5
         Cqug==
X-Gm-Message-State: ACrzQf2z7EblAdsItaQJn1LwIhMHzFBIR00GEH9VkJkssaT4JmZpC3gd
        cUZPJWdgeYBYUfvL7Fwnv8gAjw==
X-Google-Smtp-Source: AMsMyM4gcJcA8tRARkMMAurN5cSMCEOxM2sdSbaTGrQZ+dBknfKwag6sQfZLDND3tnv8+yEOEtRERQ==
X-Received: by 2002:a05:6512:33cb:b0:4a4:2bee:5c8b with SMTP id d11-20020a05651233cb00b004a42bee5c8bmr205014lfg.237.1665679950541;
        Thu, 13 Oct 2022 09:52:30 -0700 (PDT)
Received: from fedora.. ([78.10.206.53])
        by smtp.gmail.com with ESMTPSA id k7-20020a2e9207000000b00262fae1ffe6sm540752ljg.110.2022.10.13.09.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 09:52:30 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com
Subject: [PATCH v4 3/3] ARM: dts: armada-375: Update network description to match schema
Date:   Thu, 13 Oct 2022 18:51:34 +0200
Message-Id: <20221013165134.78234-4-mig@semihalf.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221013165134.78234-1-mig@semihalf.com>
References: <20221013165134.78234-1-mig@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 arch/arm/boot/dts/armada-375.dtsi | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
index 929deaf312a5..9fbe0cfec48f 100644
--- a/arch/arm/boot/dts/armada-375.dtsi
+++ b/arch/arm/boot/dts/armada-375.dtsi
@@ -178,6 +178,8 @@ mdio: mdio@c0054 {
 
 			/* Network controller */
 			ethernet: ethernet@f0000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
 				compatible = "marvell,armada-375-pp2";
 				reg = <0xf0000 0xa000>, /* Packet Processor regs */
 				      <0xc0000 0x3060>, /* LMS regs */
@@ -187,15 +189,17 @@ ethernet: ethernet@f0000 {
 				clock-names = "pp_clk", "gop_clk";
 				status = "disabled";
 
-				eth0: eth0 {
+				eth0: ethernet-port@0 {
 					interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
-					port-id = <0>;
+					reg = <0>;
+					port-id = <0>; /* For backward compatibility. */
 					status = "disabled";
 				};
 
-				eth1: eth1 {
+				eth1: ethernet-port@1 {
 					interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
-					port-id = <1>;
+					reg = <1>;
+					port-id = <1>; /* For backward compatibility. */
 					status = "disabled";
 				};
 			};
-- 
2.37.3

