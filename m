Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B25DF2068
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 22:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfKFVH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 16:07:26 -0500
Received: from mail-eopbgr820045.outbound.protection.outlook.com ([40.107.82.45]:16479
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726798AbfKFVH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 16:07:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nupA1L3bCslZUBIuV3jBu6kOhvqV4VtsIdy3KuGdcJWmzvfCuSszNayyO3C8iQoElbTV3jMcV4NFEtcb7nCQWcRnT6FhN7f3JzMOKb+DrRco+y47AFSNycEnYQaIJgKsUZuC8JTQUIu0V85tDFgpIKesQQZdZOPmPddjzSiM1+zPOOx9ck7nLlI4PohcggUAZSN/Lzt29FXXzlMOJF7/ETRu/LRaI6g7sbI95uJcVaSP1bmHCKjW5mMfWYNzH+9XsgDmDG+D0ppmXAuZz50oFfLs2/tuEJ04CSMIxqMJzJtnl3gL6m1tyEzmIyOmFnv872P0MWfKSnnaOUzTYgjYtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjpItke5hNXPdCuYub3XnU5gdeIjowjjU/Zrij14yTU=;
 b=RGbt40lU6+qh88PlS4MrALjTMnduAxk6KhO2eFN0DKTM0kJlVle/6mAn59TkVd1Gggx+5NZorbXMvBiTuT/AoOSgPZdLRGsrkZ8BVXA0u9blulJeexuQ2Lm8ncOU+Q21uO/vONu5YTStWxaHs4hYzNZJHDT4TKfwvPYxTTl0ZXLk0z2v0dQSyQjrA/dwIqqTs9g1ctgUx2wBDJZvUss8ZEMs6z1YCMLW9u2MJqN3Sgd0TmwKTE/al1b/4CN/O3cIrtyuFuev5KCA65Lee+APnDYkyE3EyUBXeZlbxceaEyL8CfcW9U5NF1g6HUEZNbXSc7wclfW84PeGDLy+ATHptw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjpItke5hNXPdCuYub3XnU5gdeIjowjjU/Zrij14yTU=;
 b=WPomZ5oxU2Ik5l19ZsdXh67uQ2zEsK909EkcJVCDkkRgR3B3g1IVlBQTn98OwgS9N1EGQ68arIczUecYb2GxIRrxGiPZhTj4sS1MKrrGpxKPXVtOBvEjnPZmiWNJ5Bd6gIOx0iAArzKkmFyxzIHZNBy18jZqmakAl1DDj3TzLQE=
Received: from CH2PR15MB3575.namprd15.prod.outlook.com (10.255.156.17) by
 CH2PR15MB3557.namprd15.prod.outlook.com (52.132.228.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Wed, 6 Nov 2019 21:07:20 +0000
Received: from CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::a0a2:ffd4:4a7f:7a63]) by CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::a0a2:ffd4:4a7f:7a63%7]) with mapi id 15.20.2430.020; Wed, 6 Nov 2019
 21:07:20 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
Subject: RE: [net-next 2/2] tipc: reduce sensitive to retransmit failures
Thread-Topic: [net-next 2/2] tipc: reduce sensitive to retransmit failures
Thread-Index: AQHVlGsm8c7lafzxrkqGt8MKwzbf66d+o3Ow
Date:   Wed, 6 Nov 2019 21:07:20 +0000
Message-ID: <CH2PR15MB35759E1A42897371181250289A790@CH2PR15MB3575.namprd15.prod.outlook.com>
References: <20191106062610.12039-1-hoang.h.le@dektech.com.au>
 <20191106062610.12039-2-hoang.h.le@dektech.com.au>
