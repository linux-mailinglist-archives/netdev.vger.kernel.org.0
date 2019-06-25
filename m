Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5217F54D94
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfFYL0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:26:33 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:53144 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729595AbfFYL0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:26:32 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 342E9C012A;
        Tue, 25 Jun 2019 11:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561461991; bh=vVKDdL95YK7O617w/US4DS9xOUVhdNnWIgicamkGlvc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cBUI74WG7KWVYQcH/H+W4D+8juUUQQnw2XABxipk1GJy/8RSoM8chZxwSzQKMGwbY
         pq/RVHl5xA55IaEJ/3WSvIArG2kH2tSoUCSUDl/+OoZQMpv/vTWwkJFvuwvHngqrNe
         IJuwBFrbxBDvrLBIksrtcwe2aX0yNBFqEM4IKfiSPoC+YgGN5DC0nThB57tJJ366uG
         dmfYfqZ4pgHEBe1Pga4nnzryv0oZ2tQWJl0ZL38mNhghC24ttnG+hXSCvzTqaEZlOf
         5Nw7emvKHJHORsJlg/dw6eX6yg8ZmEO5jYefHxtc8YauvxezNt5UC68Wru/SClbom7
         J0FDSEXkMi4gw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C6786A0065;
        Tue, 25 Jun 2019 11:26:27 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 25 Jun 2019 04:25:43 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Tue,
 25 Jun 2019 13:25:40 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Convert to phylink and remove
 phylib logic
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Convert to phylink and
 remove phylib logic
Thread-Index: AQHVIGkArVRmnWNiHUiOZ+Vq9aFNYKahDpUAgAAiuoD//+CkgIAAIfYQ///oM4CAAFRJgIAASacAgALGAQCAB4+TsIAAGyiAgAAlVRA=
Date:   Tue, 25 Jun 2019 11:25:40 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B9D76C2@DE02WEMBXB.internal.synopsys.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <6226d6a0de5929ed07d64b20472c52a86e71383d.1560266175.git.joabreu@synopsys.com>
 <d9ffce3d-4827-fa4a-89e8-0492c4bc1848@nvidia.com>
 <78EB27739596EE489E55E81C33FEC33A0B9C8D6E@DE02WEMBXB.internal.synopsys.com>
 <26cfaeff-a310-3b79-5b57-fd9c93bd8929@nvidia.com>
 <78EB27739596EE489E55E81C33FEC33A0B9C8DD9@DE02WEMBXB.internal.synopsys.com>
 <b66c7578-172f-4443-f4c3-411525e28738@nvidia.com>
 <d96f8bea-f7ef-82ae-01ba-9c97aec0ee38@nvidia.com>
 <6f36b6b6-8209-ed98-e7e1-3dac0a92f6cd@nvidia.com>
 <7f0f2ed0-f47c-4670-d169-25f0413c1fd3@nvidia.com>
 <78EB27739596EE489E55E81C33FEC33A0B9D7024@DE02WEMBXB.internal.synopsys.com>
 <113f37a2-c37f-cdb5-5194-4361d949258a@nvidia.com>
