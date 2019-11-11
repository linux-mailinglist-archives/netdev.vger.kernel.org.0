Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCA4F8089
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfKKTvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:51:36 -0500
Received: from mout.gmx.net ([212.227.15.15]:48697 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbfKKTvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 14:51:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573501793;
        bh=2nqc6rODnsja5qmJqja77SOFP0+FHJgseIDW5uO6jdg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=AVblzHIfGzgF26rvCYE17NbdW2olTXt01mTERyPtXCpSF2tZMVEQd9cfb6Wvvy63n
         m3TZIJUyTupfc2obcP37bCm8WHxeu83DnLX3/Us/ryR6C1xGek1iqabJAXhn8/B05Z
         pB1CLff+Phf7vBpYOkmnfoipqm7F8DXE+AtWrQps=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MsYv3-1hbRzG0TUJ-00txqX; Mon, 11 Nov 2019 20:49:53 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V5 net-next 6/7] net: bcmgenet: Add RGMII_RXID support
Date:   Mon, 11 Nov 2019 20:49:25 +0100
Message-Id: <1573501766-21154-7-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
References: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:ZOJfpg6u3NfseTrJXBluY7EW2RZP4PqNGXGc9v9JvJyVbCBP+yg
 8nsEbKeJB74U3TnkStTI4ItXCmosERWXr39/a/Nezuq1bmiTiRX2pLO6S+DjC3+iWaeNRTn
 wYw5E40IG3FBwEqwpaTyWI1MXXzVY0BpaPPFz6bdWj70n/ecR/4LluJ/1FkzlWF4ycxH/T5
 WZAsbauvHgTfi78LiyrGw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Z2sjTrTeI0U=:OUB7VCuUxbWWJwulchHDg0
 XoqjilVPHJfyZ6PgueQaQ4q3H1peQgot7oXyN9Rxt0Z2Z/jiMcL8+68DLG5rDvBT7NbpP3eqH
 XDFXC75Ugs2YzaeFN3FowmBGuRLk+aqbAZM9jD2G/WezQPO4e7aIbZn2wjm2MM7rC16hHT6VA
 7/fyQTFd/b+9t49qcPCQoE9XPoggcdX6JmQ0QSzRPXm5fmzz2ymc/6t/8oqd7l3T9yDvC8ui6
 ya67seQTkZZMv3fiu5m1Lf71p/ZZc6pROPBYypzjGQLj/UaqOaftMk7YgyZN6vLkWeRrDnDIW
 reDBfbpVhW7LLjdTV+Qw3U3Cn+xOJeEOR4D0ZRIXuZSbh8LRLs9keXP5R1msVByo1mvNU7GMn
 tXH/Kzebc+fDpWDC124+/yCx7MvGRqbvdtUTyNCr+kZ+5uhfecMhN8z2NPFQuhFnYvzLtUHgZ
 ntUsE3ZZuIdfLgQyRsrLF1pOOwQ2qffJ/zLdCImgFGybpofZ4oBhEFpZB+QXMcoOGdmOTTS2W
 lCzqfVnTdwZLr6zEm646UfULczKmZ0SKvYxvy/51UN52KIsasn8KIuDZ+Gm4N5KCH9chzEF90
 xOTkR5OEI9SfudDTEGQO+O84ns7OsAVf2QynejE0kCoRwdEBAjCVcd703WK7dFyb6HijeaH5y
 8U2jy4rRYgV0k6Rp2qjgefQcxGxyanUjl0i2KM6iCkto+KvS6lNTXjghdNDxlpzQKDs+AOUSw
 bOZjG2oXnwpWpWAjQptwdR8DQbuzVj+6vxI0necVd2Wqf9SDxkkG57iLBEnp2cx7o4ZfLPwsA
 M1ov64mA+UgjXG8kQXS7V0ioX2/HMR96cbAWdnU3/5EvbGxs+fWvX55IoQzH1+QcRDBNdN4wM
 /+h8ysR0fbmqTZYLC0cJCM6d9zZYMZhA6uMrhT+Tlal45xCm5O+OBLYHV/uYGBWhSlTVZXVDW
 +nPxoK0VkEfjQJUPJJgP0gK82vkCQyQQfqaH9Ui3nn5bUG+Mf/MFERIhQ/44rz7Me7pw7h1eX
 3WkI/IGzPmmr182kyPJ0yiDehlsIGz3fzTB3SNE/9Gdy0VK7izFIQggGEVKRClHGex+1Zlekz
 1Kzh/DVHb0yZlNyDgRXEFpyY3SYznsmQhzZ6tMY/eWdOeOgNiDAcFBt+tbzrY22xTR3uYekHv
 W1wNLtEYn9C1c+Wz2zBGdCAVw0q12GekHRHUIay9IoqbqnUg4nohQznXm5cgro6kmgc0eQEFl
 4sPVhdqxNcqGjj4+p8j/H+tYgGZel/k4uEl0Etw==
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
index 021ce9e..6392a25 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -270,6 +270,11 @@ int bcmgenet_mii_config(struct net_device *dev, bool =
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

