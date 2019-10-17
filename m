Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A949DDB4FF
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394898AbfJQRym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:54:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37020 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729325AbfJQRyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 13:54:41 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9HHoSd0029083;
        Thu, 17 Oct 2019 10:54:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=21PZNbFwGJiK+bco9StYJlx3OJJdep8C38+v0Mcd7F4=;
 b=NMtb7w7rPAkoIEoyV+63lvgSpisUnNhFDOpj/XRBVHC4EYiFuX68jvjNtPNZm/ZcrtD2
 ENHGmWolm1AzjtDgsmRHanY16VjI7CVSRbn3wNS2YM0xjn3wn6NpzeYzZURt0rxxocbN
 KoFU4s6lrJhyk/nUakbOXhmOOiex82FXk68= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vpcs144s8-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Oct 2019 10:54:28 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Oct 2019 10:54:27 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Oct 2019 10:54:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qfdsys2QGvTUlaae07g6emzzpmALBL6J/6y+0QYhavqIb69VmYBuGvD65dzdWVU8HkvfmiJ0LuSgXuYV3Icahy3yt5RoI3LYbsCMZ8moyOnCoBuEuFl9ItEaXfIZWlDgYBeS0gC6NyJOIUyIwa56VmZCR+Lv4elBHwNkJq2o7xNMcaZnViU2QmJpsUGdLdbhJsDOARpUG1Rvf1TC1sJjUgZ6djFM5TprhMxanH73KKACMi34BAPDCG8FdOlEMS2rr5WjA5BlQOnVstcQwjBly5MFIHiJWMhTkermy7pA4s+M7vZZYKPEY5E0Rnzd7Fw4IQHWyeSxx+oftAQQVbckPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21PZNbFwGJiK+bco9StYJlx3OJJdep8C38+v0Mcd7F4=;
 b=NNt8dhX69VXk2XA3Xgfu9uRgQT3ele6//r1YkC7bPhXJxudKo1d806QTXSYNnNVnly7zUVzBwgYYRRKqS/e0I+lnYxXJK7iMh4uyf0AnqkCJu+gORyASPLYZYpEM+2xNtqvNNfQtA+Zz0fZg67ZMbj1VFi33F9U5WFy4zcm+FAvHDiC5ud1mDvbSE2XYAgPSi/vhhSKBuD7Lmp8gZhsxLICR/5sfGRXpGYgf1BsCwLUXmNpntO+HihOtiYRRhzoxlH50eHR8yD91DWz55NQJ9TRGeL1lSaUydD6vGhm5R4ETtl9X0nuKh2zuMi8KzZ3YDdPxCRc/al6gX5cxNoNTVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21PZNbFwGJiK+bco9StYJlx3OJJdep8C38+v0Mcd7F4=;
 b=kIOSOns/3JZ7J1TTAkqMtbHBmBuhW1BfJJODqb9uFxhp7KtnXmJ01SM3k3TnZd4XH4qS5z0/Eo6/aWGWNrBk7/Pom/Zq7BlRNAH50yE3Q2UgEz20Q2ctRVJA7fBFjmqmZl3neEgNowwR/rOL+WhQBMbEnqJtVLK0yogDx4Okh6o=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2648.namprd15.prod.outlook.com (20.179.156.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 17 Oct 2019 17:54:26 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 17:54:26 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 5/7] selftests/bpf: replace test_progs and
 test_maps w/ general rule
Thread-Topic: [PATCH v4 bpf-next 5/7] selftests/bpf: replace test_progs and
 test_maps w/ general rule
Thread-Index: AQHVg+cfBdGXQnDIIUCRFTvGjj4eYKdfHwkAgAAA+YA=
Date:   Thu, 17 Oct 2019 17:54:26 +0000
Message-ID: <a5076b0f-9cc2-8f5c-7b3c-5882aa595332@fb.com>
References: <20191016060051.2024182-1-andriin@fb.com>
 <20191016060051.2024182-6-andriin@fb.com>
 <CAEf4BzZvNQwcn3=sUHjnVfGzAMkfECpiJ7=YEDWSnLFZD7xeCA@mail.gmail.com>
