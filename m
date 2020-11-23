Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C051A2C0201
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgKWJFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:05:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgKWJFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 04:05:37 -0500
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AABF220732;
        Mon, 23 Nov 2020 09:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606122336;
        bh=Tw47tcefeDRTI+nES7RbUIqiif2TrDeqaOl4YNkUcmA=;
        h=In-Reply-To:References:Cc:Subject:To:From:Date:From;
        b=rxrEkXcjVsRzpOKxl6qCmCKJD0XariDd7MbyscFb/QDEBM1M+t5HrS1FncXe3ad3+
         t6MQV2pO69AMcIC9xmniyO8gLN1CtJNq9yTjmz0OLAIqvp96my1VywVVf1lMNrd7kw
         r4LtSHL8hHrEuebqsMSVh407ZDs9r9upPdp1zyUM=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201122082636.12451-4-ceggers@arri.de>
References: <20201122082636.12451-1-ceggers@arri.de> <20201122082636.12451-4-ceggers@arri.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Christian Eggers <ceggers@gmx.de>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH net-next 3/3] net: phy: mscc: use new PTP_MSGTYPE_* defines
To:     Andrew Lunn <andrew@lunn.ch>, Christian Eggers <ceggers@arri.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <160612233299.3156.8952508603108883249@kwain.local>
Date:   Mon, 23 Nov 2020 10:05:33 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Christian,

Quoting Christian Eggers (2020-11-22 09:26:36)
> Use recently introduced PTP_MSGTYPE_SYNC and PTP_MSGTYPE_DELAY_REQ
> defines instead of a driver internal enumeration.
>=20
> Signed-off-by: Christian Eggers <ceggers@gmx.de>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!
Antoine

> Cc: Quentin Schulz <quentin.schulz@bootlin.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
>  drivers/net/phy/mscc/mscc_ptp.c | 14 +++++++-------
>  drivers/net/phy/mscc/mscc_ptp.h |  5 -----
>  2 files changed, 7 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_=
ptp.c
> index d8a61456d1ce..924ed5b034a4 100644
> --- a/drivers/net/phy/mscc/mscc_ptp.c
> +++ b/drivers/net/phy/mscc/mscc_ptp.c
> @@ -506,9 +506,9 @@ static int vsc85xx_ptp_cmp_init(struct phy_device *ph=
ydev, enum ts_blk blk)
>  {
>         struct vsc8531_private *vsc8531 =3D phydev->priv;
>         bool base =3D phydev->mdio.addr =3D=3D vsc8531->ts_base_addr;
> -       enum vsc85xx_ptp_msg_type msgs[] =3D {
> -               PTP_MSG_TYPE_SYNC,
> -               PTP_MSG_TYPE_DELAY_REQ
> +       u8 msgs[] =3D {
> +               PTP_MSGTYPE_SYNC,
> +               PTP_MSGTYPE_DELAY_REQ
>         };
>         u32 val;
>         u8 i;
> @@ -847,9 +847,9 @@ static int vsc85xx_ts_ptp_action_flow(struct phy_devi=
ce *phydev, enum ts_blk blk
>  static int vsc85xx_ptp_conf(struct phy_device *phydev, enum ts_blk blk,
>                             bool one_step, bool enable)
>  {
> -       enum vsc85xx_ptp_msg_type msgs[] =3D {
> -               PTP_MSG_TYPE_SYNC,
> -               PTP_MSG_TYPE_DELAY_REQ
> +       u8 msgs[] =3D {
> +               PTP_MSGTYPE_SYNC,
> +               PTP_MSGTYPE_DELAY_REQ
>         };
>         u32 val;
>         u8 i;
> @@ -858,7 +858,7 @@ static int vsc85xx_ptp_conf(struct phy_device *phydev=
, enum ts_blk blk,
>                 if (blk =3D=3D INGRESS)
>                         vsc85xx_ts_ptp_action_flow(phydev, blk, msgs[i],
>                                                    PTP_WRITE_NS);
> -               else if (msgs[i] =3D=3D PTP_MSG_TYPE_SYNC && one_step)
> +               else if (msgs[i] =3D=3D PTP_MSGTYPE_SYNC && one_step)
>                         /* no need to know Sync t when sending in one_ste=
p */
>                         vsc85xx_ts_ptp_action_flow(phydev, blk, msgs[i],
>                                                    PTP_WRITE_1588);
> diff --git a/drivers/net/phy/mscc/mscc_ptp.h b/drivers/net/phy/mscc/mscc_=
ptp.h
> index 3ea163af0f4f..da3465360e90 100644
> --- a/drivers/net/phy/mscc/mscc_ptp.h
> +++ b/drivers/net/phy/mscc/mscc_ptp.h
> @@ -436,11 +436,6 @@ enum ptp_cmd {
>         PTP_SAVE_IN_TS_FIFO =3D 11, /* invalid when writing in reg */
>  };
> =20
> -enum vsc85xx_ptp_msg_type {
> -       PTP_MSG_TYPE_SYNC,
> -       PTP_MSG_TYPE_DELAY_REQ,
> -};
> -
>  struct vsc85xx_ptphdr {
>         u8 tsmt; /* transportSpecific | messageType */
>         u8 ver;  /* reserved0 | versionPTP */
> --=20
> Christian Eggers
> Embedded software developer
>=20
