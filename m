Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1851D4DC94F
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiCQOy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiCQOyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:54:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8633ADAFE2
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:53:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnN6hbWxU+xtTuyw0caDbjWpx1eQyFT8Oy0hFpMvgsYJKR8kwjmzqXitLqOvPVBjbFq2BG0EVSfQj4LOcurUqahZK7hb6oU7x2KxG5T9o8YW7u+by6E2jyCaq6U5Jb+9/++8j3XB10zYRVaFD89PnWYPhF8AaZMPQg6lUr7wP6dlcZd2GeOHByAvkUeF3pJZdWa3owq88k2DEmS4Zay52a7VOmMcMXLEp34aLn4XW3qvuX5/F3y7UimXcC7MNfo0F30YP/kUvHIGdECaz7tgf85WZz/1XEjRXF6tMaWXOWU13rHt5pdeVYwAvzJUpIa4FcziDb/88vqZ5CMCHQvn3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=udbmOi+6wih7ypAEFgOkjVpdgwpt8UmXQO5wlzMPMoE=;
 b=NdJIWSgNZNvrodIBAJVQRougZQOj9+z06SbteQwpNDqY4i4Kp3m7IBYxfZ0h/HlQqv4NS506FBXEuzJzuSvpNvuWkJ5nBxD0ZffEoPCAB2+MaMzRCgh0ooCREUq0kMS5w7QcV6+QlNdYpenER7aF1KOI1jCttbECdOZtynKYfR/Wa9AVEicuKrki1IwF0K1mL7c7k88BBqmy5ahocwrlzhEQlCE4RXFm83ohO5Mxpb7laqcwO6HrCuq9tdWV5CHLQ/Oy7ZbhNmSUDYChZ24K7dTAt7pg+C+1hQ8i1NuoLaWfObn3RpGtSfPBmk2Vsl5z5sfMBiPPLIxCPIWDQ4SLQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udbmOi+6wih7ypAEFgOkjVpdgwpt8UmXQO5wlzMPMoE=;
 b=IV5DIGgKRVncqpBbzVin+XT7a0Gdl6BaHLZeP29EFgUi77WVjn5f50s6NMUROCPvi41fTnHZXWOeF7wz3zhqrN4fTfec/HieZ0eUyWPk1Ky8/sOdK8gI6aWYX0pCaGS6vqhzRV/kBqdJp1X3ZkXOXARjAp6hYB/Le6sCwC4KhDnLqplbQsq/zDj4FD0m2BYmkWfjMi/fPcMPspoz/sqil8F+EZgOlZ4pkz/cp8DKXG3f/rTQLKuINDlgkrQ634Y2sOiCbSJAxYJllTdRRI1j6Y/M2zJ+gGCcZQQmBZGXVTIlBjiLnHrB3G5pay9DWVeV6BVxmhCYN6vZHngqPTAAeA==
Received: from MW4P222CA0028.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::33)
 by DM5PR12MB1435.namprd12.prod.outlook.com (2603:10b6:3:7a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Thu, 17 Mar
 2022 14:53:37 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::22) by MW4P222CA0028.outlook.office365.com
 (2603:10b6:303:114::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28 via Frontend
 Transport; Thu, 17 Mar 2022 14:53:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Thu, 17 Mar 2022 14:53:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 17 Mar
 2022 14:53:36 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 17 Mar 2022 07:53:33 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net] af_netlink: Fix shift out of bounds in group mask calculation
Date:   Thu, 17 Mar 2022 15:53:06 +0100
Message-ID: <2bef6aabf201d1fc16cca139a744700cff9dcb04.1647527635.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ec21a7c-051c-4b6b-2fcf-08da0825eaa8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1435:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1435E859ABE6DBB9D13C658DD6129@DM5PR12MB1435.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDVsORuxnB1QmQB+v8A0oQOVtZEpaCXzpQadlhkt5suCyMRbIg8zXIeCSe1FAsTi/FwTGVAsWbyH6H0iw4VDv0+AYN48AcVwbtHUN1mojRDK/H5is1RqCB0aYWfc6XnCARdGI698SUoEAMSYNN5TSUeZ2Q4wZP25N/sXQ3Lurp7uUBp4TTUBuGvsedj+8p/yKl/8cZQq4r4NXPJKtLEpozk/98qCBRkEK3JGYmoajzjOtLaHCVIbocvNxFsRA5SRvTdJ3LlhG3zyVGuFSclSUvXYgJsoC3+lyr4m8ix+IUfweffDGorqQ9WLPkmlCUvixnkhMF4Z+9O0vFspGXHqWPkseYsYgalgHslLYznMbklvV+C3HPbrw5FwPURIQknb78OiqQErI9tTEUJBdewHFUVwBkGDMUqUpwgPIgIoDdpYWQW4F5f7I7aRL7JcBBpKseaoUqCLxEAdT3+e75wB6lDhfl8wR5NJQqyxnl2G+czKwd+RAwSNQLQgnwCynL47ybaI7ScsT7u0VroAzVQJA5pQIQHa0UiuX0d3ED/6xQizSak4qgLOMuhMsigkVt5TJnsjBKyAf7VLtKhOmcqabFB3a2ongw+CRwCVqRXGWnMgxzzSArqRutAbPLaDYR3qG0or0Dgc8LJKYbVHDRYl7XTGwpTlLf3fCqoRtRThizPgGRdO7iZ+PZ0glCcvF6CNq7oA5WIoNrigo1pe0pIe/IJZj+SoDFteiev/OnaM7vAUyERPyLKdppSEI1H8wVkQHHa65v7TR6K/GPYvfriEbSUDzuorY2bkNZFvsqpD1cc=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(40460700003)(82310400004)(7696005)(508600001)(47076005)(2906002)(6666004)(966005)(36860700001)(336012)(426003)(86362001)(316002)(36756003)(4326008)(8676002)(16526019)(186003)(107886003)(26005)(81166007)(70206006)(356005)(70586007)(2616005)(8936002)(5660300002)(83380400001)(6916009)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 14:53:36.8955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec21a7c-051c-4b6b-2fcf-08da0825eaa8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1435
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a netlink message is received, netlink_recvmsg() fills in the address
of the sender. One of the fields is the 32-bit bitfield nl_groups, which
carries the multicast group on which the message was received. The least
significant bit corresponds to group 1, and therefore the highest group
that the field can represent is 32. Above that, the UB sanitizer flags the
out-of-bounds shift attempts.

Which bits end up being set in such case is implementation defined, but
it's either going to be a wrong non-zero value, or zero, which is at least
not misleading. Make the latter choice deterministic by always setting to 0
for higher-numbered multicast groups.

To get information about membership in groups >= 32, userspace is expected
to use nl_pktinfo control messages[0], which are enabled by NETLINK_PKTINFO
socket option.
[0] https://lwn.net/Articles/147608/

The way to trigger this issue is e.g. through monitoring the BRVLAN group:

	# bridge monitor vlan &
	# ip link add name br type bridge

Which produces the following citation:

	UBSAN: shift-out-of-bounds in net/netlink/af_netlink.c:162:19
	shift exponent 32 is too large for 32-bit type 'int'

Fixes: f7fa9b10edbb ("[NETLINK]: Support dynamic number of multicast groups per netlink family")
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 net/netlink/af_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 7b344035bfe3..47a876ccd288 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -159,6 +159,8 @@ EXPORT_SYMBOL(do_trace_netlink_extack);
 
 static inline u32 netlink_group_mask(u32 group)
 {
+	if (group > 32)
+		return 0;
 	return group ? 1 << (group - 1) : 0;
 }
 
-- 
2.31.1

