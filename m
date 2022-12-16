Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CAD64F1B0
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 20:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiLPTX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 14:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiLPTXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 14:23:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D15362EA0;
        Fri, 16 Dec 2022 11:23:08 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGGhqFV016779;
        Fri, 16 Dec 2022 19:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=fqfuI9Y1PttJjv9P0CdcE+6lRxT6YooJVPCfqEhdEHc=;
 b=3QLaxNJ/LImQgQH/3oJFbT5s0CQOojVuaNuD0EuNxDifHkAwnkuFVcOTDjuEVtKlVQSR
 2jdG0DGoXTICVpBr7WHqLbEIbpSmEr87GSaEbDbF2dhbmLAVakeTa5y2DYTVdbU2F9v5
 MvaXeuG4qcJFu0AzgZ81orRpzQQPRzdqFkT/Pl6OLTnUQLIRAsM6oac/mWeNWp3/38+I
 d32TRRSU0k9IZWNUXEQzsVIijemz9+hqKjbn5ca9hkcpYCM5wdBUooIVhrfp7IaB+LsE
 /fjuvKlLQZQL5NvDSrlX8UG6TtIeEVKA3vVhTWTkfbontWUq6P8Jik92URmpIlWKpgsG 6w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewg70q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 19:20:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BGHP2Qs027848;
        Fri, 16 Dec 2022 19:20:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyf0s2gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 19:20:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFX1xzX+CopG/LVJLmlBtGBhJ06kBXSohJnGLA24aW0Zxt/4UCvsH+ZPR7t1fRQqI8m/miuKFlrKiUyULxeUM8AuumnUtGmJDHmmj+86SIc2t3VuIZ49jAQh7N5/tOXNLsLtgHl2YsMmht31/KQWF46RamwKqzNvLWDge+rIO26Q/NZA1vtDu61G3FPyIic1F+2PX+sysfGoqstuZ25Qnq9mZV59MAkJQ4ksYQHztqrp6ngoK8pD9ZLyCB4UQmHgi+FoMDyJbRfFlwHPmVVEYsQt+utu28eL3HHwBT6bNOFmpB16/YtWreOXn/6qDJb8NqxcKCs2romGb2W+GXuNHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqfuI9Y1PttJjv9P0CdcE+6lRxT6YooJVPCfqEhdEHc=;
 b=FP4BYUBuh7dubVgex7FUhx0jazEsELetsjOpHvZnSeApuuV58M0WAm+Gg1Npwepx25xum5pfIyijlnMGJrUz6h2Ux9G/eR37MLpCaPYuUH7SOxqdiGDbc7O7TA3X0OpEn32d/cG0yzYNbdPOLdIk/EhBoGRGWbzS7I73UdWHLLl6bCGtqkF7SZxYPNKuR5JdR+3J40KneTj+n+rPTa256e+d8rp80zLzU3ETnec28ZBOn/ocFbfER4c9f47hCgtLTx3p4C7hqoXXRFAjxpXAeSLhGNRE0Z6SVvS4Ao+kqPql30X0eztVway1mkc56qeLBPmvEF9ayHfLtjLnDLjYrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqfuI9Y1PttJjv9P0CdcE+6lRxT6YooJVPCfqEhdEHc=;
 b=ve8YteRF2mNFa56Hym3n0liLWI1M7g0qvKr8imLeN3khrL5hEqYq46ZprLdzvWiSuhvsKShX5pRtdKCBn8GN/WfKQ1CsrWmklczPYLL1HMhJVLHMcWT2AfzMpVBCajlEUFlhOiXCXdQYGcwEklcEsLftF0BL9LnEA7UVBvNNCtM=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SN7PR10MB7045.namprd10.prod.outlook.com (2603:10b6:806:342::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Fri, 16 Dec
 2022 19:20:22 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%5]) with mapi id 15.20.5924.012; Fri, 16 Dec 2022
 19:20:22 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christian Brauner <brauner@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: [RFC PATCH] mm: remove zap_page_range and change callers to use zap_vma_page_range
