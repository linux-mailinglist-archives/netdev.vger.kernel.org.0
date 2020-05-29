Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B0D1E881E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgE2TrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:10 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:57981
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726077AbgE2TrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEJBwLGvrqlI9B7uc36F6RhAa7LrNFPmfq3dZr4EYRPar3JX3ios+3uswboCz99a8uKSzfmXOQQE+1/Yv8XFk3X+22OiejXH6eSu/0jK2uc+BQ+3aQdfT40nX/mxpnymm+xjwQ3NsE4vJJbeffIUsxJojKIFcR7ssZUOoVIhPqZ1ZyA+25ZjefuDq9ghnqSTrxWS72k1h6OcLttOWOMkyG3IlOWZ0ETvqhJoSUryicV4oxUWfj17XTTW0nGWY70HGjAE3uY9uA77XfiGr8gXSD96K1AQGUhbIYoGoWYcoYnQE6h5LlgP/dYYORILFx+ADs1HG8TuerB8C3M6p80h3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0qWdP9GTuI2NBaP9X3ipz3hLWR0hGrpxxgacpwy6zQ=;
 b=B17p0ZrlRIKVFirSeGqNdCakHaA3ueohSAMSrLsP1Z9ZeESl33QIpwQgoIJRhCeb9mqfGxB4L+DtdsopACXVbIFt7QFk5ntLQOLt33COFoEKWk1Jv8D2BWmQhsUi3ks6FfSVQq6Ixv8tubPiGqF8Hn8Ai0FnTjQ7teZ/dKUOivuvLSXCWGxhSrZrzKU5MKu/9bFeVs+hsjviNZYhcQaBMALVY0Z0R5qLbBZYvXcbydrImXzz9NjwjIVhfDpjTkAxabXOFBsgs2IOgcH4J/9tpIeoWzJDUxwPeSb2P6nZQehkzzmxbNdNTrdz5LK7vmwkqODDQ0+nRVRoH8S7AbLKTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0qWdP9GTuI2NBaP9X3ipz3hLWR0hGrpxxgacpwy6zQ=;
 b=l9VBMyEIIwF7CVyJKRzTEVtyxl1FMv4Y0oLAiEaxSFm+n5oBAQoJoo7tuP7eoPcTf+EPF24L6cnLs7RPLBEksXVWSVjujWrPF3pEJC/rd6F1Nrjv2XLbrfFepzeTai50OC88F0bi55NFe2unhWES3UIbbg6vjABz5kWxVNlS6AI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/11] mlx5 kTLS RX offload support 2020-05-29
Date:   Fri, 29 May 2020 12:46:30 -0700
Message-Id: <20200529194641.243989-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:46:59 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 34c346af-ea73-4b3a-f012-08d804090e0b
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6589B641FDF913665A3BF80ABE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 636gDpEDCfJojX5pp7dxvx1o66xWdrbkTbuOsOCUXRkFI2BmQPVXIVCh4dup1W7nJ6oPTVXZxxIR9mF4bj3Nj+NnWOczaKIs4KPU/y94K9YSnl5Bv+haepAKw6TcJ5GJKzgSLnKZbwarBr4jcz2m9w6ibtxS5UA2bOU2fbZCDYFXBGALof9a/kaWUnehREFwnkMO57WGGZXQt8zxl56Y5AucdfVvQeUtJMX6KUKoqIlNSoSGJ76JMWPkcMlyDKh0Q/I1Tr8wnL3YUzI/zuQFzqNQ8LARWH1YQDDtXdes/o3fqEWV0sIMTbXXrQXAWE7xGvT1s15yCye1euj3l0Zz8clvbPbUkv7j6qyNkJFGal1pRp5ilGJPr4g5wQHoUIbm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: he79fbdIRd/Q9r+3yOpOn6JHNB+fo+Kgz4hBSA1MM5xCLG08KYjL//SPj/A5dGVMttl9EoEqPtYmg8ukDmhHcmm9F4SxA5xwaiMGi6dKneyzG6J46OVkadZoD58aqzC8PZRbSG+v0EPj/NmmpBOz/bzD+XTEYQtfAfbd3XQsjDU0MBdkIvLFNPEgn1VwBD7YX8G8yXT/8fXAGiRhPln4YGwchh+hYWQ7Gq7F0dY40MUd4o3VLWK27h/3/GFWXTytqDiqMUc5MUdzhT+D6KE3WZXVzadcOouJ1rc8ATpOXz00Tqt9ifVHdFuSq6+6nuLvt9WMEKz1f1OZNja8XcgLCIoWunVbDqQSv0KO1QLbrFcmAXLMOkObDpP6fTh5Pt7jqWef/utkw1mnXbQ9Sg4oOCQzfoPmeoBDa4p1vqyGMqywbZDXvuBT3eJ6RwUVhil6i9FwBPvRv/PtK0cOkQcn6kDLDXnrQcllXmfDHGMYChw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c346af-ea73-4b3a-f012-08d804090e0b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:01.5512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gUkMgV/Htw4XON4HUySddvtBLuxXI8RNmeRCWCymGXo50WdwUtdP5d5RG1PT9XBahsiUQGABVOKv5IlUrGkxAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Jakub

This series adds kTLS rx offloads support to mlx5
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 394f9ebf92c899b42207d4e71465869656981ba1:

  Merge branch 'hns3-next' (2020-05-28 16:39:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-05-29

for you to fetch changes up to 9956363818e903ac8ef1e2d6168e8d0cc19f155b:

  net/mlx5e: kTLS, Improve rx handler function call (2020-05-29 12:39:03 -0700)

----------------------------------------------------------------
mlx5-updates-2020-05-29

mlx5 kTLS rx offload:

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

5) Implement the RX resync procedure.
    The HW offload of TLS decryption in RX side might get out-of-sync
    due to out-of-order reception of packets.
    This requires SW intervention to update the HW context and get it
    back in-sync.

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
Boris Pismenny (1):
      net/mlx5e: Receive flow steering framework for accelerated TCP flows

Saeed Mahameed (2):
      net/mlx5e: API to manipulate TTC rules destinations
      net/mlx5e: kTLS, Improve rx handler function call

Tariq Toukan (8):
      net/mlx5: kTLS, Improve TLS params layout structures
      net/mlx5e: Turn XSK ICOSQ into a general asynchronous one
      net/mlx5e: Accel, Expose flow steering API for rules add/del
      net/mlx5e: kTLS, Improve TLS feature modularity
      net/mlx5e: kTLS, Use kernel API to extract private offload context
      net/mlx5e: kTLS, Add kTLS RX HW offload support
      net/mlx5e: kTLS, Add kTLS RX stats
      net/mlx5e: kTLS, Add kTLS RX resync support

 Documentation/networking/tls-offload.rst           |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  46 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  12 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |  20 +
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  | 389 +++++++++++++
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h  |  27 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    | 123 ++--
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    | 114 +---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 640 +++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 206 ++++---
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c        | 119 ++++
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |  44 ++
 .../mellanox/mlx5/core/en_accel/ktls_utils.h       |  87 +++
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |  20 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |   8 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |  34 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |  39 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  34 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  84 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  33 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  42 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  24 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  15 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   3 +-
 include/linux/mlx5/device.h                        |   9 +
 include/linux/mlx5/mlx5_ifc.h                      |   5 +-
 include/linux/mlx5/qp.h                            |   2 +-
 35 files changed, 1867 insertions(+), 421 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
