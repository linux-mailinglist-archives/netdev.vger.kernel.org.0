Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5FC58D6B3
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 11:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239056AbiHIJqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 05:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbiHIJp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 05:45:59 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527BF22B33;
        Tue,  9 Aug 2022 02:45:54 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 5676D5FD05;
        Tue,  9 Aug 2022 12:45:53 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660038353;
        bh=IGkP5efRwetbWNENRXfmghJykzmtvL4M8qfOS/4+dCg=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=VZ0A/yjl9PctemwH18AaXxKD8a2Yl2XDkcgBdL85nxOGMLqfe1RFDhVfI0tpqnmOc
         oOy5oupGAZdcUI+I4A8V8eSamoCGHDA2vIA3xcLSDslYsZWwElMPdDnRRvjXXpTYNL
         15XqkpzG4+c3cvTfoigf4xXdU0d2KfQbac8rDxy0mA+/3mvVbZrXkBeWsV2JhXOwES
         AycNnc8811ZR6V1SExgcQgeiNtF0KU2Mv+gk/6TW9bEg7p/MAYGVhtWx1sGxcsUj81
         5ziyCoy4myX4t78roGFQJyBgP/NPbPWJCAcso4mXb6YXF9l4qn8OSGKgSwQwZjE+O8
         Go23ukI2ma/iQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Tue,  9 Aug 2022 12:45:52 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Dexuan Cui" <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "VMware PV-Drivers Reviewers" <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 1/9] vsock: SO_RCVLOWAT transport set callback
Thread-Topic: [RFC PATCH v3 1/9] vsock: SO_RCVLOWAT transport set callback
Thread-Index: AQHYp0ATlQNqO/GwP0WKlu98/YZplK2koQqAgAAB2ICAAYOigIAAAlCA
Date:   Tue, 9 Aug 2022 09:45:47 +0000
Message-ID: <d9bd1c16-7096-d267-a0ff-d3742b0dcf56@sberdevices.ru>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <45822644-8e37-1625-5944-63fd5fc20dd3@sberdevices.ru>
 <20220808102335.nkviqobpgcmcaqhn@sgarzare-redhat>
 <CAGxU2F513N+0sB0fEz4EF7+NeELhW9w9Rk6hh5K7QQO+eXRymA@mail.gmail.com>
 <1ea271c1-d492-d7f7-5016-7650a72b6139@sberdevices.ru>
