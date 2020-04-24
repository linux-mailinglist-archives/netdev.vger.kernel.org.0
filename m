Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996EA1B772B
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgDXNlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:41:23 -0400
Received: from mail-am6eur05on2072.outbound.protection.outlook.com ([40.107.22.72]:6215
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727083AbgDXNlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:41:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzxSm5PNRxPyA/MI4t2cOATXnNGoBg+V850WaNiLrCUnQWiQTGjYGFEjr4pnwd1Ov6Ez2t/+klJ9mnZtyY7KU1eZEF70kigHCB/axCbO7wPfyuhFM/9YGNhAMPu90tBHqm9KupLd8Ej6FULfi1mvLcR3FivUbOcn4SB/pVY0aE87tJLPgSJU/bdIk6QxUmuaTm59RBrP2heSsS+fls/YAt/1M+T06alN4bocSCo4qxAl9ft/NBtfnAB6WPeK2bSOh6qFwD1wB9KSiRfoeM+RKHsMNHpC0OgbzP/cYH6RRRk33daQcJxBltbZpdLLRjxTQ9jswSu1LJSBWDiSceOVuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVDkDJzt0P7oZrY6N6wDFkwF6QElWuyqzr6CFV1sTR0=;
 b=matQzPa+oZ7ajhCUymEg4dHyH9t7E4gg6WUTv/f7Hbc3tZdZzf9Lqp3v0eTGJ1SfUnW/QagJQw6o4k7FgSAZnt45QxfzGimy7c/AOQWu1J/foBjIdIAJp44zsZOhmerCmYojg0rACuWwHbGkn5E1LDKuY+PfupaS+eK9pu82t9JxGCWNV/NrazYuKja92cO14B7CFeHAVRlzIQLcA/6ed0RULc2TWzR/CvDfmYqKrJAnKSp8NVYnu6FcXt5SyvGv0EEot89MY02W5F1RErZS4aOrp4N0tRXEsM0YcoYVYp+Rt7TVilOdXdMWIgHCrvHDf4Gl5d4vJTxm6PozRtE2Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVDkDJzt0P7oZrY6N6wDFkwF6QElWuyqzr6CFV1sTR0=;
 b=QZciqfKy+Q8jfcFaCDW4CXaw26XrQt52XlMaEsX/oGapXq4qo82r/Y2Jox0pI0NMFvKsLbmIOTCclN7gDrPKk8hSDJN/AIWwbnaFbjxONIYkkSB4eb0TbmcrWo6M73Nw2PkePaZxRaGQy9DZca9YoPHHiSOD79u3v2+l2lvzKI8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4371.eurprd04.prod.outlook.com (2603:10a6:208:72::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Fri, 24 Apr
 2020 13:41:18 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 13:41:18 +0000
Date:   Fri, 24 Apr 2020 19:11:04 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, linux.cj@gmail.com,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [net-next PATCH v1 1/2] device property: Introduce
 fwnode_phy_find_device()
Message-ID: <20200424134104.GA19106@lsv03152.swis.in-blr01.nxp.com>
References: <20200424031617.24033-1-calvin.johnson@oss.nxp.com>
 <20200424031617.24033-2-calvin.johnson@oss.nxp.com>
 <b583f6fb-e6fe-3320-41c6-e019a4e10388@gmail.com>
 <20200424092651.GA4501@lsv03152.swis.in-blr01.nxp.com>
 <CAHp75VdxFjzs2uj7ZYNmwt9DC386gMNahi3A_MYV4wE3kbtq=g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdxFjzs2uj7ZYNmwt9DC386gMNahi3A_MYV4wE3kbtq=g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR04CA0177.apcprd04.prod.outlook.com
 (2603:1096:4:14::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0177.apcprd04.prod.outlook.com (2603:1096:4:14::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 13:41:11 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1a288760-d394-452e-6da3-08d7e8552a87
X-MS-TrafficTypeDiagnostic: AM0PR04MB4371:|AM0PR04MB4371:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB43711738E9C320CCA5CE91F7D2D00@AM0PR04MB4371.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(9686003)(1006002)(54906003)(81156014)(6666004)(8676002)(16526019)(5660300002)(1076003)(33656002)(316002)(8936002)(6506007)(44832011)(86362001)(478600001)(186003)(55016002)(53546011)(66476007)(2906002)(4326008)(26005)(52116002)(7696005)(66946007)(7416002)(66556008)(6916009)(4744005)(55236004)(956004)(110426005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xocNXNcgRprDqflEzd0OMJHCrpi9CbU9d4ZTXm6JjmSDNVq6foJ/fpxH2LM00g7awST6p/39b9ViuPd6EuM7Rx13uuOrHbuCQdwCdaS9M4yp8LE/esbiOgtLPD1EAB0UP+gewpo0O5gCzfUePNlk0iLEOZoRBQc5lEkRCGEGpt3W4YBaUXw9q8t4l+QKjdiIYuhDbAyHs7PEPQoZAI/qnMRyTEBFZTH7imSmxTSMdZ/GUICqxtCDRcqhZIN3t9txnJG9cqAglITXeQE7k9zRm78G/uWFzxGO2IiqX6knfd9/+i81ZCHGT2kFAWvMq5Rhc/pV4/lPsqAwaPG7xUR6M7Be4DG96YE4NbEy/7PrS0Fcg7i6ObYl1Qi+oJGSmSex3oWM+AYFJc3c0PVqFVuE5jYTVXpz7SjAvoFACUo5Nr0k7RcpJcd4olT8d/1pOvL4AV5+7Givj18HvPO7U+Dkyv1G9KFxUPaT68JSeGs62TiQZkqhfcwg6dI/+fa+4oTA
X-MS-Exchange-AntiSpam-MessageData: KfvS2W5uGptCDkL766egryhMddOQFJRYdvyFIVIXSu7Wc2ZwXMs2uRJm2PPUHK1TDKkjZS/7OthfhDsQNzUjrR/1psUZZbxm0FqDwksOJzq2eN/K5D7CrW5y1m1I0URki+TLK/h/YpT7T0SnK7Xz0w==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a288760-d394-452e-6da3-08d7e8552a87
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 13:41:18.5154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xFc/M5kNJBf0V004AmvmSoFPVjq4vkARb9w9bQ++1TAK15RUyBzn+LU09g/njPqB+IDvgvUv+jzY00aPNpGoXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4371
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 12:54:26PM +0300, Andy Shevchenko wrote:
> On Fri, Apr 24, 2020 at 12:27 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> > On Thu, Apr 23, 2020 at 08:45:03PM -0700, Florian Fainelli wrote:
> > > On 4/23/2020 8:16 PM, Calvin Johnson wrote:
> 
> > > If you forget to update the MAINTAINERS file, or do not place this code
> > > under drivers/net/phy/* or drivers/of/of_mdio.c then this is going to
> > > completely escape the sight of the PHYLIB/PHYLINK maintainers...
> >
> > Did you mean the following change?
> 
> I don't think this is an appreciated option.
> Second one was to locate this code under drivers/net, which may be
> better. And perhaps other not basic (to the properties) stuff should
> be also moved to respective subsystems.

How about placing it in drivers/net/phy/phy_device.c?

If it is ok, I can do it in v2.

Thanks
Calvin
