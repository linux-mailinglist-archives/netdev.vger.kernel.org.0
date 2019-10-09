Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77281D0581
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 04:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbfJIC1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 22:27:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728019AbfJIC1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 22:27:16 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x992Modh019320;
        Tue, 8 Oct 2019 19:27:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ZpB8tQqJ+H+D1RolyKbsoup5x3GbgYaafuVKOArfMDE=;
 b=T9CVk+BRwbUUEuWeX8ls/G8GpiTX1ScmzbYrgM07GcDWlfjJJ2XGAHcwcIpCYcZ6KrUB
 EanUbh/ErH8G0+7gnY2+u4eCvy0X5/adHbOH4V+kO2JEiMwU+Y1WqxnC7SUgivgoYX/n
 04syMJHpag4ys1mWynedka5ISbqyaS9PoPE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgpq9n3n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Oct 2019 19:27:00 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 8 Oct 2019 19:26:59 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 8 Oct 2019 19:26:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAZRZLGDn925D2Foy6S2hS03iXw/66vaT2l/ce2aaM6D8BsyKW9H+bUtKcW3kuYRxhTPDkq/1LstTyNzmf3zBGmn3eKs1wa/tqXvMx27OWnhJcVAtHoZPxeLl8rV1xRyXdi1RQQDBV4vpqgT1TSxjl26vnHQdoUseG3LX/IelHIU1X1vxZra5HwaTFqgHjxcr5geejmlsZ7vXQvfFX/woTaJtTQiWqwp9m+3B1eK0LMu30BG7UOKcfh+UXBhBg993bH8Eln3XSq+KX9zDCGGwMBia3c0DJo3JGpKAiRwSIdQwnvLihz47f9kSuEwaTjquBOe37iNh4h4f44ES5xL8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpB8tQqJ+H+D1RolyKbsoup5x3GbgYaafuVKOArfMDE=;
 b=Zz2OomjuMQv9FtVOEMH1jgkdKxsREXlL/yw5GMuWxAz1tj4alVVKnetJ+aTYXTXbiF0/O+dKZPRwfK2OjLw9snqkNxMNJ7Fzj8cR2czLoxx+RDYBLh5SeIuRkghMhoDqYtLVBhX3V3wG4inEw63kMh93pZ8pbPxIkRzTrBXgNgw9gLUNujn9LhMv3+7OnkoFxJBAimSd1hzzMjT4xxGtHZAldR/HmHBH2NOHvdOpIVKH5viWbLqyZoQ+8756q4LILgNTgL9f4ObV4wiVwl0EiXAGkoE3roAk/RoiirdTceHsp4xA5/n2CwqI+7GJeGmBJqfzohv3A31Kj5LZjUXy7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpB8tQqJ+H+D1RolyKbsoup5x3GbgYaafuVKOArfMDE=;
 b=Z6qCVcdH5Ml6yVmyTql6qdtSeFTHdOJe/YeK20R3F3IWeW408QFmMqSRH7LDN7hHuI2HS+enUlroNpwLVGdxJVIYtw7c5bhcDR2nkZGNK/S1GrIA4VExo8gYj9PvwLlAg0ahwfuFov1q4JLj1XdMRHVFJQ6DkoArWJBy2c6WIQY=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3159.namprd15.prod.outlook.com (20.178.207.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 02:26:58 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 02:26:58 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 04/10] libbpf: auto-detect btf_id of
 raw_tracepoint
Thread-Topic: [PATCH bpf-next 04/10] libbpf: auto-detect btf_id of
 raw_tracepoint
Thread-Index: AQHVezpDyW71lnwiq0GdZMxN+wGyKqdP2yqAgAHAaoA=
Date:   Wed, 9 Oct 2019 02:26:58 +0000
Message-ID: <0ea6bf09-12ca-e23a-0535-abc62ee7e914@fb.com>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-5-ast@kernel.org>
 <CAEf4BzZxHyBoX9stW7uapZ06xd26N_zZcghytkQAUM1ss5sN6A@mail.gmail.com>
