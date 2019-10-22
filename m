Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2390E0136
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbfJVJxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:53:49 -0400
Received: from mail-eopbgr780047.outbound.protection.outlook.com ([40.107.78.47]:41694
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731615AbfJVJxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:53:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daL5kHRvVvWGyP20EOpHHDI2S4HUBzKjniEi66VNpQ0o1z1jv+BP4P1G0AysEwZx0GpFvBNJLcKODc+gLHi/XkG8B0xsX+00AcSVP1gJH3UfS3uNPO2wZYAaGNjTQHuCkSv+ySeCJ9MsX9SYQQ23/HYK9VxP4r1+gn8zoUbEp7lZwnUiWR6D1XVEy+SuZHe/QAdhFAhxaGMuVuzyZTklWXpniwHJC9ksHqoI9G6EC4xGJmP4sO2rlMuh2Iv6D/azeIqOCKK6YEvSLsWAAPs7+0FZCFhdU3CNS/9jfAGtO/qsJeIQ/s9WnvF/+9qq9kxtBlakO1TqS93lJxJhzNXg4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3ZaGy+WjREH7WMwwsQBNpfRgu4ztjmiBSJmPcQqXAw=;
 b=JQ5cLMM0vsRMvLHWC/Vn0T991Bh0XJGp/UWX3ndZwfJiSGDZTb6DgxYR0nyZwUXi3sSrsz6/d8jm3xNbqxgcpVloxymzTLiWFTvdRDPz/5WDNYDUwY3tZizlrLkG6ZWaRvIItQ94Lw+rM55t/AN2i2+irvj+utIAsxageX5f0pmGkDzZwy759rkvT8fiqaQm03RQbF6qKzRlQybGH8YBoUHc0MgxVrkzmy8z1vq/RFipHRpOvLcf815RQpjBUif1XOXdA8ipRyc44Sf8Td+j3fHoYUKWXXoT0KMWzxTbFKCC1Dc4E/6/CNvhaK+uh+ECxSz/yHldMC/4YPcNZfLtag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3ZaGy+WjREH7WMwwsQBNpfRgu4ztjmiBSJmPcQqXAw=;
 b=GVOcB3yr5ImSvLe/wthTUXOC8Ocrwca7mXbk4X8jK8eJk1LBJjB2OBdOCQDM9uFhh76acNh87jeKjXRw4ivpQGt4+zLYCNp4bLJiOrz21gebQARrH7UiC0IsskpmJuivbaYTA6exbs3IyBYJhg5DvAfBIJdZWLVcmB3zjUuneaY=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3732.namprd11.prod.outlook.com (20.178.218.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 09:53:40 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:40 +0000
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
Subject: [PATCH v3 net-next 08/12] net: aquantia: add support for ptp ioctls
Thread-Topic: [PATCH v3 net-next 08/12] net: aquantia: add support for ptp
 ioctls
Thread-Index: AQHViL6VoRpX+NIOQEuej/2HvAnmBQ==
Date:   Tue, 22 Oct 2019 09:53:40 +0000
Message-ID: <777624317f04d6a91d57f6947bee3f477af9c76b.1571737612.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: a4afc8ae-f69f-4ba1-3058-08d756d5b773
x-ms-traffictypediagnostic: BN8PR11MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3732B6211FE4BA330966AC4198680@BN8PR11MB3732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:13;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(366004)(376002)(396003)(199004)(189003)(2616005)(25786009)(8936002)(81166006)(86362001)(486006)(81156014)(1730700003)(44832011)(476003)(8676002)(50226002)(186003)(71190400001)(11346002)(446003)(14444005)(256004)(71200400001)(3846002)(2906002)(118296001)(66556008)(64756008)(66446008)(6116002)(66476007)(5660300002)(66946007)(6512007)(99286004)(5640700003)(4326008)(54906003)(316002)(107886003)(6486002)(7736002)(305945005)(6436002)(66066001)(26005)(6506007)(386003)(14454004)(102836004)(508600001)(6916009)(52116002)(76176011)(36756003)(2351001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3732;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e57T+w2jOvSixNMKLcUF6xBypDX7St5TYFH3u6vT/fEM21QPFZn7u9YiHwWweiUXeaJB+emCA+jJj70jfOBuIrpqFBHO+0UpEKwrUrm/kOG3+b09QSvVNBXeaYGA+tUehDtqSSbN/eWXm5Lroxv+kwuGk9YC45O1ECtyjNtJkN2u7OpwXCLWdiZC6ZUKsFX/A3OMFjOarR4yV0HVET7406delVB7OtFB9TzzAXdUQoFOWAwksbsgh1qyo+/K85E/BI1tjc+byiWIsaejA90UAyZZaINchn3gdA1/8o+9R8E7a82uk+8qIqKS4aUtpGWbUWWa870rw8ELf0PrlQZg+hAm8RLNXjS8/SnfjbbuAmv+CzWwDAM/kt2RhGiWjMH2DYV48nS2nLWFjz5n6+a/fQOFhhw6VJl6ZXOVtyeeeV14WfsN9WLS8YaqSS0D3XiI
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4afc8ae-f69f-4ba1-3058-08d756d5b773
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:40.6084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MGgWHc3WxDwZJb8qfQzvOy4/Uc2L8uxgaO7M3dpYHftdQd9zOhTiAt500cw3fjZ/K58UoCPJrT1067R1MV8VnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <epomozov@marvell.com>

Here we add support for PTP specific IOCTLs of HW timestamp get/set.

These will use filters to configure flows onto the required queue ids.

Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 82 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 63 ++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |  6 ++
 3 files changed, 151 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_main.c
index f630032af8e1..a26d4a69efad 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -218,6 +218,87 @@ static void aq_ndev_set_multicast_settings(struct net_=
device *ndev)
 	(void)aq_nic_set_multicast_list(aq_nic, ndev);
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
index 82409cb1f815..56613792abc8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -44,6 +44,7 @@ struct ptp_tx_timeout {
=20
 struct aq_ptp_s {
 	struct aq_nic_s *aq_nic;
+	struct hwtstamp_config hwtstamp_config;
 	spinlock_t ptp_lock;
 	spinlock_t ptp_ring_lock;
 	struct ptp_clock *ptp_clock;
@@ -388,6 +389,68 @@ static void aq_ptp_rx_hwtstamp(struct aq_ptp_s *aq_ptp=
, struct sk_buff *skb,
 	aq_ptp_convert_to_hwtstamp(aq_ptp, skb_hwtstamps(skb), timestamp);
 }
=20
+void aq_ptp_hwtstamp_config_get(struct aq_ptp_s *aq_ptp,
+				struct hwtstamp_config *config)
+{
+	*config =3D aq_ptp->hwtstamp_config;
+}
+
+static void aq_ptp_prepare_filters(struct aq_ptp_s *aq_ptp)
+{
+	aq_ptp->udp_filter.cmd =3D HW_ATL_RX_ENABLE_FLTR_L3L4 |
+			       HW_ATL_RX_ENABLE_CMP_PROT_L4 |
+			       HW_ATL_RX_UDP |
+			       HW_ATL_RX_ENABLE_CMP_DEST_PORT_L4 |
+			       HW_ATL_RX_HOST << HW_ATL_RX_ACTION_FL3F4_SHIFT |
+			       HW_ATL_RX_ENABLE_QUEUE_L3L4 |
+			       aq_ptp->ptp_rx.idx << HW_ATL_RX_QUEUE_FL3L4_SHIFT;
+	aq_ptp->udp_filter.p_dst =3D PTP_EV_PORT;
+
+	aq_ptp->eth_type_filter.ethertype =3D ETH_P_1588;
+	aq_ptp->eth_type_filter.queue =3D aq_ptp->ptp_rx.idx;
+}
+
+int aq_ptp_hwtstamp_config_set(struct aq_ptp_s *aq_ptp,
+			       struct hwtstamp_config *config)
+{
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	const struct aq_hw_ops *hw_ops;
+	int err =3D 0;
+
+	hw_ops =3D aq_nic->aq_hw_ops;
+	if (config->tx_type =3D=3D HWTSTAMP_TX_ON ||
+	    config->rx_filter =3D=3D HWTSTAMP_FILTER_PTP_V2_EVENT) {
+		aq_ptp_prepare_filters(aq_ptp);
+		if (hw_ops->hw_filter_l3l4_set) {
+			err =3D hw_ops->hw_filter_l3l4_set(aq_nic->aq_hw,
+							 &aq_ptp->udp_filter);
+		}
+		if (!err && hw_ops->hw_filter_l2_set) {
+			err =3D hw_ops->hw_filter_l2_set(aq_nic->aq_hw,
+						       &aq_ptp->eth_type_filter);
+		}
+		aq_utils_obj_set(&aq_nic->flags, AQ_NIC_PTP_DPATH_UP);
+	} else {
+		aq_ptp->udp_filter.cmd &=3D ~HW_ATL_RX_ENABLE_FLTR_L3L4;
+		if (hw_ops->hw_filter_l3l4_set) {
+			err =3D hw_ops->hw_filter_l3l4_set(aq_nic->aq_hw,
+							 &aq_ptp->udp_filter);
+		}
+		if (!err && hw_ops->hw_filter_l2_clear) {
+			err =3D hw_ops->hw_filter_l2_clear(aq_nic->aq_hw,
+							&aq_ptp->eth_type_filter);
+		}
+		aq_utils_obj_clear(&aq_nic->flags, AQ_NIC_PTP_DPATH_UP);
+	}
+
+	if (err)
+		return -EREMOTEIO;
+
+	aq_ptp->hwtstamp_config =3D *config;
+
+	return 0;
+}
+
 bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *ring)
 {
 	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.h
index 2c84483fcac1..7a7f36f43ce0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -38,6 +38,12 @@ void aq_ptp_clock_init(struct aq_nic_s *aq_nic);
 int aq_ptp_xmit(struct aq_nic_s *aq_nic, struct sk_buff *skb);
 void aq_ptp_tx_hwtstamp(struct aq_nic_s *aq_nic, u64 timestamp);
=20
+/* Must be to check available of PTP before call */
+void aq_ptp_hwtstamp_config_get(struct aq_ptp_s *aq_ptp,
+				struct hwtstamp_config *config);
+int aq_ptp_hwtstamp_config_set(struct aq_ptp_s *aq_ptp,
+			       struct hwtstamp_config *config);
+
 /* Return either ring is belong to PTP or not*/
 bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *ring);
=20
--=20
2.17.1

