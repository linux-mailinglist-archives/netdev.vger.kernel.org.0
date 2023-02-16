Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8C0699456
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjBPM3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBPM3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:29:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8416A2202E;
        Thu, 16 Feb 2023 04:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676550580; x=1708086580;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZnC8Lw8j7ydHwV6zv8nsmB+fLdFDL3MJ3B1RYeFSeuw=;
  b=ge45uuMdfsn0lvSh7EvnLg0ZTHWlyH6SEpYUIoAkJUUpxlDv2Q/iGQ8a
   Tg2m3OjP7Ox4ZJg25vxCc1nJpUuaOitOVdG0i4Pt/RgjkBEdlyFl6Zdmu
   ntBWm62bn1mSwZSD57o/sp+X5AeVuNYeG2D3xcxMpp0ZgMw5geX9Md8/z
   5kmb4p3MKJC1vHUf0q+NQeQnYAZshXyuBumb1hRZZbw+3KxU48190nWAH
   ZAjQ60aai6pXV1HzqqnW6hpvCfkYBmdXAim/Bs+g0UFvpt82DwALBI2/l
   KffjdmtxbXY8ZbRnHqFQl87AZVgizSSHjU61mMO9wLSxpmLIX7I5fAOv+
   g==;
X-IronPort-AV: E=Sophos;i="5.97,302,1669100400"; 
   d="scan'208";a="200971009"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2023 05:29:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 05:29:39 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 05:29:38 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2] net: lan966x: Use automatic selection of VCAP rule actionset
Date:   Thu, 16 Feb 2023 13:29:07 +0100
Message-ID: <20230216122907.2207291-1-horatiu.vultur@microchip.com>
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
to the rule. So it is not needed anymore to hardcore the actionset in the
driver, therefore it is OK to remove this.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v1->v2:
- improve the commit message by mentioning the commit which allows
  to make this change
---
 drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c | 2 --
 1 file changed, 2 deletions(-)

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

