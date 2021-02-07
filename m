Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92303122B1
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbhBGI33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:29:29 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:53233 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhBGI1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:27:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 99A585801E2;
        Sun,  7 Feb 2021 03:23:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Feb 2021 03:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=cgwGfcgNvzdq5XHm+G4P7P3RMUZY96yyYzEUEplTl+k=; b=V6O8Hodc
        Hw0I/rHS6E6rZnd7jo/eL0lYud3+7NI8itG/XxvQ2NBUADaLWykzrywO7J6idjAG
        9YczRwXa+8vt1MeTbFbl4qRUNcSqFOddrTYq80ZNz7+E+AqwBA/FOp/KFr0cv6/G
        6P1gNyV/XYtt8aXNYLUcxTEOKkra7WaZ5hQktTPCKg/CoMbf7WqABXeKeV4utqYK
        qbAmfxWSOBHFA741KgKRqfwlklsvHp0zaEzuAgP4dpx5AmuH6qekx9eHH3nkA6/Q
        VaTjFbZz3Sx9UWtY0PqiBRE7xODRlD/y4FH1aOymqhyQthzjsg4T4AmwYwctdMG7
        3tww5vYyj6AnTA==
X-ME-Sender: <xms:mKMfYN1KmXV0npZGpanobtYVQSx6GJ9d-zNxI_F4agAdolGb3ljpxA>
    <xme:mKMfYEGKOb1DB63-auq4-8ZDkuFzJYc1PYsSfFo6BRmwDtW4gIP68YoYQmgOevF96
    3wQt8G8mGGOzIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:mKMfYN6bAg2aqRcgjIgZaOr7wW-exTTlyk4E_2JRzeKiRRvfcCEm9Q>
    <xmx:mKMfYK09sVsSSMcH5rBAqluqjmdovmlAHgziishfhKvzhAjpGtplnA>
    <xmx:mKMfYAF1oGX_6JidvzofCtN8yShtJspQDkkI6dS8Dv3mkROpqFFjmw>
    <xmx:mKMfYOY3KGvB1XHg6USQ3KlQY6_ghn3E0VwnFT9B7STU7mbFGwOGjw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 768A11080057;
        Sun,  7 Feb 2021 03:23:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/10] netdevsim: fib: Add debugfs to debug route offload failure
Date:   Sun,  7 Feb 2021 10:22:56 +0200
Message-Id: <20210207082258.3872086-9-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207082258.3872086-1-idosch@idosch.org>
References: <20210207082258.3872086-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add "fail_route_offload" flag to disallow offloading routes.
It is needed to test "offload failed" notifications.

Create the flag as part of nsim_fib_create() under fib directory and set
it to false by default.

When FIB_EVENT_ENTRY_{REPLACE, APPEND} are triggered and
"fail_route_offload" value is true, set the appropriate hardware flag to
make the kernel emit RTM_NEWROUTE notification with RTM_F_OFFLOAD_FAILED
flag.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 114 +++++++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index b93bd483cf12..46fb414f7ca6 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -26,6 +26,7 @@
 #include <net/fib_rules.h>
 #include <net/net_namespace.h>
 #include <net/nexthop.h>
+#include <linux/debugfs.h>
 
 #include "netdevsim.h"
 
