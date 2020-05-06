Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4281C70C4
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgEFMtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:49:23 -0400
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:13829
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727995AbgEFMtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 08:49:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtK4EGp++OBjN3nwZjSQXHaVMG8iZ7qkEaq2qVI3xECOHIEfKv6x9GyZiYoRPqGNQ4npCVdgUFXO4jpT8bL3lZeK339CUMXuXAOT5QehiQK2HlUIQK93auagX8RKWFsS7Gerj4VyIG5mvpl3qXlIJuD6NM7vG/yS9R/9bRkKXKwnVHP0hj2Hp9/1gMUBCiR8QNCKYxsIyA17F2DeDvBwGJ1uONwXEzIKm2B1QT3s4y+LFiob2CYIF+iz9Ms8aeO36ra/K2ZxAfOxQLkOyxF1EaPTVk2kYbS1BG1YcUJ+Xx7OHG5F41mD9Mip3FHvXYm8Ugo3+3ymv1KiwPSPCZY7kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uJDswV5gMumQlJf2XFKQ4qGMs0QcwMzzBxTz5Si5ZE=;
 b=g46h0IYNqslNmZpJn31Sl77U4/zYDw/M+BhBpOFxhMIu7xoeVgGnGJzywON7QwtxEq0dGYAf0961AD99Xiculw7Gu4y28D3rKTDaDZRaupjmpOGzRh+DrlzAhjhCSoeU40BAO93WQYGLFqEkaY7YtQKmQfPu+D5y1oKFMeons/RTIffIZ4WuNpc1S3nbjSoeygpK2bK+/WuvlNHFDLxIBeXCp7Ao00dkVksVmHlS9dse0FsB2ZnQMiTAOz4W1EyzvDGShD7fzubzjSxMNfSSin53YB3xXQr2dT7dPghpf9crJ4dWFgkypBVLFfFF2mPW11Ja3NQjvjoSZwjldaxLhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uJDswV5gMumQlJf2XFKQ4qGMs0QcwMzzBxTz5Si5ZE=;
 b=AqansJaJA5Dqe1wZd8LZjOTrJ2pzSR661JSi3HjjLsQBA/4W/RKIoZ0lfbKIJpMP8ifSoU40x/uz7QlgkxoRTKwu0D72uaMylmGMJ5eDnTlGumDohjCr0LslseQUsxo/yhYkpaOakTKOH/8B+I/jKvpZLzVHllyXiFqbNUu0h9I=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB7026.eurprd04.prod.outlook.com (2603:10a6:208:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Wed, 6 May
 2020 12:49:17 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2979.028; Wed, 6 May 2020
 12:49:17 +0000
Date:   Wed, 6 May 2020 18:19:02 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, linux.cj@gmail.com,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v2 0/3] Introduce new APIs to support phylink
 and phy layers
