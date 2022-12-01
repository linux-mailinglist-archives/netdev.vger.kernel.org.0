Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C7463F387
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiLAPQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiLAPQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:16:49 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162AFC771D;
        Thu,  1 Dec 2022 07:16:45 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id EC6B95FD09;
        Thu,  1 Dec 2022 18:16:42 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669907803;
        bh=nU1RE45ZvimMv1CNnJChQ6TI/Z6ed/jCXRq3gvyAM4Q=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=Qgd+g5cc16mHuEcETwq/Sk0nr+1RDxWVtPznIfgclAqOm2whjRqZvZ8/9Vr0IiuQH
         bgxetdtcVKQ2wfbFiFdnrs8Ml9QgpxnpAhRvltt/zo6gOfydK8XSY8IixtoMNmKFuJ
         lWjddnMTXTYbPwTV16NCsMVTUwwO3mIy8O+R+JAFCT+93O+IxznMhJOfnRmv1E3X6E
         h+3pQ3sPYJ8m4dp61g16iWnDme692ace+2TycPM9rRgWfv0p3h3uJkyAc2vLpN0amD
         WZySH9Hpj9g1/iK+EGPyFrth2k9A1y2/ze2ZREU9J2uUpu3/U33GZCUPpHIZUQA5FD
         LqXXyAKJMaMpg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu,  1 Dec 2022 18:16:38 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Vishnu Dasa <vdasa@vmware.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     Bryan Tan <bryantan@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 3/6] vsock/vmci: always return ENOMEM in case of
 error
Thread-Topic: [RFC PATCH v2 3/6] vsock/vmci: always return ENOMEM in case of
 error
Thread-Index: AQHZAPB8vpTNk9Cz/UiwVhA3FAXi7a5YmwUAgABf+wCAAABQgA==
Date:   Thu, 1 Dec 2022 15:16:38 +0000
Message-ID: <ccb9e602-88c1-6d72-75f6-4a3c84549b72@sberdevices.ru>
References: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
 <675b1f93-dc07-0a70-0622-c3fc6236c8bb@sberdevices.ru>
 <20221201093048.q2pradrgn5limcfb@sgarzare-redhat>
 <D7DE3103-994D-478E-B7F6-42CE8B6469FE@vmware.com>
