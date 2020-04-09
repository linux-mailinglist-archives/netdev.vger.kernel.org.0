Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B57531A2DF9
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 05:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgDIDbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 23:31:19 -0400
Received: from mail-eopbgr00083.outbound.protection.outlook.com ([40.107.0.83]:46662
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726545AbgDIDbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 23:31:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6GXm9ejkWeD8K05zl1OET56yocvXNyWEHruNU47UX0yv/qY7S2GSr8B12gkxNidw1a+vVwUJCdGJr11XWuzoGhDBEb1QDBlrwIaEwdPgW1NjsTrURMrR0kR7XiCin7S5eTOs/ArR4AajDE95wVUQ4aSLEtQp23CWl2jFbhQBikELshfJakb62FhnkJcjpQMNxm/rL4Ir5+BMJTybDg/cGJi6fokJMUjPpPtnDK248CjnU2CLsMKGE3WuRB6KKoE2qOV8Q+CRLOITqRnQ0IDuFXKyLsnx3iPQQ5I5V2MUM9aGlXnWtyukHt7g+YfG1h/9LL4Eu5pWcHZK8dW5kSF/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSCHUkMGeaKV2XJAOjV2X5QtyQvr0dpl0Ua3ag1NHPY=;
 b=GhDzCG2LeXTYi8czwrsxKIBb7xSBaWhNhcnv6HBMfxnI629BPKPNJH1pUsgJ8BoR8lxp3w/sZvi7AOmRRV58tqi3Gcilhi6ogpVjmgrPh3KP3r0xAowBUOYjbx2HP3gdktNyGmUior1ghtKq/uER46e9nvhxowzusxMu56eocWPZA9b8qlUWgGx82XK92epyid5t2zc72Ai9C9JksiPwQ/k9fFhe1LFc3ztgBhd8ozt/FZedP45IpFv8AcDUheKkiIXkF3BRodeekl2f2xjTBe9sQN52sJfubN5Rzs17mz3eAMfdr3yiHq3FWckMOhSo9FezYMn5kojw7OWUR79RXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSCHUkMGeaKV2XJAOjV2X5QtyQvr0dpl0Ua3ag1NHPY=;
 b=jpMn4VlZ2Q02/3PLjYSJKcDXBi+EGkEioV+i+5wXvfMxR5xb+OjUT8afMHDEsYutZAdwyzqtAirLPmjEZp4hy696ZGAmhM3+3uvWXthqdJXD9KmXKbtK3UFxs++9wsXNYwe02rmjSq+9WMXiin+eMzY5OtjPiZVJvdtYQFJqNnU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5311.eurprd05.prod.outlook.com (2603:10a6:803:a3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Thu, 9 Apr
 2020 03:31:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Thu, 9 Apr 2020
 03:31:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "brouer@redhat.com" <brouer@redhat.com>
CC:     "toke@redhat.com" <toke@redhat.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH RFC v2 29/33] xdp: allow bpf_xdp_adjust_tail() to grow
 packet size
Thread-Topic: [PATCH RFC v2 29/33] xdp: allow bpf_xdp_adjust_tail() to grow
 packet size
Thread-Index: AQHWDZxJfZ/xt+YpZkKzQLVfnT6456hwI2iA
Date:   Thu, 9 Apr 2020 03:31:14 +0000
Message-ID: <ed0ce4d76e77b23aa3edcd821d5a4867e8bb27b1.camel@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
         <158634678170.707275.10720666808605360076.stgit@firesoul>
In-Reply-To: <158634678170.707275.10720666808605360076.stgit@firesoul>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b96e4160-f191-41ce-cfc0-08d7dc36751c
x-ms-traffictypediagnostic: VI1PR05MB5311:
x-microsoft-antispam-prvs: <VI1PR05MB53110245BEDD97D0D5415CB8BEC10@VI1PR05MB5311.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:245;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39850400004)(136003)(396003)(366004)(376002)(346002)(81156014)(54906003)(8936002)(8676002)(6506007)(186003)(26005)(6486002)(86362001)(2616005)(66446008)(64756008)(478600001)(76116006)(36756003)(66476007)(66556008)(7416002)(4326008)(5660300002)(66946007)(81166007)(316002)(2906002)(6916009)(71200400001)(6512007)(91956017);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BHHsXLeFqDM9sJaOpaAjGH3AKa4bzWhsfeho9VohoMzahPDnT20w1rHmpZIkqSrcT9lc4DXDSLZ/oELX0paZLmXHO0nFecjVi8EZEKafv7eoXqr5RtVltfjR5nblyaUs4Q9bSi/lD/MOlenhQHUMtDqNw4KUePTROv6DzAIhNEtX+m2M0ghJyfjuCabRBfR7kEXAFEZnY8PsJXhel64YVH0siGU4z974ZXxuCEbm+QiIbqA1SDLevQWlQKlAL//FdcBL8Aogj4QWVtz1M4CCa54Ld5m87TKOvcthXR0kOflGAClgb3eNfss2orJSwvkGn9A14odh1o7HiEXMtbZ4MXRPS9OQCoRjZTyJbq9DkJr8f13qrzhqmZIkcoQmXDggLP/1gaiq8aH4sQ3HhADBQLj9hnE740PC0uQXvJZDkbVS2IS87lkPUzTZIBBS7uZ/
x-ms-exchange-antispam-messagedata: mgNJgYl8MKl0PDpaUEjUbkIkdywPqUVPHNAkJlLxoxT70quSg71SBmfxCMJt2ljWwKP+i9RnjPL5ykbxhIkEHrG8pCa7B70ZDip2MfGjNfOVGpHmi25Cl6L8KPA2i1qjV3tE0syObqW9uxL2eK1SOA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AE39168E02CF14AA9BB697C6B6FD290@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b96e4160-f191-41ce-cfc0-08d7dc36751c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 03:31:14.6042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YyUl12WDBGCZucyuPBjRZjYxj/jlNXgdxfELZKsPWZ80ivwL5o+2EKrNzfpFDv3S4Q8h0U9DastqrFA/7w81Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTA4IGF0IDEzOjUzICswMjAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IHdyb3RlOg0KPiBGaW5hbGx5LCBhZnRlciBhbGwgZHJpdmVycyBoYXZlIGEgZnJhbWUgc2l6ZSwg
YWxsb3cgQlBGLWhlbHBlcg0KPiBicGZfeGRwX2FkanVzdF90YWlsKCkgdG8gZ3JvdyBvciBleHRl
bmQgcGFja2V0IHNpemUgYXQgZnJhbWUgdGFpbC4NCj4gDQoNCmNhbiB5b3UgcHJvdmlkZSBhIGxp
c3Qgb2YgdXNlY2FzZXMgZm9yIHdoeSB0YWlsIGV4dGVuc2lvbiBpcyBuZWNlc3NhcnkNCj8NCg0K
YW5kIHdoYXQgZG8geW91IGhhdmUgaW4gbWluZCBhcyBpbW1lZGlhdGUgdXNlIG9mIGJwZl94ZHBf
YWRqdXN0X3RhaWwoKQ0KPyANCg0KYm90aCBjb3ZlciBsZXR0ZXIgYW5kIGNvbW1pdCBtZXNzYWdl
cyBkaWRuJ3QgbGlzdCBhbnkgYWN0dWFsIHVzZSBjYXNlLi4NCg0KPiBSZW1lbWJlciB0aGF0IGhl
bHBlci9tYWNybyB4ZHBfZGF0YV9oYXJkX2VuZCBoYXZlIHJlc2VydmVkIHNvbWUNCj4gdGFpbHJv
b20uICBUaHVzLCB0aGlzIGhlbHBlciBtYWtlcyBzdXJlIHRoYXQgdGhlIEJQRi1wcm9nIGRvbid0
IGhhdmUNCj4gYWNjZXNzIHRvIHRoaXMgdGFpbHJvb20gYXJlYS4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEplc3BlciBEYW5nYWFyZCBCcm91ZXIgPGJyb3VlckByZWRoYXQuY29tPg0KPiAtLS0NCj4g
IGluY2x1ZGUvdWFwaS9saW51eC9icGYuaCB8ICAgIDQgKystLQ0KPiAgbmV0L2NvcmUvZmlsdGVy
LmMgICAgICAgIHwgICAxOCArKysrKysrKysrKysrKysrLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwg
MTggaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL3VhcGkvbGludXgvYnBmLmggYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gaW5kZXgg
MmUyOWE2NzFkNjdlLi4wZTVhYmU5OTFjYTMgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvdWFwaS9s
aW51eC9icGYuaA0KPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gQEAgLTE5Njks
OCArMTk2OSw4IEBAIHVuaW9uIGJwZl9hdHRyIHsNCj4gICAqIGludCBicGZfeGRwX2FkanVzdF90
YWlsKHN0cnVjdCB4ZHBfYnVmZiAqeGRwX21kLCBpbnQgZGVsdGEpDQo+ICAgKiAJRGVzY3JpcHRp
b24NCj4gICAqIAkJQWRqdXN0IChtb3ZlKSAqeGRwX21kKlwgKiotPmRhdGFfZW5kKiogYnkgKmRl
bHRhKg0KPiBieXRlcy4gSXQgaXMNCj4gLSAqIAkJb25seSBwb3NzaWJsZSB0byBzaHJpbmsgdGhl
IHBhY2tldCBhcyBvZiB0aGlzIHdyaXRpbmcsDQo+IC0gKiAJCXRoZXJlZm9yZSAqZGVsdGEqIG11
c3QgYmUgYSBuZWdhdGl2ZSBpbnRlZ2VyLg0KPiArICogCQlwb3NzaWJsZSB0byBib3RoIHNocmlu
ayBhbmQgZ3JvdyB0aGUgcGFja2V0IHRhaWwuDQo+ICsgKiAJCVNocmluayBkb25lIHZpYSAqZGVs
dGEqIGJlaW5nIGEgbmVnYXRpdmUgaW50ZWdlci4NCj4gICAqDQo+ICAgKiAJCUEgY2FsbCB0byB0
aGlzIGhlbHBlciBpcyBzdXNjZXB0aWJsZSB0byBjaGFuZ2UgdGhlDQo+IHVuZGVybHlpbmcNCj4g
ICAqIAkJcGFja2V0IGJ1ZmZlci4gVGhlcmVmb3JlLCBhdCBsb2FkIHRpbWUsIGFsbCBjaGVja3Mg
b24NCj4gcG9pbnRlcnMNCj4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL2ZpbHRlci5jIGIvbmV0L2Nv
cmUvZmlsdGVyLmMNCj4gaW5kZXggNzYyOGI5NDdkYmMzLi40ZDU4YTE0N2VlZDAgMTAwNjQ0DQo+
IC0tLSBhL25ldC9jb3JlL2ZpbHRlci5jDQo+ICsrKyBiL25ldC9jb3JlL2ZpbHRlci5jDQo+IEBA
IC0zNDIyLDEyICszNDIyLDI2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8N
Cj4gYnBmX3hkcF9hZGp1c3RfaGVhZF9wcm90byA9IHsNCj4gIA0KPiAgQlBGX0NBTExfMihicGZf
eGRwX2FkanVzdF90YWlsLCBzdHJ1Y3QgeGRwX2J1ZmYgKiwgeGRwLCBpbnQsIG9mZnNldCkNCj4g
IHsNCj4gKwl2b2lkICpkYXRhX2hhcmRfZW5kID0geGRwX2RhdGFfaGFyZF9lbmQoeGRwKTsNCj4g
IAl2b2lkICpkYXRhX2VuZCA9IHhkcC0+ZGF0YV9lbmQgKyBvZmZzZXQ7DQo+ICANCj4gLQkvKiBv
bmx5IHNocmlua2luZyBpcyBhbGxvd2VkIGZvciBub3cuICovDQo+IC0JaWYgKHVubGlrZWx5KG9m
ZnNldCA+PSAwKSkNCj4gKwkvKiBOb3RpY2UgdGhhdCB4ZHBfZGF0YV9oYXJkX2VuZCBoYXZlIHJl
c2VydmVkIHNvbWUgdGFpbHJvb20gKi8NCj4gKwlpZiAodW5saWtlbHkoZGF0YV9lbmQgPiBkYXRh
X2hhcmRfZW5kKSkNCj4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+ICANCg0KaSBkb24ndCBrbm93IGlm
IGkgbGlrZSB0aGlzIGFwcHJvYWNoIGZvciBjb3VwbGUgb2YgcmVhc29ucy4NCg0KMS4gZHJpdmVy
cyB3aWxsIHByb3ZpZGUgYXJiaXRyYXJ5IGZyYW1lc19zeiwgd2hpY2ggaXMgbm9ybWFsbHkgbGFy
Z2VyDQp0aGFuIG10dSwgYW5kIGNvdWxkIGJlIGEgZnVsbCBwYWdlIHNpemUsIGZvciBYRFBfVFgg
YWN0aW9uIHRoaXMgY2FuIGJlDQpwcm9ibGVtYXRpYyBpZiB4ZHAgcHJvZ3Mgd2lsbCBhbGxvdyBv
dmVyc2l6ZWQgcGFja2V0cyB0byBnZXQgY2F1Z2h0IGF0DQp0aGUgZHJpdmVyIGxldmVsLi4gDQoN
CjIuIHhkcF9kYXRhX2hhcmRfZW5kKHhkcCkgaGFzIGEgaGFyZGNvZGVkIGFzc3VtcHRpb24gb2Yg
dGhlIHNrYiBzaGluZm8NCmFuZCBpdCBpbnRyb2R1Y2VzIGEgcmV2ZXJzZSBkZXBlbmRlbmN5IGJl
dHdlZW4geGRwIGJ1ZmYgYW5kIHNrYnVmZiANCg0KYm90aCBvZiB0aGUgYWJvdmUgY2FuIGJlIHNv
bHZlZCBpZiB0aGUgZHJpdmVycyBwcm92aWRlZCB0aGUgbWF4IGFsbG93ZWQNCmZyYW1lIHNpemUs
IGFscmVhZHkgYWNjb3VudGluZyBmb3IgbXR1IGFuZCBzaGluZm8gd2hlbiBzZXR0aW5nDQp4ZHBf
YnVmZi5mcmFtZV9zeiBhdCB0aGUgZHJpdmVyIGxldmVsLg0KDQoNCj4gKwkvKiBEQU5HRVI6IEFM
TCBkcml2ZXJzIE1VU1QgYmUgY29udmVydGVkIHRvIGluaXQgeGRwLT5mcmFtZV9zeg0KPiArCSAq
IC0gQWRkaW5nIHNvbWUgY2hpY2tlbiBjaGVja3MgYmVsb3cNCj4gKwkgKiAtIFdpbGwgKGxpa2Vs
eSkgbm90IGJlIGZvciB1cHN0cmVhbQ0KPiArCSAqLw0KPiArCWlmICh1bmxpa2VseSh4ZHAtPmZy
YW1lX3N6IDwgKHhkcC0+ZGF0YV9lbmQgLSB4ZHAtDQo+ID5kYXRhX2hhcmRfc3RhcnQpKSkgew0K
PiArCQlXQVJOKDEsICJUb28gc21hbGwgeGRwLT5mcmFtZV9zeiA9ICVkXG4iLCB4ZHAtDQo+ID5m
cmFtZV9zeik7DQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArCX0NCj4gKwlpZiAodW5saWtlbHko
eGRwLT5mcmFtZV9zeiA+IFBBR0VfU0laRSkpIHsNCj4gKwkJV0FSTigxLCAiVG9vIEJJRyB4ZHAt
PmZyYW1lX3N6ID0gJWRcbiIsIHhkcC0+ZnJhbWVfc3opOw0KPiArCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gKwl9DQo+ICsNCj4gIAlpZiAodW5saWtlbHkoZGF0YV9lbmQgPCB4ZHAtPmRhdGEgKyBFVEhf
SExFTikpDQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiAgDQo+IA0KPiANCg==
