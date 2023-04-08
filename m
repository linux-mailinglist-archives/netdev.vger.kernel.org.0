Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E74C6DBA4B
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 12:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjDHK6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 06:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjDHK6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 06:58:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E709E55
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJeOhqlzHmVnAquhVlklaQ4ksEXEkI4gtZnN5IGP+aSNwsFby5120GZ5CXWbrFYulMRTMGFaDy3n3xmKeWtJbGpbMbD5PuAzDBCPB6gpqot+bX2ZWD/mJhTc+jZjIWCPBEnHlqj7HbxHLWt4BsYCMywG1SNtCsG5EEFQlwxA8q6EEheTo7kqctZeS9yT5HZQ/ht40YQfm9E80LeQWHBMRk9tme509Y7zjBSZiE/8p2inBPi8mCWM/Jp1UeB33G3H7xkuUQHVSrvUFBHa8mT11KXp24q+M8jTUnIjoVYgbq8Qscn07YgljH3mmFWmttw/J+91KsSz8I3ZnjWfEy+Eyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyPt75N7vntaf7510fJLLTo3+huT5eS/o9EYD7MYO5A=;
 b=OTB8abSU9aUX9LZ7K/jdSaBN1bGfYni7B4iZIK4NqDCsoCpFVW80vXYUj6xExFQJ624G11ACRcu376bJEbNrIdOc0dvD4JqlvnyHXLqLQ6OIqiy9KDc4YFRF3W9xhXa3YDzOIo09z//YjGGWy9CVpkzH7Y3qpKxE0FCFt/8sRG4cQvGJtvZ0a3W0XZsQszRWpO5fb/NZaJQYqWEj6VAc9k1eO89824TRQ8FsRrmLLUnsu8B5enMviJ439F/jnjNc1hEVh1XMJ6sjcxslmy2se3hfKq4yKOj7Xeib7M2T/EunKmuGdd+cGjO0dry6vVmzrLKE3KaovwQ26zQ2wrPWrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyPt75N7vntaf7510fJLLTo3+huT5eS/o9EYD7MYO5A=;
 b=eJe6RbL1P1eCnC9R8NI8NHtrA4LLpgTeFn3rMOCFK8oy9BTekX9ur80MB1oh0yBl5KbZ7txj5h7sQfR2WaUtMHTTia3nIgzbQ3x//ok+BIBZ/aOMgkGMdJIWVKbKc478tGIlftenT38U7TrEX1jOXMICQL2kNWSYr/iiFPZ75h4DaWGcq08A+pzzW5ug9G7bH3a9NVVTYit8+vX8Lw0TsVwS9dDdvUIxIjWxMisuEh6DqZIpFU8XeE3YG5X4D5TbpSmaYtTDPqfhL/MDfbf4C5cQG7vF6dZ9BvgMpkosrw6dvLmqkEXQLXUUgD4F3jiZzCY+ldQoe79Oik4zwYVf8A==
Received: from DM6PR02CA0167.namprd02.prod.outlook.com (2603:10b6:5:332::34)
 by CH0PR12MB8531.namprd12.prod.outlook.com (2603:10b6:610:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Sat, 8 Apr
 2023 10:57:54 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::1c) by DM6PR02CA0167.outlook.office365.com
 (2603:10b6:5:332::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36 via Frontend
 Transport; Sat, 8 Apr 2023 10:57:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.21 via Frontend Transport; Sat, 8 Apr 2023 10:57:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sat, 8 Apr 2023
 03:57:41 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sat, 8 Apr 2023 03:57:40 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Sat, 8 Apr
 2023 03:57:38 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v4 0/5] Support MACsec VLAN
Date:   Sat, 8 Apr 2023 13:57:30 +0300
Message-ID: <20230408105735.22935-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|CH0PR12MB8531:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a9d7a38-13de-4a9c-62b8-08db38201ae5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jWHpIocfTM1lVCsmxaBCLzvFxH0ndMS4OMswlzC84zUn2oaB2oSFVEVNTC16VvUQSEnTv0jzogn0Ifh9hCUXY+aqav/LssDYwz5fU/pVCf4arWynXLyn3gfFIA/xrsH4rb4jrUM0tTaHCcAtK05J824N8xfLGKG4XJXYmEggKFZGhHAZC9tBsSKbpzzJYL8xZnv76Yhk9ev+tX/1/I6k3D0o1+W7j/vv2wa6obDXGOEXtuRGIVtPc9LcZnPUw6QQYmP5I9dVGLYeRfUIVQ+jDhnzZ7lh6s8dUaOegGOyTIoNfnEGUBjtO5FXOlH40QrZycypS43E4O31668fDdEsv5okzy5hI7rxN49vaGT4WEEj1/aRvoognImhcxrtjMT86raIoLikNgSB8a5OnQWywX1HN2j5wSSFlGJyzLKtTnCsojrqeHmhV/BwuP8YupIGH2u86DtF4ikfFbnDOvz6D6mtHU0BNTVpy5b0cPMziPAVX7xzaHwpVk6kvEf39K3IMHhTACS+b/s7a6y/ptFZvcKKMPXSJadBSDl1BOQQE/kFOTCyUtHeYu8XeZyDQkbzwsZHafe/6oxaSzkbftKY8pzr+2InllGmpNrrmibs+8VUQHvGMv0fKHgmUxCT74uZJ6D1kSC3lKeQEEkp711VtC4IahANt0L+61JpqFeZf6WRtjl0BGuEu2QoAfVf+nJOPX87irNSnCBgxuJWwaxTjAqaG06HgcQrRDvlfkypbgQKNa0XRR9A5CG8pODouP9Z
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(82310400005)(4326008)(2616005)(5660300002)(86362001)(426003)(336012)(107886003)(6666004)(83380400001)(40480700001)(7636003)(26005)(82740400003)(1076003)(36860700001)(356005)(47076005)(478600001)(8936002)(41300700001)(54906003)(8676002)(186003)(70586007)(40460700003)(316002)(36756003)(110136005)(70206006)(7696005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 10:57:54.3000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9d7a38-13de-4a9c-62b8-08db38201ae5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8531
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

Emeel Hakim (5):
  vlan: Add MACsec offload operations for VLAN interface
  net/mlx5: Enable MACsec offload feature for VLAN interface
  net/mlx5: Support MACsec over VLAN
  net/mlx5: Consider VLAN interface in MACsec TX steering rules
  macsec: Add MACsec rx_handler change support

 .../mellanox/mlx5/core/en_accel/macsec.c      |  42 +--
 .../mellanox/mlx5/core/en_accel/macsec_fs.c   |   7 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 drivers/net/macsec.c                          |  16 +-
 net/8021q/vlan_dev.c                          | 242 ++++++++++++++++++
 5 files changed, 290 insertions(+), 18 deletions(-)

-- 
2.21.3

