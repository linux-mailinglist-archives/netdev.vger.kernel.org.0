Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6992F2825A8
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 19:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgJCRkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 13:40:09 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:19442
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725797AbgJCRkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 13:40:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Waw10yU4OykWzh7NvhDheyaApDanZs/0WD37MntDkWZ5hZ/4CoNDxlHBKWVKN2b3LAH3T82g/IziFkRM4h2UfNI/Q8XpH7ca6pOl0YI3UoPrhAOubolSjCe8+ir2HwQLwos/9AKd07SGp6IJ6FB/mM7jStUK9cGtWPUeyF7mwoy6g/G5654/fiNYJ4MB8HlE9SLiDwnmpNmgVH+QIMJvIV4VIyKqaxgX7ExTLdp30jgsdcZ5FE+A//sXjgcKWod4UfPq/Qi44hNfK9b7p0rnq8juYczEmyjQSkrk/k3VLrPeODKCCNFXWL2MhoUfoH+NXzfcmgOOV8c8HWGLh8Aw4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umAKKaj+CjHC49LORbqBH0T83PJJ6I0rVNsJNsNNsB4=;
 b=IS750C6ca/aX102ao9merYJRe2GEkeJnbHxkWBxftSmhY0sCuReCaQaGwzi+xiCogVyGRvYbitg2F3tq88s2H9z2Y+aHAyBGZFbzCWLIT/RzZ1o6M2EnNxn3IxRE6ixwdOz3Dg9SMs12GZOzeD7Ukg+tGZjidtNK45HJJQUFFUXqALm2QqwtL4HBVv3ebbGhfjRmVB16qIVLMInzy/CNFdlRsDg4ngi3bKY4Y28VERq2Igf3kXGv8hKD4pfKpF4H/lFFyNQBXDSeN2nCijSrPGq/DLLrrrdAsP9o6oZ8DMLH+4IznX20uG7duuObbOQDNg0srB8ArGLjaPlbLrdcUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umAKKaj+CjHC49LORbqBH0T83PJJ6I0rVNsJNsNNsB4=;
 b=g/HkozTaca8uCe/DK1/4TaHRjLr8AQ3DP8kq0D8wLCBf1WCpwWVyFSsoh/eQSix2SzYdvXC0eRL/wGrbAD84SEQLmY/YjYLn2Jf/wLkIqW2v9/crJ6axdQuNFBL2mpLkIavuPyvXLw+QQ1SOgTZgm4ZfxajCPvxeYJYOJCSmvfk=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM6PR04MB5638.eurprd04.prod.outlook.com (2603:10a6:20b:a6::18)
 by AM6PR04MB4581.eurprd04.prod.outlook.com (2603:10a6:20b:26::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.26; Sat, 3 Oct
 2020 17:40:03 +0000
Received: from AM6PR04MB5638.eurprd04.prod.outlook.com
 ([fe80::7c30:475e:de70:9c22]) by AM6PR04MB5638.eurprd04.prod.outlook.com
 ([fe80::7c30:475e:de70:9c22%6]) with mapi id 15.20.3433.039; Sat, 3 Oct 2020
 17:40:03 +0000
Date:   Sat, 3 Oct 2020 23:09:49 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
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
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v1 6/7] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Message-ID: <20201003173949.GB28093@lsv03152.swis.in-blr01.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-7-calvin.johnson@oss.nxp.com>
 <0e433de7-f569-0373-59a7-16f2999902d4@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e433de7-f569-0373-59a7-16f2999902d4@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR01CA0136.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::16) To AM6PR04MB5638.eurprd04.prod.outlook.com
 (2603:10a6:20b:a6::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0136.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Sat, 3 Oct 2020 17:39:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ac9442e5-a465-43dd-cb3d-08d867c35b51
X-MS-TrafficTypeDiagnostic: AM6PR04MB4581:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB45813C0091E289EA37E6F385D20E0@AM6PR04MB4581.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SN4apIlqDE4w7uf9yfM+djbbGE5U9I01wyLA6Gc+K1k0Q4QZeFUtB5LLdtah1mKjes0mcM00Sn3qg89VP15ZtRjP5p3oxtQkec5g16CxgrJs+lVTfSARhL6xRQWtZETZ7ldWlLI7BOLizNaWnh8VNecDg5SbRskzCBZkl1IDgbUEpEneJ/3FzL5Kbb/h9hHX8Gb51rM+HsWDidKecQBirhqpMUl4DgkdvPtKFCcqLBl2/8pthCs2lT0JhPCISoSi6veq2+g2grBGKjsgtUKJOKSuJ7NN1T+DaEbYkVKK7Uf8p6dKym5h0utEZnE4ta16djmFxWvyvxwR8rMyCyTa6wU5dnRSTX6OdbKqoR24Zsxm3nyR4S0meLZ+iEkKXjJC4ptTlZuHJKG1YX/IH8pFum9wG3L+55b1osAtOFVzC+A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5638.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(396003)(39850400004)(86362001)(33656002)(6916009)(2906002)(53546011)(6506007)(52116002)(54906003)(7696005)(316002)(66946007)(66476007)(66556008)(26005)(956004)(4326008)(1076003)(8676002)(5660300002)(1006002)(8936002)(6666004)(478600001)(186003)(16526019)(7416002)(9686003)(55016002)(55236004)(44832011)(83380400001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Nqyn813a7UDL1Dk3wD2XDyG01xCM2AQwkRdlK899w+UxXqpobhygKEJohElXrxbqmqvjV803AA3d8FCZSVAX9z1htNUnYbBUtwO+vVHj1VSOGQoHLXL2JTm4NM4jFfx6Y9X54FXUaGQnKwg+qzYjeHIEKzUbgVLaBilmwliNiuZ2SBzY/z8m1kv6+7yUwt/VbFoLStA4Z5XoORjd+on370W13mZCdeAISVNCZZWBGPbVm0zv3KK1CKHdu5G5GUdL3Zi3trk48O2Ry3gdwEWzc95TSiZNcNUqhExEvaVKR6mOWcFUb9k+rZvlLDdf6PB91cMtLDOkE9C+8AVl46qGyN5b5N/Yz9C7xFNAm7qN75kbCt7mJIYPiuHD/Q43JZ5gqtuG766WndPL2GrV2fvwgkWAWJz4Yk0lVJg1CV9x7kmQ0DBZQpxwq9xcVqSzspHJhztz2djPNiXGZqCAcmnbmZBJD2/ETnZFoVLZqdHxRv//+eZ7lAGSOGJtNMKulcGJliGG0uTEUEOkMGeqcK5gFX2tlbVGFwPVbly5Xw9fZZLPBXr/mNZT0mnwVaCg7o6U15zG1Djn/KrWYByLpb67yhgl5DWuO2nRZjSDelYQIffhZXVT8JHGGFT7Xg6FRZv9VEjO/Ck+gdTBM/32JFguqA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9442e5-a465-43dd-cb3d-08d867c35b51
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5638.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 17:40:03.2169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2uXm2wVruDqlUgkMMK04fasrYkTMyfIFKJ3QMtioaQlyYmzlV3rSlS2os3mlWRvFW2TXt0OreQszjq0WLbOBSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4581
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Grant,

On Fri, Oct 02, 2020 at 12:22:37PM +0100, Grant Likely wrote:
> 
> 
> On 30/09/2020 17:04, Calvin Johnson wrote:
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
> > ---
> > 
> >   .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 79 ++++++++++++-------
> >   1 file changed, 50 insertions(+), 29 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > index 90cd243070d7..18502ee83e46 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > @@ -3,6 +3,7 @@
> >   #include "dpaa2-eth.h"
> >   #include "dpaa2-mac.h"
> > +#include <linux/acpi.h>
> >   #define phylink_to_dpaa2_mac(config) \
> >   	container_of((config), struct dpaa2_mac, phylink_config)
> > @@ -35,38 +36,56 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
> >   }
> >   /* Caller must call of_node_put on the returned value */
> > -static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
> > +static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
> > +						u16 dpmac_id)
> >   {
> > -	struct device_node *dpmacs, *dpmac = NULL;
> > -	u32 id;
> > +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> > +	struct fwnode_handle *dpmacs, *dpmac = NULL;
> > +	unsigned long long adr;
> > +	acpi_status status;
> >   	int err;
> > +	u32 id;
> > -	dpmacs = of_find_node_by_name(NULL, "dpmacs");
> > -	if (!dpmacs)
> > -		return NULL;
> > +	if (is_of_node(dev->parent->fwnode)) {
> > +		dpmacs = device_get_named_child_node(dev->parent, "dpmacs");
> > +		if (!dpmacs)
> > +			return NULL;
> > +
> > +		while ((dpmac = fwnode_get_next_child_node(dpmacs, dpmac))) {
> > +			err = fwnode_property_read_u32(dpmac, "reg", &id);
> > +			if (err)
> > +				continue;
> > +			if (id == dpmac_id)
> > +				return dpmac;
> > +		}
> There is a change of behaviour here that isn't described in the patch
> description, so I'm having trouble following the intent. The original code
> searches the tree for a node named "dpmacs", but the new code constrains the
> search to just the parent device.
> 
> Also, because the new code path is only used in the DT case, I don't see why
> the behaviour change is required. If it is a bug fix, it should be broken
> out into a separate patch. If it is something else, can you describe what
> the reasoning is?

Yes, the behaviour for ACPI had to be changed as I couldn't find an ACPI method
to find named nodes. I did this change some time back and it didn't work for
ACPI. I'll revisit this once again and keep original code if needed.
Behaviour for DT hasn't changed although the APIs changed.

> 
> I also see that the change to the code has dropped the of_node_put() on the
> exit path.

Sure, I'll fix it.
> 
> > -	while ((dpmac = of_get_next_child(dpmacs, dpmac)) != NULL) {
> > -		err = of_property_read_u32(dpmac, "reg", &id);
> > -		if (err)
> > -			continue;
> > -		if (id == dpmac_id)
> > -			break;
> > +	} else if (is_acpi_node(dev->parent->fwnode)) {
> > +		device_for_each_child_node(dev->parent, dpmac) {
> > +			status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(dpmac),
> > +						       "_ADR", NULL, &adr);
> > +			if (ACPI_FAILURE(status)) {
> > +				pr_debug("_ADR returned %d on %s\n",
> > +					 status, (char *)buffer.pointer);
> > +				continue;
> > +			} else {
> > +				id = (u32)adr;
> > +				if (id == dpmac_id)
> > +					return dpmac;
> > +			}
> > +		}
> >   	}
> > -
> > -	of_node_put(dpmacs);
> > -
> > -	return dpmac;
> > +	return NULL;
> >   }
> > -static int dpaa2_mac_get_if_mode(struct device_node *node,
> > +static int dpaa2_mac_get_if_mode(struct fwnode_handle *dpmac_node,
> >   				 struct dpmac_attr attr)
> >   {
> >   	phy_interface_t if_mode;
> >   	int err;
> > -	err = of_get_phy_mode(node, &if_mode);
> > -	if (!err)
> > -		return if_mode;
> > +	err = fwnode_get_phy_mode(dpmac_node);
> > +	if (err > 0)
> > +		return err;
> 
> Is this correct? The function prototype from patch 2 is:
> 
> struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
> 
> It returns struct fwnode_handle *. Does this compile?

Will correct this.

Thanks
Calvin
