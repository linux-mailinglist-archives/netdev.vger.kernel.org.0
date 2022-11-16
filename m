Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C70C62C825
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiKPStA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239281AbiKPSoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:44:00 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022025.outbound.protection.outlook.com [40.93.200.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E34F63B98;
        Wed, 16 Nov 2022 10:42:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fH8eLjcXxid2VufDrAX4P617bUC2lu/tskNP6X81HL4soS5LO7U8x0ZW5w+4bXTxlbryo8AywPuwXQYBxa7QK3RV9zLKpKcuhxkietGnFEMWfQwTg8hy0/la9mYMjrOBPcPcFXKsH6oRoT4Yu53UK1Brv5fLyE8e4bujklyOl1LdACXKspnpCRpO+NcV8GVelYiKBqEcLv/EGeRjajPR2QJ1Z5iSg9uj6DKbUEbJ5G6utiiBufBgVg2XyYlZ7OBky4WRRRPc91wN9NscsxK8GwyZfd1WhJ7FBvs12cVQ/evYEm+xgWbg1lm2oCSJGHLaLWwMxh0Sij5rP9tim7N2wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rS+XEDLCYXK3kG0pGvcV2b4OXTcv8/63SxxK34hw9ig=;
 b=ifV0n2eOIkmvwOv4s9uwRoy4CEGEjZTEuF7Tr63W+Y8MA40yyw54we0k8BP/eYaSDFmjKgAl7g+Pr7DbSTMDrTCY2EkdQJQqz9bjcDvQV9gLoTH2iUZ4FP719DFyndiAyhooqNLIiaJOK+xaHEBpvAjaz1MfbWGo+X69ajegwBTV1XwucesOe2M2k8ODTSbjazu7FTArkfYmJwd8ojLZvhVB4DEYmD5+35HSNsTXoIh/+WQX1m/dVQP/fHz9aqyKz+IYdk/WOLIeVa09hcAFRCvyqsmljq+Q3xwFeU5kc8B8GPeWkpSrDBnvJVPVaC4LRgrY2EyiLhgVcWvcAksHPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rS+XEDLCYXK3kG0pGvcV2b4OXTcv8/63SxxK34hw9ig=;
 b=Oqfk/QiutCkL0SPpFATFjdaOSr4KVSo6iDCMn3LyREeAXa5+tVDX3i6QtKbSxaw6IDBV66Hh1YWw6MdeiJRT1qZ5MocFS2BvJXtmV4nrSuo6Tl7/8Tje0Lpu6txW5daJlKoOpKFPMzJuzfnDWFRjZYXb+YnbwOvMBAQZNn8yf2g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:39 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:39 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Cc:     mikelley@microsoft.com
Subject: [Patch v3 08/14] swiotlb: Remove bounce buffer remapping for Hyper-V
Date:   Wed, 16 Nov 2022 10:41:31 -0800
Message-Id: <1668624097-14884-9-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0178.namprd03.prod.outlook.com
 (2603:10b6:303:8d::33) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|DM4PR21MB3130:EE_
X-MS-Office365-Filtering-Correlation-Id: fe84b084-eee4-4093-1e26-08dac80256a8
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LlLr8jbVIhGS7QfPEWg+lyP9AL8NWvdwnd1jRDs/gVL4LBkWfV/GJn1sIQeWyIp4Zakt9xDVPURr1AX4RWrnHIIvOPoWydng/jYF9msorun2WHI4gtGi44jX83Mrz9DgU8gcG4QvNqyszVbYz5j1oBSRUxr9OE4LzjCkihOKwh++X+3LQZWS852rQiHfGn0TTmYei7rN/C7k6Pue+RGfnaUpiR+fklWZ4neMIzPn0+VsQ8LHJhO/Dgnz6QjY1OERZ8t5mY+R6qWd+SOFqU4+1+sbZ+2m+kfr1USdO0ZSka/yps2/o7oaS67sqpJxqhw5cPwtQY3tvkkAbCNUPEz6ezT19eZS0iSe7wIxdoWxbAVg4NjE7LTDejACy1ev9HjLqzTCiyXcKYERofk1iMBpRBvN+5+NeGvWO2UENdp0btVByxFLAkpZ4TVYX/UVKsybzzbFezu5LwYuUIUQTY2db6qnMJQm69PaTstbKw6jqrpQq+TbGj0q4kIa617F/VM1Eu4I8xRTUknIr0nyGCUpgrhGuxj0iWDNfOHXnGFBnrnhihhdJgHGC6VWAYZgdYoXdLS3RuJSStJazEsFMwGdwfbOcvRGlzL20wKl51PHUMCChc/Ulp5lw7JA94B6oWQ3qbJ82VLkEyGHdRucb8egJ+mNN39JyEmz74k8jdDiGSlV1mamXkogNsM+u8MNdEhWW1+7e1FV9jDi6ZjpmczHtEWiDAIZbTJiR0EhKUYVS8albtVv9HV6ERD1P4t7hIWV5F8EX7ag5gEjOgfxUuwCZg1ZlozlNzahyDgVPb/QzbxTDGq+RqRAW03dprw+JF0QIOGy2B1ddqINrtcSASj5Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dIB6YJnJPGK/K8LxexS0U8vZCjv5wuEg6fmz+OeA2R+N7R7+jmQtZgXoxk6q?=
 =?us-ascii?Q?NLEd9Kso5VTSbu57mx24THBKE2wD7hQnjAHdnSEgA5YU5uY+Bau9oNjt3rw1?=
 =?us-ascii?Q?zLGeD22vWjUD6mQ1DWRaf2vvnzXhjMP4K6YB66zBtZ94MvC65QlyMdOU3am6?=
 =?us-ascii?Q?zL5ATaNFdJaA09Cr6MiXySegPiGqReTsJbmsq1DoIKKuxqTjYpcipTcjHDbI?=
 =?us-ascii?Q?YUcE2TCbvLrWFaBWgkyrvjIK3wLn1odM1gOdDM77HuGYkB+hRSmz7iN0K6Sm?=
 =?us-ascii?Q?mh/nN9zAHFhumiSSZ0go1QQPoK0pNzviXCUa/HOnfI8Plx4+AZaBEtGKUyl7?=
 =?us-ascii?Q?7kSCgNVydEZ9HYzvmD/aKNC/np4u/a5aN2WZgkbg7ZlU6FHt/OgNSlnfKYRe?=
 =?us-ascii?Q?eLzgF2+as16/BjaybsWqlYjMLC7yEiK5Bp90rQEAcNZTtPzgTWJ8BDpgpwmN?=
 =?us-ascii?Q?Mxei/mvLa+i+pilPLcXLg2TpLlyCOm/TwDhio6RrsZEKltS5yhBmK9WhQMR6?=
 =?us-ascii?Q?gX955pq64/jBlmFlzwVRuKcua6bNf7P1+G/Qiog+GqDvAeo3MKaiBcGiGCSj?=
 =?us-ascii?Q?2ashHbQXVo+3sl4v4v4Zz/5s1LlSYlYYontU/smXGGip/fC7Ay4LRAAR2Hgr?=
 =?us-ascii?Q?JUXZMEzT5D/0IVS0IwssXIF4l9gA6NpRAxM9s9Vk6iKM+6OusArMkNQWODAM?=
 =?us-ascii?Q?qwAo6wRdvthYTcX6ytyj2OYTBEknYNiLbXTHu4snW5iCmjhDQDLl2huQNOAg?=
 =?us-ascii?Q?9n4JMHL77g5+spLRgXlCXdy+tBEUuP/RbMtGrxo2BJ/KqyhNI04R+TOELp28?=
 =?us-ascii?Q?32BjCdsVwuzvZoRdadyknE8UyeTKYHXc6fe5ldB8cV9mrNdSEL8bUbm4Rhy1?=
 =?us-ascii?Q?lUOpfworzT0qGFa22CivbvZdXeKh71/xyQ4AZn7+K9KS6GHMgesBvbqbAY9Z?=
 =?us-ascii?Q?Ss2FRLLmYM6lBpX1dZf7j6zUvFGt0lo0Mz85+MgfDhK2M7CXy20SRFS/H+Bg?=
 =?us-ascii?Q?0WTiPaxdkHhXPzlfyzVSNsFsnO6+7JjpuIRoIlQl6/jd04+MxoYBOjAG2R8B?=
 =?us-ascii?Q?fKQi9HUepNcavMOjeTnAgTEVQr9BAeDsJ8j1IlHXyIMQwqn7FTE4A9NThNbp?=
 =?us-ascii?Q?rjLfp5HKIdguAueN56wqu+mJtIytXpmyVvyVbGt1bt4fvQ6YQVn7qZJCFvkL?=
 =?us-ascii?Q?lkFb/PPxyrxxc5bAeBba6g2svS/8Z9rUwdWrf792LfxACvZ9v66stIGq9XX2?=
 =?us-ascii?Q?U4pbmSxohzHjSJtPOc/4+XluMvO37+qi6ih5FKzBZyxon1SVVnSKURm+Vros?=
 =?us-ascii?Q?AqeJr/F1Dqx25dCh8ofjLBg9wFNRX5V9AYDPe8JqiRM55jZJyHE3tDyWwSh6?=
 =?us-ascii?Q?LiXdNZ3xvU98j0YWesrnb4P9G8dsaddJkIA3P3ppwq26limZpC2rPUXCN/Bf?=
 =?us-ascii?Q?y/+f0aY8IHshBMVSJuE8+re/Q6ZZ2/XKfJ/vwfL04aDwFNwcJgxRfkIaK4g5?=
 =?us-ascii?Q?SDFaG9ccw2fwV8VuQQgW2Yiizui7U9Bb/ODIgvLyouiFOksETxNIQRKMrNwx?=
 =?us-ascii?Q?BKwYrlsW6817JmLQigDVNMt7550NJIWSgIhSHTDh?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe84b084-eee4-4093-1e26-08dac80256a8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:39.7725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGtaTkmm+WyPj1qt4KrMB4dq7kMDXcI1h/r/noBLGRoJGhpmNPp8iRpLQ1FGHozsxOji/woQct4QnQZBnbMsUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3130
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With changes to how Hyper-V guest VMs flip memory between private
(encrypted) and shared (decrypted), creating a second kernel virtual
mapping for shared memory is no longer necessary. Everything needed
for the transition to shared is handled by set_memory_decrypted().

As such, remove swiotlb_unencrypted_base and the associated
code.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/kernel/cpu/mshyperv.c |  7 +------
 include/linux/swiotlb.h        |  2 --
 kernel/dma/swiotlb.c           | 45 +-----------------------------------------
 3 files changed, 2 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index b080795..c87e411 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -18,7 +18,6 @@
 #include <linux/kexec.h>
 #include <linux/i8253.h>
 #include <linux/random.h>
-#include <linux/swiotlb.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 #include <asm/hyperv-tlfs.h>
@@ -332,12 +331,8 @@ static void __init ms_hyperv_init_platform(void)
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
 
-		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP) {
+		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP)
 			static_branch_enable(&isolation_type_snp);
