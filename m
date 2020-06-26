Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BCA20B25B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 15:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgFZNUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 09:20:38 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:29990
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725864AbgFZNUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 09:20:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDCqsWi/hEwp1bIfJxSlnsTvfGOVA2pp5ludXQaLcTZn+MCXLeqz/F46LhRDv+uS9Iy8OfDmipip+knj8zm4g6Rk/FV2/iwXlxDm1PWfdLObdq7iddQn8bHZsV9WKSmO65DIBfmUkhGojrmoJzz7lzpQbTph7wxgQYvsAQpJAlvXFwEvCmOZqEk3QCTIlBjBf/K46KUDsw5fniibkcAoDlOYY2CF9RLlAP9DjABxIUlkW3+PZ6bT219e6v2TNb/VpOBdFbUiczXg0WE0p3YJVPjXfxIoiDnWeTz4Nw1ZlspOmEgZrz7KIv/5M5b3Adzqdz6PFxpiyxtOyAl0pPnegw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHaGNEO4syWh0taveMlfV/m5pS5TdsJzqD3mdfLeu9g=;
 b=Bk5Y/9fdLTZhVQm2hgsTugkkbF27xiUVOOH4UUMvoeC6OV8sF+foZl0pyAeDIvs43IvI7Q+a95CJwnxJpX76W/O2u0D6BlsTK4lcIA3v3hq+GDyK6K2Djl2s2EAowzRjJjj5TKSQDKg8bAsRxOqTqbCfdGgcRedDDD4ao7pkw5CrmEBzFZH6F+hMyBdEpE7JmAL0TZwqTXb4cNwHkYB2HqtJUbtNO91v2G1Bet1HXyhJn2OBg1h81FRi/O6Rs4Et+meV9HXzzDjxQQhfrBwbRiwxs9slrmfDiEMt3d8mbcRqEN9+ujj6kZmibq7kKu9V2CT6OpdLIhqa3P92D+tVYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHaGNEO4syWh0taveMlfV/m5pS5TdsJzqD3mdfLeu9g=;
 b=NeBpQ9WpTOn7S1NO4g6DYkwLVvgXi6PZmmC/jui9p6HmgoudKC415ZqWcSPM47nP8PLu4eO1tXglGpUj7T2xjstrVRTElW6aHzoA31DF5I1/218LBXHLKqhHC5gPpOVAnKUrk9mGD3EyLk7AhVicTgcKNSC2IKl8qQuDl1uibpU=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5732.eurprd04.prod.outlook.com (2603:10a6:208:125::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 13:20:34 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 13:20:34 +0000
Date:   Fri, 26 Jun 2020 18:50:24 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>
Subject: Re: [net-next PATCH v1] net: dpaa2-mac: Add ACPI support for DPAA2
 MAC driver
Message-ID: <20200626132024.GA15707@lsv03152.swis.in-blr01.nxp.com>
References: <20200625043538.25464-1-calvin.johnson@oss.nxp.com>
 <20200625194211.GA535869@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Description:  =?ISO-8859-1?Q?=20=1B=15?=
Content-Disposition: inline
In-Reply-To: <20200625194211.GA535869@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR03CA0096.apcprd03.prod.outlook.com
 (2603:1096:4:7c::24) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0096.apcprd03.prod.outlook.com (2603:1096:4:7c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.10 via Frontend Transport; Fri, 26 Jun 2020 13:20:31 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dbd0d97a-47a6-4c65-338c-08d819d3b53d
X-MS-TrafficTypeDiagnostic: AM0PR04MB5732:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB57327BC35082AA5766066B0BD2930@AM0PR04MB5732.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +i4aW61+gBE7wEieWqqPxMLfio3d5DdlVek8srwgsMUCDhtoU+tTpOjKY/d/17D9gcPrBdNxPyQLo1QGZ6kRMJXszELeatWoe6HmASPhPHrqx01CsYmq7A0V80p9v8rTNC+FJNA1AOjWTHgFsamKETBsmB/Bq32D+0cSLzD+RtXjx0inQkBnMyKgeZe72ApLYV0svi+fGSYny1VjH+7qVszRwp2V+zOtyo13KLELNWwwNnVFdhVFDzvaMoerdCaXpEIFZMBTb0J4y4k/oMwiD+eHfj3Jn4sU1PC+40DdW0DwHLctBKE95U+a7b4k59NQYXGD92srahoDdSWlQ2glqVwjic0xV7zuHk14pjI5hgdc5QObeRXdgXsFVodTXMBv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(33656002)(956004)(66556008)(8936002)(478600001)(66476007)(6916009)(54906003)(4326008)(83380400001)(6506007)(52116002)(316002)(44832011)(7696005)(186003)(9686003)(2906002)(16526019)(1076003)(26005)(55016002)(5660300002)(6666004)(66946007)(55236004)(1006002)(86362001)(8676002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: E6xGydgUcm0DlPdRhBUjazu9JbXey0rJ02fCYgK7gmRXglhWmT9bzA8uBAESfh/a8vJlREPgkZ6RhfHQPFpe5NTr6DW0OBXnoQAomq4McLHsyZHbtQoODZt+emjsJtsUSf0H6OlvPbGaBNMSBovkaFcP/iwnBFJQ8+9iDm/3i9I7XNxhRrlVxfJaPqCNInB8cJBMFQDGruG66zsL2Y08A0GSmIgd0d7WeI4l2dfi9qQeyorjggUI+6Jd2cHp2xml9PSsTws0knsxC/TYA5AAXKLIi2ic81kMFqwQLPBb+r5dtvfU7wp0NiurNVsEBx9zAwHtqlb2kVNOI/B1eyjMiK6jjfGYplq4nTwdpGxlloNjAaunJ2DOOrB0i+NqwMv62CfC3KVifUQOdIf9C6CZbXTEEq0QSg+STwWjpabCVR9QM6yy561feNo+zgI9f4fA5QLeZ0p4kwukxxji/Hc9enr7X00HNKuqvR6/WU0WNbY=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd0d97a-47a6-4c65-338c-08d819d3b53d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 13:20:34.5204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9arnkuCox1xscc3H6nsBUjg75gziap90U/ci5cz7oFF0hEjweA+fVzjBnyWaYJhdG6FAaqo304SRESiU98LXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 09:42:11PM +0200, Andrew Lunn wrote:
> On Thu, Jun 25, 2020 at 10:05:38AM +0530, Calvin Johnson wrote:
> 
> > +static struct phy_device *dpaa2_find_phy_device(struct fwnode_handle *fwnode)
> > +{
> > +	struct fwnode_reference_args args;
> > +	struct platform_device *pdev;
> > +	struct mii_bus *mdio;
> > +	struct device *dev;
> > +	acpi_status status;
> > +	int addr;
> > +	int err;
> > +
> > +	status = acpi_node_get_property_reference(fwnode, "mdio-handle",
> > +						  0, &args);
> > +
> > +	if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
> > +		return NULL;
> > +
> > +	dev = bus_find_device_by_fwnode(&platform_bus_type, args.fwnode);
> > +	if (IS_ERR_OR_NULL(dev))
> > +		return NULL;
> > +	pdev =  to_platform_device(dev);
> > +	mdio = platform_get_drvdata(pdev);
> > +
> > +	err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
> > +	if (err < 0 || addr < 0 || addr >= PHY_MAX_ADDR)
> > +		return NULL;
> > +
> > +	return mdiobus_get_phy(mdio, addr);
> > +}
> 
> Hi Calvin
> 
> I think this needs putting somewhere global, since you are effectively
> defines how all ACPI MACs will find their PHY. This becomes the
> defacto standard until the ACPI standards committee comes along and
> tells you, you are doing it wrong, it should be like....
> 
> Does Linux have a location to document all its defacto standard ACPI
> stuff? It would be good to document this somewhere.

Hi Andrew

As you know, making this code generic would bring us back to waiting for
ACPI team's approval which is very difficult to get as the ACPI doesn't
have any opinion on MDIO bus.

Like other ACPI ethernet drivers, can't we keep it local to this driver to
avoid the above issue?

I can add more documentation to this function itself.
If we plan to make this approach generic, then it may have to be put in:
Documentation/firmware-guide/acpi/

Please advice.

Thanks
Calvin
