Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873732796F2
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 06:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgIZEe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 00:34:27 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:44862
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729231AbgIZEe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 00:34:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkaNO0ewz6MxEsIROiQBEudBO+w5kO278Y4aLK9Pct6SvaCinWrOodbOSgSF3cyzguKnBv6MsGnfZD6vjdzHN8U2mIrTJz7+PNIEMAU0HteZ6QUhsz0lPgeSDhB71HB0F38oVCu2Go0N8C9X+m1l4UaSE92ceKP15bmVkA+oz8kZKvDaYATf2LYk+vpeWHeR0YpVUXE2m7rKaFT9LGoa01qMnytcgVxstW0nw/PyDb3K4ZjmfF9pLr6XdKNPRpbEXTifcCSOCbvY2+RGmRI4wtnDOSjWg+UHHC0k8LY99XTAG+vQobX3oDZI6OvdrdIQAvRJRqGvX2ST5e3K+z/9sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOvpSAEemsJr6K/TIHFuB0cQTkeDVU4U9ek5B5KSuNU=;
 b=iS8Wcq784cp1/uGPkW/c9lr6IKQIToCrv7douKdW1WwPIFceE7xOz8HAkL8pBjSx3d2HRiD+xveNc5gpxloYaO70BnjAdBj55Ea4/VK/jCVSpG/MdL5IIdqUC36/yds8wIEuBw9yzVLVXrfjTAA82Nmk+Fb60PNalvTDEcSY5v4T9RtfBUOWJLYTZ2WGth3Ivv4jcNmdHaH6IddQuwkCb/vlYL3ogigOvdhkeKeCH5Qnph1y6XVw6YJj1nGHcFe/a8KtYGDyk21MHVa1vg9QqxcaVHvjUuO1f2a9B5qrWZZrV1N9vWzjQufOSCUFFJJfUVqgLQcRq3ItXE8G8CPjMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOvpSAEemsJr6K/TIHFuB0cQTkeDVU4U9ek5B5KSuNU=;
 b=B6lDrKdGyte61NDKvTaUpKdrEKq9aNoY/scJbAVh4RxNPVYqFoFz1GOT6LYZ8ad2MHnkw6wb52mpqCC/z4CGpYwtUubv+iZXMKqU8R9D2GjA+F8sJB51+CBHzfx8N4SkIJ5RlEVdGD9S0uy0qXsBapVQhoDnc1KrHbBNGOkuit0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM4PR0401MB2403.eurprd04.prod.outlook.com (2603:10a6:200:53::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Sat, 26 Sep
 2020 04:34:23 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3412.021; Sat, 26 Sep 2020
 04:34:23 +0000
Date:   Sat, 26 Sep 2020 10:04:13 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org, nd <nd@arm.com>
Subject: Re: [net-next PATCH v7 0/6] ACPI support for dpaa2 MAC driver.
Message-ID: <20200926043413.GB20686@lsv03152.swis.in-blr01.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <cb465245-8691-c051-3d04-0eaa97532a27@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb465245-8691-c051-3d04-0eaa97532a27@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR04CA0166.apcprd04.prod.outlook.com (2603:1096:4::28)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0166.apcprd04.prod.outlook.com (2603:1096:4::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Sat, 26 Sep 2020 04:34:19 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aded6526-31ba-48c5-3299-08d861d5715a
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2403:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB240349D9EB6040A3FFE8EB70D2370@AM4PR0401MB2403.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /g4TV1/QcoqqKv5CnTlI3+Hz526CGiCzC/rHGU5WXw0GCH4Nk2pchFiil2bIL9Lg9OtzgxbKWXGrI55S+O8tl6U95FVKNWWdsNmpjWVqzw3olLDYyY+Z0zlBDRiJouejpUvXhwbSmQbcqvVCMSE+CNQepChebn6/klbYCVqKbmm+2AcpwL0rFK5LilaFDGfmYfxtDLIbxQUmmIxShUxHpFEqeaA2CY/eaaZhr+PZKWFLbiB/QvV27FOq5PZ9M1FTqyTpL3QDao4RYYoXrdySZrc7ggRbBSyYtV2f7PDNPj4qyYtc5+d/6LYvgfR9yB43T052/+301gIiOp80b1N1Lg2hzM06ER/RWk29pYCF86l0CkRdNPtHuydYJNfONHuGiWpBUF602xwqxTuGa2XQdZN4wQAgBZTeFlYHiaE+UvXGZC91+D/YVYCNfViv83D7dEfPSjpM9aQlsYXPcU6isqvERZ2hvt/72lIotHXOEmVFMuSL5lKWGLaN58idB7Tj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(39850400004)(396003)(4326008)(8936002)(316002)(33656002)(6666004)(1006002)(16526019)(186003)(26005)(55236004)(8676002)(53546011)(6506007)(478600001)(956004)(44832011)(54906003)(52116002)(2906002)(7416002)(7696005)(66946007)(66476007)(5660300002)(66556008)(9686003)(55016002)(1076003)(966005)(86362001)(6916009)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nM6EX3EmJzGq5hkZw6ZpzpOD6N9Gu72VEw0S+FXxXd/SsO0tSUgfb51WcG4Yn3hvC/k29N9DxBTgPR4KtTMaZStMMfuilnLJoz0/kGQKr97YorFmoGn2rTCWif8K9YROUnDVJBIb7Aj7ZMcAmo7TNskN2vNZID1bF7VQSYzDywttA3z1P+F+JvF+KhtLmOisdUfJOqi2zptGD1SXT7kuObr7zDd2BFCfJzriLr7e5dIdmegXTP+MMyYaM7ekOoxsQTjEt58MrZ+7ZgBbhxy6g6+gNm37XE88tI1UPbQbGMfo9o2W6JsZ6thpX9JjX25h16a/ltSRWCFzSawmUts/bnjsFv6CDDY/1/QqZMc6sK7SQCqMQtf6UXIEbv7TbtCq4Uo9ieUeu7aIHV99CupXlANH1MAVFud6S++XkdemSE72RVYXZFMxyp5Cc7PZ/98aELBgVdo0d4eGYxJoYIq3qNA/+Rgfbj8Cjki5d55wpn96pUAt1ABcVzervIMZLXvBzkT9xH/OCyKYUDt+wHvtl7qHGVpOatJDzqmTRyBkMhAQan/71PRFc9JYzfpOLwoNFFHyXLZtpZYNHqmHUxYohKVHSNyRo1IPRkBkF85LKJvvN5XqUZaV7PLBEz3fEK9VAcuOUqC51PwK2YFdyuEGrQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aded6526-31ba-48c5-3299-08d861d5715a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 04:34:23.2569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehdj1AhRbDgsOO+1sHgBLDieA5bDJHZnRe5yZrs3rsMeNaWbUJIPr5Xs1XJKQRAI6nuN4nkohgfbfownoR1P9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2403
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Grant,

On Fri, Sep 25, 2020 at 02:39:21PM +0100, Grant Likely wrote:
> On 15/07/2020 10:03, Calvin Johnson wrote:
> >   This patch series provides ACPI support for dpaa2 MAC driver.
> >   This also introduces ACPI mechanism to get PHYs registered on a
> >   MDIO bus and provide them to be connected to MAC.
> > 
> >   Patch "net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver" depends on
> >   https://git.kernel.org/pub/scm/linux/kernel/git/lpieralisi/linux.git/commit/?h=acpi/for-next&id=c279c4cf5bcd3c55b4fb9709d9036cd1bfe3beb8
> >   Remaining patches are independent of the above patch and can be applied without
> >   any issues.
> > 
> >   Device Tree can be tested on LX2160A-RDB with the below change which is also
> > available in the above referenced patches:
> 
> Hi Calvin,
> 
> In principle, I agree with adding PHY linkage to ACPI, and I sent a comment
> about how the PHYs should be referenced. Unfortunately changing that details
> requires pretty much the entire series to be rewritten (sorry!). I won't do
> any detailed review on patches 2-6 until I see the next version.

Understood. I'll rework on the patches and send a new series.

Thanks
Calvin
