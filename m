Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99CF39A6AF
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFCRJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:09:03 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25714 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhFCRJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 13:09:02 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153H2vsu020650;
        Thu, 3 Jun 2021 17:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=W0kt1JqVyTcAf9VeNPE43ObyZ/OpJxPvaVZ7K1L2fZU=;
 b=q7DhytsgfAYHiFD77bjRBoXXh38rh9oq1+9yUUFJQ7i8FacQvxI24Xe3oW5CKlhXTBB2
 pydqUFK2O3NsZ/pB3vT31MJ+hs+gwi7xnsetoFA0tX/JEhY8UVyDU3OvUX1XmR5CcyjV
 pa2kWhkQAX8MocIxALkOH9oz64cECrHUX1Z3K5PTITI8h7i3jVKcRyiviNpCO19lDp6L
 Fshv+s+YwUjvZ0/vgrvts7QQ1pkY4eQnZk1MCuy8k5TAhlKPDpzPZy8DlmbE5qtozqyr
 NQYzzRQejxOhlWK1Ixei0dDlNxDeLsXmQ6S42/QbXBjR2JIVq7GOYCYPZZyiC6EJP/sA uA== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38wx9frsup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 17:05:16 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 153H2aVP106745;
        Thu, 3 Jun 2021 17:05:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3030.oracle.com with ESMTP id 38ubnf1qh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 17:05:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDdEyxAX/G5netsP5tZvnWy8kr5ph7B6q/nvKRPd/104mUhQk0MZIeCwyADh20LdvDz71Gv46lg9x/e+Vbvjk6uOlWPyPAoZOstEvvs1y5t+OCJwEkEqvtOiye6jEDiklMOObVXIClrLY9kT5tQkC2vo8DikIj0dq7sBiF/NAg72OhXlUf1WM+5DLVGn8qa4zMGcZWV3GfLIOyAXQG1G2P4oOo+JOhGth16KwULn8q54NiacuHt8FQaVldDgho3MDdeRGBvgEtJKaMU8JNDsglyQfFeVFH1UZt5rP1lVgqvw4F6VAPktyqaBUylVIzJ64BPXLdsEiLFeYLBEDyXqag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0kt1JqVyTcAf9VeNPE43ObyZ/OpJxPvaVZ7K1L2fZU=;
 b=RPVw+HO2jpm4EAFg/YS59qxwPOOn9821cJzYoH3p93fA51udOIcEEpwxsh5iprCAwAsEHK3D+zG4yH1xbpywb1cMDwKBAPmK8LEVJIrWG5sJ1uPfiXZRhbHF1chG2Dbrd79pKSiLW1yu4fn2+tHgoYWihDJvm84cRiJISEgk1DqaaN6Th61eTxdXwG84F4nGFHerBpSZ3HohOuHgT0u3aFT+WP0Z5Gm1qjQ1Z+G8VQ5BX3OqXqiotacp3PqoS6iUriYwgqrhdDhhdtAR2MSqW3gzFb9yxTaXqfR8MHaSIagDfUO6cCrToa8+MPzAuDE+UuY7NHm/hUDX+gYfqfq5Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0kt1JqVyTcAf9VeNPE43ObyZ/OpJxPvaVZ7K1L2fZU=;
 b=WAXvVmynqMvPxvciQFgMKNDpIBGZN1HAc1rDnJM2qnYcz02cVVk+t4zMjaUaRf758wmEUV5EbhDYqGl2We96zvfoeuWaSE2+nwntQ2sF42MXGvtQVRj7JG4urjJbrwbOlrKrFsufQj/MdTH2aWz1/t5XHzR02mFi1aO/vFZ99R4=
Authentication-Results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4301.namprd10.prod.outlook.com (2603:10b6:208:1d9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 17:05:12 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf%7]) with mapi id 15.20.4195.023; Thu, 3 Jun 2021
 17:05:12 +0000
Subject: Re: [RFC PATCH V3 09/11] HV/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
To:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, cai@lca.pw,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        Tianyu.Lan@microsoft.com, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-10-ltykernel@gmail.com>
 <9488c114-81ad-eb67-79c0-5ed319703d3e@oracle.com>
 <a023ee3f-ce85-b54f-79c3-146926bf3279@gmail.com>
 <d6714e8b-dcb6-798b-59a4-5bb68f789564@oracle.com>
 <1cdf4e6e-6499-e209-d499-7ab82992040b@gmail.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <099f311b-9614-dac5-ce05-6dad988f8a62@oracle.com>
