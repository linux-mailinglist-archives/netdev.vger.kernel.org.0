Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD4960C96C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbiJYKHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiJYKHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:07:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFC21F607
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:01:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNshmqWfE6uyk5OHfkVhkJrznzxXiACrA/ilzUjBzKSzIfHe4YcPW5jvBBok4KONVfFZHOG19REliZ4Cb6KFcVtSChZ6QnFmPe/xOIsUMUdwLi1hfLbR9R8G+xVjkh5GePawnnojQkbms1G7GtiPZ3BbUokl4O9bPgOjMPNTvlLdILG1hzAv/ELZx/SBdD8b4abj+ygZi0rhPRdoAlEGmhcBUOxe2sbkKDnKI2F3QGXnj56WUOnHfbdL7OnY6sF0pG1PUnoVxobq8PdxTOTm/WejuBBICzy931T//GASul4BXyQgsWChqB1zMTfw9PeetaX4GpGrhF/m3NKy20gTTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+cmf9tVcCDzH7H8A/E6EHHl6bXE3v/D4bCelR3/Sog=;
 b=WLoFRSDizHsz62tWYKFzH1ui0xGTdLGB9Jp2vsI2JE9tKLw5kZEsPHLuws7NXmC7r/p4mDI5EWvvJsxlWkeSpS6XL9+PgRWGmFa4zShOHbOQ8HJbZ4rS+LRhmXh94DUBydHF1Aix7pOtwiK6qWWzAY7DTGSHrXWXylMYUcvaGa6rRwfQwPx1zOG2GUd4hQkHWGd81J6hqUwOgk5FYnQgoAFkyK35arP+xI09ZeuR4YC205Q18rdueFZ2w+vuQR5Xh9VmnpkSLkQEU/UpVy+lTDx+o57CraAgPwjKETpj/1up/vbB4i8RP4mR9zEH49SxvVnKe5AivWz2YcVXKjPrWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+cmf9tVcCDzH7H8A/E6EHHl6bXE3v/D4bCelR3/Sog=;
 b=WBI/cNz0e6iwf0vat0NMCn2q1NBPLxcyh42hMosq6LM+LG0Ii/RAL15VAeO909sX1jcBYsxstws2yk24DRTL/JcjTrXD3IeWWHwPiLVgoEGdR5pShitV6W4SW3h7mS7lHSSA4fHWDfv8nAYdQlf/l/Hu4S16lPFTIREhKhUU6BQo8vtU1k38x8CfQ4h8D3tdkvxbQFnRnaDJ58KBad7RrbCTgx/efcVeY1loU8BlvcpGftFFA705U6briNDFFMLBIvSrG63kKMqK2EcTYZcyLxEgcsPZmNN0MMi/HEq/Y8a8gqslbagr2aKxUhT2wlR3e3Y0g7cSBxe3/cQj4tLxLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB4929.namprd12.prod.outlook.com (2603:10b6:208:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:01:02 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:01:02 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 02/16] selftests: forwarding: Add MAC Authentication Bypass (MAB) test cases
