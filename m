Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D55A284BBF
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 14:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgJFMjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 08:39:54 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:13857 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgJFMjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 08:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1601987993; x=1633523993;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=cWScEf2H0N07zMQ3DijjChI3ei1wf5ykE77iwjqAp9c=;
  b=WxG4j5KuEaloLswczX2aXeQJ4rGJxrA/L0ExJg3Ik0zPvuuIe/7aZutE
   XtYBfZQXKKtN0SQ1y2UaksGqoPyDCCjBL7oUOHga8wSeLeHJeEzCh0iVA
   8qvEt5cqRe5I0l0DOaO9trl7fkinlk8Wjpt4O1Uty2ewJWuPZMlh6iaJW
   Q=;
X-IronPort-AV: E=Sophos;i="5.77,343,1596499200"; 
   d="scan'208";a="81962596"
Subject: RE: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer support
Thread-Topic: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer support
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 06 Oct 2020 12:39:49 +0000
Received: from EX13D28EUB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id D8C0DA1823;
        Tue,  6 Oct 2020 12:39:47 +0000 (UTC)
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D28EUB002.ant.amazon.com (10.43.166.97) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 6 Oct 2020 12:39:46 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1497.006;
 Tue, 6 Oct 2020 12:39:46 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "echaudro@redhat.com" <echaudro@redhat.com>
Thread-Index: AQHWmMpYHdcS8+W5uEiUVfwUzD8TrKmEbwiAgABKxoCABc+m8A==
Date:   Tue, 6 Oct 2020 12:39:36 +0000
Deferred-Delivery: Tue, 6 Oct 2020 12:39:29 +0000
Message-ID: <ba4b2f1ef9ea434292e14f03da6bf908@EX13D11EUB003.ant.amazon.com>
References: <cover.1601648734.git.lorenzo@kernel.org>
 <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
 <5c22ee38-e2c3-0724-5033-603d19c4169f@iogearbox.net>
