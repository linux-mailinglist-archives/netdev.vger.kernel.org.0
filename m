Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BEC37C0AC
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhELOvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:40 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:51040
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231555AbhELOum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDjLMVDacsLjwMNV0nKIBPptXsIOHn+AFa8F0aGrQcKE4aOFyWyOTn+xIq8m2xqYT7L0lxLbStgAYQTwWMAeCDBukynlRiVNItmsews9jcCqRjPa+cd4fgizz6FBG7xJ/pyokubBL2znl2J+7D0oX3NTaLtEjx/Cs1moiPWc5ygaoNCbs7gM9CHdMusdrNmLwaBOXlJ88cCyWnWTC/oXQ8QfSWqKXgMut3v7Ps5+Y1HDe/YRP2YYCmywnhKL38zXnv/4uK/V8Rat+LZOyPGk4sZNswGoa9A+UosZZOzy9+4LoOHOMdXvdZVvMivTaKQhKR+YfajTqCSNufIAUf0+ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLD8T4pxHK7ogEKokyiWUTLies05D6B56tHXfxSNF8c=;
 b=f/XwpkGEqsFXJLt6NkHQkrPWDhrlkIX0p3rx+7ymPAa8nLqpl0QA4d8jYMrecEyODUnzsd7Hx044kifk/+s/2HK+Sz1yf0aBftUX4iQX+B20fPI4Vdbs59lA94kgpPPjyRn/HWvikrxJQSU+4trtskmMWDYa3CjOJkKF/5DmcPZi/BwAhwfgKhsbSegVvqcumk6qs+vrI7l1x/Bt9MLezVC0WR/M7H+S54nwu+8ZMnavBfFMc5nf52qrLYiJlsU9r6xkYliiy0VMrLpRqO/gy/JgtUMOUbZEnLOUqICQ3RMfBbao8vENNpvHlKR7PNuDH/wO1GjlVGO6bGPlAQgehA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLD8T4pxHK7ogEKokyiWUTLies05D6B56tHXfxSNF8c=;
 b=NW65V2Pry6J/qRJKfJ9Xs/APw34+T+F+mI5On1SU27rrg6Vs/hqYByzKV/Xtad0HB04zbNtJWcZWnyg2lbl1FnnRo6z1rf7ypToYwE1ANhgnihqpZ9URDJn9+hyOQVj3PLwU+P/0NA2TUzFU3j6YeNg7lfp/9BHAmE29gkuYnKGvrgUQpIAZADxLqK1LctsWuDHebSt4RY7wpmJhITXepHsxX10ppNARVspedqlm2wR/dJtmo0fvXSDNb4avlYMtiI9YjqphKKV3EX2i+pIPAG4fFa0Q7ZVjDdmm6OviGe2TEBc6fu6gS+UaOFV8VhjCeLJ0mDTYoty0OcOtURMcIQ==
Received: from DS7PR03CA0100.namprd03.prod.outlook.com (2603:10b6:5:3b7::15)
 by BY5PR12MB3859.namprd12.prod.outlook.com (2603:10b6:a03:1a8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Wed, 12 May
 2021 14:49:32 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::27) by DS7PR03CA0100.outlook.office365.com
 (2603:10b6:5:3b7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:32 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:32 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:29 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 14/18] selftest: netdevsim: Add devlink rate nodes test
