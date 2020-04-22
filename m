Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FB71B4B10
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgDVQ4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:56:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:21602 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726337AbgDVQ4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:56:05 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-100-3Htmdqx8M26lXy7JzYFCfA-1; Wed, 22 Apr 2020 17:56:01 +0100
X-MC-Unique: 3Htmdqx8M26lXy7JzYFCfA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 22 Apr 2020 17:55:58 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 22 Apr 2020 17:55:58 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Bernd Petrovitsch' <bernd@petrovitsch.priv.at>,
        "Karstens, Nate" <Nate.Karstens@garmin.com>,
        Matthew Wilcox <willy@infradead.org>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Changli Gao <xiaosuo@gmail.com>
Subject: RE: [PATCH 1/4] fs: Implement close-on-fork
Thread-Topic: [PATCH 1/4] fs: Implement close-on-fork
Thread-Index: AQHWGMN8ssv9Cm82zkePzv5DmgsrOaiFW04w
Date:   Wed, 22 Apr 2020 16:55:58 +0000
Message-ID: <337320db094d4426a621858fa0f6d7fd@AcuMS.aculab.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200420071548.62112-2-nate.karstens@garmin.com>
 <fa6c5c9c7c434f878c94a7c984cd43ba@garmin.com>
 <20200422154356.GU5820@bombadil.infradead.org>
 <6ed7bd08892b4311b70636658321904f@garmin.com>
 <97f05204-a27c-7cc8-429a-edcf6eebaa11@petrovitsch.priv.at>
In-Reply-To: <97f05204-a27c-7cc8-429a-edcf6eebaa11@petrovitsch.priv.at>
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

RnJvbTogQmVybmQgUGV0cm92aXRzY2gNCj4gU2VudDogMjIgQXByaWwgMjAyMCAxNzozMg0KLi4u
DQo+IEFwYXJ0IGZyb20gdGhhdCwgc3lzdGVtKCkgaXMgYSBQSVRBIGV2ZW4gb24NCj4gc2luZ2xl
L25vbi10aHJlYWRlZCBhcHBzLg0KDQpOb3Qgb25seSB0aGF0LCBpdCBpcyBibG9vZHkgZGFuZ2Vy
b3VzIGJlY2F1c2UgKHR5cGljYWxseSkNCnNoZWxsIGlzIGRvaW5nIHBvc3Qgc3Vic3RpdHV0aW9u
IHN5bnRheCBhbmFseXNpcy4NCg0KSWYgeW91IG5lZWQgdG8gcnVuIGFuIGV4dGVybmFsIHByb2Nl
c3MgeW91IG5lZWQgdG8gZ2VuZXJhdGUNCmFuIGFydltdIGFycmF5IGNvbnRhaW5pbmcgdGhlIHBh
cmFtZXRlcnMuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJy
YW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lz
dHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

