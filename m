Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C78560677B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJTR6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiJTR6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:58:43 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022019.outbound.protection.outlook.com [40.93.200.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A42A199F58;
        Thu, 20 Oct 2022 10:58:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODiWjPYpXxSwNH2jjBGvME8rMJrqocIvhpXYhHQvETXeYSDuOZ2QXHX7Ea7yHZKmSTyrp+C3ltXrFD4ic+0nUPfyPUGzFonQOWnC/bOJM5udhQ6YDdSp7yfuRABOwBC4f5ib3rq+WVQgCxyVTEtvAKoEIm0PUl6ZVOuG7OIkv9VWtghPnQ8IaGaM6X/R6Va0F4iA6igKPpKCipGo1JYNMnjGNWSeflCuRuh/kGwmeobohxB9g0S6hubTpEgV4SYmUIJVaIQpaEp8tfqbwC9hjvjZBPnA7jMkhJKVh86nAXUnyFKlpbWKMxx41pAc0p+SnhBrRBEAfMH56qD15xlH4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sel3qdBw1/pze8y63YrYV2DOyju1dhU548BTTT17Xjw=;
 b=dxOzsxTNaSd66FhZemfPsOvMamcdCXwzxT3RWLL2r9dWf03gJYWkuVeUHPPMF+ikiOGT/JWzqaF9QJCkmWQjLyCeU/ioZFd7rkrAIjjlCryh++7IL0yTQdXeXtXLy0BGQ0/H1cWJP/KRTBM1CUC63Se9pf4qZTufdx+mVOmJlgMZCS/JHqtWVnnBpErK9FdH0N/rKenTJabF/04239QZ+dXSaGjRlO0cZXN6BiAg7ANE79CoB5KJZ00ER6hRvQ9Am9hyW7nR8P5htSVUALvLKclzuQMOPaVi37t1zakO5IUH6oMrvhIUYrWxA/d0ZXK8WVFdhXBaZwZQHeZguwK5rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sel3qdBw1/pze8y63YrYV2DOyju1dhU548BTTT17Xjw=;
 b=J7HqNINvL7+bqaRWB3ksYTwxfxc0FvcdoCnqfp/u0sE1UWS6R3SyI2MQenaOqDjRPvrSyPqoa76quN/F/3jAqyrvKW9fb5QhD8BpUAyyqr4ULwGdUxIZTYfiejihgKErZ8Ojw7mrz7KXHcUvDm8kC+olJmmYOLTWu7Nf4RdIibY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:28 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:28 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lpieralisi@kernel.org, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: [PATCH 03/12] x86/hyperv: Reorder code in prep for subsequent patch
Date:   Thu, 20 Oct 2022 10:57:06 -0700
Message-Id: <1666288635-72591-4-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:303:16d::31) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f60293a-f598-40c7-9417-08dab2c4b0e9
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iiv5k2GBEmtRLjzhnVO+EE4VEuWd9LGe84JUBsn6zZP86m0e5T7z6RlzI7PqMO/VAKgHMZGKjRXb5BH0AbalyMOskO8JQG9R3JVL8ZqKNchGrAusi2LTyHSLkw4bwb9x7YN34KVXjEKbGXrT3+An5nCYaPRdw/bCusAyLisnpXDN4F3/2Zh/yLiGTe2mUcyfCEHEuInWur6uI0IpNrCfIo71XIyDV7KfV7nNjR9Z0joIK31kpELTRMF4boeSI8Rn7FKo/KAMBY6jWERS3ApOvzeAhh5VP4d2DfaiXvKMlCUo8SzQ0eDvDoGGK3o4nNtn469UpwAdMF9/Vpv3NeLutrEr+DrYewnH69QdBoWCukQ1h0M6gOW2Dpl8RcWZEyagsmkboqMwsuLI/dDT1yNphlhSIpT67RcnRBDGR9vCT4QRQkL0zbSdWXGMuxsj5a3ClORJWoQYw6FpqXmSXmLOcY1gzcFK5pFEPDLZJLNaR1+IoRclCMCWZelrXSAexFMbbo6+W21sGDdail7Xa3683CSCAttrCFIMNjd5F6wsgky3qvOcLcDW5OzBAIocj2bmWMQtML+WyuXr8+NZLXhB1GUPso7WqSzQMsIUaAqqP6axXGQVUmFA+kpDoF7owUkYXmcZ7US1SYCnmOOlXGJ8U/wwrLzkAmArgjbJGWZuD6ZkIeFq8bwZQiu8G1K6vxn1ll0t2D+60WlrjL6Tah4GnWnFt8j+1iPhJm8xuqbClMK0YAXLE699O2W6lfjKyWzOypGiHjS1+V+YMfIEpAUBHONn7FXODSfH9eeNiMsc45LOHzC0Gy4IwL0/Z4zyppGo3vCTJkBsS12GvgKoL4dyUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qSFTG6byjCYRwNja6FMW3kl9qpg164TVX8jVuUX3oBIPx2ADLZjeyBFAjn8r?=
 =?us-ascii?Q?nf7a/Z0rVLUudArRJ3OmXIYgb0e+3AGoiKt00DIk6oS19AFP9PKEhPBHcDYl?=
 =?us-ascii?Q?OpfeEhd/ssbEYFtSBbeHpeRmLtl3lKntnhgZqQB6MMry+i4YPR+z/t9z4XBL?=
 =?us-ascii?Q?LeaVuFzt8ANSwfgkeSUPtLoaHLQF8r+IE4fktPQ0n4lYCUaf7f5BlxrrqaKs?=
 =?us-ascii?Q?oMG0WJ2ngdpparJfpxZd6xllutFfInruRjUA0QP1TQFzBHRN/M1M/oKmP8U9?=
 =?us-ascii?Q?xrBQnpj9HqItaPcO9CTZ284R0kqLc/vp2wd2LknlOpYE1bM58NMVsS0rLjdn?=
 =?us-ascii?Q?kWq8Kj+AAkHLzFVdS48iFrf/wjscpQU4lD4ZKsKZXS5PMQicryzoxp2hDXPG?=
 =?us-ascii?Q?vsOX69QTl1s6aKlsSASbPKcMZX7hkz1/yksLn9A+ctT+8+p7LwV/mGuxRmwD?=
 =?us-ascii?Q?eRw3NypKdvjHFIpGUxKOhLrht6av2MRM70zyq2wsnENKsMNEm+tkBC+iaWog?=
 =?us-ascii?Q?znY+4x4vilqKeNVrZIFLQxV6gUpJybWljJKBbyqWZ+MJM1HinHu0vNjwUbWf?=
 =?us-ascii?Q?h9vEcFoLt92MWgSwiyqw8hEUt7dOEsFrEJh4uSRNQCotzIrqvydH2b0i5Pg+?=
 =?us-ascii?Q?1KH9rNFBa8FL5xacV6VwoDZInNbZOEQBjJUjZSOczitNfOlQgUdCLiKbm+Qr?=
 =?us-ascii?Q?aZTKgaszb12JV5Z3B8+NKUYAJ/61//PqZSPp8Rdbb4IaYHhthw6vnFo/UbHx?=
 =?us-ascii?Q?BgH2M+8923/CwyKdfGKIL7zUQoA0w+Zx/9emxh0E2KIRPwE7Q5XZMSP56tAP?=
 =?us-ascii?Q?I2AAbCwzkqnqHFZK2E63WmkbHaqE3GL+VWqF7oInuWNn4K40Co83SNxKLftD?=
 =?us-ascii?Q?0qjLdulHKeeWJAIR2Wq79NbtIJrJG46HpXIrpn8IEA0mhAAStrruUYBWBLat?=
 =?us-ascii?Q?i2HGX/DNcPJ0EnV7lHDOPl4LjoMct08GDSHyu4oHdXrB03XwkRbqLURdan2U?=
 =?us-ascii?Q?3j82o5Jr2CKlgiijZhgVB0ueJGQixtLjj4M9E6grBRrro0ce+A5idki/4Rw0?=
 =?us-ascii?Q?3VerRBLYWXCHSwDsHIFnsPrucJNOXTre7AlcfM5s/x5Z3VDyIzqzoEet/5RO?=
 =?us-ascii?Q?orLnnRgAdgXMpsacZYeSHMgaknb3s6PCA64++jIew8oa7IApFe642yMHI6xr?=
 =?us-ascii?Q?wGGCzoGbv1j47upL0NzaYb3Lsb+URhiLD7MYMTgZ0YiI3W3egKPa1axiD6uf?=
 =?us-ascii?Q?/FpYzonkfMzdQgI+F/v2J1JH7M+MZ6kfst5LzHXKgvo3y/g8rfm/VnhBfooy?=
 =?us-ascii?Q?GwYxF3+cnBSygd+ZXcwakRfBsff+y89zldq4l7Jg2V9CTWd3CKQTVuPOLqj4?=
 =?us-ascii?Q?OLYzUJxxnvgRp1ClVZHBcWmRq39zYZMvx+9zbmlQHCfNqQmEc2sRl/tJomxx?=
 =?us-ascii?Q?WEVh8vGV0I5Rr0W64t4ah1RQhXl2PhHARZOy1wlpb2lvh14IJfdVPmFaD9I1?=
 =?us-ascii?Q?X12mpdG4OYfU5AcsQjwiQiX+oibtcqthKISS6IEgmBJF8b793HodhmwE6p2m?=
 =?us-ascii?Q?yLe1CWbnjBrLo8M5VvDUSkovaa1/8o33aFvTewiV?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f60293a-f598-40c7-9417-08dab2c4b0e9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:28.0122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqpGP/2OtfcTq0ZYvcinz/6lCZRCIf30aUdzgXSsZLdyv/k5YG0qTSX7Uu3SnCgo5Ch6PLhE051M0e5L4DD+PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorder some code as preparation for a subsequent patch.  No
