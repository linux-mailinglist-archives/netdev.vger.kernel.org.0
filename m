Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8924B2D3E86
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgLIJVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:21:18 -0500
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:32206
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727665AbgLIJVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 04:21:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+rpjKaObmWAF8c/8h0eYe9/R7fIcyGAUqQVurChIHN68kejEvo3mUhwYNt6+/WOeQsangLvNDdnvTNkJ7a8a6U4CnXIXIjHta1oMhzHYNCGRQ43WwH2YhdHpsbsWDohhatvDYKzZKeELX7ndXXMRAKawVhUF07XJoDWtvElx/g6Pa2xllUOUyXz+0/I1w670Ge8XlNPhQGEPFpOsJAFOKc7UxxOcKnNA/8WKNCisWz/dNRxN8merAa3O48znvMiXvXz/lo24W/PCcwy13BhL2QbYegoUGe9bfqYdXnsb6MuCJ9PK/LJjqzpvUnIH0sgvaUGEpNUianmDcOFI98icg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/esLoKcz4kWH4w6zMxlo+ZG0mgSm/QzfWFfQQVohTcI=;
 b=XRp8Dy57ESzGe0OgSNi65IJK9I5Jxj6/usUX/DtwnFB1WkCWElCj0diU0kkMwIO00Fhaos9puN8sLQaDOL+qBfIeZUPFh1gB728Gdo3DKXrZfRPU/FhMYa+wqQYLyVMpPT8xO55A2DWQNVOlJilUuj9QoxlQaBNkPV3ldUgu0h32lWaX6cYAX7/DHblg/3c079r9JGfEXvCY2KacTpV0HPleLvYMD/xTxnUng/cLvQxPEJUwowl8RAhrIPcPoEPBEVQd2w4HLq5U83udOADhpLEQdy1NUKW2WBmU2aqT6MVmJnXLRwuUtKmShmEWbEDx5PBusGLwGBSHqwAx2rK5GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/esLoKcz4kWH4w6zMxlo+ZG0mgSm/QzfWFfQQVohTcI=;
 b=F7L1McTMD4rS7XTu5RqYmBh4CVeMfJ6JS6GouWuEzN7gpDt9Asjw5VZl30hQeY2+oDaqPvtFcJWzys6yZP7sA+k/r3j3npK+DQbeND9hNsoRCRZZBWAltiu7t57h7MnhaDYhWRrJLpABDzSRowcv351UWGIGSKUId1ywW+AivYk=
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com (2603:10a6:10:1ec::9)
 by DB8PR04MB5660.eurprd04.prod.outlook.com (2603:10a6:10:a5::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Wed, 9 Dec
 2020 09:20:17 +0000
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::c8c:888f:3e0c:8d5c]) by DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::c8c:888f:3e0c:8d5c%5]) with mapi id 15.20.3632.023; Wed, 9 Dec 2020
 09:20:17 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Viresh Kumar <vireshk@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>,
        Ion Badulescu <ionut@badula.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] PCI: Remove pci_try_set_mwi
