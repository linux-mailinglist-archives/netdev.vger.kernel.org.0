Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EB563EFCA
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiLALor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiLALoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:44:44 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9531D8EE55;
        Thu,  1 Dec 2022 03:44:42 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 576155FD07;
        Thu,  1 Dec 2022 14:44:40 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669895080;
        bh=IxSYjwO5aSMC7AY86M6AC1LSHBEzm9nhigoUH6Db07I=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=hri5ISsUybQVBssfRimqI5W45dX0ssrw6j6seTm8emlsUnnTpkF4Cyd3kTZvjt1oU
         Ucd1nJQCy4rYO8NxNVyhZ2eBAqrpzalZ1Gltvuo33Pmtvo9Nr/LCxzf6Cvw4MBm7hI
         3jly1Ydx/01Mz5n8mW2gMgmPOboPqbRBzM+Rn7nstok0Sm7kSDj+Tx4/CnBhOaQ8Nx
         O9QASLq9kQkvRi7Y9eLYkGh1ggXJgPXU9P9QueRX6gnCJExvfpwmZ5jggHNriUt8KG
         nL5hurL343MuZttps/+br1rBpeZAzbxRVyxbRpY0CtAqmhCDLOJAMBw59GHWaFdUKc
         RMZ8aN9P0lN8w==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu,  1 Dec 2022 14:44:39 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        "Bobby Eshleman" <bobby.eshleman@bytedance.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 5/6] test/vsock: add big message test
Thread-Topic: [RFC PATCH v2 5/6] test/vsock: add big message test
Thread-Index: AQHZAPEvcSVoxBim/0CJACwJhEWdy65YnyyAgAAg6AA=
Date:   Thu, 1 Dec 2022 11:44:39 +0000
Message-ID: <2694faa5-c460-857d-6ca9-a6328530ff23@sberdevices.ru>
References: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
 <2634ad7f-b462-5c69-8aa1-2f200a6beb20@sberdevices.ru>
 <20221201094541.gj7zthelbeqhsp63@sgarzare-redhat>
