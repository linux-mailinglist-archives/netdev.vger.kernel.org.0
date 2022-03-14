Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50A44D8EDB
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 22:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245362AbiCNVd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 17:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245306AbiCNVd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 17:33:27 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A933388B
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 14:32:15 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 1A74B2C0C35;
        Mon, 14 Mar 2022 21:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647293528;
        bh=CCslJI4Upt9ti4sTFV0dF2UZUVjFxXqK24Ghz+BqxaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KG9fXNXlKNU+snjweKpKj3+rkFkFLy5sEzLpwJKppiUh9KDfKiQ9BWNXy+7c8798A
         pbbSgP6ErCgJ/U4HzZtVi5oFmFdXrBggmuYeqbedgtzjnxpOqin8pBYR3cJ5d+7zpR
         gEqXuhDJBMek7iQRpvbo3v2/dXrTr48FQLpFePVO/KCLS7+vZoHBm2NranximxGMiV
         nPpVgoxTUyiXUyygU0H+tH2zcLXpFFwcyQ8Ktt2sTAOwakCMJwZXIYfxdLqAmFiRRY
         H1otMOk4Ox1s6XRWJnWEYQfCOjGS38xfQWRunvGqTWNSg9ROlTxlmY8ZllG70auv3J
         7QzYDPiu/7u2w==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B622fb4570007>; Tue, 15 Mar 2022 10:32:07 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 1DA3313EE36;
        Tue, 15 Mar 2022 10:32:07 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 0458E2A2678; Tue, 15 Mar 2022 10:32:04 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2 8/8] arm64: marvell: enable the 98DX2530 pinctrl driver
Date:   Tue, 15 Mar 2022 10:31:43 +1300
Message-Id: <20220314213143.2404162-9-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=o8Y5sQTvuykA:10 a=XQcNo-tEeLJW46c85tUA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit makes sure the drivers for the 98DX2530 pin controller is
enabled.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

Notes:
    Changes in v2:
    - None

 arch/arm64/Kconfig.platforms | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
index 21697449d762..6bbb56901794 100644
--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -183,11 +183,13 @@ config ARCH_MVEBU
 	select PINCTRL_ARMADA_37XX
 	select PINCTRL_ARMADA_AP806
 	select PINCTRL_ARMADA_CP110
+	select PINCTRL_AC5
 	help
 	  This enables support for Marvell EBU familly, including:
 	   - Armada 3700 SoC Family
 	   - Armada 7K SoC Family
 	   - Armada 8K SoC Family
+	   - 98DX2530 SoC Family
=20
 config ARCH_MXC
 	bool "ARMv8 based NXP i.MX SoC family"
--=20
2.35.1

