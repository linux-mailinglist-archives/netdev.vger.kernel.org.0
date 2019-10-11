Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D2CD41A4
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbfJKNp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:45:27 -0400
Received: from mail-eopbgr790055.outbound.protection.outlook.com ([40.107.79.55]:13472
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728536AbfJKNp1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:45:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJzyrVsLbdKai/wFx4Mqj6GGlJTAAVdh2FxPGIy+5WQYQgnz2Qtm8gbK76QEkKUoX6rWfTXp9gj/9YLgkoQIx8mOazfsHSk4b1cMk8n26G49heocuceT7PB1Rtdao94dQBigAYBTju+wWgAL2muk0TNpy5IjhKdSQubPV2d3x5wSP2nlMrfD3aSAuGHpxZNu3InjxU6D2JZ7pkGcIidIgoQzn6SToEqpPdUitxsYxJEmzaulnxB2eQ7BOxyUwRCur3le+XKjkBKcfmQD3Hz97BvHk28FRWixh1THJDXdjcd1S6VnF3bDmsdWm/3IvaMvaUtG93Kp+tWpwkqdYHfBdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTOW4a41kwYYcO6cndXLMDP60wkRoCKLK3OZpxTS8hk=;
 b=cZfwv9+14pIBTkDFumnKbYFWJNW9mk2srGEaDiCXaj5agDNGAP0qcOv/kMksTHmdyDAKA/5TD4/XE5VyH1Q/yPnHizMtW2RPqFBrx+yQzUJ3QcdXDvGCuSIvk+w4aIbScXN2hwfkriDCKteXwv55Dy3rhS5EthKFOmt41OH7VWQv7pIJ6qVPXiVA2BlqFmXhy/Q0jaIkaqfxJo5YgDjohltqM2YzcrH9NgkGbSyN1o1j54nC+SRrnHSrhnBcKlJUpfovmlEouU0FYYDQZ7hlMGNvl01sLSWGOEsHDlp0EGkqIj4+Gt1UWy7VvxJZSKbZNlSyv4+SC0X4GjEYgNZn1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTOW4a41kwYYcO6cndXLMDP60wkRoCKLK3OZpxTS8hk=;
 b=ySESpShj7VJMk1wniRU95l8r7KdIOYwdhT8vbGaVPVIuL7IJCZe/YH9te0qD7SMimou1jw/dyTx3Hsp1+v7/v17FbIAcYWdIi9DT7/d9U6s0t1aRFRttFrvzxEt2lpXdHheXgcP2yvZ/ORW0FsCQ2u/4zwbs+CdOhD0p7KDO67k=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3538.namprd11.prod.outlook.com (20.178.218.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Fri, 11 Oct 2019 13:45:24 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 13:45:24 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: [PATCH v2 net 4/4] net: aquantia: correctly handle macvlan and
 multicast coexistence
Thread-Topic: [PATCH v2 net 4/4] net: aquantia: correctly handle macvlan and
 multicast coexistence
Thread-Index: AQHVgDohdObWNqOca0KGmGMC/UaxZw==
Date:   Fri, 11 Oct 2019 13:45:23 +0000
Message-ID: <d05bca10aabd354194579668bc0930de02194924.1570787323.git.igor.russkikh@aquantia.com>
References: <cover.1570787323.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570787323.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0005.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::17)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5eef8295-351d-4549-09c6-08d74e514400
x-ms-traffictypediagnostic: BN8PR11MB3538:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB35385A5624E38FB107B9198598970@BN8PR11MB3538.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:131;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(376002)(136003)(346002)(366004)(189003)(199004)(52116002)(5640700003)(76176011)(99286004)(2501003)(14454004)(6486002)(25786009)(186003)(26005)(6506007)(476003)(5660300002)(11346002)(50226002)(102836004)(386003)(508600001)(486006)(44832011)(316002)(6916009)(305945005)(7736002)(54906003)(446003)(66066001)(6116002)(2351001)(8676002)(36756003)(1730700003)(3846002)(71190400001)(71200400001)(118296001)(8936002)(2906002)(256004)(86362001)(4326008)(2616005)(6436002)(64756008)(66946007)(66476007)(66556008)(107886003)(81166006)(81156014)(66446008)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3538;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZsrmyDI19CnmhMHz0Ukv80UvaP3pwX3BddATjCX473fV3dJOgWi6xndCIs+NbdN4NFlp9q9oTV3EZq7gu+JSWzHGIuizV2Ifaf2vsqceJUZRU64U/GflgUGC0sOU7UEwf+ht17VToTtHrgO2QoYk0UEzwmyAvFaRdRfET4yB/3V9CmBvrDohE+pXNM9uQM46yk2kRYwGtjtzgvjpKVbos7oW8YdBN6wWctNIQqzh6aub9MRcymyLfz+hZK8/xjMJZ5e15sozU5tTO5NrztTDGdVhWlCE1YCC7fJeoEup4LjeIWv8imJId0UuBe4aNyvcuqIWzJF6hoWbyH2h3HzLx/lilAPrZ2Fw1trnGsxkVn8gGNTHQHOmBffsYsYMsfbMuuIzcdAbV6e79OrHmh9YM3UJPMHITJczogNz1NLYQ2U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eef8295-351d-4549-09c6-08d74e514400
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 13:45:23.8983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hik3vbGoAkuZ0LCdM3dBvjGKH6qH5Lj2L5km3a1UOQkW9fpS5gSIQGsOGidIZq8cZn0u0Wt4MJyHSg0GJGyQVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3538
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

macvlan and multicast handling is now mixed up.
The explicit issue is that macvlan interface gets broken (no traffic)
after clearing MULTICAST flag on the real interface.

We now do separate logic and consider both ALLMULTI and MULTICAST
flags on the device.

Fixes: 11ba961c9161 ("net: aquantia: Fix IFF_ALLMULTI flag functionality")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  4 +--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 32 +++++++++----------
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  7 ++--
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_main.c
index b4a0fb281e69..bb65dd39f847 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -194,9 +194,7 @@ static void aq_ndev_set_multicast_settings(struct net_d=
evice *ndev)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
=20
-	aq_nic_set_packet_filter(aq_nic, ndev->flags);
-
-	aq_nic_set_multicast_list(aq_nic, ndev);
+	(void)aq_nic_set_multicast_list(aq_nic, ndev);
 }
