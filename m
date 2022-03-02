Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7214CA9F0
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241417AbiCBQQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241385AbiCBQQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:16:07 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88BBCD316
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:15:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvgFFyKhMl4xv2eRl81WmcTHKtVdfe5YfQ5Uu6qRECRGLJKZxNvxMq4tKEY+9AmbYXGx/+5Z1mf23Ljgfic+rqOs6ak/MACzinrgnvCkKAMU9oAVQmjqAwL+CVf/wBhn4sU0FsT6iNq0bpuFdZZ7Jo9QdcCwtOeuS+cXeEm3THqLjZH0GtRLIWzxPe3c9YvJUGDKok2UupIUi/o2PZZlkdBEM5yNsJFx7kgNl6Y8u6EHYOnBNg8Gdupfu9RpaFrP9fMDBiqR0XT1+rQwI195/iwNWyvEU1DeFVv/LDZyAUlYTGXytHlKJviyNCPriz+OUYj2Le+0umFhp898XbcZqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nDyx7Y5HtudQMcTTfA6BQvAtYkFx8FdMRmbiXCh9evw=;
 b=FToITTXg8takupE9Y9ge4ytFtDZ6LICVp8LNTWQfOTfrPCIIIXlIVqfxc+InHu/AFCklHdieGlJTzZva8Okl7EwvesE/HatC5gsUnAHYCU0OgePFXiUeevJpHiEvv+EgoIKvxxDJ+P3FuNn1f+/z8TUzo7nOJeV53hKyX+5STtnzmerqJv3o/KffUpn0ZRLhQ6h12e3hneCLrNQ1xzXnY2Z6DCgGKg3X/oTBCVO5KmRJA0DDiwTglQ0vwZ199qmOL4ijnKyjtkpr19hQOzUJJGHGBUAzikfBpwWQsdSk6JTVXlYw0LlvgOnjFMD2hpZYRkK8P249yw3FT3MQacnS4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDyx7Y5HtudQMcTTfA6BQvAtYkFx8FdMRmbiXCh9evw=;
 b=OiIAe9ZWL3/aQjHk25ua0YtxOqarDrsoO+zFPN+3fDTHU1TcAwmNLQjWna1RXPj1eXRuRDcFiXUXzm243BQ9gqzux4DE1n+8z8f+CvsP6fdleQONq7u2PdS+nqY9QBVpq2ptKP6d5msWeGf4vdDefhQoVsLhB7rnIG+Z8p4j9ftvtilELeHQLj8OTcJ9enD2T0e368S7VcoSJGd3vLWes/pKsFLz93bol+7cjLvEDi+t1WEhuaffmLjAX3zQyn+9gcrny4YKYcpiF2sbVzp3tlMsICdn+LLAHgSQ5a1cFVFkzXpQuY2+GxiUnkduY7O38ajdPKBYOnEAwp+CdnF8PQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM4PR12MB5136.namprd12.prod.outlook.com (2603:10b6:5:393::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 16:15:23 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:15:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] selftests: mlxsw: tc_police_scale: Make test more robust
