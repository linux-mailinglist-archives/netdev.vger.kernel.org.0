Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02270CF7A6
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbfJHK5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:57:11 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:64603
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730647AbfJHK5I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:57:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lm5OrTGLN5hqEB0YCI8WYMAr8wCceZXYNWWpmwb89womxsFWxgzkLXmTATUPKFnqDlLPrlwhpJPYPMgIKvEkptv7HzhgWalChWa9OMAWm2ISKE7OPUJM8NWeAO0iv5yjjP0ZfNHS2wCGzNj99arSfP2pyZyDrftiZZ6Zyc7lrP+d5xDvgXQoMi8NCbJ6VTlnsdyhbadkDKl1GfHvySfczc50244BD0Yp9HmKWX3qoqmv6FoObjjp3xxygSL+zJfODMQzvDoZUOrzkSbOq3wdsxWY5SStrFGMyhf51ZNi0Je0g4SiI/jVqGfGjeFNXhuhBn3WagDIqEi+LfhDJ1KH1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fcJDcPY3zDjIzTW87FwBcxOu1hoJHGh81t7YUQ5DC8=;
 b=nUmnWnWYYcSomX0o7DeGpaH21m+BYwYmCEkkwIfXnoumFBClAtDGh+bslfZL8EkUruweZJfAXBmxCMvgEVjZnRW8qIWf2FePpzL7yUyhan5otAYjF7aiEYYFozxbcdyppSVQ9UZRXl5KibjcWu7JWX01NKYk2hIsH2fJAwqYC9KH4JImSzPFIbmg90SYtsx/1SqE+cCrqgIUAzeSzIPxQvICAbgvtr74wb5+GOeNa86rq9D3ED+D4eC197cGHrzg+HftZyQsyX1iLgSWF+ZxHaGKhTLl1S4Eh5kH08Hzn2KaWOxxjZphSQdOfrDjmTAbQipnsgebifhu2zQvTGI9qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fcJDcPY3zDjIzTW87FwBcxOu1hoJHGh81t7YUQ5DC8=;
 b=6TSo3tnoSuyfkJaQTdtMLvtUH4Gq9EZD3uhHNjDG+IY71WHq97kKX5FyJ9rSq7NQd4E9tbazFxNUlOVdGFexkjO9VOuBJvkqYRJk9mZXc3I9Nj+w9k00UpQRkshX55Q7Rff+sRgxMjn2nX0QSE72PxV582DQNNDIFcQeJ0KkZ0s=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:56:59 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:56:59 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: [PATCH v2 net-next 11/12] net: aquantia: add support for PIN funcs
Thread-Topic: [PATCH v2 net-next 11/12] net: aquantia: add support for PIN
 funcs
Thread-Index: AQHVfccb1xbD53UwYU6+rlPsc16kIw==
Date:   Tue, 8 Oct 2019 10:56:59 +0000
Message-ID: <0142dcd43c84ab7bc26076c3eb48d43e67d195cc.1570531332.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: 8b50b123-4fbd-47a3-7417-08d74bde3dea
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3666E93FC98E0243B2259132989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(118296001)(71190400001)(71200400001)(2501003)(256004)(14444005)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(11346002)(5640700003)(6512007)(99286004)(25786009)(66556008)(50226002)(76176011)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(30864003)(14454004)(26005)(36756003)(86362001)(446003)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fwd2SvP5rDuXe4cgNygqXI4aUQxt3RS0DczGK51n8tHd0APmraVTXeEgIPhZUQJZ+sN11/e+rwMtIyFMJzkwyEUmh8xQnkE9cpuXZ7F62PAMovbg2L6PfrLgbQH4/IdpwxtsgIHpcEjnrf94wY6/tnvvfgc8T0ybbAiCekRlwDdSp5ciCjUXd6TJQNLL4+F6twY3Zfx3qzpxO6TZTPS30WlqXCtgxnjSUMZMb9SFV2Mr2uyeRM4W9XJByuOUrbgK9ELpAX6BRmk3ZQk9Y2Fv5ZQxnF9q55t0Chpeog6yfRZbLJQC2Zp0yRheHLHCKjaiHM6nZLY9XhGP+0kwJimMaJX90lx/rUecdmbzsboQuUcExwdo4KFxee6HyuDC7u5vak7NA/riP+fddRkJX56AvxHASGISK+43CII6HHl2moA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b50b123-4fbd-47a3-7417-08d74bde3dea
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:56:59.2331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oyJTFLd7y0zsKIJMc5BrQ/zSPQXWc/9/j2XklWZIfifrUgMNMwQmfF53VIBWfuP8qFcr5gzOWX4zTuG074YVyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

