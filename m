Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68DC3121072
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfLPRB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:01:59 -0500
Received: from mail-eopbgr10062.outbound.protection.outlook.com ([40.107.1.62]:5601
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbfLPRB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:01:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6X1sXHhu08MyjGi0cb+E1mdiIz0G9ohyxqT/DeLy7Xh71N8qDLTMcvlMV6ZxfdRMrZ4qcKFjCNJe6bzq3HdT49dsdEh8TuOYv8f4e9CvdJIFsNdXTRkuTniWgn6HHOsxxAF6fr0HSKuOP2aVEcVExs+Up3RVM5YjJ3H25rLohdP6CT2RL9EnIU+ywsi3z+oe8njVI+zquJHB6FozxoozIuEhQ2V1BwGomQXZm6UvqV0NwbTGVSlv6PXmSbqpkAW1q337T6dMHbbGblloEc8HJLr7kUNiClS94hz+qQ1jhgVmhSm/876GjaR2eiAAIxl/qXaVaCxLQ1tzrvcH/dUwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkQbSoIy1Vbnfd1SpoXRPW7S8t0d1xrkxX6o6cOD6Ro=;
 b=H6C/55jD1HzNbgLZdHsFr9XRult7KJAHyf09HtQo8uYcnV62BxhgmaRIyjeSLCH6JPIx7I5gbk/Y3lRxrFOMu6/he2Nb0pwd+CrE97/UUuDNkh3OZVdQjynItGOxEkMBfxJuY79UTcGrk8XaJ+o21jxM6cOzKVfR8XCaNWXW4Ox/ujc2pfzNGiaE88QddIYSSH62bLl5jjYEvdPYAGaU8MGOgEt/ddmogOebaPmocril+B32yTAKcfZf1kHzjgq2vsi9ydilfmCHIOnr4CKtXxTndJADNHZmegfro7BCR6HLYH3g1AWUZmNs9pBrD+8H5LbtKpf7fq9JMQXU2/gvGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkQbSoIy1Vbnfd1SpoXRPW7S8t0d1xrkxX6o6cOD6Ro=;
 b=TCviycMVjtdkhTL962rnYG6yzEXMFMDm5NXTDm8UAEtFICvRfN0WN52WI3yi+s1q/5loJ/8qKWjVaCc7G3+dO4TcNm0ByjKzkhNWM7QAj2vTQHVeQMjPkHgKUgR5VyEgA+xaAAzOZ5HGP41wmGq6D94gvdLEYpsut8Id2N88d08=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3110.eurprd05.prod.outlook.com (10.172.246.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:01:55 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:01:55 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v1 08/10] selftests: forwarding: Move
 start_/stop_traffic from mlxsw to lib.sh
Thread-Topic: [PATCH net-next mlxsw v1 08/10] selftests: forwarding: Move
 start_/stop_traffic from mlxsw to lib.sh
Thread-Index: AQHVtDKFE2MPS9XS6UiIYC3n92v4Kw==
Date:   Mon, 16 Dec 2019 17:01:55 +0000
Message-ID: <339e0ce20346608fb2fdc61f582883e82c74ce11.1576515562.git.petrm@mellanox.com>
References: <cover.1576515562.git.petrm@mellanox.com>
In-Reply-To: <cover.1576515562.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR0P264CA0027.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::15) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6585ee50-bfda-474f-a165-08d78249a772
x-ms-traffictypediagnostic: DB6PR0502MB3110:|DB6PR0502MB3110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3110399502F86E31553C46BDDB510@DB6PR0502MB3110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(189003)(199004)(8936002)(6506007)(26005)(478600001)(2616005)(81166006)(81156014)(8676002)(64756008)(66476007)(54906003)(66556008)(6486002)(36756003)(316002)(66946007)(66446008)(186003)(107886003)(6916009)(4326008)(71200400001)(86362001)(52116002)(2906002)(5660300002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3110;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R0KxeGdcPpm8GqzBDGCAwhCUlowyls91HzDNxrqCPhAJZbYUwlrPy3af0Wygxwq9PhHkb3/5QsaN1GPaCUzLLCYYl2DUTbyaQjJx88pvblSo7HHTfhl/JcVwpiNnMpDlZIy7PX/U/IOLWc6rDJXMOnqJtyxf89P1y8VNG28Tl9ZjwdMJjh2Pg32RxLsfu/z0fq2LE4pS5BCRaJYNofAPN2bIVCCnxFTKfM9DrP4q3LZZu55mYsUUhuedP2m2aRQCxb7hK/jHHQsKUPGkRo0cWwgHJHle5gHPPtuTY5DP8U4jnsAa9jOj4DsUhBG9g8+5/etbtoUXitrwzaLys8VaIbZDoErnXu4IuaKtDMRPdaGne1TQKgmy0pk8Ik6apVPqW9YFZX+xhPXk9iFGuATDjmmT7ARzZ6oTirkNYt7Li0zgpdILCAF8doPi/0PgBlSW
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6585ee50-bfda-474f-a165-08d78249a772
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:01:55.3763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uAO6+6fFXYAQGA/aJNqdG3XyBXQD4HQhQUUo5JEOY5EKpTEDdpWv/Vz6/gIS2d9dhmllIxG45VIvXIXi5i8RUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two functions are used for starting several streams of traffic, and
then stopping them later. They will be handy for the test coverage of ETS
Qdisc. Move them from mlxsw-specific qos_lib.sh to the generic lib.sh.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
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
index 1f64e7348f69..a0b09bb6995e 100644
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

