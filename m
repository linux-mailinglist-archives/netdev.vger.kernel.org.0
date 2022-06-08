Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3A2542C31
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 11:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiFHJ5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 05:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbiFHJ5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 05:57:37 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2096.outbound.protection.outlook.com [40.107.223.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B297E60D8
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 02:30:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0u8HydMPXD/WubQbtImNg36sNfVpzyqxW8EiVinRnJPTNPtFGcRqVnNvJlFqeqv97kVbDyzQdW0QRVttvfRTywpL6RbBxPb+ZwRiJAly4e9sLPdioRtun1XyXPMHitVeeaAHOT8V1Bkj1qFq6KwLTCuscJo2HBouHdYF4wm5UPFjJdsn5WUptcWZvjawZtcumI45mBmXY4J6oaVe/ykEWtqbOdWbjhanyW+cMKtjkk3YSnTYzGOUGJ/aRiijAWyHp4GA77L25fnNfGv8hEGOqJzJLFHFP6B2Mza8AqetnZfpiMh0FVK2exeCjhiWYdCi48+/cwdBik9Qy49x7CBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAd1PCTZkb3tZQnsyPrquW9c0hI6ICKXchX1cwyNVvU=;
 b=SJ6pwaV3qK0BS000X7hiM+f9ER1z4QQM4ANzNOBB6Qy60X+yh9aXEncQaTlD65xQjf5PcXxoNwbg4TZgU9Eq1+MoV46Vn7b8X+vczYtS25DuYDC2DKdmJW1rSZzN+pJWtTm5SVZ9vc3RfpYk6kAjSO30DmZegAtcGH+qMLQQuDSe59i4Z6nan7ihmsq6dPXIjeOZmqjH7+5/PByOxpqjqV1Z9HK5YTD/41Gytv16kG40+uzCj05dQbgad+Np1Mt11xnH9RyLSlov64w3E7wI24998qs58p7KqQ2s7LrtgnhMxTPChmF6OnmdnYJ63xH5NXFgIU784AulvFjLfGPlzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAd1PCTZkb3tZQnsyPrquW9c0hI6ICKXchX1cwyNVvU=;
 b=HgEeC0OjCzpZjWeNYYPmRQV0z80tUNpFcwyTcm6iXxQIAEHxw3Wvt7OjW+1s8JjAyloTiStM+dIYyE79aMOjfqtpDLci5hq0m8hytgXJ+QJC95pPlXNb2+qQA/GnT0JCAWeqJANJe9m8qyA8ffnpLbx51HPV4oQ+AWxWvW29Bug=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5575.namprd13.prod.outlook.com (2603:10b6:510:139::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.4; Wed, 8 Jun
 2022 09:29:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5332.011; Wed, 8 Jun 2022
 09:29:57 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>,
        Etienne van der Linde <etienne.vanderlinde@corigine.com>
Subject: [PATCH net 1/2] nfp: avoid unnecessary check warnings in nfp_app_get_vf_config
Date:   Wed,  8 Jun 2022 11:29:00 +0200
Message-Id: <20220608092901.124780-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608092901.124780-1-simon.horman@corigine.com>
References: <20220608092901.124780-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0071.eurprd07.prod.outlook.com
 (2603:10a6:207:4::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfd7e16d-507d-4b84-b764-08da493173b9
X-MS-TrafficTypeDiagnostic: PH7PR13MB5575:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB5575C1A6B11ED2C09E91B1A4E8A49@PH7PR13MB5575.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WBOKNJKI3rETN8yHQeMM8/qm6DoLGISChUZlyNPCXTlfhS0wnIGl/6twEYGve1pfZBbgr+4C6Dtwkvpkxgqdykpfi4CHZK/P5UvNqF0zCHBo4PlMyDaFB6m9WELtl2WmWcPN6OevYads6qxiEbtfqzCxMTEzcBPQ1hQMG0p1XQRVI6Z7StZWsDkCgATxEV0KDB1nDPhsURGCdDQ7c396VOwJmFTIMh9DYDHXxykjssAkSLe/txIwx4XJ8CwBzEWfbYQt8+eT4t3JaAr2jvyO7uvXfERLtAmwVzlWdXaYK/ct9TqhqPux6ynD1QxPtyP930kkB42rG1466ioTf4MQlrzSuwzpk9EsmK9hqD6YPcCl1d8OMcfXQGbFisRIbVv+Op7OLgswpW6umm+JuR2RbXhBkXNYbBROOSEX1wg4NbfhtM+Y2oMcFyxM4CYPDobZtKhONl2ti2tCiLjlhKubvT7hGnUJVdjhf3PLVgSjMoYebxL1r28DkABw5MQdMijPYE2ih733OewFxZ22Rpoa43qMG3RnIaVSw33eNOwuQVpDuz8FyOG8lIxzF36++1ewd1Mn7GDGv5l5rp1QYNLDr8agnVgbZC/k6r0AzDjZC0Al1O/8WVq0F9sAug6spEQ8BTmHpX+s0tyJsywvzZa4QtLDZkpHienBSzSbSY3o82bFvV1WzoOWBPM+xe/NPQ2IbpItEizDPZunjul17Adzlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(396003)(136003)(366004)(39840400004)(41300700001)(1076003)(186003)(508600001)(8936002)(2906002)(54906003)(83380400001)(36756003)(6486002)(38100700002)(44832011)(86362001)(2616005)(316002)(110136005)(107886003)(5660300002)(6666004)(6506007)(4326008)(52116002)(8676002)(66556008)(66476007)(66946007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jNfgQjhwEIyvz7/7YjIsjJX2lwmO6/ge22BydC8Y5p63k7ey/fG+yj/NqqPu?=
 =?us-ascii?Q?lJ/wQP667zN0ARt05m7usMQIO8uACCKHN17Lw97hLyhA8kHwPD/DkzMhCI4J?=
 =?us-ascii?Q?quS4e+H4rsrnk0tMSQfgr1qVZbACG5mFbCdrI3VCEjwzRQH/k+OIaXPWhjbF?=
 =?us-ascii?Q?3T8uzojs4LeP+BikpzeSNPGpCbF3CFHWvp8jkTlVtxjtWB6GYq1cmI7tDDl0?=
 =?us-ascii?Q?77hPLW3n1l6JKXSQEOyjK0T2Z7tfIP4dNCdgdQumBJPWW1PaWIuWUsU9NVW2?=
 =?us-ascii?Q?c9jkAGxT9tPN0PBO2JPzyhAVdFif1K+lXn3skiOTpt/S6KmEJzoYUWShCzWc?=
 =?us-ascii?Q?+HwVqOxnqJeJB7RIhABbbhhDU/N7HAAycEjDmINtRf1MzRcLtekBHYE89lgr?=
 =?us-ascii?Q?h3rgsl8hfLWfNszhuKXvCniRUiSQRT6OoM0zrBlV3z5hJTTZUmrXGHkLwWX0?=
 =?us-ascii?Q?V583XsFLuyUrTQ2AzcbIClI/86A6h3OdrSisfsQdJh3TlcM2T4ODSQ8R78QR?=
 =?us-ascii?Q?XCQHJeRcZGCoxtz4b7WX4vA7/iM1dsOXN3sho2jTeU2CNHrD4DW4rxBBwk5n?=
 =?us-ascii?Q?U2eVjbpTNz8x+OlHX325/FAScyy8sj9oGBQ3v/52BiGktFCKLbs8pmwhTIXz?=
 =?us-ascii?Q?peI5h0pCBTx4wtZJgLYB2HTK1rpab6sr/hcPGY81zpbjnU9MixBUsGH0siH7?=
 =?us-ascii?Q?I1FBtIIT/cpITmz/90Rnss9c5eUoD64pGpLg4ylMkK1poaPOaqTQz7uKUl3S?=
 =?us-ascii?Q?GL7KJ777BuTnP1E8SG+TwujfcyTfei0ciAvfeC/JkPIdPfYE6WlRnJ7CR0ZY?=
 =?us-ascii?Q?Besic334TPqzD1bZ9ct/yFMWNTESUCH6l27bhMn9SuuI1PWZdCyp/k436ZTE?=
 =?us-ascii?Q?k9Eq+3bDxbVrmfK3qZtXP3xi8udx1WD1Xf5ghAmWubHeEvQ87o22cTNLBw4A?=
 =?us-ascii?Q?tJqF3cwpbAgMASo14x2j4pCbXAcSBBhpoE0CSkZ6/5JwIlFVxBi35JQBC8Fs?=
 =?us-ascii?Q?emR6OZTxdg0/i+KOsSR0r79HtFtGBi1pzh1k3ojR9c79jiWiW8b06mHfnfP7?=
 =?us-ascii?Q?S+WKEbIP3u11L5SRBQVNsdUw0cd1tXJIFCRn04volMwZb6IbihjXo1Qr66T6?=
 =?us-ascii?Q?k4pXDsv/k1DiJ5Z/Ce6WYFqXqJVKEyeXOwfvE74prlQEDgoamUt4wf34jRZC?=
 =?us-ascii?Q?QmClfJFq/eXNtMm2aBtmb/uZ6jBet0VlXeRySPawu2NXU2yiCSnP66Ims05U?=
 =?us-ascii?Q?GUUN26Bm3D+lZph35Eawp8zLIyo+PmLob41GRLG/2WXuV9375MajItFJX5pU?=
 =?us-ascii?Q?X8DfQ4pRa49+4+b8B7KaApiHdFNMWK3a0jhA3X6W5RPmd7bUqkaLLtSnVmH9?=
 =?us-ascii?Q?0VttoIcaI61L3Ra/A6o9ES5fiXM0GFia2yJUVCqMJwuXOeWromZL94VBJBwb?=
 =?us-ascii?Q?jViNN7OEo3iLDBFpFR8BI3EOvTv1tgCm0fnHtKzdXgcwXut0IxAZ7uGFcWtu?=
 =?us-ascii?Q?pLxLmvqDtlAlpTvUuB4/cf7tYitP+LROJUbuu150m8J/z14fG5Do1q0ojYA7?=
 =?us-ascii?Q?1ceZLTbIEH1JgodusAsC9Gk/72txhi7JoNvJPHL3vSUOK/agVohGeMpaDgbi?=
 =?us-ascii?Q?bSxGyyMbj9Q0+VlAp62Xc7FwdFi6lzXIvenBT0F2xgc+l8gg7LgHdbSiniLs?=
 =?us-ascii?Q?K9QwYyf0dWXivgS8ovY74T+4/1y7Ss3z3AeVpgMalRL4fN9BHIlgnWF9YlUS?=
 =?us-ascii?Q?i1VYC3Z9txpB9PhkKSyrF0bRSsGtrBDMMpc5/mgpMjYBrD7W0gGJ6RI+mfnS?=
X-MS-Exchange-AntiSpam-MessageData-1: iGusMirZYl3CLxJu4WFHMyCGsauxAD9Nr7M=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd7e16d-507d-4b84-b764-08da493173b9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 09:29:57.1216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vJBjyYsujtlO42wpobYSbdPUxfmY/eyeH3pc2yadCkAiyraERkF6E7gZCrBRjweiduZf5gHA/DwxifylPFiUe2vz8lzjuQOcxB8b+NAM39c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5575
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

nfp_net_sriov_check is added in nfp_app_get_vf_config which intends
to ensure ivi->vlan_proto and ivi->max_tx_rate/min_tx_rate can be
read from VF config table only when firmware supports corresponding
capability.

However, "nfp_app_get_vf_config" can be called by commands like
"ip a", "ip link set $DEV up" and "ip link set $DEV vf $NUM vlan
$param" (with VF). When using commands above, many warnings
"ndo_set_vf_<cap_x> not supported" would appear if firmware doesn't
support VF rate limit and 802.1ad VLAN assingment. If more VFs are
created, things could get worse.

Thus, this patch add an extra bool parameter for nfp_net_sriov_check
to enable/disable the cap check warning report. Unnecessary warnings
in nfp_app_get_vf_config can be avoided. Valid warnings in kinds of
vf setting function can be reserved.

Fixes: e0d0e1fdf1ed ("nfp: VF rate limit support")
Fixes: 59359597b010 ("nfp: support 802.1ad VLAN assingment to VF")
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
index 54af30961351..6eeeb0fda91f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
@@ -15,7 +15,7 @@
 #include "nfp_net_sriov.h"
 
 static int
-nfp_net_sriov_check(struct nfp_app *app, int vf, u16 cap, const char *msg)
+nfp_net_sriov_check(struct nfp_app *app, int vf, u16 cap, const char *msg, bool warn)
 {
 	u16 cap_vf;
 
@@ -24,12 +24,14 @@ nfp_net_sriov_check(struct nfp_app *app, int vf, u16 cap, const char *msg)
 
 	cap_vf = readw(app->pf->vfcfg_tbl2 + NFP_NET_VF_CFG_MB_CAP);
 	if ((cap_vf & cap) != cap) {
-		nfp_warn(app->pf->cpp, "ndo_set_vf_%s not supported\n", msg);
+		if (warn)
+			nfp_warn(app->pf->cpp, "ndo_set_vf_%s not supported\n", msg);
 		return -EOPNOTSUPP;
 	}
 
 	if (vf < 0 || vf >= app->pf->num_vfs) {
-		nfp_warn(app->pf->cpp, "invalid VF id %d\n", vf);
+		if (warn)
+			nfp_warn(app->pf->cpp, "invalid VF id %d\n", vf);
 		return -EINVAL;
 	}
 
@@ -65,7 +67,7 @@ int nfp_app_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 	unsigned int vf_offset;
 	int err;
 
-	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_MAC, "mac");
+	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_MAC, "mac", true);
 	if (err)
 		return err;
 
@@ -101,7 +103,7 @@ int nfp_app_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 	u32 vlan_tag;
 	int err;
 
-	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_VLAN, "vlan");
+	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_VLAN, "vlan", true);
 	if (err)
 		return err;
 
@@ -115,7 +117,7 @@ int nfp_app_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 	}
 
 	/* Check if fw supports or not */
