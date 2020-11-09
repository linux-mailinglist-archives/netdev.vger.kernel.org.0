Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7029B2AC1D2
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730837AbgKIRJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:09:01 -0500
Received: from mail-mw2nam10on2093.outbound.protection.outlook.com ([40.107.94.93]:46689
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730218AbgKIRJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 12:09:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/Y2MltqCzOddRifWQfcUr7DuG/wXVyfzAF4Pq9XGFXszU38ybbe1DGM5lQeOqPcMVn1U0OBxcj7QfmsX3n5jXqsKAfPZ13aRbnE4aEBhW5IYKLuvTDF49VrP8PvhM2F7V/ihHTD/k04fwJd0GVvetMTDmvOQCj+vvB3tNTIdXrpBQSkDyEKOp8nj7j2RqTJLmqfD3b9lKo5UIw9rcXwARTr/QVfNkQlhRoMZCo9KJYWHMcCJcrjBM6+XXObiKahyKCiO7lExwBPxlOPRJxhazaPDAfrBIwTe7DHSd/nNrzIIQpHXC8T+dEvQ+yxpnYZ0vvzwpQIbZYPOuwdUMtDkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDH1yNzZGsYxOfhKcwAGf086csOiA0S4KNI92Ef6f50=;
 b=eJF5CzC/3s0S87VMhrzmoRWGIQq9+CRS5DsQuXw4yk3iPzFtGOl+jdf/uGad9Y25A+PSwUeWHfmlTBTnplpBuB0xgsZbtVgk9IPOLrC6yGrpQkZK07GQw3yjIxw7oov4RqFyvgHt9vE46jnf+eziJwgH5axy1Dcul0YMIO2J5Zv69Ymq2D8mB3ef6ue3XUcFTQJWxOibz/wmg/t6V9/ocdKWHEydNDa5ctIcMq/nARQBjWZOqEZR807cpJExrdu8wMCi2NpI4SRvRWqi30JGFzW7fLAlI4jW8V58imq+Ny7FxyPI6RTEC9f+TuKg/nC925TmJ0Y0M3ibeuC6oO2pKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDH1yNzZGsYxOfhKcwAGf086csOiA0S4KNI92Ef6f50=;
 b=deGyl71vQvTqv/0q9CRsxkEf3C+IZpBE4B7TNJu2XufKEDNMQ0I6x4XvNs3sOfo1feCayk2X7PY6HtNp6Y+WEsuxq8oFM2pvWYkotXtX9eBx14HWdv+0263tAIuPPgVJuACxaZ6rlmMf7CcgnSx8edysNgD0eJCPe/1fLV7V+kA=
Received: from MN2PR13MB3957.namprd13.prod.outlook.com (2603:10b6:208:263::11)
 by MN2PR13MB3232.namprd13.prod.outlook.com (2603:10b6:208:13b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21; Mon, 9 Nov
 2020 17:08:56 +0000
Received: from MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e989:f666:131a:e210]) by MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e989:f666:131a:e210%9]) with mapi id 15.20.3541.018; Mon, 9 Nov 2020
 17:08:56 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>
Subject: Re: [PATCH RFC] SUNRPC: Use zero-copy to perform socket send
 operations
Thread-Topic: [PATCH RFC] SUNRPC: Use zero-copy to perform socket send
 operations