Thread-Topic: [PATCH] PCI: Remove pci_try_set_mwi
Thread-Index: AQHWzgW2NT9muzSKf0y8HSvL/WLagqnufNYA
Date:   Wed, 9 Dec 2020 09:20:17 +0000
Message-ID: <20201209091947.GA31354@b29397-desktop>
References: <4d535d35-6c8c-2bd8-812b-2b53194ce0ec@gmail.com>
In-Reply-To: <4d535d35-6c8c-2bd8-812b-2b53194ce0ec@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.9.4 (2018-02-28)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: be67ec6f-07db-4bd6-bbb9-08d89c23a4c5
x-ms-traffictypediagnostic: DB8PR04MB5660:
x-microsoft-antispam-prvs: <DB8PR04MB56608BA32DB427DD5050926B8BCC0@DB8PR04MB5660.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zK9URy2toOJBKRMTR/ZJtGqgofzfzn6JepkM9TOfEXnNQ8F8XqQH7Ev1LXrL5aGsBlQ9v05Ewc9f96bq7pTn8+P9J+eAFiSld4RfvdDPFPubal1cHHKgK4tdQhWUJg9/qiarNyHxdBUX8e2EOWpADwcDiPrGhTMB2Mxpk9pfaROxGa84UQFtQAjBCC/7/L0z4YJl7B2h99swh306Ai8rqdWtDGBdnsWqNMVNXbsET681MKqI22zlN/Q/iGBAP7hD5Sxlr2wAZdUKwpKy4V5cxxfvXwBRbnnR2+nKyEdWjLdpiIMVFmLmWxIa1NSVXYhquWQU0s4uH23gBSPWacZsSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7979.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(366004)(346002)(83380400001)(71200400001)(33656002)(30864003)(6916009)(6486002)(86362001)(6506007)(8936002)(53546011)(4326008)(508600001)(91956017)(5660300002)(26005)(8676002)(54906003)(186003)(66946007)(64756008)(1076003)(66476007)(76116006)(33716001)(9686003)(7416002)(44832011)(66446008)(6512007)(66556008)(7406005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Lnn+2iDu5azWeFyf2zEb8kO8/C1L3Hq3vXSqqVmLjHMWk/xy5sWjwxT79QFQ?=
 =?us-ascii?Q?XD2H1UG/EJUokf4fjDxfBgxKFffVO2IjGt8ez4Eg4Vw6Ka14Pb7Z5jcdYbIF?=
 =?us-ascii?Q?nIyS/F0P4qrivmXSiKWPrs27QGfaxH7qrQdlb33yGNsAk82YUSwN1tcsADvL?=
 =?us-ascii?Q?qMg26HasftmnDn9M+LmHcJAG0slIjIkweeJYVCEKgIrefIfwkJykuQuEItxO?=
 =?us-ascii?Q?MrzWaYYpKz0MvqkZp7ghotFsi7xPu9FCreDJfDDv6GVh4YgV3l2oFn6heUVS?=
 =?us-ascii?Q?uPjZs0qTtTFS4L7lBws5MCK6P0aFqvylzG1yxczOZ4s6M1hC/ytBz/5M6f8Q?=
 =?us-ascii?Q?ksdmoGgfTpTjmI5XZznNidSqJyxanAxMKYWCJCBnIHwFVp8AEbjcIlDQv8I0?=
 =?us-ascii?Q?uSrAoY3YSQRImCzS0hn5slR+xEuPdbWy9ekKXE6ShcZZE60eQj6NyO26TExz?=
 =?us-ascii?Q?OSkfMmmUda9slfJgT/b2nY3rnPVKhQen9mx+fvcuefiTrKlIMEXXh6pFcnjE?=
 =?us-ascii?Q?CkHuUyGm+wM9vUFnQg2cY/e2xD0c+ifECv2YY67aRTcPMP9sRtcYnRaT0/kY?=
 =?us-ascii?Q?3D43q5vIAptBEVSMu/AbgZtB+1q99driXXT/9Ya6THRSL8ijLK6jcN7LczEZ?=
 =?us-ascii?Q?9qrligwhmDRbxzSUQ7t5uqJM92ZEVW9+BHrwdN7VAiIKsbLV9sseeFvhrfVZ?=
 =?us-ascii?Q?7j0dJH/lP2f4iKOcxpjGcY2DbnsH2bV2fV8bDPhKWWyjbzgJ1jsHzh7knemG?=
 =?us-ascii?Q?jXCBsIAPIW7e8KrJhfqMHnRSdYBWS/37LCjmnSsinUOcuv2TpbtjIoOa5YO3?=
 =?us-ascii?Q?1E4uQCJ/DatI9sKjfB253Yir7IgtpLyNpmCyyYVPaZXiZb6Rm4uG0s52IUCj?=
 =?us-ascii?Q?zJjSqd83Zx7CarhKha6HEsaraXF20oYcxG8wewaqwcfHPUg7DZoG/5RTYsad?=
 =?us-ascii?Q?5fao0F8sYiZ8xHPw2H/EtlF2NjJ6wA2ypXpgf3bsqVdK4qWh+VMOKEyZLsud?=
 =?us-ascii?Q?F3K+?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CB24077AAC54874B9110751BD93BB7A2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7979.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be67ec6f-07db-4bd6-bbb9-08d89c23a4c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 09:20:17.3771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JjXeH/lK2+Oiz435z2SwAVQCyWvUkKUBAyBsPDNcr0N63SC6PEr2I/SZgbuo6ADlgAC42p753eSNnkOQ5QWntw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5660
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-12-09 09:31:21, Heiner Kallweit wrote:
>  drivers/usb/chipidea/ci_hdrc_pci.c            |  2 +-

For chipidea changes:

Acked-by: Peter Chen <peter.chen@nxp.com>

Peter


>  drivers/usb/gadget/udc/amd5536udc_pci.c       |  2 +-
>  drivers/usb/gadget/udc/net2280.c              |  2 +-
>  drivers/usb/gadget/udc/pch_udc.c              |  2 +-
>  include/linux/pci.h                           |  5 ++---
>  27 files changed, 33 insertions(+), 60 deletions(-)
>=20
> diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
> index 814b40f83..120362cc9 100644
> --- a/Documentation/PCI/pci.rst
> +++ b/Documentation/PCI/pci.rst
> @@ -226,10 +226,7 @@ If the PCI device can use the PCI Memory-Write-Inval=
idate transaction,
>  call pci_set_mwi().  This enables the PCI_COMMAND bit for Mem-Wr-Inval
>  and also ensures that the cache line size register is set correctly.
>  Check the return value of pci_set_mwi() as not all architectures
> -or chip-sets may support Memory-Write-Invalidate.  Alternatively,
> -if Mem-Wr-Inval would be nice to have but is not required, call
> -pci_try_set_mwi() to have the system do its best effort at enabling
> -Mem-Wr-Inval.
> +or chip-sets may support Memory-Write-Invalidate.
> =20
> =20
>  Request MMIO/IOP resources
> diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
> index ad75d02b6..8654b3ae1 100644
> --- a/drivers/ata/pata_cs5530.c
> +++ b/drivers/ata/pata_cs5530.c
> @@ -214,7 +214,7 @@ static int cs5530_init_chip(void)
>  	}
> =20
>  	pci_set_master(cs5530_0);
> -	pci_try_set_mwi(cs5530_0);
> +	pci_set_mwi(cs5530_0);
> =20
>  	/*
>  	 * Set PCI CacheLineSize to 16-bytes:
> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
> index 664ef658a..ee37755ea 100644
> --- a/drivers/ata/sata_mv.c
> +++ b/drivers/ata/sata_mv.c
> @@ -4432,7 +4432,7 @@ static int mv_pci_init_one(struct pci_dev *pdev,
>  	mv_print_info(host);
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
>  	return ata_host_activate(host, pdev->irq, mv_interrupt, IRQF_SHARED,
>  				 IS_GEN_I(hpriv) ? &mv5_sht : &mv6_sht);
>  }
> diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
> index 1142aa6f8..1c20b7485 100644
> --- a/drivers/dma/dw/pci.c
> +++ b/drivers/dma/dw/pci.c
> @@ -30,7 +30,7 @@ static int dw_pci_probe(struct pci_dev *pdev, const str=
uct pci_device_id *pid)
>  	}
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	ret =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
>  	if (ret)
> diff --git a/drivers/dma/hsu/pci.c b/drivers/dma/hsu/pci.c
> index 07cc7320a..420dd3706 100644
> --- a/drivers/dma/hsu/pci.c
> +++ b/drivers/dma/hsu/pci.c
> @@ -73,7 +73,7 @@ static int hsu_pci_probe(struct pci_dev *pdev, const st=
ruct pci_device_id *id)
>  	}
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	ret =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
>  	if (ret)
> diff --git a/drivers/ide/cs5530.c b/drivers/ide/cs5530.c
> index 5bb46e713..5d2c421ab 100644
> --- a/drivers/ide/cs5530.c
> +++ b/drivers/ide/cs5530.c
> @@ -168,7 +168,7 @@ static int init_chipset_cs5530(struct pci_dev *dev)
>  	 */
> =20
>  	pci_set_master(cs5530_0);
> -	pci_try_set_mwi(cs5530_0);
> +	pci_set_mwi(cs5530_0);
> =20
>  	/*
>  	 * Set PCI CacheLineSize to 16-bytes:
> diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
> index 2d7c588ef..a0c3be750 100644
> --- a/drivers/mfd/intel-lpss-pci.c
> +++ b/drivers/mfd/intel-lpss-pci.c
> @@ -39,7 +39,7 @@ static int intel_lpss_pci_probe(struct pci_dev *pdev,
> =20
>  	/* Probably it is enough to set this for iDMA capable devices only */
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	ret =3D intel_lpss_probe(&pdev->dev, info);
>  	if (ret)
> diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethern=
et/adaptec/starfire.c
> index 555299737..1dbff34c4 100644
> --- a/drivers/net/ethernet/adaptec/starfire.c
> +++ b/drivers/net/ethernet/adaptec/starfire.c
> @@ -679,7 +679,7 @@ static int starfire_init_one(struct pci_dev *pdev,
>  	pci_set_master(pdev);
> =20
>  	/* enable MWI -- it vastly improves Rx performance on sparc64 */
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  #ifdef ZEROCOPY
>  	/* Starfire can do TCP/UDP checksumming */
> diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethe=
rnet/alacritech/slicoss.c
> index 696517eae..544510f57 100644
> --- a/drivers/net/ethernet/alacritech/slicoss.c
> +++ b/drivers/net/ethernet/alacritech/slicoss.c
> @@ -1749,7 +1749,7 @@ static int slic_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
>  	}
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	slic_configure_pci(pdev);
> =20
> diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/et=
hernet/dec/tulip/tulip_core.c
> index c1dcd6ca1..4f6debb24 100644
> --- a/drivers/net/ethernet/dec/tulip/tulip_core.c
> +++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
> @@ -1193,10 +1193,7 @@ static void tulip_mwi_config(struct pci_dev *pdev,=
 struct net_device *dev)
>  	/* if we have any cache line size at all, we can do MRM and MWI */
>  	csr0 |=3D MRM | MWI;
> =20
> -	/* Enable MWI in the standard PCI command bit.
> -	 * Check for the case where MWI is desired but not available
> -	 */
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	/* read result from hardware (in case bit refused to enable) */
>  	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
> diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/su=
n/cassini.c
> index 9ff894ba8..9a95ec989 100644
> --- a/drivers/net/ethernet/sun/cassini.c
> +++ b/drivers/net/ethernet/sun/cassini.c
> @@ -4933,14 +4933,14 @@ static int cas_init_one(struct pci_dev *pdev, con=
st struct pci_device_id *ent)
>  	pci_cmd &=3D ~PCI_COMMAND_SERR;
>  	pci_cmd |=3D PCI_COMMAND_PARITY;
>  	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
> -	if (pci_try_set_mwi(pdev))
> +	if (pci_set_mwi(pdev))
>  		pr_warn("Could not enable MWI for %s\n", pci_name(pdev));
> =20
>  	cas_program_bridge(pdev);
> =20
>  	/*
>  	 * On some architectures, the default cache line size set
> -	 * by pci_try_set_mwi reduces perforamnce.  We have to increase
> +	 * by pci_set_mwi reduces performance.  We have to increase
>  	 * it for this case.  To start, we'll print some configuration
>  	 * data.
>  	 */
> diff --git a/drivers/net/wireless/intersil/p54/p54pci.c b/drivers/net/wir=
eless/intersil/p54/p54pci.c
> index e97ee547b..c76326d1e 100644
> --- a/drivers/net/wireless/intersil/p54/p54pci.c
> +++ b/drivers/net/wireless/intersil/p54/p54pci.c
> @@ -583,7 +583,7 @@ static int p54p_probe(struct pci_dev *pdev,
>  	}
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	pci_write_config_byte(pdev, 0x40, 0);
>  	pci_write_config_byte(pdev, 0x41, 0);
> diff --git a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c b/dri=
vers/net/wireless/intersil/prism54/islpci_hotplug.c
> index 31a1e6132..e8087d9a5 100644
> --- a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
> +++ b/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
> @@ -153,8 +153,7 @@ prism54_probe(struct pci_dev *pdev, const struct pci_=
device_id *id)
>  	DEBUG(SHOW_TRACING, "%s: pci_set_master(pdev)\n", DRV_NAME);
>  	pci_set_master(pdev);
> =20
> -	/* enable MWI */
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	/* setup the network device interface and its structure */
>  	if (!(ndev =3D islpci_setup(pdev))) {
> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers=
/net/wireless/realtek/rtl818x/rtl8180/dev.c
> index 2477e18c7..b259b0b58 100644
> --- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> +++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> @@ -1871,7 +1871,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
> =20
>  	if (priv->chip_family !=3D RTL818X_CHIP_FAMILY_RTL8180) {
>  		priv->band.n_bitrates =3D ARRAY_SIZE(rtl818x_rates);
> -		pci_try_set_mwi(pdev);
> +		pci_set_mwi(pdev);
>  	}
> =20
>  	if (priv->chip_family !=3D RTL818X_CHIP_FAMILY_RTL8180)
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 9a5500287..f0ab432d2 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4389,25 +4389,6 @@ int pcim_set_mwi(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL(pcim_set_mwi);
> =20
> -/**
> - * pci_try_set_mwi - enables memory-write-invalidate PCI transaction
> - * @dev: the PCI device for which MWI is enabled
> - *
> - * Enables the Memory-Write-Invalidate transaction in %PCI_COMMAND.
> - * Callers are not required to check the return value.
> - *
> - * RETURNS: An appropriate -ERRNO error value on error, or zero for succ=
ess.
> - */
> -int pci_try_set_mwi(struct pci_dev *dev)
> -{
> -#ifdef PCI_DISABLE_MWI
> -	return 0;
> -#else
> -	return pci_set_mwi(dev);
> -#endif
> -}
> -EXPORT_SYMBOL(pci_try_set_mwi);
> -
>  /**
>   * pci_clear_mwi - disables Memory-Write-Invalidate for device dev
>   * @dev: the PCI device to disable
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index b4718a1b2..d869485e2 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -2018,7 +2018,7 @@ static int twa_probe(struct pci_dev *pdev, const st=
ruct pci_device_id *dev_id)
>  	}
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	retval =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>  	if (retval)
> @@ -2227,7 +2227,7 @@ static int __maybe_unused twa_resume(struct device =
*dev)
> =20
>  	printk(KERN_WARNING "3w-9xxx: Resuming host %d.\n", tw_dev->host->host_=
no);
> =20
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	retval =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>  	if (retval)
> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index b8f1848ec..49ca153b8 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -1571,7 +1571,7 @@ static int twl_probe(struct pci_dev *pdev, const st=
ruct pci_device_id *dev_id)
>  	}
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	retval =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>  	if (retval)
> @@ -1790,7 +1790,7 @@ static int __maybe_unused twl_resume(struct device =
*dev)
>  	TW_Device_Extension *tw_dev =3D (TW_Device_Extension *)host->hostdata;
> =20
>  	printk(KERN_WARNING "3w-sas: Resuming host %d.\n", tw_dev->host->host_n=
o);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	retval =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>  	if (retval)
> diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/cs=
io_init.c
> index 390b07bf9..c20bf44c6 100644
> --- a/drivers/scsi/csiostor/csio_init.c
> +++ b/drivers/scsi/csiostor/csio_init.c
> @@ -201,7 +201,7 @@ csio_pci_init(struct pci_dev *pdev, int *bars)
>  		goto err_disable_device;
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	rv =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>  	if (rv)
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.=
c
> index ac67f420e..b4833c0f8 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -6119,7 +6119,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>  		goto out_disable_device;
>  	/* Set up device as PCI master and save state for EEH */
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
>  	pci_save_state(pdev);
> =20
>  	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 5626e9b69..76019dc2e 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2356,7 +2356,7 @@ qla2100_pci_config(scsi_qla_host_t *vha)
>  	struct device_reg_2xxx __iomem *reg =3D &ha->iobase->isp;
> =20
>  	pci_set_master(ha->pdev);
> -	pci_try_set_mwi(ha->pdev);
> +	pci_set_mwi(ha->pdev);
> =20
>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
>  	w |=3D (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
> @@ -2388,7 +2388,7 @@ qla2300_pci_config(scsi_qla_host_t *vha)
>  	struct device_reg_2xxx __iomem *reg =3D &ha->iobase->isp;
> =20
>  	pci_set_master(ha->pdev);
> -	pci_try_set_mwi(ha->pdev);
> +	pci_set_mwi(ha->pdev);
> =20
>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
>  	w |=3D (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
> @@ -2469,7 +2469,7 @@ qla24xx_pci_config(scsi_qla_host_t *vha)
>  	struct device_reg_24xx __iomem *reg =3D &ha->iobase->isp24;
> =20
>  	pci_set_master(ha->pdev);
> -	pci_try_set_mwi(ha->pdev);
> +	pci_set_mwi(ha->pdev);
> =20
>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
>  	w |=3D (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
> @@ -2511,7 +2511,7 @@ qla25xx_pci_config(scsi_qla_host_t *vha)
>  	struct qla_hw_data *ha =3D vha->hw;
> =20
>  	pci_set_master(ha->pdev);
> -	pci_try_set_mwi(ha->pdev);
> +	pci_set_mwi(ha->pdev);
> =20
>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
>  	w |=3D (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.=
c
> index ca7306685..e9763d8e3 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -499,7 +499,7 @@ qlafx00_pci_config(scsi_qla_host_t *vha)
>  	struct qla_hw_data *ha =3D vha->hw;
> =20
>  	pci_set_master(ha->pdev);
> -	pci_try_set_mwi(ha->pdev);
> +	pci_set_mwi(ha->pdev);
> =20
>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
>  	w |=3D (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
> diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/825=
0/8250_lpss.c
> index 4dee8a9e0..8acc1e5c9 100644
> --- a/drivers/tty/serial/8250/8250_lpss.c
> +++ b/drivers/tty/serial/8250/8250_lpss.c
> @@ -193,7 +193,7 @@ static void qrk_serial_setup_dma(struct lpss8250 *lps=
s, struct uart_port *port)
>  	if (ret)
>  		return;
> =20
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	/* Special DMA address for UART */
>  	dma->rx_dma_addr =3D 0xfffff000;
> diff --git a/drivers/usb/chipidea/ci_hdrc_pci.c b/drivers/usb/chipidea/ci=
_hdrc_pci.c
> index d63479e1a..d412fa910 100644
> --- a/drivers/usb/chipidea/ci_hdrc_pci.c
> +++ b/drivers/usb/chipidea/ci_hdrc_pci.c
> @@ -78,7 +78,7 @@ static int ci_hdrc_pci_probe(struct pci_dev *pdev,
>  	}
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	/* register a nop PHY */
>  	ci->phy =3D usb_phy_generic_register();
> diff --git a/drivers/usb/gadget/udc/amd5536udc_pci.c b/drivers/usb/gadget=
/udc/amd5536udc_pci.c
> index 8d387e0e4..9630ce8d3 100644
> --- a/drivers/usb/gadget/udc/amd5536udc_pci.c
> +++ b/drivers/usb/gadget/udc/amd5536udc_pci.c
> @@ -151,7 +151,7 @@ static int udc_pci_probe(
>  	dev->chiprev =3D pdev->revision;
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	/* init dma pools */
>  	if (use_dma) {
> diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/ne=
t2280.c
> index fc9f99fe7..e15520698 100644
> --- a/drivers/usb/gadget/udc/net2280.c
> +++ b/drivers/usb/gadget/udc/net2280.c
> @@ -3761,7 +3761,7 @@ static int net2280_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
>  			&dev->pci->pcimstctl);
>  	/* erratum 0115 shouldn't appear: Linux inits PCI_LATENCY_TIMER */
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	/* ... also flushes any posted pci writes */
>  	dev->chiprev =3D get_idx_reg(dev->regs, REG_CHIPREV) & 0xffff;
> diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pc=
h_udc.c
> index a3c1fc924..4a0484a0c 100644
> --- a/drivers/usb/gadget/udc/pch_udc.c
> +++ b/drivers/usb/gadget/udc/pch_udc.c
> @@ -3100,7 +3100,7 @@ static int pch_udc_probe(struct pci_dev *pdev,
>  	}
> =20
>  	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> +	pci_set_mwi(pdev);
> =20
>  	/* device struct setup */
>  	spin_lock_init(&dev->lock);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index de75f6a4d..c590f616d 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1191,9 +1191,8 @@ void pci_clear_master(struct pci_dev *dev);
> =20
>  int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state =
state);
>  int pci_set_cacheline_size(struct pci_dev *dev);
> -int __must_check pci_set_mwi(struct pci_dev *dev);
> -int __must_check pcim_set_mwi(struct pci_dev *dev);
> -int pci_try_set_mwi(struct pci_dev *dev);
> +int pci_set_mwi(struct pci_dev *dev);
> +int pcim_set_mwi(struct pci_dev *dev);
>  void pci_clear_mwi(struct pci_dev *dev);
>  void pci_intx(struct pci_dev *dev, int enable);
>  bool pci_check_and_mask_intx(struct pci_dev *dev);
> --=20
> 2.29.2
>=20

--=20

Thanks,
Peter Chen=
