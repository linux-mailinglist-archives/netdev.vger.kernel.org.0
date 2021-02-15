Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11F031B550
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 06:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhBOF42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 00:56:28 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:9374
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229652AbhBOF4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 00:56:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVMuIq3TZ9pGDzY1eAMnx7HNCBzI/bj5ymjLn8DTPPCG4AtoIBv9bkEeze3GWOjaOK0FtV08MHJrM9luMVp8PUAVyzUjA6MkgE5BYQnWwC5KYImC+UYVZg08xharQdDUILzVo75r0PeTj8e/KMZZEixL4E5zSSUyE3SxcZKqC1oiBcDhkg5ViFVMDrSNl1IX1cas4QXshYdhPWbfObs7B9F1zCobdwrVHXHYvE7TlPxS5ZsXP9zFObB6h7Xtj/x50Q7s/f0MCapKL/oi3jbvtBI2ijGDlTc/4NDDqc/6BuSA6lg2OpzJeE0+ir0goAY4o+S0+YRxlXK6k4oAa/9uBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
 b=Daj6WMxvVLK+TZG/lTnZW60SEQG9QqtEROo+lgrAKE6/PG8g4Gw273VFjFVx8Z6JR5i7bMW6gz1ngNbwbMP/UPE/+uXKg9zrwbI9qdLMprKtClErgyyvTb47OA4SS/IOO3uy8arnwyw9zbrNZjfWZ3+ivxjMS0kSioyZ6iS3Z4sgkwnPjQbo47N+cCKpVRwhvqUpb2M4CrFM9qrarza1nl1aZ0DYs7qcB5CIjBxyeEFWR6+Y82/BVSuS7uPQrO4CZ2lbejM4iO4RH8gMkV7zZ/ionazMpgScj6cEndkeCTfioSLLzut8lUZez4biedMS99fIOj/isr3Oj0kGha0xCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
 b=ip2tZSx46zoCQKEtUSqlGAEmLYyj7H+xY5Hlo/AWdAWtyO+0utwiRVmwmTuXmxxCprdqi8hh9iMlAByiNT8AN4cGU7l9PGizYuNa/OOYlJbGxwN0M83tLQyhf/8Fmg+EfYIy4HyDAtDS48AEWwJ4yYo5C2LvFrciK0QTwX0WyMU=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM9PR04MB7505.eurprd04.prod.outlook.com (2603:10a6:20b:285::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Mon, 15 Feb
 2021 05:55:25 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Mon, 15 Feb 2021
 05:55:25 +0000
Date:   Mon, 15 Feb 2021 11:25:05 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v5 13/15] phylink: introduce
 phylink_fwnode_phy_connect()
