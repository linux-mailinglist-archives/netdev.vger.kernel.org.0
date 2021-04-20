Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34DB365B8C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhDTO4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:18 -0400
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:54240
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232853AbhDTO4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfej2EODBPFkydqNVP+k8ih4+JSbv3uo40DWkLb4FnHQT80VLXr2xDeKrgy5SU02y7zqh9zgkACr0GnPLUF2gaiNhtbVQEoTrVYC2nquZ5R/6wTwDMYtiv1+c1jXik+5yDjggBXHIp7nx16SmPOeEL6SqyNOXkVgc0+UFLAYm+4R0A9hh757sd0rPuz2aNwkpG/4e3FtC+AhYKbfRTWWX1tfVvUlozmb5nfpL+gewvN4RsAlHxaeerImppO7fIgXLUw9aEd64BKf+c/tsjxZ45el5DBijBKTAw9F0aaYbLsFVklB8hfZ3ugzvbsy3Andru5Vg7YiRTPWDpLB0gkq+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsEVeeJN2AVFkfsDkf9ftjcEIF8uLeAayd53FY6vsTk=;
 b=Dg/XjbCpQoiTsz41yj7tsJEHrPM24WwwuBrjcfHCQCp3xks4qQ7s14rmVCVrfJXQN1IkdcmviJFfczOY5J15OQTS4Wzzf/iAR2slcSdMg/TMiHXjcEsYaVYuiVhU62F2jL+CKcYqRPh/KWjPq9zaNViwHhB9e3FOW7uwYUS/8fC4910E763fWLe5Am5KoNULLOBCP+W0ijtazEzs5JjfDSA8k9Y69IgY+rfyENyKRTJLg47tReXNwJnsZKIm8YBzKDd2+ZcPDV2SwXQQ/83HQo3mVebkK4u32FXyw2Ftpg/gxhv0BUiSh65abNqdLD0KMOoJy+T870kKMRqAWZw7/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsEVeeJN2AVFkfsDkf9ftjcEIF8uLeAayd53FY6vsTk=;
 b=GdvL8f/I/zuP9HVcllh7L3y7IfYBBeX8/pS2sLHxx36Pz8CwvwiRzQjpt1ASteqXsLbPBiPgATVwCM7SIGNORDQyTTLI8G+pRThjKsnoYKrokRLWEONsqlX9hMIHviJfndfFH0BMy7CN6yUMB45kTOx8e614JZAndyv7RTmquXXv0HTJCogeVthh7o60ZIHcs1a8EtUoWgVEQrLHr1ZdhPdzwvRVK8UmKP3pmKNghIAmHXE4URcqwhq2i1swY/tMjkNtecUAXomVARjaaPPhRXuvo6RjZLMsgSMVg09LT72LpRv1xaUj5wpAiSNojqrUX+OD4iRxvnlDX3tksb33sw==
Received: from BN9PR12CA0012.namprd12.prod.outlook.com (2603:10b6:408:10c::6)
 by CY4PR12MB1511.namprd12.prod.outlook.com (2603:10b6:910:4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Tue, 20 Apr
 2021 14:55:41 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::e2) by BN9PR12CA0012.outlook.office365.com
 (2603:10b6:408:10c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:40 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:38 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 03/10] mlxsw: spectrum_qdisc: Drop an always-true condition
Date:   Tue, 20 Apr 2021 16:53:41 +0200
Message-ID: <7325913eab1aca069f53a9d5d6d051224f4007ff.1618928119.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1618928118.git.petrm@nvidia.com>
References: <cover.1618928118.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e34e39dd-0d28-4fad-db46-08d9040c5da3
X-MS-TrafficTypeDiagnostic: CY4PR12MB1511:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1511376ED946F7138A368E37D6489@CY4PR12MB1511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:67;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ooxjtYkd5Ch7ydsHpz8/ZPv5v8bytHlyfn5GYRfYO836hKoyj7l6yjUGA46wxKXFtHs1hHo9qlsUWfUcfuCjqFt5hs9KLxiNMLFyz+8ObeQmCXfGifTjdxOKdzN8q4fV8UqwnmHp30sspkF5vw6cq6KMoLtyOShn86Mh2l/cpqscZv5zOrT8TBhoALXhmKDLK3xD/s+Mpcq2yVaZnLsqupDjMW1eac0+Q85m2CswDfeL9RNp4d+gMRL6r0mTVM/ySBXTjbYOdUleSYyBNCzG5Kect/e+NB+XZZJIc08Id+9vzeOrGzJy4fIJZidTvpcheSG5YPO/bMPOLpRKfdWtGDB8PGs4gBumEXSB7hpO1vPcIUeZ3xX+dXhgOPGZDS867a3yjh17nU+f/xwcn46tGPtlYs5KXy+EXwu6EcRdo0keJE/1+MwoB0et8kD9FjzWeRAyUE+4zQnQkKUS1DSD7tEKZjENLPJOH/HE6ofpz4nQvLVGMJ+tSBFzILW33PZxOZgFsYOzmAmV9QZuWaZh5Y8nniHUfare18HkcsrUNIA3dslvMdaSGKC8Q4bObkS3XEHf1k5CR+DIPmG6dmhEsvT2QYo8Sihw5yi7THjVl7yhjcH9oUwWJcMOuPb/PBBY68VRcssW9kwJJL8GtHaeDOqShZAxG8Lp9yEYj++RRic=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(36840700001)(46966006)(70206006)(186003)(8936002)(70586007)(36860700001)(4326008)(6666004)(36906005)(8676002)(356005)(107886003)(5660300002)(2906002)(2616005)(16526019)(316002)(82310400003)(86362001)(6916009)(54906003)(426003)(7636003)(82740400003)(47076005)(478600001)(83380400001)(36756003)(26005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:40.5025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e34e39dd-0d28-4fad-db46-08d9040c5da3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function mlxsw_sp_qdisc_compare() is invoked a couple lines above this
check, which will bounce any requests where this condition does not hold.
Therefore drop it.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 013398ecd15b..f1d32bfc4bed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -886,10 +886,7 @@ int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	switch (p->command) {
 	case TC_FIFO_DESTROY:
-		if (p->handle == mlxsw_sp_qdisc->handle)
-			return mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
-						      mlxsw_sp_qdisc);
-		return 0;
+		return mlxsw_sp_qdisc_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
 	case TC_FIFO_STATS:
 		return mlxsw_sp_qdisc_get_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
 						&p->stats);
-- 
2.26.2

