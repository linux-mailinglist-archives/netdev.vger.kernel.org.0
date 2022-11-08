Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFB0620B19
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbiKHI0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiKHI0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:26:24 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2075.outbound.protection.outlook.com [40.107.100.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912EE27DC1;
        Tue,  8 Nov 2022 00:26:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0YpOLN8WY7gGJKrraiBu1VnzgYTLsfgGo/zLv7SPvPqWXDuCnAdeCGM3IxciPsfsdU2b7AZMrX723qQPbrey91T6OGniEaOamUnk1IeDKy5ba6L8g9XX4OV0VOg68DYYWYEMsQYB1WYVix/6unbzMBr3FPLfOwtLOnWlYaOBq9Pa65VCz/s8n1MX4UhWxVqDIG+4AOzadKnMCEqN0GhOc4mrA4t0Qi8IfoNjxlYaZtjOaGGmmxx8p6TjAqMo2d5bIHwCv7VYuJ2A2CrkAe5kxyH5Qc5qz64J4V0iofe42wMA8lPVey9hK5R5Gy1+6Z6DshmJ3Q6B/wgdjSgRzacEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70N2KF9WgIdQvgZYuR75kAYp8Ht+z6WNNx3vjjiHEfg=;
 b=WANyi80ZuCqtNN3KjlpD3gALWqExy2DOkQ9hLXCsew3uAWcGAh+bsCa6FZRmoOOq0moNqfHeIg0nUk9lbGHU0xnxFxG6vZW/zhevq5RBFiKvzOLE4hcXksc01EbrRdc70XwQUaII0ORlmDkYcp4yt4FsVhNH8tFAUJcSU4eSQcn9SYZX8Pv8xTSCqvcUtKtXkW4EDgYMhlehHo/aTfnr0i8Ib3J8ejd7miCmtAyCnAfhXNfnZKKF4ScP3SstAuWAHO6ZLBa17oRLvhMa2FKb4z7CmOrXUUEtE0Em/PnbR/DUikdzx7uSGYvIBDCLj9KPKkLJDuvB46ZBQUSyBWeZsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70N2KF9WgIdQvgZYuR75kAYp8Ht+z6WNNx3vjjiHEfg=;
 b=X0JAF7UyRPHGmTUsJYRJOrZz2FADDUi69dUsf+dAS5HdGySE68pSzZdWguQXZprpc+32BEu1QowazT0RXgwe+ht0NLk7FT1CsaElC3/IaeNVJCfBObLEaXqWJH662hZfesp9IVlUliqNIls/mJWWbxhT3UpMdr9w4U1jlP1owlEy2IhEWJRL9MowFW6QYOj9IiPVv9keFQD67kwQZKB2ChMMmf579mP6cgiGooxCXPnmh2Pqo5dTHbl8iHYsBSwakOblXZ/qYueDZTsSyx1OandLTnXOphI8XzjIirYNzke9rW+EwKq/0xVgnM9BHa91u9te+RigShhyu587OmEfBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by DM4PR12MB5152.namprd12.prod.outlook.com (2603:10b6:5:393::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 08:26:21 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::4ca5:7eff:cf08:6a4]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::4ca5:7eff:cf08:6a4%9]) with mapi id 15.20.5769.015; Tue, 8 Nov 2022
 08:26:21 +0000
