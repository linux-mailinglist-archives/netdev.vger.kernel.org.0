Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCD6769E
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbfGLWm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:42:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34416 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbfGLWm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:42:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 940F914E038C2;
        Fri, 12 Jul 2019 15:42:25 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:42:25 -0700 (PDT)
Message-Id: <20190712.154225.26530675805696474.davem@davemloft.net>
To:     lorenzo.bianconi@redhat.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, marek@cloudflare.com
Subject: Re: [PATCH net] net: neigh: fix multiple neigh timer scheduling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190712.154047.1787144778692165503.davem@davemloft.net>
References: <7b254317bcb84a33cdbe8eed96e510324d6eb97c.1562951883.git.lorenzo.bianconi@redhat.com>
        <20190712.154047.1787144778692165503.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:42:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogRnJpLCAxMiBK
dWwgMjAxOSAxNTo0MDo0NyAtMDcwMCAoUERUKQ0KDQo+IEZyb206IExvcmVuem8gQmlhbmNvbmkg
PGxvcmVuem8uYmlhbmNvbmlAcmVkaGF0LmNvbT4NCj4gRGF0ZTogRnJpLCAxMiBKdWwgMjAxOSAx
OToyMjo1MSArMDIwMA0KPiANCj4+IE5laWdoIHRpbWVyIGNhbiBiZSBzY2hlZHVsZWQgbXVsdGlw
bGUgdGltZXMgZnJvbSB1c2Vyc3BhY2UgYWRkaW5nDQo+PiBtdWx0aXBsZSBuZWlnaCBlbnRyaWVz
IGFuZCBmb3JjaW5nIHRoZSBuZWlnaCB0aW1lciBzY2hlZHVsaW5nIHBhc3NpbmcNCj4+IE5URl9V
U0UgaW4gdGhlIG5ldGxpbmsgcmVxdWVzdHMuDQo+PiBUaGlzIHdpbGwgcmVzdWx0IGluIGEgcmVm
Y291bnQgbGVhayBhbmQgaW4gdGhlIGZvbGxvd2luZyBkdW1wIHN0YWNrOg0KPiAgLi4uDQo+PiBG
aXggdGhlIGlzc3VlIHVuc2NoZWR1bGluZyBuZWlnaF90aW1lciBpZiBzZWxlY3RlZCBlbnRyeSBp
cyBpbiAnSU5fVElNRVInDQo+PiByZWNlaXZpbmcgYSBuZXRsaW5rIHJlcXVlc3Qgd2l0aCBOVEZf
VVNFIGZsYWcgc2V0DQo+PiANCj4+IFJlcG9ydGVkLWJ5OiBNYXJlayBNYWprb3dza2kgPG1hcmVr
QGNsb3VkZmxhcmUuY29tPg0KPj4gRml4ZXM6IDBjNWMyZDMwODkwNiAoIm5laWdoOiBBbGxvdyBm
b3IgdXNlciBzcGFjZSB1c2VycyBvZiB0aGUgbmVpZ2hib3VyIHRhYmxlIikNCj4+IFNpZ25lZC1v
ZmYtYnk6IExvcmVuem8gQmlhbmNvbmkgPGxvcmVuem8uYmlhbmNvbmlAcmVkaGF0LmNvbT4NCj4g
DQo+IEFwcGxpZWQgYW5kIHF1ZXVlZCB1cCBmb3IgLXN0YWJsZSwgdGhhbmtzLg0KDQpBY3R1YWxs
eSwgcmV2ZXJ0ZWQsIHlvdSBkaWRuJ3QgdGVzdCB0aGUgYnVpbGQgdGhvcm91Z2hseSBhcyBJbmZp
bmliYW5kDQpmYWlsczoNCg0KZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvYWRkci5jOiBJbiBmdW5j
dGlvbiChZHN0X2ZldGNoX2hhojoNCmRyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2FkZHIuYzozMzc6
MzogZXJyb3I6IHRvbyBmZXcgYXJndW1lbnRzIHRvIGZ1bmN0aW9uIKFuZWlnaF9ldmVudF9zZW5k
og0KICAgbmVpZ2hfZXZlbnRfc2VuZChuLCBOVUxMKTsNCiAgIF5+fn5+fn5+fn5+fn5+fn4NCg==
