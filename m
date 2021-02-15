Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A2731B955
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 13:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhBOMe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 07:34:26 -0500
Received: from mail-am6eur05on2061.outbound.protection.outlook.com ([40.107.22.61]:46208
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229652AbhBOMeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 07:34:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJkr8el+tsK7+Kvkyfl3PCnwMdZCt6cJcXqkj8WdHKKVKpNJPr2ciWrg99Ag4alZz/8FCPP1BXtDv8T/lgtjTSd09IYj5TWnry0l6iObB/MCEVvsv8VYtyEjvRGDZRnZsFz4I7qn49cMAAX8t+4oOcV4JtMl16MukCev5+OjcfNezJzT2RBWfpMLT5LVPBkN1CLZOlruuyFLoQnrt7zba4y1FTSIyNFjXzBArvKEd5L7miu15SauYuYS/YQoxaysA7El/r6oO3QnzPzH5+Qpq/2NB+LhPgAeKk/dYYReFqHsTPddEte96vYfByoi3fAApyTVr7tGMB9RWaBzIWuSTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p26gYdlFWpDSUEZJiaReevvAvYAda7mxD2GRMVux/mY=;
 b=KC8wEqdoIX0zw23jAk0uf7dqQPyQjyfdNWxo5FN3cnc9n0gh9Amym/S3Y9flJR3njHoYGkqrwIi1JIoxAIEziKBlg9eauSgVmax1XvcdnoVu5pZUrL2vQY/4DG5TLSSZr/5gU74Rok05cCUsoBGPduTnR3zR1lfnRVvv0Jsc79rESCrVxGXzCyyFk8Ep8vTua4d7hTfj6KoLj3D6hd8Sz/mNMfNSBUaMQkch2NYQf+wY4VRblT0OSr2E5uKop+pJpAwUb2XRJ9uHd7gxixZmKdlXdRiKnbdtCZ/hluApe6lcr+X/WY3ODseKx06i5Wa8rOp71IalYcv6MG7OXk67XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p26gYdlFWpDSUEZJiaReevvAvYAda7mxD2GRMVux/mY=;
 b=WOBi4o//M7dkvuk4NKgUjlME1rXoNntXj6LwInVaGBySvfqX5xvr5AY+UdC20krl9nrC/jDwQx1d+IqgeT+nvNnxH4UjChQFQ1tv0YmkItVmr2KJrSb4b8tIZFMB1wEdjsmucKM7ppoC5UD1ZxOQm49ZhHNnlw8jfo3iGegKYu0=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4594.eurprd04.prod.outlook.com (2603:10a6:208:74::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.39; Mon, 15 Feb
 2021 12:33:31 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Mon, 15 Feb 2021
 12:33:31 +0000
Date:   Mon, 15 Feb 2021 18:03:09 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v5 15/15] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Message-ID: <20210215123309.GA5067@lsv03152.swis.in-blr01.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-16-calvin.johnson@oss.nxp.com>
 <20210208162831.GM1463@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208162831.GM1463@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0167.apcprd04.prod.outlook.com (2603:1096:4::29)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0167.apcprd04.prod.outlook.com (2603:1096:4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Mon, 15 Feb 2021 12:33:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8e0fd77b-5d39-4869-6bc6-08d8d1ade730
X-MS-TrafficTypeDiagnostic: AM0PR04MB4594:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4594B3A0268C29779B19F4B9D2889@AM0PR04MB4594.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZRPXBpva7wf89nx54nC6uCFcaXoztZhJNq27ujclfrXxrgBN4qLGkjbZNX4CNWK8SrAnVhQzqsAczLcAiOyOILLveEkTuc7pxh2YWa2RoTY3oiamb3zxp4QfputWByJ3RSMHXzwH/O6Ctgw4vCM3HHFZlCS4B8MLNA98529nVRH9FNLjJsVc60NlHRClmbMWIMoU6q5CnJGN87sz/dU8JMMw0kyu13uSRZHubg0tXrkYrwnTXdYANTkzWTf0HEpu9ICqVzEej6z+Qli5yfASsQt24VTYvShptYGVgQNXh7dmDU7Rbab/TGHks+6LxyBEbu7+u5dccUT7f8XXVkwyATQj6Ky0bg5W+vx06cbunD1V1OoC99YmGlFMI93KkLT3S6PUByP8dYnXqlNYRFc++fv+a6WXpBU2SzaqjqBpQaBmAfoIQCLRT1eINOE4plk4C3sHzk0T91hE3BZ/LKBjiVO6cMNvjupwTErppUJdYFPTEJ9YlaJ8DH+npyTbIvz+COQlTIO7M7azN0mhGpqwUamkyz3PaIx5BUVrAKrp3NurwLlRQmK33LWJ65TwJ0RV7wLAlbG8m5i6583+2ulo8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(8936002)(6506007)(7696005)(52116002)(55016002)(2906002)(8676002)(478600001)(956004)(6916009)(54906003)(44832011)(26005)(186003)(83380400001)(16526019)(4326008)(316002)(86362001)(5660300002)(1006002)(6666004)(66946007)(66476007)(7416002)(9686003)(66556008)(55236004)(33656002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IEp49oU2V+uUbIYYHXucko43aHOVsXY/I8PDMUk8e00aZW4dCM0IxFmMurLN?=
 =?us-ascii?Q?W6Mq0W74klrFDhZ5ZqPzsGfqDhzSB9K3mnv1bc7efi5Jmq0uMIep469P3i9Z?=
 =?us-ascii?Q?p9jcr/k3rK/3Sbif601VZG1ubZzQhb8HVaDmpUNkY+tiR3PERwzLbTspwwWF?=
 =?us-ascii?Q?RR/D9Cqi/hbvot1Xeo8aJ4L9daEIrjnUrUzfbDF9pRk/XpoQuac5BIPmR6rk?=
 =?us-ascii?Q?O3acsYq9HfG9oxhyS0vEnwkvYNIZ7E/WbuvNQI1IE0aL9j/ZdPF9K64cF0YH?=
 =?us-ascii?Q?T4O5ziJNDcM4fT5UrOcD67HFrwVXvVjtf+67chaHlZVi/OfXqQWaW4jIEU6b?=
 =?us-ascii?Q?P/BQwugpQiQ3cWSwK3QtTpMLxiY77nA1xsxhKlQioFLXxYLx4oJdMvis6aom?=
 =?us-ascii?Q?4j2h+QwpbNr7LNTcUhkxfiqCKBfodaPhJPhYGf2X2YVEfXRA0NOsLJ6vk5PJ?=
 =?us-ascii?Q?1wtWUcaxyHYq9RNuoxZv+uvce96A0DWMW+7d3amkp7cJZDZC4xiQbZeKc0xU?=
 =?us-ascii?Q?NH/k5AI2wMbznZTsNMX/GWCeKIoFXQT9wD15W+SVFM3Fw1Ek7HQcti4Km8ZV?=
 =?us-ascii?Q?foae/x2ktGUYHuFZtyXC6Om3eYSdlnL7R4V/YBtRZ+rioaPVwpvvksTe1kVF?=
 =?us-ascii?Q?EAdE13tLnY/y9WFkNyHEJNtcEGDqP3T7hJCjmRywALnzHkUaV3g9eNQH8q8j?=
 =?us-ascii?Q?dELw3w/trWf9ey3IO4GZ03jBvlMV7Di7ceTr0EOESKZAGachmq0GMn637TJV?=
 =?us-ascii?Q?NOnzxu73+GMx50eq4PiJWw9HQpdOvJWf1gOutBHxpRFx/vpwGqBLdOfVUSdD?=
 =?us-ascii?Q?zb0bJwU+LWfkpghf/IpGEPvwqac4S6g2O1SFQ46busNLTgWufLgzRXU7Ic5D?=
 =?us-ascii?Q?n1/CqTGGLdS225IO1NXv9OEsAADGIZc78bSrS3UhaHT52TVw0nOkJJBkUm5S?=
 =?us-ascii?Q?vbH6o+YC4sjV5mLDD9zUJbrTvxIanloHqV1BATLKHsWM5iVijSA1P1tlcKZs?=
 =?us-ascii?Q?lwvIflIaiZ9oheqlW4VslQUhvxaEwCG/gjyTZBpsFXg12y4uetWQ3IHMXvws?=
 =?us-ascii?Q?80CnYNwksanC/9c2lDcxHlgNTBAGoJeuS4zcy2WOh3G9KfVtsw1Cz1MGFj57?=
 =?us-ascii?Q?LLPw8nifwALDecdHaS/1VkmFfJga9lG9JMRJLDsHCsQ+A81pPY7YSKys/SY7?=
 =?us-ascii?Q?gxlAHjRr+oGCKq/sE2fkKf4G6FVMa73Ka6uQdGWjX5ZUzX2DyOR+4U2idGDK?=
 =?us-ascii?Q?b6ss7phgGvWch0mbaTNsp0HeCUR1RbjWjW0/QGJXhvsrnykidtaU0q5DyqL6?=
 =?us-ascii?Q?mwBAxT18RVenIpFV+q0altuP?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0fd77b-5d39-4869-6bc6-08d8d1ade730
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2021 12:33:31.4770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wdps6zMvu7ta+6OKFQFzIjYtemtHdlaAp+hFYjKOpMRfHICOySkiLcQQLokhVhB7F38HpIXSdq+PKBUD+gazfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4594
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 04:28:31PM +0000, Russell King - ARM Linux admin wrote:
> On Mon, Feb 08, 2021 at 08:42:44PM +0530, Calvin Johnson wrote:
> > Modify dpaa2_mac_connect() to support ACPI along with DT.
> > Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
> > DT or ACPI.
> > 
> > Replace of_get_phy_mode with fwnode_get_phy_mode to get
> > phy-mode for a dpmac_node.
> > 
> > Use helper function phylink_fwnode_phy_connect() to find phy_dev and
> > connect to mac->phylink.
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> I don't think this does the full job.
> 
> >  static int dpaa2_pcs_create(struct dpaa2_mac *mac,
> > -			    struct device_node *dpmac_node, int id)
> > +			    struct fwnode_handle *dpmac_node,
> > +			    int id)
> >  {
> >  	struct mdio_device *mdiodev;
> > -	struct device_node *node;
> > +	struct fwnode_handle *node;
> >  
> > -	node = of_parse_phandle(dpmac_node, "pcs-handle", 0);
> > -	if (!node) {
> > +	node = fwnode_find_reference(dpmac_node, "pcs-handle", 0);
> > +	if (IS_ERR(node)) {
> >  		/* do not error out on old DTS files */
> >  		netdev_warn(mac->net_dev, "pcs-handle node not found\n");
> >  		return 0;
> >  	}
> >  
> > -	if (!of_device_is_available(node)) {
> > +	if (!of_device_is_available(to_of_node(node))) {
> 
> If "node" is an ACPI node, then to_of_node() returns NULL, and
> of_device_is_available(NULL) is false. So, if we're using ACPI
> and we enter this path, we will always hit the error below:
> 
> >  		netdev_err(mac->net_dev, "pcs-handle node not available\n");
> > -		of_node_put(node);
> > +		of_node_put(to_of_node(node));
> >  		return -ENODEV;
> >  	}
> 
> > @@ -306,7 +321,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
> >  	 * error out if the interface mode requests them and there is no PHY
> >  	 * to act upon them
> >  	 */
> > -	if (of_phy_is_fixed_link(dpmac_node) &&
> > +	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
> 
> If "dpmac_node" is an ACPI node, to_of_node() will return NULL, and
> of_phy_is_fixed_link() will oops.

I think of_phy_is_fixed_link() needs to be fixed. I'll add below fix.

--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -439,6 +439,9 @@ bool of_phy_is_fixed_link(struct device_node *np)
        int len, err;
        const char *managed;

+       if (!np)
+               return false;
+
        /* New binding */
        dn = of_get_child_by_name(np, "fixed-link");
        if (dn) {

Regards
Calvin
