Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A52F55C2EF
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbiF0NUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 09:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbiF0NUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 09:20:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7C21104
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 06:20:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZedFpy1vhmywWGrywxryL98QDWEvXCvrIMSq9ZdUBJ0+/ICSMsxfpfZ1tIMspwektcRMtNHv1t62Aj9zBZnhHC6s+UR86PPchSBJGty3U3MT2Rlq6auVNKikQM5y5Mdb/F3+gEI1/v/p6O5zj0O/8aXuuM+VQ0Q4SG9jKefIFaSX5jFLZH2GJevm75WZbZgpdNrtWxic3rDxbAuxXUvA2yXkBeX2jmq5PsuU5CNnIcPagtCS22/wnoS/mjWnesYaYxarC4maTQCySq5fOaZCuJZeyFbXnDP26iHvkNSsMt7luzNQBM7m+MBwZcg87UBRS/YiBai2ehWBHIZwEPtvog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pi2kPQAZu+N9/Oni5DvoMZPtAHpqXdRn0QTc4Y0RmEI=;
 b=VrYHMTAqETEbjPjVIlBiVNqbjSXHzaz7RZvxC2FZxUDxELgOF3f9a+RCsjyuI9GrGdiXMEupDFoi28N6i6h5OBoXVq/4b1zvw8G6cAyrdSvdb2uSI1YLGGhnWrBbeMRMbh65V6L8iQgKMXG8tQp+AA4qQdRw7Qs/ixoHjmxiB8YO6CkwekBtzb6JqHlHHYGCqWl5iTX9cuqQW6LFxUW26ju9PSsg6BNZBujCnmoa/Lr4wCLZEz+uqf49Vq6++kcfWEazhS8vyLQTBMdZ4bLVTBhA0Fb7HgNzlCGjRk9VSo5vrgwAsWqraPXu1L8wkmi7ZU91eEqzZx9nK8hPmTw+lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pi2kPQAZu+N9/Oni5DvoMZPtAHpqXdRn0QTc4Y0RmEI=;
 b=ZoMlEQJJn7oPdMgHWeqs90LEBWe3A8eeRZGhSbz0baAU14Yw4N+qH4pBX6lUq3CpLwG3EXlq78+9J6aFMSHgfzZy6DVoZLwYD+a6V/pNf8AZQEBv/LGhsUVvKw1bYrWp+evOdFNlPH23MCKP92k8mzLmWhdfCxpJm9qD0yX7VvMyjhwW96ZFTBYiZ9OC86kq7jiZTpX5wEf3loiYBnipdBN8e5jJCsRdJzcdRMzevZZC4ywr9zbFRczDo/PfvfRM6brVT2x8vicHxkmMfHA+awwQcTeOj1tJwqtnpLoqtcl6UQl6jRML/Zdq9z0tR7Flph6EvytcSayDt/QcmM87tw==
Received: from DM6PR14CA0053.namprd14.prod.outlook.com (2603:10b6:5:18f::30)
 by SJ1PR12MB6362.namprd12.prod.outlook.com (2603:10b6:a03:454::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Mon, 27 Jun
 2022 13:20:28 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::95) by DM6PR14CA0053.outlook.office365.com
 (2603:10b6:5:18f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Mon, 27 Jun 2022 13:20:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Mon, 27 Jun 2022 13:20:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 27 Jun
 2022 13:20:27 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 27 Jun
 2022 06:20:25 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2] ip: Fix size_columns() invocation that passes a 32-bit quantity
Date:   Mon, 27 Jun 2022 15:20:01 +0200
Message-ID: <1b8c8a3e8ae41a85f2167d94a6d7bcc4d46757f6.1656335952.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 151b7c7a-55a5-482c-459a-08da583fcda2
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6362:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1e23UNs4GVgVhK1snfGvY/7LM93odYZMYWhpmxg78p48q5sIjlMwyqW6bKgOwhyzDxVmLIP5UF/KWpEMT+F+f/T5Ps/tzLPRu1lsAcZFyXxO96lXbkpg+aFJOYMrmkVwjZ757Pk9va0ZwNjuNXwRo3OYTwTeV20Wc7mcYeRMFg6Qrb3Sl6VN+ZUDJUq+HJt4cLBslH8sLIf6kSipl2I/skvHdpQLrxRUaCuj3rxoWOnFViNF2jtCIHvTR/punrYDseIbrWKQdku+gw4QwU7UD6hJI0KY7UUvlX7HFWecLVn1h/gzkyPhpVUH3HykmjyX7nrE0xM4r38utpZ3e8yaGgwYDFBJtmEOM7hgSpPEOiTIcvYqca9718SH4EiMfoM7jP/8ZBjROciqvMi0BHGrtSsRz5/jhG5mWManukck4tSrEsNTKIiBbltaCUsnDbfdfOdvF8u83J2yuukcs8tTt8HYUqcqLVKsgHdMYA7D4Vj4ON7YUUpwmjYy+PSsAQQGXuVF0My2EEsE1nJiAYo7XXTaEXF2Z/sMxwnel352+/M1/6IarVaQU2J0+ctbUdcITQsccWA5w7om8Qbui8/8n3RJHBJyaARnj+oAF6rzuIggNKW4+ZRxgZb1ncsfcjT2BZA3FU6IwtP9wzqBwXS1tZtMYIaRCPLxkK3cpj+09tAjGcrFtf7WxrE1Vz6tKJG6ixILXgCAscSPuN1XK6jpooDFEagC13/8CwAi7NqCbBySOaWdPWebXHbMxz5ETj7oFAEvH6uPYh7C741gr0jGRAvDM+9knYWyY9tl8iPWxr6D0Los+BOlMZpqGwEUi7sRTFvEY5lypA2btdj9Xokzw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(36840700001)(40470700004)(26005)(81166007)(6666004)(41300700001)(186003)(16526019)(107886003)(83380400001)(40460700003)(82310400005)(40480700001)(2616005)(36756003)(2906002)(478600001)(5660300002)(8936002)(6916009)(70586007)(8676002)(47076005)(336012)(86362001)(82740400003)(36860700001)(70206006)(316002)(356005)(54906003)(426003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 13:20:28.1244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 151b7c7a-55a5-482c-459a-08da583fcda2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6362
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In print_stats64(), the last size_columns() invocation passes number of
carrier changes as one of the arguments. The value is decoded as a 32-bit
quantity, but size_columns() expects a 64-bit one. This is undefined
behavior.

The reason valgrind does not cite this is that the previous size_columns()
invocations prime the ABI area used for the value transfer. When these
other invocations are commented away, valgrind does complain that
"conditional jump or move depends on uninitialised value", as would be
expected.

Fixes: 49437375b6c1 ("ip: dynamically size columns when printing stats")
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 ip/ipaddress.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 5a3b1cae..8cd76073 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -788,8 +788,9 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 				     s->tx_aborted_errors, s->tx_fifo_errors,
 				     s->tx_window_errors,
 				     s->tx_heartbeat_errors,
-				     carrier_changes ?
-				     rta_getattr_u32(carrier_changes) : 0);
+				     (uint64_t)(carrier_changes ?
+						rta_getattr_u32(carrier_changes)
+						: 0));
 
 		/* RX stats */
 		fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%s",
-- 
2.35.3

