Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1863884301
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 05:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfHGDpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 23:45:51 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:54916 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbfHGDpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 23:45:51 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 9B86A886BF;
        Wed,  7 Aug 2019 15:45:47 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1565149547;
        bh=WOgXwv8hLflF8etTp24fLFm/K4eLww1QjBDI++02SKY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=Fm7HOtyAF8/t5VWoF3qbsRgh1+n1Kp8wlHFbZeDlno0BivB2d3pkivVKgXtV//oaL
         WUGT/M3D/L0RTFife1DtIX5ze/ZK73OEMe8ylZFJ8lubX7qjCpMW7eSinNUaV/sqVi
         LUd38R7igoi+5qbfsoPWsYauYMM1/U0NJhkECw7a13knqI56ihk2zuVb6iUDXLJXD0
         kRUKtAHFBOs06ly8+KSNsM093E4zsQ19maggW1vgunUYkK3Dq1OIyxxGDfZkSXpVYq
         aKbwbx29zZ3yqkUxAnCqorOy4wiYrXSMhAzRhr+fZgpskhT6JUO7XsdhrQEBk3dzRQ
         phCqQnujAdvUg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d4a496b0000>; Wed, 07 Aug 2019 15:45:47 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1156.6; Wed, 7 Aug 2019 15:45:44 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Wed, 7 Aug 2019 15:45:44 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "jon.maloy@ericsson.com" <jon.maloy@ericsson.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Slowness forming TIPC cluster with explicit node addresses
Thread-Topic: Slowness forming TIPC cluster with explicit node addresses
Thread-Index: AQHVQ0Hkw5M86TmlWkazctTgG4cJIabc5XqAgALa5YCABtFugIAFBHpw//9MBoCABC4cMP//RRcA
Date:   Wed, 7 Aug 2019 03:45:44 +0000
Message-ID: <1565149544.19352.20.camel@alliedtelesis.co.nz>
References: <1564097836.11887.16.camel@alliedtelesis.co.nz>
         <CH2PR15MB35754D65AB240A74AE488E719AC00@CH2PR15MB3575.namprd15.prod.outlook.com>
         <1564347861.9737.25.camel@alliedtelesis.co.nz>
         <1564722689.4914.27.camel@alliedtelesis.co.nz>
         <CH2PR15MB3575BF6FC4001C19B8A789559ADB0@CH2PR15MB3575.namprd15.prod.outlook.com>
         <1564959879.27215.18.camel@alliedtelesis.co.nz>
         <CH2PR15MB35759E27F2A01FAE59AB66809AD40@CH2PR15MB3575.namprd15.prod.outlook.com>