In-Reply-To: <113f37a2-c37f-cdb5-5194-4361d949258a@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.16]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQoNCj4gSSBoYXZlIGJlZW4g
bG9va2luZyBhdCB0aGlzIGEgYml0IGNsb3NlciBhbmQgSSBjYW4gc2VlIHRoZSBwcm9ibGVtLiBX
aGF0DQo+IGhhcHBlbnMgaXMgdGhhdCAuLi4NCj4gDQo+IDEuIHN0bW1hY19tYWNfbGlua191cCgp
IGlzIGNhbGxlZCBhbmQgcHJpdi0+ZWVlX2FjdGl2ZSBpcyBzZXQgdG8gZmFsc2UNCj4gMi4gc3Rt
bWFjX2VlZV9pbml0KCkgaXMgY2FsbGVkIGJ1dCBiZWNhdXNlIHByaXYtPmVlZV9hY3RpdmUgaXMg
ZmFsc2UsDQo+ICAgIHRpbWVyX3NldHVwKCkgZm9yIGVlZV9jdHJsX3RpbWVyIGlzIG5ldmVyIGNh
bGxlZC4NCj4gMy4gc3RtbWFjX2VlZV9pbml0KCkgcmV0dXJucyB0cnVlIGFuZCBzbyB0aGVuIHBy
aXYtPmVlZV9lbmFibGVkIGlzIHNldCANCj4gICAgdG8gdHJ1ZS4NCj4gNC4gV2hlbiBzdG1tYWNf
dHhfY2xlYW4oKSBpcyBjYWxsZWQgYmVjYXVzZSBwcml2LT5lZWVfZW5hYmxlZCBpcyBzZXQgdG8g
ICAgDQo+ICAgIHRydWUsIG1vZF90aW1lcigpIGlzIGNhbGxlZCBmb3IgdGhlIGVlZV9jdHJsX3Rp
bWVyLCBidXQgYmVjYXVzZSANCj4gICAgdGltZXJfc2V0dXAoKSB3YXMgbmV2ZXIgY2FsbGVkLCB3
ZSBoaXQgdGhlIEJVRyBkZWZpbmVkIGF0DQo+ICAgIGtlcm5lbC90aW1lL3RpbWVyLmM6OTUyLCBi
ZWNhdXNlIG5vIGZ1bmN0aW9uIGlzIGRlZmluZWQgZm9yIHRoZSANCj4gICAgdGltZXIuDQo+IA0K
PiBUaGUgZm9sbG93aW5nIGZpeGVzIGl0IGZvciBtZSAuLi4NCj4gDQo+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiBAQCAtMzk5LDEw
ICszOTksMTMgQEAgYm9vbCBzdG1tYWNfZWVlX2luaXQoc3RydWN0IHN0bW1hY19wcml2ICpwcml2
KQ0KPiAgICAgICAgIG11dGV4X2xvY2soJnByaXYtPmxvY2spOw0KPiAgDQo+ICAgICAgICAgLyog
Q2hlY2sgaWYgaXQgbmVlZHMgdG8gYmUgZGVhY3RpdmF0ZWQgKi8NCj4gLSAgICAgICBpZiAoIXBy
aXYtPmVlZV9hY3RpdmUgJiYgcHJpdi0+ZWVlX2VuYWJsZWQpIHsNCj4gLSAgICAgICAgICAgICAg
IG5ldGRldl9kYmcocHJpdi0+ZGV2LCAiZGlzYWJsZSBFRUVcbiIpOw0KPiAtICAgICAgICAgICAg
ICAgZGVsX3RpbWVyX3N5bmMoJnByaXYtPmVlZV9jdHJsX3RpbWVyKTsNCj4gLSAgICAgICAgICAg
ICAgIHN0bW1hY19zZXRfZWVlX3RpbWVyKHByaXYsIHByaXYtPmh3LCAwLCB0eF9scGlfdGltZXIp
Ow0KPiArICAgICAgIGlmICghcHJpdi0+ZWVlX2FjdGl2ZSkgew0KPiArICAgICAgICAgICAgICAg
aWYgKHByaXYtPmVlZV9lbmFibGVkKSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIG5ldGRl
dl9kYmcocHJpdi0+ZGV2LCAiZGlzYWJsZSBFRUVcbiIpOw0KPiArICAgICAgICAgICAgICAgICAg
ICAgICBkZWxfdGltZXJfc3luYygmcHJpdi0+ZWVlX2N0cmxfdGltZXIpOw0KPiArICAgICAgICAg
ICAgICAgICAgICAgICBzdG1tYWNfc2V0X2VlZV90aW1lcihwcml2LCBwcml2LT5odywgMCwgdHhf
bHBpX3RpbWVyKTsNCj4gKyAgICAgICAgICAgICAgIH0NCj4gKyAgICAgICAgICAgICAgIG11dGV4
X3VubG9jaygmcHJpdi0+bG9jayk7DQo+ICAgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+
ICAgICAgICAgfQ0KPiANCj4gSXQgYWxzbyBsb29rcyBsaWtlIHlvdSBoYXZlIGEgcG90ZW50aW9u
IGRlYWRsb2NrIGluIHRoZSBjdXJyZW50IGNvZGUNCj4gYmVjYXVzZSBpbiB0aGUgY2FzZSBvZiBp
ZiAoIXByaXYtPmVlZV9hY3RpdmUgJiYgcHJpdi0+ZWVlX2VuYWJsZWQpDQo+IHlvdSBkb24ndCB1
bmxvY2sgdGhlIG11dGV4LiBUaGUgYWJvdmUgZml4ZXMgdGhpcyBhcyB3ZWxsLiBJIGNhbiBzZW5k
IGENCj4gZm9ybWFsIHBhdGNoIGlmIHRoaXMgbG9va3MgY29ycmVjdC4gDQoNClRoYW5rcyBmb3Ig
bG9va2luZyBpbnRvIHRoaXMhIFRoZSBmaXggbG9va3MgY29ycmVjdCBzbyBpZiB5b3UgY291bGQg
DQpzdWJtaXQgYSBwYXRjaCBpdCB3b3VsZCBiZSBncmVhdCENCg0KVGhhbmtzLA0KSm9zZSBNaWd1
ZWwgQWJyZXUNCg==
