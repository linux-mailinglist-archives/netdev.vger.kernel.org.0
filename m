Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E0613754B
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgAJRxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:53:12 -0500
Received: from mail-bn7nam10on2057.outbound.protection.outlook.com ([40.107.92.57]:6029
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728248AbgAJRxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 12:53:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FApb7uTUYn+ZEyy/Uz+vPE5tWdymKoQoewJaV2cJ4pXBUYOp/QAqjlgbC/vnJj/6vRtYQjLwf0lxhozcxV8U0ITMJP697HL3G7tQc16zrfasZZxBTGkmMGCc1v+hMfe5D8qgdoiOk4LY9qyuaZo4oO+X4w+x7ppKRUU0Vi/wVPce5/8Zrzn4pdOLf64zS/+7xyhyuvillwK9qlrV6NLZxp6Q8wEJ4jNZf1deMDatZ5GdqYKbiJLDsudkXs9hFMtAqQiep8IZpTwP/+tKrKPqrddtfgA863CUvXBPhUgY+NO3/Coir5t4KtYnLMa9PakIR+bK/QqFX2PzNIVBjb4ixQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+8hkU9v2jJbIOiwmeoobLv75ehNbhNfu9KLE45/ESE=;
 b=c7bazklGyTUVVt/2yIkdKnQPIwhOHq6AqySHA7+QWamPVxDR6copznJ6vR7Rdykzc/ZvQVLCGkmbyi1pty1bNILWmn5BhO7JBq2H1BcPjYrsPJsHo3ErI1rxNCsiZsV8sKL/VSUjjzXsVhWy6hBbERsdZn16n9PbqEZI/Mj0XyuyXCpTbiBU1mEv+RYhDK0t5EM95XApTgeswET8QFDR3yRO9jGkNxp1hTC7hgMTo9MARRNastDUeD/KxxtYg8jUFhF9+bN3reIL9gudOU7xlsLyR0WubETZILkMco6Ge08gZbqIv12T/ArEg8EMZigK+ZqZ1KnRCwvMPEx/uZj3sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+8hkU9v2jJbIOiwmeoobLv75ehNbhNfu9KLE45/ESE=;
 b=paNWozwy5z2WZAfKQQ8cEXfnYGlARXLoQBoXytfzvru51hlcDlH4VXMkBBdn1jdzh2z/YZC5keVZLyS9Vt5Crb/8bVBFO+FCwYmJuUfF0SnLUiwHTLDnOVK4LPOzL9QJHShb9sHlZya/sckkgJdoFf04YDamd0mPxdpQ5/0YGow=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6662.namprd02.prod.outlook.com (20.180.7.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 17:53:09 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 17:53:08 +0000
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
Thread-Index: AQHVx6y29d9jke+J9UGemOnmCbRblqfj+/xwgAAx8oA=
Date:   Fri, 10 Jan 2020 17:53:08 +0000
Message-ID: <CH2PR02MB70007946C760D524D56B6F64C7380@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-3-andre.przywara@arm.com>
 <CH2PR02MB7000063BD3CFC30D18B06FDFC7380@CH2PR02MB7000.namprd02.prod.outlook.com>
In-Reply-To: <CH2PR02MB7000063BD3CFC30D18B06FDFC7380@CH2PR02MB7000.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [183.83.136.244]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b3b355a5-f43e-4dd9-e36d-08d795f5f3fc
x-ms-traffictypediagnostic: CH2PR02MB6662:|CH2PR02MB6662:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB6662746DC4AFDE84B7E1F8EFC7380@CH2PR02MB6662.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(366004)(346002)(39850400004)(13464003)(189003)(199004)(66446008)(64756008)(66556008)(316002)(66946007)(33656002)(2940100002)(76116006)(81156014)(110136005)(26005)(52536014)(5660300002)(53546011)(6506007)(7696005)(186003)(66476007)(55016002)(86362001)(9686003)(2906002)(8676002)(81166006)(4326008)(54906003)(8936002)(71200400001)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6662;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NOgEikgirrNPcOj0pHoAefIQ6zbVMZdnGj0P43OzHo/NASWgHhP1LeXKsQxDDrndv+Lgj9p3O3mnPeKkm7aXpmF54fUFFwDnMzv+IpY2FiGP6CjuBZp0Nhna58Yohq4JUnTtGaDqVUJmF+cXEFM+thiOVciHXbGQy6E7taLgd08he6ZB5YzDjcd2zwdLU5VO3Y7JFOxN2lHza73ZXMfKYrCSRBCgi+64omi0fyHKFdMBS/aNAwJ2lSo/9KxXhQNwVb/FFHEdci5U3X131cAepg7zwPclt3x1Syf9lm0xC2Yph3okw9KaoMM8pRRV1gjf7ERFLGf9SXVBHNL+u9n1sI9sudv18LHCA5Dgfsr2VjCgQ92Dxj/PCLyJ0p4BBaMrrTjPDvJVCB94GL4LamFeJJ79vckQJlQDEPDxUIi7TU/TLJUWEFIi7GifaR8E5dLuppPYIZSf92CtCVUyNRMba6jauZIfwojaxc7sPBXCawkIw6/0l+c+0lJOiLkzvOXw
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b355a5-f43e-4dd9-e36d-08d795f5f3fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 17:53:08.7684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++1c22U+azx5QUVRp3eYTYtrYRNo6rlPvm9pSDrE5gZgVbwUyjCVbQjFLyUgbmbAXkm909qU0kmO6S7qZn5/Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Radhey Shyam Pandey
> Sent: Friday, January 10, 2020 8:25 PM
> To: Andre Przywara <andre.przywara@arm.com>; David S . Miller
> <davem@davemloft.net>
> Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 02/14] net: axienet: Propagate failure of DMA descrip=
tor
> setup
>=20
> > -----Original Message-----
> > From: Andre Przywara <andre.przywara@arm.com>
> > Sent: Friday, January 10, 2020 5:24 PM
> > To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> > <radheys@xilinx.com>
> > Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> > <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH 02/14] net: axienet: Propagate failure of DMA
> > descriptor setup
> >
> > When we fail allocating the DMA buffers in axienet_dma_bd_init(), we
> > report this error, but carry on with initialisation nevertheless.
> >
> > This leads to a kernel panic when the driver later wants to send a
> > packet, as it uses uninitialised data structures.
> >
> > Make the axienet_device_reset() routine return an error value, as it
> > contains the DMA buffer initialisation. Make sure we propagate the
> > error up the chain and eventually fail the driver initialisation, to
> > avoid relying on non-initialised buffers.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>=20
> > ---
> >  .../net/ethernet/xilinx/xilinx_axienet_main.c | 25
> > +++++++++++++------
> >  1 file changed, 18 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > index 20746b801959..97482cf093ce 100644
> > --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > @@ -437,9 +437,10 @@ static void axienet_setoptions(struct net_device
> > *ndev, u32 options)
> >  	lp->options |=3D options;
> >  }
> >
> > -static void __axienet_device_reset(struct axienet_local *lp)
> > +static int __axienet_device_reset(struct axienet_local *lp)
> >  {
> >  	u32 timeout;
> > +
> >  	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The
> > reset
> >  	 * process of Axi DMA takes a while to complete as all pending
> >  	 * commands/transfers will be flushed or completed during this @@
> > -455,9 +456,11 @@ static void __axienet_device_reset(struct
> > axienet_local *lp)
> >  		if (--timeout =3D=3D 0) {
> >  			netdev_err(lp->ndev, "%s: DMA reset timeout!\n",
> >  				   __func__);
> > -			break;
> > +			return -ETIMEDOUT;
> >  		}
> >  	}
> > +
> > +	return 0;
> >  }
> >
> >  /**
> > @@ -471,12 +474,15 @@ static void __axienet_device_reset(struct
> > axienet_local *lp)
> >   * Ethernet core. No separate hardware reset is done for the Axi Ether=
net
> >   * core.
> >   */

