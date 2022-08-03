Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD40C588E40
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238614AbiHCOIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbiHCOIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:08:15 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A476B1AD87;
        Wed,  3 Aug 2022 07:08:13 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 0DDA05FD2E;
        Wed,  3 Aug 2022 17:08:12 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659535692;
        bh=ResIOTy9DtBCfFDcIrfJCTjPADSZ5tQYImGjTsxUyvo=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=E14IoBPL+HkaEvLV8EaXDedB2i5I726FYYid+Dewsx7VGANoqKf1j/gWfgR73hO3p
         1YIB+AjmxMDp88L1am8vuBqzP7KAXcDothTpeaR3GfY6dPvSSiPQ2VIEN19LmaSBqs
         r9FJc7irReqFiJ5CH6u52sryQXCvjaB8vzeitBcaHTh3QPTfMZiMZw4ANHYnSFyw/q
         qRXrTkyM2u7hKRPmLhZIXJzN+detRadYFg/Ll+9pL/WJQktDcvRdE5EzWs0pVysxjY
         d0Nmm+BNlwYXtAj1rRa3edIXkm2V9OE+acqtgcrGn8SUs5AtoVlgZE3wkxP02xEIm+
         ot3MhHaDIpP7g==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed,  3 Aug 2022 17:08:11 +0300 (MSK)
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
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Arseniy Krasnov" <AVKrasnov@sberdevices.ru>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 9/9] vsock_test: POLLIN + SO_RCVLOWAT test
Thread-Topic: [RFC PATCH v3 9/9] vsock_test: POLLIN + SO_RCVLOWAT test
Thread-Index: AQHYp0JvnFCQDy55x0SevzvDgZBQNA==
Date:   Wed, 3 Aug 2022 14:07:58 +0000
Message-ID: <1f50d595-cd37-ad61-f165-5632162dc682@sberdevices.ru>
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2E57A2760D9DA448AD28004CCE6BD1F@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/03 07:41:00 #20041172
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHRlc3QgdG8gY2hlY2ssdGhhdCB3aGVuIHBvbGwoKSByZXR1cm5zIFBPTExJTixQ
T0xMUkROT1JNIGJpdHMsDQpuZXh0IHJlYWQgY2FsbCB3b24ndCBibG9jay4NCg0KU2lnbmVkLW9m
Zi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQotLS0NCiB0
b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyB8IDEwNyArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDEwNyBpbnNlcnRpb25zKCspDQoNCmRpZmYg
LS1naXQgYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyBiL3Rvb2xzL3Rlc3Rpbmcv
dnNvY2svdnNvY2tfdGVzdC5jDQppbmRleCBkYzU3NzQ2MWFmYzIuLjkyMGRjNWQ1ZDk3OSAxMDA2
NDQNCi0tLSBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQorKysgYi90b29scy90
ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KQEAgLTE4LDYgKzE4LDcgQEANCiAjaW5jbHVkZSA8
c3lzL3NvY2tldC5oPg0KICNpbmNsdWRlIDx0aW1lLmg+DQogI2luY2x1ZGUgPHN5cy9tbWFuLmg+
DQorI2luY2x1ZGUgPHBvbGwuaD4NCiANCiAjaW5jbHVkZSAidGltZW91dC5oIg0KICNpbmNsdWRl
ICJjb250cm9sLmgiDQpAQCAtNTk2LDYgKzU5NywxMDcgQEAgc3RhdGljIHZvaWQgdGVzdF9zZXFw
YWNrZXRfaW52YWxpZF9yZWNfYnVmZmVyX3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpv
cHQNCiAJY2xvc2UoZmQpOw0KIH0NCiANCitzdGF0aWMgdm9pZCB0ZXN0X3N0cmVhbV9wb2xsX3Jj
dmxvd2F0X3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisjZGVmaW5l
IFJDVkxPV0FUX0JVRl9TSVpFIDEyOA0KKwlpbnQgZmQ7DQorCWludCBpOw0KKw0KKwlmZCA9IHZz
b2NrX3N0cmVhbV9hY2NlcHQoVk1BRERSX0NJRF9BTlksIDEyMzQsIE5VTEwpOw0KKwlpZiAoZmQg
PCAwKSB7DQorCQlwZXJyb3IoImFjY2VwdCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9
DQorDQorCS8qIFNlbmQgMSBieXRlLiAqLw0KKwlzZW5kX2J5dGUoZmQsIDEsIDApOw0KKw0KKwlj
b250cm9sX3dyaXRlbG4oIlNSVlNFTlQiKTsNCisNCisJLyogV2FpdCB1bnRpbCBjbGllbnQgaXMg
cmVhZHkgdG8gcmVjZWl2ZSByZXN0IG9mIGRhdGEuICovDQorCWNvbnRyb2xfZXhwZWN0bG4oIkNM
TlNFTlQiKTsNCisNCisJZm9yIChpID0gMDsgaSA8IFJDVkxPV0FUX0JVRl9TSVpFIC0gMTsgaSsr
KQ0KKwkJc2VuZF9ieXRlKGZkLCAxLCAwKTsNCisNCisJLyogS2VlcCBzb2NrZXQgaW4gYWN0aXZl
IHN0YXRlLiAqLw0KKwljb250cm9sX2V4cGVjdGxuKCJQT0xMRE9ORSIpOw0KKw0KKwljbG9zZShm
ZCk7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIHRlc3Rfc3RyZWFtX3BvbGxfcmN2bG93YXRfY2xpZW50
KGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQorew0KKwl1bnNpZ25lZCBsb25nIGxvd2F0
X3ZhbCA9IFJDVkxPV0FUX0JVRl9TSVpFOw0KKwljaGFyIGJ1ZltSQ1ZMT1dBVF9CVUZfU0laRV07
DQorCXN0cnVjdCBwb2xsZmQgZmRzOw0KKwlzc2l6ZV90IHJlYWRfcmVzOw0KKwlzaG9ydCBwb2xs
X2ZsYWdzOw0KKwlpbnQgZmQ7DQorDQorCWZkID0gdnNvY2tfc3RyZWFtX2Nvbm5lY3Qob3B0cy0+
cGVlcl9jaWQsIDEyMzQpOw0KKwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3IoImNvbm5lY3QiKTsN
CisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlpZiAoc2V0c29ja29wdChmZCwgU09M
X1NPQ0tFVCwgU09fUkNWTE9XQVQsDQorCQkJJmxvd2F0X3ZhbCwgc2l6ZW9mKGxvd2F0X3ZhbCkp
KSB7DQorCQlwZXJyb3IoInNldHNvY2tvcHQiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJ
fQ0KKw0KKwljb250cm9sX2V4cGVjdGxuKCJTUlZTRU5UIik7DQorDQorCS8qIEF0IHRoaXMgcG9p
bnQsIHNlcnZlciBzZW50IDEgYnl0ZS4gKi8NCisJZmRzLmZkID0gZmQ7DQorCXBvbGxfZmxhZ3Mg
PSBQT0xMSU4gfCBQT0xMUkROT1JNOw0KKwlmZHMuZXZlbnRzID0gcG9sbF9mbGFnczsNCisNCisJ
LyogVHJ5IHRvIHdhaXQgZm9yIDEgc2VjLiAqLw0KKwlpZiAocG9sbCgmZmRzLCAxLCAxMDAwKSA8
IDApIHsNCisJCXBlcnJvcigicG9sbCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQor
DQorCS8qIHBvbGwoKSBtdXN0IHJldHVybiBub3RoaW5nLiAqLw0KKwlpZiAoZmRzLnJldmVudHMp
IHsNCisJCWZwcmludGYoc3RkZXJyLCAiVW5leHBlY3RlZCBwb2xsIHJlc3VsdCAlaHhcbiIsDQor
CQkJZmRzLnJldmVudHMpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCS8qIFRl
bGwgc2VydmVyIHRvIHNlbmQgcmVzdCBvZiBkYXRhLiAqLw0KKwljb250cm9sX3dyaXRlbG4oIkNM
TlNFTlQiKTsNCisNCisJLyogUG9sbCBmb3IgZGF0YS4gKi8NCisJaWYgKHBvbGwoJmZkcywgMSwg
MTAwMDApIDwgMCkgew0KKwkJcGVycm9yKCJwb2xsIik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7
DQorCX0NCisNCisJLyogT25seSB0aGVzZSB0d28gYml0cyBhcmUgZXhwZWN0ZWQuICovDQorCWlm
IChmZHMucmV2ZW50cyAhPSBwb2xsX2ZsYWdzKSB7DQorCQlmcHJpbnRmKHN0ZGVyciwgIlVuZXhw
ZWN0ZWQgcG9sbCByZXN1bHQgJWh4XG4iLA0KKwkJCWZkcy5yZXZlbnRzKTsNCisJCWV4aXQoRVhJ
VF9GQUlMVVJFKTsNCisJfQ0KKw0KKwkvKiBVc2UgTVNHX0RPTlRXQUlULCBpZiBjYWxsIGlzIGdv
aW5nIHRvIHdhaXQsIEVBR0FJTg0KKwkgKiB3aWxsIGJlIHJldHVybmVkLg0KKwkgKi8NCisJcmVh
ZF9yZXMgPSByZWN2KGZkLCBidWYsIHNpemVvZihidWYpLCBNU0dfRE9OVFdBSVQpOw0KKwlpZiAo
cmVhZF9yZXMgIT0gUkNWTE9XQVRfQlVGX1NJWkUpIHsNCisJCWZwcmludGYoc3RkZXJyLCAiVW5l
eHBlY3RlZCByZWN2IHJlc3VsdCAlemlcbiIsDQorCQkJcmVhZF9yZXMpOw0KKwkJZXhpdChFWElU
X0ZBSUxVUkUpOw0KKwl9DQorDQorCWNvbnRyb2xfd3JpdGVsbigiUE9MTERPTkUiKTsNCisNCisJ
Y2xvc2UoZmQpOw0KK30NCisNCiBzdGF0aWMgc3RydWN0IHRlc3RfY2FzZSB0ZXN0X2Nhc2VzW10g
PSB7DQogCXsNCiAJCS5uYW1lID0gIlNPQ0tfU1RSRUFNIGNvbm5lY3Rpb24gcmVzZXQiLA0KQEAg
LTY0Niw2ICs3NDgsMTEgQEAgc3RhdGljIHN0cnVjdCB0ZXN0X2Nhc2UgdGVzdF9jYXNlc1tdID0g
ew0KIAkJLnJ1bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tldF9pbnZhbGlkX3JlY19idWZmZXJfY2xp
ZW50LA0KIAkJLnJ1bl9zZXJ2ZXIgPSB0ZXN0X3NlcXBhY2tldF9pbnZhbGlkX3JlY19idWZmZXJf
c2VydmVyLA0KIAl9LA0KKwl7DQorCQkubmFtZSA9ICJTT0NLX1NUUkVBTSBwb2xsKCkgKyBTT19S
Q1ZMT1dBVCIsDQorCQkucnVuX2NsaWVudCA9IHRlc3Rfc3RyZWFtX3BvbGxfcmN2bG93YXRfY2xp
ZW50LA0KKwkJLnJ1bl9zZXJ2ZXIgPSB0ZXN0X3N0cmVhbV9wb2xsX3Jjdmxvd2F0X3NlcnZlciwN
CisJfSwNCiAJe30sDQogfTsNCiANCi0tIA0KMi4yNS4xDQo=
