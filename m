Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84006E5C0C
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjDRIbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjDRIbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:31:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ED2728D
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 01:31:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+QpPFLpmKLT2Nr/+SDZg0qQDSvW/pJ/qGgIPigDuycxQRnQf4pMfn4/E4KZ7S9MUi3+MoQasqg5/wNS7mOIdvXpMx7x5nqnbA1Mw8hN2jvdtS9kfIMyQbV2bR/iJG5c3gKLdd5wfrR7oLvIqHm0dDLba+0COMPiDJ+Pj9eTNh6V0oxYQvT6N5K3+SO3NUy3tzGyW6zus9R3YDg4tDgZsvh2XBev0aw0sMG4c20RWjCUkLUHKDytiq3dtsdxeSWpr5ynseUjl4sV655WBOyKA3beDo8i1/85/DbZUxfE2FsqjFK3/mFSNj60o2GZESiA1alHbsdoImXkSDara2kk+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UWmjrG3UrCtfWYbl9XIyKrzeJzXBN9r7Zy3D7KzEYzY=;
 b=gHfzyV2NJYO67YJrpMNENrcuo+4CmrJZ1QivT8d1f2mOwbOET2sw2XaQOufE6Mxjf97/ix9G+s+e+ohAV31230UB59nl4Yt7B8t/QNkbonHTrsvgNlMcRxawH/rnYQTm1pA+SO2+NeegHgvQSoAxoihWQecRgW8hckAkohMEpXHkDOOA8H2M+kjka4p1eKw+zpWq6RZqGgYqU1XEMa/bhAan5wH4Q5auUZbNV32Vi6ECCFkTBeF8lPc1RzU95ACZZ/HcSzYXy968ouu73kmk4uAPlbDMufiX5ZwDfpPVFfmQAVkR3T95JLiigQpLUIqQ9W3+V4BNIfrTAIYGwR72Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWmjrG3UrCtfWYbl9XIyKrzeJzXBN9r7Zy3D7KzEYzY=;
 b=PZwS47ek/LQDT3NGsUv9ornfRfp1FTAOudbMgXWIMxK43+nRzVg7ZdUn5BeNo9tE7YptSW8i2PLTID+ub188fdYwO7ymfTaIT4wpm7pE9PPxbpC/3wl6+9aYKmvZlGo7GX9rAtihp2J5efufoQxcNS8FYmnrdTwZhVxbCShtFDmSu1uGmlMio0ydu5JZHkzVVcD0ZomfpvVgP1v6UnWAWBthiqa/hirjQYC2pxHT06YP2LDT8ywocd6IKmNPfQ7MqrX4ynhbA7g2iDhGzP5ZOi1w9DJylmgPLLca5d6bs8zeI/tuVq+0moo50XIABVwLFFK4mIowPHP6SjLsMJ6TAQ==
Received: from MW4PR03CA0279.namprd03.prod.outlook.com (2603:10b6:303:b5::14)
 by PH7PR12MB8156.namprd12.prod.outlook.com (2603:10b6:510:2b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 08:31:21 +0000
Received: from CO1NAM11FT107.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::88) by MW4PR03CA0279.outlook.office365.com
 (2603:10b6:303:b5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 08:31:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT107.mail.protection.outlook.com (10.13.175.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 08:31:21 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 18 Apr 2023
 01:31:08 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 18 Apr
 2023 01:31:08 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Tue, 18 Apr
 2023 01:31:06 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 0/5] Support MACsec VLAN
Date:   Tue, 18 Apr 2023 11:30:57 +0300
Message-ID: <20230418083102.14326-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT107:EE_|PH7PR12MB8156:EE_
X-MS-Office365-Filtering-Correlation-Id: 44641edb-b594-425f-4ddf-08db3fe749f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hDAiZ+xpiXDRXhBAcUb8DWZi0g7Z+qxdViQa1X3UVnome6OBDoIV9gzedqw5ebGxWy7IIWTeEsjbdoWo/5jAHLVxc8ClUz1utNrM7VQvnfJO5u+w6J03jYidhFGnUD0Y+zTpU16f0imx1+qpJglKdNXIg3e7CejA41uD13xHV07fvvYLAhs6a3lY/QBKmZVJFF/gcbzFXOP5fa16HWubPuZ0Y4PqzY+32lBwFoeRC8XGPPGgHbstyB5f1MSurPwQB0wrbdQUdNbToyq6g3yCZ40h0heZi6Fj4drvT+mkU+1JFy9R20eZ3neMS3f6njT0An4NjJPNt+3d56Nlg6EclwUbFjiJIh8aAFmoy4200BuxLzgTxQkGa1qx5k24GGN3z0N2ogmTckIX0yWayDxutTh68+lrwcHvFlOUpT1ToTWxkfHuW4mPKn2J9PuBfk72IG2WnhNSu+zEvDOATKpc3DMWEu4YemnH0R4/xIDvaqYfvy2eWE3VCxUPLE3KFvgKjMtsLmXivLST/Or+5RH7OqilcQ3a+CVHznUyOrm7gM6197lhGgYuFGi1IgxW/QfsLuuRkbGgKEC09PpTgXFZdRoIUAmoNBypIsuAjJpHNh2WI6dNNzSuDgsmmZHJjjr9rZ2C3II9Gpnzqt6V3JV8xzNaKD6vHkq74emz9yK0OXQRqrY4ITxwdXaynOZU2t0+A8bqHQAyDSZZ7lSJIFGbMRA4n/vgqK1z0CzEAmXN7TmUjr2mF6Cdfcl8JmJZtGtGX0iYnzA5mHpQNCCT36gDawi8/jw7lEzBg9cdbaeGfcI=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(1076003)(26005)(40480700001)(82310400005)(4326008)(40460700003)(186003)(316002)(426003)(83380400001)(47076005)(336012)(2616005)(41300700001)(478600001)(54906003)(110136005)(356005)(107886003)(7696005)(70206006)(6666004)(36860700001)(70586007)(7636003)(82740400003)(36756003)(34020700004)(86362001)(8936002)(8676002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 08:31:21.3059
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44641edb-b594-425f-4ddf-08db3fe749f7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT107.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8156
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

