Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1CC4B7C48
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 02:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245492AbiBPBJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 20:09:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245391AbiBPBII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 20:08:08 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10111.outbound.protection.outlook.com [40.107.1.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E47FA22A;
        Tue, 15 Feb 2022 17:07:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQGLzfV4IxT82i5vF/ODvaZMp0yJwvJnF3bAb0Lh8sYcZQACwJ4QZq/9iavX5APUaSDqKZ67N6kOviHzx9AHlAB/Z8EJjGYJOcRevYLYCpaP/HKTpIm1CB6g00KkuZcaIDo/g8W8duocKDpuBhRLyrqw8jx+9zDiYQsdEyultgySteYMNXVaIlkKOP1nq9OVtJvQSr1aRhqNksHFwYZm5hTYGjATcteCSMD6w5se0HjwrOwiCh+oyLrIG7T5k74alXMn60BV5DV04mT2OuUyy5HWWol35PMXayRVq9gJCb7UyYTr4WKkqvp/w4prtNXQV2UnqIu5eOIfmHk2z3VnJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQcbTrtWRez8C6Q8T9DjQaxiQHGEGlQLTX26yAMOuAo=;
 b=WCt88oqQcRrHN39OfyEx4MkBEQLmikBOEve0pAwQGA3hLaRd5lZ+QKYO3JbcjPU50CxJYTsEdLMYxEuEs4mm2W5cdpf03sSjJef9BTY6acxWpeuvh7B95D5Ql4HJfS50nVDC6MUAUMykd2MsGWW3VbYn+StRnLA8QgNX9RJT5wVCq6dvQLIY56nfnoxvNVylAXGRZEYaG/lu/yN+2RvQFg15MSRZYycIY4mGP94I2Xesq5hdKb4zXVdUADQmo5NPheMSnqM8+CpXIP+jHe7H20Y0HZuTGlo0696i7PCScNLRLF/vI7FSyg6yHKwPldfh8XY1/F2zS1Z1P51jp51YrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQcbTrtWRez8C6Q8T9DjQaxiQHGEGlQLTX26yAMOuAo=;
 b=qx/4OcSYkBH4RXiVTox8/aAJUQIyeNCckFD/pwHVHJ0D6mL8COodwMHixwmCOS6T/hXaIUKnJiisFHFbc96AHZ+LDeyzDvFjRQXGzZzfj02FQ+uv9ydykErKRqc/yCo6HLtwQnI4B/y4iBUIh9pdQ64q/yJqzvYzXLsakXAz56I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1169.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:266::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Wed, 16 Feb
 2022 01:07:36 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117%5]) with mapi id 15.20.4995.014; Wed, 16 Feb 2022
 01:07:36 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: marvell: prestera: add hardware router objects accounting for lpm
