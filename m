Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CA367F37E
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjA1BIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbjA1BIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:08:02 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2089.outbound.protection.outlook.com [40.107.8.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995E021A2F
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:08:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOhrngZvX2OGtGu7GzbfMEAgwB7P5JO5vqW+YDHwi7eR8Dox16mbc9Ki6NHxhU1nG/FdMtVl6br51G04GlY56ckR4BL7nC8FRdECEVs9oP2BmZRIC+7sXXiMkAdvfhOwMnQ8MW8RR9VKNer7fOiX6HHl+JHSmdXXFqwk1nIBMMSGVc5i2KNmHPLLyKJYlwvlEHe8cKgaJJtui9n0M7OzWsG51f+OiorpGE7tr0OjvD4Rr1wp4r++WQowzbr642NS3V1nroFGsDZDUGt7D0xzyhBIJxP2FORzKJfXatHfP0pG8yjl/1SyMCnfTOJcHbzybQ1JLIRB5IIw25jZZaDlag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eg71mh6QMGj0pjRpywu/+aDBWVEcBP7/nJrmk7KUd8k=;
 b=NjNEMLH2Ax7aGbYNd6ljz3fiykXuaPNvrSJVwF6+b9cVcjqLJ8EmtQy46rSPmF7rySYztF0JH3DsPaQUKs0LAcQ022+pja81/H7BMmwCYAe5HuO0nnELSteM7ChKtS1lLXmMmEJNEEkA6eapT/gvMB7aGsIoY34y0zOdXpwKy6hkLZAECWRreLZVLJyAYtnT/SZ4n5yAm+lmKLXPAFR80B7k0x/MYF+eiatiHdI/qHDkOsjc3ygM4+K86lo08Ml4enhgJ8uLZs0p+5J9DKh4g1CnYXZopYyb76n5gDQ+izWRETCc55qEGYvwa97PdMSRS683E5kOgPsaIFpVu+dNGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eg71mh6QMGj0pjRpywu/+aDBWVEcBP7/nJrmk7KUd8k=;
 b=Drxa7aIfkfRyW3Z/D3nVx8iYa647FHefuP+y6Miwm073U5HcLPFa/wjANzq4ygeKlMbqS8moGZdgczMiVdluhFwaFBonhtEa4k8lR0D5rLgjY9S86n3Wjvr5C9YgGZ8QjVnCz6Ci2I1kplbCcJWSSfyEBmhFihS8PL2Eh2Qk3ak=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 10/15] net/sched: make stab available before ops->init() call
