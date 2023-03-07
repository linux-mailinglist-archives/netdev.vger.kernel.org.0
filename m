Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80FCE6ADAD6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjCGJr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjCGJrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:47:23 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9EB56167;
        Tue,  7 Mar 2023 01:47:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNv7nWJ5nEcVcqfbaLjIa7Es9mbN3ZddC38PxLhhXD2p/NWd3/1omZi2C6reTuv0GBk7faGPeY8oIq2aP3tRaS1/8Q4z3zjwYZ21GCrZKvJDdlWbpjlE/kVSvQ7+nCr9QXsGoY8khSTweesQSAPAFKlFxzp4VgvxCnZ1KF95hNGNjHdYIvQvpOuAW0yWbVlq2PPaegz6qOmxfEX/TbqLsCt+0S4cE4Wnb7bDsP6D6hTcbLAKAEQ1Zpi+BzxDuWn8PyNuV7WeHs0OcN3F8G+mv+bgKdyEtmxaglJ8UM0S2wkWSOg6dXMQRKaFnTgy/vhMt847OrAai5ITT+DvSiFH8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DA5HMa94GjlMbRcd1xSm7oa5D0Tq7NIj3XAs6Syqfog=;
 b=A8vjbK+X9BqLGJzLXIrRk+bCutd7nV5LHttylpnUUQK9p1GXTbjepfpXoKnf/IRmDUXr3OzPHrSrF5h6lM+JHFKPJM/+mHRTf2LEC57ayn9y0YqjKr6QiJq3NC2uCFe8flMgJ+0LZ9vYgiFsXWIRZUmOFtD7Xlga2iYN6Paiu+GLvIMDiMG3lA8eGsUCcb5TDgysp5pfVcfJj2K8SwtsWjDnuS777Hz9rr1jq+SubHyUTRohYF6ckShEDJk9TewJTEAcYsFXLT+v8aU15yzwK96DvcyuHGStcjbptTYSLHUKTPuLc3u/cFzfGLzFaqKwD85KAx4g6ekjBamM8WfTOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DA5HMa94GjlMbRcd1xSm7oa5D0Tq7NIj3XAs6Syqfog=;
 b=sntoBYJJIJDj+aLZXH3xd0RiEvRVtprg2PrJUN9yj7yGRkaa5vEiDRegRKC4NLcrqZm7x0DLiHV4l9Fi5XGdRwsJVn7/Mb8lRAqyKBgc2YrJyXnSDEhHUcb7bB/GW34Ep4wpayxFrDr2I1F4XN86GHae8HNoD7JsGCCDyH41yOf5PJhci7hqFbgMYmelk9Gxf2ibMxmzv+5BuyGCD82ID+gV2l5GjZqdgSU2lTtfD2K21NMiggkldmxWYyukMWOhUT9FslV7m63jVIkM7B4EF+fy1OLle9DRWHSwZSnsSobcQj0INflX+cyDlXnuPpYdQToVdKnocKmxV2rwr/7r8A==
Received: from DM6PR18CA0031.namprd18.prod.outlook.com (2603:10b6:5:15b::44)
 by BL1PR12MB5730.namprd12.prod.outlook.com (2603:10b6:208:385::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Tue, 7 Mar
 2023 09:47:06 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::ca) by DM6PR18CA0031.outlook.office365.com
 (2603:10b6:5:15b::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Tue, 7 Mar 2023 09:47:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 09:47:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 7 Mar 2023
 01:47:01 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 7 Mar 2023
 01:46:57 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v5 0/4] net/mlx5e: Add GBP VxLAN HW offload support
