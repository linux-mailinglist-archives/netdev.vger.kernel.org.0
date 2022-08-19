Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B3F5994D2
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344692AbiHSFoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239690AbiHSFoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:44:22 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5F8AF4AB;
        Thu, 18 Aug 2022 22:44:19 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 0BFC15FD07;
        Fri, 19 Aug 2022 08:44:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660887857;
        bh=h7+HUP4tb8Cb9jo6wtjfQEUxhO6Pc+MKHncReNdMGME=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=hn2gNuz65CdxqlCUH3LsKVCMsiC7DIw25Ab3F+xYmtafaulSzB1IlazOogRHO7D1X
         3L4GXm8B6Xz0aRx9ObkTkHiURFpnooEO1W8w0We35Q5zBtUHXqa8koSxF+nXAkqxUF
         659Bi4Ms0Fsa/zqHEEtxXYZIhaqhEv0wCikhuOzs+rkG8W7VPo19JmK+8d/99b/v3X
         8T9go9O77Q5BnkIgcPcvmishuxMYPYdizOlv29/QBfuhTniBhPrnOMwixboJMzgYk2
         YtORgEGp7MP30s1vIMbrj7YFn3cB7LXA4h/DCdb/KJtC+2DaDyH28bp0R5/KKkD7NB
         88lv4lknSJu+Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:44:16 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: [PATCH net-next v4 9/9] vsock_test: POLLIN + SO_RCVLOWAT test
