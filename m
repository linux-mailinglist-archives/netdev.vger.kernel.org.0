Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311D7673084
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjASEq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjASEpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:45:51 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C9F3B0ED;
        Wed, 18 Jan 2023 20:41:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANizqg4uYYqOfxFoWPAqYFLK93a0zWXgRtuQmSVoVdcXS+bdQPnWNRSjIcY5dgBCpe62DjG46KxUJcF+7D+HMhOOyZCPl+kI+ie9fFBXpqftypYLr4MUz0+5kQHBwn8mGXns9ejnh/N3MLM9+w2oTnBArsFsNGIF58hOGEQIV9ejOV1aqP+nXogemiwo6x8vMtWUOCkV0S71zwE+gYhpWhwJkhraX2clGCRvQ7PtcuhD+8OrR4QphHV20CBOPXSgQS5gSfwGaJhEIM45x61pkL1Jui50v4kqA4FoWY9DadX1+4afv9f8u4KgfVOniRKEDScjOFyeDKmyy3no7x+IdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sbL1sYMpetymHB/72RunSmVnR3tIgNVfByr1LjXh/i8=;
 b=euxZKYfzIkY6g2kb4cOOVAt64p48vJnUlu1f0hNqnT0jfn3lXyuD2ryUzU8vlSjYsempe/nyJf3MeSGz6GlJvw45pxi/AJVTb50GcEeLjZO7awqgSRzyQhX17789Rg2Dza+t86TR3Mb03h7OWfMN3SoWe9zqyflLxyKip1awWRGvnPhU/R/qXFXlX8E0X1RCgK8QjvWsBLnVTy9/3KTxZP8SSTTBhuL29y+T3m+e3qYbHQpkME+Auh98yL8rAwEYL67BU+X1Ov9Y+iKhCkmHh489q8xP7Ed9VXH38jS95pjZID7UlP78WuQPG+ZbwdnAG+jHbGODtYJ6Ln1FNLiOtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbL1sYMpetymHB/72RunSmVnR3tIgNVfByr1LjXh/i8=;
 b=MPAlOlAQwhBfj4LJf4m2vjFIVY1bzvmRLCW3lQ2craINOnm4O7QsAujbcOTMhsKiSQD18BF2Bepq3Fzz6oJwMU7hvgRN5yGQ8yaf95E/Ekpe7MRQ1mU7yvtF156Ty02gwyZMO+t+HB9iqFaN3MOxuHlW6nFs8mbSiGMg2mmxYKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by GV1PR04MB9214.eurprd04.prod.outlook.com (2603:10a6:150:29::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 04:40:27 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%5]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 04:40:26 +0000
