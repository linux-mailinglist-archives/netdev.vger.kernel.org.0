Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEEF58D842
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 13:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242677AbiHILgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 07:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiHILf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 07:35:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7776581
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 04:35:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gH3UfL4FIlOehi+OdIAhHvs81JG3TfvzHq+AYAMzm2IJaN2wMVHNDRZc/UNQtJ/6xGBn6KI8N8r9SuVGR1Z+3KqsmAQOHcMQ96/XzhFgRiN4N/H2De7rKm0vIIr7I0UAm0dKNuvfyo/IsLntOZ8LcLeOT7vsUGuotr5LIpCMyxCnlcb+PQdDKUpSBZkpGAhpMRE6OKa6lNolBiwUy/+WR90lxLzXVKDYnwCvGGcuDhWZR3iehgDmvlX9ntR8GsEFGVSflF1UtUKCPmtqFyr73/t5q6XBc7WsMP120/mtmy+aJpv3ZmaAsQ/+0LTHZ8W0SzO1tWNVw7YcPRt/k4z2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+O3zQr9cchSYCb2L8JtTjiXD1L59WDcsuxri3XOpRWg=;
 b=enV/dLupkxwbMlOz28VsGz6cw1sVjctC1CrHHh7yFhIX8UEoJ0ywyOexEkqkUcljNLTx0VBRtevE3gwnKzKgb4QdGpbpXwYcpT1yS0RrtuwfMY8aA+bfrMAu3RT3qU4KCpsTUszhBmNloHVwHDqBsiVOp4tMur5mqnjHnY0nYmqb0XK3OtcW0gcMKnnxdlQlIDYecS2QqzOpNPsZwoFJbO7WSCfSe+RVYOPeh2T2VFYGqq6YlhatRhBIzXi90lhgFuvhR0qeSkRHn5AScP/no6g+OMwLFS5pVmFAjD70qvtSFsofZLfr5G64p4+A3B+S+XV7w68Iuf3G4Ddh3jEAKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+O3zQr9cchSYCb2L8JtTjiXD1L59WDcsuxri3XOpRWg=;
 b=QfQDtlcvT5jPB2EtKE/eR7ppPdJcSUgV7H+jKeCzRMtMIC2jmZGgpZbEpRZS7T34LXAZrBAyKoj5L8ZmByp5nj4lY+D+hyzzAW7IG6fwsvhmwtpLQSgUSfFbp4vnZ5Jh1PR/DS5wtEi6T5hMeisx9Cc/9p2rG8pSDvZzjJKyCr361iqHOCn0JdAVxpIl595iN6ho1vKsNy8dkn/6S7XHSSFDBluYelttFdAA2ZbBB8tIxkcca+quBJnfeaJy8YWQlRo1EPGAtMowt+ZX8nWJ3ykw5zpzeRSHmv1FO1KC29OSIxSGF+n7T+bRZGO6otPnJPQOHBL9zV/3ApByITQPNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by MN2PR12MB4000.namprd12.prod.outlook.com (2603:10b6:208:16b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.19; Tue, 9 Aug
 2022 11:35:20 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.014; Tue, 9 Aug 2022
 11:35:20 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] devlink: Fix use-after-free after a failed reload
Date:   Tue,  9 Aug 2022 14:35:06 +0300
Message-Id: <20220809113506.751730-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0056.eurprd02.prod.outlook.com
 (2603:10a6:802:14::27) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16cfc4d9-5ef4-443f-1f58-08da79fb3d80
