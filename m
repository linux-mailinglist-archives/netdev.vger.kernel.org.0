Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4F850D7D9
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbiDYDug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240854AbiDYDuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:50:08 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21BC22B01
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:46:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdWyEnhIhtSapYpxR/nqfqsBLmjPbQ8TUMMN1zW79wuIdDBNhRuPTiq7qbNwmW5WRvXSSR6MDQbjomDPGUnuVmxULUeUpEWnrp4LjpBwf5uXfcn6PqhrskCRKa3XYOVldm5J51YKmTTwqBpEYmH09lEefDK6I5KRtdE/8q0ix1UXGvR4TVrHEelN3ibpRy1jkl9LB8ZbZAwTbzYFOQ7Jp3gYjYckr8sLTz9LxE2rGkRU+kVfiIHILPzKRPxSSI0lhDanNZrPpvGC5NuF0A07du9IWC0kBKFVtydpvegHATMcw6IFu/0Po9ZDJxdzF983ppjk7owG3ORzT5fqrb5rng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ghHFcWHHWvyGhQSGiz6lu42o527oTVK69uf/sVE7J4=;
 b=lWCEmLBID1U8hSAFPi5V0XesUKdYnNsK7bJ5BtmnMoD/Ysh/w3WsR82wA4p1FxGe5uCZqKz12q410DeyVuMluCSLbe7eP8o5a+ea1RLtMRZYKzWR4k0QvZhsnHg8JZp4mUztzrkiTPov6aVgAUmwf0yg9W/hMHJFyRq6bF5XjHn64hLJre6ORRGRk3/NflTLVVp+ZbQfNje59T0MPSG5ymSvg8BeR1vHz50QEM1bwLL7lD0ol8Y/2iGB/DXx6iazTlYtKFSOKcmLU0OUANrr8f5KJ5luN+K19OfmP9ZY64IRFCKaL/5kaHZaMVx4IgPKy9yRd7OAMzb5n/zhemWRHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ghHFcWHHWvyGhQSGiz6lu42o527oTVK69uf/sVE7J4=;
 b=QXlJFIaf4ap4ZG7QgIEe2gI7haXben82BjajOpUq0VrdqH3THBoBlxU/2JYehv4dy+xTNGPcXGNTJIOGOlmZHZioVYNSi56rzJfx91nOW2nH0MfMfXADpK5r53rE+kbb4hbAR+i3diXUvRuHzIe14OTE/8HIdXAqAZKUQlzHjkmU7skLqImYLjiWYu8E5qrsImXZjazCKQY0Djv5QZ2fsU3l/uN/0YHvxwrbua3dA1fNJB3/g1rPIHpMBfllE+2f3FfUff3hskIWfGgLKhOR8rocZXMtzo72A9fSCiP0IoKLyME219SZBehKoVaxqOwxge5saUimmnymvsz50pVuoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MW3PR12MB4521.namprd12.prod.outlook.com (2603:10b6:303:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 25 Apr
 2022 03:46:32 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:46:32 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/11] selftests: mlxsw: Check device info on activated line card
Date:   Mon, 25 Apr 2022 06:44:31 +0300
Message-Id: <20220425034431.3161260-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0003.eurprd02.prod.outlook.com
 (2603:10a6:803:14::16) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63553e68-c218-4f52-b507-08da266e303d
