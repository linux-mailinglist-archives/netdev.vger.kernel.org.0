Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB1F3B9B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfKGWl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:41:57 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24292 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727718AbfKGWl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:41:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7Mdlck021307;
        Thu, 7 Nov 2019 14:41:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=oUOYg005Ddg9IlWO2U6H9/e+2Y+rX5wxOPYb/ykxuNE=;
 b=Ptu2NOEtisNe8BKCDqwr6SIdmK8zmOJO55VEWP19TlBezJoCrLJkD7gR9/xBSgTKa2uF
 Df6mRSTDxgbA22OoHYr38E1ccZ5pe2Fb44KsKknvg9TcFwf2zmJGpu+YPIzKnYtdtfkI
 F9dvkes0AcKuvEo4M5H/WOzpnltLh2ackgQ/xUf0EvjDvkX44WGafBJF7tiVMQTo30wR
 Vsjhr3RNUgEfdAPC2TQgecsNeDUVnB3yXT8PNYy2Vbq68xRwTCMqqe6ApwWdPoMk9KB4
 /nTxXsYhkSI3QBQebE+YbSz9l3djuOj+z57yxzVb6QH7nfUXy4spVYHEEaj2pgc1csZ1 ug== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w4fq6u8j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:41:52 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:41:50 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.55) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:41:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMUlRz6VB2GpcPmindpNqWRNgogqN6FM4pLmzrlHneF1Z4V8jO1AehrTnZ07+N8GqTrpomU/fImvGI7mH8lX+xGeXF9W89FQb90WbHtR2K3mJP4NCmt2g02Wg9M7PxNyBZDcouzW2M7NfA9RQS0TZ/HjUNoeCTtvoVnE6567K5FW3eZ5DiaBQFth3wd1GnjUD+ymiC/I4HV3L/ObTnCeZLyv7A3pc5o8kRjdVep6bupIAZLsAwsgYn2kZ5MuEaaR/NRqP3J1Q3EyiO5zliTgh//d+SVdhPfAlh6j2RSh99he8P9Bazgs9FNmmbyXh/00JXPDyD77t/tevDZCQwiRhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUOYg005Ddg9IlWO2U6H9/e+2Y+rX5wxOPYb/ykxuNE=;
 b=oY8tNtnUFiBSh89MJf+dE3PUuKczj/rODqTZEEdbuQfcXdafOz74JcfMaHnhm46j6YpYNwYbuhuMrkpAE2qwh0USFnptTPMN3DeDsQt12eR7nSWIDTdYr82yQVmosHf9de9yLyXPva6p6ggrfSmQvQ+6OpX2Vp94215CVjLJwI5uZzBrIkzxZd80trHhBEEiFKeBwx/OuP7MOCRJNFAiEgs8cPKMlWTi5HprPBtZnFo2OwuY3KaQWI8AUYDPYYyBLRtof474GiqPGE1BFPcH/GjKNivg4bYhTL7Ao2FDaPAmEuyjpLdPf8jr3JJgdCBcIY34q8SAIxOYTmtF7THEGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUOYg005Ddg9IlWO2U6H9/e+2Y+rX5wxOPYb/ykxuNE=;
 b=gMjbXFibeCvHqpUpsv/DQKJHbAQxv1a2RQxIS16DR6aOiev7IVWXgX8cA886iUvfyXdQAMbaYqnOOGtH2ydVafaglvQpdoKNHsQ3w5HoywZzmSO7cOe4Ko3LV+Hx4DMCa6GoHvxntRRez7Vq9gP5vZabXC0OgooRppNAqwOj864=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:41:49 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:41:49 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH v2 net-next 01/12] net: atlantic: update firmware interface
Thread-Topic: [PATCH v2 net-next 01/12] net: atlantic: update firmware
 interface
Thread-Index: AQHVlbyKkfGe4UP950+sSw8q7HFZGQ==
Date:   Thu, 7 Nov 2019 22:41:49 +0000
Message-ID: <efefdfef3fd63e8327807aaee6dd63ef7999c2b2.1573158381.git.irusskikh@marvell.com>
References: <cover.1573158381.git.irusskikh@marvell.com>
In-Reply-To: <cover.1573158381.git.irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0011.eurprd09.prod.outlook.com
 (2603:10a6:101:16::23) To DM5PR18MB1642.namprd18.prod.outlook.com
 (2603:10b6:3:14c::8)
