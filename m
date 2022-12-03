Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131DC64160E
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 11:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiLCKqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 05:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiLCKqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 05:46:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A2E5A6CA;
        Sat,  3 Dec 2022 02:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670064402; x=1701600402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2gb0KVEJxLkfgfWcqwC2lUhZWa+6fkte1PAYqx1Oljc=;
  b=oKSITuDwQlNnwk9uL9FONK3oridswB+aieLzz3kzVGSjtAsJL0lzPReJ
   VTcCorUxnGBsyECSYqJOELvFE/NQCbQB29kF8SFMgHhC9quZZWGO2SAPl
   EpD0x1xn7X4WrNmMLcso9HJ4V43ngPC6zXAgWUnOuGBRiYNkPlv4PSazp
   LGONEztmfpzXQwa3QA10sDfYFprmao3iHzeY3d9G0fzEPC+7YP8c448b+
   1BQ39JB+HAsQCrKhSXhTbc6AW2wKJqKBeWE1GRbZmQrvKVKGMDpRwQRL3
   hjvnA/ZMZS5ArWMTU0j3Kh+EThZKTfUIP8JRCp7JNNas4cb0UoiPX+sYV
   w==;
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="189861164"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2022 03:46:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sat, 3 Dec 2022 03:46:41 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sat, 3 Dec 2022 03:46:38 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Steen.Hegelund@microchip.com>,
        <lars.povlsen@microchip.com>, <daniel.machon@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <olteanv@gmail.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 3/4] net: microchip: vcap: Add vcap_rule_get_key_u32
Date:   Sat, 3 Dec 2022 11:43:47 +0100
Message-ID: <20221203104348.1749811-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221203104348.1749811-1-horatiu.vultur@microchip.com>
References: <20221203104348.1749811-1-horatiu.vultur@microchip.com>
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

