Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F18117B81
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 00:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfLIXeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 18:34:10 -0500
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:7928
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbfLIXeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 18:34:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edqcvfnK2GsSmKUE+FP8QyLfNBcVAMKJ6GjSMLuxxflRT2vGhLDYBY4rVknIWqgDIXppf2vqNeRi5PEsicmaUa73qqDe5bT7Cd3cl/IlHdYNr19ZtlzUBOYLQFHzsegMRXCp9yTMqZKU9oFGg8OMaTdMzLN7YiKhfuIiD+zjPEiH6RWEa+UVVbCaIv1kmlEMJM8T0lBIrR67sroGu6HVF4Poy/EyRq9Ss7DZnwscAivSMGAIUz/R1+v+47h1y69FsrFLf3NWKxu82qpR5k2ZfsM8utuTyDfpnkSg6dl5oOL/NUv7fHiY78XOLc10/P1ANfCIvP4WJQjjM3Uu14fzKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8Uz1tS0wBGLtgtdMJduvyBuqkvVIkJVbf49FGl9id4=;
 b=U/o0cNFtfwCRPg5J3Zijg5E+3Cav2MSYCXzMidAEFwguKVapvrZUnec0pb5jSMsGZmxTSJJ48DDcG1KFR+wlFIxvD2qL9auWoqAljMgwya2txIOondT833fk78cSpHdVHq4UH/f23HSyjqrZeBvg7Jy04v6kWbzTcM2ZORiLjwC2z7v7OyDwENE5A+Pj4mV5x6uAvu4DYBShLLtyDAi6URDC7DboGiJtQj3JAcIZ4+knAUNXYDMpSrp6ahrO+ty4el06bRm30q6/Hu4UTuIp3SLlEYHugSJ+Xcy8qotHCMxCIPaBDKw/kyXlm/jtvXVg4nOLXn39rfrnpvjub6xWbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8Uz1tS0wBGLtgtdMJduvyBuqkvVIkJVbf49FGl9id4=;
 b=AVM1+aSHKayjuwoYFX3zk6fAH696ix7kXE5KAEcLWtMBO5ds2ROVikW5EbHtDUKdt1Z4e33yxjC3QaRwdgKoX1ReY2jJFoX/AucMwmtsf4ypgPw7cofG5TDfmyO7Ow403AGmjLKTwt+Dj/T5hwWUm5qo4FahHNyvvzImuKZGMSg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6495.eurprd05.prod.outlook.com (20.179.24.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Mon, 9 Dec 2019 23:34:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 23:34:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "brouer@redhat.com" <brouer@redhat.com>
CC:     "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Topic: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Index: AQHVrBgioGDhH/MP9UuNcNvu7zNf3aeuC1gAgAOw0QCAAL3ugA==
Date:   Mon, 9 Dec 2019 23:34:05 +0000
Message-ID: <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
         <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
         <20191209131416.238d4ae4@carbon>
In-Reply-To: <20191209131416.238d4ae4@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 08e3e5be-0da8-4902-9e5d-08d77d0047c0
x-ms-traffictypediagnostic: VI1PR05MB6495:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <VI1PR05MB6495A33D76B6C794555F9ABBBE580@VI1PR05MB6495.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(199004)(189003)(186003)(5640700003)(229853002)(305945005)(478600001)(2906002)(8936002)(1730700003)(8676002)(81166006)(6486002)(81156014)(86362001)(71190400001)(71200400001)(54906003)(118296001)(6916009)(316002)(26005)(66556008)(64756008)(2616005)(66946007)(66476007)(4326008)(66446008)(6512007)(36756003)(6506007)(91956017)(5660300002)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6495;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1PnBI94dyplgZ9TQPoL0OJttljGH+WA1sJxaqmy66wwbRjrxTHxC7IdIB/nodOsg6ZgfNWttUQrBN5xrvXhNj8SIshOkRpDMCiZljKjGeMwGh0T9XudW69UzO1FrqwTfb3QA6s1OwhlDQVwUg3EGeZgOagq39i6IfIL6avdynlNF0NTi2i587YHgj811zBTFxKFYFGltc483Z5qn4GKO1BKN3SfwB0p6Jfz/sq0k7si3YrO6oK62qpz8h/ru+vlIKbY+99VswAoyh5BiyN2bvRZniAlnibySJ60Y18gYxliIGMjrJLuIz6YUh0UudgVMyHFDK36UHKeCQAov7fcliUncARpxbfpG4nA8y248F406bIkwn5vkNG3BgVk31wTe9H6fJ7Y6jg/gM2tlVhr30KVWjj6f+asuGxkmgRUHvMZryXpKMvkr5dRDxQlVq2bG
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9F4EE345C6D2B48AC17BA95F3CD1B2C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e3e5be-0da8-4902-9e5d-08d77d0047c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 23:34:05.2020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6p8aVI+VQz5o26Go40BG5MdF8HTTqZM5Ws++w2BziCXzLjfXEnC43v7LJ+R2HqbDojv05srUEBmjVv8OSqg6wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6495
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTEyLTA5IGF0IDEzOjE0ICswMTAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IHdyb3RlOg0KPiBPbiBTYXQsIDcgRGVjIDIwMTkgMDM6NTI6NDEgKzAwMDANCj4gU2FlZWQgTWFo
YW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBGcmksIDIwMTkt
MTItMDYgYXQgMTc6MzIgKzA4MDAsIExpIFJvbmdRaW5nIHdyb3RlOg0KPiA+ID4gc29tZSBkcml2
ZXJzIHVzZXMgcGFnZSBwb29sLCBidXQgbm90IHJlcXVpcmUgdG8gYWxsb2NhdGUNCj4gPiA+IHBh
Z2VzIGZyb20gYm91bmQgbm9kZSwgb3Igc2ltcGx5IGFzc2lnbiBwb29sLnAubmlkIHRvDQo+ID4g
PiBOVU1BX05PX05PREUsIGFuZCB0aGUgY29tbWl0IGQ1Mzk0NjEwYjFiYSAoInBhZ2VfcG9vbDoN
Cj4gPiA+IERvbid0IHJlY3ljbGUgbm9uLXJldXNhYmxlIHBhZ2VzIikgd2lsbCBibG9jayB0aGlz
IGtpbmQNCj4gPiA+IG9mIGRyaXZlciB0byByZWN5Y2xlDQo+ID4gPiANCj4gPiA+IHNvIHRha2Ug
cGFnZSBhcyByZXVzYWJsZSB3aGVuIHBhZ2UgYmVsb25ncyB0byBjdXJyZW50DQo+ID4gPiBtZW1v
cnkgbm9kZSBpZiBuaWQgaXMgTlVNQV9OT19OT0RFDQo+ID4gPiANCj4gPiA+IHYxLS0+djI6IGFk
ZCBjaGVjayB3aXRoIG51bWFfbWVtX2lkIGZyb20gWXVuc2hlbmcNCj4gPiA+IA0KPiA+ID4gRml4
ZXM6IGQ1Mzk0NjEwYjFiYSAoInBhZ2VfcG9vbDogRG9uJ3QgcmVjeWNsZSBub24tcmV1c2FibGUN
Cj4gPiA+IHBhZ2VzIikNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxsaXJvbmdx
aW5nQGJhaWR1LmNvbT4NCj4gPiA+IFN1Z2dlc3RlZC1ieTogWXVuc2hlbmcgTGluIDxsaW55dW5z
aGVuZ0BodWF3ZWkuY29tPg0KPiA+ID4gQ2M6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFu
b3guY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgbmV0L2NvcmUvcGFnZV9wb29sLmMgfCA3ICsrKysr
Ky0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9wYWdlX3Bvb2wuYyBiL25ldC9j
b3JlL3BhZ2VfcG9vbC5jDQo+ID4gPiBpbmRleCBhNmFlZmU5ODkwNDMuLjNjOGI1MWNjZDFjMSAx
MDA2NDQNCj4gPiA+IC0tLSBhL25ldC9jb3JlL3BhZ2VfcG9vbC5jDQo+ID4gPiArKysgYi9uZXQv
Y29yZS9wYWdlX3Bvb2wuYw0KPiA+ID4gQEAgLTMxMiwxMiArMzEyLDE3IEBAIHN0YXRpYyBib29s
DQo+ID4gPiBfX3BhZ2VfcG9vbF9yZWN5Y2xlX2RpcmVjdChzdHJ1Y3QNCj4gPiA+IHBhZ2UgKnBh
Z2UsDQo+ID4gPiAgLyogcGFnZSBpcyBOT1QgcmV1c2FibGUgd2hlbjoNCj4gPiA+ICAgKiAxKSBh
bGxvY2F0ZWQgd2hlbiBzeXN0ZW0gaXMgdW5kZXIgc29tZSBwcmVzc3VyZS4NCj4gPiA+IChwYWdl
X2lzX3BmbWVtYWxsb2MpDQo+ID4gPiAgICogMikgYmVsb25ncyB0byBhIGRpZmZlcmVudCBOVU1B
IG5vZGUgdGhhbiBwb29sLT5wLm5pZC4NCj4gPiA+ICsgKiAzKSBiZWxvbmdzIHRvIGEgZGlmZmVy
ZW50IG1lbW9yeSBub2RlIHRoYW4gY3VycmVudCBjb250ZXh0DQo+ID4gPiArICogaWYgcG9vbC0+
cC5uaWQgaXMgTlVNQV9OT19OT0RFDQo+ID4gPiAgICoNCj4gPiA+ICAgKiBUbyB1cGRhdGUgcG9v
bC0+cC5uaWQgdXNlcnMgbXVzdCBjYWxsIHBhZ2VfcG9vbF91cGRhdGVfbmlkLg0KPiA+ID4gICAq
Lw0KPiA+ID4gIHN0YXRpYyBib29sIHBvb2xfcGFnZV9yZXVzYWJsZShzdHJ1Y3QgcGFnZV9wb29s
ICpwb29sLCBzdHJ1Y3QNCj4gPiA+IHBhZ2UNCj4gPiA+ICpwYWdlKQ0KPiA+ID4gIHsNCj4gPiA+
IC0JcmV0dXJuICFwYWdlX2lzX3BmbWVtYWxsb2MocGFnZSkgJiYgcGFnZV90b19uaWQocGFnZSkg
PT0NCj4gPiA+IHBvb2wtICANCj4gPiA+ID4gcC5uaWQ7ICANCj4gPiA+ICsJcmV0dXJuICFwYWdl
X2lzX3BmbWVtYWxsb2MocGFnZSkgJiYNCj4gPiA+ICsJCShwYWdlX3RvX25pZChwYWdlKSA9PSBw
b29sLT5wLm5pZCB8fA0KPiA+ID4gKwkJKHBvb2wtPnAubmlkID09IE5VTUFfTk9fTk9ERSAmJg0K
PiA+ID4gKwkJcGFnZV90b19uaWQocGFnZSkgPT0gbnVtYV9tZW1faWQoKSkpOw0KPiA+ID4gIH0N
Cj4gPiA+ICAgIA0KPiA+IA0KPiA+IENjJ2VkIEplc3BlciwgSWxpYXMgJiBKb25hdGhhbi4NCj4g
PiANCj4gPiBJIGRvbid0IHRoaW5rIGl0IGlzIGNvcnJlY3QgdG8gY2hlY2sgdGhhdCB0aGUgcGFn
ZSBuaWQgaXMgc2FtZSBhcw0KPiA+IG51bWFfbWVtX2lkKCkgaWYgcG9vbCBpcyBOVU1BX05PX05P
REUuIEluIHN1Y2ggY2FzZSB3ZSBzaG91bGQgYWxsb3cNCj4gPiBhbGwNCj4gPiBwYWdlcyB0byBy
ZWN5Y2xlLCBiZWNhdXNlIHlvdSBjYW4ndCBhc3N1bWUgd2hlcmUgcGFnZXMgYXJlDQo+ID4gYWxs
b2NhdGVkDQo+ID4gZnJvbSBhbmQgd2hlcmUgdGhleSBhcmUgYmVpbmcgaGFuZGxlZC4NCj4gPiAN
Cj4gPiBJIHN1Z2dlc3QgdGhlIGZvbGxvd2luZzoNCj4gPiANCj4gPiByZXR1cm4gIXBhZ2VfcGZt
ZW1hbGxvYygpICYmIA0KPiA+ICggcGFnZV90b19uaWQocGFnZSkgPT0gcG9vbC0+cC5uaWQgfHwg
cG9vbC0+cC5uaWQgPT0gTlVNQV9OT19OT0RFDQo+ID4gKTsNCj4gPiANCj4gPiAxKSBuZXZlciBy
ZWN5Y2xlIGVtZXJnZW5jeSBwYWdlcywgcmVnYXJkbGVzcyBvZiBwb29sIG5pZC4NCj4gPiAyKSBh
bHdheXMgcmVjeWNsZSBpZiBwb29sIGlzIE5VTUFfTk9fTk9ERS4NCj4gPiANCj4gPiB0aGUgYWJv
dmUgY2hhbmdlIHNob3VsZCBub3QgYWRkIGFueSBvdmVyaGVhZCwgYSBtb2Rlc3QgYnJhbmNoDQo+
ID4gcHJlZGljdG9yDQo+ID4gd2lsbCBoYW5kbGUgdGhpcyB3aXRoIG5vIGVmZm9ydC4NCj4gPiAN
Cj4gPiBKZXNwZXIgZXQgYWwuIHdoYXQgZG8geW91IHRoaW5rPw0KPiANCj4gVGhlIHBhdGNoIGRl
c2NyaXB0aW9uIGRvZXNuJ3QgZXhwbGFpbiB0aGUgcHJvYmxlbSB2ZXJ5IHdlbGwuDQo+IA0KPiBM
ZXRzIGZpcnN0IGVzdGFibGlzaCB3aGF0IHRoZSBwcm9ibGVtIGlzLiAgQWZ0ZXIgSSB0b29rIGF0
IGNsb3Nlcg0KPiBsb29rLA0KPiBJIGRvIHRoaW5rIHdlIGhhdmUgYSByZWFsIHByb2JsZW0gaGVy
ZS4uLg0KPiANCj4gSWYgZnVuY3Rpb24gYWxsb2NfcGFnZXNfbm9kZSgpIGlzIGNhbGxlZCB3aXRo
IE5VTUFfTk9fTk9ERSAoc2VlIGJlbG93DQo+IHNpZ25hdHVyZSksIHRoZW4gdGhlIG5pZCBpcyBy
ZS1hc3NpZ25lZCB0byBudW1hX21lbV9pZCgpLg0KPiANCj4gT3VyIGN1cnJlbnQgY29kZSBjaGVj
a3M6IHBhZ2VfdG9fbmlkKHBhZ2UpID09IHBvb2wtPnAubmlkIHdoaWNoIHNlZW1zDQo+IGJvZ3Vz
LCBhcyBwb29sLT5wLm5pZD1OVU1BX05PX05PREUgYW5kIHRoZSBwYWdlIE5JRCB3aWxsIG5vdCBy
ZXR1cm4NCj4gTlVNQV9OT19OT0RFLi4uIGFzIGl0IHdhcyBzZXQgdG8gdGhlIGxvY2FsIGRldGVj
dCBudW1hIG5vZGUsIHJpZ2h0Pw0KPiANCg0KcmlnaHQuDQoNCj4gU28sIHdlIGRvIG5lZWQgYSBm
aXguLi4gYnV0IHRoZSBxdWVzdGlvbiBpcyB0aGF0IHNlbWFudGljcyBkbyB3ZQ0KPiB3YW50Pw0K
PiANCg0KbWF5YmUgYXNzdW1lIHRoYXQgX19wYWdlX3Bvb2xfcmVjeWNsZV9kaXJlY3QoKSBpcyBh
bHdheXMgY2FsbGVkIGZyb20NCnRoZSByaWdodCBub2RlIGFuZCBjaGFuZ2UgdGhlIGN1cnJlbnQg
Ym9ndXMgY2hlY2s6DQoNCmZyb206DQpwYWdlX3RvX25pZChwYWdlKSA9PSBwb29sLT5wLm5pZCAN
Cg0KdG86DQpwYWdlX3RvX25pZChwYWdlKSA9PSBudW1hX21lbV9pZCgpDQoNClRoaXMgd2lsbCBh
bGxvdyByZWN5Y2xpbmcgb25seSBpZiBoYW5kbGluZyBub2RlIGlzIHRoZSBzYW1lIGFzIHdoZXJl
DQp0aGUgcGFnZSB3YXMgYWxsb2NhdGVkLCByZWdhcmRsZXNzIG9mIHBvb2wtPnAubmlkLg0KDQpz
byBzZW1hbnRpY3MgYXJlOg0KDQoxKSBhbGxvY2F0ZSBmcm9tOiBwb29sLT5wLm5pZCwgYXMgY2hv
c2VuIGJ5IHVzZXIuDQoyKSByZWN5Y2xlIHdoZW46IHBhZ2VfdG9fbmlkKHBhZ2UpID09IG51bWFf
bWVtX2lkKCkuDQozKSBwb29sIHVzZXIgbXVzdCBndWFyYW50ZWUgdGhhdCB0aGUgaGFuZGxlciB3
aWxsIHJ1biBvbiB0aGUgcmlnaHQNCm5vZGUuIHdoaWNoIHNob3VsZCBhbHdheXMgYmUgdGhlIGNh
c2UuIG90aGVyd2lzZSByZWN5Y2xpbmcgd2lsbCBiZQ0Kc2tpcHBlZCAobm8gY3Jvc3MgbnVtYSBy
ZWN5Y2xpbmcpLg0KDQoNCmEpIGlmIHRoZSBwb29sIG1pZ3JhdGVzLCB3ZSB3aWxsIHN0b3AgcmVj
eWNsaW5nIHVudGlsIHRoZSBwb29sIG1vdmVzDQpiYWNrIHRvIG9yaWdpbmFsIG5vZGUsIG9yIHVz
ZXIgY2FsbHMgcG9vbF91cGRhdGVfbmlkKCkgYXMgd2UgZG8gaW4NCm1seDUuDQpiKSBpZiBwb29s
IGlzIE5VTUFfTk9fTk9ERSwgdGhlbiBhbGxvY2F0aW9uIGFuZCBoYW5kbGluZyB3aWxsIGJlIGRv
bmUNCm9uIG51bWFfbWVtX2lkKCksIHdoaWNoIG1lYW5zIHRoZSBhYm92ZSBjaGVjayB3aWxsIHdv
cmsuDQoNClRoYW5rcywNClNhZWVkLg0KDQoNCg0KDQoNCg0KDQo=
