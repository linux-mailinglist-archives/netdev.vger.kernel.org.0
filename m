Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488F361E24F
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 14:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiKFNV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 08:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiKFNVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 08:21:25 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6092C744
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 05:21:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMj51UVKUKJBgQpeeqfD5Q6xLwFlgRpJFZZH5WFoZ7F0//O+Gx5xQ745aU1JMmp1qYUeyQtQmAOKpSSrnC1x5smZbEC5M96LVa0zISJ3N4xQXc6uBpDjMLUwErODnylYepCcDYshyd2ZcL/bVL4hCG8Ql1oSEUxfNRzDRen5+iOiOnpA/zSMHxFoslNagBaG9+z9Z6MA1AOHlCTKBtPSucnEFtX93PXwuzK6t1v/KE3TNXvsskv+HuHt54pHrY7Cict8UX6fIZSp0x4K1D1Jc8pUjq/TgpE1tPghyIcoHPJ0jQaShBqp/IstDf8CGbcHXaH0gerpdZT04bUB6p9cAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNMMKE0TtKx3v/Z85KrxgERvP1I9hgJEE5AmlDHoavw=;
 b=C+xZqeZTTLtos3xEBB7OPB+5YohPEzhcpJSEL1Ykx10r+NubxMMbajwojniu2e8CksrLThILOtomz9j6WAyNew0uNZ5HiF8wQ0SVvr5u82s7tT70TULaVI37lTdh6ePHjGkFtpLwu1jMYd3qqEgoE4WmZ25d3Wa0LHkjFKXSkX8DEKGDnna00ya4yYePkEyRWWLkvUfSdgcvekQlWb2pnhrSXLzOJZWZZmpJzUaEThxqj4NyIbzNAW/kc+XO/jslXEfyaapLwKpSn0wQhZfrfEHt7JYNdeiWuGrdRDrYlBY/u11ZG4jmXvgzbN8iHmV7kkwiFC67+jfqpuj/bpt/BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNMMKE0TtKx3v/Z85KrxgERvP1I9hgJEE5AmlDHoavw=;
 b=nviudDU7ogCBuPg3K3HxuATbvqN8FgfW443qX3yzbzjKKTQJfuAA7l7TIl0pNh/kL2trEZ2rP7qYvPpNs3f/t/B6KQ3AX0F5Lh4IyxM8RSnkqeNqKgGb1j1F+l88pqCdH16b0t19xKcKmD4g4qwSq12+kYhgmTCD0QkL3TNS930pEhY8y2+X94kajbQdAUs9eserK26nQ+wE7akihUXwYOfbl5QoG2x/+vI1XT3WO3p6dTmaKfgeiQGJieuz+fuYaYpja3v7TB2o8oWK50EuNp4z47HxCFvj5iqNUavqbBsvvSugh2O3nyYnXemlPPkzeJguQre2PY6zOgkp4ZqH3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA0PR12MB4542.namprd12.prod.outlook.com (2603:10b6:806:73::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Sun, 6 Nov
 2022 13:21:21 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5791.025; Sun, 6 Nov 2022
 13:21:21 +0000
Date:   Sun, 6 Nov 2022 15:21:16 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        vladimir.oltean@nxp.com, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 00/16] bridge: Add MAC Authentication Bypass
 (MAB) support with offload
