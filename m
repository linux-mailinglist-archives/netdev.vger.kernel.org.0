Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB5017BDF7
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCFNQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:16:17 -0500
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:32801
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726866AbgCFNQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:16:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrCDOOWQw25FB0tzuR0C87Sd76H8DwVjJ0rrM078TMM69SxLpXTPVhAdQY3bCLjgghiH1zAlBr+jFCuMWrPuGqLK9H5pj77qtGYmA5msGVHlQ1Zb5ZDgQlH9WkEfJawVqsMSi+9ykoU91vtBWWqVF5j6Y0Mi4WDkOhDMnKXkbNJsLaJNRYAjNcRwqQUAe3qqudYoIv9u0XvfMdZs8q83bwFwHzhhD3Br+N6Ryl5ncpwSDTEvLp3Qxso0QAA7RUjETH2AaN79q5BaakRy2iLcJnvcFOVfcJ3wPg0rGJKJlZsCqkMojR0nBXsUv3cVP2qr1T8pd4PgkhxpzpoNZ/ZGPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGQwskNnTAipeTV7f/OfrX4WGtFepkI5HKllAlPYue0=;
 b=bDEgpOrS/9OC5EWA8tsyryrJ/48jzOGLe5KH1Pr35heT0lWvUhUrO0P+drYU8fdlwckbykwoTtJ3HYjrmXykRgs4K38qyc5dytf1ul/sg8c0dEsX9kxNKYcDxRL7CG4eya8REgZcslCa4G2jYydyyWyn0lrRiNrqVFym5UbjjjWmT+u+vnjx2f19iRY6e7mR1cIkDUnk0zneSiEOHoG4xC5wfoGnZzEq36xrsTR0JYEgRVGVxR9cgLIgvUuJFEvzbpWnj3msB+eLDk737tuqdq5CJUqUC0iN2ph3FEPg8Ny9wUr9oGIXgJw14UHujnqh930J/MxK1FFDyWWCRtOP5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGQwskNnTAipeTV7f/OfrX4WGtFepkI5HKllAlPYue0=;
 b=sKasi5A8Dz4ErEQaOI52BbaKT8eUnyhIj6vgs3C87TOCNhnhWFQJNulx/z6jXCrpLYdjG9lp5K/zY2NgK5EFRGeW1HZ+IdP540q8pe49CP4doLC0uHi+S6VikI3PBkwYRFq4CgLIOoNyHcd0iH0vxLFQIf71VH7NQUttweImAXg=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6527.eurprd04.prod.outlook.com (20.179.233.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Fri, 6 Mar 2020 13:15:31 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:15:31 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        john.hurley@netronome.com, simon.horman@netronome.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, ivan.khoronzhuk@linaro.org,
        m-karicheri2@ti.com, andre.guedes@linux.intel.com,
        jakub.kicinski@netronome.com, Po Liu <Po.Liu@nxp.com>
Subject: [RFC,net-next  6/9] net: qos: add tc police offloading action with max frame size limit
Date:   Fri,  6 Mar 2020 20:56:04 +0800
Message-Id: <20200306125608.11717-7-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-1-Po.Liu@nxp.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:15:22 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3dae1bcc-a60e-4bd9-0996-08d7c1d07263
X-MS-TrafficTypeDiagnostic: VE1PR04MB6527:|VE1PR04MB6527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB652716F178581E273E767C7D92E30@VE1PR04MB6527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(189003)(199004)(16526019)(186003)(26005)(66476007)(6512007)(4326008)(36756003)(66556008)(7416002)(6666004)(86362001)(478600001)(1076003)(81156014)(8936002)(6506007)(316002)(81166006)(956004)(5660300002)(8676002)(66946007)(2906002)(2616005)(6486002)(69590400007)(52116002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6527;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iL/0tsguTJkPNAFd+TgLSEB4zSbnYLnnSriSC2eqdq1HQmfQUBQdmACsV77OWOw3Yg907sOIYvkVHzeEsyGdETuWp5eIvA5u5WCheYdBv0V6eaI5wtdxdwi5bSC1f4YAx3AibeZGta3XXMbMWb9yCqErAZVeG+jcek1e4G615KbA3keoQy2StyrHP0/e5jul+WDeyvtUB43OEwNoHxgY5HnADzuB3AR0qomTvsYfY++CE76A2E0pvfdNuUzd4rcv6AVfWx6AAkIgO+jiFXbzzrnnnBew3YE57tBcpiL3QO3l/9ms5Qzn0xvpPh5qdzxHfHV3NxSqUViegnMbrzfAmDG5WLUMpB73zmIyOe43XFbseFvvvsC2pqs9gKms0TTyC8z6sXFTX6tzcc4e1bO5sWClwbNFizPe+KpIL+JlXIQFMtLr8NYslxKaN6mykqsLiOGqCZI2xHGyUDwoiB/4eWg2EEe64McOcr4uKftYiBA0LklYE9KW2muKAjNZD1Qqr4TvbhEyqniiEwR5sBfNnw==
X-MS-Exchange-AntiSpam-MessageData: WzzuahKiok03h0b/JJtMS7uKzIYZDMazzEFB4tX5R553gnaetiEP1xTng7tKH1v6kW4Zs4wkQUa3wbUtrl6Tus4/hwUwJEaOSYqttgsaIxM8byo2KXqhygXyQflTO/LQiXc8fCUQJlkv1ucXYzOPGQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dae1bcc-a60e-4bd9-0996-08d7c1d07263
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:15:31.7013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kpTPbIz482e7ULe6d93zbhimrDNo19Wj+UQtJGZeKiAidE10b8RmvxdicEncQjd4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current police offloading support the 'burst'' and 'rate_bytes_ps'. Some
hardware own the capability to limit the frame size. If the frame size
larger than the setting, the frame would be dropped. For the police
action itself already accept the 'mtu' parameter in tc command. But not
extend to tc flower offloading. So extend 'mtu' to tc flower offloading.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/net/flow_offload.h     |  1 +
 include/net/tc_act/tc_police.h | 10 ++++++++++
 net/sched/cls_api.c            |  1 +
 3 files changed, 12 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 7f5a097f5072..54df87328edc 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -203,6 +203,7 @@ struct flow_action_entry {
 		struct {				/* FLOW_ACTION_POLICE */
 			s64			burst;
 			u64			rate_bytes_ps;
+			u32			mtu;
 		} police;
 		struct {				/* FLOW_ACTION_CT */
 			int action;
diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
index f098ad4424be..39fbf28f8f3e 100644
--- a/include/net/tc_act/tc_police.h
+++ b/include/net/tc_act/tc_police.h
@@ -69,4 +69,14 @@ static inline s64 tcf_police_tcfp_burst(const struct tc_action *act)
 	return params->tcfp_burst;
 }
 
+static inline u32 tcf_police_mtu(const struct tc_action *act)
+{
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
+
+	return params->tcfp_mtu;
+}
 #endif /* __NET_TC_POLICE_H */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 0ada7b2a5c2c..363d3991793d 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3583,6 +3583,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->police.burst = tcf_police_tcfp_burst(act);
 			entry->police.rate_bytes_ps =
 				tcf_police_rate_bytes_ps(act);
+			entry->police.mtu = tcf_police_mtu(act);
 		} else if (is_tcf_ct(act)) {
 			entry->id = FLOW_ACTION_CT;
 			entry->ct.action = tcf_ct_action(act);
-- 
2.17.1

