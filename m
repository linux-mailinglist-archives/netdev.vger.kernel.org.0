Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFC21F0C49
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 17:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgFGPBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 11:01:05 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:5605
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727008AbgFGPAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 11:00:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0fM2tQhA8oSUdJwP5Q6qrShro0PdynzzRR3Yba+rMFu9m3AsVWbtU12ONwu6F7/M5tpjwirGc+1Sizw2EQHvgwvbKKGlN6gfY7T1lg8Ou3psTaWyjNYKD1QVTQh0lgnWCy8+pLnwhtc7/WLSaxc3BJawtnCrtBGhtoWSlsYuIQUZe97Ag7YOLx8AAQuusrg9wJIydfDtcFKdq4f30Tr07mYUMYDRuD8+uAC5ClVjX2IkriJbpQXEksrMNALsSd5SAQNf1xUb4Jraxnz+ucsCWITLnKe7XfsckIAnv42fsd/Vv6ektyWdK9zJUR+hYgI89sdaOdHhOe6I8T68aybUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uk/YNl7s4xscDIwwX7hP4qIoXMNewIxH9ycPpnJyumA=;
 b=lsHTaTXtWxALgPOw5XFkolZNGI/xCd4g5YTtCEaSkbVsJnr8+R3h+q9gttmfd3P/Bguiu5WZlNG/CD8jmp5jLs1XV9Ib8j31qOIdAQ2Dx6xQV5ttjM/mHyaWxFpUaYWEXqitpcWFo/uP61U1Tjnnh8hcOWP32M10hxcychN/JVtG97++Zs/jdSD/1sHIjAav5yJvPDbkMebn2zUmT7K1tLSq7HxZ2Cxkav4Pvro2iR9ulQ2nJbnnCOgSodNg5QyV3qAJXBfNcvJE/FaIg+nWCCl+YOBOZsMs3nNbGUKNUHuJxtqb6Xloe714SwGZuYyfekoYpWufAEu9+M9Algtrbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uk/YNl7s4xscDIwwX7hP4qIoXMNewIxH9ycPpnJyumA=;
 b=QW59QE/QEfANkzqWxidgh0FTYetCvNfe7aib2W0087pQ+W7VVM29wt1nmirCOh10iU5I2nby7xrqNiqz/Rs9pFbzQktmugkWv2YDRuWG3yWR0LSOt6Ce3JnsC12HiKXfntnDnROhrPho9UqlmqlsbFooxNOtZpM5Im46IoO6+YI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4003.eurprd05.prod.outlook.com
 (2603:10a6:208:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23; Sun, 7 Jun
 2020 15:00:29 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Sun, 7 Jun 2020
 15:00:29 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com, amitc@mellanox.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net-next 10/10] selftests: forwarding: Add tests for ethtool extended state
