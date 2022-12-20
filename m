Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45370652028
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiLTMHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbiLTMHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 07:07:09 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D534B16480;
        Tue, 20 Dec 2022 04:07:05 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id DF4175FD04;
        Tue, 20 Dec 2022 15:07:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1671538022;
        bh=yUlftmzp5aPySWXqewoqrPbcFBkrecTrMO9xZoTfO8g=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=IsZYWe29SXBpZKbqG9xaiZUEM4hnuBFnpV87ck/ynAgWFvE4eKSze4MFxV9n/5gwa
         ZnmuxyOi2I7wNv3Z5CH8q71pLkcjR/DKP10RfLcFilygPyVSp2Wsen0xC3B9KFS9PK
         mVOrze1h57c7c5YKMEWBcAhWspD+xP7xtt9VPkVi87dbi0wMszZBAP+OUEAoIkit4l
         mZOvJlkrH2JoLS1FkQCPJ1kV46nf7P7ebQei8wtjaT+4c4Lo18vd/fpQsrcV4MREGc
         uyFzlmyDCtQkqRezosKYQXhFp5TIki3ifQZc/5IVLTeNjLxM4zt3v9j8Lfq6O5y4ET
         C94yk7VUbhQEA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 20 Dec 2022 15:06:59 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v5 0/4] vsock: update tools and error handling
Thread-Topic: [RFC PATCH v5 0/4] vsock: update tools and error handling
Thread-Index: AQHZFEMAQA1kPjJjEE22ZwRXjunQBa52Y44AgAAYRIA=
Date:   Tue, 20 Dec 2022 12:06:58 +0000
Message-ID: <4041cdbc-8b44-43ba-740a-96338a95d130@sberdevices.ru>
References: <e04f749e-f1a7-9a1d-8213-c633ffcc0a69@sberdevices.ru>
 <20221220103824.w7xcwsg3o2mls7cs@sgarzare-redhat>
