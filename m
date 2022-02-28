Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57AC4C63B3
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiB1HSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiB1HSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:18:02 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2091.outbound.protection.outlook.com [40.107.20.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736C21D9;
        Sun, 27 Feb 2022 23:17:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nakv115kWYRChxgP9zFEAaQRTLlhPtQY+R0lKnbUGQXr+icFPEZxUmxGKIsS2ILNE6drKlJxbcPzFtBPEz7RwPlG8HEpLo83yiGeAocO4VgKkfe9SlgCDmIoSlruDVUfpJdpuzUzRqynBzvvMD+VJBghgLxw8tZb4KlqaEve+hpcupcDsJkD6lwi6DT8MSj7NtyRMEWJUW0O0cEJlKzbzKirebIvA9Dfu5BVyLcFGQS5Xd21M6XN4m8gPQdUiuLl5r4wB0M2r0XKffpJ9TOjiQRQvZkfshxGNxfXpFVzJzaNmQ/GFupKOwjFfORwhdFfkhu5jzB5HnheWwvOOqs6Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItXo0edaAv26vpZ+c5d9S5dAsoAp0gsx5xRh9gs3tZI=;
 b=cMgFMGYIRTBkNRfPver5SORxzSDuw+COTEpvKUhpcP25zj4SG+qqFCWiDFKtEMqSQsLYhRDM4LJslMffXM8Qkg/fqJWj4WXpp+/iYuUmyElMRdVoA+aJY7gC4xzvJ4NZH7zB7CeZ9lNnS3GqqF9xFz8vMBIeY9YnIsYU6KzEA5LGTTah405ndsFEhGdyJaTCPuKv9SlS4acSofqvZ50LJTlHzkniQ12XvMpwZSxRwSLe0jJ6KQGBCp7DLNYkR0hMA0lkDVTiz1dsjAgyyDqFc615uCfq37baHCPt4rYYl2+3OWXDwvjcwlDvWRN56cjrDSDPQPYJ6Vz5Brpkq0c7Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItXo0edaAv26vpZ+c5d9S5dAsoAp0gsx5xRh9gs3tZI=;
 b=vWA1EarnVyIcW4osm3ThjUvh9q7NTUlX1zlnYiXPTnself3vyd/RfeYBJFGpG4Dmt6oJF5H9GsmiI9jMDq2cESME5gqe/yG6KTM1qu5XQ+OqTRs9lM7o9imkU59acS6azkaxwFsqAiM0hpFjFt858fqc+DzvPxJRl0XVHPQ4K9s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VI1PR08MB3245.eurprd08.prod.outlook.com (2603:10a6:803:48::20)
 by DB8PR08MB4123.eurprd08.prod.outlook.com (2603:10a6:10:b2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 07:17:18 +0000
Received: from VI1PR08MB3245.eurprd08.prod.outlook.com
 ([fe80::4007:6de5:a0b9:1533]) by VI1PR08MB3245.eurprd08.prod.outlook.com
 ([fe80::4007:6de5:a0b9:1533%6]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 07:17:18 +0000
Message-ID: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
Date:   Mon, 28 Feb 2022 10:17:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH RFC] net: memcg accounting for veth devices
To:     Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0302CA0017.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::27) To VI1PR08MB3245.eurprd08.prod.outlook.com
 (2603:10a6:803:48::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 691d39cd-5fbe-4d1e-b297-08d9fa8a5a6a
X-MS-TrafficTypeDiagnostic: DB8PR08MB4123:EE_
X-Microsoft-Antispam-PRVS: <DB8PR08MB4123DDE2505B2639A8EEE100AA019@DB8PR08MB4123.eurprd08.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6SLawBQvtRVU6As9MDg5cHH7Ou/LLJ7wZema49uJ7N5MlxZyY5iakegmGvrD1OoDhBa6qnonrl/f9SkcvnuEqOtjzOHCGGrh7d2JkOaNrypz/LtTA/3+PDKlxTmSS5m4bIyyQUBIVCor9SnapYxiOSkErJ1TI0CrsTjJumz1ZGgnFhEZ5NCGI7y8Kf3Kp2MpRbLw4JbONhPE4L5zmd8GfeKgQHbSVC5dCboLBqXHUKMA0bsEh2jQOv/mg3Ye5xY45AiHLizYV90Dn3DUeRy5XeUzLxrmp68FGCJrGZAKcbW2Z44NPjs31gkbnhTb3n/jst+8ic054SMGmPZi/11jRi1DviPPSCtFDww2VVrJTOgcke2moFzq092MHWfMqDuy4QRMajOwLskjHLg5hBEnfDEvLykX9hdZLAjA+uSuqsgndSJQIvBY5mwgHrST3pq5kyTyyg6jWl2o7NQ5LeKqrTmWDwkd8lek5ecbQGiKy4nrLbcfZ19Iw9BXqCRPJJhT/TsjbcJ6CCpYDyxe+i3XFGxTAnK0gcwKJIi682vMr8qth4sH7g1RNf18HaqcD3X7PC4/8mBewn3aNRID6z0TdT74XxWEKE5dJ8KlX0cMaOvMbm7zzpLfp35UPK9OgE7WJw6w4J4jPp7kthJdDDxZQ9X0OsLa5VDma9HM3A9xgzv03+QW8GLx/oJFowAODQgp9YTJgPoRZGqYE6W/EN60pLaoZZ/oaelytOspdWxuIzHXd1O0l7hUVkxV0y0N+lu45A7N1gAXeP86+Cau5iL9vBbQ7eY/BsaYsK1z6n/dhgE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3245.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(54906003)(110136005)(83380400001)(38100700002)(8676002)(8936002)(4326008)(66476007)(66556008)(36756003)(66946007)(31686004)(508600001)(5660300002)(316002)(7416002)(2616005)(26005)(186003)(6506007)(52116002)(15650500001)(2906002)(31696002)(107886003)(38350700002)(6512007)(86362001)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHFOUUJRT09MMWtWTmxPbElTbGczZ29TdmlUdVBaWVRnTDhkMVo2bmdmTUpD?=
 =?utf-8?B?YS9neFpGb2JzL2xubk9ZNllieFZzdGJzOWVnSXVQaEIwVEdZM2EyMG9sUnMy?=
 =?utf-8?B?WEIxWEdVblFHTjIxeTZTMXNkcnRuRFc3NTBhVSsrVlp3NE96NkQrME1Oampv?=
 =?utf-8?B?bU1zOEtEaWtqNnpQMjdMZWxPVi9rb2E1UHZWai9ZMDIzWUxpTXFNbDhIQVRu?=
 =?utf-8?B?cG13TEd1TzJibXhJeTkrVVduR1ByTmppcTVxamxBTlJzM21JanpWNVE2Nms4?=
 =?utf-8?B?QjNGMXQ4SnQyOVkrUG5ZN09LcW9Vekoxd2pGRmR2Q2JNL0prS3NPcnZQT3Y4?=
 =?utf-8?B?c3h0NTE2Z3IyM0lCR0FGSWFOSHhtU0JQdzJlQ1g3ZUc2QUhENkFwRnB5S1N2?=
 =?utf-8?B?M2pNVFdIWFl0T1J2YVhIM1BJbnJIdXJOUkpNWHpJckQyUDFac09kZHQwaDAy?=
 =?utf-8?B?ZVR5WHM4TmQxYjhzYUZCQzBrWjBnTDB0WTNvQWZObG4xZEs5aUZCZUtyc0VH?=
 =?utf-8?B?YmlSbzJNYWxPbjgwZG5PaE1ZZTBKYnhpMjdHME55bklYRHVreFZnSE9SZWE0?=
 =?utf-8?B?QlZXbmRQQkh3TjdybUVxaTBNMWpoYUZRSXkxYitVRzFyVjNQeXA4YXVTTEtl?=
 =?utf-8?B?MmNNbUp3SUR6elZuL3l2NkRQbTYvQmgyUXZ3eGF5Tk5EOVJ4UmpCVkNLUjc5?=
 =?utf-8?B?TEFCeFZkM3RKdmhOeTQ2V1lXUTU2UlR4QXpNbVZZQzB3clZTWXNLNk9DZXFX?=
 =?utf-8?B?Q0wyUHpXQ1NmTXNRRUJCUFBjYTNIY1FYSTV6MXpjRkFjSWZ1cGZhQmQybDJx?=
 =?utf-8?B?WlNCRi80Ui9hcFRhZ0pwMmNPcFVKSENDcTA3YjJXT3hoOFJ3UEQ2NGUxcElj?=
 =?utf-8?B?L3QzOWR4dHBjY0JPS3ZwaEZjRGxTZWdyUmtWelNtV3FKczFSM0hoZ1BVY1F3?=
 =?utf-8?B?dkVHemFoYnpMeVF2cnoyU0psbklWcmwwdVRWTnBJeEY4QXBDcHJ0TFlKNHlE?=
 =?utf-8?B?czFNR25HSWdzWHZIK3MybVRneGRlOEI4dUtyZ29sK1JQMTNoYzU3ZkE5QnY4?=
 =?utf-8?B?aXJQWGJ2Wm9qWWthdDFYU25PbWwzWDA4NkhpajNZajFBbWEzcVA2cUZId2ZR?=
 =?utf-8?B?UnJNNUJud3gvK2RqNFV2azdzZkhNckRIQ1d2UDFLeFhHVG5menlia09sa2VU?=
 =?utf-8?B?aHFuNFdvMUN0ZUFid1BHcS92ZHVaSGlTV0NwUHowZWYwRjlQTTk3ekp0aFZC?=
 =?utf-8?B?dFl3bjIzSXBqVkFVU1k3LzlQYlp6OUFBR2dNeGhaZ1RzMUFqUkV6WWFua1dm?=
 =?utf-8?B?cTY2Z3NiYk0vYXl5NlhCSFZ6eXE2cVFjYkpoUEFoY2ZNRzhZbXVpVEVNVDhS?=
 =?utf-8?B?QXgvRU1RaDhvL1RZQ1VGeVd5OHFrY3lVUm5zaE9UNXhQSEFHbU52aERtcHVZ?=
 =?utf-8?B?OHhoamR2UHlGb0NrNTI5UkRkazVGZUgvb1hRK1FIYjRYK1dMYWZobXEzdWo4?=
 =?utf-8?B?NFZvRnkxd3duT1JMcDJxbmFJT2kxclhYdlBCRFRmTDBqbWYzMlZBcG9yMFNm?=
 =?utf-8?B?UnV2VGxIVDNUM21wSldqcGVyRHdCVWppa0E1NHBSOVRmNkhYMExZdTdvanFu?=
 =?utf-8?B?Y01CTVgzK1U5Ui9vSWpNOUZ1WHZkdms0bzFQeFdlUXE0dFovQzFIT2tIQ281?=
 =?utf-8?B?UTROZ2JBcks4SjRMNXpPZXJId0N2WDV4TFVIMHhqNXFISE4xV0dTQnV0ajRT?=
 =?utf-8?B?VTBNSnZqVjFxbkdnT1JNY2tpNnZpbjZJREtieFRxUGZRZGtKRGM1SDBzV0VG?=
 =?utf-8?B?R2Y2c2RoTStrSHlMQTc0c3BVeFlxbzNWY1lQNVl2SXpVQ3RLZ0Z5RDVxeWp2?=
 =?utf-8?B?M3pmK1IrbmpWSlB6ZjhIaUN3RVR1M0lpa2ozNklvMHBleUp5QVA1OEVaWTJS?=
 =?utf-8?B?TExVdTdILzR3bXJyVEpNL2hzUzdZUEo5WjlIN3krWFJmbTBUYVNWdTZnNjly?=
 =?utf-8?B?VTZvRStiQTBjeElvTlJIVW5tNzVMUXMyZkFQYm5IL241WUpYOXY0ek1DMHNN?=
 =?utf-8?B?WHd2Mml0NkVtNWk2RHFGTUI1Y3NicXBUSytTa25rUmZXUnFGV3U2MStBTjJl?=
 =?utf-8?B?VmtJWVpiOVh2b21QVEJza0lWWm8yY0wrOU9rNWFvVmxIWHNBeCtTY3M5YzJW?=
 =?utf-8?Q?963RTUsGhdCZ8mMd58ZA4sI=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691d39cd-5fbe-4d1e-b297-08d9fa8a5a6a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3245.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 07:17:18.2289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJOrNIwZNnEv9imavIqVUn++9kgdDUOkAiwuOMnDQPc1foPVM9pRZsfAJ652v3tioDF1P/ehbySXNl1HcUT+uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4123
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following one-liner running inside memcg-limited container consumes
huge number of host memory and can trigger global OOM.

for i in `seq 1 xxx` ; do ip l a v$i type veth peer name vp$i ; done

Patch accounts most part of these allocations and can protect host.
---[cut]---
It is not polished, and perhaps should be splitted.
obviously it affects other kind of netdevices too.
Unfortunately I'm not sure that I will have enough time to handle it properly
and decided to publish current patch version as is.
OpenVz workaround it by using per-container limit for number of
available netdevices, but upstream does not have any kind of
per-container configuration.
------

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
  drivers/net/veth.c    | 2 +-
  fs/kernfs/mount.c     | 2 +-
  fs/proc/proc_sysctl.c | 3 ++-
  net/core/neighbour.c  | 4 ++--
  net/ipv4/devinet.c    | 2 +-
  net/ipv6/addrconf.c   | 6 +++---
  6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 354a963075c5..6e0b4a9d0843 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1307,7 +1307,7 @@ static int veth_alloc_queues(struct net_device *dev)
  	struct veth_priv *priv = netdev_priv(dev);
  	int i;
  
-	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL);
+	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL_ACCOUNT);
  	if (!priv->rq)
  		return -ENOMEM;
  
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index cfa79715fc1a..2881aeeaa880 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -391,7 +391,7 @@ void __init kernfs_init(void)
  {
  	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
  					      sizeof(struct kernfs_node),
-					      0, SLAB_PANIC, NULL);
+					      0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
  
  	/* Creates slab cache for kernfs inode attributes */
  	kernfs_iattrs_cache  = kmem_cache_create("kernfs_iattrs_cache",
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7d9cfc730bd4..e20ce8198a44 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1333,7 +1333,8 @@ struct ctl_table_header *__register_sysctl_table(
  		nr_entries++;
  
  	header = kzalloc(sizeof(struct ctl_table_header) +
-			 sizeof(struct ctl_node)*nr_entries, GFP_KERNEL);
+			 sizeof(struct ctl_node)*nr_entries,
+			 GFP_KERNEL_ACCOUNT);
  	if (!header)
  		return NULL;
  
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ec0bf737b076..66a4445421f1 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1665,7 +1665,7 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
  	struct net *net = dev_net(dev);
  	const struct net_device_ops *ops = dev->netdev_ops;
  
-	p = kmemdup(&tbl->parms, sizeof(*p), GFP_KERNEL);
+	p = kmemdup(&tbl->parms, sizeof(*p), GFP_KERNEL_ACCOUNT);
  	if (p) {
  		p->tbl		  = tbl;
  		refcount_set(&p->refcnt, 1);
@@ -3728,7 +3728,7 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
  	char neigh_path[ sizeof("net//neigh/") + IFNAMSIZ + IFNAMSIZ ];
  	char *p_name;
  
-	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL_ACCOUNT);
  	if (!t)
  		goto err;
  
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index fba2bffd65f7..47523fe5b891 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2566,7 +2566,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
  	struct devinet_sysctl_table *t;
  	char path[sizeof("net/ipv4/conf/") + IFNAMSIZ];
  
-	t = kmemdup(&devinet_sysctl, sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&devinet_sysctl, sizeof(*t), GFP_KERNEL_ACCOUNT);
  	if (!t)
  		goto out;
  
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f927c199a93c..9d903342bc41 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -358,7 +358,7 @@ static int snmp6_alloc_dev(struct inet6_dev *idev)
  	if (!idev->stats.icmpv6dev)
  		goto err_icmp;
  	idev->stats.icmpv6msgdev = kzalloc(sizeof(struct icmpv6msg_mib_device),
-					   GFP_KERNEL);
+					   GFP_KERNEL_ACCOUNT);
  	if (!idev->stats.icmpv6msgdev)
  		goto err_icmpmsg;
  
@@ -382,7 +382,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
  	if (dev->mtu < IPV6_MIN_MTU)
  		return ERR_PTR(-EINVAL);
  
-	ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL);
+	ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL_ACCOUNT);
  	if (!ndev)
  		return ERR_PTR(err);
  
@@ -7023,7 +7023,7 @@ static int __addrconf_sysctl_register(struct net *net, char *dev_name,
  	struct ctl_table *table;
  	char path[sizeof("net/ipv6/conf/") + IFNAMSIZ];
  
-	table = kmemdup(addrconf_sysctl, sizeof(addrconf_sysctl), GFP_KERNEL);
+	table = kmemdup(addrconf_sysctl, sizeof(addrconf_sysctl), GFP_KERNEL_ACCOUNT);
  	if (!table)
  		goto out;
  
-- 
2.25.1

