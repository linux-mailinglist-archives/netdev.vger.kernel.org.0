Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9593006E4
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbhAVPPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:15:20 -0500
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728628AbhAVPOs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:14:48 -0500
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 962EBA40E5;
        Fri, 22 Jan 2021 10:14:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1611328444;
        bh=+4rHUBoSRtDn4MF5TASwgYT+ycLwSP9i0piE03cI3rY=; h=From:To:Date;
        b=M5qXf+x4mQzu3tNmvmAqHei4nUK3hBelEec5DYE5Yml2XnoDwKtp+p2jWmlF4t7TL
         bcjC9gSLGw9j+Od22mLRMldOXNnz3qrwmPS9ejv28h7qNTSImdU6q3yzcnzq8ucUyh
         3ZanQnJjTgHlcwQ8sFjga134e+EYHAvrnEsQzi/hhUckxTF/bpIdd9EA1MuoZcJUz7
         WxNkeuYYt+EhkSfGkhABiZWDwjE/Ye2uTdR7xACscNQqHYwk1r3hZhKN5kL+NboaOR
         WcR4t+5gN3tJsEZlc0LUKj4W5pL/piszJtr+g9ZPRH08ED61fU9u/b6ZsP1o8erG4P
         2tvOVhR28V7iw==
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91E1BA4102;
        Fri, 22 Jan 2021 10:14:04 -0500 (EST)
Received: from SIMTCSGWY01.napa.ad.etn.com (simtcsgwy01.napa.ad.etn.com [151.110.126.183])
        by mail.eaton.com (Postfix) with ESMTPS;
        Fri, 22 Jan 2021 10:14:04 -0500 (EST)
Received: from localhost (151.110.234.147) by SIMTCSGWY01.napa.ad.etn.com
 (151.110.126.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 22 Jan 2021
 10:14:02 -0500
From:   Laurent Badel <laurentbadel@eaton.com>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Laurent Badel <laurentbadel@eaton.com>
Subject: [PATCH net 0/1] net: fec: Fix RMII clock glitch in FEC
Date:   Fri, 22 Jan 2021 16:13:46 +0100
Message-ID: <20210122151347.30417-1-laurentbadel@eaton.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-SNTS-SMTP: DF6C7510670431F65E6ED91971896965C2933F71B2658A5D759A678594C713E42002:8
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25928.000
X-TM-AS-Result: No--5.128-7.0-31-10
X-imss-scan-details: No--5.128-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25928.000
X-TMASE-Result: 10--5.127900-10.000000
X-TMASE-MatchedRID: HGWfp+aRkrOYizZS4XBb36iUivh0j2PvsKi4EXb8AIqHX0cDZiY+DQ0/
        cjFmbp1nPSNdZAnIj4HEqBZmhnP8ZI/v49ZDRKoilchF+IvkllPLvfc3C6SWwoDpStszePepxDm
        9zIKPPUiaCEBJhT7xKqVdYNqz8fi10cvBfcPxgBM1yhbbA7We0xC26qzoFs8nCDaSBZ23epobrW
        5lEClUbOUk5kWEWqd8zIB3kpZt0CFlU6Q5GgCLzg3BRWEgXqlWy0Q+dW8+UWQda1Vk3RqxOE+mM
        tGpzwaW9AKEVfAskfcKz+IDVz2UnmR5WlY/ZLL5ZwUuZO12AYVXjjsM2/DfxkSspnFzF1mR5GAQ
        y8LG5meGJ5JKftck3XO3FRBLy6un7dQtlyG1f4UdDctFr7spHH0tCKdnhB58puP9zg477pEqtq5
        d3cxkNasm3JXyNGl2RbwkKMj3WDlOt+UJUvqp/3imO7xdv2moxejEEeX92Opqve85SBsZVlO6A1
        7NQQMTbquKVNfbyxl/90L/k9AK6FdfVo389IZYU/JCITmuhS7oZbNFHtbIdPl43iPWIJMPxwTT7
        97Vag8=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFThe FEC drivers performs a "hardware reset" of the MAC module when=
 the
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
proper setup of the MAC. =20

Laurent Badel (1):
  Fix temporary RMII clock reset on link up

 drivers/net/ethernet/freescale/fec.h      | 5 +++++
 drivers/net/ethernet/freescale/fec_main.c | 6 ++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

