Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5071F58D73A
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 12:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241990AbiHIKN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 06:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240734AbiHIKN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 06:13:27 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66804205FF;
        Tue,  9 Aug 2022 03:13:24 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id AFFAF5FD05;
        Tue,  9 Aug 2022 13:13:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660040002;
        bh=RuPMaus4MQ6lsSw9KXBYnAAR0elT3PN1eYYt6tfDqTY=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=VWWjG9NoYsZCXXmgP5BgGMmda8HffCYob7Q3SF+EEjPqCseRiX5ip9ypIaUsYKHFZ
         cY5UW7lfatzjyp7hlKSD2NtJxl+IKyOrHXM45klyL0B8tZDK5Pn+l1zE8HjUSzCu5N
         /habIcaey/9G0cZaB/d4Qqt2HMFtCvCN9n8HWhDao7jf1ZuCLA0UJWEbAXpLnYFuIN
         cWXQDCOeWR19H22WGuENvFl8VsB29frVFdTdCFYCIfyz7x7qbOggzIDJ8Lmfgvz8bL
         ihavW3gUYyB86uhgW7prQIYOYpDEuunBuPZNg4+uFvAB/jmO3vI6xuREg1+Ol+1UId
         pCJujnSOGj20w==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Tue,  9 Aug 2022 13:13:20 +0300 (MSK)
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
Thread-Index: AQHYp0ATlQNqO/GwP0WKlu98/YZplK2koQqAgAAB2ICAAYOigIAAAlCAgAAFEACAAAKagA==
Date:   Tue, 9 Aug 2022 10:13:14 +0000
Message-ID: <33b59f0e-0483-1fc1-dd9a-7b450c0ad49a@sberdevices.ru>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <45822644-8e37-1625-5944-63fd5fc20dd3@sberdevices.ru>
 <20220808102335.nkviqobpgcmcaqhn@sgarzare-redhat>
 <CAGxU2F513N+0sB0fEz4EF7+NeELhW9w9Rk6hh5K7QQO+eXRymA@mail.gmail.com>
 <1ea271c1-d492-d7f7-5016-7650a72b6139@sberdevices.ru>
 <d9bd1c16-7096-d267-a0ff-d3742b0dcf56@sberdevices.ru>
 <20220809100358.xnxromtvrehsgpn3@sgarzare-redhat>
In-Reply-To: <20220809100358.xnxromtvrehsgpn3@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <41DCB87C64838B4BA0BF12E4C27DD61A@sberdevices.ru>
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

