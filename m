Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3BACF7A2
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbfJHK5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:57:04 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:64603
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730026AbfJHK5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:57:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCYZmqGU5XwkLMJkDDrL6WPOemnuWXV82f0yxgcXRaIo3oRkidX+UP3N2nPOYctzeGiyocpNFWrKjGigG9jZS2X0f11hI2tuYTUc2bu8ngFh2kgBqW1PMW82nKF+sDTgjIZ3faUEHRiMzddAM0YR6a+YhWbqBAtyArVAxT7NNDfxpEQqEkGee9dp8cUgDKN8Tf1YGKhA9m6gUURnFfJnPPyF6Gg+pPO5Pf0ehS5fZsVfWl7OUC5oBTZ16OcAcDO9zMYXodXy/bYiUvJhzZ2il0hZjT3oA0HC0OU0hScZk9VhhYJCteCMwfuXVzgZg6AuEK7HVhiAEIjs41XeNA5M/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JBoOdOvwuW0Gjoz9sTim84iJxzP8rQ5/VRlhYdcntY=;
 b=gohbL8Nix2wHt/a3pbY+L/WOSedmP2l+G94pCPyzDVV+KVi8PoEQk+CXVHPqqKP3fxe/SX2aid091nuaPJoIcj2YnV97vGWCfiYxDeR3pvWit7bjvnHdYzMnhh45J8q/89KR3i1E0jVjsczKv/OYUx5j9ZIE7gxUnJXdkRiv1M4HcarqgcGXCZ/tTteYFN7p+jiaHnpTb1IRTiaMcXKgQnnVg4p4LuJe3GhqWGFwgYbkNi0NZGWXV+lE4zQBoOtKDLz/o5xpc2UNbYJyqBsaisX5dB3BdUlth3giQJbZm5yMFm7TCN0OX5vzxEulPGy0jnND8fjWWyA6+vw3o1UFpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JBoOdOvwuW0Gjoz9sTim84iJxzP8rQ5/VRlhYdcntY=;
 b=BsFcpxwR+JHhKEPIo7tMYpF0MH5aohzBrPVi0KEFvpsTfV4+D/3w9YwMUrEhD640SQOOKODx/EXBPZKCrd+ImnrccLMqdsddHVNFM3O7r4yUInFC2YDXVBOIIprnt7oRbA5j0hrGRqUvy3+IjLEaxYbn65lZgqSffBZCikLax8M=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:56:50 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:56:50 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: [PATCH v2 net-next 07/12] net: aquantia: rx filters for ptp
Thread-Topic: [PATCH v2 net-next 07/12] net: aquantia: rx filters for ptp
Thread-Index: AQHVfccW/16Eu28HQ0a5feBuSi0Big==
Date:   Tue, 8 Oct 2019 10:56:49 +0000
Message-ID: <650d2136c432019f7514aa5f097670ccc36f82db.1570531332.git.igor.russkikh@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570531332.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::35) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fda8abc3-e66a-4788-f45c-08d74bde3857
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB366638EC36CEC81BB00AF130989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:316;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(118296001)(71190400001)(71200400001)(2501003)(256004)(14444005)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(11346002)(5640700003)(6512007)(99286004)(25786009)(66556008)(50226002)(76176011)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(30864003)(14454004)(26005)(36756003)(86362001)(446003)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b1r/3pjUOtAXMmKEvx1+D9YAwtJjL+3AXW+fpMpMYQxX8NK74mgJEoDc07Emm0B2Tm3ChFb3ciGLtGs9wr/lMOixx0wU6gUDTFnWYDNXQOhR/guN7NsmbmEZWVtyHXnvFv1ZIQL62mq5pAPbJggeHml3q3Tun58v4+eaOUnM4Joj7DT2IHzcoqbBLtoSDsJBd0qIEUyD7jJzY5BloCEv4gnjTiFeir/n4slbN8Royrkz+g9MSS/uguvRl/a7jhsWpWzQFvEf4ZTtd7UnAJsxAz/cxIafntFgzKjud/0KqMxz/XmRvLDQ+RyATMWcnTrcQ1yVlTMElzc3pZx+8MtludzZ8BvPOrnSabLCyRyvnDg+GFEaz9uAoODxNmZ/2qeiiW+S7c4KXj/VlNJtw2zI+Ipj0nXvIyJl8GwyQhoqX7g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fda8abc3-e66a-4788-f45c-08d74bde3857
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:56:49.9174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /7AdldJKUl6wCYN3gKCUacXzv1BipHz2+dxszdw5R3l6uy/IV7HlmssDHZbkekoJv3PARctRg8bsofR9RNLbHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

