Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADE0ADA16
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfIINir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:38:47 -0400
Received: from mail-eopbgr770052.outbound.protection.outlook.com ([40.107.77.52]:40429
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728961AbfIINiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 09:38:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8Gw1qQEEuTAacR6Q1MUvoziUSzWsvHj+R4uE9P/CEtxvmMvjSezuhnB3BgIy4kNlyPSs3yW00OsJ/TSEpSrmlPNrnWYvcARY4U84mUj3ws0ES4xGMoyozxtpx2dofnDSMuBSToxU4NUsUTMyksk7arvnGzzhbnlyHGpJ359OTV8LLd+pEHreo3nyJLbVcVEU9pm7n04ejcsUhdVi0FxPexa9OXKj5P1UyjHefOcc2YIBfyFZSntODk0KuQ8HlBg9j1ylLt2inXho3DV5vlayqHbKq4i/BPvkWWUoyuvxSfEu2aXX0Uyc8cpM5ytWfvqjgJubcaXf1sEtYq/366KBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eApw+ZM5C+WzI9Q6sSBgl7Pdx3R2uub89nA9WG84TxU=;
 b=CLE3WZKlV7k+BA1MQ6Bk8ERtsa3wc3f5UyYuNY8J1KT4ig+J2r0OPhV3qS7uNApx/SfR5oFAVi6F6zKOlZPEr2KsTj4NixVr7iOeQZC+msPYL3RDP3xA8gZTj75qKSjYHYDiQWgUyHADn9Ef6xLBaFGAT0NZL5qhCD2rQh6LurcmAJ8mI8UFktMxSKJTiaHnEc4NLT0jB9mBhuJlEbt6k0f5Gc7MjI06FkFM6d0Jhv9NWcQfHLm2ywDfw9pjvobYRzsjSumbRNabe2dxsdnyzoYlEbTfPGzjC+/6qHqAawWlMNEDS9yRP9sJHL+w9uBb0On4AB5GzMNxS0OyG18s3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eApw+ZM5C+WzI9Q6sSBgl7Pdx3R2uub89nA9WG84TxU=;
 b=Z/SU1ZwIvtLsOTHjwXd4roF+Q+fnO4f3xaqgDSiYT8BCofX98T3ZQTQ/E2DQtbChrIISZ2kgYcdDdGQ4yNOorFG1+rEHx/tFJ/CzH0eSeud3XKdUKw4Qu4/omnxNENclXfEtADVsYNixMYddrW8YeRGK9ufHKc2rf+TtX+JQa/Y=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1747.namprd11.prod.outlook.com (10.175.99.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Mon, 9 Sep 2019 13:38:42 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:38:42 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 03/11] net: aquantia: add basic ptp_clock callbacks
Thread-Topic: [PATCH net-next 03/11] net: aquantia: add basic ptp_clock
 callbacks
Thread-Index: AQHVZxPlN6GC7N8UcEu4+SulFLiF+Q==
Date:   Mon, 9 Sep 2019 13:38:42 +0000
Message-ID: <8868449ec5508f498131ee141399149bf801ea94.1568034880.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: e5d080c8-1d50-40b7-e99b-08d7352b078c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1747;
x-ms-traffictypediagnostic: BN6PR11MB1747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1747C390791FB7450B76DF0E98B70@BN6PR11MB1747.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39840400004)(346002)(366004)(376002)(136003)(189003)(199004)(26005)(25786009)(6436002)(6486002)(118296001)(305945005)(99286004)(53946003)(5640700003)(14444005)(256004)(64756008)(1730700003)(107886003)(81166006)(81156014)(66446008)(316002)(478600001)(66476007)(76176011)(4326008)(8676002)(86362001)(52116002)(66556008)(30864003)(53936002)(186003)(2501003)(6506007)(386003)(476003)(11346002)(5660300002)(2616005)(44832011)(66066001)(36756003)(3846002)(8936002)(6512007)(2906002)(486006)(6116002)(71190400001)(14454004)(7736002)(66946007)(6916009)(54906003)(102836004)(50226002)(2351001)(446003)(71200400001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1747;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rWU9DbXQxdIEWPyKIrv+79MKOjSfcchV5EMklus17wA/FUAOkp5vcsJAVgkBxtWxvqLpYWFc+JGY8nxrCeiv9h4ZcTbSgPcjJELFpmY7lPxlViiMe+vcICT4nJ5NZHUuuIP4CTTQO2TMf7S99Dui49iotfJWW5o0gh0Q1Sp66Tuud3ap8+TgmrUtad9U+RbTFF+D6Pnj3he+4H433Ig2Njm8f8Z2Hk8V5fNnH2AFiFystLYai3lorW8lOTB9MCVIFrkequDOx14m6foXaj/tYsv3pYYlX6/MWeKKQqKrd7uI6fg4/Y1ju1BY16qDNiiM5Ku1bIDqZNu9SypzV26vvU8SOF9hubxGkC2V+SSoFgfHDZfSjiMC9QBh2k3wO7iO9/FmYb+6HJfPNfN4qzPh5n4bVCegBizQzD01GdmEeH4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d080c8-1d50-40b7-e99b-08d7352b078c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:38:42.5204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c+MIshKVFtLipleVHlfEXz4FX+ZClXc4JQNalOH9xsieHG66YyBy9Y0+UUL8qPr6jF0pV5wM9I/pS8us1A8kOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1747
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

Basic HW functions implemented for adjusting frequency, adjusting time,
getting and setting time.
Firmware interface for PTP requests and interactions.

Enable/disable PTP counters in HW on clock register/unregister

Co-developed-by: Egor Pomozov <egor.pomozov@aquantia.com>
Signed-off-by: Egor Pomozov <egor.pomozov@aquantia.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  20 ++-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   3 +
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 116 ++++++++++++++++++
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 102 ++++++++++++++-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  16 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |   8 +-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     |  18 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |   5 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  30 +++++
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |  97 +++++++++++----
 10 files changed, 385 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index 53d7478689a0..20f032ad41e1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_hw.h: Declaration of abstract interface for NIC hardware specif=
ic
@@ -15,6 +15,9 @@
 #include "aq_rss.h"
 #include "hw_atl/hw_atl_utils.h"
=20
+#define AQ_HW_MAC_COUNTER_HZ   312500000ll
+#define AQ_HW_PHY_COUNTER_HZ   160000000ll
+
 #define AQ_RX_FIRST_LOC_FVLANID     0U
 #define AQ_RX_LAST_LOC_FVLANID	   15U
 #define AQ_RX_FIRST_LOC_FETHERT    16U
@@ -94,6 +97,7 @@ struct aq_stats_s {
 #define AQ_HW_FLAG_STOPPING    0x00000008U
 #define AQ_HW_FLAG_RESETTING   0x00000010U
 #define AQ_HW_FLAG_CLOSING     0x00000020U
+#define AQ_HW_PTP_AVAILABLE    0x01000000U
 #define AQ_HW_LINK_DOWN        0x04000000U
 #define AQ_HW_FLAG_ERR_UNPLUG  0x40000000U
 #define AQ_HW_FLAG_ERR_HW      0x80000000U
@@ -235,6 +239,14 @@ struct aq_hw_ops {
 	int (*hw_set_offload)(struct aq_hw_s *self,
 			      struct aq_nic_cfg_s *aq_nic_cfg);
=20
+	void (*hw_get_ptp_ts)(struct aq_hw_s *self, u64 *stamp);
+
+	int (*hw_adj_clock_freq)(struct aq_hw_s *self, s32 delta);
+
+	int (*hw_adj_sys_clock)(struct aq_hw_s *self, s64 delta);
+
+	int (*hw_set_sys_clock)(struct aq_hw_s *self, u64 time, u64 ts);
+
 	int (*hw_set_fc)(struct aq_hw_s *self, u32 fc, u32 tc);
 };
=20
@@ -267,6 +279,12 @@ struct aq_fw_ops {
 	int (*set_power)(struct aq_hw_s *self, unsigned int power_state,
 			 u8 *mac);
=20
+	int (*send_fw_request)(struct aq_hw_s *self,
+			       const struct hw_fw_request_iface *fw_req,
+			       size_t size);
+
+	void (*enable_ptp)(struct aq_hw_s *self, int enable);
+
 	int (*set_eee_rate)(struct aq_hw_s *self, u32 speed);
=20
 	int (*get_eee_rate)(struct aq_hw_s *self, u32 *rate,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 8721d43fd129..8e01de6f22e3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -146,6 +146,9 @@ static int aq_nic_update_link_status(struct aq_nic_s *s=
elf)
 			self->aq_hw->aq_link_status.mbps);
 		aq_nic_update_interrupt_moderation_settings(self);
=20
+		if (self->aq_ptp)
+			aq_ptp_clock_init(self);
+
 		/* Driver has to update flow control settings on RX block
 		 * on any link event.
 		 * We should query FW whether it negotiated FC.
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index c6cdcdc1a6aa..0133745a89d0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -16,15 +16,107 @@
 struct aq_ptp_s {
 	struct aq_nic_s *aq_nic;
=20
+	spinlock_t ptp_lock;
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_info;
 };
=20
+/* aq_ptp_adjfreq
+ * @ptp: the ptp clock structure
+ * @ppb: parts per billion adjustment from base
+ *
+ * adjust the frequency of the ptp cycle counter by the
+ * indicated ppb from the base frequency.
+ */
+static int aq_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+{
+	struct aq_ptp_s *self =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct aq_nic_s *aq_nic =3D self->aq_nic;
+
+	mutex_lock(&aq_nic->fwreq_mutex);
+	aq_nic->aq_hw_ops->hw_adj_clock_freq(aq_nic->aq_hw, ppb);
+	mutex_unlock(&aq_nic->fwreq_mutex);
+
+	return 0;
+}
+
+/* aq_ptp_adjtime
+ * @ptp: the ptp clock structure
+ * @delta: offset to adjust the cycle counter by
+ *
+ * adjust the timer by resetting the timecounter structure.
+ */
+static int aq_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct aq_ptp_s *self =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct aq_nic_s *aq_nic =3D self->aq_nic;
+	unsigned long flags;
+
+	spin_lock_irqsave(&self->ptp_lock, flags);
+	aq_nic->aq_hw_ops->hw_adj_sys_clock(aq_nic->aq_hw, delta);
+	spin_unlock_irqrestore(&self->ptp_lock, flags);
+
+	return 0;
+}
+
+/* aq_ptp_gettime
+ * @ptp: the ptp clock structure
+ * @ts: timespec structure to hold the current time value
+ *
+ * read the timecounter and return the correct value on ns,
+ * after converting it into a struct timespec.
+ */
+static int aq_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *t=
s)
+{
+	struct aq_ptp_s *self =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct aq_nic_s *aq_nic =3D self->aq_nic;
+	unsigned long flags;
+	u64 ns;
+
+	spin_lock_irqsave(&self->ptp_lock, flags);
+	aq_nic->aq_hw_ops->hw_get_ptp_ts(aq_nic->aq_hw, &ns);
+	spin_unlock_irqrestore(&self->ptp_lock, flags);
+
+	*ts =3D ns_to_timespec64(ns);
+
+	return 0;
+}
+
+/* aq_ptp_settime
+ * @ptp: the ptp clock structure
+ * @ts: the timespec containing the new time for the cycle counter
+ *
+ * reset the timecounter to use a new base value instead of the kernel
+ * wall timer value.
+ */
+static int aq_ptp_settime(struct ptp_clock_info *ptp,
+			  const struct timespec64 *ts)
+{
+	struct aq_ptp_s *self =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct aq_nic_s *aq_nic =3D self->aq_nic;
+	unsigned long flags;
+	u64 ns =3D timespec64_to_ns(ts);
+	u64 now;
+
+	spin_lock_irqsave(&self->ptp_lock, flags);
+	aq_nic->aq_hw_ops->hw_get_ptp_ts(aq_nic->aq_hw, &now);
+	aq_nic->aq_hw_ops->hw_adj_sys_clock(aq_nic->aq_hw, (s64)ns - (s64)now);
+
+	spin_unlock_irqrestore(&self->ptp_lock, flags);
+
+	return 0;
+}
+
 static struct ptp_clock_info aq_ptp_clock =3D {
 	.owner		=3D THIS_MODULE,
 	.name		=3D "atlantic ptp",
+	.max_adj	=3D 999999999,
 	.n_ext_ts	=3D 0,
 	.pps		=3D 0,
+	.adjfreq	=3D aq_ptp_adjfreq,
+	.adjtime	=3D aq_ptp_adjtime,
+	.gettime64	=3D aq_ptp_gettime,
+	.settime64	=3D aq_ptp_settime,
 	.n_per_out     =3D 0,
 	.n_pins        =3D 0,
 	.pin_config    =3D NULL,
@@ -37,6 +129,16 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int i=
dx_vec)
 	struct aq_ptp_s *self;
 	int err =3D 0;
=20
+	if (!aq_nic->aq_hw_ops->hw_get_ptp_ts) {
+		aq_nic->aq_ptp =3D NULL;
+		return 0;
+	}
+
+	if (!aq_nic->aq_fw_ops->enable_ptp) {
+		aq_nic->aq_ptp =3D NULL;
+		return 0;
+	}
+
 	hw_atl_utils_mpi_read_stats(aq_nic->aq_hw, &mbox);
=20
 	if (!(mbox.info.caps_ex & BIT(CAPS_EX_PHY_PTP_EN))) {
@@ -52,6 +154,8 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int id=
x_vec)
=20
 	self->aq_nic =3D aq_nic;
=20
+	spin_lock_init(&self->ptp_lock);
+
 	self->ptp_info =3D aq_ptp_clock;
 	clock =3D ptp_clock_register(&self->ptp_info, &aq_nic->ndev->dev);
 	if (!clock) {
@@ -63,6 +167,13 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int i=
dx_vec)
=20
 	aq_nic->aq_ptp =3D self;
=20
+	/* enable ptp counter */
+	aq_utils_obj_set(&aq_nic->aq_hw->flags, AQ_HW_PTP_AVAILABLE);
+	mutex_lock(&aq_nic->fwreq_mutex);
+	aq_nic->aq_fw_ops->enable_ptp(aq_nic->aq_hw, 1);
+	aq_ptp_clock_init(aq_nic);
+	mutex_unlock(&aq_nic->fwreq_mutex);
+
 	return 0;
=20
 err_exit:
@@ -88,6 +199,11 @@ void aq_ptp_free(struct aq_nic_s *aq_nic)
 	if (!self)
 		return;
=20
+	/* disable ptp */
+	mutex_lock(&aq_nic->fwreq_mutex);
+	aq_nic->aq_fw_ops->enable_ptp(aq_nic->aq_hw, 0);
+	mutex_unlock(&aq_nic->fwreq_mutex);
+
 	kfree(self);
 	aq_nic->aq_ptp =3D NULL;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 30f7fc4c97ff..f3550fbb1c59 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_b0.c: Definition of Atlantic hardware specific functions. *=
/
@@ -86,6 +86,8 @@ const struct aq_hw_caps_s hw_atl_b0_caps_aqc109 =3D {
 			  AQ_NIC_RATE_100M,
 };
=20
+static s64 ptp_clk_offset;
+
 static int hw_atl_b0_hw_reset(struct aq_hw_s *self)
 {
 	int err =3D 0;
@@ -992,6 +994,96 @@ static int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s *s=
elf,
 	return aq_hw_err_from_flags(self);
 }
=20
+#define get_ptp_ts_val_u64(self, indx) \
+	((u64)(hw_atl_pcs_ptp_clock_get(self, indx) & 0xffff))
+
+static void hw_atl_b0_get_ptp_ts(struct aq_hw_s *self, u64 *stamp)
+{
+	u64 ns;
+
+	hw_atl_pcs_ptp_clock_read_enable(self, 1);
+	hw_atl_pcs_ptp_clock_read_enable(self, 0);
+	ns =3D (get_ptp_ts_val_u64(self, 0) +
+	      (get_ptp_ts_val_u64(self, 1) << 16)) * 1000000000llu +
+	     (get_ptp_ts_val_u64(self, 3) +
+	      (get_ptp_ts_val_u64(self, 4) << 16));
+
+	*stamp =3D ns + ptp_clk_offset;
+}
+
+static void hw_atl_b0_adj_params_get(u64 freq, s64 adj, u32 *ns, u32 *fns)
+{
+	/* For accuracy, the digit is extended */
+	s64 divisor =3D 0, base_ns =3D ((adj + 1000000000ll) * 1000000000ll) / fr=
eq;
+	u32 nsi_frac =3D 0, nsi =3D base_ns / 1000000000ll;
+
+	if (base_ns !=3D nsi * 1000000000ll) {
+		divisor =3D 1000000000000000000ll /
+			  (base_ns - nsi * 1000000000ll);
+		nsi_frac =3D 0x100000000ll * 1000000000ll / divisor;
+	}
+
+	*ns =3D nsi;
+	*fns =3D nsi_frac;
+}
+
+static void
+hw_atl_b0_mac_adj_param_calc(struct hw_fw_request_ptp_adj_freq *ptp_adj_fr=
eq,
+			     u64 phyfreq, u64 macfreq)
+{
+	s64 fns_in_sec_phy =3D phyfreq * (ptp_adj_freq->fns_phy +
+					0x100000000ll * ptp_adj_freq->ns_phy);
+	s64 fns_in_sec_mac =3D macfreq * (ptp_adj_freq->fns_mac +
+					0x100000000ll * ptp_adj_freq->ns_mac);
+	s64 fault_in_sec_phy =3D 0x100000000ll * 1000000000ll - fns_in_sec_phy;
+	s64 fault_in_sec_mac =3D 0x100000000ll * 1000000000ll - fns_in_sec_mac;
+	/* MAC MCP counter freq is macfreq / 4 */
+	s64 diff_in_mcp_overflow =3D (fault_in_sec_mac - fault_in_sec_phy) *
+				   0x400000000ll / AQ_HW_MAC_COUNTER_HZ;
+	s64 adj_fns_val =3D (ptp_adj_freq->fns_mac + 0x100000000ll *
+			   ptp_adj_freq->ns_mac) + diff_in_mcp_overflow;
+
+	ptp_adj_freq->mac_ns_adj =3D adj_fns_val / 0x100000000ll;
+	ptp_adj_freq->mac_fns_adj =3D adj_fns_val - ptp_adj_freq->mac_ns_adj *
+				    0x100000000ll;
+}
+
+static int hw_atl_b0_adj_sys_clock(struct aq_hw_s *self, s64 delta)
+{
+	ptp_clk_offset +=3D delta;
+
+	return 0;
+}
+
+static int hw_atl_b0_set_sys_clock(struct aq_hw_s *self, u64 time, u64 ts)
+{
+	s64 delta =3D time - (ptp_clk_offset + ts);
+
+	return hw_atl_b0_adj_sys_clock(self, delta);
+}
+
+static int hw_atl_b0_adj_clock_freq(struct aq_hw_s *self, s32 ppb)
+{
+	struct hw_fw_request_iface fwreq;
+	size_t size;
+
+	memset(&fwreq, 0, sizeof(fwreq));
+
+	fwreq.msg_id =3D HW_AQ_FW_REQUEST_PTP_ADJ_FREQ;
+	hw_atl_b0_adj_params_get(AQ_HW_MAC_COUNTER_HZ, ppb,
+				 &fwreq.ptp_adj_freq.ns_mac,
+				 &fwreq.ptp_adj_freq.fns_mac);
+	hw_atl_b0_adj_params_get(AQ_HW_PHY_COUNTER_HZ, ppb,
+				 &fwreq.ptp_adj_freq.ns_phy,
+				 &fwreq.ptp_adj_freq.fns_phy);
+	hw_atl_b0_mac_adj_param_calc(&fwreq.ptp_adj_freq,
+				     AQ_HW_PHY_COUNTER_HZ,
+				     AQ_HW_MAC_COUNTER_HZ);
+
+	size =3D sizeof(fwreq.msg_id) + sizeof(fwreq.ptp_adj_freq);
+	return self->aq_fw_ops->send_fw_request(self, &fwreq, size);
+}
+
 static int hw_atl_b0_hw_fl3l4_clear(struct aq_hw_s *self,
 				    struct aq_rx_filter_l3l4 *data)
 {
@@ -1164,6 +1256,12 @@ const struct aq_hw_ops hw_atl_ops_b0 =3D {
 	.hw_get_regs                 =3D hw_atl_utils_hw_get_regs,
 	.hw_get_hw_stats             =3D hw_atl_utils_get_hw_stats,
 	.hw_get_fw_version           =3D hw_atl_utils_get_fw_version,
-	.hw_set_offload              =3D hw_atl_b0_hw_offload_set,
+
+	.hw_get_ptp_ts           =3D hw_atl_b0_get_ptp_ts,
+	.hw_adj_sys_clock        =3D hw_atl_b0_adj_sys_clock,
+	.hw_set_sys_clock        =3D hw_atl_b0_set_sys_clock,
+	.hw_adj_clock_freq       =3D hw_atl_b0_adj_clock_freq,
+
+	.hw_set_offload          =3D hw_atl_b0_hw_offload_set,
 	.hw_set_fc                   =3D hw_atl_b0_set_fc,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 1149812ae463..25e7261f6a44 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_llh.c: Definitions of bitfield and register access function=
s for
@@ -1513,6 +1513,20 @@ void hw_atl_reg_glb_cpu_scratch_scp_set(struct aq_hw=
_s *aq_hw,
 			glb_cpu_scratch_scp);
 }
=20
+void hw_atl_pcs_ptp_clock_read_enable(struct aq_hw_s *aq_hw,
+				      u32 ptp_clock_read_enable)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_ADR,
+			    HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_MSK,
+			    HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_SHIFT,
+			    ptp_clock_read_enable);
+}
+
+u32 hw_atl_pcs_ptp_clock_get(struct aq_hw_s *aq_hw, u32 index)
+{
+	return aq_hw_read_reg(aq_hw, HW_ATL_PCS_PTP_TS_VAL_ADDR(index));
+}
+
 void hw_atl_mcp_up_force_intr_set(struct aq_hw_s *aq_hw, u32 up_force_intr=
)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_MCP_UP_FORCE_INTERRUPT_ADR,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index 0c37abbabca5..a62693e51a6b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_llh.h: Declarations of bitfield and register access functio=
ns for
@@ -712,6 +712,12 @@ void hw_atl_msm_reg_wr_strobe_set(struct aq_hw_s *aq_h=
w, u32 reg_wr_strobe);
 /* set pci register reset disable */
 void hw_atl_pci_pci_reg_res_dis_set(struct aq_hw_s *aq_hw, u32 pci_reg_res=
_dis);
=20
+/* pcs */
+void hw_atl_pcs_ptp_clock_read_enable(struct aq_hw_s *aq_hw,
+				      u32 ptp_clock_read_enable);
+
+u32 hw_atl_pcs_ptp_clock_get(struct aq_hw_s *aq_hw, u32 index);
+
 /* set uP Force Interrupt */
 void hw_atl_mcp_up_force_intr_set(struct aq_hw_s *aq_hw, u32 up_force_intr=
);
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_inter=
nal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index c3febcdfa92e..7716e0fc22b5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_llh_internal.h: Preprocessor definitions
@@ -2421,6 +2421,22 @@
 /* default value of bitfield register write strobe */
 #define HW_ATL_MSM_REG_WR_STROBE_DEFAULT 0x0
