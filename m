Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360193DA91B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhG2Qau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:30:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22386 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229750AbhG2Qas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:30:48 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TG75eU022227;
        Thu, 29 Jul 2021 16:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=ZPLuosigDK6fhIIei+XFf9vUybkegP3dYIBQy4dJ4Kw=;
 b=VGDNVjiBMd+3TUwwBCxMvk7UeM0VsL/aevkY3oPeaNK6HZjJ5ZQAg996/D5xi7wtYYst
 WL66wXSugvEKaU95o5nvlZ1G76VqLq3vDPP8mHz/O3OdeHhP8bne4ohYcBqFjw+JAw3z
 xoHekTAr3EMl4D1W61ikIPYN9V1R1qbd7sRFy1MmlTdyEc8+rctOzgbDkzmSZ2y8ecQv
 gyoKojUzyw0nHiNHlOp5lxOH0l/cqh+it5Bx22i2ApoJemJKvBhpgUHxA5oS8txfQXRW
 wX0GNPbFUECFVHcblffYqpxBnR8TBwHYyc2kiCi4DBu/CqqG+N0et3OsromXmfr0HE3k Kw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=ZPLuosigDK6fhIIei+XFf9vUybkegP3dYIBQy4dJ4Kw=;
 b=xag2rAPCvFDQtPGQDVDvaM2D00PK51fgX3p/9g+7soju7dhThOoxo4BF3BEW2R6I9+Yc
 xQCdsPiLW7pUDS951N73PAWM9sXFbdQCoKd5NXeexUcKaaYIYiK+4ww3Tf83Y6g1qRR0
 SP28hSe2JdJia8QBIue36xXwxogSunEi7LPTja+pATvbC2GyFCic6qw6IjZtZnZx2jUx
 AkOGQo1B7qRdpejWLuvO34Gh/4Et2VjrevNvRjT1QRFXnSAXMXXP8Ytu544BkFy15v9O
 aUTlWUpsFGszDr32LzVPWQQMeB9VifU6RLaRv8onxS+LIyu9tYHo6xXR60zJC68FWR3z 3A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3cdptctc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 16:29:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16TGFKUf152569;
        Thu, 29 Jul 2021 16:29:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3020.oracle.com with ESMTP id 3a23517rts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 16:29:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0ej2/STHCa2tlcVCHNOzKSUedG4WWqadtNcRArJ10xg8scxr3hMvw66D+OtXHPRFlhWHWOEUBWVRV48q7zepCPu8RACnPxNCGfVT7FmMyze0ydLNGVRWqO2BS06QcGkme6VbdRcvfd5A8jzj4aQdogChi1NhnMams6BrI+wKxbuxeUY+33Q7+CECcpCvA1vTIKuYXe263iIjGYcNdeV16kKvHJYVBJG9LNC8rChmIRHUsyreXgisuExnCLqOq7Bu2I+ohIWhq2xbDqwzbay5ejYi+8q81SfMG3S+pdLHeUB0wChA2dfSCd/cAXN44wKlIM7aBulWzA3tVVxXAOmLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPLuosigDK6fhIIei+XFf9vUybkegP3dYIBQy4dJ4Kw=;
 b=BOp77tJPRjSA4+YW2rEiDU004lbMf39t2BCE9kt6o7XM9SocSLJTjLUg5OpkYNfFRgxoFRQYVxdahtimjCDQtjpBzo0XHKgVEDdnHE/8vEp1ghaMFMWGwPH20zk/9CkJ068BngRSx8clg9/g9c5nBKpxDx8kOE+hWO+qnF9LQSmKDAOIof/nbwx0guYYI0JbcRDhlt4LfD+Ujv3V04FocfQLiHlfy/J/Dy2tCpKifF9qQjzIOd4kztzxiYocQaAMVOpXbjhuk96pndARzdr4bAoxNmlg/wT8KoMO75T8mza1C9zqSdJQVbDZ+Z9xKkeWIBDcOk9b3bYz2T2o1qUH1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPLuosigDK6fhIIei+XFf9vUybkegP3dYIBQy4dJ4Kw=;
 b=cGJW5GjLtta6ujZJ7PTnBuLeJ3/uX0+AmzpwM+oFXKxbQRVtOfTudYL8fGuUpbtBUIly4tbctSy5jvha2h1UBwZDGCwsA06mvD7jXheBnhFxOV9imbylhts6qIPSvDul8s/ZRne9YMKNyPLDS7HuorrGs7alVh8GjBh9nEs7IJQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by BY5PR10MB4114.namprd10.prod.outlook.com (2603:10b6:a03:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 29 Jul
 2021 16:29:29 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::cdbb:4673:98bd:7f2c]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::cdbb:4673:98bd:7f2c%5]) with mapi id 15.20.4352.031; Thu, 29 Jul 2021
 16:29:29 +0000
