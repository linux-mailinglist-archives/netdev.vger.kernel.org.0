Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA6CCF7A1
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730629AbfJHK5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:57:00 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:64603
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729893AbfJHK5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:57:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUFUwBn6IRSF5ndo6CmDpOIRFGiQ8M9ZHAQtDNr9cIBkWU2pDyd0KdfefngQnoLx7JyEUg2/BuUFRaqED3ZREKoiutTPJAT15YXqu9z9ACdZyY5QgwOCGuwX6OE0o3bhg3z0X/5Yd/6CFpkhmMT03y0yAGTEiuBHA6wWKfW2YvAq6GT77Wrny/fRuhHNTl5YGjT9TnTd8M0NdlClRuEvSvZ+9qSMJfjpjcEjyq6K9vp0eFH+llcaWkv0bOw28AHbYNkKBXQI+/Xj2Xvc1fKSE/wSz0s3zlA7d7O2GNzkR8ZYb/9p1pXHGHCYwAGaGCy5t4URf6FpucwMSGb7EML4wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqCyL5JunQQ7WbPNQRecLFqbNfd2aCBLT4w4areKqVo=;
 b=MlG0POhW/EaKWwyzk7fOkH9ybU93+PfHSwusp97lDYFggFwZPqggC9gResg/IYkvaBH9/nMAV+T2ORY1blgF37u0ngKpvr1n4Qxu410+mbImUD28GFq3ADTeHtXiyDwocFk4S9PxTZYJBimyJ/UuZUIlZoPsnLtTzVB0/Cs5cMpAHAVbeL9a8y2nnoRne1schyolmRrE102AY3hk3I75Fw4Rn0hrkItKlEfW7s2INW7UoV6pmwOGlsewHd1yGTk6uHWcfhuQzRnFr8tzsK3pWybCS8nBfAj8NlaX98DLYS5bjoWGQvRiiBNXl9iUka2gqbi2FrXAHyLvOO8ddfsn6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqCyL5JunQQ7WbPNQRecLFqbNfd2aCBLT4w4areKqVo=;
 b=j9w4J7HL1wSBJJvMyHwlR/kU1eC6DkxOZmii3oKRMElLEUk4Y7udsnazy8CQPYM9BYN57FGZTQ4u85+xMCG0f7cyRJn1QF3L7LhKebe/YxrqQt9MwBC2XKtqiwmQubvOuePpvbwjv0SWv6NkXfKfzwZJV1cVj9wl7Avyn9HVQkE=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:56:47 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:56:47 +0000
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
Subject: [PATCH v2 net-next 06/12] net: aquantia: implement data PTP datapath
Thread-Topic: [PATCH v2 net-next 06/12] net: aquantia: implement data PTP
 datapath
Thread-Index: AQHVfccUKqidU8yu2kiaCh23VeKGlA==
Date:   Tue, 8 Oct 2019 10:56:47 +0000
Message-ID: <093d91dcc66abeb4d3ef83eef829badd7389d792.1570531332.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: 017ee5f0-f5c6-4c7d-6d06-08d74bde36e8
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3666F746EA340C33A250BD2F989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:163;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(118296001)(71190400001)(71200400001)(2501003)(256004)(14444005)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(11346002)(5640700003)(6512007)(99286004)(25786009)(66556008)(50226002)(76176011)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(30864003)(14454004)(26005)(36756003)(86362001)(446003)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003)(559001)(579004)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QYIjMC5E/nPkfzsHilZxo+sQdq0hVLqydKWGSa560OssPrwca2U7+Q72C6rG4HKbdfuJhOeP2ig6EqYvIVWjAss1yb6kFttyAjcuISvNMjqNNNkigC64BktE8zeWktO+yyWLHYaUv3VkswWpZ1uuy31s0XVpZ3DlyqWfiEdyQot/ngK6oiHiafXHZbm2aDZWNmiQk4r3QpZsqWLZoYsxp9F5KadIWBTER0xOSYNv993qE1R7G1iOZ+rr6JGrRpqlVQAyVTYM3E84e7iAvjK6bgCKTBg3Q40ZPKzlo1BMbmo5H2ui7kCfZoYTyg+HFV3QZN4rJBAWOzwNd0rnj+qJH3xR1pdyq85+aaD/CclL0RqSNWCSOf/fKWvXVyI34531b+z/pxomsPLO1LOqieA8wD8MJP4GNGHaINXqgQAX6HU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 017ee5f0-f5c6-4c7d-6d06-08d74bde36e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:56:47.5717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 47afudE9hUMxE/jqE1oozDVw7uiq1tIo1LmprpYOdXhiPGoBB2mYXCNRI3HxAaKGPQRxvxrA/tEZvCMDHdW1Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <egor.pomozov@aquantia.com>

Here we do alloc/free IRQs for PTP rings.
We also implement processing of PTP packets on TX and RX sides.

Signed-off-by: Egor Pomozov <egor.pomozov@aquantia.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Co-developed-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |   4 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  12 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  23 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  18 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   3 +
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |   5 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 544 +++++++++++++++++-
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |  19 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  31 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |   1 +
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 100 ++++
 11 files changed, 748 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_cfg.h
index 02f1b70c4e25..8c633caf79d2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_cfg.h: Definition of configuration parameters and constants. */
@@ -27,7 +27,7 @@
=20
 #define AQ_CFG_INTERRUPT_MODERATION_USEC_MAX (0x1FF * 2)
