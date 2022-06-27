Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400F755D73D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiF0HHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiF0HHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:07:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1675A5F78
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:07:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWskxIjTCk4ZHMfz8w1MqJBwTeg/C8K1cE9hj+W7/EPPy/4EwOYaPYFrKZCo8eebvmlqG5Zh4nWtMkHFZ5QkccHOMzsVkQjLk0/+23ja0Q4tzlUJyJF1V8kuuO3/+TlA7SmfP1GUJPw9tBXXKx+H1VXO9EbefNmyVnePtrUCq3X7Vzd6X40cdbGIdspHKkN5pggUoKh4uUVf36YMH+v17Yrji3+UKmyBoedgfnIOAzr9YexjSSxbkczvFUoYpSEXc1+7o/LEyfyc7HeZ8Js7rWselivERKpUrES51fO3lhD4oAV2X+5mGSMGhb9aYmR5SWYFrMNoZscHpCkzNYWGXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppvQexsri/rWAWgnpl3/Xq7iijohLHZIwQnZulVEBP4=;
 b=hFJmzyCPCfQrWj59lTi1ZCdoNUMitMwIYNfMLUCETZQtbVT0ke9F1dJdIRXE9weZsPzeK3g1gMkR8vEaUAaE6IdNXmQFHrR94mt9lMoNgLsInwX/UGT6La7IeNa+oW5G9eMPUsl3xU81X1tJFpM5WnmmecIO9T1xeaU2TYEUvVNM3p7QJyGWoOrg6naVXj6ZVGZhTV3LSz6Uk8foYO5t1d7Y5pDEkEOdDrpyerb8kPs5KfLrZglvkJofznK8l6MgkrqxrrD3C0KQuDhyVQIb1Fex85PvwgMFib2tHmZ10cu0ylqkXVlzG7uqkmNUF9Zk0vQv1AfmHS3ar7hXqPUYsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppvQexsri/rWAWgnpl3/Xq7iijohLHZIwQnZulVEBP4=;
 b=lnmHkod2C27DfooRloR/woaNZV/RdRNRHt4uW6DwCMpJBwwLoJpjA/tK3k5f3YKW6FRMCrzNIYzKuHBYlw7ihT+Dd31aCYWokzt7Z1b2Hq1l6kNplnVkS+xzK0hgvM1tIzoZa8Gasfeyj0aGtJSDN2EhAWC/wSzQNw35Tx3zbDD6bmaFALFD0aOTCPVN5g9KlZ6TxmdCUS7xtsR0cjOojQeuQQrmDzH/LwBrdnvLtddDGD2rbdj7ihaSm/TvgNJFvj39PQuhoB2rleUJPFmXW16Opi/uqB4JVKr84O30w0QoL4MpHd9v8CyLlQTUuD5EOCoXw7nCV35LaVZN/xXgAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:07:07 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:07:07 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/13] mlxsw: spectrum: Add a temporary variable to indicate bridge model
