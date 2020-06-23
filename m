Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5C32049FD
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgFWGdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:33:10 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:33729
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730635AbgFWGdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 02:33:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HD1FHsJCVkH7+GBNkn+t4cv/4jr1N0XmAJXqI+L9xaC62MzoX3Fz94Q0w/Ze87Vsuwii4bIUuVu6rm92uXhSjda3WyyaGTRbZuWYxuYkHlrBJG6m6JBGC4gNHXdMKUamogTth4u8AKeuLVQg7v7KR41q2khQ/sdDQkIzOdkGj7LBsBlyKrixgF5GKVd+HlYaymhbaPbfS7qSHa6hZTX/lQxwCfwtRanMwTxsCssNogLRRbXeumcStDAU1q5ZYbsjbxVltG9H8wncQ78gu5dU62VbxHybG8GFE9qvm3ECSRnJQpB5ksQJbdkOlf19r/8vazAuR8wro+jmAw8/uE7ERw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByM5pfnHQSOGibcdoh8ZP/U1OQWwIzbxrsHPfSsnowI=;
 b=LBl6D8g5fdE/E9YFkMJk5CCv0F+iGcyP6o7dHIp2OXf+hp8/KyFugQ3Lxb/7CicncLYbX+Pc8c4fWPMw/VtVQEJGw+I9M3Qd9/XPbcG2DxELx1mYCRTTo0yWr8de8RtO5sJh90p7fbNMU7jAxtR3EYAT4WXvmWuXrMiT9KyJPLvR3b4WUGiaJD2SqXg1GUZ4C/WrufR7eRJzQ6XZq21LmkFydKJkCLRgBdon6s+ZemO3SucWs2+WRqBNljlvZMJ5+SBPAPsQUjh3XvOqUN+OuCw/yMotfi95J9mhAh91wJMPkj6tAEDp8jDFxwB0YTIztuq8fi3DaadkWHdAG7CbNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByM5pfnHQSOGibcdoh8ZP/U1OQWwIzbxrsHPfSsnowI=;
 b=TqaIsmspBUVZ1iyjVNWMGIEzZD/sJw4Xq3kqcD8LNjiy9hM+q8X0lrtudJbFNxBozget93fjODPAfGCP/FhQhGBv1xgntQ+6r8NJJc84DTps5SKT4pkr5ID2ff1xtmB9Obh3DSAWbgZydPXQIMNb4kIHXmDJkcRNbidOIG6U/vA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6688.eurprd04.prod.outlook.com (2603:10a6:803:127::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 06:33:05 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 06:33:05 +0000
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
Subject: [v1,net-next 3/4] net: qos: police action add index for tc flower offloading
Date:   Tue, 23 Jun 2020 14:34:11 +0800
Message-Id: <20200623063412.19180-3-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200623063412.19180-1-po.liu@nxp.com>
References: <20200306125608.11717-7-Po.Liu@nxp.com>
 <20200623063412.19180-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::15)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SGAP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 06:32:56 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 274df7be-6311-42de-bb0e-08d8173f48e3
X-MS-TrafficTypeDiagnostic: VE1PR04MB6688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB66884E94E19DDC7FE91089CF92940@VE1PR04MB6688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NPvhIOGHNyJGUP+mu8n1ftgtsEZovAOjDsThG1OKP/PbcfN9QypqbrWN/Nwou9ASeD9uu53hiYsj1LUJhPugMLYNxIcHPA8QGpSh6iNqrp3zbTtHWKcLMeCMQzv+vrYtDU7Ph/hcl0hnnCdpBYNTaRXhulDn0AK4MMBBU3y56SEDdmIw8eOcroxMQDgPC82fhV4USeEm1NaZlLqcoW1kfabu0nAFCmUnD1crENwMptxQ49W6ZjaljSvT4zbJdyL9LnQ4lqrkJHhg6sGN6e14JjX6gbIiFtZW/Vcgw4VZjzeQPJlzPs7WMHAMMr51Sr2kDDkID3QbV1p/8t+ZfHh7Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(6506007)(5660300002)(6512007)(8936002)(26005)(8676002)(2906002)(86362001)(1076003)(66946007)(66556008)(16526019)(186003)(66476007)(36756003)(6666004)(956004)(4326008)(44832011)(7416002)(2616005)(478600001)(316002)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qxZt4p9tBhh8MHRC+0t2zxUYzrTSgvw2hziTmUvQ467GYJch9rsl5eGKxttbQVOkFjdeJsrYGJErjtSJNvyKgC/KZM0jrQQlir05issGO9SBr0J8DF3lRsAnOWFoeCU0SQkNx3wZvgtomSGFTta46SPY+54bnWEQcPocWNi0jDa28f5Y9L4dOqtzPbkEP9Rz1wAZhHHace2ScVb3PXHVK0yN9YYNQDsJo/514slxNkbVBwiqKA/meUqHcFd9QfGRRkme2EwF9ic09C+ZWgniRx2cUVVsXMROyNu+PMC7UArpeWxU123zYo3BvhwLZUCBLCrUgXy42YCifXOPlr0qZs6w51rNHKHpUwaZ3a5abJvT9xM1nxQiKOw0G2sLhRp5oqvsCl+5o/t5WdBOImCJ3mXfeNCOPKbXm6MKUBbKDUPI8AKiFJXKfYE/y5otBiMuh5YcOIJTahZhM3uiZP+yadqBM//hVbWEZF4p8auRc5U=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 274df7be-6311-42de-bb0e-08d8173f48e3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 06:33:05.5022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N51uSnAEhiliDMfMcQLI0gLdkTZhqCYXTl/4MhTCh0MW7IIRMzu01Ku0szy4Hg79
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6688
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <Po.Liu@nxp.com>

Hardware may own many entries for police flow. So that make one(or
 multi) flow to be policed by one hardware entry. This patch add the
police action index provide to the driver side make it mapping the
driver hardware entry index.

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

