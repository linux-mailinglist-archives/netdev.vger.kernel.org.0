Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537DC43A67C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhJYW1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:23 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:7454
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233759AbhJYW1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+qYZbh4nDh5Dm8flJpJ3F2lh9zwC765EdUjyEfikCeqnfOtqQQhLF039GyygcM2mk1/9ERuo6zkYhKTHV5tUhZCkBnrtdSbtB1hNdLs7CVCGYeKXUavY7kJIeqORCyTb7wrtQ3xBoTpGc9zIe1Mj2teuhJlLLRnV2NG+E6nME60SgWhhKiHjAIZ/LtRaplQAQhVhw242z8M2RK/s6TYTamNl1e73HhMo5Zs90gYuoXf6HCwnv96JTkY/CV2UIC5bXyBDMFl+dPbPQYoV1tDmJ4ogqoAVDPQ/RstDFV5po51qasdkwmptgdMz88ksbIVBik0/g2XuPyYlaQQlWvO2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ew8BnMjb1NGykesIdXB+F7l0GMj6JY3gcwgG36dvWPY=;
 b=F7lePxlJcKisEisPLCtuFYV0I2klO17jI6rDo21jJv9akgo+R61cVyJI0wOLU15OxkHgSyMlA+KIw5jgZ7kxqyovAxs4tYBCFMhMuQJsh/JUR0URUr958OMr3rUFfeDSzIFDby8dK9sbKMzRl6Pd8SHmibIwuIRMrujTBROmh1RtDknzK4SjrHAl6zS6+nMYe/6UkWrJQLVXUWcxLihH5Q+eOB1IvCeTTSzOtZt7ohC+S1WdZqQbni+bAGttoaTVGArMC/0PucMYZifxfk745dqB1wnzE39EBKJ9ceqQ4BsEGn5xstC4EY7rqLsC3HBDEfXW2HSU9OHP6tlgvGvYuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ew8BnMjb1NGykesIdXB+F7l0GMj6JY3gcwgG36dvWPY=;
 b=Dj3+ahq8uGJfrYD5TDaB8GVUQPBlBLKbuBj5hhNuEJevLpE01Stqlitz893J4A+ufkBeStxTbbUnBCvFW+WZyauF8hQTgUro7TMx2bgRd2RWcwPK+ol1xt8y+bf91po0I0ktHoWG9Qol8vuU3mXw/rtkxqTEuFltILFA/IO9R7A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:41 +0000
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
Subject: [RFC PATCH net-next 10/15] net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
Date:   Tue, 26 Oct 2021 01:24:10 +0300
Message-Id: <20211025222415.983883-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cecd0c6a-9a51-4768-3674-08d998063d54
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23043DEDF5AFBC662357AB95E0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TLZaHUb8fbbDz9sFsofobDGqLyaX42FcIBPmaytaZxL7v2H7Y+7TpYeSonG977pz/aKQ8j9HDUaxs1uy5Xvl4D19cbmG/ikRSVM8J2RAGzNHMfwbA4m9GND46Tr0Lph+ijl72ip2H+UcRTzWpjU8+CFCoXmfrvF64nhmcJRF3GP68WHNo9duE3SmY8PRRQSZpOJUjjc+3kyeEgmDDG7bdwOfoFp3YITGTkskGaTsLnw6SAn8mAWtlfKBDpxUZ/taFYTVJkzuZnBidIr4enIoRZ7sMeoOKYed5j5JY9vTM6UuUE8aHWOidmOT9U7h060VcByMWF3HNNjCh8QHaP/dj4zukgFfkrpRIHhLhdRfU/XN8nXmaeltTS1O9PrZ62EOewPVYdA8exw+fXEfH6+jCx6kjoBaGYbh/8ubjCQHUBkEdyZKKInubogWIC9h8At92LyStOEJMlIqjzJFAhyG6xZkb4qXbdr9IK2dfN5w9XYWjbFILqbJXbWjliENHaSdb/8u9jWckfWEG9znum/RRtbjmhpRLWdffMF2ByZvHV21pCP1PJ80/eD6H13CROCefF94NvCVzf+ZnT7uDao2mP3OucHYeVkY/JSAQ5pDqNipx4u9v2EyXRDrqkVKKkoNAAD4/C/gglL/pmdCKp18m10AqlfPvBU3gL5iYjY2kwANmxFzyUdg880WDE6fPcZ8V61imBJmomvByF7X6scpUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(30864003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hQqFTT6vjvnPEMu0ZDHle3WYfyB1xoUfOO3h+bxVJtgCYRzv4GHWu1C1hBMK?=
 =?us-ascii?Q?4/1EuDpCuQmDx7SeIb5yTM/Dp52zJu0Vj36cPMKfnDI8gosyxctC0F1u6ReX?=
 =?us-ascii?Q?PcDT2B9siZcDKcxV8NZLh2ew/Y5YgsvTod/blLbZPWmHLn2bMFT90ufjwxVX?=
 =?us-ascii?Q?xFbz1GH6UtqopKqHTJvLPwa8BM7U73XY8AHyNVmV3IowkfK6LY2iKZ3vjXzJ?=
 =?us-ascii?Q?HESV2SeupO43Ej0RLY7HQEnA2V/rDZjaxMT6eSVdzilEPwPC8ZydzF+58/ax?=
 =?us-ascii?Q?KxZ8HcW+YAXv7/qQSMpB/I2duqbSIq0ddpixfPUmOm5CqaYRgHLI5o7CgHW3?=
 =?us-ascii?Q?L01bIY9wxa6qcbfFdaKnoTn9BzzeOFfiM387xEYJgr2oAO8n8VMpB7HyvqJo?=
 =?us-ascii?Q?Bib+/0i1ZOors1FtFKjNBacpq5EmkYQzsSby7Zcoo5WncLRB76fYuv9bPLtE?=
 =?us-ascii?Q?y+6JM/xTd4D8RGpu1ql05Aya1pa5UxmM6+VKyHD3hgrbIz3qKRS1EOTQjxWX?=
 =?us-ascii?Q?WZz8MNJcbNqHe9d3nlDhn/BYFYOoIl7BjHB6qmVMkGZwM7+dwEdL0H84bVhR?=
 =?us-ascii?Q?w9+D9yDGzjUji0wb3yXk4di8dtPAiFdhSWNVR20TWgU9oWfjuH5qRekCpCZY?=
 =?us-ascii?Q?39ug7Pw5S9NFa8DqjpQtMVpFLBw7H0ke/+N6LyOUsaPC9mDErlyj7jVDk2/3?=
 =?us-ascii?Q?BEVhmZri+m/KYBmPokvBk9ox2MAtgE6dmft7SIcPvPorlCTrTkwF0W6NvIrT?=
 =?us-ascii?Q?yYxr+l3DUXq9afj22VA9+mcq8IBPK3Q4g4EqeV+hMCNSIcIkoYCrKOAMeRg2?=
 =?us-ascii?Q?KdVJ8M1lzeczV4uECvGfQbC4dooUfumUr1K0iROE0Jzr3y2ztwwEcZWUTYJ6?=
 =?us-ascii?Q?fR0rzJzL5gFGFiy4l0a4QLHfAD53CBO9KYzagrdRcjNxTte8mrI6O3Xasi0d?=
 =?us-ascii?Q?bLrqgbr6wOmzoGub0A8FGGHbtyYQl0pRA9ZALLgNFoqAvk4y1NBVUcaZzGDq?=
 =?us-ascii?Q?IUGQjhCwz0EgWnU6HXs0XKShMItoJEjlUgFll6ncUCZSuqNdaBQgpPLOOhpk?=
 =?us-ascii?Q?q4deJMjrxSU+qWnDyKhKvtjjiYo+vHTFyfnrGggfq98GGvWKdT7UdyC8MNpD?=
 =?us-ascii?Q?w9+fPmw/ihYEENSroHiz50ttvDY4Z8Fn1fG7isHHup1qFGJC8BdjA3p8CzQc?=
 =?us-ascii?Q?LcBqaLmsARhyyisPcyS2OSD+2mE06I6fAh+QqQ7lSQFcnO29kGpT8G/d3bfj?=
 =?us-ascii?Q?ctMMo0pz6pnHRHxFCIWMxwYX66rfsBymIU2jIFQqH9xnbqdhxSYHCA3JXSv/?=
 =?us-ascii?Q?Vm1E57b5OkklDspvlIT2a8UuC+HBIr40cnsTVEUFZc+NNTXdbVhRVhIFErDj?=
 =?us-ascii?Q?E6WLphKAGrQU5JRQgFyAKgvyFkplJuLU/8NdNxSUSbF/h6M1r/0oeVv8uywY?=
 =?us-ascii?Q?2yVfG3PsH++I5n0x1R3l1AMAetyUpaHKDusTcuK6df/UcMVWBxGEkYgl/l4r?=
 =?us-ascii?Q?/z+bVDCPKCdoNzUq1pO7+ptS7WqgKOnvBW+U7vFEzkHO6vSEuwDkW009YHXQ?=
 =?us-ascii?Q?mzIUgfITsMaq+F8EcPyuUqdi4Ki8CD0LzaF4v+hZZ6wxduRB8uy7PzGzcEGE?=
 =?us-ascii?Q?mKsJBv2IgRo3VoCkgLJcZzQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cecd0c6a-9a51-4768-3674-08d998063d54
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:41.7189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TaO5780qdu0pEexByhraF6aUrdrJ+LxXj7z+BwUOVW1g4ovuxvXnYplLlL/z9xt03ZjgxzFNI/2HmSeW8V4srQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reduce code churn, the same patch makes multiple changes, since they
all touch the same lines:

1. The implementations for these two are identical, just with different
   function pointers. Reduce duplications and name the function pointers
   "mod_cb" instead of "add_cb" and "del_cb". Pass the event as argument.

2. Drop the "const" attribute from "orig_dev". If the driver needs to
   check whether orig_dev belongs to itself and then
   call_switchdev_notifiers(orig_dev, SWITCHDEV_FDB_OFFLOADED), it
   can't, because call_switchdev_notifiers takes a non-const struct
   net_device *.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h   |  48 +++---------
 net/dsa/slave.c           |  41 ++--------
 net/switchdev/switchdev.c | 156 ++++++--------------------------------
 3 files changed, 43 insertions(+), 202 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 6764fb7692e2..559f63abc15b 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -299,28 +299,16 @@ void switchdev_port_fwd_mark_set(struct net_device *dev,
 				 struct net_device *group_dev,
 				 bool joining);
 
-int switchdev_handle_fdb_add_to_device(struct net_device *dev,
+int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
 		bool (*check_cb)(const struct net_device *dev),
 		bool (*foreign_dev_check_cb)(const struct net_device *dev,
 					     const struct net_device *foreign_dev),
-		int (*add_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
+		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+			      unsigned long event, const void *ctx,
 			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_add_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info));
-
-int switchdev_handle_fdb_del_to_device(struct net_device *dev,
-		const struct switchdev_notifier_fdb_info *fdb_info,
-		bool (*check_cb)(const struct net_device *dev),
-		bool (*foreign_dev_check_cb)(const struct net_device *dev,
-					     const struct net_device *foreign_dev),
-		int (*del_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_del_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
+		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+				  unsigned long event, const void *ctx,
 				  const struct switchdev_notifier_fdb_info *fdb_info));
 
 int switchdev_handle_port_obj_add(struct net_device *dev,
@@ -426,32 +414,16 @@ call_switchdev_blocking_notifiers(unsigned long val,
 }
 
 static inline int
-switchdev_handle_fdb_add_to_device(struct net_device *dev,
-		const struct switchdev_notifier_fdb_info *fdb_info,
-		bool (*check_cb)(const struct net_device *dev),
-		bool (*foreign_dev_check_cb)(const struct net_device *dev,
-					     const struct net_device *foreign_dev),
-		int (*add_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_add_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
-{
-	return 0;
-}
-
-static inline int
-switchdev_handle_fdb_del_to_device(struct net_device *dev,
+switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
 		bool (*check_cb)(const struct net_device *dev),
 		bool (*foreign_dev_check_cb)(const struct net_device *dev,
 					     const struct net_device *foreign_dev),
-		int (*del_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
+		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+			      unsigned long event, const void *ctx,
 			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_del_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
+		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+				  unsigned long event, const void *ctx,
 				  const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	return 0;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 54d53e18a211..af573d16dff5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2469,10 +2469,9 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
 }
 
 static int dsa_slave_fdb_event(struct net_device *dev,
-			       const struct net_device *orig_dev,
-			       const void *ctx,
-			       const struct switchdev_notifier_fdb_info *fdb_info,
-			       unsigned long event)
+			       struct net_device *orig_dev,
+			       unsigned long event, const void *ctx,
+			       const struct switchdev_notifier_fdb_info *fdb_info)
 {
 	struct dsa_switchdev_event_work *switchdev_work;
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -2528,24 +2527,6 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	return 0;
 }
 
-static int
-dsa_slave_fdb_add_to_device(struct net_device *dev,
-			    const struct net_device *orig_dev, const void *ctx,
-			    const struct switchdev_notifier_fdb_info *fdb_info)
-{
-	return dsa_slave_fdb_event(dev, orig_dev, ctx, fdb_info,
-				   SWITCHDEV_FDB_ADD_TO_DEVICE);
-}
-
-static int
-dsa_slave_fdb_del_to_device(struct net_device *dev,
-			    const struct net_device *orig_dev, const void *ctx,
-			    const struct switchdev_notifier_fdb_info *fdb_info)
-{
-	return dsa_slave_fdb_event(dev, orig_dev, ctx, fdb_info,
-				   SWITCHDEV_FDB_DEL_TO_DEVICE);
-}
-
 /* Called under rcu_read_lock() */
 static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
@@ -2560,18 +2541,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		err = switchdev_handle_fdb_add_to_device(dev, ptr,
-							 dsa_slave_dev_check,
-							 dsa_foreign_dev_check,
-							 dsa_slave_fdb_add_to_device,
-							 NULL);
-		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		err = switchdev_handle_fdb_del_to_device(dev, ptr,
-							 dsa_slave_dev_check,
-							 dsa_foreign_dev_check,
-							 dsa_slave_fdb_del_to_device,
-							 NULL);
+		err = switchdev_handle_fdb_event_to_device(dev, event, ptr,
+							   dsa_slave_dev_check,
+							   dsa_foreign_dev_check,
+							   dsa_slave_fdb_event,
+							   NULL);
 		return notifier_from_errno(err);
 	default:
 		return NOTIFY_DONE;
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 0b2c18efc079..83460470e883 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -428,17 +428,17 @@ switchdev_lower_dev_find(struct net_device *dev,
 	return switchdev_priv.lower_dev;
 }
 
-static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
-		const struct net_device *orig_dev,
+static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
+		struct net_device *orig_dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
 		bool (*check_cb)(const struct net_device *dev),
 		bool (*foreign_dev_check_cb)(const struct net_device *dev,
 					     const struct net_device *foreign_dev),
-		int (*add_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
+		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+			      unsigned long event, const void *ctx,
 			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_add_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
+		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+				  unsigned long event, const void *ctx,
 				  const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	const struct switchdev_notifier_info *info = &fdb_info->info;
@@ -447,17 +447,17 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev))
-		return add_cb(dev, orig_dev, info->ctx, fdb_info);
+		return mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
 
 	if (netif_is_lag_master(dev)) {
 		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
 			goto maybe_bridged_with_us;
 
 		/* This is a LAG interface that we offload */
-		if (!lag_add_cb)
+		if (!lag_mod_cb)
 			return -EOPNOTSUPP;
 
-		return lag_add_cb(dev, orig_dev, info->ctx, fdb_info);
+		return lag_mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
 	}
 
 	/* Recurse through lower interfaces in case the FDB entry is pointing
@@ -481,10 +481,10 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 						      foreign_dev_check_cb))
 				continue;
 
-			err = __switchdev_handle_fdb_add_to_device(lower_dev, orig_dev,
-								   fdb_info, check_cb,
-								   foreign_dev_check_cb,
-								   add_cb, lag_add_cb);
+			err = __switchdev_handle_fdb_event_to_device(lower_dev, orig_dev,
+								     event, fdb_info, check_cb,
+								     foreign_dev_check_cb,
+								     mod_cb, lag_mod_cb);
 			if (err && err != -EOPNOTSUPP)
 				return err;
 		}
@@ -503,140 +503,34 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
 		return 0;
 
-	return __switchdev_handle_fdb_add_to_device(br, orig_dev, fdb_info,
-						    check_cb, foreign_dev_check_cb,
-						    add_cb, lag_add_cb);
+	return __switchdev_handle_fdb_event_to_device(br, orig_dev, event, fdb_info,
+						      check_cb, foreign_dev_check_cb,
+						      mod_cb, lag_mod_cb);
 }
 
-int switchdev_handle_fdb_add_to_device(struct net_device *dev,
+int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
 		bool (*check_cb)(const struct net_device *dev),
 		bool (*foreign_dev_check_cb)(const struct net_device *dev,
 					     const struct net_device *foreign_dev),
-		int (*add_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
+		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+			      unsigned long event, const void *ctx,
 			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_add_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
+		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+				  unsigned long event, const void *ctx,
 				  const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	int err;
 
-	err = __switchdev_handle_fdb_add_to_device(dev, dev, fdb_info,
-						   check_cb,
-						   foreign_dev_check_cb,
-						   add_cb, lag_add_cb);
+	err = __switchdev_handle_fdb_event_to_device(dev, dev, event, fdb_info,
+						     check_cb, foreign_dev_check_cb,
+						     mod_cb, lag_mod_cb);
 	if (err == -EOPNOTSUPP)
 		err = 0;
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(switchdev_handle_fdb_add_to_device);
-
-static int __switchdev_handle_fdb_del_to_device(struct net_device *dev,
-		const struct net_device *orig_dev,
-		const struct switchdev_notifier_fdb_info *fdb_info,
-		bool (*check_cb)(const struct net_device *dev),
-		bool (*foreign_dev_check_cb)(const struct net_device *dev,
-					     const struct net_device *foreign_dev),
-		int (*del_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_del_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
-{
-	const struct switchdev_notifier_info *info = &fdb_info->info;
-	struct net_device *br, *lower_dev;
-	struct list_head *iter;
-	int err = -EOPNOTSUPP;
-
-	if (check_cb(dev))
-		return del_cb(dev, orig_dev, info->ctx, fdb_info);
-
-	if (netif_is_lag_master(dev)) {
-		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
-			goto maybe_bridged_with_us;
-
-		/* This is a LAG interface that we offload */
-		if (!lag_del_cb)
-			return -EOPNOTSUPP;
-
-		return lag_del_cb(dev, orig_dev, info->ctx, fdb_info);
-	}
-
-	/* Recurse through lower interfaces in case the FDB entry is pointing
-	 * towards a bridge device.
-	 */
-	if (netif_is_bridge_master(dev)) {
-		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
-			return 0;
-
-		/* This is a bridge interface that we offload */
-		netdev_for_each_lower_dev(dev, lower_dev, iter) {
-			/* Do not propagate FDB entries across bridges */
-			if (netif_is_bridge_master(lower_dev))
-				continue;
-
-			/* Bridge ports might be either us, or LAG interfaces
-			 * that we offload.
-			 */
-			if (!check_cb(lower_dev) &&
-			    !switchdev_lower_dev_find(lower_dev, check_cb,
-						      foreign_dev_check_cb))
-				continue;
-
-			err = __switchdev_handle_fdb_del_to_device(lower_dev, orig_dev,
-								   fdb_info, check_cb,
-								   foreign_dev_check_cb,
-								   del_cb, lag_del_cb);
-			if (err && err != -EOPNOTSUPP)
-				return err;
-		}
-
-		return 0;
-	}
-
-maybe_bridged_with_us:
-	/* Event is neither on a bridge nor a LAG. Check whether it is on an
-	 * interface that is in a bridge with us.
-	 */
-	br = netdev_master_upper_dev_get_rcu(dev);
-	if (!br || !netif_is_bridge_master(br))
-		return 0;
-
-	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
-		return 0;
-
-	return __switchdev_handle_fdb_del_to_device(br, orig_dev, fdb_info,
-						    check_cb, foreign_dev_check_cb,
-						    del_cb, lag_del_cb);
-}
-
-int switchdev_handle_fdb_del_to_device(struct net_device *dev,
-		const struct switchdev_notifier_fdb_info *fdb_info,
-		bool (*check_cb)(const struct net_device *dev),
-		bool (*foreign_dev_check_cb)(const struct net_device *dev,
-					     const struct net_device *foreign_dev),
-		int (*del_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_del_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
-{
-	int err;
-
-	err = __switchdev_handle_fdb_del_to_device(dev, dev, fdb_info,
-						   check_cb,
-						   foreign_dev_check_cb,
-						   del_cb, lag_del_cb);
-	if (err == -EOPNOTSUPP)
-		err = 0;
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(switchdev_handle_fdb_del_to_device);
+EXPORT_SYMBOL_GPL(switchdev_handle_fdb_event_to_device);
 
 static int __switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
-- 
2.25.1

