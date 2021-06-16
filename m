Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BFE3A96C5
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhFPKEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:04:52 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:37984
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231931AbhFPKEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:04:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4sqyHaCBgxeUuzPp7d5wShjg3qG7iLwUS0zYOSwW1lBNTddoCaWQqFsDfUmNa/XxvpSAQY4Nv0l4PR0dtQlfjvsDvBbg9fACKKe5C7v7fP45UujCrn2EANlHETb8YXDARMTsJDhHygvDMGv74hRCHbKU9LKMR91mqEz/yXsQwyaICO6/HOa4l7fDzwzkF2oAIfCtzMwHCCUmnGr6zmxxUOMcG7UQWNJDsRYyJqUfvSFs8etiG2CoIk4mPi0oRv93tlnRbS+WVbb/dbR0guhLfgSPFRFDPH86repemnY1k0PlHmzdRw54iVzB3SM4EfaVCPHcxBb7LWOHIQH5bkQmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5jPKs4OvZv4XUWnf3Tb1yx9S46w/P2ePKl9QuzCaVc=;
 b=Z2sXIXs06bIVS9j7lQujTKDz6V35MXXxGYicGyOn22UkCN/Xzy+MIt42GxeqcmqlzHrmdFgOG6NcVh9sNET4qxqIz4UJQo+BYz/8bkC2VKnVyS8UY/rWY/f8hYP5nHEb9emUrD4nK+oRbGhSpmwQJfLh+OUTzvN6sVMZWp4kJdBCw2DshMUTNZTdh/oKjKsh5wkwlaxwH5Dr5NAed27bS6FQ2F0pytfRpJvKBvd3Xa6ODIlpDQ6k6SGBsWTp0yznoAiRfkN9wQPBKbPXfOnvrz+XKL7nNTNN3er/iRFlGihk9QYQJR4dKzmpPEt0SdDcHt8lX5bTOCBKsDkezT3DtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5jPKs4OvZv4XUWnf3Tb1yx9S46w/P2ePKl9QuzCaVc=;
 b=rThYFnWpJUQPzJTZFxmtQMWXE+lbzN/OTG3wsHaEHL5Te9B0KNlYjgMPPlyfpqc5pytsWcmN6/dOEGHVs/D7YwBTilzTV3Lc+U8qplvS86yZa6VXLk5AS14zTVm+yIrQf1K/dEmCM18RO+4aan8jZFxZpsd2weFhdAvil0R/Ctg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4971.namprd13.prod.outlook.com (2603:10b6:510:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7; Wed, 16 Jun
 2021 10:02:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 10:02:28 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 2/9] nfp: flower-ct: add nft callback stubs
