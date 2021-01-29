Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674B7308608
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhA2Gs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:48:58 -0500
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:45390
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230121AbhA2Gsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 01:48:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRWu21LZa3/7hUuDDxTDUAK+IlzX4EH19SseXVPQbN7Le2uHuc5YhySCmRtUcT4/pxtBYEsC8u0wDtbX2jzGyWRfX88VJeOvaOhQZU2Gp6NPT7OPW8VmfiZajtSLspaviR102+nBQ1NwFXCVKN/MlDmsMkSeGuvT2R6tXeDA5coJ636a/qSsE4EsF0fHORDrceVy78ql7GMkHj6Y1TNecERL5VvdpIoiI3A0h3J3Kv8TBHWpnx69BIzriJ7/H4r0Up8Otpl6TuJDcpj1/CXNcCt/AQgTkYa57yW+f4HXIhCr+nkHaWpNyTrdWVMIPnZ9nrb3/FVE++Xs7kBJiJVaQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7llXigSxwTAOFHTZh8x6XKa7ddBLraBXCCZT3dAN7g=;
 b=alv1vDaNPZYVOZSWchyP1DmzCM1BlZ17BWUCfMKyB6uR+ciMQyitS+v4MbVbX52mwAFTueOKV2kB3juF/7d6QJdKf2Ha86utoPFbiRrGBJ0YK6HXIRHv64oDl4dDHocQjcnHfaGRN+ifduVlNIXrRCbu6DgE+Lxqoa+R30u2KfPYlCo6hoI9T1zk6TfLNRFdZDEHF8Vv/BaN7PW3bA7T8gefCTZERsl9uiqE/1nCAjILoK/n33puG1s3jjNk7MbqQPt5Gf+DRDj1l6kHvgwViGqnd/d0eM/SCNpqZ1DtKTiqqiBxKZ7UvEChMmEYGeb/zSiYPiZbVs9Fg8ataJ462g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7llXigSxwTAOFHTZh8x6XKa7ddBLraBXCCZT3dAN7g=;
 b=ELauXOZUuB2yXI74ZUQYxY7OAhSyxcGu9ZHlX2RgDcMvdU8yTl0wwF0X8FWcXh6Ryk9r9a1xZOatQW8I2x8slzJMi70XItC/QVpMCcopin72tSEpWX6pWo07VLYAj0M4M61OrbKZhTwZyLEAjjGQKa5HAecf+qRNc3MXo3lbZ4M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM9PR04MB7505.eurprd04.prod.outlook.com (2603:10a6:20b:285::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Fri, 29 Jan
 2021 06:48:00 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3805.020; Fri, 29 Jan 2021
 06:47:59 +0000
Date:   Fri, 29 Jan 2021 12:17:39 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [net-next PATCH v4 01/15] Documentation: ACPI: DSD: Document
 MDIO PHY
Message-ID: <20210129064739.GA24267@lsv03152.swis.in-blr01.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-2-calvin.johnson@oss.nxp.com>
 <CAJZ5v0iX3uU36448ALA20hiVk968VKTsvgwLrp8ur96MQo3Acw@mail.gmail.com>
 <20210128112729.GA28413@lsv03152.swis.in-blr01.nxp.com>
 <CAJZ5v0id1i57K_=7eiK0cpOE6UtsKNfR7L7UEBcN1=G+WS+1TA@mail.gmail.com>
 <20210128131205.GA7882@lsv03152.swis.in-blr01.nxp.com>
 <CAJZ5v0j1XVSyFa1q4RZ=FnSmfR5VOyX+u1uWBWdvTOVBJJ-JXw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0j1XVSyFa1q4RZ=FnSmfR5VOyX+u1uWBWdvTOVBJJ-JXw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0117.apcprd02.prod.outlook.com
 (2603:1096:4:92::33) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0117.apcprd02.prod.outlook.com (2603:1096:4:92::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 06:47:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22d75f57-c874-4590-0229-08d8c421d0e6
X-MS-TrafficTypeDiagnostic: AM9PR04MB7505:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB7505218F451C79C6B6123417D2B99@AM9PR04MB7505.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5v3Y9g7BvMLGHJ9EhwFWEoQ1t153jf2jEAaVJacF3C3tx10Pbyqdqh4S8j0Sw9sLjr4U/pbcWg6bWfPINej9giT1r0uAgDmpfzJ1/oWUMAo8L+jYYvtcbjdZKJ1MstBzUCfG5DRt+Jy+MJCEnp3e4i6XIg2UWpYWLphMHWYsvcapyKiEMFlrDMME5zko3g2NLhRvWl8X/wwfatvbWEwKscG5rZXe+/JPCZHRYpM+Y7M9hjv/9ldZry8z030eyODfqAoeoqOh1TT78rShtIBPlmaROwLNDXhiVKZuDVEIW4Li4aXH3uWC3f7nHJKU3EJ0A6aHaN1e8ObPDryhxljcjDDVqRl2F4soKZNOvqsJvjRVvBheoVnShecdpTOM+dF+lsyBiJdcC4w43YCmoV5d6BjLZYsIsH0IvsrDtLQE0m3L2KjeSG5iK03xCQeAIHVcc/fkzKmwWWtnIxuzp/jJkfkna29irV1G2MNpaHQt+6HO8uXQQ6Ev2hJzk8GNw91S5eQvbO1tJdAb+cjjsqi4gJTT+7iOiieysIGMeGck7dyc+LiOOObW0iN3nOfIE+x0s2nLlLSJIkthWDD0TMC17Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(55236004)(6506007)(53546011)(1006002)(6666004)(26005)(6916009)(186003)(16526019)(54906003)(8936002)(33656002)(1076003)(2906002)(956004)(4326008)(7416002)(9686003)(55016002)(5660300002)(44832011)(66476007)(66556008)(7696005)(52116002)(66946007)(478600001)(8676002)(316002)(86362001)(83380400001)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FQyygcWnEFHK2ncKZG88WWo5535OLDGdKrI5V9D2HyOhBejxzyIuBvmuwNHE?=
 =?us-ascii?Q?ovnU/W2jsA95uKd3bpXChUyy2I6hAZXWgBSuvQ+KKwoMaeW59ouqsH7JeeaA?=
 =?us-ascii?Q?Up38WKGiW/kfzUrdUsjILCer+vxBtYmbsU0gb94dg+1RMkENyjyZHZilQR/Q?=
 =?us-ascii?Q?Wl59V7R6LOSmvdnWLcJZm381uRrzV5KppPfnSt0frk4xwghouJTLPiNz6HJ5?=
 =?us-ascii?Q?+TjrFRoBRNBm271iDBj5VrxRGOBa+Jf9rM6NWvtF6KsqKfY/qXZBKTRDKTtI?=
 =?us-ascii?Q?CjEYX5csuk+0db/H12rp1ZPryrNMTJDo6/P5JDYSptXSrsf4khya4P5HTxpg?=
 =?us-ascii?Q?UQhv51EW0ek2b9ookkOmLSOZWMkQUHwll8kLK9tR+4f6lT9oodGyp7UuIxhp?=
 =?us-ascii?Q?/FP1clb6j3SfjoLzVyNzOAIdVh2yW+VNz4TA7qKVf+rkpiDUn+6lguu2g9QH?=
 =?us-ascii?Q?gf7RM+9A8LXAkZCVRee1x/uI0pq6V5UpN8O9ww3mcSS3C5ferRHssG7uJbmO?=
 =?us-ascii?Q?TBiLUmfpXtWsMaiHX/SoiZA+KRdrji9yYqEpT4y3eGp0HIHOdyZMajo3gVEp?=
 =?us-ascii?Q?RQW4o2EEUSFafHZB6PJooJHU1R2Qe3PQ2MLvnFq9dBNCm4aFMcREbe3P/s0X?=
 =?us-ascii?Q?7hOjMo8l1XPpw+yH6YWWCGJVVpvVnXqsWonLeLvwzoswDcOuKFuNNF2PriMy?=
 =?us-ascii?Q?GMGkljOlyWaHx0nAD7vB6i/aonSS6zhuIK9Z7zTGu8wueTlQgkgMgPa4VgQ2?=
 =?us-ascii?Q?uubquI+V1nZStxxwwERh9FoTxzbxkpguAyzQPNt6hKvkYOzHKRJqBHRQmijD?=
 =?us-ascii?Q?bN9htWxScOMNtaMHKf4xPqIkIN2TjMczXeyuZHn30B7emL7NMJNmPv/Hyen2?=
 =?us-ascii?Q?lYG0F/auYvZJDOln6tOMwQ4YFQ5MN2I5LDMyVvB70fatPLMRZbnPZvJZPs0M?=
 =?us-ascii?Q?FOWzCnLv/JEXcnYbcLJimkdIBSaTEfyezjKSwHkkfbpoXFmS+3B34OqlSjoP?=
 =?us-ascii?Q?OQB2hknYGxld/Qtu8kTeWK9huDZYtN+zZRR+viXYX4oFhuAr9d/XsudRJnS/?=
 =?us-ascii?Q?NpohkIMhEHQF3h8LEXo6UHumWWyHlg=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d75f57-c874-4590-0229-08d8c421d0e6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 06:47:59.9279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IOLQTFIRZadu4EYZinxOfRNgqvKFQQnc9OhVD3yRPRybW59jst1rOUC7E2lkKW/aEIqp1ToSZ6av352Maycl4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7505
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 02:27:00PM +0100, Rafael J. Wysocki wrote:
> On Thu, Jan 28, 2021 at 2:12 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > On Thu, Jan 28, 2021 at 01:00:40PM +0100, Rafael J. Wysocki wrote:
> > > On Thu, Jan 28, 2021 at 12:27 PM Calvin Johnson
> > > <calvin.johnson@oss.nxp.com> wrote:
> > > >
> > > > Hi Rafael,
> > > >
> > > > Thanks for the review. I'll work on all the comments.
> > > >
> > > > On Fri, Jan 22, 2021 at 08:22:21PM +0100, Rafael J. Wysocki wrote:
> > > > > On Fri, Jan 22, 2021 at 4:43 PM Calvin Johnson
> > > > > <calvin.johnson@oss.nxp.com> wrote:
> > > > > >
> > > > > > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > > > > > provide them to be connected to MAC.
> > > > > >
> > > > > > Describe properties "phy-handle" and "phy-mode".
> > > > > >
> > > > > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > > > > > ---
> > > > > >
> > > > > > Changes in v4:
> > > > > > - More cleanup
> > > > >
> > > > > This looks much better that the previous versions IMV, some nits below.
> > > > >
> > > > > > Changes in v3: None
> > > > > > Changes in v2:
> > > > > > - Updated with more description in document
> > > > > >
> > > > > >  Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
> > > > > >  1 file changed, 129 insertions(+)
> > > > > >  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > > >
> > > > > > diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > > > new file mode 100644
> > > > > > index 000000000000..76fca994bc99
> > > > > > --- /dev/null
> > > > > > +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > > > @@ -0,0 +1,129 @@
> > > > > > +.. SPDX-License-Identifier: GPL-2.0
> > > > > > +
> > > > > > +=========================
> > > > > > +MDIO bus and PHYs in ACPI
> > > > > > +=========================
> > > > > > +
> > > > > > +The PHYs on an MDIO bus [1] are probed and registered using
> > > > > > +fwnode_mdiobus_register_phy().
> > > > >
> > > > > Empty line here, please.
> > > > >
> > > > > > +Later, for connecting these PHYs to MAC, the PHYs registered on the
> > > > > > +MDIO bus have to be referenced.
> > > > > > +
> > > > > > +The UUID given below should be used as mentioned in the "Device Properties
> > > > > > +UUID For _DSD" [2] document.
> > > > > > +   - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> > > > >
> > > > > I would drop the above paragraph.
> > > > >
> > > > > > +
> > > > > > +This document introduces two _DSD properties that are to be used
> > > > > > +for PHYs on the MDIO bus.[3]
> > > > >
> > > > > I'd say "for connecting PHYs on the MDIO bus [3] to the MAC layer."
> > > > > above and add the following here:
> > > > >
> > > > > "These properties are defined in accordance with the "Device
> > > > > Properties UUID For _DSD" [2] document and the
> > > > > daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
> > > > > Data Descriptors containing them."
> > > > >
> > > > > > +
> > > > > > +phy-handle
> > > > > > +----------
> > > > > > +For each MAC node, a device property "phy-handle" is used to reference
> > > > > > +the PHY that is registered on an MDIO bus. This is mandatory for
> > > > > > +network interfaces that have PHYs connected to MAC via MDIO bus.
> > > > > > +
> > > > > > +During the MDIO bus driver initialization, PHYs on this bus are probed
> > > > > > +using the _ADR object as shown below and are registered on the MDIO bus.
> > > > >
> > > > > Do you want to mention the "reg" property here?  I think it would be
> > > > > useful to do that.
> > > >
> > > > No. I think we should adhere to _ADR in MDIO case. The "reg" property for ACPI
> > > > may be useful for other use cases that Andy is aware of.
> > >
> > > The code should reflect this, then.  I mean it sounds like you want to
> > > check the "reg" property only if this is a non-ACPI node.
> >
> > Right. For MDIO case, that is what is required.
> > "reg" for DT and "_ADR" for ACPI.
> >
> > However, Andy pointed out [1] that ACPI nodes can also hold reg property and
> > therefore, fwnode_get_id() need to be capable to handling that situation as
> > well.
> 
> No, please don't confuse those two things.
> 
> Yes, ACPI nodes can also hold a "reg" property, but the meaning of it
> depends on the binding which is exactly my point: _ADR is not a
> fallback replacement for "reg" in general and it is not so for MDIO
> too.  The new function as proposed doesn't match the MDIO requirements
> and so it should not be used for MDIO.
> 
> For MDIO, the exact flow mentioned above needs to be implemented (and
> if someone wants to use it for their use case too, fine).
> 
> Otherwise the code wouldn't match the documentation.

In that case, is this good?

/**
 * fwnode_get_local_addr - Get the local address of fwnode.
 * @fwnode: firmware node
 * @addr: addr value contained in the fwnode
 *
 * For DT, retrieve the value of the "reg" property for @fwnode.
 *
 * In the ACPI case, evaluate the _ADR object located under the
 * given node, if present, and provide its return value to the
 * caller.
 *
 * Return 0 on success or a negative error code.
 */
int fwnode_get_local_addr(struct fwnode_handle *fwnode, u32 *addr)
{
	int ret;

	if (is_of_node(fwnode))
		return of_property_read_u32(to_of_node(fwnode), "reg", addr);

#ifdef CONFIG_ACPI
	if (is_acpi_node(fwnode)) {
		unsigned long long adr;
		acpi_status status;

		status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
					       METHOD_NAME__ADR, NULL, &adr);
		if (ACPI_FAILURE(status))
			return -ENODATA;
		*addr = (u32)adr;
		return 0;
	}
#endif
	return -EINVAL;
}
