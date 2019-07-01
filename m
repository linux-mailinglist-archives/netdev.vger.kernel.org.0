Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43FA55C5D7
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfGAXFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:05:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12418 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbfGAXFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:05:41 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61N4r8H009919;
        Mon, 1 Jul 2019 16:05:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cJPxExWAyEJeHd8bcvy5LmI2hJ/6SLyJVtWGxJu98fU=;
 b=b168uECQIr/RLUwTYjMZ6J8NJFAjlcgdZRIghgRpqeeXn4ZU2WKSBQ703CBE387jr2ZP
 H306ji0O84RNl+V7nku3eqKShH77z2I+AWZz/azdKu+2N+ft1uZewf/cedmzdv8HP1hx
 j7k6BSBrSIcfaqr2i50vXv9TyoTV/XP9vc0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfjmej51c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 16:05:20 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 16:05:19 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 16:05:19 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 16:05:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJPxExWAyEJeHd8bcvy5LmI2hJ/6SLyJVtWGxJu98fU=;
 b=gFKvconvptdx2am3fTJTp6F8EL+9HzFQEojD5pfMTyJNvrEzR7s3F7VeW9+j5ONH2Gx2ZE1xI9fK6jPTUEK+WPhP+vcbo8CjPffS6OQzu185nbMBNeGBmAtTf3Kl8sJoIur2vOfXej3+9AzoHvYjTXhX9PJfsmsnBfjxFendMAQ=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3159.namprd15.prod.outlook.com (20.178.207.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 23:05:17 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 23:05:17 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 bpf-next 7/9] selftests/bpf: switch test to new
 attach_perf_event API
Thread-Topic: [PATCH v4 bpf-next 7/9] selftests/bpf: switch test to new
 attach_perf_event API
Thread-Index: AQHVLi3MpoqZJSRY2UOetFbneL1ZZaa2BOsAgABYegCAAAkhAA==
Date:   Mon, 1 Jul 2019 23:05:17 +0000
Message-ID: <6ecaf9a0-6af1-80e9-0ba5-e1faf37e5228@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-8-andriin@fb.com>
 <60e7bee0-0ab9-dacb-0211-6b93c94f603c@fb.com>
 <CAEf4BzbDP=e+jVUBJjCUpPCewxp7-Uwq9L5TuPfUzn9j9MxUeg@mail.gmail.com>
In-Reply-To: <CAEf4BzbDP=e+jVUBJjCUpPCewxp7-Uwq9L5TuPfUzn9j9MxUeg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1001CA0020.namprd10.prod.outlook.com
 (2603:10b6:301:2a::33) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 639de07f-7426-479b-ada8-08d6fe78951b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3159;
