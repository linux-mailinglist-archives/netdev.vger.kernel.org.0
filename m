Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18DF05B8275
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 09:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiINH4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 03:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiINHz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 03:55:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F223513CD8
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 00:54:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EL51lf1QRrVjxGe9ktNuRvIPqhMOoC/BWim9Gje88nCNtc590TFSvCpoeCjHqWUpvrv4v6Z+h7Bj+7mYAUn3HnW9erHKt4pKvcst+v7K1bYYJfYxS7bjyNwVR1dEy57k/uWFALcjA2ML7mo0tKJI0QDr+4ZmyfrscsSzlWYtm+BxJgb0kpnN7H8nDKADL1ZuOPK8pPD4cUpQ0qRkUbNivtar5o7zwBEnWL8Tj8CNkIJvZ0XikpB7DJKodBUoUldwhEumKmM1zVvr9y7G/1brqAM2RTpruqtEAP6EC3RbIYYQdsNvR+jLKNiS3ixS/kkupAZAL0xa1DQFYiAT6W1kWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u+Q7t/CpjShioRT/sHBAhwe6yYUPKSVQ42d/pXmlpMM=;
 b=NAFZO0z6HVEfOIqTUzN9gkHUL+W+DncMeUXuo3R44N6b1KL2QeyjOMc94p7/Jx4D1MOfzrOnWRxKhhK6CxYtaosELMaD4odQSI78UqPbFz0U0bPLYsHjdrcXDg7B2y0NdwEE/OJQFyzUEJ3LbpgmT9rPNA3dcns/fJ2rIwj6DlzBOmYpTQq0CU/XmdHqgmhBw1RPcBZW0YxsE1niJvoSisVWS53D8zFXgzI85PQgAthyIEfXZkNk2qUMvV7afsv3PGLBhIxEHOzwcl1lunzDQi5lu4WRghusY8VVyQswcqX/ajqH1al5f24xj13phlx25mveFdfy1NaD3pbCAVfHag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+Q7t/CpjShioRT/sHBAhwe6yYUPKSVQ42d/pXmlpMM=;
 b=K6EUkoCmZIgOz24KGubm9eQfrrclmUsevosIFnck6FFUxRl4DK/WyV/Yx5T/6KOTKtjyKmyPHpWAu2He/VnH8cR73GDEk1LQKtPZujl6Vt+VJmN6f8aVPxXaaA/CEQxc4slgZh5z13BgahNiuJpD+cF/PKtogiD5WozUHo7AOr2j9byewo/3zW84i7yFXkoJlPG0moOvDj7N9YXF7xzEBIkGXT0GqMF5NyOXXApv0EcBlO81eWb+hqXuZsREk0Yr1+4yrh2MHGX66hDsGyx6sPoIMuH1IgeaZtrCTakL2TX2FywT/rrSWhqBVYPiCzbc6mMSZsmVvaJiO/owyRAqsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5454.namprd12.prod.outlook.com (2603:10b6:a03:304::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 07:54:57 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b%3]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 07:54:57 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] ipmr: Always call ip{,6}_mr_forward() from RCU read-side critical section