Date:   Wed, 16 Feb 2022 03:05:56 +0200
Message-Id: <20220216010557.11483-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220216010557.11483-1-yevhen.orlov@plvision.eu>
References: <20220216010557.11483-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::19) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4327a48f-388b-454f-5695-08d9f0e8b85b
X-MS-TrafficTypeDiagnostic: AM9P190MB1169:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1169DD70ABD58FF7CE008CFC93359@AM9P190MB1169.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:136;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DF0WDFMfB0Q1pTcDU/5O4aA/BIeF7tJOVs0hhIgOB6c9qaPDXMfblDB9Yl9d/rMf4ylplpuSqKRM9ikQ6sRYHLrAxbbph4NaY/b0t8GhDy0wK/0ZLSnkVaZf0SJULpzSWcr5fa42hBUm2DsUSS4FVCCpgZVDUuTy48aIKE2pQxrdl8fE6jYKp/YZGIyydTIlPezAlmYWC9U9FwTLRVNgHHAiGwKrnJCMZg6oQH5gC5nzyvYMOIrr5VXEfdi8jJNmDpaD4ZBrxX1BpMPY63HAK52le3yr2kdOJWIr/YJumfEWxnpEOdRuGWCoBFhbZYeBBOiUqFuwnI9o/BpwqFYrHyP2alcTulqS+9fBPhHHV1B7IOn7wd+v0JiZVkyDQdM0njylJGc/OmX2lDlFs5Eha6kZsQX198IRYzGTStqkf2Lt7WYEkKlfuM6fBG4k9omnm2xVQKwnslv3iglQLTXGyec445gd1sYcJ8fA+WFEfcDMsuZO4/WxFiF3y5vt/6caYPo4fyYEXaMwTNu5P6O1fnGLDYL+iyTE+5aDBSbH4/10ETm3bd2aholAijJTXscCfVrvcrAVRMtAOM26mcZfXiRIK0T2/Qa7BJyPCPUSWUb/zx+mpIL7rOHfBOUZxliTGNqYWnxqJWAT+NAjFVaxH+rMnIb9z3QuyPZelUX8e3xE/cxuazv6AlFxjAF1RMUGfhpak1QoNSt4DhFWf+rnPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(376002)(346002)(366004)(136003)(6666004)(5660300002)(44832011)(66574015)(36756003)(38350700002)(86362001)(52116002)(6506007)(8936002)(66556008)(66476007)(66946007)(38100700002)(8676002)(54906003)(6916009)(316002)(4326008)(6486002)(508600001)(2616005)(2906002)(83380400001)(186003)(26005)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b+AwrkSPpvgw6xzT7uL2xalxqVbMQf1tekOrW5c+vY8DXtPV+OJ7WGLMSdp+?=
 =?us-ascii?Q?El1rEJd0rli3CCCpEroyl9NHK49O42t05HwjWhBuTuPVMMxgIrw7FBigWn8a?=
 =?us-ascii?Q?lL+GZoXNqafM4yLDiXi9wDPWuCFXxBviDuW5BtBfKaH+afMy3vOIyH0/L2CT?=
 =?us-ascii?Q?SUd7T7ONML8KUxAlCZCPRZEqcVQ1fBOx4UGzu46HOfLFU1up2ng6YNsMxLia?=
 =?us-ascii?Q?9rD+bX7ltdP/wznMMLJR/hbRhQ9zJFNrVBmkMlVfDQyG+7P+/pY+254J1pLT?=
 =?us-ascii?Q?ZtG7dQdOL0RizSiTHn5UHqH+6UPijt29bDqwC78q9cLOH3FMbC1vdGS4bh9E?=
 =?us-ascii?Q?y5HilzoBU+y99gMWAnKM9iAUCYNax4tBZg6aacLXTnuZ+qvCxAdQVE0UhFc0?=
 =?us-ascii?Q?pK9slZtvMt662R7cip8mLzhaw28U5i2//WtXmxoUfhCUYPjsJOleqkcqFyYx?=
 =?us-ascii?Q?3q23Rm3l3dsPV5YzIq94otWBAD8+tg6xBoWO7Y278LuLgLgZOcmpG930QIbY?=
 =?us-ascii?Q?NOUS4sF3dw3QQ3Bb5z7MzT3xo2atvNRIRq2EY6WCyBfIOBAasYuze0z8oqID?=
 =?us-ascii?Q?gEVwvNoQakblH43Rd4mCl4LlTJXld/kiqcwGN57lOc4YM+vJ8XZMzxbnTSdZ?=
 =?us-ascii?Q?K+KMPudEMaWkOmsbhozG7KCF5lqAWoMVt9zAUJfoysuXobN5mn0V49K5EvTq?=
 =?us-ascii?Q?XeQDr8l8VSZ3K1MroGXJDWOxOxWDfzMT/3+RGqpBq7RY3+MM8Izo3V6z/DFu?=
 =?us-ascii?Q?LvociJM5tAHl3lCCFOyMdZ0fifXW9agPVIczbs2iveTWUHazq/BJj1ooTOCz?=
 =?us-ascii?Q?u4HBUARKBYiBisRoqRKizibCfxG5jE2gnXlalDPNDxiQWrWSNxwECKUBVYta?=
 =?us-ascii?Q?9QvZGBoSdmHmk6uEEQNjirKF+gauT2+ycmXAjdBApP8iGzXIokJlt7EAVva2?=
 =?us-ascii?Q?eQiFdmQLG2FcvUrkHQKN6zESsQxFpzRQRo0U/rWmgkduRi3GJA9XiGvWZxHt?=
 =?us-ascii?Q?L647C0l73Azv2yHQN6ftHe6EjBNNx4FIvUj0Xg129dIpiU9+69E02et09V/L?=
 =?us-ascii?Q?Xfckm1p3l+i5iOBS8W+nPMHZ6UaaXZ8YZ/lfUjXWGfJBhUicuRU2xYgKqNS1?=
 =?us-ascii?Q?6WTI40EVoaR+XoCFmVO9Tbu8V97ryp6bOQ0VQJSJrEO4MmCoalGMDP06ewdE?=
 =?us-ascii?Q?E2/nyiJSrFhQ/rJgYgeCHwQpY4KoZdxrAEvJU2F0Q92JoNDIK5U5WDdKDy7k?=
 =?us-ascii?Q?I9pcdOD2EATM+xLaTdVgASDIRIqD4pNmzVslFLgAMcBu2ZC/vCru2/QMbbW/?=
 =?us-ascii?Q?O9cEiC5IsrWmhCMEjKB/B4pv3kTQuI90r+361Lf/RSVmc2KKbveNdNKWVIE5?=
 =?us-ascii?Q?Osea/w2UEg72zpAXDgKpfsgKldX2bth+x+WityG/twHeTPPR1UD5ydIjdPX0?=
 =?us-ascii?Q?JeDPCZbfg+lySNMDqqDraps8c/armlEzddVNBUTKGFcwx9YQfYSdLXN3v/t4?=
 =?us-ascii?Q?lymZuJT5Yfg44oSU1iteQAR4PBjSy7XQnVtvrNnQPAFRdqt32VGKlMP3UXrQ?=
 =?us-ascii?Q?z5PcaqeNgnSybBQ6eyPDOXYYAOECqbm3bPwIy9vn+ncW/hvLG5nYxwkS2FLK?=
 =?us-ascii?Q?VBbIxKGoOqqJpSKF9OzxdsqZxzleKnVrrLgDOD27PG/BK72Zo4VcYEITp2jG?=
 =?us-ascii?Q?Ho5Dsg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4327a48f-388b-454f-5695-08d9f0e8b85b
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:07:36.6958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 73hmy2GFJ1F9kMeC53Iv7i5fmT7wAzmjhj61XheVkMSJn6OTBuEtTzA97gqMRDjTXvLnGD8Jh04F1fjOJ7KyXaMWLnTFgUOkdE37R2paWos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1169
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new router_hw object "fib_node". For now it support only DROP and
TRAP mode.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   1 +
 .../marvell/prestera/prestera_router_hw.c     | 132 +++++++++++++++++-
 .../marvell/prestera/prestera_router_hw.h     |  44 ++++++
 3 files changed, 170 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 2fd9ef2fe5d6..dcaddf685d21 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -281,6 +281,7 @@ struct prestera_router {
 	struct prestera_switch *sw;
 	struct list_head vr_list;
 	struct list_head rif_entry_list;
+	struct rhashtable fib_ht;
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
 };
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index e5592b69ad37..d62adb970dd5 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -9,23 +9,41 @@
 #include "prestera_acl.h"
 
 /*            +--+
- *   +------->|vr|
- *   |        +--+
- *   |
- * +-+-------+
- * |rif_entry|
- * +---------+
- *  Rif is
+ *   +------->|vr|<-+
+ *   |        +--+  |
+ *   |              |
+ * +-+-------+   +--+---+-+
+ * |rif_entry|   |fib_node|
+ * +---------+   +--------+
+ *  Rif is        Fib - is exit point
  *  used as
  *  entry point
  *  for vr in hw
  */
 
