Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3297760643B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJTPWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJTPWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:22:21 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DB754C87
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 08:22:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEBD+9WTMgUng43mMTaBqPOY/C7yOD0ulX7psyPRhosXoTI/YrqP/1s57xeCBtxHv3nfdJIv/uVd8AdxTEklhoPOMvZSP/4Lu7F/38esg+CSOZU79DvfYxk2/ZcmchTJ8Iec8WlGd1HMBGIbNP4aTwIZs0r24m6jZSgGcYhaZGxIXXHERiboIK3Zi6bUBacNJecPl6ZuPMwhcB6hapigUh/sVp6Rd+cnW//sqLLWOFjpib2khWatZe4txH9+EW2V4B+4URF60Gq1sK4qTsao5+BJz0lp+42K7YnGZrCnhTuZTS68L+FBFoX/rviFnz89w4qoMq2yiBNFVHYRjdapZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OsKisEuot5AGtyg1FCuOcZhWOMbOJY1SnlmRevWLsQ=;
 b=VUVsMUjzGh4Kbq3leTQzJVxmVQv75+/VHJiIjDtBPkdaHb0zSePeJk0THBi/JFfVXU3KKhFo69jBhC/MF2fNZITIfo0fWPxrr7VIzt6JwTCdqDsd/cxd5CQQG7M6IHzyMpGN7i5YDpmTgbu/sglPVJeX8X4cvDTZqy0Xr5uiKe6BUwBAo1o/mfwv23mi8/zPxM9StswRbNXVwsg1taBu5oK8qP7F0fypAHodjN0oc2hD9oSJpu7OPLvQSAKv+AIF9RCAmesSHuvViCg9KLTk1piCdsNxYYRP92fMxcA51uDJeAPFeehbqXp0WLJywrMeMf8vNpABmOaYmouqnK4ISA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OsKisEuot5AGtyg1FCuOcZhWOMbOJY1SnlmRevWLsQ=;
 b=W21Auaw2DjueWfmYtLNFKnrEHKdGhq4WvMCqFqvc/W/YWjIVT72BhxSevLemV/0afvlb+N0iCrkSAY/7/1slAFLjbWFTPhGHqk1dbJeriPtN7HeEzQG/RPiaBEEn9RMW48I1jJgG5C9+SY/7Ng7TubJAksFmL4eqn3Tw80UFCx6uUw/KbDLQn9JqU1yD9Fw7pefVTrAeszZmLQl4nYhsa8sNHrRNw3HWWOKnyDPm8MDM/7yMQ6h7UxB5QIzqWZRXhdlM+qO9aFEd4DAvmuJRGz2Y7Cpcnnd6CqUKPfzdzP0TDuJPhQhEOEe28ISHbtJz9dzCvOi/0RQ8OJ+nvfx8lw==
