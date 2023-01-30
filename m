Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F27F681616
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbjA3QNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237306AbjA3QNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:13:19 -0500
Received: from exchange.fintech.ru (exchange.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D736A728B;
        Mon, 30 Jan 2023 08:13:13 -0800 (PST)
Received: from Ex16-02.fintech.ru (10.0.10.19) by exchange.fintech.ru
 (195.54.195.169) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 30 Jan
 2023 19:13:12 +0300
Received: from Ex16-01.fintech.ru (10.0.10.18) by Ex16-02.fintech.ru
 (10.0.10.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Mon, 30 Jan
 2023 19:13:11 +0300
Received: from Ex16-01.fintech.ru ([fe80::2534:7600:5275:d3f9]) by
 Ex16-01.fintech.ru ([fe80::2534:7600:5275:d3f9%7]) with mapi id
 15.01.2242.004; Mon, 30 Jan 2023 19:13:11 +0300
From:   =?utf-8?B?0JbQsNC90LTQsNGA0L7QstC40Ycg0J3QuNC60LjRgtCwINCY0LPQvtGA0LU=?=
         =?utf-8?B?0LLQuNGH?= <n.zhandarovich@fintech.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alexey Khoroshilov" <khoroshilov@ispras.ru>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: RE: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Thread-Topic: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Thread-Index: AQHZNKePV9Tuf82zRk2tMrTfyN8UZK62u2sAgAA3O6D//9G7AIAANNZg///R24CAAFTb4A==
Date:   Mon, 30 Jan 2023 16:13:11 +0000
Message-ID: <bbd1ce753d8144ee9d4d9da7f3033c68@fintech.ru>
References: <20230130123655.86339-1-n.zhandarovich@fintech.ru>
 <20230130123655.86339-2-n.zhandarovich@fintech.ru>
 <Y9fAkt/5BRist//g@kroah.com> <b945bd5f3d414ac5bc589d65cf439f7b@fintech.ru>
 <Y9fIFirNHNP06e1L@kroah.com> <e17c785dbacf4605a726cc939bee6533@fintech.ru>
 <Y9fNs5QWbrJh+yH6@kroah.com>
In-Reply-To: <Y9fNs5QWbrJh+yH6@kroah.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.253.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+ID4gV2hhdCBpcyB0aGUgImZhdWx0Ij8NCj4gPg0KPiA+IEluIDUuMTAueSAibXQ3NjE1X2lu
aXRfdHhfcXVldWVzKCkgcmV0dXJucyAwIHJlZ2FyZGxlc3Mgb2YgaG93IGZpbmFsDQo+ID4gbXQ3
NjE1X2luaXRfdHhfcXVldWUoKSBwZXJmb3Jtcy4gSWYgbXQ3NjE1X2luaXRfdHhfcXVldWUoKSBm
YWlscyAoZHVlDQo+ID4gdG8gbWVtb3J5IGlzc3VlcywgZm9yIGluc3RhbmNlKSwgcGFyZW50IGZ1
bmN0aW9uIHdpbGwgc3RpbGwNCj4gPiBlcnJvbmVvdXNseSByZXR1cm4gMC4iDQo+IA0KPiBBbmQg
aG93IGNhbiBtZW1vcnkgaXNzdWVzIGFjdHVhbGx5IGJlIHRyaWdnZXJlZCBpbiBhIHJlYWwgc3lz
dGVtPyAgSXMgdGhpcyBhDQo+IGZha2UgcHJvYmxlbSBvciBzb21ldGhpbmcgeW91IGNhbiB2YWxp
ZGF0ZSBhbmQgdmVyaWZ5IHdvcmtzIHByb3Blcmx5Pw0KPiANCj4gRG9uJ3Qgd29ycnkgYWJvdXQg
ZmFrZSBpc3N1ZXMgZm9yIHN0YWJsZSBiYWNrcG9ydHMgcGxlYXNlLg0KPiANCj4gdGhhbmtzLA0K
PiANCj4gZ3JlZyBrLWgNCg0KbXQ3NjE1X2luaXRfdHhfcXVldWUoKSBjYWxscyBkZXZtX2t6YWxs
b2MoKSAod2hpY2ggY2FuIHRocm93IC1FTk9NRU0pIGFuZCBtdDc2X3F1ZXVlX2FsbG9jKCkgKHdo
aWNoIGNhbiBhbHNvIGZhaWwpLiBJdCdzIGhhcmQgZm9yIG1lIHRvIGdhdWdlIGhvdyBwcm9iYWJs
ZSB0aGVzZSBmYWlsdXJlcyBjYW4gYmUuIEJ1dCBJIGZlZWwgbGlrZSBhdCB0aGUgdmVyeSBsZWFz
dCBpdCdzIGEgbG9naWNhbCBzYW5pdHkgY2hlY2suIA0KDQpAQCAtODIsNyArODIsNyBAQCBtdDc2
MTVfaW5pdF90eF9xdWV1ZXMoc3RydWN0IG10NzYxNV9kZXYgKmRldikNCiAJDQogICAgICAgIHJl
dCA9IG10NzYxNV9pbml0X3R4X3F1ZXVlKGRldiwgTVRfVFhRX01DVSwgTVQ3NjE1X1RYUV9NQ1Us
DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE1UNzYxNV9UWF9NQ1VfUklOR19T
SVpFKTsNCiAgICAgICByZXR1cm4gMDsNCg0KVGhlcmUgaXMgbm8gc3BlY2lhbCByZWFzb24gIGZv
ciBtdDc2MTVfaW5pdF90eF9xdWV1ZXMoKSB0byBpZ25vcmUgbGFzdCAncmV0Jy4gSWYgbGFzdCBt
dDc2MTVfaW5pdF90eF9xdWV1ZSgpLCBzbyBzaG91bGQgbXQ3NjE1X2luaXRfdHhfcXVldWVzKCku
IEFuZCB1cHN0cmVhbSBwYXRjaCAoYjY3MWRhMzNkMWM1OTczZjkwZjA5OGZmNjZhOTE5NTM2OTFk
ZjU4MikgYWRkcmVzc2VzIHRoaXMgYXMgd2VsbC4gDQpJZiB5b3UgZmVlbCBkaWZmZXJlbnRseSwg
SSB3aWxsIG9mIGNvdXJzZSBiYWNrIGRvd24uDQoNCnJlZ2FyZHMsDQoNCk5pa2l0YQ0K