In-Reply-To: <CAEf4BzZxHyBoX9stW7uapZ06xd26N_zZcghytkQAUM1ss5sN6A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:300:129::13) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::851e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 382d74c8-091d-4829-ba56-08d74c6028ec
x-ms-traffictypediagnostic: BYAPR15MB3159:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3159013084EC3EFCAB0C2775D7950@BYAPR15MB3159.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(396003)(366004)(346002)(199004)(189003)(52116002)(54906003)(46003)(6512007)(99286004)(110136005)(6436002)(25786009)(305945005)(316002)(7736002)(102836004)(53546011)(76176011)(386003)(6506007)(8936002)(86362001)(229853002)(71200400001)(71190400001)(81156014)(14454004)(8676002)(81166006)(31686004)(446003)(14444005)(4326008)(6246003)(256004)(478600001)(476003)(66476007)(5024004)(31696002)(186003)(66446008)(66946007)(2616005)(6116002)(64756008)(486006)(11346002)(6486002)(2906002)(36756003)(66556008)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3159;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F5BOrzci0m9JwLRtM3vFc2z5+6csEiSa1WlGCEouiJigN2HuJG/lrNQBhYqPdHQmtgjlxGvd4FTYz4JE477BhHLRpKWHGJEYv5iZ97hvFNLtdfidABBdNL3XJS90zSFPp0xxcbRubaim2zUYkh8h58dnNQH1hA8QSIRKSuKA2J1c9oqrp7Av1fFtrz74zCcf1rmG1v7VFQnm/1UP0U+WQgXsPHRvSTo1zgDLTa48Ty7E8VLMQXmAgrElIeKEJZm9XLsjMRYjSKWa04mrfRBy8KFiDCnsgSIKftPPAtNCKeg1LFB0U7xOgLPw+90HdyA+YoFtpLDFqwPMyERIE4YArC1NSsWTd/TRuLls/kLX+QTpjugJmUJmXbYyWebYWq7bgJr7acz+YlREE6NX1yryBnlIYA4HRS5rdFpxAkLgZF8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8441FE764390544B9BB6429DE71C274@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 382d74c8-091d-4829-ba56-08d74c6028ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 02:26:58.5987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tuEKR0aqLU0wiIjLkJe00PV3G5XmSIT9asNHgLr0Z7Q35R0S5dD7bE80VrBreJJq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3159
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_01:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1011 adultscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090020
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvNy8xOSA0OjQxIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIEZyaSwgT2N0
IDQsIDIwMTkgYXQgMTA6MDQgUE0gQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4g
d3JvdGU6DQo+Pg0KPj4gRm9yIHJhdyB0cmFjZXBvaW50IHByb2dyYW0gdHlwZXMgbGliYnBmIHdp
bGwgdHJ5IHRvIGZpbmQNCj4+IGJ0Zl9pZCBvZiByYXcgdHJhY2Vwb2ludCBpbiB2bWxpbnV4J3Mg
QlRGLg0KPj4gSXQncyBhIHJlc3BvbnNpYmxpdHkgb2YgYnBmIHByb2dyYW0gYXV0aG9yIHRvIGFu
bm90YXRlIHRoZSBwcm9ncmFtDQo+PiB3aXRoIFNFQygicmF3X3RyYWNlcG9pbnQvbmFtZSIpIHdo
ZXJlICJuYW1lIiBpcyBhIHZhbGlkIHJhdyB0cmFjZXBvaW50Lg0KPiANCj4gQXMgYW4gYXNpZGUs
IEkndmUgYmVlbiB0aGlua2luZyBhYm91dCBhbGxvd2luZyB0byBzcGVjaWZ5ICJyYXdfdHAvIg0K
PiBhbmQgInRwLyIgaW4gc2VjdGlvbiBuYW1lIGFzIGFuICJhbGlhcyIgZm9yICJyYXdfdHJhY2Vw
b2ludC8iIGFuZA0KPiAidHJhY2Vwb2ludC8iLCByZXNwZWN0aXZlbHkuIEFueSBvYmplY3Rpb25z
Pw0KDQptYWtlIHNlbnNlLg0KDQo+PiBJZiAibmFtZSIgaXMgaW5kZWVkIGEgdmFsaWQgcmF3IHRy
YWNlcG9pbnQgdGhlbiBpbi1rZXJuZWwgQlRGDQo+PiB3aWxsIGhhdmUgImJ0Zl90cmFjZV8jI25h
bWUiIHR5cGVkZWYgdGhhdCBwb2ludHMgdG8gZnVuY3Rpb24NCj4+IHByb3RvdHlwZSBvZiB0aGF0
IHJhdyB0cmFjZXBvaW50LiBCVEYgZGVzY3JpcHRpb24gY2FwdHVyZXMNCj4+IGV4YWN0IGFyZ3Vt
ZW50IHRoZSBrZXJuZWwgQyBjb2RlIGlzIHBhc3NpbmcgaW50byByYXcgdHJhY2Vwb2ludC4NCj4+
IFRoZSBrZXJuZWwgdmVyaWZpZXIgd2lsbCBjaGVjayB0aGUgdHlwZXMgd2hpbGUgbG9hZGluZyBi
cGYgcHJvZ3JhbS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFz
dEBrZXJuZWwub3JnPg0KPj4gLS0tDQo+PiAgIHRvb2xzL2xpYi9icGYvbGliYnBmLmMgfCAxNiAr
KysrKysrKysrKysrKysrDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspDQo+
Pg0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMgYi90b29scy9saWIvYnBm
L2xpYmJwZi5jDQo+PiBpbmRleCBlMDI3NjUyMDE3MWIuLjBlNmY3YjQxYzUyMSAxMDA2NDQNCj4+
IC0tLSBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGli
YnBmLmMNCj4+IEBAIC00NTkxLDYgKzQ1OTEsMjIgQEAgaW50IGxpYmJwZl9wcm9nX3R5cGVfYnlf
bmFtZShjb25zdCBjaGFyICpuYW1lLCBlbnVtIGJwZl9wcm9nX3R5cGUgKnByb2dfdHlwZSwNCj4+
ICAgICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4+ICAgICAgICAgICAgICAgICAg
KnByb2dfdHlwZSA9IHNlY3Rpb25fbmFtZXNbaV0ucHJvZ190eXBlOw0KPj4gICAgICAgICAgICAg
ICAgICAqZXhwZWN0ZWRfYXR0YWNoX3R5cGUgPSBzZWN0aW9uX25hbWVzW2ldLmV4cGVjdGVkX2F0
dGFjaF90eXBlOw0KPj4gKyAgICAgICAgICAgICAgIGlmICgqcHJvZ190eXBlID09IEJQRl9QUk9H
X1RZUEVfUkFXX1RSQUNFUE9JTlQpIHsNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHN0cnVj
dCBidGYgKmJ0ZiA9IGJwZl9jb3JlX2ZpbmRfa2VybmVsX2J0ZigpOw0KPj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgY2hhciByYXdfdHBfYnRmX25hbWVbMTI4XSA9ICJidGZfdHJhY2VfIjsNCj4+
ICsgICAgICAgICAgICAgICAgICAgICAgIGludCByZXQ7DQo+PiArDQo+PiArICAgICAgICAgICAg
ICAgICAgICAgICBpZiAoSVNfRVJSKGJ0ZikpDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIC8qIGxhY2sgb2Yga2VybmVsIEJURiBpcyBub3QgYSBmYWlsdXJlICovDQo+PiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAwOw0KPj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgLyogYXBwZW5kICJidGZfdHJhY2VfIiBwcmVmaXggcGVyIGtlcm5lbCBjb252ZW50
aW9uICovDQo+PiArICAgICAgICAgICAgICAgICAgICAgICBzdHJjcHkocmF3X3RwX2J0Zl9uYW1l
ICsgc2l6ZW9mKCJidGZfdHJhY2VfIikgLSAxLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIG5hbWUgKyBzZWN0aW9uX25hbWVzW2ldLmxlbik7DQo+IA0KPiBidWZmZXIgb3ZlcmZs
b3cgaGVyZT8gdXNlIHN0cm5jYXQoKSBpbnN0ZWFkPw0KDQoxMjggaXMga3N5bV9uYW1lIGFuZCBk
dWUgdG8gdHAgY29uc3RydWN0aW9uIHdpdGggb3RoZXIgcHJlZml4ZXMsDQpJIHRoaW5rLCBpdCBj
YW5ub3Qgb3ZlcmZsb3csIGJ1dCB0aGF0J3MgYSBnb29kIG5pdC4gRml4ZWQgaXQuDQo=
