Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524B7E3C16
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392976AbfJXTis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:38:48 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:7745
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392853AbfJXTir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:38:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cenA2Pu6/y7Z04L1Gt6Zo/PpPlrWfDznRBo7UH9F9JyUb1pL+daQWas4jfCQyS1kQiTr99e0eWvWad04WgSFS+v0kvUHXNmJD10HjpCWOTwf54hbMtCPaSKjKvUmnmwmwuAgGaBIOdcvbdyU2yIJyt0cMUJIuBczMh8/iI8R4QP32KI0bdj7lpDkvDAIPJ9ShUt/akzN4GKHHnGJ1crlIM5ya/sAAYSNVneBRwrCSzq9jUz6Gmp6zH3xiSjcFZppTih9I06Rb85ZMe/EP9uxvZXbsHNsp+bYlUXqlEKZ7+rJxDRdxj6Hsm6AjR0M7GbpP8cbgS47tNkHo/mVFORI0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBCIR60K3WMHBJjcllZ7YBoVZNNxzrbohFUYITnRV8k=;
 b=At8BLFu9jyMs5G2wh2YqM3KADPiFxf0zxWIxficRLvvfMArKB4FES88sZEPUC9Us1lop/yY1v6rqk7c064NDN4ZuLQzMBXk9q5aaMBlt8IdZeep54EZbuq5za2ff7LcosfjhXdloCG8kKOcgpkqPXOJimPlybWMLr/N+O+KQxMdWZHxlydD/b34gqQcLd8C5nZ5BuZRq26qt8FRFFLRXSxtTa3jKTFoJfiEdg1Z5JB9EtMEJPcOWi/8G6P+n6jQo8d2/ixT6JlV/+fdOcgWD4ypo0I37crRyuvGYVMRDlN/Vb77dMbz8ZpsaYx+mbn0GoXJtflq9vSRdDTMepXyfyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBCIR60K3WMHBJjcllZ7YBoVZNNxzrbohFUYITnRV8k=;
 b=A0MX7MQAMEz4DrKlITro7zTPbNpyoWWQNZBgiAaSAtMTaP+60PZEZ0Yr3ge1Rl2TuRg9rgT7pBePPucIfMP59uGFbgXRxGaenM1PFq9oe12r2FUq/Bu0y7mcy6cVtcRNJJKgcRLc+SwhEifbIIC1cribTYTAlmzndYgrupqgpNw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:38:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:38:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 01/11] net/mlx5: Fix flow counter list auto bits struct
Thread-Topic: [net 01/11] net/mlx5: Fix flow counter list auto bits struct
Thread-Index: AQHViqKkE96YBeGp2UiTepnRVJSrkw==
Date:   Thu, 24 Oct 2019 19:38:42 +0000
Message-ID: <20191024193819.10389-2-saeedm@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
In-Reply-To: <20191024193819.10389-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d2dcb0bf-cfb6-4a51-67c8-08d758b9c6ad
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4623A7AC011C50AA7B56BA70BE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R391cQ8i+ek1Tk5RUlyYbJ2Tm92yNQQXWwYBYvpnMtdsi/+5uMITynrFQn01zY0CA5d6D+j2+S6GvJK+pVxCtmpIPUdU8Z+XbMqr+m2GeGAij1llQic4D2byVURtJA/OutdBn1AJiK1ozmbYFpH5/WcNhzwCum1UZxALcji8T0CLFchzrRPq+5sk2mvw2aEPxCCrFOdVfRiMkI/D6WkgHJFWt59XgPXcUipv/0qVI1cQYEqpPw10TIlnkDYEkCFrkxvOB9Bf1pZbQ5VpMwQioQpuGNN4OOf8WtYo+RyecE5ONrxNMdN/gssZvQ8h8BYUAAEH9bBEn1krBdR8/klm1SjqUBNEFL1Qv6ESL9LV50Iv5g8e7y5PkpZj/Hoaz1M5+MaXESopRZlmzlcVYRu33P7aS80DIm5/2/aAsfLZ33aAJtQ4OL9qFeiyBdrUIoyL
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2dcb0bf-cfb6-4a51-67c8-08d758b9c6ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:38:42.5699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e3GIOm5tEAka7AC3l83UQJ5jQJGuebL4vmm9s9UyGJMDorVBKQ5fLxXEP8Y1bzoLrzSYH/Z/QESTU/xoZB6XNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

The union should contain the extended dest and counter list.
Remove the resevered 0x40 bits which is redundant.
This change doesn't break any functionally.
Everything works today because the code in fs_cmd.c is using
the correct structs if extended dest or the basic dest.

Fixes: 1b115498598f ("net/mlx5: Introduce extended destination fields")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 138c50d5a353..0836fe232f97 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1545,9 +1545,8 @@ struct mlx5_ifc_extended_dest_format_bits {
 };
=20
 union mlx5_ifc_dest_format_struct_flow_counter_list_auto_bits {
-	struct mlx5_ifc_dest_format_struct_bits dest_format_struct;
+	struct mlx5_ifc_extended_dest_format_bits extended_dest_format;
 	struct mlx5_ifc_flow_counter_list_bits flow_counter_list;
-	u8         reserved_at_0[0x40];
 };
=20
 struct mlx5_ifc_fte_match_param_bits {
--=20
2.21.0

