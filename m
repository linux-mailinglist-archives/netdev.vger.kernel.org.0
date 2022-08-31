Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171C15A829D
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiHaQBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 12:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiHaQBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 12:01:35 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06956AB422;
        Wed, 31 Aug 2022 09:01:32 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s11so18963334edd.13;
        Wed, 31 Aug 2022 09:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=jTX8ciu6MM6kgsSC213n8sDxvwY7rre4HofaV+9C3Tw=;
        b=D58ojdePdXla0PutIXEtK2KoSd7YzyWkO7OU9M8mpMr2HK/UyAXGrh3WQYbTUIFMoh
         LsIiOgH97zEUuxmutMd+jUZTxayGsn8e+RVk3+2yCb4hgRG/AvHFwUxcFmu5gpi8XT4E
         BrjV8SSxl7Gqc/tkd/jYOBMTIKnwfy2iwcZH9NfR35v+S9V6rIacaQQqduTFmET1HJNe
         pUWfRJ7HvWmqnmrZ2zVa5TcnPAgOAVg8V+lx6/SUpwDML4fX8mWsqD59W5SzX4m7dBgF
         FLNRNPMIs9/DZK6Tx/PJt13STT6t/xkqqyCMr6gdOXx4Lz0WqC2TptBGBJcA2n4a6+cH
         gcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=jTX8ciu6MM6kgsSC213n8sDxvwY7rre4HofaV+9C3Tw=;
        b=0OGwY5xSLKO3GppLpf2kcX6X3HEbuE+AXb1pH8NnjYDiMFkEi+/w2krzmP1EjebFFy
         If7Mg5195aOLPMQZguQ4XLtFPhx9n4XYJhjSjc++oiYJTiRl6FT4vdbfbiZC9aP9JyoI
         fLWVkZIbIFDfzWQ+G3gCNTe/s2kHTLqNMLBwX0deRw34VoNKFJ18ZzMVqHZcmzw0B1NO
         YLBVjSz3W1du8mNRvu41YDpFPq10hj2UF15UZw00RnW7yeCR/y7JzgLf+3d4w/l/VPLy
         WJfzjjkOtRXLunimPjHM/tRLLT+e4H3eBj0tRfMgAqdqh6PGsP7ncUt5e70o1NuqhVZd
         Q5ug==
X-Gm-Message-State: ACgBeo1yTbPBvKpmkFdZ2N2VXBOcxeo47KFP1QnprvHMbm9uU7eEYTMZ
        m9zaIno2Kj3txX9tMmEAVDEN1u6m7ts=
X-Google-Smtp-Source: AA6agR6q5o4JKOXL+5ezK2ZEW9QodxCl2btvVUaDRDOLyaPHsj1w2IWXS+22BDWupvAbUY7pkFH75g==
X-Received: by 2002:a05:6402:4517:b0:443:7fe1:2d60 with SMTP id ez23-20020a056402451700b004437fe12d60mr25340103edb.133.1661961690054;
        Wed, 31 Aug 2022 09:01:30 -0700 (PDT)
Received: from localhost.localdomain ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id b5-20020a17090630c500b0073dde7c1767sm7277537ejb.175.2022.08.31.09.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:01:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 devicetree 1/3] arm64: dts: ls1028a: move DSA CPU port property to the common SoC dtsi
Date:   Wed, 31 Aug 2022 19:01:22 +0300
Message-Id: <20220831160124.914453-2-olteanv@gmail.com>
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

Since the CPU port 4 of the switch is hardwired inside the SoC to go to
the enetc port 2, this shouldn't be something that the board files need
to set (but whether that CPU port is used or not is another discussion).

So move the DSA "ethernet" property to the common dtsi.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Michael Walle <michael@walle.cc>
---
v1->v2: keep 'status' property last

 .../boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts     | 1 -
 arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts  | 1 -
 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts                | 1 -
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                   | 1 +
 4 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
index 6b575efd84a7..52ef2e8e5492 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
@@ -104,7 +104,6 @@ &mscc_felix_port3 {
 };
 
 &mscc_felix_port4 {
-	ethernet = <&enetc_port2>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
index 330e34f933a3..37c20cb6c152 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
@@ -60,6 +60,5 @@ &mscc_felix_port1 {
 };
 
 &mscc_felix_port4 {
-	ethernet = <&enetc_port2>;
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
index e0cd1516d05b..7285bdcf2302 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
@@ -278,7 +278,6 @@ &mscc_felix_port3 {
 };
 
 &mscc_felix_port4 {
-	ethernet = <&enetc_port2>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 5627dd7734f3..1215fcdf70fa 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -1156,6 +1156,7 @@ mscc_felix_port3: port@3 {
 					mscc_felix_port4: port@4 {
 						reg = <4>;
 						phy-mode = "internal";
+						ethernet = <&enetc_port2>;
 						status = "disabled";
 
 						fixed-link {
-- 
2.34.1

