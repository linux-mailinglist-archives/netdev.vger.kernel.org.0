Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141AC324FA2
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhBYMEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:04:20 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2588 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhBYMEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:04:10 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4DmWZh1bwBzW7yC;
        Thu, 25 Feb 2021 20:00:44 +0800 (CST)
Received: from dggemm751-chm.china.huawei.com (10.1.198.57) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 25 Feb 2021 20:03:19 +0800
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 dggemm751-chm.china.huawei.com (10.1.198.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Thu, 25 Feb 2021 20:03:19 +0800
Received: from dggeme758-chm.china.huawei.com ([10.6.80.69]) by
 dggeme758-chm.china.huawei.com ([10.6.80.69]) with mapi id 15.01.2106.006;
 Thu, 25 Feb 2021 20:03:19 +0800
From:   "Wanghongzhe (Hongzhe, EulerOS)" <wanghongzhe@huawei.com>
To:     Andy Lutomirski <luto@amacapital.net>
CC:     "keescook@chromium.org" <keescook@chromium.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "wad@chromium.org" <wad@chromium.org>, "yhs@fb.com" <yhs@fb.com>,
        tongxiaomeng <tongxiaomeng@huawei.com>
Subject: RE: [PATCH v3] seccomp: Improve performace by optimizing rmb()
Thread-Topic: [PATCH v3] seccomp: Improve performace by optimizing rmb()
Thread-Index: AQHXCoNzuX/zLaYh0E+0oBVdFxPnyKpm9kQAgAHQ2PA=
Date:   Thu, 25 Feb 2021 12:03:19 +0000
Message-ID: <ed0a760af3d3430baf6ade198ecb2eef@huawei.com>
References: <1614156585-18842-1-git-send-email-wanghongzhe@huawei.com>
 <638D44BA-0ACA-4041-8213-217233656A70@amacapital.net>
In-Reply-To: <638D44BA-0ACA-4041-8213-217233656A70@amacapital.net>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.70]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IE9uIEZlYiAyNCwgMjAyMSwgYXQgMTI6MDMgQU0sIHdhbmdob25nemhlIDx3YW5naG9uZ3po
ZUBodWF3ZWkuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IO+7v0FzIEtlZXMgaGF2ZWQgYWNjZXB0
ZWQgdGhlIHYyIHBhdGNoIGF0IGEzODFiNzBhMSB3aGljaCBqdXN0IHJlcGxhY2VkDQo+ID4gcm1i
KCkgd2l0aCBzbXBfcm1iKCksIHRoaXMgcGF0Y2ggd2lsbCBiYXNlIG9uIHRoYXQgYW5kIGp1c3Qg
YWRqdXN0IHRoZQ0KPiA+IHNtcF9ybWIoKSB0byB0aGUgY29ycmVjdCBwb3NpdGlvbi4NCj4gPg0K
PiA+IEFzIHRoZSBvcmlnaW5hbCBjb21tZW50IHNob3duIChhbmQgaW5kZWVkIGl0IHNob3VsZCBi
ZSk6DQo+ID4gICAvKg0KPiA+ICAgICogTWFrZSBzdXJlIHRoYXQgYW55IGNoYW5nZXMgdG8gbW9k
ZSBmcm9tIGFub3RoZXIgdGhyZWFkIGhhdmUNCj4gPiAgICAqIGJlZW4gc2VlbiBhZnRlciBTWVND
QUxMX1dPUktfU0VDQ09NUCB3YXMgc2Vlbi4NCj4gPiAgICAqLw0KPiA+IHRoZSBzbXBfcm1iKCkg
c2hvdWxkIGJlIHB1dCBiZXR3ZWVuIHJlYWRpbmcgU1lTQ0FMTF9XT1JLX1NFQ0NPTVANCj4gYW5k
DQo+ID4gcmVhZGluZyBzZWNjb21wLm1vZGUgdG8gbWFrZSBzdXJlIHRoYXQgYW55IGNoYW5nZXMg
dG8gbW9kZSBmcm9tDQo+ID4gYW5vdGhlciB0aHJlYWQgaGF2ZSBiZWVuIHNlZW4gYWZ0ZXIgU1lT
Q0FMTF9XT1JLX1NFQ0NPTVAgd2FzIHNlZW4sDQo+IGZvcg0KPiA+IFRTWU5DIHNpdHVhdGlvbi4g
SG93ZXZlciwgaXQgaXMgbWlzcGxhY2VkIGJldHdlZW4gcmVhZGluZyBzZWNjb21wLm1vZGUNCj4g
PiBhbmQgc2VjY29tcC0+ZmlsdGVyLiBUaGlzIGlzc3VlIHNlZW1zIHRvIGJlIG1pc2ludHJvZHVj
ZWQgYXQNCj4gPiAxM2FhNzJmMGZkMGE5Zjk4YTQxY2VmYjY2MjQ4NzI2OWUyZjFhZDY1IHdoaWNo
IGFpbXMgdG8gcmVmYWN0b3IgdGhlDQo+ID4gZmlsdGVyIGNhbGxiYWNrIGFuZCB0aGUgQVBJLiBT
byBsZXQncyBqdXN0IGFkanVzdCB0aGUNCj4gPiBzbXBfcm1iKCkgdG8gdGhlIGNvcnJlY3QgcG9z
aXRpb24uDQo+ID4NCj4gPiBBIG5leHQgb3B0aW1pemF0aW9uIHBhdGNoIHdpbGwgYmUgcHJvdmlk
ZWQgaWYgdGhpcyBhanVzdG1lbnQgaXMgYXBwcm9wcmlhdGUuDQo+IA0KPiBXb3VsZCBpdCBiZSBi
ZXR0ZXIgdG8gbWFrZSB0aGUgc3lzY2FsbCB3b3JrIHJlYWQgYmUgc21wX2xvYWRfYWNxdWlyZSgp
Pw0KPiANCj4gPg0KPiA+IHYyIC0+IHYzOg0KPiA+IC0gbW92ZSB0aGUgc21wX3JtYigpIHRvIHRo
ZSBjb3JyZWN0IHBvc2l0aW9uDQo+ID4NCj4gPiB2MSAtPiB2MjoNCj4gPiAtIG9ubHkgcmVwbGFj
ZSBybWIoKSB3aXRoIHNtcF9ybWIoKQ0KPiA+IC0gcHJvdmlkZSB0aGUgcGVyZm9ybWFuY2UgdGVz
dCBudW1iZXINCj4gPg0KPiA+IFJGQyAtPiB2MToNCj4gPiAtIHJlcGxhY2Ugcm1iKCkgd2l0aCBz
bXBfcm1iKCkNCj4gPiAtIG1vdmUgdGhlIHNtcF9ybWIoKSBsb2dpYyB0byB0aGUgbWlkZGxlIGJl
dHdlZW4gVElGX1NFQ0NPTVAgYW5kIG1vZGUNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IHdhbmdo
b25nemhlIDx3YW5naG9uZ3poZUBodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+IGtlcm5lbC9zZWNj
b21wLmMgfCAxNSArKysrKysrLS0tLS0tLS0NCj4gPiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRp
b25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2tlcm5lbC9zZWNj
b21wLmMgYi9rZXJuZWwvc2VjY29tcC5jIGluZGV4DQo+ID4gMWQ2MGZjMmM5OTg3Li42NGIyMzZj
YjhhN2YgMTAwNjQ0DQo+ID4gLS0tIGEva2VybmVsL3NlY2NvbXAuYw0KPiA+ICsrKyBiL2tlcm5l
bC9zZWNjb21wLmMNCj4gPiBAQCAtMTE2MCwxMiArMTE2MCw2IEBAIHN0YXRpYyBpbnQgX19zZWNj
b21wX2ZpbHRlcihpbnQgdGhpc19zeXNjYWxsLCBjb25zdA0KPiBzdHJ1Y3Qgc2VjY29tcF9kYXRh
ICpzZCwNCj4gPiAgICBpbnQgZGF0YTsNCj4gPiAgICBzdHJ1Y3Qgc2VjY29tcF9kYXRhIHNkX2xv
Y2FsOw0KPiA+DQo+ID4gLSAgICAvKg0KPiA+IC0gICAgICogTWFrZSBzdXJlIHRoYXQgYW55IGNo
YW5nZXMgdG8gbW9kZSBmcm9tIGFub3RoZXIgdGhyZWFkIGhhdmUNCj4gPiAtICAgICAqIGJlZW4g
c2VlbiBhZnRlciBTWVNDQUxMX1dPUktfU0VDQ09NUCB3YXMgc2Vlbi4NCj4gPiAtICAgICAqLw0K
PiA+IC0gICAgc21wX3JtYigpOw0KPiA+IC0NCj4gPiAgICBpZiAoIXNkKSB7DQo+ID4gICAgICAg
IHBvcHVsYXRlX3NlY2NvbXBfZGF0YSgmc2RfbG9jYWwpOw0KPiA+ICAgICAgICBzZCA9ICZzZF9s
b2NhbDsNCj4gPiBAQCAtMTI5MSw3ICsxMjg1LDYgQEAgc3RhdGljIGludCBfX3NlY2NvbXBfZmls
dGVyKGludCB0aGlzX3N5c2NhbGwsDQo+ID4gY29uc3Qgc3RydWN0IHNlY2NvbXBfZGF0YSAqc2Qs
DQo+ID4NCj4gPiBpbnQgX19zZWN1cmVfY29tcHV0aW5nKGNvbnN0IHN0cnVjdCBzZWNjb21wX2Rh
dGEgKnNkKSB7DQo+ID4gLSAgICBpbnQgbW9kZSA9IGN1cnJlbnQtPnNlY2NvbXAubW9kZTsNCj4g
PiAgICBpbnQgdGhpc19zeXNjYWxsOw0KPiA+DQo+ID4gICAgaWYgKElTX0VOQUJMRUQoQ09ORklH
X0NIRUNLUE9JTlRfUkVTVE9SRSkgJiYgQEAgLTEzMDEsNw0KPiArMTI5NCwxMyBAQA0KPiA+IGlu
dCBfX3NlY3VyZV9jb21wdXRpbmcoY29uc3Qgc3RydWN0IHNlY2NvbXBfZGF0YSAqc2QpDQo+ID4g
ICAgdGhpc19zeXNjYWxsID0gc2QgPyBzZC0+bnIgOg0KPiA+ICAgICAgICBzeXNjYWxsX2dldF9u
cihjdXJyZW50LCBjdXJyZW50X3B0X3JlZ3MoKSk7DQo+ID4NCj4gPiAtICAgIHN3aXRjaCAobW9k
ZSkgew0KPiA+ICsgICAgLyoNCj4gPiArICAgICAqIE1ha2Ugc3VyZSB0aGF0IGFueSBjaGFuZ2Vz
IHRvIG1vZGUgZnJvbSBhbm90aGVyIHRocmVhZCBoYXZlDQo+ID4gKyAgICAgKiBiZWVuIHNlZW4g
YWZ0ZXIgU1lTQ0FMTF9XT1JLX1NFQ0NPTVAgd2FzIHNlZW4uDQo+ID4gKyAgICAgKi8NCj4gPiAr
ICAgIHNtcF9ybWIoKTsNCj4gPiArDQo+ID4gKyAgICBzd2l0Y2ggKGN1cnJlbnQtPnNlY2NvbXAu
bW9kZSkgew0KPiA+ICAgIGNhc2UgU0VDQ09NUF9NT0RFX1NUUklDVDoNCj4gPiAgICAgICAgX19z
ZWN1cmVfY29tcHV0aW5nX3N0cmljdCh0aGlzX3N5c2NhbGwpOyAgLyogbWF5IGNhbGwgZG9fZXhp
dCAqLw0KPiA+ICAgICAgICByZXR1cm4gMDsNCj4gPiAtLQ0KPiA+IDIuMTkuMQ0KPiA+DQo+IFdv
dWxkIGl0IGJlIGJldHRlciB0byBtYWtlIHRoZSBzeXNjYWxsIHdvcmsgcmVhZCBiZSBzbXBfbG9h
ZF9hY3F1aXJlKCk/DQpNYXliZSB3ZSBjYW4gZG8gc29tZXRoaW5nIGxpa2UgdGhpcyAodW50ZXN0
ZWQpOiANCl9fc3lzY2FsbF9lbnRlcl9mcm9tX3VzZXJfd29yayhzdHJ1Y3QgcHRfcmVncyAqcmVn
cywgbG9uZyBzeXNjYWxsKQ0Kew0KLSAgICAgIHVuc2lnbmVkIGxvbmcgd29yayA9IFJFQURfT05D
RShjdXJyZW50X3RocmVhZF9pbmZvKCktPnN5c2NhbGxfd29yayk7DQorICAgICB1bnNpZ25lZCBs
b25nIHdvcmsgPSBzbXBfbG9hZF9hY3F1aXJlICgmKGN1cnJlbnRfdGhyZWFkX2luZm8oKS0+c3lz
Y2FsbF93b3JrKSk7DQoNCiAgICAgICBpZiAod29yayAmIFNZU0NBTExfV09SS19FTlRFUikNCiAg
ICAgICAgICAgICAgc3lzY2FsbCA9IHN5c2NhbGxfdHJhY2VfZW50ZXIocmVncywgc3lzY2FsbCwg
d29yayk7DQpIb3dldmVyLCB0aGlzIG1heSBpbnNlcnQgYSBtZW1vcnkgYmFycmllciBhbmQgc2xv
dyBkb3duIGFsbCB3b3JrcyANCmJlaGluZCBpdCBpbiBTWVNDQUxMX1dPUktfRU5URVIsIG5vdCBq
dXN0IHNlY2NvbXAsIHdoaWNoICBpcyBub3QgDQp3ZSB3YW50LiBBbmQgaW4gb3JkZXIgdG8gbWF0
Y2ggd2l0aCB0aGUgc21wX21iX19iZWZvcmVfYXRvbWljKCkgaW4gDQpzZWNjb21wX2Fzc2lnbl9t
b2RlKCkgd2hpY2ggY2FsbGVkIGluIHNlY2NvbXBfc3luY190aHJlYWRzKCksIGl0IGlzIA0KYmV0
dGVyIHRvIHVzZSBzbXBfcm1iKCkgYmV0d2VlbiB0aGUgd29yayBhbmQgbW9kZSByZWFkOg0KICAg
ICAgIHRhc2stPnNlY2NvbXAubW9kZSA9IHNlY2NvbXBfbW9kZTsNCiAgICAgICAvKg0KICAgICAg
ICogTWFrZSBzdXJlIFNZU0NBTExfV09SS19TRUNDT01QIGNhbm5vdCBiZSBzZXQgYmVmb3JlIHRo
ZSBtb2RlIChhbmQNCiAgICAgICAqIGZpbHRlcikgaXMgc2V0Lg0KICAgICAgICovDQoqICAgICAg
c21wX21iX19iZWZvcmVfYXRvbWljKCk7DQogICAgICAgLyogQXNzdW1lIGRlZmF1bHQgc2VjY29t
cCBwcm9jZXNzZXMgd2FudCBzcGVjIGZsYXcgbWl0aWdhdGlvbi4gKi8NCiAgICAgICBpZiAoKGZs
YWdzICYgU0VDQ09NUF9GSUxURVJfRkxBR19TUEVDX0FMTE9XKSA9PSAwKQ0KICAgICAgICAgICAg
ICBhcmNoX3NlY2NvbXBfc3BlY19taXRpZ2F0ZSh0YXNrKTsNCiAgICAgICBzZXRfdGFza19zeXNj
YWxsX3dvcmsodGFzaywgU0VDQ09NUCk7DQoNCg==
