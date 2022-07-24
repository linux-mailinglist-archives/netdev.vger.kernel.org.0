Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BBC57F3E1
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235995AbiGXIEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239510AbiGXIEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:04:49 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A08C19C32
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSazGbt4ak7VTGnY9tfWWMMXqS2zfunF7hVBqzKeWKo/u9g9Pn6HK7ftOG61DnOvWsuYgEhEMeIYF7X1FRdOf3kpUsLFrR/oxAIjuHGRCvSlI1hfqLOthvKlrFFLw+KojUJ8ph9+9G6YYU+3Wioz56WgTztgUTl+LijfC4G6DBL3tVBSeFpa533RtjO7qJd0j8LswJcqK8T87gLACMeMWVI2fa7tIwFdFpAT+8kUGVRxBjt3PGkLRJpObJ9BRttpvyrTt3WU6BU/sYepeN5Jt1eZQDdABbSihwIe9NUvEY2HMsU/tr6GBCh0KyMaF1u1PKOLXh1XueljvSamadpqVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/yeXYTQiCj0FYVQ+nSMmYxzjf+icRtSiDGe6aeASqf0=;
 b=cE6GJI4jy46yLS8BlLNqs1VbEH69NGPSStFnUIWOnKehY6W7aGBl1ihXEe/YSWLzQvDDMlVsZi7b7JUjB2R6RaDVMHzSJXE4wh1P9xy+FOIDoRBT583MjUHkKh14zjFSwdfjdaLq57oSkgwxguC2hf4RTalIbAjdJAQeG8BVVdrxNRdtNjZpxID72Qo14Wh3CoIcnz+SSADVB9BvL7+NfjfjBPj7sKDM6CPwbnGvItyDir2RAUHL5C5kECKxx8tnJupOjM894O/4txy9wPABUi0MqUBU11i5UuwOPhPadk/lNmd7zsDbFVwG6EspWVo4PIeFEQkxcaWeZDoWIgzNxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yeXYTQiCj0FYVQ+nSMmYxzjf+icRtSiDGe6aeASqf0=;
 b=gxXRz3LDZftqEvBbc7zGWEqOSGiidCRO4IbprLS1/18knWD0QJVtmWfjXLsQLUqnCyQsgSyA+m91Fdw6Q8IQwUs7V9oQsT1bfq0jHUUtngBaj/EdqbkEwBonk0gtQDX0uAPNbY8MVseMhJVOe6RZtza0v1zzm01T4Pg705oONUWyxGixWFgcRJcbE7qwP3XwOF3N38K/Xbf9gGMdtCVpMwsIBwogbAhHbdV6TQX1ad6y1NujDiPG8NLfHO90maa2V8VR/3ZUqz776Z4mdX2uty7HzxhXGHELc1r3H6TQqOKCywfAToLHkp4yTunhCMuI68+uBIrMTW19/nyB9YxLtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:04:47 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:04:47 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/15] mlxsw: cmd: Add UTC related fields to query firmware command
