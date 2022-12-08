Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4664730F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiLHPbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiLHPah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:30:37 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E517E424
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:30:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mq+U6EU26m093p9Hqbk9PdSw83xBggz1EleLQRiu3wjN/VOeop0r5EZaO64WRrBocfgffnPQvKFqlVzy+uhGcfuhCyKSJszomoWKOiaknTq39Gy/u1fsfZvfU4x8hI1ImOCLv5dAX6xP2I0A1jYc2IxTS6s0up0s7BT/Y6zafmlz1Io2DW+ZZvD1MamsLe+JbCuKzccx5bR6h/fef4UdjVq/ueGc7vDnk/FY8dLgIJInH3qPrgCmL9/IJrfp5GyhSYqRYvnddaIKCxeW9I/9pQ8EmKuhvLNauv0v/n0yAnejkEmSgdF2ToDXQJ4qoZJS+ATr57SgEwIi+LnW85cd6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNmsK5IkkASjagA6QjdaAqEuxMxVK4sv+e6YBuGv4SA=;
 b=DBk4+rUFCxNAP/ADN5BSSO6GE9nFiHyFByBAl/Z3eL3C1dr9ksj8HDBxFEnsxg8OtHWzhACQNhSfon4qSf59aIMd61sgLlo2bpJ3Fj6Yh2qv2/Vty1+q6G7Dxy6ZWDDzWVH9NY+SCoL2R+ffc+nzSqunicgEnyC+3qkOV1xGMbP5PIRcNH+omxVYbgFdD2scZ1xtpYG858Qv0IvRDU2w9ujO3Kgwezn62/IQ9T15q58HRz02i0falnJHR6X9jLPcJ3zuZaPmn4+YSylzFCj2xn/1VAhgNYbQruFt88mgCU1wDxdj2D8Qj5cNBM3rkYvcsJ4yuJ06gsvs/acDr14PYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNmsK5IkkASjagA6QjdaAqEuxMxVK4sv+e6YBuGv4SA=;
 b=IeWbtCqA020HrWrrjgf/T/Jm/xI8sWGpA5A8zgspsKp46tUXjGrwcj/EOGImQjVOZccj//pFuxIc+Z2Y2vlShz5dxlxRTGejqupg2djb+YxAqLa+6QEXsK3TG50EjmhCsYxFpaUk5FQIB5Zzl1l4lZ0GUrXKHFq1AVP/wsLsNZUc1H0YHa6qMXeEDfMgONW9bdbM7uU+4e0LGqc7+BBXB8Ags53wJQIT8z7QCu09YwbmltfNXckysC1N8L4fJFwL6wYYXcdUxZppoD3fffma2mPtlvuYXVtX7rCHrZvw82c+O3ONw0jQvgIsmbFot3dOadnTAHNiO5eiOagl+d+/+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW4PR12MB7216.namprd12.prod.outlook.com (2603:10b6:303:226::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 15:30:28 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:30:28 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/14] selftests: forwarding: Rename bridge_mdb test