X-MS-TrafficTypeDiagnostic: MN2PR12MB4000:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e6/V6Ub7sgFzG7go0jnQap6wGDT8mNK5b0HhujbgNEfx4zJWwliIF8f5BQHarbjuHecRePtni2DhJkJZkwjLmQ6qRZ9V8XkJm4fm1Rv+341pjz2PerCfYCP6vyd19IVU9Br+n+yCj9wQ0Xmt2W7FMZ+14f2FE4VFxtFdrCDHWhnXaJGRo4FAYQpSTbF03y6h8twNufaDdqwhNXJcj7H1+0tV+0HY+f6DqHKqHNkCADXUv7Op9ubeMteNSbBwpxQ1yzXvAVJvbo4mgjQjKD/CESSJUxNtcLqufRVAy/gU2EfhDo95wgpqo7sJQJKnPLR3u8e7/FZRJax69kerjWCaJ06Suo5UXaiUtsZE+2bXHYvDaC96kPtQAzdxzO8lmdcptmOhuNKdz8OTtuoTLdCrKBY1EhBHgX6cA6pxSGmidfFMWkl/0qvWf/Kk5eKlEnYHh5jCu5VWE/QMcHWZ1s7hbaoRimYzpnRcM9sU38AcFHpO+S+piK9t5LCZ5jVVA1nZ5EqFNXGG4K7FO63qIBPQpnG+B9+DZNmzdi0VCLB6z3Pos8vOWZKoRHAzfx2PZZ2ld01X74J6lqDMgaLZYwDh6X0vwmvmRl7nDAFZrUzwsngrNHWozGxusjcBpMIgCX9nRDhBx+NTe8Ae3yJY1LqSKNyKQxxucYjXg3HSAtS8WtipM4bGsWI2Wz8thq3yaYeYzz++1B9E4JCrMr6yPYUdYq9H+48f24ptTcyf8XlVWyzF2eS56VbYHjs5N3N8kzIv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(26005)(38100700002)(6666004)(6506007)(6512007)(41300700001)(6486002)(1076003)(107886003)(83380400001)(2616005)(186003)(5660300002)(8936002)(86362001)(66946007)(66476007)(66556008)(2906002)(4326008)(8676002)(36756003)(6916009)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kf6FK24/O+75LJ5jIbQA70knEWgUSFMKxN4UXMQ/uMAYtlHp2doEfDvS6Qg2?=
 =?us-ascii?Q?Vx6sQp86+rwwDf7en1uNavDyCeVVvvrS5Kn8hnxPkbAtNKNr3rMijaGp+cfr?=
 =?us-ascii?Q?LdMjvZDChctNpr4rLSKUYF2UYajyPE7dMa/WWnEf7KGNiGdMMXLUNmdu5CNe?=
 =?us-ascii?Q?KQSYalXqd5IwnLjdiGrj0MrYlPQ+Zhg6lYo20T/eKojhwrDD7AJY43fBVUkJ?=
 =?us-ascii?Q?MuMxYzX9W+kq1HdO8NvBenHWVefmUGVDNuW9ZqXGV5iaIVmmsQuUpNC7LWHL?=
 =?us-ascii?Q?Mr5Fu56cgeBBvYxV2y3jjWMGoFaTnWzNw6WWSi/6VZZ7CVtR+HO+j7VlEZ67?=
 =?us-ascii?Q?YjDI1v9HGp8r97er1RUxavNbKbR9jdX9RMYPpxa1ldkSBG6dYhJHXkdbpTw4?=
 =?us-ascii?Q?uw4eVmRuQ4h6Sa6VUVPGnPw/h4JSA8ffxhMhzgK5XSEHlRvEobVSefOYypdD?=
 =?us-ascii?Q?1jgim6iNrN1CeZVzurY8GPdhrh4a3hZ5XRza8ADfXpdn1HXSe+W0Rv8iLPJL?=
 =?us-ascii?Q?ApgDiCBL9eDgZEdCAB9Fw16kg1/1IKBIDpZ/xmpTiCi12fSLcw3gBWPWTM/t?=
 =?us-ascii?Q?vzYNXQoBY2Eyl+SLonp3xt0T+t50f8xnYRYk4xSdrtAk5O6fStqbhnCM0zQR?=
 =?us-ascii?Q?Q6UQMm3cmPwyRj4SsS0OkHCYjc2hnnSXvJM+JokNGFJgHol0RtqxRxGyXrqK?=
 =?us-ascii?Q?ZbUErmJcH3mznLB36mxZebpydNn2O6QAfHPp6T7MSYciilMd+hi1wvuMZPsP?=
 =?us-ascii?Q?FQ8mM0hh6ftfqsNI54jImV6BAN+Dw9crakFjSI3aU01sMwZrFAKiGqMJwTw3?=
 =?us-ascii?Q?yYAa8b6k9rF64MFZ3oqpyVICWS8Z6VbYzTlVVyg8MF74iUrUvhpMdzKsx3Yu?=
 =?us-ascii?Q?OvYBMrTGysOI+wm996ALIgLCMq2f+5r+hM029mpYiR6nb8e8MdAzu4xSPOdX?=
 =?us-ascii?Q?KmuHEiLz8MvoPto4tD8PH+2yy/kP1jfREq4BuO2vD9VjuvSNaUPrySx/80mZ?=
 =?us-ascii?Q?kev5hxPNyiuXZpYYCQV7FFaTwAEf8TgG3++DW4grdfCkVYZ9rLGLGhEShLp3?=
 =?us-ascii?Q?kMzu9uQnK2twtPtyaCrZztvkqxV8QS6Ek7g3VmMHcZ0HxCzwCq74y4s2ByBo?=
 =?us-ascii?Q?3SvktzKJ6lzHyFjrW8HwE5YEC8oxsdAtf0hMBLrEhbgCrktoD/BhS28+l3Uy?=
 =?us-ascii?Q?cZjY/TBqEOPbMt7UGaNSPJuOekmes5MA+ZnQInc/OIcvHn/R/4db4XYASRfl?=
 =?us-ascii?Q?8uhsDKS8Npo0jhpgDATXzrAtOIZ3nrGkxth20PC2sSFwre4k9BoFce4S00H9?=
 =?us-ascii?Q?moq+A0rFjeZSKhKzACSbX2MKd/C/M4LJvnFFKZVEFypWo0Wy1GYFMsPVDrc3?=
 =?us-ascii?Q?9rL3pKueMxdTssAJGtc7WgsTPTscAY4wfxKGK260J9m6SpuEZWFJ+91ARCv5?=
 =?us-ascii?Q?vOMOKtKgSLF2cgj6vEYH+XdFacyogQGpydE1ruvszPldEq/tgghugIIZ1m9Q?=
 =?us-ascii?Q?nMTp6fo31zSmvH4qYO8mKN+FECUjD5Mxy4D+cfoNBkvghFJBUOHQ0lH/QN8I?=
 =?us-ascii?Q?QaBV75TK8Jg61ciHXJEqXyVSrJsgiFY7dRiLmn7z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16cfc4d9-5ef4-443f-1f58-08da79fb3d80
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 11:35:20.4092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /FjvJ+4xqIMkdfbLb+Zcd493w6sAapB/nxkEGMCBW7Osb3NYmbp99AU69qPH5tjrhfKneX/5DYtbNkYXGk0omA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4000
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a failed devlink reload, devlink parameters are still registered,
which means user space can set and get their values. In the case of the
mlxsw "acl_region_rehash_interval" parameter, these operations will
trigger a use-after-free [1].

