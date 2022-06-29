Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B478D55FEAA
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 13:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbiF2Las (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 07:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiF2LaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 07:30:18 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBB73EABD
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:30:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKquGqy49v8/kBkmsl+rOl+m321TS3pyKwIFzb/cD4gFGPBTyvSJwSGTYagvXlo24XjPXSzWCNARX6RdjqLVjAL5k9qFpmf6Zr7UI/FhsWbkt6aQl/r2u/i2E/A0CRTJqx5XKk/ErzuFHMid6LTSkuHupqcp8ksdGW6pLFsJTvTlLrdzRUCrhEsDJHA0VfKcrUN/v8rdnbWum8/U3xDn/McUsUVzsIRd8qNpSML2Mccg/CEBgvyEceg/NpcAXykvyifMIRr1RgPzIiGYs4Xg5aa6Ej7xbPnzJrMVbs2qi13dDujd66nMp5t/ob1GtxPO/pud0Yvxtm0dPSfghN/qyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N6SDI3xJ/8ZEdVJ8/cKNRyI6P5vu3TqTAGWLsdbcCCo=;
 b=kfg56RJe8tZsT4yVvuYBsauhErhsxVKGasamt4EoR0mEBgjgF/lL45vKaweGmKpxyRKNb8qK0gbD9CLPihzsQWa7W32rB8O30IrOuYKUwvRaG1pMtbtlJhwronoRi5QRupb9D8kIjy3LHYyi3bmVdRb8TbNZ+xhCODlzHCklljjg2wv2VeQRtKTNZQMpHWrH+xk3Npp3zVq1SghXMhM/3L2dWYScZkiR11uTmLE7E280W6tj5mVq427yNijqVRKgnSsnTZzeIJ1Lwyinm155mbZMAmosUKGOZO2hVkMaiyONjzBNTWWrpAy4gZWpkUKF955bA4C50+4Xc7ECnJszrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6SDI3xJ/8ZEdVJ8/cKNRyI6P5vu3TqTAGWLsdbcCCo=;
 b=t+5FxcFJv2EDDBSxT0siIgJteqn7IT8UonQxfj/BfkLXNblg5uHw+YJMYpQzf64UC29OZoUjMRI5FWwlUmYHZZqISu1wlFAWn8Fa9ruBq6WsNAWIzeYN3r/UJ5FndR/oU56iPDuLuUkwbIDM5xj0kFL+pHffs1mrvf9gLADPFaR4WxuEQm7+TkwPzBRkwjSQN3dl9N9jRix/RRLRGqnQwTfGikFgVPx6pNNKnrW23iJu541+qBXLxS5jUBql+3oM6VQDRsQDLYp8z2J1qpgq51gD41KEpd5jb0In2VsLa/lneD3POP0VUusC5av1pFcsWs6EGDhjzBO/pIiUuQQxzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Wed, 29 Jun 2022 11:30:14 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 11:30:13 +0000
Date:   Wed, 29 Jun 2022 14:30:07 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Message-ID: <Yrw3vz4+umAxXVrc@shredder>
References: <20220627135501.713980-1-jiri@resnulli.us>
 <YrnPqzKexfgNVC10@shredder>
 <YrnS2tcgyI9Aqe+b@nanopsycho>
 <YrqxHpvSuEkc45uM@shredder>
 <YrworZb5yNdnMFDI@nanopsycho>
 <YrwrKDAkR2xCAAWd@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrwrKDAkR2xCAAWd@nanopsycho>
X-ClientProxiedBy: VI1PR0601CA0026.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::36) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 280ba149-4fdc-4c23-f77f-08da59c2bbec
X-MS-TrafficTypeDiagnostic: DS7PR12MB6120:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQha4VAAJA1TaxXU60Z+qWkaPNn4LPjmQmRgiC5xUK/kyh1pn3kVLj2sX+Hmohakw2HCuH7ALC618cyu+U1fl5WGb7KVKksSemTcV+fTUrbsr5wNpkHKC10T2I/A2xzoJOKugUzCAqL47XMk5/JHgnhmNlBW6o8Dh5ayZ1v7SaXywE5hC7tmeYFbL0lXD4AqNPIFNWRUpREeCaCGX4VGQ4yYmTQCFU3cDRhd1SN1T1aYYUWtcSACuQa9QeMWSd8OzXWJBG1EF+eD12D5yGSrgX6ihnu7xowgry1fIGj/V348eHahNRcvZetnsIOA4zSom6HlsBg0L0DJknusdy5LqWfA38HDSPaypq8b9e7ClcFjlmkTPRks9XwznsY4VEr/9/Cugij4iIhEXmAXWcTUmslQbbfB0l9HFrL1oaOrz50J1i708kZmk5OFJdpO08DLucRvX/Tvdtvee8zINH7iI0+tNL8ggQU9tF5c5g4Sy7FCv1B3gHPRus9ZerQBEBEbkLsCtm7Tcv8hz42oqahKgFMKJ1SUyCtt8rKXpSH1/gxi1fxqWODqVemlxWuSwfe/2wHZhQnKfb1kdM9f1RVQwMhHOim3m8UPEmi3P5dH/D+Dd1sqcbAx98zlET0onFs9XXXuKPE94OlygGh2pRSycV+YaUFqON8Yq6YS1qiWyn20ZgZa9t8AXupK1eYI0lVOWBj6g1wTJpkbl7R71qFQuBJ2Le12fZb96a86pHvZyPzSIxYWXI6fUx+j4/EWXDs0MnTRJkNaLj3bnSB56agqkCXxJZMuaZKL6rU52gccsUI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(366004)(346002)(376002)(39860400002)(136003)(9686003)(66476007)(86362001)(8936002)(41300700001)(4326008)(66556008)(26005)(478600001)(107886003)(6486002)(6666004)(66946007)(186003)(6506007)(316002)(6916009)(5660300002)(8676002)(33716001)(6512007)(2906002)(38100700002)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GWWnQXBqycil66M9ygofKssnCcBfUvOXxduSsxK4JTncDiZSgrvbs6Mrry2s?=
 =?us-ascii?Q?MxcUFGBdtlrF9qJGzbJ3BFUDGo6SmQt/ASsWZmZhWWNwvHCom7ATouVADTI8?=
 =?us-ascii?Q?+UZM/acsTN55uhKd2b5f9kE2W8Z+Nhn5aCqnDPE4+/w1uAXHS1Hw8d37LYEK?=
 =?us-ascii?Q?3jUq5fA5Nj9fcqeNuCR0NTpfC9+xgo5DT8dh9bPUu6rnpIqeMg/2KApNhwvC?=
 =?us-ascii?Q?dOenH4CrIfmRE5gM0u45teUyJC5w1d5oZQ3uhgrzpKAGYA0odRga7OeL6t+d?=
 =?us-ascii?Q?wbjGb0HkUZwXjxFveSta3iw/SnXsSTd9Axe1EbuiuFG6wiaC8TmDbIMCybsZ?=
 =?us-ascii?Q?gYKUdZxIpt+S10OsMpR3DrO70NxV930gHQyqe6sgaKpcHGGrV/7xaVP3xC7y?=
 =?us-ascii?Q?ynRcNLiwigCVZQAljK8ggXT9naxvS65r3OHbPLGHB3KHTBbn+tI2Zaod7Kya?=
 =?us-ascii?Q?76vcMbwQUpn4ewkXhZagFa/D/l4lg7MZzWssw7XJ6eXvoBQo6eh1+gzBuYQO?=
 =?us-ascii?Q?UDzKwXrAA9AA+NcqaamtV8dGMuUBc3RXVNvZoD6v0NQ7IF51YlQcgkj15vS0?=
 =?us-ascii?Q?WJGf70DcZFj3Otqcx8CbUd99msKGOIUXep1OijMBfnFMBIn0s4X2TAHxZl/J?=
 =?us-ascii?Q?xyCzA3ZodfL7eM1JrEVMBtjG8/l09+fnu3WZSirkfyhmUF+2Woeh+g71FOh3?=
 =?us-ascii?Q?jiIrdjSzLeAH/Zr83tFdZJ28eEOUSdnGPw2MMzo5SlFTZYhVhjIv7LQD9/4K?=
 =?us-ascii?Q?Q3XK/wfA+RG8EvhK0isWPjZR0+Z195dYENzWtBLIVBDaRnaf2bdLDGKzQlsW?=
 =?us-ascii?Q?52Mnb14jaY+a3c/P5RAhb9gAdYTg0ABZC8ohyq7Rz5SJ5dfvUrqq6trDl1sO?=
 =?us-ascii?Q?h2sfRbaAVxC/G4H5GTbZ+Vq8WKwi62qpeqG6FO8DO5TsmewI+T2pDDRXWo4o?=
 =?us-ascii?Q?q9NwNoPA4BQLQmPtl3uHLecHi+eSd/sv7YwbhAM6URuqySpDuc4GlvIBhZa8?=
 =?us-ascii?Q?Y4uTwAQSswJj6z/VxtyE5ORncYNddvSwGR/wlCBZeA7NiQ3locnNQM3EpCkb?=
 =?us-ascii?Q?F5ACfCpx2CYCwf0JUsqThZgJ7p5sV24gII9uWEQx4LHmYS+N83ndLmqp8utQ?=
 =?us-ascii?Q?8F04oLUob6KhWdElF7kUgLLN+S5p29eqAICYqAcXdtdV0TPiN9pmgXYcj2KO?=
 =?us-ascii?Q?r6jaGOHXUJ7SOfTTekgYsGx10WB17bMXppL5Nk0qQgojD4hIy9KdcCpTPg0P?=
 =?us-ascii?Q?AN3Pg4nNIncu9VgnHqef0t50sB/xzXIDNaZ4SFizCV0wfHEHfeD4OjKvkDSn?=
 =?us-ascii?Q?Ht0loDwKSX+a8nP5FCkPofSL33zTjqB/sWdpZo9XO+oRyV/aX16oiH7j2Fs5?=
 =?us-ascii?Q?1n+kEFPEkUMRGhN3HKEFsSmkq2mi+HPTklHjb/qB0J1dfAOlBTJV1sJMs9nU?=
 =?us-ascii?Q?vBPlNgMGbKkbX8AakzkaYxBwoRfFnD2WmMLVoWtgbvJP8KI9YKadxAR0qKdY?=
 =?us-ascii?Q?JdMGVPIErtah4SJ4w3fhQ/6GgmnWtpfji/YUH8mBiaXz4cNTHfWjr5SXKFxv?=
 =?us-ascii?Q?Ix7E5fjij2KLZID3adMS/0FmPS6NwBceg7rV5jDP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 280ba149-4fdc-4c23-f77f-08da59c2bbec
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 11:30:13.8992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBRMExHkPHRXyCKSU6Mg6LNedIQsOBGTqM1qVv8UVbRBZwGnIuG03XoJM8Lr1yZlwsj7IaX78bE0klxSqoif0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6120
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 12:36:24PM +0200, Jiri Pirko wrote:
> Wed, Jun 29, 2022 at 12:25:49PM CEST, jiri@resnulli.us wrote:
> >Tue, Jun 28, 2022 at 09:43:26AM CEST, idosch@nvidia.com wrote:
> >>On Mon, Jun 27, 2022 at 05:55:06PM +0200, Jiri Pirko wrote:
> >>> Mon, Jun 27, 2022 at 05:41:31PM CEST, idosch@nvidia.com wrote:
> >>> >On Mon, Jun 27, 2022 at 03:54:59PM +0200, Jiri Pirko wrote:
> >>> >> From: Jiri Pirko <jiri@nvidia.com>
> >>> >> 
> >>> >> This is an attempt to remove use of devlink_mutex. This is a global lock
> >>> >> taken for every user command. That causes that long operations performed
> >>> >> on one devlink instance (like flash update) are blocking other
> >>> >> operations on different instances.
> >>> >
> >>> >This patchset is supposed to prevent one devlink instance from blocking
> >>> >another? Devlink does not enable "parallel_ops", which means that the
> >>> >generic netlink mutex is serializing all user space operations. AFAICT,
> >>> >this series does not enable "parallel_ops", so I'm not sure what
> >>> >difference the removal of the devlink mutex makes.
> >>> 
> >>> You are correct, that is missing. For me, as a side effect this patchset
> >>> resolved the deadlock for LC auxdev you pointed out. That was my
> >>> motivation for this patchset :)
> >>
> >>Given that devlink does not enable "parallel_ops" and that the generic
> >>netlink mutex is held throughout all callbacks, what prevents you from
> >>simply dropping the devlink mutex now? IOW, why can't this series be
> >>patch #1 and another patch that removes the devlink mutex?
> >
> >Yep, I think you are correct. We are currently working with Moshe on
> 
> Okay, I see the problem with what you suggested:
> devlink_pernet_pre_exit()
> There, devlink_mutex is taken to protect against simultaneous cmds
> from being executed. That will be fixed with reload conversion to take
> devlink->lock.

OK, so this lock does not actually protect against simultaneous user
space operations (this is handled by the generic netlink mutex).
Instead, it protects against user space operations during netns
dismantle.

IIUC, the current plan is:

1. Get the devlink->lock rework done. Devlink will hold the lock for
every operation invocation and drivers will hold it while calling into
devlink via devl_lock().

This means 'DEVLINK_NL_FLAG_NO_LOCK' is removed and the lock will also
be taken in netns dismantle.

2. At this stage, the devlink mutex is only taken in devlink_register()
/ devlink_unregister() and some form of patch #1 will take care of that
so that this mutex can be removed.

3. Enable "parallel_ops"

?