X-MS-TrafficTypeDiagnostic: MW3PR12MB4521:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB45218591AD5E9591143457BAB2F89@MW3PR12MB4521.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bDDX5ecAooz9qK/9zRXkA+HaA8v9zsbPXBuIDHOdSS/H78hRQikom+IMXbSheiqJAhRuc6WnlQFY9IbRF+UEfVml+xODf1V/+/Jd3wf2431aeFDZjkAa4fOk4M10TDmkAG8qTf0pYcDeyqnkZn1QnikmndG9cdV4k1V5FY2axb9Avu4q4mTmiuhV5KL9KDSgUx0vaR2SV2oOLEBSCtqvZNVPMRH5rjjEyBgUybA2Q0Eb38yJLF3knLcS74akEJ6qETacdRB6gjkxFKaVXLgisxlLmY+0cBLFhwtpyrXbI+hu+gIEo2wNellcNqPLVFDrfsSQsbw+CHHGGbxspzdR+tLmTAjd4BucyUkO16GiSF4UtW6uAax+ppifbQjAAwQoQrdMoPLYtpvmTpmbmtM6sIS/Icn7jGS1nzEFhRwqna4jkrb1Nyk7KnakooB8hMubfxaCutUohmHJBnCsc4qJMZeWqouQIU5dE75bEtJ4O/xbckJ08EiAEI9POBJQrcl9fnPCH0tdY87cbdEpwK0UFMuZIKpqL+ZNQmmC7AjiInwZpsrW/GmZkWOP55YtHUUksAq1mMLWDq2dnXY8IYZm+pEkVBItfKbPWPfIYNW5EgVlppoM/KVYwu1+IRUFZdtChCGoS2sQBLwNrqMHGresmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(4326008)(66556008)(2616005)(66946007)(6512007)(5660300002)(107886003)(8936002)(86362001)(2906002)(1076003)(38100700002)(508600001)(6486002)(316002)(66476007)(8676002)(83380400001)(6916009)(186003)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EVD/4KUixEhQe4n5sg8QCyhlYXaRzhYacXLrssWaBYoaXyHnLGLPQrzxRetY?=
 =?us-ascii?Q?3l9wdTsyqjBB0sqKFwBjERNTDQtfK1c83eaVVIYkV49Ve4QDzgasjr28PvJK?=
 =?us-ascii?Q?AINwwTLzYYhDoDT3/opVrlRdtJmehoXKW7iRlrX6thAuvTo2kkiEmUFnlZFO?=
 =?us-ascii?Q?qgNilTKWb1erw5ONTJQw05pia0PIEW0XbE+KFoOHoXOCuY3WVGg3sGQDkyTB?=
 =?us-ascii?Q?iFl9dxYPBlnPpEtJCbcSVKrkV9xz8UxwMG/y1VvPrpFAlMNn53BtpqNAd5AM?=
 =?us-ascii?Q?kW5LzlT3eW5+3OvaBOtDMh8afcRmsEFe2S8NImQJdh2VMVLU7yvXCZ8/CWzn?=
 =?us-ascii?Q?mpBUL0Fc2+J8NTNOTytgR/q5stA+yBmN7aAACSYdrExLOIDbDxPeN8BBNbF4?=
 =?us-ascii?Q?nZP+AV7y+mfTeX8AOqp44tOOtnGbw12maecoDDeZTJR2u5bhnaF/fPWOtvFW?=
 =?us-ascii?Q?ru65sTgmG7LEU2YNF425Lvx2uSGAjEvcmYI/6ZnhVEG+gJLp9/wjiZcCVLKc?=
 =?us-ascii?Q?rkofRZTAqy6wIQ9JJVxL+H8QITa9G5t1InP7nXcQvVM2Ql9cww3nhgBP0w7u?=
 =?us-ascii?Q?RHkHKCu4mCWmS5SZ0erye+P+YOAmcL3G/sVbTlAM3hEb9sxNxxik7pUroWCZ?=
 =?us-ascii?Q?FgMs/i9MyWpGliklOfbcgd63eR9S8TeAExWqppSodli7y91JWY7Sen6BqY10?=
 =?us-ascii?Q?zdEmi5rgdVfPZ2ku1zlUtW21OstUAyTkL0FasRqlSwbnpj2z46VNiFGo5462?=
 =?us-ascii?Q?9frxQHe0woxK3ud8GTQzRrCRpKTwttky8L9Zxn8VfydqvLnV8ovxhBrbWjcL?=
 =?us-ascii?Q?3CTNWW4RVQYKy3+bmqyc4c7n+pHde0HEP3cOFFbX7T7epPRc81O7eMFFBb2Q?=
 =?us-ascii?Q?DT/DP/gshCjkL3vNLWO/MS7isvnASal5a37UbdgeVSDjMoA53CmVh14/3efU?=
 =?us-ascii?Q?Fto4IG1upKEgf0PYdUPg0NxeSnhcaE426/gc4I69yq8eFxQrDX+hJdcGH0zy?=
 =?us-ascii?Q?tl4ntP5ymyzslsXWBgrmNbwzJugG7px+8kA7JmTeRL4v8a1TNnHSlu+jYK9e?=
 =?us-ascii?Q?9r9P5vIvJcb/R9AtrgxBXyrOPRJtMWuRbMnHNirqecdlNaw9NJJZa0Dde9y3?=
 =?us-ascii?Q?idgphYXM6SNt3yx5GAHhC9lNejfCXdjdk2NDzDlwE9Kl2VxNGV2BwLQwswlq?=
 =?us-ascii?Q?XyLDRnHFUSVne0YYl2mwSLNLiO/KoRnsN7AIjri2x6l7Lhp2C9YRhHBHDJT9?=
 =?us-ascii?Q?crnBv3IfPKE2EtPYDMnJ01lvvyQ/Ngh/ZM3pum94ofRRRe3nxEE7nMQD9q2s?=
 =?us-ascii?Q?K/PiKgw8+o6OSZsJjb9Fy2WIl4b/mRch81W+QyGkDOerPh59nJvVXZJiiWaE?=
 =?us-ascii?Q?mBUzO8w4GprOTHasPvMpuydlGwgvxicOSLe97RNg6cMV24YLyuTWfQz5ZB96?=
 =?us-ascii?Q?SXb1ANm1Vz+Lhw3duLfQ5B4TL3sZiNY8oW+gKEOkxzoBcCuGR51JvbYwuLIP?=
 =?us-ascii?Q?gIpVN2c85k7qFJ2VvXKM2ALE5tDK8QV/34Lf/EQK736utAwtcLrepAuxvRnn?=
 =?us-ascii?Q?rqss28PP8++YOJ+E/PKiDvHXhb8YaWZeLAp3Ll+5faBV90H4Ozv58iEQzRkb?=
 =?us-ascii?Q?g0UdPxkhK0ygWZ6TVQE4mC6eiJ8jGikHauf6wuzWYQaIfRSJ1T0+EU7YmxWo?=
 =?us-ascii?Q?+ng/uBqHpiiGQVQBxMPCyOdmkRN4A7MU5BFt0JxJbPrzAcUkoTgftTEtkF/B?=
 =?us-ascii?Q?32qBn2SHOQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63553e68-c218-4f52-b507-08da266e303d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:46:32.5047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AVNZ8pEOcOg5x9KglKfDpLr6HykRQjXbfFOTb6JD2vBg1nGwkA1DR5v1Ze2GYyzJC9RskENjIWv2i7qCmskTDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4521
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Once line card is activated, check the device FW version is exposed.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_linecard.sh     | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
index 04bedd98eb8b..53a65f416770 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
@@ -259,6 +259,26 @@ interface_check()
 	setup_wait
 }
 
+lc_devices_info_check()
+{
+	local lc=$1
+	local expected_device_count=$2
+	local device_count
+	local device
+	local running_device_fw
+
+	device_count=$(devlink lc info $DEVLINK_DEV lc $lc -j | \
+		       jq -e -r ".[][][].devices |length")
+	check_err $? "Failed to get linecard $lc device count"
+	for (( device=0; device<device_count; device++ ))
+	do
+		running_device_fw=$(devlink lc -v info $DEVLINK_DEV lc $lc -j | \
+				    jq -e -r ".[][][].devices[$device].versions.running.fw")
+		check_err $? "Failed to get linecard $lc device $device running fw version"
+		log_info "Linecard $lc device $device running.fw: \"$running_device_fw\""
+	done
+}
+
 activation_16x100G_test()
 {
 	RET=0
@@ -275,6 +295,8 @@ activation_16x100G_test()
 		$ACTIVATION_TIMEOUT)
 	check_err $? "Failed to get linecard $lc activated (timeout)"
 
+	lc_devices_info_check $lc $LC_16X100G_DEVICE_COUNT
+
 	interface_check
 
 	log_test "Activation 16x100G"
-- 
2.33.1

