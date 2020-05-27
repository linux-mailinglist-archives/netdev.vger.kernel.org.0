Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF11F1E49EA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391056AbgE0QYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:24:05 -0400
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:1142
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391022AbgE0QYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:24:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpDGKi4aYvNLmB4UITPWRCZBorK0j1p++3l9oZU/S8H9gDHeZ09CJ+dqxom/JX3Lpn5xdHB3xFApGlBIK6Ggo/pUrMPrVtAMUGqVfeQ49LYXqgVWvULuHRMgl1mCVCQCfmPmDRkdlCqPB9np1+lsnORVs6pqEK0ED9W8LZN/GuIT8JX4D7Krs2Qt7HBYnGmOrIbcCxpWstfFdwnLRUrkZHBiC8PI9airiwZLO5Iyfw0xzsTB65fdYJo8J+YQN1MPVcKW8W19/AcNWApuI/LWJw5uVGciebmPKT8M64ugiNkImfHsJmuyvKcsH6BrVRr0i+1ErRtSMw0yid98dcr56g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CrRlJoFucLC066RgI2MkMtjWmVI2AX+aN6RGKPW6jY=;
 b=al8rl8pgIa/laIPQlRUkXzyXpARF4OwNOvPAcPW6hwgYsm7Amj5rNsQqxHiVzOM5T7a7wQb4Lwu4oJTwjPxOrWk5w/mGv54Pj/hkKcG04UMpiGXD/20253o/l0fUnVO12nr5P7rEFDMdW7R6l0omsJv/BzA0tv360BT5W73iWc9yvRzr647Kzx6B1RaGNiRYUovGtb93kAKmdgeCtVELyzBN/rXnehVDiCP27MwgInHikCw+IJOWYmElKdAydMIRUNZVyPIcpd/Qa53d3i8rvjofqNcj8yZt7gGfDporr+FnyrSJ+4i8LPlKkFMODaLHWH8Ntk1Pu8hsXNvfICxxpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CrRlJoFucLC066RgI2MkMtjWmVI2AX+aN6RGKPW6jY=;
 b=bA1NkLa//V+6Hn6ONR64l73ymWzHZc8vbcN68D3Cvv4iHdMZIo6n1nmIhrtBko1Ag+P9ml+EPn0ujaTshN4yVAtYgKoDqcuasOWLcyJ3YXjMafyoLpCNqYTSOUIvk1Fjbj5tWMC6/k0LfROWaySeebzaU3SKWMV1i3+J5BEI3/w=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4589.eurprd05.prod.outlook.com (2603:10a6:802:63::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 16:24:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:24:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: Re: [PATCH net-next] mlx5: fix xdp data_meta setup in
 mlx5e_fill_xdp_buff
Thread-Topic: [PATCH net-next] mlx5: fix xdp data_meta setup in
 mlx5e_fill_xdp_buff
Thread-Index: AQHWNCzwqaT7tlDgcE+aJr9FLtW9nai7+DUAgAAl4wA=
Date:   Wed, 27 May 2020 16:24:00 +0000
Message-ID: <00b84a99d52d5828d95a9b32bff81fc8f8b4aef4.camel@mellanox.com>
References: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
         <159058704935.247267.18235681992710936316.stgit@firesoul>
         <41538e35-cc81-73b5-a63d-42a7176c1e74@gmail.com>
