Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3174744D8
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhLNO0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:26:25 -0500
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:4065
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231143AbhLNO0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:26:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbN3ygF8J2HqTj3gNu2Xul4+68G9MlfwjsctT43rE89drIZD2umR6zHzVs2wy4KYexu23NwJgWPGDWCHD3v7isba45B6fbLDMoqxAHSMuBH0OsR2o+lJf4z72idpgmYJbL6YLlVSnMGyebIjK4IjZxqyyzN+VRRLlX4oTnmzsVyUV5OaFu3n9fA//XH67EQcJJo7det0vD6lY6PntMsJm8iRYFjU9iv89XUhNMc6kPc1VVvU6mplK/vonXqqmvuQRsqZaxz9cYpgzuGeKFMpNXIf0yzmo+cKlo39xbgPcnZZAjtnZ0Be/vqdwsBIgjq0BgT8Ym92MFa7TrU9J2o3bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0svjKxQIOQnp00aY8PgIwlewMwcRbNN4wmNZv4CGe0=;
 b=MACa2/ncYWPaS9hvTtwiOg3hebEwYLZW7E3BiA1jzogg5itIxEHU+GANKnMGhHxulu8EJbf5nWpFGP2t1ZOl4hHARKz6k2WXKDqXbTONmtJSYrizJcGBKvUGUUqjwOPwbHrArTUY1k59Xh7v0bwRf9pLHMbjmk89MsGZWhh4M+F0/oefhVi3ozuiNIKm6hKYxED4ZYffy4dkZDGl7m67TB/xvVKCDYUveoZJKdGFYlkhVGfCst1sTMD7iaaagWB7l1tK1DRLfdcKJgrsWe+5VCMHQO5OTd9c7ZhY3dd0bdcW4Qe0KpSi190gc7RtIWhZUwBkj33F9GYgp16cHoA6+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z0svjKxQIOQnp00aY8PgIwlewMwcRbNN4wmNZv4CGe0=;
 b=VEaW9j33t9Ww2FLVWiXCD+Bsr+s9rGlSUo0NNLtMGRWM3pSrXTEaW+7TPqIDKg4n6VKFZA90NBxEJGRV7jrhOM3el2DnvLQMQCtBVeXcpNCHGfSDjvKKxa2XNvE1z38SwdLMQ+/R+FqHFfcV09LD2FYzvrySlbWNCvoaHHIVkNQ4x0oYw7CaOrr7QlgHrI8HHQUiQFTd6gjZYFcsluFDx13puICsNOve9hksLCsMxHcVGVD5bQtg3M9HR0NjKQgUOsmTaNEy3DY3IGC7UkZerIo6ueHxTTVVTyZQ/cSD5lv0OweESg6AEDDjMOfJW4pr0G+lawzn4htvy+5Qm/qNOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB3031.namprd12.prod.outlook.com (2603:10b6:a03:d8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Tue, 14 Dec
 2021 14:26:23 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 14:26:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] mlxsw: spectrum_ipip: Use common hash table for IPv6 address mapping
Date:   Tue, 14 Dec 2021 16:25:45 +0200
Message-Id: <20211214142551.606542-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214142551.606542-1-idosch@nvidia.com>
References: <20211214142551.606542-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0184.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::23)
 To BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR2P264CA0184.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::23) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 14:26:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed43afb9-a147-48df-2371-08d9bf0db42c
