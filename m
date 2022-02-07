Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845C24ABEDC
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447855AbiBGNCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447284AbiBGM4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:56:24 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2058.outbound.protection.outlook.com [40.107.95.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6290DC043181
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 04:56:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAXCB6maPPKxm4JdbwtSsBKN/jZ1Cdw2BgEXlyP7RpK43kSwAzI+4wk9K5r027h7OONjDcqRdmk0QG4E3Tbw0pXVK83g5hwy8nB7MsGHGu/1myiotoTtF+r04aTSW/HqKrAtJisH3R7yvnt5wSLvUZgRRytEwzUv30YFr8TTr/z/oxl79l1vU9mpuSjE8W6+Q03onjRUYG6yS6/nc9gd2b7gnPHcbLqEQ7BAanpSN2oAdgPC7C4/jS3RIDo1Lytxcg7poDLLl6VRNl6t7ZZ6Mg0G8LxOgwW6f2N9mK+Uv9kN0JjbFy0m7c0BTTDsgEOFMs2aDPQ5x4TfsdUlS3URRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWLqnuJ3ykJnW5siipkQ2N8gauNfPYAN7oUheCWCBpk=;
 b=MsnmLAw/z0FrNmwRsi2rzodYlm3m5s1Pa4sqsGW+yPP52DpRvg1IuzNeyP071OcfzGPoKDgRkakkexb+H1po/sI6L84xfbuSeFgntXhF4arTYjHy3AtQvjFdidIVNs39nsf8IytvhJIfpyDA845hfUXNPlfxgY8Sw6Rk4RrKz/dmXE+JSdA6HF4EmUsrre+gDt/p/f10OhYVnqcX2sJqbt+s3REX9eunvNQ8JlTrmoAtTS8rEKoMtrE7xrFbeTgvxQ4l3IbDLfW2b3HRi+nAF+zaDTPVXpi0no3MtiX/71aZstFUqGWtYAWize1NtkFFffLnBF14FmT7DyHBCOHEzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWLqnuJ3ykJnW5siipkQ2N8gauNfPYAN7oUheCWCBpk=;
 b=fmiw2FEjzOrnrnGZb4bvLks/mEnirDb5RlmlhnWmWsypdquc0M8jFNv3qG40Q0jhXdGgLoNh9WsEhySKmuwSPiQP+ukiWebA/rtQjpo+BQKf3lzui4SaKWilFzb1g9bpTiXphuselnrs4VOw2sxctkLIDu6nrt8cuJUhA0ZrgebVNWLOKHMJ/RAvkepQe1ZFFjh10zJWxSfcvJ4mXCDJD7hRDpxKGccUW+TpdiTxQHNni24037h/smJnXk4vR9SFM4Kf2pxhGoXbC93wF+WbfUCS6mVbbIx3pg6zuPtNhiT0ED8sNw0WqwR+jX9G/Ny9aSr4ouRg6alArYqzUJZsFQ==
Received: from MW2PR16CA0027.namprd16.prod.outlook.com (2603:10b6:907::40) by
 BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 12:56:21 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::f0) by MW2PR16CA0027.outlook.office365.com
 (2603:10b6:907::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18 via Frontend
 Transport; Mon, 7 Feb 2022 12:56:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 12:56:21 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 12:56:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 04:56:20 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 04:56:18 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH 2/3] virtio: Define bit numbers for device independent features
Date:   Mon, 7 Feb 2022 14:55:36 +0200
Message-ID: <20220207125537.174619-3-elic@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220207125537.174619-1-elic@nvidia.com>
References: <20220207125537.174619-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 986a0335-b3bd-4a8d-78ab-08d9ea393d61
X-MS-TrafficTypeDiagnostic: BY5PR12MB4209:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB42090E7B7C493B45EBB40EC7AB2C9@BY5PR12MB4209.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2294brMmk19YxS5FnzWj3IA8be2hU4D43adUFtlrgsh23ITXho4X7zekJ7Zhj1YCphnMvfQz10FuZXi8LX/lj4271pU/ZT4ojQpxRkJ+pzKOW3vdUdcLueRkz3kvn45I4Vw+NUreR7Pdvbuo8xDuql7wP5lE3Y1g4u9V5KXAbtoTmPwGYEDhFazYkm/4DZpmjkMrDJ9qO48+vGa4iKgeivXXZd/Eib0JR7cC97pcfGb3f8gH8Px5hAQ2T/mL/RhmgfhVWNkBfnoEf0709pEuEIXNfABRN0ZS789q1BXIyT3fyeOtObbI3hBLLYvrPvmWV7N+QLx5bS7C1lh89wCLqKkaIVL+J2dsTs/k6LiytnMqA7MwlC6Y+2mqxnxD+agTyU9UIlKaTWuqRGXEEUirGJs2XSzrDhAAtrMMVNlQ344ETWhn4gl4gl4CsiHN9d9V9wrETUNjhEobdXhZ9YtjBLjWOqVLUizUgWsIDJAvl/jtWodgoB1Jz2TAPkUSDbxXG5oaJQN1ljk8ZgL4JG4oxAUyh5p1fOF2/X3Hj4fSPIjnTtrh/sp5B2FjGn4ymLMvV0ES4yLmqs+iZte+mzWjNFxnbKjiHEoQzPJ1kJrleaB6QJKNzUMFf36xtbF2Jn8MsD+EKJxxbtzrptrVvA82jiPo6UMz1F15eXYKJLWouG5v98VIQ0A5J/1LzTa6pryqNkN3NdP3XG/9pWfKiJgi/g==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(83380400001)(81166007)(47076005)(356005)(5660300002)(107886003)(186003)(2616005)(1076003)(26005)(336012)(426003)(2906002)(36756003)(40460700003)(6666004)(110136005)(4326008)(316002)(7696005)(86362001)(70586007)(70206006)(36860700001)(82310400004)(8676002)(8936002)(54906003)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 12:56:21.2375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 986a0335-b3bd-4a8d-78ab-08d9ea393d61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4209
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define bit fields for device independent feature bits. We need them in a
follow up patch.

Also, define macros for start and end of these feature bits.

Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 include/uapi/linux/virtio_config.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 3bf6c8bf8477..6d92cc31a8d3 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -45,14 +45,14 @@
 /* We've given up on this device. */
 #define VIRTIO_CONFIG_S_FAILED		0x80
 
-/*
- * Virtio feature bits VIRTIO_TRANSPORT_F_START through
- * VIRTIO_TRANSPORT_F_END are reserved for the transport
- * being used (e.g. virtio_ring, virtio_pci etc.), the
- * rest are per-device feature bits.
- */
-#define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		38
+/* Device independent features per virtio spec 1.1 range from 28 to 38 */
+#define VIRTIO_DEV_INDEPENDENT_F_START 28
+#define VIRTIO_DEV_INDEPENDENT_F_END   38
+
+#define VIRTIO_F_RING_INDIRECT_DESC 28
+#define VIRTIO_F_RING_EVENT_IDX 29
+#define VIRTIO_F_IN_ORDER 35
+#define VIRTIO_F_NOTIFICATION_DATA 38
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
-- 
2.34.1

