Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B0ED9A72
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394580AbfJPTuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:50:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50874 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727148AbfJPTuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:50:50 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9GJoT4w014789;
        Wed, 16 Oct 2019 12:50:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=THZ4/D5fF8Y7BEexVF4vWnAqH4VevRmKmU40GglzCyY=;
 b=lot+HMZj5dmvjYH0MLXVC5OfcRHAqaz1zMbsw4r3yfw/e505XKC0yP82CTQffNezIhSy
 NWEbVdS6NDErVO5sdaUSaPVNICoFa+eWDb+HVKb/kdZiybDEbM/RgTYKNF3CW0ra6LWP
 w0SQ7No03RY7I/G/5NRC4xBxskkcKZYz7Xo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vp3uk1wyr-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Oct 2019 12:50:34 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Oct 2019 12:50:07 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 16 Oct 2019 12:50:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiTsL9NaGkiCMdBzydVVqnm26iqfDpiv5P+JLFMt4eD4mnt+yq3Qf8jZ0ix3yh/G44yi5DmugYUVGem8qiRG81p9lRgy9SNeXs3TOGOrt/flSQiSVbLkOENaGwKekTcxDBdXujudIBRwcq8cD/b/JsMXEIOlfuTpnmbBxPtz8Lj4U6Y9sH4oGBnpfUxZrigJWEWRK0lYuF7JgFQWA0VPuIoDJr9xN7oVmjHDvgxrXB8WJdO6Ig2sA71DXAojtTVp7I0PIrAzZydSREiCY/mnOWeTbKRTEL+lE8bqZ4rr24wqswmjvnrB0gCUQQkl8MqgpEQcX6FzHNoqfgTFmGCgAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THZ4/D5fF8Y7BEexVF4vWnAqH4VevRmKmU40GglzCyY=;
 b=n1o5ILePBONZuMu0PUSleUYfItaVijw7NrFuvNKFT4wBoywp4vN6t7yhDkvDbfJJCXTVR6Gcz5JwEwkMxMdm1SOl1p9UL1gGAh+2IP1KJg9xe03ugVOkdPZ4WMUCIrNbufm5T0rfR+jJTEQt+bwIODiC6fUzakGzAJgNMuXG9Pk4mpcOIXQLDQ3Jwdx3xxNsx1bcuWU7oep5gqv09PnE8ALn4cFt8bBRBmWnf5pk4dy2NEQ66UJ/eI97esFhsq/p9O9kv7pAnrhee9g1zJkvHnHSFnUTqTWzbZO3NLX/0E3uUwwW/EhRHkZJY0vX8oNVbPVKNRQpEO4glKKdVOe3AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THZ4/D5fF8Y7BEexVF4vWnAqH4VevRmKmU40GglzCyY=;
 b=Oy4/1wZPg6Q5/3Llg1uogj5nXFFe719wIRi/cViTg/yPNd3L2p5ZiFb4PuO2tFgReaVa7kuAP6CmBpdTIJvbulOMOtTJfLmQE+1Lp5Yiq9Y8+d9GugZ/5n8u7XOGLhD8+A9xD29lnVkPC2Ugf64J9F1FDoAO0yJpvEQoZrd0sU8=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3320.namprd15.prod.outlook.com (20.179.56.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 19:50:06 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 19:50:06 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 04/11] bpf: add attach_btf_id attribute to
 program load
Thread-Topic: [PATCH v3 bpf-next 04/11] bpf: add attach_btf_id attribute to
 program load
Thread-Index: AQHVg9FeAmsSTYGlhUGcwJQRh2fetKddrOcAgAABQgA=
Date:   Wed, 16 Oct 2019 19:50:06 +0000
Message-ID: <0cf37771-f23e-e165-8c73-8cb5fb3e7f22@fb.com>
References: <20191016032505.2089704-1-ast@kernel.org>
 <20191016032505.2089704-5-ast@kernel.org>
 <CAEf4BzZCw5_GESsziVg9fxj17ti3h-FjBNcZjaSDspwbT=i0fQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZCw5_GESsziVg9fxj17ti3h-FjBNcZjaSDspwbT=i0fQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0012.namprd19.prod.outlook.com
 (2603:10b6:300:d4::22) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::acd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee366333-5edc-46fa-aee2-08d752720acf
