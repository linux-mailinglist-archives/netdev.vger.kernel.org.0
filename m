Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C1D641F37
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 20:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiLDTRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 14:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiLDTRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 14:17:38 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDF6A4;
        Sun,  4 Dec 2022 11:17:33 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 47B145FD03;
        Sun,  4 Dec 2022 22:17:30 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1670181450;
        bh=skgE35J6ivY87+2f87J3uueS/nxNIyBMux3LvAvSxgE=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=iAiB/r6g7k1wjBR8TbIf2K/PCAzvPZKkxMGCuJjXp8f81xu7YNSSb/jdRhYcMq1rd
         N8rwl+SuiOVxlG4UlM7vFbNHVFa3Bpe52O1HsM/QJrdYDll0GHiBjk2RMzjWj+ssxw
         o0nE3er86ZHSgt3hg8BTYEAykac8BT3z1j7AVbS/yRtRoOFR21mEuzoLX2McUK3uiQ
         Jkx9PV27K9mCJ8FsksfTZzeRdWjWLbQJ8ZaC1s8KLQDImFqyu6fUrJL6MSk/hJIUds
         yhrXZEZ13OOkO20SFtAKCechZQEfuEbHZl4NDxLUAm6dmsLoU4i9XjM0C4UyW0rETp
         jmG9IaG3FFANg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  4 Dec 2022 22:17:27 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 0/4] vsock: update tools and error handling
