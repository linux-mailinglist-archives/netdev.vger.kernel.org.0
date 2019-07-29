Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F139679ABD
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388456AbfG2VNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:13:05 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:2445
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388434AbfG2VND (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:13:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7VphGLL5c9yVnVV274twOIeoE/njfQTzT/lc6sz7gRfacnNMzVvCzg2ixePJiKteKlEC6MkrKt8cMALbbT/djRcM4MCiCL0rVbO0serJfz2J5uyLslHC5ZpQ0NvxUvi17YVGKTxh7yf8HOJOB1tHKzm6WV3Bj3gyAx7yHHtWjrN/KsNhQwxDpWV2XYS44L1tqabq9Ex/swy6vWb20zucWd61eRI0G8b1tMiNB0m4DNWC/uyUB/iTzl7DwO/GTyXksbFxCdelGTgh2ztzwFPLtW7hmFxD9wxWh54vY83JQGqS1b5kOoBtc5MqE/NPu5Rwo/y2Ptis74m5w/xXs/L3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0gsSeQB57OWaAojMa+b9EC5sVfUG/zQQuw62dmp8ic=;
 b=DIP6KwsEV+TDvepz4aeiMJqSKwd2kzmC4YBrRMdzFaJ6JjNdVUksc1k8GsXFGmWTZqllVYOixqxK0sSthLZn4NNcSUfT8eC8tvmoKeQeVQxTnTy5NdSG2OnryRJaXH0D54T/yrzBuYORWkrf64OnLIhuZHT9WBRtSxnz2Y1WAOapH9fsALiVpBeMkjLzUZ+LbJM6xc8dQcADUFUxF+WguQSmOZZzc7GHTEc/XJTGpzpDrVbZ1eFY4Ek3QjefEAhpmftiwFhTqqXv5Olt2LuLrIyKlxey0JElVKfnABfxg86iG5RPrM34O+36OjkLTOE98Pfolr+PO4poO3KbHLIDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0gsSeQB57OWaAojMa+b9EC5sVfUG/zQQuw62dmp8ic=;
 b=Ob0J6CC9dzbzuLyXxrERVR4r5RlqgkEn0fvHcW1wwB1cr0cz6fvVjFxD3/47onaHpzN91Um33N8RS9pfwspEqlm+GUh1r6TfQcac9dT+ov8cO6B7Epsdh9zbERrSDm921XmgB0ZK7JI21W6EhR1AhHBRAJok5skuwuEVr0lrB/4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:12:56 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:12:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 03/11] net/mlx5: Fix offset of tisc bits reserved
 field
Thread-Topic: [PATCH mlx5-next 03/11] net/mlx5: Fix offset of tisc bits
 reserved field
Thread-Index: AQHVRlJkqMfsMXBx6EWTMCn5TNPjqA==
Date:   Mon, 29 Jul 2019 21:12:56 +0000
Message-ID: <20190729211209.14772-4-saeedm@mellanox.com>
References: <20190729211209.14772-1-saeedm@mellanox.com>
In-Reply-To: <20190729211209.14772-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b3bdc9a-2d4f-42e4-9998-08d7146986be
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB23758C70DE13578E8D6549BEBEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(14444005)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(4744005)(71190400001)(71200400001)(110136005)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(11346002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7bB33Zudg8wP5P1GmYZh0Q8+lOBYz25FowJR2ldEP6fiH0Wiiw+Pkspp31hi1jmON5L1KZmOTRZmuvdHrE+MyJqbAGoQ4PQ/Rh/DZ8WDzcoNs/eJRog0Ak2zyKzVrozqWIBzCfWiL25iAOPSPL7KKYHD1Vgvfd/oYMc4okC8r/DG6b9BlK9JC25dV+bQHIHZTqP6Qgskndeufa/RChBlUqL484ov0uxUKQXJUrxwhAEO/XdrlPzAmGPFQLqzheklb70obmFnMbSJTNVVnr0NAO8zmJ7Sri8NFbFCX5XgqJWPatYZgDd5mK6oftA0ZkanmLYI3O5UtXGzdUpUDJt/t1T3Izw0BWC2imEdJf+W1IhgmA08E0gLu6KmozFY39CE7oppvFGgZb1uetrmR0H3o4sk2GneWNAMvCYcU7DU/Fs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3bdc9a-2d4f-42e4-9998-08d7146986be
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:12:56.4442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First reserved field is off by one instead of reserved_at_1 it should be
reserved_at_2, fix that.

Fixes: a12ff35e0fb7 ("net/mlx5: Introduce TLS TX offload hardware bits and =
structures")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 196987f14a3f..9265c84ad353 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2782,7 +2782,7 @@ struct mlx5_ifc_traffic_counter_bits {
 struct mlx5_ifc_tisc_bits {
 	u8         strict_lag_tx_port_affinity[0x1];
 	u8         tls_en[0x1];
-	u8         reserved_at_1[0x2];
+	u8         reserved_at_2[0x2];
 	u8         lag_tx_port_affinity[0x04];
=20
 	u8         reserved_at_8[0x4];
--=20
2.21.0

