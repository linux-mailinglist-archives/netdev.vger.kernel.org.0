Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E823D6E91B1
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbjDTLFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbjDTLEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:04:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408BF7AB8;
        Thu, 20 Apr 2023 04:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64929647D1;
        Thu, 20 Apr 2023 11:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781E1C4339B;
        Thu, 20 Apr 2023 11:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988544;
        bh=LXI1v+1r/T7TmPvJ1sPdooU44mF100hAJPtvSYd6UZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXMWA9Yjnbceyi9URwy02Q1VvXnwiU3Dk0fcCq2ESEy9HAMihqTgqjgoKvT/FBYXO
         xsnhAceQ2lJ3bu228lNDbxM7oPvwUNrsNeeqrTnY2wr18B0xp3vOzplzbIb9N6GNYa
         8C5G+Fzyla7CdRaUKlDK7TmeTnMWstcWowY4niy/b9I3/bY0ODHQSOFpzdKIq31W+h
         y6YcGwxMMbg1Wxz5lKsoq+n7gv5+Dd4zRBghKTQbC4WSXOmzPJqkTib5qFKq7FZp4Y
         KHrW9hhUS2n1LYhq0byfotME2mDiNEnNGIYmuj2vhYpbd00uBCoUc/nVk9Nmb5PAzM
         T0nvg5ykgFuXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>, chowtom <chowtom@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 14/17] net: sfp: add quirk enabling 2500Base-x for HG MXPD-483II
Date:   Thu, 20 Apr 2023 07:01:43 -0400
Message-Id: <20230420110148.505779-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110148.505779-1-sashal@kernel.org>
References: <20230420110148.505779-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit ad651d68cee75e9ac20002254c4e5d09ee67a84b ]

The HG MXPD-483II 1310nm SFP module is meant to operate with 2500Base-X,
however, in their EEPROM they incorrectly specify:
    Transceiver type                          : Ethernet: 1000BASE-LX
    ...
    BR, Nominal                               : 2600MBd

Use sfp_quirk_2500basex for this module to allow 2500Base-X mode anyway.

https://forum.banana-pi.org/t/bpi-r3-sfp-module-compatibility/14573/60

Reported-by: chowtom <chowtom@gmail.com>
Tested-by: chowtom <chowtom@gmail.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 83b99d95b2787..10a5a6f4ec307 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -389,6 +389,10 @@ static const struct sfp_quirk sfp_quirks[] = {
 
 	SFP_QUIRK_F("HALNy", "HL-GSFP", sfp_fixup_halny_gsfp),
 
+	// HG MXPD-483II-F 2.5G supports 2500Base-X, but incorrectly reports
+	// 2600MBd in their EERPOM
+	SFP_QUIRK_M("HG GENUINE", "MXPD-483II", sfp_quirk_2500basex),
+
 	// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd NRZ in
 	// their EEPROM
 	SFP_QUIRK("HUAWEI", "MA5671A", sfp_quirk_2500basex,
-- 
2.39.2

