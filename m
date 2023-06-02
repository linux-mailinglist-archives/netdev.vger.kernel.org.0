Return-Path: <netdev+bounces-7387-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 956D671FF93
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EDBE28180F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C7B10784;
	Fri,  2 Jun 2023 10:40:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F93F156D7
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:40:11 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2046.outbound.protection.outlook.com [40.107.20.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA20EE55;
	Fri,  2 Jun 2023 03:39:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CE4R6C1or3anRr8Q9ArEY3vbp59Agqkr7LorWhephfsnfKxrTP2zZKSvm1K+4cjvAe1tR+vMCFZysPPicl2YUmPlVPnUqQTuWtUQhxcU07bTTrmoZqMffLei1qNwLXnrbDjXXYLimnx5NT8yF0ezxEzZR/lwckvBNJdoQQruIGvVJHFG+nht9WVbBbHiVPKk/9+DE40oq3ImO5NGilS+7yo7Y1BAuADIPvTNEikvh6WDjm1DFPyHvhM8OBFpN0aGj9/Z5Zwet7oRRYLnlIAeDY7p2SYH5GkZ+ieV/tDOZ5Am3UyqAYrcH06auiVAluYQ/huJnSWSU5UtUYFfUjXGYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXbdk2K45vsjE10Ud3k19fgs/8bgShOPBxRnB3axMrA=;
 b=Zd55bgMm9mEVNyhCE75svQ6sHfcsDFuy/QY51VHpAaHtPl6DQsTnJLDZ8Prlx71jDRIkvdrrJKAYHwKMyjcW8QBBXdzJLM48akI40suzku5V9lNZgSnOrfrz9g+/C8SOjr9Lo4YuAkFCbGrvvIBeDw/E09mcmrv8g0YruU1SRquouJ6X90GgDTbvFxmREDeyrtNcrHdphFoYE3PmTAAeb2si70XlxK1suAF2ricKK+0rWig05UKPZOY+A6w+QKLN8rJ8WgS084mgjuKuWsoxvNSip9N974E+oYqE7fa7d8OhIiHQ3My4OvJCZu7BjcUrACrcZwAeZtoFbvalbbARMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXbdk2K45vsjE10Ud3k19fgs/8bgShOPBxRnB3axMrA=;
 b=WYY+gta4xnQsAyJKQyUGjfUB0PlGgDzHyCvjpR2VoKEw5QhVzoJbgmeCjKLOZ/xRkh/dUjtRWR/S/wdHeEZI65h+uG7j3+SrgCxz3hEIdaGHeZfbjX629xCkas7n10VZ/cmBo7hlhwTibf89COeG1PM479MQyKFxDnA/nuwZl1Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8926.eurprd04.prod.outlook.com (2603:10a6:102:20d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 10:38:22 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 10:38:22 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH RESEND net-next 5/5] net/sched: taprio: dump class stats for the actual q->qdiscs[]
Date: Fri,  2 Jun 2023 13:37:50 +0300
Message-Id: <20230602103750.2290132-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0095.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::10) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8926:EE_
X-MS-Office365-Filtering-Correlation-Id: 11dd662d-114c-4e56-4bde-08db63557d11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	i/EA/YngRemxgmilNbLISY7FYng1HF6O5BKknEQGVvMguISk0hXWxWipEj72dao3dw45j1cbqEhyRSi58ux5toetuHYa5Zj2YP2jJMGdtVAxl3FOWCE7Ei6T2NxsApe9yzJIjwhbCOJmBUg8jCk9mwL1eNoDgVJsKlR+CRa0mFcwdaUBkozJkEDKoFF+kQMdbaAq4IjzwVNMO6m8vVEifgTCc26NuyGrkXcokPrOJ0xLnDwqG8/mqrIF1axx2Cmn3yRCNm2VE14bACfvWD5PLR07VtS/x+PeV/93K5lZnCFxcFWVkRNl7mXnbEVxv92ctQTxXBV45IeXgOoA/5lq+qtEwniIGZepWfEbbo5Y26G6GCBIDCubBh7SLRqIvbk4Nvl1cFvoIqs5je/an0DcuzcZaIVere3Ykqr+uA/XU91Ryc3YK8kkaMqWYMRD18MPDnDixuQYTil17thm1AOfUayNPpqdAutitpNpuOv58KFrC8xsWcMdSH4i9diVRey1JaS+mei+BTXCMe4e0I7ESjEt3Q8HPJ/3Ev0ZzKZL7PurdkxPgrZU+4AoaydyetIbMwYwE3R0z1L21kjHQDmoPUHZ5F9MCvwEerJiSiEh/AlGWL1mYYuR2OOAd+wF+KoZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199021)(8676002)(478600001)(6506007)(1076003)(26005)(186003)(6512007)(6666004)(52116002)(6486002)(2616005)(41300700001)(83380400001)(316002)(2906002)(44832011)(8936002)(5660300002)(7416002)(66476007)(66556008)(66946007)(6916009)(54906003)(86362001)(36756003)(4326008)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3xq34pNfi1VKmkqLT+lddgGRF6VNY88Vtk22Mgq4r2MX4U/jYlTYefYfaXvV?=
 =?us-ascii?Q?9c2O8OrXOTvzpUZv1BUnpMPu4//a1CrlmeE5g0LHoHifL38Z7RK5pa8PoOkp?=
 =?us-ascii?Q?57QXtz1cX23w79xsArCtYWDd7kPamwpBhAYBamL+HoeAnKikV0WYCKaMtriE?=
 =?us-ascii?Q?gS0osFskW37OT7As2Xla0K+TYYqxVzDO7/g9QF5rF8MNljC5EmldMO2Hj2/v?=
 =?us-ascii?Q?OT/NmU7rg20t/U3dNdDhmXjwohgUhWLG7G1YI1H6UZIPMtyCluFZr7vExpyi?=
 =?us-ascii?Q?behAN62WPRrQ4GjCtZIzu72V2a/F2QNRmuIt9LvAnZCeL0GL3P4ERHdS5mHF?=
 =?us-ascii?Q?n7aKbhkZxPnOFZnnuqCB9l8h/G3zP2ODR1yx3XQ2YM0iMfg5bLcurumORDed?=
 =?us-ascii?Q?5GJYg6bJjTZGmtW7mNf+1gTgHf7B8hCA5B11m795BN3hAENm/UTGFM6ZRR8F?=
 =?us-ascii?Q?GkKmGj7VAsNfNEN0deKJVVVWzjmXl0vVhxIAZ3H6QLNMB5StcrFYYKKoDtUP?=
 =?us-ascii?Q?/NfcS7n9k9woUny0l/25IaTW88d96joEgpeLSD/zG6udn24nEgc6f+Lbmf5y?=
 =?us-ascii?Q?Kso7wcDcFM/8/sOONsI04x6DtRLHzsCHlTVvxyfD1NxjEExKzNpphAHxVL+0?=
 =?us-ascii?Q?Z2jEPMUKv4h4ISdHHM75dS8A33o5R1Sh4HufAOeXDH4S71EifZwcwIjctO0k?=
 =?us-ascii?Q?1HTEDNs+LaFpe9SPxZ3cZuv5fMBcrXHeMbSryOUpp5eXsU4vmjYfY2LD+3p0?=
 =?us-ascii?Q?B4xinpldC8xuCBv37qea4qBzaNO1l7ixDsjdqyY/zbMVfQ/tkZqZYQG9+E91?=
 =?us-ascii?Q?q7jHfcSg0elscHd8oYbYaMYb9Uz+0Lzh0EItbf2qo9KUzPn8poTwdwVduWXP?=
 =?us-ascii?Q?CJhdiC9NAjbMs9dLbVaU8NXuvJ2xxSMT4zItcVqgiI4Qz/FDAV2W70tVZ9/L?=
 =?us-ascii?Q?pNom3R7037vEFPmhz24onKBPgNiKSD8e+BBSwlNy1nKB6y5Iu0kJsZS+fhxz?=
 =?us-ascii?Q?c1/eGM7SOLzsxyRiWCZWEwlb/7LUjXuAEPZTG2OoKAVqNTDLizAOoAYetC6f?=
 =?us-ascii?Q?bBlAQcPe0cX+kONxVqTHuKfgbWK5XNlER0BmdL3zcIt7DwrC5F+9HBxkcWLc?=
 =?us-ascii?Q?5gscCF5B/nz3CmGB+Fe+QrnKW+/U/b7Fz3HKWXSR0ubOSW0ZGyG+2WjdZN/q?=
 =?us-ascii?Q?QQVjBSwsFCxKosLJJPZm68iI7ND4MgyFqY1ZrGvUZUDT+58v8UxyAwZ+/spy?=
 =?us-ascii?Q?D7d+f0tToiV7ZgC8vv6PYAKFN8+vuplxGyv7xsmVOU6MNkOHzWSnIaY3i/1K?=
 =?us-ascii?Q?dbKI0BcI7aqxlajURUv+CFc0jBK0muQ9XK9x+7RQSXxXCzU0y92TRZo72ldy?=
 =?us-ascii?Q?9Xx/hNFzxkUcJ4urZjgGykLMlaEIvDBnkVdUxfi6nr+HNxJ4xdbYcrLwb+fh?=
 =?us-ascii?Q?09OvrBQklA/DRwYdVr5iVtiOfLku1tHCZVr5b5KrsdHMc6zAe1k6KDp61PQh?=
 =?us-ascii?Q?WkpT125MF9u8ftEDlMcjV1MErb2nViUJK6M56L0Ug4iDYAVdbbJlZuhNgZ2J?=
 =?us-ascii?Q?uZYQjZJVsFZFts9u0nWOrrdnt68UnV4dRbt8UljktbRnYA/LWDET784Cg+zO?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11dd662d-114c-4e56-4bde-08db63557d11
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 10:38:22.7460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e164Z5SrPKEjdbMveHmgiKqXd+t0Rw+jVUAUN8ul24EJY8HeV3IGpYQMulVfoeNdQf3XXjO08qhxB0LpGN4RzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8926
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This makes a difference for the software scheduling mode, where
dev_queue->qdisc_sleeping is the same as the taprio root Qdisc itself,
but when we're talking about what Qdisc and stats get reported for a
traffic class, the root taprio isn't what comes to mind, but q->qdiscs[]
is.