=20
+/* register address for bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_ADR 0x00004628
+/* bitmask for bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_MSK 0x00000010
+/* inverted bitmask for bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_MSKN 0xFFFFFFEF
+/* lower bit position of bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_SHIFT 4
+/* width of bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_WIDTH 1
+/* default value of bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_DEFAULT 0x0
+
+/* register address for ptp counter reading */
+#define HW_ATL_PCS_PTP_TS_VAL_ADDR(index) (0x00004900 + (index) * 0x4)
+
 /* mif soft reset bitfield definitions
  * preprocessor definitions for the bitfield "soft reset".
  * port=3D"pif_glb_res_i"
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 32512539ae86..6fc5640065bd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -327,8 +327,7 @@ int hw_atl_utils_fw_downld_dwords(struct aq_hw_s *self,=
 u32 a,
 	return err;
 }
=20
-static int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 =
*p,
-					 u32 cnt)
+int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 *p, u32=
 cnt)
 {
 	u32 val;
 	int err =3D 0;
@@ -964,4 +963,6 @@ const struct aq_fw_ops aq_fw_1x_ops =3D {
 	.set_eee_rate =3D NULL,
 	.get_eee_rate =3D NULL,
 	.set_flow_control =3D NULL,
+	.send_fw_request =3D NULL,
+	.enable_ptp =3D NULL,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 766e02c7fd4e..f2eb94f298e2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -279,6 +279,34 @@ struct __packed offload_info {
 	u8 buf[0];
 };
=20
+/* Mailbox FW Request interface */
+struct __packed hw_fw_request_ptp_adj_freq {
+	u32 ns_mac;
+	u32 fns_mac;
+	u32 ns_phy;
+	u32 fns_phy;
+	u32 mac_ns_adj;
+	u32 mac_fns_adj;
+};
+
+struct __packed hw_fw_request_ptp_adj_clock {
+	u32 ns;
+	u32 sec;
+	int sign;
+};
+
+#define HW_AQ_FW_REQUEST_PTP_ADJ_FREQ	         0x12
+#define HW_AQ_FW_REQUEST_PTP_ADJ_CLOCK	         0x13
+
+struct __packed hw_fw_request_iface {
+	u32 msg_id;
+	union {
+		/* PTP FW Request */
+		struct hw_fw_request_ptp_adj_freq ptp_adj_freq;
+		struct hw_fw_request_ptp_adj_clock ptp_adj_clock;
+	};
+};
+
 enum hw_atl_rx_action_with_traffic {
 	HW_ATL_RX_DISCARD,
 	HW_ATL_RX_HOST,
@@ -561,6 +589,8 @@ struct aq_stats_s *hw_atl_utils_get_hw_stats(struct aq_=
hw_s *self);
 int hw_atl_utils_fw_downld_dwords(struct aq_hw_s *self, u32 a,
 				  u32 *p, u32 cnt);
=20
+int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 *p, u32=
 cnt);
