Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3943C697765
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbjBOHck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjBOHci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 02:32:38 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::61c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661FB28D1A
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:32:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Twd6DvbQNBriV8yZuyyZBobgUM8Cjtybo+h5xt6tGNeNzDhFeDjzOivvq501xQ5yAGB7N+nzoCujyzsJUM4pD9dKt83jYMpinJ/TqRQTxIwjLQLf4/vQnaBk0C+SJLsckhaaPfkWNV9rc/3MT/7CpdBrZ7Dnv0LMirVmEGhFhwcejJxgDgbFIZaV2ukgVf37z4MzrJxVI2AWS8TWYKd7eor0TdJNucAxaAFPw80QFadVJs1OMg/0NjyyTSdDRQ58oMSLT86JcmbMirvX79pKjj1KkHtIscY3nTmEuX2JcQjMiaiBhWtp4CxlJZ8BfSy6s2iWBFKIJUnuxF4Lq3cVxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIDeLojHklAseqfWP5rIPG+Ugk4kli2iObRRjxe+Qs8=;
 b=b7X+Bfun9oUUHWP8KK9neeBk8pyHGnkzYMO2pCctuqda6MIa7v8HEC5TyvimYvS5o7ZCa0ysG7ia9LHe7CX7f5JAHdg5gJs1SQXoeIoqjCi7sevT2L0oh0J94X/W6JkghO8NrbfPJvPVt0QGDwMtOt/VmCH0OTlJckYC6aODFZwjGV4fsgNBYSKMx2nIIIxiFfX0b5DC8d8qN46DZtE4mZjDexSnx4x4I43Z2aVraO66Epnh9CpqMyGv5tYfy+qfKsjd0gjhYFK3VGohYJoOhjzeJTvQbTlovqXrdtr3h/wd1d+zzAK4eDXVwzvh8yQip3meFCh3gdxar2BjInAvbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIDeLojHklAseqfWP5rIPG+Ugk4kli2iObRRjxe+Qs8=;
 b=bWo9P/kIotBCl+DyCbI/Pkc/WkAX5Ef9lRiuXv7ejS83RaQbZ2LxGRDx0T0FNJQhjgEyzwmr0gh2ZKCSqxwsZRUX4EzuRUzp4TI8Z4fFlCo1zxKRghDZCdjFweorYwt60BO0WyAwKEh4unkYcR/ZyWOt7voMomw4vCl1vZX2QiYvWHfx0QE0+OpZF0yPih39hHFCsNvYXpW7lezrt5h88Fn2nkPIslT+HzAK0zrDksVuFdBgutVoWqgnbvVeS7RagezDG0Uj+jdHlgSmpsbyZ3ExXWauNwGyvAGaVMSCThxu/y/uHQgPA+OH5oKk+LiY7NMTcme+Q+9gW+gGMascvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB7250.namprd12.prod.outlook.com (2603:10b6:806:2aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 07:32:28 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 07:32:28 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, jacob.e.keller@intel.com,
        sfr@canb.auug.org.au, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] devlink: Fix netdev notifier chain corruption
