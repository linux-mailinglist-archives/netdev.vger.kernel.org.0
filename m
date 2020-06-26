Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9806E20B312
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 16:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgFZODC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 10:03:02 -0400
Received: from mail-am6eur05on2069.outbound.protection.outlook.com ([40.107.22.69]:9313
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725864AbgFZODB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 10:03:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2kh5ogZV0VicsLYzB4wzyASLtRqKU++ptFXaKHVjx2sBmgyIVPF7G2W6bL1/Gv2ObxWAde5oIMxqFJ1ecCPNDKxlIiiNu3fAKaHWwl00pQsXbvbCx54ZUJuptWBwL1wYeYh/uYz+JCKyJuOpOZ53GBLMh64u9q0LGtxSti6XmDjq/+mQu9w9ZFmKyLDntxq6wMgzUJtnc4cgUdkf2FwUiM+xt/83lY8lS2ih+RU/0mMhzrLFwJh0x8fpWAXxrS6Xk711Q+D2RWoiG5zM2TuJ5LkRsiZhVe+ieLeTBsyip1k/nOSXNv4gYg8rAPHgqgKzNe08pkDKFq0qmEU4j8GGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Dqfp5rb93+3dhlSBd4r2CdLi3R/cw9ZSTEubOcNK+Q=;
 b=bAp6Kvv58O/XH/319pCzfQxNXUFnx++E6HPimyss+InupDYQYa32kQggmARLI9RRls6ZaEgWtyyl1WgbraH575Bm6MxigaxK22WtGfQ0JBleTkoquXYEoQm4BZQO0GjozOtQ7RlX+DaZV5H+9niY44XbHZ2oq6TkXK4/bfM18CEL3kaQWFXQd9YCC6Dk+sWNfqTZGmvwghxtlWrwyQx2Vq2nsGhyo15ZVmrEd+q6g0oZ0F+MEhp4A8R+ukzlb9WMpAeis7WmNC8x87KvGk+DrK4Ia1HmEAAoERvMS7QhvNliVRqy6SJh4lUdhkZCuSA+VrkPF8Yc8IXkTN/c6fO/yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Dqfp5rb93+3dhlSBd4r2CdLi3R/cw9ZSTEubOcNK+Q=;
 b=c6EN+VOP500p++1kr+rbSxJJvzL4yAn350AIKyJMSyfxLJ1+r8WnFos6UwaGzJB8tOJAn0DO3+KTsiJ4wAo0/BSEX2PxGVzuTKbdKTqGQZ6sDZzR7Tcf8tFtY6Ubvvc3k+w83B1f1/6ACi7mwludVfmk/elLsPCmCvYaPI8m4Vg=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4929.eurprd04.prod.outlook.com (2603:10a6:208:c8::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Fri, 26 Jun
 2020 14:02:56 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 14:02:56 +0000
Date:   Fri, 26 Jun 2020 19:32:47 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>
Subject: Re: [net-next PATCH v1] net: dpaa2-mac: Add ACPI support for DPAA2
 MAC driver
Message-ID: <20200626140247.GA17041@lsv03152.swis.in-blr01.nxp.com>
References: <20200625043538.25464-1-calvin.johnson@oss.nxp.com>
 <20200625194211.GA535869@lunn.ch>
 <20200626132024.GA15707@lsv03152.swis.in-blr01.nxp.com>
 <20200626133942.GD504133@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626133942.GD504133@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR01CA0108.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0108.apcprd01.prod.exchangelabs.com (2603:1096:3:15::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 14:02:53 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d70d5d3-7936-4f3e-149a-08d819d9a07f
X-MS-TrafficTypeDiagnostic: AM0PR04MB4929:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB492983B6EB307A74434638A2D2930@AM0PR04MB4929.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gNp9f6xTjchg0xyxyZvjeGuaJDLXwBiYrzpONCC2pboUW+LYKPyVVlFtB9uh1fJezdn3QLbl++3/8GV9gSLYtccDqwxWhjhDjnTgkb4FfQXxVw8LwYuiKK8BdLJX8w/u+IP5cZuGCfSqZx5/E8e61AeUgi7Iupgm48pFjDfLVNY/6MClYkHEWTzQmMWniyy4zSHsSXw9E00DOFxgot/o/zJRjj3TecXOXeIGsizl2KOVkXbdLBpx0j3gVJ34GyRF/DpA1mN7KcHhB1LrdB0NHBeg4ug4jmJGc8vbaP1fBjVpIlBrXV5+7E9clmh9feuimmr1YG+JDJuLNiqV7ZVJnKBF9KO4xeXUWX2nr2EdGKR7PUMsdQrwznEclgWuemNk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(6916009)(54906003)(66556008)(33656002)(6666004)(66476007)(55016002)(5660300002)(2906002)(44832011)(9686003)(956004)(1076003)(86362001)(4326008)(1006002)(66946007)(8676002)(16526019)(26005)(186003)(6506007)(52116002)(55236004)(8936002)(7696005)(316002)(478600001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OG34vpBoRfETnj82gV2mF6bmDqfbekIc3UXfov6dGVRTByjGBrlJrJTmt8gt/tSYyTGw7QSiAKQMPlAtzpbXa7byN5aWQJdsOs7jmAtvhGNz7HIjXK8ft56upSFBWMW7Gp0cho7K9FAYvWxNs1VAif0THmrfSPAxY/ygnvjbCMa5JGQWg45L8BZ+lpH0b8AHT4+Qfc9T0Vho4soM8epK2mPmKDsvz4K20F6fV1xr1O9bEZ3Kyf8HKzO4OJt0Fi5a1GHnsRQz3EWIYzAse7kxVaAe+wQ+A78UoThqQpUk2OmvW/FR3Ps+PiQuu8DKzPalVyOMxrdj7RsViNEyfad2Gk8Mw1Dq6qscb8CvpwbKYkX57kt+jW3qqkB3PZ2u4/Q/LRQCR7Yx40sTjUgDlj7wowv4HaklH6HRicNjiydhgsGQDaqBT/H4VdQgIe2IchFFFHr4cdpnmqZkY+aF0dYCusJNGH776SIXd/hUZiVwvv892aESrtF0hU4iPnGwXiuI
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d70d5d3-7936-4f3e-149a-08d819d9a07f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 14:02:56.7563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQGnj0bX5VUqIZRQc24SA4GSyY8/LHxnhxDSwycLitsztEmws1BFQEBXgjavnlHkTLKV5qRiritMHxjHP8oYvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4929
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

On Fri, Jun 26, 2020 at 03:39:42PM +0200, Andrew Lunn wrote:
> > Hi Andrew
> > 
> > As you know, making this code generic would bring us back to waiting for
> > ACPI team's approval which is very difficult to get as the ACPI doesn't
> > have any opinion on MDIO bus.
> > 
> > Like other ACPI ethernet drivers, can't we keep it local to this driver to
> > avoid the above issue?
> 
> Hi Calvin
> 
> That does not scale. Every driver doing its own thing. Each having its
> own bugs, maintenance overheads, documentation problems, no meta
> validation of the ACPI tables because every table is different,
> etc. Where is the Advanced in that? It sounds more like Primitive,
> Chaotic, Antiquated?
> 
> Plus having it generic means there is one place which needs
> modifications when the ACPI standards committee does decide how this
> should be done.

I'm very much aligned with your thoughts. Making this generic is the right
approach according to me. Is it sufficient, if we get net subsystem approval?

> 
> > If we plan to make this approach generic, then it may have to be put in:
> > Documentation/firmware-guide/acpi/
> 
> So looking in this directory, we have defacto standards,
> e.g. linux/Documentation/firmware-guide/acpi/dsd/leds.rst.
> 
> So lets add another defacto standard, how you find a PHY.
Sure will add.

Thanks
Calvin
