Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7D7E012E
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731537AbfJVJx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:53:27 -0400
Received: from mail-eopbgr780077.outbound.protection.outlook.com ([40.107.78.77]:64688
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730619AbfJVJx0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:53:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RL/yfDSMwpBTQBgUbGj5pJ3c/bPNfBDxM1MToXsTQp9H21GH7NIAZy/edIlmdsr1YAt++2U5qrUrW4ayBquSwDM5t+g98y36lnf8/8vsHnnUo8iZxqoJJXe6TR6o/5ZgX7LQzuVIOtB7SLdUnDwPccbyF9GhhbhznUaz5wR2HA6dy5nsMCcn9wR4rSRENZaRmdXiRmAhbgvslUkggzeZ8f2xE1PSa6CbmOjb7/Y20stVUphj3MAIlryFDMRvab07oZxXuQ/G1jyOsncppgIimf/8+yeYBgJjtnBMpG1lUojOKJcl0ouKBpWjjig6DMion5R1dhUHL9xa0h6dOW+bjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lx8DDh+sG6aB4+7McDO0/3YCFo2jpmVeHHEDSqvVC6w=;
 b=a5T7RmG6+0zFzlZwDe6x1R2aeZv+/n3BFmZGFgb4aaqTEorabjy/rl5/qQNjeAS4f6TVCyrpCmTu12XWflmeNqtyObBCV/Ou1SwsS+ZkoD53iyEPw47/A7XadBMsrY93+TOEPpZ7kqOxSF80Y1V8LZ26W10iADcQGG29Pf2y45FDSpr6Mjt7uFi+r6yeSdFE8HqAH3Al9ir73+7IpVzggRkly91Z6UaBb7Rmua+CdeDD6cIcTm6JtF7o44b3RPlvEm6DJ97KCs5z5BXSoHno93M5W5PxeawqtnoZjY4t0qmAnX5ffcqCEa6t/CevnW6hk7eqWQk59PgCoXbIKt+dwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lx8DDh+sG6aB4+7McDO0/3YCFo2jpmVeHHEDSqvVC6w=;
 b=LqPmFFNE/n6rj8CAoaXlioc9Df5dWc+H64yv5tvhN6DgJtAED1dJ7bt9ha/43SvJ68Bgb5pCsLvSRljhEiOWbhY5iYquS1r3z5h7Fk8NNtF2WqznhFJcqsfzh5VSyhjUNWtSPm3b3cSwIhnZ/xXQ9cfAkVv9kNR2qiMgiWYerns=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3732.namprd11.prod.outlook.com (20.178.218.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 09:53:23 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:23 +0000
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
Subject: [PATCH v3 net-next 01/12] net: aquantia: PTP skeleton declarations
 and callbacks
Thread-Topic: [PATCH v3 net-next 01/12] net: aquantia: PTP skeleton
 declarations and callbacks
Thread-Index: AQHViL6KZ2ksof+pyEWXxLdwymNClw==
Date:   Tue, 22 Oct 2019 09:53:22 +0000
Message-ID: <bdb36fb66b846b2bf3f27fe00911d3b9d6d13ba2.1571737612.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: 6d3f44e0-7e04-40ae-c903-08d756d5ace0
x-ms-traffictypediagnostic: BN8PR11MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3732644332AA09A7CD9E39A298680@BN8PR11MB3732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:321;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(366004)(376002)(396003)(199004)(189003)(2616005)(25786009)(8936002)(81166006)(86362001)(486006)(81156014)(1730700003)(44832011)(476003)(8676002)(50226002)(186003)(71190400001)(11346002)(446003)(14444005)(256004)(71200400001)(3846002)(2906002)(118296001)(66556008)(64756008)(66446008)(6116002)(66476007)(5660300002)(66946007)(6512007)(99286004)(5640700003)(4326008)(54906003)(316002)(107886003)(6486002)(7736002)(305945005)(6436002)(66066001)(26005)(6506007)(386003)(14454004)(102836004)(508600001)(6916009)(52116002)(76176011)(36756003)(2351001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3732;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NfjKAF5H9M9GbLCUSe6rQRm7TCw65V55p/7iGhmyZBj4ZuDR4D6Y5qcW2ax9jIXWG0oZm/bLJOtSisSETYqIT3fnDBvIdp/GpwaUVKn6B0AQZPFCVdIQf9916MgYvGjuz1HsbsJsdajGxQVcKMVZ6fn0U07KfwRqZSzIObJ/3KBXFeCS3819qULtOeZy1QfiDsZcIUM/Tow5orhhTAzKbJThLeneW/JoJWoqie/optD8F1VgrDTB8Ns84D+VxQpAJYsdhnBC9C0LX60yZth2eyjzpbBb1lvodgJcLFNFEWWiYB/ZVA4KeLojCZAzbaw6G6MDw5fvphtIzUvhjtQpGW4HbmTApwNHK82wGZbfBrIUtTqZFVk/NcZiWKR/vJFLiCFtt9V2UNtBNukS/ngWaRhFRQnUT9fxEJVARWv5Nlq9dBfnT8oGxMA0cQZfmVu+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d3f44e0-7e04-40ae-c903-08d756d5ace0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:22.8897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TiLf9fxTWr+pUu3jbTYVGv2ZzB+vaC94b1/8mqb2FdhD6RizPVOS+3q1oBYrGDJsImuPrcncDZvbOJynAjby2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <epomozov@marvell.com>

Here we add basic function for PTP clock register/unregister.
We also declare FW/HW capability bits used to control PTP feature on device=
.

PTP device is created if network card has appropriate FW that has PTP
enabled in config. HW supports timestamping for PTPv2 802.AS1 and
PTPv2 IPv4 UDP packets.

It also supports basic PTP callbacks for getting/setting time, adjusting
frequency and time as well.

Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Co-developed-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/Makefile   |  1 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 10 ++-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  5 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 84 ++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   | 22 +++++
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   | 85 ++++++++++++++++++-
 6 files changed, 201 insertions(+), 6 deletions(-)
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
index 137c1de4c6ec..d283d0bc75a3 100644
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
@@ -972,6 +977,9 @@ void aq_nic_deinit(struct aq_nic_s *self)
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
index 000000000000..a320916cced3
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -0,0 +1,84 @@
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
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_info;
+};
+
+static struct ptp_clock_info aq_ptp_clock =3D {
+	.owner		=3D THIS_MODULE,
+	.name		=3D "atlantic ptp",
+	.n_ext_ts	=3D 0,
+	.pps		=3D 0,
+	.n_per_out	=3D 0,
+	.n_pins		=3D 0,
+	.pin_config	=3D NULL,
+};
+
+int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
+{
+	struct hw_atl_utils_mbox mbox;
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