Date:   Tue, 7 Mar 2023 11:46:33 +0200
Message-ID: <20230307094637.246993-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT059:EE_|BL1PR12MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: ad17efa5-0922-4c38-b42e-08db1ef0e988
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aBIfyXHeu64/esGWWiyBRfDhZ6LTeXBG5iDizHyqZX8lws65pnUf5blu9EwBjqFjDQ8syoKowDiaza2BBmF9posr3xfA1i+wnB3LpRTOMRBUDwLg6AQX+KRwLd4nUhGLMAbW7+ZlHT6De7M5QZhV0J0ZOOubS01Civlar5th0UoxOW9cM0tA2k8OAT5KnXIfV5GslakXwYVtjWyKQka6WDGY7z0fw58bGsC82qmcBoL/kb/v61ENdvqfAfkw9pUefOq44c81MEqV1ZKHkEMiFlTaC94aGi6hXnnO6tmZ9WOtX3JjdPPnMMHYTeHyv+wdl8xhT1lxVyw26p+K/pKCSvZRTOeoIEN8ZCnoefbz12yqRQ4B/huHJ4yiioYg9AkLZSp2td+q9AYjeFx2KvPEIN3/v46BGIWXrqPYhCH/QtIbK2ALFsGn15HuGN+lNWUAhvNfGCtG9wz6ZOr/hHY57SriyTXTU6bwyBixCq0uh17JRwsURAVV3+pDyykUmQnq0U76fMbkc4c+WJQ1setpGW6Lvx/AtH3S+kSAlvKIYG41nFZhctyBTe6VDdTkusk/NOQcTAm1xrLbSBa1wPcKFTREstxm0TNFFRmqxnajRf1aBjwb3qJflUKzmNCIERgydpX7h+ZAxTRYlvv8GjxpW8+OcMxRrv1CI+4VG+g6GCbWEgHSTkpY56PkcaJqczeGqk66sYJtJzh5klI7OwIEqQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(396003)(136003)(451199018)(46966006)(36840700001)(40470700004)(83380400001)(316002)(54906003)(110136005)(40480700001)(82310400005)(55016003)(36756003)(86362001)(336012)(6286002)(40460700003)(186003)(2906002)(16526019)(5660300002)(1076003)(70206006)(70586007)(82740400003)(41300700001)(36860700001)(4326008)(8936002)(8676002)(6666004)(426003)(2616005)(478600001)(26005)(47076005)(7696005)(107886003)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 09:47:06.0678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad17efa5-0922-4c38-b42e-08db1ef0e988
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5730
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch-1: Remove unused argument from functions.
Patch-2: Expose helper function vxlan_build_gbp_hdr.
Patch-3: Add helper function for encap_info_equal for tunnels with options.
Patch-4: Add HW offloading support for TC flows with VxLAN GBP encap/decap
        in mlx ethernet driver.

Gavin Li (4):
  vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
    vxlan_build_gpe_hdr( )
---
changelog:
v2->v3
- Addressed comments from Paolo Abeni
- Add new patch
---
  vxlan: Expose helper vxlan_build_gbp_hdr
---
changelog:
v1->v2
- Addressed comments from Alexander Lobakin
- Use const to annotate read-only the pointer parameter
---
  net/mlx5e: Add helper for encap_info_equal for tunnels with options
---
changelog:
v3->v4
- Addressed comments from Alexander Lobakin
- Fix vertical alignment issue
v1->v2
- Addressed comments from Alexander Lobakin
- Replace confusing pointer arithmetic with function call
- Use boolean operator NOT to check if the function return value is not zero
---
  net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
---
changelog:
v4->v5
- Addressed comments from Simon Horman
- Remove Simon Horman from Reviewed-by list
v3->v4
- Addressed comments from Simon Horman
- Using cast in place instead of changing API
v2->v3
- Addressed comments from Alexander Lobakin
- Remove the WA by casting away
v1->v2
- Addressed comments from Alexander Lobakin
- Add a separate pair of braces around bitops
- Remove the WA by casting away
- Fit all log messages into one line
- Use NL_SET_ERR_MSG_FMT_MOD to print the invalid value on error
---

 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 +
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 ++++++++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-----
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
 drivers/net/vxlan/vxlan_core.c                | 27 +------
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
 include/net/vxlan.h                           | 19 +++++
 8 files changed, 149 insertions(+), 51 deletions(-)

-- 
2.31.1

