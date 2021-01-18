Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF2A2FA60F
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406555AbhARQZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406156AbhARQSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:18:25 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD786C061575
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:44 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p22so18183859edu.11
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SkvQla0TbKqP2tY1iWVi/jInNWE/GbsMGUlA1qh2WZY=;
        b=bu7OcEKBRDtjrRQHWxjnzgv1lVWOkpId0ZRV1if87goeMEmpstoB7V3FBz++FyL6nL
         lR58feLdY/nuCom8yBSjvW+CDyvbybH5/ehn1p47x4Lqc12ik2SVX4CXOZ/Zd9VKLBXU
         UxbpO7e9k3Y8VjHRK9ekb6gAEVBup/U8p3zwFjbIk55ZNpcHEQ98xa9LOQFssaIQox/R
         iFbT6P6piPhrj0sHZHBIg+29eHcF/QNkJVu7Y32Xnd+tj8mFr6PqXbtS51ajIYxe4SGb
         CzLl4ElqLSMGnkO3ahpYwUDQ4yhYTP3AeeyXMGsiuf1iPn4jUz1acAZcg+kvnXJCtoB/
         TLCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SkvQla0TbKqP2tY1iWVi/jInNWE/GbsMGUlA1qh2WZY=;
        b=l1ZVuYGNvaL8tNdPuO2uSjWmFiW2SS2LIz+z/OYZOjFFEKUPEtePmmHvYQVvLE4B+i
         1KK2Yhm0lW1ciH8KpTVrC7LX/8Wyx4bVQOqtPH+OQ/VR4PlMA72yLuLY1QMbm/9hhzWw
         Nelx+I7WaydNyGX2WBM8BpTvOm87TuTGFM8GCGYFy1NT4aBkazNW8RCOVy7+WyU8i9Ka
         qP0lMXn7F6C7x+ceUrcxnWism4+FrQPoS/U+Infk3qfLOCLKLzhuzOxX6TR9mhw4e7Oj
         yk3DVd+L1VxrshGLnsAbNUNVDXsH2AdUH5FNcNDMVEiKWUwVhb54cBW6M+LXXVWlVCBM
         vsKQ==
X-Gm-Message-State: AOAM530nc0gVkjBWDpza0pJWmHrZVxlELLXlQd8b+MjtBHb08O9uVuGM
        ZZPWDq+aobdSSQ2SLzVFklQ=
X-Google-Smtp-Source: ABdhPJw1tfSf7gKdnN6iePybbxsItLTiuShkQcVnccb/ymEC56wKeHnO3Yf+pZGQhnhwfjY4nstOtA==
X-Received: by 2002:a50:c3c5:: with SMTP id i5mr194979edf.166.1610986663531;
        Mon, 18 Jan 2021 08:17:43 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:43 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 02/15] net: mscc: ocelot: export VCAP structures to include/soc/mscc
Date:   Mon, 18 Jan 2021 18:17:18 +0200
Message-Id: <20210118161731.2837700-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Felix driver will need to preinstall some VCAP filters for its
tag_8021q implementation (outside of the tc-flower offload logic), so
these need to be exported to the common includes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_net.c  |   1 +
 drivers/net/ethernet/mscc/ocelot_vcap.h | 293 +-----------------------
 include/soc/mscc/ocelot_vcap.h          | 289 +++++++++++++++++++++++
 3 files changed, 292 insertions(+), 291 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 4585c35c24e5..9535a75b1c84 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/if_bridge.h>
+#include <net/pkt_cls.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index 82fd10581a14..cfc8b976d1de 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -7,300 +7,11 @@
 #define _MSCC_OCELOT_VCAP_H_
 
 #include "ocelot.h"
-#include "ocelot_police.h"
-#include <net/sch_generic.h>
-#include <net/pkt_cls.h>
+#include <soc/mscc/ocelot_vcap.h>
+#include <net/flow_offload.h>
 
 #define OCELOT_POLICER_DISCARD 0x17f
 
