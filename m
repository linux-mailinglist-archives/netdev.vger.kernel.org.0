Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5F3E5FB
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfD2PTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:19:35 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:42724 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728249AbfD2PTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:19:35 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B1458C0081;
        Mon, 29 Apr 2019 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1556551176; bh=6ca6mfO960XBEcOh39ZiDJip0nWB/IKPMIyykJ70WEY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ej/ASn9kUF6DpwOz0Kaanp+8KeLtu2R8lijifgir3NVbN079ob8qsK6blxowQ7DM1
         jlTL16Trt+O2a0j9p1gAPt0/UPGwh6ysnVdhDsXVzjJ/2MDXQvuX5eO3bB85vuEpAR
         pQZfpuNveagwTo277SN+Db2E/OBh2g8kpo6N4jZLGWB9VABNt6LMTU++awUyEcrDlY
         w+mD1mrVhSOCKCv/q0xclu+HdiQGokZrQw8jEs4cQuBnDpAXzKB8kSHITx2s1tTpp7
         fXqICT3VEPMb101AeXIQo6OmPO9tCvPC1c7IYG8JEQF1KsaYaZ+oS58ETuUpUsAnpy
         sZmMoA24vKGpQ==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7CED8A006A;
        Mon, 29 Apr 2019 15:19:29 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 29 Apr 2019 08:19:28 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Mon,
 29 Apr 2019 17:19:17 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Biao Huang <biao.huang@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "yt.shen@mediatek.com" <yt.shen@mediatek.com>,
        "jianguo.zhang@mediatek.com" <jianguo.zhang@mediatek.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>
Subject: RE: [PATCH 2/2] net-next: stmmac: add mdio clause 45 access from
 mac device for dwmac4
Thread-Topic: [PATCH 2/2] net-next: stmmac: add mdio clause 45 access from
 mac device for dwmac4
Thread-Index: AQHU/lXExFDw5bAlc0G9MPOfQZ0kMKZTHp8AgAAh5QA=
Date:   Mon, 29 Apr 2019 15:19:16 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B46E5B4@DE02WEMBXB.internal.synopsys.com>
References: <1556519724-1576-1-git-send-email-biao.huang@mediatek.com>
 <1556519724-1576-3-git-send-email-biao.huang@mediatek.com>
 <AF233D1473C1364ABD51D28909A1B1B75C0C27ED@pgsmsx114.gar.corp.intel.com>
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B75C0C27ED@pgsmsx114.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong, Boon Leong <boon.leong.ong@intel.com>
Date: Mon, Apr 29, 2019 at 16:15:42

> What is the preference of the driver maintainer here? =20

Your implementation doesn't need the mdelay() so I think we should follow=20
your way once you also address the review comments from Andrew and me.

Maybe you can coordinate with Biao and submit a C45 implementation that=20
can be tested by both ?

Thanks,
Jose Miguel Abreu
