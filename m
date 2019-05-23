Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A0228DA4
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388604AbfEWXKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:10:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38452 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388015AbfEWXKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 19:10:10 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NN5EFa016319;
        Thu, 23 May 2019 16:09:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=uq6BJ+pKj6xRhzw5uR8hoMYMFZoGjuFIfP/FnerFbTI=;
 b=FBP8UPGq8ZST0wp2r0ynWPNVLPzV0sXLCSN26nHZL15ND0VgIB7yP3vN8vfzTbB+BsNv
 B6/0PihmM4ZzSvjq0ysiPMriB9sXr373+RLc+YZwfoLI57g+FNY9cc3WVTiBYigvqxSx
 GogbkRXe0DmzZ3V1k5tUk2eyugkG5HHhGlw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sp15ngtpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 May 2019 16:09:48 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 16:09:46 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 16:09:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uq6BJ+pKj6xRhzw5uR8hoMYMFZoGjuFIfP/FnerFbTI=;
 b=i6iy/wNeDqQG/iBu6o6VPvHSp4map3/1po+xKPKmunqnU/6oC4l4s8YU36Taj4ZkVqxicFvL+drehnI0Egg8CkJPefRs/d4whruSfNGN7JqV8BJ04RadKIWuDBmzFYK/E7rLuS7j5GIxvs1mCDwasy7sODLgmbni53TNpcZt7F0=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2406.namprd15.prod.outlook.com (52.135.198.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 23:09:31 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 23:09:31 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Topic: [PATCH v3 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Index: AQHVEaCFg6pXZ47Yn0aCqZKhGzHn/6Z5VeMA
Date:   Thu, 23 May 2019 23:09:30 +0000
Message-ID: <4ff840cb-7e24-62d5-4ea7-fbca34218800@fb.com>
References: <20190523194532.2376233-1-guro@fb.com>
 <20190523194532.2376233-5-guro@fb.com>
In-Reply-To: <20190523194532.2376233-5-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0048.namprd15.prod.outlook.com
 (2603:10b6:101:1f::16) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::d011]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f3e2bf3-9f78-49ad-5b8b-08d6dfd3b621
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2406;
x-ms-traffictypediagnostic: BYAPR15MB2406:
x-microsoft-antispam-prvs: <BYAPR15MB240600282376D0ED5868D697D3010@BYAPR15MB2406.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(366004)(376002)(39860400002)(199004)(189003)(7736002)(476003)(2616005)(186003)(256004)(31686004)(14444005)(5024004)(36756003)(486006)(11346002)(54906003)(46003)(305945005)(81156014)(8936002)(81166006)(446003)(8676002)(53936002)(14454004)(110136005)(5660300002)(71190400001)(71200400001)(6246003)(86362001)(102836004)(6512007)(53546011)(68736007)(76176011)(386003)(6506007)(478600001)(6436002)(4326008)(25786009)(2501003)(66946007)(73956011)(99286004)(52116002)(6116002)(66556008)(66446008)(64756008)(66476007)(229853002)(6486002)(31696002)(316002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2406;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FNwIImmVTya0d6QVtSeRihb9fZtuGlfQIcepDs79JOWWcRtGB+IgpKCaAYsUQl8mFeHPsyDkA7rBuaUAXLmxjYOYVgBwZqCVD7Jx7+Z9qeSzOzdskz4yLiBpsow9ekAGRrA83zBfvhC4B4mUudFxtFNPnsy+GiOZz7t+YNBqQ+QIRhTuux8qZHMy/u/WJv4NUyoX0sa0L/Sxqzd4AoBLTcTH3iiAo2LbQMAUQlVIew8ZCswJtwynQDMdArTJepLD2fENK+vd3SD9BQPC39iHmEguViAXIXCn1bHQTkpRK7CRYg/M4wVklewiK5cMd0g8VLqgFaLpJYsyePBH5xCisJk5HuL6I1DdVhOXzqA4ZJRBXFlWfr0gImXB8+AWIV50qU9gIOINlAg8a35PQCk+vBgPeZM+0/6fO9CTm9Rghh4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC104A1435D9E4498C5C759DF5144600@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3e2bf3-9f78-49ad-5b8b-08d6dfd3b621
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 23:09:30.9554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2406
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_17:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=641 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjMvMTkgMTI6NDUgUE0sIFJvbWFuIEd1c2hjaGluIHdyb3RlOg0KPiBBZGQgYSBr
c2VsZnRlc3QgdG8gY292ZXIgYnBmIGF1dG8tZGV0YWNobWVudCBmdW5jdGlvbmFsaXR5Lg0KPiBU
aGUgdGVzdCBjcmVhdGVzIGEgY2dyb3VwLCBhc3NvY2lhdGVzIHNvbWUgcmVzb3VyY2VzIHdpdGgg
aXQsDQo+IGF0dGFjaGVzIGEgY291cGxlIG9mIGJwZiBwcm9ncmFtcyBhbmQgZGVsZXRlcyB0aGUg
Y2dyb3VwLg0KPiANCj4gVGhlbiBpdCBjaGVja3MgdGhhdCBicGYgcHJvZ3JhbXMgYXJlIGdvaW5n
IGF3YXkgaW4gNSBzZWNvbmRzLg0KPiANCj4gRXhwZWN0ZWQgb3V0cHV0Og0KPiAgICAkIC4vdGVz
dF9jZ3JvdXBfYXR0YWNoDQo+ICAgICNvdmVycmlkZTpQQVNTDQo+ICAgICNtdWx0aTpQQVNTDQo+
ICAgICNhdXRvZGV0YWNoOlBBU1MNCj4gICAgdGVzdF9jZ3JvdXBfYXR0YWNoOlBBU1MNCj4gDQo+
IE9uIGEga2VybmVsIHdpdGhvdXQgYXV0by1kZXRhY2hpbmc6DQo+ICAgICQgLi90ZXN0X2Nncm91
cF9hdHRhY2gNCj4gICAgI292ZXJyaWRlOlBBU1MNCj4gICAgI211bHRpOlBBU1MNCj4gICAgI2F1
dG9kZXRhY2g6RkFJTA0KPiAgICB0ZXN0X2Nncm91cF9hdHRhY2g6RkFJTA0KPiANCj4gU2lnbmVk
LW9mZi1ieTogUm9tYW4gR3VzaGNoaW4gPGd1cm9AZmIuY29tPg0KDQpMb29rcyBnb29kIHRvIG1l
LiBJdCB3aWxsIGJlIGdvb2QgaWYgeW91IGNhbiBhZGQgdGVzdF9jZ3JvdXBfYXR0YWNoDQp0byAu
Z2l0aWdub3JlIHRvIGF2b2lkIGl0IHNob3dzIHVwIGluIGBnaXQgc3RhdHVzYC4gV2l0aCB0aGF0
LA0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg0KPiAtLS0NCj4gICAu
Li4vc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9hdHRhY2guYyAgICAgICAgfCA5OCArKysrKysr
KysrKysrKysrKystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDk3IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYv
dGVzdF9jZ3JvdXBfYXR0YWNoLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9j
Z3JvdXBfYXR0YWNoLmMNCj4gaW5kZXggMmQ2ZDU3ZjUwZTEwLi43NjcxOTA5ZWUxY2IgMTAwNjQ0
DQo+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9hdHRhY2gu
Yw0KPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9jZ3JvdXBfYXR0YWNo
LmMNCj4gQEAgLTQ1Niw5ICs0NTYsMTA1IEBAIHN0YXRpYyBpbnQgdGVzdF9tdWx0aXByb2codm9p
ZCkNCj4gICAJcmV0dXJuIHJjOw0KPiAgIH0NCj4gICANCj4gK3N0YXRpYyBpbnQgdGVzdF9hdXRv
ZGV0YWNoKHZvaWQpDQo+ICt7DQo+ICsJX191MzIgcHJvZ19jbnQgPSA0LCBhdHRhY2hfZmxhZ3M7
DQo+ICsJaW50IGFsbG93X3Byb2dbMl0gPSB7MH07DQo+ICsJX191MzIgcHJvZ19pZHNbMl0gPSB7
MH07DQo+ICsJaW50IGNnID0gMCwgaSwgcmMgPSAtMTsNCj4gKwl2b2lkICpwdHIgPSBOVUxMOw0K
PiArCWludCBhdHRlbXB0czsNCj4gKw0KPiArCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKGFs
bG93X3Byb2cpOyBpKyspIHsNCj4gKwkJYWxsb3dfcHJvZ1tpXSA9IHByb2dfbG9hZF9jbnQoMSwg
MSA8PCBpKTsNCj4gKwkJaWYgKCFhbGxvd19wcm9nW2ldKQ0KPiArCQkJZ290byBlcnI7DQo+ICsJ
fQ0KPiArDQo+ICsJaWYgKHNldHVwX2Nncm91cF9lbnZpcm9ubWVudCgpKQ0KPiArCQlnb3RvIGVy
cjsNCj4gKw0KPiArCS8qIGNyZWF0ZSBhIGNncm91cCwgYXR0YWNoIHR3byBwcm9ncmFtcyBhbmQg
cmVtZW1iZXIgdGhlaXIgaWRzICovDQo+ICsJY2cgPSBjcmVhdGVfYW5kX2dldF9jZ3JvdXAoIi9j
Z19hdXRvZGV0YWNoIik7DQo+ICsJaWYgKGNnIDwgMCkNCj4gKwkJZ290byBlcnI7DQo+ICsNCj4g
KwlpZiAoam9pbl9jZ3JvdXAoIi9jZ19hdXRvZGV0YWNoIikpDQo+ICsJCWdvdG8gZXJyOw0KPiAr
DQo+ICsJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoYWxsb3dfcHJvZyk7IGkrKykgew0KPiAr
CQlpZiAoYnBmX3Byb2dfYXR0YWNoKGFsbG93X3Byb2dbaV0sIGNnLCBCUEZfQ0dST1VQX0lORVRf
RUdSRVNTLA0KPiArCQkJCSAgICBCUEZfRl9BTExPV19NVUxUSSkpIHsNCj4gKwkJCWxvZ19lcnIo
IkF0dGFjaGluZyBwcm9nWyVkXSB0byBjZzplZ3Jlc3MiLCBpKTsNCj4gKwkJCWdvdG8gZXJyOw0K
PiArCQl9DQo+ICsJfQ0KPiArDQo+ICsJLyogbWFrZSBzdXJlIHRoYXQgcHJvZ3JhbXMgYXJlIGF0
dGFjaGVkIGFuZCBydW4gc29tZSB0cmFmZmljICovDQo+ICsJYXNzZXJ0KGJwZl9wcm9nX3F1ZXJ5
KGNnLCBCUEZfQ0dST1VQX0lORVRfRUdSRVNTLCAwLCAmYXR0YWNoX2ZsYWdzLA0KPiArCQkJICAg
ICAgcHJvZ19pZHMsICZwcm9nX2NudCkgPT0gMCk7DQo+ICsJYXNzZXJ0KHN5c3RlbShQSU5HX0NN
RCkgPT0gMCk7DQo+ICsNCj4gKwkvKiBhbGxvY2F0ZSBzb21lIG1lbW9yeSAoNE1iKSB0byBwaW4g
dGhlIG9yaWdpbmFsIGNncm91cCAqLw0KPiArCXB0ciA9IG1hbGxvYyg0ICogKDEgPDwgMjApKTsN
Cj4gKwlpZiAoIXB0cikNCj4gKwkJZ290byBlcnI7DQo+ICsNCj4gKwkvKiBjbG9zZSBwcm9ncmFt
cyBhbmQgY2dyb3VwIGZkICovDQo+ICsJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoYWxsb3df
cHJvZyk7IGkrKykgew0KPiArCQljbG9zZShhbGxvd19wcm9nW2ldKTsNCj4gKwkJYWxsb3dfcHJv
Z1tpXSA9IDA7DQo+ICsJfQ0KPiArDQo+ICsJY2xvc2UoY2cpOw0KPiArCWNnID0gMDsNCj4gKw0K
PiArCS8qIGxlYXZlIHRoZSBjZ3JvdXAgYW5kIHJlbW92ZSBpdC4gZG9uJ3QgZGV0YWNoIHByb2dy
YW1zICovDQo+ICsJY2xlYW51cF9jZ3JvdXBfZW52aXJvbm1lbnQoKTsNCj4gKw0KPiArCS8qIHdh
aXQgZm9yIHRoZSBhc3luY2hyb25vdXMgYXV0by1kZXRhY2htZW50Lg0KPiArCSAqIHdhaXQgZm9y
IG5vIG1vcmUgdGhhbiA1IHNlYyBhbmQgZ2l2ZSB1cC4NCj4gKwkgKi8NCj4gKwlmb3IgKGkgPSAw
OyBpIDwgQVJSQVlfU0laRShwcm9nX2lkcyk7IGkrKykgew0KPiArCQlmb3IgKGF0dGVtcHRzID0g
NTsgYXR0ZW1wdHMgPj0gMDsgYXR0ZW1wdHMtLSkgew0KPiArCQkJaW50IGZkID0gYnBmX3Byb2df
Z2V0X2ZkX2J5X2lkKHByb2dfaWRzW2ldKTsNCj4gKw0KPiArCQkJaWYgKGZkIDwgMCkNCj4gKwkJ
CQlicmVhazsNCj4gKw0KPiArCQkJLyogZG9uJ3QgbGVhdmUgdGhlIGZkIG9wZW4gKi8NCj4gKwkJ
CWNsb3NlKGZkKTsNCj4gKw0KPiArCQkJaWYgKCFhdHRlbXB0cykNCj4gKwkJCQlnb3RvIGVycjsN
Cj4gKw0KPiArCQkJc2xlZXAoMSk7DQo+ICsJCX0NCj4gKwl9DQo+ICsNCj4gKwlyYyA9IDA7DQo+
ICtlcnI6DQo+ICsJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoYWxsb3dfcHJvZyk7IGkrKykN
Cj4gKwkJaWYgKGFsbG93X3Byb2dbaV0gPiAwKQ0KPiArCQkJY2xvc2UoYWxsb3dfcHJvZ1tpXSk7
DQo+ICsJaWYgKGNnKQ0KPiArCQljbG9zZShjZyk7DQo+ICsJZnJlZShwdHIpOw0KPiArCWNsZWFu
dXBfY2dyb3VwX2Vudmlyb25tZW50KCk7DQo+ICsJaWYgKCFyYykNCj4gKwkJcHJpbnRmKCIjYXV0
b2RldGFjaDpQQVNTXG4iKTsNCj4gKwllbHNlDQo+ICsJCXByaW50ZigiI2F1dG9kZXRhY2g6RkFJ
TFxuIik7DQo+ICsJcmV0dXJuIHJjOw0KPiArfQ0KPiArDQo+ICAgaW50IG1haW4odm9pZCkNCj4g
ICB7DQo+IC0JaW50ICgqdGVzdHNbXSkodm9pZCkgPSB7dGVzdF9mb29fYmFyLCB0ZXN0X211bHRp
cHJvZ307DQo+ICsJaW50ICgqdGVzdHNbXSkodm9pZCkgPSB7DQo+ICsJCXRlc3RfZm9vX2JhciwN
Cj4gKwkJdGVzdF9tdWx0aXByb2csDQo+ICsJCXRlc3RfYXV0b2RldGFjaCwNCj4gKwl9Ow0KPiAg
IAlpbnQgZXJyb3JzID0gMDsNCj4gICAJaW50IGk7DQo+ICAgDQo+IA0K
