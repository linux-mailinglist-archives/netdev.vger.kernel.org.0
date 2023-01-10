Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68256663DF8
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237868AbjAJKVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237896AbjAJKVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:21:20 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689FD5370C;
        Tue, 10 Jan 2023 02:20:25 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id BDB785FD07;
        Tue, 10 Jan 2023 13:20:23 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1673346023;
        bh=MCDL6hHQ5CdhvuYYF3vxcjATyDTPwJu/vj+j+6YM6eY=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=oN48YfnwsRcvUCbdTfcjIlrlFKndxoX6XopAJGHwkCgOwLD7Uqnyea1HSM3zZJnbr
         tISTgYkvPw24uLVVo+b2ROSTSDj1y5F+OPVuGAY3j+0ygNeg/IbP1/hbzz4QN07lWj
         GBw52fOFKkqfIYKezwfCxELh63vblsC2cnFLnZlqFtk/PnYsocFMSuJS93IjzJXoC+
         R0LK8d8NVHpcUw8gCBb4CNhm3lrsm7YEzVHG+NJxxUt3CTyzBLVFNwzgu00k9i9uWU
         rEmJ7v/iRfGZ9dBkCaoh6I/kWzNs9nxcyZ3fudEuz2WccJLFza7+ss6emIjiebto8o
         U1AY/no5XYUPw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 10 Jan 2023 13:20:23 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Paolo Abeni <pabeni@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: Re: [PATCH net-next v6 4/4] test/vsock: vsock_perf utility
Thread-Topic: [PATCH net-next v6 4/4] test/vsock: vsock_perf utility
Thread-Index: AQHZI6HpKXQv2hn3PkaMIhtl1Kn6Pa6XNJwAgAALnIA=
Date:   Tue, 10 Jan 2023 10:20:22 +0000
Message-ID: <6a82d5c7-7718-a488-1827-feac5770fd1d@sberdevices.ru>
References: <eaf9598f-27eb-8df0-1dea-b4c5623adba1@sberdevices.ru>
 <5c8b538bcc9ac75027f41c21e810d3707a2e1ec7.camel@redhat.com>
