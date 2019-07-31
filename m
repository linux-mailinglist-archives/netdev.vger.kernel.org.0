Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96FC97BE6E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 12:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387732AbfGaKac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 06:30:32 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:50805
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387684AbfGaKab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 06:30:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1akvUnp967n9UhJIylLOHh9NipzZ8oHeH5nzUK2cetKRZcsHaE90bd1JqKK8LB0AJSlivxHYqE8dnWXStNV2+KwL9E2wx0UgDQhB4NNNeOQUegGptGSl7y6ridYSD2w12ii2djGyQJPtisqv6x6HiErU0Esx4hyAH1cZdQ2xNVxyuwjbP9dHpUSO6MyoWZn3gx/AWBhc+cQLcqZ1tyfER2rbLACkENzH8vyAlyp0yoAhh+svyF8z0aXw0Yg1y8ZUkwDBJfidNebb6Y59G2sgzsdhtKXWMuTi15+PGCSjO6EeNCTBamZnAgimkIFFnKwIzFFKTdDe4oMyUzfAPw+pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ol9UZyZHmCnlFAP4g1EKEuWbMkixPHUx+iEG1QKMDq4=;
 b=Gv2gisytyVFlBMxKCYHVk+6TcYVebR2UsjiJT5jHDSxjOYvNA/EEzbd8L87nv6j8RVOiQekzdATnQkzkTbLCejFajXmiTmusfffU9hWHLlw3uzZkAGUBmhoa/ZErFQktJWjQnXRoVZ51zCDSnqUJtMy1VHwB5hOhlnovm+PI2xLmtYUbpvXNYt9mP8cRsnAgirVSKB6Pn6CwrdqpNmYBqk3nllGX7LgJVkgLDJhIX+Nmc8dS1OqHSX9SVGxKZSMBLE+bFD+yqHwmwF4PIFsBm7i99esdEPSaHno3VusXxyXFXx47HlAf34WIUjYeREstb+V057ZcrQ+pikvRUpNqrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ol9UZyZHmCnlFAP4g1EKEuWbMkixPHUx+iEG1QKMDq4=;
 b=Kig/kcJQMgs09WFBQ2es0/IyapqOaygefHMFUnDxIz+2kIHeP9lRjx5WiwYkDxZLQyQOW+7p83XleakHi0zK86N1UXuV/0GWumyYLTvc0683Ra1vqodSIhh1OUkQYGIzw7b1XO6H89Tr6b7cqzxuEOvi/sJkgkDWu9EKkWKSSUw=
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com (20.179.10.157) by
 DB8PR05MB6603.eurprd05.prod.outlook.com (20.179.11.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 10:30:27 +0000
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e]) by DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e%3]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 10:30:27 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] selftests: mlxsw: Add a test for leftover DSCP
 rule
Thread-Topic: [PATCH net-next 2/2] selftests: mlxsw: Add a test for leftover
 DSCP rule
Thread-Index: AQHVR4r4mLjngltCtEKnry+/FSFpgw==
Date:   Wed, 31 Jul 2019 10:30:27 +0000
Message-ID: <9a625a8947b375f82b1361d37e9444b6d7f362ca.1564568595.git.petrm@mellanox.com>
References: <cover.1564568595.git.petrm@mellanox.com>
In-Reply-To: <cover.1564568595.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0132.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::24) To DB8PR05MB6044.eurprd05.prod.outlook.com
 (2603:10a6:10:aa::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45719dcd-0d2a-47e5-6cdd-08d715a21a7c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB6603;
x-ms-traffictypediagnostic: DB8PR05MB6603:
x-microsoft-antispam-prvs: <DB8PR05MB66031FB0354861BBC7E2ACEEDBDF0@DB8PR05MB6603.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(199004)(189003)(6436002)(6486002)(86362001)(3846002)(8936002)(71190400001)(5660300002)(8676002)(107886003)(71200400001)(66066001)(2906002)(305945005)(54906003)(66574012)(14454004)(81156014)(81166006)(1730700003)(316002)(7736002)(6916009)(118296001)(6116002)(36756003)(50226002)(99286004)(186003)(476003)(6512007)(76176011)(11346002)(446003)(6506007)(5640700003)(68736007)(486006)(2616005)(66556008)(14444005)(478600001)(256004)(102836004)(52116002)(386003)(2501003)(53936002)(64756008)(66446008)(66476007)(66946007)(2351001)(26005)(4326008)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6603;H:DB8PR05MB6044.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3UX01nrrtTI+/KcJYnJAddNM4aRizRRKOvBf/hmvFEgQQxcP30DejliQ/MmCNq4tWMrVuLGVEz7zYwNK2wJEfQiC6liONNHpUT/e5cHs19t0NL00d0c0fwr0A2YE7NQKyY2Lld++x8lm4skhwN1FNnN2f66g+kji/ZY3vlWVvgIR83ae2fZHrb1zYx5b6A666mws1k58smeKzVXBtluNhq2MGvhG+09Ku6EPxlL5wcdrxlOpvT40F7raMkEBMJnajFlUR6KlZMJLqwNFJMKyyjVMHIDZEPGY+ORMdnSoB4Tr6G6P8wjaTOp3yrJAdJXvEW3N9d8wlK57y1wowzTyMiJq4ReZQNAOqpXP9DNtQUiqDVxA1q0aevaRUQ2rD5H/vgjr0bveP3uFAdbbuuI+2zsAiN8/KNPHR6k3gUaZUtY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45719dcd-0d2a-47e5-6cdd-08d715a21a7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 10:30:27.1960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6603
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit dedfde2fe1c4 ("mlxsw: spectrum_dcb: Configure DSCP map as the last
rule is removed") fixed a problem in mlxsw where last DSCP rule to be
removed remained in effect when DSCP rewrite was applied.

Add a selftest that covers this problem.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../drivers/net/mlxsw/qos_dscp_router.sh      | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh b=
/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
index f25e3229e1cc..c745ce3befee 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
@@ -31,6 +31,7 @@ ALL_TESTS=3D"
 	ping_ipv4
 	test_update
 	test_no_update
+	test_dscp_leftover
 "
=20
 lib_dir=3D$(dirname $0)/../../../net/forwarding
@@ -50,6 +51,11 @@ reprioritize()
 	echo ${reprio[$in]}
 }
=20
+zero()
+{
+    echo 0
+}
+
 h1_create()
 {
 	simple_if_init $h1 192.0.2.1/28
@@ -225,6 +231,19 @@ test_no_update()
 	__test_update 0 echo
 }
=20
+# Test that when the last APP rule is removed, the prio->DSCP map is prope=
rly
+# set to zeroes, and that the last APP rule does not stay active in the AS=
IC.
+test_dscp_leftover()
+{
+	lldptool -T -i $swp2 -V APP -d $(dscp_map 0) >/dev/null
+	lldpad_app_wait_del
+
+	__test_update 0 zero
+
+	lldptool -T -i $swp2 -V APP $(dscp_map 0) >/dev/null
+	lldpad_app_wait_set $swp2
+}
+
 trap cleanup EXIT
=20
 setup_prepare
--=20
2.20.1

