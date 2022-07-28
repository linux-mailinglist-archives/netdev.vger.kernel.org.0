Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A286B583DF3
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbiG1LqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbiG1LqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:46:15 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39AC51A1C
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:46:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b58OcgmpIEprl7LbYwoxqyRoa3+Ye9RgsEHkbG9iEZlqYaRZ4fwAC74Upx6+9IO9v66Yqg6mowdBTPmf//BTP9qPtYspJHadFFd2AHL+qxr4obkeeyxfARBW3KRhsqxsgL6GVwXxMtnAYa0iSkpMmk8GHxh98AMNvLI65WAaO9GLi5MSBYxlaNRSWZ8dWigVPTsq+zpVTij7xaV0H8OC6KCS0YA7ITnwkklpm4OUCgkJ1fmjKR8ZFjR1hWkG/QR+pGhqzpEmfuwgZKOp1cJod/97jkauimaRjhTUfLuOJaJYrx2GgG84OV7xLzxtiU3fSmxgiLfzRsVl93ejaEOS+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ujeUQxP7MiH0ULJ8JRvdEkmscIQH6NmniYIGNP73MtY=;
 b=IizjMCDObVhaIqcGIdICIipuOWDvvjw3RHlnIUNdeEZbfmVllmTCfOlOlLfea/HiGcAfm+70TmNlxD4FVOk1GNtsDQB+SoiYK04TvwIxAhCxIXOEeO7PvkMlm7FLig1/MD8UPba+qF8WmrPsXtD/H8P8oVyer7LXp8yK+rFxM2ICn3DOhQSRetGBWET60Y8wSTJJucPoRKBJ7fxxYADCntaw2LXCcv3vuscaZFLibouFzcMOlvvs2rvFhVHPJSBe2xE2Wx/i5vwdHwcG4rZW0ejH/rJBe3GGHkOixYDNaILnaa3pauSiq064QR8pyMHaVUauUXoyw4yaD4ylFWTjGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujeUQxP7MiH0ULJ8JRvdEkmscIQH6NmniYIGNP73MtY=;
 b=Zmh9OdjX72avIBTWvjhJDOGNYyC+uqwRCYnMKG/GjvM5iz6bBxkYCUCFUlTeE6woP8UcdWe3pmfEudxOZnTwukpljqSB2odqBg+OsIi4JbA8MIdVBqCeUdY/uw+QumG0++enlcMY+QGGpnaR+Dxcy/Epm5Ier0bNtMwVWhd2C63QmcFkOAEAT99uC+VP2kS6nzCtV+KLtOyAeXeilReh4z+RE8OHj+pMhmDgkEz/IyWeVXSBTcYMSRcEJNIfeY3UQKK8+1wEVAH00+D7RvBQYtPY/izvsa4SUxw2B7aVtydEnzZNlPBvagsw18PtJQ3iummXRVjfdzQn8fvQojAw9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW3PR12MB4505.namprd12.prod.outlook.com (2603:10b6:303:5a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 11:46:11 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62%4]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 11:46:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, amcohen@nvidia.com, dsahern@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/3] netdevsim: fib: Fix reference count leak on route deletion failure