x-mailer: git-send-email 2.17.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 125f36e4-6e12-49e7-0cb2-08d763d3ad1e
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB2295FF72C81489A5C04A6C5DB7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:352;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(76176011)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(52116002)(5640700003)(2501003)(8676002)(25786009)(118296001)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6512007)(14454004)(15650500001)(2616005)(476003)(256004)(486006)(186003)(3846002)(102836004)(11346002)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(446003)(14444005)(357404004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tyJEjHWtBAjjoCXayHH5aRppDbJvEeRbZsBJgdtMP3pxlNWSrxO4Og/wjWzpZYPqVzaE8DNFyzR4pPbAuO62tXN/ZI9N1X7gtJtPPmrCrGTEAEMNveZagYtKJg1T6f0NSu/ezW2dZtWU1k5DIETJBmuvga164XGp7fr572K1hMqpUMcCEoycJ0bCE65ZPObxC4iYtbYPKA4CxHFgvA5QlGM9IZpLi4CkXgZQ41cv0JiHhn7Sz1ztKf3sULqCRCUyUX0AkKOJJWVv7WbSs8lSt6I6/mdIdMSGCPSoHBlbvwMk58+RfZH3wX3WWFEFjFzuW6np/76xCHTVDE/WT4D1HWCtAWfBXPcwvClyp+eI9+vyVKuP/UnT9fpwKjP0VhFmtmovalMF2XtePN7eHF4tgJMN5l61Wu4Dwq3iAjQ6P0jx61BQiqRVRU2iyY2HqcY4
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 125f36e4-6e12-49e7-0cb2-08d763d3ad1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:41:49.2680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EQDl0M//q2Sa/1sidWfx7vQ10kL9Fny1cmAVmop86dAJsC/dtEEcqNi5U6/hQeqeBy9eM4ebPH5hws3Ux6rQCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

Here we improve FW interface structures layout
and prepare these for the wake phy feature implementation.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  18 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   | 173 ++++++------------
 2 files changed, 72 insertions(+), 119 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 6fc5640065bd..6c7caff9a96b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -858,22 +858,26 @@ static int aq_fw1x_set_wol(struct aq_hw_s *self, bool=
 wol_enabled, u8 *mac)
 	memset(prpc, 0, sizeof(*prpc));
=20
 	if (wol_enabled) {
-		rpc_size =3D sizeof(prpc->msg_id) + sizeof(prpc->msg_wol);
+		rpc_size =3D offsetof(struct hw_atl_utils_fw_rpc, msg_wol_add) +
+			   sizeof(prpc->msg_wol_add);
+
=20
 		prpc->msg_id =3D HAL_ATLANTIC_UTILS_FW_MSG_WOL_ADD;
-		prpc->msg_wol.priority =3D
+		prpc->msg_wol_add.priority =3D
 				HAL_ATLANTIC_UTILS_FW_MSG_WOL_PRIOR;
-		prpc->msg_wol.pattern_id =3D
+		prpc->msg_wol_add.pattern_id =3D
 				HAL_ATLANTIC_UTILS_FW_MSG_WOL_PATTERN;
-		prpc->msg_wol.wol_packet_type =3D
+		prpc->msg_wol_add.packet_type =3D
 				HAL_ATLANTIC_UTILS_FW_MSG_WOL_MAG_PKT;
=20
-		ether_addr_copy((u8 *)&prpc->msg_wol.wol_pattern, mac);
+		ether_addr_copy((u8 *)&prpc->msg_wol_add.magic_packet_pattern,
+				mac);
 	} else {
-		rpc_size =3D sizeof(prpc->msg_id) + sizeof(prpc->msg_del_id);
+		rpc_size =3D sizeof(prpc->msg_wol_remove) +
+			   offsetof(struct hw_atl_utils_fw_rpc, msg_wol_remove);
=20
 		prpc->msg_id =3D HAL_ATLANTIC_UTILS_FW_MSG_WOL_DEL;
-		prpc->msg_wol.pattern_id =3D
+		prpc->msg_wol_add.pattern_id =3D
 				HAL_ATLANTIC_UTILS_FW_MSG_WOL_PATTERN;
 	}
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index ee11b107f0a5..c6708f0d5d3e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -70,104 +70,41 @@ struct __packed hw_atl_stats_s {
 	u32 dpc;
 };
=20
-union __packed ip_addr {
-	struct {
-		u8 addr[16];
-	} v6;
-	struct {
-		u8 padding[12];
-		u8 addr[4];
-	} v4;
-};
-
-struct __packed hw_atl_utils_fw_rpc {
-	u32 msg_id;
-
+struct __packed drv_msg_enable_wakeup {
 	union {
-		struct {
-			u32 pong;
-		} msg_ping;
+		u32 pattern_mask;
=20
 		struct {
-			u8 mac_addr[6];
-			u32 ip_addr_cnt;
+			u32 reason_arp_v4_pkt : 1;
+			u32 reason_ipv4_ping_pkt : 1;
+			u32 reason_ipv6_ns_pkt : 1;
+			u32 reason_ipv6_ping_pkt : 1;
+			u32 reason_link_up : 1;
+			u32 reason_link_down : 1;
+			u32 reason_maximum : 1;
+		};
+	};
=20
-			struct {
-				union ip_addr addr;
-				union ip_addr mask;
-			} ip[1];
-		} msg_arp;
+	union {
+		u32 offload_mask;
+	};
+};
=20
-		struct {
-			u32 len;
-			u8 packet[1514U];
-		} msg_inject;
+struct __packed magic_packet_pattern_s {
+	u8 mac_addr[ETH_ALEN];
+};
=20
-		struct {
-			u32 priority;
-			u32 wol_packet_type;
-			u32 pattern_id;
-			u32 next_wol_pattern_offset;
-
-			union {
-				struct {
-					u32 flags;
-					u8 ipv4_source_address[4];
-					u8 ipv4_dest_address[4];
-					u16 tcp_source_port_number;
-					u16 tcp_dest_port_number;
-				} ipv4_tcp_syn_parameters;
-
-				struct {
-					u32 flags;
-					u8 ipv6_source_address[16];
-					u8 ipv6_dest_address[16];
-					u16 tcp_source_port_number;
-					u16 tcp_dest_port_number;
-				} ipv6_tcp_syn_parameters;
-
-				struct {
-					u32 flags;
-				} eapol_request_id_message_parameters;
-
-				struct {
-					u32 flags;
-					u32 mask_offset;
-					u32 mask_size;
-					u32 pattern_offset;
-					u32 pattern_size;
-				} wol_bit_map_pattern;
-
-				struct {
-					u8 mac_addr[ETH_ALEN];
-				} wol_magic_packet_patter;
-			} wol_pattern;
-		} msg_wol;
+struct __packed drv_msg_wol_add {
+	u32 priority;
+	u32 packet_type;
+	u32 pattern_id;
+	u32 next_pattern_offset;
=20
-		struct {
-			union {
-				u32 pattern_mask;
-
-				struct {
-					u32 reason_arp_v4_pkt : 1;
-					u32 reason_ipv4_ping_pkt : 1;
-					u32 reason_ipv6_ns_pkt : 1;
-					u32 reason_ipv6_ping_pkt : 1;
-					u32 reason_link_up : 1;
-					u32 reason_link_down : 1;
-					u32 reason_maximum : 1;
-				};
-			};
-
-			union {
-				u32 offload_mask;
-			};
-		} msg_enable_wakeup;
+	struct magic_packet_pattern_s magic_packet_pattern;
+};
=20
-		struct {
-			u32 id;
-		} msg_del_id;
-	};
+struct __packed drv_msg_wol_remove {
+	u32 id;
 };
