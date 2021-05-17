Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD25383B20
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbhEQRVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:21:15 -0400
Received: from azhdrrw-ex01.nvidia.com ([20.51.104.162]:1244 "EHLO
        AZHDRRW-EX01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbhEQRVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:21:13 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by mxs.oss.nvidia.com (10.13.234.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 10:04:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8CCqAtzqNqGzEhyGH7DdNytkqLbsLwx9hJnmTOzPErInevVRpZM9veTuytgzXobgHDNomoR5SiUBoWrjUnaU5algIZaWH1kOi9TSsCJWF1ajaTe9qY02WMJhUF66SeqWmYdDnkAyo+aMEYDyfdrFiUtYcJWwzvN6h8+WHy3EuxizRsP0K+Qg7li23k2uoRRS+bouVRwHYlLLczcJIbaH4HqRGxN+FVW2LXKvQ55ILkcklt7TEVen2XZkfwPb32aNgITjHXYfl9VVWM4/QejFQUkJ796w7Llsy23QPOspjrwwd2HMdai16kQEelEU+PI7RFCHddVxfDmoBFsiQ1+iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6m1TZjTw7yY9wwsHwC98JGaYwljm/eIwSwWuNWJz9Y=;
 b=KJsrbpcz2zgZFtI7XJNcvTxXKHmCfTsuncRrtcEhqCg8D9PFYeugVZnaIQGPqUwTdvbF5CpVHIwB1i0UF5nU5nPyt+oMrCLkO2EjLRcrWYhj5+qTliLVnx4bAYUN4fBjrqQj7lDKBBdF9HDTVObVAaoLyW6MctpnF+S2QunhAZgzC1QZPIyTbPrO6bAGN32pJbotd5mt7UlzXxbFPIFBr4MUMqXIZlRD0MAZyWz82oJWFIECZdhVvGSOr0sLz5K/9lqyzCG0Nx/lBT79I2597OUVQ4v/Cjqr7Aqh5AC6sYpZrGwnhoI3G1NYXUt6Z+Zlqdc0uGNBpOIJ6n1aW3B4RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6m1TZjTw7yY9wwsHwC98JGaYwljm/eIwSwWuNWJz9Y=;
 b=rlUrC0Gd88bfUUEOLW3wTkGekMZDnRgRPRIAJL+mMT0M54tVOMLIB697WzRWo1co6nrgnSgSHL8rKlc0gPytcQdo/2f/f4GpkbfSrzSfup2U0TdSR1nPsbfRBCpJSeTMpnaBqLFRctW8iuMfdqOh9cx5zuQl5XFh+7BwlgKLyQdqi3hTJttZCzdZxb1UXT1yWbeJmXXc9FZR3sBC1/tQuzuhK9hUvLJykkB++P04ttwPPCA4EDXEluip3hwkSvTSzIDoYfQqhm9adRXfChOGo2Mpch0QjV7xJLC6H1clnW7SuE42FCTOiQAO9Qm1zj3NDsxBI97UHi7FxBnUgfrKrw==
Received: from DM5PR21CA0044.namprd21.prod.outlook.com (2603:10b6:3:ed::30) by
 DM6PR12MB4123.namprd12.prod.outlook.com (2603:10b6:5:21f::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Mon, 17 May 2021 17:04:55 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ed:cafe::a5) by DM5PR21CA0044.outlook.office365.com
 (2603:10b6:3:ed::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.4 via Frontend
 Transport; Mon, 17 May 2021 17:04:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:04:55 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:04:51 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 06/11] mlxsw: spectrum_buffers: Switch function arguments
Date:   Mon, 17 May 2021 20:03:56 +0300
Message-ID: <20210517170401.188563-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517170401.188563-1-idosch@nvidia.com>
References: <20210517170401.188563-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7a31e4d-5290-4e8a-dd54-08d91955e4e4
X-MS-TrafficTypeDiagnostic: DM6PR12MB4123:
X-Microsoft-Antispam-PRVS: <DM6PR12MB41238D31FBBBB2FC02D441B5B22D9@DM6PR12MB4123.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/Mgpp2Hh151dtgvT2bUwfzF8EqPastNgOuYGlPGVJXBOQCZ3Y4byEOGDEriPZ0pzVs0KxeNDFo9RoCJv05oSUM6RX1DXqjUnmpABtE4b+WdjumknqUV28PgDDP9qWRRmkl+yZ+Qy7f1YSzj20TR4d8xCNhCbE5ZVd8+yOQB7kSwpuhU6+a524zy8eYDc5PqXhwIjs4Y1sfe2wEhSXThQSwaYyMZjTOcwIIxqkOisJCNaArNg7mHzCD1aDHCUVYxzfq+0ezKotuSBeNyOyBvcvZco5SWe/R0GdhHT1FX+kBwDlgACLI1OcpdElZRCdvnHXdoTkJHXDXtg7WKGawtPz7ZBNuIqmCe1d7PVKzb8YBiOFHR29tnHDyJn3XFPdAEQHForgM8QeKQp5LKBtKyTyi+Ec2RlXoEpq01zRkBtNzJU+FCrtyXdUvfGSNl+h+Sc0Hr54dhWKKL8dY3aXA+NGxx/eAdJ9d8GkHJwmKQb7Q05FwZGHpY4Y0gzSuhnvkO66mrHh0BJwQZSPoIcTJq0QCO9vMd/8XPlNmIMdzQb+uGl94Fw7chJUYfTFD6SXdQQkRXLiCUxFzcPRhWLvecibVhVmoP3sKNWuruJcCZUwS/nDuJCqKuk+q3rYNq4Zkl4I2IS1tWiyiupNSIShrJKrKMquY/Si0uu21mVx9uNSI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(82310400003)(54906003)(336012)(498600001)(107886003)(8676002)(47076005)(426003)(83380400001)(16526019)(6916009)(36756003)(26005)(70586007)(70206006)(1076003)(36860700001)(36906005)(4326008)(356005)(86362001)(186003)(5660300002)(8936002)(2616005)(2906002)(7636003);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:04:55.1715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a31e4d-5290-4e8a-dd54-08d91955e4e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

In the call path:

mlxsw_sp_hdroom_bufs_reset_sizes()
    mlxsw_sp_hdroom_int_buf_size_get()
        ->int_buf_size_get()

The 'speed' and 'mtu' arguments were mistakenly switched twice. The two
bugs thus canceled each other.

Clean this up by switching the arguments in both call sites, so that
they are passed in the right order.

Found during manual code inspection.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 37ff29a1686e..9de160e740b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -364,7 +364,7 @@ static u16 mlxsw_sp_hdroom_buf_delay_get(const struct mlxsw_sp *mlxsw_sp,
 
 static u32 mlxsw_sp_hdroom_int_buf_size_get(struct mlxsw_sp *mlxsw_sp, int mtu, u32 speed)
 {
-	u32 buffsize = mlxsw_sp->sb_ops->int_buf_size_get(speed, mtu);
+	u32 buffsize = mlxsw_sp->sb_ops->int_buf_size_get(mtu, speed);
 
 	return mlxsw_sp_bytes_cells(mlxsw_sp, buffsize) + 1;
 }
@@ -388,8 +388,8 @@ void mlxsw_sp_hdroom_bufs_reset_sizes(struct mlxsw_sp_port *mlxsw_sp_port,
 	int i;
 
 	/* Internal buffer. */
-	reserve_cells = mlxsw_sp_hdroom_int_buf_size_get(mlxsw_sp, mlxsw_sp_port->max_speed,
-							 mlxsw_sp_port->max_mtu);
+	reserve_cells = mlxsw_sp_hdroom_int_buf_size_get(mlxsw_sp, mlxsw_sp_port->max_mtu,
+							 mlxsw_sp_port->max_speed);
 	reserve_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, reserve_cells);
 	hdroom->int_buf.reserve_cells = reserve_cells;
 
-- 
2.31.1

