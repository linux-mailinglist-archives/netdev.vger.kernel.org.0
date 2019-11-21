Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3668B1059CE
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 19:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfKUSnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 13:43:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49976 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKUSnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 13:43:39 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALIeVHd020436;
        Thu, 21 Nov 2019 10:43:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QTUGhwPE3PG4dWl/gXawzoBH1gn7/lUFtpD9eyHaMWU=;
 b=ZCH6Q1v0j29uQwXOd17WWfVc3thVNFFvyMDRUr1Ry9jvIu1b7D0A3Nn/5zF/jABkHEuD
 9xZRfwTCK/gl7JHWzSSBVb5s3FlOqqNI4asXhLipuxtYpGtI9GpLH4/aHqqhoEIDJzyU
 /h0ZcgQa1xpbE2btCXgtlyKgjsOmravjCKs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wdxtm0esr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Nov 2019 10:43:21 -0800
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 Nov 2019 10:43:20 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 10:43:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4vNvE6bMSrTcKkDdFO1YlIGjg5Sn3FkJQ8Dbf4O/nlYkydoo52pIzPeZZT12tM1UqfmMA2y4+cx0V1cHKPnc61r5BMVw7UshoLyPp+zQN/B6pz7E6sbbolASVFEYoaqqYusbuhCCoN0xYjp+6S7oymBF44/B5x8d9k+xplRlBm0i8OXNDVYwJnz0qmnTp7yZVTWWFNGuxcabgj1eZkn37NFw/lCTfC2WYqt7ToLKP2gfRA2JMCThh3hTjD65n1g8c4Ktvj/VtPF6dw0EpsvsEtad30YFdUN4X3cY8Grwzr1ZqVH6BJ/j8WaMNrgPwDjGlM/3vbS/7ohHd9N2VI39Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTUGhwPE3PG4dWl/gXawzoBH1gn7/lUFtpD9eyHaMWU=;
 b=QRp7QvRThAJdswU+kU3AjU2UTJv9JGAatSHMldMl21IRzxQCqOyYtS2LDtgDaPgw/VRNk2KIlGQf3JP86OmjEHnK6iv9bICdDnWccjFDqUxdStprAuZxN0QZPCG2qtZ+/YUYXv9iuvzMfB9lcN4QeNdJZbOKbxXu9bXfoH+hCa1ncLjoJXi3k8b7+WcgpwUEFkj9z//4+iAdHJvOtaNAOnLet3jM5KbGtNJgwMknUGmFd85OeNrzOv1WaaV1ba4LvpLIL8i7iAe2Wk4i8PIYpWqzcEup2039WUuxBO5J/ZcXGqdLtVZyisOvAcCHSpomWZd7Um8S7GLZd2p6v8FywQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTUGhwPE3PG4dWl/gXawzoBH1gn7/lUFtpD9eyHaMWU=;
 b=FHjOn1wCoSPGcxpmH7qB+lYo3d4rV7Ug0vy3Krd6q24e2x1s7V4KM4j2EaEuoUVv/UzRcAT2iVleviPWssOMHX7Zvp7STmY14+RtgLk0Bt4Qg2RPA9lYTE+46xoWY1GcmEfB7aQFAo5ydGy7EJbfP/AXMNdBB0XcdTK5ClzS7Nc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2727.namprd15.prod.outlook.com (20.179.158.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Thu, 21 Nov 2019 18:43:19 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680%4]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 18:43:19 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 9/9] selftests/bpf: add batch ops testing to
 array bpf map
Thread-Topic: [PATCH v2 bpf-next 9/9] selftests/bpf: add batch ops testing to
 array bpf map
Thread-Index: AQHVnw/0rnKpbCfcfky9UVTXU5Cf8qeV+PIA
Date:   Thu, 21 Nov 2019 18:43:19 +0000
Message-ID: <4688ba20-0730-7689-9332-aa0dcef5258e@fb.com>
References: <20191119193036.92831-1-brianvv@google.com>
 <20191119193036.92831-10-brianvv@google.com>
