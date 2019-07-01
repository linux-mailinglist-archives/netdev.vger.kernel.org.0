Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABED5C1CF
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfGARNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:13:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728591AbfGARNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:13:43 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61HA4wT028677;
        Mon, 1 Jul 2019 10:13:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=WBEc9+2AeQSZS84G92P8GWLYlijIqQXuhjuh/B/seKQ=;
 b=EFcIO6mgXI7FrteLBjny+7ozBLK5QYRaPHC75HLsfaRlxoFqAgDxI9A6KmPNP/GlKNAA
 GPL8QG1qcU6Clp20GsbaNFNYuX2EH6aZ/ZYfJvi9ZnYs8nzAXDcnUeFoUBj3ppuAC5IT
 VbX4S7sGQ3Ex+kdOUH7WJg6pNnNTbGElfS0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfjmegxy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Jul 2019 10:13:22 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 1 Jul 2019 10:13:20 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 10:13:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBEc9+2AeQSZS84G92P8GWLYlijIqQXuhjuh/B/seKQ=;
 b=sTUbEXtEAHY4Y06HwsjHbpK589Q2P+nhiRUsP/I4j3e/qmlNqtjRb8YdWpDSYVyIrlvx5kzDbb8TH/5DXZInDj5SUOD6MlZRaROl6QXaq3lURJEPiAjjqwXO+0Wtse8U+uskd0BljeeH0IyA0Mobeq0EoxDNJVkM1ZyN7+QYYtA=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3013.namprd15.prod.outlook.com (20.178.238.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 17:13:19 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 17:13:19 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 bpf-next 6/9] libbpf: add raw tracepoint attach API
Thread-Topic: [PATCH v4 bpf-next 6/9] libbpf: add raw tracepoint attach API
Thread-Index: AQHVLi2rAoPQPf+NCkqAuxw7NA58oqa2BC6A
Date:   Mon, 1 Jul 2019 17:13:19 +0000
Message-ID: <e6be6907-4587-6106-9868-e76fbf38a3f5@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-7-andriin@fb.com>
In-Reply-To: <20190629034906.1209916-7-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0011.namprd20.prod.outlook.com
 (2603:10b6:301:15::21) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29cb7245-2cf5-428f-6885-08d6fe47699a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3013;
