Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCCD57F3E5
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbiGXIFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239785AbiGXIFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:05:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C56A1B6
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:05:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jpm1TODtp3WnJLjoEG6S1pt+G9C5ZfDSLx7Zs5Eg5tZFyf26Wzrzwf7EKAJ75ngrz/zOAaET3KXz4tqd+lZ44u03Q7HHUEE58zFdMqz0oan3uwp1k6YdmhDzFIBzlurcnI3+4rh3WgB4jOHTVTLfsgmNEgJEhc68uMiPk1MaChj1Wjh5qOAC4aE6HTXTd4qX4Mrll9WwziNjb5ybXcSrObNyX3B59I8rDJIgzMztiEXEfiv9eM8ieBUnYQf82pjFVxJxkrEBTrqFMoAvsf5AFZNm1cDdAejBd3jUpc1gLsjuD14Msd4wG3hEfzrn1djZq6Q/JSL8GgxpEH88134hCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZHI4fjITXmMkjadsJUCWsVHQfG0rLP/e6CtOjqRBZs=;
 b=CaFshrsdyPNVhrOGiIFegCIlptlrEJFgFYjR0jxOexmInYvFjO7NTYoEUjwkAS9dqBJwSS8uOcLgnuk7zMKypn3zzgROXo9MOjS5Xy4VG400fFI+7X931OD/ZJEjQ90iy5YHCCnyzE9IdDmWSf3kMTdEkaPMfSr7zG/Sy5ERT2yvnSe9M5si2LhltaQdFfZa4i3aPF0kksXoD1Y6JJgNzAyXAxoBPoti1JUdvZNZiZ0yAlqnc+Gc77nfLmjkVJyoH9kEV/Zs6Gf1S9eDhPp8MfVM/UucCb/61l54+SlqsggFFLBKRV+1CFwP0JBg2ijJNeiCj2+v0HCtewRS+pGGJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZHI4fjITXmMkjadsJUCWsVHQfG0rLP/e6CtOjqRBZs=;
 b=jXCyVJTgwiYqTUhHJ/cHdVxur08dLqCQwurjYRaQ6oJ7ShhyAA4Ndp8s040G4RJagMcox5cs5iAnol2FyV9T/Q9MI28LBEmq4nRZrnSJzxhGHUsUIfQpAHiWoM0z1OqImz2idXY+QaJyllDLduigu7cNy4xKKJIbp8gyDo4e2XiTtcmcMhPSycShxg96de3MTc3r0ZF6GOz3CApZEzR/ldZveIBL9M6+g+xZeXnr6LFO44SgS5464uwSiLpLQwxJVEtUoi+xtsOzin/bw+ZNiLncgV88HjKBsSjJNGlIWNqx2GDC0snHYCtHwbLpfXHVEKEC9w6Kl5fKTLNG830TvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:05:12 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:05:12 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/15] mlxsw: Rename 'read_frc_capable' bit to 'read_clock_capable'