Date:   Thu,  8 Dec 2022 17:28:38 +0200
Message-Id: <20221208152839.1016350-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221208152839.1016350-1-idosch@nvidia.com>
References: <20221208152839.1016350-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0218.eurprd07.prod.outlook.com
 (2603:10a6:802:58::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW4PR12MB7216:EE_
X-MS-Office365-Filtering-Correlation-Id: a641092d-0df8-498b-2016-08dad93121d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GVTVFCL2Kx1LUj8X+OuWeKFQAQGt09NCismwNuRSF9ERMvegaQiuPboik+9VALsK7mq8hmYHIvfJNIWgQyV4CvXgp95Inc4bk/rZ3r/HzWIqUcAGqxTWId3MTbD05nKOflW8ZSQ58u1cfm/RuJNjH0H2TNjl8LvCvEZGYB52vsBpBZSm+vbQRuS1w3qa1vsFVpfuvlkEivT4N5VndGmKLw/uBXXhv6svbmCQSRIfbC4wZuwwwd35z9DEB90gHYt+xpSz1MxzW6X66qjB116//KUD3s2pfCzSg7SE6k3a9fy2PpNV/rCWip1YuCAGUyov6j6OpSs3XdN+zso6ztjAlqG3Kw7fwnx/1Tt/GQYdDq9BxiKFmAheGm78awqKMfhed0WV3c2wylHTg5At5R0+7hDODsHV7vCLYqJ5QUVHR7FEDHxc102A8x+vyx8HM7tJxcvPfzGO7jrNhWZjgaeONDs+bxo+4Hi3g6syhSDxlKIp1oq2G5Ha9R9fiJKwZwybpoUaETYuPfbh23/x8iC6hm1P4bx7JQz/51si1vPPRlpHeR3sFVRUPqWYeBWBiOYzcScuyLEMCLfq1ID+2BXIswNboNHBWGH9YBKnG96ac/QRImh+Zf+peij3Q+hmNsNXlTvytggUkbyA+I+GH9JYsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199015)(66946007)(66476007)(66556008)(8676002)(4326008)(38100700002)(6666004)(107886003)(478600001)(6486002)(86362001)(2906002)(186003)(6512007)(26005)(6506007)(83380400001)(36756003)(8936002)(41300700001)(5660300002)(2616005)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KVd10qVsjSxb0Pob4F6fSRzmwlj/WIajta/9+RY45qtLwEjcMqTqrfvddPSF?=
 =?us-ascii?Q?lvAWWDEZtCWk54HDMSf7EumMz5etyk9CKaSfcaX5ov+CJePj2INkzy2z+A2i?=
 =?us-ascii?Q?MJzbh+jC7S0hIMzoRtehdgVJBRrAm/pik+BwoK1RHLpBNW3y6i8KYaTuI818?=
 =?us-ascii?Q?rnrUcuSzM97EeegfPGxcERb7783oSI31xEX/NZ/bTQYVhZK5QAMTFGSXwyYP?=
 =?us-ascii?Q?ssTgt8uj8z+JuZW7fUSQUd9zn2Iiz2bQUHQcOzU/38KucGbEXvjUem27eFdQ?=
 =?us-ascii?Q?NDEWFr33OWqNrDhdkraHO+KwMcVS+uDv2pzOIW4/T3apNcnpN8KGJUZz6j0c?=
 =?us-ascii?Q?4OG69Ac5U/sMamiKX6ST4V8HYZWQLZ5lnyyRyDQYqC3MFySS1iSAA2m/N5kP?=
 =?us-ascii?Q?ejcwkQ3/CutEBHHx0+x0CMdyXKbzdkbfGqmSV3rtpNTTFFEWaSoBWqdjC+AC?=
 =?us-ascii?Q?yzp5EFO1qOLgjdFY8jnOvikMQ4MB0N0hS/jivQz32lxa9Sf73oYlINRnLsqL?=
 =?us-ascii?Q?W3e8rV4RdS7Hs5QQMacUok6Td6P3HFKvQ4XvP4hH6bh3FXLRKDakAwcn4Vdr?=
 =?us-ascii?Q?QLFkykX1uGsoFCSspO53lPmHq6xwnX7ylHb6WE8DMkULM8yKkKrkCQn/hQwh?=
 =?us-ascii?Q?U7glccrXoRZj+s4Fvue0kIhJOAsZ+bxRswgq9qtPgYiAnRF9B5OAqK4/yFNr?=
 =?us-ascii?Q?NhrcY9NcHaApq5oa/HKR8inG3kv5kDT5chHjlMVDpIgA4DA8hHCR+RxyguUc?=
 =?us-ascii?Q?reY/Zq5e3jHU7NwU2EfWv6j//EmKySF0BQuLWO6aDds4EdfLWXN9bGdi9yV7?=
 =?us-ascii?Q?p48Uf3iWkYqNJlQt8TTbjshj1TKRv/1JjEvmgc0Ga7RnMCVhbZ+EIX/son6M?=
 =?us-ascii?Q?+RyNu4xtCMnRlLqKxZwoFRuQWYW1A2m4yakrPiraXB2tjGlOom2svDa5QWaK?=
 =?us-ascii?Q?hQMuH93O5FvatQWvxveij5ZTN6bTxOn3QNTKo/l0JqyzCEPqwMxA5+SHp0Wz?=
 =?us-ascii?Q?GYl8skPt9MoQGMFi5C23/94nN2dRFEr3oaqzWdNhx7UuN9kk82hlEF3P0ai5?=
 =?us-ascii?Q?4732tckFU/D5GvvhvFLMk0TGTbq+dK8bbmsJlMLJ3TDDOHd8EFYUBuLmexk3?=
 =?us-ascii?Q?QLXYPbODqQ4Lh5AjFCWEw3aUKdt+MH1jPjhg5BjyTBqg5tw5pZbya9gToW88?=
 =?us-ascii?Q?UfAcq/1jQDLxPCm6lsXprWxWGSdr+ius3+amiJGP7uTWIgEkRNaV5Ky/KHAb?=
 =?us-ascii?Q?UcfmpPaCYK6XqSafsv6pNxfZDLw6RJ5g8ft4wvnNNgrS+hmal+Zb4EkhQyFu?=
 =?us-ascii?Q?3Q+G0PBWErjWiO5Nl+Zp2o5JzV+o0RGvItRUHCIQEJOxAjLapXnndF8abnhS?=
 =?us-ascii?Q?IWKFilHlmukVaLHCPclUa0ONudivoByTkvJZehPCZcmS38x8gYLExYyz375G?=
 =?us-ascii?Q?dG5mhdVbaXmvp9FsijQMs0/Z3EOOjLs0kJchK+jhdL4sC/NyITDQCnyLmcaH?=
 =?us-ascii?Q?p2LQblVsdeRKVR9omdFm/DWLoiyiclhHbraiG+x6yxWOjLQOrp5x0O7QBRtN?=
 =?us-ascii?Q?SBN10O6mXrJYMx+Ql5f4yqyfBV1ih68j57y+jjcN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a641092d-0df8-498b-2016-08dad93121d0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:30:28.3550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtT4mD+Bab/F/pvBIV4/rD4VT1urQV5LHnmYnXkYMfBOc6XuV9al/JNVsP3HZipYjKX6YsqwTSVc4ySGm0wWqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7216
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test is only concerned with host MDB entries and not with MDB
entries as a whole. Rename the test to reflect that.

Subsequent patches will add a more general test that will contain the
test cases for host MDB entries and remove the current test.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/forwarding/Makefile                 | 2 +-
 .../net/forwarding/{bridge_mdb.sh => bridge_mdb_host.sh}        | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/net/forwarding/{bridge_mdb.sh => bridge_mdb_host.sh} (100%)

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index a9c5c1be5088..f2df81ca3179 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -2,7 +2,7 @@
 
 TEST_PROGS = bridge_igmp.sh \
 	bridge_locked_port.sh \
-	bridge_mdb.sh \
+	bridge_mdb_host.sh \
 	bridge_mdb_port_down.sh \
 	bridge_mld.sh \
 	bridge_port_isolation.sh \
diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb_host.sh
similarity index 100%
rename from tools/testing/selftests/net/forwarding/bridge_mdb.sh
rename to tools/testing/selftests/net/forwarding/bridge_mdb_host.sh
-- 
2.37.3

