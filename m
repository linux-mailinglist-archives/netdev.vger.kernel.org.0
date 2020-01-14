Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC0613B475
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 22:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgANVeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 16:34:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43434 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728992AbgANVeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 16:34:12 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00ELNGb9008566;
        Tue, 14 Jan 2020 13:33:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=d52mwVS/eJyR1LevQem2bc4DeqytdXofdAxpZagd3bM=;
 b=H3BVjnJZrhCMJWr8NQIqqzq+nxY90MTMjv1Wf1GKTIl7+ib4Ml3ff/CC8754ySNifDZj
 /M/vBsBG9X2BJK82MNGkg5SW2UGzyyx+Qh6NW5TbrErUBs4Kt3GoFk8zkmRETuaLI5HA
 FzAmvcIwS/lU2vkEtLGoYszoybumMMrx87w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhaj2bkx5-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Jan 2020 13:33:52 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 14 Jan 2020 13:33:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMv75j0bYh64NsPMKsEmyW6CayQdVtOMNvqI3HWTFd5OqJC/s/UPx2DVpjnICfxTxjducgaiWEuxNsA8rrsXyg3/JCcJlhNLzK04i++QgUjDRhx1umSoUQSCRPRJsLaPfqcebwzFHrjpeKphTBD0eH9r4JA5ZcIpQrBl0tSNZUDfXOettV7RWnXgv3BKYs+o16dSglCtu1pC3+912O/9PIErHUTRm2ICuTH16GS1S2u/WpGFA42bJpqkfr5Abfcejt2DL9cH+hTrXlSFS3nw4dOqiyXZy1znenoTY8tB8vbrIxXcUT1B/FVgXV0p9oaZ1BDKDW4lPp2oV0kVfzbWvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d52mwVS/eJyR1LevQem2bc4DeqytdXofdAxpZagd3bM=;
 b=Ul94XEU3GqWaTWjvjQm5qkq0nupqgrJqoskLJh+fzjJvc2EyQ8KJANDBTHBFljhTYtuUlQZ120v/CjBVeYeJ0gTwE/5au2ALUNuTuWozBOiv62RMGuVCPrzucwd35iALHZgypjMqbXAx1DlsH9wMU3MPkS133yXWU3D1XcPsu8KOBJIOC4NwbGGMt8fZ2OWbSB56wdM8o3DdSwGj9V9OQkXDqzsASm+2DN0Fmj2g7KmN6zQGjWMWQYckt+WzCzwg6UZ/O5pqIQch0G9e2JrU+HYnEUII/Oygv0x3UeJzsIUDXrq6LZx5BARIM8PtcxJB521GMDFExCjJmRv2FySS7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d52mwVS/eJyR1LevQem2bc4DeqytdXofdAxpZagd3bM=;
 b=LkM1Q8s1R+KJ7dXN59VChaI+oNGCHhNjk5uMVYpkdzcwODrmIi22DAcWIMyYTs/YRpktQzDRzjEUeeAfDW3vsudY9jHTbhYla6QDLw2lKUDkF5G0O31cHgvEQJJWiDm4r5hGXp88LLL7CZ+bcmOjB56ujaXWvXxueiUmiFEMcKQ=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1244.namprd15.prod.outlook.com (10.173.210.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Tue, 14 Jan 2020 21:33:50 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b%11]) with mapi id 15.20.2623.017; Tue, 14 Jan
 2020 21:33:50 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::2:b667) by MWHPR12CA0043.namprd12.prod.outlook.com (2603:10b6:301:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Tue, 14 Jan 2020 21:33:48 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Brian Vazquez <brianvv@google.com>
CC:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 7/9] libbpf: add libbpf support to batch ops
Thread-Topic: [PATCH v4 bpf-next 7/9] libbpf: add libbpf support to batch ops
Thread-Index: AQHVyvpG/BAQWB88FE6INRASv4pnVqfqfSoAgAAEyQCAAAWWgIAAJxwA
Date:   Tue, 14 Jan 2020 21:33:50 +0000
Message-ID: <9ef6e3b5-c129-e5fb-b685-f73fdee68b53@fb.com>
References: <20200114164614.47029-1-brianvv@google.com>
 <20200114164614.47029-9-brianvv@google.com>
 <CAEf4BzYEGv-q7p0rK-d94Ng0fyQLuTEvsy1ZSzTdk0xZcyibQA@mail.gmail.com>
 <CAMzD94ScYuQfvx2FLY7RAzgZ8xO-E31L79dGEJH-tNDKJzrmOg@mail.gmail.com>
 <CAEf4BzZHFaCGNg21VuWywB0Qsa_AkqDPnM4k_pcU_ssmFjd0Yg@mail.gmail.com>
