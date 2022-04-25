Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A3250D7D5
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240997AbiDYDtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbiDYDsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:48:46 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA596237C9
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:45:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ek4Kqv60K4YR4ekJzTIq9CSW83ufkxQjQcAsFH7FdkbefegDTuiolbb6H90nLntJqerdcaXld3oOtGd/lmEFg2h0R7GsDGhniBQR8JKBWhB/JenvZBteAweGVkNo0wnhksyuHafIXp0jVYPfCaOYdhZNTWJ3jm9w2WX0PIfyJZvk99nPTm5zObB9W5SafzuTAEfePQehuN+xvhlg2Gy1sLbpXC2N6hDl9IE3YoYXHKCjeHU59eo5e1fcojf1rMnJsFa4n9PDt+lJJyvC3TpDxGwOMKZBbvelSLjs2fCx4fu3rmwgN9IFruDDcYcZeRbV9hFzyy3fRhhYl8sFFnhn2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2u3csPx3GGhJt8VcMZX1wcM21evXg03DSNudL6iAa8=;
 b=aHqGZ2LDpL+/T3vdKMyZrlvYct/3uIq3kBkv0nP08jImA2AeqsEPt3lLCiGU33KyILXBb/6GQqTDTN7lNkZoemSy62VsKIDFlh89sM8Li5YXIv8bQBMz5PoQs4PMkqKl6UbE3LQ8y6boMH5GOiBzb6SQaAxKshy0jFIx2o5PbIrGLEa2pVS1nC4TettN+UkkncuX5i9c9wses62NwEcsm2fXQNr10h9YO5/2PKKDsGgStj3gARpDNHE5JEGO3LGQ5b4AR1WVazUHHmhDydmWSpag0l885LXKEcLW6Za8z4kSPFP3Mq7QodB2rLwztuFvC94SR3HmRv4vOAA/c+UxsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2u3csPx3GGhJt8VcMZX1wcM21evXg03DSNudL6iAa8=;
 b=nN9+2hifzkIWUmo7l31SBbwlE3PXqI6Gukr6sVGOH3z8X9HTb+jecNKNnqcE4v2CX5gQSR0UH/B0zjsTWP+eSWspm1WU5hZ7aORzJtMRs9OO72FrbxojK3ROJLPbr4OZXtWth6lkknehrV//vZFHIzT0TaZZR2m7nScVJRaPVFaJcGQczZFrj1c4biDRPRDRlNSx596STTBPhJfOdKI+m/3A0dX6bUn0oC10oLx5z/kH8OGXsFlniyUdsNw+ghheokOTOfIK1H1LjTpKIzk1A9b4yhn4mT7fu79bd2wguCt+OoK5qRHnHOagtJHBCdRtIXuwzmioO/p6I/KljnzZBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MWHPR1201MB0255.namprd12.prod.outlook.com (2603:10b6:301:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 03:45:42 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:45:42 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/11] devlink: introduce line card device info infrastructure