We implement HW filter reservation for PTP traffic. Special location
in filters table is marked as reserved, because incoming ptp traffic
should be directed only to PTP designated queue. This way HW will do PTP
timestamping and proper processing.

Co-developed-by: Egor Pomozov <egor.pomozov@aquantia.com>
Signed-off-by: Egor Pomozov <egor.pomozov@aquantia.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../ethernet/aquantia/atlantic/aq_filters.c   | 17 ++--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 44 +++++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  8 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 14 +++
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 12 ++-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     | 90 ++++++++++---------
 6 files changed, 131 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_filters.c
index aee827f07c16..6102251bb909 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (C) 2014-2017 aQuantia Corporation. */
+/* Copyright (C) 2014-2019 aQuantia Corporation. */
=20
 /* File aq_filters.c: RX filters related functions. */
=20
@@ -89,12 +89,14 @@ static int aq_check_approve_fl3l4(struct aq_nic_s *aq_n=
ic,
 				  struct aq_hw_rx_fltrs_s *rx_fltrs,
 				  struct ethtool_rx_flow_spec *fsp)
 {
+	u32 last_location =3D AQ_RX_LAST_LOC_FL3L4 -
+			    aq_nic->aq_hw_rx_fltrs.fl3l4.reserved_count;
+
 	if (fsp->location < AQ_RX_FIRST_LOC_FL3L4 ||
-	    fsp->location > AQ_RX_LAST_LOC_FL3L4) {
+	    fsp->location > last_location) {
 		netdev_err(aq_nic->ndev,
 			   "ethtool: location must be in range [%d, %d]",
-			   AQ_RX_FIRST_LOC_FL3L4,
-			   AQ_RX_LAST_LOC_FL3L4);
+			   AQ_RX_FIRST_LOC_FL3L4, last_location);
 		return -EINVAL;
 	}
 	if (rx_fltrs->fl3l4.is_ipv6 && rx_fltrs->fl3l4.active_ipv4) {
@@ -124,12 +126,15 @@ aq_check_approve_fl2(struct aq_nic_s *aq_nic,
 		     struct aq_hw_rx_fltrs_s *rx_fltrs,
 		     struct ethtool_rx_flow_spec *fsp)
 {
+	u32 last_location =3D AQ_RX_LAST_LOC_FETHERT -
+			    aq_nic->aq_hw_rx_fltrs.fet_reserved_count;
+
 	if (fsp->location < AQ_RX_FIRST_LOC_FETHERT ||
-	    fsp->location > AQ_RX_LAST_LOC_FETHERT) {
+	    fsp->location > last_location) {
 		netdev_err(aq_nic->ndev,
 			   "ethtool: location must be in range [%d, %d]",
 			   AQ_RX_FIRST_LOC_FETHERT,
-			   AQ_RX_LAST_LOC_FETHERT);
+			   last_location);
 		return -EINVAL;
 	}
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index f1d4d3a9bfcb..03ec778d0fcc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -13,6 +13,7 @@
 #include "aq_pci_func.h"
 #include "aq_main.h"
 #include "aq_ptp.h"
+#include "aq_filters.h"
=20
 #include <linux/moduleparam.h>
 #include <linux/netdevice.h>
@@ -1103,3 +1104,46 @@ void aq_nic_shutdown(struct aq_nic_s *self)
 err_exit:
 	rtnl_unlock();
 }
