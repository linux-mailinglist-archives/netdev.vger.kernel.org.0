Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BBC222E06
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgGPVdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:33:46 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:23206
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726198AbgGPVdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:33:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQ3bqXTbJymh+cpDSd4vjy9B7ifRm9nHwavyZkJAxkqXqmuzR6n6wxUWNm1NM0boBmf0mWChz1T+1OYKWx7kqv6IPPSxHTYN+gPgEjXoSl5OPeKSNPAMyDBV6CDqXH2UDMJP6ITs+DknZFr7h+i7oTt3uEKNM7/WfvPjgSi56vXKTpuYhskmIRbCrzFuBzzIk5OqVp6eHSZ9yz0eyjhwTZt6DsCOV4w7vmItSU0jM8x/Blm5FRLtM/cd2CAqMK0pjQtl4pyov9IAvO7bXAwxKu+AJ15kViCRXFOzNc7ZGc4tKBVMQKkpgIN5JroZTQbYcFnU2Z0rfNGUz8nux0vQmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRHMinvT+tMzSf+oG2YWp0f3eP3FFn3P+R+IBuQarDE=;
 b=KO5rBsNeLhXxdC4EdI2Q+m3fN0gTPYHz3Ha6Gk7SRbYWSNIepYMN4kW76JTA3btia6Km9dU3YKDlIhtbzE+KxYe5I068GBvPJou/3dqUagpN16EckDOjGTO39srlsom5Th/6CfjORiNsHqS+x5hDfmH+7FBgiIpNYvqOB/agVV3sYlSzayZG+ZoYNpukW8UJQIKdvne2YZ++mAf6lavlxg+b1NvyvQuIT0c9N/6sHV3J8tCm2u15AaEvQwZ3ghxAU9+KPLpiHO1QReo7j1EhjavGou+ZWAQF6kVr/607eIOT3VCoqawJHO3Ql3mi9i3iFWCOS88L1unGtMved4tsQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRHMinvT+tMzSf+oG2YWp0f3eP3FFn3P+R+IBuQarDE=;
 b=US1GDbcblqgThW7oCkwSewyUxI0jrluSpqPBckOfJcPh5gBciSocvJHHXTeZzNO954FNBAmjbrEdri6JAcCH/P3GV7PC1f/WHJzGx/8t1Ug3zyWC9Ua+uu8QLX/7lzh6JWekMs3kUnCKghQFjawNxCd3mZsoUBnNSTcqHwlfS5o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:33:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:33:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2020-07-16
Date:   Thu, 16 Jul 2020 14:33:06 -0700
Message-Id: <20200716213321.29468-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:33:40 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f679bc9-c9c5-4061-5176-08d829cfe8de
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB29929013ABACF91AFA1BB3CCBE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9uNDKpuWllA4fv4ACnSrPhXN3MTqQZpBqo1YG4CMzupW/XMcikQptnKyZPbBu1i1eZIw38Xq8FNQ6DKKsWlEVJEPMviOgZLQpJfELp4Yi8hzgzL565oic29Uegd5gimTLm0sh0qP1br5P04Vt31azF5PkIdJb5OtfPBhRKqPE/fGhYGF/luAt6ihYrEAt9STPAWo42DtfEJ0GsHvjHkO53RaIj7zmgQdJDc+dkgUmMtobgZnTpd34CU7K6VvsAFYOHhaWp1ElTg25dnW8k9hyRI5+duKwPhGuF5ApEOc3nQyRNcWeSuBLeNrH0kg1RbUHsHRzBHPwWpYZOjMaxvmdVfSvmo8Bb6enr1gcHsj5IBcL/kfW5I4uR6yU7wGV+q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(15650500001)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OIpjZE2LsNIgWNFexVXXrjTD+tQrH1lW6Wy6U/XlWim47UCa4Yr6wNoLyiID9H1kvJ8VzN/g8jp9cT7J8XtT+8vE+Qq/Z+596bdPM532SdTSTm2HBuQJ5RlDhp+b08S0f9n3r45+rknWrzSEgvxnGr8OQND3uPk/OgtrvzlN2+Um3M/9T2LShzS88S8zYDOQ3MzNmZbCFToxsQouggzn5uRM4ZQ/dTx3W/hzC8oGBGAo/ZR0QQjj4aCBT7iyPbcBBhO6d8i9V/Er+aTq+Bc5vgZp1aXs45Gq7G8SITGgaP6NUl3GumA6/mM9Iu+t7kXdqu6xIQkEUk9w4jYEDxi4Wx2SqLcCHBcboWz+BGOYKAu5Myq+S097qwbxojHp1HyXarA0eKH9TdmvIKA9Ddob8Xv/T5aqKA4bXf7VYi3GLArWLqrTXst8PD1uJwGldR/NyOfalC3NLTrNdXUE1finE6tkMpcryJ8gi+u6ATQHi0U=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f679bc9-c9c5-4061-5176-08d829cfe8de
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:33:41.6897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NegXFtEcYCiljPp8n95JRK7LX33NJ7CO2y/wnBeN5kuBYRo/gF5CCSatLhX+gtklXkROc3Url+zSM9jMdZS4hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub,