Date:   Mon, 27 Jun 2022 10:06:09 +0300
Message-Id: <20220627070621.648499-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e2c1b45-c925-4f51-e73e-08da580ba5d4
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDwHyyV0U7AV1vpt6XsIss5euW/2CpZjTteINncOOQ0ifgk0S4sua4FLyZbK0mzDVkC5RjQzwWIBfd1BJgj0n37LFo6qixgNDWIPDLo2kqVVX3Rw3irsy2hCfK4KXnEETbdY/hOTHqGID8q/w55JmsFgM2cPanffEj3fqy3dNXUbm5bkLpRAdheKMNy83Qh6UBSi+0wXuckevUb6+PFKcNCVp3/CZWPM3Uk2NoTfJqEC8yN9L74V6pFY+sOVvnhHlEPa6jCcTUmovgPn5anLfwfoSLznaFuvzG+Qoa7jFF5YvUlcaHmD+fHAYd7pcUdz/ekffiQn9eZ6eE3X4aRMt6k0wCpS44ZDwUc4QG88dy8UDJDCHNFCh2BPTONh6+h81QX5HVPDbittmIj7746QlIVIhR6q8qT7aUZ/K/kjhpuv4k+9qEJJtbH2G8NMOxiHQsCr3BYHz7yYXQZ+RATfPFt5dTiE8t8rz6zXeXbIc8EFJA9UyydhK1jaudDnoLO4sSA2Ix3EQZ63SL6IOZQWfwK9+DVsbmbG2pz6LJoC59idQIFfIDSZjv7Fyaw+VZbiVkZVh3lcHV5Rd/ZwgpVVT0FTnTlE7iw1Et9djELvc1f56s4bIPjXg6bqQinK5FpwviF4/XQ67rHslpUqukKmPma+M7qcCVFu9RafofAmn3xyvxV5LTYjUNgFflcIxpm/7dSMznkrmrgbktkWcL1lP331nDx/pS/FLuXj0kIe50/Uaj2uCJnZGf7OUx/vQqEe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vLXTamTxqEZQ9KQGBCiY9zzDMl6R4XqBySZ7hWK635WDH6Vtplzt5BhN6t01?=
 =?us-ascii?Q?ToFzyIE6Bl1ekqNM7AxnreT9C+E8n4k8LYLMO7BCQ2i0hE6YqRpgnBxbiNph?=
 =?us-ascii?Q?CmV8b/GGLJAWWob/oJzYg5OWbZtymii5ZHLn4oKodfeI6Tle4OQ8UNtYrhfB?=
 =?us-ascii?Q?UJw9EbXhX+b+/XsNW3PqlSlRPG31fyiXU24U1pFd64hXbcY/yoMOz+lrIE2R?=
 =?us-ascii?Q?2hqp4bSRN0+3u7agz+NNHqhKUX4iuD/3q4kPon6bal0oDakUthmmrc+k8aQZ?=
 =?us-ascii?Q?IgAefMku78BeFfb9V6ojhX8PY2a0p6viZpq4467MUXSgNT4TDDUzpMuxTKvc?=
 =?us-ascii?Q?lGeLMaUwKmcfcar3dyqQ8e1zRKzd1OffgTI0tLkWfmfoTQenYLH++8WX8xkJ?=
 =?us-ascii?Q?/WeQiqq7Jiv9D9sQuZOn+zqYJnUby6tSyWqgm6EtKz/Uop7If64exPutq0lb?=
 =?us-ascii?Q?ianm6E0qMfnoIEcu3vWXMRR1VdKUtbK1eVjLf4X8RenMN5rp5O7Ur8O3ng8I?=
 =?us-ascii?Q?Ke0Y5KAPlFQKarC6DyZAv99z0/s5n+0nhCnpRLhwKYiJvQpi6VMEDbqMU+Rj?=
 =?us-ascii?Q?yrG7dDmfqbqorMlkyN1oczoYWiaS28bNfeh9oGXKbrF0CN/cA9AiKcdCd6nJ?=
 =?us-ascii?Q?RaHk2XPWtDDMc58KHvJT1cwp5s7gn26UKN28KRL5G+EoLFy/aaFdmduo7GDz?=
 =?us-ascii?Q?F8/xL/ECtUlRgN9Q2vf1Y/VaAe/ZHHM8H0bcYH5kXfA31PQCA0WpvCDVdC/v?=
 =?us-ascii?Q?HBg4kq0bTXTHUdFXwhXma9cYoLYpUlVXT5AdoTAKa/1Dz7u0j4OPM1sHeb23?=
 =?us-ascii?Q?ryjj3Elkurp/WT+2rnvVSYTSGDCbx1HCwyV/Au4q21zUS/Pc92tXt7dfoVk7?=
 =?us-ascii?Q?hvgr+jViwzKpiR7kh6xLyIlpOj0o/4bzRoHfSHBaUgsOAXflo7GcNunJfu/t?=
 =?us-ascii?Q?mssCAN58sNBJIoav63FT38O7DZyhrJUMNF8eqqR68iHvYPW7e/VpSn1ux77I?=
 =?us-ascii?Q?0+8eIbQ/PwY15r6lqcSm9jc6cfSipKR51GuNJXjUbpn4zbXU9qkxqB+7j7ym?=
 =?us-ascii?Q?dfCAKIVDK+2CkofnLdynp/+B4lSU1zAqSnwb6Y4PLNi01LrKUGms5CUxgH0s?=
 =?us-ascii?Q?56XKdylzu8ou97aVJzcYPc+I/wAGXzua4jy4UpvT+irhefuldRJvefmQ2i9T?=
 =?us-ascii?Q?RzjOwKq93H4sUwhOoX1q+tX1MfFPPrVHW66RB+BIjypsyodZx+yQbwl9ZeUJ?=
 =?us-ascii?Q?Zu/9z1LNfsIE0dEAUMwihcL92wK4q2ahZ4KcKeG9gCQhIIo8uE7BcNi3w0AQ?=
 =?us-ascii?Q?sVTPgXyS7rzZtQ1NHNYck7CBiasgn8/p7sZitXipfwNTiZyzqkM95Mb2FmJr?=
 =?us-ascii?Q?zRW5a7AX2Ilb0N1lvJX2eBS45kI2aE9PRmuwG85BmX2MFsdgd51msMu+I/K0?=
 =?us-ascii?Q?wX0IJ47d24fzuu8oETMLqjXOaYLwbNsVIu9yzgvb4Rk283+D0VQQEOMIbDlh?=
 =?us-ascii?Q?ZD7Y1atcBS/nEW5YYrsZevqYmNjC56rasclaWA0o4YA4MZn3SQCL8jIexQVF?=
 =?us-ascii?Q?0F/ceixLg88pA0RGJZujahDO6+FmqbyewuIz9NI0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2c1b45-c925-4f51-e73e-08da580ba5d4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:07:07.7518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmVE3Reaj3l6PLEYH4HJLltzPjOLAxkKJzDafWxT5LVJQ93buV8aq8hLA8OMiW0rN/GuUmBSV679IzbtuyNuvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

As part of transition to unified bridge model, many different firmware
configurations are done.

Some of the configuration that needs to be done for the unified bridge
model is not valid under the legacy model, and would be rejected by the
firmware. At the same time, the driver cannot switch to the unified bridge
model until all of the code has been converted.

To allow breaking the change into patches, and to not break driver
behavior during the transition, add a boolean variable to indicate bridge
model. Then, forbidden configurations will be skipped using the check -
"if (!mlxsw_sp->ubridge)".

The new variable is temporary for several sets, it will be removed when
firmware will be configured to work with unified bridge model.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index e58acd397edf..6b17fa9ab9c7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3155,6 +3155,7 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_ports_create;
 	}
 
+	mlxsw_sp->ubridge = false;
 	return 0;
 
 err_ports_create:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 80006a631333..828d5a265157 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -216,6 +216,7 @@ struct mlxsw_sp {
 	u32 lowest_shaper_bs;
 	struct rhashtable ipv6_addr_ht;
 	struct mutex ipv6_addr_ht_lock; /* Protects ipv6_addr_ht */
+	bool ubridge;
 };
 
 struct mlxsw_sp_ptp_ops {
-- 
2.36.1