Date:   Mon, 25 Apr 2022 06:44:23 +0300
Message-Id: <20220425034431.3161260-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0128.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::26) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2794882d-3b39-4a7d-f75a-08da266e1226
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0255B705544C73510207D7E1B2F89@MWHPR1201MB0255.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfwkNFlmn7RIDC+PtuDs3u2x7m6GaeB/jdRYCkLXERNwWNKO4qmP00E5xLCSTDbpXob6w1ZY4e3WniTfF+rLPrxwXRmHcLArWuQVg2GXPihcbN85J+2RkI5jDY2Zw1kPQswg89kMJub72mDuAxwUoYA4bNkUxObfH9qm79KLFRqol1cWYie83LhB7ATSfBdkLfz/N/nwqCSuPz2M0hKKj/HhycLBsSzdjK1JeFP67Zc1kHpXayJAvK9q7B4p4x84kldddid0MrlTPB36UHsUcfnuvC8cd7OsEFOAM++L1yVSL6LNLCU6BGZ4EXS/7r5RipkYy8PPn4olecJ+QbIVtjQwFHFbA67BWu+BFj7dLXgL3H9K6m0kxcBgl53Zr+/Ojfpv41KMHwYmcQa5V5loJQX6NcBwzJrHuOS/BZffJMxTZxxUq4qDxafJw8pMHUUxgjBgxF7rSr5U0eEoElms3QgAUekwEloiJy6F9EHmsAWACzC08DTqxQ7+zZ9acnOfSyl8bKoLhuHUHQqHBs1JIDnwLkCebn1XyneNk2qouypPNsx/kbI2s3A7nGe2GQDoA/Ke9/oon9MoWkRvJQC5yhzrxfgcTkHxfuQPtmICKkxXamvwil7SQAOpvZsMG1nQxRFJmK34gpZO3HSLzZmhjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(316002)(6486002)(508600001)(8676002)(66556008)(66476007)(86362001)(6916009)(38100700002)(66946007)(5660300002)(6666004)(6506007)(2906002)(36756003)(6512007)(83380400001)(26005)(186003)(8936002)(2616005)(1076003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ORynhq5H6qPBD0pOw5SNDcWI28Dfhb0GIvhiS+XcFTwmnGgFvTrhsY6qvdAY?=
 =?us-ascii?Q?ctqpsGqacmgMLw6/o60W3FigYZA6x2mZbRJJZSmYpg8+VmY2cG2Y81asKpkB?=
 =?us-ascii?Q?uqRCimlbe4fO5BfdJIZPT3otnoTcF9DSE5XhbzzjlhsmgJtXAtb5UGtndYPS?=
 =?us-ascii?Q?RsJAL+Qx0sYMIO9b8r8sQpIvi4u+Csbe88zW3JCz8QasSVzDh2FBlA1vcZQp?=
 =?us-ascii?Q?nkh671FvYBbSXpsgMPp4tyHAADQuyFmTiJkgAqdwnKUtsGnPrHAuthMZUcPo?=
 =?us-ascii?Q?CTE8Xj2Q6vx5ekGOCMvh6GnvqJ3z88m0BaBTyI1g/Y2IoxsskgblbJ38YwTo?=
 =?us-ascii?Q?R/YWm9ojfBX2CSRxIInfSQf9GSVIfzT4okuREQB3cg9UNToMpiZ+9sVKuv4l?=
 =?us-ascii?Q?zs9IiB6xsUz1cAhX8WaejEh40ZqUdcbAvCORjSkueSPGDdsntSmSmKAFq0vz?=
 =?us-ascii?Q?xAwQxcl6IS6S9BSnk3x/gYOQd6DpWTsFNvHsSr5sFnW4O+8WzlkABF0OaEKn?=
 =?us-ascii?Q?E3weS3Q0Uqva6DuCsUdlUlWYb0rBJEnWDhg+h39ktO1j5CxRTcS0+yJTQ9Si?=
 =?us-ascii?Q?G1P45YEU/zPOlWngRkAP84Z162A42Zjz6rP3UC666FvNvDo4aOmcfz9iaJXY?=
 =?us-ascii?Q?ODzJ8gsarBTyWNPTtBjkoj/6alcTTfj7XycEfpr6+8hHP5TV5qhVoObiIDGK?=
 =?us-ascii?Q?AFuWn8FCYzGku5pirE98FyAreJ3WiIc1Hd02ADUbn5AcqIbuP9uHzlV28Vwn?=
 =?us-ascii?Q?Xh2RnI4t+RC3v5/kiNo+R5+2ZLikbHz4qqeMIs7UaxaGrW22P21i3//QKINv?=
 =?us-ascii?Q?n40HjOS3KbOu2v6Wy0NdtLeIRWuvyiks8nTGVN6Y4zlXivfv1JDK0tz2CEtQ?=
 =?us-ascii?Q?zXlO54jwPS8cdvrhp64mS6vEX7+td8n0uvdiijWaYDDf/l3K8FHOcWWD5uXL?=
 =?us-ascii?Q?bO9lW1KFML4WN+QubfNjssWpz/OViIshKrNsORyB+88djbkKLjLBp+yRzEwS?=
 =?us-ascii?Q?9wcFu44qSwtgKwH0hoZQ+qo7yhsXZtC/CyHbdCu/5s63/71AVI4KzAP2+KXE?=
 =?us-ascii?Q?8g0KautAEwLi6ke5QtKFvorcZYS95wiFvRVh7eIr9YtU+SXI2wFqR4O7Fx08?=
 =?us-ascii?Q?3dpLarP85KxbGJ2tM39Wpfw5TDrcB8ETWrgL1YyjYM5gG2VqFt5qF96l5pP3?=
 =?us-ascii?Q?IrmFz38rQrm65LHm8B8J/MvnGjh6f9rrrF0h8kuWF0GFH/Z3yBOMucmj/+qy?=
 =?us-ascii?Q?nhAqp4iTzqZuQYlctDH17GGdTACCVN/Ru3+ZD/x5JGQPMhJANMfGCAaec/XQ?=
 =?us-ascii?Q?1iSFlhGgMviGH3LBUifdrIi5p0H68umTQL7MeWrV1WiOG+ezu+ffBXBj+nr6?=
 =?us-ascii?Q?cnV/s1ggzoNpVpeNzKUj60dVeNttUKyrUL9zDtZfp33WHlE5PleaBXJEpG4X?=
 =?us-ascii?Q?f5P4/O3mq/HwxYkRujPkfx6EV2W3N+2wIE33Mxeo4o4px/kR881uS1ezj0Qf?=
 =?us-ascii?Q?z3AK8G5PltoomWhT3Ep8Tx1u+dl6X6PMxBFxvrICR1aqY4FPVVwhsi0uaUK6?=
 =?us-ascii?Q?ZClA+FckinxIDYqJ9zOgUR8RZ35mYAcumI14JuyeruWNUpqvGUCEivAGtJPC?=
 =?us-ascii?Q?m/JIo9K8HYYDX+tiT2zw15bt44CQj7419TCUet7uhSUDfrdsFm36jDL2ArUx?=
 =?us-ascii?Q?T2hZt6XuE9pYh8Qu3vU2Mu86vZ4AFOmXgB0vQOzmxc7tdbueS7RK5ahINxCt?=
 =?us-ascii?Q?LxkMTV3eQw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2794882d-3b39-4a7d-f75a-08da266e1226
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:45:42.0554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ebTkyCoIpeSg/J+D2Nys7H3UgsdyHzVfMvbfXkvK2WW+xIdTI419v83zJKNoAs5P+f5zH1mvwrqBc71bL+st2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0255
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Extend the line card info message with information (e.g., FW version)
about devices found on the line card.

Example:
$ devlink lc info pci/0000:01:00.0 lc 8
pci/0000:01:00.0:
  lc 8
    versions:
        fixed:
          hw.revision 0
        running:
          ini.version 4
    devices:
      device 0
        versions:
            running:
              fw 19.2010.1310
      device 1
        versions:
            running:
              fw 19.2010.1310
      device 2
        versions:
            running:
              fw 19.2010.1310
      device 3
        versions:
            running:
              fw 19.2010.1310

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../networking/devlink/devlink-linecard.rst   |  2 +-
 include/net/devlink.h                         |  8 ++-
 net/core/devlink.c                            | 71 ++++++++++++++++++-
 3 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-linecard.rst b/Documentation/networking/devlink/devlink-linecard.rst
index 5a8d5989702a..a98b468ad479 100644
--- a/Documentation/networking/devlink/devlink-linecard.rst
+++ b/Documentation/networking/devlink/devlink-linecard.rst
@@ -14,7 +14,7 @@ system. Following operations are provided:
   * Get a list of supported line card types.
   * Provision of a slot with specific line card type.
   * Get and monitor of line card state and its change.
-  * Get information about line card versions.
+  * Get information about line card versions and devices.
 
 Line card according to the type may contain one or more gearboxes
 to mux the lanes with certain speed to multiple ports with lanes
diff --git a/include/net/devlink.h b/include/net/devlink.h
index f96dcb376630..062895973656 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -151,6 +151,7 @@ struct devlink_port_new_attrs {
 };
 
 struct devlink_info_req;
+struct devlink_linecard_device;
 
 /**
  * struct devlink_linecard_ops - Linecard operations
@@ -171,6 +172,7 @@ struct devlink_info_req;
  * @types_count: callback to get number of supported types
  * @types_get: callback to get next type in list
  * @info_get: callback to get linecard info
+ * @device_info_get: callback to get linecard device info
  */
 struct devlink_linecard_ops {
 	int (*provision)(struct devlink_linecard *linecard, void *priv,
@@ -188,6 +190,9 @@ struct devlink_linecard_ops {
 	int (*info_get)(struct devlink_linecard *linecard, void *priv,
 			struct devlink_info_req *req,
 			struct netlink_ext_ack *extack);
+	int (*device_info_get)(struct devlink_linecard_device *device,
+			       void *priv, struct devlink_info_req *req,
+			       struct netlink_ext_ack *extack);
 };
 
 struct devlink_sb_pool_info {
@@ -1583,10 +1588,9 @@ struct devlink_linecard *
 devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 			const struct devlink_linecard_ops *ops, void *priv);
 void devlink_linecard_destroy(struct devlink_linecard *linecard);
-struct devlink_linecard_device;
 struct devlink_linecard_device *
 devlink_linecard_device_create(struct devlink_linecard *linecard,
-			       unsigned int device_index);
+			       unsigned int device_index, void *priv);
 void
 devlink_linecard_device_destroy(struct devlink_linecard *linecard,
 				struct devlink_linecard_device *linecard_device);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5facd10de64a..5f441a0e34f4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2062,6 +2062,7 @@ struct devlink_linecard_type {
 struct devlink_linecard_device {
 	struct list_head list;
 	unsigned int index;
+	void *priv;
 };
 
 static int
@@ -2428,6 +2429,68 @@ struct devlink_info_req {
 	struct sk_buff *msg;
 };
 
+static int
+devlink_nl_linecard_device_info_fill(struct sk_buff *msg,
+				     struct devlink_linecard *linecard,
+				     struct devlink_linecard_device *linecard_device,
+				     struct netlink_ext_ack *extack)
+{
+	struct nlattr *attr;
+
+	attr = nla_nest_start(msg, DEVLINK_ATTR_LINECARD_DEVICE);
+	if (!attr)
+		return -EMSGSIZE;
+	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_DEVICE_INDEX,
+			linecard_device->index)) {
+		nla_nest_cancel(msg, attr);
+		return -EMSGSIZE;
+	}
+	if (linecard->ops->device_info_get) {
+		struct devlink_info_req req;
+		int err;
+
+		req.msg = msg;
+		err = linecard->ops->device_info_get(linecard_device,
+						     linecard_device->priv,
+						     &req, extack);
+		if (err) {
+			nla_nest_cancel(msg, attr);
+			return err;
+		}
+	}
+	nla_nest_end(msg, attr);
+
+	return 0;
+}
+
+static int devlink_nl_linecard_devices_info_fill(struct sk_buff *msg,
+						 struct devlink_linecard *linecard,
+						 struct netlink_ext_ack *extack)
+{
+	struct devlink_linecard_device *linecard_device;
+	struct nlattr *attr;
+	int err;
+
+	if (list_empty(&linecard->device_list))
+		return 0;
+
+	attr = nla_nest_start(msg, DEVLINK_ATTR_LINECARD_DEVICE_LIST);
+	if (!attr)
+		return -EMSGSIZE;
+	list_for_each_entry(linecard_device, &linecard->device_list, list) {
+		err = devlink_nl_linecard_device_info_fill(msg, linecard,
+							   linecard_device,
+							   extack);
+		if (err) {
+			nla_nest_cancel(msg, attr);
+			return err;
+		}
+	}
+	nla_nest_end(msg, attr);
+
+	return 0;
+}
+
 static int
 devlink_nl_linecard_info_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_linecard *linecard,
@@ -2453,6 +2516,10 @@ devlink_nl_linecard_info_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
+	err = devlink_nl_linecard_devices_info_fill(msg, linecard, extack);
+	if (err)
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -10483,12 +10550,13 @@ EXPORT_SYMBOL_GPL(devlink_linecard_destroy);
  *
  *	@linecard: devlink linecard
  *	@device_index: index of the linecard device
+ *	@priv: user priv pointer
  *
  *	Return: Line card device structure or an ERR_PTR() encoded error code.
  */
 struct devlink_linecard_device *
 devlink_linecard_device_create(struct devlink_linecard *linecard,
-			       unsigned int device_index)
+			       unsigned int device_index, void *priv)
 {
 	struct devlink_linecard_device *linecard_device;
 
@@ -10496,6 +10564,7 @@ devlink_linecard_device_create(struct devlink_linecard *linecard,
 	if (!linecard_device)
 		return ERR_PTR(-ENOMEM);
 	linecard_device->index = device_index;
+	linecard_device->priv = priv;
 	mutex_lock(&linecard->state_lock);
 	list_add_tail(&linecard_device->list, &linecard->device_list);
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
-- 
2.33.1

