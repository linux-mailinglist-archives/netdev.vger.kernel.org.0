Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CC586B56
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404750AbfHHUVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:21:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16322 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404467AbfHHUVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 16:21:38 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78KIgCk017958;
        Thu, 8 Aug 2019 13:21:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=a4fAOkBCu/wBavdnwlCmmZd3RxMpwxPxgsDZWB4Xp8I=;
 b=PWa1Khas6PpjV4hKyieg/Mb7si41Vm6MPcPIbYHUWmKpteRwfEJnx/a/lu8UnUFcUvF3
 gsSiF2Pal0bEkwYZlI2iVAizSTJXWSGTkJF3UGUzTim4tVIfNI93I2WeX7fFQg6FvgE5
 1K2x4kzEmzoHM0L/8GW6Andy6VP65BKK1rw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u8sung5x8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 13:21:06 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 8 Aug 2019 13:21:04 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Aug 2019 13:21:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kct9kqSS6Qh5bjVmscsbWtfVm9AChDAAVrpULSA8LPKHUUkX3uKpwnKcD6y4kLyzxpIHuPE4Wc7w9nsc4nsSDgaG2x5s3ZOGrnnhoRjoxAtCqU028+hkHc0mAR5mZaVfuhqxIGJNUycX++6p5vspglSHkjtE8tWHudEfenlpIxcd+RmsAqUjQXE9dvzl3PWBmgtKapSnDVLxID7XNNzCFJ7GeLsNusDarzcsyzLgWaaePZ+fpdFX7uuCEEHiV73uPVPaTjxwvlPB2h8+5JKuoFXcb3+gMx4cM3aGfiuREfJ1t4xYpT97QQakmxWoeb3yd0Seq6Iwmbzo8zK2O1LNMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4fAOkBCu/wBavdnwlCmmZd3RxMpwxPxgsDZWB4Xp8I=;
 b=a/VRbJSoyEnzZmYfOUfZ3M5QmjcNAaaie5FUrlj/1axdN6rgZ8MIckNVCGE1KdeH8BG3SMBfGsFIfMdoi5QIKN0/HIxWK3N+E745fMXDOjh53ex+AGnYLrvIKfo1LFlzxsYrNHHgZFLBzj0JctlD4zFWDYD3KBBkngWG7WTMzEXAmO/HYQZuaMUKlvdbcQXR0XI/hadJsGS+G4qwMBUce3yL6kNG/x02E+6H1WtjbAsbICwoy3d0R08Lxzi8YLMh1FfsTaMUkx8JhFo/POiDBReGRYU0DOfzxHndNMWlagHvB+b4c1wKJ+D3M1zYmSyK43CBnQBDPxiq4NlLar6J+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4fAOkBCu/wBavdnwlCmmZd3RxMpwxPxgsDZWB4Xp8I=;
 b=E2WiFZT/LdNZ1iRlRrBSFP25y9tIvO8h+oqYN2DP+d9C6yVJ0Q+vDSB86sYX3LwHgc615i/pNAwAkqzvPnQEoaxEWUqzVBBQIxSwX5NSyjalZ0CKfQxINho7kDFpE+cqUQiHQRU3zakiqcZwyOu6DzqLfKpZeROWsm+FgVuBa1M=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2727.namprd15.prod.outlook.com (20.179.157.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Thu, 8 Aug 2019 20:21:03 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2136.022; Thu, 8 Aug 2019
 20:21:03 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 bpf-next] btf: expose BTF info through sysfs
Thread-Topic: [PATCH v2 bpf-next] btf: expose BTF info through sysfs
Thread-Index: AQHVTYGIGwiYbvGVIUem2Q2gdqcpWabwMe+AgAFVzoCAACrUgA==
Date:   Thu, 8 Aug 2019 20:21:02 +0000
Message-ID: <9cde90e5-2831-0195-748c-b3325cbe1a1e@fb.com>
References: <20190808003215.1462821-1-andriin@fb.com>
 <89a6e282-0250-4264-128d-469be99073e9@fb.com>
 <CAEf4BzYAZ7x+PY0t90ty9RVSm1FSmc9XqY216DtJCA-giK3fUg@mail.gmail.com>
