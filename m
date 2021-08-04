Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BF83E027E
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbhHDNzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:55:24 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:28896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238461AbhHDNzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:55:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPr7Hc9BWgIXosP+ThVg8lh0Zpowi33nZMKxMSELaqTRb8DGroWBwwtSzYx4TUNr8LEiYSuzMJ1bxBnacGM1l0VU3DscHX2ZcxfQwO6lOH0d/ZoQeu+yZMeL6BQueYi1u57ve4Maxon7YcKePJlbn5i4CxWVZkrxXN7gi2rmNFpBUxZIiLr70i2ZnG2Uz8Q0YqZss4FM6UYTE/SBeoajXvoavRPsY8uCxEFpjVLT80qjrlfphfAdfZJKMZaLCJljnylDtq45WYDxZA3fH+t+TGZkY/jgY8tW5FpOsl0m38uBu8R4Uuijfxk1mVEzi8ir2eXVZgqh95vqtPJB32WckQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUJQTskF/PxUROiNR9u0KutptxhC7rr7ejtMqyblQE4=;
 b=fW2GNsNJk+UWuYMP4tDUxAXaw+wBpWJX4il4I+86H2HEZ70rbpa7SNibcI2RRJhhZeh0tzjReoHS8q/O9bNZTxoz+yfxAVfdIw/BZ6IRi/CV+z/52R1gZSuPpHQvS5HveOKKO7JkJjebpucU0Jmf16qmHfY1RTW8AqW20RKOQsfK8fXZXrde3393/pZmJC7qarmkN5oXMsVyL5+dmJgVR/n3Sx68ygI0dBEliaA2AkQLh7Kvi6UBoBq6n4Aenxu3k4IaMRlnAizRSA/rQQRgXtQZzf8EqnfMmQ2aEWjaRNbSIUBU189vFah15znt1/4Z7MkofrOZPQDsjuzgSicXrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUJQTskF/PxUROiNR9u0KutptxhC7rr7ejtMqyblQE4=;
 b=IFtZDEoeIVc7gQYvSlxYlsjLDS6OmKGNt72hHICT55GjrTI6UEo3I+XOMfcVDkcExqbty/lukiHv2a+g6NT5SsZUJR3ZJaP+HtLesmpMVdMjhctX3NwHRt2bdBNH8nzHBJA/I7GYxBLzjhhm8B2GeqvrnXfrEPLhZZlEcf+sdXI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 13:55:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:55:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 1/8] net: dsa: rename teardown_default_cpu to teardown_cpu_ports
