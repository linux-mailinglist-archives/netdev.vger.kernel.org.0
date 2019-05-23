Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13972275B3
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfEWFru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:47:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58342 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbfEWFrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 01:47:49 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4N5coLC023289;
        Wed, 22 May 2019 22:47:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=D4Nzd8rxVyvFYKbfoUHo9WxVD9d/pz6zG+6rGCRDz/k=;
 b=VXUvnptF1bcKl8UfSgo3TylNDBuc4m2Bc18AlcUAys5fP/1ZwKKb5JvAw3Ye5DXfIzge
 q+fIywyWpYttEXAh0vjizPBKgjHeY5ZNvLtQQgEOtXnaacsnR3H0jnjbwixtLaeTxKUG
 bviXXurFCGt0Hc7MyEQO3SyfQevKamPPbsA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn8b0ts78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 22:47:28 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 22 May 2019 22:47:27 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 22 May 2019 22:47:26 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 22:47:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4Nzd8rxVyvFYKbfoUHo9WxVD9d/pz6zG+6rGCRDz/k=;
 b=RnrRacRPTUVnkMfnlcPoR+P1kspRCwT2wUB/imQVwcN8NqfdXTevrGLxxvQ4Q6CMLqxY3zBNTPVi426jaGhlCsngEE04wbtCugyBEI/xK4d1ucNFQojI5YEGwJns7gGmCZrOeDrnir3/Qlh8f5ESB1l3ynQUuWnRyYoxpoow9so=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2549.namprd15.prod.outlook.com (20.179.155.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 05:47:24 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 05:47:24 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Topic: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Index: AQHVEPUtUUkH/nhO2UeBDfLyvw3JgKZ4NA4A
Date:   Thu, 23 May 2019 05:47:24 +0000
Message-ID: <f7953267-8559-2f58-f39a-b2b0c3bf2e38@fb.com>
References: <20190522232051.2938491-1-guro@fb.com>
 <20190522232051.2938491-5-guro@fb.com>
In-Reply-To: <20190522232051.2938491-5-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0053.namprd17.prod.outlook.com
 (2603:10b6:300:93::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c87a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4a82964-609c-4de6-ed3d-08d6df422195
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2549;
x-ms-traffictypediagnostic: BYAPR15MB2549:
x-microsoft-antispam-prvs: <BYAPR15MB2549F3C67AB7401AE5DD7658D3010@BYAPR15MB2549.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(346002)(376002)(39860400002)(199004)(189003)(6512007)(305945005)(99286004)(53546011)(36756003)(102836004)(7736002)(486006)(2906002)(478600001)(46003)(71190400001)(8676002)(71200400001)(81166006)(8936002)(53936002)(14454004)(2616005)(476003)(2501003)(81156014)(6506007)(386003)(52116002)(54906003)(14444005)(256004)(76176011)(86362001)(66946007)(66476007)(73956011)(4326008)(6486002)(110136005)(68736007)(6246003)(25786009)(186003)(5024004)(229853002)(5660300002)(6116002)(66446008)(446003)(31696002)(66556008)(316002)(11346002)(64756008)(31686004)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2549;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ulgk/Hqe3bLCe8Lpvuylr4cUENYggEqIQK4CQAoL66S44ZMVlpRAyjVL6+sHH35QLQEas3n1tPc12tmm7PC3xsRasH6hcN1fswuVFc7dmGq5YjMNGkHRsHBb96gXt/AYfUPKVQOcrUmxqVYSEJFHRmQLX24IxURQqWfEqqN8MKHJbhKKwW6iGTvIOrGQct4Gp8X4hp5T+Y3GJRdiZ/DoHV8tg2hjhXt6a2ynyRJZilDtiaWwkpFin27JcP7YH3PVyZDGcWsQoZ46loEtq7v50QP3whd03namHok5RagmJOq7kSMiRn0ylYHOKtMoHAqpWKWmvopQ6EoBSWeCip5Mg1eAzvFNV7nBA8m9ngAO66murVl3lUtlccNF4CNHKxqIqurxprqi+8BqRWrmbehQWBvpmJFfBqNRVIkaRl0h0Lo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BC6185A7850864EA12CCCAD9847F21E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a82964-609c-4de6-ed3d-08d6df422195
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 05:47:24.6351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2549
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=710 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjIvMTkgNDoyMCBQTSwgUm9tYW4gR3VzaGNoaW4gd3JvdGU6DQo+IEFkZCBhIGtz
ZWxmdGVzdCB0byBjb3ZlciBicGYgYXV0by1kZXRhY2htZW50IGZ1bmN0aW9uYWxpdHkuDQo+IFRo
ZSB0ZXN0IGNyZWF0ZXMgYSBjZ3JvdXAsIGFzc29jaWF0ZXMgc29tZSByZXNvdXJjZXMgd2l0aCBp
dCwNCj4gYXR0YWNoZXMgYSBjb3VwbGUgb2YgYnBmIHByb2dyYW1zIGFuZCBkZWxldGVzIHRoZSBj
Z3JvdXAuDQo+IA0KPiBUaGVuIGl0IGNoZWNrcyB0aGF0IGJwZiBwcm9ncmFtcyBhcmUgZ29pbmcg
YXdheSBpbiA1IHNlY29uZHMuDQo+IA0KPiBFeHBlY3RlZCBvdXRwdXQ6DQo+ICAgICQgLi90ZXN0
X2Nncm91cF9hdHRhY2gNCj4gICAgI292ZXJyaWRlOlBBU1MNCj4gICAgI211bHRpOlBBU1MNCj4g
ICAgI2F1dG9kZXRhY2g6UEFTUw0KPiAgICB0ZXN0X2Nncm91cF9hdHRhY2g6UEFTUw0KPiANCj4g
T24gYSBrZXJuZWwgd2l0aG91dCBhdXRvLWRldGFjaGluZzoNCj4gICAgJCAuL3Rlc3RfY2dyb3Vw
X2F0dGFjaA0KPiAgICAjb3ZlcnJpZGU6UEFTUw0KPiAgICAjbXVsdGk6UEFTUw0KPiAgICAjYXV0
b2RldGFjaDpGQUlMDQo+ICAgIHRlc3RfY2dyb3VwX2F0dGFjaDpGQUlMDQoNCkkgcmFuIHRoaXMg
cHJvYmxlbSB3aXRob3V0IGJvdGggb2xkIGFuZCBuZXcga2VybmVscyBhbmQNCmJvdGggZ2V0IGFs
bCBQQVNTZXMuIE15IHRlc3RpbmcgZW52aXJvbm1lbnQgaXMgYSBWTS4NCkNvdWxkIHlvdSBzcGVj
aWZ5IGhvdyB0byB0cmlnZ2VyIHRoZSBhYm92ZSBmYWlsdXJlPw0KDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBSb21hbiBHdXNoY2hpbiA8Z3Vyb0BmYi5jb20+DQo+IC0tLQ0KPiAgIC4uLi9zZWxmdGVz
dHMvYnBmL3Rlc3RfY2dyb3VwX2F0dGFjaC5jICAgICAgICB8IDk5ICsrKysrKysrKysrKysrKysr
Ky0NCj4gICAxIGZpbGUgY2hhbmdlZCwgOTggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91
cF9hdHRhY2guYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9hdHRh
Y2guYw0KPiBpbmRleCA5M2Q0ZmUyOTVlN2QuLmJjNWJkMGYxNzI4ZSAxMDA2NDQNCj4gLS0tIGEv
dG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfY2dyb3VwX2F0dGFjaC5jDQo+ICsrKyBi
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9hdHRhY2guYw0KPiBAQCAt
NDU2LDkgKzQ1NiwxMDYgQEAgc3RhdGljIGludCB0ZXN0X211bHRpcHJvZyh2b2lkKQ0KPiAgIAly
ZXR1cm4gcmM7DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIGludCB0ZXN0X2F1dG9kZXRhY2godm9p
ZCkNCj4gK3sNCj4gKwlfX3UzMiBwcm9nX2NudCA9IDQsIGF0dGFjaF9mbGFnczsNCj4gKwlpbnQg
YWxsb3dfcHJvZ1syXSA9IHswfTsNCj4gKwlfX3UzMiBwcm9nX2lkc1syXSA9IHswfTsNCj4gKwlp
bnQgY2cgPSAwLCBpLCByYyA9IC0xOw0KPiArCXZvaWQgKnB0ciA9IE5VTEw7DQo+ICsJaW50IGF0
dGVtcHRzOw0KPiArDQo+ICsNCj4gKwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRShhbGxvd19w
cm9nKTsgaSsrKSB7DQo+ICsJCWFsbG93X3Byb2dbaV0gPSBwcm9nX2xvYWRfY250KDEsIDEgPDwg
aSk7DQo+ICsJCWlmICghYWxsb3dfcHJvZ1tpXSkNCj4gKwkJCWdvdG8gZXJyOw0KPiArCX0NCj4g
Kw0KPiArCWlmIChzZXR1cF9jZ3JvdXBfZW52aXJvbm1lbnQoKSkNCj4gKwkJZ290byBlcnI7DQo+
ICsNCj4gKwkvKiBjcmVhdGUgYSBjZ3JvdXAsIGF0dGFjaCB0d28gcHJvZ3JhbXMgYW5kIHJlbWVt
YmVyIHRoZWlyIGlkcyAqLw0KPiArCWNnID0gY3JlYXRlX2FuZF9nZXRfY2dyb3VwKCIvY2dfYXV0
b2RldGFjaCIpOw0KPiArCWlmIChjZyA8IDApDQo+ICsJCWdvdG8gZXJyOw0KPiArDQo+ICsJaWYg
KGpvaW5fY2dyb3VwKCIvY2dfYXV0b2RldGFjaCIpKQ0KPiArCQlnb3RvIGVycjsNCj4gKw0KPiAr
CWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKGFsbG93X3Byb2cpOyBpKyspIHsNCj4gKwkJaWYg
KGJwZl9wcm9nX2F0dGFjaChhbGxvd19wcm9nW2ldLCBjZywgQlBGX0NHUk9VUF9JTkVUX0VHUkVT
UywNCj4gKwkJCQkgICAgQlBGX0ZfQUxMT1dfTVVMVEkpKSB7DQo+ICsJCQlsb2dfZXJyKCJBdHRh
Y2hpbmcgcHJvZ1slZF0gdG8gY2c6ZWdyZXNzIiwgaSk7DQo+ICsJCQlnb3RvIGVycjsNCj4gKwkJ
fQ0KPiArCX0NCj4gKw0KPiArCS8qIG1ha2Ugc3VyZSB0aGF0IHByb2dyYW1zIGFyZSBhdHRhY2hl
ZCBhbmQgcnVuIHNvbWUgdHJhZmZpYyAqLw0KPiArCWFzc2VydChicGZfcHJvZ19xdWVyeShjZywg
QlBGX0NHUk9VUF9JTkVUX0VHUkVTUywgMCwgJmF0dGFjaF9mbGFncywNCj4gKwkJCSAgICAgIHBy
b2dfaWRzLCAmcHJvZ19jbnQpID09IDApOw0KPiArCWFzc2VydChzeXN0ZW0oUElOR19DTUQpID09
IDApOw0KPiArDQo+ICsJLyogYWxsb2NhdGUgc29tZSBtZW1vcnkgKDRNYikgdG8gcGluIHRoZSBv
cmlnaW5hbCBjZ3JvdXAgKi8NCj4gKwlwdHIgPSBtYWxsb2MoNCAqICgxIDw8IDIwKSk7DQo+ICsJ
aWYgKCFwdHIpDQo+ICsJCWdvdG8gZXJyOw0KPiArDQo+ICsJLyogY2xvc2UgcHJvZ3JhbXMgYW5k
IGNncm91cCBmZCAqLw0KPiArCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKGFsbG93X3Byb2cp
OyBpKyspIHsNCj4gKwkJY2xvc2UoYWxsb3dfcHJvZ1tpXSk7DQo+ICsJCWFsbG93X3Byb2dbaV0g
PSAwOw0KPiArCX0NCj4gKw0KPiArCWNsb3NlKGNnKTsNCj4gKwljZyA9IDA7DQo+ICsNCj4gKwkv
KiBsZWF2ZSB0aGUgY2dyb3VwIGFuZCByZW1vdmUgaXQuIGRvbid0IGRldGFjaCBwcm9ncmFtcyAq
Lw0KPiArCWNsZWFudXBfY2dyb3VwX2Vudmlyb25tZW50KCk7DQo+ICsNCj4gKwkvKiB3YWl0IGZv
ciB0aGUgYXN5bmNocm9ub3VzIGF1dG8tZGV0YWNobWVudC4NCj4gKwkgKiB3YWl0IGZvciBubyBt
b3JlIHRoYW4gNSBzZWMgYW5kIGdpdmUgdXAuDQo+ICsJICovDQo+ICsJZm9yIChpID0gMDsgaSA8
IEFSUkFZX1NJWkUocHJvZ19pZHMpOyBpKyspIHsNCj4gKwkJZm9yIChhdHRlbXB0cyA9IDU7IGF0
dGVtcHRzID49IDA7IGF0dGVtcHRzLS0pIHsNCj4gKwkJCWludCBmZCA9IGJwZl9wcm9nX2dldF9m
ZF9ieV9pZChwcm9nX2lkc1tpXSk7DQo+ICsNCj4gKwkJCWlmIChmZCA8IDApDQo+ICsJCQkJYnJl
YWs7DQo+ICsNCj4gKwkJCS8qIGRvbid0IGxlYXZlIHRoZSBmZCBvcGVuICovDQo+ICsJCQljbG9z
ZShmZCk7DQo+ICsNCj4gKwkJCWlmICghYXR0ZW1wdHMpDQo+ICsJCQkJZ290byBlcnI7DQo+ICsN
Cj4gKwkJCXNsZWVwKDEpOw0KPiArCQl9DQo+ICsJfQ0KPiArDQo+ICsJcmMgPSAwOw0KPiArZXJy
Og0KPiArCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKGFsbG93X3Byb2cpOyBpKyspDQo+ICsJ
CWlmIChhbGxvd19wcm9nW2ldID4gMCkNCj4gKwkJCWNsb3NlKGFsbG93X3Byb2dbaV0pOw0KPiAr
CWlmIChjZykNCj4gKwkJY2xvc2UoY2cpOw0KPiArCWZyZWUocHRyKTsNCj4gKwljbGVhbnVwX2Nn
cm91cF9lbnZpcm9ubWVudCgpOw0KPiArCWlmICghcmMpDQo+ICsJCXByaW50ZigiI2F1dG9kZXRh
Y2g6UEFTU1xuIik7DQo+ICsJZWxzZQ0KPiArCQlwcmludGYoIiNhdXRvZGV0YWNoOkZBSUxcbiIp
Ow0KPiArCXJldHVybiByYzsNCj4gK30NCj4gKw0KPiAgIGludCBtYWluKGludCBhcmdjLCBjaGFy
ICoqYXJndikNCj4gICB7DQo+IC0JaW50ICgqdGVzdHNbXSkodm9pZCkgPSB7dGVzdF9mb29fYmFy
LCB0ZXN0X211bHRpcHJvZ307DQo+ICsJaW50ICgqdGVzdHNbXSkodm9pZCkgPSB7DQo+ICsJCXRl
c3RfZm9vX2JhciwNCj4gKwkJdGVzdF9tdWx0aXByb2csDQo+ICsJCXRlc3RfYXV0b2RldGFjaCwN
Cj4gKwl9Ow0KPiAgIAlpbnQgZXJyb3JzID0gMDsNCj4gICAJaW50IGk7DQo+ICAgDQo+IA0K
