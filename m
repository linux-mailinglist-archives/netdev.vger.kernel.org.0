Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C92A43A67D
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbhJYW12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:28 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233708AbhJYW1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHi/0P0WHlfFtmacsR1xYg2No2/PCZoEkSqSmhVS15wVL0114NRetlV8hvH/3HvME/Qw4TPrOwwoEFQY0mCM6kvAcHrL+eHpHHYDp640PDswJfm4jOt1hIPFVY6XQqvyYMBi44FSwCNmE6cw0r6s/7OKjln3suWtX2MBZcsvmhPT9qi2roWOgpJ2xPX0tnrWjdC6109ZUDKjgr3mNJKJuX7TCBz2pN4MI66IqzDXLFnXX3s/8EeLrq66oTciFTWjj4FMg5sOSDipYjFhHAxlOqY5lYlbSEeKQt0Xqd34yovNDl9MW8qjCs6oJeCTa7NXOSO6+Sx9oCUFE/sxhavf8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6BK9jq+hnNSAeHLu9xTZRvW1dHplVImVTGZNQGdZcOg=;
 b=dFF/m9GxEEgz5I5UnSU2mg1m5++BKUdxnob2Wbaryvqv5Na0L8H2m5pixuCk4q9osQS6u9Sv2ROF7dViHRK/BFXIJwJk3TQIlCLzfeAY/37kW4LjoFMfuuLTutoRjdHCUA9y8azQfQThyyHGrvcq2O6gXtlzGkfTeqK/pO4W90Q/S5hiCpW7wB9ENEknvK/iQ3p3KLKC8CZelgxSzb5ISfNq56bAO0vcURSNzQW1vTCnjyfCDkILSCRBMk6o0ptuAhMEiWBOvAptXKug1gy7fMNHSit7mbQEU6kPWZGglMs1PggOczrto8JRFauvQ9vPQzo4f5BPgRg04S18pa88/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6BK9jq+hnNSAeHLu9xTZRvW1dHplVImVTGZNQGdZcOg=;
 b=Na0qD4MxtHRE5/n2qmp0wB7I4Raz8F1LqlhmiJdSf2j+kAOYvUz08f4yS8HfHIOXfIJmcOASMf7pOiHcQvJrK70fMsAboMt/KIVjy32BFLuGISxCmO3zdEdI61tlrZBeZa9LymuIqV6yWv8Ay2yw16YaOPMMbVCZg2AaxZ9kKZ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH net-next 11/15] net: bridge: make fdb_add_entry() wait for switchdev feedback
