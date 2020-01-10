Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0307D1370E4
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgAJPOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:14:50 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:8847
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbgAJPOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 10:14:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX6XmZXIJUCStGEXCbuvimLh9jjh5iBv715wJrfbC2FxE1x2N8b8F3rfd4XkNMeW/89SFev7Zvpd+3F/Y7W21QSUUZbVZegLy0zN6VzVPH9JHc1l9dZ2xhfV53OGhYHfMD7lKTDiBkFqh2/KQQjGklW/d/N4fGu56hHgdbRGf2vejiwdMZXIfEbdcdONr3EJWdVzLzElta3EoFSl/1b66g8CwBT3vf0nYrawHJnsL7495Oa5HPmcFpRL1Yyg3IQbpEvjc0z9Xnn+eqxXRaOFYwIX8GgD3v0eSQpR7h+iyn2Qr3L1pg9cv2ojpwOTPShI4P5ZT0LuU7jg7Am70PK7Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ic0IedYA64h7TvmTjEwKb74Yxbqw6u3+Ex/dgXVxpyg=;
 b=BS0YqetJHPGNRkRDaNfnyI+lXl5dl6WBAMm22VWn46mMzZMF/TUp555W5EuvnQmaQnkA9BBt9tEL/J4kooLRkSRcL8gs7LDO1ZI05D7xr2GjvVU5LDahZqor7yTapUy0nuM3gI9jYTuaAXMEWDkPPr/SKNe+2I3SYpqyNXNbESWWopcvNfNfTCpGtEjCSSshLAxYFeH09BAc3OhcfOK7gLmwNXgxfcG1tzfmSINTUy7TRU01xlFjbykEbElcT3HeJOjt5R4DL3Haud9u/tHGgaqWOS77OEryCOEKFhynqRPHvozgkQ24IHxjg3dUOmnAwPH6e2tX2bb6wHwk7kb8Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ic0IedYA64h7TvmTjEwKb74Yxbqw6u3+Ex/dgXVxpyg=;
 b=tT1y/1oQgJR4ZHWM4IG3HZ1L7d2Xx5A84dFCLYSVkGKHS9uB5MBaMNgX1EogAHpHQTsn8dR/TbzLjqkakqOaahrbRhH+z98gQiijqs/k3ikvtatvLZpMzXUOSlCQZPdtMdW5CMx/e55R8ZtrUU71/S1SNVjOb2LE0tEZV/v8WJE=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6840.namprd02.prod.outlook.com (20.180.5.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 15:14:47 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 15:14:47 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andre Przywara <andre.przywara@arm.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 03/14] net: axienet: Fix DMA descriptor cleanup path
