Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70A51BF7D5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 14:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgD3MGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 08:06:06 -0400
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:23518
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726127AbgD3MGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 08:06:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWSF5YscwOMmLWJfHWpU8xxypQ/GolX6ZLfbQ3XIGQf0yGg0KZxJMUWHT9t9paiQ0Vsiq9RnzUIDx88jLbuF7pN8/wKLTmUQmCgYuqVXNmekJIHJHqsKv0T4IIgxwmxz/SILlTrU7wH0ImuKqV8O6xucDp3uzJuE6Q3Hf3Qg9XMBwG8Owisen8khd+zjGUMajIUTEQNkL/JGOTx7ms+fkjZq0G4f2Qh/sQSk4R/D5hN06c51gQ4P5i0E7Ddc/1/AASO/KmeRcRhSK5SL8i8R05xVMzRx4MlWM/Xx/hdLJLIF34d7sXWPnaUPi0HGzLSYNgFj5RfQvU7O1+uNHDtXbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcHDJkr8twbZIBzugmOzaLCjeJwVTLtWJ+NTd6YpWMw=;
 b=J/jRw1qd3HlCprHO+UrbyP4wyMxrDXKunsQ9sA5XfKlXxaNrl4C9oigSra7Lt7Lf1OTGjclovrqosmzbiMLs3lNmD+NH8fRPKEnG6mjdunm5KxoOPJrAC5RCSi79AjmTRTMfEejZNmh0dTuKIURsB3/PGLUjOgn1RZFfon0jTokxEJ1j2GDgc680LMaebU9qbWEcFI2Hfd4p0S147kPsQksDLGTn9rCsMohVuwdhiuPPYF61BGn/+tYhHZU5gs5+NSZIp/Ub0oyK6Icjo8W/EJMlW3O1awPmaj5iE1N7Hxp8pDGiuUEneGuroaDQCXx+RMN0zLOxRynwUGx82qYlnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcHDJkr8twbZIBzugmOzaLCjeJwVTLtWJ+NTd6YpWMw=;
 b=SiTYsTlp3Av22oCnKGgdPgt203OaTHfyCdA7K7qYksucHb/jmIL/IG6eHGFReqZbRXWSCwYHsH3JcTf/tUMwMRNKwbzwiLa1UawS5erdRRINcnNhnnQKqAPOTEX6astDL/h8OIsYVzulq80VVK+DC/8BpFE2E6BcAFp8IZXoNyo=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5059.eurprd04.prod.outlook.com (2603:10a6:208:bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 12:06:01 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2958.019; Thu, 30 Apr 2020
 12:06:01 +0000
Date:   Thu, 30 Apr 2020 17:35:47 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
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
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>, linux-kernel@vger.kernel.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v2 0/3] Introduce new APIs to support phylink
 and phy layers