-struct ocelot_ipv4 {
-	u8 addr[4];
-};
-
-enum ocelot_vcap_bit {
-	OCELOT_VCAP_BIT_ANY,
-	OCELOT_VCAP_BIT_0,
-	OCELOT_VCAP_BIT_1
-};
-
-struct ocelot_vcap_u8 {
-	u8 value[1];
-	u8 mask[1];
-};
-
-struct ocelot_vcap_u16 {
-	u8 value[2];
-	u8 mask[2];
-};
-
-struct ocelot_vcap_u24 {
-	u8 value[3];
-	u8 mask[3];
-};
-
-struct ocelot_vcap_u32 {
-	u8 value[4];
-	u8 mask[4];
-};
-
-struct ocelot_vcap_u40 {
-	u8 value[5];
-	u8 mask[5];
-};
-
-struct ocelot_vcap_u48 {
-	u8 value[6];
-	u8 mask[6];
-};
-
-struct ocelot_vcap_u64 {
-	u8 value[8];
-	u8 mask[8];
-};
-
-struct ocelot_vcap_u128 {
-	u8 value[16];
-	u8 mask[16];
-};
-
-struct ocelot_vcap_vid {
-	u16 value;
-	u16 mask;
-};
-
-struct ocelot_vcap_ipv4 {
-	struct ocelot_ipv4 value;
-	struct ocelot_ipv4 mask;
-};
-
-struct ocelot_vcap_udp_tcp {
-	u16 value;
-	u16 mask;
-};
-
-struct ocelot_vcap_port {
-	u8 value;
-	u8 mask;
-};
-
-enum ocelot_vcap_key_type {
-	OCELOT_VCAP_KEY_ANY,
-	OCELOT_VCAP_KEY_ETYPE,
-	OCELOT_VCAP_KEY_LLC,
-	OCELOT_VCAP_KEY_SNAP,
-	OCELOT_VCAP_KEY_ARP,
-	OCELOT_VCAP_KEY_IPV4,
-	OCELOT_VCAP_KEY_IPV6
-};
-
-struct ocelot_vcap_key_vlan {
-	struct ocelot_vcap_vid vid;    /* VLAN ID (12 bit) */
-	struct ocelot_vcap_u8  pcp;    /* PCP (3 bit) */
-	enum ocelot_vcap_bit dei;    /* DEI */
-	enum ocelot_vcap_bit tagged; /* Tagged/untagged frame */
-};
-
-struct ocelot_vcap_key_etype {
-	struct ocelot_vcap_u48 dmac;
-	struct ocelot_vcap_u48 smac;
-	struct ocelot_vcap_u16 etype;
-	struct ocelot_vcap_u16 data; /* MAC data */
-};
-
-struct ocelot_vcap_key_llc {
-	struct ocelot_vcap_u48 dmac;
-	struct ocelot_vcap_u48 smac;
-
-	/* LLC header: DSAP at byte 0, SSAP at byte 1, Control at byte 2 */
-	struct ocelot_vcap_u32 llc;
-};
-
-struct ocelot_vcap_key_snap {
-	struct ocelot_vcap_u48 dmac;
-	struct ocelot_vcap_u48 smac;
-
-	/* SNAP header: Organization Code at byte 0, Type at byte 3 */
-	struct ocelot_vcap_u40 snap;
-};
-
-struct ocelot_vcap_key_arp {
-	struct ocelot_vcap_u48 smac;
-	enum ocelot_vcap_bit arp;	/* Opcode ARP/RARP */
-	enum ocelot_vcap_bit req;	/* Opcode request/reply */
-	enum ocelot_vcap_bit unknown;    /* Opcode unknown */
-	enum ocelot_vcap_bit smac_match; /* Sender MAC matches SMAC */
-	enum ocelot_vcap_bit dmac_match; /* Target MAC matches DMAC */
-
-	/**< Protocol addr. length 4, hardware length 6 */
-	enum ocelot_vcap_bit length;
-
-	enum ocelot_vcap_bit ip;       /* Protocol address type IP */
-	enum  ocelot_vcap_bit ethernet; /* Hardware address type Ethernet */
-	struct ocelot_vcap_ipv4 sip;     /* Sender IP address */
-	struct ocelot_vcap_ipv4 dip;     /* Target IP address */
-};
-
-struct ocelot_vcap_key_ipv4 {
-	enum ocelot_vcap_bit ttl;      /* TTL zero */
-	enum ocelot_vcap_bit fragment; /* Fragment */
-	enum ocelot_vcap_bit options;  /* Header options */
-	struct ocelot_vcap_u8 ds;
-	struct ocelot_vcap_u8 proto;      /* Protocol */
-	struct ocelot_vcap_ipv4 sip;      /* Source IP address */
-	struct ocelot_vcap_ipv4 dip;      /* Destination IP address */
-	struct ocelot_vcap_u48 data;      /* Not UDP/TCP: IP data */
-	struct ocelot_vcap_udp_tcp sport; /* UDP/TCP: Source port */
-	struct ocelot_vcap_udp_tcp dport; /* UDP/TCP: Destination port */
-	enum ocelot_vcap_bit tcp_fin;
-	enum ocelot_vcap_bit tcp_syn;
-	enum ocelot_vcap_bit tcp_rst;
-	enum ocelot_vcap_bit tcp_psh;
-	enum ocelot_vcap_bit tcp_ack;
-	enum ocelot_vcap_bit tcp_urg;
-	enum ocelot_vcap_bit sip_eq_dip;     /* SIP equals DIP  */
-	enum ocelot_vcap_bit sport_eq_dport; /* SPORT equals DPORT  */
-	enum ocelot_vcap_bit seq_zero;       /* TCP sequence number is zero */
-};
-
-struct ocelot_vcap_key_ipv6 {
-	struct ocelot_vcap_u8 proto; /* IPv6 protocol */
-	struct ocelot_vcap_u128 sip; /* IPv6 source (byte 0-7 ignored) */
-	struct ocelot_vcap_u128 dip; /* IPv6 destination (byte 0-7 ignored) */
-	enum ocelot_vcap_bit ttl;  /* TTL zero */
-	struct ocelot_vcap_u8 ds;
-	struct ocelot_vcap_u48 data; /* Not UDP/TCP: IP data */
-	struct ocelot_vcap_udp_tcp sport;
-	struct ocelot_vcap_udp_tcp dport;
-	enum ocelot_vcap_bit tcp_fin;
-	enum ocelot_vcap_bit tcp_syn;
-	enum ocelot_vcap_bit tcp_rst;
-	enum ocelot_vcap_bit tcp_psh;
-	enum ocelot_vcap_bit tcp_ack;
-	enum ocelot_vcap_bit tcp_urg;
-	enum ocelot_vcap_bit sip_eq_dip;     /* SIP equals DIP  */
-	enum ocelot_vcap_bit sport_eq_dport; /* SPORT equals DPORT  */
-	enum ocelot_vcap_bit seq_zero;       /* TCP sequence number is zero */
-};
-
-enum ocelot_mask_mode {
-	OCELOT_MASK_MODE_NONE,
-	OCELOT_MASK_MODE_PERMIT_DENY,
-	OCELOT_MASK_MODE_POLICY,
-	OCELOT_MASK_MODE_REDIRECT,
-};
-
-enum ocelot_es0_tag {
-	OCELOT_NO_ES0_TAG,
-	OCELOT_ES0_TAG,
-	OCELOT_FORCE_PORT_TAG,
-	OCELOT_FORCE_UNTAG,
-};
-
-enum ocelot_tag_tpid_sel {
-	OCELOT_TAG_TPID_SEL_8021Q,
-	OCELOT_TAG_TPID_SEL_8021AD,
-};
-
-struct ocelot_vcap_action {
-	union {
-		/* VCAP ES0 */
-		struct {
-			enum ocelot_es0_tag push_outer_tag;
-			enum ocelot_es0_tag push_inner_tag;
-			enum ocelot_tag_tpid_sel tag_a_tpid_sel;
-			int tag_a_vid_sel;
-			int tag_a_pcp_sel;
-			u16 vid_a_val;
-			u8 pcp_a_val;
-			u8 dei_a_val;
-			enum ocelot_tag_tpid_sel tag_b_tpid_sel;
-			int tag_b_vid_sel;
-			int tag_b_pcp_sel;
-			u16 vid_b_val;
-			u8 pcp_b_val;
-			u8 dei_b_val;
-		};
-
-		/* VCAP IS1 */
-		struct {
-			bool vid_replace_ena;
-			u16 vid;
-			bool vlan_pop_cnt_ena;
-			int vlan_pop_cnt;
-			bool pcp_dei_ena;
-			u8 pcp;
-			u8 dei;
-			bool qos_ena;
-			u8 qos_val;
-			u8 pag_override_mask;
-			u8 pag_val;
-		};
-
-		/* VCAP IS2 */
-		struct {
-			bool cpu_copy_ena;
-			u8 cpu_qu_num;
-			enum ocelot_mask_mode mask_mode;
-			unsigned long port_mask;
-			bool police_ena;
-			struct ocelot_policer pol;
-			u32 pol_ix;
-		};
-	};
-};
-
-struct ocelot_vcap_stats {
-	u64 bytes;
-	u64 pkts;
-	u64 used;
-};
-
-enum ocelot_vcap_filter_type {
-	OCELOT_VCAP_FILTER_DUMMY,
-	OCELOT_VCAP_FILTER_PAG,
-	OCELOT_VCAP_FILTER_OFFLOAD,
-};
-
-struct ocelot_vcap_filter {
-	struct list_head list;
-
-	enum ocelot_vcap_filter_type type;
-	int block_id;
-	int goto_target;
-	int lookup;
-	u8 pag;
-	u16 prio;
-	u32 id;
-
-	struct ocelot_vcap_action action;
-	struct ocelot_vcap_stats stats;
-	/* For VCAP IS1 and IS2 */
-	unsigned long ingress_port_mask;
-	/* For VCAP ES0 */
-	struct ocelot_vcap_port ingress_port;
-	struct ocelot_vcap_port egress_port;
-
-	enum ocelot_vcap_bit dmac_mc;
-	enum ocelot_vcap_bit dmac_bc;
-	struct ocelot_vcap_key_vlan vlan;
-
-	enum ocelot_vcap_key_type key_type;
-	union {
-		/* OCELOT_VCAP_KEY_ANY: No specific fields */
-		struct ocelot_vcap_key_etype etype;
-		struct ocelot_vcap_key_llc llc;
-		struct ocelot_vcap_key_snap snap;
-		struct ocelot_vcap_key_arp arp;
-		struct ocelot_vcap_key_ipv4 ipv4;
-		struct ocelot_vcap_key_ipv6 ipv6;
-	} key;
-};
-
-int ocelot_vcap_filter_add(struct ocelot *ocelot,
-			   struct ocelot_vcap_filter *rule,
-			   struct netlink_ext_ack *extack);
-int ocelot_vcap_filter_del(struct ocelot *ocelot,
-			   struct ocelot_vcap_filter *rule);
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *rule);
 struct ocelot_vcap_filter *
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 96300adf3648..7f1b82fba63c 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -400,4 +400,293 @@ enum vcap_es0_action_field {
 	VCAP_ES0_ACT_HIT_STICKY,
 };
 