Message-ID: <20210215051452.GA14049@lsv03152.swis.in-blr01.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-14-calvin.johnson@oss.nxp.com>
 <20210208153111.GK1463@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208153111.GK1463@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0160.apcprd04.prod.outlook.com (2603:1096:4::22)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0160.apcprd04.prod.outlook.com (2603:1096:4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26 via Frontend Transport; Mon, 15 Feb 2021 05:55:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d91c34fc-26d9-4c32-1033-08d8d17649a1
X-MS-TrafficTypeDiagnostic: AM9PR04MB7505:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB7505FED2DCEFB693A28A054DD2889@AM9PR04MB7505.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ae1foM/QS5qk1rmOpru2nNLkPA55eWTSmd4j0vSlovy242QIQ0M1L/jxo4dA4KOB8xaZq4AMtFvkrgjIMCLFR9bkJ5vKSvUC60nN4PVLNZcknY40qILMePLkNj0WmGspwBM1e2pqjCwYxmKjOoVbNWJiVcsTNkRGDvtytyMNplYe1cRNzvHcgvqSkwAnrN3WpcD8yjQpLiLqe0t1UbpCOII7+ilV80gXrIG76Qlrx+8pCz5tcGmbjeckzOidcHAuAQKwqhrRynC2kJJYySuDcqwlDCxK4oTBbUIl04lxPMr9++4ygQcUIcRc2q9tTP53
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:ro;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(86362001)(33656002)(1006002)(4326008)(6666004)(9686003)(7416002)(8676002)(55016002)(478600001)(52116002)(73894004)(186003)(1076003)(7696005)(55236004)(66946007)(4270600006)(44832011)(2906002)(54906003)(16526019)(66556008)(66476007)(316002)(26005)(6916009)(956004)(6506007)(8936002)(621065003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l/N0b1XDwhtnsOQ2PveCyDH8hcwoMjWA2vCLgLLMLbN9+9Nrk4Ua507eHTtj?=
 =?us-ascii?Q?TfkWffXPRS8VnwnGLOLVthk1isalyI9+GjYN/XJGfRQV3nbzfe1869+I75Wz?=
 =?us-ascii?Q?aZmlxZIzQP/HXopAEcVhZoPwPScjDSSGgf111ggE7wYOvbqlwN1gZ+1med1O?=
 =?us-ascii?Q?wIfePJVqqzT7ZiL16Z543u6XCesfpLUc7VWDC7oyMwFhZ+niRpvEGcm/wRfH?=
 =?us-ascii?Q?0rVXgJNBKfYB7Ra4WSKUeZdVn1GVJ+swjRBvOyApBbIRN08XsqUqbeXRUfSf?=
 =?us-ascii?Q?4R5t23Rd3e2VOpcuX3xxbN2ExawAAmJJgpK932Cp2sM0SAr5g2ZmDmyr7JFb?=
 =?us-ascii?Q?Kv+arQV75iTJNtPSiBjn9fIQR6pmtxDYzko0rP425hW+/6N1Uh7HNGLMH7Lq?=
 =?us-ascii?Q?raOE2d+RU0FZ5MRUhsxZ46IBX7eFru8cNukEvl+7VoeV7ndEYD5be0fvo02Y?=
 =?us-ascii?Q?l62FJeUajoGnnrXrqHvacwFpVbFNPKkrX24advLjJXnb4fpoXLvenPraCIoq?=
 =?us-ascii?Q?ZltiAT2CA7GDrbY+StEv+UVDJMnY+uOy6XATee9oG18sBLH4wic9DNHeeXzK?=
 =?us-ascii?Q?W1c7J4A9BvL1gIOeHws09NGyJLkr6Bt+0XDi46F5qcJIvoR1bQ9kpnnl4X2X?=
 =?us-ascii?Q?fKOGrGH9uVBaf5Xz/rQo6DLJTlsAPQbtRKNKtIlOfEQmc0sz/ShKOYEk/9a2?=
 =?us-ascii?Q?SCSdLsXCEaKUnq44OCU+N0c3CzTQZFgEkYhLVJyZ3Wro/NP+4nq+3n2sYxgR?=
 =?us-ascii?Q?tgPZfd7sLYW3gVWHzRu6/zRfmrbjm78RuF8l057ZU8ps+CHI0MMQPcKSZj/Y?=
 =?us-ascii?Q?Dr5U+K+r32ajD2n6O4LI5z3mHZXEnWPatGpQqbIPagDpuYyrl8y6FbG4M07R?=
 =?us-ascii?Q?yh82FO/x16MZmt8Uf14smz7f82/PooAockLxaBqpl6WeXSP5irVRzl0pD7Yy?=
 =?us-ascii?Q?Cdm0VJE/i+xNnGw4UiMCCCuVoqPk1t840UZR20h8MKGEakCHQQWdydJgOdEC?=
 =?us-ascii?Q?SxHO9hkoKBIbt1P5NJnZZJeIEUSWIxY6hRDmrG8/MSy3dsECNwpev2PF5ZFL?=
 =?us-ascii?Q?2vy4nBYmoI+DPnw/Wlaglx83gVAeb1f+G255M8d7J+Gv74STUVXxPjlOQI8O?=
 =?us-ascii?Q?QazCYIxwi0GvcZu/Btzk2t6e5Eu7GAQi/rMC+Wprog/bQf+1n2DgPww+qHPp?=
 =?us-ascii?Q?MTO0h2Hep7xmFtRpZHG4JnCyUaQ4X68/Guqc8nHelyGhL+OBqLL1u28GBkVY?=
 =?us-ascii?Q?Na0klYfc4exVOXyodDAIsEBw1pG3/w3+OhyR8/wMakhpgb7TumjxsVGaCpVR?=
 =?us-ascii?Q?82UP47DABWBu9zQuxxor2yq+?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d91c34fc-26d9-4c32-1033-08d8d17649a1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2021 05:55:25.0110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGMEMG2pi//IVtqgn43Lt6UT6wfrVFC+HIkmyUWfLy4j6XzmTjwfbWzgzQZ6vpMnZNTV9pou4XFwyqisEsJG2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7505
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

