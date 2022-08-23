Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9F759E998
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiHWRcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbiHWRaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:30:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2117.outbound.protection.outlook.com [40.107.244.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C256D25E8
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:07:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJ3IAddwVMnok6mrPcA4KJ/El4NfxI3rt8Tmd7YOOYyph5d2vcw9C2h/Ubul7A40cMBcH55GquD/Jy1wHVUGC6sYFaxLIBMnvP3F4+YgBh9Ep300/0N6TD2pz+NCgJn76/Gl1tbEOdICWh++5cFOZitYXqcTEfRbvRiq5BUdPFzxeXpBZNk46699l1hGt8Ud6vv5MhZXL7FZWYeSczTtlXqTUNzuh98ntpHjel+tutZUmsDPfiKhFAhB4vFQ5uGLnX1zscNcYLimfOKci8CV7hzYUAVTYiuC+6yhN5dcxg8nQrD4RUNa2nB2zVCEJhdvS5BBhQDAJWG7FVyOXBFktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6Sy7Bi/Fwm+EDJRVSdYsVxP37v5Z7sJkLpWSFCboPk=;
 b=UeLpQFv2qjtnnQdUBto8yk8jfGLNiy3bPM/rjq4ymP1qFN4ctoTQun81frJDzFe69K/zpDTE+1JzzjB/zpYixZEywnrwsc+4OBBrDmlMefILmpt9fMwDbJz+PiJcjz2hjGWY/RyUcDWZQzuBoWSYqGvCEELCcTpeMegj6QwtMNEc3vWvJIr8x4ozBIWnwa2mxM6M+bsCbArn0MgzN4v7OnSoV6q73U7L3WdprnTj1HDWAzkQ1yb+oeMy60h8kIkvt9s2DweZjR2M2A36iHFFgOVAAizfXHLzUTFqz4sXhciMXTyNlcyXbUoe/a+Nb0cIKXh8FZrgjnfX0rW+DRc5wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6Sy7Bi/Fwm+EDJRVSdYsVxP37v5Z7sJkLpWSFCboPk=;
 b=wGkXR9yORR5RHqr5BebT4pX+cqihqf+xAHPoeESTzY/aIWUGEi90oMSFhKkf4Rac7KC1TDcxoPy0Yran+wErq4GdIBOck48RJrr4U9SsiPlt0RuwEBAtHFxojNOh/z+6BYpHZ+OGUHk548LUDPjcf/JMUPSuw99GYS8pOyulE2w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5861.namprd13.prod.outlook.com (2603:10b6:303:1b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.14; Tue, 23 Aug
 2022 15:07:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%8]) with mapi id 15.20.5566.014; Tue, 23 Aug 2022
 15:07:02 +0000
Date:   Tue, 23 Aug 2022 17:06:50 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Shannon Nelson <snelson@pensando.io>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Fei Qin <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Yu Xiao <yu.xiao@corigine.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Yufeng Mo <moyufeng@huawei.com>,
        Sixiang Chen <sixiang.chen@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Erik Ekman <erik@kryo.se>, Ido Schimmel <idosch@nvidia.com>,
        Jie Wang <wangjie125@huawei.com>,
        Moshe Tal <moshet@nvidia.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Marco Bonelli <marco@mebeim.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH net-next 1/2] ethtool: pass netlink extended ACK to
 .set_fecparam
