Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87003611C9
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhDOSNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:13:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhDOSNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 14:13:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FI9GE1056163;
        Thu, 15 Apr 2021 18:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=p2GObtrUlSvmlD4cvGyWaQ1GoXj3hh+E0iLo1v27qvw=;
 b=Sf5IXEDyIC9A6w7p1T83/ws/djPo1QG3dP+DXgvHaA3dhXNOdBAuXjhvAqNUzsgfKABx
 bUrenpg406Tp2YbnGOKAMDSKQJn3aOfTtIKyluomjAQVI5WNTpS/psbvbCl23xrVxprn
 mLVUaiCRLNx6tQF2fZagquowFU/5kPWMHpds3LvvrZtXirSK13zdo8oNY3XoTHp+6W0t
 pP3J3ZOZ41JVYbCOsrGScGBxviktvkxMX3Jdf1L/Cd/SHtr7GRGCs+acRccB3Yv/R6mr
 JPGAbuPAre4UXcVKw7QHZd4NMmm0BAUAs8KMi3H60YHdqTAHElYOrydKr1eLtsyDNoB8 Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnpsf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 18:11:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FHxnWh189269;
        Thu, 15 Apr 2021 18:11:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 37unx3advy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 18:11:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJQf5M0VRBzhndM4OYdt9rBecsDsIaOpPo0PBT7rfG7C/utnxp0kAxW9WcQG6n4eWN0eLJV5nU6KRt8jXucQq7g5xOkeqvmWMMiBcb5+S4yCbM0t4Hzdod0Uw7YFPYrBEP47ZRaFKpFY7YnlN64eQuON3bTgqdzzkW061znHeSZxsLYlbDOPCKrkhH0C33RYoLKWMNRNitJOk1+FKyKmpgBzSa+HuD/Wg0462UDPeqFbUNXF0Gu+gSPOxsqO2erNPVzUt082R+7n5uqqEAgG4tmi5IoT1TKQrrye5orVpbO2dpq5d3kICjOZdXrfyiiSmd8G+qnbBola0kJpIovWTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2GObtrUlSvmlD4cvGyWaQ1GoXj3hh+E0iLo1v27qvw=;
 b=B3dy+kpbEj8nYsoXDcuNELlleRImvj2LpUZujyu0puhXwjfJ8YIDWhsVRkRI+2ey3N4hIjQAhKW3+SHq2r/aD7IJ4TfxxB6tPxqWIgNDhCQwqbNIqSkQ9q1+T1nw+jCULtkcZmVDB72fMUwzbg3bd4oL9wo5l7nI8zvo33YXN8Qw+/B9EW0DJX25CsyXpnHDikcfk3mjwASNprsTOj5f7wRUXOHibScztzfHzjkvBGd/BtpqGcKdmNwsg9GaQk7ORzklt1pywqxYRVuNRIE8QVjzZk8xqMWa6+ee8CPAByXBpI0oLXwtm+HotLMMH/cxVKE0r7WbiZ0XIyZp9Px/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2GObtrUlSvmlD4cvGyWaQ1GoXj3hh+E0iLo1v27qvw=;
 b=YirKHp/jSqjOXpYqwBobtl2ogpvMqn89pxeecL9g/bIQzlXg/0/BY5vvZUtdJlbV/h9B4HRN7VB5TddxvkMYLuLWZmttMAoHt26slsWSglBG0nxJQRsuxKpPyn141QAcclGzuy8nGdF+1KUqPecEnnI1pHusZDvFqmTHym6Zt3Q=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by BY5PR10MB4114.namprd10.prod.outlook.com (2603:10b6:a03:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 18:11:46 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::50f2:e203:1cc5:d4f7]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::50f2:e203:1cc5:d4f7%7]) with mapi id 15.20.4020.022; Thu, 15 Apr 2021
 18:11:46 +0000
Date:   Thu, 15 Apr 2021 14:11:34 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [Resend RFC PATCH V2 04/12]  HV: Add Write/Read MSR registers
 via ghcb