Fix this by rejecting set and get operations while in the failed state.
Return the "-EOPNOTSUPP" error code which does not abort the parameters
dump, but instead causes it to skip over the problematic parameter.

Another possible fix is to perform these checks in the mlxsw parameter
callbacks, but other drivers might be affected by the same problem and I
am not aware of scenarios where these stricter checks will cause a
regression.

[1]
mlxsw_spectrum3 0000:00:10.0: Port 125: Failed to register netdev
mlxsw_spectrum3 0000:00:10.0: Failed to create ports

==================================================================
BUG: KASAN: use-after-free in mlxsw_sp_acl_tcam_vregion_rehash_intrvl_get+0xbd/0xd0 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c:904
Read of size 4 at addr ffff8880099dcfd8 by task kworker/u4:4/777

CPU: 1 PID: 777 Comm: kworker/u4:4 Not tainted 5.19.0-rc7-custom-126601-gfe26f28c586d #1
Hardware name: QEMU MSN4700, BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x92/0xbd lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:313 [inline]
 print_report.cold+0x5e/0x5cf mm/kasan/report.c:429
 kasan_report+0xb9/0xf0 mm/kasan/report.c:491
 __asan_report_load4_noabort+0x14/0x20 mm/kasan/report_generic.c:306
 mlxsw_sp_acl_tcam_vregion_rehash_intrvl_get+0xbd/0xd0 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c:904
 mlxsw_sp_acl_region_rehash_intrvl_get+0x49/0x60 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c:1106
 mlxsw_sp_params_acl_region_rehash_intrvl_get+0x33/0x80 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:3854
 devlink_param_get net/core/devlink.c:4981 [inline]
 devlink_nl_param_fill+0x238/0x12d0 net/core/devlink.c:5089
 devlink_param_notify+0xe5/0x230 net/core/devlink.c:5168
 devlink_ns_change_notify net/core/devlink.c:4417 [inline]
 devlink_ns_change_notify net/core/devlink.c:4396 [inline]
 devlink_reload+0x15f/0x700 net/core/devlink.c:4507
 devlink_pernet_pre_exit+0x112/0x1d0 net/core/devlink.c:12272
 ops_pre_exit_list net/core/net_namespace.c:152 [inline]
 cleanup_net+0x494/0xc00 net/core/net_namespace.c:582
 process_one_work+0x9fc/0x1710 kernel/workqueue.c:2289
 worker_thread+0x675/0x10b0 kernel/workqueue.c:2436
 kthread+0x30c/0x3d0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

The buggy address belongs to the physical page:
page:ffffea0000267700 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x99dc
flags: 0x100000000000000(node=0|zone=1)
raw: 0100000000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880099dce80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880099dcf00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8880099dcf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                    ^
 ffff8880099dd000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880099dd080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================

Fixes: 98bbf70c1c41 ("mlxsw: spectrum: add "acl_region_rehash_interval" devlink param")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5da5c7cca98a..b50bcc18b8d9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5147,7 +5147,7 @@ static int devlink_param_get(struct devlink *devlink,
 			     const struct devlink_param *param,
 			     struct devlink_param_gset_ctx *ctx)
 {
-	if (!param->get)
+	if (!param->get || devlink->reload_failed)
 		return -EOPNOTSUPP;
 	return param->get(devlink, param->id, ctx);
 }
@@ -5156,7 +5156,7 @@ static int devlink_param_set(struct devlink *devlink,
 			     const struct devlink_param *param,
 			     struct devlink_param_gset_ctx *ctx)
 {
-	if (!param->set)
+	if (!param->set || devlink->reload_failed)
 		return -EOPNOTSUPP;
 	return param->set(devlink, param->id, ctx);
 }
-- 
2.37.1

