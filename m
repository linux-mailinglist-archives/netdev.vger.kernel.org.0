Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3E154DF60
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376657AbiFPKol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376301AbiFPKoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:44:18 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E9A5DD03
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:44:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNq66khrtQ/IbB42nhuDeFSUIMRhYt7HCwt4JgFpz9hvv3TFFBFvZspoGhUdf22uNxg/P3AE/p40l6E+wqPg8rBypn8X/7V4jPKZZPadE39Qw+uSlYFbkakqilWgezXPYb9ROM7x+V0h5OrvddybM0C90pO9ob8gsTwIBQi9zQecLbUQ9aALWDo1EjJoGqZxynGYLWJwJqwLg91kI1Rhi0jGL/GSQXqxpNyR3NO1yXuIuAD5znEXGdqrM/O2mM0ifGG/XJ2GsORe/E1AlNiCX+BdDtt3j7Ubb1d38Qw+SWN1h9DVLOzu18OUbRK09t0DAkRPHxGUAS4/xIYzPu1Isw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJ5yqi1xh9UFDm7Cp6ROnnC6I4tcNT8Cl03L6ruE+Jg=;
 b=gVdFZDPj/Oz5bvb+Lwzsm/P+DonO4qKh5w9Tiu14i3YYv4ymKXdQEaVUO8rWTH/vaNpeb0eGfceMx+a9LxoPRo+u3b8SnQ22WhBBGa+sPsOZAYYRk84xCFaOl6tkGuzW5ZOJrybLrHL73wZNSyB92aNS17pUsCEYJ6+xw5bXQpiXAT/yGRrJVin8Q/zlZvZz/1Ydv3+rYGgE0VcTivdKAfG7C8czgOxL3cYmQKfXKjeVEGoA4bpdM3a+t2xEnDEyeR+WxhnXTXf+wbP2Hqfsnmr2l4qsttp1MUUCtIvwi5r+6QNmZqbMOofrA7VSPgCn4a2/G2mu3RQzNprl7CxkLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJ5yqi1xh9UFDm7Cp6ROnnC6I4tcNT8Cl03L6ruE+Jg=;
 b=Aq7s4SX/iwZbafsEXgnScvjJj0j+BtbaJljbGwvyYAHgHR/OIriOlRY+XnBHWlbHuyI+VYi6MKBMRcFUSckoSBSBkPS46A7cv/+Ga1A869XQ7U91WwzCrrWbmcSIodUIv9Kk4oqMc8W6sz3H7WIPCwOqIArug1aOaGA8pTZRkQslPk7qX+mh1xVYF+HmtXbUdy6bDYvcg8WD6ZSaTVJUGZsw9twWaB6deVjGAdWukf8DhPdnMjUxEq9DcPNeiQsu9eEH48diUKHcLVS72Ka8aVLcUgmVFrcCpw0aXzQdo5NF5aA/LmJN+HiV+otsIxfGbun2guY2hjW6ZRbbhjG/qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR1201MB2504.namprd12.prod.outlook.com (2603:10b6:3:e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Thu, 16 Jun
 2022 10:44:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:44:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/11] selftests: mlxsw: resource_scale: Allow skipping a test
