Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB4727F847
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 05:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgJAD7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 23:59:12 -0400
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:60997
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbgJAD7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 23:59:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyo4LOZadjNKenMW35LCUH4Bt/m3kXl+UV+rSFvTyqkqpMhd4CULH73duMyJKI0lJkYZ/4gzBs9OnDDg4FYxOk/gE1pc1GAz8yQ2ernKYEKZwvQI4PBg9WqawFc7xiBZyhx0dTsDZVUo7F0sINuxIrgmygBS7mGnyrHTR9m1L5YNRa9lD5Ns+GxVjwsCbVaJKL78htXIP3jaeCNJuZDHtX0vGf2RdlknYJ7I62jEPQxqkqxqZJjHIhBnnmGn/436CmalvMgIi0T/4Bvwxsj9esaTA4Esv7yrsF3LpRCltgH/nLOqvaTWIwQBqsf0XNw4JFDD8lR157Z1Tt3zOO6DeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lvOQdyhN67yzfWPL1lmeJ2ev2402nhYzawTngIRNrY=;
 b=UYNCNRsXUu6yasY1XYCMAGkGKLljVDhqNphoUo7VXTn15/W3UfJchwg3UqxD4y0ztlYR/izvuoehResPxDE0PVJMKwPKiDM0IgOm1tUr/qWL2QCROXcOWGh6YpS676HNTp8R9Nh62anqS8ciMrtgI6E4mIWyjC7kaEOUDkA/zJX7RHEsOtBjIpdZBxT0Ec/Gau4zDJuaxyHEB8AnmcFBwL8IDQOBIIUYfB5eMqL05AdERA1X7f2QUiaJ0gt3DKoWmRaejlsN4ujbVg/cq0KF7JrcFaBuL9ivvD1w5oUPJPBXH4/Mve8bJlFZKpx5FhyZqpzxLMlKzn3UaJHilsDs2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lvOQdyhN67yzfWPL1lmeJ2ev2402nhYzawTngIRNrY=;
 b=HzBgNAgU1xgk/vq6nAT7rkywuty0ZXftFLCjPmdN9QXc1T3JHgnWmIL+DTMm76hCq0jnl30AEf79nDPI82GaLkUPIHul/L42bEOSkAGvOESXJN23ErqKwYl7eMCo+Ngw5D0b+IFkDaonJy0dfYnwcdk6Rm0h3Pmr1F4gwwEu2F0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7394.eurprd04.prod.outlook.com (2603:10a6:20b:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Thu, 1 Oct
 2020 03:59:08 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Thu, 1 Oct 2020
 03:59:08 +0000
Date:   Thu, 1 Oct 2020 09:28:54 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     David Miller <davem@davemloft.net>
Cc:     grant.likely@arm.com, rafael@kernel.org, jeremy.linton@arm.com,
        andrew@lunn.ch, andy.shevchenko@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, cristian.sovaiala@nxp.com,
        florinlaurentiu.chiculita@nxp.com, ioana.ciornei@nxp.com,
        madalin.bucur@oss.nxp.com, heikki.krogerus@linux.intel.com,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, diana.craciun@nxp.com,
        laurentiu.tudor@nxp.com, hkallweit1@gmail.com, kuba@kernel.org
Subject: Re: [net-next PATCH v1 2/7] net: phy: Introduce phy related fwnode
 functions
Message-ID: <20201001035854.GB9110@lsv03152.swis.in-blr01.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-3-calvin.johnson@oss.nxp.com>
 <20200930.150349.1490001851325231827.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930.150349.1490001851325231827.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR0401CA0010.apcprd04.prod.outlook.com
 (2603:1096:3:1::20) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0401CA0010.apcprd04.prod.outlook.com (2603:1096:3:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35 via Frontend Transport; Thu, 1 Oct 2020 03:59:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d29927be-3901-46a2-032a-08d865be57f5
X-MS-TrafficTypeDiagnostic: AM8PR04MB7394:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7394D83CD3B6F151BC1D5C52D2300@AM8PR04MB7394.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R0agJiwtmdc+ckEb4vTlZpG28dl6nssiudKT6lRn9W4IEKoIy+tVvk+wgA3cVgb/La2ufz47FC/PXXO9k28LsLEJSWJd1XIHaweVtGQ6Ez01Pj2icW8nsKdpiIfvRVcPDPctTztJlIZAglI70H0vC2GlW46M9ezx1bF6GDdLRqm8QdLN2rAUn0f7ozrh7gSANiFIAPKDXtWbQkO4sMF5Eyz5aaXkTifqlS6ogp8wo9CmQOF/pPDkC6dDhJYoTRW747bCBgJ9hdPZ7uz5bWl5qTAMbwmhBjlBqzPi8rW+LTeMdPhi/+bZJd1w958cmgOH3FtL3oFJWoG2GIiE6U84972MJ7xHS3VF9o9i4iXPv6K/FnD9qzjb17vVgMdNkx8D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(396003)(136003)(366004)(316002)(4744005)(66476007)(7416002)(55016002)(86362001)(6916009)(5660300002)(66946007)(66556008)(4326008)(8676002)(8936002)(9686003)(26005)(55236004)(186003)(16526019)(44832011)(1006002)(6666004)(33656002)(478600001)(956004)(1076003)(7696005)(83380400001)(52116002)(6506007)(2906002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 57jBgMgQTTFbwmLWR1atlTwEXQGmbsZ/Lw12ngZLMR86Im7mYpJFUZwTjgWbQau5abSmoCVsiXryQwXK0wR9wYvquy9yQ2wBYbM5FiyeFFPjkHrEWeYPRDrXSxiWeieqT1IXroUb/ydnjtGF+e2dWsUcoarxABhpif/fDlIojAuO9DO95hs3z3fqR1TbRbwAleQZOAU6C5XcqdhtpJ5eEU0xFMZ9x+ANh9BK+YSrVDzciSt8mxB119xdwz+vwyuGOZFiGLrc5bTVxJaXzBIMx+V5jUjDB3C1SQvqlzYR7VtwGZ5u4fizaif21c69t4brEjEHarUOOzC2jsfci6nRQ0O9bbNzjIoDIhPhZoXrP5z5+JOhn7wmoGac57yb1z2pf6RLO1CJHfV4EVNG0XvD8ssMZ0kxEP8FXEk0VmAWcGfhaai8lT+DWykAbOQwajFqn505/D75IH8lF92lSxpvAkIRicV3zRxvY+2YHNCheVJn2WPobATjT5xSjKi2mY07UqoKuKcMtlzG04gwPPnEm3uRI3y8Mg0u7j2JSKCYlJ23kDnPtndeFOJQVDaAOUOCtjIQIK1B0STR2yOJ5Cl/e2Aj5zd8oclrE5lKKJ5vJoLq1ShG4PvWT+9bfSBonr+YtzzCZH+bhbeW27PW3ZSMQA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d29927be-3901-46a2-032a-08d865be57f5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 03:59:07.9014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qnx5igjQdndlan3nlEPHGSyAsaCU7bIZKLIp70GS2M/8s5ALM0Z7a/GMw3hi47+rkEXFdEj+c5KKEXpMnXlHzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7394
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 03:03:49PM -0700, David Miller wrote:
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> Date: Wed, 30 Sep 2020 21:34:25 +0530
> 
> > +struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
> > +{
> > +	struct device *d;
> > +	struct mdio_device *mdiodev;
> 
> Please use reverse christmas tree ordering for local variables.

Sure. In next rev, I'll make sure all the patches follow this.

Thanks
Calvin
