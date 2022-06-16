Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBF854DF5E
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376364AbiFPKoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376511AbiFPKoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:44:16 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB695DD09
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:44:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpO4phXf6u9EGrkaudmCnvGLEw9oZVcxwqPDaX3d+oa4OyDWCH20m9xgIWcIz+cnaUcn5JBxJLMa3rUfqGPXXPjxUtStQYtmSr+H7Ev8P0BqCV+mfc/bwjEsf5lgNzmg8ncTkYXASQ1iJqJDNclQnEKo6E0VcFk1Z8pUj2dT87z50vKzNhSXefovk/qg63YaUB8XFoWpWoy1Z1JJuALR/dhwvoF49NHSl6OrNTHy5g8uyp2veIJxztR6cz/y4uX9QL+0H0wxeuyd9JB06hsvx/U0xR+DrMqiGQ16+qADMENgDH8BvDQRIlsxEksbaSAlxHXnV8212NH01m0mVI/mcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9QZBjSKpjIe2YmYAxuXK72DVugDCuci2Zje7WQndhE=;
 b=Utntjsnn0J3f1TcLMLVGadUW77HJQQx3Ee3KMT7fq4HRT/tbgETywWsFcI1ZlGC/AudzrrljBUIvb1LCxCC2IvLY50C4B7mnmfQejfvgSOgO64Jisu8cLwe6k57OgRJnuJ26j8QjsAA8rnTNpgnEfuMeA0r0k/Xu2HyRjpFyuiDPBDTHxFJzl/UEP42CDP4mG+xedPvUBZV6wgsOjrD7lCDFTzJiIcTUd0DaxjcTFFSVZTA4KGERWVYJypqCDF1GEDQeifq/Ag/7ZFjp3AbMt3RLBZURzjEClAqMJdzuqqjBgBxIdxZ0urpVnkANWVcq8rzqu6EsJ2pop3RB83Y9tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9QZBjSKpjIe2YmYAxuXK72DVugDCuci2Zje7WQndhE=;
 b=ozpVDk4elKX/Ep3q2z76tm4T8nclSG2g5/2xcSargQK3SLnwCNqHPNAPyQr1dc6xLv+WT4JVPpB7HlQKC/NFtAK7VekgxZlwiReYjyprPJuh3HqxGalVgUqYU3Ch4MG6dtCh+lnrbxSh3+8lXKAd9HNoGUQdMFf4uN6TjHMgEdssDaaVmDrWpBUNRlBhLnmpdJYIUCnqEiZzsNZAQP1S+QZSTljDbGl1fC5OWAd0QOxTltMBFpfQTz+Z5D/6UNzZ+ORFb4b0QM5gz7oN4dSCQuj9dnWH2LZv7PnNNxovN2/bXcAoANItlOzvSAsJsIcse78ok5XMaGSD2KJuG98oMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR1201MB2504.namprd12.prod.outlook.com (2603:10b6:3:e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Thu, 16 Jun
 2022 10:44:02 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:44:02 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/11] selftests: mlxsw: resource_scale: Introduce traffic tests
