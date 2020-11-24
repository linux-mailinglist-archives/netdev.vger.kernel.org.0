Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C712C1CBD
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 05:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgKXEeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 23:34:50 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:58946 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgKXEeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 23:34:50 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B23D3806A8;
        Tue, 24 Nov 2020 17:34:46 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1606192486;
        bh=No+LIf58LomnAE7gWTmb7xCffnpADEemc91zfcgX0bo=;
        h=From:To:Cc:Subject:Date;
        b=TEZkSfAOKeSFeZ0c3fzEtDCNvx5L3+v3nyint/Hmr30Zm0Ho+v2EXoD0kt4eMPZQp
         7VyRrod6aHylkoREHcbD90xgLDQl5Mu4mA0Sn1kKt093udKp16j9CV3IXfsYz5Fx3+
         NVzq/cmiIr247oNLgsjhE13zPXBfSgx4f5DXUhsek2tY8UzJcB9WwF08I40hTF3+Io
         Lv01zhs+exJqB0/SAP2LaVUQJ0oj4Npz9pfpSCiTmG93ZCWtxAgAKzsadnF+6syKdC
         CjdFnStFirXRYdEDZDoMiv/IfCA13n1wp+ZoDEGbxP90re8rnC+auTsp76clobiKhp
         ED/ADEeC8TJJA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5fbc8d640000>; Tue, 24 Nov 2020 17:34:46 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 33C2213EE9C;
        Tue, 24 Nov 2020 17:34:44 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id F37702800AA; Tue, 24 Nov 2020 17:34:44 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, pavana.sharma@digi.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [net-next PATCH v5 0/4] net: dsa: mv88e6xxx: serdes link without phy
Date:   Tue, 24 Nov 2020 17:34:36 +1300
Message-Id: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.29.2
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

I've dropped the patch for the 88E6123 as it's a distraction and I lack
hardware to do any proper testing with it. Earlier versions are on the ma=
iling
list if anyone wants to pick it up in the future.

I notice there's a series for mv88e6393x circulating on the netdev mailin=
g
list. As patch #1 is adding a new device specific op either this series w=
ill
need updating to cover the mv88e6393x or the mv88e6393x series will need
updating for the new op depenting on which lands first.

Chris Packham (4):
  net: dsa: mv88e6xxx: Don't force link when using in-band-status
  net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185
  net: dsa: mv88e6xxx: Add serdes interrupt support for MV88E6097
  net: dsa: mv88e6xxx: Handle error in serdes_get_regs

 drivers/net/dsa/mv88e6xxx/chip.c   |  47 ++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h   |   4 +
 drivers/net/dsa/mv88e6xxx/port.c   |  36 +++++++++
 drivers/net/dsa/mv88e6xxx/port.h   |   3 +
 drivers/net/dsa/mv88e6xxx/serdes.c | 123 +++++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h |   9 +++
 6 files changed, 213 insertions(+), 9 deletions(-)

--=20
2.29.2

