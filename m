Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1878A20701C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389711AbgFXJf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:35:29 -0400
Received: from mail-eopbgr10053.outbound.protection.outlook.com ([40.107.1.53]:60896
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389647AbgFXJf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 05:35:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyB6hYDZiUCFD+XinF2GeSmCCzUoh/WoLoqlfEEQ7KGGarU3LTr98W9JEWF2+n4gOa55Oj5N7kTFVYC+BjbA/MsTcjfl9BIWJI9PQ+yujtNupQq0hikg73rRUN+SiSYVJTSw4SzNFu5aHHk/og1xFB9HQkAUvn6VCD0V7QvqfFEr/imzpNgcaKWaXKYM+U24frRTfDdlJFaen1BBmz94VhuXpMdDQvHj2unerQ5hdUyZBLGByCURRuNbKv75PNf4dZxxZxMm/sGcaywezKhuhaLwV2Fl7Exy5yoctnh2WXudH9BLBd4nOCxaGy7sTENQAUuPdrZ5SBYFI3v4CQ9kiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29vzUWrklfOas2rdC2/ECp4TstA2PQz7kqGWH/t8cHc=;
 b=HLBt9KnwMkTgBTOXCvqhWkmy9pKkGSZOn4yB5F0dMFZUWy7K48vtOUAq3yd3idxxvEhJ/NXDc6YOJ+7FDjSNiuASX3rQnMfbHiuc3K57B3p8zskAw3ZLySRUC9ryUBNJjOnZCiW8tRXAJpQA8cEPMsGeUvl0qcQoggFAreV5s/ecpQpojnxirG9SLaTGR8uXouCcbmjVt0OAkHthO+jT63C5a3r59KIDOP/MKS+hq6eNH/suGeZMLrLYa3eN4kdP36uLC0Gw8rulURx4kcZORfrKlZBrUerJW37xJSwiICGLNVLqRn5MoUyaQgofFeazg8s3t+dlU/+4TAijJWA/nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29vzUWrklfOas2rdC2/ECp4TstA2PQz7kqGWH/t8cHc=;
 b=LIuZYSmg7vNd9NdtkD60gzbY6WJyQTqsoBTBEwMOvFuCFE/DOypp4rlApgFoqEIsKl3NN2A+iJhA1sXAc8etugXSf9K9ek2s57vFD8fyX+WEsLl11xExaUsQ3sjfSLcwyJZBrAS1F42AlXKdWuo03JMa+QBp+Dw1uWGOozr6vl0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6431.eurprd04.prod.outlook.com (2603:10a6:803:12a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Wed, 24 Jun
 2020 09:35:24 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 09:35:24 +0000
From:   Po Liu <po.liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, idosch@idosch.org
Cc:     jiri@resnulli.us, vinicius.gomes@intel.com, vlad@buslov.dev,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v2,net-next 3/4] net: qos: police action add index for tc flower offloading
Date:   Wed, 24 Jun 2020 17:36:30 +0800
Message-Id: <20200624093631.13719-3-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624093631.13719-1-po.liu@nxp.com>
References: <20200623063412.19180-4-po.liu@nxp.com>
 <20200624093631.13719-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0119.apcprd06.prod.outlook.com
 (2603:1096:1:1d::21) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SG2PR06CA0119.apcprd06.prod.outlook.com (2603:1096:1:1d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 09:35:16 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f6b41717-653f-4bb4-9272-08d81821ebba
X-MS-TrafficTypeDiagnostic: VE1PR04MB6431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6431BB91235501EF8B41DC3592950@VE1PR04MB6431.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dAvxe3YRTT5tCa1mb34uEDOBwfz6anC67385fKNO0eXhbLBMcAWs+J0xzjbu6y+44aJK/Ytltjw/P0VUFjeVpG80c2/DyUZIxI1Xx1IfKKVqE6H96P/a4GlnWw9ioDS15KDZZitJX0OzbXO3kHbADJyCpWT/XJmf2uXMnbMROsDSUiuDFcb4JvSvWc70DrpuUU2UM0cEhoxaR+V/EZJ1pcD5eUIcEf+bYkqwbs5tDWM97Rk3XzcY/p892inquOMcXceRmUBge3U3MFDNiBzXSBsYzCe398ztpRrUY96Z5s/X8bLJpBkSpsNd9u0y6RvBYifqG6HAOmWN1hb5W8u2Aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(6486002)(956004)(44832011)(2616005)(316002)(86362001)(83380400001)(1076003)(478600001)(66556008)(6666004)(36756003)(66476007)(66946007)(8676002)(4326008)(8936002)(186003)(16526019)(6512007)(7416002)(6506007)(52116002)(5660300002)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 28bcxArSzi+3B9y8CAZud/M5X2iqHb3wGKzbUjX9SflOdDrPvWSNW/Nq0ikRalz6YU+IVhojkrpxqK16si5voYRPCKg16EiriH5uctNXBrSJsMKlJqQeN5Af81kEVmWpokhwKDAfudmX2uvM5l8SPg5iZMogJ3fg0SWF11muWKDySElmwE8QX+2H25RxXpa/avPdzPrLAEAugEEoHkOvJN6bqJ/kG8qshiE86DjjEHyocaowToHsyemQG/WIFfWZSABTPlb+Ymp3E539qo0Gh0JVsFmW7fOjjFWjWYDqM53MDbvYqRYmsU2J6dCFvrkrPzAU6MRSO82NJlrCRm10gd8ognRravpigGQ2eHspe3vAq7cSMRdohqbnv4d3J3qcrVTEM/2Hgl9231wciaI+om3eqfDN3TuUaflnAmrT0EYpIC5jJplAEgRFBn2dv08xzaZg2MqaSAlUHKFa6hey0Uaofe02MqHrBfrezybju2o=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b41717-653f-4bb4-9272-08d81821ebba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 09:35:24.6302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QMLLCKjwxqlaNaZBxXESxA0QdEiqo/lEs71KiW0kAz+HwsYx3fZsDHduypWqXuj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6431
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <Po.Liu@nxp.com>

Hardware device may include more than one police entry. Specifying the
action's index make it possible for several tc filters to share the same
police action when installing the filters.

Propagate this index to device drivers through the flow offload
intermediate representation, so that drivers could share a single
hardware policer between multiple filters.

v1->v2 changes:
- Update the commit message suggest by Ido Schimmel <idosch@idosch.org>

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/net/flow_offload.h | 1 +
 net/sched/cls_api.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index c2ef19c6b27d..eed98075b1ae 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -232,6 +232,7 @@ struct flow_action_entry {
 			bool			truncate;
 		} sample;
 		struct {				/* FLOW_ACTION_POLICE */
+			u32			index;
 			s64			burst;
 			u64			rate_bytes_ps;
 			u32			mtu;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 6aba7d5ba1ec..fdc4c89ca1fa 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3659,6 +3659,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->police.rate_bytes_ps =
 				tcf_police_rate_bytes_ps(act);
 			entry->police.mtu = tcf_police_tcfp_mtu(act);
+			entry->police.index = act->tcfa_index;
 		} else if (is_tcf_ct(act)) {
 			entry->id = FLOW_ACTION_CT;
 			entry->ct.action = tcf_ct_action(act);
-- 
2.17.1