-#ifdef CONFIG_SWIOTLB
-			swiotlb_unencrypted_base = ms_hyperv.shared_gpa_boundary;
-#endif
-		}
 	}
 
 	if (hv_max_functions_eax >= HYPERV_CPUID_NESTED_FEATURES) {
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 35bc4e2..13d7075 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -185,6 +185,4 @@ static inline bool is_swiotlb_for_alloc(struct device *dev)
 }
 #endif /* CONFIG_DMA_RESTRICTED_POOL */
 
-extern phys_addr_t swiotlb_unencrypted_base;
-
 #endif /* __LINUX_SWIOTLB_H */
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index a34c38b..d3d6be0 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -73,8 +73,6 @@ struct io_tlb_slot {
 
 struct io_tlb_mem io_tlb_default_mem;
 
-phys_addr_t swiotlb_unencrypted_base;
-
 static unsigned long default_nslabs = IO_TLB_DEFAULT_SIZE >> IO_TLB_SHIFT;
 static unsigned long default_nareas;
 
@@ -210,34 +208,6 @@ static inline unsigned long nr_slots(u64 val)
 }
 
 /*
- * Remap swioltb memory in the unencrypted physical address space
- * when swiotlb_unencrypted_base is set. (e.g. for Hyper-V AMD SEV-SNP
- * Isolation VMs).
- */
-#ifdef CONFIG_HAS_IOMEM
-static void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
-{
-	void *vaddr = NULL;
-
-	if (swiotlb_unencrypted_base) {
-		phys_addr_t paddr = mem->start + swiotlb_unencrypted_base;
-
-		vaddr = memremap(paddr, bytes, MEMREMAP_WB);
-		if (!vaddr)
-			pr_err("Failed to map the unencrypted memory %pa size %lx.\n",
-			       &paddr, bytes);
-	}
-
-	return vaddr;
-}
-#else
-static void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
-{
-	return NULL;
-}
-#endif
-
-/*
  * Early SWIOTLB allocation may be too early to allow an architecture to
  * perform the desired operations.  This function allows the architecture to
  * call SWIOTLB when the operations are possible.  It needs to be called
@@ -246,18 +216,12 @@ static void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
 void __init swiotlb_update_mem_attributes(void)
 {
 	struct io_tlb_mem *mem = &io_tlb_default_mem;
-	void *vaddr;
 	unsigned long bytes;
 
 	if (!mem->nslabs || mem->late_alloc)
 		return;
-	vaddr = phys_to_virt(mem->start);
 	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
-	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
-
-	mem->vaddr = swiotlb_mem_remap(mem, bytes);
-	if (!mem->vaddr)
-		mem->vaddr = vaddr;
+	set_memory_decrypted((unsigned long)mem->vaddr, bytes >> PAGE_SHIFT);
 }
 
 static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
@@ -288,13 +252,6 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 		mem->slots[i].alloc_size = 0;
 	}
 
-	/*
-	 * If swiotlb_unencrypted_base is set, the bounce buffer memory will
-	 * be remapped and cleared in swiotlb_update_mem_attributes.
-	 */
-	if (swiotlb_unencrypted_base)
-		return;
-
 	memset(vaddr, 0, bytes);
 	mem->vaddr = vaddr;
 	return;
-- 
1.8.3.1