In-Reply-To: <D7DE3103-994D-478E-B7F6-42CE8B6469FE@vmware.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <828820DEBCB8C8448C1E6D7D6AA05FC3@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/01 11:49:00 #20632713
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEuMTIuMjAyMiAxODoxNCwgVmlzaG51IERhc2Egd3JvdGU6DQo+IA0KPiANCj4+IE9uIERl
YyAxLCAyMDIyLCBhdCAxOjMwIEFNLCBTdGVmYW5vIEdhcnphcmVsbGEgPHNnYXJ6YXJlQHJlZGhh
dC5jb20+IHdyb3RlOg0KPj4NCj4+ICEhIEV4dGVybmFsIEVtYWlsDQo+Pg0KPj4gT24gRnJpLCBO
b3YgMjUsIDIwMjIgYXQgMDU6MDg6MDZQTSArMDAwMCwgQXJzZW5peSBLcmFzbm92IHdyb3RlOg0K
Pj4+IEZyb206IEJvYmJ5IEVzaGxlbWFuIDxib2JieS5lc2hsZW1hbkBieXRlZGFuY2UuY29tPg0K
Pj4+DQo+Pj4gVGhpcyBzYXZlcyBvcmlnaW5hbCBiZWhhdmlvdXIgZnJvbSBhZl92c29jay5jIC0g
c3dpdGNoIGFueSBlcnJvcg0KPj4+IGNvZGUgcmV0dXJuZWQgZnJvbSB0cmFuc3BvcnQgbGF5ZXIg
dG8gRU5PTUVNLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogQm9iYnkgRXNobGVtYW4gPGJvYmJ5
LmVzaGxlbWFuQGJ5dGVkYW5jZS5jb20+DQo+Pj4gU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFz
bm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQo+Pj4gLS0tDQo+Pj4gbmV0L3Ztd192c29j
ay92bWNpX3RyYW5zcG9ydC5jIHwgOSArKysrKysrKy0NCj4+PiAxIGZpbGUgY2hhbmdlZCwgOCBp
bnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gQEJyeWFuIEBWaXNobnUgd2hhdCBk
byB5b3UgdGhpbmsgYWJvdXQgdGhpcyBwYXRjaD8NCj4+DQo+PiBBIGJpdCBvZiBjb250ZXh0Og0K
Pj4NCj4+IEJlZm9yZSB0aGlzIHNlcmllcywgdGhlIGFmX3Zzb2NrIGNvcmUgYWx3YXlzIHJldHVy
bmVkIEVOT01FTSB0byB0aGUgdXNlcg0KPj4gaWYgdGhlIHRyYW5zcG9ydCBmYWlsZWQgdG8gcXVl
dWUgdGhlIHBhY2tldC4NCj4+DQo+PiBOb3cgd2UgYXJlIGNoYW5naW5nIGl0IGJ5IHJldHVybmlu
ZyB0aGUgdHJhbnNwb3J0IGVycm9yLiBTbyBJIHRoaW5rIGhlcmUNCj4+IHdlIHdhbnQgdG8gcHJl
c2VydmUgdGhlIHByZXZpb3VzIGJlaGF2aW9yIGZvciB2bWNpLCBidXQgSSBkb24ndCBrbm93IGlm
DQo+PiB0aGF0J3MgdGhlIHJpZ2h0IHRoaW5nLg0KPj4NCj4gDQo+IEFncmVlIHdpdGggU3RlZmFu
by4gIEkgZG9uJ3QgdGhpbmsgd2UgbmVlZCB0byBwcmVzZXJ2ZSB0aGUgcHJldmlvdXMNCj4gYmVo
YXZpb3IgZm9yIHZtY2kuDQpHb29kISBJJ2xsIHJlbW92ZSB0aGlzIHBhdGNoIGZyb20gdGhlIG5l
eHQgdmVyc2lvbg0KDQpUaGFua3MsIEFyc2VuaXkNCj4gDQo+Pg0KPj4gQEFyc2VuaXkgcGxlYXNl
IGluIHRoZSBuZXh0IHZlcnNpb25zIGRlc2NyaWJlIGJldHRlciBpbiB0aGUgY29tbWl0DQo+PiBt
ZXNzYWdlcyB0aGUgcmVhc29ucyBmb3IgdGhlc2UgY2hhbmdlcywgc28gaXQgaXMgZWFzaWVyIHJl
dmlldyBmb3INCj4+IG90aGVycyBhbmQgYWxzbyBpbiB0aGUgZnV0dXJlIGJ5IHJlYWRpbmcgdGhl
IGNvbW1pdCBtZXNzYWdlIHdlIGNhbg0KPj4gdW5kZXJzdGFuZCB0aGUgcmVhc29uIGZvciB0aGUg
Y2hhbmdlLg0KPj4NCj4+IFRoYW5rcywNCj4+IFN0ZWZhbm8NCj4+DQo+Pj4NCj4+PiBkaWZmIC0t
Z2l0IGEvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydC5jIGIvbmV0L3Ztd192c29jay92bWNp
X3RyYW5zcG9ydC5jDQo+Pj4gaW5kZXggODQyYzk0Mjg2ZDMxLi4yODlhMzZhMjAzYTIgMTAwNjQ0
DQo+Pj4gLS0tIGEvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydC5jDQo+Pj4gKysrIGIvbmV0
L3Ztd192c29jay92bWNpX3RyYW5zcG9ydC5jDQo+Pj4gQEAgLTE4MzgsNyArMTgzOCwxNCBAQCBz
dGF0aWMgc3NpemVfdCB2bWNpX3RyYW5zcG9ydF9zdHJlYW1fZW5xdWV1ZSgNCj4+PiAgICAgIHN0
cnVjdCBtc2doZHIgKm1zZywNCj4+PiAgICAgIHNpemVfdCBsZW4pDQo+Pj4gew0KPj4+IC0gICAg
ICByZXR1cm4gdm1jaV9xcGFpcl9lbnF1ZXYodm1jaV90cmFucyh2c2spLT5xcGFpciwgbXNnLCBs
ZW4sIDApOw0KPj4+ICsgICAgICBpbnQgZXJyOw0KPj4+ICsNCj4+PiArICAgICAgZXJyID0gdm1j
aV9xcGFpcl9lbnF1ZXYodm1jaV90cmFucyh2c2spLT5xcGFpciwgbXNnLCBsZW4sIDApOw0KPj4+
ICsNCj4+PiArICAgICAgaWYgKGVyciA8IDApDQo+Pj4gKyAgICAgICAgICAgICAgZXJyID0gLUVO
T01FTTsNCj4+PiArDQo+Pj4gKyAgICAgIHJldHVybiBlcnI7DQo+Pj4gfQ0KPj4+DQo+Pj4gc3Rh
dGljIHM2NCB2bWNpX3RyYW5zcG9ydF9zdHJlYW1faGFzX2RhdGEoc3RydWN0IHZzb2NrX3NvY2sg
KnZzaykNCj4+PiAtLQ0KPj4+IDIuMjUuMQ0KPj4NCj4+DQo+PiAhISBFeHRlcm5hbCBFbWFpbDog
VGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBE
byBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IHJlY29nbml6
ZSB0aGUgc2VuZGVyLg0KPiANCg0K
