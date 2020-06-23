Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE842049F8
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbgFWGc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:32:57 -0400
Received: from mail-eopbgr10074.outbound.protection.outlook.com ([40.107.1.74]:17585
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730635AbgFWGc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 02:32:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEgxzS9GQ+CcNJ0iH4gYWyNIdlBdmoHiqBbh21ledmkQLTG4Hm7lpZvJeIQ5ZRNuMR2aXy+WrpkvICeyxMWA1FfAH4z4p4EqvlYOyS9zHJi72qacRde0Ikdi6BwSoWZH5+pIKRg7tNab72Q4tk6Xgup5JH9K9/1PzQmqMBBTi+fVgjCK7yZD9IY/uOosogIyNoUc11m/TCWjmpAYpFu0loRPJk3IAVAXjgLK8sVD9H5aSdurLwf9ocyeOvqAi4wJ2RqEHiIYdF4hnNdM1CwQ9AjFByqBPvA+0GuPZircNoFxz5551L+k+HoQvQxD8J5BIlPEm9ZzKT2qhuVDAJYfag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaeDAoMV7F+rZLYpouIhZ3PIcYsLDXxL/vglhN6tsJM=;
 b=She3LaKMo8lABwnF3AQ3X3h9Bk5YJdRl8lvBh/FFqIYgSIAGXDfNAldK8wfWUnhj+ubCDucqgHdEY40xL79k7FxMrvUbp1ZkGQKNahHfOmQG6td0NGH+9HEG5pUX2lcQmrGp1SskZnj0fygCh9GfY9DMGCRoLFuA31PuW7qsraHGBLSLYAEre4LDRXgTqPUCtjeTXduEO2EPEkXqHSPqXPPp3Md9WD5Gf48Jc3WMNQHGNDfFOkupvDEGID5eZv706cRHKaVAWoIdZ7jiSDoHiLnJxznT9xkPcSE7lGpygZ/8b4Uxx2APfQVdqwG5eMwDTaIazC/z1pe1LQs8HnVWWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaeDAoMV7F+rZLYpouIhZ3PIcYsLDXxL/vglhN6tsJM=;
 b=SJQo6jzB4204iLCq0AwElcP15+X3B+sbGtMA/gbhOLsozWjHfjWe5cZv58vSKEQ2q1oc1DqRQhzECI5Q0q5h7OjtDLkKINEW/Vod/QeIHlF3jDJnTKyT8vRbzrHx4kkFgY4uqI6ONlHk3SXqBSua4OvOHNxA88Bj855Y8pWS22s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6621.eurprd04.prod.outlook.com (2603:10a6:803:124::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 06:32:47 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 06:32:47 +0000
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
Subject: [v1,net-next 1/4] net: qos: add tc police offloading action with max frame size limit
Date:   Tue, 23 Jun 2020 14:34:09 +0800
Message-Id: <20200623063412.19180-1-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-7-Po.Liu@nxp.com>
References: <20200306125608.11717-7-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::15)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SGAP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 06:32:39 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 144b57fb-cae6-4d43-b8b8-08d8173f3e70
X-MS-TrafficTypeDiagnostic: VE1PR04MB6621:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6621CD80DFBC359D74D7A5EB92940@VE1PR04MB6621.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9c/pku/HwBFZKduT7iiXaDGQQ+KfkiH+iRKcEumw6XvzEkjZfkLvCleH/NJvrBTkgDYMqJ9qz+/PybnlWJaORGurEmSgkmsDXbohmdb5d5yCe+/BYFuBEGXk1Y6T7ChJk9uxnQ2djUlZpC7yHaFZ9LH/hOw6TsV/f9XXdv9Qsbe56WBdOvBtaRkk1JVyoL8Fe24zgho8GR7VjtTq+ogiRsIjLqTMWv4G+XjXnw5GC8Nejs76ZkIXIF/NkvFt5tvd/g3Je+oDzEWApmDiGygtk7MiOjvE7ShQT8MmJ4irYDjmEJ/WdaNOCaCh6rsA/tQN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(26005)(16526019)(52116002)(66556008)(66476007)(66946007)(186003)(6506007)(83380400001)(4326008)(478600001)(36756003)(2906002)(86362001)(6666004)(44832011)(1076003)(7416002)(5660300002)(8936002)(6512007)(2616005)(6486002)(316002)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: j1/5ErTf3GEHkRI2qqVpXBrcpf+rGglpm7zuHHvk6/obr+13S2BB7e7Li+tLqpqzz4kPc9XGudfC3WSELbz6CaVcJq/yq7zwdh2vpzNswrNEvRNq9qit1V505z85kzl4JdI+zpaVqGLBbJ2ePOAkx8UA2dKdPczrI6vds1U3CvTZ63KztFL80JFzV6DM/6L0NxDLYctA/CnkEUIYoKO+s8UN4QQx1aLKyXx3+Uw3Ehik/eYupvPajCtLRci+6dkL0kKBCiJ2eyNDCYt1Nz2bvULRTo5HeCz3jpxtEqRZXk7XOikRp5Gj3lsMkT8JuyHMZEUV9iedZKqv1zk49Hp2qQd13UMTl3a2gmm61R6vWUqSWtwO9sLXY4ofAbF7aZ90iCOL/g3NOMQUqgTrwn7DA5h8egdFHZX6d3iSaaZ9oxPOQn3NHLqLl1uB38YEngygeTSDvKRKgijO+LOcHcxRatJVpTJNaFK7mzGo+9Vx3U8=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144b57fb-cae6-4d43-b8b8-08d8173f3e70
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 06:32:47.7844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ni9th+IsA6PZgytrdv60IeYnarKmfjg4E2cMid+aU3BWOz4S5Hzhh4BUvNgDbFK2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6621
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
continue the thread 20200306125608.11717-7-Po.Liu@nxp.com for the police
action offloading.

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

