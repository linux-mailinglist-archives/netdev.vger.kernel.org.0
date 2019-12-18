Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1CA124A77
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfLROz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:55:56 -0500
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:9171
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727183AbfLROzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:55:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHlx6JkJGCyk6P4oss+J0f6EYzhTD2z4q4DY22pPX8dBiSfQar9HB6fkPJHruy3p3tMcdsHH1lxmzZrSn35Cs0YQGfPYmCfTgj5kNoJea5WLaheELRiz7hU+XEdbQySlfz226sCYCtqhK/i1Tem4xUW8nMSJxVGrPKBX/glTzDeYWJlfheE/K/arxzNCtyir4Y7AdtQBIP2nIqDbFuAudS522R3FyInqaW+//2IX1xUB745B5XKny4MPF2Gn1aREKGo0kFkQk8UmSmpDrpwo/V6rzAUkUO02dRKWk9LPwShkQNeYIb0LywUm6HXr7cbbMrNkYnV1fC86AF7aq9l4Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBk7OCKPYiHlbX8vxPSL65WcpDp5Iko8qjSrtFW4TpE=;
 b=Jyj/V6Q2kqDSMwsWt10Mqa+iarAiFCefZFVuKGZ1yLGlJt7Cpiw7lDmtzFQUY+p50e2CRk00vX7DUuV/4TPtkn9eJ1SS7ouQnVorz+xRnVqLy8MVmDtiBpBRGr8WcbQSryz/ZWuiVO++4y3xrSjBDzjqPIFd6ML4+nIAySeNuEOvRngATvtgOAWG8wuX0MmU2pbzFVwdkmVuBfnA3/aGedxEPWjZaZC6MEDuxBLLec1ocdgnep5ncSQcp6PhBQC8cFKRdAI0EVFXfqkkWesgxDLNV373FTiKG+PniFMYaEG6Kyv+rIh1Xyp/RwZgHRhkhbSNrxMpBLyZkX61IuDG/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBk7OCKPYiHlbX8vxPSL65WcpDp5Iko8qjSrtFW4TpE=;
 b=PbEcBQY5P0NBnbEZpF9kWx6XRzb7VxlsvzIFgrD3pqOX383utqUhV+RUDttXhnPHLhkKuqAGM8tgWIpxYLupJWX+2Yi35MUjCf6cYb/vYu9+nrkpNy+aN/9DCPXBE6JsPm5lEPJVaVFxShiq2ubIRAoCA8ajOBuqwJhbce1F+9k=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3048.eurprd05.prod.outlook.com (10.172.250.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 14:55:25 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:55:25 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next mlxsw v2 10/10] selftests: qdiscs: Add test coverage
 for ETS Qdisc
Thread-Topic: [PATCH net-next mlxsw v2 10/10] selftests: qdiscs: Add test
 coverage for ETS Qdisc
Thread-Index: AQHVtbMtcInsAQycm0mWCEFrYdc0yw==
Date:   Wed, 18 Dec 2019 14:55:24 +0000
Message-ID: <d052efd1bc49fc20d7c4db365c62777b15b8ed43.1576679651.git.petrm@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
In-Reply-To: <cover.1576679650.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR2P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::19) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2b45fa8f-b6fe-4ef7-2f3c-08d783ca5009
x-ms-traffictypediagnostic: DB6PR0502MB3048:|DB6PR0502MB3048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB304851C5BC47175CC2D3279DDB530@DB6PR0502MB3048.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(2906002)(478600001)(6512007)(8936002)(81166006)(4326008)(316002)(8676002)(71200400001)(26005)(186003)(81156014)(86362001)(2616005)(6916009)(66946007)(66446008)(64756008)(66556008)(66476007)(30864003)(36756003)(6486002)(5660300002)(54906003)(52116002)(6506007)(559001)(579004)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3048;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 49oXsMYp/Cty7OhGEZJEwud1C69zq+i8GlIkzjmAROlDzmPwDcW07A7Rnj+BgTdyvmR9yv6eZfJusfP3O8U0Yti8yuMnehjgMqZLk95ErwwKiF7bKnrajAe/AR1jyhgdbrQQHSJ1DDk1lPUq654rEBQtxhYCC+OR3Ng4224WxpT8EfvFzJJH637AHs3VtzAdu1hpA4aNK2L6ik5fCeX9Dn7XFQDvjx7OmhJW/yKNdK36lEGQCh3UO8XB2b50UXzo3bSNZ5yP65kL/mq2QVbesIh/UiSNVhjIRDE4w/xvGNKyb2Wi9udsB/uSbr9U2H9ixDJaE1nD4icnwLCsJJbrs4V0Q8rJ9gvSBpvixbWVQIyLiRH6ft6c/V0JR2i5AA/ey6gGjk55sqNir4mgK+IGURWhtJIjKQDUKokD90JCy6e6o2myxoiTFUslPwVEM6mQRD/2JMHj00fLEwtgYr9D+uvd4tG054cgMrVK6iSKBFk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b45fa8f-b6fe-4ef7-2f3c-08d783ca5009
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:55:24.9854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BI/6Rf2w2/bHblAaYNCq8/CQ1pDvAtowsXDbXYyFPFte46u9kfpBMjHE1uewbP+lc6CJae3W33KFfoDLXsI+pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3048
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

