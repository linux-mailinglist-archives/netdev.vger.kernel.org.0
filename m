Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D32D62DC95
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239987AbiKQNYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240018AbiKQNYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:24:00 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3105C5F86F;
        Thu, 17 Nov 2022 05:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668691436; x=1700227436;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Mva3irCZtbU/n4ixfR3IHzyqvcagg8EtGCdeTzm6YVk=;
  b=U56tONk9N9N8xHXozEs1syZCq+FBrJxJOvzf2GtnhVY4Un6LFpjDKBXT
   MajopqvOaP7P7HyNwhx0fzqPzekPEVjKGGaJxTMXMt3FdaxGQJbvVVXrj
   8t8Dm/seOCY4SZ1b/dkTVpIQG+CYNTKb9cJlFv+1zs4EJnk/ukeU5SXUY
   WSTGp1kUfyFhjhcyCI16uVkRjiy4GIbiu32umf+PE+HaD+ppT+Ranz4nH
   VKuSQipfLLbJeLcm4B3HFNDBeMA9PY2Q/QL+k93kmxwGAiyTawJHRdI2J
   YJ1aGwN/U5VT6+VI/x0PI5JAruIheQiAH3u5g824cdgtPbmBSBjJir3WE
   w==;
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="189423565"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2022 06:23:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 17 Nov 2022 06:23:56 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 17 Nov 2022 06:23:54 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Steen.Hegelund@microchip.com>, <lars.povlsen@microchip.com>,
        <daniel.machon@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: microchip: sparx5: kunit test: Fix compile warnings.
Date:   Thu, 17 Nov 2022 14:28:12 +0100
Message-ID: <20221117132812.2105718-1-horatiu.vultur@microchip.com>
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

When VCAP_KUNIT_TEST is enabled the following warnings are generated:

drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:257:34: warning: Using plain integer as NULL pointer
drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:258:41: warning: Using plain integer as NULL pointer
drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:342:23: warning: Using plain integer as NULL pointer
drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:359:23: warning: Using plain integer as NULL pointer
drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:1327:34: warning: Using plain integer as NULL pointer
drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:1328:41: warning: Using plain integer as NULL pointer

Therefore fix this.

Fixes: dccc30cc4906 ("net: microchip: sparx5: Add KUNIT test of counters and sorted rules")
Fixes: c956b9b318d9 ("net: microchip: sparx5: Adding KUNIT tests of key/action values in VCAP API")
Fixes: 67d637516fa9 ("net: microchip: sparx5: Adding KUNIT test for the VCAP API")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index 6858e44ce4a55..194734cadf8b4 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -254,8 +254,8 @@ test_vcap_xn_rule_creator(struct kunit *test, int cid, enum vcap_user user,
 			  u16 priority,
 			  int id, int size, int expected_addr)
 {
-	struct vcap_rule *rule = 0;
-	struct vcap_rule_internal *ri = 0;
+	struct vcap_rule *rule;
+	struct vcap_rule_internal *ri;
 	enum vcap_keyfield_set keyset = VCAP_KFS_NO_VALUE;
 	enum vcap_actionfield_set actionset = VCAP_AFS_NO_VALUE;
 	int ret;
@@ -339,7 +339,7 @@ static void vcap_api_set_bit_1_test(struct kunit *test)
 		.sw_width = 52,
 		.reg_idx = 1,
 		.reg_bitpos = 20,
-		.tg = 0
+		.tg = NULL,
 	};
 	u32 stream[2] = {0};
 
@@ -356,7 +356,7 @@ static void vcap_api_set_bit_0_test(struct kunit *test)
 		.sw_width = 52,
 		.reg_idx = 2,
 		.reg_bitpos = 11,
-		.tg = 0
+		.tg = NULL,
 	};
 	u32 stream[3] = {~0, ~0, ~0};
 
@@ -1324,8 +1324,8 @@ static void vcap_api_encode_rule_test(struct kunit *test)
 			.actionstream = actdata,
 		},
 	};
-	struct vcap_rule *rule = 0;
-	struct vcap_rule_internal *ri = 0;
+	struct vcap_rule *rule;
+	struct vcap_rule_internal *ri;
 	int vcap_chain_id = 10005;
 	enum vcap_user user = VCAP_USER_VCAP_UTIL;
 	u16 priority = 10;
-- 
2.38.0

