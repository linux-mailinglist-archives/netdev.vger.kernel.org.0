Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960B3653F16
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 12:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiLVLfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 06:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbiLVLfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 06:35:24 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F820FCE8;
        Thu, 22 Dec 2022 03:35:23 -0800 (PST)
Received: from dggpeml100026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nd7WC1WpjzJqbk;
        Thu, 22 Dec 2022 19:34:15 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 dggpeml100026.china.huawei.com (7.185.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 22 Dec 2022 19:35:16 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.034;
 Thu, 22 Dec 2022 19:35:16 +0800
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "aspriel@gmail.com" <aspriel@gmail.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "alsi@bang-olufsen.dk" <alsi@bang-olufsen.dk>,
        "pieterpg@broadcom.com" <pieterpg@broadcom.com>,
        "dekim@broadcom.com" <dekim@broadcom.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: RE: [PATCH] wifi: brcmfmac: unmap dma buffer in
 brcmf_msgbuf_alloc_pktid()
Thread-Topic: [PATCH] wifi: brcmfmac: unmap dma buffer in
 brcmf_msgbuf_alloc_pktid()
Thread-Index: AQHZFWq8yViv4H2Lj0+i8vYu8peAZ654/7AAgACZYfD//3tpgIAAI56AgACPiMA=
Date:   Thu, 22 Dec 2022 11:35:16 +0000
Message-ID: <fc8a7c6ac335473b901aa9815167754f@huawei.com>
References: <20221207013114.1748936-1-shaozhengchao@huawei.com>
 <167164758059.5196.17408082243455710150.kvalo@kernel.org>
 <Y6QJWPDXglDjUP9p@linutronix.de> <87cz8bkeqp.fsf@kernel.org>
 <47236b24-6b47-b03a-c7b8-c46ea07cac6f@huawei.com>
 <6b529058-3650-72bb-7541-9fbfb8c6ad9b@broadcom.com>
In-Reply-To: <6b529058-3650-72bb-7541-9fbfb8c6ad9b@broadcom.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.84.75.11]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBBcmVuZCB2YW4gU3ByaWVsIFtt
YWlsdG86YXJlbmQudmFuc3ByaWVsQGJyb2FkY29tLmNvbV0gDQpTZW50OiBUaHVyc2RheSwgRGVj
ZW1iZXIgMjIsIDIwMjIgNzowMCBQTQ0KVG86IHNoYW96aGVuZ2NoYW8gPHNoYW96aGVuZ2NoYW9A
aHVhd2VpLmNvbT47IEthbGxlIFZhbG8gPGt2YWxvQGtlcm5lbC5vcmc+OyBTZWJhc3RpYW4gQW5k
cnplaiBTaWV3aW9yIDxiaWdlYXN5QGxpbnV0cm9uaXguZGU+DQpDYzogbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBicmNtODAyMTEtZGV2LWxp
c3QucGRsQGJyb2FkY29tLmNvbTsgU0hBLWN5Zm1hYy1kZXYtbGlzdEBpbmZpbmVvbi5jb207IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsg
cGFiZW5pQHJlZGhhdC5jb207IGFzcHJpZWxAZ21haWwuY29tOyBmcmFua3kubGluQGJyb2FkY29t
LmNvbTsgaGFudGUubWV1bGVtYW5AYnJvYWRjb20uY29tOyB3cmlnaHQuZmVuZ0BjeXByZXNzLmNv
bTsgY2hpLWhzaWVuLmxpbkBjeXByZXNzLmNvbTsgYS5mYXRvdW1AcGVuZ3V0cm9uaXguZGU7IGFs
c2lAYmFuZy1vbHVmc2VuLmRrOyBwaWV0ZXJwZ0Bicm9hZGNvbS5jb207IGRla2ltQGJyb2FkY29t
LmNvbTsgbGludmlsbGVAdHV4ZHJpdmVyLmNvbTsgd2VpeW9uZ2p1biAoQSkgPHdlaXlvbmdqdW4x
QGh1YXdlaS5jb20+OyB5dWVoYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQpTdWJqZWN0
OiBSZTogW1BBVENIXSB3aWZpOiBicmNtZm1hYzogdW5tYXAgZG1hIGJ1ZmZlciBpbiBicmNtZl9t
c2didWZfYWxsb2NfcGt0aWQoKQ0KDQpPbiAxMi8yMi8yMDIyIDk6NTIgQU0sIHNoYW96aGVuZ2No
YW8gd3JvdGU6DQo+IA0KPiANCj4gT24gMjAyMi8xMi8yMiAxNjo0NiwgS2FsbGUgVmFsbyB3cm90
ZToNCj4+IFNlYmFzdGlhbiBBbmRyemVqIFNpZXdpb3IgPGJpZ2Vhc3lAbGludXRyb25peC5kZT4g
d3JpdGVzOg0KPj4NCj4+PiBPbiAyMDIyLTEyLTIxIDE4OjMzOjA2IFsrMDAwMF0sIEthbGxlIFZh
bG8gd3JvdGU6DQo+Pj4+IFpoZW5nY2hhbyBTaGFvIDxzaGFvemhlbmdjaGFvQGh1YXdlaS5jb20+
IHdyb3RlOg0KPj4+Pg0KPj4+Pj4gQWZ0ZXIgdGhlIERNQSBidWZmZXIgaXMgbWFwcGVkIHRvIGEg
cGh5c2ljYWwgYWRkcmVzcywgYWRkcmVzcyBpcyANCj4+Pj4+IHN0b3JlZA0KPj4+Pj4gaW4gcGt0
aWRzIGluIGJyY21mX21zZ2J1Zl9hbGxvY19wa3RpZCgpLiBUaGVuLCBwa3RpZHMgaXMgcGFyc2Vk
IGluDQo+Pj4+PiBicmNtZl9tc2didWZfZ2V0X3BrdGlkKCkvYnJjbWZfbXNnYnVmX3JlbGVhc2Vf
YXJyYXkoKSB0byBvYnRhaW4gDQo+Pj4+PiBwaHlzYWRkcg0KPj4+Pj4gYW5kIGxhdGVyIHVubWFw
IHRoZSBETUEgYnVmZmVyLiBCdXQgd2hlbiBjb3VudCBpcyBhbHdheXMgZXF1YWwgdG8NCj4+Pj4+
IHBrdGlkcy0+YXJyYXlfc2l6ZSwgcGh5c2FkZHIgaXNuJ3Qgc3RvcmVkIGluIHBrdGlkcyBhbmQg
dGhlIERNQSBidWZmZXINCj4+Pj4+IHdpbGwgbm90IGJlIHVubWFwcGVkIGFueXdheS4NCj4+Pj4+
DQo+Pj4+PiBGaXhlczogOWExYmI2MDI1MGQyICgiYnJjbWZtYWM6IEFkZGluZyBtc2didWYgcHJv
dG9jb2wuIikNCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFpoZW5nY2hhbyBTaGFvIDxzaGFvemhlbmdj
aGFvQGh1YXdlaS5jb20+DQo+Pj4+DQo+Pj4+IENhbiBzb21lb25lIHJldmlldyB0aGlzPw0KPj4+
DQo+Pj4gQWZ0ZXIgbG9va2luZyBhdCB0aGUgY29kZSwgdGhhdCBza2IgaXMgbWFwcGVkIGJ1dCBu
b3QgaW5zZXJ0ZWQgaW50byB0aGUNCj4+PiByaW5nYnVmZmVyIGluIHRoaXMgY29uZGl0aW9uLiBU
aGUgZnVuY3Rpb24gcmV0dXJucyB3aXRoIGFuIGVycm9yIGFuZCB0aGUNCj4+PiBjYWxsZXIgd2ls
bCBmcmVlIHRoYXQgc2tiIChvciBhZGQgdG8gYSBsaXN0IGZvciBsYXRlcikuIEVpdGhlciB3YXkg
dGhlDQo+Pj4gc2tiIHJlbWFpbnMgbWFwcGVkIHdoaWNoIGlzIHdyb25nLiBUaGUgdW5tYXAgaGVy
ZSBpcyB0aGUgcmlnaHQgdGhpbmcgdG8NCj4+PiBkby4NCj4+Pg0KPj4+IFJldmlld2VkLWJ5OiBT
ZWJhc3RpYW4gQW5kcnplaiBTaWV3aW9yIDxiaWdlYXN5QGxpbnV0cm9uaXguZGU+DQo+Pg0KPj4g
VGhhbmtzIGZvciB0aGUgcmV2aWV3LCB2ZXJ5IG11Y2ggYXBwcmVjaWF0ZWQuDQo+Pg0KPiANCj4g
VGhhbmsgeW91IHZlcnkgbXVjaC4NCg0KPkdvb2QgY2F0Y2guIEhhcyB0aGlzIHBhdGggYmVlbiBv
YnNlcnZlZCBvciBpcyB0aGlzIGZvdW5kIGJ5IGluc3BlY3RpbmcgDQo+dGhlIGNvZGU/IEp1c3Qg
Y3VyaW91cy4NCg0KPlJlZ2FyZHMsDQo+QXJlbmQNCg0KSGkgQXJlbmTvvJoNCglJIHJldmlldyBj
b2RlIGFuZCBmaW5kIHRoZSBidWcuIA0KDQpaaGVuZ2NoYW8gU2hhbw0K