+struct ocelot_ipv4 {
+	u8 addr[4];
+};
+
+enum ocelot_vcap_bit {
+	OCELOT_VCAP_BIT_ANY,
+	OCELOT_VCAP_BIT_0,
+	OCELOT_VCAP_BIT_1
+};
+
+struct ocelot_vcap_u8 {
+	u8 value[1];
+	u8 mask[1];
+};
+
+struct ocelot_vcap_u16 {
+	u8 value[2];
+	u8 mask[2];
+};
+
+struct ocelot_vcap_u24 {
+	u8 value[3];
+	u8 mask[3];
+};
+
+struct ocelot_vcap_u32 {
+	u8 value[4];
+	u8 mask[4];
+};
+
+struct ocelot_vcap_u40 {
+	u8 value[5];
+	u8 mask[5];
+};
+
+struct ocelot_vcap_u48 {
+	u8 value[6];
+	u8 mask[6];
+};
+
+struct ocelot_vcap_u64 {
+	u8 value[8];
+	u8 mask[8];
+};
+
+struct ocelot_vcap_u128 {
+	u8 value[16];
+	u8 mask[16];
+};
+
+struct ocelot_vcap_vid {
+	u16 value;
+	u16 mask;
+};
+
+struct ocelot_vcap_ipv4 {
+	struct ocelot_ipv4 value;
+	struct ocelot_ipv4 mask;
+};
+
+struct ocelot_vcap_udp_tcp {
+	u16 value;
+	u16 mask;
+};
+
+struct ocelot_vcap_port {
+	u8 value;
+	u8 mask;
+};
+
+enum ocelot_vcap_key_type {
+	OCELOT_VCAP_KEY_ANY,
+	OCELOT_VCAP_KEY_ETYPE,
+	OCELOT_VCAP_KEY_LLC,
+	OCELOT_VCAP_KEY_SNAP,
+	OCELOT_VCAP_KEY_ARP,
+	OCELOT_VCAP_KEY_IPV4,
+	OCELOT_VCAP_KEY_IPV6
+};
+
+struct ocelot_vcap_key_vlan {
+	struct ocelot_vcap_vid vid;    /* VLAN ID (12 bit) */
+	struct ocelot_vcap_u8  pcp;    /* PCP (3 bit) */
+	enum ocelot_vcap_bit dei;    /* DEI */
+	enum ocelot_vcap_bit tagged; /* Tagged/untagged frame */
+};
+
+struct ocelot_vcap_key_etype {
+	struct ocelot_vcap_u48 dmac;
+	struct ocelot_vcap_u48 smac;
+	struct ocelot_vcap_u16 etype;
+	struct ocelot_vcap_u16 data; /* MAC data */
+};
+
+struct ocelot_vcap_key_llc {
+	struct ocelot_vcap_u48 dmac;
+	struct ocelot_vcap_u48 smac;
+
+	/* LLC header: DSAP at byte 0, SSAP at byte 1, Control at byte 2 */
+	struct ocelot_vcap_u32 llc;
+};
+
+struct ocelot_vcap_key_snap {
+	struct ocelot_vcap_u48 dmac;
+	struct ocelot_vcap_u48 smac;
+
+	/* SNAP header: Organization Code at byte 0, Type at byte 3 */
+	struct ocelot_vcap_u40 snap;
+};
+
+struct ocelot_vcap_key_arp {
+	struct ocelot_vcap_u48 smac;
+	enum ocelot_vcap_bit arp;	/* Opcode ARP/RARP */
+	enum ocelot_vcap_bit req;	/* Opcode request/reply */
+	enum ocelot_vcap_bit unknown;    /* Opcode unknown */
+	enum ocelot_vcap_bit smac_match; /* Sender MAC matches SMAC */
+	enum ocelot_vcap_bit dmac_match; /* Target MAC matches DMAC */
+
+	/**< Protocol addr. length 4, hardware length 6 */
+	enum ocelot_vcap_bit length;
+
+	enum ocelot_vcap_bit ip;       /* Protocol address type IP */
+	enum  ocelot_vcap_bit ethernet; /* Hardware address type Ethernet */
+	struct ocelot_vcap_ipv4 sip;     /* Sender IP address */
+	struct ocelot_vcap_ipv4 dip;     /* Target IP address */
+};
+
+struct ocelot_vcap_key_ipv4 {
+	enum ocelot_vcap_bit ttl;      /* TTL zero */
+	enum ocelot_vcap_bit fragment; /* Fragment */
+	enum ocelot_vcap_bit options;  /* Header options */
+	struct ocelot_vcap_u8 ds;
+	struct ocelot_vcap_u8 proto;      /* Protocol */
+	struct ocelot_vcap_ipv4 sip;      /* Source IP address */
+	struct ocelot_vcap_ipv4 dip;      /* Destination IP address */
+	struct ocelot_vcap_u48 data;      /* Not UDP/TCP: IP data */
+	struct ocelot_vcap_udp_tcp sport; /* UDP/TCP: Source port */
+	struct ocelot_vcap_udp_tcp dport; /* UDP/TCP: Destination port */
+	enum ocelot_vcap_bit tcp_fin;
+	enum ocelot_vcap_bit tcp_syn;
+	enum ocelot_vcap_bit tcp_rst;
+	enum ocelot_vcap_bit tcp_psh;
+	enum ocelot_vcap_bit tcp_ack;
+	enum ocelot_vcap_bit tcp_urg;
+	enum ocelot_vcap_bit sip_eq_dip;     /* SIP equals DIP  */
+	enum ocelot_vcap_bit sport_eq_dport; /* SPORT equals DPORT  */
+	enum ocelot_vcap_bit seq_zero;       /* TCP sequence number is zero */
+};
+
+struct ocelot_vcap_key_ipv6 {
+	struct ocelot_vcap_u8 proto; /* IPv6 protocol */
+	struct ocelot_vcap_u128 sip; /* IPv6 source (byte 0-7 ignored) */
+	struct ocelot_vcap_u128 dip; /* IPv6 destination (byte 0-7 ignored) */
+	enum ocelot_vcap_bit ttl;  /* TTL zero */
+	struct ocelot_vcap_u8 ds;
+	struct ocelot_vcap_u48 data; /* Not UDP/TCP: IP data */
+	struct ocelot_vcap_udp_tcp sport;
+	struct ocelot_vcap_udp_tcp dport;
+	enum ocelot_vcap_bit tcp_fin;
+	enum ocelot_vcap_bit tcp_syn;
+	enum ocelot_vcap_bit tcp_rst;
+	enum ocelot_vcap_bit tcp_psh;
+	enum ocelot_vcap_bit tcp_ack;
+	enum ocelot_vcap_bit tcp_urg;
+	enum ocelot_vcap_bit sip_eq_dip;     /* SIP equals DIP  */
+	enum ocelot_vcap_bit sport_eq_dport; /* SPORT equals DPORT  */
+	enum ocelot_vcap_bit seq_zero;       /* TCP sequence number is zero */
+};
+
+enum ocelot_mask_mode {
+	OCELOT_MASK_MODE_NONE,
+	OCELOT_MASK_MODE_PERMIT_DENY,
+	OCELOT_MASK_MODE_POLICY,
+	OCELOT_MASK_MODE_REDIRECT,
+};
+
+enum ocelot_es0_tag {
+	OCELOT_NO_ES0_TAG,
+	OCELOT_ES0_TAG,
+	OCELOT_FORCE_PORT_TAG,
+	OCELOT_FORCE_UNTAG,
+};
+
+enum ocelot_tag_tpid_sel {
+	OCELOT_TAG_TPID_SEL_8021Q,
+	OCELOT_TAG_TPID_SEL_8021AD,
+};
+
+struct ocelot_vcap_action {
+	union {
+		/* VCAP ES0 */
+		struct {
+			enum ocelot_es0_tag push_outer_tag;
+			enum ocelot_es0_tag push_inner_tag;
+			enum ocelot_tag_tpid_sel tag_a_tpid_sel;
+			int tag_a_vid_sel;
+			int tag_a_pcp_sel;
+			u16 vid_a_val;
+			u8 pcp_a_val;
+			u8 dei_a_val;
+			enum ocelot_tag_tpid_sel tag_b_tpid_sel;
+			int tag_b_vid_sel;
+			int tag_b_pcp_sel;
+			u16 vid_b_val;
+			u8 pcp_b_val;
+			u8 dei_b_val;
+		};
+
+		/* VCAP IS1 */
+		struct {
+			bool vid_replace_ena;
+			u16 vid;
+			bool vlan_pop_cnt_ena;
+			int vlan_pop_cnt;
+			bool pcp_dei_ena;
+			u8 pcp;
+			u8 dei;
+			bool qos_ena;
+			u8 qos_val;
+			u8 pag_override_mask;
+			u8 pag_val;
+		};
+
+		/* VCAP IS2 */
+		struct {
+			bool cpu_copy_ena;
+			u8 cpu_qu_num;
+			enum ocelot_mask_mode mask_mode;
+			unsigned long port_mask;
+			bool police_ena;
+			struct ocelot_policer pol;
+			u32 pol_ix;
+		};
+	};
+};
+
+struct ocelot_vcap_stats {
+	u64 bytes;
+	u64 pkts;
+	u64 used;
+};
+
+enum ocelot_vcap_filter_type {
+	OCELOT_VCAP_FILTER_DUMMY,
+	OCELOT_VCAP_FILTER_PAG,
+	OCELOT_VCAP_FILTER_OFFLOAD,
+};
+
+struct ocelot_vcap_filter {
+	struct list_head list;
+
+	enum ocelot_vcap_filter_type type;
+	int block_id;
+	int goto_target;
+	int lookup;
+	u8 pag;
+	u16 prio;
+	u32 id;
+
+	struct ocelot_vcap_action action;
+	struct ocelot_vcap_stats stats;
+	/* For VCAP IS1 and IS2 */
+	unsigned long ingress_port_mask;
+	/* For VCAP ES0 */
+	struct ocelot_vcap_port ingress_port;
+	struct ocelot_vcap_port egress_port;
+
+	enum ocelot_vcap_bit dmac_mc;
+	enum ocelot_vcap_bit dmac_bc;
+	struct ocelot_vcap_key_vlan vlan;
+
+	enum ocelot_vcap_key_type key_type;
+	union {
+		/* OCELOT_VCAP_KEY_ANY: No specific fields */
+		struct ocelot_vcap_key_etype etype;
+		struct ocelot_vcap_key_llc llc;
+		struct ocelot_vcap_key_snap snap;
+		struct ocelot_vcap_key_arp arp;
+		struct ocelot_vcap_key_ipv4 ipv4;
+		struct ocelot_vcap_key_ipv6 ipv6;
+	} key;
+};
+
+int ocelot_vcap_filter_add(struct ocelot *ocelot,
+			   struct ocelot_vcap_filter *rule,
+			   struct netlink_ext_ack *extack);
+int ocelot_vcap_filter_del(struct ocelot *ocelot,
+			   struct ocelot_vcap_filter *rule);
+
 #endif /* _OCELOT_VCAP_H_ */
-- 
2.25.1