Date:   Wed, 15 Feb 2023 09:31:39 +0200
Message-Id: <20230215073139.1360108-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0005.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB7250:EE_
X-MS-Office365-Filtering-Correlation-Id: 89a89c43-8262-4720-5003-08db0f26ca48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YX8dXOBPH99vxRY7NNmH3GgG/Jl0SCaWvjuW/CCQoiVXDDlwradcKOdKFKhfN3IRH1IyX6xsgSzDdaO3OCBkdirM0kqSScZydDB1iSNL+tApTHMfFZF+PZqSDJVzjrKGaaDETuyCWd0oPPUGBA1ArXhLNZwUnZcRb6760PNVErNN87oAKk03IkcSDnFjoebQrEJtf4PP2oLmYhUVRX9Vi2BxrwewjOJRSXUbym5Hirt2kuEYbbn2roz6ltKkRNjbL8GotbjML2IbIbXxDSFTHk7hysB0gLXGU8L/pQAs5Z1qMAwiiuoFqay6JgjY2Xv/lws/73tu6khq9ujdtx3oXCGtSDrcbsEGEyHvfUDicmYtITulgyW2uxAY0Ej5I3idBKbAJhZXIfgbpszt3ipOEvmCzhNnjylNSPFq0FoQWRmlyebTVuW3AUArbNBNoj7fYYstf2Vaq7BgtDTblUtBLsRdVREKimGxx8zy6S+GwdREcp3YtWBqK3JtK5RrDTm///dF+oHZ9L24zWFJLoYAwFQ/7HQS60DrMgA1ZIgjP10SKatvYGg/gMNVB6mVz1ZYDUtuJg7zEbp8zsFucohkka9ihxpnvsKpEuUzvmWiStP+Rhxv+e+0HqjDKMiJPQwtNXShX/WyHV2R0BBWar195Sp3+/PqhM1sa9DWLgAG4PmFMQg4sDU86wGPXgIsLMNTu0+t1LeCdNK+Jfd41FAy+m/aZr1RtVTRMlfg43CGjsk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199018)(186003)(6506007)(6666004)(36756003)(1076003)(6512007)(26005)(2616005)(107886003)(83380400001)(4326008)(41300700001)(8936002)(5660300002)(66476007)(8676002)(6916009)(66556008)(66946007)(2906002)(478600001)(6486002)(316002)(38100700002)(966005)(86362001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ppmziR1ttQE15+1JELrQt/4YaPnCSYMN2QT3ixOTsiARyaj3N4XXnX0oCjUc?=
 =?us-ascii?Q?C/uhdWxkfFJE85rNAG/9veaHtfLoE4tiroi3FO5A9B6JVLm3K+nNUEfQdAzm?=
 =?us-ascii?Q?FRoKq25/HhQmuPqkJFGdpG2Av0xoW8hl/v8PAGbnTAuVT0YktOiznlFjxMK8?=
 =?us-ascii?Q?8c+wogmFcZipWVj7fGhuCk/nKpP5G9lFsPTxgB8Ebr4Pu6pkbTjVKiQkvNwl?=
 =?us-ascii?Q?ML41n/qbT7tpxDss51p9ASvB8NjOKIYVvO56jSswBDkh124k0DKnJZ29NWqN?=
 =?us-ascii?Q?5r6rTBDU2KeauoDxpYZgDCVG/XEaRMeu5M10hil33on83CgijnkPCszPUQIj?=
 =?us-ascii?Q?G9LO+94knwYHXajPc9ndOA/3/jV7+KSqYnR2Wzq+bZqYAO7qEN5BOvAnknce?=
 =?us-ascii?Q?33GjiF9/o6E9YrsCPKJ9eHNPDfxcwBDIqPhRI+TIRYZ4piBQw0tJ2oD1Lieh?=
 =?us-ascii?Q?2E4iy9609Mnid660+zvuT2sK1DeMuaaK6G50066s3zPA6fib0jFmKtl6aWB9?=
 =?us-ascii?Q?/PNOPaxDHIArVd01dOTTmUisi2WpblzgLPII9ExfVjgJhyqr8tumNUYUar4L?=
 =?us-ascii?Q?QqcijnuhDPdCr9x/mnrhidmjX1xrKDbulHnoZIXvBWDXjVGS26MJDD8I73Sr?=
 =?us-ascii?Q?JlmKN4wFuagOvRodHo0IwTmre7dMC5QCVPoqqf9oNPFjmmLYZrAUYMFeay6C?=
 =?us-ascii?Q?tfWXk/ifo5e+D3mnT9DdWqQOuuvpmrgJzjNwcRq9rbepjlXG4AP12Fz5C8iQ?=
 =?us-ascii?Q?sRc64zZlqyqXfp4vWm043bZg8eyD60qDqQxY4GE/W8i69bH7/KO/fBe+HEJl?=
 =?us-ascii?Q?MdjxkpN06YhZC6BYM2nikpXwLpn4OmItzuvYOExCOGgbX4TPlsLM2NytY0M0?=
 =?us-ascii?Q?Zo2f7RS4qsaqXFZFQRSsJsPBobR6h5mEweYI8kgcmDdARpwgMJZjh48rBvXc?=
 =?us-ascii?Q?AEtBbzRqEbqGI+PSef66noWSBoX/699LPnUEZxVho2sAfNRZcVsxrgNrWA85?=
 =?us-ascii?Q?W7/chfjnWLWyBdbtDUqt3xTSTbXVNl4HorCHP32pNXZ6vdAd5/uOYfg3WPr2?=
 =?us-ascii?Q?dFHnlysel+oXT0G9Lh7PGbU2CWxL6OA6zlKfdGv8Jz0WI+/Q2mnIcMeLJRXD?=
 =?us-ascii?Q?Nu/woFuyRK6JPPdHbMTOZvtzI61KxerwQeQZcmTcZ2V5/XoMJMKKSMDJfhba?=
 =?us-ascii?Q?v5EilySrXShVx090RqmD/vKyaT8jFc+qz9Cx+9sm+nhLnXtzwoVyS7cmIyTi?=
 =?us-ascii?Q?ODRbjds+o/yr8tbltNZmlyXrD/Jyq3f1mDe3s7lF8ZVSqXKPzGDj9zjHPffK?=
 =?us-ascii?Q?yrVH2HAEIohkBlI6mvJdPotsJJixZdu+r50MSWEx1cc1/oPGMJ58vBZVEasA?=
 =?us-ascii?Q?jJKqf1mN3gO4epI5J/gd1CB+AZMuxfT1lK7qyFMvQBD8nFN2z9o55udyOi1q?=
 =?us-ascii?Q?sOp5TkUpak2iinYl6lTvQ/NaMdIQw/dPJFBPtH4MXvb+tCYO1zreOBhAhOHt?=
 =?us-ascii?Q?jmZRcUIJffOCWG18SM3qGD6gmhS1SDZpt3KbPmARuPSLEBCp9hwkikS434nR?=
 =?us-ascii?Q?aK1oZy64agXdk8uurUwD4vlINL9mSQygCCaAibbD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a89c43-8262-4720-5003-08db0f26ca48
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 07:32:28.0905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QkT1rLKGaGQIUFdrHPgi03+s2dFeB/Pp0d116/h2Esa1OKxprbUs8SK0F+S5stxSg+IjAToX5Po27x1NXvsuzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7250
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cited commit changed devlink to register its netdev notifier block on
the global netdev notifier chain instead of on the per network namespace
one.