Date:   Tue, 25 Oct 2022 13:00:10 +0300
Message-Id: <20221025100024.1287157-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0105.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL0PR12MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: 402f1fad-3424-45cb-1910-08dab66fd2be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y1VZR0LdHMtKG8EN6sbvebdStfeBQAMEFiI8vkuqL4u6HZ91s0rb4J5sIwLOi+nrYhSpJj9q7WCpFKXjoLDfr7oFkRKO5LoipZMtSNeVbsa+vT19ieshhVQrRJXyZ/2dODJu4iT7G1cq/+fsQvd80QZUfrUlYAxZLGER5IrJxcTBZI25lwhkP12tUOZqrZDsDfpUm4iYgvyXIJ7DFiR7W9ljc5jKeNUms+/c7FGzVJ9XSf3/PvbuDAgy9YkbEGDzhovvQtn0ib1m2O33uYkWDZVmQXDEQFCiLsquoPOtWCyAzV9k9kIH9UV8aBdif7JscAheqZtuvI7VgbgfDEfl9IjvBtoJerLPEiHQYdcV6a6SN7UA1kzAysJ89nGVqUgndqfsV8POJQo8BFmJwzqXvtkg8iPHvXIhF8DBXFqkIcInk6QNUDnsP2+bSwd6ILvwAZcEV0SnvgueROZYEGP/EtO/2m0tXEEvzQBrFoDktp/bgFfKTzhX6KU+Kgvvl32btZg9Ys/hPGyKS5+sd5CGRiHSWQGuRvLwY7aaRiJbVtb6hsVRpLS3sfzCTiudulE0bpnR5yKZkxQyCxVHMagtP7NUencoXudf7dyx9s7s/7SaYoEWzzC8alQ9HrFMT5moDCLpAVLDYfMXdH8rLHMrnh0yAffUFzhYBTHBIAMUKYWnQ92VOUL7/hzNhlElOMe1pRsKCIflvKztezHxqw6eog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(86362001)(36756003)(38100700002)(2906002)(5660300002)(8936002)(7416002)(83380400001)(1076003)(107886003)(6666004)(26005)(6512007)(2616005)(186003)(6506007)(478600001)(8676002)(66476007)(41300700001)(66946007)(66556008)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZJuWPTZ9UT+K00xVupVT507wgcbOH+/7Acsvgjl+UCaeiOlhbY81MYQycFxv?=
 =?us-ascii?Q?ITUlYuK4VuscbNoUK3n6rltLPOzRiBBtDkRvpmoBH8g4V/46zJm0+jPiEvHR?=
 =?us-ascii?Q?XMZm+Ez1RXhTlnm7qJ676SrX0JygPryfeOgAa+DZtSXeDKhK2jTttWNMUX2O?=
 =?us-ascii?Q?6ncwtCawNlIRbO700NGrg9uF8qxbo3X35cqwU2wlupjk+Ebs4XbQ4U/SAsbl?=
 =?us-ascii?Q?ldYwSGuQ/onbFXDfx1e25L16Uov0uhhyDUfqiQ0ZnvccqxlKU9GYcoRRnm3U?=
 =?us-ascii?Q?r22W4gVacO3OVVRbJD3lW4bPB8DpB0EbwdeYcANqqkokAMM0xjF+A0M2OaP0?=
 =?us-ascii?Q?dIhnCMy7/99R4FB7axVaiH1WKrvuVNSi0pWX2DFbAICiWmapHwIatf986FgJ?=
 =?us-ascii?Q?U0akkU3zqtVoJJkV236W9dSbLHT/R2I4iRJo7quHOlUfp+RAw8q/5CADTa23?=
 =?us-ascii?Q?2dErZEFTIWS9bVSz5mFxmcwNOYKxEgS3xt+yO9NbCOxtWKeG6cNeyr0iBlG9?=
 =?us-ascii?Q?YBLLr7fz8aii0s7XeY2ZMvFpd+/bTKyRGL5tYJ1yLP71rzlaFDuLhVgknkWo?=
 =?us-ascii?Q?z8GsFbjK19GV83wNaVrCyuUGRB/ZbxdOuF3ihKwKBTgzMlDvhMTW/j99tcFs?=
 =?us-ascii?Q?7YWy5vnoW6FDhM0NUnFFLqboQxUofocRAIhkRk0GOebKOL5I4ZvECvOjfIt4?=
 =?us-ascii?Q?6TIESbAxC94yD1CDQ2O8q2wUw+Qsk0nnlDM+T/3RYQ4MSueJl3+YPAMGiY9H?=
 =?us-ascii?Q?gm7qmfsQCqkRjMwwkBwLiszbYLJNGR0wsfg3tyrO2/1bc6FR/dWskLBhLY9c?=
 =?us-ascii?Q?si/iCmP1x8YqKEsVMkrNPQn1tFeGGPS8taglsdxn9wliB9x78w+dArNkeCcK?=
 =?us-ascii?Q?6DY2Scsu/+d+LU9aEalnpmNyVTS03cHgxT+cSyYlFuf4vj02nGVHIrWgZ/+R?=
 =?us-ascii?Q?G+76bJbq8AGrwkD8MUOcmTGlRpVxegPDJSDlluhIE3x3+YVRzM/KbpS/fpI0?=
 =?us-ascii?Q?8DHLoO5BWOU+lYsHLzMl/6AQ5YC8koShVSL2cgpIh6o4xKDlQSM1FrmQnur3?=
 =?us-ascii?Q?thfbgwb1ffe3P6N0UC1aDTBEDZijZcsBRsk04d/Tw1WDYbRJu+NqA5h+hx+P?=
 =?us-ascii?Q?ZNbUJ6em72UwDg6OjzEdx5oxSwYCpFs9UYR2VCSTNGK1i90k/3hanaY470Nq?=
 =?us-ascii?Q?mPDeP5CZUiEtpnz2VUeqR2xL3ylJCAslDHb3fUyLUOpRCRcrUfVqcLWkCqa1?=
 =?us-ascii?Q?O4al97X1ygR4syy+GoISVVp5A3UIDmnvt1w9sUr4QN9PZDUX+8MPGzJZU82s?=
 =?us-ascii?Q?v3SoOFYdxMKi+uXPniULCLNdIAFFDTS812ROWAt87RoAMKADDWug2G8sB1jn?=
 =?us-ascii?Q?qRVarulb7OKss2yhv8VQ/UnlhwBMN3DJGS48HU64SewdYVhXDJBdf7wE1CMf?=
 =?us-ascii?Q?neCUav2aOpLlN/Qg5qK5hJki7FbtU8qL8HcuvW7X3LQWd+VZtSF5xcH8v1Cz?=
 =?us-ascii?Q?XneG+0mCtQ2po7iZ+cVmVSU9zYc28EyW0YU3XpvAk6QDbe5CbUTnlnXEMvov?=
 =?us-ascii?Q?1s02OijEX7r745wrUqcoBpTOYOn+rvVkENJFgEqb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402f1fad-3424-45cb-1910-08dab66fd2be
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:01:02.0426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MN+ovysEum8ty9xW2e6DdNP61a/oIcIOfjIwKt3NuFmkjoaEz/Op048XeJzq2vkZHNiqExrpLFnRuFwcBC45wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4929
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Hans J. Schultz" <netdev@kapio-technology.com>