+
 int hw_atl_utils_fw_set_wol(struct aq_hw_s *self, bool wol_enabled, u8 *ma=
c);
=20
 int hw_atl_utils_fw_rpc_call(struct aq_hw_s *self, unsigned int rpc_size);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2=
x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index da726489e3c8..8b9824b1dc5e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_utils_fw2x.c: Definition of firmware 2.x functions for
@@ -17,14 +17,17 @@
 #include "hw_atl_utils.h"
 #include "hw_atl_llh.h"
=20
-#define HW_ATL_FW2X_MPI_RPC_ADDR        0x334
+#define HW_ATL_FW2X_MPI_RPC_ADDR         0x334
=20
-#define HW_ATL_FW2X_MPI_MBOX_ADDR       0x360
-#define HW_ATL_FW2X_MPI_EFUSE_ADDR	0x364
-#define HW_ATL_FW2X_MPI_CONTROL_ADDR	0x368
-#define HW_ATL_FW2X_MPI_CONTROL2_ADDR	0x36C
-#define HW_ATL_FW2X_MPI_STATE_ADDR	0x370
-#define HW_ATL_FW2X_MPI_STATE2_ADDR     0x374
+#define HW_ATL_FW2X_MPI_MBOX_ADDR        0x360
+#define HW_ATL_FW2X_MPI_EFUSE_ADDR       0x364
+#define HW_ATL_FW2X_MPI_CONTROL_ADDR     0x368
+#define HW_ATL_FW2X_MPI_CONTROL2_ADDR    0x36C
+#define HW_ATL_FW2X_MPI_STATE_ADDR       0x370
+#define HW_ATL_FW2X_MPI_STATE2_ADDR      0x374
+
+#define HW_ATL_FW3X_EXT_CONTROL_ADDR     0x378
+#define HW_ATL_FW3X_EXT_STATE_ADDR       0x37c
=20
 #define HW_ATL_FW2X_CAP_PAUSE            BIT(CAPS_HI_PAUSE)
 #define HW_ATL_FW2X_CAP_ASYM_PAUSE       BIT(CAPS_HI_ASYMMETRIC_PAUSE)
