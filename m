Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C86282C8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbfEWQUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:20:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33036 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730790AbfEWQUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:20:19 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NGBlFb026232;
        Thu, 23 May 2019 09:19:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=X4vd8cImKy22/yqfhfn95Pp1YmJzRx/DQHLxlkw40dY=;
 b=Zxbo4gV2BoQCj37Y8dIzaZrVYnAvN6A+xPy8M9BD9pwTmydhblaBtM2NtV7oUIPzJbnq
 tSVcP2u4sYjMR0MCxCDX4gjsfB24EV02G3vDJDSoh/PVEj3PH8e9SRvcHdIQ2IltiCBU
 BQpqNnaX9Qced6Pjz5movb35kYN04qyDLek= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2snu990uf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 May 2019 09:19:52 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 09:19:51 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 09:19:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4vd8cImKy22/yqfhfn95Pp1YmJzRx/DQHLxlkw40dY=;
 b=gjiDeRURNx1Ilw+ErqUUfj2XNa3TiFeJc9k3+uMMJGkJJe5d5LL6ZEP84RKXYmWYLekluhGCBkV88fGkz8DXf0UwOaqBc5HBOCVcQsthUdUCBviZPzuQUAIWH842pwVw/cFVZYUjmhV2wDGr8dxl19EVLVJGvioSOYKgQi9H9nk=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2263.namprd15.prod.outlook.com (52.135.197.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 16:19:49 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 16:19:49 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [PATCH bpf-next v2 2/3] libbpf: add bpf_object__load_xattr() API
 function to pass log_level
Thread-Topic: [PATCH bpf-next v2 2/3] libbpf: add bpf_object__load_xattr() API
 function to pass log_level
Thread-Index: AQHVEVX0x9CZVTZqdk+w+vMT57iUPKZ45AAA
Date:   Thu, 23 May 2019 16:19:49 +0000
Message-ID: <d9d1d907-9f0d-7fc0-3f2d-dde5081e8bd3@fb.com>
References: <20190523105426.3938-1-quentin.monnet@netronome.com>
 <20190523105426.3938-3-quentin.monnet@netronome.com>
In-Reply-To: <20190523105426.3938-3-quentin.monnet@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0185.namprd04.prod.outlook.com
 (2603:10b6:104:5::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::d011]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c214d302-c1fa-4263-4385-08d6df9a7a5b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2263;
x-ms-traffictypediagnostic: BYAPR15MB2263:
x-microsoft-antispam-prvs: <BYAPR15MB2263C135BA62EC897DFE2D80D3010@BYAPR15MB2263.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(346002)(376002)(366004)(189003)(199004)(102836004)(6246003)(2906002)(478600001)(31686004)(305945005)(7736002)(386003)(6506007)(53546011)(5660300002)(73956011)(4326008)(76176011)(66946007)(6512007)(52116002)(71190400001)(71200400001)(8936002)(6486002)(66446008)(64756008)(66556008)(66476007)(6436002)(53936002)(446003)(256004)(86362001)(11346002)(486006)(186003)(99286004)(316002)(476003)(14454004)(68736007)(14444005)(2616005)(25786009)(6116002)(229853002)(54906003)(31696002)(110136005)(8676002)(81156014)(36756003)(81166006)(46003)(101420200001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2263;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oCvalis2x1tZ/gqIIYnrVGdNgyHEj725DFQi2QcktNl20MluL2R/2/lhsVr1dLGFkFeODC+N6LM8Hi1vosz1lC65qpa8ThsNsW7GdjsUni7sGUvw0QpUWNyxd0b9UkCbbqT34srHPlQmsG1ewZrIlfrK5/a5GLNd5BkfH47doY0G76dU/sW7kXYnFusLGjvfOxzzgZswT/IVh9UUTSEbDa0DbLgaS2Igo6ETLC6Sg0EzW4uIV8E/d6gt0frM5rpicb3DKAIR2ATWopL4gHk8qb483GPckPeLyC3pwM9exgScCfJx2I9fgXNoBa1kJ8nKbUFOi7veyq4C4iv8e+T1bB4cFevXEHfI/B/bu3pm1PxJWCCV46Gvs40wTIkVdRBHR37e9wqL2CB+ITuyW8UhqsmwQoMBbpUe7JFbhLqo5tI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF8B6B98965BD3448EE2274CF6464A55@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c214d302-c1fa-4263-4385-08d6df9a7a5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 16:19:49.4310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2263
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230110
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjMvMTkgMzo1NCBBTSwgUXVlbnRpbiBNb25uZXQgd3JvdGU6DQo+IGxpYmJwZiB3
YXMgcmVjZW50bHkgbWFkZSBhd2FyZSBvZiB0aGUgbG9nX2xldmVsIGF0dHJpYnV0ZSBmb3IgcHJv
Z3JhbXMsDQo+IHVzZWQgdG8gc3BlY2lmeSB0aGUgbGV2ZWwgb2YgaW5mb3JtYXRpb24gZXhwZWN0
ZWQgdG8gYmUgZHVtcGVkIGJ5IHRoZQ0KPiB2ZXJpZmllci4NCj4gDQo+IENyZWF0ZSBhbiBBUEkg
ZnVuY3Rpb24gdG8gcGFzcyBhZGRpdGlvbmFsIGF0dHJpYnV0ZXMgd2hlbiBsb2FkaW5nIGENCj4g
YnBmX29iamVjdCwgc28gd2UgY2FuIHNldCB0aGlzIGxvZ19sZXZlbCB2YWx1ZSBpbiBwcm9ncmFt
cyB3aGVuIGxvYWRpbmcNCj4gdGhlbSwgYW5kIHNvIHRoYXQgc28gdGhhdCBhcHBsaWNhdGlvbnMg
cmVseWluZyBvbiBsaWJicGYgYnV0IG5vdCBjYWxsaW5nDQoic28gdGhhdCBzbyB0aGF0IiA9PiAi
c28gdGhhdCINCj4gYnBmX3Byb2dfbG9hZF94YXR0cigpIGNhbiBhbHNvIHVzZSB0aGF0IGZlYXR1
cmUuDQoNCkRvIG5vdCBmdWxseSB1bmRlcnN0YW5kIHRoZSBhYm92ZSBzdGF0ZW1lbnQuIEZyb20g
dGhlIGNvZGUgYmVsb3csDQpJIGRpZCBub3Qgc2VlIGhvdyB0aGUgbm9uLXplcm8gbG9nX2xldmVs
IGNhbiBiZSBzZXQgZm9yIGJwZl9wcm9ncmFtDQp3aXRob3V0IGJwZl9wcm9nX2xvYWRfeGF0dHIo
KS4gTWF5YmUgSSBtaXNzIHNvbWV0aGluZz8NCg0KPiANCj4gdjI6DQo+IC0gV2UgYXJlIGluIGEg
bmV3IGN5Y2xlLCBidW1wIGxpYmJwZiBleHRyYXZlcnNpb24gbnVtYmVyLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogUXVlbnRpbiBNb25uZXQgPHF1ZW50aW4ubW9ubmV0QG5ldHJvbm9tZS5jb20+DQo+
IFJldmlld2VkLWJ5OiBKYWt1YiBLaWNpbnNraSA8amFrdWIua2ljaW5za2lAbmV0cm9ub21lLmNv
bT4NCj4gLS0tDQo+ICAgdG9vbHMvbGliL2JwZi9NYWtlZmlsZSAgIHwgIDIgKy0NCj4gICB0b29s
cy9saWIvYnBmL2xpYmJwZi5jICAgfCAyMCArKysrKysrKysrKysrKysrKy0tLQ0KPiAgIHRvb2xz
L2xpYi9icGYvbGliYnBmLmggICB8ICA2ICsrKysrKw0KPiAgIHRvb2xzL2xpYi9icGYvbGliYnBm
Lm1hcCB8ICA1ICsrKysrDQo+ICAgNCBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUg
Yi90b29scy9saWIvYnBmL01ha2VmaWxlDQo+IGluZGV4IGEyYWNlYWRmNjhkYi4uOTMxMjA2NmEx
YWUzIDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBmL01ha2VmaWxlDQo+ICsrKyBiL3Rvb2xz
L2xpYi9icGYvTWFrZWZpbGUNCj4gQEAgLTMsNyArMyw3IEBADQo+ICAgDQo+ICAgQlBGX1ZFUlNJ
T04gPSAwDQo+ICAgQlBGX1BBVENITEVWRUwgPSAwDQo+IC1CUEZfRVhUUkFWRVJTSU9OID0gMw0K
PiArQlBGX0VYVFJBVkVSU0lPTiA9IDQNCj4gICANCj4gICBNQUtFRkxBR1MgKz0gLS1uby1wcmlu
dC1kaXJlY3RvcnkNCj4gICANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMg
Yi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+IGluZGV4IDE5N2I1NzQ0MDZiMy4uMWM2ZmI3YTMy
MDFlIDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+ICsrKyBiL3Rvb2xz
L2xpYi9icGYvbGliYnBmLmMNCj4gQEAgLTIyMjIsNyArMjIyMiw3IEBAIHN0YXRpYyBib29sIGJw
Zl9wcm9ncmFtX19pc19mdW5jdGlvbl9zdG9yYWdlKHN0cnVjdCBicGZfcHJvZ3JhbSAqcHJvZywN
Cj4gICB9DQo+ICAgDQo+ICAgc3RhdGljIGludA0KPiAtYnBmX29iamVjdF9fbG9hZF9wcm9ncyhz
dHJ1Y3QgYnBmX29iamVjdCAqb2JqKQ0KPiArYnBmX29iamVjdF9fbG9hZF9wcm9ncyhzdHJ1Y3Qg
YnBmX29iamVjdCAqb2JqLCBpbnQgbG9nX2xldmVsKQ0KPiAgIHsNCj4gICAJc2l6ZV90IGk7DQo+
ICAgCWludCBlcnI7DQo+IEBAIC0yMjMwLDYgKzIyMzAsNyBAQCBicGZfb2JqZWN0X19sb2FkX3By
b2dzKHN0cnVjdCBicGZfb2JqZWN0ICpvYmopDQo+ICAgCWZvciAoaSA9IDA7IGkgPCBvYmotPm5y
X3Byb2dyYW1zOyBpKyspIHsNCj4gICAJCWlmIChicGZfcHJvZ3JhbV9faXNfZnVuY3Rpb25fc3Rv
cmFnZSgmb2JqLT5wcm9ncmFtc1tpXSwgb2JqKSkNCj4gICAJCQljb250aW51ZTsNCj4gKwkJb2Jq
LT5wcm9ncmFtc1tpXS5sb2dfbGV2ZWwgPSBsb2dfbGV2ZWw7DQo+ICAgCQllcnIgPSBicGZfcHJv
Z3JhbV9fbG9hZCgmb2JqLT5wcm9ncmFtc1tpXSwNCj4gICAJCQkJCW9iai0+bGljZW5zZSwNCj4g
ICAJCQkJCW9iai0+a2Vybl92ZXJzaW9uKTsNCj4gQEAgLTIzODEsMTAgKzIzODIsMTQgQEAgaW50
IGJwZl9vYmplY3RfX3VubG9hZChzdHJ1Y3QgYnBmX29iamVjdCAqb2JqKQ0KPiAgIAlyZXR1cm4g
MDsNCj4gICB9DQo+ICAgDQo+IC1pbnQgYnBmX29iamVjdF9fbG9hZChzdHJ1Y3QgYnBmX29iamVj
dCAqb2JqKQ0KPiAraW50IGJwZl9vYmplY3RfX2xvYWRfeGF0dHIoc3RydWN0IGJwZl9vYmplY3Rf
bG9hZF9hdHRyICphdHRyKQ0KPiAgIHsNCj4gKwlzdHJ1Y3QgYnBmX29iamVjdCAqb2JqOw0KPiAg
IAlpbnQgZXJyOw0KPiAgIA0KPiArCWlmICghYXR0cikNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+
ICsJb2JqID0gYXR0ci0+b2JqOw0KPiAgIAlpZiAoIW9iaikNCj4gICAJCXJldHVybiAtRUlOVkFM
Ow0KPiAgIA0KPiBAQCAtMjM5Nyw3ICsyNDAyLDcgQEAgaW50IGJwZl9vYmplY3RfX2xvYWQoc3Ry
dWN0IGJwZl9vYmplY3QgKm9iaikNCj4gICANCj4gICAJQ0hFQ0tfRVJSKGJwZl9vYmplY3RfX2Ny
ZWF0ZV9tYXBzKG9iaiksIGVyciwgb3V0KTsNCj4gICAJQ0hFQ0tfRVJSKGJwZl9vYmplY3RfX3Jl
bG9jYXRlKG9iaiksIGVyciwgb3V0KTsNCj4gLQlDSEVDS19FUlIoYnBmX29iamVjdF9fbG9hZF9w
cm9ncyhvYmopLCBlcnIsIG91dCk7DQo+ICsJQ0hFQ0tfRVJSKGJwZl9vYmplY3RfX2xvYWRfcHJv
Z3Mob2JqLCBhdHRyLT5sb2dfbGV2ZWwpLCBlcnIsIG91dCk7DQo+ICAgDQo+ICAgCXJldHVybiAw
Ow0KPiAgIG91dDoNCj4gQEAgLTI0MDYsNiArMjQxMSwxNSBAQCBpbnQgYnBmX29iamVjdF9fbG9h
ZChzdHJ1Y3QgYnBmX29iamVjdCAqb2JqKQ0KPiAgIAlyZXR1cm4gZXJyOw0KPiAgIH0NCj4gICAN
Cj4gK2ludCBicGZfb2JqZWN0X19sb2FkKHN0cnVjdCBicGZfb2JqZWN0ICpvYmopDQo+ICt7DQo+
ICsJc3RydWN0IGJwZl9vYmplY3RfbG9hZF9hdHRyIGF0dHIgPSB7DQo+ICsJCS5vYmogPSBvYmos
DQo+ICsJfTsNCj4gKw0KPiArCXJldHVybiBicGZfb2JqZWN0X19sb2FkX3hhdHRyKCZhdHRyKTsN
Cj4gK30NCj4gKw0KPiAgIHN0YXRpYyBpbnQgY2hlY2tfcGF0aChjb25zdCBjaGFyICpwYXRoKQ0K
PiAgIHsNCj4gICAJY2hhciAqY3AsIGVycm1zZ1tTVFJFUlJfQlVGU0laRV07DQo+IGRpZmYgLS1n
aXQgYS90b29scy9saWIvYnBmL2xpYmJwZi5oIGIvdG9vbHMvbGliL2JwZi9saWJicGYuaA0KPiBp
bmRleCBjNWZmMDA1MTVjZTcuLmUxYzc0OGRiNDRmNiAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvbGli
L2JwZi9saWJicGYuaA0KPiArKysgYi90b29scy9saWIvYnBmL2xpYmJwZi5oDQo+IEBAIC04OSw4
ICs4OSwxNCBAQCBMSUJCUEZfQVBJIGludCBicGZfb2JqZWN0X191bnBpbl9wcm9ncmFtcyhzdHJ1
Y3QgYnBmX29iamVjdCAqb2JqLA0KPiAgIExJQkJQRl9BUEkgaW50IGJwZl9vYmplY3RfX3Bpbihz
dHJ1Y3QgYnBmX29iamVjdCAqb2JqZWN0LCBjb25zdCBjaGFyICpwYXRoKTsNCj4gICBMSUJCUEZf
QVBJIHZvaWQgYnBmX29iamVjdF9fY2xvc2Uoc3RydWN0IGJwZl9vYmplY3QgKm9iamVjdCk7DQo+
ICAgDQo+ICtzdHJ1Y3QgYnBmX29iamVjdF9sb2FkX2F0dHIgew0KPiArCXN0cnVjdCBicGZfb2Jq
ZWN0ICpvYmo7DQo+ICsJaW50IGxvZ19sZXZlbDsNCj4gK307DQo+ICsNCj4gICAvKiBMb2FkL3Vu
bG9hZCBvYmplY3QgaW50by9mcm9tIGtlcm5lbCAqLw0KPiAgIExJQkJQRl9BUEkgaW50IGJwZl9v
YmplY3RfX2xvYWQoc3RydWN0IGJwZl9vYmplY3QgKm9iaik7DQo+ICtMSUJCUEZfQVBJIGludCBi
cGZfb2JqZWN0X19sb2FkX3hhdHRyKHN0cnVjdCBicGZfb2JqZWN0X2xvYWRfYXR0ciAqYXR0cik7
DQo+ICAgTElCQlBGX0FQSSBpbnQgYnBmX29iamVjdF9fdW5sb2FkKHN0cnVjdCBicGZfb2JqZWN0
ICpvYmopOw0KPiAgIExJQkJQRl9BUEkgY29uc3QgY2hhciAqYnBmX29iamVjdF9fbmFtZShzdHJ1
Y3QgYnBmX29iamVjdCAqb2JqKTsNCj4gICBMSUJCUEZfQVBJIHVuc2lnbmVkIGludCBicGZfb2Jq
ZWN0X19rdmVyc2lvbihzdHJ1Y3QgYnBmX29iamVjdCAqb2JqKTsNCj4gZGlmZiAtLWdpdCBhL3Rv
b2xzL2xpYi9icGYvbGliYnBmLm1hcCBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcA0KPiBpbmRl
eCA2NzMwMDE3ODdjYmEuLjZjZTYxZmEwYmFmMyAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvbGliL2Jw
Zi9saWJicGYubWFwDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcA0KPiBAQCAtMTY0
LDMgKzE2NCw4IEBAIExJQkJQRl8wLjAuMyB7DQo+ICAgCQlicGZfbWFwX2ZyZWV6ZTsNCj4gICAJ
CWJ0Zl9fZmluYWxpemVfZGF0YTsNCj4gICB9IExJQkJQRl8wLjAuMjsNCj4gKw0KPiArTElCQlBG
XzAuMC40IHsNCj4gKwlnbG9iYWw6DQo+ICsJCWJwZl9vYmplY3RfX2xvYWRfeGF0dHI7DQo+ICt9
IExJQkJQRl8wLjAuMzsNCj4gDQo=