Date:   Thu, 16 Jun 2022 13:42:41 +0300
Message-Id: <20220616104245.2254936-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0072.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::49) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ee62a61-5721-4ba4-1d00-08da4f852490
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2504:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB250479835714A82F3D329EEEB2AC9@DM5PR1201MB2504.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2qppxjUrLWg2UH/pT3aniaZufO3JecKgdI/7mV70mnvxDdjx2hZ8vAvZt/f5N77EqJi/71vVYRDLiFfRAGSnmzPH8Bh5SXneghRits+/8BtUFhRnkK3MLqkaFzWLuHBdBsBIkQgiMYxEfH1r/4nys6FcuaZY+hK27YWqPbg9vY6YfxfVEvX7W/prhTcrW00ZuSHnvsMYAz2ndaHSsccetEL8t9C9yMB6+NPZgrtSe5iiIVAGvsaKdL4igDtU24+kN+W+OQI8TdFnsJRIDGTwg3hY/ZzGcR6ads0VN03BKPXTF2KYG1y/QOinAB7NnCWC5bx1Tl8LrGe7nHkQtQZ6RBdW2AtOyJUjvkhmqV4xFv9dxV9TW//wf4M0jaEkvoYuvS0/7DLcgsTITrFaTO7pB3Yaos1Q8/39St+GycEeniZcroiaEaCRtXOvRbnn3RC7aD/LRa18iOM4D/mf+Y1anOXZo8sXZFniyCas+u3chossbVzVXftzmHjUH1/4kNouuz+CdGGeUGZn0tSaf+/+kOV3zk5hr5Mn7XFaGhydJU1iEqZ69bz2IsGgeKYICXXn2e3knHls6jko3HDNyioyHe7tohQxd9e+Kj/tHV4KzU0qYkY7DL53z4gzCmPyT8MMIWEej9ai3SRuJCbOawoc3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(107886003)(66476007)(6666004)(83380400001)(1076003)(6506007)(66946007)(6512007)(2906002)(186003)(36756003)(8936002)(5660300002)(86362001)(66556008)(8676002)(26005)(6916009)(4326008)(6486002)(508600001)(38100700002)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NAw7m5VDIZuzP8vXgcpTDF306Da1130rEv1TEnwoNKBIxUBpWSy5RSQPdVp6?=
 =?us-ascii?Q?nIucT+8Jyy7qH2j4wL9KtVVNE9aPiN5kHkXtoq6akrRteJIq9zpBNPE6/n8z?=
 =?us-ascii?Q?+okihPcLwk76WGT+xS12LHIFngpKe9jge5iv7BNR9+nICJWIpD0AMJLJyfFE?=
 =?us-ascii?Q?i2A+tlkdEQ6BsA9NPNJUyo9x7vNC0t0sOsSXmfDl86t4neWeuCDwpxuNI6rN?=
 =?us-ascii?Q?DqaWbPhK7bTVb4sLz+sqRYU9DT7nLvyfRJUheKI67/5GmdeAEFK76ecApFW5?=
 =?us-ascii?Q?cDdZxrcF8cAuAwiAEh6LaeKRVpdBqTflJdIH3/ZlYGWynKohY+NhRLKsg52l?=
 =?us-ascii?Q?SwPbZ3chBGir+i0lz2iLe4yRpLkX5LiR8Ox9x0J4qaDuJUz3idPthQZRDwiH?=
 =?us-ascii?Q?fv+8T9bnABtp8DPyG4k1rhRjR4K39AmujsERz0N5EJTwPkHLuPIHINBTFJ06?=
 =?us-ascii?Q?2T1cJSY5L+Q46nAD5ok921jdNWdLUUrrfiHtmL7bn0K04/yhu+5MrJvWs4BO?=
 =?us-ascii?Q?gCa+bE5aO/045k2rksPOTbz4El003zgcJDCOw+77O4P6yJMSzVKXYJdABtSh?=
 =?us-ascii?Q?6J23D6X044sO/66SjT6uqPPygwx3Ra0Rse7SAm3vp6wZ0tptMWNjrKQ2YWtR?=
 =?us-ascii?Q?AQKMrZ6F/URd4cj30c1GfBWmH6HT0FQHAdOlmrQaxGzaLrwP/Wo1h0i4D9SI?=
 =?us-ascii?Q?ziJi9v3OuQE85FFYu+u+lJ43YakNqUr1VFY6/vlj9gl8U8/4P4fPD30fTm8Z?=
 =?us-ascii?Q?wrqhNPLQYVz7wGL0QML3Q/51qeVOJIh7RBYG7OG9Myn2NWFgRbVa4DmaJJKv?=
 =?us-ascii?Q?J+IvCC642u+zPuFBDGm5d70hNqGZpONtTIGrppshSypDVaM7hgHMf19sG4co?=
 =?us-ascii?Q?Ws1Oc0ERaP1XZIKgxAkeRkg+v6akCd7urFKsoU13cIFTzbI15S1I3wDjpZEc?=
 =?us-ascii?Q?hioz7oPfXuCvHuMjIwD7CIuyRpfxpw6Ksi3IeEuQBC87J41KxrhplQv/t4h6?=
 =?us-ascii?Q?/CpsGGvB+4zvpyaZRSsuB59L54Us8BMHrEP/1YTGEMNDhKQ4NaeCZVow2G2A?=
 =?us-ascii?Q?YXtcVZyUgNqos9Xx83+cWdIYNKnu6+pNHaKz9E8wYMbyIw9UpAxBhTtI73gT?=
 =?us-ascii?Q?tuPa6rxvVljq9jrg6I0vkWpfpeYsKkVeYkwfXhs8kKb3bHzz82jKyq6CLEs1?=
 =?us-ascii?Q?7M26FWvT2OcdSE4gZrDfEUos25ofoLiAT0s23Rec9TypwctfomDpo1ehH90J?=
 =?us-ascii?Q?5nvNO1V3+o6jCH1mcIr7BYZqYbMCQjt5ZgWiwjOvpme8x6eipqZTq25aZQYP?=
 =?us-ascii?Q?3vS8UD30csebeaBXK9Nez76P5gGN7N+t/1Y0kdIyxjHnDOOmMnBDwIRVoVLw?=
 =?us-ascii?Q?xcMImiNqHrCy9UnOQbihNvvOZufJR8ASfDZvgNLzCQttMpCRSRcg6L71bjCj?=
 =?us-ascii?Q?fmGMz17EGucVoasMDv4B1Im5knXRfFsNY0t8+DrwAI2QqmLdnKuzYPV8jDV4?=
 =?us-ascii?Q?bYrtDh1bEG0TTm2VcGmdwyyxsfRyHFIWvNnuUgKCVk80vJFtKuOHW/FC1ATV?=
 =?us-ascii?Q?3bZldFYCzQPhHv0G+EcBL86CPjwwm7ahGDmFZ1Be7Ovu9aQ7PxSZ5ejz+wqk?=
 =?us-ascii?Q?PxRAn8tLykuu5E7wwMHo2ONUgkv24h65dnK2W6faH+pHnFpbuCRIng7ZhatU?=
 =?us-ascii?Q?4/a9iUd7qPLi7VYwIG19/fPa6UfkQRokVILssqoyx+nYJlTqeX11Jua0Mq3l?=
 =?us-ascii?Q?SF00RlxyPA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee62a61-5721-4ba4-1d00-08da4f852490
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:44:09.1358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YafhpbCe5xYsRN2oa1e4mVVpo4lQ8IETvWe4j7bHWfwVvkkFUzXAcZrDtEfDfHcqW6bk2VHe/20zfJCNb3y2Uw==
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