Date:   Thu, 16 Jun 2022 13:42:40 +0300
Message-Id: <20220616104245.2254936-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0036.eurprd05.prod.outlook.com
 (2603:10a6:803:1::49) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c21b2be0-37ef-4308-a518-08da4f8520a8
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2504:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB25044286A184F24379B19CD8B2AC9@DM5PR1201MB2504.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mwRL8iuBljsPB9jmXiK6xT1IMCZyh8gCVVZ9SAml9OFYKjeYL8Om/wdtkYpUQGZ0crDTiudkCDaYHX6RBCQuKmn4roGqtcESX0lhjBKry4NYpNuXuh9mCG3IWNbkMqpRRAp1onM5xnI0RMy6G0ikU/+CuTdWUM880NfxLy2ybrowUbBdPQt8ubEV7N4CdWOKk8e1MIcwWujOHyCN2SpH+YDdpJU8MKFkKSDKtjtViNBWzkHRtnRierqLaXqN+8d0vBhji915i99vXcGbYPWKwIOoOBtgzx06TkZYu/W65mGUeGzokgSprx8Un2UaLWYmhO+TaExrNlxiI49OjFYsGgLH5ZfO1CnB4Wk7RR6pkSIR86k8pikmd20sN8usvrXC05vHIKr/KNSNmPLeR+niSbqvHCjWQf2HHmYf927wwCjDQ3yvzEk6fIORFXFWE/XhpOB0YLUCwI7o0ZClyN27oPBT+ZqvPqnAwpPgaMEvVZRfTfBxkh9IVX/Da/zsInD8nZoP79KDBW8r9OcpbCZ0Cp8KVMoS2u+9+Adcp/d2fVaxUB53aHvNWNM4KXQ5ymmi678NSb43w/UAPPQglQ+PX2lORJzoDBgFJqchrOPaAXXCGeji14PY7bs7CEqd1T/prODQlcseN/Cy2QI4KYk9mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(107886003)(66476007)(6666004)(83380400001)(1076003)(6506007)(66946007)(6512007)(2906002)(186003)(36756003)(8936002)(5660300002)(86362001)(66556008)(8676002)(26005)(6916009)(4326008)(6486002)(508600001)(38100700002)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2zFX0duSGfu2TxtK0Vy6cPab55zf+MC8yiBRaxMbOlCQZ1ZmFQAitti0DqCU?=
 =?us-ascii?Q?kTq2FVBWd5Lynsy+4HWpPurwImOUVPJTIILcEh1Eh5CXYxt1OwLrUm2wWfvP?=
 =?us-ascii?Q?hdY6OnFcLw609Gp1zCrH1aJyuEsRaqLw6eK6mbB8dSXkQr84B7px2Rbe15YO?=
 =?us-ascii?Q?G1SEtcmiFLZh5z3LyRntpjcnDErA3LsNUJyGL/p2Kte2jm7Eo7jAH9Owo/oI?=
 =?us-ascii?Q?Lmbye3o7Bs2Lx2IyV8p7Z7EwZ0eWpzCFeElsZZXhRPe4q+I9/ewXxYPOOi/d?=
 =?us-ascii?Q?hfPcYy+Q/OHkG6pib2TMU9v8QcCTvLQczitlhFnxpH3m6Fs9x6z3sgyJphuS?=
 =?us-ascii?Q?z9aVs5WG+RYrSGq2TTBSMXd7shUrvtDZ21T7M1eqWnjyhamdnaDAobKjSCVw?=
 =?us-ascii?Q?UMvvCd9Da9WwO4OoxWZagi4tb82xWV9PX8vSp9qfvBiyoJ/NaFIPxOq445Dl?=
 =?us-ascii?Q?EFY0veW2H4E3+ZzJkki4seNVMa2ZbmfeTFQzheIgViE9nZFQdd4O6GHQgCGq?=
 =?us-ascii?Q?HlQcJuVhxUzT3bopO4Q8EWzzyVHfAkedjTjfcFxuFEZ3iy7ww02gQPsQAVaY?=
 =?us-ascii?Q?lFCc/LJdpYJ2tWG2tjOjapiiaEkqqkeu4sn3g/iu+QNwP4bPRUkHqJhFTgls?=
 =?us-ascii?Q?duZ3uHBiXEJE9UqMkOytyaUZGYZy51R9v4LdsZTdiGEPJHRtviaFs2IBgMiT?=
 =?us-ascii?Q?cbJ049gLvBxB0QtIArvofIee7yGZMMJQxfNkTwtfwCwn5q3rTyo8q8ekAIB+?=
 =?us-ascii?Q?i78hVjW3QrsOctDaAlkFr5kvlKZnu3ImUSbH2BOo/WzPMeL0lQVYW9zIwupH?=
 =?us-ascii?Q?Hz8xPyQxw+90yeHWPB0UcZu4wFVP4LIQ8SZGFQ5OLbSc+xmCbUxVg7FTExtz?=
 =?us-ascii?Q?9eo/PGqVTR+XCIzL1IqV8fbtTX6SveID8a6IKbh3h63YxfJSCjk/rSn2X83z?=
 =?us-ascii?Q?HS/AlaQke0U+PYCJ2Tje/KLBbjfH7F6SbPTsvHUYHQOQwLuKQhLKDEBSzPGM?=
 =?us-ascii?Q?AgT/hpGJ7JYkaBvDUpN5RbpTaN1ULuN2JeuLpoTC8Jm+tIY0P+UxG0xn0vXP?=
 =?us-ascii?Q?aV99MZH45cxrRIPr1ieM9KUWe364O4sQ9IYLTuJQyH4eWsUDjyQgP6BDJPBB?=
 =?us-ascii?Q?/OJKMPGtoNeQdT606z0Y8lPEADLQ9fKeEG+Vpny5EOpEkx/jGZ9I83bjvBkI?=
 =?us-ascii?Q?w0UT1OQ18Vk8FThmoPaxVlrp334ANMZDxe5CGhFxrIrP1QUHSFSW4CxB71nZ?=
 =?us-ascii?Q?kUGQeVP+izFEW8Z8PF4PtwNdaGCxsBtemDVlkkRoik6+TNzLGUKOnShcyU9D?=
 =?us-ascii?Q?2OH/VNylMjvT2d4GXKXoymZZH9cHJPzMTTyTaG11Lk7DkcslkyRpmde8WSsC?=
 =?us-ascii?Q?rj+rUNSznRW1t5Ll5RAb7YpZEOgcwALq/Xhq9HYhA/m/O0/bKqrwX8gYRiUb?=
 =?us-ascii?Q?xLxTSOQWEbdkZUjSZithpxTPNHYIwvGgntozbhL2Uxf/rgI0DF0CIyTdmeeR?=
 =?us-ascii?Q?7A9vsCGoPp9v3evbz4Yc32JwLhzut4MmeklQZc6z70ZJOuA4AqEnLGo/iyPg?=
 =?us-ascii?Q?yQYTODvcJiD+HAUF0urhdy4hbS2Vm/8X2MqujMj+Rd+YbwEt4dJhln8RFnZu?=
 =?us-ascii?Q?8H+YL4yIYxATIeiZNBCslydX4qqChakkRlWr/0743edD1f7Fp6x8kiTn2Ihg?=
 =?us-ascii?Q?IIfJ2Sgj77oE49FAceE55VyKj8xCXVmKPwjLcURDu3AAE6hfGxVufsc8NA9Y?=
 =?us-ascii?Q?VKTELQnePw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c21b2be0-37ef-4308-a518-08da4f8520a8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:44:02.4607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcAKut9L42/dCSt+Mt4XULrU7dTOgXAg/Ax9/z0KN2PuUBhvPVjsKXFRHJ42HwRG+yAdq09UnHzBBGuq0H9IQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2504
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The scale tests are currently testing two things: that some number of
instances of a given resource can actually be created; and that when an
attempt is made to create more than the supported amount, the failures are
noted and handled gracefully.