Date:   Wed, 12 May 2021 17:48:43 +0300
Message-ID: <1620830927-11828-15-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27678ada-c31b-4ff1-ad98-08d915552750
X-MS-TrafficTypeDiagnostic: BY5PR12MB3859:
X-Microsoft-Antispam-PRVS: <BY5PR12MB38594AD7C4B389C0C5EDB19CCB529@BY5PR12MB3859.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s33p24kEMVz0RonIT8GhZpTC1Bkmb1E5GzWHrMOCVtk1YDvVAHxb9Xgw/WiHe2AJKsX/aVL7ypgpgDD1bL+JAU9Hejr0MeNQlwVb3td2bYUdel1N+HybHbbCUbd9NcyN/I0r+iqEn+6MZsDOE8qfoxX6BUMZc8kbnuq1R+XeqjUeQH7/VKkWPKbKRg4wqKSijdN+C2io02lmP1SqfUIJ70CpCn4QhBTCRfdPt4axP4NdyvV2EADLpRU1gdpxPF3YbXAT+djandikj4k7gsyutbMOqmjHlMAHNasjjODRHHb6SoYeRDoM/bKK9MXor+tOtqhyGVjMem+jWaWWQ1wcMQOPXEbyaH6BdRa4iqMm+YIUr6M/Zw2uHBIyEwbuFgo4FQ/oRIG+cc3+A9BgIqg0P2V3W7Xmk/xuUEochZshG9YyxxUVdq4B7TzrylM0RDUEDw48jxmfJ7oRpyu8SuoLmuBAkcyqJmYfyYWTBLBqkzpv8r1U4TRk2A6GF2fRtuWsF7DWjYxiCHj+BiWxG+Kc4OKvZRnWd3UdCotxGZipYiL4wF9hH+z4pZdLCneVrzqAqpv82jGdaAdTA49zYFJTZ1UR4AjY3VOHUjAYZ3egsUVppGZBiu9Q7sKXSr07fruQ2gRTC1wkNmNHwULjs6XAFA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(36840700001)(46966006)(7696005)(70586007)(2876002)(8676002)(8936002)(47076005)(5660300002)(36860700001)(478600001)(2906002)(54906003)(82740400003)(4326008)(6666004)(36756003)(107886003)(6916009)(2616005)(356005)(7636003)(82310400003)(336012)(70206006)(426003)(186003)(86362001)(83380400001)(36906005)(26005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:32.4548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27678ada-c31b-4ff1-ad98-08d915552750
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3859
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Test verifies that it is possible to create, delete and set min/max tx
rate of devlink rate node on netdevsim VF.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---

Notes:
    v1->v2:
    - s/func/function/ in devlink commands

 .../selftests/drivers/net/netdevsim/devlink.sh     | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 05dcefc..301d920 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -516,6 +516,14 @@ rate_leafs_get()
 	       '.[] | to_entries | .[] | select(.value.type == "leaf") | .key | select(contains("'$handle'"))'
 }
 
+rate_nodes_get()
+{
+	local handle=$1
+
+	cmd_jq "devlink port function rate show -j" \
+		'.[] | to_entries | .[] | select(.value.type == "node") | .key | select(contains("'$handle'"))'
+}
+
 rate_attr_set()
 {
 	local handle=$1
@@ -555,6 +563,20 @@ rate_attr_tx_rate_check()
 	check_err $? "Unexpected $name attr value $api_value != $rate"
 }
 
+rate_node_add()
+{
+	local handle=$1
+
+	devlink port function rate add $handle
+}
+
+rate_node_del()
+{
+	local handle=$1
+
+	devlink port function rate del $handle
+}
+
 rate_test()
 {
 	RET=0
@@ -582,6 +604,29 @@ rate_test()
 		rate=$(($rate+100))
 	done
 
+	local node1_name='group1'
+	local node1="$DL_HANDLE/$node1_name"
+	rate_node_add "$node1"
+	check_err $? "Failed to add node $node1"
+
+	local num_nodes=`rate_nodes_get $DL_HANDLE | wc -w`
+	[ $num_nodes == 1 ]
+	check_err $? "Expected 1 rate node in output but got $num_nodes"
+
+	local node_tx_share=10
+	rate_attr_tx_rate_check $node1 tx_share $node_tx_share \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/tx_share
+
+	local node_tx_max=100
+	rate_attr_tx_rate_check $node1 tx_max $node_tx_max \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/tx_max
+
+	rate_node_del "$node1"
+	check_err $? "Failed to delete node $node1"
+	local num_nodes=`rate_nodes_get $DL_HANDLE | wc -w`
+	[ $num_nodes == 0 ]
+	check_err $? "Expected 0 rate node but got $num_nodes"
+
 	log_test "rate test"
 }
 
-- 
1.8.3.1