-	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO, "vlan_proto");
+	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO, "vlan_proto", true);
 	if (err)
 		is_proto_sup = false;
 
@@ -149,7 +151,7 @@ int nfp_app_set_vf_rate(struct net_device *netdev, int vf,
 	u32 vf_offset, ratevalue;
 	int err;
 
-	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_RATE, "rate");
+	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_RATE, "rate", true);
 	if (err)
 		return err;
 
@@ -181,7 +183,7 @@ int nfp_app_set_vf_spoofchk(struct net_device *netdev, int vf, bool enable)
 	int err;
 
 	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_SPOOF,
-				  "spoofchk");
+				  "spoofchk", true);
 	if (err)
 		return err;
 
@@ -205,7 +207,7 @@ int nfp_app_set_vf_trust(struct net_device *netdev, int vf, bool enable)
 	int err;
 
 	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_TRUST,
-				  "trust");
+				  "trust", true);
 	if (err)
 		return err;
 
@@ -230,7 +232,7 @@ int nfp_app_set_vf_link_state(struct net_device *netdev, int vf,
 	int err;
 
 	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_LINK_STATE,
-				  "link_state");
+				  "link_state", true);
 	if (err)
 		return err;
 
@@ -265,7 +267,7 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 	u8 flags;
 	int err;
 