Thread-Topic: [PATCH 03/14] net: axienet: Fix DMA descriptor cleanup path
Thread-Index: AQHVx6y2ShwELFcgQk2RmkO2ceD3dafj/VgA
Date:   Fri, 10 Jan 2020 15:14:46 +0000
Message-ID: <CH2PR02MB7000F64AB27D352E00DC77A7C7380@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-4-andre.przywara@arm.com>
In-Reply-To: <20200110115415.75683-4-andre.przywara@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3336a455-c974-4424-2bc8-08d795dfd47b
x-ms-traffictypediagnostic: CH2PR02MB6840:|CH2PR02MB6840:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB6840D5CAD2DAAFAD37722CA3C7380@CH2PR02MB6840.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(13464003)(43544003)(189003)(199004)(71200400001)(316002)(66446008)(66556008)(66476007)(64756008)(110136005)(54906003)(52536014)(86362001)(55016002)(76116006)(66946007)(9686003)(478600001)(7696005)(5660300002)(2906002)(33656002)(6506007)(186003)(26005)(8936002)(81166006)(81156014)(53546011)(8676002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6840;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QIJamsDW9g0K8HymIx0Ck4dFfXXELQLaeu8/rYiqUibFYCBbfHB3WG4Lc+dwBvBNz6/TB7bUfYcSQ4PoU86K+20isukuN2Tn8uym4MsloiNJEqIkyHB9Ucidp+MyrDh3aVJ6bh/YmdsTW/XVaKZ3frKJYOvXxv/gj1HcipuRSQn4k05LnWKKyt+NWHLJdB+63MIYbIAyqtes67vc4L9CLaS4DnbHH4+P8GLfX86mAOfp3lKOZDlePBg1KVZaY2IbUqP3pXxrH/dpzPDO+LKOXXbdFrcHmf4e6G6FgITn9zxz/krLpHeDEnjKSuE57Oe8nKsRD7TwfSooGOwErHR8riM+heRpPMSDglvGRTnDR+9eNaNaU8v1t94dJ0J03NGhkHlIlJ3OuLzmCHK97NjvJEfvJ3sIn2PrC6oc0YThFXt2gHWUNgkRfyylmLYnSEREdzeCRgnaHW3giKKqKS3N7bL/68OpVKoHQypvr+Eu+JmzzG8vr/TqX0eG5chQOIHD6cly5PXF2UoMm378VguJBQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3336a455-c974-4424-2bc8-08d795dfd47b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 15:14:46.9490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0KTEaowHr/taVxheRuKsisr1MQWTz4PVOyDXhrF00wUoBxdfoDXZRXw/9+GBJczM9B3vErSI/FxnD9vQFw7GHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6840
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andre Przywara <andre.przywara@arm.com>
> Sent: Friday, January 10, 2020 5:24 PM
> To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> <radheys@xilinx.com>
> Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 03/14] net: axienet: Fix DMA descriptor cleanup path
>=20
> When axienet_dma_bd_init() bails out during the initialisation process,
> it might do so with parts of the structure already allocated and
> initialised, while other parts have not been touched yet. Before
> returning in this case, we call axienet_dma_bd_release(), which does not
> take care of this corner case.
> This is most obvious by the first loop happily dereferencing
> lp->rx_bd_v, which we actually check to be non NULL *afterwards*.
>=20
> Make sure we only unmap or free already allocated structures, by:
> - directly returning with -ENOMEM if nothing has been allocated at all
> - checking for lp->rx_bd_v to be non-NULL *before* using it
> - only unmapping allocated DMA RX regions
>=20
> This avoids NULL pointer dereferences when initialisation fails.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 43 ++++++++++++-------
>  1 file changed, 28 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 97482cf093ce..7e90044cf2d9 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -160,24 +160,37 @@ static void axienet_dma_bd_release(struct
> net_device *ndev)
>  	int i;
>  	struct axienet_local *lp =3D netdev_priv(ndev);
>=20
> +	/* If we end up here, tx_bd_v must have been DMA allocated. */
> +	dma_free_coherent(ndev->dev.parent,
> +			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
> +			  lp->tx_bd_v,
> +			  lp->tx_bd_p);
> +
> +	if (!lp->rx_bd_v)
> +		return;
> +
>  	for (i =3D 0; i < lp->rx_bd_num; i++) {
> -		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
> -				 lp->max_frm_size, DMA_FROM_DEVICE);
> +		/* A NULL skb means this descriptor has not been initialised
> +		 * at all.
> +		 */
> +		if (!lp->rx_bd_v[i].skb)
> +			break;
> +
>  		dev_kfree_skb(lp->rx_bd_v[i].skb);
> -	}
>=20
> -	if (lp->rx_bd_v) {
> -		dma_free_coherent(ndev->dev.parent,
> -				  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
> -				  lp->rx_bd_v,
> -				  lp->rx_bd_p);
> -	}
> -	if (lp->tx_bd_v) {
> -		dma_free_coherent(ndev->dev.parent,
> -				  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
> -				  lp->tx_bd_v,
> -				  lp->tx_bd_p);
> +		/* For each descriptor, we programmed cntrl with the (non-
> zero)
> +		 * descriptor size, after it had been successfully allocated.
> +		 * So a non-zero value in there means we need to unmap it.
> +		 */

> +		if (lp->rx_bd_v[i].cntrl)

I think it should ok to unmap w/o any check?
> +			dma_unmap_single(ndev->dev.parent, lp-
> >rx_bd_v[i].phys,
> +					 lp->max_frm_size,
> DMA_FROM_DEVICE);
>  	}
> +
> +	dma_free_coherent(ndev->dev.parent,
> +			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
> +			  lp->rx_bd_v,
> +			  lp->rx_bd_p);
>  }
>=20
>  /**
> @@ -207,7 +220,7 @@ static int axienet_dma_bd_init(struct net_device
> *ndev)
>  					 sizeof(*lp->tx_bd_v) * lp-
> >tx_bd_num,
>  					 &lp->tx_bd_p, GFP_KERNEL);
>  	if (!lp->tx_bd_v)
> -		goto out;
> +		return -ENOMEM;
>=20
>  	lp->rx_bd_v =3D dma_alloc_coherent(ndev->dev.parent,
>  					 sizeof(*lp->rx_bd_v) * lp-
> >rx_bd_num,
> --
> 2.17.1