Message-ID: <Y2e0zHgzIClULTIB@shredder>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <e6c4c3755e4aba80b3c7ebf31c8cdb58@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6c4c3755e4aba80b3c7ebf31c8cdb58@kapio-technology.com>
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA0PR12MB4542:EE_
X-MS-Office365-Filtering-Correlation-Id: d5d4f8b7-8d11-4b95-d539-08dabff9cbee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMnCnG/wFW5MXEvnrO3MRk0zHF/Na/XV0oFfE0Dg7vq94/tEFv0rxOuVnomBYUPYZO4ArQf+lXLWEC/C3wbpMF3y3nVBORPXk7bR0uM8UzBiF/J+t8LLY1U9/atiidYz5HArtsMD8AFDipDDM9bs5r8TP91DxzS8uvDTPhEaNMs1zxLQ9xl4OMkHZr1ZVVrnkxCIRoEeVNgtY3OIzARdqYA8nIxTFaBs2aBWlH60DE1EH/2AaDVqpaGm5OXPAud98GSPZAt25iA4X5BaECzQTkQhPF0F3rSs0okkdHJds5W6C/YJvmEv7lkRKR6QTh+yZ+H/Aba4UvPDdrUCV5Tg4+oXajmQeKO1PcRVR51APxjzIDA7UC87ZMqCxqJUzhz2PeEmOACrStGotNr4lxZ1m9S5u77li/16VJ8OKzXLzZo3LW0Hjh61pV+DSYEVztiG1dKjSFExV4SS8xiAExokyKB31MJDmQMgwA3toRFnzaic1IlzmEzTyvr+KL0VK3ceXtNbzNKyNz7zH5zo7epronXfyKKWHBu4i6QRtq/Qe+3Hi6hbhzU4Bo67F6lP0SEAK2QNfUzJh8q897sXkZqmgCzQclvoHXgaRdMHlcf6VwDyv2BZtQZPkcx90QH3UoboDXUHNiHIczflr6CLUoAPBZKnKk8RcT1TE3zZv2uPBKZBAuBhrO6B8XovxR1Zz9Losr5XhEOu4B5gkX1p39rWS91FHvUwE0FKRBxagKGFHl95KFXOR98gID1VskOM3iFdl/D4g2Tt8KiiD0658ndtt9mhPuskpdyC0MiXQuHQnaE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(107886003)(6506007)(66946007)(53546011)(41300700001)(6916009)(26005)(966005)(66556008)(38100700002)(86362001)(6486002)(33716001)(4326008)(6512007)(9686003)(66476007)(478600001)(5660300002)(8676002)(316002)(6666004)(186003)(4001150100001)(7416002)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6J2+/XK05lY+6I5DR2Ih32XemjyvtIhANCWOEjYKuuk5asywJPPnaRMBrXLm?=
 =?us-ascii?Q?dq1jf3H8dfmvBhygxQzVqq9EH2HNbQHmPoNC8HXtxqqdFeMx8199Bx2kuDK3?=
 =?us-ascii?Q?niTXLvGf5Jt1r+Lr7Hy1k0BDOkpLReyvdLy9SaLsIvh0II1aT7Yb0/oVL40N?=
 =?us-ascii?Q?KYOtLGgclHgoo435evFfqVkdyMJEovy88FHDEZtf+jf1D59wNw01q1mxSsC/?=
 =?us-ascii?Q?a04VnHvF/gJQ4DgHQxnCNQZLubCDUcJL2sVPlRtX/9ptGiqiWr9498hy3Um+?=
 =?us-ascii?Q?wfBD7MuQwe0RQVwKkN9tg8by+ktw+qV+FtmqRoGTn/oYqT9PU6yfI11oayj+?=
 =?us-ascii?Q?3wWHlmPWBNBHPvL+KHvqx53mVdEO6X9IYElnpjZZsSabShthS4AF/ET+eyke?=
 =?us-ascii?Q?Q+mP7hI1IdtxM6Yq/MtJnl9CKEiW4PoR0fIWtG2PNWZLdYbHqD7Nui/vg530?=
 =?us-ascii?Q?p4G4CwdNW7MJ34zNKw2qlj4ThUaX1z+7EnQBUVz3Pgo89w6aiKxSdUpyIi3h?=
 =?us-ascii?Q?fbE9ySYcePcJNZ20RwIoaHs0cNISTexMUqG7H0oZ7aso3rdWWkApKXneCcwM?=
 =?us-ascii?Q?31xa4mZX0v2nhidnlz6JPdP8NMGTUVxbLEb+GAlq2zGmRu3Pv5oJ4cRqLa2L?=
 =?us-ascii?Q?qMbnd3YQuKU89x+Wfq5r4ubXDbOsRGI1N2/uKuURKjcD6GM03m18s15WxtAX?=
 =?us-ascii?Q?E1cGK/2Y7MXjrS9fx2eE8Yycbqgbi+PLKK+T2DXNmWcK+cPZd0mJISjZpV7E?=
 =?us-ascii?Q?89u4OUYHFaHTskdfOu2BOGOoG35UNoatkBi6bqa2XjxfYDu5t9hh2wtvmpen?=
 =?us-ascii?Q?KiYVmmCe19ZROkm2taj+7rNItejyBN0u2rs0VnNImj7ZwzFKnleXfoW5WadY?=
 =?us-ascii?Q?XOj0EaMBY6avSPmgUbr3EliTqiUE7uqnqVjzwWb4Ly3Qs6iA+QshGfOAzt5/?=
 =?us-ascii?Q?NYV3oVdigYaKmSNQqp6UCLgH8qevL5Nuu/Fi0R9u54KpbYl+xkMQWwkzh9+I?=
 =?us-ascii?Q?P6FOATwhfX7loFmNt2Ysy2ALXsrRdt44qznCVRQsXpMqT/hNeFELmJ24dW/p?=
 =?us-ascii?Q?4MnwvVe695N7HvEz0QXAOZ7ZxfpwbDcpnHuGpAcTyxnYZ6Kr2++AuDJ43QuQ?=
 =?us-ascii?Q?PfDZYCG3LlgOJBlUpN8LoxDrBvwbBnx7cEdkdOcMOCNGnkuJaBle9zWH5MrG?=
 =?us-ascii?Q?8VMtk9kWkUQMWOYTgb+z/IBVRK5q77GQXqGzPlM3Cb75lmLL7pmAspArPdrN?=
 =?us-ascii?Q?PBwC+EyP36G4calH5SF30SpHzCjvbZ6qHNi6Ck2gAk46v5DoQXnqAyWDcphq?=
 =?us-ascii?Q?RoyIAaZpuXlQ2X94fsXLXTJJbkbgcM/vL3yoiS9v0Ej9VLD3NaoW+RBRf58P?=
 =?us-ascii?Q?TtAZv7mrbh/vCayiacWYE+imh9oRbCItavUR0KR2LN+5FnAJM6J5a6fBqEmj?=
 =?us-ascii?Q?7FYlYWQocQyO6NrneKjJZiSu7tbExtHGOaXo/1yTlz+F1Tzr+cFW6HaWdQg5?=
 =?us-ascii?Q?J0t9UvGsPM8Q2lML/gUcVXCxProS9CEJJUvBpFn6OrSJ7Ld17K6r987I2fvg?=
 =?us-ascii?Q?VFVeCPADD103FIGzX5pvc9egdCEJgx2Pr85ldu8Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d4f8b7-8d11-4b95-d539-08dabff9cbee
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 13:21:21.6472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3vOkyOn6GgwqPy+k5k4ywA0g1uXUh7YUHDVZgyCB1HJw9bQvyWCQxbWi9oK3QAzqJ4a1wy5+mEIRQzdQ7JwmUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4542
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 06, 2022 at 01:04:36PM +0100, netdev@kapio-technology.com wrote:
> On 2022-10-25 12:00, Ido Schimmel wrote:
> > Merge plan
> > ==========
> > 
> > We need to agree on a merge plan that allows us to start submitting
> > patches for inclusion and finally conclude this work. In my experience,
> > it is best to work in small batches. I therefore propose the following
> > plan:
> > 
> > * Add MAB support in the bridge driver. This corresponds to patches
> >   #1-#2.
> > 
> > * Switchdev extensions for MAB offload together with mlxsw
> >   support. This corresponds to patches #3-#16. I can reduce the number
> >   of patches by splitting out the selftests to a separate submission.
> > 
> > * mv88e6xxx support. I believe the blackhole stuff is an optimization,
> >   so I suggest getting initial MAB offload support without that. Support
> >   for blackhole entries together with offload can be added in a separate
> >   submission.
> 
> As I understand for the mv88e6xxx support, we will be sending
> SWITCHDEV_FDB_ADD_TO_BRIDGE
> events from the driver to the bridge without installing entries in the
> driver.
> Just to note, that will of course imply that the bridge FDB will be out of
> sync with the
> FDB in the driver (ATU).

Stated explicitly here:
https://lore.kernel.org/netdev/20221025100024.1287157-4-idosch@nvidia.com/

Don't see a way around it and it's not critical IMO. The entries will
not appear with the "offload" flag so user space knows they are not in
hardware. Once the "blackhole" flag is supported, user space can replace
such entries and set the "blackhole" flag, which will result in the
entries being programmed to hardware (assuming hardware/driver support).

I plan to submit the offload patches later this week.
