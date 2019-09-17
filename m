Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D10B5416
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 19:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbfIQRYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 13:24:03 -0400
Received: from mail-eopbgr810059.outbound.protection.outlook.com ([40.107.81.59]:34409
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726548AbfIQRYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 13:24:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIw18SnzgscAeDOPwQcrAvenDZO/+d/oUhbHFNDFdVmszNBRj6xH+FcI1d7Fq0GIsBDEvu5hgQjqEM0N2kfj5AbpTbkasf3s5NMO1Ibc4X5BQowjRtH68CAA28LMPhZKraTqzqNaqmJKchiun4q7kDkKdRqPPxVIxfqrFmp8QoGpcUZ/Vox3NLAdF804u26evz37lKFPX2OZfVaOdKeFzBZ7Pbnw0R20mBTjnvYrA6Rkb1X7xLFvg+7S87+OGffWavFV6TOAQXXLiyuVUSPIKuUmbJTZ4jWY4k+BZlTeX8BG8diOBkYQJ+Qbf2dsTYhNvpoPkf9iJKP8nKMVgu03FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8079Pa78PHSBv4iJTQldTkyNFS/lZ3NzF0DQ5aWr5w=;
 b=hXhnj7KfF9lwH2oBZ5qSmSK8KDh9rGgvBmfedjC3EdB6xojy9dQlOzjtZ/K5nE4eXEl20xkKdDwyUesAQCSUPpSNgrEfgg0Zz1F8lwjhucnXvASN4FB0svpY1y0Eg78JspzgGSutSTQeKB21tvrsTFzFp9LzsxPW6Fwlu8h+SMVMlfHqO0N9qMJ4Mv/hOa+NSXjsoDfF3oAxFjEqGtlJvvihbCgAf8arxVDuiYdDZRsEZMJXJxmbFRTLRUJqy+8XoF+OF0YLlq3qxItpe3lMqXVAEv2DnV01izGaFH2oGuvkRecTFWgAd04fzy5hIt0Za4+voDaWioqrsUfZUwfVbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8079Pa78PHSBv4iJTQldTkyNFS/lZ3NzF0DQ5aWr5w=;
 b=3pRvxA0ZGbpobIqR2SDm2lTsZ8edAEQ6905Ma+o+jFCx/12jsbe6YYt2jv2g9P2qMjVZxD89P7ibwxO7/3fZ7h9SYzXBaI+2ZyqBIhbt8BLeI/u81+Ntgav6brEdqb3vD4eRN1MItKR1GNl3hG7fTtzXMtWGJaK0yImsqj2knCo=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3628.namprd12.prod.outlook.com (20.178.199.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Tue, 17 Sep 2019 17:24:00 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::585:2d27:6e06:f9b0]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::585:2d27:6e06:f9b0%7]) with mapi id 15.20.2263.023; Tue, 17 Sep 2019
 17:23:58 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        David Bolvansky <david.bolvansky@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: -Wsizeof-array-div warnings in ethernet drivers
Thread-Topic: -Wsizeof-array-div warnings in ethernet drivers
Thread-Index: AQHVbSoUswguwnQmjEqavzG+PPlsbqcwHwoA
Date:   Tue, 17 Sep 2019 17:23:58 +0000
Message-ID: <c5028a69-38eb-6390-9db6-aa9e58f9b8e8@amd.com>
References: <20190917073232.GA14291@archlinux-threadripper>
In-Reply-To: <20190917073232.GA14291@archlinux-threadripper>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0074.namprd05.prod.outlook.com
 (2603:10b6:803:22::12) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 250a8052-ffd6-436d-5570-08d73b93d2e9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3628;