Date:   Wed, 16 Jun 2021 12:02:00 +0200
Message-Id: <20210616100207.14415-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210616100207.14415-1-simon.horman@corigine.com>
References: <20210616100207.14415-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:756:703:d63d:7eff:fe99:ac9d]
X-ClientProxiedBy: AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:02:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6be393b1-e36d-49d8-f84d-08d930add97b
X-MS-TrafficTypeDiagnostic: PH0PR13MB4971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4971E86C9C1049564C25AF8EE80F9@PH0PR13MB4971.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: haI9X7zM4/MmdFbUqsDGOTc+9qrMU9qwn+AqMz6xVFxwCGy7SJZC9G1tx3dIpNti5uFRqaBm7qdztE/sscW00Jqw2TE3ltzj9rKKuchRXN1sTGjzB/oBPVKWL3mFSkZ/MJEgUfWavy5KzDseYE+F3ul65Y0i4ZIiQnUHKN+ObAi01aGlD4B5h0s4oPWypMcONsJTTIRHWW8NWeTmxIJ+p2RYkT/p1b/tnWc6GJuZ/mrDu0cYaruihCeLDFy4JlIYo10I4pSEap3t8PgdG8X+b9vRPL7VadgqZ8LHr/EiNdijES277vSRYNPP2wKfa+wq3V7GVuTu+3KI6uRt0zqzIwcENE32jBvP5xd4oS1I4PCF+1Dcp58PuIWCKqFFrMmeXGW+4sdvuiwQL3cspZAoWDe7wwVc6LzR+ttjnN0kUMDm5ddS3QWi5d/qljdhYGNafAMuBQigIUoa2AMoX72g0kd5JfMqD+B6RbjEU/zS1UQcSTlenUR6R5u0TXuwnSj84Zd5/Jln1GPctlTJ/aEbwQ6KJJ+CEGzJAn3v4mmH30V9EskBq0rBMPYFpJJx7Ru2NQhzthdqb2o4ZFMuLHpllwoCDAt178EpNf9IfQ3k6wMtv+wR9HObUmWe9T5Hdfba8YVlWARg7Z/rvmTmnuzE6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(66476007)(6512007)(8936002)(66556008)(66946007)(38100700002)(4326008)(86362001)(2616005)(6666004)(6506007)(5660300002)(8676002)(478600001)(1076003)(110136005)(2906002)(316002)(54906003)(16526019)(186003)(107886003)(83380400001)(52116002)(6486002)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GooI5M73KgtGCc/BjQj7IjuGmVCOjhD+usQK3epnr0SXK3DZyjv6IMOCsYSX?=
 =?us-ascii?Q?ifxJgq6Q/A8ksYu3E2g/1TFNfavS1cgfdpXTe/7cDFLwKq5a5Bb1k0SIDTYF?=
 =?us-ascii?Q?RknDzEnXTxt8yETqLw9huOxpVSVxhi7b2lNACt/st2lxcY0axOTv8jz6obnf?=
 =?us-ascii?Q?RO3IwmP98iTTVWh3t4MJ7eLNRhogxl3x9v6xawvf3LfcXu5wL/2vp3KAdH5G?=
 =?us-ascii?Q?nyBa/ztVSe0GbAy0Ld3AbXj3qD5EyU3ysnG/TIToTHGZGuIcXCcppLrakOcK?=
 =?us-ascii?Q?WuRqLSa9LxbTnDYA2cI8ORu8/iUYQllxfDwz3V1CPJ4XmQZLDkXrDWeIZH90?=
 =?us-ascii?Q?EL8K9znH7NuaKLbwXSDfzCzUkBep8ussqYGVVOTihWEbrwt7ilzWg7OXy291?=
 =?us-ascii?Q?6VTBFAdrVjeRdE/aWIPaJaGGJdGOUTELxF56xNldUhi2RHmq1dy5vtdh51Yy?=
 =?us-ascii?Q?bnxps/Dijpxbu3NonTMzpSDgctu37lmcNKpZbehnTzGOn+1m9mRWK8/FUhYN?=
 =?us-ascii?Q?YASBYUeIpHJvd5+jN8V1WD/N7pur05ipdoyNrq9xwGQnB+GIYJGRJlCpm4tg?=
 =?us-ascii?Q?snRhidUZtSjmhr08DJ2t3ugQf6gIjIRZTTxbCbgfNhtyBs7YNuUIVhbP3pyR?=
 =?us-ascii?Q?+3cn9lBrdr4MDK7n9AV791zZYjirJQ1S/cDx4tIonFHTCRZGVKj1h2IgnuZo?=
 =?us-ascii?Q?VVYzkmXBxdQTyrQTeVM3KKxeLkwl+qswCY4Ttpyy/BgEUcN0V2/2/a45wjKe?=
 =?us-ascii?Q?GMOTRJUMAc/UWHMA2UeKMGpTj1Hk/CjToEwQ2OO8bBQCbCzKeA21WwzgEJR3?=
 =?us-ascii?Q?gUyjNQQ77xIbaFSiCQZFpCydXOq+N9IHTs4aZ3IHwD4kzUr9eg+sJa9qGNNL?=
 =?us-ascii?Q?gYoOqzDS7S05yNTNjdfRR/4ZO4Va72L6rxDGBtRYucHEroo1+H4Y8WPu463f?=
 =?us-ascii?Q?ln+B969Jz9KKq+n4/PxlWsjf8jGNa/I7INoCMu6WI2YvN3r4rQQ7mg1MIDpa?=
 =?us-ascii?Q?L++jrlA0srCWE7QLlTBQ5yyjUDmi5F7ohHf7U7k9kmkrnsH7uiE/p6VkZEP7?=
 =?us-ascii?Q?mR0xDu55a/uWmiPLxbs4pfJegkY4EW3Is6LNiJZMsTaOwu/GJyEh7/nG0xbe?=
 =?us-ascii?Q?yzPFPORqhhqJE9UKEQ/QIEhlHqA7n/ckjg2M0xUHVGqpunpCteDznj+vvXxf?=
 =?us-ascii?Q?6PH3Ff+OJrcIGHtVRQY/fWI9HqW7y5JHSUvQOm9gDw3nAGP8fuBsr/ZJlOqb?=
 =?us-ascii?Q?GepFDu4wfk0e0U/9TYhCoaeRXyCbeoIfxZSgAQYQFelEoBiaZBIQPnhRcoqh?=
 =?us-ascii?Q?uGTJnkt+8uTRq6HM1vqaudk40V3FZBeX1z8k8RYPzd1dB72RwtpD6yIFKL27?=
 =?us-ascii?Q?lu2gr00QvsLd0xdx5pCwzoQhYkzJ?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be393b1-e36d-49d8-f84d-08d930add97b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:02:28.6986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvyTYVLJWbNYQ+1ni2iGfhPSrmJZ1mfkiPPc+vgM1kB8sHzAmpUBT8l3e2r2P9p8XkrmfxHXWinvVPy5scvZl0K2nF4LjkYskr0rJJzRW7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add register/unregister of the nft callback. For now just add