Date:   Thu, 29 Jul 2021 12:29:21 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, anparri@microsoft.com
Subject: Re: [PATCH 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap
 function for HV IVM
Message-ID: <YQLXYVaWWdBfF7Sm@fedora>
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-11-ltykernel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728145232.285861-11-ltykernel@gmail.com>
X-ClientProxiedBy: MN2PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:208:23d::21) To BYAPR10MB2999.namprd10.prod.outlook.com
 (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fedora (130.44.160.152) by MN2PR06CA0016.namprd06.prod.outlook.com (2603:10b6:208:23d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Thu, 29 Jul 2021 16:29:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 792afe9f-db99-474a-9703-08d952ae0986
X-MS-TrafficTypeDiagnostic: BY5PR10MB4114:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4114163EAC2BD7916940488689EB9@BY5PR10MB4114.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfZZFDZhdcvvzvE802Hs5K2Nzb1is5/8cXMdubZdWV5Kiz687C9hoY9z0FXGNj9Jt3QJOdjmrscwfsk9sMiP2gOTpk/yC5yzbRYgjXC5p9hjm9glEswb7Es4wwGZWpy3sTMMcaCNDwVbY2GLSG7ftuDBs8EDAZgejIr/99WnJnm1mSRYhq6amf2i+Cb/55ozmaNVpMDsKo7OBuG542BNe2jBrfipkAq+Iu5fTDD1BQ7B0dzYwQ3rBFZLa6zQIycf9cNi4HZ+hNlqmJDfCWwGzYAddGJ6eIS1JbfdtSDQpP4W3j37gtbrQOc8iZAPMNGGgnuTZziwhakJ1LKUwbi+m60PDd4jcYJCXJbSG3EerQulUezuihjjCUxRVI5Jta/R0y9eGyNUr/MKzWbpMcrGrX4NpIg8VP8WGr1ayIFqQMLDpxSOb0a8M2RwbEzwBc+TIR9W5Gqa8Fp0LWiC2qC3a6WElFYCovqTNxJtT8eELS9+2g9flCWACeGNGrSIwokFzKIXebU01eopZ4UfUbnKvBuOIM7ds7sRJ4cgffsls6H2IfZFwj2AyVm+EbqAOKmSF54WRCYvZuETgIxPm6rcagugODoQv1eysCTU/daarOZs9e7j7vTKcT3XeaPUxEghcrY3f6S4yabX56Icvec9uPifKdwNFGADhWBp5kChPkfTfRZ+h9bXQMtKg9D77p8zUDxiRTP/iclvrKiGbjbvGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7366002)(7406005)(33716001)(66476007)(7416002)(66556008)(66946007)(45080400002)(38100700002)(38350700002)(8936002)(956004)(9686003)(2906002)(508600001)(26005)(4326008)(83380400001)(5660300002)(52116002)(6496006)(55016002)(9576002)(8676002)(86362001)(186003)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l/39Mu3DFmDjSn/Li/PzEt9Tb0ZU1qb3cdof+uUbw8z3LrMdHVBUgL23HOq9?=
 =?us-ascii?Q?rRlaZla3NnCVse9mnjLa5cLv0GcAo1tvX/prQJeIwNh9jQQoNo5RZE0KKR6j?=
 =?us-ascii?Q?NMto1epWOGOBGX78R8lNIkWkOe02UqSPwQFKK7RDL5/r7pjum4tWzdPtn9Jb?=
 =?us-ascii?Q?WyA+QApdsnHSeSZ2oXtW1ro3B4ykOID90gejmBXbqoRqdBVJ12YFYSZVWVLD?=
 =?us-ascii?Q?zC/uDWIx/IdJxmBrJXIGjFLjELkjQLihgfLkwvX/BLELySsNyu1W0o2gTY7x?=
 =?us-ascii?Q?w2/1Ag2m0ATiWmU5n6lLYDAnQEMwsoFny1poC1pe/cgnmtzHNuWwnAmI5dya?=
 =?us-ascii?Q?jqVLPDftYFjOrnhXk7VbZObWFdRixbAQr8v/VOUXP2Ujv0U5rYS1+NYtlRCq?=
 =?us-ascii?Q?HrGGa265HnOAzuYNMDATGb4ArvZsG2ND7DKLwVKoUxphivcpp8dWt9cMi0aZ?=
 =?us-ascii?Q?BUiCMXf5NSUsf7sTgyx/YmUvQ0u9ymwwlk29eSKhD97u5N1hmlhhcQpTmmXA?=
 =?us-ascii?Q?KhhZ91XTNJBwYKpAez5LhTDQIIEAW9QxoxkRu1oKHOajLOvKvj+9mN2Ta2dk?=
 =?us-ascii?Q?JdJOvlhmhk8VDigu/aQUZptbe93t2rjp3gqquEjNCKqtEYpHA7Fs/6aSE7uD?=
 =?us-ascii?Q?gwo/rs4lMaiTlXwfCZIl111q6iJo+aklmBGie5Vh/ekA7e1SdnWryhcRpmBr?=
 =?us-ascii?Q?h3nnRvOr0Dr+A6tbE1DqsNE1995uPSV3eEaiUWx2Ks0nNNWAAYRmR4hU2CyB?=
 =?us-ascii?Q?SnaAED2yhtC5toU1EUMw3qwqe7uIO0NsWm9HhGvYlPU2RJ/XeqfzuxmLQVbW?=
 =?us-ascii?Q?tPbqHYZ1P8AyFXYU/ozTPerRMG9w0RytWCDj7gNN8LknhHdQXh8bmgNlDy+e?=
 =?us-ascii?Q?0hn+dqAQ8DNGc8Yn8Q+6gT2lGQaiy3G9tIV7jXhu2SiTKVpwPEwCv8hXYIeI?=
 =?us-ascii?Q?P+i8VYKzzogUwUe58ttWVa+EFtZvKysuHjFWvT4PoQ60SSI4Qm4aQ32mw1to?=
 =?us-ascii?Q?RoRkHTzqImt35jkYAjva/OBcARxaqwUgCsHmPrjrTaGMYfdhSEqeXQ7qMdqa?=
 =?us-ascii?Q?A/bju8JJ1OVG1N2GZPqmJJathSLpZSXkBA40cgC8d5Uj1NYxtySnl8qhiDAF?=
 =?us-ascii?Q?/tZip2TAgOUVOHBfMVLtV/1Q8x1w/m6QzroF+xwMEWjTSy8dx2o9ahN674AG?=
 =?us-ascii?Q?45E7jU4FZs87nXTrZYOcMx4tMi+6wCJAzv0+Ka+vLGw+Lw0jhbBPjCu8PyAk?=
 =?us-ascii?Q?TvHudErFPJsuuaB7xwNzFOZjU6nl1Vwxqg0nkDO2AR3KZCW+XJQdRFYWqfYa?=
 =?us-ascii?Q?NeAqH1ThC1M4X9SyMMrc9qCE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 792afe9f-db99-474a-9703-08d952ae0986
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 16:29:29.0556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10ewHPKAZyzNWcBruF9y8ComuX0r1d58QxET0IVOG28C6eyJvH2TGM5jCKcBHyScYfkXvynvDfOX+6WW3y8hvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4114
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290102
X-Proofpoint-GUID: NmXwd-VwEZxv4oelekdSlwjZ16z0aVH_
X-Proofpoint-ORIG-GUID: NmXwd-VwEZxv4oelekdSlwjZ16z0aVH_
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 10:52:25AM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
> extra address space which is above shared_gpa_boundary
> (E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.
> The access physical address will be original physical address +
> shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
> spec is called virtual top of memory(vTOM). Memory addresses below
> vTOM are automatically treated as private while memory above
> vTOM is treated as shared.
> 
> Use dma_map_decrypted() in the swiotlb code, store remap address returned
> and use the remap address to copy data from/to swiotlb bounce buffer.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  include/linux/swiotlb.h |  4 ++++
>  kernel/dma/swiotlb.c    | 11 ++++++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index f507e3eacbea..584560ecaa8e 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -72,6 +72,9 @@ extern enum swiotlb_force swiotlb_force;
>   * @end:	The end address of the swiotlb memory pool. Used to do a quick
>   *		range check to see if the memory was in fact allocated by this
>   *		API.
> + * @vaddr:	The vaddr of the swiotlb memory pool. The swiotlb
> + *		memory pool may be remapped in the memory encrypted case and store
> + *		virtual address for bounce buffer operation.
>   * @nslabs:	The number of IO TLB blocks (in groups of 64) between @start and
>   *		@end. For default swiotlb, this is command line adjustable via
>   *		setup_io_tlb_npages.
> @@ -89,6 +92,7 @@ extern enum swiotlb_force swiotlb_force;
>  struct io_tlb_mem {
>  	phys_addr_t start;
>  	phys_addr_t end;
> +	void *vaddr;
>  	unsigned long nslabs;
>  	unsigned long used;
>  	unsigned int index;
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 1fa81c096c1d..6866e5784b53 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -194,8 +194,13 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
>  		mem->slots[i].alloc_size = 0;
>  	}
>  
> -	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
> -	memset(vaddr, 0, bytes);
> +	mem->vaddr = dma_map_decrypted(vaddr, bytes);
> +	if (!mem->vaddr) {
> +		pr_err("Failed to decrypt memory.\n");

I am wondering if it would be worth returning an error code in this
function instead of just printing an error?

For this patch I think it is Ok, but perhaps going forward this would be
better done as I am thinking - is there some global guest->hyperv
reporting mechanism so that if this fails - it ends up being bubbled up
to the HyperV console-ish?

And ditto for other hypervisors?


> +		return;
> +	}
> +
> +	memset(mem->vaddr, 0, bytes);
>  }
>  
>  int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
> @@ -360,7 +365,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
>  	phys_addr_t orig_addr = mem->slots[index].orig_addr;
>  	size_t alloc_size = mem->slots[index].alloc_size;
>  	unsigned long pfn = PFN_DOWN(orig_addr);
> -	unsigned char *vaddr = phys_to_virt(tlb_addr);
> +	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
>  	unsigned int tlb_offset;
>  
>  	if (orig_addr == INVALID_PHYS_ADDR)
> -- 
> 2.25.1
> 
