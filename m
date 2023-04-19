Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67C26E7C3E
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjDSOVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjDSOVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:21:54 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0207F9
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:21:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUHm/pUr4D/OBTyRRiM58W0+4OGAXB2b0hxpbPtWzOzvKGmRZU03w9APZ2HxFmmw4UymNBcHdcyuxFLsJF/sYk4VS1d3OuiRxxTpTgYLuzzYXIwm0beE+fJ3vgo20ducwwC7hB42F3b5KBV4Ndm4s3gbrf4In7QmYdmJ3FySINd9sT7XSZCR7IyRjgpHYQnMg38+x5kD5Ju9L9HHzUUmsj0Kjk89558SQQB1+rMwDCWw7/f9+PTCbrkj52hNXLK9FV1SjX8iYM8uIzaPGpYkICIaGZh8RX9SD9jEYyskv+IwxfZ1y1Lk2PAhPaqc1sYQM36HS6OYbg7KdLUvktA7Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CM8KWF6yHSJCN/X+f03Rk4wiOzpsaaS5Fq7JJXJ9LHs=;
 b=BgcJwNMgbvXTsdhCneuC5c4ReNkem7+lpB5xDHs3VDzI3MPfJANa6R2sX2eNN31bw4+RkMbupYHvnqsUSgk0cQlJ4tCuYZnhdi1lx9+QCOzw+fxhuy0afcMfMIirLCzxvcHGI2nFeYSK8+1d9Yl6UpOPV+kgoK2iU3A4XWghrdQaM5VWRQ+9u/UMyGhigrKzL/lAzb2lDSWa/aLg/2lvZ8uBeC90awAtZ5PTTSmDQEwYH6WI0f20KbzjVy45qKOA4fAxlOrywtLVyjduxo8QPW83nKHMGdYZueOR26CfV/SahxmYdZGLJIk756nc1ZrkwbnKosZlEF5wxUu1PqA1zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CM8KWF6yHSJCN/X+f03Rk4wiOzpsaaS5Fq7JJXJ9LHs=;
 b=QxDpjsfR54y4BJdEJJXTdJsenwl5EcKFt3fEsw77LRHYASKnoGCRJqmsEH6ZwBMgBbgQZChZcP1SdPMyzJJJSOYFWPWnTNVJwAKWhgd+AMP0Royrf0kknouJLC9ZbOvwlBrHe7Bw+VUrEaJs7mJHUdO8GyjQMwL/bd6mBGdrIvRbSdXmotjpTiNZ640QduICxS4n/G50SDKAUmDr38apxwP0z/bArWSg3fQyxGzsxAUZSdBznxTAhrmmHwxNnn75L4TRXCXPvJDGyhNngO5oY54dsoX6hxsQ3BaSsT+l0eQa6zO19DmGvSEg0LIP24cR/ICQdqLo/6f/mTDutCOC3g==
Received: from BN0PR04CA0095.namprd04.prod.outlook.com (2603:10b6:408:ec::10)
 by CY5PR12MB6526.namprd12.prod.outlook.com (2603:10b6:930:31::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 14:21:49 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::db) by BN0PR04CA0095.outlook.office365.com
 (2603:10b6:408:ec::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 14:21:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22 via Frontend Transport; Wed, 19 Apr 2023 14:21:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 19 Apr 2023
 07:21:37 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 19 Apr
 2023 07:21:37 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Wed, 19 Apr
 2023 07:21:35 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v7 0/5] Support MACsec VLAN
