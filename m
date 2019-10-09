Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B978AD170B
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbfJIRqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:46:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46794 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730503AbfJIRqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 13:46:34 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x99HS0xt012059;
        Wed, 9 Oct 2019 10:46:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qrPEMbARNeDldiC1mzQOOffdMblVzIxsjzRzEDeqHpY=;
 b=q7L/fe4GNxv/kThwJ8IXOM1Djtu7149OjryWosQ0ZMCyBr+WiHwYydbbyAYvcLP6UV9n
 grHw96lwqU6mtMPdwDSLX1ju6vMuidlIQVIG79xGBqpot/vgTRo8mOy3Z5G7MnOGtYfu
 pYgwcl175jNaSTIxgZRa4+m05i6PG6PqqEs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhfsdshau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Oct 2019 10:46:19 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 9 Oct 2019 10:46:18 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 9 Oct 2019 10:46:18 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 9 Oct 2019 10:46:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MoVaDvmlDWkGES9ZttRmrnnhSRwDIoluYpxtK1cOmvtbteRyjqVQSSm9R33NIOOXf0YuN7au7h/3T2E8n61z3hNKZQl/5EiH25G2H7sV91DT7QFpSzecGp1h74f96qTYrk0OvVyiv/mBGINbgNqh1tmu4AWB4//Rj1cE2b9M4GPkbGVStuj7GDkbL1Tc8lNAKHahW5Iih40DzEHAFgteRFw3VALF+pF+uqWHDIQ/YJtA+lVrwjlW0Rxrf+AkNe7oKl1kxFDr0J2llKsiyAbaYdTAYQFIffW1j7tFLFdnQMd9OyLrGl9qEA0pYbPQbNYuMVtPKWIkU2au3LhBS03yVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrPEMbARNeDldiC1mzQOOffdMblVzIxsjzRzEDeqHpY=;
 b=WIJQePC+DviTCu8D+TXFI+u2h4opgoNrs5tyCOKQ3qsjAs2/Jc7UAZhpt99z3MvPzjglH4+luOIJCh4g7E9KTCbJ/FTFNj0ddT89E7VC7qQuIR2ZWsYZ1hzrQN8hkY8PALNR26cvv+IGgOXoy94wUmXozCjW+WZ3+8F48kj9bAx8JenPd4kS+QMVRe/NTHAdY7pNiM2rvJp4tStI22KpPDFQ5VWNXukZ4ZnG6P7W89UEuD+uaQwJ55OXKnwH3zCqAMY+Y8w2PtJ+7kERJt4pHm4xVPguY/VRElWBvcpXZqnafBu2jhmneOg3s7UtrABTl3ANqzJLfFE6HtKdKftG7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrPEMbARNeDldiC1mzQOOffdMblVzIxsjzRzEDeqHpY=;
 b=ef20qnEe2tMbx77BuaBp+ZTTanNXuZp/2J3Cj+ghM2K0K7Mn1JKfeREUvR45JZo2Zrnrn9KLyIA4Xuq3Lpelx+398WCbi2Eu4OfKCiJKDOr1yymW9sfmDbDxCh6Fnc4apa/1a8iR2J3K1VMMm0EiooY5CyT+dLxTyEaXUWxQwA4=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3126.namprd15.prod.outlook.com (20.178.239.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 17:46:16 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 17:46:16 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 07/10] bpf: add support for BTF pointers to x86
 JIT
Thread-Topic: [PATCH bpf-next 07/10] bpf: add support for BTF pointers to x86
 JIT
Thread-Index: AQHVezpOv0LD+gVjOkeZwjfCf+3isadSmkUAgAACKIA=
Date:   Wed, 9 Oct 2019 17:46:16 +0000
Message-ID: <c08a5ce5-cc82-97ae-40cd-8f8bdd8a5668@fb.com>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-8-ast@kernel.org>
 <CAEf4Bza0FP9EgXVuHsQFy4-bedn3uypuwznpu2fPDTYLaMAQpA@mail.gmail.com>
