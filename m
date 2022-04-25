Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FD950D7DE
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbiDYDt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240998AbiDYDtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:49:07 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDC11A387
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:46:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hx2zunY8kArq8/QhV7otKk6TrVs7wdlLQzi0hs+mge//8n0jps2NYi47qq/jdJfNtVqeurnPuuYM2CWK0OCzcEYgw6JGxduSXFlZEMW3vhHkHgfpJVjI23xeroP/xyltdYbGwgAnL3d2V8zxZAvsoIyZYvw0P6Uu8nBb0zjG5SurycFqoqTyupWQWAB/ah8BhEeAALopxKTljk8KI2X5JZHkhS3/8FSMgY/OU7Lpg96CW4FOiROrorEIumE2YmXkk7j9wvFNJoDF07S/JK2IhXOtvxuQjAVRIvCVlsQoPIorhocW5RYVjoMD3AxCNiaqKhoOgnClTeK8O2Ba6iM7Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZLbBvgssw+0Pzp879tujWpRYzoxdtGye4PrKaAGPgA=;
 b=M7nualsm+JISJLlybeSI0M2iYTteABL+EhGe4n01gxIcwCLdpaw+USsGzQnv87JWRoZugwMoipdtGgXYutWVSedMBFZdlCAddGg7DUR7SAiMz/mf201kDvu2/THNLSzXS65xKzCnWCd4+9C7l4iVHcUC/VfP4PgJwyNZJAElVDBYlfBr16uC2J68DlAF9I9BINxz0muZBW5JPAr6GxdNm7kPL/b65UMSwPRSez+I0etrzkH9t9wyONZY+TKc/RYSSNtMxLcG1o8Oyy+dHy/8PKmw5AbBUhUGMbg59RoX5vjcSqyfjqnvWQf0PFnQXwpY+lkq+QjCT8D3+E4iKGe6hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZLbBvgssw+0Pzp879tujWpRYzoxdtGye4PrKaAGPgA=;
 b=VSWtL+0v1v9/+n0Ywvdp/VacKd+0CuViCbT7rmKqkhBehdte0nmD1m2QKDLG+AtuApwSZN1dLhEqZFOqbaVoc2f57nuBWJ9KUI03kHwxg+qm5lw5M6LbBHZP3a2rxEYg4RZjotbWP9tVylX60/bWEf76zaxn7s9FCJbKUlw0WveIfn4JZK4ZEkEs4MmWrGdBw71oW01ZysWqpCtCpGwgAHSVCcqERwVKFmtovOz8CvrmORHLQK36anqHrVotk0NCtJkvqQ9G8fwg6JP6i3nEzlVju/GAg2HNZekI/N9yZbOy3EpczSE42wU0+S9V+2r+HXny2bA/drYCcBnl//LeZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MW3PR12MB4521.namprd12.prod.outlook.com (2603:10b6:303:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 25 Apr
 2022 03:46:00 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:45:59 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/11] selftests: mlxsw: Check devices on provisioned line card
