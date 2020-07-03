Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3311F2133EF
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 08:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgGCGPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 02:15:13 -0400
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:48390
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725648AbgGCGPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 02:15:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AR1e0wnCG4gyq352aceVCvVMIsiSQi42BiWeWlJAeQlZOoRuK21TffIbfpYStJpNEdMgWtY98pINDNzXcPuKYO+a9wFOSV+2ljJaIITEwQymM8jU5fDqcx/+H3ToVocwr4XahTY/8zzHnlijerDBdbM0oxSgU81cmOns38ULB0W+JyzOnWPFvD5LhmGXmUQ5ViVIp+7Xvxw7CM5XSvTwcsuVJbopzxk/BV7Dj7u1GPYGAd0jtAn9bkVDHPQrFZqgIsHlJgG11WlPQiGIL9lSHSCv+51EcY9L9pUaUsGe5xG5aOS9uWRPx40lT364eSgvltvhLZdLCWY+Y7YowQM/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCv0ISCajQafMlfmkEQcKCiC3a7n46uJdugK/bsHqDk=;
 b=Rhy8owxInBbhJzx3hhZnZvcMrUJ13pTvZBb8FKDeFEh7ZyYO06jXjt47RlH6pNHSo62Lwb5iwRKY4HW5te+DS0O1q/pu0TOiqnShswGB0AXqFvnIBA9/BzfL2bPzfCjdUtBvu5AkmLd/x2izVlbYg/sRjYyBHjUw0BhaL7pgG1r9kCsyX1BjDoUcSt+sKGSI42+03JQkSQm94QLpZVM0ebf2ckyh2aJiN9KFHrkSdUXVJSR9HnWRDIOXppDlLb+w0mU155lLenj1+JimYwl8AVQqOYkRQpoEO9MPpqbxZCr4jPA7nYiWhyUHDFnPqSgKS0P07xvzuVT7XF0N90yZ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCv0ISCajQafMlfmkEQcKCiC3a7n46uJdugK/bsHqDk=;
 b=m5M10OnVK8QMwxItuGyEor9+W1PdQZ3+5g1u6OZMqFycv3XLQ/3WajRyIHJufQ8Uxm9xJIEQcCLuvfyimgW/ZlQGHexBVyJtf5RcHOl7SklbVqUh8TMu0ElRC+lea0t/JXLQhDpQsYJSE8a2Ntnr0msKADcHfa1hxvjVIT80jQ4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6655.eurprd05.prod.outlook.com (2603:10a6:800:131::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21; Fri, 3 Jul
 2020 06:15:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 06:15:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Ron Diskin <rondi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Thread-Topic: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Thread-Index: AQHWUL8B0dTQ7515okubmzIlcDj/s6j1FnWAgAAg54CAAAsHgIAAHreA
Date:   Fri, 3 Jul 2020 06:15:09 +0000
Message-ID: <763ba5f0a5ae07f4da736572f1a3e183420efcd0.camel@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
         <20200702221923.650779-3-saeedm@mellanox.com>
         <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
         <20200702212511.1fcbbb26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200702212511.1fcbbb26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c8b333a7-e030-438c-9b00-08d81f18702d
x-ms-traffictypediagnostic: VI1PR05MB6655:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6655C4D113C9435C6C8D1D0CBE6A0@VI1PR05MB6655.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X4rqU34upaPWu2J+S0Rb3FX0f5N5QXcIoHAYjOG12XeADG55fh5I7W2cxWbzCopKJ34x/ys9jy0ImjvKvS9IgO//9o4VgxuI8ls4v858Wr3tqoKMPHnfBiwT1fWcjJY7ynakjhLU2MnBcxI/qsNrgRBDYWc1C6RetX5xZMKxYus1yHnm0FU3pZqzASN5omfxdegwSJUJqkIyCizWddJoPIqTGs5iSELmD0L7JjC0+Xzpk+pzJ8iWKNdMh5MdHjtiGJwlbMSMyEvm5NJM+/l2Q2g3BhySnDFy4ydDgLqLu7sQxgc2Jv9DBhi5BMJEjRtfHZJoa6NyW1SiMDNjtbgbrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(8936002)(76116006)(91956017)(66446008)(64756008)(6506007)(66556008)(66946007)(66476007)(4326008)(26005)(71200400001)(86362001)(2616005)(6916009)(8676002)(54906003)(36756003)(316002)(5660300002)(83380400001)(2906002)(186003)(478600001)(6486002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Ogfytp0Y2ez0W2V3mm6PKu707OpPoHRlazX14lh5gCqPmRtxLkxh70dMnCKfTTiOZXpMUJgrWj9Pi1CE9Gc6j1mpvSpRZaiOLzZSUuLqx62znQh3wIaYUGDSQ5y0azKkksKGyX6o/glHTyBt2bp8oak7VO5/MMnOzn/yfoNIYXqRS2lb6tVaKfFR48nm6CM6qIAiJ88qgxdpIV1HM+3J6EfW2oXVioMY2Njl0wrFQPFszZuofvZjfqxi3vnitlmCSCPZINjTWbPTUNXby8kp253nilcKKM4czic/xSWheUKdi+0nlVMinQDvU29ZXYb1zRVtpSqfZc0Sfu2lOdu3WDuBStniFySlxhY7gfYNwHt0O/fdeRNIBM83FXBqdk3k4GPvOZ/DY/BdKwE2bVpUUC2xq+m2MMWTW6QpRcX9sKtXVNFq5OKQ7Tx5FWF06Cr533cKiHKB3FocxX6PNcUX2px+BQBFzqr1AMtIH+ooAFY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D280C4CB725D4540B84BC6FC146AF18A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b333a7-e030-438c-9b00-08d81f18702d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 06:15:09.1280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /BgSZftEamnQIqIl/9DItvb0Wy4EvEZFshkAVECPqpnZJLdwpVkshVWjNk10PeL7gX9NYO1hkA6G1snJHqYGIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTAyIGF0IDIxOjI1IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAzIEp1bCAyMDIwIDAzOjQ1OjQ1ICswMDAwIFNhZWVkIE1haGFtZWVkIHdyb3Rl
Og0KPiA+IE9uIFRodSwgMjAyMC0wNy0wMiBhdCAxODo0NyAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+ID4gPiBPbiBUaHUsICAyIEp1bCAyMDIwIDE1OjE5OjE0IC0wNzAwIFNhZWVkIE1h
aGFtZWVkIHdyb3RlOiAgDQo+ID4gPiA+IEZyb206IFJvbiBEaXNraW4gPHJvbmRpQG1lbGxhbm94
LmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IEN1cnJlbnRseSB0aGUgRlcgZG9lcyBub3QgZ2VuZXJh
dGUgZXZlbnRzIGZvciBjb3VudGVycyBvdGhlcg0KPiA+ID4gPiB0aGFuDQo+ID4gPiA+IGVycm9y
DQo+ID4gPiA+IGNvdW50ZXJzLiBVbmxpa2UgIi5nZXRfZXRodG9vbF9zdGF0cyIsICIubmRvX2dl
dF9zdGF0czY0Ig0KPiA+ID4gPiAod2hpY2ggaXANCj4gPiA+ID4gLXMNCj4gPiA+ID4gdXNlcykg
bWlnaHQgcnVuIGluIGF0b21pYyBjb250ZXh0LCB3aGlsZSB0aGUgRlcgaW50ZXJmYWNlIGlzDQo+
ID4gPiA+IG5vbg0KPiA+ID4gPiBhdG9taWMuDQo+ID4gPiA+IFRodXMsICdpcCcgaXMgbm90IGFs
bG93ZWQgdG8gaXNzdWUgZncgY29tbWFuZHMsIHNvIGl0IHdpbGwgb25seQ0KPiA+ID4gPiBkaXNw
bGF5DQo+ID4gPiA+IGNhY2hlZCBjb3VudGVycyBpbiB0aGUgZHJpdmVyLg0KPiA+ID4gPiANCj4g
PiA+ID4gQWRkIGEgU1cgY291bnRlciAobWNhc3RfcGFja2V0cykgaW4gdGhlIGRyaXZlciB0byBj
b3VudCByeA0KPiA+ID4gPiBtdWx0aWNhc3QNCj4gPiA+ID4gcGFja2V0cy4gVGhlIGNvdW50ZXIg
YWxzbyBjb3VudHMgYnJvYWRjYXN0IHBhY2tldHMsIGFzIHdlDQo+ID4gPiA+IGNvbnNpZGVyDQo+
ID4gPiA+IGl0IGENCj4gPiA+ID4gc3BlY2lhbCBjYXNlIG9mIG11bHRpY2FzdC4NCj4gPiA+ID4g
VXNlIHRoZSBjb3VudGVyIHZhbHVlIHdoZW4gY2FsbGluZyAiaXAgLXMiLyJpZmNvbmZpZyIuICBE
aXNwbGF5DQo+ID4gPiA+IHRoZQ0KPiA+ID4gPiBuZXcNCj4gPiA+ID4gY291bnRlciB3aGVuIGNh
bGxpbmcgImV0aHRvb2wgLVMiLCBhbmQgYWRkIGEgbWF0Y2hpbmcgY291bnRlcg0KPiA+ID4gPiAo
bWNhc3RfYnl0ZXMpIGZvciBjb21wbGV0ZW5lc3MuICANCj4gPiA+IA0KPiA+ID4gV2hhdCBpcyB0
aGUgcHJvYmxlbSB0aGF0IGlzIGJlaW5nIHNvbHZlZCBoZXJlIGV4YWN0bHk/DQo+ID4gPiANCj4g
PiA+IERldmljZSBjb3VudHMgbWNhc3Qgd3JvbmcgLyB1bnN1aXRhYmx5Pw0KPiA+ID4gICANCj4g
PiANCj4gPiBUbyByZWFkIG1jYXN0IGNvdW50ZXIgd2UgbmVlZCB0byBleGVjdXRlIEZXIGNvbW1h
bmQgd2hpY2ggaXMNCj4gPiBibG9ja2luZywNCj4gPiB3ZSBjYW4ndCBibG9jayBpbiBhdG9taWMg
Y29udGV4dCAubmRvX2dldF9zdGF0czY0IDooIC4uIHdlIGhhdmUgdG8NCj4gPiBjb3VudCBpbiBT
Vy4gDQo+ID4gDQo+ID4gdGhlIHByZXZpb3VzIGFwcHJvYWNoIHdhc24ndCBhY2N1cmF0ZSBhcyB3
ZSByZWFkIHRoZSBtY2FzdCBjb3VudGVyDQo+ID4gaW4gYQ0KPiA+IGJhY2tncm91bmQgdGhyZWFk
IHRyaWdnZXJlZCBieSB0aGUgcHJldmlvdXMgcmVhZC4uIHNvIHdlIHdlcmUgb2ZmDQo+ID4gYnkN
Cj4gPiB0aGUgaW50ZXJ2YWwgYmV0d2VlbiB0d28gcmVhZHMuDQo+IA0KPiBBbmQgdGhhdCdzIGJh
ZCBlbm91Z2ggdG8gY2F1c2UgdHJvdWJsZT8gV2hhdCdzIHRoZSB3b3JzdCBjYXNlIHRpbWUNCj4g
ZGVsdGEgeW91J3JlIHNlZWluZz8NCj4gDQoNCkRlcGVuZHMgb24gdGhlIHVzZXIgZnJlcXVlbmN5
IHRvIHJlYWQgc3RhdHMsDQppZiB5b3UgcmVhZCBzdGF0cyBvbmNlIGV2ZXJ5IDUgbWludXRlcyB0
aGVuIG1jYXN0IHN0YXRzIGFyZSBvZmYgYnkgNQ0KbWludXRlcy4uDQoNCkp1c3QgdGhpbmtpbmcg
b3V0IGxvdWQsIGlzIGl0IG9rIG9mIHdlIGJ1c3kgbG9vcCBhbmQgd2FpdCBmb3IgRlcNCnJlc3Bv
bnNlIGZvciBtY2FzdCBzdGF0cyBjb21tYW5kcyA/IA0KDQpJbiBldGh0b29sIC1TIHRob3VnaCwg
dGhleSBhcmUgYWNjdXJhdGUgc2luY2Ugd2UgZ3JhYiB0aGVtIG9uIHRoZSBzcG90DQpmcm9tIEZX
Lg0KDQo+ID4gPiA+IEZpeGVzOiBmNjJiOGJiOGYyZDMgKCJuZXQvbWx4NTogRXh0ZW5kIG1seDVf
Y29yZSB0byBzdXBwb3J0DQo+ID4gPiA+IENvbm5lY3RYLTQgRXRoZXJuZXQgZnVuY3Rpb25hbGl0
eSIpDQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFJvbiBEaXNraW4gPHJvbmRpQG1lbGxhbm94LmNv
bT4NCj4gPiA+ID4gUmV2aWV3ZWQtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNv
bT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5v
eC5jb20+ICANCg==
