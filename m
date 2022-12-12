Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8952664A84A
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 20:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbiLLTvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 14:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLLTvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 14:51:37 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2073.outbound.protection.outlook.com [40.107.15.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC4F1658E
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:51:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZltiOUrXNcnmjCs1gh3q5Z3s2C0KClCiVPhXGTUTM6JV1jT80SB27vTD5vekyvzxLj64/r4J01W9lUguyqH/ZAccf1OmV8ecXxE9LMiKcI9vb1yrIlEYI11Kh+sOtJwWJzr3NYiGOWiHjResUWvirmXNJCBPtxROIKvd+BqrAtHCojmWKqeB/rRiCW8Gnd5HticEgNhLm1iVpScg46r1Sk4VvYi6FF25idZ0z68sVz/RkwqbSZ53Ov8u/vB5aPhcmI0PQ00dydJP/+k+Lo2YZJyIxIWvTyERyEiT3vuycrDwRYxrxUTrggfdWW19uTX2D7OIVrPF6rYom5sEkZviA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/Gm1Tf0cWnXcBaJSn7AlZQugS05SJX2nf9/Gaa21zE=;
 b=YnnCKmt8VnDN/bmzpKN1sd9WahGHyg+QZVzVjoJ4bIH1DueSmH0fQjQRC+3J8JGE5mV2t4AR8WPkcnP+aJOXmqmBHYNTViKuJ/cI4YRMZPCnkCJb0tHbP4DTMeqMRglPoclPDlrzSbdcSh+iSGftCBt3jh2Ms+pBjuFgtL5D8eGLhJqRSDRpATjofnfO2BOOLg+u9nqTtICS51isR0ziBNyKRThc5Dp1xHLDL22jjWqaxgSNNzPqYi4BGajyx6ytbemRlCxQqUBfEYIFAzOp+q/64aOFA4WCuwUG8ZERZiK18Hq2zEvhOmYYnv4wi9etF6PSvD674nia6B3KMBrEZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/Gm1Tf0cWnXcBaJSn7AlZQugS05SJX2nf9/Gaa21zE=;
 b=STDvrkX7Mhk2mrHRQHOGOCZO5NIRJibMXGcOcFqOfJjqTNrZ2XKNZUiAYKb7XfxHVbWKP7qaqe/+UiiDCw7FxWF5RFW6wOJqkBwsCOeFMmROqjWLiILTClYYHhvDVFOEaquMA/GTwCc0leKuZztZK7y89Q83WFyGgLrN4rCfvGs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8491.eurprd04.prod.outlook.com (2603:10a6:102:1df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Mon, 12 Dec
 2022 19:51:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 19:51:33 +0000
Date:   Mon, 12 Dec 2022 21:51:30 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v3 net-next 0/2] enetc: unlock XDP_REDIRECT for XDP
 non-linear
Message-ID: <20221212195130.w2f5ykiwek4jrvqu@skbuf>
References: <cover.1670680119.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670680119.git.lorenzo@kernel.org>
X-ClientProxiedBy: AS4P192CA0028.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8491:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c9d7d08-262b-44b6-2ecc-08dadc7a4577
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ShK5PtpEHKYRl0WYiCEH5DE5Iva5rM+4YEK5S7Q0QL9UjyJ/Dx4IJ13b6xtppMVQCqxsj+gXTkzF49qIib95grdK9s495fcB71/orPuZriMayGkfGKfpPuTDyLKGHs5wjWmcnZDor5DtpuxIvp0IXisBOlKySaaVsUqdNVf/y6GzZN7jUo5a8kQUdVutdY0AI6DFLDsluAYL5Yo6wbxwOkeckZ6V03tFCRnLkQePwr+N7plNEAifQXm9jwzblYwJRbypgPmd+z5MnX5/B4/7Qrd7E9K81Cg8XgWdbZmjM9HkZLxIf2FcoPQA38kNz/sA3Pe90jUigUF9cvUwnayM8a9LxSssABYsGOM2PD3oGfKyZjUvQ3ubVakKmaSWRPr4ieBQsKsa12ShuEDX1u1zLfjm2qT4EwJ5P23vtENe19FyRFzHmUGr5pqZ7BI2+IFKeU7Wn2f5UeEYHzBdIsJAovyyyePyJI7L7HvKOEfrtRLxrfgx/Nu4dAktxdDdqU+yRAaxqlsjGOWEnqKI0c2VFvsYA4Z3TxJhS4MXGG3yVLx6twoEb4NST2IfNJqcsxntyCBWTD+CoSUNfNmK7I1JduVIGVgH9nnQO7P7QEh1XMuIS83Hh9iGXsZehfTsfH2otJ/y2aE29y8jpxlMooAJxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199015)(38100700002)(6486002)(5660300002)(86362001)(44832011)(478600001)(2906002)(41300700001)(66946007)(6916009)(4326008)(66556008)(316002)(8676002)(83380400001)(33716001)(6512007)(6506007)(186003)(8936002)(26005)(9686003)(66476007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xq08mvk0CkpKtA+SlPCto90QMDyZCeePt+5j9axYUsT/PivEM70oVGm4nOKc?=
 =?us-ascii?Q?g7lkP04JzoNrX/KTaa3Wo87hUokN3hU3QRgx8Tx0oSgO99iaGYc35f9L0nJc?=
 =?us-ascii?Q?HNXjIBbZ7QJ3Tb2RJC5iDhDayYR4TtAq+xDA4YUsydaQ57Xvojf2s2/63Q+0?=
 =?us-ascii?Q?/udmXq184/RpIvJW22A0U7YGnLQy2K7vhBDPLYX0y9qNtwXTkXMUtaJdrZYj?=
 =?us-ascii?Q?vtax+cJHJPlHnHdn9nF773lMDcJgSNdqNWV2cmhxcGwzCkgUmz/FiMFQDWKS?=
 =?us-ascii?Q?UHC+0ZCCRpLxCqTV873ahlsIpk/nOkCdZg7Sw93mdSMTQmS/g56+8+bR99lf?=
 =?us-ascii?Q?qOJBjSNzvIhPu0+knuqj8OG1lQ5YU7TxaxH40TaaxTPkfH3QDw+EClZitQt7?=
 =?us-ascii?Q?o94dderG9IMShI2/rUDJFlBvFuMBwP+ZoHqcVzgFp6C5Cuq75lb3+BTu3G/v?=
 =?us-ascii?Q?BigSDkT/f+tMwdEFlfn6KdN/ilmXEwFnnf8M2nDMEnpg32EjxDavcAtMxZsI?=
 =?us-ascii?Q?RObD/mWdfWKxP6Hbl6sk/O0bI0dcZdKPoGd9T+K+0QPjwx5K12xLuarI+Sez?=
 =?us-ascii?Q?tKXB/ctF6X7/g639HvbBqbUpto9oupKB1lRdOXNRmq2VLaOZGPqp8Ko9NAQo?=
 =?us-ascii?Q?2qBd9t/FzaBOQr4wsCRneMgd+hWzYFzv8HuIKgh45AQEjsrO/xpErhBCpOqX?=
 =?us-ascii?Q?JJk4/1x2tTffqChhPPwW1rasBbj8alv653O61Mi/tpO97CWrwmVahjJ8m5pw?=
 =?us-ascii?Q?GVDIe5NYj1PIjyWTW8hw3O4n5UgKrC7WDSJ3bkSlTzt8rEp2OR7lf9xYPSDq?=
 =?us-ascii?Q?AA32nGHvhsuzTH+Qo1S4fqAtMOjrb1Kit4G9w/wRaKI0x9luMS1CmeRFmX+C?=
 =?us-ascii?Q?wwQPw4mbaLJVLQOKCgmmvvrq0bxatsxbMR3qrko91E3AQp7+XOuD23Liw1VU?=
 =?us-ascii?Q?nyM6Lbf6MauDrRqAqmGcP9LXYxXIlmbhROc2BNAwHfU68Nzya0UkNfM17NO9?=
 =?us-ascii?Q?z1jCTGUrDhK/ykoR6xSnaUoT0zio/WBzLR9RT/2UqZg7I87nSdmFoW4JCBDk?=
 =?us-ascii?Q?hrSk2rJQ5AuU44Kamwm7MhrrvX2SdoBw4yQAR0JMuMN0iXnyhPjvlXH1v9hZ?=
 =?us-ascii?Q?Ps4eYb85eCBU6cCOVNv4CjjZGkaWZgUN3+1TXNiwp8RdhW6RqsYBR3Pc1utp?=
 =?us-ascii?Q?GEzx4GHcQe8OVQwu6F8pHfUHSor9up3Q9tShM6e/2mXbAT12NnA58M68kVgZ?=
 =?us-ascii?Q?S8IdzDeWOdvsAdYoalC3Dsj9/QmvmzTCl9kYhEQF+KSu+JtOPK8lXRqhqWKG?=
 =?us-ascii?Q?7kRj6b10vli6gG0UGgPJpZZNJvqEg6yDcXtKvXIBgCt4rOVEJBECNDVusRyl?=
 =?us-ascii?Q?wqQfSdENZgkOsbPb3U99s7GWgFNRFcoLpZjnyrLd7T6qp8gZpPwpEl4ushqu?=
 =?us-ascii?Q?GZfzO77hVPkkA/LbYSDRroG7EQT9Sg/BfXqf/6KrHZPuqwfdld3gqmG8Zs8k?=
 =?us-ascii?Q?Qmp/Nw7sntMhgIBe6JUcKkAPRuAbgZuuPMFyTMqYVwdtAc20CgYaZw6uPH4I?=
 =?us-ascii?Q?R85/L7tCwhJLe/ZneoePeENqZSi49hOF8PS+OGOJCYvTOc1CKc9LvSavgPYu?=
 =?us-ascii?Q?eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9d7d08-262b-44b6-2ecc-08dadc7a4577
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 19:51:33.8093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Fdu9HLy4eDQbKtOCeVB153I27BDclcv4/ws8bZXDx4WfhGXiiI3ClMGdDbi92hixTQZJ4inZao3LDp5Vy2isQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8491
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 02:53:09PM +0100, Lorenzo Bianconi wrote:
> Unlock XDP_REDIRECT for S/G XDP buffer and rely on XDP stack to properly
> take care of the frames.
> Remove xdp_redirect_sg counter and the related ethtool entry since it is
> no longer used.
> 
> Changes since v2:
> - remove xdp_redirect_sg ethtool counter
> Changes since v1:
> - drop Fixes tag
> - unlock XDP_REDIRECT
> - populate missing XDP metadata
> 
> Please note this patch is just compile tested
> 
> Lorenzo Bianconi (2):
>   net: ethernet: enetc: unlock XDP_REDIRECT for XDP non-linear buffers
>   net: ethernet: enetc: get rid of xdp_redirect_sg counter
> 
>  drivers/net/ethernet/freescale/enetc/enetc.c  | 25 ++++++++-----------
>  drivers/net/ethernet/freescale/enetc/enetc.h  |  1 -
>  .../ethernet/freescale/enetc/enetc_ethtool.c  |  2 --
>  3 files changed, 10 insertions(+), 18 deletions(-)

NACK.

xdp_redirect_cpu works, but OOM is still there if we XDP_REDIRECT to
another interface. That needs to be solved first.

root@debian:~# ./bpf/xdp_redirect eno0 eno2
[  313.613983] fsl_enetc 0000:00:00.0 eno0: Link is Down
[  313.699861] fsl_enetc 0000:00:00.0 eno0: PHY [0000:00:00.3:02] driver [Qualcomm Atheros AR8031/AR8033] (irq=POLL)
[  313.735530] fsl_enetc 0000:00:00.0 eno0: configuring for inband/sgmii link mode
[  313.754024] fsl_enetc 0000:00:00.2 eno2: Link is Down
[  313.798565] fsl_enetc 0000:00:00.2 eno2: configuring for fixed/internal link mode
[  313.806252] fsl_enetc 0000:00:00.2 eno2: Link is Up - 2.5Gbps/Full - flow control rx/tx
Redirecting from eno0 (ifindex 6; driver fsl_enetc) to eno2 (ifindex 7; driver fsl_enetc)
[  315.791491] fsl_enetc 0000:00:00.0 eno0: Link is Up - 1Gbps/Full - flow control rx/tx
[  315.799451] IPv6: ADDRCONF(NETDEV_CHANGE): eno0: link becomes ready
eno0->eno2                      0 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                      0 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                  19806 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                  81274 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                  81275 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                  81274 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                  81274 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                  75733 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                   1562 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                      0 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                      0 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                      0 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                      0 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                      0 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                      0 rx/s                  0 err,drop/s            0 xmit/s
eno0->eno2                      0 rx/s                  0 err,drop/s            0 xmit/s
^Z
[1]+  Stopped                 ./nxp_board_rootfs/bpf/xdp_redirect eno0 eno2
[  347.901643] bash invoked oom-killer: gfp_mask=0x40cc0(GFP_KERNEL|__GFP_COMP), order=0, oom_score_adj=0
[  347.911254] CPU: 1 PID: 412 Comm: bash Not tainted 6.1.0-rc8-07010-ga9b9500ffaac-dirty #754
[  347.919676] Hardware name: LS1028A RDB Board (DT)
[  347.924423] Call trace:
[  347.926901]  dump_backtrace.part.0+0xe8/0xf4
[  347.931223]  show_stack+0x20/0x50
[  347.934579]  dump_stack_lvl+0x8c/0xb8
[  347.938288]  dump_stack+0x18/0x34
[  347.941644]  dump_header+0x50/0x2ec
[  347.945182]  oom_kill_process+0x384/0x390
[  347.949243]  out_of_memory+0x218/0x670
[  347.953039]  __alloc_pages+0xf28/0x1080
[  347.956919]  cache_grow_begin+0x98/0x390
[  347.960887]  fallback_alloc+0x1f8/0x2bc
[  347.964765]  ____cache_alloc_node+0x17c/0x194
[  347.969168]  kmem_cache_alloc+0x214/0x2d0
[  347.973222]  getname_flags.part.0+0x3c/0x1a4
[  347.977536]  getname_flags+0x4c/0x7c
[  347.981151]  vfs_fstatat+0x4c/0x90
[  347.984595]  __do_sys_newfstatat+0x2c/0x70
[  347.988737]  __arm64_sys_newfstatat+0x28/0x34
[  347.993140]  invoke_syscall+0x50/0x120
[  347.996939]  el0_svc_common.constprop.0+0x68/0x124
