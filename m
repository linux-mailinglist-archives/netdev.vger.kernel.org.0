Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AA921BCD5
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgGJSRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:17:12 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:39659 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgGJSRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 14:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594405030; x=1625941030;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joWt3KR9L675nqN6Bcu4u09143359QD2X+bsh9y3Nvo=;
  b=T8juYrnfG5MqFg1rnwSh6p3xhpthKeAzmRRpoplzQ72WFo0MSfuIeGaU
   eh1aunY3qgenLWJA8zsZSbF8T3YuonQfc5I2HSk41HPtfIx3QBzhDExnU
   znZ9uobJHDP/XAy498k1KyYsETnKC1v9PQL1gdHamg9du4PniFGatKnwY
   w=;
IronPort-SDR: UR91taBo6wMI9fsybWeyflevqTm4zIXRLwJEvpFt4kjWyx23bneS910mlSJDHbN9Xyn797xxCe
 mpgDSFyA3dkw==
X-IronPort-AV: E=Sophos;i="5.75,336,1589241600"; 
   d="scan'208";a="50693043"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 10 Jul 2020 18:17:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id 66DC4A223F;
        Fri, 10 Jul 2020 18:17:06 +0000 (UTC)
Received: from EX13D10UWB002.ant.amazon.com (10.43.161.130) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 18:17:05 +0000
Received: from EX13D07UWB001.ant.amazon.com (10.43.161.238) by
 EX13D10UWB002.ant.amazon.com (10.43.161.130) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 18:17:05 +0000
Received: from EX13D07UWB001.ant.amazon.com ([10.43.161.238]) by
 EX13D07UWB001.ant.amazon.com ([10.43.161.238]) with mapi id 15.00.1497.006;
 Fri, 10 Jul 2020 18:17:05 +0000
