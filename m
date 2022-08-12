Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED572591306
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbiHLPdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237281AbiHLPdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:33:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A8B8286B
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 08:32:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2LJtQvFe16T9xpGzRUwNivC6vcZlplGT4xXOoitrtTbdIn7uyBvV/i0nhJQzBsYSJAAuynE0iwJAqolewHTvfdt58QUaE2dYWNxXzclLEkOMuhYV8iboSl6apqQ8qLERHlS/x9DyAgXC2z5nCzzJYoB5q6X4rGknMivVTgTnCWbK8ebLCZg14UNwvVcrSIIYsTQsqRZC4iAM+ppPHu3VBXrYUh/mO+rw/QWkBk2ab930mNh5s0wCTdKRUAtVrCkzt0zJQPo/aYz+iKCiOy4gAUi93ItNDPcXAkViJHKB7GQH3WvtGCgHzESyrlC1bR6GYggrwGvyXKz+rIodC9lHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/uxsdw3dIdZqRAR2RxOnm8ojGmwyhayXyD1R7LWmGE=;
 b=hAxi/xD8niQ2qCIvev9NnmVPkhq2nK0Pbyj8ar+dcwTQOves0ALfEWTpJ86dpvF2rKpfoXExas7CbCt0upVKmQVFB8Ks3TceIsRxpGy2HBNBs+2npgKofG+RXDYAW++40lIKZt8uBiioUvevGpqony7PsWq0cEbPt6j7O0hHftasWYv4dy5qNpOyutFJtpOp/CUNZzEZ7Mb8gdzryGx5a59y+Q7GijXfiu82zyesY9B0q09PkF2HRb1G2xiHZJVktka8me/EvBBii+9NVW48zK32+mUB0yZo1osq/SFrzySTjaDpU8D2eDgGiiWPUxhHLOevd+rHUCBxiHLhO7KySw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/uxsdw3dIdZqRAR2RxOnm8ojGmwyhayXyD1R7LWmGE=;
 b=hPbrCOnfKml/9RnE8+PqO/39ys7kwIrkl/TPn5zi3QqeRC7ZtCs2/JyRsnjg2p0o7sVKmZOu94Hswq1RjQhqv0doXu+ro5zYZfQBk7ukF6DrdQ471k1nSPaHn9qnHcp6Ncyy8aMxxTlgWaeZnUDV5uCr23yKb2ddK3iRa7u9QUhQTHhMlmx5UJEWJAUYJW/4nifZwsn8ijIj62z7cJwU8HrN1fwa8o9zLSdp7aTr3T81HJNWHCf2WzbtKpN2nj52+U+2/RtQrVM/UbJw3D36Y1klkIIwEwPK9u2ohSucdN5S5eItED0SFN05OlMW0o6frCJSB/DG778Ir8te3VCcgA==
