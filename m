Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D44103AB1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfKTNFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:37 -0500
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:50305
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728787AbfKTNFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUOC59t0Xk3wj/sFMwOuBmVDEy4h8OAFXl+5Z42cWz9pLdtIv77Wm6ndhuvA3okVqgwF0ud3qR4kKoigcokviIqKcZ35wds6FzlyS6ezR8/lDGlpadbBinc34FrAJOXq01DIIMMZd5GKnTRZohfuvzBaz5HaQBXoRwrLkuYpZd6AG0MSrKGFWbnOTA8B8FDIGoXq/72l8o2+LAVwgC4Z5CP2LnCeHUFrOsgzSbkHJLVpwJNPXaBUOpMVlv0D9ApeigQzOJ7H+Z9Ve0nXDMCL/hqEJ6AezWiM6ro1R6h+hH+pifoaO4rn5mbE4SpSGQnZxpejskJBlU1/ASUrsD7Z5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksqp3vhboUS86x1tLQgGNIKetuGs8cpUXjOPffuxx6M=;
 b=GTJ3rMxVW/TPzgb0957RV+nWuY39Jah+YjPCzdl0V8mw28+kx6Wkz23liRzBbmrGj6U+/NiTXOSTwlw5zjF60SYRuY6Gf3a7IOl1S3ehC5/D7NTtdYsC0h3X/a9XMy2Ss2P2+mu4AsSbx3dTfZSfUjOyq5tTIEee5z06Otm4pdNU7Xn5HkyPL/dcrI+6M4ibdpXDXI+BC9N8uZNDpZBhFYtEZHxkwg215cERvrIxmwNbSdchFBzvBCn8aGWUODo9G2nboOzO84BioZbPuAmFTeXJJY5Vo0yZ8TpUy/YYcKiXN4IhEejVf9iw7GgBXOCJLSjsoc+yo6MvBp8HNYJlUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksqp3vhboUS86x1tLQgGNIKetuGs8cpUXjOPffuxx6M=;
 b=Q2sEfhEOSpebjKWXvAbdAYb3vLryzsGMNS6N6TaS+mRHo8LUtxGV1T7EtIojVVNkb/tDH1G/qE4EBr3RW4JpkWECIJ8Mf7x+7po3W8IFMpStDzPTNb/SU8FhVRYboqVSMOUccWt3Si4JEW/pkaD3o1O6y2vmOf39p5BdXy54jcU=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:19 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:19 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 10/10] selftests: qdiscs: Add test coverage for ETS Qdisc
Thread-Topic: [RFC PATCH 10/10] selftests: qdiscs: Add test coverage for ETS
 Qdisc
Thread-Index: AQHVn6Mocm4KwGkon0KLnlCM/Wt2tQ==
Date:   Wed, 20 Nov 2019 13:05:19 +0000
Message-ID: <4c364de6add3e615f1675ddb4d2911491a65bd8a.1574253236.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 60eaedea-585d-46a4-87cb-08d76dba4b29
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2982EFAEA6F9D483CBD9330BDB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(446003)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(76176011)(71190400001)(71200400001)(2351001)(256004)(64756008)(30864003)(2501003)(52116002)(86362001)(486006)(6116002)(11346002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4326008)(118296001)(559001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OeL20mx6aOHK1UuiTmaQZ0Ba5mc6aAVK+mkSDhmDa8mV/qEezd0ZWqBwX41j3oc9WD1KKY0iIXCxvKkmuEGJOlvQWVRv1rJWZ7Z6khOuA8erLWW1nEaI78/74W9fG41RPnWD+3wAYZuiAoPPyupw3j0Llad030P13B27IT1Ta6woLEUxdAfVq9POelTTnsBdVxo8aIVXY7Tk8axlKvd0tDDvQm4QZIQhLT1mWlIPE0Kl8uXM+aAOPHXW6GpWV57L3MvOIfRiWLRyHc5+cXOGN0j6aQTkT2qPXwPnG68Qh/Ht62oNlXE0sAj1B12biMOsS4e7401SgoSHj2ICNx9yQhjphg30kQglbq5dDxVe95230wHWVL6uGQ6NVhYLuErKjfyih9K4MgPtkCBxy2KrsVp6Bd5I3q1/CNxAdXZ93eZUDaZxE8i+chgdsj/RvD92
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60eaedea-585d-46a4-87cb-08d76dba4b29
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:19.1550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qd4C4taso+v4bzwLsRrrmSQ6tKjNtAlW33/7Gd4CS0z+kAm/VJU5/WRC/C1M/Acor9624uQHBKxDBh2D4UDiDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add TDC coverage for the new ETS Qdisc.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../tc-testing/tc-tests/qdiscs/ets.json       | 709 ++++++++++++++++++
 1 file changed, 709 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.=
json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json b/=
tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json
new file mode 100644
index 000000000000..6619d6bceb49
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json
@@ -0,0 +1,709 @@
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

