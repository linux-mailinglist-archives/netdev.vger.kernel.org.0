Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C711051975B
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344197AbiEDGda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245755AbiEDGd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:33:28 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ABA1FCF8
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:29:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9zl93RG6mDqeWZPleP/6fCGd3xqfxQEYcUUo3M7UWfsWc7VrCX4viptziKR2OyHaou3rfcFI35WgNSWB11m4/LUbq8ob4lCe/f/qOvyLF06Mk4bxtH6E8zN2/sDzbwRobvFMCDsegL/lyOdfc6LNNwfCsdHA6OmogON+iueV4haiauV2ac82X4t4OrdMNxNSmiOsqsDOp8B/akmSHbxSb19ojqVtEeG1GXHPIpClaoyKiBG46BXgrGU+5DLxdsHT1uop01RRK5AZPAna2unI8kOO46SljoNupBqQqmLdHSvbssDr/PtoxF6kHBhBn4ItGra7vB1CTFMhrBozrstMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8aRSyNuVjWBY2CvZ7DwsJOnW1mwX8xp79sjXfoEYb0I=;
 b=Zd0RX+8XdQ4Zu5uTunG0vxUTrZa6a1SKXnt+Sj/vbKLcrocggZ6SKxqs8uARKedVny3xJMa3ktEAHz20420mhBtbjb9lnx81ciXusf2hY0bN9Br6MhUNw4ChIyRVynWCEu7MWdgMG8kVU/Jgrbk9KRccGgyu1mLjpM2cM/KOM3m9+PzRyTMElBgFwaRFLt9krjxrXb6kw+GqKyNCMY/JzM55GDV0Z/BR5Z8eebl/+B4qItcNRE+ok1UxJdEYXqIL3zveqjc3HChF03KKuH2KA1cjxwGuV8CFdtqj0xIi9ianJULNZqloteMVArTqn0IPbamvEPGpaX3hw8yPDBDgkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8aRSyNuVjWBY2CvZ7DwsJOnW1mwX8xp79sjXfoEYb0I=;
 b=c/VROVtSeArMAEyOJw92OvRPjZ6+HgE9uY/9W+bIYTZ4Z3NJkzs//v3z9FhWAIGIhDpUSHK+0ZJVG+FqtjXSnFUxGVA6Hs9KO523yHFClZohHvr2VkWoduc0E2vcrwyctUfj4WUn5DimYDHa7KZrRjXJtwJhLr8lWoP7C9I5GSTVs29Z+zkjcTAIL1FGdx38YVhvDuJpjswawKvDg8SXsIMoxlDUvgcDj6rBmRQvc2JTVpMQyhI72WB4pL1u0WXo/E1I+aaT3mBD84xhyJ/Jxz/Jirc1bpmcOqyRHowrVNWOkfEWsWwv1Z3R0/c8oQZ8AoSnmSGzL/D2f456PpG8wg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB4745.namprd12.prod.outlook.com (2603:10b6:5:7b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 06:29:52 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:29:52 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] selftests: mlxsw: bail_on_lldpad before installing the cleanup trap
