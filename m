Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68FA426D03
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbfEVTit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:38:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56866 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731647AbfEVTis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:38:48 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MJV1PH024964;
        Wed, 22 May 2019 12:38:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=sA/u34+9flKSjaQU6SeqojteXnKvJfFi7qIpAKvSMb0=;
 b=oamGpp9mii3nAHlSVej83uy/XviaSG4gUQUYpaunZH7vEg7bcp1zGlMAtNpQ6HerAhH2
 qpudzg3irKX9T6y84zsKxXr1IBep+YxBf8mPFVT+VVODm6ZZIdCS497VAW+GHs5d8f1r
 Kz5U5ptBvPmoMKvxiSAhQ+9Iw0JOIKuChUk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn7jusbe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 May 2019 12:38:20 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 12:38:19 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 12:38:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sA/u34+9flKSjaQU6SeqojteXnKvJfFi7qIpAKvSMb0=;
 b=OgimPOI16n4eR8Z4BLAtbMUVzl7UVz9S17zpee4bgNbKsvdfBaWtvuZYQUrsPVRgJhlj6n6VmCQdYTp3/aoSfUvqJqfSESeEoW+j+AOL+s/KXSeEploSSKo6APzArzwc9IkGlJWehtKVSZrIaKrbx+qaTNlkoPV+xM3h5wng+N4=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2198.namprd15.prod.outlook.com (52.135.196.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Wed, 22 May 2019 19:38:17 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 19:38:17 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH bpf-next v2 3/3] tools/bpf: add a selftest for
 bpf_send_signal() helper
Thread-Topic: [PATCH bpf-next v2 3/3] tools/bpf: add a selftest for
 bpf_send_signal() helper
Thread-Index: AQHVEGC/AXMWZ1rZ1EW14tmo8WsUfKZ3fUGAgAANx4A=
Date:   Wed, 22 May 2019 19:38:17 +0000
Message-ID: <c33ddd82-addf-aff6-ade2-e66f2c74f260@fb.com>
References: <20190522053900.1663459-1-yhs@fb.com>
 <20190522053903.1663924-1-yhs@fb.com>
 <CAEf4BzbSvVRFd3ASnOR5kT40mCeH85ir2eFRdzu_rk4xjYky2g@mail.gmail.com>
In-Reply-To: <CAEf4BzbSvVRFd3ASnOR5kT40mCeH85ir2eFRdzu_rk4xjYky2g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0044.namprd18.prod.outlook.com
 (2603:10b6:104:2::12) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::abfc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f862f2e-188d-4907-b800-08d6deed09b4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2198;