Received: from BN9PR03CA0394.namprd03.prod.outlook.com (2603:10b6:408:111::9)
 by IA1PR12MB6305.namprd12.prod.outlook.com (2603:10b6:208:3e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Fri, 12 Aug
 2022 15:32:54 +0000
Received: from BN8NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::d5) by BN9PR03CA0394.outlook.office365.com
 (2603:10b6:408:111::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17 via Frontend
 Transport; Fri, 12 Aug 2022 15:32:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT108.mail.protection.outlook.com (10.13.176.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Fri, 12 Aug 2022 15:32:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 12 Aug
 2022 15:32:53 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 12 Aug 2022 08:32:50 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 4/4] mlxsw: spectrum_ptp: Forbid PTP enablement only in RX or in TX
Date:   Fri, 12 Aug 2022 17:32:03 +0200
Message-ID: <6dc486a05deb2d402652267673cf07524708a6ca.1660315448.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660315448.git.petrm@nvidia.com>
References: <cover.1660315448.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ca2cea4-0d6d-48d2-4f8f-08da7c77ed20
X-MS-TrafficTypeDiagnostic: IA1PR12MB6305:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z6TnoL/Rxr/ja8ECufhPP/3pn9C3rYaDKFvaoXQ+tRDz0H+pz6MALC62VibCXf0dedvWytJpn9Oqw+WPyactOZuwTua/oINSCbPBv/qMY9ndiMQozQTQW2BZzTNHUivNtRCtEKY+W+IKNcstW4FbHtcmX3G2ZnClThSkGZX4gqWPiCBVdBAkBXTaHAHIrYu0CNp249iPBUVL2lCDXtVOFRpMy3iQzJLpSwsUr1PrhhtVm9W+NPgmasDJLt6YrwZ9//Jkk8vTmGFAOU8D+NsqlSkH8tDYW6Rbu54HYRypz8FlVqCUFLBffKjTpMfkPzRPsdW2fWD5UL7YLyEDyl+/zsRl6KF//aa6VPebWj48QP+eA0G3aZaiZ1pZcaG+hXOs+pfxwxM85WiFT/qBYeB9wJMr0xMthaY5nmGrFfzGxgMEvXW0ZnYJWFqEdbQb8oqsqI5/529lSuUMX+hOGkOpWUlJ22kqbpZZRSV4SdrBT2QN5YK2Ys9Mb1w6ii9SVyn0lHsbENU/EIaHM3bBLeWNCc9qkNeSqITgmtnk+GzB4UspoxyKUBls4AiBGfmuYDuXXU7xZBQsEWIIVUsVXbuD0Cl+MISsTX88sI35WpApXPXqViHTIGDeE3/gmEosi2fO8/sEukGS8wcBvR+MrFRPBKBWoLzTgz7dsFHaAt4lE1qJPF2Xl8teh7b8EqKOQMoi0ThfX1vqVZPL0Qb+kYEb3CYGWIYQGgx4x9S3R1BC3qHGdsa2WGFnEkHdZqHlLhXzkQXyAC8MXODFkivrWYisJV3M1fXL96j2B7s5CyMxyzrhf8H/KiWf3jWGXnmf3waDyxjY2wpUXeOUIQ2IVOn0FQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(40470700004)(46966006)(36840700001)(107886003)(336012)(40480700001)(54906003)(47076005)(2616005)(426003)(478600001)(41300700001)(82310400005)(186003)(316002)(6666004)(86362001)(26005)(110136005)(7696005)(356005)(16526019)(82740400003)(40460700003)(81166007)(83380400001)(8936002)(2906002)(8676002)(36860700001)(4326008)(5660300002)(70586007)(36756003)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 15:32:54.5741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca2cea4-0d6d-48d2-4f8f-08da7c77ed20
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6305
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently mlxsw driver configures one global PTP configuration for all
ports. The reason is that the switch behaves like a transparent clock
between CPU port and front-panel ports. When time stamp is enabled in
any port, the hardware is configured to update the correction field. The
fact that the configuration of CPU port affects all the ports, makes the
correction field update to be global for all ports. Otherwise, user will
see odd values in the correction field, as the switch will update the
correction field in the CPU port, but not in all the front-panel ports.

The CPU port is relevant in both RX and TX, so to avoid problematic
configuration, forbid PTP enablement only in one direction, i.e., only in
RX or TX.

Without the change:
$ hwstamp_ctl -i swp1 -r 12 -t 0
current settings:
tx_type 0
rx_filter 0
new settings:
tx_type 0
rx_filter 2
$ echo $?
0

With the change:
$ hwstamp_ctl -i swp1 -r 12 -t 0
current settings:
tx_type 1
rx_filter 2
SIOCSHWTSTAMP failed: Invalid argument

Fixes: 08ef8bc825d96 ("mlxsw: spectrum_ptp: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index f32c83603b84..7b01b9c20722 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -1529,6 +1529,9 @@ mlxsw_sp2_ptp_get_message_types(const struct hwtstamp_config *config,
 		return -EINVAL;
 	}
 
+	if ((ing_types && !egr_types) || (!ing_types && egr_types))
+		return -EINVAL;
+
 	*p_ing_types = ing_types;
 	*p_egr_types = egr_types;
 	return 0;
-- 
2.35.3

