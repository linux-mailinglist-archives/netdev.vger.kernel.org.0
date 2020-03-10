Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B4B180C68
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgCJXeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:34:22 -0400
Received: from mail-eopbgr10089.outbound.protection.outlook.com ([40.107.1.89]:13380
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726463AbgCJXeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 19:34:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lb7+76sGE5JxA66WswRghr97+5kKQPXKu7WfHxAPHFgdlShT58ok5zzdqpezBBrknDsmomv9Hz1dM7SSijNMiesjoJV7ENwMEsMcxwvbC1A+Y1HUZGtU7XnSa8+PAW50JKAN/v19P/+RvSyYIj8k+GgrHIEsUL3jytX/IrLSyPRRVO5tJ2kGp8+snFK1xxBp+nrNznXOH1kpOzHjr2hT5NcCrNoU86X9oMp/127z5lZIHXjB64gq8aoWTkyYlLr82cmRg0x6YvE8gx+SjSAO4u98SJiZoMlD4cr1Igam/SDclD+J5F3HZOoCC+6AltuxTmJe7T8RBqNl3cW5oh3cfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3xrpc59fRhzxCySD3K8EPFmYmkDFtLsCdGxa4E3cM8=;
 b=PeqG27LxFofR4BD3vUuN+DZXxWOqAh8UuZUpTtlm/XLYQgHP9Ngwvv3n+q/n3Pa9UcbYuJpZmAnWWRFuY1iecXtPzFzLoztz1AKpn/kvzPI8NYNSWDONR6KtPw8QsSKJlbXzExm2gPZ++kvFjE/SnubzG6ZWfLhC3H4nZAHSTEbKoIBxgcgCdftpIiBbNBCbqD4TnzK28hqyqo74CXTdtVvxNMw/DDAYzrmHDxl62OhmWuhL5F1R2T71rUPoHHOLTec+DW9u532/42nzB+l0uhmVkfs9srE26zkKc1tqQrDqRTzo4mOaaYArBSmu6fL6ensO/nHaIzQivWU2ZjxQIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3xrpc59fRhzxCySD3K8EPFmYmkDFtLsCdGxa4E3cM8=;
 b=Swz/0knfE1mwC5zdQuFAntjwyNT/osGzDi/ox3yVBPc98szxNa7Tj/yan3WxKoiZhzx/ShnjG1Mcix66V74aqrIUCIrGa3EDPOk1X9snJOSXPNb6Djz6A2htt9qVKJaLat59aseNX1PBi52XLUMEa4E26BOVTCDk3J+u+lkcVG8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4208.eurprd05.prod.outlook.com (10.171.183.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.14; Tue, 10 Mar 2020 23:34:17 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 23:34:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH] page_pool: use irqsave/irqrestore to protect ring access.
Thread-Topic: [PATCH] page_pool: use irqsave/irqrestore to protect ring
 access.
Thread-Index: AQHV9kvf9xbvvfqL9UebbKngICNOR6hBAJ0AgAAaiICAAPTqAIAAbCoA
Date:   Tue, 10 Mar 2020 23:34:16 +0000
Message-ID: <a6a88962951a9bfdb69facaadf45a6b6cf5aa625.camel@mellanox.com>
References: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
         <20200309.175534.1029399234531592179.davem@davemloft.net>
         <9b09170da05fb59bde7b003be282dfa63edd969e.camel@mellanox.com>
         <D6B9A0EF-61FA-40A9-AED3-4B4927FD9115@gmail.com>
In-Reply-To: <D6B9A0EF-61FA-40A9-AED3-4B4927FD9115@gmail.com>
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
x-ms-office365-filtering-correlation-id: 9f073287-1c03-446b-6803-08d7c54b8cb7
x-ms-traffictypediagnostic: VI1PR05MB4208:
x-microsoft-antispam-prvs: <VI1PR05MB42085A22E4113F10B685C281BEFF0@VI1PR05MB4208.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(199004)(189003)(54906003)(8936002)(5660300002)(4326008)(36756003)(64756008)(6486002)(8676002)(66556008)(66476007)(91956017)(81156014)(6512007)(81166006)(86362001)(2906002)(76116006)(316002)(66446008)(66946007)(2616005)(53546011)(71200400001)(26005)(478600001)(186003)(6506007)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4208;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NFvN0KnzA/cs+rTT5OKfyC+XWoJEpfA2lVJcUDRdheH0kopSiiB3wt2CJDxRX2PSqe2/bJyfjxWFQL+HkaEfp2KBDuJamR+d/kc8NoVbEaecADsqxANKEtiCACn9DzkzXikWCiIC/0rwGDCg6cjFX/MgS4U9omXfRoi/burxJUt4BpnTYlzbyR3iMzUSyvuawPf4F0ESdTcSsWS3vUF+93CXsHaF6nWZHzm5DusugHn0EWyDLZ4UJt0pCX/uGCcsycDloVOnme5eWE4ec4M2w/b2eSoF3lF/FxmRSCpbExyxh1B0P/65ZP9xtglla0IE9gKw8DC5uupFBAfVpcCnl31x7IW50DKttcbmsJ5I2uASO8LJRVAJ0XORJqX2f7aR56krho6jFg7Qs7PxiuZEhZyK/+DjtEJadsOm83veN6Abmc1d8Ohz+Kisf5wq5QsE
x-ms-exchange-antispam-messagedata: N18wlG06Fn2kuf0mFWsU9D1v5i3eaq9rgU76V9NU0tE+srK0lQXYegY7/oXm66awEOMVfjvlYcGf7qazAXEC5HMucaGKoiSCP1yZby96HaPLy4FIdBXqg8K1kw0wcr/uGRiT0iPdCNI9X0gI8C+FjQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <87DB66CED67A1D478F6114D47F44A475@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f073287-1c03-446b-6803-08d7c54b8cb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2020 23:34:16.9334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uw2Gm/J5lCAmcwpcfQnAZaDtlWpcyBz+oXIOsS8yQ7Uak/YBeaO8pTjB0e+VmxdQRdOrkxMRx8Dx/5O9BEjkIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAzLTEwIGF0IDEwOjA3IC0wNzAwLCBKb25hdGhhbiBMZW1vbiB3cm90ZToN
Cj4gDQo+IE9uIDkgTWFyIDIwMjAsIGF0IDE5OjMwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4g
DQo+ID4gT24gTW9uLCAyMDIwLTAzLTA5IGF0IDE3OjU1IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3Jv
dGU6DQo+ID4gPiBGcm9tOiBKb25hdGhhbiBMZW1vbiA8am9uYXRoYW4ubGVtb25AZ21haWwuY29t
Pg0KPiA+ID4gRGF0ZTogTW9uLCA5IE1hciAyMDIwIDEyOjQ5OjI5IC0wNzAwDQo+ID4gPiANCj4g
PiA+ID4gbmV0cG9sbCBtYXkgYmUgY2FsbGVkIGZyb20gSVJRIGNvbnRleHQsIHdoaWNoIG1heSBh
Y2Nlc3MgdGhlDQo+ID4gPiA+IHBhZ2UgcG9vbCByaW5nLiAgVGhlIGN1cnJlbnQgX2JoIHZhcmlh
bnRzIGRvIG5vdCBwcm92aWRlDQo+ID4gPiA+IHN1ZmZpY2llbnQNCj4gPiA+ID4gcHJvdGVjdGlv
biwgc28gdXNlIGlycXNhdmUvcmVzdG9yZSBpbnN0ZWFkLg0KPiA+ID4gPiANCj4gPiA+ID4gRXJy
b3Igb2JzZXJ2ZWQgb24gYSBtb2RpZmllZCBtbHg0IGRyaXZlciwgYnV0IHRoZSBjb2RlIHBhdGgN
Cj4gPiA+ID4gZXhpc3RzDQo+ID4gPiA+IGZvciBhbnkgZHJpdmVyIHdoaWNoIGNhbGxzIHBhZ2Vf
cG9vbF9yZWN5Y2xlIGZyb20gbmFwaSBwb2xsLg0KPiA+ID4gPiANCj4gPiA+ID4gV0FSTklORzog
Q1BVOiAzNCBQSUQ6IDU1MDI0OCBhdCAvcm8vc291cmNlL2tlcm5lbC9zb2Z0aXJxLmM6MTYxDQo+
ID4gPiBfX2xvY2FsX2JoX2VuYWJsZV9pcCsweDM1LzB4NTANCj4gPiA+ICAuLi4NCj4gPiA+ID4g
U2lnbmVkLW9mZi1ieTogSm9uYXRoYW4gTGVtb24gPGpvbmF0aGFuLmxlbW9uQGdtYWlsLmNvbT4N
Cj4gPiA+IA0KPiA+ID4gVGhlIG5ldHBvbGwgc3R1ZmYgYWx3YXlzIG1ha2VzIHRoZSBsb2NraW5n
IG1vcmUgY29tcGxpY2F0ZWQgdGhhbg0KPiA+ID4gaXQNCj4gPiA+IG5lZWRzDQo+ID4gPiB0byBi
ZS4gIEkgd29uZGVyIGlmIHRoZXJlIGlzIGFub3RoZXIgd2F5IGFyb3VuZCB0aGlzIGlzc3VlPw0K
PiA+ID4gDQo+ID4gPiBCZWNhdXNlIElSUSBzYXZlL3Jlc3RvcmUgaXMgYSBoaWdoIGNvc3QgdG8g
cGF5IGluIHRoaXMgY3JpdGljYWwNCj4gPiA+IHBhdGguDQo+ID4gDQo+ID4gYSBwcmludGsgaW5z
aWRlIGlycSBjb250ZXh0IGxlYWQgdG8gdGhpcywgc28gbWF5YmUgaXQgY2FuIGJlDQo+ID4gYXZv
aWRlZCAuLg0KPiANCj4gVGhpcyB3YXMgY2F1c2VkIGJ5IGEgcHJpbnRrIGluIGhwZXRfcnRjX3Rp
bWVyX3JlaW5pdCgpIGNvbXBsYWluaW5nDQo+IGFib3V0DQo+IFJUQyBpbnRlcnJ1cHRzIGJlaW5n
IGxvc3QuICBJJ20gbm90IHN1cmUgaXQncyBwcmFjdGljYWwgdHJ5aW5nIHRvDQo+IGxvY2F0ZQ0K
PiBhbGwgdGhlIHByaW50ayBjYXNlcyBsaWtlIHRoaXMuDQo+IA0KPiANCj4gPiBvciBpbnN0ZWFk
IG9mIGNoZWNraW5nIGluX3NlcnZpbmdfc29mdGlycSgpICBjaGFuZ2UgcGFnZV9wb29sIHRvDQo+
ID4gY2hlY2sgaW5faW50ZXJydXB0KCkgd2hpY2ggaXMgbW9yZSBwb3dlcmZ1bCwgdG8gYXZvaWQg
cHRyX3JpbmcNCj4gPiBsb2NraW5nDQo+ID4gYW5kIHRoZSBjb21wbGljYXRpb24gd2l0aCBuZXRw
b2xsIGFsdG9nZXRoZXIuDQo+IA0KPiBUaGF0J3MgYW5vdGhlciBhcHByb2FjaDoNCj4gDQo+ICAg
ICByZXQgPSAxOw0KPiAgICAgaWYgKCFpbl9pcnEoKSkgew0KPiAgICAgICAgIGlmIChpbl9zZXJ2
aW5nX3NvZnRpcnEoKSkNCj4gICAgICAgICAgICAgcmV0ID0gcHRyX3JpbmdfcHJvZHVjZSguLi4u
DQo+ICAgICAgICAgZWxzZQ0KPiAgICAgICAgICAgICByZXQgPSBwdHJfcmluZ19wcm9kdWNlX2Jo
KC4uLi4NCj4gICAgIH0NCj4gDQo+IHdoaWNoIHdvdWxkIHJldHVybiBmYWlsdXJlIGFuZCByZWxl
YXNlIHRoZSBwYWdlIGZyb20gdGhlIHBhZ2UgcG9vbC4NCj4gVGhpcyBkb2Vzbid0IGFkZHJlc3Mg
dGhlIGFsbG9jYXRpb24gb3IgdGhlIGJ1bGsgcmVsZWFzZSBwYXRoLg0KPiANCj4gDQo+ID4gSSB3
b25kZXIgd2h5IEplc3BlciBwaWNrZWQgaW5fc2VydmluZ19zb2Z0aXJxKCkgaW4gZmlyc3QgcGxh
Y2UsIHdhcw0KPiA+IHRoZXJlIGEgc3BlY2lmaWMgcmVhc29uID8gb3IgaGUganVzdCB3YW50ZWQg
aXQgdG8gYmUgYXMgbGVzcyBzdHJpY3QNCj4gPiBhcw0KPiA+IHBvc3NpYmxlID8NCj4gDQo+IEZy
b20gdGhlIGNvZGUsIGl0IGxvb2tzIGxpa2UgaGUgd2FzIG9wdGltaXppbmcgdG8gYXZvaWQgdGhl
IF9iaA0KPiB2YXJpYW50DQo+IGlmIHBvc3NpYmxlLg0KDQpJIHRoaW5rIHRoYXQgaWYgeW91IHVz
ZSBhbm90aGVyIHZhcmlhbnQgdGhpcyBpdCBpbnRvcmR1Y2UgYSBwb3NzaWJsZXJhY2UgYmVzdHJl
d24gc29maXRxIGFuZCBoYXJkaXJxIC4uIA0KDQoNCg==
