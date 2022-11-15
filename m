Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC16F62A34E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 21:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiKOUsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 15:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKOUsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 15:48:12 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDE826489;
        Tue, 15 Nov 2022 12:48:09 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 3E6FB5FD07;
        Tue, 15 Nov 2022 23:48:07 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1668545287;
        bh=JPGfohbosaUAmtObAbhNd5nTyTEewTH4tnrJ4R/k/CE=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=fYvCNb4yFSo9DbBpdE4sS+9hMchiqxV+TSqt7DoH1pNqnBoHHQGPUxO4B/yiWcFh8
         SILVsDThKjYG5hoJu2Qql6Wd8RdaHzg4CgPlOQwgAu7pstu6598iMHR9lx5dNN7g+2
         dXyf3B9TUm1N1TAXmVdJesuil0wrzKKqwZOo09ndg5zoRCyEaYSjJicyijplNyxqQ8
         Xqd2wbKV3gY4GN2vZIxZFS8mXtWXGQXqNegvWb5+AuDnCJ5OYijm+WsWyT38q9YGlt
         qmxqs+2h3Nm1zRL5FqAYwMOaQLAYlI8fkvcFF1CQ0fI5kRjsl6n1o/DWyndiR5Fl0y
         9ry2QilmgLTug==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 15 Nov 2022 23:48:05 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 0/3] test/vsock: update two tests and add new tool
