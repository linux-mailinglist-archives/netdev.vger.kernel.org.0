Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E455358D697
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 11:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiHIJho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 05:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbiHIJhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 05:37:42 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D5E1C10F;
        Tue,  9 Aug 2022 02:37:40 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id A7D845FD05;
        Tue,  9 Aug 2022 12:37:38 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660037858;
        bh=2DdyAtzagU1qRtqV2lJK0nAzEAra85U3delt8oqRUKc=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=H7Sf+5ag6KI+IBb6HlSaoHjNLgUkIQdIO7g2Sm1kFzFRbh12bWth5X6/OkGvi28Gy
         iMi8Vchbc0jgc4Mdx5E0uel7NHD63GMOUOzn7yGvFxRNrCniITci3dOpak2rZDzKQ0
         PodZHYdV6gJxFnA/6nrTrRq4t6pwDoe6Peb0hCFiuhCRP2vNildI6o1/rQqgoktFC7
         DkBj6eepsNjGUporsQM9W7Vmlw6Gam0OiOkqnJq+t3H2/2+G7J1L7TDVLsCbh0ydDX
         4MECtzkJxCHg467X7yqdyV4LfLLdnNeKbDtnv2BxeJzgbyf9shNiQpOSAtDq1urqfm
         kHdb44Dwu4IJg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Tue,  9 Aug 2022 12:37:36 +0300 (MSK)
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
Thread-Index: AQHYp0ATlQNqO/GwP0WKlu98/YZplK2koQqAgAAB2ICAAYOigA==
Date:   Tue, 9 Aug 2022 09:37:31 +0000
Message-ID: <1ea271c1-d492-d7f7-5016-7650a72b6139@sberdevices.ru>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <45822644-8e37-1625-5944-63fd5fc20dd3@sberdevices.ru>
 <20220808102335.nkviqobpgcmcaqhn@sgarzare-redhat>
 <CAGxU2F513N+0sB0fEz4EF7+NeELhW9w9Rk6hh5K7QQO+eXRymA@mail.gmail.com>
In-Reply-To: <CAGxU2F513N+0sB0fEz4EF7+NeELhW9w9Rk6hh5K7QQO+eXRymA@mail.gmail.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0B6EEECE4FC3D4C8F906F0394EDE15A@sberdevices.ru>
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