In-Reply-To: <20191106062610.12039-2-hoang.h.le@dektech.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [192.75.88.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1194ce7-1bf0-4c4a-e92c-08d762fd4fe3
x-ms-traffictypediagnostic: CH2PR15MB3557:
x-ld-processed: 92e84ceb-fbfd-47ab-be52-080c6b87953f,ExtAddr
x-microsoft-antispam-prvs: <CH2PR15MB35576AE2B3C6A321B3C85E339A790@CH2PR15MB3557.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(13464003)(199004)(189003)(86362001)(8936002)(52536014)(8676002)(5660300002)(66066001)(305945005)(44832011)(6116002)(3846002)(2501003)(71200400001)(110136005)(66446008)(14454004)(316002)(64756008)(81166006)(76116006)(229853002)(66476007)(71190400001)(66946007)(66556008)(256004)(2201001)(33656002)(14444005)(446003)(6436002)(186003)(81156014)(486006)(6246003)(99286004)(11346002)(476003)(6506007)(2906002)(76176011)(53546011)(74316002)(25786009)(7696005)(26005)(55016002)(7736002)(102836004)(478600001)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR15MB3557;H:CH2PR15MB3575.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zc6jfVQ1I6MLOfA8z/L/qNChad7oeEqkxCfFMfcPkEFZLQvYsc2zUBimuvR/j3LOPNHbajjKRWpaTpqyBAtEuEIQdm+mEg6+c8NSRRtl4OyKh3yco4YFYw/W3DqkZKuTU5rIe46gK4GCO236Pbgrize+/5iqRhZrBLCDUS/6di7USCLIXkKsu5gUvZ2HHVUnGKkQodUHKHWz1uZE8bqLsHmmtyalNMx6iE/QiT5gaq1QSXw3Ze/Uw25paYmOQLht0wsqfYPm6tbpKy4PeDmCx/gvBgABZGNm+gXpJ86dF1k0M4CkpYbgUmtvPQejcQE1FXDx/S65RArR5RON5HDuie5DH+epOC3DjFFU9/9cXqJFYXBEaQZ4cvWZFxp9ewrRRiHaO7v66NOgmeg2RwLntRHeUcWMKNkLfKG6m56Xy+L34NdOxYy+y5lTPnhj7Mke
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1194ce7-1bf0-4c4a-e92c-08d762fd4fe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 21:07:20.1499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z6Lh4E4R0CJZzBtH2koXgrZCP/X/M4fgP9pkt7tipF1tlSLgmqvDZrSnnJOA/FkfL5xe0Jk6IPJ+Vc6uRDCgbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3557
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWNrZWQtYnk6IEpvbg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhv
YW5nIExlIDxob2FuZy5oLmxlQGRla3RlY2guY29tLmF1Pg0KPiBTZW50OiA2LU5vdi0xOSAwMToy
Ng0KPiBUbzogSm9uIE1hbG95IDxqb24ubWFsb3lAZXJpY3Nzb24uY29tPjsgbWFsb3lAZG9uam9u
bi5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHRpcGMtDQo+IGRpc2N1c3Npb25AbGlzdHMu
c291cmNlZm9yZ2UubmV0DQo+IFN1YmplY3Q6IFtuZXQtbmV4dCAyLzJdIHRpcGM6IHJlZHVjZSBz
ZW5zaXRpdmUgdG8gcmV0cmFuc21pdCBmYWlsdXJlcw0KPiANCj4gV2l0aCBodWdlIGNsdXN0ZXIg
KGUuZyA+MjAwbm9kZXMpLCB0aGUgYW1vdW50IG9mIHRoYXQgZmxvdzoNCj4gZ2FwIC0+IHJldHJh
bnNtaXQgcGFja2V0IC0+IGFja2VkIHdpbGwgdGFrZSB0aW1lIGluIGNhc2Ugb2YgU1RBVEVfTVNH
DQo+IGRyb3BwZWQvZGVsYXllZCBiZWNhdXNlIGEgbG90IG9mIHRyYWZmaWMuIFRoaXMgbGVhZCB0
byAxLjUgc2VjIHRvbGVyYW5jZQ0KPiB2YWx1ZSBjcml0ZXJpYSBtYWRlIGxpbmsgZWFzeSBmYWls
dXJlIGFyb3VuZCAybmQsIDNyZCBvZiBmYWlsZWQNCj4gcmV0cmFuc21pc3Npb24gYXR0ZW1wdHMu
DQo+IA0KPiBJbnN0ZWFkIG9mIHJlLWludHJvZHVjZWQgY3JpdGVyaWEgb2YgOTkgZmFsZWQgcmV0
cmFuc21pc3Npb25zIHRvIGZpeCB0aGUNCj4gaXNzdWUsIHdlIGluY3JlYXNlIGZhaWx1cmUgZGV0
ZWN0aW9uIHRpbWVyIHRvIHRlbiB0aW1lcyB0b2xlcmFuY2UgdmFsdWUuDQo+IA0KPiBGaXhlczog
NzdjZjhlZGJjMGU3ICgidGlwYzogc2ltcGxpZnkgc3RhbGUgbGluayBmYWlsdXJlIGNyaXRlcmlh
IikNCj4gQWNrZWQtYnk6IEpvbiBNYWxveSA8am9uLm1hbG95QGVyaWNzc29uLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogSG9hbmcgTGUgPGhvYW5nLmgubGVAZGVrdGVjaC5jb20uYXU+DQo+IC0tLQ0K
PiAgbmV0L3RpcGMvbGluay5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L3RpcGMvbGluay5jIGIv
bmV0L3RpcGMvbGluay5jDQo+IGluZGV4IDAzODg2MWJhZDcyYi4uMmFlZDdhOTU4YThjIDEwMDY0
NA0KPiAtLS0gYS9uZXQvdGlwYy9saW5rLmMNCj4gKysrIGIvbmV0L3RpcGMvbGluay5jDQo+IEBA
IC0xMDg3LDcgKzEwODcsNyBAQCBzdGF0aWMgYm9vbCBsaW5rX3JldHJhbnNtaXRfZmFpbHVyZShz
dHJ1Y3QgdGlwY19saW5rICpsLCBzdHJ1Y3QgdGlwY19saW5rICpyLA0KPiAgCQlyZXR1cm4gZmFs
c2U7DQo+IA0KPiAgCWlmICghdGltZV9hZnRlcihqaWZmaWVzLCBUSVBDX1NLQl9DQihza2IpLT5y
ZXRyX3N0YW1wICsNCj4gLQkJCW1zZWNzX3RvX2ppZmZpZXMoci0+dG9sZXJhbmNlKSkpDQo+ICsJ
CQltc2Vjc190b19qaWZmaWVzKHItPnRvbGVyYW5jZSAqIDEwKSkpDQo+ICAJCXJldHVybiBmYWxz
ZTsNCj4gDQo+ICAJaGRyID0gYnVmX21zZyhza2IpOw0KPiAtLQ0KPiAyLjIwLjENCg0K
