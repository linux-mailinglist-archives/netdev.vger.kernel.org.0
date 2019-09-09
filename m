Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC5FADA1D
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730686AbfIINjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:39:08 -0400
Received: from mail-eopbgr770088.outbound.protection.outlook.com ([40.107.77.88]:4676
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729267AbfIINjH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 09:39:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlnTShFTq35YvnRIha+2ytXsdEoXHzXSjdZBTw0pWPcrisu3wQrwSN36SR9+dHSf4ZVKJdz+EakxJg1UlTlak1AYSAtjEvgCJQ5dpTA77Eu4fdw7MP4HOmM69X+dhvHrKrPSAW1m+VDWydpnZaS7LmMF9GTprdAtuuKnBcQfx1oSIIKADMGWsRGdM09DlCke+lkxUAyZJCnow4xK6KTTCWsOEmdj7VSJlqskqFDNzms1JQ3ZfAtWpvKucmEWkbUX5lfQRmxWUxPx3hSjBRA9u3LTWtxU15vf7yAQ807C0AmMQ5if19pRivMqFTqSnm1TBZeVnfJWW/qsvJynNA0mig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1g4Nn0cBjDo97qPi4G1mtJO66jeiVvqPtcSU5F5IGk=;
 b=jVE1flj7a6JSdBnfeUT2PdL3uw2dv3X/dpNImeWvBuo6ukHT4JIgsKc0iam4/CVWd1Ef3VMs0dZ9TpjkTnIMP8AUk5tI72hTyG8k6VvgrJsjN75B+ISDJcuOcmgsUgNhhXR86bl19qn8sRejkVz9gtzCUyc7n0aR+eC10UPYaoJPg43rOQo8lZ1wbUAVdeasy+IVrQUpj8Fd3+glM0jdgHMoMmwfZTXKWpAg6usmg1LD8jdHJI7BLlPAd/hkMM1HrRBTDN+ESPIvhgOmU+bPvAa0TtWr8Lc+BhwNJq7EDbG4YzCHBU5pfcJeUyU5v1imJebaBOSYPHvBsA0wQTGQ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1g4Nn0cBjDo97qPi4G1mtJO66jeiVvqPtcSU5F5IGk=;
 b=aCXsv5Mpto5q81zDuogw7pfYidYjJCe911hNE3aaZN905dzNzzNBTHZinEJ7iuBG3a5eOzn/weZwr6VGvha3sEKnpBEmtoIJCzBzKeBPnhucx+U4xsB3q1kAl0arX4+nKao1gEybkWpNwbGLjomtW8Jkrok0AD15v8ou673CPgc=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1747.namprd11.prod.outlook.com (10.175.99.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Mon, 9 Sep 2019 13:39:00 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:39:00 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH net-next 11/11] net: aquantia: add support for PIN funcs
Thread-Topic: [PATCH net-next 11/11] net: aquantia: add support for PIN funcs
Thread-Index: AQHVZxPwoTJMzv/kJUiQAvYv4VHgGA==
Date:   Mon, 9 Sep 2019 13:39:00 +0000
Message-ID: <b3eeb5dd7d38dab79ded5f4b7cca2a84505c8fac.1568034880.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: 4434e96e-9d3e-4667-ac1a-08d7352b1272
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1747;
x-ms-traffictypediagnostic: BN6PR11MB1747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB17472B40612B33F2B77A196A98B70@BN6PR11MB1747.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(396003)(346002)(366004)(39850400004)(376002)(136003)(189003)(199004)(26005)(25786009)(6436002)(6486002)(118296001)(305945005)(99286004)(53946003)(5640700003)(14444005)(256004)(64756008)(1730700003)(107886003)(81166006)(81156014)(66446008)(316002)(478600001)(66476007)(76176011)(4326008)(8676002)(86362001)(52116002)(66556008)(30864003)(53936002)(186003)(2501003)(6506007)(386003)(476003)(11346002)(5660300002)(2616005)(44832011)(66066001)(36756003)(3846002)(8936002)(6512007)(2906002)(486006)(6116002)(71190400001)(14454004)(7736002)(66946007)(6916009)(54906003)(102836004)(50226002)(2351001)(446003)(71200400001)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1747;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZrLbLetuPAmL8giIdmuO4GI9pNeSWCp3Bdjln8tycv5Qk0fqvLu5fnnm/PXIjLxESelkhuLU1BzGqixeEMMcJQqhHnuSkMYR8ldgyusXMtN9ygimavDTtEeGxWG2OhP5LyRB7eviy46F6+Ftcg17zyh+4Z/56NoFfK/yPsErocfzKhlsBt6r1e8yaAte+04seCJAxOWGbdm8lMDKnlRhO41ZdWT03c6CuJkeOjMYlmWtQR6Kpxyal+4PBqCNv5b2DIW0Etmm0vSFvru+q17HNXH6PEELl5HxiCOvwUFzys/T0//PPBZjRklK1oEVPcHgAWb2xaj3FCTMVeBX/4l0pbJPMO1h4Rh0YLnlW7GLK2z+7y+oUPESSX24Nao18d14NP6erZGA1Ch1HBQd6BQrU1TY/2ZuFNCm0jk6Z3URaVk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4434e96e-9d3e-4667-ac1a-08d7352b1272
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:39:00.8044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mfto8ga7JZkwaCDAECEJvzWnCICZOrfHRB83jQFk0mGsQ1YZYMrxvtjBizIWmxOM2wZgkcpYCJnfB+rNoKXY4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1747
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
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Co-developed-by: Nikita Danilov <nikita.danilov@aquantia.com>
Signed-off-by: Nikita Danilov <nikita.danilov@aquantia.com>
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
index 336c5599e279..cdd668bd3caf 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -258,6 +258,16 @@ struct aq_hw_ops {
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
 	u16 (*rx_extract_ts)(u8 *p, unsigned int len, u64 *timestamp);
=20
 	int (*extract_hwts)(u8 *p, unsigned int len, u64 *timestamp);
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
index 9ac0bc61f86a..0bb65bddf162 100644
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
s *self,
 	hwtstamp->hwtstamp =3D ns_to_ktime(timestamp);
 }
=20
+static int aq_ptp_hw_pin_conf(struct aq_nic_s *aq_nic, u32 pin_index, u64 =
start,
+			      u64 period)
+{
+	if (period)
+		netdev_info(aq_nic->ndev,
+			"Enable GPIO %d pulsing, start time %llu, period %u\n",
+			pin_index, start, (u32)period);
+	else
+		netdev_info(aq_nic->ndev,
+			"Disable GPIO %d pulsing, start time %llu, period %u\n",
+			pin_index, start, (u32)period);
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
+	struct aq_ptp_s *self =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct ptp_clock_time *t =3D &rq->perout.period;
+	struct ptp_clock_time *s =3D &rq->perout.start;
+	struct aq_nic_s *aq_nic =3D self->aq_nic;
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
+	period =3D on ? t->sec * 1000000000LL + t->nsec : 0;
+
+	/* verify the value is in range supported by hardware */
+	if (period > U32_MAX)
+		return -ERANGE;
+	/* convert to unsigned 64b ns */
+	/* TODO convert to AQ time */
+	start =3D on ? s->sec * 1000000000LL + s->nsec : 0;
+
+	aq_ptp_hw_pin_conf(aq_nic, pin_index, start, period);
+
+	return 0;
+}
+
+static int aq_ptp_pps_pin_configure(struct ptp_clock_info *ptp,
+				    struct ptp_clock_request *rq, int on)
+{
+	struct aq_ptp_s *self =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct aq_nic_s *aq_nic =3D self->aq_nic;
+	u64 start, period;
+	u32 pin_index =3D 0;
+	u64 rest =3D 0;
+
+	/* verify the request channel is there */
+	if (pin_index >=3D ptp->n_per_out)
+		return -EINVAL;
+
+	aq_nic->aq_hw_ops->hw_get_ptp_ts(aq_nic->aq_hw, &start);
+	rest =3D start % 1000000000LL;
+	period =3D on ? 1000000000LL : 0; /* PPS - pulse per second */
+	start =3D on ? start - rest + 1000000000LL *
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
+	struct aq_ptp_s *self =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+
+	u32 pin_index =3D rq->extts.index;
+
+	if (pin_index >=3D ptp->n_ext_ts)
+		return -EINVAL;
+
+	self->extts_pin_enabled =3D !!on;
+	if (on) {
+		self->poll_timeout_ms =3D POLL_SYNC_TIMER_MS;
+		cancel_delayed_work_sync(&self->poll_sync);
+		schedule_delayed_work(&self->poll_sync,
+				      msecs_to_jiffies(self->poll_timeout_ms));
+	}
+
+	aq_ptp_extts_pin_ctrl(self);
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
@@ -865,6 +1036,8 @@ void aq_ptp_ring_free(struct aq_nic_s *aq_nic)
 	aq_ptp_skb_ring_release(&self->skb_ring);
 }
=20
+#define MAX_PTP_GPIO_COUNT 4
+
 static struct ptp_clock_info aq_ptp_clock =3D {
 	.owner		=3D THIS_MODULE,
 	.name		=3D "atlantic ptp",
@@ -876,7 +1049,9 @@ static struct ptp_clock_info aq_ptp_clock =3D {
 	.gettime64	=3D aq_ptp_gettime,
 	.settime64	=3D aq_ptp_settime,
 	.n_per_out     =3D 0,
+	.enable        =3D aq_ptp_gpio_feature_enable,
 	.n_pins        =3D 0,
+	.verify        =3D aq_ptp_verify,
 	.pin_config    =3D NULL,
 };
=20
@@ -934,6 +1109,57 @@ static void aq_ptp_offset_init(const struct hw_aq_ptp=
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
 	struct aq_ptp_s *self =3D aq_nic->aq_ptp;
@@ -943,6 +1169,8 @@ void aq_ptp_clock_init(struct aq_nic_s *aq_nic)
 	aq_ptp_settime(&self->ptp_info, &ts);
 }
=20
+static void aq_ptp_poll_sync_work_cb(struct work_struct *w);
+
 int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 {
 	struct hw_atl_utils_mbox mbox;
@@ -981,6 +1209,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int =
idx_vec)
 	spin_lock_init(&self->ptp_ring_lock);
=20
 	self->ptp_info =3D aq_ptp_clock;
+	aq_ptp_gpio_init(&self->ptp_info, &mbox.info);
 	clock =3D ptp_clock_register(&self->ptp_info, &aq_nic->ndev->dev);
 	if (!clock) {
 		netdev_err(aq_nic->ndev, "ptp_clock_register failed\n");
@@ -1007,6 +1236,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int=
 idx_vec)
 	aq_ptp_clock_init(aq_nic);
 	mutex_unlock(&aq_nic->fwreq_mutex);
=20
+	INIT_DELAYED_WORK(&self->poll_sync, &aq_ptp_poll_sync_work_cb);
 	self->eth_type_filter.location =3D
 			aq_nic_reserve_filter(aq_nic, aq_rx_filter_ethertype);
 	self->udp_filter.location =3D
@@ -1015,6 +1245,8 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int=
 idx_vec)
 	return 0;
=20
 err_exit:
+	if (self)
+		kfree(self->ptp_info.pin_config);
 	kfree(self);
 	aq_nic->aq_ptp =3D NULL;
 	return err;
@@ -1041,11 +1273,14 @@ void aq_ptp_free(struct aq_nic_s *aq_nic)
 			      self->eth_type_filter.location);
 	aq_nic_release_filter(aq_nic, aq_rx_filter_l3l4,
 			      self->udp_filter.location);
