Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C7C362BFC
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhDPXoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbhDPXoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 19:44:04 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEED7C061756;
        Fri, 16 Apr 2021 16:43:39 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p67so14398970pfp.10;
        Fri, 16 Apr 2021 16:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CrPBf14mwxSLO7aRnBxhd9zm0h5+2vyayHpyoWlJYoM=;
        b=tfQWYShiFK0cgSJUnF/Ftg0f0QwaGKzXdWDDp2E0AulQH0UFs047T5hjMcNa2jIJBA
         ciQFxXFrocw0Nfd9bZTJfJIuqqinTiqKm3rq+J3Kx7HhiVTsR/UqoFxEe7etVrAGk02U
         2K7O2XRGqfHnoZGvqvxDGQjVMleIEogV0RC52yI4al9fQA4cc94ez4hoB8KI//RLCZSI
         rqncu8Lt0wap/Sk5z94KCmOhsKr8cwpBvDQzmvrkLEg9tvHKaJ6TossDs2GSgIeLkog/
         LmRe1SSIc9WtqJKW45KXn+iTJOVgThQUiPvtL15osT3BrkwS4O47/ryaSJYBFiymf817
         IRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CrPBf14mwxSLO7aRnBxhd9zm0h5+2vyayHpyoWlJYoM=;
        b=gaas4KVquC9keRIfcf1C+oY5RHJEawt6L5d+Fb4eilKLNEcZpFO8j45p+Yk321KwJQ
         WFBIjg7BlD+XSPE1fTxRkX9yIcKL4I5UScaPIidXVo19yfyZZZDRK3gB9V0r1w6/xn4Y
         xOuGeBxMzu0IwfTGwKyvyB7NL5Ow4md1y/ovSYPNZCTdbJhSs8ElemqfJnzRlx4xRPNA
         fdhBVBX4OWTJZEF4Eonz3E1nITMtzZ2gl6IzSWfyzePV6D5924Mkyn7EjaWXRJUChzJF
         BaZ3fzSuu5Vbcs73kFHOm4PQiIKF0fZtxRGsT52hxiwhGG2H+PQNBGfBIbH0eyRCOJ9m
         4rfA==
X-Gm-Message-State: AOAM531u6ixMFCNLgoQQGiHNU4vyQr4JQcN1gQFEfdXYdRfY6tJnA8pF
        UcFNqFPlHSx1Si8gkwKOJrPluSIGqc5kUg==
X-Google-Smtp-Source: ABdhPJy6Ha7JMjymXr3wFDtxpsD7MXyqgWmTN/Vzf7L2v/5MbPY+rV9y7C1fGUW1ydIYQxfS9UN+ew==
X-Received: by 2002:a63:d009:: with SMTP id z9mr1289286pgf.16.1618616619299;
        Fri, 16 Apr 2021 16:43:39 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a185sm5623947pfd.70.2021.04.16.16.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 16:43:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 4/5] arm64: dts: ls1028a: declare the Integrated Endpoint Register Block node
Date:   Sat, 17 Apr 2021 02:42:24 +0300
Message-Id: <20210416234225.3715819-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416234225.3715819-1-olteanv@gmail.com>
References: <20210416234225.3715819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add a node describing the address in the SoC memory space for the IERB.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 7b45fba7a9cc..44e18603e678 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -1130,6 +1130,12 @@ fixed-link {
 			};
 		};
 
+		/* Integrated Endpoint Register Block */
+		ierb@1f0800000 {
+			compatible = "fsl,ls1028a-enetc-ierb";
+			reg = <0x01 0xf0800000 0x0 0x10000>;
+		};
+
 		rcpm: power-controller@1e34040 {
 			compatible = "fsl,ls1028a-rcpm", "fsl,qoriq-rcpm-2.1+";
 			reg = <0x0 0x1e34040 0x0 0x1c>;
-- 
2.25.1

