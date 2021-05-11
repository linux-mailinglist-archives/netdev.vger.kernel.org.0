Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB23437A703
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbhEKMry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:47:54 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:13967 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhEKMry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 08:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1620737208; x=1652273208;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=9mYQdexU/j0t5uVV5OxSrAwNJQ/AzFnPxwg3Sa0K8j8=;
  b=ZD8NnEK9QXzH+oegDYrViQi0rfLkhGa1wFVNca2s14yig3Q7aE7vnEKC
   Z8GKWktDcdulnJp0VE1CiYdoJ0aj4v7TZSkU74XWm4ntuGHxwY82l9DRK
   +cQIBWR8krajAG+8ULahAOIU1vhhFTw2YwB0NmO9RgFSk1uGAsVSWAiw7
   E=;
X-IronPort-AV: E=Sophos;i="5.82,290,1613433600"; 
   d="scan'208";a="134361449"
Subject: RE: [PATCH] xen-netback: Check for hotplug-status existence before watching
Thread-Topic: [PATCH] xen-netback: Check for hotplug-status existence before watching
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 11 May 2021 12:46:41 +0000
Received: from EX13D32EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 146DAA1865;
        Tue, 11 May 2021 12:46:40 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC003.ant.amazon.com (10.43.164.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 May 2021 12:46:38 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.015;
 Tue, 11 May 2021 12:46:38 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     =?utf-8?B?TWFyZWsgTWFyY3p5a293c2tpLUfDs3JlY2tp?= 
        <marmarek@invisiblethingslab.com>
CC:     Michael Brown <mbrown@fensystems.co.uk>,
        "paul@xen.org" <paul@xen.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>
Thread-Index: AQHXMHlgrSEnNO4f/0CXVVR3ElA0XKrdNJQAgAAEMoCAAAGvAIAAA+GAgAAKCwCAAL1BsIAAPacAgAABMQCAACDP4A==
Date:   Tue, 11 May 2021 12:46:38 +0000
Message-ID: <9edd6873034f474baafd70b1df693001@EX13D32EUC003.ant.amazon.com>
References: <54659eec-e315-5dc5-1578-d91633a80077@xen.org>
 <20210413152512.903750-1-mbrown@fensystems.co.uk> <YJl8IC7EbXKpARWL@mail-itl>
 <404130e4-210d-2214-47a8-833c0463d997@fensystems.co.uk>
 <YJmBDpqQ12ZBGf58@mail-itl>
 <21f38a92-c8ae-12a7-f1d8-50810c5eb088@fensystems.co.uk>
 <YJmMvTkp2Y1hlLLm@mail-itl>
 <df9e9a32b0294aee814eeb58d2d71edd@EX13D32EUC003.ant.amazon.com>
 <YJpfORXIgEaWlQ7E@mail-itl> <YJpgNvOmDL9SuRye@mail-itl>
In-Reply-To: <YJpgNvOmDL9SuRye@mail-itl>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.209]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJlayBNYXJjenlrb3dza2kt
R8OzcmVja2kgPG1hcm1hcmVrQGludmlzaWJsZXRoaW5nc2xhYi5jb20+DQo+IFNlbnQ6IDExIE1h
eSAyMDIxIDExOjQ1DQo+IFRvOiBEdXJyYW50LCBQYXVsIDxwZHVycmFudEBhbWF6b24uY28udWs+
DQo+IENjOiBNaWNoYWVsIEJyb3duIDxtYnJvd25AZmVuc3lzdGVtcy5jby51az47IHBhdWxAeGVu
Lm9yZzsgeGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyB3ZWkubGl1QGtlcm5lbC5vcmcNCj4gU3ViamVjdDogUkU6IFtFWFRFUk5BTF0gW1BB
VENIXSB4ZW4tbmV0YmFjazogQ2hlY2sgZm9yIGhvdHBsdWctc3RhdHVzIGV4aXN0ZW5jZSBiZWZv
cmUgd2F0Y2hpbmcNCj4gDQo+IE9uIFR1ZSwgTWF5IDExLCAyMDIxIGF0IDEyOjQwOjU0UE0gKzAy
MDAsIE1hcmVrIE1hcmN6eWtvd3NraS1Hw7NyZWNraSB3cm90ZToNCj4gPiBPbiBUdWUsIE1heSAx
MSwgMjAyMSBhdCAwNzowNjo1NUFNICswMDAwLCBEdXJyYW50LCBQYXVsIHdyb3RlOg0KPiA+ID4g
PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gPiBGcm9tOiBNYXJlayBNYXJjenlr
b3dza2ktR8OzcmVja2kgPG1hcm1hcmVrQGludmlzaWJsZXRoaW5nc2xhYi5jb20+DQo+ID4gPiA+
IFNlbnQ6IDEwIE1heSAyMDIxIDIwOjQzDQo+ID4gPiA+IFRvOiBNaWNoYWVsIEJyb3duIDxtYnJv
d25AZmVuc3lzdGVtcy5jby51az47IHBhdWxAeGVuLm9yZw0KPiA+ID4gPiBDYzogcGF1bEB4ZW4u
b3JnOyB4ZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IHdlaS5saXVAa2VybmVsLm9yZzsNCj4gRHVycmFudCwNCj4gPiA+ID4gUGF1bCA8cGR1cnJh
bnRAYW1hem9uLmNvLnVrPg0KPiA+ID4gPiBTdWJqZWN0OiBSRTogW0VYVEVSTkFMXSBbUEFUQ0hd
IHhlbi1uZXRiYWNrOiBDaGVjayBmb3IgaG90cGx1Zy1zdGF0dXMgZXhpc3RlbmNlIGJlZm9yZSB3
YXRjaGluZw0KPiA+ID4gPg0KPiA+ID4gPiBPbiBNb24sIE1heSAxMCwgMjAyMSBhdCAwODowNjo1
NVBNICswMTAwLCBNaWNoYWVsIEJyb3duIHdyb3RlOg0KPiA+ID4gPiA+IElmIHlvdSBoYXZlIGEg
c3VnZ2VzdGVkIHBhdGNoLCBJJ20gaGFwcHkgdG8gdGVzdCB0aGF0IGl0IGRvZXNuJ3QgcmVpbnRy
b2R1Y2UNCj4gPiA+ID4gPiB0aGUgcmVncmVzc2lvbiBidWcgdGhhdCB3YXMgZml4ZWQgYnkgdGhp
cyBjb21taXQuDQo+ID4gPiA+DQo+ID4gPiA+IEFjdHVhbGx5LCBJJ3ZlIGp1c3QgdGVzdGVkIHdp
dGggYSBzaW1wbGUgcmVsb2FkaW5nIHhlbi1uZXRmcm9udCBtb2R1bGUuIEl0DQo+ID4gPiA+IHNl
ZW1zIGluIHRoaXMgY2FzZSwgdGhlIGhvdHBsdWcgc2NyaXB0IGlzIG5vdCByZS1leGVjdXRlZC4g
SW4gZmFjdCwgSQ0KPiA+ID4gPiB0aGluayBpdCBzaG91bGQgbm90IGJlIHJlLWV4ZWN1dGVkIGF0
IGFsbCwgc2luY2UgdGhlIHZpZiBpbnRlcmZhY2UNCj4gPiA+ID4gcmVtYWlucyBpbiBwbGFjZSAo
aXQganVzdCBnZXRzIE5PLUNBUlJJRVIgZmxhZykuDQo+ID4gPiA+DQo+ID4gPiA+IFRoaXMgYnJp
bmdzIGEgcXVlc3Rpb24sIHdoeSByZW1vdmluZyBob3RwbHVnLXN0YXR1cyBpbiB0aGUgZmlyc3Qg
cGxhY2U/DQo+ID4gPiA+IFRoZSBpbnRlcmZhY2UgcmVtYWlucyBjb3JyZWN0bHkgY29uZmlndXJl
ZCBieSB0aGUgaG90cGx1ZyBzY3JpcHQgYWZ0ZXINCj4gPiA+ID4gYWxsLiBGcm9tIHRoZSBjb21t
aXQgbWVzc2FnZToNCj4gPiA+ID4NCj4gPiA+ID4gICAgIHhlbi1uZXRiYWNrOiByZW1vdmUgJ2hv
dHBsdWctc3RhdHVzJyBvbmNlIGl0IGhhcyBzZXJ2ZWQgaXRzIHB1cnBvc2UNCj4gPiA+ID4NCj4g
PiA+ID4gICAgIFJlbW92aW5nIHRoZSAnaG90cGx1Zy1zdGF0dXMnIG5vZGUgaW4gbmV0YmFja19y
ZW1vdmUoKSBpcyB3cm9uZzsgdGhlIHNjcmlwdA0KPiA+ID4gPiAgICAgbWF5IG5vdCBoYXZlIGNv
bXBsZXRlZC4gT25seSByZW1vdmUgdGhlIG5vZGUgb25jZSB0aGUgd2F0Y2ggaGFzIGZpcmVkIGFu
ZA0KPiA+ID4gPiAgICAgaGFzIGJlZW4gdW5yZWdpc3RlcmVkLg0KPiA+ID4gPg0KPiA+ID4gPiBJ
IHRoaW5rIHRoZSBpbnRlbnRpb24gd2FzIHRvIHJlbW92ZSAnaG90cGx1Zy1zdGF0dXMnIG5vZGUg
X2xhdGVyXyBpbg0KPiA+ID4gPiBjYXNlIG9mIHF1aWNrbHkgYWRkaW5nIGFuZCByZW1vdmluZyB0
aGUgaW50ZXJmYWNlLiBJcyB0aGF0IHJpZ2h0LCBQYXVsPw0KPiA+ID4NCj4gPiA+IFRoZSByZW1v
dmFsIHdhcyBkb25lIHRvIGFsbG93IHVuYmluZC9iaW5kIHRvIGZ1bmN0aW9uIGNvcnJlY3RseS4g
SUlSQyBiZWZvcmUgdGhlIG9yaWdpbmFsIHBhdGNoDQo+IGRvaW5nIGEgYmluZCB3b3VsZCBzdGFs
bCBmb3JldmVyIHdhaXRpbmcgZm9yIHRoZSBob3RwbHVnIHN0YXR1cyB0byBjaGFuZ2UsIHdoaWNo
IHdvdWxkIG5ldmVyIGhhcHBlbi4NCj4gPg0KPiA+IEhtbSwgaW4gdGhhdCBjYXNlIG1heWJlIGRv
bid0IHJlbW92ZSBpdCBhdCBhbGwgaW4gdGhlIGJhY2tlbmQsIGFuZCBsZXQNCj4gPiBpdCBiZSBj
bGVhbmVkIHVwIGJ5IHRoZSB0b29sc3RhY2ssIHdoZW4gaXQgcmVtb3ZlcyBvdGhlciBiYWNrZW5k
LXJlbGF0ZWQNCj4gPiBub2Rlcz8NCj4gDQo+IE5vLCB1bmJpbmQvYmluZCBfZG9lc18gcmVxdWly
ZSBob3RwbHVnIHNjcmlwdCB0byBiZSBjYWxsZWQgYWdhaW4uDQo+IA0KDQpZZXMsIHNvcnJ5IEkg
d2FzIG1pc3JlbWVtYmVyaW5nLiBNeSBtZW1vcnkgaXMgaGF6eSBidXQgdGhlcmUgd2FzIGRlZmlu
aXRlbHkgYSBwcm9ibGVtIGF0IHRoZSB0aW1lIHdpdGggbGVhdmluZyB0aGUgbm9kZSBpbiBwbGFj
ZS4NCg0KPiBXaGVuIGV4YWN0bHkgdmlmIGludGVyZmFjZSBhcHBlYXJzIGluIHRoZSBzeXN0ZW0g
KHN0YXJ0cyB0byBiZSBhdmFpbGFibGUNCj4gZm9yIHRoZSBob3RwbHVnIHNjcmlwdCk/IE1heWJl
IHJlbW92ZSAnaG90cGx1Zy1zdGF0dXMnIGp1c3QgYmVmb3JlIHRoYXQNCj4gcG9pbnQ/DQo+IA0K
DQpJIHJlYWxseSBjYW4ndCByZW1lbWJlciBhbnkgZGV0YWlsLiBQZXJoYXBzIHRyeSByZXZlcnRp
bmcgYm90aCBwYXRjaGVzIHRoZW4gYW5kIGNoZWNrIHRoYXQgdGhlIHVuYmluZC9ybW1vZC9tb2Rw
cm9iZS9iaW5kIHNlcXVlbmNlIHN0aWxsIHdvcmtzIChhbmQgdGhlIGJhY2tlbmQgYWN0dWFsbHkg
bWFrZXMgaXQgaW50byBjb25uZWN0ZWQgc3RhdGUpLg0KDQogIFBhdWwNCg0K
