Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A841F8D6F
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 07:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgFOF6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 01:58:48 -0400
Received: from mail-eopbgr1320107.outbound.protection.outlook.com ([40.107.132.107]:54304
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728162AbgFOF6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 01:58:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZY9OI7Cr9UoEkavl9QNvEtyW47mpXWqCEnwSGIMaue782UMs5byvcKbuHTehYHFhY6YXE/OafwhDCUiHPuzJ9LTq++is31JvE06pxsJQvSdsbU0zkYIL42C48PZePgGQ/2c51V7Vt5/NgWpHp9oIO7QQfkBtmr69uYbUrYPWVqhP6zDQ0O9wqbTuKuTlr8RkIMADR4/WXHASStKd1VSDcpep9xx6q8VvBK1bvBIV5Y9YSzWZG1MrTSflQ4pJkLCIVot3PZ6JLg8ZdSaK2jvQZYMOkR1mvqRaEwXLvPTaHayPrxZGtzF3w5f7kPJy/VxuudkcdhBy6oNSWsF+1LdjEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cvh4RbwxqY+Gfveox1G9SKefTXXrO6hrkNWqekbCi1I=;
 b=fEZpZJyX+fWoOoy1JWS8VyOAIkbO+smYuu9IkHe9OMrI8n6kumOa70zZKx5qYAFZOtvaGYOB3Gl3pH3xJ3QU9jrcu8kC4KvsdMezwB+9BkFWW7rUwsJ55UnumBaevPJ/3AvJD72T8/IkCQiWXXhddhnWiObHKcrK8tXci6VVpsdICiPYjlDNiQpoCPe9fcp4DCIhkw/xAVnpXU5lXE8E/eThsZAJYoOpGCUkkqh4ow/KRhaKNm2/BBfGSqWfmUlcKo9aSFgNiIIyVI//U8osu0IEGvJZZbilVRonnq0p6TUda0RpeWYz/N2eiNvqQbC698T0YDWYvStT2TS+9N31fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cvh4RbwxqY+Gfveox1G9SKefTXXrO6hrkNWqekbCi1I=;
 b=oGm8vBMvS84Q6DzM8rr26Wjg/0WwbsXZF5IHh18hoRD9sJxp7LdJBbnAa8UeDiNu1zWk8ibTO0kBjjewY5NSDam03aGDSmP42d3kYCN+AFdZjsHpXWTEoHyyRCXxeGaTcQXVZb7zfhy4o9UTUMaBd6y/vm87AYRvEGnw1XYJZdI=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TY2PR01MB3883.jpnprd01.prod.outlook.com (2603:1096:404:d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20; Mon, 15 Jun
 2020 05:58:43 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::2da1:bdb7:9089:7f43]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::2da1:bdb7:9089:7f43%3]) with mapi id 15.20.3088.028; Mon, 15 Jun 2020
 05:58:42 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "REE dirk.behme@de.bosch.com" <dirk.behme@de.bosch.com>,
        "Shashikant.Suguni@in.bosch.com" <Shashikant.Suguni@in.bosch.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "sergei.shtylyov@gmail.com" <sergei.shtylyov@gmail.com>
Subject: RE: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
Thread-Topic: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
Thread-Index: AQHWM0Kg7roEc2K3tEugD8qfTO7LKKjZTL9g
Date:   Mon, 15 Jun 2020 05:58:42 +0000
Message-ID: <TY2PR01MB369266A27D1ADF5297A3CFFCD89C0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: cogentembedded.com; dkim=none (message not signed)
 header.d=none;cogentembedded.com; dmarc=none action=none
 header.from=renesas.com;