In-Reply-To: <CAEf4BzYAZ7x+PY0t90ty9RVSm1FSmc9XqY216DtJCA-giK3fUg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0004.namprd10.prod.outlook.com (2603:10b6:301::14)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:8bce]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be2c5036-1b79-484a-6f75-08d71c3deed6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2727;
x-ms-traffictypediagnostic: BYAPR15MB2727:
x-microsoft-antispam-prvs: <BYAPR15MB2727D144E091BDA0C54DAEACD3D70@BYAPR15MB2727.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(366004)(136003)(39860400002)(189003)(199004)(66476007)(31696002)(64756008)(66556008)(66446008)(66946007)(14444005)(6116002)(256004)(2906002)(229853002)(5660300002)(86362001)(99286004)(316002)(36756003)(54906003)(305945005)(46003)(478600001)(52116002)(102836004)(76176011)(53936002)(186003)(71200400001)(71190400001)(53546011)(11346002)(6916009)(386003)(446003)(2616005)(476003)(6506007)(14454004)(6512007)(6436002)(31686004)(486006)(6486002)(6246003)(7736002)(25786009)(8676002)(8936002)(4326008)(81156014)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2727;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1t1/mOfV2rIyjuKCB+1Fyr3DkRoyHexAkFQPsWGGuUn8dJbLC/CbIMy/vGah7ynKSyUBekOoYHAonFKjpGeiPUtT6BiXRfMVzhMt0DgX9lxghNdEulJxhr7Df4qBvmdJBgnCQwu1IaMdPQHubuwTc+ZaJex+JthBJ8nLu1yK5uHWMhdkx3LmeCKsMRh7YvqIojib6aoipSa+jZmy5Ubcw2G/Soybkn9Z+KXj13TQl7vuzY/LavxnkUuHxmyjzTTXoBESVWWKrDA71wqKlJF8o0860WppHJ8ucwu4nJGOsNQtWHZKZ1ug07hz+C40bCvWfcIL7e2PvjYZENqFAphX6c//djx37icWiJVXVjVGpGe/sGfPv8MhU1+pIT+0+cYm4aTLA5Qm0EEzr5ZVqTd/s1ew2WtGj6oElCuwhnkoems=
Content-Type: text/plain; charset="utf-8"
Content-ID: <915B806A026F7541ACBBBAD2F258DA3B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: be2c5036-1b79-484a-6f75-08d71c3deed6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:21:02.6685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=890 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvOC8xOSAxMDo0NyBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBXZWQs
IEF1ZyA3LCAyMDE5IGF0IDk6MjQgUE0gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3JvdGU6
DQo+Pg0KPj4NCj4+DQo+PiBPbiA4LzcvMTkgNTozMiBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3Rl
Og0KPj4+IE1ha2UgLkJURiBzZWN0aW9uIGFsbG9jYXRlZCBhbmQgZXhwb3NlIGl0cyBjb250ZW50
cyB0aHJvdWdoIHN5c2ZzLg0KPj4+DQo+Pj4gL3N5cy9rZXJuZWwvYnRmIGRpcmVjdG9yeSBpcyBj
cmVhdGVkIHRvIGNvbnRhaW4gYWxsIHRoZSBCVEZzIHByZXNlbnQNCj4+PiBpbnNpZGUga2VybmVs
LiBDdXJyZW50bHkgdGhlcmUgaXMgb25seSBrZXJuZWwncyBtYWluIEJURiwgcmVwcmVzZW50ZWQg
YXMNCj4+PiAvc3lzL2tlcm5lbC9idGYva2VybmVsIGZpbGUuIE9uY2Uga2VybmVsIG1vZHVsZXMn
IEJURnMgYXJlIHN1cHBvcnRlZCwNCj4+PiBlYWNoIG1vZHVsZSB3aWxsIGV4cG9zZSBpdHMgQlRG
IGFzIC9zeXMva2VybmVsL2J0Zi88bW9kdWxlLW5hbWU+IGZpbGUuDQo+Pj4NCj4+PiBDdXJyZW50
IGFwcHJvYWNoIHJlbGllcyBvbiBhIGZldyBwaWVjZXMgY29taW5nIHRvZ2V0aGVyOg0KPj4+IDEu
IHBhaG9sZSBpcyB1c2VkIHRvIHRha2UgYWxtb3N0IGZpbmFsIHZtbGludXggaW1hZ2UgKG1vZHVs
byAuQlRGIGFuZA0KPj4+ICAgICAga2FsbHN5bXMpIGFuZCBnZW5lcmF0ZSAuQlRGIHNlY3Rpb24g
YnkgY29udmVydGluZyBEV0FSRiBpbmZvIGludG8NCj4+PiAgICAgIEJURi4gVGhpcyBzZWN0aW9u
IGlzIG5vdCBhbGxvY2F0ZWQgYW5kIG5vdCBtYXBwZWQgdG8gYW55IHNlZ21lbnQsDQo+Pj4gICAg
ICB0aG91Z2gsIHNvIGlzIG5vdCB5ZXQgYWNjZXNzaWJsZSBmcm9tIGluc2lkZSBrZXJuZWwgYXQg
cnVudGltZS4NCj4+PiAyLiBvYmpjb3B5IGR1bXBzIC5CVEYgY29udGVudHMgaW50byBiaW5hcnkg
ZmlsZSBhbmQgc3Vic2VxdWVudGx5DQo+Pj4gICAgICBjb252ZXJ0IGJpbmFyeSBmaWxlIGludG8g
bGlua2FibGUgb2JqZWN0IGZpbGUgd2l0aCBhdXRvbWF0aWNhbGx5DQo+Pj4gICAgICBnZW5lcmF0
ZWQgc3ltYm9scyBfYmluYXJ5X19idGZfa2VybmVsX2Jpbl9zdGFydCBhbmQNCj4+PiAgICAgIF9i
aW5hcnlfX2J0Zl9rZXJuZWxfYmluX2VuZCwgcG9pbnRpbmcgdG8gc3RhcnQgYW5kIGVuZCwgcmVz
cGVjdGl2ZWx5LA0KPj4+ICAgICAgb2YgQlRGIHJhdyBkYXRhLg0KPj4+IDMuIGZpbmFsIHZtbGlu
dXggaW1hZ2UgaXMgZ2VuZXJhdGVkIGJ5IGxpbmtpbmcgdGhpcyBvYmplY3QgZmlsZSAoYW5kDQo+
Pj4gICAgICBrYWxsc3ltcywgaWYgbmVjZXNzYXJ5KS4gc3lzZnNfYnRmLmMgdGhlbiBjcmVhdGVz
DQo+Pj4gICAgICAvc3lzL2tlcm5lbC9idGYva2VybmVsIGZpbGUgYW5kIGV4cG9zZXMgZW1iZWRk
ZWQgQlRGIGNvbnRlbnRzIHRocm91Z2gNCj4+PiAgICAgIGl0LiBUaGlzIGFsbG93cywgZS5nLiwg
bGliYnBmIGFuZCBicGZ0b29sIGFjY2VzcyBCVEYgaW5mbyBhdA0KPj4+ICAgICAgd2VsbC1rbm93
biBsb2NhdGlvbiwgd2l0aG91dCByZXNvcnRpbmcgdG8gc2VhcmNoaW5nIGZvciB2bWxpbnV4IGlt
YWdlDQo+Pj4gICAgICBvbiBkaXNrIChsb2NhdGlvbiBvZiB3aGljaCBpcyBub3Qgc3RhbmRhcmRp
emVkIGFuZCB2bWxpbnV4IGltYWdlDQo+Pj4gICAgICBtaWdodCBub3QgYmUgZXZlbiBhdmFpbGFi
bGUgaW4gc29tZSBzY2VuYXJpb3MsIGUuZy4sIGluc2lkZSBxZW11DQo+Pj4gICAgICBkdXJpbmcg
dGVzdGluZykuDQo+Pj4NCj4+PiBBbHRlcm5hdGl2ZSBhcHByb2FjaCB1c2luZyAuaW5jYmluIGFz
c2VtYmxlciBkaXJlY3RpdmUgdG8gZW1iZWQgQlRGDQo+Pj4gY29udGVudHMgZGlyZWN0bHkgd2Fz
IGF0dGVtcHRlZCBidXQgZGlkbid0IHdvcmssIGJlY2F1c2Ugc3lzZnNfcHJvYy5vIGlzDQo+Pj4g
bm90IHJlLWNvbXBpbGVkIGR1cmluZyBsaW5rLXZtbGludXguc2ggc3RhZ2UuIFRoaXMgaXMgcmVx
dWlyZWQsIHRob3VnaCwNCj4+PiB0byB1cGRhdGUgZW1iZWRkZWQgQlRGIGRhdGEgKGluaXRpYWxs
eSBlbXB0eSBkYXRhIGlzIGVtYmVkZGVkLCB0aGVuDQo+Pj4gcGFob2xlIGdlbmVyYXRlcyBCVEYg
aW5mbyBhbmQgd2UgbmVlZCB0byByZWdlbmVyYXRlIHN5c2ZzX2J0Zi5vIHdpdGgNCj4+PiB1cGRh
dGVkIGNvbnRlbnRzLCBidXQgaXQncyB0b28gbGF0ZSBhdCB0aGF0IHBvaW50KS4NCj4+Pg0KPj4+
IElmIEJURiBjb3VsZG4ndCBiZSBnZW5lcmF0ZWQgZHVlIHRvIG1pc3Npbmcgb3IgdG9vIG9sZCBw
YWhvbGUsDQo+Pj4gc3lzZnNfYnRmLmMgaGFuZGxlcyB0aGF0IGdyYWNlZnVsbHkgYnkgZGV0ZWN0
aW5nIHRoYXQNCj4+PiBfYmluYXJ5X19idGZfa2VybmVsX2Jpbl9zdGFydCAod2VhayBzeW1ib2wp
IGlzIDAgYW5kIG5vdCBjcmVhdGluZw0KPj4+IC9zeXMva2VybmVsL2J0ZiBhdCBhbGwuDQo+Pj4N
Cj4+PiB2MS0+djI6DQo+Pj4gLSBhbGxvdyBrYWxsc3ltcyBzdGFnZSB0byByZS11c2Ugdm1saW51
eCBnZW5lcmF0ZWQgYnkgZ2VuX2J0ZigpOw0KPj4+DQo+Pj4gQ2M6IE1hc2FoaXJvIFlhbWFkYSA8
eWFtYWRhLm1hc2FoaXJvQHNvY2lvbmV4dC5jb20+DQo+Pj4gQ2M6IEFybmFsZG8gQ2FydmFsaG8g
ZGUgTWVsbyA8YWNtZUByZWRoYXQuY29tPg0KPj4+IENjOiBKaXJpIE9sc2EgPGpvbHNhQGtlcm5l
bC5vcmc+DQo+Pj4gQ2M6IFNhbSBSYXZuYm9yZyA8c2FtQHJhdm5ib3JnLm9yZz4NCj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KPj4+IC0tLQ0KPiAN
Cj4gWy4uLl0NCj4gDQo+Pj4gKw0KPj4+ICsgICAgICMgZHVtcCAuQlRGIHNlY3Rpb24gaW50byBy
YXcgYmluYXJ5IGZpbGUgdG8gbGluayB3aXRoIGZpbmFsIHZtbGludXgNCj4+PiArICAgICBiaW5f
YXJjaD0kKCR7T0JKRFVNUH0gLWYgJHsxfSB8IGdyZXAgYXJjaGl0ZWN0dXJlIHwgXA0KPj4+ICsg
ICAgICAgICAgICAgY3V0IC1kLCAtZjEgfCBjdXQgLWQnICcgLWYyKQ0KPj4+ICsgICAgICR7T0JK
Q09QWX0gLS1kdW1wLXNlY3Rpb24gLkJURj0uYnRmLmtlcm5lbC5iaW4gJHsxfSAyPi9kZXYvbnVs
bA0KPj4+ICsgICAgICR7T0JKQ09QWX0gLUkgYmluYXJ5IC1PICR7Q09ORklHX09VVFBVVF9GT1JN
QVR9IC1CICR7YmluX2FyY2h9IFwNCj4+PiArICAgICAgICAgICAgIC0tcmVuYW1lLXNlY3Rpb24g
LmRhdGE9LkJURiAuYnRmLmtlcm5lbC5iaW4gJHsyfQ0KPj4NCj4+IEN1cnJlbnRseSwgdGhlIGJp
bmFyeSBzaXplIG9uIG15IGNvbmZpZyBpcyBhYm91dCAyLjZNQi4gRG8geW91IHRoaW5rDQo+PiB3
ZSBjb3VsZCBvciBuZWVkIHRvIGNvbXByZXNzIGl0IHRvIG1ha2UgaXQgc21hbGxlcj8gSSB0cmll
ZCBnemlwDQo+PiBhbmQgdGhlIGNvbXByZXNzZWQgc2l6ZSBpcyAwLjlNQi4NCj4gDQo+IEknZCBy
ZWFsbHkgcHJlZmVyIHRvIGtlZXAgaXQgdW5jb21wcmVzc2VkIGZvciB0d28gbWFpbiByZWFzb25z
Og0KPiAtIGJ5IGhhdmluZyB0aGlzIGluIHVuY29tcHJlc3NlZCBmb3JtLCBrZXJuZWwgaXRzZWxm
IGNhbiB1c2UgdGhpcyBCVEYNCj4gZGF0YSBmcm9tIGluc2lkZSB3aXRoIGFsbW9zdCBubyBhZGRp
dGlvbmFsIG1lbW9yeSAoZXhjZXB0IG1heWJlIGZvcg0KPiBpbmRleCBmcm9tIHR5cGUgSUQgdG8g
YWN0dWFsIGxvY2F0aW9uIG9mIHR5cGUgaW5mbyksIHdoaWNoIG9wZW5zIHVwIGENCj4gbG90IG9m
IG5ldyBhbmQgaW50ZXJlc3Rpbmcgb3Bwb3J0dW5pdGllcywgbGlrZSBrZXJuZWwgcmV0dXJuaW5n
IGl0cw0KPiBvd24gQlRGIGFuZCBCVEYgdHlwZSBJRCBmb3IgdmFyaW91cyB0eXBlcyAodGhpbmsg
YWJvdXQgZHJpdmVyIG1ldGRhdGEsDQo+IGFsbCB0aG9zZSBzcGVjaWFsIG1hcHMsIGV0YykuDQo+
IC0gaWYgd2UgYXJlIGRvaW5nIGNvbXByZXNzaW9uLCBub3cgd2UgbmVlZCB0byBkZWNpZGUgb24g
YmVzdA0KPiBjb21wcmVzc2lvbiBmb3JtYXQsIHRlYWNoIGl0IGxpYmJwZiAod2hpY2ggd2lsbCBt
YWtlIGxpYmJwZiBhbHNvDQo+IGJpZ2dlciBhbmQgZGVwZW5kaW5nIG9uIGV4dHJhIGxpYnJhcmll
cyksIGV0Yy4NCj4gDQo+IFNvIGJhc2ljYWxseSwgaW4gZXhjaGFuZ2Ugb2YgMS0xLjVNQiBleHRy
YSBtZW1vcnkgd2UgZ2V0IGEgYnVuY2ggb2YNCj4gbmV3IHByb2JsZW1zIHdlIG5vcm1hbGx5IGRv
bid0IGhhdmUgdG8gZGVhbCB3aXRoLg0KDQpZZXMsIEkgYW0gYXdhcmUgb2YgdGhpcyB0cmFkZW9m
Zi4gSnVzdCB0byBtYWtlIHN1cmUgdGhpcyBoYXMgYmVlbiANCmRpc2N1c3NlZC4gSSBhbSB0b3Rh
bGx5IGZpbmUgd2l0aCBsZWF2aW5nIGl0IHVuY29tcHJlc3NlZC4NCg0KPiANCj4+DQo+Pj4gICAg
fQ0KPj4+DQo+Pj4gICAgIyBDcmVhdGUgJHsyfSAubyBmaWxlIHdpdGggYWxsIHN5bWJvbHMgZnJv
bSB0aGUgJHsxfSBvYmplY3QgZmlsZQ0KPj4+IEBAIC0xNTMsNiArMTY0LDcgQEAgc29ydGV4dGFi
bGUoKQ0KPj4+ICAgICMgRGVsZXRlIG91dHB1dCBmaWxlcyBpbiBjYXNlIG9mIGVycm9yDQo+Pj4g
ICAgY2xlYW51cCgpDQo+Pj4gICAgew0KPiANCj4gWy4uLl0NCj4gDQo=