x-ms-traffictypediagnostic: DM6PR12MB3628:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR12MB362883BA2C894BE1B954B0F7EC8F0@DM6PR12MB3628.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:58;
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(53754006)(199004)(189003)(6486002)(102836004)(478600001)(5660300002)(305945005)(186003)(7736002)(31686004)(31696002)(86362001)(6512007)(6306002)(476003)(6246003)(11346002)(36756003)(14444005)(4326008)(486006)(256004)(54906003)(2616005)(446003)(26005)(110136005)(53546011)(966005)(386003)(6436002)(14454004)(229853002)(6116002)(76176011)(7416002)(8936002)(99286004)(3846002)(64756008)(66556008)(66476007)(66946007)(52116002)(6506007)(66066001)(316002)(71190400001)(2906002)(81166006)(66446008)(71200400001)(8676002)(81156014)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3628;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QvNfNIb35OrNrhRxSlwc6fcwQR+dl99L/PQCHH2DICDGebVAfcpG+QCyrBFvT6hXZdc83UV4K015g/1qTbjDNkufhBsDtghx7Ao2UlKJR6A4wcAuZPBbulMUcB9wqURbpV1B3yyQ9QVUsIBED8YME31JBW5RRwyPG+EBGxYpp+8hUHmReYgh0mppdhegNPUXWvuvrKX930fDMFdpIhZ+vGqTH4gNxA4v3wC+c5qiwtzuMXNTkTUutgWGP1XJzfXZshqj1fuoy97EKwj6D+otvHnyyF7+1Otj3flsqh3MMOT9c8yPpSrCyEStD02b25hcEMrCO+/PvjXzIFJ81ed1TUYxIwu1Ek9m7L0ua07Pdqz6aaM6wsqWErK12Xv70VyNsBouD8umyFnVmBqJ+U67OPCGBoDHUdeDPwlYd6rFOZM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3E614633159794AA0A212A132120257@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 250a8052-ffd6-436d-5570-08d73b93d2e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2019 17:23:58.4850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WNVXOqIDvVjTY+HcLGJwCMmnUPUcQlAsgmoCRtsQl0KsqNFlxifmOs0cDuFnr1hK1ppyX8Sf2OYZxbbDCwXDgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3628
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8xNy8xOSAyOjMyIEFNLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90ZToNCj4gSGkgYWxsLA0K
PiANCj4gQ2xhbmcgcmVjZW50bHkgYWRkZWQgYSBuZXcgZGlhZ25vc3RpYyBpbiByMzcxNjA1LCAt
V3NpemVvZi1hcnJheS1kaXYsDQo+IHRoYXQgdHJpZXMgdG8gd2FybiB3aGVuIHNpemVvZihYKSAv
IHNpemVvZihZKSBkb2VzIG5vdCBjb21wdXRlIHRoZQ0KPiBudW1iZXIgb2YgZWxlbWVudHMgaW4g
YW4gYXJyYXkgWCAoaS5lLiwgc2l6ZW9mKFkpIGlzIHdyb25nKS4gU2VlIHRoYXQNCj4gY29tbWl0
IGZvciBtb3JlIGRldGFpbHM6DQo+IA0KPiBodHRwczovL2dpdGh1Yi5jb20vbGx2bS9sbHZtLXBy
b2plY3QvY29tbWl0LzMyNDBhZDRjZWQwZDMyMjMxNDliNzJhNGZjMmE0ZDliNjc1ODk0MjcNCj4g
DQo+IFNvbWUgZXRoZXJuZXQgZHJpdmVycyBoYXZlIGFuIGluc3RhbmNlIG9mIHRoaXMgd2Fybmlu
ZyBkdWUgdG8gcmVjZWl2ZQ0KPiBzaWRlIHNjYWxpbmcgc3VwcG9ydDoNCj4gDQo+IA0KPiAuLi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9hbWQveGdiZS94Z2JlLWRldi5jOjM2MTo0OTogd2FybmluZzog
ZXhwcmVzc2lvbg0KPiBkb2VzIG5vdCBjb21wdXRlIHRoZSBudW1iZXIgb2YgZWxlbWVudHMgaW4g
dGhpcyBhcnJheTsgZWxlbWVudCB0eXBlIGlzDQo+ICd1OCcgKGFrYSAndW5zaWduZWQgY2hhcicp
LCBub3QgJ3UzMicgKGFrYSAndW5zaWduZWQgaW50JykNCj4gWy1Xc2l6ZW9mLWFycmF5LWRpdl0N
Cj4gICAgICAgICB1bnNpZ25lZCBpbnQga2V5X3JlZ3MgPSBzaXplb2YocGRhdGEtPnJzc19rZXkp
IC8gc2l6ZW9mKHUzMik7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IH5+fn5+fn5+fn5+fn5+ICBeDQo+IC4uL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtZC94Z2JlL3hn
YmUtZGV2LmM6MzYxOjQ5OiBub3RlOiBwbGFjZQ0KPiBwYXJlbnRoZXNlcyBhcm91bmQgdGhlICdz
aXplb2YodTMyKScgZXhwcmVzc2lvbiB0byBzaWxlbmNlIHRoaXMgd2FybmluZw0KPiANCj4gDQo+
IC4uL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3eGdtYWMyX2NvcmUuYzo1
Mzc6MzY6IHdhcm5pbmc6DQo+IGV4cHJlc3Npb24gZG9lcyBub3QgY29tcHV0ZSB0aGUgbnVtYmVy
IG9mIGVsZW1lbnRzIGluIHRoaXMgYXJyYXk7DQo+IGVsZW1lbnQgdHlwZSBpcyAndTgnIChha2Eg
J3Vuc2lnbmVkIGNoYXInKSwgbm90ICd1MzInIChha2EgJ3Vuc2lnbmVkDQo+IGludCcpIFstV3Np
emVvZi1hcnJheS1kaXZdDQo+ICAgICAgICAgZm9yIChpID0gMDsgaSA8IChzaXplb2YoY2ZnLT5r
ZXkpIC8gc2l6ZW9mKHUzMikpOyBpKyspIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB+fn5+fn5+fiAgXg0KPiAuLi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1h
Yy9kd3hnbWFjMl9jb3JlLmM6NTM3OjM2OiBub3RlOg0KPiBwbGFjZSBwYXJlbnRoZXNlcyBhcm91
bmQgdGhlICdzaXplb2YodTMyKScgZXhwcmVzc2lvbiB0byBzaWxlbmNlIHRoaXMNCj4gd2Fybmlu
Zw0KPiANCj4gDQo+IC4uL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N5bm9wc3lzL2R3Yy14bGdtYWMt
aHcuYzoyMzI5OjQ5OiB3YXJuaW5nOg0KPiBleHByZXNzaW9uIGRvZXMgbm90IGNvbXB1dGUgdGhl
IG51bWJlciBvZiBlbGVtZW50cyBpbiB0aGlzIGFycmF5Ow0KPiBlbGVtZW50IHR5cGUgaXMgJ3U4
JyAoYWthICd1bnNpZ25lZCBjaGFyJyksIG5vdCAndTMyJyAoYWthICd1bnNpZ25lZA0KPiBpbnQn
KSBbLVdzaXplb2YtYXJyYXktZGl2XQ0KPiAgICAgICAgIHVuc2lnbmVkIGludCBrZXlfcmVncyA9
IHNpemVvZihwZGF0YS0+cnNzX2tleSkgLyBzaXplb2YodTMyKTsNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfn5+fn5+fn5+fn5+fn4gIF4NCj4gLi4vZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc3lub3BzeXMvZHdjLXhsZ21hYy1ody5jOjIzMjk6NDk6IG5vdGU6IHBsYWNl
DQo+IHBhcmVudGhlc2VzIGFyb3VuZCB0aGUgJ3NpemVvZih1MzIpJyBleHByZXNzaW9uIHRvIHNp
bGVuY2UgdGhpcyB3YXJuaW5nDQo+IA0KPiANCj4gV2hhdCBpcyB0aGUgcmVhc29uaW5nIGJlaGlu
ZCBoYXZpbmcgdGhlIGtleSBiZWluZyBhbiBhcnJheSBvZiB1OHMgYnV0DQo+IHNlZW1saW5nbHkg
Y29udmVydGluZyBpdCBpbnRvIGFuIGFycmF5IG9mIHUzMnM/IEl0J3Mgbm90IGltbWVkaWF0ZWx5
DQoNClByb2JhYmx5IGJlY2F1c2UgdGhlIGV0aHRvb2wgZnVuY3Rpb25zIHRoYXQgZ2V0IGFuZCBz
ZXQgdGhlIFJTUyBrZXkgcGFzc2VzDQp0aGUga2V5IGJ1ZmZlciBpbiBhcyBhIHU4IHBvaW50ZXIu
ICBIYXZpbmcgc2FpZCB0aGF0LCB0aGVyZSdzIG5vIHJlYXNvbg0KdGhhdCBhbnkgY2FzdGluZyBj
YW4ndCBiZSBkb25lIGluIHRoZSBldGh0b29sIGNhbGxiYWNrIGZ1bmN0aW9ucywgaWYNCm5lZWRl
ZCAod2hpY2ggSSBkb24ndCB0aGluayBpdCBpcywgc2luY2UgdGhlIGtleSBidWZmZXIgaXMgdXNl
ZCBpbg0KbWVtY3B5KCkgY2FsbHMpLCBpbnN0ZWFkLg0KDQpUaGFua3MsDQpUb20NCg0KPiBhcHBh
cmVudCBmcm9tIHJlYWRpbmcgb3ZlciB0aGUgY29kZSBidXQgSSBhbSBub3QgZmFtaWxpYXIgd2l0
aCBpdCBzbyBJDQo+IG1pZ2h0IGJlIG1ha2luZyBhIG1pc3Rha2UuIEkgYXNzdW1lIHRoaXMgaXMg
aW50ZW50aW9uYWw/IElmIHNvLCB0aGUNCj4gd2FybmluZyBjYW4gYmUgc2lsZW5jZWQgYW5kIHdl
J2xsIHNlbmQgcGF0Y2hlcyB0byBkbyBzbyBidXQgd2Ugd2FudCB0bw0KPiBtYWtlIHN1cmUgd2Ug
YXJlbid0IGFjdHVhbGx5IHBhcGVyaW5nIG92ZXIgYSBtaXN0YWtlLj4NCj4gQ2hlZXJzIQ0KPiBO
YXRoYW4NCj4gDQo=
