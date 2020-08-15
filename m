Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4B824556F
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 04:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgHPCKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 22:10:36 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3479 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726926AbgHPCKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 22:10:35 -0400
Received: from dggeme701-chm.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id D1DEFC4F7998B15228CD;
        Sat, 15 Aug 2020 10:09:06 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme701-chm.china.huawei.com (10.1.199.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 15 Aug 2020 10:09:06 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Sat, 15 Aug 2020 10:09:06 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "martin.varghese@nokia.com" <martin.varghese@nokia.com>,
        "pshelar@ovn.org" <pshelar@ovn.org>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        "Yadu Kishore" <kyk.segfault@gmail.com>,
        "sowmini.varadhan@oracle.com" <sowmini.varadhan@oracle.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: add missing skb_uarg refcount increment in
 pskb_carve_inside_header()
Thread-Topic: [PATCH] net: add missing skb_uarg refcount increment in
 pskb_carve_inside_header()
Thread-Index: AdZyqG0kRQ90pG27RJqKlae5o5FvkA==
Date:   Sat, 15 Aug 2020 02:09:06 +0000
Message-ID: <ec28bf85a54c42a7ad03fd33a542023a@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.252]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4gd3JvdGU6
DQo+T24gRnJpLCBBdWcgMTQsIDIwMjAgYXQgOToyMCBBTSBsaW5taWFvaGUgPGxpbm1pYW9oZUBo
dWF3ZWkuY29tPiB3cm90ZToNCj4+DQo+PiBXaWxsZW0gZGUgQnJ1aWpuIDx3aWxsZW1kZWJydWlq
bi5rZXJuZWxAZ21haWwuY29tPiB3cm90ZToNCj4+ID5PbiBUaHUsIEF1ZyAxMywgMjAyMCBhdCAy
OjE2IFBNIE1pYW9oZSBMaW4gPGxpbm1pYW9oZUBodWF3ZWkuY29tPiB3cm90ZToNCj4+ID4+DQo+
PiA+PiBJZiB0aGUgc2tiIGlzIHpjb3BpZWQsIHdlIHNob3VsZCBpbmNyZWFzZSB0aGUgc2tiX3Vh
cmcgcmVmY291bnQgDQo+PiA+PiBiZWZvcmUgd2UgaW52b2x2ZSBza2JfcmVsZWFzZV9kYXRhKCku
IFNlZSBwc2tiX2V4cGFuZF9oZWFkKCkgYXMgYSByZWZlcmVuY2UuDQo+PiA+DQo+PiA+RGlkIHlv
dSBtYW5hZ2UgdG8gb2JzZXJ2ZSBhIGJ1ZyB0aHJvdWdoIHRoaXMgZGF0YXBhdGggaW4gcHJhY3Rp
Y2U/DQo+PiA+DQo+PiA+cHNrYl9jYXJ2ZV9pbnNpZGVfaGVhZGVyIGlzIGNhbGxlZA0KPj4gPiAg
ZnJvbSBwc2tiX2NhcnZlDQo+PiA+ICAgIGZyb20gcHNrYl9leHRyYWN0DQo+PiA+ICAgICAgZnJv
bSByZHNfdGNwX2RhdGFfcmVjdg0KPj4gPg0KPj4gPlRoYXQgcmVjZWl2ZSBwYXRoIHNob3VsZCBu
b3Qgc2VlIGFueSBwYWNrZXRzIHdpdGggemVyb2NvcHkgc3RhdGUgYXNzb2NpYXRlZC4NCj4+ID4N
Cj4+DQo+PiBUaGlzIHdvcmtzIGZpbmUgeWV0IGFzIGl0cyBjYWxsZXIgaXMgbGltaXRlZC4gQnV0
IHdlIHNob3VsZCB0YWtlIGNhcmUgb2YgdGhlIHNrYl91YXJnIHJlZmNvdW50IGZvciBmdXR1cmUg
dXNlLg0KPg0KPklmIGEgbmV3IGFwcGxpY2F0aW9uIG9mIHRoaXMgaW50ZXJmYWNlIGlzIHByb3Bv
c2VkLCB0aGUgYXV0aG9yIHdpbGwgaGF2ZSB0byBtYWtlIHN1cmUgdGhhdCBpdCBpcyBleGVyY2lz
ZWQgY29ycmVjdGx5Lg0KDQpTdXJlLiBMZXQgdGhlIGF1dGhvciBtYWtlIHN1cmUgdGhhdCBpdCBp
cyBleGVyY2lzZWQgY29ycmVjdGx5IGlmIGEgbmV3IGFwcGxpY2F0aW9uIG9mIHRoaXMgaW50ZXJm
YWNlIGlzIHByb3Bvc2VkLg0KDQo+PiBPbiB0aGUgb3RoZXIgaGFuZCwgYmVjYXVzZSB0aGlzIGNv
ZGVwYXRoIHNob3VsZCBub3Qgc2VlIGFueSBwYWNrZXRzIA0KPj4gd2l0aCB6ZXJvY29weSBzdGF0
ZSBhc3NvY2lhdGVkLCB0aGVuIHdlIHNob3VsZCBub3QgY2FsbCBza2Jfb3JwaGFuX2ZyYWdzIGhl
cmUuDQoNCj5JJ20gYWxzbyBub3QgY29udmluY2VkIHRoYXQgdGhlIHNrYl9vcnBoYW5fZnJhZ3Mg
aGVyZSBhcmUgbmVlZGVkLCBnaXZlbiB0aGUgb25seSBwYXRoIGlzIGZyb20gdGNwX3JlYWRfc29j
ay4NCg0KTWF5YmUganVzdCBrZWVwIGl0IGhlcmUgYXMgaXQgZG9lc24ndCBodXJ0IGV2ZW4gaWYg
aXQncyByZWFsbHkgbm90IG5lZWRlZC4NCg0KTWFueSB0aGFua3MuDQoNCg==
