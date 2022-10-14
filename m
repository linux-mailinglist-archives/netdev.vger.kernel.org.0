Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4B95FF580
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 23:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJNVd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 17:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiJNVdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 17:33:45 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1FF1DDC23
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 14:33:42 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id o12so661209lfq.9
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 14:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6hw2W+lQ+Hv9z48dDP42SJngsa6TM787Uybb56JTsIU=;
        b=IzjtkQDeQYFdEn4qZzb1y1MhYYgveIXQ3jXngRhUccpAUTAv2U56wpVEo4vTa7Ije4
         sAupNlsKBfXuyjJMbKI1gyZDdYl00MbAfewpZYfg2yPC/+GlFo7ry7JPZ9XBuviAPHf1
         xe0mno2Y1BaXlBQLr2ksEzGoRieudyDUjsWBHUS6EQVhJP819XxvT1zMUEsrbLwdY9Pm
         7bHlbgY725Ccras+osgCcPSMdyan91I4QlxbukJFOvL1AYW0haPqlPU9w03RY+A2JMok
         5kINGb3i9YDCuFkLCexSEC3CwDQ/o5uusvv8+JOtwI17ngetxbEAF6UU53D8pBUTF4bs
         D08g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6hw2W+lQ+Hv9z48dDP42SJngsa6TM787Uybb56JTsIU=;
        b=MDFkw8Xzk30E7Pig0q+EVkcdrlTo8hUCDA7AC00R3Lhil8XavZutWsadZXDh3Uvn+f
         cSB5Oh1fwy1kqWuKIyANV50nkQduT3/NiMUZGUOFjqYTNsbyHWE0+Zhcwl0ghLNLcA0H
         iSIj+3VAWsi0akgz7LvuvjDKSIeKRb+i384cmlSaIRFzVMm52J8oraXAiv1DvAQRu9mT
         XnJR65DpR0qdknrwEd/MgqOj8C0Dxc2G9SiwcOWtkhfuzsuXlewxYbXyEvf4iQ41wlhX
         +/gMHcHfAuSLdCY/VhFTypb2qxv5bhPQNFtCQUimEIxaNZmzX8ur4kJbcpLf1WR4qBTD
         y7zg==
X-Gm-Message-State: ACrzQf2iZN+w8nfe/5N/nYJgveWekwTpOeLgCU96w1h4mLhvPJdvBRtj
        09KOR053/Mjq3VN8UeNvtfECXA==
X-Google-Smtp-Source: AMsMyM5e+mqse7jgqB+fvyHTHDmwUvq7Ma4QJCvAULxUDpj58pm7P4FgR2I8cnXSkGuc5SX2RoitPA==
X-Received: by 2002:ac2:44cd:0:b0:4a2:3fcd:c960 with SMTP id d13-20020ac244cd000000b004a23fcdc960mr2482364lfm.590.1665783220846;
        Fri, 14 Oct 2022 14:33:40 -0700 (PDT)
Received: from fedora.. ([78.10.207.24])
        by smtp.gmail.com with ESMTPSA id d4-20020ac24c84000000b00494978b0caesm494036lfl.276.2022.10.14.14.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:33:40 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com
Subject: [PATCH v5 3/3] ARM: dts: armada-375: Update network description to match schema
Date:   Fri, 14 Oct 2022 23:32:54 +0200
Message-Id: <20221014213254.30950-4-mig@semihalf.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221014213254.30950-1-mig@semihalf.com>
References: <20221014213254.30950-1-mig@semihalf.com>
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

