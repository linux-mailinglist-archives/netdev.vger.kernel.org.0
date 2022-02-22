Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928CE4BF6F6
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiBVLIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiBVLIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:08:09 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1902CB6D01;
        Tue, 22 Feb 2022 03:07:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3J9GIta6yMIXZQ3Vcq+9Vxdg2/tOxBFrfFHj9kfXparDtTItCSCrlqHdAfvRaCyBcTBMKXgeKkdVsSdMh0FQXzfrUU1VIQswPDAr9m14wujjtzyt6X618kgGNSu2PxmPC1dBoK3CLuHLZeFTlFdc2P0PWqmn2UNrJtYEjn3LuP9tkZM482yUnE4xrXuXaJqCH/ys/2isInl8JlXyzcyJgPfUm3wO9br8F384r24yGto+UKEHCX2T7ky/v6uyGm9Too8+OHq1k5VJTcJAAe1j5WO08JAlpwsuW046RqWD7zSiTfqtRL/e93jY+axX0F9h8+fC/SHJDm7X0EEzU4CKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMJd7HpZsjDU4WSJBWmdc3agHDtbQz7Z3yngAULUUg8=;
 b=fYvsM6lG8aAsKiHrLBmaqRq12Wbq5XL87/IaWiR5FqJ3pUT8W+na8cV4zp//EOmKir84sR5kNpIV3EnGlXWczfH/0Pgl2oDiLJRHEfhcuymKnazc8flRGPLnqAZdPLx3ZwJ+OhR4BdWVg4auoWHSZ6qQr4Zh3ZGt6zzv1J8x/7QD9sCK8+3r6K+PbpWsAAj8ghcWT2bBsUwFw0oe3ok5OWPMzsk1vMVQ220UnJgclaUDvir8VSR8IobqO852cqfaEsLlhx2Qjt1RuqO/xqBcyk/lpYsRXtOWcAmaqaCUORja4IfWkMzRY3xRSM7UeKG0ClRZVGjAMmQ3AkbuT8adNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMJd7HpZsjDU4WSJBWmdc3agHDtbQz7Z3yngAULUUg8=;
 b=AKQYM8AaMQAfSDhkA+6fGzJ8IsxPluB7egk3+o+jTDK4Hdoj9GJc0rc35maY8EXfYLWrjpsofN9d2UHJ08HvuCDQFUD7V2Cv9hy1dlTui7lFw1PjTzgOWGEUQSEsQghoKq8Ea03zS0VQ23esH/DAmZC6QxzdWgkZEGytVxyD5VRcgbJciPUAYI0U8TXSIkNweSEOHkAre5aJwVm6L/e4L3jCI5RxQqv2v58tsHY+R6XHOQngL4ytOl43bU5PEReUITnbc4u380LI2cvh8r245nx5Qjw0Xo7s5oUtQXVwg5o4blDei5iaqt4ST1N815bk0DTk1r0ZNFzyJVg+uMq6bw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MWHPR12MB1310.namprd12.prod.outlook.com (2603:10b6:300:a::21)
 by DM6PR12MB5552.namprd12.prod.outlook.com (2603:10b6:5:1bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 22 Feb
 2022 11:07:40 +0000
Received: from MWHPR12MB1310.namprd12.prod.outlook.com
 ([fe80::5165:db44:70d5:1c2a]) by MWHPR12MB1310.namprd12.prod.outlook.com
 ([fe80::5165:db44:70d5:1c2a%11]) with mapi id 15.20.4995.027; Tue, 22 Feb
 2022 11:07:40 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, parav@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 2/4] devlink: Add support for NLA_BITFIELD for devlink param
Date:   Tue, 22 Feb 2022 12:58:10 +0200
Message-Id: <20220222105812.18668-3-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220222105812.18668-1-shayd@nvidia.com>
References: <20220222105812.18668-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0201CA0002.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::12) To MWHPR12MB1310.namprd12.prod.outlook.com
 (2603:10b6:300:a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8669a79-eb9e-492e-e0cf-08d9f5f38a97
X-MS-TrafficTypeDiagnostic: DM6PR12MB5552:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55524967A846944373F7C00FCF3B9@DM6PR12MB5552.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 73CiVa3a4wSUv1+uxmCTd4rZw0U+v4OfVYU62x0yxUpPU9Djv9obwKEfUdvDlKYS8ljgRlw7TtQlkTBcdc5g1APSoU6w7tQy0a62vtZniJRU3qCzXKK69WHpLkUHIKzTaqDclsOJ3lam8JOHpHZh1K5/C4W4nmzmhOUEB7ZM2TRRSst9r5ose78WSrLcITRqklVUNQVRkOM44NMiO9BkYTvN5Go4HWCKSKCIJLcR6abvlYzp1pavIf92i5+bu80xbPsmxHfip9dANMKjsf1ZOIpJzcPzUGyMQSFUKBWl7cR31BStJv/tOcGY8WN8Reec00lLkBt8aYAp87wte4OpuUf2XLfzOgdrZPqlkGRXh8S3vzW0Zt1d8R58/jeisKZX/DJxbd4lCTBIZZ5jiFUIz/napBP7LQZ/aGR4e0lUAJEJtjCMVQO6X3XJ327Zc5qpJcUjDWCd7JEKtJtVVKbgXXXwb7abJ1PabAlt/GvP3VfeWds4WsDHivEeOFvAUufEbnKF0qw8sV681v1Rp7oC0p7xnZEXssgqirfmrQglAhLF9HFqa26AThRdKxuuBVI/H5mrR3aTyYoELdZ7LMo7Xc1UTNehYdZDAAjUTktcpFK1XZLATkt/y2YIX9VzpkoWby5atblNTE3H3Jt+hLRAHvuEU8LcuSJ4aYR2LioiGUfYoRI6MxH6RF3o4DLdO5X+myy5HqkROavle4WR/dirYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1310.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(36756003)(508600001)(30864003)(5660300002)(6486002)(86362001)(8936002)(316002)(54906003)(8676002)(66476007)(66556008)(4326008)(66946007)(1076003)(2616005)(107886003)(83380400001)(186003)(6666004)(6512007)(6506007)(52116002)(2906002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VMJqxik/7Ilv1AEY5J1gkrBYs/yYk4To54MqU7XErphb1I9P5hwup4G4IO2s?=
 =?us-ascii?Q?4sU89ycA09ZYL0/x7cla7a47ZThs61f8DtCMm4KOpWn7ws4tPQuciu8yBMhj?=
 =?us-ascii?Q?O7DO9EWwtTuWvocAF5rPuKIKIiVn6B43qbdknK08QBGjs+rfk5YGKPDYRH7W?=
 =?us-ascii?Q?vcxiDW9p9YKEsVCY4JrM1n0iSCPBaLS8aiwWrEIqlhzsyBcXTIR2+5uNPgaQ?=
 =?us-ascii?Q?2XK7/N8ci3AepfCDAmTyR1E4bpnirhr49cJzQAzHGCyWrcBsbZL02bygdBu9?=
 =?us-ascii?Q?p9VOCJPxxpE+/nGmiAdu2HehyxncIupQEjal/hAS5QU9sDapOImvgTeK1pSQ?=
 =?us-ascii?Q?ZHfVmrHG0lFA8ldrgQ0bWToKiXJrHGwZKzCxFNTE1C3/WLsPPY5jQR2u33dL?=
 =?us-ascii?Q?pV8y7EMacHX70Ejfdca66Q3lxSae3HGDTblYRNYlGjEFzUfmRc6lT7xzMOZE?=
 =?us-ascii?Q?vuNtNQs1WbQrqUHhIlzsWLJ6hL0hG0dvsceo6EO+qJqarWN+2Ppeoy4nFxUA?=
 =?us-ascii?Q?Fk+DepoERrSFgIBAG7FDVuUmVmf5jejaGzmA8j1af357fIq39bdi5mjIKmxf?=
 =?us-ascii?Q?kT1pR+VsvsZoM0AF+47vgZ8kOuxXZ00M0HZYfOh2dL9LX4G70yCDpn3V3PXr?=
 =?us-ascii?Q?hj185TjHa4Fof/w09iECkzy+u3A6ZdbcK5ViJQZMX0Eq3VOZhC/olTLkxd2e?=
 =?us-ascii?Q?WxBam0ndp8GRLumtMPMUZ0do3SZPovBZtyxoPHtH6NrBZDQQcMjRFHYpWADk?=
 =?us-ascii?Q?XAOAfalvZq/+qo9MK0VqFdqgncz5UaeXuE0xOPu5XRtMwwvBTLo9QxQC5w7W?=
 =?us-ascii?Q?gZfKZf4PImC2AcqiKDas69Y6HbCCZdyeb8SMXh7dP0R5gdyYPYib6z5doHyM?=
 =?us-ascii?Q?wB9IbSY3EZfaBlPEzcvbf1C0YcTso9kieV2uW5/2Id7LvC4ckaeDYJiWM7Tz?=
 =?us-ascii?Q?RO1CAh8KD0C0FdhGJ7g/J2YwRD4d7MEk4KD/lnrOtZPgPDDKx+oeXhRwi2KX?=
 =?us-ascii?Q?Xq8I18TnAh4pLDiB2RV8SvNqBz4sHZbo3p8k76lln9ShIXk1H0FmW2Rdbj17?=
 =?us-ascii?Q?SxlDo6hr8o3GcgBQZn01dz7ifKZ0G3i2meOAiwtFMsKz/P1UYveJXjK1RGBU?=
 =?us-ascii?Q?U8F0BeiYa4PBteMnyZJO86In8MRegNIsn3XSgybgVtSaN1JGW3MC4ylqqkDp?=
 =?us-ascii?Q?GVIQus6qa2P3QUtWecgSPXmW8Iy+jGawvY3XZZnJDEyr100gLMoco/KBTDft?=
 =?us-ascii?Q?gVm049o1JdLRMcUOVnRN4pDgq0DJwatnak72EA384ucWUbsESfUFv9n9E2Ac?=
 =?us-ascii?Q?wYQA5XpSgAprj1rutwT4dPjrO6k/iYc0RSNsfzmOIawm++g34HmVyH0pbDnV?=
 =?us-ascii?Q?OFUTix08uaHRw9afYyLcodDyn1AnmoZUFdn9ql2qcGBOiFUppNhVeURdT6w+?=
 =?us-ascii?Q?Mzt/93Yv3ArnHt/c4BzIhbUGODRhFkqqD/gCiITMkRrqFGT/aTrePLQDEhnJ?=
 =?us-ascii?Q?Rm8M97KsoWWaWG1cB1Fxw8S+jQNpFWFffC7IEq0PE92s1WPqhjMmfokungBE?=
 =?us-ascii?Q?uxPcgNEEvI9XlbDF5GkWK7BDSrb0mHi3+0AwZCUyZpyvSVDNsrcuSz5t3qsY?=
 =?us-ascii?Q?mxnoybIigGXnY8YKFwUGMy0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8669a79-eb9e-492e-e0cf-08d9f5f38a97
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1310.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 11:07:40.3046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1L12tXIPvdAEjJFTk+Iq0Bd+EJbadbawEvunHeKBvUw4r7WmpYb5F1uDOBdgzfc8rmiKdJY62AycECPAPLmyyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5552
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink support for param of type NLA_BITFIELD.
kernel user need to provide a bitmap to devlink.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 include/net/devlink.h |  18 ++++++
 net/core/devlink.c    | 138 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 139 insertions(+), 17 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8d5349d2fb68..f411482f716d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -372,6 +372,7 @@ enum devlink_param_type {
 	DEVLINK_PARAM_TYPE_U32,
 	DEVLINK_PARAM_TYPE_STRING,
 	DEVLINK_PARAM_TYPE_BOOL,
+	DEVLINK_PARAM_TYPE_BITFIELD,
 };
 
 union devlink_param_value {
@@ -380,6 +381,7 @@ union devlink_param_value {
 	u32 vu32;
 	char vstr[__DEVLINK_PARAM_MAX_STRING_VALUE];
 	bool vbool;
+	unsigned long *vbitmap;
 };
 
 struct devlink_param_gset_ctx {
@@ -412,6 +414,8 @@ struct devlink_flash_notify {
  * @generic: indicates if the parameter is generic or driver specific
  * @type: parameter type
  * @supported_cmodes: bitmap of supported configuration modes
+ * @nbits: number of bits this param need to use, if this param is
+ *         of dynamic len.
  * @get: get parameter value, used for runtime and permanent
  *       configuration modes
  * @set: set parameter value, used for runtime and permanent
@@ -427,6 +431,7 @@ struct devlink_param {
 	bool generic;
 	enum devlink_param_type type;
 	unsigned long supported_cmodes;
+	u64 nbits;
 	int (*get)(struct devlink *devlink, u32 id,
 		   struct devlink_param_gset_ctx *ctx);
 	int (*set)(struct devlink *devlink, u32 id,
@@ -542,6 +547,19 @@ enum devlink_param_generic_id {
 	.validate = _validate,						\
 }
 
+#define DEVLINK_PARAM_DYNAMIC_GENERIC(_id, _cmodes, _get, _set, _validate, _nbits)\
+{									\
+	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
+	.name = DEVLINK_PARAM_GENERIC_##_id##_NAME,			\
+	.type = DEVLINK_PARAM_GENERIC_##_id##_TYPE,			\
+	.generic = true,						\
+	.supported_cmodes = _cmodes,					\
+	.nbits = _nbits,						\
+	.get = _get,							\
+	.set = _set,							\
+	.validate = _validate,						\
+}
+
 /* Part number, identifier of board design */
 #define DEVLINK_INFO_VERSION_GENERIC_BOARD_ID	"board.id"
 /* Revision of board design */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index fcd9f6d85cf1..3d7e27abc487 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4568,6 +4568,8 @@ devlink_param_type_to_nla_type(enum devlink_param_type param_type)
 		return NLA_STRING;
 	case DEVLINK_PARAM_TYPE_BOOL:
 		return NLA_FLAG;
+	case DEVLINK_PARAM_TYPE_BITFIELD:
+		return NLA_BITFIELD;
 	default:
 		return -EINVAL;
 	}
@@ -4575,11 +4577,13 @@ devlink_param_type_to_nla_type(enum devlink_param_type param_type)
 
 static int
 devlink_nl_param_value_fill_one(struct sk_buff *msg,
-				enum devlink_param_type type,
+				const struct devlink_param *param,
 				enum devlink_param_cmode cmode,
 				union devlink_param_value val)
 {
 	struct nlattr *param_value_attr;
+	struct nla_bitfield *bitfield;
+	int err;
 
 	param_value_attr = nla_nest_start_noflag(msg,
 						 DEVLINK_ATTR_PARAM_VALUE);
@@ -4589,7 +4593,7 @@ devlink_nl_param_value_fill_one(struct sk_buff *msg,
 	if (nla_put_u8(msg, DEVLINK_ATTR_PARAM_VALUE_CMODE, cmode))
 		goto value_nest_cancel;
 
-	switch (type) {
+	switch (param->type) {
 	case DEVLINK_PARAM_TYPE_U8:
 		if (nla_put_u8(msg, DEVLINK_ATTR_PARAM_VALUE_DATA, val.vu8))
 			goto value_nest_cancel;
@@ -4612,6 +4616,17 @@ devlink_nl_param_value_fill_one(struct sk_buff *msg,
 		    nla_put_flag(msg, DEVLINK_ATTR_PARAM_VALUE_DATA))
 			goto value_nest_cancel;
 		break;
+	case DEVLINK_PARAM_TYPE_BITFIELD:
+		bitfield = nla_bitfield_alloc(param->nbits);
+		if (!bitfield)
+			return -ENOMEM;
+		nla_bitfield_from_bitmap(bitfield, val.vbitmap, param->nbits);
+		err = nla_put_bitfield(msg, DEVLINK_ATTR_PARAM_VALUE_DATA,
+				       bitfield);
+		nla_bitfield_free(bitfield);
+		if (err)
+			goto value_nest_cancel;
+		break;
 	}
 
 	nla_nest_end(msg, param_value_attr);
@@ -4623,6 +4638,24 @@ devlink_nl_param_value_fill_one(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int devlink_param_value_get(const struct devlink_param *param,
+				   union devlink_param_value *value)
+{
+	if (param->type == DEVLINK_PARAM_TYPE_BITFIELD) {
+		value->vbitmap = bitmap_zalloc(param->nbits, GFP_KERNEL);
+		if (!value->vbitmap)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+static void devlink_param_value_put(const struct devlink_param *param,
+				    union devlink_param_value *value)
+{
+	if (param->type == DEVLINK_PARAM_TYPE_BITFIELD)
+		bitmap_free(value->vbitmap);
+}
+
 static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 				 unsigned int port_index,
 				 struct devlink_param_item *param_item,
@@ -4645,14 +4678,22 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 		if (!devlink_param_cmode_is_supported(param, i))
 			continue;
 		if (i == DEVLINK_PARAM_CMODE_DRIVERINIT) {
-			if (!param_item->driverinit_value_valid)
-				return -EOPNOTSUPP;
+			if (!param_item->driverinit_value_valid) {
+				err = -EOPNOTSUPP;
+				goto param_value_put;
+			}
 			param_value[i] = param_item->driverinit_value;
 		} else {
 			ctx.cmode = i;
-			err = devlink_param_get(devlink, param, &ctx);
+			err = devlink_param_value_get(param, &param_value[i]);
 			if (err)
-				return err;
+				goto param_value_put;
+			ctx.val = param_value[i];
+			err = devlink_param_get(devlink, param, &ctx);
+			if (err) {
+				devlink_param_value_put(param, &param_value[i]);
+				goto param_value_put;
+			}
 			param_value[i] = ctx.val;
 		}
 		param_value_set[i] = true;
@@ -4660,7 +4701,7 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
 	if (!hdr)
-		return -EMSGSIZE;
+		goto genlmsg_put_err;
 
 	if (devlink_nl_put_handle(msg, devlink))
 		goto genlmsg_cancel;
@@ -4693,10 +4734,13 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 	for (i = 0; i <= DEVLINK_PARAM_CMODE_MAX; i++) {
 		if (!param_value_set[i])
 			continue;
-		err = devlink_nl_param_value_fill_one(msg, param->type,
+		err = devlink_nl_param_value_fill_one(msg, param,
 						      i, param_value[i]);
 		if (err)
 			goto values_list_nest_cancel;
+		if (i != DEVLINK_PARAM_CMODE_DRIVERINIT)
+			devlink_param_value_put(param, &param_value[i]);
+		param_value_set[i] = false;
 	}
 
 	nla_nest_end(msg, param_values_list);
@@ -4710,7 +4754,13 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 	nla_nest_cancel(msg, param_attr);
 genlmsg_cancel:
 	genlmsg_cancel(msg, hdr);
-	return -EMSGSIZE;
+genlmsg_put_err:
+	err = -EMSGSIZE;
+param_value_put:
+	for (i = 0; i <= DEVLINK_PARAM_CMODE_MAX; i++)
+		if (i != DEVLINK_PARAM_CMODE_DRIVERINIT && param_value_set[i])
+			devlink_param_value_put(param, &param_value[i]);
+	return err;
 }
 
 static void devlink_param_notify(struct devlink *devlink,
@@ -4815,6 +4865,9 @@ devlink_param_type_get_from_info(struct genl_info *info,
 	case NLA_FLAG:
 		*param_type = DEVLINK_PARAM_TYPE_BOOL;
 		break;
+	case NLA_BITFIELD:
+		*param_type = DEVLINK_PARAM_TYPE_BITFIELD;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -4827,6 +4880,7 @@ devlink_param_value_get_from_info(const struct devlink_param *param,
 				  struct genl_info *info,
 				  union devlink_param_value *value)
 {
+	struct nla_bitfield *bitfield;
 	struct nlattr *param_data;
 	int len;
 
@@ -4863,6 +4917,18 @@ devlink_param_value_get_from_info(const struct devlink_param *param,
 			return -EINVAL;
 		value->vbool = nla_get_flag(param_data);
 		break;
+	case DEVLINK_PARAM_TYPE_BITFIELD:
+		bitfield = nla_data(param_data);
+
+		if (!nla_bitfield_len_is_valid(bitfield, nla_len(param_data)) ||
+		    !nla_bitfield_nbits_valid(bitfield, param->nbits))
+			return -EINVAL;
+		value->vbitmap = bitmap_zalloc(param->nbits, GFP_KERNEL);
+		if (!value->vbitmap)
+			return -ENOMEM;
+
+		nla_bitfield_to_bitmap(value->vbitmap, bitfield);
+		break;
 	}
 	return 0;
 }
@@ -4936,33 +5002,48 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 	if (param->validate) {
 		err = param->validate(devlink, param->id, value, info->extack);
 		if (err)
-			return err;
+			goto out;
 	}
 
-	if (!info->attrs[DEVLINK_ATTR_PARAM_VALUE_CMODE])
-		return -EINVAL;
+	if (!info->attrs[DEVLINK_ATTR_PARAM_VALUE_CMODE]) {
+		err = -EINVAL;
+		goto out;
+	}
 	cmode = nla_get_u8(info->attrs[DEVLINK_ATTR_PARAM_VALUE_CMODE]);
-	if (!devlink_param_cmode_is_supported(param, cmode))
-		return -EOPNOTSUPP;
+	if (!devlink_param_cmode_is_supported(param, cmode)) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 
 	if (cmode == DEVLINK_PARAM_CMODE_DRIVERINIT) {
 		if (param->type == DEVLINK_PARAM_TYPE_STRING)
 			strcpy(param_item->driverinit_value.vstr, value.vstr);
+		else if (param->type == DEVLINK_PARAM_TYPE_BITFIELD)
+			bitmap_copy(param_item->driverinit_value.vbitmap,
+				    value.vbitmap,
+				    param_item->param->nbits);
 		else
 			param_item->driverinit_value = value;
 		param_item->driverinit_value_valid = true;
 	} else {
-		if (!param->set)
-			return -EOPNOTSUPP;
+		if (!param->set) {
+			err = -EOPNOTSUPP;
+			goto out;
+		}
 		ctx.val = value;
 		ctx.cmode = cmode;
 		err = devlink_param_set(devlink, param, &ctx);
 		if (err)
-			return err;
+			goto out;
 	}
 
+	devlink_param_value_put(param, &value);
 	devlink_param_notify(devlink, port_index, param_item, cmd);
 	return 0;
+
+out:
+	devlink_param_value_put(param, &value);
+	return err;
 }
 
 static int devlink_nl_cmd_param_set_doit(struct sk_buff *skb,
@@ -10098,6 +10179,8 @@ static int devlink_param_verify(const struct devlink_param *param)
 {
 	if (!param || !param->name || !param->supported_cmodes)
 		return -EINVAL;
+	if (param->type == DEVLINK_PARAM_TYPE_BITFIELD && !param->nbits)
+		return -EINVAL;
 	if (param->generic)
 		return devlink_param_generic_verify(param);
 	else
@@ -10188,6 +10271,16 @@ int devlink_param_register(struct devlink *devlink,
 		return -ENOMEM;
 
 	param_item->param = param;
+	if (param_item->param->type == DEVLINK_PARAM_TYPE_BITFIELD &&
+	    devlink_param_cmode_is_supported(param_item->param,
+					     DEVLINK_PARAM_CMODE_DRIVERINIT)) {
+		param_item->driverinit_value.vbitmap =
+			bitmap_zalloc(param_item->param->nbits, GFP_KERNEL);
+		if (!param_item->driverinit_value.vbitmap) {
+			kfree(param_item);
+			return -ENOMEM;
+		}
+	}
 
 	list_add_tail(&param_item->list, &devlink->param_list);
 	return 0;
@@ -10210,6 +10303,10 @@ void devlink_param_unregister(struct devlink *devlink,
 		devlink_param_find_by_name(&devlink->param_list, param->name);
 	WARN_ON(!param_item);
 	list_del(&param_item->list);
+	if (param_item->param->type == DEVLINK_PARAM_TYPE_BITFIELD &&
+	    devlink_param_cmode_is_supported(param_item->param,
+					     DEVLINK_PARAM_CMODE_DRIVERINIT))
+		bitmap_free(param_item->driverinit_value.vbitmap);
 	kfree(param_item);
 }
 EXPORT_SYMBOL_GPL(devlink_param_unregister);
@@ -10244,6 +10341,10 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 
 	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
 		strcpy(init_val->vstr, param_item->driverinit_value.vstr);
+	else if (param_item->param->type == DEVLINK_PARAM_TYPE_BITFIELD)
+		bitmap_copy(init_val->vbitmap,
+			    param_item->driverinit_value.vbitmap,
+			    param_item->param->nbits);
 	else
 		*init_val = param_item->driverinit_value;
 
@@ -10280,6 +10381,9 @@ int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 
 	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
 		strcpy(param_item->driverinit_value.vstr, init_val.vstr);
+	else if (param_item->param->type == DEVLINK_PARAM_TYPE_BITFIELD)
+		bitmap_copy(param_item->driverinit_value.vbitmap,
+			    init_val.vbitmap, param_item->param->nbits);
 	else
 		param_item->driverinit_value = init_val;
 	param_item->driverinit_value_valid = true;
-- 
2.21.3

