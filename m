Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C4830B4DC
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhBBBvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:51:06 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2574 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhBBBvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 20:51:03 -0500
Received: from dggeme708-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4DV74Y4XV4zW3WX;
        Tue,  2 Feb 2021 09:48:13 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 dggeme708-chm.china.huawei.com (10.1.199.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 2 Feb 2021 09:50:18 +0800
Received: from dggeme758-chm.china.huawei.com ([10.6.80.69]) by
 dggeme758-chm.china.huawei.com ([10.6.80.69]) with mapi id 15.01.2106.006;
 Tue, 2 Feb 2021 09:50:18 +0800
From:   "Wanghongzhe (Hongzhe, EulerOS)" <wanghongzhe@huawei.com>
To:     Andy Lutomirski <luto@amacapital.net>
CC:     "keescook@chromium.org" <keescook@chromium.org>,
        "wad@chromium.org" <wad@chromium.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] seccomp: Improve performance by optimizing memory barrier
Thread-Topic: [PATCH] seccomp: Improve performance by optimizing memory
 barrier
Thread-Index: AQHW+JKVO2If6N9YNUuKsZSbR9a9o6pC6YoAgAEvrUA=
Date:   Tue, 2 Feb 2021 01:50:18 +0000
Message-ID: <003c156cf88c4ccd82d50e450c4696ed@huawei.com>
References: <1612183830-15506-1-git-send-email-wanghongzhe@huawei.com>
 <B1DC6A42-15AF-4804-B20E-FC6E2BDD1C8E@amacapital.net>