Thread-Topic: [PATCH net-next v4 9/9] vsock_test: POLLIN + SO_RCVLOWAT test
Thread-Index: AQHYs46oe5LFMy4RrEyUi4DF7J/0fw==
Date:   Fri, 19 Aug 2022 05:43:50 +0000
Message-ID: <5dac33eb-29d0-c4bc-a110-8519c8146d30@sberdevices.ru>
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF77E04B4C84C74881DD99B2AC186BC1@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/19 00:26:00 #20118704
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHRlc3QgdG8gY2hlY2ssIHRoYXQgd2hlbiBwb2xsKCkgcmV0dXJucyBQT0xMSU4s
IFBPTExSRE5PUk0gYml0cywNCm5leHQgcmVhZCBjYWxsIHdvbid0IGJsb2NrLg0KDQpTaWduZWQt
b2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NClJldmll
d2VkLWJ5OiBTdGVmYW5vIEdhcnphcmVsbGEgPHNnYXJ6YXJlQHJlZGhhdC5jb20+DQotLS0NCiB0
b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyB8IDEwOCArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDEwOCBpbnNlcnRpb25zKCspDQoNCmRpZmYg
LS1naXQgYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyBiL3Rvb2xzL3Rlc3Rpbmcv
dnNvY2svdnNvY2tfdGVzdC5jDQppbmRleCBkYzU3NzQ2MWFmYzIuLmJiNmQ2OTFjYjMwZCAxMDA2
NDQNCi0tLSBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQorKysgYi90b29scy90
ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KQEAgLTE4LDYgKzE4LDcgQEANCiAjaW5jbHVkZSA8
c3lzL3NvY2tldC5oPg0KICNpbmNsdWRlIDx0aW1lLmg+DQogI2luY2x1ZGUgPHN5cy9tbWFuLmg+
DQorI2luY2x1ZGUgPHBvbGwuaD4NCiANCiAjaW5jbHVkZSAidGltZW91dC5oIg0KICNpbmNsdWRl
ICJjb250cm9sLmgiDQpAQCAtNTk2LDYgKzU5NywxMDggQEAgc3RhdGljIHZvaWQgdGVzdF9zZXFw
YWNrZXRfaW52YWxpZF9yZWNfYnVmZmVyX3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpv
cHQNCiAJY2xvc2UoZmQpOw0KIH0NCiANCisjZGVmaW5lIFJDVkxPV0FUX0JVRl9TSVpFIDEyOA0K
Kw0KK3N0YXRpYyB2b2lkIHRlc3Rfc3RyZWFtX3BvbGxfcmN2bG93YXRfc2VydmVyKGNvbnN0IHN0
cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQorew0KKwlpbnQgZmQ7DQorCWludCBpOw0KKw0KKwlmZCA9
IHZzb2NrX3N0cmVhbV9hY2NlcHQoVk1BRERSX0NJRF9BTlksIDEyMzQsIE5VTEwpOw0KKwlpZiAo
ZmQgPCAwKSB7DQorCQlwZXJyb3IoImFjY2VwdCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0K
Kwl9DQorDQorCS8qIFNlbmQgMSBieXRlLiAqLw0KKwlzZW5kX2J5dGUoZmQsIDEsIDApOw0KKw0K
Kwljb250cm9sX3dyaXRlbG4oIlNSVlNFTlQiKTsNCisNCisJLyogV2FpdCB1bnRpbCBjbGllbnQg
aXMgcmVhZHkgdG8gcmVjZWl2ZSByZXN0IG9mIGRhdGEuICovDQorCWNvbnRyb2xfZXhwZWN0bG4o
IkNMTlNFTlQiKTsNCisNCisJZm9yIChpID0gMDsgaSA8IFJDVkxPV0FUX0JVRl9TSVpFIC0gMTsg
aSsrKQ0KKwkJc2VuZF9ieXRlKGZkLCAxLCAwKTsNCisNCisJLyogS2VlcCBzb2NrZXQgaW4gYWN0
aXZlIHN0YXRlLiAqLw0KKwljb250cm9sX2V4cGVjdGxuKCJQT0xMRE9ORSIpOw0KKw0KKwljbG9z
ZShmZCk7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIHRlc3Rfc3RyZWFtX3BvbGxfcmN2bG93YXRfY2xp
ZW50KGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQorew0KKwl1bnNpZ25lZCBsb25nIGxv
d2F0X3ZhbCA9IFJDVkxPV0FUX0JVRl9TSVpFOw0KKwljaGFyIGJ1ZltSQ1ZMT1dBVF9CVUZfU0la
RV07DQorCXN0cnVjdCBwb2xsZmQgZmRzOw0KKwlzc2l6ZV90IHJlYWRfcmVzOw0KKwlzaG9ydCBw
b2xsX2ZsYWdzOw0KKwlpbnQgZmQ7DQorDQorCWZkID0gdnNvY2tfc3RyZWFtX2Nvbm5lY3Qob3B0
cy0+cGVlcl9jaWQsIDEyMzQpOw0KKwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3IoImNvbm5lY3Qi
KTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlpZiAoc2V0c29ja29wdChmZCwg
U09MX1NPQ0tFVCwgU09fUkNWTE9XQVQsDQorCQkgICAgICAgJmxvd2F0X3ZhbCwgc2l6ZW9mKGxv
d2F0X3ZhbCkpKSB7DQorCQlwZXJyb3IoInNldHNvY2tvcHQiKTsNCisJCWV4aXQoRVhJVF9GQUlM
VVJFKTsNCisJfQ0KKw0KKwljb250cm9sX2V4cGVjdGxuKCJTUlZTRU5UIik7DQorDQorCS8qIEF0
IHRoaXMgcG9pbnQsIHNlcnZlciBzZW50IDEgYnl0ZS4gKi8NCisJZmRzLmZkID0gZmQ7DQorCXBv
bGxfZmxhZ3MgPSBQT0xMSU4gfCBQT0xMUkROT1JNOw0KKwlmZHMuZXZlbnRzID0gcG9sbF9mbGFn
czsNCisNCisJLyogVHJ5IHRvIHdhaXQgZm9yIDEgc2VjLiAqLw0KKwlpZiAocG9sbCgmZmRzLCAx
LCAxMDAwKSA8IDApIHsNCisJCXBlcnJvcigicG9sbCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUp
Ow0KKwl9DQorDQorCS8qIHBvbGwoKSBtdXN0IHJldHVybiBub3RoaW5nLiAqLw0KKwlpZiAoZmRz
LnJldmVudHMpIHsNCisJCWZwcmludGYoc3RkZXJyLCAiVW5leHBlY3RlZCBwb2xsIHJlc3VsdCAl
aHhcbiIsDQorCQkJZmRzLnJldmVudHMpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQor
DQorCS8qIFRlbGwgc2VydmVyIHRvIHNlbmQgcmVzdCBvZiBkYXRhLiAqLw0KKwljb250cm9sX3dy
aXRlbG4oIkNMTlNFTlQiKTsNCisNCisJLyogUG9sbCBmb3IgZGF0YS4gKi8NCisJaWYgKHBvbGwo
JmZkcywgMSwgMTAwMDApIDwgMCkgew0KKwkJcGVycm9yKCJwb2xsIik7DQorCQlleGl0KEVYSVRf
RkFJTFVSRSk7DQorCX0NCisNCisJLyogT25seSB0aGVzZSB0d28gYml0cyBhcmUgZXhwZWN0ZWQu
ICovDQorCWlmIChmZHMucmV2ZW50cyAhPSBwb2xsX2ZsYWdzKSB7DQorCQlmcHJpbnRmKHN0ZGVy
ciwgIlVuZXhwZWN0ZWQgcG9sbCByZXN1bHQgJWh4XG4iLA0KKwkJCWZkcy5yZXZlbnRzKTsNCisJ
CWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwkvKiBVc2UgTVNHX0RPTlRXQUlULCBpZiBj
YWxsIGlzIGdvaW5nIHRvIHdhaXQsIEVBR0FJTg0KKwkgKiB3aWxsIGJlIHJldHVybmVkLg0KKwkg
Ki8NCisJcmVhZF9yZXMgPSByZWN2KGZkLCBidWYsIHNpemVvZihidWYpLCBNU0dfRE9OVFdBSVQp
Ow0KKwlpZiAocmVhZF9yZXMgIT0gUkNWTE9XQVRfQlVGX1NJWkUpIHsNCisJCWZwcmludGYoc3Rk
ZXJyLCAiVW5leHBlY3RlZCByZWN2IHJlc3VsdCAlemlcbiIsDQorCQkJcmVhZF9yZXMpOw0KKwkJ
ZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWNvbnRyb2xfd3JpdGVsbigiUE9MTERPTkUi
KTsNCisNCisJY2xvc2UoZmQpOw0KK30NCisNCiBzdGF0aWMgc3RydWN0IHRlc3RfY2FzZSB0ZXN0
X2Nhc2VzW10gPSB7DQogCXsNCiAJCS5uYW1lID0gIlNPQ0tfU1RSRUFNIGNvbm5lY3Rpb24gcmVz
ZXQiLA0KQEAgLTY0Niw2ICs3NDksMTEgQEAgc3RhdGljIHN0cnVjdCB0ZXN0X2Nhc2UgdGVzdF9j
YXNlc1tdID0gew0KIAkJLnJ1bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tldF9pbnZhbGlkX3JlY19i
dWZmZXJfY2xpZW50LA0KIAkJLnJ1bl9zZXJ2ZXIgPSB0ZXN0X3NlcXBhY2tldF9pbnZhbGlkX3Jl
Y19idWZmZXJfc2VydmVyLA0KIAl9LA0KKwl7DQorCQkubmFtZSA9ICJTT0NLX1NUUkVBTSBwb2xs
KCkgKyBTT19SQ1ZMT1dBVCIsDQorCQkucnVuX2NsaWVudCA9IHRlc3Rfc3RyZWFtX3BvbGxfcmN2
bG93YXRfY2xpZW50LA0KKwkJLnJ1bl9zZXJ2ZXIgPSB0ZXN0X3N0cmVhbV9wb2xsX3Jjdmxvd2F0
X3NlcnZlciwNCisJfSwNCiAJe30sDQogfTsNCiANCi0tIA0KMi4yNS4xDQo=