In-Reply-To: <CAEf4BzZHFaCGNg21VuWywB0Qsa_AkqDPnM4k_pcU_ssmFjd0Yg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0043.namprd12.prod.outlook.com
 (2603:10b6:301:2::29) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:b667]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 883e0d6b-3fe8-4088-a6f0-08d7993971f5
x-ms-traffictypediagnostic: DM5PR15MB1244:
x-microsoft-antispam-prvs: <DM5PR15MB1244F8E4C8542F78F7D282F7D3340@DM5PR15MB1244.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(396003)(346002)(136003)(199004)(189003)(2906002)(53546011)(6506007)(6666004)(66556008)(66446008)(478600001)(64756008)(66476007)(66946007)(71200400001)(6486002)(52116002)(86362001)(16526019)(186003)(8936002)(81156014)(110136005)(316002)(8676002)(81166006)(2616005)(5660300002)(31696002)(6512007)(31686004)(54906003)(7416002)(36756003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1244;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eWJAvGJ9lWZYAelObGT6b8HLNFhmjBc9NQwbu4R+MdIMXda1ajolXfk/7engcKdUvYlZgEeUllQ4JT0qQevN3Xk1DJtX2+DnGP7SwLcoY7PI4k0zZNj8I4e6l0FS58LRp/CcYNnFcR43cssIbxxS9AvUGDVYoaIBrLT/7EQP8T9mhVDMuvYapPRufARiw2xCCEXlCEwqGreib4tJrfKiBzVT9bmVoUK2EmVjbDzvaw+gsYkPlN3t8cZ72hUcB/Frca46VINBFZTHZFE3ojAL7N9HzkWTRSo5bBgAEwJqCVr/fR6o663z7Pbfeq3jNjMB51+I0VG21F5czE3Ejpi+Ky5Op0NDfJHUhJNmVKKwoTeCv/NLsNfFW6U5SFXxokaaRV2h8eq6Z/RTI6iXIlxvtdCDJfvTvjeXd5J4mBTuUqLxMwH+JgLROf1YRdg2mUy4
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AAA72AE4CB29548A8A7631CC838E047@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 883e0d6b-3fe8-4088-a6f0-08d7993971f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 21:33:50.2433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xTILC55tMp8QdcxcPM0XxdA7thqkgagrFNum+zQnRysiTlALJQzkj28B+0UzAj/s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1244
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001140161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMTQvMjAgMTE6MTMgQU0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gT24gVHVl
LCBKYW4gMTQsIDIwMjAgYXQgMTA6NTQgQU0gQnJpYW4gVmF6cXVleiA8YnJpYW52dkBnb29nbGUu
Y29tPiB3cm90ZToNCj4+DQo+PiBPbiBUdWUsIEphbiAxNCwgMjAyMCBhdCAxMDozNiBBTSBBbmRy
aWkgTmFrcnlpa28NCj4+IDxhbmRyaWkubmFrcnlpa29AZ21haWwuY29tPiB3cm90ZToNCj4+Pg0K
Pj4+IE9uIFR1ZSwgSmFuIDE0LCAyMDIwIGF0IDg6NDYgQU0gQnJpYW4gVmF6cXVleiA8YnJpYW52
dkBnb29nbGUuY29tPiB3cm90ZToNCj4+Pj4NCj4+Pj4gRnJvbTogWW9uZ2hvbmcgU29uZyA8eWhz
QGZiLmNvbT4NCj4+Pj4NCj4+Pj4gQWRkZWQgZm91ciBsaWJicGYgQVBJIGZ1bmN0aW9ucyB0byBz
dXBwb3J0IG1hcCBiYXRjaCBvcGVyYXRpb25zOg0KPj4+PiAgICAuIGludCBicGZfbWFwX2RlbGV0
ZV9iYXRjaCggLi4uICkNCj4+Pj4gICAgLiBpbnQgYnBmX21hcF9sb29rdXBfYmF0Y2goIC4uLiAp
DQo+Pj4+ICAgIC4gaW50IGJwZl9tYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2goIC4uLiApDQo+
Pj4+ICAgIC4gaW50IGJwZl9tYXBfdXBkYXRlX2JhdGNoKCAuLi4gKQ0KPj4+Pg0KPj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KPj4+PiAtLS0NCj4+Pj4gICB0
b29scy9saWIvYnBmL2JwZi5jICAgICAgfCA2MCArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrDQo+Pj4+ICAgdG9vbHMvbGliL2JwZi9icGYuaCAgICAgIHwgMjIgKysrKysr
KysrKysrKysrDQo+Pj4+ICAgdG9vbHMvbGliL2JwZi9saWJicGYubWFwIHwgIDQgKysrDQo+Pj4+
ICAgMyBmaWxlcyBjaGFuZ2VkLCA4NiBpbnNlcnRpb25zKCspDQo+Pj4+DQo+Pj4+IGRpZmYgLS1n
aXQgYS90b29scy9saWIvYnBmL2JwZi5jIGIvdG9vbHMvbGliL2JwZi9icGYuYw0KPj4+PiBpbmRl
eCA1MDBhZmU0NzhlOTRhLi4xMmNlOGQyNzVmN2RjIDEwMDY0NA0KPj4+PiAtLS0gYS90b29scy9s
aWIvYnBmL2JwZi5jDQo+Pj4+ICsrKyBiL3Rvb2xzL2xpYi9icGYvYnBmLmMNCj4+Pj4gQEAgLTQ1
Miw2ICs0NTIsNjYgQEAgaW50IGJwZl9tYXBfZnJlZXplKGludCBmZCkNCj4+Pj4gICAgICAgICAg
cmV0dXJuIHN5c19icGYoQlBGX01BUF9GUkVFWkUsICZhdHRyLCBzaXplb2YoYXR0cikpOw0KPj4+
PiAgIH0NCj4+Pj4NCj4+Pj4gK3N0YXRpYyBpbnQgYnBmX21hcF9iYXRjaF9jb21tb24oaW50IGNt
ZCwgaW50IGZkLCB2b2lkICAqaW5fYmF0Y2gsDQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgdm9pZCAqb3V0X2JhdGNoLCB2b2lkICprZXlzLCB2b2lkICp2YWx1ZXMsDQo+Pj4+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX191MzIgKmNvdW50LA0KPj4+PiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBicGZfbWFwX2JhdGNoX29w
dHMgKm9wdHMpDQo+Pj4+ICt7DQo+Pj4+ICsgICAgICAgdW5pb24gYnBmX2F0dHIgYXR0ciA9IHt9
Ow0KPj4+PiArICAgICAgIGludCByZXQ7DQo+Pj4+ICsNCj4+Pj4gKyAgICAgICBpZiAoIU9QVFNf
VkFMSUQob3B0cywgYnBmX21hcF9iYXRjaF9vcHRzKSkNCj4+Pj4gKyAgICAgICAgICAgICAgIHJl
dHVybiAtRUlOVkFMOw0KPj4+PiArDQo+Pj4+ICsgICAgICAgbWVtc2V0KCZhdHRyLCAwLCBzaXpl
b2YoYXR0cikpOw0KPj4+PiArICAgICAgIGF0dHIuYmF0Y2gubWFwX2ZkID0gZmQ7DQo+Pj4+ICsg
ICAgICAgYXR0ci5iYXRjaC5pbl9iYXRjaCA9IHB0cl90b191NjQoaW5fYmF0Y2gpOw0KPj4+PiAr
ICAgICAgIGF0dHIuYmF0Y2gub3V0X2JhdGNoID0gcHRyX3RvX3U2NChvdXRfYmF0Y2gpOw0KPj4+
PiArICAgICAgIGF0dHIuYmF0Y2gua2V5cyA9IHB0cl90b191NjQoa2V5cyk7DQo+Pj4+ICsgICAg
ICAgYXR0ci5iYXRjaC52YWx1ZXMgPSBwdHJfdG9fdTY0KHZhbHVlcyk7DQo+Pj4+ICsgICAgICAg
aWYgKGNvdW50KQ0KPj4+PiArICAgICAgICAgICAgICAgYXR0ci5iYXRjaC5jb3VudCA9ICpjb3Vu
dDsNCj4+Pj4gKyAgICAgICBhdHRyLmJhdGNoLmVsZW1fZmxhZ3MgID0gT1BUU19HRVQob3B0cywg
ZWxlbV9mbGFncywgMCk7DQo+Pj4+ICsgICAgICAgYXR0ci5iYXRjaC5mbGFncyA9IE9QVFNfR0VU
KG9wdHMsIGZsYWdzLCAwKTsNCj4+Pj4gKw0KPj4+PiArICAgICAgIHJldCA9IHN5c19icGYoY21k
LCAmYXR0ciwgc2l6ZW9mKGF0dHIpKTsNCj4+Pj4gKyAgICAgICBpZiAoY291bnQpDQo+Pj4+ICsg
ICAgICAgICAgICAgICAqY291bnQgPSBhdHRyLmJhdGNoLmNvdW50Ow0KPj4+DQo+Pj4gd2hhdCBp
ZiBzeXNjYWxsIGZhaWxlZCwgZG8geW91IHN0aWxsIHdhbnQgdG8gYXNzaWduICpjb3VudCB0aGVu
Pw0KPj4NCj4+IEhpIEFuZHJpaSwgdGhhbmtzIGZvciB0YWtpbmcgYSBsb29rLg0KPj4NCj4+IGF0
dHIuYmF0Y2guY291bnQgc2hvdWxkIHJlcG9ydCB0aGUgbnVtYmVyIG9mIGVudHJpZXMgY29ycmVj
dGx5DQo+PiBwcm9jZXNzZWQgYmVmb3JlIGZpbmRpbmcgYW5kIGVycm9yLCBhbiBleGFtcGxlIGNv
dWxkIGJlIHdoZW4geW91DQo+PiBwcm92aWRlZCBhIGJ1ZmZlciBmb3IgMyBlbnRyaWVzIGFuZCB0
aGUgbWFwIG9ubHkgaGFzIDEsIHJldCBpcyBnb2luZw0KPj4gdG8gYmUgLUVOT0VOVCBtZWFuaW5n
IHRoYXQgeW91IHRyYXZlcnNlZCB0aGUgbWFwIGFuZCB5b3Ugc3RpbGwgd2FudCB0bw0KPj4gYXNz
aWduICpjb3VudC4NCj4gDQo+IGFoLCBvaywgdHJpY2t5IHNlbWFudGljcyA6KSBpZiBzeXNjYWxs
IGZhaWxlZCBiZWZvcmUga2VybmVsIGdvdCB0bw0KPiB1cGRhdGluZyBjb3VudCwgSSdtIGd1ZXNz
aW5nIGl0IGlzIGd1YXJhbnRlZWQgdG8gcHJlc2VydmUgb2xkIHZhbHVlPw0KPiANCj4+DQo+PiBU
aGF0IGJlaW5nIHNhaWQsIHRoZSBjb25kaXRpb24gJ2lmIChjb3VudCknIGlzIHdyb25nIGFuZCBJ
IHRoaW5rIGl0DQo+PiBzaG91bGQgYmUgcmVtb3ZlZC4NCj4gDQo+IFNvIGNvdW50IGlzIG1hbmRh
dG9yeSwgcmlnaHQ/IEluIHRoYXQgY2FzZSBib3RoIGBpZiAoY291bnQpYCBjaGVja3MgYXJlIHdy
b25nLg0KDQpBIGxpdHRsZSBiaXQgaGlzdG9yeSBoZXJlLiBTb21lIG9mIGVhcmx5IGl0ZXJhdGlv
bnMgbWF5IGhhdmUgb3BlcmF0aW9ucyANCmxpa2U6DQogICAgZGVsZXRlIHRoZSB3aG9sZSBoYXNo
IHRhYmxlDQogICAgZGVsZXRlIHRoZSBoYXNoIHRhYmxlIHN0YXJ0aW5nIGZyb20gYSBrZXkgdG8g
dGhlIGVuZC4NCiAgICBldGMuDQpJbiBzdWNoIGNhc2VzLCB1c2VyIG1heSBub3QgcGFzcyAnY291
bnQnIHRvIGtlcm5lbC4NCg0KTm93IHdlIGRvIG5vdCBzdXBwb3J0IHN1Y2ggc2NlbmFyaW9zIGFu
ZCBhbGwgc3VwcG9ydGVkIGNhc2VzDQppbiB0aGlzIHBhdGNoIHNldCByZXF1aXJlcyAnY291bnQn
LCBzbyB5ZXMsIHdlIGNhbiBtYWtlIGBjb3VudCcNCm1hbmRhdG9yeS4NCg0KPiANCj4+DQo+Pj4N
Cj4+Pj4gKw0KPj4+PiArICAgICAgIHJldHVybiByZXQ7DQo+Pj4+ICt9DQo+Pj4+ICsNCj4+Pg0K
Pj4+IFsuLi5dDQo=
