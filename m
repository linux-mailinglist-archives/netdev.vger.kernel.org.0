Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B178F501
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbfHOTqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:46:23 -0400
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:51424
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729779AbfHOTqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:46:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmEOnrhxjVpJEy56gz/vVtCStxvbcPZzn8k37UBNxpDtiontGOu7SThg4Dyd4AMMFBQqBOyRIEZROtu7L9tWrTH4JNlcj967YMae3yO2Pw/5leT5ZyE1vTr4co8eE0EfnKgdk7frWRC5IEq2jzWZq8azbKkOJye8eKRHhqv4R8HXzWbg0ZaMyNG00+DxamkAKFjUnjJeFOTLLE2ipOPV11F00pLj4UJZFo5RdZrcXHjA54cpU77cFnyO8tzonOEXKgr310P3t1FYE0pm4C6NbGktB5wq++16FCqpQAdooREOO5NRdDgb4/j8bpTkjFuuR/Z6XiplUgu4bGaVNnk5tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06vtXuPF/djEz/D41R63/YfAUVxOXfSdGM/EZCVTLrw=;
 b=PNzWvdWyPUv28+h6wlEQHuj3dLP5YChh+Xx55EC2uMlYsn6qsL1W5Gz6kBZiIgSIF8hncB+EDqVF6PzJqwAs2cqsP4HQZDAXDPcSqhZwdGARpNjlvpX2+E6sBod5DZf7D+Wd8Mm5Cq2rk6mS34p00SW6p9Tgi/8uIanUfOq1v9/+fgqn2zeEbrIMAGNjiVKMhv/a+lETmiJ7gM4WwDB579n85RB7hDZCff3R0wZCnrO86ByUJnH5gi/kXaEBPs4d88+YIvCAHZZtaWW98MJJMvV7S9I3cmaKFH8+Ci91vIXAqeDeZtKCTYj8sn4tB6i3PkRGNvKYZHGSRGJVyJ1HiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06vtXuPF/djEz/D41R63/YfAUVxOXfSdGM/EZCVTLrw=;
 b=q7auQ8Hl8C93SY5DOMkAwiKWFiFxSizLctbHXchJtwSDp14xifM4SiEcvMmv01Dix+T8jcW2Z25IzDwhXhxUQhHQml8jbAWet4i9ZrG+XCL8SNcJx7s0oJHXb/ISnxePGVGOwhaAEDcMWhkLI8tYmhr7en+TA0GRl2OxgT4CXJo=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2693.eurprd05.prod.outlook.com (10.172.226.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Thu, 15 Aug 2019 19:46:17 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:46:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH mlx5-next 4/5] net/mlx5: Expose IP-in-IP capability bit
Thread-Topic: [PATCH mlx5-next 4/5] net/mlx5: Expose IP-in-IP capability bit
Thread-Index: AQHVU6IYa6/crw8iskuKL1DPeIpvgQ==
Date:   Thu, 15 Aug 2019 19:46:14 +0000
Message-ID: <20190815194543.14369-5-saeedm@mellanox.com>
References: <20190815194543.14369-1-saeedm@mellanox.com>
In-Reply-To: <20190815194543.14369-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1889b687-da92-4655-50d2-08d721b93af6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2693;
x-ms-traffictypediagnostic: DB6PR0501MB2693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB269321C07614BDD31A24FD95BEAC0@DB6PR0501MB2693.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(199004)(189003)(478600001)(64756008)(6506007)(186003)(102836004)(476003)(66556008)(26005)(14454004)(66446008)(86362001)(2906002)(25786009)(66476007)(66946007)(3846002)(4326008)(6486002)(6116002)(6636002)(76176011)(386003)(450100002)(53936002)(66066001)(107886003)(5660300002)(1076003)(71190400001)(8676002)(71200400001)(256004)(486006)(4744005)(54906003)(6666004)(81156014)(8936002)(6512007)(14444005)(99286004)(36756003)(305945005)(50226002)(52116002)(316002)(6436002)(110136005)(11346002)(446003)(7736002)(2616005)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2693;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: y42W0y6ATO3kqm1lTYD25W8InBNtNpQK5kIpsOA+GxoblMK0EtW6S0VFf+a+oAhDe4xttCz+83ObYzFB+BXrvsqFlU2agsLzESm3mTSb5mofEXfFHBluJYrECR8bRGMo3ogLTFBpGqMkHwaGcZOh0bogko5EHvXNUlJq9zlKJqsky8N9WE0Z3q5t4t8wPQ/DMGgbwSmRW7ODNlycKXzMkmRicu7WFJQzsdnhykyvd6bQMIiLbseiTixz8ZPFyRw8NVNvsJHz5t3F43IkOAaoKikEWjj+614yDHvrgD9+IGrQ09+GgHw1WbtAr/1a+k5VZ/t4D9RdwFHrFUP08Fwrr7SkKx2IbEv6ubeo4kkWRuG31ZkLJX9QEcUTXgJma+rH8L4VdF1Z2J/6FwJ2kh3AkYp9X60Re59KhdjUdip18N8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1889b687-da92-4655-50d2-08d721b93af6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:46:14.1300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lPRkO296nlxV3WNp0cDP4Jpcj7BTFMqKT91Af5RKOl/WXzyOnvZt+f0YkusJdpBjyOTI8BTFRTA7jkBVFpD7+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2693
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Expose Fw indication that it supports Stateless Offloads for IP over IP
tunneled packets. The following offloads are supported for the inner
packets: RSS, RX & TX Checksum Offloads, LSO and Flow Steering.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c788f895b350..2837fe4d8901 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -808,7 +808,9 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bi=
ts {
 	u8         swp_csum[0x1];
 	u8         swp_lso[0x1];
 	u8         cqe_checksum_full[0x1];
-	u8         reserved_at_24[0xc];
+	u8         reserved_at_24[0x5];
+	u8         tunnel_stateless_ip_over_ip[0x1];
+	u8         reserved_at_2a[0x6];
 	u8         max_vxlan_udp_ports[0x8];
 	u8         reserved_at_38[0x6];
 	u8         max_geneve_opt_len[0x1];
--=20
2.21.0