x-ms-traffictypediagnostic: BYAPR15MB3159:
x-microsoft-antispam-prvs: <BYAPR15MB3159DA7150277C7221064485D3F90@BYAPR15MB3159.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:283;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(376002)(136003)(396003)(366004)(346002)(199004)(189003)(256004)(31696002)(14444005)(86362001)(5024004)(478600001)(36756003)(66446008)(66556008)(64756008)(66946007)(446003)(316002)(73956011)(7736002)(6246003)(305945005)(8676002)(6916009)(81156014)(81166006)(6512007)(53936002)(6486002)(46003)(71190400001)(6436002)(71200400001)(229853002)(2616005)(476003)(186003)(14454004)(5660300002)(11346002)(486006)(68736007)(54906003)(25786009)(8936002)(53546011)(6506007)(386003)(102836004)(31686004)(4326008)(76176011)(99286004)(66476007)(52116002)(6116002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3159;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CFnKc7HfH1qRIFvnoQ0i9tPvjdDKU5xAh5uVdv+RWdxJLIx6FzhBKUrlUL4wHztWdXoCOTmcBX9Svvo319PQclQLv4BhW9R9MWw1FyMoJIzFdnOaxevLF9BcCmzDQYF3FQUsn6p4AycJumbBlgikNkV3ko7qA91hSWekaOO9t0JuLHqNsLPJou7U4FiLbawLtqmhXCxN7Rvn1R2aoPj4Q1iV5WmpEUon1M4pzFcPDmYdjaKq+nr7o2Cmg8wQm7D6y6Mi44+JgpsJVodUvvqG8ircMgimWtXZTLdX6Q/7uMObUHVxaDJzs2vqdyYa8Hs61qixnbPOo1MZVOQBTe+6kGBE7fwQDhYMBmtbwLILa15ZoF0PPk8L4r8aHgZbVJTkoH38INGCXeC0COR5UsqHIA2P3A3hLNYtyyWZQizG3ws=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76384F639750D9468001F0DCEDD9E88B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 639de07f-7426-479b-ada8-08d6fe78951b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 23:05:17.3871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3159
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010268
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMS8xOSAzOjMyIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIE1vbiwg
SnVsIDEsIDIwMTkgYXQgMTA6MTYgQU0gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3JvdGU6
DQo+Pg0KPj4NCj4+DQo+PiBPbiA2LzI4LzE5IDg6NDkgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90
ZToNCj4+PiBVc2UgbmV3IGJwZl9wcm9ncmFtX19hdHRhY2hfcGVyZl9ldmVudCgpIGluIHRlc3Qg
cHJldmlvdXNseSByZWx5aW5nIG9uDQo+Pj4gZGlyZWN0IGlvY3RsIG1hbmlwdWxhdGlvbnMuDQo+
Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0K
Pj4+IFJldmlld2VkLWJ5OiBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBnb29nbGUuY29tPg0KPj4+
IEFja2VkLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KPj4+IC0tLQ0KPj4+
ICAgIC4uLi9icGYvcHJvZ190ZXN0cy9zdGFja3RyYWNlX2J1aWxkX2lkX25taS5jICB8IDMxICsr
KysrKysrKy0tLS0tLS0tLS0NCj4+PiAgICAxIGZpbGUgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygr
KSwgMTYgZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvc3RhY2t0cmFjZV9idWlsZF9pZF9ubWkuYyBiL3Rvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL3N0YWNrdHJhY2VfYnVpbGRfaWRfbm1p
LmMNCj4+PiBpbmRleCAxYzFhMmY3NWYzZDguLjk1NTdiN2RmYjc4MiAxMDA2NDQNCj4+PiAtLS0g
YS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9zdGFja3RyYWNlX2J1aWxk
X2lkX25taS5jDQo+Pj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVz
dHMvc3RhY2t0cmFjZV9idWlsZF9pZF9ubWkuYw0KPj4+IEBAIC0xNyw2ICsxNyw3IEBAIHN0YXRp
YyBfX3U2NCByZWFkX3BlcmZfbWF4X3NhbXBsZV9mcmVxKHZvaWQpDQo+Pj4gICAgdm9pZCB0ZXN0
X3N0YWNrdHJhY2VfYnVpbGRfaWRfbm1pKHZvaWQpDQo+Pj4gICAgew0KPj4+ICAgICAgICBpbnQg
Y29udHJvbF9tYXBfZmQsIHN0YWNraWRfaG1hcF9mZCwgc3RhY2ttYXBfZmQsIHN0YWNrX2FtYXBf
ZmQ7DQo+Pj4gKyAgICAgY29uc3QgY2hhciAqcHJvZ19uYW1lID0gInRyYWNlcG9pbnQvcmFuZG9t
L3VyYW5kb21fcmVhZCI7DQo+Pj4gICAgICAgIGNvbnN0IGNoYXIgKmZpbGUgPSAiLi90ZXN0X3N0
YWNrdHJhY2VfYnVpbGRfaWQubyI7DQo+Pj4gICAgICAgIGludCBlcnIsIHBtdV9mZCwgcHJvZ19m
ZDsNCj4+PiAgICAgICAgc3RydWN0IHBlcmZfZXZlbnRfYXR0ciBhdHRyID0gew0KPj4+IEBAIC0y
NSw3ICsyNiw5IEBAIHZvaWQgdGVzdF9zdGFja3RyYWNlX2J1aWxkX2lkX25taSh2b2lkKQ0KPj4+
ICAgICAgICAgICAgICAgIC5jb25maWcgPSBQRVJGX0NPVU5UX0hXX0NQVV9DWUNMRVMsDQo+Pj4g
ICAgICAgIH07DQo+Pj4gICAgICAgIF9fdTMyIGtleSwgcHJldmlvdXNfa2V5LCB2YWwsIGR1cmF0
aW9uID0gMDsNCj4+PiArICAgICBzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2c7DQo+Pj4gICAgICAg
IHN0cnVjdCBicGZfb2JqZWN0ICpvYmo7DQo+Pj4gKyAgICAgc3RydWN0IGJwZl9saW5rICpsaW5r
Ow0KPj4+ICAgICAgICBjaGFyIGJ1ZlsyNTZdOw0KPj4+ICAgICAgICBpbnQgaSwgajsNCj4+PiAg
ICAgICAgc3RydWN0IGJwZl9zdGFja19idWlsZF9pZCBpZF9vZmZzW1BFUkZfTUFYX1NUQUNLX0RF
UFRIXTsNCj4+PiBAQCAtMzksNiArNDIsMTAgQEAgdm9pZCB0ZXN0X3N0YWNrdHJhY2VfYnVpbGRf
aWRfbm1pKHZvaWQpDQo+Pj4gICAgICAgIGlmIChDSEVDSyhlcnIsICJwcm9nX2xvYWQiLCAiZXJy
ICVkIGVycm5vICVkXG4iLCBlcnIsIGVycm5vKSkNCj4+PiAgICAgICAgICAgICAgICByZXR1cm47
DQo+Pj4NCj4+PiArICAgICBwcm9nID0gYnBmX29iamVjdF9fZmluZF9wcm9ncmFtX2J5X3RpdGxl
KG9iaiwgcHJvZ19uYW1lKTsNCj4+PiArICAgICBpZiAoQ0hFQ0soIXByb2csICJmaW5kX3Byb2ci
LCAicHJvZyAnJXMnIG5vdCBmb3VuZFxuIiwgcHJvZ19uYW1lKSkNCj4+PiArICAgICAgICAgICAg
IGdvdG8gY2xvc2VfcHJvZzsNCj4+PiArDQo+Pj4gICAgICAgIHBtdV9mZCA9IHN5c2NhbGwoX19O
Ul9wZXJmX2V2ZW50X29wZW4sICZhdHRyLCAtMSAvKiBwaWQgKi8sDQo+Pj4gICAgICAgICAgICAg
ICAgICAgICAgICAgMCAvKiBjcHUgMCAqLywgLTEgLyogZ3JvdXAgaWQgKi8sDQo+Pj4gICAgICAg
ICAgICAgICAgICAgICAgICAgMCAvKiBmbGFncyAqLyk7DQo+Pj4gQEAgLTQ3LDE1ICs1NCwxMiBA
QCB2b2lkIHRlc3Rfc3RhY2t0cmFjZV9idWlsZF9pZF9ubWkodm9pZCkNCj4+PiAgICAgICAgICAg
ICAgICAgIHBtdV9mZCwgZXJybm8pKQ0KPj4+ICAgICAgICAgICAgICAgIGdvdG8gY2xvc2VfcHJv
ZzsNCj4+Pg0KPj4+IC0gICAgIGVyciA9IGlvY3RsKHBtdV9mZCwgUEVSRl9FVkVOVF9JT0NfRU5B
QkxFLCAwKTsNCj4+PiAtICAgICBpZiAoQ0hFQ0soZXJyLCAicGVyZl9ldmVudF9pb2NfZW5hYmxl
IiwgImVyciAlZCBlcnJubyAlZFxuIiwNCj4+PiAtICAgICAgICAgICAgICAgZXJyLCBlcnJubykp
DQo+Pj4gLSAgICAgICAgICAgICBnb3RvIGNsb3NlX3BtdTsNCj4+PiAtDQo+Pj4gLSAgICAgZXJy
ID0gaW9jdGwocG11X2ZkLCBQRVJGX0VWRU5UX0lPQ19TRVRfQlBGLCBwcm9nX2ZkKTsNCj4+PiAt
ICAgICBpZiAoQ0hFQ0soZXJyLCAicGVyZl9ldmVudF9pb2Nfc2V0X2JwZiIsICJlcnIgJWQgZXJy
bm8gJWRcbiIsDQo+Pj4gLSAgICAgICAgICAgICAgIGVyciwgZXJybm8pKQ0KPj4+IC0gICAgICAg
ICAgICAgZ290byBkaXNhYmxlX3BtdTsNCj4+PiArICAgICBsaW5rID0gYnBmX3Byb2dyYW1fX2F0
dGFjaF9wZXJmX2V2ZW50KHByb2csIHBtdV9mZCk7DQo+Pj4gKyAgICAgaWYgKENIRUNLKElTX0VS
UihsaW5rKSwgImF0dGFjaF9wZXJmX2V2ZW50IiwNCj4+PiArICAgICAgICAgICAgICAgImVyciAl
bGRcbiIsIFBUUl9FUlIobGluaykpKSB7DQo+Pj4gKyAgICAgICAgICAgICBjbG9zZShwbXVfZmQp
Ow0KPj4+ICsgICAgICAgICAgICAgZ290byBjbG9zZV9wcm9nOw0KPj4+ICsgICAgIH0NCj4+Pg0K
Pj4+ICAgICAgICAvKiBmaW5kIG1hcCBmZHMgKi8NCj4+PiAgICAgICAgY29udHJvbF9tYXBfZmQg
PSBicGZfZmluZF9tYXAoX19mdW5jX18sIG9iaiwgImNvbnRyb2xfbWFwIik7DQo+Pj4gQEAgLTEz
NCw4ICsxMzgsNyBAQCB2b2lkIHRlc3Rfc3RhY2t0cmFjZV9idWlsZF9pZF9ubWkodm9pZCkNCj4+
PiAgICAgICAgICogdHJ5IGl0IG9uZSBtb3JlIHRpbWUuDQo+Pj4gICAgICAgICAqLw0KPj4+ICAg
ICAgICBpZiAoYnVpbGRfaWRfbWF0Y2hlcyA8IDEgJiYgcmV0cnktLSkgew0KPj4+IC0gICAgICAg
ICAgICAgaW9jdGwocG11X2ZkLCBQRVJGX0VWRU5UX0lPQ19ESVNBQkxFKTsNCj4+PiAtICAgICAg
ICAgICAgIGNsb3NlKHBtdV9mZCk7DQo+Pj4gKyAgICAgICAgICAgICBicGZfbGlua19fZGVzdHJv
eShsaW5rKTsNCj4+PiAgICAgICAgICAgICAgICBicGZfb2JqZWN0X19jbG9zZShvYmopOw0KPj4+
ICAgICAgICAgICAgICAgIHByaW50ZigiJXM6V0FSTjpEaWRuJ3QgZmluZCBleHBlY3RlZCBidWls
ZCBJRCBmcm9tIHRoZSBtYXAsIHJldHJ5aW5nXG4iLA0KPj4+ICAgICAgICAgICAgICAgICAgICAg
ICBfX2Z1bmNfXyk7DQo+Pj4gQEAgLTE1NCwxMSArMTU3LDcgQEAgdm9pZCB0ZXN0X3N0YWNrdHJh
Y2VfYnVpbGRfaWRfbm1pKHZvaWQpDQo+Pj4gICAgICAgICAqLw0KPj4+DQo+Pj4gICAgZGlzYWJs
ZV9wbXU6DQo+Pj4gLSAgICAgaW9jdGwocG11X2ZkLCBQRVJGX0VWRU5UX0lPQ19ESVNBQkxFKTsN
Cj4+PiAtDQo+Pj4gLWNsb3NlX3BtdToNCj4+PiAtICAgICBjbG9zZShwbXVfZmQpOw0KPj4+IC0N
Cj4+PiArICAgICBicGZfbGlua19fZGVzdHJveShsaW5rKTsNCj4+DQo+PiBUaGVyZSBpcyBhIHBy
b2JsZW0gaW4gYnBmX2xpbmtfX2Rlc3Ryb3kobGluaykuDQo+PiBUaGUgImxpbmsgPSBicGZfcHJv
Z3JhbV9fYXR0YWNoX3BlcmZfZXZlbnQocHJvZywgcG11X2ZkKSINCj4+IG1heSBiZSBhbiBlcnJv
ciBwb2ludGVyIChJU19FUlIobGluaykgaXMgdHJ1ZSksIGluIHdoaWNoDQo+PiBjYXNlLCBsaW5r
IHNob3VsZCBiZSByZXNldCB0byBOVUxMIGFuZCB0aGVuIGNhbGwNCj4+IGJwZl9saW5rX19kZXN0
cm95KGxpbmspLiBPdGhlcndpc2UsIHRoZSBwcm9ncmFtIG1heQ0KPj4gc2VnZmF1bHQgb3IgZnVu
Y3Rpb24gaW5jb3JyZWN0bHkuDQo+IA0KPiBOb3QgcmVhbGx5LCBpZiBicGZfcHJvZ3JhbV9fYXR0
YWNoX3BlcmZfZXZlbnQgZmFpbHMgYW5kIElTX0VSUihsaW5rKQ0KPiBpcyB0cnVlLCB3ZSdsbCBj
bG9zZSBwbXVfZmQgZXhwbGljaXRseSBhbmQgYGdvdG8gY2xvc2VfcHJvZ2AgYnlwYXNzaW5nDQo+
IGJwZl9saW5rX19kZXN0cm95LiBgZ290byBkaXNhYmxlX3BtdWAgaXMgZG9uZSBvbmx5IGFmdGVy
IHdlDQo+IHN1Y2Nlc3NmdWxseSBlc3RhYmxpc2hlZCBhdHRhY2hlZCBsaW5rLg0KPiANCj4gU28g
dW5sZXNzIEkgc3RpbGwgbWlzcyBzb21ldGhpbmcsIEkgdGhpbmsgdGhpcyB3aWxsIHdvcmsgcmVs
aWFibHkuDQoNCkRvdWJsZSBjaGVja2VkIGFnYWluLiBZb3UgYXJlIGNvcnJlY3QuIFdlIGRvIG5v
dCBoYXZlIGlzc3VlcyBoZXJlLg0KDQo+IA0KPj4NCj4+PiAgICBjbG9zZV9wcm9nOg0KPj4+ICAg
ICAgICBicGZfb2JqZWN0X19jbG9zZShvYmopOw0KPj4+ICAgIH0NCj4+Pg0K
