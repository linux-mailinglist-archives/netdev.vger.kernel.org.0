Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E177A41B18B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbhI1OGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:06:34 -0400
Received: from mail-co1nam11on2103.outbound.protection.outlook.com ([40.107.220.103]:32324
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240172AbhI1OGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 10:06:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DejgXHw/ah+J/2SIKAdo2yOBtJz4+FMppbmzKquTjU0jK0egrYe+mMPI6Pm2MhRPXWVUk1oYvs2EIkEoB3bJ00hcsLAMbeCKk22MMqsMZ48peiBp4No8HyG5cGkR9+325JJgOhs87h2OfDL5qBAv/49T3DQw4Ny0c80JkczUukTssdpKSFaeLrDOZFp4jQ9VjGBq++zh/2w9IcyFWRja0iwF8PZHSboaG0orXVmCkZ6Ul6Nocb87mV+tKwSvQ3iUJWAURH9Ic39U0X9NOg0uGAUx2cXrMBpT4rkVl+t3/EauAjIgOA/v9x4bWNYUtV8apFym71vOoA+HbfhG3yU3Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WsicuKH/qDKXKrTexFe4tUOYXiMKoN5cs1HlDRxq6bc=;
 b=l1w3T9OKL2RYUGP3HIrZCxCPNyhdEWpN7Ltnn2ZSlghh8UjEK9CEfA91vz/Q1OuGw0iQWYLHgtCkyftYXLU7tHoEDqm3rSU1tbvG3Et0WPDyHHkJfQQPFC8zc3uKyvRv2XzImmfy3jrVOGz6Om393glqnjYfkMOE7r0zDJ7O1QYZXzuVsYgwtb2MHQelyBj1UwYSyv2fEv9J+dCTvHDLRFuPQCdIs+v1oSMAZbFyqPtNSzhZpQLPXkD8IdiGyFvRoJY9bGIzFyhQWTRSuFGsMf1cQLvNCAjaByyjbqYxsLi2sYwXcWdUfPWDiot0AZuY7GjYx8gO7bekLqj1L97rdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsicuKH/qDKXKrTexFe4tUOYXiMKoN5cs1HlDRxq6bc=;
 b=SlgfEHVe4OQTsZ8WQIkzhRdIPcQEATiJreccE6hWCgAoS8jABCvDCjmayl7/+uHOYNwLPJO7sh/LWaL2otFtlWJ/N5aEGWlsueV6eR4XrywFAURu0jaMVYeCCR8yWtaKLiM5EvWdzBDCfkYcRkNJRMfXy/jF2c5mTKH5q3h5CdU=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by CH2PR13MB3495.namprd13.prod.outlook.com (2603:10b6:610:14::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.10; Tue, 28 Sep
 2021 14:04:50 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::185b:505d:b35c:a3a2]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::185b:505d:b35c:a3a2%6]) with mapi id 15.20.4566.014; Tue, 28 Sep 2021
 14:04:50 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "bfields@fieldses.org" <bfields@fieldses.org>
CC:     "neilb@suse.com" <neilb@suse.com>,
        "kolga@netapp.com" <kolga@netapp.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "tyhicks@canonical.com" <tyhicks@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wanghai38@huawei.com" <wanghai38@huawei.com>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "kuniyu@amazon.co.jp" <kuniyu@amazon.co.jp>,
        "timo@rothenpieler.org" <timo@rothenpieler.org>,
        "jiang.wang@bytedance.com" <jiang.wang@bytedance.com>,
        "wenbin.zeng@gmail.com" <wenbin.zeng@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rao.Shoaib@oracle.com" <Rao.Shoaib@oracle.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "tom@talpey.com" <tom@talpey.com>
Subject: Re: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Thread-Topic: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Thread-Index: AQHXtBciMSJq8UTGIk29qdNL+Xnf4qu5ccKAgAAFewCAAAQtAA==
Date:   Tue, 28 Sep 2021 14:04:49 +0000
Message-ID: <77051a059fa19a7ae2390fbda7f8ab6f09514dfc.camel@hammerspace.com>
References: <20210928031440.2222303-1-wanghai38@huawei.com>
         <20210928031440.2222303-3-wanghai38@huawei.com>
         <a845b544c6592e58feeaff3be9271a717f53b383.camel@hammerspace.com>
         <20210928134952.GA25415@fieldses.org>
