Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873BFCF7A5
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbfJHK5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:57:10 -0400
Received: from mail-eopbgr750051.outbound.protection.outlook.com ([40.107.75.51]:48528
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729893AbfJHK5J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:57:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilYHGBkwMTVan0IYvt3R5ivV+eRQHzzFb5vfsxsQD36zZP0M5eLNhKUs0nWq2QZ7ctju2gZ2kGHjdtuGI2VLemZelW+Qd1NaEj7PDwYs3RuBLIWEDdHqtOW1r7WK++KxvVo4XysSWTuJTYq5/kdibzpXKmLso4/zNJhvebznDWAGIj2l6MEJEdlyVZEGZMYw09MskI1uvjr6bYAnOwHQPTk4tKP4cLfRvO2Ys0RorTaMIIIVgs0XB5CqVL/AUBL9TnjjmAbvzSbiRJr5n/8fn4C0PRJB9HbPha+szZWd/ylO0daTwg6oQQnu2NqLFAGragu06pGAtg3LOtR5kFU8dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTZ0ksdh+d2yK/so4WWu4g/bLGNTJL0LcHsYWvNjfVo=;
 b=mUR4PRGnhmzOgn7ZgpNpSNJ8kWii2VWCW5JqkcoouT3eeXuOOHGz5YyZEUEFGlte8r5jGvIzVzsJt7p9yS8WJnD/FC+bsQWhQBuuGeOGWWmxhVMaaoSGz2+vkTLd0UpGDgw2Ne7ob7GbWIbvToEEPxZD94hWJ1WtMhlZvtcOLsmfzwdmTk7HPYiNiBzQMSautFvldLCCXAGrgp5QLK8YfOGk91QqCbZ56uM+USQa8mz5fmzdvXxbDK6cc9adSTrf0hGJbKGBMZeFrUcdQ2s3tDY0qJt3kFlzzyCouaguZoDNYbar1rCh5FxOyh6jdPjH6ZlyxugCGDX+OEVZsIT78w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTZ0ksdh+d2yK/so4WWu4g/bLGNTJL0LcHsYWvNjfVo=;
 b=EjoWtWqF0qGCfMSQSX424SwsDXREfNyR6koK6XyuQzMu/JKiN7Qbnl5F4VwtsWR5z2ugFTUqQPchZ6cbkbWkrn9RUPPdE7JsNNuhi+hvOPPpOk8HKZXxGw9bi+VTdYP/hXneFLbHF3BrzdUYkppQGTJ/E4UW/HL4G3RV3pVYcs4=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:56:57 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:56:57 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH v2 net-next 10/12] net: aquantia: add support for Phy access
Thread-Topic: [PATCH v2 net-next 10/12] net: aquantia: add support for Phy
 access
Thread-Index: AQHVfccaHm7vyqrB/0i0TJjnhG/Tmw==
Date:   Tue, 8 Oct 2019 10:56:56 +0000
Message-ID: <09f7d525783b31730ca3bdbaa52c962a141284a5.1570531332.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: b41a9814-259b-4405-2d6a-08d74bde3c81
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3666794F0B2F12DD2210FCD4989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:212;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(118296001)(71190400001)(71200400001)(2501003)(256004)(14444005)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(11346002)(5640700003)(6512007)(99286004)(25786009)(66556008)(50226002)(76176011)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(30864003)(14454004)(26005)(36756003)(86362001)(446003)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8h4CMjRcfaz5WzNeAMF5zCXvn0ln+P+aX2BHYSAtD55BMn5WVBlA9Jyy3HOmaQiGPs8a9kxfk4qkxSF2q64hgLGlYKGxq6pbgK1Mw67U0t51c19yugxAcqRHdXFf9rRjsMx4MfkoMHMqzkV/NF35fvbTxaQXqlDmfvGNvnBDGuLK4D6eqHkardkRi4BAMn/+g0/XEJRqk9LI+heE7vdVZ1z9zjHEBs3unfu6uWSSwWavO7lidhfvt6NaXs6mBDHTPWVIiG4ri+KivgGTGMAPiX+TH6CoAqQZhln2va0N8NANph5nqsW+oy12cK9AnwlarC/kPO7ffevIqKrA4Qxq4GivzJpINUR0D0xYZ6n+R4bomiWZ2aCsWwuIjcQGI0ctG9yC6rvGUG1m/wePnjIYcHTruVf1WjZcX7NEBqQnP9k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41a9814-259b-4405-2d6a-08d74bde3c81
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:56:56.9364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SqTFA+i0fHoYH2cZSIm+UX+9nVLlf8rq+5g0l+GiFZswwDarU36q3Mc4R+Zz90GgwIUnD1BN9UUN8DS1p3JacQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

