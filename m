Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A53ECEDD
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 14:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfKBNmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 09:42:25 -0400
Received: from mout.gmx.net ([212.227.17.21]:33617 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfKBNmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 09:42:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572702115;
        bh=B+2ielFzQfrNXcrr2rG7ypa++YSnuxddRmAyBorL8W4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=NSR4jjTcIbME/Mma0/vrjDQ+Eq3suj0eYWC2h6wu4yIE0LvpkpivqvCIDGhoP3C6k
         /U+tHPPbqW0FXoALDJRW/kuAGojfAj2N27bdshkDhjuIha9odbN3fhAhAdsMGqRoOF
         DilHEi9bqqLCG/vkKJdZkGSlxXDFRsqLOrZMA7/E=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1Mzyyk-1i4I2n2Zp0-00x7Pu; Sat, 02 Nov 2019 14:41:55 +0100
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
Subject: [PATCH RFC V2 5/6] net: bcmgenet: Add RGMII_RXID and RGMII_ID support
Date:   Sat,  2 Nov 2019 14:41:32 +0100
Message-Id: <1572702093-18261-6-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
References: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:YlD3liMtwTM1X67+rhs9J6Xk/Cwvcrk77ukSyY9OTn1dfuB9FOI
 jGgd8VLi90xpNxuWu39vsNO/fDPMETXQaHn/LQ0rxh4yN3JzG/tghvPlRTtjrljUZz4jli+
 dgqVIhFlwAGcgjmEE5WI3jcMtJucbB4+A8RncLYtMLOR4thjYNj+pGpFuzg1/hTuTENjelm
 gyyGdF+qvraFwknJbwQ+g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DRhM9sgeMiE=:LAjnbh1+DHmkNZE9H6ptZL
 PXjAVZevOKt0vCnIVyFIposySYFwMZSTZhGyXfF7iojc+aWi9tNJokwTvSkQmzMegNME6K1hD
 1o60RlcmJvisrRDaoCAnSchJb8zi/Kp05OMqc8PcIjNQ4MC580fXXkVNFM9je5zIPOQaslK3O
 jHNzv4GTNGiT5b+lnr9qqc1/bh9cwqMp5EY1a3KZLszzOOr0olCVIHkZ2K2oeUz+WVG/n2kzN
 TTkgKLbPbuYGBU+wurZ0fx+SDBlX9N+PYoq385dx0W1rkbkvnGhIXXKMReaeeMKQs9M3A25jR
 brg4MITtDKRNggRJ5I0ib21CkXZLfBZ+ub+r0GSwpfeDokb694wOcEu2BdPgLrVlK9vyw0S6G
 up5wzQnTfXzfiP1C34V1bSz4L8QEMcKj1GEuhEcCVJRdc6EPU1nPX2Fxd79tJlLBGNJ5Ffcqp
 oNobvJq9oTMbB/Ehhnwp5HK4ZpKnoEQOVxddOMOSVu1wEQQdPoYxoWo3irM3p4mrOQV7HGoz5
 roUoYE85QHUPBSQ6h4kYDmh2PVN+tNFTvygJ2mfmchG8kRfsQpmjMsMGiEjRb+M9QWxxvOuCg
 hOoLXnSLptzkxUJ8Bq3CWNnpEWY29pNmOLTVpHEleprbXNVsYlRkk6liHKVmhug9RZObx10Zi
 7d0CwQA3cknJWp0aB5pjN+TgzkxwwsfYrJIFaaJeEd4DUhp2yF+nn362//DCZbXKtcQwLPzcD
 Yxnj+UDbgzdW90+uQpGwcbZf1N1EAmXaeDpfN/2y7UsBTQCeiIaaM1Oej39fIXLl/3MxCt85A
 tnLy5511X2afbb2F8WYw2Erf0XyY2s7ChLERpvJ1SVRC9bFQ4Mlxydzg5WO3Ru3XymcY1MPLY
 ZgyaDEqfw4OwCbCbDTVbSKIGnYoSOayVTMuCQx/WhX3lZLobzJNBeZNTu5JznzkmSIBB2naJ7
 wE/NEM+kGdTJvXQfxqhg/+8ayhrlyo1zaB9vD2ldMF1WIDe2MmUGl/p1A4PAU0g5APxNxbap3
 Qlr2Rb9tXOI2jJapxc4+94pTOfybvPr6fjPli9ZWF7eT449Vsva6mH1mFBuGGqfe05DuuaJyM
 WrNlP17t+2X9DpqVZsxDSpcJti8ci3VCJfeSfcvlKh3tGkd4vWV1odp2duCgqcwrw8pYjiN8w
 EQzNWFLgdfccn2WyJTyM3TjQB4ORh+yE8AR1uDEMHUY77M+RgLgC6pFwNJvOXX/5x8nYVgalo
 DsZuteUHJQ9HPt/SvlteKk58Z4DLnfl0KKuAPBQ==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the missing support for the PHY modes RGMII_RXID and
RGMII_ID. This is necessary for the Raspberry Pi 4.

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

