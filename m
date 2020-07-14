Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C943E21EF26
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 13:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgGNLUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 07:20:52 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:36541 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgGNLUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 07:20:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594725649; x=1626261649;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=BqrgoE+puvxQng9cI5qM40hcfRyznkqAUBKrROFub8g=;
  b=RfwOKrspsMrYz8zMQ+UOmFFA5juF3gVsldzyg29Q5hGgtIsL2Jv8vz3V
   SvGow9VeJV3C08BMJqW9GK2FXjowYx/KHkH1c7yU/tL3KRT0TvAGn4GPy
   dJ4HCNfK2VQn3Y6Dk39TY6yVk8GpyyF8WCXR1scfCxCeGDhQIGAJWDVQ8
   U=;
IronPort-SDR: Nkec061H2qFSYgB7LLWfkx0Sbx/hNxRyVaBphX7EKcpGa+BJyJO3a8dUJxeoZOZmsBRF7w5lTO
 9h05RgNnjSAw==
X-IronPort-AV: E=Sophos;i="5.75,350,1589241600"; 
   d="scan'208";a="41722551"
Subject: RE: [PATCH V1 net-next 6/8] net: ena: enable support of rss hash key and
 function changes
Thread-Topic: [PATCH V1 net-next 6/8] net: ena: enable support of rss hash key and
 function changes
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 14 Jul 2020 11:20:48 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 15C24A0767;
        Tue, 14 Jul 2020 11:20:47 +0000 (UTC)
Received: from EX13D04EUA001.ant.amazon.com (10.43.165.136) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 14 Jul 2020 11:20:46 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D04EUA001.ant.amazon.com (10.43.165.136) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 14 Jul 2020 11:20:45 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1497.006;
 Tue, 14 Jul 2020 11:20:45 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     "Machulsky, Zorik" <zorik@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
Thread-Index: AQHWViPyyJqC3qgbbECBf8QdYKAAYKj/sUCAgAGKHACAAAMzgIAAB3oAgAWuarA=
Date:   Tue, 14 Jul 2020 11:20:27 +0000
Deferred-Delivery: Tue, 14 Jul 2020 11:20:21 +0000
Message-ID: <c5274c7769ac48bea39d63063728e695@EX13D22EUA004.ant.amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
 <1594321503-12256-7-git-send-email-akiyano@amazon.com>
 <20200709132311.63720a70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <53596F13-16F7-4C82-A5BC-5F5DB22C36A4@amazon.com>
 <20200710130513.057a2854@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <C1F3BC8C-AFAD-4AB4-8329-A48F4AD0E60B@amazon.com>