Date:   Sat, 28 Jan 2023 03:07:14 +0200
Message-Id: <20230128010719.2182346-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: 61b00cc9-1365-4c6d-f9c3-08db00cc15fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qub34G6K6E/GyTcTjnZJOtfHTtFnE7dCN3LMW+XGQdDLSd4E0pVm2e5HvN60OHee+XlhozYPyqOnFxGq3iV37Ez5cqTlOCa2FRSZOxbK/g25WdHWcRMvVdz/HruH//fu1PSdB+v8NBvelfPu0JrCl8vujapHh1VrJQ2/NdZsCVDF+o3IUdQCDBbG2EE1UitbEZs4XDSAyUM2XaVWcffLSxkqCqCwrx+C8Ri24LFAdXg6ngtVwTU0+O0rejdBFjxkBBhumF+yV3+TCF4OYKsbuvxU0ZiqnFWY87K5oH2Sza0ueytj4Mzul62VNMzTyMyrmS+MHS8iBukNrX3G3l3WPd5haixKbD378DYWFozulbcafnyr1VGajxsjvgfDSBY4TWitgutl92jrJU0Fszzbf8yRLcWPRf9n9ZfoViiXC78fcytmbvyEp+C2fMpt0NxM7GJKvgW70EzkUEofjY0I3vSnKhNk85P2me6SVsEhqDVWXZARjKCjgluZESXY3hMEq5+/W4SjZ2w3St7ihqf24JFaT1as3RckEgIS+SE6s2kbpXFpaOqkcT5m046agKvxiV9vKaM9ABiLlmCV3vLFiBT9NyR4F4fSYwIIlP/47Qi7P8sua/Viirdio81hzUslTklxIt0mAnA6DkvhzyvBQuPr4o5N+7I1YV8yS0nZ4PKmkkKRqEE3kD51wN9hcBSuxTmu/2HF9/RbDbHeF2jEgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uv2K7iUw7uCDR+eOVNYh2GJqwZm9hA8vTwovvg4BuQAbLOnBwQ8OQgioBXUH?=
 =?us-ascii?Q?y+n1jMlK41lZ9M0w4zk6oJ+76K+EOC8Q5TjF9bZu9jo9mZD29Lg8PfNXycYU?=
 =?us-ascii?Q?PIHMG6LDWKxIHGtxpIGjsIyed12XaihSbrpps4ZuO5sLtHSlMR0Yhc0ldhV0?=
 =?us-ascii?Q?eyS0ElyDOCeBupiem9HPEKkuuTPmRzdeGLZ92IS3PDY20bxR9tSIB/6Zhjm9?=
 =?us-ascii?Q?yQXay3mxMyxpXnBC/62RWs2haU+w6KhFi3KDsIfQli09V4OrSRWI8p2vcB3V?=
 =?us-ascii?Q?No5eTnHFxDOcuFbUm6XJXmmoml7zfXF7vxY/byPBmzGQJJizV70shEJeaobY?=
 =?us-ascii?Q?Rp2gOlC0eEG9NrTJO3obVNAb4a4zUsXIvE7rppqVgZ+w+pNUEcvqii/+H4VN?=
 =?us-ascii?Q?0naRVP44XanczGKl3SKm3WKdtUv9RyiobJgHnTEzMlbWD4mIFyeeMot1hm5l?=
 =?us-ascii?Q?PPjNH/K7Lq8nvx7HInBQRe06JZRntHyWZnZ+lgWPuAlSyo8HKNQ0GxuYLI8A?=
 =?us-ascii?Q?ak7WAjOLOapJtLDn5/NrEiIC7JjYgfYp7f5uL+PMgSbNpciGrJRIl3aUvhki?=
 =?us-ascii?Q?V8SQTxQJFEDVbC2kNxtkFaZvC66xozhx2iWj7MdrVKHCodJg5xmWeyBQpboU?=
 =?us-ascii?Q?WpvLlZnyX/5hZZf1YNx4gmq2r2DOGoVEcfFcBj8yo5CLBK4D39qTsGeM5d8z?=
 =?us-ascii?Q?9DhL87ppy6b48omYmMDhf9H28cFFHLkD/6W5Uff3mD+MnEGFBFZRfBiHVlbw?=
 =?us-ascii?Q?S+yD3aVD/+ajFgqExfpgNXPAms/KflAkpXIf/FH2NOUAkRc+IpF1OsTcVrnt?=
 =?us-ascii?Q?WMK7z6wUdK9MjEvmSYARBL9xobBju4ZYIvNM9Bbqfu9Y2NpWpzgk5+pgLmZE?=
 =?us-ascii?Q?FgKAwiQXuy3yFBvfvTCshmEQ42d9D/LAmhcCeWLuvKwLOtzqf9igF88b1aNb?=
 =?us-ascii?Q?bX4ByPs3Va7vv+dkGour7HoDgU/A9bVgtgcWEexZMfK/IwF2wpTVEmy7fABu?=
 =?us-ascii?Q?bOCx7JdMaovpYNyAK29xf/AOEDkcvwrkRXDolewEwPnBda5FVjxqvbJgWjxT?=
 =?us-ascii?Q?Rg/JouhzDZ4O6LVAtyShUpd9vzdddBOXGLIGBdblI4eqznzqXp4/N/MP7/RB?=
 =?us-ascii?Q?wg3k1I8htMAYY/P4VSCjVM29MD+508HeutwBKf5mEretSLkcZAjdl4fBNY+N?=
 =?us-ascii?Q?GJb++dABf0kpzCL4hvglB3rCH0cqstKHuDGLwg3Ew7/DJveSBtxjNvFH9cMt?=
 =?us-ascii?Q?2MupGbCS40L+EtTrj056W35tLA8v/qehdmVYXlbY0T7XJCMcs3nRHEneKWBX?=
 =?us-ascii?Q?1ViXibfqkB6kOuslaJAPr9/aF0A2RFRKGgaFOOstQO8y1h2VpA2FT/ikm1YY?=
 =?us-ascii?Q?GMvNLw6I/QwjzsknYZYhPSYDQGml4iFZLxAuEPchHwQ77BAztjG9Xo6AMedC?=
 =?us-ascii?Q?0tzlG+zeGDCwQDddpjEg2Yo4CmI/hHBg22D98EFv/hNcOnx7VXWcQWnYONa2?=
 =?us-ascii?Q?AcHLWN4M8AOSbjeAMpPb9mOygBvw2mFCGl+/8XfdxJu3CQBycZzmbT0vnYlr?=
 =?us-ascii?Q?Xo7EJTFqIFYmD3RtZnycPCyYwuWrM7QxmmHcPMufKw15ZgWQqNmhoQqEkl3k?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b00cc9-1365-4c6d-f9c3-08db00cc15fe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:54.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRL0g26bDYbwooa3g5XvXV4Wu1VBXNronlkjmC/F/jORiWyYdi/fg1qM7veOpgaBD9k4wNkFD5KKoz+cRIncpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some qdiscs like taprio turn out to be actually pretty reliant on a well
