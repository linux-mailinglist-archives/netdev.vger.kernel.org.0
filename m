Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D451E69AC73
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjBQN3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBQN3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:29:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0741468AFA;
        Fri, 17 Feb 2023 05:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676640545; x=1708176545;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fWjBECFP8J01OEx4LikRiFy7HsHydKDZBAVI6vrWI+0=;
  b=qDCohuwUXDNI2NVU2Yqw0OnYcxxV73aI1QfMrA4gYcfYY9IHoOUBpQz7
   Hu98fMb/6m+uncBCv4tKaErQt/weRLc8mmivmtIWnIUX7742dDjqXuXxy
   Pts8AW+tM3OD+98mIYYl31XtxclezWQt2Xg4HWesz/Cw8VEymaXyucTi2
   qKnjt+C1+XyCgrCREwkIrwwZTRU7eR6LZDRS0FwxOTIXy/fy9kMLORp6r
   PID3ArKP5sO2E9WeAGcMCHKWlicBfTk4TZlTTABQTaQjzV6rjoFnm3OOg
   90F85R9w899MK4ulb6t/4TgZMI9wy9wQe2gXW9H9LB9uHy4pcebXIj5pi
   w==;
X-IronPort-AV: E=Sophos;i="5.97,304,1669100400"; 
   d="scan'208";a="197513884"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2023 06:29:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 06:28:49 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 06:28:47 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <larysa.zaremba@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3] net: lan966x: Use automatic selection of VCAP rule actionset
Date:   Fri, 17 Feb 2023 14:28:31 +0100
Message-ID: <20230217132831.2508465-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 81e164c4aec5 ("net: microchip: sparx5: Add automatic
selection of VCAP rule actionset") the VCAP API has the capability to
select automatically the actionset based on the actions that are attached
to the rule. So it is not needed anymore to hardcode the actionset in the
driver, therefore it is OK to remove this.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v2->v3:
- fix typo hardcore -> hardcode
- remove vcap_set_rule_set_actionset also for PTP rules
v1->v2:
- improve the commit message by mentioning the commit which allows
  to make this change
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c       | 3 +--
 drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index a8348437dd87f..ded9ab79ccc21 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -83,8 +83,7 @@ static int lan966x_ptp_add_trap(struct lan966x_port *port,
 	if (err)
 		goto free_rule;
 
-	err = vcap_set_rule_set_actionset(vrule, VCAP_AFS_BASE_TYPE);
-	err |= vcap_rule_add_action_bit(vrule, VCAP_AF_CPU_COPY_ENA, VCAP_BIT_1);
+	err = vcap_rule_add_action_bit(vrule, VCAP_AF_CPU_COPY_ENA, VCAP_BIT_1);
 	err |= vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE, LAN966X_PMM_REPLACE);
 	err |= vcap_val_rule(vrule, proto);
 	if (err)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index bd10a71897418..f960727ecaeec 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -261,8 +261,6 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
 							0);
 			err |= vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE,
 							LAN966X_PMM_REPLACE);
-			err |= vcap_set_rule_set_actionset(vrule,
-							   VCAP_AFS_BASE_TYPE);
 			if (err)
 				goto out;
 
-- 
2.38.0

