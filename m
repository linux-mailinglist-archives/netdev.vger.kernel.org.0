Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004C4103AB2
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbfKTNFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:36 -0500
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:50305
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730036AbfKTNF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHwnOOVYiQNwbMfbf/riBCJEMsiybpZdut+iZUd8udUIWSaE2RyaIRuDyHxvn6C2MKHwENKSr0/wVzMbSM/fKrIZLtMranpyaZtRiE8X4oEGLVKR0sExIavdNwqM8hiyfnn5EnYnm+dLPmrXAqEvqpW51GQ3RcI1bIQuCjjnM+CkColq6FF/MyA87O8ik6xEdhoApJVgTGV7DFfcw/tOrlodFkHQfIEtL2Mbw2ZefJ92aUORedpItxwodKaOcjzQcXeRiGX87Asf0hxUtRfE97848WJEnjOsAL74YwhsCHzVq9C84fAt6twLxhG8CyrVHZ6gzN7MC8eyR0IGWKXuBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mS73ZXqNYu94Z+Q4Ry5xD8Cn4zKyy6UzIVXu48hos+A=;
 b=MzvL7TWBrbNpLTILkGyyTe6MkSein9Ht1oUl+ZyiDikv2YGSUfLbKBItKHc4TFk2a4nJ427ea8rEGYkA6Hi+aTMx4JOXGgfrZ3lwt83gRE23Rl/VrsKbZDnHYT29ShVLjTiNtV9bu5BWad8eDk79AHQBEPGIr1EOhMM6EcLSmytK92juIAWcxQi7O+Nr+3KPKIPMVdnBMi8w4YORGCKEMJkBI6kQgYb9/Hcd9BUFvIbVEZfHXB624QPTb5kcfVaGBXVaPSz9j0mwemwLtA+fcFFY0Y58cirEDTNXUkQ5FXvegv3SMNfzsnjdLPfYFQd6IJQNoPIvgYsJ2Zxu4UIalA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mS73ZXqNYu94Z+Q4Ry5xD8Cn4zKyy6UzIVXu48hos+A=;
 b=p1xuaU7uXYS95jwhC3cMJ3BNSOQI0fnxKewtQbjcWAlGCPZ+nYWqFZ9QvIW0oaVMSYm8KsyS+0xd0dxsmjskKgA2DIX+UZsX0AXd86aSHBnUYN4VIW8MuSH4of2IU76q0ORvKjTcQgGVTlzNvAYKvJhoiEt2NMcWV+2y4CQRZKY=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:17 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:17 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 08/10] selftests: forwarding: Move start_/stop_traffic
 from mlxsw to lib.sh
Thread-Topic: [RFC PATCH 08/10] selftests: forwarding: Move
 start_/stop_traffic from mlxsw to lib.sh
Thread-Index: AQHVn6Mn36xSPbPOoUaEdHl71IOxrw==
Date:   Wed, 20 Nov 2019 13:05:17 +0000
Message-ID: <f9c80a60646abe6d80953cda142f511cf95a7045.1574253236.git.petrm@mellanox.com>
References: <cover.1574253236.git.petrm@mellanox.com>
In-Reply-To: <cover.1574253236.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 360f0a1a-008b-4065-8c69-08d76dba4a0b
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB29824794C39F172A42A23569DB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(446003)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(76176011)(71190400001)(71200400001)(2351001)(256004)(64756008)(2501003)(52116002)(86362001)(486006)(6116002)(11346002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4326008)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xCze6NYu8XHqfL325/flRV6xKqE273aF8nmHnjpdswcHiloa0FPqUho1Jxt7cNL5R0hwYA+CWmYZw/zNYrUeG7LoTbQwark95ET0fagaylewjUL0dD/f/UkfkAd8xzXsbzv7wGBaJQ32ZpM31o6ZvNYpPbbArzzyV/zY4wytXV3DRWtr+04uI7uXUsZp5MR3EDnvRbQ+Z4+BKsGy8WCMfn6lMWMUGwf4wTAcBhaTOZzbmstG2a82Pd3lCR/yn1xLM8AYFc0RRdpkQ4/TQ4mTicD/62A1zAPXIGgM2HdU/ucGqAWHBuvklfEnerVr1jHx2LE5uEFYTH5D/gzfcZAX5nWEReX5+TYLm0/swMl+Ut5kzYjWQUjeMI9jDEzdfD9KCFWBPLUi62JIrRMNMGgDqQeVJLLbPinamrOlH1NcaJPJuY8cn4tbrQu+JGx05tIe
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 360f0a1a-008b-4065-8c69-08d76dba4a0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:17.2049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BDAb4VVbxsuY38TK7Vnz0WaWh4vGJ3m5iOn7KVB5MZeRQM4erRLh1mGTDu0gvAwFDmzets0cBwl/sUhFnaawGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two functions are used for starting several streams of traffic, and
then stopping them later. They will be handy for the test coverage of ETS
Qdisc. Move them from mlxsw-specific qos_lib.sh to the generic lib.sh.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/qos_lib.sh     | 18 ------------------
 tools/testing/selftests/net/forwarding/lib.sh  | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh b/tools/t=
esting/selftests/drivers/net/mlxsw/qos_lib.sh
index e80be65799ad..75a3fb3b5663 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
@@ -24,24 +24,6 @@ rate()
 	echo $((8 * (t1 - t0) / interval))
 }
=20
-start_traffic()
-{
-	local h_in=3D$1; shift    # Where the traffic egresses the host
-	local sip=3D$1; shift
-	local dip=3D$1; shift
-	local dmac=3D$1; shift
-
-	$MZ $h_in -p 8000 -A $sip -B $dip -c 0 \
-		-a own -b $dmac -t udp -q &
-	sleep 1
-}
-
-stop_traffic()
-{
-	# Suppress noise from killing mausezahn.
-	{ kill %% && wait %%; } 2>/dev/null
-}
-
 check_rate()
 {
 	local rate=3D$1; shift
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/=
selftests/net/forwarding/lib.sh
index 2f8cfea070c5..8ff242fa5f0d 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1065,3 +1065,21 @@ flood_test()
 	flood_unicast_test $br_port $host1_if $host2_if
 	flood_multicast_test $br_port $host1_if $host2_if
 }
+
+start_traffic()
+{
+	local h_in=3D$1; shift    # Where the traffic egresses the host
+	local sip=3D$1; shift
+	local dip=3D$1; shift
+	local dmac=3D$1; shift
+
+	$MZ $h_in -p 8000 -A $sip -B $dip -c 0 \
+		-a own -b $dmac -t udp -q &
+	sleep 1
+}
+
+stop_traffic()
+{
+	# Suppress noise from killing mausezahn.
+	{ kill %% && wait %%; } 2>/dev/null
+}
--=20
2.20.1

