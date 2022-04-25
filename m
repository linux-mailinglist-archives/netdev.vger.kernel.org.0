Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49E950D7CF
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240934AbiDYDs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240944AbiDYDsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:48:36 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2073.outbound.protection.outlook.com [40.107.212.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6096125286
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:45:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=et5+ZWvr2QaLB1Hsg67LlowsOhgwpLPSbTbWJrknJ87bRFgcKshzwLPNwN+QYMMFxmDbu1nrWCAFu5v3OMWOkABO4QEfnpKwWomjXfnqFJxjkme3yIudqiBwkehJb6poiBf4X1+vusqnRi/3aM1IhwEDFtmATsOL1bZtqWLbXW1Rnar9GsEx3Y0Me34iddHRS1gXLtvyLKy79acVZN2VsqkMsVPLFUIVbRZd8uqjYAqvUN4uXEn3KVFb5QAAxyVmrfPnTmeHNuhNQvKUkqC1rE61jF2YksSxSdn8Bva47aQaFbyRHergg1PSrE1F8A3wRx/Qnbfn92sS2sJBXVZVHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kO5Urd5MUwOvpwNYX6h7+MgLUk8cVAj3yoE41WtjoxE=;
 b=ISahMlJoAyaKsgawSe3zChAbFkFk08JD2QAxcgpQ6WlB5EN5DdomA/SE803tT6sDGghjHuUP2xxu9GLTwF0RjfmF/5ISfOjRCfyJX3kijWQByCFpWR1EeYSzx9fD/GSy6eptT0FGpnWBKhlMrWQiUkHhwAj30gbm4ee8rT/WmSHJIIlo2wOii5ESADUBcTSEAY+omEpO+vg02Vg3WJcHixJuHafV3UEyxkvM0nvYDH0ri/iRFRwiSsi1UxJ1dZfdYD1CwQubgXYYiCZahOeXiecqpWxJz6RxRQMXUYG175iisuJdznvqBnRXaW15Ey3KP1QOlNmnNqCfWU2MQJIZaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO5Urd5MUwOvpwNYX6h7+MgLUk8cVAj3yoE41WtjoxE=;
 b=UceySjWJQIpyvTVxn0zoCofhkEPTAGEwjyqAJwVv9MLDfJl1yJsOygjRiR7n/RkqcZFOT6cxxys7ESZZi7wQ7kp9ZS4i/al1I3LpLIMiGZDIQ8/hD1Hv8Q7cjpCa5N2/bY4DWDC1NO+Yorit+P1sUr03e1NrnHCNZrDNbNfLfI2zAhVaVndlcoQpmmGkpL9iDQu9AojM9+pVhFL8vvWiNJhqRwlUCnTdVA1GMPrYdVAb747MH50z/PUSG2Pi1LjkIj8ePk7uF67NsZtdbkelWSYk7wyxZuKYxWKLWEPbu6zwmErsydFROVH31Q2ja+lI0wElMBn0BaG8U8q8+5j8Cg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MWHPR1201MB0255.namprd12.prod.outlook.com (2603:10b6:301:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 03:45:30 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:45:30 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/11] devlink: introduce line card devices support
Date:   Mon, 25 Apr 2022 06:44:21 +0300
Message-Id: <20220425034431.3161260-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::45) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e5ce86f-f315-4e9f-539b-08da266e0a45
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB025599B42C182BE2E5D0C906B2F89@MWHPR1201MB0255.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5BUO1xQl9K9aGTqZdKWPwtD66du0dFvFL68JwHsWAsn77OwmfDyt9eZZwXaYK9bQxrpypfwjbjDbHbRIv6RPTYPYXlQ56t7CsAqXL6hQdTwIPeXYtUDvKYzdM5ZDm2oIq2LI2vDqoGbOPl8Va04QLog6YElSSsvlHieLrFUkxeCkI4VEwrqGeyx+Vxwg5WUMseqLWOsC7u1nQDFtGw3Qs0wnH9eyyi2ax02vdYY0CqKa+ieKIjhur42bPMyF/xmoWwW6JQENlsnoyFTElxWHfPqoqGzdWDx2GoxyqW8oSlsMKGNhnN+01C9XmZykr1ZB1LJ604KrSJJQ8fRJTKrSZsF/NjJiv1O7ubv82Kew9iujFO7lb1NapUPCGK8dMjNATH9jlyEG908mfKjYHf/b35f8DQrmcMti+PqUAUr8DE7Zv1XIullv+nvt+OHythzAhaPrtWJ3KiGqlqY8tXwGhRIHYNSCog/fwcK2mpe/pQbtgaq8lZiMIAt49lEfTUwy3COsvbJ+R6BFjlzwv4aQoOAhUdXl1GA7XKI2qFRyZNyHfl2WsHSCh7XNofjEbvB8AfLCpGcmnV6piFqJ9fJeRIhh5xcEDax+bgrcouYhzIt83p0aqj27uxXbaxeLIhZv9zeKoi31gnNGD0pVLPFPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(316002)(6486002)(508600001)(8676002)(66556008)(66476007)(86362001)(6916009)(38100700002)(66946007)(5660300002)(6666004)(6506007)(2906002)(36756003)(6512007)(83380400001)(26005)(186003)(8936002)(2616005)(1076003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jY6YiPx20NFNWuMl2KCE87AN2rcZvfbNppzMe1nDpYpnWJxAdbwhy7liW5c+?=
 =?us-ascii?Q?mJ9M+2S+LKfm9+pk6kN3qnR5dETJrAPDktgjTQGeLQOQfVrQssysuZdeaTY9?=
 =?us-ascii?Q?Z25a82h+WUpBMwTKpW76oilDy7iqobEe7oKk/NQkZ1SAxTw2tD0Z+sP1ASO4?=
 =?us-ascii?Q?vW4NgJpqP764GT2J7+EE8N/P9CzteNss39bD9GSxTEIiBrH4hkXZfSqhuPda?=
 =?us-ascii?Q?TGv72SdvgiDE3kBO2tkIZcq96sLjhjulL2sAkgeF+TvnpS2O/VdEjXyTUhNj?=
 =?us-ascii?Q?Z05GjsGOkaDS8gjDeP5ehvYSt1HtMhVPTB8Tzvna0DCX2McC2DyP7J69GNJV?=
 =?us-ascii?Q?jEPnYMZKJRYSgKv4A6t4S2lZ4umDnwwJFKhcni0qfypm6BAsieaO3UbXbxl7?=
 =?us-ascii?Q?SxNhf6oM3snQTc+6TDHi3JQXdtGeXeTgkjPkAuyYJ/+2zLponI7RWuExBCgm?=
 =?us-ascii?Q?LQ4kjQOJYlsQoTZj8gHzPjDcwIPS5UgTWp43smjCJ8cyo9LE1NUO11Ozq9YQ?=
 =?us-ascii?Q?QzI/vWEybWj+iRe/Itct+QaOYXDCxpAGnagu6LMufq+evqI6zmh749W3n5kH?=
 =?us-ascii?Q?QW/MF1Q7BGkgHBUrc4VtHERFPXxGehB4UhPpBhCLwE0X4G+hvVC1idjohE06?=
 =?us-ascii?Q?vscH7+7zmTBKVNrWdVGiCqY97l9jIv2/DpKvmqylDz9GNxoy+Bxf2FMI7qI2?=
 =?us-ascii?Q?yQ8/CQTaVpFndtyA9FF9R0MHtWecwKd3fs2vqpZAfU5GqpLTwrodAugavpdA?=
 =?us-ascii?Q?Cg56D1qtZNQz56ARzIKl2jWCkcttY3uw+DzLDvgH/Qz0AiFZqiWgJ1wyBsbc?=
 =?us-ascii?Q?kWOAKT3q0VKtTa85WIqzCFwfD0s8uIAcJwNwvJE+sZp4Q97xBhieC5W4Pgcq?=
 =?us-ascii?Q?dSelZqZjwdxnLwdYziXISDZaOSBHzqIWRj8jM9GRggCZ3c2ZkbJ0O+UA5++9?=
 =?us-ascii?Q?72fVih9DxsgovIgCeWQyosJ0f/ZSonGchJVGX5LAhMMs3btcHH7Grw30D+em?=
 =?us-ascii?Q?4SzYsNAoSws1kNNwwPULPu6Aw4YHCjS+uR9Gr2k2y92hZdbyAaA3FLSfEjrd?=
 =?us-ascii?Q?mdIEE3YYPYVOUbnqTejUOgm5y+T6+LK2m1LweurU3v1r4Dq4X+6tEQqAFBmO?=
 =?us-ascii?Q?BLa2s5TpA1nu6HIgzC1u82GHqgA/Qrd7mN/lZMCLhuBaBrt33sTRALf+thJZ?=
 =?us-ascii?Q?Xmm7M15uCS2FPSsBSN35tO21B96pNG87bg4mH5mYenxpKWTk9IIxDHmVpp6r?=
 =?us-ascii?Q?iB4eEElY9MnflwbK4IFKRdPRaP0wNYOp0Nu/7YIiBkDSj84T8yDxUDndvBP9?=
 =?us-ascii?Q?S2yxjSy57m0SzEfQjTKuvj3XBLuxqeJBzfVjqm1I20AJeP2vnAg0T1UE6fP6?=
 =?us-ascii?Q?sYxHWh+/lWDTZ4wcy9EnS81iA79hX22AqRiItV97elZjWy4USr9W985ez4gx?=
 =?us-ascii?Q?741KghuUTiuGM4Au5Bt38VEKb84r+dVbMb6XW1qcw39cCWwy2Af1CQfugJS6?=
 =?us-ascii?Q?T5c3LbWZUcgkpuXB3KXP7vbCIH+1kUhv1R435Cf6gsgx1pqpwdeBrOGGf6XL?=
 =?us-ascii?Q?IyYnz7XQ5+Zxw/u13OAKqPHQZWLbczp/V/9iFvP7oEFnr8UvZdKFl9lgJb5b?=
 =?us-ascii?Q?gFBTnUdNXntKta+I/IItPOyoyPYvE3vWfaZxn802BTeuiuKQQtAUBS7yi67J?=
 =?us-ascii?Q?LQ94+SZyic0niS2BjE/YtohJVGKwsTMhYs5XnvfLeCxhsEzrdBmy8JOmWmUb?=
 =?us-ascii?Q?ehx4P390Bw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5ce86f-f315-4e9f-539b-08da266e0a45
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:45:30.3182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LEydoeOpX1n+RQzcBV6TWqPCPywtkSkliY4Ehwi5f3FpEXMuTWvhrhPd0QRTEUenB/a+SRRTLZHG91SMPE8PJg==
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

Line card can contain one or more devices that makes sense to make
visible to the user. For example, this can be a gearbox with
flash memory, which could be updated.

Provide the driver possibility to attach such devices to a line card
and expose those to user.

Example:
$ devlink lc show pci/0000:01:00.0 lc 8
pci/0000:01:00.0:
  lc 8 state active type 16x100G
    supported_types:
      16x100G
    devices:
      device 0
      device 1
      device 2
      device 3

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/devlink.h        |   7 +++
 include/uapi/linux/devlink.h |   3 +
 net/core/devlink.c           | 104 ++++++++++++++++++++++++++++++++++-
 3 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2a2a2a0c93f7..c84b52fb9ff0 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1578,6 +1578,13 @@ struct devlink_linecard *
 devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 			const struct devlink_linecard_ops *ops, void *priv);
 void devlink_linecard_destroy(struct devlink_linecard *linecard);
