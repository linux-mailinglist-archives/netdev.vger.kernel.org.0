Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B1039DF12
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhFGOtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:49:22 -0400
Received: from mail-mw2nam10on2072.outbound.protection.outlook.com ([40.107.94.72]:29152
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230193AbhFGOtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 10:49:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mu+XxY/zEEkFVaUH6ud+yvRXI7NzLcAH4lelLGAWWX+kbzNh/I21E+kTmR9M4VbrgvR2R1nMFIOP8x+btlx45Et2g6669bhiWF4reI6Q5+gEzcuW+BV0Yx9ighdxMI7kePANXOmfqdz7DabRuo1GTjNZ8zL8TnbqXUggFAlFs5pKQPBvZMwdDM8Oo7JfybQrfzfkKAkh15nyEOgTnzWsN3IpyKNK+awwg0evJy8txp4v8DDxUq7XYQbDyX5uV9osl+38vDtkALqexRdBlx5O3wHuP1RcmTEM5QDKh0ZqYz9rG1DNXJLR8p6/31pJ1hyYjPlm2N2treXBC3fx7pvBUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4z5GbKNBObaAwYhvGwalRlIWnaJdvRPN6FG97ySMWcM=;
 b=LPqNQv3d6Y0XYCuPfWr39P8WlYSNn7Mf8IUwJ7QCtZofiEJwoIXqgDewnV1JWnmBC1Bq66Rulr9Cb1euLLAk+qFXarS07j+EyT0oXu3y2TEKSMmLuSg312esT+PN9HtYkl3KqbfnqlrCRhzm3ogkPzAKfQ5tHjhnxcYRfOA9J3OTI6Pud5lDYqooX0I6jR9Hmu0lPMFhdxULIUe57D7556QhldukNTaShSD88eaU6fbbGPusJVniB9d+wCA6+m1zBzBFRrtrtgpNfeAxGavbtPPmX9L08Y1Th38No5dwgOWHh6Sk0KNXM8VElYbakbH7hh4w+ttFNB/u0ggHZ47FhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4z5GbKNBObaAwYhvGwalRlIWnaJdvRPN6FG97ySMWcM=;
 b=SAKmvg+O3cEP+RsQogmS3fom2PPjijuERWitpbf2NPPgV2QV/LN3P/ISwKZ6xUeJAWEJTpuiZ//UfXUxlHOGEE5KlNhhbZ2AC4JCUl5cjeqtdW/sfZZtI6V7n0wPbW0bJbzlG6/y6VeEZP5jqSqKp53CQETQOT2KAGm+QOH1kzgDL4Y70TYK0x7pqFTjOyJ0CDts3b7LNyXiufqHvOXlS44WOIh+LLaXfVp9kek3pNG/fP3y9DD2VA+EQbr7VyYgesmgXJpUdobHWTCK5W0Gcnq5ebo19Qk4WCeMX0IYnIjwDxg+dFgdHFCYPcJ95Y6qlYd4adQ89WGUT/q35kGJCg==
Received: from BN9PR12MB5340.namprd12.prod.outlook.com (2603:10b6:408:105::22)
 by BN9PR12MB5035.namprd12.prod.outlook.com (2603:10b6:408:134::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Mon, 7 Jun
 2021 14:47:28 +0000
Received: from BN9PR12MB5340.namprd12.prod.outlook.com
 ([fe80::d41:8407:ca2c:be6b]) by BN9PR12MB5340.namprd12.prod.outlook.com
 ([fe80::d41:8407:ca2c:be6b%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 14:47:28 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Liming Sun <limings@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: RE: [PATCH net-next v6] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Topic: [PATCH net-next v6] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Index: AQHXVuEpSOTcrUt2GECg02LvPMfTFasAJJeAgAiFWMA=
Date:   Mon, 7 Jun 2021 14:47:28 +0000
Message-ID: <BN9PR12MB534065BE42BA2951929F6CEEC7389@BN9PR12MB5340.namprd12.prod.outlook.com>
References: <20210601122455.1025-1-davthompson@nvidia.com>
 <YLcLV+p4yZGjdMHO@unreal>
In-Reply-To: <YLcLV+p4yZGjdMHO@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.62.225.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1905bbd-431d-473f-f8a4-08d929c32c35
x-ms-traffictypediagnostic: BN9PR12MB5035:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR12MB5035E8822836E88BC247020DC7389@BN9PR12MB5035.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kXPzE9DZnOQ9VX134ch2RnPxQbfD8fbvc0gpiSiOzquzlllnLJd3eb1A5hslxZGtYwZMdenAKDJYKN120beiIvCwzaPlMS+4kfHa7QR5aZitg+16Rp6fO1W3KR4ng9WjX6A1H5ux8Fd4gMXO6vnO3fYMpEFbqfIjAvafDElD/FFdXoLeI4N5lHHmhtJE+zLbxmMhB/bxTd8W6vnm12iGCS5+MCHnjuvqfJZ+seP3E50KLxuWVcUR55oG/LHjoI0xL8xRXJNY9Kw2jhsW+/yVNUD5ciYFCzXBVYbP5zS6N4/Qayej3hG691HV8WGxmzppr4IEtZiZEzxQvfEIXEiAtuUoV559vinkrSkAuR3X/PZIsBooIch1HSv7Fnzk/4wDjjiHPoZRL45P0AqvlGPWwIFK6cXfhOHgKsJXvW7eGoqWptrJiQVaihPJFiK7P+ZW8PUz1vG1acFijfZ/8fzJRbF0w9LqtiC7dhoL7LczQp4R1vanOc1LU4kZEIiDSkX1aRMfq6aIpSa/SMTY0v3R/XpZM77DXWnUB2//RDcFGgtTKc1rBRmbC1Wr95IX7PptxnEeq1lTMg9tOenT8Gw5HbJS8wXzPzTyE0CrUEH06tA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(33656002)(6506007)(66946007)(54906003)(38100700002)(6916009)(86362001)(316002)(76116006)(66476007)(9686003)(186003)(5660300002)(66556008)(53546011)(7696005)(55016002)(71200400001)(8676002)(83380400001)(8936002)(122000001)(26005)(4326008)(66446008)(64756008)(52536014)(107886003)(2906002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KEkXcILOcsKbfp33zxmdGiEld5UkLBzKXJJ2k29S3z36PRLEcxKJCydb4ASP?=
 =?us-ascii?Q?rDq9a9EgaTdUuR4DEIkU5cM71oABE51iUvhaUaFHS0rn1EtaYKmtjtfpOnLE?=
 =?us-ascii?Q?E+lsDOORn5kobwDi8eeRQq0HwBXbAaLJ+PuQ3DtkcG1duwVS+V90XwRiHEsd?=
 =?us-ascii?Q?bJtMrEn0ikgm3Nd3kz+u79k8mlKqhm5Mm5NgK48cLUwCjEDFNO5wj13jAGiS?=
 =?us-ascii?Q?VOhk5qx7bkxnzJrElrOT0V3raPPJoD9BQerDEjYcAaOlttkNAw8QpM7cj9kc?=
 =?us-ascii?Q?1TvYlzyYCLPr+IqQz/fLd8yBayyLd3+8nlKJT+sgq3pa+qjSOKpl4Fux9mSt?=
 =?us-ascii?Q?3OBtLoWQzVEUcNKTMRNlvCxq3gF298eBemVw0SFzSS0m/Hfnu10FTKzgTMa7?=
 =?us-ascii?Q?Avd5CITdpXjC5AbxAH715rXcaGP/5Zgg1B7MuZo7IlD0j+EpVkvgNYwvIp1q?=
 =?us-ascii?Q?aHZ5e/slU9oYpvFM2NuUBI73zAalV6AzdJC5Y37K4zLScJj6/bKeqHoa/33N?=
 =?us-ascii?Q?ygRCnNHCakO8V3BGA1ppdqwHlkev650FyfHzd7k7vWAH6JNYwAnwSVPn4RND?=
 =?us-ascii?Q?2HybGGGyLVSb9KrddJ/0mgAMmT+uKsEiOo80sXxHBXzHilecV+VBL/UpUQvd?=
 =?us-ascii?Q?oKRS0l5+/AUHfMZIaXNqP/8qwJnTxWU6ETjU+99kzVAA8pRHCA9V6URpnLf+?=
 =?us-ascii?Q?lyCn6esBlbTQoEmjD/I1+M0MZhNh4TQyOCRSLflOWuH6urA8awswjytN6Yyu?=
 =?us-ascii?Q?CKMKn2JaaSwSK0TzsBh4mRf10Nf5W3xmoUxSBZRvQm/h3Z0SdzVxi7SRGetz?=
 =?us-ascii?Q?fU2aTG44N9mj3sFKfmg96SEuQQQnup4Z6W3QPz30L+nnhpHNYikZ71yAEqJD?=
 =?us-ascii?Q?tL66Fek7xvLuOq7DzLR90APncLOyk66meufVKdmfuFnTa6KYsOI93284jCIu?=
 =?us-ascii?Q?hMCceFKH6BKCV5tebQmAix4j9Ud4tNJkYWAtknUtxquNvmNGRy5wLWUbu/3e?=
 =?us-ascii?Q?xww+L/XscO9lmQ0V9PImMsaF+GqYZVSjmok+MGzG8G4iCxW2g+UsgM9tkg/v?=
 =?us-ascii?Q?vuwezYwJmHrsJ5+X2a18Rb61m64syeiWoULDowmrnXaVKuYK+T8O7R7hlJuM?=
 =?us-ascii?Q?VaJMUlr+LcKzKZorCJSwEkQsFOWeYqhTlryJV2LBbYFeG5xzkmCI4ttQQYTR?=
 =?us-ascii?Q?edvI524Gucerq6XliVJlSpcLNLjc1DEnLG1EEImSESPubYNnOpzjnxmvuZQj?=
 =?us-ascii?Q?Os/espZtN+MjEybF6vaXZVIqFvskCvMyskJj7HYGmQRubOdsooss8f9X3UnQ?=
 =?us-ascii?Q?www=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1905bbd-431d-473f-f8a4-08d929c32c35
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 14:47:28.4850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jJqrO0QSDhioraNhGTgFYYeJsgozl5IyjAwHj2gMeaTIwSUoEerVUo7+9jq8xauCWE0JU/Xo7BJOVHHLEnnN0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, June 2, 2021 12:39 AM
> To: David Thompson <davthompson@nvidia.com>
> Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org; Liming
> Sun <limings@nvidia.com>; Asmaa Mnebhi <asmaa@nvidia.com>
> Subject: Re: [PATCH net-next v6] Add Mellanox BlueField Gigabit Ethernet =
driver
>=20
> On Tue, Jun 01, 2021 at 08:24:55AM -0400, David Thompson wrote:
> > This patch adds build and driver logic for the "mlxbf_gige"
> > Ethernet driver from Mellanox Technologies. The second generation
> > BlueField SoC from Mellanox supports an out-of-band GigaBit Ethernet
> > management port to the Arm subsystem.  This driver supports TCP/IP
> > network connectivity for that port, and provides back-end routines to
> > handle basic ethtool requests.
> >
> > The driver interfaces to the Gigabit Ethernet block of BlueField SoC
> > via MMIO accesses to registers, which contain control information or
> > pointers describing transmit and receive resources.  There is a single
> > transmit queue, and the port supports transmit ring sizes of 4 to 256
> > entries.
> > There is a single receive queue, and the port supports receive ring
> > sizes of 32 to 32K entries. The transmit and receive rings are
> > allocated from DMA coherent memory. There is a 16-bit producer and
> > consumer index per ring to denote software ownership and hardware
> > ownership, respectively.
> >
> > The main driver logic such as probe(), remove(), and netdev ops are in
> > "mlxbf_gige_main.c".  Logic in "mlxbf_gige_rx.c"
> > and "mlxbf_gige_tx.c" handles the packet processing for receive and
> > transmit respectively.
> >
> > The logic in "mlxbf_gige_ethtool.c" supports the handling of some
> > basic ethtool requests: get driver info, get ring parameters, get
> > registers, and get statistics.
> >
> > The logic in "mlxbf_gige_mdio.c" is the driver controlling the
> > Mellanox BlueField hardware that interacts with a PHY device via
> > MDIO/MDC pins.  This driver does the following:
> >   - At driver probe time, it configures several BlueField MDIO
> >     parameters such as sample rate, full drive, voltage and MDC
> >   - It defines functions to read and write MDIO registers and
> >     registers the MDIO bus.
> >   - It defines the phy interrupt handler reporting a
> >     link up/down status change
> >   - This driver's probe is invoked from the main driver logic
> >     while the phy interrupt handler is registered in ndo_open.
> >
> > Driver limitations
> >   - Only supports 1Gbps speed
> >   - Only supports GMII protocol
> >   - Supports maximum packet size of 2KB
> >   - Does not support scatter-gather buffering
> >
> > Testing
> >   - Successful build of kernel for ARM64, ARM32, X86_64
> >   - Tested ARM64 build on FastModels & Palladium
> >   - Tested ARM64 build on several Mellanox boards that are built with
> >     the BlueField-2 SoC.  The testing includes coverage in the areas
> >     of networking (e.g. ping, iperf, ifconfig, route), file transfers
> >     (e.g. SCP), and various ethtool options relevant to this driver.
> >
> > v5 -> v6
>=20
> Please put changelog under "---" below your SOBs. We don't need to see th=
is
> history in the git log.
>=20

Sure, will adjust this in the next patch version.

> >   Fixed use of COMPILE_TEST for ARM32 build; changed driver to not
> >   depend on CONFIG_ACPI for ARM32 build
> > v4 -> v5
> >   Created a separate interrupt controller for the GPIO PHY interrupt
> >   and as a result, the GIGE driver no longer depends on GPIO driver
> >   Updated the logic in mlxbf_gige_adjust_link() to store the negotiated
> >   pause settings into the driver's private settings.
> >   Modified logic to only change enable bit in RX_DMA register
> >   Changed logic to only map and unmap the actual length of the TX SKB,
> >   instead using the default size.
> >   Added better error handling to open() method
> >   Modified receive packet logic to use polarity bit to signify ownershi=
p
> >   (software vs. hardware) of the RX CQE slot
> > v3 -> v4
> >   Main driver module broken out into rx, tx, intr, and ethtool modules
> >   Removed some GPIO PHY interrupt logic; moved to GPIO_MLXBF2 driver
> > v2 -> v3
> >   Added logic to handle PHY link up/down interrupts
> >   Use streaming DMA mapping for packet buffers
> >   Changed logic to use standard iopoll methods
> >   Changed PHY logic to not allow C45 transactions
> >   Enhanced the error handling in open() method
> >   Enhanced start_xmit() method to use xmit_more mechanism
> >   Added support for ndo_get_stats64
> >   Removed standard stats from "ethtool -S" output
> > v1 -> v2:
> >   Fixed all warnings raised by "make C=3D1" and "make W=3D1"
> >     a) Changed logic in mlxbf_gige_rx_deinit() and mlxbf_gige_tx_deinit=
()
> >        to initialize relevant pointers as NULL, not 0
> >     b) Change mlxbf_gige_get_mac_rx_filter() to return void,
> >        as this function's return status is not used by caller
> >     c) Fixed type definition of "buff" in mlxbf_gige_get_regs()
> >
> > Signed-off-by: David Thompson <davthompson@nvidia.com>
> > Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> > Reviewed-by: Liming Sun <limings@nvidia.com>
> > ---
>=20
> The patch generates checkpatch warnings.
>=20
>  CHECK: spinlock_t definition without comment
>  #272: FILE: drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h:87:
>  +	spinlock_t lock;
>=20
>  CHECK: spinlock_t definition without comment
>  #273: FILE: drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h:88:
>  +	spinlock_t gpio_lock;
>=20
>  CHECK: Macro argument 'tx_wqe_addr' may be better as '(tx_wqe_addr)' to
> avoid precedence issues
>  #328: FILE: drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h:143:
>  +#define MLXBF_GIGE_TX_WQE_PKT_LEN(tx_wqe_addr) \
>  +	(*(tx_wqe_addr + 1) & MLXBF_GIGE_TX_WQE_PKT_LEN_MASK)
>=20
>  CHECK: multiple assignments should be avoided
>  #1271: FILE:
> drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:374:
>  +	phydev->irq =3D priv->mdiobus->irq[addr] =3D priv->phy_irq;
>=20
> Thanks

Leon,

Thank you for pointing out these checkpatch warnings.
We'll address these in the next patch version.

- Dave
