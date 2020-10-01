Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A920B28001B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 15:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbgJAN1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 09:27:07 -0400
Received: from mail-eopbgr20088.outbound.protection.outlook.com ([40.107.2.88]:32199
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731993AbgJAN1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 09:27:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYUOUXR6i1Ffk1RekK5ajHxNdCazBfx9m0NbcCU0IWZB4Slq+575bUlOqi7o2jgk9C1HI/Kkd58xrhMRQueuimjw6WcLt00Ji2l9/kNW18EMVZih6knoEWaIDEOJIMiuU7IJOeZW90cOajPU04LiHa6WemnpoAFLvFm3hWP8fUAWV3f3+cwDsOHrjzAfVvGEFCigHjmXBzafiZ8Ny+VAX+KMyPqEEH5WC2Sa0EdbaXjMghve7mShIgeWpZT/ll1Vtuf6wGveHRj6N8H9dLcLHpl+SH9LeIUFLevZ2iXHLCKr/0O4CWuztMVIETU5dlLkB09DKvjogdJE0kZOZ9n4DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fr/h+ALbAuM0UN/OtzORWwthZ4T29BtS9XiVShCcfQ=;
 b=b4beXviPbhwTW0ibHQZLSB7cbswVJ9NzJzPpkwSenMygwbSZjYi8cem80MuLFmwc2GfUI5ZiGrn8+hlegxE8/CwDdfQrQSuJgaYr0s2zVHt7g8Q16X1nRX88+W/oeM6kKB+3SMdJhO/sP32Ng11FaCC9fvUvJBOGqbRYE+JdNR+8ch5fZpDhnMZNnyBpPTpyn+/tST4AZXXum1nh89D8g2vuhumY7zU3nxKEYc1HuXsKkLYzLXoA798q/x5mwfYBE/U+tHQKgbC/1SNwKTpWq0sU7M0KAOsj+CaQE4YjtP8IJgDB+wACi2RyH2xU1hxywBCXLAaMkBppsP6pwHQQcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fr/h+ALbAuM0UN/OtzORWwthZ4T29BtS9XiVShCcfQ=;
 b=i3h+rfGDLZWeyr25Kv+iiwKtMXz2bn12Vr6BqIwzFJ9KxxBW2kTFZKVTzi5o09Ckv6uj0SD8k1AFB7yapmgje+xjxULPahBhQxcodosCpDEo/DF6+EYLWv7zKvLOvXKJNvmQn6+UQzQC5IKnafBxLKoDPFdZYFxINSZOutMQiu4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6897.eurprd04.prod.outlook.com (2603:10a6:208:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Thu, 1 Oct
 2020 13:27:02 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Thu, 1 Oct 2020
 13:27:02 +0000
Date:   Thu, 1 Oct 2020 18:56:49 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Grant Likely <grant.likely@arm.com>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux.cj@gmail.com, netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [net-next PATCH v1 1/7] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20201001132649.GD9110@lsv03152.swis.in-blr01.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-2-calvin.johnson@oss.nxp.com>
 <CAJZ5v0jP8L=bBMYTUkYCSwN=fy8dwTdjqu1JurSxTa2bAHRLew@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0jP8L=bBMYTUkYCSwN=fy8dwTdjqu1JurSxTa2bAHRLew@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0153.apcprd04.prod.outlook.com (2603:1096:4::15)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0153.apcprd04.prod.outlook.com (2603:1096:4::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Thu, 1 Oct 2020 13:26:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b9917423-4772-4110-4388-08d8660dae37
X-MS-TrafficTypeDiagnostic: AM0PR04MB6897:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB68978B0E28F1AAB473A9A384D2300@AM0PR04MB6897.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1BV2YVi3ZjYybleaDZ5V+NITCSwm6UWqSiK3FkZ4vCU0ChSeusGv3DJSt1YGDx/jY0upHDlkwWQsSjOm74i2tEutj55qTtMTQkzXUmUVWsEnkMyHvdZ2xDnaUOfaFSY2jIMxHh8HxHEzVoIRXCflYtlph4KZzbNwP8HxfNJQIEoHOnFSOmfJNoTu3Fk+WRhQfP9L1gW6iTkg2a0hJo/qpXTEKxmKfMtEyRLlT5MzxYzGnQhfp7lsVEgYh1y26UrtICEZwZcpHDWw3t6X9pBymmNwy/9D0j7sFaWewNEVUMX2TGOVc//PFyKJ19Yf1ffgGoiNb7JICjnsko1dDF5OGRBmV6iV12MvFpSbGiDsOGNW8NXOgw/5OJ2vU+HsUv/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(8676002)(66946007)(66556008)(66476007)(9686003)(16526019)(2906002)(478600001)(316002)(52116002)(1076003)(7696005)(186003)(54906003)(4326008)(55016002)(8936002)(55236004)(956004)(83380400001)(6506007)(86362001)(53546011)(33656002)(1006002)(6666004)(7416002)(26005)(44832011)(5660300002)(6916009)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 20ZGjkFSI7QXQjBLXr0W2d/tXCs2elNTPcGHA55k998cKgsnv4sBLGOFTWP9pPq/c/Psn3iDkOIHaoOF8Bw4Y419u1ZRWA4/+vaZeabpduD2BZKp3cDxZZsVuGjmakv3U0205dPqbJMORbn34vJh4gUsBUjNFtk68mQz87Kl31k/MyUQa+5iraYP4ZvAiwXJNM1SY10IFucqnoAovFgq1DLOv9xJQKJPf+Z0jnZ4u3Dh0I+zkrBGJtaLi86R42KHyE0JnY7XQeU3Sd80Q671OU9hBjFlOSgO88eszCx3K4+1oZxumXlsgwPi4Yu3UAXPwmDFFQ77VSM8P0UxBfXcc3eYwkbXKDUMKvyL+cA1fqNJXqREFhg61vJb2CF+Zc4+qnz4e+9qgiu/zOV0ljD6tmvxay3HIHdivnkUpgzd9u9d5qDJy4ws+YcyHZjYveLbRhX2w/YMr9+QxbfLvgc4PGqEzKcsGukQ1/FSSJgxXYIEhV1ydsoxvK6qTI1gHq5MJ7DNy8FQzpnHsCwfVsj95EBTaIEYEKPU7Vpv9yflUpR5iH2BRlrJCNeXgjyd1IdTJJOrD3wwZDqed5o14f09FB8+Jj2ovi632fUpNf0QB6GCZpaVuLFJDtsyLvea3pJwJH022qqdoMoWy4nIW+UyCQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9917423-4772-4110-4388-08d8660dae37
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 13:27:01.9039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DgzS7jGWVD6ythWz4I910J0hblfmm4kJ/dfTQgrd/2d+T+7qooNjdTaWniDy6Yfrf0vR4lX2kSK6A3/zYvahA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6897
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rafael,

On Wed, Sep 30, 2020 at 06:37:09PM +0200, Rafael J. Wysocki wrote:
> On Wed, Sep 30, 2020 at 6:05 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > provide them to be connected to MAC.
> >
> > Describe properties "phy-handle" and "phy-mode".
> >
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> >  Documentation/firmware-guide/acpi/dsd/phy.rst | 78 +++++++++++++++++++
> >  1 file changed, 78 insertions(+)
> >  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> >
> > diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > new file mode 100644
> > index 000000000000..f10feb24ec1c
> > --- /dev/null
> > +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > @@ -0,0 +1,78 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=========================
> > +MDIO bus and PHYs in ACPI
> > +=========================
> > +
> > +The PHYs on an mdiobus are probed and registered using
> > +fwnode_mdiobus_register_phy().
> > +Later, for connecting these PHYs to MAC, the PHYs registered on the
> > +mdiobus have to be referenced.
> > +
> > +phy-handle
> > +-----------
> > +For each MAC node, a property "phy-handle" is used to reference the
> > +PHY that is registered on an MDIO bus.
> 
> It is not clear what "a property" means in this context.
> 
In rev-2, I'll add more info on this.
During the MDIO bus driver initialization, PHYs on this bus are probed
using the _ADR object as shown below and are registered on the mdio bus.

      Scope(\_SB.MDI0)
      {
        Device(PHY1) {
          Name (_ADR, 0x1)
        } // end of PHY1

        Device(PHY2) {
          Name (_ADR, 0x2)
        } // end of PHY2
      }

Later, during the MAC driver initialization, the registered PHY devices
have to be retrieved from the mdio bus. For this, MAC driver needs reference
to the previously registered PHYs which are provided using reference to the
device as {\_SB.MDI0.PHY1}.

> This should refer to the documents introducing the _DSD-based generic
> device properties rules, including the GUID used below.
> 
Sure. I'll refer "Documentation/firmware-guide/acpi/DSD-properties-rules.rst"

> You need to say whether or not the property is mandatory and if it
> isn't mandatory, you need to say what the lack of it means.
> 
I'll do that.

> > +
> > +phy-mode
> > +--------
> > +Property "phy-mode" defines the type of PHY interface.
> 
> This needs to be more detailed too, IMO.  At the very least, please
> list all of the possible values of it and document their meaning.
> 
> > +
> > +An example of this is shown below::
> > +
> > +DSDT entry for MACs where PHY nodes are referenced
> > +--------------------------------------------------
> > +       Scope(\_SB.MCE0.PR17) // 1G
> > +       {
> > +         Name (_DSD, Package () {
> > +            ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +                Package () {
> > +                    Package (2) {"phy-mode", "rgmii-id"},
> > +                    Package (2) {"phy-handle", Package (){\_SB.MDI0.PHY1}}
> 
> What is "phy-handle"?
> 
> You haven't introduced it above.
I thought I introduced it earlier in this document as a property. Ofcourse,
more info needs to be added as you mentioned. Other than that am I missing
something?

I've a correction here.
Based on referring some more documents, I'll be using
	Package (2) {"phy-handle",\_SB.MDI0.PHY1}
instead of
        Package (2) {"phy-handle", Package (){\_SB.MDI0.PHY1}}
.

> > +             }
> > +          })
> > +       }
> > +
> > +       Scope(\_SB.MCE0.PR18) // 1G
> > +       {
> > +         Name (_DSD, Package () {
> > +           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +               Package () {
> > +                   Package (2) {"phy-mode", "rgmii-id"},
> > +                   Package (2) {"phy-handle", Package (){\_SB.MDI0.PHY2}}
> > +           }
> > +         })
> > +       }
> > +
> > +DSDT entry for MDIO node
> > +------------------------
> > +a) Silicon Component
> 
> What is this device, exactly?

I'll explain it more clearly.

> 
> > +--------------------
> > +       Scope(_SB)
> > +       {
> > +         Device(MDI0) {
> > +           Name(_HID, "NXP0006")
> > +           Name(_CCA, 1)
> > +           Name(_UID, 0)
> > +           Name(_CRS, ResourceTemplate() {
> > +             Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> > +             Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> > +              {
> > +                MDI0_IT
> > +              }
> > +           }) // end of _CRS for MDI0
> > +         } // end of MDI0
> > +       }
> > +
> > +b) Platform Component
> > +---------------------
> > +       Scope(\_SB.MDI0)
> > +       {
> > +         Device(PHY1) {
> > +           Name (_ADR, 0x1)
> > +         } // end of PHY1
> > +
> > +         Device(PHY2) {
> > +           Name (_ADR, 0x2)
> > +         } // end of PHY2
> > +       }
> > --
> 
> What is the connection between the last two pieces of ASL and the _DSD
> definitions above?

In rev-2, I'll explain the relation between these pieces. What I tried to show
is that the MDIO bus has an SoC component(mdio controller) and a platform
component(PHYs on the mdiobus).

In the MAC nodes, the PHYs are referenced and that is done using the "phy-handle"
property.

Thanks
Calvin
