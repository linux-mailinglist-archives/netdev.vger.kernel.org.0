Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E810B222FA2
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgGQAEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:04:36 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:58740
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbgGQAEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:04:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTPs4b4+9cces5pmxigBi5HmKdhdTJSnga2kmDyJcRR1ikcmphKITsp5/dFiNl5jDTeriuGZn+FFx9OZ8suXLN4JHfKJpKxjU6YQNTojPiQ37DjOgmTgTxBwISDSkpUhvPpzxRuEwBoBCVjWwWmwZzKgMDq0lJJLZFfM4SF7G5OXGe3fY1zK9p0JptfRJxvJ/pn9g6oUQUF8SHPM1iwwiKPYWhtBdzE9d21m5Ite7vfYis87MEI/fY/SuzzXK4DdOr9evPKN9JGmIr5JR61lu3CWx7FdI3yn7veHVIh+EqE+uYPcoAV7pNDQRjdbOJrfpTFWe4y4TBRS2f5eau4Vwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4mN8rKMVYE0OwluWkqpCcD+BSxnRQrWSTZnvUhSWO4=;
 b=nONUhjqNmPt9VHgP86l7UMjzVzJSus8dF1CBrM0mhGLNrOL/ZyX3zSZQF4Jn0WHX2xyNkgvwXqz8kc98kOUl9o/gzG7jR72fGYv/bQpzqQpKl029BuaGnXMxutw5tiCDce+cnUJURVpDyISHP7sFxikh3YQBPE8LK74cLZUZnoEhKX0sX7BjBzget4NAQejmk6LQKYegyCHgv38FH9+qUZfZBfE5YGbaHI2eH+BQNDR8DBImTdI5Tq3yiNkF3/buPI2W9443xWsGW4Z+0bi37AfwlLyCPLX8Y5oMR7Nr0b7XwnICMP0qssM2XcdEoRNGkJHH49uVGZr03F4TAlF1sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4mN8rKMVYE0OwluWkqpCcD+BSxnRQrWSTZnvUhSWO4=;
 b=bSHpmGm9ln9WX3b0RiRwjw7Yz6iM/LG1EjZ6b7qWyl7cVaxjbGjSJQBenbGTus/QGHlYqJ7/3ujNZ1oBD/lTtQuhmOwdpK4NRQjjbkVEzUVBaNwTSIFE6c4L1x9TDep1LtR53Gods5nZGCb+HpOlce5nuQdVcycaH0jDRT7BGrY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V2 00/15] mlx5 updates 2020-07-16
Date:   Thu, 16 Jul 2020 17:03:55 -0700
Message-Id: <20200717000410.55600-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:29 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 76eb8c8b-e861-4625-0a7c-08d829e4fa90
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB244846AE54926C5A8FC91EF0BE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kS/ucSxl9avesmL/0b04Y4GDd6YhIbFqlpjLIkG2lD8XkleTDBLmnamIABxCUT2E/0OsHzSv2v9o32U6sIv7RxpOhTx2IhSsdaaSFETQFWiHEDxekcDTxRX4rllTcQ4FfVpXVXsVfZ8aUC4ABzTUj6ZpPIe9KzJ81nm3Bnz7ln+NY4Pgx0RoPCwiqStb90OdDaltR8Y4yN8stNXedvuN8Dfva4H1Duw724vpBdEguj7EdCKqHQNZbx3e2u7uDYqT2NqeAUctTmJh6Dsw9932oRiLwQSJVwXmzFIr0xs2g/Pf368Xrz6Ry+dKTdQe89vQCwA5cJK31inopOWZ5C83JYvlV3R7nJ5dUFenwfvvq6c+wI1Vq40RWUk7bg19KNsb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(107886003)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(15650500001)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GPHpEadevmTjwQyI9IBoEbk1BwApF7tJcNDAlUwqqHU4vmQjdWzSfXiiLECvdA5BcQS4CgYySCSBYzfaInYd6kakgsIdYIxRix+Aet3niEf1JyL3CjfLsylLKHRWA3Xr2jfpsoFi0jxCNje8y3rmArhLj9EcJVTY7MrJJv5BmR/O9UvsCD3KKHC/RnymnS6XdjFXHtxaxHWGWjXySsig6iMmM15bwyF/PFwMQOGTAijyDWJxdNOpo6EnAEagPFZFz/qLHSUrgQOt4zne0CK2YNzu/SikzLWwW4fvoAIXNMEUklIdnvbB7Wql1xy+975G7n/43C79dEc0UUPZCxD4jlKOCBNb7mFFWT2U4vEX9TQ+4epaDzFc6t3jLKOfG8i+5DSjE4MWOJQSEL58DTfjIrlAMOAi9Nf99fpO4ap46KV2NdLal4Ttd1aniVAvH+4P77TadU8mNwDud7JGhEsal+k1r3OUOgvsXDH2L5a4zQ4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76eb8c8b-e861-4625-0a7c-08d829e4fa90
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:30.8359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PLk2vYt98tkxXJSsUn5S4NgGnx5EACOJ+uvNKdY7l9WsHDyDd+BmCKWo0x/LczAH+HCGCNlToCPCONiGZvfjvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Dave, Jakub,

This patchset includes mlx5 RX XFRM ipsec offloads for ConnectX devices
and some other misc updates and fixes to net-next.
v1->v2:
 - Fix "was not declared" build warning when RETPOLINE=y, reported by Jakub.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 89e35f66d552c98c1cfee4a058de158d7f21796a:

  net: mscc: ocelot: rethink Kconfig dependencies again (2020-07-16 12:46:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-07-16

for you to fetch changes up to 54b154ecfb8c66dfeba6578a64e79c2104da4ced:

  net/mlx5e: CT: Map 128 bits labels to 32 bit map ID (2020-07-16 16:37:00 -0700)

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
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  13 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  11 +-
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
 40 files changed, 1473 insertions(+), 211 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