In-Reply-To: <C1F3BC8C-AFAD-4AB4-8329-A48F4AD0E60B@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.8]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFjaHVsc2t5LCBab3Jp
ayA8em9yaWtAYW1hem9uLmNvbT4NCj4gU2VudDogRnJpZGF5LCBKdWx5IDEwLCAyMDIwIDExOjMy
IFBNDQo+IFRvOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBDYzogS2l5YW5v
dnNraSwgQXJ0aHVyIDxha2l5YW5vQGFtYXpvbi5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0K
PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBXb29kaG91c2UsIERhdmlkIDxkd213QGFtYXpvbi5j
by51az47DQo+IE1hdHVzaGV2c2t5LCBBbGV4YW5kZXIgPG1hdHVhQGFtYXpvbi5jb20+OyBCc2hh
cmEsIFNhZWVkDQo+IDxzYWVlZGJAYW1hem9uLmNvbT47IFdpbHNvbiwgTWF0dCA8bXN3QGFtYXpv
bi5jb20+OyBMaWd1b3JpLCBBbnRob255DQo+IDxhbGlndW9yaUBhbWF6b24uY29tPjsgQnNoYXJh
LCBOYWZlYSA8bmFmZWFAYW1hem9uLmNvbT47IFR6YWxpaywgR3V5DQo+IDxndHphbGlrQGFtYXpv
bi5jb20+OyBCZWxnYXphbCwgTmV0YW5lbCA8bmV0YW5lbEBhbWF6b24uY29tPjsgU2FpZGksIEFs
aQ0KPiA8YWxpc2FpZGlAYW1hem9uLmNvbT47IEhlcnJlbnNjaG1pZHQsIEJlbmphbWluIDxiZW5o
QGFtYXpvbi5jb20+Ow0KPiBEYWdhbiwgTm9hbSA8bmRhZ2FuQGFtYXpvbi5jb20+OyBBZ3Jvc2tp
biwgU2hheQ0KPiA8c2hheWFnckBhbWF6b24uY29tPjsgSnVicmFuLCBTYW1paCA8c2FtZWVoakBh
bWF6b24uY29tPg0KPiBTdWJqZWN0OiBSZTogW0VYVEVSTkFMXSBbUEFUQ0ggVjEgbmV0LW5leHQg
Ni84XSBuZXQ6IGVuYTogZW5hYmxlIHN1cHBvcnQgb2YgcnNzDQo+IGhhc2gga2V5IGFuZCBmdW5j
dGlvbiBjaGFuZ2VzDQo+IA0KPiANCj4gDQo+IO+7v09uIDcvMTAvMjAsIDE6MDUgUE0sICJKYWt1
YiBLaWNpbnNraSIgPGt1YmFAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiAgICAgT24gRnJpLCAx
MCBKdWwgMjAyMCAxOTo1Mzo0NiArMDAwMCBNYWNodWxza3ksIFpvcmlrIHdyb3RlOg0KPiAgICAg
PiBPbiA3LzkvMjAsIDE6MjQgUE0sICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVsLm9yZz4g
d3JvdGU6DQo+ICAgICA+DQo+ICAgICA+ICAgICBPbiBUaHUsIDkgSnVsIDIwMjAgMjI6MDU6MDEg
KzAzMDAgYWtpeWFub0BhbWF6b24uY29tIHdyb3RlOg0KPiAgICAgPiAgICAgPiBGcm9tOiBBcnRo
dXIgS2l5YW5vdnNraSA8YWtpeWFub0BhbWF6b24uY29tPg0KPiAgICAgPiAgICAgPg0KPiAgICAg
PiAgICAgPiBBZGQgdGhlIHJzc19jb25maWd1cmFibGVfZnVuY3Rpb25fa2V5IGJpdCB0byBkcml2
ZXJfc3VwcG9ydGVkX2ZlYXR1cmUuDQo+ICAgICA+ICAgICA+DQo+ICAgICA+ICAgICA+IFRoaXMg
Yml0IHRlbGxzIHRoZSBkZXZpY2UgdGhhdCB0aGUgZHJpdmVyIGluIHF1ZXN0aW9uIHN1cHBvcnRz
IHRoZQ0KPiAgICAgPiAgICAgPiByZXRyaWV2aW5nIGFuZCB1cGRhdGluZyBvZiBSU1MgZnVuY3Rp
b24gYW5kIGhhc2gga2V5LCBhbmQgdGhlcmVmb3JlDQo+ICAgICA+ICAgICA+IHRoZSBkZXZpY2Ug
c2hvdWxkIGFsbG93IFJTUyBmdW5jdGlvbiBhbmQga2V5IG1hbmlwdWxhdGlvbi4NCj4gICAgID4g
ICAgID4NCj4gICAgID4gICAgID4gU2lnbmVkLW9mZi1ieTogQXJ0aHVyIEtpeWFub3Zza2kgPGFr
aXlhbm9AYW1hem9uLmNvbT4NCj4gICAgID4NCj4gICAgID4gICAgIElzIHRoaXMgYSBmaXggb2Yg
dGhlIHByZXZpb3VzIHBhdGNoZXM/IGxvb2tzIHN0cmFuZ2UgdG8ganVzdCBzdGFydA0KPiAgICAg
PiAgICAgYWR2ZXJ0aXNpbmcgYSBmZWF0dXJlIGJpdCBidXQgbm90IGFkZCBhbnkgY29kZS4uDQo+
ICAgICA+DQo+ICAgICA+IFRoZSBwcmV2aW91cyByZWxhdGVkIGNvbW1pdHMgd2VyZSBtZXJnZWQg
YWxyZWFkeToNCj4gICAgID4gMGFmM2M0ZTJlYWI4IG5ldDogZW5hOiBjaGFuZ2VzIHRvIFJTUyBo
YXNoIGtleSBhbGxvY2F0aW9uDQo+ICAgICA+IGMxYmQxN2U1MWM3MSBuZXQ6IGVuYTogY2hhbmdl
IGRlZmF1bHQgUlNTIGhhc2ggZnVuY3Rpb24gdG8gVG9lcGxpdHoNCj4gICAgID4gZjY2YzJlYTNi
MThhIG5ldDogZW5hOiBhbGxvdyBzZXR0aW5nIHRoZSBoYXNoIGZ1bmN0aW9uIHdpdGhvdXQgY2hh
bmdpbmcNCj4gdGhlIGtleQ0KPiAgICAgPiBlOWExZGUzNzhkZDQgbmV0OiBlbmE6IGZpeCBlcnJv
ciByZXR1cm5pbmcgaW4gZW5hX2NvbV9nZXRfaGFzaF9mdW5jdGlvbigpDQo+ICAgICA+IDgwZjg0
NDNmY2RhYSBuZXQ6IGVuYTogYXZvaWQgdW5uZWNlc3NhcnkgYWRtaW4gY29tbWFuZCB3aGVuIFJT
Uw0KPiBmdW5jdGlvbiBzZXQgZmFpbHMNCj4gICAgID4gNmE0ZjdkYzgyZDFlIG5ldDogZW5hOiBy
c3M6IGRvIG5vdCBhbGxvY2F0ZSBrZXkgd2hlbiBub3Qgc3VwcG9ydGVkDQo+ICAgICA+IDBkMWMz
ZGU3YjhjNyBuZXQ6IGVuYTogZml4IGluY29ycmVjdCBkZWZhdWx0IFJTUyBrZXkNCj4gDQo+ICAg
ICBUaGVzZSBjb21taXRzIGFyZSBpbiBuZXQuDQo+IA0KPiAgICAgPiBUaGlzIGNvbW1pdCB3YXMg
bm90IGluY2x1ZGVkIGJ5IG1pc3Rha2UsIHNvIHdlIGFyZSBhZGRpbmcgaXQgbm93Lg0KPiANCj4g
ICAgIFlvdSdyZSBhZGRpbmcgaXQgdG8gbmV0LW5leHQuDQo+IFRoaXMgY29tbWl0IGFjdHVhbGx5
IGVuYWJsZXMgYSBmZWF0dXJlIGFmdGVyIGl0IHdhcyBmaXhlZCBieSBwcmV2aW91cyBjb21taXRz
LA0KPiB0aGVyZWZvcmUgd2UgdGhvdWdodCB0aGF0IG5ldC1uZXh0IGNvdWxkIGJlIGEgcmlnaHQg
cGxhY2UuIEJ1dCBpZiB5b3UgdGhpbmsgaXQNCj4gc2hvdWxkIGdvIHRvIG5ldCwgd2UnbGwgZ28g
YWhlYWQgYW5kIHJlc3VibWl0IGl0IHRoZXJlLiBUaGFua3MgZm9yIHlvdXINCj4gY29tbWVudHMu
DQoNCkpha3ViLCANCknigJl2ZSByZW1vdmVkIHRoZSBwYXRjaCBmcm9tIHYyIGJ1dCBpdCBzZWVt
cyB0byBtZSB0aGVyZSB3YXMgc29tZSBtaXNjb21tdW5pY2F0aW9uIGFuZCBJTU8gdGhlIGNvcnJl
Y3QgcGxhY2UgZm9yIHRoZSBwYXRjaCBzaG91bGQgYmUgbmV0LW5leHQuIA0KVGhpcyBmZWF0dXJl
IHdhcyBhY3R1YWxseSB0dXJuZWQgb2ZmIHVudGlsIG5vdywgYW5kIHRoaXMgcGF0Y2ggdHVybnMg
aXQgb24uIEl0IGlzIG5vdCBhIGJ1ZyBmaXgsIGl0IGlzIGFjdHVhbGx5IGEgZmVhdHVyZS4gRG8g
eW91IGhhdmUgYW4gb2JqZWN0aW9uIHRvIG1lIHJldHVybmluZyB0aGlzIHBhdGNoICh3aXRoIHRo
aXMgZXhwbGFuYXRpb24gaW4gdGhlIGNvbW1pdCBtZXNzYWdlKSB0byB0aGlzIHBhdGNoc2V0cyBW
Mz8NClNvcnJ5IGZvciB0aGUgY29uZnVzaW9uDQpUaGFua3MhDQpBcnRodXINCg0KDQo=