Depending on FW configuration we can manage from 0 to 3 PINs for periodic o=
utput
and from 0 to 1 ext ts PIN for getting TS for external event.

Ext TS PIN functionality is implemented via periodic timestamps polling
directly from PHY, because right now there is now way to received
PIN trigger interrupt from phy.

Poller delay is 15ms.

Co-developed-by: Egor Pomozov <egor.pomozov@aquantia.com>
Signed-off-by: Egor Pomozov <egor.pomozov@aquantia.com>
Co-developed-by: Pavel Belous <pavel.belous@aquantia.com>
Signed-off-by: Pavel Belous <pavel.belous@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  10 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   1 +
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 339 ++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |   2 +
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  63 +++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |   8 +
 6 files changed, 422 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index c36c0d7d038e..5246cf44ce51 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -259,6 +259,16 @@ struct aq_hw_ops {
=20
 	int (*hw_set_sys_clock)(struct aq_hw_s *self, u64 time, u64 ts);
=20
+	int (*hw_ts_to_sys_clock)(struct aq_hw_s *self, u64 ts, u64 *time);
+
+	int (*hw_gpio_pulse)(struct aq_hw_s *self, u32 index, u64 start,
+			     u32 period);
+
+	int (*hw_extts_gpio_enable)(struct aq_hw_s *self, u32 index,
+				    u32 enable);
+
+	int (*hw_get_sync_ts)(struct aq_hw_s *self, u64 *ts);
+
 	u16 (*rx_extract_ts)(struct aq_hw_s *self, u8 *p, unsigned int len,
 			     u64 *timestamp);
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index b7960490ca90..3c821d1a4372 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -152,6 +152,7 @@ static int aq_nic_update_link_status(struct aq_nic_s *s=
elf)
 			aq_ptp_clock_init(self);
 			aq_ptp_tm_offset_set(self,
 					     self->aq_hw->aq_link_status.mbps);
+			aq_ptp_link_change(self);
 		}
