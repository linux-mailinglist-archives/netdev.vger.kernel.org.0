Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A6137A052
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 09:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhEKHIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 03:08:12 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:62251 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhEKHIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 03:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1620716825; x=1652252825;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=FgiF7Puuz72Tc+bHv4Fk487lVQ8q5lBGnrGRwaNZG+o=;
  b=bRMY9/im/vV3O329XRpUnzXazcHn8kZRFg41sRbEyfovYJlvyVkEARGH
   SOTsJFqmKqyZaUhNUZjyhfWMRqYJoj3RvZILwLKDlilwZLGtVC4d0Kkn9
   Dloy5c4VU923KdNGzSOn5cmx5vc4yvb+/fyNe2LSw3i/DANmb3Rk4JmP2
   M=;
X-IronPort-AV: E=Sophos;i="5.82,290,1613433600"; 
   d="scan'208";a="125102215"
Subject: RE: [PATCH] xen-netback: Check for hotplug-status existence before watching
Thread-Topic: [PATCH] xen-netback: Check for hotplug-status existence before watching
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 11 May 2021 07:06:58 +0000
Received: from EX13D32EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id C9DF3365327;
        Tue, 11 May 2021 07:06:56 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC003.ant.amazon.com (10.43.164.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 May 2021 07:06:55 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.015;
 Tue, 11 May 2021 07:06:55 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     =?utf-8?B?TWFyZWsgTWFyY3p5a293c2tpLUfDs3JlY2tp?= 
        <marmarek@invisiblethingslab.com>,
        Michael Brown <mbrown@fensystems.co.uk>,
        "paul@xen.org" <paul@xen.org>
CC:     "paul@xen.org" <paul@xen.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>
Thread-Index: AQHXMHlgrSEnNO4f/0CXVVR3ElA0XKrdNJQAgAAEMoCAAAGvAIAAA+GAgAAKCwCAAL1BsA==
Date:   Tue, 11 May 2021 07:06:55 +0000
Message-ID: <df9e9a32b0294aee814eeb58d2d71edd@EX13D32EUC003.ant.amazon.com>
References: <54659eec-e315-5dc5-1578-d91633a80077@xen.org>
 <20210413152512.903750-1-mbrown@fensystems.co.uk> <YJl8IC7EbXKpARWL@mail-itl>
 <404130e4-210d-2214-47a8-833c0463d997@fensystems.co.uk>
 <YJmBDpqQ12ZBGf58@mail-itl>
 <21f38a92-c8ae-12a7-f1d8-50810c5eb088@fensystems.co.uk>
 <YJmMvTkp2Y1hlLLm@mail-itl>
In-Reply-To: <YJmMvTkp2Y1hlLLm@mail-itl>
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
R8OzcmVja2kgPG1hcm1hcmVrQGludmlzaWJsZXRoaW5nc2xhYi5jb20+DQo+IFNlbnQ6IDEwIE1h
eSAyMDIxIDIwOjQzDQo+IFRvOiBNaWNoYWVsIEJyb3duIDxtYnJvd25AZmVuc3lzdGVtcy5jby51
az47IHBhdWxAeGVuLm9yZw0KPiBDYzogcGF1bEB4ZW4ub3JnOyB4ZW4tZGV2ZWxAbGlzdHMueGVu
cHJvamVjdC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHdlaS5saXVAa2VybmVsLm9yZzsg
RHVycmFudCwNCj4gUGF1bCA8cGR1cnJhbnRAYW1hem9uLmNvLnVrPg0KPiBTdWJqZWN0OiBSRTog
W0VYVEVSTkFMXSBbUEFUQ0hdIHhlbi1uZXRiYWNrOiBDaGVjayBmb3IgaG90cGx1Zy1zdGF0dXMg
ZXhpc3RlbmNlIGJlZm9yZSB3YXRjaGluZw0KPiANCj4gT24gTW9uLCBNYXkgMTAsIDIwMjEgYXQg
MDg6MDY6NTVQTSArMDEwMCwgTWljaGFlbCBCcm93biB3cm90ZToNCj4gPiBJZiB5b3UgaGF2ZSBh
IHN1Z2dlc3RlZCBwYXRjaCwgSSdtIGhhcHB5IHRvIHRlc3QgdGhhdCBpdCBkb2Vzbid0IHJlaW50
cm9kdWNlDQo+ID4gdGhlIHJlZ3Jlc3Npb24gYnVnIHRoYXQgd2FzIGZpeGVkIGJ5IHRoaXMgY29t
bWl0Lg0KPiANCj4gQWN0dWFsbHksIEkndmUganVzdCB0ZXN0ZWQgd2l0aCBhIHNpbXBsZSByZWxv
YWRpbmcgeGVuLW5ldGZyb250IG1vZHVsZS4gSXQNCj4gc2VlbXMgaW4gdGhpcyBjYXNlLCB0aGUg
aG90cGx1ZyBzY3JpcHQgaXMgbm90IHJlLWV4ZWN1dGVkLiBJbiBmYWN0LCBJDQo+IHRoaW5rIGl0
IHNob3VsZCBub3QgYmUgcmUtZXhlY3V0ZWQgYXQgYWxsLCBzaW5jZSB0aGUgdmlmIGludGVyZmFj
ZQ0KPiByZW1haW5zIGluIHBsYWNlIChpdCBqdXN0IGdldHMgTk8tQ0FSUklFUiBmbGFnKS4NCj4g
DQo+IFRoaXMgYnJpbmdzIGEgcXVlc3Rpb24sIHdoeSByZW1vdmluZyBob3RwbHVnLXN0YXR1cyBp
biB0aGUgZmlyc3QgcGxhY2U/DQo+IFRoZSBpbnRlcmZhY2UgcmVtYWlucyBjb3JyZWN0bHkgY29u
ZmlndXJlZCBieSB0aGUgaG90cGx1ZyBzY3JpcHQgYWZ0ZXINCj4gYWxsLiBGcm9tIHRoZSBjb21t
aXQgbWVzc2FnZToNCj4gDQo+ICAgICB4ZW4tbmV0YmFjazogcmVtb3ZlICdob3RwbHVnLXN0YXR1
cycgb25jZSBpdCBoYXMgc2VydmVkIGl0cyBwdXJwb3NlDQo+IA0KPiAgICAgUmVtb3ZpbmcgdGhl
ICdob3RwbHVnLXN0YXR1cycgbm9kZSBpbiBuZXRiYWNrX3JlbW92ZSgpIGlzIHdyb25nOyB0aGUg
c2NyaXB0DQo+ICAgICBtYXkgbm90IGhhdmUgY29tcGxldGVkLiBPbmx5IHJlbW92ZSB0aGUgbm9k
ZSBvbmNlIHRoZSB3YXRjaCBoYXMgZmlyZWQgYW5kDQo+ICAgICBoYXMgYmVlbiB1bnJlZ2lzdGVy
ZWQuDQo+IA0KPiBJIHRoaW5rIHRoZSBpbnRlbnRpb24gd2FzIHRvIHJlbW92ZSAnaG90cGx1Zy1z
dGF0dXMnIG5vZGUgX2xhdGVyXyBpbg0KPiBjYXNlIG9mIHF1aWNrbHkgYWRkaW5nIGFuZCByZW1v
dmluZyB0aGUgaW50ZXJmYWNlLiBJcyB0aGF0IHJpZ2h0LCBQYXVsPw0KDQpUaGUgcmVtb3ZhbCB3
YXMgZG9uZSB0byBhbGxvdyB1bmJpbmQvYmluZCB0byBmdW5jdGlvbiBjb3JyZWN0bHkuIElJUkMg
YmVmb3JlIHRoZSBvcmlnaW5hbCBwYXRjaCBkb2luZyBhIGJpbmQgd291bGQgc3RhbGwgZm9yZXZl
ciB3YWl0aW5nIGZvciB0aGUgaG90cGx1ZyBzdGF0dXMgdG8gY2hhbmdlLCB3aGljaCB3b3VsZCBu
ZXZlciBoYXBwZW4uDQoNCj4gSW4gdGhhdCBjYXNlLCBsZXR0aW5nIGhvdHBsdWdfc3RhdHVzX2No
YW5nZWQoKSByZW1vdmUgdGhlIGVudHJ5IHdvbnQNCj4gd29yaywgYmVjYXVzZSB0aGUgd2F0Y2gg
d2FzIHVucmVnaXN0ZXJlZCBmZXcgbGluZXMgZWFybGllciBpbg0KPiBuZXRiYWNrX3JlbW92ZSgp
LiBBbmQga2VlcGluZyB0aGUgd2F0Y2ggaXMgbm90IGFuIG9wdGlvbiwgYmVjYXVzZSB0aGUNCj4g
d2hvbGUgYmFja2VuZF9pbmZvIHN0cnVjdCBpcyBnb2luZyB0byBiZSBmcmVlLWVkIGFscmVhZHku
DQo+IA0KPiBJZiBteSBndWVzcyBhYm91dCB0aGUgb3JpZ2luYWwgcmVhc29uIGZvciB0aGUgY2hh
bmdlIGlzIHJpZ2h0LCBJIHRoaW5rDQo+IGl0IHNob3VsZCBiZSBmaXhlZCBhdCB0aGUgaG90cGx1
ZyBzY3JpcHQgbGV2ZWwgLSBpdCBzaG91bGQgY2hlY2sgaWYgdGhlDQo+IGRldmljZSBpcyBzdGls
bCB0aGVyZSBiZWZvcmUgd3JpdGluZyAnaG90cGx1Zy1zdGF0dXMnIG5vZGUuDQo+IEknbSBub3Qg
c3VyZSBpZiBkb2luZyBpdCByYWNlLWZyZWUgaXMgcG9zc2libGUgZnJvbSBhIHNoZWxsIHNjcmlw
dCAoSSB0aGluayBpdA0KPiByZXF1aXJlcyBkb2luZyB4ZW5zdG9yZSByZWFkIF9hbmRfIHdyaXRl
IGluIGEgc2luZ2xlIHRyYW5zYWN0aW9uKS4gQnV0DQo+IGluIHRoZSB3b3JzdCBjYXNlLCB0aGUg
YWZ0ZXJtYXRoIG9mIGxvb3NpbmcgdGhlIHJhY2UgaXMgbGVhdmluZyBzdHJheQ0KPiAnaG90cGx1
Zy1zdGF0dXMnIHhlbnN0b3JlIG5vZGUgLSBub3QgaWRlYWwsIGJ1dCBhbHNvIGxlc3MgaGFybWZ1
bCB0aGFuDQo+IGZhaWxpbmcgdG8gYnJpbmcgdXAgYW4gaW50ZXJmYWNlLiBBdCB0aGlzIHBvaW50
LCB0aGUgdG9vbHN0YWNrIGNvdWxkIGNsZWFudXANCj4gaXQgbGF0ZXIsIHBlcmhhcHMgd2hpbGUg
c2V0dGluZyB1cCB0aGF0IGludGVyZmFjZSBhZ2FpbiAoaWYgaXQgZ2V0cw0KPiByZS1jb25uZWN0
ZWQpPw0KPiANCj4gQW55d2F5LCBwZXJoYXBzIHRoZSBiZXN0IHRoaW5nIHRvIGRvIG5vdywgaXMg
dG8gcmV2ZXJ0IGJvdGggY29tbWl0cywgYW5kDQo+IHRoaW5rIG9mIGFuIGFsdGVybmF0aXZlIHNv
bHV0aW9uIGZvciB0aGUgb3JpZ2luYWwgaXNzdWU/IFRoYXQgb2YgY291cnNlDQo+IGFzc3VtZXMg
SSBndWVzc2VkIGNvcnJlY3RseSB3aHkgaXQgd2FzIGRvbmUgaW4gdGhlIGZpcnN0IHBsYWNlLi4u
DQo+IA0KDQpTaW1wbHkgcmV2ZXJ0aW5nIGV2ZXJ5dGhpbmcgd291bGQgbGlrZWx5IGJyZWFrIHRo
ZSBhYmlsaXR5IHRvIGRvIHVuYmluZCBhbmQgYmluZCAod2hpY2ggaXMgdXNlZnVsIGUuZyB0byBh
bGxvdyB1cGRhdGUgdGhlIG5ldGJhY2sgbW9kdWxlIHdoaWxzdCBndWVzdHMgYXJlIHN0aWxsIHJ1
bm5pbmcpIHNvIEkgZG9uJ3QgdGhpbmsgdGhhdCdzIGFuIG9wdGlvbi4NCg0KICBQYXVsDQo=
