Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D8C68B303
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 01:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBFALm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 19:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBFALl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 19:11:41 -0500
X-Greylist: delayed 505 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 05 Feb 2023 16:11:37 PST
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8538917157
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 16:11:37 -0800 (PST)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 43A1D7F471;
        Mon,  6 Feb 2023 01:03:06 +0100 (CET)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DB9834064;
        Mon,  6 Feb 2023 01:03:06 +0100 (CET)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13A033405A;
        Mon,  6 Feb 2023 01:03:06 +0100 (CET)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Mon,  6 Feb 2023 01:03:06 +0100 (CET)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id D86D57F471;
        Mon,  6 Feb 2023 01:03:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1675641785; bh=TnmcbWXV1HoqXtK+EYm+bLT5n0PQAmUZ0eT6DiEPEIY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=uDLsUyoaCUbnlEsiBdhB5gW2FRHuWNbP+Hg/BW7Mw9pH9a/fVoaAGvrcxZNlwsiHL
         2NZoBTcFTkfIcaLwShfAdr43+ZuSNki+cjUEGRyVd8ZIllolEYya7nzOtONsYg5dJe
         dwaMSaAVlCl4WOrwPdAq/IFlvf8oCk0peQf0W9BCfHBI/JSI2UGb4+PJtuEJ7wocTw
         H9LbR9lYlV/IEuBep4NYMTI5+tpnCMT5oIAFs1r+LIH2pxe1R2U40GPnE6I3VtqrHq
         HwSFoL230Lvq1TLLU9RqaEiUoVUm6+WUQSyOZrg6bo28xsJyVm4ij1XSUBMcg3pPc1
         WYlRbnmd6SmUA==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.17; Mon, 6 Feb 2023 01:03:04 +0100
Received: from atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7]) by
 atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7%11]) with mapi id
 15.01.2507.017; Mon, 6 Feb 2023 01:03:04 +0100
From:   =?iso-8859-2?Q?Cs=F3k=E1s_Bence?= <Csokas.Bence@prolan.hu>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: [PATCH repost] net: fec: Refactor: rename `adapter` to `fep`
Thread-Topic: [PATCH repost] net: fec: Refactor: rename `adapter` to `fep`
Thread-Index: AQHZOb5iOec6xI5D/kK4UPuMeHPSxA==
Date:   Mon, 6 Feb 2023 00:03:04 +0000
Message-ID: <b0d5ef8d98324e3898a261c3c06ac039@prolan.hu>
References: <20221222094951.11234-1-csokas.bence@prolan.hu>
In-Reply-To: <20221222094951.11234-1-csokas.bence@prolan.hu>
Accept-Language: hu-HU, en-US
Content-Language: hu-HU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [152.66.181.220]
x-esetresult: clean, is OK
x-esetid: 37303A29971EF454617766
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 01b825f reverted a style fix, which renamed
`struct fec_enet_private *adapter` to `fep` to match
the rest of the driver. This commit factors out
that style fix.

Signed-off-by: Cs=F3k=E1s Bence <csokas.bence@prolan.hu>
---
=A0drivers/net/ethernet/freescale/fec_ptp.c | 16 ++++++++--------
=A01 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/etherne=
t/freescale/fec_ptp.c
index ab86bb8562ef..afc658d2c271 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -443,21 +443,21 @@ static int fec_ptp_adjtime(struct ptp_clock_info *ptp=
, s64 delta)
=A0 */
=A0static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64=
 *ts)
=A0{
-=A0=A0=A0=A0=A0=A0 struct fec_enet_private *adapter =3D
+=A0=A0=A0=A0=A0=A0 struct fec_enet_private *fep =3D
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 container_of(ptp, struct fec_enet_priv=
ate, ptp_caps);
=A0=A0=A0=A0=A0=A0=A0=A0 u64 ns;
=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long flags;
=A0
-=A0=A0=A0=A0=A0=A0 mutex_lock(&adapter->ptp_clk_mutex);
+=A0=A0=A0=A0=A0=A0 mutex_lock(&fep->ptp_clk_mutex);
=A0=A0=A0=A0=A0=A0=A0=A0 /* Check the ptp clock */
-=A0=A0=A0=A0=A0=A0 if (!adapter->ptp_clk_on) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mutex_unlock(&adapter->ptp_clk_=
mutex);
+=A0=A0=A0=A0=A0=A0 if (!fep->ptp_clk_on) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mutex_unlock(&fep->ptp_clk_mute=
x);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0 spin_lock_irqsave(&adapter->tmreg_lock, flags);
-=A0=A0=A0=A0=A0=A0 ns =3D timecounter_read(&adapter->tc);
-=A0=A0=A0=A0=A0=A0 spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
-=A0=A0=A0=A0=A0=A0 mutex_unlock(&adapter->ptp_clk_mutex);
+=A0=A0=A0=A0=A0=A0 spin_lock_irqsave(&fep->tmreg_lock, flags);
+=A0=A0=A0=A0=A0=A0 ns =3D timecounter_read(&fep->tc);
+=A0=A0=A0=A0=A0=A0 spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+=A0=A0=A0=A0=A0=A0 mutex_unlock(&fep->ptp_clk_mutex);
=A0
=A0=A0=A0=A0=A0=A0=A0=A0 *ts =3D ns_to_timespec64(ns);
=A0
--=20
2.25.1

    =
