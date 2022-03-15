Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63494D966D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 09:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344858AbiCOIiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 04:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346178AbiCOIiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 04:38:11 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528D34CD4F;
        Tue, 15 Mar 2022 01:36:55 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 289265FD05;
        Tue, 15 Mar 2022 11:36:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647333411;
        bh=zQ9KUNJidOTBi9mTlrAbIUsZPD9xnMaIuG+Kuj/2tcE=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=anSKvlDeqcVp9CUMnL3fjh9YutsByeHYXMpVn4YlJ3Aup6LVF3/utT3sYvaqFigwb
         PhpjSNk2g2exhqm1LTsdHhzMetMw98GkEF8BQztzN5XdOVCOxivO4+31wN0EVBsO8y
         y+jr9sguu74LNZSM7sN32T3ZUE7qfIdyJRXkOLENdLxSooUJ8/XYcNYh1mYLwhYqTQ
         daIL9x+vaNDri0l1OFyr8301VH9B+MAy0WzNKnXd9Cv9t4nx0z8O0tOaKvjoRPlI99
         qnLChCmmLBr+P1Wfm24HHRg7gC1Mw6s0w9kw7O/cDowUp5mjMRaFHjsctFjevXwPof
         11AKiwweUvBCg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Tue, 15 Mar 2022 11:36:41 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 2/3] af_vsock: SOCK_SEQPACKET receive timeout test
Thread-Topic: [RFC PATCH v1 2/3] af_vsock: SOCK_SEQPACKET receive timeout test
Thread-Index: AQHYNTaJU61+cjcYFEaSzJHWUZnmpKy/7OSAgAAF6wA=
Date:   Tue, 15 Mar 2022 08:35:44 +0000
Message-ID: <457e03a0-7f74-4b9d-3699-ce8775ed69c0@sberdevices.ru>
References: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
 <6981b132-4121-62d8-7172-dca28ad1e498@sberdevices.ru>
 <20220315081517.m7rvlpintqipdu6i@sgarzare-redhat>
In-Reply-To: <20220315081517.m7rvlpintqipdu6i@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <10AC6C659A6A99489263F3BE18C16D3E@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/15 06:52:00 #18973197
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTUuMDMuMjAyMiAxMToxNSwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBGcmks
IE1hciAxMSwgMjAyMiBhdCAxMDo1NTo0MkFNICswMDAwLCBLcmFzbm92IEFyc2VuaXkgVmxhZGlt
aXJvdmljaCB3cm90ZToNCj4+IFRlc3QgZm9yIHJlY2VpdmUgdGltZW91dCBjaGVjazogY29ubmVj
dGlvbiBpcyBlc3RhYmxpc2hlZCwNCj4+IHJlY2VpdmVyIHNldHMgdGltZW91dCwgYnV0IHNlbmRl
ciBkb2VzIG5vdGhpbmcuIFJlY2VpdmVyJ3MNCj4+ICdyZWFkKCknIGNhbGwgbXVzdCByZXR1cm4g
RUFHQUlOLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92
QHNiZXJkZXZpY2VzLnJ1Pg0KPj4gLS0tDQo+PiB0b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rl
c3QuYyB8IDQ5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+PiAxIGZpbGUgY2hh
bmdlZCwgNDkgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5n
L3Zzb2NrL3Zzb2NrX3Rlc3QuYyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQo+
PiBpbmRleCAyYTM2MzhjMGEwMDguLmFhMmRlMjdkMGY3NyAxMDA2NDQNCj4+IC0tLSBhL3Rvb2xz
L3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQo+PiArKysgYi90b29scy90ZXN0aW5nL3Zzb2Nr
L3Zzb2NrX3Rlc3QuYw0KPj4gQEAgLTM5MSw2ICszOTEsNTAgQEAgc3RhdGljIHZvaWQgdGVzdF9z
ZXFwYWNrZXRfbXNnX3RydW5jX3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0K
Pj4gwqDCoMKgwqBjbG9zZShmZCk7DQo+PiB9DQo+Pg0KPj4gK3N0YXRpYyB2b2lkIHRlc3Rfc2Vx
cGFja2V0X3RpbWVvdXRfY2xpZW50KGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQo+PiAr
ew0KPj4gK8KgwqDCoCBpbnQgZmQ7DQo+PiArwqDCoMKgIHN0cnVjdCB0aW1ldmFsIHR2Ow0KPj4g
K8KgwqDCoCBjaGFyIGR1bW15Ow0KPj4gKw0KPj4gK8KgwqDCoCBmZCA9IHZzb2NrX3NlcXBhY2tl
dF9jb25uZWN0KG9wdHMtPnBlZXJfY2lkLCAxMjM0KTsNCj4+ICvCoMKgwqAgaWYgKGZkIDwgMCkg
ew0KPj4gK8KgwqDCoMKgwqDCoMKgIHBlcnJvcigiY29ubmVjdCIpOw0KPj4gK8KgwqDCoMKgwqDC
oMKgIGV4aXQoRVhJVF9GQUlMVVJFKTsNCj4+ICvCoMKgwqAgfQ0KPj4gKw0KPj4gK8KgwqDCoCB0
di50dl9zZWMgPSAxOw0KPj4gK8KgwqDCoCB0di50dl91c2VjID0gMDsNCj4+ICsNCj4+ICvCoMKg
wqAgaWYgKHNldHNvY2tvcHQoZmQsIFNPTF9TT0NLRVQsIFNPX1JDVlRJTUVPLCAodm9pZCAqKSZ0
diwgc2l6ZW9mKHR2KSkgPT0gLTEpIHsNCj4+ICvCoMKgwqDCoMKgwqDCoCBwZXJyb3IoInNldHNv
Y2tvcHQgJ1NPX1JDVlRJTUVPJyIpOw0KPj4gK8KgwqDCoMKgwqDCoMKgIGV4aXQoRVhJVF9GQUlM
VVJFKTsNCj4+ICvCoMKgwqAgfQ0KPj4gKw0KPj4gK8KgwqDCoCBpZiAoKHJlYWQoZmQsICZkdW1t
eSwgc2l6ZW9mKGR1bW15KSkgIT0gLTEpIHx8DQo+PiArwqDCoMKgwqDCoMKgwqAgKGVycm5vICE9
IEVBR0FJTikpIHsNCj4+ICvCoMKgwqDCoMKgwqDCoCBwZXJyb3IoIkVBR0FJTiBleHBlY3RlZCIp
Ow0KPj4gK8KgwqDCoMKgwqDCoMKgIGV4aXQoRVhJVF9GQUlMVVJFKTsNCj4+ICvCoMKgwqAgfQ0K
PiANCj4gVGhlIHBhdGNoIExHVE0sIG1heWJlIHRoZSBvbmx5IHRoaW5nIEkgd291bGQgYWRkIGhl
cmUgaXMgYSBjaGVjayBvbiB0aGUgdGltZSBzcGVudCBpbiB0aGUgcmVhZCgpLCB0byBzZWUgdGhh
dCBpdCBpcyBhcHByb3hpbWF0ZWx5IHRoZSB0aW1lb3V0IHdlIGhhdmUgc2V0Lg0KDQpBY2ssIEkn
bGwgYWRkIGl0IG9uIHYyDQoNCj4gDQo+IFRoYW5rcywNCj4gU3RlZmFubw0KPiANCg0K