T24gMDkuMDguMjAyMiAxMzowMywgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBUdWUs
IEF1ZyAwOSwgMjAyMiBhdCAwOTo0NTo0N0FNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBPbiAwOS4wOC4yMDIyIDEyOjM3LCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6DQo+Pj4gT24g
MDguMDguMjAyMiAxMzozMCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPj4+PiBPbiBNb24s
IEF1ZyA4LCAyMDIyIGF0IDEyOjIzIFBNIFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVk
aGF0LmNvbT4gd3JvdGU6DQo+Pj4+Pg0KPj4+Pj4gT24gV2VkLCBBdWcgMDMsIDIwMjIgYXQgMDE6
NTE6MDVQTSArMDAwMCwgQXJzZW5peSBLcmFzbm92IHdyb3RlOg0KPj4+Pj4+IFRoaXMgYWRkcyB0
cmFuc3BvcnQgc3BlY2lmaWMgY2FsbGJhY2sgZm9yIFNPX1JDVkxPV0FULCBiZWNhdXNlIGluIHNv
bWUNCj4+Pj4+PiB0cmFuc3BvcnRzIGl0IG1heSBiZSBkaWZmaWN1bHQgdG8ga25vdyBjdXJyZW50
IGF2YWlsYWJsZSBudW1iZXIgb2YgYnl0ZXMNCj4+Pj4+PiByZWFkeSB0byByZWFkLiBUaHVzLCB3
aGVuIFNPX1JDVkxPV0FUIGlzIHNldCwgdHJhbnNwb3J0IG1heSByZWplY3QgaXQuDQo+Pj4+Pj4N
Cj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2
aWNlcy5ydT4NCj4+Pj4+PiAtLS0NCj4+Pj4+PiBpbmNsdWRlL25ldC9hZl92c29jay5owqDCoCB8
wqAgMSArDQo+Pj4+Pj4gbmV0L3Ztd192c29jay9hZl92c29jay5jIHwgMjUgKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPj4+Pj4+IDIgZmlsZXMgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKQ0K
Pj4+Pj4+DQo+Pj4+Pj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmggYi9pbmNs
dWRlL25ldC9hZl92c29jay5oDQo+Pj4+Pj4gaW5kZXggZjc0MmU1MDIwN2ZiLi5lYWU1ODc0YmFl
MzUgMTAwNjQ0DQo+Pj4+Pj4gLS0tIGEvaW5jbHVkZS9uZXQvYWZfdnNvY2suaA0KPj4+Pj4+ICsr
KyBiL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmgNCj4+Pj4+PiBAQCAtMTM0LDYgKzEzNCw3IEBAIHN0
cnVjdCB2c29ja190cmFuc3BvcnQgew0KPj4+Pj4+IMKgwqDCoMKgwqAgdTY0ICgqc3RyZWFtX3Jj
dmhpd2F0KShzdHJ1Y3QgdnNvY2tfc29jayAqKTsNCj4+Pj4+PiDCoMKgwqDCoMKgIGJvb2wgKCpz
dHJlYW1faXNfYWN0aXZlKShzdHJ1Y3QgdnNvY2tfc29jayAqKTsNCj4+Pj4+PiDCoMKgwqDCoMKg
IGJvb2wgKCpzdHJlYW1fYWxsb3cpKHUzMiBjaWQsIHUzMiBwb3J0KTsNCj4+Pj4+PiArwqDCoMKg
wqDCoCBpbnQgKCpzZXRfcmN2bG93YXQpKHN0cnVjdCB2c29ja19zb2NrICosIGludCk7DQo+Pj4+
Pg0KPj4+Pj4gY2hlY2twYXRjaCBzdWdnZXN0cyB0byBhZGQgaWRlbnRpZmllciBuYW1lcy4gRm9y
IHNvbWUgd2UgcHV0IHRoZW0gaW4sDQo+Pj4+PiBmb3Igb3RoZXJzIHdlIGRpZG4ndCwgYnV0IEkg
c3VnZ2VzdCBwdXR0aW5nIHRoZW0gaW4gZm9yIHRoZSBuZXcgb25lcw0KPj4+Pj4gYmVjYXVzZSBJ
IHRoaW5rIGl0J3MgY2xlYXJlciB0b28uDQo+Pj4+Pg0KPj4+Pj4gV0FSTklORzogZnVuY3Rpb24g
ZGVmaW5pdGlvbiBhcmd1bWVudCAnc3RydWN0IHZzb2NrX3NvY2sgKicgc2hvdWxkIGFsc28NCj4+
Pj4+IGhhdmUgYW4gaWRlbnRpZmllciBuYW1lDQo+Pj4+PiAjMjU6IEZJTEU6IGluY2x1ZGUvbmV0
L2FmX3Zzb2NrLmg6MTM3Og0KPj4+Pj4gK8KgwqDCoMKgwqDCoCBpbnQgKCpzZXRfcmN2bG93YXQp
KHN0cnVjdCB2c29ja19zb2NrICosIGludCk7DQo+Pj4+Pg0KPj4+Pj4gV0FSTklORzogZnVuY3Rp
b24gZGVmaW5pdGlvbiBhcmd1bWVudCAnaW50JyBzaG91bGQgYWxzbyBoYXZlIGFuIGlkZW50aWZp
ZXIgbmFtZQ0KPj4+Pj4gIzI1OiBGSUxFOiBpbmNsdWRlL25ldC9hZl92c29jay5oOjEzNzoNCj4+
Pj4+ICvCoMKgwqDCoMKgwqAgaW50ICgqc2V0X3Jjdmxvd2F0KShzdHJ1Y3QgdnNvY2tfc29jayAq
LCBpbnQpOw0KPj4+Pj4NCj4+Pj4+IHRvdGFsOiAwIGVycm9ycywgMiB3YXJuaW5ncywgMCBjaGVj
a3MsIDQ0IGxpbmVzIGNoZWNrZWQNCj4+Pj4+DQo+Pj4+Pj4NCj4+Pj4+PiDCoMKgwqDCoMKgIC8q
IFNFUV9QQUNLRVQuICovDQo+Pj4+Pj4gwqDCoMKgwqDCoCBzc2l6ZV90ICgqc2VxcGFja2V0X2Rl
cXVldWUpKHN0cnVjdCB2c29ja19zb2NrICp2c2ssIHN0cnVjdCBtc2doZHIgKm1zZywNCj4+Pj4+
PiBkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay9hZl92c29jay5jIGIvbmV0L3Ztd192c29jay9h
Zl92c29jay5jDQo+Pj4+Pj4gaW5kZXggZjA0YWJmNjYyZWM2Li4wMTZhZDVmZjc4YjcgMTAwNjQ0
DQo+Pj4+Pj4gLS0tIGEvbmV0L3Ztd192c29jay9hZl92c29jay5jDQo+Pj4+Pj4gKysrIGIvbmV0
L3Ztd192c29jay9hZl92c29jay5jDQo+Pj4+Pj4gQEAgLTIxMjksNiArMjEyOSwzMCBAQCB2c29j
a19jb25uZWN0aWJsZV9yZWN2bXNnKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIg
Km1zZywgc2l6ZV90IGxlbiwNCj4+Pj4+PiDCoMKgwqDCoMKgIHJldHVybiBlcnI7DQo+Pj4+Pj4g
fQ0KPj4+Pj4+DQo+Pj4+Pj4gK3N0YXRpYyBpbnQgdnNvY2tfc2V0X3Jjdmxvd2F0KHN0cnVjdCBz
b2NrICpzaywgaW50IHZhbCkNCj4+Pj4+PiArew0KPj4+Pj4+ICvCoMKgwqDCoMKgIGNvbnN0IHN0
cnVjdCB2c29ja190cmFuc3BvcnQgKnRyYW5zcG9ydDsNCj4+Pj4+PiArwqDCoMKgwqDCoCBzdHJ1
Y3QgdnNvY2tfc29jayAqdnNrOw0KPj4+Pj4+ICvCoMKgwqDCoMKgIGludCBlcnIgPSAwOw0KPj4+
Pj4+ICsNCj4+Pj4+PiArwqDCoMKgwqDCoCB2c2sgPSB2c29ja19zayhzayk7DQo+Pj4+Pj4gKw0K
Pj4+Pj4+ICvCoMKgwqDCoMKgIGlmICh2YWwgPiB2c2stPmJ1ZmZlcl9zaXplKQ0KPj4+Pj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsNCj4+Pj4+PiArDQo+Pj4+
Pj4gK8KgwqDCoMKgwqAgdHJhbnNwb3J0ID0gdnNrLT50cmFuc3BvcnQ7DQo+Pj4+Pj4gKw0KPj4+
Pj4+ICvCoMKgwqDCoMKgIGlmICghdHJhbnNwb3J0KQ0KPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCByZXR1cm4gLUVPUE5PVFNVUFA7DQo+Pj4+Pg0KPj4+Pj4gSSBkb24ndCBrbm93
IHdoZXRoZXIgaXQgaXMgYmV0dGVyIGluIHRoaXMgY2FzZSB0byB3cml0ZSBpdCBpbg0KPj4+Pj4g
c2stPnNrX3Jjdmxvd2F0LCBtYXliZSB3ZSBjYW4gcmV0dXJuIEVPUE5PVFNVUFAgb25seSB3aGVu
IHRoZSB0cmFzcG9ydA0KPj4+Pj4gaXMgYXNzaWduZWQgYW5kIHNldF9yY3Zsb3dhdCBpcyBub3Qg
ZGVmaW5lZC4gVGhpcyBpcyBiZWNhdXNlIHVzdWFsbHkgdGhlDQo+Pj4+PiBvcHRpb25zIGFyZSBz
ZXQganVzdCBhZnRlciBjcmVhdGlvbiwgd2hlbiB0aGUgdHJhbnNwb3J0IGlzIHByYWN0aWNhbGx5
DQo+Pj4+PiB1bmFzc2lnbmVkLg0KPj4+Pj4NCj4+Pj4+IEkgbWVhbiBzb21ldGhpbmcgbGlrZSB0
aGlzOg0KPj4+Pj4NCj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqAgaWYgKHRyYW5zcG9ydCkgew0KPj4+
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHRyYW5zcG9ydC0+c2V0X3Jj
dmxvd2F0KQ0KPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybiB0cmFuc3BvcnQtPnNldF9yY3Zsb3dhdCh2c2ssIHZhbCk7DQo+Pj4+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbHNlDQo+Pj4+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FT1BOT1RTVVBQOw0K
Pj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCB9DQo+Pj4+Pg0KPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCBX
UklURV9PTkNFKHNrLT5za19yY3Zsb3dhdCwgdmFsID8gOiAxKTsNCj4+Pj4+DQo+Pj4+PiDCoMKg
wqDCoMKgwqDCoMKgIHJldHVybiAwOw0KPj4+Pg0KPj4+PiBTaW5jZSBodl9zb2NrIGltcGxlbWVu
dHMgYHNldF9yY3Zsb3dhdGAgdG8gcmV0dXJuIEVPUE5PVFNVUFAuIG1heWJlIHdlDQo+Pj4+IGNh
biBqdXN0IGRvIHRoZSBmb2xsb3dpbmc6DQo+Pj4+DQo+Pj4+IMKgwqDCoMKgwqDCoMKgIGlmICh0
cmFuc3BvcnQgJiYgdHJhbnNwb3J0LT5zZXRfcmN2bG93YXQpDQo+Pj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gdHJhbnNwb3J0LT5zZXRfcmN2bG93YXQodnNrLCB2YWwp
Ow0KPj4+Pg0KPj4+PiDCoMKgwqDCoMKgwqDCoCBXUklURV9PTkNFKHNrLT5za19yY3Zsb3dhdCwg
dmFsID8gOiAxKTsNCj4+Pj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7DQo+Pj4+DQo+Pj4+IFRo
YXQgaXMsIHRoZSBkZWZhdWx0IGJlaGF2aW9yIGlzIHRvIHNldCBzay0+c2tfcmN2bG93YXQsIGJ1
dCBmb3INCj4+Pj4gdHJhbnNwb3J0cyB0aGF0IHdhbnQgYSBkaWZmZXJlbnQgYmVoYXZpb3IsIHRo
ZXkgbmVlZCB0byBkZWZpbmUNCj4+Pj4gc2V0X3Jjdmxvd2F0KCkgKGxpa2UgaHZfc29jaykuDQo+
Pj4gSG0gb2ssIGkgc2VlLiBJJ3ZlIGltcGxlbWVudGVkIGxvZ2ljIHdoZW4gbm9uLWVtcHR5IHRy
YW5zcG9ydCBpcyByZXF1aXJlZCwgYmVjYXVzZSBoeXBlcnYgdHJhbnNwb3J0DQo+Pj4gZm9yYmlk
cyB0byBzZXQgU09fUkNWTE9XQVQsIHNvIHVzZXIgbmVlZHMgdG8gY2FsbCB0aGlzIHNldHNvY2tv
cHQgQUZURVIgdHJhbnNwb3J0IGlzIGFzc2lnbmVkKHRvIGNoZWNrDQo+Pj4gdGhhdCB0cmFuc3Bv
cnQgYWxsb3dzIGl0LiBOb3QgYWZ0ZXIgc29ja2V0IGNyZWF0aW9uIGFzIFlvdSBtZW50aW9uZWQg
YWJvdmUpLiBPdGhlcndpc2UgdGhlcmUgaXMgbm8gc2Vuc2UNCj4+PiBpbiBzdWNoIGNhbGxiYWNr
IC0gaXQgd2lsbCBiZSBuZXZlciB1c2VkLiBBbHNvIGluIGNvZGUgYWJvdmUgLSBmb3IgaHlwZXJ2
IHdlIHdpbGwgaGF2ZSBkaWZmZXJlbnQgYmVoYXZpb3INCj4+PiBkZXBlbmRzIG9uIHdoZW4gc2V0
X3Jjdmxvd2F0IGlzIGNhbGxlZDogYmVmb3JlIG9yIGFmdGVyIHRyYW5zcG9ydCBhc3NpZ25tZW50
LiBJcyBpdCBvaz8NCj4+IHNvcnJ5LCBpIG1lYW46IGZvciBoeXBlcnYsIGlmIHVzZXIgc2V0cyBz
a19yY3Zsb3dhdCBiZWZvcmUgdHJhbnNwb3J0IGlzIGFzc2lnbmVkLCBpdCBzZWVzIDAgLSBzdWNj
ZXNzLCBidXQgaW4gZmFjdA0KPj4gaHlwZXJ2IHRyYW5zcG9ydCBmb3JiaWRzIHRoaXMgb3B0aW9u
Lg0KPiANCj4gSSBzZWUsIGJ1dCBJIHRoaW5rIGl0J3MgYmV0dGVyIHRvIHNldCBpdCBhbmQgbm90
IHJlc3BlY3QgaW4gaHlwZXJ2IChhcyB3ZSd2ZSBwcmFjdGljYWxseSBkb25lIHVudGlsIG5vdyB3
aXRoIGFsbCB0cmFuc3BvcnRzKSB0aGFuIHRvIHByZXZlbnQgdGhlIHNldHRpbmcgdW50aWwgd2Ug
YXNzaWduIGEgdHJhbnNwb3J0Lg0KPiANCj4gQXQgbW9zdCB3aGVuIHdlIHVzZSBoeXBlcnYgYW55
d2F5IHdlIGdldCBub3RpZmllZCBwZXIgYnl0ZSwgc28gd2Ugc2hvdWxkIGp1c3QgZ2V0IG1vcmUg
bm90aWZpY2F0aW9ucyB0aGFuIHdlIGV4cGVjdC4NCnNlZSBpdCwgb2ssIHRoYW5rcw0KPiANCj4g
VGhhbmtzLA0KPiBTdGVmYW5vDQo+IA0KDQo=
