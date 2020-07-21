Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832FA227497
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgGUBdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:33:35 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2582 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725857AbgGUBde (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 21:33:34 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 240938F82CA7BC3CD607;
        Tue, 21 Jul 2020 09:33:33 +0800 (CST)
Received: from DGGEMM421-HUB.china.huawei.com (10.1.198.38) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 21 Jul 2020 09:33:32 +0800
Received: from DGGEMM508-MBX.china.huawei.com ([169.254.2.193]) by
 dggemm421-hub.china.huawei.com ([10.1.198.38]) with mapi id 14.03.0487.000;
 Tue, 21 Jul 2020 09:33:30 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "michael.hennerich@analog.com" <michael.hennerich@analog.com>,
        "alex.aring@gmail.com" <alex.aring@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, "kjlu@umn.edu" <kjlu@umn.edu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net] ieee802154: fix one possible memleak in
 adf7242_probe
Thread-Topic: [PATCH v2 net] ieee802154: fix one possible memleak in
 adf7242_probe
Thread-Index: AQHWXqBUQcmuPpZs2EW93v3z9RR+H6kRPsJQ
Date:   Tue, 21 Jul 2020 01:33:31 +0000
Message-ID: <4F88C5DDA1E80143B232E89585ACE27D129AA062@dggemm508-mbx.china.huawei.com>
References: <20200720143001.40194-1-liujian56@huawei.com>
 <3a35ee9a-d10d-96b7-2804-025b00e5bd0d@datenfreihafen.org>
In-Reply-To: <3a35ee9a-d10d-96b7-2804-025b00e5bd0d@datenfreihafen.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.177.124]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU3RlZmFuIFNjaG1pZHQg
W21haWx0bzpzdGVmYW5AZGF0ZW5mcmVpaGFmZW4ub3JnXQ0KPiBTZW50OiBNb25kYXksIEp1bHkg
MjAsIDIwMjAgMTA6MTYgUE0NCj4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5j
b20+OyBtaWNoYWVsLmhlbm5lcmljaEBhbmFsb2cuY29tOw0KPiBhbGV4LmFyaW5nQGdtYWlsLmNv
bTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOw0KPiBramx1QHVtbi5lZHU7
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiBuZXRdIGll
ZWU4MDIxNTQ6IGZpeCBvbmUgcG9zc2libGUgbWVtbGVhayBpbg0KPiBhZGY3MjQyX3Byb2JlDQo+
IA0KPiBIZWxsby4NCj4gDQo+IE9uIDIwLjA3LjIwIDE2OjMwLCBMaXUgSmlhbiB3cm90ZToNCj4g
PiBXaGVuIHByb2JlIGZhaWwsIHdlIHNob3VsZCBkZXN0cm95IHRoZSB3b3JrcXVldWUuDQo+ID4N
Cj4gPiBGaXhlczogMjc5NWU4YzI1MTYxICgibmV0OiBpZWVlODAyMTU0OiBmaXggYSBwb3RlbnRp
YWwgTlVMTCBwb2ludGVyDQo+ID4gZGVyZWZlcmVuY2UiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IExp
dSBKaWFuIDxsaXVqaWFuNTZAaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiB2MS0+djI6DQo+ID4g
Q2hhbmdlIHRhcmdldGluZyBmcm9tICJuZXQtbmV4dCIgdG8gIm5ldCINCj4gDQo+IA0KPiBCZWZv
cmUgc2VuZGluZyBhIHNlY29uZCB2ZXJzaW9uIG1ha2Ugc3VyZSB5b3UgY2hlY2sgcmVwbGllcyB0
byB5b3VyIHBhdGNoDQo+IHBvc3RpbmdzLiBJIGFscmVhZHkgYXBwbGllZCB0aGUgdjEgcGF0Y2gg
dG8gbXkgd3BhbiB0cmVlIHdoaWNoIGdvZXMgaW50byBuZXQuDQpJIGFtIHNvcnJ5IGZvciB0aGlz
LCBJIHdpbGwgY2hlY2sgdGhlIG1haWwgZmlyc3QgaGVyZWFmdGVyLg0KPiBBcyB2MiBpdCBpcyBp
ZGVudGljYWwgdjEgdGhlcmVpIHMgbm90aGluZyB0byBkbyBoZXJlIGZvciBtZS4NCj4gDQo+IHJl
Z2FyZHMNCj4gU3RlZmFuIFNjaG1pZHQNCg==