x-ms-traffictypediagnostic: BYAPR15MB3013:
x-microsoft-antispam-prvs: <BYAPR15MB3013470946EDF8640893E3D6D3F90@BYAPR15MB3013.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:128;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(396003)(346002)(39860400002)(199004)(189003)(478600001)(5660300002)(25786009)(6636002)(68736007)(6246003)(6436002)(6486002)(66946007)(73956011)(66446008)(53936002)(66476007)(2201001)(6512007)(64756008)(110136005)(316002)(66556008)(71200400001)(229853002)(14454004)(71190400001)(102836004)(256004)(11346002)(14444005)(5024004)(76176011)(7736002)(46003)(86362001)(31696002)(486006)(6506007)(476003)(2616005)(53546011)(305945005)(186003)(446003)(8936002)(6116002)(81166006)(81156014)(99286004)(2906002)(8676002)(52116002)(2501003)(31686004)(386003)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3013;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MfeIUdxjiyA5oRW4hc/HKprbHEHWfeWaj4+oKHtWhEpfBrDwO0GGaoljSe9BNmVmjkRZOP1LDNyRdLxU/1Bd7oRtmUu/eT1J2fGmLgCI6Ki8Njg5Q0ZtUICWrUH1fW425+WH4+VEHhGACgsOYqybSzV3Nl5MeA2tQxqctFZV+cIo54rmd/ap5gbln4zf107BK72uAbF+W8+yO6/ApWSby/QCotBP8GV6Oj1YBmkidfdw+Q5vAsGR4D+9OrMPUf+e4h+ekSKHL9kKBI0+jP5HL1Ukmwxr0VUjPNxAdfpG1sym36Da5az5r2vEXsBya5KOzGOVLLTx9dp3jxionnbsNxdT71QsXC33rLwIrzinzLlxUKBYRN4FVIzKSU8GGHsK1djZi/8mquRt38WctVtUNIm5cZV/2dMIZPwKAu1tNrw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D9CFB6D8A864D44B92AD7256488B043@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 29cb7245-2cf5-428f-6885-08d6fe47699a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 17:13:19.0951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3013
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010202
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjgvMTkgODo0OSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBBZGQgYSB3
cmFwcGVyIHV0aWxpemluZyBicGZfbGluayAiaW5mcmFzdHJ1Y3R1cmUiIHRvIGFsbG93IGF0dGFj
aGluZyBCUEYNCj4gcHJvZ3JhbXMgdG8gcmF3IHRyYWNlcG9pbnRzLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4gQWNrZWQtYnk6IFNvbmcg
TGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+DQo+IC0tLQ0KPiAgIHRvb2xzL2xpYi9icGYvbGli
YnBmLmMgICB8IDM3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gICB0
b29scy9saWIvYnBmL2xpYmJwZi5oICAgfCAgMyArKysNCj4gICB0b29scy9saWIvYnBmL2xpYmJw
Zi5tYXAgfCAgMSArDQo+ICAgMyBmaWxlcyBjaGFuZ2VkLCA0MSBpbnNlcnRpb25zKCspDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYuYyBiL3Rvb2xzL2xpYi9icGYvbGli
YnBmLmMNCj4gaW5kZXggOGFkNGY5MTVkZjM4Li5mOGM3YTdlY2IzNWUgMTAwNjQ0DQo+IC0tLSBh
L3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYuYw0K
PiBAQCAtNDI2Myw2ICs0MjYzLDQzIEBAIHN0cnVjdCBicGZfbGluayAqYnBmX3Byb2dyYW1fX2F0
dGFjaF90cmFjZXBvaW50KHN0cnVjdCBicGZfcHJvZ3JhbSAqcHJvZywNCj4gICAJcmV0dXJuIGxp
bms7DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIGludCBicGZfbGlua19fZGVzdHJveV9mZChzdHJ1
Y3QgYnBmX2xpbmsgKmxpbmspDQo+ICt7DQo+ICsJc3RydWN0IGJwZl9saW5rX2ZkICpsID0gKHZv
aWQgKilsaW5rOw0KPiArDQo+ICsJcmV0dXJuIGNsb3NlKGwtPmZkKTsNCj4gK30NCj4gKw0KPiAr
c3RydWN0IGJwZl9saW5rICpicGZfcHJvZ3JhbV9fYXR0YWNoX3Jhd190cmFjZXBvaW50KHN0cnVj
dCBicGZfcHJvZ3JhbSAqcHJvZywNCj4gKwkJCQkJCSAgICBjb25zdCBjaGFyICp0cF9uYW1lKQ0K
PiArew0KPiArCWNoYXIgZXJybXNnW1NUUkVSUl9CVUZTSVpFXTsNCj4gKwlzdHJ1Y3QgYnBmX2xp
bmtfZmQgKmxpbms7DQo+ICsJaW50IHByb2dfZmQsIHBmZDsNCj4gKw0KPiArCXByb2dfZmQgPSBi
cGZfcHJvZ3JhbV9fZmQocHJvZyk7DQo+ICsJaWYgKHByb2dfZmQgPCAwKSB7DQo+ICsJCXByX3dh
cm5pbmcoInByb2dyYW0gJyVzJzogY2FuJ3QgYXR0YWNoIGJlZm9yZSBsb2FkZWRcbiIsDQo+ICsJ
CQkgICBicGZfcHJvZ3JhbV9fdGl0bGUocHJvZywgZmFsc2UpKTsNCj4gKwkJcmV0dXJuIEVSUl9Q
VFIoLUVJTlZBTCk7DQo+ICsJfQ0KPiArDQo+ICsJbGluayA9IG1hbGxvYyhzaXplb2YoKmxpbmsp
KTsNCj4gKwlsaW5rLT5saW5rLmRlc3Ryb3kgPSAmYnBmX2xpbmtfX2Rlc3Ryb3lfZmQ7DQoNCllv
dSBjYW4gbW92ZSB0aGUgImxpbmsgPSBtYWxsb2MoLi4uKSIgZXRjLiBhZnRlciANCmJwZl9yYXdf
dHJhY2Vwb2ludF9vcGVuKCkuIFRoYXQgd2F5LCB5b3UgZG8gbm90IG5lZWQgdG8gZnJlZShsaW5r
KQ0KaW4gdGhlIGVycm9yIGNhc2UuDQoNCj4gKw0KPiArCXBmZCA9IGJwZl9yYXdfdHJhY2Vwb2lu
dF9vcGVuKHRwX25hbWUsIHByb2dfZmQpOw0KPiArCWlmIChwZmQgPCAwKSB7DQo+ICsJCXBmZCA9
IC1lcnJubzsNCj4gKwkJZnJlZShsaW5rKTsNCj4gKwkJcHJfd2FybmluZygicHJvZ3JhbSAnJXMn
OiBmYWlsZWQgdG8gYXR0YWNoIHRvIHJhdyB0cmFjZXBvaW50ICclcyc6ICVzXG4iLA0KPiArCQkJ
ICAgYnBmX3Byb2dyYW1fX3RpdGxlKHByb2csIGZhbHNlKSwgdHBfbmFtZSwNCj4gKwkJCSAgIGxp
YmJwZl9zdHJlcnJvcl9yKHBmZCwgZXJybXNnLCBzaXplb2YoZXJybXNnKSkpOw0KPiArCQlyZXR1
cm4gRVJSX1BUUihwZmQpOw0KPiArCX0NCj4gKwlsaW5rLT5mZCA9IHBmZDsNCj4gKwlyZXR1cm4g
KHN0cnVjdCBicGZfbGluayAqKWxpbms7DQo+ICt9DQo+ICsNCj4gICBlbnVtIGJwZl9wZXJmX2V2
ZW50X3JldA0KPiAgIGJwZl9wZXJmX2V2ZW50X3JlYWRfc2ltcGxlKHZvaWQgKm1tYXBfbWVtLCBz
aXplX3QgbW1hcF9zaXplLCBzaXplX3QgcGFnZV9zaXplLA0KPiAgIAkJCSAgIHZvaWQgKipjb3B5
X21lbSwgc2l6ZV90ICpjb3B5X3NpemUsDQo+IGRpZmYgLS1naXQgYS90b29scy9saWIvYnBmL2xp
YmJwZi5oIGIvdG9vbHMvbGliL2JwZi9saWJicGYuaA0KPiBpbmRleCA2MDYxMWY0YjRlMWQuLmY1
NTkzMzc4NGY5NSAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvbGliL2JwZi9saWJicGYuaA0KPiArKysg
Yi90b29scy9saWIvYnBmL2xpYmJwZi5oDQo+IEBAIC0xODIsNiArMTgyLDkgQEAgTElCQlBGX0FQ
SSBzdHJ1Y3QgYnBmX2xpbmsgKg0KPiAgIGJwZl9wcm9ncmFtX19hdHRhY2hfdHJhY2Vwb2ludChz
dHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csDQo+ICAgCQkJICAgICAgIGNvbnN0IGNoYXIgKnRwX2Nh
dGVnb3J5LA0KPiAgIAkJCSAgICAgICBjb25zdCBjaGFyICp0cF9uYW1lKTsNCj4gK0xJQkJQRl9B
UEkgc3RydWN0IGJwZl9saW5rICoNCj4gK2JwZl9wcm9ncmFtX19hdHRhY2hfcmF3X3RyYWNlcG9p
bnQoc3RydWN0IGJwZl9wcm9ncmFtICpwcm9nLA0KPiArCQkJCSAgIGNvbnN0IGNoYXIgKnRwX25h
bWUpOw0KPiAgIA0KPiAgIHN0cnVjdCBicGZfaW5zbjsNCj4gICANCj4gZGlmZiAtLWdpdCBhL3Rv
b2xzL2xpYi9icGYvbGliYnBmLm1hcCBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcA0KPiBpbmRl
eCAzYzYxOGI3NWVmNjUuLmU2YjdkNGVkYmM5MyAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvbGliL2Jw
Zi9saWJicGYubWFwDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcA0KPiBAQCAtMTcx
LDYgKzE3MSw3IEBAIExJQkJQRl8wLjAuNCB7DQo+ICAgCQlicGZfb2JqZWN0X19sb2FkX3hhdHRy
Ow0KPiAgIAkJYnBmX3Byb2dyYW1fX2F0dGFjaF9rcHJvYmU7DQo+ICAgCQlicGZfcHJvZ3JhbV9f
YXR0YWNoX3BlcmZfZXZlbnQ7DQo+ICsJCWJwZl9wcm9ncmFtX19hdHRhY2hfcmF3X3RyYWNlcG9p
bnQ7DQo+ICAgCQlicGZfcHJvZ3JhbV9fYXR0YWNoX3RyYWNlcG9pbnQ7DQo+ICAgCQlicGZfcHJv
Z3JhbV9fYXR0YWNoX3Vwcm9iZTsNCj4gICAJCWJ0Zl9kdW1wX19kdW1wX3R5cGU7DQo+IA0K
