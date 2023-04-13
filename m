Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AE76E043C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 04:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjDMChO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 22:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjDMCgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 22:36:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A05683E8;
        Wed, 12 Apr 2023 19:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 273C263A94;
        Thu, 13 Apr 2023 02:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2F9C4339C;
        Thu, 13 Apr 2023 02:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353395;
        bh=LXI1v+1r/T7TmPvJ1sPdooU44mF100hAJPtvSYd6UZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CauH5QblQtEWNL+UR86wn8ALnVGxbfrwIBrYjJ+XtrZQnOSJoF0G1wDHgwag3QBI1
         2ctXBIjL/ZpjwSE+sjmRubL+zc9KgkXCp9Mn4YmuRRUtIM7/y9wtusvTOBGEklRAaU
         k8Ln3PWmhtuLyq1WGJlrDjFn6YXCfF5m/C9K/u+VB3dpWyk1fI9hiNMFPPfS6IDvcA
         zAaL/DyGATKBTgtEHwJQr+oO28onympnFTq7750uV6Au5sytfvEkl3+e8heoijxHOw
         hQNYMOzPnvIPgGCOqQWOxDIDvG63ypT8jN8VQtYr5CxiNBXFqcmg+IAhF3/p7kyuCw
         /wgHlXdLp78aQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>, chowtom <chowtom@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 14/20] net: sfp: add quirk enabling 2500Base-x for HG MXPD-483II
Date:   Wed, 12 Apr 2023 22:35:52 -0400
Message-Id: <20230413023601.74410-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023601.74410-1-sashal@kernel.org>
References: <20230413023601.74410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