+#define PRESTERA_NHGR_UNUSED (0)
+#define PRESTERA_NHGR_DROP (0xFFFFFFFF)
+
+static const struct rhashtable_params __prestera_fib_ht_params = {
+	.key_offset  = offsetof(struct prestera_fib_node, key),
+	.head_offset = offsetof(struct prestera_fib_node, ht_node),
+	.key_len     = sizeof(struct prestera_fib_key),
+	.automatic_shrinking = true,
+};
+
 int prestera_router_hw_init(struct prestera_switch *sw)
 {
+	int err;
+
+	err = rhashtable_init(&sw->router->fib_ht,
+			      &__prestera_fib_ht_params);
+	if (err)
+		goto err_fib_ht_init;
+
 	INIT_LIST_HEAD(&sw->router->vr_list);
 	INIT_LIST_HEAD(&sw->router->rif_entry_list);
 
+err_fib_ht_init:
 	return 0;
 }
 
@@ -33,6 +51,7 @@ void prestera_router_hw_fini(struct prestera_switch *sw)
 {
 	WARN_ON(!list_empty(&sw->router->vr_list));
 	WARN_ON(!list_empty(&sw->router->rif_entry_list));
+	rhashtable_destroy(&sw->router->fib_ht);
 }
 
 static struct prestera_vr *__prestera_vr_find(struct prestera_switch *sw,
@@ -212,3 +231,102 @@ prestera_rif_entry_create(struct prestera_switch *sw,
 err_kzalloc:
 	return NULL;
 }
+
+struct prestera_fib_node *
+prestera_fib_node_find(struct prestera_switch *sw, struct prestera_fib_key *key)
+{
+	struct prestera_fib_node *fib_node;
+
+	fib_node = rhashtable_lookup_fast(&sw->router->fib_ht, key,
+					  __prestera_fib_ht_params);
+	return IS_ERR(fib_node) ? NULL : fib_node;
+}
+
+static void __prestera_fib_node_destruct(struct prestera_switch *sw,
+					 struct prestera_fib_node *fib_node)
+{
+	struct prestera_vr *vr;
+
+	vr = fib_node->info.vr;
+	prestera_hw_lpm_del(sw, vr->hw_vr_id, fib_node->key.addr.u.ipv4,
+			    fib_node->key.prefix_len);
+	switch (fib_node->info.type) {
+	case PRESTERA_FIB_TYPE_TRAP:
+		break;
+	case PRESTERA_FIB_TYPE_DROP:
+		break;
+	default:
+	      pr_err("Unknown fib_node->info.type = %d",
+		     fib_node->info.type);
+	}
+
+	prestera_vr_put(sw, vr);
+}
+
+void prestera_fib_node_destroy(struct prestera_switch *sw,
+			       struct prestera_fib_node *fib_node)
+{
+	__prestera_fib_node_destruct(sw, fib_node);
+	rhashtable_remove_fast(&sw->router->fib_ht, &fib_node->ht_node,
+			       __prestera_fib_ht_params);
+	kfree(fib_node);
+}
+
+struct prestera_fib_node *
+prestera_fib_node_create(struct prestera_switch *sw,
+			 struct prestera_fib_key *key,
+			 enum prestera_fib_type fib_type)
+{
+	struct prestera_fib_node *fib_node;
+	u32 grp_id;
+	struct prestera_vr *vr;
+	int err;
+
+	fib_node = kzalloc(sizeof(*fib_node), GFP_KERNEL);
+	if (!fib_node)
+		goto err_kzalloc;
+
+	memcpy(&fib_node->key, key, sizeof(*key));
+	fib_node->info.type = fib_type;
+
+	vr = prestera_vr_get(sw, key->tb_id, NULL);
+	if (IS_ERR(vr))
+		goto err_vr_get;
+
+	fib_node->info.vr = vr;
+
+	switch (fib_type) {
+	case PRESTERA_FIB_TYPE_TRAP:
+		grp_id = PRESTERA_NHGR_UNUSED;
+		break;
+	case PRESTERA_FIB_TYPE_DROP:
+		grp_id = PRESTERA_NHGR_DROP;
+		break;
+	default:
+		pr_err("Unsupported fib_type %d", fib_type);
+		goto err_nh_grp_get;
+	}
+
+	err = prestera_hw_lpm_add(sw, vr->hw_vr_id, key->addr.u.ipv4,
+				  key->prefix_len, grp_id);
+	if (err)
+		goto err_lpm_add;
+
+	err = rhashtable_insert_fast(&sw->router->fib_ht, &fib_node->ht_node,
+				     __prestera_fib_ht_params);
+	if (err)
+		goto err_ht_insert;
+
+	return fib_node;
+
+err_ht_insert:
+	prestera_hw_lpm_del(sw, vr->hw_vr_id, key->addr.u.ipv4,
+			    key->prefix_len);
+err_lpm_add:
+err_nh_grp_get:
+	prestera_vr_put(sw, vr);
+err_vr_get:
+	kfree(fib_node);
+err_kzalloc:
+	return NULL;
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index b6b028551868..67dbb49c8bd4 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -22,6 +22,42 @@ struct prestera_rif_entry {
 	struct list_head router_node; /* ht */
 };
 
+struct prestera_ip_addr {
+	union {
+		__be32 ipv4;
+		struct in6_addr ipv6;
+	} u;
+	enum {
+		PRESTERA_IPV4 = 0,
+		PRESTERA_IPV6
+	} v;
+};
+
+struct prestera_fib_key {
+	struct prestera_ip_addr addr;
+	u32 prefix_len;
+	u32 tb_id;
+};
+
+struct prestera_fib_info {
+	struct prestera_vr *vr;
+	struct list_head vr_node;
+	enum prestera_fib_type {
+		PRESTERA_FIB_TYPE_INVALID = 0,
+		/* It can be connected route
+		 * and will be overlapped with neighbours
+		 */
+		PRESTERA_FIB_TYPE_TRAP,
+		PRESTERA_FIB_TYPE_DROP
+	} type;
+};
+
+struct prestera_fib_node {
+	struct rhash_head ht_node; /* node of prestera_vr */
+	struct prestera_fib_key key;
+	struct prestera_fib_info info; /* action related info */
+};
+
 struct prestera_rif_entry *
 prestera_rif_entry_find(const struct prestera_switch *sw,
 			const struct prestera_rif_entry_key *k);
@@ -31,6 +67,14 @@ struct prestera_rif_entry *
 prestera_rif_entry_create(struct prestera_switch *sw,
 			  struct prestera_rif_entry_key *k,
 			  u32 tb_id, const unsigned char *addr);
+struct prestera_fib_node *prestera_fib_node_find(struct prestera_switch *sw,
+						 struct prestera_fib_key *key);
+void prestera_fib_node_destroy(struct prestera_switch *sw,
+			       struct prestera_fib_node *fib_node);
+struct prestera_fib_node *
+prestera_fib_node_create(struct prestera_switch *sw,
+			 struct prestera_fib_key *key,
+			 enum prestera_fib_type fib_type);
 int prestera_router_hw_init(struct prestera_switch *sw);
 void prestera_router_hw_fini(struct prestera_switch *sw);
 
-- 
2.17.1

