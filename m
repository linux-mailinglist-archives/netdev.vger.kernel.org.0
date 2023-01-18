Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C7B672601
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjARSBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjARSAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:00:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E8A56895;
        Wed, 18 Jan 2023 10:00:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsA9cv7REBe37zw/vOhFLLGs49vLLa6GxZ9aW2n+1YdbHbZ5912j/snkSjQqBkWUahO+t99LZzGLzaDd/QeW0WyB2FCi+I8u34ULF+SHAklY6qgCr7YE6udA8Da+dfJFv1OOcEmjkvLRWGJBNQWoR8GmKx/sgXC1hkavbG/kJu4tGsDFnnPdzqOoJQmumOYphWMRn44SBv3J2wTlOnpOLls5D9zJVnsWZhOqWYu3nYs4PB6XafOLu2+YEAg1Dau6wDwX7+jDQJ2KyViTtbK/Vr4a8DhijDJQYF8bIIznmU575dcXZhg+pPodA8LzDslg1/3fjClHjgBsJX9Vm5Akjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqPQQtTRQUpYSGOXmSqMnJWIpGPVCuIxL1bg187xZXs=;
 b=Jec7mNtiT7LwijgwO0G8/3sDu3mWO7u8/M/KcWNhYtyFFL2661UrrME42VBXYIGlcK+OlLkU+bE7U8aLlkCDC3g5tylwpRc4DInBU4S9TpG8EAx8lW/bSN4x4176+wAk2iKK0OEFR0aBG/Y7jx2gfc3LmPLx/spJ+J9h9/+1qDlZ1F2j2xUX0e5QDt0Yp8Awa5pW6h6PkycEB8r+wAvwPpYvZbfh1yv8GBczkpnhCNVFiIx6JB5iDDdlM3gXRgNtDknaMkc7d5rWjrrp34YP9Y6sDLErTfa6A9Rbyntqa0AzV8NoQ5Py1ssB83Ik5q39PKiK3bKdfjC4Ef+wugZSbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vqPQQtTRQUpYSGOXmSqMnJWIpGPVCuIxL1bg187xZXs=;
 b=bEG7OuyKGPl10p6JweU4jUhea7ZDK3C9Q8Vw91dSN86drPLLuZTET+z/W8uqZiz35M1vjOhtlH5G1r9FH79YQp/Tg8gvgy7pTd1WoQZM+DJsf4RkXzhWoPmSIDyhNvWQo1ViRtRRs/PAeHOrHC5v/8HjTJW/eLR84Bl1oWpw12hCtD+a1/G3tszY9HQsNVcOojL1CuUX6MoEw1HmvUcui4i2PR94r6hG8Hu6QV6+9zDymfGl2K1V+eFnDOiECrQPpQXZks9QcBvudNrUFy2fmts3RdVSlBIllluATuN5LFXM0fbktEMStQkroPhltqHf55Ez/r1sT93w0/RcKq7HKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5818.namprd12.prod.outlook.com (2603:10b6:8:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 18:00:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 18:00:49 +0000
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
Subject: [PATCH v2 10/10] iommu/s390: Use GFP_KERNEL in sleepable contexts
Date:   Wed, 18 Jan 2023 14:00:44 -0400
Message-Id: <10-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:208:329::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: c1721888-54a1-4925-7872-08daf97dec52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EaU9ywwN6UQ6lqY9VmpkUIvlY4Azaf/JXeP0m37rNvOhCk1obBI5yEO2DbdCOn5hOUqKKp+g6+I8knVHS8WuwQkneJLcSsRH8EvQXA3uYk1VsXX0jCxW9xRIS6G0o17fQ1yoFnkeKPuqNFRiIOYKuqRgRZp3zEV6ZEQ9wsYRVPDBQ67oH4A7yU1s5oCBZVuukpTVZx+eO4Ab5tX87jRJJ3zBrELq3cswVHTsvCdOC/kXo+P4hg1wILAfXg2ytWip4CWFHFFkcbWSQeHoA3jyu2iO+EoTCefez440pPAFoRawGCZ7Kvbm9eb13QHbJ2gePeLN8g60wq1eigS/TxyCYVfhOcbmfwq1VdEMt8ciJHI3Av8E9/kW4c+XWJyQF0eZF4Uno3EHUMe6F8QyNHx2PFV8P0MKI/fhb+O1mNByHjTOWhwVzwq8d5AYM0KIBNBH3x1ub9h2omu3RvWj3KbFBSvqVxwQEre33r87EefeKbHxq05KKbC4lSRcvXE1rI5+XmyGm8WasoL8IpCC0xV9G269/6lDXfVgjdqoJkVrO4EtGDSsm+VssV38kjXQAZKTyrHzs3/Ilru+vBEAFrgaTL1/c9q8J2uTdugc4ezHojJ7kQPlsJE+frc4cOk6w1x8455A+jZojjtV3i+YGbwpxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(8676002)(36756003)(83380400001)(41300700001)(8936002)(2906002)(66476007)(2616005)(110136005)(54906003)(4326008)(316002)(5660300002)(38100700002)(86362001)(66556008)(7416002)(186003)(6486002)(6512007)(478600001)(26005)(66946007)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6xefLf1A7b6onibFJL4xcR/mMuhUGDqMKS+h80M4YEmmEQm1qxrS5ZvNBA+u?=
 =?us-ascii?Q?rzXhGvukVau1KVHteD9OVIjy5Hpn4QVACXetjIBiM2pZwrwGpjcBF7byuFM4?=
 =?us-ascii?Q?CvnBEM6okyNEFDhCpP+D/SVeTTWHeZkQOJ0c0jcYEvQoFOrOKQEuOLsarNgj?=
 =?us-ascii?Q?oXiX7CBxHOjN9cdHEyJy9wMs/k76zLk3j7xTPDw8YujTFtPT2lTal+vHn1ml?=
 =?us-ascii?Q?WyY062z4c8SAP//YQmwYoWLZTLlVbl+9h8qTXZdADFoPwYwg7JhKSLv4oKpp?=
 =?us-ascii?Q?rliaTN2NCGdt2hwKWlW5yIChqE0jwXtOiBSIhaV4GMRKvFf0cS5MWOHEK7ZX?=
 =?us-ascii?Q?CGRKE6iq7RzkQRbcbl6lrYntMyyngL++HfcCicCSovmQsQ8PQ8iBDIGdVnaE?=
 =?us-ascii?Q?wkyHV5/GmYZTDrtvZDb2vrW5+4w0zyNnUeLctRcx4s8ZtkJZDkoz08MKWmTj?=
 =?us-ascii?Q?H89W3yZXPp/CtFhQuIjqxLvFjcpt9qqdYptmd4Yx5GbJL3dfnBoEjzyTugMe?=
 =?us-ascii?Q?FOAJob2OOiWNCOKhC6/JsNmPNnOcn7ffN0z6wj7yW66tJGmX9poL6ECKnST+?=
 =?us-ascii?Q?m3MKXONv+LVbDRkBP3bhavohehSpmRRyBc0BgzIMcy2Krv5zpgF/YBf4Jfrd?=
 =?us-ascii?Q?faW7+lk5qqFSB3ofVhvOv7JzVsbJyXpHVnAwoseO8KWtZdH9wKHuP5Jmu8Uf?=
 =?us-ascii?Q?MRpEpj57+sg6Cd4Gw6/WOH/vxp4iPNQqSX7MsH9FYeDUuJJNwYypKvRiJ8ul?=
 =?us-ascii?Q?EnakRKsNNi8fsdwi/npFS/udPzBqU6MNsZi2O/UHC1lSRJKmMfxWpgSLRG1g?=
 =?us-ascii?Q?cjxU0VQg3fyrpuV+KmWa0Uq38YNnHu5w/uN6OiDUX5ikEAPrkfVrKKy+VDeR?=
 =?us-ascii?Q?N0Ntx4i+JSWH0eJuisJWHIh2qXVVoTgq1Oqamdhe0P2kc4pRvza6l4+auAMi?=
 =?us-ascii?Q?MbBdnnus2k0uy4q9iQreHBry+Wa8GhRkkZP8qrsAiwvcAnQrQfK2gnnu2pzb?=
 =?us-ascii?Q?KUu361hZ7BELWtZxIvWRX0J3UiKoxeE47Z5Fmf8UHE/Sn7HqZfG6EMenWmid?=
 =?us-ascii?Q?vJoOODg2w1ax9440cMJZ/rJwXEx8jFTT4jFGaC0G5R7JTQgQM9B9RvE15H39?=
 =?us-ascii?Q?kEsoU0S3fAZbPodLJKvhIsViAFIXa3U2P3067/Q5uOaVZ6KoRWSRf5VARQgY?=
 =?us-ascii?Q?+HXqE37XEHznLELGAATEo0uY/6bZFh19zF2uV9CYJl53rDATZI/vOd3nh2+Y?=
 =?us-ascii?Q?ZFmsvD1ykzkwGIcoAgSgAMhIof/d/ggKuQGyMn/Sr3Ig616JewsFopajyKzf?=
 =?us-ascii?Q?LhzvqS4+YE4xj+iMgzrovgMtYc1SitPeFrkEOrUhMJzPqkdEMg61BeSDVRss?=
 =?us-ascii?Q?lRB192lauuwRwe26ZAUCEL/Rfuecgyz39/YuaRhjVF6/90bPfwvSNFtw5MsG?=
 =?us-ascii?Q?0aGxfDgXMXXRWV6BKMmQbl6Xv9e95uVNajmNROYyUpeQpdzKrKpDfl4P1RvP?=
 =?us-ascii?Q?GrgOeb+LoN10DKH/ZCBWdHbwxoHdCfDaSqrTxUoPisnvbGaqzldqvIMamV5C?=
 =?us-ascii?Q?FLPn+Cgug8S39DehW6LS1EXCoO3ttKP4ryLDCNcm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1721888-54a1-4925-7872-08daf97dec52
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:46.0214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZqc2vdieqmNxvGL7Dg7UiD0Zivm0glFD4RNBPiJvlFLC/n4oq87FtslIka/Q+t9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5818
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

