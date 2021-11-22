Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F064593ED
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbhKVRYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:24:20 -0500
Received: from mail-bn8nam08on2103.outbound.protection.outlook.com ([40.107.100.103]:54785
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237615AbhKVRYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 12:24:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikq3FfhiK2Uy2/JC9n3MICMBDdufXZLYhecPSR7mfzBPOt+03lQRoBTnEq+gi/D32m5W4q+GxGH0bE4lx1iLNTAuwDLT5Qao/yjuaicJsKzCDQW9jxAs3uYEXPsA1NScn9oLcNQrIWXjFYcSfX5fVxuxsoKssEr/HN1XrCoCHjBuytQEBNzX4sVUiVwJnbCkttkONEkuAFwPjNb8nxsbmu61jgSFRUxxcpNc99qCd6pwPh1YvRmKdRYRLwBYRcr6j1XreUJ02VxxMlo1DUTAK6PeMDy+tJQNUcbQRwpietJQz+cU4EN5y2ZFrjC8AjfrnCQvUfjwVHOqqeQa7Vpkvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8gh81uOonjew43cS0vYy8tqAeD2cs8c6u+oyaewbLWE=;
 b=PwoRXr9P1jWf46Rgt2TUUWTgmEHubHwYbj2lWTalBVH08lC0w+HDAB7fdnsF/2cU+J+Z3rmMm3cTXCy1j2fMH51rQ+VtlCGYJ1KNklkVTsSQt8/aHoA61fhPy17j1GIOfkbrTpWWuKong13jjmFCYv8eXUHcDzNWCs0dzxYLJ1tyyOznQSH94MDCuhyVQffBEPNG+CWihE+35k6R892rMR24hYwp+buIWL2w3uobpMg4qQ7prH6eTa4MRHKcmWvc3ghm+N6gH/037rOKazYQ9QuS5m71KVJDKj7L48TmtCR2t2SHhMRwXXViS8SgtDIYlnJ5Hez6dbc3NSvu4fAbIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8gh81uOonjew43cS0vYy8tqAeD2cs8c6u+oyaewbLWE=;
 b=H7p3qpTRs6qIyaySKWHyCgiGVpNncKYzLvFH9rVNGNhFs1MwPxsSR896DL6rYWk3mzw0lUfWxYUticqR71hZZjpU8fugPUg58dpG7C0XBVw2byHwmwOsSrorspQhzE3UwXl7cMjmAcmM1BT3WP6GNENVRsJ0S74xg3J0CIGmbFk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4625.namprd10.prod.outlook.com
 (2603:10b6:303:6d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Mon, 22 Nov
 2021 17:21:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 17:21:08 +0000
Date:   Mon, 22 Nov 2021 09:21:10 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 3/3] net: dsa: ocelot: felix: switch to
 mdio-mscc-miim driver for indirect mdio access
Message-ID: <20211122172110.GD29931@DESKTOP-LAINLKC.localdomain>
References: <20211119213918.2707530-1-colin.foster@in-advantage.com>
 <20211119213918.2707530-4-colin.foster@in-advantage.com>
 <20211121174412.xi4dxw35qrfqyjjv@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121174412.xi4dxw35qrfqyjjv@skbuf>
X-ClientProxiedBy: MW4PR04CA0166.namprd04.prod.outlook.com
 (2603:10b6:303:85::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from DESKTOP-LAINLKC.localdomain (96.93.101.165) by MW4PR04CA0166.namprd04.prod.outlook.com (2603:10b6:303:85::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24 via Frontend Transport; Mon, 22 Nov 2021 17:21:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d695ea9-0669-4eac-b015-08d9addc7899
X-MS-TrafficTypeDiagnostic: CO1PR10MB4625:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4625050A67F02392B5177D07A49F9@CO1PR10MB4625.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /xH52XM0htpRFgXmNmxWTQcipKjNj+bXbWO1DRK8bMMHTlrjQUcwz6N2fs6Iu8Oj89C9UNOCB8HHJ8GAj/sati1ayR3BfVGT53reEgL0Mgt+h0h8MlwxUSi0G05n3ZLaN5i3xHRae9qm4mpp5DLN14J26owyHDgx241Hu6tWamub7/2rcDrkZIDV2ZauA7AcMVZ7jwz7eXdeju3wcCWq1LpDKGwyhH+7mIMblFDGfZv6t98XyWri4c6nZP+NJ0sy3MTXfvWVJpZKwd4dvpF6C756extvyqBjhEMhpTG3wNCB3VDecwUv6MoNCS8mq0apEgOeGjQf5jq6dSRlUXKO8pXvz5VztPiHRXmwPp9O22fMdatwiZYgYs+jJXl7erJvZ70zg2BEOhMWgWNNcX9gcUXtnjc5/sLfg7qnpffuKH5HSmxgmBLiY+sGddhXP3oOaUogsSvtJbMltq1ixC6DsnA77ttizwRahNVQ09P7BdkcCzR/iQvrF8YGi0ShjkmsukXfzd/wShZMXKCZcucLZn0zUMD1DbNluBvJch6qH2S6eb6m0VyofGvKkhgIj2yDIsMoGEKOC4Tm6jpi+AUOdXL9eMsrYvj7xMWGbuST8MaAGz2xfbCs2Z6PkA9A3LjMo/2xOxL7zDyekFRjaO7qCMc5tfoPek9mR5NC2izZhZMy2tHSo0Dm8eMwSjehuJiW23TXHFUarDoBzXwZ2NeBEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39830400003)(346002)(136003)(33656002)(83380400001)(2906002)(508600001)(66946007)(52116002)(6916009)(6666004)(1076003)(5660300002)(30864003)(86362001)(7696005)(6506007)(956004)(7416002)(8936002)(186003)(55016002)(44832011)(54906003)(38100700002)(66556008)(66476007)(38350700002)(8676002)(316002)(4326008)(9686003)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7vIzdQJwXMOHUk5J8+Fc0ta7RvHw3Q4y9X9qofkt5ektD4WS51ocVFwngAIO?=
 =?us-ascii?Q?7rzbbINy9gTjd/OSfSyT2gJpjZWwKAlNNX7gn975pvNYSPSGDr4mBDucWAop?=
 =?us-ascii?Q?tL0Ee/Y6tUbloFIEcrH70DXM37ANIfBkrwJYi6GRo58/BTQAWcfaK+YeDp9e?=
 =?us-ascii?Q?/y3AVllK0VWLYjYwG+bnwSOwI3mzsKpug8u6gfYMTDobEQFNtalmE7HVWwnz?=
 =?us-ascii?Q?LAZTIq2teufK9kikVFeOhg9LVb1m5COcBBRaFYN/bskm8HWC/mWk9eXRKTGj?=
 =?us-ascii?Q?00TSwicwrc0AwRAD0/xNcs8rAq39wBBGgHqqmVf5RbjDlT2+So3XFS7nZ4V9?=
 =?us-ascii?Q?MNGvesVSP42LZ5rg1uZ/3aoveA+6GcLkediU/dwibsKD5lkj/BlESrR4mffh?=
 =?us-ascii?Q?HWWfri+bkcYI8BnKspcQvzRtTD9b2C98gI7TfZhacrnprk1ckyYHIIXJyxs8?=
 =?us-ascii?Q?f34PMIWRpRuOmwA6g7+nwXrd8NshVOi/tqP0I/dW1QGnpMk177NNwz8Tmisx?=
 =?us-ascii?Q?ySVjZ8rn/B7aa5vZWPjbJSt1uP+VtLwR49RYMRux9A8l2NgBVji88cx9ApfW?=
 =?us-ascii?Q?cniSmhFThpXv9dkITDwl2nlNbg76LkntORYF8eceQPb26l/3GeRxufXabc68?=
 =?us-ascii?Q?/L2hbC0Q4regbnrHDUtqFfuIcSgDmkC01/sCAY9jTeYtEUia6Q6xJPjCjatM?=
 =?us-ascii?Q?bceaOzrsH55jNQtayAXUkeiZnxvnXknV2zEAHmP4tquEUkakkBnljRNtwkVK?=
 =?us-ascii?Q?CGRXfqWWdpqs35XYuu57TlcL6f60TNAeOfbNKTq775p38D55KeTiFwtmrSU4?=
 =?us-ascii?Q?6KqNnKExgwG+DjoysDPO5DpCaVq6QAKTjwDneJi7vXHLQwYTfHIL0pL1WEzB?=
 =?us-ascii?Q?nNwW7VBLzaapBLA2fASNvl1HNOyrXNhWlQEwjM4yfHynnwCMNx7rIIVkQS0+?=
 =?us-ascii?Q?23er320glBN1LDWw/Acbe4zIQYl4JPanoftxv+7dAZFJEhsl2vwyIGPdSx1A?=
 =?us-ascii?Q?xJHFuU34qnNgKosYHCyJm9nhGOm4YKNHDohVvSXh2Y1td2roDtrkicYgNCMk?=
 =?us-ascii?Q?oNgM99sm3CKSs8+7nFbGe1xY5/trT8pBaXTHlrPIA5H6Y2IbRM5DNZksDQ9O?=
 =?us-ascii?Q?jg29sMyS7aozACrTSvJaLJTRUjf1G8YbfPBInvq8rLApa/KsLxvThr3UEl7x?=
 =?us-ascii?Q?1thNwcY6gHTVQ+dmuMPVvUNJ7fthjXrfrMjGKTFXJuh6EfwcfQ4hgEercn7J?=
 =?us-ascii?Q?vm7o3Aa8/66j6FekSszK2hUMOJ5NTCvuWXhAs1H7VnvgS3uJAjfVEyjpUc4T?=
 =?us-ascii?Q?4L1Lwj8yzFvYkIUsi+jRZ5n8HHmlx6kIiWtwNQbxXFc+1CNmtsOk5oaHBz89?=
 =?us-ascii?Q?mW520yIhu+Nl3IWZutk3YrVd5QTAr8yiAmfeJaL/roDg3REKRsPO4Qt+K///?=
 =?us-ascii?Q?2Sia0+gaCSmX74Yyi4IQEqaDAeDJD7dWySc067qw72BDFLsPtJseK/j+xYbx?=
 =?us-ascii?Q?ZomW30kUnAV5qM17qlZQ48dtpuh4eIJS2pobwh6vHRvr9dF0/qf5+D4i2HhR?=
 =?us-ascii?Q?BQMvVJtQUTRCpfYMxKK17Jd6jgRRI20+m+hU4d8diRUZnCXfUYBAApk8m3+d?=
 =?us-ascii?Q?V/pef6Foic1IzuH7gw0oXXGA6Kzq8cXRKJ6vaORVbrUYka352MSMCYKJjyju?=
 =?us-ascii?Q?+4HqDUuxeksEhr+uVQayxvQ5CQk=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d695ea9-0669-4eac-b015-08d9addc7899
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 17:21:08.0732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdyNZBYPly3iet5xdkafyh7ojW7HfVX4QHT5e5PoBD4oS2rKd2NM8fZWWRLabOC790dOpNNAmeBQvkr4r6MK3D9cSTvsY6k2DtkYYlN38y4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4625
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 05:44:13PM +0000, Vladimir Oltean wrote:
> On Fri, Nov 19, 2021 at 01:39:18PM -0800, Colin Foster wrote:
> > Switch to a shared MDIO access implementation now provided by
> > drivers/net/mdio/mdio-mscc-miim.c
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/net/dsa/ocelot/Kconfig           |   1 +
> >  drivers/net/dsa/ocelot/Makefile          |   1 +
> >  drivers/net/dsa/ocelot/felix_mdio.c      |  54 ++++++++++++
> >  drivers/net/dsa/ocelot/felix_mdio.h      |  13 +++
> >  drivers/net/dsa/ocelot/seville_vsc9953.c | 108 ++---------------------
> >  drivers/net/mdio/mdio-mscc-miim.c        |  37 ++++++--
> >  include/linux/mdio/mdio-mscc-miim.h      |  19 ++++
> >  include/soc/mscc/ocelot.h                |   1 +
> >  8 files changed, 125 insertions(+), 109 deletions(-)
> >  create mode 100644 drivers/net/dsa/ocelot/felix_mdio.c
> >  create mode 100644 drivers/net/dsa/ocelot/felix_mdio.h
> >  create mode 100644 include/linux/mdio/mdio-mscc-miim.h
> > 
> > diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
> > index 9948544ba1c4..220b0b027b55 100644
> > --- a/drivers/net/dsa/ocelot/Kconfig
> > +++ b/drivers/net/dsa/ocelot/Kconfig
> > @@ -21,6 +21,7 @@ config NET_DSA_MSCC_SEVILLE
> >  	depends on NET_VENDOR_MICROSEMI
> >  	depends on HAS_IOMEM
> >  	depends on PTP_1588_CLOCK_OPTIONAL
> > +	select MDIO_MSCC_MIIM
> >  	select MSCC_OCELOT_SWITCH_LIB
> >  	select NET_DSA_TAG_OCELOT_8021Q
> >  	select NET_DSA_TAG_OCELOT
> > diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
> > index f6dd131e7491..34b9b128efb8 100644
> > --- a/drivers/net/dsa/ocelot/Makefile
> > +++ b/drivers/net/dsa/ocelot/Makefile
> > @@ -8,4 +8,5 @@ mscc_felix-objs := \
> >  
> >  mscc_seville-objs := \
> >  	felix.o \
> > +	felix_mdio.o \
> >  	seville_vsc9953.o
> > diff --git a/drivers/net/dsa/ocelot/felix_mdio.c b/drivers/net/dsa/ocelot/felix_mdio.c
> > new file mode 100644
> > index 000000000000..34375285756b
> > --- /dev/null
> > +++ b/drivers/net/dsa/ocelot/felix_mdio.c
> > @@ -0,0 +1,54 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/* Distributed Switch Architecture VSC9953 driver
> > + * Copyright (C) 2020, Maxim Kochetkov <fido_max@inbox.ru>
> > + * Copyright (C) 2021 Innovative Advantage
> > + */
> > +#include <linux/of_mdio.h>
> > +#include <linux/types.h>
> > +#include <soc/mscc/ocelot.h>
> > +#include <linux/dsa/ocelot.h>
> > +#include <linux/mdio/mdio-mscc-miim.h>
> > +#include "felix.h"
> > +#include "felix_mdio.h"
> > +
> > +int felix_of_mdio_register(struct ocelot *ocelot, struct device_node *np)
> > +{
> > +	struct felix *felix = ocelot_to_felix(ocelot);
> > +	struct device *dev = ocelot->dev;
> > +	int rc;
> > +
> > +	/* Needed in order to initialize the bus mutex lock */
> > +	rc = of_mdiobus_register(felix->imdio, np);
> > +	if (rc < 0) {
> > +		dev_err(dev, "failed to register MDIO bus\n");
> > +		felix->imdio = NULL;
> > +	}
> > +
> > +	return rc;
> > +}
> > +
> > +int felix_mdio_bus_alloc(struct ocelot *ocelot)
> > +{
> > +	struct felix *felix = ocelot_to_felix(ocelot);
> > +	struct device *dev = ocelot->dev;
> > +	struct mii_bus *bus;
> > +	int err;
> > +
> > +	err = mscc_miim_setup(dev, &bus, ocelot->targets[GCB],
> > +			      ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
> > +			      ocelot->targets[GCB],
> > +			      ocelot->map[GCB][GCB_PHY_PHY_CFG & REG_MASK]);
> > +
> > +	if (!err)
> > +		felix->imdio = bus;
> > +
> > +	return err;
> > +}
> 
> I am a little doubtful of the value added by felix_mdio.c, since very
> little is actually common. For example, the T1040 SoC has dpaa-eth
> standalone ports (including the DSA master) and an embedded Seville
> (VSC9953) switch. To access external PHYs connected to the switch, the
> dpaa-eth MDIO bus is used (drivers/net/ethernet/freescale/xgmac_mdio.c).
> The Microsemi MIIM MDIO controller from the Seville switch is used to
> access only the NXP Lynx PCS, which is MDIO-mapped. That's why we put it
> in felix->imdio (i == internal).

I do think some value was lost from felix_mdio.c once I was made aware
of the mscc_mdio_miim.[ch] drivers. Initially I had just pulled out
everything from vsc_9953_mdio_{read,write} into a common place... but
later it just wrapped into mscc_mdio_miim.

> 
> Whereas in your case, the Microsemi MIIM MDIO controller is used to
> actually access the external PHYs. So it won't go in felix->imdio, since
> it's not internal.

It is both actually. What is currently functional is using imdio to
access the internal copper phys to the VSC7512 on ports 0-3. My
understanding is that same bus can be used to access the phys addressed
at 4-7 on the VSC8514.

> 
> (yes, I know that NXP's integration of Vitesse switches is strange, but
> it is what it is).
> 
> So unless I'm missing something, I guess you would be better off leaving
> this code in Seville, and just duplicating minor portions of it (the
> call to mscc_miim_setup) in your vsc7514 driver. What do you think?

I think Seville could be updated to use mscc_mdio_miim, which was done
by way of felix_mdio. Maybe that's a separate patch for Seville alone.
But I have no issue with removing this file and hooking into mdio_miim
directly from the ocelot_spi driver. 

> 
> > +
> > +void felix_mdio_bus_free(struct ocelot *ocelot)
> > +{
> > +	struct felix *felix = ocelot_to_felix(ocelot);
> > +
> > +	if (felix->imdio)
> > +		mdiobus_unregister(felix->imdio);
> > +}
> > diff --git a/drivers/net/dsa/ocelot/felix_mdio.h b/drivers/net/dsa/ocelot/felix_mdio.h
> > new file mode 100644
> > index 000000000000..93286f598c3b
> > --- /dev/null
> > +++ b/drivers/net/dsa/ocelot/felix_mdio.h
> > @@ -0,0 +1,13 @@
> > +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> > +/* Shared code for indirect MDIO access for Felix drivers
> > + *
> > + * Author: Colin Foster <colin.foster@in-advantage.com>
> > + * Copyright (C) 2021 Innovative Advantage
> > + */
> > +#include <linux/of.h>
> > +#include <linux/types.h>
> > +#include <soc/mscc/ocelot.h>
> > +
> > +int felix_mdio_bus_alloc(struct ocelot *ocelot);
> > +int felix_of_mdio_register(struct ocelot *ocelot, struct device_node *np);
> > +void felix_mdio_bus_free(struct ocelot *ocelot);
> > diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> > index db124922c374..dd7ae6a1d843 100644
> > --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> > +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> > @@ -10,15 +10,9 @@
> >  #include <linux/pcs-lynx.h>
> >  #include <linux/dsa/ocelot.h>
> >  #include <linux/iopoll.h>
> > -#include <linux/of_mdio.h>
> >  #include "felix.h"
> > +#include "felix_mdio.h"
> >  
> > -#define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
> > -#define MSCC_MIIM_CMD_OPR_READ			BIT(2)
> > -#define MSCC_MIIM_CMD_WRDATA_SHIFT		4
> > -#define MSCC_MIIM_CMD_REGAD_SHIFT		20
> > -#define MSCC_MIIM_CMD_PHYAD_SHIFT		25
> > -#define MSCC_MIIM_CMD_VLD			BIT(31)
> >  #define VSC9953_VCAP_POLICER_BASE		11
> >  #define VSC9953_VCAP_POLICER_MAX		31
> >  #define VSC9953_VCAP_POLICER_BASE2		120
> > @@ -862,7 +856,6 @@ static struct vcap_props vsc9953_vcap_props[] = {
> >  #define VSC9953_INIT_TIMEOUT			50000
> >  #define VSC9953_GCB_RST_SLEEP			100
> >  #define VSC9953_SYS_RAMINIT_SLEEP		80
> > -#define VCS9953_MII_TIMEOUT			10000
> >  
> >  static int vsc9953_gcb_soft_rst_status(struct ocelot *ocelot)
> >  {
> > @@ -882,82 +875,6 @@ static int vsc9953_sys_ram_init_status(struct ocelot *ocelot)
> >  	return val;
> >  }
> >  
> > -static int vsc9953_gcb_miim_pending_status(struct ocelot *ocelot)
> > -{
> > -	int val;
> > -
> > -	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_PENDING, &val);
> > -
> > -	return val;
> > -}
> > -
> > -static int vsc9953_gcb_miim_busy_status(struct ocelot *ocelot)
> > -{
> > -	int val;
> > -
> > -	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_BUSY, &val);
> > -
> > -	return val;
> > -}
> > -
> > -static int vsc9953_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
> > -			      u16 value)
> > -{
> > -	struct ocelot *ocelot = bus->priv;
> > -	int err, cmd, val;
> > -
> > -	/* Wait while MIIM controller becomes idle */
> > -	err = readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
> > -				 val, !val, 10, VCS9953_MII_TIMEOUT);
> > -	if (err) {
> > -		dev_err(ocelot->dev, "MDIO write: pending timeout\n");
> > -		goto out;
> > -	}
> > -
> > -	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> > -	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> > -	      (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> > -	      MSCC_MIIM_CMD_OPR_WRITE;
> > -
> > -	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
> > -
> > -out:
> > -	return err;
> > -}
> > -
> > -static int vsc9953_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
> > -{
> > -	struct ocelot *ocelot = bus->priv;
> > -	int err, cmd, val;
> > -
> > -	/* Wait until MIIM controller becomes idle */
> > -	err = readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
> > -				 val, !val, 10, VCS9953_MII_TIMEOUT);
> > -	if (err) {
> > -		dev_err(ocelot->dev, "MDIO read: pending timeout\n");
> > -		goto out;
> > -	}
> > -
> > -	/* Write the MIIM COMMAND register */
> > -	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> > -	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ;
> > -
> > -	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
> > -
> > -	/* Wait while read operation via the MIIM controller is in progress */
> > -	err = readx_poll_timeout(vsc9953_gcb_miim_busy_status, ocelot,
> > -				 val, !val, 10, VCS9953_MII_TIMEOUT);
> > -	if (err) {
> > -		dev_err(ocelot->dev, "MDIO read: busy timeout\n");
> > -		goto out;
> > -	}
> > -
> > -	val = ocelot_read(ocelot, GCB_MIIM_MII_DATA);
> > -
> > -	err = val & 0xFFFF;
> > -out:
> > -	return err;
> > -}
> >  
> >  /* CORE_ENA is in SYS:SYSTEM:RESET_CFG
> >   * MEM_INIT is in SYS:SYSTEM:RESET_CFG
> > @@ -1089,7 +1006,6 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
> >  {
> >  	struct felix *felix = ocelot_to_felix(ocelot);
> >  	struct device *dev = ocelot->dev;
> > -	struct mii_bus *bus;
> >  	int port;
> >  	int rc;
> >  
> > @@ -1101,26 +1017,18 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
> >  		return -ENOMEM;
> >  	}
> >  
> > -	bus = devm_mdiobus_alloc(dev);
> > -	if (!bus)
> > -		return -ENOMEM;
> > -
> > -	bus->name = "VSC9953 internal MDIO bus";
> > -	bus->read = vsc9953_mdio_read;
> > -	bus->write = vsc9953_mdio_write;
> > -	bus->parent = dev;
> > -	bus->priv = ocelot;
> > -	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
> > +	rc = felix_mdio_bus_alloc(ocelot);
> > +	if (rc < 0) {
> > +		dev_err(dev, "failed to allocate MDIO bus\n");
> > +		return rc;
> > +	}
> >  
> > -	/* Needed in order to initialize the bus mutex lock */
> > -	rc = of_mdiobus_register(bus, NULL);
> > +	rc = felix_of_mdio_register(ocelot, NULL);
> >  	if (rc < 0) {
> >  		dev_err(dev, "failed to register MDIO bus\n");
> >  		return rc;
> >  	}
> >  
> > -	felix->imdio = bus;
> > -
> >  	for (port = 0; port < felix->info->num_ports; port++) {
> >  		struct ocelot_port *ocelot_port = ocelot->ports[port];
> >  		int addr = port + 4;
> > @@ -1165,7 +1073,7 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
> >  		mdio_device_free(pcs->mdio);
> >  		lynx_pcs_destroy(pcs);
> >  	}
> > -	mdiobus_unregister(felix->imdio);
> > +	felix_mdio_bus_free(ocelot);
> >  }
> >  
> >  static const struct felix_info seville_info_vsc9953 = {
> > diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
> > index f55ad20c28d5..cf3fa7a4459c 100644
> > --- a/drivers/net/mdio/mdio-mscc-miim.c
> > +++ b/drivers/net/mdio/mdio-mscc-miim.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/io.h>
> >  #include <linux/iopoll.h>
> >  #include <linux/kernel.h>
> > +#include <linux/mdio/mdio-mscc-miim.h>
> >  #include <linux/module.h>
> >  #include <linux/of_mdio.h>
> >  #include <linux/phy.h>
> > @@ -37,7 +38,9 @@
> >  
> >  struct mscc_miim_dev {
> >  	struct regmap *regs;
> > +	int mii_status_offset;
> >  	struct regmap *phy_regs;
> > +	int phy_reset_offset;
> >  };
> >  
> >  /* When high resolution timers aren't built-in: we can't use usleep_range() as
> > @@ -56,7 +59,8 @@ static int mscc_miim_status(struct mii_bus *bus)
> >  	struct mscc_miim_dev *miim = bus->priv;
> >  	int val, err;
> >  
> > -	err = regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
> > +	err = regmap_read(miim->regs,
> > +			  MSCC_MIIM_REG_STATUS + miim->mii_status_offset, &val);
> >  	if (err < 0)
> >  		WARN_ONCE(1, "mscc miim status read error %d\n", err);
> >  
> > @@ -91,7 +95,9 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
> >  	if (ret)
> >  		goto out;
> >  
> > -	err = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> > +	err = regmap_write(miim->regs,
> > +			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
> > +			   MSCC_MIIM_CMD_VLD |
> >  			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> >  			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> >  			   MSCC_MIIM_CMD_OPR_READ);
> > @@ -103,7 +109,8 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
> >  	if (ret)
> >  		goto out;
> >  
> > -	err = regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
> > +	err = regmap_read(miim->regs,
> > +			  MSCC_MIIM_REG_DATA + miim->mii_status_offset, &val);
> >  
> >  	if (err < 0)
> >  		WARN_ONCE(1, "mscc miim read data reg error %d\n", err);
> > @@ -128,7 +135,9 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
> >  	if (ret < 0)
> >  		goto out;
> >  
> > -	err = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> > +	err = regmap_write(miim->regs,
> > +			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
> > +			   MSCC_MIIM_CMD_VLD |
> >  			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> >  			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> >  			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> > @@ -143,14 +152,17 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
> >  static int mscc_miim_reset(struct mii_bus *bus)
> >  {
> >  	struct mscc_miim_dev *miim = bus->priv;
> > +	int offset = miim->phy_reset_offset;
> >  	int err;
> >  
> >  	if (miim->phy_regs) {
> > -		err = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
> > +		err = regmap_write(miim->phy_regs,
> > +				   MSCC_PHY_REG_PHY_CFG + offset, 0);
> >  		if (err < 0)
> >  			WARN_ONCE(1, "mscc reset set error %d\n", err);
> >  
> > -		err = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
> > +		err = regmap_write(miim->phy_regs,
> > +				   MSCC_PHY_REG_PHY_CFG + offset, 0x1ff);
> >  		if (err < 0)
> >  			WARN_ONCE(1, "mscc reset clear error %d\n", err);
> >  
> > @@ -166,10 +178,12 @@ static const struct regmap_config mscc_miim_regmap_config = {
> >  	.reg_stride	= 4,
> >  };
> >  
> > -static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
> > -			   struct regmap *mii_regmap, struct regmap *phy_regmap)
> > +int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
> > +		    struct regmap *mii_regmap, int status_offset,
> > +		    struct regmap *phy_regmap, int reset_offset)
> >  {
> >  	struct mscc_miim_dev *miim;
> > +	struct mii_bus *bus;
> >  
> >  	bus = devm_mdiobus_alloc_size(dev, sizeof(*miim));
> >  	if (!bus)
> > @@ -185,10 +199,15 @@ static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
> >  	miim = bus->priv;
> >  
> >  	miim->regs = mii_regmap;
> > +	miim->mii_status_offset = status_offset;
> >  	miim->phy_regs = phy_regmap;
> > +	miim->phy_reset_offset = reset_offset;
> > +
> > +	*pbus = bus;
> >  
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL(mscc_miim_setup);
> >  
> >  static int mscc_miim_probe(struct platform_device *pdev)
> >  {
> > @@ -225,7 +244,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
> >  		return PTR_ERR(dev->phy_regs);
> >  	}
> >  
> > -	mscc_miim_setup(&pdev->dev, bus, mii_regmap, phy_regmap);
> > +	mscc_miim_setup(&pdev->dev, &bus, mii_regmap, 0, phy_regmap, 0);
> >  
> >  	ret = of_mdiobus_register(bus, pdev->dev.of_node);
> >  	if (ret < 0) {
> > diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdio-mscc-miim.h
> > new file mode 100644
> > index 000000000000..3ceab7b6ffc1
> > --- /dev/null
> > +++ b/include/linux/mdio/mdio-mscc-miim.h
> > @@ -0,0 +1,19 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> > +/*
> > + * Driver for the MDIO interface of Microsemi network switches.
> > + *
> > + * Author: Colin Foster <colin.foster@in-advantage.com>
> > + * Copyright (C) 2021 Innovative Advantage
> > + */
> > +#ifndef MDIO_MSCC_MIIM_H
> > +#define MDIO_MSCC_MIIM_H
> > +
> > +#include <linux/device.h>
> > +#include <linux/phy.h>
> > +#include <linux/regmap.h>
> > +
> > +int mscc_miim_setup(struct device *device, struct mii_bus **bus,
> > +		    struct regmap *mii_regmap, int status_offset,
> > +		    struct regmap *phy_regmap, int reset_offset);
> > +
> > +#endif
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 89d17629efe5..9d6fe8ce9dd1 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -398,6 +398,7 @@ enum ocelot_reg {
> >  	GCB_MIIM_MII_STATUS,
> >  	GCB_MIIM_MII_CMD,
> >  	GCB_MIIM_MII_DATA,
> > +	GCB_PHY_PHY_CFG,
> >  	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
> >  	DEV_PORT_MISC,
> >  	DEV_EVENTS,
> > -- 
> > 2.25.1
> >