Date:   Wed,  4 Aug 2021 16:54:29 +0300
Message-Id: <20210804135436.1741856-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
References: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0155.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 13:55:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fa91385-c017-492f-eec8-08d9574f784b
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2687FD562299581563E672E4E0F19@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IOCqKXWJOMpB870XjlUTvmvHKBy7ya52+IZoiA+JRGXNCPNwVNt97uq4PIiIU6A38O4OBAMzjC2dLH6xZ+bku6XaUM81z/Au7F7LcLTRNBZqxRVXoBvIEjwiK4BiL6bMMYBMadUWh2L1qUG3ob5YLbI6/5r4voRTGZS5wEemgXaYCHN4AvfDelW4LVWuS02WQfI5e8nvIBE4TMI2cPzfRAE/S+v1/Is4q6AZ5/qk+pvpNZI15YP9LxItZbDE6M47Isswc8Dt3N4plnk00cPdImrxd1KTqew/zFcTBgDZd17ilUV2BVGX97CI9fObC9iEqLes3eBlAeBXNd2mlv4vydEob5HpznGEDt54yzR3KCKS5s9mqFQu5oLGrjytm+V3HgPW+T11avyN9+Eg/SeQ+gD6DbxklViPVuqmHKwGxS7aRdDAuDayLG2ACQ8c/k4fYXqylpntuGC26AqqRApoEckUOChN5+u01kf7BTxhdLH0p+tlAjHh70E3KyLJJZLdhDqjfnHr9KOZ/OqhjIPRAlCenHqmlg7nPX5QKWyhxU2+un/Ix3SWmrHITv6EJj9RfMeoyvuMwkOUO+3gqD1b5tg3B8Y5ddgPe7lV+8IIKERfRWejAjlUVDV9UvDbq5UGPsVOFyu/urvIvxfCuMaOyOaUSGHp2RM835MXubpcTw1mRY2nz+nHagAIwN7USEqp13/nE3TQVCsVErPnYP1dPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(6666004)(6486002)(5660300002)(478600001)(66946007)(1076003)(66476007)(4326008)(66556008)(54906003)(26005)(44832011)(38350700002)(86362001)(2616005)(52116002)(8676002)(6506007)(2906002)(36756003)(110136005)(83380400001)(38100700002)(956004)(6512007)(316002)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PzGOb5fXcqspL2uw125Cul8i0xnB2neAvowIwFQTroyYkznRAY+9gTak0oXR?=
 =?us-ascii?Q?qISGHXeH/Q6sGp7uJAdAiCm0xFCcTaeflsYavDoAxWD2a4gjeVQpfzfbhwpi?=
 =?us-ascii?Q?eHWLPHRw+3lA6/5UKEzwXhvkDiX+jzCybNDVuZE6/rUvL1eIRFLLbcoWWFn1?=
 =?us-ascii?Q?KE285V2mNbNdwoXturGsH7JRKcGJ5FUrm28wiqUsEU3ZS6UgOkdnWpCtONYF?=
 =?us-ascii?Q?mRohRAz7Ep+HhYs5FaU/bBT6P5w07Kh6oFEmvrPsfYhgn7pJMdNUllgDwWHo?=
 =?us-ascii?Q?rNsruuEUrLcwgvLFDTwxBJY948oAdfJ64hcUqJMd7RpAV6aCD1grIoDW/Qq0?=
 =?us-ascii?Q?JJm2Whn8Zybd+2sRzCD3sZaiHzKOZEAYOo2spUyQFZmc93fEYmozZeF2XCns?=
 =?us-ascii?Q?VPMOJMcrhcAyymo2gUuv8IXaPG72ka368pbAFNGK3RKzjeMoevnnsLbxy3sQ?=
 =?us-ascii?Q?qmTG7DmWW3XNfy5p2E0tr024E5RR7QKS44YkK7d5KsB7qkls8RiQ+BczERHK?=
 =?us-ascii?Q?lLHmCDdddy+yBfgyP0An6CDhKD9EbEiubvAfKvPt1S/rib9aWq1zP5NRQbpI?=
 =?us-ascii?Q?TLiAe1e5R7v4Jx2W5xHk5luDJIajjbUeI3uIIcg7ExSsPwqVHF4jVD2xCWzt?=
 =?us-ascii?Q?WO7F36UvIq/ITg8SJCoKLClIWPBdsk1n+pLOgsG+sA5m6Lh+r4llfilv53ms?=
 =?us-ascii?Q?v3xotLlQKokfTLrctm8rirstP1qBqu/fuFrEdidLHoGfYsziUcPW6hNerFy3?=
 =?us-ascii?Q?QguDibRcyyxSbFUvbPh544NH/xqODbRq8KVT9Ik/zbIKGrQggKZyVi7aRftp?=
 =?us-ascii?Q?VkLOAYOxvvIJHlJHjpueMCoCHesmHo2T9/bv2ITPhzW3x7iYIJS7/sFFQnRL?=
 =?us-ascii?Q?RLpX4q0fkBg9zu88Bi+g2j+lrxDAU7ScL7qm57PjhTYG7teejMrnMBLVFAFt?=
 =?us-ascii?Q?yyE+yw3FGlLARFCK+H+HdVibqjlS9dNMG+KtJAWzuxoOGeYwXfkrETXUw9rh?=
 =?us-ascii?Q?viQGh/rQqE7HPPQVQbKURYXsFRR/FcyAnr2uvIvlBspoo9F+82KGy/AsHFaN?=
 =?us-ascii?Q?n4FIUymb4uhfjFtTIsaM0s19VMGD0n4ygOq5GbvZAKW5v6BRNTOgbGZQYQdj?=
 =?us-ascii?Q?zIRqUOyAbJTK5OHwGWV0JAwAc25h/XwRnGFutaP0tiFBNISsRF/c80Vmcrs2?=
 =?us-ascii?Q?Lm0MgfqJRWaNn7y4P3CeXw7ohjgqjoGwBWjyvKCBBjG8srq3Z14x3vjIULfw?=
 =?us-ascii?Q?3kiQ6Z4W9VOwwhZg0q1qPF+bCpwFENrPR5fG5Gp9VD7hXKeJIH/fdqQnO389?=
 =?us-ascii?Q?X6Ggqj31qP6dNwBCZplWUc6q?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa91385-c017-492f-eec8-08d9574f784b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:55:08.3410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JPBVCRQsqRx1kRZTy2G3vapCkJBHoW82e3PNgto1jko4pkNWkuU4H1ywoQpJnLYWp4CpDd1RVEgbyKefnEGRzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is nothing specific to having a default CPU port to what
dsa_tree_teardown_default_cpu() does. Even with multiple CPU ports,
it would do the same thing: iterate through the ports of this switch
tree and reset the ->cpu_dp pointer to NULL. So rename it accordingly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c7fa85fb3086..4f1aab6cf964 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -329,7 +329,7 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 	return 0;
 }
 
-static void dsa_tree_teardown_default_cpu(struct dsa_switch_tree *dst)
+static void dsa_tree_teardown_cpu_ports(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
@@ -927,7 +927,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 
 	err = dsa_tree_setup_switches(dst);
 	if (err)
-		goto teardown_default_cpu;
+		goto teardown_cpu_ports;
 
 	err = dsa_tree_setup_master(dst);
 	if (err)
@@ -947,8 +947,8 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	dsa_tree_teardown_master(dst);
 teardown_switches:
 	dsa_tree_teardown_switches(dst);
-teardown_default_cpu:
-	dsa_tree_teardown_default_cpu(dst);
+teardown_cpu_ports:
+	dsa_tree_teardown_cpu_ports(dst);
 
 	return err;
 }
@@ -966,7 +966,7 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 
 	dsa_tree_teardown_switches(dst);
 
-	dsa_tree_teardown_default_cpu(dst);
+	dsa_tree_teardown_cpu_ports(dst);
 
 	list_for_each_entry_safe(dl, next, &dst->rtable, list) {
 		list_del(&dl->list);
-- 
2.25.1