Message-ID: <YwTtCgBGclpY1Euz@corigine.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <20220823150438.3613327-2-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823150438.3613327-2-jacob.e.keller@intel.com>
X-ClientProxiedBy: AM0PR03CA0062.eurprd03.prod.outlook.com (2603:10a6:208::39)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ee585a7-e2a1-450c-2c7c-08da85192269
X-MS-TrafficTypeDiagnostic: MW4PR13MB5861:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ue6U7Tils5mzQcB3ymHzYBZ0kDaBWMAnUlIFbtn408aH8DUW1W+3UHGiPw226hXMQSkuxNKNTGrCSxWfiqkoArNtNvcFrnWTvqc/46UkquXFHDn/48fvOtFa/2CH+NsAVdY6EMy7ZNDd4C+VNpmUcjYrAsCxV4pcukUudst82q0Q/3nxMXdQRHFe3hOWp5lh/RVr+xnohPRWNMzsfU/JMyjMcWGToZzOCpSpwBwkoM+AgjLl/NeSzfa+5U/tNwiSDajEIkRF4Wq/qIYndJdAf6jF5Veri7rHIzL43ezudH5u1DD+Wb8IpUqenORvU+iOXex6R/rVMSeYnSlpLD6j5t6BDXhiOgQfNx4cV2CBEgr3nEy/8H9iH1vHcUc6fBiMIcm8LvNv3hAynXWc37MRHWq6IHVvAFCoU6EH8/uKxQO/Ul74qWcvL0UXNQmtYz7+uRVnyk2zoCymUSD8Zls5jfxDh+D0uQuk1OJ75fyocrvsbYZ6oGQjANetp9YiEZXuHhIoJr7MubF+f1CY68f9CSBQfWJV1Lh9RSBjSnTmXSySbsli7W0aEw0KKh56/lPVCJTBcSLHZaZtntUcFZ84+E630zcvCfprbqQlKcdlDnJSQpekl+YpOceO5NqpxkmsVLIcMby89sESC2gVR67t+mEUF+JjkqqOpdkVJFZ3Vwww3/k5kJ5gOFYkZiaNNtYAKyMmMCEjfXvkm597RTdiGsMpef+d5DUey41lfZeQdpbKrxWp4I9lTfSG6Dz3mpav9Cxa2/7eMugpyx5wVCQLr6SfIGJm7ayD5eSb//7RlPARdJEzBTQ8FEqKT7cPvqBB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(366004)(396003)(376002)(136003)(346002)(6916009)(8936002)(44832011)(66476007)(66946007)(6666004)(36756003)(4326008)(52116002)(41300700001)(8676002)(66556008)(4744005)(478600001)(6486002)(54906003)(2906002)(6506007)(86362001)(316002)(6512007)(186003)(2616005)(7406005)(38100700002)(7416002)(5660300002)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h9hTMcDyehNr/Kum+ockJaQ8b41xJ1h6zlYdfJ9LW6ISvj5h/GW0fAxpqqSv?=
 =?us-ascii?Q?ag3jgsLExM/vmU43PPpIMV3uwNx8N1sVXGZgcZfAg/VeSwOSo7oNi0gLQR9S?=
 =?us-ascii?Q?P2g5khT5fBDKjr38i7E+KXf70DjT79WuVmqdeIU678WWup8na25UWk8kzti2?=
 =?us-ascii?Q?XW4TTg/+0Eh9mmd5OEkjdJDr1PKL52ZVSchp9XFA0zrPm18WT1tIAYDlFUk1?=
 =?us-ascii?Q?J0qRchLKhm+JXQNVZd118a/YicK9RlH3BV7da7NRoMSRHu0sbBm8EzHrMlhX?=
 =?us-ascii?Q?XNi1Cnj6yOE3ANefmhRDcC0VkJ77kizxIrxCpsmPdzoMLpg1VRKYL7XeqjxR?=
 =?us-ascii?Q?QLk74on03MbfCJi9KeFiI+/u31zGvJBmVkL3LfLGBV1fEhJRPFPyaXP8+bYg?=
 =?us-ascii?Q?oy508uaxEKyrIGmwbAXH3vIUAEyMxX1KHXZtjHzzZbB4xJpCq8w/vTVLrkRP?=
 =?us-ascii?Q?MJsMJAFXTmu/CEe5PlB+DgX6sPFrD6e4RCI8+whBU3rKrx+vsRYKKfMYAXP/?=
 =?us-ascii?Q?J7DNMA3ZdVRL4liSPQxEv3IHodfhJigxRpwe0+HRwpOZ1tVSkiMVte4fQ4dT?=
 =?us-ascii?Q?bCl9reL65JwwRQfr5e0nwW77iCLwo0zpCsvdxeSGK9BHmS2SVLNBqYugQBBZ?=
 =?us-ascii?Q?C13wW1HNTX9/ZdWyEztx+sQ4x15y73EdBXVC3sB6BSbCxmxGo8niClFwa2lT?=
 =?us-ascii?Q?w1ecmGzUZalvVJl10p7FmHN8YaoKSxj7HkHHWVq4CtVkbZEkdWhO3h6poCkD?=
 =?us-ascii?Q?LLUPuPfUeHM/D14zBHk9BVd9wKLntzgoYh+MjgMZ/WZ7EdvNxWg948/FRh2j?=
 =?us-ascii?Q?VJC0AF0mODJezLYH6ekVh42NSZnpgOeDCR8QJUe8FQsZCtVz0cmg3Rso6HNz?=
 =?us-ascii?Q?dmmPF6fUPWKFEWe2dNKzA0b0QATa4o4/7jUjAux/4NjwbvB9CgT4KcVsbrhI?=
 =?us-ascii?Q?CpUUTZvzrnqTpqI5lAxF4rNnJz11zZC4xqfF+QNGKtrurhokp1cqV20ackZr?=
 =?us-ascii?Q?/wDisANbhrpbkWFFXhcfs1zi4Yhq/3PaD7ZE+7zGEAwM7q2qsSPrxtCwfWEL?=
 =?us-ascii?Q?NVsJAaPRL7v0HXH0PR/dD+sUzNLx/UNF8hVTHAkppNn4YFpn4zcSQhpAemAn?=
 =?us-ascii?Q?Y2D/2ECkdi6rTDvZUrL5HfpC/EuGqbaQgBotlRXpF0H3dnBiKUbhBs+CIxxD?=
 =?us-ascii?Q?sgNuKLh8C4CN9wHsmmFmTc+czGr7YT4CeTCE9dOq+4q55DiEAcIoGbqErro9?=
 =?us-ascii?Q?H66HW/PE99RcQZ/5R3s34wRsjWsP3OSzB3xWKXd1I8WQW7c9WvY5ljw7tVN+?=
 =?us-ascii?Q?BW2dXzWMfvq/xbmhjZ2p0k7pe3PGGJSzAMTX7YGs7RSd25nc6hB9xezUz712?=
 =?us-ascii?Q?dn5Y6hqXgIHgFtjdiP9bNTApYcRgm9EV1njPtvaIJikFlIxpeR46Qk7MZt+5?=
 =?us-ascii?Q?msHgqFisFlvfbyLo5rrJz7BSMWiMPCXfOsCLU1OPPEVL6plv0/Lq+icuKk4w?=
 =?us-ascii?Q?l4lLDlG9j/IXGWC4y8TnKaKqwpcqoDamu9mszMLjO8BEU4beMBSL2DxrxKWh?=
 =?us-ascii?Q?b3zqIz0+ZdS+UGWn39geKo8Z9TkdZHl1duj8Zx7HbiBgcyN5Ar/aGdRoz7Ea?=
 =?us-ascii?Q?2as+LRgtV7OMW+BPD/5btH+1hSBv1SCChf1QbsfqOMWz2z98g9hr7220eKP0?=
 =?us-ascii?Q?2aMF5Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee585a7-e2a1-450c-2c7c-08da85192269
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 15:07:02.6840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LS559umBYF+dr2rpb1paZUwQqeuTnD7Y1rh0uOtmq2jZqHpY2GmqWdrJaKszighgexLXV/VoAV3Gzxg30NzNhyA7DXO7glQTbeGVHW1OG9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5861
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 08:04:37AM -0700, Jacob Keller wrote:
> Add the netlink extended ACK structure pointer to the interface for
> .set_fecparam. This allows reporting errors to the user appropriately when
> using the netlink ethtool interface.

FWIIW, for the, trivial, nfp portion of this change:

Acked-by: Simon Horman <simon.horman@corigine.com>
