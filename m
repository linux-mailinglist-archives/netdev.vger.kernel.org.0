Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB1E54FE6
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 15:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfFYNLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 09:11:23 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:56450 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726702AbfFYNLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 09:11:23 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A3497C0BDF;
        Tue, 25 Jun 2019 13:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561468282; bh=pVOI7vtpkaOEo69Q/qZzk7oLFXaKmC7L4sMOnj6pYa8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=CKkjHwmPT3HKFCIiQWDzBwir8qzzY1cPH8KDT90y1wI5BBNrQB4NXjJ1MPAtC8Oeg
         q+mZaKxqadKqX7eBu+SSmvFeGKLFZj9jFP9DlI/Lgz2/KiLxk9dQEvNX+MG9BG9QjF
         8MIi98Db6S0lO3U70W1ur5E8TKl6M2lKVPuEcYL96ebDIkQwwoWS87C2AsVZWjvfTY
         6hzSSucJ54+tPHWCUg+iEbu6iavhRC1noUPoMzwfUXm/N4XH+/krYfMiJZIQdcbJUL
         viArzcf35U1VFoG7rKCNoEpTSLMav5BcuxNAc0EicNyGR3DlqP551r2Ac9zxBIL2SC
         92wsvtaqppgJw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 1B768A0068;
        Tue, 25 Jun 2019 13:11:22 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 25 Jun 2019 06:11:21 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Tue,
 25 Jun 2019 15:11:18 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Katsuhiro Suzuki <katsuhiro@katsuster.net>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next] net: stmmac: Fix the case when PHY handle is
 not present
Thread-Topic: [PATCH net-next] net: stmmac: Fix the case when PHY handle is
 not present
Thread-Index: AQHVKy6wyQrkI1N/ykesAgacT59cX6asWGJA
Date:   Tue, 25 Jun 2019 13:11:17 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B9D78A2@DE02WEMBXB.internal.synopsys.com>
References: <351cce38d1c572d8b171044f2856c7fae9f89cbc.1561450696.git.joabreu@synopsys.com>
In-Reply-To: <351cce38d1c572d8b171044f2856c7fae9f89cbc.1561450696.git.joabreu@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.16]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

++ Katsuhiro

From: Jose Abreu <joabreu@synopsys.com>

> Some DT bindings do not have the PHY handle. Let's fallback to manually
> discovery in case phylink_of_phy_connect() fails.
>=20
> Reported-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib l=
ogic")
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> ---
> Hello Katsuhiro,
>=20
> Can you please test this patch ?
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index a48751989fa6..f4593d2d9d20 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -950,9 +950,12 @@ static int stmmac_init_phy(struct net_device *dev)
> =20
>  	node =3D priv->plat->phylink_node;
> =20
> -	if (node) {
> +	if (node)
>  		ret =3D phylink_of_phy_connect(priv->phylink, node, 0);
> -	} else {
> +
> +	/* Some DT bindings do not set-up the PHY handle. Let's try to
> +	 * manually parse it */
> +	if (!node || ret) {
>  		int addr =3D priv->plat->phy_addr;
>  		struct phy_device *phydev;
> =20
> --=20
> 2.7.4