In-Reply-To: <1ea271c1-d492-d7f7-5016-7650a72b6139@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2868DFFEAF5C640B9B38E18318BDD06@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/09 07:32:00 #20083496
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDkuMDguMjAyMiAxMjozNywgQXJzZW5peSBLcmFzbm92IHdyb3RlOg0KPiBPbiAwOC4wOC4y
MDIyIDEzOjMwLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6DQo+PiBPbiBNb24sIEF1ZyA4LCAy
MDIyIGF0IDEyOjIzIFBNIFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVkaGF0LmNvbT4g
d3JvdGU6DQo+Pj4NCj4+PiBPbiBXZWQsIEF1ZyAwMywgMjAyMiBhdCAwMTo1MTowNVBNICswMDAw
LCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6DQo+Pj4+IFRoaXMgYWRkcyB0cmFuc3BvcnQgc3BlY2lm
aWMgY2FsbGJhY2sgZm9yIFNPX1JDVkxPV0FULCBiZWNhdXNlIGluIHNvbWUNCj4+Pj4gdHJhbnNw
b3J0cyBpdCBtYXkgYmUgZGlmZmljdWx0IHRvIGtub3cgY3VycmVudCBhdmFpbGFibGUgbnVtYmVy
IG9mIGJ5dGVzDQo+Pj4+IHJlYWR5IHRvIHJlYWQuIFRodXMsIHdoZW4gU09fUkNWTE9XQVQgaXMg
c2V0LCB0cmFuc3BvcnQgbWF5IHJlamVjdCBpdC4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTog
QXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQo+Pj4+IC0tLQ0KPj4+
PiBpbmNsdWRlL25ldC9hZl92c29jay5oICAgfCAgMSArDQo+Pj4+IG5ldC92bXdfdnNvY2svYWZf
dnNvY2suYyB8IDI1ICsrKysrKysrKysrKysrKysrKysrKysrKysNCj4+Pj4gMiBmaWxlcyBjaGFu
Z2VkLCAyNiBpbnNlcnRpb25zKCspDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25l
dC9hZl92c29jay5oIGIvaW5jbHVkZS9uZXQvYWZfdnNvY2suaA0KPj4+PiBpbmRleCBmNzQyZTUw
MjA3ZmIuLmVhZTU4NzRiYWUzNSAxMDA2NDQNCj4+Pj4gLS0tIGEvaW5jbHVkZS9uZXQvYWZfdnNv
Y2suaA0KPj4+PiArKysgYi9pbmNsdWRlL25ldC9hZl92c29jay5oDQo+Pj4+IEBAIC0xMzQsNiAr
MTM0LDcgQEAgc3RydWN0IHZzb2NrX3RyYW5zcG9ydCB7DQo+Pj4+ICAgICAgIHU2NCAoKnN0cmVh
bV9yY3ZoaXdhdCkoc3RydWN0IHZzb2NrX3NvY2sgKik7DQo+Pj4+ICAgICAgIGJvb2wgKCpzdHJl
YW1faXNfYWN0aXZlKShzdHJ1Y3QgdnNvY2tfc29jayAqKTsNCj4+Pj4gICAgICAgYm9vbCAoKnN0
cmVhbV9hbGxvdykodTMyIGNpZCwgdTMyIHBvcnQpOw0KPj4+PiArICAgICAgaW50ICgqc2V0X3Jj
dmxvd2F0KShzdHJ1Y3QgdnNvY2tfc29jayAqLCBpbnQpOw0KPj4+DQo+Pj4gY2hlY2twYXRjaCBz
dWdnZXN0cyB0byBhZGQgaWRlbnRpZmllciBuYW1lcy4gRm9yIHNvbWUgd2UgcHV0IHRoZW0gaW4s
DQo+Pj4gZm9yIG90aGVycyB3ZSBkaWRuJ3QsIGJ1dCBJIHN1Z2dlc3QgcHV0dGluZyB0aGVtIGlu
IGZvciB0aGUgbmV3IG9uZXMNCj4+PiBiZWNhdXNlIEkgdGhpbmsgaXQncyBjbGVhcmVyIHRvby4N
Cj4+Pg0KPj4+IFdBUk5JTkc6IGZ1bmN0aW9uIGRlZmluaXRpb24gYXJndW1lbnQgJ3N0cnVjdCB2
c29ja19zb2NrIConIHNob3VsZCBhbHNvDQo+Pj4gaGF2ZSBhbiBpZGVudGlmaWVyIG5hbWUNCj4+
PiAjMjU6IEZJTEU6IGluY2x1ZGUvbmV0L2FmX3Zzb2NrLmg6MTM3Og0KPj4+ICsgICAgICAgaW50
ICgqc2V0X3Jjdmxvd2F0KShzdHJ1Y3QgdnNvY2tfc29jayAqLCBpbnQpOw0KPj4+DQo+Pj4gV0FS
TklORzogZnVuY3Rpb24gZGVmaW5pdGlvbiBhcmd1bWVudCAnaW50JyBzaG91bGQgYWxzbyBoYXZl
IGFuIGlkZW50aWZpZXIgbmFtZQ0KPj4+ICMyNTogRklMRTogaW5jbHVkZS9uZXQvYWZfdnNvY2su
aDoxMzc6DQo+Pj4gKyAgICAgICBpbnQgKCpzZXRfcmN2bG93YXQpKHN0cnVjdCB2c29ja19zb2Nr
ICosIGludCk7DQo+Pj4NCj4+PiB0b3RhbDogMCBlcnJvcnMsIDIgd2FybmluZ3MsIDAgY2hlY2tz
LCA0NCBsaW5lcyBjaGVja2VkDQo+Pj4NCj4+Pj4NCj4+Pj4gICAgICAgLyogU0VRX1BBQ0tFVC4g
Ki8NCj4+Pj4gICAgICAgc3NpemVfdCAoKnNlcXBhY2tldF9kZXF1ZXVlKShzdHJ1Y3QgdnNvY2tf
c29jayAqdnNrLCBzdHJ1Y3QgbXNnaGRyICptc2csDQo+Pj4+IGRpZmYgLS1naXQgYS9uZXQvdm13
X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCj4+Pj4gaW5kZXgg
ZjA0YWJmNjYyZWM2Li4wMTZhZDVmZjc4YjcgMTAwNjQ0DQo+Pj4+IC0tLSBhL25ldC92bXdfdnNv
Y2svYWZfdnNvY2suYw0KPj4+PiArKysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCj4+Pj4g
QEAgLTIxMjksNiArMjEyOSwzMCBAQCB2c29ja19jb25uZWN0aWJsZV9yZWN2bXNnKHN0cnVjdCBz
b2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1zZywgc2l6ZV90IGxlbiwNCj4+Pj4gICAgICAg
cmV0dXJuIGVycjsNCj4+Pj4gfQ0KPj4+Pg0KPj4+PiArc3RhdGljIGludCB2c29ja19zZXRfcmN2
bG93YXQoc3RydWN0IHNvY2sgKnNrLCBpbnQgdmFsKQ0KPj4+PiArew0KPj4+PiArICAgICAgY29u
c3Qgc3RydWN0IHZzb2NrX3RyYW5zcG9ydCAqdHJhbnNwb3J0Ow0KPj4+PiArICAgICAgc3RydWN0
IHZzb2NrX3NvY2sgKnZzazsNCj4+Pj4gKyAgICAgIGludCBlcnIgPSAwOw0KPj4+PiArDQo+Pj4+
ICsgICAgICB2c2sgPSB2c29ja19zayhzayk7DQo+Pj4+ICsNCj4+Pj4gKyAgICAgIGlmICh2YWwg
PiB2c2stPmJ1ZmZlcl9zaXplKQ0KPj4+PiArICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsN
Cj4+Pj4gKw0KPj4+PiArICAgICAgdHJhbnNwb3J0ID0gdnNrLT50cmFuc3BvcnQ7DQo+Pj4+ICsN
Cj4+Pj4gKyAgICAgIGlmICghdHJhbnNwb3J0KQ0KPj4+PiArICAgICAgICAgICAgICByZXR1cm4g
LUVPUE5PVFNVUFA7DQo+Pj4NCj4+PiBJIGRvbid0IGtub3cgd2hldGhlciBpdCBpcyBiZXR0ZXIg
aW4gdGhpcyBjYXNlIHRvIHdyaXRlIGl0IGluDQo+Pj4gc2stPnNrX3Jjdmxvd2F0LCBtYXliZSB3
ZSBjYW4gcmV0dXJuIEVPUE5PVFNVUFAgb25seSB3aGVuIHRoZSB0cmFzcG9ydA0KPj4+IGlzIGFz
c2lnbmVkIGFuZCBzZXRfcmN2bG93YXQgaXMgbm90IGRlZmluZWQuIFRoaXMgaXMgYmVjYXVzZSB1
c3VhbGx5IHRoZQ0KPj4+IG9wdGlvbnMgYXJlIHNldCBqdXN0IGFmdGVyIGNyZWF0aW9uLCB3aGVu
IHRoZSB0cmFuc3BvcnQgaXMgcHJhY3RpY2FsbHkNCj4+PiB1bmFzc2lnbmVkLg0KPj4+DQo+Pj4g
SSBtZWFuIHNvbWV0aGluZyBsaWtlIHRoaXM6DQo+Pj4NCj4+PiAgICAgICAgICBpZiAodHJhbnNw
b3J0KSB7DQo+Pj4gICAgICAgICAgICAgICAgICBpZiAodHJhbnNwb3J0LT5zZXRfcmN2bG93YXQp
DQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiB0cmFuc3BvcnQtPnNldF9yY3Zs
b3dhdCh2c2ssIHZhbCk7DQo+Pj4gICAgICAgICAgICAgICAgICBlbHNlDQo+Pj4gICAgICAgICAg
ICAgICAgICAgICAgICAgIHJldHVybiAtRU9QTk9UU1VQUDsNCj4+PiAgICAgICAgICB9DQo+Pj4N
Cj4+PiAgICAgICAgICBXUklURV9PTkNFKHNrLT5za19yY3Zsb3dhdCwgdmFsID8gOiAxKTsNCj4+
Pg0KPj4+ICAgICAgICAgIHJldHVybiAwOw0KPj4NCj4+IFNpbmNlIGh2X3NvY2sgaW1wbGVtZW50
cyBgc2V0X3Jjdmxvd2F0YCB0byByZXR1cm4gRU9QTk9UU1VQUC4gbWF5YmUgd2UgDQo+PiBjYW4g
anVzdCBkbyB0aGUgZm9sbG93aW5nOg0KPj4NCj4+ICAgICAgICAgaWYgKHRyYW5zcG9ydCAmJiB0
cmFuc3BvcnQtPnNldF9yY3Zsb3dhdCkNCj4+ICAgICAgICAgICAgICAgICByZXR1cm4gdHJhbnNw
b3J0LT5zZXRfcmN2bG93YXQodnNrLCB2YWwpOw0KPj4NCj4+ICAgICAgICAgV1JJVEVfT05DRShz
ay0+c2tfcmN2bG93YXQsIHZhbCA/IDogMSk7DQo+PiAgICAgICAgIHJldHVybiAwOw0KPj4NCj4+
IFRoYXQgaXMsIHRoZSBkZWZhdWx0IGJlaGF2aW9yIGlzIHRvIHNldCBzay0+c2tfcmN2bG93YXQs
IGJ1dCBmb3IgDQo+PiB0cmFuc3BvcnRzIHRoYXQgd2FudCBhIGRpZmZlcmVudCBiZWhhdmlvciwg
dGhleSBuZWVkIHRvIGRlZmluZSANCj4+IHNldF9yY3Zsb3dhdCgpIChsaWtlIGh2X3NvY2spLg0K
PiBIbSBvaywgaSBzZWUuIEkndmUgaW1wbGVtZW50ZWQgbG9naWMgd2hlbiBub24tZW1wdHkgdHJh
bnNwb3J0IGlzIHJlcXVpcmVkLCBiZWNhdXNlIGh5cGVydiB0cmFuc3BvcnQNCj4gZm9yYmlkcyB0
byBzZXQgU09fUkNWTE9XQVQsIHNvIHVzZXIgbmVlZHMgdG8gY2FsbCB0aGlzIHNldHNvY2tvcHQg
QUZURVIgdHJhbnNwb3J0IGlzIGFzc2lnbmVkKHRvIGNoZWNrDQo+IHRoYXQgdHJhbnNwb3J0IGFs
bG93cyBpdC4gTm90IGFmdGVyIHNvY2tldCBjcmVhdGlvbiBhcyBZb3UgbWVudGlvbmVkIGFib3Zl
KS4gT3RoZXJ3aXNlIHRoZXJlIGlzIG5vIHNlbnNlDQo+IGluIHN1Y2ggY2FsbGJhY2sgLSBpdCB3
aWxsIGJlIG5ldmVyIHVzZWQuIEFsc28gaW4gY29kZSBhYm92ZSAtIGZvciBoeXBlcnYgd2Ugd2ls
bCBoYXZlIGRpZmZlcmVudCBiZWhhdmlvcg0KPiBkZXBlbmRzIG9uIHdoZW4gc2V0X3Jjdmxvd2F0
IGlzIGNhbGxlZDogYmVmb3JlIG9yIGFmdGVyIHRyYW5zcG9ydCBhc3NpZ25tZW50LiBJcyBpdCBv
az8NCnNvcnJ5LCBpIG1lYW46IGZvciBoeXBlcnYsIGlmIHVzZXIgc2V0cyBza19yY3Zsb3dhdCBi
ZWZvcmUgdHJhbnNwb3J0IGlzIGFzc2lnbmVkLCBpdCBzZWVzIDAgLSBzdWNjZXNzLCBidXQgaW4g
ZmFjdA0KaHlwZXJ2IHRyYW5zcG9ydCBmb3JiaWRzIHRoaXMgb3B0aW9uLg0KPj4NCj4+IFRoYW5r
cywNCj4+IFN0ZWZhbm8NCj4+DQo+IA0KDQo=
