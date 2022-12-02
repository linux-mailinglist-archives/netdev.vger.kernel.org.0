Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB53640150
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiLBHwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbiLBHvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:51:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF47A5192;
        Thu,  1 Dec 2022 23:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669967499; x=1701503499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2gb0KVEJxLkfgfWcqwC2lUhZWa+6fkte1PAYqx1Oljc=;
  b=aP76ZtCyz5EVtksaG51NJiAxgIgDjC0UX/nS5wEo0nAHZdYAcV5ew+JY
   +/MBzzYd6i47xxt9ZsSs0mGCyeBF1WEegXejEGzuEBP/cpwKW9HZRc3O0
   tJdyG27JiNrzpsszgdegzTxis9GTZkui99t8OWuCNGWfPL+WpD2+nEJl4
   l6tDaQ7u0VyWoC7dskW01ZfBA6W6uvhoa5cYLfMgA35vX1brxvKXszKgI
   chJ6X52fjfh7/vJ6pjxYcUXCbWMQvp40JppBki8G69qPZKwOsY2YVW897
   dnr0sCuISI/AVs6bIhpAVOPIbrTU1bIT9eh4fP0XKthYfuV4R3mUoN1AD
   w==;
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="126141913"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2022 00:51:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Dec 2022 00:51:33 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Dec 2022 00:51:30 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Steen.Hegelund@microchip.com>,
        <lars.povlsen@microchip.com>, <daniel.machon@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <olteanv@gmail.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 3/4] net: microchip: vcap: Add vcap_rule_get_key_u32
Date:   Fri, 2 Dec 2022 08:56:20 +0100
Message-ID: <20221202075621.1504908-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221202075621.1504908-1-horatiu.vultur@microchip.com>
References: <20221202075621.1504908-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the function vcap_rule_get_key_u32 which allows to get the value and
the mask of a key that exist on the rule. If the key doesn't exist,
it would return error.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c   | 16 ++++++++++++++++
 .../ethernet/microchip/vcap/vcap_api_client.h    |  4 ++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index eae4e9fe0e147..05e915ea858d6 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -2338,6 +2338,22 @@ int vcap_rule_add_key_u128(struct vcap_rule *rule, enum vcap_key_field key,
 }
 EXPORT_SYMBOL_GPL(vcap_rule_add_key_u128);
 
+int vcap_rule_get_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
+			  u32 *value, u32 *mask)
+{
+	struct vcap_client_keyfield *ckf;
+
+	ckf = vcap_find_keyfield(rule, key);
+	if (!ckf)
+		return -ENOENT;
+
+	*value = ckf->data.u32.value;
+	*mask = ckf->data.u32.mask;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_rule_get_key_u32);
+
 /* Find a client action field in a rule */
 static struct vcap_client_actionfield *
 vcap_find_actionfield(struct vcap_rule *rule, enum vcap_action_field act)
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index fdfc5d58813bb..0319866f9c94d 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -258,4 +258,8 @@ int vcap_rule_mod_action_u32(struct vcap_rule *rule,
 			     enum vcap_action_field action,
 			     u32 value);
 
+/* Get a 32 bit key field value and mask from the rule */
+int vcap_rule_get_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
+			  u32 *value, u32 *mask);
+
 #endif /* __VCAP_API_CLIENT__ */
-- 
2.38.0

