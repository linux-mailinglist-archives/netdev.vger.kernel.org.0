Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816BA2F76F7
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 11:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731710AbhAOKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 05:48:10 -0500
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:41538
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726370AbhAOKsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 05:48:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkaqwxCzoCWF65w5savxe9xUJnfMknsqbB66Bv07PB9AlTJCRKGIZLc8+j+9D0P9ZYej9l4Y3C935xd1+BLY4n+80GLTIr+OtvO0LFNatQ4NtOl+sgJPTqou/dXH8arCU82h4sJ7yelyWJ+V//nrTcbEj5yoBFScxm/pwunJJnfxc4ZWNj6VSt0bOlEkXITGuWmNikSbQ8J4A9smADm6SYcp+VhCnFqE6Xd565bXVM9mAnFb8SGrdPbWY+fZ8m5GgJJd3KZfJR+TBCcBGtOgwHo9kLF7+YaFg+JiwmOfeThjbIuAbeVaaQzBQGkYDq5g+6ikvD619RHvOaTioF1qrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qzt7/NSzvGmQE1XQ3mlQvE4x34GfamM9eB/oaQ+4nhU=;
 b=LTQtNJKsAzX78kXnvVsxNkvXZJ0zcLY6Pbs2EKkfKAKhOr7kE5k1Rv6EUowORo4mxf+T9cUE2Y/yoQIAFFQ+yu/RgYm2KxGB7fClPFo9CXj5pnftfS4tMWSau/04Zc2Pl706rqqLEfpG/ewtdyXo3ce/U1Q/v89btTP6qosjwB4ffE5LR80jMWra9GlBNog8daRIEHVv2DHHJqfPiLkSkE0qgohmHpkUQ4joMAEeX9vOzSaVSp+yB2WfEzea3+IeZtuV9koH/yc8UeHk4v0ZUlTXJ5oQtzDzqsFCimDpa4BfAjGkydT0Iv2Dz1/FMIxtDXLVsQMbm1jIj6qJKeCCEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qzt7/NSzvGmQE1XQ3mlQvE4x34GfamM9eB/oaQ+4nhU=;
 b=XiRJ+S15YSC5ta3QhbV7lvG6PFNSE8AZKqND1rVivPAfrpaDXZhYEkqwDas7L+cHj+3q4A708lbBjhGmOHcDDy7I/9gFH4MMh7WIUSsEPONiCvVLjwVo66BW7P7UItzMajnbjlW9+EuxudQzo5pQ1mxnRlDfK1aa9XNj9UQKPMI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7937.eurprd04.prod.outlook.com (2603:10a6:20b:248::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 10:47:20 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 10:47:20 +0000
Date:   Fri, 15 Jan 2021 16:17:05 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Saravana Kannan <saravanak@google.com>
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
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce
 fwnode_get_id()
Message-ID: <20210115104705.GB22724@lsv03152.swis.in-blr01.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com>
 <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0246.apcprd06.prod.outlook.com
 (2603:1096:4:ac::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0246.apcprd06.prod.outlook.com (2603:1096:4:ac::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 10:47:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 599ea6f6-189c-499b-886c-08d8b942ee82
X-MS-TrafficTypeDiagnostic: AM8PR04MB7937:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7937BD78D370E30B7FD3B5C0D2A70@AM8PR04MB7937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwAipUkt/eYaHlmkxDu4ITYxp91ela0coqzpITAVch0N8msk3d24YTpy2SQwK6ZTpltY3uk8/ntu50tbtl5DeLrb+puF3yCTzt2Yg8x7tPEh/JhvNbQ3imdZjd1CzSYStnCX4w70WRQN44tfhxS5TGrxlvMtObqYySTe/FLXjpW1W0+X9Ss30+wqXdYWk1zvRY6QSAUDYGsCdJxPYoxD7XyOAbQBVHUIaCANgoahxHIRtwCK2jGRwZdcPPV2PL8RuOl5jw3Jg3xdStNtae8Wu6P/NziwPQfGgzjcphmSgRn2wVgZcjrCSmYjeTOkEqECXMD3vbx3anXQ+7CLOB3ZeHkNc7Y6bCRhwLZa3rDYNjQslhqvm+SkdZC8ESCxQtiH8m7fjNks6BfXzA9Ix9TehAqlOprvWOYYXZltp2Vq5FrIGhIcU2eV1FErSJYQ9f7K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(2906002)(86362001)(83380400001)(1006002)(55236004)(33656002)(186003)(55016002)(8676002)(316002)(6916009)(66946007)(6506007)(53546011)(7696005)(6666004)(66556008)(52116002)(44832011)(7416002)(66476007)(16526019)(9686003)(5660300002)(478600001)(1076003)(4326008)(54906003)(26005)(8936002)(956004)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OKE23DzffpSYdln0ZeU1q9A8JXTPYljJ8SM+lFdDbA7YL/+cUYSBpYieZ4Pl?=
 =?us-ascii?Q?D06dCxYKMGxXaPaVugQIR1OIwcFfMOci30p0iMoRNo1KYdoNPVc0uR2F5+4A?=
 =?us-ascii?Q?wmIUoz0/phE1eFQFa1O1raxFdWnBf8K7vf3pFcufFtr0+SXIEsm9oaShZLOS?=
 =?us-ascii?Q?am+E0p+wtqxhsijy1Yu89NPBF98qeI7DBi01psBUf1JbmQe3HllRnf1UI6ej?=
 =?us-ascii?Q?2UlZycHjjVXeX6KTZE2o9vRfLE1plkitjoTA7aCpDsjH8xD35uwHiZw3QiVp?=
 =?us-ascii?Q?4xNOF0FnjXD+jAhoXwDYxA8DbzdLdw2n6vG2BIgSUfhuzVtdz+aeSKrKg7qG?=
 =?us-ascii?Q?HE/PBUzmFnjOH0zi7YRi+yrUaCC/CQSQTnQsVWFe79WWqWMQYsCfcqaTmeIB?=
 =?us-ascii?Q?0/RxT5KfHXAUiG65zvHJ52nsd4AAo3Bqm/XhJ2+pr6KdNtTe5F0kHw3MD2OV?=
 =?us-ascii?Q?xuuU54cUS1qEc3EiTiuIrDGPqxm5KP81h3v/UQlfvziJ9geuUZ1WXUzkoa59?=
 =?us-ascii?Q?Vm1GoSMlf0uSrtmhSOaoHKBR5OxB5cIzTEJ7kO3Jb/21QjegcxS9NX46PNLa?=
 =?us-ascii?Q?rF0mAAS1YfqlbY9waMh6w4n5emh8sI+HcKpm5vv21YKmH3PqtpTsktmM8oL5?=
 =?us-ascii?Q?M5BaFwGDGMZ+la3mXVXhSsTbZxym51VwI8UXRVGEeGBYHqIAFNWMyBSi7Asz?=
 =?us-ascii?Q?z67CJ5IyrijUpoKFs99QeLdd2q7ZtJ6ED5twS4V1G05WD/FHXa8A1gNxVsMR?=
 =?us-ascii?Q?5lF6N2D4qKTayyVAZ/cKMT7A4zGgh34flgILpymLQA5XUhVNsX0nB50I3n2U?=
 =?us-ascii?Q?rYhn20xe21exzsJotS0Zm1PDuX9vTGMeiVhkfr4i7/m8VBrbwEMEJ5D4frnR?=
 =?us-ascii?Q?dw1jwdQXt3aFT7ST1Vgrp2wd6bQNKZQDMPRPOv6gkRyiq3yIvU1UE0S6tQTv?=
 =?us-ascii?Q?tFq0ZpUBtysHPFPl3SESlrqnLUj+ksrVBYFaoUDeXtaAwiDxjmSy+cMypjK5?=
 =?us-ascii?Q?aBaQ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 599ea6f6-189c-499b-886c-08d8b942ee82
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 10:47:20.2192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7TEHHUDK3FdrbjN6lrxp0z9h8FmyReDezVldEFC/rX2MF5fFUQsdnQ7L7bzFOq+ve1cOsGajEcFpBvzgPfVNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7937
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jan 12, 2021 at 09:30:31AM -0800, Saravana Kannan wrote:
> On Tue, Jan 12, 2021 at 5:42 AM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Using fwnode_get_id(), get the reg property value for DT node
> > or get the _ADR object value for ACPI node.
> >
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> > Changes in v3:
> > - Modified to retrieve reg property value for ACPI as well
> > - Resolved compilation issue with CONFIG_ACPI = n
> > - Added more info into documentation
> >
> > Changes in v2: None
> >
> >  drivers/base/property.c  | 33 +++++++++++++++++++++++++++++++++
> >  include/linux/property.h |  1 +
> >  2 files changed, 34 insertions(+)
> >
> > diff --git a/drivers/base/property.c b/drivers/base/property.c
> > index 35b95c6ac0c6..2d51108cb936 100644
> > --- a/drivers/base/property.c
> > +++ b/drivers/base/property.c
> > @@ -580,6 +580,39 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
> >         return fwnode_call_ptr_op(fwnode, get_name_prefix);
> >  }
> >
> > +/**
> > + * fwnode_get_id - Get the id of a fwnode.
> > + * @fwnode: firmware node
> > + * @id: id of the fwnode
> > + *
> > + * This function provides the id of a fwnode which can be either
> > + * DT or ACPI node. For ACPI, "reg" property value, if present will
> > + * be provided or else _ADR value will be provided.
> > + * Returns 0 on success or a negative errno.
> > + */
> > +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> > +{
> > +#ifdef CONFIG_ACPI
> > +       unsigned long long adr;
> > +       acpi_status status;
> > +#endif
> > +       int ret;
> > +
> > +       ret = fwnode_property_read_u32(fwnode, "reg", id);
> > +       if (!(ret && is_acpi_node(fwnode)))
> > +               return ret;
> > +
> > +#ifdef CONFIG_ACPI
> > +       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > +                                      METHOD_NAME__ADR, NULL, &adr);
> > +       if (ACPI_FAILURE(status))
> > +               return -EINVAL;
> > +       *id = (u32)adr;
> > +#endif
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(fwnode_get_id);
> 
> Please don't do it this way. The whole point of fwnode_operations is
> to avoid conditional stuff at the fwnode level. Also ACPI and DT
> aren't mutually exclusive if I'm not mistaken.
> 
> Also, can you CC me on the entire series please? I want to reply to
> some of your other patches too. Most of the fwnode changes don't seem
> right. fwnode is lower level that the device-driver framework. Making
> it aware of busses like mdio, etc doesn't sound right. Also, there's
> already get_dev_from_fwnode() which is a much more efficient way to
> look up/get a device from a fwnode instead of looping through a bus.

Thanks for reviewing the patch. I'll add you in the upcoming v4 series.
There is lot of history into patch series. It would be helpful, if you can
search for related submissions in the past and get some background.

Regards
Calvin