+	cancel_delayed_work_sync(&self->poll_sync);
 	/* disable ptp */
 	mutex_lock(&aq_nic->fwreq_mutex);
 	aq_nic->aq_fw_ops->enable_ptp(aq_nic->aq_hw, 0);
 	mutex_unlock(&aq_nic->fwreq_mutex);
=20
+	kfree(self->ptp_info.pin_config);
+
 	netif_napi_del(&self->napi);
 	kfree(self);
 	aq_nic->aq_ptp =3D NULL;
@@ -1055,3 +1290,107 @@ struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_pt=
p_s *self)
 {
 	return self->ptp_clock;
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
+				msecs_to_jiffies(aq_ptp->poll_timeout_ms));
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
+	struct aq_ptp_s *self =3D container_of(dw, struct aq_ptp_s, poll_sync);
+
+	aq_ptp_check_sync1588(self);
+
+	if (self->extts_pin_enabled) {
+		unsigned long timeout =3D msecs_to_jiffies(self->poll_timeout_ms);
+
+		schedule_delayed_work(&self->poll_sync, timeout);
+	}
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.h
index dfce080453a0..80fbb4286fad 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -52,4 +52,6 @@ u16 aq_ptp_extract_ts(struct aq_nic_s *aq_nic, struct sk_=
buff *skb, u8 *p,
=20
 struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_ptp_s *self);
