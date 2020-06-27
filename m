Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD0E20C43D
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgF0VSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:18:42 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbgF0VSl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:18:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EahmzDWgZ6NjVPZeDkkVVj3dFKpnf8nWND5JJmgdL9ebkowS9cOeVbFy0Qc91TC/UIOYBXpAp6qWrzbdg7Sm9+gkL2/IjXxOWzLVJfkxMhJYvr9mnBkiXUzfevpd2Y3Dlfsv3W2EegMgmqDH+mA7f2H9B6F5ADQcPWe4uKuHQ97d8AeAnlduqQC+6gj/4FlbXJCA6lpjsdw3fLFCdBhY2ZLZIoiPR1SH+F6JP8nJxrYMtORGh0X1JqaXTqRKG9RJF1iJdxDm58KsEM04Au6jO8nTLK41OXQUsdCy9c+22+HHGg/b4aKGCKb0tYWO3H+mxXJmwuCbTwBbc7ZT/ETfMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnYSZMp5Yso5RVbE+oCmx7sqjtVaD0aRaI401YEgF+s=;
 b=W138yxhRA9ZL456SyYXOnswSNr5tOAeMgs2BrX6KWQsXQhtv7F70ywESlvzNYwhP6CsycKNvfgK6I43GVDFdgWMAA9lIyTim2O3+FTlyp5Vek+Kq1s+VlZesjP9e/0cQJ7RUJycC8h+zx6iadpvmVPTXd3L9E/EOHswpIn2ayL4V4tL9uCF35KQE/1avxZZ4GZgG4wM8nPRI4S3SL4eHKGC3oyXtmwKtQ0Roq3Xb4gLWvz5J2zsi38UP8+ZyI2327JiUVKizcVps3d7UiDyWypwwZ3GO/0n7PJBpe3VTWYDc0PeWDd3D4v+pUf8OKd0FCKgvaYYjl3SVoFU7AgkUSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnYSZMp5Yso5RVbE+oCmx7sqjtVaD0aRaI401YEgF+s=;
 b=Revm1bobAckl2ZUDNca7rz5wZOWyxDuKUZQrESReHrj/O36N2yn2G8dMZ2LzB5dD+I/dcFkc/4w+mm0hpjTYNN06lxKqzI1v7YlSjSPZMq+5RHDZCHYuzez7cDLQ4Vgs4xXCLuCrftmeA5VB0dAIgUTwdi5F3cGXq52kUmprzw4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:18:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:18:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/15] mlx5 tls rx offload 2020-06-26
Date:   Sat, 27 Jun 2020 14:17:12 -0700
Message-Id: <20200627211727.259569-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:33 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5b7d362e-7e1b-42de-d290-08d81adfa698
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51346D379121AC0CF57F3E75BE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y61vte1JyjRLszc2gKM/b9ebb25gSVYGWmGCTlCJNme6RzZvJiRzTomr6gIT8rVE6R4CWYnk9wHUkLFJ1Z+hh46NhlwV8FFqqIivdUaXTmyTCn9Ngb/RLKpHhq57o4edY6CkVq0wMKoxVWaCBBDjV1S38yx8RcNgWHMQOwGw3SlK/Z957npArS+JQKyGRPT3gXrZ386lABVWQ9lnVkma05idQjZcupJSmhfKMAHIOpVm+zu621DliF5OyJzLGcfQ22twKLKZEjj/L93WVwjByb1Ud5Kh07dAYiVu+TeGA6haeo/Mn+LI7mArGN0LtNfiZY5NBqzUH1FMPA6rRk5acul4RIsOJ41sGcIL62CF35kwzzXZJQqMwN5BA47N6+e8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(478600001)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RDvRNKK7TLBn+R2+6Semx84rf3p+oHmUyiTHdSmjDbTCgPKsOPXkVjpgf6FWB48bkqb1oZ7q7EHWoyNJA4FQrjbGhgaaL+cC9aEMd6874T5y0mxXw0jK0XCWnJPK8ImAasbnY07EWHUC+LEs2rTvCti6fFfXQS92GWWABR24daL54HjZbHZ7kQb5yPmh2mW91Hbnl0cNO4okNoteaRX2p9gTlQbbbJgci8NsXvXBr9aFzwaG5C2bBbHnSBOsuiPr6ebOy+lQan77wAVzjFTy5/y+p1uM6y3/0cEnxGZK10nfuDKum/ko2GZcIm2wcjUyshTkmlPTfhzo3D4XkFHAx57eV0rwcz2yXtuLPWv/NqwD7KEJu/jnxwaqdD2YN7sii/1JCjzvMY9wfOPvutGX+LFzbXOoSsLjsuFy8cC+ToDvBrssTNtmF7wvxzdKOjB9b/SSMftfjHBejgewgo9EkB3fPGzCJNZFiz3dr3AVoAg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b7d362e-7e1b-42de-d290-08d81adfa698
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:18:35.0436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sAPBlCdwT5jyp43TTU+28xhnhYO0E+IsgScGeoQriVFfWVw59XCyEbux+yDyRs4+Iah1iOzPs+dwzX9lHFkeMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub

This is a re-spin of the previous kernel cycle mlx5 rx tls submission, From Tariq
and Boris.

Changes from previous iteration:
1) Better handling of error flows in the resyc procedure.
2) An improved TLS device API for Asynchronous Resync to replace "force resync"
For this Tariq and Boris revert the old "force resync" API then add the new one,
patch: ('Revert "net/tls: Add force_resync for driver resync"')
Since there are no users for the "force resync" API it might be a good idea to also
take this patch to net.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