functional change.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/hyperv/ivm.c | 68 +++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 1dbcbd9..f33c67e 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -235,40 +235,6 @@ void hv_ghcb_msr_read(u64 msr, u64 *value)
 EXPORT_SYMBOL_GPL(hv_ghcb_msr_read);
 #endif
 
-enum hv_isolation_type hv_get_isolation_type(void)
-{
-	if (!(ms_hyperv.priv_high & HV_ISOLATION))
-		return HV_ISOLATION_TYPE_NONE;
-	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
-}
-EXPORT_SYMBOL_GPL(hv_get_isolation_type);
-
-/*
- * hv_is_isolation_supported - Check system runs in the Hyper-V
- * isolation VM.
- */
-bool hv_is_isolation_supported(void)
-{
-	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
-		return false;
-
-	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
-		return false;
-
-	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
-}
-
-DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
-
-/*
- * hv_isolation_type_snp - Check system runs in the AMD SEV-SNP based
- * isolation VM.
- */
-bool hv_isolation_type_snp(void)
-{
-	return static_branch_unlikely(&isolation_type_snp);
-}
-
 /*
  * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
  *
@@ -387,3 +353,37 @@ void hv_unmap_memory(void *addr)
 {
 	vunmap(addr);
 }
+
+enum hv_isolation_type hv_get_isolation_type(void)
+{
+	if (!(ms_hyperv.priv_high & HV_ISOLATION))
+		return HV_ISOLATION_TYPE_NONE;
+	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
+}
+EXPORT_SYMBOL_GPL(hv_get_isolation_type);
+
+/*
+ * hv_is_isolation_supported - Check system runs in the Hyper-V
+ * isolation VM.
+ */
+bool hv_is_isolation_supported(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return false;
+
+	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
+		return false;
+
+	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
+}
+
+DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
+
+/*
+ * hv_isolation_type_snp - Check system runs in the AMD SEV-SNP based
+ * isolation VM.
+ */
+bool hv_isolation_type_snp(void)
+{
+	return static_branch_unlikely(&isolation_type_snp);
+}
-- 
1.8.3.1

