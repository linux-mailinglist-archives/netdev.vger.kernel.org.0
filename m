Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07AC4830AF
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 12:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiACLpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 06:45:05 -0500
Received: from mail-sn1anam02on2062.outbound.protection.outlook.com ([40.107.96.62]:31166
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229788AbiACLpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 06:45:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7fG4oYQ4NPuIZ0BdL/CteQrZ8L8PRHwjDF6Jxdgq1bS5b55BcrutNG7G77DGs3TDehn/ilL+pc6PlxJZtCa2mMX5VC5ecQVXxclW/7auKE3jqiDJx/iUiy6zxPt99y98uKnI8YL2ykFOJR3nRPK9IhYiZzHLmscO4unw2cvQqoxBEyaPQuLUD+Xm325MXOwaPUKIP84nTajWh0ZMhcPkC/WHPDO4RC+mNrX7gimfBF5dJqLgAFA3YWxw+O7LIUuu/vCt6+3UTV8l/xpPCLQTe/CXzzmY7Cx/YxztHE6Ybi67hfZJI8AIT/IzxYhj5fOkUa1J2kR2hND4kLaPSPfgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCBpDrjcYV5ru4C0Tp1WQIml6s7JWGNP4r+dRIGzv54=;
 b=Vxc+fjw6Cgm22hLSe+ofDI2JmPoCQRTNDHzG6kAkyjHLGYddbbrFp2rwB8ZzTPqTZNtBR7Kmd9EONvTLCqIoU+gN4gHqKx9WM9/4HOkPj73SjH35OffoqG87jh4H2iXwfDNVuvavw789FX45KAZFs9reLTWLg5YOjbTZyNCkI7eET3HPzFZvI5PuydZNYBcezUHfQYYQfJO5MvW9PcBmYGJXaBUDezyX+VWlJDC+LiqLyQMyXzqbnOZHOv8oFxlqkuXzRVcY51lkxy8RLStaZY0UqSz1gMKqOyCNM8FxauKp+CRP83hYOhnLUW5Z44ufAZuNFr+mqrlPx+q/KHZTYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCBpDrjcYV5ru4C0Tp1WQIml6s7JWGNP4r+dRIGzv54=;
 b=GKBglAKzIhIHUq/FMKZ17CRJlmhSmwQql/gMDgS4/8frR1HckIh8DeyTO3MgrCRd6ZcWz7vCda52FlsSfdNTZpjAcDLkHDlj+7GEhFe8XeXNVS7qg3ZHGXSVap6Z5Gyf+jEPaKxIkW7TfPaGJKjmDo+bk3Icbs8oVcPI6VR/lb4u7/NvzKUbyWUlc+t3mRFsu0oM0bUMdG1Bfk7GGNfZw1gLJuYneEJ+ghd/kjtZH2+tAFdAlugu8uVzH6XSd0T9zU4IkBZQpYPHfv+f6XdgftgKxYZqrB1mplcP9+wJPFwLKz93+UYCdgLzqxF2i8BFtAlHrTgpPXFXfWjz9uXB1A==
Received: from BN6PR14CA0010.namprd14.prod.outlook.com (2603:10b6:404:79::20)
 by BL0PR12MB4947.namprd12.prod.outlook.com (2603:10b6:208:17d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 11:45:00 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::1) by BN6PR14CA0010.outlook.office365.com
 (2603:10b6:404:79::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15 via Frontend
 Transport; Mon, 3 Jan 2022 11:45:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Mon, 3 Jan 2022 11:45:00 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 11:44:59 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 11:44:58 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Mon, 3 Jan 2022 11:44:55 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next 0/3] net/sched: Pass originating device to drivers offloading ct connection
Date:   Mon, 3 Jan 2022 13:44:49 +0200
Message-ID: <20220103114452.406-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6523ad2a-a716-41bd-29e9-08d9ceae795d
X-MS-TrafficTypeDiagnostic: BL0PR12MB4947:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB494765B2DEDA5FFF16A69982C2499@BL0PR12MB4947.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQ8+rioPFvs9ioGZaKErUXtEV7uT9Vigt7Wuleq3n772cPAUsrLHc+bgae5mU+K5pmjv9g3WK5BrUhTDvHFppfzJkHiINVBxnyssrq0T/vU42/evmrvx7cNPS7qZvkgBbZ6xJdnUdWa/xx9kzgQausVhvfN0YiXG4ypVzDdDXgE0BlRFxl/zCHA06vIGyb9aCLu92bErQuGF4zdPwwdyPHwj8EeroR+Wh+kX/fuDFj83G2duQBtSE6IVX1chOOjmenf7bF+u4L9GZAS9mnyQzRmF3ag+/NfGO1OEmUj3TXhy6DlCxzUTqJ6orGvblPPbi7yaYZ03hYb+VLugQoPgZBq5EKX33J1lMotxhI1dQ7kYUQ8zEV8qn92lhnD5nsW/5dWKlOSjXatmNaF+aOQv+rgMhulvMC55Ghj0qgPFOZzZDpxduqSW8HPmXYs/H0iRJuon5bFjuM4jvzAf8WPXjC5FHlbJM41mniiX9DNT2fY2a4MG4Ym9d3stXTe7fHdyYbGcdkly+N7TOLum9caU90elk+a7srzOra1Izynq7VlOETYD0eUSDcYvH+cW/ML7g/P1J4dUbYJZj/rDQoVF8Do6pXL7QNj5Q/fFf/kU+sYKpCX+hp80TIbvVut6+q8DJ9GjwxzYcp1IaKepaLIDmjVnxCHG03NlyYYDmdMtmAYHa3+nbknpLn/WrQG8dOULmzWRD7O62faG1D1BC6mu+FwFIgpM7L/PdfWi1mAuSW4FaW4f3oPR1ToVgTr7+MImi9mHgvqbyfOVq+hFCU8PyeG2aHZMBnVvol73TWqnJDWG+aMu2DgCNDFMNOMYo6yx
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(5660300002)(83380400001)(86362001)(1076003)(8676002)(36860700001)(8936002)(921005)(107886003)(316002)(508600001)(4326008)(2906002)(54906003)(110136005)(70586007)(82310400004)(2616005)(6666004)(47076005)(186003)(36756003)(26005)(356005)(81166007)(70206006)(336012)(426003)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 11:45:00.3697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6523ad2a-a716-41bd-29e9-08d9ceae795d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4947
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Currently, drivers register to a ct zone that can be shared by multiple
devices. This can be inefficient for the driver to offload, as it
needs to handle all the cases where the tuple can come from,
instead of where it's most likely will arive from.

For example, consider the following tc rules:
tc filter add dev dev1 ... flower action ct commit zone 5 \
   action mirred egress redirect dev dev2

tc filter add dev dev2 ... flower action ct zone 5 \
   action goto chain chain 2
tc filter add dev dev2 ... flower ct_state +trk+est ... \
   action mirred egress redirect dev dev1

Both dev2 and dev1 register to the zone 5 flow table (created
by act_ct). A tuple originating on dev1, going to dev2, will
be offloaded to both devices, and both will need to offload
both directions, resulting in 4 total rules. The traffic
will only hit originiating tuple on dev1, and reply tuple
on dev2.

By passing the originating device that created the connection
with the tuple, dev1 can choose to offload only the originating
tuple, and dev2 only the reply tuple. Resulting in a more
efficient offload.

The first patch adds an act_ct nf conntrack extension, to
temporarily store the originiating device from the skb before
offloading the connection once the connection is established.
Once sent to offload, it fills the tuple originating device.

The second patch get this information from tuples
which pass in openvswitch.

The third patch is Mellanox driver ct offload implementation using
this information to provide a hint to firmware of where this
offloaded tuple packets will arrive from (LOCAL or UPLINK port),
and thus increase insertion rate.

Paul Blakey (3):
  net/sched: act_ct: Fill offloading tuple iifidx
  net: openvswitch: Fill act ct extension
  net/mlx5: CT: Set flow source hint from provided tuple device

 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 51 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 include/net/netfilter/nf_conntrack_act_ct.h   | 50 ++++++++++++++++++
 include/net/netfilter/nf_conntrack_extend.h   |  4 ++
 net/netfilter/nf_conntrack_core.c             |  6 ++-
 net/openvswitch/conntrack.c                   |  6 +++
 net/sched/act_ct.c                            | 27 ++++++++++
 8 files changed, 141 insertions(+), 6 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_act_ct.h

-- 
2.30.1