In-Reply-To: <20221201094541.gj7zthelbeqhsp63@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <253B24191838FB4C99A56A39A2F7161D@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/01 00:48:00 #20630840
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEuMTIuMjAyMiAxMjo0NSwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBGcmks
IE5vdiAyNSwgMjAyMiBhdCAwNToxMzowNlBNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBUaGlzIGFkZHMgdGVzdCBmb3Igc2VuZGluZyBtZXNzYWdlLCBiaWdnZXIgdGhhbiBwZWVy
J3MgYnVmZmVyIHNpemUuDQo+PiBGb3IgU09DS19TRVFQQUNLRVQgc29ja2V0IGl0IG11c3QgZmFp
bCwgYXMgdGhpcyB0eXBlIG9mIHNvY2tldCBoYXMNCj4+IG1lc3NhZ2Ugc2l6ZSBsaW1pdC4NCj4+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNl
cy5ydT4NCj4+IC0tLQ0KPj4gdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCA2OSAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4gMSBmaWxlIGNoYW5nZWQsIDY5IGlu
c2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy92c29jay92c29j
a190ZXN0LmMgYi90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KPj4gaW5kZXggMTJl
ZjBjY2E2ZjkzLi5hOGU0MzQyNGZiMzIgMTAwNjQ0DQo+PiAtLS0gYS90b29scy90ZXN0aW5nL3Zz
b2NrL3Zzb2NrX3Rlc3QuYw0KPj4gKysrIGIvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0
LmMNCj4+IEBAIC01NjksNiArNTY5LDcwIEBAIHN0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X3Rp
bWVvdXRfc2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQo+PiDCoMKgwqDCoGNs
b3NlKGZkKTsNCj4+IH0NCj4+DQo+PiArc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfYmlnbXNn
X2NsaWVudChjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KPj4gK3sNCj4+ICvCoMKgwqAg
dW5zaWduZWQgbG9uZyBzb2NrX2J1Zl9zaXplOw0KPj4gK8KgwqDCoCBzc2l6ZV90IHNlbmRfc2l6
ZTsNCj4+ICvCoMKgwqAgc29ja2xlbl90IGxlbjsNCj4+ICvCoMKgwqAgdm9pZCAqZGF0YTsNCj4+
ICvCoMKgwqAgaW50IGZkOw0KPj4gKw0KPj4gK8KgwqDCoCBsZW4gPSBzaXplb2Yoc29ja19idWZf
c2l6ZSk7DQo+PiArDQo+PiArwqDCoMKgIGZkID0gdnNvY2tfc2VxcGFja2V0X2Nvbm5lY3Qob3B0
cy0+cGVlcl9jaWQsIDEyMzQpOw0KPj4gK8KgwqDCoCBpZiAoZmQgPCAwKSB7DQo+PiArwqDCoMKg
wqDCoMKgwqAgcGVycm9yKCJjb25uZWN0Iik7DQo+PiArwqDCoMKgwqDCoMKgwqAgZXhpdChFWElU
X0ZBSUxVUkUpOw0KPj4gK8KgwqDCoCB9DQo+PiArDQo+PiArwqDCoMKgIGlmIChnZXRzb2Nrb3B0
KGZkLCBBRl9WU09DSywgU09fVk1fU09DS0VUU19CVUZGRVJfU0laRSwNCj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgICZzb2NrX2J1Zl9zaXplLCAmbGVuKSkgew0KPj4gK8KgwqDCoMKg
wqDCoMKgIHBlcnJvcigiZ2V0c29ja29wdCIpOw0KPj4gK8KgwqDCoMKgwqDCoMKgIGV4aXQoRVhJ
VF9GQUlMVVJFKTsNCj4+ICvCoMKgwqAgfQ0KPj4gKw0KPj4gK8KgwqDCoCBzb2NrX2J1Zl9zaXpl
Kys7DQo+PiArDQo+PiArwqDCoMKgIGRhdGEgPSBtYWxsb2Moc29ja19idWZfc2l6ZSk7DQo+PiAr
wqDCoMKgIGlmICghZGF0YSkgew0KPj4gK8KgwqDCoMKgwqDCoMKgIHBlcnJvcigibWFsbG9jIik7
DQo+PiArwqDCoMKgwqDCoMKgwqAgZXhpdChFWElUX0ZBSUxVUkUpOw0KPj4gK8KgwqDCoCB9DQo+
PiArDQo+PiArwqDCoMKgIHNlbmRfc2l6ZSA9IHNlbmQoZmQsIGRhdGEsIHNvY2tfYnVmX3NpemUs
IDApOw0KPj4gK8KgwqDCoCBpZiAoc2VuZF9zaXplICE9IC0xKSB7DQo+PiArwqDCoMKgwqDCoMKg
wqAgZnByaW50ZihzdGRlcnIsICJleHBlY3RlZCAnc2VuZCgyKScgZmFpbHVyZSwgZ290ICV6aVxu
IiwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNlbmRfc2l6ZSk7DQo+PiArwqDCoMKgwqDC
oMKgwqAgZXhpdChFWElUX0ZBSUxVUkUpOw0KPj4gK8KgwqDCoCB9DQo+PiArDQo+PiArwqDCoMKg
IGlmIChlcnJubyAhPSBFTVNHU0laRSkgew0KPj4gK8KgwqDCoMKgwqDCoMKgIGZwcmludGYoc3Rk
ZXJyLCAiZXhwZWN0ZWQgRU1TR1NJWkUgaW4gJ2Vycm5vJywgZ290ICVpXG4iLA0KPj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgZXJybm8pOw0KPj4gK8KgwqDCoMKgwqDCoMKgIGV4aXQoRVhJVF9G
QUlMVVJFKTsNCj4+ICvCoMKgwqAgfQ0KPiANCj4gV2Ugc2hvdWxkIG1ha2Ugc3VyZSB0aGF0IHRo
aXMgaXMgdHJ1ZSBmb3IgYWxsIHRyYW5zcG9ydHMsIGJ1dCBzaW5jZSBub3cgb25seSB2aXJ0aW8t
dnNvY2sgc3VwcG9ydHMgaXQsIHdlIHNob3VsZCBiZSBva2F5Lg0KSG0sIGluIGdlbmVyYWw6IEkn
dmUgdGVzdGVkIHRoaXMgdGVzdCBzdWl0ZSBmb3Igdm1jaSBtYXkgYmUgc2V2ZXJhbCBtb250aHMg
YWdvLCBhbmQgZm91bmQsIHRoYXQgc29tZSB0ZXN0cw0KZGlkbid0IHdvcmsuIEknbSB0aGlua2lu
ZyBhYm91dCByZXdvcmtpbmcgdGhpcyB0ZXN0IHN1aXRlIGEgbGl0dGxlIGJpdDogZWFjaCB0cmFu
c3BvcnQgbXVzdCBoYXZlIG93biBzZXQgb2YNCnRlc3RzIGZvciBmZWF0dXJlcyB0aGF0IGl0IHN1
cHBvcnRzLiBJIGhhZCBmZWVsaW5nLCB0aGF0IGFsbCB0aGVzZSB0ZXN0cyBhcmUgcnVuIG9ubHkg
d2l0aCB2aXJ0aW8gdHJhbnNwb3J0IDopDQpCZWNhdXNlIGZvciBleGFtcGxlIFNFUVBBQ0tFVCBt
b2RlIGlzIHN1cG9ydGVkIG9ubHkgZm9yIHZpcnRpby4NCg0KVGhhbmtzDQo+IA0KPj4gKw0KPj4g
K8KgwqDCoCBjb250cm9sX3dyaXRlbG4oIkNMSVNFTlQiKTsNCj4+ICsNCj4+ICvCoMKgwqAgZnJl
ZShkYXRhKTsNCj4+ICvCoMKgwqAgY2xvc2UoZmQpOw0KPj4gK30NCj4+ICsNCj4+ICtzdGF0aWMg
dm9pZCB0ZXN0X3NlcXBhY2tldF9iaWdtc2dfc2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMg
Km9wdHMpDQo+PiArew0KPj4gK8KgwqDCoCBpbnQgZmQ7DQo+PiArDQo+PiArwqDCoMKgIGZkID0g
dnNvY2tfc2VxcGFja2V0X2FjY2VwdChWTUFERFJfQ0lEX0FOWSwgMTIzNCwgTlVMTCk7DQo+PiAr
wqDCoMKgIGlmIChmZCA8IDApIHsNCj4+ICvCoMKgwqDCoMKgwqDCoCBwZXJyb3IoImFjY2VwdCIp
Ow0KPj4gK8KgwqDCoMKgwqDCoMKgIGV4aXQoRVhJVF9GQUlMVVJFKTsNCj4+ICvCoMKgwqAgfQ0K
Pj4gKw0KPj4gK8KgwqDCoCBjb250cm9sX2V4cGVjdGxuKCJDTElTRU5UIik7DQo+PiArDQo+PiAr
wqDCoMKgIGNsb3NlKGZkKTsNCj4+ICt9DQo+PiArDQo+PiAjZGVmaW5lIEJVRl9QQVRURVJOXzEg
J2EnDQo+PiAjZGVmaW5lIEJVRl9QQVRURVJOXzIgJ2InDQo+Pg0KPj4gQEAgLTg1MSw2ICs5MTUs
MTEgQEAgc3RhdGljIHN0cnVjdCB0ZXN0X2Nhc2UgdGVzdF9jYXNlc1tdID0gew0KPj4gwqDCoMKg
wqDCoMKgwqAgLnJ1bl9jbGllbnQgPSB0ZXN0X3N0cmVhbV9wb2xsX3Jjdmxvd2F0X2NsaWVudCwN
Cj4+IMKgwqDCoMKgwqDCoMKgIC5ydW5fc2VydmVyID0gdGVzdF9zdHJlYW1fcG9sbF9yY3Zsb3dh
dF9zZXJ2ZXIsDQo+PiDCoMKgwqDCoH0sDQo+PiArwqDCoMKgIHsNCj4+ICvCoMKgwqDCoMKgwqDC
oCAubmFtZSA9ICJTT0NLX1NFUVBBQ0tFVCBiaWcgbWVzc2FnZSIsDQo+PiArwqDCoMKgwqDCoMKg
wqAgLnJ1bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tldF9iaWdtc2dfY2xpZW50LA0KPj4gK8KgwqDC
oMKgwqDCoMKgIC5ydW5fc2VydmVyID0gdGVzdF9zZXFwYWNrZXRfYmlnbXNnX3NlcnZlciwNCj4+
ICvCoMKgwqAgfSwNCj4+IMKgwqDCoMKge30sDQo+PiB9Ow0KPj4NCj4+IC0twqANCj4+IDIuMjUu
MQ0KPiANCj4gTEdUTSENCj4gDQo+IFJldmlld2VkLWJ5OiBTdGVmYW5vIEdhcnphcmVsbGEgPHNn
YXJ6YXJlQHJlZGhhdC5jb20+DQo+IA0KDQo=
