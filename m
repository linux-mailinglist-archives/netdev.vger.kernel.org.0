Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9FE292130
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 04:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbgJSCoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 22:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730925AbgJSCoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 22:44:02 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477EFC0613D1
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 19:44:02 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 43B4D83645;
        Mon, 19 Oct 2020 15:43:58 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603075438;
        bh=/qu5CgQc0psIBufAFeBcJ0q/ccgJ7xHHJbfe84ckgy4=;
        h=From:To:Cc:Subject:Date;
        b=gNr+XVjX7v4QkxoqXmnlZ9eEWrgnyJHMJ/rgaglzN1XIgZwm/tOS4Oe6U+pMLj66f
         aH8ktqnkJjUjJ6/ouCZL//GC6d+bd45n58IahJIbgpVI7zk30wL0FTYUgUJTxwqugz
         hn1Mfvq1crzAJGLmKwQNW2ZbuqSwSEK+wScB2wnpekQ44MaFBcpKKtb3yZx3cDgNSz
         MmTvXe0ybOMaNKllGDRy2svzb1Fn/kbYCFbQzhANKYUguTNomMSauQeXfyJ9DUA1tx
         uNOoAzGQRlCjJRgLxyEU6YM20WD6xazE5Cwm0zlKp8AAJqCnu3wTOMfpjD9Y6loFq8
         XRrLfc/rDbjDg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8cfd6e0000>; Mon, 19 Oct 2020 15:43:58 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id D385013EEB7;
        Mon, 19 Oct 2020 15:43:56 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 0995928006D; Mon, 19 Oct 2020 15:43:58 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2 0/3] net: dsa: mv88e6xxx: serdes link without phy
Date:   Mon, 19 Oct 2020 15:43:52 +1300
Message-Id: <20201019024355.30717-1-chris.packham@alliedtelesis.co.nz>
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

I've included patch #3 in this series but I don't have anything to test i=
t on.
It's just a guess based on the datasheets.

Chris Packham (3):
  net: dsa: mv88e6xxx: Don't force link when using in-band-status
  net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185
  net: dsa: mv88e6xxx: Support serdes ports on MV88E6123/6131

 drivers/net/dsa/mv88e6xxx/chip.c   |  26 +++++++-
 drivers/net/dsa/mv88e6xxx/serdes.c | 102 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |   9 +++
 3 files changed, 135 insertions(+), 2 deletions(-)

--=20
2.28.0