Message-ID: <20200430120547.GA19262@lsv03152.swis.in-blr01.nxp.com>
References: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR04CA0148.apcprd04.prod.outlook.com
 (2603:1096:3:16::32) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0148.apcprd04.prod.outlook.com (2603:1096:3:16::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 12:05:54 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 621bbaad-9d09-4da5-4a23-08d7ecfed8ef
X-MS-TrafficTypeDiagnostic: AM0PR04MB5059:|AM0PR04MB5059:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5059BD6D63F84E31491E6A03D2AA0@AM0PR04MB5059.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(316002)(54906003)(956004)(7416002)(33656002)(8936002)(8676002)(55236004)(26005)(6506007)(5660300002)(186003)(7696005)(66476007)(6666004)(44832011)(66946007)(52116002)(66556008)(110136005)(1006002)(1076003)(4326008)(16526019)(55016002)(478600001)(9686003)(86362001)(2906002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vCb3Dc5VpIOWySpinUu2P7EB0/4ZEAW5jANrZAYer6BL3xtG5kXp4rvzQQfDAM+ILI3k0VqFD7FN0VtgmZ5LdXSNLYTUKhf98mh30PnqEcAWw/ZDE71gHmb99nRiPPehIqkjXrFlu6pjHelAaSutdYiwChjHUwspJwtpKYkwHKWdNuDeRtkHWl/Q4q//vZkOv1XcsDVddaPQOJT9DWNW56BtmLICdNUjvAgdluAn3CO7rPEkqh1lsVoa9KlKIEOmR7yfuF/j4tHjlAo4dP+2ZjdCDv84Zboy2DuZBuWVsxxdpM+iPuPKkntyhZrXrb+QPFIlugTOQ5eLBT4FKuw3trfD7rHrrVYhU+gee6HEfvyDWEeGwzaMsy5SyNl86mcuBAtu2kGE4LoS4idQmVwIlhUCjeaamHPjxf1sgTh/a8v8MpKBLnycIn5BWi9p62X3nO2FM1aNLdDTT2k/pHwEk/sPUl8ez9VtUztqN+rnFJ8/0zEq083Gw0FAY8SiASNCtwVrMzmWJUljiWAgh27o8w==
X-MS-Exchange-AntiSpam-MessageData: lRazfolALNbRdaLQjzUZtLbFB+cO9fAf7gALuYV9TyhslZelOOgaLptR4kvGuo3Sz4AqTDLXAHWbSi/Od6vYT/Q2UqddryEuNsmbsTkk4Tll5BpTAz6mV29vaIn5ge0nUJIz5GeTnJkbTg4GdE6O+srXgKsfCsnk0q1XbBeDk6kT5SR+EWN4XiSQV2zcNNzAhY8Dfizp/s9NcMdQr0JsLadn7Gvj8dp9073ur/RzFp7+ugsaieTSjiTaIpDKE5kst0tI1J2ZIeazzN6APv8s5oGmGuvMdjqcTnwJO+Aia6gJlHC8X/2gPoPVj8XO+DJKymk/40CEi2H4jDMF1QIATCpyH8MTbH5ZOhDPepswd/yvfMOP71w95bc0syfnVs3pN22ezzmLckytejTnI+dsrgHuOishFNg7WDVUekGMFuvziFEPtHuUS+1wrDU1uJ8CuUo3QwSNtH80i6lCnvMJPBY6TtIx0VmTAuvPRgXybGzqZa/eFbi+ocLVpR8L27Ug8fKzOK9GZCotrbXiZq4ySXq4DX4p8Zm04JLBwKm6y8gRqUokI6DaoqRPm00MMBi0Wq2ZTasschtcTHALVnjFMeQY1I2I9MvNjs+mwwwZTROMcQrD7q/Em59OIga9aKWdqN0XIB4aVrYJnRM+LPIsRaA65RNYFaAxNYVaJlHEABoqyqqeRH/+qvNuBzTj7RjWZ24jGk+DcCdbTbxBwq36GK8fO33+lGHi1o2WTCJsleN4gakLZW0TbuLjjynws173s+z0ECr9wkn6utP9/HL671YH7PKoHIbIjh6jS1d0B70=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 621bbaad-9d09-4da5-4a23-08d7ecfed8ef
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 12:06:00.9229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tRZvVcNW3hDrFL9BGMLHLyKfjwiF6neb1MId7+xX1mK688VK2RFjBuboL5JnMQLCmqwGMScNiHEfqDtJ0eQYcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5059
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 06:54:06PM +0530, Calvin Johnson wrote:

Hi Russell, others,

> Following functions are defined:
>   phylink_fwnode_phy_connect()
>   phylink_device_phy_connect()
>   fwnode_phy_find_device()
>   device_phy_find_device()
>   fwnode_get_phy_node()
> 
> First two help in connecting phy to phylink instance.
> Next two help in finding a phy on a mdiobus.
> Last one helps in getting phy_node from a fwnode.
> 
> Changes in v2:
>   move phy code from base/property.c to net/phy/phy_device.c
>   replace acpi & of code to get phy-handle with fwnode_find_reference
>   replace of_ and acpi_ code with generic fwnode to get phy-handle.
> 
> Calvin Johnson (3):
>   device property: Introduce phy related fwnode functions
>   net: phy: alphabetically sort header includes
>   phylink: Introduce phylink_fwnode_phy_connect()
> 
>  drivers/net/phy/phy_device.c | 83 ++++++++++++++++++++++++++++++------
>  drivers/net/phy/phylink.c    | 68 +++++++++++++++++++++++++++++
>  include/linux/phy.h          |  3 ++
>  include/linux/phylink.h      |  6 +++
>  4 files changed, 146 insertions(+), 14 deletions(-)

I've a new patch introducing fwnode_mdiobus_register_phy and fwnode_get_phy_id.
Can I introduce it in v3 of this patchset or do I need to send it separately?
Please advice.

Thanks
Calvin