In-Reply-To: <B1DC6A42-15AF-4804-B20E-FC6E2BDD1C8E@amacapital.net>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.177.164]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+PiBPbiBGZWIgMSwgMjAyMSwgYXQgNDowNiBBTSwgd2FuZ2hvbmd6aGUgPHdhbmdob25nemhl
QGh1YXdlaS5jb20+IHdyb3RlOg0KPj4gDQo+PiDvu79JZiBhIHRocmVhZChBKSdzIFRTWU5DIGZs
YWcgaXMgc2V0IGZyb20gc2VjY29tcCgpLCB0aGVuIGl0IHdpbGwgDQo+PiBzeW5jaHJvbml6ZSBp
dHMgc2VjY29tcCBmaWx0ZXIgdG8gb3RoZXIgdGhyZWFkcyhCKSBpbiBzYW1lIHRocmVhZCANCj4+
IGdyb3VwLiBUbyBhdm9pZCByYWNlIGNvbmRpdGlvbiwgc2VjY29tcCBwdXRzIHJtYigpIGJldHdl
ZW4gcmVhZGluZyB0aGUgDQo+PiBtb2RlIGFuZCBmaWx0ZXIgaW4gc2VjY29tcCBjaGVjayBwYXRj
aChpbiBCIHRocmVhZCkuDQo+PiBBcyBhIHJlc3VsdCwgZXZlcnkgc3lzY2FsbCdzIHNlY2NvbXAg
Y2hlY2sgaXMgc2xvd2VkIGRvd24gYnkgdGhlIA0KPj4gbWVtb3J5IGJhcnJpZXIuDQo+PiANCj4+
IEhvd2V2ZXIsIHdlIGNhbiBvcHRpbWl6ZSBpdCBieSBjYWxsaW5nIHJtYigpIG9ubHkgd2hlbiBm
aWx0ZXIgaXMgTlVMTCANCj4+IGFuZCByZWFkaW5nIGl0IGFnYWluIGFmdGVyIHRoZSBiYXJyaWVy
LCB3aGljaCBtZWFucyB0aGUgcm1iKCkgaXMgDQo+PiBjYWxsZWQgb25seSBvbmNlIGluIHRocmVh
ZCBsaWZldGltZS4NCj4+IA0KPj4gVGhlICdmaWx0ZXIgaXMgTlVMTCcgY29uZGl0b24gbWVhbnMg
dGhhdCBpdCBpcyB0aGUgZmlyc3QgdGltZSANCj4+IGF0dGFjaGluZyBmaWx0ZXIgYW5kIGlzIGJ5
IG90aGVyIHRocmVhZChBKSB1c2luZyBUU1lOQyBmbGFnLg0KPj4gSW4gdGhpcyBjYXNlLCB0aHJl
YWQgQiBtYXkgcmVhZCB0aGUgZmlsdGVyIGZpcnN0IGFuZCBtb2RlIGxhdGVyIGluIENQVSANCj4+
IG91dC1vZi1vcmRlciBleGVjdGlvbi4gQWZ0ZXIgdGhpcyB0aW1lLCB0aGUgdGhyZWFkIEIncyBt
b2RlIGlzIGFsd2F5cyANCj4+IGJlIHNldCwgYW5kIHRoZXJlIHdpbGwgbm8gcmFjZSBjb25kaXRp
b24gd2l0aCB0aGUgZmlsdGVyL2JpdG1hcC4NCj4+IA0KPj4gSW4gYWRkdGlvbiwgd2Ugc2hvdWxk
IHB1dHMgYSB3cml0ZSBtZW1vcnkgYmFycmllciBiZXR3ZWVuIHdyaXRpbmcgdGhlIA0KPj4gZmls
dGVyIGFuZCBtb2RlIGluIHNtcF9tYl9fYmVmb3JlX2F0b21pYygpLCB0byBhdm9pZCB0aGUgcmFj
ZSANCj4+IGNvbmRpdGlvbiBpbiBUU1lOQyBjYXNlLg0KPg0KPiBJIGhhdmVu4oCZdCBmdWxseSB3
b3JrZWQgdGhpcyBvdXQsIGJ1dCBybWIoKSBpcyBib2d1cy4gVGhpcyBzaG91bGQgYmUgc21wX3Jt
YigpLg0KDQpZZXMsIEkgdGhpbmsgeW91IGFyZSByaWdodC5JIHdpbGwgZml4IGl0IGFuZCBzZW5k
IGFub3RoZXIgcGF0Y2guDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IHdhbmdob25nemhlIDx3YW5n
aG9uZ3poZUBodWF3ZWkuY29tPg0KPj4gLS0tDQo+PiBrZXJuZWwvc2VjY29tcC5jIHwgMzEgKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDIyIGluc2Vy
dGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9rZXJuZWwvc2Vj
Y29tcC5jIGIva2VybmVsL3NlY2NvbXAuYyBpbmRleCANCj4+IDk1MmRjMWM5MDIyOS4uYjk0NGNi
MmI2Yjk0IDEwMDY0NA0KPj4gLS0tIGEva2VybmVsL3NlY2NvbXAuYw0KPj4gKysrIGIva2VybmVs
L3NlY2NvbXAuYw0KPj4gQEAgLTM5Nyw4ICszOTcsMjAgQEAgc3RhdGljIHUzMiBzZWNjb21wX3J1
bl9maWx0ZXJzKGNvbnN0IHN0cnVjdCBzZWNjb21wX2RhdGEgKnNkLA0KPj4gICAgICAgICAgICBS
RUFEX09OQ0UoY3VycmVudC0+c2VjY29tcC5maWx0ZXIpOw0KPj4gDQo+PiAgICAvKiBFbnN1cmUg
dW5leHBlY3RlZCBiZWhhdmlvciBkb2Vzbid0IHJlc3VsdCBpbiBmYWlsaW5nIG9wZW4uICovDQo+
PiAtICAgIGlmIChXQVJOX09OKGYgPT0gTlVMTCkpDQo+PiAtICAgICAgICByZXR1cm4gU0VDQ09N
UF9SRVRfS0lMTF9QUk9DRVNTOw0KPj4gKyAgICBpZiAoV0FSTl9PTihmID09IE5VTEwpKSB7DQo+
PiArICAgICAgICAvKg0KPj4gKyAgICAgICAgICogTWFrZSBzdXJlIHRoZSBmaXJzdCBmaWx0ZXIg
YWRkdGlvbiAoZnJvbSBhbm90aGVyDQo+PiArICAgICAgICAgKiB0aHJlYWQgdXNpbmcgVFNZTkMg
ZmxhZykgYXJlIHNlZW4uDQo+PiArICAgICAgICAgKi8NCj4+ICsgICAgICAgIHJtYigpOw0KPj4g
KyAgICAgICAgDQo+PiArICAgICAgICAvKiBSZWFkIGFnYWluICovDQo+PiArICAgICAgICBmID0g
UkVBRF9PTkNFKGN1cnJlbnQtPnNlY2NvbXAuZmlsdGVyKTsNCj4+ICsNCj4+ICsgICAgICAgIC8q
IEVuc3VyZSB1bmV4cGVjdGVkIGJlaGF2aW9yIGRvZXNuJ3QgcmVzdWx0IGluIGZhaWxpbmcgb3Bl
bi4gKi8NCj4+ICsgICAgICAgIGlmIChXQVJOX09OKGYgPT0gTlVMTCkpDQo+PiArICAgICAgICAg
ICAgcmV0dXJuIFNFQ0NPTVBfUkVUX0tJTExfUFJPQ0VTUzsNCj4+ICsgICAgfQ0KPj4gDQo+PiAg
ICBpZiAoc2VjY29tcF9jYWNoZV9jaGVja19hbGxvdyhmLCBzZCkpDQo+PiAgICAgICAgcmV0dXJu
IFNFQ0NPTVBfUkVUX0FMTE9XOw0KPj4gQEAgLTYxNCw5ICs2MjYsMTYgQEAgc3RhdGljIGlubGlu
ZSB2b2lkIHNlY2NvbXBfc3luY190aHJlYWRzKHVuc2lnbmVkIGxvbmcgZmxhZ3MpDQo+PiAgICAg
ICAgICogZXF1aXZhbGVudCAoc2VlIHB0cmFjZV9tYXlfYWNjZXNzKSwgaXQgaXMgc2FmZSB0bw0K
Pj4gICAgICAgICAqIGFsbG93IG9uZSB0aHJlYWQgdG8gdHJhbnNpdGlvbiB0aGUgb3RoZXIuDQo+
PiAgICAgICAgICovDQo+PiAtICAgICAgICBpZiAodGhyZWFkLT5zZWNjb21wLm1vZGUgPT0gU0VD
Q09NUF9NT0RFX0RJU0FCTEVEKQ0KPj4gKyAgICAgICAgaWYgKHRocmVhZC0+c2VjY29tcC5tb2Rl
ID09IFNFQ0NPTVBfTU9ERV9ESVNBQkxFRCkgew0KPj4gKyAgICAgICAgICAgIC8qDQo+PiArICAg
ICAgICAgICAgICogTWFrZSBzdXJlIG1vZGUgY2Fubm90IGJlIHNldCBiZWZvcmUgdGhlIGZpbHRl
cg0KPj4gKyAgICAgICAgICAgICAqIGFyZSBzZXQuDQo+PiArICAgICAgICAgICAgICovDQo+PiAr
ICAgICAgICAgICAgc21wX21iX19iZWZvcmVfYXRvbWljKCk7DQo+PiArDQo+PiAgICAgICAgICAg
IHNlY2NvbXBfYXNzaWduX21vZGUodGhyZWFkLCBTRUNDT01QX01PREVfRklMVEVSLA0KPj4gICAg
ICAgICAgICAgICAgICAgICAgICBmbGFncyk7DQo+PiArICAgICAgICB9DQo+PiAgICB9DQo+PiB9
DQo+PiANCj4+IEBAIC0xMTYwLDEyICsxMTc5LDYgQEAgc3RhdGljIGludCBfX3NlY2NvbXBfZmls
dGVyKGludCB0aGlzX3N5c2NhbGwsIGNvbnN0IHN0cnVjdCBzZWNjb21wX2RhdGEgKnNkLA0KPj4g
ICAgaW50IGRhdGE7DQo+PiAgICBzdHJ1Y3Qgc2VjY29tcF9kYXRhIHNkX2xvY2FsOw0KPj4gDQo+
PiAtICAgIC8qDQo+PiAtICAgICAqIE1ha2Ugc3VyZSB0aGF0IGFueSBjaGFuZ2VzIHRvIG1vZGUg
ZnJvbSBhbm90aGVyIHRocmVhZCBoYXZlDQo+PiAtICAgICAqIGJlZW4gc2VlbiBhZnRlciBTWVND
QUxMX1dPUktfU0VDQ09NUCB3YXMgc2Vlbi4NCj4+IC0gICAgICovDQo+PiAtICAgIHJtYigpOw0K
Pj4gLQ0KPj4gICAgaWYgKCFzZCkgew0KPj4gICAgICAgIHBvcHVsYXRlX3NlY2NvbXBfZGF0YSgm
c2RfbG9jYWwpOw0KPj4gICAgICAgIHNkID0gJnNkX2xvY2FsOw0KPj4gLS0NCj4+IDIuMTkuMQ0K
Pj4gDQo=
