Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E156D4BB3
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 03:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfJLBLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 21:11:32 -0400
Received: from mail-eopbgr20051.outbound.protection.outlook.com ([40.107.2.51]:25486
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726863AbfJLBLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 21:11:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6gLmHNQN0TgERQtDPaGVdhvybR9Aj9wCTrYSHQ3gWyarSib0RIkl1yOEkR5s/mVKh2rWQk8OGfW/hDDSa9TzxzTt0ciSVk89sgm2Oxunn053ED814ORorgUAOVTwLSdR67z8cjqPK9LfkPzQVl6qpN20ie1Hy86PLk5knRPCdKfTZ1XHjJRqHUcOPmmB/JdClYkg9wuELDAKnZQwqdXfPTvqnL8I6Y0bDxd8/9PV0//V6NriSeTbNCvplFmGh1MtqmiwFikykI3PCi8IXuvcC351wl7SReqs+LfluLAlcgN597PV+Tdbba+004tnp05RAstEOyBEIDPnJp8EfXL+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BOCmVzlnJQEjQD49mJVpm1PeXKsPO10s/+sSNsXBMg=;
 b=Dj10gJ7OfZuv7nIH0ta27xde2Q3G14QPd06BpdHUo68dsBahUX04IZHm8lkfj3YWmVE0GdApOcvRNdMD8VHgVY4jp96BFqOHBWchqwtVypoJa6hJERZ2oTdNJtx4FP6ZwLGk8EqgNY2yShraezV91kVI6h6vkwWlQCGgnQNEOI9Ple5D9sgg7ZaLchMLXM82CgqfahknWo0ATrgdXDn5n0bqW9f5DTZkzKCiXr/4xTBFyXEf2j5S1f1s3Q7oIrD2HaEhsUbgDWVuBgwr7P9UHoXQ6SD0AKpAKE5V9TQpBFw408hlemlV8PagplveVwUC46r39IQ7t1NHYc93zjShtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BOCmVzlnJQEjQD49mJVpm1PeXKsPO10s/+sSNsXBMg=;
 b=hTy/oLwwjzg9J+s3uClSMG70hMeelZDlMZg9i1oh7XB7kvIJBU489xxe0lgjzxK3bNyIr5vS89uTbcgliCgpps2Wf4CjdFal16luxt6Xi9qyxt6Z7Zvtv4+udkJvDtOCXREWmzUfpS1Wh040kDVW+ICUTrz4mCRW5nPSJdZt6Jk=
Received: from DB3PR0402MB3916.eurprd04.prod.outlook.com (52.134.72.18) by
 DB3PR0402MB3738.eurprd04.prod.outlook.com (52.134.70.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.25; Sat, 12 Oct 2019 01:09:47 +0000
Received: from DB3PR0402MB3916.eurprd04.prod.outlook.com
 ([fe80::d469:ad51:2bec:19f0]) by DB3PR0402MB3916.eurprd04.prod.outlook.com
 ([fe80::d469:ad51:2bec:19f0%6]) with mapi id 15.20.2347.021; Sat, 12 Oct 2019
 01:09:47 +0000
From:   Anson Huang <anson.huang@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "swboyd@chromium.org" <swboyd@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 1/2] net: fec_main: Use platform_get_irq_byname_optional()
 to avoid error message
Thread-Topic: [PATCH 1/2] net: fec_main: Use
 platform_get_irq_byname_optional() to avoid error message
Thread-Index: AQHVforZimETp53I4UOLcQPYAMVf3qdUghaAgAAN4TCAAAnBAIAAAP3QgAAEwgCAAARvAIAAkwAAgAD+TWA=
Date:   Sat, 12 Oct 2019 01:09:47 +0000
Message-ID: <DB3PR0402MB391602D0860E8ADC2DB36475F5960@DB3PR0402MB3916.eurprd04.prod.outlook.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
 <20191010160811.7775c819@cakuba.netronome.com>
 <DB3PR0402MB3916FF4583577B182D9BF60CF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
 <20191010173246.2cd02164@cakuba.netronome.com>
 <DB3PR0402MB3916284A326512CE2FDF597EF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
 <20191010175320.1fe5f6b3@cakuba.netronome.com>
 <DB3PR0402MB3916F0AC3E3AEC2AC1900BCCF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
 <CA+h21hpp5L-tcJNxXWaJaCKZyFzm-qPzUZ32LU+vKOv99PJ9ng@mail.gmail.com>
In-Reply-To: <CA+h21hpp5L-tcJNxXWaJaCKZyFzm-qPzUZ32LU+vKOv99PJ9ng@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=anson.huang@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f94e319-87a0-47b0-4800-08d74eb0dfe6
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DB3PR0402MB3738:|DB3PR0402MB3738:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB3738674C4A24D6F146E66894F5960@DB3PR0402MB3738.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0188D66E61
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(199004)(189003)(229853002)(6916009)(186003)(6506007)(25786009)(33656002)(26005)(476003)(1411001)(52536014)(11346002)(102836004)(81156014)(54906003)(81166006)(5660300002)(7696005)(446003)(76176011)(55016002)(6436002)(478600001)(256004)(6246003)(44832011)(74316002)(8936002)(9686003)(99286004)(66446008)(8676002)(14454004)(76116006)(64756008)(3846002)(486006)(71190400001)(66556008)(71200400001)(966005)(66946007)(6116002)(7736002)(6306002)(66066001)(86362001)(305945005)(4326008)(2906002)(66476007)(316002)(15650500001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR0402MB3738;H:DB3PR0402MB3916.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: No3VPif3FB1CQu7nEcCGpbJgYK584/2pv+VgGeDcdkgphtJ55i4t+UgJ0RH+NCSwLQc+0kwvtCk01AmbBV91gcQpQ4xgc3YuUboXYqOO4BlxA+e03eDXLjKwV2PCEDJEeZjihaMY+fsaDUyI3JFVPCabjwz15oOsV7PIjvuQrFn7JaW8l9IEcMsTc8nTcGprZFfuSBeE8lyH2+pCmqJno2+7F4Hbi/bukKPAYsKTK0NK8/QocN39coomUrk5B22iXMNRVYMQAKthpUZT3dbAbQrbezXS8hkyUPBNaudJcA91ZubIt8YRjf/0fbWkrS9LblEf6o2wJvQ+xWOTjO5XsD3ADMPuOFuy/Fkewz2WToG8WTo/x494gM348Oi9cX0wASFQwdC0hahDkhw0y0H0Ow8miT0ORAP4VnYlRd1ANLW+mt7weuG1LxwnN0oq74AG0d3qiEEstkEt1qz3kxznxg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f94e319-87a0-47b0-4800-08d74eb0dfe6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2019 01:09:47.1827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D1sxqc+qy04rrM5b0NV5/PsfgTYGN2vyxjAGsqmd7lKcD4IsAka3Xnjawf4nOWkpya3IrFYs7wISF3d8aCPT7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3738
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIFZsYWRpbWlyDQoNCj4gT24gRnJpLCAxMSBPY3QgMjAxOSBhdCAwNDoxMSwgQW5zb24gSHVh
bmcgPGFuc29uLmh1YW5nQG54cC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gSGksIEpha3ViDQo+ID4N
Cj4gPiA+IE9uIEZyaSwgMTEgT2N0IDIwMTkgMDA6Mzg6NTAgKzAwMDAsIEFuc29uIEh1YW5nIHdy
b3RlOg0KPiA+ID4gPiA+IEhtLiBMb29rcyBsaWtlIHRoZSBjb21taXQgeW91IG5lZWQgaXMgY29t
bWl0IGYxZGE1NjdmMWRjMSAoImRyaXZlcg0KPiBjb3JlOg0KPiA+ID4gPiA+IHBsYXRmb3JtOiBB
ZGQgcGxhdGZvcm1fZ2V0X2lycV9ieW5hbWVfb3B0aW9uYWwoKSIpIGFuZCBpdCdzDQo+ID4gPiA+
ID4gY3VycmVudGx5IGluIEdyZWcncyB0cmVlLiBZb3UgaGF2ZSB0byB3YWl0IGZvciB0aGF0IGNv
bW1pdCB0bw0KPiA+ID4gPiA+IG1ha2UgaXRzIHdheSBpbnRvIExpbnVzJ2VzIG1haW4gdHJlZSBh
bmQgdGhlbiBmb3IgRGF2ZSBNaWxsZXIgdG8gcHVsbA0KPiBmcm9tIExpbnVzLg0KPiA+ID4gPiA+
DQo+ID4gPiA+ID4gSSdkIHN1Z2dlc3QgeW91IGNoZWNrIGlmIHlvdXIgcGF0Y2hlcyBidWlsZHMg
b24gdGhlIG5ldCB0cmVlOg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gICBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV0ZGV2L25ldC5naXQNCj4gPiA+ID4gPg0K
PiA+ID4gPiA+IG9uY2UgYSB3ZWVrLiBNeSBndWVzcyBpcyBpdCdsbCBwcm9iYWJseSB0YWtlIHR3
byB3ZWVrcyBvciBzbyBmb3INCj4gPiA+ID4gPiBHcmVnJ3MgcGF0Y2hlcyB0byBwcm9wYWdhdGUg
dG8gRGF2ZS4NCj4gPiA+ID4NCj4gPiA+ID4gVGhhbmtzIGZvciBleHBsYW5hdGlvbiBvZiBob3cg
dGhlc2UgdHJlZXMgd29yaywgc28gY291bGQgeW91DQo+ID4gPiA+IHBsZWFzZSB3YWl0IHRoZSBu
ZWNlc3NhcnkgcGF0Y2ggbGFuZGluZyBvbiBuZXR3b3JrIHRyZWUgdGhlbiBhcHBseQ0KPiA+ID4g
PiB0aGlzIHBhdGNoIHNlcmllcywgdGhhbmtzIGZvciBoZWxwLg0KPiA+ID4NCj4gPiA+IFVuZm9y
dHVuYXRlbHkgdGhlIG5ldHdvcmtpbmcgc3Vic3lzdGVtIHNlZXMgYXJvdW5kIGEgMTAwIHBhdGNo
ZXMNCj4gPiA+IHN1Ym1pdHRlZCBlYWNoIGRheSwgaXQnZCBiZSB2ZXJ5IGhhcmQgdG8ga2VlcCB0
cmFjayBvZiBwYXRjaGVzIHdoaWNoDQo+ID4gPiBoYXZlIGV4dGVybmFsIGRlcGVuZGVuY2llcyBh
bmQgd2hlbiB0byBtZXJnZSB0aGVtLiBUaGF0J3Mgd2h5IHdlDQo+ID4gPiBuZWVkIHRoZSBzdWJt
aXR0ZXJzIHRvIGRvIHRoaXMgd29yayBmb3IgdXMgYW5kIHJlc3VibWl0IHdoZW4gdGhlDQo+ID4g
PiBwYXRjaCBjYW4gYmUgYXBwbGllZCBjbGVhbmx5Lg0KPiA+DQo+ID4gT0ssIEkgd2lsbCByZXNl
bmQgdGhpcyBwYXRjaCBzZXJpZXMgb25jZSB0aGUgbmVjZXNzYXJ5IHBhdGNoIGxhbmRzIG9uDQo+
ID4gdGhlIG5ldHdvcmsgdHJlZS4NCj4gDQo+IFdoYXQgaGFzIG5vdCBiZWVuIG1lbnRpb25lZCBp
cyB0aGF0IHlvdSBjYW4ndCBjcmVhdGUgZnV0dXJlIGRlcGVuZGVuY2llcw0KPiBmb3IgcGF0Y2hl
cyB3aGljaCBoYXZlIGEgRml4ZXM6IHRhZy4NCj4gDQo+IGdpdCBkZXNjcmliZSAtLXRhZ3MgNzcy
M2Y0YzVlY2RiICMgZHJpdmVyIGNvcmU6IHBsYXRmb3JtOiBBZGQgYW4gZXJyb3INCj4gbWVzc2Fn
ZSB0byBwbGF0Zm9ybV9nZXRfaXJxKigpIHY1LjMtcmMxLTEzLWc3NzIzZjRjNWVjZGINCj4gDQo+
IGdpdCBkZXNjcmliZSAtLXRhZ3MgZjFkYTU2N2YxZGMgIyBkcml2ZXIgY29yZTogcGxhdGZvcm06
IEFkZA0KPiBwbGF0Zm9ybV9nZXRfaXJxX2J5bmFtZV9vcHRpb25hbCgpDQo+IHY1LjQtcmMxLTQ2
LWdmMWRhNTY3ZjFkYzENCj4gDQo+IFNvIHlvdSBoYXZlIHRvIGNvbnNpZGVyIHdoZXRoZXIgdGhl
IHBhdGNoIGlzIHJlYWxseSBmaXhpbmcgYW55dGhpbmcgKGl0IGlzIG9ubHkNCj4gZ2V0dGluZyBy
aWQgb2YgYSBub24tZmF0YWwgZXJyb3IgbWVzc2FnZSkuDQo+IEFuZCBpdCdzIG5vdCByZWFzb25h
YmxlIGFueXdheSB0byBzYXkgdGhhdCB5b3UncmUgZml4aW5nIHRoZSBwYXRjaCB0aGF0IGFkZGVk
DQo+IHRoZSBlcnJvciBtZXNzYWdlIGluIHRoZSBnZW5lcmljIGZyYW1ld29yay4NCj4gVGhlIGZh
bGxiYWNrIGxvZ2ljIGhhcyBhbHdheXMgYmVlbiB0aGVyZSBpbiB0aGUgZHJpdmVyLiBTbyB5b3Ug
bWlnaHQgd2FudCB0bw0KPiBkcm9wIHRoZSBGaXhlczogdGFnIHdoZW4geW91IHJlc2VuZC4NCg0K
T0ssIEkgYWdyZWUgdGhhdCBzdWNoIGtpbmQgb2YgcGF0Y2ggc2hvdWxkIE5PVCBhZGQgZml4IHRh
ZywgYnV0IEkgd2FzIGNvbmZ1c2VkIHdoZW4NCkkgY3JlYXRlZCB0aGlzIHBhdGNoLCBhcyBJIHNh
dyBtYW55IHNpbWlsYXIgcGF0Y2hlcyBhbHNvIGhhcyBmaXggdGFnLCBzdWNoIGFzIGJlbG93IDIN
CmV4YW1wbGVzLg0KDQpJIHdpbGwgZHJvcCB0aGUgZml4IHRhZyB3aGVuIHJlc2VuZCB0aGUgcGF0
Y2ggc2VyaWVzLg0KDQpjb21taXQgNzFlZWE3MDcxNTgzYjA0ZTliNzk2ZWUxZDZmN2EwNzMzNDQy
NjQ5NQ0KQXV0aG9yOiBBbmR5IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4Lmlu
dGVsLmNvbT4NCkRhdGU6ICAgVGh1IE9jdCAxMCAxMToxNToyMCAyMDE5ICswMzAwDQoNCiAgICBw
bGF0Zm9ybS94ODY6IGludGVsX3B1bml0X2lwYzogQXZvaWQgZXJyb3IgbWVzc2FnZSB3aGVuIHJl
dHJpZXZpbmcgSVJRDQoNCiAgICBTaW5jZSB0aGUgY29tbWl0DQoNCiAgICAgIDc3MjNmNGM1ZWNk
YiAoImRyaXZlciBjb3JlOiBwbGF0Zm9ybTogQWRkIGFuIGVycm9yIG1lc3NhZ2UgdG8gcGxhdGZv
cm1fZ2V0X2lycSooKSIpDQoNCiAgICB0aGUgcGxhdGZvcm1fZ2V0X2lycSgpIHN0YXJ0ZWQgaXNz
dWluZyBhbiBlcnJvciBtZXNzYWdlIHdoaWNoIGlzIG5vdA0KICAgIHdoYXQgd2Ugd2FudCBoZXJl
Lg0KDQogICAgU3dpdGNoIHRvIHBsYXRmb3JtX2dldF9pcnFfb3B0aW9uYWwoKSB0byBoYXZlIG9u
bHkgd2FybmluZyBtZXNzYWdlDQogICAgcHJvdmlkZWQgYnkgdGhlIGRyaXZlci4NCg0KICAgIEZp
eGVzOiA3NzIzZjRjNWVjZGIgKCJkcml2ZXIgY29yZTogcGxhdGZvcm06IEFkZCBhbiBlcnJvciBt
ZXNzYWdlIHRvIHBsYXRmb3JtX2dldF9pcnEqKCkiKQ0KICAgIFNpZ25lZC1vZmYtYnk6IEFuZHkg
U2hldmNoZW5rbyA8YW5kcml5LnNoZXZjaGVua29AbGludXguaW50ZWwuY29tPg0KDQpkcml2ZXJz
L3BsYXRmb3JtL3g4Ni9pbnRlbF9wdW5pdF9pcGMuYw0KDQpjb21taXQgMzkyZmI4ZGY1MjhiOTdh
MDZlMTkzMTI3NzJhZmQzOGFlYzU0MmI5Ng0KQXV0aG9yOiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdl
ZXJ0K3JlbmVzYXNAZ2xpZGVyLmJlPg0KRGF0ZTogICBUdWUgT2N0IDEgMjA6MDc6NDMgMjAxOSAr
MDIwMA0KDQogICAgc2VyaWFsOiBzaC1zY2k6IFVzZSBwbGF0Zm9ybV9nZXRfaXJxX29wdGlvbmFs
KCkgZm9yIG9wdGlvbmFsIGludGVycnVwdHMNCg0KICAgIEFzIHBsYXRmb3JtX2dldF9pcnEoKSBu
b3cgcHJpbnRzIGFuIGVycm9yIHdoZW4gdGhlIGludGVycnVwdCBkb2VzIG5vdA0KICAgIGV4aXN0
LCBzY2FyeSB3YXJuaW5ncyBtYXkgYmUgcHJpbnRlZCBmb3Igb3B0aW9uYWwgaW50ZXJydXB0czoN
Cg0KICAgICAgICBzaC1zY2kgZTY1NTAwMDAuc2VyaWFsOiBJUlEgaW5kZXggMSBub3QgZm91bmQN
CiAgICAgICAgc2gtc2NpIGU2NTUwMDAwLnNlcmlhbDogSVJRIGluZGV4IDIgbm90IGZvdW5kDQog
ICAgICAgIHNoLXNjaSBlNjU1MDAwMC5zZXJpYWw6IElSUSBpbmRleCAzIG5vdCBmb3VuZA0KICAg
ICAgICBzaC1zY2kgZTY1NTAwMDAuc2VyaWFsOiBJUlEgaW5kZXggNCBub3QgZm91bmQNCiAgICAg
ICAgc2gtc2NpIGU2NTUwMDAwLnNlcmlhbDogSVJRIGluZGV4IDUgbm90IGZvdW5kDQoNCiAgICBG
aXggdGhpcyBieSBjYWxsaW5nIHBsYXRmb3JtX2dldF9pcnFfb3B0aW9uYWwoKSBpbnN0ZWFkIGZv
ciBhbGwgYnV0IHRoZQ0KICAgIGZpcnN0IGludGVycnVwdHMsIHdoaWNoIGFyZSBvcHRpb25hbC4N
Cg0KICAgIEZpeGVzOiA3NzIzZjRjNWVjZGI4ZDgzICgiZHJpdmVyIGNvcmU6IHBsYXRmb3JtOiBB
ZGQgYW4gZXJyb3IgbWVzc2FnZSB0byBwbGF0Zm9ybV9nZXRfaXJxKigpIikNCiAgICBTaWduZWQt
b2ZmLWJ5OiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNAZ2xpZGVyLmJlPg0KICAg
IFJldmlld2VkLWJ5OiBTdGVwaGVuIEJveWQgPHN3Ym95ZEBjaHJvbWl1bS5vcmc+DQogICAgUmV2
aWV3ZWQtYnk6IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2Fz
LmNvbT4NCiAgICBUZXN0ZWQtYnk6IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9k
YS51aEByZW5lc2FzLmNvbT4NCiAgICBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIw
MTkxMDAxMTgwNzQzLjEwNDEtMS1nZWVydCtyZW5lc2FzQGdsaWRlci5iZQ0KICAgIFNpZ25lZC1v
ZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQoN
CmRyaXZlcnMvdHR5L3NlcmlhbC9zaC1zY2kuYw0KDQp0aGFua3MsDQpBbnNvbg0K
