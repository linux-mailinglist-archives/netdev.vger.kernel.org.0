Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1D1585B2C
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 17:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbiG3PxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 11:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiG3PxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 11:53:23 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2054.outbound.protection.outlook.com [40.107.100.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C7DB4A3
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 08:53:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aN9y8Ozha5ILtjDCcyXJ/aPi4sqWlcmjM2CeklhiNGE2Yi7WhNYzN0L02PAJbnszK0MuscDkQCbiPbSDOX3cGu52V7KTTZYzE5TJlZREKva9EMI6M5S2oXKFcX8RKTTOgxEuZBZiy+i/7BdVtU+twq4heYv1+PMhhkAuJwku/y1Xnr2HatjPGqS3ecKQIRGgnnkIcN+5A0QOHEAJVtxjkVwbnO4QNmvhIirI+ZyExaUI2O8c3KfMiDCKpU7Va0GDZ/PtQTsT4pVxo/sYKcqZD4kqL1Lp18QBx6NDoyqu+spHuzBeVTkPcHs4Bdao1gGVUJVRvrhdtWu86/qwMZq0EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iDSyjQtIcZUkWrABko7TqiVE9lnGuzxEYEk9C8CbsIU=;
 b=jC65lP2jP+2SYvel0twVxIbJ78img6bbQL25dJWZTqjHMo1f0tH4JuADHiQylqG9McReo+/bwCQHVVzH5LsnerO69r+VkVVFWOdoD0l0ISqM1E/VRa4hBMzuoFnmLyMTOSX4iIeu84FV4ctpJYMj1tsYm2tvqb61XbBlVVqaACcpOrAZdQM/YSGZeXweYju1SggKngrosiEY5lHWjFNa2bDpTNClT8DFOPX9LqCTSCZkOY3b5T67KuznZsABH2xhch3qbtpAFfzW+9JCk6rXh3751xUUfV+GBlTh/cL8f9QizyDwBRTeyR/4RTufjhXaUN/MHrPCn811+DxM3WszhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDSyjQtIcZUkWrABko7TqiVE9lnGuzxEYEk9C8CbsIU=;
 b=sGGFMYLNwUWzGk3R8xfUWvoBdStgfPNwCjq/Knvsbyh/Bz1kELFFFzl5ToYG4YZxumQBKIqmXUSY4oPZOFUEM/CtCbGZgWsvVOKbMHwK2lx8xaEzgT2FI501nOl3mUKdZl0TOAVf3PiUKC0g/PH6Abq6/cPTyDqS8TpbknEVUcCkgr83CeSkutt4xSGKhVBCstBYDdg8OtQ3oshSbj0JnvXDDLu5Kpcx8nVt7cFghgGSAC3MmbaEi6RWvB9vLwerTU7ERpeXtxBJsa8E91CgqCmGnZ4Kn6VU3QfPby/Z47RFna7JMnM9P2JmBD4+zJAPcs5IeFwZ0BUA4CZylqqahw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH8PR12MB6724.namprd12.prod.outlook.com (2603:10b6:510:1cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Sat, 30 Jul
 2022 15:53:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62%4]) with mapi id 15.20.5482.011; Sat, 30 Jul 2022
 15:53:18 +0000
Date:   Sat, 30 Jul 2022 18:53:11 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, moshe@nvidia.com
Subject: Re: [patch net-next 0/4] net: devlink: allow parallel commands on
 multiple devlinks
