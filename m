Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BE83A1905
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhFIPSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:40 -0400
Received: from mail-am6eur05on2097.outbound.protection.outlook.com ([40.107.22.97]:56865
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238718AbhFIPSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSaCK9iEsNiorNa1OeOI0rW4bwooLnBa3wAObN5OKe6uDAYGecwp/mLlGNnQz1S7Rl2nXa9BjzX71TABOtwsyaJxSSXda0oar1nNmNAa7zm2pKrSdk8y9G7dU86hhZqamKAKm0AQh65rdGHL1Jmnz9nZml6xd0Ey8seO2wbOFl7vKFT/vh0rg/6G+NmKUvfkenryLZBBoQiBZkaDeB6R/vhsjtPJLX0YixZeQlPf8cfVXuOgBWmwDhNK5Q3maKKxw1xjA6vFaHdA37C08Ko3b580+YL7/WjIrCYP7MuWY+YYI4AWOp+ZX/ASNLOhu4B7gSwL8ckE89mPEwsJpv4nWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NL5xHPP8oUVtKKhuyfJpdfKBegW/I2DabixcS4QNAI=;
 b=nhI75kgStRMAUJf5EAk6t+9n5ddq6J7Pkd4EXm+cq+kXDXMNuIenCTJLzpp8I9wd6bMWvHV9bhcVPqdFKeyMNPtrKmq1Wu32fZG29Lpm3okTLwODIB0uSABQkV5ftXoYnM5tm821G+Fxe1cjEqqQsgTb6ljdR+xanJSdPBvatYhe9G+VZWLAIm3b+MZ3a02FGud+KxWzHOfjmkOuc6tb0jzfYRZtZAQ/3ctOl8ZPo2284n9n4by3dyjZwSxiZau62N3H+uJvpsr/n7GCZss/zAMwebGJGjv6eL0F3V2DRxiBn1suhMD0P6wzplhuYuoqm0iIUsNbSSfSF8ZKQpEKqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NL5xHPP8oUVtKKhuyfJpdfKBegW/I2DabixcS4QNAI=;
 b=eM/05q11b8dbSqT7jPwNAsguXaHWCg/HNBoTWbWuu5/ateUDLoAo3HI7xh6UJZ+tjz7GcxqEi5bHViX9L2F2VB3LGwbvYLbCf4elvf/MTJaLIp/CFMXgBb+BdQsV9vyj+ps2isOe3uVwHrQPuQfC4yYtrVxnWiss8jmPcPZaJ5U=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:36 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:36 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 06/11] testing: selftests: drivers: net: netdevsim: devlink: add test case for hard drop statistics