=20
-#define AQ_CFG_IRQ_MASK                      0x1FFU
+#define AQ_CFG_IRQ_MASK                      0x3FFU
=20
 #define AQ_CFG_VECS_MAX   8U
 #define AQ_CFG_TCS_MAX    8U
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index edc7d83ef5e1..5b0f42818033 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -244,6 +244,12 @@ struct aq_hw_ops {
=20
 	int (*hw_rx_tc_mode_get)(struct aq_hw_s *self, u32 *tc_mode);
=20
+	int (*hw_ring_hwts_rx_fill)(struct aq_hw_s *self,
+				    struct aq_ring_s *aq_ring);
+
+	int (*hw_ring_hwts_rx_receive)(struct aq_hw_s *self,
+				       struct aq_ring_s *ring);
+
 	void (*hw_get_ptp_ts)(struct aq_hw_s *self, u64 *stamp);
=20
 	int (*hw_adj_clock_freq)(struct aq_hw_s *self, s32 delta);
@@ -252,6 +258,12 @@ struct aq_hw_ops {
=20
 	int (*hw_set_sys_clock)(struct aq_hw_s *self, u64 time, u64 ts);
=20
+	u16 (*rx_extract_ts)(struct aq_hw_s *self, u8 *p, unsigned int len,
+			     u64 *timestamp);
+
+	int (*extract_hwts)(struct aq_hw_s *self, u8 *p, unsigned int len,
+			    u64 *timestamp);
+
 	int (*hw_set_fc)(struct aq_hw_s *self, u32 fc, u32 tc);
 };
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_main.c
index b4a0fb281e69..0b9ad49b5081 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_main.c: Main file for aQuantia Linux driver. */
@@ -10,10 +10,13 @@
 #include "aq_nic.h"
 #include "aq_pci_func.h"
 #include "aq_ethtool.h"
+#include "aq_ptp.h"
 #include "aq_filters.h"
=20
 #include <linux/netdevice.h>
 #include <linux/module.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
=20
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(AQ_CFG_DRV_VERSION);
@@ -93,6 +96,24 @@ static int aq_ndev_start_xmit(struct sk_buff *skb, struc=
t net_device *ndev)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
=20
+	if (unlikely(aq_utils_obj_test(&aq_nic->flags, AQ_NIC_PTP_DPATH_UP))) {
+		/* Hardware adds the Timestamp for PTPv2 802.AS1
+		 * and PTPv2 IPv4 UDP.
+		 * We have to push even general 320 port messages to the ptp
+		 * queue explicitly. This is a limitation of current firmware
+		 * and hardware PTP design of the chip. Otherwise ptp stream
+		 * will fail to sync
+		 */
+		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) ||
+		    unlikely((ip_hdr(skb)->version =3D=3D 4) &&
+			     (ip_hdr(skb)->protocol =3D=3D IPPROTO_UDP) &&
+			     ((udp_hdr(skb)->dest =3D=3D htons(319)) ||
+			      (udp_hdr(skb)->dest =3D=3D htons(320)))) ||
+		    unlikely(eth_hdr(skb)->h_proto =3D=3D htons(ETH_P_1588)))
+			return aq_ptp_xmit(aq_nic, skb);
+	}
+
+	skb_tx_timestamp(skb);
 	return aq_nic_xmit(aq_nic, skb);
 }
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 87357755a72d..f1d4d3a9bfcb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -146,8 +146,11 @@ static int aq_nic_update_link_status(struct aq_nic_s *=
self)
 			self->aq_hw->aq_link_status.mbps);
 		aq_nic_update_interrupt_moderation_settings(self);
