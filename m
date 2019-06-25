Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817B2524F2
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 09:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbfFYHhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 03:37:31 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:51418 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728479AbfFYHha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 03:37:30 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A0EFBC0246;
        Tue, 25 Jun 2019 07:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561448250; bh=0hdJqtZRKRFCAm+OSBWo1+z63ElRNgJ2jXFsP7pragI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=UUa8F07j5BjoGbbBqa7s7KQ9cHnosJNdCrOmDgjTpidsA7W43gVEmZ+v8vB1ogeGQ
         Pb/IrqMnccPIwMDP/ywnO7lZnNN6p/9bud7qHSVfhv6ePatj0ETz3EQ+aJRhEGBFc0
         IMKVAco7FXzwXviU05GSSK5lWEQXDxhlbjip5cyT2PxsfLjWe0mBi+OXBllOJ7BbGl
         J/DdLWO4/+MshgPeCOOvND+cDwcX61cSwdybceP9kXPKsSsegMn5wAmnZAAl1nFpt/
         KpV/QCL3iTE3iIZ+/6j831RonuXx8/tEQsGqtTrC9NL27AaE4t+hu0mJTbsC8EQYxh
         W2GzPUc++ISzg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 92003A005D;
        Tue, 25 Jun 2019 07:37:26 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 25 Jun 2019 00:37:26 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Tue,
 25 Jun 2019 09:37:24 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Convert to phylink and remove
 phylib logic
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Convert to phylink and
 remove phylib logic
Thread-Index: AQHVIGkArVRmnWNiHUiOZ+Vq9aFNYKahDpUAgAAiuoD//+CkgIAAIfYQ///oM4CAAFRJgIAASacAgALGAQCAB4+TsA==
Date:   Tue, 25 Jun 2019 07:37:23 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B9D7024@DE02WEMBXB.internal.synopsys.com>
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
In-Reply-To: <7f0f2ed0-f47c-4670-d169-25f0413c1fd3@nvidia.com>
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

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQoNCj4gQW55IGZ1cnRoZXIg
ZmVlZGJhY2s/IEkgYW0gc3RpbGwgc2VlaW5nIHRoaXMgaXNzdWUgb24gdG9kYXkncyAtbmV4dC4N
Cg0KQXBvbG9naWVzIGJ1dCBJIHdhcyBpbiBGVE8uDQoNCklzIHRoZXJlIGFueSBwb3NzaWJpbGl0
eSB5b3UgY2FuIGp1c3QgZGlzYWJsZSB0aGUgZXRoWCBjb25maWd1cmF0aW9uIGluIA0KdGhlIHJv
b3RmcyBtb3VudCBhbmQgbWFudWFsbHkgY29uZmlndXJlIGl0IGFmdGVyIHJvb3RmcyBpcyBkb25l
ID8NCg0KSSBqdXN0IHdhbnQgdG8gbWFrZSBzdXJlIGluIHdoaWNoIGNvbmRpdGlvbnMgdGhpcyBp
cyBoYXBwZW5pbmcgKGlmIGluIA0KaWZkb3duIG9yIGlmdXApLg0KDQpUaGFua3MsDQpKb3NlIE1p
Z3VlbCBBYnJldQ0K