Date:   Thu, 3 Jun 2021 13:04:57 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <1cdf4e6e-6499-e209-d499-7ab82992040b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [160.34.88.237]
X-ClientProxiedBy: BY3PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::34) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.96.237] (160.34.88.237) by BY3PR03CA0029.namprd03.prod.outlook.com (2603:10b6:a03:39a::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Thu, 3 Jun 2021 17:05:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6c32b45-aa2d-45f6-f36b-08d926b1c029
X-MS-TrafficTypeDiagnostic: MN2PR10MB4301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4301570CE51481F8E38CF31C8A3C9@MN2PR10MB4301.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ib59lrCRhUEe25JkRnNnwO7/YJUzZIh37ouuzzvFtifgsJqZWIWIoi5+jWOXCCGNf5AuSPa7HZAaw6NrBjLPg7QZD77646nwPEqf93B7Abtghl3tho5JdsbjjLhR6I46YIneBbyYWQMWaCaie4UeJmcxdCgAD731nr1ohitpVONUNY6Ku/xlf2DcukgfEmHNQ4sCkwXPm+EoBKrEhL9ac1wW3Vw0tdQVXPwplSCnEAc1U9EScJpkzV1cLYDEP7FlfwB8SR3pNkm2HUQDa84ysj1KjfqzV89UMUX70lISiV9NdGI/Hmk5ZDwi0O0K47wBhuQpWIbt4SkZgA9Inn82obiJ2uESdus8pc7in6wxZq5I1HGvIfzLtRYAo+MxWf+Pfbbro1QyhSI87mXt2PRirMeK1iUHeGyHXPOmfwOIqH1v3qQiIHK1sHTU0OklcV3gIkrxm17CuCTDQ3iCsnu3pztKLX2lrMXYbLnSqt1UmI8vNHoYuMDXsCJ7AIpvul927pZ3fvA7JZQlhu0z94ofgDBAb0g0mVLcq/fgSzUhWqql6cuyO2fiOfYR62PGxn4sP7RbgCugQOpinqyO3D5YG6uttjK3aaX06y/jqC1iIl+CsaKB7R+HV2zLLw3cHygk2mB+56CuRlYxsc+25Xi/mvT9dPM3pA0Rno6KZHpM90BzLVT58RcQu67YceKAb2hy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(39860400002)(136003)(376002)(7406005)(38100700002)(16576012)(921005)(4326008)(7416002)(26005)(83380400001)(8936002)(16526019)(478600001)(186003)(44832011)(4744005)(2906002)(316002)(31696002)(53546011)(86362001)(6636002)(66476007)(66556008)(66946007)(6666004)(2616005)(6486002)(8676002)(956004)(36756003)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VEhpODY5bk9rcHFacXk4NjV2NU16M1h2K2xpRkxxeFFXNkpVSTNPNWR6Ukoy?=
 =?utf-8?B?ZzhoVW1PdkdaZSsreXN1MEFDVk81SFhsOTg5R2hERGZWbUNUZEZ0cEoveEhV?=
 =?utf-8?B?RElObjJleWxDMzh6YkRTRUZTNVNUcDR5MWFvZGlsZDQzaGJmOW9oQmpGcTZ2?=
 =?utf-8?B?TnZHYSt2UFZCcGxxTktld1FISmFXZEV4dG9ScnkzZDdqbjRDMGZCaFhVUmd2?=
 =?utf-8?B?TURtNHZSNHpTMEJLRHJtdmpseFNjNC94aFZRa1pZU2F3YVQxTW1CQ1FQUGN0?=
 =?utf-8?B?TjZIMDA1elNCakdmSGczVmU0Rnc0OFlSYnV4OU45ckk1MldydUoyeVNWN3p0?=
 =?utf-8?B?aDRtU3RrM3UvZXk5QXdmSk84Z2VSVTNvSWpPU3k5TWc1ekZSZGgvNGpTTkE0?=
 =?utf-8?B?aGFER0xGUWdtMGZPRDVuUUVDa3RraEs1TE1CbVlkOGZFMitxZ2xVN2J2eGwv?=
 =?utf-8?B?YjhzcExJVm9XbmEzcXh1Z2FFV0NCTnAzcHZVQklaRk5sUlFOeEV6UEVycVY4?=
 =?utf-8?B?eXJ1MnRxcWdVb0JmRE5xekJIRkdJVkRSbmFmUzgvclNmb2ZoSHB0YWc4Rnc3?=
 =?utf-8?B?UFdiYnBwaSthaHk4djd3NnpXUDV6UVhPVlhoNUFMUnRhUk1DL01BbDMxb1Vj?=
 =?utf-8?B?QWpWUzUyNE1CUzhzdFlkVHBxaXNnbG4vdUNSbWs1V2JKOGRJekUzUVhnTjlC?=
 =?utf-8?B?VEU3ZkRWbDVnNzg5TnYwdXUwSG1hUU1mL3ZEZVZqOUVoOGhDeS9Lai82Y3NO?=
 =?utf-8?B?bHI3dWo0YUlhNms1YXVNMVJJWHBDVnhVRDBIK1lxaXBob0paaFlCaHBtMk05?=
 =?utf-8?B?Q0Z3Sm9KcE5FWGY5ODY2b0NVd3hxSUJ1UCtVQzRYRzFlUnovY1Q0WWFxQlVP?=
 =?utf-8?B?TVZMNXJZdUJoTlg3RUM3TWYvZHpDUG9JaDVZL1RyQUgrRWRNSjZPRUpGMWxm?=
 =?utf-8?B?VUwrTGRSb05BVXVQYUtKTDVNaXo4blZqWmVIRGdQQURCYmdaSW5pcGVubnF2?=
 =?utf-8?B?b2Z5QjJUN3hRRHFUcjJ4VE1mZnpqZ1QvdTdzR09tYURyUFR0a3lVT3RvNGF3?=
 =?utf-8?B?M1lGK01VVXc3OU1zMGdSbGp2S2Z3ZGQ1cStDSEx3eUVpUzNGY0oxM0U5SjFH?=
 =?utf-8?B?N0YvVHRCNjBxRE42WUl4RCttMGdCeXhEYnEra0pZQXM3L1VzMldwK2pzYjhD?=
 =?utf-8?B?ckpJNFcxYmkxc3pGcmhvWDRvSkhkc2xuWEFMTENHaUt4a0JqbU1adWM3dkRQ?=
 =?utf-8?B?aUkvZFFmRDJvSTI2ajhxR1BWdUZYQkxkNHR1anpYa2loNEp5R2VqdUNFZzBP?=
 =?utf-8?B?dUpmem42dXBNbWo5YUZFb0ZFYnJ1MGY3UDcvNlBReE1hVHB1WnNnQzhGNzlh?=
 =?utf-8?B?MkppYVcya2Nlcmw2Tjl3TWtKenptN1pNOTMrMDI1dVloblhpZUtHb2pBczVR?=
 =?utf-8?B?dUhOeVE1b1RoN2lGaEp2cm95ZUliQ0t1bjVBSmxsMFJCckRFWTZTSUxVT3Z5?=
 =?utf-8?B?Y1JNVi9kRnluTmE5L3EyNTErdW5nNkUwSUpuRWpqQnlPdHJWWFJ5UUx0UXcz?=
 =?utf-8?B?cjRnR01KSjdrVXNhcWhNb08vSnY1MS9IOThCZE8zYjJ6QmlCL0UzMFhUZU5P?=
 =?utf-8?B?VVpOYzNFWXpjQk8vWFB0TFM5eFBIeVFGb3ZxMWNJaTNtd0JoQlRwSnBOQXY2?=
 =?utf-8?B?YUFUaVBPUjVwWDVpVUhEVVBCa2hYbE1ucDlGa1lZZ0xzODFySy8rZ0FMZmwz?=
 =?utf-8?Q?NImILyNX8hZSGIxt92yeobyRg490LOVKTxJWgp2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c32b45-aa2d-45f6-f36b-08d926b1c029
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 17:05:12.6808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hl7AW3zzE8KTOKvLjG12YlNRlx/jmon3gGhAe41uW1iVlbOxxIKZuCVzphiP7biG3veKW+26gz2pSJL+ynj61iwn77gDR5xZj0KFiM0T+O8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4301
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030115
X-Proofpoint-GUID: WlbH_4viG8I4D6gMQqbLyui6jxa4rNit
X-Proofpoint-ORIG-GUID: WlbH_4viG8I4D6gMQqbLyui6jxa4rNit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/3/21 11:37 AM, Tianyu Lan wrote:
>
> Yes, the dependency is between hyperv_swiotlb_detect() and
> pci_swiotlb_detect_override()/pci_swiotlb_detect_4gb(). Now
> pci_swiotlb_detect_override() and pci_swiotlb_detect_4gb() depends on
> pci_xen_swiotlb_detect(). To keep dependency between
> hyperv_swiotlb_detect() and pci_swiotlb_detect_override/4gb(), make pci_xen_swiotlb_detect() depends on hyperv_swiotlb_detect() and just to
> keep order in the IOMMU table. Current iommu_table_entry only has one
> depend callback and this is why I put xen depends on hyperv detect function.
>

Ah, ok. Thanks.



-boris