GPIO PIN control and access is done by direct phy manipulation.
Here we add an aq_phy module which is able to access phy registers
via MDIO access mailbox.

Access is controlled via HW semaphore.

Co-developed-by: Nikita Danilov <nikita.danilov@aquantia.com>
Signed-off-by: Nikita Danilov <nikita.danilov@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/Makefile   |   1 +
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   1 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   6 +
 .../net/ethernet/aquantia/atlantic/aq_phy.c   | 147 ++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_phy.h   |  32 ++++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  62 ++++++++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |  35 +++++
 .../atlantic/hw_atl/hw_atl_llh_internal.h     | 115 ++++++++++++++
 8 files changed, 399 insertions(+)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_phy.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_phy.h

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/=
ethernet/aquantia/atlantic/Makefile
index cd12d9d824ec..68c41141ede2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -25,6 +25,7 @@ atlantic-objs :=3D aq_main.o \
 	aq_drvinfo.o \
 	aq_filters.o \
 	aq_ptp.o \
+	aq_phy.o \
 	hw_atl/hw_atl_a0.o \
 	hw_atl/hw_atl_b0.o \
 	hw_atl/hw_atl_utils.o \
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index 5b0f42818033..c36c0d7d038e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -140,6 +140,7 @@ struct aq_hw_s {
 	u32 rpc_tid;
 	struct hw_atl_utils_fw_rpc rpc;
 	s64 ptp_clk_offset;
+	u16 phy_id;
 };
=20
 struct aq_ring_s;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 03ec778d0fcc..b7960490ca90 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -12,6 +12,7 @@
 #include "aq_hw.h"
 #include "aq_pci_func.h"
 #include "aq_main.h"
+#include "aq_phy.h"
 #include "aq_ptp.h"
 #include "aq_filters.h"
=20
@@ -337,6 +338,11 @@ int aq_nic_init(struct aq_nic_s *self)
 	if (err < 0)
 		goto err_exit;
=20
+	if (self->aq_nic_cfg.aq_hw_caps->media_type =3D=3D AQ_HW_MEDIA_TYPE_TP) {
+		self->aq_hw->phy_id =3D HW_ATL_PHY_ID_MAX;
+		err =3D aq_phy_init(self->aq_hw);
+	}
+
 	for (i =3D 0U, aq_vec =3D self->aq_vec[0];
 		self->aq_vecs > i; ++i, aq_vec =3D self->aq_vec[i])
 		aq_vec_init(aq_vec, self->aq_hw_ops, self->aq_hw);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_phy.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_phy.c
