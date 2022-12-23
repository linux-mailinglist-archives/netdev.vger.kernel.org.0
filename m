Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49266554B8
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 22:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiLWVZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 16:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLWVZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 16:25:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B232181C;
        Fri, 23 Dec 2022 13:25:04 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BNKxwdn004605;
        Fri, 23 Dec 2022 21:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=DpXfFoCfcdwC0+fZT8B7NKRcXetd9iXc1+xmDnnJjhA=;
 b=nYH8FmrETAXZs2UXeV/l/GfAI4bNsHnA00Twlq0opLqSvFvbWAfLroBXZv/Mg86Rixbb
 UPipZR0virLDH6pmerYPhkIHN29cRLCgP3lNpUuR+r+qEQeBtkmi2cutdsdySeBzxmOX
 zcRb7fikvwcnBDCWZjvjL/QBLRd1KBl31VE4Z7Mf2Bcj2g3w+1HY5o6MwV1AQ+y2slEj
 I+mtpCoqr8ZuHzrgQ2HvZ2TA87fSh6r0DXUN7jvhayf9VaPosxBU//oA8lfW0534Yb+8
 npPfSeA9kuhXfr98PhPCnEaTj/Vu3zVXfLzE/6eL0sMg5ln4VmKBO2gc4ysah1dIp/1p fw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tpexcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Dec 2022 21:22:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BNKXbVX004045;
        Fri, 23 Dec 2022 21:22:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh47g17r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Dec 2022 21:22:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUPa2C5ppJnKkO07vhEs60XL8SYlkf/qjdMXSsABiBwDuUHpo59XKH+3AZoIP0ZgX+xP/iywurU9evCrpuQ/vUfxwVuM8topFVnDSbLBkjMGz2t+vi/KNSLx7g7XQpALtj3MhlGeC9okIQC+mz27jU5Hjp4jZKnqhpg+VX19QChoZGKr50PRDI271rWQGYuaS3c5voW4hzvUNHEjTwNZaipeQPpO7gWnACwNvViHKAPOBPOL6q0pqei25zjQ0FT3hhC0DvaQVnNy9wvrJ0qlzjlzgN9F/FpgUybY/Rzuhq9IhV/9ohKD5XWNDro7I7mDSK5TAnnWZ8o9qClvoy8wOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpXfFoCfcdwC0+fZT8B7NKRcXetd9iXc1+xmDnnJjhA=;
 b=E4NvFqawNR1+TxKxtXfj9o9hrlxmdnTG21ho7oz7am4T4ca/qVTvNnUyzYW5Z9L9J70CCYC5XpUh5OZB9oyWvX7/guDtlwhV0YZY2cRHAAZzBW+scaHaeC4vzYN6w7TOXKHcii5zdmDao2j15Lb5FjiZugFVS7U6sj0DNSmD8ztHrha+CVvLbumXfrHrY7onYfjvGwV/VY/Xdrh/Yzdmt8a+UB2Bb1KL2ob7Gf5/IdIKTX4iI/eEqRbk/e+5VOvrh0nZReI8JnFSCvsfJVrCB+utmAvkVoh2RLZ3+a3GFj1yja3OWr2Q0EGAl6czRfkYXB42sqszDzH1kgbGH/cjtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpXfFoCfcdwC0+fZT8B7NKRcXetd9iXc1+xmDnnJjhA=;
 b=vOpr6kvhWmIn1HELqGa3a018udkMTW+lVF9iwblbODmE1Tb3MMSut5YfGm3SbVTOGNSnHy9wrM/ozOtOFadamKyns+4TdTnlC+UA6KfskcIZk02/QkvbiUMJtS9k5IAnjFelGBWYXqXy37IjKcFVl36FRSM0MK/zgK15+2HvQGA=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SN7PR10MB6522.namprd10.prod.outlook.com (2603:10b6:806:2a5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Fri, 23 Dec
 2022 21:22:11 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%7]) with mapi id 15.20.5944.012; Fri, 23 Dec 2022
 21:22:11 +0000
Date:   Fri, 23 Dec 2022 13:22:08 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
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
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm: remove zap_page_range and change callers to use
 zap_vma_page_range
Message-ID: <Y6YcAKT+vVIyWTkF@monkey>
References: <20221216192012.13562-1-mike.kravetz@oracle.com>
 <Y6XW3hMtB7PrTSM5@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6XW3hMtB7PrTSM5@infradead.org>