In-Reply-To: <CAEf4BzZvNQwcn3=sUHjnVfGzAMkfECpiJ7=YEDWSnLFZD7xeCA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0057.namprd17.prod.outlook.com
 (2603:10b6:300:93::19) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c981]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cea73ae6-4230-4f6c-8d8f-08d7532b0cc0
x-ms-traffictypediagnostic: BYAPR15MB2648:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB264800A7F636D71E40531361D76D0@BYAPR15MB2648.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(31696002)(86362001)(7736002)(478600001)(14454004)(71190400001)(305945005)(6116002)(6636002)(36756003)(316002)(71200400001)(256004)(110136005)(54906003)(2906002)(6486002)(31686004)(8676002)(64756008)(99286004)(6512007)(66446008)(229853002)(6506007)(52116002)(6436002)(76176011)(186003)(81166006)(81156014)(2616005)(476003)(5660300002)(46003)(486006)(8936002)(11346002)(386003)(25786009)(446003)(66946007)(6246003)(53546011)(4326008)(66556008)(102836004)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2648;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7BHWW5OV6/8swk3hCSJiiXHHdBMPq/mQHgMArdKClmXQO+GF7onsu3OCSmA3tBrnpJN8UmMYHGxdSYA30Mni5RHHb+MgF6lW8u6NNU3QfPcWD7aGGOmxUidJsMsO/h3JCLyJFCAHeMInXQILY+GHwr8aOUO5MZPteSNS4IJEUFU66ANvR+HlEtCu0rETXxra8HzGCR39jxTyehPnq7S7PzaXA49onXamyzoXyL6UOeu79WsyhMOE3mIoirpfwovac1dZvGYiyzyI0/LEg9BmOBcYxdbcCggw7ZueWEb54+WPdlCt7vUzJ2NmKVgejCJAF/JfbAlUvEyRHcLT6gUHMGZ3LbsjWs+HCk4/N524Lyzt2V9PZSYb17DjfzYoRTwkXCfmvnrfON76Hacyu+cJqxZwDxzBvcvJCyU+asmYvTw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3888D2915A22344B242B0F5EB1AC24C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cea73ae6-4230-4f6c-8d8f-08d7532b0cc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 17:54:26.1587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CaKt3bjw+gFSuPfMkkfzyBwOuOjk494Qsh0+KPx9wPbqEBrA3ZqMw7rCn61E9NfT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2648
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-17_05:2019-10-17,2019-10-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910170161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTcvMTkgMTA6NTAgQU0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gT24gVHVlLCBP
Y3QgMTUsIDIwMTkgYXQgMTE6MDEgUE0gQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4g
d3JvdGU6DQo+Pg0KPj4gRGVmaW5lIHRlc3QgcnVubmVyIGdlbmVyYXRpb24gbWV0YS1ydWxlIHRo
YXQgY29kaWZpZXMgZGVwZW5kZW5jaWVzDQo+PiBiZXR3ZWVuIHRlc3QgcnVubmVyLCBpdHMgdGVz
dHMsIGFuZCBpdHMgZGVwZW5kZW50IEJQRiBwcm9ncmFtcy4gVXNlIHRoYXQNCj4+IGZvciBkZWZp
bmluZyB0ZXN0X3Byb2dzIGFuZCB0ZXN0X21hcHMgdGVzdC1ydW5uZXJzLiBBbHNvIGFkZGl0aW9u
YWxseSBkZWZpbmUNCj4+IDIgZmxhdm9ycyBvZiB0ZXN0X3Byb2dzOg0KPj4gLSBhbHUzMiwgd2hp
Y2ggYnVpbGRzIEJQRiBwcm9ncmFtcyB3aXRoIDMyLWJpdCByZWdpc3RlcnMgY29kZWdlbjsNCj4+
IC0gYnBmX2djYywgd2hpY2ggYnVpbGQgQlBGIHByb2dyYW1zIHVzaW5nIEdDQywgaWYgaXQgc3Vw
cG9ydHMgQlBGIHRhcmdldC4NCj4+DQo+PiBPdmVyYWxsLCB0aGlzIGlzIGFjY29tcGxpc2hlZCB0
aHJvdWdoICQoZXZhbCknaW5nIGEgc2V0IG9mIGdlbmVyaWMNCj4+IHJ1bGVzLCB3aGljaCBkZWZp
bmVzIE1ha2VmaWxlIHRhcmdldHMgZHluYW1pY2FsbHkgYXQgcnVudGltZS4gU2VlDQo+PiBjb21t
ZW50cyBleHBsYWluaW5nIHRoZSBuZWVkIGZvciAyICQoZXZhbHMpLCB0aG91Z2guDQo+Pg0KPj4g
Rm9yIGVhY2ggdGVzdCBydW5uZXIgd2UgaGF2ZSAodGVzdF9tYXBzIGFuZCB0ZXN0X3Byb2dzLCBj
dXJyZW50bHkpLCBhbmQsDQo+PiBvcHRpb25hbGx5LCB0aGVpciBmbGF2b3JzLCB0aGUgbG9naWMg
b2YgYnVpbGQgcHJvY2VzcyBpcyBtb2RlbGVkIGFzDQo+PiBmb2xsb3dzICh1c2luZyB0ZXN0X3By
b2dzIGFzIGFuIGV4YW1wbGUpOg0KPj4gLSBhbGwgQlBGIG9iamVjdHMgYXJlIGluIHByb2dzLzoN
Cj4+ICAgIC0gQlBGIG9iamVjdCdzIC5vIGZpbGUgaXMgYnVpbHQgaW50byBvdXRwdXQgZGlyZWN0
b3J5IGZyb20NCj4+ICAgICAgY29ycmVzcG9uZGluZyBwcm9ncy8uYyBmaWxlOw0KPj4gICAgLSBh
bGwgQlBGIG9iamVjdHMgaW4gcHJvZ3MvKi5jIGRlcGVuZCBvbiBhbGwgcHJvZ3MvKi5oIGhlYWRl
cnM7DQo+PiAgICAtIGFsbCBCUEYgb2JqZWN0cyBkZXBlbmQgb24gYnBmXyouaCBoZWxwZXJzIGZy
b20gbGliYnBmIChidXQgbm90DQo+PiAgICAgIGxpYmJwZiBhcmNoaXZlKS4gVGhlcmUgaXMgYW4g
ZXh0cmEgcnVsZSB0byB0cmlnZ2VyIGJwZl9oZWxwZXJfZGVmcy5oDQo+PiAgICAgIChyZS0pYnVp
bGQsIGlmIGl0J3Mgbm90IHByZXNlbnQvb3V0ZGF0ZWQpOw0KPj4gICAgLSBidWlsZCByZWNpcGUg
Zm9yIEJQRiBvYmplY3QgY2FuIGJlIHJlLWRlZmluZWQgcGVyIHRlc3QgcnVubmVyL2ZsYXZvcjsN
Cj4+IC0gdGVzdCBmaWxlcyBhcmUgYnVpbHQgZnJvbSBwcm9nX3Rlc3RzLyouYzoNCj4+ICAgIC0g
YWxsIHN1Y2ggdGVzdCBmaWxlIG9iamVjdHMgYXJlIGJ1aWx0IG9uIGluZGl2aWR1YWwgZmlsZSBi
YXNpczsNCj4+ICAgIC0gY3VycmVudGx5LCBldmVyeSBzaW5nbGUgdGVzdCBmaWxlIGRlcGVuZHMg
b24gYWxsIEJQRiBvYmplY3QgZmlsZXM7DQo+PiAgICAgIHRoaXMgbWlnaHQgYmUgaW1wcm92ZWQg
aW4gZm9sbG93IHVwIHBhdGNoZXMgdG8gZG8gMS10by0xIGRlcGVuZGVuY3ksDQo+PiAgICAgIGJ1
dCBhbGxvd2luZyB0byBjdXN0b21pemUgdGhpcyBwZXIgZWFjaCBpbmRpdmlkdWFsIHRlc3Q7DQo+
PiAgICAtIGVhY2ggdGVzdCBydW5uZXIgZGVmaW5pdGlvbiBjYW4gc3BlY2lmeSBhIGxpc3Qgb2Yg
ZXh0cmEgLmMgYW5kIC5oDQo+PiAgICAgIGZpbGVzIHRvIGJlIGJ1aWx0IGFsb25nIHRlc3QgZmls
ZXMgYW5kIHRlc3QgcnVubmVyIGJpbmFyeTsgYWxsIHN1Y2gNCj4+ICAgICAgaGVhZGVycyBhcmUg
YmVjb21pbmcgYXV0b21hdGljIGRlcGVuZGVuY3kgb2YgZWFjaCB0ZXN0IC5jIGZpbGU7DQo+PiAg
ICAtIGR1ZSB0byB0ZXN0IGZpbGVzIHNvbWV0aW1lcyBlbWJlZGRpbmcgKHVzaW5nIC5pbmNiaW4g
YXNzZW1ibHkNCj4+ICAgICAgZGlyZWN0aXZlKSBjb250ZW50cyBvZiBzb21lIEJQRiBvYmplY3Rz
IGF0IGNvbXBpbGF0aW9uIHRpbWUsIHdoaWNoIGFyZQ0KPj4gICAgICBleHBlY3RlZCB0byBiZSBp
biBDV0Qgb2YgY29tcGlsZXIsIGNvbXBpbGF0aW9uIGZvciB0ZXN0IGZpbGUgb2JqZWN0IGRvZXMN
Cj4+ICAgICAgY2QgaW50byB0ZXN0IHJ1bm5lcidzIG91dHB1dCBkaXJlY3Rvcnk7IHRvIHN1cHBv
cnQgdGhpcyBtb2RlIGFsbCB0aGUNCj4+ICAgICAgaW5jbHVkZSBwYXRocyBhcmUgdHVybmVkIGlu
dG8gYWJzb2x1dGUgcGF0aHMgdXNpbmcgJChhYnNwYXRoKSBtYWtlDQo+PiAgICAgIGZ1bmN0aW9u
Ow0KPj4gLSBwcm9nX3Rlc3RzL3Rlc3QuaCBpcyBhdXRvbWF0aWNhbGx5IChyZS0pZ2VuZXJhdGVk
IHdpdGggYW4gZW50cnkgZm9yDQo+PiAgICBlYWNoIC5jIGZpbGUgaW4gcHJvZ190ZXN0cy87DQo+
PiAtIGZpbmFsIHRlc3QgcnVubmVyIGJpbmFyeSBpcyBsaW5rZWQgdG9nZXRoZXIgZnJvbSB0ZXN0
IG9iamVjdCBmaWxlcyBhbmQNCj4+ICAgIGV4dHJhIG9iamVjdCBmaWxlcywgbGlua2luZyB0b2dl
dGhlciBsaWJicGYncyBhcmNoaXZlIGFzIHdlbGw7DQo+PiAtIGl0J3MgcG9zc2libGUgdG8gc3Bl
Y2lmeSBleHRyYSAicmVzb3VyY2UiIGZpbGVzL3RhcmdldHMsIHdoaWNoIHdpbGwgYmUNCj4+ICAg
IGNvcGllZCBpbnRvIHRlc3QgcnVubmVyIG91dHB1dCBkaXJlY3RvcnksIGlmIGl0IGRpZmZlcmVz
IGZyb20NCj4+ICAgIE1ha2VmaWxlLXdpZGUgJChPVVRQVVQpLiBUaGlzIGlzIHVzZWQgdG8gZW5z
dXJlIGJ0Zl9kdW1wIHRlc3QgY2FzZXMgYW5kDQo+PiAgICB1cmFuZG9tX3JlYWQgYmluYXJ5IGlz
IHB1dCBpbnRvIGEgdGVzdCBydW5uZXIncyBDV0QgZm9yIHRlc3RzIHRvIGZpbmQNCj4+ICAgIHRo
ZW0gaW4gcnVudGltZS4NCj4+DQo+PiBGb3IgZmxhdm9yZWQgdGVzdCBydW5uZXJzLCB0aGVpciBv
dXRwdXQgZGlyZWN0b3J5IGlzIGEgc3ViZGlyZWN0b3J5IG9mDQo+PiBjb21tb24gTWFrZWZpbGUt
d2lkZSAkKE9VVFBVVCkgZGlyZWN0b3J5IHdpdGggZmxhdm9yIG5hbWUgdXNlZCBhcw0KPj4gc3Vi
ZGlyZWN0b3J5IG5hbWUuDQo+Pg0KPj4gQlBGIG9iamVjdHMgdGFyZ2V0cyBtaWdodCBiZSByZXVz
ZWQgYmV0d2VlbiBkaWZmZXJlbnQgdGVzdCBydW5uZXJzLCBzbw0KPj4gZXh0cmEgY2hlY2tzIGFy
ZSBlbXBsb3llZCB0byBub3QgZG91YmxlLWRlZmluZSB0aGVtLiBTaW1pbGFybHksIHdlIGhhdmUN
Cj4+IHJlZGVmaW5pdGlvbiBndWFyZHMgZm9yIG91dHB1dCBkaXJlY3RvcmllcyBhbmQgdGVzdCBo
ZWFkZXJzLg0KPj4NCj4+IHRlc3RfdmVyaWZpZXIgZm9sbG93cyBzbGlnaHRseSBkaWZmZXJlbnQg
cGF0dGVybnMgYW5kIGlzIHNpbXBsZSBlbm91Z2gNCj4+IHRvIG5vdCBqdXN0aWZ5IGdlbmVyYWxp
emluZyBURVNUX1JVTk5FUl9ERUZJTkUvVEVTVF9SVU5ORVJfREVGSU5FX1JVTEVTDQo+PiBmdXJ0
aGVyIHRvIGFjY29tb2RhdGUgdGhlc2UgZGlmZmVyZW5jZXMuIEluc3RlYWQsIHJ1bGVzIGZvcg0K
Pj4gdGVzdF92ZXJpZmllciBhcmUgbWluaW1pemVkIGFuZCBzaW1wbGlmaWVkLCB3aGlsZSBwcmVz
ZXJ2aW5nIGNvcnJlY3RuZXNzDQo+PiBvZiBkZXBlbmRlbmNpZXMuDQo+Pg0KPj4gU2lnbmVkLW9m
Zi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4+IC0tLQ0KPiANCj4gQlRX
LCBpZiBjb3JyZWN0bmVzcyBhbmQgRFJZLW5lc3MgYXJndW1lbnQgaXMgbm90IHN0cm9uZyBlbm91
Z2gsIHRoZXNlDQo+IGNoYW5nZXMgbWFrZXMgY2xlYW4gcmVidWlsZCBmcm9tIHNjcmF0Y2ggYWJv
dXQgMnggZmFzdGVyIGZvciBtZToNCj4gDQo+IEJFRk9SRTogYG1ha2UgY2xlYW4gJiYgdGltZSBt
YWtlIC1qNTBgIGlzIDE0LTE1IHNlY29uZHMNCj4gQUZURVI6IGBtYWtlIGNsZWFuICYmIHRpbWUg
bWFrZSAtajUwYCBpcyA3LTggc2Vjb25kcw0KDQpJIG5vdGljZWQgdGhhdCB0b28gYW5kIHdhcyBh
Ym91dCB0byBhc2sgIndoeT8iIC4uIDopDQo=
