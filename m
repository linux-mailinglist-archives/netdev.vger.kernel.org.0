Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53A6487AD0
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbiAGQ51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:57:27 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.142.165]:45384 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240055AbiAGQ50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qccesdkim1;
  t=1641574646; x=1642179446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iJon5cm8vSd/Nz9BixnQaUxGIimvxyhHzno6BDXxATM=;
  b=rYXDyHB9Jl8ljQRkUcPd9HylgOmcEpf0Vpe43Qd889MDUL0qckI3k98B
   nGuLshyR5qe8cRDed/U04vSJtNZ20kVvkwRNhSjjqVFi20HnlP4O6aSPZ
   wJYxHEoSGnyY51Ow1quq1+fNzvBUmsfOojcfA+z0cACf9u1U4ASTPa/Sk
   0=;
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 16:57:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTc9BRw2eruxplIdi1Zz24PRm4Zfy1MQ35LLefugl6UUDUi4atI0abyniG249SvkcHp7j3OVPnNqu10cxaNPF1KQShnns47xz3m9kJpJhWCzuJct7OohwbbZiLAsnvWh5xdv5ZdwnABbPSysgNIAjoByBwbtsmaYuQRDedybP3My1bJ4euU5ZpGVcdBaLgyE9W4dcj6NOvQMIgmNh+3uEDOA9h/rGEFFyiIYfujw0U8UCJ9GCwh6QPQZvWgP+1takZTpWjaiyEtluiT6n9U+fMCbm6tCuinhRrQYIycymywAFAXaJb+kDq4W9jy9J/iNO/LIkUXoEQ9T7FEr3j5g2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJon5cm8vSd/Nz9BixnQaUxGIimvxyhHzno6BDXxATM=;
 b=X0RCQOknGNqO+9vl/5dOhsG9hAEtY8zsqC8OsDZKj/zOTTAQY29Q25xDBUnHI7amLYUvtBAfQVm/9WJGikOLEd3/v3w+OJTPgvZT2uMtxn1B4r29aC60pU5stRUj5o8UV+mdHho9I18mXJ5cz16mAnPtL4pcfefz+mFu5LvnuJhO/9lELAOxbuebINj7ti4s/ZSSOooewliVLXOGOvnX8L3+UibvbrrU6IH9TDmfwE08sxsKldP6nsx/zPXvQFibvYtzB85rpe28VOoxsF7IV6KTXXLBLmrh8szHSV6KkA0Y3sR52cUSLzc0C33Iq0Aiq1akYI6t5eo2aw1VcOuObg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from BN7PR02MB5236.namprd02.prod.outlook.com (2603:10b6:408:21::18)
 by BN7PR02MB4003.namprd02.prod.outlook.com (2603:10b6:406:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Fri, 7 Jan
 2022 16:57:21 +0000
Received: from BN7PR02MB5236.namprd02.prod.outlook.com
 ([fe80::e8b7:c0dc:370b:df3e]) by BN7PR02MB5236.namprd02.prod.outlook.com
 ([fe80::e8b7:c0dc:370b:df3e%2]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 16:57:21 +0000
From:   "Tyler Wear (QUIC)" <quic_twear@quicinc.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "maze@google.com" <maze@google.com>, "yhs@fb.com" <yhs@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "toke@redhat.com" <toke@redhat.com>,
        Tyler Wear <quic_twear@quicinc.org>
Subject: RE: [PATCH bpf-next v3] Add skb_store_bytes() for
 BPF_PROG_TYPE_CGROUP_SKB
Thread-Topic: [PATCH bpf-next v3] Add skb_store_bytes() for
 BPF_PROG_TYPE_CGROUP_SKB
Thread-Index: AQHYApaSDry0KMM8z0idLOMOFHbcxqxWpsSAgAEi5qA=
Date:   Fri, 7 Jan 2022 16:57:21 +0000
Message-ID: <BN7PR02MB52366E745C1EC32B57F2C06AAA4D9@BN7PR02MB5236.namprd02.prod.outlook.com>
References: <20220106004340.2317542-1-quic_twear@quicinc.com>
 <a827c4a8-44bd-54d0-2a39-f2552ae9d30f@iogearbox.net>
In-Reply-To: <a827c4a8-44bd-54d0-2a39-f2552ae9d30f@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quicinc.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86d65e1c-ffcd-4c52-43b1-08d9d1fec5a3
x-ms-traffictypediagnostic: BN7PR02MB4003:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <BN7PR02MB4003012D01217149352733FFFB4D9@BN7PR02MB4003.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yWUTG0skviAEBae342OK/yxdEbh9R3vw/743jsHImODpcYmwJJXHzroDP3QjF7CC8R+4IiojntdtvSo6mP52NWvdprNZ69vURf8b2tniaSJ9HuXgyTETjcgD8PYm3Kk/LBYVA79PcYPGPLxUEWsQfKlVLA8y4ufh2c4nIELoUgC8kt5eAMUcRZUZ5cjX05En12a3SG65rth6DQxvumZNqBWSD2IbLW47QvVzJrDBADi3RxVZoCO0EJw2OKN3Zz9Tp73n+rWbbHqm8UR9vvBToKV+Vjf6+sEXSkPT9Abu5flXetpn0YbvJfHF3IJUa4cJrxt2QqNjOicaIBg0wcfDw/QWl1EV84GnCN8RE6mT+PkdBTeIx4PKk0qUlLcZpPxMlsAS3cqRvPEMmxoJhAFMBAGrFBJoQ+pbHZf3svuQ3JCP3m1rsyColRrAF0a3RqYg/AQTgsV7eDbPu8ZnDHQinB/V6KZQxL+KMklUeYPjuGfWDLZQrMLLcx4eqXsk9GJV42d0ONyeGx8Cd5ri2QbAAH8AoA9YlAXroG3BHQ+XZwgbiUPFmzlRU8F9WWYka7eVlcDz3KSOxXCJNqgkxO2IjIz8JgyfI4mSFOApzPa+YyPgE/xkbM3W181ivFXlGvA/PEcxtNag7ixhL1euKdpErnXkUsFx3LdZ4X9TqJSGle+jdN61Q+8d/cebvD5I3sBwLvY6AX/5k1VC/3wDU5zSkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR02MB5236.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(54906003)(38070700005)(8936002)(9686003)(33656002)(7696005)(83380400001)(508600001)(8676002)(38100700002)(66556008)(66476007)(76116006)(66946007)(2906002)(66446008)(64756008)(53546011)(86362001)(6506007)(186003)(4326008)(110136005)(26005)(52536014)(5660300002)(316002)(55016003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTMzcGkwY1dpakpRWHR4OHVBTjJwekFpWTg1d0IzV1Bkbm5YUnFLSlcyOXVp?=
 =?utf-8?B?Vld6cksrRXFWVGppdE1QWmhRS3RndGhObHhoNVdGTnBHTVd5cmwvR2FqNlZu?=
 =?utf-8?B?U0t1enJucEVrZmZUTTh2aThnVXZJdWZSQk5ma2NURHFteTNJaHF6S1VEQWcw?=
 =?utf-8?B?QUR6TWl3TlJjcnorVUdQdm5oRlVHQUd6Y2pDbi9XNzgyOTdEUks4Q2ppY0Jq?=
 =?utf-8?B?ckMwUUszS0pBa2ZnZDhpSTJRZWdYdVZ6bk5oL0lGTml3L1ZQV24xMTNXcnQ1?=
 =?utf-8?B?elYwT3M4WTVqYk9rc3lORHkzNU5STWpycE5NZERPNW0ybXAxcHFSU2JSVGsz?=
 =?utf-8?B?QTBPbXdHVEhoRmI0elljRlkvZG4zVW9RVVJzYXJlSldxc3BxUHJCa1hBZHpi?=
 =?utf-8?B?MnZQeHVtU0JhWGpiaVl6ZE0xSG85V3lrN0NaL0hFNm96NFZUazZHNTYwQVZQ?=
 =?utf-8?B?WUs2Snp3bVNxSEhSZGRqUWRvV1dnbWhHclhlUER3bFE1Um9pc3liNkhlTnUz?=
 =?utf-8?B?Y21PYXVnZ3p3eWpsR0EzRHBOcWFlaFZEMWNDTVo0UjZIMVR5NS95bE44aExP?=
 =?utf-8?B?bm5MQXNoLzVJVEZ6SlQ4SEZCaFUyYXZ1TVg3UTNJQ1JVTHNVNU8zc2xQaGkz?=
 =?utf-8?B?VDVyNnpNK0l1Zlo1dWFEdnVYcHkrR3IvQ1VGR0JuSjZuVGVaWkpoNXMzSmRm?=
 =?utf-8?B?b25rZjhaSTZ5V2pBc1VLSDlyS0FYd0E2YTZmMnZrQ1BObXE2OE56SFY3bGxU?=
 =?utf-8?B?a0d0ZWd0WTh6ZS90WllSWHZjeXR5aEVFbmQwVlNvM2NkbHpybDhTUGtmdDhh?=
 =?utf-8?B?OFdIQU0vSEhQdll0VmhlWFpuZi9XY2svMFBjOVFmc3lqd0p1M25mcnZRUnRJ?=
 =?utf-8?B?TnBqNWFwNmZ1Qm9qYUJacGNia3F2TTlrcnFNWDJXSmtaNmFsWkJtMWtZRG5o?=
 =?utf-8?B?TmxPdyt0cW5BQlR6Y25salQ4RjJORmlyWWVHSzVPZHByQzJPdWx0Szd2MXhO?=
 =?utf-8?B?MVFXWHIrRGErY1BtWnl3SWJWU1ZiOFM4RU9YNzBhZ1cvTUYzSlFEbnI5ZVdO?=
 =?utf-8?B?NTZ1NnhzV09GTzYrNTFFNUE4U1hGVTFCTlBCWjc2czZrYWUwUVFpbS9VUExl?=
 =?utf-8?B?bXNGSnNYbWthVVV0ZWdaUDZyUHphR1J6ZDJWM0NPZVA5dit5N3F4TEJQcVBP?=
 =?utf-8?B?ZE8xLzZRNnF0Q0Y2eVF3dHN2Z0R4YktUeTJRNTAvMjhPQmYrN3VXMFUvekg3?=
 =?utf-8?B?Tk1DWVppUHhkZTRJWFYxQnJBZU5wNTlna1ppYzZHUW1kUzJLWFNkd2lVUE84?=
 =?utf-8?B?WjYxaWR5NmhrRG51em1EOVZtaDlPdVZzQWN4UWFGSThlV056T2x4OEpFNHIw?=
 =?utf-8?B?dEdSOFpiWFMySzN3eWpGdmkwa2g3dUw0Wmx6VzBrblIwZVpES01kVHZvQTR4?=
 =?utf-8?B?U1dmamxXV2JzbGlWcE9odmVNbjAxVDYzdUJIekZWQzkxbC9OSEY0UVpIalkv?=
 =?utf-8?B?QzBNS093ckh1aEtWN3VKYzBXczdPZm1od0hFdXFlc0lFcCtaZHdnUDZCTjM4?=
 =?utf-8?B?ZDBHekN4RHhkM201MGV6bVVwVmt1cE9HSEN1OEkzbnJHR3Ara0Y3YUtQOGJZ?=
 =?utf-8?B?ZXZiNXdoYlV5UnczbzhvZWo4REp0N2pkQ2l2bFZJcXVYV09iN3hIOVo4WVla?=
 =?utf-8?B?R0pOdnRyYVRBTkU3WEM2QStKNnNtL3pUVHpFTXF4SU1SMHNhOVVSNkowZGg1?=
 =?utf-8?B?N0FpQzZFdGo1VjVMMThNRnVPTkM1akl5YUVOM29VWS9DakR6TjRqbVhtQ3RX?=
 =?utf-8?B?MEFhbEZjUFk5MHlXZlk1dFNtdG1rTUpWckZLdmR2T1h4aFVTbXk2d0c0RENF?=
 =?utf-8?B?QjZDdGRQUzNlelpIZ1RPTkY5cVdjWVpHUjlPTmZ1WVU3cWlLVTNZcWJRb1l6?=
 =?utf-8?B?Nml3em9ydWJOcnZiTzdWVDhwQms2RFpHRWdQVnNteWhEclU4bzJEazg0QVcz?=
 =?utf-8?B?bU5wbjluL2U0dEpMdFV0enE5YTBWZENwNStRNzdFa3dtY2FVYUlxYW9YRzBD?=
 =?utf-8?B?UDNJVll0azIxcVJsV3BZc3Zidk5DYlA3Qnc4bDR5MFJMd0tWQXBabCtpNzBD?=
 =?utf-8?B?QmtYdHhqRHNRWFhsTE5QZXJWOHlDSVhTZkRhdWlpR0JoWlhuTXZnT01NVGpF?=
 =?utf-8?B?WEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR02MB5236.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d65e1c-ffcd-4c52-43b1-08d9d1fec5a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 16:57:21.6251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YJay8S0Ww0R5q4QCQ4T5sHXVCn7dabVKCbnVhX4vtgYBSF3cwnH8RzeV3j1qKhid/C4FI6BqRTZXVLUpvZwRVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB4003
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuaWVsIEJvcmttYW5u
IDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4NCj4gU2VudDogVGh1cnNkYXksIEphbnVhcnkgNiwgMjAy
MiAzOjM1IFBNDQo+IFRvOiBUeWxlciBXZWFyIChRVUlDKSA8cXVpY190d2VhckBxdWljaW5jLmNv
bT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGJwZkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IG1h
emVAZ29vZ2xlLmNvbTsgeWhzQGZiLmNvbTsga2FmYWlAZmIuY29tOyB0b2tlQHJlZGhhdC5jb207
IFR5bGVyIFdlYXIgPHF1aWNfdHdlYXJAcXVpY2luYy5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggYnBmLW5leHQgdjNdIEFkZCBza2Jfc3RvcmVfYnl0ZXMoKSBmb3IgQlBGX1BST0dfVFlQRV9D
R1JPVVBfU0tCDQo+IA0KPiBXQVJOSU5HOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRz
aWRlIG9mIFF1YWxjb21tLiBQbGVhc2UgYmUgd2FyeSBvZiBhbnkgbGlua3Mgb3IgYXR0YWNobWVu
dHMsIGFuZCBkbyBub3QgZW5hYmxlIG1hY3Jvcy4NCj4gDQo+IE9uIDEvNi8yMiAxOjQzIEFNLCBU
eWxlciBXZWFyIHdyb3RlOg0KPiA+IEZyb206IFR5bGVyIFdlYXIgPHF1aWNfdHdlYXJAcXVpY2lu
Yy5vcmc+DQo+ID4NCj4gPiBOZWVkIHRvIG1vZGlmeSB0aGUgZHMgZmllbGQgdG8gc3VwcG9ydCB1
cGNvbWluZyBXaWZpIFFvUyBBbGxpYW5jZSBzcGVjLg0KPiA+IEluc3RlYWQgb2YgYWRkaW5nIGdl
bmVyaWMgZnVuY3Rpb24gZm9yIGp1c3QgbW9kaWZ5aW5nIHRoZSBkcyBmaWVsZCwNCj4gPiBhZGQg
c2tiX3N0b3JlX2J5dGVzIGZvciBCUEZfUFJPR19UWVBFX0NHUk9VUF9TS0IuDQo+ID4gVGhpcyBh
bGxvd3Mgb3RoZXIgZmllbGRzIGluIHRoZSBuZXR3b3JrIGFuZCB0cmFuc3BvcnQgaGVhZGVyIHRv
IGJlDQo+ID4gbW9kaWZpZWQgaW4gdGhlIGZ1dHVyZS4NCj4gPg0KPiA+IENoZWNrc3VtIEFQSSdz
IGFsc28gbmVlZCB0byBiZSBhZGRlZCBmb3IgY29tcGxldGVuZXNzLg0KPiA+DQo+ID4gSXQgaXMg
bm90IHBvc3NpYmxlIHRvIHVzZSBDR1JPVVBfKFNFVHxHRVQpU09DS09QVCBzaW5jZSB0aGUgcG9s
aWN5IG1heQ0KPiA+IGNoYW5nZSBkdXJpbmcgcnVudGltZSBhbmQgd291bGQgcmVzdWx0IGluIGEg
bGFyZ2UgbnVtYmVyIG9mIGVudHJpZXMNCj4gPiB3aXRoIHdpbGRjYXJkcy4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFR5bGVyIFdlYXIgPHF1aWNfdHdlYXJAcXVpY2luYy5jb20+DQo+ID4gLS0t
DQo+ID4gICBuZXQvY29yZS9maWx0ZXIuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAx
MCArKw0KPiA+ICAgLi4uL2JwZi9wcm9nX3Rlc3RzL2Nncm91cF9zdG9yZV9ieXRlcy5jICAgICAg
IHwgOTcgKysrKysrKysrKysrKysrKysrKw0KPiA+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3Mv
Y2dyb3VwX3N0b3JlX2J5dGVzLmMgIHwgNjQgKysrKysrKysrKysrDQo+ID4gICAzIGZpbGVzIGNo
YW5nZWQsIDE3MSBpbnNlcnRpb25zKCspDQo+ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvY2dyb3VwX3N0b3JlX2J5dGVzLmMNCj4g
PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiA+IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9w
cm9ncy9jZ3JvdXBfc3RvcmVfYnl0ZXMuYw0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL25ldC9jb3Jl
L2ZpbHRlci5jIGIvbmV0L2NvcmUvZmlsdGVyLmMgaW5kZXgNCj4gPiA2MTAyZjA5M2Q1OWEuLmNl
MDFhODAzNjM2MSAxMDA2NDQNCj4gPiAtLS0gYS9uZXQvY29yZS9maWx0ZXIuYw0KPiA+ICsrKyBi
L25ldC9jb3JlL2ZpbHRlci5jDQo+ID4gQEAgLTcyOTksNiArNzI5OSwxNiBAQCBjZ19za2JfZnVu
Y19wcm90byhlbnVtIGJwZl9mdW5jX2lkIGZ1bmNfaWQsIGNvbnN0IHN0cnVjdCBicGZfcHJvZyAq
cHJvZykNCj4gPiAgICAgICAgICAgICAgIHJldHVybiAmYnBmX3NrX3N0b3JhZ2VfZGVsZXRlX3By
b3RvOw0KPiA+ICAgICAgIGNhc2UgQlBGX0ZVTkNfcGVyZl9ldmVudF9vdXRwdXQ6DQo+ID4gICAg
ICAgICAgICAgICByZXR1cm4gJmJwZl9za2JfZXZlbnRfb3V0cHV0X3Byb3RvOw0KPiA+ICsgICAg
IGNhc2UgQlBGX0ZVTkNfc2tiX3N0b3JlX2J5dGVzOg0KPiA+ICsgICAgICAgICAgICAgcmV0dXJu
ICZicGZfc2tiX3N0b3JlX2J5dGVzX3Byb3RvOw0KPiA+ICsgICAgIGNhc2UgQlBGX0ZVTkNfY3N1
bV91cGRhdGU6DQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gJmJwZl9jc3VtX3VwZGF0ZV9wcm90
bzsNCj4gPiArICAgICBjYXNlIEJQRl9GVU5DX2NzdW1fbGV2ZWw6DQo+ID4gKyAgICAgICAgICAg
ICByZXR1cm4gJmJwZl9jc3VtX2xldmVsX3Byb3RvOw0KPiA+ICsgICAgIGNhc2UgQlBGX0ZVTkNf
bDNfY3N1bV9yZXBsYWNlOg0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuICZicGZfbDNfY3N1bV9y
ZXBsYWNlX3Byb3RvOw0KPiA+ICsgICAgIGNhc2UgQlBGX0ZVTkNfbDRfY3N1bV9yZXBsYWNlOg0K
PiA+ICsgICAgICAgICAgICAgcmV0dXJuICZicGZfbDRfY3N1bV9yZXBsYWNlX3Byb3RvOw0KPiA+
ICAgI2lmZGVmIENPTkZJR19TT0NLX0NHUk9VUF9EQVRBDQo+ID4gICAgICAgY2FzZSBCUEZfRlVO
Q19za2JfY2dyb3VwX2lkOg0KPiA+ICAgICAgICAgICAgICAgcmV0dXJuICZicGZfc2tiX2Nncm91
cF9pZF9wcm90bzsNCj4gDQo+IERvIHdlIG5lZWQgc2tiX3NoYXJlX2NoZWNrIGluIHRoZSB3cml0
ZSBoZWxwZXJzIGF0IHRoZXNlIGhvb2sgcG9pbnRzIHdoZW4gdGhpcyBnb2VzIGJleW9uZCBqdXN0
IHJlYWRpbmc/DQo+IA0KPiBUaGFua3MsDQo+IERhbmllbA0KDQpJcyB0aGVyZSBhIGRpZmZlcmVu
Y2UgaGVyZSBiZXR3ZWVuIHRoZSBjZ19za2IgYW5kIG90aGVyIGZ1bmN0aW9uIHByb3RvJ3MgdGhh
dCB3b3VsZCByZXF1aXJlIHNrYl9zaGFyZV9jaGVjaz8gU2luY2UgdGhlc2UgZnVuY3Rpb24gcHJv
dG8ncyBhbHJlYWR5IGV4aXN0IGZvciBvdGhlciBhdHRhY2ggdHlwZXMgaXQgc2hvdWxkIGJlIGZp
bmUgcmlnaHQ/DQo=
