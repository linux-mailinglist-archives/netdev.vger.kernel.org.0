Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5323E07D
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfD2KZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:25:59 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:57060 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727608AbfD2KZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 06:25:58 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C00BDC0087;
        Mon, 29 Apr 2019 10:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1556533559; bh=z5eTlFYWQgzvaQeVi4z2PR7OioSoOCan0A0M7ft+gn0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=AtaFGGkjAPvJDpQd3JAVKtVDly3g731hAe5bIr4sHeExke95zn/ywMT/RRaUqgv3d
         aZIdswU4TMX7BKDK5Lerp2xZDmO1rZgMV+4WZjRljGfwLdex6Pj2s0e/i4h38gdcoc
         /c03GNuO59xmtVoLv43zbErL/1VMk5Gm8ZYXYFAWVtra4bulNwwRXqn8DfmSeJmEk1
         Mm3fIfFtFfHbfDAoLSgUxSU1xHkzIJOggqQrXInHJiTFVyfEmueZVnrd+3qhtf2x/9
         ehyTTdWmDDA9NJVgPr3DrWZK2tLXCjyr5O9BLG2/bqIJkTs5mMcNnwCOoUGZEEUW6e
         5mQgl+6UZVZxg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 1B09EA00B8;
        Mon, 29 Apr 2019 10:25:56 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 29 Apr 2019 03:25:56 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Mon,
 29 Apr 2019 12:25:54 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: RE: [PATCH 3/7] net: stmmac: dma channel control register need to
 be init first
Thread-Topic: [PATCH 3/7] net: stmmac: dma channel control register need to
 be init first
Thread-Index: AQHU+n6DdNJICrCLmkmtbuchA6NOs6ZMVDIAgAaifDA=
Date:   Mon, 29 Apr 2019 10:25:52 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B46E022@DE02WEMBXB.internal.synopsys.com>
References: <1556126241-2774-1-git-send-email-weifeng.voon@intel.com>
 <1556126241-2774-4-git-send-email-weifeng.voon@intel.com>
 <D6759987A7968C4889FDA6FA91D5CBC8146EF098@PGSMSX103.gar.corp.intel.com>
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC8146EF098@PGSMSX103.gar.corp.intel.com>
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

From: Voon, Weifeng <weifeng.voon@intel.com>
Date: Thu, Apr 25, 2019 at 08:06:08

> > stmmac_init_chan() needs to be called before stmmac_init_rx_chan() and
> > stmmac_init_tx_chan(). This is because if PBLx8 is to be used,
> > "DMA_CH(#i)_Control.PBLx8" needs to be set before programming
> > "DMA_CH(#i)_TX_Control.TxPBL" and "DMA_CH(#i)_RX_Control.RxPBL".
> >=20
> > Reviewed-by: Zhang, Baoli <baoli.zhang@intel.com>
> > Signed-off-by: Weifeng Voon <weifeng.voon@intel.com>
> > Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

This is a fix so it should belong to -net tree and it should have the=20
"Fixes: " tag.

Thanks,
Jose Miguel Abreu