new file mode 100644
index 000000000000..51ae921e3e1f
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_phy.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* aQuantia Corporation Network Driver
+ * Copyright (C) 2018-2019 aQuantia Corporation. All rights reserved
+ */
+
+#include "aq_phy.h"
+
+bool aq_mdio_busy_wait(struct aq_hw_s *aq_hw)
+{
+	int err =3D 0;
+	u32 val;
+
+	err =3D readx_poll_timeout_atomic(hw_atl_mdio_busy_get, aq_hw,
+					val, val =3D=3D 0U, 10U, 100000U);
+
+	if (err < 0)
+		return false;
+
+	return true;
+}
+
+u16 aq_mdio_read_word(struct aq_hw_s *aq_hw, u16 mmd, u16 addr)
+{
+	u16 phy_addr =3D aq_hw->phy_id << 5 | mmd;
+
+	/* Set Address register. */
+	hw_atl_glb_mdio_iface4_set(aq_hw, (addr & HW_ATL_MDIO_ADDRESS_MSK) <<
+				   HW_ATL_MDIO_ADDRESS_SHIFT);
+	/* Send Address command. */
+	hw_atl_glb_mdio_iface2_set(aq_hw, HW_ATL_MDIO_EXECUTE_OPERATION_MSK |
+				   (3 << HW_ATL_MDIO_OP_MODE_SHIFT) |
+				   ((phy_addr & HW_ATL_MDIO_PHY_ADDRESS_MSK) <<
+				    HW_ATL_MDIO_PHY_ADDRESS_SHIFT));
+
+	aq_mdio_busy_wait(aq_hw);
+
+	/* Send Read command. */
+	hw_atl_glb_mdio_iface2_set(aq_hw, HW_ATL_MDIO_EXECUTE_OPERATION_MSK |
+				   (1 << HW_ATL_MDIO_OP_MODE_SHIFT) |
+				   ((phy_addr & HW_ATL_MDIO_PHY_ADDRESS_MSK) <<
+				    HW_ATL_MDIO_PHY_ADDRESS_SHIFT));
+	/* Read result. */
+	aq_mdio_busy_wait(aq_hw);
+
+	return (u16)hw_atl_glb_mdio_iface5_get(aq_hw);
+}
+
+void aq_mdio_write_word(struct aq_hw_s *aq_hw, u16 mmd, u16 addr, u16 data=
)
+{
+	u16 phy_addr =3D aq_hw->phy_id << 5 | mmd;
+
+	/* Set Address register. */
+	hw_atl_glb_mdio_iface4_set(aq_hw, (addr & HW_ATL_MDIO_ADDRESS_MSK) <<
+				   HW_ATL_MDIO_ADDRESS_SHIFT);
+	/* Send Address command. */
+	hw_atl_glb_mdio_iface2_set(aq_hw, HW_ATL_MDIO_EXECUTE_OPERATION_MSK |
+				   (3 << HW_ATL_MDIO_OP_MODE_SHIFT) |
+				   ((phy_addr & HW_ATL_MDIO_PHY_ADDRESS_MSK) <<
+				    HW_ATL_MDIO_PHY_ADDRESS_SHIFT));
+
+	aq_mdio_busy_wait(aq_hw);
+
+	hw_atl_glb_mdio_iface3_set(aq_hw, (data & HW_ATL_MDIO_WRITE_DATA_MSK) <<
+				   HW_ATL_MDIO_WRITE_DATA_SHIFT);
+	/* Send Write command. */
+	hw_atl_glb_mdio_iface2_set(aq_hw, HW_ATL_MDIO_EXECUTE_OPERATION_MSK |
+				   (2 << HW_ATL_MDIO_OP_MODE_SHIFT) |
+				   ((phy_addr & HW_ATL_MDIO_PHY_ADDRESS_MSK) <<
+				    HW_ATL_MDIO_PHY_ADDRESS_SHIFT));
+
+	aq_mdio_busy_wait(aq_hw);
+}
+
+u16 aq_phy_read_reg(struct aq_hw_s *aq_hw, u16 mmd, u16 address)
+{
+	int err =3D 0;
+	u32 val;
+
+	err =3D readx_poll_timeout_atomic(hw_atl_sem_mdio_get, aq_hw,
+					val, val =3D=3D 1U, 10U, 100000U);
+
+	if (err < 0) {
+		err =3D 0xffff;
+		goto err_exit;
+	}
+
+	err =3D aq_mdio_read_word(aq_hw, mmd, address);
+
+	hw_atl_reg_glb_cpu_sem_set(aq_hw, 1U, HW_ATL_FW_SM_MDIO);
+
+err_exit:
+	return err;
+}
+
+void aq_phy_write_reg(struct aq_hw_s *aq_hw, u16 mmd, u16 address, u16 dat=
a)
+{
+	int err =3D 0;
+	u32 val;
+
+	err =3D readx_poll_timeout_atomic(hw_atl_sem_mdio_get, aq_hw,
+					val, val =3D=3D 1U, 10U, 100000U);
+	if (err < 0)
+		return;
+
+	aq_mdio_write_word(aq_hw, mmd, address, data);
+	hw_atl_reg_glb_cpu_sem_set(aq_hw, 1U, HW_ATL_FW_SM_MDIO);
+}
+
+bool aq_phy_init_phy_id(struct aq_hw_s *aq_hw)
+{
+	u16 val;
+
+	for (aq_hw->phy_id =3D 0; aq_hw->phy_id < HW_ATL_PHY_ID_MAX;
+	     ++aq_hw->phy_id) {
+		/* PMA Standard Device Identifier 2: Address 1.3 */
+		val =3D aq_phy_read_reg(aq_hw, MDIO_MMD_PMAPMD, 3);
+
+		if (val !=3D 0xffff)
+			return true;
+	}
+
+	return false;
+}
+
+bool aq_phy_init(struct aq_hw_s *aq_hw)
+{
+	u32 dev_id;
+
+	if (aq_hw->phy_id =3D=3D HW_ATL_PHY_ID_MAX)
+		if (!aq_phy_init_phy_id(aq_hw))
+			return false;
+
+	/* PMA Standard Device Identifier:
+	 * Address 1.2 =3D MSW,
+	 * Address 1.3 =3D LSW
+	 */
+	dev_id =3D aq_phy_read_reg(aq_hw, MDIO_MMD_PMAPMD, 2);
+	dev_id <<=3D 16;
+	dev_id |=3D aq_phy_read_reg(aq_hw, MDIO_MMD_PMAPMD, 3);
+
+	if (dev_id =3D=3D 0xffffffff) {
+		aq_hw->phy_id =3D HW_ATL_PHY_ID_MAX;
+		return false;
+	}
+
+	return true;
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_phy.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_phy.h
new file mode 100644
index 000000000000..84b72ad04a4a
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_phy.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* aQuantia Corporation Network Driver
+ * Copyright (C) 2018-2019 aQuantia Corporation. All rights reserved
+ */
+
+#ifndef AQ_PHY_H
+#define AQ_PHY_H
+
+#include <linux/mdio.h>
+
+#include "hw_atl/hw_atl_llh.h"
+#include "hw_atl/hw_atl_llh_internal.h"
+#include "aq_hw_utils.h"
+#include "aq_hw.h"
+
+#define HW_ATL_PHY_ID_MAX 32U
+
+bool aq_mdio_busy_wait(struct aq_hw_s *aq_hw);
+
+u16 aq_mdio_read_word(struct aq_hw_s *aq_hw, u16 mmd, u16 addr);
+
+void aq_mdio_write_word(struct aq_hw_s *aq_hw, u16 mmd, u16 addr, u16 data=
);
+
+u16 aq_phy_read_reg(struct aq_hw_s *aq_hw, u16 mmd, u16 address);
+
+void aq_phy_write_reg(struct aq_hw_s *aq_hw, u16 mmd, u16 address, u16 dat=
a);
+
+bool aq_phy_init_phy_id(struct aq_hw_s *aq_hw);
+
+bool aq_phy_init(struct aq_hw_s *aq_hw);
+
+#endif /* AQ_PHY_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 255572f00bbc..340f433a7e9b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -1631,6 +1631,11 @@ u32 hw_atl_sem_ram_get(struct aq_hw_s *self)
 	return hw_atl_reg_glb_cpu_sem_get(self, HW_ATL_FW_SM_RAM);
 }