Date:   Thu, 28 Jul 2022 14:45:33 +0300
Message-Id: <20220728114535.3318119-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220728114535.3318119-1-idosch@nvidia.com>
References: <20220728114535.3318119-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:803:64::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d50f6a0f-b1ad-4a7b-041b-08da708ec44e
X-MS-TrafficTypeDiagnostic: MW3PR12MB4505:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zylA+WhNHY2OfzYVQlylyW01AvQ1CdNIXXM40zgIn0vEFptXx6YLd4o4GDKwNAf1MLaoeMHL58iWvUhFg5HsD+xvpniQhkTkpv/mD2wEUcnt4seHhT5Tebps6CvYbhZWCZT5igKSYhFcx+S2aWVrTKIVsWA4zB40sKZjol1p9NDWbAAzK7K10904uBzmOhzk76LF+rYrWjVxII8vJErLgbwzOCD7WCXNGsJ6myl7tHf1phljwdRE6HdhvgQecfXj+RtrykbHYr15HWhXLL/g3F9I1kZAvN3Ng9MwCU9xWHdtK/zthgMBiDH/c1wD4IWXXl0WJg8NiMioERic5ymAnnUX67KL+Rm5Zc+OL1V9y63ShX0N2WFe28Z9/TwBnyOCML9FWizEWT1I5shw9u4z/uFWVrwo3YKQ5P64zrR3w2JQG4ocBhcHrouuQ4vX2OiLPednCLVIKFmx08PCY3KwBtZlnU9GDkSo4lL3py1crLz3YXLJIOmD7u2tLtGzbBa2xWel2Mk18ztsOflV9GSgXNcprPPzxrBYEQujNm8ig1VD+CK4FomRYY20lMxYdKmg3POSvtuL0kMQS0qo21KXKHmXKn2fjmBWGrvACY9Ot5JewrJPLGsSz3jnH9KAqPG+mJ2j2WDrp/isJP1FJqmRvcZDafcNsLpr2lH6TIqO0XhIdj8Evt9skd+ntaSjKrWr+B4x5/zVkAtDJTPc6XZ+tZgbgSggyul/Q7QzAh9w5Df01IpKSmy6vA9BIDb3bKSm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(6512007)(41300700001)(186003)(83380400001)(6506007)(6666004)(8936002)(2906002)(66476007)(478600001)(6486002)(38100700002)(6916009)(5660300002)(107886003)(36756003)(4326008)(316002)(1076003)(26005)(86362001)(66946007)(8676002)(66556008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fqRS1XSXi6IfYrUYcFKBdc74WpF+Q6yVfmIaIeGqoudV4xecNmEmSEAzZuie?=
 =?us-ascii?Q?G+sg8yVDSOVxNS24WwKISj2Te3LqPHHu69Oriar+AigCp3hTnQLYpYyrjhVT?=
 =?us-ascii?Q?tYkbMvawzuVwpIRGUjO4H7KvR6yXz/6shLDtuGDe66WTlXDx0jOJ7Bncqfv4?=
 =?us-ascii?Q?BjW9faN6/pnkQlbwmZwYrjyZzxZA/iK+x2z4+J/NOkwKzqPcNmqXTu0u+NIP?=
 =?us-ascii?Q?b0UGxPxjUvmQH713UBhCxB3dkWBHGAHQagMSQFbAKkBCG7eG2OqpTzf+h9XQ?=
 =?us-ascii?Q?3v+RpwuuR1fhqMTkugmON3d5R2+FD8/QTp0Wc+joBJ4mILxyZl1XIHCsZyeO?=
 =?us-ascii?Q?qvpZXKSKbDYYZPaNDmhyAdoflAdUTkKPIA1csTRvyghMlSWwapjL68bQEGS0?=
 =?us-ascii?Q?cXrLqdPmbRLXKoawIztLylh2mop1eoed2D8+fre0jOvdmz3HX0l+QFuHr/uG?=
 =?us-ascii?Q?5mDJNfInfL2L4thLu01CxFhOwYl0pVb2LoQgPClRUzY/5a6v/gSk5AabdPod?=
 =?us-ascii?Q?WEp8HwRbZb9Ksv5EUc3Mz8Fk2aGwEGWO76qBB+d9hphSjWGpCVQBy8p6SbxV?=
 =?us-ascii?Q?m+VCvFXXWsGIkv3uqnG00xpCC04EU02crqyFmsI5O4CZhSTqSZNQ+sUhampp?=
 =?us-ascii?Q?PYRo2H4HuM8rvBY3ndvYj+CwrnH2zWiF2n6fh6p76bCCu4K7WUX8ewdSJitH?=
 =?us-ascii?Q?l5iJLYepJdR0PSVou74NNw6dwitktsM/3rv39H/7ARvmrZ9FZm0EP+7zUYoH?=
 =?us-ascii?Q?yYZS8sQ5c3lFTiUaRECV7UYyUdGML8mrSq2NfM+HFYDaPAoPsLug2SzNswrg?=
 =?us-ascii?Q?FtrLOmsq18sFGNGW8wDxFNxYrZB1kYhCIduyC/4eyFR3i6oggGUs6iKaGlBt?=
 =?us-ascii?Q?Cd6RiZzII4R4+qbNittVSN1J25jvK+5uhEfFhOLZ6J2ei+z0SqMWh5tDMhIt?=
 =?us-ascii?Q?8ldXPKDXw4HDAhNFvViwuUCA6e2vzUTTG0cge0g7LdpIQ1ktJkHFtsF7PFyD?=
 =?us-ascii?Q?IZcLArlNghX3UBXnl+wz3UBn6zWRigQKKJDUfTT9xRO/8l/BwZ/ZIwjs7Coc?=
 =?us-ascii?Q?fLbz7TAIgz4eK/pP9yXaAlyv31Ktxy89NGgJVWf21Rm6R2DMTYP06c4BWskZ?=
 =?us-ascii?Q?zyy+Y2or2vaDDc9zFKo4Z/rKbVKhClgjmWEeGeeWSe9hql6TTEzAkIxkDAW6?=
 =?us-ascii?Q?hegUSftti9fUcyrv9icRdaClYK+yltcxcQg66s3ZgmYJxbzg6L7x3HNFCVBh?=
 =?us-ascii?Q?PWipVp6qxTMUq6WI6Z/04N8MPeZsT6YVXPWc01rBNcdFSdyR9VJ0te+/+zUk?=
 =?us-ascii?Q?d54aOWRfNigcGnHUzMeaZyyl4g9Gwiepda+aOjIhLFA/VY4JZhhbN/FJJjpD?=
 =?us-ascii?Q?0Mlib2OC+6yqx4kGRBpodyB8PfsUO5kUIfr7jc+gxoFHjMFi4tpkIOUEiP70?=
 =?us-ascii?Q?v7cO3Zn3IjWaIUNVDEze3uIGcfNOw+D6+HqozRaNG7vUAz5GjVS+/zML1z6O?=
 =?us-ascii?Q?QeFeywkT5RaYawVBHVEAZSeeAqNawfA7pKwCvtV1BzH2GskuZJ7+hpGAgSPM?=
 =?us-ascii?Q?ekQffCvBjAh3D4CSFDarXax1LUupysz5U04PbbMU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d50f6a0f-b1ad-4a7b-041b-08da708ec44e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 11:46:10.9647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dAsZ+EOc4U4nXm3EkgMCKjCC8n0QyoSieq+A7peqnVxbfit9qEAvZo2JN+8PY83VE+Opui9soxYcy9kEkS7P0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4505
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of FIB offload simulation, netdevsim stores IPv4 and IPv6 routes
and holds a reference on FIB info structures that in turn hold a
reference on the associated nexthop device(s).

In the unlikely case where we are unable to allocate memory to process a
route deletion request, netdevsim will not release the reference from
the associated FIB info structure, thereby preventing the associated
nexthop device(s) from ever being removed [1].

Fix this by scheduling a work item that will flush netdevsim's FIB table
upon route deletion failure. This will cause netdevsim to release its
reference from all the FIB info structures in its table.

Reported by Lucas Leong of Trend Micro Zero Day Initiative.

Fixes: 0ae3eb7b4611 ("netdevsim: fib: Perform the route programming in a non-atomic context")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
No "Reported-by" tag since I do not have the mail address of the
reporter.
---
 drivers/net/netdevsim/fib.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index c8f398f5bc5b..57371c697d5c 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -54,6 +54,7 @@ struct nsim_fib_data {
 	struct rhashtable nexthop_ht;
 	struct devlink *devlink;
 	struct work_struct fib_event_work;
+	struct work_struct fib_flush_work;
 	struct list_head fib_event_queue;
 	spinlock_t fib_event_queue_lock; /* Protects fib event queue list */
 	struct mutex nh_lock; /* Protects NH HT */
@@ -978,7 +979,7 @@ static int nsim_fib_event_schedule_work(struct nsim_fib_data *data,
 
 	fib_event = kzalloc(sizeof(*fib_event), GFP_ATOMIC);
 	if (!fib_event)
-		return NOTIFY_BAD;
+		goto err_fib_event_alloc;
 
 	fib_event->data = data;
 	fib_event->event = event;
@@ -1006,6 +1007,9 @@ static int nsim_fib_event_schedule_work(struct nsim_fib_data *data,
 
 err_fib_prepare_event:
 	kfree(fib_event);
+err_fib_event_alloc:
+	if (event == FIB_EVENT_ENTRY_DEL)
+		schedule_work(&data->fib_flush_work);
 	return NOTIFY_BAD;
 }
 
@@ -1483,6 +1487,24 @@ static void nsim_fib_event_work(struct work_struct *work)
 	mutex_unlock(&data->fib_lock);
 }
 
+static void nsim_fib_flush_work(struct work_struct *work)
+{
+	struct nsim_fib_data *data = container_of(work, struct nsim_fib_data,
+						  fib_flush_work);
+	struct nsim_fib_rt *fib_rt, *fib_rt_tmp;
+
+	/* Process pending work. */
+	flush_work(&data->fib_event_work);
+
+	mutex_lock(&data->fib_lock);
+	list_for_each_entry_safe(fib_rt, fib_rt_tmp, &data->fib_rt_list, list) {
+		rhashtable_remove_fast(&data->fib_rt_ht, &fib_rt->ht_node,
+				       nsim_fib_rt_ht_params);
+		nsim_fib_rt_free(fib_rt, data);
+	}
+	mutex_unlock(&data->fib_lock);
+}
+
 static int
 nsim_fib_debugfs_init(struct nsim_fib_data *data, struct nsim_dev *nsim_dev)
 {
@@ -1541,6 +1563,7 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 		goto err_rhashtable_nexthop_destroy;
 
 	INIT_WORK(&data->fib_event_work, nsim_fib_event_work);
+	INIT_WORK(&data->fib_flush_work, nsim_fib_flush_work);
 	INIT_LIST_HEAD(&data->fib_event_queue);
 	spin_lock_init(&data->fib_event_queue_lock);
 
@@ -1587,6 +1610,7 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 err_nexthop_nb_unregister:
 	unregister_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb);
 err_rhashtable_fib_destroy:
+	cancel_work_sync(&data->fib_flush_work);
 	flush_work(&data->fib_event_work);
 	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
 				    data);
@@ -1616,6 +1640,7 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 					    NSIM_RESOURCE_IPV4_FIB);
 	unregister_fib_notifier(devlink_net(devlink), &data->fib_nb);
 	unregister_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb);
+	cancel_work_sync(&data->fib_flush_work);
 	flush_work(&data->fib_event_work);
 	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
 				    data);
-- 
2.36.1

