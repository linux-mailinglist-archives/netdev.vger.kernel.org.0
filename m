Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA4F3D26B2
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhGVOx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:53:29 -0400
Received: from mail-bn7nam10on2106.outbound.protection.outlook.com ([40.107.92.106]:37427
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232217AbhGVOx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 10:53:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtDaSR4JUOCieCSsZj9DNLxSr/TIOuASBOpS4xbU3s/BL5W+ID5JDK5SFSLQs6lfuleCBqk3FHwsFwK72lz5BbGQP7N5nnpLFz1LWc92UlZZ1HnOqvxvuHW1Vo7j/6hfPA3oC57rjoWgXsH90N+EFvi9iK0MrxTKNGvW9WB0LnZXs151db87r9DY3jpsErEU1rSuT1gDN1AT3lHHE1gkvrlx1SkZK7jph8cGovb6/qBH4yst5iEWp2+Fur8praIf7+liNxFTo0v6B5G4VsFhrdThH2hJrC+XnITC8lyVbw+CRaLAIqIp9S/wrAv9WFeqZVJpP01HEHCUA0I379PEOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Npp4iX1PgCArjUt/0W6tKjavu4PGUTpGqwMp4K6RXHE=;
 b=JYzgb0h9ZROO60+8+DNsCZIZj6e6ZXvH5FBGIf47McdO41WDMet9EfQZ1U7156C7s/gYuks966Ub7xezxYpweH3kK90exzPO5zXK5qszIGPTkBC/7v5sehq/2jnfOlzZDOkABiYPWu9eAWULBq3MvK52TJe3g9vVpC9q11aNH/tmiDOPQHc5q/GDsn6zDgxVWVqSeqTd/OSYtWtuu32WJxHzywVN39xz9FMD6R9eoFS688h36YUJKpmwB48QvK0hpWV7g2e8GNuo19B/l1ditbXLYvCdiVLhyytSHdzvYJf4Ljj//lE/IgTLpWE1Zdk+vTRSPN9X58FOIwW/MmgsaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Npp4iX1PgCArjUt/0W6tKjavu4PGUTpGqwMp4K6RXHE=;
 b=Q/2AUktlRMEpVj0E10uTTbI5YKNQv5IErQXQj5FiRVnrrkCh7kzJ+blcy2221AwtMxzBMX/qWMuAU2a4hnEdq8RHSoiKAtaBUl+3d1hKnf1UoxWFWvukzDxsz5Qhg27ENZ2klrymZ8nJE9QT8JEuwzd/JAM0XtRjyPaT47HVv3w=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4465.namprd10.prod.outlook.com
 (2603:10b6:303:6d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 15:34:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 15:34:01 +0000
Date:   Thu, 22 Jul 2021 08:33:51 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 net-next 1/1] net: ethernet: ti: cpsw: allow MTU >
 1500 when overridden by module parameter
Message-ID: <20210722153351.GA3590944@euler>
References: <20210721210538.22394-1-colin.foster@in-advantage.com>
 <YPl7LdLMMTmhSu1z@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPl7LdLMMTmhSu1z@lunn.ch>
X-ClientProxiedBy: CO2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:102:2::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by CO2PR05CA0053.namprd05.prod.outlook.com (2603:10b6:102:2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Thu, 22 Jul 2021 15:34:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80e67995-cae6-4db1-f05a-08d94d262137
X-MS-TrafficTypeDiagnostic: CO1PR10MB4465:
X-Microsoft-Antispam-PRVS: <CO1PR10MB44657C276FB3109EC2C9E839A4E49@CO1PR10MB4465.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aj4kOk8N4BnhjuPOlE4Rx19tsyzla2yIFkv0nZ6onb+kxHwm6VkTsr1ntAj3JyLSTmUVJP6YJBmNEBvkXaiZeTlRE87yPzEbTz6cVEXteBdIyo37I4V8BBHjyIAcSMYdRmry8qLhZIF+UDU8YjUbEAumsJO6piO6rGW1eiiaxoH/jIVsgdEV4JtgsMMWDMEKXtbkOARBUmH/RoeH1URA1kVBtFWKItaW4suCvwuicPzew0Ftvr0VnepDQdSRyxTElpzmNp4r3nxSOi9Az7mZPvVKNlb/sgZLN/2dDS3lijHKHj8/fKLXgZVH5UuJtASVCQYtvB0jvCvCoxajrftWqjhSYsYtNJbNbNj7Uq5oXrrJFYb/cmlNvlX39KKQXwIgyFmLdui6a/ULsWISL4bmB3aywN6tK4yA7Mv4cz0ba0sNgsc+P6f9IxXnCuHAJno3OgzymoU8eRfLb11K+9Y3BPdT/DylHDvXmQGrm37knOi4U/uYoafEc3FOKjMJH2aTwSl0bGlAIKjHME4XkSlRvlYMmSYOlD43DR94286YFCi2oBJOkJQM5kKt4w6DiTP3tPVw+7SF76x3P+YmBpXRKevO/0yl78OQD2bAor0YwxSBA6i7teyGPHtWvJPm7D8vV9k/wbWdb3xBkRn/AXIuXCuoQMHHQZDAMt23PwLcaYsCZMa5Xw13Gb1GUzWW30DYHyIHEknuM3P/ygsU+36cbX3w+fwTYF+tV+0q12wWQJcfgRAYEud7gLCroqMFx3LGRUp3UlkoLLNCCn4MUM6r5uRetwViJj4D/vNuDBc6IVrrmP5Zen2NscsQ3t1SEA0b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39830400003)(136003)(55016002)(33656002)(6666004)(316002)(2906002)(33716001)(966005)(6496006)(52116002)(5660300002)(86362001)(44832011)(478600001)(8676002)(186003)(83380400001)(9576002)(26005)(54906003)(8936002)(956004)(4326008)(66946007)(9686003)(66556008)(1076003)(38350700002)(38100700002)(66476007)(6916009)(221023002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6owdTiPOpHf2VCrltvKleUdNc63nBNFj5iBSVgqvyzwoZR/vm51C8y22brlc?=
 =?us-ascii?Q?WNVMNG1cNu4OrxZ4ZHuV72+maH6Xt9Nv2E2BRAE76TRHI/0jT162LwSFUlU7?=
 =?us-ascii?Q?5M5LeaQ++KdbO0sH6lZTtT75x7dKsIjv7pXdAyZyBrpta91sVi1OBWZrSnrc?=
 =?us-ascii?Q?s14NFYO0S37rxboF7/IgRueY/MhJT7u/Th8q7ZFuull0/YXLcCBnRswBh2BT?=
 =?us-ascii?Q?uK1ajrpcJs6a5NEj6YPfotoqtJF6XUSwJweqISSFG8YKS62JQlKN3MZuecmv?=
 =?us-ascii?Q?weXa1aJ2zxPyFczomKaAjYtA/Ee4+vPgLMvF6TiguKyN4XGKO2esGMJp8UB4?=
 =?us-ascii?Q?Ou/cxpnrujDLOf/apPs2DKoqJUsX4KXUNtsTyOXFSP0fHBJ5BDTd3k9SU9zl?=
 =?us-ascii?Q?wNFuALP0891cXQKoIZ7bq5AvZQd8OCOApOzVJUzgAvAIf7AWxS71m6FRE415?=
 =?us-ascii?Q?gGWnspOZmR24hwdaHbr8BNanbMu3DFeLjb9MYMBxissWG96YkdlrKppzVsDj?=
 =?us-ascii?Q?id7qcavdoqCi41yE42deF7SFxJTqjmLM4aZ7N9rAB0A9jGS+b1tRz4+iN6Ih?=
 =?us-ascii?Q?N8fGoI6hvDdK/Cn1FG7GEfp6IgwAvsf4F3ZPv591FoTxH5dWONX1ZbmWWDxl?=
 =?us-ascii?Q?uhnfuSodaPr9i7XTFBT+VCvaJnS1v4cDikOSdWi28sIkt6WFKwOSMJ50CDnN?=
 =?us-ascii?Q?/FDZ7hvG4fuk7DOsoiqXm9jM1EyaCyX4accNmH6usDZKJpx9Ra2YyTnTYnM4?=
 =?us-ascii?Q?GtCobyKyenyyBgE++VTOwRGAkq2Xqpz/d2NNU8FjCw0f3p/U3fSw8AVpCrqE?=
 =?us-ascii?Q?0ep2PHM9wtE6hCk9LAWyB1mClKP1U9ZYHDjnDN/Rx0iAdTNmxDL0v0lwlV6y?=
 =?us-ascii?Q?/pOX+sNQdV/uV3kmQgt/R2i8uU4+Mu3732cC24QD64zlN5SEd3YOI5x2/PyI?=
 =?us-ascii?Q?c+S6GgqA+Swz4rzaB06DaIzV7UDt1D2Df1LNYrlSlNb2VKGXFARHCm0supLn?=
 =?us-ascii?Q?OQuApy45asipK96MioVM+MngsSUOuCCpFE4agmlBUXcwzuz8p4zhEMmMQEmy?=
 =?us-ascii?Q?BENhKnGW7yokPVZBD+7w9YXB6Co+1f3A62ZKh7H2g6w9Hqngwg/fDUvlEOGo?=
 =?us-ascii?Q?7bm7gjGGuLKV2/7c5zCaa+HVOa70GsIpofyMFqNXsKQaYhsVrw51y0QAgPbZ?=
 =?us-ascii?Q?vpv0Nafvb0u7cRd+YR271hTIX419uUaOGKeXkH5UfGT5jjNLDMO7AVFRHi+U?=
 =?us-ascii?Q?M0nDPUOw+ifZknqWWVK0ksIO+kZOOhCdhca/Qk+UEy7fZoWpk4ESU5uGwJYl?=
 =?us-ascii?Q?YO25eJkd49JWcb/2921LbjWN?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e67995-cae6-4db1-f05a-08d94d262137
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 15:34:01.2824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0CjKeXx6kUDyt/m7d6q3iJpe2jagzKjHdr5DgKFhJGWnDjkfQsAujlgimVG5TAP5hP4RrB9iBRcJ9upFQdkk7FFNV2X/geqew1Eec+wodBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 04:05:33PM +0200, Andrew Lunn wrote:
> On Wed, Jul 21, 2021 at 02:05:38PM -0700, Colin Foster wrote:
> > The module parameter rx_packet_max can be overridden at module load or
> > boot args. But it doesn't adjust the max_mtu for the device accordingly.
> > 
> > If a CPSW device is to be used in a DSA architecture, increasing the
> > MTU by small amounts to account for switch overhead becomes necessary.
> > This way, a boot arg of cpsw.rx_packet_max=1600 should allow the MTU
> > to be increased to values of 1520, which is necessary for DSA tagging
> > protocols like "ocelot" and "seville".
> 
> Hi Colin
> 
> As far as your patch goes, it makes sense.
> 
> However, module parameters are unlikely by netdev maintainers. Having
> to set one in order to make DSA work is not nice. What is involved in
> actually removing the module parameter and making the MTU change work
> without it?

Thanks for the feedback Andrew.

That's a good idea. I used the module parameter because it was already 
there.

My intent was to not change any existing default behavior. The below 
forum post makes me think that simply changing the default value of 
rx_packet_max from 1500 to 1998 alongside this patch is all that is 
needed. It all seems too easy, so either my use-case is rare enough 
that nobody considered it, or there's some limitation I'm missing.

https://e2e.ti.com/support/processors-group/processors/f/processors-forum/461724/how-to-send-receive-jumbo-packet-by-am335x-emac

> 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/net/ethernet/ti/cpsw.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> > index c0cd7de88316..d400163c4ef2 100644
> > --- a/drivers/net/ethernet/ti/cpsw.c
> > +++ b/drivers/net/ethernet/ti/cpsw.c
> > @@ -1625,6 +1625,14 @@ static int cpsw_probe(struct platform_device *pdev)
> >  		goto clean_cpts;
> >  	}
> >  
> > +	/* adjust max_mtu to match module parameter rx_packet_max */
> > +	if (cpsw->rx_packet_max > CPSW_MAX_PACKET_SIZE) {
> > +		ndev->max_mtu = ETH_DATA_LEN + (cpsw->rx_packet_max -
> > +				CPSW_MAX_PACKET_SIZE);
> > +		dev_info(dev, "overriding default MTU to %d\n\n",
> > +			 ndev->max_mtu);
> 
> There is no need for dev_info(). You could consider dev_dbg(), or just
> remove it.

Understood.

> 
>        Andrew