Date:   Sun, 24 Jul 2022 11:03:23 +0300
Message-Id: <20220724080329.2613617-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0409.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::13) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 595970b1-d385-4367-5657-08da6d4b3bd7
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/dvjHaSdU6gajWzk20v4zKKFqsTTPTSgTRBUhDJPnj7FNJHcl8NzkDgwgBVqzl6V6MSIqYtBLX75R80J/Ev+QDE0CZHiD+WyXZxd6k7NhI8zrROQjBFVCibpeqDCQA3ezJL0PjtRLjfaXCwgGb6jKgAS2izV68Djv0RAz5MHbGpuD6hiAkBFQCdKji6MC1GGsKUtQQaMQ0j1J+VSz2KLX1vEBh5ssGgAnU2YIJ4rvhD+m8XxRruK/LnPsZtSFwk1TdoY91gAIyQ1ROCpcdMm/cnMA01AXY5HdMzQVPhN3QJGFzJhgnieszbNWZQL56BL6Lj2AKth21DdLRlRZyqEUJWN89WPzNyMIwFXW95cAW7k3xGVkloCdjQkKBxfgyn1tTNimtJBB7c8cPLwgB36M7liLRxO4Ej4Oo83KxQMZ04+9/GfpPiGOBp79ZuwCx1j73XFzR52Yc3kr5UmXlsoUOrf6nQMPYA6Hp5f9z7fc/qaFg7+6OQD802pGHb/sRZb10KiH2z5vanAYC6lwMfVp5SlM+857BbmsRA9AhTDH4Q/QDDlFg1i4FGWLhz60TxTISnBzQLbX7woYMincDMxHWTWL/CXSaooZlmmF3sz8HaMuqp4Q2I4HBYktm2hPRi8QVxM+8+oUvbRuB6I4ieH9kiauUpDoaqnNyynkl9O9dUwKqCESF1FmICuWqfWoN5Ilf8AiR6vsTQMOnHw6mOaVggUM6b+nMYG/h6oNojB52LUAC+1oGR2ycJ9EQLRKxS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(66574015)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rPy0UXuC9/hNhK/1BYJcWsuAkFk7FCW7xyNUmRycClEzkcF2W3mHeXqkoDYX?=
 =?us-ascii?Q?A8BFnEXFCUAmZzyuRohRiDKW7navSQuWAZzCHtvuV4pHw4yQxyIms9xWYcc8?=
 =?us-ascii?Q?V15k2mMesXDc0IJhSjxJJH2kJD/7bHKAXjvwPxqUa783jp0+W5s+itEPLyey?=
 =?us-ascii?Q?Cw6ZZsTPnAFHVHj7TWaW1QKPBUaxopM7EOVBOzRsNagyk8XAZjp80UdBZZlK?=
 =?us-ascii?Q?8wLyxvqjfWMJn9VwT94C4ayTe4hPkcbV3uFwIwUOv8SE7r9d++ZzT7ck8e/F?=
 =?us-ascii?Q?MBH2JuKPJ+fP2QzIFfTFkwcokE6Sn2b7y+LbepqR2PKxSwcbB+1iONVA7fQ8?=
 =?us-ascii?Q?8KzjiVcPl9rrVqBBe5wmNaEaDu2KKyBpquBYawXhzY5cJSWAVeDP/xewEqnA?=
 =?us-ascii?Q?N81MM9UF32qwbsFC9jq+HImLjfxDN33n7JlGIo+1EU5Wg7Rt44mlWHhb4TcS?=
 =?us-ascii?Q?a3WQIJTaeVKUtL4RV1eDl0VB1GWy72l6JEwGMO+L4GIorTW8YGdM89MEiTEf?=
 =?us-ascii?Q?qOnyfdi1+3eGDikeFCrWuzUAHKH6cM1tfom1GuoG5abQBJz6EBSKxbLgvdTn?=
 =?us-ascii?Q?UUpPVDohr2UFuDuxo2sXDfeDm7wtQElf03V9UhNF6G4hyPqalKYduikLrXJa?=
 =?us-ascii?Q?i2HeJ9ywlVZFPfQAQRpyPTmdtffAV3vjX1sVYNkzFNNeIAyM18agWNVNiOze?=
 =?us-ascii?Q?+DmfRpEBQUEoVYcBnzTk3KDcQPxDLo+9kCircuyNzRHQjg0Jg/LH2WeNKp6J?=
 =?us-ascii?Q?mVfoBiQURl4sUcWYTu+7ddNDyDiDNxIrhxD8VgKK4v2PeO+OBqrVy9Jrbrp2?=
 =?us-ascii?Q?g0G0n0Dno55lYUwunOna9YCraMp2TeWmaUCNDf8G5JVUQd7T05//i0fWieSM?=
 =?us-ascii?Q?pwstzZmU1ruTnbDyY4COnyGGOW96nDnVO3rmvCbIrjhwOYtVASgDRKoEOPCw?=
 =?us-ascii?Q?symkDxvTXGFJgKkwzDO2XZpYVQnAJcOkhA2UxLcokgI0xrFtnUeLJugTVB3t?=
 =?us-ascii?Q?ql0Sgz2udFQSMVWnWI5o5vDNIYhgmjMYuoYbCjzkQFo55HVab5u29ZOPzdLF?=
 =?us-ascii?Q?cZwdTF+YDU0LPz//hm7fu1yORU0dOlLKW0ilUUmBhemttkgk3+TTimSaVZnu?=
 =?us-ascii?Q?xGSbZK3xDcugnHhM8NYaE9rEFo6GODYVv7lxgfT8ojqXvlW2KAKvpP6xR3C7?=
 =?us-ascii?Q?LMf/fcuTTXZ/tlLlnHs/3y7ktGX5dvxsLrrfbY/Uh8409qzjvE2GvvYGPQAV?=
 =?us-ascii?Q?IfshXNzGeyMpUkkVx3YL81lzlgdOuWmyXKVRwHIeeTZUEXPeBc0NRZevoY8F?=
 =?us-ascii?Q?ka6VBEFPuM3Od5CPOGTzJ++tLkTwnZaxEMW2QTLs/1wO/1wSSwYsrwlib20e?=
 =?us-ascii?Q?h4hMDxVpUIUXtd2b4po+UL8PfLHZV0pG2eKwl7uIhdeD+nGC8Xg5OjomAkWb?=
 =?us-ascii?Q?6hdv9xYAi+3gkS6NSw73FbziN8uwlhp1bG9IuQK9JJldJqk4mR6o/eHRYU+/?=
 =?us-ascii?Q?LXd32rW7PMgVDD8WstpQM+uCiEUVfYpmrDomPF4kmvhia9aUuzWniw7RVdPb?=
 =?us-ascii?Q?YxnOw3f4Smb5oqG4hnKlzfJ5nesjodpNuCWG3qpD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 595970b1-d385-4367-5657-08da6d4b3bd7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:05:12.2632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FALduMDhT5iKac7BocBlMrgyRSWLM+APpT3d2YhLOkSsC/d6Qd62g4ryDMUU3FU6T/PkamjhatWZ8zQqkUgvpw==
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

