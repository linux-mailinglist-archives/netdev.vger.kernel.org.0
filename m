Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6914A2DDE73
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 07:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732695AbgLRGKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 01:10:36 -0500
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:3878
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725870AbgLRGKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 01:10:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pppsu6MkMkBemrQU6kM5uGHusfy4kHvCEz9q+1vhz/0le1AWaY9AQmIETfsNkwTlEwooFmh8mf37DGmubzHf4ZNyBldxLYxFMTvVKvwurHNi3Q83uGcKsHmFJ4DVPDv9GYx36NoDdd82bXHZ9bH06scWoj+VGLYQPJFODshZZxTcyasqynHPapgnkCFqc8UWYZC+KHoQ6wczrJkX7aaQqUnhMhJahQbCN1ISo0clfuAT9adwmHCMNr8mV3COaeuQbkaY7rGeu9jI6RIj5M1azNIUv4qDkJio/q1R8YLEDRBxI3fY17YTQissbN+/0GECVy12fqGffuTc5Z6HIIXjGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCIoVr4Ydsy04Bm/04//oSehpABCC/p7CWWSeGKjg9o=;
 b=UitINj9WrXMtd+Z6/j1gmGAj7zY5eDlBnT2c0JdKkE6qJFsCOuARFHmZv/r20vp6GdjaML3hFu5kgq7mpq/mWU+mwCx/f6Bu02KVKJOTmJ6LKfHzykpp+6UuUujTt1VCpkd/GsiNQ1pxu1CB2DMSH/km4pkaUEprO8RqmwUK9jKhlty6EGl2mgmhLhRN9zxIbNLL/w1uC7pRINoRVUT8+wm0dIVWjKamvjblTuGmP4Png2i/qkjj1UF90CYGBy1HNHMC4hDCagmFKXp3J+pKkZI5e/RrMNC4LJw5nY0f1RW/0bLVy/QKO846FELdO+719WgLA2H+xHTrmTM7S4btWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCIoVr4Ydsy04Bm/04//oSehpABCC/p7CWWSeGKjg9o=;
 b=mT2lb5IegwaQ/nEDCz+ddJB3Si+e/8sJ0SBBLuG4Qt0jz/QBe7qUpKcMmMTFUcKM/7rXcOWbiHqqfP0zxTO6zgJKlFmHR/VIqZw5tg7CKqjyHTahRyP7SEg6Y5iCkMGuvA/Z07ijCjjmhLL75xzeSZ1tNKZJ7O3UFfm+ARVwuvI=
