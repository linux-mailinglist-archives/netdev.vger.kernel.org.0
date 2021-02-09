Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709283151C5
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 15:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhBIOgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 09:36:33 -0500
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:43840
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232187AbhBIOfy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 09:35:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNUWak/XAcXecR51E95zqtNFsyNL0YC4RVx5NsQDnPELMM3rpNW3vA53Y56BxUQv5G8iwY0GkcSjKoIEAwdbAnQvzdn+6MtWI9pWPSM71fjmVpey+D6RnN2YBxrzHYfLBhztgr+KnyBAD49/sndlrpUoqWgps/zfa/qnFwoiSLV2g+W1huzvgarS2Pa45LkKA+67PwWz222LWeGrK5axWykgxva+Z9bhWXZ97zSsjBdzaqoEZqlTONEIGEEuyT4W0zK0vsVUWPn1QVi7/OSIMNnHe084VGgpSYQH6t4JwYc1dFDF5JCC67pL4LrLx9eK+P27dQqig3e2FGrGetDB0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekHACrOSrqTvVR129HpdPyjzTyAXNvkXo2oaRsuLukQ=;
 b=bKkiuVm1FmA+d+/i+k6IP7OFlXpSXMZPEt23lRPHG+nTHOQtRtimDGHRT2G8UAawPR9z5znXxDX0cJnsmd/KAKgfd8ZzyxdI4rACTk/k+x95Ico/exJFJ4BurYq2ToBMATe8wdiY9PlaFtpAnG/iaI99hZdNJs+cZWE9fkrTu8yolsh70/0XL6zW3Bo8zoBWXLDY5ySOP2FJ0fEiiV+9rhXriluV0uwNrz0exFgJ3aGDxekuUFg07PbKnDYl58dYbXnpuWd7d5HHs5KTsy+aHDgO2Y68PbeTQWb/rwc92OIxD+rCGpZZ29ZYU8DqscXXmkLqYsk5DeipdOTAx7x74Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekHACrOSrqTvVR129HpdPyjzTyAXNvkXo2oaRsuLukQ=;
 b=WQsIuop4x5TLyaphpUx1oe7lVvCJrq1cT/auwsSVsijqibMIjsBhrBTW6yYvdk5mB3khxtZZStku7jaTtmFSkGpws0i5YJmA11UZ5P24LbWV5QfZ7T2+MtRnwoZa5pG5uAWHM6Ae0gmkMKCW+NAb7ifHjQJbFAytwH7b65u2MYU=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3444.eurprd04.prod.outlook.com (2603:10a6:208:20::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Tue, 9 Feb
 2021 14:35:02 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 14:35:02 +0000
Date:   Tue, 9 Feb 2021 20:04:09 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Randy Dunlap <rdunlap@infradead.org>
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [net-next PATCH v5 01/15] Documentation: ACPI: DSD: Document
 MDIO PHY
Message-ID: <20210209143409.GA3248@lsv03152.swis.in-blr01.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-2-calvin.johnson@oss.nxp.com>
 <0a347d2a-f885-5b26-4477-ff267527d8c4@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a347d2a-f885-5b26-4477-ff267527d8c4@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: MA1PR01CA0124.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::18) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by MA1PR01CA0124.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 14:34:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 44173500-f728-495f-fdc4-08d8cd07e227
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3444:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3444B26BC36E74576D75D59ED28E9@AM0PR0402MB3444.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0yF0+Zn3MIl6+YxZR5LJD3rXOx0zSMmEh7MRKoKTwjNCVioswCWogfDy4+0v9jJDjH2N7bZAtZOwoGVLRYTZ2+lZty3P9UMPM8B2Ckr5+VrPuSpVWI5cOeQb5e44sBH2M3mSUZGUKrGTNzOBa7ffiFF6qDcGO7U67VLfrs0QLDjfLbV9A19Q38IbW6whxIgYno0QQzN+B6LSDcYXjE8rx4IVzBBCB/e5nPcfFA/gU/cYXkzrlq30CavnZ3zRjo1Wtyu6cMBFV9zo6Hx2P/Wxikqe0ZYnsAhGlpcyrhLqqHKRo8p25iQ8oYSBN306FIA6zbkNl3hWWQu6mIbcrz2HF3uIwqxcbnBi0CVJDTgj2Qc2ts02aHjLIgKQmms2nyO57CXSwu1OWtBvJseQk1gH+OdVCzhNsJq+cqqNfbLXjwgl3qrpNdX+qWw9f8ovGrJEktPIT4ddtdT15r4XIeh10qrRtEQySBTgv7OUT3Z3hBGF7BQrrrT3B63Ni7KH2cHG7+bRkFEOENM33m/1MZxgf8XEnV6MB/nu+ngwHuNnWqhlDmD4Eq3dpuIir7MIo+s3o8S1jDHmpOWNchjv+yh2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39850400004)(366004)(55016002)(52116002)(55236004)(2906002)(4326008)(7696005)(1076003)(5660300002)(9686003)(26005)(53546011)(8936002)(66946007)(478600001)(6506007)(16526019)(54906003)(316002)(186003)(956004)(33656002)(86362001)(66476007)(66556008)(6666004)(7416002)(6916009)(8676002)(1006002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?q0n0cH/LAI39puFO0FuK0YTXC67NmWRJLcTdkdXbheltPjNwlJRRZ66Ufg48?=
 =?us-ascii?Q?6l29Kxzd1zfd+Vv+gBzu9JqX6Ne2mwKASnza7/VNEA2gM4hqWmHqr++JzVnK?=
 =?us-ascii?Q?0zpvLNLb9nPowQebBX9L3wqzcC53210vEePpIhXS9ZW+jUwAKS8E2cFL3hk3?=
 =?us-ascii?Q?2k9QykVsO0hlCc3SJTc1V9jlD2uaBBuXxQqXQBUHRpoJJwyo4eZkCxNpJag2?=
 =?us-ascii?Q?R5ldMSL9kzFrInu7zpNBu4e6nCHyvfH+flcEG3ls+RS4EGSSP6l+hXHP0hgA?=
 =?us-ascii?Q?Y9/LVRpcsoUZ0IK6ilq2XR/psZ9NwH6KAD1D7KHPHstOwJvwWsfxIXLA/kc9?=
 =?us-ascii?Q?3LWINiBkS0mxCXpaDQSoKFdpnAfO4HZVKftUqL9OCEEY41h3Mqul7Fo9QFCZ?=
 =?us-ascii?Q?+0mRNNd4pteUeNaRsbpduOEtqJbocglStJHMeTt8cNwdlRiiGcMQkJxJaHuO?=
 =?us-ascii?Q?0kLfo34iloSHRnfY7Z25eivPaKrg+2rnufdCzLwNL6VBdMdkvm/4BjDG8bOa?=
 =?us-ascii?Q?bG/UmyUrZ/J68Cuovkcd0IGuDMVzWAGVuK77mvYEY2/aBs+pSLXNUdKniM/D?=
 =?us-ascii?Q?O4PEJ0mrK74fSPIhVAlK79mZ0jUeOYDdt2K3E9WbnhMSvX4IoA/qtwyTl3m3?=
 =?us-ascii?Q?a4wb66h84WU48I6Qnh8QdzAXgYRSPEO36AoXWY1fiGs6mD6lmeY67ZsebIvh?=
 =?us-ascii?Q?bijiSMYWeMXYnA//jQF5OfpvVHt9Ry/jGY6a2/snfoFrvjDVq417pPB3hbX1?=
 =?us-ascii?Q?dI/iBmE9e1wDlBeRNGvjbKcCXgE1KVZHWM0ZYbpump+row++jap2xe8C1FRh?=
 =?us-ascii?Q?DpQDh3p8r5qdl3+8Z5HNOJCWQ4RpFKFK/DtLDW6bI+zvctYis91PHxggp/A5?=
 =?us-ascii?Q?a2nUWSYrgDdhcFMIp+TMXaIzN90g5lNmQgIlfsPIREmNIEJPRyzO/66h+P3f?=
 =?us-ascii?Q?cpnF0B/s4c2RDFIdT2CMbtOBWK7Fnmd8Gj7unXy65QA6p3i25ZbUhYQjO493?=
 =?us-ascii?Q?x4L99EA5OaUN0zBcgZdfXBegTLekSsHF7S5FycukvbN0INNOkx8ufILpCfA5?=
 =?us-ascii?Q?EwGAbaalhbEsCrBbN89vpPBed44AkUpB3j4q8eGjJgmICreGrQ5jsNiH/Pgt?=
 =?us-ascii?Q?yvj3bPKWZDcZ4okLU/Ff+eNwn/+EWi0n38fFXLI3d7UiBKjCsTvoZXXSvgNK?=
 =?us-ascii?Q?dwZMtoEJJNvfMUyygBMIFcWtZSXXQbFPn3Gqw8F1d3NsWg/QnIfD7lQAxWwp?=
 =?us-ascii?Q?8gRHZwfvlDWMFcZ24NxFJ5ThyOmWUy2+OdCFYNl7CNQFBajmpiKsOwnmjvV5?=
 =?us-ascii?Q?14fm5hgWqW2wMNS1099CopVy?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44173500-f728-495f-fdc4-08d8cd07e227
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 14:35:02.4507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxqLFKlW6XLXAXxsv57o4SGvJB2InGqNzlYKXRI0aHPwAJcli/P1h8VdHg3SVkmfaippv0kiJbZBMunhmeZLBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3444
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 12:01:57PM -0800, Randy Dunlap wrote:
> Hi,
> Just a couple of nits below:
> 
> On 2/8/21 7:12 AM, Calvin Johnson wrote:
> > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > provide them to be connected to MAC.
> > 
> > Describe properties "phy-handle" and "phy-mode".
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> 
> >  Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++++
> >  1 file changed, 133 insertions(+)
> >  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> > 
> > diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > new file mode 100644
> > index 000000000000..e1e99cae5eb2
> > --- /dev/null
> > +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > @@ -0,0 +1,133 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=========================
> > +MDIO bus and PHYs in ACPI
> > +=========================
> > +
> > +The PHYs on an MDIO bus [1] are probed and registered using
> > +fwnode_mdiobus_register_phy().
> > +
> > +Later, for connecting these PHYs to MAC, the PHYs registered on the
> 
>                                     to a MAC,
Each PHY is connected to a MAC. So I'll change it to "PHYs to their respective MACs".
> 
> > +MDIO bus have to be referenced.
> > +
> > +This document introduces two _DSD properties that are to be used
> > +for connecting PHYs on the MDIO bus [3] to the MAC layer.
> > +
> > +These properties are defined in accordance with the "Device
> > +Properties UUID For _DSD" [2] document and the
> > +daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
> > +Data Descriptors containing them.
> > +
> > +phy-handle
> > +----------
> 
> ...
> 
> > +
> > +Later, during the MAC driver initialization, the registered PHY devices
> > +have to be retrieved from the MDIO bus. For this, the MAC driver need
> 
>                                                                     needs
> 
> > +references to the previously registered PHYs which are provided
> > +as device object references (e.g. \_SB.MDI0.PHY1).
> 
> 
> thanks.
> -- 
> ~Randy
> 
