Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E56CF79B
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfJHK4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:56:47 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:64603
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730026AbfJHK4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:56:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBKUGXh7ifzJiN7t5CfehK5mVKlV1yyR4UoN3yKNYzhySfiYRDB7md2tPVHgcmK3LgcVryp1ATvr9lAdJJSZSTTL0fUYzCvHwzcguioL7ox8Qf1fycgMaF/iH9osTj9aEpHT3xr/atitq3MuhhGJnU8IdUBr8RWEZDhmcHmqdGZ6xbiiyA+mrvI5Pq+mwZ1AWjI1TzyZJrOACDD/o31+5EWTeIuLaioTwwfoxhB7LR8MWUrGdthdQqSf1iIzLMJDm0+wkPzN+L7/wCmjwsJx3iNlFAEhi+qoMDfqTkbJPydHyXtrbdrNtxL8+06VNsF6TVn65+DJPjRisl//GQQKDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WiDXi/GSaQS3MAbXsJgSbWubsr8LY3KR+/NLwnqXBlA=;
 b=hlxEbpaDxNotKE3cBHbHtvwYxOjpVrcD2XIULT/8d5Fq4K3iCEp4ZAHBCkjuwWZUdnwIUeFBKGPUySy+n08bPiwaMQaTg7LbcUXseg6S5IuOc9zJiUcitN4vxSsN4Vl4bmyuN4CLilgDg5g7F1bYXuIkc1Xk1HgPAsfS6gc2kpyAYbtRstgAp1sFzJ3nMFsxAK99qTp+yCusjO+hARKEDdSEkGorgVg2X9xk8qujGuEJJYLIvW7S0X9bHed1Zogos06v3wkbMveQaTU0KE4OomIMOx0VgrePkm42HChxMOywNFiw2Il8trETmrU4swUYk2DXSnhztFtj8ednekn5fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WiDXi/GSaQS3MAbXsJgSbWubsr8LY3KR+/NLwnqXBlA=;
 b=7W/pAEvIFfF2LJlAIFb1RAMWvX4NWRiU4k/akSyI3gSt50i7fMrGOlWd2tkQHjICEctGbEvNapuVzDI997FMr0+7YktVfK5wguxW1j1CFUElAHD0gUGUrQjX9kNiQ0Q9W0aMiTnhvLoGwhTKK3F3gmL148CEn0KJcFuvLjh93YY=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:56:36 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:56:36 +0000
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
Subject: [PATCH v2 net-next 01/12] net: aquantia: PTP skeleton declarations
 and callbacks
Thread-Topic: [PATCH v2 net-next 01/12] net: aquantia: PTP skeleton
 declarations and callbacks
Thread-Index: AQHVfccN+t3u9dEYWUeNTNjmHwlSpA==
Date:   Tue, 8 Oct 2019 10:56:36 +0000
Message-ID: <91d1e1181a01005ef04610241bffb9032f4669b8.1570531332.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: b5bb78c4-8868-47f8-f4dd-08d74bde3029
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3666E4F88BD0A9D653CBC6BE989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:321;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(118296001)(71190400001)(71200400001)(2501003)(256004)(14444005)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(11346002)(5640700003)(6512007)(99286004)(25786009)(66556008)(50226002)(76176011)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(14454004)(26005)(36756003)(86362001)(446003)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WN6zaOsvfIvBHqsWkR3WpBWVW8ieXzc1wkFYmSprOTjoRpQR5prFp4N9ES5RYkwfikK+fKsGtbH/5NujfzxBU/Sj3VPMNZ+Bdv6koQWd/XbIeLM1p9HabeTE2C0nlpjicWV41nZqSflbAHRokx2AijpWEIaKz+q4u9i8AQhCtyWDx02s9ossdP7tkM8onScLelcbX/Sm66I1lCH5adcrjpvkp2TiSzKAfpm65VsvaA0dojnwp6IFlXMWN+/Oyl6JaoU4mQQGFZJQYqQhRCEJG+iMWLPR5vyFoHLb20OnKzSZEs2X0qKw2wBvsNmKNqBPe/BprSjJwfrX6B1i4Su2W8bgqfr3a1xOAOxs8JyGYzH/GKbPyvZAJub1W+D5u3MYmAnra2MrBQ7gRobs922ks7opznxU1waRs2s6BhwGNGk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5bb78c4-8868-47f8-f4dd-08d74bde3029
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:56:36.2421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nGNt0jJRkJ9/ijkoQ8k3zcTHbhFi2cKTacRy6UkkYAM/NgyjT3eb+bndRHWsC/pqva2Oi4oFpnNaKpAu4ZW7Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <egor.pomozov@aquantia.com>

