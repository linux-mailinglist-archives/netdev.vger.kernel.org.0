Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3979823E2E7
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 22:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgHFULj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 16:11:39 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3047 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbgHFULj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 16:11:39 -0400
Received: from dggeme703-chm.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id EA26DBEDFACB0CA11284;
        Thu,  6 Aug 2020 19:56:33 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme703-chm.china.huawei.com (10.1.199.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 6 Aug 2020 19:56:33 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Thu, 6 Aug 2020 19:56:33 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        "martin.varghese@nokia.com" <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "shmulik@metanetworks.com" <shmulik@metanetworks.com>,
        "kyk.segfault@gmail.com" <kyk.segfault@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Fix potential out of bound write in
 skb_try_coalesce()
Thread-Topic: [PATCH] net: Fix potential out of bound write in
 skb_try_coalesce()
Thread-Index: AdZqy5NXuDxuQTg3SyGrTCdJ0BYmPg==
Date:   Thu, 6 Aug 2020 11:56:33 +0000
Message-ID: <a1516b0e527246ed8e40ede17e69decd@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.177.143]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPiB3cm90ZToNCj5PbiBUdWUsIEF1ZyA0
LCAyMDIwIGF0IDQ6NDYgQU0gbGlubWlhb2hlIDxsaW5taWFvaGVAaHVhd2VpLmNvbT4gd3JvdGU6
DQo+Pg0KPj4gRnJvbTogTWlhb2hlIExpbiA8bGlubWlhb2hlQGh1YXdlaS5jb20+DQo+Pg0KPj4g
VGhlIGhlYWRfZnJhZyBvZiBza2Igd291bGQgb2NjdXB5IG9uZSBleHRyYSBza2JfZnJhZ190LiBU
YWtlIGl0IGludG8gDQo+PiBhY2NvdW50IG9yIG91dCBvZiBib3VuZCB3cml0ZSB0byBza2IgZnJh
Z3MgbWF5IGhhcHBlbi4NCj4+DQo+DQo+UGxlYXNlIHNoYXJlIGEgc3RhY2sgdHJhY2UgaWYgdGhp
cyB3YXMgYSByZWFsIGJ1ZyBzcG90dGVkIGluIHRoZSB3aWxkLg0KPg0KPkkgZG8gbm90IGJlbGll
dmUgdGhpcyBwYXRjaCBpcyBjb3JyZWN0Lg0KPg0KPmlmIChBICsgQiA+PSBNQVgpICAgaXMgZXF1
aXZhbGVudCB0byAgaWYgKEEgKyBCICsgMSA+IE1BWCkNCj4NCj5Ob3RlIGhvdyB0aGUgb3RoZXIg
Y29uZGl0aW9uICh3aGVuIHRoZXJlIGlzIG5vIGJ5dGVzIGluIHNrYiBoZWFkZXIpIGlzIGNvZGVk
IDoNCj4NCj5pZiAoQSArIEIgPiBNQVgpIHJldHVybiBmYWxzZTsNCj4NCj5JbiBhbnljYXNlLCBw
bGVhc2UgYWx3YXlzIHByb3ZpZGUgYSBGaXhlczogdGFnIGZvciBhbnkgYnVnIGZpeC4NCj4NCj5U
aGFua3MuDQoNCk1hbnkgdGhhbmtzIGZvciB5b3VyIHBhdGllbnQgZXhwbGFpbmF0aW9uLiBJIGNv
bXBhcmVkIChBICsgQiA+PSBNQVgpIHdpdGggKEEgKyBCICsgMSA+IE1BWCkgaW4gc2tiX2dyb19y
ZWNlaXZlKCksDQpidXQgSSBtaXNzZWQgdGhlICc9Jy4gSXQncyBteSBvdmVyc2lnaHQsIEknYW0g
cmVhbGx5IHNvcnJ5IGFib3V0IGl0Lg0KDQpUaGFua3MgYWdhaW4uDQoNCg==
