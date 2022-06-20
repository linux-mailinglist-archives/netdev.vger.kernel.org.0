Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC6F5525B7
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 22:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244678AbiFTUTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 16:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343931AbiFTUTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 16:19:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EEC13E15
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 13:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0A4C60765
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 20:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB62C3411B;
        Mon, 20 Jun 2022 20:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655756357;
        bh=whPxTuT0qBVtaa4fNESO/ZAv1bMBRiN+N1MvCItauYc=;
        h=From:To:Cc:Subject:Date:From;
        b=NpbFBL4xmtEf/CM2KaZtTb+NqG0wNEJEafwW4NWMiqRh4U/u+/Og5pHsjHUVLJpye
         dkRODiW3sn20wLLZ5KuAhlDYMwuMauq/v390a0rcvvcXDxC622A8+c9enJcMWe/ATQ
         q9PHE4r4HuyOkef/31tHS+maefwnWnqvem0+QEhxi3MeibhTqUQIUh5mSqZB9brrQs
         1VgVRO9Csvp9iow2wXA0W+85e082M6Q/zC6qDIzSCffAd59qydbFUYeol1qXMp1nMV
         w2S4jxn/QYIDoK/Kfh4F7JVCyWqoJ0FNucFKLEqIZYtpR0ablbLm3UltdpeqKMONeo
         UMdR8V4LXY4vA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        boon.leong.ong@intel.com, rmk+kernel@armlinux.org.uk
Subject: [PATCH net-next] net: pcs: xpcs: select PHYLINK in Kconfig
Date:   Mon, 20 Jun 2022 13:19:15 -0700
Message-Id: <20220620201915.1195280-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various builds bots are upset about lack of PHYLINK:

>> ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
>> ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!

Link: https://lore.kernel.org/all/202206182016.Go0zVi4t-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Fixes: b47aec885bcd ("net: pcs: xpcs: add CL37 1000BASE-X AN support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: andrew@lunn.ch
CC: hkallweit1@gmail.com
CC: linux@armlinux.org.uk
CC: boon.leong.ong@intel.com
CC: rmk+kernel@armlinux.org.uk
---
 drivers/net/pcs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..c3e52fa6ca06 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -8,6 +8,7 @@ menu "PCS device drivers"
 config PCS_XPCS
 	tristate "Synopsys DesignWare XPCS controller"
 	depends on MDIO_DEVICE && MDIO_BUS
+	select PHYLINK
 	help
 	  This module provides helper functions for Synopsys DesignWare XPCS
 	  controllers.
-- 
2.36.1

