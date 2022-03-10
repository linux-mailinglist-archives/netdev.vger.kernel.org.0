Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC944D4723
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 13:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242030AbiCJMi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 07:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiCJMi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 07:38:28 -0500
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BEF148902;
        Thu, 10 Mar 2022 04:37:24 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id D69095FD0A;
        Thu, 10 Mar 2022 15:37:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1646915842;
        bh=EYq5tKgfesKo6D2XVsUYPzfU6MR1bu8zAYZ0NrjCDsI=;
        h=From:To:Subject:Date:Message-ID:Reply-To:Content-Type:
         MIME-Version;
        b=UU2cy7hIiZ4eWPgcmEeBklBLPC56Tr7RlNAAWD/oc2l4q6CUJ17ueP/EmMnTKIGFn
         XcKE/4LueZBRK/MT9Z1njnFvytrMD9UHfvfTcRoN6iEYSNTMrPsi6Cz6Tvnlx201Ut
         r1gIFTwEl6FyMR2fPzoGNS0x7V8nI/xE6C5O2nlc7eIVz9QkcHSx62NiINfVrjJ1tO
         5JkSUGlLOAArPs1lpvduaus/XUe7dlq9R7D0/cDm3BADM6Nf9EK9HGOqqPTAdaXnYk
         l1/G7DpaqHiQhbUf1P93Ow/cgfBsnZakIMBZH9N8dXZY+zq25exkhSj3/vXR6rkDnk
         +oEv7NxYa4Oig==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 10 Mar 2022 15:37:22 +0300 (MSK)
From:   =?utf-8?B?0JrRgNCw0YHQvdC+0LIg0JDRgNGB0LXQvdC40Lkg0JLQu9Cw0LTQuNC80Lg=?=
         =?utf-8?B?0YDQvtCy0LjRhw==?= <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        =?utf-8?B?0KDQvtC60L7RgdC+0LIg0JTQvNC40YLRgNC40Lkg0JTQvNC40YLRgNC40LU=?=
         =?utf-8?B?0LLQuNGH?= <DDRokosov@sberdevices.ru>