Date:   Wed,  2 Mar 2022 18:14:46 +0200
Message-Id: <20220302161447.217447-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302161447.217447-1-idosch@nvidia.com>
References: <20220302161447.217447-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0203.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::24) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 243b4fb9-38d1-4e1d-7c03-08d9fc67da94
X-MS-TrafficTypeDiagnostic: DM4PR12MB5136:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB513681E06478770FD1C818C2B2039@DM4PR12MB5136.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ai+ajiHlZsXoJ7cEmZ8BuFtTQBuAMRDEWrB7wgVAbgrPvhTsC3eUm6eZJSq3TwG8LsxYJMS7/1tFNr6ehSlBr8cmvTQezcG4wFKrZgYOh0BHEWnVYqaT4GbMjz/M7MyL8ssaXTdk0iBoqFK6gFlJZZEVDET59AMQ7Fa/5gbq6Os/79a/dsuvA7MtzKyb5cE8s+S2KhN7y4ZZ5jBE0dI1h+/iB59Bw6BKrBd5qQ3MwJzCIC+I6/3G61wSM1BorVTFntDvFSeU6wbeTDDJkfwxmhOp05s8BeeSMRPcoNopamY39k93t+7xXqEjSaWSCcbf/fKjILAIHpyt90XvZIVOPyxCat6JKmJKD2osfDwSKc3XApxG9LYse+nF1OU/OGevsUvYpNe5QqdKUgmi7SPipA337X/FyifYea34gvrInSLW91aIeZyopZyt5mtaOGKc31CTY97M7HNGHDzBWm83cJw8qq9Fi+vQVHv/xdV+C/6Hiu8kuUFrJ39c6smOOnNzlVk02xNkS94rRPEp4S9fATZ2olc7fasku5qn1Jw1pxeSn+bM98tsDeOyHla3UCb1nP3JDhzlOJ9K2E4pcnR8d9WqHtUj8b+222OqLIcx7lxNDs8/Np+YA9IDuuaYum5Vak2Id6SnPXdlyAmk42SQUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(107886003)(6506007)(38100700002)(36756003)(6916009)(186003)(2906002)(6512007)(5660300002)(26005)(6666004)(8936002)(1076003)(2616005)(316002)(508600001)(6486002)(4326008)(86362001)(8676002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZbOdxwwf4wGCvfV72rU6Q8viS14tutyWL5uvopwWmgpv+zl5gX+J/9NeP47o?=
 =?us-ascii?Q?WP8L92i92RZkgPdQ5RomSHhtJHFS5bfUbEzwq6O619Gi/eKtwEgssDOBmHeR?=
 =?us-ascii?Q?18ZU62kpUou/TjWZsVnqPcsQfptQJbMf4YD/7m4FG6Pk7IGoFX4NAJbjy5nJ?=
 =?us-ascii?Q?WWjCwDjQC4VoHvwvncsTJm3gFvPci99PrllmtLVN72WRC8mGu8McRIGvfJkD?=
 =?us-ascii?Q?WVzCQSMMJV2MnfMP35S0136B4xY4bsu5zNL5dvxe+XNYkUAWLE6T/xzVcYNm?=
 =?us-ascii?Q?DPD3jP9dBSOw2lnDtPxAtEVTolqaUrOaaYdrY/ajegHmP7NEFy7KHmU0XnqH?=
 =?us-ascii?Q?3qiEy8szpTVg16JN6T5Fga5+z9PJpxjahsgYQU6MjjEBqBYirGT+dDYkb2gv?=
 =?us-ascii?Q?ZHjMSicLTjmv+2WWJVJqdTJOKJR8w36dMv2a4QU4wfkxGdE9zC0n9dBa6/Tq?=
 =?us-ascii?Q?MEzEe6V7EVo70YRi12hwkWi/rzpDPJaC9mE1yInkY7k4psG55OW4KQoWNFKS?=
 =?us-ascii?Q?ZvKb1SlSQm5OF1elbgz90ns3TMfMnpUt0brUqYLWQcJLVK5ukDgr2hcslrrG?=
 =?us-ascii?Q?d/iTbNNUsP3/FDMln+JrMWfDb1J8HRK4E0Gv9+It+Dm79uf+bP13cHdraCAM?=
 =?us-ascii?Q?vi0yt7y1aEJmYGOe1uXpd49NXXP2HiqwF/KZqjHw20LBSuqY9cyHElupOMjW?=
 =?us-ascii?Q?NxI6vjvvWynmFisyrZ8kGpGSByO667d3P9PyZqnM2aVx0sJQL5YzSEoobzeK?=
 =?us-ascii?Q?Gxyv7E1adwtysYR32JWyDtbLKtZe43c7r5SpfsqHYnXnC0JjLMSSeWaWSl/a?=
 =?us-ascii?Q?WhQdHIaen+NYl+E9A7guWhom5eHkNNe4RNsip0LO+TcfrG5aIDy+8H56YiXo?=
 =?us-ascii?Q?fbCmCZdoxjOWpGcshgRXoW9eyYXRLdTfgtmzbCoUM4drnfm6MdVCPKHMRh6l?=
 =?us-ascii?Q?yObJUcVJAKBjD+jD1MDV4vGhqTOPGn3AzMwng5iX7yqncZxTh7Er0enDLJKP?=
 =?us-ascii?Q?jYR1idDLTMxrdYLINFWO1UOm6kT2jSSgzOpV3KCIyTFzcLyTlWKW5NUNY428?=
 =?us-ascii?Q?EkIL/7ajfK21+uPoyivFsBk0knqN+i84aQP0IIq5Vb6GH3S5g0gcRbCNlfUG?=
 =?us-ascii?Q?j4SjudGPVwW8m9hLYilkvBXyJmltMKGvYqz2e8Ruiouz5yKFB5U1IV+pwCmX?=
 =?us-ascii?Q?CLHrk67p8ywvzGovqq9w+Y/yKnDnR61o8hk49YKbLIWfEUrKWx90QfgxAiFI?=
 =?us-ascii?Q?6XkyqiRJrE/0x+guUJ+iTiuZ7He+aAEm3Cz/jOxqC6qmGi/BwZDekjkS9sHw?=
 =?us-ascii?Q?L57stfADFIHIY9jN88Uw0ACC+glbJZF/58mrnFYG19Pc9vz082SqXkMXm1P2?=
 =?us-ascii?Q?G16IcUnjE5fjZcuuQ4/pb0DeenXC/mnXAvIkDKbJ8vGm30iFTZYwyUxAiXKt?=
 =?us-ascii?Q?FzNHG0xgUwBmkoroYw5s9Le/h13kWAsNCi6vjggQaa0WoUyY0TSKR8xwtxra?=
 =?us-ascii?Q?Xx0G/WIDr57W9cFwPzKpvEa0UGFsaH1neKSGN4FnGL49mJ5+YfXwOHwtJ6nQ?=
 =?us-ascii?Q?N3v+xEx115wk4HteIQluR/wa4PodWua6UibjoZ88SikIXhki6ugDgne3pGBc?=
 =?us-ascii?Q?bTRt/Rog+mlKoFeh3GMRw+c=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 243b4fb9-38d1-4e1d-7c03-08d9fc67da94
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:15:22.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJeI6BkJIlSEnkHCB3BuIH6mCx/HUsAFV33TenWDkgzTIp4TPYOvb2N5D7AcuKwxRY5QLQcCTxAKoavM6XaN3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5136
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The test adds tc filters and checks how many of them were offloaded by
grepping for 'in_hw'.

iproute2 commit f4cd4f127047 ("tc: add skip_hw and skip_sw to control
action offload") added offload indication to tc actions, producing the
following output:

 $ tc filter show dev swp2 ingress
 ...
 filter protocol ipv6 pref 1000 flower chain 0 handle 0x7c0
   eth_type ipv6
   dst_ip 2001:db8:1::7bf
   skip_sw
   in_hw in_hw_count 1
         action order 1:  police 0x7c0 rate 10Mbit burst 100Kb mtu 2Kb action drop overhead 0b
         ref 1 bind 1
         not_in_hw
         used_hw_stats immediate

The current grep expression matches on both 'in_hw' and 'not_in_hw',
resulting in incorrect results.

Fix that by using JSON output instead.

Fixes: 5061e773264b ("selftests: mlxsw: Add scale test for tc-police")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
index 3e3e06ea5703..86e787895f78 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
@@ -60,7 +60,8 @@ __tc_police_test()
 
 	tc_police_rules_create $count $should_fail
 
-	offload_count=$(tc filter show dev $swp1 ingress | grep in_hw | wc -l)
+	offload_count=$(tc -j filter show dev $swp1 ingress |
+			jq "[.[] | select(.options.in_hw == true)] | length")
 	((offload_count == count))
 	check_err_fail $should_fail $? "tc police offload count"
 }
-- 
2.33.1