Message-ID: <20200506124902.GA20867@lsv03152.swis.in-blr01.nxp.com>
References: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
 <20200427135820.GH25745@shell.armlinux.org.uk>
 <20200427143238.GA26436@lsv03152.swis.in-blr01.nxp.com>
 <20200427144806.GI25745@shell.armlinux.org.uk>
 <20200429053753.GA12533@lsv03152.swis.in-blr01.nxp.com>
 <CAJZ5v0g4oaDGGk1Jg5rihaG1kj1BYHpZpwTFrXX4Jo4tettbgg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0g4oaDGGk1Jg5rihaG1kj1BYHpZpwTFrXX4Jo4tettbgg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR0401CA0009.apcprd04.prod.outlook.com
 (2603:1096:3:1::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0401CA0009.apcprd04.prod.outlook.com (2603:1096:3:1::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Wed, 6 May 2020 12:49:10 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 71580222-42a5-4607-9a0a-08d7f1bbe2fb
X-MS-TrafficTypeDiagnostic: AM0PR04MB7026:|AM0PR04MB7026:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB70268AE199C9C21088C0F3F3D2A40@AM0PR04MB7026.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96RXI6FfnOApmi1q2a3GyMZrWnieOV+vsChuAe8Ck0iZ6CqCsvyt1uY9PV1n0/WXvcG7qkx+JTcZmlesIyWWGIO9KgM6lV9k5c3PpgZ1Q/EPZCwoA745RXBbx8r5Ykq01mLBSjs/RyHzzi0/5rWlbW0JqtrbWFcxUaeNSfVmQnwV1chl0Vt7Dv6VDyOO39DJ9T6sbGkxv/d+DBxf+cJH+SkI/N/N3Wi2PkHUmrqIyZcPZU2BX7IqLNrMO3pYAfOqg1Ha6aRRmign/vo147mqKrIIu4I3Fvv8mzlGvtHoPcxvsesaYwjoFfYk0miGnlssWVaEnnWMsoEWiimOWyVds7cIjlmgeM6i0zuQ8qnxH3n0z//z45bJ0Qv70Jydh+KU0Ir3SnjmeavpdlhngGVeAVJrkIHBearl7duhFYU/cQJBltcXs4YxyQ24YLi+1SlxXm3Fa+Bum9ye47c9plewbSOqZKey46lEmt501eHGl0zNiKOG2g4BC8ojWf15+DBYsIUHNfCmpb+yI9Bw5EGzWiMcZyKb1bk3TRnmNVLRBTBVzed1g0StGTo0g4oip0//
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(33430700001)(55016002)(86362001)(9686003)(8676002)(7416002)(1076003)(1006002)(53546011)(186003)(7696005)(6506007)(52116002)(54906003)(26005)(55236004)(33440700001)(8936002)(956004)(316002)(6916009)(6666004)(16526019)(33656002)(5660300002)(66556008)(66476007)(66946007)(478600001)(4326008)(44832011)(2906002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: m4mIYkUL2RF/EJZXrAyzGFTXDYnjAUxrHglBeC+WmHhFAXv6ocEBZ0irI5crNsHJd4wa3CCj8u2U4qqrw7jYv6VXS9m/nYvygrJl6e8+xsG0MhPX0/7oaPYutqDFfZ5B4iq8sWUb2l1S8xSQ3vR5Pya9l/lU+RuXJWiVWkrl8UdZQTHHyAch0GhbtDz5hjBMMOJnkWahp6I8cPXPdNVtLmLMUgzxzVnR8fTcpgcSySd+DoeNID0SpvMOZ+ATf1QuQIiPc1ArcZHaInmHtHqZ26pNoci02mv6AMh9vuvlOHyl1FaCTrKg9CF9LVPhWV0FY3Uwz+pMdNO5Xvk4ykAnU25a/Op3b9ItzFrTWJWkRX4KqzrF6cGk9yakHkH4LxPoIjN1P6om/gnYxiMdoIgwlzYi9T4928gYiARCTmXxUf8lKJcWRVre/8m74jeOX7EQmOXRzvtSMBDNKKTDA3l6hqyhV9jGAmFuWp2jpkKCr7FdLgyB7Bgk5JXQC3UlU0X1mi4k2qdvYPUq497yCEmGnq4ZH4c1TwJDRJd6c43KJxdxppL2JCRV3O1MG9ITGM7tCXM3lSEEOe/VVE3/pfHeg7BmCJySDbb14o8ZN91otltlt6A+9VRSDwOhUTbef2v5Ab/Yym8D7sxWYatBsj50kd+w9Jkg/DFLVxaQ8PIVqsJTvpv8EwHL693d0AjIFJb4SYmuoopKUY6CrcXNtjmT9YLZ+lzPWj6Yk6YXh55EaI5bSHm94fNVOQP+lVed+zdG8ammx18INHI8UOGntP6tO0n9h6DFvN+5n0mOxeBcKz4=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71580222-42a5-4607-9a0a-08d7f1bbe2fb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 12:49:17.0969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AUqX3Qe/pekQV1M90ZlPsxh+dEni89YXgoeeyEKRIFLD8FqVGiQldipIcqzkJJWAVudRZ7XCqpHlIC3U/fZj0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rafael,

On Wed, Apr 29, 2020 at 12:26:12PM +0200, Rafael J. Wysocki wrote:
> On Wed, Apr 29, 2020 at 7:38 AM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
<snip>
> > > So, yes, there's another driver using it, but the ACPI folk probably
> > > never got a look-in on that instance.  Even if they had been copied,
> > > the patch description is probably sufficiently poor that they wouldn't
> > > have read the patch.
> > >
> > > I'd say there's questions over whether ACPI people will find this an
> > > acceptable approach.
> > >
> > > Given that your patch moves this from one driver to a subsystem thing,
> > > it needs to be ratified by ACPI people, because it's effectively
> > > becoming a standardised way to represent a PHY in ACPI.
> >
> > How can we get attention/response from ACPI people?
> 
> This is in my queue, but the processing of this has been slow for a
> while, sorry about that.
> 
> If you have a new version of the series, please submit it, otherwise
> ping me in a couple of days if I don't respond to the patches in the
> meantime.

I've posted v3 of the patchset. Can you please review?

Thanks
Calvin
