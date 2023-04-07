Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19A46DAF99
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbjDGPTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240763AbjDGPS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:18:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFCCAF38
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=FeLc91hLpGM7djM3MfRLG+qEX3kBHlbEQz+RJVIeDUM=; b=jPwt1AwnZY9+kLIVDUH2cEp9xh
        N0QBfdb5+KIOv96fUoYw+BvX3fgbPB9SZO6Z1DdTPxeMhrNO1Bb43UOvF/XtxhTPTDCviHGXmxZ2v
        TGq4OK4lnw+ycuXKuWrQJlh042MfJEw4X94T1odoKWnE33Gqt6eBsjzINVMTms2YMCfU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pknrO-009jhB-90; Fri, 07 Apr 2023 17:18:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gregory Clement <gregory.clement@bootlin.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] ARM64: dts: marvell: cn9310: Add missing phy-mode
Date:   Fri,  7 Apr 2023 17:18:39 +0200
Message-Id: <20230407151839.2320596-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA framework has got more picky about always having a phy-mode
for the CPU port. The SoC Ethernet is being configured to
10gbase-r. Set the switch phy-mode based on this. Additionally, the
SoC Ethernet is using in-band signalling to determine the link speed,
so add same parameter to the switch.

Additionally, the cpu label has never actually been used in the
binding, so remove it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm64/boot/dts/marvell/cn9130-crb.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi b/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
index 8e4ec243fb8f..32cfb3e2efc3 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
@@ -282,8 +282,9 @@ port@9 {
 
 			port@a {
 				reg = <10>;
-				label = "cpu";
 				ethernet = <&cp0_eth0>;
+				phy-mode = "10gbase-r";
+				managed = "in-band-status";
 			};
 
 		};
-- 
2.40.0

