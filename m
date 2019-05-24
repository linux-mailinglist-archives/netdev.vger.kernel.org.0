Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8012A124
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404417AbfEXW11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:27 -0400
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:32916
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404396AbfEXW10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 18:27:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOLpKjZE9uIfFJBrOYuBt7GHE6Gfuiuf5NMC/gM99Bw=;
 b=I7KvdgPagrS+JKj/pDzp0Hi2KJ77QxS3vbsGBdbSfxystUd+WJyzQr0wGpOvwSw+Y30FuG/bk9VLuFjUGtu7pg0Jetl0azI68zm/jTZKn3xonjfwGNtGZYnN0YruZyybQPlMWVFm/m+WsLcoxosWSw6lx/8onOMmm/PiOt9YqBQ=
Received: from VI1PR05MB3328.eurprd05.prod.outlook.com (10.170.238.141) by
 VI1PR05MB5039.eurprd05.prod.outlook.com (20.177.52.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 22:27:22 +0000
Received: from VI1PR05MB3328.eurprd05.prod.outlook.com
 ([fe80::d054:c1d5:5865:9092]) by VI1PR05MB3328.eurprd05.prod.outlook.com
 ([fe80::d054:c1d5:5865:9092%4]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 22:27:22 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH RFC 0/2] Support MPLS features in bonding and vlan net devices
Thread-Topic: [PATCH RFC 0/2] Support MPLS features in bonding and vlan net
 devices
Thread-Index: AQHVEn/b/MCTyIo3zE2HQ+8JdljlCw==
Date:   Fri, 24 May 2019 22:27:22 +0000
Message-ID: <1558736809-23258-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.226.120.58]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: LO2P265CA0457.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::13) To VI1PR05MB3328.eurprd05.prod.outlook.com
 (2603:10a6:802:1d::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 064190a0-4500-4c2c-f5ca-08d6e096fd62
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600147)(711020)(4605104)(1401326)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5039;
x-ms-traffictypediagnostic: VI1PR05MB5039:
x-microsoft-antispam-prvs: <VI1PR05MB50397E842033379D0332034DBA020@VI1PR05MB5039.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(366004)(396003)(346002)(199004)(189003)(66556008)(66946007)(66476007)(305945005)(4326008)(64756008)(107886003)(66446008)(2501003)(25786009)(4720700003)(5660300002)(86362001)(81156014)(478600001)(8676002)(81166006)(386003)(102836004)(1730700003)(186003)(2906002)(26005)(50226002)(316002)(6506007)(14454004)(8936002)(256004)(6486002)(6436002)(476003)(36756003)(53936002)(7736002)(2616005)(71190400001)(73956011)(5640700003)(71200400001)(99286004)(3846002)(68736007)(4744005)(6512007)(6116002)(6916009)(2351001)(486006)(66066001)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5039;H:VI1PR05MB3328.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mfQBJ5Uwtrg0u6vCMXMF6RNo1KzTg3Jo5q436HLUCJGQ1NooYSB3/WwIzH8IuaJ9poOAJnkfILGjm7PxUHC2Cu5Y6D7BuLnnY8QAw78Nc6AgIqMGflxLR0L8hRHlTC3D/NxzTKxXhjfNAg7OxoemVFFc85/FLtnuRWjElfkP3mxAfW/0ehRmN58g0B7eR6eef+YbyUz0AK8s8nXAi6jqfN+89/Z7eZFu6b2TGE0j/YK/N85asXaDrs64oyYse8qn6msyb8luN0iwCq6ZKLRkv1XB/8jOyCdjopkd8bTmw5sTTnR/z7fqO3SV3SYk+BlyPeVC4EMblBefsOA2P24Sgdu8SS/J9euW8PNYqUsRQt48267SsqdBGTgqv3Zv1uhnBVyNs3GIsep+q9L/QRUQ0RC7fNVdA7Tl6AY8eSpllW0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 064190a0-4500-4c2c-f5ca-08d6e096fd62
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 22:27:22.3439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lariel@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TmV0ZGV2aWNlIEhXIE1QTFMgZmVhdHVyZXMgYXJlIG5vdCBwYXNzZWQgZnJvbSBkZXZpY2UgZHJp
dmVyJ3MgbmV0ZGV2aWNlIHRvDQp1cHBlciBuZXRkZXZpY2UsIHNwZWNpZmljYWxseSBWTEFOIGFu
ZCBib25kaW5nIG5ldGRldmljZSB3aGljaCBhcmUgY3JlYXRlZA0KYnkgdGhlIGtlcm5lbCB3aGVu
IG5lZWRlZC4NCg0KVGhpcyBwcmV2ZW50cyBlbmFibGVtZW50IGFuZCB1c2FnZSBvZiBIVyBvZmZs
b2Fkcywgc3VjaCBhcyBUU08gYW5kIGNoZWNrc3VtbWluZw0KZm9yIE1QTFMgdGFnZ2VkIHRyYWZm
aWMgd2hlbiBydW5uaW5nIHZpYSBWTEFOIG9yIGJvbmRpbmcgaW50ZXJmYWNlLg0KDQpUaGUgcGF0
Y2hlcyBpbnRyb2R1Y2UgY2hhbmdlcyB0byB0aGUgaW5pdGlhbGl6YXRpb24gc3RlcHMgb2YgdGhl
IFZMQU4gYW5kIGJvbmRpbmcNCm5ldGRldmljZXMgdG8gaW5oZXJpdCB0aGUgTVBMUyBmZWF0dXJl
cyBmcm9tIGxvd2VyIG5ldGRldmljZXMgdG8gYWxsb3cgdGhlIEhXDQpvZmZsb2Fkcy4NCg0KQXJp
ZWwgTGV2a292aWNoICgyKToNCiAgbmV0OiBib25kaW5nOiBJbmhlcml0IE1QTFMgZmVhdHVyZXMg
ZnJvbSBzbGF2ZSBkZXZpY2VzDQogIG5ldDogdmxhbjogSW5oZXJpdCBNUExTIGZlYXR1cmVzIGZy
b20gcGFyZW50IGRldmljZQ0KDQogZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX21haW4uYyB8IDEx
ICsrKysrKysrKysrDQogbmV0LzgwMjFxL3ZsYW5fZGV2LmMgICAgICAgICAgICB8ICAxICsNCiAy
IGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCg0KLS0gDQoxLjguMy4xDQoNCg==
