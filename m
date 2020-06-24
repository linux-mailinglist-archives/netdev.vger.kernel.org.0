Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5DB207019
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388005AbgFXJfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:35:11 -0400
Received: from mail-db8eur05on2073.outbound.protection.outlook.com ([40.107.20.73]:6021
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387717AbgFXJfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 05:35:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQPG+/QsiRPgnq8K7otIGUuvkJltnn8I52bURhhf0thlyeGIJVndULOQB7RM/yh7Bl75c7QbekIXF4+DIA/bbVkV4tDdaGxfC6zWvKAZQcWOAlvIN8mi4zYmCzzhpDc2eW4SWcXw6ZhN+Ur+0IcrWJeeYDPp5q7kiN5yggRXel2eNWowchiSNcPZaFwFzGR8NGEEe/uJyuUTReTFIGLuGjS6zGaXwx9to23liNMLiGegfp5iCWRDdkO3AIAU9w5TlTOLgGi73UrO9qzPVJBOFqgl69fTP+RDK67+jOzuNh0wv7XarX08efKnCVMyTI8vmKieJi4ZXVTC1HIAKyRV+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wk/7yK/NJ+kHw1t46DYadciZuuqj3JuMjhqot8ry/ko=;
 b=eQQnaeRXMMcw6yapj5y050gT9bFy2Mp+GFxl0UiFkBpVJuEWSu6+gJxXexVOkkfoVmhxZyB2qReUyWYYVo2LbMM7U7QsG5p4B2J5XAK6w4M7SsluDuwfdAYRN2hAHy/rIeFy89EyFXuXXP93sW7wMisddbglf+mqzLktJL0taa7wmP19MzPAAoe2cj2UxtXJre/1NpEw6+v+qkFTJQe4uYxs/pf3MITa8i0Hi2/oyfqpWhjbzCQBeervvwPskLKbGwIagMIl3ZezdN9DfpQMCiVq2SG+h7d7/T5Scjfh6GSGXb/2WQWuKTEHPar8qSFtK1s6nmy3S+EeSI86okKVWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wk/7yK/NJ+kHw1t46DYadciZuuqj3JuMjhqot8ry/ko=;
 b=BaRAnn0TCD7IjPomjgBsrX+6fAh9bBrbYUiOIQAIWJQtYGenIGNkPNDnDllo+Fj655cfWlQpxk2gZh7tBqzjwsUgyktpAcarmBbywki4rFTdJXzb01FjjOdSWCwUpj3JCEjQuFM0deYEHf8a4ypMby82uRCXB61MXROyaIq4rMU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6606.eurprd04.prod.outlook.com (2603:10a6:803:127::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 09:35:07 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 09:35:07 +0000
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
Subject: [v2,net-next 1/4] net: qos: add tc police offloading action with max frame size limit
Date:   Wed, 24 Jun 2020 17:36:28 +0800
Message-Id: <20200624093631.13719-1-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200623063412.19180-4-po.liu@nxp.com>
References: <20200623063412.19180-4-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0119.apcprd06.prod.outlook.com
 (2603:1096:1:1d::21) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SG2PR06CA0119.apcprd06.prod.outlook.com (2603:1096:1:1d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 09:34:59 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3aa4d165-68ef-4728-5808-08d81821e1b7
X-MS-TrafficTypeDiagnostic: VE1PR04MB6606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6606A6FAFFBAEB95619463E492950@VE1PR04MB6606.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvYECHEAW1AM7c3eQGzMKQQuT3GNvjvZleKqCyAS/IJKTGIAFOkj3abYxBMkymARebve+SLF2SwxhBVvrXMjCI/vwa/Pue9mmLaoV1brHTQhADaBXjL5nucYMUKiiPuSveHnA0VnEZTL7RMAwL6ZFg3Bo+/MCHbmXObaTUM6k9qFpu6KIA7wCC1DTWJYQbcDjTmqO4/2kX+WdGYjGRLwBkMYZU8AHuvVc/EQBC9sqdLdNy8xlNwZ0o2SRBWH14nnKxMRVuAmYm9NzVQlIFup8J5WRaTZfr+8CisewvBuByK4EipODiY6wZ8xpHM2kw6Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(6512007)(6666004)(4326008)(1076003)(6506007)(186003)(52116002)(26005)(83380400001)(2906002)(36756003)(8936002)(16526019)(8676002)(5660300002)(2616005)(44832011)(86362001)(7416002)(478600001)(956004)(6486002)(66476007)(66946007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: u3U7T+w2g7XKEuVo2OOWiDfM3M3oqhezGsQnZj+Hc3Yai3Blfzi/iqNM1DJVYeHa5W2gzuL6vssU7mkJCBnc+K0Uwa0dnwvhFN297OVa17A645jN7W4nhkTdG/j2I29AnOHVV8g83pP2njmhmSIWxtx6hNochFR65oLFUSPCrvNOmIf607719G6a9aYjhRTFRRIIW2Cu5yzh4560pWGXiwLObYxMZyDK4ExBVyO8E02QjwByEhkkbFybosFp8vT/ZEJ1/r1Jeba7RMAk18L0LorlHbat/i+xFQieLfdFqvsBaKZXiMTvhQIq7CcNItIH5HM7ybCZJ17gLAR0FjrRyAv+2WNbVfh4dDjh4oqBLFUO1ZkD5cqDynGFHlYv9BPMGovS5/wo2wKFJUVKW+vYCPW9uRBAyMqPEYrojp4iVjqmz/mAR0sogsKeNvdOwzmH/QU5U4H4j1ZqV4/itTg3Eyn5ajbYyCqdYItEiM0ffug=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa4d165-68ef-4728-5808-08d81821e1b7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 09:35:07.6909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TGfYf2V+RQHGg+WDchft4w4yBWQbAmtzQ0W//DwNRNoPQeKu/PMfkLDouZWeLVOX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <Po.Liu@nxp.com>

Current police offloading support the 'burst'' and 'rate_bytes_ps'. Some
hardware own the capability to limit the frame size. If the frame size
larger than the setting, the frame would be dropped. For the police
action itself already accept the 'mtu' parameter in tc command. But not
extend to tc flower offloading. So extend 'mtu' to tc flower offloading.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
v2:
-- No update.

 include/net/flow_offload.h     |  1 +
 include/net/tc_act/tc_police.h | 10 ++++++++++
 net/sched/cls_api.c            |  1 +
 3 files changed, 12 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 00c15f14c434..c2ef19c6b27d 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -234,6 +234,7 @@ struct flow_action_entry {
 		struct {				/* FLOW_ACTION_POLICE */
 			s64			burst;
 			u64			rate_bytes_ps;
+			u32			mtu;
 		} police;
 		struct {				/* FLOW_ACTION_CT */
 			int action;
diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
index f098ad4424be..cd973b10ae8c 100644
--- a/include/net/tc_act/tc_police.h
+++ b/include/net/tc_act/tc_police.h
@@ -69,4 +69,14 @@ static inline s64 tcf_police_tcfp_burst(const struct tc_action *act)
 	return params->tcfp_burst;
 }
 
+static inline u32 tcf_police_tcfp_mtu(const struct tc_action *act)
+{
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
+	return params->tcfp_mtu;
+}
+
 #endif /* __NET_TC_POLICE_H */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a00a203b2ef5..6aba7d5ba1ec 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3658,6 +3658,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->police.burst = tcf_police_tcfp_burst(act);
 			entry->police.rate_bytes_ps =
 				tcf_police_rate_bytes_ps(act);
+			entry->police.mtu = tcf_police_tcfp_mtu(act);
 		} else if (is_tcf_ct(act)) {
 			entry->id = FLOW_ACTION_CT;
 			entry->ct.action = tcf_ct_action(act);
-- 
2.17.1

