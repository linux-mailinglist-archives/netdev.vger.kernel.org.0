Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB262E0B0F
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgLVNp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:45:56 -0500
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:35431
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727042AbgLVNpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:45:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTDIH+2Q1WWIP2XYNWnRwntqDPqwMGFdWJCsND21WZ0pBI+OCWNnfXoFyLx79SUWeawiM85tGRJeoXlunUykuw2tcpl5jtYJj7ohkLM8gmUDK7xr2Y6giwQH2ARYSnAkAH86kt7ONerS0YJfUtCXXiSvfDtv6bJ8WoIeUzJ/5YjBiC3yUPxl6syMrjOzBym1VWKCgiOzrlTzop1+iJcbcINv5EOKwXWI9e6SPqmkeEgP3t4L9TiNvoUquH2qnbRLg6/Z5Rw2vLe5QsjjU5ru/E2Ssh+G+0hu/hj/8N+RuLbriUuYsQ0FwCD2jeBHr3ZMnWaPA3yl7sQ5Wtnw/PLtZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YPtU+Lf+lRRhhh9KfaJIz+I+FANMlJuG1a7bZo3nYo=;
 b=Dpp43+106DpgFKAoAIHXsvX+Eri1QoL1FW+Xzk1evYbCqF5EB2zi1OcacPESqqGNxYuKzpDSgvOinkqo1EZxSKCpyIPCU8Vb++9xP+oU4YPy5KJWUNO9GJQlVDaIQfuQAgtbU2er7nQD69znb07gJD2bSRhizbOcyxJ9PNftbdan324xYrxtTYJreu2DJkgz4v+Y8Ms9WRMTyaiswSD7azsaB8mtSk29jHWbYXoz5d+niTbFm0qXIflPUs+d9U18mNuOt2cqV0LfrfPGybAzvxzChF3bqerSLCEbTXsnqa0xG/QXmJR/CukEzI4KWdmaL3k2SXTa9ca+WdNb7gMxGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YPtU+Lf+lRRhhh9KfaJIz+I+FANMlJuG1a7bZo3nYo=;
 b=rSPhBqsBlijxCDIWACBi0rIYeYSWWshex/pq/jIhWvcsy7fH9IVa2eKjCGOowoU6UAuC6uTllhCyp+LrQmyEj+Rr3xSxaJLj566Eldjr5z8T2zY2lZyMG0frKC/wocj+v+gNp9mD6FHeIrZN+Ur4itxBGVj0ounoDOHFpUNn3s4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:44:55 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:44:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 02/15] net: mscc: ocelot: export VCAP structures to include/soc/mscc