Message-ID: <YHiB1i2r7pdcZp/o@dhcp-10-154-102-149.vpn.oracle.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-5-ltykernel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414144945.3460554-5-ltykernel@gmail.com>
X-Originating-IP: [138.3.200.21]
X-ClientProxiedBy: SN7PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:806:121::29) To BYAPR10MB2999.namprd10.prod.outlook.com
 (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-154-102-149.vpn.oracle.com (138.3.200.21) by SN7PR04CA0084.namprd04.prod.outlook.com (2603:10b6:806:121::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 18:11:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d89767f3-5040-4b84-f91e-08d90039edeb
X-MS-TrafficTypeDiagnostic: BY5PR10MB4114:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB41143BEFC518F66010FE368D894D9@BY5PR10MB4114.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:89;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpWdCm557B3WFgcj6qiR/v3XVsZsuYr65TOSLL/zjCkvvp3qGgbQcsEjrJsGnqTVfcGNoGnokC+qPDlLolq7lDNcTLXkLc/H/UQYDiEWb+L/mR2bFQi5EMvR1hXYx9gr9qGZtcMxcs4QaooSKLFEX4j3mnC4X0x23sFZdtxViElo4MRhHtuQv8Cy4zdHFOuVYlJjy/aggO447CsN7QA6B5FSq+p0xAduqKtbzAvz7+qdLR+67CztGSwJ2knRq+Sgw7YPLDCBIpZ90QrtzDvenbLQvvhalekHgmYod0WvWXiT6dE3VyV7LqXJgdfVk4yRggxvkgWk4rdI5dYXvUrX20sfpZwiaYLQbBJTlJfE65M+Yx5m9otC7QpamfADnc6p6V1AbSQ+cDOopgilAhLLvWEDRWvBxIdGD5DgKy+kAQqES1oTynT2YLdS+ilSNpvA6V6W+INDWswu4OiyDhCjclLTkxcwBtp1EkpfIzkYpLwj/78Y2eTkqz2PORSA+gpYkwyCymWl1kTTjffko//R4bxF825IbrGtYLt+VVazjLZinzrkpPnaFTUZ2d5cioQsGfJvwp26t9tiwRj8Y6dq5qo2Z5PQqJcpruFZcqK3sloI4JwaIZfJ5zrjfUO2RrgSEF0G8yvu/mTGnALQ385HGWDJU53UDfFyJAT1abHfcSkgK7SrSrtWKtyswmLG8TBbuPi4WWZ+lI50fq7ny83BugD8IuzlpW86UE6UOS3Yzlzcgwr+3yQyUfoPn2vn56uhtCe4lIraSNKMAm7+wppoOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(346002)(376002)(8936002)(7406005)(66946007)(6666004)(38100700002)(956004)(7416002)(66476007)(86362001)(66556008)(186003)(30864003)(45080400002)(83380400001)(26005)(7696005)(52116002)(316002)(16526019)(8676002)(5660300002)(38350700002)(6916009)(966005)(55016002)(2906002)(478600001)(4326008)(102196002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?C5y2AfF7LaXhskCfzKCNYJLT0w6KxtDavJWYWEDKSmYTsKXsDP6WsoYDoYFH?=
 =?us-ascii?Q?gD/FYbJuOZkCRNa6Rtle+Q3bAF6lwddXAWABr/aQozg0GdpwF+k4Txbd7s4e?=
 =?us-ascii?Q?9bK8dbaqYMnDnILHXCmbOwzc5JzBMgBZTOy/dtq/EIrz1UiFROeUf9fGeITc?=
 =?us-ascii?Q?/IWPhgHJvla3U0qMGoUE9sc/B9BbayL4ktpf8FyX1BgHqRaAOCdbVOLfb7R/?=
 =?us-ascii?Q?SbgPG1WwW3XTDGWw7MVqClUFqJuP/X8FNMml0kFN0Z9Ca8PTbt6Meqzhkkh5?=
 =?us-ascii?Q?XigVtPzDRTlM7Pjo5jz9mlyZbyjwtpx8WB4fTXb0lMfIzF75/YKoWtwlk7A3?=
 =?us-ascii?Q?WP/xDeWjcRqNsz78rb/xpLY/1wRTKhnz/X/Ixtgv35YENQzh8LF3aoQJsh+J?=
 =?us-ascii?Q?RC1HFydEqvbKEnAZEawnh4h+5ADbC77blemKlVOaHZt7+KQv/7dUgkyNNp8K?=
 =?us-ascii?Q?o6uXUhJdw8w+LBHMeXSCTSSXUdeZJ+qfbFejPUnCRZNIAJYPtfrH2GuoyWg6?=
 =?us-ascii?Q?EFCoE109Olm0Vr4ceBBY902LYxf2l+8lU0yoGzKgn7KGJrRbeB3g7u283Ngr?=
 =?us-ascii?Q?h3Tyhi7vPCKBFFohGyP7rl2jAQ0RsfENL1tn08gK50J0Ri2I/MWSFQg6ug1Y?=
 =?us-ascii?Q?mM+/Wbe59PVVqTAz0p+UzvD8kpcQAH/v3S6iqEmB/iQ9BKkWjnO2lRJJkp+Q?=
 =?us-ascii?Q?4jIWk/qEDrQpIZombILoyl3laADbRZhozIHFFZ6w6B0twVei7UVlHidCxtG9?=
 =?us-ascii?Q?ITUC60C8gSbvfVom89SsmI75laEALd43kksR4AslRz58KmXkNgsmodzQh7Kb?=
 =?us-ascii?Q?psNB1Fl5HWYOhHntXxmPsWcx5Xu1CewsKEapEq/Mb6y1T7/tRsU7z4l2D79f?=
 =?us-ascii?Q?fhU6gknDLGn/UYZ++pdDaNjvXH9he/Od9pM+q36MsEvQz+7BweHTwt/vaDFY?=
 =?us-ascii?Q?/LiPXIYe8wiBcYmDG2uaq+j2pVau48DZh6rpf5WqdsKnQ6056f01Q5Y9EMo/?=
 =?us-ascii?Q?L25RqSx9XyWG5gJ9gabj5v6af9kSjlUy9cFB84eV+GhpLBUZzgPQXC41FIEo?=
 =?us-ascii?Q?Iqe9pBVcduoqx7J3PAB/TQexSVEtSBwPdDG9dPStfrkvkl6otbwdWv4PvQoG?=
 =?us-ascii?Q?1yXEJ4ecZuyGxa77ENqfaCYk/YhGMDUCDZbKXgesIny3kVpHSjYx3CIjOkxR?=
 =?us-ascii?Q?TS/lar38YhRpOhLewIEdGkKo4+DGQumDzXEM2k/Irkrw8Y6piaA6JHafuBK8?=
 =?us-ascii?Q?HuRwceAJUFJUy3aOuA4G8JBps2UZO6JDlgurs8CzRd6HvlBfmEFovibmDU68?=
 =?us-ascii?Q?C2DF07IJyNLATfZZ6eQpphh+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89767f3-5040-4b84-f91e-08d90039edeb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 18:11:46.2551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qxLCNF+BYirVfpS8epyBd10P/y940Z5e1l/H0tMy+qrzuELPD1bqHCFRCqjx8+eSsDh6f6z/bLrwN5opvFaQlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4114
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150112
X-Proofpoint-ORIG-GUID: qaNJ5Ko1dZ193fB4WxAq_8xxo_u0wE50
X-Proofpoint-GUID: qaNJ5Ko1dZ193fB4WxAq_8xxo_u0wE50
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 10:49:37AM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Hyper-V provides GHCB protocol to write Synthetic Interrupt
> Controller MSR registers and these registers are emulated by
> Hypervisor rather than paravisor.

What is paravisor? Is that the VMPL0 to borrow AMD speak from
https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf
 
> 
> Hyper-V requests to write SINTx MSR registers twice(once via
> GHCB and once via wrmsr instruction including the proxy bit 21)

Why? And what does 'proxy bit 21' mean? Isn't it just setting a bit
on the MSR?

Oh. Are you writting to it twice because you need to let the hypervisor
know (Hyper-V) which is done via the WRMSR. And then the inner
hypervisor (VMPL0) via the SINITx MSR?


> Guest OS ID MSR also needs to be set via GHCB.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/hyperv/hv_init.c       |  18 +----
>  arch/x86/hyperv/ivm.c           | 130 ++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/mshyperv.h |  87 +++++++++++++++++----
>  arch/x86/kernel/cpu/mshyperv.c  |   3 +
>  drivers/hv/hv.c                 |  65 +++++++++++-----
>  include/asm-generic/mshyperv.h  |   4 +-
>  6 files changed, 261 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index 90e65fbf4c58..87b1dd9c84d6 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -475,6 +475,9 @@ void __init hyperv_init(void)
>  
>  		ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
>  		*ghcb_base = ghcb_va;
> +
> +		/* Hyper-V requires to write guest os id via ghcb in SNP IVM. */
> +		hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, guest_id);
>  	}
>  
>  	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
> @@ -561,6 +564,7 @@ void hyperv_cleanup(void)
>  
>  	/* Reset our OS id */
>  	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
> +	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
>  
>  	/*
>  	 * Reset hypercall page reference before reset the page,
> @@ -668,17 +672,3 @@ bool hv_is_hibernation_supported(void)
>  	return !hv_root_partition && acpi_sleep_state_supported(ACPI_STATE_S4);
>  }
>  EXPORT_SYMBOL_GPL(hv_is_hibernation_supported);
> -
> -enum hv_isolation_type hv_get_isolation_type(void)
> -{
> -	if (!(ms_hyperv.features_b & HV_ISOLATION))
> -		return HV_ISOLATION_TYPE_NONE;
> -	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
> -}
> -EXPORT_SYMBOL_GPL(hv_get_isolation_type);
> -
> -bool hv_is_isolation_supported(void)
> -{
> -	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
> -}
> -EXPORT_SYMBOL_GPL(hv_is_isolation_supported);
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index a5950b7a9214..2ec64b367aaf 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -6,12 +6,139 @@
>   *  Tianyu Lan <Tianyu.Lan@microsoft.com>
>   */
>  
> +#include <linux/types.h>
> +#include <linux/bitfield.h>
>  #include <linux/hyperv.h>
>  #include <linux/types.h>
>  #include <linux/bitfield.h>
>  #include <asm/io.h>
> +#include <asm/svm.h>
> +#include <asm/sev-es.h>
>  #include <asm/mshyperv.h>
>  
> +union hv_ghcb {
> +	struct ghcb ghcb;
> +} __packed __aligned(PAGE_SIZE);
> +
> +void hv_ghcb_msr_write(u64 msr, u64 value)
> +{
> +	union hv_ghcb *hv_ghcb;
> +	void **ghcb_base;
> +	unsigned long flags;
> +
> +	if (!ms_hyperv.ghcb_base)
> +		return;
> +
> +	local_irq_save(flags);
> +	ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
> +	hv_ghcb = (union hv_ghcb *)*ghcb_base;
> +	if (!hv_ghcb) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +
> +	memset(hv_ghcb, 0x00, HV_HYP_PAGE_SIZE);
> +
> +	hv_ghcb->ghcb.protocol_version = 1;
> +	hv_ghcb->ghcb.ghcb_usage = 0;
> +
> +	ghcb_set_sw_exit_code(&hv_ghcb->ghcb, SVM_EXIT_MSR);
> +	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
> +	ghcb_set_rax(&hv_ghcb->ghcb, lower_32_bits(value));
> +	ghcb_set_rdx(&hv_ghcb->ghcb, value >> 32);
> +	ghcb_set_sw_exit_info_1(&hv_ghcb->ghcb, 1);
> +	ghcb_set_sw_exit_info_2(&hv_ghcb->ghcb, 0);
> +
> +	VMGEXIT();
> +
> +	if ((hv_ghcb->ghcb.save.sw_exit_info_1 & 0xffffffff) == 1)
> +		pr_warn("Fail to write msr via ghcb.\n.");
> +
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(hv_ghcb_msr_write);
> +
> +void hv_ghcb_msr_read(u64 msr, u64 *value)
> +{
> +	union hv_ghcb *hv_ghcb;
> +	void **ghcb_base;
> +	unsigned long flags;
> +
> +	if (!ms_hyperv.ghcb_base)
> +		return;
> +
> +	local_irq_save(flags);
> +	ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
> +	hv_ghcb = (union hv_ghcb *)*ghcb_base;
> +	if (!hv_ghcb) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +
> +	memset(hv_ghcb, 0x00, PAGE_SIZE);
> +	hv_ghcb->ghcb.protocol_version = 1;
> +	hv_ghcb->ghcb.ghcb_usage = 0;
> +
> +	ghcb_set_sw_exit_code(&hv_ghcb->ghcb, SVM_EXIT_MSR);
> +	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
> +	ghcb_set_sw_exit_info_1(&hv_ghcb->ghcb, 0);
> +	ghcb_set_sw_exit_info_2(&hv_ghcb->ghcb, 0);
> +
> +	VMGEXIT();
> +
> +	if ((hv_ghcb->ghcb.save.sw_exit_info_1 & 0xffffffff) == 1)
> +		pr_warn("Fail to write msr via ghcb.\n.");
> +	else
> +		*value = (u64)lower_32_bits(hv_ghcb->ghcb.save.rax)
> +			| ((u64)lower_32_bits(hv_ghcb->ghcb.save.rdx) << 32);
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(hv_ghcb_msr_read);
> +
> +void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value)
> +{
> +	hv_ghcb_msr_read(msr, value);
> +}
> +EXPORT_SYMBOL_GPL(hv_sint_rdmsrl_ghcb);
> +
> +void hv_sint_wrmsrl_ghcb(u64 msr, u64 value)
> +{
> +	hv_ghcb_msr_write(msr, value);
> +
> +	/* Write proxy bit vua wrmsrl instruction. */
> +	if (msr >= HV_X64_MSR_SINT0 && msr <= HV_X64_MSR_SINT15)
> +		wrmsrl(msr, value | 1 << 20);
> +}
> +EXPORT_SYMBOL_GPL(hv_sint_wrmsrl_ghcb);
> +
> +inline void hv_signal_eom_ghcb(void)
> +{
> +	hv_sint_wrmsrl_ghcb(HV_X64_MSR_EOM, 0);
> +}
> +EXPORT_SYMBOL_GPL(hv_signal_eom_ghcb);
> +
> +enum hv_isolation_type hv_get_isolation_type(void)
> +{
> +	if (!(ms_hyperv.features_b & HV_ISOLATION))
> +		return HV_ISOLATION_TYPE_NONE;
> +	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
> +}
> +EXPORT_SYMBOL_GPL(hv_get_isolation_type);
> +
> +bool hv_is_isolation_supported(void)
> +{
> +	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
> +}
> +EXPORT_SYMBOL_GPL(hv_is_isolation_supported);
> +
> +DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
> +
> +bool hv_isolation_type_snp(void)
> +{
> +	return static_branch_unlikely(&isolation_type_snp);
> +}
> +EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
> +
>  /*
>   * hv_set_mem_host_visibility - Set host visibility for specified memory.
>   */
> @@ -22,6 +149,9 @@ int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility)
>  	u64 *pfn_array;
>  	int ret = 0;
>  
> +	if (!hv_is_isolation_supported())
> +		return 0;
> +
>  	pfn_array = vzalloc(HV_HYP_PAGE_SIZE);
>  	if (!pfn_array)
>  		return -ENOMEM;
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
> index d9437f096ce5..73501dbbc240 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -10,6 +10,8 @@
>  #include <asm/nospec-branch.h>
>  #include <asm/paravirt.h>
>  
> +DECLARE_STATIC_KEY_FALSE(isolation_type_snp);
> +
>  typedef int (*hyperv_fill_flush_list_func)(
>  		struct hv_guest_mapping_flush_list *flush,
>  		void *data);
> @@ -19,24 +21,64 @@ typedef int (*hyperv_fill_flush_list_func)(
>  #define hv_init_timer_config(timer, val) \
>  	wrmsrl(HV_X64_MSR_STIMER0_CONFIG + (2*timer), val)
>  
> -#define hv_get_simp(val) rdmsrl(HV_X64_MSR_SIMP, val)
> -#define hv_set_simp(val) wrmsrl(HV_X64_MSR_SIMP, val)
> +#define hv_get_sint_reg(val, reg) {		\
> +	if (hv_isolation_type_snp())		\
> +		hv_get_##reg##_ghcb(&val);		\
> +	else					\
> +		rdmsrl(HV_X64_MSR_##reg, val);	\
> +	}
> +
> +#define hv_set_sint_reg(val, reg) {		\
> +	if (hv_isolation_type_snp())		\
> +		hv_set_##reg##_ghcb(val);		\
> +	else					\
> +		wrmsrl(HV_X64_MSR_##reg, val);	\
> +	}
> +
>  
> -#define hv_get_siefp(val) rdmsrl(HV_X64_MSR_SIEFP, val)
> -#define hv_set_siefp(val) wrmsrl(HV_X64_MSR_SIEFP, val)
> +#define hv_get_simp(val) hv_get_sint_reg(val, SIMP)
> +#define hv_get_siefp(val) hv_get_sint_reg(val, SIEFP)
>  
> -#define hv_get_synic_state(val) rdmsrl(HV_X64_MSR_SCONTROL, val)
> -#define hv_set_synic_state(val) wrmsrl(HV_X64_MSR_SCONTROL, val)
> +#define hv_set_simp(val) hv_set_sint_reg(val, SIMP)
> +#define hv_set_siefp(val) hv_set_sint_reg(val, SIEFP)
> +
> +#define hv_get_synic_state(val) {			\
> +	if (hv_isolation_type_snp())			\
> +		hv_get_synic_state_ghcb(&val);		\
> +	else						\
> +		rdmsrl(HV_X64_MSR_SCONTROL, val);	\
> +	}
> +#define hv_set_synic_state(val) {			\
> +	if (hv_isolation_type_snp())			\
> +		hv_set_synic_state_ghcb(val);		\
> +	else						\
> +		wrmsrl(HV_X64_MSR_SCONTROL, val);	\
> +	}
>  
>  #define hv_get_vp_index(index) rdmsrl(HV_X64_MSR_VP_INDEX, index)
>  
> -#define hv_signal_eom() wrmsrl(HV_X64_MSR_EOM, 0)
> +#define hv_signal_eom() {			 \
> +	if (hv_isolation_type_snp() &&		 \
> +	    old_msg_type != HVMSG_TIMER_EXPIRED) \
> +		hv_signal_eom_ghcb();		 \
> +	else					 \
> +		wrmsrl(HV_X64_MSR_EOM, 0);	 \
> +	}
>  
> -#define hv_get_synint_state(int_num, val) \
> -	rdmsrl(HV_X64_MSR_SINT0 + int_num, val)
> -#define hv_set_synint_state(int_num, val) \
> -	wrmsrl(HV_X64_MSR_SINT0 + int_num, val)
> -#define hv_recommend_using_aeoi() \
> +#define hv_get_synint_state(int_num, val) {		\
> +	if (hv_isolation_type_snp())			\
> +		hv_get_synint_state_ghcb(int_num, &val);\
> +	else						\
> +		rdmsrl(HV_X64_MSR_SINT0 + int_num, val);\
> +	}
> +#define hv_set_synint_state(int_num, val) {		\
> +	if (hv_isolation_type_snp())			\
> +		hv_set_synint_state_ghcb(int_num, val);	\
> +	else						\
> +		wrmsrl(HV_X64_MSR_SINT0 + int_num, val);\
> +	}
> +
> +#define hv_recommend_using_aeoi()				\
>  	(!(ms_hyperv.hints & HV_DEPRECATING_AEOI_RECOMMENDED))
>  
>  #define hv_get_crash_ctl(val) \
> @@ -271,6 +313,25 @@ int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
>  
>  int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility);
>  int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility);
> +void hv_sint_wrmsrl_ghcb(u64 msr, u64 value);
> +void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value);
> +void hv_signal_eom_ghcb(void);
> +void hv_ghcb_msr_write(u64 msr, u64 value);
> +void hv_ghcb_msr_read(u64 msr, u64 *value);
> +
> +#define hv_get_synint_state_ghcb(int_num, val)			\
> +	hv_sint_rdmsrl_ghcb(HV_X64_MSR_SINT0 + int_num, val)
> +#define hv_set_synint_state_ghcb(int_num, val) \
> +	hv_sint_wrmsrl_ghcb(HV_X64_MSR_SINT0 + int_num, val)
> +
> +#define hv_get_SIMP_ghcb(val) hv_sint_rdmsrl_ghcb(HV_X64_MSR_SIMP, val)
> +#define hv_set_SIMP_ghcb(val) hv_sint_wrmsrl_ghcb(HV_X64_MSR_SIMP, val)
> +
> +#define hv_get_SIEFP_ghcb(val) hv_sint_rdmsrl_ghcb(HV_X64_MSR_SIEFP, val)
> +#define hv_set_SIEFP_ghcb(val) hv_sint_wrmsrl_ghcb(HV_X64_MSR_SIEFP, val)
> +
> +#define hv_get_synic_state_ghcb(val) hv_sint_rdmsrl_ghcb(HV_X64_MSR_SCONTROL, val)
> +#define hv_set_synic_state_ghcb(val) hv_sint_wrmsrl_ghcb(HV_X64_MSR_SCONTROL, val)
>  #else /* CONFIG_HYPERV */
>  static inline void hyperv_init(void) {}
>  static inline void hyperv_setup_mmu_ops(void) {}
> @@ -289,9 +350,9 @@ static inline int hyperv_flush_guest_mapping_range(u64 as,
>  {
>  	return -1;
>  }
> +static inline void hv_signal_eom_ghcb(void) { };
>  #endif /* CONFIG_HYPERV */
>  
> -
>  #include <asm-generic/mshyperv.h>
>  
>  #endif
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index aeafd4017c89..6eaa0891c0f7 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -333,6 +333,9 @@ static void __init ms_hyperv_init_platform(void)
>  
>  		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
>  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
> +
> +		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP)
> +			static_branch_enable(&isolation_type_snp);
>  	}
>  
>  	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index f202ac7f4b3d..069530eeb7c6 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -99,17 +99,24 @@ int hv_synic_alloc(void)
>  		tasklet_init(&hv_cpu->msg_dpc,
>  			     vmbus_on_msg_dpc, (unsigned long) hv_cpu);
>  
> -		hv_cpu->synic_message_page =
> -			(void *)get_zeroed_page(GFP_ATOMIC);
> -		if (hv_cpu->synic_message_page == NULL) {
> -			pr_err("Unable to allocate SYNIC message page\n");
> -			goto err;
> -		}
> +		/*
> +		 * Synic message and event pages are allocated by paravisor.
> +		 * Skip these pages allocation here.
> +		 */
> +		if (!hv_isolation_type_snp()) {
> +			hv_cpu->synic_message_page =
> +				(void *)get_zeroed_page(GFP_ATOMIC);
> +			if (hv_cpu->synic_message_page == NULL) {
> +				pr_err("Unable to allocate SYNIC message page\n");
> +				goto err;
> +			}
>  
> -		hv_cpu->synic_event_page = (void *)get_zeroed_page(GFP_ATOMIC);
> -		if (hv_cpu->synic_event_page == NULL) {
> -			pr_err("Unable to allocate SYNIC event page\n");
> -			goto err;
> +			hv_cpu->synic_event_page =
> +				(void *)get_zeroed_page(GFP_ATOMIC);
> +			if (hv_cpu->synic_event_page == NULL) {
> +				pr_err("Unable to allocate SYNIC event page\n");
> +				goto err;
> +			}
>  		}
>  
>  		hv_cpu->post_msg_page = (void *)get_zeroed_page(GFP_ATOMIC);
> @@ -136,10 +143,17 @@ void hv_synic_free(void)
>  	for_each_present_cpu(cpu) {
>  		struct hv_per_cpu_context *hv_cpu
>  			= per_cpu_ptr(hv_context.cpu_context, cpu);
> +		free_page((unsigned long)hv_cpu->post_msg_page);
> +
> +		/*
> +		 * Synic message and event pages are allocated by paravisor.
> +		 * Skip free these pages here.
> +		 */
> +		if (hv_isolation_type_snp())
> +			continue;
>  
>  		free_page((unsigned long)hv_cpu->synic_event_page);
>  		free_page((unsigned long)hv_cpu->synic_message_page);
> -		free_page((unsigned long)hv_cpu->post_msg_page);
>  	}
>  
>  	kfree(hv_context.hv_numa_map);
> @@ -161,20 +175,36 @@ void hv_synic_enable_regs(unsigned int cpu)
>  	union hv_synic_sint shared_sint;
>  	union hv_synic_scontrol sctrl;
>  
> -	/* Setup the Synic's message page */
> +
> +	/* Setup the Synic's message. */
>  	hv_get_simp(simp.as_uint64);
>  	simp.simp_enabled = 1;
> -	simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
> -		>> HV_HYP_PAGE_SHIFT;
> +
> +	if (hv_isolation_type_snp()) {
> +		hv_cpu->synic_message_page
> +			= ioremap_cache(simp.base_simp_gpa << HV_HYP_PAGE_SHIFT,
> +					HV_HYP_PAGE_SIZE);
> +		if (!hv_cpu->synic_message_page)
> +			pr_err("Fail to map syinc message page.\n");
> +	} else {
> +		simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
> +			>> HV_HYP_PAGE_SHIFT;
> +	}
>  
>  	hv_set_simp(simp.as_uint64);
>  
>  	/* Setup the Synic's event page */
>  	hv_get_siefp(siefp.as_uint64);
>  	siefp.siefp_enabled = 1;
> -	siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
> -		>> HV_HYP_PAGE_SHIFT;
> -
> +	if (hv_isolation_type_snp()) {
> +		hv_cpu->synic_event_page = ioremap_cache(
> +			 siefp.base_siefp_gpa << HV_HYP_PAGE_SHIFT, HV_HYP_PAGE_SIZE);
> +		if (!hv_cpu->synic_event_page)
> +			pr_err("Fail to map syinc event page.\n");
> +	} else {
> +		siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
> +			>> HV_HYP_PAGE_SHIFT;
> +	}
>  	hv_set_siefp(siefp.as_uint64);
>  
>  	/* Setup the shared SINT. */
> @@ -188,7 +218,6 @@ void hv_synic_enable_regs(unsigned int cpu)
>  	/* Enable the global synic bit */
>  	hv_get_synic_state(sctrl.as_uint64);
>  	sctrl.enable = 1;
> -
>  	hv_set_synic_state(sctrl.as_uint64);
>  }
>  
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
> index b73e201abc70..59777377e641 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -23,6 +23,7 @@
>  #include <linux/bitops.h>
>  #include <linux/cpumask.h>
>  #include <asm/ptrace.h>
> +#include <asm/mshyperv.h>
>  #include <asm/hyperv-tlfs.h>
>  
>  struct ms_hyperv_info {
> @@ -52,7 +53,7 @@ extern struct ms_hyperv_info ms_hyperv;
>  
>  extern u64 hv_do_hypercall(u64 control, void *inputaddr, void *outputaddr);
>  extern u64 hv_do_fast_hypercall8(u16 control, u64 input8);
> -
> +extern bool hv_isolation_type_snp(void);
>  
>  /* Generate the guest OS identifier as described in the Hyper-V TLFS */
>  static inline  __u64 generate_guest_id(__u64 d_info1, __u64 kernel_version,
> @@ -186,6 +187,7 @@ bool hv_is_hyperv_initialized(void);
>  bool hv_is_hibernation_supported(void);
>  enum hv_isolation_type hv_get_isolation_type(void);
>  bool hv_is_isolation_supported(void);
> +bool hv_isolation_type_snp(void);
>  void hyperv_cleanup(void);
>  #else /* CONFIG_HYPERV */
>  static inline bool hv_is_hyperv_initialized(void) { return false; }
> -- 
> 2.25.1
> 
