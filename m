Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48F6F4DD8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 15:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfKHOK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 09:10:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60518 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbfKHOK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 09:10:26 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8E9IPr013093;
        Fri, 8 Nov 2019 06:10:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yKbz8lzfrhCVQeD2GJvnK9rReDHTfzKvB4YiVXc/U5s=;
 b=i/a3N2F9NpFpZ8074BC07JQWPt+apsqai2WW5ya5GplhYRtexfj9+S0sC28rF8LS7ucT
 GDVzBxeEHuczSW21CAdSvEuyaNlRQ4kRjdqkCOLdlGFt+SbOt3d0iDIcBFP0BN0vRWcC
 jXFvDxaLWn6eWh9nneXaHq/PJ95F8h840MQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0ubud-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Nov 2019 06:10:06 -0800
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 06:09:57 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 06:09:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXSVjZ1x1SS+PVEHOpTNYPDisLd7nqG0K0/CT4XbfHkyCR2De0RcHL88WG3p1HXSKuzJu4o0rzkevn0zcEvwYl2pyPClVp/kmzcb79rBeQ+J42id0BzttLdy02lfvPa2xy/gwjSPmUHg+L48OGyJONjuVBlx3WxJx7O+xfOilFGoW2+EK7rUOeCT6DILp/vABxrTtIa+HpOS3nqqKb5EZigqHuvyhwxtKp8E0Kj70IN/uI9q4ZfUoUnntCvo5+ciGDf6QqWpdCPYnwLrqU0U9Q28DQbxnCjEdK/U83xFilfBZDEiHCuJpnl7Gm6AW5GfUcfa03zf4SwCkkpOCCHe2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKbz8lzfrhCVQeD2GJvnK9rReDHTfzKvB4YiVXc/U5s=;
 b=QctXkA/niUNsZuK3wOXO9ZX55ROIy/JE5hvnN9vUv9w/1zBn2x9jBghvUUgMbEJQcE/zBLZ8SUg7zC0j6p5kkNEDjWfFK3P0fRYOIG6AeLeXKJi1fg9iuN0gR42Qf0Djg131yI9+l7ccWv26Giu55S6XuDOy1pzUwWPuz3qMYevY+jLvrwu505Bc5Zse2EjNX+qCHRzUjLMpVYCcq9E58bBXIUmKpphFwYqWGkf0HTLGd1XTaTaAE0H/bGVTynq7bHNqLSlOZ/S+aKe++pH/pQ/p9pbF7gUeEcp0uPQfhIgfBa3DV2QSJLYlhjuQuFGeHjkYSQHm3puJMUIjeqPQAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKbz8lzfrhCVQeD2GJvnK9rReDHTfzKvB4YiVXc/U5s=;
 b=ZOCjtKxQKnml/5MOi64BPmurRk3tnNj5sn6oqj1RhOXUqy1/czI5ZRhTbocrSNsHJ+ElhqB5+JtnkAOS/O4dyp5Ys/PloxnXwnKLnTtf/Gf6PeRAOLf/rdlTOUvfhM5dd4qVhvis602vqIN+Q6N5eWM/gbFfiNpsGL/u+aifqv0=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2357.namprd15.prod.outlook.com (52.135.193.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Fri, 8 Nov 2019 14:09:56 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 14:09:56 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Thread-Topic: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Thread-Index: AQHVlf98WlPtScUlMU6IdXfmoHd8+aeA77uAgABgpYA=
Date:   Fri, 8 Nov 2019 14:09:56 +0000
Message-ID: <1c41496a-314e-d8d1-c93e-522c9fa16394@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-3-ast@kernel.org>
 <CAJ+HfNhOBCamXzMV0XKmVUeDFvdEJXpDHdVCNsdTb6PFRP7Hqg@mail.gmail.com>
In-Reply-To: <CAJ+HfNhOBCamXzMV0XKmVUeDFvdEJXpDHdVCNsdTb6PFRP7Hqg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0040.namprd21.prod.outlook.com
 (2603:10b6:300:129::26) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a68e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 370061b9-6f2c-4dff-dd0c-08d764555520
x-ms-traffictypediagnostic: BYAPR15MB2357:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB235709300234E7FA05403F2FD77B0@BYAPR15MB2357.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(376002)(346002)(366004)(189003)(199004)(478600001)(186003)(2906002)(86362001)(46003)(31686004)(66574012)(6116002)(446003)(14454004)(486006)(476003)(2616005)(11346002)(36756003)(4326008)(25786009)(52116002)(102836004)(6506007)(53546011)(386003)(7736002)(305945005)(71200400001)(71190400001)(76176011)(256004)(31696002)(14444005)(6246003)(6512007)(6436002)(6486002)(8936002)(99286004)(66476007)(66556008)(66446008)(229853002)(64756008)(66946007)(81156014)(81166006)(316002)(8676002)(54906003)(110136005)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2357;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k9ONK+XT6grSLmnjKNbMt/dQjeBh/lczBH83eCTNuM+BJ+A7edagSRd+asuYfmmcD38GdFtCeTQBvFYnPGzPaPUvwyLnQOiTArEb+/TjeK3RAwez11Pvnq2BCBWOFyb1B2wS6GEy0iV/P9Kz9eY6+1RRAzL/y1BF4KsQi1yW3NdH/sL4VvSde+e3MInXDTYma+VPzatUqlLSRJ2y66+6I6m8Kc93UA9x8+f8lbwCM4EXrS/BLIJ2ntvE9WWjzY/jWh7kzea/66J/mIZ/1lr9Dgz2ejTKyI9JfyQcp+mfNfsddi3ZcyA7FzdxwZzgFrymnDaFq3FBhoAvWA0qtUecKhFuEaQEdO221DE73kYKqdIcqAcAXBcQrhsbPMfJzHOjDMcawmHZ22E95sBYaF67Z1Ue1V6hrPLk68CxDipaLMW3vRZfMhX1PsP1NRlxuchk
Content-Type: text/plain; charset="utf-8"
Content-ID: <64E5E6DA8F56A64EAEB92D87DCCC0D52@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 370061b9-6f2c-4dff-dd0c-08d764555520
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 14:09:56.1538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wj3Es2PvQ9ho5vvVPMinBwjiAU+7FjvCCdyzxMVYtU9mUOArl4IAmp8EHff34Vv+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2357
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_04:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvOC8xOSAxMjoyMyBBTSwgQmrDtnJuIFTDtnBlbCB3cm90ZToNCj4gT24gRnJpLCA4IE5v
diAyMDE5IGF0IDA3OjQxLCBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPiB3cm90
ZToNCj4+DQo+PiBBZGQgYnBmX2FyY2hfdGV4dF9wb2tlKCkgaGVscGVyIHRoYXQgaXMgdXNlZCBi
eSBCUEYgdHJhbXBvbGluZSBsb2dpYyB0byBwYXRjaA0KPj4gbm9wcy9jYWxscyBpbiBrZXJuZWwg
dGV4dCBpbnRvIGNhbGxzIGludG8gQlBGIHRyYW1wb2xpbmUgYW5kIHRvIHBhdGNoDQo+PiBjYWxs
cy9ub3BzIGluc2lkZSBCUEYgcHJvZ3JhbXMgdG9vLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEFs
ZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+DQo+PiAtLS0NCj4+ICAgYXJjaC94ODYv
bmV0L2JwZl9qaXRfY29tcC5jIHwgNTEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPj4gICBpbmNsdWRlL2xpbnV4L2JwZi5oICAgICAgICAgfCAgOCArKysrKysNCj4+ICAg
a2VybmVsL2JwZi9jb3JlLmMgICAgICAgICAgIHwgIDYgKysrKysNCj4+ICAgMyBmaWxlcyBjaGFu
Z2VkLCA2NSBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L25ldC9i
cGZfaml0X2NvbXAuYyBiL2FyY2gveDg2L25ldC9icGZfaml0X2NvbXAuYw0KPj4gaW5kZXggMDM5
OWIxZjgzYzIzLi5iYjg0NjdmZDY3MTUgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9uZXQvYnBm
X2ppdF9jb21wLmMNCj4+ICsrKyBiL2FyY2gveDg2L25ldC9icGZfaml0X2NvbXAuYw0KPj4gQEAg
LTksOSArOSwxMSBAQA0KPj4gICAjaW5jbHVkZSA8bGludXgvZmlsdGVyLmg+DQo+PiAgICNpbmNs
dWRlIDxsaW51eC9pZl92bGFuLmg+DQo+PiAgICNpbmNsdWRlIDxsaW51eC9icGYuaD4NCj4+ICsj
aW5jbHVkZSA8bGludXgvbWVtb3J5Lmg+DQo+PiAgICNpbmNsdWRlIDxhc20vZXh0YWJsZS5oPg0K
Pj4gICAjaW5jbHVkZSA8YXNtL3NldF9tZW1vcnkuaD4NCj4+ICAgI2luY2x1ZGUgPGFzbS9ub3Nw
ZWMtYnJhbmNoLmg+DQo+PiArI2luY2x1ZGUgPGFzbS90ZXh0LXBhdGNoaW5nLmg+DQo+Pg0KPj4g
ICBzdGF0aWMgdTggKmVtaXRfY29kZSh1OCAqcHRyLCB1MzIgYnl0ZXMsIHVuc2lnbmVkIGludCBs
ZW4pDQo+PiAgIHsNCj4+IEBAIC00ODcsNiArNDg5LDU1IEBAIHN0YXRpYyBpbnQgZW1pdF9jYWxs
KHU4ICoqcHByb2csIHZvaWQgKmZ1bmMsIHZvaWQgKmlwKQ0KPj4gICAgICAgICAgcmV0dXJuIDA7
DQo+PiAgIH0NCj4+DQo+PiAraW50IGJwZl9hcmNoX3RleHRfcG9rZSh2b2lkICppcCwgZW51bSBi
cGZfdGV4dF9wb2tlX3R5cGUgdCwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgdm9pZCAqb2xk
X2FkZHIsIHZvaWQgKm5ld19hZGRyKQ0KPj4gK3sNCj4+ICsgICAgICAgdTggb2xkX2luc25bWDg2
X0NBTExfU0laRV0gPSB7fTsNCj4+ICsgICAgICAgdTggbmV3X2luc25bWDg2X0NBTExfU0laRV0g
PSB7fTsNCj4+ICsgICAgICAgdTggKnByb2c7DQo+PiArICAgICAgIGludCByZXQ7DQo+PiArDQo+
PiArICAgICAgIGlmICghaXNfa2VybmVsX3RleHQoKGxvbmcpaXApKQ0KPj4gKyAgICAgICAgICAg
ICAgIC8qIEJQRiB0cmFtcG9saW5lIGluIG1vZHVsZXMgaXMgbm90IHN1cHBvcnRlZCAqLw0KPj4g
KyAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPj4gKw0KPj4gKyAgICAgICBpZiAob2xk
X2FkZHIpIHsNCj4+ICsgICAgICAgICAgICAgICBwcm9nID0gb2xkX2luc247DQo+PiArICAgICAg
ICAgICAgICAgcmV0ID0gZW1pdF9jYWxsKCZwcm9nLCBvbGRfYWRkciwgKHZvaWQgKilpcCk7DQo+
PiArICAgICAgICAgICAgICAgaWYgKHJldCkNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHJl
dHVybiByZXQ7DQo+PiArICAgICAgIH0NCj4+ICsgICAgICAgaWYgKG5ld19hZGRyKSB7DQo+PiAr
ICAgICAgICAgICAgICAgcHJvZyA9IG5ld19pbnNuOw0KPj4gKyAgICAgICAgICAgICAgIHJldCA9
IGVtaXRfY2FsbCgmcHJvZywgbmV3X2FkZHIsICh2b2lkICopaXApOw0KPj4gKyAgICAgICAgICAg
ICAgIGlmIChyZXQpDQo+PiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPj4g
KyAgICAgICB9DQo+PiArICAgICAgIHJldCA9IC1FQlVTWTsNCj4+ICsgICAgICAgbXV0ZXhfbG9j
aygmdGV4dF9tdXRleCk7DQo+PiArICAgICAgIHN3aXRjaCAodCkgew0KPj4gKyAgICAgICBjYXNl
IEJQRl9NT0RfTk9QX1RPX0NBTEw6DQo+PiArICAgICAgICAgICAgICAgaWYgKG1lbWNtcChpcCwg
aWRlYWxfbm9wc1tOT1BfQVRPTUlDNV0sIFg4Nl9DQUxMX1NJWkUpKQ0KPj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgZ290byBvdXQ7DQo+PiArICAgICAgICAgICAgICAgdGV4dF9wb2tlKGlwLCBu
ZXdfaW5zbiwgWDg2X0NBTExfU0laRSk7DQo+IA0KPiBJJ20gcHJvYmFibHkgbWlzc2luZyBzb21l
dGhpbmcsIGJ1dCB3aHkgaXNuJ3QgdGV4dF9wb2tlX2JwKCkgbmVlZGVkIGhlcmU/DQoNCkkgc2hv
dWxkIGhhdmUgZG9jdW1lbnRlZCB0aGUgaW50ZW50IGJldHRlci4NCnRleHRfcG9rZV9icCgpIGlz
IGJlaW5nIGNoYW5nZWQgYnkgUGV0ZXIgdG8gZW11bGF0ZSBpbnN0cnVjdGlvbnMNCnByb3Blcmx5
IGluIGhpcyBmdHJhY2UtPnRleHRfcG9rZSBjb252ZXJzaW9uIHNldC4NClNvIEkgY2Fubm90IHVz
ZSBpdCBqdXN0IHlldC4NClRvIHlvdSBwb2ludCB0aGF0IHRleHRfcG9rZSgpIGlzIHRlY2huaWNh
bGx5IGluY29ycmVjdCBoZXJlLiBZZXAuDQpXZWxsIGF3YXJlLiBUaGlzIGlzIHRlbXBvcmFyaWx5
LiBBcyBJIHNhaWQgaW4gdGhlIGNvdmVyIGxldHRlciB0aGlzDQpuZWVkcyB0byBjaGFuZ2UgdG8g
cmVnaXN0ZXJfZnRyYWNlX2RpcmVjdCgpIGZvciBrZXJuZWwgdGV4dCBwb2tpbmcgdG8NCnBsYXkg
bmljZSB3aXRoIGZ0cmFjZS4gVGhpbmtpbmcgYWJvdXQgaXQgbW9yZS4uLiBJIGd1ZXNzIEkgY2Fu
IHVzZQ0KdGV4dF9wb2tlX2JwKCkuIEp1c3QgbmVlZCB0byBzZXR1cCBoYW5kbGVyIHByb3Blcmx5
LiBJIG1heSBuZWVkIHRvIGRvIGl0IA0KZm9yIGJwZiBwcm9nIHBva2luZyBhbnl3YXkuIFdhbnRl
ZCB0byBhdm9pZCBleHRyYSBjaHVybiB0aGF0IGlzIGdvaW5nDQp0byBiZSByZW1vdmVkIGR1cmlu
ZyBtZXJnZSB3aW5kb3cgd2hlbiB0cmVlcyBjb252ZXJnZS4NCg0KU2luY2Ugd2UncmUgb24gdGhp
cyBzdWJqZWN0Lg0KUGV0ZXIsDQp3aHkgeW91IGRvbid0IGRvIDggYnl0ZSBhdG9taWMgcmV3cml0
ZSB3aGVuIHN0YXJ0IGFkZHIgb2YgaW5zbg0KaXMgcHJvcGVybHkgYWxpZ25lZD8gVGhpcyB0cmFw
IGRhbmNlIHdvdWxkIGJlIHVubmVjZXNzYXJ5Lg0KVGhhdCB3aWxsIG1ha2UgZXZlcnl0aGluZyBz
byBtdWNoIHNpbXBsZXIuDQoNCg==