=20
+int aq_ptp_link_change(struct aq_nic_s *aq_nic);
+
 #endif /* AQ_PTP_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 5cff68707069..377567fc14f2 100644
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
@@ -1130,6 +1131,12 @@ static int hw_atl_b0_set_sys_clock(struct aq_hw_s *s=
elf, u64 time, u64 ts)
 	return hw_atl_b0_adj_sys_clock(self, delta);
 }
=20
+int hw_atl_b0_ts_to_sys_clock(struct aq_hw_s *self, u64 ts, u64 *time)
+{
+	*time =3D ptp_clk_offset + ts;
+	return 0;
+}
+
 static int hw_atl_b0_adj_clock_freq(struct aq_hw_s *self, s32 ppb)
 {
 	struct hw_fw_request_iface fwreq;
@@ -1152,6 +1159,57 @@ static int hw_atl_b0_adj_clock_freq(struct aq_hw_s *=
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
+	fwreq.ptp_gpio_ctrl.start =3D start - ptp_clk_offset;
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
 static u16 hw_atl_b0_rx_extract_ts(u8 *p, unsigned int len, u64 *timestamp=
)
 {
 	unsigned int offset =3D 14;
@@ -1393,8 +1451,11 @@ const struct aq_hw_ops hw_atl_ops_b0 =3D {
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

