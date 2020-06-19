Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDAF201585
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 18:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394606AbgFSQXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 12:23:03 -0400
Received: from mail-am6eur05on2055.outbound.protection.outlook.com ([40.107.22.55]:24112
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390538AbgFSO7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 10:59:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1XhLqgZNgpsSDmwz2Lw46ATrcu6VvDyBsa+7SQ+16CQg9+M9KD3bwm+763v57geJvJhJA2o43EOyoDsNVUC1MV7kBO5KhxCtp7T97fmqOXhW0SHjC8K2isk7ln95G90YsUtAOAQM1LuGuch/mvPjLNlv2WBMVsZXV6OCJgxnK3lPW+HcolBjTEL8E4AM5fOFC3RMAhPxkpBPDO+1JRys+KyVv9LnEgLNeDyKp+jIJ7M3LmxZuqQbPUzuejqJwt13FUX/nC3ZXiXZT0k3ubdcY8eKOR3GPYg5P2ltIAFZvQB3aTs1kvlvyqqXD+IlQOa8gd43AclFOwT75QGsc/FRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGPCfhF2TB/AefSF24a7H3NAUrwifp5e0BYAEBboHbc=;
 b=SKaXnAsoiTXLutUpBiQL6luNh5eqZLCHFMaimPccTmX9ou6+/Nqjwr1E0TYAQJa38m3u2zrPU1K06vRzOP8WvmCGRvyxB6zjKoyv/x2pWjPqhgoIzfjW+F2aaixe/KvV62JyJTortNBV0AjC7zhkS8nE4+ZD2F0GweFjnyYMWJQYksCIhHJrY8EpT2j0fJ/oSyctETCmhcOfXpcdKYnKyPxMB1nRTY8c11/8dLW5RdvwFTNJzhSdlyoVqdY1iAq1cmPtvUBPBXV92lV8e+kqwKJwBF3jsqNKUImjPHr1zo/ek/GPxzKChgB89LTAJu3uNfO7UZe7u49owQ4JShthUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGPCfhF2TB/AefSF24a7H3NAUrwifp5e0BYAEBboHbc=;
 b=BSRAQGx8yB+SbO2w+ocMJ/VZ9iwdlP+BDg0PbA6/BzU62JKG+4+tb30B60madA8IpFeBxkHXqEDurtYoq1qcWkBhcluFFreiVOdVyCCbH492EfIkX5BXbbx9ZrdVaPJOheDAg7pEJPwABJx788BtgScaD9XJzhglarUU//X4WqM=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5457.eurprd04.prod.outlook.com (2603:10a6:208:115::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Fri, 19 Jun
 2020 14:59:37 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.023; Fri, 19 Jun 2020
 14:59:37 +0000
Date:   Fri, 19 Jun 2020 20:29:27 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com
Subject: Re: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
Message-ID: <20200619145927.GA12973@lsv03152.swis.in-blr01.nxp.com>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
 <20200617174930.GU1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617174930.GU1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR06CA0120.apcprd06.prod.outlook.com
 (2603:1096:1:1d::22) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0120.apcprd06.prod.outlook.com (2603:1096:1:1d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 14:59:34 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0619d15a-7cb6-48dd-e445-08d81461626e
X-MS-TrafficTypeDiagnostic: AM0PR04MB5457:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB545728E2B613AD92A730ED1FD2980@AM0PR04MB5457.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lw4jJbxKhRK8wguJu0lywA90z7g8C/bnjxAiEFHg0HB2vVDi6ob1Y/kvbrUjAJ6+Zh/xCUC04/wUT49nnVoWjemtWSiBwcowrFE72xOaOnjArmL1WBzvgp6iK3Ywl0MI9/acvvwQyOguGzbeB20tEDBjlh6LaovZt8OZ5FBccaUYZWClBJrRpjEi2XvDQ5Hjebvx5RPemCEVpgH9+9AUUI3uPyCoCipKS98h9zn101kgLm5GgJ2Hujqg/mqPuvgIdQHM8VUoxjOIkbfByLp9L58gu8xDqAjJezLni/0VXoUPbXRB2e/qQocDE0YuLlzOcUbo6zfIeLn9YuqwBW32+pqJB8J8iyQsog362V+IBsiLy+cvBGUnMBwarJpK2F9M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(1006002)(5660300002)(6506007)(316002)(26005)(6666004)(2906002)(478600001)(86362001)(33656002)(8936002)(44832011)(83380400001)(8676002)(66946007)(7696005)(55236004)(52116002)(186003)(4326008)(54906003)(1076003)(66476007)(956004)(6916009)(16526019)(55016002)(9686003)(66556008)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qITuWFcoDotG7o3eKgl+fwHF/MMxl4ajKhl+2RH6WNQrvly6qaMJbVDJnZaKkBp3dNvUfbBds2tLxP9+EXRDIfHyLLGI+JvaIBHy54H+86FS+JvEPCJJ59z1yYXJz0d7wplWOFlwtjUD/tidQW5NnrhPfRuhJbaUbI4PO5W42tWoI3EXBriMuzA5OpWSUPyTF6e6ul8o1k5yO9R1JGV+XlMpwumxcV0VmScgKZtpV2THgFR/CjRvzjNrcJiGpwoUYr0jvE6JT9WBtvf8WpPgUG3gKvadY5PBUGrKXa1tZykzhnAidnx2AnVjjNN0YZxp9cStZhJnTkgAde807qGPUsxOVh8nambTJX9cBMREIKsuLmLjd8X+NMtiC6XhVPksinMr5ywFfnmDAL4cqz7OOBLGh9yps225JDWVF+vNQYL67ZzLoy0FXl3CallbqOgjA7TgvCSR6IJCfONYC+YrI3Mk2Zxo2T2fJmX8WS+txhOI/VDleT84RwU5KU0Mhs5z
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0619d15a-7cb6-48dd-e445-08d81461626e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 14:59:37.1621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bzU12CrgI51c+93VkZUZTS+aBuUjIND0Qu6nVASkoPfoCSgmbZUTd99ub1Hb6vT4TCG+b2rNzsQ/FO2sobm5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5457
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 06:49:31PM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jun 17, 2020 at 10:45:34PM +0530, Calvin Johnson wrote:
> > From: Jeremy Linton <jeremy.linton@arm.com>
> > 
> > Add ACPI support for xgmac MDIO bus registration while maintaining
> > the existing DT support.
> > 
> > The function mdiobus_register() inside of_mdiobus_register(), brings
> > up all the PHYs on the mdio bus and attach them to the bus.
> > 
> > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> > 
> >  drivers/net/ethernet/freescale/xgmac_mdio.c | 27 +++++++++++++--------
> >  1 file changed, 17 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
> > index c82c85ef5fb3..fb7f8caff643 100644
> > --- a/drivers/net/ethernet/freescale/xgmac_mdio.c
> > +++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
> > @@ -245,14 +245,14 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
> >  {
> >  	struct device_node *np = pdev->dev.of_node;
> >  	struct mii_bus *bus;
> > -	struct resource res;
> > +	struct resource *res;
> >  	struct mdio_fsl_priv *priv;
> >  	int ret;
> >  
> > -	ret = of_address_to_resource(np, 0, &res);
> > -	if (ret) {
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res) {
> >  		dev_err(&pdev->dev, "could not obtain address\n");
> > -		return ret;
> > +		return -EINVAL;
> >  	}
> 
> I think, as you're completely rewriting the resource handling, it would
> be a good idea to switch over to using devm_* stuff here.
> 
> 	void __iomem *regs;
> 
> 	regs = devm_platform_ioremap_resource(pdev, 0);

I had used devm_ API earlier in this place and ran into a regression.
This mdio driver is used by both DPAA-1 and DPAA-2. In DPAA2 case, this
works fine.

But in DPAA-1 case, the existing device tree describes the memory map in a
hierarchical manner. The FMan of DPAA-1 area include the MDIO, Port, MAC areas.
Therefore, we may have to continue with existing method.

Thanks
Calvin