Thread-Topic: [RFC PATCH v1 0/3] test/vsock: update two tests and add new tool
Thread-Index: AQHY+TOPXsnrO4Inj0K6247YFI64dQ==
Date:   Tue, 15 Nov 2022 20:48:05 +0000
Message-ID: <ba294dff-812a-bfc2-a43c-286f99aee0b8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB6E3890E470E74D815897843DED993B@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/15 16:23:00 #20571948
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2luY2UgdGhlcmUgaXMgd29yayBvbiBzZXZlcmFsIHNpZ25pZmljYW50IHVwZGF0ZXMgZm9yIHZz
b2NrKHZpcnRpby8NCnZzb2NrIGVzcGVjaWFsbHkpOiBza2J1ZmYsIERHUkFNLCB6ZXJvY29weSBy
eC90eCwgc28gSSB0aGluayB0aGF0IHRoaXMNCnBhdGNoc2V0IHdpbGwgYmUgdXNlZnVsLg0KDQpU
aGlzIHBhdGNoc2V0IHVwZGF0ZXMgdnNvY2sgdGVzdHMgYW5kIHRvb2xzIGEgbGl0dGxlIGJpdC4g
Rmlyc3Qgb2YgYWxsDQppdCB1cGRhdGVzIHRlc3Qgc3VpdGU6IHR3byBuZXcgdGVzdHMgYXJlIGFk
ZGVkLiBPbmUgdGVzdCBpcyByZXdvcmtlZA0KbWVzc2FnZSBib3VuZCB0ZXN0LiBOb3cgaXQgaXMg
bW9yZSBjb21wbGV4LiBJbnN0ZWFkIG9mIHNlbmRpbmcgMSBieXRlDQptZXNzYWdlcyB3aXRoIG9u
ZSBNU0dfRU9SIGJpdCwgaXQgc2VuZHMgbWVzc2FnZXMgb2YgcmFuZG9tIGxlbmd0aChvbmUNCmhh
bGYgb2YgbWVzc2FnZXMgYXJlIHNtYWxsZXIgdGhhbiBwYWdlIHNpemUsIHNlY29uZCBoYWxmIGFy
ZSBiaWdnZXIpDQp3aXRoIHJhbmRvbSBudW1iZXIgb2YgTVNHX0VPUiBiaXRzIHNldC4gUmVjZWl2
ZXIgYWxzbyBkb24ndCBrbm93IHRvdGFsDQpudW1iZXIgb2YgbWVzc2FnZXMuIE1lc3NhZ2UgYm91
bmRzIGNvbnRyb2wgaXMgbWFpbnRhaW5lZCBieSBoYXNoIHN1bQ0Kb2YgbWVzc2FnZXMgbGVuZ3Ro
IGNhbGN1bGF0aW9uLiBTZWNvbmQgdGVzdCBpcyBmb3IgU09DS19TRVFQQUNLRVQgLSBpdA0KdHJp
ZXMgdG8gc2VuZCBtZXNzYWdlIHdpdGggbGVuZ3RoIG1vcmUgdGhhbiBhbGxvd2VkLiBJIHRoaW5r
IGJvdGggdGVzdHMNCndpbGwgYmUgdXNlZnVsIGZvciBER1JBTSBzdXBwb3J0IGFsc28uDQoNClRo
aXJkIHRoaW5nIHRoYXQgdGhpcyBwYXRjaHNldCBhZGRzIGlzIHNtYWxsIHV0aWxpdHkgdG8gdGVz
dCB2c29jaw0KcGVyZm9ybWFuY2UgZm9yIGJvdGggcnggYW5kIHR4LiBJIHRoaW5rIHRoaXMgdXRp
bCBjb3VsZCBiZSB1c2VmdWwgYXMNCidpcGVyZicsIGJlY2F1c2U6DQoxKSBJdCBpcyBzbWFsbCBj
b21wYXJpbmcgdG8gJ2lwZXJmKCknLCBzbyBpdCB2ZXJ5IGVhc3kgdG8gYWRkIG5ldw0KICAgbW9k
ZSBvciBmZWF0dXJlIHRvIGl0KGVzcGVjaWFsbHkgdnNvY2sgc3BlY2lmaWMpLg0KMikgSXQgaXMg
bG9jYXRlZCBpbiBrZXJuZWwgc291cmNlIHRyZWUsIHNvIGl0IGNvdWxkIGJlIHVwZGF0ZWQgYnkg
dGhlDQogICBzYW1lIHBhdGNoc2V0IHdoaWNoIGNoYW5nZXMgcmVsYXRlZCBrZXJuZWwgZnVuY3Rp
b25hbGl0eSBpbiB2c29jay4NCg0KSSB1c2VkIHRoaXMgdXRpbCB2ZXJ5IG9mdGVuIHRvIGNoZWNr
IHBlcmZvcm1hbmNlIG9mIG15IHJ4IHplcm9jb3B5DQpzdXBwb3J0KHRoaXMgdG9vbCBoYXMgcngg
emVyb2NvcHkgc3VwcG9ydCwgYnV0IG5vdCBpbiB0aGlzIHBhdGNoc2V0KS4NCg0KUGF0Y2hzZXQg
d2FzIHJlYmFzZWQgYW5kIHRlc3RlZCBvbiBza2J1ZmYgcGF0Y2ggZnJvbSBCb2JieSBFc2hsZW1h
bjoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMjExMTAxNzE3MjMuMjQyNjMtMS1i
b2JieS5lc2hsZW1hbkBieXRlZGFuY2UuY29tLw0KDQpBbGwgMyBwYXRjaGVzIGFyZSBmcm9tIG15
IHByZXZpb3VzIGJpZyBwYXRjaHNldCBmb3IgdmlydGlvL3Zzb2NrIHJ4DQp6ZXJvY29weSAtIHRo
ZXkgYXJlIG5vdCByZWxhdGVkIHRvIHplcm9jb3B5LCBzbyBTdGVmYW5vIHN1Z2dlc3RlZCB0bw0K
ZXhjbHVkZSB0aGVtIGZyb20gcGF0Y2hzZXQuDQoNCkFyc2VuaXkgS3Jhc25vdigzKToNCiB0ZXN0
L3Zzb2NrOiByZXdvcmsgbWVzc2FnZSBib3VuZCB0ZXN0DQogdGVzdC92c29jazogYWRkIGJpZyBt
ZXNzYWdlIHRlc3QNCiB0ZXN0L3Zzb2NrOiB2c29ja19wZXJmIHV0aWxpdHkNCg0KIHRvb2xzL3Rl
c3RpbmcvdnNvY2svTWFrZWZpbGUgICAgIHwgICAxICsNCiB0b29scy90ZXN0aW5nL3Zzb2NrL3Zz
b2NrX3BlcmYuYyB8IDM4NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysN
CiB0b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyB8ICA2MiArKysrKysrDQogMyBmaWxl
cyBjaGFuZ2VkLCA0NDkgaW5zZXJ0aW9ucygrKQ0KDQotLSANCjIuMjUuMQ0K
