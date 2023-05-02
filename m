Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BDE6F439F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbjEBMVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbjEBMVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:21:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF4F1A1
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 05:21:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvAi82T72wgMY3g9aQHvtsMTzwxcnFZyHglwIo8P95+361cC/nZDRBSZjFmrAgNjcO6hZ+Gje4Whc6D25Dc50i9gjfL+7J3wECAwfFYSpIUQRDctDGw1yz7NS6qkZ3tJjN7JA96Ge0iTZvm9yeuC8imBVNIcDZ3boXBACO9TAuCaz2m76+tUn+uK5Y6AICExm6M/VLTWunYkw0heZANyvdau3mavLYTayFup24M3o0VW2o+Uy4eOYY9zsdOvZM2K8So+YTVQpi0bguaiI5u+SIhhDFNNfOSZ6kIAt91EZCpV31y1AmO9JKyd29HMuc/8PzIU53w23wPIiNPFoMYPJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLwCoHDQAqhuF1pPJXQz4hD+c51wvTpnIqTgtlRe1fQ=;
 b=cfgqyLqpf7y9M6ZjMSrFLmdJjremlJXqgfBO/fR11Bzux4XuVoQZbZv7k9qnCIsM7cI0Nhx18ATDgSWApNQFXPRSrbeU9/TqINI7B5txnfc+6b6QtOIqquknsWxQw87JCfn02H2Nk9YnTW+s8xHiOcqCQBMRiJxQ8NgcXS0agCtgfDCWHCRpOtQZ6NFFY0fmWHXE94T7AIrUKng9CRh+GlPZcF9iDk4+vUxEhQ/L3j1uvBsxVdlEcSeekd6XlPJnaRD1n4j4zAvJn0W1Et5vvXixnSJSQE75B0I4qqLy13YurnDnER8gP7pyDdlnkkgDzi+yGFnyns1GKSVM8I9KlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLwCoHDQAqhuF1pPJXQz4hD+c51wvTpnIqTgtlRe1fQ=;
 b=gu6BM61JATUG8hHSWILP7bs4wCjPziTxBVsUsUZV9AqcP0aLzLBtJn1a+K4agUAR4pdw1EFBgpONoLZzP6uX13NOIpZ1s38oqvM5WntuDw3f1ncr9HisQ3OGt0glATIzNkXKTMn5/X7z/zTIC6X+dR9ncU0FiTW+gf6CJ09n59LmWxi5FasxML8ZsOg87ZCSkCJZFBylulaSLa2Y0NQVvMYNSaIk4/ZZM0d4aq7PM6pKztMqWGRV0WlR2SspH59cKnkwPO9rBHel3H9y+64x1V7OkrKH1kMsbxvRE3XQKmqPvSTebTfCEvjQ2hJOh+bMC+qPgceBNth8GaxqBGfVxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB7905.namprd12.prod.outlook.com (2603:10b6:510:28b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 12:21:17 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%3]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 12:21:17 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] ethtool: Fix uninitialized number of lanes
