Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B04A4741E5
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 12:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhLNL7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 06:59:04 -0500
Received: from mail-zr0che01on2122.outbound.protection.outlook.com ([40.107.24.122]:52161
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233730AbhLNL7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 06:59:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxm7iU0J05q0pzQtxQLqmONkvNRkQhFUgtFRUGr080aCE62IcfFGRGn45RyNWRLiLAI6uTyNGo4MEtHgWsx59Zy+RD3YxcgibGcmImqYzA8899yBvvu03PUNjR52CsXQ3xoQhD4CESMTGRxyJCzc5FaaSvSFJc9ZznZFvBBS5P1wsn6XZFh3T9t6tEGFwu9jjQjznAbxP4VCaUIx0qa7F2r1cato32KvDi0iuLFTiFBjQds4L4KPaiMUo6DKXC571pVDX7/ZTzuffgoMXvKBmM4u1AfF2thl2dlKXGJ+anQOj993cmkOCeWdk4IF0MVUctx5no2zY6c0+ZffkIrElQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zhOh2kefMjwK+ffOCKH2ohfZE6akXlfzY87miBH1hI=;
 b=O2OcmF9W4DjQP/IyKWWoCryj1KpubU98eObFA/jg1PJ/JVgcoieJKmUnpvUlTYUNcW5E/478Kj7CfuSQOLOnIBbAc+TXFL0ezcaWC3A+QGAlubBsLP9BwjDMf2x6Fn02Y3FyzN7VR4NFpKfhxrldI8dT/uwHwCibB60kOkYmTxIZGQh1R+qz4cIgh5HrvsnnsfSc0yOPJyS2K+567ojhcFJVjpvfEa9svfPi6dhsN0OODsKglVyD5hRx8lrdgQfIDtz5siXyJ/2AFanUT2+yuSO7XpAHdiJrdKdfc0oKKi1wwTfHlThSFjS7fsi9xZ+yBgK1/mUA4MbVcGBMLDg01A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zhOh2kefMjwK+ffOCKH2ohfZE6akXlfzY87miBH1hI=;
 b=nGQVbpEM3/doLEmOtrTOwL3MMreaDo58iucjvSPPMGSprKLgLGDkGuwIqnVSzR8WLIdD6Jg+ca68//w4PmzOWvHeQqrPRiPMjR5c9RsolHU7pSOXdQEFG3ZgF1nt96IR8AkmrSQsuW9LIiKkbSSZ4aHK/Axq7UkzUeNQIvV850M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZRAP278MB0238.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 11:58:58 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 11:58:58 +0000
Date:   Tue, 14 Dec 2021 12:58:57 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        philippe.schenker@toradex.com, andrew@lunn.ch,
        qiangqing.zhang@nxp.com, davem@davemloft.net, festevam@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: perform a PHY reset on resume
Message-ID: <20211214115857.GA13490@francesco-nb.int.toradex.com>
References: <7a4830b495e5e819a2b2b39dd01785aa3eba4ce7.camel@toradex.com>
 <20211211130146.357794-1-francesco.dolcini@toradex.com>
 <YbSymkxlslW2DqLW@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbSymkxlslW2DqLW@shell.armlinux.org.uk>
X-ClientProxiedBy: ZR0P278CA0010.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::20) To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea4ac6b0-458d-495e-f48c-08d9bef91c3d
X-MS-TrafficTypeDiagnostic: ZRAP278MB0238:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB0238EE10B5ACA847F7D2D021E2759@ZRAP278MB0238.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2T0twbHo4omxb4yXGRg9GNkZitl7T5E6NgQR3SCQnIApfgxdiSN9STgjplNp8q9h+HnG4lYRK/JywU6Z5EfPpL94DzwZ2bgPUj5q15UkynqXeWbPQjHI/LPF4RaR2PUiQINPZg4wMEMVSdapL4BcZcn9nayWToOi/tCdTbkwsePClxHKE/ushZPppmZp5OuPYEQibSm9fCsih/2aV/I1D6psE19mIK7DrjUqvx9diEfiN6Cdq7udeKSP6U7neix+CoVMBkw0m7xJlLo7swAPEzJxytdc9LAZP4qBSDFuFYfCUwHpyalhDSZMwH6k5GMtkMk0XJ9U4fxLVsTTVKl3Pj+kO59NGwkSQBmHJzWWNtgIFO/JngDgIKwZZMyvzuaaZDPXc9atNdNFkrTOt9/0IuDYL9nMZXQcHVX6Q2je4bhnraZzVptmYWb7UzTgcykNSAoQd3YmGVupPEwZdVWU4VQ3xpizkMscEps16+HtCxjWQxC2wfq5l4FHJpUKIKaXbXKeBQ7+HpYXlN9Ns3MYix/s1Bz4uw/i4CdGf1rK9DnL3eJAr5G5XZTqa7mY7W287qauO5k77OaiU4Pw4lQSjJrX/HDxpVi0/xrYIZEXpJPmuFvdLALzz20ZKP6mFoM0twsmnBWG/sW/97V/dFKjcn5yEoYtkNMkYvUtWug0GBeUKAMeYXlcmaqcPorx57PSZ8PiWcMvPNjIuK2vFjCj9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(136003)(366004)(396003)(346002)(8676002)(6512007)(6916009)(4744005)(6486002)(33656002)(86362001)(38350700002)(52116002)(8936002)(6506007)(1076003)(38100700002)(26005)(186003)(44832011)(316002)(5660300002)(2906002)(66476007)(66556008)(508600001)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YWfJ9zhH73OtHfOA5wiQJL0UGlRrn7GqVq4EMCIThj4YWTO9ZDhSGx5t9A6G?=
 =?us-ascii?Q?xe4xUDFcM2trgELgBYdcMFlJ11R9RLvjLiIdjDTfyTjWYyo1W+R/0DnhqV7X?=
 =?us-ascii?Q?10vHp9elesgvW4U37wyuvftiHJ6qyCBaTqwUdvmF8Lq2OGtxEazOQL0+srHU?=
 =?us-ascii?Q?hGK5TBC/8piOF/PaTG4C3uQ6jKSzA5y5xCfzUzUfcOX5n5GiQf8oAzsPimwG?=
 =?us-ascii?Q?FJbeybubegCdfok5W5qcPKfl21/U6z/dd1y2cgduP7UtKIuMe3pBP9WvACLa?=
 =?us-ascii?Q?txQaRK22dtURwquADKLeh49pjRghkbqvEahS+EiZERaTgaCCprT33y9IzI2m?=
 =?us-ascii?Q?LdZwszKiUuMdxTN05nLocNsTdnI+spcdNc0C/IHgTGPG9LlMwoYYtMhiUYo8?=
 =?us-ascii?Q?eKbvzneQN+auAqUrAXYmm1203HuUTrac3tv/kHolaT7Bv8jnmbUzlQqLf8i4?=
 =?us-ascii?Q?t595lYuy+VvUfjzT+TTXIaWpLTQnwPxQ1FIcESTrpNUKWqS+Zkf6cxu8SOR5?=
 =?us-ascii?Q?u6yY3mEGD8EgURfu40UT4klfu4XipH4P3QngJK29NhG4ykDBEAswlrPBGfBX?=
 =?us-ascii?Q?5kYdq4k1P1Oez+tP75AMW2pG9pdt8pe37IT9SwdrDXcGXOb6SqKHkLixad2e?=
 =?us-ascii?Q?VPNNxyM47pk3LOYrXFcATSRfv93mxYpgprOlAwLi7jJolbBqVGjcMhrhCP3w?=
 =?us-ascii?Q?FuhjyJnPhijCyIJPaw2ntkZ/elY+YUoEujmA1aOBSAR3HKJsIBFXYU9KuTzt?=
 =?us-ascii?Q?acbKuZhqvi3s3UWvsiIhVhEm5EJL0Fon444B9ZuujLuLzueYbFs7HFkY1e6s?=
 =?us-ascii?Q?pHszR+H5H+xTUNSAJTQox5CIv436UJIycfsOqiBAdT4p6cpUlRFXzDBru/X5?=
 =?us-ascii?Q?hhEXd4On+TcpWU2LQxIV25Lq2vj2P0NV2cdKXyaJYasESJbNzRNnf9iAYrFN?=
 =?us-ascii?Q?Kq/oTYH0v+GJh9iYBPTn6FHZ8iuiNaJ5naO4/IFpiQftAE5fg9DsW8QBchnm?=
 =?us-ascii?Q?PcQet/TIxVcNpBxNRq2eA5e4g6RoVj4xLmxkulC/Vx+MXTNTyReGmb1FdJDv?=
 =?us-ascii?Q?6hqzgJ33qnIEjMrpfCYfJOLt9gobLfa7rF5haEEK/XXMEs2W1NtCSa7cgzA3?=
 =?us-ascii?Q?0ZAvqNHWbGimv9nRu/q8Ug+WdFxYU/qmwu0ZAwMARxniRqnNksQxFGgB0Tst?=
 =?us-ascii?Q?UydKHzQF17DCoR4INHOqBkNRLxQblp42Xpq3j+kohdOZfxlSEnCBTUPNm+TD?=
 =?us-ascii?Q?AB3UTpMAboX7VW2UuhIyuviZGzWGdI9wnxVezwa/r3GrgcjSMtLzpKMDJ0RD?=
 =?us-ascii?Q?MJEP5/CdrufwyejGBIA5cWeQ4/MMxWh5njvOkUYoXjAsiMRKcGS3L6TNgquM?=
 =?us-ascii?Q?pVQ6V2rzJERkHd1sbWRpWSs+t9wE5P6D2LvsDyY5iW+Rl/TK8XxSzc4yeygH?=
 =?us-ascii?Q?Stw7ggoZgHubk9ezi0CWhuVKRN33Mhk9PAC9K9Adlf2zP89OE+3o9yJF5JzL?=
 =?us-ascii?Q?KUFaxTYa5XhhioTNdzOp/Iv3Zc8uyV82abkW6JmgvNV4LAtu0r9s/DV1tWnT?=
 =?us-ascii?Q?9Z3saHGiBQh5V12+5sfU8+BiW+i+B+FugHMSFbLaBXRGqFh2uyW5o6mgWEHP?=
 =?us-ascii?Q?BJjHJjaGJpjLzUXgx4TSc8dnyOQx00JjQOSFJt+tkm1aCe2yhOrIfdCF2qJp?=
 =?us-ascii?Q?SrKqfA=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4ac6b0-458d-495e-f48c-08d9bef91c3d
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 11:58:58.0627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KT7m5VWySBeNTzMtzC8215YF8xYybwByxhA3JH/zxJ2FAOIPjXhD1oNRxx/hdYzjLRsjsHh4tVPJ2PQiX68ACj9j/Jvnoyl3DbfdnLvnCjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0238
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 02:15:54PM +0000, Russell King (Oracle) wrote:
> I don't particularly like this - this impacts everyone who is using
> phylib at this point, whereas no reset was happening if the reset was
> already deasserted here.

Let's drop this patch, Philippe will send a new patch adding a
phy_reset_after_power_on() function similar to
phy_reset_after_clk_enable().

Francesco