@@ -53,6 +54,8 @@ struct nsim_fib_data {
 	struct work_struct fib_event_work;
 	struct list_head fib_event_queue;
 	spinlock_t fib_event_queue_lock; /* Protects fib event queue list */
+	struct dentry *ddir;
+	bool fail_route_offload;
 };
 
 struct nsim_fib_rt_key {
@@ -303,6 +306,25 @@ nsim_fib4_rt_lookup(struct rhashtable *fib_rt_ht,
 	return container_of(fib_rt, struct nsim_fib4_rt, common);
 }
 
+static void
+nsim_fib4_rt_offload_failed_flag_set(struct net *net,
+				     struct fib_entry_notifier_info *fen_info)
+{
+	u32 *p_dst = (u32 *)&fen_info->dst;
+	struct fib_rt_info fri;
+
+	fri.fi = fen_info->fi;
+	fri.tb_id = fen_info->tb_id;
+	fri.dst = cpu_to_be32(*p_dst);
+	fri.dst_len = fen_info->dst_len;
+	fri.tos = fen_info->tos;
+	fri.type = fen_info->type;
+	fri.offload = false;
+	fri.trap = false;
+	fri.offload_failed = true;
+	fib_alias_hw_flags_set(net, &fri);
+}
+
 static void nsim_fib4_rt_hw_flags_set(struct net *net,
 				      const struct nsim_fib4_rt *fib4_rt,
 				      bool trap)
@@ -384,6 +406,15 @@ static int nsim_fib4_rt_insert(struct nsim_fib_data *data,
 	struct nsim_fib4_rt *fib4_rt, *fib4_rt_old;
 	int err;
 
+	if (data->fail_route_offload) {
+		/* For testing purposes, user set debugfs fail_route_offload
+		 * value to true. Simulate hardware programming latency and then
+		 * fail.
+		 */
+		msleep(1);
+		return -EINVAL;
+	}
+
 	fib4_rt = nsim_fib4_rt_create(data, fen_info);
 	if (!fib4_rt)
 		return -ENOMEM;
@@ -423,6 +454,11 @@ static int nsim_fib4_event(struct nsim_fib_data *data,
 	switch (event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 		err = nsim_fib4_rt_insert(data, fen_info);
+		if (err) {
+			struct net *net = devlink_net(data->devlink);
+
+			nsim_fib4_rt_offload_failed_flag_set(net, fen_info);
+		}
 		break;
 	case FIB_EVENT_ENTRY_DEL:
 		nsim_fib4_rt_remove(data, fen_info);
@@ -564,6 +600,15 @@ static int nsim_fib6_rt_append(struct nsim_fib_data *data,
 	struct nsim_fib6_rt *fib6_rt;
 	int i, err;
 
+	if (data->fail_route_offload) {
+		/* For testing purposes, user set debugfs fail_route_offload
+		 * value to true. Simulate hardware programming latency and then
+		 * fail.
+		 */
+		msleep(1);
+		return -EINVAL;
+	}
+
 	fib6_rt = nsim_fib6_rt_lookup(&data->fib_rt_ht, rt);
 	if (!fib6_rt)
 		return -EINVAL;
@@ -586,6 +631,26 @@ static int nsim_fib6_rt_append(struct nsim_fib_data *data,
 	return err;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static void nsim_fib6_rt_offload_failed_flag_set(struct nsim_fib_data *data,
+						 struct fib6_info **rt_arr,
+						 unsigned int nrt6)
+
+{
+	struct net *net = devlink_net(data->devlink);
+	int i;
+
+	for (i = 0; i < nrt6; i++)
+		fib6_info_hw_flags_set(net, rt_arr[i], false, false, true);
+}
+#else
+static void nsim_fib6_rt_offload_failed_flag_set(struct nsim_fib_data *data,
+						 struct fib6_info **rt_arr,
+						 unsigned int nrt6)
+{
+}
+#endif
+
 #if IS_ENABLED(CONFIG_IPV6)
 static void nsim_fib6_rt_hw_flags_set(struct nsim_fib_data *data,
 				      const struct nsim_fib6_rt *fib6_rt,
@@ -667,6 +732,15 @@ static int nsim_fib6_rt_insert(struct nsim_fib_data *data,
 	struct nsim_fib6_rt *fib6_rt, *fib6_rt_old;
 	int err;
 
+	if (data->fail_route_offload) {
+		/* For testing purposes, user set debugfs fail_route_offload
+		 * value to true. Simulate hardware programming latency and then
+		 * fail.
+		 */
+		msleep(1);
+		return -EINVAL;
+	}
+
 	fib6_rt = nsim_fib6_rt_create(data, fib6_event->rt_arr,
 				      fib6_event->nrt6);
 	if (IS_ERR(fib6_rt))
@@ -764,7 +838,7 @@ static int nsim_fib6_event(struct nsim_fib_data *data,
 			   struct nsim_fib6_event *fib6_event,
 			   unsigned long event)
 {
-	int err = 0;
+	int err;
 
 	if (fib6_event->rt_arr[0]->fib6_src.plen)
 		return 0;
@@ -772,9 +846,13 @@ static int nsim_fib6_event(struct nsim_fib_data *data,
 	switch (event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 		err = nsim_fib6_rt_insert(data, fib6_event);
+		if (err)
+			goto err_rt_offload_failed_flag_set;
 		break;
 	case FIB_EVENT_ENTRY_APPEND:
 		err = nsim_fib6_rt_append(data, fib6_event);
+		if (err)
+			goto err_rt_offload_failed_flag_set;
 		break;
 	case FIB_EVENT_ENTRY_DEL:
 		nsim_fib6_rt_remove(data, fib6_event);
@@ -783,6 +861,11 @@ static int nsim_fib6_event(struct nsim_fib_data *data,
 		break;
 	}
 
+	return 0;
+
+err_rt_offload_failed_flag_set:
+	nsim_fib6_rt_offload_failed_flag_set(data, fib6_event->rt_arr,
+					     fib6_event->nrt6);
 	return err;
 }
 
@@ -1290,10 +1373,29 @@ static void nsim_fib_event_work(struct work_struct *work)
 	mutex_unlock(&data->fib_lock);
 }
 
+static int
+nsim_fib_debugfs_init(struct nsim_fib_data *data, struct nsim_dev *nsim_dev)
+{
+	data->ddir = debugfs_create_dir("fib", nsim_dev->ddir);
+	if (IS_ERR(data->ddir))
+		return PTR_ERR(data->ddir);
+
+	data->fail_route_offload = false;
+	debugfs_create_bool("fail_route_offload", 0600, data->ddir,
+			    &data->fail_route_offload);
+	return 0;
+}
+
+static void nsim_fib_debugfs_exit(struct nsim_fib_data *data)
+{
+	debugfs_remove_recursive(data->ddir);
+}
+
 struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 				      struct netlink_ext_ack *extack)
 {
 	struct nsim_fib_data *data;
+	struct nsim_dev *nsim_dev;
 	int err;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
@@ -1301,10 +1403,15 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 		return ERR_PTR(-ENOMEM);
 	data->devlink = devlink;
 
-	err = rhashtable_init(&data->nexthop_ht, &nsim_nexthop_ht_params);
+	nsim_dev = devlink_priv(devlink);
+	err = nsim_fib_debugfs_init(data, nsim_dev);
 	if (err)
 		goto err_data_free;
 
+	err = rhashtable_init(&data->nexthop_ht, &nsim_nexthop_ht_params);
+	if (err)
+		goto err_debugfs_exit;
+
 	mutex_init(&data->fib_lock);
 	INIT_LIST_HEAD(&data->fib_rt_list);
 	err = rhashtable_init(&data->fib_rt_ht, &nsim_fib_rt_ht_params);
@@ -1365,6 +1472,8 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 	rhashtable_free_and_destroy(&data->nexthop_ht, nsim_nexthop_free,
 				    data);
 	mutex_destroy(&data->fib_lock);
+err_debugfs_exit:
+	nsim_fib_debugfs_exit(data);
 err_data_free:
 	kfree(data);
 	return ERR_PTR(err);
@@ -1392,5 +1501,6 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 	WARN_ON_ONCE(!list_empty(&data->fib_event_queue));
 	WARN_ON_ONCE(!list_empty(&data->fib_rt_list));
 	mutex_destroy(&data->fib_lock);
+	nsim_fib_debugfs_exit(data);
 	kfree(data);
 }
-- 
2.29.2