Date:   Sun,  7 Jun 2020 17:59:45 +0300
Message-Id: <20200607145945.30559-11-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200607145945.30559-1-amitc@mellanox.com>
References: <20200607145945.30559-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sun, 7 Jun 2020 15:00:27 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3c69734-e052-4d05-c90d-08d80af384c3
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4003:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB4003474094BBFB8D87EE2293D7840@AM0PR0502MB4003.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:163;
X-Forefront-PRVS: 04270EF89C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZrksZ+qFJk6Wz07SbLZo7YS2dzdJW0H4Gn5zt7z08623gawKKCF9cmibay7DrWdQm4LYce45f7hqr3z/ncOdrmOMHbZmCOalvFeTxn/wHnAJ/Skg8GfY9hk6xDAt/mNssKmahnRO3NUTa6ypyzwzot3KjJvB6oxGoT+2cTrtJ0v+JdtW20NJ+GwcgPZYNdvTnfZXAOQrb+8krLgbhMHj3dWAaBmWRNeYrINioEY88xwy95FVKG09xOp3fw626esYAxKZuIbgmhzc3k7zsj2xm7ERYvHQ/i7PMcVsgq+p1j4N7hbtLEWSbm2NTOAB8ML3PspNYACrfW+OE7Wgg/jbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66476007)(66946007)(66556008)(1076003)(186003)(8936002)(16526019)(26005)(52116002)(478600001)(6506007)(36756003)(2906002)(6666004)(7416002)(5660300002)(8676002)(4326008)(83380400001)(6486002)(316002)(86362001)(6916009)(2616005)(956004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: u2eW14qaW5lNn5Q0FHxwIoghedRDQI91BARTmSnc7Rsmxl0m5WQDoZYBsuxMt4aiLQXJDklXwqQ4fWsO3lov8DF3R58/A1Ncro7oCnfVZnBhmhYpyCGNP/vc62LPbMABKLt0jUFcATiP9wUP2vWJLB5clOuXSLYIxAs9uIYDvVo89NbzaEw9+OEhAqROXfiVLydyYnZz6JhkabQxlv+hmcuLuUG3X3R/HKCoTOL8Tl/8mK1zOIMQn4JXoNhSzRo3szWT1ObHyk/dF8Xqh4qb8+FHJVagzkj4DmpPO9flvQYXldOv5I9Q3HFnt4nxfuBL60/ZjbiXnUMS8JdsmC4mPOYXlc16Ch8YGktu1/or+KYJ9G1+NjfW2CPQ1+NLSjRZDfSYAqvJNh1JChnCtkPRzUHJGYB0VfHh0Lr75Tugj8uebgktEZhHy4oLhngSlYmcEiPsWHKAZG3pAyGMEDY3Xf0cjjOG4M3ubICr5hpOvOU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c69734-e052-4d05-c90d-08d80af384c3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2020 15:00:29.7157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 619hGefJOtoWmj2Za1llkS0bKjBgsGoyrKaJYp65bHwKp/hsoBgw3LSFxZf6JAQ/e5qlD1PzwjShSu//AG0zbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests to check ethtool report about extended state.
The tests configure several states and verify that the correct extended
state is reported by ethtool.

Check extended state with substate (Autoneg) and extended state without
substate (No cable).

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../net/forwarding/ethtool_extended_state.sh  | 103 ++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_extended_state.sh

diff --git a/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh b/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh
new file mode 100755
index 000000000000..dd7f256296c1
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh
@@ -0,0 +1,103 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	autoneg_failure
+	autoneg_failure_force_mode
+	no_cable
+"
+
+NUM_NETIFS=2
+source lib.sh
+source ethtool_lib.sh
+
+setup_prepare()
+{
+	swp1=${NETIFS[p1]}
+	swp2=${NETIFS[p2]}
+	swp3=$NETIF_NO_CABLE
+}
+
+ethtool_extended_state_check()
+{
+	local dev=$1; shift
+	local expected_ext_state=$1; shift
+	local expected_ext_substate=${1:-""}; shift
+
+	local ext_state=$(ethtool $dev | grep "Link detected" \
+		| cut -d "(" -f2 | cut -d ")" -f1)
+	local ext_substate=$(echo $ext_state | cut -sd "," -f2 \
+		| sed -e 's/^[[:space:]]*//')
+	ext_state=$(echo $ext_state | cut -d "," -f1)
+
+	[[ $ext_state == $expected_ext_state ]]
+	check_err $? "Expected \"$expected_ext_state\", got \"$ext_state\""
+
+	[[ $ext_substate == $expected_ext_substate ]]
+	check_err $? "Expected \"$expected_ext_substate\", got \"$ext_substate\""
+}
+
+autoneg_failure()
+{
+	RET=0
+
+	ip link set dev $swp1 up
+
+	sleep 4
+	ethtool_extended_state_check $swp1 "Autoneg failure" \
+		"No partner detected"
+
+	log_test "Autoneg failure, No partner detected"
+
+	ip link set dev $swp1 down
+}
+
+autoneg_failure_force_mode()
+{
+	RET=0
+
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+
+	local -a speeds_arr=($(different_speeds_get $swp1 $swp2 0 0))
+	local speed1=${speeds_arr[0]}
+	local speed2=${speeds_arr[1]}
+
+	ethtool_set $swp1 speed $speed1 autoneg off
+	ethtool_set $swp2 speed $speed2 autoneg off
+
+	sleep 4
+	ethtool_extended_state_check $swp1 "Autoneg failure" \
+		"No partner detected during force mode"
+
+	ethtool_extended_state_check $swp2 "Autoneg failure" \
+		"No partner detected during force mode"
+
+	log_test "Autoneg failure, No partner detected during force mode"
+
+	ethtool -s $swp2 autoneg on
+	ethtool -s $swp1 autoneg on
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+}
+
+no_cable()
+{
+	RET=0
+
+	ip link set dev $swp3 up
+
+	sleep 1
+	ethtool_extended_state_check $swp3 "No cable"
+
+	log_test "No cable"
+
+	ip link set dev $swp3 down
+}
+
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.20.1