In-Reply-To: <20191119193036.92831-10-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0194.namprd04.prod.outlook.com
 (2603:10b6:104:5::24) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:b385]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1be46b8-fff1-4f06-37de-08d76eb2ad7b
x-ms-traffictypediagnostic: BYAPR15MB2727:
x-microsoft-antispam-prvs: <BYAPR15MB27279F758A5E08DA0626FFEED34E0@BYAPR15MB2727.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:241;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(396003)(39860400002)(136003)(199004)(189003)(81166006)(8936002)(6512007)(76176011)(7736002)(305945005)(66446008)(478600001)(66556008)(256004)(6436002)(52116002)(31686004)(7416002)(2906002)(14454004)(64756008)(46003)(8676002)(2616005)(229853002)(86362001)(66946007)(31696002)(446003)(81156014)(6486002)(102836004)(11346002)(53546011)(99286004)(186003)(6506007)(386003)(4326008)(66476007)(25786009)(6246003)(71190400001)(36756003)(5660300002)(316002)(6116002)(54906003)(110136005)(14444005)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2727;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0qvLGr1lPI48wgp5B6hn9omN9ZDc602+rP5mlDC445UJL3PFf42YCoUwdWrumR2+M4r2qZhc48gQNxbTtFpOea7DfaaEsVFeLS9UWWWyLLSWZJVSR4GYPe2bMv4BrsGq/iVroN71bhnwROy4b9BPl0Pd6fnlbwJTDhnSVTc8GnNMNZ4waU282W84V3L1GlW7lj/xtQQBZkcLhSGc1QAWvX0aNLHYrM+zz98nNaEBrP0MW8lMdVWvJTAUmZMf+IaIELJYlhaHtqyauWJt23wyghnblzpvHeNMEgTUEHbwvxVgWtWgN2pkmexNCye4O4ldfOs6hlfwAAUbHV2/o50iscPxMV4uv7z/VNN808XLgRzTJ0bk3ikFZL8pNdWHvZZJyUM4JKQNqwSD6SDqzwni7IqW52uRWpRsyyx/RU5bl/AYgL2HkKYjLv5ezHQT93Mi
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B7E9C96220BCE4F87ABB45694F935A9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f1be46b8-fff1-4f06-37de-08d76eb2ad7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 18:43:19.0871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qm1vWQcAMO4819c5x6jc+v6tR1FQOl5L2G6+JuHoMZ8EUYNFi03i4QtM2N2LzHLZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_05:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzE5LzE5IDExOjMwIEFNLCBCcmlhbiBWYXpxdWV6IHdyb3RlOg0KPiBUZXN0ZWQg
YnBmX21hcF9sb29rdXBfYmF0Y2goKSBhbmQgYnBmX21hcF91cGRhdGVfYmF0Y2goKQ0KPiBmdW5j
dGlvbmFsaXR5Lg0KPiANCj4gICAgJCAuL3Rlc3RfbWFwcw0KPiAgICAgICAgLi4uDQo+ICAgICAg
ICAgIHRlc3RfbWFwX2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNoX2FycmF5OlBBU1MNCj4gICAgICAg
IC4uLg0KDQpUaGUgdGVzdCBpcyBmb3IgbG9va3VwX2JhdGNoKCkgYW5kIHVwZGF0ZV9iYXRjaCgp
DQphbmQgdGhlIHRlc3QgbmFtZSBhbmQgZnVuYyBuYW1lIGlzIGxvb2t1cF9hbmRfZGVsZXRlX2Jh
dGNoKCksDQpwcm9iYWJseSByZW5hbWUgaXMgdG8gbG9va3VwX2FuZF91cGRhdGVfYmF0Y2hfYXJy
YXkoKT8NCg0KSXQgd291bGQgYmUgZ29vZCBpZiBnZW5lcmljIGxvb2t1cF9hbmRfZGVsZXRlX2Jh
dGNoKCkNCmFuZCBkZWxldGVfcGF0Y2goKSBjYW4gYmUgdGVzdGVkIGFzIHdlbGwuDQpNYXliZSB0
cmllZCB0byB1c2UgcHJvZ19hcnJheT8NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQnJpYW4gVmF6
cXVleiA8YnJpYW52dkBnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBZb25naG9uZyBTb25n
IDx5aHNAZmIuY29tPg0KPiAtLS0NCj4gICAuLi4vbWFwX2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNo
X2FycmF5LmMgICAgICAgfCAxMTkgKysrKysrKysrKysrKysrKysrDQo+ICAgMSBmaWxlIGNoYW5n
ZWQsIDExOSBpbnNlcnRpb25zKCspDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rp
bmcvc2VsZnRlc3RzL2JwZi9tYXBfdGVzdHMvbWFwX2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNoX2Fy
cmF5LmMNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvbWFw
X3Rlc3RzL21hcF9sb29rdXBfYW5kX2RlbGV0ZV9iYXRjaF9hcnJheS5jIGIvdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMvYnBmL21hcF90ZXN0cy9tYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2hfYXJy
YXkuYw0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAwLi5jYmVj
NzJhZDM4NjA5DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmL21hcF90ZXN0cy9tYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2hfYXJyYXkuYw0KPiBA
QCAtMCwwICsxLDExOSBAQA0KPiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAN
Cj4gKw0KPiArI2luY2x1ZGUgPHN0ZGlvLmg+DQo+ICsjaW5jbHVkZSA8ZXJybm8uaD4NCj4gKyNp
bmNsdWRlIDxzdHJpbmcuaD4NCj4gKw0KPiArI2luY2x1ZGUgPGJwZi9icGYuaD4NCj4gKyNpbmNs
dWRlIDxicGYvbGliYnBmLmg+DQo+ICsNCj4gKyNpbmNsdWRlIDx0ZXN0X21hcHMuaD4NCj4gKw0K
PiArc3RhdGljIHZvaWQgbWFwX2JhdGNoX3VwZGF0ZShpbnQgbWFwX2ZkLCBfX3UzMiBtYXhfZW50
cmllcywgaW50ICprZXlzLA0KPiArCQkJICAgICBpbnQgKnZhbHVlcykNCj4gK3sNCj4gKwlpbnQg
aSwgZXJyOw0KPiArDQo+ICsJZm9yIChpID0gMDsgaSA8IG1heF9lbnRyaWVzOyBpKyspIHsNCj4g
KwkJa2V5c1tpXSA9IGk7DQo+ICsJCXZhbHVlc1tpXSA9IGkgKyAxOw0KPiArCX0NCj4gKw0KPiAr
CWVyciA9IGJwZl9tYXBfdXBkYXRlX2JhdGNoKG1hcF9mZCwga2V5cywgdmFsdWVzLCAmbWF4X2Vu
dHJpZXMsIDAsIDApOw0KPiArCUNIRUNLKGVyciwgImJwZl9tYXBfdXBkYXRlX2JhdGNoKCkiLCAi
ZXJyb3I6JXNcbiIsIHN0cmVycm9yKGVycm5vKSk7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyB2b2lk
IG1hcF9iYXRjaF92ZXJpZnkoaW50ICp2aXNpdGVkLCBfX3UzMiBtYXhfZW50cmllcywNCj4gKwkJ
CSAgICAgaW50ICprZXlzLCBpbnQgKnZhbHVlcykNCj4gK3sNCj4gKwlpbnQgaTsNCj4gKw0KPiAr
CW1lbXNldCh2aXNpdGVkLCAwLCBtYXhfZW50cmllcyAqIHNpemVvZigqdmlzaXRlZCkpOw0KPiAr
CWZvciAoaSA9IDA7IGkgPCBtYXhfZW50cmllczsgaSsrKSB7DQo+ICsJCUNIRUNLKGtleXNbaV0g
KyAxICE9IHZhbHVlc1tpXSwgImtleS92YWx1ZSBjaGVja2luZyIsDQo+ICsJCSAgICAgICJlcnJv
cjogaSAlZCBrZXkgJWQgdmFsdWUgJWRcbiIsIGksIGtleXNbaV0sIHZhbHVlc1tpXSk7DQo+ICsJ
CXZpc2l0ZWRbaV0gPSAxOw0KPiArCX0NCj4gKwlmb3IgKGkgPSAwOyBpIDwgbWF4X2VudHJpZXM7
IGkrKykgew0KPiArCQlDSEVDSyh2aXNpdGVkW2ldICE9IDEsICJ2aXNpdGVkIGNoZWNraW5nIiwN
Cj4gKwkJICAgICAgImVycm9yOiBrZXlzIGFycmF5IGF0IGluZGV4ICVkIG1pc3NpbmdcbiIsIGkp
Ow0KPiArCX0NCj4gK30NCj4gKw0KPiArdm9pZCB0ZXN0X21hcF9sb29rdXBfYW5kX2RlbGV0ZV9i
YXRjaF9hcnJheSh2b2lkKQ0KPiArew0KPiArCXN0cnVjdCBicGZfY3JlYXRlX21hcF9hdHRyIHhh
dHRyID0gew0KPiArCQkubmFtZSA9ICJhcnJheV9tYXAiLA0KPiArCQkubWFwX3R5cGUgPSBCUEZf
TUFQX1RZUEVfQVJSQVksDQo+ICsJCS5rZXlfc2l6ZSA9IHNpemVvZihpbnQpLA0KPiArCQkudmFs
dWVfc2l6ZSA9IHNpemVvZihpbnQpLA0KPiArCX07DQo+ICsJaW50IG1hcF9mZCwgKmtleXMsICp2
YWx1ZXMsICp2aXNpdGVkOw0KPiArCV9fdTMyIGNvdW50LCB0b3RhbCwgdG90YWxfc3VjY2VzczsN
Cj4gKwljb25zdCBfX3UzMiBtYXhfZW50cmllcyA9IDEwOw0KPiArCWludCBlcnIsIGksIHN0ZXA7
DQo+ICsJYm9vbCBub3NwYWNlX2VycjsNCj4gKwlfX3U2NCBiYXRjaCA9IDA7DQo+ICsNCj4gKwl4
YXR0ci5tYXhfZW50cmllcyA9IG1heF9lbnRyaWVzOw0KPiArCW1hcF9mZCA9IGJwZl9jcmVhdGVf
bWFwX3hhdHRyKCZ4YXR0cik7DQo+ICsJQ0hFQ0sobWFwX2ZkID09IC0xLA0KPiArCSAgICAgICJi
cGZfY3JlYXRlX21hcF94YXR0cigpIiwgImVycm9yOiVzXG4iLCBzdHJlcnJvcihlcnJubykpOw0K
PiArDQo+ICsJa2V5cyA9IG1hbGxvYyhtYXhfZW50cmllcyAqIHNpemVvZihpbnQpKTsNCj4gKwl2
YWx1ZXMgPSBtYWxsb2MobWF4X2VudHJpZXMgKiBzaXplb2YoaW50KSk7DQo+ICsJdmlzaXRlZCA9
IG1hbGxvYyhtYXhfZW50cmllcyAqIHNpemVvZihpbnQpKTsNCj4gKwlDSEVDSygha2V5cyB8fCAh
dmFsdWVzIHx8ICF2aXNpdGVkLCAibWFsbG9jKCkiLCAiZXJyb3I6JXNcbiIsDQo+ICsJICAgICAg
c3RyZXJyb3IoZXJybm8pKTsNCj4gKw0KPiArCS8qIHBvcHVsYXRlIGVsZW1lbnRzIHRvIHRoZSBt
YXAgKi8NCj4gKwltYXBfYmF0Y2hfdXBkYXRlKG1hcF9mZCwgbWF4X2VudHJpZXMsIGtleXMsIHZh
bHVlcyk7DQo+ICsNCj4gKwkvKiB0ZXN0IDE6IGxvb2t1cCBpbiBhIGxvb3Agd2l0aCB2YXJpb3Vz
IHN0ZXBzLiAqLw0KPiArCXRvdGFsX3N1Y2Nlc3MgPSAwOw0KPiArCWZvciAoc3RlcCA9IDE7IHN0
ZXAgPCBtYXhfZW50cmllczsgc3RlcCsrKSB7DQo+ICsJCW1hcF9iYXRjaF91cGRhdGUobWFwX2Zk
LCBtYXhfZW50cmllcywga2V5cywgdmFsdWVzKTsNCj4gKwkJbWVtc2V0KGtleXMsIDAsIG1heF9l
bnRyaWVzICogc2l6ZW9mKCprZXlzKSk7DQo+ICsJCW1lbXNldCh2YWx1ZXMsIDAsIG1heF9lbnRy
aWVzICogc2l6ZW9mKCp2YWx1ZXMpKTsNCj4gKwkJYmF0Y2ggPSAwOw0KPiArCQl0b3RhbCA9IDA7
DQo+ICsJCWkgPSAwOw0KPiArCQkvKiBpdGVyYXRpdmVseSBsb29rdXAvZGVsZXRlIGVsZW1lbnRz
IHdpdGggJ3N0ZXAnDQo+ICsJCSAqIGVsZW1lbnRzIGVhY2guDQo+ICsJCSAqLw0KPiArCQljb3Vu
dCA9IHN0ZXA7DQo+ICsJCW5vc3BhY2VfZXJyID0gZmFsc2U7DQo+ICsJCXdoaWxlICh0cnVlKSB7
DQo+ICsJCQllcnIgPSBicGZfbWFwX2xvb2t1cF9iYXRjaChtYXBfZmQsDQo+ICsJCQkJCQl0b3Rh
bCA/ICZiYXRjaCA6IE5VTEwsICZiYXRjaCwNCj4gKwkJCQkJCWtleXMgKyB0b3RhbCwNCj4gKwkJ
CQkJCXZhbHVlcyArIHRvdGFsLA0KPiArCQkJCQkJJmNvdW50LCAwLCAwKTsNCj4gKw0KPiArCQkJ
Q0hFQ0soKGVyciAmJiBlcnJubyAhPSBFTk9FTlQpLCAibG9va3VwIHdpdGggc3RlcHMiLA0KPiAr
CQkJICAgICAgImVycm9yOiAlc1xuIiwgc3RyZXJyb3IoZXJybm8pKTsNCj4gKw0KPiArCQkJdG90
YWwgKz0gY291bnQ7DQo+ICsNCj4gKwkJCWlmIChlcnIpDQo+ICsJCQkJYnJlYWs7DQo+ICsNCj4g
KwkJCWkrKzsNCj4gKwkJfQ0KPiArDQo+ICsJCWlmIChub3NwYWNlX2VyciA9PSB0cnVlKQ0KPiAr
CQkJY29udGludWU7DQo+ICsNCj4gKwkJQ0hFQ0sodG90YWwgIT0gbWF4X2VudHJpZXMsICJsb29r
dXAgd2l0aCBzdGVwcyIsDQo+ICsJCSAgICAgICJ0b3RhbCA9ICV1LCBtYXhfZW50cmllcyA9ICV1
XG4iLCB0b3RhbCwgbWF4X2VudHJpZXMpOw0KPiArDQo+ICsJCW1hcF9iYXRjaF92ZXJpZnkodmlz
aXRlZCwgbWF4X2VudHJpZXMsIGtleXMsIHZhbHVlcyk7DQo+ICsNCj4gKwkJdG90YWxfc3VjY2Vz
cysrOw0KPiArCX0NCj4gKw0KPiArCUNIRUNLKHRvdGFsX3N1Y2Nlc3MgPT0gMCwgImNoZWNrIHRv
dGFsX3N1Y2Nlc3MiLA0KPiArCSAgICAgICJ1bmV4cGVjdGVkIGZhaWx1cmVcbiIpOw0KPiArDQo+
ICsJcHJpbnRmKCIlczpQQVNTXG4iLCBfX2Z1bmNfXyk7DQo+ICt9DQo+IA0K
