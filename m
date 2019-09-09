Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD60ADA1B
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbfIINi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:38:58 -0400
Received: from mail-eopbgr770052.outbound.protection.outlook.com ([40.107.77.52]:40429
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728895AbfIINi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 09:38:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGsHLvFdPDM3Yv+EtLYdqM3WRDRvlUCYSa5CtM8m2FP24qAY2Ko3sQXa4jDJ01rh2PBSd4DsEvBMDb0EF61gzGZMKrQsQxafopYNo7nbCMZZbMnc6+Ub27iRre20MNk6S9TQtVVLGKn6hm4VnTr1guHTFjX7IWpDMTurUqWsTYW1gVlnCFQc/FoyK5pFpMMb8ACGJgDK4Ar+0DEUiygCtonHQZLMDZ49SNow83A2aDgJLzPmnMGJqI68LvT3Fo6r0ZghZ1BXhGhqJGtKwxuWVa6YjCIdrO7NWVcaGeyqoen4BiUwu/a76qLKbiuqsP5EQtZ5WYNUKCkHD3JwODUTLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFU8VexXYvrECaPwVL1yMFYgg0WvP0/7tYrFUr3NY7c=;
 b=L1zGKbpX8Vf8AyzM5SIFhf31r64Exm4VdYNChFprKxvM/POdbaN3MB6syg0H0EOsnyQaxmR4WRuV2Q4TTK8xaa3TckDHSlnUUMt+/Bx26w+tDXJsP+77YbmeS+m/J4NPZtEx5dX8E3C4vQ5KCt13X52yzA+WcBYMeOSc0WZjyMqA+iVmcHig2Cc3jmfcaZDf+QI2l2su5+uZr1ryxIH+iL9AyeCMbpjoZpf5kkVjIni9SAq0WAaGfFAdBGqJxztBYNoy6ZKzkd75J50Q1CAKmVQdEkXpOkBqujMUbAU1Y2HnQfehTt+OjStwyH6dkLpkCvuHAAh7ENWqRkED27GH/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFU8VexXYvrECaPwVL1yMFYgg0WvP0/7tYrFUr3NY7c=;
 b=Edx4SGT/VJSnNBwdGwlZXvHWBp3bCC62PDBKn1NYsGEMC9xaHbIUMBT7EhFjx5RqsoLh7WTHhkQgtg1WWKLX2lXt9XvEQAyApmIH2O8404/3wT/FUoN0W27AbgIpK/fYzfFT2aoH4qK95TqSzFtQdCzFvVcuaoDE//Jf5xWp47w=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1747.namprd11.prod.outlook.com (10.175.99.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Mon, 9 Sep 2019 13:38:53 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:38:53 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 08/11] net: aquantia: add support for ptp ioctls
Thread-Topic: [PATCH net-next 08/11] net: aquantia: add support for ptp ioctls
Thread-Index: AQHVZxPrw3ErajoTvkCvZQGAQUfqHQ==
Date:   Mon, 9 Sep 2019 13:38:53 +0000
Message-ID: <d0ce9a5941d3473bfeef82481fd3f53d85f50b4d.1568034880.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: d59c8501-99f0-4b85-0df1-08d7352b0e14
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1747;
x-ms-traffictypediagnostic: BN6PR11MB1747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB174791CED9B3849C47CEF42898B70@BN6PR11MB1747.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:13;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(39850400004)(376002)(136003)(189003)(199004)(26005)(25786009)(6436002)(6486002)(118296001)(305945005)(99286004)(5640700003)(14444005)(256004)(64756008)(1730700003)(107886003)(81166006)(81156014)(66446008)(316002)(478600001)(66476007)(76176011)(4326008)(8676002)(86362001)(52116002)(66556008)(53936002)(186003)(2501003)(6506007)(386003)(476003)(11346002)(5660300002)(2616005)(44832011)(66066001)(36756003)(3846002)(8936002)(6512007)(2906002)(486006)(6116002)(71190400001)(14454004)(7736002)(66946007)(6916009)(54906003)(102836004)(50226002)(2351001)(446003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1747;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C4C72F8waO4+q2yYhpDlp4or+new3TCO1mgRmkV25tGAUFVlKCKMhi8aDTXF6etdzz25xba9I+pzPO2Ye7dHoPm/ozCc+LnTdMhjFgS5IJz1cd985eFIcWuordNEXMVB98d+LrcDyq9GT56i7/bM3AfmZXA+9c76hqIGVlMUXhssnqpKFddD0oC8z+UC3wsQ0qaPlfo5Cy26wNcpNt1uV5851p5uNxy5MntpLvG6QLZCQgjg3aMzzdR42EKWNRD3vbaP+YLyWZlrP+YtOjO1gi/OLA0EIpPeL1CjhF4FDHxOR3s/TmEkFYv0oNaqdDRLmaJUALb/X+8g7/3ayKz0s5Fb3j0dPWDAiUdw5bZhQziOq18pTf2bAHIhF67WGAtubeHtG1OhYXfTHztvSaNykp6XwLIIp6YSDW54hqKG2aQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59c8501-99f0-4b85-0df1-08d7352b0e14
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:38:53.4534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1+YXsmDfFfD5jdiVePQar5eQCF0TVVBmBa4JK844HQWvE8PmxhVJGZguJiUid4clcrlH8C1uNYF1UedekqcMGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1747
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

Here we add support for PTP specific IOCTLs of HW timestamp get/set.

These will use filters to configure flows onto the required queue ids.

Co-developed-by: Egor Pomozov <egor.pomozov@aquantia.com>
Signed-off-by: Egor Pomozov <egor.pomozov@aquantia.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 82 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 64 +++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |  6 ++
 3 files changed, 152 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_main.c
index 37d8715c760e..6a7fd9959038 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -218,6 +218,87 @@ static void aq_ndev_set_multicast_settings(struct net_=
device *ndev)
 	aq_nic_set_multicast_list(aq_nic, ndev);
 }
=20
+static int aq_ndev_config_hwtstamp(struct aq_nic_s *aq_nic,
+				   struct hwtstamp_config *config)
+{
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_OFF:
+	case HWTSTAMP_TX_ON:
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		config->rx_filter =3D HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_NONE:
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	return aq_ptp_hwtstamp_config_set(aq_nic->aq_ptp, config);
+}
+
+static int aq_ndev_hwtstamp_set(struct aq_nic_s *aq_nic, struct ifreq *ifr=
)
+{
+	struct hwtstamp_config config;
+	int ret_val;
+
+	if (!aq_nic->aq_ptp)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	ret_val =3D aq_ndev_config_hwtstamp(aq_nic, &config);
+	if (ret_val)
+		return ret_val;
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+	       -EFAULT : 0;
+}
+
+static int aq_ndev_hwtstamp_get(struct aq_nic_s *aq_nic, struct ifreq *ifr=
)
+{
+	struct hwtstamp_config config;
+
+	if (!aq_nic->aq_ptp)
+		return -EOPNOTSUPP;
+
+	aq_ptp_hwtstamp_config_get(aq_nic->aq_ptp, &config);
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+	       -EFAULT : 0;
+}
+
+static int aq_ndev_ioctl(struct net_device *netdev, struct ifreq *ifr, int=
 cmd)
+{
+	struct aq_nic_s *aq_nic =3D netdev_priv(netdev);
+
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return aq_ndev_hwtstamp_set(aq_nic, ifr);
+
+	case SIOCGHWTSTAMP:
+		return aq_ndev_hwtstamp_get(aq_nic, ifr);
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int aq_ndo_vlan_rx_add_vid(struct net_device *ndev, __be16 proto,
 				  u16 vid)
 {
@@ -255,6 +336,7 @@ static const struct net_device_ops aq_ndev_ops =3D {
 	.ndo_change_mtu =3D aq_ndev_change_mtu,
 	.ndo_set_mac_address =3D aq_ndev_set_mac_address,
 	.ndo_set_features =3D aq_ndev_set_features,
+	.ndo_do_ioctl =3D aq_ndev_ioctl,
 	.ndo_vlan_rx_add_vid =3D aq_ndo_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid =3D aq_ndo_vlan_rx_kill_vid,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index a609173e9907..9ac0bc61f86a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -45,6 +45,8 @@ struct ptp_tx_timeout {
 struct aq_ptp_s {
 	struct aq_nic_s *aq_nic;
=20
+	struct hwtstamp_config hwtstamp_config;
+
 	spinlock_t ptp_lock;
 	spinlock_t ptp_ring_lock;
 	struct ptp_clock *ptp_clock;
@@ -398,6 +400,68 @@ static void aq_ptp_rx_hwtstamp(struct aq_ptp_s *self, =
struct sk_buff *skb,
 	aq_ptp_convert_to_hwtstamp(self, skb_hwtstamps(skb), timestamp);
 }
=20
+void aq_ptp_hwtstamp_config_get(struct aq_ptp_s *self,
+				struct hwtstamp_config *config)
+{
+	*config =3D self->hwtstamp_config;
+}
+
+static void aq_ptp_prepare_filters(struct aq_ptp_s *self)
+{
+	self->udp_filter.cmd =3D HW_ATL_RX_ENABLE_FLTR_L3L4 |
+			       HW_ATL_RX_ENABLE_CMP_PROT_L4 |
+			       HW_ATL_RX_UDP |
+			       HW_ATL_RX_ENABLE_CMP_DEST_PORT_L4 |
+			       HW_ATL_RX_HOST << HW_ATL_RX_ACTION_FL3F4_SHIFT |
+			       HW_ATL_RX_ENABLE_QUEUE_L3L4 |
+			       self->ptp_rx.idx << HW_ATL_RX_QUEUE_FL3L4_SHIFT;
+	self->udp_filter.p_dst =3D PTP_EV_PORT;
+
+	self->eth_type_filter.ethertype =3D ETH_P_1588;
+	self->eth_type_filter.queue =3D self->ptp_rx.idx;
+}
+
+int aq_ptp_hwtstamp_config_set(struct aq_ptp_s *self,
+			       struct hwtstamp_config *config)
+{
+	struct aq_nic_s *aq_nic =3D self->aq_nic;
+	const struct aq_hw_ops *hw_ops;
+	int err =3D 0;
+
+	hw_ops =3D aq_nic->aq_hw_ops;
+	if (config->tx_type =3D=3D HWTSTAMP_TX_ON ||
+	    config->rx_filter =3D=3D HWTSTAMP_FILTER_PTP_V2_EVENT) {
+		aq_ptp_prepare_filters(self);
+		if (hw_ops->hw_filter_l3l4_set) {
+			err =3D hw_ops->hw_filter_l3l4_set(aq_nic->aq_hw,
+							 &self->udp_filter);
+		}
+		if (!err && hw_ops->hw_filter_l2_set) {
+			err =3D hw_ops->hw_filter_l2_set(aq_nic->aq_hw,
+						       &self->eth_type_filter);
+		}
+		aq_utils_obj_set(&aq_nic->flags, AQ_NIC_PTP_DPATH_UP);
+	} else {
+		self->udp_filter.cmd &=3D ~HW_ATL_RX_ENABLE_FLTR_L3L4;
+		if (hw_ops->hw_filter_l3l4_set) {
+			err =3D hw_ops->hw_filter_l3l4_set(aq_nic->aq_hw,
+							 &self->udp_filter);
+		}
+		if (!err && hw_ops->hw_filter_l2_clear) {
+			err =3D hw_ops->hw_filter_l2_clear(aq_nic->aq_hw,
+							&self->eth_type_filter);
+		}
+		aq_utils_obj_clear(&aq_nic->flags, AQ_NIC_PTP_DPATH_UP);
+	}
+
+	if (err)
+		return -EREMOTEIO;
+
+	self->hwtstamp_config =3D *config;
+
+	return 0;
+}
+
 bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *ring)
 {
 	struct aq_ptp_s *self =3D aq_nic->aq_ptp;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.h
index 0c6db243cb07..dfce080453a0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -38,6 +38,12 @@ void aq_ptp_clock_init(struct aq_nic_s *aq_nic);
 int aq_ptp_xmit(struct aq_nic_s *aq_nic, struct sk_buff *skb);
 void aq_ptp_tx_hwtstamp(struct aq_nic_s *aq_nic, u64 timestamp);
=20
+/* Must be to check available of PTP before call */
+void aq_ptp_hwtstamp_config_get(struct aq_ptp_s *self,
+				struct hwtstamp_config *config);
+int aq_ptp_hwtstamp_config_set(struct aq_ptp_s *self,
+			       struct hwtstamp_config *config);
+
 /* Return either ring is belong to PTP or not*/
 bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *ring);
=20
--=20
2.17.1

