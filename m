Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFADA3ECBC7
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 01:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhHOX2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 19:28:36 -0400
Received: from mail-sn1anam02on2132.outbound.protection.outlook.com ([40.107.96.132]:4770
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230509AbhHOX2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 19:28:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6//tML+KOtFAfOtsolMjhOE+XSR/FNilt6uIH8eRUwXEbotY/Ukhy0i5hicCfOMpSTwjr5IdfOtkBN7I87orhRsLF+WqBGyaPhOTelsKQLjKQojXvRDbah2cbcihDZslxkGrfKLHr77hmyjdY9F5RHj4fXlzMaoRt5hAnZVUoeIVflgkzspFqpQXukq/2Xa4AYPc4SNURt+YsQg8dFdBwqPX0SEVp/FHbQ8c3JeiC6plgfEsppFI1bIlB+S0WCQqwmD7cQqd6CfjPkurUg/FKYE/urhbP4lO8yyn2e4ClXiS2GBOo1RfBz9WKrYA9nexSAC5KqnZhDYWeLytl5tUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYxWiqyHGvJMq1yRW0SOuOyNmfBGYeHYnMBry2TiMOY=;
 b=CNdvmYG1fp+cEqKeZp0JKF9ZswArBEAidkRTRwMXY70CRuOLDGZpqH46YOqdw64gGzgJ1OU5hwzDaFZQt7wNFGhZCLSvhgwZDC5pDZGjjctYGQXmbElXzf2PyjVjxWzSpPInel8VVLdGj+Anu1UDwdXs1GWMrXlV8cVN4ZoweGQv2vtZVl9CBOIY7UcQY+AxuDJI923ze0W9ihMbceJnc8UkGVhGQFkamqqSgvDUYy04fnlDthtJxfmudSxnCIJ3JT0yQ7qbCkWH46t/dfXEMEVTz4nu3nZiW6wVkS4PfUhXg0VAawmSqyELGpuS+Ep05YsQjUO2qwIMmmsg3QLxFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYxWiqyHGvJMq1yRW0SOuOyNmfBGYeHYnMBry2TiMOY=;
 b=dYFssHvBAFV06iWneQSkjJqCJvZRC4V7XXU7Ay2Di0IaYxquUFKxcHN+OhtQ2qGrHql99fXZqT0yKczKUvk19I2XS6fWddCZTQh9bIO0Pg/4ICbNpGKltOMN7AQoginIM1bSOKU31aK4naYH0PWZr73RpPjlBCuOajNOghjGwT8=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1758.namprd10.prod.outlook.com
 (2603:10b6:301:9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Sun, 15 Aug
 2021 23:28:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 23:28:00 +0000
Date:   Sun, 15 Aug 2021 16:27:53 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 09/10] net: dsa: ocelot: felix: add
 support for VSC75XX control over SPI
Message-ID: <20210815232753.GA3526284@euler>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-10-colin.foster@in-advantage.com>
 <20210814114329.mycpcfwoqpqxzsyl@skbuf>
 <20210814120211.v2qjqgi6l3slnkq2@skbuf>
 <20210815204149.GB3328995@euler>
 <20210815231454.GD22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815231454.GD22278@shell.armlinux.org.uk>
X-ClientProxiedBy: MWHPR10CA0012.namprd10.prod.outlook.com (2603:10b6:301::22)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MWHPR10CA0012.namprd10.prod.outlook.com (2603:10b6:301::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sun, 15 Aug 2021 23:27:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3784133-ee71-461f-b7f9-08d9604451ef
X-MS-TrafficTypeDiagnostic: MWHPR10MB1758:
X-Microsoft-Antispam-PRVS: <MWHPR10MB17580065FF058179953C6FCDA4FC9@MWHPR10MB1758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Ff2M1RQILkY9UqnXgO0goSu9wN0IX/crWFTJMd6erj2OVTJYm6RLozt1nPP0FyPzZJ6G+ZGvicdAOMA7cqPlImCthkGto0tTc7bsrGTXglcfhtlaLi/i/Id++1/lKChEi5W+FZehrESdhgn1j1tHB9SBwDUbuynunWnqrWe3/X3UnPJgXV5jGFfx5O1RDYHFK0YDh1uilBzOTvH5RbXtVaM8iRiTFXjBx86antf5TZyjX5pk6fwYCJxKsSfHO5LXbuuRgIVZjOumRa1WXJgwRAyAltYkPCf+TO6C4iWy1A245gJ0xuspl0ZrLbMzqPCrkNsU4HPZ8O26W7cS8WLo7QfyQ/AG6LgtDXZXLNozDw6oTVP8YdN99SXNrL/sHBQYDrNsJuh108dRnIsCrtgszsVyKwJc6LFljUR8+17nDQ8xth4iHUWqYv9VZn712DCzWz3LkCd+rKeT/uJUoL4Kbf9fXNQNna/hEEqa4kMRk4lZf73YrkZTS186P6Dsg+EVo44VxDgvFuGow3kvGvkfCVhru7lfjVC8fEyZIv4Kcye27AO+w5H1uGzTP+PzyNHdOULIzfL7p3U1hNDx97j7FS9ce09/hPUqBiVrr3Zf+WFe90mUC3KKBrAolmT3ggCukLqGycGb1k0xrCPJbHFaEy9gL0YL+TleUyyB3CCZfY29nGtuogaMOjsvcrf0oAmZaRVUBTku+lbTQ9sY74YXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39830400003)(376002)(396003)(346002)(1076003)(86362001)(33656002)(7416002)(52116002)(5660300002)(6496006)(4326008)(508600001)(316002)(33716001)(26005)(9576002)(956004)(2906002)(8676002)(44832011)(8936002)(66556008)(6916009)(66946007)(6666004)(9686003)(55016002)(186003)(38350700002)(38100700002)(83380400001)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sm2Uk21r9v1ZAwAeU5kDJTa5xe8Tdj4E8l3MX13I57Llf5tCUuP2QJb39NE6?=
 =?us-ascii?Q?FaWIkMP4IUgVZV859JHJcFnOUamsWVpKhMFM70PzYxJzBgcO191Cvv6lAtKp?=
 =?us-ascii?Q?AHzFe9rmNw0N9qap6AftKj6mI44ye2ImJmp33ju+yGjD8gC4/zzy4fUg2xiz?=
 =?us-ascii?Q?aKyLwfrx0Eifd5t5vVtWvEQu88vujHBKhqahIm/98Hpn7LJMi2jyuaWiXSok?=
 =?us-ascii?Q?sopzh604CeNt2FTLymcfAm5BNAs6cofVWtwPUkKvD/XVbZEA551kzZIQkQc9?=
 =?us-ascii?Q?7WKTqDJp3HB1Gdf08p7bf53CibCsLoHpSPsosMwRX0udVl1wkQ3FoM9wYc+9?=
 =?us-ascii?Q?CZvO5W94geueJFEx/vSBjo7x/2CfOjlqWDwAc+Urk2iIsfs2KnNcuzqFN01b?=
 =?us-ascii?Q?5L7+ZZaCkJiux+aGBCuoiYa1eHXshWFaHEdWjof1Anqee07Y/+RZ3hGuSFf5?=
 =?us-ascii?Q?svo4cWhfGczZ/Q7usDHz/Bfn2nNELmPvK5E4ML5+Z9giXiuuG3Ahvnh++Rb/?=
 =?us-ascii?Q?MfO/73zht0WAHgurww7Jl7fjEtlofy3b/hNjtzTvkgmhw9vv+ZU7Dqc9hLxy?=
 =?us-ascii?Q?dC+DOWs28GBFRb5464opbUvCaeto15aZNxGUrlRJlfrkCEuxjaSgXRTuEBd+?=
 =?us-ascii?Q?p86CUelWkImfSfWhzOWAYZx0WLJStB+EV8wOGGCIpRFL547uQjlINRUNyksP?=
 =?us-ascii?Q?JJgAw5F58V9cEzaqhQmIu5qodpw3kja5+uCjq3mZuGZuomiznMMfiY9BKHOC?=
 =?us-ascii?Q?uiGbcDhwHbgO11wn+XAcm6KcXsJgTWlV1KFOYhSAMlAyl5lGeF/i/t8Sxo4P?=
 =?us-ascii?Q?nYX0qLxYwHJpj2BxFQ1VFuSQY/DS9Bai4nobMGORAU/chc46tVrlji3thCEj?=
 =?us-ascii?Q?DtoO4QgrdEkaTeeJEI+ljDM5mXt//5Vzc8G9UNnTC6MCa/LWD9mtcmJBayyd?=
 =?us-ascii?Q?ng/rLErZ779Gd/rCZS5tSbsw9pcNmmKHfkXUXIAEVBUMT/5cyBH1Mth86BXG?=
 =?us-ascii?Q?8epde/MTXK/Zpn5tFc9ENWjQWFF+kGRHoG82Y4xKc6SAAD1khgynFjKg+GOK?=
 =?us-ascii?Q?ioWJrLqeP4KozCsNhZngXqAcd0RPa7wgaum61rJ0oS4HQw8ep3VYm7+0OiHD?=
 =?us-ascii?Q?2bQvGcy7MpT36Pcj00h4vKoBLQO00Z3YymiRtn6qsRFaEdXJmApxy+YVnnGM?=
 =?us-ascii?Q?+MGQNBJZxsUF1sziF4Niv5xVq2aszcJNCcgdy3+Li0MWeZYUTSWnwBcZR/M/?=
 =?us-ascii?Q?9S30lBZD2NgR4Fi/An9MHZ1dGLaN+zxe4PKSFsrDr5Xp/i05Ou+un3u6SFFZ?=
 =?us-ascii?Q?L3xYLOasOpnS1JBSeEkJ6wJv?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3784133-ee71-461f-b7f9-08d9604451ef
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 23:28:00.2081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +VHA1D3+SwrBgSSv0FamTYMqOor+cskb+t1IDVexuG5y2a7FzhXrdk0EdvZBgiJc+VV7fIpgVGM/pjltWwWDsu7OE5W33Xm6m3v4fSDDZs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1758
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 12:14:54AM +0100, Russell King (Oracle) wrote:
> > diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > index a84129d18007..d0b3f6be360f 100644
> > --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> > +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > @@ -1046,7 +1046,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
> >  	int rc;
> >  
> >  	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
> > -				  sizeof(struct lynx_pcs *),
> > +				  sizeof(struct phylink_pcs *),
> >  				  GFP_KERNEL);
> >  	if (!felix->pcs) {
> >  		dev_err(dev, "failed to allocate array for PCS PHYs\n");
> > @@ -1095,8 +1095,8 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
> >  
> >  	for (port = 0; port < felix->info->num_ports; port++) {
> >  		struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +		struct phylink_pcs *phylink;
> >  		struct mdio_device *pcs;
> > -		struct lynx_pcs *lynx;
> 
> Normally, "phylink" is used to refer to the main phylink data
> structure, so I'm not too thrilled to see it getting re-used for the
> PCS. However, as you have a variable called "pcs" already, I suppose
> you don't have much choice.
> 
> That said, it would be nice to have consistent naming through at
> least a single file, and you do have "pcs" below to refer to this
> same thing.
> 
> Maybe using plpcs or ppcs would suffice? Or maybe use the "long name"
> of phylink_pcs ?

I noticed this as well. It seems to me like the mdio_device variable
name of pcs is misleading, and perhaps should be "mdio" and phylink_pcs
should be pcs, or any of the alternatives you suggested.

> 
> >  
> >  		if (dsa_is_unused_port(felix->ds, port))
> >  			continue;
> > @@ -1108,13 +1108,13 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
> >  		if (IS_ERR(pcs))
> >  			continue;
> >  
> > -		lynx = lynx_pcs_create(pcs);
> > +		phylink = lynx_pcs_create(pcs);
> >  		if (!lynx) {
> 
> I think you want to change this test.

Yes, I caught these shortly after submitting it. Fixed.