=20
-		if (self->aq_ptp)
+		if (self->aq_ptp) {
 			aq_ptp_clock_init(self);
+			aq_ptp_tm_offset_set(self,
+					     self->aq_hw->aq_link_status.mbps);
+		}
=20
 		/* Driver has to update flow control settings on RX block
 		 * on any link event.
@@ -196,6 +199,8 @@ static void aq_nic_service_task(struct work_struct *wor=
k)
 					     service_task);
 	int err;
=20
+	aq_ptp_service_task(self);
+
 	if (aq_utils_obj_test(&self->flags, AQ_NIC_FLAGS_IS_NOT_READY))
 		return;
=20
@@ -408,6 +413,10 @@ int aq_nic_start(struct aq_nic_s *self)
 				goto err_exit;
 		}
=20
+		err =3D aq_ptp_irq_alloc(self);
+		if (err < 0)
+			goto err_exit;
+
 		if (self->aq_nic_cfg.link_irq_vec) {
 			int irqvec =3D pci_irq_vector(self->pdev,
 						   self->aq_nic_cfg.link_irq_vec);
@@ -440,9 +449,8 @@ int aq_nic_start(struct aq_nic_s *self)
 	return err;
 }
=20
-static unsigned int aq_nic_map_skb(struct aq_nic_s *self,
-				   struct sk_buff *skb,
-				   struct aq_ring_s *ring)
+unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
+			    struct aq_ring_s *ring)
 {
 	unsigned int ret =3D 0U;
 	unsigned int nr_frags =3D skb_shinfo(skb)->nr_frags;
@@ -971,6 +979,8 @@ int aq_nic_stop(struct aq_nic_s *self)
 	else
 		aq_pci_func_free_irqs(self);
=20
+	aq_ptp_irq_free(self);
+
 	for (i =3D 0U, aq_vec =3D self->aq_vec[0];
 		self->aq_vecs > i; ++i, aq_vec =3D self->aq_vec[i])
 		aq_vec_stop(aq_vec);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.h
index d0979bba7ed3..576432adda4c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -54,6 +54,7 @@ struct aq_nic_cfg_s {
 #define AQ_NIC_FLAG_STOPPING    0x00000008U
 #define AQ_NIC_FLAG_RESETTING   0x00000010U
 #define AQ_NIC_FLAG_CLOSING     0x00000020U
+#define AQ_NIC_PTP_DPATH_UP     0x02000000U
 #define AQ_NIC_LINK_DOWN        0x04000000U
 #define AQ_NIC_FLAG_ERR_UNPLUG  0x40000000U
 #define AQ_NIC_FLAG_ERR_HW      0x80000000U
@@ -129,6 +130,8 @@ void aq_nic_cfg_start(struct aq_nic_s *self);
 int aq_nic_ndev_register(struct aq_nic_s *self);
 void aq_nic_ndev_free(struct aq_nic_s *self);
 int aq_nic_start(struct aq_nic_s *self);
+unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
+			    struct aq_ring_s *ring);
 int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb);
 int aq_nic_get_regs(struct aq_nic_s *self, struct ethtool_regs *regs, void=
 *p);
 int aq_nic_get_regs_count(struct aq_nic_s *self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers=
/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 74b9f3f1da81..e82c96b50373 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_pci_func.c: Definition of PCI functions. */
@@ -269,6 +269,9 @@ static int aq_pci_probe(struct pci_dev *pdev,
 	numvecs =3D min((u8)AQ_CFG_VECS_DEF,
 		      aq_nic_get_cfg(self)->aq_hw_caps->msix_irqs);
 	numvecs =3D min(numvecs, num_online_cpus());
+	/* Request IRQ vector for PTP */
+	numvecs +=3D 1;
+
 	numvecs +=3D AQ_HW_SERVICE_IRQS;
 	/*enable interrupts */
 #if !AQ_CFG_FORCE_LEGACY_INT
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index b338d724ad5f..c7ec956eea8b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -8,12 +8,24 @@
  */
=20
 #include <linux/ptp_clock_kernel.h>
+#include <linux/interrupt.h>
 #include <linux/clocksource.h>
=20
 #include "aq_nic.h"
 #include "aq_ptp.h"
 #include "aq_ring.h"
=20
+#define AQ_PTP_TX_TIMEOUT        (HZ *  10)
+
+enum ptp_speed_offsets {
+	ptp_offset_idx_10 =3D 0,
+	ptp_offset_idx_100,
+	ptp_offset_idx_1000,
+	ptp_offset_idx_2500,
+	ptp_offset_idx_5000,
+	ptp_offset_idx_10000,
+};
+
 struct ptp_skb_ring {
 	struct sk_buff **buff;
 	spinlock_t lock;
@@ -22,6 +34,12 @@ struct ptp_skb_ring {
 	unsigned int tail;
 };
=20
+struct ptp_tx_timeout {
+	spinlock_t lock;
+	bool active;
+	unsigned long tx_start;
+};
+
 struct aq_ptp_s {
 	struct aq_nic_s *aq_nic;
=20
@@ -30,8 +48,16 @@ struct aq_ptp_s {
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_info;
=20
+	atomic_t offset_egress;
+	atomic_t offset_ingress;
+
 	struct aq_ring_param_s ptp_ring_param;
=20
+	struct ptp_tx_timeout ptp_tx_timeout;
+
+	unsigned int idx_vector;
+	struct napi_struct napi;
+
 	struct aq_ring_s ptp_tx;
 	struct aq_ring_s ptp_rx;
 	struct aq_ring_s hwts_rx;
@@ -39,6 +65,111 @@ struct aq_ptp_s {
 	struct ptp_skb_ring skb_ring;
 };
=20
+struct ptp_tm_offset {
+	unsigned int mbps;
+	int egress;
+	int ingress;
+};
+
+static struct ptp_tm_offset ptp_offset[6];
+
+static inline int aq_ptp_tm_offset_egress_get(struct aq_ptp_s *aq_ptp)
+{
+	return atomic_read(&aq_ptp->offset_egress);
+}
+
+static inline int aq_ptp_tm_offset_ingress_get(struct aq_ptp_s *aq_ptp)
+{
+	return atomic_read(&aq_ptp->offset_ingress);
+}
+
+void aq_ptp_tm_offset_set(struct aq_nic_s *aq_nic, unsigned int mbps)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	int i, egress, ingress;
+
+	if (!aq_ptp)
+		return;
+
+	egress =3D 0;
+	ingress =3D 0;
+
+	for (i =3D 0; i < ARRAY_SIZE(ptp_offset); i++) {
+		if (mbps =3D=3D ptp_offset[i].mbps) {
+			egress =3D ptp_offset[i].egress;
+			ingress =3D ptp_offset[i].ingress;
+			break;
+		}
+	}
+
+	atomic_set(&aq_ptp->offset_egress, egress);
+	atomic_set(&aq_ptp->offset_ingress, ingress);
+}
+
+static int __aq_ptp_skb_put(struct ptp_skb_ring *ring, struct sk_buff *skb=
)
+{
+	unsigned int next_head =3D (ring->head + 1) % ring->size;
+
+	if (next_head =3D=3D ring->tail)
+		return -1;
+
+	ring->buff[ring->head] =3D skb_get(skb);
+	ring->head =3D next_head;
+
+	return 0;
+}
+
+static int aq_ptp_skb_put(struct ptp_skb_ring *ring, struct sk_buff *skb)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	ret =3D __aq_ptp_skb_put(ring, skb);
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	return ret;
+}
+
+static struct sk_buff *__aq_ptp_skb_get(struct ptp_skb_ring *ring)
+{
+	struct sk_buff *skb;
+
+	if (ring->tail =3D=3D ring->head)
+		return NULL;
+
+	skb =3D ring->buff[ring->tail];
+	ring->tail =3D (ring->tail + 1) % ring->size;
+
+	return skb;
+}
+
+static struct sk_buff *aq_ptp_skb_get(struct ptp_skb_ring *ring)
+{
+	unsigned long flags;
+	struct sk_buff *skb;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	skb =3D __aq_ptp_skb_get(ring);
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	return skb;
+}
+
+static unsigned int aq_ptp_skb_buf_len(struct ptp_skb_ring *ring)
+{
+	unsigned long flags;
+	unsigned int len;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	len =3D (ring->head >=3D ring->tail) ?
+	ring->head - ring->tail :
+	ring->size - ring->tail + ring->head;
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	return len;
+}
+
 static int aq_ptp_skb_ring_init(struct ptp_skb_ring *ring, unsigned int si=
ze)
 {
 	struct sk_buff **buff =3D kmalloc(sizeof(*buff) * size, GFP_KERNEL);
@@ -56,10 +187,75 @@ static int aq_ptp_skb_ring_init(struct ptp_skb_ring *r=
ing, unsigned int size)
 	return 0;
 }
=20
+static void aq_ptp_skb_ring_clean(struct ptp_skb_ring *ring)
+{
+	struct sk_buff *skb;
+
+	while ((skb =3D aq_ptp_skb_get(ring)) !=3D NULL)
+		dev_kfree_skb_any(skb);
+}
+
 static void aq_ptp_skb_ring_release(struct ptp_skb_ring *ring)
 {
-	kfree(ring->buff);
-	ring->buff =3D NULL;
+	if (ring->buff) {
+		aq_ptp_skb_ring_clean(ring);
+		kfree(ring->buff);
+		ring->buff =3D NULL;
+	}
+}
+
+static void aq_ptp_tx_timeout_init(struct ptp_tx_timeout *timeout)
+{
+	spin_lock_init(&timeout->lock);
+	timeout->active =3D false;
+}
+
+static void aq_ptp_tx_timeout_start(struct aq_ptp_s *aq_ptp)
+{
+	struct ptp_tx_timeout *timeout =3D &aq_ptp->ptp_tx_timeout;
+	unsigned long flags;
+
+	spin_lock_irqsave(&timeout->lock, flags);
+	timeout->active =3D true;
+	timeout->tx_start =3D jiffies;
+	spin_unlock_irqrestore(&timeout->lock, flags);
+}
+
+static void aq_ptp_tx_timeout_update(struct aq_ptp_s *aq_ptp)
+{
+	if (!aq_ptp_skb_buf_len(&aq_ptp->skb_ring)) {
+		struct ptp_tx_timeout *timeout =3D &aq_ptp->ptp_tx_timeout;
+		unsigned long flags;
+
+		spin_lock_irqsave(&timeout->lock, flags);
+		timeout->active =3D false;
+		spin_unlock_irqrestore(&timeout->lock, flags);
+	}
+}
+
+static void aq_ptp_tx_timeout_check(struct aq_ptp_s *aq_ptp)
+{
+	struct ptp_tx_timeout *timeout =3D &aq_ptp->ptp_tx_timeout;
+	unsigned long flags;
+	bool timeout_flag;
+
+	timeout_flag =3D false;
+
+	spin_lock_irqsave(&timeout->lock, flags);
+	if (timeout->active) {
+		timeout_flag =3D time_is_before_jiffies(timeout->tx_start +
+						      AQ_PTP_TX_TIMEOUT);
+		/* reset active flag if timeout detected */
+		if (timeout_flag)
+			timeout->active =3D false;
+	}
+	spin_unlock_irqrestore(&timeout->lock, flags);
+
+	if (timeout_flag) {
+		aq_ptp_skb_ring_clean(&aq_ptp->skb_ring);
+		netdev_err(aq_ptp->aq_nic->ndev,
+			   "PTP Timeout. Clearing Tx Timestamp SKBs\n");
+	}
 }
=20
 /* aq_ptp_adjfreq
@@ -148,6 +344,263 @@ static int aq_ptp_settime(struct ptp_clock_info *ptp,
 	return 0;
 }
=20
+static void aq_ptp_convert_to_hwtstamp(struct aq_ptp_s *aq_ptp,
+				       struct skb_shared_hwtstamps *hwtstamp,
+				       u64 timestamp)
+{
+	memset(hwtstamp, 0, sizeof(*hwtstamp));
+	hwtstamp->hwtstamp =3D ns_to_ktime(timestamp);
+}
+
+/* aq_ptp_tx_hwtstamp - utility function which checks for TX time stamp
+ * @adapter: the private adapter struct
+ *
+ * if the timestamp is valid, we convert it into the timecounter ns
+ * value, then store that result into the hwtstamps structure which
+ * is passed up the network stack
+ */
+void aq_ptp_tx_hwtstamp(struct aq_nic_s *aq_nic, u64 timestamp)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	struct sk_buff *skb =3D aq_ptp_skb_get(&aq_ptp->skb_ring);
+	struct skb_shared_hwtstamps hwtstamp;
+
+	if (!skb) {
+		netdev_err(aq_nic->ndev, "have timestamp but tx_queus empty\n");
+		return;
+	}
+
+	timestamp +=3D aq_ptp_tm_offset_egress_get(aq_ptp);
+	aq_ptp_convert_to_hwtstamp(aq_ptp, &hwtstamp, timestamp);
+	skb_tstamp_tx(skb, &hwtstamp);
+	dev_kfree_skb_any(skb);
+
+	aq_ptp_tx_timeout_update(aq_ptp);
+}
+
+/* aq_ptp_rx_hwtstamp - utility function which checks for RX time stamp
+ * @adapter: pointer to adapter struct
+ * @skb: particular skb to send timestamp with
+ *
+ * if the timestamp is valid, we convert it into the timecounter ns
+ * value, then store that result into the hwtstamps structure which
+ * is passed up the network stack
+ */
+static void aq_ptp_rx_hwtstamp(struct aq_ptp_s *aq_ptp, struct sk_buff *sk=
b,
+			       u64 timestamp)
+{
+	timestamp -=3D aq_ptp_tm_offset_ingress_get(aq_ptp);
+	aq_ptp_convert_to_hwtstamp(aq_ptp, skb_hwtstamps(skb), timestamp);
+}
+
+bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *ring)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+
+	if (!aq_ptp)
+		return false;
+
+	return &aq_ptp->ptp_tx =3D=3D ring ||
+	       &aq_ptp->ptp_rx =3D=3D ring || &aq_ptp->hwts_rx =3D=3D ring;
+}
+
+u16 aq_ptp_extract_ts(struct aq_nic_s *aq_nic, struct sk_buff *skb, u8 *p,
+		      unsigned int len)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	u64 timestamp =3D 0;
+	u16 ret =3D aq_nic->aq_hw_ops->rx_extract_ts(aq_nic->aq_hw,
+						   p, len, &timestamp);
+
+	if (ret > 0)
+		aq_ptp_rx_hwtstamp(aq_ptp, skb, timestamp);
+
+	return ret;
+}
+
+static int aq_ptp_poll(struct napi_struct *napi, int budget)
+{
+	struct aq_ptp_s *aq_ptp =3D container_of(napi, struct aq_ptp_s, napi);
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	bool was_cleaned =3D false;
+	int work_done =3D 0;
+	int err;
+
+	/* Processing PTP TX traffic */
+	err =3D aq_nic->aq_hw_ops->hw_ring_tx_head_update(aq_nic->aq_hw,
+							&aq_ptp->ptp_tx);
+	if (err < 0)
+		goto err_exit;
+
+	if (aq_ptp->ptp_tx.sw_head !=3D aq_ptp->ptp_tx.hw_head) {
+		aq_ring_tx_clean(&aq_ptp->ptp_tx);
+
+		was_cleaned =3D true;
+	}
+
+	/* Processing HW_TIMESTAMP RX traffic */
+	err =3D aq_nic->aq_hw_ops->hw_ring_hwts_rx_receive(aq_nic->aq_hw,
+							 &aq_ptp->hwts_rx);
+	if (err < 0)
+		goto err_exit;
+
+	if (aq_ptp->hwts_rx.sw_head !=3D aq_ptp->hwts_rx.hw_head) {
+		aq_ring_hwts_rx_clean(&aq_ptp->hwts_rx, aq_nic);
+
+		err =3D aq_nic->aq_hw_ops->hw_ring_hwts_rx_fill(aq_nic->aq_hw,
+							      &aq_ptp->hwts_rx);
+
+		was_cleaned =3D true;
+	}
+
+	/* Processing PTP RX traffic */
+	err =3D aq_nic->aq_hw_ops->hw_ring_rx_receive(aq_nic->aq_hw,
+						    &aq_ptp->ptp_rx);
+	if (err < 0)
+		goto err_exit;
+
+	if (aq_ptp->ptp_rx.sw_head !=3D aq_ptp->ptp_rx.hw_head) {
+		unsigned int sw_tail_old;
+
+		err =3D aq_ring_rx_clean(&aq_ptp->ptp_rx, napi, &work_done, budget);
+		if (err < 0)
+			goto err_exit;
+
+		sw_tail_old =3D aq_ptp->ptp_rx.sw_tail;
+		err =3D aq_ring_rx_fill(&aq_ptp->ptp_rx);
+		if (err < 0)
+			goto err_exit;
+
+		err =3D aq_nic->aq_hw_ops->hw_ring_rx_fill(aq_nic->aq_hw,
+							 &aq_ptp->ptp_rx,
+							 sw_tail_old);
+		if (err < 0)
+			goto err_exit;
+	}
+
+	if (was_cleaned)
+		work_done =3D budget;
+
+	if (work_done < budget) {
+		napi_complete_done(napi, work_done);
+		aq_nic->aq_hw_ops->hw_irq_enable(aq_nic->aq_hw,
+					1 << aq_ptp->ptp_ring_param.vec_idx);
+	}
+
+err_exit:
+	return work_done;
+}
+
+static irqreturn_t aq_ptp_isr(int irq, void *private)
+{
+	struct aq_ptp_s *aq_ptp =3D private;
+	int err =3D 0;
+
+	if (!aq_ptp) {
+		err =3D -EINVAL;
+		goto err_exit;
+	}
+	napi_schedule(&aq_ptp->napi);
+
+err_exit:
+	return err >=3D 0 ? IRQ_HANDLED : IRQ_NONE;
+}
+
+int aq_ptp_xmit(struct aq_nic_s *aq_nic, struct sk_buff *skb)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	struct aq_ring_s *ring =3D &aq_ptp->ptp_tx;
+	unsigned long irq_flags;
+	int err =3D NETDEV_TX_OK;
+	unsigned int frags;
+
+	if (skb->len <=3D 0) {
+		dev_kfree_skb_any(skb);
+		goto err_exit;
+	}
+
+	frags =3D skb_shinfo(skb)->nr_frags + 1;
+	/* Frags cannot be bigger 16KB
+	 * because PTP usually works
+	 * without Jumbo even in a background
+	 */
+	if (frags > AQ_CFG_SKB_FRAGS_MAX || frags > aq_ring_avail_dx(ring)) {
+		/* Drop packet because it doesn't make sence to delay it */
+		dev_kfree_skb_any(skb);
+		goto err_exit;
+	}
+
+	err =3D aq_ptp_skb_put(&aq_ptp->skb_ring, skb);
+	if (err) {
+		netdev_err(aq_nic->ndev, "SKB Ring is overflow (%u)!\n",
+			   ring->size);
+		return NETDEV_TX_BUSY;
+	}
+	skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
+	aq_ptp_tx_timeout_start(aq_ptp);
+	skb_tx_timestamp(skb);
+
+	spin_lock_irqsave(&aq_nic->aq_ptp->ptp_ring_lock, irq_flags);
+	frags =3D aq_nic_map_skb(aq_nic, skb, ring);
+
+	if (likely(frags)) {
+		err =3D aq_nic->aq_hw_ops->hw_ring_tx_xmit(aq_nic->aq_hw,
+						       ring, frags);
+		if (err >=3D 0) {
+			++ring->stats.tx.packets;
+			ring->stats.tx.bytes +=3D skb->len;
+		}
+	} else {
+		err =3D NETDEV_TX_BUSY;
+	}
+	spin_unlock_irqrestore(&aq_nic->aq_ptp->ptp_ring_lock, irq_flags);
+
+err_exit:
+	return err;
+}
+
+void aq_ptp_service_task(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+
+	if (!aq_ptp)
+		return;
+
+	aq_ptp_tx_timeout_check(aq_ptp);
+}
+
+int aq_ptp_irq_alloc(struct aq_nic_s *aq_nic)
+{
+	struct pci_dev *pdev =3D aq_nic->pdev;
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	int err =3D 0;
+
+	if (!aq_ptp)
+		return 0;
+
+	if (pdev->msix_enabled || pdev->msi_enabled) {
+		err =3D request_irq(pci_irq_vector(pdev, aq_ptp->idx_vector),
+				  aq_ptp_isr, 0, aq_nic->ndev->name, aq_ptp);
+	} else {
+		err =3D -EINVAL;
+		goto err_exit;
+	}
+
+err_exit:
+	return err;
+}
+
+void aq_ptp_irq_free(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	struct pci_dev *pdev =3D aq_nic->pdev;
+
+	if (!aq_ptp)
+		return;
+
+	free_irq(pci_irq_vector(pdev, aq_ptp->idx_vector), aq_ptp);
+}
+
 int aq_ptp_ring_init(struct aq_nic_s *aq_nic)
 {
 	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
@@ -189,6 +642,12 @@ int aq_ptp_ring_init(struct aq_nic_s *aq_nic)
 	err =3D aq_nic->aq_hw_ops->hw_ring_rx_init(aq_nic->aq_hw,
 						 &aq_ptp->hwts_rx,
 						 &aq_ptp->ptp_ring_param);
+	if (err < 0)
+		goto err_exit;
+	err =3D aq_nic->aq_hw_ops->hw_ring_hwts_rx_fill(aq_nic->aq_hw,
+						      &aq_ptp->hwts_rx);
+	if (err < 0)
+		goto err_exit;
=20
 err_exit:
 	return err;
@@ -215,6 +674,8 @@ int aq_ptp_ring_start(struct aq_nic_s *aq_nic)
 	if (err < 0)
 		goto err_exit;
=20
+	napi_enable(&aq_ptp->napi);
+
 err_exit:
 	return err;
 }