In-Reply-To: <20210928134952.GA25415@fieldses.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fieldses.org; dkim=none (message not signed)
 header.d=none;fieldses.org; dmarc=none action=none
 header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bf7d50f-3ad6-41cc-9f6b-08d98288efea
x-ms-traffictypediagnostic: CH2PR13MB3495:
x-microsoft-antispam-prvs: <CH2PR13MB3495A47BC72FC57DF794DEBEB8A89@CH2PR13MB3495.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P4PrBbfAqCRj28+7oi94E/1Gt0EiW8CvPt3LlHa67rD5hBDEHkfc/77uE/RyiPhlTCSpdy6wzOCP1ACWG8AXzcazvWG0LutCmFfoUMwDcOOLY0vxbx5jZX9kGr01l+LfdRZhi5wJphDGoU/PQnZtX05mBSHuObVrfZtOVZvVHrUOzN3BGLAfjvJmnDOHF0Frcr6XOsUtbN+3oyzG9erR6zEBVHB77srFAyPeQSMpLU9ojXBqPe7FBC/mWRX33dCgY6sYUScEiYE2ozcvf2m0s3qBiXOpQ7gwfTSDjAK3+arSkQjj0cb212q0rkQTDnVpQnb4X3hl7yVdFuJ+FtkdV0jwdK2f+x+/w6vH9KCwMb0jUD9/H+cAgrgWxf/7NHVjUbjqX+CU4nKngcPsUYjMyuQ2hQG1gma+RWGFt34trkRjwe0vpqdl+HV2Ck82d2QFQEOGcZQuzq14EDZ9bIWuDRKd3JKZn3CFVPiAGY14vIhU2Vn1rBAaw47VvZtwg4tjzSvn0SLcU02vk8gAnMU2SPSslwTUgR3BeBNquupua5kgSqwnxNKNt83Kji6Hk67aaUxXehLGRbLunKHSPWlJpsC+vKfBD2WG1+Qg4zQk8ucuvQRpVurJurK8XKu//vuVvbGTnF8ZS6EK7VcVNlAYngLdEKyaLAqx+xQQKWYhQEb46HB6718L/cf8CjIcFMoY9QzR27A7IAVhmOHlaSZxdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(316002)(122000001)(7416002)(8676002)(508600001)(5660300002)(186003)(83380400001)(36756003)(38100700002)(8936002)(2906002)(6486002)(66946007)(66476007)(66446008)(64756008)(66556008)(6506007)(54906003)(86362001)(38070700005)(71200400001)(6512007)(4326008)(76116006)(6916009)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S21BdTBqTlBucjlqL0FkUXpBa0xnY2s1Y3BNZU4zaWhMNzhVTExkdFA2ejhH?=
 =?utf-8?B?UDdYWS9BQmxuWWJ2S3BOUVBNbFBBMXlVdjd5VEFxOEM3MElNeWpmZWtsS09W?=
 =?utf-8?B?am9mMmVTc2M4ZTNyYldJUE5SRGNRUTZuNEdMajhEL2FpRDNmQVBsL3BNdGt1?=
 =?utf-8?B?SE0zV1dpU09ZcW9ldERCdXZrZHp1M3JrVHpOL2xCNUlFS09IN3A2RFVGNlZs?=
 =?utf-8?B?bkxDYkxGN3h5ZjkzZDRtV093RFVUNEcyOXdjR21KMHIvRm1VeG5aaUNIcG9v?=
 =?utf-8?B?VjVjRTJRZmpkMmdmc2hObGNsdTB0QnczRHEvcEpjN2pway9JMWtCNnFxN2lP?=
 =?utf-8?B?VVl3aEZtNlpkY2lzS3lHRjF6czVSWkQvUTl3S2pXL2MyVmtzMkJlV0VPY09J?=
 =?utf-8?B?cXVQcU1hMVZBaVFmbEJpNTlLK3lsV2kwcFhpVmwxREpNeFl6eFljV00wZ244?=
 =?utf-8?B?S2ZDMHVuc3hidVp3eHpIVG9LeUM5N0ZWZmxzQzN1NzA3VHZwYkVMOWFUenUr?=
 =?utf-8?B?LytBeVcxdEtmUXJ2MGkwdUxjT3BkR1dzREpJclNpMkRlejJZN2NLRElFd1hP?=
 =?utf-8?B?alI0dUVtc1VLcGZVSnBBUi9RUnBEbGtpZllIVWVTUFZDZUJwbjVIT3RiTWhi?=
 =?utf-8?B?cmVwcWN2Uzgra2JuZDdCTThsclpxSjRqdkhxLzh4bTJ6eG5DbmQyaVlrSlMy?=
 =?utf-8?B?RVluall1QnNNc0g2eFNQU01vMWk1YnBnNkZaV2FmU002NW5sa3JOMnFZUERB?=
 =?utf-8?B?UlRWVHRicGRmOXdLMHJVRVRESTdmakRweitNNzcyMzBQYU8rS1JkSFcyOFFa?=
 =?utf-8?B?UWJ0Tno4V3c0MElpZFpXZmU3ajFxQlU4Uk5qV29vSnF2M2trWFMweTgvQVpU?=
 =?utf-8?B?U3E0bUViRW1HMzlUamZtNitIcFYvK2J3TmlMMnI3M2MvcUhJbThpbHRieEhI?=
 =?utf-8?B?aGJFdnU3NGg2MG1mUkN5TjZxVDVmMFh3U1pCeVM5VElxT2lZYnJEZzlPL1Uw?=
 =?utf-8?B?WGszRTBXemdVQ0pqaFI3M3dDUDJPbG1tT2tYVHp3V3Bhd0l2VDh1QnZGVVZJ?=
 =?utf-8?B?NjhzRVl2ZzJtV2hkZ3dUTGRvYzBNRFdWL3RQTEpRUUYxZHc4cjB4bFJyNEpk?=
 =?utf-8?B?VC9wL2doMW9qS1ZBdWpWNjhBNTFxVUxUTGU1OTNnTTBka2NUNVh6aHc2SXE3?=
 =?utf-8?B?cWY1eTRBQm9YTWUwejRtbDFLRkp0cEZzZVdmdzk2U2ZNMmViRkQrTnNHZUhu?=
 =?utf-8?B?ZHlhMUladEhjT3Q3SHN4akUxN0R2eGVZS0xVOWNseklUaThxZXBVaVB3NWlh?=
 =?utf-8?B?d2NZQVc0QnZPZ3VqbzFxTlJuaERUNVFJQkZmVENKTGZJSXc2OUJBaEJPK21F?=
 =?utf-8?B?N1VkNlRtc0YrckNpZHVsQWltcyt5TmRybEYwdjNIeDI1eGQ5WGFqQ0VmMHpS?=
 =?utf-8?B?WTVZRXpqWFN3SS9yOHNWVVk5M3phaUFYZmdSOHlMZEh4bkFjS1pGSEMydm9j?=
 =?utf-8?B?MWxtaUdHUlRvS090VkQ1R3dUYmtBWktxb0FVeGZUVUUyUjh6MDl1dGtlNkNt?=
 =?utf-8?B?cnBSQ1BqQjRCOWhvenNTSjhtdktoM0FzODNHVVliV3FrYUViL1Y0UzBmYy85?=
 =?utf-8?B?ZVc4NjJLZXg0THhDU3NZR2NMQk02YU1SRGZiMy9TdWtLZDU2Q2k5YnlMYldm?=
 =?utf-8?B?VkhZamJvR0YxN1IwWW9yeCtxckluYUlTWG5xUzJZdCtGZzViN3c2bHRQY084?=
 =?utf-8?Q?hitVXaNsjeT618BhVyL/07vEW+XVxFBsmpCWfRk?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AE30A4ED214E948BA00F922E13743B5@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf7d50f-3ad6-41cc-9f6b-08d98288efea
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 14:04:50.0177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L0WXc5jxAUJPJigjA6iSvpjhjV6O33IrPr/YDCIuwV21uJvM3UnQxD6JlixRcWs+0EdHsELBvSb8sS/m/p3ufg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3495
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTA5LTI4IGF0IDA5OjQ5IC0wNDAwLCBiZmllbGRzQGZpZWxkc2VzLm9yZyB3
cm90ZToNCj4gT24gVHVlLCBTZXAgMjgsIDIwMjEgYXQgMDE6MzA6MTdQTSArMDAwMCwgVHJvbmQg
TXlrbGVidXN0IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMS0wOS0yOCBhdCAxMToxNCArMDgwMCwg
V2FuZyBIYWkgd3JvdGU6DQo+ID4gPiBXaGVuIHVzZS1nc3MtcHJveHkgaXMgc2V0IHRvIDEsIHdy
aXRlX2dzc3AoKSBjcmVhdGVzIGEgcnBjIGNsaWVudA0KPiA+ID4gaW4NCj4gPiA+IGdzc3BfcnBj
X2NyZWF0ZSgpLCB0aGlzIGluY3JlYXNlcyB0aGUgbmV0bnMgcmVmY291bnQgYnkgMiwgdGhlc2UN
Cj4gPiA+IHJlZmNvdW50cyBhcmUgc3VwcG9zZWQgdG8gYmUgcmVsZWFzZWQgaW4gcnBjc2VjX2dz
c19leGl0X25ldCgpLA0KPiA+ID4gYnV0DQo+ID4gPiBpdA0KPiA+ID4gd2lsbCBuZXZlciBoYXBw
ZW4gYmVjYXVzZSBycGNzZWNfZ3NzX2V4aXRfbmV0KCkgaXMgdHJpZ2dlcmVkIG9ubHkNCj4gPiA+
IHdoZW4NCj4gPiA+IHRoZSBuZXRucyByZWZjb3VudCBnZXRzIHRvIDAsIHNwZWNpZmljYWxseToN
Cj4gPiA+IMKgwqDCoCByZWZjb3VudD0wIC0+IGNsZWFudXBfbmV0KCkgLT4gb3BzX2V4aXRfbGlz
dCAtPg0KPiA+ID4gcnBjc2VjX2dzc19leGl0X25ldA0KPiA+ID4gSXQgaXMgYSBkZWFkbG9jayBz
aXR1YXRpb24gaGVyZSwgcmVmY291bnQgd2lsbCBuZXZlciBnZXQgdG8gMA0KPiA+ID4gdW5sZXNz
DQo+ID4gPiBycGNzZWNfZ3NzX2V4aXRfbmV0KCkgaXMgY2FsbGVkLiBTbywgaW4gdGhpcyBjYXNl
LCB0aGUgbmV0bnMNCj4gPiA+IHJlZmNvdW50DQo+ID4gPiBzaG91bGQgbm90IGJlIGluY3JlYXNl
ZC4NCj4gPiA+IA0KPiA+ID4gSW4gdGhpcyBjYXNlLCB4cHJ0IHdpbGwgdGFrZSBhIG5ldG5zIHJl
ZmNvdW50IHdoaWNoIGlzIG5vdA0KPiA+ID4gc3VwcG9zZWQNCj4gPiA+IHRvIGJlIHRha2VuLiBB
ZGQgYSBuZXcgZmxhZyB0byBycGNfY3JlYXRlX2FyZ3MgY2FsbGVkDQo+ID4gPiBSUENfQ0xOVF9D
UkVBVEVfTk9fTkVUX1JFRiBmb3Igbm90IGluY3JlYXNpbmcgdGhlIG5ldG5zIHJlZmNvdW50Lg0K
PiA+ID4gDQo+ID4gPiBJdCBpcyBzYWZlIG5vdCB0byBob2xkIHRoZSBuZXRucyByZWZjb3VudCwg
YmVjYXVzZSB3aGVuDQo+ID4gPiBjbGVhbnVwX25ldCgpLCBpdA0KPiA+ID4gd2lsbCBob2xkIHRo
ZSBnc3NwX2xvY2sgYW5kIHRoZW4gc2h1dCBkb3duIHRoZSBycGMgY2xpZW50DQo+ID4gPiBzeW5j
aHJvbm91c2x5Lg0KPiA+ID4gDQo+ID4gPiANCj4gPiBJIGRvbid0IGxpa2UgdGhpcyBzb2x1dGlv
biBhdCBhbGwuIEFkZGluZyB0aGlzIGtpbmQgb2YgZmxhZyBpcw0KPiA+IGdvaW5nIHRvDQo+ID4g
bGVhZCB0byBwcm9ibGVtcyBkb3duIHRoZSByb2FkLg0KPiA+IA0KPiA+IElzIHRoZXJlIGFueSBy
ZWFzb24gd2hhdHNvZXZlciB3aHkgd2UgbmVlZCB0aGlzIFJQQyBjbGllbnQgdG8gZXhpc3QNCj4g
PiB3aGVuIHRoZXJlIGlzIG5vIGFjdGl2ZSBrbmZzZCBzZXJ2ZXI/IElPVzogSXMgdGhlcmUgYW55
IHJlYXNvbiB3aHkNCj4gPiB3ZQ0KPiA+IHNob3VsZG4ndCBkZWZlciBjcmVhdGluZyB0aGlzIFJQ
QyBjbGllbnQgZm9yIHdoZW4ga25mc2Qgc3RhcnRzIHVwDQo+ID4gaW4NCj4gPiB0aGlzIG5ldCBu
YW1lc3BhY2UsIGFuZCB3aHkgd2UgY2FuJ3Qgc2h1dCBpdCBkb3duIHdoZW4ga25mc2Qgc2h1dHMN
Cj4gPiBkb3duPw0KPiANCj4gVGhlIHJwYyBjcmVhdGUgaXMgZG9uZSBpbiB0aGUgY29udGV4dCBv
ZiB0aGUgcHJvY2VzcyB0aGF0IHdyaXRlcyB0bw0KPiAvcHJvYy9uZXQvcnBjL3VzZS1nc3MtcHJv
eHkgdG8gZ2V0IHRoZSByaWdodCBuYW1lc3BhY2VzLsKgIEkgZG9uJ3QNCj4ga25vdw0KPiBob3cg
aGFyZCBpdCB3b3VsZCBiZSBjYXB0dXJlIHRoYXQgaW5mb3JtYXRpb24gZm9yIGEgbGF0ZXIgY3Jl
YXRlLg0KPiANCg0Kc3ZjYXV0aF9nc3NfcHJveHlfaW5pdCgpIHVzZXMgdGhlIG5ldCBuYW1lc3Bh
Y2UgU1ZDX05FVChycXN0cCkgKGkuZS4NCnRoZSBrbmZzZCBuYW1lc3BhY2UpIGluIHRoZSBjYWxs
IHRvIGdzc3BfYWNjZXB0X3NlY19jb250ZXh0X3VwY2FsbCgpLg0KDQpJT1c6IHRoZSBuZXQgbmFt
ZXNwYWNlIHVzZWQgaW4gdGhlIGNhbGwgdG8gZmluZCB0aGUgUlBDIGNsaWVudCBpcyB0aGUNCm9u
ZSBzZXQgdXAgYnkga25mc2QsIGFuZCBzbyBpZiB1c2UtZ3NzLXByb3h5IHdhcyBzZXQgaW4gYSBk
aWZmZXJlbnQNCm5hbWVzcGFjZSB0aGFuIHRoZSBvbmUgdXNlZCBieSBrbmZzZCwgdGhlbiBpdCB3
b24ndCBiZSBmb3VuZC4NCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQg
bWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20N
Cg0KDQo=