Date:   Wed, 19 Apr 2023 17:21:21 +0300
Message-ID: <20230419142126.9788-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|CY5PR12MB6526:EE_
X-MS-Office365-Filtering-Correlation-Id: 81b03c90-dfea-403c-2d06-08db40e169f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JJwLGJoNeZCe1Ajrk2XfoWnTMPKSBlJLUsRq/m4DiUuSJVEgUfkZ7bCv0hX2O3VgdkcHiIyvJCuAGX4hqCkvYSPBvy7/+IEci+ErtAcVhc77CpgOom/zesLP1Keb4CCZ81LpAYOQomjj5iVCIjeKZ9Yv188G1/3L0IurLqYZwLlQIEJucPfj7S65XbabU2VcIcuEKtv7QwHCGB3/Xs3xU/DufP9cV/33VDAWW/+HNH0TeTh0yjRQieKiAHxUsCbJAItxWev/Qi66kRDgZhnmmu10mG/gG3knkdZS/J/CZYWG/pYVLBM/auli/DqQ4vEM1QMY92+HTyzGNHbhbgauq5vCNQiTHtuyxhYXSFLuVslc3LBZzysUuUE1a91WZRFHKtXvgvEmTZ3hfYxj9ijPX0yAT0p1G3zLHpppdnWuE/vwubDY5ZkR9uekEQOuotqBoBBJU27Y0OBs+0JFgHoxIg+q6w7d9QSzvEHttYGRasUEliCH+/nm3SmuuaGTsA5vB8XanJEvQcDIO5hg9C5Lw0ZD/7QZFBIWfOUWb4ztF/Ustgff49fYxWrP9npYth8Tw6WHLMIFZWRZ3vLytmGWhkFa8WfgQvPa5DqRh8OKBXkc3klK19VszJmmBsu+XC74na1xl0HGYEcu2RVU9EWNaqVBdgyD9t8eYmcXNi1qfMcXveVOhJK66WtVMsB6V7eHTzqFHs+ANugNeoR+bYdb7JMKxIJYHkMesN6nEg4Xk26Zqbp3psF8pY78SEROZGDNpFyp5JW1sP+uP4KMeWkXKoTLr8pIpvzuU5hgnr6I0wQ=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199021)(36840700001)(46966006)(40470700004)(478600001)(4326008)(6666004)(8676002)(8936002)(34070700002)(316002)(82740400003)(41300700001)(40480700001)(70206006)(70586007)(54906003)(7636003)(110136005)(186003)(356005)(40460700003)(36756003)(2906002)(107886003)(1076003)(336012)(426003)(26005)(83380400001)(86362001)(47076005)(82310400005)(36860700001)(2616005)(5660300002)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:21:49.0193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b03c90-dfea-403c-2d06-08db40e169f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6526
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

This patch series introduces support for hardware (HW) offload MACsec
devices with VLAN configuration. The patches address both scenarios
where the VLAN header is both the inner and outer header for MACsec.

The changes include:

1. Adding MACsec offload operation for VLAN.
2. Considering VLAN when accessing MACsec net device.
3. Currently offloading MACsec when it's configured over VLAN with
current MACsec TX steering rules would wrongly insert the MACsec sec tag
after inserting the VLAN header. This resulted in an ETHERNET | SECTAG |
VLAN packet when ETHERNET | VLAN | SECTAG is configured. The patche
handles this issue when configuring steering rules.
4. Adding MACsec rx_handler change support in case of a marked skb and a
mismatch on the dst MAC address.

Please review these changes and let me know if you have any feedback or
concerns.

Updates since v1:
- Consult vlan_features when adding NETIF_F_HW_MACSEC.
- Allow grep for the functions.
- Add helper function to get the macsec operation to allow the compiler
  to make some choice.

Updates since v2:
- Don't use macros to allow direct navigattion from mdo functions to its
  implementation.
- Make the vlan_get_macsec_ops argument a const.
- Check if the specific mdo function is available before calling it.
- Enable NETIF_F_HW_MACSEC by default when the lower device has it enabled
  and in case the lower device currently has NETIF_F_HW_MACSEC but disabled
  let the new vlan device also have it disabled.

Updates since v3:
- Split patch ("vlan: Add MACsec offload operations for VLAN interface")
  to prevent mixing generic vlan code changes with driver changes.
- Add mdo_open, stop and stats to support drivers which have those.
- Don't fail if macsec offload operations are available but a specific
  function is not, to support drivers which does not implement all
  macsec offload operations.
- Don't call find_rx_sc twice in the same loop, instead save the result
  in a parameter and re-use it.
- Completely remove _BUILD_VLAN_MACSEC_MDO macro, to prevent returning
  from a macro.
- Reorder the functions inside struct macsec_ops to match the struct
  decleration.
  
 Updates since v4:
 - Change subject line of ("macsec: Add MACsec rx_handler change support") and adapt commit message.
 - Don't separate the new check in patch ("macsec: Add MACsec rx_handler change support")
   from the previous if/else if.
 - Drop"_found" from the parameter naming "rx_sc_found" and move the definition to
   the relevant block.
 - Remove "{}" since not needed around a single line.
 
 Updates since v5:
 - Consider promiscuous mode case.
 
 Updates since v6:
 - Use IS_ENABLED instead of checking for ifdef.
 - Don't add inline keywork in c files, let the compiler make its own decisions.

Emeel Hakim (5):
  vlan: Add MACsec offload operations for VLAN interface
  net/mlx5: Enable MACsec offload feature for VLAN interface
  net/mlx5: Support MACsec over VLAN
  net/mlx5: Consider VLAN interface in MACsec TX steering rules
  macsec: Don't rely solely on the dst MAC address to identify
    destination MACsec device

 .../mellanox/mlx5/core/en_accel/macsec.c      |  42 +--
 .../mellanox/mlx5/core/en_accel/macsec_fs.c   |   7 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 drivers/net/macsec.c                          |  14 +-
 net/8021q/vlan_dev.c                          | 242 ++++++++++++++++++
 5 files changed, 288 insertions(+), 18 deletions(-)

-- 
2.21.3

