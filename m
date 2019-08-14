Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812F58DF0D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbfHNUlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:41:15 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:41486
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728579AbfHNUlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 16:41:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9BwgDqZTy5lc+3oiOfZU4yRZXmIIpxonjjAoNZHL6DKW7b78q73HIkgv5dR2soSN3O3cILn7IM68qnq5yDFlCMg5CwWg+MkksKO63sMoV7h0+uL6cZfwJN3Te33+jYJeebY/804/BOOldnyobZDwaJtho/nsV3/pCyDajz1LQZlTysZRbxw7NWDb/LCO2inp3l1ZbckDoR9EA0NNI2kU/MHo3+Ssfp9XYkSfw92774DDPR8ODk2OSSWceiSb4Z/RlUoK5/a2j0HCy3jS8RbOwkxqy+1wdz8yoDIRccaK46LxFMdXa5w99i6B9B72alYJsQ8e/pEuxG6SHSBrWN4Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nu6ua77vageCPSt3zIdiuVe/N23nJwqrghCplRBfyM8=;
 b=VWbS+99n1VKrApQ12AXTOT4V5Zbh0QY6nHhINEN52pO3CDPlCCGam46oMa28wgF2L0CPGOrIgXf0sayK3F18Guq0jlPnkhszUyEQePiykamINlCUzWUaPfPDQB0SAI51JHD2o7pD1D2Y30lKjjGGcvrgTe5UwPtTIG8dF5k2xYA2OQMHdcxT1paIxTYAnwkoPQVTy6dOt4IKjEMaeYUw1r7jPDpe15knW0ihaIrqEP1YQBM8iNSkAifgALDHP/YbwuHkwRr+lQH+sxgNw43LIFAHhXAsNFhA3QV5C7WbzrvEjo4PKCzX5glyvlXjYHFKXngJm+w31jo2jkmELHobNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nu6ua77vageCPSt3zIdiuVe/N23nJwqrghCplRBfyM8=;
 b=Hj3JoMx+LradlxRJf4m+m3ogtWEMs1WLwknuVcEPGU7j3L9gLHIk+mCFUH8sXc8NncOOvXqJkwImd6jFY/yB0938U8DmG9P6xVnicJeNddzjOcWfCwy76I7wFWEr1mT0QHcB1O6+v/tx3c98yPf3JOyB+gcFuw2e3wqQXMgBo4k=
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com (10.170.238.143) by
 VI1PR05MB5616.eurprd05.prod.outlook.com (20.177.203.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Wed, 14 Aug 2019 20:41:03 +0000
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::3195:8043:2057:2780]) by VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::3195:8043:2057:2780%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 20:41:03 +0000
From:   Mark Bloch <markb@mellanox.com>
To:     haiyangz <haiyangz@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     kys <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Topic: [PATCH net-next, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Index: AQHVUtPRAHeBl29YRkyFJ13hEptbC6b7G3mA
Date:   Wed, 14 Aug 2019 20:41:02 +0000
Message-ID: <e2a38f24-5a63-ef89-9d69-6a0f2770a9e4@mellanox.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
 <1565809632-39138-4-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1565809632-39138-4-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0062.namprd04.prod.outlook.com
 (2603:10b6:300:6c::24) To VI1PR05MB3342.eurprd05.prod.outlook.com
 (2603:10a6:802:1d::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [208.186.24.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3632ffa4-b3d0-48d7-58be-08d720f7b8c7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5616;
x-ms-traffictypediagnostic: VI1PR05MB5616:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5616C01AFC887BBC4F053D22D2AD0@VI1PR05MB5616.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(199004)(189003)(6506007)(7416002)(110136005)(256004)(76176011)(14454004)(55236004)(25786009)(386003)(6116002)(54906003)(53546011)(2201001)(4326008)(86362001)(52116002)(36756003)(6486002)(31686004)(186003)(229853002)(53936002)(6436002)(3846002)(81156014)(6246003)(66066001)(316002)(102836004)(31696002)(26005)(478600001)(81166006)(305945005)(8936002)(7736002)(11346002)(8676002)(486006)(2616005)(71190400001)(71200400001)(1511001)(64756008)(2906002)(2501003)(446003)(5660300002)(99286004)(66556008)(476003)(66476007)(66446008)(66946007)(6512007)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5616;H:VI1PR05MB3342.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qqs3KVmqEGdd/iR0wu+oedsoaZCigUI710gVXPeci9DK0hDOJvOCPU74pa48+iBG4HJz22z/LjUfc1T0wzxMqV7f6rM2nQ7tPmXjvnCM2jxf8jj2tHlNLHCns1PW5954+3RBBO3/Paz5B5qSMhcQK4wWuxgQLgslcNEsshIZizanHCB8JTMk/q4KVp4++WnsFQC3/afu4HxY2cixjZv3S0i+gbW6GJe31qsvWk6o51widBG4xeJT0dtscHxZDptVp7ccMi5LMfa8kWyB2n17Fig4SQa3BqBY25oQm1RqIPUJSY5iNXO9bHRfp84QOprfD6BuoAzKEBTbHGDXffD9TNlldS4Fph3TfkwjmorQyZ1SijzQ/Gvz7gfDwuzir+xmJdD8JasP9Fvp/AZIjgLC6fPjQ0kV36voMN47W38l+cM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A36F4B727B93564589F2B3C07FD9AC99@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3632ffa4-b3d0-48d7-58be-08d720f7b8c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 20:41:02.8885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ILnxQwYVQmUM0vyzQ15J5yIMG3vKxwSvADST3ko6HCDo7xk4k2soz3mpxV+5CBEG10f99pNuLBktL6zujqwZUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5616
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTQvMTkgMTI6MDggUE0sIEhhaXlhbmcgWmhhbmcgd3JvdGU6DQo+IEZyb206IEVy
YW4gQmVuIEVsaXNoYSA8ZXJhbmJlQG1lbGxhbm94LmNvbT4NCj4gDQo+IEFkZCB3cmFwcGVyIGZ1
bmN0aW9ucyBmb3IgSHlwZXJWIFBDSWUgcmVhZCAvIHdyaXRlIC8NCj4gYmxvY2tfaW52YWxpZGF0
ZV9yZWdpc3RlciBvcGVyYXRpb25zLiAgVGhpcyB3aWxsIGJlIHVzZWQgYXMgYW4NCj4gaW5mcmFz
dHJ1Y3R1cmUgaW4gdGhlIGRvd25zdHJlYW0gcGF0Y2ggZm9yIHNvZnR3YXJlIGNvbW11bmljYXRp
b24uDQo+IA0KPiBUaGlzIHdpbGwgYmUgZW5hYmxlZCBieSBkZWZhdWx0IGlmIENPTkZJR19QQ0lf
SFlQRVJWX01JTkkgaXMgc2V0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRXJhbiBCZW4gRWxpc2hh
IDxlcmFuYmVAbWVsbGFub3guY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8
c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvTWFrZWZpbGUgfCAgMSArDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmMgfCA2NCArKysrKysrKysrKysrKysrKysrKysrKysN
Cj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvaHYuaCB8IDIy
ICsrKysrKysrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDg3IGluc2VydGlvbnMoKykNCj4gIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGli
L2h2LmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvbGliL2h2LmgNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvTWFrZWZpbGUgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvTWFrZWZpbGUNCj4gaW5kZXggOGI3ZWRhYS4uYTg5NTBiMSAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL01ha2Vm
aWxlDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9NYWtl
ZmlsZQ0KPiBAQCAtNDUsNiArNDUsNyBAQCBtbHg1X2NvcmUtJChDT05GSUdfTUxYNV9FU1dJVENI
KSAgICs9IGVzd2l0Y2gubyBlc3dpdGNoX29mZmxvYWRzLm8gZXN3aXRjaF9vZmZsbw0KPiAgbWx4
NV9jb3JlLSQoQ09ORklHX01MWDVfTVBGUykgICAgICArPSBsaWIvbXBmcy5vDQo+ICBtbHg1X2Nv
cmUtJChDT05GSUdfVlhMQU4pICAgICAgICAgICs9IGxpYi92eGxhbi5vDQo+ICBtbHg1X2NvcmUt
JChDT05GSUdfUFRQXzE1ODhfQ0xPQ0spICs9IGxpYi9jbG9jay5vDQo+ICttbHg1X2NvcmUtJChD
T05GSUdfUENJX0hZUEVSVl9NSU5JKSAgICAgKz0gbGliL2h2Lm8NCj4gIA0KPiAgIw0KPiAgIyBJ
cG9pYiBuZXRkZXYNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9saWIvaHYuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9saWIvaHYuYw0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwLi5j
ZjA4ZDAyDQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2xpYi9odi5jDQo+IEBAIC0wLDAgKzEsNjQgQEANCj4gKy8vIFNQRFgt
TGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wIE9SIExpbnV4LU9wZW5JQg0KPiArLy8gQ29weXJp
Z2h0IChjKSAyMDE4IE1lbGxhbm94IFRlY2hub2xvZ2llcw0KPiArDQo+ICsjaW5jbHVkZSA8bGlu
dXgvaHlwZXJ2Lmg+DQo+ICsjaW5jbHVkZSAibWx4NV9jb3JlLmgiDQo+ICsjaW5jbHVkZSAibGli
L2h2LmgiDQo+ICsNCj4gK3N0YXRpYyBpbnQgbWx4NV9odl9jb25maWdfY29tbW9uKHN0cnVjdCBt
bHg1X2NvcmVfZGV2ICpkZXYsIHZvaWQgKmJ1ZiwgaW50IGxlbiwNCj4gKwkJCQkgaW50IG9mZnNl
dCwgYm9vbCByZWFkKQ0KPiArew0KPiArCWludCByYyA9IC1FT1BOT1RTVVBQOw0KPiArCWludCBi
eXRlc19yZXR1cm5lZDsNCj4gKwlpbnQgYmxvY2tfaWQ7DQo+ICsNCj4gKwlpZiAob2Zmc2V0ICUg
SFZfQ09ORklHX0JMT0NLX1NJWkVfTUFYIHx8IGxlbiAlIEhWX0NPTkZJR19CTE9DS19TSVpFX01B
WCkNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICsNCj4gKwlibG9ja19pZCA9IG9mZnNldCAvIEhW
X0NPTkZJR19CTE9DS19TSVpFX01BWDsNCj4gKw0KPiArCXJjID0gcmVhZCA/DQo+ICsJICAgICBo
eXBlcnZfcmVhZF9jZmdfYmxrKGRldi0+cGRldiwgYnVmLA0KPiArCQkJCSBIVl9DT05GSUdfQkxP
Q0tfU0laRV9NQVgsIGJsb2NrX2lkLA0KPiArCQkJCSAmYnl0ZXNfcmV0dXJuZWQpIDoNCj4gKwkg
ICAgIGh5cGVydl93cml0ZV9jZmdfYmxrKGRldi0+cGRldiwgYnVmLA0KPiArCQkJCSAgSFZfQ09O
RklHX0JMT0NLX1NJWkVfTUFYLCBibG9ja19pZCk7DQo+ICsNCj4gKwkvKiBNYWtlIHN1cmUgbGVu
IGJ5dGVzIHdlcmUgcmVhZCBzdWNjZXNzZnVsbHkgICovDQo+ICsJaWYgKHJlYWQpDQo+ICsJCXJj
IHw9ICEobGVuID09IGJ5dGVzX3JldHVybmVkKTsNCj4gKw0KPiArCWlmIChyYykgew0KPiArCQlt
bHg1X2NvcmVfZXJyKGRldiwgIkZhaWxlZCB0byAlcyBodiBjb25maWcsIGVyciA9ICVkLCBsZW4g
PSAlZCwgb2Zmc2V0ID0gJWRcbiIsDQo+ICsJCQkgICAgICByZWFkID8gInJlYWQiIDogIndyaXRl
IiwgcmMsIGxlbiwNCj4gKwkJCSAgICAgIG9mZnNldCk7DQo+ICsJCXJldHVybiByYzsNCj4gKwl9
DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCg0KVGhpcyBzZWVtcyBvdXQgb2YgcGxhY2Ugd2h5
IG5vdCBleHBvc2UgdGhpcyBmdW5jdGlvbiBhcyBwYXJ0IG9mIGh5cGVydiBhbmQgbWx4NQ0Kd2ls
bCBqdXN0IHBhc3MgdGhlIHBkZXYuDQoNCj4gKw0KPiAraW50IG1seDVfaHZfcmVhZF9jb25maWco
c3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgdm9pZCAqYnVmLCBpbnQgbGVuLA0KPiArCQkJaW50
IG9mZnNldCkNCj4gK3sNCj4gKwlyZXR1cm4gbWx4NV9odl9jb25maWdfY29tbW9uKGRldiwgYnVm
LCBsZW4sIG9mZnNldCwgdHJ1ZSk7DQo+ICt9DQo+ICsNCj4gK2ludCBtbHg1X2h2X3dyaXRlX2Nv
bmZpZyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB2b2lkICpidWYsIGludCBsZW4sDQo+ICsJ
CQkgaW50IG9mZnNldCkNCj4gK3sNCj4gKwlyZXR1cm4gbWx4NV9odl9jb25maWdfY29tbW9uKGRl
diwgYnVmLCBsZW4sIG9mZnNldCwgZmFsc2UpOw0KPiArfQ0KPiArDQo+ICtpbnQgbWx4NV9odl9y
ZWdpc3Rlcl9pbnZhbGlkYXRlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHZvaWQgKmNvbnRl
eHQsDQo+ICsJCQkJdm9pZCAoKmJsb2NrX2ludmFsaWRhdGUpKHZvaWQgKmNvbnRleHQsDQo+ICsJ
CQkJCQkJIHU2NCBibG9ja19tYXNrKSkNCj4gK3sNCj4gKwlyZXR1cm4gaHlwZXJ2X3JlZ19ibG9j
a19pbnZhbGlkYXRlKGRldi0+cGRldiwgY29udGV4dCwNCj4gKwkJCQkJICAgYmxvY2tfaW52YWxp
ZGF0ZSk7DQo+ICt9DQo+ICsNCj4gK3ZvaWQgbWx4NV9odl91bnJlZ2lzdGVyX2ludmFsaWRhdGUo
c3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCj4gK3sNCj4gKwloeXBlcnZfcmVnX2Jsb2NrX2lu
dmFsaWRhdGUoZGV2LT5wZGV2LCBOVUxMLCBOVUxMKTsNCj4gK30NCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvaHYuaCBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvaHYuaA0KPiBuZXcgZmlsZSBtb2Rl
IDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwLi43ZjY5NzcxDQo+IC0tLSAvZGV2L251bGwNCj4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9odi5oDQo+IEBA
IC0wLDAgKzEsMjIgQEANCj4gKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wIE9S
IExpbnV4LU9wZW5JQiAqLw0KPiArLyogQ29weXJpZ2h0IChjKSAyMDE5IE1lbGxhbm94IFRlY2hu
b2xvZ2llcy4gKi8NCj4gKw0KPiArI2lmbmRlZiBfX0xJQl9IVl9IX18NCj4gKyNkZWZpbmUgX19M
SUJfSFZfSF9fDQo+ICsNCj4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19QQ0lfSFlQRVJWX01JTkkp
DQo+ICsNCj4gKyNpbmNsdWRlIDxsaW51eC9oeXBlcnYuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9t
bHg1L2RyaXZlci5oPg0KPiArDQo+ICtpbnQgbWx4NV9odl9yZWFkX2NvbmZpZyhzdHJ1Y3QgbWx4
NV9jb3JlX2RldiAqZGV2LCB2b2lkICpidWYsIGludCBsZW4sDQo+ICsJCQlpbnQgb2Zmc2V0KTsN
Cj4gK2ludCBtbHg1X2h2X3dyaXRlX2NvbmZpZyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB2
b2lkICpidWYsIGludCBsZW4sDQo+ICsJCQkgaW50IG9mZnNldCk7DQo+ICtpbnQgbWx4NV9odl9y
ZWdpc3Rlcl9pbnZhbGlkYXRlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHZvaWQgKmNvbnRl
eHQsDQo+ICsJCQkJdm9pZCAoKmJsb2NrX2ludmFsaWRhdGUpKHZvaWQgKmNvbnRleHQsDQo+ICsJ
CQkJCQkJIHU2NCBibG9ja19tYXNrKSk7DQo+ICt2b2lkIG1seDVfaHZfdW5yZWdpc3Rlcl9pbnZh
bGlkYXRlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpOw0KPiArI2VuZGlmDQo+ICsNCj4gKyNl
bmRpZiAvKiBfX0xJQl9IVl9IX18gKi8NCj4gDQoNCk1hcmsNCg==
