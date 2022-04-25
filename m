Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E53450D7D3
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240990AbiDYDtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240960AbiDYDsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:48:41 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2083.outbound.protection.outlook.com [40.107.212.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F932237C9
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:45:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGLr5nMdgOlSbZLAL02EWLdW6r3+mlvrrd8c76b6zJMg+PDhgUDIfcu3BucDA9KYVYJipXAUl4j5aIfUuVLu9lDl4cUoOJUWteyyulhasfq08wB8TzcNLL3GmPgoIIvh7POyBOzwj/hOxQzVlcNHflox+gHbPGPSgoT/hfRLapzm6ORSNRVHKCVIdH6p+K/cV4fVvajUqnlKsRzDchL+BTDOoQTJmlXHuqA4jx5MyqeNENBVtw2JZAO45sfUEQaahLg+axcaS+lNYxtN3mLeqZkmzh8coQraG0GHaFxL/lVUGr7NcnPxCCs/qYC8pL4QE4jC5Jps+ENy148epX3ZSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+gRZ+10ew3xWcyfm2EImPREj/Eu7LADHERqH0CdUXg=;
 b=Yl2aa7C+SvkVKv7GX7nLuozfQ2jnFtcmj6liMhUzirhZjUiodlUGW4CvSmZMYvV4m40eOL+UKE5C8y3J5PzndgZaOZUP+2Glqw03cGsUNTgu0gfonD3PDatO8iMaCrQVfiCm0RPUeqcf2rGX3SekChzd24r2LP5YlBc8ZOGg6C3rJ2Rhdh/rdXcxuD4ZkfxYIAblGEKjl4jiLUo5M1cSxuJ2+M+wthDJR3LRX1eJJSivZsedlGha5zD4tdtUJYzzxWcL8F+rcdf/2dyVWkLOpqipGBlYED6vNH+WrwjSybyWIfMz4zgGiSkHql74bfwmWGNaCwnZimQkw1YqNhohwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+gRZ+10ew3xWcyfm2EImPREj/Eu7LADHERqH0CdUXg=;
 b=ZgBECQN+NrMnOErs7gepEQGkJ2Jxl27XezNxyWxPjWpdiig70lOHI0HIMpSb7gNZ2vtjqeXc+otUHnjARu2w0aHnxGPmUH7byDKYCV47sjTzDa4lYgruAyfhvW3haPbJpZdn6Kd5ank80pZovGUunrAf3BvfXjd/8bnhbLSEl1k4QVa/LgJSDdZ39VGbpmwVGoXBi3ptvufFOCkFwvnu6qdd+d1xhMph0O1Q2o7tKW8KgrUFNGDp0rmV/XXlJWUnHzac7B+aXpq2czuJm4z5Quz6CDzJU2zO3NPqO6ivuVpZW6HAlmTX5aqM7eTpkaoS+FNw6Y7/CMPdDo9ECtRa2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MWHPR1201MB0255.namprd12.prod.outlook.com (2603:10b6:301:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 03:45:36 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:45:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/11] devlink: introduce line card info get message
Date:   Mon, 25 Apr 2022 06:44:22 +0300
Message-Id: <20220425034431.3161260-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0253.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::26) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff48d5d1-b10f-4ae6-6b3f-08da266e0eb9
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0255663B03624A85FA8CA1D6B2F89@MWHPR1201MB0255.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yjg1mQk55OjlgDz4IFgL5+6mdRLb8dj3gtiHD4alfTEeZlQi4bKWGUfmhidEgrd2O1AtuVhyvIRpPB+CTRfQYq5jIv8n6jYTBZRYGmzdAn2hZMSwNVwCDIyMikTsQad1E7jDVXYYIzTRSWr2nL1tU6Ltl7Hx1zULRO2pW0x4OgLfb/Y48HYbGZIlgBEQLKUGgJqDHeRPn/SVcZLAgN6DpV5TnNp8MlvgCfFlvL6wg6OPxfSLrl53ek0TlGdDtAHaZy7cegV2hZJtTK5sPrH0c8p/Q5scu/i4kwZFXQZU6MGmgU0uuMuTudlyZtV4JWqZKENb77fS+bZ/MAkFnmvOC7+gblX5kSqn57SoaJZ28m1sFOzC40XoT9tOgGjOdeUfnKJRL32R5gzOj2Th+1ByNWcCQ00bsUkTYVp5HlHwb93XN1Xgzojomwh4JAPoKBkjhIFDn796JAYFp5Oldrw4TPId1ZiBu5p/d9dCds6d7YG4Ls9AS9XKozlbDlbUcXBFprzF7GS/KkubM0WMK1mbmkIrxfvTthceCHerbmhM9jsuAZ71m2mBi6CvZ4a2e/YJPAtXxprbo/4wPosqYFLj7ZKTHicXrNAc8W6y6/hIhNuL6bySMjXq0+4ynCvxsgnuA/RFYivodk1YALtH0YvWmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(316002)(6486002)(508600001)(8676002)(66556008)(66476007)(86362001)(6916009)(38100700002)(66946007)(5660300002)(15650500001)(6666004)(6506007)(2906002)(36756003)(6512007)(83380400001)(26005)(186003)(8936002)(2616005)(1076003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iAvC2JYe7j7Qbu4Y6W0RRt4/tcbTDxcsMx3NsX51IwGVQz6wrcSkjFep17XT?=
 =?us-ascii?Q?nIjBk+XnTPmYRvRoeqiULkLwbmxg6k9D67LlMLXAQaffXgp6ozrbDMUI3KXg?=
 =?us-ascii?Q?0hrwP+bL7s0IYx44Irc2TWgngUGdW7oYfroA3hIXsc295bZrkHa72PqRHqPV?=
 =?us-ascii?Q?ccUuhYbjgF73BXIechE5Eh09HB6wAiATCgMK4Hnxki0e2a5TbaohcNZyW4LB?=
 =?us-ascii?Q?EOyqoPE9Y2aXrBVolSChPIIi3WV/Ro0MketWdFZkSx7PTj4gGE/Sr89zO/oC?=
 =?us-ascii?Q?v9S9MKxCSYuzclt+cuIWCnYXk0g9ggNtXdFnJ9SGoXDU7zAzUcHI0EPY7VMX?=
 =?us-ascii?Q?x7v7IGzdkXB6RUxAnbcYOuM1iOPcobDRS7AArttzwiMxnGGs7PkbDsjYNu2g?=
 =?us-ascii?Q?S/Idp7h5XTw92HX+PGf/JvHSjX2W9dO5XK8h/LESbxqPuEgdslYvsTi3h32U?=
 =?us-ascii?Q?6/UaZaak/ptyGKTRRcG39RRyUSIwQE3VCpHr5SCS6lWU9/MLo/EM31b5oCSS?=
 =?us-ascii?Q?A4zsORapNHdkaNfqMd4KTZPZOcPx7mXKN3vGgAcc9yNTpt3sa9vItXZ1DZ3Y?=
 =?us-ascii?Q?+cYyDZgWCFh66kDZFaW5eWBipzyYyoHe6IsVb+giTpg+x4nc8fTSuRzUsdHd?=
 =?us-ascii?Q?h9pO7OHVCM4HmNbd/yISB2mlDMPd2ePwv78NtSuYbV8QHO/wB/AYuH3ICbqj?=
 =?us-ascii?Q?/3Zkap068bOxZzwJRKy0VRg5jPs8SRli1Kp4XikYqvsKzJk15zUzeiEAMYj1?=
 =?us-ascii?Q?1A97AiUWh6d9tZxV7AzjxLbNTu7lTbwz3NICHB5Dn5JxNZ7G5NjhX6VV9mZg?=
 =?us-ascii?Q?QuIEx1GUcACCuO7K7DtwGxihv7ZvQ5+8648KXU37SpaFuWdAZ7InP6lWYBKW?=
 =?us-ascii?Q?Np3qvoXyY5NMKUhp+e4FSkvF3IGd7fmeet1lsDxfe8Uvh4WOutvgkYmAiksU?=
 =?us-ascii?Q?3oZ0JPaZuAA4M3BVhgENq+hNTZGCIKGj2tLnrzkiaTz029NuIdFgDcEFH8XK?=
 =?us-ascii?Q?Om8SuowdqJYRDuHjXJoIgQIS3S11LHmvlyxeYwm9XFrIAbyiBnzom/5tGTJN?=
 =?us-ascii?Q?fzsN7NqHImLPzqItCg8HeYzNpFMQdQP5NEEV1WNl7OGcjmbfV+t2dnf6JeY3?=
 =?us-ascii?Q?caVLnjBjArSXP+nKGjRNjl9+Zh6BWfBG0L6Pu86O2TIMOcf5uX4Jr2XzxdPJ?=
 =?us-ascii?Q?WKJ+lfMI5MZ/Hlw3am0HPeos7Z/XhzeQCNjft84dgm1VqOLa4aVV28hz8YtB?=
 =?us-ascii?Q?0a37VF7aDRkS+7aAx6fneTIcZegOCvjhjd7U6aW2IHagX7ElwaQ4mvBRVQ7V?=
 =?us-ascii?Q?/yPhnzxU4pW8PZdT8v0NwcUuPDBDa27rc4Fs7cZZw9lWmJwl1hGt58gNaFr0?=
 =?us-ascii?Q?KWly52RBmZYiBkW5jZq5dQFbT3zeYJ/Xiazjm5fzi/r7sznyJEd+B5ChkePc?=
 =?us-ascii?Q?lo/BdlJdmniYqsVwxwW9l2qNWC2zes9N85wDsf+YcZNgIWjFnsZBkK6VjvtZ?=
 =?us-ascii?Q?fsCgqyJMxwnxyiHj7I0PkvA6zwYoGR9yUeXk62VNq1zMzCq41ihOtKHfTpG+?=
 =?us-ascii?Q?4N+mnaiEUUouDRcg9T7GqQnInfdRopaOyhCZoikLa2A+uuqCbxIjs0oIJuUv?=
 =?us-ascii?Q?7VN7m68UfoufH0zZlZ5FlPt2znWNaFf88VlTYfj4X1kJEwYCwF0zqQrni7dx?=
 =?us-ascii?Q?grwf8+EcWhCk7gduuAQ80kponuHhDcrlUxxoz/+Qj7lAf+ZsbOZkE0u71I/s?=
 =?us-ascii?Q?rRtKwp8D6Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff48d5d1-b10f-4ae6-6b3f-08da266e0eb9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:45:36.3820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FoR5qqm3hj0WLWdmTmrq/l/3D+TRGDOtmBKtVjnWJq4Gb/CSogDmk1nQV37sN4KC3a8jQ+kTFsB0k14z4Ey/8w==
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

Allow the driver to provide per line card info get op to fill-up info,
similar to the "devlink dev info".

Example:

$ devlink lc info pci/0000:01:00.0 lc 8
pci/0000:01:00.0:
  lc 8
    versions:
        fixed:
          hw.revision 0
        running:
          ini.version 4

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../networking/devlink/devlink-linecard.rst   |   4 +
 include/net/devlink.h                         |   7 +-
 include/uapi/linux/devlink.h                  |   2 +
 net/core/devlink.c                            | 130 +++++++++++++++++-
 4 files changed, 138 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-linecard.rst b/Documentation/networking/devlink/devlink-linecard.rst
index 6c0b8928bc13..5a8d5989702a 100644
--- a/Documentation/networking/devlink/devlink-linecard.rst
+++ b/Documentation/networking/devlink/devlink-linecard.rst
@@ -14,6 +14,7 @@ system. Following operations are provided:
   * Get a list of supported line card types.
   * Provision of a slot with specific line card type.
   * Get and monitor of line card state and its change.
+  * Get information about line card versions.
 
 Line card according to the type may contain one or more gearboxes
 to mux the lanes with certain speed to multiple ports with lanes
@@ -120,3 +121,6 @@ Example usage
 
     # Set slot 8 to be unprovisioned:
     $ devlink lc set pci/0000:01:00.0 lc 8 notype
+
+    # Set info for slot 8:
+    $ devlink lc info pci/0000:01:00.0 lc 8
diff --git a/include/net/devlink.h b/include/net/devlink.h
index c84b52fb9ff0..f96dcb376630 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -150,6 +150,8 @@ struct devlink_port_new_attrs {
 	   sfnum_valid:1;
 };
 
+struct devlink_info_req;
+
 /**
  * struct devlink_linecard_ops - Linecard operations
  * @provision: callback to provision the linecard slot with certain
@@ -168,6 +170,7 @@ struct devlink_port_new_attrs {
  *                  provisioned.
  * @types_count: callback to get number of supported types
  * @types_get: callback to get next type in list
+ * @info_get: callback to get linecard info
  */
 struct devlink_linecard_ops {
 	int (*provision)(struct devlink_linecard *linecard, void *priv,
@@ -182,6 +185,9 @@ struct devlink_linecard_ops {
 	void (*types_get)(struct devlink_linecard *linecard,
 			  void *priv, unsigned int index, const char **type,
 			  const void **type_priv);
+	int (*info_get)(struct devlink_linecard *linecard, void *priv,
+			struct devlink_info_req *req,
+			struct netlink_ext_ack *extack);
 };
 
 struct devlink_sb_pool_info {
@@ -628,7 +634,6 @@ struct devlink_flash_update_params {
 #define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
 
 struct devlink_region;
-struct devlink_info_req;
 
 /**
  * struct devlink_region_ops - Region operations
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cd578645f94f..fb8c3864457f 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -136,6 +136,8 @@ enum devlink_command {
 	DEVLINK_CMD_LINECARD_NEW,
 	DEVLINK_CMD_LINECARD_DEL,
 
+	DEVLINK_CMD_LINECARD_INFO_GET,		/* can dump */
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 41d9631ceada..5facd10de64a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2424,6 +2424,125 @@ static int devlink_nl_cmd_linecard_set_doit(struct sk_buff *skb,
 	return 0;
 }
 
+struct devlink_info_req {
+	struct sk_buff *msg;
+};
+
+static int
+devlink_nl_linecard_info_fill(struct sk_buff *msg, struct devlink *devlink,
+			      struct devlink_linecard *linecard,
+			      enum devlink_command cmd, u32 portid,
+			      u32 seq, int flags, struct netlink_ext_ack *extack)
+{
+	struct devlink_info_req req;
+	void *hdr;
+	int err;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	err = -EMSGSIZE;
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX, linecard->index))
+		goto nla_put_failure;
+
+	req.msg = msg;
+	err = linecard->ops->info_get(linecard, linecard->priv, &req, extack);
+	if (err)
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return err;
+}
+
+static int devlink_nl_cmd_linecard_info_get_doit(struct sk_buff *skb,
+						 struct genl_info *info)
+{
+	struct devlink_linecard *linecard = info->user_ptr[1];
+	struct devlink *devlink = linecard->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	if (!linecard->ops->info_get)
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	mutex_lock(&linecard->state_lock);
+	err = devlink_nl_linecard_info_fill(msg, devlink, linecard,
+					    DEVLINK_CMD_LINECARD_INFO_GET,
+					    info->snd_portid, info->snd_seq, 0,
+					    info->extack);
+	mutex_unlock(&linecard->state_lock);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int devlink_nl_cmd_linecard_info_get_dumpit(struct sk_buff *msg,
+						   struct netlink_callback *cb)
+{
+	struct devlink_linecard *linecard;
+	struct devlink *devlink;
+	int start = cb->args[0];
+	unsigned long index;
+	int idx = 0;
+	int err = 0;
+
+	mutex_lock(&devlink_mutex);
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
+		if (!devlink_try_get(devlink))
+			continue;
+
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			goto retry;
+
+		mutex_lock(&devlink->linecards_lock);
+		list_for_each_entry(linecard, &devlink->linecard_list, list) {
+			if (idx < start || !linecard->ops->info_get) {
+				idx++;
+				continue;
+			}
+			mutex_lock(&linecard->state_lock);
+			err = devlink_nl_linecard_info_fill(msg, devlink, linecard,
+							    DEVLINK_CMD_LINECARD_INFO_GET,
+							    NETLINK_CB(cb->skb).portid,
+							    cb->nlh->nlmsg_seq,
+							    NLM_F_MULTI,
+							    cb->extack);
+			mutex_unlock(&linecard->state_lock);
+			if (err) {
+				mutex_unlock(&devlink->linecards_lock);
+				devlink_put(devlink);
+				goto out;
+			}
+			idx++;
+		}
+		mutex_unlock(&devlink->linecards_lock);
+retry:
+		devlink_put(devlink);
+	}
+out:
+	mutex_unlock(&devlink_mutex);
+
+	if (err != -EMSGSIZE)
+		return err;
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -6416,10 +6535,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-struct devlink_info_req {
-	struct sk_buff *msg;
-};
-
 int devlink_info_driver_name_put(struct devlink_info_req *req, const char *name)
 {
 	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME, name);
@@ -9139,6 +9254,13 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
 	},
+	{
+		.cmd = DEVLINK_CMD_LINECARD_INFO_GET,
+		.doit = devlink_nl_cmd_linecard_info_get_doit,
+		.dumpit = devlink_nl_cmd_linecard_info_get_dumpit,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
+		/* can be retrieved by unprivileged users */
+	},
 	{
 		.cmd = DEVLINK_CMD_SB_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-- 
2.33.1