Date:   Sun, 24 Jul 2022 11:03:19 +0300
Message-Id: <20220724080329.2613617-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0342.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d32b8465-4398-4fee-53c1-08da6d4b2d43
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xr8oSi8S5EiLRrYuPiOJ9snliWxyROa9LxWaXIdOCzIGSR2bZFAFWMagmzy1YXbf9Ojd76EkWOZ8kBz5cj0rpORc+PbKYCYH2AuFF+iR5NH1elJEcDBOwWI7qljeNXFUVUEJb9njPsZTWwP2/4AgslTmioPCdipHBkzZPUxsAuf5a0Dhy0nnA1oZbbkVglQlU1ALgtqGjkxfubLQ3jDM99FGIhdlmHqewN1005q6UOQHrIJtWKNH52ytoJKOcDuvVsOTWsTkZc1jfdfx7HkdwsuNS9EZrKF8GyCyrKlSZGYeHsGENsC4X+osR3Y8usP/oX6oFinnB+CPZUfe/Iw9w0HqAnILyY1TVq8dnDDnqYdEdBsNRD3gF0O2HE+b6i76O7XCYczo93m001CiPQGq7cLihLP5Toly7aDeUopT3m4QlKj2213fkdvF5qc8KGf/W8vWtJmA0yNwiY+FI6pJ7f1TSx5zCrjY9U8aezRqgdysRgMCkHalc+ugL62aBpPX1jFZL/Fy5aHbcLIIbhRstULsoV3sSlByqkZFyFNRifLYvDMqC2tS1y492OElI/Aw33F8CfT+yxwO8RnoS0R+IASVgfQ1TcHL/Vf/5GtDkM0ZBv724HLH0ySbzdb5cZKiBJBqQQHlJxrRPV2yWhAHvFbpDKwB69vh94Bm8ZAvVc3wjbBc6rT4oTIztSm+1hrTWcHQplTdqXSWABGooODtcdtAfRjrbYAXzLiBuJnrvELbEWjGgs/0uWZAFypgl/T4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fsKJ2jrmDQjNNe4zqLz6lOWKf0xICYCZ12FAjarG14ryLTa2iqIrc66LIsCe?=
 =?us-ascii?Q?+UHdO9qDVWFBOEgVmQGuX8NxlN3QyBh/Q2pWhHfFAkBB+XMXpn5eozjH8Zur?=
 =?us-ascii?Q?v/TPvdgsIOc4CVlxdF5Oag2DkWm0k7BA9vb6vi2OHyamegbOUkD50Ib8q9EM?=
 =?us-ascii?Q?OgxaIZ+xgUHAmxDY74LpFmPalNcWHHtpnMiL+zkjw2rJ7zd98XYuFyI3QJHh?=
 =?us-ascii?Q?CYcP+tnu2w8CTxZaK10jFf6HwqFI92jC2dgPCsEbB8BzcD3CUBnXoH+itmGT?=
 =?us-ascii?Q?SNAqM89tHYd0QQjxRgzcrNNdWnsjuRMEe3H71KLm2hzompU1UZNe8yE+jnzV?=
 =?us-ascii?Q?1H0hEtww3CAC+1pGOO0zvQdtJQgVD3SPL2kvthP/eSIK2iTNn3zlQzXWQy76?=
 =?us-ascii?Q?nvQxKWhR4Ei1jO5P37S2MMrVXNIHjLnvYlZqbBQuU68iRlMOL9urgua4egZ4?=
 =?us-ascii?Q?EgTzFKWw/V6fjbq4XWfC0hdZxWX8AYzUge/t0Z0MSMSDFksqAbCXpUxobGi4?=
 =?us-ascii?Q?hneB7l9EySootjBiBSq031ObPwTA670ftpR21rrb3INZvRavS20kdotL0lB+?=
 =?us-ascii?Q?lOWc6r2nlkPSiW6ceHW8EFb/NhSp2XiaKv+KTKrEFUFfs5J10RqUHh21uEbo?=
 =?us-ascii?Q?WaVQFaOpe9n30FDOeX7eu0cl7BsQ+Ncw+RkeG0v+Tmn7csrIfKGC++c0OaZk?=
 =?us-ascii?Q?L9HWO2nz2YI0eqjeK245HcPpOEcROU+znTlW5uZ7f36DV/9Ip+8w0cw6BRs4?=
 =?us-ascii?Q?lTRkWDISsDXo3+6h0LxS237LO7bdxuylUz64k7wGNF16bZEB+3Az72iQlMDb?=
 =?us-ascii?Q?AJQX4hXRNcrwrX1C5Xp3Ktgdo7bXxX5mwrsWVbqtssUOWoTEiDGt9YAtp51z?=
 =?us-ascii?Q?MS9bzGsErB/YDkMHDHUUWiFT1fSZWyl3u16qPiM8e/3pgDe7BQu6P+r8yxnp?=
 =?us-ascii?Q?yVDZLC5lLECmk/hR7LiIKCAjpmC6QO2eMgVz/3gCYgsbJFXTFnE650X0WZPx?=
 =?us-ascii?Q?AcMby9oCeo2+0/KXkgneIi4hmpPmo3y8umxoikDBi9usuXoUtCGZj0+3nmzi?=
 =?us-ascii?Q?vakdWTpgU9P/6u6JtFWu3ZTMbtaiXZdxFKXE2r/XXfnfWKyGn/Yo//3nPdnn?=
 =?us-ascii?Q?+ldYXmCHzUe/UTHiZpnA038BrIOwn6OfZ59IHeCaFkMp3X5Q+lSDI7BORv3i?=
 =?us-ascii?Q?Cxe7exuo8s44DKEXBI5t4mJ121Eh6gIAk5qVjKWSlGmyKtW4qEdLqYVm2cJl?=
 =?us-ascii?Q?+Upbd7ZPuYjmjulWYfgeO54DiEv9Emh0za543RdffQZ9+tXrRqIIAjXpi4ZE?=
 =?us-ascii?Q?YAsxd5zCGMdFUJw0Tthcokzky6fcKZQZPNXWEVYvgAeD2hPoXwl5Iou8N5FR?=
 =?us-ascii?Q?02wkci6Bjs6m++ksgZG3fSCazr76MPvBdsSUT03dI4ZOe+1sTEsCqiOF1hRd?=
 =?us-ascii?Q?lS0F9nJ1zJD6vI6uKMTpxWfJiIP788pe0sxlSJL9EykYLdk8S2vSXjUM839c?=
 =?us-ascii?Q?ypXsCfeMkNCv4zipIyrY2fF9PQNVVmeisfObVp/ECGTOAHUC+gASu35wuFIm?=
 =?us-ascii?Q?STOhy9fjlvUcqw+uhAWqkPxcVs5w+5xZmS554LGA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32b8465-4398-4fee-53c1-08da6d4b2d43
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:04:47.6802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpEDqNJywHqjWAGYPgveniQEgGVE10s9k/Bp63PaFGx2wUrWGegiy84lNNUayeU0KFw+oV2QlHn8Q05PVsmKXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3877
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Add UTC sec and nsec PCI BAR and offset to query firmware command for a
future use.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h | 26 +++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 666d6b6e4dbf..e5ac5d267348 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -329,6 +329,32 @@ MLXSW_ITEM64(cmd_mbox, query_fw, free_running_clock_offset, 0x50, 0, 64);
  */
 MLXSW_ITEM32(cmd_mbox, query_fw, fr_rn_clk_bar, 0x58, 30, 2);
 
