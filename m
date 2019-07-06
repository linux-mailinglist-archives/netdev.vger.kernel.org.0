Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B76256120B
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 17:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfGFP5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 11:57:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbfGFP5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 11:57:00 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x66Fpqtc015349;
        Sat, 6 Jul 2019 08:56:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=oXjPGrVezvW64S5e7OuBVNNo/ALkR4Jg0tCAGl9fFc0=;
 b=jCWZYfUPvdAygZdt2VkpCWz45NKXJCDAvYynq0ZFSm+ec9XjYzng3eMo+Di5Nf6FhZUm
 2eiGKZ+LFP3Oaaj+zpK//6pR8k7UAGUvkVvPfoFGLiRxnMz+isrosCztLYYe+EwamS8j
 HZvPMgBZ/W6M8o69T0t++V8ZMKaF0jlp5g0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tjqacs3cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 06 Jul 2019 08:56:38 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 6 Jul 2019 08:56:37 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 6 Jul 2019 08:56:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXjPGrVezvW64S5e7OuBVNNo/ALkR4Jg0tCAGl9fFc0=;
 b=POz0MrgTqqfOSlCSqgRCvhLRZ82Ukix6lWM6IaxtQkOpI3TinMWWHlUX3+GZB4xBYqAxGkoCMehi/uoWOyxmiUtz2roOpyso10Cb7SQjYXim+vxE5psQQFoeASkz5OdQHBU6W1RvVOuhJ3fHRRJNEh4Jzcn46UOMm5k8AdSs8ac=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3413.namprd15.prod.outlook.com (20.179.59.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.17; Sat, 6 Jul 2019 15:56:31 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2052.019; Sat, 6 Jul 2019
 15:56:31 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, Kernel Team <Kernel-team@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH v5 bpf-next 1/5] libbpf: add perf buffer API
