Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68FE1F0929
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 03:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgFGBDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 21:03:11 -0400
Received: from mail-bn8nam12on2110.outbound.protection.outlook.com ([40.107.237.110]:27205
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728743AbgFGBDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jun 2020 21:03:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eekGCe+3Zv7hknAMqRGEh8wLJzNUJla25CUmN6tpy+cfgMLuUd/7qzmTNErT/b9zbfpBU6Zc0gNMs+TJThhFU1NEt/TdmwqGehL33qml+uKI1DIXeW4DgnSza2lOJszbhBigy9ytOIR1NIKXPsIz3pur/JuyJncipg4uA3v4GQ9Oc4tmf+ZAtReLG/EkNrrcUuFaohqZfa59XcuN9i6IRmtjd3eg+AD2PMVqI7cDIp1qRvHAyoyUu8qWqBAXKSbIKAThHGPuil4nT085XA5/CBtXBgQR4O53FPxkzYHM7N0MpKXywv7RaZ/pWOlV5BAfDMYoBxbO4YQ3+Uci3HfWGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWK5QjiYdr81Vc1C1vEUJskury/cStLkc+NJLJtHkt8=;
 b=TgV9KGrbZ1Mnax7oiglwZEVB3Fwsv9KFs0kFmXtGjemUQHL5Mc5L9MfMBljg9fNEcXocslnDUBVB0jH0CCtkJ4UuDCiCZl8zFqHO7L3+BbLSUD6zOgu5tzp3qyCrt2meNqXZTZfq+pNm2zkPracqlGLyftSxZjVZn9dspwNBmIZ0xVxAmXH12eKiu6qcNLLsm0ivIwPzrZhAmfpjvhSDPQ4Axitch+Rqu/tym/6WcTHjGFzfeuV6hKMNaat7zvdvmR6AFy9WUkdnLhxah2NCzJwFPJPjf4EZU63u+v5vCJf//VtDlNdmnUkdS8msEVnnPJpp7hopuEqkttKsnsfzUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWK5QjiYdr81Vc1C1vEUJskury/cStLkc+NJLJtHkt8=;
 b=a3Iae8I/BkLgrq2ruj+1Xg9YtPN6izsK0xosf4KSD0Z7ws9ckA9Zju0x296tRIEgCS15v4QhHb8nN8qaK1j4iIVIarbuxpj1p8Bbcz+b9sBOSR6yXut2J8jIqwk50BDNoBeOpYkyrGWXUkfbC6ccg2kAkFJ8cMuoXGIAIw0qtuw=
Received: from CH2PR13MB3398.namprd13.prod.outlook.com (2603:10b6:610:2a::33)
 by CH2PR13MB3350.namprd13.prod.outlook.com (2603:10b6:610:27::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.9; Sun, 7 Jun
 2020 01:03:06 +0000
Received: from CH2PR13MB3398.namprd13.prod.outlook.com
 ([fe80::49f6:ce9b:9803:2493]) by CH2PR13MB3398.namprd13.prod.outlook.com
 ([fe80::49f6:ce9b:9803:2493%6]) with mapi id 15.20.3088.014; Sun, 7 Jun 2020
 01:03:06 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "zhengbin13@huawei.com" <zhengbin13@huawei.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
CC:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>
Subject: Re: [PATCH] sunrpc: need delete xprt->timer in xs_destroy
Thread-Topic: [PATCH] sunrpc: need delete xprt->timer in xs_destroy
Thread-Index: AQHWOn5Zh6+x4WmBK0y1uFEnW2D2E6jIl84AgACwLYCAAxHTAA==
Date:   Sun, 7 Jun 2020 01:03:05 +0000
Message-ID: <f4e2b91d346cc345df2f6e1176fb4906992c7069.camel@hammerspace.com>
References: <20200604144910.133756-1-zhengbin13@huawei.com>
         <bc4755e6c5cee7a326cf06f983907a3170be1649.camel@hammerspace.com>
         <b04044c7-597c-0487-f459-4d0032d66d5b@huawei.com>
In-Reply-To: <b04044c7-597c-0487-f459-4d0032d66d5b@huawei.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0f2ba71-a962-4ad1-ef8c-08d80a7e8970
x-ms-traffictypediagnostic: CH2PR13MB3350:
x-microsoft-antispam-prvs: <CH2PR13MB335070636F24D5576313F221B8840@CH2PR13MB3350.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 04270EF89C
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MYyMb2jOxIAt/GNaanxovKqgcs8L7v2eeX4bqygz971SlnR6Jciw/HAlzj9ChQcr/ThXwVQ3+whVKYj3bjLSUj3xOy4OIpM6K0UU9oPyTRGxddjouUKsPRo3MKNZ/NZQBWkEysNgfHk8g/08H+bv4FFJqjD8p3c6Am/hANGQS2/hYGMBY5TmuW23IcPpnfGwphOLW+62sjrosEuYB5ZYAxjKP0yk8EDM5/Dhw12U0604fF7HgeU/YF7xXEBq4lp0tjaTWZFTqtzaBGl+mUJsUB1n7ZrZ7jgVibvtTLj0LNDf1nGZiIRW9C9sJuYnuv9D61zP8t+Q8p+JljThREhHWhKQH0Chdz9zSVl5KJJBMu+gVJgncd03SpA72rvHzocV3SUbd3QMk97uF7r7Ev+NCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3398.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(346002)(376002)(71200400001)(508600001)(83380400001)(2616005)(86362001)(15974865002)(4326008)(6512007)(83080400001)(8936002)(64756008)(76116006)(66946007)(2906002)(66476007)(66446008)(66556008)(8676002)(26005)(54906003)(6486002)(5660300002)(7416002)(36756003)(53546011)(110136005)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Wdv6kH5uaJfwKWYw+LIeSW1a9kqaCX5F1xigo4itZ2wcAXJ2EQdeRd6j385g/OyIqEHNR2EgSj0mPRqgaHKZSpgLjmT2dv7bdIJ2Nc4ZIkbj4mMEdhBe+NVB/GKMOnBvhNJobDUJ5VUPS3jaFMqVITIrxyYdv/I18qlcjDoYz73X3GV4r+4iN+xKE1mtHNN1bYtUZ+VRXvwhos34nNdBTiYUh4/AXK7pcYHXGdXtaC3WKtl51AHhS8WXZue4QJEP30fmkudkrywKhJ7jQafz9qapSnluKlFlKHmzpP+rvnbKGq27z4onuX0ry9GvlS1RV9Gg6+Ba5IeuXLbfHxHd4aGNP8FWtvqtApqfz0mpGw8pgk9SQB0GPzDeidwGd1Yec34ZCXXHwnHtzTFhgv2PHEVwGC7pRp5k+ub4bj9lfcD6B2xdDoDSGVTJeRjTJlcYmdfWoeS4NbR8BHGsPS2ZmORTkPteeODh2ip+XSSL54c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <350CA59CD68AA04180432B25B9005EB7@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f2ba71-a962-4ad1-ef8c-08d80a7e8970
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2020 01:03:05.9103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F7Q0aL7ulXGVOQOJCRN8TLgFbreCciFoQ4eYU2XsbMBPrpYZ32PqvQF4IC0o2feA9rCkXK8tlQWsGDG7vC1kKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3350
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA2LTA1IGF0IDEwOjEwICswODAwLCBaaGVuZ2JpbiAoT1NLZXJuZWwpIHdy
b3RlOg0KPiBUaGUgY29tcGxldGUgcHJvY2VzcyBpcyBsaWtlIHRoaXM6DQo+IA0KPiB4cHJ0X2Rl
c3Ryb3kNCj4gICAgd2FpdF9vbl9iaXRfbG9jaygmeHBydC0+c3RhdGUsIFhQUlRfTE9DS0VELA0K
PiBUQVNLX1VOSU5URVJSVVBUSUJMRSkgIA0KPiAtLT5nZXRsb2NrDQo+ICAgIGRlbF90aW1lcl9z
eW5jKCZ4cHJ0LT50aW1lcikgICAtLT5kZWwgeHBydC0+dGltZXINCj4gICAgSU5JVF9XT1JLKCZ4
cHJ0LT50YXNrX2NsZWFudXAsIHhwcnRfZGVzdHJveV9jYikNCj4gDQo+IHhwcnRfZGVzdHJveV9j
Yg0KPiAgICB4c19kZXN0cm95KHhwcnQtPm9wcy0+ZGVzdHJveSkNCj4gICAgICBjYW5jZWxfZGVs
YXllZF93b3JrX3N5bmMgICAgIC0tPndpbGwgY2FsbCANCj4gdHJhbnNwb3J0LT5jb25uZWN0X3dv
cmtlciwgd2hvc2UgY2FsbGJhY2sgaXMgeHNfdWRwX3NldHVwX3NvY2tldA0KPiAgICAgIHhzX3hw
cnRfZnJlZSh4cHJ0KSAgICAgICAgICAgICAgICAgICAgLS0+ZnJlZSB4cHJ0DQo+IA0KPiB4c191
ZHBfc2V0dXBfc29ja2V0DQo+ICAgIHNvY2sgPSB4c19jcmVhdGVfc29jaw0KPiAgICB4cHJ0X3Vu
bG9ja19jb25uZWN0DQo+ICAgICAgICBpZiAoIXRlc3RfYml0KFhQUlRfTE9DS0VELCAmeHBydC0+
c3RhdGUpKSAtLT5zdGF0ZSBpcw0KPiBYUFJUX0xPQ0tFRA0KPiAgICAgICAgeHBydF9zY2hlZHVs
ZV9hdXRvZGlzY29ubmVjdA0KPiAgICAgICAgICBtb2RfdGltZXINCj4gICAgICAgICAgICBpbnRl
cm5hbF9hZGRfdGltZXIgIC0tPmluc2VydCB4cHJ0LT50aW1lciB0byBiYXNlIHRpbWVyDQo+IGxp
c3QNCg0KVGhlIGNhbGwgdG8geHBydF9sb2NrX2Nvbm5lY3QoKSBpbiB4c19jb25uZWN0KCkgaXMg
c3VwcG9zZWQgdG8gZW5zdXJlDQpleGNsdXNpb24gdy5yLnQuIHdhaXRfb25fYml0X2xvY2soKS4g
SW4gb3RoZXIgd29yZHMgaWYgdGhlIHRyYW5zcG9ydC0NCj5jb25uZWN0X3dvcmtlciBpcyBhY3R1
YWxseSBxdWV1ZWQsIGl0IGlzIGFsc28gc3VwcG9zZWQgdG8gYmUgaG9sZGluZw0KdGhlIFhQUlRf
TE9DSyBhbmQgZW5zdXJpbmcgdGhhdCB3ZSBjYW4ndCBnZXQgaW50byB0aGUgYWJvdmUgc2l0dWF0
aW9uLg0KDQpXaHkgaXMgdGhhdCBub3QgdGhlIGNhc2UgaGVyZT8NCg0KPiANCj4gT24gMjAyMC82
LzQgMjM6MzksIFRyb25kIE15a2xlYnVzdCB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMjAtMDYtMDQg
YXQgMjI6NDkgKzA4MDAsIFpoZW5nIEJpbiB3cm90ZToNCj4gPiA+IElmIFJQQyB1c2UgdWRwIGFz
IGl0J3MgdHJhbnNwb3J0IHByb3RvY29sLCB0cmFuc3BvcnQtDQo+ID4gPiA+Y29ubmVjdF93b3Jr
ZXINCj4gPiA+IHdpbGwgY2FsbCB4c191ZHBfc2V0dXBfc29ja2V0Lg0KPiA+ID4geHNfdWRwX3Nl
dHVwX3NvY2tldA0KPiA+ID4gICAgc29jayA9IHhzX2NyZWF0ZV9zb2NrDQo+ID4gPiAgICBpZiAo
SVNfRVJSKHNvY2spKQ0KPiA+ID4gICAgICBnb3RvIG91dDsNCj4gPiA+ICAgIG91dDoNCj4gPiA+
ICAgICAgeHBydF91bmxvY2tfY29ubmVjdA0KPiA+ID4gICAgICAgIHhwcnRfc2NoZWR1bGVfYXV0
b2Rpc2Nvbm5lY3QNCj4gPiA+ICAgICAgICAgIG1vZF90aW1lcg0KPiA+ID4gICAgICAgICAgICBp
bnRlcm5hbF9hZGRfdGltZXIgIC0tPmluc2VydCB4cHJ0LT50aW1lciB0byBiYXNlDQo+ID4gPiB0
aW1lcg0KPiA+ID4gbGlzdA0KPiA+ID4gDQo+ID4gPiB4c19kZXN0cm95DQo+ID4gPiAgICBjYW5j
ZWxfZGVsYXllZF93b3JrX3N5bmMoJnRyYW5zcG9ydC0+Y29ubmVjdF93b3JrZXIpDQo+ID4gPiAg
ICB4c194cHJ0X2ZyZWUoeHBydCkgICAgICAgICAgIC0tPmZyZWUgeHBydA0KPiA+ID4gDQo+ID4g
PiBUaHVzIHVzZS1hZnRlci1mcmVlIHdpbGwgaGFwcGVuLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBaaGVuZyBCaW4gPHpoZW5nYmluMTNAaHVhd2VpLmNvbT4NCj4gPiA+IC0tLQ0KPiA+
ID4gICBuZXQvc3VucnBjL3hwcnRzb2NrLmMgfCAxICsNCj4gPiA+ICAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9uZXQvc3VucnBjL3hw
cnRzb2NrLmMgYi9uZXQvc3VucnBjL3hwcnRzb2NrLmMNCj4gPiA+IGluZGV4IDg0NWQwYmU4MDVl
Yy4uYzc5NjgwOGU3ZjdhIDEwMDY0NA0KPiA+ID4gLS0tIGEvbmV0L3N1bnJwYy94cHJ0c29jay5j
DQo+ID4gPiArKysgYi9uZXQvc3VucnBjL3hwcnRzb2NrLmMNCj4gPiA+IEBAIC0xMjQyLDYgKzEy
NDIsNyBAQCBzdGF0aWMgdm9pZCB4c19kZXN0cm95KHN0cnVjdCBycGNfeHBydA0KPiA+ID4gKnhw
cnQpDQo+ID4gPiAgIAlkcHJpbnRrKCJSUEM6ICAgICAgIHhzX2Rlc3Ryb3kgeHBydCAlcFxuIiwg
eHBydCk7DQo+ID4gPiANCj4gPiA+ICAgCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmdHJhbnNw
b3J0LT5jb25uZWN0X3dvcmtlcik7DQo+ID4gPiArCWRlbF90aW1lcl9zeW5jKCZ4cHJ0LT50aW1l
cik7DQo+ID4gPiAgIAl4c19jbG9zZSh4cHJ0KTsNCj4gPiA+ICAgCWNhbmNlbF93b3JrX3N5bmMo
JnRyYW5zcG9ydC0+cmVjdl93b3JrZXIpOw0KPiA+ID4gICAJY2FuY2VsX3dvcmtfc3luYygmdHJh
bnNwb3J0LT5lcnJvcl93b3JrZXIpOw0KPiA+ID4gLS0NCj4gPiA+IDIuMjYuMC4xMDYuZzlmYWRl
ZGQNCj4gPiA+IA0KPiA+IEknbSBjb25mdXNlZC4gSG93IGNhbiB0aGlzIGhhcHBlbiBnaXZlbiB0
aGF0IHhwcnRfZGVzdHJveSgpIGZpcnN0DQo+ID4gdGFrZXMNCj4gPiB0aGUgWFBSVF9MT0NLLCBh
bmQgdGhlbiBkZWxldGVzIHhwcnQtPnRpbWVyPw0KPiA+IA0KPiA+IFJpZ2h0IG5vdywgdGhlIHNv
Y2tldCBjb2RlIGtub3dzIG5vdGhpbmcgYWJvdXQgdGhlIGRldGFpbHMgb2YgeHBydC0NCj4gPiA+
IHRpbWVyIGFuZCB3aGF0IGl0IGlzIHVzZWQgZm9yLiBJJ2QgcHJlZmVyIHRvIGtlZXAgaXQgdGhh
dCB3YXkgaWYNCj4gPiBwb3NzaWJsZS4NCj4gPiANCi0tIA0KVHJvbmQgTXlrbGVidXN0DQpDVE8s
IEhhbW1lcnNwYWNlIEluYw0KNDk4NCBFbCBDYW1pbm8gUmVhbCwgU3VpdGUgMjA4DQpMb3MgQWx0
b3MsIENBIDk0MDIyDQp3d3cuaGFtbWVyLnNwYWNlDQoNCg==
