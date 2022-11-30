Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2848763D845
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiK3Ocy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiK3OcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:32:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFDE6B39A;
        Wed, 30 Nov 2022 06:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669818726; x=1701354726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2gb0KVEJxLkfgfWcqwC2lUhZWa+6fkte1PAYqx1Oljc=;
  b=J5vy73oplXp+GSUEVMnBPKf6i4rVRj1FFjPdxfcN4X3OfXI3Z8bInxku
   Srok2tL1iJ0H0nmEcZsPYplHzJSq2TtY83F5qGFvJPcmxXWZLjx33XfL7
   v46UQWyU0TLphkxkIu2WB3reSaUrpvV7efayOJIWqJNOhjWjzNqhGgiPK
   7pVM+aiot7gi76mmqRK8XlqKslLAZMB06GIjBC5Ha/zIFRt5/3kcq9UsR
   vgf19UHY+8UqgyTTryoOH/WmnyaNOt6G6bpjeMxoI8uhZFvH1eCbm1Cco
   Tk+eN8oGSv1p85rMzBnMG2TnIynm0b1eLZPzJfKbs/3DJWfWA6uuAfr5G
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="191144800"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 07:30:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 07:30:37 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 07:30:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/4] net: microchip: vcap: Add vcap_rule_get_key_u32
Date:   Wed, 30 Nov 2022 15:35:24 +0100
Message-ID: <20221130143525.934906-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130143525.934906-1-horatiu.vultur@microchip.com>
References: <20221130143525.934906-1-horatiu.vultur@microchip.com>
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