=20
 		/* Driver has to update flow control settings on RX block
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index 39ba2d20728a..116c85e0b15a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -15,10 +15,13 @@
 #include "aq_nic.h"
 #include "aq_ptp.h"
 #include "aq_ring.h"
+#include "aq_phy.h"
 #include "aq_filters.h"
=20
 #define AQ_PTP_TX_TIMEOUT        (HZ *  10)
=20
+#define POLL_SYNC_TIMER_MS 15
+
 enum ptp_speed_offsets {
 	ptp_offset_idx_10 =3D 0,
 	ptp_offset_idx_100,
@@ -70,6 +73,12 @@ struct aq_ptp_s {
=20
 	struct aq_rx_filter_l3l4 udp_filter;
 	struct aq_rx_filter_l2 eth_type_filter;
+
+	struct delayed_work poll_sync;
+	u32 poll_timeout_ms;
+
+	bool extts_pin_enabled;
+	u64 last_sync1588_ts;
 };
=20
 struct ptp_tm_offset {
@@ -359,6 +368,168 @@ static void aq_ptp_convert_to_hwtstamp(struct aq_ptp_=
s *aq_ptp,
 	hwtstamp->hwtstamp =3D ns_to_ktime(timestamp);
 }
=20
+static int aq_ptp_hw_pin_conf(struct aq_nic_s *aq_nic, u32 pin_index, u64 =
start,
+			      u64 period)
+{
+	if (period)
+		netdev_info(aq_nic->ndev,
+			    "Enable GPIO %d pulsing, start time %llu, period %u\n",
+			    pin_index, start, (u32)period);
+	else
+		netdev_info(aq_nic->ndev,
+			    "Disable GPIO %d pulsing, start time %llu, period %u\n",
+			    pin_index, start, (u32)period);
+
+	/* Notify hardware of request to being sending pulses.
+	 * If period is ZERO then pulsen is disabled.
+	 */
+	mutex_lock(&aq_nic->fwreq_mutex);
+	aq_nic->aq_hw_ops->hw_gpio_pulse(aq_nic->aq_hw, pin_index,
+					 start, (u32)period);
+	mutex_unlock(&aq_nic->fwreq_mutex);
+
+	return 0;
+}
+
+static int aq_ptp_perout_pin_configure(struct ptp_clock_info *ptp,
+				       struct ptp_clock_request *rq, int on)
+{
+	struct aq_ptp_s *aq_ptp =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct ptp_clock_time *t =3D &rq->perout.period;
+	struct ptp_clock_time *s =3D &rq->perout.start;
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	u64 start, period;
+	u32 pin_index =3D rq->perout.index;
+
+	/* verify the request channel is there */
+	if (pin_index >=3D ptp->n_per_out)
+		return -EINVAL;
+
+	/* we cannot support periods greater
+	 * than 4 seconds due to reg limit
+	 */
+	if (t->sec > 4 || t->sec < 0)
+		return -ERANGE;
+
+	/* convert to unsigned 64b ns,
+	 * verify we can put it in a 32b register
+	 */
+	period =3D on ? t->sec * NSEC_PER_SEC + t->nsec : 0;
+
+	/* verify the value is in range supported by hardware */
+	if (period > U32_MAX)
+		return -ERANGE;
+	/* convert to unsigned 64b ns */
+	/* TODO convert to AQ time */
+	start =3D on ? s->sec * NSEC_PER_SEC + s->nsec : 0;
+
+	aq_ptp_hw_pin_conf(aq_nic, pin_index, start, period);
+
+	return 0;
+}
+
+static int aq_ptp_pps_pin_configure(struct ptp_clock_info *ptp,
+				    struct ptp_clock_request *rq, int on)
+{
+	struct aq_ptp_s *aq_ptp =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	u64 start, period;
+	u32 pin_index =3D 0;
+	u32 rest =3D 0;
+
+	/* verify the request channel is there */
+	if (pin_index >=3D ptp->n_per_out)
+		return -EINVAL;
+
+	aq_nic->aq_hw_ops->hw_get_ptp_ts(aq_nic->aq_hw, &start);
+	div_u64_rem(start, NSEC_PER_SEC, &rest);
+	period =3D on ? NSEC_PER_SEC : 0; /* PPS - pulse per second */
+	start =3D on ? start - rest + NSEC_PER_SEC *
+		(rest > 990000000LL ? 2 : 1) : 0;
+
+	aq_ptp_hw_pin_conf(aq_nic, pin_index, start, period);
+
+	return 0;
+}
+
+static void aq_ptp_extts_pin_ctrl(struct aq_ptp_s *aq_ptp)
+{
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	u32 enable =3D aq_ptp->extts_pin_enabled;
+
+	if (aq_nic->aq_hw_ops->hw_extts_gpio_enable)
+		aq_nic->aq_hw_ops->hw_extts_gpio_enable(aq_nic->aq_hw, 0,
+							enable);
+}
+
+static int aq_ptp_extts_pin_configure(struct ptp_clock_info *ptp,
+				      struct ptp_clock_request *rq, int on)
+{
+	struct aq_ptp_s *aq_ptp =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+
+	u32 pin_index =3D rq->extts.index;
+
+	if (pin_index >=3D ptp->n_ext_ts)
+		return -EINVAL;
+
+	aq_ptp->extts_pin_enabled =3D !!on;
+	if (on) {
+		aq_ptp->poll_timeout_ms =3D POLL_SYNC_TIMER_MS;
+		cancel_delayed_work_sync(&aq_ptp->poll_sync);
+		schedule_delayed_work(&aq_ptp->poll_sync,
+				      msecs_to_jiffies(aq_ptp->poll_timeout_ms));
+	}
+
+	aq_ptp_extts_pin_ctrl(aq_ptp);
+	return 0;
+}
+
+/* aq_ptp_gpio_feature_enable
+ * @ptp: the ptp clock structure
+ * @rq: the requested feature to change
+ * @on: whether to enable or disable the feature
+ */
+static int aq_ptp_gpio_feature_enable(struct ptp_clock_info *ptp,
+				      struct ptp_clock_request *rq, int on)
+{
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		return aq_ptp_extts_pin_configure(ptp, rq, on);
+	case PTP_CLK_REQ_PEROUT:
+		return aq_ptp_perout_pin_configure(ptp, rq, on);
+	case PTP_CLK_REQ_PPS:
+		return aq_ptp_pps_pin_configure(ptp, rq, on);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+/* aq_ptp_verify
+ * @ptp: the ptp clock structure
+ * @pin: index of the pin in question
+ * @func: the desired function to use
+ * @chan: the function channel index to use
+ */
+static int aq_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
+			 enum ptp_pin_function func, unsigned int chan)
+{
+	/* verify the requested pin is there */
+	if (!ptp->pin_config || pin >=3D ptp->n_pins)
+		return -EINVAL;
+
+	/* enforce locked channels, no changing them */
+	if (chan !=3D ptp->pin_config[pin].chan)
+		return -EINVAL;
+
+	/* we want to keep the functions locked as well */
+	if (func !=3D ptp->pin_config[pin].func)
+		return -EINVAL;
+
+	return 0;
+}
+
 /* aq_ptp_tx_hwtstamp - utility function which checks for TX time stamp
  * @adapter: the private adapter struct
  *
@@ -866,6 +1037,8 @@ void aq_ptp_ring_free(struct aq_nic_s *aq_nic)
 	aq_ptp_skb_ring_release(&aq_ptp->skb_ring);
 }
=20
+#define MAX_PTP_GPIO_COUNT 4
+
 static struct ptp_clock_info aq_ptp_clock =3D {
 	.owner		=3D THIS_MODULE,
 	.name		=3D "atlantic ptp",
@@ -877,7 +1050,9 @@ static struct ptp_clock_info aq_ptp_clock =3D {
 	.gettime64	=3D aq_ptp_gettime,
 	.settime64	=3D aq_ptp_settime,
 	.n_per_out     =3D 0,
+	.enable        =3D aq_ptp_gpio_feature_enable,
 	.n_pins        =3D 0,
+	.verify        =3D aq_ptp_verify,
 	.pin_config    =3D NULL,
 };
=20
@@ -935,6 +1110,57 @@ static void aq_ptp_offset_init(const struct hw_aq_ptp=
_offset *offsets)
 	aq_ptp_offset_init_from_fw(offsets);
 }
=20
+static void aq_ptp_gpio_init(struct ptp_clock_info *info,
+			     struct hw_aq_info *hw_info)
+{
+	struct ptp_pin_desc pin_desc[MAX_PTP_GPIO_COUNT];
+	u32 extts_pin_cnt =3D 0;
+	u32 out_pin_cnt =3D 0;
+	u32 i;
+
+	memset(pin_desc, 0, sizeof(pin_desc));
+
+	for (i =3D 0; i < MAX_PTP_GPIO_COUNT - 1; i++) {
+		if (hw_info->gpio_pin[i] =3D=3D
+		    (GPIO_PIN_FUNCTION_PTP0 + out_pin_cnt)) {
+			snprintf(pin_desc[out_pin_cnt].name,
+				 sizeof(pin_desc[out_pin_cnt].name),
+				 "AQ_GPIO%d", i);
+			pin_desc[out_pin_cnt].index =3D out_pin_cnt;
+			pin_desc[out_pin_cnt].chan =3D out_pin_cnt;
+			pin_desc[out_pin_cnt++].func =3D PTP_PF_PEROUT;
+		}
+	}
+
+	info->n_per_out =3D out_pin_cnt;
+
+	if (hw_info->caps_ex & BIT(CAPS_EX_PHY_CTRL_TS_PIN)) {
+		extts_pin_cnt +=3D 1;
+
+		snprintf(pin_desc[out_pin_cnt].name,
+			 sizeof(pin_desc[out_pin_cnt].name),
+			  "AQ_GPIO%d", out_pin_cnt);
+		pin_desc[out_pin_cnt].index =3D out_pin_cnt;
+		pin_desc[out_pin_cnt].chan =3D 0;
+		pin_desc[out_pin_cnt].func =3D PTP_PF_EXTTS;
+	}
+
+	info->n_pins =3D out_pin_cnt + extts_pin_cnt;
+	info->n_ext_ts =3D extts_pin_cnt;
+
+	if (!info->n_pins)
+		return;
+
+	info->pin_config =3D kcalloc(info->n_pins, sizeof(struct ptp_pin_desc),
+				   GFP_KERNEL);
+
+	if (!info->pin_config)
+		return;
+
+	memcpy(info->pin_config, &pin_desc,
+	       sizeof(struct ptp_pin_desc) * info->n_pins);
+}
+
 void aq_ptp_clock_init(struct aq_nic_s *aq_nic)
 {
 	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
@@ -944,6 +1170,8 @@ void aq_ptp_clock_init(struct aq_nic_s *aq_nic)
 	aq_ptp_settime(&aq_ptp->ptp_info, &ts);
 }
=20
+static void aq_ptp_poll_sync_work_cb(struct work_struct *w);
+
 int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 {
 	struct hw_atl_utils_mbox mbox;
@@ -982,6 +1210,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int =
idx_vec)
 	spin_lock_init(&aq_ptp->ptp_ring_lock);
=20
 	aq_ptp->ptp_info =3D aq_ptp_clock;
+	aq_ptp_gpio_init(&aq_ptp->ptp_info, &mbox.info);
 	clock =3D ptp_clock_register(&aq_ptp->ptp_info, &aq_nic->ndev->dev);
 	if (!clock) {
 		netdev_err(aq_nic->ndev, "ptp_clock_register failed\n");
@@ -1008,6 +1237,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int=
 idx_vec)
 	aq_ptp_clock_init(aq_nic);
 	mutex_unlock(&aq_nic->fwreq_mutex);
=20
+	INIT_DELAYED_WORK(&aq_ptp->poll_sync, &aq_ptp_poll_sync_work_cb);
 	aq_ptp->eth_type_filter.location =3D
 			aq_nic_reserve_filter(aq_nic, aq_rx_filter_ethertype);
 	aq_ptp->udp_filter.location =3D
@@ -1016,6 +1246,8 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int=
 idx_vec)
 	return 0;
=20
 err_exit:
+	if (aq_ptp)
+		kfree(aq_ptp->ptp_info.pin_config);
 	kfree(aq_ptp);
 	aq_nic->aq_ptp =3D NULL;
 	return err;
@@ -1042,11 +1274,14 @@ void aq_ptp_free(struct aq_nic_s *aq_nic)
 			      aq_ptp->eth_type_filter.location);
 	aq_nic_release_filter(aq_nic, aq_rx_filter_l3l4,
 			      aq_ptp->udp_filter.location);
+	cancel_delayed_work_sync(&aq_ptp->poll_sync);
 	/* disable ptp */
 	mutex_lock(&aq_nic->fwreq_mutex);
 	aq_nic->aq_fw_ops->enable_ptp(aq_nic->aq_hw, 0);
 	mutex_unlock(&aq_nic->fwreq_mutex);
