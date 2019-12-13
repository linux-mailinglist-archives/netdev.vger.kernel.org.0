Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71B411DE45
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 07:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfLMGoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 01:44:39 -0500
Received: from mx22.baidu.com ([220.181.50.185]:34890 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725770AbfLMGoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 01:44:38 -0500
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Dec 2019 01:44:37 EST
Received: from BC-Mail-Ex30.internal.baidu.com (unknown [172.31.51.24])
        by Forcepoint Email with ESMTPS id 1B2BE1EAD4B5A1E08CF9;
        Fri, 13 Dec 2019 14:27:29 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex30.internal.baidu.com (172.31.51.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 13 Dec 2019 14:27:28 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Fri, 13 Dec 2019 14:27:28 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBwYWdlX3Bvb2w6IGhhbmRsZSBwYWdlIHJl?=
 =?utf-8?B?Y3ljbGUgZm9yIE5VTUFfTk9fTk9ERSBjb25kaXRpb24=?=
Thread-Topic: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Index: AQHVrBgioGDhH/MP9UuNcNvu7zNf3aeuC1gAgAa9z4CAACtDgIAARc8AgACSe4CAASNCAIAArxmA
Date:   Fri, 13 Dec 2019 06:27:28 +0000
Message-ID: <1d4f10f4c0f1433bae658df8972a904f@baidu.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191212111831.2a9f05d3@carbon>
 <7c555cb1-6beb-240d-08f8-7044b9087fe4@huawei.com>
In-Reply-To: <7c555cb1-6beb-240d-08f8-7044b9087fe4@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.17]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex30_2019-12-13 14:27:29:041
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex30_GRAY_Inside_WithoutAtta_2019-12-13
 14:27:29:010
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gSXQgaXMgZ29vZCB0byBhbGxvY2F0ZSB0aGUgcnggcGFnZSBjbG9zZSB0byBib3RoIGNw
dSBhbmQgZGV2aWNlLCBidXQgaWYNCj4gYm90aCBnb2FsIGNhbiBub3QgYmUgcmVhY2hlZCwgbWF5
YmUgd2UgY2hvb3NlIHRvIGFsbG9jYXRlIHBhZ2UgdGhhdCBjbG9zZQ0KPiB0byBjcHU/DQo+IA0K
SSB0aGluayBpdCBpcyB0cnVlDQoNCklmIGl0IGlzIHRydWUsICwgd2UgY2FuIHJlbW92ZSBwb29s
LT5wLm5pZCwgYW5kIHJlcGxhY2UgYWxsb2NfcGFnZXNfbm9kZSB3aXRoDQphbGxvY19wYWdlcyBp
biBfX3BhZ2VfcG9vbF9hbGxvY19wYWdlc19zbG93LCBhbmQgY2hhbmdlIHBvb2xfcGFnZV9yZXVz
YWJsZSBhcw0KdGhhdCBwYWdlX3RvX25pZChwYWdlKSBpcyBjaGVja2VkIHdpdGggbnVtYV9tZW1f
aWQoKSAgDQoNCnNpbmNlIGFsbG9jX3BhZ2VzIGhpbnQgdG8gdXNlIHRoZSBjdXJyZW50IG5vZGUg
cGFnZSwgYW5kIF9fcGFnZV9wb29sX2FsbG9jX3BhZ2VzX3Nsb3cgDQp3aWxsIGJlIGNhbGxlZCBp
biBOQVBJIHBvbGxpbmcgb2Z0ZW4gaWYgcmVjeWNsZSBmYWlsZWQsIGFmdGVyIHNvbWUgY3ljbGUs
IHRoZSBwYWdlIHdpbGwgYmUgZnJvbQ0KbG9jYWwgbWVtb3J5IG5vZGUuDQoNCi1MaQ0KDQo=
