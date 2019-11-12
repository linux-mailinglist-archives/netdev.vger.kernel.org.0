Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48D5F8796
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 05:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfKLEsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 23:48:40 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58008 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726910AbfKLEsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 23:48:39 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAC4mFYv005646;
        Mon, 11 Nov 2019 20:48:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XSEm3TKCBHmYaHgiUNydNrJoLNCmUvcVOzuHYDYZJnI=;
 b=hnOOCBqa5j5hRGuJQT19AL9Md2f2i5YnfoU4Y9pV5FgLXMUSjx7aVY0MYdJ32LUq/otS
 j6+hJ7I6lEAsJZyZVro1s1iXO0kkMeZRdA/etE0YvUw9iMAcsyXmubhssZjf2ZpHVTjK
 kVlfdNCkEV++2Db8bZ0BrEsLev6Yx8pBXIo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5v5jw7sp-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Nov 2019 20:48:17 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 11 Nov 2019 20:48:08 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 11 Nov 2019 20:48:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=au19dMg6qEZMjai4yljk/DLS09oK3VoNwk6jBT1Z2/oOyhOyHz9bcx2b78ah5NR8zMurT/amifZ2IqbEKMwW4OJ+otRTS9kg/BOGyjNEqa16+4EsM4W2OSB/FmN0V62i/8p98uSbf0YSfMwh+SfaJL2zreRxI4TUjIshbmOZktxXVPq2kzqCTi+6/kStisw7dRk6f3t1g9hwlyIm/0jhoGILnFg9Ypd5F1yCq+OlEFxS1ZdULdSMdGxMxzyp/i1Bebjvh5fyYOKsu23Af5MdnHZ/PxMzfMnNt5A0F2qPCAAQK9cCYnm8mtWoKyVSBB2s3EKUcWSU4NGwIcjGh+xa9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSEm3TKCBHmYaHgiUNydNrJoLNCmUvcVOzuHYDYZJnI=;
 b=Tp8J1mOci+ZawHAKRSiqBf7fueLkwlpchD80BmgAr4/v2+oCZK7cd2eFiLxcTtTBQdW0pM1XFq6vbeA3xEDkxA4WE4LXoC3ga4YPmPmAwuJo85g8r+do8fWH1qp36wGCgkxaZY2iUIEnOy+vCXsEX/hS+UmDw1uJp0TAwdT+ZJVQyC87Xp7N/7bumm4gAwdsZyjj/12zWNrK3LXiR58jvqDbXh7Br82vmvqK0U+d1w0nNmxHyT2UQf8Xy8DOAlN2LC/a6MLhQvDnkjtu+0eVbfV3KEa9CbT8Yir21W9P8moLRk693QOxgA2JdRhGXhfE2QBMWVvAcicKEj7RTQAUwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSEm3TKCBHmYaHgiUNydNrJoLNCmUvcVOzuHYDYZJnI=;
 b=N4mULjnNqoJefsrVZP1Hkd/0cZa9ba6f4v+tv/OTuZbt3b8jwV+/R2SNeJQ3SuqbBZsEOzmI+HZ+HopA7/fT/CmOlEqhws7F4FVucyXmNaQlsqsjILrwO7DbOea9fkegmH6EYZ1VUX3RYEpKJnareNelFgYHT6OdzI5JBo3WACg=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3048.namprd15.prod.outlook.com (20.178.238.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Tue, 12 Nov 2019 04:47:53 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 04:47:53 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF
 program to other BPF programs
Thread-Topic: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF
 program to other BPF programs
Thread-Index: AQHVlf+nZDPDBM5wGU2+HMUND7lGDKeEAdyAgAKavwCAAF2SAIAAAn6A
Date:   Tue, 12 Nov 2019 04:47:52 +0000
Message-ID: <c51e684b-5f86-a6e5-d31d-ed42179bf626@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-16-ast@kernel.org>
 <CAEf4BzZAEqv4kJy133PAMt81xaDBTcYDqNHSJP81X+2AitHpOQ@mail.gmail.com>
 <20191111230358.t3tcqkxaupcxyfap@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzahNJXbpJ6mfhDT=G-dspCg-Zzm9jGYUexxfz62Yop_oQ@mail.gmail.com>
In-Reply-To: <CAEf4BzahNJXbpJ6mfhDT=G-dspCg-Zzm9jGYUexxfz62Yop_oQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0043.namprd14.prod.outlook.com
 (2603:10b6:300:12b::29) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::fea7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a932b37-0189-4223-0ef5-08d7672b7a16
x-ms-traffictypediagnostic: BYAPR15MB3048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3048B952D81FCEECBD841D10D7770@BYAPR15MB3048.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(376002)(136003)(39860400002)(189003)(199004)(54906003)(81156014)(64756008)(66476007)(4326008)(66446008)(81166006)(316002)(71190400001)(66556008)(66946007)(110136005)(14444005)(5024004)(305945005)(6512007)(256004)(7736002)(14454004)(86362001)(71200400001)(6246003)(8676002)(76176011)(31696002)(478600001)(36756003)(102836004)(53546011)(386003)(6506007)(99286004)(6486002)(6436002)(52116002)(186003)(2906002)(8936002)(229853002)(46003)(5660300002)(31686004)(6116002)(2616005)(476003)(486006)(11346002)(446003)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3048;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q9gm/X3d7wWCMF8Xtttg1jIooxekJP+6AGeWYOG1XDfytBTaBb5Aq2uiY9oHPfjFG8EaTUG/BeBzChsDhP1Z+ZVEgKbyGpb4btHj+BnbmPa3W/jrZPpmQBs4hFRwFZIf5SZVZw4Z6OrdvTjeTa9v433Aj+2xYMv3ypFqkHSlXCNu//YfIJIg+S0DvThX7/w75Y5qLJdQctt+MD/j9w0z/BWNO+5f3PktEx8nr4qgmgiyPM04JP28oI/w9nuaPBx0cqI2pz4scLC6Wnl/tCVqvlQF/2wQbHKKpH6Grbe+OpUkFRDhA2qWpxqDWbAL1TNah2CxLpgsXboC62jAOKg37tUsbjp2kHfJfvky7WtdHygCzRvn3Lwzuibhk5syu0TAhsRazI3eEL99ZASn/6eNYWTn1QLrBULHhNowrbOXfxmJeemO0S5RO9dxpWlgQDCa
Content-Type: text/plain; charset="utf-8"
Content-ID: <73ABD7BF87B2034C9F5D2CBA3F333DD9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a932b37-0189-4223-0ef5-08d7672b7a16
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 04:47:52.8273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q2J3k+ArDDYyb9GH3/pmRv5h5Gs5y7OQzfpFXUWTJEBrogp+qEFa0GpAAjeJNscP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3048
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-11_07:2019-11-11,2019-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911120041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMTEvMTkgODozOCBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBNb24sIE5v
diAxMSwgMjAxOSBhdCAzOjA0IFBNIEFsZXhlaSBTdGFyb3ZvaXRvdg0KPiA8YWxleGVpLnN0YXJv
dm9pdG92QGdtYWlsLmNvbT4gd3JvdGU6DQo+Pg0KPj4gT24gU2F0LCBOb3YgMDksIDIwMTkgYXQg
MTE6MTc6MzdQTSAtMDgwMCwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPj4+IE9uIFRodSwgTm92
IDcsIDIwMTkgYXQgMTA6NDEgUE0gQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4g
d3JvdGU6DQo+Pj4+DQo+Pj4+IEFsbG93IEZFTlRSWS9GRVhJVCBCUEYgcHJvZ3JhbXMgdG8gYXR0
YWNoIHRvIG90aGVyIEJQRiBwcm9ncmFtcyBvZiBhbnkgdHlwZQ0KPj4+PiBpbmNsdWRpbmcgdGhl
aXIgc3VicHJvZ3JhbXMuIFRoaXMgZmVhdHVyZSBhbGxvd3Mgc25vb3Bpbmcgb24gaW5wdXQgYW5k
IG91dHB1dA0KPj4+PiBwYWNrZXRzIGluIFhEUCwgVEMgcHJvZ3JhbXMgaW5jbHVkaW5nIHRoZWly
IHJldHVybiB2YWx1ZXMuIEluIG9yZGVyIHRvIGRvIHRoYXQNCj4+Pj4gdGhlIHZlcmlmaWVyIG5l
ZWRzIHRvIHRyYWNrIHR5cGVzIG5vdCBvbmx5IG9mIHZtbGludXgsIGJ1dCB0eXBlcyBvZiBvdGhl
ciBCUEYNCj4+Pj4gcHJvZ3JhbXMgYXMgd2VsbC4gVGhlIHZlcmlmaWVyIGFsc28gbmVlZHMgdG8g
dHJhbnNsYXRlIHVhcGkvbGludXgvYnBmLmggdHlwZXMNCj4+Pj4gdXNlZCBieSBuZXR3b3JraW5n
IHByb2dyYW1zIGludG8ga2VybmVsIGludGVybmFsIEJURiB0eXBlcyB1c2VkIGJ5IEZFTlRSWS9G
RVhJVA0KPj4+PiBCUEYgcHJvZ3JhbXMuIEluIHNvbWUgY2FzZXMgTExWTSBvcHRpbWl6YXRpb25z
IGNhbiByZW1vdmUgYXJndW1lbnRzIGZyb20gQlBGDQo+Pj4+IHN1YnByb2dyYW1zIHdpdGhvdXQg
YWRqdXN0aW5nIEJURiBpbmZvIHRoYXQgTExWTSBiYWNrZW5kIGtub3dzLiBXaGVuIEJURiBpbmZv
DQo+Pj4+IGRpc2FncmVlcyB3aXRoIGFjdHVhbCB0eXBlcyB0aGF0IHRoZSB2ZXJpZmllcnMgc2Vl
cyB0aGUgQlBGIHRyYW1wb2xpbmUgaGFzIHRvDQo+Pj4+IGZhbGxiYWNrIHRvIGNvbnNlcnZhdGl2
ZSBhbmQgdHJlYXQgYWxsIGFyZ3VtZW50cyBhcyB1NjQuIFRoZSBGRU5UUlkvRkVYSVQNCj4+Pj4g
cHJvZ3JhbSBjYW4gc3RpbGwgYXR0YWNoIHRvIHN1Y2ggc3VicHJvZ3JhbXMsIGJ1dCB3b24ndCBi
ZSBhYmxlIHRvIHJlY29nbml6ZQ0KPj4+PiBwb2ludGVyIHR5cGVzIGxpa2UgJ3N0cnVjdCBza19i
dWZmIConIGludG8gd29uJ3QgYmUgYWJsZSB0byBwYXNzIHRoZW0gdG8NCj4+Pj4gYnBmX3NrYl9v
dXRwdXQoKSBmb3IgZHVtcGluZyB0byB1c2VyIHNwYWNlLg0KPj4+Pg0KPj4+PiBUaGUgQlBGX1BS
T0dfTE9BRCBjb21tYW5kIGlzIGV4dGVuZGVkIHdpdGggYXR0YWNoX3Byb2dfZmQgZmllbGQuIFdo
ZW4gaXQncyBzZXQNCj4+Pj4gdG8gemVybyB0aGUgYXR0YWNoX2J0Zl9pZCBpcyBvbmUgdm1saW51
eCBCVEYgdHlwZSBpZHMuIFdoZW4gYXR0YWNoX3Byb2dfZmQNCj4+Pj4gcG9pbnRzIHRvIHByZXZp
b3VzbHkgbG9hZGVkIEJQRiBwcm9ncmFtIHRoZSBhdHRhY2hfYnRmX2lkIGlzIEJURiB0eXBlIGlk
IG9mDQo+Pj4+IG1haW4gZnVuY3Rpb24gb3Igb25lIG9mIGl0cyBzdWJwcm9ncmFtcy4NCj4+Pj4N
Cj4+Pj4gU2lnbmVkLW9mZi1ieTogQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4N
Cj4+Pj4gLS0tDQo+Pj4+ICAgYXJjaC94ODYvbmV0L2JwZl9qaXRfY29tcC5jIHwgIDMgKy0NCj4+
Pj4gICBpbmNsdWRlL2xpbnV4L2JwZi5oICAgICAgICAgfCAgMiArDQo+Pj4+ICAgaW5jbHVkZS9s
aW51eC9idGYuaCAgICAgICAgIHwgIDEgKw0KPj4+PiAgIGluY2x1ZGUvdWFwaS9saW51eC9icGYu
aCAgICB8ICAxICsNCj4+Pj4gICBrZXJuZWwvYnBmL2J0Zi5jICAgICAgICAgICAgfCA1OCArKysr
KysrKysrKysrKysrKysrLS0tDQo+Pj4+ICAga2VybmVsL2JwZi9jb3JlLmMgICAgICAgICAgIHwg
IDIgKw0KPj4+PiAgIGtlcm5lbC9icGYvc3lzY2FsbC5jICAgICAgICB8IDE5ICsrKysrLS0NCj4+
Pj4gICBrZXJuZWwvYnBmL3ZlcmlmaWVyLmMgICAgICAgfCA5OCArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0tDQo+Pj4+ICAga2VybmVsL3RyYWNlL2JwZl90cmFjZS5jICAgIHwg
IDIgLQ0KPj4+PiAgIDkgZmlsZXMgY2hhbmdlZCwgMTUxIGluc2VydGlvbnMoKyksIDM1IGRlbGV0
aW9ucygtKQ0KPj4+Pg0KPj4+DQo+Pj4gWy4uLl0NCj4+Pg0KPj4+PiArDQo+Pj4+ICtzdGF0aWMg
Ym9vbCBidGZfdHJhbnNsYXRlX3RvX3ZtbGludXgoc3RydWN0IGJwZl92ZXJpZmllcl9sb2cgKmxv
ZywNCj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBidGYg
KmJ0ZiwNCj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0
cnVjdCBidGZfdHlwZSAqdCwNCj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHN0cnVjdCBicGZfaW5zbl9hY2Nlc3NfYXV4ICppbmZvKQ0KPj4+PiArew0KPj4+PiArICAg
ICAgIGNvbnN0IGNoYXIgKnRuYW1lID0gX19idGZfbmFtZV9ieV9vZmZzZXQoYnRmLCB0LT5uYW1l
X29mZik7DQo+Pj4+ICsgICAgICAgaW50IGJ0Zl9pZDsNCj4+Pj4gKw0KPj4+PiArICAgICAgIGlm
ICghdG5hbWUpIHsNCj4+Pj4gKyAgICAgICAgICAgICAgIGJwZl9sb2cobG9nLCAiUHJvZ3JhbSdz
IHR5cGUgZG9lc24ndCBoYXZlIGEgbmFtZVxuIik7DQo+Pj4+ICsgICAgICAgICAgICAgICByZXR1
cm4gZmFsc2U7DQo+Pj4+ICsgICAgICAgfQ0KPj4+PiArICAgICAgIGlmIChzdHJjbXAodG5hbWUs
ICJfX3NrX2J1ZmYiKSA9PSAwKSB7DQo+Pj4NCj4+PiBtaWdodCBiZSBhIGdvb2QgaWRlYSB0byBl
bnN1cmUgdGhhdCB0J3MgdHlwZSBpcyBhbHNvIGEgc3RydWN0Pw0KPj4+DQo+Pj4+ICsgICAgICAg
ICAgICAgICBidGZfaWQgPSBidGZfcmVzb2x2ZV9oZWxwZXJfaWQobG9nLCAmYnBmX3NrYl9vdXRw
dXRfcHJvdG8sIDApOw0KPj4+DQo+Pj4gVGhpcyBpcyBraW5kIG9mIHVnbHkgYW5kIGhpZ2gtbWFp
bnRlbmFuY2UuIEhhdmUgeW91IGNvbnNpZGVyZWQgaGF2aW5nDQo+Pj4gc29tZXRoaW5nIGxpa2Ug
dGhpcywgdG8gZG8gdGhpcyBtYXBwaW5nOg0KPj4+DQo+Pj4gc3RydWN0IGJwZl9jdHhfbWFwcGlu
ZyB7DQo+Pj4gICAgICBzdHJ1Y3Qgc2tfYnVmZiAqX19za19idWZmOw0KPj4+ICAgICAgc3RydWN0
IHhkcF9idWZmICp4ZHBfbWQ7DQo+Pj4gfTsNCj4+Pg0KPj4+IFNvIGZpZWxkIG5hbWUgaXMgYSBu
YW1lIHlvdSBhcmUgdHJ5aW5nIHRvIG1hdGNoLCB3aGlsZSBmaWVsZCB0eXBlIGlzDQo+Pj4gYWN0
dWFsIHR5cGUgeW91IGFyZSBtYXBwaW5nIHRvPyBZb3Ugd29uJ3QgbmVlZCB0byBmaW5kIHNwZWNp
YWwNCj4+PiBmdW5jdGlvbiBwcm90b3MgKGxpa2UgYnBmX3NrYl9vdXRwdXRfcHJvdG8pLCBpdCB3
aWxsIGJlIGVhc3kgdG8NCj4+PiBleHRlbmQsIHlvdSdsbCBoYXZlIHJlYWwgdm1saW51eCB0eXBl
cyBhdXRvbWF0aWNhbGx5IGNhcHR1cmVkIGZvciB5b3UNCj4+PiAoeW91J2xsIGp1c3QgaGF2ZSB0
byBpbml0aWFsbHkgZmluZCBicGZfY3R4X21hcHBpbmcncyBidGZfaWQpLg0KPj4NCj4+IEkgd2Fz
IHRoaW5raW5nIHNvbWV0aGluZyBhbG9uZyB0aGVzZSBsaW5lcy4NCj4+IFRoZSBwcm9ibGVtIHdp
dGggc2luZ2xlIHN0cnVjdCBsaWtlIGFib3ZlIGlzIHRoYXQgaXQncyBjZW50cmFsaXplZC4NCj4+
IGNvbnZlcnRfY3R4X2FjY2VzcyBjYWxsYmFja3MgYXJlIGFsbCBvdmVyIHRoZSBwbGFjZS4NCj4+
IFNvIEknbSB0aGlua2luZyB0byBhZGQgbWFjcm8gbGlrZSB0aGlzIHRvIGJwZi5oDQo+PiArI2Rl
ZmluZSBCUEZfUkVDT1JEX0NUWF9DT05WRVJTSU9OKHVzZXJfdHlwZSwga2VybmVsX3R5cGUpIFwN
Cj4+ICsgICAgICAgKHt0eXBlZGVmIGtlcm5lbF90eXBlICgqYnBmX2N0eF9jb252ZXJ0KSh1c2Vy
X3R5cGUpOyBcDQo+PiArICAgICAgICAodm9pZCkgKGJwZl9jdHhfY29udmVydCkgKHZvaWQgKikg
MDt9KQ0KPj4NCj4+IGFuZCB0aGVuIGRvDQo+PiBCUEZfUkVDT1JEX0NUWF9DT05WRVJTSU9OKHN0
cnVjdCBicGZfeGRwX3NvY2ssIHN0cnVjdCB4ZHBfc29jayk7DQo+PiBpbnNpZGUgY29udmVydF9j
dHhfYWNjZXNzIGZ1bmN0aW9ucyAobGlrZSBicGZfeGRwX3NvY2tfY29udmVydF9jdHhfYWNjZXNz
KS4NCj4+IFRoZXJlIHdpbGwgYmUgc2V2ZXJhbCB0eXBlZGVmcyB3aXRoICdicGZfY3R4X2NvbnZl
cnQnIG5hbWUuIFRoZQ0KPj4gYnRmX3RyYW5zbGF0ZV90b192bWxpbnV4KCkgd2lsbCBpdGVyYXRl
IG92ZXIgdGhlbS4gU3BlZWQgaXMgbm90IGNyaXRpY2lhbCBoZXJlLA0KPiANCj4gSSBndWVzcyB0
aGF0IHdvcmtzIGFzIHdlbGwuIFBsZWFzZSBsZWF2ZSBhIGNvbW1lbnQgZXhwbGFpbmluZyB0aGUg
aWRlYQ0KPiBiZWhpbmQgdGhpcyBkaXN0cmlidXRlZCBtYXBwaW5nIDopDQo+IA0KPj4gYnV0IGxv
bmcgdGVybSB3ZSBwcm9iYWJseSBuZWVkIHRvIG1lcmdlIHByb2cncyBCVEYgd2l0aCB2bWxpbnV4
J3MgQlRGLCBzbyBtb3N0DQo+PiBvZiB0aGUgdHlwZSBjb21wYXJpc29uIGlzIGRvbmUgZHVyaW5n
IHByb2cgbG9hZC4gSXQgcHJvYmFibHkgc2hvdWxkIHJlZHVjZSB0aGUNCj4+IHNpemUgb2YgcHJv
ZydzIEJURiB0b28uIFJlbnVtYmVyaW5nIG9mIHByb2cncyBCVEYgd2lsbCBiZSBhbm5veWluZyB0
aG91Z2guDQo+PiBTb21ldGhpbmcgdG8gY29uc2lkZXIgbG9uZyB0ZXJtLg0KPj4NCj4+Pg0KPj4+
PiArICAgICAgICAgICAgICAgaWYgKGJ0Zl9pZCA8IDApDQo+Pj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiBmYWxzZTsNCj4+Pj4gKyAgICAgICAgICAgICAgIGluZm8tPmJ0Zl9pZCA9
IGJ0Zl9pZDsNCj4+Pj4gKyAgICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KPj4+PiArICAgICAg
IH0NCj4+Pj4gKyAgICAgICByZXR1cm4gZmFsc2U7DQo+Pj4+ICt9DQo+Pj4+DQo+Pj4NCj4+PiBb
Li4uXQ0KPj4+DQo+Pj4+ICsgICAgICAgICAgICAgICBpZiAodGd0X3Byb2cgJiYgY29uc2VydmF0
aXZlKSB7DQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBidGZfZnVuY19tb2Rl
bCAqbSA9ICZ0ci0+ZnVuYy5tb2RlbDsNCj4+Pj4gKw0KPj4+PiArICAgICAgICAgICAgICAgICAg
ICAgICAvKiBCVEYgZnVuY3Rpb24gcHJvdG90eXBlIGRvZXNuJ3QgbWF0Y2ggdGhlIHZlcmlmaWVy
IHR5cGVzLg0KPj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgKiBGYWxsIGJhY2sgdG8gNSB1
NjQgYXJncy4NCj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICovDQo+Pj4+ICsgICAgICAg
ICAgICAgICAgICAgICAgIGZvciAoaSA9IDA7IGkgPCA1OyBpKyspDQo+Pj4+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgbS0+YXJnX3NpemVbaV0gPSA4Ow0KPj4+PiArICAgICAgICAg
ICAgICAgICAgICAgICBtLT5yZXRfc2l6ZSA9IDg7DQo+Pj4+ICsgICAgICAgICAgICAgICAgICAg
ICAgIG0tPm5yX2FyZ3MgPSA1Ow0KPj4+PiArICAgICAgICAgICAgICAgICAgICAgICBwcm9nLT5h
dXgtPmF0dGFjaF9mdW5jX3Byb3RvID0gTlVMTDsNCj4+Pj4gKyAgICAgICAgICAgICAgIH0gZWxz
ZSB7DQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IGJ0Zl9kaXN0aWxsX2Z1bmNf
cHJvdG8oJmVudi0+bG9nLCBidGYsIHQsDQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgdG5hbWUsICZ0ci0+ZnVuYy5tb2RlbCk7DQo+Pj4N
Cj4+PiB0aGVyZSBpcyBub3RoaW5nIHByZXZlbnRpbmcgc29tZSBwYXJhbGxlbCB0aHJlYWQgdG8g
bW9kaWZ5DQo+Pj4gdHItPmZ1bmMubW9kZWwgaW4gcGFyYWxsZWwsIHJpZ2h0PyBTaG91bGQgdGhl
c2UgbW9kaWZpY2F0aW9ucyBiZQ0KPj4+IGVpdGhlciBsb2NrZWQgb3IgYXQgbGVhc3QgV1JJVEVf
T05DRSwgc2ltaWxhciB0bw0KPj4+IGJ0Zl9yZXNvbHZlX2hlbHBlcl9pZD8NCj4+DQo+PiBobW0u
IFJpZ2h0LiBUaGVyZSBpcyBhIHJhY2Ugd2l0aCBicGZfdHJhbXBvbGluZV9sb29rdXAuIE9uZSB0
aHJlYWQgY291bGQgaGF2ZQ0KPj4ganVzdCBjcmVhdGVkIHRoZSB0cmFtcG9saW5lIGFuZCBzdGls
bCBkb2luZyBkaXN0aWxsLCB3aGlsZSBhbm90aGVyIHRocmVhZCBpcw0KPj4gdHJ5aW5nIHRvIHVz
ZSBpdCBhZnRlciBnZXR0aW5nIGl0IGZyb20gYnBmX3RyYW1wb2xpbmVfbG9va3VwLiBUaGUgZml4
IGNob2ljZXMNCj4+IGFyZSBub3QgcHJldHR5LiBFaXRoZXIgdG8gYWRkIGEgbXV0ZXggdG8gY2hl
Y2tfYXR0YWNoX2J0Zl9pZCgpIG9yIGRvDQo+PiBicGZfdHJhbXBvbGluZV9sb29rdXBfb3JfY3Jl
YXRlKCkgd2l0aCBleHRyYSBjYWxsYmFjayB0aGF0IGRvZXMNCj4+IGJ0Zl9kaXN0aWxsX2Z1bmNf
cHJvdG8gd2hpbGUgYnBmX3RyYW1wb2xpbmVfbG9va3VwX29yX2NyZWF0ZSBpcyBob2xkaW5nDQo+
PiB0cmFtcG9saW5lX211dGV4IG9yIG1vdmUgbW9zdCBvZiB0aGUgY2hlY2tfYXR0YWNoX2J0Zl9p
ZCgpIGxvZ2ljIGludG8NCj4+IGJwZl90cmFtcG9saW5lX2xvb2t1cF9vcl9jcmVhdGUoKS4NCj4+
IEkgdHJpZWQgdG8ga2VlcCB0cmFtcG9saW5lIGFzIGFic3RyYWN0IGNvbmNlcHQsIGJ1dCB3aXRo
IGNhbGxiYWNrIG9yIG1vdmUNCj4+IHRoZSB2ZXJpZmVyIGFuZCBidGYgbG9naWMgd2lsbCBibGVl
ZCBpbnRvIHRyYW1wb2xpbmUuIEhtbS4NCj4gDQo+IHllYWgsIHRoYXQgc291bmRzIHRvbyBpbnRy
dXNpdmUuIEknZCBjaGFuZ2UgYnRmX2Rpc3RpbGxfZnVuY19wcm90byB0bw0KPiBhY2NlcHQgc3Ry
dWN0IGJ0Zl9mdW5jX21vZGVsICoqbSwgYWxsb2NhdGUgbW9kZWwgZHluYW1pY2FsbHksIGFuZCB0
aGVuDQo+IGNvbXBhcmVfZXhjaGFuZ2UgdGhlIGZpbmFsIGNvbnN0cnVjdGVkIG1vZGVsIHBvaW50
ZXIuDQoNCmNtcHhjaGcgaXMgdG9vIHVnbHkgYW5kIGFsc28gbm90IGNvdmVyaW5nIGFsbCBvdGhl
ciBmaWVsZHMgdGhhdCBtYXkgbmVlZCANCnRvIGhhdmUgc2VyaWFsaXplZCBhY2Nlc3MgaW4gdGhl
IGZ1dHVyZS4gSSB3ZW50IHdpdGggc2ltcGxlciBtb2RlbCBvZg0KYWRkaXRpb25hbCBtdXRleCBw
ZXIgdHJhbXBvbGluZS4gSXQgYWxzbyBoZWxwZWQgdG8gYXZvaWQgZ2xvYmFsIG11dGV4DQpmb3Ig
bGluay91bmxpbmsuDQo=