=20
+u32 hw_atl_sem_mdio_get(struct aq_hw_s *self)
+{
+	return hw_atl_reg_glb_cpu_sem_get(self, HW_ATL_FW_SM_MDIO);
+}
+
 u32 hw_atl_scrpad_get(struct aq_hw_s *aq_hw, u32 scratch_scp)
 {
 	return aq_hw_read_reg(aq_hw,
@@ -1646,3 +1651,60 @@ u32 hw_atl_scrpad25_get(struct aq_hw_s *self)
 {
 	return hw_atl_scrpad_get(self, 0x18);
 }
+
+void hw_atl_glb_mdio_iface1_set(struct aq_hw_s *aq_hw, u32 value)
+{
+	aq_hw_write_reg(aq_hw, HW_ATL_GLB_MDIO_IFACE_N_ADR(1), value);
+}
+
+u32 hw_atl_glb_mdio_iface1_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg(aq_hw, HW_ATL_GLB_MDIO_IFACE_N_ADR(1));
+}
+
+void hw_atl_glb_mdio_iface2_set(struct aq_hw_s *aq_hw, u32 value)
+{
+	aq_hw_write_reg(aq_hw, HW_ATL_GLB_MDIO_IFACE_N_ADR(2), value);
+}
+
+u32 hw_atl_glb_mdio_iface2_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg(aq_hw, HW_ATL_GLB_MDIO_IFACE_N_ADR(2));
+}
+
+void hw_atl_glb_mdio_iface3_set(struct aq_hw_s *aq_hw, u32 value)
+{
+	aq_hw_write_reg(aq_hw, HW_ATL_GLB_MDIO_IFACE_N_ADR(3), value);
+}
+
+u32 hw_atl_glb_mdio_iface3_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg(aq_hw, HW_ATL_GLB_MDIO_IFACE_N_ADR(3));
+}
+
+void hw_atl_glb_mdio_iface4_set(struct aq_hw_s *aq_hw, u32 value)
+{
+	aq_hw_write_reg(aq_hw, HW_ATL_GLB_MDIO_IFACE_N_ADR(4), value);
+}
+
+u32 hw_atl_glb_mdio_iface4_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg(aq_hw, HW_ATL_GLB_MDIO_IFACE_N_ADR(4));
+}
+
+void hw_atl_glb_mdio_iface5_set(struct aq_hw_s *aq_hw, u32 value)
+{
+	aq_hw_write_reg(aq_hw, HW_ATL_GLB_MDIO_IFACE_N_ADR(5), value);
+}
+
+u32 hw_atl_glb_mdio_iface5_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg(aq_hw, HW_ATL_GLB_MDIO_IFACE_N_ADR(5));
+}
+
+u32 hw_atl_mdio_busy_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, HW_ATL_MDIO_BUSY_ADR,
+				  HW_ATL_MDIO_BUSY_MSK,
+				  HW_ATL_MDIO_BUSY_SHIFT);
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index 00b41fe5f1eb..bfb75ffe315f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -764,9 +764,44 @@ void hw_atl_rpfl3l4_ipv6_src_addr_set(struct aq_hw_s *=
aq_hw, u8 location,
 void hw_atl_rpfl3l4_ipv6_dest_addr_set(struct aq_hw_s *aq_hw, u8 location,
 				       u32 *ipv6_dest);
=20
+/* set Global MDIO Interface 1 */
+void hw_atl_glb_mdio_iface1_set(struct aq_hw_s *hw, u32 value);
+
+/* get Global MDIO Interface 1 */
+u32 hw_atl_glb_mdio_iface1_get(struct aq_hw_s *hw);
+
+/* set Global MDIO Interface 2 */
+void hw_atl_glb_mdio_iface2_set(struct aq_hw_s *hw, u32 value);
+
+/* get Global MDIO Interface 2 */
+u32 hw_atl_glb_mdio_iface2_get(struct aq_hw_s *hw);
+
+/* set Global MDIO Interface 3 */
+void hw_atl_glb_mdio_iface3_set(struct aq_hw_s *hw, u32 value);
+
+/* get Global MDIO Interface 3 */
+u32 hw_atl_glb_mdio_iface3_get(struct aq_hw_s *hw);
+
+/* set Global MDIO Interface 4 */
+void hw_atl_glb_mdio_iface4_set(struct aq_hw_s *hw, u32 value);
+
+/* get Global MDIO Interface 4 */
+u32 hw_atl_glb_mdio_iface4_get(struct aq_hw_s *hw);
+
+/* set Global MDIO Interface 5 */
+void hw_atl_glb_mdio_iface5_set(struct aq_hw_s *hw, u32 value);
+
+/* get Global MDIO Interface 5 */
+u32 hw_atl_glb_mdio_iface5_get(struct aq_hw_s *hw);
+
+u32 hw_atl_mdio_busy_get(struct aq_hw_s *aq_hw);
+
 /* get global microprocessor ram semaphore */
 u32 hw_atl_sem_ram_get(struct aq_hw_s *self);
=20
+/* get global microprocessor mdio semaphore */
+u32 hw_atl_sem_mdio_get(struct aq_hw_s *self);
+
 /* get global microprocessor scratch pad register */
 u32 hw_atl_scrpad_get(struct aq_hw_s *aq_hw, u32 scratch_scp);
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_inter=
nal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index 79d5adc77e42..9526be06051d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -2575,6 +2575,121 @@
 /* default value of bitfield uP Force Interrupt */
 #define HW_ATL_MCP_UP_FORCE_INTERRUPT_DEFAULT 0x0
=20
+/* Preprocessor definitions for Global MDIO Interfaces
+ * Address: 0x00000280 + 0x4 * Number of interface
+ */
+#define HW_ATL_GLB_MDIO_IFACE_ADDR_BEGIN   0x00000280u
+
+#define HW_ATL_GLB_MDIO_IFACE_N_ADR(number) \
+	(HW_ATL_GLB_MDIO_IFACE_ADDR_BEGIN + (((number) - 1) * 0x4))
+
+/* MIF MDIO Busy Bitfield Definitions
+ * Preprocessor definitions for the bitfield "MDIO Busy".
+ * PORT=3D"mdio_pif_busy_o"
+ */
+
+/* Register address for bitfield MDIO Busy */
+#define HW_ATL_MDIO_BUSY_ADR 0x00000284
+/* Bitmask for bitfield MDIO Busy */
+#define HW_ATL_MDIO_BUSY_MSK 0x80000000
+/* Inverted bitmask for bitfield MDIO Busy */
+#define HW_ATL_MDIO_BUSY_MSKN 0x7FFFFFFF
+/* Lower bit position of bitfield MDIO Busy */
+#define HW_ATL_MDIO_BUSY_SHIFT 31
+/* Width of bitfield MDIO Busy */
+#define HW_ATL_MDIO_BUSY_WIDTH 1
+
+/* MIF MDIO Execute Operation Bitfield Definitions
+ * Preprocessor definitions for the bitfield "MDIO Execute Operation".
+ * PORT=3D"pif_mdio_op_start_i"
+ */
+
+/* Register address for bitfield MDIO Execute Operation */
+#define HW_ATL_MDIO_EXECUTE_OPERATION_ADR 0x00000284
+/* Bitmask for bitfield MDIO Execute Operation */
+#define HW_ATL_MDIO_EXECUTE_OPERATION_MSK 0x00008000
+/* Inverted bitmask for bitfield MDIO Execute Operation */
+#define HW_ATL_MDIO_EXECUTE_OPERATION_MSKN 0xFFFF7FFF
+/* Lower bit position of bitfield MDIO Execute Operation */
+#define HW_ATL_MDIO_EXECUTE_OPERATION_SHIFT 15
+/* Width of bitfield MDIO Execute Operation */
+#define HW_ATL_MDIO_EXECUTE_OPERATION_WIDTH 1
+/* Default value of bitfield MDIO Execute Operation */
+#define HW_ATL_MDIO_EXECUTE_OPERATION_DEFAULT 0x0
+
+/* MIF Op Mode [1:0] Bitfield Definitions
+ * Preprocessor definitions for the bitfield "Op Mode [1:0]".
+ * PORT=3D"pif_mdio_mode_i[1:0]"
+ */
+
+/* Register address for bitfield Op Mode [1:0] */
+#define HW_ATL_MDIO_OP_MODE_ADR 0x00000284
+/* Bitmask for bitfield Op Mode [1:0] */
+#define HW_ATL_MDIO_OP_MODE_MSK 0x00003000
+/* Inverted bitmask for bitfield Op Mode [1:0] */
+#define HW_ATL_MDIO_OP_MODE_MSKN 0xFFFFCFFF
+/* Lower bit position of bitfield Op Mode [1:0] */
+#define HW_ATL_MDIO_OP_MODE_SHIFT 12
+/* Width of bitfield Op Mode [1:0] */
+#define HW_ATL_MDIO_OP_MODE_WIDTH 2
+/* Default value of bitfield Op Mode [1:0] */
+#define HW_ATL_MDIO_OP_MODE_DEFAULT 0x0
+
+/* MIF PHY address Bitfield Definitions
+ * Preprocessor definitions for the bitfield "PHY address".
+ * PORT=3D"pif_mdio_phy_addr_i[9:0]"
+ */
+
+/* Register address for bitfield PHY address */
+#define HW_ATL_MDIO_PHY_ADDRESS_ADR 0x00000284
+/* Bitmask for bitfield PHY address */
+#define HW_ATL_MDIO_PHY_ADDRESS_MSK 0x000003FF
+/* Inverted bitmask for bitfield PHY address */
+#define HW_ATL_MDIO_PHY_ADDRESS_MSKN 0xFFFFFC00
+/* Lower bit position of bitfield PHY address */
+#define HW_ATL_MDIO_PHY_ADDRESS_SHIFT 0
+/* Width of bitfield PHY address */
+#define HW_ATL_MDIO_PHY_ADDRESS_WIDTH 10
+/* Default value of bitfield PHY address */
+#define HW_ATL_MDIO_PHY_ADDRESS_DEFAULT 0x0
+
+/* MIF MDIO WriteData [F:0] Bitfield Definitions
+ * Preprocessor definitions for the bitfield "MDIO WriteData [F:0]".
+ * PORT=3D"pif_mdio_wdata_i[15:0]"
+ */
+
+/* Register address for bitfield MDIO WriteData [F:0] */
+#define HW_ATL_MDIO_WRITE_DATA_ADR 0x00000288
+/* Bitmask for bitfield MDIO WriteData [F:0] */
+#define HW_ATL_MDIO_WRITE_DATA_MSK 0x0000FFFF
+/* Inverted bitmask for bitfield MDIO WriteData [F:0] */
+#define HW_ATL_MDIO_WRITE_DATA_MSKN 0xFFFF0000
+/* Lower bit position of bitfield MDIO WriteData [F:0] */
+#define HW_ATL_MDIO_WRITE_DATA_SHIFT 0
+/* Width of bitfield MDIO WriteData [F:0] */
+#define HW_ATL_MDIO_WRITE_DATA_WIDTH 16
+/* Default value of bitfield MDIO WriteData [F:0] */
+#define HW_ATL_MDIO_WRITE_DATA_DEFAULT 0x0
+
+/* MIF MDIO Address [F:0] Bitfield Definitions
+ * Preprocessor definitions for the bitfield "MDIO Address [F:0]".
+ * PORT=3D"pif_mdio_addr_i[15:0]"
+ */
+
+/* Register address for bitfield MDIO Address [F:0] */
+#define HW_ATL_MDIO_ADDRESS_ADR 0x0000028C
+/* Bitmask for bitfield MDIO Address [F:0] */
+#define HW_ATL_MDIO_ADDRESS_MSK 0x0000FFFF
+/* Inverted bitmask for bitfield MDIO Address [F:0] */
+#define HW_ATL_MDIO_ADDRESS_MSKN 0xFFFF0000
+/* Lower bit position of bitfield MDIO Address [F:0] */
+#define HW_ATL_MDIO_ADDRESS_SHIFT 0
+/* Width of bitfield MDIO Address [F:0] */
+#define HW_ATL_MDIO_ADDRESS_WIDTH 16
+/* Default value of bitfield MDIO Address [F:0] */
+#define HW_ATL_MDIO_ADDRESS_DEFAULT 0x0
+
+#define HW_ATL_FW_SM_MDIO       0x0U
 #define HW_ATL_FW_SM_RAM        0x2U
=20
 #endif /* HW_ATL_LLH_INTERNAL_H */
--=20
2.17.1