Date:   Mon, 25 Apr 2022 06:44:26 +0300
Message-Id: <20220425034431.3161260-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0066.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::43) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9463f29b-b9d4-4757-afd1-08da266e1cd3
X-MS-TrafficTypeDiagnostic: MW3PR12MB4521:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB452175E8F1ED6940320F4184B2F89@MW3PR12MB4521.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DIxFtuNlS+uBiQqr2R4NBa0SL5mb1DFVhp+2W/2IH99byrJ2eZFE6AaQanyHA8Kzg4JEWL/iuult8mf31YexU7LFaTkFcsiEL8/LippA1Sc2sG74ALQmyrmsrKcAuOWSvMQzQcCBSdX3JjE0MtO1/eTIFUocXGzNaLR9YMVI0S1+ed6dL+exlak7cRxKJVRZy7btx/v8up5xhrJ9vUnNyUBBJ+ofyFHAOc+Zr+SnWirAVOFMJKIInyPpWFGoNPrOFIHXYgreI4wbXyg42BUcqMidHoxxGI2OH1kEj8k+DoF71LICnOh6cJ5fr1835WP7vh0VHesiJVK2r/dUT0sgJpPuAgnWrzlRa3aJFKaH49WvTs/HDXcpdbhsEi0xyL00URfMnijJg3a/kwnVGJ4IDu8GqcOGnZa2EVa3XWxR0TJdtdB8D27a4IGt/CIVQRAXTWU200xVK8lxpv+hTr+Ipv8LVYFKA6lgwtxNGSXJLbHdpKaXNNuDvbCtYbvFpEC7x5ocvc0EQEBgg7l85ydmDN8QvzxZc58iakFSNtilSciecWL9cL/FjBAe7yAi2OWxU1kL7nSYQT6g8RF8dD80rTHeGYP4Y899Re0Qa0cEanMmzXrgGGsitRyQdkB3+FyxItZPlwTM6lcrzsA1ffhzGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(4326008)(66556008)(6666004)(2616005)(66946007)(6512007)(5660300002)(107886003)(8936002)(86362001)(2906002)(1076003)(38100700002)(508600001)(6486002)(316002)(66476007)(8676002)(6916009)(186003)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nf9yRA/AyWfVvaP0lVGtEKgUxO0+AxafkTTsM8UmDQh/qCkBTWutnQM8FNmt?=
 =?us-ascii?Q?z/vyEqn4EUC7zmLSgjnzSC0yTeQBhHBzUR9jxBzYWBgFltJMlRQR1M3jyED2?=
 =?us-ascii?Q?eXWMLYTfILmK6S9VNiJkKTs+/CiF+RBcJODhRlyVxUUNaWUwDus2Q5bZ2zh+?=
 =?us-ascii?Q?UC1P9vlbB6O/hRmaOEkow1YIERNRIEDvwxgi4Tp2vX2JNsSKzvZQXlCvFUkp?=
 =?us-ascii?Q?WNZ+LcNjAeoMKp+cNWx/iU/1w9PEUU50wSaBnlVQmFwsFcqyMbOh1M0egdfT?=
 =?us-ascii?Q?QBCH26iOqqM0VBDC9MR2IJw34lSqHREiv99SG2GpPV2P5RZkSuGx6c7rXa75?=
 =?us-ascii?Q?HtlhiZMh+SIcOlZhRAlZfYSUS4Hn7OOeZImclK+gT8kvvnL3h2UWUBLyAlYJ?=
 =?us-ascii?Q?19XHwY7Gku8v83DE0A5u+praN+gMjmJUXIVL9mOdaodCmQhBWs3JZpwQL43Y?=
 =?us-ascii?Q?Oc8whk/mYYqxvRIiHGISGQ3fSBFMKkKyM63Z9y7RXIdG+5PMIQR4IC8PSPOZ?=
 =?us-ascii?Q?3DYWnVJSXyD+elnHx9Gc0sWtEfuL46TIB725HUI3BkTgV0gt8bfNw/bAYLUU?=
 =?us-ascii?Q?DWmNy6SwTchOO0Z1cJz6TT/D4Ddke5yMK2ACBPgOcBTUUmi8TaVbIDUKn2lm?=
 =?us-ascii?Q?ZBUIzv89kbZlzdI6shAf8XRFT2hvTT3v3LPEGiT8sfTpZpY09m4SNL3qtgSH?=
 =?us-ascii?Q?qj9DEAlmkUp8qM5+S99ZgQZpj6yIAdR+toL5u16sEysGZPpV0clUw2YB4yN8?=
 =?us-ascii?Q?2hYjj5ZWe9UnesQZGTR+eo+vs0Ia2yn/5sfi8OV453wVJlhvW7kVM9GwnaO3?=
 =?us-ascii?Q?2F+PEvQVR89ULaCVUafZw+0i7a4aJ3GwVxWgzGKnku+qp4RiasGnipMLYEe/?=
 =?us-ascii?Q?S6uxhlycBXGv6AxQK3d0FZ0pEqZCsmTCN79tMW/EuUnCJ8vVeeQ0M3NWOsmS?=
 =?us-ascii?Q?RA6fLCLjF2Mnelj+qwGc69RvgDyTrciZ8Bm+jzv7U566F0PA7pU53Y7Vx7sl?=
 =?us-ascii?Q?uLgLctqDMA2UDcqWF+OLKM1b35kBN9WXWsHrQqwSBLjLtk8AxeYq1541wp4y?=
 =?us-ascii?Q?YMlYkglyzuckrSausNr+bEJLE6/O05xGYTiAuxGZcKDfqotWQpfmPDWkshsJ?=
 =?us-ascii?Q?b2OS4NJk5zis8n7mYzqhz9E03U7rsyqp3/AUJVPY/lTy9Q6bIG1LdyYDFrGr?=
 =?us-ascii?Q?zTxPqbohWc+CqtWc6PwpC3Y9QRQdUro5HI4TVeHhhFKIj0HPlR9R0YyD7H0V?=
 =?us-ascii?Q?1jNnuh2IMTcG8+LFY/5x1tsG117nx9tr+KCp7xdliZ9sx9ajX6NAsef2MzMU?=
 =?us-ascii?Q?kgbtWzAZJTOiaocYI4P+Xz5yx4vV4UfW4gqkwHv9M+QLJSfMby6KGfOBbliA?=
 =?us-ascii?Q?ZC1sOk88q/h5cPg9n+h7PNv8uW3AViEb35f2kbK7amki9yZ3ap55muFNxpzS?=
 =?us-ascii?Q?AJDDw1/xDzXVYUR+A+J/TXglNMqmVLyTpR2LbQh4zK7Tni4VrBQRlllYXzyP?=
 =?us-ascii?Q?5AjWtelZ+EaHk8ddlMy+XEc8w5qdjTf4AuY3GKlSnotg9T1MzWGYn2JEwrVg?=
 =?us-ascii?Q?wVrrxX1XpBJYnQAV2c4/X1G8fMNIlSx3BjKRQjakOVZ7Cjs0yqBtxUVavQV+?=
 =?us-ascii?Q?kdw6e/QQ1E1QmYHbYqBz3VUqnU5PVqiosq6spcedbcUWn1Z9FcCjyho6anLX?=
 =?us-ascii?Q?vAc9hFP698WW4QBVugk8JROd1P0KQ2qle2fYBODW/oVnCp9gCPMo4dagI/kO?=
 =?us-ascii?Q?9oN5SYApBg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9463f29b-b9d4-4757-afd1-08da266e1cd3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:45:59.9177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEka6NVR3NofN5Rb8lNhO3lTtaOo8YtLR6+arXDrg9oCMi2EsUq/25dkASPlOOx6z4V78l3gGme694AqEkWTJw==
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

