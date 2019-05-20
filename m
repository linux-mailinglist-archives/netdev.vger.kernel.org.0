Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A1E24369
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 00:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfETWRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 18:17:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:20368 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfETWRw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 18:17:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 15:17:51 -0700
X-ExtLoop1: 1
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga006.fm.intel.com with ESMTP; 20 May 2019 15:17:50 -0700
Received: from orsmsx154.amr.corp.intel.com (10.22.226.12) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 20 May 2019 15:17:49 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX154.amr.corp.intel.com ([169.254.11.101]) with mapi id 14.03.0415.000;
 Mon, 20 May 2019 15:17:49 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mroos@linux.ee" <mroos@linux.ee>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
CC:     "bp@alien8.de" <bp@alien8.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "namit@vmware.com" <namit@vmware.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [PATCH v2] vmalloc: Fix issues with flush flag
Thread-Topic: [PATCH v2] vmalloc: Fix issues with flush flag
Thread-Index: AQHVD0ezpbXySuUS5EinefGl750kkaZ0/uwAgAALkwA=
Date:   Mon, 20 May 2019 22:17:49 +0000
Message-ID: <c6020a01e81d08342e1a2b3ae7e03d55858480ba.camel@intel.com>
References: <20190520200703.15997-1-rick.p.edgecombe@intel.com>
         <90f8a4e1-aa71-0c10-1a91-495ba0cb329b@linux.ee>