Received: from DS7PR03CA0152.namprd03.prod.outlook.com (2603:10b6:5:3b2::7) by
 MN2PR12MB4517.namprd12.prod.outlook.com (2603:10b6:208:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 15:22:18 +0000
Received: from DM6NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::c8) by DS7PR03CA0152.outlook.office365.com
 (2603:10b6:5:3b2::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35 via Frontend
 Transport; Thu, 20 Oct 2022 15:22:18 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=nvidia.com;
Received-SPF: None (protection.outlook.com: nvidia.com does not designate
 permitted sender hosts)
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT105.mail.protection.outlook.com (10.13.173.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 15:22:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 20 Oct
 2022 08:22:08 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 20 Oct 2022 08:22:04 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        David Ahern <dsahern@kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/3] Add support for 800Gbps speed
Date:   Thu, 20 Oct 2022 17:20:02 +0200
Message-ID: <cover.1666277135.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT105:EE_|MN2PR12MB4517:EE_
X-MS-Office365-Filtering-Correlation-Id: 744929aa-679a-4630-ac9f-08dab2aee03d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dNZ7qn+XTD4wzsAIDqKP++UjHrboCUrFl2MuRU6NWgdtbiv4W9Z3m+Fe9nHSz6DZpZxNB90eKyLLm5agm9HrWvxLKqmE3+J3fdSZofyl0e1MdvY3RvZvlXxKeLG9Ua0LZKDTSHtlzePb+E5ph/fzB+EeAVP7y9L7PiGdnxJmWOVXd1z7LRVTMiDdE1ma91Sf3JcS5gljFTg0gTt/RE7hNaPODyVkPxiv/CuMKrnbYTGT486kcwvX+qR8RVpOc+/3BQ9WM78/xjsXPIacCOYVz2Ea2e4yetMIIamPxgUvpvBKIvh1HFfN6LMpW3Ba/KdIYCCs1w+sBYgEef1VwmWPYSu49+WjKxjPTP3h6YQyIJEcV75H35LTh0mabEIDH/tNArJWiWu5JrxD2vnP6chL6wTzQIGl1PIxPzxfgCyB6D7flxgKsIm+r65LLXj0LrwlmnIcJMbjbgPM3FJeX9erB9eY4QdpiTFrWGhism1EtDoAzgEhI42j7KrFwK5UzWs5fffuCZZLrLEVMJ6mG82v2mz1YGiG/2arFihjAO8b1YoRNeaHEAEYOIk8ophpBCp3vxtNvl3PwwkZ7XZmETmdmf0BC+FHGAGA1VDfX1mhb6KU83v0pIdz0mbkIkjlahCSIysY+DMAwD68GYcx7emw77HZgddQ0nNWNTeTy8di3aAa4JjOK27CJ6taGAKk+Thjv4WXi3oBqUWZWWnHSoIMpuMD8bM9vg/jY/57ZSBAkvD0ZB07RWsC8YzhdtnvPKHe+IPz8Rk7JVh90xFkR6l4M9fpccts4T4cghgdhF6W42CKqaxBx60a1LYE4L5AhRY2Ez5fU93f1TbsOAOlAvK/wPUVpsyDS1TBpbf8kVe0BdQ=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199015)(40470700004)(36840700001)(46966006)(316002)(36860700001)(110136005)(41300700001)(54906003)(40480700001)(47076005)(426003)(8936002)(186003)(2616005)(5660300002)(26005)(8676002)(7416002)(16526019)(2906002)(336012)(70206006)(70586007)(4326008)(36756003)(107886003)(86362001)(83380400001)(7696005)(40460700003)(82310400005)(478600001)(966005)(7636003)(356005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 15:22:18.0819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 744929aa-679a-4630-ac9f-08dab2aee03d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4517
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amit Cohen <amcohen@nvidia.com> writes:

The next Nvidia Spectrum ASIC will support 800Gbps speed.
The IEEE 802 LAN/MAN Standards Committee already published standards for
800Gbps, see the last update [1] and the list of approved changes [2].

As first phase, add support for 800Gbps over 8 lanes (100Gbps/lane).
In the future 800Gbps over 4 lanes can be supported also.

Extend ethtool to support the relevant PMDs and extend mlxsw and bonding
drivers to support 800Gbps.

Patch set overview:
Patch #1 extends ethtool to support 800Gbps.
Patch #2 extends mlxsw driver to support 800Gbps.
Patch #3 extends bonding driver to support 800Gbps.

----
[1]: https://www.ieee802.org/3/df/public/22_10/22_1004/shrikhande_3df_01a_221004.pdf
[2]: https://ieee802.org/3/df/KeyMotions_3df_221005.pdf

Amit Cohen (3):
  ethtool: Add support for 800Gbps link modes
  mlxsw: Add support for 800Gbps link modes
  bonding: 3ad: Add support for 800G speed

 drivers/net/bonding/bond_3ad.c                |  9 ++++++++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../mellanox/mlxsw/spectrum_ethtool.c         | 21 +++++++++++++++++++
 drivers/net/phy/phy-core.c                    | 11 +++++++++-
 include/uapi/linux/ethtool.h                  |  8 +++++++
 net/ethtool/common.c                          | 14 +++++++++++++
 6 files changed, 63 insertions(+), 1 deletion(-)

-- 
2.35.3

