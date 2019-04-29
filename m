Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A83E3A8
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfD2NXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:23:34 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:35922 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbfD2NXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 09:23:34 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1A312C00C9;
        Mon, 29 Apr 2019 13:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1556544212; bh=Mflle1+S8Aliq2KJvkEHM5CV5/kFY6OCRX0cLLFEGAY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=SbZBNC01WoIzwIP7hzZyDQ3Rk+XCeJzqaCBLZFlVvVhjX8w1M0aselKh4oBk+2+zf
         lD1FsYsCU53FVMKM0yOjURKDEwTpuZRtd5wnuljCj0iaa8pmPXa7Nv+k4LgF/zRC2I
         psmGyGHtCGy1O8JJH7tqcupzT7f/kCJpGd2PTfLAkQ8WrLVJWUM2CAPuAJYOVe8mBr
         jJyAnY/xD8Jf489yymUkM1SRIl8oD9vizWZ+d3mJPvC8sA9Km0K7hU39h9GQjg40wF
         cMcRerTVL52CK3Sc6BBkqsQ/MuQO2OSE1j9X1UGyu8IeKajq50c/vTDWQt3ht1i5eP
         FwE1q+7bHZ1aA==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5B869A0065;
        Mon, 29 Apr 2019 13:23:29 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 29 Apr 2019 06:23:29 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Mon,
 29 Apr 2019 15:23:27 +0200
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
Subject: RE: [PATCH 4/7] net: stmmac: introducing support for DWC xPCS logics
Thread-Topic: [PATCH 4/7] net: stmmac: introducing support for DWC xPCS
 logics
Thread-Index: AQHU+oijzDBWZoWOSkutjbTSvGWKlaZMVEeAgAai8KA=
Date:   Mon, 29 Apr 2019 13:23:26 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B46E26B@DE02WEMBXB.internal.synopsys.com>
References: <1556126241-2774-1-git-send-email-weifeng.voon@intel.com>
 <1556126241-2774-5-git-send-email-weifeng.voon@intel.com>
 <D6759987A7968C4889FDA6FA91D5CBC8146EF0A8@PGSMSX103.gar.corp.intel.com>
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC8146EF0A8@PGSMSX103.gar.corp.intel.com>
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
Date: Thu, Apr 25, 2019 at 08:06:43

> > From: Ong Boon Leong <boon.leong.ong@intel.com>
> >=20
> > xPCS is DWC Ethernet Physical Coding Sublayer that may be integrated in=
to a
> > GbE controller that uses DWC EQoS MAC controller. An example of HW
> > configuration is shown below:-
> >=20
> >   <-----------------GBE Controller---------->|<--External PHY chip-->
> >=20
> >   +----------+         +----+    +---+               +--------------+
> >   |   EQoS   | <-GMII->|xPCS|<-->|L1 | <-- SGMII --> | External GbE |
> >   |   MAC    |         |    |    |PHY|               | PHY Chip     |
> >   +----------+         +----+    +---+               +--------------+
> >          ^               ^                                  ^
> >          |               |                                  |
> >          +---------------------MDIO-------------------------+
> >=20
> > xPCS is a Clause-45 MDIO Manageable Device (MMD) and we need a way to
> > differentiate it from external PHY chip that is discovered over MDIO.
> > Therefore, xpcs_phy_addr is introduced in stmmac platform data
> > (plat_stmmacenet_data) for differentiating xPCS from 'phy_addr' that
> > belongs to external PHY.
> >=20
> > Basic functionalities for initializing xPCS and configuring auto negoti=
ation (AN),
> > loopback, link status, AN advertisement and Link Partner ability are
> > implemented.
> >=20
> > xPCS interrupt handling for C37 AN complete is also implemented.
> >=20
> > Tested-by: Kweh Hock Leong <hock.leong.kweh@intel.com>
> > Reviewed-by: Chuah Kim Tatt <kim.tatt.chuah@intel.com>
> > Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
> > Reviewed-by: Kweh Hock Leong <hock.leong.kweh@intel.com>
> > Reviewed-by: Baoli Zhang <baoli.zhang@intel.com>
> > Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/dw_xpcs.h | 288
> > ++++++++++++++++++++++++++
> >  drivers/net/ethernet/stmicro/stmmac/hwif.h    |  17 ++
> >  include/linux/stmmac.h                        |   1 +
> >  3 files changed, 306 insertions(+)
> >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dw_xpcs.h
> >=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dw_xpcs.h
> > b/drivers/net/ethernet/stmicro/stmmac/dw_xpcs.h
> > new file mode 100644
> > index 0000000..446b714
> > --- /dev/null
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dw_xpcs.h

I would rather prefer see this as a .c file and then just export a new=20
structure for HWIF because this does not belong to the MAC. Is there any=20
specific reason why you added this as a .h file besides the reuse of=20
callbacks across cores ?

And having inline functions everywhere seems overkill also.

Thanks,
Jose Miguel Abreu
