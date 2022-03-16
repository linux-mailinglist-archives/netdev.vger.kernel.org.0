Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA834DAEF4
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 12:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355360AbiCPLiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 07:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbiCPLiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 07:38:10 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E4B275CE;
        Wed, 16 Mar 2022 04:36:52 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 948005FD04;
        Wed, 16 Mar 2022 14:36:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647430609;
        bh=PvPY+tRJkwNvXuOCwrb9GlOjYUqFZkOk6XJ2pyjpG98=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=PM3RkON2tYA9eEAVAAjAz6mJThYIzg/ZHZcgpWPRIMYhu0EXr80u35cPQrVYeim8B
         EgkzcscE18hwmCZglCJGNvuXfkJTZiZWSJTu1tq6rUCaPhCfdKow4frGan4z4lx+el
         yXxF5iZ7VBU4v4b4rV9CfbB5OuW4gy/+3INJJ8HrhQlAcwrWgdaoFp3uovABZCqzDx
         tEV50RC/VBAjJKytI0V20eNppjEIeGzkU1vMYdyYmKfE/SzxEBtbxNGV+5sIX2S4CH
         XUoLyxH08tXwOyBxCHQNbk6AZAXn3yBVrTvXaB9YE1F8js+A9SLYckM6KOYdjUqNR4
         dZeikzSZKEBQw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 16 Mar 2022 14:36:43 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/2] af_vsock: SOCK_SEQPACKET receive timeout test
Thread-Topic: [RFC PATCH v2 1/2] af_vsock: SOCK_SEQPACKET receive timeout test
Thread-Index: AQHYOQdQb7ugiPNDrEajiUcKS1B+h6zBgaGAgAAuNwA=
Date:   Wed, 16 Mar 2022 11:35:47 +0000
Message-ID: <3eb6bbeb-ec1d-14cb-be8c-795954e6587a@sberdevices.ru>
References: <1474b149-7d4c-27b2-7e5c-ef00a718db76@sberdevices.ru>
 <2bc15104-37e6-088a-1699-dc27d0e2dadf@sberdevices.ru>
 <20220316085113.jlkj7cflzg77akmm@sgarzare-redhat>
