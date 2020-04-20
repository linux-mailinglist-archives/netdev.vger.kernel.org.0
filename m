Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB90E1B088C
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgDTLyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:54:51 -0400
Received: from mail-eopbgr700108.outbound.protection.outlook.com ([40.107.70.108]:13793
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726380AbgDTLyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:54:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7qteTMOsApJKQIYAgtm/XGuihk/LnpDgCXYZYxMNWISGgK+cg7d3+P7mrLrxR2PhXLQMtY5tAuJiKtEeWUFQcVfsghAGYuiFqbs+7OUrzLKjy1991oM/crQIpAOdFswxcna1aTFBQyEgML3M/ngInHMPI0aflLbso0rYATPakrBUpu1LgJJLRRuPXXMxnWskdaa++M7uBeX6Se70sN06B1KMXKO91L/XK6eQHD8RpqMndoq4O1uivNkBU2ldR3EsbpRPZgqHCS4MH94h40gHpMrw02FtzPqBZClaM0rz6PfjwtvBKEwUYRWeff61pUsiohjPRV6/prGmQReMxRerg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1CpA5MbBj/i37Ov6EuLuAALjnxSQbRol92OSaTcT+g=;
 b=RPJhCFp6P/4CJ8w8nei47vmMh5P+Dult28M9NuAk2CCuKg5mUwTCCJqBeRqF3wHSS1NvX+WMdGaE+77jtJpw9lbPp++d3f2Sj2ktdFHuVycoD27H8IZ9FXt8MmfZS9YMI9KyKy4b8xfdb6PyhkzsCHDGlyBXI/VanVm7muXwPsEWn8EhpKHrSvCn/Jg+WwJj7IimhKiKYreeyMwDGw77DJhObeFJENxDwjDGumoueWP7rES1XX2RSzOTmgDMq6k7IURAhWNE8xPny64y9YFSyJRBoPBDqeXf1N/b5axBo4Wqu1iyb5MP+fqVmjQL2BeMPN2+0ajoCIRwZvJbdlyaXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1CpA5MbBj/i37Ov6EuLuAALjnxSQbRol92OSaTcT+g=;
 b=bpVvzw1hYn980Fe/EEp0mlWf9SBCmjyH9N8bL2ZA7OQhu4tDAEkwfTb7l9nXfWVJSU24hOOG8g+CceXVrpGJke0C5PwR3/ami8MgdQCeGeEfOeajDgvxBXRO5LXXaraVNbq8IEwWhHMFvYid7z5nO40we3FkT9WGY5YX/rkY25o=
Received: from CH2PR13MB3398.namprd13.prod.outlook.com (2603:10b6:610:2a::33)
 by CH2PR13MB3351.namprd13.prod.outlook.com (2603:10b6:610:2d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.6; Mon, 20 Apr
 2020 11:54:44 +0000
Received: from CH2PR13MB3398.namprd13.prod.outlook.com
 ([fe80::49f6:ce9b:9803:2493]) by CH2PR13MB3398.namprd13.prod.outlook.com
 ([fe80::49f6:ce9b:9803:2493%6]) with mapi id 15.20.2937.011; Mon, 20 Apr 2020
 11:54:44 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "xiyuyang19@fudan.edu.cn" <xiyuyang19@fudan.edu.cn>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>
CC:     "tanxin.ctf@gmail.com" <tanxin.ctf@gmail.com>,
        "yuanxzhang@fudan.edu.cn" <yuanxzhang@fudan.edu.cn>,
        "kjlu@umn.edu" <kjlu@umn.edu>
Subject: Re: [PATCH] SUNRPC: Fix refcnt leak in rpc_clnt_test_and_add_xprt
Thread-Topic: [PATCH] SUNRPC: Fix refcnt leak in rpc_clnt_test_and_add_xprt
Thread-Index: AQHWFtb05f68VIcQEku+POtapIkW36iB50WA
Date:   Mon, 20 Apr 2020 11:54:43 +0000
Message-ID: <6d82d9e6f34f369bcf86abffe3d3f18ab1a13cc0.camel@hammerspace.com>
References: <1587361519-83687-1-git-send-email-xiyuyang19@fudan.edu.cn>
In-Reply-To: <1587361519-83687-1-git-send-email-xiyuyang19@fudan.edu.cn>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=trondmy@hammerspace.com; 
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52b851c3-2417-47f0-11af-08d7e5219dd7
x-ms-traffictypediagnostic: CH2PR13MB3351:
x-microsoft-antispam-prvs: <CH2PR13MB335190C7D36A8D1A38F8BFC3B8D40@CH2PR13MB3351.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3398.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39830400003)(376002)(346002)(396003)(136003)(71200400001)(54906003)(91956017)(4326008)(26005)(66946007)(6486002)(6512007)(66446008)(64756008)(66556008)(66476007)(76116006)(36756003)(478600001)(2616005)(7416002)(81156014)(8676002)(316002)(2906002)(186003)(86362001)(8936002)(5660300002)(6506007)(110136005);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: hammerspace.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BG5Vu6v0NRVxB13qtuf1on1wNssqDLrInhxAw2selJCMMsv3gylNIZdFzy4lN38ueCvSifH3p/gPFr2k/HYWUGqlIkpYV17suM8MKW5BAGG66Kmqd+b3MnI8UonyNIBmAwPEenWjZXNSgRcFmcqg8HPy0QK3x5lN7oG8eod2Qeom3IHvpr2UEBbTLLSlayw00i2xQMu4brY8CfqkLE+SIrLwFSNUZR2zh2feMadSIqsAp6eK2o0uVgJ5U3CNg3ViEM65soT3oXzTOTh73DAFQ/Y99cpDMjru3tYkkORQhnKUWZ4GgRQ8X5gDoJyicGdrQBGPbYWlk0BkscRjME7orffMVAvUTSiNLlYrP0ptz28q1E7i515cQueD4IzWM85uTEr9PmxHedUwoR7aPc4/ShpsyvJIpDwTk7Od9EWL/Kk/oSKmCAdmEEcmeCKCCO43
x-ms-exchange-antispam-messagedata: u0OAUcmbDwpmGhiLCdFbWat7/Z2CK0P41Lbm3PoBWxKye2NxiEQROvn2a7U87WxYP7P5izC200n7i4zGGJLjpEFP4WkE9MmdtP79do7tGTj/bKaQY3IokHK9/La0bh/qvpcusrRrGIiEb8pvp44Fpzg9tixSZfi1yf0KLb/2JJSJrk+SrukNAFF/NqvPcB48cK1fvIS3Hodg2UqIWeZ74SGuxhrvm2ZbizNo/p6jYBx6pbA7mbv4dlLQG7ziANeOcSREzviUA72+SQW5T8caHKkCXoKyRhi90YZRQVZwr/qcmpMVameD49lAx8zIIa9wfjO7X6nhviRDGE8f04wqsm9m58+yvo3KDeGpkGa2Fl0HhzR9vWVh33o/ttrAOHUhAnPc2LApy8nKyH36DbM52A5lM5kjpM3J7tC0ZgU3p06HfzZOTSqQjNar4Fjl+/FvR5yeb47pZtnl2d1BV9vyFrP19uBUBFr5urJSfEjJ2m0CNVyb42lN+rNZiZ5scSC5SDxCWjMOM5sYp2M5fWFMJ0xq5oM/XNDQSenWE3i7u16jtjQvLCIRZ1/H7UJCULxZnwrOLZWqlcg4hIJLEt0UmQlBk46AKrLVozSJItyxrr2CZ7dd2asJ751ZxpKd4TsQHG3H4kMvvogsv8w31rxf1WfQRAQrtLzVkacWK+LHWUuDdjalnmBFvQdDxTaiviKLaVDFxvdE0hqgwH0V5w8FNi3tHXfLQrAIpNoFw8IDN/XyZnp+5nz2PIINJC+4D49sY4wqEhDt//zo/BmG9QSD0VgGzz7tuVZLPPvReNum6zk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <446BF67DE9F4B4468E4F8542D3860606@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b851c3-2417-47f0-11af-08d7e5219dd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 11:54:44.0334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hM2CLpJVvxjumu+nFCRKUh6i333lWlRX4kYD70pNpeWDWdipO3eYWE+2iSdYXr4sVkZ02V5zObreuVvhu+5XqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA0LTIwIGF0IDEzOjQ1ICswODAwLCBYaXl1IFlhbmcgd3JvdGU6DQo+IHJw
Y19jbG50X3Rlc3RfYW5kX2FkZF94cHJ0KCkgaW52b2tlcyB4cHJ0X3N3aXRjaF9nZXQoKSBhbmQN
Cj4geHBydF9nZXQoKSwNCj4gd2hpY2ggcmV0dXJucyBhIHJlZmVyZW5jZSBvZiB0aGUgcnBjX3hw
cnRfc3dpdGNoIG9iamVjdCB0byAiZGF0YS0NCj4gPnhwcyINCj4gYW5kIGEgcmVmZXJlbmNlIG9m
IHRoZSBycGNfeHBydCBvYmplY3QgdG8gImRhdGEtPnhwcnQiIHdpdGggaW5jcmVhc2VkDQo+IHJl
ZmNvdW50Lg0KPiANCj4gV2hlbiBycGNfY2xudF90ZXN0X2FuZF9hZGRfeHBydCgpIHJldHVybnMs
IGxvY2FsIHZhcmlhYmxlICJkYXRhIiBhbmQNCj4gaXRzDQo+IGZpZWxkICJ4cHMiIGFzIHdlbGwg
YXMgInhwcnQiIGJlY29tZXMgaW52YWxpZCwgc28gdGhlaXIgcmVmY291bnRzDQo+IHNob3VsZA0K
PiBiZSBkZWNyZWFzZWQgdG8ga2VlcCByZWZjb3VudCBiYWxhbmNlZC4NCj4gDQo+IFRoZSByZWZl
cmVuY2UgY291bnRpbmcgaXNzdWUgaGFwcGVucyBpbiBvbmUgZXhjZXB0aW9uIGhhbmRsaW5nIHBh
dGhzDQo+IG9mDQo+IHJwY19jbG50X3Rlc3RfYW5kX2FkZF94cHJ0KCkuIFdoZW4gcnBjX2NhbGxf
bnVsbF9oZWxwZXIoKSByZXR1cm5zDQo+IElTX0VSUiwgdGhlIHJlZmNudCBpbmNyZWFzZWQgYnkg
eHBydF9zd2l0Y2hfZ2V0KCkgYW5kIHhwcnRfZ2V0KCkgYXJlDQo+IG5vdA0KPiBkZWNyZWFzZWQs
IGNhdXNpbmcgYSByZWZjbnQgbGVhay4NCj4gDQo+IEZpeCB0aGlzIGlzc3VlIGJ5IGNhbGxpbmcg
cnBjX2NiX2FkZF94cHJ0X3JlbGVhc2UoKSB0byBkZWNyZWFzZQ0KPiByZWxhdGVkDQo+IHJlZmNv
dW50ZWQgZmllbGRzIGluICJkYXRhIiBhbmQgdGhlbiByZWxlYXNlIGl0IHdoZW4NCj4gcnBjX2Nh
bGxfbnVsbF9oZWxwZXIoKSByZXR1cm5zIElTX0VSUi4NCj4gDQo+IEZpeGVzOiA3ZjU1NDg5MDU4
N2MgKCJTVU5SUEM6IEFsbG93IGFkZGl0aW9uIG9mIG5ldyB0cmFuc3BvcnRzIHRvIGENCj4gc3Ry
dWN0IHJwY19jbG50IikNCj4gU2lnbmVkLW9mZi1ieTogWGl5dSBZYW5nIDx4aXl1eWFuZzE5QGZ1
ZGFuLmVkdS5jbj4NCj4gU2lnbmVkLW9mZi1ieTogWGluIFRhbiA8dGFueGluLmN0ZkBnbWFpbC5j
b20+DQo+IC0tLQ0KPiAgbmV0L3N1bnJwYy9jbG50LmMgfCA0ICsrKy0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9u
ZXQvc3VucnBjL2NsbnQuYyBiL25ldC9zdW5ycGMvY2xudC5jDQo+IGluZGV4IDczMjRiMjFmOTIz
ZS4uZjg2ZDlhZTIxNjdmIDEwMDY0NA0KPiAtLS0gYS9uZXQvc3VucnBjL2NsbnQuYw0KPiArKysg
Yi9uZXQvc3VucnBjL2NsbnQuYw0KPiBAQCAtMjgwMyw4ICsyODAzLDEwIEBAIGludCBycGNfY2xu
dF90ZXN0X2FuZF9hZGRfeHBydChzdHJ1Y3QgcnBjX2NsbnQNCj4gKmNsbnQsDQo+ICAJdGFzayA9
IHJwY19jYWxsX251bGxfaGVscGVyKGNsbnQsIHhwcnQsIE5VTEwsDQo+ICAJCQlSUENfVEFTS19T
T0ZUfFJQQ19UQVNLX1NPRlRDT05OfFJQQ19UQVNLX0FTWU5DfA0KPiBSUENfVEFTS19OVUxMQ1JF
RFMsDQo+ICAJCQkmcnBjX2NiX2FkZF94cHJ0X2NhbGxfb3BzLCBkYXRhKTsNCj4gLQlpZiAoSVNf
RVJSKHRhc2spKQ0KPiArCWlmIChJU19FUlIodGFzaykpIHsNCj4gKwkJcnBjX2NiX2FkZF94cHJ0
X3JlbGVhc2UoZGF0YSk7DQo+ICAJCXJldHVybiBQVFJfRVJSKHRhc2spOw0KDQpXZSBzaG91bGQg
anVzdCBnZXQgcmlkIG9mIHRoZSBJU19FUlIoKSBjb25kaXRpb24gaGVyZS4gSXQgY2Fubm90IGV2
ZXINCnRyaWdnZXIsIHdoaWNoIGlzIHdoeSBycGNfcnVuX3Rhc2soKSBubyBsb25nZXIgY2hlY2tz
IGZvciBpdCwgYW5kIG5vDQpsb25nZXIgY2FsbHMgdGhlIC0+cnBjX3JlbGVhc2UoKSBtZXRob2Qg
b24gZXJyb3IuDQoNCj4gKwl9DQo+ICAJcnBjX3B1dF90YXNrKHRhc2spOw0KPiAgc3VjY2VzczoN
Cj4gIAlyZXR1cm4gMTsNCi0tIA0KVHJvbmQgTXlrbGVidXN0DQpMaW51eCBORlMgY2xpZW50IG1h
aW50YWluZXIsIEhhbW1lcnNwYWNlDQp0cm9uZC5teWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tDQoN
Cg0K
