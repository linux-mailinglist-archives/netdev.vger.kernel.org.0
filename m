Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84B963869E
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiKYJtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiKYJrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:47:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BB33D923;
        Fri, 25 Nov 2022 01:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669369581; x=1700905581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TYXorT9DOo+3WztLtIfe+bDwuNKkxCZCmA5YzIPCu4o=;
  b=cNJTzwDp8HZPonTt62n1BzPsJvJijb26JqdExB1VqoiwmUII1gF3tv2D
   PeLm+yleOrTenoH1KtGbWzNzzOHBy9CU93ELXST2g1ZGkZtxPmrjdku7E
   TvBTnoMAOEFaDy2JO+TAsKwRXU8RcU1X0TdretnZYOrdMQJxSFBAmD0j0
   B1HXOEW+W+AyOjFUOsB/WV24bM/XN9OHjsy37gO2x36t+j+GDcsjvIzpN
   GWENH3Trmk0AYhGKZVEji7B3V37s5MZW9Q6kVscq1Z5gJAkNCpZ3DqzAc
   LO1StXrnpnrx0GBn//ZTkmruVSZLV28V0fBjqjfgkvfQiKMNCl9PcTmfe
   w==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="125074991"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 02:46:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 02:46:16 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 02:46:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/9] net: lan966x: Add is2 vcap model to vcap API.
Date:   Fri, 25 Nov 2022 10:50:05 +0100
Message-ID: <20221125095010.124458-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125095010.124458-1-horatiu.vultur@microchip.com>
References: <20221125095010.124458-1-horatiu.vultur@microchip.com>
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

This provides the lan966x is2 model and adds it to the vcap control
instance that will be provided to the vcap API.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |    2 +-
 .../microchip/lan966x/lan966x_vcap_ag_api.c   | 1608 +++++++++++++++++
 .../microchip/lan966x/lan966x_vcap_ag_api.h   |   11 +
 .../microchip/lan966x/lan966x_vcap_impl.c     |    4 +
 4 files changed, 1624 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.h

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 2c27784859014..053a174f09f32 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -12,7 +12,7 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o \
 			lan966x_tbf.o lan966x_cbs.o lan966x_ets.o \
 			lan966x_tc_matchall.o lan966x_police.o lan966x_mirror.o \
