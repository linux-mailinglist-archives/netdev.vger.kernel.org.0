Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B2B5C1D3
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfGARQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:16:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28134 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727094AbfGARQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:16:24 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61HD1US011593;
        Mon, 1 Jul 2019 10:16:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VS8jFXy/3+adHuBHdqrnwRj7qwDNp0xlqmYeMtag0xc=;
 b=AUmLwUauMm5KXmDsyZIkPjq7j7DFiSoVrA5/9/lzvePDBOm19Tu2OrIzN36nvDyNhhNX
 zUYTjGcI2no01OY3BoUoAk6FIwbCOZHAUM8xPZGKn+MlHReFcc4i2bvvxLDibQVStix8
 5hQ/NgcIEYWA/CEdYmOKjiX0Dns4ml47Hq0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfm9erk6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Jul 2019 10:16:03 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 1 Jul 2019 10:16:02 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 1 Jul 2019 10:16:02 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 10:16:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VS8jFXy/3+adHuBHdqrnwRj7qwDNp0xlqmYeMtag0xc=;
 b=hMvstMiwfW9lW6+7krErOrcPgflJTFK0uiJOT5W4WAdp78tW4maXQIq19I3I2fFvIfeXUj46pGXk8po8c64cUExh9rb7DqGl587BjjfZv1ITo4P4+CjITF+S7IM92jYy39/QmMwYlw9LnehUUlshXyansi11LpvxRwuq+/noyAQ=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3013.namprd15.prod.outlook.com (20.178.238.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 17:16:00 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 17:16:00 +0000
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
Subject: Re: [PATCH v4 bpf-next 7/9] selftests/bpf: switch test to new
 attach_perf_event API
Thread-Topic: [PATCH v4 bpf-next 7/9] selftests/bpf: switch test to new
 attach_perf_event API
Thread-Index: AQHVLi3MpoqZJSRY2UOetFbneL1ZZaa2BOsA
Date:   Mon, 1 Jul 2019 17:16:00 +0000
Message-ID: <60e7bee0-0ab9-dacb-0211-6b93c94f603c@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-8-andriin@fb.com>
In-Reply-To: <20190629034906.1209916-8-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:300:117::25) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71fb619b-6dfe-46f0-1c37-08d6fe47c9e2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3013;
x-ms-traffictypediagnostic: BYAPR15MB3013:
x-microsoft-antispam-prvs: <BYAPR15MB3013DE156858F739D749A209D3F90@BYAPR15MB3013.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:216;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(396003)(346002)(39860400002)(199004)(189003)(478600001)(5660300002)(25786009)(6636002)(68736007)(6246003)(6436002)(6486002)(66946007)(73956011)(66446008)(53936002)(66476007)(2201001)(6512007)(64756008)(110136005)(316002)(66556008)(71200400001)(229853002)(14454004)(71190400001)(102836004)(256004)(11346002)(14444005)(5024004)(76176011)(7736002)(46003)(86362001)(31696002)(486006)(6506007)(476003)(2616005)(53546011)(305945005)(186003)(446003)(8936002)(6116002)(81166006)(81156014)(99286004)(2906002)(8676002)(52116002)(2501003)(31686004)(386003)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3013;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: G64DF17MOIompMmeH/PjFob8m2A776Q4KXXMfyXJXkmzFMMUD4Z1j1tsDYXI6a0vJxKH6b75XDsL/V6r3NPFxSIWb9VysuQ+FYI7qViNpTONYBlBoYgdY4QpI4IGjA2Edzg4+fsIqUXrjrtinsNTE8Bcokjo/xwE6jIO11SjES9szD3vTnRkXKFF2IgaIwBgVT6iGhnG5sK16nZA89Isv6s91L82qUcDCiN8zlrM/vjWymFQ8GZBTtuzrWKRs4WEgiK7tsgAuaSBB7G8AN7hKQai3LY5KqTT31tPKj9xoYFTa+u9qRtFfxeyxpAAcYB8Hf+6og5HhEu71jktNJBGvudE422zGfQRiCgxChQQl9JLoX0cTb5qEUgQZ0GJF92mb7cFMTbZ/Erhj2RpdOuzqZy0BkE4je95+dlggsArm8Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38A2C0DB429B1A4B9A609A7CD5034DD4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 71fb619b-6dfe-46f0-1c37-08d6fe47c9e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 17:16:00.5624
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

