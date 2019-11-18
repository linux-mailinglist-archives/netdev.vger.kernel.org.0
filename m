Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC5CFFEAD
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 07:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfKRGra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 01:47:30 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:6881
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726455AbfKRGra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 01:47:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClbUJzAJfO56LJ6z5ejaeP3xmnLq0QPFuJudzMgXmwuGFJNCZwBWhkf64nhrigne5COhXxSRVJu6svorh9xhphApkN6K47JsuZiUA+nxL/0dIeg5j1bsi//fc6wygmRqMq3ZU5T3Ki6CYbod6ReFqqBBvuX+J+QtGwMWzh0Svl6LFDjIljIckbV3gHqO2EGsQrK1O0Bm499B6rTLPdIsICBCg+FDjxCjxfbY9brD7ZyTVxVklYjCfJsznvsMXrCuoz1+gQS3/UaUFKMnEo1PAkB1MFn5+weqK68log2SebJKftyhBnaP8HFUQeCir4aaA0WCrzssIb1uI7MKmyasDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f40IAwoCouPB0E02C/mSpk7GIS4mxEFebZTaMpQHrOo=;
 b=fxt9W08+VScyBwvMJtRHFc1DvZzskSz5ONYXPmks3oqGnUVf0tI8gLATEMTxc4FkX/V9cmaQtpQfl8dIhVEXF7b4GOI7TvbRRNsTMFZZfGEDddOPMG+8m6vkWU5xjcfbJsPcPvv2XHyAGv4e22yP0YoLy7dVPBvPI+DbpXDLXOe/2OiqcdQ25V1+Ff+Z+nf226TV/dcM+amjVS5v2c5WY+FAnh9icNmCvWfZXnEyCibN+xkVcIPLO3ek2WQadYjydXSijiAwul+L/bu4bY7C0+8o37K8HYeZmR68lckZZ16LtVzxzQ1R7+YEs3cEY5rBTuUkA+fNqapxq7Rj8A9DFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f40IAwoCouPB0E02C/mSpk7GIS4mxEFebZTaMpQHrOo=;
 b=njQBIcfxEHLwzmxpUn+d0xQmv4FhY1YUz6bTuW/jG7EcK0LWBLr/BGhqld20mNsYFMPDWg1ZHjHfAhSg5dIiokystOiyNbrlgCCL6sJDdCvQpKYnU7SUrh9jCLxeDjK6DtdWQ5Qxzu3yKPOr+JfzsVuSWrmymnoaJCxkil+QwL8=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3903.eurprd04.prod.outlook.com (52.134.16.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Mon, 18 Nov 2019 06:47:26 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625%7]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 06:47:26 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Chuhong Yuan <hslester96@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net v2] net: fec: add a check for CONFIG_PM to
 avoid clock count mis-match
Thread-Topic: [EXT] Re: [PATCH net v2] net: fec: add a check for CONFIG_PM to
 avoid clock count mis-match
Thread-Index: AQHVm/DMOznlKnTJFkKJdT1jxlx3n6eNXN9wgAB3nYCAAqiLsA==
Date:   Mon, 18 Nov 2019 06:47:26 +0000
Message-ID: <VI1PR0402MB36002B858030B02BCBCA8500FF4D0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191112112830.27561-1-hslester96@gmail.com>
 <20191115.121050.591805779332799354.davem@davemloft.net>
 <VI1PR0402MB3600CE74E0EC86AC97F25026FF730@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CANhBUQ1VZMV4MKqs95mJnZPLeDnhAgjgLTSaqL_pY08GGzM-mQ@mail.gmail.com>
