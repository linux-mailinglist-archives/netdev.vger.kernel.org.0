Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74DBA57B4F
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 07:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfF0FZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 01:25:27 -0400
Received: from mail-eopbgr40049.outbound.protection.outlook.com ([40.107.4.49]:39916
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbfF0FZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 01:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANgj6x15z107NP9YcbEeiksGj3vHr5dIwfNeRnmNv8k=;
 b=Yo5420pnLn7lDvbBOjbuAfnHlZMaas55eWC0IMV/ii4ewNFGmaRXJs5BDJiyG6nTQM8R6nOvN0l+3wBUc4J2viKP+Y/yr8xMxmzncoq012edwk3CuZl7gB1jKE/PWdqI4/UKpIYIuPTSxI5STMl7+md8Ddw4X7QiOh77+3E17K8=
Received: from AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) by
 AM4PR0501MB2642.eurprd05.prod.outlook.com (10.172.215.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.17; Thu, 27 Jun 2019 05:25:23 +0000
Received: from AM4PR0501MB2257.eurprd05.prod.outlook.com
 ([fe80::4d19:2bbc:edde:4baf]) by AM4PR0501MB2257.eurprd05.prod.outlook.com
 ([fe80::4d19:2bbc:edde:4baf%7]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 05:25:23 +0000
From:   Yamin Friedman <yaminf@mellanox.com>
To:     Sagi Grimberg <sagi@grimberg.me>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [for-next V2 08/10] linux/dim: Implement rdma_dim
Thread-Topic: [for-next V2 08/10] linux/dim: Implement rdma_dim
Thread-Index: AQHVK5im0LXsYlpEekKv/QTDguotP6as7A0AgAIOHIA=
Date:   Thu, 27 Jun 2019 05:25:23 +0000
Message-ID: <54f580a7-e94a-04b9-1472-5c543ad03f57@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-9-saeedm@mellanox.com>
 <bfa2159e-1576-6b3c-c85b-ee98bd4f9a47@grimberg.me>
In-Reply-To: <bfa2159e-1576-6b3c-c85b-ee98bd4f9a47@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR08CA0020.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::32) To AM4PR0501MB2257.eurprd05.prod.outlook.com
 (2603:10a6:200:50::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yaminf@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7237cdb-5de3-426b-4370-08d6fabfda7f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2642;
x-ms-traffictypediagnostic: AM4PR0501MB2642:
x-microsoft-antispam-prvs: <AM4PR0501MB2642F85A292F9958F4FF9F3AB1FD0@AM4PR0501MB2642.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(39860400002)(346002)(366004)(199004)(189003)(31686004)(186003)(14454004)(4326008)(110136005)(478600001)(25786009)(7736002)(107886003)(26005)(11346002)(54906003)(66556008)(446003)(229853002)(6116002)(2616005)(53936002)(3846002)(66946007)(68736007)(64756008)(66476007)(66446008)(316002)(73956011)(256004)(8676002)(71190400001)(71200400001)(52116002)(81156014)(81166006)(31696002)(86362001)(2906002)(99286004)(305945005)(386003)(53546011)(66066001)(6506007)(6512007)(36756003)(486006)(102836004)(6486002)(476003)(6636002)(6246003)(5660300002)(76176011)(8936002)(4744005)(14444005)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2642;H:AM4PR0501MB2257.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: c/XG2ToumpI/+XQezTl3fMOZg23JQ9aQ1godmf+lndXd/6La0C33or/vbcbjORyeuiakIpDrYxqN0GDYxHLfXTt0AvfHnAX8feukwe7Bps07Q6EDHZ2FwOxryXyuHE/REBK8Mijy8uQwDseej3rtHx1n4maDRA8adxTX818TyRmjMu7IAk4VRbnDvkNWOnn12bXJhH/tst1SRysY3rcdxODOHlEBFrMnV7a/PEOjqDEIjsnmGY7Z/MBydv1qd86AQkwDUi0e76Sot01ep8vTjGdR2VFiffgQ2xDUZNOeaGL6ipoHdQgaHX2gkJdybUUb8zqxhYbfpmTWaP1QmZfP0Qar0OXL8gAsSUZPwYpdX+7td6+WbYiTMd14xdqsxFhOwyKvGo30kRbbWbCycSZYtyTJleszFhDIzMhcjiWNg1E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B81E7DD7FB8B8E4C8FB9BBBBB95D9EFE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7237cdb-5de3-426b-4370-08d6fabfda7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 05:25:23.4958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yaminf@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2642
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzI2LzIwMTkgMTowMiBBTSwgU2FnaSBHcmltYmVyZyB3cm90ZToNCj4NCj4+ICt2b2lk
IHJkbWFfZGltKHN0cnVjdCBkaW0gKmRpbSwgdTY0IGNvbXBsZXRpb25zKQ0KPj4gK3sNCj4+ICvC
oMKgwqAgc3RydWN0IGRpbV9zYW1wbGUgKmN1cnJfc2FtcGxlID0gJmRpbS0+bWVhc3VyaW5nX3Nh
bXBsZTsNCj4+ICvCoMKgwqAgc3RydWN0IGRpbV9zdGF0cyBjdXJyX3N0YXRzOw0KPj4gK8KgwqDC
oCB1MzIgbmV2ZW50czsNCj4+ICsNCj4+ICvCoMKgwqAgZGltX3VwZGF0ZV9zYW1wbGVfd2l0aF9j
b21wcyhjdXJyX3NhbXBsZS0+ZXZlbnRfY3RyICsgMSwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGN1cnJfc2FtcGxlLT5wa3RfY3RyLA0KPj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3Vycl9zYW1wbGUtPmJ5dGVfY3RyLA0K
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3Vycl9zYW1wbGUt
PmNvbXBfY3RyICsgY29tcGxldGlvbnMsDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAmZGltLT5tZWFzdXJpbmdfc2FtcGxlKTsNCj4NCj4gSWYgdGhpcyBpcyB0
aGUgb25seSBjYWxsZXIsIHdoeSBhZGQgcGt0X2N0ciBhbmQgYnl0ZV9jdHIgYXQgYWxsPw0KDQoN
CldlIHdhbnRlZCB0byBrZWVwIHRoZSBBUEkgZ2VuZXJhbCBlbm91Z2ggdGhhdCBpZiBzb21lb25l
IHdhbnRzIHRvIA0KaW1wbGVtZW50IGEgZGlmZmVyZW50IGFsZ29yaXRobSB1c2luZyB0aGUgZGlt
IGxpYnJhcnkgdGhleSB3aWxsIGJlIGFibGUgDQp0byB1c2UgYWxsIHRoZSBwb3NzaWJsZSBzdGF0
aXN0aWNzLiBJIGFncmVlIHRob3VnaCB0aGF0IGluIHRoZSByZG1hX2RpbSANCmZ1bmN0aW9uIHRo
ZXJlIGlzIG5vIHBvaW50IGluIG1ha2luZyBpdCBzZWVtIGxpa2UgdGhleSBhcmUgcmVsZXZhbnQg
DQpwYXJhbWV0ZXJzLg0KDQo=