In-Reply-To: <20221220103824.w7xcwsg3o2mls7cs@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8AC5BFD6E8ECC41A5830208A6D3E71E@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/20 06:32:00 #20688041
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAuMTIuMjAyMiAxMzozOCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBUdWUs
IERlYyAyMCwgMjAyMiBhdCAwNzoxNjozOEFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBQYXRjaHNldCBjb25zaXN0cyBvZiB0d28gcGFydHM6DQo+Pg0KPj4gMSkgS2VybmVsIHBh
dGNoDQo+PiBPbmUgcGF0Y2ggZnJvbSBCb2JieSBFc2hsZW1hbi4gSSB0b29rIHNpbmdsZSBwYXRj
aCBmcm9tIEJvYmJ5Og0KPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9kODE4MThiODY4
MjE2Yzc3NDYxM2RkMDM2NDFmY2ZlNjNjYzU1YTQ1DQo+PiAuMTY2MDM2MjY2OC5naXQuYm9iYnku
ZXNobGVtYW5AYnl0ZWRhbmNlLmNvbS8gYW5kIHVzZSBvbmx5IHBhcnQgZm9yDQo+PiBhZl92c29j
ay5jLCBhcyBWTUNJIGFuZCBIeXBlci1WIHBhcnRzIHdlcmUgcmVqZWN0ZWQuDQo+Pg0KPj4gSSB1
c2VkIGl0LCBiZWNhdXNlIGZvciBTT0NLX1NFUVBBQ0tFVCBiaWcgbWVzc2FnZXMgaGFuZGxpbmcg
d2FzIGJyb2tlbiAtDQo+PiBFTk9NRU0gd2FzIHJldHVybmVkIGluc3RlYWQgb2YgRU1TR1NJWkUu
IEFuZCBhbnl3YXksIGN1cnJlbnQgbG9naWMgd2hpY2gNCj4+IGFsd2F5cyByZXBsYWNlcyBhbnkg
ZXJyb3IgY29kZSByZXR1cm5lZCBieSB0cmFuc3BvcnQgdG8gRU5PTUVNIGxvb2tzDQo+PiBzdHJh
bmdlIGZvciBtZSBhbHNvKGZvciBleGFtcGxlIGluIEVNU0dTSVpFIGNhc2UgaXQgd2FzIGNoYW5n
ZWQgdG8NCj4+IEVOT01FTSkuDQo+Pg0KPj4gMikgVG9vbCBwYXRjaGVzDQo+PiBTaW5jZSB0aGVy
ZSBpcyB3b3JrIG9uIHNldmVyYWwgc2lnbmlmaWNhbnQgdXBkYXRlcyBmb3IgdnNvY2sodmlydGlv
Lw0KPj4gdnNvY2sgZXNwZWNpYWxseSk6IHNrYnVmZiwgREdSQU0sIHplcm9jb3B5IHJ4L3R4LCBz
byBJIHRoaW5rIHRoYXQgdGhpcw0KPj4gcGF0Y2hzZXQgd2lsbCBiZSB1c2VmdWwuDQo+Pg0KPj4g
VGhpcyBwYXRjaHNldCB1cGRhdGVzIHZzb2NrIHRlc3RzIGFuZCB0b29scyBhIGxpdHRsZSBiaXQu
IEZpcnN0IG9mIGFsbA0KPj4gaXQgdXBkYXRlcyB0ZXN0IHN1aXRlOiB0d28gbmV3IHRlc3RzIGFy
ZSBhZGRlZC4gT25lIHRlc3QgaXMgcmV3b3JrZWQNCj4+IG1lc3NhZ2UgYm91bmQgdGVzdC4gTm93
IGl0IGlzIG1vcmUgY29tcGxleC4gSW5zdGVhZCBvZiBzZW5kaW5nIDEgYnl0ZQ0KPj4gbWVzc2Fn
ZXMgd2l0aCBvbmUgTVNHX0VPUiBiaXQsIGl0IHNlbmRzIG1lc3NhZ2VzIG9mIHJhbmRvbSBsZW5n
dGgob25lDQo+PiBoYWxmIG9mIG1lc3NhZ2VzIGFyZSBzbWFsbGVyIHRoYW4gcGFnZSBzaXplLCBz
ZWNvbmQgaGFsZiBhcmUgYmlnZ2VyKQ0KPj4gd2l0aCByYW5kb20gbnVtYmVyIG9mIE1TR19FT1Ig
Yml0cyBzZXQuIFJlY2VpdmVyIGFsc28gZG9uJ3Qga25vdyB0b3RhbA0KPj4gbnVtYmVyIG9mIG1l
c3NhZ2VzLiBNZXNzYWdlIGJvdW5kcyBjb250cm9sIGlzIG1haW50YWluZWQgYnkgaGFzaCBzdW0N
Cj4+IG9mIG1lc3NhZ2VzIGxlbmd0aCBjYWxjdWxhdGlvbi4gU2Vjb25kIHRlc3QgaXMgZm9yIFNP
Q0tfU0VRUEFDS0VUIC0gaXQNCj4+IHRyaWVzIHRvIHNlbmQgbWVzc2FnZSB3aXRoIGxlbmd0aCBt
b3JlIHRoYW4gYWxsb3dlZC4gSSB0aGluayBib3RoIHRlc3RzDQo+PiB3aWxsIGJlIHVzZWZ1bCBm
b3IgREdSQU0gc3VwcG9ydCBhbHNvLg0KPj4NCj4+IFRoaXJkIHRoaW5nIHRoYXQgdGhpcyBwYXRj
aHNldCBhZGRzIGlzIHNtYWxsIHV0aWxpdHkgdG8gdGVzdCB2c29jaw0KPj4gcGVyZm9ybWFuY2Ug
Zm9yIGJvdGggcnggYW5kIHR4LiBJIHRoaW5rIHRoaXMgdXRpbCBjb3VsZCBiZSB1c2VmdWwgYXMN
Cj4+ICdpcGVyZicvJ3VwZXJmJywgYmVjYXVzZToNCj4+IDEpIEl0IGlzIHNtYWxsIGNvbXBhcmlu
ZyB0byAnaXBlcmYnIG9yICd1cGVyZicsIHNvIGl0IHZlcnkgZWFzeSB0byBhZGQNCj4+IMKgIG5l
dyBtb2RlIG9yIGZlYXR1cmUgdG8gaXQoZXNwZWNpYWxseSB2c29jayBzcGVjaWZpYykuDQo+PiAy
KSBJdCBhbGxvd3MgdG8gc2V0IFNPX1JDVkxPV0FUIGFuZCBTT19WTV9TT0NLRVRTX0JVRkZFUl9T
SVpFIG9wdGlvbi4NCj4+IMKgIFdob2xlIHRocm91Z2h0cHV0IGRlcGVuZHMgb24gYm90aCBwYXJh
bWV0ZXJzLg0KPj4gMykgSXQgaXMgbG9jYXRlZCBpbiB0aGUga2VybmVsIHNvdXJjZSB0cmVlLCBz
byBpdCBjb3VsZCBiZSB1cGRhdGVkIGJ5DQo+PiDCoCB0aGUgc2FtZSBwYXRjaHNldCB3aGljaCBj
aGFuZ2VzIHJlbGF0ZWQga2VybmVsIGZ1bmN0aW9uYWxpdHkgaW4gdnNvY2suDQo+Pg0KPj4gSSB1
c2VkIHRoaXMgdXRpbCB2ZXJ5IG9mdGVuIHRvIGNoZWNrIHBlcmZvcm1hbmNlIG9mIG15IHJ4IHpl
cm9jb3B5DQo+PiBzdXBwb3J0KHRoaXMgdG9vbCBoYXMgcnggemVyb2NvcHkgc3VwcG9ydCwgYnV0
IG5vdCBpbiB0aGlzIHBhdGNoc2V0KS4NCj4+DQo+PiBIZXJlIGlzIGNvbXBhcmlzb24gb2Ygb3V0
cHV0cyBmcm9tIHRocmVlIHV0aWxzOiAnaXBlcmYnLCAndXBlcmYnIGFuZA0KPj4gJ3Zzb2NrX3Bl
cmYnLiBJbiBhbGwgdGhyZWUgY2FzZXMgc2VuZGVyIHdhcyBhdCBndWVzdCBzaWRlLiByeCBhbmQN
Cj4+IHR4IGJ1ZmZlcnMgd2VyZSBhbHdheXMgNjRLYihiZWNhdXNlIGJ5IGRlZmF1bHQgJ3VwZXJm
JyB1c2VzIDhLKS4NCj4+DQo+PiBpcGVyZjoNCj4+DQo+PiDCoCBbIElEXSBJbnRlcnZhbMKgwqDC
oMKgwqDCoMKgwqDCoMKgIFRyYW5zZmVywqDCoMKgwqAgQml0cmF0ZQ0KPj4gwqAgW8KgIDVdwqDC
oCAwLjAwLTEwLjAwwqAgc2VjwqAgMTIuOCBHQnl0ZXPCoCAxMS4wIEdiaXRzL3NlYyBzZW5kZXIN
Cj4+IMKgIFvCoCA1XcKgwqAgMC4wMC0xMC4wMMKgIHNlY8KgIDEyLjggR0J5dGVzwqAgMTEuMCBH
Yml0cy9zZWMgcmVjZWl2ZXINCj4+DQo+PiB1cGVyZjoNCj4+DQo+PiDCoCBUb3RhbMKgwqDCoMKg
IDE2LjI3R0IgL8KgIDExLjM2KHMpID3CoMKgwqAgMTIuMzBHYi9zwqDCoMKgwqDCoMKgIDIzNDU1
b3Avcw0KPj4NCj4+IHZzb2NrX3BlcmY6DQo+Pg0KPj4gwqAgdHggcGVyZm9ybWFuY2U6IDEyLjMw
MTUyOSBHYml0cy9zDQo+PiDCoCByeCBwZXJmb3JtYW5jZTogMTIuMjg4MDExIEdiaXRzL3MNCj4+
DQo+PiBSZXN1bHRzIGFyZSBhbG1vc3Qgc2FtZSBpbiBhbGwgdGhyZWUgY2FzZXMuDQo+IA0KPiBU
aGFua3MgZm9yIGNoZWNraW5nIHRoaXMhDQo+IA0KPj4NCj4+IFBhdGNoc2V0IHdhcyByZWJhc2Vk
IGFuZCB0ZXN0ZWQgb24gc2tidWZmIHY4IHBhdGNoIGZyb20gQm9iYnkgRXNobGVtYW46DQo+PiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMjEyMTUwNDM2NDUuMzU0NTEyNy0xLWJv
YmJ5LmVzaGxlbWFuQGJ5dGVkYW5jZS5jb20vDQo+IA0KPiBJIHJldmlld2VkIGFsbCB0aGUgcGF0
Y2hlcywgaW4gdGhlIGxhc3Qgb25lIHRoZXJlIGlzIGp1c3QgdG8gdXBkYXRlIHRoZSBSRUFETUUs
IHNvIEkgdGhpbmsgaXQgaXMgcmVhZHkgZm9yIG5ldC1uZXh0ICh3aGVuIGl0IHdpbGwgcmUtb3Bl
bikuDQpUaGFua3MhIEknbGwgZml4IGl0KGp1c3QgZm9yZ290IGFib3V0IFJFQURNRSkgYW5kIHNl
bmQgdjYgd2l0aCAnbmV0LW5leHQnIHRhZyB3aGVuIG5ldC1uZXh0IHdpbGwgYmUgb3BlbmVkDQo+
IA0KPiBUaGFua3MsDQo+IFN0ZWZhbm8NCj4gDQoNCg==