Here we add basic function for PTP clock register/unregister.
We also declare FW/HW capability bits used to control PTP feature
on device.

PTP device is created if network card has appropriate FW that has PTP
enabled in config. HW supports timestamping for PTPv2 802.AS1 and
PTPv2 IPv4 UDP packets.

It also supports basic PTP callbacks for getting/setting time, adjusting
frequency and time as well.

Signed-off-by: Egor Pomozov <egor.pomozov@aquantia.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Co-developed-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/Makefile   |  1 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 10 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  5 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 93 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   | 22 +++++
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   | 85 ++++++++++++++++-
 6 files changed, 210 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_ptp.h

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/=
ethernet/aquantia/atlantic/Makefile
index 131cab855be7..cd12d9d824ec 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -24,6 +24,7 @@ atlantic-objs :=3D aq_main.o \
 	aq_ethtool.o \
 	aq_drvinfo.o \
 	aq_filters.o \
+	aq_ptp.o \
 	hw_atl/hw_atl_a0.o \
 	hw_atl/hw_atl_b0.o \
 	hw_atl/hw_atl_utils.o \
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 8f66e7817811..8721d43fd129 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_nic.c: Definition of common code for NIC. */
@@ -12,6 +12,7 @@
 #include "aq_hw.h"
 #include "aq_pci_func.h"
 #include "aq_main.h"
+#include "aq_ptp.h"
=20
 #include <linux/moduleparam.h>
 #include <linux/netdevice.h>
@@ -331,6 +332,10 @@ int aq_nic_init(struct aq_nic_s *self)
 		self->aq_vecs > i; ++i, aq_vec =3D self->aq_vec[i])
 		aq_vec_init(aq_vec, self->aq_hw_ops, self->aq_hw);
=20
+	err =3D aq_ptp_init(self, self->irqvecs - 1);
+	if (err < 0)
+		goto err_exit;
+
 	netif_carrier_off(self->ndev);
=20
 err_exit:
@@ -970,6 +975,9 @@ void aq_nic_deinit(struct aq_nic_s *self)
 		self->aq_vecs > i; ++i, aq_vec =3D self->aq_vec[i])
 		aq_vec_deinit(aq_vec);