Rename the 'read_frc_capable' bit to 'read_clock_capable' since now it can
be both the FRC and UTC clocks.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c      | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 6b05586052dd..9d2e8a8d3a75 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -487,7 +487,7 @@ struct mlxsw_bus_info {
 	u8 vsd[MLXSW_CMD_BOARDINFO_VSD_LEN];
 	u8 psid[MLXSW_CMD_BOARDINFO_PSID_LEN];
 	u8 low_frequency:1,
-	   read_frc_capable:1;
+	   read_clock_capable:1;
 };
 
 struct mlxsw_hwmon;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 57792e87dee2..0f452c8dabbd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1923,7 +1923,7 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mlxsw_pci->bus_info.device_kind = driver_name;
 	mlxsw_pci->bus_info.device_name = pci_name(mlxsw_pci->pdev);
 	mlxsw_pci->bus_info.dev = &pdev->dev;
-	mlxsw_pci->bus_info.read_frc_capable = true;
+	mlxsw_pci->bus_info.read_clock_capable = true;
 	mlxsw_pci->id = id;
 
 	err = mlxsw_core_bus_device_register(&mlxsw_pci->bus_info,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index bd7552e8dd5c..641078060b02 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3096,7 +3096,7 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_router_init;
 	}
 
-	if (mlxsw_sp->bus_info->read_frc_capable) {
+	if (mlxsw_sp->bus_info->read_clock_capable) {
 		/* NULL is a valid return value from clock_init */
 		mlxsw_sp->clock =
 			mlxsw_sp->ptp_ops->clock_init(mlxsw_sp,
-- 
2.36.1

