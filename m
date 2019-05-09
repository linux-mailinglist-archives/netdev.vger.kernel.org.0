Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FE619047
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 20:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfEISg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 14:36:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55276 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbfEISg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 14:36:27 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49IYhIK028455;
        Thu, 9 May 2019 11:36:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HLb8IshkajVd9kLEDe1UbWUuHvGTuLHGJXO/xfwdVqg=;
 b=FBVKUnBYnqYT6xEIaSjP+yGyPa79Q/18vDMJciUHniEW7ZFyv/BYVsUzA9a0P8so3pBr
 grrb/1P74SKyHzC9yk64fltav4bXa1z17wucubJZIYGR+RoEm5F936lFRK1CguKXpE+J
 ShrHIWIOK6nClnObzDRippRFwCiZx07Zceo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2scbsy2u7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 May 2019 11:36:23 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 9 May 2019 11:36:22 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 9 May 2019 11:36:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLb8IshkajVd9kLEDe1UbWUuHvGTuLHGJXO/xfwdVqg=;
 b=gdK3Ldzx9wHJJclBqFB51jw+Tl4ws22K0ncEl4UiRu+SJ1MiIysv3319aGsJZ/PveISJp5j224NJNEYB8wSmqNg5o+AmPPbWsyn8hZW4O/gh8cMy/qBbB+Oe1WDnKV3LKnRLvWBIn7tqoR5O0hL3SHK1vd4jTH9Wz8V4L0IfnXg=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2824.namprd15.prod.outlook.com (20.179.158.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Thu, 9 May 2019 18:36:20 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::140e:9c62:f2d3:7f27]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::140e:9c62:f2d3:7f27%7]) with mapi id 15.20.1878.022; Thu, 9 May 2019
 18:36:20 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
