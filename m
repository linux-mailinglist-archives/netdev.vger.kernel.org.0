Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19633678864
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjAWUgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjAWUg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:36:28 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059901DBB8;
        Mon, 23 Jan 2023 12:36:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mr14+TQpizbQz7B2pug/h8QyIJ2K4cADX3hvvE5e0zbx/eRyZD+mrXTOvL1IzLIVcZgoI03Ev5vRAm7P6GY4SeK/oawR7LrJJcR+fbTHiqbmgnBG8JSc7P4VSiLB6QITDMoucDroocLACc0HbhfyK5W7yNvejAcN9P9mLWCJtwpLlP1Zy+iKefjWD6i9bU6h+as0K7VCuF4DhhNBZeFZXF/kHqvSVWzOVgglrs3tKoeRkclAWskwQ9oba2uYAMpwyWmguLlOk438rSFrNBosEc54VueqrPvLJKBefioaJEO/7V+oF8CrLnX6IR1Ae3IX+59BNVs3WViweM8xsN8pPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/5qhZMcxbuieGySe9aeptZ7GgD7dbsVtDHB1SonTkA=;
 b=TqhJqlZRDQ4tyoRP8t+WWT7ci2ZyhZaSYaboDGyBR0JRGHKkPRPEhQBxDyXT/TR0x8XrXCGbbT50i4Mpwd5gFtnaOfk+eg7sKa5CEHc62NCZLkzo1esQha/VpwpkvSQbkDLZQnSxnFNndoabVbRSqb+tYnpTG/U32Y/0PCJqWWJ5JnSrTBhyuddKCUSngbfJw5ryWC/cKrzUoXnYih3YHKa/aYE+peJmPTQXNUw3Bkbdpbl0KTeeLO6aq+PpeR0kZjL0r95ml1Yjv7+nroTgINOKO/RvSRVrngZ9xdlpJZa9tnaeLsK5IPJ89RSHFER376Nma05KSgGkSIjYfNl9xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/5qhZMcxbuieGySe9aeptZ7GgD7dbsVtDHB1SonTkA=;
 b=H7Wk43EIbgaTZo4N/INcAfCFDYcZmr1DuuBiNbytKXn+UMIGTuPrTi1yETc03UBZ9SowJw13O+UUtCRZuZwRz0RArBvCi1qicj5gTYck1KY5dtEj0Exzmp8bKvnMHqbqCX6x6zBWqqqZKQs8pujvLuAwqc19cqkxIO/KwnZU8ni+IhU75yLabrSc40iRy6n7lUdUeBIz9KPVUYaJw5Pqim8vGbOtaz32wv3hYt1/voZg82y5n1zMDJicE9b9hyoa5gu/k8wWqrogL7zB2a/2TRK3ocKvVrKB/rEwNYMr/4EsaWB99JHk41YLNz1iCFSO9G2bnoD7NcyB/uwsNV8B3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6571.namprd12.prod.outlook.com (2603:10b6:208:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Mon, 23 Jan
 2023 20:36:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 20:36:06 +0000
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
Subject: [PATCH v3 10/10] iommu/s390: Use GFP_KERNEL in sleepable contexts
Date:   Mon, 23 Jan 2023 16:36:03 -0400
Message-Id: <10-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:23a::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: 2516c879-d1d1-4824-29d9-08dafd817354
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LVGshr4er2elL/unnZCOCqvxV70HIS4TLdoaezQkk/BGn29wHu9juFzGd4KlsMbViOkRAlHG/EEXd7ZxxxJROEhPTX1pARZxnMT6gu2yJgDfCwUtYf48F5g7DrsTsf4jxtPW5+Cz4FcPvJqPn8SWcFpV8eNSSe0IdUYw+6dLj7r7TFNJScqQmHB3yUArWSKxdyL7Uil5RV+Y7h0S0U6+KOJ90qv4YyIAK3ufIMKDnjVcLRRHGA0Ei6hOao0yiVlgxJZD1tEcA2R2dIV+u1+BSAtfgXiQXe2PHoMFrJM4yXNMNLUtDypRpMfhbsGw3NAYA2QTOZFuHpan0mC4Lp9JuvaxKrxrC9OZ6dz2E25lxYKSERJ+gQVoUR6lglgAnnLD3dQHd+RUwCrxO1yqY4aOhfqTSWUZyDNWcb69Q3DkKMijnU9reO1Pra48n1Q1n3InSYezVuYqkM2AEI1BUtAwfH8VcQFVuTRbaMGb8jBYngLDRnY7/BlFlFfuZSEcF44WOmvV4pnlFfp1Mvhugl13LVB2Jdje+pXpotG8cdXFyOwcr07EJOuRj7b8p2Xrqf/g/FKNDuKerFxS8KCbt85iz4A5mj1FTk/IPGR4MGo3hQ+0kGra0k/+BqQp4NaWD57+34B2CC/EsjNYbxLGJyGSjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(5660300002)(316002)(8936002)(7416002)(41300700001)(38100700002)(110136005)(36756003)(186003)(83380400001)(478600001)(6666004)(86362001)(6512007)(6506007)(6486002)(26005)(66476007)(8676002)(66946007)(4326008)(2616005)(54906003)(2906002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aX43Z3Qps0hqfTvWsm+MygYbBsHjUyNRMkSVvNFeWJ+E03PT1jnM5GOMlF4w?=
 =?us-ascii?Q?CISel+zjpLsbZUSsaY6sLYpR8ZPort2rw65kObQ3VLr8HlZK5Rbuqz/e+5nu?=
 =?us-ascii?Q?tz7Y+1z4gyXh8JxPMBo2gdmCZUCf2R5nUUOW8ClM+NGDmco3Yox4LU8jW8QF?=
 =?us-ascii?Q?7LmbMaEcjbh7RmAaqxCURMRYPRx63Jd4xQunPKfKpbFSW236EXIllcPDS5Zx?=
 =?us-ascii?Q?t3xgrLYmVBhO+0V7tOexQNHqCrSvsK2o+cQznAqK7J3C3NVAj6qvihvXLZmp?=
 =?us-ascii?Q?ByuoNMTbUlXXSiKuq2GzICiL59kfa9izQ4kCn7vynSfAvuYWsT/F9rK/F9gl?=
 =?us-ascii?Q?KmW+WvsuIYVE2dbu/BJ1QSFzeMiPVnxWInUfxKutpjoREBuUXV7pA40wYsFc?=
 =?us-ascii?Q?Jn2GSEbTJdFbtmaO2/kD2rVJaTKcb1yAOgjwqEfoF3rlWyKqwhD8KvG+AtlD?=
 =?us-ascii?Q?QAi6cfdZy/cFL6BkURQ828r2xxU/hdhFZRQHMkG+P1TkLZkUNN+Bb0/bTn4b?=
 =?us-ascii?Q?DKG696vrGtD9oh0lvfWwORhXIG9VBZg/bUPQ4FDCfIkmz28qdfymtHMqbQTc?=
 =?us-ascii?Q?YN8IdOqtPTyE6eeblJKV8wLFbt3BWCLSViEnHAJGPZDoYjs2qVhqEfkoNsF3?=
 =?us-ascii?Q?H594Txtvuf9FlbEo9TNLLm3wEW6bAPW3Y2Uc+wNARsCi+pKlWXaMP9+Lon47?=
 =?us-ascii?Q?4ahmUdV8HRkyPejdjM0GpW90VhWT9PJ2vSXJ5ICSIgQgizYzEmW0DlxGcpe1?=
 =?us-ascii?Q?N5q/lvZBJPTHSQNaf6HcJYHtWTEntkOXjnBgroH7RG4Mpn64oV+KN3cPL6ce?=
 =?us-ascii?Q?Hs7Vdw2aipJEFpVeQ5oMvF/tTN2jhata6hQwiQIpcHPu15DsxxbulrLq3YMt?=
 =?us-ascii?Q?OgyO7wgwhild+a2LzVx3G/8KeqSCSReg/xPbsLWJbg2r1RNgcXG+vLJsh5w0?=
 =?us-ascii?Q?I+JlXJ2BFE6ZTdL2wXn9BL8+PffxyB8DBeESoLCpanXJ9/SLKZhcfDiIFpof?=
 =?us-ascii?Q?QH1yugmma/Br8ZaQIc0R8msPK9uJd2iiUnn8cZZf75+k8l3S/w0AlJqyXuN6?=
 =?us-ascii?Q?yVmBfmrh/9dVj5UA6lPxw5ZIjSmg127B4a23hSyoYqXmj7MF36cMRnZNbLI+?=
 =?us-ascii?Q?S9XY9nnIldBDMEkgwCTOyEV4uzBSafzO1wzj4zQOqM+N6MDnXwxhy2FyKJG9?=
 =?us-ascii?Q?6AcxHrmHX4csojpjgbLTdMuG9MtLXqx1cUR2GEPCNMQuFwyr9dUrR8Os7MXd?=
 =?us-ascii?Q?bIJKGheUuwGk6CvyED8F8kE7c8oSXngJnzeyXmalYvhgD2/n6X6FiTQyUj7I?=
 =?us-ascii?Q?+GQCGJFDJzWYcpvg713y/k+WMnA3zvWZJblG2lN8euIfRXOSuCbt5F9YLbA5?=
 =?us-ascii?Q?Sdx3deB7eYSMaQ7IHOIOjhZOtVtQVkZA/EaEnYgsyMUnE9ice3+I7yRt83dW?=
 =?us-ascii?Q?/k5RXSif32PdF2EaNmgDJ+Bg72sIr+SZbx7waNPF9SJjqeNBHmigRqxw5nou?=
 =?us-ascii?Q?2J4Go3VCxHRgo9bEALVJYyfRozunEx9PBMOuOQaDraxogp4MKKqlHfc1IvYC?=
 =?us-ascii?Q?vfT/UQ102oNXq5OSxwx/l/hvYWMdrKgY9HE+itCT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2516c879-d1d1-4824-29d9-08dafd817354
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:36:05.5413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwNuQbrVCMq1U51lxXzJ35/JsQt/2JC5UMBINcUbkkaSZVvWTxcX9wF/dE86P867
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6571
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

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/s390/pci/pci_dma.c    | 2 +-
 drivers/iommu/s390-iommu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index 2f6d05d6da4f76..2d9b01d7ca4c5c 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -579,7 +579,7 @@ int zpci_dma_init_device(struct zpci_dev *zdev)
 
 	spin_lock_init(&zdev->iommu_bitmap_lock);
 
-	zdev->dma_table = dma_alloc_cpu_table(GFP_ATOMIC);
+	zdev->dma_table = dma_alloc_cpu_table(GFP_KERNEL);
 	if (!zdev->dma_table) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 654ec4411fe36c..7dcfffed260e6b 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -52,7 +52,7 @@ static struct iommu_domain *s390_domain_alloc(unsigned domain_type)
 	if (!s390_domain)
 		return NULL;
 
-	s390_domain->dma_table = dma_alloc_cpu_table(GFP_ATOMIC);
+	s390_domain->dma_table = dma_alloc_cpu_table(GFP_KERNEL);
 	if (!s390_domain->dma_table) {
 		kfree(s390_domain);
 		return NULL;
-- 
2.39.0