In-Reply-To: <CH2PR15MB35759E27F2A01FAE59AB66809AD40@CH2PR15MB3575.namprd15.prod.outlook.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.18.5.2-0ubuntu3.2 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:3a2c:4aff:fe70:2b02]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5CC2ED20F9604448DF9FD9B99FD2FB3@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSm9uLA0KDQpPbiBXZWQsIDIwMTktMDgtMDcgYXQgMDI6NTUgKzAwMDAsIEpvbiBNYWxveSB3
cm90ZToNCj4gDQo+ID4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9t
OiBDaHJpcyBQYWNraGFtIDxDaHJpcy5QYWNraGFtQGFsbGllZHRlbGVzaXMuY28ubno+DQo+ID4g
U2VudDogNC1BdWctMTkgMTk6MDUNCj4gPiBUbzogSm9uIE1hbG95IDxqb24ubWFsb3lAZXJpY3Nz
b24uY29tPjsgdGlwYy0NCj4gPiBkaXNjdXNzaW9uQGxpc3RzLnNvdXJjZWZvcmdlLm5ldA0KPiA+
IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQo+ID4gU3ViamVjdDogUmU6IFNsb3duZXNzIGZvcm1pbmcgVElQQyBjbHVzdGVyIHdpdGggZXhw
bGljaXQgbm9kZQ0KPiA+IGFkZHJlc3Nlcw0KPiA+IA0KPiA+IE9uIFN1biwgMjAxOS0wOC0wNCBh
dCAyMTo1MyArMDAwMCwgSm9uIE1hbG95IHdyb3RlOg0KPiA+ID4gDQo+ID4gPiANCj4gPiA+ID4g
DQo+ID4gPiA+IA0KPiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gPiBG
cm9tOiBuZXRkZXYtb3duZXJAdmdlci5rZXJuZWwub3JnIDxuZXRkZXYtb3duZXJAdmdlci5rZXJu
ZWwub3INCj4gPiA+ID4gZz4NCj4gPiBPbg0KPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBCZWhh
bGYgT2YgQ2hyaXMgUGFja2hhbQ0KPiA+ID4gPiBTZW50OiAyLUF1Zy0xOSAwMToxMQ0KPiA+ID4g
PiBUbzogSm9uIE1hbG95IDxqb24ubWFsb3lAZXJpY3Nzb24uY29tPjsgdGlwYy0NCj4gPiA+ID4g
ZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQNCj4gPiA+ID4gQ2M6IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+ID4gU3ViamVj
dDogUmU6IFNsb3duZXNzIGZvcm1pbmcgVElQQyBjbHVzdGVyIHdpdGggZXhwbGljaXQgbm9kZQ0K
PiA+ID4gPiBhZGRyZXNzZXMNCj4gPiA+ID4gDQo+ID4gPiA+IE9uIE1vbiwgMjAxOS0wNy0yOSBh
dCAwOTowNCArMTIwMCwgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4gPiA+ID4gPiANCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiBPbiBGcmksIDIwMTktMDctMjYgYXQgMTM6MzEgKzAwMDAsIEpvbiBNYWxv
eSB3cm90ZToNCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiANCj4gPiA+
ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IA0K
PiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gPiA+ID4gPiA+ID4gRnJvbTogbmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZyA8bmV0ZGV2
LQ0KPiA+ID4gPiBvd25lckB2Z2VyLmtlcm5lbC5vcmc+DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+
ID4gDQo+ID4gPiA+ID4gPiA+IE9uIEJlaGFsZiBPZiBDaHJpcyBQYWNraGFtDQo+ID4gPiA+ID4g
PiA+IFNlbnQ6IDI1LUp1bC0xOSAxOTozNw0KPiA+ID4gPiA+ID4gPiBUbzogdGlwYy1kaXNjdXNz
aW9uQGxpc3RzLnNvdXJjZWZvcmdlLm5ldA0KPiA+ID4gPiA+ID4gPiBDYzogbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gPiA+ID4gPiBT
dWJqZWN0OiBTbG93bmVzcyBmb3JtaW5nIFRJUEMgY2x1c3RlciB3aXRoIGV4cGxpY2l0IG5vZGUN
Cj4gPiA+ID4gPiA+ID4gYWRkcmVzc2VzDQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBI
aSwNCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IEknbSBoYXZpbmcgcHJvYmxlbXMgZm9y
bWluZyBhIFRJUEMgY2x1c3RlciBiZXR3ZWVuIDINCj4gPiA+ID4gPiA+ID4gbm9kZXMuDQo+ID4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBUaGlzIGlzIHRoZSBiYXNpYyBzdGVwcyBJJ20gZ29p
bmcgdGhyb3VnaCBvbiBlYWNoIG5vZGUuDQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBt
b2Rwcm9iZSB0aXBjDQo+ID4gPiA+ID4gPiA+IGlwIGxpbmsgc2V0IGV0aDIgdXANCj4gPiA+ID4g
PiA+ID4gdGlwYyBub2RlIHNldCBhZGRyIDEuMS41ICMgb3IgMS4xLjYgdGlwYyBiZWFyZXIgZW5h
YmxlDQo+ID4gPiA+ID4gPiA+IG1lZGlhDQo+ID4gPiA+ID4gPiA+IGV0aCBkZXYgZXRoMA0KPiA+
ID4gPiA+ID4gZXRoMiwgSSBhc3N1bWUuLi4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFllcyBz
b3JyeSBJIGtlZXAgc3dpdGNoaW5nIGJldHdlZW4gYmV0d2VlbiBFdGhlcm5ldCBwb3J0cyBmb3IN
Cj4gPiA+ID4gPiB0ZXN0aW5nDQo+ID4gPiA+ID4gc28gSSBoYW5kIGVkaXRlZCB0aGUgZW1haWwu
DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiA+IA0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gVGhlbiB0byBjb25maXJtIGlmIHRo
ZSBjbHVzdGVyIGlzIGZvcm1lZCBJIHVzZcKgdGlwYyBsaW5rDQo+ID4gPiA+ID4gPiA+IGxpc3QN
Cj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IFtyb290QG5vZGUtNSB+XSMgdGlwYyBsaW5r
IGxpc3QNCj4gPiA+ID4gPiA+ID4gYnJvYWRjYXN0LWxpbms6IHVwDQo+ID4gPiA+ID4gPiA+IC4u
Lg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gTG9va2luZyBhdCB0Y3BkdW1wIHRoZSB0
d28gbm9kZXMgYXJlIHNlbmRpbmcgcGFja2V0cw0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+
ID4gMjI6MzA6MDUuNzgyMzIwIFRJUEMgdjIuMCAxLjEuNSA+IDAuMC4wLCBoZWFkZXJsZW5ndGgg
NjANCj4gPiA+ID4gPiA+ID4gYnl0ZXMsDQo+ID4gPiA+ID4gPiA+IE1lc3NhZ2VTaXplDQo+ID4g
PiA+ID4gPiA+IDc2IGJ5dGVzLCBOZWlnaGJvciBEZXRlY3Rpb24gUHJvdG9jb2wgaW50ZXJuYWws
DQo+ID4gPiA+ID4gPiA+IG1lc3NhZ2VUeXBlDQo+ID4gPiA+ID4gPiA+IExpbmsNCj4gPiA+ID4g
PiA+ID4gcmVxdWVzdA0KPiA+ID4gPiA+ID4gPiAyMjozMDowNS44NjM1NTUgVElQQyB2Mi4wIDEu
MS42ID4gMC4wLjAsIGhlYWRlcmxlbmd0aCA2MA0KPiA+ID4gPiA+ID4gPiBieXRlcywNCj4gPiA+
ID4gPiA+ID4gTWVzc2FnZVNpemUNCj4gPiA+ID4gPiA+ID4gNzYgYnl0ZXMsIE5laWdoYm9yIERl
dGVjdGlvbiBQcm90b2NvbCBpbnRlcm5hbCwNCj4gPiA+ID4gPiA+ID4gbWVzc2FnZVR5cGUNCj4g
PiA+ID4gPiA+ID4gTGluaw0KPiA+ID4gPiA+ID4gPiByZXF1ZXN0DQo+ID4gPiA+ID4gPiA+IA0K
PiA+ID4gPiA+ID4gPiBFdmVudHVhbGx5IChhZnRlciBhIGZldyBtaW51dGVzKSB0aGUgbGluayBk
b2VzIGNvbWUgdXANCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IFtyb290QG5vZGUtNsKg
fl0jIHRpcGMgbGluayBsaXN0DQo+ID4gPiA+ID4gPiA+IGJyb2FkY2FzdC1saW5rOiB1cA0KPiA+
ID4gPiA+ID4gPiAxMDAxMDA2OmV0aDItMTAwMTAwNTpldGgyOiB1cA0KPiA+ID4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+ID4gW3Jvb3RAbm9kZS01wqB+XSMgdGlwYyBsaW5rIGxpc3QNCj4gPiA+ID4g
PiA+ID4gYnJvYWRjYXN0LWxpbms6IHVwDQo+ID4gPiA+ID4gPiA+IDEwMDEwMDU6ZXRoMi0xMDAx
MDA2OmV0aDI6IHVwDQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBXaGVuIEkgcmVtb3Zl
IHRoZSAidGlwYyBub2RlIHNldCBhZGRyIiB0aGluZ3Mgc2VlbSB0bw0KPiA+ID4gPiA+ID4gPiBr
aWNrDQo+ID4gPiA+ID4gPiA+IGludG8NCj4gPiA+ID4gPiA+ID4gbGlmZSBzdHJhaWdodCBhd2F5
DQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBbcm9vdEBub2RlLTUgfl0jIHRpcGMgbGlu
ayBsaXN0DQo+ID4gPiA+ID4gPiA+IGJyb2FkY2FzdC1saW5rOiB1cA0KPiA+ID4gPiA+ID4gPiAw
MDUwYjYxYmQyYWE6ZXRoMi0wMDUwYjYxZTZkZmE6ZXRoMjogdXANCj4gPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiA+IFNvIHRoZXJlIGFwcGVhcnMgdG8gYmUgc29tZSBkaWZmZXJlbmNlIGluIGJl
aGF2aW91cg0KPiA+ID4gPiA+ID4gPiBiZXR3ZWVuDQo+ID4gPiA+ID4gPiA+IGhhdmluZw0KPiA+
ID4gPiA+ID4gPiBhbiBleHBsaWNpdCBub2RlIGFkZHJlc3MgYW5kIHVzaW5nIHRoZSBkZWZhdWx0
Lg0KPiA+ID4gPiA+ID4gPiBVbmZvcnR1bmF0ZWx5DQo+ID4gPiA+ID4gPiA+IG91cg0KPiA+ID4g
PiA+ID4gPiBhcHBsaWNhdGlvbiByZWxpZXMgb24gc2V0dGluZyB0aGUgbm9kZSBhZGRyZXNzZXMu
DQo+ID4gPiA+ID4gPiBJIGRvIHRoaXMgbWFueSB0aW1lcyBhIGRheSwgd2l0aG91dCBhbnkgcHJv
YmxlbXMuIElmIHRoZXJlDQo+ID4gPiA+ID4gPiB3b3VsZCBiZQ0KPiA+ID4gPiA+ID4gYW55IHRp
bWUgZGlmZmVyZW5jZSwgSSB3b3VsZCBleHBlY3QgdGhlICdhdXRvIGNvbmZpZ3VyYWJsZScNCj4g
PiA+ID4gPiA+IHZlcnNpb24NCj4gPiA+ID4gPiA+IHRvIGJlIHNsb3dlciwgYmVjYXVzZSBpdCBp
bnZvbHZlcyBhIERBRCBzdGVwLg0KPiA+ID4gPiA+ID4gQXJlIHlvdSBzdXJlIHlvdSBkb24ndCBo
YXZlIGFueSBvdGhlciBub2RlcyBydW5uaW5nIGluIHlvdXINCj4gPiA+ID4gPiA+IHN5c3RlbT8N
Cj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gLy8vam9uDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4g
PiBOb3BlIHRoZSB0d28gbm9kZXMgYXJlIGNvbm5lY3RlZCBiYWNrIHRvIGJhY2suIERvZXMgdGhl
DQo+ID4gPiA+ID4gbnVtYmVyIG9mDQo+ID4gPiA+ID4gRXRoZXJuZXQgaW50ZXJmYWNlcyBtYWtl
IGEgZGlmZmVyZW5jZT8gQXMgeW91IGNhbiBzZWUgSSd2ZQ0KPiA+ID4gPiA+IGdvdCAzDQo+ID4g
PiA+ID4gb24NCj4gPiA+ID4gPiBlYWNoIG5vZGUuIE9uZSBpcyBjb21wbGV0ZWx5IGRpc2Nvbm5l
Y3RlZCwgb25lIGlzIGZvciBib290aW5nDQo+ID4gPiA+ID4gb3Zlcg0KPiA+ID4gPiA+IFRGVFAN
Cj4gPiA+ID4gPiDCoChvbmx5IHVzZWQgYnkgVS1ib290KSBhbmQgdGhlIG90aGVyIGlzIHRoZSBV
U0IgRXRoZXJuZXQgSSdtDQo+ID4gPiA+ID4gdXNpbmcgZm9yDQo+ID4gPiA+ID4gdGVzdGluZy4N
Cj4gPiA+ID4gPiANCj4gPiA+ID4gU28gSSBjYW4gc3RpbGwgcmVwcm9kdWNlIHRoaXMgb24gbm9k
ZXMgdGhhdCBvbmx5IGhhdmUgb25lDQo+ID4gPiA+IG5ldHdvcmsNCj4gPiA+ID4gaW50ZXJmYWNl
IGFuZA0KPiA+ID4gPiBhcmUgdGhlIG9ubHkgdGhpbmdzIGNvbm5lY3RlZC4NCj4gPiA+ID4gDQo+
ID4gPiA+IEkgZGlkIGZpbmQgb25lIHRoaW5nIHRoYXQgaGVscHMNCj4gPiA+ID4gDQo+ID4gPiA+
IGRpZmYgLS1naXQgYS9uZXQvdGlwYy9kaXNjb3Zlci5jIGIvbmV0L3RpcGMvZGlzY292ZXIuYyBp
bmRleA0KPiA+ID4gPiBjMTM4ZDY4ZThhNjkuLjQ5OTIxZGFkNDA0YSAxMDA2NDQNCj4gPiA+ID4g
LS0tIGEvbmV0L3RpcGMvZGlzY292ZXIuYw0KPiA+ID4gPiArKysgYi9uZXQvdGlwYy9kaXNjb3Zl
ci5jDQo+ID4gPiA+IEBAIC0zNTgsMTAgKzM1OCwxMCBAQCBpbnQgdGlwY19kaXNjX2NyZWF0ZShz
dHJ1Y3QgbmV0ICpuZXQsDQo+ID4gPiA+IHN0cnVjdA0KPiA+ID4gPiB0aXBjX2JlYXJlciAqYiwN
Cj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoHRpcGNfZGlzY19pbml0X21zZyhuZXQsIGQtPnNrYiwg
RFNDX1JFUV9NU0csIGIpOw0KPiA+ID4gPiANCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoC8qIERv
IHdlIG5lZWQgYW4gYWRkcmVzcyB0cmlhbCBwZXJpb2QgZmlyc3QgPyAqLw0KPiA+ID4gPiAtwqDC
oMKgwqDCoMKgwqBpZiAoIXRpcGNfb3duX2FkZHIobmV0KSkgew0KPiA+ID4gPiArLy/CoMKgwqDC
oMKgaWYgKCF0aXBjX293bl9hZGRyKG5ldCkpIHsNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqB0bi0+YWRkcl90cmlhbF9lbmQgPSBqaWZmaWVzICsNCj4gPiA+ID4gbXNl
Y3NfdG9famlmZmllcygxMDAwKTsNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBtc2dfc2V0X3R5cGUoYnVmX21zZyhkLT5za2IpLCBEU0NfVFJJQUxfTVNHKTsNCj4gPiA+
ID4gLcKgwqDCoMKgwqDCoMKgfQ0KPiA+ID4gPiArLy/CoMKgwqDCoMKgfQ0KPiA+ID4gPiDCoMKg
wqDCoMKgwqDCoMKgbWVtY3B5KCZkLT5kZXN0LCBkZXN0LCBzaXplb2YoKmRlc3QpKTsNCj4gPiA+
ID4gwqDCoMKgwqDCoMKgwqDCoGQtPm5ldCA9IG5ldDsNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDC
oGQtPmJlYXJlcl9pZCA9IGItPmlkZW50aXR5Ow0KPiA+ID4gPiANCj4gPiA+ID4gSSB0aGluayBi
ZWNhdXNlIHdpdGggcHJlLWNvbmZpZ3VyZWQgYWRkcmVzc2VzIHRoZSBkdXBsaWNhdGUNCj4gPiA+
ID4gYWRkcmVzcw0KPiA+ID4gPiBkZXRlY3Rpb24NCj4gPiA+ID4gaXMgc2tpcHBlZCB0aGUgc2hv
cnRlciBpbml0IHBoYXNlIGlzIHNraXBwZWQuIFdvdWxkIGlzIG1ha2UNCj4gPiA+ID4gc2Vuc2UN
Cj4gPiA+ID4gdG8NCj4gPiA+ID4gdW5jb25kaXRpb25hbGx5IGRvIHRoZSB0cmlhbCBzdGVwPyBP
ciBpcyB0aGVyZSBzb21lIGJldHRlciB3YXkNCj4gPiA+ID4gdG8NCj4gPiA+ID4gZ2V0IHRoaW5n
cyB0bw0KPiA+ID4gPiB0cmFuc2l0aW9uIHdpdGggcHJlLWFzc2lnbmVkIGFkZHJlc3Nlcy4NCj4g
PiA+IEkgYW0gb24gdmFjYXRpb24gdW50aWwgdGhlIGVuZCBvZiBuZXh0LXdlZWssIHNvIEkgY2Fu
J3QgZ2l2ZSB5b3UNCj4gPiA+IGFueQ0KPiA+ID4gZ29vZCBhbmFseXNpcyByaWdodCBub3cuDQo+
ID4gVGhhbmtzIGZvciB0YWtpbmcgdGhlIHRpbWUgdG8gcmVzcG9uZC4NCj4gPiANCj4gPiA+IA0K
PiA+ID4gVG8gZG8gdGhlIHRyaWFsIHN0ZXAgZG9lc27igJl0IG1ha2UgbXVjaCBzZW5zZSB0byBt
ZSwgLWl0IHdvdWxkDQo+ID4gPiBvbmx5DQo+ID4gPiBkZWxheSB0aGUgc2V0dXAgdW5uZWNlc3Nh
cmlseSAoYnV0IHdpdGggb25seSAxIHNlY29uZCkuDQo+ID4gPiBDYW4geW91IGNoZWNrIHRoZSBp
bml0aWFsIHZhbHVlIG9mIGFkZHJfdHJpYWxfZW5kIHdoZW4gdGhlcmUgYQ0KPiA+ID4gcHJlLQ0K
PiA+ID4gY29uZmlndXJlZCBhZGRyZXNzPw0KPiA+IEkgaGFkIHRoZSBzYW1lIHRob3VnaHQuIEZv
ciBib3RoIG15IGRldmljZXMgJ2FkZHJfdHJpYWxfZW5kID0gMCcgc28NCj4gPiBJDQo+ID4gdGhp
bmvCoHRpcGNfZGlzY19hZGRyX3RyaWFsX21zZyBzaG91bGQgZW5kIHVwIHdpdGggdHJpYWwgPT0g
ZmFsc2UNCj4gSSBzdWdnZXN0IHlvdSB0cnkgaW5pdGlhbGl6aW5nIGl0IHRvIGppZmZpZXMgYW5k
IHNlZSB3aGF0IGhhcHBlbnMuDQo+IA0KDQpTZXR0aW5nwqBhZGRyX3RyaWFsX2VuZCB0byBqaWZm
aWVzIHNlZW1zIHRvIGRvIHRoZSB0cmljay4gSSdsbCBwcmVwYXJlIGENCnBhdGNoIGFuZCBzZW5k
IGl0IHRocm91Z2gu
