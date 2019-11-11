Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED9E7F6ECE
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfKKG5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:57:44 -0500
Received: from mout.gmx.net ([212.227.15.15]:46511 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfKKG5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 01:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573455363;
        bh=Imoq/wSFMrBBPLNQDLfO722VD00600hqsxm/eoRaikM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=IzoFprfv+223+F9CAdkCL1fPQsVURQw7l2gyTLN+ngxtXQ8miGkleq50GY+bk5by2
         gCnicIWRvhPRZEw5oKHHrjUolOC1Vzza7JH4+Dm59DGyG4+A8mKqh1lqaPWcTbqgs6
         rV0lmUsW6YFcyUHp8t4w+DcD4MOHZX3/oz3vqjQ8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MGhyS-1ihr8b1gIs-00DrZJ; Mon, 11 Nov 2019 07:56:03 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V4 net-next 6/7] net: bcmgenet: Add RGMII_RXID support
Date:   Mon, 11 Nov 2019 07:55:40 +0100
Message-Id: <1573455341-22813-7-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
References: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:kNPp966w54VeZ2+FMAstTTYYTOCLGCHBqjQrWRi18NF975uBc6A
 iT30WGE0l5WPP7ZeZfmscjl6IaRAiN8OuWTOSZdSjxxrOi+brBjzDGbd5dsQxkYdHTNVwW3
 9cQ0YOzWZfS4tAhnlkZbbzHIXlNoyUvA9QH4vwChdhf7+WG35qjuUHww/uwGboFujLD+jBu
 keYltdNqvv5UdOHk7NtJg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Xl7Wvqae/X0=:oPA1wqbZGgNTv/lV8qVoTR
 iPLHcqbC2K4zYqmYyVAQ6PpEcg989LoUGpcXjZqB/u/pnfwObTj5y5sVPRdcyDL6LdF1baVsS
 UhD8HiqZTr8O33Vi5VGLtiv1FGcm6CpFWVl7a9zTGgUIaCueo2oQmliilt25UKBqmIDGV7tCP
 Nzzm/Rmd64qAkXlXORqcJpkEQlMJ6RthsD58YRO4ErbKmlDlWqukN62NSzNr4SzTS4JyZzSG3
 peK5fq5lYhpAxb3OXcUDBFCpqbjN89wjZiV98FJ7gFiDxR5UzuG3je+M6ksXSxt4S4j7JBcN3
 nC2Vr+na++CXYbzOTd8EAqytZWKiB37GkKrHHRYRLFmeNj/lo6hvlcIbe78FK4P33EhDTVCxg
 qMHLVsuvCs6DWOBJsigfT8pruJWwxMA8GB6rjdYCnxiWij6TDMJq46j2cskp6T9NDK+lpdb5F
 vLItd4Sx4/kmyV7ARpPo4OszFk+Jb44SCKfYaHaxKgiN4sJcsDF69ASL7/iWvft281Ehi5BY/
 /GcwPkpTJ91othwE0RQkBF67W/r6ywG1MLRQ1Yvw6VZ1de9w3KDOq3kNiRXqNz8fCiyE5A2WX
 EwyuV6mgB/3oJR/bqa+BT3UKtXaZSHOFI63y/Um1TKh2XycaOg7m77yQoc1zsaVyA5q+PHP2e
 paJ0Zh70vMWVrDOo9chGjEC8jl/VhhxYVPT9XROLPLrCelJUOGeOayciJuTC+B8untyh2pBqr
 9ZApm8V7blrpXXhO4YuGrhFxM3O4870J5wLrXy5sa0vm9MmWfq3Sf1nQdOwEJwu2iQ4qCnbfB
 Apl8QRXpUnV5xrd3icdIxQ57VC17iFgkQxWinR7mar5AZNKQznYm3oirfWxVA4jkRGhDKaELV
 jZ32pP6C2ULOCBY1xspW7cbMZETTfk9KQlNuPHre1haJ/7KnZgU8P8urwFZyQQpo8PZyH3Sh8
 AuHEPvlbBpUY0ru0GDDOv1zNyvjQe1g9u1Cq1BeHfq1b20k3bvrSZNH9SK2lK1RzTS/TvP07G
 sutX2TyCUOPCozFMtxznytqm4AF/y+XZsRfqDYeRB/qhnacnayics9VDaaW7ma+D8jsfGqp5D
 xcVRlwvSqJ33PhJlvHuaC2sJyu0+eO8ipGXRikm/SxkjELiY4FExOeDnQ6qWfIgXoG2Wf0Udf
 wU0SidL0CGKNu4nW0dDAKPHPokrC11snTDDZYYAt0rZSqneJLfSj24gMWYzFNseFzvKxnpPsh
 sSmhUuzQwm1vr6xYNaaoJ3gvo1nWNx/6YvS6kww==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the missing support for the PHY mode RGMII_RXID.
It's necessary for the Raspberry Pi 4.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/et=
hernet/broadcom/genet/bcmmii.c
index 611a6c0..80d2f87 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -273,6 +273,11 @@ int bcmgenet_mii_config(struct net_device *dev, bool =
init)
 		phy_name =3D "external RGMII (TX delay)";
 		port_ctrl =3D PORT_MODE_EXT_GPHY;
 		break;
+
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		phy_name =3D "external RGMII (RX delay)";
+		port_ctrl =3D PORT_MODE_EXT_GPHY;
+		break;
 	default:
 		dev_err(kdev, "unknown phy mode: %d\n", priv->phy_interface);
 		return -EINVAL;
=2D-
2.7.4

