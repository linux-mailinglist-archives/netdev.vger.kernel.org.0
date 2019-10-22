Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D51EE0139
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731652AbfJVJyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:54:09 -0400
Received: from mail-eopbgr810057.outbound.protection.outlook.com ([40.107.81.57]:7515
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731615AbfJVJyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:54:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1l2jjsxJjck40w3ET1eOSs1NYRbZK+yAB/p3dYjR1vdSR6+4IVHb+fRK/J4bG/5Nx76HfQ3g2uxEGjPpV8VsBsOEoKpUeCbCO7WJWbroc9YrKLye0b0A2Eyn2ioIeP/sHo9Kn8FhuxSANFMzZ/FQSpda7UK6ODhyrI8Deop6xTzHjOpkTVTxcJUqj/POMo7ZrVKBgWDYZqe+e5Yjm0PaaSJ1ZwE95Bd67DIbJwvrQfUmm9r/xUt06xXc+IGp9Wz6aZFNnLafGRpzMQFPuYvarjDCFQoPi7APZ4ZsdtwjN7sp4P1hx62Qy4gwagpIkjmv7B/fvkL3jPkxxmhd1cfnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lduXpA+bhXvvKK3aAAsjRrn/NUIOegxZvQ6uDZcFAh0=;
 b=i3FqxKzWdLKGorYry2PtRLKJR8w4XoAWeosECfKHd6u98D1O4Lm5rzZMWMCXevE3uwnkELADqe9ARIBue80rJSEtom5F3rzfim0gYx6q70Nl2ymp6dBdWuQTksCTMv18TjXxFRXPFwLj//M7COI9LhiUCZWdVWkxNESkM970GXz9WMxy+/Q0jTBuhxTtav7scMGPMif2d+ZF8625APAdwZkzxKGAmCC7GLaKQuHkEjtzUF0U5rzKkKFx3ZjATWVDlEGfwxBbmS7IuLui4kkPPdr4OOUEYyDS73hqrxF1qlCDx9L9leNKJPZ/qmx8awagIKusdB8blB99Lwi8tIX0fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lduXpA+bhXvvKK3aAAsjRrn/NUIOegxZvQ6uDZcFAh0=;
 b=0g0YSkXKdwI6HUbp4gSV8hJ/dyVOb3iSE3mXsrAWG+BgR5FIWSUv/3T3n2c1pIZfeDnxkbnCeP6Q2/BbTYyLlnsBPWufrMuvvwO0M5BN0irVE2n51ib12+OyIHRf3+muweoPFjjfme5yPR7QO6OpqZ9LVP9PtbeH4ln7A2ii5BY=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3650.namprd11.prod.outlook.com (20.178.221.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.21; Tue, 22 Oct 2019 09:53:47 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:47 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: [PATCH v3 net-next 11/12] net: aquantia: add support for PIN funcs
Thread-Topic: [PATCH v3 net-next 11/12] net: aquantia: add support for PIN
 funcs
Thread-Index: AQHViL6Zv6bQgftzjUGWtTbe7a4DrQ==
Date:   Tue, 22 Oct 2019 09:53:47 +0000
Message-ID: <a2a6ecfb5580858c2a690fa0ed1c98cffc61c4b9.1571737612.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: b3d61082-066c-429f-6258-08d756d5bba4
x-ms-traffictypediagnostic: BN8PR11MB3650:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3650C695BE0EA36671D00D3898680@BN8PR11MB3650.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(376002)(346002)(136003)(396003)(199004)(189003)(6512007)(30864003)(107886003)(4326008)(6486002)(6436002)(5640700003)(3846002)(6116002)(2351001)(7736002)(305945005)(25786009)(81166006)(81156014)(1730700003)(8676002)(14454004)(50226002)(8936002)(508600001)(66066001)(118296001)(66946007)(6916009)(66446008)(64756008)(66556008)(66476007)(316002)(54906003)(71200400001)(186003)(86362001)(2616005)(476003)(446003)(11346002)(102836004)(2501003)(26005)(76176011)(71190400001)(99286004)(256004)(14444005)(52116002)(6506007)(386003)(44832011)(2906002)(36756003)(486006)(5660300002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3650;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TZpksPvo0Nf4fiv3MemrYU8SeRAVYesDZ27EB+i34bJbyndPMtSXBew5LCpxnm1bydbw9GJMHmODI8v2MCV14iEdxTjqVK9Wwlym61V3vGpcve2I9XueOzwLXps2eYi6qNU5mXhfYI3w0DYxKqr/vvG60PnFzlGr8MXrUQtpDaspiPVfjn5GrkcbwfY7hcGrPLisTcYR+5DO/VMt314A8E8nD600aF7NIr5L7KBeqQi5YNFjR4uzkqIylcGDdyYFPfns78g2Fi/i2oeycaWdUgdK6oBtPmjRSa4yk+l/p/oyiGNhBgtIRBsDAHFBNGlEmJMzsKonMJ28RUO08cH2rvPqGS3RorWbO8SfknBWwql9QIJwI1jVuwPp3lzdEiosmzUJxTyQh53T1OfAY/BkU88tnMERvnVjGVnfHZcSzNGm/siNt3UtYiRqqI5RSbGl
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d61082-066c-429f-6258-08d756d5bba4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:47.4938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ByHAtIS4ghPouE99BkPfl98uqKzXOc5Y/pTNGebYViTfKHvT0RJXlxH+C0psAOZNVjxXjOlHCUfgVnXG4jAFxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3650
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

Depending on FW configuration we can manage from 0 to 3 PINs for periodic o=
utput
and from 0 to 1 ext ts PIN for getting TS for external event.

Ext TS PIN functionality is implemented via periodic timestamps polling
directly from PHY, because right now there is now way to receive the
PIN trigger interrupt from phy.

The polling interval is 15 milliseconds.

Co-developed-by: Egor Pomozov <epomozov@marvell.com>
Signed-off-by: Egor Pomozov <epomozov@marvell.com>
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
index 1e12cedee11e..433adc099e44 100644
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
index 56613792abc8..3ec08415e53e 100644
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
@@ -68,6 +71,12 @@ struct aq_ptp_s {
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
@@ -348,6 +357,168 @@ static void aq_ptp_convert_to_hwtstamp(struct aq_ptp_=
s *aq_ptp,
 	hwtstamp->hwtstamp =3D ns_to_ktime(timestamp);
 }
=20
+static int aq_ptp_hw_pin_conf(struct aq_nic_s *aq_nic, u32 pin_index, u64 =
start,
+			      u64 period)
+{
+	if (period)
+		netdev_dbg(aq_nic->ndev,
+			   "Enable GPIO %d pulsing, start time %llu, period %u\n",
+			   pin_index, start, (u32)period);
+	else
+		netdev_dbg(aq_nic->ndev,
+			   "Disable GPIO %d pulsing, start time %llu, period %u\n",
+			   pin_index, start, (u32)period);
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
@@ -859,6 +1030,8 @@ void aq_ptp_ring_free(struct aq_nic_s *aq_nic)
 	aq_ptp_skb_ring_release(&aq_ptp->skb_ring);
 }
=20
+#define MAX_PTP_GPIO_COUNT 4
+
 static struct ptp_clock_info aq_ptp_clock =3D {
 	.owner		=3D THIS_MODULE,
 	.name		=3D "atlantic ptp",
@@ -870,7 +1043,9 @@ static struct ptp_clock_info aq_ptp_clock =3D {
 	.gettime64	=3D aq_ptp_gettime,
 	.settime64	=3D aq_ptp_settime,
 	.n_per_out	=3D 0,
+	.enable		=3D aq_ptp_gpio_feature_enable,
 	.n_pins		=3D 0,
+	.verify		=3D aq_ptp_verify,
 	.pin_config	=3D NULL,
 };
=20
@@ -928,6 +1103,57 @@ static void aq_ptp_offset_init(const struct hw_aq_ptp=
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
@@ -937,6 +1163,8 @@ void aq_ptp_clock_init(struct aq_nic_s *aq_nic)
 	aq_ptp_settime(&aq_ptp->ptp_info, &ts);
 }
=20
+static void aq_ptp_poll_sync_work_cb(struct work_struct *w);
+
 int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 {
 	struct hw_atl_utils_mbox mbox;
@@ -975,6 +1203,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int =
idx_vec)
 	spin_lock_init(&aq_ptp->ptp_ring_lock);
=20
 	aq_ptp->ptp_info =3D aq_ptp_clock;
+	aq_ptp_gpio_init(&aq_ptp->ptp_info, &mbox.info);
 	clock =3D ptp_clock_register(&aq_ptp->ptp_info, &aq_nic->ndev->dev);
 	if (!clock || IS_ERR(clock)) {
 		netdev_err(aq_nic->ndev, "ptp_clock_register failed\n");
@@ -1001,6 +1230,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int=
 idx_vec)
 	aq_ptp_clock_init(aq_nic);
 	mutex_unlock(&aq_nic->fwreq_mutex);
=20
+	INIT_DELAYED_WORK(&aq_ptp->poll_sync, &aq_ptp_poll_sync_work_cb);
 	aq_ptp->eth_type_filter.location =3D
 			aq_nic_reserve_filter(aq_nic, aq_rx_filter_ethertype);
 	aq_ptp->udp_filter.location =3D
@@ -1009,6 +1239,8 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int=
 idx_vec)
 	return 0;
=20
 err_exit:
+	if (aq_ptp)
+		kfree(aq_ptp->ptp_info.pin_config);
 	kfree(aq_ptp);
 	aq_nic->aq_ptp =3D NULL;
 	return err;
@@ -1035,11 +1267,14 @@ void aq_ptp_free(struct aq_nic_s *aq_nic)
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
@@ -1049,3 +1284,107 @@ struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_pt=
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
index 56cec2ea0af0..51ecf87e0198 100644
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
@@ -1151,6 +1152,12 @@ static int hw_atl_b0_set_sys_clock(struct aq_hw_s *s=
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
@@ -1173,6 +1180,57 @@ static int hw_atl_b0_adj_clock_freq(struct aq_hw_s *=
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
@@ -1416,8 +1474,11 @@ const struct aq_hw_ops hw_atl_ops_b0 =3D {
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

