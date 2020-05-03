Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679511C2CDF
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 15:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgECNwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 09:52:50 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:44196 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728645AbgECNwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 09:52:50 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-194-3gMxvSZ4OeeIzTSoj4h9rA-1; Sun, 03 May 2020 14:52:46 +0100
X-MC-Unique: 3gMxvSZ4OeeIzTSoj4h9rA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 3 May 2020 14:52:45 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 3 May 2020 14:52:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Karstens, Nate'" <Nate.Karstens@garmin.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Jeff Layton" <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Changli Gao <xiaosuo@gmail.com>
Subject: RE: [PATCH 1/4] fs: Implement close-on-fork
Thread-Topic: [PATCH 1/4] fs: Implement close-on-fork
Thread-Index: AQHWFuOUNQrmUX2/BU6CQ6OUTp2yNKiCIimAgBEzlACAAxtC0A==
Date:   Sun, 3 May 2020 13:52:45 +0000
Message-ID: <4d00ffe759ec4f87bd7f4e663732838b@AcuMS.aculab.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200420071548.62112-2-nate.karstens@garmin.com>
 <36dce9b4-a0bf-0015-f6bc-1006938545b1@gmail.com>
 <0e884704c25740df8e652d50431facff@garmin.com>
In-Reply-To: <0e884704c25740df8e652d50431facff@garmin.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS2Fyc3RlbnMsIE5hdGUNCj4gU2VudDogMDEgTWF5IDIwMjAgMTU6NDUNCj4gVGhhbmtz
IGZvciB0aGUgc3VnZ2VzdGlvbi4gSSBsb29rZWQgaW50byBpdCBhbmQgbm90aWNlZCB0aGF0IGRv
X2Nsb3NlX29uX2V4ZWMoKSBhcHBlYXJzIHRvIGhhdmUgc29tZQ0KPiBvcHRpbWl6YXRpb25zIGFz
IHdlbGw6DQo+IA0KPiA+IHNldCA9IGZkdC0+Y2xvc2Vfb25fZXhlY1tpXTsNCj4gPiBpZiAoIXNl
dCkNCj4gPiAJY29udGludWU7DQo+IA0KPiBJZiB3ZSBpbnRlcmxlYXZlIHRoZSBjbG9zZS1vbi1l
eGVjIGFuZCBjbG9zZS1vbi1mb3JrIGZsYWdzIHRoZW4gdGhpcyBvcHRpbWl6YXRpb24gd2lsbCBo
YXZlIHRvIGJlDQo+IHJlbW92ZWQuIERvIHlvdSBoYXZlIGEgc2Vuc2Ugb2Ygd2hpY2ggb3B0aW1p
emF0aW9uIHByb3ZpZGVzIHRoZSBtb3N0IGJlbmVmaXQ/DQoNClRoaW5rcy4uLi4NCkEgbW9kZXJh
dGUgcHJvcG9ydGlvbiBvZiBleGVjKCkgd2lsbCBoYXZlIGF0IGxlYXN0IG9uZSBmZCB3aXRoICdj
bG9zZSBvbiBleGVjJyBzZXQuDQpWZXJ5IGZldyBmb3JrKCkgd2lsbCBoYXZlIGFueSBmZCB3aXRo
ICdjbG9zZSBvbiBmb3JrJyBzZXQuDQpUaGUgJ2Nsb3NlIG9uIGZvcmsnIHRhYmxlIHNob3VsZG4n
dCBiZSBjb3BpZWQgdG8gdGhlIGZvcmtlZCBwcm9jZXNzLg0KVGhlICdjbG9zZSBvbiBleGVjJyB0
YWJsZSBpcyBkZWxldGVkIGJ5IGV4ZWMoKS4NCg0KU28uLi4NCk9uIGZvcmsoKSB0YWtlIGEgY29w
eSBhbmQgY2xlYXIgdGhlICdjbG9zZV9vbl9mb3JrJyBiaXRtYXAuDQpGb3IgZXZlcnkgYml0IHNl
dCBsb29rdXAgdGhlIGZkIGFuZCBjbG9zZSBpZiB0aGUgbGl2ZSBiaXQgaXMgc2V0Lg0KU2ltaWxh
cmx5IGV4ZWMoKSBjbGVhcnMgYW5kIGFjdHMgb24gdGhlICdjbG9zZSBvbiBleGVjJyBtYXAuDQoN
CllvdSBzaG91bGQgYmUgYWJsZSB0byB1c2UgdGhlIHNhbWUgJ2Nsb3NlIHRoZSBmZHMgaW4gdGhp
cyBiaXRtYXAnDQpmdW5jdGlvbiBmb3IgYm90aCBjYXNlcy4NCg0KU28gSSB0aGluayB5b3UgbmVl
ZCB0d28gYml0bWFwcy4NCkJ1dCB0aGUgY29kZSBuZWVkcyB0byBkaWZmZXJlbnRpYXRlIGJldHdl
ZW4gcmVxdWVzdHMgdG8gc2V0IGJpdHMNCih3aGljaCBuZWVkIHRvIGFsbG9jYXRlL2V4dGVuZCB0
aGUgYml0bWFwKSBhbmQgb25lcyB0byBjbGVhci9yZWFkDQpiaXRzICh3aGljaCBkbyBub3QpLg0K
DQpZb3UgbWlnaHQgZXZlbiBjb25zaWRlciBwdXR0aW5nIHRoZSAnbGl2ZScgZmxhZyBpbnRvIHRo
ZSBmZCBzdHJ1Y3R1cmUNCmFuZCB1c2luZyB0aGUgYml0bWFwIHZhbHVlIGFzIGEgJ2hpbnQnIC0g
d2hpY2ggbWlnaHQgYmUgaGFzaGVkLg0KDQpBZnRlciBhbGwsIGl0IGlzIGxpa2VseSB0aGF0IHRo
ZSAnY2xvc2Ugb24gZXhlYycgcHJvY2Vzc2luZw0Kd2lsbCBiZSBmYXN0ZXIgb3ZlcmFsbCBpZiBp
dCBqdXN0IGxvb3BzIHRocm91Z2ggdGhlIG9wZW4gZmQgYW5kDQpjaGVja3MgZWFjaCBpbiB0dXJu
IQ0KSSBkb3VidCBtYW55IHByb2Nlc3NlcyBhY3R1YWxseSBleGVjIHdpdGggbW9yZSB0aGFuIGFu
IGhhbmRmdWwNCm9mIG9wZW4gZmlsZXMuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJl
c3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsx
IDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

