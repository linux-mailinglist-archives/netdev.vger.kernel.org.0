Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2BFF60F3
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 20:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfKITCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 14:02:11 -0500
Received: from mout.gmx.net ([212.227.15.15]:48159 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfKITCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 14:02:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573326041;
        bh=bF9IRVU1Z+oU5tnKjEXvJJa+O7P8tQaVbU3MEL17pDA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=l1FJt/JVrFQ4Cc3d64j1zLpF2x/BffVHtslCVFAZp7+a0ZmvFDWr9WPJuNoCS1baB
         gMRqbU7o9qZZlJ1DhUKQArkhlyVR/gW48DrxeU3omPQxoxq6SBWJtO8OUFkhOK6lok
         a8mYMTLjROCWDXQI/EhZpB6xBG9xTXsgrsEjwGY4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MHXBj-1igUXY1l21-00DaRC; Sat, 09 Nov 2019 20:00:41 +0100
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
Subject: [PATCH V3 net-next 6/7] net: bcmgenet: Add RGMII_RXID and RGMII_ID support
Date:   Sat,  9 Nov 2019 20:00:08 +0100
Message-Id: <1573326009-2275-7-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
References: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:19XFGzU2npmrhE8QyHNaT8vHf0VoFCxuBlYlyWoEyLrl7mZ23nD
 1LFggpxZFlO39/Av6KGSxJ6cwbPl9dqfjsnA8Imx/J+ZjAnbiKNZHB6jOOeJy1ZyDcpFGwl
 cIZ17iEKCDsuYgG3If+xeUijiLiLh9iHeY0mqdWs61eJi8k8W1sa/CfIy7b/CSA0F1B6nIN
 HYWQ8WDYBPDn9FePEVZAg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:S8YkU2xmVYo=:UBd6+Er4cHJHAJM6IVJi3G
 F/XexFmtKjVA6wM+Rp3ZSNbZScoCrX4HbAFRMikvtMoapWQ2BSMCicUydV0K0eKcRa2/36iNV
 hximV/GxMQbaTK9SlbWFCzKXsrGsdh/lsR4RM0Pz1boX80N7VK5cmnjsz/iIL8vBAFIvyG/Ti
 if0MEuxfGHWaXDn/errOPjRWj9vQWkPGyotTTgh6fVjvkWRgR9Brp7exxm45FKgEg3ecZbJp/
 RPHCyegUDnLaHaZ7FUiqHurOplS+tuM++l9BhSp9iA1nz/zlpydEUqQ+8kLS/q18VBepxdR3X
 0aP1wcVORhsKGvoFZvyrUrOM1bf0HmmZjlHyScxODeAfC4fBAniUyzwzfEpdf1PqnuBdZOgLG
 9sflnO/i46Pc29mwjvaSdbwCF1+vd+Gq+o/GH7uM84eDUltf0YL+IJyvXAzPVTQFWf7+hEe7S
 Hl0IYKtwuPZ9SgTj63gnW415To6VJvjcdpEVTTkKrzDjeaQqmmcRPCDDyggHzrZT5N/DV6dMG
 LIeP9VpXMJKE3D1jDZV/a4zUtzRcYpFgZLR46DfismFhGtGdXSemEmbr5DGXFrH3wOQIXf+t4
 KxjlO22vG4jyFO1xIWiW/CbSxrFBL6xl9l3Bmz/qUaNhHjt5ebAUVtxoXdY1zK/g/PatRERQN
 K3fnT5YcWfh/seVjE+15ppheIqTIzAL/nDPSklwOfMSFpMseh2sLGXzppMDE21FFUtRJmj1s9
 1kfabuNO1tJasx63nHwcsq7pXCCPZCh0RDudS45VWBgk8jhJOTvQMSWx1YfwAP4+zYmrRPN+R
 7ZAaC50uwxNJhOP6ZKBqbYXVquZf+7VlRvjMy2aa9jHOwNRXsYqIvVjvIGoOPPIake62CqEjG
 5q6J6k+SvJ/ocAuE+1vkErNhseHBuz7zlxijVgK7bWClK0DkeUZRwheU/vjc+APNht0PlEH72
 n7wDI5E5okFqrDn7+8sf6iNhjypwpdrCVI3m6syAhRIKtGo67LV+ml3l2ap9ZEoN72AlfXpHQ
 sYetSlHVRmMSzP9+bpSILe1VUEVGAXZ5YaGATihulDEUwcotv3mwfFV8aW8fwXZkYqYHbBwTs
 5PkyLpbPZV9ynfYwENZ548282CqhvbN3pzrdU3L5ocjl3cmMaznTkfM52WvUccV3NZQH9GPhe
 yfqGrWB3RnuW6UK7xkWaXOJ8QA1inUJPy2S0Ju5J4aVeHDfnbVIqfWteRFJz4tpI8eiFJgtFZ
 FFHW8gAz0UWcgaw9p5m0Pd94CROW/fY4Ecp0b4g==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the missing support for the PHY modes RGMII_RXID and
RGMII_ID. Based on the used register settings in the downstream tree
the mode RGMII_RXID is necessary for the Raspberry Pi 4.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/et=
hernet/broadcom/genet/bcmmii.c
index 8f7b2c0..9091e5b 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -273,6 +273,16 @@ int bcmgenet_mii_config(struct net_device *dev, bool =
init)
 		phy_name =3D "external RGMII (TX delay)";
 		port_ctrl =3D PORT_MODE_EXT_GPHY;
 		break;
+
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		phy_name =3D "external RGMII (RX delay)";
+		port_ctrl =3D PORT_MODE_EXT_GPHY;
+		break;
+
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		phy_name =3D "external RGMII (RX/TX delay)";
+		port_ctrl =3D PORT_MODE_EXT_GPHY;
+		break;
 	default:
 		dev_err(kdev, "unknown phy mode: %d\n", priv->phy_interface);
 		return -EINVAL;
=2D-
2.7.4