Sometimes the scale test depends on more than one resource. In particular,
a following patch will add a RIF counter scale test, which depends on the
number of RIF counters that can be bound, and also on the number of RIFs
that can be created.

When the test is limited by the auxiliary resource and not by the primary
one, there's no point trying to run the overflow test, because it would be
testing exhaustion of the wrong resource.

To support this use case, when the $test_get_target yields 0, skip the test
instead.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh | 5 +++++
 .../selftests/drivers/net/mlxsw/spectrum/resource_scale.sh   | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index 6d7814ba3c03..afe17b108b46 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -36,6 +36,11 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 	for should_fail in 0 1; do
 		RET=0
 		target=$(${current_test}_get_target "$should_fail")
+		if ((target == 0)); then
+			log_test_skip "'$current_test' should_fail=$should_fail test"
+			continue
+		fi
+
 		${current_test}_setup_prepare
 		setup_wait $num_netifs
 		# Update target in case occupancy of a certain resource changed
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index a1bc93b966ae..c0da22cd7d20 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -41,6 +41,10 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 		for should_fail in 0 1; do
 			RET=0
 			target=$(${current_test}_get_target "$should_fail")
+			if ((target == 0)); then
+				log_test_skip "'$current_test' [$profile] should_fail=$should_fail test"
+				continue
+			fi
 			${current_test}_setup_prepare
 			setup_wait $num_netifs
 			# Update target in case occupancy of a certain resource
-- 
2.36.1