From:   wei.fang@nxp.com
To:     shenwei.wang@nxp.com, xiaoning.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Cc:     linux-imx@nxp.com, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: fec: Use page_pool_put_full_page when freeing rx buffers
Date:   Thu, 19 Jan 2023 12:37:47 +0800
Message-Id: <20230119043747.943452-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::16) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8106:EE_|GV1PR04MB9214:EE_
X-MS-Office365-Filtering-Correlation-Id: b3a87517-db33-4e01-8877-08daf9d7490d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Ex5OBySP78wsP5sQ1Q7db3j//xlBHWU4hhsOz92TRiX8nulOHVXZ64i+Kj1Qu7NDORib8H7JXzd3Uc4vN7h8ndOnJqlpbLnIBOGXjBIS1q6hrkIStMsYXkQVIks9EV2FJBm02k/wT9H9zAUTwbF2MBVefR0CmxWIadDxfN1dCPqu7v3SKxGMB2u569rysQPPWTy/c4fRq0gh/9E6JDJNK2ZNy8lSuWyZLszVlM3xyA97Uuco8AZq3mEIW/Zk/1L5UiVDFBIemzqGZ6YwwtaKNNVneeCkHyhL2UTR0x+nCem2hIGgkQgJEvdxoW+1D9VXLSvPGhOuduq5YFoTgwVjVtltPqQ+ofaX/7q7GdxVHUL1vQC7yHPMCrvg3uNvjVY9z86uyDwLE0AF4GYG9VeEZZZvLrLPIiwbBx5cZMMAQx3ARcrID8/WEPpdqsN37/LV/5kP4HmfANQiVCXzBfyKOTBLU052c9zHFaBrAyWRXh3BINB8aKN6T460nQyEb0fnlr4AenThblvczH2S+yixWvsC6QAIYSd9qigEIxYWzC/rLMNLmfhCROWTj/ssHngmsJCNcU7HAnJo68K+Tkbv/KvfWl2UKcjRchkeBwqEZkXu/GGHKLw6Hwb2cZllNd18UDo/E7fYV3KOPkgwn9WD3oGko3zxwuIGUM8XywILS/XEI284DQhA1JprIOj7FHdLYRcxSrrpLZ9WI/u7O3ZtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199015)(66476007)(38350700002)(38100700002)(40140700001)(86362001)(8936002)(5660300002)(2906002)(30864003)(66946007)(66556008)(4326008)(8676002)(41300700001)(1076003)(26005)(2616005)(186003)(6512007)(9686003)(83380400001)(52116002)(316002)(6666004)(478600001)(6486002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3d4Sq9PBUroJt14t//xBpUQvjDpekvb6JWF4d7j31iyAzf8rA6WlVmt479eT?=
 =?us-ascii?Q?RIK8uk1ABm5M5GnDJl15DQcysf9G0QN7LthNX7rX3KcyLjRgmKh5laoVzzdl?=
 =?us-ascii?Q?i0CJu7IvY5/OU2MBsc18e+FGUr3sXoJY2tDaCEimjEDZe4fTBgLW6ucOgr22?=
 =?us-ascii?Q?48QYEorzqf9ySezV1XajCKsvOaQLr4JV2vHfVjKr7XwhSMoGNfw1Wq94+2T3?=
 =?us-ascii?Q?4qAEmZnadw3den3ELlaObDPg16aWdPXn0wVLLRlZl3Sw+8E7CUkyc+G4D2lv?=
 =?us-ascii?Q?WycdCT6aPj0bZtt+0J3M3urFPTST8gLgNPGUeyVJjRzo+K2z3kwdyvDBvYbE?=
 =?us-ascii?Q?L9bOy3EmndVB+HroSDFRM1G57T77eHXBe3bGs+XRNAgoG5w7nPhRsYD+m/tZ?=
 =?us-ascii?Q?WkzhWElSI1ajiVvVkvZbJJlI1sP95JCZjrV/HKDkImKnt0ZfB3pA+kkzQEWS?=
 =?us-ascii?Q?8SfE8ubNTnd6DMzEwlSUAsJz51bnVZUl0EwmT78ELxHcDBKirdQUIlNQkNb5?=
 =?us-ascii?Q?E877k+oWRArLa7Y3DJcO5eSgI2UyRmJG9HBy132vwYpcpLMm6P8lswFvEe9v?=
 =?us-ascii?Q?/UQZEfxKpCxcjx+5G8Pm2KqbKfVXrAUbM6B+lfFjYjmF7OHzfdGf3e+eYSOB?=
 =?us-ascii?Q?A/KsGaL+eL/vmC5z3E1bErayjGMJs9VEJ3PYk3BwbLb29ER9zqkEz5ucxXZ4?=
 =?us-ascii?Q?gCgvJj5JllyOh7MVZHkcPJwg4QVzBCdFmZHiD7TpFRzxzI/iEx5lvC35ZoPt?=
 =?us-ascii?Q?4Dc75LwFxV2woNBWWEDj4mvUos056sLWdfEm6bwcVy2L/rmUEyP/FVG2V4Ba?=
 =?us-ascii?Q?lDrIAhiPw8+d3VOnieDZAjChiJEYl6vjwhuEOLwZkOxvBhNPExSaTJ5QI8t/?=
 =?us-ascii?Q?9HPV/jPvu3Pc8+47KrpUOFdrQrssi6Iz35wzRKf4fLI6LHiBz7vI1CwlFJ1+?=
 =?us-ascii?Q?I2wayO4Xhfh6g+1AKbxjka2NhIOtC01ehiLMlowp3ujNt+01SbPRUou+SBF3?=
 =?us-ascii?Q?nVF5UKzz055KajZBpRsNq1b/2QdW+dKksXfgHcxEoI6JxTaXkn9DsY2XaBKg?=
 =?us-ascii?Q?VfQB/ZYrMb56AIeTxaVtYWoZx0Y7f6tB1iB/+/mBaW1ciHvHto6Mz54lTlnU?=
 =?us-ascii?Q?TN+MrhYESexLEA0UwpXbxK/KzqopwWHEqdQhDp8FBeCRxM8Zi+7YOJT6AT0B?=
 =?us-ascii?Q?w2hQeXIfpL01or55SsaqS16ptxKVLHd2dRfWIHM8sacz6XEFIjoPQ+O8/XEw?=
 =?us-ascii?Q?Hyvfe09373hkKhtTlLGVO4gopgNs5SfTYZSjJOa42a7IjlHymbEJM3kMki6y?=
 =?us-ascii?Q?6V6sShprxz+nRttSJ0UQqfhsh4sxJqc4zzhy2MQVwvz4hL2P2eIaxAi0bs5W?=
 =?us-ascii?Q?mblG8ieZOWcmyRxLnEPMpENj3ZtXc3hVkSuD/Bg0OLDyzRacgwNvTLmhps71?=
 =?us-ascii?Q?EMUkolc5um2+f6tKg6lcVqWRDumREgS7/s/7jF3Ak/OYHpUkLakTtjKGXzI4?=
 =?us-ascii?Q?I0ff7VThxwJsBEgXRs2N3A4v/hAqVNx2ZVTvhPhI1F6k1AeAxRHisXOL/i/d?=
 =?us-ascii?Q?scXeof6G2BMuU7+VMrh9keSW0zWcFVayzrYEgbdn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a87517-db33-4e01-8877-08daf9d7490d
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 04:40:26.8535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugmXRqfhViWMAEjI8VkReQAvj0xDiT7ze2Ve2YxaQpYpRLMtzktu43yhhTVRwLLOr38x5P71mCSzYLWAshxapA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9214
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The page_pool_release_page was used when freeing rx buffers, and this
function just unmaps the page (if mapped) and does not recycle the page.
So after hundreds of down/up the eth0, the system will out of memory.
For more details, please refer to the following reproduce steps and
bug logs. To solve this issue and refer to the doc of page pool, the
page_pool_put_full_page should be used to replace page_pool_release_page.
Because this API will try to recycle the page if the page refcnt equal to
1. After testing 20000 times, the issue can not be reproduced anymore
(about testing 391 times the issue will occur on i.MX8MN-EVK before).