@@ -230,6 +691,8 @@ void aq_ptp_ring_stop(struct aq_nic_s *aq_nic)
 	aq_nic->aq_hw_ops->hw_ring_rx_stop(aq_nic->aq_hw, &aq_ptp->ptp_rx);
=20
 	aq_nic->aq_hw_ops->hw_ring_rx_stop(aq_nic->aq_hw, &aq_ptp->hwts_rx);
+
+	napi_disable(&aq_ptp->napi);
 }
=20
 void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic)
@@ -302,6 +765,12 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 		goto err_exit_4;
 	}
=20
+	aq_ptp->ptp_ring_param.vec_idx =3D aq_ptp->idx_vector;
+	aq_ptp->ptp_ring_param.cpu =3D aq_ptp->ptp_ring_param.vec_idx +
+			aq_nic_get_cfg(aq_nic)->aq_rss.base_cpu_number;
+	cpumask_set_cpu(aq_ptp->ptp_ring_param.cpu,
+			&aq_ptp->ptp_ring_param.affinity_mask);
+
 	return 0;
=20
 err_exit_4:
@@ -343,6 +812,60 @@ static struct ptp_clock_info aq_ptp_clock =3D {
 	.pin_config    =3D NULL,
 };
=20
+#define ptp_offset_init(__idx, __mbps, __egress, __ingress)   do { \
+		ptp_offset[__idx].mbps =3D (__mbps); \
+		ptp_offset[__idx].egress =3D (__egress); \
+		ptp_offset[__idx].ingress =3D (__ingress); } \
+		while (0)
+
+static void aq_ptp_offset_init_from_fw(const struct hw_aq_ptp_offset *offs=
ets)
+{
+	int i;
+
+	/* Load offsets for PTP */
+	for (i =3D 0; i < ARRAY_SIZE(ptp_offset); i++) {
+		switch (i) {
+		/* 100M */
+		case ptp_offset_idx_100:
+			ptp_offset_init(i, 100,
+					offsets->egress_100,
+					offsets->ingress_100);
+			break;
+		/* 1G */
+		case ptp_offset_idx_1000:
+			ptp_offset_init(i, 1000,
+					offsets->egress_1000,
+					offsets->ingress_1000);
+			break;
+		/* 2.5G */
+		case ptp_offset_idx_2500:
+			ptp_offset_init(i, 2500,
+					offsets->egress_2500,
+					offsets->ingress_2500);
+			break;
+		/* 5G */
+		case ptp_offset_idx_5000:
+			ptp_offset_init(i, 5000,
+					offsets->egress_5000,
+					offsets->ingress_5000);
+			break;
+		/* 10G */
+		case ptp_offset_idx_10000:
+			ptp_offset_init(i, 10000,
+					offsets->egress_10000,
+					offsets->ingress_10000);
+			break;
+		}
+	}
+}
+
+static void aq_ptp_offset_init(const struct hw_aq_ptp_offset *offsets)
+{
+	memset(ptp_offset, 0, sizeof(ptp_offset));
+
+	aq_ptp_offset_init_from_fw(offsets);
+}
+
 void aq_ptp_clock_init(struct aq_nic_s *aq_nic)
 {
 	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
@@ -376,6 +899,8 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int i=
dx_vec)
 		return 0;
 	}
