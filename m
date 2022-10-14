Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE89E5FF57B
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 23:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiJNVdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 17:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiJNVdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 17:33:43 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700F61DDC00
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 14:33:41 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id r22so7477801ljn.10
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 14:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWIwo+mIwSXhxLgpwwdJO6e+2GcvcXvg+9gu/sbvq84=;
        b=B/DXzD8t2nEeI0lXREfvngk3fEgJ2rA4VH95A2oHmA83Gb+GG8oJmp8fzbVkvgOc5F
         SODDb8VkxgUjCzXpefDuPQNlI04n/rbcFIea088lGIZwrQ0Hnw4NV46xGIwF7ubfm7kl
         XadvfTxkjyBtKFMRdnQj/ajSRgk4OAf0o8yEPFlD1QtWOomb4Dt78blsl1QKhPOR1YRQ
         cWfZXXzCWSIcKhv0t8TZUMEix82KIszGwfORT72SqoKKREA3eE0Pt2ujCiv1ogAfmxTW
         IEup5cUYWutePHZyhI4R+W1bEFfivf9CqCKy0kk1BCooUdHZPnsKyzJbHyd0FkYvIXh7
         n54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWIwo+mIwSXhxLgpwwdJO6e+2GcvcXvg+9gu/sbvq84=;
        b=CnmQDrFyeBB5kN/22P1AIjpZxF6wHt8JCYyFRVRdviGn0SraftnZ8lC/NBBNJgivRu
         44Wn9EqpoUgrFMzB0vJBv9c7x+kTCGJICQ/866V1/F/deiefs0RVdW0HxWmkfgwl5o9L
         y3bVHVHvsQmgbccxXIGN2tYgvGxfjU5C7DdgM0iHRUkQfCxmFq6TGXJoqObp5LpCpSaY
         dxqYURMcyBToQtXyQpHxG1GSEXta6kZAYEjZ//Swd5y3WigK2sp1iMPFI4uwqv5XVX9c
         KGjlpQQEnRMTGi3cYubBw7oPISaQoD/VMHHNjVs3+4h5JlLDaA3oeK6dnmEdkz2DvUR4
         Pksg==
X-Gm-Message-State: ACrzQf2Hoq7xGC3w2FsbQMXqZD05yXOvh//JXj/vxPC1lBFdr0AS75HN
        sNGncA5lWL2/o49GRQkkkOJEjQ==
X-Google-Smtp-Source: AMsMyM74UfwDrRVI+uSJOmdihIfCn9esHqz00xZikJRiuE7l0R6ojwioZkoGBQMsMCIvcAsk4dySUg==
X-Received: by 2002:a2e:81c9:0:b0:26e:1cc:2951 with SMTP id s9-20020a2e81c9000000b0026e01cc2951mr2493966ljg.197.1665783219599;
        Fri, 14 Oct 2022 14:33:39 -0700 (PDT)
Received: from fedora.. ([78.10.207.24])
        by smtp.gmail.com with ESMTPSA id d4-20020ac24c84000000b00494978b0caesm494036lfl.276.2022.10.14.14.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:33:39 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com
Subject: [PATCH v5 2/3] arm64: dts: marvell: Update network description to match schema
Date:   Fri, 14 Oct 2022 23:32:53 +0200
Message-Id: <20221014213254.30950-3-mig@semihalf.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221014213254.30950-1-mig@semihalf.com>
References: <20221014213254.30950-1-mig@semihalf.com>
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