In-Reply-To: <CANhBUQ1VZMV4MKqs95mJnZPLeDnhAgjgLTSaqL_pY08GGzM-mQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e6ec7cf7-2784-4c5d-0b6a-08d76bf32c7e
x-ms-traffictypediagnostic: VI1PR0402MB3903:
x-microsoft-antispam-prvs: <VI1PR0402MB3903E8EA404B536131863955FF4D0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:530;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(189003)(199004)(33656002)(25786009)(102836004)(76176011)(4326008)(7696005)(6246003)(86362001)(64756008)(66446008)(8676002)(26005)(81166006)(81156014)(8936002)(52536014)(6916009)(66946007)(14444005)(256004)(76116006)(14454004)(1411001)(99286004)(229853002)(11346002)(476003)(486006)(71190400001)(71200400001)(186003)(3846002)(446003)(66476007)(66556008)(6116002)(5660300002)(2906002)(316002)(66066001)(54906003)(55016002)(6436002)(9686003)(74316002)(478600001)(305945005)(53546011)(6506007)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3903;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NkBH+UWOE7JWMkb7kWjWSg4Akxl/vdkDp/6zuiVXtbAUm4YnMYDu0C+VE1a8phERMioc3aaAfdEUSKxEbuFcO04D8EOn4wsOYIXZB+4oh52hli6Koi09cF7YY8Lre4C7iiHu3VHw6dudGPh95X5DuNKtT6hcjOZft2IZ789IunJdjFGehZBAGrLxsupYM2/INT881zPloIoeCV5fJW0uA+/Ib7FuZslVPoD9lhr44f4N+z+0StIGVz4PxlCSCJsbf1xCqR5vxJGEDXgAhedeklbS2iVyxSQ2zyBJwYqaM7vhgn9In3M16YIByLNnPtAH9E60ZDynjKkF4GnfnX3DRzp1LwLp9JtFQ3Z/qReUwjDIxXRr69D7E7zjx2iITy/EZOzSQC0f7rKZOmnqw4AiCsarbtecbyVJZWpWzqbvQ8OfKHjYEd1InCH3wO9MoHAT
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ec7cf7-2784-4c5d-0b6a-08d76bf32c7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 06:47:26.2888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WjbNk1UqqXS81HNnRxdgYS27RA6F2h+gAULJk47NahHefIySIl0Zo5VRldXyc/LsGQrYGaHS5VkIXUaQcpj4ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2h1aG9uZyBZdWFuIDxoc2xlc3Rlcjk2QGdtYWlsLmNvbT4gU2VudDogU2F0dXJkYXks
IE5vdmVtYmVyIDE2LCAyMDE5IDEwOjAwIFBNDQo+IE9uIFNhdCwgTm92IDE2LCAyMDE5IGF0IDI6
NTcgUE0gQW5keSBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZy
b206IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4gU2VudDogU2F0dXJkYXksIE5v
dmVtYmVyIDE2LA0KPiA+IDIwMTkgNDoxMSBBTQ0KPiA+ID4gRnJvbTogQ2h1aG9uZyBZdWFuIDxo
c2xlc3Rlcjk2QGdtYWlsLmNvbT4NCj4gPiA+IERhdGU6IFR1ZSwgMTIgTm92IDIwMTkgMTk6Mjg6
MzAgKzA4MDANCj4gPiA+DQo+ID4gPiA+IElmIENPTkZJR19QTSBpcyBlbmFibGVkLCBydW50aW1l
IHBtIHdpbGwgd29yayBhbmQgY2FsbA0KPiA+ID4gPiBydW50aW1lX3N1c3BlbmQgYXV0b21hdGlj
YWxseSB0byBkaXNhYmxlIGNsa3MuDQo+ID4gPiA+IFRoZXJlZm9yZSwgcmVtb3ZlIG9ubHkgbmVl
ZHMgdG8gZGlzYWJsZSBjbGtzIHdoZW4gQ09ORklHX1BNIGlzDQo+IGRpc2FibGVkLg0KPiA+ID4g
PiBBZGQgdGhpcyBjaGVjayB0byBhdm9pZCBjbG9jayBjb3VudCBtaXMtbWF0Y2ggY2F1c2VkIGJ5
IGRvdWJsZS1kaXNhYmxlLg0KPiA+ID4gPg0KPiA+ID4gPiBGaXhlczogYzQzZWFiM2VkZGI0ICgi
bmV0OiBmZWM6IGFkZCBtaXNzZWQgY2xrX2Rpc2FibGVfdW5wcmVwYXJlDQo+ID4gPiA+IGluDQo+
ID4gPiA+IHJlbW92ZSIpDQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IENodWhvbmcgWXVhbiA8aHNs
ZXN0ZXI5NkBnbWFpbC5jb20+DQo+ID4gPg0KPiA+ID4gWW91ciBleHBsYW5hdGlvbiBpbiB5b3Vy
IHJlcGx5IHRvIG15IGZlZWRiYWNrIHN0aWxsIGRvZXNuJ3QgZXhwbGFpbg0KPiA+ID4gdGhlIHNp
dHVhdGlvbiB0byBtZS4NCj4gPiA+DQo+ID4gPiBGb3IgZXZlcnkgY2xvY2sgZW5hYmxlIGRvbmUg
ZHVyaW5nIHByb2JlLCB0aGVyZSBtdXN0IGJlIGEgbWF0Y2hpbmcNCj4gPiA+IGNsb2NrIGRpc2Fi
bGUgZHVyaW5nIHJlbW92ZS4NCj4gPiA+DQo+ID4gPiBQZXJpb2QuDQo+ID4gPg0KPiA+ID4gVGhl
cmUgaXMgbm8gQ09ORklHX1BNIGd1YXJkaW5nIHRoZSBjbG9jayBlbmFibGVzIGR1cmluZyBwcm9i
ZSBpbg0KPiA+ID4gdGhpcyBkcml2ZXIsIHRoZXJlZm9yZSB0aGVyZSBzaG91bGQgYmUgbm8gcmVh
c29uIHRvIHJlcXVpcmUNCj4gPiA+IENPTkZJR19QTSBndWFyZHMgdG8gdGhlIGNsb2NrIGRpc2Fi
bGVzIGR1cmluZyB0aGUgcmVtb3ZlIG1ldGhvZCwNCj4gPiA+DQo+ID4gPiBZb3UgaGF2ZSB0byBl
eHBsYWluIGNsZWFybHksIGFuZCBpbiBkZXRhaWwsIHdoeSBteSBsb2dpYyBhbmQNCj4gPiA+IGFu
YWx5c2lzIG9mIHRoaXMgc2l0dWF0aW9uIGlzIG5vdCBjb3JyZWN0Lg0KPiA+ID4NCj4gPiA+IEFu
ZCB3aGVuIHlvdSBkbyBzbywgeW91IHdpbGwgbmVlZCB0byBhZGQgdGhvc2UgaW1wb3J0YW50IGRl
dGFpbHMgdG8NCj4gPiA+IHRoZSBjb21taXQgbWVzc2FnZSBvZiB0aGlzIGNoYW5nZSBhbmQgc3Vi
bWl0IGEgdjMuDQo+ID4gPg0KPiA+ID4gVGhhbmsgeW91Lg0KPiA+DQo+ID4gSSBhZ3JlZSB3aXRo
IERhdmlkLiBCZWxvdyBmaXhlcyBpcyBtb3JlIHJlYXNvbmFibGUuDQo+ID4gQ2h1aG9uZywgaWYg
dGhlcmUgaGFzIG5vIHZvaWNlIGFib3V0IGJlbG93IGZpeGVzLCB5b3UgY2FuIHN1Ym1pdCB2MyBs
YXRlci4NCj4gPg0KPiANCj4gSSBnZXQgY29uZnVzZWQgdGhhdCBob3cgZG9lcyB0aGlzIHdvcmsg
dG8gc29sdmUgdGhlIENPTkZJR19QTSBwcm9ibGVtLg0KPiBBbmQgd2h5IGRvIHdlIG5lZWQgdG8g
YWRqdXN0IHRoZSBwb3NpdGlvbiBvZiB0aGUgbGF0dGVyIGZvdXIgZnVuY3Rpb25zPw0KSnVzdCBs
b29rcyBiZXR0ZXIsIG5vIGZ1bmN0aW9uIGNoYW5nZS4NCj4gSSBuZWVkIHRvIGV4cGxhaW4gdGhl
bSBpbiB0aGUgY29tbWl0IG1lc3NhZ2UuDQoNClBsZWFzZSBzZWUgYmVsb3cgbG9naWMgaW4gcmVt
b3ZlKCk6DQpJZiBDT05GSUdfUE0gaXMgZW5hYmxlZDoNCi5wcm9iZSgpDQplbmFibGUgY2xrcw0K
cG1fcnVudGltZV9tYXJrX2xhc3RfYnVzeSgpDQpwbV9ydW50aW1lX3B1dF9hdXRvc3VzcGVuZCgp
DQogICAgZGlzYWJsZSBjbGtzDQoNCi5yZW1vdmUoKToNCnBtX3J1bnRpbWVfZ2V0X3N5bmMoKQ0K
ICAgIHJ1bnRpbWUgcmVzdW1lIGNhbGxiYWNrIGlzIGNhbGxlZCwgZW5hYmxlIGNsa3MNCmRpc2Fi
bGUgY2xrcw0KcG1fcnVudGltZV9wdXRfbm9pZGxlKCkNCiAgICBydW50aW1lIHN1c3BlbmQgY2Fs
bGJhY2sgaXMgbm90IGNhbGxlZA0KDQoNCklmIENPTkZJR19QTSBpcyBkaXNhYmxlZCwgcnVudGlt
ZSBwbSBpcyBOVUxMIG9wZXJhdGlvbjoNCi5wcm9iZSgpDQogICAgZW5hYmxlIGNsa3MNCi5yZW1v
dmUoKToNCiAgICBkaXNhYmxlIGNsa3MNCg0KDQoNCj4gDQo+ID4gQEAgLTM2MzYsNiArMzYzNiwx
MSBAQCBmZWNfZHJ2X3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiA+ICAg
ICAgICAgc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYgPSBwbGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2
KTsNCj4gPiAgICAgICAgIHN0cnVjdCBmZWNfZW5ldF9wcml2YXRlICpmZXAgPSBuZXRkZXZfcHJp
dihuZGV2KTsNCj4gPiAgICAgICAgIHN0cnVjdCBkZXZpY2Vfbm9kZSAqbnAgPSBwZGV2LT5kZXYu
b2Zfbm9kZTsNCj4gPiArICAgICAgIGludCByZXQ7DQo+ID4gKw0KPiA+ICsgICAgICAgcmV0ID0g
cG1fcnVudGltZV9nZXRfc3luYygmcGRldi0+ZGV2KTsNCj4gPiArICAgICAgIGlmIChyZXQgPCAw
KQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+DQo+ID4gICAgICAgICBjYW5j
ZWxfd29ya19zeW5jKCZmZXAtPnR4X3RpbWVvdXRfd29yayk7DQo+ID4gICAgICAgICBmZWNfcHRw
X3N0b3AocGRldik7DQo+ID4gQEAgLTM2NDMsMTUgKzM2NDgsMTcgQEAgZmVjX2Rydl9yZW1vdmUo
c3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPiAqcGRldikNCj4gPiAgICAgICAgIGZlY19lbmV0X21p
aV9yZW1vdmUoZmVwKTsNCj4gPiAgICAgICAgIGlmIChmZXAtPnJlZ19waHkpDQo+ID4gICAgICAg
ICAgICAgICAgIHJlZ3VsYXRvcl9kaXNhYmxlKGZlcC0+cmVnX3BoeSk7DQo+ID4gLSAgICAgICBw
bV9ydW50aW1lX3B1dCgmcGRldi0+ZGV2KTsNCj4gPiAtICAgICAgIHBtX3J1bnRpbWVfZGlzYWJs
ZSgmcGRldi0+ZGV2KTsNCj4gPiAtICAgICAgIGNsa19kaXNhYmxlX3VucHJlcGFyZShmZXAtPmNs
a19haGIpOw0KPiA+IC0gICAgICAgY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGZlcC0+Y2xrX2lwZyk7
DQo+ID4gKw0KPiA+ICAgICAgICAgaWYgKG9mX3BoeV9pc19maXhlZF9saW5rKG5wKSkNCj4gPiAg
ICAgICAgICAgICAgICAgb2ZfcGh5X2RlcmVnaXN0ZXJfZml4ZWRfbGluayhucCk7DQo+ID4gICAg
ICAgICBvZl9ub2RlX3B1dChmZXAtPnBoeV9ub2RlKTsNCj4gPiAgICAgICAgIGZyZWVfbmV0ZGV2
KG5kZXYpOw0KPiA+DQo+ID4gKyAgICAgICBjbGtfZGlzYWJsZV91bnByZXBhcmUoZmVwLT5jbGtf
YWhiKTsNCj4gPiArICAgICAgIGNsa19kaXNhYmxlX3VucHJlcGFyZShmZXAtPmNsa19pcGcpOw0K
PiA+ICsgICAgICAgcG1fcnVudGltZV9wdXRfbm9pZGxlKCZwZGV2LT5kZXYpOw0KPiA+ICsgICAg
ICAgcG1fcnVudGltZV9kaXNhYmxlKCZwZGV2LT5kZXYpOw0KPiA+ICsNCj4gPiAgICAgICAgIHJl
dHVybiAwOw0KPiA+ICB9DQo+ID4NCj4gPiBSZWdhcmRzLA0KPiA+IEZ1Z2FuZyBEdWFuDQo=