=20
+	aq_ptp_offset_init(&mbox.info.ptp_offset);
+
 	aq_ptp =3D kzalloc(sizeof(*aq_ptp), GFP_KERNEL);
 	if (!aq_ptp) {
 		err =3D -ENOMEM;
@@ -395,6 +920,15 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int =
idx_vec)
 		goto err_exit;
 	}
 	aq_ptp->ptp_clock =3D clock;
+	aq_ptp_tx_timeout_init(&aq_ptp->ptp_tx_timeout);
+
+	atomic_set(&aq_ptp->offset_egress, 0);
+	atomic_set(&aq_ptp->offset_ingress, 0);
+
+	netif_napi_add(aq_nic_get_ndev(aq_nic), &aq_ptp->napi,
+		       aq_ptp_poll, AQ_CFG_NAPI_WEIGHT);
+
+	aq_ptp->idx_vector =3D idx_vec;
=20
 	aq_nic->aq_ptp =3D aq_ptp;
=20
@@ -435,6 +969,12 @@ void aq_ptp_free(struct aq_nic_s *aq_nic)
 	aq_nic->aq_fw_ops->enable_ptp(aq_nic->aq_hw, 0);
 	mutex_unlock(&aq_nic->fwreq_mutex);
=20
+	netif_napi_del(&aq_ptp->napi);
 	kfree(aq_ptp);
 	aq_nic->aq_ptp =3D NULL;
 }