Add three test cases to verify MAB functionality:

* Verify that a locked FDB entry can be generated by the bridge,
  preventing a host from communicating via the bridge. Test that user
  space can clear the "locked" flag by replacing the entry, thereby
  authenticating the host and allowing it to communicate via the bridge.

* Test that an entry cannot roam to a locked port, but that it can roam
  to an unlocked port.

* Test that MAB can only be enabled on a port that is both locked and
  has learning enabled.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    Changes made by me:
    
     * Reword commit message.
     * Remove blackhole tests as they are not relevant for this series.
     * Add configuration test case.
     * Add a few additional test cases.

 .../net/forwarding/bridge_locked_port.sh      | 101 +++++++++++++++++-
 tools/testing/selftests/net/forwarding/lib.sh |   8 ++
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
index 5b02b6b60ce7..0ad90007f96b 100755
--- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
@@ -1,7 +1,15 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan"
+ALL_TESTS="
+	locked_port_ipv4
+	locked_port_ipv6
+	locked_port_vlan
+	locked_port_mab
+	locked_port_mab_roam
+	locked_port_mab_config
+"
+
 NUM_NETIFS=4
 CHECK_TC="no"
 source lib.sh
@@ -166,6 +174,97 @@ locked_port_ipv6()
 	log_test "Locked port ipv6"
 }
 