DQoNCk9uIDYvMjgvMTkgODo0OSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBVc2UgbmV3
IGJwZl9wcm9ncmFtX19hdHRhY2hfcGVyZl9ldmVudCgpIGluIHRlc3QgcHJldmlvdXNseSByZWx5
aW5nIG9uDQo+IGRpcmVjdCBpb2N0bCBtYW5pcHVsYXRpb25zLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFN0YW5p
c2xhdiBGb21pY2hldiA8c2RmQGdvb2dsZS5jb20+DQo+IEFja2VkLWJ5OiBTb25nIExpdSA8c29u
Z2xpdWJyYXZpbmdAZmIuY29tPg0KPiAtLS0NCj4gICAuLi4vYnBmL3Byb2dfdGVzdHMvc3RhY2t0
cmFjZV9idWlsZF9pZF9ubWkuYyAgfCAzMSArKysrKysrKystLS0tLS0tLS0tDQo+ICAgMSBmaWxl
IGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL3N0YWNrdHJhY2Vf
YnVpbGRfaWRfbm1pLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9z
dGFja3RyYWNlX2J1aWxkX2lkX25taS5jDQo+IGluZGV4IDFjMWEyZjc1ZjNkOC4uOTU1N2I3ZGZi
NzgyIDEwMDY0NA0KPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0
cy9zdGFja3RyYWNlX2J1aWxkX2lkX25taS5jDQo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2JwZi9wcm9nX3Rlc3RzL3N0YWNrdHJhY2VfYnVpbGRfaWRfbm1pLmMNCj4gQEAgLTE3LDYg
KzE3LDcgQEAgc3RhdGljIF9fdTY0IHJlYWRfcGVyZl9tYXhfc2FtcGxlX2ZyZXEodm9pZCkNCj4g
ICB2b2lkIHRlc3Rfc3RhY2t0cmFjZV9idWlsZF9pZF9ubWkodm9pZCkNCj4gICB7DQo+ICAgCWlu
dCBjb250cm9sX21hcF9mZCwgc3RhY2tpZF9obWFwX2ZkLCBzdGFja21hcF9mZCwgc3RhY2tfYW1h
cF9mZDsNCj4gKwljb25zdCBjaGFyICpwcm9nX25hbWUgPSAidHJhY2Vwb2ludC9yYW5kb20vdXJh
bmRvbV9yZWFkIjsNCj4gICAJY29uc3QgY2hhciAqZmlsZSA9ICIuL3Rlc3Rfc3RhY2t0cmFjZV9i
dWlsZF9pZC5vIjsNCj4gICAJaW50IGVyciwgcG11X2ZkLCBwcm9nX2ZkOw0KPiAgIAlzdHJ1Y3Qg
cGVyZl9ldmVudF9hdHRyIGF0dHIgPSB7DQo+IEBAIC0yNSw3ICsyNiw5IEBAIHZvaWQgdGVzdF9z
dGFja3RyYWNlX2J1aWxkX2lkX25taSh2b2lkKQ0KPiAgIAkJLmNvbmZpZyA9IFBFUkZfQ09VTlRf
SFdfQ1BVX0NZQ0xFUywNCj4gICAJfTsNCj4gICAJX191MzIga2V5LCBwcmV2aW91c19rZXksIHZh
bCwgZHVyYXRpb24gPSAwOw0KPiArCXN0cnVjdCBicGZfcHJvZ3JhbSAqcHJvZzsNCj4gICAJc3Ry
dWN0IGJwZl9vYmplY3QgKm9iajsNCj4gKwlzdHJ1Y3QgYnBmX2xpbmsgKmxpbms7DQo+ICAgCWNo
YXIgYnVmWzI1Nl07DQo+ICAgCWludCBpLCBqOw0KPiAgIAlzdHJ1Y3QgYnBmX3N0YWNrX2J1aWxk
X2lkIGlkX29mZnNbUEVSRl9NQVhfU1RBQ0tfREVQVEhdOw0KPiBAQCAtMzksNiArNDIsMTAgQEAg
dm9pZCB0ZXN0X3N0YWNrdHJhY2VfYnVpbGRfaWRfbm1pKHZvaWQpDQo+ICAgCWlmIChDSEVDSyhl
cnIsICJwcm9nX2xvYWQiLCAiZXJyICVkIGVycm5vICVkXG4iLCBlcnIsIGVycm5vKSkNCj4gICAJ
CXJldHVybjsNCj4gICANCj4gKwlwcm9nID0gYnBmX29iamVjdF9fZmluZF9wcm9ncmFtX2J5X3Rp
dGxlKG9iaiwgcHJvZ19uYW1lKTsNCj4gKwlpZiAoQ0hFQ0soIXByb2csICJmaW5kX3Byb2ciLCAi
cHJvZyAnJXMnIG5vdCBmb3VuZFxuIiwgcHJvZ19uYW1lKSkNCj4gKwkJZ290byBjbG9zZV9wcm9n
Ow0KPiArDQo+ICAgCXBtdV9mZCA9IHN5c2NhbGwoX19OUl9wZXJmX2V2ZW50X29wZW4sICZhdHRy
LCAtMSAvKiBwaWQgKi8sDQo+ICAgCQkJIDAgLyogY3B1IDAgKi8sIC0xIC8qIGdyb3VwIGlkICov
LA0KPiAgIAkJCSAwIC8qIGZsYWdzICovKTsNCj4gQEAgLTQ3LDE1ICs1NCwxMiBAQCB2b2lkIHRl
c3Rfc3RhY2t0cmFjZV9idWlsZF9pZF9ubWkodm9pZCkNCj4gICAJCSAgcG11X2ZkLCBlcnJubykp
DQo+ICAgCQlnb3RvIGNsb3NlX3Byb2c7DQo+ICAgDQo+IC0JZXJyID0gaW9jdGwocG11X2ZkLCBQ
RVJGX0VWRU5UX0lPQ19FTkFCTEUsIDApOw0KPiAtCWlmIChDSEVDSyhlcnIsICJwZXJmX2V2ZW50
X2lvY19lbmFibGUiLCAiZXJyICVkIGVycm5vICVkXG4iLA0KPiAtCQkgIGVyciwgZXJybm8pKQ0K
PiAtCQlnb3RvIGNsb3NlX3BtdTsNCj4gLQ0KPiAtCWVyciA9IGlvY3RsKHBtdV9mZCwgUEVSRl9F
VkVOVF9JT0NfU0VUX0JQRiwgcHJvZ19mZCk7DQo+IC0JaWYgKENIRUNLKGVyciwgInBlcmZfZXZl
bnRfaW9jX3NldF9icGYiLCAiZXJyICVkIGVycm5vICVkXG4iLA0KPiAtCQkgIGVyciwgZXJybm8p
KQ0KPiAtCQlnb3RvIGRpc2FibGVfcG11Ow0KPiArCWxpbmsgPSBicGZfcHJvZ3JhbV9fYXR0YWNo
X3BlcmZfZXZlbnQocHJvZywgcG11X2ZkKTsNCj4gKwlpZiAoQ0hFQ0soSVNfRVJSKGxpbmspLCAi
YXR0YWNoX3BlcmZfZXZlbnQiLA0KPiArCQkgICJlcnIgJWxkXG4iLCBQVFJfRVJSKGxpbmspKSkg
ew0KPiArCQljbG9zZShwbXVfZmQpOw0KPiArCQlnb3RvIGNsb3NlX3Byb2c7DQo+ICsJfQ0KPiAg
IA0KPiAgIAkvKiBmaW5kIG1hcCBmZHMgKi8NCj4gICAJY29udHJvbF9tYXBfZmQgPSBicGZfZmlu
ZF9tYXAoX19mdW5jX18sIG9iaiwgImNvbnRyb2xfbWFwIik7DQo+IEBAIC0xMzQsOCArMTM4LDcg
QEAgdm9pZCB0ZXN0X3N0YWNrdHJhY2VfYnVpbGRfaWRfbm1pKHZvaWQpDQo+ICAgCSAqIHRyeSBp
dCBvbmUgbW9yZSB0aW1lLg0KPiAgIAkgKi8NCj4gICAJaWYgKGJ1aWxkX2lkX21hdGNoZXMgPCAx
ICYmIHJldHJ5LS0pIHsNCj4gLQkJaW9jdGwocG11X2ZkLCBQRVJGX0VWRU5UX0lPQ19ESVNBQkxF
KTsNCj4gLQkJY2xvc2UocG11X2ZkKTsNCj4gKwkJYnBmX2xpbmtfX2Rlc3Ryb3kobGluayk7DQo+
ICAgCQlicGZfb2JqZWN0X19jbG9zZShvYmopOw0KPiAgIAkJcHJpbnRmKCIlczpXQVJOOkRpZG4n
dCBmaW5kIGV4cGVjdGVkIGJ1aWxkIElEIGZyb20gdGhlIG1hcCwgcmV0cnlpbmdcbiIsDQo+ICAg
CQkgICAgICAgX19mdW5jX18pOw0KPiBAQCAtMTU0LDExICsxNTcsNyBAQCB2b2lkIHRlc3Rfc3Rh
Y2t0cmFjZV9idWlsZF9pZF9ubWkodm9pZCkNCj4gICAJICovDQo+ICAgDQo+ICAgZGlzYWJsZV9w
bXU6DQo+IC0JaW9jdGwocG11X2ZkLCBQRVJGX0VWRU5UX0lPQ19ESVNBQkxFKTsNCj4gLQ0KPiAt
Y2xvc2VfcG11Og0KPiAtCWNsb3NlKHBtdV9mZCk7DQo+IC0NCj4gKwlicGZfbGlua19fZGVzdHJv
eShsaW5rKTsNCg0KVGhlcmUgaXMgYSBwcm9ibGVtIGluIGJwZl9saW5rX19kZXN0cm95KGxpbmsp
Lg0KVGhlICJsaW5rID0gYnBmX3Byb2dyYW1fX2F0dGFjaF9wZXJmX2V2ZW50KHByb2csIHBtdV9m
ZCkiDQptYXkgYmUgYW4gZXJyb3IgcG9pbnRlciAoSVNfRVJSKGxpbmspIGlzIHRydWUpLCBpbiB3
aGljaA0KY2FzZSwgbGluayBzaG91bGQgYmUgcmVzZXQgdG8gTlVMTCBhbmQgdGhlbiBjYWxsIA0K
YnBmX2xpbmtfX2Rlc3Ryb3kobGluaykuIE90aGVyd2lzZSwgdGhlIHByb2dyYW0gbWF5DQpzZWdm
YXVsdCBvciBmdW5jdGlvbiBpbmNvcnJlY3RseS4NCg0KPiAgIGNsb3NlX3Byb2c6DQo+ICAgCWJw
Zl9vYmplY3RfX2Nsb3NlKG9iaik7DQo+ICAgfQ0KPiANCg==