+
+struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_ptp_s *aq_ptp)
+{
+	return aq_ptp->ptp_clock;
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.h
index 32350f75e138..2c84483fcac1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -17,6 +17,9 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx=
_vec);
 void aq_ptp_unregister(struct aq_nic_s *aq_nic);
 void aq_ptp_free(struct aq_nic_s *aq_nic);
=20
+int aq_ptp_irq_alloc(struct aq_nic_s *aq_nic);
+void aq_ptp_irq_free(struct aq_nic_s *aq_nic);
+
 int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic);
 void aq_ptp_ring_free(struct aq_nic_s *aq_nic);
=20
@@ -25,6 +28,22 @@ int aq_ptp_ring_start(struct aq_nic_s *aq_nic);
 void aq_ptp_ring_stop(struct aq_nic_s *aq_nic);
 void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic);
=20
+void aq_ptp_service_task(struct aq_nic_s *aq_nic);
+
+void aq_ptp_tm_offset_set(struct aq_nic_s *aq_nic, unsigned int mbps);
+
 void aq_ptp_clock_init(struct aq_nic_s *aq_nic);
=20
+/* Traffic processing functions */
+int aq_ptp_xmit(struct aq_nic_s *aq_nic, struct sk_buff *skb);
+void aq_ptp_tx_hwtstamp(struct aq_nic_s *aq_nic, u64 timestamp);
+
+/* Return either ring is belong to PTP or not*/
+bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *ring);
+
+u16 aq_ptp_extract_ts(struct aq_nic_s *aq_nic, struct sk_buff *skb, u8 *p,
+		      unsigned int len);
+
+struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_ptp_s *aq_ptp);
+
 #endif /* AQ_PTP_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c
