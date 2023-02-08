Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6882568E8B2
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjBHHIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBHHIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:08:31 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2091.outbound.protection.outlook.com [40.107.6.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801ED16ACC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 23:08:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDkKJDctqwEolCCNMd7uao2zIydWCwWaxrAFa8/PGebEZ33yfDEdp+KVdBd+4D48BHrnYADR+GYX3qRKwz6+wzZ4KXQHBAzLTV/G5Fi/POlTSz3wIsEj24lxqO5L5hmKjl6AMOYvVBi0cW2UL5F0hpjoiOwU+o93iornY61IJ29wuRCHvB6EPz+ZiO4bi/SFn9593kjo+G8aXRklRyAJMeQKCnJ8C7Y1787dxLYIrZPuSrPYlVrfwMCHwqiRYbiSeg58NG6Gv6dcky8zX5Smbskvladux70YOR4aAZqGYr+LqhK8V3/KiU8STZqy392r6pkM74SMLnTgaoOrG/1q8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8NCQFHUKfr0nCN61l7uILA3jtgN79EKsQbpgYlUhUY=;
 b=W4vDpLpf815pIII306egI0YLJFws5jsXKj4yS+dTXPZ0MeFDX3RbWr2WOfwm71KpoDjDw7DWmUT5KD4ZrnR3C/mhlDK4QzaLP4bFwDOfxoeTDqpIrGCToGoHa2yxu06G3G9wjKVM2lzkls9on0mI8vw6nsyl+L7xW48uNlAJBwDueDcXrc3n7NB2W7B5sS2t+Fo39PuYzTtG+vmbrdGusmVtLLsRaa9b/B456UZq8ReAqLcTSUG72svsYwXB41HhwRr1qtESnBWEDTIcOX0TFSsM+qpmdP9NUdkGW99o4g1CILSikbxLqr/zBTGes1OrypMYfQOJvQKZBUvHOxh4Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8NCQFHUKfr0nCN61l7uILA3jtgN79EKsQbpgYlUhUY=;
 b=SNuaMufo1xTmh8BexBoWjkU5p5PFJvrRlSuquSgt18zF4ApCAdzshQNSfCv055lOH0jdzsqR1o5V/i/TktEuLmoKpTuRfkPr6hwmwZ+L68W2N1ypmoojVVO8boFGEQKd1NHzHxH5gN1gxu6xfS6/dz3yqAmAmQIJ1874tmE2Ew4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by VI1PR05MB7006.eurprd05.prod.outlook.com (2603:10a6:800:18f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 07:08:27 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4%3]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 07:08:27 +0000
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com,
        viro@zeniv.linux.org.uk,
        syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
Subject: [PATCH v2 net 1/1] tipc: fix kernel warning when sending SYN message
Date:   Wed,  8 Feb 2023 07:07:59 +0000
Message-Id: <20230208070759.462019-1-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ME2PR01CA0167.ausprd01.prod.outlook.com
 (2603:10c6:201:2f::35) To DB9PR05MB9078.eurprd05.prod.outlook.com
 (2603:10a6:10:36a::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR05MB9078:EE_|VI1PR05MB7006:EE_
X-MS-Office365-Filtering-Correlation-Id: eefac3dd-d80f-483b-e499-08db09a3465c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2n7+yl3SCoCGjXxfTEi4bREGqMWnPEyeMeAjFadWvuJ0TrwzTDgoX1crKVNrreqXS+N811V30EO7knr+5tmd957iv4TsOPy5x7jL38PVQRApEBZ4iiFX+xhYdoNKK9ZfDc1ZAUnEC/3maJJKXkECgErwVwfvURhAxC9tFJcZSl5JQ+oKYrU6v1y5rzdEz0pihYKZmhDHljC7vrHg7n9bRUEZEgvE/3865Wc3+AdyZA82DAYwBPEmIeQyE+t4uyA1tmBa9tToSOhhmYQJFIXP7WIw1yf9/ZJkKvNzHez6RpVUnnIZ9slG3y+1fEdrvWkioELqBBgyn1GO51SfjYSrgaXIP1P6XIcTl6WjWEWsJhAd93z6F2HTAnSak1G1ntU9TunJtKLhD7blDaW1aAwbB848csPiuVcULws5qpVUGa3KV3Tj4iASLgDNEMGcW/xYVHDQGNxkjkIsdgoar8rYthPNj7S7w2e6K9xCJIZGEHHmw7E9ATEVwF+XuMilEYuzVZe24r1rjFWXLuzxprW7AgbDmyCs6sUvnM+qWXF0ZBSE4biJEP+ijJp7rnkfRZfnb6hvoUiOXY+wqye8Xg45tUnETGCXq3dFPoqPNh6a7oyA4qmcOjspFtkiKy3hXw+iCzWRiLydE4poGmlIB/5XfZTrytgb1N/Wcut53ocBNvTihTaUyx33YGh2liHASDfZ0KJErAS6i/sk8vNKBqllRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39840400004)(366004)(376002)(346002)(136003)(396003)(451199018)(2616005)(316002)(6666004)(83380400001)(36756003)(186003)(26005)(6512007)(4326008)(6916009)(5660300002)(8936002)(8676002)(6506007)(1076003)(52116002)(38100700002)(38350700002)(41300700001)(103116003)(66556008)(66946007)(66476007)(86362001)(15650500001)(2906002)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8wmvUaXdKpSw3Q8ngEhjYBJ0gPZzQHZV08HEX9revOSX1QDySQ/YtcS/DMpo?=
 =?us-ascii?Q?HxKoRKBeCYBJ5bllNfCzJDnaQOYlTj/Hly1GuMfa1YQuhSDBeOql/zQdIjwC?=
 =?us-ascii?Q?Y+p2F/YIHBduXcMa6xz0lrasI0ZyS68LM3YWRy5AL1bGJJ5KMsAlahGDpbeh?=
 =?us-ascii?Q?Nc/adBB5f5wEjRZy0E3vS+w2aO0HMy/JCqkTECumpQjGPkldZj9vOknpD/AA?=
 =?us-ascii?Q?HSdTNZyYyskDcx4bZqr0f+QFvJLrW/GczPl7h3ONv5I5WiPrNj3aysATFo4B?=
 =?us-ascii?Q?DoEAo5ubczr1LWF0BAkQOglr7iPpjPEQI1SzRk04mDKPNRZV/EHbO5z41RkE?=
 =?us-ascii?Q?NqrYQtmvhvCsf3lcvXqp+RjhX2lrXu1UxL/eZs4zv36Kozd/eCw2X+AxqIcu?=
 =?us-ascii?Q?sDkUORaCSmJr/N4bZTDSeW0Nj1JaNznse9m+C3MaqH+FEanY9ybh8o3HyKh3?=
 =?us-ascii?Q?BvSCLC9UHt3deV0AqxrfrAlPYpMh7oFdayfKKHpwqkKGEWu9bn50+bX8L4gy?=
 =?us-ascii?Q?wKgltf7jMzArUC0vYHxt7FtRduHeorKDgd5vT1ua21tctnkMgVTZte1FbN6V?=
 =?us-ascii?Q?GFb/cyRwtsYO56kIOI9dOrW2t5aBEj9giFi+s/E6k7dqTZVALZ+rWXGwlUxo?=
 =?us-ascii?Q?mKczVcadwQIMGFn4EiFvn7Awsa36sXjATkIKCYYSh1VvjqgACvWBeMn0KPoT?=
 =?us-ascii?Q?IOvcslr4KPyHpgSfwsNmp3CNsKEW8AKw7NdBRkZ41RJHhxup2yXNf/LxowdM?=
 =?us-ascii?Q?hIpXRzzsj4oz4xcCD2M8CxtYGZxDsrLuEFE8kDCtTfP3mwwbAjlziEybUhmH?=
 =?us-ascii?Q?64pdepYGF7b+GBSFLjIwaWlQYWV1zAY0nPPAJXUfA4hFUUXGwECBzDMgEz1n?=
 =?us-ascii?Q?CBpLSPShY1MLoPiIudMb9y88rYtlf2cq+zyeVf6D63RVgBQPMsxtXTVr3zyo?=
 =?us-ascii?Q?MjtRfyFUkiusQdRBbjeKtqqdDO36YxWVVprt7KuLaLY46rMczRPrX2lewzep?=
 =?us-ascii?Q?QY3e/BJuGDOtm9lgX5Afb1ZT4C7EXYSTgG8RZ9X8dY0jqYQ1ARoBRLXu7eOp?=
 =?us-ascii?Q?E2gtA4XUlN1ykmHdfTb10HNkjcQQMG88zq1kwErFJyuTKycTXLELzcoF2ibO?=
 =?us-ascii?Q?ApbVvwf4Gl+C6K4f1fa+oacTK1xus7ktocOUTKjoutQKqhV1CYUGB87MqLIf?=
 =?us-ascii?Q?aBJCuyvHwaf+H0TRn5x1Z9A+SC4xGS4gyUJqedu7xubjp63jWlsD1k3+SbF4?=
 =?us-ascii?Q?aJ5LERSkoPOz5q/9GFTnmN7pL1vh8++66zgGJOBQ5lbAcZmirLnfIS10r/tE?=
 =?us-ascii?Q?xUxgAYNUxIdJsn+g24lDMS6fOOYJJbeCLjY87Lko1pGeARAVJ/zGuu1ypcu+?=
 =?us-ascii?Q?zddcPAsvq7i45cSIOMWNfxk0rmThv/qRBtxrmdIZ99xoNaCmrMTQYhlswEPE?=
 =?us-ascii?Q?1Lj/6ZzbN3a7LqMWtcJ2ly7esXkvM0XoOc/1xNkJxlSigBx1R2YFNB+vLbc7?=
 =?us-ascii?Q?kbNeiKpYmCTax19Giti2328gOzX6Y0mumZ7+HRwjxxOfHkQt0FzmlQUlgwGX?=
 =?us-ascii?Q?lJwCS6kdr+gdnwtg0nbDihYcCwHGBio5BYLnVftvbsWMOj0+uRFKiDNLVejS?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: eefac3dd-d80f-483b-e499-08db09a3465c
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 07:08:27.1441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4gEYmN2jp4XLShKnkemSSRESS5tHgeHk8KA9maiCDM5GgG3ZVfmyeuY/xoUjta52pvTaQ+LZIvxtsi/yjJ5dLGwLISNmFupsmEJNUZn5GGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7006
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sending a SYN message, this kernel stack trace is observed:

...
[   13.396352] RIP: 0010:_copy_from_iter+0xb4/0x550
...
[   13.398494] Call Trace:
[   13.398630]  <TASK>
[   13.398630]  ? __alloc_skb+0xed/0x1a0
[   13.398630]  tipc_msg_build+0x12c/0x670 [tipc]
[   13.398630]  ? shmem_add_to_page_cache.isra.71+0x151/0x290
[   13.398630]  __tipc_sendmsg+0x2d1/0x710 [tipc]
[   13.398630]  ? tipc_connect+0x1d9/0x230 [tipc]
[   13.398630]  ? __local_bh_enable_ip+0x37/0x80
[   13.398630]  tipc_connect+0x1d9/0x230 [tipc]
[   13.398630]  ? __sys_connect+0x9f/0xd0
[   13.398630]  __sys_connect+0x9f/0xd0
[   13.398630]  ? preempt_count_add+0x4d/0xa0
[   13.398630]  ? fpregs_assert_state_consistent+0x22/0x50
[   13.398630]  __x64_sys_connect+0x16/0x20
[   13.398630]  do_syscall_64+0x42/0x90
[   13.398630]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

It is because commit a41dad905e5a ("iov_iter: saner checks for attempt
to copy to/from iterator") has introduced sanity check for copying
from/to iov iterator. Lacking of copy direction from the iterator
viewpoint would lead to kernel stack trace like above.

This commit fixes this issue by initializing the iov iterator with
the correct copy direction.

Fixes: f25dcc7687d4 ("tipc: tipc ->sendmsg() conversion")
Reported-by: syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
---
v2: add Fixes tag

 net/tipc/msg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 5c9fd4791c4b..cce118fea07a 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -381,6 +381,9 @@ int tipc_msg_build(struct tipc_msg *mhdr, struct msghdr *m, int offset,
 
 	msg_set_size(mhdr, msz);
 
+	if (!dsz)
+		iov_iter_init(&m->msg_iter, ITER_SOURCE, NULL, 0, 0);
+
 	/* No fragmentation needed? */
 	if (likely(msz <= pktmax)) {
 		skb = tipc_buf_acquire(msz, GFP_KERNEL);
-- 
2.34.1

