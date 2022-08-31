Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F545A829B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiHaQBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 12:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiHaQBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 12:01:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A38AE9CA;
        Wed, 31 Aug 2022 09:01:36 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id a36so15187505edf.5;
        Wed, 31 Aug 2022 09:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=EmNOHW8dOBfji1wkjcTQmmq1Mj0tjVV6eLhD3GgRB/g=;
        b=iPzGBtmsyIlRowO01qTXhasG0NLWdlzZwl/O3IlBP3urBRqmLeHlHQUduHBqbN8eaz
         IFCcNdL5ccd6/YBh5OykW9i1vXKvhwh2kSqjAzExcad5bYMzLp8Dq6apPeHQmj+WAAPg
         uZc1knE24OFoP2zfsEiWGxdV4qKioFaCqC/UI2OXh3xhW3xyTtqbIfrMiFcdL05NI24n
         x+oD4RwT5biLqIx8PQh/w+/Z9DwWZOh3Pm2gDg6dXcdOdt9oDruOcVBYvyYXQvsvIHMt
         Z10YmakIfVehoTPiJBvbK97UwOFjbkEop6dTgWUx7kso/mwhsESEG+8PcWEWrVMlu+f6
         p0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=EmNOHW8dOBfji1wkjcTQmmq1Mj0tjVV6eLhD3GgRB/g=;
        b=CSHwQ50HvjlAXH3UqEOzSNel3aJstofxqZ4TFT2Kr9oYdTVijvX70d+qJGJVJOsn3U
         KuwjW01fsM3Av9mXKE1mDVAdFbqljhQsQwyZHF/WgzYr2XBU15USY5h/pBlRczINr4wr
         wjM8fS/Pc4TUKfO7F0FW9EN94wMVKcTPpcwTB4FWrDQc7A8Fx9mvmXsiPB70VNUNmgKG
         T6FMnbmj7J80W1pbmuRuZrvQgpyb1ruYFBQ7HxrGudqGrGI+LE1qlvAz+4zKvrz25BK4
         F/xNTbhIZyao5qp4ozJ6Pw+8cPruGMgMXD7A2Hii+mSKem2BNbYCSPfrkWJJvPczoJzG
         slgg==
X-Gm-Message-State: ACgBeo0rsRV+dEFyPHjjm0MIQRZ+oSRl5Jt3vfbWvAgkeCHnMr3P9tfC
        AkcS95h3y8P+2wNoN2pR0VafOmpKTic=
X-Google-Smtp-Source: AA6agR7/mG+nWnFFyl//A8+WrZ8yAr1i9FETVTqXy2AMVt9YUhAeyE8y0SOWAJQjm5QcsfsWpYrtlw==
X-Received: by 2002:aa7:c3c2:0:b0:447:7d68:7187 with SMTP id l2-20020aa7c3c2000000b004477d687187mr24775177edr.400.1661961694515;
        Wed, 31 Aug 2022 09:01:34 -0700 (PDT)
Received: from localhost.localdomain ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id b5-20020a17090630c500b0073dde7c1767sm7277537ejb.175.2022.08.31.09.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:01:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 devicetree 3/3] arm64: dts: ls1028a: enable swp5 and eno3 for all boards
Date:   Wed, 31 Aug 2022 19:01:24 +0300
Message-Id: <20220831160124.914453-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831160124.914453-1-olteanv@gmail.com>
References: <20220831160124.914453-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In order for the LS1028A based boards to benefit from support for
multiple CPU ports, the second DSA master and its associated CPU port
must be enabled in the device trees. This does not change the default
CPU port from the current port 4.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Michael Walle <michael@walle.cc>
---
v1->v2: none

 .../dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts   | 8 ++++++++
 .../boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts  | 8 ++++++++
 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts         | 8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
index 52ef2e8e5492..73eb6061c73e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
@@ -59,6 +59,10 @@ &enetc_port2 {
 	status = "okay";
 };
 
+&enetc_port3 {
+	status = "okay";
+};
+
 &i2c3 {
 	eeprom@57 {
 		compatible = "atmel,24c32";
@@ -107,6 +111,10 @@ &mscc_felix_port4 {
 	status = "okay";
 };
 
+&mscc_felix_port5 {
+	status = "okay";
+};
+
 &sata {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
index 37c20cb6c152..113b1df74bf8 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
@@ -39,6 +39,10 @@ &enetc_port2 {
 	status = "okay";
 };
 
+&enetc_port3 {
+	status = "okay";
+};
+
 &mscc_felix {
 	status = "okay";
 };
@@ -62,3 +66,7 @@ &mscc_felix_port1 {
 &mscc_felix_port4 {
 	status = "okay";
 };
+
+&mscc_felix_port5 {
+	status = "okay";
+};
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
index 7285bdcf2302..e33725c60169 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
@@ -151,6 +151,10 @@ &enetc_port2 {
 	status = "okay";
 };
 
+&enetc_port3 {
+	status = "okay";
+};
+
 &esdhc {
 	sd-uhs-sdr104;
 	sd-uhs-sdr50;
@@ -281,6 +285,10 @@ &mscc_felix_port4 {
 	status = "okay";
 };
 
+&mscc_felix_port5 {
+	status = "okay";
+};
+
 &optee {
 	status = "okay";
 };
-- 
2.34.1

