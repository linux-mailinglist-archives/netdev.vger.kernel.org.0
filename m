Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599C949D79
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfFRJf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:35:57 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:42492 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729113AbfFRJf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:35:56 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6CC45C01A2;
        Tue, 18 Jun 2019 09:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1560850555; bh=UPJFmJ4/GHL/ezVPvMkQlAsjd9cJ2dnSTtuqr/riI2M=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=XZAlMhXqCdms8ygkqDOaMK96m7G/ws/VVmKnokeUpwLhADCzzkX1nf5A3TXwvjpAa
         sK+m3NgfIn3qP52uZp7v20LkKjvVfpDT2/bYX69aKN2G8BIopjT+nZ+mUmfNfbWPDK
         aaIaWSJbEiHElyrWUFVMxGlSi35H3pNcwWaJj4xWEn0fix9n1B1CG3Z28rvBupn9kp
         4J4ag+u/Cujs4Kvz9ndam39WSXJrgqNAn4XIUBeZjLB/pvFMb3N8rnPOrVIi34LVad
         82/5qjeLhEmeuN6pe2cRQ17KkBm3rCng8ZAHRCqJiOxMNjUWy5Fnt2l3EFyYea2Ge7
         FQtBDjmaBdkvg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 88982A007F;
        Tue, 18 Jun 2019 09:35:50 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 18 Jun 2019 02:35:50 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Tue,
 18 Jun 2019 11:35:48 +0200
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
Thread-Index: AQHVIGkArVRmnWNiHUiOZ+Vq9aFNYKahDpUAgAAiuoA=
Date:   Tue, 18 Jun 2019 09:35:47 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B9C8D6E@DE02WEMBXB.internal.synopsys.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <6226d6a0de5929ed07d64b20472c52a86e71383d.1560266175.git.joabreu@synopsys.com>
 <d9ffce3d-4827-fa4a-89e8-0492c4bc1848@nvidia.com>
In-Reply-To: <d9ffce3d-4827-fa4a-89e8-0492c4bc1848@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.15]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQoNCj4gSSBhbSBzZWVpbmcg
YSBib290IHJlZ3Jlc3Npb24gb24gLW5leHQgZm9yIHNvbWUgb2Ygb3VyIGJvYXJkcyB0aGF0IGhh
dmUNCj4gYSBzeW5vcHN5cyBldGhlcm5ldCBjb250cm9sbGVyIHRoYXQgdXNlcyB0aGUgZHdtYWMt
ZHdjLXFvcy1ldGhlcm5ldA0KPiBkcml2ZXIuIEdpdCBiaXNlY3QgaXMgcG9pbnRpbmcgdG8gdGhp
cyBjb21taXQsIGJ1dCB1bmZvcnR1bmF0ZWx5IHRoaXMNCj4gY2Fubm90IGJlIGNsZWFubHkgcmV2
ZXJ0ZWQgb24gdG9wIG9mIC1uZXh0IHRvIGNvbmZpcm0uIA0KDQpUaGFua3MgZm9yIHJlcG9ydGlu
Zy4gTG9va3MgbGlrZSB0aGUgdGltZXIgaXMgbm90IHNldHVwIHdoZW4gDQpzdG1tYWNfdHhfY2xl
YW4oKSBpcyBjYWxsZWQuIFdoZW4gZG8geW91IHNlZSB0aGlzIHN0YWNrdHJhY2UgPyBBZnRlciAN
CmlmZG93biA/DQoNClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
