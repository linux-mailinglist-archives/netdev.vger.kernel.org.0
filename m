Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29D73ACAB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 03:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbfFJBRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 21:17:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51256 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729703AbfFJBRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 21:17:41 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5A1F2WR032526;
        Sun, 9 Jun 2019 18:17:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Tc3Jy0rO0xijITioVPScpD5qQZl9zzYkrDqpSR5pNdA=;
 b=CplGU0een0KDuJ7slIko8ygqDpYRgm2gLBMzyzHO3bnG2vETniKlP5iQzm4dcp3j0ZpB
 gKC8J7qbFSL1zS8UkJ3aYcbN3QCVT51HZ4ubPoF+gCnYlLjxfc/EtlsUa9DP6bEV0U9d
 BSrtQJB2bI9Gmm7BlMouJpS2OIWkTeDLCSI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t08b33wsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 09 Jun 2019 18:17:17 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 9 Jun 2019 18:17:16 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 9 Jun 2019 18:17:15 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 9 Jun 2019 18:17:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tc3Jy0rO0xijITioVPScpD5qQZl9zzYkrDqpSR5pNdA=;
 b=Wx3Frn1Evyhd0bfWR93d33wVpJnDX+R7ckGhv5Fig3Z5+a6lszpXPOJcPu9atQuJGdOAMQjgfkxC8gksmLjhB2cvg9+8yAQsblkrvYqX+TRqlDR3inJ6ePpt08BpUFhKOcE7PMkIeCNNnj6TyMVHfoAW0WI6KU2A9lVOlUfDbII=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2213.namprd15.prod.outlook.com (52.135.196.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.17; Mon, 10 Jun 2019 01:17:13 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 01:17:13 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Subject: explicit maps. Was: [RFC PATCH bpf-next 6/8] libbpf: allow specifying
 map definitions using BTF
Thread-Topic: explicit maps. Was: [RFC PATCH bpf-next 6/8] libbpf: allow
 specifying map definitions using BTF
Thread-Index: AQHVF+6FIN4ypCqNSkaaeWcXaUexbKaFv76AgAAZLICABEsPAIAAXHQAgAAyMACAAAE1gIAAOGMAgACbgwCAAD8rgIADYXQAgAAfwACAAAbfAIAAC+aAgAAE8QCAAAnNgIAEuv0A
Date:   Mon, 10 Jun 2019 01:17:13 +0000
Message-ID: <b9798871-3b0e-66ce-903d-c9a587651abc@fb.com>
References: <20190531202132.379386-1-andriin@fb.com>
 <20190531202132.379386-7-andriin@fb.com> <20190531212835.GA31612@mini-arch>
 <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch>
 <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch>
 <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
 <20190604042902.GA2014@mini-arch> <20190604134538.GB2014@mini-arch>
 <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
 <3ff873a8-a1a6-133b-fa20-ad8bc1d347ed@iogearbox.net>
 <CAEf4BzYr_3heu2gb8U-rmbgMPu54ojcdjMZu7M_VaqOyCNGR5g@mail.gmail.com>
 <9d0bff7f-3b9f-9d2c-36df-64569061edd6@fb.com>
 <20190606171007.1e1eb808@cakuba.netronome.com>
 <4553f579-c7bb-2d4c-a1ef-3e4fbed64427@fb.com>
 <20190606180253.36f6d2ae@cakuba.netronome.com>
In-Reply-To: <20190606180253.36f6d2ae@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0012.namprd14.prod.outlook.com
 (2603:10b6:300:ae::22) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:3c5d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9495d345-ea55-47fc-9920-08d6ed415e6d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2213;
x-ms-traffictypediagnostic: BYAPR15MB2213:
x-microsoft-antispam-prvs: <BYAPR15MB2213FD7B7EC5BF79490B1CB6D7130@BYAPR15MB2213.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(39860400002)(136003)(346002)(366004)(189003)(199004)(102836004)(86362001)(52116002)(76176011)(81166006)(81156014)(36756003)(8676002)(8936002)(54906003)(6916009)(71190400001)(305945005)(6506007)(478600001)(6512007)(256004)(186003)(7736002)(386003)(53936002)(53546011)(14454004)(71200400001)(31696002)(31686004)(6116002)(446003)(46003)(99286004)(68736007)(2616005)(476003)(6436002)(2906002)(6486002)(11346002)(4326008)(25786009)(486006)(316002)(5660300002)(66446008)(66946007)(66476007)(66556008)(64756008)(73956011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2213;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0XK2IEKQ5ftgrikS6lTVHcg8TfWzmKQoXlFJf09exaR2IzPrdwxwCslYUDj7SkKAEl0BKAcv92dljTH/fI6uNSJxK3aZ4L0CSgFWqIlweR/yeaHaIY2Km7bfMFJFj/5qgvTJVrVy8Q6wWwHM6zMVtUEYMH0o1eV9cUg5gB9viZ+YWYSCHzDq3b/KaEocSvo6FoWnjoBgmz3oi9+yEMkNn4vyuTHX/TDD6yA5c9ceyo/yoPucNPdfGghZSfbpNv5YqS9P8CTKqN17YJq6UxRfb34UoQJlf3ubKnWSJqE7vZxbY8Esc10d7YrzaAmGoH+GBYrTyL7lLlKbYkPwvEBhBTbV6HkHhZxO45EeRUTSK/LLEe5RDDKyZ89wN9lkfvuni4FVKLeByf5LRWe+YSbv6etq1Sb3X4VkriQRZCW8wh8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8D9DA819A70E0408EE9A58E65FB2227@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9495d345-ea55-47fc-9920-08d6ed415e6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 01:17:13.5949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2213
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-09_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=968 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi82LzE5IDY6MDIgUE0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBGcmksIDcgSnVu
IDIwMTkgMDA6Mjc6NTIgKzAwMDAsIEFsZXhlaSBTdGFyb3ZvaXRvdiB3cm90ZToNCj4+IHRoZSBz
b2x1dGlvbiB3ZSdyZSBkaXNjdXNzaW5nIHNob3VsZCBzb2x2ZSBCUEZfQU5OT1RBVEVfS1ZfUEFJ
UiB0b28uDQo+PiBUaGF0IGhhY2sgbXVzdCBnby4NCj4gDQo+IEkgc2VlLg0KPiANCj4+IElmIEkg
dW5kZXJzdG9vZCB5b3VyIG9iamVjdGlvbnMgdG8gQW5kcmlpJ3MgZm9ybWF0IGlzIHRoYXQNCj4+
IHlvdSBkb24ndCBsaWtlIHBvaW50ZXIgcGFydCBvZiBrZXkvdmFsdWUgd2hpbGUgQW5kcmlpIGV4
cGxhaW5lZA0KPj4gd2h5IHdlIHBpY2tlZCB0aGUgcG9pbnRlciwgcmlnaHQ/DQo+Pg0KPj4gU28g
aG93IGFib3V0Og0KPj4NCj4+IHN0cnVjdCB7DQo+PiAgICAgaW50IHR5cGU7DQo+PiAgICAgaW50
IG1heF9lbnRyaWVzOw0KPj4gICAgIHN0cnVjdCB7DQo+PiAgICAgICBfX3UzMiBrZXk7DQo+PiAg
ICAgICBzdHJ1Y3QgbXlfdmFsdWUgdmFsdWU7DQo+PiAgICAgfSB0eXBlc1tdOw0KPj4gfSAuLi4N
Cj4gDQo+IE15IG9iamVjdGlvbiBpcyB0aGF0IGsvdiBmaWVsZHMgYXJlIG5ldmVyIGluaXRpYWxp
emVkLCBzbyB0aGV5J3JlDQo+ICJtZXRhZmllbGRzIiwgbWl4ZWQgd2l0aCByZWFsIGZpZWxkcyB3
aGljaCBob2xkIHBhcmFtZXRlcnMgLSBsaWtlDQo+IHR5cGUsIG1heF9lbnRyaWVzIGV0Yy4NCg0K
SSBkb24ndCBzaGFyZSB0aGlzIG1ldGEgZmllbGRzIHZzIHJlYWwgZmllbGRzIGRpc3RpbmN0aW9u
Lg0KQWxsIG9mIHRoZSBmaWVsZHMgYXJlIG1ldGEuDQpLZXJuZWwgaW1wbGVtZW50YXRpb24gb2Yg
dGhlIG1hcCBkb2Vzbid0IG5lZWQgdG8gaG9sZCB0eXBlIGFuZA0KbWF4X2VudHJpZXMgYXMgYWN0
dWFsIGNvbmZpZ3VyYXRpb24gZmllbGRzLg0KVGhlIG1hcCBkZWZpbml0aW9uIGluIGMrKyB3b3Vs
ZCBoYXZlIGxvb2tlZCBsaWtlOg0KYnBmOjpoYXNoX21hcDxpbnQsIHN0cnVjdCBteV92YWx1ZSwg
MTAwMCwgTk9fUFJFQUxMT0M+IGZvbzsNCmJwZjo6YXJyYXlfbWFwPHN0cnVjdCBteV92YWx1ZSwg
MjAwMD4gYmFyOw0KDQpTb21ldGltZSBrZXkgaXMgbm90IG5lY2Vzc2FyeS4gU29tZXRpbWVzIGZs
YWdzIGhhdmUgdG8gYmUgemVyby4NCmJwZiBzeXNjYWxsIGFwaSBpcyBhIHN1cGVyc2V0IG9mIGFs
bCBmaWVscyBmb3IgYWxsIG1hcHMuDQpBbGwgb2YgdGhlbSBhcmUgY29uZmlndXJhdGlvbiBhbmQg
bWV0YSBmaWVsZHMgYXQgdGhlIHNhbWUgdGltZS4NCkluIGMrKyBleGFtcGxlIHRoZXJlIGlzIHJl
YWxseSBubyBkaWZmZXJlbmNlIGJldHdlZW4NCidzdHJ1Y3QgbXlfdmFsdWUnIGFuZCAnMTAwMCcg
YXR0cmlidXRlcy4NCg0KSSdtIHByZXR0eSBzdXJlIGJwZiB3aWxsIGhhdmUgQysrIGZyb250LWVu
ZCBpbiB0aGUgZnV0dXJlLA0KYnV0IHVudGlsIHRoZW4gd2UgaGF2ZSB0byBkZWFsIHdpdGggQyBh
bmQsIEkgdGhpbmssIHRoZSBtYXANCmRlZmluaXRpb24gc2hvdWxkIGJlIHRoZSBtb3N0IG5hdHVy
YWwgQyBzeW50YXguDQpJbiB0aGF0IHNlbnNlIHdoYXQgeW91J3JlIHByb3Bvc2luZyB3aXRoIGV4
dGVybjoNCj4gZXh0ZXJuIHN0cnVjdCBteV9rZXkgbXlfa2V5Ow0KPiBleHRlcm4gaW50IHR5cGVf
aW50Ow0KPiANCj4gc3RydWN0IG1hcF9kZWYgew0KPiAgICAgIGludCB0eXBlOw0KPiAgICAgIGlu
dCBtYXhfZW50cmllczsNCj4gICAgICB2b2lkICpidGZfa2V5X3JlZjsNCj4gICAgICB2b2lkICpi
dGZfdmFsX3JlZjsNCj4gfSA9IHsNCj4gICAgICAuLi4NCj4gICAgICAuYnRmX2tleV9yZWYgPSAm
bXlfa2V5LA0KPiAgICAgIC5idGZfdmFsX3JlZiA9ICZ0eXBlX2ludCwNCj4gfTsNCg0KaXMgd29y
c2UgdGhhbg0KDQpzdHJ1Y3QgbWFwX2RlZiB7DQogICAgICAgaW50IHR5cGU7DQogICAgICAgaW50
IG1heF9lbnRyaWVzOw0KICAgICAgIGludCBidGZfa2V5Ow0KICAgICAgIHN0cnVjdCBteV9rZXkg
YnRmX3ZhbHVlOw0KfTsNCg0KaW1vIGV4cGxpY2l0IGtleSBhbmQgdmFsdWUgd291bGQgYmUgaWRl
YWwsDQpidXQgdGhleSB0YWtlIHRvbyBtdWNoIHNwYWNlLiBIZW5jZSBwb2ludGVycw0Kb3IgemVy
byBzaXplZCBhcnJheToNCnN0cnVjdCB7DQogICAgICBpbnQgdHlwZTsNCiAgICAgIGludCBtYXhf
ZW50cmllczsNCiAgICAgIHN0cnVjdCB7DQogICAgICAgIF9fdTMyIGtleTsNCiAgICAgICAgc3Ry
dWN0IG15X3ZhbHVlIHZhbHVlOw0KICAgICAgfSB0eXBlc1tdOw0KfTsNCg0KSSB0aGluayB3ZSBz
aG91bGQgYWxzbyBjb25zaWRlciBleHBsaWNpdCBtYXAgY3JlYXRpb24uDQoNClNvbWV0aGluZyBs
aWtlOg0KDQpzdHJ1Y3QgbXlfbWFwIHsNCiAgIF9fdTMyIGtleTsNCiAgIHN0cnVjdCBteV92YWx1
ZSB2YWx1ZTsNCn0gKm15X2hhc2hfbWFwLCAqbXlfcGlubmVkX2hhc2hfbWFwOw0KDQpzdHJ1Y3Qg
ew0KICAgIF9fdTY0IGtleTsNCiAgIHN0cnVjdCBteV9tYXAgKnZhbHVlOw0KfSAqbXlfaGFzaF9v
Zl9tYXBzOw0KDQpzdHJ1Y3Qgew0KICAgc3RydWN0IG15X21hcCAqdmFsdWU7DQp9ICpteV9hcnJh
eV9vZl9tYXBzOw0KDQpfX2luaXQgdm9pZCBjcmVhdGVfbXlfbWFwcyh2b2lkKQ0Kew0KICAgYnBm
X2NyZWF0ZV9oYXNoX21hcCgmbXlfaGFzaF9tYXAsIDEwMDAvKm1heF9lbnRyaWVzKi8pOw0KICAg
YnBmX29ial9nZXQoJm15X3Bpbm5lZF9oYXNoX21hcCwgIi9zeXMvZnMvYnBmL215X21hcCIpOw0K
ICAgYnBmX2NyZWF0ZV9oYXNoX29mX21hcHMoJm15X2hhc2hfb2ZfbWFwcywgMTAwMC8qbWF4X2Vu
dHJpZXMqLyk7DQogICBicGZfY3JlYXRlX2FycmF5X29mX21hcHMoJm15X2FycmF5X29mX21hcHMs
IDIwKTsNCn0NCg0KU0VDKCJjZ3JvdXAvc2tiIikNCmludCBicGZfcHJvZyhzdHJ1Y3QgX19za19i
dWZmICpza2IpDQp7DQogICBzdHJ1Y3QgbXlfdmFsdWUgKnZhbDsNCiAgIF9fdTMyIGtleTsNCiAg
IF9fdTY0IGtleTY0Ow0KICAgc3RydWN0IG15X21hcCAqbWFwOw0KDQogICB2YWwgPSBicGZfbWFw
X2xvb2t1cChteV9oYXNoX21hcCwgJmtleSk7DQogICBtYXAgPSBicGZfbWFwX2xvb2t1cChteV9o
YXNoX29mX21hcHMsICZrZXk2NCk7DQp9DQoNCidfX2luaXQnIHNlY3Rpb24gd2lsbCBiZSBjb21w
aWxlZCBieSBsbHZtIGludG8gYnBmIGluc3RydWN0aW9ucw0KdGhhdCB3aWxsIGJlIGV4ZWN1dGVk
IGluIHVzZXJzIHNwYWNlIGJ5IGxpYmJwZi4NClRoZSBfX2luaXQgcHJvZyBoYXMgdG8gc3VjY2Vl
ZCBvdGhlcndpc2UgcHJvZyBsb2FkIGZhaWxzLg0KDQpNYXkgYmUgYWxsIG1hcCBwb2ludGVycyBz
aG91bGQgYmUgaW4gYSBzcGVjaWFsIHNlY3Rpb24gdG8gYXZvaWQNCnB1dHRpbmcgdGhlbSBpbnRv
IGRhdGFzZWMsIGJ1dCBsaWJicGYgc2hvdWxkIGJlIGFibGUgdG8gZmlndXJlIHRoYXQNCm91dCB3
aXRob3V0IHJlcXVpcmluZyB1c2VyIHRvIHNwZWNpZnkgdGhlIC5tYXAgc2VjdGlvbi4NClRoZSBy
ZXN0IG9mIGdsb2JhbCB2YXJzIHdvdWxkIGdvIGludG8gc3BlY2lhbCBkYXRhc2VjIG1hcC4NCg0K
Tm8gbGx2bSBjaGFuZ2VzIG5lY2Vzc2FyeSBhbmQgQlRGIGlzIGF2YWlsYWJsZSBmb3Iga2V5cyBh
bmQgdmFsdWVzLg0KDQpsaWJicGYgY2FuIHN0YXJ0IHdpdGggc2ltcGxlIF9faW5pdCBhbmQgZXZl
bnR1YWxseSBncm93IGludG8NCmNvbXBsZXggaW5pdCBwcm9jZWR1cmUgd2hlcmUgbWFwcyBhcmUg
aW5pdGlhbGl6ZWQsDQpwcm9nX2FycmF5IGlzIHBvcHVsYXRlZCwgZXRjLg0KDQpUaG91Z2h0cz8N
Cg==
