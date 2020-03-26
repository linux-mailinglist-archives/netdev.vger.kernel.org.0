Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C81193734
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgCZDxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:53:50 -0400
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:54754
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727590AbgCZDxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:53:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kweFEAaa9hxwXBx79jSGkVEVHmKl3XuHXpBBE1JW1wM/0ywp9NEhcZlGdr/eQI7JWTDwoyjHwDfOAxDMXWvNBCx3fn9PBF/t1eCL73jI8KxfSpcmfzt1FrHsNuWv7a+Gn/R++hNl14tA1nRsIOR5/VFSXCE/NlJA15MyWWr/KNpQbZ2Zv152W7NV6OTRMS6XhxXFcvuRZkBQkE53nUYe4+PxTYQZnzZTt+uiGI+rhPFzYGwbSyRcdSGOKWV4pxItAUtZun8VxWEsa5Ma+jX+NzazLexJuvJVrVDQ21CbrZnb0ylx9WuR8ePzfranrtOeuwmVUVonSEz/Ibs0xZWMmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kyNGFqGZba4f5kAJgdylGde9+yk1tzoy5+CsMvTXcA=;
 b=K5zqjflQrTqZ6w7V4WOpFFVRIRWcyVxlQcFQWhYrZqOtXtvdI1iuKEkUMSlMwIzY68MPlTHq+7BWOoeFIU5kczIJOjHV64oCi9+HqFgbLoOlgOZdcSOmA1FIhn+dWVq3o9qoMQxtfkiFz6e8lfqRXnOnp3GfAu1bjgnco7UNCq1+Pq+GMCYMMI7ChJVs/1YWuvSkuNsAB6Mca2vVZaUtdDrk9vP+JFEoFFp+LTbs+uOEDc9UIUf1xsLdBe+2E8x3X9fqs9TEDrHalysfknOrUc6mGsjddqNOT4ulXkFBkQsj3MHK0RUYUTazqjesnnTFEodxA8IXROzzmeKLJZZpwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kyNGFqGZba4f5kAJgdylGde9+yk1tzoy5+CsMvTXcA=;
 b=H5oEFmN51fmp7pnutPNho5xl9NNZZgJZ+Bfy9ZzZ3S5jWucuJz7glecjGWXoGeir9MnVFCirHVfu4/o5bHCfiRNOJQhreBNoI6GFmadJVZn4MQ/A9JeNssMS/OHSIE3cFjDg5R5zUX/gmUInJUx5+Wd2PbRdVa83jQHstEB6iX4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4207.eurprd05.prod.outlook.com (52.133.14.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.19; Thu, 26 Mar 2020 03:53:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 03:53:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Roi Dayan <roid@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Majd Dibbiny <majd@mellanox.com>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net/mlx5: CT: Use rhashtable's ct entries
 instead of a seperate list
Thread-Topic: [PATCH net-next 3/3] net/mlx5: CT: Use rhashtable's ct entries
 instead of a seperate list
Thread-Index: AQHWAd6gnXNvk3opWEin1rfALSQP26haQImA
Date:   Thu, 26 Mar 2020 03:53:43 +0000
Message-ID: <b24b275716ffecbf1382d4ab063464e18ddf5073.camel@mellanox.com>
References: <1585055841-14256-1-git-send-email-paulb@mellanox.com>
         <1585055841-14256-4-git-send-email-paulb@mellanox.com>
In-Reply-To: <1585055841-14256-4-git-send-email-paulb@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 32ba078e-4014-4e34-aa36-08d7d13947f2
x-ms-traffictypediagnostic: VI1PR05MB4207:|VI1PR05MB4207:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4207F1CDD30D46A10702AF78BECF0@VI1PR05MB4207.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(6506007)(478600001)(316002)(110136005)(86362001)(5660300002)(66476007)(76116006)(2906002)(66946007)(66556008)(64756008)(66446008)(91956017)(4326008)(6636002)(71200400001)(6512007)(6486002)(186003)(36756003)(2616005)(8676002)(8936002)(26005)(81156014)(81166006);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: usTfxu7p/Buvk+yEAj6A8aoBNgoj5YHkQq8ZWfKLXYn19ETEkBDSDMYbaqLRqGEmifqOYFaCbgQQnqKXlvV5NtWBYxrFtKp9qyPxEtVwryQBv/hwVHh1/LzpuHWYVSBBV6BYl8lL4jbSoG0y3oAegFIMuQVa4t9gf9PpuGgXuCDpemsEfvBoJxFJTZ0Rm/kMWZ2+ChaMeWaWNMv3NJWNgEK+0EKHiObgUtUCyhsg2DVFOWOEo8cp7E/B98oJqKIzwQlCiM+5rjFFbYIfbNsI81bzalKvpsvAzyPAJEz/DFOW6af3s5rQnAfxBek+yHyjtZUEKHYzeM1tTGYhrvH+ocn2CTysI5yr3ars4tvQbT/6lqYs9X/o685AOZKiUCBekhGgbksJW0YWNPT/q64yYwqKfrxW5IQ81uvOBHMIWOx8Ji/TUvbScyHUEEA6mZhA
x-ms-exchange-antispam-messagedata: BGA52MmBQJCn+zeDgBtJbhdEx74lZEXh3wIuNgVAOrC67gsjZ5uVznU82SSe4lv3Ub5e+N7lbIy/9YsipLmzGj+ijWzIQWGq6p1bE7yazj4+QPRcr73+kxxL5l/nYZccxeb+cSWlagsfzAoqIUMR9w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FB00256819B2F48B333C43BC33CF119@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32ba078e-4014-4e34-aa36-08d7d13947f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 03:53:44.0194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9QKRNT+i5BGzRPVebp5HAOkfhlW2WEDcEQUeWOG530ROPBJZgYJ2TZrvGhtjxVWipmVo29YruLgi8EhwhKW2TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4207
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAzLTI0IGF0IDE1OjE3ICswMjAwLCBQYXVsIEJsYWtleSB3cm90ZToNCj4g
Q1QgZW50cmllcyBsaXN0IGlzIG9ubHkgdXNlZCB3aGlsZSBmcmVlaW5nIGEgY3Qgem9uZSBmbG93
IHRhYmxlIHRvDQo+IGdvIG92ZXIgYWxsIHRoZSBjdCBlbnRyaWVzIG9mZmxvYWRlZCBvbiB0aGF0
IHpvbmUvdGFibGUsIGFuZCBmbHVzaA0KPiB0aGUgdGFibGUuDQo+IA0KPiBSaGFzaHRhYmxlIGFs
cmVhZHkgcHJvdmlkZXMgYW4gYXBpIHRvIGdvIG92ZXIgYWxsIHRoZSBpbnNlcnRlZA0KPiBlbnRy
aWVzLg0KPiBVc2UgaXQgaW5zdGVhZCwgYW5kIHJlbW92ZSB0aGUgbGlzdC4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IFBhdWwgQmxha2V5IDxwYXVsYkBtZWxsYW5veC5jb20+DQo+IFJldmlld2VkLWJ5
OiBPeiBTaGxvbW8gPG96c2hAbWVsbGFub3guY29tPg0KDQpBY2tlZC1ieTogU2FlZWQgTWFoYW1l
ZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfY3QuYyB8IDE5ICsrKysrKystLS0tLQ0KPiAtLS0t
LS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW4vdGNfY3QuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbi90Y19jdC5jDQo+IGluZGV4IGEyMmFkNmIuLmFmYzhhYzMgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y19jdC5jDQo+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y19jdC5jDQo+IEBA
IC02NywxMSArNjcsOSBAQCBzdHJ1Y3QgbWx4NV9jdF9mdCB7DQo+ICAJc3RydWN0IG5mX2Zsb3d0
YWJsZSAqbmZfZnQ7DQo+ICAJc3RydWN0IG1seDVfdGNfY3RfcHJpdiAqY3RfcHJpdjsNCj4gIAlz
dHJ1Y3Qgcmhhc2h0YWJsZSBjdF9lbnRyaWVzX2h0Ow0KPiAtCXN0cnVjdCBsaXN0X2hlYWQgY3Rf
ZW50cmllc19saXN0Ow0KPiAgfTsNCj4gIA0KPiAgc3RydWN0IG1seDVfY3RfZW50cnkgew0KPiAt
CXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsNCj4gIAl1MTYgem9uZTsNCj4gIAlzdHJ1Y3Qgcmhhc2hf
aGVhZCBub2RlOw0KPiAgCXN0cnVjdCBmbG93X3J1bGUgKmZsb3dfcnVsZTsNCj4gQEAgLTYxNyw4
ICs2MTUsNiBAQCBzdHJ1Y3QgbWx4NV9jdF9lbnRyeSB7DQo+ICAJaWYgKGVycikNCj4gIAkJZ290
byBlcnJfaW5zZXJ0Ow0KPiAgDQo+IC0JbGlzdF9hZGQoJmVudHJ5LT5saXN0LCAmZnQtPmN0X2Vu
dHJpZXNfbGlzdCk7DQo+IC0NCj4gIAlyZXR1cm4gMDsNCj4gIA0KPiAgZXJyX2luc2VydDoNCj4g
QEAgLTY0Niw3ICs2NDIsNiBAQCBzdHJ1Y3QgbWx4NV9jdF9lbnRyeSB7DQo+ICAJV0FSTl9PTihy
aGFzaHRhYmxlX3JlbW92ZV9mYXN0KCZmdC0+Y3RfZW50cmllc19odCwNCj4gIAkJCQkgICAgICAg
JmVudHJ5LT5ub2RlLA0KPiAgCQkJCSAgICAgICBjdHNfaHRfcGFyYW1zKSk7DQo+IC0JbGlzdF9k
ZWwoJmVudHJ5LT5saXN0KTsNCj4gIAlrZnJlZShlbnRyeSk7DQo+ICANCj4gIAlyZXR1cm4gMDsN
Cj4gQEAgLTgxNyw3ICs4MTIsNiBAQCBzdHJ1Y3QgbWx4NV9jdF9lbnRyeSB7DQo+ICAJZnQtPnpv
bmUgPSB6b25lOw0KPiAgCWZ0LT5uZl9mdCA9IG5mX2Z0Ow0KPiAgCWZ0LT5jdF9wcml2ID0gY3Rf
cHJpdjsNCj4gLQlJTklUX0xJU1RfSEVBRCgmZnQtPmN0X2VudHJpZXNfbGlzdCk7DQo+ICAJcmVm
Y291bnRfc2V0KCZmdC0+cmVmY291bnQsIDEpOw0KPiAgDQo+ICAJZXJyID0gcmhhc2h0YWJsZV9p
bml0KCZmdC0+Y3RfZW50cmllc19odCwgJmN0c19odF9wYXJhbXMpOw0KPiBAQCAtODQ2LDEyICs4
NDAsMTIgQEAgc3RydWN0IG1seDVfY3RfZW50cnkgew0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgdm9p
ZA0KPiAtbWx4NV90Y19jdF9mbHVzaF9mdChzdHJ1Y3QgbWx4NV90Y19jdF9wcml2ICpjdF9wcml2
LCBzdHJ1Y3QNCj4gbWx4NV9jdF9mdCAqZnQpDQo+ICttbHg1X3RjX2N0X2ZsdXNoX2Z0X2VudHJ5
KHZvaWQgKnB0ciwgdm9pZCAqYXJnKQ0KPiAgew0KPiAtCXN0cnVjdCBtbHg1X2N0X2VudHJ5ICpl
bnRyeTsNCj4gKwlzdHJ1Y3QgbWx4NV90Y19jdF9wcml2ICpjdF9wcml2ID0gYXJnOw0KPiArCXN0
cnVjdCBtbHg1X2N0X2VudHJ5ICplbnRyeSA9IHB0cjsNCj4gIA0KPiAtCWxpc3RfZm9yX2VhY2hf
ZW50cnkoZW50cnksICZmdC0+Y3RfZW50cmllc19saXN0LCBsaXN0KQ0KPiAtCQltbHg1X3RjX2N0
X2VudHJ5X2RlbF9ydWxlcyhmdC0+Y3RfcHJpdiwgZW50cnkpOw0KPiArCW1seDVfdGNfY3RfZW50
cnlfZGVsX3J1bGVzKGN0X3ByaXYsIGVudHJ5KTsNCj4gIH0NCj4gIA0KPiAgc3RhdGljIHZvaWQN
Cj4gQEAgLTg2Miw5ICs4NTYsMTAgQEAgc3RydWN0IG1seDVfY3RfZW50cnkgew0KPiAgDQo+ICAJ
bmZfZmxvd190YWJsZV9vZmZsb2FkX2RlbF9jYihmdC0+bmZfZnQsDQo+ICAJCQkJICAgICBtbHg1
X3RjX2N0X2Jsb2NrX2Zsb3dfb2ZmbG9hZCwNCj4gZnQpOw0KPiAtCW1seDVfdGNfY3RfZmx1c2hf
ZnQoY3RfcHJpdiwgZnQpOw0KPiAgCXJoYXNodGFibGVfcmVtb3ZlX2Zhc3QoJmN0X3ByaXYtPnpv
bmVfaHQsICZmdC0+bm9kZSwNCj4gem9uZV9wYXJhbXMpOw0KPiAtCXJoYXNodGFibGVfZGVzdHJv
eSgmZnQtPmN0X2VudHJpZXNfaHQpOw0KPiArCXJoYXNodGFibGVfZnJlZV9hbmRfZGVzdHJveSgm
ZnQtPmN0X2VudHJpZXNfaHQsDQo+ICsJCQkJICAgIG1seDVfdGNfY3RfZmx1c2hfZnRfZW50cnks
DQo+ICsJCQkJICAgIGN0X3ByaXYpOw0KPiAgCWtmcmVlKGZ0KTsNCj4gIH0NCj4gIA0K
