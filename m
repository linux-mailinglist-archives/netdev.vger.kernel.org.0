Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329C247621E
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhLOTtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:49:15 -0500
Received: from mail-zr0che01on2123.outbound.protection.outlook.com ([40.107.24.123]:8606
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232931AbhLOTtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 14:49:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tuh/vS0LIdjnGQ/NiIMROKzwGaCeFmQ9ZnCdv72Hw4vk0qfDmzfxVDSUJe0PgBYvqbnp/CXJwzAnqnFcHRK29BfMBB6B9UCJaYnGG028JdzFcCYPjvdfozwPv5suVKDK5bk43MssXfIHv+C6c2RISq4kbCN/p5fM9tYVbXroE0ENtQQ2u3XeyhqVA6aAmES+usfoJbKY+LHVatDLPUic+nh+388hTdi9WMPQf9eZ6BQywu43soNswMGQqTNd9nkUELs/mVR6XPMu8jsHUsUZJ1Tljuup4rz0dL7v1WnZrVlzg1/EB/mEhE+68GFwaXsyTfkk23vpDj+kZe/2WaslwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHxbU9IyhYZN/BKSKwhyT9HbOXBAsJnQYmUExeox68w=;
 b=nPIk+xfUJbv0KFzWGv86EvxJfPiYGvAU5RMoZNXtod0a/iZ7ZsqxfWe0FKIsFarHnnG1MVDDPKf3CI9adhM6sWDHb7qrYwiJhwhBXhSfbeR+K8u1U1nPrDqzH2chlVMo/FU4aI6v+9ZgQ5D27qhxX4jxVjy7LM3bqfx8QGS0eZf+s2nX/orhePBpF0S9PbW9MdauwvEGHDLeEyaOB4eyFNUfzDYo4w9mPjNEQqdrL352b2nQLtBSmQ4Pot1r7ImbuqGWnxlqq+jFpE0dUNAnBsMvkKaQpDliuTqJDGB4f6TWAsPuE4aRfUFHFeIeB0+7LoTrStF1sO/EXuQG2Z0w+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHxbU9IyhYZN/BKSKwhyT9HbOXBAsJnQYmUExeox68w=;
 b=OBoOwW3W0q7ICFJyykkHk+0YjsLFB3vvB/BpiYEJ2f3qd1WYfq0wMH35Fd1d8ENAalH3DT+zmNK/gy/5lzeFRa7252ChH0VV43nHiiXvXpAV6Y5Lt200CDhXg7HzsniFHSuA/qSqhJ/zX2MUUv76GGvqnUbnyIveAL3Jl22swUw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZRAP278MB0416.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 19:49:11 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4801.014; Wed, 15 Dec 2021
 19:49:11 +0000
Date:   Wed, 15 Dec 2021 20:48:55 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <20211215194855.GA114534@francesco-nb.int.toradex.com>
References: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
 <Ybm3NDeq96TSjh+k@lunn.ch>
 <20211215110139.GA64001@francesco-nb.int.toradex.com>
 <YbpDKH6CaHzm119W@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbpDKH6CaHzm119W@lunn.ch>
X-ClientProxiedBy: ZR0P278CA0135.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::14) To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b1a0e0f-e52f-4e5f-e4d7-08d9c003f71d
X-MS-TrafficTypeDiagnostic: ZRAP278MB0416:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB0416FDCA9DC2E68B3618A8E9E2769@ZRAP278MB0416.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c//UdF+gLhNw2/NI/gqH7Whk1KAKoPNqPqp421kMbRXTih3bSVFOgZG6OeI+Zx3EkpU61fEuyiBrqLx4dLcgthfAHDbIHEsBiOGzzP2346ZeUtzzYgCtf7yQSziCtqePhb2KyIYL701bl75R7eQ5+toNW9HGDfUTSWRw7DxHINdX9k4o/PX/0c3HDDPaWuM6M8WGLxDPFy/6MDCG0EOIF2CmIfQ7+f46tRNyArEi4pxTcZzes5ZkZzXx1XRpNp4+xA/VpjJ/5a3E3uCmx3AuZ2k7/ypx6MJzCkP6duErNq0dG6QW2zii1ZnnAfM93ZWsNIsJscegbXUBExx6o53CdtMTHj6nOHcOvFVf5sKNoEaEllsf6y0VnwyN0gweV2LoCmVR2O2yUsNnC3C1P7BxH4zWYHLByfZ8T1/+BSUYDhp/4ICKJFM1VGAKc+90kACb0HO7hYvCajHdxfR0m/YBoQ6Q4zl+e5ciOfGa024sva8BTBOU+XtZi5Yymdo3wkPOO62APc9dZaqstmNwfnUvUcxro3nrb9GLgbxMr2g02LdYZNmSBX3MX/nxxm0fbgeAetH/NZp2INTGYYxCisaBZOZN7O+z6jb2SrWooIbNGxsPZlPrMKT23g/RV5/Jdz2rF+RzUK6Rra0yCTfvpmJ5u3ZnCY8a93nId85vAmg/VErXDaloSRyoL7Vx227LIrMmDcUWgqN8LcKzWrC+me4NZTFHCZ4EKLOldkeeWUB2xJYSn6qfOIh8O9yF5X3M/MljdACdQxWwv5eZ4FQPMN4qAJaR4aukK9l0aRYMwFvdiAY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(39850400004)(346002)(2906002)(8936002)(6506007)(6486002)(1076003)(52116002)(38350700002)(316002)(4326008)(38100700002)(4744005)(86362001)(44832011)(6916009)(33656002)(66946007)(83380400001)(508600001)(5660300002)(8676002)(26005)(6512007)(66556008)(66476007)(966005)(186003)(54906003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jUNSJT+1cdpVADIavVkZES7ASxeoKxiKW+vv/6RgWZxEjEtwNd5iW526Xcm4?=
 =?us-ascii?Q?IVu41d1+eOVwCmJABuPTjhe5C1ea5+ocRdOU7IWzcQObIoOrQIRbOqRlUcx1?=
 =?us-ascii?Q?biXeTBTQD/AB7/CFgYnl68bGPPGkvPwReIIDI1F2DiVyFPNdSe6vrL6gSY4l?=
 =?us-ascii?Q?uBhDngYsK6JOsQoWiITMQ3vr1TFIvlf3+qzCoatC5sdsvDD7QpEhLBP+vqlV?=
 =?us-ascii?Q?vOR9CqzhRxmEej8Q5aj/+c30/ERg/GrH8sIWoQ94zODDMURLxwN86P92if7u?=
 =?us-ascii?Q?KtHGVFLNyRCuIAq7I5Nf6X1CPXUNCn0ome/SeRbUzuFxy23hobrAW3lO+Irt?=
 =?us-ascii?Q?rr5R5FPqhvMjgagP3CBasjlR62HoLk9BqPWTpPzXdhVxolQFQ7aHILAiXxhN?=
 =?us-ascii?Q?JorxC+qRroP6YMbKOF4kkspmnm5fTx49ZS+mDwFThbJZtx0OlMVOHZA7yxkw?=
 =?us-ascii?Q?ZC3uiiwzwsUOHFoVv8hmp8TnpIUb53szVe+/Au2736k1wHoCLKzWc2rvSO8h?=
 =?us-ascii?Q?NqbUN4JPHGoVj9KkK/kbzGOcHhAfC5leu66tRDNRpzn4Z/dJwlYkV8I/uNXS?=
 =?us-ascii?Q?PUYMboIF4uFcfolbvUxuzLLH4k9hULWryUM9Vwp+0NWn8vRwFYzm1HXsuaT3?=
 =?us-ascii?Q?bTxuykB5Q4UEV2Gmh4hNTHN+V/0QwgxMcD3OAtNq4FTO3L8UnBa0DMq4GIep?=
 =?us-ascii?Q?kmqqd3Duef9+nc8nYCY42qzaQL8jaXrSTihsAKVW4qyZ3PbwtVvOww61sBhh?=
 =?us-ascii?Q?E1dCchc7Ek/fk+/ZG0n8lmpOMAPdNzxJLdvdqVxtfsMHeQCB5GL3T/kB1FM+?=
 =?us-ascii?Q?qe3jeTckg8U3gwClbXpbZyalYlUwHCoytM77oTJ2vsuL8d8kZhbTZsnmEOsj?=
 =?us-ascii?Q?956r4ptedc3zI0Wt2W9TSW6/yaaXynbZrtrupauDVLLyLR0Lf9UbalGkKWnl?=
 =?us-ascii?Q?G410n8GBdg9DojsLHmEy7ISFS2r1zouPZCkyttnRJNX4+rZ1EppSoV4kFSg1?=
 =?us-ascii?Q?06qm2v4ea5CshKQF+AFFNXzPN3htHjdT1SIidxEiLXQBIRV9vFQ5wo+RN3ED?=
 =?us-ascii?Q?75OmnKwjX3a3TcLXpWYrI48xXv1sCIe7dt6DPt23N0811Pkm7K3TaZ5dAqYf?=
 =?us-ascii?Q?Qd6QEE6hX1qrxjL3B0/g5reQxtAfHxrOEdos9WR2k+ExT082QVrUZShEV/Ts?=
 =?us-ascii?Q?p3Pa6AlBw93RaXMUP0OdbhuCaoAq/F5GcsnJxB3Mzf6Bt0Y/gDhrPpXoXE4a?=
 =?us-ascii?Q?vM55LvA9SEA8+4PJGQU0grSrnuJcTbsvfhOiTUS2CcKtYo53KBunhkl+/kSc?=
 =?us-ascii?Q?LJV1qanWkrl5po6JpGwAm8f+rlGs2qH8GPPopSXKuuRlh71FVNg5DgaubieG?=
 =?us-ascii?Q?giHkl9i6DAbj+RqzwZGxrBqz9lDMtWzxdZOsQFNtFcbBN7UkoWbNeCrWyZ2r?=
 =?us-ascii?Q?9O85qkzovRE2TpUV/8QxrWI3Ho4G7zkT2ihzcBfhV51MCeGfNdIGC1rrnFfo?=
 =?us-ascii?Q?zt4ht0Dc81/Zlic692GRUmXGGPps7CN+ewP6KlqtBQXwxo1SXVo2R/p3P7fN?=
 =?us-ascii?Q?DT8zqmY9SbB4r5ChXzqBWfvJok1HMtLeBcuEXxutw4ARgkQ5YhhdyOtd+FVC?=
 =?us-ascii?Q?HlOabqHQz1cILVvVQGPLjHgb6g4nZ1mdqdT7+M1zFtbNDBrD95Mlz6q9ZKFt?=
 =?us-ascii?Q?IqZt+Q=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1a0e0f-e52f-4e5f-e4d7-08d9c003f71d
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 19:49:11.4007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOwrpdZt3qbAL5r3beOQ7X88jA2nMsASjSIsRJiz04arlCocIHyXi0G6oZoU8Ppd4M/WienrisXEGHkBe8mh6LZIlNxAWrKFIljl8bQ+M3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0416
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 08:34:00PM +0100, Andrew Lunn wrote:
> > The reason is that the power consumption in reset is higher in reset
> > compared to the normal PHY software power down.
> 
> Does the datasheet have numbers for in lower power mode and held in
> reset? We only have an issue if held in reset when in low power mode
> consumes more power than simply in low power mode.

The numbers for KSZ9131, Table 6-3: Power Consumption from datasheet [0]

61.2mW in reset, 24.4mW in software power down (3.3VDD)
40.9mW in reset, 12.5mW in software power down (2.5VDD)

Francesco

[0] https://ww1.microchip.com/downloads/en/DeviceDoc/00002841B.pdf