This patchset includes mlx5 RX XFRM ipsec offloads for ConnectX devices
and some other misc updates and fixes to net-next.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 89e35f66d552c98c1cfee4a058de158d7f21796a:

  net: mscc: ocelot: rethink Kconfig dependencies again (2020-07-16 12:46:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-07-16

for you to fetch changes up to 3e6ae272202e418f8184caa71b3fc37b62fb921e:

  net/mlx5e: CT: Map 128 bits labels to 32 bit map ID (2020-07-16 14:28:20 -0700)

----------------------------------------------------------------
mlx5-updates-2020-07-16

Fixes:
1) Fix build break when CONFIG_XPS is not set
2) Fix missing switch_id for representors

Updates:
1) IPsec XFRM RX offloads from Raed and Huy.
  - Added IPSec RX steering flow tables to NIC RX
  - Refactoring of the existing FPGA IPSec, to add support
    for ConnectX IPsec.
  - RX data path handling for IPSec traffic
  - Synchronize offloading device ESN with xfrm received SN

2) Parav allows E-Switch to siwtch to switchdev mode directly without
   the need to go through legacy mode first.

3) From Tariq, Misc updates including:
   3.1) indirect calls for RX and XDP handlers
   3.2) Make MLX5_EN_TLS non-prompt as it should always be enabled when
        TLS and MLX5_EN are selected.

----------------------------------------------------------------
Eli Britstein (1):
      net/mlx5e: CT: Map 128 bits labels to 32 bit map ID

Huy Nguyen (2):
      net/mlx5: Add IPsec related Flow steering entry's fields
      net/mlx5e: IPsec: Add IPsec steering in local NIC RX

Parav Pandit (3):
      net/mlx5e: Fix missing switch_id for representors
      net/mlx5: E-switch, Avoid function change handler for non ECPF
      net/mlx5: E-switch, Reduce dependency on num_vfs during mode set

Raed Salem (4):
      net/mlx5: Accel, Add core IPsec support for the Connect-X family
      net/mlx5: IPsec: Add HW crypto offload support
      net/mlx5e: IPsec: Add Connect-X IPsec Rx data path offload
      net/mlx5e: IPsec: Add Connect-X IPsec ESN update offload support

Saeed Mahameed (1):
      net/mlx5e: Fix build break when CONFIG_XPS is not set

Tariq Toukan (4):
      net/mlx5: Make MLX5_EN_TLS non-prompt
      net/mlx5e: XDP, Avoid indirect call in TX flow
      net/mlx5e: RX, Avoid indirect call in representor CQE handling
      net/mlx5e: Do not request completion on every single UMR WQE

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |  28 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.c  | 108 ++--
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.h  |  45 +-
 .../mellanox/mlx5/core/accel/ipsec_offload.c       | 385 +++++++++++++++
 .../mellanox/mlx5/core/accel/ipsec_offload.h       |  38 ++
 .../net/ethernet/mellanox/mlx5/core/accel/tls.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  59 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  36 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  22 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |  10 -
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  47 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |  10 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         | 544 +++++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h         |  26 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  56 +++
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  22 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  11 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  14 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |  51 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h   |  37 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   6 +
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.c   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   9 +-
 include/linux/mlx5/accel.h                         |   6 +-
 include/linux/mlx5/driver.h                        |   3 +
 include/linux/mlx5/fs.h                            |   5 +-
 include/linux/mlx5/mlx5_ifc.h                      |  12 +-
 39 files changed, 1480 insertions(+), 211 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
