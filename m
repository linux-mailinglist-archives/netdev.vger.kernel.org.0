Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC1EC28A
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfKAMRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51854 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726925AbfKAMRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1CBNsM001722;
        Fri, 1 Nov 2019 05:17:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=oUOYg005Ddg9IlWO2U6H9/e+2Y+rX5wxOPYb/ykxuNE=;
 b=JTY35BdM6gnkqdGVxWbSXCyaj0LEUSDiWF4saCt3qwXKNz28rPTQ8bFLUrX6DaqIXnFn
 b9AmbmkrfMZotttypAocjsA1AtCUQiG+Nv4Gqy/vSOSIoGwjV5KJDAk7Zkp2wI+eEeeQ
 ytRqZ5OOyKZ3TLHBGR1mPB9lglJW4nO8QxoRZ0zDU5xJ/jP194GtOGj2mOGSJt/W828f
 3Znf0oUq6rGEgV5V/czxEH46D6kWAbkBGmo9R9JNWYJttEja+M8mPWqHEzni4YUtAA12
 CYXLF2+Tdmh+ULwU6X1ZJoxQh0QixRrKXImLa8Fub0Acpi7buC4SFcFPpwTL78588T1K 7A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vxwjmbtk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:16 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:15 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.54) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frpyKv82Pstd5IsAoO+aQgfX5p7bR0vDsma7FRFM/iw2wucRR13Q0P0DwhXkjZ3PzHh0jYWGPGgdlIVAMkv3yNSJm2PIpXrkYDeDkWGZawYFHLEcSOfRkU84YuItQngBT8tCOt+je7FP4f0mjrhnwAi/+vrks6CAzRD5kuXjCj8xefBIfW8PK6VU4cs8x6MC8Llldf46YMmPNrA9Mbml8Kj7wlofLb60XxzQFpU4PvYci+GVrtK5knUzHrSx/gBjgoKpUjZ3LPQdrjg0zeDeljcpnWWE3j7h1DTQdxrNMYBxzyUwiOtfG8gj4+pwTRrYVW13/+CpgJMUpWMjJ32YzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUOYg005Ddg9IlWO2U6H9/e+2Y+rX5wxOPYb/ykxuNE=;
 b=i6Cn7NAJOlYmwSNEFJRn8jHntscXx6c3V2X3Hg5JYcVoVLMKj+yj3GU+0tbKwllxnPrhTebtdiblZg5X4t0DnTVbDe0/bj47xmrGWizifLV0QMGIXfSYSrwk24oMPyAhP2VobBb1eIFAI6NczYV+ypA5Xb5Twfbn32Gxdy7jRDWf9Z8rSFS4i3p0ofONIjcNZl6VZbtrSZgnZOHv5CERVXe3E23ymK77W5suGJgZxFYVrzhw2zX6Y1KWxm94veWbUzR6gL5BNimSwLjHuFcBzqI88QWDaL13zRHPgHV0bx6feXw3ntdle8gd6m2jR9el0yhnv2/FsgXQfkehM7AqQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUOYg005Ddg9IlWO2U6H9/e+2Y+rX5wxOPYb/ykxuNE=;
 b=HQ18nO6vSD9ADSx+/DWnREkia2nXnBpd3/g/WRvH6DfBuxZgq+b5aCX/jd0Xtj/ArvpSL3jy2BS3ct+z8ECaOKeJcMp+KFwgNBu1g+8ZssXTeS0IvNlUbY/wxq1I5B5ZCu7CF/uAy17pTJiXOr1QQvJUroxsqA2YpaDZ9J1avOg=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:14 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:14 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH net-next 01/12] net: atlantic: update firmware interface
Thread-Topic: [PATCH net-next 01/12] net: atlantic: update firmware interface
Thread-Index: AQHVkK5LGMUVINKkLUOJ5wF+3NQ+rA==
Date:   Fri, 1 Nov 2019 12:17:13 +0000
Message-ID: <efefdfef3fd63e8327807aaee6dd63ef7999c2b2.1572610156.git.irusskikh@marvell.com>
References: <cover.1572610156.git.irusskikh@marvell.com>
In-Reply-To: <cover.1572610156.git.irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0035.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::23) To BL0PR18MB2275.namprd18.prod.outlook.com
 (2603:10b6:207:44::13)
x-mailer: git-send-email 2.17.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa35e433-9ba8-4ac5-76f9-08d75ec56d96
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2306371CD83BDF2474CF7C55B7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:352;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(14444005)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(15650500001)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008)(357404004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EnKXiiygE10ok9OkZibYKmBo5G7FfBmEhCvhVIvV/CirBsC/Qvfz0gn16Rc/IfnfcSyZnEP0gDsiM6RGAbKlkb1jEigtQSswUC/ZqfGEde9WI3KB2EvXcn87unh91vrf3toso6wSA2ocFnmsmg9RgFurdcCEjZOQhOP6zm35b1Vn52jVtTIK4vdIrQCj1AWfE/wuLOsmJ9YG3YSvo35nhVHmWmK3lA3UONEihIs7A2jNFmdE0lMBVtlhWMkVmjIJjvybpuPflwYBkYRsBJ3nTyQ/zKwoa/H4SPv0On4y+PBGDTH0MW+tJVkXaHVBKyIhPxOqmiOJA/EpUIOOMS1OmfJjncrVf0AXKVBkOMM4zfE32MVhRnJquB0FhYMUWihG0PjMwYMvylb3sukrXmkACxWZPRdkwwIzvQpH8Y5IU5W7M/VAp4en73H+/cx5haed
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: aa35e433-9ba8-4ac5-76f9-08d75ec56d96
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:13.8718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LQ1zaFvw+YONKFOsBDDVabOojrcH2V/3SVrrnqE95hqNAEjVFcSYOQt8K4QN5zbIUtGJJV5SWK4lLunK8K8iVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
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