X-MS-TrafficTypeDiagnostic: BYAPR12MB3031:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3031A99D0FD040ACD6B4D7D0B2759@BYAPR12MB3031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qq7vE/Fklfy2Rzb7zKjj60hk82ZRg/v6UX74b/+4KOQLzdzIyLaVlbwGdKH4C32pweyLa2vyZWc+v7gz1yxrUO8Bc7C1XZBFbEQWQKcrSRTJYL2ljgihmDWM0TSz2iM53V1wXKyzS8XQfvIauH3P8PZs5a/pcZlHGW4hqyHlfETthtd9wVrE5HLAxOZAIUmb52H7ijEQ9o8HtrDEnNc6yNYyB0BR6l7PtnmBy9T7yNMvrK3LEBrOcKxtr2Ue+lWLG8HiNvzdGB+32BwlSmynIxMLnQQOlGwC9aJdvrSFW5Qjxa+Ktzgzj49ewWRX0upu1oeuT0YZSTt1L6Z4b3M5zeOT4zXHwlcvX8FzZAOmvyIEWOsbKWzYgjzR8WPnyOAmjTOrEcn+oD3Gxq4mZsWG8OFxvn7ENNDdsG+BYHhMBP8iIK9jYCXGyIliZeDZatPvUwuhzmUMFqIDjwtmURMaIHrl7H3WWe4jHt4DDiOng4kpDmWznOin+JYuONR+AOvCKiZ7/vVtxRXBDRz8du7dSn9haG3OkMbTzy+EPVuKMwsswry1H5p8f93e0W3bkPXhcpBT+zbKpyAu1/d+eLzYIIIA3XwPubaFATiLT2aRZTZ1aqISZ6QnjpIVwj4aIGDznarja5KsGgMfyNU0NuWwiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66946007)(6496006)(508600001)(8936002)(83380400001)(107886003)(2906002)(66476007)(66556008)(86362001)(186003)(38100700002)(316002)(4326008)(8676002)(2616005)(1076003)(5660300002)(6486002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XX0mdHh9JUtJk69257NPMQL/NUFaqbCDGXHLRpUjl59U+Fd7igqrF3jS8SzG?=
 =?us-ascii?Q?7RXKWXOSp+7s+7aPlb1QaSxS19wEHsdFHvuNXgZmniPb9qAe/EUzNgxMlkZJ?=
 =?us-ascii?Q?Z8mCjRQGounhU5ZJmDeqZk2uhLDqiZpmhCKjUgLR2AG04KPaNbTbuYM+iPwW?=
 =?us-ascii?Q?K3YF4tGjVTRBGXeiVPCkBGhLvq7WphTC9fLvQ2goE0u9Ugo0SW5UyjsmAfWo?=
 =?us-ascii?Q?03dT4fKX10VBPoOac3JxKgmJzjxQtAzU2Shn+km2pGqZkNLfNtTCYNToVMPe?=
 =?us-ascii?Q?jIo3/bxOcB4A8NKOifra196/1jj+fhsfhkz4Aqjw08S4q/e63gt48+AlIWK9?=
 =?us-ascii?Q?ha+kJe4XHEc+P82KBi9yGV9AFTOYmrIxagTqFd1qg8WfEJ/3tp22G0P46Qpn?=
 =?us-ascii?Q?ja2JFXgFvq3vQgtCmjUeL3ojg/XmzOcEjkzkEfl8ssgISe330Agvw6UNyQAb?=
 =?us-ascii?Q?KKRlNcq9xVS/3dAA57zvabGl7LXT+lpr9iHtHK6m/aLpdSjXNYn139I40DfJ?=
 =?us-ascii?Q?kJHZtH05LUTfem7IutvYCo7qHqEk8BygNXuvW5GnSugnuQlIXkwPAaLSmkOd?=
 =?us-ascii?Q?AYm9rU+m/uHimj5EbHUnaqcbCwyG7ggHjXjMzznHggsur4U/oX/FdvtwJyTe?=
 =?us-ascii?Q?yXqIOhhexQ0bNg5c9PmLZQUgHOIHMc4KahzC2OeEqLyMmaEydZkU3ELQLwV9?=
 =?us-ascii?Q?9s8hMWyAQER4lbhFqfYMKQRScuk4fqMWvslKkeQ8foff2s00XauLgZNvmJtG?=
 =?us-ascii?Q?pmDnyy6e0GMvjG3Agfr6ehaWFffDhSRq3mvcNUjnTnsiVCacBBCoZlHCVVlf?=
 =?us-ascii?Q?I865M7w5rL4ds9OuynpNokl8WU1FqilfT8Qm0OK4A5wHhA1UXUi3tDrTHs3M?=
 =?us-ascii?Q?ZZmtTEoFjTYPBNZ+tsP/4mEovINuiV3NPJR5c810x/4SnbYPvoz7QU994gCj?=
 =?us-ascii?Q?oQaNbsTLnmRWw10UWq8RjZyAyoLujUYj7+XVdYABzeI11+Ki/Dy48sAUg1Ly?=
 =?us-ascii?Q?Z31ogBI8W24oDhSNDAYxL3/1lVmnTBVLVf8cqH78sHZQ0FYwx6zqiu6y8m8v?=
 =?us-ascii?Q?hp+qmWnEFrhUp2lQzH2ZiT3Wc3dEtjvL0hGY6Wvk5FAIwrV+cGW6x6FBFLJJ?=
 =?us-ascii?Q?JX8LvcnNOWG6GUgJAfwU2by6C91/ehk1VC1E90TvzHkevoWYrQgx0GULVEes?=
 =?us-ascii?Q?6ap/k4Fq2CsupKzSteCiB71ixo2hwmVV8+fR/EOaf5Za2PuZCQUq/Cw2iOnq?=
 =?us-ascii?Q?Mx2hhc9PXieoFRWDON3wRGXJjBOVXE+QNiDhhe3V7DyWHVuM8GhFHvxHUOzn?=
 =?us-ascii?Q?cE0FiomyIEUbayfkwe8hyCZHjEaKWNCtWIxCNgAlffyK44IJZTjzg47ucYCA?=
 =?us-ascii?Q?vbQymIj4jah70qxxspg3VQ1QY2ozjBOjismSfWk+kCumLHolVQYPJsLL0KwM?=
 =?us-ascii?Q?vRxbpnNuauL3w6hYTC1lZg5fN5SqayFr3S8cXrrW6DkaePDe+xUT+bkRYlg5?=
 =?us-ascii?Q?B28/qkePVAAZSWgrdZbWkgZo/pHDWwVAvcjAYrD6zlHOnuFObUrQAxE4Q15O?=
 =?us-ascii?Q?gmRs7VA4HMJTHj0DhO9D+T3Ot3i46VJg8pLys6rV8LwHNlWaSlk/TvEqwSl/?=
 =?us-ascii?Q?GBqplUcuua6G06WM4zxJAI0n+/FOLM9mRyt7utzsrDx2CCijOIo7WnoGfP7O?=
 =?us-ascii?Q?MgDNndzYUSzaZkI06EM7+Av9ujc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed43afb9-a147-48df-2371-08d9bf0db42c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:26:23.1032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dvEC8Q7GWz9cTQlAZvEjDkR4vbwpGzJLUP2mSxnYGoyGpNVvvPR3fRk+4o0I937pq+rUVv2MgRbT48QcRCzN8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Use the common hash table introduced by the previous patch instead of
the IP-in-IP specific implementation.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 28 ++++---------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index ad3926de88f2..01cf5a6a26bd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -568,37 +568,21 @@ static int
 mlxsw_sp2_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_ipip_entry *ipip_entry)
 {
-	char rips_pl[MLXSW_REG_RIPS_LEN];
 	struct __ip6_tnl_parm parms6;
-	int err;
-
-	err = mlxsw_sp_kvdl_alloc(mlxsw_sp,
-				  MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS, 1,
-				  &ipip_entry->dip_kvdl_index);
-	if (err)
-		return err;
 
 	parms6 = mlxsw_sp_ipip_netdev_parms6(ipip_entry->ol_dev);
-	mlxsw_reg_rips_pack(rips_pl, ipip_entry->dip_kvdl_index,
-			    &parms6.raddr);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rips), rips_pl);
-	if (err)
-		goto err_rips_write;
-
-	return 0;
-
-err_rips_write:
-	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS, 1,
-			   ipip_entry->dip_kvdl_index);
-	return err;
+	return mlxsw_sp_ipv6_addr_kvdl_index_get(mlxsw_sp, &parms6.raddr,
+						 &ipip_entry->dip_kvdl_index);
 }
 
 static void
 mlxsw_sp2_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
 				   const struct mlxsw_sp_ipip_entry *ipip_entry)
 {
-	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS, 1,
-			   ipip_entry->dip_kvdl_index);
+	struct __ip6_tnl_parm parms6;
+
+	parms6 = mlxsw_sp_ipip_netdev_parms6(ipip_entry->ol_dev);
+	mlxsw_sp_ipv6_addr_put(mlxsw_sp, &parms6.raddr);
 }
 
 static const struct mlxsw_sp_ipip_ops mlxsw_sp2_ipip_gre6_ops = {
-- 
2.31.1