CC:     Netdev <netdev@vger.kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Thread-Topic: [PATCH bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Thread-Index: AQHVBfB1goz9JBW3cE6P1q8NPh2E2qZirkiAgABJ+QCAACgLgA==
Date:   Thu, 9 May 2019 18:36:20 +0000
Message-ID: <9a1a0d6a-d7d4-406a-6bad-26f222df073f@fb.com>
References: <20190508225016.2375828-1-jonathan.lemon@gmail.com>
 <CAJ+HfNj4NgGQkJOEivuxuohA_+Fa98yD8EmY4acHQqymdUBA4g@mail.gmail.com>
 <7974B49C-CC4F-475D-992A-3E5B6480B039@gmail.com>
In-Reply-To: <7974B49C-CC4F-475D-992A-3E5B6480B039@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:300:ee::15) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::bc44]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9732f1a-21ca-469d-0f40-08d6d4ad3ab5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2824;
x-ms-traffictypediagnostic: BYAPR15MB2824:
x-microsoft-antispam-prvs: <BYAPR15MB2824F4357F09C2FB445320DAD7330@BYAPR15MB2824.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(136003)(346002)(376002)(189003)(199004)(4326008)(6506007)(53546011)(102836004)(386003)(52116002)(31696002)(86362001)(25786009)(99286004)(66574012)(486006)(76176011)(46003)(6246003)(36756003)(186003)(64756008)(66446008)(66476007)(66556008)(66946007)(73956011)(2906002)(71200400001)(71190400001)(316002)(8676002)(7736002)(305945005)(14454004)(229853002)(8936002)(81156014)(81166006)(14444005)(256004)(31686004)(54906003)(110136005)(11346002)(2616005)(476003)(446003)(53936002)(6116002)(68736007)(6512007)(5660300002)(478600001)(6436002)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2824;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NX+Pf1HM1u7gwDxuy3bBBPyxeET02d1Eu8mVxgzKMJaQwEtw1ESIrxAH63K973LqO95JmV+cOKmvH2EWM1wf1fPjCDihaOUj6Nz4/aZc2PAY9j3+vpZkodW5R6bJjr8kjqhWuonyu1hjr5crF7zadONGeGUNeqr3WMhNunRPatZK6h0TMOISEaNftxRP+/QQiJeS6F+grcH3XPQOs7+VxQv7VKsV1u3tbr3ZfPiVVDq6KEtCCYgc62CwK9rAJwRQ1hYDzjBGFtsFRh+63NPuyAiqLl8uo4Lu64ajxHexwzMUilDor/tW5RDGNGY63/cXrYp+LYnhuPVE65wz0xVvXNRFilsY9mF0B8bQrslm+3QDz8i9mMMcGJmVql1sFvFPqKLetb7HeYdN5huN41J1rZWMghk6BE1D3W7FZxNEbdM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5444BF5B72E36E4C95234D63EB5C3E18@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c9732f1a-21ca-469d-0f40-08d6d4ad3ab5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 18:36:20.3886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2824
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090107
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS85LzE5IDk6MTIgQU0sIEpvbmF0aGFuIExlbW9uIHdyb3RlOg0KPiBPbiA5IE1heSAyMDE5
LCBhdCA0OjQ4LCBCasO2cm4gVMO2cGVsIHdyb3RlOg0KPiANCj4+IE9uIFRodSwgOSBNYXkgMjAx
OSBhdCAwMTowNywgSm9uYXRoYW4gTGVtb24gPGpvbmF0aGFuLmxlbW9uQGdtYWlsLmNvbT4gDQo+
PiB3cm90ZToNCj4+Pg0KPj4+IEN1cnJlbnRseSwgdGhlIEFGX1hEUCBjb2RlIHVzZXMgYSBzZXBh
cmF0ZSBtYXAgaW4gb3JkZXIgdG8NCj4+PiBkZXRlcm1pbmUgaWYgYW4geHNrIGlzIGJvdW5kIHRv
IGEgcXVldWUuwqAgSW5zdGVhZCBvZiBkb2luZyB0aGlzLA0KPj4+IGhhdmUgYnBmX21hcF9sb29r
dXBfZWxlbSgpIHJldHVybiBhIGJvb2xlYW4gaW5kaWNhdGluZyB3aGV0aGVyDQo+Pj4gdGhlcmUg
aXMgYSB2YWxpZCBlbnRyeSBhdCB0aGUgbWFwIGluZGV4Lg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1i
eTogSm9uYXRoYW4gTGVtb24gPGpvbmF0aGFuLmxlbW9uQGdtYWlsLmNvbT4NCj4+PiAtLS0NCj4+
PiDCoGtlcm5lbC9icGYvdmVyaWZpZXIuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA2ICsrKysrLQ0KPj4+IMKga2VybmVsL2JwZi94
c2ttYXAuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB8wqAgMiArLQ0KPj4+IMKgLi4uL3NlbGZ0ZXN0cy9icGYvdmVyaWZpZXIvcHJl
dmVudF9tYXBfbG9va3VwLmPCoMKgIHwgMTUgLS0tLS0tLS0tLS0tLS0tDQo+Pj4gwqAzIGZpbGVz
IGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBkaWZm
IC0tZ2l0IGEva2VybmVsL2JwZi92ZXJpZmllci5jIGIva2VybmVsL2JwZi92ZXJpZmllci5jDQo+
Pj4gaW5kZXggN2IwNWU4OTM4ZDVjLi5hOGI4ZmY5ZWNkOTAgMTAwNjQ0DQo+Pj4gLS0tIGEva2Vy
bmVsL2JwZi92ZXJpZmllci5jDQo+Pj4gKysrIGIva2VybmVsL2JwZi92ZXJpZmllci5jDQo+Pj4g
QEAgLTI3NjEsMTAgKzI3NjEsMTQgQEAgc3RhdGljIGludCANCj4+PiBjaGVja19tYXBfZnVuY19j
b21wYXRpYmlsaXR5KHN0cnVjdCBicGZfdmVyaWZpZXJfZW52ICplbnYsDQo+Pj4gwqDCoMKgwqDC
oMKgwqDCoCAqIGFwcGVhci4NCj4+PiDCoMKgwqDCoMKgwqDCoMKgICovDQo+Pj4gwqDCoMKgwqDC
oMKgwqAgY2FzZSBCUEZfTUFQX1RZUEVfQ1BVTUFQOg0KPj4+IC3CoMKgwqDCoMKgwqAgY2FzZSBC
UEZfTUFQX1RZUEVfWFNLTUFQOg0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBp
ZiAoZnVuY19pZCAhPSBCUEZfRlVOQ19yZWRpcmVjdF9tYXApDQo+Pj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIGVycm9yOw0KPj4+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsNCj4+PiArwqDCoMKgwqDCoMKgIGNhc2UgQlBG
X01BUF9UWVBFX1hTS01BUDoNCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAo
ZnVuY19pZCAhPSBCUEZfRlVOQ19yZWRpcmVjdF9tYXAgJiYNCj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZ1bmNfaWQgIT0gQlBGX0ZVTkNfbWFwX2xvb2t1cF9lbGVt
KQ0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3Rv
IGVycm9yOw0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+IMKg
wqDCoMKgwqDCoMKgIGNhc2UgQlBGX01BUF9UWVBFX0FSUkFZX09GX01BUFM6DQo+Pj4gwqDCoMKg
wqDCoMKgwqAgY2FzZSBCUEZfTUFQX1RZUEVfSEFTSF9PRl9NQVBTOg0KPj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoZnVuY19pZCAhPSBCUEZfRlVOQ19tYXBfbG9va3VwX2Vs
ZW0pDQo+Pj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYveHNrbWFwLmMgYi9rZXJuZWwvYnBmL3hz
a21hcC5jDQo+Pj4gaW5kZXggNjg2ZDI0NGU3OThkLi5mNmU0OTIzNzk3OWMgMTAwNjQ0DQo+Pj4g
LS0tIGEva2VybmVsL2JwZi94c2ttYXAuYw0KPj4+ICsrKyBiL2tlcm5lbC9icGYveHNrbWFwLmMN
Cj4+PiBAQCAtMTU0LDcgKzE1NCw3IEBAIHZvaWQgX194c2tfbWFwX2ZsdXNoKHN0cnVjdCBicGZf
bWFwICptYXApDQo+Pj4NCj4+PiDCoHN0YXRpYyB2b2lkICp4c2tfbWFwX2xvb2t1cF9lbGVtKHN0
cnVjdCBicGZfbWFwICptYXAsIHZvaWQgKmtleSkNCj4+PiDCoHsNCj4+PiAtwqDCoMKgwqDCoMKg
IHJldHVybiBFUlJfUFRSKC1FT1BOT1RTVVBQKTsNCj4+PiArwqDCoMKgwqDCoMKgIHJldHVybiAh
IV9feHNrX21hcF9sb29rdXBfZWxlbShtYXAsICoodTMyICopa2V5KTsNCj4+PiDCoH0NCj4+Pg0K
Pj4NCj4+IEhtbSwgZW5hYmxpbmcgbG9va3VwcyBoYXMgc29tZSBjb25jZXJucywgc28gd2UgdG9v
ayB0aGUgZWFzeSBwYXRoOw0KPj4gc2ltcGx5IGRpc2FsbG93aW5nIGl0LiBMb29rdXBzIChhbmQg
cmV0dXJuaW5nIGEgc29ja2V0L2ZkKSBmcm9tDQo+PiB1c2Vyc3BhY2UgbWlnaHQgYmUgZXhwZW5z
aXZlOyBhbGxvY2F0aW5nIGEgbmV3IGZkLCBhbmQgc3VjaCwgYW5kIG9uDQo+PiB0aGUgQlBGIHNp
ZGUgdGhlcmUncyBubyBYRFAgc29ja2V0IG9iamVjdCAoeWV0ISkuDQo+Pg0KPj4gWW91ciBwYXRj
aCBtYWtlcyB0aGUgbG9va3VwIHJldHVybiBzb21ldGhpbmcgZWxzZSB0aGFuIGEgZmQgb3Igc29j
a2V0Lg0KPj4gVGhlIGJyb2FkZXIgcXVlc3Rpb24gaXMsIGluc2VydGluZyBhIHNvY2tldCBmZCBh
bmQgZ2V0dGluZyBiYWNrIGEgYm9vbA0KPj4gLS0gaXMgdGhhdCBvayBmcm9tIGEgc2VtYW50aWMg
cGVyc3BlY3RpdmU/IEl0J3MgYSBraW5kIG9mIHdlaXJkIG1hcC4NCj4+IEFyZSB0aGVyZSBhbnkg
b3RoZXIgbWFwcyB0aGF0IGJlaGF2ZSBpbiB0aGlzIHdheT8gSXQgY2VydGFpbmx5IG1ha2VzDQo+
PiB0aGUgWERQIGNvZGUgZWFzaWVyLCBhbmQgeW91IGdldCBzb21ld2hhdCBiZXR0ZXIgaW50cm9z
cGVjdGlvbiBpbnRvDQo+PiB0aGUgWFNLTUFQLg0KPiANCj4gSSBzaW1wbHkgd2FudCB0byBxdWVy
eSB0aGUgbWFwIGFuZCBhc2sgImlzIHRoZXJlIGFuIGVudHJ5IHByZXNlbnQ/IiwNCj4gYnV0IHRo
ZXJlIGlzbid0IGEgc2VwYXJhdGUgQVBJIGZvciB0aGF0LsKgIEl0IHNlZW1zIHJlYWxseSBvZGQg
dGhhdCBJJ20NCj4gcmVxdWlyZWQgdG8gZHVwbGljYXRlIHRoZSBzYW1lIGxvZ2ljIGJ5IHVzaW5n
IGEgc2Vjb25kIG1hcC7CoCBJIGFncmVlIHRoYXQNCj4gdGhlcmUgaXNuJ3QgYW55IHBvaW50IGlu
IHJldHVybmluZyBhbiBmZCBvciB4ZHAgc29ja2V0IG9iamVjdCAtIGhlbmNlDQo+IHRoZSBib29s
ZWFuLg0KPiANCj4gVGhlIGNvbW1lbnQgaW50aGUgdmVyaWZpZXIgZG9lcyByZWFkOg0KPiANCj4g
IMKgwqDCoMKgwqDCoMKgIC8qIFJlc3RyaWN0IGJwZiBzaWRlIG9mIGNwdW1hcCBhbmQgeHNrbWFw
LCBvcGVuIHdoZW4gdXNlLWNhc2VzDQo+ICDCoMKgwqDCoMKgwqDCoMKgICogYXBwZWFyLg0KPiAN
Cj4gc28gSSdkIHNheSB0aGlzIGlzIGEgdXNlLWNhc2UuwqAgOikNCj4gDQo+IFRoZSBjcHVtYXAg
Y3B1X21hcF9sb29rdXBfZWxlbSgpIGZ1bmN0aW9uIHJldHVybnMgdGhlIHFzaXplIGZvciBzb21l
DQo+IHJlYXNvbiwgYnV0IGl0IGRvZXNuJ3Qgc2VlbSByZWFjaGFibGUgZnJvbSB0aGUgdmVyaWZp
ZXIuDQoNCkkgdGhpbmsgaXQncyBnb29kIHRvIGV4cG9zZSBzb21lIGluZm8gYWJvdXQgeHNrIHRv
IGJwZiBwcm9nLg0KUmV0dXJuaW5nIGJvb2wgaXMga2luZGEgc2luZ2xlIHB1cnBvc2UuDQpDYW4g
eHNrX21hcF9sb29rdXBfZWxlbSgpIHJldHVybiB4c2suc2suc2tfY29va2llIGluc3RlYWQ/DQpJ
IHRoaW5rIHdlIGNhbiBmb3JjZSBub24gemVybyBjb29raWUgZm9yIGFsbCB4c2sgc29ja2V0cw0K
dGhlbiByZXR1cm5pbmcgemVybyB3b3VsZCBtZWFuIHRoYXQgc29ja2V0IGlzIG5vdCB0aGVyZQ0K
YW5kIGNhbiBzb2x2ZSB0aGlzIHVzZSBjYXNlIGFzIHdlbGwuDQpPciBzb21lIG90aGVyIHByb3Bl
cnR5IG9mIHhzayA/DQoNClByb2JhYmx5IGJldHRlciBpZGVhIHdvdWxkIGJlIHRvIHJldHVybiAn
c3RydWN0IGJwZl9zb2NrIConIG9yDQpuZXcgJ3N0cnVjdCBicGZfeGRwX3NvY2sgKicgYW5kIHRl
YWNoIHRoZSB2ZXJpZmllciB0byBleHRyYWN0DQp4c2sucXVldWVfaWQgb3Igb3RoZXIgaW50ZXJl
c3RpbmcgaW5mbyBmcm9tIGl0Lg0KSSB0aGluayBpdCdzIHNhZmUgdG8gZG8sIHNpbmNlIHByb2dz
IHJ1biB1bmRlciByY3UuDQo=