=20
 struct __packed hw_atl_utils_mbox_header {
@@ -189,6 +126,13 @@ struct __packed hw_aq_ptp_offset {
 	u16 egress_10000;
 };
=20
+struct __packed hw_atl_cable_diag {
+	u8 fault;
+	u8 distance;
+	u8 far_distance;
+	u8 reserved;
+};
+
 enum gpio_pin_function {
 	GPIO_PIN_FUNCTION_NC,
 	GPIO_PIN_FUNCTION_VAUX_ENABLE,
@@ -210,7 +154,7 @@ struct __packed hw_aq_info {
 	u16 phy_temperature;
 	u8 cable_len;
 	u8 reserved1;
-	u32 cable_diag_data[4];
+	struct hw_atl_cable_diag cable_diag_data[4];
 	struct hw_aq_ptp_offset ptp_offset;
 	u8 reserved2[12];
 	u32 caps_lo;
@@ -236,25 +180,22 @@ struct __packed hw_atl_utils_mbox {
 	struct hw_aq_info info;
 };
=20
-/* fw2x */
-typedef u32	fw_offset_t;
-
 struct __packed offload_ip_info {
 	u8 v4_local_addr_count;
 	u8 v4_addr_count;
 	u8 v6_local_addr_count;
 	u8 v6_addr_count;
-	fw_offset_t v4_addr;
-	fw_offset_t v4_prefix;
-	fw_offset_t v6_addr;
-	fw_offset_t v6_prefix;
+	u32 v4_addr;
+	u32 v4_prefix;
+	u32 v6_addr;
+	u32 v6_prefix;
 };
=20
 struct __packed offload_port_info {
 	u16 udp_port_count;
 	u16 tcp_port_count;
-	fw_offset_t udp_port;
-	fw_offset_t tcp_port;
+	u32 udp_port;
+	u32 tcp_port;
 };
=20
 struct __packed offload_ka_info {
@@ -262,15 +203,15 @@ struct __packed offload_ka_info {
 	u16 v6_ka_count;
 	u32 retry_count;
 	u32 retry_interval;
-	fw_offset_t v4_ka;
-	fw_offset_t v6_ka;
+	u32 v4_ka;
+	u32 v6_ka;
 };
=20
 struct __packed offload_rr_info {
 	u32 rr_count;
 	u32 rr_buf_len;
-	fw_offset_t rr_id_x;
-	fw_offset_t rr_buf;
+	u32 rr_id_x;
+	u32 rr_buf;
 };
=20
 struct __packed offload_info {
@@ -287,6 +228,19 @@ struct __packed offload_info {
 	u8 buf[0];
 };
=20
+struct __packed hw_atl_utils_fw_rpc {
+	u32 msg_id;
+
+	union {
+		/* fw1x structures */
+		struct drv_msg_wol_add msg_wol_add;
+		struct drv_msg_wol_remove msg_wol_remove;
+		struct drv_msg_enable_wakeup msg_enable_wakeup;
+		/* fw2x structures */
+		struct offload_info fw2x_offloads;
+	};
+};
+
 /* Mailbox FW Request interface */
 struct __packed hw_fw_request_ptp_gpio_ctrl {
 	u32 index;
@@ -326,6 +280,9 @@ struct __packed hw_fw_request_iface {
 enum hw_atl_rx_action_with_traffic {
 	HW_ATL_RX_DISCARD,
 	HW_ATL_RX_HOST,
+	HW_ATL_RX_MNGMNT,
+	HW_ATL_RX_HOST_AND_MNGMNT,
+	HW_ATL_RX_WOL
 };
=20
 struct aq_rx_filter_vlan {
@@ -407,20 +364,12 @@ enum hal_atl_utils_fw_state_e {
 #define HAL_ATLANTIC_RATE_100M       BIT(5)
 #define HAL_ATLANTIC_RATE_INVALID    BIT(6)
=20
-#define HAL_ATLANTIC_UTILS_FW_MSG_PING          0x1U
-#define HAL_ATLANTIC_UTILS_FW_MSG_ARP           0x2U
-#define HAL_ATLANTIC_UTILS_FW_MSG_INJECT        0x3U
 #define HAL_ATLANTIC_UTILS_FW_MSG_WOL_ADD       0x4U
 #define HAL_ATLANTIC_UTILS_FW_MSG_WOL_PRIOR     0x10000000U
 #define HAL_ATLANTIC_UTILS_FW_MSG_WOL_PATTERN   0x1U
 #define HAL_ATLANTIC_UTILS_FW_MSG_WOL_MAG_PKT   0x2U
 #define HAL_ATLANTIC_UTILS_FW_MSG_WOL_DEL       0x5U
 #define HAL_ATLANTIC_UTILS_FW_MSG_ENABLE_WAKEUP 0x6U
-#define HAL_ATLANTIC_UTILS_FW_MSG_MSM_PFC       0x7U
-#define HAL_ATLANTIC_UTILS_FW_MSG_PROVISIONING  0x8U
-#define HAL_ATLANTIC_UTILS_FW_MSG_OFFLOAD_ADD   0x9U
-#define HAL_ATLANTIC_UTILS_FW_MSG_OFFLOAD_DEL   0xAU
-#define HAL_ATLANTIC_UTILS_FW_MSG_CABLE_DIAG    0xDU
=20
 enum hw_atl_fw2x_rate {
 	FW2X_RATE_100M    =3D 0x20,
--=20
2.17.1

