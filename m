Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E9E2A6C1
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 21:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfEYTO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 15:14:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45298 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725791AbfEYTO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 15:14:56 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4PJ7Ut3011933;
        Sat, 25 May 2019 12:14:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6w5sJ1u2lrUGLNoMxEO6L+rFeul8lBwTarIvX+EhZIE=;
 b=SoCtcBeEbrN4/+XhrPqyrcYuY2KeJYt8CI/26k8pJ+v/y6ig7b/2GNwa9yhZ2urqTPvr
 s/DiHBXjCwK9N0ijni0ci0reHYtcA/FEH6FA7tD1q77gsbFz/3QDtGu/fGhWhLnWNkku
 syMPq3ZirE4QHoCadgODajm1hWi3OkWjgHs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sq50j0sx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 25 May 2019 12:14:24 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 25 May 2019 12:14:23 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 25 May 2019 12:14:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6w5sJ1u2lrUGLNoMxEO6L+rFeul8lBwTarIvX+EhZIE=;
 b=n96eMGXPU+uE//jrUetZ5G3B11S/qlpa40ATQ6LLl368eXJXBcjM/I9xK8IptoNu6Kg6UIL9wIZT5WsG/A1es23sXEsMYOqs/DSnDavRFLjjvtQsIaQoYppYhGjw5wze6RQ99A4m/MRL1/KRQqlW6JdiqOJOwnvSsUAPAJ5PNV8=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2279.namprd15.prod.outlook.com (52.135.197.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Sat, 25 May 2019 19:14:20 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1922.021; Sat, 25 May 2019
 19:14:20 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>, Kernel Team <Kernel-team@fb.com>,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: implement bpf_send_signal() helper
Thread-Topic: [PATCH bpf-next v5 1/3] bpf: implement bpf_send_signal() helper
Thread-Index: AQHVEbFAdcZbQBZzEE6RKT6takmR46Z6zu2A//+WOgCAAHoJgIABWYOA
Date:   Sat, 25 May 2019 19:14:20 +0000
Message-ID: <c68987ee-57e9-0882-2e06-0c4e48b3fbbd@fb.com>
References: <20190523214745.854300-1-yhs@fb.com>
 <20190523214745.854355-1-yhs@fb.com>
 <54257f88-b088-2330-ba49-a78ce06d08bf@iogearbox.net>
 <fe5ed98c-0cc2-b126-25e6-84774c03bcb9@fb.com>
 <289e2279-8a88-8046-d4e0-c29cf79080a5@iogearbox.net>
