Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F51B3E67
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 18:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389579AbfIPQHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 12:07:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730197AbfIPQHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 12:07:41 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8GG23vV023925;
        Mon, 16 Sep 2019 09:07:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CP3lEgh8qaXH4smps1N0AS6Wbn5pJboHCsdY2d6tth8=;
 b=SktwX640y5tTUHL6gsMtEVPZJU8PSEnSFh4nFXvV54Oso3y4ANz4kGfSPLZjHgxvsRHJ
 9vAQRgMvbEdn0sMwjuPxoBEe0xeMcBJIFEy2nRukC15wxUfyqk72R6l6ZdO4rEDxxwZI
 z8mFn5DbzVII0qbw/JslzlFNrhTDgcM2aLY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2v21jpak8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 09:07:15 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Sep 2019 09:07:12 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Sep 2019 09:07:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Itc97yn4IskByELK0J1lv11jz2trKlN9gk2JGHl5mKFhpjjx+aILyFAaY0uqsUSFpcf5UQahY0AxXteItXxqSQfxL5v0nT3skpPvBToZ+ILHkLk8+BLLYvtgePH413tEm1srRG0tJOBj9kPyny12CyMwHRdR6lzT5Ojz2jFO2hny/zpnBzkv42FYCwXg14T3ThQyFAlx++vQFid18j2gRPscunF+WG2L8LpycHADCVZqGpPomkQ34UM2yDjW3AybH3y70m+vUGy9Do22pryaRZpoWpBPLXxi8Q597SVs7QkG72F3KHnSDOytbkMsn1f6+hAzBirIbV0ZnrCSVAd3jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CP3lEgh8qaXH4smps1N0AS6Wbn5pJboHCsdY2d6tth8=;
 b=PF4LqFyT/sCx0FhMxNYqpR3BlAyGRp8M49zwpAndHqnuJQ0eyqQ7uMgUcpAF0mmF9nWdsdIOVc7rYp/uSmy8mAVAB3TJEVn6iv1lzhdo/VQhbZQqJVOm/bq5TcC1Id+ouIxRZjfKD7cxq3Tt1bOfAetWurBLD9s+ezNfndcOMwKRBOnbc5gCDWqmahNFofn6gG0HmbG3Ij2IwdGO/kw7eHkrfwC/y8/MlEV0nA/lGZpKK1XpAy9Edq8nGldmG5N/mEzFA7wRDNV152zG0hAaM7rFWODWdUGDbGYKF2m8xnu1jU+Gqb7gvl6SMjwwxNKjDJdzSVImvmPWrOU4Xe4cdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CP3lEgh8qaXH4smps1N0AS6Wbn5pJboHCsdY2d6tth8=;
 b=kQvAw1OqOMLCNij9KzN81Y1Fiusm3DTBY0M7mpRDj1/tQaIdXPYNSJEvTllMw+eHKFO+RMxyX8GKI/79LK7uii9vDjovKML4YNb+0W8KX3GBW0/5tNbSX+G/zrHSyxLN60hQ+Sr56AKNNcR8FtPCPK9ZydBDFYXH7Dy3VKzi8RU=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2422.namprd15.prod.outlook.com (52.135.195.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Mon, 16 Sep 2019 16:07:10 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.023; Mon, 16 Sep 2019
 16:07:10 +0000
From:   Yonghong Song <yhs@fb.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [bpf-next,v4] samples: bpf: add max_pckt_size option at
 xdp_adjust_tail
Thread-Topic: [bpf-next,v4] samples: bpf: add max_pckt_size option at
 xdp_adjust_tail
Thread-Index: AQHVa8PGy9laecXPyUm1z6ewuYYpTKcueguA
Date:   Mon, 16 Sep 2019 16:07:10 +0000
Message-ID: <d6b935ae-64a7-a375-9825-72eaebafd8a4@fb.com>
References: <20190915124733.31134-1-danieltimlee@gmail.com>
In-Reply-To: <20190915124733.31134-1-danieltimlee@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:104:1::11) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3c5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e1afef1-06d0-4ab9-badc-08d73abfee0c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2422;
x-ms-traffictypediagnostic: BYAPR15MB2422:
x-microsoft-antispam-prvs: <BYAPR15MB242256869C70CC8C5E8017B3D38C0@BYAPR15MB2422.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:168;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(396003)(346002)(376002)(366004)(199004)(189003)(14454004)(8936002)(31696002)(86362001)(6486002)(305945005)(7736002)(71200400001)(31686004)(71190400001)(81156014)(478600001)(81166006)(25786009)(64756008)(2906002)(66556008)(36756003)(256004)(14444005)(6116002)(186003)(6436002)(229853002)(66446008)(76176011)(66476007)(66946007)(4326008)(386003)(11346002)(102836004)(316002)(110136005)(6506007)(53546011)(2616005)(52116002)(476003)(6246003)(446003)(6512007)(5660300002)(54906003)(99286004)(8676002)(486006)(53936002)(46003)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2422;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2+18kvz3dxHcpcEGv6cGgno9ql1Vptx9VEdzrt1ClgjjomvIFsG1XWu+0n+7x23789pNLfvb190GJhkA2gp6Z5sXDHyWJpVTjkGaIavotB9phXDP9IXVIXLDhJD85vyO4CRukpnm2nNGeFyFq26n4IHUbSODr7OL/wOqexqYvlVHCbcamNrO3fCzR4IVWnvZnBx93ASlvRcnBd1QaAq0hfM/9l4zYur/TX8FoqsrICMbYg/7P2Q3S2KgSYD0xPYP7V0gn/cCU1RW3QOAAX7//vOvi53CgEQr3u0vVBcqaJg8UgFW1xeTg2eYPVz4q3HKJMef1mo1z/qAf3G7VkSat7WkivOCCxNKGlE9Og6bKr9VRM+QxSFbsnxjU2qk67Q7oy5oJ4aIkNfIc835AGv6cZpSKr9EQnaMGNWjKfl+AIc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA83CF3EE1E321418620C467F8A51322@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1afef1-06d0-4ab9-badc-08d73abfee0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 16:07:10.6428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDaPG/u5zjTYvV9908ghA1tES0cwEsEI9htUQQ0+3khTJs3Bv84Xfdikv/I2Rc9Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2422
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_07:2019-09-11,2019-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909160165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTUvMTkgMTo0NyBQTSwgRGFuaWVsIFQuIExlZSB3cm90ZToNCj4gQ3VycmVudGx5
LCBhdCB4ZHBfYWRqdXN0X3RhaWxfa2Vybi5jLCBNQVhfUENLVF9TSVpFIGlzIGxpbWl0ZWQNCj4g
dG8gNjAwLiBUbyBtYWtlIHRoaXMgc2l6ZSBmbGV4aWJsZSwgYSBuZXcgbWFwICdwY2t0c3onIGlz
IGFkZGVkLg0KPiANCj4gQnkgdXBkYXRpbmcgbmV3IHBhY2tldCBzaXplIHRvIHRoaXMgbWFwIGZy
b20gdGhlIHVzZXJsYW5kLA0KPiB4ZHBfYWRqdXN0X3RhaWxfa2Vybi5vIHdpbGwgdXNlIHRoaXMg
dmFsdWUgYXMgYSBuZXcgbWF4X3Bja3Rfc2l6ZS4NCj4gDQo+IElmIG5vICctUCA8TUFYX1BDS1Rf
U0laRT4nIG9wdGlvbiBpcyB1c2VkLCB0aGUgc2l6ZSBvZiBtYXhpbXVtIHBhY2tldA0KPiB3aWxs
IGJlIDYwMCBhcyBhIGRlZmF1bHQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgVC4gTGVl
IDxkYW5pZWx0aW1sZWVAZ21haWwuY29tPg0KPiANCj4gLS0tDQo+IENoYW5nZXMgaW4gdjQ6DQo+
ICAgICAgLSBtYWtlIHBja3Rfc2l6ZSBubyBsZXNzIHRoYW4gSUNNUF9UT09CSUdfU0laRQ0KPiAg
ICAgIC0gRml4IGNvZGUgc3R5bGUNCj4gQ2hhbmdlcyBpbiB2MjoNCj4gICAgICAtIENoYW5nZSB0
aGUgaGVscGVyIHRvIGZldGNoIG1hcCBmcm9tICdicGZfbWFwX19uZXh0JyB0bw0KPiAgICAgICdi
cGZfb2JqZWN0X19maW5kX21hcF9mZF9ieV9uYW1lJy4NCj4gDQo+ICAgc2FtcGxlcy9icGYveGRw
X2FkanVzdF90YWlsX2tlcm4uYyB8IDIzICsrKysrKysrKysrKysrKysrKystLS0tDQo+ICAgc2Ft
cGxlcy9icGYveGRwX2FkanVzdF90YWlsX3VzZXIuYyB8IDI4ICsrKysrKysrKysrKysrKysrKysr
KystLS0tLS0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDQxIGluc2VydGlvbnMoKyksIDEwIGRlbGV0
aW9ucygtKQ0KDQpMR1RNIGV4Y2VwdCBhIG1pbm9yIGNvbW1lbnRzIGJlbG93Lg0KQWNrZWQtYnk6
IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQoNCmJwZi1uZXh0IGlzIGNsb3NlZC4gUGxlYXNl
IHJlc3VibWl0IHRoZSBwYXRjaCBvbmNlIGl0IGlzIG9wZW5lZA0KaW4gYXJvdW5kIDIgd2Vla3Mu
DQoNCj4gDQo+IGRpZmYgLS1naXQgYS9zYW1wbGVzL2JwZi94ZHBfYWRqdXN0X3RhaWxfa2Vybi5j
IGIvc2FtcGxlcy9icGYveGRwX2FkanVzdF90YWlsX2tlcm4uYw0KPiBpbmRleCA0MTFmZGIyMWY4
YmMuLjg4NjliYmIxNjBkMiAxMDA2NDQNCj4gLS0tIGEvc2FtcGxlcy9icGYveGRwX2FkanVzdF90
YWlsX2tlcm4uYw0KPiArKysgYi9zYW1wbGVzL2JwZi94ZHBfYWRqdXN0X3RhaWxfa2Vybi5jDQo+
IEBAIC0yNSw2ICsyNSwxMyBAQA0KPiAgICNkZWZpbmUgSUNNUF9UT09CSUdfU0laRSA5OA0KPiAg
ICNkZWZpbmUgSUNNUF9UT09CSUdfUEFZTE9BRF9TSVpFIDkyDQo+ICAgDQo+ICtzdHJ1Y3QgYnBm
X21hcF9kZWYgU0VDKCJtYXBzIikgcGNrdHN6ID0gew0KPiArCS50eXBlID0gQlBGX01BUF9UWVBF
X0FSUkFZLA0KPiArCS5rZXlfc2l6ZSA9IHNpemVvZihfX3UzMiksDQo+ICsJLnZhbHVlX3NpemUg
PSBzaXplb2YoX191MzIpLA0KPiArCS5tYXhfZW50cmllcyA9IDEsDQo+ICt9Ow0KPiArDQo+ICAg
c3RydWN0IGJwZl9tYXBfZGVmIFNFQygibWFwcyIpIGljbXBjbnQgPSB7DQo+ICAgCS50eXBlID0g
QlBGX01BUF9UWVBFX0FSUkFZLA0KPiAgIAkua2V5X3NpemUgPSBzaXplb2YoX191MzIpLA0KPiBA
QCAtNjQsNyArNzEsOCBAQCBzdGF0aWMgX19hbHdheXNfaW5saW5lIHZvaWQgaXB2NF9jc3VtKHZv
aWQgKmRhdGFfc3RhcnQsIGludCBkYXRhX3NpemUsDQo+ICAgCSpjc3VtID0gY3N1bV9mb2xkX2hl
bHBlcigqY3N1bSk7DQo+ICAgfQ0KPiAgIA0KPiAtc3RhdGljIF9fYWx3YXlzX2lubGluZSBpbnQg
c2VuZF9pY21wNF90b29fYmlnKHN0cnVjdCB4ZHBfbWQgKnhkcCkNCj4gK3N0YXRpYyBfX2Fsd2F5
c19pbmxpbmUgaW50IHNlbmRfaWNtcDRfdG9vX2JpZyhzdHJ1Y3QgeGRwX21kICp4ZHAsDQo+ICsJ
CQkJCSAgICAgIF9fdTMyIG1heF9wY2t0X3NpemUpDQo+ICAgew0KPiAgIAlpbnQgaGVhZHJvb20g
PSAoaW50KXNpemVvZihzdHJ1Y3QgaXBoZHIpICsgKGludClzaXplb2Yoc3RydWN0IGljbXBoZHIp
Ow0KPiAgIA0KPiBAQCAtOTIsNyArMTAwLDcgQEAgc3RhdGljIF9fYWx3YXlzX2lubGluZSBpbnQg
c2VuZF9pY21wNF90b29fYmlnKHN0cnVjdCB4ZHBfbWQgKnhkcCkNCj4gICAJb3JpZ19pcGggPSBk
YXRhICsgb2ZmOw0KPiAgIAlpY21wX2hkci0+dHlwZSA9IElDTVBfREVTVF9VTlJFQUNIOw0KPiAg
IAlpY21wX2hkci0+Y29kZSA9IElDTVBfRlJBR19ORUVERUQ7DQo+IC0JaWNtcF9oZHItPnVuLmZy
YWcubXR1ID0gaHRvbnMoTUFYX1BDS1RfU0laRS1zaXplb2Yoc3RydWN0IGV0aGhkcikpOw0KPiAr
CWljbXBfaGRyLT51bi5mcmFnLm10dSA9IGh0b25zKG1heF9wY2t0X3NpemUgLSBzaXplb2Yoc3Ry
dWN0IGV0aGhkcikpOw0KPiAgIAlpY21wX2hkci0+Y2hlY2tzdW0gPSAwOw0KPiAgIAlpcHY0X2Nz
dW0oaWNtcF9oZHIsIElDTVBfVE9PQklHX1BBWUxPQURfU0laRSwgJmNzdW0pOw0KPiAgIAlpY21w
X2hkci0+Y2hlY2tzdW0gPSBjc3VtOw0KPiBAQCAtMTE4LDE0ICsxMjYsMjEgQEAgc3RhdGljIF9f
YWx3YXlzX2lubGluZSBpbnQgaGFuZGxlX2lwdjQoc3RydWN0IHhkcF9tZCAqeGRwKQ0KPiAgIHsN
Cj4gICAJdm9pZCAqZGF0YV9lbmQgPSAodm9pZCAqKShsb25nKXhkcC0+ZGF0YV9lbmQ7DQo+ICAg
CXZvaWQgKmRhdGEgPSAodm9pZCAqKShsb25nKXhkcC0+ZGF0YTsNCj4gKwlfX3UzMiBtYXhfcGNr
dF9zaXplID0gTUFYX1BDS1RfU0laRTsNCj4gICAJaW50IHBja3Rfc2l6ZSA9IGRhdGFfZW5kIC0g
ZGF0YTsNCj4gKwlfX3UzMiAqcGNrdF9zejsNCj4gKwlfX3UzMiBrZXkgPSAwOw0KPiAgIAlpbnQg
b2Zmc2V0Ow0KPiAgIA0KPiAtCWlmIChwY2t0X3NpemUgPiBNQVhfUENLVF9TSVpFKSB7DQo+ICsJ
cGNrdF9zeiA9IGJwZl9tYXBfbG9va3VwX2VsZW0oJnBja3RzeiwgJmtleSk7DQo+ICsJaWYgKHBj
a3Rfc3ogJiYgKnBja3Rfc3opDQo+ICsJCW1heF9wY2t0X3NpemUgPSAqcGNrdF9zejsNCj4gKw0K
PiArCWlmIChwY2t0X3NpemUgPiBtYXgobWF4X3Bja3Rfc2l6ZSwgSUNNUF9UT09CSUdfU0laRSkp
IHsNCj4gICAJCW9mZnNldCA9IHBja3Rfc2l6ZSAtIElDTVBfVE9PQklHX1NJWkU7DQo+ICAgCQlp
ZiAoYnBmX3hkcF9hZGp1c3RfdGFpbCh4ZHAsIDAgLSBvZmZzZXQpKQ0KPiAgIAkJCXJldHVybiBY
RFBfUEFTUzsNCj4gLQkJcmV0dXJuIHNlbmRfaWNtcDRfdG9vX2JpZyh4ZHApOw0KPiArCQlyZXR1
cm4gc2VuZF9pY21wNF90b29fYmlnKHhkcCwgbWF4X3Bja3Rfc2l6ZSk7DQo+ICAgCX0NCj4gICAJ
cmV0dXJuIFhEUF9QQVNTOw0KPiAgIH0NCj4gZGlmZiAtLWdpdCBhL3NhbXBsZXMvYnBmL3hkcF9h
ZGp1c3RfdGFpbF91c2VyLmMgYi9zYW1wbGVzL2JwZi94ZHBfYWRqdXN0X3RhaWxfdXNlci5jDQo+
IGluZGV4IGEzNTk2YjYxN2M0Yy4uOTllOTY1YzY4MDU0IDEwMDY0NA0KPiAtLS0gYS9zYW1wbGVz
L2JwZi94ZHBfYWRqdXN0X3RhaWxfdXNlci5jDQo+ICsrKyBiL3NhbXBsZXMvYnBmL3hkcF9hZGp1
c3RfdGFpbF91c2VyLmMNCj4gQEAgLTIzLDYgKzIzLDcgQEANCj4gICAjaW5jbHVkZSAibGliYnBm
LmgiDQo+ICAgDQo+ICAgI2RlZmluZSBTVEFUU19JTlRFUlZBTF9TIDJVDQo+ICsjZGVmaW5lIE1B
WF9QQ0tUX1NJWkUgNjAwDQo+ICAgDQo+ICAgc3RhdGljIGludCBpZmluZGV4ID0gLTE7DQo+ICAg
c3RhdGljIF9fdTMyIHhkcF9mbGFncyA9IFhEUF9GTEFHU19VUERBVEVfSUZfTk9FWElTVDsNCj4g
QEAgLTcyLDYgKzczLDcgQEAgc3RhdGljIHZvaWQgdXNhZ2UoY29uc3QgY2hhciAqY21kKQ0KPiAg
IAlwcmludGYoIlVzYWdlOiAlcyBbLi4uXVxuIiwgY21kKTsNCj4gICAJcHJpbnRmKCIgICAgLWkg
PGlmbmFtZXxpZmluZGV4PiBJbnRlcmZhY2VcbiIpOw0KPiAgIAlwcmludGYoIiAgICAtVCA8c3Rv
cC1hZnRlci1YLXNlY29uZHM+IERlZmF1bHQ6IDAgKGZvcmV2ZXIpXG4iKTsNCj4gKwlwcmludGYo
IiAgICAtUCA8TUFYX1BDS1RfU0laRT4gRGVmYXVsdDogJXVcbiIsIE1BWF9QQ0tUX1NJWkUpOw0K
PiAgIAlwcmludGYoIiAgICAtUyB1c2Ugc2tiLW1vZGVcbiIpOw0KPiAgIAlwcmludGYoIiAgICAt
TiBlbmZvcmNlIG5hdGl2ZSBtb2RlXG4iKTsNCj4gICAJcHJpbnRmKCIgICAgLUYgZm9yY2UgbG9h
ZGluZyBwcm9nXG4iKTsNCj4gQEAgLTg1LDEzICs4NywxNCBAQCBpbnQgbWFpbihpbnQgYXJnYywg
Y2hhciAqKmFyZ3YpDQo+ICAgCQkucHJvZ190eXBlCT0gQlBGX1BST0dfVFlQRV9YRFAsDQo+ICAg
CX07DQo+ICAgCXVuc2lnbmVkIGNoYXIgb3B0X2ZsYWdzWzI1Nl0gPSB7fTsNCj4gLQljb25zdCBj
aGFyICpvcHRzdHIgPSAiaTpUOlNORmgiOw0KPiArCWNvbnN0IGNoYXIgKm9wdHN0ciA9ICJpOlQ6
UDpTTkZoIjsNCj4gICAJc3RydWN0IGJwZl9wcm9nX2luZm8gaW5mbyA9IHt9Ow0KPiAgIAlfX3Uz
MiBpbmZvX2xlbiA9IHNpemVvZihpbmZvKTsNCj4gKwlfX3UzMiBtYXhfcGNrdF9zaXplID0gMDsN
Cj4gKwlfX3UzMiBrZXkgPSAwOw0KPiAgIAl1bnNpZ25lZCBpbnQga2lsbF9hZnRlcl9zID0gMDsN
Cj4gICAJaW50IGksIHByb2dfZmQsIG1hcF9mZCwgb3B0Ow0KPiAgIAlzdHJ1Y3QgYnBmX29iamVj
dCAqb2JqOw0KPiAtCXN0cnVjdCBicGZfbWFwICptYXA7DQo+ICAgCWNoYXIgZmlsZW5hbWVbMjU2
XTsNCj4gICAJaW50IGVycjsNCj4gICANCj4gQEAgLTExMCw2ICsxMTMsOSBAQCBpbnQgbWFpbihp
bnQgYXJnYywgY2hhciAqKmFyZ3YpDQo+ICAgCQljYXNlICdUJzoNCj4gICAJCQlraWxsX2FmdGVy
X3MgPSBhdG9pKG9wdGFyZyk7DQo+ICAgCQkJYnJlYWs7DQo+ICsJCWNhc2UgJ1AnOg0KPiArCQkJ
bWF4X3Bja3Rfc2l6ZSA9IGF0b2kob3B0YXJnKTsNCj4gKwkJCWJyZWFrOw0KPiAgIAkJY2FzZSAn
Uyc6DQo+ICAgCQkJeGRwX2ZsYWdzIHw9IFhEUF9GTEFHU19TS0JfTU9ERTsNCj4gICAJCQlicmVh
azsNCj4gQEAgLTE1MCwxMiArMTU2LDIyIEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJn
dikNCj4gICAJaWYgKGJwZl9wcm9nX2xvYWRfeGF0dHIoJnByb2dfbG9hZF9hdHRyLCAmb2JqLCAm
cHJvZ19mZCkpDQo+ICAgCQlyZXR1cm4gMTsNCj4gICANCj4gLQltYXAgPSBicGZfbWFwX19uZXh0
KE5VTEwsIG9iaik7DQo+IC0JaWYgKCFtYXApIHsNCj4gLQkJcHJpbnRmKCJmaW5kaW5nIGEgbWFw
IGluIG9iaiBmaWxlIGZhaWxlZFxuIik7DQo+ICsJLyogdXBkYXRlIHBja3RzeiBtYXAgKi8NCj4g
KwlpZiAobWF4X3Bja3Rfc2l6ZSkgew0KPiArCQltYXBfZmQgPSBicGZfb2JqZWN0X19maW5kX21h
cF9mZF9ieV9uYW1lKG9iaiwgInBja3RzeiIpOw0KPiArCQlpZiAobWFwX2ZkIDwgMCkgew0KPiAr
CQkJcHJpbnRmKCJmaW5kaW5nIGEgcGNrdHN6IG1hcCBpbiBvYmogZmlsZSBmYWlsZWRcbiIpOw0K
PiArCQkJcmV0dXJuIDE7DQo+ICsJCX0NCj4gKwkJYnBmX21hcF91cGRhdGVfZWxlbShtYXBfZmQs
ICZrZXksICZtYXhfcGNrdF9zaXplLCBCUEZfQU5ZKTsNCj4gKwl9DQo+ICsNCj4gKwkvKiBmZXRj
aCBpY21wY250IG1hcCAqLw0KPiArCW1hcF9mZCA9IGJwZl9vYmplY3RfX2ZpbmRfbWFwX2ZkX2J5
X25hbWUob2JqLCAiaWNtcGNudCIpOw0KPiArCWlmIChtYXBfZmQgPCAwKSB7DQo+ICsJCXByaW50
ZigiZmluZGluZyBhIGljbXBjbnQgbWFwIGluIG9iaiBmaWxlIGZhaWxlZFxuIik7DQo+ICAgCQly
ZXR1cm4gMTsNCj4gICAJfQ0KPiAtCW1hcF9mZCA9IGJwZl9tYXBfX2ZkKG1hcCk7DQo+ICAgDQo+
ICAgCWlmICghcHJvZ19mZCkgew0KPiAgIAkJcHJpbnRmKCJsb2FkX2JwZl9maWxlOiAlc1xuIiwg
c3RyZXJyb3IoZXJybm8pKTsNCg0KQ291bGQgeW91IG1vdmUgdGhlICdpZiAoIXByb2dfZmQpIC4u
LicgcmlnaHQgYWZ0ZXIgJ2JwZl9wcm9nX2xvYWRfeGF0dHInDQpmb3IgcmVhZGFiaWxpdHkgcmVh
c29uPw0KDQpDb3VsZCB5b3UgYWxzbyBjaGFuZ2UgdGhlIGNvbmRpdGlvbiAnaWYgKCFwcm9nX2Zk
KScgdG8gJ2lmIChwcm9nX2ZkIDwgDQowKSc/IFlvdSBuZWVkIHRvIG1lbnRpb24gdGhpcyBmaXgg
aW4geW91ciBjb21taXQgbWVzc2FnZSBhcyB3ZWxsLg0K
