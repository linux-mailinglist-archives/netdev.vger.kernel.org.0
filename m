Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D5A107527
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 16:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKVPrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 10:47:25 -0500
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:31815
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbfKVPrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 10:47:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mY97woXDNPc3o25ZX4lrrJdqVcbv89pL05Te+zvdbXb9CTIp/aqDJx+T18eoLH+xJ9ehsKUyyJzK6dHxiZYlQUjzfXeE2ISGO/NDXALEdBJINPWQc+XYnJP4J8QTwELW/geJRNWvnjFyJYbkPDgSTb0V+vKOkM4xn6ompYXmQBRCoD5YKfw4bMrs7c18p2VN94QWUFw/qtmph3QupQ6dOxderWG4IPDgwch+RYTY4AARoHjI6iXYRu0DwNY3V5oq1zTaqlRSlKts/bdUkOH7iocNd6NGlQ1SRnMWSCG/CYg5mhoPhS1OItv+U0M9jI9zC265fwwt/14Ka+cga9GNRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vG+X8LG8qm+TN95T0srcfnXs+3VVQ9hK4arcrGiLnvI=;
 b=EYvZLN3BO/HpBePktKGr3Sc441jwFXOP1YTvQjeFUHKljpucnnLaDR+G9xEbmtM1GvI58fRS/PZY99gzzAkjQrCJ98bju20sDJbcin5+tI3nJEnsC56vd4TOAqsA4gWivFmr4Y/6pUicIsXjdatWsFB//+YiRNcU/LUXK+67NZJAGb2jAzdFTXg91E6EBuKxzydtWERyPHJe4krQdRXaY8Y+fqt84NRNo8liJ84BpTjIFV6DFsnQOl3hPSa+oC3NkgRIq3I2WxPDMiVffpNFq48aunHhHbdzk+RpaBSoU6JsA6fy3I9RBnJfF82f0BRQ0H1xriCh00E8TLhIKmbihg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vG+X8LG8qm+TN95T0srcfnXs+3VVQ9hK4arcrGiLnvI=;
 b=MAp8sIg0VvUoNX5LISb7QkDM7oFn2lDFnFxrj4FohyKA0+6eLTDNht8uL+BPjaH9+MnoXkBgIXaUxDoMtyDUg5L7koWilqvSI0LIwTgYS+QP/KPzSgwY4fpPk1a9BsGYTyQ6x30cS3/SwNPfsyPxKiHAW5FhzD3V/CYlGDez1R0=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2888.eurprd05.prod.outlook.com (10.172.249.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 15:47:21 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 15:47:21 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next] net: flow_dissector: Wrap unionized VLAN fields in a
 struct
Thread-Topic: [PATCH net-next] net: flow_dissector: Wrap unionized VLAN fields
 in a struct
Thread-Index: AQHVoUwgFCTDjBPLWEGfQhK2OLglew==
Date:   Fri, 22 Nov 2019 15:47:21 +0000
Message-ID: <c2be1d959f0d710dbbb99392eeb190a81952307a.1574437486.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0283.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::31) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01be6f8a-ad05-4be0-d805-08d76f6342df
x-ms-traffictypediagnostic: DB6PR0502MB2888:|DB6PR0502MB2888:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2888C2DB4A5F0358CF6FA12CDB490@DB6PR0502MB2888.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(189003)(199004)(2616005)(36756003)(2351001)(71200400001)(6116002)(71190400001)(66556008)(25786009)(66476007)(3846002)(66066001)(118296001)(2906002)(14454004)(26005)(81166006)(8676002)(8936002)(50226002)(64756008)(66446008)(66946007)(1730700003)(81156014)(7736002)(2501003)(305945005)(4326008)(54906003)(478600001)(86362001)(6436002)(256004)(6512007)(5660300002)(99286004)(316002)(6506007)(6916009)(386003)(52116002)(186003)(6486002)(5640700003)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2888;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BDvxU/qVMcmw70+XFWZfcinB6p9FKxnPosAaDCC79AkEuyFfehyFTxyCQ96VOE8WUjUvhn7sLox7qB6z9/1yI6JZ17O5ZnM1T99YAStOgndtSk+wiB8GNieG2mTG/RD2DGB6ZQ/HfhjuLzEiof+QY/PpPVQT1bGcIU7SKMAvkxyl+q0LelV+P03GskK0CoCabLY2sduaVRP0d3pO2bNS9cTiVctJdjcjNacMkR4+pA8yAAhEyNnRqmkvY+/fZqxGsXppeAXiisZfrnEhBwuTdWC91GGehlsuoX8NCMJsFNfsgxppdb3l2goEXyMpKjyhcI3Cf+HNi4f7003LO44f3mxDbG5igo5W81uLRP0IIi3Ce6gi29OWnN68Cd33i7Cjbrt8/mBw0A0Zsnd2VlbT/uaHNf1lcHpcHIrwdR7BvEbfuhrsM60QTKynsoAGEKxf
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01be6f8a-ad05-4be0-d805-08d76f6342df
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 15:47:21.2975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ShAZln2UuuoQc3U1KKUacLlnsbohBxJqxzgsiuD8iRcX+rGDm0fUU/CUR+g25KQAt3EXt/0t+1RXJktdu1Qk3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2888
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit a82055af5959 ("netfilter: nft_payload: add VLAN offload
support"), VLAN fields in struct flow_dissector_key_vlan were unionized
with the intention of introducing another field that covered the whole TCI
header. However without a wrapping struct the subfields end up sharing the
same bits. As a result, "tc filter add ... flower vlan_id 14" specifies not
only vlan_id, but also vlan_priority.

Fix by wrapping the individual VLAN fields in a struct.

Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/net/flow_dissector.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index f06b0239c32b..b8c20e9f343e 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -49,9 +49,11 @@ struct flow_dissector_key_tags {
=20
 struct flow_dissector_key_vlan {
 	union {
-		u16	vlan_id:12,
-			vlan_dei:1,
-			vlan_priority:3;
+		struct {
+			u16	vlan_id:12,
+				vlan_dei:1,
+				vlan_priority:3;
+		};
 		__be16	vlan_tci;
 	};
 	__be16	vlan_tpid;
--=20
2.20.1

