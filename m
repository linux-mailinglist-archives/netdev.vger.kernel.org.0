Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E85513C008
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbgAOMN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:27 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:31808
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730258AbgAOMNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWBFUdCyLnESNWUeS+8Lgqfr3ZJQprfDAJDwyvHweFr6IUEn7/8M7aQ/FrLepn6pybSpHrsB4Z86O40DBF2+NqKw1b2zbckb5MfsDxDf/9RetLNVEkEr7pnqVb7spcKRdypH7dZvZ/B4e+WV0JKB5vIg9cmFRQCwx0RZz1xRs4ZhiDQYwlMIMa/APcnLyjysdGtrDuYIWhzWAWo4orvMmP9Vxw6xncjeRQibzvTO6aloLusEZVhFvBMxP1LvEROjtchJZh5zr94eJQZ0VGT2EWsF6vqN+6AVh4fLhviarE0HD9LNe7LLcI/i42w/e2mesAID4q/Mj4MwWzcuwy331w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7WXVyk7UNsnby0BTFvK7nM6kwOYLUjSDsqtkvRlZTw=;
 b=TGssdAEQo23RANr7+tiEleet3Bc9LEWRQp8whz2jY2P23CrXMNP4xIlKGC0ywvpMGktzai9V3zHyezJ9wxUjuKjirMBUUuWA07oYItqoKr/4lLTme0VE0ZGu4wf4xO2YS/Xo7tgSnqBB2Wxx0iSn848GePdTEPjlHwUHd55of56IBM2UGE9SP+yScwHJZc1FJqa3xcPXxv+BZIlk4+fGkE87rM4pQtLAH59oXyIUagkM0ejyRBUVsbXx4j1RCfxXzrPD75nzzJLqAyQ9ZRJsIsjqo9lwXNmn6ulUad1+BlUdXtRh0iTKlC+trcg8O/91BhhHIhcw+13ImBW4a+h1Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7WXVyk7UNsnby0BTFvK7nM6kwOYLUjSDsqtkvRlZTw=;
 b=kPh1JrRa9T12D7tW4JQNNhIIy/1GcXZqBvUQWNJYPAqLyrrlpwMQN1NZEQI9/9fFvxUGNrwhCJp60l9da1XfeLeIiOtrBOAJOxLdsRbVvs4mNJq8Mf2BPuNQR6RqBv3ZxO08ys96KiGWOJAYR/ZmJDQVV92apv0SGwAFJnChZzE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:13:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:20 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:49 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 31/65] staging: wfx: simplify hif_set_uc_mc_bc_condition()
Thread-Topic: [PATCH 31/65] staging: wfx: simplify
 hif_set_uc_mc_bc_condition()