Date:   Tue, 26 Oct 2021 01:24:11 +0300
Message-Id: <20211025222415.983883-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3404843f-dc9f-468d-4c4b-08d998063e0a
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB230403E5D03F8FEBCB5CFFE0E0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rS3hxmgA+ntHhayCKf53cmPsr4x9X6M8FmIFw8L46udrqcaGU5vmo86cNGJzMgGQaUlnkRnYnA0VOuyVAS4ZhBuPVd9SLF/L73cNwPTUSrzE2iv9teUPipk0d2LML25ONylV6Ikl88DQe8j9nDtPJdqOFpOOQhu7KD9vCQPuYTYuTgJU/PZ9+6/OskzdDe8j5Rwq8IrWtLbOh6nj6/wkwdk+qKRhl2Tn5I05l6YfIIPbWz0i0FhNJFCqUgiAJkQEgc+Ifq0MpQf7NOKvRjD9csnjTfuC0R/KO0gEJQosYV8eZ/n69J/nybJAKHuMohCe1HRu5McsZkVFS6yUrpx3QWisjNE8sJxSRrH5Zy2S8oSWHnGKWsdxN12i1g5pBqmrYgrxwR+FXZ4E+e66bCNDrKFfU45F1R1MdF72Aga8ZmLstpX0kyI5kNuhb+KocSiNF3Q/KKTfpK2iRbKqNMzp5fWzG8DPAIBAQR/t8UW7g7Ln8OmwW7u8z2ZTd6TUDS3I3npF2KAikvXEyhs8yMToZmlmu/Uz/raxirGomRdCwy1xjZqasHkOOF0gP54i2IZZ98EJDK8ZwIQBf6xfnkpqzUUIV5S8VYIZ19UushnwSyI3wcp6u9qKNJnoExpqBPG4gHuS4yY3tk1xgQNlqjEi3dqGaCKzTYwQYChQwkyUHcLIWEeOmDY93n7lMhhIPbMq8cIjEaftSRLavHCJDHTpCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(30864003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yPhqcVtxf1N6RxUBpG/+QWwFyxS+JG+2kYY9BkvFtpOsa6I3KfR2yTs2wTje?=
 =?us-ascii?Q?Req2T75u6H4suTnnXknik1PeTViQoiG8gLFFCTpFIQoBigZjnM4whbCeDJWQ?=
 =?us-ascii?Q?+fLt9oFJCQF9frrRRWrsIfQL4XKAEgWkNxeDVb+LH2qsBzWDetlGOf9uOF1E?=
 =?us-ascii?Q?kLDvZpL0pRrYOelXRgFLKQMZ6I4HJ/m+C71OX6hbRZfTQGzO5AGaUumnjzHP?=
 =?us-ascii?Q?p92Z1SG8QuWSYHjn3zdeL5TWl8pWI4eRSdbMPIsJHekkEvr3guhcVbecp9H6?=
 =?us-ascii?Q?el92FVkj1fUbDyJ52U7H7KAVU0WgLwNf6CSnuMfffDxvQRQdIRIZe2LsmM/J?=
 =?us-ascii?Q?3Al1SwP094wjoFQNp3aD4k0lrY9TzAHoDTQIlAdZV++LrJurepojbRSQveQh?=
 =?us-ascii?Q?cqiNvbQv3deEhnyMT93bFXHshs39n/NwHvnuYkYiCtEg9y0xojE2CYPjn4o/?=
 =?us-ascii?Q?2RDl50uvXsgjLXF3oMSKpmMLopRoyLOOCOXxDG0QRssSh2i/WZlXkFTerfGT?=
 =?us-ascii?Q?InZzHakp4v2yr3wspGraRU9VD4fxcI6l9g9OC9PJZBMw130r9+c+MDOywZxs?=
 =?us-ascii?Q?9CCCwgjB8mBme3BEYstIGWJ66QHH2XgDr51hrTcXVkPoyh59GNZLDOtBgq5Y?=
 =?us-ascii?Q?1FF1RkAM181yfDjKY5C0iZWZrwSlD8Ho5b8g7Q+yZ22y/CxZSNJbybprHqRb?=
 =?us-ascii?Q?G4YPJ0kwG5R1sggUueU8lZCm63fNTFisns284V7MEkFx1Q4GUqHUae/q0xI5?=
 =?us-ascii?Q?zr+nCF7BKaG92aLht4CNNWPaXttZWJERVTkGfP6fV5YXAZdNEnPpcjCFb3Vg?=
 =?us-ascii?Q?422blKtBHggtgaDS2euKQVHQWXLCtpRFLYx579irq7u4AJXi1H8IIaLGUjvn?=
 =?us-ascii?Q?a5wUMXLN+5Grf6yfSCveFbtXp80ZHlzF3MsJKED7gxyOy0c+YcGkFtmAUVRH?=
 =?us-ascii?Q?Sakjz1Zl4xu0AEeoAFqHFYXdaFlCAsdYBjjYmfg04sMqdYQ09JIx6NQADfR4?=
 =?us-ascii?Q?bT/YdYwn1VVPl6+d2uFpiSzipp0fmrlagUjEzcRh5Z6IxdNPRn9psrpXgm3H?=
 =?us-ascii?Q?3Ul7KZKh416HO44a2xo8ZNqgHq5bjsh9MU8OElVVxg41QQY4OulvIXpJVD7E?=
 =?us-ascii?Q?53DH5uWPisKy1lrLOyFTJ5sxCFl2kcgY1vB3CTpMYa78ycc7mKLiVu2EAaaS?=
 =?us-ascii?Q?mzsxX4q7qLpWKOFm0COGRcWCmJYvpcSlMq4qstSaTCptUk2ly8gQxluDN0NP?=
 =?us-ascii?Q?41bkd6aGfeKAsnnxTUPe/gHIxDkevZEnTDXhiN/+Al7bC3oXaQinjtyVY4fO?=
 =?us-ascii?Q?vxIow1q4Kwsv2TezT8dDGe1AayGz9QIAICkg0WK2p//aPl4emCgIasU8msrG?=
 =?us-ascii?Q?26rlaHX60ZdlVxi3UH52hCHkAd3ihI2or7+ugUKeWTQlbSyorkbkraps8ETj?=
 =?us-ascii?Q?slEoAzS4XVl6X6iYqafES/JSb30Kqzif024DfMEdCBXRJDdNwij0V3WdUQzA?=
 =?us-ascii?Q?pd95I2XELf9zyYsKLDfjf3H/SONWKjpFn6L3rXjD1kb2hl1HIyc6yEayJdDr?=
 =?us-ascii?Q?TqywZYiNNHc6yk3v//khyTy0JjvNJU311PEyTdNpH58wdgBKwU0ZAFONIJJ0?=
 =?us-ascii?Q?OLJiM5Az7BqKRcvwVweo/k0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3404843f-dc9f-468d-4c4b-08d998063e0a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:42.8793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8fg+hq6mpYm46/HOmLlXdtJrr/5ZVgODFGM857qP67SR5cgBS5vNir4dgjVf0pYzKLTAIUmi1QTB/7YehfVjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, switchdev gets notified of FDB entries via the
br_switchdev_fdb_notify() function, which is called from fdb_notify().
In turn, fdb_notify is called from a wide variety of places, mixing data
path learning, STP timers, sysfs handlers, netlink IFLA_BRPORT_FLUSH
handlers, RTM_NEWNEIGH/RTM_DELNEIGH handlers, FDB garbage collection
timers, and others.

The common denominator is that FDB entries are created and added to the
bridge hash table under the br->hash_lock. And so is the switchdev
notification.

Because SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events are notified on the
switchdev atomic notifier chain and all drivers need sleepable context
to offload those FDB entries, the current situation is that all drivers
register a private workqueue on which they schedule work items from the
atomic switchdev notifier chain. The practical implication is that they
can't return error codes and extack messages from their private
workqueue, and even if they could (or if they would return an error
directly from the atomic notifier), the bridge would still ignore those.

We're not structurally changing anything, because there are reasons why
things are the way they are (the theoretical possibility of performance,
basically). Instead, this patch just adds a mechanism based on a
completion structure by which user space can wait for the driver's
deferred work item to finish, and return an error code.

It works as follows:

- br_switchdev_fdb_notify() behaves as before, but we introduce a new
  br_switchdev_fdb_notify_async() which contains some bridge data.
  The functions which don't care what switchdev has to say keep calling
  br_switchdev_fdb_notify(), the others (for now fdb_add_entry(), the
  function that processes RTM_NEWNEIGH) calls
  br_switchdev_fdb_notify_async()

- every function that calls br_switchdev_fdb_notify_async() must declare
  a struct br_switchdev_fdb_wait_ctx on stack. This is the storage for
  the completion structure. Then br_switchdev_fdb_notify_async() will
  create a special struct switchdev_notifier_fdb_info that contains some
  function pointers that wake up the bridge process waiting for this
  completion.

- every function that calls br_switchdev_fdb_notify_async() under
  br->hash_lock must release this lock before it can sleep waiting for
  the completion, then it has to take the lock again and search for the
  FDB entry again.

- in the case of fdb_add_entry(), we have nothing to do if switchdev was
  happy, otherwise we need to take the hash_lock again and delete the
  FDB entry we've just created. We may not find the FDB entry we were
  trying to delete, due to factors such as ultra short ageing time.
  In those cases we do nothing. The rollback logic for fdb_add_entry()
  is copied from fdb_delete_by_addr_and_port() except here we don't
  notify switchdev - we know it doesn't contain that entry and doesn't
  want it. I've renamed the existing fdb_delete_by_addr_and_port()
  function into fdb_delete_by_addr_and_port_switchdev().

The API exposed to switchdev drivers is comprised of two functions:

* switchdev_fdb_mark_pending() must be called from atomic context, to
  tell the bridge to wait
* switchdev_fdb_mark_done() can be called from any context, it tells
  the bridge to stop waiting

When nobody has called switchdev_fdb_mark_pending(), the bridge doesn't
wait. There is no race condition here, because the atomic notifiers have
finished by the time br_switchdev_fdb_notify_async() finishes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h   |  17 +++++
 net/bridge/br_fdb.c       | 138 +++++++++++++++++++++++++++++++++++---
 net/bridge/br_private.h   |  16 +++++
 net/bridge/br_switchdev.c |  34 ++++++++--
 4 files changed, 190 insertions(+), 15 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 559f63abc15b..67f7b22e5332 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -218,6 +218,9 @@ struct switchdev_notifier_info {
 
 struct switchdev_notifier_fdb_info {
 	struct switchdev_notifier_info info; /* must be first */
+	void (*pending_fn)(unsigned long cookie);
+	void (*done_fn)(unsigned long cookie, int err);
+	unsigned long cookie;
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	u8 added_by_user:1,
@@ -260,6 +263,20 @@ switchdev_fdb_is_dynamically_learned(const struct switchdev_notifier_fdb_info *f
 	return !fdb_info->added_by_user && !fdb_info->is_local;
 }
 
+static inline void
+switchdev_fdb_mark_pending(const struct switchdev_notifier_fdb_info *fdb_info)
+{
+	if (fdb_info->pending_fn)
+		fdb_info->pending_fn(fdb_info->cookie);
+}
+
+static inline void
+switchdev_fdb_mark_done(const struct switchdev_notifier_fdb_info *fdb_info, int err)
+{
+	if (fdb_info->done_fn)
+		fdb_info->done_fn(fdb_info->cookie, err);
+}
+
 #ifdef CONFIG_NET_SWITCHDEV
 
 int switchdev_bridge_port_offload(struct net_device *brport_dev,
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 2095bdf24e42..e8afe64dadcc 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -201,6 +201,83 @@ static void fdb_notify(struct net_bridge *br,
 	rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
 }
 
+struct br_switchdev_fdb_wait_ctx {
+	/* Serializes switchdev driver calls to switchdev_fdb_mark_done */
+	struct mutex lock;
+	struct completion done;
+	bool pending;
+	int pending_count;
+	int err;
+};
+
+static void
+br_switchdev_fdb_wait_ctx_init(struct br_switchdev_fdb_wait_ctx *wait_ctx)
+{
+	wait_ctx->pending = false;
+	wait_ctx->pending_count = 0;
+	wait_ctx->err = 0;
+	mutex_init(&wait_ctx->lock);
+	init_completion(&wait_ctx->done);
+}
+
+static void br_switchdev_fdb_pending(unsigned long cookie)
+{
+	struct br_switchdev_fdb_wait_ctx *wait_ctx;
+
+	wait_ctx = (struct br_switchdev_fdb_wait_ctx *)cookie;
+
+	wait_ctx->pending = true;
+	/* Drivers serialize on the switchdev atomic notifier chain when they
+	 * call switchdev_fdb_mark_pending, so no locking is necessary.
+	 */
+	wait_ctx->pending_count++;
+}
+
+static void br_switchdev_fdb_done(unsigned long cookie, int err)
+{
+	struct br_switchdev_fdb_wait_ctx *wait_ctx;
+	bool done;
+
+	wait_ctx = (struct br_switchdev_fdb_wait_ctx *)cookie;
+
+	/* Potentially multiple drivers might call switchdev_fdb_mark_done,
+	 * each from its own deferred context. So we need to serialize here.
+	 */
+	mutex_lock(&wait_ctx->lock);
+
+	/* Do not overwrite errors with success stories. This preserves the
+	 * last non-zero error code, which may or may not coincide with the
+	 * last extack.
+	 */
+	if (err)
+		wait_ctx->err = err;
+
+	wait_ctx->pending_count--;
+	done = wait_ctx->pending_count == 0;
+
+	mutex_unlock(&wait_ctx->lock);
+
+	if (done)
+		complete(&wait_ctx->done);
+}
+
+static int br_switchdev_fdb_wait(struct br_switchdev_fdb_wait_ctx *wait_ctx)
+{
+	/* If the pending flag isn't set, there's nothing to wait for
+	 * (switchdev not compiled, no driver interested, driver with the
+	 * legacy silent behavior, etc).
+	 * We need a dedicated pending flag as opposed to looking at the
+	 * pending_count, because we'd need a lock to look at the
+	 * pending_count (it's decremented concurrently with us), whereas we
+	 * need no locking to look at the pending flag: it was set (if it was)
+	 * during the atomic notifier call.
+	 */
+	if (wait_ctx->pending)
+		wait_for_completion(&wait_ctx->done);
+
+	return wait_ctx->err;
+}
+
 static void br_fdb_notify(struct net_bridge *br,
 			  const struct net_bridge_fdb_entry *fdb, int type,
 			  bool swdev_notify)
@@ -211,6 +288,18 @@ static void br_fdb_notify(struct net_bridge *br,
 	fdb_notify(br, fdb, type);
 }
 
+static void br_fdb_notify_async(struct net_bridge *br,
+				const struct net_bridge_fdb_entry *fdb,
+				int type, struct netlink_ext_ack *extack,
+				struct br_switchdev_fdb_wait_ctx *wait_ctx)
+{
+	br_switchdev_fdb_notify_async(br, fdb, type, br_switchdev_fdb_pending,
+				      br_switchdev_fdb_done,
+				      (unsigned long)wait_ctx, extack);
+
+	fdb_notify(br, fdb, type);
+}
+
 static struct net_bridge_fdb_entry *fdb_find_rcu(struct rhashtable *tbl,
 						 const unsigned char *addr,
 						 __u16 vid)
@@ -841,6 +930,26 @@ int br_fdb_get(struct sk_buff *skb,
 	return err;
 }
 
+/* Delete an FDB entry and don't notify switchdev */
+static void fdb_delete_by_addr_and_port(struct net_bridge *br,
+					const struct net_bridge_port *p,
+					const u8 *addr, u16 vlan)
+{
+	struct net_bridge_fdb_entry *fdb;
+
+	spin_lock_bh(&br->hash_lock);
+
+	fdb = br_fdb_find(br, addr, vlan);
+	if (!fdb || READ_ONCE(fdb->dst) != p) {
+		spin_unlock_bh(&br->hash_lock);
+		return;
+	}
+
+	fdb_delete(br, fdb, false);
+
+	spin_unlock_bh(&br->hash_lock);
+}
+
 /* returns true if the fdb is modified */
 static bool fdb_handle_notify(struct net_bridge_fdb_entry *fdb, u8 notify)
 {
@@ -868,14 +977,16 @@ static bool fdb_handle_notify(struct net_bridge_fdb_entry *fdb, u8 notify)
 /* Update (create or replace) forwarding database entry */
 static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 			 const u8 *addr, struct ndmsg *ndm, u16 flags, u16 vid,
-			 struct nlattr *nfea_tb[])
+			 struct nlattr *nfea_tb[], struct netlink_ext_ack *extack)
 {
 	bool is_sticky = !!(ndm->ndm_flags & NTF_STICKY);
 	bool refresh = !nfea_tb[NFEA_DONT_REFRESH];
+	struct br_switchdev_fdb_wait_ctx wait_ctx;
 	struct net_bridge_fdb_entry *fdb;
 	u16 state = ndm->ndm_state;
 	bool modified = false;
 	u8 notify = 0;
+	int err;
 
 	/* If the port cannot learn allow only local and static entries */
 	if (source && !(state & NUD_PERMANENT) && !(state & NUD_NOARP) &&
@@ -899,6 +1010,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 			return -EINVAL;
 	}
 
+	br_switchdev_fdb_wait_ctx_init(&wait_ctx);
+
 	spin_lock_bh(&br->hash_lock);
 
 	fdb = br_fdb_find(br, addr, vid);
@@ -959,12 +1072,16 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 	if (modified) {
 		if (refresh)
 			fdb->updated = jiffies;
-		br_fdb_notify(br, fdb, RTM_NEWNEIGH, true);
+		br_fdb_notify_async(br, fdb, RTM_NEWNEIGH, extack, &wait_ctx);
 	}
 
 	spin_unlock_bh(&br->hash_lock);
 
-	return 0;
+	err = br_switchdev_fdb_wait(&wait_ctx);
+	if (err)
+		fdb_delete_by_addr_and_port(br, source, addr, vid);
+
+	return err;
 }
 
 static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
@@ -996,7 +1113,8 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 		}
 		err = br_fdb_external_learn_add(br, p, addr, vid, true);
 	} else {
-		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
+		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb,
+				    extack);
 	}
 
 	return err;