In-Reply-To: <41538e35-cc81-73b5-a63d-42a7176c1e74@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d036d6a-a255-4f10-ad42-08d8025a5cfa
x-ms-traffictypediagnostic: VI1PR05MB4589:
x-microsoft-antispam-prvs: <VI1PR05MB45897044D4D0BD80D4322827BEB10@VI1PR05MB4589.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VDxcscb5BHr4VfZP6HvcaKFq2TYYJi2U18bSzsXDaNG6Xg5ZaD2wtCYXcsiEfSYSYmUV66zE57UDnIzkGFDHUlNdYE+QFQjq+eWSbiPW1Yq45rZ1SP/MYbiGH/ykrPwMJSfYz4pLOlNMl7gd+HL7MJqx2zyaBo5SJhGLtecQLylvnvF7mRuXdcB2aomxCsdsybpczR9RT67v3o4kWBEgWBwzshMEd17HHci6Nhtd1dY+BNehQIn/WTIPy2SgY80v4zX4axAq9YZfYhiJBE6dT8Ee3xZuF07g0eCQD/yyuwX5LiVFoujD0VBLOicxB9ThKppsP8j6Izi3NuygRIfpEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(36756003)(6506007)(86362001)(186003)(53546011)(316002)(110136005)(71200400001)(5660300002)(2906002)(26005)(66476007)(66556008)(91956017)(66946007)(8936002)(64756008)(2616005)(6512007)(76116006)(6486002)(8676002)(478600001)(83380400001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: C3Fh550uyCFs0Jf1Mq33fS2iDjRtBwPHE5+bdBOLUDXKPOLXipKxWrpAqJisR6/oIhTBi88RVoYODs+rTho7kbxJP2mDABT6CLfb76gTqSFUnGQ+ISGFvCg/Tu4ODhjkpi6J59aj+EoRxzFydlhNKzxqFZhTrnF5m5k5Mm7SluYOEraM2wfaM3HuRRozVmMRP8aN625JNEkUNhrt1wyskGop3e3Z6TLXQW5trDoC95Zyxg17VwQFMrFm93MT/HtR4JDNnypBFqmSOotr1tq2VUEY/zfI5hI+/8tzA+X51bUoC+aBoU22BvI+jUiJtmSWqOgfvUha83Ui6Yb+1glISaByetl7n31q8beu3JXh5iiSHEeAm5jkmHag08jPPyq39nobSE6r93nPOiukuWgL1UV/iL23lLrxbF3nj1ydkom3ExbiA0mSV5IqYNqhATRJJYejWUmDBOpTOeHlFXhntliO0IENbfoZGshxL3VkMWE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <589CBC46187EC24889BAD7D807092272@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d036d6a-a255-4f10-ad42-08d8025a5cfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 16:24:00.1890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hkKsmuWqve0H7KiIHgCJepJF2hSAZsyWu6GaPnnb9s1CEMua039o23Q519fVVNbvPc7fioWv+gQ2XPFiJ/8QWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA1LTI3IGF0IDA4OjA4IC0wNjAwLCBEYXZpZCBBaGVybiB3cm90ZToNCj4g
T24gNS8yNy8yMCA3OjQ0IEFNLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIHdyb3RlOg0KPiA+IFRo
ZSBoZWxwZXIgZnVuY3Rpb24geGRwX3NldF9kYXRhX21ldGFfaW52YWxpZCgpIG11c3QgYmUgY2Fs
bGVkDQo+ID4gYWZ0ZXINCj4gPiBzZXR0aW5nIHhkcC0+ZGF0YSBhcyBpdCBkZXBlbmRzIG9uIGl0
Lg0KPiA+IA0KPiA+IFRoZSBidWcgd2FzIGludHJvZHVjZWQgaW4gMzlkNjQ0M2M4ZGFmICgibWx4
NSwgeHNrOiBNaWdyYXRlIHRvDQo+ID4gbmV3IE1FTV9UWVBFX1hTS19CVUZGX1BPT0wiKSwgYW5k
IGNhdXNlIHRoZSBrZXJuZWwgdG8gY3Jhc2ggd2hlbg0KPiA+IHVzaW5nIEJQRiBoZWxwZXIgYnBm
X3hkcF9hZGp1c3RfaGVhZCgpIG9uIG1seDUgZHJpdmVyLg0KPiA+IA0KPiA+IEZpeGVzOiAzOWQ2
NDQzYzhkYWYgKCJtbHg1LCB4c2s6IE1pZ3JhdGUgdG8gbmV3DQo+ID4gTUVNX1RZUEVfWFNLX0JV
RkZfUE9PTCIpDQo+ID4gUmVwb3J0ZWQtYnk6IERhdmlkIEFoZXJuIDxkc2FoZXJuQGtlcm5lbC5v
cmc+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8YnJvdWVyQHJl
ZGhhdC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl9yeC5jIHwgICAgMiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yeC5jDQo+ID4gaW5kZXggNmIzYzgyZGExOTlj
Li5kYmIxYzYzMjM5NjcgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX3J4LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fcnguYw0KPiA+IEBAIC0xMDU2LDggKzEwNTYsOCBAQCBzdGF0
aWMgdm9pZCBtbHg1ZV9maWxsX3hkcF9idWZmKHN0cnVjdA0KPiA+IG1seDVlX3JxICpycSwgdm9p
ZCAqdmEsIHUxNiBoZWFkcm9vbSwNCj4gPiAgCQkJCXUzMiBsZW4sIHN0cnVjdCB4ZHBfYnVmZiAq
eGRwKQ0KPiA+ICB7DQo+ID4gIAl4ZHAtPmRhdGFfaGFyZF9zdGFydCA9IHZhOw0KPiA+IC0JeGRw
X3NldF9kYXRhX21ldGFfaW52YWxpZCh4ZHApOw0KPiA+ICAJeGRwLT5kYXRhID0gdmEgKyBoZWFk
cm9vbTsNCj4gPiArCXhkcF9zZXRfZGF0YV9tZXRhX2ludmFsaWQoeGRwKTsNCj4gPiAgCXhkcC0+
ZGF0YV9lbmQgPSB4ZHAtPmRhdGEgKyBsZW47DQo+ID4gIAl4ZHAtPnJ4cSA9ICZycS0+eGRwX3J4
cTsNCj4gPiAgCXhkcC0+ZnJhbWVfc3ogPSBycS0+YnVmZi5mcmFtZTBfc3o7DQo+ID4gDQo+ID4g
DQo+IA0KPiBnb29kIGNhdGNoLiBJIGxvb2tlZCByaWdodCBwYXN0IHRoYXQgeWVzdGVyZGF5Lg0K
PiANCj4gVGVzdGVkLWJ5OiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+DQoNCkFwcGxp
ZWQgdG8gbmV0LW5leHQtbWx4NSwgd2lsbCBzZW5kIHNob3J0bHkgdG8gbmV0LW5leHQuDQpUaGFu
a3MsDQpTYWVlZC4NCg0K
