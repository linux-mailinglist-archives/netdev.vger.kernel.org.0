Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF397244657
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 10:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgHNIRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 04:17:19 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:60450 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726641AbgHNIRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 04:17:19 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id AFDC018AF1808F92AB83;
        Fri, 14 Aug 2020 16:17:16 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme754-chm.china.huawei.com (10.3.19.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 14 Aug 2020 16:17:16 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Fri, 14 Aug 2020 16:17:16 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: correct zerocopy refcnt with newly allocated UDP or
 RAW uarg
Thread-Topic: [PATCH] net: correct zerocopy refcnt with newly allocated UDP or
 RAW uarg
Thread-Index: AdZyCsRRYMjrdzIZQKySmFdoNa8vFQ==
Date:   Fri, 14 Aug 2020 08:17:16 +0000
Message-ID: <84f3ed74e9de4422933bc6a642890697@huawei.com>
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
DQo+T24gVGh1LCBBdWcgMTMsIDIwMjAgYXQgMTo1OSBQTSBNaWFvaGUgTGluIDxsaW5taWFvaGVA
aHVhd2VpLmNvbT4gd3JvdGU6DQo+Pg0KPj4gVGhlIHZhciBleHRyYV91cmVmIGlzIGludHJvZHVj
ZWQgdG8gcGFzcyB0aGUgaW5pdGlhbCByZWZlcmVuY2UgdGFrZW4gDQo+PiBpbiBzb2NrX3plcm9j
b3B5X2FsbG9jIHRvIHRoZSBmaXJzdCBnZW5lcmF0ZWQgc2tiLiBCdXQgbm93IHdlIG1heSBmYWls
IA0KPj4gdG8gcGFzcyB0aGUgaW5pdGlhbCByZWZlcmVuY2Ugd2l0aCBuZXdseSBhbGxvY2F0ZWQg
VURQIG9yIFJBVyB1YXJnIA0KPj4gd2hlbiB0aGUgc2tiIGlzIHpjb3BpZWQuDQo+DQo+ZXh0cmFf
dXJlZiBpcyB0cnVlIGlmIHRoZXJlIGlzIG5vIHByZXZpb3VzIHNrYiB0byBhcHBlbmQgdG8gb3Ig
dGhlcmUgaXMgYSBwcmV2aW91cyBza2IsIGJ1dCB0aGF0IGRvZXMgbm90IGhhdmUgemVyb2NvcHkg
ZGF0YSBhc3NvY2lhdGVkIHlldCAoYmVjYXVzZSB0aGUgcHJldmlvdXMgY2FsbChzKSBkaWQgbm90
IHNldCBNU0dfWkVST0NPUFkpLg0KPg0KPkluIG90aGVyIHdvcmRzLCB3aGVuIGZpcnN0IChhbGxv
Y2F0aW5nIGFuZCkgYXNzb2NpYXRpbmcgYSB6ZXJvY29weSBzdHJ1Y3Qgd2l0aCB0aGUgc2tiLg0K
DQpNYW55IHRoYW5rcyBmb3IgeW91ciBleHBsYWluYXRpb24uIFRoZSB2YXIgZXh0cmFfdXJlZiBw
bGF5cyB0aGUgcm9sZSBhcyB5b3Ugc2F5LiBJIGp1c3QgYm9ycm93ZWQgdGhlIGRlc2NyaXB0aW9u
IG9mIHZhciBleHRyYV91cmVmIGZyb20gcHJldmlvdXMgY29tbWl0IGxvZyBoZXJlLg0KDQo+DQo+
PiAtICAgICAgICAgICAgICAgZXh0cmFfdXJlZiA9ICFza2JfemNvcHkoc2tiKTsgICAvKiBvbmx5
IHJlZiBvbiBuZXcgdWFyZyAqLw0KPj4gKyAgICAgICAgICAgICAgIC8qIE9ubHkgcmVmIG9uIG5l
d2x5IGFsbG9jYXRlZCB1YXJnLiAqLw0KPj4gKyAgICAgICAgICAgICAgIGlmICghc2tiX3pjb3B5
KHNrYikgfHwgKHNrLT5za190eXBlICE9IFNPQ0tfU1RSRUFNICYmIHNrYl96Y29weShza2IpICE9
IHVhcmcpKQ0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgZXh0cmFfdXJlZiA9IHRydWU7DQo+
DQo+U09DS19TVFJFQU0gZG9lcyBub3QgdXNlIF9faXBfYXBwZW5kX2RhdGEuDQo+DQo+VGhpcyBs
ZWF2ZXMgYXMgbmV3IGJyYW5jaCBza2JfemNvcHkoc2tiKSAmJiBza2JfemNvcHkoc2tiKSAhPSB1
YXJnLg0KPg0KPlRoaXMgZnVuY3Rpb24gY2FuIG9ubHkgYWNxdWlyZSBhIHVhcmcgdGhyb3VnaCBz
b2NrX3plcm9jb3B5X3JlYWxsb2MsIHdoaWNoIG9uIHNrYl96Y29weShza2IpIG9ubHkgcmV0dXJu
cyB0aGUgZXhpc3RpbmcgdWFyZyBvciBOVUxMIChmb3Igbm90IFNPQ0tfU1RSRUFNKS4NCj4NCj5T
byBJIGRvbid0IHNlZSB3aGVuIHRoYXQgY29uZGl0aW9uIGNhbiBoYXBwZW4uDQo+DQoNCk9uIHNr
Yl96Y29weShza2IpLCB3ZSByZXR1cm5zIHRoZSBleGlzdGluZyB1YXJnIGlmZiAodWFyZy0+aWQg
KyB1YXJnLT5sZW4gPT0gYXRvbWljX3JlYWQoJnNrLT5za196Y2tleSkpIGluIHNvY2tfemVyb2Nv
cHlfcmVhbGxvYy4gU28gd2UgbWF5IGdldCBhIG5ld2x5IGFsbG9jYXRlZA0KdWFyZyB2aWEgc29j
a196ZXJvY29weV9hbGxvYygpLiBUaG91Z2ggd2UgbWF5IG5vdCB0cmlnZ2VyIHRoaXMgY29kZXBh
dGggbm93LCBpdCdzIHN0aWxsIGEgcG90ZW50aWFsIHByb2JsZW0gdGhhdCB3ZSBtYXkgbWlzc2Vk
IHRoZSByaWdodCB0cmFjZSB0byB1YXJnLg0KDQpPciBhbSBJIHN0aWxsIG1pc3MgYW55dGhpbmc/
IFRoYW5rcy4NCg0K