@@ -1090,9 +1208,13 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	return err;
 }
 
-static int fdb_delete_by_addr_and_port(struct net_bridge *br,
-				       const struct net_bridge_port *p,
-				       const u8 *addr, u16 vlan)
+/* Delete an FDB entry and notify switchdev.
+ * Caller must hold &br->hash_lock.
+ */
+static int
+fdb_delete_by_addr_and_port_switchdev(struct net_bridge *br,
+				      const struct net_bridge_port *p,
+				      const u8 *addr, u16 vlan)
 {
 	struct net_bridge_fdb_entry *fdb;
 
@@ -1112,7 +1234,7 @@ static int __br_fdb_delete(struct net_bridge *br,
 	int err;
 
 	spin_lock_bh(&br->hash_lock);
-	err = fdb_delete_by_addr_and_port(br, p, addr, vid);
+	err = fdb_delete_by_addr_and_port_switchdev(br, p, addr, vid);
 	spin_unlock_bh(&br->hash_lock);
 
 	return err;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 3c9327628060..f5f7501dad7d 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1987,6 +1987,12 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       struct netlink_ext_ack *extack);
 void br_switchdev_fdb_notify(struct net_bridge *br,
 			     const struct net_bridge_fdb_entry *fdb, int type);
+void br_switchdev_fdb_notify_async(struct net_bridge *br,
+				   const struct net_bridge_fdb_entry *fdb, int type,
+				   void (*pending_fn)(unsigned long cookie),
+				   void (*done_fn)(unsigned long cookie, int err),
+				   unsigned long cookie,
+				   struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
@@ -2073,6 +2079,16 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 {
 }
 
+static inline void
+br_switchdev_fdb_notify_async(struct net_bridge *br,
+			      const struct net_bridge_fdb_entry *fdb, int type,
+			      void (*pending_fn)(unsigned long cookie),
+			      void (*done_fn)(unsigned long cookie, int err),
+			      unsigned long cookie,
+			      struct netlink_ext_ack *extack)
+{
+}
+
 static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 {
 }
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index f58fb06ae641..6e3040f6f636 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -125,7 +125,10 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 static void br_switchdev_fdb_populate(struct net_bridge *br,
 				      struct switchdev_notifier_fdb_info *item,
 				      const struct net_bridge_fdb_entry *fdb,
-				      const void *ctx)
+				      const void *ctx,
+				      void (*pending_fn)(unsigned long cookie),
+				      void (*done_fn)(unsigned long cookie, int err),
+				      unsigned long cookie)
 {
 	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
 
@@ -136,28 +139,44 @@ static void br_switchdev_fdb_populate(struct net_bridge *br,
 	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
 	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
 	item->info.ctx = ctx;
+	item->pending_fn = pending_fn;
+	item->done_fn = done_fn;
+	item->cookie = cookie;
 }
 
 void
-br_switchdev_fdb_notify(struct net_bridge *br,
-			const struct net_bridge_fdb_entry *fdb, int type)
+br_switchdev_fdb_notify_async(struct net_bridge *br,
+			      const struct net_bridge_fdb_entry *fdb, int type,
+			      void (*pending_fn)(unsigned long cookie),
+			      void (*done_fn)(unsigned long cookie, int err),
+			      unsigned long cookie,
+			      struct netlink_ext_ack *extack)
 {
 	struct switchdev_notifier_fdb_info item;
 
-	br_switchdev_fdb_populate(br, &item, fdb, NULL);
+	br_switchdev_fdb_populate(br, &item, fdb, NULL, pending_fn,
+				  done_fn, cookie);
 
 	switch (type) {
 	case RTM_DELNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
-					 item.info.dev, &item.info, NULL);
+					 item.info.dev, &item.info, extack);
 		break;
 	case RTM_NEWNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
-					 item.info.dev, &item.info, NULL);
+					 item.info.dev, &item.info, extack);
 		break;
 	}
 }
 
+void
+br_switchdev_fdb_notify(struct net_bridge *br,
+			const struct net_bridge_fdb_entry *fdb, int type)
+{
+	br_switchdev_fdb_notify_async(br, fdb, type, NULL, NULL,
+				      (unsigned long)NULL, NULL);
+}
+
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack)
 {
@@ -287,7 +306,8 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 	struct switchdev_notifier_fdb_info item;
 	int err;
 
-	br_switchdev_fdb_populate(br, &item, fdb, ctx);
+	br_switchdev_fdb_populate(br, &item, fdb, ctx, NULL,
+				  NULL, (unsigned long)NULL);
 
 	err = nb->notifier_call(nb, action, &item);
 	return notifier_to_errno(err);
-- 
2.25.1