In-Reply-To: <5c22ee38-e2c3-0724-5033-603d19c4169f@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.68]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuaWVsIEJvcmttYW5u
IDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4NCj4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDIsIDIwMjAg
MTA6NTMgUE0NCj4gVG86IEpvaG4gRmFzdGFiZW5kIDxqb2huLmZhc3RhYmVuZEBnbWFpbC5jb20+
OyBMb3JlbnpvIEJpYW5jb25pDQo+IDxsb3JlbnpvQGtlcm5lbC5vcmc+OyBicGZAdmdlci5rZXJu
ZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0
OyBrdWJhQGtlcm5lbC5vcmc7IGFzdEBrZXJuZWwub3JnOyBBZ3Jvc2tpbiwNCj4gU2hheSA8c2hh
eWFnckBhbWF6b24uY29tPjsgSnVicmFuLCBTYW1paCA8c2FtZWVoakBhbWF6b24uY29tPjsNCj4g
ZHNhaGVybkBrZXJuZWwub3JnOyBicm91ZXJAcmVkaGF0LmNvbTsgbG9yZW56by5iaWFuY29uaUBy
ZWRoYXQuY29tOw0KPiBlY2hhdWRyb0ByZWRoYXQuY29tDQo+IFN1YmplY3Q6IFJFOiBbRVhURVJO
QUxdIFtQQVRDSCB2NCBicGYtbmV4dCAwMC8xM10gbXZuZXRhOiBpbnRyb2R1Y2UgWERQDQo+IG11
bHRpLWJ1ZmZlciBzdXBwb3J0DQo+IA0KPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQg
ZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljaw0KPiBsaW5rcyBv
ciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQg
a25vdyB0aGUNCj4gY29udGVudCBpcyBzYWZlLg0KPiANCj4gDQo+IA0KPiBPbiAxMC8yLzIwIDU6
MjUgUE0sIEpvaG4gRmFzdGFiZW5kIHdyb3RlOg0KPiA+IExvcmVuem8gQmlhbmNvbmkgd3JvdGU6
DQo+ID4+IFRoaXMgc2VyaWVzIGludHJvZHVjZSBYRFAgbXVsdGktYnVmZmVyIHN1cHBvcnQuIFRo
ZSBtdm5ldGEgZHJpdmVyIGlzDQo+ID4+IHRoZSBmaXJzdCB0byBzdXBwb3J0IHRoZXNlIG5ldyAi
bm9uLWxpbmVhciIgeGRwX3tidWZmLGZyYW1lfS4NCj4gPj4gUmV2aWV3ZXJzIHBsZWFzZSBmb2N1
cyBvbiBob3cgdGhlc2UgbmV3IHR5cGVzIG9mIHhkcF97YnVmZixmcmFtZX0NCj4gPj4gcGFja2V0
cyB0cmF2ZXJzZSB0aGUgZGlmZmVyZW50IGxheWVycyBhbmQgdGhlIGxheW91dCBkZXNpZ24uIEl0
IGlzIG9uDQo+ID4+IHB1cnBvc2UgdGhhdCBCUEYtaGVscGVycyBhcmUga2VwdCBzaW1wbGUsIGFz
IHdlIGRvbid0IHdhbnQgdG8gZXhwb3NlDQo+ID4+IHRoZSBpbnRlcm5hbCBsYXlvdXQgdG8gYWxs
b3cgbGF0ZXIgY2hhbmdlcy4NCj4gPj4NCj4gPj4gRm9yIG5vdywgdG8ga2VlcCB0aGUgZGVzaWdu
IHNpbXBsZSBhbmQgdG8gbWFpbnRhaW4gcGVyZm9ybWFuY2UsIHRoZQ0KPiA+PiBYRFAgQlBGLXBy
b2cgKHN0aWxsKSBvbmx5IGhhdmUgYWNjZXNzIHRvIHRoZSBmaXJzdC1idWZmZXIuIEl0IGlzIGxl
ZnQNCj4gPj4gZm9yIGxhdGVyIChhbm90aGVyIHBhdGNoc2V0KSB0byBhZGQgcGF5bG9hZCBhY2Nl
c3MgYWNyb3NzIG11bHRpcGxlIGJ1ZmZlcnMuDQo+ID4+IFRoaXMgcGF0Y2hzZXQgc2hvdWxkIHN0
aWxsIGFsbG93IGZvciB0aGVzZSBmdXR1cmUgZXh0ZW5zaW9ucy4gVGhlDQo+ID4+IGdvYWwgaXMg
dG8gbGlmdCB0aGUgWERQIE1UVSByZXN0cmljdGlvbiB0aGF0IGNvbWVzIHdpdGggWERQLCBidXQN
Cj4gPj4gbWFpbnRhaW4gc2FtZSBwZXJmb3JtYW5jZSBhcyBiZWZvcmUuDQo+ID4+DQo+ID4+IFRo
ZSBtYWluIGlkZWEgZm9yIHRoZSBuZXcgbXVsdGktYnVmZmVyIGxheW91dCBpcyB0byByZXVzZSB0
aGUgc2FtZQ0KPiA+PiBsYXlvdXQgdXNlZCBmb3Igbm9uLWxpbmVhciBTS0IuIFRoaXMgcmVseSBv
biB0aGUgInNrYl9zaGFyZWRfaW5mbyINCj4gPj4gc3RydWN0IGF0IHRoZSBlbmQgb2YgdGhlIGZp
cnN0IGJ1ZmZlciB0byBsaW5rIHRvZ2V0aGVyIHN1YnNlcXVlbnQNCj4gPj4gYnVmZmVycy4gS2Vl
cGluZyB0aGUgbGF5b3V0IGNvbXBhdGlibGUgd2l0aCBTS0JzIGlzIGFsc28gZG9uZSB0byBlYXNl
DQo+ID4+IGFuZCBzcGVlZHVwIGNyZWF0aW5nIGFuIFNLQiBmcm9tIGFuIHhkcF97YnVmZixmcmFt
ZX0uIENvbnZlcnRpbmcNCj4gPj4geGRwX2ZyYW1lIHRvIFNLQiBhbmQgZGVsaXZlciBpdCB0byB0
aGUgbmV0d29yayBzdGFjayBpcyBzaG93biBpbg0KPiA+PiBjcHVtYXAgY29kZSAocGF0Y2ggMTMv
MTMpLg0KPiA+DQo+ID4gVXNpbmcgdGhlIGVuZCBvZiB0aGUgYnVmZmVyIGZvciB0aGUgc2tiX3No
YXJlZF9pbmZvIHN0cnVjdCBpcyBnb2luZyB0bw0KPiA+IGJlY29tZSBkcml2ZXIgQVBJIHNvIHVu
d2luZGluZyBpdCBpZiBpdCBwcm92ZXMgdG8gYmUgYSBwZXJmb3JtYW5jZQ0KPiA+IGlzc3VlIGlz
IGdvaW5nIHRvIGJlIHVnbHkuIFNvIHNhbWUgcXVlc3Rpb24gYXMgYmVmb3JlLCBmb3IgdGhlIHVz
ZQ0KPiA+IGNhc2Ugd2hlcmUgd2UgcmVjZWl2ZSBwYWNrZXQgYW5kIGRvIFhEUF9UWCB3aXRoIGl0
IGhvdyBkbyB3ZSBhdm9pZA0KPiA+IGNhY2hlIG1pc3Mgb3ZlcmhlYWQ/IFRoaXMgaXMgbm90IGp1
c3QgYSBoeXBvdGhldGljYWwgdXNlIGNhc2UsIHRoZQ0KPiA+IEZhY2Vib29rIGxvYWQgYmFsYW5j
ZXIgaXMgZG9pbmcgdGhpcyBhcyB3ZWxsIGFzIENpbGl1bSBhbmQgYWxsb3dpbmcNCj4gPiB0aGlz
IHdpdGggbXVsdGktYnVmZmVyIHBhY2tldHMgPjE1MDBCIHdvdWxkIGJlIHVzZWZ1bC4NCj4gWy4u
Ll0NCj4gDQo+IEZ1bGx5IGFncmVlLiBNeSBvdGhlciBxdWVzdGlvbiB3b3VsZCBiZSBpZiBzb21l
b25lIGVsc2UgcmlnaHQgbm93IGlzIGluIHRoZQ0KPiBwcm9jZXNzIG9mIGltcGxlbWVudGluZyB0
aGlzIHNjaGVtZSBmb3IgYSA0MEcrIE5JQz8gTXkgY29uY2VybiBpcyB0aGUNCj4gbnVtYmVycyBi
ZWxvdyBhcmUgcmF0aGVyIG9uIHRoZSBsb3dlciBlbmQgb2YgdGhlIHNwZWN0cnVtLCBzbyBJIHdv
dWxkIGxpa2UNCj4gdG8gc2VlIGEgY29tcGFyaXNvbiBvZiBYRFAgYXMtaXMgdG9kYXkgdnMgWERQ
IG11bHRpLWJ1ZmYgb24gYSBoaWdoZXIgZW5kIE5JQw0KPiBzbyB0aGF0IHdlIGhhdmUgYSBwaWN0
dXJlIGhvdyB3ZWxsIHRoZSBjdXJyZW50IGRlc2lnbmVkIHNjaGVtZSB3b3JrcyB0aGVyZQ0KPiBh
bmQgaW50byB3aGljaCBwZXJmb3JtYW5jZSBpc3N1ZSB3ZSdsbCBydW4gZS5nLg0KPiB1bmRlciB0
eXBpY2FsIFhEUCBMNCBsb2FkIGJhbGFuY2VyIHNjZW5hcmlvIHdpdGggWERQX1RYLiBJIHRoaW5r
IHRoaXMgd291bGQNCj4gYmUgY3J1Y2lhbCBiZWZvcmUgdGhlIGRyaXZlciBBUEkgYmVjb21lcyAn
c29ydCBvZicgc2V0IGluIHN0b25lIHdoZXJlIG90aGVycw0KPiBzdGFydCB0byBhZGFwdGluZyBp
dCBhbmQgY2hhbmdpbmcgZGVzaWduIGJlY29tZXMgcGFpbmZ1bC4gRG8gZW5hIGZvbGtzIGhhdmUN
Cj4gYW4gaW1wbGVtZW50YXRpb24gcmVhZHkgYXMgd2VsbD8gQW5kIHdoYXQgYWJvdXQgdmlydGlv
X25ldCwgZm9yIGV4YW1wbGUsDQo+IGFueW9uZSBjb21taXR0aW5nIHRoZXJlIHRvbz8gVHlwaWNh
bGx5IGZvciBzdWNoIGZlYXR1cmVzIHRvIGxhbmQgaXMgdG8gcmVxdWlyZQ0KPiBhdCBsZWFzdCAy
IGRyaXZlcnMgaW1wbGVtZW50aW5nIGl0Lg0KPg0KDQpXZSAoRU5BKSBleHBlY3QgdG8gaGF2ZSBY
RFAgTUIgaW1wbGVtZW50YXRpb24gd2l0aCBwZXJmb3JtYW5jZSByZXN1bHRzIGluIGFyb3VuZCA0
LTYgd2Vla3MuDQoNCj4gPj4gVHlwaWNhbCB1c2UgY2FzZXMgZm9yIHRoaXMgc2VyaWVzIGFyZToN
Cj4gPj4gLSBKdW1iby1mcmFtZXMNCj4gPj4gLSBQYWNrZXQgaGVhZGVyIHNwbGl0IChwbGVhc2Ug
c2VlIEdvb2dsZSAgIHMgdXNlLWNhc2UgQCBOZXREZXZDb25mDQo+ID4+IDB4MTQsIFswXSkNCj4g
Pj4gLSBUU08NCj4gPj4NCj4gPj4gTW9yZSBpbmZvIGFib3V0IHRoZSBtYWluIGlkZWEgYmVoaW5k
IHRoaXMgYXBwcm9hY2ggY2FuIGJlIGZvdW5kIGhlcmUNCj4gWzFdWzJdLg0KPiA+Pg0KPiA+PiBX
ZSBjYXJyaWVkIG91dCBzb21lIHRocm91Z2hwdXQgdGVzdHMgaW4gYSBzdGFuZGFyZCBsaW5lYXIg
ZnJhbWUNCj4gPj4gc2NlbmFyaW8gaW4gb3JkZXIgdG8gdmVyaWZ5IHdlIGRpZCBub3QgaW50cm9k
dWNlZCBhbnkgcGVyZm9ybWFuY2UNCj4gPj4gcmVncmVzc2lvbiBhZGRpbmcgeGRwIG11bHRpLWJ1
ZmYgc3VwcG9ydCB0byBtdm5ldGE6DQo+ID4+DQo+ID4+IG9mZmVyZWQgbG9hZCBpcyB+IDEwMDBL
cHBzLCBwYWNrZXQgc2l6ZSBpcyA2NEIsIG12bmV0YSBkZXNjcmlwdG9yDQo+ID4+IHNpemUgaXMg
b25lIFBBR0UNCj4gPj4NCj4gPj4gY29tbWl0OiA4Nzk0NTZiZWRiZTUgKCJuZXQ6IG12bmV0YTog
YXZvaWQgcG9zc2libGUgY2FjaGUgbWlzc2VzIGluDQo+IG12bmV0YV9yeF9zd2JtIikNCj4gPj4g
LSB4ZHAtcGFzczogICAgICB+MTYyS3Bwcw0KPiA+PiAtIHhkcC1kcm9wOiAgICAgIH43MDFLcHBz
DQo+ID4+IC0geGRwLXR4OiAgICAgICAgfjE4NUtwcHMNCj4gPj4gLSB4ZHAtcmVkaXJlY3Q6ICB+
MjAyS3Bwcw0KPiA+Pg0KPiA+PiBtdm5ldGEgeGRwIG11bHRpLWJ1ZmY6DQo+ID4+IC0geGRwLXBh
c3M6ICAgICAgfjE2M0twcHMNCj4gPj4gLSB4ZHAtZHJvcDogICAgICB+NzM5S3Bwcw0KPiA+PiAt
IHhkcC10eDogICAgICAgIH4xODJLcHBzDQo+ID4+IC0geGRwLXJlZGlyZWN0OiAgfjIwMktwcHMN
Cj4gWy4uLl0NCg==
