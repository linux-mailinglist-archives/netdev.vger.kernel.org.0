Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE6F2AB5CC
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgKILFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgKILFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:05:19 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AD7C0613CF;
        Mon,  9 Nov 2020 03:05:19 -0800 (PST)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 25ABA22EEB;
        Mon,  9 Nov 2020 12:05:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1604919916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kOqIuIndQf3aK9yaBEOv3D7I9b4UZvE3iTyoW8FVpLU=;
        b=rO4j0B0yfqTFIx0ShMhu8go6NNnXWNsz4GOFGyfWQ84tagw2diaJvToVUOdJta8GF49kxa
        Q4YyJxB16cxvLwA/zZZ99c9nnNAd7ZvEHcX+SyBdLqbvEGCMzPbuNOlh/g57WnhrFNn7hA
        4WDF0luGmCuXYTo8Rpr9DBMVVF77ZFg=
From:   Michael Walle <michael@walle.cc>
To:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net RESEND] arm64: dts: fsl-ls1028a-kontron-sl28: specify in-band mode for ENETC
Date:   Mon,  9 Nov 2020 12:04:36 +0100
Message-Id: <20201109110436.5906-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX") the
network port of the Kontron sl28 board is broken. After the migration to
phylink the device tree has to specify the in-band-mode property. Add
it.

Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Forgot to add the netdev@ mailinglist in my former submission.

From my previous mail:
> Ping. will this go through the net queue or Shawn's queue. In any case,
> it should make it into a fixes queue, because this board is currently
> broken in 5.10-rc2.

 arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
index 17a2f5dacc3f..54ff6f7c2477 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
@@ -79,6 +79,7 @@
 &enetc_port0 {
 	phy-handle = <&phy0>;
 	phy-connection-type = "sgmii";
+	managed = "in-band-status";
 	status = "okay";
 
 	mdio {
-- 
2.20.1

