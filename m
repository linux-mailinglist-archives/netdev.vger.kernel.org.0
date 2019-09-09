Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B195AADA1A
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbfIINi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:38:57 -0400
Received: from mail-eopbgr770052.outbound.protection.outlook.com ([40.107.77.52]:40429
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729805AbfIINi4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 09:38:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYn3MrGYUbNL0iCZAhZAKBwJMK6U4+yuzHGxL0I13cAhiZjfF50eU7+lDLbEQNcThYR1BcLsHqinfx1r5P+zZzT0qqQ7hfkcn0YFey916MpF2cZdVhUn7GI28Fl+yuMYIu/mj83KRfRoILe+mj9KXC8St2REzd+MLYq4ZJhdk+86o77+wjvefHoANoV2gjt7Ml61yYunKXGZBqd/HDu/2PFPh6lqILb2VkpK5s8TGg7DOhVapJ6DG7lCdXN7/1DtK5aSK0SMk9r2g/JEEHyibNuVMW02qG642BUp+lY41yIPXXG/e+U1Hkvx1Is0sGDBjr/K1DYE4UxwzegFPno4JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pydy45gAjWQkrFrr00fmT9WBBqSrvrBE5UifQ5ibOsc=;
 b=aMOGbw5cUIzaYqYCkcZqA6NoLUxQ+fwW2AdH1xquLC+lWuvn/ZPJp8J/2Afyv8TYQazntAh6Gh74M6xtsp8km5PCl/jwmJY6RRfEoXDXt7QLTrFWzUfEcXM6TxfUUiiA3jChSXxz9BmOHrTlRTDKWq3Wm2vwAJjmYBXERzOc86LUsMPPBaPF4S/Oy7y/iMCD0V4i8h2J40c6koBZm3Q23LxRjWj4pW0sLBmdwiVdjm96DqWf8qkRQvj5dmLG0M1gTYN6fMLs4KIUI2nmmlZo0gU83tO9Y6/0enSofuYgn1MKDHKjItX2Cir3RG0jm9udhiAgTWFFd+oeW9IOMHTy8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pydy45gAjWQkrFrr00fmT9WBBqSrvrBE5UifQ5ibOsc=;
 b=QOfyvs69YoGrRt12IAGH7ZSvUmGAPg4JSyfAHBHSraPXMOsT5oVAmv2SuZuW8dGgHx1xyHAWuZCIIoeHI3in0fEwm2UL8CDpCK++brDQx//IyyRXoEFR3kmvS3i9qRoa2B/1QqtBYDxWPnsyVtIwPNEIUruW5UtMjUrSRdeagt4=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1747.namprd11.prod.outlook.com (10.175.99.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Mon, 9 Sep 2019 13:38:51 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:38:51 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 07/11] net: aquantia: rx filters for ptp
Thread-Topic: [PATCH net-next 07/11] net: aquantia: rx filters for ptp
Thread-Index: AQHVZxPqD/X/DbWVdkqjILw/trMpzg==
Date:   Mon, 9 Sep 2019 13:38:51 +0000
Message-ID: <62ffbe77085f2e35f8dc231946727669d53fd0d9.1568034880.git.igor.russkikh@aquantia.com>
References: <cover.1568034880.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1568034880.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0298.eurprd05.prod.outlook.com
 (2603:10a6:7:93::29) To BN6PR11MB4081.namprd11.prod.outlook.com
 (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 772a9cf9-6b42-4946-7c9a-08d7352b0c9f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1747;
x-ms-traffictypediagnostic: BN6PR11MB1747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1747023D15B0BE31728F230098B70@BN6PR11MB1747.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:316;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(39850400004)(376002)(136003)(189003)(199004)(26005)(25786009)(6436002)(6486002)(118296001)(305945005)(99286004)(5640700003)(14444005)(256004)(64756008)(1730700003)(107886003)(81166006)(81156014)(66446008)(316002)(478600001)(66476007)(76176011)(4326008)(8676002)(86362001)(52116002)(66556008)(30864003)(53936002)(186003)(2501003)(6506007)(386003)(476003)(11346002)(5660300002)(2616005)(44832011)(66066001)(36756003)(3846002)(8936002)(6512007)(2906002)(486006)(6116002)(71190400001)(14454004)(7736002)(66946007)(6916009)(54906003)(102836004)(50226002)(2351001)(446003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1747;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8lxkPyhXgUcxhpq/V3iEnH+2zbe6VbOHNyEbb6uvYYutYkAhS9i5eTIBExwXVv8plyShoicSWZD+Auu/BcZUZ6162biPe5dAJenpNXgpvmB9eERMvfprsUSbiyvt6F82NTC1OurC+YHRgiSdjowldRFUbmT/lctyp4jgSAocCBdA7Dv3X9lkCj16vaYXmMXriBBsHWA+6HD66PcIp+Sixa+y/bZ4wvBYIOd2F2HJzhDRECY9K/rJiScD2lhHC3P3FiSVYAIJeFUxEKGC8kqGRkYa8K3LZfNsxrDUEZJkjNgEFNdLxy5ycGYSzWugDmkZvz/feXOehZfNr+RRLn7fxTSGMdMUkEDJy6li/1/bPm7mU66Sd5MvPU/1X1SwX0mkq6d7DjaEq9x1pa4BInxwG4Oc4ruxXZWln/REGYw6ppE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772a9cf9-6b42-4946-7c9a-08d7352b0c9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:38:51.0227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TxSZxlEVr+EjL3GvddhfvJ6K7N4Zy7UaPWebKTyxTAV50byeNZn5s7PG5p3/1rsnX279Rej+b27B2511ht+fAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1747
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
index 47b6635ce8a1..a609173e9907 100644
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
@@ -938,6 +943,11 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int =
idx_vec)
 	aq_ptp_clock_init(aq_nic);
 	mutex_unlock(&aq_nic->fwreq_mutex);
=20
+	self->eth_type_filter.location =3D
+			aq_nic_reserve_filter(aq_nic, aq_rx_filter_ethertype);
+	self->udp_filter.location =3D
+			aq_nic_reserve_filter(aq_nic, aq_rx_filter_l3l4);
+
 	return 0;
=20
 err_exit:
@@ -963,6 +973,10 @@ void aq_ptp_free(struct aq_nic_s *aq_nic)
 	if (!self)
 		return;
=20
+	aq_nic_release_filter(aq_nic, aq_rx_filter_ethertype,
+			      self->eth_type_filter.location);
+	aq_nic_release_filter(aq_nic, aq_rx_filter_l3l4,
+			      self->udp_filter.location);
 	/* disable ptp */
 	mutex_lock(&aq_nic->fwreq_mutex);
 	aq_nic->aq_fw_ops->enable_ptp(aq_nic->aq_hw, 0);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 78b0bacb3eb4..5cff68707069 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1238,7 +1238,8 @@ static int hw_atl_b0_hw_fl3l4_set(struct aq_hw_s *sel=
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
@@ -1255,8 +1256,13 @@ static int hw_atl_b0_hw_fl3l4_set(struct aq_hw_s *se=
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

