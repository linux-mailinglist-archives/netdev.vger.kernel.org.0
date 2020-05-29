Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A754D1E8912
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgE2Uog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:44:36 -0400
Received: from mail-vi1eur05on2049.outbound.protection.outlook.com ([40.107.21.49]:6090
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726975AbgE2Uof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:44:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcUr6OaErC4hx8X2fXFOILQqZt1hepRNDxlzakSn3RdszhfYiq6y9UAvb8H/4CncV7j+cE5kecCYOyg8K156auGUyzdADgxj4MF5rSQOIkLSQ+A684EqzVqJvxzQ2JRQnPyfXOeD6yKKwpGNGRR9CTNlO5Gi95z4Uku3AzAQ5EzGRf8rxhaH7UAMKfvFx3LPIRlXV4zrGGsYlRLSnOjMVUyN9ovce1VVSpDLw3hnE5nmJeIkU6TJOrPTZy5GQdpslGH1XeZfgy+ma+aUZmE2IPJAzUDH5vf26iUFTLYbNzSU6IjAYAg8OoWKsEZNudUfXmPxyvu62OvAMgIm1Z65tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glP20HBjI5/0mzOCJ9YaFaH5tMdRgiJHqyt64OwPsuE=;
 b=jMhUBxNJKT5PqNJ86J5+OtlDY4l5qLNBuJWvjkRBlta/5bFXDSv401PdnW6mA2OlHiZswsGmUYwQrXx6GXQGBE78R9IEydsYDP5yKWePi7+nxLqH6Ki6ggn3tvX3cHf/p4bMQ4wmjDLyvLQkWy/+fEGZEPO9idxdiG8AOfH/D2/AvSi/cdQkO/6yzyNAYVLhDxft78Xk3pEsM7QnFBSttcm5PZAWhjbxLBAoFsX3E5fCNs23VE1VbdHpMFidTGDVzT4wk/lsVCtdtakwo9Wopm9GorIarZei9JH6KfVKnxAGEU89ewOqaHsbTnDhSzQwJHPZj1gSErSAiDlEhzVXfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glP20HBjI5/0mzOCJ9YaFaH5tMdRgiJHqyt64OwPsuE=;
 b=tn/sIzcljOG2D/nij4DA5B+cumU1iva8FYWFUCw68VVFPpGis28CyEsXQQRN0DOQV9H2zNekJVH97QkwrsjyyGWaSPQu0i0yaodoiNgU3Xpp8gHpy1DGIEmHD2mQTfmqAgOXUlH6inygxFd3azJpSps9BNylp0PFIyqHiezK2Os=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6863.eurprd05.prod.outlook.com (2603:10a6:800:183::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 20:44:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:44:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Thread-Topic: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Thread-Index: AQHWNfH6mom1hs1JjU+8qCOucXKJOKi/gDGAgAAHzoA=
Date:   Fri, 29 May 2020 20:44:29 +0000
Message-ID: <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
         <20200529194641.243989-11-saeedm@mellanox.com>
         <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0eab82a7-962b-4045-fe21-08d8041115f0
x-ms-traffictypediagnostic: VI1PR05MB6863:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB68639023877A25D2C08DB620BE8F0@VI1PR05MB6863.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 04180B6720
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x21HL5+C7b2kXATouBBXSgEcoJZvSMobOpnnJjMRRpU0SVNU4Gaqgwa6on3XoLwHCEiorMvCReXoL/wIL8lG1BJHglGwtghRpWkWMCxBmtscgHT+TGjkxy15Es9MQC9oaeFiVnFA3NPqoe8KVdAT5CqykRnPuCnoYGUNgcR45j3WoOhfkDtlPjd/N/ARAtTv1ZVjZJxpE0KJu/+l7Vwo527rWnAfpGPo8Pb9t+hTf3ga4jgdJBvBI+OsBm/Qy+MAJMm5Gmf9Rc7+6Ud+e38AXxLHhYiUwrFRui7iZeUOnTmHW+2+KhVHhvRWUbsODdLHACmD8SY5rkVxoA9p9P8ePg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(66476007)(66946007)(186003)(2906002)(5660300002)(6486002)(86362001)(71200400001)(26005)(478600001)(36756003)(8936002)(64756008)(6506007)(316002)(76116006)(66446008)(54906003)(66556008)(4326008)(91956017)(107886003)(6916009)(2616005)(8676002)(6512007)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: pxA694VNpLnoruzYNKePJmAWjwSlKQAo4Gc8rnRzDz5FcQTlSlqXW0PsH36cFrMYyRfx1QB0RG9K80X/z5+ch8ittHNPa8aW/YUSdJu7Te8urbym5UAmnObnrVHo67/bag/0xWX81ea9QA6Pjz9uale2ghFYIlwgbE/8BuNa9QUihxkh4fDC4gyamM6IwUYYUmkUtapfRz3Gv0Cin6IuKSresXUerbjRRNWMa0gDoY9IhBAo+sFTqq4sbBtapBojAy3hjs1vJQ4av0GbmKTAM/e24Y2z4/M8+TZRLtW1p0lD+va9TnwSIAQ3+CD5JVjbs3+c/N9Xm8ZAf6FMZ9Ym7zYkIrTlZzwZzS+OGfWRLvuDV2FQTncDHad/UomGO4TOufF9Ntd84wZZ7ZgqONlwGHg6GEEhplCtp0CmizE7Tas1CZTAmCQx9/mxkW9ZIPbjTljeP/ZvIt8kk9K8XW7axUyfmRdjXOvHDJb1zN+BCMI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7C3D13677875343A9F5894BF4F8F6B6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eab82a7-962b-4045-fe21-08d8041115f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2020 20:44:30.0186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pd0J4V8VXGVie8zRR2PnVn1jS+CiSbNwtVcUBVcSJGYkVOiY5PoGFef5AJYo7kumOPkryuxgdpxLdgGkNRWhgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6863
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTI5IGF0IDEzOjE2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAyOSBNYXkgMjAyMCAxMjo0Njo0MCAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiAgLyogUmUtc3luYyAqLw0KPiA+ICtzdGF0aWMgc3RydWN0IG1seDVfd3FlX2N0cmxf
c2VnICoNCj4gPiArcmVzeW5jX3Bvc3RfZ2V0X3Byb2dyZXNzX3BhcmFtcyhzdHJ1Y3QgbWx4NWVf
aWNvc3EgKnNxLA0KPiA+ICsJCQkJc3RydWN0IG1seDVlX2t0bHNfb2ZmbG9hZF9jb250ZXh0X3J4
DQo+ID4gKnByaXZfcngpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBtbHg1ZV9rdGxzX3J4X3Jlc3lu
Y19jdHggKnJlc3luYyA9ICZwcml2X3J4LT5yZXN5bmM7DQo+ID4gKwlzdHJ1Y3QgbWx4NWVfZ2V0
X3Rsc19wcm9ncmVzc19wYXJhbXNfd3FlICp3cWU7DQo+ID4gKwlzdHJ1Y3QgbWx4NV93cWVfY3Ry
bF9zZWcgKmNzZWc7DQo+ID4gKwlzdHJ1Y3QgbWx4NV9zZWdfZ2V0X3BzdiAqcHN2Ow0KPiA+ICsJ
dTE2IHBpOw0KPiA+ICsNCj4gPiArCWRtYV9zeW5jX3NpbmdsZV9mb3JfZGV2aWNlKHJlc3luYy0+
cHJpdi0+bWRldi0+ZGV2aWNlLA0KPiA+ICsJCQkJICAgcmVzeW5jLT5kbWFfYWRkciwNCj4gPiAr
CQkJCSAgIFBST0dSRVNTX1BBUkFNU19QQURERURfU0laRSwNCj4gPiArCQkJCSAgIERNQV9GUk9N
X0RFVklDRSk7DQo+ID4gKwlCVUlMRF9CVUdfT04oTUxYNUVfS1RMU19HRVRfUFJPR1JFU1NfV1FF
QkJTICE9IDEpOw0KPiA+ICsJaWYgKHVubGlrZWx5KCFtbHg1ZV93cWNfaGFzX3Jvb21fZm9yKCZz
cS0+d3EsIHNxLT5jYywgc3EtPnBjLA0KPiA+IDEpKSkNCj4gPiArCQlyZXR1cm4gRVJSX1BUUigt
RU5PU1BDKTsNCj4gDQo+IEkgdGhvdWdodCB5b3Ugc2FpZCB0aGF0IHJlc3luYyByZXF1ZXN0cyBh
cmUgZ3VhcmFudGVlZCB0byBuZXZlciBmYWlsPw0KPiANCg0KSSBkaWRuJ3Qgc2F5IHRoYXQgOiks
IG1heWJlIHRhcmlxIGRpZCBzYXkgdGhpcyBiZWZvcmUgbXkgcmV2aWV3LA0KYnV0IGJhc2ljYWxs
eSB3aXRoIHRoZSBjdXJyZW50IG1seDUgYXJjaCwgaXQgaXMgaW1wb3NzaWJsZSB0byBndWFyYW50
ZWUNCnRoaXMgdW5sZXNzIHdlIG9wZW4gMSBzZXJ2aWNlIHF1ZXVlIHBlciBrdGxzIG9mZmxvYWRz
IGFuZCB0aGF0IGlzIGdvaW5nDQp0byBiZSBhbiBvdmVya2lsbCENCg0KVGhpcyBpcyBhIHJhcmUg
Y29ybmVyIGNhc2UgYW55d2F5LCB3aGVyZSBtb3JlIHRoYW4gMWsgdGNwIGNvbm5lY3Rpb25zDQpz
aGFyaW5nIHRoZSBzYW1lIFJYIHJpbmcgd2lsbCByZXF1ZXN0IHJlc3luYyBhdCB0aGUgc2FtZSBl
eGFjdCBtb21lbnQuIA0KDQo+ID4gKwlwaSA9IG1seDVlX2ljb3NxX2dldF9uZXh0X3BpKHNxLCAx
KTsNCj4gPiArCXdxZSA9IE1MWDVFX1RMU19GRVRDSF9HRVRfUFJPR1JFU1NfUEFSQU1TX1dRRShz
cSwgcGkpOw0KPiA+ICsNCj4gPiArI2RlZmluZSBHRVRfUFNWX0RTX0NOVCAoRElWX1JPVU5EX1VQ
KHNpemVvZigqd3FlKSwNCj4gPiBNTFg1X1NFTkRfV1FFX0RTKSkNCj4gPiArDQo+ID4gKwljc2Vn
ID0gJndxZS0+Y3RybDsNCj4gPiArCWNzZWctPm9wbW9kX2lkeF9vcGNvZGUgPQ0KPiA+ICsJCWNw
dV90b19iZTMyKChzcS0+cGMgPDwgOCkgfCBNTFg1X09QQ09ERV9HRVRfUFNWIHwNCj4gPiArCQkJ
ICAgIChNTFg1X09QQ19NT0RfVExTX1RJUl9QUk9HUkVTU19QQVJBTVMgPDwNCj4gPiAyNCkpOw0K
PiA+ICsJY3NlZy0+cXBuX2RzID0NCj4gPiArCQljcHVfdG9fYmUzMigoc3EtPnNxbiA8PCBNTFg1
X1dRRV9DVFJMX1FQTl9TSElGVCkgfA0KPiA+IEdFVF9QU1ZfRFNfQ05UKTsNCj4gPiArDQo+ID4g
Kwlwc3YgPSAmd3FlLT5wc3Y7DQo+ID4gKwlwc3YtPm51bV9wc3YgICAgICA9IDEgPDwgNDsNCj4g
PiArCXBzdi0+bF9rZXkgICAgICAgID0gc3EtPmNoYW5uZWwtPm1rZXlfYmU7DQo+ID4gKwlwc3Yt
PnBzdl9pbmRleFswXSA9IGNwdV90b19iZTMyKHByaXZfcngtPnRpcm4pOw0KPiA+ICsJcHN2LT52
YSAgICAgICAgICAgPSBjcHVfdG9fYmU2NChwcml2X3J4LT5yZXN5bmMuZG1hX2FkZHIpOw0KPiA+
ICsNCj4gPiArCWljb3NxX2ZpbGxfd2koc3EsIHBpLCBNTFg1RV9JQ09TUV9XUUVfR0VUX1BTVl9U
TFMsIDEsIHByaXZfcngpOw0KPiA+ICsJc3EtPnBjKys7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIGNz
ZWc7DQo+ID4gK30NCg==