Date:   Wed, 14 Sep 2022 10:53:38 +0300
Message-Id: <20220914075339.4074096-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220914075339.4074096-1-idosch@nvidia.com>
References: <20220914075339.4074096-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0214.eurprd07.prod.outlook.com
 (2603:10a6:802:58::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: dc2585a6-8fd5-4cbf-ef47-08da96266afd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxAK9uRT2pubakvSY3q4fhzC995JRbxJzPkBYcf3CFGKWAyqhdtskWPg16nRNr0EEu2086jjZnqsus/SueEAVmTJg7jmb3E9mS86d2cCkN5bV/XrRsMlpcyPMxz37EQSE9IzK+Y7P5qYvpcq5eil4VeaYnJqQM3GgqxtEengwd45B/JxNXtgBXix/rYHhrBlMWocost2jkZcoPWrnEBgGReOFwtLN7PJvlB+XebRKRNN/M9xZxxHSo02K/IyfpCFrDqeBc2Z4mzE6eJ6JXDf8MpBKoJBJaummTgC3FAFM6lo43bZ9l7c/e9O0+bLDmIufnAKgBsgASSdUSFfyJdUzHXj6YCR+p1LsFJbY8f8iEP6g+r84CLDJt7gAEDRtLmQcmfMVt8LlTmrLcq9qzQ42Q0dHfUPRKFNPIDuyug1RBy6ospbQSG5AhyaJ/KN/AS43yYHVwaYMtKWoFcmJU7QxXC3tz/mKnlOxNT0txmselTQI6isOqbW9GRcXrPG4M8nqHb7d6algkgHP2x7RSC0OQ7WQ1viS3CKlPk1q2aeGxulKDNNSyW3UmL/GP1W9P+9LpMm7ie1mFpe6zG819uFY4+dC9WibPJIzKA5knsNEQ05eYmTLNX12uZsh21w/b61edovuPmu7UDSbKsDfSWqZ5lSS9Gt/6z9gArSq/6RYp22GZDlOXQW6FJmN471EFYFz3rRX+QZik6q0ZRoycxrVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(86362001)(38100700002)(6666004)(41300700001)(107886003)(66946007)(66476007)(8936002)(4326008)(8676002)(66556008)(26005)(5660300002)(6506007)(6486002)(478600001)(6916009)(83380400001)(2906002)(316002)(2616005)(6512007)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p0ad94urolDRuiW8BQo1qhmS9h/PIAd1L+QaQ1C5G5wXc5tHQT/2IOyZhCYI?=
 =?us-ascii?Q?ekREsmXlnx5o30C5vuwLr6JVFsb3oQOqDKqT27Yu9RgGJN4D4UfU4BPefE0O?=
 =?us-ascii?Q?e0NPWzftjzuYeFUWykR85A3QzCX/QjnSwhVtFkgAhZtkHfC4Ykn4LNPt8hD+?=
 =?us-ascii?Q?cW8CSOGGFCeBtns5ojKgLuS2il2g1s+46qo5rQ2T/GeR9bwWNeOWQJ2DKOcj?=
 =?us-ascii?Q?QsAKghOiZ2iZD7ymD2lKx72/bGxFW7MtJczY84gvYK34fZwVgHBfumPv5Pz5?=
 =?us-ascii?Q?6OzR3qNqTMe3S8cemheFc7t5D3H5g4fZFGyUVd7PZZGtzNEVWO+QGFXiGs2Z?=
 =?us-ascii?Q?kS+JPgwsQdK3r7/6jeUDVEWkxYQgKE+OdkTCICF9+HA1nlplWXovGqJFdt3/?=
 =?us-ascii?Q?UKCV/uWCGeM4QFLhEzMDkxhsPL3urNoIDRSeEu/BxHiRvedBmhthY9m8Wh9n?=
 =?us-ascii?Q?R5BNyHCck8cq0EQBIZ+0wpqY7ExuXwIiDJulJPEDdwm8clqdSHSWFgX8XkhJ?=
 =?us-ascii?Q?Nq0Cn48nE/LFiKoAoehCypRLPZTgmOxqe/OZpTrobQLD0kv3tAt+2YUjbAJ6?=
 =?us-ascii?Q?1aW0efNXOc4lfcXb8SHox84V/w8QK+FbzREh/E4psMktCiEtV+pbhRHk9ApC?=
 =?us-ascii?Q?JAVDUAzXPShLpyFe9IKiQiX6yhMzBRmJetfhaWqP7PLhU4S3BA2MsbLKpQPW?=
 =?us-ascii?Q?JGkCPOXMrtf6o6ghAcsrMOvwsDCEV05rYDI+JO+wPPZ6sMmt+CwhfFyulrmA?=
 =?us-ascii?Q?ZU+Jl3eHjByHwRzc4YtWNlKN8O/UUz5LyoiO/ZLGF/mgMPqRuiZJ2rwNN9pe?=
 =?us-ascii?Q?yXcg1yVj+dfFYxsnbaRFlVjPSWo49Ygcs/8Y4bumEo5WpXJwlEEIuvORKO/M?=
 =?us-ascii?Q?p14f8ch5qLYpwNRsFLhDbuFgzV6pc1JQE7VYjR6UbPJbjPy+Kh5ZKdHU5eOR?=
 =?us-ascii?Q?/SF9T1vp7t0OBtWwVbpjvn6ezgOhnrr5cUdShISCg2ES2myvyDwsrDwAi2bh?=
 =?us-ascii?Q?Q0J88cefXfA9zDlfiHx1fE4BTBO0F7Bw/Mqt+DM4FlgeBxjgnAroS+qpb67r?=
 =?us-ascii?Q?SBBeO8ODqmqTVGpWgc9Bgkni9hJ0h6UIn19JXMwHMRziMbH5xb5Xf2SE3plr?=
 =?us-ascii?Q?RI2KCRZkRlwz7L7HFZoF4gJkPfl+nwDKXmcLvH8Uurv8cfsxklLgrrqA1x5j?=
 =?us-ascii?Q?mfIkJ9h52Gxr/KA6GcK92yxXYTK0SGE84rjqPKvZ5fmiIGlRis7CvSGPTc9v?=
 =?us-ascii?Q?YXqwR4xK8fxu/MdcVKfoA3TaeXR4qFSGDob/q6L/wo380JJ77aqWl8b00RLk?=
 =?us-ascii?Q?8KSDj7L15iQSrmAPyXgPmivYA6e03cRQE+2fnshKiIfKx+3c0ZXakePIrmkA?=
 =?us-ascii?Q?BGL52qrsT8nNmtxN8kzB5p9BJKb/WusqMxcNY9yCDafokx1pcg/XDi69IDoC?=
 =?us-ascii?Q?/vB/iKPyz4WsRJdVDS/MORlhk9arpZgk8JqaRBa6l7zEn5Bwleb5+LsneffD?=
 =?us-ascii?Q?/RNEdqi7Tlh/WSYPdsYxwyp1xaK3k9uwyDpeWcgivlxNLZzD2VzXp/DINo+1?=
 =?us-ascii?Q?RuKJtYgwkQ+2nmAdgbeMRmse4mCDeGt8apb35c8C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2585a6-8fd5-4cbf-ef47-08da96266afd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 07:54:57.6784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SM9KRA2VKPbZkDfzm8unTxX7t2gIUUw1UECx8zTPhWPu8BgKCigPNHy+cS7UeaaUxAerYCGi9UPoOyXRbvf7sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5454
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions expect to be called from RCU read-side critical section,
but this only happens when invoked from the data path via
ip{,6}_mr_input(). They can also be invoked from process context in
response to user space adding a multicast route which resolves a cache
entry with queued packets [1][2].

Fix by adding missing rcu_read_lock() / rcu_read_unlock() in these call
paths.

[1]
WARNING: suspicious RCU usage
6.0.0-rc3-custom-15969-g049d233c8bcc-dirty #1387 Not tainted
-----------------------------
net/ipv4/ipmr.c:84 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by smcrouted/246:
 #0: ffffffff862389b0 (rtnl_mutex){+.+.}-{3:3}, at: ip_mroute_setsockopt+0x11c/0x1420

stack backtrace:
CPU: 0 PID: 246 Comm: smcrouted Not tainted 6.0.0-rc3-custom-15969-g049d233c8bcc-dirty #1387
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x91/0xb9
 vif_dev_read+0xbf/0xd0
 ipmr_queue_xmit+0x135/0x1ab0
 ip_mr_forward+0xe7b/0x13d0
 ipmr_mfc_add+0x1a06/0x2ad0
 ip_mroute_setsockopt+0x5c1/0x1420
 do_ip_setsockopt+0x23d/0x37f0
 ip_setsockopt+0x56/0x80
 raw_setsockopt+0x219/0x290
 __sys_setsockopt+0x236/0x4d0
 __x64_sys_setsockopt+0xbe/0x160
 do_syscall_64+0x34/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

[2]
WARNING: suspicious RCU usage
6.0.0-rc3-custom-15969-g049d233c8bcc-dirty #1387 Not tainted
-----------------------------
net/ipv6/ip6mr.c:69 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by smcrouted/246:
 #0: ffffffff862389b0 (rtnl_mutex){+.+.}-{3:3}, at: ip6_mroute_setsockopt+0x6b9/0x2630

stack backtrace:
CPU: 1 PID: 246 Comm: smcrouted Not tainted 6.0.0-rc3-custom-15969-g049d233c8bcc-dirty #1387
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x91/0xb9
 vif_dev_read+0xbf/0xd0
 ip6mr_forward2.isra.0+0xc9/0x1160
 ip6_mr_forward+0xef0/0x13f0
 ip6mr_mfc_add+0x1ff2/0x31f0
 ip6_mroute_setsockopt+0x1825/0x2630
 do_ipv6_setsockopt+0x462/0x4440
 ipv6_setsockopt+0x105/0x140
 rawv6_setsockopt+0xd8/0x690
 __sys_setsockopt+0x236/0x4d0
 __x64_sys_setsockopt+0xbe/0x160
 do_syscall_64+0x34/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: ebc3197963fc ("ipmr: add rcu protection over (struct vif_device)->dev")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/ipmr.c  | 2 ++
 net/ipv6/ip6mr.c | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 73651d17e51f..e11d6b0b62b7 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1004,7 +1004,9 @@ static void ipmr_cache_resolve(struct net *net, struct mr_table *mrt,
 
 			rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
 		} else {
+			rcu_read_lock();
 			ip_mr_forward(net, mrt, skb->dev, skb, c, 0);
+			rcu_read_unlock();
 		}
 	}
 }
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index a9ba41648e36..858fd8a28b5b 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1028,8 +1028,11 @@ static void ip6mr_cache_resolve(struct net *net, struct mr_table *mrt,
 				((struct nlmsgerr *)nlmsg_data(nlh))->error = -EMSGSIZE;
 			}
 			rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
-		} else
+		} else {
+			rcu_read_lock();
 			ip6_mr_forward(net, mrt, skb->dev, skb, c);
+			rcu_read_unlock();
+		}
 	}
 }
 
-- 
2.37.1