Date:   Fri, 16 Dec 2022 11:20:12 -0800
Message-Id: <20221216192012.13562-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:303:8e::14) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SN7PR10MB7045:EE_
X-MS-Office365-Filtering-Correlation-Id: 41a5acc0-af59-48b8-618e-08dadf9a935b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZdEEdxoalgCFYBqEpBrDd9dnoCSMO0WVA5y2YovjjvmT7u652dFAXejk6ngFfpx/Cd/TYgsDX47KTLRp5Dn3bdu8TZ9Og1GH1yMHeD+Qi74lFL/ooJt+dyQT3N8fto1Ikpqx0TtX8Eh/XLtRWJUkjj+e0CO9l8OA0vbdM7das6CU9h3anuHWlsWbEq9D0xlpxUC/ERMHwYcJLBDdxCFae1/bc/f7E0HkjsXksVgz6bLKO6r3OSKQ2htFVQN+OTxlpRkJX7wn3k1YX5OIZ/EGuAX2p6SMgKcHKSagKF9/PY+/F8vxGc2wIq+zw2phlz38Aim7ts35Xn2UlpMYgDRzSDQvZD/fLormgVE1HPak+rMFl8UCBHkLVqgealWfby7M3odaS2Vj0mrIOANE7e1F2BBhWpiXO1ewDnWXvS7V5R17LwE1k+/uXERK+TyiQjOoTk7l8U5UkjP26sQBWLmFxUhvBwUO210mAoEbJ7qUlI72rXeb8xV8xIuh07E2gs1A2pE0VOKHbRcP5N2oCd71IPiAcETWqkICi6Wqp1/7DQl6FKsGIK8ZAgep0OBO8SEimR4zMhRG3V78ep0wmEKJYGi/Oip3XsfucJB+NCf2Z5A8J/BYu/rqYJCEP4WT78qdiqw0lqrPgu3hlpNGZi1p1dnr3Zgnz7cP4pSqYSXVEuA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199015)(66946007)(66556008)(8676002)(4326008)(66476007)(5660300002)(7416002)(2906002)(316002)(41300700001)(8936002)(186003)(26005)(54906003)(966005)(6506007)(6512007)(6486002)(478600001)(107886003)(6666004)(86362001)(83380400001)(2616005)(1076003)(44832011)(38100700002)(30864003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UvzWSVuInhGUZqipu92v3eBeHxXg3FeR4wpmCxKFPRR1s/49lYf9zXo1dYTt?=
 =?us-ascii?Q?TsEWsXPP4WbhGNFZxCokAarCk6gE+mCTibr9ls0Il+GGN03al645+iNPqwBF?=
 =?us-ascii?Q?nw0x5xWaaiCG6lYHOSqvpKG2RkspJqkOyZlMDHU4XlRtOZg9TQ+ub6biKXfd?=
 =?us-ascii?Q?3RP3FVBEH6Hy67ixkP/N1ney1H10BMlSnQ1KF5m1DIFOIdgRhPSkYZ5YdtDP?=
 =?us-ascii?Q?ueKRhPLROTMfXyt/ih++bI+aoatTsxe5groMhECxSDKkLiOR4STPzT/9GWhb?=
 =?us-ascii?Q?JCAlMauSbH8tJWRcXrEhTj3iviSt4GCUBGjZ4T+XSsqOBDt8IaSuwND4oJSe?=
 =?us-ascii?Q?JIMkQdyGxtaOPEfDoxMtl+bWdMUDvmdfniHM5J8+4JQ74r6qX7rQzbF/BNnp?=
 =?us-ascii?Q?oTouszgsg3/kHBds7G8c/FYljuujM1gF1X2xkleqn++SiXPtvrhTKGxa9MLc?=
 =?us-ascii?Q?TdHvOZvS4++ETQSHX4QcsfGHdJw5Ak4zn3r0LVW6Ma4TkQrVccrAbl+Y2+2R?=
 =?us-ascii?Q?iLszFicD9hw0rYq4dTKrt5eTyva3CBhRr8H1KVrHxoTBnEcwNcd4aiHkdXE+?=
 =?us-ascii?Q?oVIt8rSAoq0k60Et51RzjDeit76WoK0uXZe/jvEekcTh/tQTtSTXzZpWmqwo?=
 =?us-ascii?Q?kLSTBnrrS9hfFNe9iZm31IswFY7vZnG9aihw8EPjn4M1yJRK6M2pXxKZyvWk?=
 =?us-ascii?Q?cJMWz2p2hR3XhmudRGtm91tjWkP08pZo5JqghL0/bBx968Vd5dVsqcQFaPrW?=
 =?us-ascii?Q?ozwBxvtWkywz6yDnwrTB0bErakemKi7ulXEjzHDCsvE+vU8zzzYSyP0Gl0g4?=
 =?us-ascii?Q?G4Ziz8qXwa/1KFOOHex8UapvyWDN+BteaNMHT/GgucAlLtdjM5B4moI7bUZL?=
 =?us-ascii?Q?jbGhZiIg2H8U5TTjKLbZ7wcPLTToM/YTswjr3FGlmHM8HP6+bIoeaOddGOu4?=
 =?us-ascii?Q?VETgvVMFyEVa92a9DxfuJpa7nYqXxI8lD7tLs+Os7Y6bDbdjBx8CX+v1Gt3V?=
 =?us-ascii?Q?EtoZ6VDI0HoY+K9XXeStkvD6B/RCVOGv5i8PWZQ+sZdt0eevfHS1WDT4VJ32?=
 =?us-ascii?Q?zfen1oNtLe/bkNw4OZxqHc4mZrHl0zmDaah+Fpt0ze1fuZLjy5uJGLyy7KSd?=
 =?us-ascii?Q?IhmaL5cwmt3TpvwK0MAa3qo1B/A3j7og7mW5CpwQUZoF47zyBC50dNrC6ics?=
 =?us-ascii?Q?G8clbLWdm1DrU8IquvkyJE/Lign2dP4dsK0uc07qDCC548DjPj1sX/ItCdyd?=
 =?us-ascii?Q?nxzSTuqjHqa64OZ2eUHhoZT1nyJoOpQMmJpTwvYvgdX7+zf3JvOQnMBK9XOM?=
 =?us-ascii?Q?nB1pv+jjxv26TnIM5Z5PLBfva10YfhLDwvgTJ0WNY1KIjwlmgSb5gTEBb92C?=
 =?us-ascii?Q?q2youTtAYmCrwg1SSLMwpY6bGVA6VrCR0RMb9ySdMJOF/904anrM8Lh70S+K?=
 =?us-ascii?Q?dQ10ZBzxndxq2SQV5+uHks21XJ3DlcgDVGZ0fnEy1BVrrUHnxx7b8wVBvgLl?=
 =?us-ascii?Q?d/GGutUED22A8nfvOqL3KKFv90mx9R9jo1JJQFdZEPkJIkJX7l+fs0m4OoXH?=
 =?us-ascii?Q?HOxVVZLYD2mFYBxI1Cli+m9f1Mp5YVFTTtAh43dEkriPH2hMg8YbBaKuHhvM?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a5acc0-af59-48b8-618e-08dadf9a935b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 19:20:22.0272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ub1BA6Blu+LD0KuVVg7YnaG5sFUz90tfKHrxkGjAj8kVINelD+pgtIrPM0xGlnBE8/kDgFpeb0WgRa61nX53og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7045
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-16_12,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212160169
X-Proofpoint-GUID: um6Dv7ZqfTjk_n1EhNED4LQTp4Gj47Hn
X-Proofpoint-ORIG-GUID: um6Dv7ZqfTjk_n1EhNED4LQTp4Gj47Hn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zap_page_range was originally designed to unmap pages within an address
range that could span multiple vmas.  While working on [1], it was
discovered that all callers of zap_page_range pass a range entirely within
a single vma.  In addition, the mmu notification call within zap_page
range does not correctly handle ranges that span multiple vmas as calls
should be vma specific.

Instead of fixing zap_page_range, change all callers to use the new
routine zap_vma_page_range.  zap_vma_page_range is just a wrapper around
zap_page_range_single passing in NULL zap details.  The name is also
more in line with other exported routines that operate within a vma.
We can then remove zap_page_range.

Also, change madvise_dontneed_single_vma to use this new routine.

[1] https://lore.kernel.org/linux-mm/20221114235507.294320-2-mike.kravetz@oracle.com/
Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 arch/arm64/kernel/vdso.c                |  4 ++--
 arch/powerpc/kernel/vdso.c              |  2 +-
 arch/powerpc/platforms/book3s/vas-api.c |  2 +-
 arch/powerpc/platforms/pseries/vas.c    |  2 +-
 arch/riscv/kernel/vdso.c                |  4 ++--
 arch/s390/kernel/vdso.c                 |  2 +-
 arch/s390/mm/gmap.c                     |  2 +-
 arch/x86/entry/vdso/vma.c               |  2 +-
 drivers/android/binder_alloc.c          |  2 +-
 include/linux/mm.h                      |  7 ++++--
 mm/madvise.c                            |  4 ++--
 mm/memory.c                             | 30 -------------------------
 mm/page-writeback.c                     |  2 +-
 net/ipv4/tcp.c                          |  6 ++---
 14 files changed, 22 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index e59a32aa0c49..a7b10e182f78 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -141,10 +141,10 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 		unsigned long size = vma->vm_end - vma->vm_start;
 
 		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA64].dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_page_range(vma, vma->vm_start, size);
 #ifdef CONFIG_COMPAT_VDSO
 		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA32].dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_page_range(vma, vma->vm_start, size);
 #endif
 	}
 
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 507f8228f983..479d70fe8c55 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -123,7 +123,7 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 		unsigned long size = vma->vm_end - vma->vm_start;
 
 		if (vma_is_special_mapping(vma, &vvar_spec))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_page_range(vma, vma->vm_start, size);
 	}
 	mmap_read_unlock(mm);
 
diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
index eb5bed333750..8f57388b760b 100644
--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -414,7 +414,7 @@ static vm_fault_t vas_mmap_fault(struct vm_fault *vmf)
 	/*
 	 * When the LPAR lost credits due to core removal or during
 	 * migration, invalidate the existing mapping for the current
-	 * paste addresses and set windows in-active (zap_page_range in
+	 * paste addresses and set windows in-active (zap_vma_page_range in
 	 * reconfig_close_windows()).
 	 * New mapping will be done later after migration or new credits
 	 * available. So continue to receive faults if the user space
diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index 4ad6e510d405..2aef8d9295a2 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -760,7 +760,7 @@ static int reconfig_close_windows(struct vas_caps *vcap, int excess_creds,
 		 * is done before the original mmap() and after the ioctl.
 		 */
 		if (vma)
-			zap_page_range(vma, vma->vm_start,
+			zap_vma_page_range(vma, vma->vm_start,
 					vma->vm_end - vma->vm_start);
 
 		mmap_write_unlock(task_ref->mm);
diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
index e410275918ac..a405119da2c0 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -127,10 +127,10 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 		unsigned long size = vma->vm_end - vma->vm_start;
 
 		if (vma_is_special_mapping(vma, vdso_info.dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_page_range(vma, vma->vm_start, size);
 #ifdef CONFIG_COMPAT
 		if (vma_is_special_mapping(vma, compat_vdso_info.dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_page_range(vma, vma->vm_start, size);
 #endif
 	}
 
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index ff7bf4432229..eccfcd505403 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -63,7 +63,7 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 
 		if (!vma_is_special_mapping(vma, &vvar_mapping))
 			continue;
-		zap_page_range(vma, vma->vm_start, size);
+		zap_vma_page_range(vma, vma->vm_start, size);
 		break;
 	}
 	mmap_read_unlock(mm);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 74e1d873dce0..67d998152142 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -722,7 +722,7 @@ void gmap_discard(struct gmap *gmap, unsigned long from, unsigned long to)
 		if (is_vm_hugetlb_page(vma))
 			continue;
 		size = min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
-		zap_page_range(vma, vmaddr, size);
+		zap_vma_page_range(vma, vmaddr, size);
 	}
 	mmap_read_unlock(gmap->mm);
 }
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index b8f3f9b9e53c..5aafbd19e869 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -116,7 +116,7 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 		unsigned long size = vma->vm_end - vma->vm_start;
 
 		if (vma_is_special_mapping(vma, &vvar_mapping))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_page_range(vma, vma->vm_start, size);
 	}
 	mmap_read_unlock(mm);
 
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 4ad42b0f75cd..f7f10248c742 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1019,7 +1019,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 	if (vma) {
 		trace_binder_unmap_user_start(alloc, index);
 
-		zap_page_range(vma, page_addr, PAGE_SIZE);
+		zap_vma_page_range(vma, page_addr, PAGE_SIZE);
 
 		trace_binder_unmap_user_end(alloc, index);
 	}
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6b28eb9c6ea2..706efaf95783 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1980,10 +1980,13 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
-void zap_page_range(struct vm_area_struct *vma, unsigned long address,
-		    unsigned long size);
 void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 			   unsigned long size, struct zap_details *details);
