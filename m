Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863586725DB
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjARSBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjARSAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:00:51 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C404552BD;
        Wed, 18 Jan 2023 10:00:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1UKIXGh4R5oiPp7pZv4E87H25Dl5kJ6OhaNWVI/ohJOuHcmSiD7RENHZo35+y8+IjW2Q+NFL7H0eGCq+KcVgWei3+mqbATloGFQJd/sA2eQxlhZ4+Rb2G//NKrrr5Fcnnm3KZVugIcj3i1FODfHt1q0AMiDxn5X2AibQadqWBTkl+uSzWvBa4A5S/o5a7HEQdMDTWdgYJp0ouz0ybM16+USI/IwWaP9iksqAw1SWb5TCGt4grQhBy5PFcyj3sYpLSBafBp8L1wfw91X8WdvduGSxtW+M3hQUzDv+hSYJ/bX/K1488GUCYOuk0Aql712LkMaf8d/7Ln7VE27GUfc8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uOOUUOL4gGvZRR+WN42+Xle0Izn4ZSA4TRUFQt6ShE=;
 b=cDaOpqv0PcJcjSL836icdtrRUvs5x7AT92Z9Ya7aw+nkdcajLzJjqnnGzYXgPRO8j7A44e15Bq5xCpubAw6ZjlmXKvberw0NlIxHM+UzRAirNJgT2gD7rwjRkYcy+BrJsBlWMS5cG1rLdTRWKWk/o7yESEiENxQKVvFR5dCDJNYyYsmkQgTe9560W+3E4pvmqeO4bwv/7wlebH68X7oqxp9K7MNMkBBJeF9ZlFD8JypMqHSY/ml/AIFZLWAXv4fM4Y8pfnY+lcftDq4z5ppINDv6RZMIQ1Y4uod5kA5QJfyZo4TFmHZsPiSpi18QEbK/RPJXTXLKncKd7Wt18l2gvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uOOUUOL4gGvZRR+WN42+Xle0Izn4ZSA4TRUFQt6ShE=;
 b=b3bOFZJX4l6UWb3rWC7MFk/RD1L6GAH5EyVj5JF2TiN2BRD2bQoICw9aKx/iYvP0mMH0qrXb8rN4D1qBM3br7bDE6Z5kGsgPo/SiwHInCj/5TIdEM+b3VcrIVWjdLnG61aR6apBzdT3ks9XpsMG5RUwPGSqRrzHhccWwhn/uQGQ2jfACwhFrpp7RFTqPv+qEq0oL5cvlTZrO3vRIwmsSZLjFJ6hudwpqMCnyoZHKeSVj0XAeSyIJ3W5C0zmC6QaAANaXbTlCG7+QF6zaQXiUztT/rCCT+vUXKpUY6dZTLCUuYJtV4EonW7R6DQvEK1NzZzjsyP9REEDh/rEVRxr2RQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB7614.namprd12.prod.outlook.com (2603:10b6:208:429::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 18:00:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 18:00:48 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-tegra@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 08/10] iommu/intel: Use GFP_KERNEL in sleepable contexts