Date:   Tue,  2 May 2023 15:20:50 +0300
Message-Id: <20230502122050.917205-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0146.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::39) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB7905:EE_
X-MS-Office365-Filtering-Correlation-Id: 2350980a-a075-413f-70b6-08db4b07bac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oe5A4fXD3xWfKvNDlJggadMNSgsrO3v6DmiJByn43mP8HKHOhfzPwf1X6W/O1OblWOT135QCH2DnuRVTBrpmIjjIbLcJUcLgxSbgsJbnmCR/5HcV0/Y+6Dp0inIkPgWarYxBd7K47s7TxMkPOtmBSNQZcAq6e/IlKe8KcU+07c4Etne8FjLHInGUO93+3A7ShyEkyDKSMMHydGd98jxKsAhoe+q1HYhOyoNG8UMnsPlvTlW+3Jb6u7O/Il6RUNP2XDISC7UFJRcVkYNk5/xv2I3IOyvSVt66H0aF3MUF4pm4oNhdvmZwEn0yesl+yDVXFtfALFc6unKUoPZM0Dv1iTmTpaTtFcyS2+M0F9lf9bN79zi3hYKp0QJu09HJCapekMruc9xNXZLP+YqTWMU+zFXi4qqPHBICsba9AjEWEXSpQVzMlyn1gP9R7pTYErRjbQjOtRlcwLuwmU86dxF4x9UBvpvniOQnvEsUF3/auBJruU/IE/aKllSheBGzUYasRQJMq+RF34xfmlqWfPppZ8iVSNj+fSQPAgCVtWk4WiEMeVSRShMtw4FBxVws5/rmjXHLtIZW4OafKOgEGkwd86OxaCZPFzVRcrmvyubi3bM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199021)(316002)(6512007)(6506007)(1076003)(26005)(41300700001)(83380400001)(66476007)(2616005)(186003)(66946007)(66556008)(6486002)(4326008)(38100700002)(966005)(6666004)(6916009)(2906002)(107886003)(36756003)(86362001)(5660300002)(8936002)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?juOYO6WpcLASelqRcx7anTTcEin/C9o6q29eTVEHsA7jnRnEY5j5wrTqnLV1?=
 =?us-ascii?Q?56gvT7FO2U49Lo8uOvGMwZdF1YyJZraC5mclp5bncGBnnFCvMBhOSIn1miiw?=
 =?us-ascii?Q?PhM6B0p0r28PN67dN6kU3HZqkZvVV1kLPjcHGCSNKWKVe4BZ6N58EwXR2P29?=
 =?us-ascii?Q?ffQJpgsWGEnktz0e1iDBep3MjqazI1MoyZapPQvm/8HVx3+Vd5FqRTU6nGki?=
 =?us-ascii?Q?oPTWrSqFkGIqtXtXdqv0JIz+JhVrfW/SDGJukURTH9i+m49Q3WhdMdhlWRqF?=
 =?us-ascii?Q?xN4R4GsFUqAQIxDtlkW/CFGcmruhk9RiQxWDJF0+M81xp2n3VWW7PwMN9Etl?=
 =?us-ascii?Q?Y8txExG+SfPrC1QKUDNujoJJdusu1ik+MTEPYiv0ExiuniFT7RdhN0qiJmxE?=
 =?us-ascii?Q?/yw29ZKAzQY7s3oGTQWSdUGTg1c0bc5mAOrJ++lBh8ksIvtL56/Qe7fVFJRf?=
 =?us-ascii?Q?PyliLwOpxCylTK6gzZsayJVmSHuBjyMPbosJWZh+kJ/342Gq2DVVxdym+syQ?=
 =?us-ascii?Q?1Vi8o0BSC74+Q2nvAoP6tVpRgMCkLfgp3C/DNZfmBuUlfWIW0KgffGxko7S9?=
 =?us-ascii?Q?zlkWrHwV+pQYDn0TNHbt2+AefGKBV7CRJxN4MdfSPg7m/vag6rTxo6uEv+6l?=
 =?us-ascii?Q?hU6d5ZS1EI5LxKQQQODbDS0+suyAVpRV6XKRgFFFmXKu+ArKBJEkOw8FyMid?=
 =?us-ascii?Q?bs82JfwHQdPv+kMvpXBbrkmMz756jknkXhqxvliL5qPnSOnbIra0OXT5hoLV?=
 =?us-ascii?Q?S3sFFlpwbW7/VeLZqjRvzi+PVKSFyOx7l4rgCQxFekLhXPmSv2vqCgDtNNpc?=
 =?us-ascii?Q?jRkPRElioiwGLWzAnu1brv6Or9IVzOhY6J3MIKkZe/fRotI1Z2u34hHBVkN7?=
 =?us-ascii?Q?c4zHe9/cxm1M2r2iGb5Rf/M8iPaNeaOGqVBaeoz2l6ltDVbJCyUVumAs/mc3?=
 =?us-ascii?Q?B0uS2MqZ/G524ebwVeRev2Ru2wAEse2rDa8eO9DbT9Lu0r+E3AcExY5xt79/?=
 =?us-ascii?Q?eUr5xKqEn+JVvPytTvEp/NVddPWCE6kKvI9trVmctjWu9oT2HR1BXExapM0y?=
 =?us-ascii?Q?FhpedyCdE/c4s8FDOdZeorq9oJkRqkUHxwJrLYhH5ajWilMZAbVbeoW0ma7m?=
 =?us-ascii?Q?ezHgxAqitJbW/jE8uJlbBnA6jWffZkNjVU2+RqFNPBCcgk+AkDLBexmwlzKx?=
 =?us-ascii?Q?W8zxPOuuENhll/qp12ot7N9n/4ndQyB5HwhIC0saU47ScGms/RUUnwXCsOln?=
 =?us-ascii?Q?syWYvKDLhcK/Y2xMgMz1sROPNow9JcgXsmrZA3L5+YMkAUezMXnp1FkbSXnt?=
 =?us-ascii?Q?DVx1dSAc3Rwd+ld2NtLVyTH1n7OjpTS6GJdOWLyztGxllr9oM7nqXfb/HJgt?=
 =?us-ascii?Q?qwddC3WObVRHLf6viPtcNv+/zoVTsgyUpfVyaB0Q9XiOVoZrjTiBEdIvGgv0?=
 =?us-ascii?Q?mv1MskxzVFVKHHu9JjACiVhywEBwUAuLc/4lFfkSyKNZaJHNARc6M74YrwNe?=
 =?us-ascii?Q?iNoVxlu3FkQ6mRXN/sqzczA3JJTou3GycVMVhu7maBAgOzrZ6Ra+fg2vOVWw?=
 =?us-ascii?Q?dSvXWB7jBQTNZaynumUqEzrBKo2pJSva7LCy5Ldd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2350980a-a075-413f-70b6-08db4b07bac8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 12:21:17.4894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7ch6LhWfeC2A1GcaJMMwig1LSQwUSZKLDD8KxmMlxb1yYWGbcjAVBKY1Rs+SRHXvK0KKYSAto2YpKqG6IWtGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7905
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not possible to set the number of lanes when setting link modes
using the legacy IOCTL ethtool interface. Since 'struct
ethtool_link_ksettings' is not initialized in this path, drivers receive
an uninitialized number of lanes in 'struct
ethtool_link_ksettings::lanes'.