However the ability to allocate the resource does not mean that the
resource actually works when passing traffic. For that, make it possible
for a given scale to also test traffic.

Traffic test is only run on the positive leg of the scale test (no point
trying to pass traffic when the expected outcome is that the resource will
not be allocated). Traffic tests are opt-in, if a given test does not
expose it, it is not run.

To this end, delay the test cleanup until after the traffic test is run.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/spectrum-2/resource_scale.sh   | 12 ++++++++++--
 .../drivers/net/mlxsw/spectrum/resource_scale.sh     | 11 ++++++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index 22f761442bad..6d7814ba3c03 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -42,13 +42,21 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 		# following the test setup.
 		target=$(${current_test}_get_target "$should_fail")
 		${current_test}_test "$target" "$should_fail"
-		${current_test}_cleanup
-		devlink_reload
 		if [[ "$should_fail" -eq 0 ]]; then
 			log_test "'$current_test' $target"
+
+			if ((!RET)); then
+				tt=${current_test}_traffic_test
+				if [[ $(type -t $tt) == "function" ]]; then
+					$tt "$target"
+					log_test "'$current_test' $target traffic test"
+				fi
+			fi
 		else
 			log_test "'$current_test' overflow $target"
 		fi
+		${current_test}_cleanup
+		devlink_reload
 		RET_FIN=$(( RET_FIN || RET ))
 	done
 done
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index 12201acc00b9..a1bc93b966ae 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -47,12 +47,21 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 			# changed following the test setup.
 			target=$(${current_test}_get_target "$should_fail")
 			${current_test}_test "$target" "$should_fail"
-			${current_test}_cleanup
 			if [[ "$should_fail" -eq 0 ]]; then
 				log_test "'$current_test' [$profile] $target"
+
+				if ((!RET)); then
+					tt=${current_test}_traffic_test
+					if [[ $(type -t $tt) == "function" ]]
+					then
+						$tt "$target"
+						log_test "'$current_test' [$profile] $target traffic test"
+					fi
+				fi
 			else
 				log_test "'$current_test' [$profile] overflow $target"
 			fi
+			${current_test}_cleanup
 			RET_FIN=$(( RET_FIN || RET ))
 		done
 	done
-- 
2.36.1

