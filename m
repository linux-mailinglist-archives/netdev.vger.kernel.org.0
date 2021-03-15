Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359E733AFE3
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 11:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhCOKWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 06:22:44 -0400
Received: from mail-eopbgr50041.outbound.protection.outlook.com ([40.107.5.41]:1151
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229507AbhCOKWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 06:22:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzznvXC5/pCinRM2mdhEKD16t0dmXXlRUmx9VXcLG6kB2zUBLjFij5CHfjHYUK6AGscqW/UnloGXUNtu0UGihxLqIjIQCjVbpuci2lkv+92RG7JgVuWZIZqVM3km0RuV+5NPKCTDHleL/BzlJHIA+rxxP2qfALuUre0/1s+fM/FAStdH5FN9z3jyCXmW2Uod/f+cEQoTZ4g75jZI9c71ws9UL2G2keBty3ARNezGbwFEwe6kxziYmXuBbJzvb4GDZ/v9Fb5+3nEYch2h4fyKs/8YVhncS7lvyDDXDpoRAOaPaL9FsiZTir111qBG7CvLxnpCftpNT4OOuR8eJBMvKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFBEhhGsoLe7vS/R9SceTJGUVJPHSMyw8HAqBt0jzZo=;
 b=VWjN2H1kvrCXKX3x8RNddWQ/IUCdlKJpw7ViTdG7EuIlIJ57QLx1K+bJQ1NXG+vAecMPcUcMDd7Et0hPc7bXzRb8EY+6d7febEP21nIGeEMKRE9m3sHtSm8rFHmLL+BtGPvCwxB0VTgbYXR9KUP+8EhVBmTX3OazAbnpfMGPirL6BVAALis0dWm9M3eN2P+3pYK5RXhn9EF7H9c/DhVQCf10l24W0YdTLKDp558rwrIMEP3aaC+Ii5qi5Diu9z9QW1pRkxIaANNGUQO/ri6NBIG5fsq9bd7sMlM1kEO0e1jx5DUesd6Kfj2XnI5f8pL19rvN1S/rhm9w+vTgiiPITQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFBEhhGsoLe7vS/R9SceTJGUVJPHSMyw8HAqBt0jzZo=;
 b=CgpCYIz3HbGWyMC5YzbH5PEWuWkaZOkp+UO4n/fpTG2XPQkpXUfh/xqQMGfVmSj08peJimJ4Rj1p14KsE+yibXEta2iQvCFueVV516v96Xf/VbqYbwuyIgqdicL5U4AxZprrdW26X6aH7RelP3+0OcyhZtTK8/qU5ax2DtBFeDc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM9PR04MB7683.eurprd04.prod.outlook.com (2603:10a6:20b:2d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 10:22:11 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 10:22:11 +0000
Date:   Mon, 15 Mar 2021 15:51:52 +0530
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v7 11/16] net: mdio: Add ACPI support code for
 mdio
Message-ID: <20210315102152.GA14002@lsv03152.swis.in-blr01.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
 <20210311062011.8054-12-calvin.johnson@oss.nxp.com>
 <CAHp75VcDzMGgQDWeqR7hxnHXmfobR-CbwcmuMoE57ZMwvNQQ3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75VcDzMGgQDWeqR7hxnHXmfobR-CbwcmuMoE57ZMwvNQQ3Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: MA1PR01CA0103.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by MA1PR01CA0103.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 10:22:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1c572b49-1794-4453-dea6-08d8e79c31c2
X-MS-TrafficTypeDiagnostic: AM9PR04MB7683:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB76838F2D2BEDF36D01CB600FD26C9@AM9PR04MB7683.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CRu42ObSPprDQr3om72c1HYQ4YOjKLojHDLKcaWdzvATBUzs95jZ9hlMEAAHWnoyeYIbVjMr7ogsfWJmgbhrF3NSsfYp0xELh7ri9ua9H3b4kBANTXwcrsWuTTDUwlyKuovWBG7DJY5oTtA9bBc/F/hTh/R4UkWHeA3OxfYQc7KLRTWh+lL7ThRb+qmpMLJNJZ4amA4k1tS07NUVQJ7sYjzlJJYmMlLB9Dt+j6xeQixTShkkX8G35U5m7/uUOmWzkeFoO5O9yyprCPQkQMg/x2nqRBjlC2h8jxvZc5v39D98FkOt3kkKj3J8IWIHQbUjkt2Cj/2JfNorI73e8AessXeHvIGIFAhcZajp8t9ZIPMOuGxhBqcl4lecmV/7rQ+ERULzviM5sw+B+VgN7o6ohRSSXl90mh4mbvkazNf0JcvdL9jxCq0DzcjeDe1Ygt3S3q4mdM+o22FSyWl78OHZk6izrg7xDQAYGntGlqNb3xqMOTntVb6dAaSKs2pzZvwUmjNK3KclC9e0ksJ0UNHCQkiy/rzfS696IlJEVX4Q+Vdb9vjfKE4+ufnfNpQauYUzpmGHprGhHnsyI/7HyrkL6jsk3qkpv6frme2fJ+nAy6Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(86362001)(33656002)(83380400001)(6916009)(55236004)(16526019)(1076003)(66476007)(44832011)(66556008)(66946007)(52116002)(4326008)(956004)(316002)(53546011)(8676002)(6666004)(54906003)(9686003)(1006002)(6506007)(7416002)(478600001)(2906002)(186003)(55016002)(26005)(5660300002)(7696005)(8936002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dEFHV0dUVE1kZy9mWGl4dGk0M1YzSVVUZjZMTFBtSUt0aVcrOTZwQTU0ZW5v?=
 =?utf-8?B?SW5LSXVnVDM5Z1MzakM1M09md2hqWkZOS3ZnUkZVbm9UM3ROM3NQRWRES0Rp?=
 =?utf-8?B?Ulg3S2dzU3p5Q29CZzQ1d3RzU3pXSWpsZENybzM5WlRUS28zM05FRTJTY0ll?=
 =?utf-8?B?Si93enNicjNBeXZjSG05TDZDNC9PczJockY5eEd0Y21xeU5jM0k0MmdSalBn?=
 =?utf-8?B?Y2g0M3ZKV2dCS2RFekM3cTlFRmtVbmZxdjRPNEdlVGptNlhtQ3A2UkR4UkFH?=
 =?utf-8?B?a3Q1QUN4N1JxSEdyaUZjOE45YXZsdHJpdSs4cGNqZ2NxVE5GZGpraXVRTkVm?=
 =?utf-8?B?WHcrZnZMSmd4SFM5MVpiT3RVL1hvakFnODJlL3djb0JtdTVxYXVSdHhac0s3?=
 =?utf-8?B?aDQ2bnV2cVR5emRzdy9LK0dmVm53L1E2Rm9STVUxLzZzZDI4ZU1WOGFoV09O?=
 =?utf-8?B?Z0kwTWx4SHNGNTRYanJWL0daWFdrTy9TcEJDT0FzTC9OY3FYcHl3M2FreU1w?=
 =?utf-8?B?WjRZbGxPNG9hWVhjRWl4bldwbVNRQ2oySkJxZWZEQTNCYUtNV2xYTmVHdjRR?=
 =?utf-8?B?OFdabFlZRitKMlQyMlhWczgyZlBRVFdhRUVxbWZBZ3lNYzBIZDdYOEUrUUNz?=
 =?utf-8?B?ZWNCWWkyd1FNMGQvNDI3dEw3QnNRSEZ4aW0yK0VMSU1lM3F2WVVxNjlBRElw?=
 =?utf-8?B?QUNyTDlYd1VrTzhXZmp4SWNvNThsRS9DYmxQekVRR0JWVE81TW1scmpBZmVG?=
 =?utf-8?B?U0ExMUdnVnduNk9hdEVWamZhYk1BUTJQYzJkSUVuV0tUdnJPemFrUzZFbkpu?=
 =?utf-8?B?UTluMWQyL0xaRkpuL0x6VFpXMmdCbkRTbmRFenVPMDQ1c2ZmeHRjSmVad0da?=
 =?utf-8?B?WTFOMGFIRDQ2N1VFcUZidTI3ZitWOHJCUXZzSmVsVGpGYnB0NEkvWjVpaDlV?=
 =?utf-8?B?V1Y1TTFXcmpjQWRlYkh0aHkza1NROVlKMDJ4RXhPVkR3QmQyL0cvTTdxMDJB?=
 =?utf-8?B?SkdGaGdRRGNuUC85aGJ5eElEU0h2Lyt6NVlBcmNnRUE3VWNndlgvT3IvdFJW?=
 =?utf-8?B?NEVBWlVNVnVPWGtMWlJpSUhhNEp0VCtXanQ0M3M2dFJkUWFRVEhCakFxVUpC?=
 =?utf-8?B?aXJnN0EzZ1o1Z3pPTit6WFFvUFZ3UEdldVpFZVFSWmY3akZ0RDlUTGZUQWd0?=
 =?utf-8?B?eEgxMGlJK3IzTGttN0d3anI1aHdNaWZQaFhjUnMraWhoRnhpQ1krbzhEQ3Bm?=
 =?utf-8?B?R3B2REJ6OW9mbC8wQTExS1RMRGcvWktYcmN6SjlGZkU5VjBkZC9Mc2FoUHpB?=
 =?utf-8?B?elNOSEZWZXBTNFFncjIvUCs1Z0RLU1FWZHNvZHNSMVk4L3RZVTg5U0lXUUdC?=
 =?utf-8?B?STAvb3k4aGRVRkxYRWxQdW4rT1M2ZkI1d25QMG9BcGJ6QWJ2TW91OVBnT0tr?=
 =?utf-8?B?TFZSeTg0dmRhOExsbGF2am1CUmFWUURab1V4b2o1OERJQzNtWW9QZVNuNzdE?=
 =?utf-8?B?NlNmQ2xQU2R0b1VNbGhNSHZseWpZTGpmTnprR2lOaHBoa3VUSS8vQ3FHNnpw?=
 =?utf-8?B?TFJtczlmZjdETVNYLzM5Qy9lOUpNZE84YmxrdXZYVGpjOG1oNU96ZFYvV2Zt?=
 =?utf-8?B?TkZCTW9kVkZUZ1pVSytmU1hFZW9vdWNmUk5yeGdqVWNjcDE2R01QYmFtdUxP?=
 =?utf-8?B?VmFBVTJEQXhtOWhzMXl2Z1VpcENkU2RPei9mRWZPMmFSa0VmR1ZkKzBSV2Zw?=
 =?utf-8?Q?D769nyaFdk7o04cK1wRvR/YJ0ZAesHEevsIFzRM?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c572b49-1794-4453-dea6-08d8e79c31c2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 10:22:11.6469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FU9ZsdxVLS7KenmH91/lHXpAWyhp/o5sHsUMvqJ0RWDElPAP33rF1nYbybgfKeO4sPXvlE/fcjvC1BcH6n4Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7683
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 02:14:37PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 11, 2021 at 8:22 AM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
> > each ACPI child node.
> >
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> > Changes in v7:
> > - Include headers directly used in acpi_mdio.c
> >
> > Changes in v6:
> > - use GENMASK() and ACPI_COMPANION_SET()
> > - some cleanup
> > - remove unwanted header inclusion
> >
> > Changes in v5:
> > - add missing MODULE_LICENSE()
> > - replace fwnode_get_id() with OF and ACPI function calls
> >
> > Changes in v4: None
> > Changes in v3: None
> > Changes in v2: None
> >
> >  MAINTAINERS                  |  1 +
> >  drivers/net/mdio/Kconfig     |  7 +++++
> >  drivers/net/mdio/Makefile    |  1 +
> >  drivers/net/mdio/acpi_mdio.c | 56 ++++++++++++++++++++++++++++++++++++
> >  include/linux/acpi_mdio.h    | 25 ++++++++++++++++
> >  5 files changed, 90 insertions(+)
> >  create mode 100644 drivers/net/mdio/acpi_mdio.c
> >  create mode 100644 include/linux/acpi_mdio.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 146de41d2656..051377b7fa94 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6680,6 +6680,7 @@ F:        Documentation/devicetree/bindings/net/mdio*
> >  F:     Documentation/devicetree/bindings/net/qca,ar803x.yaml
> >  F:     Documentation/networking/phy.rst
> >  F:     drivers/net/mdio/
> > +F:     drivers/net/mdio/acpi_mdio.c
> >  F:     drivers/net/mdio/fwnode_mdio.c
> >  F:     drivers/net/mdio/of_mdio.c
> >  F:     drivers/net/pcs/
> > diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> > index 2d5bf5ccffb5..fc8c787b448f 100644
> > --- a/drivers/net/mdio/Kconfig
> > +++ b/drivers/net/mdio/Kconfig
> > @@ -36,6 +36,13 @@ config OF_MDIO
> >         help
> >           OpenFirmware MDIO bus (Ethernet PHY) accessors
> >
> > +config ACPI_MDIO
> > +       def_tristate PHYLIB
> 
> > +       depends on ACPI
> > +       depends on PHYLIB
> 
> Same issue, they are no-ops.
> 
> I guess you have to surround OF and ACPI and FWNODE variants by
> 
> if PHYLIB
> ...
> endif
> 
> This will be an equivalent to depends on PHYLIB
> 
> and put this into Makefile
> 
> ifneq ($(CONFIG_ACPI),)
> obj-$(CONFIG_PHYLIB) += acpi_mdio.o
> endif
> 
> This will give you the rest, i.e. default PHYLIB + depends on ACPI
> 
> Similar for OF
> 

I checked the effect of y/n/m choice of PHYLIB on FWNODE_MDIO.
As expected with def_tristate, whenever PHYLIB changes to y/n/m corresponding
change is reflected on FWNODE_MDIO, also considering the state of other
depending CONFIGS like OF and ACPI.

Symbol: FWNODE_MDIO [=n]
│
  │ Type  : tristate
│
  │ Defined at drivers/net/mdio/Kconfig:22
│
  │   Depends on: NETDEVICES [=y] && MDIO_DEVICE [=y] && ACPI [=y] && OF [=y] &&
PHYLIB [=n]                                                          │
  │ Selects: FIXED_PHY [=n]

Effect is similar for ACPI_MDIO and OF_MDIO.

So instead of above proposed method, I think what you proposed in your earlier
email, i.e, "depends on (ACPI || OF) || COMPILE_TEST" seems to be better for
FWNODE_MDIO.

Shall we go ahead with this?

Regards
Calvin

> > +       help
> > +         ACPI MDIO bus (Ethernet PHY) accessors
> > +
> >  if MDIO_BUS
> >
> >  config MDIO_DEVRES
> > diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
> > index ea5390e2ef84..e8b739a3df1c 100644
> > --- a/drivers/net/mdio/Makefile
> > +++ b/drivers/net/mdio/Makefile
> > @@ -1,6 +1,7 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  # Makefile for Linux MDIO bus drivers
> >
> > +obj-$(CONFIG_ACPI_MDIO)                += acpi_mdio.o
> >  obj-$(CONFIG_FWNODE_MDIO)      += fwnode_mdio.o
> >  obj-$(CONFIG_OF_MDIO)          += of_mdio.o
> >
> > diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
> > new file mode 100644
> > index 000000000000..60a86e3fc246
> > --- /dev/null
> > +++ b/drivers/net/mdio/acpi_mdio.c
> > @@ -0,0 +1,56 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * ACPI helpers for the MDIO (Ethernet PHY) API
> > + *
> > + * This file provides helper functions for extracting PHY device information
> > + * out of the ACPI ASL and using it to populate an mii_bus.
> > + */
> > +
> > +#include <linux/acpi.h>
> > +#include <linux/acpi_mdio.h>
> > +#include <linux/bits.h>
> > +#include <linux/dev_printk.h>
> > +#include <linux/fwnode_mdio.h>
> > +#include <linux/module.h>
> > +#include <linux/types.h>
> > +
> > +MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
> > +MODULE_LICENSE("GPL");
> > +
> > +/**
> > + * acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
> > + * @mdio: pointer to mii_bus structure
> > + * @fwnode: pointer to fwnode of MDIO bus.
> > + *
> > + * This function registers the mii_bus structure and registers a phy_device
> > + * for each child node of @fwnode.
> > + */
> > +int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
> > +{
> > +       struct fwnode_handle *child;
> > +       u32 addr;
> > +       int ret;
> > +
> > +       /* Mask out all PHYs from auto probing. */
> > +       mdio->phy_mask = GENMASK(31, 0);
> > +       ret = mdiobus_register(mdio);
> > +       if (ret)
> > +               return ret;
> > +
> > +       ACPI_COMPANION_SET(&mdio->dev, to_acpi_device_node(fwnode));
> > +
> > +       /* Loop over the child nodes and register a phy_device for each PHY */
> > +       fwnode_for_each_child_node(fwnode, child) {
> > +               ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &addr);
> > +               if (ret || addr >= PHY_MAX_ADDR)
> > +                       continue;
> > +
> > +               ret = fwnode_mdiobus_register_phy(mdio, child, addr);
> > +               if (ret == -ENODEV)
> > +                       dev_err(&mdio->dev,
> > +                               "MDIO device at address %d is missing.\n",
> > +                               addr);
> > +       }
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(acpi_mdiobus_register);
> > diff --git a/include/linux/acpi_mdio.h b/include/linux/acpi_mdio.h
> > new file mode 100644
> > index 000000000000..748d261fe2f9
> > --- /dev/null
> > +++ b/include/linux/acpi_mdio.h
> > @@ -0,0 +1,25 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * ACPI helper for the MDIO (Ethernet PHY) API
> > + */
> > +
> > +#ifndef __LINUX_ACPI_MDIO_H
> > +#define __LINUX_ACPI_MDIO_H
> > +
> > +#include <linux/phy.h>
> > +
> > +#if IS_ENABLED(CONFIG_ACPI_MDIO)
> > +int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
> > +#else /* CONFIG_ACPI_MDIO */
> > +static inline int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
> > +{
> > +       /*
> > +        * Fall back to mdiobus_register() function to register a bus.
> > +        * This way, we don't have to keep compat bits around in drivers.
> > +        */
> > +
> > +       return mdiobus_register(mdio);
> > +}
> > +#endif
> > +
> > +#endif /* __LINUX_ACPI_MDIO_H */
> > --
> > 2.17.1
> >
> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko
