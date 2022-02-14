Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236084B43FA
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbiBNIVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:21:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiBNIVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:21:05 -0500
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40129.outbound.protection.outlook.com [40.107.4.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31CD25C41;
        Mon, 14 Feb 2022 00:20:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwxKnOp55LI8YQXZiRNaCra/Q9CUQ6N3mpU9grilAbCFgL7hLMfKAOO1kDWr4yS4eKyBcXsBnsxxFKmQR6qHHEYMTkJLM8nyeMiF+hLEKtb1mzR3QNaT7B1fq0Gx95XiTFNC6pkShEOqA+yN0pRBFl8SOMd8lHruprNotO6hJaQ7yyaKv9Nps1nbOz1DKEgFYoSY5HsVBYyr8WZbD8EFfr73PZPMExA+NU6RPZrlq78uD4N/Uvzg65uuU9pSeNFmP0CEwHXa0J7fzEwvtaJ2ERxlhAuP7FG4ifQgSo7n1cRkmFgUq7IFCzIK3NT0RT5rNsHuLD1Fb0rfCAaBkNw77A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSoJfhUludLp4n3BBdE1L/ig+J/C3R6yhChRVDcjIpQ=;
 b=iqyPRPnU+pe8A5HezdrtzqSNb5p/+Q0G74YVSvyR3s4wl69AES+gFxNVnPOUHhc0WOuEMbS65+J/owO8MxcGU1t8RumVPimFKN1H88JubOOM6JvhmbkzPjCbefug/yEGsSPZqRlbA5sUar0cysW5IkIo5j+GGJ+vWgwucF4gCQM5bK6vesWUqE9L5Xw5LLj/Sg2Vxlyy3bQBmlESnHNBHO6g19rjpyJzhZlAMvabTYJDyvvnyibytl7m6dX3CfbdPocJKctxaNPxdHOH6hhekBbIygAVruD+cBiH2Lp2ucQcwc4+d52xqzPkUEzn4gdcsz9WNg05E8XOSgEvOF6StA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSoJfhUludLp4n3BBdE1L/ig+J/C3R6yhChRVDcjIpQ=;
 b=Xeb7KhS+gKLXBz+0bH/Ogvlk2C9dVelkbFRu9nc2Q3hLEDTOupdiXTnG/Tx/l5Hj8D0xGMI3UkmX8RJu2h6h9aHBXs0tO8VWtnCXomd0ggLKKgskX4AxMuLT9EKoVrYNqsGeeWOWLpzgViDJarordp1EmKAo/OdQRp+0ZiixmEU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by AM9P190MB1524.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 08:20:50 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::f16c:7fde:c692:f911]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::f16c:7fde:c692:f911%5]) with mapi id 15.20.4975.018; Mon, 14 Feb 2022
 08:20:50 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: prestera: acl: add multi-chain support offload
Date:   Mon, 14 Feb 2022 10:20:06 +0200
Message-Id: <1644826807-15770-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::14) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fa290bb-a58f-4361-c4e1-08d9ef92e8c4
X-MS-TrafficTypeDiagnostic: AM9P190MB1524:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1524A7B855C88AEC7363A7E98F339@AM9P190MB1524.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vHmrHVS1wU0kpMBj5zeDpPMM9MY94neovNKH3zKEytNbhNagN8CkDNTarUb7QPgkd0yvaGQh2epaANMSWsWg+NnQAbmkLdMWHCiTvo2N9n2MdALhatVQFZSM5pp6zvSUO4GSV+zil/ywoZghfd6SHLdpWBx+2+fyqt1ZltKAribCwbaDdMjoFhCRL+mHRlVdlUlo0hze2Wg8U2D6dFdb+gBXiDNk85VHaPxDKM/squ7fKwbjIJ6Y4XcGwz0OmN7ODPBq2fZ2BL6PIDFaVtYqDLjJOCLrhwQRFm9PdozL9Xuqw8E9Ng5qEjwvFR58WZsrG7se6dlJN5o6uy5LeUtDC32wlVLpMqQX9Kf8834PA4vzMNlA0oQikb6dUvvkLqBD1X4ibVTIL6i+HxFUfCMev+NkDIY8qyp1LtCJS1fZ3P06R+B6q8ToR2qcDRyPM+A0EZHYEHRL7Q8DVsfnaLil33L0eyOI0HGlD05CZi07KE2w4SAOgslR8YGuJ4Z5Npcw3+BVkLlLRpkxt7vsN9KliWxCbvMH1NFIefefVpDb4YUk/JiEmCtHcvwn1AlTpkS4Ix5liYmC6yLYpAuMtVFyIDIDun92pSJvYtXcJ6K38/wPorepddEOFqzbDjHqFoSgdXwfUuJEaNiUhngbniHJBD7R4Rs1zu6FMpw148ykW4RTID03xgKs/KxF0sfTrEgHCc3SB2LuAA+HStnBXn57Kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(396003)(136003)(39830400003)(376002)(346002)(366004)(54906003)(44832011)(316002)(86362001)(186003)(6916009)(2616005)(2906002)(30864003)(66476007)(66556008)(5660300002)(26005)(6486002)(6666004)(8936002)(6506007)(66946007)(83380400001)(38100700002)(38350700002)(508600001)(36756003)(52116002)(4326008)(6512007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e7eCwKyjqkRolyJfJc/xYTr/65dV4q9VXmSBzCQt8AKZ0xDxqm0KjDeWosvl?=
 =?us-ascii?Q?QQtX4swsSVqEtmmdS/RSBpnQk56m3nzk4bIF+2bIf5MnFxoVE/4SLndnfK/D?=
 =?us-ascii?Q?zym13LAPY5RPz61Y7XDjM43/8sR2pgLZ/dU+zvY80GwBy3/sjYfiFJOTQJK7?=
 =?us-ascii?Q?5+RQ23R95a5ujNzdqzPIlYyVupdle0CrIlX/vaaRmXWZuNRnNW3p0fl4OpHS?=
 =?us-ascii?Q?timY7Rs5QSzjser6dtzRraYxC5IgnyT/SBOQKleEVtEbr+i8tzVKnPivPLxN?=
 =?us-ascii?Q?9ui9938haLLK8nccVku+527Uiy5UGeYVv3JaeC9Ts5OrGzzv6+JKbHvHl7E6?=
 =?us-ascii?Q?yVeV3SC4OZvIYSl9D4iCQD4hb8gB+ExcfzRhH5HcvwKRHcJmEkL9OnA3T6Ek?=
 =?us-ascii?Q?NhAr8QuC9DZvDnpa+/4pAVLZkk6MyO5edWzqkgh/UBcRg3A812KXZdDuXcEh?=
 =?us-ascii?Q?MQfsbKwmZIG/uyKLMRPz8C4j8E8SMMf2WToNIybf0fws4OaD6v78wNzMaXc5?=
 =?us-ascii?Q?cGyWPvWvyyNXHzoWpK4huuWW9b8PTJ504Bz/RsHWt9jMD7DGSms9sPiZjHje?=
 =?us-ascii?Q?jjIKOxJ09VhO3HzK5PTGhcq5Ttoc/jPDazcecPPa9gEZZAwhhivZoC4ssL6j?=
 =?us-ascii?Q?lUUjiYEdSJEhy6nU7HRKxaABrNoUlKcl63OVi113zls3KnLds394aLatTSeJ?=
 =?us-ascii?Q?VMh3v1Mo4nXSzYu99MVma66eJ/Rx69fg5jB9TrcMYYkUOw5Pi1z9aR3G3wSH?=
 =?us-ascii?Q?Pa51GsZPc7RKhmhUx9lzn3tPk6RZhLwKn7IqTIrL4D2LzYjezu7UeB1VkAHH?=
 =?us-ascii?Q?oxKFD8uw5f/vZE5zVkhm6hPTqb+3pxzPds50S8ahvSKuw59ARnGLCNiEmvgS?=
 =?us-ascii?Q?z45j3RjUT9sZgDUq6KgWkUat+5moan1AFYhatQlrm6jYSJfyqhMh+1rT0wQF?=
 =?us-ascii?Q?fJ9NZJALd2RqIt9oksoFqLcxw+AIJiVQ9jVJZL2oWrFP72tL/s1LBbuXZdgU?=
 =?us-ascii?Q?81YVP0QcEAlQgG5uiD23Luma/zuw+BIhnci7U0Du3hzMjWbcGqYUkZOTRIPZ?=
 =?us-ascii?Q?u7Rwfj+BrBsRwSTdE5WGH4QbbZD11IdJIu6uFYxP8ejlKVY8nlXS5ezAP/Zs?=
 =?us-ascii?Q?+wppYws5GCX3DkXCA/AHsj01NLKm0cEr+OyUY0VhKkAqSJ44MxMlT7AmQNwm?=
 =?us-ascii?Q?TKYoFj08uvDIqy6tc89XRSGxNbG7SnUKWPVfZDAUDrLYKgwPPsusfw8CFDAy?=
 =?us-ascii?Q?M3FQt54LvJn73gSshzkjayGfek3c63mVQ92FXGSdAIAGTE83kKjmsCM7nNmD?=
 =?us-ascii?Q?prSXf62jJHRmiVTQD10SVpTCZEB8FgxGSzcL9gG0HOa2G0dOGGoNDw91ewrQ?=
 =?us-ascii?Q?L+p/AEnrQ80ECrxe+wvxIu246pSZGkzmBKRSl7y4fOgjWx/QugCjZVx4Fh/U?=
 =?us-ascii?Q?12749p0DFs08gqKu+Lvg8jJUYr2XQaOL8jLDJ5Ak2VPfdTQIpoy/MEJA3xl6?=
 =?us-ascii?Q?cqA6gBAA718Cj/9J/VE4dutut6a1yLO/YGQ30T8+gQqIwfQGfICxYDiilFjf?=
 =?us-ascii?Q?A57KMFVFOUqDyQoRJW85JpRbrwHzPwzv8s9Cwa73anKsFL9qBZICkHM5udiE?=
 =?us-ascii?Q?IQNJgwoIlpVwm+AKl9bUIDYjq1LaCDLLnkq/fOfulHRxbPkJZO2k5PaWs+Vv?=
 =?us-ascii?Q?I41yvw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa290bb-a58f-4361-c4e1-08d9ef92e8c4
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 08:20:50.1295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SIrianYrqr71r0xJ9Rnd47QXhz7wT86yd/2/WOJIuiWL54lGNghbFD9zBQd5Kv7B8VxJ/omdUf5tL1GHbh6V8RMbJWfoiBzAYk2GeY/emU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1524
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Add support of rule offloading added to the non-zero index chain,
which was previously forbidden. Also, goto action is offloaded
allowing to jump for processing of desired chain.

Note that only implicit chain 0 is bound to the device port(s) for
processing. The rest of chains have to be jumped by actions.

Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 .../net/ethernet/marvell/prestera/prestera_acl.c   | 124 ++++++++++++++++++---
 .../net/ethernet/marvell/prestera/prestera_acl.h   |  30 ++++-
 .../net/ethernet/marvell/prestera/prestera_flow.c  |   5 +-
 .../net/ethernet/marvell/prestera/prestera_flow.h  |   3 +-
 .../ethernet/marvell/prestera/prestera_flower.c    |  73 +++++++++---
 .../ethernet/marvell/prestera/prestera_flower.h    |   1 -
 .../net/ethernet/marvell/prestera/prestera_hw.c    |   6 +
 7 files changed, 203 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index f0d9f592173b..06303e31b32a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -22,6 +22,7 @@ struct prestera_acl {
 
 struct prestera_acl_ruleset_ht_key {
 	struct prestera_flow_block *block;
+	u32 chain_index;
 };
 
 struct prestera_acl_rule_entry {
@@ -34,6 +35,10 @@ struct prestera_acl_rule_entry {
 			u8 valid:1;
 		} accept, drop, trap;
 		struct {
+			struct prestera_acl_action_jump i;
+			u8 valid:1;
+		} jump;
+		struct {
 			u32 id;
 			struct prestera_counter_block *block;
 		} counter;
@@ -49,6 +54,7 @@ struct prestera_acl_ruleset {
 	refcount_t refcount;
 	void *keymask;
 	u32 vtcam_id;
+	u32 index;
 	u16 pcl_id;
 	bool offload;
 };
@@ -83,20 +89,45 @@ static const struct rhashtable_params __prestera_acl_rule_entry_ht_params = {
 	.automatic_shrinking = true,
 };
 
+int prestera_acl_chain_to_client(u32 chain_index, u32 *client)
+{
+	u32 client_map[] = {
+		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_0,
+		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_1,
+		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_2
+	};
+
+	if (chain_index > ARRAY_SIZE(client_map))
+		return -EINVAL;
+
+	*client = client_map[chain_index];
+	return 0;
+}
+
+static bool prestera_acl_chain_is_supported(u32 chain_index)
+{
+	return (chain_index & ~PRESTERA_ACL_CHAIN_MASK) == 0;
+}
+
 static struct prestera_acl_ruleset *
 prestera_acl_ruleset_create(struct prestera_acl *acl,
-			    struct prestera_flow_block *block)
+			    struct prestera_flow_block *block,
+			    u32 chain_index)
 {
 	struct prestera_acl_ruleset *ruleset;
 	u32 uid = 0;
 	int err;
 
+	if (!prestera_acl_chain_is_supported(chain_index))
+		return ERR_PTR(-EINVAL);
+
 	ruleset = kzalloc(sizeof(*ruleset), GFP_KERNEL);
 	if (!ruleset)
 		return ERR_PTR(-ENOMEM);
 
 	ruleset->acl = acl;
 	ruleset->ht_key.block = block;
+	ruleset->ht_key.chain_index = chain_index;
 	refcount_set(&ruleset->refcount, 1);
 
 	err = rhashtable_init(&ruleset->rule_ht, &prestera_acl_rule_ht_params);
@@ -108,7 +139,9 @@ prestera_acl_ruleset_create(struct prestera_acl *acl,
 		goto err_ruleset_create;
 
 	/* make pcl-id based on uid */
-	ruleset->pcl_id = (u8)uid;
+	ruleset->pcl_id = PRESTERA_ACL_PCL_ID_MAKE((u8)uid, chain_index);
+	ruleset->index = uid;
+
 	err = rhashtable_insert_fast(&acl->ruleset_ht, &ruleset->ht_node,
 				     prestera_acl_ruleset_ht_params);
 	if (err)
@@ -133,35 +166,64 @@ void prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
 
 int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset)
 {
+	struct prestera_acl_iface iface;
 	u32 vtcam_id;
 	int err;
 
 	if (ruleset->offload)
 		return -EEXIST;
 
-	err = prestera_acl_vtcam_id_get(ruleset->acl, 0,
+	err = prestera_acl_vtcam_id_get(ruleset->acl,
+					ruleset->ht_key.chain_index,
 					ruleset->keymask, &vtcam_id);
 	if (err)
-		return err;
+		goto err_vtcam_create;
+
+	if (ruleset->ht_key.chain_index) {
+		/* for chain > 0, bind iface index to pcl-id to be able
+		 * to jump from any other ruleset to this one using the index.
+		 */
+		iface.index = ruleset->index;
+		iface.type = PRESTERA_ACL_IFACE_TYPE_INDEX;
+		err = prestera_hw_vtcam_iface_bind(ruleset->acl->sw, &iface,
+						   vtcam_id, ruleset->pcl_id);
+		if (err)
+			goto err_ruleset_bind;
+	}
 
 	ruleset->vtcam_id = vtcam_id;
 	ruleset->offload = true;
 	return 0;
+
+err_ruleset_bind:
+	prestera_acl_vtcam_id_put(ruleset->acl, ruleset->vtcam_id);
+err_vtcam_create:
+	return err;
 }
 
 static void prestera_acl_ruleset_destroy(struct prestera_acl_ruleset *ruleset)
 {
 	struct prestera_acl *acl = ruleset->acl;
 	u8 uid = ruleset->pcl_id & PRESTERA_ACL_KEYMASK_PCL_ID_USER;
+	int err;
 
 	rhashtable_remove_fast(&acl->ruleset_ht, &ruleset->ht_node,
 			       prestera_acl_ruleset_ht_params);
 
-	if (ruleset->offload)
+	if (ruleset->offload) {
+		if (ruleset->ht_key.chain_index) {
+			struct prestera_acl_iface iface = {
+				.type = PRESTERA_ACL_IFACE_TYPE_INDEX,
+				.index = ruleset->index
+			};
+			err = prestera_hw_vtcam_iface_unbind(acl->sw, &iface,
+							     ruleset->vtcam_id);
+			WARN_ON(err);
+		}
 		WARN_ON(prestera_acl_vtcam_id_put(acl, ruleset->vtcam_id));
+	}
 
 	idr_remove(&acl->uid, uid);
-
 	rhashtable_destroy(&ruleset->rule_ht);
 	kfree(ruleset->keymask);
 	kfree(ruleset);
@@ -169,23 +231,26 @@ static void prestera_acl_ruleset_destroy(struct prestera_acl_ruleset *ruleset)
 
 static struct prestera_acl_ruleset *
 __prestera_acl_ruleset_lookup(struct prestera_acl *acl,
-			      struct prestera_flow_block *block)
+			      struct prestera_flow_block *block,
+			      u32 chain_index)
 {
 	struct prestera_acl_ruleset_ht_key ht_key;
 
 	memset(&ht_key, 0, sizeof(ht_key));
 	ht_key.block = block;
+	ht_key.chain_index = chain_index;
 	return rhashtable_lookup_fast(&acl->ruleset_ht, &ht_key,
 				      prestera_acl_ruleset_ht_params);
 }
 
 struct prestera_acl_ruleset *
 prestera_acl_ruleset_lookup(struct prestera_acl *acl,
-			    struct prestera_flow_block *block)
+			    struct prestera_flow_block *block,
+			    u32 chain_index)
 {
 	struct prestera_acl_ruleset *ruleset;
 
-	ruleset = __prestera_acl_ruleset_lookup(acl, block);
+	ruleset = __prestera_acl_ruleset_lookup(acl, block, chain_index);
 	if (!ruleset)
 		return ERR_PTR(-ENOENT);
 
@@ -195,17 +260,18 @@ prestera_acl_ruleset_lookup(struct prestera_acl *acl,
 
 struct prestera_acl_ruleset *
 prestera_acl_ruleset_get(struct prestera_acl *acl,
-			 struct prestera_flow_block *block)
+			 struct prestera_flow_block *block,
+			 u32 chain_index)
 {
 	struct prestera_acl_ruleset *ruleset;
 
-	ruleset = __prestera_acl_ruleset_lookup(acl, block);
+	ruleset = __prestera_acl_ruleset_lookup(acl, block, chain_index);
 	if (ruleset) {
 		refcount_inc(&ruleset->refcount);
 		return ruleset;
 	}
 
-	return prestera_acl_ruleset_create(acl, block);
+	return prestera_acl_ruleset_create(acl, block, chain_index);
 }
 
 void prestera_acl_ruleset_put(struct prestera_acl_ruleset *ruleset)
@@ -293,6 +359,11 @@ prestera_acl_rule_lookup(struct prestera_acl_ruleset *ruleset,
 				      prestera_acl_rule_ht_params);
 }
 
+u32 prestera_acl_ruleset_index_get(const struct prestera_acl_ruleset *ruleset)
+{
+	return ruleset->index;
+}
+
 bool prestera_acl_ruleset_is_offload(struct prestera_acl_ruleset *ruleset)
 {
 	return ruleset->offload;
@@ -300,7 +371,7 @@ bool prestera_acl_ruleset_is_offload(struct prestera_acl_ruleset *ruleset)
 
 struct prestera_acl_rule *
 prestera_acl_rule_create(struct prestera_acl_ruleset *ruleset,
-			 unsigned long cookie)
+			 unsigned long cookie, u32 chain_index)
 {
 	struct prestera_acl_rule *rule;
 
@@ -310,6 +381,7 @@ prestera_acl_rule_create(struct prestera_acl_ruleset *ruleset,
 
 	rule->ruleset = ruleset;
 	rule->cookie = cookie;
+	rule->chain_index = chain_index;
 
 	refcount_inc(&ruleset->refcount);
 
@@ -324,6 +396,10 @@ void prestera_acl_rule_priority_set(struct prestera_acl_rule *rule,
 
 void prestera_acl_rule_destroy(struct prestera_acl_rule *rule)
 {
+	if (rule->jump_ruleset)
+		/* release ruleset kept by jump action */
+		prestera_acl_ruleset_put(rule->jump_ruleset);
+
 	prestera_acl_ruleset_put(rule->ruleset);
 	kfree(rule);
 }
@@ -347,7 +423,10 @@ int prestera_acl_rule_add(struct prestera_switch *sw,
 
 	/* setup counter */
 	rule->re_arg.count.valid = true;
-	rule->re_arg.count.client = PRESTERA_HW_COUNTER_CLIENT_LOOKUP_0;
+	err = prestera_acl_chain_to_client(ruleset->ht_key.chain_index,
+					   &rule->re_arg.count.client);
+	if (err)
+		goto err_rule_add;
 
 	rule->re = prestera_acl_rule_entry_find(sw->acl, &rule->re_key);
 	err = WARN_ON(rule->re) ? -EEXIST : 0;
@@ -360,8 +439,10 @@ int prestera_acl_rule_add(struct prestera_switch *sw,
 	if (err)
 		goto err_rule_add;
 
-	/* bind the block (all ports) to chain index 0 */
-	if (!ruleset->rule_count) {
+	/* bind the block (all ports) to chain index 0, rest of
+	 * the chains are bound to goto action
+	 */
+	if (!ruleset->ht_key.chain_index && !ruleset->rule_count) {
 		err = prestera_acl_ruleset_block_bind(ruleset, block);
 		if (err)
 			goto err_acl_block_bind;
@@ -395,7 +476,7 @@ void prestera_acl_rule_del(struct prestera_switch *sw,
 	prestera_acl_rule_entry_destroy(sw->acl, rule->re);
 
 	/* unbind block (all ports) */
-	if (!ruleset->rule_count)
+	if (!ruleset->ht_key.chain_index && !ruleset->rule_count)
 		prestera_acl_ruleset_block_unbind(ruleset, block);
 }
 
@@ -459,6 +540,12 @@ static int __prestera_acl_rule_entry2hw_add(struct prestera_switch *sw,
 		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_TRAP;
 		act_num++;
 	}
+	/* jump */
+	if (e->jump.valid) {
+		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_JUMP;
+		act_hw[act_num].jump = e->jump.i;
+		act_num++;
+	}
 	/* counter */
 	if (e->counter.block) {
 		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_COUNT;
@@ -505,6 +592,9 @@ __prestera_acl_rule_entry_act_construct(struct prestera_switch *sw,
 	e->drop.valid = arg->drop.valid;
 	/* trap */
 	e->trap.valid = arg->trap.valid;
+	/* jump */
+	e->jump.valid = arg->jump.valid;
+	e->jump.i = arg->jump.i;
 	/* counter */
 	if (arg->count.valid) {
 		int err;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 40f6c1d961fa..6d2ad27682d1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -10,6 +10,14 @@
 #define PRESTERA_ACL_KEYMASK_PCL_ID		0x3FF
 #define PRESTERA_ACL_KEYMASK_PCL_ID_USER			\
 	(PRESTERA_ACL_KEYMASK_PCL_ID & 0x00FF)
+#define PRESTERA_ACL_KEYMASK_PCL_ID_CHAIN			\
+	(PRESTERA_ACL_KEYMASK_PCL_ID & 0xFF00)
+#define PRESTERA_ACL_CHAIN_MASK					\
+	(PRESTERA_ACL_KEYMASK_PCL_ID >> 8)
+
+#define PRESTERA_ACL_PCL_ID_MAKE(uid, chain_id)			\
+	(((uid) & PRESTERA_ACL_KEYMASK_PCL_ID_USER) |		\
+	(((chain_id) << 8) & PRESTERA_ACL_KEYMASK_PCL_ID_CHAIN))
 
 #define rule_match_set_n(match_p, type, val_p, size)		\
 	memcpy(&(match_p)[PRESTERA_ACL_RULE_MATCH_TYPE_##type],	\
@@ -46,6 +54,7 @@ enum prestera_acl_rule_action {
 	PRESTERA_ACL_RULE_ACTION_ACCEPT = 0,
 	PRESTERA_ACL_RULE_ACTION_DROP = 1,
 	PRESTERA_ACL_RULE_ACTION_TRAP = 2,
+	PRESTERA_ACL_RULE_ACTION_JUMP = 5,
 	PRESTERA_ACL_RULE_ACTION_COUNT = 7,
 
 	PRESTERA_ACL_RULE_ACTION_MAX
@@ -61,6 +70,10 @@ struct prestera_acl_match {
 	__be32 mask[__PRESTERA_ACL_RULE_MATCH_TYPE_MAX];
 };
 
+struct prestera_acl_action_jump {
+	u32 index;
+};
+
 struct prestera_acl_action_count {
 	u32 id;
 };
@@ -74,6 +87,7 @@ struct prestera_acl_hw_action_info {
 	enum prestera_acl_rule_action id;
 	union {
 		struct prestera_acl_action_count count;
+		struct prestera_acl_action_jump jump;
 	};
 };
 
@@ -88,6 +102,10 @@ struct prestera_acl_rule_entry_arg {
 			u8 valid:1;
 		} accept, drop, trap;
 		struct {
+			struct prestera_acl_action_jump i;
+			u8 valid:1;
+		} jump;
+		struct {
 			u8 valid:1;
 			u32 client;
 		} count;
@@ -98,7 +116,9 @@ struct prestera_acl_rule {
 	struct rhash_head ht_node; /* Member of acl HT */
 	struct list_head list;
 	struct prestera_acl_ruleset *ruleset;
+	struct prestera_acl_ruleset *jump_ruleset;
 	unsigned long cookie;
+	u32 chain_index;
 	u32 priority;
 	struct prestera_acl_rule_entry_key re_key;
 	struct prestera_acl_rule_entry_arg re_arg;
@@ -122,7 +142,7 @@ void prestera_acl_fini(struct prestera_switch *sw);
 
 struct prestera_acl_rule *
 prestera_acl_rule_create(struct prestera_acl_ruleset *ruleset,
-			 unsigned long cookie);
+			 unsigned long cookie, u32 chain_index);
 void prestera_acl_rule_priority_set(struct prestera_acl_rule *rule,
 				    u32 priority);
 void prestera_acl_rule_destroy(struct prestera_acl_rule *rule);
@@ -147,10 +167,12 @@ prestera_acl_rule_entry_create(struct prestera_acl *acl,
 			       struct prestera_acl_rule_entry_arg *arg);
 struct prestera_acl_ruleset *
 prestera_acl_ruleset_get(struct prestera_acl *acl,
-			 struct prestera_flow_block *block);
+			 struct prestera_flow_block *block,
+			 u32 chain_index);
 struct prestera_acl_ruleset *
 prestera_acl_ruleset_lookup(struct prestera_acl *acl,
-			    struct prestera_flow_block *block);
+			    struct prestera_flow_block *block,
+			    u32 chain_index);
 void prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
 				      void *keymask);
 bool prestera_acl_ruleset_is_offload(struct prestera_acl_ruleset *ruleset);
@@ -160,6 +182,7 @@ int prestera_acl_ruleset_bind(struct prestera_acl_ruleset *ruleset,
 			      struct prestera_port *port);
 int prestera_acl_ruleset_unbind(struct prestera_acl_ruleset *ruleset,
 				struct prestera_port *port);
+u32 prestera_acl_ruleset_index_get(const struct prestera_acl_ruleset *ruleset);
 void
 prestera_acl_rule_keymask_pcl_id_set(struct prestera_acl_rule *rule,
 				     u16 pcl_id);
@@ -167,5 +190,6 @@ prestera_acl_rule_keymask_pcl_id_set(struct prestera_acl_rule *rule,
 int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
 			      void *keymask, u32 *vtcam_id);
 int prestera_acl_vtcam_id_put(struct prestera_acl *acl, u32 vtcam_id);
+int prestera_acl_chain_to_client(u32 chain_index, u32 *client);
 
 #endif /* _PRESTERA_ACL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.c b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
index d849f046ece7..05c3ad98eba9 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
@@ -29,9 +29,6 @@ static int prestera_flow_block_mall_cb(struct prestera_flow_block *block,
 static int prestera_flow_block_flower_cb(struct prestera_flow_block *block,
 					 struct flow_cls_offload *f)
 {
-	if (f->common.chain_index != 0)
-		return -EOPNOTSUPP;
-
 	switch (f->command) {
 	case FLOW_CLS_REPLACE:
 		return prestera_flower_replace(block, f);
@@ -71,6 +68,7 @@ static void prestera_flow_block_destroy(void *cb_priv)
 
 	prestera_flower_template_cleanup(block);
 
+	WARN_ON(!list_empty(&block->template_list));
 	WARN_ON(!list_empty(&block->binding_list));
 
 	kfree(block);
@@ -86,6 +84,7 @@ prestera_flow_block_create(struct prestera_switch *sw, struct net *net)
 		return NULL;
 
 	INIT_LIST_HEAD(&block->binding_list);
+	INIT_LIST_HEAD(&block->template_list);
 	block->net = net;
 	block->sw = sw;
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.h b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
index 1ea5b745bf72..6550278b166a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
@@ -8,7 +8,6 @@
 
 struct prestera_port;
 struct prestera_switch;
-struct prestera_flower_template;
 
 struct prestera_flow_block_binding {
 	struct list_head list;
@@ -22,7 +21,7 @@ struct prestera_flow_block {
 	struct net *net;
 	struct prestera_acl_ruleset *ruleset_zero;
 	struct flow_block_cb *block_cb;
-	struct prestera_flower_template *tmplt;
+	struct list_head template_list;
 	unsigned int rule_count;
 };
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 19c1417fd05f..580fb986496a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -8,26 +8,60 @@
 
 struct prestera_flower_template {
 	struct prestera_acl_ruleset *ruleset;
+	struct list_head list;
+	u32 chain_index;
 };
 
 void prestera_flower_template_cleanup(struct prestera_flow_block *block)
 {
-	if (block->tmplt) {
-		/* put the reference to the ruleset kept in create */
-		prestera_acl_ruleset_put(block->tmplt->ruleset);
-		kfree(block->tmplt);
-		block->tmplt = NULL;
-		return;
+	struct prestera_flower_template *template;
+	struct list_head *pos, *n;
+
+	/* put the reference to all rulesets kept in tmpl create */
+	list_for_each_safe(pos, n, &block->template_list) {
+		template = list_entry(pos, typeof(*template), list);
+		prestera_acl_ruleset_put(template->ruleset);
+		list_del(&template->list);
+		kfree(template);
 	}
 }
 
+static int
+prestera_flower_parse_goto_action(struct prestera_flow_block *block,
+				  struct prestera_acl_rule *rule,
+				  u32 chain_index,
+				  const struct flow_action_entry *act)
+{
+	struct prestera_acl_ruleset *ruleset;
+
+	if (act->chain_index <= chain_index)
+		/* we can jump only forward */
+		return -EINVAL;
+
+	if (rule->re_arg.jump.valid)
+		return -EEXIST;
+
+	ruleset = prestera_acl_ruleset_get(block->sw->acl, block,
+					   act->chain_index);
+	if (IS_ERR(ruleset))
+		return PTR_ERR(ruleset);
+
+	rule->re_arg.jump.valid = 1;
+	rule->re_arg.jump.i.index = prestera_acl_ruleset_index_get(ruleset);
+
+	rule->jump_ruleset = ruleset;
+
+	return 0;
+}
+
 static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 					 struct prestera_acl_rule *rule,
 					 struct flow_action *flow_action,
+					 u32 chain_index,
 					 struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *act;
-	int i;
+	int err, i;
 
 	/* whole struct (rule->re_arg) must be initialized with 0 */
 	if (!flow_action_has_entries(flow_action))
@@ -53,6 +87,13 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 
 			rule->re_arg.trap.valid = 1;
 			break;
+		case FLOW_ACTION_GOTO:
+			err = prestera_flower_parse_goto_action(block, rule,
+								chain_index,
+								act);
+			if (err)
+				return err;
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			pr_err("Unsupported action\n");
@@ -259,6 +300,7 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 	}
 
 	return prestera_flower_parse_actions(block, rule, &f->rule->action,
+					     f->common.chain_index,
 					     f->common.extack);
 }
 
@@ -270,12 +312,13 @@ int prestera_flower_replace(struct prestera_flow_block *block,
 	struct prestera_acl_rule *rule;
 	int err;
 
-	ruleset = prestera_acl_ruleset_get(acl, block);
+	ruleset = prestera_acl_ruleset_get(acl, block, f->common.chain_index);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);
 
 	/* increments the ruleset reference */
-	rule = prestera_acl_rule_create(ruleset, f->cookie);
+	rule = prestera_acl_rule_create(ruleset, f->cookie,
+					f->common.chain_index);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		goto err_rule_create;
@@ -312,7 +355,8 @@ void prestera_flower_destroy(struct prestera_flow_block *block,
 	struct prestera_acl_ruleset *ruleset;
 	struct prestera_acl_rule *rule;
 
-	ruleset = prestera_acl_ruleset_lookup(block->sw->acl, block);
+	ruleset = prestera_acl_ruleset_lookup(block->sw->acl, block,
+					      f->common.chain_index);
 	if (IS_ERR(ruleset))
 		return;
 
@@ -345,7 +389,8 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 	}
 
 	prestera_acl_rule_keymask_pcl_id_set(&rule, 0);
-	ruleset = prestera_acl_ruleset_get(block->sw->acl, block);
+	ruleset = prestera_acl_ruleset_get(block->sw->acl, block,
+					   f->common.chain_index);
 	if (IS_ERR_OR_NULL(ruleset)) {
 		err = -EINVAL;
 		goto err_ruleset_get;
@@ -364,7 +409,8 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 
 	/* keep the reference to the ruleset */
 	template->ruleset = ruleset;
-	block->tmplt = template;
+	template->chain_index = f->common.chain_index;
+	list_add_rcu(&template->list, &block->template_list);
 	return 0;
 
 err_ruleset_get:
@@ -390,7 +436,8 @@ int prestera_flower_stats(struct prestera_flow_block *block,
 	u64 bytes;
 	int err;
 
-	ruleset = prestera_acl_ruleset_lookup(block->sw->acl, block);
+	ruleset = prestera_acl_ruleset_lookup(block->sw->acl, block,
+					      f->common.chain_index);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.h b/drivers/net/ethernet/marvell/prestera/prestera_flower.h
index dc3aa4280e9f..495f151e6fa9 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.h
@@ -6,7 +6,6 @@
 
 #include <net/pkt_cls.h>
 
-struct prestera_switch;
 struct prestera_flow_block;
 
 int prestera_flower_replace(struct prestera_flow_block *block,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index e6bfadc874c5..d4c0f0577b26 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -424,6 +424,9 @@ struct prestera_msg_acl_action {
 	__le32 __reserved;
 	union {
 		struct {
+			__le32 index;
+		} jump;
+		struct {
 			__le32 id;
 		} count;
 		__le32 reserved[6];
@@ -1164,6 +1167,9 @@ prestera_acl_rule_add_put_action(struct prestera_msg_acl_action *action,
 	case PRESTERA_ACL_RULE_ACTION_TRAP:
 		/* just rule action id, no specific data */
 		break;
+	case PRESTERA_ACL_RULE_ACTION_JUMP:
+		action->jump.index = __cpu_to_le32(info->jump.index);
+		break;
 	case PRESTERA_ACL_RULE_ACTION_COUNT:
 		action->count.id = __cpu_to_le32(info->count.id);
 		break;
-- 
2.7.4

