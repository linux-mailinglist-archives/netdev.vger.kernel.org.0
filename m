Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B434413702D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgAJOyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:54:40 -0500
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:8034
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728308AbgAJOyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 09:54:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8hE0Ok0STMoWusQ9TGi4Ta08BkovEV5HX3jrkQUFTWGs7Gw3HAaFCgq4zLGBJ1a5D7XMDEua/QUvtXkZs7/aBaS7T2bxOq3thueHX4/gYYrbvSP+izsYfiXgluDglIXGYy+0Jx+hrdjn/PizoFF2Q5KEyriqI8TS+S1L0BpbLQL4CtLFiPQPsApOwnlfjzDvyHghCmbUzmzvHP8eKA6WZ/YJsHJMXGXbhKqLWEEoyc1nSfhMdhOWbnxMbTBH2J4N5bRmqHyDalf9nDetvhrwx9lPiUXIAjujHPJC0OU5NPRfLb0WeoxwV6MXcf7Sf9DyKNJ4kJCkeWSFc0hqRPbZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWp09n2CH7TcP/N2KbkGHdfSNjz6T/re9GHkqptVCW8=;
 b=hcMvsSIWV8fC1oUi/SPFvv6ZH2JZ/UVQbAR6Sr4Tz1aB8u3qz51vewykKNLuVWeRvn5Kn/ighLhBEjpDvtAQQrOZ45bbefSlQ9u/1VpFfMNTvCcPLKu3kOSfQDYXqpGO468W8y9OXk9amf0R8k9dDadIXv/5VcJOnUe9DijUGwPc+uV3f/w5CHCVzHUw5oTjcCnqdxjtzcgfnfvwQdz4G1N/u9P2vHp4nEh7cvV3Sifuxk7+edXs44L/3Ym/lqHUdQhsvkx8jlIHk9ozxapNrvq747c6lrs+6yk1Ayr8Ba0o600Cwh6kj6+aqZfb4Ff8mpttv1aMaHA2zKVg7GaGXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWp09n2CH7TcP/N2KbkGHdfSNjz6T/re9GHkqptVCW8=;
 b=Acd26+9aGknuNXlMEA8tS1BErB+CGwUC4yti6J0cjU71PThh00b77Mkof6DlzGuOSZbTRcjc8G38EVm5AlbOGViFgpsDpcFq3uydbCnu8Voe9kro3EubGpACebn+dPom8rSRgruxeITMH6MvtDi9dY6VuIbiQaZ0xaGXGX+rFlk=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6760.namprd02.prod.outlook.com (10.141.156.73) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 14:54:35 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 14:54:35 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andre Przywara <andre.przywara@arm.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 02/14] net: axienet: Propagate failure of DMA descriptor
 setup
Thread-Topic: [PATCH 02/14] net: axienet: Propagate failure of DMA descriptor
 setup
Thread-Index: AQHVx6y29d9jke+J9UGemOnmCbRblqfj+/xw
Date:   Fri, 10 Jan 2020 14:54:35 +0000
Message-ID: <CH2PR02MB7000063BD3CFC30D18B06FDFC7380@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-3-andre.przywara@arm.com>
In-Reply-To: <20200110115415.75683-3-andre.przywara@arm.com>
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
x-ms-office365-filtering-correlation-id: a987f790-008e-4875-9333-08d795dd0286
x-ms-traffictypediagnostic: CH2PR02MB6760:|CH2PR02MB6760:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB67603C40A482241CBCA9BF76C7380@CH2PR02MB6760.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(199004)(189003)(13464003)(54906003)(110136005)(8676002)(81156014)(86362001)(81166006)(7696005)(26005)(186003)(478600001)(71200400001)(2906002)(6506007)(316002)(8936002)(53546011)(66446008)(64756008)(66556008)(4326008)(52536014)(33656002)(66476007)(55016002)(5660300002)(76116006)(66946007)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6760;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PWQiwu3otGzYSLtuYcCPGH4ZqYBkgD1P7S0kBdyECWGOcFBvuZXjS6XxyjnKg9tICTY3mvcBSOjRMstCZDmObooQnTOrFGzdvAF+YY/9xEE7TazvYeD9N/FzFVX1rmbDWBcbCfVCbz3k3yk7JxeF+MbvC5Pb2UZBNA6dxr5OfoY58YgtKB6nLA9jX0/amKL+L968cWsL25nt+Sc15LWebcR+ZFTpPNHnw+gQFCwjbs/akXkILiNfJD0Hw4kRsJ0xCgbJI96Xg2R9Sus6Angxae2FEi3zbnrGYTyKjcpoMlYmN6dJva9G/HEV8LoVbCKSC7ZA3MJ2prnjx0GhvV4mWI4XBhqKipl/gxCO5rb9GQW0KWZdFqcBd423kl4NjKOA84+1gAN3JFrJ9pVVnBsOO8XCYLY1tK5AGIxL4tlKc1fMqo+mFPw+HQRz12zUZekjpV2PIHQKqBeKYgMSgJjKCUU9UWjwCQCd5atCecrPnRUcxYLuRVzBXHUssvv4P0j8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a987f790-008e-4875-9333-08d795dd0286
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 14:54:35.7674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NKGSwuX3gG8GxXp+RBX5/80Nie0VQy1xapCxTY+CMzP3yZqE2uM2YCgkP+XGkqeewDnJN8E4dejNEhQL/KOCjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6760
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
> Subject: [PATCH 02/14] net: axienet: Propagate failure of DMA descriptor
> setup
>=20
> When we fail allocating the DMA buffers in axienet_dma_bd_init(), we
> report this error, but carry on with initialisation nevertheless.
>=20
> This leads to a kernel panic when the driver later wants to send a
> packet, as it uses uninitialised data structures.
>=20
> Make the axienet_device_reset() routine return an error value, as it
> contains the DMA buffer initialisation. Make sure we propagate the error
> up the chain and eventually fail the driver initialisation, to avoid
> relying on non-initialised buffers.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