index 6d57928f8a37..469507776fa5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -10,6 +10,7 @@
 #include "aq_nic.h"
 #include "aq_hw.h"
 #include "aq_hw_utils.h"
+#include "aq_ptp.h"
=20
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
@@ -321,6 +322,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		self->sw_head =3D aq_ring_next_dx(self, self->sw_head),
 		--budget, ++(*work_done)) {
 		struct aq_ring_buff_s *buff =3D &self->buff_ring[self->sw_head];
+		bool is_ptp_ring =3D aq_ptp_ring(self->aq_nic, self);
 		struct aq_ring_buff_s *buff_ =3D NULL;
 		struct sk_buff *skb =3D NULL;
 		unsigned int next_ =3D 0U;
@@ -384,6 +386,11 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 				err =3D -ENOMEM;
 				goto err_exit;
 			}
+			if (is_ptp_ring)
+				buff->len -=3D
+					aq_ptp_extract_ts(self->aq_nic, skb,
+						aq_buf_vaddr(&buff->rxdata),
+						buff->len);
 			skb_put(skb, buff->len);
 			page_ref_inc(buff->rxdata.page);
 		} else {
@@ -392,6 +399,11 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 				err =3D -ENOMEM;
 				goto err_exit;
 			}
+			if (is_ptp_ring)
+				buff->len -=3D
+					aq_ptp_extract_ts(self->aq_nic, skb,
+						aq_buf_vaddr(&buff->rxdata),
+						buff->len);
=20
 			hdr_len =3D buff->len;
 			if (hdr_len > AQ_CFG_RX_HDR_SIZE)
@@ -451,8 +463,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		skb_set_hash(skb, buff->rss_hash,
 			     buff->is_hash_l4 ? PKT_HASH_TYPE_L4 :
 			     PKT_HASH_TYPE_NONE);
-
-		skb_record_rx_queue(skb, self->idx);
+		/* Send all PTP traffic to 0 queue */
+		skb_record_rx_queue(skb, is_ptp_ring ? 0 : self->idx);
=20
 		++self->stats.rx.packets;
 		self->stats.rx.bytes +=3D skb->len;
@@ -464,6 +476,21 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 	return err;
 }
=20
+void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic=
)
+{
+	while (self->sw_head !=3D self->hw_head) {
+		u64 ns;
+
+		aq_nic->aq_hw_ops->extract_hwts(aq_nic->aq_hw,
+						self->dx_ring +
+						(self->sw_head * self->dx_size),
+						self->dx_size, &ns);
+		aq_ptp_tx_hwtstamp(aq_nic, ns);
+
+		self->sw_head =3D aq_ring_next_dx(self, self->sw_head);
+	}
+}
+
 int aq_ring_rx_fill(struct aq_ring_s *self)
 {
 	unsigned int page_order =3D self->page_order;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.h
index 068689f44bc9..be3702a4dcc9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -177,5 +177,6 @@ int aq_ring_rx_fill(struct aq_ring_s *self);
 struct aq_ring_s *aq_ring_hwts_rx_alloc(struct aq_ring_s *self,
 		struct aq_nic_s *aq_nic, unsigned int idx,
 		unsigned int size, unsigned int dx_size);
+void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic=
);
=20
 #endif /* AQ_RING_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 692914f02e10..5722fd5fd52d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -682,6 +682,46 @@ static int hw_atl_b0_hw_ring_rx_fill(struct aq_hw_s *s=
elf,
 	return aq_hw_err_from_flags(self);
 }
