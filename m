Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252254B9C12
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 10:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbiBQJcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 04:32:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238187AbiBQJcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 04:32:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFC51A3B6
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 01:31:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SC70oPbtA9R3tlWoTSkgBhq1g0RLW5GmoNqbhO8sz0uMS7TjxuJJ76v5B5E12Or1fu3+sHgjXFpoZQoC2Z29vsp8sl6jIVFFUs0ccoHS5hgQAAJ0N5Ycj2pf6AA+IwG+4nGjnVxzxaAlXM8tfDvFfI+qcaz2xyCPZfhcJAUtET2B7H0EqG1q1Lyjap7LsdrjgxjTx9RM3CVjCrsmEnWsWHIlNNas1z2pdQloQmPqE4ekDrfx0Nipu+Y7p2NLFckJYIdsH7+Zp27PCkHxAm/sh2mPFUGx+x+YFFe6eL/tFjwLbQHfJ4adMBIQpEILnk36LL3cROte63/HNhdqDyYZGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xi0lxhuRdr7ECunYn+xb7m8OVXh9h1hp/Ni95ERtu9A=;
 b=dDSbv7+SX32YEX3cMlx/V3Dy4coEaxIiuAMVaB7QdmvhjpYtgWrErMhIRCmJkzU7qXwowjDeT3fz/9RpAT0chMI26tQ3aU53WdRU5akbkqgyijoHpESqbinUXYDt8qdajGgrKeQsZJwGq9DW01RwSKDvUH156KD6PGlCYMRNzQhockcRqypl5XAWd/xYttiIJu/CS4jitZ5owJTIKinq5c4WIqzYMCTeBQICg9Jqafzw9Zx6nPlVLb6EI1lPWbtstcoEvQyqBN+Nh3VPS88uv88reqtK4WZoIfGPZ7v4CQyqWVj759c4vui0bny2gxPRtSMbqK93jZ4uRGyMaRFyKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xi0lxhuRdr7ECunYn+xb7m8OVXh9h1hp/Ni95ERtu9A=;
 b=eAAnGoNeob6SPoZZsCTraDV0spgDLoTb+1hZFC2mt4vDyzX4F/4NWQIQh3pl3Qp3dyZfDPA1oReOu6Fr/YCYSbdP9Ga6/p8Kekiz9h/eIGhdxq4mqXS95xgqI/sqRrK9596kq9ILcwzAjwRI0HWsw4Gzl4Q7SfZtjyf97tHt3HVHx7smPFexSWC6dK1yyzgTboAP9U9vP/Jm62bim86Nv20yxAPKAqng6qXUFRijA66XQu4kmmw1Zl4wgnNqJnpHYIGUaWzgqheY86qCCL/FkTYXz54ragNtcORdFoh/qSGJ4DROm4ebE5H7/5NqyBFllFe4itFxbQ6UVAyoch7ypQ==
Received: from BN6PR20CA0070.namprd20.prod.outlook.com (2603:10b6:404:151::32)
 by CY4PR12MB1189.namprd12.prod.outlook.com (2603:10b6:903:38::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 09:31:57 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::44) by BN6PR20CA0070.outlook.office365.com
 (2603:10b6:404:151::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Thu, 17 Feb 2022 09:31:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 09:31:56 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 09:30:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 01:30:52 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Thu, 17 Feb 2022 01:30:50 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        <davem@davemloft.net>, Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup after ct clear or switching zones
Date:   Thu, 17 Feb 2022 11:30:48 +0200
Message-ID: <20220217093048.23392-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d149eb0f-a00e-4d46-ab06-08d9f1f85710
X-MS-TrafficTypeDiagnostic: CY4PR12MB1189:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB11899FC0B9819FAADA23441FC2369@CY4PR12MB1189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QxIVnw0Xot9B4xznIhpU0kn0xRnxn+myNNQ2FapifxnJc8c6JGD6va4c4063cuq3g8iu5C0naLcvl1ZGjZb2oupumMW2ZGvqn0Jk6l0e5X4TJZr3OeQvKqZhZIHBrMBl3orTkBRpBRQoB00t5Nrbyhiu6uRcSRWgW8n13CtdHSMuHSQQUPQ/D3CBQAqZ+gUAKyH4HIf4ebrxqT9yko7qFVyzJquUxa7V1WzIJq6tSU11G1qKu6Ip1O7+PUVxOjKN6wSsiQMSHCoGQotSv7ZNcfEnRBwGDi4eruVCDi2Ik/hspsiBDkCGue71ixh5y56y3b+M1nHjIJbMAc3IPyJUrVpH7N4ne9u7YNTUofPXmB9Og0bQV7rHX7iWhW8imQ4ZSb+2nF/+0k/0IL9GjpAIxgZUEyU9cj+BCKwcDrowdYWDr2CivZjyhuTyaaMP1yRSKFdIhHRZA2ii296uFSvxiCGk7mJPBmFK//UFlH4/iUm63nIP6HvgTzYBMR4va2XW3Oyou8+21tfeHXEbmqsWjZDdjwDWqz1zicbgIQDk8QWSu+GlJzQuF1Qt3NlvJ5M4eSqIRW3EbulDxdoywI1N3Ji7usyJjQrJW40n0/RiIMrKanjRTilQ7NdB4EcRZ8vPhROC/Ew0Yfrl+Hmacmwb7AYPr2iDbZ2SbiYbieEg3Buu1vikoo2esmrTjxitY8AnoWySsBqFVljF4AySTytzlQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(110136005)(8676002)(54906003)(316002)(4326008)(2906002)(47076005)(40460700003)(70206006)(36860700001)(81166007)(86362001)(508600001)(107886003)(70586007)(356005)(5660300002)(36756003)(83380400001)(1076003)(2616005)(8936002)(26005)(426003)(186003)(336012)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 09:31:56.2654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d149eb0f-a00e-4d46-ab06-08d9f1f85710
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1189
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flow table lookup is skipped if packet either went through ct clear
action (which set the IP_CT_UNTRACKED flag on the packet), or while
switching zones and there is already a connection associated with
the packet. This will result in no SW offload of the connection,
and the and connection not being removed from flow table with
TCP teardown (fin/rst packet).

To fix the above, remove these unneccary checks in flow
table lookup.

Fixes: 46475bb20f4b ("net/sched: act_ct: Software offload of established flows")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/sched/act_ct.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f99247fc6468..33e70d60f0bf 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -533,11 +533,6 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	struct nf_conn *ct;
 	u8 dir;
 
-	/* Previously seen or loopback */
-	ct = nf_ct_get(skb, &ctinfo);
-	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
-		return false;
-
 	switch (family) {
 	case NFPROTO_IPV4:
 		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple, &tcph))
-- 
2.30.1