Minor nit- we need to add descripton for return value.
drivers/net/ethernet/xilinx/xilinx_axienet_main.c:491: warning:=20
No description found for return value of 'axienet_device_reset'

> > -static void axienet_device_reset(struct net_device *ndev)
> > +static int axienet_device_reset(struct net_device *ndev)
> >  {
> >  	u32 axienet_status;
> >  	struct axienet_local *lp =3D netdev_priv(ndev);
> > +	int ret;
> >
> > -	__axienet_device_reset(lp);
> > +	ret =3D __axienet_device_reset(lp);
> > +	if (ret)
> > +		return ret;
> >
> >  	lp->max_frm_size =3D XAE_MAX_VLAN_FRAME_SIZE;
> >  	lp->options |=3D XAE_OPTION_VLAN;
> > @@ -491,9 +497,11 @@ static void axienet_device_reset(struct
> > net_device
> > *ndev)
> >  			lp->options |=3D XAE_OPTION_JUMBO;
> >  	}
> >
> > -	if (axienet_dma_bd_init(ndev)) {
> > +	ret =3D axienet_dma_bd_init(ndev);
> > +	if (ret) {
> >  		netdev_err(ndev, "%s: descriptor allocation failed\n",
> >  			   __func__);
> > +		return ret;
> >  	}
> >
> >  	axienet_status =3D axienet_ior(lp, XAE_RCW1_OFFSET); @@ -518,6
> +526,8
> > @@ static void axienet_device_reset(struct net_device
> > *ndev)
> >  	axienet_setoptions(ndev, lp->options);
> >
> >  	netif_trans_update(ndev);
> > +
> > +	return 0;
> >  }
> >
> >  /**
> > @@ -921,8 +931,9 @@ static int axienet_open(struct net_device *ndev)
> >  	 */
> >  	mutex_lock(&lp->mii_bus->mdio_lock);
> >  	axienet_mdio_disable(lp);
> > -	axienet_device_reset(ndev);
> > -	ret =3D axienet_mdio_enable(lp);
> > +	ret =3D axienet_device_reset(ndev);
> > +	if (ret =3D=3D 0)
> > +		ret =3D axienet_mdio_enable(lp);
> >  	mutex_unlock(&lp->mii_bus->mdio_lock);
> >  	if (ret < 0)
> >  		return ret;
> > --
> > 2.17.1