Reproduce steps:
Create the test script and run the script. The script content is as
follows:
LOOPS=20000
i=1
while [ $i -le $LOOPS ]
do
    echo "TINFO:ENET $curface up and down test $i times"
    org_macaddr=$(cat /sys/class/net/eth0/address)
    ifconfig eth0 down
    ifconfig eth0  hw ether $org_macaddr up
    i=$(expr $i + 1)
done
sleep 5
if cat /sys/class/net/eth0/operstate | grep 'up';then
    echo "TEST PASS"
else
    echo "TEST FAIL"
fi

Bug detail logs:
TINFO:ENET  up and down test 391 times
[  850.471205] Qualcomm Atheros AR8031/AR8033 30be0000.ethernet-1:00: attached PHY driver (mii_bus:phy_addr=30be0000.ethernet-1:00, irq=POLL)
[  853.535318] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  853.541694] fec 30be0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[  870.590531] page_pool_release_retry() stalled pool shutdown 199 inflight 60 sec
[  931.006557] page_pool_release_retry() stalled pool shutdown 199 inflight 120 sec
TINFO:ENET  up and down test 392 times
[  991.426544] page_pool_release_retry() stalled pool shutdown 192 inflight 181 sec
[ 1051.838531] page_pool_release_retry() stalled pool shutdown 170 inflight 241 sec
[ 1093.751217] Qualcomm Atheros AR8031/AR8033 30be0000.ethernet-1:00: attached PHY driver (mii_bus:phy_addr=30be0000.ethernet-1:00, irq=POLL)
[ 1096.446520] page_pool_release_retry() stalled pool shutdown 308 inflight 60 sec
[ 1096.831245] fec 30be0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[ 1096.839092] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[ 1112.254526] page_pool_release_retry() stalled pool shutdown 103 inflight 302 sec
[ 1156.862533] page_pool_release_retry() stalled pool shutdown 308 inflight 120 sec
[ 1172.674516] page_pool_release_retry() stalled pool shutdown 103 inflight 362 sec
[ 1217.278532] page_pool_release_retry() stalled pool shutdown 308 inflight 181 sec
TINFO:ENET  up and down test 393 times
[ 1233.086535] page_pool_release_retry() stalled pool shutdown 103 inflight 422 sec
[ 1277.698513] page_pool_release_retry() stalled pool shutdown 308 inflight 241 sec
[ 1293.502525] page_pool_release_retry() stalled pool shutdown 86 inflight 483 sec
[ 1338.110518] page_pool_release_retry() stalled pool shutdown 308 inflight 302 sec
[ 1353.918540] page_pool_release_retry() stalled pool shutdown 32 inflight 543 sec
[ 1361.179205] Qualcomm Atheros AR8031/AR8033 30be0000.ethernet-1:00: attached PHY driver (mii_bus:phy_addr=30be0000.ethernet-1:00, irq=POLL)
[ 1364.255298] fec 30be0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[ 1364.263189] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[ 1371.998532] page_pool_release_retry() stalled pool shutdown 310 inflight 60 sec
[ 1398.530542] page_pool_release_retry() stalled pool shutdown 308 inflight 362 sec
[ 1414.334539] page_pool_release_retry() stalled pool shutdown 16 inflight 604 sec
[ 1432.414520] page_pool_release_retry() stalled pool shutdown 310 inflight 120 sec
[ 1458.942523] page_pool_release_retry() stalled pool shutdown 308 inflight 422 sec
[ 1474.750521] page_pool_release_retry() stalled pool shutdown 16 inflight 664 sec
TINFO:ENET  up and down test 394 times
[ 1492.830522] page_pool_release_retry() stalled pool shutdown 310 inflight 181 sec
[ 1519.358519] page_pool_release_retry() stalled pool shutdown 308 inflight 483 sec
[ 1535.166545] page_pool_release_retry() stalled pool shutdown 2 inflight 724 sec
[ 1537.090278] eth_test2.sh invoked oom-killer: gfp_mask=0x400dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO), order=0, oom_score_adj=0
[ 1537.101192] CPU: 3 PID: 2379 Comm: eth_test2.sh Tainted: G         C         6.1.1+g56321e101aca #1
[ 1537.110249] Hardware name: NXP i.MX8MNano EVK board (DT)
[ 1537.115561] Call trace:
[ 1537.118005]  dump_backtrace.part.0+0xe0/0xf0
[ 1537.122289]  show_stack+0x18/0x40
[ 1537.125608]  dump_stack_lvl+0x64/0x80
[ 1537.129276]  dump_stack+0x18/0x34
[ 1537.132592]  dump_header+0x44/0x208
[ 1537.136083]  oom_kill_process+0x2b4/0x2c0
[ 1537.140097]  out_of_memory+0xe4/0x594
[ 1537.143766]  __alloc_pages+0xb68/0xd00
[ 1537.147521]  alloc_pages+0xac/0x160
[ 1537.151013]  __get_free_pages+0x14/0x40
[ 1537.154851]  pgd_alloc+0x1c/0x30
[ 1537.158082]  mm_init+0xf8/0x1d0
[ 1537.161228]  mm_alloc+0x48/0x60
[ 1537.164368]  alloc_bprm+0x7c/0x240
[ 1537.167777]  do_execveat_common.isra.0+0x70/0x240
[ 1537.172486]  __arm64_sys_execve+0x40/0x54
[ 1537.176502]  invoke_syscall+0x48/0x114
[ 1537.180255]  el0_svc_common.constprop.0+0xcc/0xec
[ 1537.184964]  do_el0_svc+0x2c/0xd0
[ 1537.188280]  el0_svc+0x2c/0x84
[ 1537.191340]  el0t_64_sync_handler+0xf4/0x120
[ 1537.195613]  el0t_64_sync+0x18c/0x190
[ 1537.199334] Mem-Info:
[ 1537.201620] active_anon:342 inactive_anon:10343 isolated_anon:0
[ 1537.201620]  active_file:54 inactive_file:112 isolated_file:0
[ 1537.201620]  unevictable:0 dirty:0 writeback:0
[ 1537.201620]  slab_reclaimable:2620 slab_unreclaimable:7076
[ 1537.201620]  mapped:1489 shmem:2473 pagetables:466
[ 1537.201620]  sec_pagetables:0 bounce:0
[ 1537.201620]  kernel_misc_reclaimable:0
[ 1537.201620]  free:136672 free_pcp:96 free_cma:129241
[ 1537.240419] Node 0 active_anon:1368kB inactive_anon:41372kB active_file:216kB inactive_file:5052kB unevictable:0kB isolated(anon):0kB isolated(file):0kB s
[ 1537.271422] Node 0 DMA free:541636kB boost:0kB min:30000kB low:37500kB high:45000kB reserved_highatomic:0KB active_anon:1368kB inactive_anon:41372kB actiB
[ 1537.300219] lowmem_reserve[]: 0 0 0 0
[ 1537.303929] Node 0 DMA: 1015*4kB (UMEC) 743*8kB (UMEC) 417*16kB (UMEC) 235*32kB (UMEC) 116*64kB (UMEC) 25*128kB (UMEC) 4*256kB (UC) 2*512kB (UC) 0*1024kBB
[ 1537.323938] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1537.332708] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=32768kB
[ 1537.341292] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1537.349776] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=64kB
[ 1537.358087] 2939 total pagecache pages
[ 1537.361876] 0 pages in swap cache
[ 1537.365229] Free swap  = 0kB
[ 1537.368147] Total swap = 0kB
[ 1537.371065] 516096 pages RAM
[ 1537.373959] 0 pages HighMem/MovableOnly
[ 1537.377834] 17302 pages reserved
[ 1537.381103] 163840 pages cma reserved
[ 1537.384809] 0 pages hwpoisoned
[ 1537.387902] Tasks state (memory values in pages):
[ 1537.392652] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
[ 1537.401356] [    201]   993   201     1130       72    45056        0             0 rpcbind
[ 1537.409772] [    202]     0   202     4529     1640    77824        0          -250 systemd-journal
[ 1537.418861] [    222]     0   222     4691      801    69632        0         -1000 systemd-udevd
[ 1537.427787] [    248]   994   248    20914      130    65536        0             0 systemd-timesyn
[ 1537.436884] [    497]     0   497      620       31    49152        0             0 atd
[ 1537.444938] [    500]     0   500      854       77    53248        0             0 crond
[ 1537.453165] [    503]   997   503     1470      160    49152        0          -900 dbus-daemon
[ 1537.461908] [    505]     0   505      633       24    40960        0             0 firmwared
[ 1537.470491] [    513]     0   513     2507      180    61440        0             0 ofonod
[ 1537.478800] [    514]   990   514    69640      137    81920        0             0 parsec
[ 1537.487120] [    533]     0   533      599       39    40960        0             0 syslogd
[ 1537.495518] [    534]     0   534     4546      148    65536        0             0 systemd-logind
[ 1537.504560] [    535]     0   535      690       24    45056        0             0 tee-supplicant
[ 1537.513564] [    540]   996   540     2769      168    61440        0             0 systemd-network
[ 1537.522680] [    566]     0   566     3878      228    77824        0             0 connmand
[ 1537.531168] [    645]   998   645     1538      133    57344        0             0 avahi-daemon
[ 1537.540004] [    646]   998   646     1461       64    57344        0             0 avahi-daemon
[ 1537.548846] [    648]   992   648      781       41    45056        0             0 rpc.statd
[ 1537.557415] [    650] 64371   650      590       23    45056        0             0 ninfod
[ 1537.565754] [    653] 61563   653      555       24    45056        0             0 rdisc
[ 1537.573971] [    655]     0   655   374569     2999   290816        0          -999 containerd
[ 1537.582621] [    658]     0   658     1311       20    49152        0             0 agetty
[ 1537.590922] [    663]     0   663     1529       97    49152        0             0 login
[ 1537.599138] [    666]     0   666     3430      202    69632        0             0 wpa_supplicant
[ 1537.608147] [    667]     0   667     2344       96    61440        0             0 systemd-userdbd
[ 1537.617240] [    677]     0   677     2964      314    65536        0           100 systemd
[ 1537.625651] [    679]     0   679     3720      646    73728        0           100 (sd-pam)
[ 1537.634138] [    687]     0   687     1289      403    45056        0             0 sh
[ 1537.642108] [    789]     0   789      970       93    45056        0             0 eth_test2.sh
[ 1537.650955] [   2355]     0  2355     2346       94    61440        0             0 systemd-userwor
[ 1537.660046] [   2356]     0  2356     2346       94    61440        0             0 systemd-userwor
[ 1537.669137] [   2358]     0  2358     2346       95    57344        0             0 systemd-userwor
[ 1537.678258] [   2379]     0  2379      970       93    45056        0             0 eth_test2.sh
[ 1537.687098] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/user.slice/user-0.slice/user@0.service,tas0
[ 1537.703009] Out of memory: Killed process 679 ((sd-pam)) total-vm:14880kB, anon-rss:2584kB, file-rss:0kB, shmem-rss:0kB, UID:0 pgtables:72kB oom_score_ad0
[ 1553.246526] page_pool_release_retry() stalled pool shutdown 310 inflight 241 sec

Fixes: 95698ff6177b ("net: fec: using page pool to manage RX buffers")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: shenwei wang <Shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 644f3c963730..2341597408d1 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3191,7 +3191,7 @@ static void fec_enet_free_buffers(struct net_device *ndev)
 	for (q = 0; q < fep->num_rx_queues; q++) {
 		rxq = fep->rx_queue[q];
 		for (i = 0; i < rxq->bd.ring_size; i++)
-			page_pool_release_page(rxq->page_pool, rxq->rx_skb_info[i].page);
+			page_pool_put_full_page(rxq->page_pool, rxq->rx_skb_info[i].page, false);
 
 		for (i = 0; i < XDP_STATS_TOTAL; i++)
 			rxq->stats[i] = 0;
-- 
2.25.1

