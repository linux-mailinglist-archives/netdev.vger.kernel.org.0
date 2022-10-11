Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3915FBB19
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 21:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiJKTHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 15:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiJKTHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 15:07:02 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9C953025
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 12:07:00 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id h8so6020971lja.11
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 12:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVRoSf4qECz/Xi1SOY8LYcpaa/slnJd7EiRkPtLaIq0=;
        b=eIKjYgCr0Zpa6L0ni1vjzPLF5JAlRa6sHuSTKj1SpRMWunTpzp2CoVzMmH638NlXvC
         TfXlZML6Ao/afPfv0vxtzf7j1mYzRCUV7S0EuZPxGWE+ButN1gC3OGGoYKyXhtB2BQoN
         t8Vt9Qg3mf0jn6jSWOBaUJfqFpUicPZ+KdbUJsq6jrvWtQITyH4HWQCpvhtgh3sgyad6
         DAhSuoTl9fVrjMoXCNeLu/WPm2hceaSIn5guKDGj76jefFHa8qnJa5g6rCRiKMch28Wy
         lIgBxP6wukUbfZZ2LKbUOr5RxSQtftMMfAfObWRRSKT6QVWR6BUkoq92icMgJr76Xrps
         megg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iVRoSf4qECz/Xi1SOY8LYcpaa/slnJd7EiRkPtLaIq0=;
        b=f+YGw5vGJTdAaiOxYQMxt/eDdo3BPyzarthYmtGCPUpA1C2BdpHhOevH66CQWS/OKT
         qB4NK2ImHJigkTg346GXIgknL6WJ8u1YUCjD35Oo/nxH/vWTBG2f+LsPrKmDP91zeYMd
         rTKoywMUW1FFAb/ZFWDqvoEf3v5uHfUhTbAJEuTCrs462PEEIG4bjrxGyr6P8qp0KAEx
         6V1J3egtINz2JMd3NnKpilEJRC6IkhqDBq2SjGp/SBUH9thL2VEfL4CpIYFbDpblixoM
         hPjIv7UDkcJcpIa6XVjS0Q+voH7kNhZ+gajP9LY3jFI81mMeKHuOh33LRxN4+BnzxwsZ
         6doQ==
X-Gm-Message-State: ACrzQf2v8LJW/qOUOEhuuN9sWgKFihnPa6sCIsjg9eaEIvbnwME9elbI
        wmetwJplIbCrsKtPIH9i01wo2g==
X-Google-Smtp-Source: AMsMyM5CNa1Fo1IaBiexqlLkh/HY1sFt21p6qhXic7mm47qLIcIyNHc6POjl+UaQIsj/Jj2PLFZAnA==
X-Received: by 2002:a2e:bc24:0:b0:26f:a6f1:e8ca with SMTP id b36-20020a2ebc24000000b0026fa6f1e8camr4912567ljf.249.1665515218240;
        Tue, 11 Oct 2022 12:06:58 -0700 (PDT)
Received: from michal-H370M-DS3H.office.semihalf.net ([83.142.187.84])
        by smtp.googlemail.com with ESMTPSA id p9-20020a2eb7c9000000b00262fae1ffe6sm2270477ljo.110.2022.10.11.12.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:06:57 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com
Subject: [PATCH v3 2/3] arm64: dts: marvell: Update network description to match schema
Date:   Tue, 11 Oct 2022 21:06:12 +0200
Message-Id: <20221011190613.13008-3-mig@semihalf.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221011190613.13008-1-mig@semihalf.com>
References: <20221011190613.13008-1-mig@semihalf.com>
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
2.25.1