+
+u8 aq_nic_reserve_filter(struct aq_nic_s *self, enum aq_rx_filter_type typ=
e)
+{
+	u8 location =3D 0xFF;
+	u32 fltr_cnt;
+	u32 n_bit;
+
+	switch (type) {
+	case aq_rx_filter_ethertype:
+		location =3D AQ_RX_LAST_LOC_FETHERT - AQ_RX_FIRST_LOC_FETHERT -
+			   self->aq_hw_rx_fltrs.fet_reserved_count;
+		self->aq_hw_rx_fltrs.fet_reserved_count++;
+		break;
+	case aq_rx_filter_l3l4:
+		fltr_cnt =3D AQ_RX_LAST_LOC_FL3L4 - AQ_RX_FIRST_LOC_FL3L4;
+		n_bit =3D fltr_cnt - self->aq_hw_rx_fltrs.fl3l4.reserved_count;
+
+		self->aq_hw_rx_fltrs.fl3l4.active_ipv4 |=3D BIT(n_bit);
+		self->aq_hw_rx_fltrs.fl3l4.reserved_count++;
+		location =3D n_bit;
+		break;
+	default:
+		break;
+	}
+
+	return location;
+}
+
+void aq_nic_release_filter(struct aq_nic_s *self, enum aq_rx_filter_type t=
ype,
+			   u32 location)
+{
+	switch (type) {
+	case aq_rx_filter_ethertype:
+		self->aq_hw_rx_fltrs.fet_reserved_count--;
+		break;
+	case aq_rx_filter_l3l4:
+		self->aq_hw_rx_fltrs.fl3l4.reserved_count--;
+		self->aq_hw_rx_fltrs.fl3l4.active_ipv4 &=3D ~BIT(location);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.h
index 576432adda4c..c2513b79b9e9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -18,6 +18,7 @@ struct aq_hw_ops;
 struct aq_fw_s;
 struct aq_vec_s;
 struct aq_ptp_s;
+enum aq_rx_filter_type;
=20
 struct aq_nic_cfg_s {
 	const struct aq_hw_caps_s *aq_hw_caps;
@@ -72,6 +73,7 @@ struct aq_hw_rx_fl3l4 {
 	u8   active_ipv4;
 	u8   active_ipv6:2;
 	u8 is_ipv6;
+	u8 reserved_count;
 };
=20
 struct aq_hw_rx_fltrs_s {
@@ -79,6 +81,8 @@ struct aq_hw_rx_fltrs_s {
 	u16                   active_filters;
 	struct aq_hw_rx_fl2   fl2;
 	struct aq_hw_rx_fl3l4 fl3l4;
+	/*filter ether type */
+	u8 fet_reserved_count;
 };
=20
 struct aq_nic_s {
@@ -154,5 +158,7 @@ u32 aq_nic_get_fw_version(struct aq_nic_s *self);
 int aq_nic_change_pm_state(struct aq_nic_s *self, pm_message_t *pm_msg);
 int aq_nic_update_interrupt_moderation_settings(struct aq_nic_s *self);
 void aq_nic_shutdown(struct aq_nic_s *self);
-
+u8 aq_nic_reserve_filter(struct aq_nic_s *self, enum aq_rx_filter_type typ=
e);
+void aq_nic_release_filter(struct aq_nic_s *self, enum aq_rx_filter_type t=
ype,
+			   u32 location);
 #endif /* AQ_NIC_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index c7ec956eea8b..e30747d2e7ca 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -8,12 +8,14 @@
  */
=20
 #include <linux/ptp_clock_kernel.h>
+#include <linux/ptp_classify.h>
 #include <linux/interrupt.h>
 #include <linux/clocksource.h>
=20
 #include "aq_nic.h"
 #include "aq_ptp.h"
 #include "aq_ring.h"
+#include "aq_filters.h"
=20
 #define AQ_PTP_TX_TIMEOUT        (HZ *  10)
=20
@@ -63,6 +65,9 @@ struct aq_ptp_s {
 	struct aq_ring_s hwts_rx;
=20
 	struct ptp_skb_ring skb_ring;
+
+	struct aq_rx_filter_l3l4 udp_filter;
+	struct aq_rx_filter_l2 eth_type_filter;
 };
=20
 struct ptp_tm_offset {
@@ -939,6 +944,11 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int =
idx_vec)
 	aq_ptp_clock_init(aq_nic);
 	mutex_unlock(&aq_nic->fwreq_mutex);
=20
+	aq_ptp->eth_type_filter.location =3D
+			aq_nic_reserve_filter(aq_nic, aq_rx_filter_ethertype);
+	aq_ptp->udp_filter.location =3D
+			aq_nic_reserve_filter(aq_nic, aq_rx_filter_l3l4);
+
 	return 0;
=20
 err_exit:
@@ -964,6 +974,10 @@ void aq_ptp_free(struct aq_nic_s *aq_nic)
 	if (!aq_ptp)
 		return;
=20
+	aq_nic_release_filter(aq_nic, aq_rx_filter_ethertype,
+			      aq_ptp->eth_type_filter.location);
+	aq_nic_release_filter(aq_nic, aq_rx_filter_l3l4,
+			      aq_ptp->udp_filter.location);
 	/* disable ptp */
 	mutex_lock(&aq_nic->fwreq_mutex);
 	aq_nic->aq_fw_ops->enable_ptp(aq_nic->aq_hw, 0);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 5722fd5fd52d..f058ef1320c2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1248,7 +1248,8 @@ static int hw_atl_b0_hw_fl3l4_set(struct aq_hw_s *sel=
f,
=20
 	hw_atl_b0_hw_fl3l4_clear(self, data);
=20
-	if (data->cmd) {
+	if (data->cmd & (HW_ATL_RX_ENABLE_CMP_DEST_ADDR_L3 |
+			 HW_ATL_RX_ENABLE_CMP_SRC_ADDR_L3)) {
 		if (!data->is_ipv6) {
 			hw_atl_rpfl3l4_ipv4_dest_addr_set(self,
 							  location,
@@ -1265,8 +1266,13 @@ static int hw_atl_b0_hw_fl3l4_set(struct aq_hw_s *se=
lf,
 							 data->ip_src);
 		}
 	}
-	hw_atl_rpf_l4_dpd_set(self, data->p_dst, location);
-	hw_atl_rpf_l4_spd_set(self, data->p_src, location);
+
+	if (data->cmd & (HW_ATL_RX_ENABLE_CMP_DEST_PORT_L4 |
+			 HW_ATL_RX_ENABLE_CMP_SRC_PORT_L4)) {
+		hw_atl_rpf_l4_dpd_set(self, data->p_dst, location);
+		hw_atl_rpf_l4_spd_set(self, data->p_src, location);
+	}
+
 	hw_atl_rpfl3l4_cmd_set(self, location, data->cmd);
=20
 	return aq_hw_err_from_flags(self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_inter=
nal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index 7716e0fc22b5..79d5adc77e42 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -1289,6 +1289,52 @@
 /* default value of bitfield et_val{f}[f:0] */
 #define HW_ATL_RPF_ET_VALF_DEFAULT 0x0
=20
+/* RX l3_l4_en{F} Bitfield Definitions
+ * Preprocessor definitions for the bitfield "l3_l4_en{F}".
+ * Parameter: filter {F} | stride size 0x4 | range [0, 7]
+ * PORT=3D"pif_rpf_l3_l4_en_i[0]"
+ */
+
+#define HW_ATL_RPF_L3_REG_CTRL_ADR(filter) (0x00005380 + (filter) * 0x4)
+
+/* RX rpf_l3_sa{D}[1F:0] Bitfield Definitions
+ * Preprocessor definitions for the bitfield "l3_sa{D}[1F:0]".
+ * Parameter: location {D} | stride size 0x4 | range [0, 7]
+ * PORT=3D"pif_rpf_l3_sa0_i[31:0]"
+ */
+
+/* Register address for bitfield pif_rpf_l3_sa0_i[31:0] */
+#define HW_ATL_RPF_L3_SRCA_ADR(filter) (0x000053B0 + (filter) * 0x4)
+/* Bitmask for bitfield l3_sa0[1F:0] */
+#define HW_ATL_RPF_L3_SRCA_MSK 0xFFFFFFFFu
+/* Inverted bitmask for bitfield l3_sa0[1F:0] */
+#define HW_ATL_RPF_L3_SRCA_MSKN 0xFFFFFFFFu
+/* Lower bit position of bitfield l3_sa0[1F:0] */
+#define HW_ATL_RPF_L3_SRCA_SHIFT 0
+/* Width of bitfield l3_sa0[1F:0] */
+#define HW_ATL_RPF_L3_SRCA_WIDTH 32
+/* Default value of bitfield l3_sa0[1F:0] */
+#define HW_ATL_RPF_L3_SRCA_DEFAULT 0x0
+
+/* RX rpf_l3_da{D}[1F:0] Bitfield Definitions
+ * Preprocessor definitions for the bitfield "l3_da{D}[1F:0]".
+ * Parameter: location {D} | stride size 0x4 | range [0, 7]
+ * PORT=3D"pif_rpf_l3_da0_i[31:0]"
+ */
+
+ /* Register address for bitfield pif_rpf_l3_da0_i[31:0] */
+#define HW_ATL_RPF_L3_DSTA_ADR(filter) (0x000053B0 + (filter) * 0x4)
+/* Bitmask for bitfield l3_da0[1F:0] */
+#define HW_ATL_RPF_L3_DSTA_MSK 0xFFFFFFFFu
+/* Inverted bitmask for bitfield l3_da0[1F:0] */
+#define HW_ATL_RPF_L3_DSTA_MSKN 0xFFFFFFFFu
+/* Lower bit position of bitfield l3_da0[1F:0] */
+#define HW_ATL_RPF_L3_DSTA_SHIFT 0
+/* Width of bitfield l3_da0[1F:0] */
+#define HW_ATL_RPF_L3_DSTA_WIDTH 32
+/* Default value of bitfield l3_da0[1F:0] */
+#define HW_ATL_RPF_L3_DSTA_DEFAULT 0x0
+
 /* RX l4_sp{D}[F:0] Bitfield Definitions
  * Preprocessor definitions for the bitfield "l4_sp{D}[F:0]".
  * Parameter: srcport {D} | stride size 0x4 | range [0, 7]
@@ -2529,50 +2575,6 @@
 /* default value of bitfield uP Force Interrupt */
 #define HW_ATL_MCP_UP_FORCE_INTERRUPT_DEFAULT 0x0
=20
-#define HW_ATL_RX_CTRL_ADDR_BEGIN_FL3L4   0x00005380
-#define HW_ATL_RX_SRCA_ADDR_BEGIN_FL3L4   0x000053B0
-#define HW_ATL_RX_DESTA_ADDR_BEGIN_FL3L4  0x000053D0
-
-#define HW_ATL_RPF_L3_REG_CTRL_ADR(location) (0x00005380 + (location) * 0x=
4)
-
-/* RX rpf_l3_sa{D}[1F:0] Bitfield Definitions
- * Preprocessor definitions for the bitfield "l3_sa{D}[1F:0]".
- * Parameter: location {D} | stride size 0x4 | range [0, 7]
- * PORT=3D"pif_rpf_l3_sa0_i[31:0]"
- */
-
-/* Register address for bitfield pif_rpf_l3_sa0_i[31:0] */
-#define HW_ATL_RPF_L3_SRCA_ADR(location) (0x000053B0 + (location) * 0x4)
-/* Bitmask for bitfield l3_sa0[1F:0] */
-#define HW_ATL_RPF_L3_SRCA_MSK 0xFFFFFFFFu
-/* Inverted bitmask for bitfield l3_sa0[1F:0] */
-#define HW_ATL_RPF_L3_SRCA_MSKN 0xFFFFFFFFu
-/* Lower bit position of bitfield l3_sa0[1F:0] */
-#define HW_ATL_RPF_L3_SRCA_SHIFT 0
-/* Width of bitfield l3_sa0[1F:0] */
-#define HW_ATL_RPF_L3_SRCA_WIDTH 32
-/* Default value of bitfield l3_sa0[1F:0] */
-#define HW_ATL_RPF_L3_SRCA_DEFAULT 0x0
-
-/* RX rpf_l3_da{D}[1F:0] Bitfield Definitions
- * Preprocessor definitions for the bitfield "l3_da{D}[1F:0]".
- * Parameter: location {D} | stride size 0x4 | range [0, 7]
- * PORT=3D"pif_rpf_l3_da0_i[31:0]"
- */
-
- /* Register address for bitfield pif_rpf_l3_da0_i[31:0] */
-#define HW_ATL_RPF_L3_DSTA_ADR(location) (0x000053B0 + (location) * 0x4)
-/* Bitmask for bitfield l3_da0[1F:0] */
-#define HW_ATL_RPF_L3_DSTA_MSK 0xFFFFFFFFu
-/* Inverted bitmask for bitfield l3_da0[1F:0] */
-#define HW_ATL_RPF_L3_DSTA_MSKN 0xFFFFFFFFu
-/* Lower bit position of bitfield l3_da0[1F:0] */
-#define HW_ATL_RPF_L3_DSTA_SHIFT 0
-/* Width of bitfield l3_da0[1F:0] */
-#define HW_ATL_RPF_L3_DSTA_WIDTH 32
-/* Default value of bitfield l3_da0[1F:0] */
-#define HW_ATL_RPF_L3_DSTA_DEFAULT 0x0
-
 #define HW_ATL_FW_SM_RAM        0x2U
=20
 #endif /* HW_ATL_LLH_INTERNAL_H */
--=20
2.17.1

