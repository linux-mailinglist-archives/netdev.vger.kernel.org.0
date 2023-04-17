Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECD86E4774
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjDQMUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjDQMUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:20:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE841FC0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:19:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtlbnGXZuCHnLG0Axrj3TdKUgwWGxzEv5RLv+j96H6gEx2R/VMDjU2z+CmMO1ZVxquStiZORpdbm4R1wduLyrQeEj/Xn198iKp2S8hhJ7qlYKoZ2dvmXUUY6zGh31Y+u/vKFuammmgZDiQe0M/LaJZWhDG7y85x/bwUpbQpS8DZxNtzniDFhqkiIA1Ftk1OJtQetqHjPy9fNQJwMNV2TPRqCdpzgrn1ZVH980awZYGgU9CRRAdOM2112Vox9H2vE+4MyRpIZLKzWpcBNEhifdI9jSUK/wY5M9l8Qrtz2I0NuZX+GqIAkPeGTA1mWSd1pRgEQHC5B7jbvC5Iy7krqeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVdRgkmNOT0T/mP9Jxhl5rRvzkBecomXi6ZakO4A8Qk=;
 b=VEEDfXLY4sVRCYMeotEghzR8LOF2Mfq6uYfesiPmqqNX512m4UM/9BmIE0h++CafiDWU6cxSBNhsgZ+g0ud1Jbd0MvQJxJU6g+sl/U/bJNDM/mbqM3R2j2J9bUHN/RScw1z0v49AkavUUgxb1x6x1sKfNwksQN8eDE0s5a2UdD2azeZ4W2GWtQ8bBXw/ZaJhj50/EdeEuPd4j8sHm1H5ml03awf3QH8D512iR/r9XMjgKmP658AHjbBDmWZeZrK6WGDu7hOmCTQ7bDe+EESotTLixbM5gYAn1ft7RPM0A/3pHXpY90EntCCnMOEH+LERm9S9qvlU0xgQiHgGDCoyTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVdRgkmNOT0T/mP9Jxhl5rRvzkBecomXi6ZakO4A8Qk=;
 b=OuPGzcEi8k+HcCizQ29875aIoHfdUT5iL/o77vE58LvwiYvu6YPoiydZuFU06TrTk0OSsYF/lntL++Dhnhr1i4+FSvaRXIy2/UicWpLUAINffH/pDaxphcXJXrDiqXlu+YTYG9OLad6Dvqe2H/1DV7DpdAymgivl0L0ZIeu/peVB3M8zEDgqQNQI8gzaTZw2ME4DjnHljENRwsw8thwDV6YjKJ3DkhyQYIwBnteFR647pRe+7Rim7UWi+3rzLgfjAHYGGOOaqh88FxvwkbIWi/vvNlWGzWGpMQuVOWTsikSLrsZHjYG22POAawPVoYGAZRNYpOfUsAg0bsFhbr9MrQ==
Received: from DM6PR07CA0057.namprd07.prod.outlook.com (2603:10b6:5:74::34) by
 BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:19:58 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::eb) by DM6PR07CA0057.outlook.office365.com
 (2603:10b6:5:74::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:19:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20 via Frontend Transport; Mon, 17 Apr 2023 12:19:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:19:47 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:19:47 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:19:44 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 00/15] net/mlx5e: Extend XDP multi-buffer capabilities