=20
+static int hw_atl_b0_hw_ring_hwts_rx_fill(struct aq_hw_s *self,
+					  struct aq_ring_s *ring)
+{
+	unsigned int i;
+
+	for (i =3D aq_ring_avail_dx(ring); i--;
+			ring->sw_tail =3D aq_ring_next_dx(ring, ring->sw_tail)) {
+		struct hw_atl_rxd_s *rxd =3D
+			(struct hw_atl_rxd_s *)
+			&ring->dx_ring[ring->sw_tail * HW_ATL_B0_RXD_SIZE];
+
+		rxd->buf_addr =3D ring->dx_ring_pa + ring->size * ring->dx_size;
+		rxd->hdr_addr =3D 0U;
+	}
+	/* Make sure descriptors are updated before bump tail*/
+	wmb();
+
+	hw_atl_reg_rx_dma_desc_tail_ptr_set(self, ring->sw_tail, ring->idx);
+
+	return aq_hw_err_from_flags(self);
+}
+
+static int hw_atl_b0_hw_ring_hwts_rx_receive(struct aq_hw_s *self,
+					     struct aq_ring_s *ring)
+{
+	while (ring->hw_head !=3D ring->sw_tail) {
+		struct hw_atl_rxd_hwts_wb_s *hwts_wb =3D
+			(struct hw_atl_rxd_hwts_wb_s *)
+			(ring->dx_ring + (ring->hw_head * HW_ATL_B0_RXD_SIZE));
+
+		/* RxD is not done */
+		if (!(hwts_wb->sec_lw0 & 0x1U))
+			break;
+
+		ring->hw_head =3D aq_ring_next_dx(ring, ring->hw_head);
+	}
+
+	return aq_hw_err_from_flags(self);
+}
+
 static int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
 					    struct aq_ring_s *ring)
 {
@@ -1120,6 +1160,61 @@ static int hw_atl_b0_adj_clock_freq(struct aq_hw_s *=
self, s32 ppb)
 	return self->aq_fw_ops->send_fw_request(self, &fwreq, size);
 }
=20
+static u16 hw_atl_b0_rx_extract_ts(struct aq_hw_s *self, u8 *p,
+				   unsigned int len, u64 *timestamp)
+{
+	unsigned int offset =3D 14;
+	struct ethhdr *eth;
+	u64 sec;
+	u8 *ptr;
+	u32 ns;
+
+	if (len <=3D offset || !timestamp)
+		return 0;
+
+	/* The TIMESTAMP in the end of package has following format:
+	 * (big-endian)
+	 *   struct {
+	 *     uint64_t sec;
+	 *     uint32_t ns;
+	 *     uint16_t stream_id;
+	 *   };
+	 */
+	ptr =3D p + (len - offset);
+	memcpy(&sec, ptr, sizeof(sec));
+	ptr +=3D sizeof(sec);
+	memcpy(&ns, ptr, sizeof(ns));
+
+	sec =3D be64_to_cpu(sec) & 0xffffffffffffllu;
+	ns =3D be32_to_cpu(ns);
+	*timestamp =3D sec * NSEC_PER_SEC + ns + self->ptp_clk_offset;
+
+	eth =3D (struct ethhdr *)p;
+
+	return (eth->h_proto =3D=3D htons(ETH_P_1588)) ? 12 : 14;
+}
+
+static int hw_atl_b0_extract_hwts(struct aq_hw_s *self, u8 *p, unsigned in=
t len,
+				  u64 *timestamp)
+{
+	struct hw_atl_rxd_hwts_wb_s *hwts_wb =3D (struct hw_atl_rxd_hwts_wb_s *)p=
;
+	u64 tmp, sec, ns;
+
+	sec =3D 0;
+	tmp =3D (hwts_wb->sec_lw0 >> 2) & 0x3ff;
+	sec +=3D tmp;
+	tmp =3D (u64)((hwts_wb->sec_lw1 >> 16) & 0xffff) << 10;
+	sec +=3D tmp;
+	tmp =3D (u64)(hwts_wb->sec_hw & 0xfff) << 26;
+	sec +=3D tmp;
+	tmp =3D (u64)((hwts_wb->sec_hw >> 22) & 0x3ff) << 38;
+	sec +=3D tmp;
+	ns =3D sec * NSEC_PER_SEC + hwts_wb->ns;
+	if (timestamp)
+		*timestamp =3D ns + self->ptp_clk_offset;
+	return 0;
+}
+
 static int hw_atl_b0_hw_fl3l4_clear(struct aq_hw_s *self,
 				    struct aq_rx_filter_l3l4 *data)
 {
@@ -1296,11 +1391,16 @@ const struct aq_hw_ops hw_atl_ops_b0 =3D {
 	.hw_tx_tc_mode_get       =3D hw_atl_b0_tx_tc_mode_get,
 	.hw_rx_tc_mode_get       =3D hw_atl_b0_rx_tc_mode_get,
=20
+	.hw_ring_hwts_rx_fill        =3D hw_atl_b0_hw_ring_hwts_rx_fill,
+	.hw_ring_hwts_rx_receive     =3D hw_atl_b0_hw_ring_hwts_rx_receive,
+
 	.hw_get_ptp_ts           =3D hw_atl_b0_get_ptp_ts,
 	.hw_adj_sys_clock        =3D hw_atl_b0_adj_sys_clock,
 	.hw_set_sys_clock        =3D hw_atl_b0_set_sys_clock,
 	.hw_adj_clock_freq       =3D hw_atl_b0_adj_clock_freq,
=20
+	.rx_extract_ts           =3D hw_atl_b0_rx_extract_ts,
+	.extract_hwts            =3D hw_atl_b0_extract_hwts,
 	.hw_set_offload          =3D hw_atl_b0_hw_offload_set,
 	.hw_set_fc                   =3D hw_atl_b0_set_fc,
 };
--=20
2.17.1