Once line card is provisioned, check the count of devices on it and
print them out.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_linecard.sh     | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
index 08a922d8b86a..67b0e56cb413 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
@@ -152,6 +152,7 @@ unprovision_test()
 
 LC_16X100G_TYPE="16x100G"
 LC_16X100G_PORT_COUNT=16
+LC_16X100G_DEVICE_COUNT=4
 
 supported_types_check()
 {
@@ -177,6 +178,26 @@ supported_types_check()
 	check_err $? "16X100G not found between supported types of linecard $lc"
 }
 
+lc_devices_check()
+{
+	local lc=$1
+	local expected_device_count=$2
+	local device_count
+	local device
+
+	device_count=$(devlink lc show $DEVLINK_DEV lc $lc -j | \
+		       jq -e -r ".[][][].devices |length")
+	check_err $? "Failed to get linecard $lc device count"
+	[ $device_count != 0 ]
+	check_err $? "No device found on linecard $lc"
+	[ $device_count == $expected_device_count ]
+	check_err $? "Unexpected device count on linecard $lc (got $expected_device_count, expected $device_count)"
+	for (( device=0; device<device_count; device++ ))
+	do
+		log_info "Linecard $lc device $device"
+	done
+}
+
 ports_check()
 {
 	local lc=$1
@@ -206,6 +227,7 @@ provision_test()
 		unprovision_one $lc
 	fi
 	provision_one $lc $LC_16X100G_TYPE
+	lc_devices_check $lc $LC_16X100G_DEVICE_COUNT
 	ports_check $lc $LC_16X100G_PORT_COUNT
 	log_test "Provision"
 }
-- 
2.33.1