Date:   Tue, 8 Nov 2022 09:26:17 +0100
From:   Jiri Pirko <jiri@nvidia.com>
To:     syzbot <syzbot+c2ca18f0fccdd1f09c66@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] linux-next test error: WARNING in devl_port_unregister
Message-ID: <Y2oSqdrob7bI6Xvr@nanopsycho>
References: <0000000000000c56d205ece61277@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000000c56d205ece61277@google.com>
X-ClientProxiedBy: FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::15) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5979:EE_|DM4PR12MB5152:EE_
X-MS-Office365-Filtering-Correlation-Id: 99a65ceb-3b83-4d3a-8169-08dac162ea74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M3CgXItdBJdQ/dM7xtV7BdtwB9eyKIvcz93bt15OcAG+a+TC425cCltoHYEQpFI+8lfsdJ0IPOWF9mXSr1UO354DfPamdczw/DnSU8m5lfnuzLU05qkDjwBrmJ7dgxZyslwuBM5cmFx7XUYOaRHh/jyJZvTfvfPHZk4pCMXIFPJXp9dVIH91qrY36/cuw62SixUwsCJdXG87l7xLD5n6cspk803o3/EaUF7h3EUeNDba2hisNFF3/zxCnHTuqkKYk45v1E/C+GBOvqYunQR2jCif2T+DaZiiOSMrEZZjnTslRFIhwqCeVV5lwXvCKgXsixb2W3Hzp0AoN2TU7QcJor/TflgGBRK6nkctNKg4CllpNT/295/2MS5Z1Wrky6Apc/r+3JeLnBw+9fbfTg9T/IsWFuzWqkohKRiF7Poe5aJH9DNQY7BBOzELtyoiSGOVMphWUOpAnFxApwN7fJEuxGzi9jnd0Pz/Q1p9eUpYz++wx1oKsPKVDpHv870iO8vnB7A3NrxSyIe6VQsY5bN59uUcJmKmA9mNDIe68X6wk37Y9ZzAWNlZSYU5ZzIrrNj/74ijvwha/RjC5AMz0q3FkV5r1WzxBvtPiqw/ooU81mmhTMmMZPXbOJXE9ch8Q+h+rmBUGzFb8+RsxWGk4BJWSp0vOhJIinsASOT2UfMk40qy2rK1jQSLkhRql127l3pMRgDWoI2HgRMzHx+vUYnQ+n30/6PVvT7hreobY2mwbO+H+ZATYvv90hh3zXFXSRyK2vCYXzY1Ma7X+81bOceNTLL4rqxo507UIBbtX6NJBIqZVGPra0CE+8Dx0lALAL93lrPSTCmRi6l4kDU4jSn1zSAlnXrnHDdEi2j9+UmUokFS1fCgoGgG6OlWcBgWCDvP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199015)(38100700002)(478600001)(966005)(6486002)(33716001)(83380400001)(86362001)(6666004)(186003)(2906002)(6512007)(9686003)(6506007)(8936002)(5660300002)(7416002)(41300700001)(26005)(66946007)(66556008)(66476007)(316002)(4326008)(8676002)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uuI6ICNE3UiJCMZZpKcO5IANSXy4MvvtH6UvLtTGcZaug7SqimWZkhjpQ5kP?=
 =?us-ascii?Q?YLlqIk4nxQ49kIlymZZsiFBc0RTc0tEGLgiG2I2gF7w9Swvj+YDmc2Uu5Mvm?=
 =?us-ascii?Q?tC8DowxpV0jtQq/c/VwrxwmhXtCayqvAqMTGvHeU/43GNH3PnakrMkruheaH?=
 =?us-ascii?Q?rqRhtaG3E9v8W5rWEL4GDHFoP/CkT3aT+u3YxydO1/QxHUwVP8YCKKJJy5y+?=
 =?us-ascii?Q?KbaL7IGVVhW1UrU6z+DEEL74F4BuEdGJm04f4XN51yKCkK5KBbratXsDBZ7e?=
 =?us-ascii?Q?skciJXIIC6XiZ58JNUeHSMVg9FgQDo+vdhVbqVuqU8DB5v4706fMK7vEU1BN?=
 =?us-ascii?Q?un1tZfU4JLWR7D5RyEFS1wDadhNEHOTOpV4rVCv6g06+LCyvi5zghsmLziHr?=
 =?us-ascii?Q?L/mgrp4kesLn4ErhAuSPB2L55fCdru6RFkZoOSsNpNxOi1Z8Uq21o9Pk+dQB?=
 =?us-ascii?Q?9P5liKujo24mc0Fs2drORTCjS2btSAFjohtpeVS+l13NRFVtpmqSfFjvX160?=
 =?us-ascii?Q?jbkYtPYfYVPN9BWTPzyFWZIYiFAPgCpt9/10FCg34qX+mNIvbMIIja1QAUoJ?=
 =?us-ascii?Q?uE3SUn2i7ZplFamY0qv2TpZGLbmt63yXgx/gxR+vGbITpzTENg7cYqcmT6dA?=
 =?us-ascii?Q?qqsgvk/7LqDBtt2cGofweD9j9rEFlGCNLdX0IpwAPtqHp95qlENJC8p71BJW?=
 =?us-ascii?Q?zf8kSBRIJDriKzVbIaDy6eI4MlLe+rImnez4fjLSWYSJk+MIy8FcBTBklDit?=
 =?us-ascii?Q?4QTkFtoBv8fIlBlLKk6v07vxNkTCxSLSuUolmTyCWStGiToTHl9gwm0PvVIj?=
 =?us-ascii?Q?HKFNcfKr8ufhI9hCOEvjItb7G/58i/Qo2aHeVQ/8VkzhHXpQUCndAiBJbAlA?=
 =?us-ascii?Q?9/HatV8jcpILdiosjmf9csJRFoNTEgp/GTLZXuIudjl/+mYn7HmzSgoX/wdU?=
 =?us-ascii?Q?aNucN7Dd94F6URi1ELGmAwVzhkJ/EJorhUbiZNvKZbDSZPk8D9jkGGjl3r8/?=
 =?us-ascii?Q?+Ssl/9Wz8ey9GqAIzWKCnrEE/jINrIz6FlU0LmS6KvhYgU0DzfocUupNwvJV?=
 =?us-ascii?Q?qQT8blh7uSr2JmyUC04wfQ9n6kV3R+K6NCU9udWAXB61hTL/5HIZqHgMLo+W?=
 =?us-ascii?Q?NX59caGUyv4ct3hfStkjQYeivwyjW8HILIwSTTx+bf575V/aJDZ3Oj1cLAIl?=
 =?us-ascii?Q?N53lqZU/VDehWni5hUIWaFVOK47V49dNN6BJiyGVh5sxrh4PfmyaNEafFO2g?=
 =?us-ascii?Q?BGTyMvfvupmSkwaNAq0tM/hKiVguaTxNHlcNU7v7fd3AaA85DhjQWlgz1DEB?=
 =?us-ascii?Q?0vLuKaBeyjoUwNXXWUbCP5o/cbhc6PScrHD7stQUA1o1QB5UXnGn0f2BZQP+?=
 =?us-ascii?Q?0hOftuR9Rb3AqQPDsmfHAcK+ibBOBPT4wfbK/Sy9OukRLBonOf9OEUPX7zQi?=
 =?us-ascii?Q?pPpyo0EyIunCwng8ltqExJr+nvR4nDLyNj/PSQfb7C0/ukR4WsfM3XCpCy8Y?=
 =?us-ascii?Q?RKU32NbCTU5Ha8+Z8DYoyM4q4fb4s+ymARQjSVJIOltkXUb5U8X6XlJmp85z?=
 =?us-ascii?Q?nSnvQkQk/ZVEcZfjpKG51KOpNhwyq4jgDNx/Uuoe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a65ceb-3b83-4d3a-8169-08dac162ea74
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 08:26:21.3149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1ozcE37zeqOoCSICEAnFfY9f/3dOdDofimZz9s0ALnz1aWtdDGxDGH0S20tRQni
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5152
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 07, 2022 at 08:02:52PM CET, syzbot+c2ca18f0fccdd1f09c66@syzkaller.appspotmail.com wrote:
>Hello,
>
>syzbot found the following issue on:
>
>HEAD commit:    d8e87774068a Add linux-next specific files for 20221107
>git tree:       linux-next
>console output: https://syzkaller.appspot.com/x/log.txt?x=17b99fde880000
>kernel config:  https://syzkaller.appspot.com/x/.config?x=97401fe9f72601bf
>dashboard link: https://syzkaller.appspot.com/bug?extid=c2ca18f0fccdd1f09c66
>compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
>Downloadable assets:
>disk image: https://storage.googleapis.com/syzbot-assets/671a9d3d5dc6/disk-d8e87774.raw.xz
>vmlinux: https://storage.googleapis.com/syzbot-assets/ef1309efbb19/vmlinux-d8e87774.xz
>kernel image: https://storage.googleapis.com/syzbot-assets/7592dabd2a3a/bzImage-d8e87774.xz
>
>IMPORTANT: if you fix the issue, please add the following tag to the commit:
>Reported-by: syzbot+c2ca18f0fccdd1f09c66@syzkaller.appspotmail.com
>
>wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
>netdevsim netdevsim0 netdevsim3 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
>------------[ cut here ]------------
>WARNING: CPU: 0 PID: 11 at net/core/devlink.c:9998 devl_port_unregister+0x2f6/0x390 net/core/devlink.c:9998

Taking care of this. Will send fix today.
