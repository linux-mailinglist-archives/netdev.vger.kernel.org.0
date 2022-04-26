Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9177251022B
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352532AbiDZPxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344512AbiDZPxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:53:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05189FD2
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:49:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEn753vb5yr+IqcmXCzREcbPb9u7UaZWL06UfF2YCHxi02mrrD1FGDoieIUkwKkXtLpAsa23RvcxyDjYU9IxWmKw7zGgLk9/MUvc3cfOe5yf+J4sWQdrFbNQYQaCJXJamMb7Q6gA9S7aqzekgC51GJ/zyo0B5OVSH4nXoFZWVYVaJFMf99v783ArHqO8SUxxCc2drUpdFpYCY6NPxiDlg36BrYhfF+XmJoiMoOe+MDrxjhtZJdTm8KxA0SJjZ3FlsCq0zpa8d/7kcUnXSFV2NtHYr2zwXF83IBwNbVctBu+EIlQYsdEANtKnG5CJADGbZNvDsAybeNMl5IDh3tF7/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIDmLD4oflQ3SElf5v6qV1A9f3erxnaW35imLRYNvXI=;
 b=UZQQn0jUhFcJlUyg94g04IdEcczUU8VbgA/Rn4Dx4TD5DBOUXGbB4Elrr2ttBU1vNwCGnvrOkMEEk6HwCLN+gVx6H0lUvRQBhJXT0nCAkMhNO54e9Y2fGpijjFO/rBql49yBtdurTdRzaUG3vyYZwdalTs9sUC0LNniueE8ESOJsMTrkG9K0yuqxDjR7kW2eaGXluTB3wH5Gqvc4rtPRQLwLRaiUPR16WgtLuDpcif9Nrh8TkQZIobT9z6dBWHWjRYyJTthj6N8jVfIpHEeNOGsEPDXoRGdfMGUmFfLhtXta4GmAiOenzSUggnwpMPr9nsvuTjmvePGnCvC87Bwn/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIDmLD4oflQ3SElf5v6qV1A9f3erxnaW35imLRYNvXI=;
 b=dXeuTqoHWwCAeljISgAY7adOpMsjkelFJY6BcRXX0r0VlMiTgc3iE/kMTf15hWnf+U8tL/y+75Y0Gs5BatSoumSegMl/GtZdp6Ueb3c+FnMrzExMxgPI3MNhgLdlk8RlIjOUDdXdUMgfZFGNOtfMooLEf/vDP/pi0XHnBZ94gDpKEpfVJY/bv4ffBvMD+jOMwjsXu7eXdJN5tQOpJEK0yy4vDaLpw5Ig1pJBCuRFdreX+LF+yDOgywR+V/2tZT5RLo+9zfEYfPgMNTqYUsgMcMcKpDOHl2jIXz7bd0YraB4Aa+UnhM9ciFpskzsGOvL9uthXOAlL9hu+eWyoi+l2nA==
Received: from MW4PR04CA0059.namprd04.prod.outlook.com (2603:10b6:303:6a::34)
 by PH0PR12MB5483.namprd12.prod.outlook.com (2603:10b6:510:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 15:49:57 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::5a) by MW4PR04CA0059.outlook.office365.com
 (2603:10b6:303:6a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Tue, 26 Apr 2022 15:49:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Tue, 26 Apr 2022 15:49:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Apr
 2022 15:49:56 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 26 Apr
 2022 08:49:55 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 26 Apr
 2022 08:49:52 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        <netdev@vger.kernel.org>, Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net v2] tls: Skip tls_append_frag on zero copy size
Date:   Tue, 26 Apr 2022 18:49:49 +0300
Message-ID: <20220426154949.159055-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 426af51f-a2f0-4213-4b16-08da279c69bb
X-MS-TrafficTypeDiagnostic: PH0PR12MB5483:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB54836ED7FD3CD5D53D8E7A6BDCFB9@PH0PR12MB5483.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkh4DSdt0Z9gRzjCrXs6rJ49QbHo6KIbDCfaCqYLoMWtm+it4kiCwq0VrSZAYrjXLGCjPKYx566XL+rzKpp4+TQ3Bo3Thb4OEGKB3uw+hNg/rS5D/j0eIw7PQcxKNSND/mi8Yk2+1AOQyMZ8bF2zmqI0bxdqB+M8QTqanBOgZF55kEmRs4OHQo/vR06vmW9MHlNOL9nKW2zmP3mMeHl7F8sv2EQp9Ic9F2VXHxjuIjhwKiJLEWCFVleQS+iQpKXxJOd2EsbiL6j0OcCaYQL7LuRzhg4sFl6Qr7WrVG/OboDrojrqfmGlZnTwykSCNrIjxGXhWWogTqnOUy+v2BsSoAFlbAgCoRrC0u9N3BJJ8mrSz/R3fQubZXqrOAY8astqPjeOO8F+e3zhHPHEfguZCOgUhFqkeBrHyQUJdsanV/eeZbac23Hl5OR7F06C7DIXG/oqT/8d8XE/hdAgDFppVM3Cap3ePjoPl0dcAhVAnNEAdAacgpjp+OQA83fwsmizzMZjzTyyBaAKxDASrUJ03068xAiWdrkZ0FF1LYibnQdxVzxOCMbaLH/1z6IOjKO9pbJlrvv1xnro8fvJ2+sdbQKLmbD9gebV7gnNrJOJvp6IsEhZDsIq1+Si2Ut9tnY4WLEaGIyKhfuhObJiN8eKDm1gwVH8ynd0zUbuVE244Qgj04XP26BprmSFiXM9SOzhiftoQh8WG3Rrbu2+9UgLBg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(508600001)(82310400005)(81166007)(2906002)(70586007)(70206006)(4326008)(8676002)(6666004)(54906003)(40460700003)(356005)(86362001)(8936002)(110136005)(36860700001)(5660300002)(316002)(107886003)(26005)(83380400001)(2616005)(186003)(36756003)(1076003)(7696005)(426003)(47076005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 15:49:56.7516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 426af51f-a2f0-4213-4b16-08da279c69bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5483
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling tls_append_frag when max_open_record_len == record->len might
add an empty fragment to the TLS record if the call happens to be on the
page boundary. Normally tls_append_frag coalesces the zero-sized
fragment to the previous one, but not if it's on page boundary.

If a resync happens then, the mlx5 driver posts dump WQEs in
tx_post_resync_dump, and the empty fragment may become a data segment
with byte_count == 0, which will confuse the NIC and lead to a CQE
error.

This commit fixes the described issue by skipping tls_append_frag on
zero size to avoid adding empty fragments. The fix is not in the driver,
because an empty fragment is hardly the desired behavior.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/tls/tls_device.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 12f7b56771d9..af875ad4a822 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -483,11 +483,13 @@ static int tls_push_data(struct sock *sk,
 		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
 		copy = min_t(size_t, copy, (max_open_record_len - record->len));
 
-		rc = tls_device_copy_data(page_address(pfrag->page) +
-					  pfrag->offset, copy, msg_iter);
-		if (rc)
-			goto handle_error;
-		tls_append_frag(record, pfrag, copy);
+		if (copy) {
+			rc = tls_device_copy_data(page_address(pfrag->page) +
+						  pfrag->offset, copy, msg_iter);
+			if (rc)
+				goto handle_error;
+			tls_append_frag(record, pfrag, copy);
+		}
 
 		size -= copy;
 		if (!size) {
-- 
2.25.1

