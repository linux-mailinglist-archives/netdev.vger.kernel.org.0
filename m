Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDEC239804
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731289AbfFGVrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:47:43 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:37518
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730116AbfFGVrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 17:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HS4TMhk802J1i62j9ImG3r0z2WtnZ241ndDxHzU4Mdw=;
 b=jlSCatr6LAUDbYMOITCXKPh1xX0IZt1iJaS0ZphGxlm8GZamzn2Vi+Clg9eEr3G4mrPSNE1GpTqxXmzb5bpwA6Tq1yW3S65caKrGBUvA/eIDGaYY3BHOjFfZgJvoFa9sOSgscDVoBOOBBwqdPwaX0wVIYfg/btzskDTxs1ESRps=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6139.eurprd05.prod.outlook.com (20.179.12.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Fri, 7 Jun 2019 21:47:37 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 21:47:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/7] net/mlx5: Update pci error handler entries and command
 translation
Thread-Topic: [net 1/7] net/mlx5: Update pci error handler entries and command
 translation
Thread-Index: AQHVHXqfpEp8W7HxSk+XJOgOe51rVg==
Date:   Fri, 7 Jun 2019 21:47:37 +0000
Message-ID: <20190607214716.16316-2-saeedm@mellanox.com>
References: <20190607214716.16316-1-saeedm@mellanox.com>
In-Reply-To: <20190607214716.16316-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ad37c4e-6eb9-41aa-d1fa-08d6eb91c196
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6139;
x-ms-traffictypediagnostic: DB8PR05MB6139:
x-microsoft-antispam-prvs: <DB8PR05MB6139475D9D47DC38204395C3BE100@DB8PR05MB6139.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(71200400001)(81166006)(71190400001)(8676002)(25786009)(52116002)(64756008)(66446008)(66556008)(66476007)(8936002)(76176011)(86362001)(99286004)(73956011)(66946007)(66066001)(50226002)(54906003)(6916009)(6512007)(81156014)(7736002)(316002)(486006)(256004)(102836004)(2906002)(305945005)(6116002)(53936002)(3846002)(4326008)(107886003)(6436002)(36756003)(476003)(2616005)(11346002)(6486002)(68736007)(446003)(6506007)(386003)(1076003)(186003)(26005)(14454004)(5660300002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6139;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q9beQ/CrconbCIXczmIq6ohGUYBJXAN0HFbYyeLCodF4Uxo0HmkPas4NcL6Vpw/GGZFf3f44wCchiQx9arlezx52XDn7t3xbKw3n93FHZaghG+uQ7NWIMvJ5yflvp0drZ/CfeHdRtNBMmgAM6qd3LN3k+Mytf/fdEiEhYNBw6x+kyHyJq5Yw7wFws3GKGew8NYbuJQ30sf3Muk01iu8JQk6NPG1F5D+ZGNCXFnb7e+jid0A2MEtA6jqvcEYSliiauAo1+Nd6/NsmZFnvxnt2d01UHSi5Mo1tYsXSXkQRA08f/xzn8nO6anTFgJdT/x0Fyi2VO4hy8FbiwzXOPfmh+agtBAM4O61GziWoCp0tNf+0yGLbd5Zg4HWoinFETykF29VuFejK7+VSqWa37Z7dJuLV/09Mkty+/Ha/kzPniBY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad37c4e-6eb9-41aa-d1fa-08d6eb91c196
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 21:47:37.2644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRWR3YXJkIFNyb3VqaSA8ZWR3YXJkc0BtZWxsYW5veC5jb20+DQoNCkFkZCBtaXNzaW5n
IGVudHJpZXMgZm9yIGNyZWF0ZS9kZXN0cm95IFVDVFggYW5kIFVNRU0gY29tbWFuZHMuDQpUaGlz
IGNvdWxkIGdldCB1cyB3cm9uZyAidW5rbm93biBGVyBjb21tYW5kIiBlcnJvciBpbiBmbG93cw0K
d2hlcmUgd2UgdW5iaW5kIHRoZSBkZXZpY2Ugb3IgcmVzZXQgdGhlIGRyaXZlci4NCg0KQWxzbyB0
aGUgdHJhbnNsYXRpb24gb2YgdGhlc2UgY29tbWFuZHMgZnJvbSBvcGNvZGVzIHRvIHN0cmluZw0K
d2FzIG1pc3NpbmcuDQoNCkZpeGVzOiA2ZTM3MjJiYWFjMDQgKCJJQi9tbHg1OiBVc2UgdGhlIGNv
cnJlY3QgY29tbWFuZHMgZm9yIFVNRU0gYW5kIFVDVFggYWxsb2NhdGlvbiIpDQpTaWduZWQtb2Zm
LWJ5OiBFZHdhcmQgU3JvdWppIDxlZHdhcmRzQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6
IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2NtZC5jIHwgOCArKysrKysrKw0KIDEgZmlsZSBj
aGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9jbWQuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9jbWQuYw0KaW5kZXggZDJhYjhjZDhhZDlmLi5lOTQ2ODZjNDIwMDAgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvY21kLmMN
CisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9jbWQuYw0KQEAg
LTQ0MSw2ICs0NDEsMTAgQEAgc3RhdGljIGludCBtbHg1X2ludGVybmFsX2Vycl9yZXRfdmFsdWUo
c3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgdTE2IG9wLA0KIAljYXNlIE1MWDVfQ01EX09QX0NS
RUFURV9HRU5FUkFMX09CSkVDVDoNCiAJY2FzZSBNTFg1X0NNRF9PUF9NT0RJRllfR0VORVJBTF9P
QkpFQ1Q6DQogCWNhc2UgTUxYNV9DTURfT1BfUVVFUllfR0VORVJBTF9PQkpFQ1Q6DQorCWNhc2Ug
TUxYNV9DTURfT1BfQ1JFQVRFX1VDVFg6DQorCWNhc2UgTUxYNV9DTURfT1BfREVTVFJPWV9VQ1RY
Og0KKwljYXNlIE1MWDVfQ01EX09QX0NSRUFURV9VTUVNOg0KKwljYXNlIE1MWDVfQ01EX09QX0RF
U1RST1lfVU1FTToNCiAJY2FzZSBNTFg1X0NNRF9PUF9BTExPQ19NRU1JQzoNCiAJCSpzdGF0dXMg
PSBNTFg1X0RSSVZFUl9TVEFUVVNfQUJPUlRFRDsNCiAJCSpzeW5kID0gTUxYNV9EUklWRVJfU1lO
RDsNCkBAIC02MjksNiArNjMzLDEwIEBAIGNvbnN0IGNoYXIgKm1seDVfY29tbWFuZF9zdHIoaW50
IGNvbW1hbmQpDQogCU1MWDVfQ09NTUFORF9TVFJfQ0FTRShBTExPQ19NRU1JQyk7DQogCU1MWDVf
Q09NTUFORF9TVFJfQ0FTRShERUFMTE9DX01FTUlDKTsNCiAJTUxYNV9DT01NQU5EX1NUUl9DQVNF
KFFVRVJZX0hPU1RfUEFSQU1TKTsNCisJTUxYNV9DT01NQU5EX1NUUl9DQVNFKENSRUFURV9VQ1RY
KTsNCisJTUxYNV9DT01NQU5EX1NUUl9DQVNFKERFU1RST1lfVUNUWCk7DQorCU1MWDVfQ09NTUFO
RF9TVFJfQ0FTRShDUkVBVEVfVU1FTSk7DQorCU1MWDVfQ09NTUFORF9TVFJfQ0FTRShERVNUUk9Z
X1VNRU0pOw0KIAlkZWZhdWx0OiByZXR1cm4gInVua25vd24gY29tbWFuZCBvcGNvZGUiOw0KIAl9
DQogfQ0KLS0gDQoyLjIxLjANCg0K