Authentication-Results: ideasonboard.com; dkim=none (message not signed)
 header.d=none;ideasonboard.com; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7364.eurprd04.prod.outlook.com (2603:10a6:20b:1db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 06:09:45 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Fri, 18 Dec 2020
 06:09:45 +0000
Date:   Fri, 18 Dec 2020 11:39:32 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
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
        Jon <jon@solid-run.com>, linux.cj@gmail.com,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [net-next PATCH v2 10/14] device property: Introduce
 fwnode_get_id()
Message-ID: <20201218060932.GD14594@lsv03152.swis.in-blr01.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-11-calvin.johnson@oss.nxp.com>
 <X9jrrMJIj2EQBykI@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9jrrMJIj2EQBykI@pendragon.ideasonboard.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR03CA0160.apcprd03.prod.outlook.com
 (2603:1096:4:c9::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0160.apcprd03.prod.outlook.com (2603:1096:4:c9::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.19 via Frontend Transport; Fri, 18 Dec 2020 06:09:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 43e2213c-9574-4c12-9dce-08d8a31b84a2
X-MS-TrafficTypeDiagnostic: AM8PR04MB7364:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB73640D2FA196FD0BDF0D03BBD2C30@AM8PR04MB7364.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rYnG0CsAq0QBifkYQqnho7Tkd+C1pGz/p3haEain33CE1ZR2gU0CNw4eTLzZpzFKdT1d6aNPqBN6k5Eplhiq14C9mLok/QUXmqxcbIfCerWFNaE6HwOMrbGS9abfo5gHeuoNdNRuZorOVR1kqT3jP/xTYQfBgNn8HEASDCC5HO5/EEbk2phGYNlP5FW0RYEasZuD0fIOrLDoUGW5/96z/XzmkGjTuWqSEbLgGHMK14Jmse7IOsJ9yrNgfPGoG//nXdf6S8wtCHQ4hWw/hmc+BWOIjJi3X/9ukLyE0+8vwGMTBAgdy7qwkCyhPSRTW1L99XWziZW2bZU32PyKHSORL/4dnagIedeUlIvzj9QTy6Pmy3YE8L//jOuyVmOjFzkr9kgvq0ciygKfF3Q20J1IbWhxs+7/t6jR8p5LhFyBwNLHZZv6UK+2kRbRLreJb5rd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(9686003)(4326008)(66476007)(83380400001)(54906003)(86362001)(2906002)(5660300002)(66556008)(8936002)(66946007)(55016002)(956004)(186003)(6916009)(52116002)(26005)(44832011)(478600001)(7416002)(6506007)(6666004)(55236004)(1076003)(33656002)(1006002)(7696005)(8676002)(16526019)(316002)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qN6oZ3nKxrDLKmBTbw0F8Tp9Lji8X/UeKr5CwogdVUbK5qV/6NiI4UtEyerh?=
 =?us-ascii?Q?MC8RTPxWb311FKGAipg99XhjGBAKnOuZliuejxzGnxOH06CVBIPeRAlVzIOn?=
 =?us-ascii?Q?tWD6gk/BcIXPd6tpRDSiqHwLO4yk53Jaweu65CvbMi2Y9fjPsozdEKOGw3V+?=
 =?us-ascii?Q?k6dualX7pEe9kq4j0szCJeEKFEKAHagSS7mDKRt12YJhSPBCeTM4k3KZZ8lc?=
 =?us-ascii?Q?/eghTIi6nGqHCGzQ6Rqw8Et9f9CfqoCbOHJhf4wK7974mZaLNQ8KfkHAiTok?=
 =?us-ascii?Q?U24+5O/uZz0+UPsXY+XpZ9fMzgrjtrSi9SeIkZyYsr6aQS9B3iKBzI/15ed2?=
 =?us-ascii?Q?LXN/a7ES9Wr3ZFipSHjjcwH4K5H8nzO37SW/6IJ2V1ny5Uep6oi0JzZOhAYV?=
 =?us-ascii?Q?E4M5RJSDRB5rGJILSG1aVkOGTgrJDLf8UQ2G705R//iHwFcCIwq00up5Ky0h?=
 =?us-ascii?Q?ibysnKcsfBxM9ac9+wGeQ3tQ18Bjf2/nW1Bnn9pWjBW6XTlyXaUceucsnWHO?=
 =?us-ascii?Q?jOZLag9wEkd2vPe90zPTGsNERu1O1iJdpMx/+tZLfl4YfJAISqEHaIV18Vaq?=
 =?us-ascii?Q?nOfZkgzXUi9h3O5oL/QnJwISQSUmTo5oXd4Y5pM9p+Y8vJ581INzdmH98NWQ?=
 =?us-ascii?Q?uvsPTtC9HdfaiJYOA3QUzGWGs9LhP4JGPt75UwuIp3BZFCbyuz9DLLyRXtPs?=
 =?us-ascii?Q?jkHDzi8Gq/efdosyvfalBCjXGDI/nDTht96TH1nf/gPVJ4v8+UalEoUqpaWh?=
 =?us-ascii?Q?1wQUG5zWmYIfWeC4DapkXOvSnwNaRhWCys87DM+j/G2lXwqnNA4z72m/M96O?=
 =?us-ascii?Q?Xv5LIgtnWyl/wl+gEff/RMU9mwVCTXUtpaAeH6r5fLaz7hZmNQ5v7lcWii/s?=
 =?us-ascii?Q?wALE3krvrX8PlGOQtazOlVnyQAa42cBP6u6NjyXE29A5+wqddjoqIW136UDY?=
 =?us-ascii?Q?4wmW5ps1lHfuLKtmJTs2+SMvHJuTApcUPuNVLGkMw2TWGPwEJMl2oaQJ/Sto?=
 =?us-ascii?Q?6lYG?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 06:09:45.6370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e2213c-9574-4c12-9dce-08d8a31b84a2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQ+Zm3HF+3Y1O81V1sVYxJMlg4SfKnPUXOfoQicIxhJZ914nzRF6tk+F00tRNOfJRlFH3984rZBtgsVECQZHdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Laurent,

Thanks for reviewing.
On Tue, Dec 15, 2020 at 07:00:28PM +0200, Laurent Pinchart wrote:
> Hi Calvin,
> 
> Thank you for the patch.
> 
> On Tue, Dec 15, 2020 at 10:13:11PM +0530, Calvin Johnson wrote:
> > Using fwnode_get_id(), get the reg property value for DT node
> > and get the _ADR object value for ACPI node.
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> > 
> > Changes in v2: None
> > 
> >  drivers/base/property.c  | 26 ++++++++++++++++++++++++++
> >  include/linux/property.h |  1 +
> >  2 files changed, 27 insertions(+)
> > 
> > diff --git a/drivers/base/property.c b/drivers/base/property.c
> > index 4c43d30145c6..1c50e17ae879 100644
> > --- a/drivers/base/property.c
> > +++ b/drivers/base/property.c
> > @@ -580,6 +580,32 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
> >  	return fwnode_call_ptr_op(fwnode, get_name_prefix);
> >  }
> >  
> > +/**
> > + * fwnode_get_id - Get the id of a fwnode.
> > + * @fwnode: firmware node
> > + * @id: id of the fwnode
> > + *
> 
> Is the concept of fwnode ID documented clearly somewhere ? I think this
> function should otherwise have more documentation, at least to explain
> what the ID is.

Agree. Will add more info here.
> 
> > + * Returns 0 on success or a negative errno.
> > + */
> > +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> > +{
> > +	unsigned long long adr;
> > +	acpi_status status;
> > +
> > +	if (is_of_node(fwnode)) {
> > +		return of_property_read_u32(to_of_node(fwnode), "reg", id);
> > +	} else if (is_acpi_node(fwnode)) {
> > +		status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > +					       METHOD_NAME__ADR, NULL, &adr);
> > +		if (ACPI_FAILURE(status))
> > +			return -ENODATA;
> 
> Would it make sense to standardize error codes ? of_property_read_u32()
> can return -EINVAL, -ENODATA or -EOVERFLOW. I don't think the caller of
> this function would be very interested to tell those three cases apart.
> Maybe we should return -EINVAL in all error cases ? Or maybe different
> error codes to mean "the backend doesn't support the concept of IDs",
> and "the device doesn't have an ID" ?

I think it make sense to return just -EINVAL. Will take care in v3.

Thanks
Calvin
