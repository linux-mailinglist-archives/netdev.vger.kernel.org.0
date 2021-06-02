Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E50398F88
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhFBQFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:05:35 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19666 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232602AbhFBQFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:05:33 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152G2fGe024614;
        Wed, 2 Jun 2021 16:02:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FhZo5TqOLCbYFE8dfIq/wsTGIaXUBJx1ifBYy0FfxBs=;
 b=C+sZK792DEg+Pm4h9rvBrh/2zdQHOQuoQRm/do27x7/HA48MmNPxtwD8W8ObfoLMplRs
 /yZ6eNFS2mql4jkDtI9LML+8ktzng7QRgsUU0skT2Cpilxjq3tB5JSchNSY0AKjS8Fy6
 x4De18C4zCD0FAKBKSC5sM2eWIpCkTD/qT3+qcNR26gjxRg3ubY436S2elTPL0VxAt4Y
 KWaaaocDSggOSG6ltI50ME1AyilI0OY+lvTxuII95TCSYtHpirJISkVx6N3q3ow+wwNG
 SEKEigOvPMw29jxVGBOMBgAFSbj56PecqHZUARI1RWzYpMKpes7u4MubXYtMeq6vx/6e HA== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38wx9fra8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 16:02:40 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 152G2duL074339;
        Wed, 2 Jun 2021 16:02:39 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by aserp3020.oracle.com with ESMTP id 38udecap7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 16:02:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJMvBgWS66jGwJGc2xlCo1rGKiYxBBzM2VzGY+HsNEhweBknL+pGn0yBqLdE0ciE3uupEG0vYQ3aPLW19xUYG2XCOfEDxWxGqsk/mo6BuTQWDCw8fmXfNBDJS2tsFq4t5/PaWaBp1LhxHuiYL4KVYUt1gmZI4lC6X9oRNdCfDM4cMyiemRrraoS2SUw6JTuLGttt1FXByTgXxS1Cj+JYIPE2OUd7xm4Mq+IhiGgE9Bk5fJM5SJuv68hAUwThIDKKmkEbZBVfMHBQBiSylIlQ3cOszjQi1mbxkuv1c48tZ5K4RviM8HSvjk2fQDB2QIyqoiGQS8TTcGKCjs+pzor2cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhZo5TqOLCbYFE8dfIq/wsTGIaXUBJx1ifBYy0FfxBs=;
 b=oQAV4EZMJY/pnqtfE0mtTPspIJVNFCQMydHqGvL++XEkzxbi7uFwKMpBuk44f1ipTwBQGXj+bLQXhj8iJfRXjNw9corb+MhK//9uAd9rZVnLBz/fkoMmn7iuF5lUiTeLxWFIWsJbknqMcVxM2zLVMsO81Zji8TUBhmEccsJKuOePqICBGUQQ5fs2bn2I0m/5lcIxiXYxOvmoIN/xWGXaBwgPReu0QtIm58t2ClE7+EvYFfYhEtJhkjiPJfJ+lATlxlFK93aZWmUp2GPEqnDu9L6yLPy5TpNj3+qaG4AWyNUBujNeEcbouQMbw4DH02kQJ3w5RPWPptVTbjos0WjLTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhZo5TqOLCbYFE8dfIq/wsTGIaXUBJx1ifBYy0FfxBs=;
 b=ZY9rTj1M6I4whNd1GbkVOBxUHuFh1wdxbd6A8LmJBy5jwsEXhW+HAaLAo0I0ma/5t2PhXABnTt71WqBdwuKj4p3MYQflGAMFdQdpepmAl41X6PhgdjrnXj2yEiKd9XD4Q7NEaRtmIfXxeNirsm7YT8LJXkefefcn42u7/b4+mGQ=