=20
 static int aq_ndo_vlan_rx_add_vid(struct net_device *ndev, __be16 proto,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 8f66e7817811..2a18439b36fb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -631,9 +631,12 @@ int aq_nic_set_packet_filter(struct aq_nic_s *self, un=
signed int flags)
=20
 int aq_nic_set_multicast_list(struct aq_nic_s *self, struct net_device *nd=
ev)
 {
-	unsigned int packet_filter =3D self->packet_filter;
+	const struct aq_hw_ops *hw_ops =3D self->aq_hw_ops;
+	struct aq_nic_cfg_s *cfg =3D &self->aq_nic_cfg;
+	unsigned int packet_filter =3D ndev->flags;
 	struct netdev_hw_addr *ha =3D NULL;
 	unsigned int i =3D 0U;
+	int err =3D 0;
=20
 	self->mc_list.count =3D 0;
 	if (netdev_uc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
@@ -641,29 +644,26 @@ int aq_nic_set_multicast_list(struct aq_nic_s *self, =
struct net_device *ndev)
 	} else {
 		netdev_for_each_uc_addr(ha, ndev) {
 			ether_addr_copy(self->mc_list.ar[i++], ha->addr);
-
-			if (i >=3D AQ_HW_MULTICAST_ADDRESS_MAX)
-				break;
 		}
 	}
=20
-	if (i + netdev_mc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
-		packet_filter |=3D IFF_ALLMULTI;
-	} else {
-		netdev_for_each_mc_addr(ha, ndev) {
-			ether_addr_copy(self->mc_list.ar[i++], ha->addr);
-
-			if (i >=3D AQ_HW_MULTICAST_ADDRESS_MAX)
-				break;
+	cfg->is_mc_list_enabled =3D !!(packet_filter & IFF_MULTICAST);
+	if (cfg->is_mc_list_enabled) {
+		if (i + netdev_mc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
+			packet_filter |=3D IFF_ALLMULTI;
+		} else {
+			netdev_for_each_mc_addr(ha, ndev) {
+				ether_addr_copy(self->mc_list.ar[i++],
+						ha->addr);
+			}
 		}
 	}
=20
 	if (i > 0 && i <=3D AQ_HW_MULTICAST_ADDRESS_MAX) {
-		packet_filter |=3D IFF_MULTICAST;
 		self->mc_list.count =3D i;
-		self->aq_hw_ops->hw_multicast_list_set(self->aq_hw,
-						       self->mc_list.ar,
-						       self->mc_list.count);
+		err =3D hw_ops->hw_multicast_list_set(self->aq_hw,
+						    self->mc_list.ar,
+						    self->mc_list.count);
 	}
 	return aq_nic_set_packet_filter(self, packet_filter);
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 3459fadb7ddd..2ad3fa6316ce 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -818,14 +818,15 @@ static int hw_atl_b0_hw_packet_filter_set(struct aq_h=
w_s *self,
 				     cfg->is_vlan_force_promisc);
=20
 	hw_atl_rpfl2multicast_flr_en_set(self,
-					 IS_FILTER_ENABLED(IFF_ALLMULTI), 0);
+					 IS_FILTER_ENABLED(IFF_ALLMULTI) &&
+					 IS_FILTER_ENABLED(IFF_MULTICAST), 0);
=20
 	hw_atl_rpfl2_accept_all_mc_packets_set(self,
-					       IS_FILTER_ENABLED(IFF_ALLMULTI));
+					      IS_FILTER_ENABLED(IFF_ALLMULTI) &&
+					      IS_FILTER_ENABLED(IFF_MULTICAST));
=20
 	hw_atl_rpfl2broadcast_en_set(self, IS_FILTER_ENABLED(IFF_BROADCAST));
=20
-	cfg->is_mc_list_enabled =3D IS_FILTER_ENABLED(IFF_MULTICAST);
=20
 	for (i =3D HW_ATL_B0_MAC_MIN; i < HW_ATL_B0_MAC_MAX; ++i)
 		hw_atl_rpfl2_uc_flr_en_set(self,
--=20
2.17.1