+locked_port_mab()
+{
+	RET=0
+	check_port_mab_support || return 0
+
+	ping_do $h1 192.0.2.2
+	check_err $? "Ping did not work before locking port"
+
+	bridge link set dev $swp1 learning on locked on
+
+	ping_do $h1 192.0.2.2
+	check_fail $? "Ping worked on a locked port without an FDB entry"
+
+	bridge fdb get `mac_get $h1` br br0 vlan 1 &> /dev/null
+	check_fail $? "FDB entry created before enabling MAB"
+
+	bridge link set dev $swp1 learning on locked on mab on
+
+	ping_do $h1 192.0.2.2
+	check_fail $? "Ping worked on MAB enabled port without an FDB entry"
+
+	bridge fdb get `mac_get $h1` br br0 vlan 1 | grep "dev $swp1" | grep -q "locked"
+	check_err $? "Locked FDB entry not created"
+
+	bridge fdb replace `mac_get $h1` dev $swp1 master static
+
+	ping_do $h1 192.0.2.2
+	check_err $? "Ping did not work after replacing FDB entry"
+
+	bridge fdb get `mac_get $h1` br br0 vlan 1 | grep "dev $swp1" | grep -q "locked"
+	check_fail $? "FDB entry marked as locked after replacement"
+
+	bridge fdb del `mac_get $h1` dev $swp1 master
+	bridge link set dev $swp1 learning off locked off mab off
+
+	log_test "Locked port MAB"
+}
+
+# Check that entries cannot roam to a locked port, but that entries can roam
+# to an unlocked port.
+locked_port_mab_roam()
+{
+	local mac=a0:b0:c0:c0:b0:a0
+
+	RET=0
+	check_port_mab_support || return 0
+
+	bridge link set dev $swp1 learning on locked on mab on
+
+	$MZ $h1 -q -c 5 -d 100msec -t udp -a $mac -b rand
+	bridge fdb get $mac br br0 vlan 1 | grep "dev $swp1" | grep -q "locked"
+	check_err $? "No locked entry on first injection"
+
+	$MZ $h2 -q -c 5 -d 100msec -t udp -a $mac -b rand
+	bridge fdb get $mac br br0 vlan 1 | grep -q "dev $swp2"
+	check_err $? "Entry did not roam to an unlocked port"
+
+	bridge fdb get $mac br br0 vlan 1 | grep -q "locked"
+	check_fail $? "Entry roamed with locked flag on"
+
+	$MZ $h1 -q -c 5 -d 100msec -t udp -a $mac -b rand
+	bridge fdb get $mac br br0 vlan 1 | grep -q "dev $swp1"
+	check_fail $? "Entry roamed back to locked port"
+
+	bridge fdb del $mac vlan 1 dev $swp2 master
+	bridge link set dev $swp1 learning off locked off mab off
+
+	log_test "Locked port MAB roam"
+}
+
+# Check that MAB can only be enabled on a port that is both locked and has
+# learning enabled.
+locked_port_mab_config()
+{
+	RET=0
+	check_port_mab_support || return 0
+
+	bridge link set dev $swp1 learning on locked off mab on &> /dev/null
+	check_fail $? "MAB enabled while port is unlocked"
+
+	bridge link set dev $swp1 learning off locked on mab on &> /dev/null
+	check_fail $? "MAB enabled while port has learning disabled"
+
+	bridge link set dev $swp1 learning on locked on mab on
+	check_err $? "Failed to enable MAB when port is locked and has learning enabled"
+
+	bridge link set dev $swp1 learning off locked off mab off
+
+	log_test "Locked port MAB configuration"
+}
+
 trap cleanup EXIT
 
 setup_prepare
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 3ffb9d6c0950..1c4f866de7d7 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -137,6 +137,14 @@ check_locked_port_support()
 	fi
 }
 
+check_port_mab_support()
+{
+	if ! bridge -d link show | grep -q "mab"; then
+		echo "SKIP: iproute2 too old; MacAuth feature not supported."
+		return $ksft_skip
+	fi
+}
+
 if [[ "$(id -u)" -ne 0 ]]; then
 	echo "SKIP: need root privileges"
 	exit $ksft_skip
-- 
2.37.3

