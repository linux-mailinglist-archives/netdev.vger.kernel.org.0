Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B7821B7D1
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgGJOIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:08:22 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:45409
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727031AbgGJOIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 10:08:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vr5AVRxoNlIjD3U4yZbI2GBeQx/y3ILU+qUSYA+hZ5sz7AgChc+zYIPh99ZwqlzGG4GXhKwm3oBjO+v/OHokwXDV/wPi8OuYuuiblElKx7u74Hn5w377yj1g3NsIbKlx3tdLkFh1ChsZZSwj0P9jAGyX65khOMvx8vTtR1rXLE5a9cRnld1cIWqjZm0We9BJs8KBXtkDNgyP7mlGwAEuEfU/VU8yrikC0Lu2A5QdICyLqXDKEXTJzgJuxnJXjDgdIGGJ4r4s1a6GDgsZNjSQKBlHkltfuQ/jY8FAX+mFQ1I+EtSp538EDvoPMsY0/iR1B0Y1EBEmTFPDAXZ3NVIBvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PyhrvK15la7mJdtXGs8wsbcadxLx9LZ+P3OJWeMusac=;
 b=jwH7rpH0uSY2ixLiiilykZby0bH3S1nuUXdlzBtrWV7S4FFALR6cWWNpWTVmT33eehOhQH3IpaBMuP0kCTafNUa3ywpijDNLpObwFnDp1czBSywlhF4QZHykCZtufATK5d1SQqCTrp5ph47O0rE7w4s+5Aq0jtthCvKl+F69zvD77BjVuxGPDxcDuNxh2pOoFP6LXxrduqFNE0eS0AdOtbzKYXgUBo/pDo1ZunRqwnJP1QiFCwykc8UIKxnchlBYdElK67GfzgJ6VS6sCMj3T/0rmjBj0oaARfvIwW4r81Yp5rAmYjdWNwDnuy28nPS1kgs7Is7KN2sb7p/i/ke1bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PyhrvK15la7mJdtXGs8wsbcadxLx9LZ+P3OJWeMusac=;
 b=mSRtj85P8lWmKaHJkaDM/h4j3fKzO2sdejjKvfapeNsjhElDEAnjtBytq8/5I2EPpPQDI8zW4hZBN6o29848vbCIujCAyW8yBPoEewWe0k8CMwPOOCP/vEeBm9reyHbKY6x1LI5iY0tVwrsgtN6rdMOieiLdCOQ5haHuPgxZeTc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4387.eurprd04.prod.outlook.com (2603:10a6:208:73::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 14:08:18 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 14:08:18 +0000
Date:   Fri, 10 Jul 2020 19:38:08 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, netdev <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH v4 5/6] phylink: introduce
 phylink_fwnode_phy_connect()
Message-ID: <20200710140808.GA26486@lsv03152.swis.in-blr01.nxp.com>
References: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
 <20200709175722.5228-6-calvin.johnson@oss.nxp.com>
 <CAHp75VdOF2qXFQOAyYVFLY-_JbGUAZ-6Cq-q_LRzKeV69RrJgg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdOF2qXFQOAyYVFLY-_JbGUAZ-6Cq-q_LRzKeV69RrJgg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR02CA0105.apcprd02.prod.outlook.com
 (2603:1096:4:92::21) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0105.apcprd02.prod.outlook.com (2603:1096:4:92::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 14:08:15 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d6027a6e-97a0-44e3-351a-08d824dab22f
X-MS-TrafficTypeDiagnostic: AM0PR04MB4387:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB438739B4BE775C9635FD6D4ED2650@AM0PR04MB4387.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YKvwEcaS/JiWtYdIG1P0I1Zwig6fvsKVd72FgHvCfARu5/62NTFjI1+DefM30aqzNGxe85px+h0BzyWyOfWp+4q00T091I2XO7+2GOKgh8myi7nsCdKV9xYqYrteyf9Ic1Vh6UksFErnbNYsL97u3AuYOnzTGTyn2PbmJN9A9RzVPAe8XwVvJigvzonsxcml9NV7SvMqOJEb+toVmLXgV/D1DxfFKvepOMpC2UnznDs1q3sVvCH8NSP7QPNU5czF8SwqVxL8p20gp6OtE2XZXn9M5jorFZphdyPujNJ62Ywbvr+DkjHW+85oLCQ+3pLTvSEpX4nFlhMcJMcXBeTQYhF/IzYmfznHheh28DJhcuqS2y6UEh/M+GyDfaRkG670
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(6916009)(956004)(7696005)(2906002)(186003)(55236004)(16526019)(53546011)(6506007)(9686003)(5660300002)(8676002)(8936002)(66556008)(54906003)(6666004)(1076003)(66946007)(316002)(66476007)(1006002)(44832011)(33656002)(55016002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5pWhmLm3s44bdxOw9exgs7R2IVfuCIKC0H+RLBzBFpq4tp824HyuEWBf1nnJWcBBEQti4uOPP345LhZy/RthFPl3xHI5Uj9UGKhIAvAvXyQX/zWTSlnA5U0FP8MJj6bUm8zNOuDu1vFxfDX+La5os3dP6TaNNhxZPlv/DJiAvhXOG7fN3Hdn0K9FQyNnFnNsnE3H6qNzCRPjVY7wB2dNjw5ixcIWQMDwdzAg/ghsipgAs7Vy3bSCd8pQbo87yOvcyOL9TOWEdt+VTkqZJIp6VsNGMdY4xStauufw5nxJjD8XYTGTtzKgsF+C6rnDQjeVqZZJxwY6xxd3oC2QiS5FQEGNKqFjNRdVQvulu3UsrLKN8V9I9GGZ6RcpkoO4YXYA5oSVr4tuo0LVSAfG/Aczr9g+2Cq0/Fncg2VFEV2QHMZI6ZnwgWNm7GXRIXuMgpTodPoPT4c7kyDbRtbG85w+LpBxvLPnWl0wZwIK+7rNOJQPGI0IjWcu2Zi/0AcybM0O
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6027a6e-97a0-44e3-351a-08d824dab22f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 14:08:18.7072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3l9KNayyOCy2GNU3Xj/7IsPd7r1lkHHo74LjY4WjW2Oi0r1Gq2AkqOBlbmQMKMTniLfWMy1ieAgFmuPN7BoFmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4387
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:48:03PM +0300, Andy Shevchenko wrote:
> On Thu, Jul 9, 2020 at 8:58 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Define phylink_fwnode_phy_connect() to connect phy specified by
> > a fwnode to a phylink instance.
> 
> ...
> 
> > +       if (is_of_node(fwnode)) {
> > +               ret = phylink_of_phy_connect(pl, to_of_node(fwnode), flags);
> > +       } else if (is_acpi_device_node(fwnode)) {
> > +               phy_dev = phy_find_by_fwnode(fwnode);
> > +               if (!phy_dev)
> > +                       return -ENODEV;
> > +               ret = phylink_connect_phy(pl, phy_dev);
> > +       }
> 
> Looking at this more I really don't like how this if-else-if looks like.
> 
> I would rather expect something like
> 
>                phy_dev = phy_find_by_fwnode(fwnode);
>                if (!phy_dev)
>                        return -ENODEV;
>                ret = phylink_connect_phy(pl, phy_dev);
> 
> Where phy_find_by_fwnode() will take care about OF or any other
> possible fwnode cases.

phy_find_by_fwnode() has a different purpose from that of
phylink_fwnode_phy_connect(). Current implementation looks good to me as it
clearly takes different paths for DT and ACPI cases.

Thanks
Calvin
