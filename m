Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092D84AEAA6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 07:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiBIGyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 01:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiBIGyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 01:54:18 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC23C05CB85
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 22:54:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKqH9EiK55mwBFGTzb2nczSSLKwLY3t4jGqu3fuVsNJYvHa6br96aR7U9T13l3X4tMmTph1uDoULNnSLUhXBlz18wPi1McSrTJ2rmvx+PQ0TsecV5ZOY7CaDYHCb8BlcLSkZPbVMIva7uEUbenD1Qi8FLmt9lLZHY8JFF24c3ZBKok79mYYT9Q2n0MiQasfEKZ46PAn63yVpRQLp8hIdqjHG154LkQuYCLSL6oYer2EnRI1oORApJ9pLWeoTBYIepODF6H/fR55qBUyG/kGSNo9KRyE6ZHGULc8TKoCrl+v8W+4Y53VKujDHijfkPMCntCHpWtGbevGp0eZ0LRdMfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DzM5lgUwFy/SPBrZ7+fnIQhRVUjqHqzfQtlNTIV9RwI=;
 b=mgdbm9DvrC+Dldf8tU5P2WjkBttdKhrJmJQBQerALdAKjrQ5wCGhW70+EWbQ9wxiFUPMdTlboRLJYqUe9rZve2xiotk/E6lp0WligzQhHbrK7r5owlMWaIEpCLig3wor35CZ2wmttr+wlH1XIY/Zviwd+mARfWtYNcq8HxJ3ezX00ewC3AXRjXjS9/s3xhaKyP6lpCjyoV8XsIpt01nX/3oMiG1XWbhKihhWHOsKv0wTCrhnjsok9cefGOTtkNlbqEfv4A2Y1mgPcRz93Sv30B6eXS5lS8o/JXajbZ1CDkHlpVkxNfarG6kPKAxODU2EL7gx3gVEyN2KjMnhD9tYJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzM5lgUwFy/SPBrZ7+fnIQhRVUjqHqzfQtlNTIV9RwI=;
 b=HgfCPAhC+7RsKAtQdSK8EHi3bhFFbQITJIR/DebLHwxeKLmslDUGdMoMZLh57dtCmFsacCWo86tlPmSppOZZ6ZKKfKa171q1ZxqR00QK2qXQJjfZyGvOJy4OKpNX4brW/zQzqTFkKZliyCeL6s/9/ETdQ952fgHh6vQE8+FWLuf/BzldVuqEHEotq5p1iFN8AhO5lzeivIzgoKk/14axrHZ/ZOB0qknU9iW1kHVTNqGZRYENIGB/zGvfr3c4/OG9nDXwJq5Z5stwHVlou/zQ+i3R65IlNemNUHHAZhexPlriwQAX/vrMIy64pcY+Ol8VtUw6i2pVL5pKk/KnGATdhA==
Received: from MW4P222CA0003.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::8)
 by DM4PR12MB5199.namprd12.prod.outlook.com (2603:10b6:5:396::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 06:54:20 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::ca) by MW4P222CA0003.outlook.office365.com
 (2603:10b6:303:114::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14 via Frontend
 Transport; Wed, 9 Feb 2022 06:54:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 9 Feb 2022 06:54:19 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Feb
 2022 06:54:19 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 22:54:18 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 8 Feb
 2022 22:54:16 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH iproute2-next] tunnel: Fix missing space after local/remote print
Date:   Wed, 9 Feb 2022 08:54:15 +0200
Message-ID: <20220209065415.7068-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e13b73a-37d9-46b6-ec18-08d9eb98ff07
X-MS-TrafficTypeDiagnostic: DM4PR12MB5199:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB519946C219D006E95E753A8EC22E9@DM4PR12MB5199.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fA4xFlo+ax0rO6ND3b2gKS9m7dssKCyKoJKnTJSycKjubh3rgBbo3+6njDHUV68FjPpzcxwsUAQlPYlFoM9JKvplDTu/iuNrpVXh40e6SWis4U5Hw2UJz7/kr3qxuFWUDkkd6ZZdtHaG3bQm/bZiLxuK38AQwuU1TBRBB4oGa5gV0rPjVKbjs9HMeTZHkj6Gd3weOHz+acK5/d4ma0fuzI2NDPdsNj66FD9bQJKxbjkRCJAuSbRYfqaE/Imi6qgNfZUkIMSOzB57w0EeNU3OU2ChGoxTnlvxo1PShStcQfW3f4h/QQ94uWMO4bXwB2xSTNIQogS3O+9gQf7qZjPyel5Ac7dn85KaLuu6QaGIcr76KVpC4cFk19tNIoEl5KMWA3gpgYyUI+ES6j9pUxL4hP1LLKQqAgyHuXoXTipqT1poXLOtn4y6Tx2WtQ+DcGjYCrOBPsTbh8352pFkZtSqApDcrSq3XXIXsCsypSq42Jehxnv2T6yXWmLlqmuBbOmjqjrkSYuiAqz9Yeaul283Lko2lUTTp22j/LD8dSgqGIQXiwjvArobtw82kTf56RmgqKZalbFxdh2KmpsDLDlli2mIeHddJCM2pr5PIkTe93E98OQA+63T6y0cOCT5xoGKXWhX6Gn/s0JgFoOKh34HWI7L2G6PiUBcpuMsHaKzR0XBb8Dv+LhsAkOENzNcvEKiUGQ1/XaBbDTAfC8KA44kQHa02VzKFcZHHnVgM5svRLDBvrFEofyzH0y5wAomjj81mPDLMtHz1EpjbUPvbED05C8DayExPsPrlSKhC13zCkU=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(8676002)(86362001)(356005)(1076003)(5660300002)(966005)(7696005)(83380400001)(54906003)(8936002)(40460700003)(316002)(110136005)(4326008)(70586007)(70206006)(82310400004)(36756003)(4744005)(2906002)(26005)(186003)(426003)(2616005)(336012)(47076005)(36860700001)(81166007)(508600001)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 06:54:19.4807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e13b73a-37d9-46b6-ec18-08d9eb98ff07
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5199
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited commit removed the space after the local/remote tunnel print
and resulted in "broken" output:

gre remote 1.1.1.2local 1.1.1.1ttl inherit erspan_ver 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: 5632cf69ad59 ("tunnel: fix clang warning")
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
v1->v2: https://lore.kernel.org/netdev/20220208144005.32401-1-gal@nvidia.com/
* Remove unneeded is_json_context()
---
 ip/tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ip/tunnel.c b/ip/tunnel.c
index f2632f43babf..224c81e42e9b 100644
--- a/ip/tunnel.c
+++ b/ip/tunnel.c
@@ -299,6 +299,7 @@ void tnl_print_endpoint(const char *name, const struct rtattr *rta, int family)
 	}
 
 	print_string_name_value(name, value);
+	print_string(PRINT_FP, NULL, " ", NULL);
 }
 
 void tnl_print_gre_flags(__u8 proto,
-- 
2.25.1