@@ -444,6 +447,54 @@ static int aq_fw2x_set_power(struct aq_hw_s *self, uns=
igned int power_state,
 	return err;
 }
=20
+static int aq_fw2x_send_fw_request(struct aq_hw_s *self,
+				   const struct hw_fw_request_iface *fw_req,
+				   size_t size)
+{
+	u32 ctrl2, orig_ctrl2;
+	u32 dword_cnt;
+	int err =3D 0;
+	u32 val;
+
+	/* Write data to drvIface Mailbox */
+	dword_cnt =3D size / sizeof(u32);
+	if (size % sizeof(u32))
+		dword_cnt++;
+	err =3D hw_atl_utils_fw_upload_dwords(self, aq_fw2x_rpc_get(self),
+					    (void *)fw_req, dword_cnt);
+	if (err < 0)
+		goto err_exit;
+
+	/* Toggle statistics bit for FW to update */
+	ctrl2 =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
+	orig_ctrl2 =3D ctrl2 & BIT(CAPS_HI_FW_REQUEST);
+	ctrl2 =3D ctrl2 ^ BIT(CAPS_HI_FW_REQUEST);
+	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, ctrl2);
+
+	/* Wait FW to report back */
+	err =3D readx_poll_timeout_atomic(aq_fw2x_state2_get, self, val,
+					orig_ctrl2 !=3D (val &
+						       BIT(CAPS_HI_FW_REQUEST)),
+					1U, 10000U);
+
+err_exit:
+	return err;
+}
+
+static void aq_fw3x_enable_ptp(struct aq_hw_s *self, int enable)
+{
+	u32 ptp_opts =3D aq_hw_read_reg(self, HW_ATL_FW3X_EXT_STATE_ADDR);
+	u32 all_ptp_features =3D BIT(CAPS_EX_PHY_PTP_EN) |
+						   BIT(CAPS_EX_PTP_GPIO_EN);
+
+	if (enable)
+		ptp_opts |=3D all_ptp_features;
+	else
+		ptp_opts &=3D ~all_ptp_features;
+
+	aq_hw_write_reg(self, HW_ATL_FW3X_EXT_CONTROL_ADDR, ptp_opts);
+}
+
 static int aq_fw2x_set_eee_rate(struct aq_hw_s *self, u32 speed)
 {
 	u32 mpi_opts =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
@@ -534,19 +585,21 @@ static u32 aq_fw2x_state2_get(struct aq_hw_s *self)
 }
