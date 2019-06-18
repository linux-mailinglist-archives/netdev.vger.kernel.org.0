Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8883549DBB
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbfFRJrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:47:06 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:60240 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729203AbfFRJrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:47:06 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E01AFC01A4;
        Tue, 18 Jun 2019 09:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1560851225; bh=Rqzx3uY9EUXjmjAhh+pT/tAUt/DkvOXA2RUyG7eB3Iw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=g8ZVwcnSCkJKtPUHXp0Z1d10qnnDXGbwdJiU0N+Psize73SDO8WvWLcvttGR4lqvi
         ZZntyzawO7F+5/3p66R2eojzGp3/oe/++bkIM/NueynMti1iyofEPQIwNOs3UwIq85
         8Pc5Z3afimrmtbymhO1uMDf7jvX0fRYgc6qWDoUL3JeO2zea4yb/gRV+3dOnhnBX2c
         Hcr20yDRg+i+D6OO4yyZmH6XzRbVIvg7MentW4GcjBOdVv7h7tT9/169gRWzXQmrb9
         e1tgpnLl9ohqwIBcCEXdjr4lJR5XWgxw2sF/YF5tZOsuU2ciGzRTjfiGs9wM/kGU2y
         YeCkp0sDLxgCA==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 15B30A0067;
        Tue, 18 Jun 2019 09:47:00 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 18 Jun 2019 02:47:00 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Tue,
 18 Jun 2019 11:46:58 +0200
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
Thread-Index: AQHVIGkArVRmnWNiHUiOZ+Vq9aFNYKahDpUAgAAiuoD//+CkgIAAIfYQ
Date:   Tue, 18 Jun 2019 09:46:57 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B9C8DD9@DE02WEMBXB.internal.synopsys.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <6226d6a0de5929ed07d64b20472c52a86e71383d.1560266175.git.joabreu@synopsys.com>
 <d9ffce3d-4827-fa4a-89e8-0492c4bc1848@nvidia.com>
 <78EB27739596EE489E55E81C33FEC33A0B9C8D6E@DE02WEMBXB.internal.synopsys.com>
 <26cfaeff-a310-3b79-5b57-fd9c93bd8929@nvidia.com>
In-Reply-To: <26cfaeff-a310-3b79-5b57-fd9c93bd8929@nvidia.com>
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

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQoNCj4gSSBhbSBub3QgY2Vy
dGFpbiBidXQgSSBkb24ndCBiZWxpZXZlIHNvLiBXZSBhcmUgdXNpbmcgYSBzdGF0aWMgSVAgYWRk
cmVzcw0KPiBhbmQgbW91bnRpbmcgdGhlIHJvb3QgZmlsZS1zeXN0ZW0gdmlhIE5GUyB3aGVuIHdl
IHNlZSB0aGlzIC4uLg0KDQpDYW4geW91IHBsZWFzZSBhZGQgYSBjYWxsIHRvIG5hcGlfc3luY2hy
b25pemUoKSBiZWZvcmUgZXZlcnkgDQpuYXBpX2Rpc2FibGUoKSBjYWxscywgbGlrZSB0aGlzOg0K
DQppZiAocXVldWUgPCByeF9xdWV1ZXNfY250KSB7DQoJbmFwaV9zeW5jaHJvbml6ZSgmY2gtPnJ4
X25hcGkpOw0KCW5hcGlfZGlzYWJsZSgmY2gtPnJ4X25hcGkpOw0KfQ0KDQppZiAocXVldWUgPCB0
eF9xdWV1ZXNfY250KSB7DQoJbmFwaV9zeW5jaHJvbml6ZSgmY2gtPnR4X25hcGkpOw0KCW5hcGlf
ZGlzYWJsZSgmY2gtPnR4X25hcGkpOw0KfQ0KDQpbIEkgY2FuIHNlbmQgeW91IGEgcGF0Y2ggaWYg
eW91IHByZWZlciBdDQoNClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