x-ms-traffictypediagnostic: BYAPR15MB2198:
x-microsoft-antispam-prvs: <BYAPR15MB219812B93164776294C62359D3000@BYAPR15MB2198.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(39860400002)(376002)(396003)(199004)(189003)(5660300002)(8936002)(25786009)(36756003)(478600001)(4326008)(14454004)(229853002)(66476007)(64756008)(66446008)(66946007)(73956011)(305945005)(7736002)(71190400001)(71200400001)(66556008)(102836004)(2906002)(6916009)(316002)(6116002)(386003)(6506007)(186003)(53546011)(99286004)(31696002)(52116002)(2616005)(76176011)(486006)(11346002)(46003)(86362001)(31686004)(446003)(476003)(81156014)(256004)(14444005)(6436002)(54906003)(53936002)(68736007)(8676002)(81166006)(6512007)(6246003)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2198;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: h3sLo2HEX3UFUi01yDkCq2PgEWUcOLU/CSKGb5CU4c0aJ1sRDnJM0X8eZUBv4vj733akmlfmpa3n2EpcUlRSAue0M28shJwJkMgFJkmuLYVuip1daOdGoeu57CeCAphNG325CdvkPLWh2I4jXMPdBBOjI0K/wfl1G6xxRYIiCWwH7WQOb4N8fYkKk+isMtbD/8pgimGa64tm3UJdb000+SufGXdnn6TFAU2xn05EZ3yKTXm0FH/VKkHGzas2akApZhIqJrw9s09vxTZumIOmHA26ZZNRrXEzGnFOYhZD7nGEKLbtEK+3Jl+6XiA75QUmFfLsZJK3Xu/dD668AKWgynFP0CkYHcHqJSiDDSc1PNTp+kBFE/GwyA/+OnzAktjKk4m+ueRMrvlSAVm/WUCH2C7asQBl/rFCIpgSTM400xQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9F3FA66867E724CAAF5FD2158649F79@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f862f2e-188d-4907-b800-08d6deed09b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 19:38:17.4385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2198
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjIvMTkgMTE6NDggQU0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gT24gVHVl
LCBNYXkgMjEsIDIwMTkgYXQgMTA6NDAgUE0gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3Jv
dGU6DQo+Pg0KPj4gVGhlIHRlc3QgY292ZXJlZCBib3RoIG5taSBhbmQgdHJhY2Vwb2ludCBwZXJm
IGV2ZW50cy4NCj4+ICAgICQgLi90ZXN0X3NlbmRfc2lnbmFsX3VzZXINCj4+ICAgIHRlc3Rfc2Vu
ZF9zaWduYWwgKHRyYWNlcG9pbnQpOiBPSw0KPj4gICAgdGVzdF9zZW5kX3NpZ25hbCAocGVyZl9l
dmVudCk6IE9LDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNv
bT4NCj4+IC0tLQ0KPj4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvTWFrZWZpbGUgICAg
ICAgICAgfCAgIDMgKy0NCj4+ICAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL2JwZl9oZWxw
ZXJzLmggICAgIHwgICAxICsNCj4+ICAgLi4uL2JwZi9wcm9ncy90ZXN0X3NlbmRfc2lnbmFsX2tl
cm4uYyAgICAgICAgIHwgIDUxICsrKysrDQo+PiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Rlc3Rfc2Vu
ZF9zaWduYWxfdXNlci5jICAgICB8IDIxMiArKysrKysrKysrKysrKysrKysNCj4+ICAgNCBmaWxl
cyBjaGFuZ2VkLCAyNjYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4gICBjcmVhdGUg
bW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3Rfc2VuZF9z
aWduYWxfa2Vybi5jDQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9icGYvdGVzdF9zZW5kX3NpZ25hbF91c2VyLmMNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL01ha2VmaWxlIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmL01ha2VmaWxlDQo+PiBpbmRleCA2NmYyZGNhMWRlZTEuLjVlYjYzNjhhOTZhMiAxMDA2
NDQNCj4+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9NYWtlZmlsZQ0KPj4gKysr
IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL01ha2VmaWxlDQo+PiBAQCAtMjMsNyArMjMs
OCBAQCBURVNUX0dFTl9QUk9HUyA9IHRlc3RfdmVyaWZpZXIgdGVzdF90YWcgdGVzdF9tYXBzIHRl
c3RfbHJ1X21hcCB0ZXN0X2xwbV9tYXAgdGVzdA0KPj4gICAgICAgICAgdGVzdF9hbGlnbiB0ZXN0
X3ZlcmlmaWVyX2xvZyB0ZXN0X2Rldl9jZ3JvdXAgdGVzdF90Y3BicGZfdXNlciBcDQo+PiAgICAg
ICAgICB0ZXN0X3NvY2sgdGVzdF9idGYgdGVzdF9zb2NrbWFwIHRlc3RfbGlyY19tb2RlMl91c2Vy
IGdldF9jZ3JvdXBfaWRfdXNlciBcDQo+PiAgICAgICAgICB0ZXN0X3NvY2tldF9jb29raWUgdGVz
dF9jZ3JvdXBfc3RvcmFnZSB0ZXN0X3NlbGVjdF9yZXVzZXBvcnQgdGVzdF9zZWN0aW9uX25hbWVz
IFwNCj4+IC0gICAgICAgdGVzdF9uZXRjbnQgdGVzdF90Y3Bub3RpZnlfdXNlciB0ZXN0X3NvY2tf
ZmllbGRzIHRlc3Rfc3lzY3RsDQo+PiArICAgICAgIHRlc3RfbmV0Y250IHRlc3RfdGNwbm90aWZ5
X3VzZXIgdGVzdF9zb2NrX2ZpZWxkcyB0ZXN0X3N5c2N0bCBcDQo+PiArICAgICAgIHRlc3Rfc2Vu
ZF9zaWduYWxfdXNlcg0KPj4NCj4+ICAgQlBGX09CSl9GSUxFUyA9ICQocGF0c3Vic3QgJS5jLCUu
bywgJChub3RkaXIgJCh3aWxkY2FyZCBwcm9ncy8qLmMpKSkNCj4+ICAgVEVTVF9HRU5fRklMRVMg
PSAkKEJQRl9PQkpfRklMRVMpDQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmL2JwZl9oZWxwZXJzLmggYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvYnBmX2hl
bHBlcnMuaA0KPj4gaW5kZXggNWY2ZjllN2FiYTJhLi5jYjAyNTIxYjhlNTggMTAwNjQ0DQo+PiAt
LS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvYnBmX2hlbHBlcnMuaA0KPj4gKysrIGIv
dG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL2JwZl9oZWxwZXJzLmgNClsuLi5dDQo+PiArDQo+
PiAraW50IG1haW4odm9pZCkNCj4+ICt7DQo+PiArICAgICAgIHRlc3RfdHJhY2Vwb2ludCgpOw0K
Pj4gKyAgICAgICB0ZXN0X25taV9wZXJmX2V2ZW50KCk7DQo+IA0KPiBUZXN0cyBzaG91bGQgcHJv
YmFibHkgcHJvcGFnYXRlIGZhaWx1cmUgdXAgdG8gbWFpbigpIGFuZCByZXR1cm4gZXhpdA0KPiBj
b2RlICE9IDAsIGlmIGFueSBvZiB0aGUgdGVzdHMgZmFpbGVkLg0KDQpHb29kIGNhdGNoISBXaWxs
IGZpeCBpdCBpbiB0aGUgbmV4dCByZXZpc2lvbi4NCg0KPiANCj4+ICsgICAgICAgcmV0dXJuIDA7
DQo+PiArfQ0KPj4gLS0NCj4+IDIuMTcuMQ0KPj4NCg==