x-originating-ip: [124.210.22.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 437db216-eb8d-4dfe-3b75-08d810f128bb
x-ms-traffictypediagnostic: TY2PR01MB3883:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TY2PR01MB388386AB9A1C9E5AFDB53777D89C0@TY2PR01MB3883.jpnprd01.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 04359FAD81
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vSBdpvtszLiKPrSnVJL8vVnTPOfHnmvfPqjrKw4wdaD9qz7q3GpvnmR29EbHi7nnB0C5SkxS8xudkBa+VcCsaby1Iq47T5KrhGZQLXeWZAcCp4WouRSftYmHh4HaJbIldNNmrJJNlyetIUqz1H912/uNHAZfm1QlPQ+UDE2fxqa+6k49trDAOvTryO3lcnt89QxRylNY4+OtZbS4ow8LGLYnAPsqIsTtaRaesJ+OF4Mw0IMAg0XZd86RQoDpGQY/bHmqtIq29smr5+zTmblGdtuv/GAeK5SUGM3ABtpCL+LGmfOR+w+0uJclxkC/aZ29sphFv6uCMzovaEtYXsnIeHlnNOElFE/LxmwIecx8SK+WMsg2Hpzp5uUTxqZxGTrHSAkOZ3KUz1jErlzqsmhgpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(2906002)(83380400001)(33656002)(966005)(4326008)(52536014)(9686003)(5660300002)(55016002)(55236004)(26005)(66556008)(7696005)(6506007)(8936002)(76116006)(316002)(66446008)(64756008)(186003)(66476007)(66946007)(71200400001)(478600001)(110136005)(54906003)(86362001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: VgDX9L7nCgJa0GbgGOkPWVCODI0kcbl0Kv0DDesqdRwxt6azdK+iwymFOwyzK7IaCffdpP5q/3G9WI6JOqKKwJwu8ETb60bFPM2XcpBgBh6AamA/VXvaiVCd+cSBuXNreevCjWSlWecVeq6XILEMcvhGmFhmly8FBrMm0d8zROMiogXihGesTVxcsIMLYJo3iQzS9/iZ0mzCd1qFnZirzVMlu8XRN11AzljDOlqWhX97BArDoLfhz3MfGtYHtDDkX+US4ulS9m+raSTVQ53eeLgylyxvF0WOm5U8YRncmz5ZJ04XGCL27UgLK0vn5Hpcl0WKzpVJ/z9QVxQrYy3qSjpkRVsxjS4nrz3h8ArA46HZwPlyiPNBnFf8CwWqs/upnt/Xf9yQrAxX3kul9L04EwaoPd67fvPuGbVGUGbw1JDjxM6LalWiwz0+D57oFiJEpETHdD3VRfuC3l3Pc7gitbvF2NhgzBPPYroR/bePWjaZVSkdsZYWc2PEXBK9Y12c
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 437db216-eb8d-4dfe-3b75-08d810f128bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2020 05:58:42.8267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N0EqaiBfKzMeLi1WfxAIc6BEG1jus3CjATccl9nrhUdn2FoNeoaZUYqjRhzc1hs9+S5IwSn5u0c9f8YlI+EL5eRL/D/HLQ2CjZLr7ccqGrjhTHryRqvqTnlSztHfqvkb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB3883
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei-san,
(add your private email address to CC.)

> From: Yoshihiro Shimoda, Sent: Tuesday, May 26, 2020 6:47 PM
>=20
> According to the report of [1], this driver is possible to cause
> the following error in ravb_tx_timeout_work().
>=20
> ravb e6800000.ethernet ethernet: failed to switch device to config mode
>=20
> This error means that the hardware could not change the state
> from "Operation" to "Configuration" while some tx queue is operating.
> After that, ravb_config() in ravb_dmac_init() will fail, and then
> any descriptors will be not allocaled anymore so that NULL porinter
> dereference happens after that on ravb_start_xmit().
>=20
> Such a case is possible to be caused because this driver supports
> two queues (NC and BE) and the ravb_stop_dma() is possible to return
> without any stopping process if TCCR or CSR register indicates
> the hardware is operating for TX.
>=20
> To fix the issue, just try to wake the subqueue on
> ravb_tx_timeout_work() if the descriptors are not full instead
> of stop all transfers (all queues of TX and RX).
>=20
> [1]
> https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behm=
e@de.bosch.com/
>=20
> Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  I'm guessing that this issue is possible to happen if:
>  - ravb_start_xmit() calls netif_stop_subqueue(), and
>  - ravb_poll() will not be called with some reason, and
>  - netif_wake_subqueue() will be not called, and then
>  - dev_watchdog() in net/sched/sch_generic.c calls ndo_tx_timeout().
>=20
>  However, unfortunately, I didn't reproduce the issue yet.
>  To be honest, I'm also guessing other queues (SR) of this hardware
>  which out-of tree driver manages are possible to reproduce this issue,
>  but I didn't try such environment for now...
>=20
>  So, I marked RFC on this patch now.

I'm afraid, but do you have any comments about this patch?

Best regards,
Yoshihiro Shimoda

>  drivers/net/ethernet/renesas/ravb.h      |  1 -
>  drivers/net/ethernet/renesas/ravb_main.c | 48 ++++++++++----------------=
------
>  2 files changed, 14 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/r=
enesas/ravb.h
> index 9f88b5d..42cf41a 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1021,7 +1021,6 @@ struct ravb_private {
>  	u32 cur_tx[NUM_TX_QUEUE];
>  	u32 dirty_tx[NUM_TX_QUEUE];
>  	struct napi_struct napi[NUM_RX_QUEUE];
> -	struct work_struct work;
>  	/* MII transceiver section. */
>  	struct mii_bus *mii_bus;	/* MDIO bus control */
>  	int link;
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ether=
net/renesas/ravb_main.c
> index 067ad25..45e1ecd 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1428,44 +1428,25 @@ static int ravb_open(struct net_device *ndev)
>  static void ravb_tx_timeout(struct net_device *ndev, unsigned int txqueu=
e)
>  {
>  	struct ravb_private *priv =3D netdev_priv(ndev);
> +	unsigned long flags;
> +	bool wake =3D false;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +	if (priv->cur_tx[txqueue] - priv->dirty_tx[txqueue] <=3D
> +	    (priv->num_tx_ring[txqueue] - 1) * priv->num_tx_desc)
> +		wake =3D true;
>=20
>  	netif_err(priv, tx_err, ndev,
> -		  "transmit timed out, status %08x, resetting...\n",
> -		  ravb_read(ndev, ISS));
> +		  "transmit timed out (%d %d), status %08x %08x %08x\n",
> +		  txqueue, wake, ravb_read(ndev, ISS), ravb_read(ndev, TCCR),
> +		  ravb_read(ndev, CSR));
> +
> +	if (wake)
> +		netif_wake_subqueue(ndev, txqueue);
>=20
>  	/* tx_errors count up */
>  	ndev->stats.tx_errors++;
> -
> -	schedule_work(&priv->work);
> -}
> -
> -static void ravb_tx_timeout_work(struct work_struct *work)
> -{
> -	struct ravb_private *priv =3D container_of(work, struct ravb_private,
> -						 work);
> -	struct net_device *ndev =3D priv->ndev;
> -
> -	netif_tx_stop_all_queues(ndev);
> -
> -	/* Stop PTP Clock driver */
> -	if (priv->chip_id =3D=3D RCAR_GEN2)
> -		ravb_ptp_stop(ndev);
> -
> -	/* Wait for DMA stopping */
> -	ravb_stop_dma(ndev);
> -
> -	ravb_ring_free(ndev, RAVB_BE);
> -	ravb_ring_free(ndev, RAVB_NC);
> -
> -	/* Device init */
> -	ravb_dmac_init(ndev);
> -	ravb_emac_init(ndev);
> -
> -	/* Initialise PTP Clock driver */
> -	if (priv->chip_id =3D=3D RCAR_GEN2)
> -		ravb_ptp_init(ndev, priv->pdev);
> -
> -	netif_tx_start_all_queues(ndev);
> +	spin_unlock_irqrestore(&priv->lock, flags);
>  }
>=20
>  /* Packet transmit function for Ethernet AVB */
> @@ -2046,7 +2027,6 @@ static int ravb_probe(struct platform_device *pdev)
>  	}
>=20
>  	spin_lock_init(&priv->lock);
> -	INIT_WORK(&priv->work, ravb_tx_timeout_work);
>=20
>  	error =3D of_get_phy_mode(np, &priv->phy_interface);
>  	if (error && error !=3D -ENODEV)
> --
> 2.7.4