Thread-Index: AQHVy50bKVfQ4tTy5ESA2ASoIlwUzA==
Date:   Wed, 15 Jan 2020 12:12:50 +0000
Message-ID: <20200115121041.10863-32-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cda5b2c8-c044-49a1-d0d0-08d799b43dae
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40961EED29C91FE1BD563EC293370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(6666004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: upOqF/cCEKulQBTk60h6Iy9lJw5rN1HhIyVOkVgi5q33pE/4C0PUHzMBQcTlwHgVQWDSO4HCuuC/a7MkMD77bNqsxVmhL7N3LOiWjYS9vx5ygJKVYJrAviSwL2YwLDo8cqi/R/gTYtD+ItB5XXIfKWhtdjAE8iKGesf3+Ln+aQFjed4wKsxe67GzWCKRc+oFd3s3OUamCz1RuRblnbUEQhIuMuSI3ioSMdT90K+SXuwU9SednRgFCf8/gisV6UyYpZqJGXrLP/Sz+O9aLMSl0BDejuiEFaS2rJrG5VN5IDM92qjx7D9F8CBpiCqdH7MeHZ0lS9bjTFiUDBkNl1MRSiEjUPqVQd//wWAW+6h5eQcuRbVqWoUalHrLExpIp2ISIAudXzoiD+tyA2v7l0LeNgIKnRjaYclFglv5upCsoQLqDOmO6PRGWbVx81PaoAYI
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EC5639BD602334A9C8D44B4105A1518@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cda5b2c8-c044-49a1-d0d0-08d799b43dae
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:50.5903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VzBYYqxw/SD8ZBjY7dHGpZC9b7Cg686ZSUhl4BKVpfFzFL3FD0vIgtG3cJd16ruRbCKLWI7ssFVVqNz7M+jK7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX3VjX21jX2JjX2RhdGFfZnJhbWVfY29uZGl0aW9uIGNvbWUgZnJv
bSBoYXJkd2FyZQpBUEkuIEl0IGlzIG5vdCBpbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1
cHBlciBsYXllcnMgb2YgdGhlIGRyaXZlci4KCkluIGFkZCwgY3VycmVudCBjb2RlIGZvciBoaWZf
c2V0X3VjX21jX2JjX2NvbmRpdGlvbigpIGlzIHRvbyBkdW1iLiBJdApzaG91bGQgcGFjayBkYXRh
IHdpdGggaGFyZHdhcmUgcmVwcmVzZW50YXRpb24gaW5zdGVhZCBvZiBsZWF2aW5nIGFsbAp3b3Jr
IHRvIHRoZSBjYWxsZXIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21l
LnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWli
LmggfCAxNCArKysrKysrKysrKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgICAg
fCAgNiArLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCmluZGV4IGVlYzZmNDE1N2U2MC4uNGQxNzFl
NmNmYzlhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaApAQCAtMjQ2LDEyICsyNDYsMjAgQEAg
c3RhdGljIGlubGluZSBpbnQgaGlmX3NldF9tYWNfYWRkcl9jb25kaXRpb24oc3RydWN0IHdmeF92
aWYgKnd2aWYsCiAJCQkgICAgIGFyZywgc2l6ZW9mKCphcmcpKTsKIH0KIAotc3RhdGljIGlubGlu
ZSBpbnQgaGlmX3NldF91Y19tY19iY19jb25kaXRpb24oc3RydWN0IHdmeF92aWYgKnd2aWYsCi0J
CQkJCSAgICAgc3RydWN0IGhpZl9taWJfdWNfbWNfYmNfZGF0YV9mcmFtZV9jb25kaXRpb24gKmFy
ZykKKy8vIEZJWE1FOiB1c2UgYSBiaXRmaWVsZCBpbnN0ZWFkIG9mIDMgYm9vbGVhbiB2YWx1ZXMK
K3N0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfdWNfbWNfYmNfY29uZGl0aW9uKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBpbnQgaWR4LAorCQkJCQkgICAgIGJvb2wgdW5pYywgYm9vbCBtdWx0aWMsIGJv
b2wgYnJvYWRjKQogeworCXN0cnVjdCBoaWZfbWliX3VjX21jX2JjX2RhdGFfZnJhbWVfY29uZGl0
aW9uIHZhbCA9IHsKKwkJLmNvbmRpdGlvbl9pZHggPSBpZHgsCisJCS5wYXJhbS5iaXRzLnR5cGVf
dW5pY2FzdCA9IHVuaWMsCisJCS5wYXJhbS5iaXRzLnR5cGVfbXVsdGljYXN0ID0gbXVsdGljLAor
CQkucGFyYW0uYml0cy50eXBlX2Jyb2FkY2FzdCA9IGJyb2FkYywKKwl9OworCiAJcmV0dXJuIGhp
Zl93cml0ZV9taWIod3ZpZi0+d2Rldiwgd3ZpZi0+aWQsCiAJCQkgICAgIEhJRl9NSUJfSURfVUNf
TUNfQkNfREFUQUZSQU1FX0NPTkRJVElPTiwKLQkJCSAgICAgYXJnLCBzaXplb2YoKmFyZykpOwor
CQkJICAgICAmdmFsLCBzaXplb2YodmFsKSk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9z
ZXRfY29uZmlnX2RhdGFfZmlsdGVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLApkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5k
ZXggOTAzMDY4MTg1OGJiLi43OTI4NTkyN2M3YmYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMTIwLDcgKzEy
MCw2IEBAIHN0YXRpYyBpbnQgd2Z4X3NldF9tY2FzdF9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2
aWYsCiAJc3RydWN0IGhpZl9taWJfY29uZmlnX2RhdGFfZmlsdGVyIGNvbmZpZyA9IHsgfTsKIAlz
dHJ1Y3QgaGlmX21pYl9zZXRfZGF0YV9maWx0ZXJpbmcgZmlsdGVyX2RhdGEgPSB7IH07CiAJc3Ry
dWN0IGhpZl9taWJfbWFjX2FkZHJfZGF0YV9mcmFtZV9jb25kaXRpb24gZmlsdGVyX2FkZHJfdmFs
ID0geyB9OwotCXN0cnVjdCBoaWZfbWliX3VjX21jX2JjX2RhdGFfZnJhbWVfY29uZGl0aW9uIGZp
bHRlcl9hZGRyX3R5cGUgPSB7IH07CiAKIAkvLyBUZW1wb3Jhcnkgd29ya2Fyb3VuZCBmb3IgZmls
dGVycwogCXJldHVybiBoaWZfc2V0X2RhdGFfZmlsdGVyaW5nKHd2aWYsICZmaWx0ZXJfZGF0YSk7
CkBAIC0xNDQsMTAgKzE0Myw3IEBAIHN0YXRpYyBpbnQgd2Z4X3NldF9tY2FzdF9maWx0ZXIoc3Ry
dWN0IHdmeF92aWYgKnd2aWYsCiAJfQogCiAJLy8gQWNjZXB0IHVuaWNhc3QgYW5kIGJyb2FkY2Fz
dAotCWZpbHRlcl9hZGRyX3R5cGUuY29uZGl0aW9uX2lkeCA9IDA7Ci0JZmlsdGVyX2FkZHJfdHlw
ZS5wYXJhbS5iaXRzLnR5cGVfdW5pY2FzdCA9IDE7Ci0JZmlsdGVyX2FkZHJfdHlwZS5wYXJhbS5i
aXRzLnR5cGVfYnJvYWRjYXN0ID0gMTsKLQlyZXQgPSBoaWZfc2V0X3VjX21jX2JjX2NvbmRpdGlv
bih3dmlmLCAmZmlsdGVyX2FkZHJfdHlwZSk7CisJcmV0ID0gaGlmX3NldF91Y19tY19iY19jb25k
aXRpb24od3ZpZiwgMCwgdHJ1ZSwgZmFsc2UsIHRydWUpOwogCWlmIChyZXQpCiAJCXJldHVybiBy
ZXQ7CiAKLS0gCjIuMjUuMAoK
