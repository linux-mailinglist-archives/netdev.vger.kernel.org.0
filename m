Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F9D78D73
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfG2OHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:07:32 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27956 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726556AbfG2OHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 10:07:32 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6TE4jte018499;
        Mon, 29 Jul 2019 07:07:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=y/cSpJZkSKGKAKnDwopZIlAFlF+dpyV1brFWY/bETyw=;
 b=NgCjk443QoVf3Ka/qNDTdnwz7HRY8pM0UL60AHLG9KqCgT40RA7BwArOPXS8QgdbKA5Z
 C2ZvbEGFcdD07BGqCs1TaKBtQddAghblXD/K84GCNGaZpFGjjBRDeE0apAqGkREWv1c3
 azQJZYk1hoQyUZjcUn+YwnW2wF0xWkiYOXYb8GAy7O8oE29FJI3Mjs7TPg6LblxurCfx
 ScNZDOd7O3uIowcTUI0igRyADc1qgyfXHeUEEiY8z1tTJclIzRiniYv791IqzIBKar5n
 bKTPurPsPwnRO3hYoAXmjtmnv+gK0zpUE+yzbn8P12w8Vjk00vyAw4bJKTvOyjQv5ZGY Yw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u0kyq0eam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jul 2019 07:07:27 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 29 Jul
 2019 07:07:26 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.57) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 29 Jul 2019 07:07:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXWYUaxOeMVP8FchhbAtV8W+vuOD28mjUNvr9nJGpXMU2pwviNHuEiI71LzjbfvhRB/13hB8GiKn6GJOp5kZVF71Wh/BX5uiz6o6fswHrsNupCVOiYf3fwSu6L24gUE5Vg+7wBrMin49pwl+ZR4FIonwTsSsAHuuXG5PlrThte67g7HicMCl/wj3Z12Z9ES9Fejl3vg1sWC9L49zfyZKyVGSCq+Z/dbz8bNACoBuLYCSuoJAjiO1dB0d5U1GBoU5/Ua8RPyMkdrFvYmuGZJthy16GOkGC0OIXrnEpoU/etF2nlH+9vvvZDhN/MxUyAgCr5Qhy2ZSkRQIHr7PflNw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/cSpJZkSKGKAKnDwopZIlAFlF+dpyV1brFWY/bETyw=;
 b=SiQkoLy5xbn/iwlZ40Vk7NlHvxL7BsZa1jlA1uDChSODwWLkDfFZf/wZK7zVnJ5jhiu9XNw2lmMzyL5eFOhmGT8yNpIH+wMaNxgAzyp+m6Tagai4MoexM+Fb4mGSEVAI6mCqJLsI8J1Otl3L/LsjxG3er51eONt8ewdd5xS9uIyq2CrqloxOKVFMbtLgmGiK6jlrob9Jqael+U+u4Vg7QYiO9CQCoIKcSIFaYaxrRSeajado1f+tBjD65xhPQXd89Cr1aoJ4ZeiyFJEyfDKc+wQWq/UzqNk6UZ2fqwWzqgydzC8o6nRWSa8KtFY5QgO7Xye0pPRBtOzWKvEuq3Xkbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/cSpJZkSKGKAKnDwopZIlAFlF+dpyV1brFWY/bETyw=;
 b=ZKRPp9e0/5Bs/JJ0zOU3/jrj3UT8KngPQWlPtQoG6vFgYtGCrd08B2Q2plOCL0ZzSd02c8IHMronPPeCn2qzry4gV7RFZobyjlynRjXM7XKBkAhNjNvZOL1rx1P+dbFY7fWH73x9u9W6nr+VapVPF2l85qMc22p+B60vS2nMPQI=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3424.namprd18.prod.outlook.com (10.255.239.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 14:07:23 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 14:07:23 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Gal Pressman <galpress@amazon.com>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Thread-Topic: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Thread-Index: AQHVNmFHCA5NoSkqKU2zcNxJe13QUKbbt5QAgAX1jTCAABAnAIAAAayw
Date:   Mon, 29 Jul 2019 14:07:23 +0000
Message-ID: <MN2PR18MB31823CA6395E3DCBC16B2647A1DD0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
 <MN2PR18MB3182F4557BC042EE37A3C565A1DD0@MN2PR18MB3182.namprd18.prod.outlook.com>
 <d632598e-0896-fa10-9148-73794a9a49d7@amazon.com>
In-Reply-To: <d632598e-0896-fa10-9148-73794a9a49d7@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b07eb065-a18e-413f-6fd7-08d7142e144a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3424;
x-ms-traffictypediagnostic: MN2PR18MB3424:
x-microsoft-antispam-prvs: <MN2PR18MB342444532732B17E3881C9ADA1DD0@MN2PR18MB3424.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(9686003)(52536014)(6116002)(6246003)(74316002)(55016002)(5660300002)(305945005)(99286004)(25786009)(66946007)(64756008)(66556008)(66476007)(4326008)(53936002)(3846002)(66066001)(66446008)(86362001)(76116006)(71200400001)(71190400001)(6436002)(8676002)(68736007)(81156014)(186003)(14454004)(76176011)(14444005)(229853002)(476003)(53546011)(110136005)(8936002)(498600001)(486006)(54906003)(2906002)(6506007)(33656002)(102836004)(81166006)(11346002)(446003)(7736002)(7696005)(26005)(256004)(130980200001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3424;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZCE5OaHxEu5l0sbgBJ3cpcNg/wWv4kpOWtpiQ3SypUgjSaDZiE+ULIfKBcMCxsPMlsURLFMPBnsU6DreREms0fwPuz7qJWVnDbpLXMGEjo8on3KVYQdaCq8TRuOULZoND8ODpwvUpCyK/y/H6hLaxP4GHMDsVXdCb6PlxlH7qe8P0l4v3TXSNuowNTLSp724YMu+5BFt7I+ihpkM8pbUk+f7T6XBJo37bzpxCmLta7eC/5qCK/PvNEZwMtaFZMg0ta8kaclwMaFvFhS2RS9aIkU2uDXwiDzakYTc4cfmxkFKT04SyKeZmgEmjLGsaCeFQ0+wV1OYkqhwCTzwA6WytSEkOGr68F3G5I6fYd49iCBVd4XsA04Bt8/Wta+PwFoljVtv2HJemcMGcw6YsLKHoiDjvNO7YvWa14K0vGLNhC8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b07eb065-a18e-413f-6fd7-08d7142e144a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 14:07:23.6169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3424
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-29_07:2019-07-29,2019-07-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBHYWwgUHJlc3NtYW4gPGdhbHByZXNzQGFtYXpvbi5jb20+DQo+IFNlbnQ6IE1vbmRh
eSwgSnVseSAyOSwgMjAxOSA0OjU0IFBNDQo+IA0KPiBPbiAyOS8wNy8yMDE5IDE1OjU4LCBNaWNo
YWwgS2FsZGVyb24gd3JvdGU6DQo+ID4+IEZyb206IGxpbnV4LXJkbWEtb3duZXJAdmdlci5rZXJu
ZWwub3JnIDxsaW51eC1yZG1hLQ0KPiA+PiBvd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uIEJlaGFs
ZiBPZiBKYXNvbiBHdW50aG9ycGUNCj4gPj4NCj4gPj4+ICsJeGFfbG9jaygmdWNvbnRleHQtPm1t
YXBfeGEpOw0KPiA+Pj4gKwlpZiAoY2hlY2tfYWRkX292ZXJmbG93KHVjb250ZXh0LT5tbWFwX3hh
X3BhZ2UsDQo+ID4+PiArCQkJICAgICAgICh1MzIpKGxlbmd0aCA+PiBQQUdFX1NISUZUKSwNCj4g
Pj4+ICsJCQkgICAgICAgJm5leHRfbW1hcF9wYWdlKSkNCj4gPj4+ICsJCWdvdG8gZXJyX3VubG9j
azsNCj4gPj4NCj4gPj4gSSBzdGlsbCBkb24ndCBsaWtlIHRoYXQgdGhpcyBhbGdvcml0aG0gbGF0
Y2hlcyBpbnRvIGEgcGVybWFuZW50DQo+ID4+IGZhaWx1cmUgd2hlbiB0aGUgeGFfcGFnZSB3cmFw
cy4NCj4gPj4NCj4gPj4gSXQgc2VlbXMgd29ydGggc3BlbmRpbmcgYSBiaXQgbW9yZSB0aW1lIGhl
cmUgdG8gdGlkeSB0aGlzLi4gS2VlcA0KPiA+PiB1c2luZyB0aGUgbW1hcF94YV9wYWdlIHNjaGVt
ZSwgYnV0IGluc3RlYWQgZG8gc29tZXRoaW5nIGxpa2UNCj4gPj4NCj4gPj4gYWxsb2NfY3ljbGlj
X3JhbmdlKCk6DQo+ID4+DQo+ID4+IHdoaWxlICgpIHsNCj4gPj4gICAgLy8gRmluZCBmaXJzdCBl
bXB0eSBlbGVtZW50IGluIGEgY3ljbGljIHdheQ0KPiA+PiAgICB4YV9wYWdlX2ZpcnN0ID0gbW1h
cF94YV9wYWdlOw0KPiA+PiAgICB4YV9maW5kKHhhLCAmeGFfcGFnZV9maXJzdCwgVTMyX01BWCwg
WEFfRlJFRV9NQVJLKQ0KPiA+Pg0KPiA+PiAgICAvLyBJcyB0aGVyZSBhIGVub3VnaCByb29tIHRv
IGhhdmUgdGhlIHJhbmdlPw0KPiA+PiAgICBpZiAoY2hlY2tfYWRkX292ZXJmbG93KHhhX3BhZ2Vf
Zmlyc3QsIG5wYWdlcywgJnhhX3BhZ2VfZW5kKSkgew0KPiA+PiAgICAgICBtbWFwX3hhX3BhZ2Ug
PSAwOw0KPiA+PiAgICAgICBjb250aW51ZTsNCj4gPj4gICAgfQ0KPiA+Pg0KPiA+PiAgICAvLyBT
ZWUgaWYgdGhlIGVsZW1lbnQgYmVmb3JlIGludGVyc2VjdHMNCj4gPj4gICAgZWxtID0geGFfZmlu
ZCh4YSwgJnplcm8sIHhhX3BhZ2VfZW5kLCAwKTsNCj4gPj4gICAgaWYgKGVsbSAmJiBpbnRlcnNl
Y3RzKHhhX3BhZ2VfZmlyc3QsIHhhX3BhZ2VfbGFzdCwgZWxtLT5maXJzdCwgZWxtLQ0KPiA+bGFz
dCkpIHsNCj4gPj4gICAgICAgbW1hcF94YV9wYWdlID0gZWxtLT5sYXN0ICsgMTsNCj4gPj4gICAg
ICAgY29udGludWUNCj4gPj4gICAgfQ0KPiA+Pg0KPiA+PiAgICAvLyB4YV9wYWdlX2ZpcnN0IC0+
IHhhX3BhZ2VfZW5kIHNob3VsZCBub3cgYmUgZnJlZQ0KPiA+PiAgICB4YV9pbnNlcnQoeGEsIHhh
X3BhZ2Vfc3RhcnQsIGVudHJ5KTsNCj4gPj4gICAgbW1hcF94YV9wYWdlID0geGFfcGFnZV9lbmQg
KyAxOw0KPiA+PiAgICByZXR1cm4geGFfcGFnZV9zdGFydDsNCj4gPj4gfQ0KPiA+Pg0KPiA+PiBB
cHByb3hpbWF0ZWx5LCBwbGVhc2UgY2hlY2sgaXQuDQo+ID4gR2FsICYgSmFzb24sDQo+ID4NCj4g
PiBDb21pbmcgYmFjayB0byB0aGUgbW1hcF94YV9wYWdlIGFsZ29yaXRobS4gSSBjb3VsZG4ndCBm
aW5kIHNvbWUNCj4gYmFja2dyb3VuZCBvbiB0aGlzLg0KPiA+IFdoeSBkbyB5b3UgbmVlZCB0aGUg
bGVuZ3RoIHRvIGJlIHJlcHJlc2VudGVkIGluIHRoZSBtbWFwX3hhX3BhZ2UgPw0KPiA+IFdoeSBu
b3Qgc2ltcGx5IHVzZSB4YV9hbGxvY19jeWNsaWMgKCBsaWtlIGluIHNpdyApIFRoaXMgaXMgc2lt
cGx5IGENCj4gPiBrZXkgdG8gYSBtbWFwIG9iamVjdC4uLg0KPiANCj4gVGhlIGludGVudGlvbiB3
YXMgdGhhdCB0aGUgZW50cnkgd291bGQgIm9jY3VweSIgbnVtYmVyIG9mIHhhcnJheSBlbGVtZW50
cw0KPiBhY2NvcmRpbmcgdG8gaXRzIHNpemUgKGluIHBhZ2VzKS4gSXQgd2Fzbid0IGluaXRpYWxs
eSBsaWtlIHRoaXMsIGJ1dCBJSVJDIHRoaXMgd2FzDQo+IHByZWZlcnJlZCBieSBKYXNvbi4NCg0K
VGhhbmtzLCBzbyBKYXNvbiwgaWYgd2UncmUgbm93IGZyZWVpbmcgdGhlIG9iamVjdHMsIGNhbiB3
ZSBzaW1wbHkgdXMgeGFfYWxsb2NfY3ljbGljIGluc3RlYWQ/IA0KVGhhbmtzLA0KTWljaGFsDQo=
