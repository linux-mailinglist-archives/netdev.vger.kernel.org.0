Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B98A2CDE
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 04:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfH3C3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 22:29:44 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:18114
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727270AbfH3C3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 22:29:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ig7s1o0io2FqgFW36rIWjzgUdON7NIUJGIF/rlzjzsakbs/TkpJiddR5vLUptKMVD6q/Xr+nypAHByYe3moMTvidMqhADEQwSxZVyEWoTx3CtmoNFM0cdRyG85BA5n+7N+OIyLhirPSMVxnH9JyjSr3zqwvuWaDhwuuq1IX7BGBV5ViFxOF//f8887Fj8i2rD411WrvnrM/wPPbpHI9qxviPKKEaToIwrR36BntdlWxcQ4x1QE7QkxKvNqrBfrqOURN6jnVV4GRgAUCUpczOiV0kbD79l3s/UfWlL58gS5Nl2UhHKG2LNY8gR6l0tXgQnJJUDeUkkL9iKdT/0H1xyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMo8cj6+r3d26mJ9PDaxpXMWAqbZW7vXrvf7a0xmyPE=;
 b=HMgbBsILezw/S0JBWUYVlIBwPHbbfqjZiaUFMt91wwfMRyUHbXvgjaZSL43bq05wvVFne3jlx+R6Q0ayoFbsRQqtLm0Mhzq8ea0K2htV6s1xxIjzp0zKAVhuqcfaZ4CenJm3hLQCAmYpUEdkw/ooHU/ByxkqM13dql2b1NDsoBoL+1XAOomWzvqn4FMEWzzasBDfUrqtVajROmeus0k8C8UBBQtZAKKBRLG9fpxaybo0dP9xg9YUVeKXgp6YyCCWFZzIBTd+DAkljUepgace92JSO9ORTo5A6/pCFa+4SJH0/a+rmcFr4gKgaRVYj2609yY5kJ3HZTjUzDli8hzosg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMo8cj6+r3d26mJ9PDaxpXMWAqbZW7vXrvf7a0xmyPE=;
 b=Vk9EQ5XKGkj6NK+OD8I9gf+m0BTChC4fznT0AvXe+CLG6wyGa7UjewiYObGfduflIpCif3HEU4uJaQhgp1FiFmKQqFwZ8CHe/GCQRn0+iZ6zXQT4YAhrdmYOtVHumOyZrAhW8+DsEHJ98p4SRZ7gIaYlLubo1MoIMiVnbE8q/P8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4484.eurprd05.prod.outlook.com (52.134.124.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Fri, 30 Aug 2019 02:27:57 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 02:27:57 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
Thread-Index: AQHVXluia2ak8fbBtkW+HkGgDQ+zpacSDVCAgADpXEA=
Date:   Fri, 30 Aug 2019 02:27:57 +0000
Message-ID: <AM0PR05MB48664658A79ECDB617A5F1A7D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190829111904.16042-1-parav@mellanox.com>
 <20190829111904.16042-2-parav@mellanox.com>
 <63e58577-f652-e021-2ff7-7e7403e38f9f@huawei.com>
In-Reply-To: <63e58577-f652-e021-2ff7-7e7403e38f9f@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4afea8c6-5dcf-4c37-0584-08d72cf1abdb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4484;
x-ms-traffictypediagnostic: AM0PR05MB4484:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB44846768C5444F786A019192D1BD0@AM0PR05MB4484.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(189003)(199004)(54534003)(13464003)(229853002)(76116006)(446003)(476003)(11346002)(14454004)(81166006)(5660300002)(305945005)(3846002)(33656002)(6116002)(9456002)(74316002)(2906002)(478600001)(486006)(2201001)(316002)(54906003)(110136005)(81156014)(66066001)(7736002)(8676002)(86362001)(53936002)(26005)(4326008)(2501003)(71190400001)(99286004)(7696005)(71200400001)(6246003)(6506007)(53546011)(55236004)(25786009)(6436002)(186003)(8936002)(52536014)(66946007)(64756008)(66446008)(66556008)(66476007)(256004)(14444005)(102836004)(76176011)(55016002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4484;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mVquW7fuzFEE785qZkq9Ogi4Nd1DE9VtFbzGdtOg2goe/FoGm3iN9KPV7Kp+lhx6DWeawqbGTDAN4uwuo1dE451+yxy1VEYEeh+k6N/j3e3NCHkpc4OkDuZAoffd1WhEXJdKf6xtC8ySMjVyjps7brqT4pum7gSKGoi9orNEceVJkBlopnxKPl1fJamnu9Dn/Y3WwhYjocLm3FLJSBUaZdJXdFS1F6n/0g4Xo6f6icrBZNZy4aobUHVa+YCj9UTSqNxy7Cvp+jD3jOQzDrkjNr5+xA2R1B7YjRN0XP9Cepr16Z5Mx8jmpPd55aCxMfX+mI08ic1rUhhMgagSl+wVxNwQtE0h105Qi1H77W00/AuNpW5v9C/ElBJWnCkm/3bxVxgCz2ZAk4CM5fS0Rm3gqhWoGtL5KY1LN1xauiLE61A=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4afea8c6-5dcf-4c37-0584-08d72cf1abdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 02:27:57.4205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0PtP9J8WjpQoF0CYWIak2IplPWowtDdlXw1rW4rFN5vk33LKV9P2q3v0JWThxTn9+xsr3kOKOtglcs8ETTa2eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4484
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWXVuc2hlbmcgTGluIDxs
aW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI5LCAyMDE5
IDU6NTcgUE0NCj4gVG86IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29tPjsgYWxleC53
aWxsaWFtc29uQHJlZGhhdC5jb207IEppcmkNCj4gUGlya28gPGppcmlAbWVsbGFub3guY29tPjsg
a3dhbmtoZWRlQG52aWRpYS5jb207IGNvaHVja0ByZWRoYXQuY29tOw0KPiBkYXZlbUBkYXZlbWxv
ZnQubmV0DQo+IENjOiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djIgMS82XSBtZGV2OiBJbnRyb2R1Y2Ugc2hhMSBiYXNlZCBtZGV2IGFsaWFzDQo+IA0KPiBPbiAy
MDE5LzgvMjkgMTk6MTgsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiBTb21lIHZlbmRvciBkcml2
ZXJzIHdhbnQgYW4gaWRlbnRpZmllciBmb3IgYW4gbWRldiBkZXZpY2UgdGhhdCBpcw0KPiA+IHNo
b3J0ZXIgdGhhbiB0aGUgVVVJRCwgZHVlIHRvIGxlbmd0aCByZXN0cmljdGlvbnMgaW4gdGhlIGNv
bnN1bWVycyBvZg0KPiA+IHRoYXQgaWRlbnRpZmllci4NCj4gPg0KPiA+IEFkZCBhIGNhbGxiYWNr
IHRoYXQgYWxsb3dzIGEgdmVuZG9yIGRyaXZlciB0byByZXF1ZXN0IGFuIGFsaWFzIG9mIGENCj4g
PiBzcGVjaWZpZWQgbGVuZ3RoIHRvIGJlIGdlbmVyYXRlZCBmb3IgYW4gbWRldiBkZXZpY2UuIElm
IGdlbmVyYXRlZCwNCj4gPiB0aGF0IGFsaWFzIGlzIGNoZWNrZWQgZm9yIGNvbGxpc2lvbnMuDQo+
ID4NCj4gPiBJdCBpcyBhbiBvcHRpb25hbCBhdHRyaWJ1dGUuDQo+ID4gbWRldiBhbGlhcyBpcyBn
ZW5lcmF0ZWQgdXNpbmcgc2hhMSBmcm9tIHRoZSBtZGV2IG5hbWUuDQo+ID4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NCj4gPg0KPiA+IC0tLQ0K
PiA+IENoYW5nZWxvZzoNCj4gPiB2MS0+djI6DQo+ID4gIC0gS2VwdCBtZGV2X2RldmljZSBuYXR1
cmFsbHkgYWxpZ25lZA0KPiA+ICAtIEFkZGVkIGVycm9yIGNoZWNraW5nIGZvciBjcnlwdF8qKCkg
Y2FsbHMNCj4gPiAgLSBDb3JyZWN0ZWQgYSB0eXBvIGZyb20gJ2FuZCcgdG8gJ2FuJw0KPiA+ICAt
IENoYW5nZWQgcmV0dXJuIHR5cGUgb2YgZ2VuZXJhdGVfYWxpYXMoKSBmcm9tIGludCB0byBjaGFy
Kg0KPiA+IHYwLT52MToNCj4gPiAgLSBNb3ZlZCBhbGlhcyBsZW5ndGggY2hlY2sgb3V0c2lkZSBv
ZiB0aGUgcGFyZW50IGxvY2sNCj4gPiAgLSBNb3ZlZCBhbGlhcyBhbmQgZGlnZXN0IGFsbG9jYXRp
b24gZnJvbSBrdnphbGxvYyB0byBremFsbG9jDQo+ID4gIC0gJmFsaWFzWzBdIGNoYW5nZWQgdG8g
YWxpYXMNCj4gPiAgLSBhbGlhc19sZW5ndGggY2hlY2sgaXMgbmVzdGVkIHVuZGVyIGdldF9hbGlh
c19sZW5ndGggY2FsbGJhY2sgY2hlY2sNCj4gPiAgLSBDaGFuZ2VkIGNvbW1lbnRzIHRvIHN0YXJ0
IHdpdGggYW4gZW1wdHkgbGluZQ0KPiA+ICAtIEZpeGVkIGNsZWF1bnVwIG9mIGhhc2ggaWYgbWRl
dl9idXNfcmVnaXN0ZXIoKSBmYWlscw0KPiA+ICAtIEFkZGVkIGNvbW1lbnQgd2hlcmUgYWxpYXMg
bWVtb3J5IG93bmVyc2hpcCBpcyBoYW5kZWQgb3ZlciB0byBtZGV2DQo+ID4gZGV2aWNlDQo+ID4g
IC0gVXBkYXRlZCBjb21taXQgbG9nIHRvIGluZGljYXRlIG1vdGl2YXRpb24gZm9yIHRoaXMgZmVh
dHVyZQ0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3ZmaW8vbWRldi9tZGV2X2NvcmUuYyAgICB8IDEy
Mw0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+ID4gIGRyaXZlcnMvdmZpby9t
ZGV2L21kZXZfcHJpdmF0ZS5oIHwgICA1ICstDQo+ID4gIGRyaXZlcnMvdmZpby9tZGV2L21kZXZf
c3lzZnMuYyAgIHwgIDEzICsrLS0NCj4gPiAgaW5jbHVkZS9saW51eC9tZGV2LmggICAgICAgICAg
ICAgfCAgIDQgKw0KPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDEzNSBpbnNlcnRpb25zKCspLCAxMCBk
ZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vbWRldi9tZGV2
X2NvcmUuYw0KPiA+IGIvZHJpdmVycy92ZmlvL21kZXYvbWRldl9jb3JlLmMgaW5kZXggYjU1OGQ0
Y2ZkMDgyLi4zYmRmZjA0Njk2MDcNCj4gPiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8v
bWRldi9tZGV2X2NvcmUuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmZpby9tZGV2L21kZXZfY29yZS5j
DQo+ID4gQEAgLTEwLDkgKzEwLDExIEBADQo+ID4gICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4N
Cj4gPiAgI2luY2x1ZGUgPGxpbnV4L2RldmljZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvc2xh
Yi5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvbW0uaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3V1
aWQuaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3N5c2ZzLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51
eC9tZGV2Lmg+DQo+ID4gKyNpbmNsdWRlIDxjcnlwdG8vaGFzaC5oPg0KPiA+DQo+ID4gICNpbmNs
dWRlICJtZGV2X3ByaXZhdGUuaCINCj4gPg0KPiA+IEBAIC0yNyw2ICsyOSw4IEBAIHN0YXRpYyBz
dHJ1Y3QgY2xhc3NfY29tcGF0ICptZGV2X2J1c19jb21wYXRfY2xhc3M7DQo+ID4gc3RhdGljIExJ
U1RfSEVBRChtZGV2X2xpc3QpOyAgc3RhdGljIERFRklORV9NVVRFWChtZGV2X2xpc3RfbG9jayk7
DQo+ID4NCj4gPiArc3RhdGljIHN0cnVjdCBjcnlwdG9fc2hhc2ggKmFsaWFzX2hhc2g7DQo+ID4g
Kw0KPiA+ICBzdHJ1Y3QgZGV2aWNlICptZGV2X3BhcmVudF9kZXYoc3RydWN0IG1kZXZfZGV2aWNl
ICptZGV2KSAgew0KPiA+ICAJcmV0dXJuIG1kZXYtPnBhcmVudC0+ZGV2Ow0KPiA+IEBAIC0xNTAs
NiArMTU0LDE2IEBAIGludCBtZGV2X3JlZ2lzdGVyX2RldmljZShzdHJ1Y3QgZGV2aWNlICpkZXYs
IGNvbnN0DQo+IHN0cnVjdCBtZGV2X3BhcmVudF9vcHMgKm9wcykNCj4gPiAgCWlmICghb3BzIHx8
ICFvcHMtPmNyZWF0ZSB8fCAhb3BzLT5yZW1vdmUgfHwgIW9wcy0NCj4gPnN1cHBvcnRlZF90eXBl
X2dyb3VwcykNCj4gPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gPg0KPiA+ICsJaWYgKG9wcy0+Z2V0
X2FsaWFzX2xlbmd0aCkgew0KPiA+ICsJCXVuc2lnbmVkIGludCBkaWdlc3Rfc2l6ZTsNCj4gPiAr
CQl1bnNpZ25lZCBpbnQgYWxpZ25lZF9sZW47DQo+ID4gKw0KPiA+ICsJCWFsaWduZWRfbGVuID0g
cm91bmR1cChvcHMtPmdldF9hbGlhc19sZW5ndGgoKSwgMik7DQo+ID4gKwkJZGlnZXN0X3NpemUg
PSBjcnlwdG9fc2hhc2hfZGlnZXN0c2l6ZShhbGlhc19oYXNoKTsNCj4gPiArCQlpZiAoYWxpZ25l
ZF9sZW4gLyAyID4gZGlnZXN0X3NpemUpDQo+ID4gKwkJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsJ
fQ0KPiA+ICsNCj4gPiAgCWRldiA9IGdldF9kZXZpY2UoZGV2KTsNCj4gPiAgCWlmICghZGV2KQ0K
PiA+ICAJCXJldHVybiAtRUlOVkFMOw0KPiA+IEBAIC0yNTksNiArMjczLDcgQEAgc3RhdGljIHZv
aWQgbWRldl9kZXZpY2VfZnJlZShzdHJ1Y3QgbWRldl9kZXZpY2UNCj4gKm1kZXYpDQo+ID4gIAlt
dXRleF91bmxvY2soJm1kZXZfbGlzdF9sb2NrKTsNCj4gPg0KPiA+ICAJZGV2X2RiZygmbWRldi0+
ZGV2LCAiTURFVjogZGVzdHJveWluZ1xuIik7DQo+ID4gKwlrZnJlZShtZGV2LT5hbGlhcyk7DQo+
ID4gIAlrZnJlZShtZGV2KTsNCj4gPiAgfQ0KPiA+DQo+ID4gQEAgLTI2OSwxOCArMjg0LDEwMSBA
QCBzdGF0aWMgdm9pZCBtZGV2X2RldmljZV9yZWxlYXNlKHN0cnVjdCBkZXZpY2UNCj4gKmRldikN
Cj4gPiAgCW1kZXZfZGV2aWNlX2ZyZWUobWRldik7DQo+ID4gIH0NCj4gPg0KPiA+IC1pbnQgbWRl
dl9kZXZpY2VfY3JlYXRlKHN0cnVjdCBrb2JqZWN0ICprb2JqLA0KPiA+IC0JCSAgICAgICBzdHJ1
Y3QgZGV2aWNlICpkZXYsIGNvbnN0IGd1aWRfdCAqdXVpZCkNCj4gPiArc3RhdGljIGNvbnN0IGNo
YXIgKg0KPiA+ICtnZW5lcmF0ZV9hbGlhcyhjb25zdCBjaGFyICp1dWlkLCB1bnNpZ25lZCBpbnQg
bWF4X2FsaWFzX2xlbikgew0KPiA+ICsJc3RydWN0IHNoYXNoX2Rlc2MgKmhhc2hfZGVzYzsNCj4g
PiArCXVuc2lnbmVkIGludCBkaWdlc3Rfc2l6ZTsNCj4gPiArCXVuc2lnbmVkIGNoYXIgKmRpZ2Vz
dDsNCj4gPiArCXVuc2lnbmVkIGludCBhbGlhc19sZW47DQo+ID4gKwljaGFyICphbGlhczsNCj4g
PiArCWludCByZXQ7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIEFsaWduIHRvIG11bHRpcGxl
IG9mIDIgYXMgYmluMmhleCB3aWxsIGdlbmVyYXRlDQo+ID4gKwkgKiBldmVuIG51bWJlciBvZiBi
eXRlcy4NCj4gPiArCSAqLw0KPiA+ICsJYWxpYXNfbGVuID0gcm91bmR1cChtYXhfYWxpYXNfbGVu
LCAyKTsNCj4gPiArCWFsaWFzID0ga3phbGxvYyhhbGlhc19sZW4gKyAxLCBHRlBfS0VSTkVMKTsN
Cj4gDQo+IEl0IHNlZW1zIHRoZSBtdHR5X2FsaWFzX2xlbmd0aCBpbiBtdHR5LmMgY2FuIGJlIHNl
dCBmcm9tIG1vZHVsZSBwYXJhbWV0ZXIsDQo+IGFuZCB1c2VyIGNhbiBzZXQgYSB2ZXJ5IGxhcmdl
IG51bWJlciwgbWF5YmUgbGltaXQgdGhlIG1heCBvZiB0aGUgYWxpYXNfbGVuDQo+IGJlZm9yZSBj
YWxsaW5nIGt6YWxsb2M/DQpUaGlzIGlzIGFscmVhZHkgZ3VhcmRlZCBpbiBtZGV2X3JlZ2lzdGVy
X2RldmljZSgpLg0KVXNlciBjYW5ub3QgcmVxdWVzdCBhbGlhcyBsZW5ndGggYmlnZ2VyIHRoYW4g
dGhlIGRpZ2VzdCBzaXplIG9mIHNoYTEgKHdoaWNoIGlzIDIwIGJ5dGVzKS4NCg==