Date:   Wed,  9 Jun 2021 18:15:56 +0300
Message-Id: <20210609151602.29004-7-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0092.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::33) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd1a5531-f9ce-4ff9-ea70-08d92b5992c9
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1427D72C52F2390EB5DFF3B7E4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tBqiF1B0M0meJ8XNz4EfhyDkjsQK2yMfiVpzljGQvjKavw5dtV8gE1C5Q4KaAf/9HJ4JpGExwEp2N3Cg4+3gfu3O3ADZ1P9+49Bc1NcYTFnAtg+JNHkTBlEvx9epILuhnqOFJE5tZ07i6L34CUQvuAPYB/RSk9ehBAAMFGbGG3O0uw4gL/hdtQqnW78GCX89x8p3EAlnKtcSQwWzInP4EudhGrUZh/nZ+i+ewNCwvzgS9HLkiDq6ml8f4TgxBo8QgNjb6GwbrMUjcoez0uE/x9JkSyR3ndxUBQbvcfG5eq4rTaWmbC5krEqzK0ot+TwDrO4OzU4mRinU80qjwse9J3YMJm+URpspREbtDuIDnGwKgcD0d8Dvm46Qvbj2qAgB3b+1nw+VEeEKf+GthLDw9FSaEe10BX49VB1pz4a/audYDIvOg9YnNtNtIM78R1ft0Gzpy0bFSuVUvtHSe5g+070M9k+zyTHfTjYv1DDPgUGL8vbpkXdI+rgUHjEvW2UKmdoC0klA3QLZUjnGUi0ZNDS6J6MBhO70ngxP5qe0dYRskz1Sri3QeurIh+VUtdoCNFbs2GzEtgasiWmx7o9KexeIJl4Hv+DcavWGd5rzUaAet+5e64vZZ1MEfL13q/9Z1sUABnoyOEHQl19g08gnA1LeNrxHZQUaR35oqNhWdis=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(6916009)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OS+V0PbbXliviTonxVWkXn2NYEQVMf3QRklJZa8Fz76mLzbbixtPz+7KWo1u?=
 =?us-ascii?Q?13qhcC9WTkmUV+HXqKo+dYTySnUigdAPL4OC8EBWT2DhhzO3pqt2ESAAFunA?=
 =?us-ascii?Q?Zs8d5N+lOgavw6/oQD0wFl97ip2LpMBUwz94qN4htPIKwvsJLAb/W8yblzgd?=
 =?us-ascii?Q?b2wPU8C8bZ8aBZhzShib+Uz/N2B0qG0HM8hziKOp+FRp/Ae9Jy/I7wDyHpQ2?=
 =?us-ascii?Q?1uXMYJVjDaxQ84ZnwvSeNnpafOPBC0hLPYSfxfkiEyLmw/HFRy54U+eITxbG?=
 =?us-ascii?Q?l2X5AqbrstX7j8uKtRR5toyhN9iiEnktO0ZFsfAJOD/3OLU6CJtt1eTHbwNV?=
 =?us-ascii?Q?kSI2uvdT9MFZDDz0rzM9Bzse8yhAeXkI2dR+OwCpSwMRO4Sr2abCZIgDw1fj?=
 =?us-ascii?Q?VX6jUEhG0fIfDo5QJ1IsMypZpGsAnU5rggPiHpaiBaSEhfdpLy3YiBBKwb1O?=
 =?us-ascii?Q?kdcQVcT0bOWuEzcqUI6Wl5NiURhmPb9anQZ60Psvw5xEv+5zNqjv9t1wnmY6?=
 =?us-ascii?Q?3HMVCMYl8FY1T0rmiWl4jFnG731cOqtpyOOhvmQihf8ojz8cAZQTZQXslpYk?=
 =?us-ascii?Q?Swk/QdsXAoIT90bLsSErh9ET5HeuU0wu+2JhOZ8Upic8InFYr72FlymhbtZh?=
 =?us-ascii?Q?WP2f37wnqVr6EUPCvjtw2JpWO6Lkdmp6oD8cLAOh8zTdw3iE6cbIZTvuHMyg?=
 =?us-ascii?Q?tenZCYBBylECAHqvXYWnFtl1V2F4nGPUX9CP1hqu61/sV0/R++lQHU9kEg+V?=
 =?us-ascii?Q?GM5h1u7NfYS0j7CT/S6g4uT/B5+5k74trDLnilIIMkGNGb1AnkxgeXgH2lKd?=
 =?us-ascii?Q?e6N/k0LB30KL6L6s51rmNhqppYv0Rvqis8nmtizgYGF1mBkzWWGfYvrgUm3p?=
 =?us-ascii?Q?IIR/tNTWMepdDwecABeKBg86ce8CgrZ4Q9h7YLTDgGdDpBuKqUbRIUlPKmS1?=
 =?us-ascii?Q?f0Tj+GXAE+ZxLNf2FIcH8yuY4XbmK/0UOLFk8Y9pq7DmhhIXni0cXo251kcK?=
 =?us-ascii?Q?JncQG6Ngd9YKtruwUUBAz65WwmT3H8HMztoemUZntgZdMpWRFOs2HEW1gKir?=
 =?us-ascii?Q?ECVSCdG2AjK+Ob2oqK+TIhYrXWuBbwqgfE7v713XS/zpYX70B2xbxflefhhn?=
 =?us-ascii?Q?PvF3MJ0H+lM1BW3lLjBG4d0ySr9JIb1rFRSY+uwJPZsRTV64OrVT8tGCmFgi?=
 =?us-ascii?Q?Fu8dMoBATWukAgZfz4hkGbMrEoxkKbruJyRGTHhRyTDdXkcGqmiIZynzQBcl?=
 =?us-ascii?Q?KE98G4aWvalx8TuN9PqsQDJomQQ/LKKsee56Wnd/DMokpKWV4XF6PURE/pWU?=
 =?us-ascii?Q?Sq/3+sjVBN5g3kYG9h8nXmXZ?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1a5531-f9ce-4ff9-ea70-08d92b5992c9
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:36.5421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUbu1SQ3rgfOAyClVksaP0r1U985Ldk32Q2OnE9rKjNKq2AUrQcdKaPgas8cW96A0FB8fISAmg+RkR9mfvcwJohBBi5VwooGxjboilvTbJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add hard drop counter check testcase, to make sure netdevsim driver
properly handles the devlink hard drop counters get/set callbacks.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../selftests/drivers/net/netdevsim/devlink_trap.sh    | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
index da49ad2761b5..ff4f3617e0c5 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
@@ -163,6 +163,16 @@ trap_stats_test()
 			devlink_trap_action_set $trap_name "drop"
 			devlink_trap_stats_idle_test $trap_name
 			check_err $? "Stats of trap $trap_name not idle when action is drop"
+
+			echo "y"> $DEBUGFS_DIR/fail_trap_drop_counter_get
+			devlink -s trap show $DEVLINK_DEV trap $trap_name &> /dev/null
+			check_fail $? "Managed to read trap (hard dropped) statistics when should not"
+			echo "n"> $DEBUGFS_DIR/fail_trap_drop_counter_get
+			devlink -s trap show $DEVLINK_DEV trap $trap_name &> /dev/null
+			check_err $? "Did not manage to read trap (hard dropped) statistics when should"
+
+			devlink_trap_drop_stats_idle_test $trap_name
+			check_fail $? "Drop stats of trap $trap_name idle when should not"
 		else
 			devlink_trap_stats_idle_test $trap_name
 			check_fail $? "Stats of non-drop trap $trap_name idle when should not"
-- 
2.17.1

