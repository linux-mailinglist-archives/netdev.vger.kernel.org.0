Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFF4615279
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 20:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiKATk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 15:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiKATkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 15:40:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423C21DF34
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 12:40:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeEH/nYwkH+sr1v3nT0KcE9HG7+/eq4O9x9jvqrjE/geNdVSWgISnzlacw2X7k0DrKsUhqex9z8D0jh6D23/gYBKkf9ub12NRx68M1gaj5hCxJaQjWaroPux0jxFrx9AUy6y44hYmWa32PXlP0Cn6CFjBGbmsYew8JqpqpuAe2VGUMMwFjA5KD65Uvq9wwW9rqt7NwMIwuiY5ygikG6lVtrNPeLNEQpra+6yqktLrTG5mp7Ts4PruQa5sxL/GVpNRZBTu1jzPNlP37+5qr5U7EE4ScuEt5Bm3caMaihNhSNmUOJWdlj+AIT3xOaOHgkWbgMx8mOdOhpsocG/6jIbFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGqCg6WWbuXmq2LtfCZfZ4D7a1wD9O9NjM1Bb8VepDg=;
 b=WlU6gOmPOhfqS0UBC6XqKQZPUaBlZh06s/Jnx/Cx6Kz+dyzUH6Y0b+9l1zBnrJ19f4fF/lef2eKGKfLBjj4oD+E8yAE7NhX5VeKoQmVSsLClKm7nltNWZjtHO6DSEM6We8wJCCguMJDkRNqk0tKK9tQRTezTtgxfGHTdqN7v1Rb/Ji09xlj9SOESPVKvgX+EogNvtNkT7clCYj1CxFWsH0rYNbolouNc7OaP1HMSGvITGNhNnKPjaXoIoJjV9ZS1lUy8uIt2zDScMqXkoGWdAUghz0SIgQ6tUvDP0V/FWNLT+sKdDsqC/8KG8RhWpJ0bvS5GqzyyhuU3iZKhv5QOjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGqCg6WWbuXmq2LtfCZfZ4D7a1wD9O9NjM1Bb8VepDg=;
 b=ge7TlqsgZuG3UJpH8JZsU94q6W4vThRjS1A2bIJDnlNpWeiGpMdFFUzMtA4slzDabhhr5JNSpC+Lf75DaoY47DwBSYo844hWfdcgfF/nvr/yYJO373+qOjYlwWRpo1+bqknIIvAADGSZFPp2O5R1JAH3h9YB3u6gVrwJxcDDj7uQjnPC47+fH+cqaiB5ei9I4oQS89bWKetyFN5omTnLHSMT14P6wXoQggMDiquKRp+Spda8jdAJyg41SX7SQDqFomT6/taJFsv0J2wMdvVtZfxga9gA3zrax9mcor8z8CjAmRb61YH3m0TMMoXbooYkJjr5C8X90FlfaoqP2HAkmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by LV2PR12MB5944.namprd12.prod.outlook.com (2603:10b6:408:14f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 19:40:15 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 19:40:15 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/2] selftests: forwarding: Add MAC Authentication Bypass (MAB) test cases