=20
+	kfree(aq_ptp->ptp_info.pin_config);
+
 	netif_napi_del(&aq_ptp->napi);
 	kfree(aq_ptp);
 	aq_nic->aq_ptp =3D NULL;
@@ -1056,3 +1291,107 @@ struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_pt=
p_s *aq_ptp)
 {
 	return aq_ptp->ptp_clock;
 }
+
+/* PTP external GPIO nanoseconds count */
+static uint64_t aq_ptp_get_sync1588_ts(struct aq_nic_s *aq_nic)
+{
+	u64 ts =3D 0;
+
+	if (aq_nic->aq_hw_ops->hw_get_sync_ts)
+		aq_nic->aq_hw_ops->hw_get_sync_ts(aq_nic->aq_hw, &ts);
+
+	return ts;
+}
+
+static void aq_ptp_start_work(struct aq_ptp_s *aq_ptp)
+{
+	if (aq_ptp->extts_pin_enabled) {
+		aq_ptp->poll_timeout_ms =3D POLL_SYNC_TIMER_MS;
+		aq_ptp->last_sync1588_ts =3D
+				aq_ptp_get_sync1588_ts(aq_ptp->aq_nic);
+		schedule_delayed_work(&aq_ptp->poll_sync,
+				      msecs_to_jiffies(aq_ptp->poll_timeout_ms));
+	}
+}
+
+int aq_ptp_link_change(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+
+	if (!aq_ptp)
+		return 0;
+
+	if (aq_nic->aq_hw->aq_link_status.mbps)
+		aq_ptp_start_work(aq_ptp);
+	else
+		cancel_delayed_work_sync(&aq_ptp->poll_sync);
+
+	return 0;
+}
+
+static bool aq_ptp_sync_ts_updated(struct aq_ptp_s *aq_ptp, u64 *new_ts)
+{
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	u64 sync_ts2;
+	u64 sync_ts;
+
+	sync_ts =3D aq_ptp_get_sync1588_ts(aq_nic);
+
+	if (sync_ts !=3D aq_ptp->last_sync1588_ts) {
+		sync_ts2 =3D aq_ptp_get_sync1588_ts(aq_nic);
+		if (sync_ts !=3D sync_ts2) {
+			sync_ts =3D sync_ts2;
+			sync_ts2 =3D aq_ptp_get_sync1588_ts(aq_nic);
+			if (sync_ts !=3D sync_ts2) {
+				netdev_err(aq_nic->ndev,
+					   "%s: Unable to get correct GPIO TS",
+					   __func__);
+				sync_ts =3D 0;
+			}
+		}
+
+		*new_ts =3D sync_ts;
+		return true;
+	}
+	return false;
+}
+
+static int aq_ptp_check_sync1588(struct aq_ptp_s *aq_ptp)
+{
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	u64 sync_ts;
+
+	 /* Sync1588 pin was triggered */
+	if (aq_ptp_sync_ts_updated(aq_ptp, &sync_ts)) {
+		if (aq_ptp->extts_pin_enabled) {
+			struct ptp_clock_event ptp_event;
+			u64 time =3D 0;
+
+			aq_nic->aq_hw_ops->hw_ts_to_sys_clock(aq_nic->aq_hw,
+							      sync_ts, &time);
+			ptp_event.index =3D aq_ptp->ptp_info.n_pins - 1;
+			ptp_event.timestamp =3D time;
+
+			ptp_event.type =3D PTP_CLOCK_EXTTS;
+			ptp_clock_event(aq_ptp->ptp_clock, &ptp_event);
+		}
+
+		aq_ptp->last_sync1588_ts =3D sync_ts;
+	}
+
+	return 0;
+}
+
+void aq_ptp_poll_sync_work_cb(struct work_struct *w)
+{
+	struct delayed_work *dw =3D to_delayed_work(w);
+	struct aq_ptp_s *aq_ptp =3D container_of(dw, struct aq_ptp_s, poll_sync);
+
+	aq_ptp_check_sync1588(aq_ptp);
+
+	if (aq_ptp->extts_pin_enabled) {
+		unsigned long timeout =3D msecs_to_jiffies(aq_ptp->poll_timeout_ms);
+
+		schedule_delayed_work(&aq_ptp->poll_sync, timeout);
+	}
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.h
index 7a7f36f43ce0..3de4682f7c06 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -52,4 +52,6 @@ u16 aq_ptp_extract_ts(struct aq_nic_s *aq_nic, struct sk_=
buff *skb, u8 *p,
=20
 struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_ptp_s *aq_ptp);
=20
+int aq_ptp_link_change(struct aq_nic_s *aq_nic);
+
 #endif /* AQ_PTP_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index f058ef1320c2..c6d540a670cd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -10,6 +10,7 @@
 #include "../aq_hw_utils.h"
 #include "../aq_ring.h"
 #include "../aq_nic.h"
+#include "../aq_phy.h"
 #include "hw_atl_b0.h"
 #include "hw_atl_utils.h"
 #include "hw_atl_llh.h"
@@ -1138,6 +1139,12 @@ static int hw_atl_b0_set_sys_clock(struct aq_hw_s *s=
elf, u64 time, u64 ts)
 	return hw_atl_b0_adj_sys_clock(self, delta);
 }
