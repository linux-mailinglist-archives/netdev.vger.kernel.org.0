Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1868C209C3C
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 11:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403988AbgFYJqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 05:46:22 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:36836
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390576AbgFYJqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 05:46:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uqp80EL44ohLmo9+bWt0m0IKHNDTZP17JrLueFdmNtALBlurZLpi291LZc2ZaJw8x2YdEbTNwcHpot2kMZN8FDsAfaprjCIW3n84a4ujjjfSO3kqCP7pDojNMTf3eUREbgdFCLF1j62v8DmwfgcrQywUCmJF1ec23SBAazgBZuyB1SrVq8d6rJaijiwXAu8nzT2X236cV3gWWVYynVYLtUK278xo4gGcstKaOlTVPdw7yvr/NvDRb7uRDhwSiSTj8HXPG30NR6OL1mIN9mWJaaj8aQ/VPXYGuBQqvNxZqcACuESd8P7zwzQBMAOQlrs5sJR8JMvj9rWqn+j8eerwcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2199VlOq1ZAE5R/dNM7Npqos5uRnP40gD+rPYCJGxI=;
 b=biwVPKzOKCHZdk7tfQGhFWq30v4qFF6R4QRk3Ni9q42ISfGurBRySZEiKuGt4RCgJnl40c1mCjpmxuyC/1wS5ATPcxAgMTwGFKvHuhEWwSgMwH0vBRf+zio7GXSrI7wPMHNERTorP44xUvHSvBdSCMI0XU1yAjpDNU8q0QvjVrHH4AjXU8ZPvd3tpkp6LFB1eai/Jut20cbvFzraFTUzZF6HV7bI5bINFsKxTpeep+DTnsoZAdjKQ49ASJcthtOuZnSbmk7FxtksaRe+Encrr82KWZjIPSFOc+5kqPlyIARyBsKk9ROmBnSeA0otgScS2SpHx216jkTBwympZXHRxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2199VlOq1ZAE5R/dNM7Npqos5uRnP40gD+rPYCJGxI=;
 b=MvRPuB7iV1Fn0/rqXhaRukElZDAwoznVZia57VhxFNXcOeYGI6jtlSR09DdWYHJSBnt5pepC98KERzPCCrnID9io1fpwIv5oHbktX0GLCwmIQX/uM41uOIVK6eWIXNJw49tjNKcco8A7EeKeR1DzYHZEq1kU9ChI2yjrNUzsAi4=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4131.eurprd04.prod.outlook.com (2603:10a6:208:65::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 25 Jun
 2020 09:46:14 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Thu, 25 Jun 2020
 09:46:14 +0000
Date:   Thu, 25 Jun 2020 15:16:06 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux.cj@gmail.com" <linux.cj@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH v1] net: dpaa2-mac: Add ACPI support for DPAA2
 MAC driver
Message-ID: <20200625094606.GA20540@lsv03152.swis.in-blr01.nxp.com>
References: <20200625043538.25464-1-calvin.johnson@oss.nxp.com>
 <VI1PR0402MB3871BFA3098D784FB940759EE0920@VI1PR0402MB3871.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3871BFA3098D784FB940759EE0920@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR01CA0122.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0122.apcprd01.prod.exchangelabs.com (2603:1096:4:40::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Thu, 25 Jun 2020 09:46:11 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5e4ca94d-ace8-4824-8ce6-08d818ec99d8
X-MS-TrafficTypeDiagnostic: AM0PR04MB4131:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB41317196EDF7F249DD6EC92AD2920@AM0PR04MB4131.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nypbkttRt7ROhXT2VqD6zuyq4pNcuJkPl8BDXkkqdqfeRrrx1ypIuRKGWA5PaPKcxFQrw8EzJHHsCiLUtAD/7Xmtjx/xf/Eh1dDzysQxNaShxb6wpEGE5MKoIBNISX5+UXYc/fDHtMX0BAHZWzLE6T/493luKG4scGCcxIaEU8X/E9riShdXTNKGZRm7V5yPNRkBckIc8/fFW6o83fhSh0e91X0198Wx9y4Qj5j/OW8/ceurb+t5LaXi4xoF6zRoqSdse8zHqUKNtM3pM4IlYh8+5NfO93FjITv0M68yBUTRV0k0x9KSaT8LZtjNpxRu5PUoCRPHtJBIoXGCzkr4rKOnaQ03w3tWwvUv4hpWWkQDbwxa73jexv503JTf6JNH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(52116002)(6666004)(26005)(33656002)(6862004)(66476007)(66556008)(478600001)(1006002)(66946007)(186003)(16526019)(1076003)(86362001)(8676002)(5660300002)(6506007)(44832011)(83380400001)(9686003)(7696005)(2906002)(316002)(956004)(55016002)(4326008)(55236004)(8936002)(54906003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ccZU8Xp3fXb+BYA0d5etn5Q9m9C2IuHdIDDNW/UBuQAFORdQGcZatvqvhU88F9Oded9U+Rj7WGXT2ztlqcVI6eccaTKDzJBRmxoE+aAw1SLd1I11EjN1HysOHlPtx3rnJjGMWCy7aWAAo/eCl6jrQJXMDPAF6oj5YkPSpcqA+P7rzXZyRRmo9GmS5YqZ48vFYa5njHLVsxsf2SFHZ4dNrjD9JQqHh6eh1LzEXjYCovKBBp2Jl9n9dXZVgiNBrsvMq7XJHREASKD76mbK7ELKGmfxhyVQwDKthywX6NrjGymYRxtyc/nOZVE0GrHz76SFTOEMWBP0XYl1xr02/bk2yid276kAowIPfw9XgDHmYvS/hdoxxtA4MLIN/uHQtMBHyWJrIGgaQasc1VmsvBctoGvNPVdk4lDbECHpTkmsyoRMhzxSaA8JbKp/X3hMQAEwssZ9aFxo3uUcumiRQ3pFIX+aTL52/8SBQfxzsNJLAmh7SaoRQ8WLooemdk4ZtCNY
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4ca94d-ace8-4824-8ce6-08d818ec99d8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 09:46:14.7288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gq3bEpaKdpZ408Ob4jyhody5IQKAOBmjxsSDEuphoIoPNqvQ/i62/Qt+01Zwpe35FIGgDLsaPvhrLvOYbltN6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

On Thu, Jun 25, 2020 at 07:59:19AM +0000, Ioana Ciornei wrote:
> > Subject: [net-next PATCH v1] net: dpaa2-mac: Add ACPI support for DPAA2 MAC
> > driver
> > 
> > Modify dpaa2_mac_connect() to support ACPI along with DT.
> > Modify dpaa2_mac_get_node() to get the dpmac fwnode from either DT or
> > ACPI.
> > Replace of_get_phy_mode() with fwnode_get_phy_mode() to get phy-mode for
> > a dpmac_node.
> > Define and use helper function dpaa2_find_phy_device() to find phy_dev that is
> > later connected to mac->phylink.
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > 
> > ---
> > 
> >  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 114 +++++++++++++-----
> >  1 file changed, 86 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > index 3ee236c5fc37..163da735ab29 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > @@ -3,6 +3,8 @@
> > 
> >  #include "dpaa2-eth.h"
> >  #include "dpaa2-mac.h"
> > +#include <linux/acpi.h>
> > +#include <linux/platform_device.h>
> > 
> >  #define phylink_to_dpaa2_mac(config) \
> >  	container_of((config), struct dpaa2_mac, phylink_config) @@ -23,38
> > +25,54 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t
> > *if_mode)  }
> > 
> >  /* Caller must call of_node_put on the returned value */ -static struct
> > device_node *dpaa2_mac_get_node(u16 dpmac_id)
> > +static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
> > +						u16 dpmac_id)
> >  {
> > -	struct device_node *dpmacs, *dpmac = NULL;
> > -	u32 id;
> > +	struct fwnode_handle *dpmacs, *dpmac = NULL;
> > +	unsigned long long adr;
> > +	acpi_status status;
> >  	int err;
> > +	u32 id;
> > 
> > -	dpmacs = of_find_node_by_name(NULL, "dpmacs");
> > -	if (!dpmacs)
> > -		return NULL;
> > +	if (is_of_node(dev->parent->fwnode)) {
> > +		dpmacs = device_get_named_child_node(dev->parent,
> > "dpmacs");
> > +		if (!dpmacs)
> > +			return NULL;
> 
> 
> Hi Calvin,
> 
> Unfortunately, this is breaking the OF use case.
> 
> [    4.236045] fsl_dpaa2_eth dpni.0 (unnamed net_device) (uninitialized): No dpmac@17 node found.              
> [    4.245646] fsl_dpaa2_eth dpni.0 (unnamed net_device) (uninitialized): Error connecting to the MAC endpoint 
> [    4.331921] fsl_dpaa2_eth dpni.0: fsl_mc_driver_probe failed: -19                                           
> 
> You replaced of_find_node_by_name() which searches the entire DTS
> file (hence the NULL first parameter) with device_get_named_child_node(dev->parent, ..)
> which only searches starting with the dev->parent device. In this case, the
> parent device is dprc.1 (the root container) which is not probing on the
> device tree so the associated fwnode_handle is NULL.

I had tested with UEFI+net-next tree and didn't encounter any such issue. Let
me see how to resolve this.

Thanks
Calvin
