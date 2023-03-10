Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9F26B3E48
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjCJLqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCJLqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:46:09 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DCA111B0B
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 03:45:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGbmu3JDk6sxMim7YVIzyO0VD2E3Uy1Hh0LkONGjBCgfm/vPyT2MKs91AbJToR7KmJUT7dehj9DTtNyGBuML6t8fAUq5EVLT0cYQTEMT2nKkmQDfRymfId5wP4FpokZ8B8vr6NSkSqD1YBNTsix8xijFWJsY4o7ebGmaRWiBzVgwfbbN/M+ugG4pNnW+H835EqamhyDeMllxm+VUqPyR8YIqBp4n2uvRXX3vSi4ZR1Pk2mH/Gpoen0g0Y9mJ2gFmtYBzolcnDvRo7xXHcJgBmsAMcFCNsbdcctkFKUxGGc6oHtpkbgqtS8hpkA3QzntcrF8Jzwuw0HavyeV6xdy+Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k7cql/UElw8X8PTOZo5k44PZ+zil71zIXITY8RMfQqY=;
 b=A0bMo78nmDcOZLBQhE9/sDXgXbBcm2SVsIdWTu3lnWDtjl1Hl0rFjoiLYpoimyFMrtDRRVC6YhODOC4zQOqV1XwuhZ9cGsHmXhairDaYYUE5oZVnIjfgfeagDPCc3kLnv9hLkoPUW/UlVeGqc4qFUbtGwjpMuq42JjTeNesAeHWwlXV809a7Nm9jEQwXdPphiMGKCFVjlwanTKai/+2m9hc1SOmQbdctuQ3pmlH50nTuQNi5bWUvovSmWgGYh9BydTD+UgUedEMFXqX/FT4tWtcR9zzT8LpxhDnMbdUlZ1Z5UdxZctBixbT5vJI4+qSAtjW8u5rBoH5JD8/FHwvRng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7cql/UElw8X8PTOZo5k44PZ+zil71zIXITY8RMfQqY=;
 b=oQxMV7CReFBh3UouVcsrNi6fEdqJgDu4up9pNWEQg11HKsjljFhxTslBVp20AHBME+AlZyfVwErrx34KTa9XgdejEhhN1ozQqCfn3FANp5h3DAOL5jy6Tey7WhBx9COvfXjTzCr1qrY1446kOnMyCevFOVe2tQEsa/CCHL7a6KC7unrkXinyLWSUa5lATfGRprdA2NT6oDe0vExuFVemJk4G7wA/OjspvzrxP5PR8rWRBvOzgp88W+khMZF3Jky+dwiRPpvIAk+mxpCms6sx567L4m0E7DcZ/v10LxtD44NCCuAFm/vg773VTDFya5PVTD4JI5b7Ylcx/2u+rGoMnA==
Received: from MW4PR04CA0390.namprd04.prod.outlook.com (2603:10b6:303:81::35)
 by PH7PR12MB6859.namprd12.prod.outlook.com (2603:10b6:510:1b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Fri, 10 Mar
 2023 11:45:54 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::48) by MW4PR04CA0390.outlook.office365.com
 (2603:10b6:303:81::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Fri, 10 Mar 2023 11:45:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.20 via Frontend Transport; Fri, 10 Mar 2023 11:45:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 10 Mar 2023
 03:45:44 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 10 Mar 2023 03:45:39 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 5/5] selftests: rtnetlink: Add an address label test