Thread-Topic: [RFC PATCH v3 0/4] vsock: update tools and error handling
Thread-Index: AQHZCBUL8pVjCcixh0a5TtqWHSqeyw==
Date:   Sun, 4 Dec 2022 19:17:26 +0000
Message-ID: <6bd77692-8388-8693-f15f-833df1fa6afd@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <050CC44EF805B848BA74D7739AAF9FF5@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/04 13:44:00 #20647742
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGF0Y2hzZXQgY29uc2lzdHMgb2YgdHdvIHBhcnRzOg0KDQoxKSBLZXJuZWwgcGF0Y2gNCk9uZSBw
YXRjaCBmcm9tIEJvYmJ5IEVzaGxlbWFuLiBJIHRvb2sgc2luZ2xlIHBhdGNoIGZyb20gQm9iYnk6
DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2Q4MTgxOGI4NjgyMTZjNzc0NjEzZGQwMzY0
MWZjZmU2M2NjNTVhNDUNCi4xNjYwMzYyNjY4LmdpdC5ib2JieS5lc2hsZW1hbkBieXRlZGFuY2Uu
Y29tLyBhbmQgdXNlIG9ubHkgcGFydCBmb3INCmFmX3Zzb2NrLmMsIGFzIFZNQ0kgYW5kIEh5cGVy
LVYgcGFydHMgd2VyZSByZWplY3RlZC4NCg0KSSB1c2VkIGl0LCBiZWNhdXNlIGZvciBTT0NLX1NF
UVBBQ0tFVCBiaWcgbWVzc2FnZXMgaGFuZGxpbmcgd2FzIGJyb2tlbiAtDQpFTk9NRU0gd2FzIHJl
dHVybmVkIGluc3RlYWQgb2YgRU1TR1NJWkUuIEFuZCBhbnl3YXksIGN1cnJlbnQgbG9naWMgd2hp
Y2gNCmFsd2F5cyByZXBsYWNlcyBhbnkgZXJyb3IgY29kZSByZXR1cm5lZCBieSB0cmFuc3BvcnQg
dG8gRU5PTUVNIGxvb2tzDQpzdHJhbmdlIGZvciBtZSBhbHNvKGZvciBleGFtcGxlIGluIEVNU0dT
SVpFIGNhc2UgaXQgd2FzIGNoYW5nZWQgdG8NCkVOT01FTSkuDQoNCjIpIFRvb2wgcGF0Y2hlcw0K
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
d2FzIHJlYmFzZWQgYW5kIHRlc3RlZCBvbiBza2J1ZmYgdjUgcGF0Y2ggZnJvbSBCb2JieSBFc2hs
ZW1hbjoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIyMTIwMjE3MzUyMC4xMDQy
OC0xLWJvYmJ5LmVzaGxlbWFuQGJ5dGVkYW5jZS5jb20vDQoNCkNoYW5nZWxvZzoNCiB2MiAtPiB2
MzoNCiAtIFBhdGNoZXMgZm9yIFZNQ0kgYW5kIEh5cGVyLVYgd2VyZSByZW1vdmVkIGZyb20gcGF0
Y2hzZXQoY29tbWVudGVkIGJ5DQogICBWaXNobnUgRGFzYSBhbmQgRGV4dWFuIEN1aSkNCiAtIElu
IG1lc3NhZ2UgYm91bmRzIHRlc3QgaGFzaCBpcyBjb21wdXRlZCBmcm9tIGRhdGEgYnVmZmVyIHdp
dGggcmFuZG9tDQogICBjb250ZW50KGluIHYyIGl0IHdhcyBzaXplIG9ubHkpLiBUaGlzIGFwcHJv
YWNoIGNvbnRyb2xzIGJvdGggZGF0YQ0KICAgaW50ZWdyaXR5IGFuZCBtZXNzYWdlIGJvdW5kcy4N
CiAtIHZzb2NrX3BlcmY6DQogICAtIGdyYW1tYXIgZml4ZXMNCiAgIC0gb25seSBsb25nIHBhcmFt
ZXRlcnMgc3VwcG9ydGVkKGluc3RlYWQgb2Ygb25seSBzaG9ydCkNCiB2MSAtPiB2MjoNCiAtIFRo
cmVlIG5ldyBwYXRjaGVzIGZyb20gQm9iYnkgRXNobGVtYW4gdG8ga2VybmVsIHBhcnQNCiAtIE1l
c3NhZ2UgYm91bmRzIHRlc3Q6IHNvbWUgcmVmYWN0b3JpbmcgYW5kIGFkZCBjb21tZW50IHRvIGRl
c2NyaWJlDQogICBoYXNoaW5nIHB1cnBvc2UNCiAtIEJpZyBtZXNzYWdlIHRlc3Q6IGNoZWNrICdl
cnJubycgZm9yIEVNU0dTSVpFIGFuZCAgbW92ZSBuZXcgdGVzdCB0bw0KICAgdGhlIGVuZCBvZiB0
ZXN0cyBhcnJheQ0KIC0gdnNvY2tfcGVyZjoNCiAgIC0gdXBkYXRlIFJFQURNRSBmaWxlDQogICAt
IGFkZCBzaW1wbGUgdXNhZ2UgZXhhbXBsZSB0byBjb21taXQgbWVzc2FnZQ0KICAgLSB1cGRhdGUg
Jy1oJyAoaGVscCkgb3V0cHV0DQogICAtIHVzZSAnc3Rkb3V0JyBmb3Igb3V0cHV0IGluc3RlYWQg
b2YgJ3N0ZGVycicNCiAgIC0gdXNlICdzdHJ0b2wnIGluc3RlYWQgb2YgJ2F0b2knDQoNCkJvYmJ5
IEVzaGxlbWFuKDEpOg0KIHZzb2NrOiByZXR1cm4gZXJyb3JzIG90aGVyIHRoYW4gLUVOT01FTSB0
byBzb2NrZXQNCg0KQXJzZW5peSBLcmFzbm92KDMpOg0KIHRlc3QvdnNvY2s6IHJld29yayBtZXNz
YWdlIGJvdW5kIHRlc3QNCiB0ZXN0L3Zzb2NrOiBhZGQgYmlnIG1lc3NhZ2UgdGVzdA0KIHRlc3Qv
dnNvY2s6IHZzb2NrX3BlcmYgdXRpbGl0eQ0KDQogbmV0L3Ztd192c29jay9hZl92c29jay5jICAg
ICAgICAgfCAgIDMgKy0NCiB0b29scy90ZXN0aW5nL3Zzb2NrL01ha2VmaWxlICAgICB8ICAgMSAr
DQogdG9vbHMvdGVzdGluZy92c29jay9SRUFETUUgICAgICAgfCAgMzQgKysrDQogdG9vbHMvdGVz
dGluZy92c29jay9jb250cm9sLmMgICAgfCAgMjggKysrDQogdG9vbHMvdGVzdGluZy92c29jay9j
b250cm9sLmggICAgfCAgIDIgKw0KIHRvb2xzL3Rlc3RpbmcvdnNvY2svdXRpbC5jICAgICAgIHwg
IDEzICsrDQogdG9vbHMvdGVzdGluZy92c29jay91dGlsLmggICAgICAgfCAgIDEgKw0KIHRvb2xz
L3Rlc3RpbmcvdnNvY2svdnNvY2tfcGVyZi5jIHwgNDQ5ICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KIHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIHwgMTkz
ICsrKysrKysrKysrKysrKy0tDQogOSBmaWxlcyBjaGFuZ2VkLCA3MTAgaW5zZXJ0aW9ucygrKSwg
MTQgZGVsZXRpb25zKC0pDQotLSANCjIuMjUuMQ0K