T24gMDguMDguMjAyMiAxMzozMCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBNb24s
IEF1ZyA4LCAyMDIyIGF0IDEyOjIzIFBNIFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVk
aGF0LmNvbT4gd3JvdGU6DQo+Pg0KPj4gT24gV2VkLCBBdWcgMDMsIDIwMjIgYXQgMDE6NTE6MDVQ
TSArMDAwMCwgQXJzZW5peSBLcmFzbm92IHdyb3RlOg0KPj4+IFRoaXMgYWRkcyB0cmFuc3BvcnQg
c3BlY2lmaWMgY2FsbGJhY2sgZm9yIFNPX1JDVkxPV0FULCBiZWNhdXNlIGluIHNvbWUNCj4+PiB0
cmFuc3BvcnRzIGl0IG1heSBiZSBkaWZmaWN1bHQgdG8ga25vdyBjdXJyZW50IGF2YWlsYWJsZSBu
dW1iZXIgb2YgYnl0ZXMNCj4+PiByZWFkeSB0byByZWFkLiBUaHVzLCB3aGVuIFNPX1JDVkxPV0FU
IGlzIHNldCwgdHJhbnNwb3J0IG1heSByZWplY3QgaXQuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5
OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCj4+PiAtLS0NCj4+
PiBpbmNsdWRlL25ldC9hZl92c29jay5oICAgfCAgMSArDQo+Pj4gbmV0L3Ztd192c29jay9hZl92
c29jay5jIHwgMjUgKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4+IDIgZmlsZXMgY2hhbmdl
ZCwgMjYgaW5zZXJ0aW9ucygrKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2Fm
X3Zzb2NrLmggYi9pbmNsdWRlL25ldC9hZl92c29jay5oDQo+Pj4gaW5kZXggZjc0MmU1MDIwN2Zi
Li5lYWU1ODc0YmFlMzUgMTAwNjQ0DQo+Pj4gLS0tIGEvaW5jbHVkZS9uZXQvYWZfdnNvY2suaA0K
Pj4+ICsrKyBiL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmgNCj4+PiBAQCAtMTM0LDYgKzEzNCw3IEBA
IHN0cnVjdCB2c29ja190cmFuc3BvcnQgew0KPj4+ICAgICAgIHU2NCAoKnN0cmVhbV9yY3ZoaXdh
dCkoc3RydWN0IHZzb2NrX3NvY2sgKik7DQo+Pj4gICAgICAgYm9vbCAoKnN0cmVhbV9pc19hY3Rp
dmUpKHN0cnVjdCB2c29ja19zb2NrICopOw0KPj4+ICAgICAgIGJvb2wgKCpzdHJlYW1fYWxsb3cp
KHUzMiBjaWQsIHUzMiBwb3J0KTsNCj4+PiArICAgICAgaW50ICgqc2V0X3Jjdmxvd2F0KShzdHJ1
Y3QgdnNvY2tfc29jayAqLCBpbnQpOw0KPj4NCj4+IGNoZWNrcGF0Y2ggc3VnZ2VzdHMgdG8gYWRk
IGlkZW50aWZpZXIgbmFtZXMuIEZvciBzb21lIHdlIHB1dCB0aGVtIGluLA0KPj4gZm9yIG90aGVy
cyB3ZSBkaWRuJ3QsIGJ1dCBJIHN1Z2dlc3QgcHV0dGluZyB0aGVtIGluIGZvciB0aGUgbmV3IG9u
ZXMNCj4+IGJlY2F1c2UgSSB0aGluayBpdCdzIGNsZWFyZXIgdG9vLg0KPj4NCj4+IFdBUk5JTkc6
IGZ1bmN0aW9uIGRlZmluaXRpb24gYXJndW1lbnQgJ3N0cnVjdCB2c29ja19zb2NrIConIHNob3Vs
ZCBhbHNvDQo+PiBoYXZlIGFuIGlkZW50aWZpZXIgbmFtZQ0KPj4gIzI1OiBGSUxFOiBpbmNsdWRl
L25ldC9hZl92c29jay5oOjEzNzoNCj4+ICsgICAgICAgaW50ICgqc2V0X3Jjdmxvd2F0KShzdHJ1
Y3QgdnNvY2tfc29jayAqLCBpbnQpOw0KPj4NCj4+IFdBUk5JTkc6IGZ1bmN0aW9uIGRlZmluaXRp
b24gYXJndW1lbnQgJ2ludCcgc2hvdWxkIGFsc28gaGF2ZSBhbiBpZGVudGlmaWVyIG5hbWUNCj4+
ICMyNTogRklMRTogaW5jbHVkZS9uZXQvYWZfdnNvY2suaDoxMzc6DQo+PiArICAgICAgIGludCAo
KnNldF9yY3Zsb3dhdCkoc3RydWN0IHZzb2NrX3NvY2sgKiwgaW50KTsNCj4+DQo+PiB0b3RhbDog
MCBlcnJvcnMsIDIgd2FybmluZ3MsIDAgY2hlY2tzLCA0NCBsaW5lcyBjaGVja2VkDQo+Pg0KPj4+
DQo+Pj4gICAgICAgLyogU0VRX1BBQ0tFVC4gKi8NCj4+PiAgICAgICBzc2l6ZV90ICgqc2VxcGFj
a2V0X2RlcXVldWUpKHN0cnVjdCB2c29ja19zb2NrICp2c2ssIHN0cnVjdCBtc2doZHIgKm1zZywN
Cj4+PiBkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay9hZl92c29jay5jIGIvbmV0L3Ztd192c29j
ay9hZl92c29jay5jDQo+Pj4gaW5kZXggZjA0YWJmNjYyZWM2Li4wMTZhZDVmZjc4YjcgMTAwNjQ0
DQo+Pj4gLS0tIGEvbmV0L3Ztd192c29jay9hZl92c29jay5jDQo+Pj4gKysrIGIvbmV0L3Ztd192
c29jay9hZl92c29jay5jDQo+Pj4gQEAgLTIxMjksNiArMjEyOSwzMCBAQCB2c29ja19jb25uZWN0
aWJsZV9yZWN2bXNnKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1zZywgc2l6
ZV90IGxlbiwNCj4+PiAgICAgICByZXR1cm4gZXJyOw0KPj4+IH0NCj4+Pg0KPj4+ICtzdGF0aWMg
aW50IHZzb2NrX3NldF9yY3Zsb3dhdChzdHJ1Y3Qgc29jayAqc2ssIGludCB2YWwpDQo+Pj4gK3sN
Cj4+PiArICAgICAgY29uc3Qgc3RydWN0IHZzb2NrX3RyYW5zcG9ydCAqdHJhbnNwb3J0Ow0KPj4+
ICsgICAgICBzdHJ1Y3QgdnNvY2tfc29jayAqdnNrOw0KPj4+ICsgICAgICBpbnQgZXJyID0gMDsN
Cj4+PiArDQo+Pj4gKyAgICAgIHZzayA9IHZzb2NrX3NrKHNrKTsNCj4+PiArDQo+Pj4gKyAgICAg
IGlmICh2YWwgPiB2c2stPmJ1ZmZlcl9zaXplKQ0KPj4+ICsgICAgICAgICAgICAgIHJldHVybiAt
RUlOVkFMOw0KPj4+ICsNCj4+PiArICAgICAgdHJhbnNwb3J0ID0gdnNrLT50cmFuc3BvcnQ7DQo+
Pj4gKw0KPj4+ICsgICAgICBpZiAoIXRyYW5zcG9ydCkNCj4+PiArICAgICAgICAgICAgICByZXR1
cm4gLUVPUE5PVFNVUFA7DQo+Pg0KPj4gSSBkb24ndCBrbm93IHdoZXRoZXIgaXQgaXMgYmV0dGVy
IGluIHRoaXMgY2FzZSB0byB3cml0ZSBpdCBpbg0KPj4gc2stPnNrX3Jjdmxvd2F0LCBtYXliZSB3
ZSBjYW4gcmV0dXJuIEVPUE5PVFNVUFAgb25seSB3aGVuIHRoZSB0cmFzcG9ydA0KPj4gaXMgYXNz
aWduZWQgYW5kIHNldF9yY3Zsb3dhdCBpcyBub3QgZGVmaW5lZC4gVGhpcyBpcyBiZWNhdXNlIHVz
dWFsbHkgdGhlDQo+PiBvcHRpb25zIGFyZSBzZXQganVzdCBhZnRlciBjcmVhdGlvbiwgd2hlbiB0
aGUgdHJhbnNwb3J0IGlzIHByYWN0aWNhbGx5DQo+PiB1bmFzc2lnbmVkLg0KPj4NCj4+IEkgbWVh
biBzb21ldGhpbmcgbGlrZSB0aGlzOg0KPj4NCj4+ICAgICAgICAgIGlmICh0cmFuc3BvcnQpIHsN
Cj4+ICAgICAgICAgICAgICAgICAgaWYgKHRyYW5zcG9ydC0+c2V0X3Jjdmxvd2F0KQ0KPj4gICAg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiB0cmFuc3BvcnQtPnNldF9yY3Zsb3dhdCh2c2ss
IHZhbCk7DQo+PiAgICAgICAgICAgICAgICAgIGVsc2UNCj4+ICAgICAgICAgICAgICAgICAgICAg
ICAgICByZXR1cm4gLUVPUE5PVFNVUFA7DQo+PiAgICAgICAgICB9DQo+Pg0KPj4gICAgICAgICAg
V1JJVEVfT05DRShzay0+c2tfcmN2bG93YXQsIHZhbCA/IDogMSk7DQo+Pg0KPj4gICAgICAgICAg
cmV0dXJuIDA7DQo+IA0KPiBTaW5jZSBodl9zb2NrIGltcGxlbWVudHMgYHNldF9yY3Zsb3dhdGAg
dG8gcmV0dXJuIEVPUE5PVFNVUFAuIG1heWJlIHdlIA0KPiBjYW4ganVzdCBkbyB0aGUgZm9sbG93
aW5nOg0KPiANCj4gICAgICAgICBpZiAodHJhbnNwb3J0ICYmIHRyYW5zcG9ydC0+c2V0X3Jjdmxv
d2F0KQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIHRyYW5zcG9ydC0+c2V0X3Jjdmxvd2F0KHZz
aywgdmFsKTsNCj4gDQo+ICAgICAgICAgV1JJVEVfT05DRShzay0+c2tfcmN2bG93YXQsIHZhbCA/
IDogMSk7DQo+ICAgICAgICAgcmV0dXJuIDA7DQo+IA0KPiBUaGF0IGlzLCB0aGUgZGVmYXVsdCBi
ZWhhdmlvciBpcyB0byBzZXQgc2stPnNrX3Jjdmxvd2F0LCBidXQgZm9yIA0KPiB0cmFuc3BvcnRz
IHRoYXQgd2FudCBhIGRpZmZlcmVudCBiZWhhdmlvciwgdGhleSBuZWVkIHRvIGRlZmluZSANCj4g
c2V0X3Jjdmxvd2F0KCkgKGxpa2UgaHZfc29jaykuDQpIbSBvaywgaSBzZWUuIEkndmUgaW1wbGVt
ZW50ZWQgbG9naWMgd2hlbiBub24tZW1wdHkgdHJhbnNwb3J0IGlzIHJlcXVpcmVkLCBiZWNhdXNl
IGh5cGVydiB0cmFuc3BvcnQNCmZvcmJpZHMgdG8gc2V0IFNPX1JDVkxPV0FULCBzbyB1c2VyIG5l
ZWRzIHRvIGNhbGwgdGhpcyBzZXRzb2Nrb3B0IEFGVEVSIHRyYW5zcG9ydCBpcyBhc3NpZ25lZCh0
byBjaGVjaw0KdGhhdCB0cmFuc3BvcnQgYWxsb3dzIGl0LiBOb3QgYWZ0ZXIgc29ja2V0IGNyZWF0
aW9uIGFzIFlvdSBtZW50aW9uZWQgYWJvdmUpLiBPdGhlcndpc2UgdGhlcmUgaXMgbm8gc2Vuc2UN
CmluIHN1Y2ggY2FsbGJhY2sgLSBpdCB3aWxsIGJlIG5ldmVyIHVzZWQuIEFsc28gaW4gY29kZSBh
Ym92ZSAtIGZvciBoeXBlcnYgd2Ugd2lsbCBoYXZlIGRpZmZlcmVudCBiZWhhdmlvcg0KZGVwZW5k
cyBvbiB3aGVuIHNldF9yY3Zsb3dhdCBpcyBjYWxsZWQ6IGJlZm9yZSBvciBhZnRlciB0cmFuc3Bv
cnQgYXNzaWdubWVudC4gSXMgaXQgb2s/DQo+IA0KPiBUaGFua3MsDQo+IFN0ZWZhbm8NCj4gDQoN
Cg==
