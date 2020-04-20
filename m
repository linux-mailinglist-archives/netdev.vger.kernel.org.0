Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A3E1B1077
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgDTPo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:44:29 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:60823
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725989AbgDTPo2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 11:44:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1ZNt/5+icvVACrvv0kD+gig4kK44FTU12R+sagunPj7l07wjqIHXRmj36v8r3NOjPzWFT4JK4pyqT2l1mtjXDPORbiHkynFEBY+7/b/nBs+WUEYhetQ83xqYYFN4lePX/6JFjNIdxobfMEOg+i1gjj9ENI/SFEB893GzHjgiQMgK3QC4MKSFIr5HhtxgJHtcMH7ajp9EQZ4up/Coaczcuo12czNlrDQkA4rwJrHaD9WiHKh+8jcH+dwSKRQf5maHLVJxjpSvdm6o/U0uls4puyC0psQi2JFcnix6XknFgH/2hMDuk2SPJhsRGwP1+IvZ3FRnieT1N4EoYqm8x4P8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKmi6CM6lrwXIV4zE+fnNheHW5ZNafCTDcsZL1gvaHM=;
 b=K1WLTRqlzvQDd3ki+RD39d4zRXzyEAVmvLUFjCRreMpwsvkWpsrHZgo8xvyKDEJkkW9JYfRqD9/mX2EwvjEpvVdR9XMHLQCzhuTovg3Cx+bnwbyFdEm6FlW2brYMliUQrr67LpIYOSY18Jp8KcG5dX0ULs12naVuQZfrhfmgfpbZvOeKvmIlRpOxY7Bft0XVc+CARwl7uJ48uHC92HHZ6nUzXTuq/XC8YXBCru6Uo9JTzumF5ZutdNxXZ4+Wy+1pI+nmpRet6pAZTQnlbYqpBYFGT2IeY2GPsBBQNLFHBTWgR9u97d2eeZkIrkmUSOasFmVd/udnB7Ef/QQXkfwCGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKmi6CM6lrwXIV4zE+fnNheHW5ZNafCTDcsZL1gvaHM=;
 b=TXh2XOFZ3cdaYYX4qLqgrRzUMc2DRe412TkhHIdSuTlHMgtd/lTe7+45MUKwZ6Aiuu3ASr9fi5LQWddI1m1xWmLFR60Cke01IBE717H3lGLRZFzhSCyd5KVfWY77ynLYNlsmuWPjmZfLGxhsIAkgU3HQqM5v+qE7voJ3jkLgMBI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4674.eurprd04.prod.outlook.com (2603:10a6:208:75::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 15:44:25 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 15:44:25 +0000
Date:   Mon, 20 Apr 2020 21:14:13 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC net-next PATCH v2 1/2] net/fsl: add ACPI support for mdio
 bus
Message-ID: <20200420154413.GC27078@lsv03152.swis.in-blr01.nxp.com>
References: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
 <20200418105432.11233-2-calvin.johnson@oss.nxp.com>
 <20200418144606.GG804711@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418144606.GG804711@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2P153CA0016.APCP153.PROD.OUTLOOK.COM (2603:1096::26) To
 AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2P153CA0016.APCP153.PROD.OUTLOOK.COM (2603:1096::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2 via Frontend Transport; Mon, 20 Apr 2020 15:44:19 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e8a6f6c-ed36-4980-67a7-08d7e541b3c4
X-MS-TrafficTypeDiagnostic: AM0PR04MB4674:|AM0PR04MB4674:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4674188729AB4A97ED138C42D2D40@AM0PR04MB4674.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(52116002)(54906003)(44832011)(2906002)(956004)(4326008)(1076003)(7416002)(316002)(55016002)(186003)(6916009)(33656002)(8936002)(8676002)(81156014)(4744005)(66946007)(66476007)(66556008)(16526019)(55236004)(86362001)(26005)(9686003)(1006002)(6506007)(7696005)(6666004)(5660300002)(478600001)(110426005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FNb0fx92b4ChTKVz987kUU/gXEh84AghI5d02/4DvC7pe4tfBrLBSX4pTfnNjKSoSj8SNz2it0oPJWDKfMeWpR+lo6VbfQGAzYW4YKIx0aIHbpyZ8q6Z2JeONacWVMtvypVKS22jgFJ/r31g/cB7jHm5ULLmIDdGSa1t95W91Ob/1jtGZS7bbOUN1DiC3QY1hsPi/517wkvjWX2+UkTuRjuUs/nKhaphhYeEK3FoIirPje1xdcAQ1pOo+Kf7Ro/wnKUIgoFsZ7ZXMVpA1QPTQGuxio25PTIHN5a7cKSS/wPOuYbqU2XD3NTyBzP6dbB1kUqKC3LgMI/83apdGNGXOKlxivtllq4SX3AtMOniRHqA26Q0MlcJGmtYDQMUQgBa/NhbgXFIxPk/fGEla85SeSEUhl/oODXgp2CoPnWaZcm4VTUSEdaSdyDTD6zQ9FLq14o5AfBNAzu+kZitNbLTFW/n5Loe+gr5ACqFbebBGvAl0BSYNkJSipGSl9nJnlis
X-MS-Exchange-AntiSpam-MessageData: E8EgMCd1mFpqvArF3OzE+hMF6MPPrg3W1j61b4mhn1iJ1kkP0XdNR6m+Xp0ln7B7fcg8+El9U5RGIRjxzCOYaRCQqwHdhx2tKuyqV3j0O2K7EIaKfctZWlGq0cAFgV+pGqKELnTDt5Q/tXG9c3hddw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8a6f6c-ed36-4980-67a7-08d7e541b3c4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 15:44:25.2849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSajlLAu5oBjSpnwtH37+c7fsbf6ntm7N3qcIWm8n1gBFVA6edDqemBRpaWwwLGbtUclAqW0Bv6NBKA9WvjTDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 04:46:06PM +0200, Andrew Lunn wrote:
> > -	ret = of_mdiobus_register(bus, np);
> 
> So this is the interesting part. What you really want to be doing is
> adding a device_mdiobus_register(bus, dev) to the core. And it needs
> to share as much as possible with the of_mdiobus_register()
> implementation.

Sure, will take this approach and submit v3.

Thanks
Calvin