When this information is later queried from drivers, it results in the
ethtool code making decisions based on uninitialized memory, leading to
the following KMSAN splat [1]. In practice, this most likely only
happens with the tun driver that simply returns whatever it got in the
set operation.

As far as I can tell, this uninitialized memory is not leaked to user
space thanks to the 'ethtool_ops->cap_link_lanes_supported' check in
linkmodes_prepare_data().

Fix by initializing the structure in the IOCTL path. Did not find any
more call sites that pass an uninitialized structure when calling
'ethtool_ops::set_link_ksettings()'.

[1]
BUG: KMSAN: uninit-value in ethnl_update_linkmodes net/ethtool/linkmodes.c:273 [inline]
BUG: KMSAN: uninit-value in ethnl_set_linkmodes+0x190b/0x19d0 net/ethtool/linkmodes.c:333
 ethnl_update_linkmodes net/ethtool/linkmodes.c:273 [inline]
 ethnl_set_linkmodes+0x190b/0x19d0 net/ethtool/linkmodes.c:333
 ethnl_default_set_doit+0x88d/0xde0 net/ethtool/netlink.c:640
 genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x141a/0x14c0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2577
 genl_rcv+0x40/0x60 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 ____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
 __sys_sendmsg net/socket.c:2584 [inline]
 __do_sys_sendmsg net/socket.c:2593 [inline]
 __se_sys_sendmsg net/socket.c:2591 [inline]
 __x64_sys_sendmsg+0x36b/0x540 net/socket.c:2591
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was stored to memory at:
 tun_get_link_ksettings+0x37/0x60 drivers/net/tun.c:3544
 __ethtool_get_link_ksettings+0x17b/0x260 net/ethtool/ioctl.c:441
 ethnl_set_linkmodes+0xee/0x19d0 net/ethtool/linkmodes.c:327
 ethnl_default_set_doit+0x88d/0xde0 net/ethtool/netlink.c:640
 genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x141a/0x14c0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2577
 genl_rcv+0x40/0x60 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 ____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
 __sys_sendmsg net/socket.c:2584 [inline]
 __do_sys_sendmsg net/socket.c:2593 [inline]
 __se_sys_sendmsg net/socket.c:2591 [inline]
 __x64_sys_sendmsg+0x36b/0x540 net/socket.c:2591
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was stored to memory at:
 tun_set_link_ksettings+0x37/0x60 drivers/net/tun.c:3553
 ethtool_set_link_ksettings+0x600/0x690 net/ethtool/ioctl.c:609
 __dev_ethtool net/ethtool/ioctl.c:3024 [inline]
 dev_ethtool+0x1db9/0x2a70 net/ethtool/ioctl.c:3078
 dev_ioctl+0xb07/0x1270 net/core/dev_ioctl.c:524
 sock_do_ioctl+0x295/0x540 net/socket.c:1213
 sock_ioctl+0x729/0xd90 net/socket.c:1316
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0x222/0x400 fs/ioctl.c:856
 __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Local variable link_ksettings created at:
 ethtool_set_link_ksettings+0x54/0x690 net/ethtool/ioctl.c:577
 __dev_ethtool net/ethtool/ioctl.c:3024 [inline]
 dev_ethtool+0x1db9/0x2a70 net/ethtool/ioctl.c:3078

Fixes: 012ce4dd3102 ("ethtool: Extend link modes settings uAPI with lanes")
Reported-and-tested-by: syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com
Link: https://lore.kernel.org/netdev/0000000000004bb41105fa70f361@google.com/
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 59adc4e6e9ee..6bb778e10461 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -574,8 +574,8 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
 static int ethtool_set_link_ksettings(struct net_device *dev,
 				      void __user *useraddr)
 {
+	struct ethtool_link_ksettings link_ksettings = {};
 	int err;
-	struct ethtool_link_ksettings link_ksettings;
 
 	ASSERT_RTNL();
 
-- 
2.39.2

