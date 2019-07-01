Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4835C1C5
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfGARLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:11:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3952 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbfGARLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:11:25 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61Gm6VV016543;
        Mon, 1 Jul 2019 10:11:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5ywD9/cac1tJP/ZUMlVJH6D0RKeAd/MYAQ9IGdcoaSc=;
 b=cz/RvKdYEy1S2Xb2mswuJB8+4VYw/I4wV/HM/CnSbH9jmS5C7lor+mocjlJTLZxvvt3V
 ZEiH+zWCzKg7Z/W6KsUi6SrmsKXOYTGl3JbZkPePAtiLKTGTQVE3mUJdEmUOgAtSi4RZ
 mJu3gg0k7WjY0FaWsHCuPi9XePA3jfpd20E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfhjq962g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 10:11:05 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 10:11:03 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 10:11:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ywD9/cac1tJP/ZUMlVJH6D0RKeAd/MYAQ9IGdcoaSc=;
 b=WfMOVkW+YDpy9Sfw21+axFW5r8Jl9t9HdE9lmhKF8iY6WFpdgIQ7tL94X8mZakiM0/1367QbBXzz4N41+bUjXCTTNWjnZ/Mj7q3z/KBJHja1e7CTUXp29NfQgLL3qa2Jnxl7ycGUeVfp+//iIgtTJDM82i1Ob03zm2rCylaOklo=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2453.namprd15.prod.outlook.com (52.135.198.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 17:10:58 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 17:10:58 +0000
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
Subject: Re: [PATCH v4 bpf-next 5/9] libbpf: add tracepoint attach API
Thread-Topic: [PATCH v4 bpf-next 5/9] libbpf: add tracepoint attach API
Thread-Index: AQHVLi2s64v4eAwEvEiXuQ/eHnKTQ6a2A4gA
Date:   Mon, 1 Jul 2019 17:10:58 +0000
Message-ID: <c0948bd2-fbc2-6c27-3fe9-1c1d1e07ea39@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-6-andriin@fb.com>
In-Reply-To: <20190629034906.1209916-6-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR06CA0034.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::47) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2abb57f-bf2d-4457-9099-08d6fe4715f5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2453;
x-ms-traffictypediagnostic: BYAPR15MB2453:
x-microsoft-antispam-prvs: <BYAPR15MB2453A9953152A0ED11FE46F2D3F90@BYAPR15MB2453.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:185;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(396003)(376002)(39860400002)(189003)(199004)(52116002)(76176011)(8676002)(7736002)(8936002)(6506007)(229853002)(2501003)(14454004)(386003)(81156014)(31696002)(81166006)(305945005)(186003)(86362001)(102836004)(53546011)(2616005)(256004)(476003)(5024004)(14444005)(6636002)(446003)(11346002)(486006)(25786009)(2906002)(53936002)(71190400001)(99286004)(71200400001)(6116002)(31686004)(316002)(6512007)(5660300002)(68736007)(46003)(110136005)(6246003)(478600001)(36756003)(2201001)(66476007)(66556008)(64756008)(66446008)(73956011)(66946007)(6436002)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2453;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uhPbM3ojEhNT9V4XuhqEtKu87cHYhw/kxOH5cTFqC2RHa3QA1A5SiNiCRLOc1Ip+jqwtKounEvqooxFnDUqfQSUEIFwa2e5IKS95QTkw/n5Cx5fW4JXGf+WRurgndfPD/azxN4KW00bopjrqo0R8/eEgMvdgKzW4sj8+i9TdLyFs1zNJxPmxCKjNTB6EUDabERzGdAv5/ziNWAoZe6INoSo9zzax3tDU+UPV3qogYCSOvqz+VtwSCNbasUTeI4Gtf/L2rx9nwh1SlxQs73iuHAc226tUmR7Q85w4I8e9P1kyKlHHsUt9RfihyJ99m1d29LLZ268sBFFxrGDviuodmXhh7wrLLH9fHkzjADKH73+dWIJCdZyofOjI0NOA6W7u3yOC778lHXdHS884vQK18JS8QL/QWd8nPXALcW3zGfI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8338CA3719CAA4C9D76D23D7EB37D0A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d2abb57f-bf2d-4457-9099-08d6fe4715f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 17:10:58.6570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2453
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjgvMTkgODo0OSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBBbGxvdyBh
dHRhY2hpbmcgQlBGIHByb2dyYW1zIHRvIGtlcm5lbCB0cmFjZXBvaW50IEJQRiBob29rcyBzcGVj
aWZpZWQgYnkNCj4gY2F0ZWdvcnkgYW5kIG5hbWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRy
aWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KPiBBY2tlZC1ieTogU29uZyBMaXUgPHNvbmds
aXVicmF2aW5nQGZiLmNvbT4NCj4gLS0tDQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYuYyAgIHwg
NzkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIHRvb2xzL2xp
Yi9icGYvbGliYnBmLmggICB8ICA0ICsrDQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYubWFwIHwg
IDEgKw0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgODQgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+
IGluZGV4IDJmNzllOTU2M2RiOS4uOGFkNGY5MTVkZjM4IDEwMDY0NA0KPiAtLS0gYS90b29scy9s
aWIvYnBmL2xpYmJwZi5jDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4gQEAgLTQx
ODQsNiArNDE4NCw4NSBAQCBzdHJ1Y3QgYnBmX2xpbmsgKmJwZl9wcm9ncmFtX19hdHRhY2hfdXBy
b2JlKHN0cnVjdCBicGZfcHJvZ3JhbSAqcHJvZywNCj4gICAJcmV0dXJuIGxpbms7DQo+ICAgfQ0K
PiAgIA0KPiArc3RhdGljIGludCBkZXRlcm1pbmVfdHJhY2Vwb2ludF9pZChjb25zdCBjaGFyICp0
cF9jYXRlZ29yeSwNCj4gKwkJCQkgICBjb25zdCBjaGFyICp0cF9uYW1lKQ0KPiArew0KPiArCWNo
YXIgZmlsZVtQQVRIX01BWF07DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCXJldCA9IHNucHJpbnRm
KGZpbGUsIHNpemVvZihmaWxlKSwNCj4gKwkJICAgICAgICIvc3lzL2tlcm5lbC9kZWJ1Zy90cmFj
aW5nL2V2ZW50cy8lcy8lcy9pZCIsDQo+ICsJCSAgICAgICB0cF9jYXRlZ29yeSwgdHBfbmFtZSk7
DQo+ICsJaWYgKHJldCA8IDApDQo+ICsJCXJldHVybiAtZXJybm87DQo+ICsJaWYgKHJldCA+PSBz
aXplb2YoZmlsZSkpIHsNCj4gKwkJcHJfZGVidWcoInRyYWNlcG9pbnQgJXMvJXMgcGF0aCBpcyB0
b28gbG9uZ1xuIiwNCj4gKwkJCSB0cF9jYXRlZ29yeSwgdHBfbmFtZSk7DQo+ICsJCXJldHVybiAt
RTJCSUc7DQo+ICsJfQ0KPiArCXJldHVybiBwYXJzZV92YWx1ZV9mcm9tX2ZpbGUoZmlsZSwgIiVk
XG4iKTsNCj4gK30NCj4gKw0KPiArc3RhdGljIGludCBwZXJmX2V2ZW50X29wZW5fdHJhY2Vwb2lu
dChjb25zdCBjaGFyICp0cF9jYXRlZ29yeSwNCj4gKwkJCQkgICAgICBjb25zdCBjaGFyICp0cF9u
YW1lKQ0KPiArew0KPiArCXN0cnVjdCBwZXJmX2V2ZW50X2F0dHIgYXR0ciA9IHt9Ow0KPiArCWNo
YXIgZXJybXNnW1NUUkVSUl9CVUZTSVpFXTsNCj4gKwlpbnQgdHBfaWQsIHBmZCwgZXJyOw0KPiAr
DQo+ICsJdHBfaWQgPSBkZXRlcm1pbmVfdHJhY2Vwb2ludF9pZCh0cF9jYXRlZ29yeSwgdHBfbmFt
ZSk7DQo+ICsJaWYgKHRwX2lkIDwgMCkgew0KPiArCQlwcl93YXJuaW5nKCJmYWlsZWQgdG8gZGV0
ZXJtaW5lIHRyYWNlcG9pbnQgJyVzLyVzJyBwZXJmIElEOiAlc1xuIiwNCg0Kbml0OiAicGVyZiBJ
RCIgaXMgbm90IGFjY3VyYXRlLiBNYXliZSAiZXZlbnQgSUQiIG9yICJwZXJmIGV2ZW50IElEIj8N
Cg0KPiArCQkJICAgdHBfY2F0ZWdvcnksIHRwX25hbWUsDQo+ICsJCQkgICBsaWJicGZfc3RyZXJy
b3Jfcih0cF9pZCwgZXJybXNnLCBzaXplb2YoZXJybXNnKSkpOw0KPiArCQlyZXR1cm4gdHBfaWQ7
DQo+ICsJfQ0KPiArDQo+ICsJYXR0ci50eXBlID0gUEVSRl9UWVBFX1RSQUNFUE9JTlQ7DQo+ICsJ
YXR0ci5zaXplID0gc2l6ZW9mKGF0dHIpOw0KPiArCWF0dHIuY29uZmlnID0gdHBfaWQ7DQo+ICsN
Cj4gKwlwZmQgPSBzeXNjYWxsKF9fTlJfcGVyZl9ldmVudF9vcGVuLCAmYXR0ciwgLTEgLyogcGlk
ICovLCAwIC8qIGNwdSAqLywNCj4gKwkJICAgICAgLTEgLyogZ3JvdXBfZmQgKi8sIFBFUkZfRkxB
R19GRF9DTE9FWEVDKTsNCj4gKwlpZiAocGZkIDwgMCkgew0KPiArCQllcnIgPSAtZXJybm87DQo+
ICsJCXByX3dhcm5pbmcoInRyYWNlcG9pbnQgJyVzLyVzJyBwZXJmX2V2ZW50X29wZW4oKSBmYWls
ZWQ6ICVzXG4iLA0KPiArCQkJICAgdHBfY2F0ZWdvcnksIHRwX25hbWUsDQo+ICsJCQkgICBsaWJi
cGZfc3RyZXJyb3JfcihlcnIsIGVycm1zZywgc2l6ZW9mKGVycm1zZykpKTsNCj4gKwkJcmV0dXJu
IGVycjsNCj4gKwl9DQo+ICsJcmV0dXJuIHBmZDsNCj4gK30NCj4gKw0KPiArc3RydWN0IGJwZl9s
aW5rICpicGZfcHJvZ3JhbV9fYXR0YWNoX3RyYWNlcG9pbnQoc3RydWN0IGJwZl9wcm9ncmFtICpw
cm9nLA0KPiArCQkJCQkJY29uc3QgY2hhciAqdHBfY2F0ZWdvcnksDQo+ICsJCQkJCQljb25zdCBj
aGFyICp0cF9uYW1lKQ0KPiArew0KPiArCWNoYXIgZXJybXNnW1NUUkVSUl9CVUZTSVpFXTsNCj4g
KwlzdHJ1Y3QgYnBmX2xpbmsgKmxpbms7DQo+ICsJaW50IHBmZCwgZXJyOw0KPiArDQo+ICsJcGZk
ID0gcGVyZl9ldmVudF9vcGVuX3RyYWNlcG9pbnQodHBfY2F0ZWdvcnksIHRwX25hbWUpOw0KPiAr
CWlmIChwZmQgPCAwKSB7DQo+ICsJCXByX3dhcm5pbmcoInByb2dyYW0gJyVzJzogZmFpbGVkIHRv
IGNyZWF0ZSB0cmFjZXBvaW50ICclcy8lcycgcGVyZiBldmVudDogJXNcbiIsDQo+ICsJCQkgICBi
cGZfcHJvZ3JhbV9fdGl0bGUocHJvZywgZmFsc2UpLA0KPiArCQkJICAgdHBfY2F0ZWdvcnksIHRw
X25hbWUsDQo+ICsJCQkgICBsaWJicGZfc3RyZXJyb3JfcihwZmQsIGVycm1zZywgc2l6ZW9mKGVy
cm1zZykpKTsNCj4gKwkJcmV0dXJuIEVSUl9QVFIocGZkKTsNCj4gKwl9DQo+ICsJbGluayA9IGJw
Zl9wcm9ncmFtX19hdHRhY2hfcGVyZl9ldmVudChwcm9nLCBwZmQpOw0KPiArCWlmIChJU19FUlIo
bGluaykpIHsNCj4gKwkJY2xvc2UocGZkKTsNCj4gKwkJZXJyID0gUFRSX0VSUihsaW5rKTsNCj4g
KwkJcHJfd2FybmluZygicHJvZ3JhbSAnJXMnOiBmYWlsZWQgdG8gYXR0YWNoIHRvIHRyYWNlcG9p
bnQgJyVzLyVzJzogJXNcbiIsDQo+ICsJCQkgICBicGZfcHJvZ3JhbV9fdGl0bGUocHJvZywgZmFs
c2UpLA0KPiArCQkJICAgdHBfY2F0ZWdvcnksIHRwX25hbWUsDQo+ICsJCQkgICBsaWJicGZfc3Ry
ZXJyb3JfcihlcnIsIGVycm1zZywgc2l6ZW9mKGVycm1zZykpKTsNCj4gKwkJcmV0dXJuIGxpbms7
DQo+ICsJfQ0KPiArCXJldHVybiBsaW5rOw0KPiArfQ0KPiArDQo+ICAgZW51bSBicGZfcGVyZl9l
dmVudF9yZXQNCj4gICBicGZfcGVyZl9ldmVudF9yZWFkX3NpbXBsZSh2b2lkICptbWFwX21lbSwg
c2l6ZV90IG1tYXBfc2l6ZSwgc2l6ZV90IHBhZ2Vfc2l6ZSwNCj4gICAJCQkgICB2b2lkICoqY29w
eV9tZW0sIHNpemVfdCAqY29weV9zaXplLA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9s
aWJicGYuaCBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmgNCj4gaW5kZXggYmQ3NjdjYzExOTY3Li42
MDYxMWY0YjRlMWQgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmgNCj4gKysr
IGIvdG9vbHMvbGliL2JwZi9saWJicGYuaA0KPiBAQCAtMTc4LDYgKzE3OCwxMCBAQCBMSUJCUEZf
QVBJIHN0cnVjdCBicGZfbGluayAqDQo+ICAgYnBmX3Byb2dyYW1fX2F0dGFjaF91cHJvYmUoc3Ry
dWN0IGJwZl9wcm9ncmFtICpwcm9nLCBib29sIHJldHByb2JlLA0KPiAgIAkJCSAgIHBpZF90IHBp
ZCwgY29uc3QgY2hhciAqYmluYXJ5X3BhdGgsDQo+ICAgCQkJICAgc2l6ZV90IGZ1bmNfb2Zmc2V0
KTsNCj4gK0xJQkJQRl9BUEkgc3RydWN0IGJwZl9saW5rICoNCj4gK2JwZl9wcm9ncmFtX19hdHRh
Y2hfdHJhY2Vwb2ludChzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csDQo+ICsJCQkgICAgICAgY29u
c3QgY2hhciAqdHBfY2F0ZWdvcnksDQo+ICsJCQkgICAgICAgY29uc3QgY2hhciAqdHBfbmFtZSk7
DQo+ICAgDQo+ICAgc3RydWN0IGJwZl9pbnNuOw0KPiAgIA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMv
bGliL2JwZi9saWJicGYubWFwIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+IGluZGV4IDU3
YTQwZmI2MDcxOC4uM2M2MThiNzVlZjY1IDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBmL2xp
YmJwZi5tYXANCj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+IEBAIC0xNzEsNiAr
MTcxLDcgQEAgTElCQlBGXzAuMC40IHsNCj4gICAJCWJwZl9vYmplY3RfX2xvYWRfeGF0dHI7DQo+
ICAgCQlicGZfcHJvZ3JhbV9fYXR0YWNoX2twcm9iZTsNCj4gICAJCWJwZl9wcm9ncmFtX19hdHRh
Y2hfcGVyZl9ldmVudDsNCj4gKwkJYnBmX3Byb2dyYW1fX2F0dGFjaF90cmFjZXBvaW50Ow0KPiAg
IAkJYnBmX3Byb2dyYW1fX2F0dGFjaF91cHJvYmU7DQo+ICAgCQlidGZfZHVtcF9fZHVtcF90eXBl
Ow0KPiAgIAkJYnRmX2R1bXBfX2ZyZWU7DQo+IA0K