-			lan966x_xdp.o lan966x_vcap_impl.o
+			lan966x_xdp.o lan966x_vcap_impl.o lan966x_vcap_ag_api.o
 
 # Provide include files
 ccflags-y += -I$(srctree)/drivers/net/ethernet/microchip/vcap
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
new file mode 100644
index 0000000000000..928e711960e6b
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
@@ -0,0 +1,1608 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+#include "lan966x_vcap_ag_api.h"
+
+/* keyfields */
+static const struct vcap_field is2_mac_etype_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 4,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_PAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 5,
+		.width = 8,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 9,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 22,
+		.width = 1,
+	},
+	[VCAP_KF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 23,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 24,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 25,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 26,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 27,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 39,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 40,
+		.width = 3,
+	},
+	[VCAP_KF_L2_DMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 43,
+		.width = 48,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 91,
+		.width = 48,
+	},
+	[VCAP_KF_ETYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 139,
+		.width = 16,
+	},
+	[VCAP_KF_L2_FRM_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 155,
+		.width = 4,
+	},
+	[VCAP_KF_L2_PAYLOAD0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 159,
+		.width = 16,
+	},
+	[VCAP_KF_L2_PAYLOAD1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 175,
+		.width = 8,
+	},
+	[VCAP_KF_L2_PAYLOAD2] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 183,
+		.width = 3,
+	},
+};
+
+static const struct vcap_field is2_mac_llc_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 4,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_PAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 5,
+		.width = 8,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 9,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 22,
+		.width = 1,
+	},
+	[VCAP_KF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 23,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 24,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 25,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 26,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 27,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 39,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 40,
+		.width = 3,
+	},
+	[VCAP_KF_L2_DMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 43,
+		.width = 48,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 91,
+		.width = 48,
+	},
+	[VCAP_KF_L2_LLC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 139,
+		.width = 40,
+	},
+};
+
+static const struct vcap_field is2_mac_snap_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 4,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_PAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 5,
+		.width = 8,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 9,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 22,
+		.width = 1,
+	},
+	[VCAP_KF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 23,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 24,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 25,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 26,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 27,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 39,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 40,
+		.width = 3,
+	},
+	[VCAP_KF_L2_DMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 43,
+		.width = 48,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 91,
+		.width = 48,
+	},
+	[VCAP_KF_L2_SNAP] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 139,
+		.width = 40,
+	},
+};
+
+static const struct vcap_field is2_arp_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 4,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_PAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 5,
+		.width = 8,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 9,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 22,
+		.width = 1,
+	},
+	[VCAP_KF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 23,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 24,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 25,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 26,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 27,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 39,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 40,
+		.width = 3,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 43,
+		.width = 48,
+	},
+	[VCAP_KF_ARP_ADDR_SPACE_OK_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 91,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_PROTO_SPACE_OK_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 92,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_LEN_OK_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 93,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_TGT_MATCH_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 94,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_SENDER_MATCH_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 95,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_OPCODE_UNKNOWN_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 96,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_OPCODE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 97,
+		.width = 2,
+	},
+	[VCAP_KF_L3_IP4_DIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 99,
+		.width = 32,
+	},
+	[VCAP_KF_L3_IP4_SIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 131,
+		.width = 32,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 163,
+		.width = 1,
+	},
+};
+
+static const struct vcap_field is2_ip4_tcp_udp_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 4,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_PAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 5,
+		.width = 8,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 9,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 22,
+		.width = 1,
+	},
+	[VCAP_KF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 23,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 24,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 25,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 26,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 27,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 39,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 40,
+		.width = 3,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 43,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAGMENT] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 44,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAG_OFS_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 45,
+		.width = 1,
+	},
+	[VCAP_KF_L3_OPTIONS_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 46,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TTL_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 47,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TOS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 48,
+		.width = 8,
+	},
+	[VCAP_KF_L3_IP4_DIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 56,
+		.width = 32,
+	},
+	[VCAP_KF_L3_IP4_SIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 88,
+		.width = 32,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 120,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 121,
+		.width = 1,
+	},
+	[VCAP_KF_L4_DPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 122,
+		.width = 16,
+	},
+	[VCAP_KF_L4_SPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 138,
+		.width = 16,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 154,
+		.width = 8,
+	},
+	[VCAP_KF_L4_SPORT_EQ_DPORT_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 162,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SEQUENCE_EQ0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 163,
+		.width = 1,
+	},
+	[VCAP_KF_L4_FIN] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 164,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SYN] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 165,
+		.width = 1,
+	},
+	[VCAP_KF_L4_RST] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 166,
+		.width = 1,
+	},
+	[VCAP_KF_L4_PSH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 167,
+		.width = 1,
+	},
+	[VCAP_KF_L4_ACK] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 168,
+		.width = 1,
+	},
+	[VCAP_KF_L4_URG] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 169,
+		.width = 1,
+	},
+	[VCAP_KF_L4_1588_DOM] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 170,
+		.width = 8,
+	},
+	[VCAP_KF_L4_1588_VER] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 178,
+		.width = 4,
+	},
+};
+
+static const struct vcap_field is2_ip4_other_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 4,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_PAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 5,
+		.width = 8,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 9,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 22,
+		.width = 1,
+	},
+	[VCAP_KF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 23,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 24,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 25,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 26,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 27,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 39,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 40,
+		.width = 3,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 43,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAGMENT] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 44,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAG_OFS_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 45,
+		.width = 1,
+	},
+	[VCAP_KF_L3_OPTIONS_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 46,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TTL_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 47,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TOS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 48,
+		.width = 8,
+	},
+	[VCAP_KF_L3_IP4_DIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 56,
+		.width = 32,
+	},
+	[VCAP_KF_L3_IP4_SIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 88,
+		.width = 32,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 120,
+		.width = 1,
+	},
+	[VCAP_KF_L3_IP_PROTO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 121,
+		.width = 8,
+	},
+	[VCAP_KF_L3_PAYLOAD] = {
+		.type = VCAP_FIELD_U56,
+		.offset = 129,
+		.width = 56,
+	},
+};
+
+static const struct vcap_field is2_ip6_std_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 4,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_PAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 5,
+		.width = 8,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 9,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 22,
+		.width = 1,
+	},
+	[VCAP_KF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 23,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 24,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 25,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 26,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 27,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 39,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 40,
+		.width = 3,
+	},
+	[VCAP_KF_L3_TTL_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 43,
+		.width = 1,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 44,
+		.width = 128,
+	},
+	[VCAP_KF_L3_IP_PROTO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 172,
+		.width = 8,
+	},
+};
+
+static const struct vcap_field is2_oam_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 4,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_PAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 5,
+		.width = 8,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 9,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 22,
+		.width = 1,
+	},
+	[VCAP_KF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 23,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 24,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 25,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 26,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 27,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 39,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 40,
+		.width = 3,
+	},
+	[VCAP_KF_L2_DMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 43,
+		.width = 48,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 91,
+		.width = 48,
+	},
+	[VCAP_KF_OAM_MEL_FLAGS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 139,
+		.width = 7,
+	},
+	[VCAP_KF_OAM_VER] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 146,
+		.width = 5,
+	},
+	[VCAP_KF_OAM_OPCODE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 151,
+		.width = 8,
+	},
+	[VCAP_KF_OAM_FLAGS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 159,
+		.width = 8,
+	},
+	[VCAP_KF_OAM_MEPID] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 167,
+		.width = 16,
+	},
+	[VCAP_KF_OAM_CCM_CNTS_EQ0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 183,
+		.width = 1,
+	},
+	[VCAP_KF_OAM_Y1731_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 184,
+		.width = 1,
+	},
+	[VCAP_KF_OAM_DETECTED] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 185,
+		.width = 1,
+	},
+};
+
+static const struct vcap_field is2_ip6_tcp_udp_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 2,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 2,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_PAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 3,
+		.width = 8,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 11,
+		.width = 9,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 20,
+		.width = 1,
+	},
+	[VCAP_KF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 21,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 22,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 23,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 24,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 25,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 37,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 38,
+		.width = 3,
+	},
+	[VCAP_KF_L3_TTL_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 41,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TOS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 42,
+		.width = 8,
+	},
+	[VCAP_KF_L3_IP6_DIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 50,
+		.width = 128,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 178,
+		.width = 128,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 306,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 307,
+		.width = 1,
+	},
+	[VCAP_KF_L4_DPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 308,
+		.width = 16,
+	},
+	[VCAP_KF_L4_SPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 324,
+		.width = 16,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 340,
+		.width = 8,
+	},
+	[VCAP_KF_L4_SPORT_EQ_DPORT_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 348,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SEQUENCE_EQ0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 349,
+		.width = 1,
+	},
+	[VCAP_KF_L4_FIN] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 350,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SYN] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 351,
+		.width = 1,
+	},
+	[VCAP_KF_L4_RST] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 352,
+		.width = 1,
+	},
+	[VCAP_KF_L4_PSH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 353,
+		.width = 1,
+	},
+	[VCAP_KF_L4_ACK] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 354,
+		.width = 1,
+	},
+	[VCAP_KF_L4_URG] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 355,
+		.width = 1,
+	},
+	[VCAP_KF_L4_1588_DOM] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 356,
+		.width = 8,
+	},
+	[VCAP_KF_L4_1588_VER] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 364,
+		.width = 4,
+	},
+};
+
+static const struct vcap_field is2_ip6_other_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 2,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 2,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_PAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 3,
+		.width = 8,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 11,
+		.width = 9,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 20,
+		.width = 1,
+	},
+	[VCAP_KF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 21,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 22,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 23,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 24,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 25,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 37,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 38,
+		.width = 3,
+	},
+	[VCAP_KF_L3_TTL_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 41,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TOS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 42,
+		.width = 8,
+	},
+	[VCAP_KF_L3_IP6_DIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 50,
+		.width = 128,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 178,
+		.width = 128,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 306,
+		.width = 1,
+	},
+	[VCAP_KF_L3_IP_PROTO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 307,
+		.width = 8,
+	},
+	[VCAP_KF_L3_PAYLOAD] = {
+		.type = VCAP_FIELD_U56,
+		.offset = 315,
+		.width = 56,
+	},
+};
+
+static const struct vcap_field is2_smac_sip4_keyfield[] = {
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 4,
+		.width = 48,
+	},
+	[VCAP_KF_L3_IP4_SIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 52,
+		.width = 32,
+	},
+};
+
+static const struct vcap_field is2_smac_sip6_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 4,
+		.width = 4,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 8,
+		.width = 48,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 56,
+		.width = 128,
+	},
+};
+
+/* keyfield_set */
+static const struct vcap_set is2_keyfield_set[] = {
+	[VCAP_KFS_MAC_ETYPE] = {
+		.type_id = 0,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_MAC_LLC] = {
+		.type_id = 1,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_MAC_SNAP] = {
+		.type_id = 2,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_ARP] = {
+		.type_id = 3,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP4_TCP_UDP] = {
+		.type_id = 4,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP4_OTHER] = {
+		.type_id = 5,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP6_STD] = {
+		.type_id = 6,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_OAM] = {
+		.type_id = 7,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP6_TCP_UDP] = {
+		.type_id = 0,
+		.sw_per_item = 4,
+		.sw_cnt = 1,
+	},
+	[VCAP_KFS_IP6_OTHER] = {
+		.type_id = 1,
+		.sw_per_item = 4,
+		.sw_cnt = 1,
+	},
+	[VCAP_KFS_SMAC_SIP4] = {
+		.type_id = -1,
+		.sw_per_item = 1,
+		.sw_cnt = 4,
+	},
+	[VCAP_KFS_SMAC_SIP6] = {
+		.type_id = 8,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+};
+
+/* keyfield_set map */
+static const struct vcap_field *is2_keyfield_set_map[] = {
+	[VCAP_KFS_MAC_ETYPE] = is2_mac_etype_keyfield,
+	[VCAP_KFS_MAC_LLC] = is2_mac_llc_keyfield,
+	[VCAP_KFS_MAC_SNAP] = is2_mac_snap_keyfield,
+	[VCAP_KFS_ARP] = is2_arp_keyfield,
+	[VCAP_KFS_IP4_TCP_UDP] = is2_ip4_tcp_udp_keyfield,
+	[VCAP_KFS_IP4_OTHER] = is2_ip4_other_keyfield,
+	[VCAP_KFS_IP6_STD] = is2_ip6_std_keyfield,
+	[VCAP_KFS_OAM] = is2_oam_keyfield,
+	[VCAP_KFS_IP6_TCP_UDP] = is2_ip6_tcp_udp_keyfield,
+	[VCAP_KFS_IP6_OTHER] = is2_ip6_other_keyfield,
+	[VCAP_KFS_SMAC_SIP4] = is2_smac_sip4_keyfield,
+	[VCAP_KFS_SMAC_SIP6] = is2_smac_sip6_keyfield,
+};
+
+/* keyfield_set map sizes */
+static int is2_keyfield_set_map_size[] = {
+	[VCAP_KFS_MAC_ETYPE] = ARRAY_SIZE(is2_mac_etype_keyfield),
+	[VCAP_KFS_MAC_LLC] = ARRAY_SIZE(is2_mac_llc_keyfield),
+	[VCAP_KFS_MAC_SNAP] = ARRAY_SIZE(is2_mac_snap_keyfield),
+	[VCAP_KFS_ARP] = ARRAY_SIZE(is2_arp_keyfield),
+	[VCAP_KFS_IP4_TCP_UDP] = ARRAY_SIZE(is2_ip4_tcp_udp_keyfield),
+	[VCAP_KFS_IP4_OTHER] = ARRAY_SIZE(is2_ip4_other_keyfield),
+	[VCAP_KFS_IP6_STD] = ARRAY_SIZE(is2_ip6_std_keyfield),
+	[VCAP_KFS_OAM] = ARRAY_SIZE(is2_oam_keyfield),
+	[VCAP_KFS_IP6_TCP_UDP] = ARRAY_SIZE(is2_ip6_tcp_udp_keyfield),
+	[VCAP_KFS_IP6_OTHER] = ARRAY_SIZE(is2_ip6_other_keyfield),
+	[VCAP_KFS_SMAC_SIP4] = ARRAY_SIZE(is2_smac_sip4_keyfield),
+	[VCAP_KFS_SMAC_SIP6] = ARRAY_SIZE(is2_smac_sip6_keyfield),
+};
+
+/* actionfields */
+static const struct vcap_field is2_base_type_actionfield[] = {
+	[VCAP_AF_HIT_ME_ONCE] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 0,
+		.width = 1,
+	},
+	[VCAP_AF_CPU_COPY_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 1,
+		.width = 1,
+	},
+	[VCAP_AF_CPU_QUEUE_NUM] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 2,
+		.width = 3,
+	},
+	[VCAP_AF_MASK_MODE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 5,
+		.width = 2,
+	},
+	[VCAP_AF_MIRROR_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 7,
+		.width = 1,
+	},
+	[VCAP_AF_LRN_DIS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 8,
+		.width = 1,
+	},
+	[VCAP_AF_POLICE_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 9,
+		.width = 1,
+	},
+	[VCAP_AF_POLICE_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 10,
+		.width = 9,
+	},
+	[VCAP_AF_POLICE_VCAP_ONLY] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 19,
+		.width = 1,
+	},
+	[VCAP_AF_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 20,
+		.width = 8,
+	},
+	[VCAP_AF_REW_OP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 28,
+		.width = 16,
+	},
+	[VCAP_AF_ISDX_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 44,
+		.width = 1,
+	},
+	[VCAP_AF_ACL_ID] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 45,
+		.width = 6,
+	},
+};
+
+static const struct vcap_field is2_smac_sip_actionfield[] = {
+	[VCAP_AF_CPU_COPY_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 0,
+		.width = 1,
+	},
+	[VCAP_AF_CPU_QUEUE_NUM] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 1,
+		.width = 3,
+	},
+	[VCAP_AF_FWD_KILL_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 4,
+		.width = 1,
+	},
+	[VCAP_AF_HOST_MATCH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 5,
+		.width = 1,
+	},
+};
+
+/* actionfield_set */
+static const struct vcap_set is2_actionfield_set[] = {
+	[VCAP_AFS_BASE_TYPE] = {
+		.type_id = -1,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_AFS_SMAC_SIP] = {
+		.type_id = -1,
+		.sw_per_item = 1,
+		.sw_cnt = 4,
+	},
+};
+
+/* actionfield_set map */
+static const struct vcap_field *is2_actionfield_set_map[] = {
+	[VCAP_AFS_BASE_TYPE] = is2_base_type_actionfield,
+	[VCAP_AFS_SMAC_SIP] = is2_smac_sip_actionfield,
+};
+
+/* actionfield_set map size */
+static int is2_actionfield_set_map_size[] = {
+	[VCAP_AFS_BASE_TYPE] = ARRAY_SIZE(is2_base_type_actionfield),
+	[VCAP_AFS_SMAC_SIP] = ARRAY_SIZE(is2_smac_sip_actionfield),
+};
+
+/* Type Groups */
+static const struct vcap_typegroup is2_x4_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 3,
+		.value = 4,
+	},
+	{
+		.offset = 96,
+		.width = 1,
+		.value = 0,
+	},
+	{
+		.offset = 192,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 288,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup is2_x2_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 2,
+		.value = 2,
+	},
+	{
+		.offset = 96,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup is2_x1_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 1,
+		.value = 1,
+	},
+	{}
+};
+
+static const struct vcap_typegroup *is2_keyfield_set_typegroups[] = {
+	[4] = is2_x4_keyfield_set_typegroups,
+	[2] = is2_x2_keyfield_set_typegroups,
+	[1] = is2_x1_keyfield_set_typegroups,
+	[5] = NULL,
+};
+
+static const struct vcap_typegroup is2_x2_actionfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 2,
+		.value = 2,
+	},
+	{
+		.offset = 31,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup is2_x1_actionfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 1,
+		.value = 1,
+	},
+	{}
+};
+
+static const struct vcap_typegroup *is2_actionfield_set_typegroups[] = {
+	[2] = is2_x2_actionfield_set_typegroups,
+	[1] = is2_x1_actionfield_set_typegroups,
+	[5] = NULL,
+};
+
+/* Keyfieldset names */
+static const char * const vcap_keyfield_set_names[] = {
+	[VCAP_KFS_NO_VALUE]                      =  "(None)",
+	[VCAP_KFS_ARP]                           =  "VCAP_KFS_ARP",
+	[VCAP_KFS_IP4_OTHER]                     =  "VCAP_KFS_IP4_OTHER",
+	[VCAP_KFS_IP4_TCP_UDP]                   =  "VCAP_KFS_IP4_TCP_UDP",
+	[VCAP_KFS_IP6_OTHER]                     =  "VCAP_KFS_IP6_OTHER",
+	[VCAP_KFS_IP6_STD]                       =  "VCAP_KFS_IP6_STD",
+	[VCAP_KFS_IP6_TCP_UDP]                   =  "VCAP_KFS_IP6_TCP_UDP",
+	[VCAP_KFS_MAC_ETYPE]                     =  "VCAP_KFS_MAC_ETYPE",
+	[VCAP_KFS_MAC_LLC]                       =  "VCAP_KFS_MAC_LLC",
+	[VCAP_KFS_MAC_SNAP]                      =  "VCAP_KFS_MAC_SNAP",
+	[VCAP_KFS_OAM]                           =  "VCAP_KFS_OAM",
+	[VCAP_KFS_SMAC_SIP4]                     =  "VCAP_KFS_SMAC_SIP4",
+	[VCAP_KFS_SMAC_SIP6]                     =  "VCAP_KFS_SMAC_SIP6",
+};
+
+/* Actionfieldset names */
+static const char * const vcap_actionfield_set_names[] = {
+	[VCAP_AFS_NO_VALUE]                      =  "(None)",
+	[VCAP_AFS_BASE_TYPE]                     =  "VCAP_AFS_BASE_TYPE",
+	[VCAP_AFS_SMAC_SIP]                      =  "VCAP_AFS_SMAC_SIP",
+};
+
+/* Keyfield names */
+static const char * const vcap_keyfield_names[] = {
+	[VCAP_KF_NO_VALUE]                       =  "(None)",
+	[VCAP_KF_8021Q_DEI_CLS]                  =  "8021Q_DEI_CLS",
+	[VCAP_KF_8021Q_PCP_CLS]                  =  "8021Q_PCP_CLS",
+	[VCAP_KF_8021Q_VID_CLS]                  =  "8021Q_VID_CLS",
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS]           =  "8021Q_VLAN_TAGGED_IS",
+	[VCAP_KF_ARP_ADDR_SPACE_OK_IS]           =  "ARP_ADDR_SPACE_OK_IS",
+	[VCAP_KF_ARP_LEN_OK_IS]                  =  "ARP_LEN_OK_IS",
+	[VCAP_KF_ARP_OPCODE]                     =  "ARP_OPCODE",
+	[VCAP_KF_ARP_OPCODE_UNKNOWN_IS]          =  "ARP_OPCODE_UNKNOWN_IS",
+	[VCAP_KF_ARP_PROTO_SPACE_OK_IS]          =  "ARP_PROTO_SPACE_OK_IS",
+	[VCAP_KF_ARP_SENDER_MATCH_IS]            =  "ARP_SENDER_MATCH_IS",
+	[VCAP_KF_ARP_TGT_MATCH_IS]               =  "ARP_TGT_MATCH_IS",
+	[VCAP_KF_ETYPE]                          =  "ETYPE",
+	[VCAP_KF_HOST_MATCH]                     =  "HOST_MATCH",
+	[VCAP_KF_IF_IGR_PORT]                    =  "IF_IGR_PORT",
+	[VCAP_KF_IF_IGR_PORT_MASK]               =  "IF_IGR_PORT_MASK",
+	[VCAP_KF_IP4_IS]                         =  "IP4_IS",
+	[VCAP_KF_ISDX_GT0_IS]                    =  "ISDX_GT0_IS",
+	[VCAP_KF_L2_BC_IS]                       =  "L2_BC_IS",
+	[VCAP_KF_L2_DMAC]                        =  "L2_DMAC",
+	[VCAP_KF_L2_FRM_TYPE]                    =  "L2_FRM_TYPE",
+	[VCAP_KF_L2_LLC]                         =  "L2_LLC",
+	[VCAP_KF_L2_MC_IS]                       =  "L2_MC_IS",
+	[VCAP_KF_L2_PAYLOAD0]                    =  "L2_PAYLOAD0",
+	[VCAP_KF_L2_PAYLOAD1]                    =  "L2_PAYLOAD1",
+	[VCAP_KF_L2_PAYLOAD2]                    =  "L2_PAYLOAD2",
+	[VCAP_KF_L2_SMAC]                        =  "L2_SMAC",
+	[VCAP_KF_L2_SNAP]                        =  "L2_SNAP",
+	[VCAP_KF_L3_DIP_EQ_SIP_IS]               =  "L3_DIP_EQ_SIP_IS",
+	[VCAP_KF_L3_FRAGMENT]                    =  "L3_FRAGMENT",
+	[VCAP_KF_L3_FRAG_OFS_GT0]                =  "L3_FRAG_OFS_GT0",
+	[VCAP_KF_L3_IP4_DIP]                     =  "L3_IP4_DIP",
+	[VCAP_KF_L3_IP4_SIP]                     =  "L3_IP4_SIP",
+	[VCAP_KF_L3_IP6_DIP]                     =  "L3_IP6_DIP",
+	[VCAP_KF_L3_IP6_SIP]                     =  "L3_IP6_SIP",
+	[VCAP_KF_L3_IP_PROTO]                    =  "L3_IP_PROTO",
+	[VCAP_KF_L3_OPTIONS_IS]                  =  "L3_OPTIONS_IS",
+	[VCAP_KF_L3_PAYLOAD]                     =  "L3_PAYLOAD",
+	[VCAP_KF_L3_TOS]                         =  "L3_TOS",
+	[VCAP_KF_L3_TTL_GT0]                     =  "L3_TTL_GT0",
+	[VCAP_KF_L4_1588_DOM]                    =  "L4_1588_DOM",
+	[VCAP_KF_L4_1588_VER]                    =  "L4_1588_VER",
+	[VCAP_KF_L4_ACK]                         =  "L4_ACK",
+	[VCAP_KF_L4_DPORT]                       =  "L4_DPORT",
+	[VCAP_KF_L4_FIN]                         =  "L4_FIN",
+	[VCAP_KF_L4_PSH]                         =  "L4_PSH",
+	[VCAP_KF_L4_RNG]                         =  "L4_RNG",
+	[VCAP_KF_L4_RST]                         =  "L4_RST",
+	[VCAP_KF_L4_SEQUENCE_EQ0_IS]             =  "L4_SEQUENCE_EQ0_IS",
+	[VCAP_KF_L4_SPORT]                       =  "L4_SPORT",
+	[VCAP_KF_L4_SPORT_EQ_DPORT_IS]           =  "L4_SPORT_EQ_DPORT_IS",
+	[VCAP_KF_L4_SYN]                         =  "L4_SYN",
+	[VCAP_KF_L4_URG]                         =  "L4_URG",
+	[VCAP_KF_LOOKUP_FIRST_IS]                =  "LOOKUP_FIRST_IS",
+	[VCAP_KF_LOOKUP_PAG]                     =  "LOOKUP_PAG",
+	[VCAP_KF_OAM_CCM_CNTS_EQ0]               =  "OAM_CCM_CNTS_EQ0",
+	[VCAP_KF_OAM_DETECTED]                   =  "OAM_DETECTED",
+	[VCAP_KF_OAM_FLAGS]                      =  "OAM_FLAGS",
+	[VCAP_KF_OAM_MEL_FLAGS]                  =  "OAM_MEL_FLAGS",
+	[VCAP_KF_OAM_MEPID]                      =  "OAM_MEPID",
+	[VCAP_KF_OAM_OPCODE]                     =  "OAM_OPCODE",
+	[VCAP_KF_OAM_VER]                        =  "OAM_VER",
+	[VCAP_KF_OAM_Y1731_IS]                   =  "OAM_Y1731_IS",
+	[VCAP_KF_TCP_IS]                         =  "TCP_IS",
+	[VCAP_KF_TYPE]                           =  "TYPE",
+};
+
+/* Actionfield names */
+static const char * const vcap_actionfield_names[] = {
+	[VCAP_AF_NO_VALUE]                       =  "(None)",
+	[VCAP_AF_ACL_ID]                         =  "ACL_ID",
+	[VCAP_AF_CPU_COPY_ENA]                   =  "CPU_COPY_ENA",
+	[VCAP_AF_CPU_QUEUE_NUM]                  =  "CPU_QUEUE_NUM",
+	[VCAP_AF_FWD_KILL_ENA]                   =  "FWD_KILL_ENA",
+	[VCAP_AF_HIT_ME_ONCE]                    =  "HIT_ME_ONCE",
+	[VCAP_AF_HOST_MATCH]                     =  "HOST_MATCH",
+	[VCAP_AF_ISDX_ENA]                       =  "ISDX_ENA",
+	[VCAP_AF_LRN_DIS]                        =  "LRN_DIS",
+	[VCAP_AF_MASK_MODE]                      =  "MASK_MODE",
+	[VCAP_AF_MIRROR_ENA]                     =  "MIRROR_ENA",
+	[VCAP_AF_POLICE_ENA]                     =  "POLICE_ENA",
+	[VCAP_AF_POLICE_IDX]                     =  "POLICE_IDX",
+	[VCAP_AF_POLICE_VCAP_ONLY]               =  "POLICE_VCAP_ONLY",
+	[VCAP_AF_PORT_MASK]                      =  "PORT_MASK",
+	[VCAP_AF_REW_OP]                         =  "REW_OP",
+};
+
+/* VCAPs */
+const struct vcap_info lan966x_vcaps[] = {
+	[VCAP_TYPE_IS2] = {
+		.name = "is2",
+		.rows = 64,
+		.sw_count = 4,
+		.sw_width = 96,
+		.sticky_width = 32,
+		.act_width = 31,
+		.default_cnt = 11,
+		.require_cnt_dis = 1,
+		.version = 1,
+		.keyfield_set = is2_keyfield_set,
+		.keyfield_set_size = ARRAY_SIZE(is2_keyfield_set),
+		.actionfield_set = is2_actionfield_set,
+		.actionfield_set_size = ARRAY_SIZE(is2_actionfield_set),
+		.keyfield_set_map = is2_keyfield_set_map,
+		.keyfield_set_map_size = is2_keyfield_set_map_size,
+		.actionfield_set_map = is2_actionfield_set_map,
+		.actionfield_set_map_size = is2_actionfield_set_map_size,
+		.keyfield_set_typegroups = is2_keyfield_set_typegroups,
+		.actionfield_set_typegroups = is2_actionfield_set_typegroups,
+	},
+};
+
+const struct vcap_statistics lan966x_vcap_stats = {
+	.name = "lan966x",
+	.count = 1,
+	.keyfield_set_names = vcap_keyfield_set_names,
+	.actionfield_set_names = vcap_actionfield_set_names,
+	.keyfield_names = vcap_keyfield_names,
+	.actionfield_names = vcap_actionfield_names,
+};
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.h b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.h
new file mode 100644
index 0000000000000..0d8bbee73b2a5
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+
+#ifndef __LAN966X_VCAP_AG_API_H__
+#define __LAN966X_VCAP_AG_API_H__
+
+#include "vcap_api.h"
+
+extern const struct vcap_info lan966x_vcaps[];
+extern const struct vcap_statistics lan966x_vcap_stats;
+
+#endif /* __LAN966X_VCAP_AG_API_H__ */
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index 8d89cfcb8502d..aac821cd611e8 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 
 #include "lan966x_main.h"
+#include "lan966x_vcap_ag_api.h"
 #include "vcap_api.h"
 
 int lan966x_vcap_init(struct lan966x *lan966x)
@@ -11,6 +12,9 @@ int lan966x_vcap_init(struct lan966x *lan966x)
 	if (!ctrl)
 		return -ENOMEM;
 
+	ctrl->vcaps = lan966x_vcaps;
+	ctrl->stats = &lan966x_vcap_stats;
+
 	lan966x->vcap_ctrl = ctrl;
 
 	return 0;
-- 
2.38.0