> ---
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 25 +++++++++++++------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 20746b801959..97482cf093ce 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -437,9 +437,10 @@ static void axienet_setoptions(struct net_device
> *ndev, u32 options)
>  	lp->options |=3D options;
>  }
>=20
> -static void __axienet_device_reset(struct axienet_local *lp)
> +static int __axienet_device_reset(struct axienet_local *lp)
>  {
>  	u32 timeout;
> +
>  	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The
> reset
>  	 * process of Axi DMA takes a while to complete as all pending
>  	 * commands/transfers will be flushed or completed during this
> @@ -455,9 +456,11 @@ static void __axienet_device_reset(struct
> axienet_local *lp)
>  		if (--timeout =3D=3D 0) {
>  			netdev_err(lp->ndev, "%s: DMA reset timeout!\n",
>  				   __func__);
> -			break;
> +			return -ETIMEDOUT;
>  		}
>  	}
> +
> +	return 0;
>  }
>=20
>  /**
> @@ -471,12 +474,15 @@ static void __axienet_device_reset(struct
> axienet_local *lp)
>   * Ethernet core. No separate hardware reset is done for the Axi Etherne=
t
>   * core.
>   */
> -static void axienet_device_reset(struct net_device *ndev)
> +static int axienet_device_reset(struct net_device *ndev)
>  {
>  	u32 axienet_status;
>  	struct axienet_local *lp =3D netdev_priv(ndev);
> +	int ret;
>=20
> -	__axienet_device_reset(lp);
> +	ret =3D __axienet_device_reset(lp);
> +	if (ret)
> +		return ret;
>=20
>  	lp->max_frm_size =3D XAE_MAX_VLAN_FRAME_SIZE;
>  	lp->options |=3D XAE_OPTION_VLAN;
> @@ -491,9 +497,11 @@ static void axienet_device_reset(struct net_device
> *ndev)
>  			lp->options |=3D XAE_OPTION_JUMBO;
>  	}
>=20
> -	if (axienet_dma_bd_init(ndev)) {
> +	ret =3D axienet_dma_bd_init(ndev);
> +	if (ret) {
>  		netdev_err(ndev, "%s: descriptor allocation failed\n",
>  			   __func__);
> +		return ret;
>  	}
>=20
>  	axienet_status =3D axienet_ior(lp, XAE_RCW1_OFFSET);
> @@ -518,6 +526,8 @@ static void axienet_device_reset(struct net_device
> *ndev)
>  	axienet_setoptions(ndev, lp->options);
>=20
>  	netif_trans_update(ndev);
> +
> +	return 0;
>  }
>=20
>  /**
> @@ -921,8 +931,9 @@ static int axienet_open(struct net_device *ndev)
>  	 */
>  	mutex_lock(&lp->mii_bus->mdio_lock);
>  	axienet_mdio_disable(lp);
> -	axienet_device_reset(ndev);
> -	ret =3D axienet_mdio_enable(lp);
> +	ret =3D axienet_device_reset(ndev);
> +	if (ret =3D=3D 0)
> +		ret =3D axienet_mdio_enable(lp);
>  	mutex_unlock(&lp->mii_bus->mdio_lock);
>  	if (ret < 0)
>  		return ret;
> --
> 2.17.1