Thread-Topic: [PATCH v5 bpf-next 1/5] libbpf: add perf buffer API
Thread-Index: AQHVM7RDY67jeJ/hpEu/lVUn/Au/Aqa9E8mAgAADagCAAKggAA==
Date:   Sat, 6 Jul 2019 15:56:31 +0000
Message-ID: <5019eba1-5da2-22b7-9bad-19e770dda2f0@fb.com>
References: <20190706043522.1559005-1-andriin@fb.com>
 <20190706043522.1559005-2-andriin@fb.com>
 <e0e2f6d2-016c-70bd-a0c6-5c147d5b7aca@fb.com>
 <CAEf4BzZYAN5t+6Kkt+W4ee13PL7dR4FG8P71dFnk_CHWqMmHPQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZYAN5t+6Kkt+W4ee13PL7dR4FG8P71dFnk_CHWqMmHPQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0034.namprd11.prod.outlook.com
 (2603:10b6:300:115::20) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:c7d4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56456e03-a87e-4abf-8419-08d7022a8349
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3413;
x-ms-traffictypediagnostic: BYAPR15MB3413:
x-microsoft-antispam-prvs: <BYAPR15MB3413D4AA4EA4352921AFD798D3F40@BYAPR15MB3413.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00909363D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(136003)(39860400002)(376002)(346002)(366004)(396003)(199004)(189003)(2616005)(14454004)(52116002)(476003)(54906003)(486006)(478600001)(36756003)(99286004)(53546011)(6506007)(4326008)(386003)(76176011)(31696002)(5660300002)(186003)(305945005)(7736002)(102836004)(6116002)(86362001)(6916009)(53936002)(71190400001)(71200400001)(6512007)(31686004)(66446008)(2906002)(64756008)(66556008)(8936002)(66476007)(66946007)(73956011)(25786009)(68736007)(14444005)(446003)(46003)(316002)(11346002)(256004)(6436002)(81166006)(6486002)(6246003)(81156014)(229853002)(8676002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3413;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WH95KxlDZ5TyFxGqBgg8xFhskaznIWeN1jcIjy9/BB+4wxURLlw7YpZ23a74rPmxIlkz3oTk2X9eufWtGJhX7jfV5fTtoiaGUeqYn4ljULBJWCPSq2UzA+VoP6XWxWv8HTVgNLr5NkzWX3+g+Ogc/LONfesoWkdVpllV5SVFXOAsWg+VU3WayBnFpVMG091DNNBJdabecqnPWDUk4h6I4+H5SOBLEPVhY2TIUBZiaPl3Ue5oBKh6YggDeiEgOSCq1MIthUZI5v8phs7Cbs5jjxg5qhWYr/nxKWBdSGMBFPoWUtVbQ9pizdihJLRN9jFtoKcVy48hpRpNAhrwN+GmdtQv4Hvtz1chq1WDpiByZE93IJqEwVfLHONSvs8a2BOMIsXedUMb8JKVOZgWamr3sCMwsL4zI8U2+9sVNSUqKZc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EC8B17F4721A54A94EC01C308764F9A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 56456e03-a87e-4abf-8419-08d7022a8349
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2019 15:56:31.3728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3413
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-06_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060209
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvNS8xOSAxMDo1NCBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBGcmks
IEp1bCA1LCAyMDE5IGF0IDEwOjQyIFBNIFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+IHdyb3Rl
Og0KPj4NCj4+DQo+Pg0KPj4gT24gNy81LzE5IDk6MzUgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90
ZToNCj4+PiBCUEZfTUFQX1RZUEVfUEVSRl9FVkVOVF9BUlJBWSBtYXAgaXMgb2Z0ZW4gdXNlZCB0
byBzZW5kIGRhdGEgZnJvbSBCUEYgcHJvZ3JhbQ0KPj4+IHRvIHVzZXIgc3BhY2UgZm9yIGFkZGl0
aW9uYWwgcHJvY2Vzc2luZy4gbGliYnBmIGFscmVhZHkgaGFzIHZlcnkgbG93LWxldmVsIEFQSQ0K
Pj4+IHRvIHJlYWQgc2luZ2xlIENQVSBwZXJmIGJ1ZmZlciwgYnBmX3BlcmZfZXZlbnRfcmVhZF9z
aW1wbGUoKSwgYnV0IGl0J3MgaGFyZCB0bw0KPj4+IHVzZSBhbmQgcmVxdWlyZXMgYSBsb3Qgb2Yg
Y29kZSB0byBzZXQgZXZlcnl0aGluZyB1cC4gVGhpcyBwYXRjaCBhZGRzDQo+Pj4gcGVyZl9idWZm
ZXIgYWJzdHJhY3Rpb24gb24gdG9wIG9mIGl0LCBhYnN0cmFjdGluZyBzZXR0aW5nIHVwIGFuZCBw
b2xsaW5nDQo+Pj4gcGVyLUNQVSBsb2dpYyBpbnRvIHNpbXBsZSBhbmQgY29udmVuaWVudCBBUEks
IHNpbWlsYXIgdG8gd2hhdCBCQ0MgcHJvdmlkZXMuDQo+Pj4NCj4+PiBwZXJmX2J1ZmZlcl9fbmV3
KCkgc2V0cyB1cCBwZXItQ1BVIHJpbmcgYnVmZmVycyBhbmQgdXBkYXRlcyBjb3JyZXNwb25kaW5n
IEJQRg0KPj4+IG1hcCBlbnRyaWVzLiBJdCBhY2NlcHRzIHR3byB1c2VyLXByb3ZpZGVkIGNhbGxi
YWNrczogb25lIGZvciBoYW5kbGluZyByYXcNCj4+PiBzYW1wbGVzIGFuZCBvbmUgZm9yIGdldCBu
b3RpZmljYXRpb25zIG9mIGxvc3Qgc2FtcGxlcyBkdWUgdG8gYnVmZmVyIG92ZXJmbG93Lg0KPj4+
DQo+Pj4gcGVyZl9idWZmZXJfX25ld19yYXcoKSBpcyBzaW1pbGFyLCBidXQgcHJvdmlkZXMgbW9y
ZSBjb250cm9sIG92ZXIgaG93DQo+Pj4gcGVyZiBldmVudHMgYXJlIHNldCB1cCAoYnkgYWNjZXB0
aW5nIHVzZXItcHJvdmlkZWQgcGVyZl9ldmVudF9hdHRyKSwgaG93DQo+Pj4gdGhleSBhcmUgaGFu
ZGxlZCAocGVyZl9ldmVudF9oZWFkZXIgcG9pbnRlciBpcyBwYXNzZWQgZGlyZWN0bHkgdG8NCj4+
PiB1c2VyLXByb3ZpZGVkIGNhbGxiYWNrKSwgYW5kIG9uIHdoaWNoIENQVXMgcmluZyBidWZmZXJz
IGFyZSBjcmVhdGVkDQo+Pj4gKGl0J3MgcG9zc2libGUgdG8gcHJvdmlkZSBhIGxpc3Qgb2YgQ1BV
cyBhbmQgY29ycmVzcG9uZGluZyBtYXAga2V5cyB0bw0KPj4+IHVwZGF0ZSkuIFRoaXMgQVBJIGFs
bG93cyBhZHZhbmNlZCB1c2VycyBmdWxsZXIgY29udHJvbC4NCj4+Pg0KPj4+IHBlcmZfYnVmZmVy
X19wb2xsKCkgaXMgdXNlZCB0byBmZXRjaCByaW5nIGJ1ZmZlciBkYXRhIGFjcm9zcyBhbGwgQ1BV
cywNCj4+PiB1dGlsaXppbmcgZXBvbGwgaW5zdGFuY2UuDQo+Pj4NCj4+PiBwZXJmX2J1ZmZlcl9f
ZnJlZSgpIGRvZXMgY29ycmVzcG9uZGluZyBjbGVhbiB1cCBhbmQgdW5zZXRzIEZEcyBmcm9tIEJQ
RiBtYXAuDQo+Pj4NCj4+PiBBbGwgQVBJcyBhcmUgbm90IHRocmVhZC1zYWZlLiBVc2VyIHNob3Vs
ZCBlbnN1cmUgcHJvcGVyIGxvY2tpbmcvY29vcmRpbmF0aW9uIGlmDQo+Pj4gdXNlZCBpbiBtdWx0
aS10aHJlYWRlZCBzZXQgdXAuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlp
a28gPGFuZHJpaW5AZmIuY29tPg0KPj4+IC0tLQ0KPj4+ICAgIHRvb2xzL2xpYi9icGYvbGliYnBm
LmMgICB8IDM2NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+PiAg
ICB0b29scy9saWIvYnBmL2xpYmJwZi5oICAgfCAgNDkgKysrKysrDQo+Pj4gICAgdG9vbHMvbGli
L2JwZi9saWJicGYubWFwIHwgICA0ICsNCj4+PiAgICAzIGZpbGVzIGNoYW5nZWQsIDQxOSBpbnNl
cnRpb25zKCspDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYuYyBi
L3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4+PiBpbmRleCAyYTA4ZWIxMDYyMjEuLjcyMTQ5ZDY4
YjhjMSAxMDA2NDQNCj4+PiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+Pj4gKysrIGIv
dG9vbHMvbGliL2JwZi9saWJicGYuYw0KPj4+IEBAIC0zMiw3ICszMiw5IEBADQo+Pj4gICAgI2lu
Y2x1ZGUgPGxpbnV4L2xpbWl0cy5oPg0KPj4+ICAgICNpbmNsdWRlIDxsaW51eC9wZXJmX2V2ZW50
Lmg+DQo+Pj4gICAgI2luY2x1ZGUgPGxpbnV4L3JpbmdfYnVmZmVyLmg+DQo+Pj4gKyNpbmNsdWRl
IDxzeXMvZXBvbGwuaD4NCj4+PiAgICAjaW5jbHVkZSA8c3lzL2lvY3RsLmg+DQo+Pj4gKyNpbmNs
dWRlIDxzeXMvbW1hbi5oPg0KPj4+ICAgICNpbmNsdWRlIDxzeXMvc3RhdC5oPg0KPj4+ICAgICNp
bmNsdWRlIDxzeXMvdHlwZXMuaD4NCj4+PiAgICAjaW5jbHVkZSA8c3lzL3Zmcy5oPg0KPj4+IEBA
IC00MzU0LDYgKzQzNTYsMzcwIEBAIGJwZl9wZXJmX2V2ZW50X3JlYWRfc2ltcGxlKHZvaWQgKm1t
YXBfbWVtLCBzaXplX3QgbW1hcF9zaXplLCBzaXplX3QgcGFnZV9zaXplLA0KPj4+ICAgICAgICBy
ZXR1cm4gcmV0Ow0KPj4+ICAgIH0NCj4+Pg0KPj4+ICtzdHJ1Y3QgcGVyZl9idWZmZXI7DQo+Pj4g
Kw0KPj4+ICtzdHJ1Y3QgcGVyZl9idWZmZXJfcGFyYW1zIHsNCj4+PiArICAgICBzdHJ1Y3QgcGVy
Zl9ldmVudF9hdHRyICphdHRyOw0KPj4+ICsgICAgIC8qIGlmIGV2ZW50X2NiIGlzIHNwZWNpZmll
ZCwgaXQgdGFrZXMgcHJlY2VuZGVuY2UgKi8NCj4+PiArICAgICBwZXJmX2J1ZmZlcl9ldmVudF9m
biBldmVudF9jYjsNCj4+PiArICAgICAvKiBzYW1wbGVfY2IgYW5kIGxvc3RfY2IgYXJlIGhpZ2hl
ci1sZXZlbCBjb21tb24tY2FzZSBjYWxsYmFja3MgKi8NCj4+PiArICAgICBwZXJmX2J1ZmZlcl9z
YW1wbGVfZm4gc2FtcGxlX2NiOw0KPj4+ICsgICAgIHBlcmZfYnVmZmVyX2xvc3RfZm4gbG9zdF9j
YjsNCj4+PiArICAgICB2b2lkICpjdHg7DQo+Pj4gKyAgICAgaW50IGNwdV9jbnQ7DQo+Pj4gKyAg
ICAgaW50ICpjcHVzOw0KPj4gWy4uLl0NCj4+PiArDQo+Pj4gK2ludCBwZXJmX2J1ZmZlcl9fcG9s
bChzdHJ1Y3QgcGVyZl9idWZmZXIgKnBiLCBpbnQgdGltZW91dF9tcykNCj4+PiArew0KPj4+ICsg
ICAgIGludCBjbnQsIGVycjsNCj4+PiArDQo+Pj4gKyAgICAgY250ID0gZXBvbGxfd2FpdChwYi0+
ZXBvbGxfZmQsIHBiLT5ldmVudHMsIHBiLT5jcHVfY250LCB0aW1lb3V0X21zKTsNCj4+PiArICAg
ICBmb3IgKGludCBpID0gMDsgaSA8IGNudDsgaSsrKSB7DQo+Pg0KPj4gRmluZCBvbmUgY29tcGls
YXRpb24gZXJyb3IgaGVyZS4NCj4+DQo+PiBsaWJicGYuYzogSW4gZnVuY3Rpb24g4oCYcGVyZl9i
dWZmZXJfX3BvbGzigJk6DQo+PiBsaWJicGYuYzo0NzI4OjI6IGVycm9yOiDigJhmb3LigJkgbG9v
cCBpbml0aWFsIGRlY2xhcmF0aW9ucyBhcmUgb25seSBhbGxvd2VkDQo+PiBpbiBDOTkgbW9kZQ0K
Pj4gICAgIGZvciAoaW50IGkgPSAwOyBpIDwgY250OyBpKyspIHsNCj4+ICAgICBeDQo+Pg0KPiAN
Cj4gQWguLi4gRml4aW5nLCB0aGFua3MhLiBIb3cgZGlkIHlvdSBjb21waWxlPyBtYWtlIC1DIHRv
b2xzL2xpYi9icGYNCj4gZG9lc24ndCBzaG93IHRoaXMsIHNob3VsZCB3ZSB1cGRhdGUgbGliYnBm
IE1ha2VmaWxlIHRvIGNhdGNoIHN0dWZmDQo+IGxpa2UgdGhpcz8NCg0KSSBkaWQgbm90IG1ha2Ug
YW55IGNvZGUgY2hhbmdlcy4gTXkgY29tcGlsZXIgaXMgZ2NjIDQuOC41LiBpdCBpcyANCnBvc3Np
YmxlIHRoYXQgb2xkIGNvbXBpbGVyIGxlc3MgdG9sZXJhbnQuDQoNCj4+PiArICAgICAgICAgICAg
IHN0cnVjdCBwZXJmX2NwdV9idWYgKmNwdV9idWYgPSBwYi0+ZXZlbnRzW2ldLmRhdGEucHRyOw0K
Pj4+ICsNCj4+PiArICAgICAgICAgICAgIGVyciA9IHBlcmZfYnVmZmVyX19wcm9jZXNzX3JlY29y
ZHMocGIsIGNwdV9idWYpOw0KPj4+ICsgICAgICAgICAgICAgaWYgKGVycikgew0KPj4+ICsgICAg
ICAgICAgICAgICAgICAgICBwcl93YXJuaW5nKCJlcnJvciB3aGlsZSBwcm9jZXNzaW5nIHJlY29y
ZHM6ICVkXG4iLCBlcnIpOw0KPj4+ICsgICAgICAgICAgICAgICAgICAgICByZXR1cm4gZXJyOw0K
Pj4+ICsgICAgICAgICAgICAgfQ0KPj4+ICsgICAgIH0NCj4+PiArICAgICByZXR1cm4gY250IDwg
MCA/IC1lcnJubyA6IGNudDsNCj4+PiArfQ0KPj4+ICsNCj4+PiAgICBzdHJ1Y3QgYnBmX3Byb2df
aW5mb19hcnJheV9kZXNjIHsNCj4+PiAgICAgICAgaW50ICAgICBhcnJheV9vZmZzZXQ7ICAgLyog
ZS5nLiBvZmZzZXQgb2Ygaml0ZWRfcHJvZ19pbnNucyAqLw0KPj4+ICAgICAgICBpbnQgICAgIGNv
dW50X29mZnNldDsgICAvKiBlLmcuIG9mZnNldCBvZiBqaXRlZF9wcm9nX2xlbiAqLw0KPj4gWy4u
Ll0NCg==
