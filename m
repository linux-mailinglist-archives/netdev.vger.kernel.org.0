Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9239C1CDDFF
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgEKPAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:00:19 -0400
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:14023
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbgEKPAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:00:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeCImlC4chJMb3f5/Lfv7PlcFfdE/JY2gCx7Ruyztl1XbdKcl6vtjTbYn07fV8GewUneFqPV68aZzgDhxwqnEFeFl0JtJedTn7FOuCBhU44dGkflfVl/5loB021qzFUpMyq3BTolTkUz+Begiy5byXur5Gl1niPe4PfIr122WTtPqH9FLg/RifbYBwZ0w1Am0h+bdXJL+gKhKngkc9UEcTttzX0doeE3rdPNDbwxQPgjTWS+yrR2t2mZB6XgeR9ZHNEnAKsAzPd6mWN14Tx5odyn64rt++YQ7piPmgXQJb96ki1kZeG12/Lv4IfmMUXxm+a7+7WifXAi9y/+9uN1Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70kWKPa/VI0yZxSWLk1C9yAVONUDQb8EL+l77CagnBA=;
 b=iKD0G0tL8Xu5PknNLNRgeZ9PYmN4w6V3oTJcDDNkQe6MRCFoAwXL/SUeGIlhLrzovkmQSTy4p+KxJWx75BG3f4dcd/Owg1+KEJVFq2j/7VuM7GSMgqk4zfLzo7KoN617cxtF75qztyQ8tu3RW0PPKGZbwH1FJsbsKodyvwro7jwRYAM7tqammhiXLp6T6KoOrIXV/MCp/tqf8RLdkv+HfDQxIz8d8/yzWu9Qe0RuydjHXBF0YHJrnobeVDja/1nth2vZuScFTN2pnPU/VdWsFU9U1rTkcYTKica+WzYYKh/ztkQRh+6U0fGWewml8Wez8tUbOGd3akuWNRw3v16H1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70kWKPa/VI0yZxSWLk1C9yAVONUDQb8EL+l77CagnBA=;
 b=E9VmoY9dfWpdo2yy7Bu5JxSh99jwsFyR1i8liUvZ+/6IwPVesV0oEuKkjgCKLrXOnU3YpYZl3BKYBzFiYAJYL9s0HjbuYDqC8Zykl1smjzXfsQ9KlU1o3Y4ClmCGuwOroZiZSEt1y87d7ftzv2E7CnHzwUZ6vxP4VLrZOu22xaQ=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6147.eurprd04.prod.outlook.com (2603:10a6:208:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:00:12 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:00:12 +0000
Date:   Mon, 11 May 2020 20:29:59 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200511145959.GA20671@lsv03152.swis.in-blr01.nxp.com>
References: <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
 <1e33605e-42fd-baf8-7584-e8fcd5ca6fd3@arm.com>
 <20200508202722.GI298574@lunn.ch>
 <97a9e145-bbaa-efb8-6215-dc3109ee7290@arm.com>
 <20200508234257.GA338317@lunn.ch>
 <20200511080040.GC12725@lsv03152.swis.in-blr01.nxp.com>
 <20200511130457.GC409897@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511130457.GC409897@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0107.apcprd02.prod.outlook.com (2603:1096:4:92::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29 via Frontend Transport; Mon, 11 May 2020 15:00:06 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f99488bf-b96b-4f1b-dfd5-08d7f5bc015e
X-MS-TrafficTypeDiagnostic: AM0PR04MB6147:|AM0PR04MB6147:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB614796BB9D9D6F18379BF94CD2A10@AM0PR04MB6147.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPnk+ZAFs1/pxg0oRAIA9ZfT5uPDX7Y2pCUn0X9NQi3kndtcpTgxOpJBzT9wEXCJg56ltSbePrPHvXR6kEbq63RCwH1mSYHSx4X4rULI1glAOj64Ma2M2jAOqmgk2YTwrzdZXdoMweDZFO+1bcvwZgVCbug9EE7CdTPxmqebiqdiDq+kbJABZYDHSoZlwKTgiv830WLCrM9QRXC5sbXAxRAtm8vNfQ7FihITiOTwULnJ2NAAPs5CPAAfXnViiikSnztyUBf4k5BPBeRpaPrX92KNP/kdAyYV+AFHruvLRVkOoQGmoMsbqcZN/d3gBOHMwdcIgoLIJA+cMnX/1YFuRGtozZ7svR57k0VyEEh8WGM8yAeq4P/thNiNPW+arqaTozde4Az6l5g5iVloRCQkRNqp9e1CRJ8MDxy6AMcR0gLsxWMXaCNp2uc4K5I5TPWPnBNMvh3EpT1lCKCuFSjCyL/2FdyPTMLgnf12R/gQKWoASJ9qWiU4NspszUfCFYVMP/VPlOJnsGm05pFjESAjBw3g4ubQ/t9nQDB/YDSBP5eqbK1MSjkGQ+QVo5j7JvZL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(33430700001)(956004)(66556008)(55016002)(316002)(55236004)(478600001)(54906003)(5660300002)(9686003)(2906002)(8936002)(7416002)(66476007)(26005)(66946007)(7696005)(1076003)(44832011)(86362001)(52116002)(33440700001)(33656002)(6506007)(6916009)(8676002)(186003)(1006002)(16526019)(4326008)(6666004)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AxnNMDqn4TewmZcF9GaVqx1FUUanpeHZxNLG1kn3WGijGKzjcAqpUi9oygieQEObnQEZa5XmrRYMG9hXq3VZHrM19hA5WFCuTp03lDuwZT45tAi2YBloTkUwaBFiy45jqwVG9/ByuamU4u3SLfjpZ16KXVIu0kRO5ip8vXNQfTqqi99NITYEGd/bWUdmfvd5W/YfcXKjdnofmp3jsyD99/onlj74rOx6MufolbOCKRHyyhJsnlMyGjrYeXpGFLvPdB088alsdxAtiKFzLJ5Sd5wqVGVmcTzSMZKozz8cLNotZskTi46lYhZhRX6PVH4MIScl8dWjo81tF1ZjdodNLR/GSI/l12zse6S5OCa3g058lbjUAKA3mrS/OxUOZIYdNMqUUpF6XLlxejaGEW+OyQcAQQQrrI5YquKOjEn+4RWQyr1kp2SVxlDsQVIm6VYgb2tBcvd3S9Zj0FyIgV5exYvljeVgaTRSf48Nxw2l020=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f99488bf-b96b-4f1b-dfd5-08d7f5bc015e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:00:12.6483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojXa9cEsx+751jZY5Jg7MoiwH4uwqoQHjQSModpw1up5bSwcsCwYwQP4cLHUFe95jAiyTSRWUhiNoT7Kc02l5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 03:04:57PM +0200, Andrew Lunn wrote:
> > NXP's LX2160ARDB platform currently has the following MDIO-PHY connection.
> > 
> > MDIO-1 ==> one 40G PHY, two 1G PHYs(C45), two 10G PHYs(C22)
> > MDIO-2 ==> one 25G PHY
> 
> It has been suggested that ACPI only support a one to one
> mapping. Each MAC has one MDIO bus, with one PHY on it. KISS.
> 
> This clearly does not work for your hardware. So not only do we need
> to solve how PHY properties are described, we also need an equivalent
> of phy-handle, so a MAC can indicate which PHY it is connected to.
> 

Right. I had introduced fwnode_get_phy_node() to take care of phy-handle.

> So in effect, you seem to be heading towards a pretty full
> reproduction of the DT binding. Before you go too much further and
> waste too much of your time, you might want confirmation from the ACPI
> people this is not too advanced for what ACPI can do and they tell you
> to forget ACPI for this hardware and stick with DT.

I've copied the patchset to Rafael and acpi ML.
Waiting for their response.

Thanks
Calvin