Thanks,
Saeed.

---
The following changes since commit e396eccf0f1a6621d235340260f4d1f292de74f9:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux (2020-06-27 14:00:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-tls-2020-06-26

for you to fetch changes up to a29074367b347af9e19d36522f7ad9a7db4b9c28:

  net/mlx5e: kTLS, Improve rx handler function call (2020-06-27 14:00:25 -0700)

----------------------------------------------------------------
mlx5-tls-2020-06-26

1) Improve hardware layouts and structure for kTLS support

2) Generalize ICOSQ (Internal Channel Operations Send Queue)
Due to the asynchronous nature of adding new kTLS flows and handling
HW asynchronous kTLS resync requests, the XSK ICOSQ was extended to
support generic async operations, such as kTLS add flow and resync, in
addition to the existing XSK usages.

3) kTLS hardware flow steering and classification:
The driver already has the means to classify TCP ipv4/6 flows to send them
to the corresponding RSS HW engine, as reflected in patches 3 through 5,
the series will add a steering layer that will hook to the driver's TCP
classifiers and will match on well known kTLS connection, in case of a
match traffic will be redirected to the kTLS decryption engine, otherwise
traffic will continue flowing normally to the TCP RSS engine.

3) kTLS add flow RX HW offload support
New offload contexts post their static/progress params WQEs
(Work Queue Element) to communicate the newly added kTLS contexts
over the per-channel async ICOSQ.

The Channel/RQ is selected according to the socket's rxq index.

A new TLS-RX workqueue is used to allow asynchronous addition of
steering rules, out of the NAPI context.
It will be also used in a downstream patch in the resync procedure.

Feature is OFF by default. Can be turned on by:
$ ethtool -K <if> tls-hw-rx-offload on

4) Added mlx5 kTLS sw stats and new counters are documented in
Documentation/networking/tls-offload.rst
rx_tls_ctx - number of TLS RX HW offload contexts added to device for
decryption.

rx_tls_ooo - number of RX packets which were part of a TLS stream
but did not arrive in the expected order and triggered the resync
procedure.

rx_tls_del - number of TLS RX HW offload contexts deleted from device
(connection has finished).

rx_tls_err - number of RX packets which were part of a TLS stream
 but were not decrypted due to unexpected error in the state machine.

5) Asynchronous RX resync

a. The NIC driver indicates that it would like to resync on some TLS
record within the received packet (P), but the driver does not
know (yet) which of the TLS records within the packet.
At this stage, the NIC driver will query the device to find the exact
TCP sequence for resync (tcpsn), however, the driver does not wait
for the device to provide the response.

b. Eventually, the device responds, and the driver provides the tcpsn
within the resync packet to KTLS. Now, KTLS can check the tcpsn against
any processed TLS records within packet P, and also against any record
that is processed in the future within packet P.

The asynchronous resync path simplifies the device driver, as it can
save bits on the packet completion (32-bit TCP sequence), and pass this
information on an asynchronous command instead.

Performance:
    CPU: Intel(R) Xeon(R) CPU E5-2687W v4 @ 3.00GHz, 24 cores, HT off
    NIC: ConnectX-6 Dx 100GbE dual port

    Goodput (app-layer throughput) comparison:
    +---------------+-------+-------+---------+
    | # connections |   1   |   4   |    8    |
    +---------------+-------+-------+---------+
    | SW (Gbps)     |  7.26 | 24.70 |   50.30 |
    +---------------+-------+-------+---------+
    | HW (Gbps)     | 18.50 | 64.30 |   92.90 |
    +---------------+-------+-------+---------+
    | Speedup       | 2.55x | 2.56x | 1.85x * |
    +---------------+-------+-------+---------+

    * After linerate is reached, diff is observed in CPU util

----------------------------------------------------------------
Boris Pismenny (3):
      net/mlx5e: Receive flow steering framework for accelerated TCP flows
      Revert "net/tls: Add force_resync for driver resync"
      net/tls: Add asynchronous resync

Saeed Mahameed (1):
      net/mlx5e: API to manipulate TTC rules destinations

Tariq Toukan (11):
      net/mlx5e: Turn XSK ICOSQ into a general asynchronous one
      net/mlx5e: Refactor build channel params
      net/mlx5e: Accel, Expose flow steering API for rules add/del
      net/mlx5e: kTLS, Improve TLS feature modularity
      net/mlx5e: kTLS, Use kernel API to extract private offload context
      net/mlx5e: kTLS, Add kTLS RX HW offload support
      net/mlx5e: kTLS, Add kTLS RX resync support
      net/mlx5e: kTLS, Add kTLS RX stats
      net/mlx5e: Increase Async ICO SQ size
      net/mlx5e: kTLS, Cleanup redundant capability check
      net/mlx5e: kTLS, Improve rx handler function call

 Documentation/networking/tls-offload.rst           |  18 +
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  23 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  26 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  15 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  53 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  12 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |  20 +
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  | 400 ++++++++++++
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h  |  27 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    | 123 ++--
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    | 114 +---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 670 +++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 204 ++++---
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c        | 119 ++++
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |  42 ++
 .../mellanox/mlx5/core/en_accel/ktls_utils.h       |  86 +++
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |  26 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |  14 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |  32 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |  34 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  34 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  84 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  68 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  41 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  39 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  25 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   3 +-
 include/net/tls.h                                  |  34 +-
 net/tls/tls_device.c                               |  60 +-
 36 files changed, 2054 insertions(+), 454 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
