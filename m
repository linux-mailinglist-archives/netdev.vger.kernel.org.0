Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB592DDE7B
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 07:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732736AbgLRGNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 01:13:32 -0500
Received: from mail-vi1eur05on2042.outbound.protection.outlook.com ([40.107.21.42]:55455
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726045AbgLRGNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 01:13:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePUZWwQggjcd1FaD4Hz6IB8cPBhOa02C89uO6swGrCYCEAe1xqzDAoDLH/zIoeaXrOY13gkBCz83xIYtO3I/5+dI+oOZp8RsfJA+L/1xPJYNbeqzYRvbUruD8aEKjXPJrvuZR+sldfaJdP6cjjVM24gM09X9A1s3HMmhePsI7uitU4KcwYL4U97vCOO8Ug69984R/d9Nnm5H5kwHMwIidZ1Jc0EBDOyuuGJ/KT+pUkGSwLINXCq0vP1emghtjUsAqcZMT56Jq7d4UJkRhGHzLVvgMdonkjxlJlayGvBX4HI6Em4953ZueW/iKTowwsmdGnlnwuf3YwpnCPdWlB85aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2xbs9tTKjF8wAcETwjp7ViIoDoxhSiIAWNIyxD1J18=;
 b=dz3rJLMtH26riT8+daYth5jyEINjrL/gPpOxjydU6OIHWM68/kMDqxExkE0A1j0alt0tEtMZVOf5GlLKLWRP4sr5gb5IVLNphJxAWitFGzN9Ov2OInu2o7uExdaujWl2JfXjiBg0riG8EkQeewZV62Lkfd7GrfkKN5V/DtgujoJTjbhwGHM8hv5ZWcnLWAMkkVCyDoPauylW/yXOQNS8Go0OtjO2gFkMMrIahbQjo+vmHPbbREZxAFc6lcnnejkU4f3mp3sAwUem7Yjdo/cKwhWmJsDWyDFWZMdYAcyc1col1CkTmxUDYlEPCDPV5oziPTwnPUE8YVc8vB4lUqpSUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2xbs9tTKjF8wAcETwjp7ViIoDoxhSiIAWNIyxD1J18=;
 b=I+if6rzPIG40NUMEigIttUsdGLKXANxDqPkF4srC1q1ejRKe5jg5VCJaV3I17zhw0YqiDw6I/MZe3n+dDooIAa9bt0bI0+1OsveOVOSJoFo4uTr1rLxx+qqArVrQECyg6wiWTGwYeK8L9EuB043CqAYBuBwFsYTJAV07PTD3wp0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7364.eurprd04.prod.outlook.com (2603:10a6:20b:1db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 06:12:43 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Fri, 18 Dec 2020
 06:12:43 +0000
Date:   Fri, 18 Dec 2020 11:42:29 +0530
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
        Jon <jon@solid-run.com>, "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [net-next PATCH v2 10/14] device property: Introduce
 fwnode_get_id()
Message-ID: <20201218061229.GE14594@lsv03152.swis.in-blr01.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-11-calvin.johnson@oss.nxp.com>
 <CAHp75Vef7Ln2hwx8BYao3SFxB8U2QTsfxPpxA_jxmujAMFpboA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vef7Ln2hwx8BYao3SFxB8U2QTsfxPpxA_jxmujAMFpboA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 06:12:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d49d64d5-4552-4e8f-f96a-08d8a31bee70
X-MS-TrafficTypeDiagnostic: AM8PR04MB7364:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7364D37C6E1711B451F2F7E2D2C30@AM8PR04MB7364.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHJbmg+L64nB4XjZKb9GXRjWfOqs30wJpXihoL61yVX58i9oHzHc/QUnxr5C8vjNAZl20uzfuPNGv5fyXQegWeVIZOYDC9IQbkv7a1X2N4dvHqDK6niK4mA9N6d4wCCpJYgIhP+rF09imRcJAl/3vHgC7hl5rcKlmH/F5tFNY18hOSDJ4pTboSSNgukFpD4SACZXGtlZPxO5kbq2oi5PnE10EwAf3YiMFN/NP31ZqWlNG97HBHfcpjCAMKCgh9pDeFrAOtpFcSoeBkEOd73JbjOlN72g/k/xg6bVaKNAlc9zyszMahDe1u1IPvshHgW8IqKmxu4MdI1HIiDQ6bB/Iks1aEGa8jR5WLEETjFLSEMYHPImnbJawfJgobkWsaVVH98c5Kv5vJcsjYV7yEgpfFoBv77s2eWQ06T3SZmGrwDSUtRzVEK5HFzL2EnusQji
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(9686003)(4326008)(66476007)(83380400001)(54906003)(86362001)(2906002)(5660300002)(66556008)(8936002)(66946007)(55016002)(956004)(186003)(6916009)(52116002)(26005)(44832011)(53546011)(478600001)(7416002)(6506007)(6666004)(55236004)(1076003)(33656002)(1006002)(7696005)(8676002)(16526019)(316002)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oJR/Wq2Pf79sE7xQDDdUo+cWhb/Y1RWLWQZ1bySDbCqY9KO1zCMJGHGD+3Ya?=
 =?us-ascii?Q?Bx6Nn6vJu+K+QxUg0q/j8Da3Xp6hG6t6Sx4nszA/GFiKFDFHiqE5qpS6N/aO?=
 =?us-ascii?Q?u531WMFu9H/E16emuyzitkiC/BYuYLEYJ5RQb1EVGFZuvhDFyJV23gsC/ugh?=
 =?us-ascii?Q?BPk8TmLrs/zWk2wYlkPlyiY8VU+6y3uX4A41aO8RnkplzwYZYnflcsG/J5AX?=
 =?us-ascii?Q?9QGB7v5OEBGujRxzp0v0GY43S/0p2CG5yT2ANhyG5BOlfJPLVUSlGxKcu35N?=
 =?us-ascii?Q?fnAmAwWi69Q91BwqjvZZS1PsKuswideW1e0qDTI/NI4ePMFZqlDtNEhwL3HP?=
 =?us-ascii?Q?3Smm0Obc51K211BmDv78jz5I4iWRXnpLOXsOjuRB65HzKJCzBfY73FObbaRa?=
 =?us-ascii?Q?R1k1uCyWAXBB2U1R4tiRMVvCmO45xO1apNO7aCIZhkIHKwTwL3u6KdN8cv03?=
 =?us-ascii?Q?gsRk6nbHjA+w//fg2YihnLfoMvr1tQ+nYQ1AngqoeYGOa3H7iJ2/W3lPoawo?=
 =?us-ascii?Q?uyda/FXSjrQW8Nyl67ScxuDVHrysYz8JTwRZe3nakIFxT8RTPZXWSq8QHQNF?=
 =?us-ascii?Q?TXjTMiwTegRGcWP1DICYZKcArCi6ud7DTOyvyypfNYHToGP5Q6rmkd4mOAmz?=
 =?us-ascii?Q?fQA3bf/yCzyA5cjQJpLgdiHXKla1o9rvWCkmLdyuZhAPcS2T0kWMzincQI8j?=
 =?us-ascii?Q?33aN2dZ1IJF3VzBvuWAEXbOG8JvH24lyyWymV431yBJWGlP0MTcf9Z0wOGcL?=
 =?us-ascii?Q?r0lXau+GbwrJvmrKzJIt/zNccoXcfusWYSt8pXkmLP4taKS9zCfeTHWiXvyJ?=
 =?us-ascii?Q?7pxQPqcwLp7FsuoRG005rsCwuyZFGVNWY9mFgBxUeE1XSqLG1gAt3jS394XL?=
 =?us-ascii?Q?KoIEN7G4o/ioTRlagTaew89g1SUCPbOIC6N6q3WY5odeB01BtSeHSrbDw6KH?=
 =?us-ascii?Q?wgWZDoKlWw/9crpCvF88OIjQ39Ikz0ABpCYmj8uof2g/F/7/OzYoua5Djv9J?=
 =?us-ascii?Q?ura+?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 06:12:43.1281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: d49d64d5-4552-4e8f-f96a-08d8a31bee70
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ZmS4Pk9IwkCbmIWCcKPvdjX8aHVhU1uIg7hIZHx04OnnDXJYDFuEc8EypdKsK7rRbr13dOcQEhLRctNAMiYZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 07:45:16PM +0200, Andy Shevchenko wrote:
> On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Using fwnode_get_id(), get the reg property value for DT node
> > and get the _ADR object value for ACPI node.
> 
> and -> or
> 
> ...
> 
> > +/**
> > + * fwnode_get_id - Get the id of a fwnode.
> > + * @fwnode: firmware node
> > + * @id: id of the fwnode
> > + *
> > + * Returns 0 on success or a negative errno.
> > + */
> > +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> > +{
> > +       unsigned long long adr;
> > +       acpi_status status;
> > +
> > +       if (is_of_node(fwnode)) {
> > +               return of_property_read_u32(to_of_node(fwnode), "reg", id);
> 
> ACPI nodes can hold reg property as well. I would rather think about
> 
> ret = fwnode_property_read_u32(fwnode, "reg", id)
> if (!(ret && is_acpi_node(fwnode)))
>   return ret;
> 
Got it. Will rework on it.
> > +       } else if (is_acpi_node(fwnode)) {
> 
> Redundant 'else'
> 
> > +               status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > +                                              METHOD_NAME__ADR, NULL, &adr);
> > +               if (ACPI_FAILURE(status))
> > +                       return -ENODATA;
> 
> I'm wondering if it compiles when CONFIG_ACPI=n.
Correct. It doesn't compile for non-ACPI case. Will resolve it.

Thanks
Calvin