In-Reply-To: <90f8a4e1-aa71-0c10-1a91-495ba0cb329b@linux.ee>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.254.114.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2752FAF46305AF449FC03AABF0EBFDE7@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA1LTIxIGF0IDAwOjM2ICswMzAwLCBNZWVsaXMgUm9vcyB3cm90ZToNCj4g
PiBTd2l0Y2ggVk1fRkxVU0hfUkVTRVRfUEVSTVMgdG8gdXNlIGEgcmVndWxhciBUTEIgZmx1c2gg
aW50ZWFkIG9mDQo+ID4gdm1fdW5tYXBfYWxpYXNlcygpIGFuZCBmaXggY2FsY3VsYXRpb24gb2Yg
dGhlIGRpcmVjdCBtYXAgZm9yIHRoZQ0KPiA+IENPTkZJR19BUkNIX0hBU19TRVRfRElSRUNUX01B
UCBjYXNlLg0KPiA+IA0KPiA+IE1lZWxpcyBSb29zIHJlcG9ydGVkIGlzc3VlcyB3aXRoIHRoZSBu
ZXcgVk1fRkxVU0hfUkVTRVRfUEVSTVMgZmxhZw0KPiA+IG9uIGENCj4gPiBzcGFyYyBtYWNoaW5l
LiBPbiBpbnZlc3RpZ2F0aW9uIHNvbWUgaXNzdWVzIHdlcmUgbm90aWNlZDoNCj4gPiANCj4gPiAx
LiBUaGUgY2FsY3VsYXRpb24gb2YgdGhlIGRpcmVjdCBtYXAgYWRkcmVzcyByYW5nZSB0byBmbHVz
aCB3YXMNCj4gPiB3cm9uZy4NCj4gPiBUaGlzIGNvdWxkIGNhdXNlIHByb2JsZW1zIG9uIHg4NiBp
ZiBhIFJPIGRpcmVjdCBtYXAgYWxpYXMgZXZlciBnb3QNCj4gPiBsb2FkZWQNCj4gPiBpbnRvIHRo
ZSBUTEIuIFRoaXMgc2hvdWxkbid0IG5vcm1hbGx5IGhhcHBlbiwgYnV0IGl0IGNvdWxkIGNhdXNl
DQo+ID4gdGhlDQo+ID4gcGVybWlzc2lvbnMgdG8gcmVtYWluIFJPIG9uIHRoZSBkaXJlY3QgbWFw
IGFsaWFzLCBhbmQgdGhlbiB0aGUgcGFnZQ0KPiA+IHdvdWxkIHJldHVybiBmcm9tIHRoZSBwYWdl
IGFsbG9jYXRvciB0byBzb21lIG90aGVyIGNvbXBvbmVudCBhcyBSTw0KPiA+IGFuZA0KPiA+IGNh
dXNlIGEgY3Jhc2guDQo+ID4gDQo+ID4gMi4gQ2FsbGluZyB2bV91bm1hcF9hbGlhcygpIG9uIHZm
cmVlIGNvdWxkIHBvdGVudGlhbGx5IGJlIGEgbG90IG9mDQo+ID4gd29yayB0bw0KPiA+IGRvIG9u
IGEgZnJlZSBvcGVyYXRpb24uIFNpbXBseSBmbHVzaGluZyB0aGUgVExCIGluc3RlYWQgb2YgdGhl
DQo+ID4gd2hvbGUNCj4gPiB2bV91bm1hcF9hbGlhcygpIG9wZXJhdGlvbiBtYWtlcyB0aGUgZnJl
ZXMgZmFzdGVyIGFuZCBwdXNoZXMgdGhlDQo+ID4gaGVhdnkNCj4gPiB3b3JrIHRvIGhhcHBlbiBv
biBhbGxvY2F0aW9uIHdoZXJlIGl0IHdvdWxkIGJlIG1vcmUgZXhwZWN0ZWQuDQo+ID4gSW4gYWRk
aXRpb24gdG8gdGhlIGV4dHJhIHdvcmssIHZtX3VubWFwX2FsaWFzKCkgdGFrZXMgc29tZSBsb2Nr
cw0KPiA+IGluY2x1ZGluZw0KPiA+IGEgbG9uZyBob2xkIG9mIHZtYXBfcHVyZ2VfbG9jaywgd2hp
Y2ggd2lsbCBtYWtlIGFsbCBvdGhlcg0KPiA+IFZNX0ZMVVNIX1JFU0VUX1BFUk1TIHZmcmVlcyB3
YWl0IHdoaWxlIHRoZSBwdXJnZSBvcGVyYXRpb24gaGFwcGVucy4NCj4gPiANCj4gPiAzLiBwYWdl
X2FkZHJlc3MoKSBjYW4gaGF2ZSBsb2NraW5nIG9uIHNvbWUgY29uZmlndXJhdGlvbnMsIHNvIHNr
aXANCj4gPiBjYWxsaW5nDQo+ID4gdGhpcyB3aGVuIHBvc3NpYmxlIHRvIGZ1cnRoZXIgc3BlZWQg
dGhpcyB1cC4NCj4gPiANCj4gPiBGaXhlczogODY4YjEwNGQ3Mzc5ICgibW0vdm1hbGxvYzogQWRk
IGZsYWcgZm9yIGZyZWVpbmcgb2Ygc3BlY2lhbA0KPiA+IHBlcm1zaXNzaW9ucyIpDQo+ID4gUmVw
b3J0ZWQtYnk6IE1lZWxpcyBSb29zPG1yb29zQGxpbnV4LmVlPg0KPiA+IENjOiBNZWVsaXMgUm9v
czxtcm9vc0BsaW51eC5lZT4NCj4gPiBDYzogUGV0ZXIgWmlqbHN0cmE8cGV0ZXJ6QGluZnJhZGVh
ZC5vcmc+DQo+ID4gQ2M6ICJEYXZpZCBTLiBNaWxsZXIiPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+
ID4gQ2M6IERhdmUgSGFuc2VuPGRhdmUuaGFuc2VuQGludGVsLmNvbT4NCj4gPiBDYzogQm9yaXNs
YXYgUGV0a292PGJwQGFsaWVuOC5kZT4NCj4gPiBDYzogQW5keSBMdXRvbWlyc2tpPGx1dG9Aa2Vy
bmVsLm9yZz4NCj4gPiBDYzogSW5nbyBNb2xuYXI8bWluZ29AcmVkaGF0LmNvbT4NCj4gPiBDYzog
TmFkYXYgQW1pdDxuYW1pdEB2bXdhcmUuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJpY2sgRWRn
ZWNvbWJlPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IA0KPiA+IENo
YW5nZXMgc2luY2UgdjE6DQo+ID4gICAtIFVwZGF0ZSBjb21taXQgbWVzc2FnZSB3aXRoIG1vcmUg
ZGV0YWlsDQo+ID4gICAtIEZpeCBmbHVzaCBlbmQgcmFuZ2Ugb24gIUNPTkZJR19BUkNIX0hBU19T
RVRfRElSRUNUX01BUCBjYXNlDQo+IA0KPiBJdCBkb2VzIG5vdCB3b3JrIG9uIG15IFY0NDUgd2hl
cmUgdGhlIGluaXRpYWwgcHJvYmxlbSBoYXBwZW5lZC4NCj4gDQpUaGFua3MgZm9yIHRlc3Rpbmcu
IFNvIEkgZ3Vlc3MgdGhhdCBzdWdnZXN0cyBpdCdzIHRoZSBUTEIgZmx1c2ggY2F1c2luZw0KdGhl
IHByb2JsZW0gb24gc3BhcmMgYW5kIG5vdCBhbnkgbGF6eSBwdXJnZSBkZWFkbG9jay4gSSBoYWQg
c2VudCBNZWVsaXMNCmFub3RoZXIgdGVzdCBwYXRjaCB0aGF0IGp1c3QgZmx1c2hlZCB0aGUgZW50
aXJlIDAgdG8gVUxPTkdfTUFYIHJhbmdlIHRvDQp0cnkgdG8gYWx3YXlzIHRoZSBnZXQgdGhlICJm
bHVzaCBhbGwiIGxvZ2ljIGFuZCBhcHByZW50bHkgaXQgZGlkbid0DQpib290IG1vc3RseSBlaXRo
ZXIuIEl0IGFsc28gc2hvd2VkIHRoYXQgaXQncyBub3QgZ2V0dGluZyBzdHVjayBhbnl3aGVyZQ0K
aW4gdGhlIHZtX3JlbW92ZV9hbGlhcygpIGZ1bmN0aW9uLiBTb21ldGhpbmcganVzdCBoYW5ncyBs
YXRlci4NCg0KDQo=
