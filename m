Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5AC695D5D
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjBNIn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBNIn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:43:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FC6CDD6;
        Tue, 14 Feb 2023 00:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676364207; x=1707900207;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BXIr4+VIWq9cUCsuzL+i/vlpdZv710csS/iIfxVyaMQ=;
  b=y6BkbzCorruBLp4rdSyTOFz7wNVQ27MrL4QDDBDTjW3ypa8oau3/uQrW
   4qPSoEh6JMzSv4oxQjAeOSgMjx9wx/tIZ/LISVNOo/YLvSLBIHIRospDL
   yAHwol6hD8x3tK/43Rdx5YHpVLYWEaJun0nkeoNpJuCUHpafdAjyh43W7
   bHikOUZiQVJ3nytYgZtc78wlLhQ+aN5EvJnCH8ArQAIancjoGy1n2tdVL
   xP8P4UPrV05hZ/Cq/aM2l1yswIIT4EkQYxXq/Lk2zVXIlzwZFCDo4n7M/
   36CAcp+/Md7iU9YRy0yROE5vPtXS1yy674zcksKXXbSZSn3vzTNeYwKcq
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,296,1669100400"; 
   d="scan'208";a="196806006"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Feb 2023 01:43:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 01:43:24 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 01:43:22 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Use automatic selection of VCAP rule actionset
Date:   Tue, 14 Feb 2023 09:42:06 +0100
Message-ID: <20230214084206.1412423-1-horatiu.vultur@microchip.com>
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

Now the VCAP API automatically selects the action set, therefore is
not needed to be hardcoded anymore to hardcode the action in the
lan966x. Therefore remove this.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
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

