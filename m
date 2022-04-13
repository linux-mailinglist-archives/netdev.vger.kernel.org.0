Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5254FF830
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbiDMNxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbiDMNwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:52:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F0D1FCFF
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 06:50:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pjnt/gW9mbNqpnNayCE2aUjJuf7xVHZM3ZRvTTY6Fi5QMlSoEODbbh+3Iv4zchvb4yqGR6AwRJM2UZgt2Vs9LYHN0HNBiFd/64vutX8ICMaGeDvb1Hv57QUh606k+/qfvGvORN1hmD5ahdH4+hzeFTswcBjGZIlqKM/h57fNz9vFWyIP0TSNXh+sAbDDQRC6WOhg0DgcUXZp/uTgIwf9f8M7f8ymwUfpjac2ZZnnabl48XSvEdRFH1WYlcSe1tdQCBEWwQOVljkhCW1dI/rkhpMtRaWyi/CcUL/XYUqtzyjgHKqKCmB2kPAd8JYIfCJxq0jMvdfdLQ3oDseZdnrkaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIDmLD4oflQ3SElf5v6qV1A9f3erxnaW35imLRYNvXI=;
 b=AmZ2mjwawproA0+FIn5nYcRkqObuM7FrhwZMPf3O2Xxd7vjKofzHaTGY7X01ooj/sVuuA42S0H4rUwSJQDOCHqNJpND+v9ZwP6gBlUuqrG4u6M/R8V/0r5we/kjK2WQb+OODKYGDipfgMa0Rz6PKXpFoGhlk+CgVm+2wj8M9I9JubkXGjCebKhxUeyUOpXHmV20qQCwfER98EsWGUcsnKtEqaK+A2F/YytO43jX8bBn4F/VuJXRPsiIZEOwg3SJUGzZKwX3EbMa+E93YvE+sGB0kXpJJdRDul5tiD41C4sgW6EGrr3jhjrXfUfgGnuma8Hxwib9dsvac2Hc+uj+Jyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIDmLD4oflQ3SElf5v6qV1A9f3erxnaW35imLRYNvXI=;
 b=RJEy5bunAEe0UykC6zqO1ARVggjpafCuyA/UOn7mOvxS6wz44vw5K07IglhBUmY4sNuIINBcsykEpGdGLj2OMrU4eSZ8poRDxvRPWyUkQohFLhzXijhfuK8deqv2b+jGn07ic0H6+VSzBL0Isw9mGgMpJMsIf07M7mK1oVhwy58D7dV/8gPtBlzOvwgB7g2KBvpOpz3Juk68cguuDKyQPhCaE4f2olduBa+pG/TOsBwHBlCGiyPGJAFVJceg6y5LFLQw4mXaA8Hy9P/yhv0olzjKbi6eaUfmVCeU2eYm/LOUEtG5D9HnvekwTDhGQGrydoKR3gtrR6brGSAnCF0Z2g==
Received: from DM6PR05CA0061.namprd05.prod.outlook.com (2603:10b6:5:335::30)
 by LV2PR12MB5727.namprd12.prod.outlook.com (2603:10b6:408:17d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Wed, 13 Apr
 2022 13:50:04 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::dc) by DM6PR05CA0061.outlook.office365.com
 (2603:10b6:5:335::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.8 via Frontend
 Transport; Wed, 13 Apr 2022 13:50:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 13:50:03 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Apr
 2022 13:50:02 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 13 Apr
 2022 06:50:02 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 13 Apr
 2022 06:49:59 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "Ilya Lesokhin" <ilyal@mellanox.com>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net] tls: Skip tls_append_frag on zero copy size
Date:   Wed, 13 Apr 2022 16:49:56 +0300
Message-ID: <20220413134956.3258530-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a50f3282-98fa-4e66-060e-08da1d548311
X-MS-TrafficTypeDiagnostic: LV2PR12MB5727:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB5727AFCA9305CA7E57708171DCEC9@LV2PR12MB5727.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QTn+zOt4KoaR9qScoerlBvZ2WX/lWOR5ZeM9vxskY+1kxISXm34qKHzsgyalJJKOsphrKewO8Ap544oE5PyCX2LXLT99WNZFeA/ykRQgZoB6RcAsfTyY1WPe/tyu4PcChSxZYsxTqDOZQB6LWktGBEj2qO6RV5Hxs8fKwLnF2ssKfsxU1ux7kOsJCiR8huH97WhXATBl2DtaxzvxQTq7XT5uXTksZ7QovaWTuvj6ujD4+gfuxy6p9hDEdIDGcfxGMgwGu2GSa6cn8wEn/PA+vc4gmCfzefQspG/40W/mwANfA0ed9fyk3WPEKgpa4QJlDpIyVMQw7vaLV2N9lf/ZzR7F87VXo6RougLFDVT5zUC6Yz56bQ/7rmybgj2B5fIk9XRe4j9i2V2nms9b9/1Whbv6fAS6D+z8yoKbIrgFL+HyPUf6Besr+uqqunfwwaB0XKmseMeyFVHR21KWFj4r1Fbze9zTRaKhdlJP9n31Za9suorRw2M9xxW2dEQFl9xoWhNl4kjQj+4c8AUWu6h+5hu370tIK6YSDXaP8Pc8zjWhdAhHMzis7gw23yFwM7SzXLDzljSE7Ey/73oQyx5kGzdNMYP9FOYHNxNlxshzCgyKuptAYrr5/Gh9hKL6yAQxlV83ohZRhiiX9W76/zOSnaFYWM6xJzWS/mrkp+izRPDK/zRCWKI4O/4KammlCKwxn3C4CjkuKjw2bCnDiFpCdw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(81166007)(186003)(36756003)(47076005)(54906003)(426003)(70586007)(336012)(2906002)(110136005)(26005)(107886003)(356005)(82310400005)(1076003)(70206006)(5660300002)(6666004)(316002)(7696005)(83380400001)(36860700001)(8676002)(4326008)(2616005)(508600001)(40460700003)(86362001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 13:50:03.8642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a50f3282-98fa-4e66-060e-08da1d548311
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5727
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

