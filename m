Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15ABAE0135
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfJVJxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:53:46 -0400
Received: from mail-eopbgr780047.outbound.protection.outlook.com ([40.107.78.47]:41694
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731615AbfJVJxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:53:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=no1eww2kfYuMqvcte62r4oSDkKgNYz0KiyuunW0UiPdfN064WQMEM/by5tJEoMHxv++y/5f+JFagQCuYXQMhBbJnMwwESPOIpxbI+quLLfftt8QbpSzv+MzlJd09DnMFx7QZxOgTb6RFYicHT5D6SU+0DqBCCIa6bCRe2SbnQfKdpRCvHcX/MgMbxIfkQIzR0Ey30hUKa5Gj6MCmkZOkUs4g7RzB9vZOPv4e0VXqsiJT0FBTBvM4wl85YbYTUglGB0udiF6ajM6meicGALvCmwndD3DuB+CUZv8r9esFWkobopGReyc9EDn9N9txJZaGpQHVJzP9xUxAe/Tj0am9IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZPEzhm3IiIZmSi6FhyRuT9HKNKJ+Ykpwqj8cw5ZCHQ=;
 b=bdvGj8YVemHAcD31W1VyyXwYTa/XPKuQPYAJA+Z32f3e6BHNLWUKko38azuA1mFMGcQQX/qv53Z6Vb8JKfGy0KAHVY/yxQO/JdBfo5z8HVORGMhRGgVCtckh9gf2CY88esqigLd/YgL6oAGIgGzmkgDXh1L+G2/CARt89BjaAjkMI6Yky7WdnfTh1QUSRpe/BAjgO2qROoRsXGJBz9pylZIxGpHMBfYspmLLW4Swgzqiv+TNAw8/BFyjXMdhIjsiTpeqP5Y5wAgXOPhFXHlfiZ2T/Bp2Eab66fwef6/HN4moS1kaPilSxbu9w1pc6hVyTpZjRetR7/bYSyO2Ffj7PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZPEzhm3IiIZmSi6FhyRuT9HKNKJ+Ykpwqj8cw5ZCHQ=;
 b=FBuDWbeMI97RcTMFC3l7TOsgxGiHAt+JRSKn5s9MTqJtFBMBAkKtgjp52agq0J/5cBILvG7LJFgizQcwUxED4WkphvIB2CXJw97MTlZIf0nOTavvKecl01o4J0BeNb02MD+JjirQdfMY4MsNzPgvvop0Hima/Hh6XzDyGRnYI7M=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3732.namprd11.prod.outlook.com (20.178.218.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 09:53:38 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:38 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: [PATCH v3 net-next 07/12] net: aquantia: rx filters for ptp
Thread-Topic: [PATCH v3 net-next 07/12] net: aquantia: rx filters for ptp
Thread-Index: AQHViL6Tev8Cjfdwc0KL//8JEp1D9g==
Date:   Tue, 22 Oct 2019 09:53:38 +0000
Message-ID: <1727a1193e0144fb08a646da3c3251260f4b7d03.1571737612.git.igor.russkikh@aquantia.com>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1571737612.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MR2P264CA0092.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::32) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cd973ea-49d6-49c1-262b-08d756d5b619
x-ms-traffictypediagnostic: BN8PR11MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB37323DDC39A170691FD92E8798680@BN8PR11MB3732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:316;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(366004)(376002)(396003)(199004)(189003)(2616005)(25786009)(8936002)(81166006)(86362001)(486006)(81156014)(1730700003)(44832011)(30864003)(476003)(8676002)(50226002)(186003)(71190400001)(11346002)(446003)(14444005)(256004)(71200400001)(3846002)(2906002)(118296001)(66556008)(64756008)(66446008)(6116002)(66476007)(5660300002)(66946007)(6512007)(99286004)(5640700003)(4326008)(54906003)(316002)(107886003)(6486002)(7736002)(305945005)(6436002)(66066001)(26005)(6506007)(386003)(14454004)(102836004)(508600001)(6916009)(52116002)(76176011)(36756003)(2351001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3732;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XiiS2PDEWfnihjqBSYC+tYBEGTNnclor4Fj8E9BBCuVYpn8N6uJoQG2ewJlhbsO4KnNBo0by0RvMevYZwwKstAYjgFdsZ8pz4YhZyVjF1FLggoCLgSKuPqoKZg/913RDQLl/zEK4YXqUj6mqF2u9l2p2njVKmmhF2e5xyIexz4amPMoCJAkcPztWwU1qLZqDgRICmX9hp35agdUhOQ0QPO5fL1PTAEL+rXTzfqBy2mNtUbt045CuAZNoGe0ioIb+T3do59MahMg3q0bRuMvzHK3MjbiS8jovaXFB9Qci7YEOhQjS68U9aUUprtmADBEyOp6z0AXgJOHQo5UaPqdjivjoBFDPX2nUkHEDn2UKrdHhIGZOgtT4syCa4YH68DLBjAwWC+70GBWjg+0pzrqbCZHmCK/Sm4Nj0osT1si5Jb3n8+UuBcwaQrXdH3UuPzKe
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd973ea-49d6-49c1-262b-08d756d5b619
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:38.1727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bgaqahI0yDEsAadPuZv+6QTgQ47IEPq1mnxiND3Zy8s4xopQzACzbKIDHefvSvmQGjttd9t0v04qXlz13mpWjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

We implement HW filter reservation for PTP traffic. Special location
in filters table is marked as reserved, because incoming ptp traffic
should be directed only to PTP designated queue. This way HW will do PTP
timestamping and proper processing.

Co-developed-by: Egor Pomozov <epomozov@marvell.com>
Signed-off-by: Egor Pomozov <epomozov@marvell.com>
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
index 65384f45805f..22e4a5587c15 100644
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
@@ -1105,3 +1106,46 @@ void aq_nic_shutdown(struct aq_nic_s *self)
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
index fbb1912a34d7..82409cb1f815 100644
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
@@ -62,6 +64,9 @@ struct aq_ptp_s {
 	struct aq_ring_s hwts_rx;
=20
 	struct ptp_skb_ring skb_ring;
+
+	struct aq_rx_filter_l3l4 udp_filter;
+	struct aq_rx_filter_l2 eth_type_filter;
 };
=20
 struct ptp_tm_offset {
@@ -933,6 +938,11 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int =
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
@@ -958,6 +968,10 @@ void aq_ptp_free(struct aq_nic_s *aq_nic)
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
index bd9e5a598657..56cec2ea0af0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1261,7 +1261,8 @@ static int hw_atl_b0_hw_fl3l4_set(struct aq_hw_s *sel=
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
@@ -1278,8 +1279,13 @@ static int hw_atl_b0_hw_fl3l4_set(struct aq_hw_s *se=
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
index 65fb74a4d5ea..86c2d12b0dcd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -1308,6 +1308,52 @@
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
@@ -2548,50 +2594,6 @@
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

