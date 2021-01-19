Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FA22FAF52
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 05:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730062AbhASEHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:07:44 -0500
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:9443
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727427AbhASEHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 23:07:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nj1J+2A9x+hnU3QY00SolBEyEBurExDO0Q1fpDNA2c6UadtRFoxJ/U7lQUrRSsZHAWJPVGtlCgGdgIT2N+JIRhqsbBXT2ge/hOLCMHaf/DQ9Ic9TmNeq5zCjN0FdN7H+9hG9XShZRuc6qJ/DiIhNgERitNDxex+RBs6j0I2pSP15ea2Oz+/gqHqGfzivfoYew1YSH5K+htrDkkdALx1uPvodG1QaRlt8S7c2N4It8uSNpPY2W3DQklIrOwjSj6xRcl3XQF3KOs6OzUeJQmvsAGGI11cmvy1reAcWdD69PTUXBvY0ueh77Jbtl+CZBNWBjiKNOD2cruT2BJVNopHdVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAGjkSSfF3ZabSaKLTPjZ6M9r3OCGJ/tC+Lgfp0qnPU=;
 b=lLSjcdGsu16cPYzHB3TqbT0jwOA1GRcFZajKQ6fco0ruMeyXw7D8PV8+XcjMaT3QDm+NntAliO4Wjmi9bkhI3zRRW5ZsXaEX22QXJsiK4CRfXzGtB90oL//W54aIkeIBXZiapiZf8AkjGxXqcRRP5M2mv6nMrUpJw591jewP94BGZ48PcMF2jIv50J/T2S6Q+jgSKMlaZ8RcNlmx3IYUDBdtoP2Mym+KyX0lKRfdvkMONWspGp+A+sYIijE9aIXOYOIjpCpJN7ZUd3cZSp9KG3Je8I1BnltyZW0RSxqLfHa/oFy/maTHdrn2wdcDwcuCtJ9Xv92z0CEXqb0Qr5Eu7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAGjkSSfF3ZabSaKLTPjZ6M9r3OCGJ/tC+Lgfp0qnPU=;
 b=NNFfKGIlC71qq6GvM2937OBg0f6w2k2yU2aZU9cNXJIumiwWpOD0bCQ4mRrYft9NfOoKs7myS9Z4dmx0YK9xfYgJgT6/1zqw1FQF3sVCFGUoPYnGN4bA8HZ6M599q6o1zI9oXeO0FcJNgnD6xeLiFASlFtWQ43qox5Inr2rBrZ4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB7155.eurprd04.prod.outlook.com (2603:10a6:208:194::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Tue, 19 Jan
 2021 04:06:15 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::bda3:e1f0:3c08:b357]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::bda3:e1f0:3c08:b357%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 04:06:15 +0000
Date:   Tue, 19 Jan 2021 09:35:56 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v3 13/15] phylink: introduce
 phylink_fwnode_phy_connect()
