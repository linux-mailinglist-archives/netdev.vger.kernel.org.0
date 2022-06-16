Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B271E54DF61
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376558AbiFPKoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376271AbiFPKoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:44:03 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2070.outbound.protection.outlook.com [40.107.212.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D375DD37
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:43:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWRObfx4CKWF8ThFZtw1nx5485ShGFQO0RrCzzJzfBMq7JklomVWKSorSw7kB+EYHzkAonYHT87+aJ6OFKjQoJb+2Nk54qVpZ4CJtwhYZ3OBY4/U68nFBUZ2KG4C5gnbimX2WCLkBoCXotgQgj3VQHHJ6OBoHmdLUfJMmMNDSedH4P5CVKSuPNjPcTwlsFcgm+s6kTyqEYznDjSFqyJwHVGHhzafSLwPjhgv+gLijFqnie/VxAqaDKJsf6dIvLzsyl/qA99YcWt+yXit4Yl3pQK3Nsc3c/4uOhL5M2nJKN/HzU3819CoB5riTdFbgALiVl8LfTijdtuLYzqT67rRvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DW0AN5MIgjBj4UkdxZmqRslULKYcrkR3a7z+UCMjaE=;
 b=LPhiMvPWgE83q12MtTClplRpIhbsLe8xcYY9KBY5fun/6dWzCdPVsURPT7cZy0oJEjV1DQRdVHiWcfYkZoLpKKRPCxNPBHPSNJ+tTMRFHoP/bokhasO/50xOfSKEthQ+01q5Fo6Skroua7aCyqkaL0r3lPWSXrsbH2xUu52gWTa7WIvKKdH/LKI3/2Azkht8NfqGPPx18x+wXuMcE553si7Dsv3qECdDAvmAQ1W/lZxUq1QJlV7hZ/z4vdJz9Rk3nxs/hKsto0XAXJH716TOnjb6Paqtfv5LeIukCTPt6Qc1ZYU/UJtVNq+CkNAakZ52BovG+FEQJtNLIQY5ugPTUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DW0AN5MIgjBj4UkdxZmqRslULKYcrkR3a7z+UCMjaE=;
 b=FLBvv1vvo9xKVik0dVtNPHqCPd1/dB2awhA5vxhmA+eHKfJh+3MRl4uJj5+Ui+Hd+vfKyQ134cEYmHp27wr1ia4y9EELYcSZhKNAAI5GEWtDAztNggNLsfM27pofOfoU0Bd12iiYVykRe3WnTunNwR8m7uvsTNC1dBA7lFqVwZAxICsJMnI1Nv+DqjuDMZS0QtrKiY+1bmFm5ByyrvKiabJjqM9+GbDJ9Ofi5xF5T39uInT0xhoeJW6U7SxnRonbLH3uMY5eoQG6k72jZgE3D7lEce3T+F/5F3sVpWp1VcAwTSLOCJ8tTWat9D0+1tL8KqyMZ2iGrxd4UEMAs1VQiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR1201MB2504.namprd12.prod.outlook.com (2603:10b6:3:e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Thu, 16 Jun
 2022 10:43:55 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:43:55 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/11] selftests: mlxsw: resource_scale: Update scale target after test setup
Date:   Thu, 16 Jun 2022 13:42:39 +0300
Message-Id: <20220616104245.2254936-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0197.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5fbc8a0-9823-45a4-bcfd-08da4f851c2d
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2504:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2504934EBD9E7C6AA1BC7539B2AC9@DM5PR1201MB2504.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44OR/5ZG7I/J/80BE0IP5z2jTnhaTFA1hgc49z/vR5TH0MtiaLTnfapm72hyzG8rb3Dl4/OeSo60SBPgUBu57KjR32PDfY+jaAYES++8M0zMA0yCVYJpJ1zImaSHrzRp08vx/ACfnzcVTa0Q6Zs+azzBFxq4ILGDEDX9yqbQ1ivHMVLhcZXONenBKCnmeId81u7kAaYu1AWYGPb6XGlIymgilbf5JY8KN5ZaU+MjPflnIrIk8u0F6Q50iQs9qo/DDuvv8rhF25F+v+XHAEQvUOj5LyBMh5ya1gpxh9QXEJSmuGxhWdBTQ4ciz3hg+7bD3HfybLR+k/5repI6aTWQ9sPsBwrEnPEWZQHXw2uJzMVEQRzDcFZyb8T2sBwKPMQDJEtc2408USMxnt1jTyjUB1AN1MuklJNRwEGWMK13ki7Za2lNXDzV7Bi3jNzFmxcQ1jFvQ8lko7BKnEHdImzxRXSoR4qIX8iccac0FrVhYkT/YWKH8Si5zRDMq21GDySK20nOHPCPHs7fMG6JXahULmbRHwR1+HT1DJE7D6Oq6k14VeeWi7W6SxxPjXVd9UqXEfxnIRPSOcmEm4ajmEuwQKmE2NoWBkMGAT1KbpElOwNkrS2NKFLscNbiEHTVuFfNZVRZaHFxL3rcZUHi5KY+nQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(107886003)(66476007)(6666004)(83380400001)(1076003)(6506007)(66946007)(15650500001)(6512007)(2906002)(186003)(36756003)(8936002)(5660300002)(86362001)(66556008)(8676002)(26005)(6916009)(4326008)(6486002)(508600001)(38100700002)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KccfRaj0hSRRO/ygqeO/CbwR9XmhrFOVyT9t2jYWnADxdxHXAgZOSx3tau7Y?=
 =?us-ascii?Q?XJxoFFfWDvP40Hza9QBZ/TS5nS3eRKOOC6GYnorEIefK0MDNMjZzHinKuGmp?=
 =?us-ascii?Q?lXpYtbsAtqGB4wVS9Om2zm8VzQrO7UyQIkbWH0RNAaR4RlhHj2vrwvYO5hUB?=
 =?us-ascii?Q?yx5HRSiqEK6yeumL+PrXEXg0Wdyb06uIear+F36Ppl58k1226ONmOOKKzc0o?=
 =?us-ascii?Q?H7/wFOuS98zCe1KWp4XxMM/WQca+PsaAyk6NcgWxw6e1I95uexMooTiOwHo/?=
 =?us-ascii?Q?tqpqUUZM6CtC7PSttEYty472WiVzddgfybPCwSmD3Zz2pyT4jRErYcWV/gN4?=
 =?us-ascii?Q?mKWWz8qIlQ02tnbz+oSxpYQiuxPgR26keTGtKn8yw4TYpfigmAs+w1cQkQep?=
 =?us-ascii?Q?FmJy7iCQFw/rePdQ+vp15cz+82JJZw/S5BOpMrxCxIp5Rj5fk+mS6QHp6RCl?=
 =?us-ascii?Q?Wv2whW8ZYIyjw7wMVsuNnTJsYGIzPzkRiH+cm3c0CcrQIb8XwTsr5pONECM3?=
 =?us-ascii?Q?vdbwhUXDdS2H3wnxgylp+IoIZUPkJDvhk7FdTAvS44w8V+FOytx1esnTBNxy?=
 =?us-ascii?Q?tqQSd+Ze1Efl7niG8rpR1QCFAASS+P2TSit7ogPGfCdSPb1QWbYWhXg/HItk?=
 =?us-ascii?Q?A+OiBaG/E4u/F3Ramvxqv0ccJtIP7uqOU8seJjiFPA6PYN+MHn2UvmzfRGBx?=
 =?us-ascii?Q?WkqxJHIzCoGEKJ1RmWwLJnV6a2EQkIpaoUR4MrVITZqqPLeFEI4nJlX7r2B7?=
 =?us-ascii?Q?oO7vpjMYr11SAByd+V51Ah4eXkx6LhbrIdIRbIlqhovONevb6X+I2d4rgr5V?=
 =?us-ascii?Q?+YUtLZeuo+GUX9mObympJREMKJW2QBEc+RJHuMvwpzr9yVGyxH2FL6v+B/UE?=
 =?us-ascii?Q?uonr24MiHoMVv9Uj8i5dgfiPdFq7SBmxxzB/agfRkrxjFN+dys01qoHX2uaV?=
 =?us-ascii?Q?jPrNRAfStoMVUMnmaZtUZETTrZ+mJGtyRWU//iHn1NYJZa6U5Dry6nyuQjHB?=
 =?us-ascii?Q?6hEgKE7i8lKB0KfqImXIY8xAukC9aWf9IjllB2WebBazVVeukYM5VRtOYxZk?=
 =?us-ascii?Q?Sf83yG3ok8If98ZIJTGE7dN4rFY4478RSzsVBhC9wtq3fMZJKoIzUpgTJluZ?=
 =?us-ascii?Q?EDcKbsinm5haZ1jLHM7I+AlTCVJwU1pNMQAtY+74woewPrc7jAv6dsvosDnZ?=
 =?us-ascii?Q?XzJkPzRxrwGoyFDWy618gKpAML9oVGFz8UfU/JEU6iyu50OkHkOmR6z5DEIJ?=
 =?us-ascii?Q?+Fyrtm5BR2tB+QHQvYVYLbCwXjfmZoYzL6A2bN4zQvmow3k+l/ocaYwIbZ47?=
 =?us-ascii?Q?SkZEhoWhtUn3k4n8pcNU+7o8hOZxhqQlYw2tqeQq2TyRxtpcK4AWS5/C9bqT?=
 =?us-ascii?Q?BMH3DAno9PpQyeBQJyGq/Ec3wOomI32LOIzB25371HknmnWSTKBiMOFUUgle?=
 =?us-ascii?Q?wxe2gQIN7gI0kSghsIR6kPAwZGU4mzUtiRl5VESu1DinRDt8vbCrITxNELmP?=
 =?us-ascii?Q?g3/vR1c+a9eY602QtBKAQtQCkNZOAuNvYqUZOFvfa3r6jkQvlr8fqMEnuB+D?=
 =?us-ascii?Q?tdDUzjHYOn1jNhayLDRJFZmKTHwvxy+1ZStKVZ6+TIA+OdKnGWtq3poqJ0Xc?=
 =?us-ascii?Q?nmhxb4YDOqGJ1iYM5rm7X/gsdYxH3iWqoNQC3XgIF6nm9/+tyYUO+AAvB8GN?=
 =?us-ascii?Q?1TUcxDfa1fu0eZJ+j3+lnZFxLrQKDy+pmpjsDqi4nkAX+ZMZhY6qtSVBMnl5?=
 =?us-ascii?Q?f9OV/4mZDw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5fbc8a0-9823-45a4-bcfd-08da4f851c2d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:43:55.0850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qbsBPo2Lyq52DACLhmdZy3sFOM9fagad6Gu+xoB1VSEYKPJA5Gz1xhPPqv/c44EyS3vHyxw0TAd9Zl5sjDEP7g==
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

The scale of each resource is tested in the following manner:

1. The scale target is queried.
2. The test setup is prepared.
3. The test is invoked.

In some cases, the occupancy of a resource changes as part of the second
step, requiring the test to return a scale target that takes this change
into account.

Make this more robust by re-querying the scale target after the second
step.

Another possible solution is to swap the first and second steps, but
when a test needs to be skipped (i.e., scale target is zero), the setup
would have been in vain.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh   | 3 +++
 .../selftests/drivers/net/mlxsw/spectrum/resource_scale.sh     | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index e9f65bd2e299..22f761442bad 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -38,6 +38,9 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 		target=$(${current_test}_get_target "$should_fail")
 		${current_test}_setup_prepare
 		setup_wait $num_netifs
+		# Update target in case occupancy of a certain resource changed
+		# following the test setup.
+		target=$(${current_test}_get_target "$should_fail")
 		${current_test}_test "$target" "$should_fail"
 		${current_test}_cleanup
 		devlink_reload
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index dea33dc93790..12201acc00b9 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -43,6 +43,9 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 			target=$(${current_test}_get_target "$should_fail")
 			${current_test}_setup_prepare
 			setup_wait $num_netifs
+			# Update target in case occupancy of a certain resource
+			# changed following the test setup.
+			target=$(${current_test}_get_target "$should_fail")
 			${current_test}_test "$target" "$should_fail"
 			${current_test}_cleanup
 			if [[ "$should_fail" -eq 0 ]]; then
-- 
2.36.1