Subject: 
Thread-Index: AQHYNHuOMj+fQ8zOQU2b4JDz69ksfQ==
Date:   Thu, 10 Mar 2022 12:37:14 +0000
Message-ID: <ea590468-0fa9-65f0-fbe9-7541ce005a09@sberdevices.ru>
Reply-To: "17514ec6-6e04-6ef9-73ba-b21da09f0f6f@sberdevices.ru" 
          <17514ec6-6e04-6ef9-73ba-b21da09f0f6f@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B03FE4090921B42938A8FA5DB53B983@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/10 08:46:00 #18933400
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbSA3ZTdjNzMwNWY2NGVlNTY2NWY4OTRkOThhMmIwMzkxNGY2YzhiYjViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmlj
ZXMucnU+DQpEYXRlOiBNb24sIDMgSmFuIDIwMjIgMTQ6NDU6MDUgKzAzMDANClN1YmplY3Q6IFtS
RkMgUEFUQ0ggdjEgMy8zXSBhZl92c29jazogU09DS19TRVFQQUNLRVQgYnJva2VuIGJ1ZmZlciB0
ZXN0DQoNCkFkZCB0ZXN0IHdoZXJlIHNlbmRlciBzZW5kcyB0d28gbWVzc2FnZSwgZWFjaCB3aXRo
IG93bg0KZGF0YSBwYXR0ZXJuLiBSZWFkZXIgdHJpZXMgdG8gcmVhZCBmaXJzdCB0byBicm9rZW4g
YnVmZmVyOg0KaXQgaGFzIHRocmVlIHBhZ2VzIHNpemUsIGJ1dCBtaWRkbGUgcGFnZSBpcyB1bm1h
cHBlZC4gVGhlbiwNCnJlYWRlciB0cmllcyB0byByZWFkIHNlY29uZCBtZXNzYWdlIHRvIHZhbGlk
IGJ1ZmZlci4gVGVzdA0KY2hlY2tzLCB0aGF0IHVuY29waWVkIHBhcnQgb2YgZmlyc3QgbWVzc2Fn
ZSB3YXMgZHJvcHBlZA0KYW5kIHRodXMgbm90IGNvcGllZCBhcyBwYXJ0IG9mIHNlY29uZCBtZXNz
YWdlLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2
aWNlcy5ydT4NCi0tLQ0KIHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIHwgMTIxICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgMTIxIGluc2Vy
dGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5j
IGIvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCmluZGV4IGFhMmRlMjdkMGY3Ny4u
Njg2YWY3MTJiNGFkIDEwMDY0NA0KLS0tIGEvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0
LmMNCisrKyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQpAQCAtMTYsNiArMTYs
NyBAQA0KICNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4NCiAjaW5jbHVkZSA8c3lzL3R5cGVzLmg+
DQogI2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4NCisjaW5jbHVkZSA8c3lzL21tYW4uaD4NCiANCiAj
aW5jbHVkZSAidGltZW91dC5oIg0KICNpbmNsdWRlICJjb250cm9sLmgiDQpAQCAtNDM1LDYgKzQz
NiwxMjEgQEAgc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfdGltZW91dF9zZXJ2ZXIoY29uc3Qg
c3RydWN0IHRlc3Rfb3B0cyAqb3B0cykNCiAJY2xvc2UoZmQpOw0KIH0NCiANCisjZGVmaW5lIEJV
Rl9QQVRURVJOXzEgJ2EnDQorI2RlZmluZSBCVUZfUEFUVEVSTl8yICdiJw0KKw0KK3N0YXRpYyB2
b2lkIHRlc3Rfc2VxcGFja2V0X2ludmFsaWRfcmVjX2J1ZmZlcl9jbGllbnQoY29uc3Qgc3RydWN0
IHRlc3Rfb3B0cyAqb3B0cykNCit7DQorCWludCBmZDsNCisJdW5zaWduZWQgY2hhciAqYnVmMTsN
CisJdW5zaWduZWQgY2hhciAqYnVmMjsNCisJaW50IGJ1Zl9zaXplID0gZ2V0cGFnZXNpemUoKSAq
IDM7DQorDQorCWZkID0gdnNvY2tfc2VxcGFja2V0X2Nvbm5lY3Qob3B0cy0+cGVlcl9jaWQsIDEy
MzQpOw0KKwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3IoImNvbm5lY3QiKTsNCisJCWV4aXQoRVhJ
VF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlidWYxID0gbWFsbG9jKGJ1Zl9zaXplKTsNCisJaWYgKGJ1
ZjEgPT0gTlVMTCkgew0KKwkJcGVycm9yKCInbWFsbG9jKCknIGZvciAnYnVmMSciKTsNCisJCWV4
aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlidWYyID0gbWFsbG9jKGJ1Zl9zaXplKTsNCisJ
aWYgKGJ1ZjIgPT0gTlVMTCkgew0KKwkJcGVycm9yKCInbWFsbG9jKCknIGZvciAnYnVmMiciKTsN
CisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwltZW1zZXQoYnVmMSwgQlVGX1BBVFRF
Uk5fMSwgYnVmX3NpemUpOw0KKwltZW1zZXQoYnVmMiwgQlVGX1BBVFRFUk5fMiwgYnVmX3NpemUp
Ow0KKw0KKwlpZiAoc2VuZChmZCwgYnVmMSwgYnVmX3NpemUsIDApICE9IGJ1Zl9zaXplKSB7DQor
CQlwZXJyb3IoInNlbmQgZmFpbGVkIik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisN
CisJaWYgKHNlbmQoZmQsIGJ1ZjIsIGJ1Zl9zaXplLCAwKSAhPSBidWZfc2l6ZSkgew0KKwkJcGVy
cm9yKCJzZW5kIGZhaWxlZCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWNs
b3NlKGZkKTsNCit9DQorDQorc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfaW52YWxpZF9yZWNf
YnVmZmVyX3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisJaW50IGZk
Ow0KKwl1bnNpZ25lZCBjaGFyICpicm9rZW5fYnVmOw0KKwl1bnNpZ25lZCBjaGFyICp2YWxpZF9i
dWY7DQorCWludCBwYWdlX3NpemUgPSBnZXRwYWdlc2l6ZSgpOw0KKwlpbnQgYnVmX3NpemUgPSBw
YWdlX3NpemUgKiAzOw0KKwlzc2l6ZV90IHJlczsNCisJaW50IHByb3QgPSBQUk9UX1JFQUQgfCBQ
Uk9UX1dSSVRFOw0KKwlpbnQgZmxhZ3MgPSBNQVBfUFJJVkFURSB8IE1BUF9BTk9OWU1PVVM7DQor
CWludCBpOw0KKw0KKwlmZCA9IHZzb2NrX3NlcXBhY2tldF9hY2NlcHQoVk1BRERSX0NJRF9BTlks
IDEyMzQsIE5VTEwpOw0KKwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3IoImFjY2VwdCIpOw0KKwkJ
ZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCS8qIFNldHVwIGZpcnN0IGJ1ZmZlci4gKi8N
CisJYnJva2VuX2J1ZiA9IG1tYXAoTlVMTCwgYnVmX3NpemUsIHByb3QsIGZsYWdzLCAtMSwgMCk7
DQorCWlmIChicm9rZW5fYnVmID09IE1BUF9GQUlMRUQpIHsNCisJCXBlcnJvcigibW1hcCBmb3Ig
J2Jyb2tlbl9idWYnIik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJLyogVW5t
YXAgImhvbGUiIGluIGJ1ZmZlci4gKi8NCisJaWYgKG11bm1hcChicm9rZW5fYnVmICsgcGFnZV9z
aXplLCBwYWdlX3NpemUpKSB7DQorCQlwZXJyb3IoIidicm9rZW5fYnVmJyBzZXR1cCIpOw0KKwkJ
ZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCXZhbGlkX2J1ZiA9IG1tYXAoTlVMTCwgYnVm
X3NpemUsIHByb3QsIGZsYWdzLCAtMSwgMCk7DQorCWlmICh2YWxpZF9idWYgPT0gTUFQX0ZBSUxF
RCkgew0KKwkJcGVycm9yKCJtbWFwIGZvciAndmFsaWRfYnVmJyIpOw0KKwkJZXhpdChFWElUX0ZB
SUxVUkUpOw0KKwl9DQorDQorCS8qIFRyeSB0byBmaWxsIGJ1ZmZlciB3aXRoIHVubWFwcGVkIG1p
ZGRsZS4gKi8NCisJcmVzID0gcmVhZChmZCwgYnJva2VuX2J1ZiwgYnVmX3NpemUpOw0KKwlpZiAo
cmVzICE9IC0xKSB7DQorCQlwZXJyb3IoImludmFsaWQgcmVhZCByZXN1bHQgb2YgJ2Jyb2tlbl9i
dWYnIik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJaWYgKGVycm5vICE9IEVO
T01FTSkgew0KKwkJcGVycm9yKCJpbnZhbGlkIGVycm5vIG9mICdicm9rZW5fYnVmJyIpOw0KKwkJ
ZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCS8qIFRyeSB0byBmaWxsIHZhbGlkIGJ1ZmZl
ci4gKi8NCisJcmVzID0gcmVhZChmZCwgdmFsaWRfYnVmLCBidWZfc2l6ZSk7DQorCWlmIChyZXMg
IT0gYnVmX3NpemUpIHsNCisJCXBlcnJvcigiaW52YWxpZCByZWFkIHJlc3VsdCBvZiAndmFsaWRf
YnVmJyIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWZvciAoaSA9IDA7IGkg
PCBidWZfc2l6ZTsgaSsrKSB7DQorCQlpZiAodmFsaWRfYnVmW2ldICE9IEJVRl9QQVRURVJOXzIp
IHsNCisJCQlwZXJyb3IoImludmFsaWQgcGF0dGVybiBmb3IgdmFsaWQgYnVmIik7DQorCQkJZXhp
dChFWElUX0ZBSUxVUkUpOw0KKwkJfQ0KKwl9DQorDQorDQorCS8qIFVubWFwIGJ1ZmZlcnMuICov
DQorCW11bm1hcChicm9rZW5fYnVmLCBwYWdlX3NpemUpOw0KKwltdW5tYXAoYnJva2VuX2J1ZiAr
IHBhZ2Vfc2l6ZSAqIDIsIHBhZ2Vfc2l6ZSk7DQorCW11bm1hcCh2YWxpZF9idWYsIGJ1Zl9zaXpl
KTsNCisJY2xvc2UoZmQpOw0KK30NCisNCiBzdGF0aWMgc3RydWN0IHRlc3RfY2FzZSB0ZXN0X2Nh
c2VzW10gPSB7DQogCXsNCiAJCS5uYW1lID0gIlNPQ0tfU1RSRUFNIGNvbm5lY3Rpb24gcmVzZXQi
LA0KQEAgLTQ4MCw2ICs1OTYsMTEgQEAgc3RhdGljIHN0cnVjdCB0ZXN0X2Nhc2UgdGVzdF9jYXNl
c1tdID0gew0KIAkJLnJ1bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tldF90aW1lb3V0X2NsaWVudCwN
CiAJCS5ydW5fc2VydmVyID0gdGVzdF9zZXFwYWNrZXRfdGltZW91dF9zZXJ2ZXIsDQogCX0sDQor
CXsNCisJCS5uYW1lID0gIlNPQ0tfU0VRUEFDS0VUIGludmFsaWQgcmVjZWl2ZSBidWZmZXIiLA0K
KwkJLnJ1bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tldF9pbnZhbGlkX3JlY19idWZmZXJfY2xpZW50
LA0KKwkJLnJ1bl9zZXJ2ZXIgPSB0ZXN0X3NlcXBhY2tldF9pbnZhbGlkX3JlY19idWZmZXJfc2Vy
dmVyLA0KKwl9LA0KIAl7fSwNCiB9Ow0KIA0KLS0gDQoyLjI1LjENCg==