+/* cmd_mbox_query_fw_utc_sec_offset
+ * The offset of the UTC_Sec page
+ */
+MLXSW_ITEM64(cmd_mbox, query_fw, utc_sec_offset, 0x70, 0, 64);
+
+/* cmd_mbox_query_fw_utc_sec_bar
+ * PCI base address register (BAR) of the UTC_Sec page
+ * 0: BAR 0
+ * 1: 64 bit BAR
+ * Reserved on SwitchX/-2, Switch-IB/2, Spectrum-1
+ */
+MLXSW_ITEM32(cmd_mbox, query_fw, utc_sec_bar, 0x78, 30, 2);
+
+/* cmd_mbox_query_fw_utc_nsec_offset
+ * The offset of the UTC_nSec page
+ */
+MLXSW_ITEM64(cmd_mbox, query_fw, utc_nsec_offset, 0x80, 0, 64);
+
+/* cmd_mbox_query_fw_utc_nsec_bar
+ * PCI base address register (BAR) of the UTC_nSec page
+ * 0: BAR 0
+ * 1: 64 bit BAR
+ * Reserved on SwitchX/-2, Switch-IB/2, Spectrum-1
+ */
+MLXSW_ITEM32(cmd_mbox, query_fw, utc_nsec_bar, 0x88, 30, 2);
+
 /* QUERY_BOARDINFO - Query Board Information
  * -----------------------------------------
  * OpMod == 0 (N/A), INMmod == 0 (N/A)
-- 
2.36.1