+static inline void zap_vma_page_range(struct vm_area_struct *vma,
+				 unsigned long address, unsigned long size)
+{
+	zap_page_range_single(vma, address, size, NULL);
+}
 void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 		struct vm_area_struct *start_vma, unsigned long start,
 		unsigned long end);
diff --git a/mm/madvise.c b/mm/madvise.c
index 87703a19bbef..3c4d9829d4e1 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -787,7 +787,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
  * data it wants to keep.  Be sure to free swap resources too.  The
- * zap_page_range_single call sets things up for shrink_active_list to actually
+ * zap_vma_page_range call sets things up for shrink_active_list to actually
  * free these pages later if no one else has touched them in the meantime,
  * although we could add these pages to a global reuse list for
  * shrink_active_list to pick up before reclaiming other pages.
@@ -805,7 +805,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range_single(vma, start, end - start, NULL);
+	zap_vma_page_range(vma, start, end - start);
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 5b2c137dfb2a..e953a0108278 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1687,36 +1687,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 	mmu_notifier_invalidate_range_end(&range);
 }
 
-/**
- * zap_page_range - remove user pages in a given range
- * @vma: vm_area_struct holding the applicable pages
- * @start: starting address of pages to zap
- * @size: number of bytes to zap
- *
- * Caller must protect the VMA list
- */
-void zap_page_range(struct vm_area_struct *vma, unsigned long start,
-		unsigned long size)
-{
-	struct maple_tree *mt = &vma->vm_mm->mm_mt;
-	unsigned long end = start + size;
-	struct mmu_notifier_range range;
-	struct mmu_gather tlb;
-	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
-
-	lru_add_drain();
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				start, start + size);
-	tlb_gather_mmu(&tlb, vma->vm_mm);
-	update_hiwater_rss(vma->vm_mm);
-	mmu_notifier_invalidate_range_start(&range);
-	do {
-		unmap_single_vma(&tlb, vma, start, range.end, NULL);
-	} while ((vma = mas_find(&mas, end - 1)) != NULL);
-	mmu_notifier_invalidate_range_end(&range);
-	tlb_finish_mmu(&tlb);
-}
-
 /**
  * zap_page_range_single - remove user pages in a given range
  * @vma: vm_area_struct holding the applicable pages
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ad608ef2a243..bd9fe6ff6557 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2713,7 +2713,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
  *
  * The caller must hold lock_page_memcg().  Most callers have the folio
  * locked.  A few have the folio blocked from truncation through other
- * means (eg zap_page_range() has it mapped and is holding the page table
+ * means (eg zap_vma_page_range() has it mapped and is holding the page table
  * lock).  This can also be called from mark_buffer_dirty(), which I
  * cannot prove is always protected against truncate.
  */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c567d5e8053e..afaad3cfed00 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2092,7 +2092,7 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 		maybe_zap_len = total_bytes_to_map -  /* All bytes to map */
 				*length + /* Mapped or pending */
 				(pages_remaining * PAGE_SIZE); /* Failed map. */
-		zap_page_range(vma, *address, maybe_zap_len);
+		zap_vma_page_range(vma, *address, maybe_zap_len);
 		err = 0;
 	}
 
@@ -2100,7 +2100,7 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 		unsigned long leftover_pages = pages_remaining;
 		int bytes_mapped;
 
-		/* We called zap_page_range, try to reinsert. */
+		/* We called zap_vma_page_range, try to reinsert. */
 		err = vm_insert_pages(vma, *address,
 				      pending_pages,
 				      &pages_remaining);
@@ -2234,7 +2234,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	total_bytes_to_map = avail_len & ~(PAGE_SIZE - 1);
 	if (total_bytes_to_map) {
 		if (!(zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT))
-			zap_page_range(vma, address, total_bytes_to_map);
+			zap_vma_page_range(vma, address, total_bytes_to_map);
 		zc->length = total_bytes_to_map;
 		zc->recv_skip_hint = 0;
 	} else {
-- 
2.38.1