In-Reply-To: <289e2279-8a88-8046-d4e0-c29cf79080a5@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0015.namprd08.prod.outlook.com
 (2603:10b6:301:5f::28) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d262]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13a239de-43a1-4260-954e-08d6e1453069
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2279;
x-ms-traffictypediagnostic: BYAPR15MB2279:
x-microsoft-antispam-prvs: <BYAPR15MB22797AC7323D7B5F1B1341A1D3030@BYAPR15MB2279.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0048BCF4DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(102836004)(2501003)(71200400001)(99286004)(386003)(52116002)(2201001)(478600001)(31686004)(256004)(7736002)(6116002)(6506007)(31696002)(76176011)(305945005)(8936002)(2906002)(86362001)(54906003)(316002)(36756003)(14444005)(110136005)(4326008)(6486002)(53936002)(71190400001)(14454004)(8676002)(6512007)(486006)(25786009)(476003)(11346002)(229853002)(5660300002)(46003)(68736007)(66446008)(73956011)(81166006)(66556008)(81156014)(64756008)(66476007)(6246003)(66946007)(186003)(446003)(6436002)(53546011)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2279;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JoCJ2jxx+YDIcm+SPqbvS6SWplqGRXJkjrYsbyYThRgscayv1qKM98GDJQLzlU/Dvl7XTulpygZGydEWzfWvgaWpRj0bpawE5F/OgHHX669vFWDYEjWEf61zo7hSea6Ah2YH59VFfvUV7io8RfmD2cIT2cP2tQXs8Jxk/tLB6J64Zy7PqKp5BAf+XumBv9cg6RgluYbX6nAGsKZtbf/R8w+DcSQb9uXJKZ+xc3vnhKQyJaUP5qkUXsYPq730YLLzdGzvfIEBEWmtHpvN6OgnZRJWo3JUAEZAR/vAvMUheKia48G196ByntQxJJg38LOMwr48/s75CkhC04zkJbsbsihD6UoCAqItMEv6uB2qnfVhdHq7XYzX21m3Zpm1WSLcZpV1FiUMkfjsgWl5SPf5hWJPPskDRRcfOjTgQH+qRQc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <721639B4A5321E4383A0939E5A651A24@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a239de-43a1-4260-954e-08d6e1453069
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2019 19:14:20.4890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2279
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-25_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905250135
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjQvMTkgMzozNyBQTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPiBPbiAwNS8y
NS8yMDE5IDEyOjIwIEFNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4gT24gNS8yNC8xOSAyOjM5
IFBNLCBEYW5pZWwgQm9ya21hbm4gd3JvdGU6DQo+Pj4gT24gMDUvMjMvMjAxOSAxMTo0NyBQTSwg
WW9uZ2hvbmcgU29uZyB3cm90ZToNCj4+Pj4gVGhpcyBwYXRjaCB0cmllcyB0byBzb2x2ZSB0aGUg
Zm9sbG93aW5nIHNwZWNpZmljIHVzZSBjYXNlLg0KPj4+Pg0KPj4+PiBDdXJyZW50bHksIGJwZiBw
cm9ncmFtIGNhbiBhbHJlYWR5IGNvbGxlY3Qgc3RhY2sgdHJhY2VzDQo+Pj4+IHRocm91Z2gga2Vy
bmVsIGZ1bmN0aW9uIGdldF9wZXJmX2NhbGxjaGFpbigpDQo+Pj4+IHdoZW4gY2VydGFpbiBldmVu
dHMgaGFwcGVucyAoZS5nLiwgY2FjaGUgbWlzcyBjb3VudGVyIG9yDQo+Pj4+IGNwdSBjbG9jayBj
b3VudGVyIG92ZXJmbG93cykuIEJ1dCBzdWNoIHN0YWNrIHRyYWNlcyBhcmUNCj4+Pj4gbm90IGVu
b3VnaCBmb3Igaml0dGVkIHByb2dyYW1zLCBlLmcuLCBoaHZtIChqaXRlZCBwaHApLg0KPj4+PiBU
byBnZXQgcmVhbCBzdGFjayB0cmFjZSwgaml0IGVuZ2luZSBpbnRlcm5hbCBkYXRhIHN0cnVjdHVy
ZXMNCj4+Pj4gbmVlZCB0byBiZSB0cmF2ZXJzZWQgaW4gb3JkZXIgdG8gZ2V0IHRoZSByZWFsIHVz
ZXIgZnVuY3Rpb25zLg0KPj4+Pg0KPj4+PiBicGYgcHJvZ3JhbSBpdHNlbGYgbWF5IG5vdCBiZSB0
aGUgYmVzdCBwbGFjZSB0byB0cmF2ZXJzZQ0KPj4+PiB0aGUgaml0IGVuZ2luZSBhcyB0aGUgdHJh
dmVyc2luZyBsb2dpYyBjb3VsZCBiZSBjb21wbGV4IGFuZA0KPj4+PiBpdCBpcyBub3QgYSBzdGFi
bGUgaW50ZXJmYWNlIGVpdGhlci4NCj4+Pj4NCj4+Pj4gSW5zdGVhZCwgaGh2bSBpbXBsZW1lbnRz
IGEgc2lnbmFsIGhhbmRsZXIsDQo+Pj4+IGUuZy4gZm9yIFNJR0FMQVJNLCBhbmQgYSBzZXQgb2Yg
cHJvZ3JhbSBsb2NhdGlvbnMgd2hpY2gNCj4+Pj4gaXQgY2FuIGR1bXAgc3RhY2sgdHJhY2VzLiBX
aGVuIGl0IHJlY2VpdmVzIGEgc2lnbmFsLCBpdCB3aWxsDQo+Pj4+IGR1bXAgdGhlIHN0YWNrIGlu
IG5leHQgc3VjaCBwcm9ncmFtIGxvY2F0aW9uLg0KPj4+Pg0KPj4+PiBTdWNoIGEgbWVjaGFuaXNt
IGNhbiBiZSBpbXBsZW1lbnRlZCBpbiB0aGUgZm9sbG93aW5nIHdheToNCj4+Pj4gICAgIC4gYSBw
ZXJmIHJpbmcgYnVmZmVyIGlzIGNyZWF0ZWQgYmV0d2VlbiBicGYgcHJvZ3JhbQ0KPj4+PiAgICAg
ICBhbmQgdHJhY2luZyBhcHAuDQo+Pj4+ICAgICAuIG9uY2UgYSBwYXJ0aWN1bGFyIGV2ZW50IGhh
cHBlbnMsIGJwZiBwcm9ncmFtIHdyaXRlcw0KPj4+PiAgICAgICB0byB0aGUgcmluZyBidWZmZXIg
YW5kIHRoZSB0cmFjaW5nIGFwcCBnZXRzIG5vdGlmaWVkLg0KPj4+PiAgICAgLiB0aGUgdHJhY2lu
ZyBhcHAgc2VuZHMgYSBzaWduYWwgU0lHQUxBUk0gdG8gdGhlIGhodm0uDQo+Pj4+DQo+Pj4+IEJ1
dCB0aGlzIG1ldGhvZCBjb3VsZCBoYXZlIGxhcmdlIGRlbGF5cyBhbmQgY2F1c2luZyBwcm9maWxp
bmcNCj4+Pj4gcmVzdWx0cyBza2V3ZWQuDQo+Pj4+DQo+Pj4+IFRoaXMgcGF0Y2ggaW1wbGVtZW50
cyBicGZfc2VuZF9zaWduYWwoKSBoZWxwZXIgdG8gc2VuZA0KPj4+PiBhIHNpZ25hbCB0byBoaHZt
IGluIHJlYWwgdGltZSwgcmVzdWx0aW5nIGluIGludGVuZGVkIHN0YWNrIHRyYWNlcy4NCj4+Pj4N
Cj4+Pj4gQWNrZWQtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+Pj4+IFNp
Z25lZC1vZmYtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+Pj4+IC0tLQ0KPj4+PiAg
ICBpbmNsdWRlL3VhcGkvbGludXgvYnBmLmggfCAxNyArKysrKysrKystDQo+Pj4+ICAgIGtlcm5l
bC90cmFjZS9icGZfdHJhY2UuYyB8IDcyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysNCj4+Pj4gICAgMiBmaWxlcyBjaGFuZ2VkLCA4OCBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvYnBm
LmggYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4+Pj4gaW5kZXggNjNlMGNmNjZmMDFhLi42
OGQ0NDcwNTIzYTAgMTAwNjQ0DQo+Pj4+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0K
Pj4+PiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4+Pj4gQEAgLTI2NzIsNiArMjY3
MiwyMCBAQCB1bmlvbiBicGZfYXR0ciB7DQo+Pj4+ICAgICAqCQkwIG9uIHN1Y2Nlc3MuDQo+Pj4+
ICAgICAqDQo+Pj4+ICAgICAqCQkqKi1FTk9FTlQqKiBpZiB0aGUgYnBmLWxvY2FsLXN0b3JhZ2Ug
Y2Fubm90IGJlIGZvdW5kLg0KPj4+PiArICoNCj4+Pj4gKyAqIGludCBicGZfc2VuZF9zaWduYWwo
dTMyIHNpZykNCj4+Pj4gKyAqCURlc2NyaXB0aW9uDQo+Pj4+ICsgKgkJU2VuZCBzaWduYWwgKnNp
ZyogdG8gdGhlIGN1cnJlbnQgdGFzay4NCj4+Pj4gKyAqCVJldHVybg0KPj4+PiArICoJCTAgb24g
c3VjY2VzcyBvciBzdWNjZXNzZnVsbHkgcXVldWVkLg0KPj4+PiArICoNCj4+Pj4gKyAqCQkqKi1F
QlVTWSoqIGlmIHdvcmsgcXVldWUgdW5kZXIgbm1pIGlzIGZ1bGwuDQo+Pj4+ICsgKg0KPj4+PiAr
ICoJCSoqLUVJTlZBTCoqIGlmICpzaWcqIGlzIGludmFsaWQuDQo+Pj4+ICsgKg0KPj4+PiArICoJ
CSoqLUVQRVJNKiogaWYgbm8gcGVybWlzc2lvbiB0byBzZW5kIHRoZSAqc2lnKi4NCj4+Pj4gKyAq
DQo+Pj4+ICsgKgkJKiotRUFHQUlOKiogaWYgYnBmIHByb2dyYW0gY2FuIHRyeSBhZ2Fpbi4NCj4+
Pj4gICAgICovDQo+Pj4+ICAgICNkZWZpbmUgX19CUEZfRlVOQ19NQVBQRVIoRk4pCQlcDQo+Pj4+
ICAgIAlGTih1bnNwZWMpLAkJCVwNCj4+Pj4gQEAgLTI3ODIsNyArMjc5Niw4IEBAIHVuaW9uIGJw
Zl9hdHRyIHsNCj4+Pj4gICAgCUZOKHN0cnRvbCksCQkJXA0KPj4+PiAgICAJRk4oc3RydG91bCks
CQkJXA0KPj4+PiAgICAJRk4oc2tfc3RvcmFnZV9nZXQpLAkJXA0KPj4+PiAtCUZOKHNrX3N0b3Jh
Z2VfZGVsZXRlKSwNCj4+Pj4gKwlGTihza19zdG9yYWdlX2RlbGV0ZSksCQlcDQo+Pj4+ICsJRk4o
c2VuZF9zaWduYWwpLA0KPj4+PiAgICANCj4+Pj4gICAgLyogaW50ZWdlciB2YWx1ZSBpbiAnaW1t
JyBmaWVsZCBvZiBCUEZfQ0FMTCBpbnN0cnVjdGlvbiBzZWxlY3RzIHdoaWNoIGhlbHBlcg0KPj4+
PiAgICAgKiBmdW5jdGlvbiBlQlBGIHByb2dyYW0gaW50ZW5kcyB0byBjYWxsDQo+Pj4+IGRpZmYg
LS1naXQgYS9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMgYi9rZXJuZWwvdHJhY2UvYnBmX3RyYWNl
LmMNCj4+Pj4gaW5kZXggZjkyZDZhZDVlMDgwLi43MDAyOWVhZmM3MWYgMTAwNjQ0DQo+Pj4+IC0t
LSBhL2tlcm5lbC90cmFjZS9icGZfdHJhY2UuYw0KPj4+PiArKysgYi9rZXJuZWwvdHJhY2UvYnBm
X3RyYWNlLmMNCj4+Pj4gQEAgLTU2Nyw2ICs1NjcsNjMgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBi
cGZfZnVuY19wcm90byBicGZfcHJvYmVfcmVhZF9zdHJfcHJvdG8gPSB7DQo+Pj4+ICAgIAkuYXJn
M190eXBlCT0gQVJHX0FOWVRISU5HLA0KPj4+PiAgICB9Ow0KPj4+PiAgICANCj4+Pj4gK3N0cnVj
dCBzZW5kX3NpZ25hbF9pcnFfd29yayB7DQo+Pj4+ICsJc3RydWN0IGlycV93b3JrIGlycV93b3Jr
Ow0KPj4+PiArCXN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzazsNCj4+Pj4gKwl1MzIgc2lnOw0KPj4+
PiArfTsNCj4+Pj4gKw0KPj4+PiArc3RhdGljIERFRklORV9QRVJfQ1BVKHN0cnVjdCBzZW5kX3Np
Z25hbF9pcnFfd29yaywgc2VuZF9zaWduYWxfd29yayk7DQo+Pj4+ICsNCj4+Pj4gK3N0YXRpYyB2
b2lkIGRvX2JwZl9zZW5kX3NpZ25hbChzdHJ1Y3QgaXJxX3dvcmsgKmVudHJ5KQ0KPj4+PiArew0K
Pj4+PiArCXN0cnVjdCBzZW5kX3NpZ25hbF9pcnFfd29yayAqd29yazsNCj4+Pj4gKw0KPj4+PiAr
CXdvcmsgPSBjb250YWluZXJfb2YoZW50cnksIHN0cnVjdCBzZW5kX3NpZ25hbF9pcnFfd29yaywg
aXJxX3dvcmspOw0KPj4+PiArCWdyb3VwX3NlbmRfc2lnX2luZm8od29yay0+c2lnLCBTRU5EX1NJ
R19QUklWLCB3b3JrLT50YXNrLCBQSURUWVBFX1RHSUQpOw0KPj4+PiArfQ0KPj4+PiArDQo+Pj4+
ICtCUEZfQ0FMTF8xKGJwZl9zZW5kX3NpZ25hbCwgdTMyLCBzaWcpDQo+Pj4+ICt7DQo+Pj4+ICsJ
c3RydWN0IHNlbmRfc2lnbmFsX2lycV93b3JrICp3b3JrID0gTlVMTDsNCj4+Pj4gKw0KPj4+PiAr
CS8qIFNpbWlsYXIgdG8gYnBmX3Byb2JlX3dyaXRlX3VzZXIsIHRhc2sgbmVlZHMgdG8gYmUNCj4+
Pj4gKwkgKiBpbiBhIHNvdW5kIGNvbmRpdGlvbiBhbmQga2VybmVsIG1lbW9yeSBhY2Nlc3MgYmUN
Cj4+Pj4gKwkgKiBwZXJtaXR0ZWQgaW4gb3JkZXIgdG8gc2VuZCBzaWduYWwgdG8gdGhlIGN1cnJl
bnQNCj4+Pj4gKwkgKiB0YXNrLg0KPj4+PiArCSAqLw0KPj4+PiArCWlmICh1bmxpa2VseShjdXJy
ZW50LT5mbGFncyAmIChQRl9LVEhSRUFEIHwgUEZfRVhJVElORykpKQ0KPj4+PiArCQlyZXR1cm4g
LUVQRVJNOw0KPj4+PiArCWlmICh1bmxpa2VseSh1YWNjZXNzX2tlcm5lbCgpKSkNCj4+Pj4gKwkJ
cmV0dXJuIC1FUEVSTTsNCj4+Pj4gKwlpZiAodW5saWtlbHkoIW5taV91YWNjZXNzX29rYXkoKSkp
DQo+Pj4+ICsJCXJldHVybiAtRVBFUk07DQo+Pj4+ICsNCj4+Pj4gKwlpZiAoaW5fbm1pKCkpIHsN
Cj4+Pj4gKwkJd29yayA9IHRoaXNfY3B1X3B0cigmc2VuZF9zaWduYWxfd29yayk7DQo+Pj4+ICsJ
CWlmICh3b3JrLT5pcnFfd29yay5mbGFncyAmIElSUV9XT1JLX0JVU1kpDQo+Pj4NCj4+PiBHaXZl
biBoZXJlIGFuZCBpbiBzdGFja21hcCBhcmUgdGhlIG9ubHkgdHdvIHVzZXJzIG91dHNpZGUgb2Yg
a2VybmVsL2lycV93b3JrLmMsDQo+Pj4gaXQgbWF5IHByb2JhYmx5IGJlIGdvb2QgdG8gYWRkIGEg
c21hbGwgaGVscGVyIHRvIGluY2x1ZGUvbGludXgvaXJxX3dvcmsuaCBhbmQNCj4+PiB1c2UgaXQg
Zm9yIGJvdGguDQo+Pj4NCj4+PiBQZXJoYXBzIHNvbWV0aGluZyBsaWtlIC4uLg0KPj4+DQo+Pj4g
c3RhdGljIGlubGluZSBib29sIGlycV93b3JrX2J1c3koc3RydWN0IGlycV93b3JrICp3b3JrKQ0K
Pj4+IHsNCj4+PiAJcmV0dXJuIFJFQURfT05DRSh3b3JrLT5mbGFncykgJiBJUlFfV09SS19CVVNZ
Ow0KPj4+IH0NCj4+DQo+PiBOb3Qgc3VyZSB3aGV0aGVyIFJFQURfT05DRSBpcyBuZWVkZWQgaGVy
ZSBvciBub3QuDQo+Pg0KPj4gVGhlIGlycV93b3JrIGlzIHBlciBjcHUgZGF0YSBzdHJ1Y3R1cmUs
DQo+PiAgICAgc3RhdGljIERFRklORV9QRVJfQ1BVKHN0cnVjdCBzZW5kX3NpZ25hbF9pcnFfd29y
aywgc2VuZF9zaWduYWxfd29yayk7DQo+PiBzbyBwcmVzdW1hYmx5IG5vIGNvbGxpc2lvbiBmb3Ig
d29yay0+ZmxhZ3MgbWVtb3J5IHJlZmVyZW5jZS4NCj4gDQo+IFRoZSBidXN5IGJpdCB5b3UncmUg
dGVzdGluZyBpcyBjbGVhcmVkIHZpYSBjbXB4Y2hnKCksIGtlcm5lbC9pcnFfd29yay5jICsxNjk6
DQo+IA0KPiBjbXB4Y2hnKCZ3b3JrLT5mbGFncywgZmxhZ3MsIGZsYWdzICYgfklSUV9XT1JLX0JV
U1kpOw0KDQpMb29rcyBsaWtlIGZvciBicGYgY2FzZSwgd2UgaGF2ZSBicGZfcHJvZ19hY3RpdmUg
Z3VhcmRpbmcsDQpzbyBuZXN0ZWQgbm1pIHdvbid0IHRyaWdnZXIgbmVzdGVkIGJwZl9zZW5kX3Np
Z25hbCgpIGNhbGwsDQpzbyB3ZSBzaG91bGQgYmUgZmluZSB3aXRob3V0IFJFQURfT05DRSBoZXJl
Lg0KDQpBbHNvLA0Kc3RydWN0IGlycV93b3JrIHsNCiAgICAgICAgIHVuc2lnbmVkIGxvbmcgZmxh
Z3M7DQogICAgICAgICBzdHJ1Y3QgbGxpc3Rfbm9kZSBsbG5vZGU7DQogICAgICAgICB2b2lkICgq
ZnVuYykoc3RydWN0IGlycV93b3JrICopOw0KfTsNCg0KLWJhc2gtNC40JCBlZ3JlcCAtciAnd29y
ay0+ZmxhZ3MnIGlycV93b3JrLmMgDQoNCiAgICAgICAgIGZsYWdzID0gd29yay0+ZmxhZ3MgJiB+
SVJRX1dPUktfUEVORElORzsNCiAgICAgICAgICAgICAgICAgb2ZsYWdzID0gY21weGNoZygmd29y
ay0+ZmxhZ3MsIGZsYWdzLCBuZmxhZ3MpOw0KICAgICAgICAgaWYgKHdvcmstPmZsYWdzICYgSVJR
X1dPUktfTEFaWSkgew0KICAgICAgICAgICAgICAgICBmbGFncyA9IHdvcmstPmZsYWdzICYgfklS
UV9XT1JLX1BFTkRJTkc7DQogICAgICAgICAgICAgICAgIHhjaGcoJndvcmstPmZsYWdzLCBmbGFn
cyk7DQogICAgICAgICAgICAgICAgICh2b2lkKWNtcHhjaGcoJndvcmstPmZsYWdzLCBmbGFncywg
ZmxhZ3MgJiB+SVJRX1dPUktfQlVTWSk7DQogICAgICAgICB3aGlsZSAod29yay0+ZmxhZ3MgJiBJ
UlFfV09SS19CVVNZKQ0KLWJhc2gtNC40JA0KDQogRnJvbSB0aGUgYWJvdmUsIGBmbGFnc2AgaXMg
dW5zaWduZWQgbG9uZyBhbmQgbm8gUkVBRF9PTkNFDQppcyB1c2VkLCBwZW9wbGUgbWF5IGFscmVh
ZHkgYXNzdW1lIGF0b21pYyByZWFkX29uY2UgaXMgYXZhaWxhYmxlLA0Kc28gbm90IHVzaW5nIGl0
Lg0K