Message-ID: <20210119031302.GA19428@lsv03152.swis.in-blr01.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-14-calvin.johnson@oss.nxp.com>
 <CAHp75VcRDmQGfJ6ADJO8m4NvvenMaamNn8AYbYAyXV8JDy_b3w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcRDmQGfJ6ADJO8m4NvvenMaamNn8AYbYAyXV8JDy_b3w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0221.apcprd06.prod.outlook.com
 (2603:1096:4:68::29) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0221.apcprd06.prod.outlook.com (2603:1096:4:68::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Tue, 19 Jan 2021 04:06:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6f48bf2-2164-4ed0-cb3a-08d8bc2f9070
X-MS-TrafficTypeDiagnostic: AM0PR04MB7155:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB71558167D45A75A5FB5B38F3D2A30@AM0PR04MB7155.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /f/sTKxtnT+rjPsbHPIt1uaDO2cmVDmGWHMAGJ30ZfN75lMDRW9AJkpRtGoYdlTThI3QKjXkogMdI9bJTsW55g9+S6X/a/WHAwkoh0mbsNgTs2XXxNOfL8k8PTv6xMcc+nrqZeaAwCmd680RUeQqcZTpHZ0PF9UO7p0FgmOK9QgBgmefzhQF/za19kYLhfYstThYcd0KvnvQ7mxTlHO05yxZOfrcvz3TVwg+tIZG5AmiDVjVE8QqURCNpE9JyWCaNekz1JW7vOckhMN8F/Q7yJh/T5KR7wzy2714Z4BqBfpCbVYgWyg+Oh5Rgf2C1KCiagqV/f+9BEebNFkv66pze22a4frFkDDl5BoPqTnR9QBr4o3DMS8s+UeMZCWn+cV1onOpTvY7DYJEJdtu6GbbIsKxxtHS8g8KySoc3mTCwWfB8HsFMdBbeBU5iiaPlECq3/L0MRc//4BwvWB4i1fCCL1LJ7vBcgcsjiZhTWTe0Kj00Iv1loFO5rQkpkQGlLlV+nhX13lLO5XgaNZt4pO4oUtL3bJV/K77/TmZbntZAAfT9BIqou2fArWiTXlAlpExxFsekGRiA8f1yypK0sdrvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(66476007)(4326008)(66946007)(8936002)(1006002)(956004)(6666004)(55236004)(186003)(478600001)(33656002)(1076003)(66556008)(16526019)(86362001)(2906002)(7696005)(6506007)(53546011)(54906003)(8676002)(26005)(6916009)(52116002)(44832011)(5660300002)(4744005)(9686003)(7416002)(316002)(55016002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?faQeBqK/O9tTuOiFalzoCDKVlzMrh4ZRjuh0woqcTKyX14xSzj3UYjTeukbI?=
 =?us-ascii?Q?31+OPbXU7Bw2PWCeDQJFTMOwlg7zMXVNjA468ot9kclFhSucb10jEJcIfgBK?=
 =?us-ascii?Q?4bqq2+FYmrk9XNbJ31lfTkLe+QBOJa5FkC+Kksz8PnPGtK4qVVsO8PCL7KgF?=
 =?us-ascii?Q?GJmi0QOmJpaOJHK2DeXZCdZ55px7012y5TAa27TEH6wcGO3fOF1WEqGt02np?=
 =?us-ascii?Q?cWTUaubiN6RKrZ0l0qiUXy5BoYup/BtsRJcsztpQPzXwcBArfobk6zrUO1e1?=
 =?us-ascii?Q?Zn7nHLZxEEVAdv/PmE9M9+DZMUb0ZsnNyHSw+23Gvw4dYN5DjfzhG7EHZlTv?=
 =?us-ascii?Q?dcYI4V0t8RxBQDqHsKSyj96OitH3+obHhH7pd6oLYOHaa38cR9F9CWXvmgCP?=
 =?us-ascii?Q?ejN6HEdKbR3tu7ONP9aSEfxb1b8Xzc793lNM06j7G7fU8V2MQhTEV73+JtGi?=
 =?us-ascii?Q?kjvDtQe24qpc6/Wooen2vJ2ZOpSiD6V63HO+h4qa0Fd8flEv4x1KWPKGuXEU?=
 =?us-ascii?Q?tJpVcMWBZe7Mr10IyfKBBJhLWUHdUcbTmhk0bEsCHacGzzTcWGAjjsOX/tZU?=
 =?us-ascii?Q?PVV5QCMxcGFhEEGGGBVjUCdpWq+ySvwTLsXBCQ8RlYaDuP3cRsVGE9FflRZ2?=
 =?us-ascii?Q?hl+SH45hkVDP4vyQt4ByTo36yRvgDpm6KFI14IGEPyKYTleae1xzsOb9KJMw?=
 =?us-ascii?Q?T/fZ7gvYBghD/wOT15U+sgvlXovIeRVI99aQ6Hw1XKWQAQfRvFgsZfWNNorU?=
 =?us-ascii?Q?zl0GPkNDqdIHPrQJBZoRFFvu+/0ZcGjo6fZZg66IO8FT1lxcpqA2VD1188HO?=
 =?us-ascii?Q?uKNWA1Suos8irMfhskhIOJlxoKNy3HBgsIKEL74HcwpGQKWdTKVKClm0d4Lr?=
 =?us-ascii?Q?oTD5iIkfTNyAm7oSUZSvke2462XqLqqc6AI3ot2j6L7p1EuGfZ4aY6YaPaXm?=
 =?us-ascii?Q?vdqUi7iQSRsVXoX2/q7LYfY8uzW2uui+4s08x+LijgAK55kOcj1JtT/SAIEZ?=
 =?us-ascii?Q?7LUQ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6f48bf2-2164-4ed0-cb3a-08d8bc2f9070
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 04:06:15.3186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZ1FlQRxV2h2v0Dm53/r06w0h7+D3xeeQiHVfTZlJpRu6iHqngam8UO4i0+PCLmiWHDlSgZBKXxAvXpj348xbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 05:55:54PM +0200, Andy Shevchenko wrote:
> On Tue, Jan 12, 2021 at 3:43 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Define phylink_fwnode_phy_connect() to connect phy specified by
> > a fwnode to a phylink instance.
> 
> ...
> 
> > +       phy_dev = fwnode_phy_find_device(phy_fwnode);
> > +       /* We're done with the phy_node handle */
> > +       fwnode_handle_put(phy_fwnode);
> > +       if (!phy_dev)
> > +               return -ENODEV;
> > +
> > +       ret = phy_attach_direct(pl->netdev, phy_dev, flags,
> > +                               pl->link_interface);
> > +       if (ret)
> 
> Hmm... Shouldn't you put phy_dev here?
I think you are right. We may have to add
		put_device(&phydev->mdio.dev);
It is missing in phylink_of_phy_connect() as well.
> 
> > +               return ret;
> 
> -- 
Thanks
Calvin
