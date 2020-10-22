Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9AF29560F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 03:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894752AbgJVBZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 21:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894704AbgJVBZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 21:25:25 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F1AC0613D4
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 18:25:24 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 88301806B5;
        Thu, 22 Oct 2020 14:25:18 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603329918;
        bh=7+o/Mhzem1dqhNkq7ef4LoO81PgES70KV6LfFH996z0=;
        h=From:To:Cc:Subject:Date;
        b=LuVK2dQ3So9SFdGGVen4/7Kb6C2oO5V+N1/uNEVsbKwAdaXVZY/GMdb/jAX2mgCEJ
         2YmgipG8BreBY67vS7SPEFcvWD1WzVGZnsDXT1GPYnexOLctGroHuNJz+ugtmYLhcy
         F1TSqHRBWHWNBjX39n41tDtyQ4xDjbDbYjRAZMND1SOylPWc0gTjLuoLj8LzHR/Vqe
         8cUtyQ60CMoK3cxm20oYN+9U5WgDSiK5yPgmJgFV2j6Qnws248LdFiO7o3S1FfQxxF
         TSHgKPxO4wsAQklsffqVAsck21m3JPVXmvvY8eIz6871d7EKflcwcWsEH0soGBj3UY
         6Ag40/zjoyYHQ==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f90df7f0000>; Thu, 22 Oct 2020 14:25:19 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 25C3C13EEBB;
        Thu, 22 Oct 2020 14:25:17 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 5460A283AAA; Thu, 22 Oct 2020 14:25:18 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 0/4] net: dsa: mv88e6xxx: serdes link without phy
Date:   Thu, 22 Oct 2020 14:25:11 +1300
Message-Id: <20201022012516.18720-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series gets my hardware into a working state. The key points a=
re to
make sure we don't force the link and that we ask the MAC for the link st=
atus.
I also have updated my dts to say `phy-mode =3D "1000base-x";` and `manag=
ed =3D
"in-band-status";`

I've included patch #4 in this series but I don't have anything to test i=
t on.
It's just a guess based on the datasheets. I'd suggest applying patch 1, =
2 & 3
and leaving 4 for the mailing list archives.

Chris Packham (4):
  net: dsa: mv88e6xxx: Don't force link when using in-band-status
  net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185
  net: dsa: mv88e6xxx: Handle error in serdes_get_regs
  net: dsa: mv88e6xxx: Support serdes ports on MV88E6123/6131

 drivers/net/dsa/mv88e6xxx/chip.c   |  50 +++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h   |   4 +
 drivers/net/dsa/mv88e6xxx/port.c   |  36 +++++++++
 drivers/net/dsa/mv88e6xxx/port.h   |   3 +
 drivers/net/dsa/mv88e6xxx/serdes.c | 122 +++++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h |   9 +++
 6 files changed, 217 insertions(+), 7 deletions(-)

--=20
2.28.0