=20
 const struct aq_fw_ops aq_fw_2x_ops =3D {
-	.init =3D aq_fw2x_init,
-	.deinit =3D aq_fw2x_deinit,
-	.reset =3D NULL,
-	.renegotiate =3D aq_fw2x_renegotiate,
-	.get_mac_permanent =3D aq_fw2x_get_mac_permanent,
-	.set_link_speed =3D aq_fw2x_set_link_speed,
-	.set_state =3D aq_fw2x_set_state,
+	.init               =3D aq_fw2x_init,
+	.deinit             =3D aq_fw2x_deinit,
+	.reset              =3D NULL,
+	.renegotiate        =3D aq_fw2x_renegotiate,
+	.get_mac_permanent  =3D aq_fw2x_get_mac_permanent,
+	.set_link_speed     =3D aq_fw2x_set_link_speed,
+	.set_state          =3D aq_fw2x_set_state,
 	.update_link_status =3D aq_fw2x_update_link_status,
-	.update_stats =3D aq_fw2x_update_stats,
-	.get_phy_temp =3D aq_fw2x_get_phy_temp,
-	.set_power =3D aq_fw2x_set_power,
-	.set_eee_rate =3D aq_fw2x_set_eee_rate,
-	.get_eee_rate =3D aq_fw2x_get_eee_rate,
-	.set_flow_control =3D aq_fw2x_set_flow_control,
-	.get_flow_control =3D aq_fw2x_get_flow_control
+	.update_stats       =3D aq_fw2x_update_stats,
+	.get_phy_temp       =3D aq_fw2x_get_phy_temp,
+	.set_power          =3D aq_fw2x_set_power,
+	.set_eee_rate       =3D aq_fw2x_set_eee_rate,
+	.get_eee_rate       =3D aq_fw2x_get_eee_rate,
+	.set_flow_control   =3D aq_fw2x_set_flow_control,
+	.get_flow_control   =3D aq_fw2x_get_flow_control,
+	.send_fw_request    =3D aq_fw2x_send_fw_request,
+	.enable_ptp         =3D aq_fw3x_enable_ptp,
 };
--=20
2.17.1