Date:   Tue,  1 Nov 2022 21:39:22 +0200
Message-Id: <20221101193922.2125323-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221101193922.2125323-1-idosch@nvidia.com>
References: <20221101193922.2125323-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0049.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::38) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|LV2PR12MB5944:EE_
X-MS-Office365-Filtering-Correlation-Id: fd648773-52f2-47dc-7f15-08dabc40e609
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ef0M2b2IhUqNaxDbSiJGhHBlwjulUPzECFAUk03uEGWoGgKeIRW2UHzKty1jC8v5TCsKYuUZ/b8IIv1fIhs2RE94onsb4IBYIH4l1aD9ILirVs/f7Zwm5D/XRdCoesFjOjGeR52QUPUnuz35nyuyHwCsHQP1nOGW/noqDWFFUMoXxx6E6/2pZS5dUlMPGMsiwTURT8YGMMkEQNG6BoHyv/Ndx6CpndHSp2U0ycCnQDxtumdty0hyuzpdMVaJKXthr/wiTAriqH/6f1jLtILZAJzoLh2nhwKHxKiR6DxsDUXnqj3VC9OAmFn6CVYJu9oZJekDGNQ6HTMeV17UVr3t3KW2Y/peudWl7+a9e0tVi0EBEWKHBtqs5rrw2hBOdzoh9ddcOUmfBDZWw3huYHlyKDsMDK7Tjwmy/NDDmjeglVLvrHUDVXsIc20zzvp7wDCX4bQkZMlWM4M4EiUi/7LYUzh6M31n5JxDJa+U1NNdlSD3O32CsZx3o2UQZKdt+ODG+94uDr8Ag4K3vYfUBgI/Iq1YEQizKhKljuc1OCu/GOJN3aIkSL6w+VlBYc031Th9jBZaP8a8KJ2tJogSdYaGWE31Bjeg2cIOnwEIY+xFB+/SsgfhYsM9DvdW4zZfKKK5VKCBEBCe/A+oQ2iiYvYxxU1Em1FoSK3lZl0e5aslXKgjAPF/GXyXblASvQmLJw1tR+73OropF0MO2GH+4bDT8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199015)(478600001)(6666004)(107886003)(6512007)(316002)(26005)(6486002)(38100700002)(6506007)(2616005)(186003)(1076003)(36756003)(83380400001)(86362001)(2906002)(66476007)(4326008)(66556008)(66946007)(8676002)(41300700001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?15CNnwrkbQ/kWHCCJW8KVegapkvQwC6Lk+j7pyKIepD9o0cCqLMIrinTEVft?=
 =?us-ascii?Q?nbwyTYbVRTCzvxuYb/uigH8am0p6nH5jS+vcCibGLij3evs0McPuzoyF3LC9?=
 =?us-ascii?Q?NLOX0cmQOk0zu+Xve2C3pGonwobrKt0bvKAk/pN7InzmnNtN/Ps7LKer5khY?=
 =?us-ascii?Q?rRsZ8TgRI+96LSURd+yWqtjbsU/ELS5GRnJ+PsB+w+9QplvACAMAx2KLTt66?=
 =?us-ascii?Q?G8ARm7jK54cFsouvDYYIT0sw+pQ4HCsv7m08xJouEYh4yDakIwe+AqM49Rnr?=
 =?us-ascii?Q?EprxPxIApcdHplCMgVtFGjLut+QEUBVtXs3kcTmX8OKl8Wvrrf8h/wcmN6zu?=
 =?us-ascii?Q?FTrwDtifhJi+nK9APa7L69LxrxrviV5StfYJc0H6g7zHFGVMS20xSJcbx+VX?=
 =?us-ascii?Q?yTsgIhJgHmdppp1AkD0wLM/BR4GLPC07yVN3R087vP4c/3ItUrCWdJj02TJ4?=
 =?us-ascii?Q?X5Jxiw241HsjGRUpSrSNoQkGVEakbFNnrRYWKAGh9DPDkH2E/HTk+jTau0g2?=
 =?us-ascii?Q?NdmJIi0RlC/rwrN0jNwK/h9M9pJKN7GFVx9pq7aqSZ/TTegEgb+QAdIstcoc?=
 =?us-ascii?Q?hik0BmqugjpRGePAka454USKK+lkMg99TfISLaCpcqXhYWVeKSrvGyYgxKh3?=
 =?us-ascii?Q?skYSCHUdWSgPvhU0H1xjk1e5hLKM+gB3ocie52ohL9xjL4LhLTyfKO/HnFls?=
 =?us-ascii?Q?eBtHfQTr+iu9AojiRJSLGtiXzTBb+o375AcJUX39KihKAGUNqtoW5nYn+zES?=
 =?us-ascii?Q?sdQsyBN8nHYqLaznPCRwyTs489F/zogUMDXaJe6nZrHHd2F4pY5d2G+TjuhC?=
 =?us-ascii?Q?yMQueIQpmpLCiurE4ABTAlaUpRL9azpk9+JLZe/JR54KumpNmSTonERxOFdO?=
 =?us-ascii?Q?aU1y6xje1qWrdoO03x3D1EoQJYgki1+Xs/R2DvfAAVze4fNXMZROJIeNZ6D+?=
 =?us-ascii?Q?K7wARWt/1pNikZJ19nN0z1+x2nraUNm94Ty5pk20RWFmCCt2h2qmnE7mbVNL?=
 =?us-ascii?Q?Op6ErjvG3oMrLtTIIPFteFF8GnpT3qHgZIrL4aKQpf9CaWr1PgElvDdWko4W?=
 =?us-ascii?Q?J5kDq6o8ckbEwS3G07CUhOa5PnucjPi7uBDvEk6XMptkVTpdQb4jzTuYDpu9?=
 =?us-ascii?Q?VbRTpXyw8wQxHTcg0RHxQy0FgGhvzf0jrZ0HcXfvppFWtXc9vUpk9IV8ZfI4?=
 =?us-ascii?Q?kQhceSaJPBzFupyiaN8VrnVyt3+8JdKPRRLCTVGMLguWY5twS6y9K/Z9+hMn?=
 =?us-ascii?Q?lyoTzySh3THqCWUaCzJgzU+TCoVxFqCTtGl8DpdLS4qsjyDQSrvhYvrN217W?=
 =?us-ascii?Q?qEUaDws0IlQhHgBCbP2LtWEftEVq7PdixQdRpqFn/E5L1OEWn0uuLn7FhBYS?=
 =?us-ascii?Q?T1LwkLvLihs2aY+Sk4RDvUiSEEebPj6a39HmNk3hryT8gdmNR0HhXl7/Na8q?=
 =?us-ascii?Q?6F+PvET2cPPPyIQJsO9+AAhtXD6Igtln9o4BlU5wZvl3KImUTDt82x6OPuur?=
 =?us-ascii?Q?O4kU6hmj0ByjdJbL0hX4L4eTpPEQ7HsB06xVYRKcGkJXg58bNLcFgwuBkWfo?=
 =?us-ascii?Q?SwnwYkhCJxXexOXNG7h7bZNUzCYfdDH9F79XjQEt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd648773-52f2-47dc-7f15-08dabc40e609
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 19:40:15.2000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OwmO1Y9S+9fWOACVcpY83wm/U2EenOCrloxsHrfy9kbKUnlj4rD0RxSXd1um9ueWDXZnXw4B9zNrjvE+vo4vIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5944
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Hans J. Schultz" <netdev@kapio-technology.com>

Add four test cases to verify MAB functionality:

* Verify that a locked FDB entry can be generated by the bridge,
  preventing a host from communicating via the bridge. Test that user
  space can clear the "locked" flag by replacing the entry, thereby
  authenticating the host and allowing it to communicate via the bridge.

* Test that an entry cannot roam to a locked port, but that it can roam
  to an unlocked port.

* Test that MAB can only be enabled on a port that is both locked and
  has learning enabled.

* Test that locked FDB entries are flushed from a port when MAB is
  disabled.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v1:
    * Adjust commit message.
    * Add FDB flushing test case.
    
    Changes made by me:
    * Reword commit message.
    * Remove blackhole tests as they are not relevant for this series.
    * Add configuration test case.
    * Add a few additional test cases.

 .../net/forwarding/bridge_locked_port.sh      | 155 +++++++++++++++++-
 tools/testing/selftests/net/forwarding/lib.sh |   8 +
 2 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
index 5b02b6b60ce7..dc92d32464f6 100755
--- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
@@ -1,7 +1,16 @@
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
+	locked_port_mab_flush
+"
+
 NUM_NETIFS=4
 CHECK_TC="no"
 source lib.sh
@@ -166,6 +175,150 @@ locked_port_ipv6()
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
+# Check that locked FDB entries are flushed from a port when MAB is disabled.
+locked_port_mab_flush()
+{
+	local locked_mac1=00:01:02:03:04:05
+	local unlocked_mac1=00:01:02:03:04:06
+	local locked_mac2=00:01:02:03:04:07
+	local unlocked_mac2=00:01:02:03:04:08
+
+	RET=0
+	check_port_mab_support || return 0
+
+	bridge link set dev $swp1 learning on locked on mab on
+	bridge link set dev $swp2 learning on locked on mab on
+
+	# Create regular and locked FDB entries on each port.
+	bridge fdb add $unlocked_mac1 dev $swp1 vlan 1 master static
+	bridge fdb add $unlocked_mac2 dev $swp2 vlan 1 master static
+
+	$MZ $h1 -q -c 5 -d 100msec -t udp -a $locked_mac1 -b rand
+	bridge fdb get $locked_mac1 br br0 vlan 1 | grep "dev $swp1" | \
+		grep -q "locked"
+	check_err $? "Failed to create locked FDB entry on first port"
+
+	$MZ $h2 -q -c 5 -d 100msec -t udp -a $locked_mac2 -b rand
+	bridge fdb get $locked_mac2 br br0 vlan 1 | grep "dev $swp2" | \
+		grep -q "locked"
+	check_err $? "Failed to create locked FDB entry on second port"
+
+	# Disable MAB on the first port and check that only the first locked
+	# FDB entry was flushed.
+	bridge link set dev $swp1 mab off
+
+	bridge fdb get $unlocked_mac1 br br0 vlan 1 &> /dev/null
+	check_err $? "Regular FDB entry on first port was flushed after disabling MAB"
+
+	bridge fdb get $unlocked_mac2 br br0 vlan 1 &> /dev/null
+	check_err $? "Regular FDB entry on second port was flushed after disabling MAB"
+
+	bridge fdb get $locked_mac1 br br0 vlan 1 &> /dev/null
+	check_fail $? "Locked FDB entry on first port was not flushed after disabling MAB"
+
+	bridge fdb get $locked_mac2 br br0 vlan 1 &> /dev/null
+	check_err $? "Locked FDB entry on second port was flushed after disabling MAB"
+
+	bridge fdb del $unlocked_mac2 dev $swp2 vlan 1 master static
+	bridge fdb del $unlocked_mac1 dev $swp1 vlan 1 master static
+
+	bridge link set dev $swp2 learning on locked off mab off
+	bridge link set dev $swp1 learning off locked off mab off
+
+	log_test "Locked port MAB FDB flush"
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