However, when changing the network namespace of the devlink instance,
devlink still tries to unregister its notifier block from the chain of
the old namespace and register it on the chain of the new namespace.
This results in corruption of the notifier chains, as the same notifier
block is registered on two different chains: The global one and the per
network namespace one. In turn, this causes other problems such as the
inability to dismantle namespaces due to netdev reference count issues.

Fix by preventing devlink from moving its notifier block between
namespaces.

Reproducer:

 # echo "10 1" > /sys/bus/netdevsim/new_device
 # ip netns add test123
 # devlink dev reload netdevsim/netdevsim10 netns test123
 # ip netns del test123
 [   71.935619] unregister_netdevice: waiting for lo to become free. Usage count = 2
 [   71.938348] leaked reference.

Fixes: 565b4824c39f ("devlink: change port event netdev notifier from per-net to global")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
If the patch is accepted, it is going to conflict when you merge net
into net-next. Resolution can be found here:
https://github.com/idosch/linux/commit/405de3d68566fb0cb640e7d55dc0f1d9028597cb.patch
---
 include/linux/netdevice.h | 2 --
 net/core/dev.c            | 8 --------
 net/core/devlink.c        | 5 +----
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index aad12a179e54..e6e02184c25a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2839,8 +2839,6 @@ int unregister_netdevice_notifier(struct notifier_block *nb);
 int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb);
 int unregister_netdevice_notifier_net(struct net *net,
 				      struct notifier_block *nb);
-void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
-				 struct notifier_block *nb);
 int register_netdevice_notifier_dev_net(struct net_device *dev,
 					struct notifier_block *nb,
 					struct netdev_net_notifier *nn);
diff --git a/net/core/dev.c b/net/core/dev.c
index ea0a7bac1e5c..f23e287602b7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1869,14 +1869,6 @@ static void __move_netdevice_notifier_net(struct net *src_net,
 	__register_netdevice_notifier_net(dst_net, nb, true);
 }
 
-void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
-				 struct notifier_block *nb)
-{
-	rtnl_lock();
-	__move_netdevice_notifier_net(src_net, dst_net, nb);
-	rtnl_unlock();
-}
-
 int register_netdevice_notifier_dev_net(struct net_device *dev,
 					struct notifier_block *nb,
 					struct netdev_net_notifier *nn)
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 909a10e4b0dd..0bfc144df8b9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4742,11 +4742,8 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	if (err)
 		return err;
 
-	if (dest_net && !net_eq(dest_net, curr_net)) {
-		move_netdevice_notifier_net(curr_net, dest_net,
-					    &devlink->netdevice_nb);
+	if (dest_net && !net_eq(dest_net, curr_net))
 		write_pnet(&devlink->_net, dest_net);
-	}
 
 	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
 	devlink_reload_failed_set(devlink, !!err);
-- 
2.37.3

