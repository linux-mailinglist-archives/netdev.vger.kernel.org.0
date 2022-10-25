Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8247360C982
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiJYKJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiJYKI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:08:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E31220C8
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:02:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGYT1Kj+mIM1Zy0auu4wMwot9C7gBqbnhq78pvgxZR3eTos6OWBTTasSmh8P+nSPdae8iHO7YnpUsu1E2SBnygLa2gW21KmdDjq7TAfHIZPD7w2LDtt6VkMsK00QDEd5bYOgia1i8S4DY+/XoutYZjSrzUb80LTMxp5IcAt+mk5wOKwbmni9G1a5eD/OAxD3B85kY+QkUWmz/304SA1PuVi6V+W3sQvf6fJXknoo9zc0d6mrhU3lFWsu8UbiO3bArGhS7OSFdlPI+Dsz9SSZGBDJlpRv5z7bFnqIzLkZXkla1rCorEHn3hN0z1zL/8CyAhIMbcSgwo2lAO1bgTheCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bh8zoFLiQpl4kt2kIepqZ27r6waWEN2Vat6/G8zbY0g=;
 b=T7XLX8AIxa4LZdDqPy33mSk0pXGS8rHmgcY/hmWwsaKe0Bo/egWDurPlpTAuFum0I0BpJG+vNrCvCmahcH9Zdfa3w5sulWaJK27fJrmBzpvr/HeJfSD6dkGvWcNihOTpstvmOWQoGKoGpGG19JBupiWEfleh+ELmYgzo4r96Iu7dJ0ODWcvcesNW5stYSsYPCo5T/lHzhZfT+QBg3USMcCWgOPlQXy439KLE53omgA4RUG4/ereif6V8Bjspv4JDkR5D2ai56CHlMnUGgwThpIH+YOqqDi4bJ+ecDI4WRi89ls7nI++scl2YCRf7hpqhQj8sVh1sIv737Lq1c8vG0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bh8zoFLiQpl4kt2kIepqZ27r6waWEN2Vat6/G8zbY0g=;
 b=K0NH/Suut3kx9Yon5195iuyr2knC57NOtD3D6WDq7zxBKEfWMcx2ABxvWi9KPpyzHm9TBpJjk6ogDIC26W4IrHKYMRdLYIOONCAsJTaPQz82Om5Qw5sOPHb7h5qWYOFb52hhlo+/Wa0EhvseH7E97RyW6p1dhi+0rMq4ZGw49LOsukQyuEM0GxGrf4853UyzHXaJUa2A3BErTg135RbzUuU9T08/u9VMmzRXRLHwKa/gGL5zcY8AMKelJEjuzwWgvvaYOk0nIqMVSqx4vw0djHKavNW5QRhhIoDLokf9uPFs8Mfk253jcZsZOKZ0FFaI8BvB8WZUUBZtQ9oXOayZLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:02:20 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:02:20 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 13/16] selftests: devlink_lib: Split out helper
