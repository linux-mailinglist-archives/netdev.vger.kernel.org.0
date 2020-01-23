Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 996FD146205
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAWGjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:39:42 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:52999
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgAWGjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:39:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIEbjd8d3eKea1ULlsrPKgLHDdhsllCqaeRouLLnb6kWuqhgBiZjMmAKl0KrYJoJRbmPXVmf0mVgJKrT/6l1CTlK5znPnecKNdUwXvq8jylU8YQv05pdW6/E+sQBsH6eryJiNth/+gFShqsVoHv88OxXAeB0EG6glROejUQZkmTCOQFpQfvdmTZowNLDmBNgv1koE3hQ5U9OFRFocdL0AZEnW+jtR0mk8I5B1M6tlH4/sd4CEaMHpevoZxYXARuep2+8l0VgGGWTa3QnquSXrawDouS7Ec6yIyhe9J3Ysk9dspwtgHDrOM0ppJ1AFIFoVM6GXzn+HPNQikQ7nlRn4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZidm4dfY5t2yGLvlELa6RmiGMNOT5AKQ5i5G+OTNEc=;
 b=YbfTtqXYmNUsUajutyMXpu9ewDO+25Z6StAgtN6RwwBGtQXM73lce2UDiKlAIsbiyPeCLh8mFmzm0boqZ4Ui74J5h1/aDeXGeH5Lefo8+zJg+7hpagehcMFxQIFVk27FSnyR6RvvhNHB7rxVHltvk2h3cpW1vekz/tIQfn7pobE3SIY6xQPAS1v4okdQS4v4usy6zcRhEJdQql8wbjP4+jhNNtBoqDqRqutb53fw0udQnyJNF39y13BrSRSEmZ5NRXhiCbT9POkqpd0sp2xlm96ywhkWcjzHUOLS+w9eInl1ulWjFaenML0HeEULu2glTMwUGSWU+YD/eBhNDdjABA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZidm4dfY5t2yGLvlELa6RmiGMNOT5AKQ5i5G+OTNEc=;
 b=VwEdDjj5FCDdcrnuaN7S2WjwAlJ+qjJXCWrkBf7CKIF9aMuoPhqDjy/11Zh/erTtbCAA1W28CVvpvdpPiXTTtrTz7bseUz66trjvflo9el//Wtb9U2ls1uJLntZBm0Xq03vvuar1vk2jM6yuHvEJxCdobd9lSPnTHOxP2UA/iN0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:39 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:39 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/15] net/mlx5e: allow TSO on VXLAN over VLAN topologies
Thread-Topic: [net-next 02/15] net/mlx5e: allow TSO on VXLAN over VLAN
 topologies
Thread-Index: AQHV0bfiLry8+AfJI0W92B3SjHL7hg==
Date:   Thu, 23 Jan 2020 06:39:39 +0000
Message-ID: <20200123063827.685230-3-saeedm@mellanox.com>
References: <20200123063827.685230-1-saeedm@mellanox.com>
In-Reply-To: <20200123063827.685230-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 381e493e-096d-4283-3a3b-08d79fcf050e
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4941F0A209BF390D01060402BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T9sM/tBIn69to74nqOC/rfDtCYf6jbjqj5EgbFSAk6J4pFHuMXmzKMo/gG7eOjeu5xCadE/FW2MLPZ0Xheu1yVUrSdQlh0LDScq3MQnKSlYF9UF7GTzABSSsb8WN3RtvNzxVpaMSrZsZu8Is48NLOTo+UVtTKa4bGxLRxE5RfKbTU3XJiFD8kEhlVpU1mONsaC6mh+dAnKiJilLRCtYsfCRO2+4VTGzb1YEbdHjHItpHONzVlVWyjYdTnC7D0/nX5YWJvnGgGI2hc2QzEnxFeNh/a/G/yRv2Wj7jw8yDyhj/hTf6JqqmwLvrHA6tN8jSGzewyfDFm+P99GppPGRViLlWH2fBRCrXczZIZbly6VqnToEBFcBj5agpv0htUlZMvjIUwyu6Q4aDJZTTMu5olSE3ZWVo+eZJ9SVdBB1XLP4rkiNTolyLKg4PGrZp/Dq3saUfOEXR3GerjBd3qqISTnwZNty/JAi1AHnDUEUI2CWbBRmmBrad6WoXvIx6ZwHGP8xQ973fiGeVC0ueHWy96GIjdHXY1fZdLcZhr8zG1RM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 381e493e-096d-4283-3a3b-08d79fcf050e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:39.1197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m8RCP7npJBuJUFJHysD7Xg45ymmabMgrzzIfwL1Yj1B5A6LxGwFVHnAjslSmOAMbhdfkyBj3+ylctd3RjmIXtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

since mlx5 hardware can segment correctly TSO packets on VXLAN over VLAN
topologies, CPU usage can improve significantly if we enable tunnel
offloads in dev->vlan_features, like it was done in the past with other
NIC drivers (e.g. mlx4, be2net and ixgbe).

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 78737fd42616..87267c18ff8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4878,6 +4878,8 @@ static void mlx5e_build_nic_netdev(struct net_device =
*netdev)
 		netdev->hw_enc_features |=3D NETIF_F_GSO_UDP_TUNNEL |
 					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev->gso_partial_features =3D NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->vlan_features |=3D NETIF_F_GSO_UDP_TUNNEL |
+					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
=20
 	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_GRE)) {
--=20
2.24.1