In-Reply-To: <CAEf4Bza0FP9EgXVuHsQFy4-bedn3uypuwznpu2fPDTYLaMAQpA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0069.namprd07.prod.outlook.com (2603:10b6:100::37)
 To BYAPR15MB2501.namprd15.prod.outlook.com (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::cfd7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f3308a4-8e37-494a-e12a-08d74ce095b5
x-ms-traffictypediagnostic: BYAPR15MB3126:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3126CCD98617FCD041E488E3D7950@BYAPR15MB3126.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(376002)(396003)(366004)(199004)(189003)(7736002)(31696002)(6116002)(86362001)(4326008)(36756003)(66946007)(66476007)(110136005)(64756008)(8936002)(66446008)(316002)(66556008)(186003)(102836004)(6506007)(99286004)(53546011)(81166006)(386003)(31686004)(81156014)(476003)(2616005)(11346002)(446003)(305945005)(486006)(46003)(52116002)(76176011)(8676002)(229853002)(6512007)(14454004)(6246003)(54906003)(2906002)(6486002)(478600001)(5660300002)(14444005)(6436002)(25786009)(71200400001)(71190400001)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3126;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2lbY8S5V5O7QOAuhCfVMBqdpET9yTwKJaCGpjOqgEn4Gv29pDmc/TjN5VX1GkochEd3srr60MATbqKDizpmvj0TQMuqA9JZra7Jn4ni/VAL+Amb1BALMUgP92M9lEzirH0TZPeQ3ke7xDhCVZC1/rqAUeLmW94fP8CWmVKcFT0W+OTv2QrogzDoWH0pasX/JRFTL835r9UYBt9mXS5SjQnicGfej6aWl9JA8zK/y79jN3cf0glAd+e/S0zh4WEE7Ypi8PROMeycIPTsG9k+pro9lDfmgo3DIkZZvCUJP33iEin5VeJuTI9ccksiSBpMDHxnBO+WG7s1MkZ/MT/cab/KvxdKuIv1Xpv94OX1aM/ZY2nfxEeA2BF/OW9qP1yMsCfuFPtdC9mtN6TebANb1Z3Ar9A8YobSaZVz6UZITKnc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2445D815B501C14C9F461A3D8DE9E1D8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3308a4-8e37-494a-e12a-08d74ce095b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 17:46:16.6633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: odbfZv13YhUwcHPCMTONGD1dQ+EIIDhoW2d3YIpE1GK7907960KjSbjGQ+PU1ZUf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3126
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_08:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=699 spamscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvOS8xOSAxMDozOCBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBGcmksIE9j
dCA0LCAyMDE5IGF0IDEwOjA0IFBNIEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+
IHdyb3RlOg0KPj4NCj4+IFBvaW50ZXIgdG8gQlRGIG9iamVjdCBpcyBhIHBvaW50ZXIgdG8ga2Vy
bmVsIG9iamVjdCBvciBOVUxMLg0KPj4gU3VjaCBwb2ludGVycyBjYW4gb25seSBiZSB1c2VkIGJ5
IEJQRl9MRFggaW5zdHJ1Y3Rpb25zLg0KPj4gVGhlIHZlcmlmaWVyIGNoYW5nZWQgdGhlaXIgb3Bj
b2RlIGZyb20gTERYfE1FTXxzaXplDQo+PiB0byBMRFh8UFJPQkVfTUVNfHNpemUgdG8gbWFrZSBK
SVRpbmcgZWFzaWVyLg0KPj4gVGhlIG51bWJlciBvZiBlbnRyaWVzIGluIGV4dGFibGUgaXMgdGhl
IG51bWJlciBvZiBCUEZfTERYIGluc25zDQo+PiB0aGF0IGFjY2VzcyBrZXJuZWwgbWVtb3J5IHZp
YSAicG9pbnRlciB0byBCVEYgdHlwZSIuDQo+PiBPbmx5IHRoZXNlIGxvYWQgaW5zdHJ1Y3Rpb25z
IGNhbiBmYXVsdC4NCj4+IFNpbmNlIHg4NiBleHRhYmxlIGlzIHJlbGF0aXZlIGl0IGhhcyB0byBi
ZSBhbGxvY2F0ZWQgaW4gdGhlIHNhbWUNCj4+IG1lbW9yeSByZWdpb24gYXMgSklUZWQgY29kZS4N
Cj4+IEFsbG9jYXRlIGl0IHByaW9yIHRvIGxhc3QgcGFzcyBvZiBKSVRpbmcgYW5kIGxldCB0aGUg
bGFzdCBwYXNzIHBvcHVsYXRlIGl0Lg0KPj4gUG9pbnRlciB0byBleHRhYmxlIGluIGJwZl9wcm9n
X2F1eCBpcyBuZWNlc3NhcnkgdG8gbWFrZSBwYWdlIGZhdWx0DQo+PiBoYW5kbGluZyBmYXN0Lg0K
Pj4gUGFnZSBmYXVsdCBoYW5kbGluZyBpcyBkb25lIGluIHR3byBzdGVwczoNCj4+IDEuIGJwZl9w
cm9nX2thbGxzeW1zX2ZpbmQoKSBmaW5kcyBCUEYgcHJvZ3JhbSB0aGF0IHBhZ2UgZmF1bHRlZC4N
Cj4+ICAgICBJdCdzIGRvbmUgYnkgd2Fsa2luZyByYiB0cmVlLg0KPj4gMi4gdGhlbiBleHRhYmxl
IGZvciBnaXZlbiBicGYgcHJvZ3JhbSBpcyBiaW5hcnkgc2VhcmNoZWQuDQo+PiBUaGlzIHByb2Nl
c3MgaXMgc2ltaWxhciB0byBob3cgcGFnZSBmYXVsdGluZyBpcyBkb25lIGZvciBrZXJuZWwgbW9k
dWxlcy4NCj4+IFRoZSBleGNlcHRpb24gaGFuZGxlciBza2lwcyBvdmVyIGZhdWx0aW5nIHg4NiBp
bnN0cnVjdGlvbiBhbmQNCj4+IGluaXRpYWxpemVzIGRlc3RpbmF0aW9uIHJlZ2lzdGVyIHdpdGgg
emVyby4gVGhpcyBtaW1pY3MgZXhhY3QNCj4+IGJlaGF2aW9yIG9mIGJwZl9wcm9iZV9yZWFkICh3
aGVuIHByb2JlX2tlcm5lbF9yZWFkIGZhdWx0cyBkZXN0IGlzIHplcm9lZCkuDQo+Pg0KPj4gSklU
cyBmb3Igb3RoZXIgYXJjaGl0ZWN0dXJlcyBjYW4gYWRkIHN1cHBvcnQgaW4gc2ltaWxhciB3YXku
DQo+PiBVbnRpbCB0aGVuIHRoZXkgd2lsbCByZWplY3QgdW5rbm93biBvcGNvZGUgYW5kIGZhbGxi
YWNrIHRvIGludGVycHJldGVyLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEFsZXhlaSBTdGFyb3Zv
aXRvdiA8YXN0QGtlcm5lbC5vcmc+DQo+PiAtLS0NCj4+ICAgYXJjaC94ODYvbmV0L2JwZl9qaXRf
Y29tcC5jIHwgOTYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPj4gICBp
bmNsdWRlL2xpbnV4L2JwZi5oICAgICAgICAgfCAgMyArKw0KPj4gICBpbmNsdWRlL2xpbnV4L2V4
dGFibGUuaCAgICAgfCAxMCArKysrDQo+PiAgIGtlcm5lbC9icGYvY29yZS5jICAgICAgICAgICB8
IDIwICsrKysrKystDQo+PiAgIGtlcm5lbC9icGYvdmVyaWZpZXIuYyAgICAgICB8ICAxICsNCj4+
ICAga2VybmVsL2V4dGFibGUuYyAgICAgICAgICAgIHwgIDIgKw0KPj4gICA2IGZpbGVzIGNoYW5n
ZWQsIDEyNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPj4NCj4gDQo+IFRoaXMgaXMg
c3VycHJpc2luZ2x5IGVhc3kgdG8gZm9sbG93IDopIExvb2tzIGdvb2Qgb3ZlcmFsbCwganVzdCBv
bmUNCj4gY29uY2VybiBhYm91dCAzMi1iaXQgZGlzdGFuY2UgYmV0d2VlbiBleF9oYW5kbGVyX2Jw
ZiBhbmQgQlBGIGppdHRlZA0KPiBwcm9ncmFtIGJlbG93LiBBbmQgSSBhZ3JlZSB3aXRoIEVyaWMs
IHByb2JhYmx5IG5lZWQgdG8gZW5zdXJlIHByb3Blcg0KPiBhbGlnbm1lbnQgZm9yIGV4Y2VwdGlv
bl90YWJsZV9lbnRyeSBhcnJheS4NCg0KYWxyZWFkeSBmaXhlZC4NCg0KDQo+IFsuLi5dDQo+IA0K
Pj4gQEAgLTgwNSw2ICs4MzUsNDggQEAgc3R4OiAgICAgICAgICAgICAgICAgICAgICAgaWYgKGlz
X2ltbTgoaW5zbi0+b2ZmKSkNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICBlbHNlDQo+PiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBFTUlUMV9vZmYzMihhZGRfMnJlZygweDgw
LCBzcmNfcmVnLCBkc3RfcmVnKSwNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGluc24tPm9mZik7DQo+PiArICAgICAgICAgICAgICAgICAgICAgICBpZiAo
QlBGX01PREUoaW5zbi0+Y29kZSkgPT0gQlBGX1BST0JFX01FTSkgew0KPj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgZXhjZXB0aW9uX3RhYmxlX2VudHJ5ICpleDsNCj4+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTggKl9pbnNuID0gaW1hZ2UgKyBwcm9n
bGVuOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzNjQgZGVsdGE7DQo+PiAr
DQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmICghYnBmX3Byb2ctPmF1eC0+
ZXh0YWJsZSkNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBicmVh
azsNCj4+ICsNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGV4Y250ID49
IGJwZl9wcm9nLT5hdXgtPm51bV9leGVudHJpZXMpIHsNCj4+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBwcl9lcnIoImV4IGdlbiBidWdcbiIpOw0KPiANCj4gVGhpcyBz
aG91bGQgbmV2ZXIgaGFwcGVuLCByaWdodD8gQlVHKCk/DQoNCmFic29sdXRlbHkgbm90LiBObyBC
VUdzIGluIGtlcm5lbCBmb3IgdGhpbmdzIGxpa2UgdGhpcy4NCklmIGtlcm5lbCBjYW4gY29udGlu
dWUgaXQgc2hvdWxkLg0KDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgcmV0dXJuIC1FRkFVTFQ7DQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0N
Cj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZXggPSAmYnBmX3Byb2ctPmF1eC0+
ZXh0YWJsZVtleGNudCsrXTsNCj4+ICsNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgZGVsdGEgPSBfaW5zbiAtICh1OCAqKSZleC0+aW5zbjsNCj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgaWYgKCFpc19zaW1tMzIoZGVsdGEpKSB7DQo+PiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJfZXJyKCJleHRhYmxlLT5pbnNuIGRvZXNuJ3Qg
Zml0IGludG8gMzItYml0XG4iKTsNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICByZXR1cm4gLUVGQVVMVDsNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfQ0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBleC0+aW5zbiA9IGRlbHRh
Ow0KPj4gKw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZWx0YSA9ICh1OCAq
KWV4X2hhbmRsZXJfYnBmIC0gKHU4ICopJmV4LT5oYW5kbGVyOw0KPiANCj4gaG93IGxpa2VseSBp
dCBpcyB0aGF0IGdsb2JhbCBleF9oYW5kbGVfYnBmIHdpbGwgYmUgY2xvc2UgZW5vdWdoIHRvDQo+
IGR5bmFtaWNhbGx5IGFsbG9jYXRlZCBwaWVjZSBvZiBleGNlcHRpb25fdGFibGVfZW50cnk/DQoN
Cjk5LjklIFNpbmNlIHdlIHJlbHkgb24gdGhhdCBpbiBvdGhlciBwbGFjZXMgaW4gdGhlIEpJVC4N
ClNlZSBCUEZfQ0FMTCwgZm9yIGV4YW1wbGUuDQpCdXQgSSdkIGxpa2UgdG8ga2VlcCB0aGUgY2hl
Y2sgYmVsb3cuIEp1c3QgaW4gY2FzZS4NClNhbWUgYXMgaW4gQlBGX0NBTEwuDQo=