+struct devlink_linecard_device;
+struct devlink_linecard_device *
+devlink_linecard_device_create(struct devlink_linecard *linecard,
+			       unsigned int device_index);
+void
+devlink_linecard_device_destroy(struct devlink_linecard *linecard,
+				struct devlink_linecard_device *linecard_device);
 void devlink_linecard_provision_set(struct devlink_linecard *linecard,
 				    const char *type);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b3d40a5d72ff..cd578645f94f 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -575,6 +575,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_STATE,		/* u8 */
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
+	DEVLINK_ATTR_LINECARD_DEVICE_LIST,	/* nested */
+	DEVLINK_ATTR_LINECARD_DEVICE,		/* nested */
+	DEVLINK_ATTR_LINECARD_DEVICE_INDEX,	/* u32 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5cc88490f18f..41d9631ceada 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -83,10 +83,11 @@ struct devlink_linecard {
 	const struct devlink_linecard_ops *ops;
 	void *priv;
 	enum devlink_linecard_state state;
-	struct mutex state_lock; /* Protects state */
+	struct mutex state_lock; /* Protects state and device_list */
 	const char *type;
 	struct devlink_linecard_type *types;
 	unsigned int types_count;
+	struct list_head device_list;
 };
 
 /**
@@ -2058,6 +2059,55 @@ struct devlink_linecard_type {
 	const void *priv;
 };
 
+struct devlink_linecard_device {
+	struct list_head list;
+	unsigned int index;
+};
+
+static int
+devlink_nl_linecard_device_fill(struct sk_buff *msg,
+				struct devlink_linecard_device *linecard_device)
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
+	nla_nest_end(msg, attr);
+
+	return 0;
+}
+
+static int devlink_nl_linecard_devices_fill(struct sk_buff *msg,
+					    struct devlink_linecard *linecard)
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
+		err = devlink_nl_linecard_device_fill(msg, linecard_device);
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
 static int devlink_nl_linecard_fill(struct sk_buff *msg,
 				    struct devlink *devlink,
 				    struct devlink_linecard *linecard,
@@ -2068,6 +2118,7 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 	struct devlink_linecard_type *linecard_type;
 	struct nlattr *attr;
 	void *hdr;
+	int err;
 	int i;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
@@ -2100,6 +2151,10 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 		nla_nest_end(msg, attr);
 	}
 
+	err = devlink_nl_linecard_devices_fill(msg, linecard);
+	if (err)
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -10264,6 +10319,7 @@ devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 	linecard->priv = priv;
 	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
 	mutex_init(&linecard->state_lock);
+	INIT_LIST_HEAD(&linecard->device_list);
 
 	err = devlink_linecard_types_init(linecard);
 	if (err) {
@@ -10291,6 +10347,7 @@ void devlink_linecard_destroy(struct devlink_linecard *linecard)
 	struct devlink *devlink = linecard->devlink;
 
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_DEL);
+	WARN_ON(!list_empty(&linecard->device_list));
 	mutex_lock(&devlink->linecards_lock);
 	list_del(&linecard->list);
 	devlink_linecard_types_fini(linecard);
@@ -10299,6 +10356,50 @@ void devlink_linecard_destroy(struct devlink_linecard *linecard)
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_destroy);
 
+/**
+ *	devlink_linecard_device_create - Create a device on linecard
+ *
+ *	@linecard: devlink linecard
+ *	@device_index: index of the linecard device
+ *
+ *	Return: Line card device structure or an ERR_PTR() encoded error code.
+ */
+struct devlink_linecard_device *
+devlink_linecard_device_create(struct devlink_linecard *linecard,
+			       unsigned int device_index)
+{
+	struct devlink_linecard_device *linecard_device;
+
+	linecard_device = kzalloc(sizeof(*linecard_device), GFP_KERNEL);
+	if (!linecard_device)
+		return ERR_PTR(-ENOMEM);
+	linecard_device->index = device_index;
+	mutex_lock(&linecard->state_lock);
+	list_add_tail(&linecard_device->list, &linecard->device_list);
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->state_lock);
+	return linecard_device;
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_device_create);
+
+/**
+ *	devlink_linecard_device_destroy - Destroy device on linecard
+ *
+ *	@linecard: devlink linecard
+ *	@linecard_device: devlink linecard device
+ */
+void
+devlink_linecard_device_destroy(struct devlink_linecard *linecard,
+				struct devlink_linecard_device *linecard_device)
+{
+	mutex_lock(&linecard->state_lock);
+	list_del(&linecard_device->list);
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->state_lock);
+	kfree(linecard_device);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_device_destroy);
+
 /**
  *	devlink_linecard_provision_set - Set provisioning on linecard
  *
@@ -10331,6 +10432,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
 {
 	mutex_lock(&linecard->state_lock);
+	WARN_ON(!list_empty(&linecard->device_list));
 	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
 	linecard->type = NULL;
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
-- 
2.33.1

