Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AA04B3EFC
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 02:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiBNBp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 20:45:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235609AbiBNBpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 20:45:25 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2081.outbound.protection.outlook.com [40.107.102.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01117527FA
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 17:45:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMTyiDOOY5DpLOXVUl8w53rc/bm4qpUiE148VLCmRtx7l42u6zK9tJrPgtKf55OoXv9kHLUz2KrZdwGtRwrOvz4ZCuCGuOtNX3ClhaiKUCJgIQRtB/ffoNZXE7A7XxReXw33C4hEiCJJR1zZaRGYcFueFWmoLcik9KnhIPybKI7nDo8q6+/59nCLlqA1WN1gfeW/uTZmEr2cHsq8eiPmvOcVP9ZZSJJcXuM4x/g8ICIxiXAsA+IClSwaF1tt5PLo8PgqjyUcxPiB04NysGlAF1+Dq6xPmT9VsV6GBMdRhkSH9QhjDxnDTau2OcINZWHEbcHv1NWtUeyOc2IbkWEm2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7LKmq8EsFPeieScaQGU0dUR5/r6ejYhuIShpUbsuTs=;
 b=nPUCrar41tRft5+GlutdEneM9kng75a451zD/mQLdymJ8v3vlOya8Zgv7JOK7Gsow0jkClQYacM8Fku4D017k1zFTy9QemIIdTySysIoRavwMmv9Z8cTbojlPgzR7TJPfBcATvwnCEUnlwEYLRV/mRIRVuQSeD4J0ykyJTyzIt2yNpeVUV85SF4fznKmLBob09HnyPpLz8zGwTay6xDig6H9XXXNa2LWIcwvVaniq/axCImZdEQieRWoXVkobRMxlc65BmXfrEziM9hcle8QxhBBkziHOjppy23Bu1XpHB7SvTH99efbZLoWzWGMDM+xi3Rv/GNoMQhOYOW08Kgt+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7LKmq8EsFPeieScaQGU0dUR5/r6ejYhuIShpUbsuTs=;
 b=LtlAkppEuuwW5HWfZEQMMnwJy1mTvdo57GDjhkLwqrPDk0tLC3NbDXv5QmxbBRFDTh7h92EzwWTFlFZvWxZaskbBwOAdDXHwjU28FzrelRmEVu1KLkczdCCL5nvyJ0nhHFjgzqqysgg1kXJaaS/gZgiE2DZGDLbD6XWtnvSryrAswIcPVEsNv3nha9Fyy2ES1mj5QbH8eF6X7bm3iccCk4kz+UKva7SRfVn6u4b+wpJODZBC5xUFDMH2OfV4aRbQVvObwJ0o27TYtvglFNRP8Ju/WCKBIoq/qdr4FbzJO3SKWNMNM1E0IwIxIVS/PNNv9quBKp6SmxeUPF22iFchZA==
Received: from MWHPR07CA0014.namprd07.prod.outlook.com (2603:10b6:300:116::24)
 by CH2PR12MB5545.namprd12.prod.outlook.com (2603:10b6:610:67::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 01:45:17 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::df) by MWHPR07CA0014.outlook.office365.com
 (2603:10b6:300:116::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Mon, 14 Feb 2022 01:45:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 01:45:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 01:45:16 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 13 Feb 2022
 17:45:15 -0800
Received: from d3.nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 13 Feb
 2022 17:45:15 -0800
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH iproute2 2/2] bridge: Remove vlan listing from `bridge link`
Date:   Mon, 14 Feb 2022 10:44:46 +0900
Message-ID: <20220214014446.22097-3-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214014446.22097-1-bpoirier@nvidia.com>
References: <20220214014446.22097-1-bpoirier@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ac43831-6c48-4a2f-ce50-08d9ef5ba6e6
X-MS-TrafficTypeDiagnostic: CH2PR12MB5545:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB554546858650E86D2F24E0F9B0339@CH2PR12MB5545.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vOvJCa2qmIY94VvjyrGDwVhtaxIITNlplFbzUwTy4huLFClOBrfM0t/2J1FacPZhWxp8gUU/Ai6lV4FAvqAtsk6V59zVHVcKbh2PqOMTfc8wAMOeClFXv55H8KC1KTT8djRdl/pZo4DRu6aG0cCsf4M9F2cCDwrQXpSAWwbDWxh4VaZt/lIGXupW4UST2gkjLR4kxBj7fiMr7CkgbHsDochudKsgi93JPanPS87RyrSO+iBhoDvKJ7Aw4GVJ5hYmWzHP0GUEYpyBUS4Lb5oky0Mkt9JWbm1crCWdFClL6hU6iwORgd8jw7jAWWwC+tifXExieS7RcqvLmQYPzGP2kDIhCHCaJrNY5kRalbgl9dpVDzpf4icoeE9+nGoml2Nafv3tGD1bG4BwTPGtl2QM1HMuq0l3f5+lvw5qzyAaguGq4cjrFmrRiTw2i0cC2MDf4XJSdkexTwEejXlq06HA9RpWlEhyzMJk/cNvIqCz62JBHvw2aB9jBBZjnnWNUNxR6beUenalHhN+/oQCfEtRl+ciwychEK3xZ7PCHggu2+5uoaK7yNmWgV7tKzp4YwE704Paok4vjfr7HpC4M6xA5IxTZ7K5Sbh+plwihc9sOSOvyGXz+xUwk6TvBs7pjzFgh7qm49PQ/0fMcydK2iv9ZngXR8Vday8Z1xxSSw2QcwDeR3k3YUiN8uva9f35hPHNGlW462+/rRjOZYXXsggsacDXog50A2tJJJHqo07qlqA=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(2906002)(4326008)(82310400004)(47076005)(40460700003)(86362001)(6916009)(316002)(36860700001)(8676002)(81166007)(70586007)(70206006)(356005)(83380400001)(8936002)(5660300002)(336012)(2616005)(426003)(186003)(36756003)(26005)(7696005)(508600001)(1076003)(6666004)(81973001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 01:45:16.9592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac43831-6c48-4a2f-ce50-08d9ef5ba6e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5545
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vlan listing from `bridge link -d` was broken by commit f32e4977dcb0 ("bridge:
add json support for link command"). print_vlan_info() expects to be passed a
IFLA_AF_SPEC attribute (as is done in print_vlan()) but that commit changed
the call in link.c to pass a IFLA_BRIDGE_VLAN_INFO attribute instead. As a
result, a struct bridge_vlan_info is mistakenly parsed as a struct rtattr and
print_vlan_info() usually exits early in this callpath.

The output style of print_vlan_info() (one line per vlan) is different from
the output style of `bridge link` (multiple attributes per line). The json
output is also unsuitable for `bridge link`. Since vlan listing is available
from `bridge vlan`, remove it from `bridge link` instead of trying to change
print_vlan_info().

Note that previously, bridge master devices would be included in the output
when specifying '-d' (and only in that case) but they are no longer
included because there is no detailed information to show for master
devices if we are not printing a vlan listing:
$ bridge link
4: vxlan0: <BROADCAST,MULTICAST> mtu 1500 master br0 state disabled priority 32 cost 100
$ bridge -d link
3: br0: <BROADCAST,MULTICAST> mtu 1500 master br0
4: vxlan0: <BROADCAST,MULTICAST> mtu 1500 master br0 state disabled priority 32 cost 100
    hairpin off guard off root_block off fastleave off learning on flood on mcast_flood on mcast_to_unicast off neigh_suppress off vlan_tunnel on isolated off
$ ./bridge/bridge -d link
4: vxlan0: <BROADCAST,MULTICAST> mtu 1500 master br0 state disabled priority 32 cost 100
    hairpin off guard off root_block off fastleave off learning on flood on mcast_flood on mcast_to_unicast off neigh_suppress off vlan_tunnel on isolated off

Fixes: f32e4977dcb0 ("bridge: add json support for link command")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 bridge/link.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/bridge/link.c b/bridge/link.c
index b6292984..bc7837a9 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -192,12 +192,6 @@ static void print_af_spec(struct rtattr *attr, int ifindex)
 
 	if (aftb[IFLA_BRIDGE_MODE])
 		print_hwmode(rta_getattr_u16(aftb[IFLA_BRIDGE_MODE]));
-
-	if (!show_details)
-		return;
-
-	if (aftb[IFLA_BRIDGE_VLAN_INFO])
-		print_vlan_info(aftb[IFLA_BRIDGE_VLAN_INFO], ifindex);
 }
 
 int print_linkinfo(struct nlmsghdr *n, void *arg)
@@ -538,19 +532,9 @@ static int brlink_show(int argc, char **argv)
 			return nodev(filter_dev);
 	}
 
-	if (show_details) {
-		if (rtnl_linkdump_req_filter(&rth, PF_BRIDGE,
-					     (compress_vlans ?
-					      RTEXT_FILTER_BRVLAN_COMPRESSED :
-					      RTEXT_FILTER_BRVLAN)) < 0) {
-			perror("Cannot send dump request");
-			exit(1);
-		}
-	} else {
-		if (rtnl_linkdump_req(&rth, PF_BRIDGE) < 0) {
-			perror("Cannot send dump request");
-			exit(1);
-		}
+	if (rtnl_linkdump_req(&rth, PF_BRIDGE) < 0) {
+		perror("Cannot send dump request");
+		exit(1);
 	}
 
 	new_json_obj(json);
-- 
2.34.1

