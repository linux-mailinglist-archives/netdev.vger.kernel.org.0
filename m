Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B00558A0E
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 22:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiFWUaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 16:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiFWU3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 16:29:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4983654FA8
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 13:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A248B8253C
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 20:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E2AC341C0;
        Thu, 23 Jun 2022 20:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656016186;
        bh=Ly7lJhYtk4s8/46JaslLoIg5sWT5cr9ID2xncHzebT8=;
        h=From:To:Cc:Subject:Date:From;
        b=UnM/35vt9gREZsvyH5EQBT5l3oh3pFwluk0mwPJzK97gQZSML4eHuTOFW+a4xJq7K
         oxsAK0K+2sCKa1OIov3VY7pq1XTgC8EgAgQuxMOjebYXA23qC+PgcHzfJW9t9jVqg3
         M8e7lDJj8eimCxbLBJYme4j6N9oUTWd4GSPneEj3Q8QR3CcTOleKr7OfArIjWj1pl0
         YtagRX9H3aC9ZXXzMC9Hu+XlcxsE99iMw8xpaChi7/UfRkFYEuxKxjMieAD9V9fgzu
         e9ceJypD2cLit5btX5TW7zIZ6uH+ZDlvywJ0XlIfnzaQskRXkqMbf8mZA8ZhaA6W3d
         u3h76xcv7usCg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        rmk+kernel@armlinux.org.uk, boon.leong.ong@intel.com
Subject: [PATCH net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
Date:   Thu, 23 Jun 2022 13:29:33 -0700
Message-Id: <20220623202933.2341938-1-kuba@kernel.org>
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

This is yet another attempt at fixing:

>> ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
>> ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!

Switch XPCS to be invisible, as Russell points out it's
"selected" by its consumers. Drop the dependency on MDIO_BUS
as "depends" is meaningless on "selected" symbols.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: b47aec885bcd ("net: pcs: xpcs: add CL37 1000BASE-X AN support")
Link: https://lore.kernel.org/netdev/20220620201915.1195280-1-kuba@kernel.org/
Link: https://lore.kernel.org/r/20220622083521.0de3ea5c@kernel.org/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: andrew@lunn.ch
CC: hkallweit1@gmail.com
CC: linux@armlinux.org.uk
CC: rmk+kernel@armlinux.org.uk
CC: boon.leong.ong@intel.com
---
 drivers/net/pcs/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..f778e5155fae 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -6,8 +6,8 @@
 menu "PCS device drivers"
 
 config PCS_XPCS
-	tristate "Synopsys DesignWare XPCS controller"
-	depends on MDIO_DEVICE && MDIO_BUS
+	tristate
+	select PHYLINK
 	help
 	  This module provides helper functions for Synopsys DesignWare XPCS
 	  controllers.
-- 
2.36.1