=20
+int hw_atl_b0_ts_to_sys_clock(struct aq_hw_s *self, u64 ts, u64 *time)
+{
+	*time =3D self->ptp_clk_offset + ts;
+	return 0;
+}
+
 static int hw_atl_b0_adj_clock_freq(struct aq_hw_s *self, s32 ppb)
 {
 	struct hw_fw_request_iface fwreq;
@@ -1160,6 +1167,57 @@ static int hw_atl_b0_adj_clock_freq(struct aq_hw_s *=
self, s32 ppb)
 	return self->aq_fw_ops->send_fw_request(self, &fwreq, size);
 }
=20
+static int hw_atl_b0_gpio_pulse(struct aq_hw_s *self, u32 index,
+				u64 start, u32 period)
+{
+	struct hw_fw_request_iface fwreq;
+	size_t size;
+
+	memset(&fwreq, 0, sizeof(fwreq));
+
+	fwreq.msg_id =3D HW_AQ_FW_REQUEST_PTP_GPIO_CTRL;
+	fwreq.ptp_gpio_ctrl.index =3D index;
+	fwreq.ptp_gpio_ctrl.period =3D period;
+	/* Apply time offset */
+	fwreq.ptp_gpio_ctrl.start =3D start - self->ptp_clk_offset;
+
+	size =3D sizeof(fwreq.msg_id) + sizeof(fwreq.ptp_gpio_ctrl);
+	return self->aq_fw_ops->send_fw_request(self, &fwreq, size);
+}
+
+static int hw_atl_b0_extts_gpio_enable(struct aq_hw_s *self, u32 index,
+				       u32 enable)
+{
+	/* Enable/disable Sync1588 GPIO Timestamping */
+	aq_phy_write_reg(self, MDIO_MMD_PCS, 0xc611, enable ? 0x71 : 0);
+
+	return 0;
+}
+
+static int hw_atl_b0_get_sync_ts(struct aq_hw_s *self, u64 *ts)
+{
+	u64 sec_l;
+	u64 sec_h;
+	u64 nsec_l;
+	u64 nsec_h;
+
+	if (!ts)
+		return -1;
+
+	/* PTP external GPIO clock seconds count 15:0 */
+	sec_l =3D aq_phy_read_reg(self, MDIO_MMD_PCS, 0xc914);
+	/* PTP external GPIO clock seconds count 31:16 */
+	sec_h =3D aq_phy_read_reg(self, MDIO_MMD_PCS, 0xc915);
+	/* PTP external GPIO clock nanoseconds count 15:0 */
+	nsec_l =3D aq_phy_read_reg(self, MDIO_MMD_PCS, 0xc916);
+	/* PTP external GPIO clock nanoseconds count 31:16 */
+	nsec_h =3D aq_phy_read_reg(self, MDIO_MMD_PCS, 0xc917);
+
+	*ts =3D (nsec_h << 16) + nsec_l + ((sec_h << 16) + sec_l) * NSEC_PER_SEC;
+
+	return 0;
+}
+
 static u16 hw_atl_b0_rx_extract_ts(struct aq_hw_s *self, u8 *p,
 				   unsigned int len, u64 *timestamp)
 {
@@ -1403,8 +1461,11 @@ const struct aq_hw_ops hw_atl_ops_b0 =3D {
 	.hw_get_ptp_ts           =3D hw_atl_b0_get_ptp_ts,
 	.hw_adj_sys_clock        =3D hw_atl_b0_adj_sys_clock,
 	.hw_set_sys_clock        =3D hw_atl_b0_set_sys_clock,
+	.hw_ts_to_sys_clock      =3D hw_atl_b0_ts_to_sys_clock,
 	.hw_adj_clock_freq       =3D hw_atl_b0_adj_clock_freq,
-
+	.hw_gpio_pulse           =3D hw_atl_b0_gpio_pulse,
+	.hw_extts_gpio_enable    =3D hw_atl_b0_extts_gpio_enable,
+	.hw_get_sync_ts          =3D hw_atl_b0_get_sync_ts,
 	.rx_extract_ts           =3D hw_atl_b0_rx_extract_ts,
 	.extract_hwts            =3D hw_atl_b0_extract_hwts,
 	.hw_set_offload          =3D hw_atl_b0_hw_offload_set,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 77132bda4696..37e6b696009d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -288,6 +288,12 @@ struct __packed offload_info {
 };
=20
 /* Mailbox FW Request interface */
+struct __packed hw_fw_request_ptp_gpio_ctrl {
+	u32 index;
+	u32 period;
+	u64 start;
+};
+
 struct __packed hw_fw_request_ptp_adj_freq {
 	u32 ns_mac;
 	u32 fns_mac;
@@ -303,6 +309,7 @@ struct __packed hw_fw_request_ptp_adj_clock {
 	int sign;
 };
=20
+#define HW_AQ_FW_REQUEST_PTP_GPIO_CTRL	         0x11
 #define HW_AQ_FW_REQUEST_PTP_ADJ_FREQ	         0x12
 #define HW_AQ_FW_REQUEST_PTP_ADJ_CLOCK	         0x13
=20
@@ -310,6 +317,7 @@ struct __packed hw_fw_request_iface {
 	u32 msg_id;
 	union {
 		/* PTP FW Request */
+		struct hw_fw_request_ptp_gpio_ctrl ptp_gpio_ctrl;
 		struct hw_fw_request_ptp_adj_freq ptp_adj_freq;
 		struct hw_fw_request_ptp_adj_clock ptp_adj_clock;
 	};
--=20
2.17.1