=20
+	aq_ptp_unregister(self);
+	aq_ptp_free(self);
+
 	if (likely(self->aq_fw_ops->deinit)) {
 		mutex_lock(&self->fwreq_mutex);
 		self->aq_fw_ops->deinit(self->aq_hw);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.h
index 255b54a6ae07..d0979bba7ed3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_nic.h: Declaration of common code for NIC. */
@@ -17,6 +17,7 @@ struct aq_ring_s;
 struct aq_hw_ops;
 struct aq_fw_s;
 struct aq_vec_s;
+struct aq_ptp_s;
=20
 struct aq_nic_cfg_s {
 	const struct aq_hw_caps_s *aq_hw_caps;
@@ -108,6 +109,8 @@ struct aq_nic_s {
 	u32 irqvecs;
 	/* mutex to serialize FW interface access operations */
 	struct mutex fwreq_mutex;
+	/* PTP support */
+	struct aq_ptp_s *aq_ptp;
 	struct aq_hw_rx_fltrs_s aq_hw_rx_fltrs;
 };
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
new file mode 100644
index 000000000000..d5a28904f708
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Aquantia Corporation Network Driver
+ * Copyright (C) 2014-2019 Aquantia Corporation. All rights reserved
+ */
+
+/* File aq_ptp.c:
+ * Definition of functions for Linux PTP support.
+ */
+
+#include <linux/ptp_clock_kernel.h>
+#include <linux/clocksource.h>
+
+#include "aq_nic.h"
+#include "aq_ptp.h"
+
+struct aq_ptp_s {
+	struct aq_nic_s *aq_nic;
+
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_info;
+};
+
+static struct ptp_clock_info aq_ptp_clock =3D {
+	.owner		=3D THIS_MODULE,
+	.name		=3D "atlantic ptp",
+	.n_ext_ts	=3D 0,
+	.pps		=3D 0,
+	.n_per_out     =3D 0,
+	.n_pins        =3D 0,
+	.pin_config    =3D NULL,
+};
+
+int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
+{
+	struct hw_atl_utils_mbox mbox;
+	struct ptp_clock *clock;
+	struct aq_ptp_s *aq_ptp;
+	int err =3D 0;
+
+	hw_atl_utils_mpi_read_stats(aq_nic->aq_hw, &mbox);
+
+	if (!(mbox.info.caps_ex & BIT(CAPS_EX_PHY_PTP_EN))) {
+		aq_nic->aq_ptp =3D NULL;
+		return 0;
+	}
+
+	aq_ptp =3D kzalloc(sizeof(*aq_ptp), GFP_KERNEL);
+	if (!aq_ptp) {
+		err =3D -ENOMEM;
+		goto err_exit;
+	}
+
+	aq_ptp->aq_nic =3D aq_nic;
+
+	aq_ptp->ptp_info =3D aq_ptp_clock;
+	clock =3D ptp_clock_register(&aq_ptp->ptp_info, &aq_nic->ndev->dev);
+	if (!clock) {
+		netdev_err(aq_nic->ndev, "ptp_clock_register failed\n");
+		err =3D 0;
+		goto err_exit;
+	}
+	aq_ptp->ptp_clock =3D clock;
+
+	aq_nic->aq_ptp =3D aq_ptp;
+
+	return 0;
+
+err_exit:
+	kfree(aq_ptp);
+	aq_nic->aq_ptp =3D NULL;
+	return err;
+}
+
+void aq_ptp_unregister(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+
+	if (!aq_ptp)
+		return;
+
+	ptp_clock_unregister(aq_ptp->ptp_clock);
+}
+
+void aq_ptp_free(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+
+	if (!aq_ptp)
+		return;
+
+	kfree(aq_ptp);
+	aq_nic->aq_ptp =3D NULL;
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.h
new file mode 100644
index 000000000000..cea238959b20
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Aquantia Corporation Network Driver
+ * Copyright (C) 2014-2019 Aquantia Corporation. All rights reserved
+ */
+
+/* File aq_ptp.h: Declaration of PTP functions.
+ */
+#ifndef AQ_PTP_H
+#define AQ_PTP_H
+
+#include <linux/net_tstamp.h>
+#include <linux/version.h>
+
+/* Common functions */
+int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec);
+
+void aq_ptp_unregister(struct aq_nic_s *aq_nic);
+void aq_ptp_free(struct aq_nic_s *aq_nic);
+
+void aq_ptp_clock_init(struct aq_nic_s *aq_nic);
+
+#endif /* AQ_PTP_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 692bed70e104..7121248954df 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_utils.h: Declaration of common functions for Atlantic hardw=
are
@@ -168,6 +168,34 @@ struct __packed hw_atl_utils_mbox_header {
 	u32 error;
 };
=20
+struct __packed hw_aq_ptp_offset {
+	u16 ingress_100;
+	u16 egress_100;
+	u16 ingress_1000;
+	u16 egress_1000;
+	u16 ingress_2500;
+	u16 egress_2500;
+	u16 ingress_5000;
+	u16 egress_5000;
+	u16 ingress_10000;
+	u16 egress_10000;
+};
+
+enum gpio_pin_function {
+	GPIO_PIN_FUNCTION_NC,
+	GPIO_PIN_FUNCTION_VAUX_ENABLE,
+	GPIO_PIN_FUNCTION_EFUSE_BURN_ENABLE,
+	GPIO_PIN_FUNCTION_SFP_PLUS_DETECT,
+	GPIO_PIN_FUNCTION_TX_DISABLE,
+	GPIO_PIN_FUNCTION_RATE_SEL_0,
+	GPIO_PIN_FUNCTION_RATE_SEL_1,
+	GPIO_PIN_FUNCTION_TX_FAULT,
+	GPIO_PIN_FUNCTION_PTP0,
+	GPIO_PIN_FUNCTION_PTP1,
+	GPIO_PIN_FUNCTION_PTP2,
+	GPIO_PIN_FUNCTION_SIZE
+};
+
 struct __packed hw_aq_info {
 	u8 reserved[6];
 	u16 phy_fault_code;
@@ -175,9 +203,23 @@ struct __packed hw_aq_info {
 	u8 cable_len;
 	u8 reserved1;
 	u32 cable_diag_data[4];
-	u8 reserved2[32];
+	struct hw_aq_ptp_offset ptp_offset;
+	u8 reserved2[12];
 	u32 caps_lo;
 	u32 caps_hi;
+	u32 reserved_datapath;
+	u32 reserved3[7];
+	u32 reserved_simpleresp[3];
+	u32 reserved_linkstat[7];
+	u32 reserved_wakes_count;
+	u32 reserved_eee_stat[12];
+	u32 tx_stuck_cnt;
+	u32 setting_address;
+	u32 setting_length;
+	u32 caps_ex;
+	enum gpio_pin_function gpio_pin[3];
+	u32 pcie_aer_dump[18];
+	u16 snr_margin[4];
 };
=20
 struct __packed hw_atl_utils_mbox {
@@ -372,7 +414,7 @@ enum hw_atl_fw2x_caps_hi {
 	CAPS_HI_2P5GBASET_FD_EEE,
 	CAPS_HI_5GBASET_FD_EEE,
 	CAPS_HI_10GBASET_FD_EEE,
-	CAPS_HI_RESERVED5,
+	CAPS_HI_FW_REQUEST,
 	CAPS_HI_RESERVED6,
 	CAPS_HI_RESERVED7,
 	CAPS_HI_RESERVED8,
@@ -380,7 +422,7 @@ enum hw_atl_fw2x_caps_hi {
 	CAPS_HI_CABLE_DIAG,
 	CAPS_HI_TEMPERATURE,
 	CAPS_HI_DOWNSHIFT,
-	CAPS_HI_PTP_AVB_EN,
+	CAPS_HI_PTP_AVB_EN_FW2X   =3D 20,
 	CAPS_HI_MEDIA_DETECT,
 	CAPS_HI_LINK_DROP,
 	CAPS_HI_SLEEP_PROXY,
@@ -429,6 +471,41 @@ enum hw_atl_fw2x_ctrl {
 	CTRL_FORCE_RECONNECT,
 };
=20
+enum hw_atl_caps_ex {
+	CAPS_EX_LED_CONTROL       =3D  0,
+	CAPS_EX_LED0_MODE_LO,
+	CAPS_EX_LED0_MODE_HI,
+	CAPS_EX_LED1_MODE_LO,
+	CAPS_EX_LED1_MODE_HI,
+	CAPS_EX_LED2_MODE_LO      =3D  5,
+	CAPS_EX_LED2_MODE_HI,
+	CAPS_EX_RESERVED07,
+	CAPS_EX_RESERVED08,
+	CAPS_EX_RESERVED09,
+	CAPS_EX_RESERVED10        =3D 10,
+	CAPS_EX_RESERVED11,
+	CAPS_EX_RESERVED12,
+	CAPS_EX_RESERVED13,
+	CAPS_EX_RESERVED14,
+	CAPS_EX_RESERVED15        =3D 15,
+	CAPS_EX_PHY_PTP_EN,
+	CAPS_EX_MAC_PTP_EN,
+	CAPS_EX_EXT_CLK_EN,
+	CAPS_EX_SCHED_DMA_EN,
+	CAPS_EX_PTP_GPIO_EN       =3D 20,
+	CAPS_EX_UPDATE_SETTINGS,
+	CAPS_EX_PHY_CTRL_TS_PIN,
+	CAPS_EX_SNR_OPERATING_MARGIN,
+	CAPS_EX_RESERVED24,
+	CAPS_EX_RESERVED25        =3D 25,
+	CAPS_EX_RESERVED26,
+	CAPS_EX_RESERVED27,
+	CAPS_EX_RESERVED28,
+	CAPS_EX_RESERVED29,
+	CAPS_EX_RESERVED30        =3D 30,
+	CAPS_EX_RESERVED31
+};
+
 struct aq_hw_s;
 struct aq_fw_ops;
 struct aq_hw_caps_s;
--=20
2.17.1