In-Reply-To: <5c8b538bcc9ac75027f41c21e810d3707a2e1ec7.camel@redhat.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEC5A1AC4BC5254EA50715EEA7411946@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/01/10 08:25:00 #20754977
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAuMDEuMjAyMyAxMjozNiwgUGFvbG8gQWJlbmkgd3JvdGU6DQo+IEhpLA0KPiANCj4gc29y
cnkgZm9yIHRoZSBsYXRlIGZlZWRiYWNrLCBhIGNvdXBsZSBvZiBub3RlcyBiZWxvdy4uLg0KDQpI
ZWxsbyEgVGhhbmtzIGZvciByZXZpZXchIGp1c3QgZml4ZWQgaXQgaW4gdjcNCg0KVGhhbmtzLCBB
cnNlbml5DQoNCj4gDQo+IE9uIFN1biwgMjAyMy0wMS0wOCBhdCAyMDo0MyArMDAwMCwgQXJzZW5p
eSBLcmFzbm92IHdyb3RlOg0KPj4gVGhpcyBhZGRzIHV0aWxpdHkgdG8gY2hlY2sgdnNvY2sgcngv
dHggcGVyZm9ybWFuY2UuDQo+Pg0KPj4gVXNhZ2UgYXMgc2VuZGVyOg0KPj4gLi92c29ja19wZXJm
IC0tc2VuZGVyIDxjaWQ+IC0tcG9ydCA8cG9ydD4gLS1ieXRlcyA8Ynl0ZXMgdG8gc2VuZD4NCj4+
IFVzYWdlIGFzIHJlY2VpdmVyOg0KPj4gLi92c29ja19wZXJmIC0tcG9ydCA8cG9ydD4gLS1yY3Zs
b3dhdCA8U09fUkNWTE9XQVQ+DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92
IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQo+PiBSZXZpZXdlZC1ieTogU3RlZmFubyBHYXJ6
YXJlbGxhIDxzZ2FyemFyZUByZWRoYXQuY29tPg0KPj4gLS0tDQo+PiAgdG9vbHMvdGVzdGluZy92
c29jay9NYWtlZmlsZSAgICAgfCAgIDMgKy0NCj4+ICB0b29scy90ZXN0aW5nL3Zzb2NrL1JFQURN
RSAgICAgICB8ICAzNCArKysNCj4+ICB0b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3BlcmYuYyB8
IDQ0MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+PiAgMyBmaWxlcyBjaGFuZ2Vk
LCA0NzcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4gIGNyZWF0ZSBtb2RlIDEwMDY0
NCB0b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3BlcmYuYw0KPj4NCj4+IGRpZmYgLS1naXQgYS90
b29scy90ZXN0aW5nL3Zzb2NrL01ha2VmaWxlIGIvdG9vbHMvdGVzdGluZy92c29jay9NYWtlZmls
ZQ0KPj4gaW5kZXggZjgyOTNjNjkxMGM5Li40M2EyNTRmMGUxNGQgMTAwNjQ0DQo+PiAtLS0gYS90
b29scy90ZXN0aW5nL3Zzb2NrL01ha2VmaWxlDQo+PiArKysgYi90b29scy90ZXN0aW5nL3Zzb2Nr
L01ha2VmaWxlDQo+PiBAQCAtMSw4ICsxLDkgQEANCj4+ICAjIFNQRFgtTGljZW5zZS1JZGVudGlm
aWVyOiBHUEwtMi4wLW9ubHkNCj4+IC1hbGw6IHRlc3QNCj4+ICthbGw6IHRlc3QgdnNvY2tfcGVy
Zg0KPj4gIHRlc3Q6IHZzb2NrX3Rlc3QgdnNvY2tfZGlhZ190ZXN0DQo+PiAgdnNvY2tfdGVzdDog
dnNvY2tfdGVzdC5vIHRpbWVvdXQubyBjb250cm9sLm8gdXRpbC5vDQo+PiAgdnNvY2tfZGlhZ190
ZXN0OiB2c29ja19kaWFnX3Rlc3QubyB0aW1lb3V0Lm8gY29udHJvbC5vIHV0aWwubw0KPj4gK3Zz
b2NrX3BlcmY6IHZzb2NrX3BlcmYubw0KPj4gIA0KPj4gIENGTEFHUyArPSAtZyAtTzIgLVdlcnJv
ciAtV2FsbCAtSS4gLUkuLi8uLi9pbmNsdWRlIC1JLi4vLi4vLi4vdXNyL2luY2x1ZGUgLVduby1w
b2ludGVyLXNpZ24gLWZuby1zdHJpY3Qtb3ZlcmZsb3cgLWZuby1zdHJpY3QtYWxpYXNpbmcgLWZu
by1jb21tb24gLU1NRCAtVV9GT1JUSUZZX1NPVVJDRSAtRF9HTlVfU09VUkNFDQo+PiAgLlBIT05Z
OiBhbGwgdGVzdCBjbGVhbg0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svUkVB
RE1FIGIvdG9vbHMvdGVzdGluZy92c29jay9SRUFETUUNCj4+IGluZGV4IDRkNTA0NWU3ZDJjMy4u
ODRlZTIxN2JhOGVlIDEwMDY0NA0KPj4gLS0tIGEvdG9vbHMvdGVzdGluZy92c29jay9SRUFETUUN
Cj4+ICsrKyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svUkVBRE1FDQo+PiBAQCAtMzUsMyArMzUsMzcg
QEAgSW52b2tlIHRlc3QgYmluYXJpZXMgaW4gYm90aCBkaXJlY3Rpb25zIGFzIGZvbGxvd3M6DQo+
PiAgICAgICAgICAgICAgICAgICAgICAgICAtLWNvbnRyb2wtcG9ydD0kR1VFU1RfSVAgXA0KPj4g
ICAgICAgICAgICAgICAgICAgICAgICAgLS1jb250cm9sLXBvcnQ9MTIzNCBcDQo+PiAgICAgICAg
ICAgICAgICAgICAgICAgICAtLXBlZXItY2lkPTMNCj4+ICsNCj4+ICt2c29ja19wZXJmIHV0aWxp
dHkNCj4+ICstLS0tLS0tLS0tLS0tLS0tLS0tDQo+PiArJ3Zzb2NrX3BlcmYnIGlzIGEgc2ltcGxl
IHRvb2wgdG8gbWVhc3VyZSB2c29jayBwZXJmb3JtYW5jZS4gSXQgd29ya3MgaW4NCj4+ICtzZW5k
ZXIvcmVjZWl2ZXIgbW9kZXM6IHNlbmRlciBjb25uZWN0IHRvIHBlZXIgYXQgdGhlIHNwZWNpZmll
ZCBwb3J0IGFuZA0KPj4gK3N0YXJ0cyBkYXRhIHRyYW5zbWlzc2lvbiB0byB0aGUgcmVjZWl2ZXIu
IEFmdGVyIGRhdGEgcHJvY2Vzc2luZyBpcyBkb25lLA0KPj4gK2l0IHByaW50cyBzZXZlcmFsIG1l
dHJpY3Moc2VlIGJlbG93KS4NCj4+ICsNCj4+ICtVc2FnZToNCj4+ICsjIHJ1biBhcyBzZW5kZXIN
Cj4+ICsjIGNvbm5lY3QgdG8gQ0lEIDIsIHBvcnQgMTIzNCwgc2VuZCAxRyBvZiBkYXRhLCB0eCBi
dWYgc2l6ZSBpcyAxTQ0KPj4gKy4vdnNvY2tfcGVyZiAtLXNlbmRlciAyIC0tcG9ydCAxMjM0IC0t
Ynl0ZXMgMUcgLS1idWYtc2l6ZSAxTQ0KPj4gKw0KPj4gK091dHB1dDoNCj4+ICt0eCBwZXJmb3Jt
YW5jZTogQSBHYml0cy9zDQo+PiArDQo+PiArT3V0cHV0IGV4cGxhbmF0aW9uOg0KPj4gK0EgaXMg
Y2FsY3VsYXRlZCBhcyAibnVtYmVyIG9mIGJpdHMgdG8gc2VuZCIgLyAidGltZSBpbiB0eCBsb29w
Ig0KPj4gKw0KPj4gKyMgcnVuIGFzIHJlY2VpdmVyDQo+PiArIyBsaXN0ZW4gcG9ydCAxMjM0LCBy
eCBidWYgc2l6ZSBpcyAxTSwgc29ja2V0IGJ1ZiBzaXplIGlzIDFHLCBTT19SQ1ZMT1dBVCBpcyA2
NEsNCj4+ICsuL3Zzb2NrX3BlcmYgLS1wb3J0IDEyMzQgLS1idWYtc2l6ZSAxTSAtLXZzay1zaXpl
IDFHIC0tcmN2bG93YXQgNjRLDQo+PiArDQo+PiArT3V0cHV0Og0KPj4gK3J4IHBlcmZvcm1hbmNl
OiBBIEdiaXRzL3MNCj4+ICt0b3RhbCBpbiAncmVhZCgpJzogQiBzZWMNCj4+ICtQT0xMSU4gd2Fr
ZXVwczogQw0KPj4gK2F2ZXJhZ2UgaW4gJ3JlYWQoKSc6IEQgbnMNCj4+ICsNCj4+ICtPdXRwdXQg
ZXhwbGFuYXRpb246DQo+PiArQSBpcyBjYWxjdWxhdGVkIGFzICJudW1iZXIgb2YgcmVjZWl2ZWQg
Yml0cyIgLyAidGltZSBpbiByeCBsb29wIi4NCj4+ICtCIGlzIHRpbWUsIHNwZW50IGluICdyZWFk
KCknIHN5c3RlbSBjYWxsKGV4Y2x1ZGluZyAncG9sbCgpJykNCj4+ICtDIGlzIG51bWJlciBvZiAn
cG9sbCgpJyB3YWtlIHVwcyB3aXRoIFBPTExJTiBiaXQgc2V0Lg0KPj4gK0QgaXMgQiAvIEMsIGUu
Zy4gYXZlcmFnZSBhbW91bnQgb2YgdGltZSwgc3BlbnQgaW4gc2luZ2xlICdyZWFkKCknLg0KPj4g
ZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfcGVyZi5jIGIvdG9vbHMvdGVz
dGluZy92c29jay92c29ja19wZXJmLmMNCj4+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+PiBpbmRl
eCAwMDAwMDAwMDAwMDAuLmNjZDU5NTQ2MmI0MA0KPj4gLS0tIC9kZXYvbnVsbA0KPj4gKysrIGIv
dG9vbHMvdGVzdGluZy92c29jay92c29ja19wZXJmLmMNCj4+IEBAIC0wLDAgKzEsNDQxIEBADQo+
PiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQ0KPj4gKy8qDQo+PiAr
ICogdnNvY2tfcGVyZiAtIGJlbmNobWFyayB1dGlsaXR5IGZvciB2c29jay4NCj4+ICsgKg0KPj4g
KyAqIENvcHlyaWdodCAoQykgMjAyMiBTYmVyRGV2aWNlcy4NCj4+ICsgKg0KPj4gKyAqIEF1dGhv
cjogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQo+PiArICovDQo+
PiArI2luY2x1ZGUgPGdldG9wdC5oPg0KPj4gKyNpbmNsdWRlIDxzdGRpby5oPg0KPj4gKyNpbmNs
dWRlIDxzdGRsaWIuaD4NCj4+ICsjaW5jbHVkZSA8c3RkYm9vbC5oPg0KPj4gKyNpbmNsdWRlIDxz
dHJpbmcuaD4NCj4+ICsjaW5jbHVkZSA8ZXJybm8uaD4NCj4+ICsjaW5jbHVkZSA8dW5pc3RkLmg+
DQo+PiArI2luY2x1ZGUgPHRpbWUuaD4NCj4+ICsjaW5jbHVkZSA8c3RkaW50Lmg+DQo+PiArI2lu
Y2x1ZGUgPHBvbGwuaD4NCj4+ICsjaW5jbHVkZSA8c3lzL3NvY2tldC5oPg0KPj4gKyNpbmNsdWRl
IDxsaW51eC92bV9zb2NrZXRzLmg+DQo+PiArDQo+PiArI2RlZmluZSBERUZBVUxUX0JVRl9TSVpF
X0JZVEVTCSgxMjggKiAxMDI0KQ0KPj4gKyNkZWZpbmUgREVGQVVMVF9UT19TRU5EX0JZVEVTCSg2
NCAqIDEwMjQpDQo+PiArI2RlZmluZSBERUZBVUxUX1ZTT0NLX0JVRl9CWVRFUyAoMjU2ICogMTAy
NCkNCj4+ICsjZGVmaW5lIERFRkFVTFRfUkNWTE9XQVRfQllURVMJMQ0KPj4gKyNkZWZpbmUgREVG
QVVMVF9QT1JUCQkxMjM0DQo+PiArDQo+PiArI2RlZmluZSBCWVRFU19QRVJfR0IJCSgxMDI0ICog
MTAyNCAqIDEwMjRVTEwpDQo+PiArI2RlZmluZSBOU0VDX1BFUl9TRUMJCSgxMDAwMDAwMDAwVUxM
KQ0KPj4gKw0KPj4gK3N0YXRpYyB1bnNpZ25lZCBpbnQgcG9ydCA9IERFRkFVTFRfUE9SVDsNCj4+
ICtzdGF0aWMgdW5zaWduZWQgbG9uZyBidWZfc2l6ZV9ieXRlcyA9IERFRkFVTFRfQlVGX1NJWkVf
QllURVM7DQo+PiArc3RhdGljIHVuc2lnbmVkIGxvbmcgdnNvY2tfYnVmX2J5dGVzID0gREVGQVVM
VF9WU09DS19CVUZfQllURVM7DQo+PiArDQo+PiArc3RhdGljIGlubGluZSB0aW1lX3QgY3VycmVu
dF9uc2VjKHZvaWQpDQo+IA0KPiBNaW5vciBuaXQ6IHlvdSBzaG91bGQgYXZvaWQgJ3N0YXRpYyBp
bmxpbmUnIGZ1bmN0aW9ucyBpbiBjIGZpbGVzLA0KPiAnc3RhdGljJyB3b3VsZCBzdWZmaWNlIGFu
ZCB3aWxsIGFsbG93IHRoZSBjb21waWxlciB0byBkbyBhIGJldHRlciBqb2IuDQo+IA0KPj4gK3sN
Cj4+ICsJc3RydWN0IHRpbWVzcGVjIHRzOw0KPj4gKw0KPj4gKwlpZiAoY2xvY2tfZ2V0dGltZShD
TE9DS19SRUFMVElNRSwgJnRzKSkgew0KPj4gKwkJcGVycm9yKCJjbG9ja19nZXR0aW1lIik7DQo+
PiArCQlleGl0KEVYSVRfRkFJTFVSRSk7DQo+PiArCX0NCj4+ICsNCj4+ICsJcmV0dXJuICh0cy50
dl9zZWMgKiBOU0VDX1BFUl9TRUMpICsgdHMudHZfbnNlYzsNCj4+ICt9DQo+PiArDQo+PiArLyog
RnJvbSBsaWIvY21kbGluZS5jLiAqLw0KPj4gK3N0YXRpYyB1bnNpZ25lZCBsb25nIG1lbXBhcnNl
KGNvbnN0IGNoYXIgKnB0cikNCj4+ICt7DQo+PiArCWNoYXIgKmVuZHB0cjsNCj4+ICsNCj4+ICsJ
dW5zaWduZWQgbG9uZyBsb25nIHJldCA9IHN0cnRvdWxsKHB0ciwgJmVuZHB0ciwgMCk7DQo+PiAr
DQo+PiArCXN3aXRjaCAoKmVuZHB0cikgew0KPj4gKwljYXNlICdFJzoNCj4+ICsJY2FzZSAnZSc6
DQo+PiArCQlyZXQgPDw9IDEwOw0KPj4gKwljYXNlICdQJzoNCj4+ICsJY2FzZSAncCc6DQo+PiAr
CQlyZXQgPDw9IDEwOw0KPj4gKwljYXNlICdUJzoNCj4+ICsJY2FzZSAndCc6DQo+PiArCQlyZXQg
PDw9IDEwOw0KPj4gKwljYXNlICdHJzoNCj4+ICsJY2FzZSAnZyc6DQo+PiArCQlyZXQgPDw9IDEw
Ow0KPj4gKwljYXNlICdNJzoNCj4+ICsJY2FzZSAnbSc6DQo+PiArCQlyZXQgPDw9IDEwOw0KPj4g
KwljYXNlICdLJzoNCj4+ICsJY2FzZSAnayc6DQo+PiArCQlyZXQgPDw9IDEwOw0KPj4gKwkJZW5k
cHRyKys7DQo+PiArCWRlZmF1bHQ6DQo+PiArCQlicmVhazsNCj4+ICsJfQ0KPj4gKw0KPj4gKwly
ZXR1cm4gcmV0Ow0KPj4gK30NCj4+ICsNCj4+ICtzdGF0aWMgdm9pZCB2c29ja19pbmNyZWFzZV9i
dWZfc2l6ZShpbnQgZmQpDQo+PiArew0KPj4gKwlpZiAoc2V0c29ja29wdChmZCwgQUZfVlNPQ0ss
IFNPX1ZNX1NPQ0tFVFNfQlVGRkVSX01BWF9TSVpFLA0KPj4gKwkJICAgICAgICZ2c29ja19idWZf
Ynl0ZXMsIHNpemVvZih2c29ja19idWZfYnl0ZXMpKSkgew0KPj4gKwkJcGVycm9yKCJzZXRzb2Nr
b3B0KFNPX1ZNX1NPQ0tFVFNfQlVGRkVSX01BWF9TSVpFKSIpOw0KPj4gKwkJZXhpdChFWElUX0ZB
SUxVUkUpOw0KPj4gKwl9DQo+PiArDQo+PiArCWlmIChzZXRzb2Nrb3B0KGZkLCBBRl9WU09DSywg
U09fVk1fU09DS0VUU19CVUZGRVJfU0laRSwNCj4+ICsJCSAgICAgICAmdnNvY2tfYnVmX2J5dGVz
LCBzaXplb2YodnNvY2tfYnVmX2J5dGVzKSkpIHsNCj4+ICsJCXBlcnJvcigic2V0c29ja29wdChT
T19WTV9TT0NLRVRTX0JVRkZFUl9TSVpFKSIpOw0KPj4gKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0K
PiANCj4gWW91IHVzZSB0aGUgYWJvdmUgcGF0dGVybiBmcmVxdWVudGx5LCBidXQgeW91IGNvdWxk
IHJlcGxhY2UgYm90aA0KPiBsaWJjYWxsIHdpdGggYSBzaW5nbGUgZXJyb3IoKSBjYWxsLg0KPiAN
Cj4gVGhhbmtzLA0KPiANCj4gUGFvbG8NCj4gDQoNCg==
