Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB6030327B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 04:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbhAYKKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 05:10:51 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO mail2.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbhAYKIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 05:08:42 -0500
Received: from mail2.eaton.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F0EA11A161;
        Mon, 25 Jan 2021 05:07:58 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1611569278;
        bh=Z2wFWjvyVFLX1zQ/KTOAUaZk/b8OGSaj/l8y7I3sazE=; h=From:To:Date;
        b=YKLkG2gnNeXt6BOAho6+AjtvP/Q+vnPr56HVxc+3rL8/9Bb8zmskXJ4Vl2FeW64Or
         qZL8uxF5t3fwOIDeLmQhGIlHfSxW8tewugZufrxu1zX9qBnAqE7YwWLn3WgjZXsvLw
         xd5P2HxH51wNGT0SekUMWRItLNNDDj2LESw53/QFnoLIcjBvGQoWjtjly14lCbGuoy
         4MK++REYnIzal0b4vBob8yzcoJbTfh9P77y64mxsQzBRgoLFKKiQLIOHToL5/hIFFA
         eW9bNYUHLYbhgzBmN5xud3LdWToYcnXiWaxgw6+KyroYDgcJj/r3bcfEKDVZ84F5FO
         d4Nb8Xrgo8QfA==
Received: from mail2.eaton.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 502D211A15E;
        Mon, 25 Jan 2021 05:07:58 -0500 (EST)
Received: from SIMTCSGWY02.napa.ad.etn.com (simtcsgwy02.napa.ad.etn.com [151.110.126.185])
        by mail2.eaton.com (Postfix) with ESMTPS;
        Mon, 25 Jan 2021 05:07:58 -0500 (EST)
Received: from localhost (151.110.234.147) by SIMTCSGWY02.napa.ad.etn.com
 (151.110.126.205) with Microsoft SMTP Server id 14.3.487.0; Mon, 25 Jan 2021
 05:07:57 -0500
From:   Laurent Badel <laurentbadel@eaton.com>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Laurent Badel <laurentbadel@eaton.com>
Subject: [PATCH v2 net 0/1] net: fec: Fix temporary RMII clock reset on link up
Date:   Mon, 25 Jan 2021 11:07:44 +0100
Message-ID: <20210125100745.5090-1-laurentbadel@eaton.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-SNTS-SMTP: EB5C4706828976AEE11C7A33DA0F1B4138D89FAFE9FACB1D8AA6015C5FFFF7C32002:8
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25932.007
X-TM-AS-Result: No--5.106-7.0-31-10
X-imss-scan-details: No--5.106-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25932.007
X-TMASE-Result: 10--5.105600-10.000000
X-TMASE-MatchedRID: X2MEFJ8pJ9CYizZS4XBb3095wQijrwBLYjDXdM/x2VNjLp8Cm8vwFxMn
        vir+JcmKEbX2Fpa2gakpmz6bXBXAqTA72TzG70w+8UIP9c6qlJs8/9bDwLOgRwMADm5EdqKW4qA
        BsUMuHjVSeHWiaGFVpDlNI4VHjyjPO5sXKty63LM9oFMnLLzjBeeZaG5J6Gn335PZsZcOLRnK1N
        5uMH+VULwujwzWn5JPfyZ+Fi4VKmqw2LseEG011XnNctcK7zfFas1wAJHsfyIKdpfa9KyX/28Ay
        zAJO0+x7ic15DHF6W5nVQEDLA8A+g2Qc8bioJ2ZCuDAUX+yO6bdKRNjzo2IOJ+PdzYxWzfA5GAQ
        y8LG5mekoxDx4v0uc28XRXofbaF7vBVg4IU4e9mcVWc2a+/ju6lmjFq8ZmGOO312fKgjq4ltapT
        6O1Qb0yq2rl3dzGQ1RwiffAK8j1iUS1UKAEHrzLpYj9xqv3NK3nE526kZ4/urpp8iVB0roQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFv2: fixed a compilation warning=20

The FEC drivers performs a "hardware reset" of the MAC module when the
link is reported to be up. This causes a short glitch in the RMII clock=20
due to the hardware reset clearing the receive control register which=20
controls the MII mode. It seems that some link partners do not tolerate=20
this glitch, and invalidate the link, which leads to a never-ending loop
of negotiation-link up-link down events.=20

This was observed with the iMX28 Soc and LAN8720/LAN8742 PHYs, with two=20
Intel adapters I218-LM and X722-DA2 as link partners, though a number of
other link partners do not seem to mind the clock glitch. Changing the=20
hardware reset to a software reset (clearing bit 1 of the ECR register)=20
cured the issue.

Attempts to optimize fec_restart() in order to minimize the duration of=20
the glitch were unsuccessful. Furthermore manually producing the glitch by
setting MII mode and then back to RMII in two consecutive instructions,=20
resulting in a clock glitch <10us in duration, was enough to cause the=20
partner to invalidate the link. This strongly suggests that the root cause
of the link being dropped is indeed the change in clock frequency.

In an effort to minimize changes to driver, the patch proposes to use=20
soft reset only for tested SoCs (iMX28) and only if the link is up. This=20
preserves hardware reset in other situations, which might be required for
proper setup of the MAC.


Laurent Badel (1):
  net: fec: Fix temporary RMII clock reset on link up

 drivers/net/ethernet/freescale/fec.h      | 5 +++++
 drivers/net/ethernet/freescale/fec_main.c | 6 ++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