Date:   Tue, 25 Oct 2022 13:00:21 +0300
Message-Id: <20221025100024.1287157-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0229.eurprd08.prod.outlook.com
 (2603:10a6:802:15::38) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: 48aa8452-404b-4cfc-3a86-08dab670015d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6K6Osi6HcSxaQNtO5WCyPc11xgYZNxg+8PhcEVIctZ6pA3moBq5Xz6QC7b+99u0Iv/dYdtnRkWJoOiR3/JP0wJj4HvQW+5fy9uSivU+CGMUoD39vXjh+myuXkQHoImH9dWS/qnOWKB0oHD64jppPFkd6k6RFwFtbGSdbrRwvVpHhybj3WVqfpBBtajr/xAlc1C8E68LC7gqzUSHYXXIs5QoJCK5ZsiLezTIkeAG7KGkf6GER6PivobujQzgu/f9xlXHbLCHBzVlGrxW5Zk4OMwvbGTbs7MOQLhUFkJDDx0EFmajRTnLRC8gvouLHO212LkmKVwSpP895CjIFABBqPT/d2H5B+XHBza5IoI266+j1xI5G/Rg4GxHQ9QyMI0ZrZcjjm+q1ODr/fhpTbbSW7YL5kEfIbIz/UqMcvO+Z0WmQfCtYSdtIFRAUylbJo9147rDS9bUEQnKwbM2NGwsL2xG/mRdhyD2iJcn5yvh43ooArhc3bPfQcT4re3fwSga/ok7rBvrhNkUkiA4CTp55DGgtZzJkeErJ9qP1PuA3ouh+66G73UddsOWnrmPM3zGSALzOsgAD7nFkwNu+yxCn+tgwz9CzMsuyJyElpKPqQE6gF2m3SV0myB1ieip+7sXrkdFBIUo5Xetc6tobP9ZDWrRIAK8EqL8gKsvxOwt2Um3gAkujD7vr7OscP6Ne7KQsx0CefXA4/tuYli3we9fYzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(36756003)(5660300002)(66476007)(66556008)(66946007)(7416002)(38100700002)(8936002)(83380400001)(86362001)(316002)(186003)(2616005)(1076003)(26005)(6512007)(6486002)(478600001)(2906002)(8676002)(41300700001)(4326008)(6506007)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UDvlo2M5L0rNWvdIAhSumsaFRahasApj7ihBXfDZJDorWs/1PB2fOof/bHNO?=
 =?us-ascii?Q?8oUsHavRiOHGiw3IENXj1RFICIn2IDWOvOqYOwbq0gD0QjNzjeIGtJq5t6mQ?=
 =?us-ascii?Q?tboNItFd9NjFP9XxumhCPfOw2QEAygG80CAinXo7MKKyKsehCX/3Pzy0FJkg?=
 =?us-ascii?Q?Ao8b2V5ODEmuXLealeLabXKob0a25MA1ZRzj1zzA95TlTCTJEOQGFssz5JB8?=
 =?us-ascii?Q?L6YMKGLALhTg+EnlDMiEVtQAJcmxG75cnfMiNvv9lR21RWKuHhy+/2elQUUK?=
 =?us-ascii?Q?d70WBqfQnBOYSHL/QvzxhIIok6P7BdntowhsJEKqqhFBVoxmIugUDCAZshfK?=
 =?us-ascii?Q?9pOhHwCrr6q8PzfUfh5AnN3+k0H2t3MueVCsjeGCXNTmkUuvMO2twIRXrNU/?=
 =?us-ascii?Q?bBOkOFZIZEekD/PTypXdM6MJbgHaR6xEqpuAdjNCLobV/JFS8n95qd4cCA+N?=
 =?us-ascii?Q?6nFmmix+VA8yJowdCpXK7XRM3qnHOfdhjOGfu5J/ljbreb50prFU6Z85i2+S?=
 =?us-ascii?Q?TXocFbApA6z9TiPphxcvi187JhCPnJuwTEgUojwx3LLS8Dp5JKPS5TRgzujl?=
 =?us-ascii?Q?IKn4ylNcInnhTZ33zvHkrr7JObcISI8t8SyEgWSe8+W/9Odn5k9GeOCOZz0N?=
 =?us-ascii?Q?CoGArn3rYj/mtKtkejKvC9riQ5HSk5F8rtdbhlQyH9W9kCzUpZvmD/UJWoS1?=
 =?us-ascii?Q?M+3bfQSiFsyPjrcOCUxc9sIRwtIifh/zr1dtWTbK174UOpDUUSpkVMipZV7n?=
 =?us-ascii?Q?zO6y3IehiYYdTsaLYnVkmWqGOl8XmT5yyMiIGPqahOmaAGT64J6Vb5MPOaFv?=
 =?us-ascii?Q?kOCbqUXhpmhMHGxstrZCqPoEUiO7BlGRRTouXoRSHokKmjAMbts2GlI2vWg6?=
 =?us-ascii?Q?EAUqbT5PqRJKzVKbBWux6AB7D6Q6FPOBdndnc65RrPv39LWg2OpPEBy91Ayd?=
 =?us-ascii?Q?8Hp0VBeEYjoIukH4+BJwmA8YM/Q1rW13LMPhegk1E+UG3soHfkCH8U/gbn2g?=
 =?us-ascii?Q?1vO+ZUV5pu21XOJaL8VZa6oECy/Qac832WqhRk3c3e+2LmGJpuFOhL4PCXTm?=
 =?us-ascii?Q?E5zswd146aDlC89awyAOM2bp+XDecvd8GiVjYSWd34TLzDBNNngKJJjCdcB+?=
 =?us-ascii?Q?HnguevaMJtAMB1uv76DbkklowMsyop1P0VAAGFN7vb3H3qavMvxfFEi1wPz/?=
 =?us-ascii?Q?9XnDr6aD15ME1ejDzt9+HbXaspjhh242DpiHngQn+K3exuAUNQDTX4bC2wkm?=
 =?us-ascii?Q?ybUzhaEgb+9zE7NwWXwjwKHtmcyDGX9XHq42isN4omFYLFd8UIrqB4SKTXzh?=
 =?us-ascii?Q?J6tL3Wbb4suIbqCBwtjVdcy8X8NiVkDt/MAhehsXVa4wWypEXdT6smt1xhtd?=
 =?us-ascii?Q?EgnKeKg7e8DFbL8NkL1gy4XZFSN/tbUx38As273w8gf+ySu3t/HmVH/TNdRY?=
 =?us-ascii?Q?tmliFDadCF9IlKjYOQ6qRC4h8EngmfDRCmptM608Qx5D5aTr8YDMVjBKRyFG?=
 =?us-ascii?Q?fqe8IQEk+uIcSro6s67ywZRRTJ8+kbQBR0I1elI4YlIBvsl5jkGuxyo2sp4Y?=
 =?us-ascii?Q?1kJ05hwJXbgL+cKQTm9VWaIx1IbDfM0HG78y4+Tz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48aa8452-404b-4cfc-3a86-08dab670015d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:02:20.2919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cy/OBhSunITrD5slRrgS0DiJlPFEt/ghx0pyPjLrPkgh0n7Br0Yn4oyiVAFNbYGZrifrR5aovCRDesTCZDXtWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merely checking whether a trap counter incremented or not without
logging a test result is useful on its own. Split this functionality to
a helper which will be used by subsequent patches.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/devlink_lib.sh   | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 601990c6881b..f1de525cfa55 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -503,25 +503,30 @@ devlink_trap_drop_cleanup()
 	tc filter del dev $dev egress protocol $proto pref $pref handle $handle flower
 }
 
-devlink_trap_stats_test()
+devlink_trap_stats_check()
 {
-	local test_name=$1; shift
 	local trap_name=$1; shift
 	local send_one="$@"
 	local t0_packets
 	local t1_packets
 
-	RET=0
-
 	t0_packets=$(devlink_trap_rx_packets_get $trap_name)
 
 	$send_one && sleep 1
 
 	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
 
-	if [[ $t1_packets -eq $t0_packets ]]; then
-		check_err 1 "Trap stats did not increase"
-	fi
+	[[ $t1_packets -ne $t0_packets ]]
+}
+
+devlink_trap_stats_test()
+{
+	local test_name=$1; shift
+
+	RET=0
+
+	devlink_trap_stats_check "$@"
+	check_err $? "Trap stats did not increase"
 
 	log_test "$test_name"
 }
-- 
2.37.3