From:   "Agarwal, Anchal" <anchalag@amazon.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 00/11] Fix PM hibernation in Xen guests
Thread-Topic: [PATCH v2 00/11] Fix PM hibernation in Xen guests
Thread-Index: AQHWUJhxoD1ejJnCNkKYcMl0G0oJ3qkAtheA
Date:   Fri, 10 Jul 2020 18:17:05 +0000
Message-ID: <324020A7-996F-4CF8-A2F4-46957CEA5F0C@amazon.com>
References: <cover.1593665947.git.anchalag@amazon.com>
In-Reply-To: <cover.1593665947.git.anchalag@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.248]
Content-Type: text/plain; charset="utf-8"
Content-ID: <781BFA7803E4E748A2A73C4D4BD0B730@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R2VudGxlIHBpbmcgb24gdGhpcyBzZXJpZXMuIA0KDQotLQ0KQW5jaGFsDQoNCu+7vyAgICBIZWxs
bywNCiAgICBUaGlzIHNlcmllcyBmaXhlcyBQTSBoaWJlcm5hdGlvbiBmb3IgaHZtIGd1ZXN0cyBy
dW5uaW5nIG9uIHhlbiBoeXBlcnZpc29yLg0KICAgIFRoZSBydW5uaW5nIGd1ZXN0IGNvdWxkIG5v
dyBiZSBoaWJlcm5hdGVkIGFuZCByZXN1bWVkIHN1Y2Nlc3NmdWxseSBhdCBhDQogICAgbGF0ZXIg
dGltZS4gVGhlIGZpeGVzIGZvciBQTSBoaWJlcm5hdGlvbiBhcmUgYWRkZWQgdG8gYmxvY2sgYW5k
DQogICAgbmV0d29yayBkZXZpY2UgZHJpdmVycyBpLmUgeGVuLWJsa2Zyb250IGFuZCB4ZW4tbmV0
ZnJvbnQuIEFueSBvdGhlciBkcml2ZXINCiAgICB0aGF0IG5lZWRzIHRvIGFkZCBTNCBzdXBwb3J0
IGlmIG5vdCBhbHJlYWR5LCBjYW4gZm9sbG93IHNhbWUgbWV0aG9kIG9mDQogICAgaW50cm9kdWNp
bmcgZnJlZXplL3RoYXcvcmVzdG9yZSBjYWxsYmFja3MuDQogICAgVGhlIHBhdGNoZXMgaGFkIGJl
ZW4gdGVzdGVkIGFnYWluc3QgdXBzdHJlYW0ga2VybmVsIGFuZCB4ZW40LjExLiBMYXJnZQ0KICAg
IHNjYWxlIHRlc3RpbmcgaXMgYWxzbyBkb25lIG9uIFhlbiBiYXNlZCBBbWF6b24gRUMyIGluc3Rh
bmNlcy4gQWxsIHRoaXMgdGVzdGluZw0KICAgIGludm9sdmVkIHJ1bm5pbmcgbWVtb3J5IGV4aGF1
c3Rpbmcgd29ya2xvYWQgaW4gdGhlIGJhY2tncm91bmQuDQoNCiAgICBEb2luZyBndWVzdCBoaWJl
cm5hdGlvbiBkb2VzIG5vdCBpbnZvbHZlIGFueSBzdXBwb3J0IGZyb20gaHlwZXJ2aXNvciBhbmQN
CiAgICB0aGlzIHdheSBndWVzdCBoYXMgY29tcGxldGUgY29udHJvbCBvdmVyIGl0cyBzdGF0ZS4g
SW5mcmFzdHJ1Y3R1cmUNCiAgICByZXN0cmljdGlvbnMgZm9yIHNhdmluZyB1cCBndWVzdCBzdGF0
ZSBjYW4gYmUgb3ZlcmNvbWUgYnkgZ3Vlc3QgaW5pdGlhdGVkDQogICAgaGliZXJuYXRpb24uDQoN
CiAgICBUaGVzZSBwYXRjaGVzIHdlcmUgc2VuZCBvdXQgYXMgUkZDIGJlZm9yZSBhbmQgYWxsIHRo
ZSBmZWVkYmFjayBoYWQgYmVlbg0KICAgIGluY29ycG9yYXRlZCBpbiB0aGUgcGF0Y2hlcy4gVGhl
IGxhc3QgdjEgY291bGQgYmUgZm91bmQgaGVyZToNCg0KICAgIFt2MV06IGh0dHBzOi8vbGttbC5v
cmcvbGttbC8yMDIwLzUvMTkvMTMxMg0KICAgIEFsbCBjb21tZW50cyBhbmQgZmVlZGJhY2sgZnJv
bSB2MSBoYWQgYmVlbiBpbmNvcnBvcmF0ZWQgaW4gdjIgc2VyaWVzLg0KICAgIEFueSBjb21tZW50
cy9zdWdnZXN0aW9ucyBhcmUgd2VsY29tZQ0KDQogICAgS25vd24gaXNzdWVzOg0KICAgIDEuS0FT
TFIgY2F1c2VzIGludGVybWl0dGVudCBoaWJlcm5hdGlvbiBmYWlsdXJlcy4gVk0gZmFpbHMgdG8g
cmVzdW1lcyBhbmQNCiAgICBoYXMgdG8gYmUgcmVzdGFydGVkLiBJIHdpbGwgaW52ZXN0aWdhdGUg
dGhpcyBpc3N1ZSBzZXBhcmF0ZWx5IGFuZCBzaG91bGRuJ3QNCiAgICBiZSBhIGJsb2NrZXIgZm9y
IHRoaXMgcGF0Y2ggc2VyaWVzLg0KICAgIDIuIER1cmluZyBoaWJlcm5hdGlvbiwgSSBvYnNlcnZl
ZCBzb21ldGltZXMgdGhhdCBmcmVlemluZyBvZiB0YXNrcyBmYWlscyBkdWUNCiAgICB0byBidXN5
IFhGUyB3b3JrcXVldWVpW3hmcy1jaWwveGZzLXN5bmNdLiBUaGlzIGlzIGFsc28gaW50ZXJtaXR0
ZW50IG1heSBiZSAxDQogICAgb3V0IG9mIDIwMCBydW5zIGFuZCBoaWJlcm5hdGlvbiBpcyBhYm9y
dGVkIGluIHRoaXMgY2FzZS4gUmUtdHJ5aW5nIGhpYmVybmF0aW9uDQogICAgbWF5IHdvcmsuIEFs
c28sIHRoaXMgaXMgYSBrbm93biBpc3N1ZSB3aXRoIGhpYmVybmF0aW9uIGFuZCBzb21lDQogICAg
ZmlsZXN5c3RlbXMgbGlrZSBYRlMgaGFzIGJlZW4gZGlzY3Vzc2VkIGJ5IHRoZSBjb21tdW5pdHkg
Zm9yIHllYXJzIHdpdGggbm90IGFuDQogICAgZWZmZWN0dmUgcmVzb2x1dGlvbiBhdCB0aGlzIHBv
aW50Lg0KDQogICAgVGVzdGluZyBIb3cgdG86DQogICAgLS0tLS0tLS0tLS0tLS0tDQogICAgMS4g
U2V0dXAgeGVuIGh5cGVydmlzb3Igb24gYSBwaHlzaWNhbCBtYWNoaW5lWyBJIHVzZWQgVWJ1bnR1
IDE2LjA0ICt1cHN0cmVhbQ0KICAgIHhlbi00LjExXQ0KICAgIDIuIEJyaW5nIHVwIGEgSFZNIGd1
ZXN0IHcvdCBrZXJuZWwgY29tcGlsZWQgd2l0aCBoaWJlcm5hdGlvbiBwYXRjaGVzDQogICAgW0kg
dXNlZCB1YnVudHUxOC4wNCBuZXRib290IGJpb25pYyBpbWFnZXMgYW5kIGFsc28gQW1hem9uIExp
bnV4IG9uLXByZW0gaW1hZ2VzXS4NCiAgICAzLiBDcmVhdGUgYSBzd2FwIGZpbGUgc2l6ZT1SQU0g
c2l6ZQ0KICAgIDQuIFVwZGF0ZSBncnViIHBhcmFtZXRlcnMgYW5kIHJlYm9vdA0KICAgIDUuIFRy
aWdnZXIgcG0taGliZXJuYXRpb24gZnJvbSB3aXRoaW4gdGhlIFZNDQoNCiAgICBFeGFtcGxlOg0K
ICAgIFNldCB1cCBhIGZpbGUtYmFja2VkIHN3YXAgc3BhY2UuIFN3YXAgZmlsZSBzaXplPj1Ub3Rh
bCBtZW1vcnkgb24gdGhlIHN5c3RlbQ0KICAgIHN1ZG8gZGQgaWY9L2Rldi96ZXJvIG9mPS9zd2Fw
IGJzPSQoKCAxMDI0ICogMTAyNCApKSBjb3VudD00MDk2ICMgNDA5Nk1pQg0KICAgIHN1ZG8gY2ht
b2QgNjAwIC9zd2FwDQogICAgc3VkbyBta3N3YXAgL3N3YXANCiAgICBzdWRvIHN3YXBvbiAvc3dh
cA0KDQogICAgVXBkYXRlIHJlc3VtZSBkZXZpY2UvcmVzdW1lIG9mZnNldCBpbiBncnViIGlmIHVz
aW5nIHN3YXAgZmlsZToNCiAgICByZXN1bWU9L2Rldi94dmRhMSByZXN1bWVfb2Zmc2V0PTIwMDcw
NCBub19jb25zb2xlX3N1c3BlbmQ9MQ0KDQogICAgRXhlY3V0ZToNCiAgICAtLS0tLS0tLQ0KICAg
IHN1ZG8gcG0taGliZXJuYXRlDQogICAgT1INCiAgICBlY2hvIGRpc2sgPiAvc3lzL3Bvd2VyL3N0
YXRlICYmIGVjaG8gcmVib290ID4gL3N5cy9wb3dlci9kaXNrDQoNCiAgICBDb21wdXRlIHJlc3Vt
ZSBvZmZzZXQgY29kZToNCiAgICAiDQogICAgIyEvdXNyL2Jpbi9lbnYgcHl0aG9uDQogICAgaW1w
b3J0IHN5cw0KICAgIGltcG9ydCBhcnJheQ0KICAgIGltcG9ydCBmY250bA0KDQogICAgI3N3YXAg
ZmlsZQ0KICAgIGYgPSBvcGVuKHN5cy5hcmd2WzFdLCAncicpDQogICAgYnVmID0gYXJyYXkuYXJy
YXkoJ0wnLCBbMF0pDQoNCiAgICAjRklCTUFQDQogICAgcmV0ID0gZmNudGwuaW9jdGwoZi5maWxl
bm8oKSwgMHgwMSwgYnVmKQ0KICAgIHByaW50IGJ1ZlswXQ0KICAgICINCg0KDQogICAgQWxla3Nl
aSBCZXNvZ29ub3YgKDEpOg0KICAgICAgUE0gLyBoaWJlcm5hdGU6IHVwZGF0ZSB0aGUgcmVzdW1l
IG9mZnNldCBvbiBTTkFQU0hPVF9TRVRfU1dBUF9BUkVBDQoNCiAgICBBbmNoYWwgQWdhcndhbCAo
NCk6DQogICAgICB4ODYveGVuOiBJbnRyb2R1Y2UgbmV3IGZ1bmN0aW9uIHRvIG1hcCBIWVBFUlZJ
U09SX3NoYXJlZF9pbmZvIG9uDQogICAgICAgIFJlc3VtZQ0KICAgICAgeDg2L3hlbjogc2F2ZSBh
bmQgcmVzdG9yZSBzdGVhbCBjbG9jayBkdXJpbmcgUE0gaGliZXJuYXRpb24NCiAgICAgIHhlbjog
SW50cm9kdWNlIHdyYXBwZXIgZm9yIHNhdmUvcmVzdG9yZSBzY2hlZCBjbG9jayBvZmZzZXQNCiAg
ICAgIHhlbjogVXBkYXRlIHNjaGVkIGNsb2NrIG9mZnNldCB0byBhdm9pZCBzeXN0ZW0gaW5zdGFi
aWxpdHkgaW4NCiAgICAgICAgaGliZXJuYXRpb24NCg0KICAgIE11bmVoaXNhIEthbWF0YSAoNSk6
DQogICAgICB4ZW4vbWFuYWdlOiBrZWVwIHRyYWNrIG9mIHRoZSBvbi1nb2luZyBzdXNwZW5kIG1v
ZGUNCiAgICAgIHhlbmJ1czogYWRkIGZyZWV6ZS90aGF3L3Jlc3RvcmUgY2FsbGJhY2tzIHN1cHBv
cnQNCiAgICAgIHg4Ni94ZW46IGFkZCBzeXN0ZW0gY29yZSBzdXNwZW5kIGFuZCByZXN1bWUgY2Fs
bGJhY2tzDQogICAgICB4ZW4tYmxrZnJvbnQ6IGFkZCBjYWxsYmFja3MgZm9yIFBNIHN1c3BlbmQg
YW5kIGhpYmVybmF0aW9uDQogICAgICB4ZW4tbmV0ZnJvbnQ6IGFkZCBjYWxsYmFja3MgZm9yIFBN
IHN1c3BlbmQgYW5kIGhpYmVybmF0aW9uDQoNCiAgICBUaG9tYXMgR2xlaXhuZXIgKDEpOg0KICAg
ICAgZ2VuaXJxOiBTaHV0ZG93biBpcnEgY2hpcHMgaW4gc3VzcGVuZC9yZXN1bWUgZHVyaW5nIGhp
YmVybmF0aW9uDQoNCiAgICAgYXJjaC94ODYveGVuL2VubGlnaHRlbl9odm0uYyAgICAgIHwgICA3
ICsrDQogICAgIGFyY2gveDg2L3hlbi9zdXNwZW5kLmMgICAgICAgICAgICB8ICA1MyArKysrKysr
KysrKysrDQogICAgIGFyY2gveDg2L3hlbi90aW1lLmMgICAgICAgICAgICAgICB8ICAxNSArKyst
DQogICAgIGFyY2gveDg2L3hlbi94ZW4tb3BzLmggICAgICAgICAgICB8ICAgMyArDQogICAgIGRy
aXZlcnMvYmxvY2sveGVuLWJsa2Zyb250LmMgICAgICB8IDEyMiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKy0NCiAgICAgZHJpdmVycy9uZXQveGVuLW5ldGZyb250LmMgICAgICAgIHwgIDk4
ICsrKysrKysrKysrKysrKysrKysrKysrLQ0KICAgICBkcml2ZXJzL3hlbi9ldmVudHMvZXZlbnRz
X2Jhc2UuYyAgfCAgIDEgKw0KICAgICBkcml2ZXJzL3hlbi9tYW5hZ2UuYyAgICAgICAgICAgICAg
fCAgNjAgKysrKysrKysrKysrKysrDQogICAgIGRyaXZlcnMveGVuL3hlbmJ1cy94ZW5idXNfcHJv
YmUuYyB8ICA5NiArKysrKysrKysrKysrKysrKysrLS0tLQ0KICAgICBpbmNsdWRlL2xpbnV4L2ly
cS5oICAgICAgICAgICAgICAgfCAgIDIgKw0KICAgICBpbmNsdWRlL3hlbi94ZW4tb3BzLmggICAg
ICAgICAgICAgfCAgIDMgKw0KICAgICBpbmNsdWRlL3hlbi94ZW5idXMuaCAgICAgICAgICAgICAg
fCAgIDMgKw0KICAgICBrZXJuZWwvaXJxL2NoaXAuYyAgICAgICAgICAgICAgICAgfCAgIDIgKy0N
CiAgICAga2VybmVsL2lycS9pbnRlcm5hbHMuaCAgICAgICAgICAgIHwgICAxICsNCiAgICAga2Vy
bmVsL2lycS9wbS5jICAgICAgICAgICAgICAgICAgIHwgIDMxICsrKysrLS0tDQogICAgIGtlcm5l
bC9wb3dlci91c2VyLmMgICAgICAgICAgICAgICB8ICAgNiArLQ0KICAgICAxNiBmaWxlcyBjaGFu
Z2VkLCA0NzAgaW5zZXJ0aW9ucygrKSwgMzMgZGVsZXRpb25zKC0pDQoNCiAgICAtLSANCiAgICAy
LjIwLjENCg0KDQo=
