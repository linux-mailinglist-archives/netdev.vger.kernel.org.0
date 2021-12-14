Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79B6474268
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhLNMYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:24:02 -0500
Received: from mail-zr0che01on2113.outbound.protection.outlook.com ([40.107.24.113]:11009
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229809AbhLNMX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 07:23:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h19j63ECPHesiODCqlefUXqbfEN6YB5L0Ad7oz+gkEklnsVPROoo0kANHtudIGQyhea/siUoQSvzY/bOObb8oYe4wEAK8YFvhL9fcTzLJU0+RMFths4Skl/yivDkA8BQrDwRuWcZ8ZijW52sxhC7qZhEC/zx0es1x15sOd+0yx+6+iDlvVJ6qyKkCH8kTU6PYzCnFx5fsuYBFFixIi0iQeaReIJKZfpraUTagUXJajj7XmEi0FF4j6JGaUgWlqJjA+J6dHK58GgANOrxcudoXhHvcnaAw3tsF+2UXaejxmlijXnpwDUiqv2ARlqmXV3E544pWQ7rKflyZ8TWHA/2Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JiiRRoeQMargmtNQb6Z6xemVPJMUJGdLH9snMWoe7+8=;
 b=SghZW3fmKTUwQqVgGpZ7u5afBKSX/zUr0PFvnEoE9dLbf+sRPh4pHERCQTLLuhFCnsLQvyrDkyflrmuMHM1wz7A6F9pWpMNLLx5/qg/q32scqVwjL9g+NqlHWluntrY3Ge2ByaYgnObeI4oyIiGjACPSzOghmy4IvWWUNbB3n+wZiewYVh4XgQut3A/YOMVMpet4B1h1jFt3Ri0ru8Lzp4RW3v2xtB1Drt8yLttZMzCWzR5nnqGWnVDPio66hG+Rk28EH+gAZO1WXNptFDlY6Nb07JBXHxju9n2b+nGF3S1Kr9ozBjGQCQ34I74eVIspNNWPZDbt+emmj+S25nCjvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiiRRoeQMargmtNQb6Z6xemVPJMUJGdLH9snMWoe7+8=;
 b=WS4JhewaEaqtjAOgIB6eZzEb/XREMi6JkpY0hjKI72j5WwY7+mOzexunCWTCrzUsB2cRsXUxDDI/m0uh7vYXz2hZa4Y55jN2ncDfWANqn5kK63+RpQlf1IAW4msduDWe0Von4bmEsPO/xinToXOfvcbNmuuXgUkPUuwGfDMXafg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZRAP278MB0061.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:14::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 12:23:56 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 12:23:56 +0000
Date:   Tue, 14 Dec 2021 13:23:55 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Philippe Schenker <philippe.schenker@toradex.com>
Cc:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Add Possiblity to Reset PHY After Power-up
Message-ID: <20211214122355.GB13490@francesco-nb.int.toradex.com>
References: <20211214121638.138784-1-philippe.schenker@toradex.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214121638.138784-1-philippe.schenker@toradex.com>
X-ClientProxiedBy: AS9PR06CA0107.eurprd06.prod.outlook.com
 (2603:10a6:20b:465::31) To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9587441f-6571-4031-5a60-08d9befc9990
X-MS-TrafficTypeDiagnostic: ZRAP278MB0061:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB0061A6EF7A21866BBE16D28AE2759@ZRAP278MB0061.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RrNqR3x+EtYhxHm+/NV91QpqxS9GuTMgN0zZ14KbWBoojJHxuCJ7z23WfvD+aEM+4uMfByDtzmHovdg4pI97W59pDMDPAuPuxkt1oFUQSP+mo4hMftuyKJE+CV8rDpYtDXhC7vk+3qXF05fp+7FS2yiAuMcADoyVQjTNS3Xtde0ssFS+ukOAdsWjPeR0peCFcOWv0jkpfO43ZftF6TKBaPxHTw3t9ABwHasBOLh+HQWQGpCgPr9Msub8uMAwwV23Mks42W3iGaoG+lyWgtCOkFJU4K4KuehWcVRKHco2vgJxcjRJC9ajRaU/wj3Wsg0GRfAckVI5kwQG5YEZ9QBXnX9bq/wQdNSfGR+M114xeqlgFBssP/R6kqba8bDE1x9BEok/3gW+l+xwJQUlE0yLzVUkWbkGUmwWfdnwZgAMDE38m7iNoLQQzo/2Ff8R/ZaJcaMCzmTnfQDsUjvAXKdM4ae9qfNXvmwvMGrMl7i2VlmmGMvOF+SdX/pcZ8JTRXCU7ITmy6d8nXdoQJZsgV0wTo5986QdSnj+Obo25iYUpbmuSoqsP7BbJaI4drWw+Dro6omXOWZH3hOq6bRCg2EMZ1nRJcKIQr9P4tV+8UfYC0y4w3CMuN6PJuld6wEGO2t4U4UlSUq2VR/9sTk/EoRyS2CLwCkQIsNnIoghrYd7CoxuLOS7P9I91ZxgnSgxojRsz6ghYWLqUZ9vvOeSxL3Ryhe7ScsRRovjrv0umgDNv39Jls5Nljulm8amVelBx0/hctxruhrGQt5C2ZVskq7wEgTbSW5+BieT3eBZS2fHAaQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(366004)(376002)(396003)(1076003)(4326008)(6636002)(86362001)(6862004)(966005)(6512007)(33656002)(26005)(2906002)(4744005)(52116002)(8936002)(38100700002)(38350700002)(508600001)(44832011)(6506007)(5660300002)(8676002)(186003)(6486002)(54906003)(316002)(83380400001)(7416002)(66476007)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rHlGNuP5nmG5vlD7D/r5YFEi156aQ6HeRcey5oT+O0MzVBhf/nKVaCgKmnNc?=
 =?us-ascii?Q?wnCPHaJND5dUMJMFITld/d/NnfBP/np8GlACqQwG3jyoow+inlhVpJ1NwQEZ?=
 =?us-ascii?Q?iQ7L194myBKKf5tGE6yM8pClNpMyDkd2Nilr2HxXm7GpRngLId1olHhAu0jO?=
 =?us-ascii?Q?hMJl0z8AH35iMBOANXuoHKs0PX/01zOWXfUbh5G0tTAxZ/kCs+bKKGoE9si0?=
 =?us-ascii?Q?wh4U4zMv3V0zFjNQaLVo/jJFEREkLbA7ypum1m6kiyULQW/f9iOnr+SllmBr?=
 =?us-ascii?Q?ybQwv+J8YQ/SplfHfk/WO3rMyN6v9oVhGE2hePIl5W7JQkab2VID6Q3K/vbB?=
 =?us-ascii?Q?WzRiiYM/D8weRC2x6FM+ZGf5Bs8IZpX/a7YrLstay0e9bgUO/Q74ZQm5lNcK?=
 =?us-ascii?Q?z6gIHhZ5CBJ/h3MonXpWLsuNrxs0p7v/9Dtkr+Eo2WN19KfZEdO7rgVyi5hY?=
 =?us-ascii?Q?vHTEz1ev0OAUmAwooQM4Jf51bLWMl1JOxnxAjCo0Z7pU79TmSNzORWCq/a8G?=
 =?us-ascii?Q?/NgL1s4t2F7eaH4Z7uIHp813MV5GsFWNM9DWwK7f6XEHBF817rmJu80RP7dh?=
 =?us-ascii?Q?T8UuP+imwLNwqHnzCLx3hq3Tv73LKH6Sep5SJpk3qz6FC2SLk8RwWQPBSEe9?=
 =?us-ascii?Q?yO1FJldvjn6Ne1ImvKeejWqu/RiwCJmdfqWvc3RMytAgzXB5zAM4GFdlhhue?=
 =?us-ascii?Q?QilL75lh3ArxpWF70rW4Rl8+6gBYxIbMef5Js08iIAFC1ino7nw5x6KmTE4L?=
 =?us-ascii?Q?u2c4iNatLReveh+p8GlrP8DY/uREhAdssDuk+mqkvPWHfHsRvz9smV2cEGqA?=
 =?us-ascii?Q?GbssxvXC1OZ6Bj0bx74Gp6S4tu2iftULYHEwHo/DWHcFKIWcyFsVqrl2iTaG?=
 =?us-ascii?Q?YegVjgRjpP0OVc0KA11LGD21XE9TkXU/UdB3A1gDa3UT2UWQZTNhoNC6/go5?=
 =?us-ascii?Q?P/xCCS8fvydpJ35jAq/h/f/D1dd7xPZUdRel1SyGN//6ZTTdFV0k16AZ8vLn?=
 =?us-ascii?Q?cPVRWDldNJzxMKh4elO8Z1lgtvdK1EPgodjuKcEZys7zhull8tzst1la4iXN?=
 =?us-ascii?Q?aiH4G+sfEVL9OCeRZMfxKVUFtVfXpDp75RKuZ2LRfcmJWEIMIb8zHhOcpbW8?=
 =?us-ascii?Q?W6i6Dd0ibtebTqAENxDZEZHojKPwg1G499lhmut6xSYxDZHOCQTm+F/9DmIo?=
 =?us-ascii?Q?AJ1O7TMgpyducKv0V8hIHQvt0H9PBNaY7X63rP0bkQ0cU+wuZyvA681FSEaF?=
 =?us-ascii?Q?n739wrvysISqeSOsJNx/oBjwD3wheBqrpSKw5B5yhaA97Qfn/VbdYvpcbrg8?=
 =?us-ascii?Q?SqICUsN7pu5wwaK3vywQ0aYqYXfeC7jtPa8gE9Pr7vKX36syAxld3dOeVmz8?=
 =?us-ascii?Q?MqmeWkyrsFZw8VwNT74xEq7T2F4G+0T30umSYKruF0YQz+AaCFh5xcwe4gLX?=
 =?us-ascii?Q?N/YggcI65sEDuH56GLtopp1M/1qpwwt9UIqibaNlAxqmvTPm5g05OQmlN7sG?=
 =?us-ascii?Q?yHzxE76HsqQv5Nsre+VGAKzRGRowv41UB8wItq5FDHuqyuUZFDgjHflUPHZP?=
 =?us-ascii?Q?G1P3czzxA3VhrS6vHL5jy+G+/YeadtoM/4aMTWQJtBoepJ4Idf3OT55cqS0t?=
 =?us-ascii?Q?Qz++JEo95a7+3QR1gJZBhS1hiEz+j7hyapTid+wWCVW7cti7zxK3u485piAG?=
 =?us-ascii?Q?x3VUltHyczIm/dxmAjV9Iut/pm4=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9587441f-6571-4031-5a60-08d9befc9990
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 12:23:56.7653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8NDBlOotVOlVnG8S7dOXXVBmP5wbCEPZyOkw8Kmgb+ekqFajHU/FigXvdsE4OMu4JXsBYytQShKJ5KkJyjPmLHwWH6rO5Q/ztKn5crec+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 01:16:35PM +0100, Philippe Schenker wrote:
> We do have a hardware design in which the ethernet phy regulator and
> reset are controlled by software. The ethernet PHY is a Microchip
> KSZ9131 [1] and the power sequencing requires a reset after the power
> goes up.
> 
> In our case the ethernet PHY is connected to a Freescale FEC and the
> driver is shutting down the regulator on suspend, however on the resume
> path the reset signal is never asserted and because of that the
> ethernet is not working anymore.
> 
> To solve this adds a new phy_reset_after_power_on() function, similar
> to the existing phy_reset_after_clk_enable(), and call it in the fec
> resume path after the regulator is switched on as suggested by
> Joakim Zhang <qiangqing.zhang@nxp.com>.
> 
> [1] https://ww1.microchip.com/downloads/en/DeviceDoc/00002841C.pdf

For the whole series.

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>