Date:   Wed,  4 May 2022 09:29:02 +0300
Message-Id: <20220504062909.536194-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504062909.536194-1-idosch@nvidia.com>
References: <20220504062909.536194-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0088.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::17) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76d4de01-3b82-436e-3833-08da2d977f34
X-MS-TrafficTypeDiagnostic: DM6PR12MB4745:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4745E39EEB42D413D27D401EB2C39@DM6PR12MB4745.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPof2qlOOdxI6wRJPPK/WS2d0zMOds/jTpeNBOE4NTSqBNetIraM14OyBB279GvN/0QzxPcfqQQDxuQktgilI3xecOBM9nnqGu62LSEbQimei1Hb55LABB9LyGNJ8lvhpGQCpMpqg9EW4wmImo9aBFFF9OCJw3RQn/sk7vCzMJ0ARjWi4ClYt8/ZDq+NOvmwrAP743OE28yLwpIRf+5G4vm0SxpYgXZk8L1Elxo8ig2b4mVgYLa2VO3D4jYA6M2SkUFDvTY1NtnGmcRbuViSJwMxxSdxwssgrOLOaHuu4ago63muJQdUETNHm9OsfcPddPFY7tAEKRlgL/nvV8zLTX1Lt6Ci37GForTfJB0AeAnA9CAvy9dO5etGSvLEOCMMqvJpbkVbiy7JFuhCLADq6ZU7ri66ACE0Ny2WpZIXsdG1ZQlba2DIn3YEAhI7UA2zgoSWCe5uLvyayyg7uMYBXlLxAFYLVFe7sjyRPAP0tz0X5MWgJvl92uEpTpErj4JzEQVDO5404QK9tWWk2mb6MK/EdwMZ7oS3BKrhmD1Fv3PI/IXL1nj1Px0pog7CdVPv+hFTbZnQk2in54YrGDm797qSfhk/0Mq6iTNHunPyaT/nQRguqHi239TNxirgxR9lgCMPZr84wAGl+JfWaGqaoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6486002)(316002)(66556008)(8676002)(66476007)(4326008)(5660300002)(6506007)(6916009)(508600001)(86362001)(36756003)(38100700002)(1076003)(186003)(6666004)(26005)(6512007)(8936002)(107886003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mLvaAIlQdF7mpITbC0RiVLMx6sE8cpFxGq5WoaQ3mEoq4Emw1zZ1KwbOlVbR?=
 =?us-ascii?Q?1PFJkYKqW4AUgjwUDMpcKBLmlDllCsfKY9DsNuIEpRCN5epoqiiKkR6deezB?=
 =?us-ascii?Q?MQJdKI67R3yKqNsLlzoGemZmWWztRAlEBPuDokQgeqDd6I17fTaaODP+JW8g?=
 =?us-ascii?Q?gxKyPiCif9GoFutIsXuYTD/+H7gvuD5lo9WbKz8D8ELJBNgu+gpmr4cmgOnY?=
 =?us-ascii?Q?VIl2D8+nhv3XAFY+JfdVCcj9NIYJdEk1B8rIAP7yCiwEOC9vIp4r+PEjXtkn?=
 =?us-ascii?Q?gpMyoqBksuBCoBw+2eR0K7JHzvY/S2K4Iz+XjStbuuNe5ww96LYVCvStNyab?=
 =?us-ascii?Q?P51qCHMa6Nt/JXnb163NUr7EVdvieXHzJMet2vcDOcwdviFQeBVvPN9Mnre/?=
 =?us-ascii?Q?hG845Nkq4x5hB1t7Uz0ol1M7ig5PMmyhesAIe+batO2qOxhyMrGsRec6qdrX?=
 =?us-ascii?Q?3p25MqTqotjMMBrrhE0QvnPBVqqDCSP1INnyrZIkbpugJBy45NwDH+QFOSSj?=
 =?us-ascii?Q?V6jZ07VqEK90m6njtxfnz/tk567UdiHOD21t/MdkhCHZmCVV9UBljDCn69lB?=
 =?us-ascii?Q?wRbnRrrmcY/UlGIdcXKeBsMQUfLr61ud9T5KgjuKogs4649tr0VNh5y+BX+r?=
 =?us-ascii?Q?trnbEus4xZl/+b8NVkvqTYJlE9AEr9vnZLSjpv8MuqrcumI8KQgxfexYAabx?=
 =?us-ascii?Q?yUzrmRRVps5smXwyYaLB+m0nFtyHDX4Cy2YTzheVxHZ/6TEWHlI8md+0cP4U?=
 =?us-ascii?Q?lSKy2QWA2rKjieAbAYKD3/T7bPGAwSSoxEd73U2eNk7OtYV27m3Q20tWT5e0?=
 =?us-ascii?Q?+iKzBGdh5JILYnE23PXWPPltpnyVCiRAeIALygyMaA/U4aeWMDDpEWGUpknE?=
 =?us-ascii?Q?S8iYVtaNW3UfajN0eJl4khhEx7tuG60yDHMCccLi6O45rcMVftbIvaM7hkSk?=
 =?us-ascii?Q?IyRUI7eOKI1dQGn31b0L5vRVNP3t3LQeWih0s/1M2Ci6dNUD7R1i9vIP9byu?=
 =?us-ascii?Q?AibDjHMG23XONyL+imgc6wS9/CXmVO5OaopLj4C2eBbzLCpvg9Z7UrrQSh6G?=
 =?us-ascii?Q?GsAc6hWHHjnytbUNkHY9gsnzEX3LyvIM4ygdXGkpWk4d06JgEfryi+uTKAEG?=
 =?us-ascii?Q?Irlka04Bpas0L75IcDr6d4JOztUz/sWQa7CQgGmtegTBSA2xyHYKcLtieuvU?=
 =?us-ascii?Q?8jkr6+QiczPgSdDcj7iQMgNyv3qJE5DVGuUG6rDGPtYbN3KhJRWSTnAIECpF?=
 =?us-ascii?Q?immP9PEntS5+Ey470GFwXDnfloEKG2Ua49Mbcr5poas1P6aaFdbeBa/DaRyr?=
 =?us-ascii?Q?RhVq6bVEFBHeBruHjRDO9ogB6PNRDg1mTAJMa6k7IwIUyK4PXqMxJ4m2I1ne?=
 =?us-ascii?Q?oMF1pupS+qAxR4qJw9Gg03A8mmnMBPw1Nwe2fCkxnp9FWIuEc81SzFHapHeF?=
 =?us-ascii?Q?5mrR++fSnyo//T/BHi/yGETk9XoG608bFtUi+rZr2ZoXl5ka+SKr5H55yUNA?=
 =?us-ascii?Q?vWZqwINbZyx963TnPm7cUXYNTLtEfLXLKe18iVbiAdLTlGRhPYHVK0YuKkni?=
 =?us-ascii?Q?biiKPuO76k8OOBA1lEOiPntHzmnOuNndwftzriZrRTepAQ482mmA4yIY/RH3?=
 =?us-ascii?Q?f9P9FHkPkY8HpQXiyW+BCP1Owbh48e9dD8xLyUUqiSPJTbFSy0F8yleVymMU?=
 =?us-ascii?Q?xs63E/r0Ur6gR82V01MCU5RTEEniJdH6OobT1DSl9X0XItZpP6mlr+fCXunL?=
 =?us-ascii?Q?mXetEAq8fA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76d4de01-3b82-436e-3833-08da2d977f34
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:29:52.4724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wI2NTOIBl0WnSIN16uxEMb38pXA3xqMdOF36qJNAsujciklR4reLNMTeDgRfzDCZ+dnytGSjb9hpJILaIixI4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4745
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

A number of mlxsw-specific QoS tests use manual QoS DCB management. As
such, they need to make sure lldpad is not running, because it would
override the configuration the test has applied using other tools. To that
end, these selftests invoke the bail_on_lldpad() helper, which terminates
the selftest if th lldpad is running.

Some of these tests however first install the bash exit trap, which invokes
a cleanup() at the test exit. If bail_on_lldpad() has terminated the script
even before the setup part was run, the cleanup part will be very confused.

Therefore make sure bail_on_lldpad() is invoked before the cleanup is
registered.

While there are still edge cases where the user terminates the script
before the setup was fully done, this takes care of a common situation
where the cleanup would be invoked in an inconsistent state.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh | 4 ++--
 tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh      | 4 ++--
 tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh  | 5 ++---
 tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh | 5 ++---
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
index f4493ef9cca1..3569ff45f7d5 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
@@ -371,9 +371,9 @@ test_tc_int_buf()
 	tc qdisc delete dev $swp root
 }
 
-trap cleanup EXIT
-
 bail_on_lldpad
+
+trap cleanup EXIT
 setup_wait
 tests_run
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
index 5d5622fc2758..f9858e221996 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
@@ -393,9 +393,9 @@ test_qos_pfc()
 	log_test "PFC"
 }
 
-trap cleanup EXIT
-
 bail_on_lldpad
+
+trap cleanup EXIT
 setup_prepare
 setup_wait
 tests_run
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index 1e5ad3209436..7a73057206cd 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -166,12 +166,11 @@ ecn_mirror_test()
 	uninstall_qdisc
 }
 
-trap cleanup EXIT
+bail_on_lldpad
 
+trap cleanup EXIT
 setup_prepare
 setup_wait
-
-bail_on_lldpad
 tests_run
 
 exit $EXIT_STATUS
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
index d79a82f317d2..501d192529ac 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
@@ -73,12 +73,11 @@ red_mirror_test()
 	uninstall_qdisc
 }
 
-trap cleanup EXIT
+bail_on_lldpad
 
+trap cleanup EXIT
 setup_prepare
 setup_wait
-
-bail_on_lldpad
 tests_run
 
 exit $EXIT_STATUS
-- 
2.35.1