Date:   Fri, 10 Mar 2023 12:44:58 +0100
Message-ID: <e36a10992012cb59c6529ecac174445fb13ad400.1678448186.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1678448186.git.petrm@nvidia.com>
References: <cover.1678448186.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT016:EE_|PH7PR12MB6859:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d75328d-5bbc-45d3-0862-08db215d0169
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBieVr+ZZpJmpJAybA1nGUF1ud9Eau/XbYLNlbqr8b0+H157YwEube2OTIQY02AOZSjJGlnkrdUk1581yxwDER5h1ct+O6XbmRyp+Hmg74eB+Wgd4f8cHlkCMVVYorco1g8bSriverjiOPu/OxOXYJt8RKdKnRPjcoryDM8V3+zrqgCub5aAUbxVagf0D+n4BaFGogjdLEU1WHr38Gum9yrk7TWt+93YXHALpYRLXhn7GeOtY2h+w4fqQvE5z3N//fDMKnD0b6yp6yOFkDoAZZ2yUyCuEZAuHpB6zVAICux8m9eI902qNLsMxb9gqIO5Rn0M44UlQaZ1COH3mvz1znbmv0YaDHJzaYiAsRddpVNq7RkkPs/FttzxgvB8jsaXa0+l9RHz1XHx0P5VrlsB1xb/WvBSnkEAQGQ/W4hxKRmAxWuM799dYU9wP4E2xltiOaQaTha2DwFFTbt4Hi3rbFHjMsJRHu57W0uoaG0Q4dKfkmksqPzoSfbtPNIKnXfAuI1tbwADwHwrZ0m5jQJMmN+MF6YeUbikQZVVmzdaO5MweYy1ps9AbR2MnXvrdalQdghbGbH6ymgJ5uyGckgJ+cYEKIBmYr7BelihzyEEeeG9kT1nEAoAlOTsayCOBG/pVg3cya+j/1DS1TbzQ3xk53tQag2Py5qA/8hmTNFjHxYfyaU0IRmtHfmZFIrSmOLgDNhV4c3u7WY7e+e1UtKV3YlZLdDuFiikqtlqEjl05exyfAxZJ8wpZx/22Y6h+DCr
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199018)(36840700001)(46966006)(40470700004)(40460700003)(16526019)(186003)(47076005)(2906002)(70206006)(7636003)(356005)(5660300002)(36860700001)(7696005)(478600001)(6666004)(4326008)(41300700001)(70586007)(26005)(8936002)(8676002)(426003)(107886003)(2616005)(110136005)(36756003)(336012)(40480700001)(82310400005)(54906003)(83380400001)(86362001)(82740400003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 11:45:54.0986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d75328d-5bbc-45d3-0862-08db215d0169
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6859
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add coverage of "ip address {add,replace} ... label" support.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/rtnetlink.sh | 82 ++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 12caf9602353..3f62b202746d 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -1249,6 +1249,88 @@ kci_test_bridge_parent_id()
 	echo "PASS: bridge_parent_id"
 }
 
+address_get_label()
+{
+	local addr=$1; shift
+
+	ip -j address show dev "$devdummy" |
+	    jq -e -r --arg addr "${addr%/*}" \
+	       '.[].addr_info[] | select(.local == $addr) | .label'
+}
+
+do_test_address_label()
+{
+	local what=$1; shift
+	local addr=$1; shift
+	local label
+	local ret=0
+	local msg
+	local err
+
+	# Test adding an address with a pre-set label.
+	msg=$(ip address add dev "$devdummy" "$addr" label foo 2>&1)
+	err=$?
+	if [[ "$err" -ne 0 && "${msg/be prefixed/}" != "${msg}" ]]; then
+		echo "SKIP: ip does not support arbitrary ip address labels."
+		return $ksft_skip
+	fi
+	check_err $err
+	label=$(address_get_label "$addr")
+	check_err $?
+	[[ "$label" == "foo" ]]
+	check_err $?
+
+	# When deleting an address, if label is given at all, it must match
+	# the label at the deleted address.
+	ip address del dev "$devdummy" "$addr" label bar 2>/dev/null
+	check_fail $?
+	ip address del dev "$devdummy" "$addr" label foo
+	check_err $?
+
+	# When no label is given, it defaults to the name of the netdevice.
+	ip address add dev "$devdummy" "$addr"
+	label=$(address_get_label "$addr")
+	check_err $?
+	[[ "$label" == "$devdummy" ]]
+	check_err $?
+
+	# Setting a label to empty string effectively deletes it -- it is
+	# not reported through netlink.
+	ip address replace dev "$devdummy" "$addr" label ''
+	label=$(address_get_label "$addr")
+	check_fail $?
+
+	# It is possible to set label explicitly.
+	ip address replace dev "$devdummy" "$addr" label foo
+	label=$(address_get_label "$addr")
+	check_err $?
+	[[ "$label" == "foo" ]]
+	check_err $?
+
+	# An address with a label can be deleted without giving a label.
+	ip address del dev "$devdummy" "$addr"
+	check_err $?
+
+	if [ $ret -ne 0 ]; then
+		echo "FAIL: address label $what"
+		return 1
+	fi
+	echo "PASS: address label $what"
+}
+
+kci_test_address_label()
+{
+	local ret=0
+
+	do_test_address_label IPv4 192.0.2.1/28
+	check_err $?
+
+	do_test_address_label IPv6 2001:db8:1::1/64
+	check_err $?
+
+	return $ret
+}
+
 kci_test_rtnl()
 {
 	local current_test
-- 
2.39.0

