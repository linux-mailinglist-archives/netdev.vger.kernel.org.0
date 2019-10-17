Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893AEDA4CA
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 06:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407775AbfJQEf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 00:35:56 -0400
Received: from thsbbfxrt01p.thalesgroup.com ([192.54.144.131]:57698 "EHLO
        thsbbfxrt01p.thalesgroup.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726394AbfJQEf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 00:35:56 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2019 00:35:54 EDT
Received: from thsbbfxrt01p.thalesgroup.com (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 46tx6Z3hSmz44nN;
        Thu, 17 Oct 2019 06:30:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thalesgroup.com;
        s=xrt20181201; t=1571286630;
        bh=O64FPBGQUrQtbB7zcOSO4pj++QSQdX9KKYztJ7QTMc0=;
        h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
         Content-Transfer-Encoding:MIME-Version:From;
        b=pD0s5LWv5Pp9FPrdvlwKGxrGEYSAToU9m/WBQS6tdjOHXFvt3xyYDN4tQ1n++5JC9
         bJqvx4Z3j7y5nCXi0VSI4HMRdcJ2JEL71wYqlp/oLhjm8NIzKlqpLfNmKo6z7JnP6V
         7pvGGYDvzfBp/ygFBna5cW/P7Qq3RU4QmWuSTKQ43ht5KmH3lXZprgMe8+2r0Lvi4E
         t8z6pAXJNUaCgWiRRBPzS/HNyaofYFrUaVN1ASmmOxxKC4q1BDKjXR5E9fHEdksp1Q
         HkmFYiCb956LOar9shqQT/2fpaqmePtKSiPdzIrOJpHX/cN0phvmJwCJBUmPFnlubW
         Mr0dFKvV45rRA==
From:   JABLONSKY Jan <Jan.JABLONSKY@thalesgroup.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Trond Myklebust <trond.myklebust@primarydata.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Jeff Layton" <jlayton@poochiereds.net>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>
Subject: Re: [PATCH net] sunrpc: fix UDP memory accounting for v4.4 kernel
Thread-Topic: [PATCH net] sunrpc: fix UDP memory accounting for v4.4 kernel
Thread-Index: AQHVgykwG4NF6Q3nKk+Y9JJzJaI8uadbS1yAgALT/YA=
Date:   Thu, 17 Oct 2019 04:30:28 +0000
Message-ID: <e9d73f769e19418143f381ac724d93c275aa3ecc.camel@thalesgroup.com>
References: <e5070c6d6157290c2a3f627a50d951ca141973b1.camel@thalesgroup.com>
         <5ba8b82764c8b51744f9c77355c2c917e9206d19.camel@redhat.com>
In-Reply-To: <5ba8b82764c8b51744f9c77355c2c917e9206d19.camel@redhat.com>
Accept-Language: en-US, fr-FR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.1-2 
x-pmwin-version: 4.0.3, Antivirus-Engine: 3.74.1, Antivirus-Data: 5.68
Content-Type: text/plain; charset="utf-8"
Content-ID: <F55796EE29EAAE4A8E48E01142430812@iris.infra.thales>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTEwLTE1IGF0IDExOjE5ICswMjAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4g
SGksDQo+IA0KPiBPbiBUdWUsIDIwMTktMTAtMTUgYXQgMDc6MjEgKzAwMDAsIEpBQkxPTlNLWSBK
YW4gd3JvdGU6DQo+ID4gVGhlIHNhbWUgd2FybmluZ3MgcmVwb3J0ZWQgYnkgSmFuIFN0YW5jZWsg
bWF5IGFwcGVhciBhbHNvIG9uIDQuNA0KPiA+IEJhc2VkIG9uIFBhb2xvIEFiZW5pJ3Mgd29yay4N
Cj4gPiANCj4gPiBXQVJOSU5HOiBhdCBuZXQvaXB2NC9hZl9pbmV0LmM6MTU1DQo+ID4gQ1BVOiAx
IFBJRDogMjE0IENvbW06IGt3b3JrZXIvMToxSCBOb3QgdGFpbnRlZCA0LjQuMTY2ICMxDQo+ID4g
V29ya3F1ZXVlOiBycGNpb2QgLnhwcnRfYXV0b2Nsb3NlDQo+ID4gdGFzazogYzAwMDAwMDAzNjZm
NTdjMCB0aTogYzAwMDAwMDAzNDEzNDAwMCB0YXNrLnRpOg0KPiA+IGMwMDAwMDAwMzQxMzQwMDAN
Cj4gPiBOSVAgW2MwMDAwMDAwMDA2NjIyNjhdIC5pbmV0X3NvY2tfZGVzdHJ1Y3QrMHgxNTgvMHgy
MDANCj4gPiANCj4gPiBCYXNlZCBvbjogIltuZXRdIHN1bnJwYzogZml4IFVEUCBtZW1vcnkgYWNj
b3VudGluZyINCj4gDQo+IFNpbmNlIHlvdXIgZ29hbCBoZXJlIGlzIHRoZSBpbmNsdXNpb24gaW50
byB0aGUgNC40Lnkgc3RhYmxlIHRyZWUsIHlvdQ0KPiBzaG91bGQgZm9sbG93IHRoZSBpbnN0cnVj
dGlvbnMgbGlzdGVkIGhlcmU6DQo+IA0KPiBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1s
L2xhdGVzdC9wcm9jZXNzL3N0YWJsZS1rZXJuZWwtcnVsZXMuaHQNCj4gbWwNCj4gDQoNClN1cmUs
DQpidXQgdW5mb3J0dW5ldGFseSBJIG5vdGljZWQgYTQxYmQyNWFlNjdkICh3aXRoIGNvbW1lbnQg
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyA0LjQrKQ0KYW5kIHNpbmNlIHRoZW4gSSBoYXZl
bid0IHNlZW4gYW55IGFkZGl0aW9uYWwgZWZmb3J0IHRvIGJyaW5nIChiYWNrcG9ydCkgdGhpcyBw
YXRjaCBhbHNvIGZvciA0LjQuDQpTbyBJIHdhbnQgdG8gbWFrZSBpdCBjbGVhciwgYmVmb3JlIHNl
bmRpbmcgdGhlIHBhdGNoIHRvIHRoZSA0LjQueSBzdGFibGUgdHJlZQ0KDQpUaGFua3MgZm9yIGZl
ZWRiYWNrDQo=