configured stab, to not underestimate the skb transmission time (by
properly accounting for L1 overhead).

In a future change, taprio will need the stab, if configured by the
user, to be available at ops->init() time.

However, rcu_assign_pointer(sch->stab, stab) is called right after
ops->init(), making it unavailable, and I don't really see a good reason
for that.

Move it earlier, which nicely seems to simplify the error handling path
as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_api.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index c14018a8052c..e9780631b5b5 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1282,12 +1282,6 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 	if (err)
 		goto err_out3;
 
-	if (ops->init) {
-		err = ops->init(sch, tca[TCA_OPTIONS], extack);
-		if (err != 0)
-			goto err_out5;
-	}
-
 	if (tca[TCA_STAB]) {
 		stab = qdisc_get_stab(tca[TCA_STAB], extack);
 		if (IS_ERR(stab)) {
@@ -1296,11 +1290,18 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 		}
 		rcu_assign_pointer(sch->stab, stab);
 	}
+
+	if (ops->init) {
+		err = ops->init(sch, tca[TCA_OPTIONS], extack);
+		if (err != 0)
+			goto err_out5;
+	}
+
 	if (tca[TCA_RATE]) {
 		err = -EOPNOTSUPP;
 		if (sch->flags & TCQ_F_MQROOT) {
 			NL_SET_ERR_MSG(extack, "Cannot attach rate estimator to a multi-queue root qdisc");
-			goto err_out4;
+			goto err_out5;
 		}
 
 		err = gen_new_estimator(&sch->bstats,
@@ -1311,7 +1312,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 					tca[TCA_RATE]);
 		if (err) {
 			NL_SET_ERR_MSG(extack, "Failed to generate new estimator");
-			goto err_out4;
+			goto err_out5;
 		}
 	}
 
@@ -1321,6 +1322,8 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 	return sch;
 
 err_out5:
+	qdisc_put_stab(rtnl_dereference(sch->stab));
+err_out4:
 	/* ops->init() failed, we call ->destroy() like qdisc_create_dflt() */
 	if (ops->destroy)
 		ops->destroy(sch);
@@ -1332,16 +1335,6 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 err_out:
 	*errp = err;
 	return NULL;
-
-err_out4:
-	/*
-	 * Any broken qdiscs that would require a ops->reset() here?
-	 * The qdisc was never in action so it shouldn't be necessary.
-	 */
-	qdisc_put_stab(rtnl_dereference(sch->stab));
-	if (ops->destroy)
-		ops->destroy(sch);
-	goto err_out3;
 }
 
 static int qdisc_change(struct Qdisc *sch, struct nlattr **tca,
-- 
2.34.1