Authentication-Results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BL0PR10MB2948.namprd10.prod.outlook.com (2603:10b6:208:7b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 16:02:17 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf%7]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 16:02:17 +0000
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
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <d6714e8b-dcb6-798b-59a4-5bb68f789564@oracle.com>
Date:   Wed, 2 Jun 2021 12:02:03 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <a023ee3f-ce85-b54f-79c3-146926bf3279@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [160.34.89.155]
X-ClientProxiedBy: SJ0PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::10) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.103.155] (160.34.89.155) by SJ0PR03CA0275.namprd03.prod.outlook.com (2603:10b6:a03:39e::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 16:02:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e880f785-c80a-4594-9961-08d925dfcb81
X-MS-TrafficTypeDiagnostic: BL0PR10MB2948:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB2948E5F3684F7BB4EF7F01718A3D9@BL0PR10MB2948.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HJL3AnD7x/9PGpxjrgiyQBj/KirmlfRaYrGHtjr3cgyzQIc/Fc0RmeioXFo2lfpVibPJcQ9r58P7xtGkhF4eaFDZreeA0GQ90s3Wo+pmh9ansrYimIOspvJ1zUmXFLKsVaMTfvIw7nhDE90bqdKuAO1MbKrtttn9+W+hQJ2wYgBvGV67tN2wT5g2Rlwp7UK7LjGoeoH4t2WsY4gPxvUJLsiUZP2Af6C6k1pEL2fz8kwEH8UDixN/eFDFI6epDF5tWQoFf1UWvBrmlH1kTXTdJmFAxEXcnvu97K8ODRBbd8cUI82pVSqETJUxbA/Zh0hYTzJ6Q89Y+c52vHkfO77EoH7Rv3pq80qHqlxSLK+ox/f3Lzeu73mgTSy4EqCUB5hMcr3CfcvS5PFrsKLG657V+DeXzCBhfxqtfKPcUzcs99tU+Sb9KVSJm1o+QSBAOtuXoEvctK1iEpYlc9GQ2gIh7hnBFYFYoM0DuzSks2msc9lGrhm1AgVDMhjSrYsEzzvOwY8/qyhoWp86YUnMP637N2sCy5vgZlko6itldn8fwpDjWf72FzXPM7hiRw6bOSYj5bSsbsP7Mdh/6L2zRsrfue3z/e0xUaZXCUo+8mbMKqD1CqHQnRNTIzolx2hIcHcubX9CFOOtoPpzqXhJrLApmk7UvBDbh4wjiTYi86havgHX4l3IH0BQ1WCrrPbqV4/Fo1pXDpm1gduHQQrE+XhLdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(396003)(376002)(346002)(26005)(6636002)(16526019)(186003)(86362001)(2616005)(956004)(83380400001)(44832011)(31696002)(66476007)(8676002)(7406005)(478600001)(53546011)(16576012)(66946007)(31686004)(38100700002)(8936002)(66556008)(6666004)(316002)(4326008)(2906002)(921005)(5660300002)(36756003)(6486002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MDZyeStwMFFoR2J0SEc2bW9rbVR3cm51Nm96UzJ1NU9KNDczNmhNZHZIbnF4?=
 =?utf-8?B?ZFA3TlNzR1dLd1FTTVdqWlZuMXVmWTFjMWZVSTlIdDhFM0FhTU9HallxVFNa?=
 =?utf-8?B?dlcxWGRQaEg0S3RQY2ozTGhSRlpnZTNpUzR2TW83amc0ZVV5cTJkbzQzUERS?=
 =?utf-8?B?Y0VqZXFWc01Rd2xKc0NnTmJxUk5vcVZDemdBaThxVDZwUm1abWxldVE5U2ZX?=
 =?utf-8?B?ZjQzVzk2QVZGVEdQYjdxZ0R3RFF4b2tENEJtQ3hhU2tITUdDTENsaUt3OS9Q?=
 =?utf-8?B?T2pTTDFodXVBNktZRGIxV3AxUElTVDExSnRQa1FHTUt6TGhIcGFNNjVaTjFs?=
 =?utf-8?B?K3g4UmRZa2ROYjlGOWRBYkRWZk5YR1VPRmhlcW5YZTJJWTN3MU5NRjU5b2hy?=
 =?utf-8?B?cDlIeGhyejFxNFRMbDlhODljNlUyVFBDa3ptL2dMd3ZwMmd4azZjZDZjc3J5?=
 =?utf-8?B?dG5HZzd1LzhWOVVpdSsyZjJ1VU43QVdOaFBqdTFLQ2MxZHd4NWpmSjlLcDhk?=
 =?utf-8?B?UmN3blRXWloyT2pDVkRsamlJU0pNWDNIc3dwZ0IrLzd4WTNMWFAxdHdMd1Bp?=
 =?utf-8?B?TXRYclRBWG1xeUlEcHlhVnpDMUdHK0lBL21PZk9KaWZYNmtabmpheDVIMFly?=
 =?utf-8?B?L21XcVJ4M2psdkNEeEcvSmQ3ZW1IbEVwWHo1RmNwUmFUS2RwMHRsWVI3UjBR?=
 =?utf-8?B?aWJUanYyOEFhbGZKMXpCU0FGT3ZSbDNzWFdpcnIxL3hsSkYwSTNvUVc2bnZv?=
 =?utf-8?B?cnk5eGpQbnpTV3R3L011NjMxaTFjTWZZTmtVbWlrNFNnMzN5K0RieFRPcWE0?=
 =?utf-8?B?cXExRmJlWVBNbXhad010Nmd6d0h0QkZWZ1NWeXRqa2dVUG0xRHZaU3NJNTEz?=
 =?utf-8?B?RVRHWU9rVGFDRHVtWFJyYTFMVnNWYzM5Mm1FTnVSTldRY2tEZUphZys1ZFhz?=
 =?utf-8?B?b2tENmMrNWErZmk0V2dQcHlUZi8weFdWbE4zaTEwSnArVFc3eGVVTUJYUjFt?=
 =?utf-8?B?cVA2WlpQYlJ2L2RERzFybVY2dEdBWFlVWTNEWVBKSFh1UytXMlN3TXlSSkV3?=
 =?utf-8?B?MEVBVkkvZFBwWGwrVUVieVVxc2Z3bDBic203bjJKU1REQVN4K0w3T2FIMEY5?=
 =?utf-8?B?a1M5VEhYSE12MHp6SXEzRThWWTRPVkNNdS8rSEFUY3dSVWlrMXV4RXJFNVZs?=
 =?utf-8?B?WWJVTHZTZHh0SVZJNGlYQkZXbEd4OUVQMlE0bGdRS3RCT1pxdVhNNmEyZk5B?=
 =?utf-8?B?WG42VlNqK2MvU3MzYUwvSVo3ZndYZmptMmFqVFI4S3RVNlNlNFZ2RXA3VElI?=
 =?utf-8?B?MW1PTEJMYzQvOG9SM2YrNkR2bWllUXVpVWN0dkdWTVgwNVUwc0dkU0JVNFhB?=
 =?utf-8?B?TGFpVkEzOTZJbW5lSVNhY1JHSlE1a2tVQlJxRFRFMHpqanl0aGk1eFdrNmRX?=
 =?utf-8?B?ZjJXRUpudHNXQkU1R0M5NWl1eFpiWTIrWnRXOU9jL1phcyt6d1JWMzdMUGVa?=
 =?utf-8?B?dEE0eWx2RlBISWo3WWQrRHo4M3hTMGZ2Z1ZoZnRjUjJpOThRQVJ5SjB5TWlP?=
 =?utf-8?B?WjRacEw4L3E5SGJWblVDRHhoNEJpcCtXWVAxMXIyTTJOODh2dmJaNzNnLzdk?=
 =?utf-8?B?bm0zM0gzR0x6MGViS0VPalZNUFBOS2NVajBPQ1dMT2FvS2F3UjdnRzhHS2Ju?=
 =?utf-8?B?cnBkd3daaHR6Vjc0dDhWV0JGRDY2alJJK1ZkNEU2LzgzaDJlWWFSTWErOE94?=
 =?utf-8?Q?gXM4EeYi+eZIPZA3pmX/wNZ1x05ij1DuSnROjtp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e880f785-c80a-4594-9961-08d925dfcb81
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 16:02:17.5711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2gXOzzbZ7MMkWZnLPMBjTsCziTkYJjn8DI5EWzgfUUM3mB9fJXC1BCiBLmVmLPBRFNvBCvRFwdczV3oJioOpqVJxQ1juVJOh1BkAxeEGsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2948
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020101
X-Proofpoint-GUID: D2nKtgwgUzB4I8NO5gn7GykhtJc5Pd7z
X-Proofpoint-ORIG-GUID: D2nKtgwgUzB4I8NO5gn7GykhtJc5Pd7z
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/2/21 11:01 AM, Tianyu Lan wrote:
> Hi Boris:
>     Thanks for your review.
>
> On 6/2/2021 9:16 AM, Boris Ostrovsky wrote:
>>
>> On 5/30/21 11:06 AM, Tianyu Lan wrote:
>>> @@ -91,6 +92,6 @@ int pci_xen_swiotlb_init_late(void)
>>>   EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
>>>     IOMMU_INIT_FINISH(2,
>>> -          NULL,
>>> +          hyperv_swiotlb_detect,
>>>             pci_xen_swiotlb_init,
>>>             NULL);
>>
>>
>> Could you explain this change?
>
> Hyper-V allocates its own swiotlb bounce buffer and the default
> swiotlb buffer should not be allocated. swiotlb_init() in pci_swiotlb_init() is to allocate default swiotlb buffer.
> To achieve this, put hyperv_swiotlb_detect() as the first entry in the iommu_table_entry list. The detect loop in the pci_iommu_alloc() will exit once hyperv_swiotlb_detect() is called in Hyper-V VM and other iommu_table_entry callback will not be called.



Right. But pci_xen_swiotlb_detect() will only do something for Xen PV guests, and those guests don't run on hyperV. It's either xen_pv_domain() (i.e. hypervisor_is_type(X86_HYPER_XEN_PV)) or hypervisor_is_type(X86_HYPER_MS_HYPERV) but never both. So I don't think there needs to be a dependency between the two callbacks.



-boris