Thread-Index: AQHWtrHgQGMAEXnlr0WTJWA0fWWPg6nACJ0A
Date:   Mon, 9 Nov 2020 17:08:56 +0000
Message-ID: <9ce015245c916b2c90de72440a22f801142f2c6e.camel@hammerspace.com>
References: <160493771006.15633.8524084764848931537.stgit@klimt.1015granger.net>
In-Reply-To: <160493771006.15633.8524084764848931537.stgit@klimt.1015granger.net>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eaf92dd2-83b6-4863-1c0d-08d884d22483
x-ms-traffictypediagnostic: MN2PR13MB3232:
x-microsoft-antispam-prvs: <MN2PR13MB3232F995D8A7631BA748518FB8EA0@MN2PR13MB3232.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FMFxLE9VGd+pzNiaeRfYTu1CamgCtcB6K/s6cIj2LoUhf4jnzJ/5k8wcUrYto+cpKA+FqYCNiCtMxWGuuekMbgthlAnleLWZSwNd+imotSbVH5Nb08wxgQI205sQsLD1DXq+bTls5KjyB8Wh1FRjRaWHwmWh3D/HZ0+quNRDuM0jXWqB1JVVEOCKb68zTvWEpVzioFNnSpibbjDmMDZucmn/dOkZu8XpBoAPx2CNliH8kAskSDWoQc/yrKgpK50Dama6YskiXvQQkeAtYdwXw1qNdu7AOeERZdBdBc9+gSV7LHW8ISsvB7KUKzRymLJ8GHgi7eVvefZBA7rKVzVofU/YliVHHiInncaAAprSrImBWy7L7uIVCSyVXjn4tKn+K/60CefpBIImR7M0A/OwwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR13MB3957.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39830400003)(346002)(396003)(366004)(966005)(91956017)(316002)(2616005)(478600001)(186003)(6506007)(26005)(66946007)(110136005)(36756003)(66476007)(6512007)(76116006)(66556008)(2906002)(64756008)(86362001)(66446008)(5660300002)(83380400001)(8936002)(71200400001)(6486002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: o66YvnnghBRqMJxw66Jtl2Wi6hRHR7opb7QsAmCcsEtpPHZB1CswH0AHTtvqrTWeZ+Rki2o+oTrct7jUjCU7WyiqPIgIHfSIARzAInRuwaYNnVAL4TMhYWy434HQYJUogZ9MHGtqjLet8kaEuk8zk2CBrv4GyIA+uP7dHDeCJHVvoe+9vlWdigblH4YPtHnuq3MWwq1mOShq7jgUHPi9hw87Lkxjfp6ERdS0bHS2itBw7OUvPeDPVw3O1fo1j9VEOXecAU22ttWU2wVWFjM3PIRa8mkkwKK7gAbmbvdksDGGMuBmUMavVmtr/D8FzyKFJ2Z0gysfTOVrCigcKwogr+xthNokOOiMt9Z0UINkrEpdHJmFrxumtSTLdzbqi3gTy3GuF7/wwrSlerNdFMd5RhMfVzzKqHmx555cyDmZCfQTZIq2B4edZS+Qs+0h6nAoGjdDmgKs0X3OKLXO/3e3MeYepnYMziAyIn0csG09gqGh8gDuKAQhXfFID3gGm57AByc3m4WhYf1V7w9wX4LkTrrT2Z6wFeCWs/L4RLNPP5ByMwI9eISsQwDJ2vua0naN1Yp5PWP83LosZs7OZCdXjZawBegM8lPdOypQ0uvzpy10RtSoTWgZu8jYj4kxR+HyHX5hUEJPihf/b9Yg23Z17Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B1B94D00A52EF42AE69AA2D5E40A46F@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR13MB3957.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf92dd2-83b6-4863-1c0d-08d884d22483
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 17:08:56.1693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kPizwgFEA36DeszD9UYNoQhMJUDUuRQJ2GNs8pidPiKAohs3T5XMjV57HgixIAedM8wE7KwhXA9d5TMwe5jgxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3232
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTExLTA5IGF0IDExOjAzIC0wNTAwLCBDaHVjayBMZXZlciB3cm90ZToNCj4g
RGFpcmUgQnlybmUgcmVwb3J0cyBhIH41MCUgYWdncmVncmF0ZSB0aHJvdWdocHV0IHJlZ3Jlc3Np
b24gb24gaGlzDQo+IExpbnV4IE5GUyBzZXJ2ZXIgYWZ0ZXIgY29tbWl0IGRhMTY2MWI5M2JmNCAo
IlNVTlJQQzogVGVhY2ggc2VydmVyIHRvDQo+IHVzZSB4cHJ0X3NvY2tfc2VuZG1zZyBmb3Igc29j
a2V0IHNlbmRzIiksIHdoaWNoIHJlcGxhY2VkDQo+IGtlcm5lbF9zZW5kX3BhZ2UoKSBjYWxscyBp
biBORlNEJ3Mgc29ja2V0IHNlbmQgcGF0aCB3aXRoIGNhbGxzIHRvDQo+IHNvY2tfc2VuZG1zZygp
IHVzaW5nIGlvdl9pdGVyLg0KPiANCj4gSW52ZXN0aWdhdGlvbiBzaG93ZWQgdGhhdCB0Y3Bfc2Vu
ZG1zZygpIHdhcyBub3QgdXNpbmcgemVyby1jb3B5IHRvDQo+IHNlbmQgdGhlIHhkcl9idWYncyBi
dmVjIHBhZ2VzLCBidXQgaW5zdGVhZCB3YXMgcmVseWluZyBvbiBtZW1jcHkuDQo+IA0KPiBTZXQg
dXAgdGhlIHNvY2tldCBhbmQgZWFjaCBtc2doZHIgdGhhdCBiZWFycyBidmVjIHBhZ2VzIHRvIHVz
ZSB0aGUNCj4gemVyby1jb3B5IG1lY2hhbmlzbSBpbiB0Y3Bfc2VuZG1zZy4NCj4gDQo+IFJlcG9y
dGVkLWJ5OiBEYWlyZSBCeXJuZSA8ZGFpcmVAZG5lZy5jb20+DQo+IEJ1Z0xpbms6IGh0dHBzOi8v
YnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjA5NDM5DQo+IEZpeGVzOiBkYTE2
NjFiOTNiZjQgKCJTVU5SUEM6IFRlYWNoIHNlcnZlciB0byB1c2UgeHBydF9zb2NrX3NlbmRtc2cN
Cj4gZm9yIHNvY2tldCBzZW5kcyIpDQo+IFNpZ25lZC1vZmYtYnk6IENodWNrIExldmVyIDxjaHVj
ay5sZXZlckBvcmFjbGUuY29tPg0KPiAtLS0NCj4gwqBuZXQvc3VucnBjL3NvY2tsaWIuY8KgIHzC
oMKgwqAgNSArKysrLQ0KPiDCoG5ldC9zdW5ycGMvc3Zjc29jay5jwqAgfMKgwqDCoCAxICsNCj4g
wqBuZXQvc3VucnBjL3hwcnRzb2NrLmMgfMKgwqDCoCAxICsNCj4gwqAzIGZpbGVzIGNoYW5nZWQs
IDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gVGhpcyBwYXRjaCBkb2VzIG5v
dCBmdWxseSByZXNvbHZlIHRoZSBpc3N1ZS4gRGFpcmUgcmVwb3J0cyBoaWdoDQo+IHNvZnRJUlEg
YWN0aXZpdHkgYWZ0ZXIgdGhlIHBhdGNoIGlzIGFwcGxpZWQsIGFuZCB0aGlzIGFjdGl2aXR5DQo+
IHNlZW1zIHRvIHByZXZlbnQgZnVsbCByZXN0b3JhdGlvbiBvZiBwcmV2aW91cyBwZXJmb3JtYW5j
ZS4NCj4gDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy9zb2NrbGliLmMgYi9uZXQvc3Vu
cnBjL3NvY2tsaWIuYw0KPiBpbmRleCBkNTIzMTNhZjgyYmMuLmFmNDc1OTZhN2JkZCAxMDA2NDQN
Cj4gLS0tIGEvbmV0L3N1bnJwYy9zb2NrbGliLmMNCj4gKysrIGIvbmV0L3N1bnJwYy9zb2NrbGli
LmMNCj4gQEAgLTIyNiw5ICsyMjYsMTIgQEAgc3RhdGljIGludCB4cHJ0X3NlbmRfcGFnZWRhdGEo
c3RydWN0IHNvY2tldA0KPiAqc29jaywgc3RydWN0IG1zZ2hkciAqbXNnLA0KPiDCoMKgwqDCoMKg
wqDCoMKgaWYgKGVyciA8IDApDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0
dXJuIGVycjsNCj4gwqANCj4gK8KgwqDCoMKgwqDCoMKgbXNnLT5tc2dfZmxhZ3MgfD0gTVNHX1pF
Uk9DT1BZOw0KPiDCoMKgwqDCoMKgwqDCoMKgaW92X2l0ZXJfYnZlYygmbXNnLT5tc2dfaXRlciwg
V1JJVEUsIHhkci0+YnZlYywNCj4geGRyX2J1Zl9wYWdlY291bnQoeGRyKSwNCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHhkci0+cGFnZV9sZW4gKyB4ZHItPnBh
Z2VfYmFzZSk7DQo+IC3CoMKgwqDCoMKgwqDCoHJldHVybiB4cHJ0X3NlbmRtc2coc29jaywgbXNn
LCBiYXNlICsgeGRyLT5wYWdlX2Jhc2UpOw0KPiArwqDCoMKgwqDCoMKgwqBlcnIgPSB4cHJ0X3Nl
bmRtc2coc29jaywgbXNnLCBiYXNlICsgeGRyLT5wYWdlX2Jhc2UpOw0KPiArwqDCoMKgwqDCoMKg
wqBtc2ctPm1zZ19mbGFncyAmPSB+TVNHX1pFUk9DT1BZOw0KPiArwqDCoMKgwqDCoMKgwqByZXR1
cm4gZXJyOw0KPiDCoH0NCj4gwqANCj4gwqAvKiBDb21tb24gY2FzZToNCj4gZGlmZiAtLWdpdCBh
L25ldC9zdW5ycGMvc3Zjc29jay5jIGIvbmV0L3N1bnJwYy9zdmNzb2NrLmMNCj4gaW5kZXggYzI3
NTJlMmI5Y2UzLi5jODE0YjQ5NTNiMTUgMTAwNjQ0DQo+IC0tLSBhL25ldC9zdW5ycGMvc3Zjc29j
ay5jDQo+ICsrKyBiL25ldC9zdW5ycGMvc3Zjc29jay5jDQo+IEBAIC0xMTc2LDYgKzExNzYsNyBA
QCBzdGF0aWMgdm9pZCBzdmNfdGNwX2luaXQoc3RydWN0IHN2Y19zb2NrICpzdnNrLA0KPiBzdHJ1
Y3Qgc3ZjX3NlcnYgKnNlcnYpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3Zz
ay0+c2tfZGF0YWxlbiA9IDA7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWVt
c2V0KCZzdnNrLT5za19wYWdlc1swXSwgMCwgc2l6ZW9mKHN2c2stDQo+ID5za19wYWdlcykpOw0K
PiDCoA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc29ja19zZXRfZmxhZyhzaywg
U09DS19aRVJPQ09QWSk7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdGNwX3Nr
KHNrKS0+bm9uYWdsZSB8PSBUQ1BfTkFHTEVfT0ZGOw0KPiDCoA0KPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHNldF9iaXQoWFBUX0RBVEEsICZzdnNrLT5za194cHJ0LnhwdF9mbGFn
cyk7DQo+IGRpZmYgLS1naXQgYS9uZXQvc3VucnBjL3hwcnRzb2NrLmMgYi9uZXQvc3VucnBjL3hw
cnRzb2NrLmMNCj4gaW5kZXggNzA5MGJiZWUwZWM1Li4zNDNjNjM5NmIyOTcgMTAwNjQ0DQo+IC0t
LSBhL25ldC9zdW5ycGMveHBydHNvY2suYw0KPiArKysgYi9uZXQvc3VucnBjL3hwcnRzb2NrLmMN
Cj4gQEAgLTIxNzUsNiArMjE3NSw3IEBAIHN0YXRpYyBpbnQgeHNfdGNwX2ZpbmlzaF9jb25uZWN0
aW5nKHN0cnVjdA0KPiBycGNfeHBydCAqeHBydCwgc3RydWN0IHNvY2tldCAqc29jaykNCj4gwqAN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBzb2NrZXQgb3B0aW9ucyAqLw0K
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNvY2tfcmVzZXRfZmxhZyhzaywgU09D
S19MSU5HRVIpOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc29ja19zZXRfZmxh
ZyhzaywgU09DS19aRVJPQ09QWSk7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
dGNwX3NrKHNrKS0+bm9uYWdsZSB8PSBUQ1BfTkFHTEVfT0ZGOw0KPiDCoA0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhwcnRfY2xlYXJfY29ubmVjdGVkKHhwcnQpOw0KPiANCj4g
DQpJJ20gdGhpbmtpbmcgd2UgYXJlIG5vdCByZWFsbHkgYWxsb3dlZCB0byBkbyB0aGF0IGhlcmUu
IFRoZSBwYWdlcyB3ZQ0KcGFzcyBpbiB0byB0aGUgUlBDIGxheWVyIGFyZSBub3QgZ3VhcmFudGVl
ZCB0byBjb250YWluIHN0YWJsZSBkYXRhDQpzaW5jZSB0aGV5IGluY2x1ZGUgdW5sb2NrZWQgcGFn
ZSBjYWNoZSBwYWdlcyBhcyB3ZWxsIGFzIE9fRElSRUNUIHBhZ2VzLg0KDQotLSANClRyb25kIE15
a2xlYnVzdA0KTGludXggTkZTIGNsaWVudCBtYWludGFpbmVyLCBIYW1tZXJzcGFjZQ0KdHJvbmQu
bXlrbGVidXN0QGhhbW1lcnNwYWNlLmNvbQ0KDQoNCg==