To understand the difference, I've attempted to send 100 packets in
software mode through traffic class 0 (they are in the Qdisc's backlog),
and recorded the stats before and after the change.

Here is before:

$ tc -s class show dev eth0
class taprio 8001:1 root leaf 8001:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 9400b 100p requeues 0
 Window drops: 0
class taprio 8001:2 root leaf 8001:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 9400b 100p requeues 0
 Window drops: 0
class taprio 8001:3 root leaf 8001:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 9400b 100p requeues 0
 Window drops: 0
class taprio 8001:4 root leaf 8001:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 9400b 100p requeues 0
 Window drops: 0
class taprio 8001:5 root leaf 8001:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 9400b 100p requeues 0
 Window drops: 0
class taprio 8001:6 root leaf 8001:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 9400b 100p requeues 0
 Window drops: 0
class taprio 8001:7 root leaf 8001:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 9400b 100p requeues 0
 Window drops: 0
class taprio 8001:8 root leaf 8001:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 9400b 100p requeues 0
 Window drops: 0

and here is after:

class taprio 8001:1 root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 9400b 100p requeues 0
 Window drops: 0
class taprio 8001:2 root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 Window drops: 0
class taprio 8001:3 root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 Window drops: 0
class taprio 8001:4 root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 Window drops: 0
class taprio 8001:5 root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 Window drops: 0
class taprio 8001:6 root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 Window drops: 0
class taprio 8001:7 root leaf 8010:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 Window drops: 0
class taprio 8001:8 root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 Window drops: 0

The most glaring (and expected) difference is that before, all class
stats reported the global stats, whereas now, they really report just
the counters for that traffic class.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index cc7ff98e5e86..23b98c3af8b2 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2452,11 +2452,11 @@ static unsigned long taprio_find(struct Qdisc *sch, u32 classid)
 static int taprio_dump_class(struct Qdisc *sch, unsigned long cl,
 			     struct sk_buff *skb, struct tcmsg *tcm)
 {
-	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
+	struct Qdisc *child = taprio_leaf(sch, cl);
 
 	tcm->tcm_parent = TC_H_ROOT;
 	tcm->tcm_handle |= TC_H_MIN(cl);
-	tcm->tcm_info = dev_queue->qdisc_sleeping->handle;
+	tcm->tcm_info = child->handle;
 
 	return 0;
 }
@@ -2466,8 +2466,7 @@ static int taprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 	__releases(d->lock)
 	__acquires(d->lock)
 {
-	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
-	struct Qdisc *child = dev_queue->qdisc_sleeping;
+	struct Qdisc *child = taprio_leaf(sch, cl);
 	struct tc_taprio_qopt_offload offload = {
 		.cmd = TAPRIO_CMD_TC_STATS,
 		.tc_stats = {
-- 
2.34.1