Date:   Tue, 22 Dec 2020 15:44:26 +0200
Message-Id: <20201222134439.2478449-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:44:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ed7e59c-3d1a-4320-ed5a-08d8a67fc415
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7408C437CE34F9D5BBAFFECBE0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pFo50mveQiRbqlKfbwUTvJo/VGt7qXU0W+IDXTfVLVA9vYx6llvOOcy4uI3coIHfQdMllVUUKmL6WX9+ZYIPPBO9xzFralRUE0Th9qM6t6DJ7I/mhUgWT2y3+pB5ngkDf2GsuydhEn5kENo1d7DnsU+Bnuyba3qJzIoemyInt79YMPFeb6iGOTbjIViudmSxJd9cF/uNvMcBFTqhxJ2Xk2m6G7WhuUk5j0xJ3tOcLeg/o/i5bnze034AnEvzq9TQeBF/gHL5ZCREEc4enhjIjobjRd0a5LL7bv1FDDksl/L05mnPODytuDnymeqYQ0dVku2sfR1YEBJhRDQt//OKOgVP+ZOTycQnpmkypZeat5zjz7zfl9J+JOVi2lcJwDtCCtkwN/qSq1gOCCs6EFDZpS3zJhLq1hHwd2JeStqP+Nsz9ix2I/8q7wYmB9n0l+wk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(30864003)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x8OBZ3LoHSOeFsAW1bOZZk/UOYUvHTnqQoVNyHUKAzGZ5Ad1GvcXmUyymvnI?=
 =?us-ascii?Q?bgI+x4RGSpLOZ54N9TyejU0TuC8YOt4LB4lBpglgtWlSG9A5QMovu7zbPwrE?=
 =?us-ascii?Q?vMkKS0HoTS3V+H+SLRTJ19pBrqqqh6eS3MizhZdaQ4FFVzZem8t+lQkHw1nv?=
 =?us-ascii?Q?ZgruzuLJUwKU43VnqOpMjVomcm1Dwd30jL4E3kTpZmJd/7kxQK3TibLeb0s1?=
 =?us-ascii?Q?wX8ha7C8dIA6GnaGkBDmftKUGwOWVChE5xAK8aiXW7cvMenRZriNtB5r+/G1?=
 =?us-ascii?Q?UxTeAteiOJj9I/al/x2yqqiloKDAzGCss7vMbGgdSIYnGaWRaqAF7CqQrDY7?=
 =?us-ascii?Q?eznGM+3aupHDgDxNCZ5mNYbGZsJB+8o6W4i0ecwNGqOpE9Y8p7eOJgJA/57X?=
 =?us-ascii?Q?3Rd7j2wmrcPebqPFLcRzueykyFOIrXnk8pBhHcIFDvncnYiNzVGolfF17roU?=
 =?us-ascii?Q?Yo5E42ZD5OeYy3mRTcSftUV/qu8iCw7xttnPw4LRe25xSNWeySesmBIQstAB?=
 =?us-ascii?Q?cdxXRUyoFWkyJV3fAFrrCNK86Kpt16pMC2/T7lAmUx72OOdA91SD74tWF6fE?=
 =?us-ascii?Q?pyjbKyqO0S2k+YElhvHTCWFl837BL4nya6VNPfL4S4poEKUdbb5f3xJqMSrf?=
 =?us-ascii?Q?etWLVc2cbF7w06+zoh0dF7gDI+m/nCk3uM5IKIyDCVQE2NMcN4wSX54L8zwM?=
 =?us-ascii?Q?6Vk33DcevB9SEJQmgaPaYn2QRxX6T6tVxhnCJrPqhZ9eO5lyokiBuMC2G95s?=
 =?us-ascii?Q?K5De1RjqUuVrG9MZKC2UIolI2MwK0d1QSFnz03kMGERvrLOil80KVOgiyN8c?=
 =?us-ascii?Q?Ql75Vesse1B64J+3NSXfiXLg5nys3w2VQkIY6pyv6Nr7GZWI2VP3g/uFEdiJ?=
 =?us-ascii?Q?5QfChjQcKt9mzG1yRFwUT1fRvb+WndNz4wd79vsCORau5nZjLLaEFYNBe3FZ?=
 =?us-ascii?Q?WohriwM/EUwWmMIGnDZnEgSusbW5/tmJcNx1VUdcmVP4MuYqKsmAXYwAD4nZ?=
 =?us-ascii?Q?Rze5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:44:55.1515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed7e59c-3d1a-4320-ed5a-08d8a67fc415
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sKXxdCeIcSoCJEjhz3D42L/6wZ9TpMe+/NxWTCv1K7Z/SYq5JurupUsnFLj9eI0F30D5SRB7zX830XET6TleAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix driver will need to preinstall some VCAP filters for its
tag_8021q implementation (outside of the tc-flower offload logic), so
these need to be exported to the common includes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_net.c  |   1 +
 drivers/net/ethernet/mscc/ocelot_vcap.h | 293 +-----------------------
 include/soc/mscc/ocelot_vcap.h          | 289 +++++++++++++++++++++++
 3 files changed, 292 insertions(+), 291 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 2bd2840d88bd..3a3bbd5e7883 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -5,6 +5,7 @@
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