-	err = nfp_net_sriov_check(app, vf, 0, "");
+	err = nfp_net_sriov_check(app, vf, 0, "", true);
 	if (err)
 		return err;
 
@@ -285,13 +287,13 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 
 	ivi->vlan = FIELD_GET(NFP_NET_VF_CFG_VLAN_VID, vlan_tag);
 	ivi->qos = FIELD_GET(NFP_NET_VF_CFG_VLAN_QOS, vlan_tag);
-	if (!nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO, "vlan_proto"))
+	if (!nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO, "vlan_proto", false))
 		ivi->vlan_proto = htons(FIELD_GET(NFP_NET_VF_CFG_VLAN_PROT, vlan_tag));
 	ivi->spoofchk = FIELD_GET(NFP_NET_VF_CFG_CTRL_SPOOF, flags);
 	ivi->trusted = FIELD_GET(NFP_NET_VF_CFG_CTRL_TRUST, flags);
 	ivi->linkstate = FIELD_GET(NFP_NET_VF_CFG_CTRL_LINK_STATE, flags);
 
-	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_RATE, "rate");
+	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_RATE, "rate", false);
 	if (!err) {
 		rate = readl(app->pf->vfcfg_tbl2 + vf_offset +
 			     NFP_NET_VF_CFG_RATE);
-- 
2.30.2

