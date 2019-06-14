Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C80C545E11
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfFNNZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:25:12 -0400
Received: from mail-eopbgr50088.outbound.protection.outlook.com ([40.107.5.88]:12356
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727612AbfFNNZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 09:25:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ns0rzmf1SKbQ25+0Wcu8vOvQE4uZjSVounGww5/RvZU=;
 b=OrbvQsJF5G8xvVK/vaIS9s6EHwbNsiN78hXMawE0iJQvAEOS8v+IkCRQyc2VgO7WFpYV7kXW+SW7cr88AzCzI/mpjuinmoIZX66+UHScmEx7B8FpjfaO4O9u6kMXJPak4uOeTv57HqzL2n8WOzxgY3xwXkzGnis9en5Qawt3dqE=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4359.eurprd05.prod.outlook.com (52.135.162.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Fri, 14 Jun 2019 13:25:05 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:25:05 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Thread-Topic: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Thread-Index: AQHVITdxVC+hU8LhkUKnNDgy7zjLlaaYdxEAgAEneoCAAEVvAIABQqyA
Date:   Fri, 14 Jun 2019 13:25:05 +0000
Message-ID: <f0d9e7cc-6266-a5d5-e371-dd355066b994@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612155605.22450-8-maximmi@mellanox.com>
 <20190612132352.7ee27bf3@cakuba.netronome.com>
 <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
 <20190613110956.001ef81f@cakuba.netronome.com>
In-Reply-To: <20190613110956.001ef81f@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0099.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::40) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b826b757-5352-41bd-5e0c-08d6f0cbb68e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4359;
x-ms-traffictypediagnostic: AM6PR05MB4359:
x-microsoft-antispam-prvs: <AM6PR05MB435905CACCD5A9FA0C1532B4D1EE0@AM6PR05MB4359.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(199004)(189003)(53936002)(305945005)(14454004)(25786009)(8676002)(8936002)(6116002)(54906003)(7736002)(3846002)(6436002)(4326008)(2906002)(6246003)(6486002)(81166006)(229853002)(81156014)(64756008)(478600001)(68736007)(66446008)(71190400001)(14444005)(316002)(486006)(6512007)(55236004)(6506007)(386003)(186003)(31686004)(53546011)(446003)(102836004)(11346002)(73956011)(31696002)(26005)(71200400001)(66946007)(66476007)(66556008)(99286004)(2616005)(86362001)(476003)(256004)(7416002)(76176011)(6916009)(36756003)(66066001)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4359;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zh6I9tku/O8qLLCp3OLMv5SFpxwJ/V1ISZ71oagqBwDWqfResvYnGCna942eXV7eWOjSlNkXoOUp5tt+pLUtgT4VCQ7fpSb52bZpVcCS/d5yTmXkaabzyjtHKLKfRIUmfKPQRMn270aqcyWNRX6PBizufFlW+Z4RQtDxc5GpKDTGmZ0pDZzxVFi9T/kn+rg+nBOj6sTbnb8SqXqv5XngeofrHUM8HhQOsnGRS/tCC7USqvdBUG2MBBRTNsxInh9VV+JRH6LvF/HWXWvZNDhS5Sx5VQHuXGkbO2nmSrRo7qrAjBTqTiJn9cwqwmhesqZBaX0boSsda0GlJbdLjgKwU+ejgK/GZqxMGyTzj44hBQGVvMarRTvg4n18TjvsL4R9TcKbszGTPBNAQ8G3bpvcYf37LayYefsyEvKC/5c4loU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F0DEBDEDAA9994CA5AF9BA6824D373A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b826b757-5352-41bd-5e0c-08d6f0cbb68e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:25:05.6631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xMyAyMTowOSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFRodSwgMTMg
SnVuIDIwMTkgMTQ6MDE6MzkgKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+IE9u
IDIwMTktMDYtMTIgMjM6MjMsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPj4+IE9uIFdlZCwgMTIg
SnVuIDIwMTkgMTU6NTY6NDggKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+Pj4g
Q3VycmVudGx5LCBsaWJicGYgdXNlcyB0aGUgbnVtYmVyIG9mIGNvbWJpbmVkIGNoYW5uZWxzIGFz
IHRoZSBtYXhpbXVtDQo+Pj4+IHF1ZXVlIG51bWJlci4gSG93ZXZlciwgdGhlIGtlcm5lbCBoYXMg
YSBkaWZmZXJlbnQgbGltaXRhdGlvbjoNCj4+Pj4NCj4+Pj4gLSB4ZHBfcmVnX3VtZW1fYXRfcWlk
KCkgYWxsb3dzIHVwIHRvIG1heChSWCBxdWV1ZXMsIFRYIHF1ZXVlcykuDQo+Pj4+DQo+Pj4+IC0g
ZXRodG9vbF9zZXRfY2hhbm5lbHMoKSBjaGVja3MgZm9yIFVNRU1zIGluIHF1ZXVlcyB1cCB0bw0K
Pj4+PiAgICAgY29tYmluZWRfY291bnQgKyBtYXgocnhfY291bnQsIHR4X2NvdW50KS4NCj4+Pj4N
Cj4+Pj4gbGliYnBmIHNob3VsZG4ndCBsaW1pdCBhcHBsaWNhdGlvbnMgdG8gYSBsb3dlciBtYXgg
cXVldWUgbnVtYmVyLiBBY2NvdW50DQo+Pj4+IGZvciBub24tY29tYmluZWQgUlggYW5kIFRYIGNo
YW5uZWxzIHdoZW4gY2FsY3VsYXRpbmcgdGhlIG1heCBxdWV1ZQ0KPj4+PiBudW1iZXIuIFVzZSB0
aGUgc2FtZSBmb3JtdWxhIHRoYXQgaXMgdXNlZCBpbiBldGh0b29sLg0KPj4+Pg0KPj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNraXkgPG1heGltbWlAbWVsbGFub3guY29tPg0KPj4+
PiBSZXZpZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPj4+PiBB
Y2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+Pj4NCj4+PiBJ
IGRvbid0IHRoaW5rIHRoaXMgaXMgY29ycmVjdC4gIG1heF90eCB0ZWxscyB5b3UgaG93IG1hbnkg
VFggY2hhbm5lbHMNCj4+PiB0aGVyZSBjYW4gYmUsIHlvdSBjYW4ndCBhZGQgdGhhdCB0byBjb21i
aW5lZC4gIENvcnJlY3QgY2FsY3VsYXRpb25zIGlzOg0KPj4+DQo+Pj4gbWF4X251bV9jaGFucyA9
IG1heChtYXhfY29tYmluZWQsIG1heChtYXhfcngsIG1heF90eCkpDQo+Pg0KPj4gRmlyc3Qgb2Yg
YWxsLCBJJ20gYWxpZ25pbmcgd2l0aCB0aGUgZm9ybXVsYSBpbiB0aGUga2VybmVsLCB3aGljaCBp
czoNCj4+DQo+PiAgICAgICBjdXJyLmNvbWJpbmVkX2NvdW50ICsgbWF4KGN1cnIucnhfY291bnQs
IGN1cnIudHhfY291bnQpOw0KPj4NCj4+IChzZWUgbmV0L2NvcmUvZXRodG9vbC5jLCBldGh0b29s
X3NldF9jaGFubmVscygpKS4NCj4gDQo+IGN1cnIgIT0gbWF4LiAgZXRodG9vbCBjb2RlIHlvdSdy
ZSBwb2ludGluZyBtZSB0byAoYW5kIHdoaWNoIEkgd3JvdGUpDQo+IHVzZXMgdGhlIGN1cnJlbnQg
YWxsb2NhdGlvbiwgbm90IHRoZSBtYXggdmFsdWVzLg0KDQpUaGUgZXRodG9vbCBjb2RlIHVzZXMg
Y3VyciwgYmVjYXVzZSBpdCB3YW50cyB0byBjYWxjdWxhdGUgdGhlIGFtb3VudCBvZiANCnF1ZXVl
cyBjdXJyZW50bHkgaW4gdXNlLiBsaWJicGYgdXNlcyBtYXgsIGJlY2F1c2UgaXQgd2FudHMgdG8g
Y2FsY3VsYXRlIA0KdGhlIG1heGltdW0gYW1vdW50IG9mIHF1ZXVlcyB0aGF0IGNhbiBiZSBpbiB1
c2UuIFRoYXQncyB0aGUgb25seSANCmRpZmZlcmVuY2UsIHNvIHRoZSBmb3JtdWxhIHNob3VsZCBi
ZSB0aGUgc2FtZSwgYW5kIHRoaXMgY2FsY3VsYXRpb24gY2FuIA0KYmUgYXBwbGllZCBlaXRoZXIg
dG8gY3VyciBvciB0byBtYXguDQoNCkltYWdpbmUgeW91IGhhdmUgY29uZmlndXJlZCB0aGUgTklD
IHRvIGhhdmUgdGhlIG1heGltdW0gc3VwcG9ydGVkIGFtb3VudCANCm9mIGNoYW5uZWxzLiBUaGVu
IHlvdXIgZm9ybXVsYSBpbiBldGh0b29sLmMgcmV0dXJucyBzb21lIHZhbHVlLiBFeGFjdGx5IA0K
dGhlIHNhbWUgdmFsdWUgc2hvdWxkIGFsc28gYmUgcmV0dXJuZWQgZnJvbSBsaWJicGYncyANCnhz
a19nZXRfbWF4X3F1ZXVlcygpLiBJdCdzIGFjaGlldmVkIGJ5IGFwcGx5aW5nIHlvdXIgZm9ybXVs
YSBkaXJlY3RseSB0byANCm1heC4NCg0KPj4gVGhlIGZvcm11bGEgaW4gbGliYnBmIHNob3VsZCBt
YXRjaCBpdC4NCj4gDQo+IFRoZSBmb3JtdWxhIHNob3VsZCBiZSBiYXNlZCBvbiB1bmRlcnN0YW5k
aW5nIHdoYXQgd2UncmUgZG9pbmcsDQo+IG5vdCBjb3B5aW5nIHNvbWUgbm90LXJlYWxseS1lcXVp
dmFsZW50IGNvZGUgZnJvbSBzb21ld2hlcmUgOikNCg0KSSBoYXZlIHVuZGVyc3RhbmRpbmcgb2Yg
dGhlIGNvZGUgSSB3cml0ZS4NCg0KPiBDb21iaW5lZCBpcyBhIGJhc2ljYWxseSBhIHF1ZXVlIHBh
aXIsIFJYIGlzIGFuIFJYIHJpbmcgd2l0aCBhIGRlZGljYXRlZA0KPiBJUlEsIGFuZCBUWCBpcyBh
IFRYIHJpbmcgd2l0aCBhIGRlZGljYXRlZCBJUlEuICBJZiBkcml2ZXIgc3VwcG9ydHMgYm90aA0K
PiBjb21iaW5lZCBhbmQgc2luZ2xlIHB1cnBvc2UgaW50ZXJydXB0IHZlY3RvcnMgaXQgd2lsbCBt
b3N0IGxpa2VseSBzZXQNCj4gDQo+IAltYXhfcnggPSBudW1faHdfcngNCj4gCW1heF90eCA9IG51
bV9od190eA0KPiAJbWF4X2NvbWJpbmVkID0gbWluKHJ4LCB0eCkNCg0KT0ssIEkgZ290IHlvdXIg
ZXhhbXBsZS4gVGhlIGRyaXZlciB5b3UgYXJlIHRhbGtpbmcgYWJvdXQgd29uJ3Qgc3VwcG9ydCAN
CnNldHRpbmcgcnhfY291bnQgPSBtYXhfcngsIHR4X2NvdW50ID0gbWF4X3R4IGFuZCBjb21iaW5l
ZF9jb3VudCA9IA0KbWF4X2NvbWJpbmVkIHNpbXVsdGFuZW91c2x5Lg0KDQpIb3dldmVyLCB4c2tf
Z2V0X21heF9xdWV1ZXMgaGFzIHRvIHJldHVybiB0aGUgbWF4aW11bSBudW1iZXIgb2YgcXVldWVz
IA0KdGhlb3JldGljYWxseSBwb3NzaWJsZSB3aXRoIHRoaXMgZGV2aWNlLCB0byBjcmVhdGUgeHNr
c19tYXAgb2YgYSANCnN1ZmZpY2llbnQgc2l6ZS4gQ3VycmVudGx5LCBpdCB0b3RhbGx5IGlnbm9y
ZXMgZGV2aWNlcyB3aXRob3V0IGNvbWJpbmVkIA0KY2hhbm5lbHMsIHNvIG1heF9yeCBhbmQgbWF4
X3R4IGhhdmUgdG8gYmUgY29uc2lkZXJlZCBpbiB0aGUgY2FsY3VsYXRpb24uIA0KTmV4dCB0aGlu
ZyBpcyB0aGF0IGV0aHRvb2wgQVBJIGRvZXNuJ3QgcmVhbGx5IHRlbGwgeW91IHdoZXRoZXIgdGhl
IA0KZGV2aWNlIGNhbiBjcmVhdGUgdXAgdG8gbWF4X3J4IFJYIGNoYW5uZWxzLCBtYXhfdHggVFgg
Y2hhbm5lbHMgYW5kIA0KbWF4X2NvbWJpbmVkIGNvbWJpbmVkIGNoYW5uZWxzIHNpbXVsdGFuZW91
c2x5LCBvciB0aGVyZSBhcmUgc29tZSANCmFkZGl0aW9uYWwgbGltaXRhdGlvbnMuIFlvdXIgZXhh
bXBsZSBkaXNwbGF5cyBzdWNoIGEgbGltaXRhdGlvbiwgYnV0IA0KaXQncyBub3QgdGhlIG9ubHkg
cG9zc2libGUgb25lLCBhbmQgdGhpcyBsaW1pdGF0aW9uIGlzIG5vdCBldmVuIA0KbWFuZGF0b3J5
IGZvciBhbGwgZHJpdmVycy4gQXMgZXRodG9vbCBkb2Vzbid0IGV4cG9zZSB0aGUgaW5mb3JtYXRp
b24gDQphYm91dCBhZGRpdGlvbmFsIGxpbWl0YXRpb25zIGltcG9zZWQgYnkgdGhlIGRyaXZlciwg
YW5kIGFzIGl0IHdvbid0IGh1cnQgDQppZiB4c2tzX21hcCB3aWxsIGJlIGJpZ2dlciB0aGFuIG5l
Y2Vzc2FyeSwgbXkgdmlzaW9uIGlzIHRoYXQgd2UgDQpzaG91bGRuJ3QgYXNzdW1lIGFueSBsaW1p
dGF0aW9ucyB3ZSBhcmUgbm90IHN1cmUgYWJvdXQsIHNvIG1heF9jb21iaW5lZCANCisgbWF4KG1h
eF9yeCwgbWF4X3R4KSBpcyB0aGUgcmlnaHQgdGhpbmcgdG8gZG8uDQoNCj4gTGlrZSB3aXRoIG1v
c3QgZXRodG9vbCBBUElzIHRoZXJlIGFyZSBzb21lIHZhcmlhdGlvbnMgdG8gdGhpcy4NCj4gDQo+
PiBTZWNvbmQsIHRoZSBleGlzdGluZyBkcml2ZXJzIGhhdmUgZWl0aGVyIGNvbWJpbmVkIGNoYW5u
ZWxzIG9yIHNlcGFyYXRlDQo+PiByeCBhbmQgdHggY2hhbm5lbHMuIFNvLCBmb3IgdGhlIGZpcnN0
IGtpbmQgb2YgZHJpdmVycywgbWF4X3R4IGRvZXNuJ3QNCj4+IHRlbGwgaG93IG1hbnkgVFggY2hh
bm5lbHMgdGhlcmUgY2FuIGJlLCBpdCBqdXN0IHNheXMgMCwgYW5kIG1heF9jb21iaW5lZA0KPj4g
dGVsbHMgaG93IG1hbnkgVFggYW5kIFJYIGNoYW5uZWxzIGFyZSBzdXBwb3J0ZWQuIEFzIG1heF90
eCBkb2Vzbid0DQo+PiBpbmNsdWRlIG1heF9jb21iaW5lZCAoYW5kIHZpY2UgdmVyc2EpLCB3ZSBz
aG91bGQgYWRkIHRoZW0gdXAuDQo+IA0KPiBCeSBleGlzdGluZyBkcml2ZXJzIHlvdSBtZWFuIElu
dGVsIGRyaXZlcnMgd2hpY2ggaW1wbGVtZW50IEFGX1hEUCwNCj4gYW5kIHlvdXIgZHJpdmVyPw0K
DQpObywgSSBtZWFudCBhbGwgZHJpdmVycywgbm90IG9ubHkgQUZfWERQLWVuYWJsZWQgb25lcy4g
SSB3YXNuJ3QgYXdhcmUgDQp0aGF0IHNvbWUgb2YgdGhlbSBzdXBwb3J0IHRoZSBjaG9pY2UgYmV0
d2VlbiBhIGNvbWJpbmVkIGNoYW5uZWwgYW5kIGEgDQp1bmlkaXJlY3Rpb25hbCBjaGFubmVsLCBo
b3dldmVyLCBJIHN0aWxsIGZpbmQgbXkgZm9ybXVsYSBjb3JyZWN0IChzZWUgDQp0aGUgZXhwbGFu
YXRpb24gYWJvdmUpLg0KDQo+IEJvdGggSW50ZWwgYW5kIE1MWCBkcml2ZXJzIHNlZW0gdG8gb25s
eSBzZXQNCj4gbWF4X2NvbWJpbmVkLg0KbWx4NCBkb2Vzbid0IHN1cHBvcnQgY29tYmluZWQgY2hh
bm5lbHMsIGJ1dCBpdCdzIG91dCBvZiBzY29wZSBvZiB0aGlzIA0KcGF0Y2hzZXQuDQoNCj4gSWYg
eW91IG1lYW4gYWxsIGRyaXZlcnMgYWNyb3NzIHRoZSBrZXJuZWwsIHRoZW4gSSBiZWxpZXZlIHRo
ZSBiZXN0DQo+IGZvcm11bGEgaXMgd2hhdCBJIGdhdmUgeW91Lg0KPiANCj4+Pj4gICAgdG9vbHMv
bGliL2JwZi94c2suYyB8IDYgKysrLS0tDQo+Pj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS90b29scy9s
aWIvYnBmL3hzay5jIGIvdG9vbHMvbGliL2JwZi94c2suYw0KPj4+PiBpbmRleCBiZjE1YTgwYTM3
YzIuLjg2MTA3ODU3ZTFmMCAxMDA2NDQNCj4+Pj4gLS0tIGEvdG9vbHMvbGliL2JwZi94c2suYw0K
Pj4+PiArKysgYi90b29scy9saWIvYnBmL3hzay5jDQo+Pj4+IEBAIC0zMzQsMTMgKzMzNCwxMyBA
QCBzdGF0aWMgaW50IHhza19nZXRfbWF4X3F1ZXVlcyhzdHJ1Y3QgeHNrX3NvY2tldCAqeHNrKQ0K
Pj4+PiAgICAJCWdvdG8gb3V0Ow0KPj4+PiAgICAJfQ0KPj4+PiAgICANCj4+Pj4gLQlpZiAoY2hh
bm5lbHMubWF4X2NvbWJpbmVkID09IDAgfHwgZXJybm8gPT0gRU9QTk9UU1VQUCkNCj4+Pj4gKwly
ZXQgPSBjaGFubmVscy5tYXhfY29tYmluZWQgKyBtYXgoY2hhbm5lbHMubWF4X3J4LCBjaGFubmVs
cy5tYXhfdHgpOw0KPj4+PiArDQo+Pj4+ICsJaWYgKHJldCA9PSAwIHx8IGVycm5vID09IEVPUE5P
VFNVUFApDQo+Pj4+ICAgIAkJLyogSWYgdGhlIGRldmljZSBzYXlzIGl0IGhhcyBubyBjaGFubmVs
cywgdGhlbiBhbGwgdHJhZmZpYw0KPj4+PiAgICAJCSAqIGlzIHNlbnQgdG8gYSBzaW5nbGUgc3Ry
ZWFtLCBzbyBtYXggcXVldWVzID0gMS4NCj4+Pj4gICAgCQkgKi8NCj4+Pj4gICAgCQlyZXQgPSAx
Ow0KPj4+PiAtCWVsc2UNCj4+Pj4gLQkJcmV0ID0gY2hhbm5lbHMubWF4X2NvbWJpbmVkOw0KPj4+
PiAgICANCj4+Pj4gICAgb3V0Og0KPj4+PiAgICAJY2xvc2UoZmQpOw0KDQo=