In-Reply-To: <20220316085113.jlkj7cflzg77akmm@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7124CFA70831F74FB4B400FB532F362F@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/16 06:31:00 #18980784
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDMuMjAyMiAxMTo1MSwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBXZWQs
IE1hciAxNiwgMjAyMiBhdCAwNzoyNzo0NUFNICswMDAwLCBLcmFzbm92IEFyc2VuaXkgVmxhZGlt
aXJvdmljaCB3cm90ZToNCj4+IFRlc3QgZm9yIHJlY2VpdmUgdGltZW91dCBjaGVjazogY29ubmVj
dGlvbiBpcyBlc3RhYmxpc2hlZCwNCj4+IHJlY2VpdmVyIHNldHMgdGltZW91dCwgYnV0IHNlbmRl
ciBkb2VzIG5vdGhpbmcuIFJlY2VpdmVyJ3MNCj4+ICdyZWFkKCknIGNhbGwgbXVzdCByZXR1cm4g
RUFHQUlOLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92
QHNiZXJkZXZpY2VzLnJ1Pg0KPj4gLS0tDQo+PiB2MSAtPiB2MjoNCj4+IDEpIENoZWNrIGFtb3Vu
dCBvZiB0aW1lIHNwZW50IGluICdyZWFkKCknLg0KPiANCj4gVGhlIHBhdGNoIGxvb2tzIGNvcnJl
Y3QgdG8gbWUsIGJ1dCBzaW5jZSBpdCdzIGFuIFJGQyBhbmQgeW91IGhhdmUgdG8gc2VuZCBhbm90
aGVyIHZlcnNpb24gYW55d2F5LCBoZXJlIGFyZSBzb21lIG1pbm9yIHN1Z2dlc3Rpb25zIDotKQ0K
PiANCg0KT2ssIGknbGwgcHJlcGFyZSBuZXh0IHZlcnNpb24gd2l0aCBmaXhlcyA6KQ0KDQo+Pg0K
Pj4gdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCA3OSArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPj4gMSBmaWxlIGNoYW5nZWQsIDc5IGluc2VydGlvbnMoKykNCj4+
DQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgYi90b29s
cy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KPj4gaW5kZXggMmEzNjM4YzBhMDA4Li42ZDc2
NDhjY2U1YWEgMTAwNjQ0DQo+PiAtLS0gYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3Qu
Yw0KPj4gKysrIGIvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCj4+IEBAIC0xNiw2
ICsxNiw3IEBADQo+PiAjaW5jbHVkZSA8bGludXgva2VybmVsLmg+DQo+PiAjaW5jbHVkZSA8c3lz
L3R5cGVzLmg+DQo+PiAjaW5jbHVkZSA8c3lzL3NvY2tldC5oPg0KPj4gKyNpbmNsdWRlIDx0aW1l
Lmg+DQo+Pg0KPj4gI2luY2x1ZGUgInRpbWVvdXQuaCINCj4+ICNpbmNsdWRlICJjb250cm9sLmgi
DQo+PiBAQCAtMzkxLDYgKzM5Miw3OSBAQCBzdGF0aWMgdm9pZCB0ZXN0X3NlcXBhY2tldF9tc2df
dHJ1bmNfc2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQo+PiDCoMKgwqDCoGNs
b3NlKGZkKTsNCj4+IH0NCj4+DQo+PiArc3RhdGljIHRpbWVfdCBjdXJyZW50X25zZWModm9pZCkN
Cj4+ICt7DQo+PiArwqDCoMKgIHN0cnVjdCB0aW1lc3BlYyB0czsNCj4+ICsNCj4+ICvCoMKgwqAg
aWYgKGNsb2NrX2dldHRpbWUoQ0xPQ0tfUkVBTFRJTUUsICZ0cykpIHsNCj4+ICvCoMKgwqDCoMKg
wqDCoCBwZXJyb3IoImNsb2NrX2dldHRpbWUoMykgZmFpbGVkIik7DQo+PiArwqDCoMKgwqDCoMKg
wqAgZXhpdChFWElUX0ZBSUxVUkUpOw0KPj4gK8KgwqDCoCB9DQo+PiArDQo+PiArwqDCoMKgIHJl
dHVybiAodHMudHZfc2VjICogMTAwMDAwMDAwMFVMTCkgKyB0cy50dl9uc2VjOw0KPj4gK30NCj4+
ICsNCj4+ICsjZGVmaW5lIFJDVlRJTUVPX1RJTUVPVVRfU0VDIDENCj4+ICsjZGVmaW5lIFJFQURf
T1ZFUkhFQURfTlNFQyAyNTAwMDAwMDAgLyogMC4yNSBzZWMgKi8NCj4+ICsNCj4+ICtzdGF0aWMg
dm9pZCB0ZXN0X3NlcXBhY2tldF90aW1lb3V0X2NsaWVudChjb25zdCBzdHJ1Y3QgdGVzdF9vcHRz
ICpvcHRzKQ0KPj4gK3sNCj4+ICvCoMKgwqAgaW50IGZkOw0KPj4gK8KgwqDCoCBzdHJ1Y3QgdGlt
ZXZhbCB0djsNCj4+ICvCoMKgwqAgY2hhciBkdW1teTsNCj4+ICvCoMKgwqAgdGltZV90IHJlYWRf
ZW50ZXJfbnM7DQo+PiArwqDCoMKgIHRpbWVfdCByZWFkX292ZXJoZWFkX25zOw0KPj4gKw0KPj4g
K8KgwqDCoCBmZCA9IHZzb2NrX3NlcXBhY2tldF9jb25uZWN0KG9wdHMtPnBlZXJfY2lkLCAxMjM0
KTsNCj4+ICvCoMKgwqAgaWYgKGZkIDwgMCkgew0KPj4gK8KgwqDCoMKgwqDCoMKgIHBlcnJvcigi
Y29ubmVjdCIpOw0KPj4gK8KgwqDCoMKgwqDCoMKgIGV4aXQoRVhJVF9GQUlMVVJFKTsNCj4+ICvC
oMKgwqAgfQ0KPj4gKw0KPj4gK8KgwqDCoCB0di50dl9zZWMgPSBSQ1ZUSU1FT19USU1FT1VUX1NF
QzsNCj4+ICvCoMKgwqAgdHYudHZfdXNlYyA9IDA7DQo+PiArDQo+PiArwqDCoMKgIGlmIChzZXRz
b2Nrb3B0KGZkLCBTT0xfU09DS0VULCBTT19SQ1ZUSU1FTywgKHZvaWQgKikmdHYsIHNpemVvZih0
dikpID09IC0xKSB7DQo+PiArwqDCoMKgwqDCoMKgwqAgcGVycm9yKCJzZXRzb2Nrb3B0ICdTT19S
Q1ZUSU1FTyciKTsNCj4+ICvCoMKgwqDCoMKgwqDCoCBleGl0KEVYSVRfRkFJTFVSRSk7DQo+PiAr
wqDCoMKgIH0NCj4+ICsNCj4+ICvCoMKgwqAgcmVhZF9lbnRlcl9ucyA9IGN1cnJlbnRfbnNlYygp
Ow0KPj4gKw0KPj4gK8KgwqDCoCBpZiAoKHJlYWQoZmQsICZkdW1teSwgc2l6ZW9mKGR1bW15KSkg
IT0gLTEpIHx8DQo+PiArwqDCoMKgwqDCoMKgwqAgKGVycm5vICE9IEVBR0FJTikpIHsNCj4gDQo+
IEhlcmUgd2UgY2FuIHNwbGl0IGluIDIgY2hlY2tzIGxpa2UgaW4gcGF0Y2ggMiwgc2luY2UgaWYg
cmVhZCgpIHJldHVybiB2YWx1ZSBpcyA+PSAwLCBlcnJubyBpcyBub3Qgc2V0Lg0KPiANCj4+ICvC
oMKgwqDCoMKgwqDCoCBwZXJyb3IoIkVBR0FJTiBleHBlY3RlZCIpOw0KPj4gK8KgwqDCoMKgwqDC
oMKgIGV4aXQoRVhJVF9GQUlMVVJFKTsNCj4+ICvCoMKgwqAgfQ0KPj4gKw0KPj4gK8KgwqDCoCBy
ZWFkX292ZXJoZWFkX25zID0gY3VycmVudF9uc2VjKCkgLSByZWFkX2VudGVyX25zIC0NCj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIDEwMDAwMDAwMDBVTEwgKiBSQ1ZUSU1FT19USU1FT1VUX1NF
QzsNCj4+ICsNCj4+ICvCoMKgwqAgaWYgKHJlYWRfb3ZlcmhlYWRfbnMgPiBSRUFEX09WRVJIRUFE
X05TRUMpIHsNCj4+ICvCoMKgwqDCoMKgwqDCoCBmcHJpbnRmKHN0ZGVyciwNCj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICJ0b28gbXVjaCB0aW1lIGluIHJlYWQoMikgd2l0aCBTT19SQ1ZUSU1F
TzogJWx1IG5zXG4iLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVhZF9vdmVyaGVhZF9u
cyk7DQo+IA0KPiBXaGF0IGFib3V0IHByaW50aW5nIGFsc28gdGhlIGV4cGVjdGVkIG92ZXJoZWFk
Pw0KPiANCj4+ICvCoMKgwqDCoMKgwqDCoCBleGl0KEVYSVRfRkFJTFVSRSk7DQo+PiArwqDCoMKg
IH0NCj4+ICsNCj4+ICvCoMKgwqAgY29udHJvbF93cml0ZWxuKCJXQUlURE9ORSIpOw0KPj4gK8Kg
wqDCoCBjbG9zZShmZCk7DQo+PiArfQ0KPj4gKw0KPj4gK3N0YXRpYyB2b2lkIHRlc3Rfc2VxcGFj
a2V0X3RpbWVvdXRfc2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQo+PiArew0K
Pj4gK8KgwqDCoCBpbnQgZmQ7DQo+PiArDQo+PiArwqDCoMKgIGZkID0gdnNvY2tfc2VxcGFja2V0
X2FjY2VwdChWTUFERFJfQ0lEX0FOWSwgMTIzNCwgTlVMTCk7DQo+PiArwqDCoMKgIGlmIChmZCA8
IDApIHsNCj4+ICvCoMKgwqDCoMKgwqDCoCBwZXJyb3IoImFjY2VwdCIpOw0KPj4gK8KgwqDCoMKg
wqDCoMKgIGV4aXQoRVhJVF9GQUlMVVJFKTsNCj4+ICvCoMKgwqAgfQ0KPj4gKw0KPj4gK8KgwqDC
oCBjb250cm9sX2V4cGVjdGxuKCJXQUlURE9ORSIpOw0KPj4gK8KgwqDCoCBjbG9zZShmZCk7DQo+
PiArfQ0KPj4gKw0KPj4gc3RhdGljIHN0cnVjdCB0ZXN0X2Nhc2UgdGVzdF9jYXNlc1tdID0gew0K
Pj4gwqDCoMKgwqB7DQo+PiDCoMKgwqDCoMKgwqDCoCAubmFtZSA9ICJTT0NLX1NUUkVBTSBjb25u
ZWN0aW9uIHJlc2V0IiwNCj4+IEBAIC00MzEsNiArNTA1LDExIEBAIHN0YXRpYyBzdHJ1Y3QgdGVz
dF9jYXNlIHRlc3RfY2FzZXNbXSA9IHsNCj4+IMKgwqDCoMKgwqDCoMKgIC5ydW5fY2xpZW50ID0g
dGVzdF9zZXFwYWNrZXRfbXNnX3RydW5jX2NsaWVudCwNCj4+IMKgwqDCoMKgwqDCoMKgIC5ydW5f
c2VydmVyID0gdGVzdF9zZXFwYWNrZXRfbXNnX3RydW5jX3NlcnZlciwNCj4+IMKgwqDCoMKgfSwN
Cj4+ICvCoMKgwqAgew0KPj4gK8KgwqDCoMKgwqDCoMKgIC5uYW1lID0gIlNPQ0tfU0VRUEFDS0VU
IHRpbWVvdXQiLA0KPj4gK8KgwqDCoMKgwqDCoMKgIC5ydW5fY2xpZW50ID0gdGVzdF9zZXFwYWNr
ZXRfdGltZW91dF9jbGllbnQsDQo+PiArwqDCoMKgwqDCoMKgwqAgLnJ1bl9zZXJ2ZXIgPSB0ZXN0
X3NlcXBhY2tldF90aW1lb3V0X3NlcnZlciwNCj4+ICvCoMKgwqAgfSwNCj4+IMKgwqDCoMKge30s
DQo+PiB9Ow0KPj4NCj4+IC0twqANCj4+IDIuMjUuMQ0KPiANCg0K