stub code to accept the flows, but don't do anything with it.
Decided to accept the flows since netfilter will keep on trying
to offload a flow if it was rejected, which is quite noisy.
Follow-up patches will start implementing the functions to add
nft flows to the relevant tables.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 63 ++++++++++++++++++-
 .../ethernet/netronome/nfp/flower/conntrack.h | 11 ++++
 2 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index ea70e02d170e..7fb51e13faea 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -384,6 +384,7 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 	struct flow_action_entry *ct_act, *ct_goto;
 	struct nfp_fl_ct_flow_entry *ct_entry;
 	struct nfp_fl_ct_zone_entry *zt;
+	int err;
 
 	ct_act = get_flow_act(flow, FLOW_ACTION_CT);
 	if (!ct_act) {
@@ -406,8 +407,15 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 		return PTR_ERR(zt);
 	}
 
-	if (!zt->nft)
+	if (!zt->nft) {
 		zt->nft = ct_act->ct.flow_table;
+		err = nf_flow_table_offload_add_cb(zt->nft, nfp_fl_ct_handle_nft_flow, zt);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "offload error: Could not register nft_callback");
+			return err;
+		}
+	}
 
 	/* Add entry to pre_ct_list */
 	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow, extack);
@@ -489,6 +497,42 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 	return 0;
 }
 
+static int
+nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offload *flow)
+{
+	ASSERT_RTNL();
+
+	switch (flow->command) {
+	case FLOW_CLS_REPLACE:
+		return 0;
+	case FLOW_CLS_DESTROY:
+		return 0;
+	case FLOW_CLS_STATS:
+		return 0;
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
+int nfp_fl_ct_handle_nft_flow(enum tc_setup_type type, void *type_data, void *cb_priv)
+{
+	struct flow_cls_offload *flow = type_data;
+	struct nfp_fl_ct_zone_entry *zt = cb_priv;
+	int err = -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		rtnl_lock();
+		err = nfp_fl_ct_offload_nft_flow(zt, flow);
+		rtnl_unlock();
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	return err;
+}
+
 int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent)
 {
 	struct nfp_fl_ct_flow_entry *ct_entry;
@@ -506,6 +550,23 @@ int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent)
 				       nfp_ct_map_params);
 		nfp_fl_ct_clean_flow_entry(ct_entry);
 		kfree(ct_map_ent);
+
+		/* If this is the last pre_ct_rule it means that it is
+		 * very likely that the nft table will be cleaned up next,
+		 * as this happens on the removal of the last act_ct flow.
+		 * However we cannot deregister the callback on the removal
+		 * of the last nft flow as this runs into a deadlock situation.
+		 * So deregister the callback on removal of the last pre_ct flow
+		 * and remove any remaining nft flow entries. We also cannot
+		 * save this state and delete the callback later since the
+		 * nft table would already have been freed at that time.
+		 */
+		if (!zt->pre_ct_count) {
+			nf_flow_table_offload_del_cb(zt->nft,
+						     nfp_fl_ct_handle_nft_flow,
+						     zt);
+			zt->nft = NULL;
+		}
 		break;
 	case CT_TYPE_POST_CT:
 		zt->post_ct_count--;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index dbb18fbbae69..b6e750dad929 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -4,6 +4,7 @@
 #ifndef __NFP_FLOWER_CONNTRACK_H__
 #define __NFP_FLOWER_CONNTRACK_H__ 1
 
+#include <net/netfilter/nf_flow_table.h>
 #include "main.h"
 
 #define NFP_FL_CT_NO_TUN	0xff
@@ -158,4 +159,14 @@ void nfp_fl_ct_clean_flow_entry(struct nfp_fl_ct_flow_entry *entry);
  * @ct_map_ent:	ct map entry for the flow that needs deleting
  */
 int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent);
+
+/**
+ * nfp_fl_ct_handle_nft_flow() - Handle flower flow callbacks for nft table
+ * @type:	Type provided by callback
+ * @type_data:	Callback data
+ * @cb_priv:	Pointer to data provided when registering the callback, in this
+ *		case it's the zone table.
+ */
+int nfp_fl_ct_handle_nft_flow(enum tc_setup_type type, void *type_data,
+			      void *cb_priv);
 #endif
-- 
2.20.1

