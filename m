Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474641210A5
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfLPRFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:05:05 -0500
Received: from mail-eopbgr10062.outbound.protection.outlook.com ([40.107.1.62]:39904
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbfLPRFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:05:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cv0f9+PgstSDLBVvgHqL4L2k9/QqT8ZNwBDeCSAxMzpyz0iCueFx9xpRk8GH+6PPEEn0JYZQM+yd29K+7X4nJKOKQihtEuG8Hy9LtwnZP+FnJ/zKdne28J+e57KLSMi4/Gx89jhaQtGm56vv8NhNz8Y7RFpZGOw0YQRuV7peIBJGmGOZDjSRmz9Lays+5W4hC/RXfG3wa8uhPlF2LKNRlhYCqiOmU2JXf7C4/0TiNtd17LsI08EJsCTOqITz9+XG17iwNfVndIDvkx2KtKZyICHMBoCh1+mqT7fMIEZP1IHGwuToRnUDPMkdps1ec3FkQSKN+dCW+DjtZU52EUKsaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBk7OCKPYiHlbX8vxPSL65WcpDp5Iko8qjSrtFW4TpE=;
 b=DEY14M/24txPDdZbyuOpQfdHI2oMkK4Ob2gpr8tbjOkbSruf8BXsisI9Zjy0MLJsbaxfKnJ+bRgbszZkncWbolAgmp1ag5htTpu58Sf3J0foakvkqlK1fImQHaN7G3oDoMPPLanEVJB0Gcq2gdHIEjjEXPfd7IFu7vgerXUzESy+czT/zCS1A8DcEm4HVy9RiYBd8/pzQq5utGylZ9l9jid4x8gmqVm9NlPzinqYWKrI/PJiYvKvlo0A/rpQxO0T0PZyNpK/WmM4380IbvB+KqeUSfcbyblIVOsAb11yH5b/3HnaSQ45kQxNck8B9BgGD8Vo/IRiKhn8/xAgBq91pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBk7OCKPYiHlbX8vxPSL65WcpDp5Iko8qjSrtFW4TpE=;
 b=Pdj3JvcYn2Dg4RI3vf83P4d0vjOr/ND5y04JifRlIZhljm3sGRaMUcqIAgTH2bK8WPNuM9UbYHDsw48NGQaEALrOz/vcRsIMrgc/fGnwR2B/D8es5fgEcMx4/Syp96lg8VM2XsY8zWz1+mv+sJxQTKm6vDkp03bkptP3kBL6AN8=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3110.eurprd05.prod.outlook.com (10.172.246.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:02:00 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:02:00 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next mlxsw v1 10/10] selftests: qdiscs: Add test coverage
 for ETS Qdisc
Thread-Topic: [PATCH net-next mlxsw v1 10/10] selftests: qdiscs: Add test
 coverage for ETS Qdisc
Thread-Index: AQHVtDKHyX1iMT/ibky3jiEYYBkrZg==
Date:   Mon, 16 Dec 2019 17:01:59 +0000
Message-ID: <1e52ee8f70621825e92a1b96991d4928ef45d327.1576515562.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 7f517a16-9a4b-49a8-851b-08d78249aa07
x-ms-traffictypediagnostic: DB6PR0502MB3110:|DB6PR0502MB3110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3110F991BF896FAD90F51EAADB510@DB6PR0502MB3110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(189003)(199004)(8936002)(6506007)(26005)(478600001)(2616005)(81166006)(81156014)(8676002)(64756008)(66476007)(54906003)(66556008)(6486002)(36756003)(316002)(66946007)(66446008)(186003)(30864003)(6916009)(4326008)(71200400001)(86362001)(52116002)(2906002)(5660300002)(6512007)(559001)(579004)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3110;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WM9ddxiL8ejLreZysT0P2o7WoVJJUMYtpj6wHndspQKy9axZs+Jj8KvCksASuZukkEX4lJjUSuQS33HABmi7Srz0p80ec0ER5R32cpmYeFrnSVO4KtbixXJVOChEWse4twqj5PI9HH3gKffe/Uf5pTjDn+h6PodLsNEPUQvon4gWK7kuH5O6dZ/3g/QnEjZZwFHXgzXjtCBYFiQVVIcGje89jQjNnsrH/qXBhtEE5danTgzNvGw7pTNlnOlxo0dkQ57l0mYSCUrWmIUKBAcdks9LI04jtSlQ79620Dz7U1I0utJ/7vodT44ozTknpoVN5dJSjfDJe7OqtfTqGiOtTd9+fxY/XnL1O/LHa988qag5XCfa9pphwLSFU5nthLvzO7gDRz232kYBBasO/sWUyztYRNr8+K1ndLjkDIsvbKeIX45BsvfzBcHZWbr2C236jrWRZBYCnspg9mTWgvVw+0yB3QkTL2CTYlR5aHLkc10=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f517a16-9a4b-49a8-851b-08d78249aa07
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:01:59.7675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +aIqO1ZZ4w/hLMzqLqZbVHCl2kpu6UjchKI1lY3ReEfvzrpMcULFchz+bCNN74WF0zj0oHCmyASi1kc+qh4mcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add TDC coverage for the new ETS Qdisc.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---

Notes:
    v1 (internal):
    - Add a number of new tests to test default priomap band, overlarge
      number of bands, zeroes in quanta, and altogether missing quanta.

 .../tc-testing/tc-tests/qdiscs/ets.json       | 940 ++++++++++++++++++
 1 file changed, 940 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.=
json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json b/=
tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json
new file mode 100644
index 000000000000..180593010675
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json
@@ -0,0 +1,940 @@
+[
+    {
+        "id": "e90e",
+        "name": "Add ETS qdisc using bands",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .* bands 2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "b059",
+        "name": "Add ETS qdisc using quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a 1000 900 800 700",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 4 quanta 1000 900 800 7=
00",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "e8e7",
+        "name": "Add ETS qdisc using strict",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 3",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 3 strict 3",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "233c",
+        "name": "Add ETS qdisc using bands + quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 4 quanta 1000 900 800 700",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 4 quanta 1000 900 800 7=
00 priomap",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "3d35",
+        "name": "Add ETS qdisc using bands + strict",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 3 strict 3",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 3 strict 3 priomap",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "7f3b",
+        "name": "Add ETS qdisc using strict + quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 3 quanta 1500 750",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 5 strict 3 quanta 1500 =
750 priomap",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4593",
+        "name": "Add ETS qdisc using strict 0 + quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 0 quanta 1500 750",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 2 quanta 1500 750 priom=
ap",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "8938",
+        "name": "Add ETS qdisc using bands + strict + quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 5 strict 3 quanta 1500 750",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 5 .*strict 3 quanta 150=
0 750 priomap",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0782",
+        "name": "Add ETS qdisc with more bands than quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 2 quanta 1000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 2 .*quanta 1000 [1-9][0=
-9]* priomap",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "501b",
+        "name": "Add ETS qdisc with more bands than strict",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 3 strict 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 3 strict 1 quanta ([1-9=
][0-9]* ){2}priomap",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "671a",
+        "name": "Add ETS qdisc with more bands than strict + quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 3 strict 1 quanta 1000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 3 strict 1 quanta 1000 =
[1-9][0-9]* priomap",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2a23",
+        "name": "Add ETS qdisc with 16 bands",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 16",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .* bands 16",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "8daf",
+        "name": "Add ETS qdisc with 17 bands",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 17",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "7f95",
+        "name": "Add ETS qdisc with 17 strict",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 17",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "837a",
+        "name": "Add ETS qdisc with 16 quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .* bands 16",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "65b6",
+        "name": "Add ETS qdisc with 17 quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "b9e9",
+        "name": "Add ETS qdisc with 16 strict + quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 8 quanta 1 2 3 4 5 6 7 8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .* bands 16",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "9877",
+        "name": "Add ETS qdisc with 17 strict + quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 9 quanta 1 2 3 4 5 6 7 8",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "c696",
+        "name": "Add ETS qdisc with priomap",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 5 priomap 0 0 1 0 1 2 0 1 2 3 0 1 2 3 4 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*priomap 0 0 1 0 1 2 0 1 2 3 0=
 1 2 3 4 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "30c4",
+        "name": "Add ETS qdisc with quanta + priomap",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a 1000 2000 3000 4000 5000 priomap 0 0 1 0 1 2 0 1 2 3 0 1 2 3 4 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*quanta 1000 2000 3000 4000 50=
00 priomap 0 0 1 0 1 2 0 1 2 3 0 1 2 3 4 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "e8ac",
+        "name": "Add ETS qdisc with strict + priomap",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 5 priomap 0 0 1 0 1 2 0 1 2 3 0 1 2 3 4 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*bands 5 strict 5 priomap 0 0 =
1 0 1 2 0 1 2 3 0 1 2 3 4 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "5a7e",
+        "name": "Add ETS qdisc with quanta + strict + priomap",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 2 quanta 1000 2000 3000 priomap 0 0 1 0 1 2 0 1 2 3 0 1 2 3 4 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*strict 2 quanta 1000 2000 300=
0 priomap 0 0 1 0 1 2 0 1 2 3 0 1 2 3 4 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "cb8b",
+        "name": "Show ETS class :1",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a 4000 3000 2000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY classid 1:1",
+        "matchPattern": "class ets 1:1 root quantum 4000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "1b4e",
+        "name": "Show ETS class :2",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a 4000 3000 2000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY classid 1:2",
+        "matchPattern": "class ets 1:2 root quantum 3000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "f642",
+        "name": "Show ETS class :3",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a 4000 3000 2000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY classid 1:3",
+        "matchPattern": "class ets 1:3 root quantum 2000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0a5f",
+        "name": "Show ETS strict class",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 3",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY classid 1:1",
+        "matchPattern": "class ets 1:1 root $",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "f7c8",
+        "name": "Add ETS qdisc with too many quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 2 quanta 1000 2000 3000",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2389",
+        "name": "Add ETS qdisc with too many strict",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 2 strict 3",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "fe3c",
+        "name": "Add ETS qdisc with too many strict + quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 4 strict 2 quanta 1000 2000 3000",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "cb04",
+        "name": "Add ETS qdisc with excess priomap elements",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 5 priomap 0 0 1 0 1 2 0 1 2 3 0 1 2 3 4 0 1 2",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "c32e",
+        "name": "Add ETS qdisc with priomap above bands",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 2 priomap 0 1 2",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "744c",
+        "name": "Add ETS qdisc with priomap above quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a 1000 500 priomap 0 1 2",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "7b33",
+        "name": "Add ETS qdisc with priomap above strict",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 2 priomap 0 1 2",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "dbe6",
+        "name": "Add ETS qdisc with priomap above strict + quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets stric=
t 1 quanta 1000 500 priomap 0 1 2 3",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "bdb2",
+        "name": "Add ETS qdisc with priomap within bands with strict + qua=
nta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 4 strict 1 quanta 1000 500 priomap 0 1 2 3",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "1",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "39a3",
+        "name": "Add ETS qdisc with priomap above bands with strict + quan=
ta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 4 strict 1 quanta 1000 500 priomap 0 1 2 3 4",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "557c",
+        "name": "Unset priorities default to the last band",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 4 priomap 0 0 0 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets .*priomap 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3=
 3",
+        "matchCount": "1",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "a347",
+        "name": "Unset priorities default to the last band -- no priomap",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 4",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets .*priomap 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3=
 3",
+        "matchCount": "1",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "39c4",
+        "name": "Add ETS qdisc with too few bands",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 0",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "930b",
+        "name": "Add ETS qdisc with too many bands",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets bands=
 17",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "406a",
+        "name": "Add ETS qdisc without parameters",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "e51a",
+        "name": "Zero element in quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a 1000 0 800 700",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "e7f2",
+        "name": "Sole zero element in quanta",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a 0",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "d6e6",
+        "name": "No values after the quanta keyword",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root ets quant=
a",
+        "expExitCode": "255",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "28c6",
+        "name": "Change ETS band quantum",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root ets quanta 1000 2000 =
3000"
+        ],
+        "cmdUnderTest": "$TC class change dev $DUMMY classid 1:1 ets quant=
um 1500",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*quanta 1500 2000 3000 priomap=
 ",
+        "matchCount": "1",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4714",
+        "name": "Change ETS band without quantum",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root ets quanta 1000 2000 =
3000"
+        ],
+        "cmdUnderTest": "$TC class change dev $DUMMY classid 1:1 ets",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets 1: root .*quanta 1000 2000 3000 priomap=
 ",
+        "matchCount": "1",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "6979",
+        "name": "Change quantum of a strict ETS band",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root ets strict 5"
+        ],
+        "cmdUnderTest": "$TC class change dev $DUMMY classid 1:2 ets quant=
um 1500",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets .*bands 5 .*strict 5",
+        "matchCount": "1",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "9a7d",
+        "name": "Change ETS strict band without quantum",
+        "category": [
+            "qdisc",
+            "ets"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root ets strict 5"
+        ],
+        "cmdUnderTest": "$TC class change dev $DUMMY classid 1:2 ets",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ets .*bands 5 .*strict 5",
+        "matchCount": "1",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
--=20
2.20.1

