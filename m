Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37239A3E5
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfHVXgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:36:48 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:39558
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726823AbfHVXgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 19:36:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMLX+mXviacQPeN+Z5VSn3aq3IMSwFa2kVwF5i2Z0ptW5Alste6p03SqsmksVq3a1jhlr/V5wJMSit73GTPhafS3rF5cE+ogT3Zfmd2qug+bZsQxFIW/l3I5T424lkYjN5f8zLPkwDP5ieoEr9wjQFHpYzzTO4ko9q2Q8/aQw+GB5cdQm/6KejLousCK6pjIIP+bQlV0hb5qZMFcHWv8/ruLXy24yNc0TXZPmBiXDPQju9uMgrci5lscDPzIqzBFzOmiOE6M6FQs9Jv1jj7C89ChBhynjfm7fGU7Bjie6iiSm2imfWPM2Je4EndjOCZsai91LH+xrwChOfluTwnyhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCkyZrzZiJdwUmCjkA61mjzNlijzprFbn9ryMu6YmOY=;
 b=UEq/m2isaj1qXcZmeqLim0LHUItjz5Nu9hpwm6ZZQdC2xE3Lbqb4kI+2/+Z5xqbGTf5M3wLcmc9GvNL6kVDDQ5E1bGJMqqcDYfyMdsn0loQnQ/eN9fp5VUa3S1wbRSIJ/JXuRl05NILgXYhPSjaumtDe5C77fEEz6fO2Pm4RvB/QSze/oMOkMtDq3OpZAwF0jftMQ9/Ck+wvGGR0FS5k+Ww4kujQ/v75BqZOO5AS/ncMq83kpUtuwNXIe5Le0Xpyh53potKlCT8Sm56cmxAcxb7cjC8CIEgzievDT+BmMZUiXY3zJgEHe1UdqnFlgy/+ZJwvYlR8cmxAHlMGJiXEKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCkyZrzZiJdwUmCjkA61mjzNlijzprFbn9ryMu6YmOY=;
 b=TxhXAxYE42Uvxn+DfV4P3uiU+kFl5YaaUyoHWbuvaH1XP5YAtzJPM2/YAI2q7tOOUmj+H+tAiiFwi+lz/MbvT9W6odvCPSs7K6t9lmKaQ7cBpdmJ9IQQJb8zcqtl8cON//eSYgxczD/Q9EQSW4YnigK0jITkEWKl6IT+A7lQ0Lc=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2817.eurprd05.prod.outlook.com (10.172.215.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 23:36:00 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 23:36:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Marina Varshaver <marinav@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 8/8] net/mlx5e: Support TSO and TX checksum offloads for
 IP-in-IP tunnels
Thread-Topic: [net-next 8/8] net/mlx5e: Support TSO and TX checksum offloads
 for IP-in-IP tunnels
Thread-Index: AQHVWUJauKgoKTenmkCvyal7CnBSnw==
Date:   Thu, 22 Aug 2019 23:35:59 +0000
Message-ID: <20190822233514.31252-9-saeedm@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
In-Reply-To: <20190822233514.31252-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19032348-602a-492f-6428-08d727597ce9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2817;
x-ms-traffictypediagnostic: AM4PR0501MB2817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2817045FB4505B5A03F3C47ABEA50@AM4PR0501MB2817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(199004)(189003)(11346002)(446003)(486006)(1076003)(66476007)(66556008)(64756008)(66946007)(66446008)(186003)(386003)(102836004)(305945005)(476003)(66066001)(6506007)(478600001)(2616005)(26005)(2906002)(6512007)(3846002)(6116002)(7736002)(86362001)(6486002)(6916009)(36756003)(76176011)(54906003)(316002)(53936002)(256004)(8676002)(4326008)(25786009)(50226002)(81156014)(99286004)(81166006)(8936002)(14454004)(107886003)(6436002)(5660300002)(71190400001)(71200400001)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2817;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oMzFxK9+1JQ2ir02xuC/nesXUrwTLFmE5PQoUcJx2uKqPYujBCc00E+2FhXJlMIi2uYYnbM40suZk2aaYup7VaW883t9DSkFSBxgEzW1DLb5u4meitz5ZJplbkiPZSOgJtGvtk8B6JuB+S0jvI6kEHe5GSGxI63Egfxl3/bgTNcOdYUfeVgoHy4aT+IT/n0VQOps8uoReGaBbIjM/zuINpNfZChSdOax2XxhvSfdqiUyzMpUjqT4MyzQxhXWwR24SceFS+k6qFCRrwD1eam544uUE/3hBfZ+9EoSyVHfMVLnRq1pR+GLcCzNVK9b6B+uc+E2gXW9gEiMn96UwK110Wa4et9iXsIs6Y7s2bfjmfvgHWr6Xnx0ey02Vgzy+/nN+OFeg5b2aRXuabeyZNlkSPWmzH9YxZibaPTQ+F6M1sQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19032348-602a-492f-6428-08d727597ce9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 23:35:59.9176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5RaU51VXdIHg9SuDPo9Gm1Lt7gp7yq0omcy1ERvoXOu+QLAFGTTWqfY1Ld/LWWTMaodjToFHKG+ZFpOxfxC3fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2817
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marina Varshaver <marinav@mellanox.com>

Add TX offloads support for IP-in-IP tunneled packets by reporting
the needed netdev features.

Signed-off-by: Marina Varshaver <marinav@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 1c4f82842df9..f4a5055dfaff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4241,6 +4241,7 @@ static netdev_features_t mlx5e_tunnel_features_check(=
struct mlx5e_priv *priv,
=20
 	switch (proto) {
 	case IPPROTO_GRE:
+	case IPPROTO_IPIP:
 		return features;
 	case IPPROTO_UDP:
 		udph =3D udp_hdr(skb);
@@ -4901,6 +4902,15 @@ static void mlx5e_build_nic_netdev(struct net_device=
 *netdev)
 						NETIF_F_GSO_GRE_CSUM;
 	}
=20
+	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_IPIP)) {
+		netdev->hw_features |=3D NETIF_F_GSO_IPXIP4 |
+				       NETIF_F_GSO_IPXIP6;
+		netdev->hw_enc_features |=3D NETIF_F_GSO_IPXIP4 |
+					   NETIF_F_GSO_IPXIP6;
+		netdev->gso_partial_features |=3D NETIF_F_GSO_IPXIP4 |
+						NETIF_F_GSO_IPXIP6;
+	}
+
 	netdev->hw_features	                 |=3D NETIF_F_GSO_PARTIAL;
 	netdev->gso_partial_features             |=3D NETIF_F_GSO_UDP_L4;
 	netdev->hw_features                      |=3D NETIF_F_GSO_UDP_L4;
--=20
2.21.0