Date:   Wed, 18 Jan 2023 14:00:42 -0400
Message-Id: <8-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:208:329::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7614:EE_
X-MS-Office365-Filtering-Correlation-Id: a5a69345-a01c-436b-51ce-08daf97dec4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4CXtxxQO9qF+Sau11E0b1oaPPiAZpEwBPRQFKY6/wBqYu56uLQR8bZsbeymxlMrqN9Q475nf/4/saPyGaocs2r6FvsjNUZNO/Vb4BgNY+Cgl/I+DCjrZYhYsAefIgoiNgLQ2XR6hHgs9WAw5Y3CXmLDr/BafS2p0qZi+PUCzZQz7CFofPS/nN8QhF5ttfinWu/WB9g86VsOT/XgAWl53uiluz+5v9dMZfIOaSAi96vd4QCpvvDEzPSX6x0ZfPqZ4LouMItw8yFl4e4vXLlf+w+sLqnf3O1jX6tUXAEucswF6pA5IP+dcv9TH3/cv7imLclxptkhyEeMUPY3cE1IvcQW2HvwIOSKGK8e77MMzT2rjxff9Fu5zCDcHOhmG3372ufTdCbcz+sYYPseMCuMOZgKAJ9eBUSmwA5zx/oQPoHa0NHvtCsYpbUU3qsmbnpqbkDxTBBgQLyvy9ka0THmD7zQRkztUfJq/90Rbq6KO+Vnp+wXKo01WcAFYRwnwFWX/GjDobL/+r9HnuNRIdRN0Ent6rw0KKzzPyL+s93VKnbJEuJspsOQmC72KxCev83sUX5AE8iXicg832+/SIuHacpNPKwiF29fz/BX8DIpy3XRbxWn4Icom8EPmb3FEcWSBDjCoekMxHTfH1WcydM1sa28A+0U4Dce8R8gGdUlfBeXaWWBDXTi8YclIZHCdcOK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(186003)(26005)(478600001)(6512007)(6486002)(6666004)(54906003)(316002)(110136005)(4326008)(66946007)(66556008)(8676002)(66476007)(36756003)(2616005)(41300700001)(8936002)(83380400001)(2906002)(7416002)(5660300002)(38100700002)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D4pi8WCKPrVH02kCBQ7m5F2S4awYjEluHqNTutFAttYZlYMDYw21IAprhzB9?=
 =?us-ascii?Q?U76DS9pfjusV7PZ1TUEYMC5hSLawd6G67XN9qymgSp0VYnjwvn6lEadrXsFD?=
 =?us-ascii?Q?uR9lafgh3Jhu2s62/qf185IiNkNtQlo8nPZAOMC01uOEnPiOClYrYWceSeBj?=
 =?us-ascii?Q?FHE+O1gMkO3hgj67d11ieqh7YfO7VuKo8ejGIHhHdomVi2BhD01TRPX89K1s?=
 =?us-ascii?Q?HPAzG9x7tn/wc25zRzex4UJ9PgwYJvg2GH14+xWfEnv7dh642U8WgiJC/Tqv?=
 =?us-ascii?Q?8ZEmFQ2QwOPZHJyjeGHa69mm61MI29Ck8T7/TBuEIEtrZFKljn6goFENT5hk?=
 =?us-ascii?Q?OjMCQpvBIom5k6DhDkNlHMLYdkw1TWRAIObeQFQsxSy+T1XThM25bcapN+gQ?=
 =?us-ascii?Q?Sh57NFHQRCPZ6h0rOvbGONbSIWr5ZHwx666/IvPM/aBJ7AXDct/b+FpxBMwy?=
 =?us-ascii?Q?mgsH38SYrIUvN09KzNSdcZo+AHPMn4GB8qb3gxXKjq0LgknJxtp570cV2SUJ?=
 =?us-ascii?Q?SSMm+OSABuBgdoe8q7bTtIylMpUwt+7xUCQd11khdRlbRRsbCEIIBnSuQtwN?=
 =?us-ascii?Q?gCQCvYkCe0FTW2FhfyN3ZXTu+ecnZNutmAZ/p+AeFqtwxaGNxerHREu7yBCP?=
 =?us-ascii?Q?PrJYjNluSH42+jynau/guFwqRRRCUA27+hLuqVCrdroqvgwKyEiWKyrfT6/4?=
 =?us-ascii?Q?Y7EB+HTZq1A5XeMUtI+vQ+Y+uXpDNncGKwqD7U02d4P1zSUe0doXtCQSelY3?=
 =?us-ascii?Q?nUd6eAI+ZbfpwKwGkUECWixMEQQ9VzTdR2qsLuxBqkWCG4Oo4BQrZcTkD7Ch?=
 =?us-ascii?Q?uQKOEKlf2SJErshLKp4K5MBIiciaBra9Szsy+d7UfugQXy9KwfcfxbUMrySo?=
 =?us-ascii?Q?iduTj08enSaOSKOWJFuHgpClYsWYSUyeogtVJUe1BkhhOD+bXrOPSYhj5fLb?=
 =?us-ascii?Q?H8+x2VmpKMbgcW7x5J0xpHG2+zUvCAvd3C5hxLt33WGVsQoprOvXrAOgLCCr?=
 =?us-ascii?Q?+8tiReLlwOuzxlnAvRPoVrLEF3NyHQiDz6AdKfltgZ0zwZw8QVcA767jK3lG?=
 =?us-ascii?Q?OxXuXjLlrslTRAri6wC+L+4K1/9PaFN8HgTDbfoyaX45DDsSywjDXOBNpcZl?=
 =?us-ascii?Q?N857Aux5K1xnrq8hjBC637aDhX1tXSfhkRjdVy0M346r5aplQB6BXHqeUPcF?=
 =?us-ascii?Q?Wg7WA7qt8ndoa24WHIe8yD12ZG5QYFi2RuaQyp0oi6wcxtHmcwoWtFBMlhl9?=
 =?us-ascii?Q?WSSmh1XKJkUfTB5fiqntrM+ugj722OCyPlLVWkDYgScv7i3ZxKClNdJgxpVb?=
 =?us-ascii?Q?EDHgMgcOGc+eKCJizuoWjW66iHtUAcvFiNBMjm7hx4zesafkEBtQ2kM4g6p/?=
 =?us-ascii?Q?r2o8A5fHFk7h2Zpo0jUImadYKbTlq1b3j8sCtVOfqR24mDzj9gK49vM/pjtt?=
 =?us-ascii?Q?nISUVK6iHyJkD0jHdxrjCp2n/m3Ny4/5mXrBaHf1BI+Ghw+4PQ8zfXbRqJmC?=
 =?us-ascii?Q?+yEl8ko/wtcs48wBGKPs6DEcnb9AD097uUnnvs+uLohG5WqFlw7O4LfDJMuL?=
 =?us-ascii?Q?E/5yXWWw54zirJxtFegH1/gMudn5jK9GKxGGOsBZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a69345-a01c-436b-51ce-08daf97dec4b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:45.9902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIMex9DmzSNfbXvUopUHrmQVwxPw3OnGg2iXBoYF6MRDT132YRNeIOLlx7/qi50I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7614
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These contexts are sleepable, so use the proper annotation. The GFP_ATOMIC
was added mechanically in the prior patches.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e95f7703ce7b83..a1a66798e1f06c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2372,7 +2372,7 @@ static int iommu_domain_identity_map(struct dmar_domain *domain,
 
 	return __domain_mapping(domain, first_vpfn,
 				first_vpfn, last_vpfn - first_vpfn + 1,
-				DMA_PTE_READ|DMA_PTE_WRITE, GFP_ATOMIC);
+				DMA_PTE_READ|DMA_PTE_WRITE, GFP_KERNEL);
 }
 
 static int md_domain_init(struct dmar_domain *domain, int guest_width);
@@ -2680,7 +2680,7 @@ static int copy_context_table(struct intel_iommu *iommu,
 			if (!old_ce)
 				goto out;
 
-			new_ce = alloc_pgtable_page(iommu->node, GFP_ATOMIC);
+			new_ce = alloc_pgtable_page(iommu->node, GFP_KERNEL);
 			if (!new_ce)
 				goto out_unmap;
 
-- 
2.39.0