Date:   Mon, 17 Apr 2023 15:18:48 +0300
Message-ID: <20230417121903.46218-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT016:EE_|BL1PR12MB5320:EE_
X-MS-Office365-Filtering-Correlation-Id: e4e355dc-21a7-456b-0c08-08db3f3e0f21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 84AQk2Sg86Vv1j7CoEqJipohN1msZXco45fQwu0edx8ngRv7fp/IoDxBYoyZ/O2VIBzZy+0lWnJqPuj6W2/kDE4noHT0xopzeeGc4CAJDJZ1H0AXiOVFvlseTFfAWRQJJloc8I1MbkUgkhIdbQdh83RdwhAId1L2CXtlwkrKHg4mmhn3sM7DQbNSMCj0KOGVVGu/y7UndlAEHDFUWyubTf8fLHmteJPekUN8a4xmL930yWsX0w1KbvNrOjLfpdELVcGs45TF92GAzmnlXiHMpbKZrIagiLwt9cGakwWNWqlnHBvfkmTlFj7O75RebLrv586tI7WFgOtDROkYFXCYE31IZMGewjiXNeW7nip5rXBnisBjww2OrPb6VIH6vq1flPxW387HHGjX0pwyd7y8bHcfaOiZzZ213Q3gqcSEngbBOpmpl0v36Hui3HBF6xULg3ozn1woRzOnC5iOZf4BNyIeVX/SqJC4IYZlQ8awolXFjGlQMO3Mi1QcnBK1IDBEP2UOZGFwDl/VVX6nAmcv8O3obZCpPEgO0jFJIE12hHHKvVixMY9vOxMK6FU2RNaNNWPbW7fx40AEIsvaSptJS9yh0MvHvmeWXyWM6UgIJL2ytkRQDnZDYPoS3/QdE1t8BZRx82F5egKjE58p37b7CQhL383BWEECxOtTUGVmVhPEAyRZ1yCQgff2nwtF1naoXBFgO7TTynvPo5ax1Dn5RWg1toNwYJeQtQIFyAC/2sTvfhQEyW4JhUNmYcJbsJoOrZ1Zz24CO0jpu0E7lov3QHS4yg2OOQ6e6YsEtGE92/o=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199021)(40470700004)(36840700001)(46966006)(54906003)(4326008)(316002)(110136005)(70206006)(70586007)(478600001)(7696005)(40480700001)(82310400005)(5660300002)(8676002)(8936002)(41300700001)(2906002)(7416002)(7636003)(356005)(34020700004)(82740400003)(86362001)(36756003)(426003)(2616005)(336012)(1076003)(26005)(107886003)(186003)(40460700003)(36860700001)(83380400001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:19:57.5840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e355dc-21a7-456b-0c08-08db3f3e0f21
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5320
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series extends the XDP multi-buffer support in the mlx5e driver.

Patchset breakdown:
- Infrastructural changes and preparations.
- Add XDP multi-buffer support for XDP redirect-in.
- Use TX MPWQE (multi-packet WQE) HW feature for non-linear
  single-segmented XDP frames.
- Add XDP multi-buffer support for striding RQ.

In Striding RQ, we overcome the lack of headroom and tailroom between
the RQ strides by allocating a side page per packet and using it for the
xdp_buff descriptor. We structure the xdp_buff so that it contains
nothing in the linear part, and the whole packet resides in the
fragments.

Performance highlight:

Packet rate test, 64 bytes, 32 channels, MTU 9000 bytes.
CPU: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz.
NIC: ConnectX-6 Dx, at 100 Gbps.

+----------+-------------+-------------+---------+
| Test     | Legacy RQ   | Striding RQ | Speedup |
+----------+-------------+-------------+---------+
| XDP_DROP | 101,615,544 | 117,191,020 | +15%    |
+----------+-------------+-------------+---------+
| XDP_TX   |  95,608,169 | 117,043,422 | +22%    |
+----------+-------------+-------------+---------+

Series generated against net commit:
e61caf04b9f8 Merge branch 'page_pool-allow-caching-from-safely-localized-napi'

I'm submitting this directly as Saeed is traveling.

Regards,
Tariq

Tariq Toukan (15):
  net/mlx5e: Move XDP struct and enum to XDP header
  net/mlx5e: Move struct mlx5e_xmit_data to datapath header
  net/mlx5e: Introduce extended version for mlx5e_xmit_data
  net/mlx5e: XDP, Remove doubtful unlikely calls
  net/mlx5e: XDP, Use multiple single-entry objects in xdpi_fifo
  net/mlx5e: XDP, Add support for multi-buffer XDP redirect-in
  net/mlx5e: XDP, Improve Striding RQ check with XDP
  net/mlx5e: XDP, Let XDP checker function get the params as input
  net/mlx5e: XDP, Consider large muti-buffer packets in Striding RQ
    params calculations
  net/mlx5e: XDP, Remove un-established assumptions on XDP buffer
  net/mlx5e: XDP, Allow non-linear single-segment frames in XDP TX MPWQE
  net/mlx5e: RX, Take shared info fragment addition into a function
  net/mlx5e: RX, Generalize mlx5e_fill_mxbuf()
  net/mlx5e: RX, Prepare non-linear striding RQ for XDP multi-buffer
    support
  net/mlx5e: RX, Add XDP multi-buffer support in Striding RQ

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  46 +--
 .../ethernet/mellanox/mlx5/core/en/params.c   |  32 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   3 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  13 +
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 305 +++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  55 +++-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  92 +++---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 215 +++++++++---
 9 files changed, 519 insertions(+), 254 deletions(-)

-- 
2.34.1