Message-ID: <YuVT58c3PVkvR+DL@shredder>
References: <20220729071038.983101-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729071038.983101-1-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR08CA0157.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ff90213-f9e4-439b-e846-08da72439f24
X-MS-TrafficTypeDiagnostic: PH8PR12MB6724:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ChUKBJqeesEKfFB5JLWHjtigjqcauSVgkI+ct0Q7MYepCQCMS815BnV+a60uTCBEDqX88vd8WvQdFKA4rZhUtjurOEwD3OfjcJejYynEtm0Vig4BEMctbAVrBeNkMsgGC2bnhLelzJ5xuclg/hLB5GOOInXn1Fh1lXzA0o7keH0DwTXv0ytB0QC9ERkyBJFWkG5oLAOWDtNgKvdpZ8T0OS1FDswYEvQcBBT8BGjDkpx9gs6GPyqSPdIAExqA1LLtvQeyDH/ncTwtoosC3KuIuUX7Xyu3Jus5bJstz7nvlKlcmS+E0yPZ+MCeYinaWBkI8bihilZ4rKr2an1e8FE0Bk/QFMq+g6g2+rHL+eVtvyM7Bkr5KMdFC//N06jxP0J6++vgVAn4kFMfTc1zs33y9QmkKOclUnh3nPUuJAQ2+0vUisTQ1oQ0Gld5lJ0QYA3KmC/xDf3qC4UrD8T+gn3MOHNaexOjNoK3y5cHcivkzZe0KxgrMptcC9xOwLYIKkAz/vijuN284UZ7xJan1XJl6lTJxE2/cLqDnHHXS+lc9TbWbOzqAtiAoM9Cv0IlfZyB8GjlTUoG4yQmu5FrddxCGfEqD27HK4SMGjkT8VLqU7KptxnxC7xlInp2BmckQSiTKoBouJYtRcXhUvEa0zvhEl3vApsSgOoxmlBDsdhipC3lYe9gTmHB3YLXkxRS5Za1gg1R2ZiOgo2cjT7eBUZ2cAEWVUFtQWRgIY0aZHRzVr748C5I6DroCpUA++G+y1iCZGgYABEWuhVFcS0wLzLtFYkwDIe0LYbsIk8cux0mGec=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(66556008)(8676002)(66476007)(4326008)(38100700002)(5660300002)(8936002)(2906002)(478600001)(6506007)(6512007)(6666004)(6486002)(9686003)(41300700001)(26005)(186003)(107886003)(316002)(6916009)(66946007)(86362001)(558084003)(33716001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iay5XiaHzD3tqLLVZYhwWuS8N/pDnmLLJxJpJTNA/KGlASWzsogaY3mFyuJ4?=
 =?us-ascii?Q?1hLguNaEg+h9qltBTLQcTiUmYnonCIX1xevracGGyktTyB1vAOxQe66rtHfC?=
 =?us-ascii?Q?XKORBHSI+3KSi5VUZXQj4MXK0ECiU791w4xGyTbt8NUUeLIt452du9+g65iR?=
 =?us-ascii?Q?INxaNkLrzW8d/oDKfw5bRsJd5TJoE5jDfRh2P2DoLFqiNRKswHgnL9dJ8qUF?=
 =?us-ascii?Q?q6ZGKSLaTXFa3atCW6otfiRZv9Fe8YFLvl+g2qWle+SWuNW9YdKI4q44mVP7?=
 =?us-ascii?Q?jFp4tg2N2xVlSGXQ+LJ6lh4WesX1EgnqM+55O4P4znHxIuL+Av+QYUiPdBzQ?=
 =?us-ascii?Q?5vOFsRnC44yCRWEktOIAnjTa9gJpK8u3goKVwwK5S4iAos5UqC/pbHp+2fSR?=
 =?us-ascii?Q?MKcyXoJe5RlvreyfSHKZ35yP8a9UX4pFbXBMS4CB4ZHeKfk1BoObdc85HarU?=
 =?us-ascii?Q?7HkJhDihQAq/ZJl23lclaxyqbFOMDDS6wEvaAHOtpxT5dZ8dXZSoPV9VHZ41?=
 =?us-ascii?Q?gK7rKYSIpn0BDKnG4YAW7K+f9YfiwCLJzl/73ZrQlwx+9WvYTtdk0KAy4hFy?=
 =?us-ascii?Q?SF9Deey2CE8GhSxYFSMVXBLUsc9ZRxL/3hydK2T0qy1LuBQJXaqUzVhwNydL?=
 =?us-ascii?Q?Q6CO+rh792Es8fYckmAmdRRsX1g2UbvkwOTZJ4IqDTbDCAWT0ZFPreNtbSMS?=
 =?us-ascii?Q?GqEOS6Nm+yY2QGBGtQknBItuITagD1qItrzSsfnh8svML79UDk397Kpu2Qmt?=
 =?us-ascii?Q?AsaVj1sF1G4QB9lw2t2TFItB+MnpGpTUBZTt+hYWWGeDJqNBKWtPxfqquffs?=
 =?us-ascii?Q?gyXehHRWIbtmkUnTArpEBDOWL87ofknlnmTdwX6VuimQE8x9G+t/Hi2zZe4S?=
 =?us-ascii?Q?GG35k7qzLOccZwWOKMFAbE5i9zWkMtr1Y3RayZocV/JB08x6qjpdxwvyLvZJ?=
 =?us-ascii?Q?FQJy/yXe4iX2kBZA1QeT+s6lpaS1XzeOzvgzWEfgEx9aKEQ2edy2lkJfx4v6?=
 =?us-ascii?Q?pmnrf6N5rlR6PPLq4mXOtKTuv8fiOiPlGPpNWHknhPDUSwX27T8B22e5aR+z?=
 =?us-ascii?Q?q8wT97cMcSER9eESNzwRMEvdJTqGaW63a/XGVm9/izpfiww6eJ7K7zydiloi?=
 =?us-ascii?Q?bkRP97YlIXcnR6EkWqqyHWCJ4kvvUgjBYvi1vHUYyF0dNM5fX19E/8oqR4sO?=
 =?us-ascii?Q?dxkpFxxMN8wpKb6liu2YjZxcLEnUMxfLg41BPJNPNNP8CDufcB06hpJjYItE?=
 =?us-ascii?Q?BXtzHHlkz/r5vnRHSck+VCT22pxAZtvzLQ5Mec8Xh2x+/bGeoPY6MhtM/Ks6?=
 =?us-ascii?Q?dq9ANwvGqMMhrEMoxqfARLuVtfUsMa+TTa8CCQ6YGjMmd++fN0ioa44iax5z?=
 =?us-ascii?Q?d6ebziEe19vvhLvOcVBHvoupyMksmTIvfWij5S4qOffn1k+k1xFmIQzHKmyk?=
 =?us-ascii?Q?N7Q1fLa8uDHfok8mNyf/F/Yt7TJeuoD18q4wA56y7zisJi3nOQ2eQQD7P7of?=
 =?us-ascii?Q?PbvKE43PWj3p2nucUcHLp+Ok31qRHMvVLfX3YURwRyObpGpnCJcwg+7rodrm?=
 =?us-ascii?Q?b1S+19QzrlPO7VBzu8TPe+pDVMqouIgfSKYZYYFn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff90213-f9e4-439b-e846-08da72439f24
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2022 15:53:18.6592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WZRmYYXsNcD8bpalwwfRvUkZbtNF3mPUq8W/JPjZcqdkBRf3uMUGYE+C95tNj6UsnSLYrlLcvfdXZiQ05WP6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6724
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 09:10:34AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Aim of this patchset is to remove devlink_mutex and eventually to enable
> parallel ops on devlink netlink interface.

Will report regression results tomorrow morning.