X-ClientProxiedBy: MW4PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:303:8f::20) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SN7PR10MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c5ac313-d715-4560-c032-08dae52bc100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQp4TBaXimoGvwWqiPH69+Vj7KGh024JVyuPhyRhgWtnyRF73nCGYoDvjlI1Xpa9UFvVev4XqoPop8wLF8TMOH21gaNCD/p9qUDl3hZUuw1bpQVTgy9cYOJ+6ZJFFB8bQcAee500aA3RkkxbUjONNz5LyBdzfZApDmbXjd14P0kh2sI1B7clMtIy7OCyynUfK5XsOv1Wv103O64aSuzEIotH4AQZvFVRBrAWegbe4q45bxdZncxfYNpt60kMcDZgfvLk26ISKbqDUVMnRNXqz2Iz8Ii2Q2dQrHMz72/t2rWPovGiD5rd90UNCr+mifVJo7irVcWRUe5m8PV87un9+F0sVnMXB75g9sVQN45pMtGP/eSiGXC9Oq8oQUg5eO/WPr2qeAlQaZ7eELE7tUvpqm6Jz6wOBx46c+y0Tg5pcNsphyC1c/fPn9pvTXbCfUU2Rqe00ijqQ1zjmPnWvtTNRSbQPwCzalrzXs6iOcfBkcN4RU2oj8yjJETHmqHCDxAITTm/7s++ImzTqU7JeQhnT8P8mIIl8ZhZc4EhaZ2tskkOoyuA7octItEssqzCz33zvnpRXqswZmOa3GRIwrVILMK4pkzSEJOninGcuAhFANi4fp2Zi1RkHTBSDoVG1CXiuxC/Pp2aesGnD3/Cs3E+p4qI/OBM0tqSuspTgKWYp6VZIQNYC87Jc4Qd09irmgoo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(8676002)(41300700001)(38100700002)(5660300002)(7416002)(8936002)(2906002)(33716001)(53546011)(4326008)(44832011)(478600001)(6666004)(6486002)(86362001)(54906003)(316002)(6916009)(6506007)(186003)(66556008)(66946007)(26005)(6512007)(9686003)(66476007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zo7vqLWEY58VihFZ7RdJ3LXXgUP0NYY9ob7WJOLRG4RiD9Vg9eSvaLDc89Rw?=
 =?us-ascii?Q?jDx+JP6qF5BQopiOmm0hq8IfQiLtSsOXyHzFG7mS3JA6eMkQ8Y0uH6W04k6S?=
 =?us-ascii?Q?Mn7vS4dLcMYGhTEGN3yRZtP2ncGISH8X8z9LPSFkmUTnsxpwj8y7dOYt0Db9?=
 =?us-ascii?Q?6+3G2WCxnYcatwTz4NWaI2DnUd6bbhb+nRF4W+4a8nDZhJ/12eZx4E855p+Z?=
 =?us-ascii?Q?8rWCILuOfgZbPR7/GYzHlddAsjyyAW48uxRFi1HtLP6mOXXU7di9F5ErM0RQ?=
 =?us-ascii?Q?NOX7he4jyVvXZq5kL4oLtg2G3G7/UTRIfOeuMYbrKVY04WgA3kKGXEj6WZCA?=
 =?us-ascii?Q?tG3vxJjY7ucNvfvj2OEpjjfJruVTQ9jUyzxJIw7t55gv9cvnskIPks+aVgjM?=
 =?us-ascii?Q?/KH7Qod5fXnZqK9GlbYACQVNgelUkiKFatHWil7iJ+PmzYMwFvElcUryUKHT?=
 =?us-ascii?Q?q35bOVBPsZJGtiHhMmx4c23iRKaREmXAsDEuIsgpKKl7F9P61Z+TrhxFbep1?=
 =?us-ascii?Q?1aN7zmahiEpzBhld2jDd6i6LhvO+UBm5qJYR/jBDOflDnyajUsR76F2lGnys?=
 =?us-ascii?Q?bYZOKzcgHgTNz2b8H9FhYpSED5atoDM/oqANCuW0tvGFnD5ws2cvCLO2Ev10?=
 =?us-ascii?Q?KHDd+wwSx+4sOHFVI7kb8n9K6Gmu4geVCb//xTrOX20dkZb/xx7DKc3p090q?=
 =?us-ascii?Q?GDACvbj+sPXMrpmxdvHvKvsNlfDxHykWxI4Mk65bqAAAcgTTmq3W9yCi6H9m?=
 =?us-ascii?Q?ghe/F6gkNzLkZVP1thj6WjAZ5VnnjrpIoQAJgPXX/SQ2Etl0Zi2BAokbqHUG?=
 =?us-ascii?Q?w71ig5qtNGahHWtQA3zz6ZsPx/x72H5EfNzW7ao19uaZ+hQSRwSajr17HrEw?=
 =?us-ascii?Q?KEqBiqXxIfCCKdktTsdQnGtJuHldSnkxmZXzaUYlfOqXDeDDiSvTmAQJVaGB?=
 =?us-ascii?Q?iFobxZLIC3Mtnxc6qK7V8NmhYgj5tsZJwzPhHbTe1b2FCJQUSMuQ4Sx0Slw7?=
 =?us-ascii?Q?eg7onm9lJYIIsbkpF6aF9aTGHtLIWIssdPL5+UNa+4E/mn7ynJxtfC5O5DAc?=
 =?us-ascii?Q?UICwGtZ++VTnjlKaR/JI7HqzkS2/zw+d/9XWsTf7OqDimAQPncGOhe1IKXWS?=
 =?us-ascii?Q?vrQfTBve9IA71Txwu5F+OVz5vkF/Iyh4Qu8tire/3L879FhRfV3s+EZ/VnRB?=
 =?us-ascii?Q?qR2t24whSmM+Myigqj9UX29TiBJvGltCsu7lKiFysBwXvMojYhomj/uzbnRg?=
 =?us-ascii?Q?cHkBOkMCOVoOR4Fwa7Z6zqbtV1dKwji8qQiis2zsPdnw4Fh58bYecv3sFn36?=
 =?us-ascii?Q?49YJXSMPc+OzaeF6gTb7qPi66Ihxr/Gljbp6ELFrm7yrM0X3GEMVccwgis7H?=
 =?us-ascii?Q?HZQ/FNTO2m/MymYsry1kIDUL3TgS63ngZmMk2DiuLdtHWJzOw35hD9x9TjlS?=
 =?us-ascii?Q?n57xVSeU5elzFFAcmfiw0XS9fx5Apawgmw0msbnvDpBCsC9JbcCESh4CL12H?=
 =?us-ascii?Q?XaAALMaK0VNl42tbxvdcrWBSaKFONtYx9nhc+NQFPKmbC5DTQ2/3Tsn1nb2f?=
 =?us-ascii?Q?SJ2xvz1OVTTpZywzcrHYwH5vEIvKlNghQLZHHzN1nvHzLVWshtzkuC5rzCCg?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5ac313-d715-4560-c032-08dae52bc100
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 21:22:11.3096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJUt25Q0xuyN3JdiX8QD5hMDg7x/LjPCT7S9F4XuKYCEWP2yYZo6ZKshB3BQkeuWxntv2yIpAJwTja2CzP8cCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6522
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-23_08,2022-12-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212230178
X-Proofpoint-GUID: TindufSzVaaX12-dPvfre_Qe4CneRmZ_
X-Proofpoint-ORIG-GUID: TindufSzVaaX12-dPvfre_Qe4CneRmZ_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/22 08:27, Christoph Hellwig wrote:
> >  		unsigned long size = vma->vm_end - vma->vm_start;
> >  
> >  		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA64].dm))
> > -			zap_page_range(vma, vma->vm_start, size);
> > +			zap_vma_page_range(vma, vma->vm_start, size);
> >  #ifdef CONFIG_COMPAT_VDSO
> >  		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA32].dm))
> > -			zap_page_range(vma, vma->vm_start, size);
> > +			zap_vma_page_range(vma, vma->vm_start, size);
> >  #endif
> 
> So for something called zap_vma_page_range I'd expect to just pass
> the vma and zap all of it, which this and many other callers want
> anyway.
> 
> > +++ b/arch/s390/mm/gmap.c
> > @@ -722,7 +722,7 @@ void gmap_discard(struct gmap *gmap, unsigned long from, unsigned long to)
> >  		if (is_vm_hugetlb_page(vma))
> >  			continue;
> >  		size = min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
> > -		zap_page_range(vma, vmaddr, size);
> > +		zap_vma_page_range(vma, vmaddr, size);
> 
> And then just call zap_page_range_single directly for those that
> don't want to zap the entire vma.

Thanks!

This sounds like a good idea and I will incorporate in a new patch.

-- 
Mike Kravetz