x-ms-traffictypediagnostic: BYAPR15MB3320:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33200585EB13FF40B6AEB126D7920@BYAPR15MB3320.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(346002)(136003)(376002)(189003)(199004)(6436002)(99286004)(186003)(81156014)(8936002)(81166006)(229853002)(76176011)(31686004)(6506007)(6486002)(66446008)(6512007)(102836004)(4326008)(6246003)(66946007)(66476007)(8676002)(52116002)(486006)(64756008)(386003)(53546011)(66556008)(25786009)(46003)(476003)(2616005)(5660300002)(446003)(11346002)(6116002)(7736002)(14454004)(71200400001)(305945005)(71190400001)(14444005)(31696002)(478600001)(36756003)(86362001)(54906003)(2906002)(110136005)(316002)(256004)(5024004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3320;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c4aHpizEXYgJxFygl/kM0o1vVOcMZcKj22pyiaJvFZGP2uywLDZj+v+aJh9fhbSGXPOqI/cTy2x9XiQ+X0iu8kHWM09fPCM2CAyVHrMH/p+Ud26WcLDn5TYFoIiabdxsrww/L1022z6jzaDVZ6cy0yqhn2lOY3mMyDvXvwOxHwIsqNreqEkv59gBleY69meXsUH3jGA0wZZcKrWP7vof/jnbbZQjvrXJhn4sbAeyDRDAJd7KtKTl/+1f2lhuuF4wmw7HummELsnP3vtcuUjtom8OstxoCt22/o+qTSQIIW/hZMy8YfqBCDNF0QY1blr5j6S4+9xRIVgdQTqz6K9SWHYtT01ePLJBDrt5HUSGoebXBmZJmz9zzhsEiuoL3JyP2F18VfXrDYsJWffzJgybAWfIsFsMnt17Rqm2ifJivfM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7B5E25EB8A3DA4791B61D89024C7A99@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ee366333-5edc-46fa-aee2-08d752720acf
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 19:50:06.1974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1pbpPBX7Di0LrJ9EhWHse2f3wfkH7rpfXJgM8dSCTHVW0zZwS7aRvn2rN0evsZi/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3320
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_08:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1015 bulkscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTYvMTkgMTI6NDUgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gT24gV2VkLCBP
Y3QgMTYsIDIwMTkgYXQgNDoxNSBBTSBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3Jn
PiB3cm90ZToNCj4+DQo+PiBBZGQgYXR0YWNoX2J0Zl9pZCBhdHRyaWJ1dGUgdG8gcHJvZ19sb2Fk
IGNvbW1hbmQuDQo+PiBJdCdzIHNpbWlsYXIgdG8gZXhpc3RpbmcgZXhwZWN0ZWRfYXR0YWNoX3R5
cGUgYXR0cmlidXRlIHdoaWNoIGlzDQo+PiB1c2VkIGluIHNldmVyYWwgY2dyb3VwIGJhc2VkIHBy
b2dyYW0gdHlwZXMuDQo+PiBVbmZvcnR1bmF0ZWx5IGV4cGVjdGVkX2F0dGFjaF90eXBlIGlzIGln
bm9yZWQgZm9yDQo+PiB0cmFjaW5nIHByb2dyYW1zIGFuZCBjYW5ub3QgYmUgcmV1c2VkIGZvciBu
ZXcgcHVycG9zZS4NCj4+IEhlbmNlIGludHJvZHVjZSBhdHRhY2hfYnRmX2lkIHRvIHZlcmlmeSBi
cGYgcHJvZ3JhbXMgYWdhaW5zdA0KPj4gZ2l2ZW4gaW4ta2VybmVsIEJURiB0eXBlIGlkIGF0IGxv
YWQgdGltZS4NCj4+IEl0IGlzIHN0cmljdGx5IGNoZWNrZWQgdG8gYmUgdmFsaWQgZm9yIHJhd190
cCBwcm9ncmFtcyBvbmx5Lg0KPj4gSW4gYSBsYXRlciBwYXRjaGVzIGl0IHdpbGwgYmVjb21lOg0K
Pj4gYnRmX2lkID09IDAgc2VtYW50aWNzIG9mIGV4aXN0aW5nIHJhd190cCBwcm9ncy4NCj4+IGJ0
ZF9pZCA+IDAgcmF3X3RwIHdpdGggQlRGIGFuZCBhZGRpdGlvbmFsIHR5cGUgc2FmZXR5Lg0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+DQo+
PiBBY2tlZC1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4+IC0tLQ0KPj4g
ICBpbmNsdWRlL2xpbnV4L2JwZi5oICAgICAgICAgICAgfCAgMSArDQo+PiAgIGluY2x1ZGUvdWFw
aS9saW51eC9icGYuaCAgICAgICB8ICAxICsNCj4+ICAga2VybmVsL2JwZi9zeXNjYWxsLmMgICAg
ICAgICAgIHwgMTggKysrKysrKysrKysrKystLS0tDQo+PiAgIHRvb2xzL2luY2x1ZGUvdWFwaS9s
aW51eC9icGYuaCB8ICAxICsNCj4+ICAgNCBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCsp
LCA0IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2JwZi5o
IGIvaW5jbHVkZS9saW51eC9icGYuaA0KPj4gaW5kZXggMjgyZTI4YmY0MWVjLi5mOTE2MzgwNjc1
ZGQgMTAwNjQ0DQo+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L2JwZi5oDQo+PiArKysgYi9pbmNsdWRl
L2xpbnV4L2JwZi5oDQo+PiBAQCAtMzc1LDYgKzM3NSw3IEBAIHN0cnVjdCBicGZfcHJvZ19hdXgg
ew0KPj4gICAgICAgICAgdTMyIGlkOw0KPj4gICAgICAgICAgdTMyIGZ1bmNfY250OyAvKiB1c2Vk
IGJ5IG5vbi1mdW5jIHByb2cgYXMgdGhlIG51bWJlciBvZiBmdW5jIHByb2dzICovDQo+PiAgICAg
ICAgICB1MzIgZnVuY19pZHg7IC8qIDAgZm9yIG5vbi1mdW5jIHByb2csIHRoZSBpbmRleCBpbiBm
dW5jIGFycmF5IGZvciBmdW5jIHByb2cgKi8NCj4+ICsgICAgICAgdTMyIGF0dGFjaF9idGZfaWQ7
IC8qIGluLWtlcm5lbCBCVEYgdHlwZSBpZCB0byBhdHRhY2ggdG8gKi8NCj4+ICAgICAgICAgIGJv
b2wgdmVyaWZpZXJfemV4dDsgLyogWmVybyBleHRlbnNpb25zIGhhcyBiZWVuIGluc2VydGVkIGJ5
IHZlcmlmaWVyLiAqLw0KPj4gICAgICAgICAgYm9vbCBvZmZsb2FkX3JlcXVlc3RlZDsNCj4+ICAg
ICAgICAgIHN0cnVjdCBicGZfcHJvZyAqKmZ1bmM7DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91
YXBpL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+PiBpbmRleCBhNjVj
M2IwYzY5MzUuLjNiYjJjZDFkZTM0MSAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51
eC9icGYuaA0KPj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+PiBAQCAtNDIwLDYg
KzQyMCw3IEBAIHVuaW9uIGJwZl9hdHRyIHsNCj4+ICAgICAgICAgICAgICAgICAgX191MzIgICAg
ICAgICAgIGxpbmVfaW5mb19yZWNfc2l6ZTsgICAgIC8qIHVzZXJzcGFjZSBicGZfbGluZV9pbmZv
IHNpemUgKi8NCj4+ICAgICAgICAgICAgICAgICAgX19hbGlnbmVkX3U2NCAgIGxpbmVfaW5mbzsg
ICAgICAvKiBsaW5lIGluZm8gKi8NCj4+ICAgICAgICAgICAgICAgICAgX191MzIgICAgICAgICAg
IGxpbmVfaW5mb19jbnQ7ICAvKiBudW1iZXIgb2YgYnBmX2xpbmVfaW5mbyByZWNvcmRzICovDQo+
PiArICAgICAgICAgICAgICAgX191MzIgICAgICAgICAgIGF0dGFjaF9idGZfaWQ7ICAvKiBpbi1r
ZXJuZWwgQlRGIHR5cGUgaWQgdG8gYXR0YWNoIHRvICovDQo+PiAgICAgICAgICB9Ow0KPj4NCj4+
ICAgICAgICAgIHN0cnVjdCB7IC8qIGFub255bW91cyBzdHJ1Y3QgdXNlZCBieSBCUEZfT0JKXyog
Y29tbWFuZHMgKi8NCj4+IGRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL3N5c2NhbGwuYyBiL2tlcm5l
bC9icGYvc3lzY2FsbC5jDQo+PiBpbmRleCA4MmVhYmQ0ZTM4YWQuLmI1NmM0ODJjOTc2MCAxMDA2
NDQNCj4+IC0tLSBhL2tlcm5lbC9icGYvc3lzY2FsbC5jDQo+PiArKysgYi9rZXJuZWwvYnBmL3N5
c2NhbGwuYw0KPj4gQEAgLTIzLDYgKzIzLDcgQEANCj4+ICAgI2luY2x1ZGUgPGxpbnV4L3RpbWVr
ZWVwaW5nLmg+DQo+PiAgICNpbmNsdWRlIDxsaW51eC9jdHlwZS5oPg0KPj4gICAjaW5jbHVkZSA8
bGludXgvbm9zcGVjLmg+DQo+PiArI2luY2x1ZGUgPHVhcGkvbGludXgvYnRmLmg+DQo+Pg0KPj4g
ICAjZGVmaW5lIElTX0ZEX0FSUkFZKG1hcCkgKChtYXApLT5tYXBfdHlwZSA9PSBCUEZfTUFQX1RZ
UEVfUFJPR19BUlJBWSB8fCBcDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKG1hcCkt
Pm1hcF90eXBlID09IEJQRl9NQVBfVFlQRV9QRVJGX0VWRU5UX0FSUkFZIHx8IFwNCj4+IEBAIC0x
NTY1LDggKzE1NjYsOSBAQCBzdGF0aWMgdm9pZCBicGZfcHJvZ19sb2FkX2ZpeHVwX2F0dGFjaF90
eXBlKHVuaW9uIGJwZl9hdHRyICphdHRyKQ0KPj4gICB9DQo+Pg0KPj4gICBzdGF0aWMgaW50DQo+
PiAtYnBmX3Byb2dfbG9hZF9jaGVja19hdHRhY2hfdHlwZShlbnVtIGJwZl9wcm9nX3R5cGUgcHJv
Z190eXBlLA0KPj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBlbnVtIGJwZl9hdHRh
Y2hfdHlwZSBleHBlY3RlZF9hdHRhY2hfdHlwZSkNCj4+ICticGZfcHJvZ19sb2FkX2NoZWNrX2F0
dGFjaChlbnVtIGJwZl9wcm9nX3R5cGUgcHJvZ190eXBlLA0KPj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgZW51bSBicGZfYXR0YWNoX3R5cGUgZXhwZWN0ZWRfYXR0YWNoX3R5cGUsDQo+PiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICB1MzIgYnRmX2lkKQ0KPj4gICB7DQo+PiAgICAgICAg
ICBzd2l0Y2ggKHByb2dfdHlwZSkgew0KPj4gICAgICAgICAgY2FzZSBCUEZfUFJPR19UWVBFX0NH
Uk9VUF9TT0NLOg0KPj4gQEAgLTE2MDgsMTMgKzE2MTAsMTkgQEAgYnBmX3Byb2dfbG9hZF9jaGVj
a19hdHRhY2hfdHlwZShlbnVtIGJwZl9wcm9nX3R5cGUgcHJvZ190eXBlLA0KPj4gICAgICAgICAg
ICAgICAgICBkZWZhdWx0Og0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUlO
VkFMOw0KPj4gICAgICAgICAgICAgICAgICB9DQo+PiArICAgICAgIGNhc2UgQlBGX1BST0dfVFlQ
RV9SQVdfVFJBQ0VQT0lOVDoNCj4+ICsgICAgICAgICAgICAgICBpZiAoYnRmX2lkID4gQlRGX01B
WF9UWVBFKQ0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+PiAr
ICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+PiAgICAgICAgICBkZWZhdWx0Og0KPj4gKyAgICAg
ICAgICAgICAgIGlmIChidGZfaWQpDQo+PiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4g
LUVJTlZBTDsNCj4gDQo+IHRoaXMgaXMgbWlub3IgaXNzdWUsIGZlZWwgZnJlZSB0byBmaXggaW4g
YSBmb2xsb3cgdXAgcGF0Y2gsIGJ1dCB0aGlzDQo+IGNoZWNrIHNob3VsZCBiZSBkb25lIGZvciBh
bGwgY2FzZXMgYnV0IEJQRl9QUk9HX1RZUEVfUkFXX1RSQUNFUE9JTlQsDQo+IG5vdCBqdXN0IGZv
ciBkZWZhdWx0IChkZWZhdWx0IHdpbGwgaWdub3JlIGEgYnVuY2ggb2YgY2dyb3VwIGF0dGFjaA0K
PiB0eXBlcykuDQoNCnJpZ2h0LiBnb29kIHBvaW50LiB3aWxsIGZpeCBpbiBmb2xsb3cgdXAgaWYg
dGhlcmUgYXJlIG5vIGlzc3VlcyBpbiB0aGUgDQpyZXN0IG9mIHBhdGNoZXMuDQo=
