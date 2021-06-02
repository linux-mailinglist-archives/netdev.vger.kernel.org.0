Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8723397DF8
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhFBBTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:19:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55260 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229867AbhFBBTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 21:19:46 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1521CclW001584;
        Wed, 2 Jun 2021 01:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kOpUSB9gbHIsvVsRPdwLbfNGUezEr64tyQ3KnDDoIGQ=;
 b=S146tfUEUcrf/q00V1AAkylznrj2SZZOzHxkXqEey+SNG52EGRCk3hgka86LPlhAtsz3
 FVZseRP4hjvotpdIv5k+lWRWBJSQInjya398v/GGOKiOc2PjRT2Ozf9uZE4XcIGXmv1X
 /GrS5qR0FvoR2fm1ZmmnEgORSytKCTmd/P1pTkwFwleOar8zN0K5TsfisbRw578zWr7R
 7wdwM2BzIomrvE5cwMw0ZnSVifh5SWGa58bazHgx2GENb84cW84vPWITcr4rOhigN1fy
 DCIQWCNJlSgGhm3x7tmDn+4ob7IT4yJW8Z8kp4sET0qSShCYpNaaPT47EfqyJYib2WoK eg== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38wu57r33j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 01:17:11 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1521HAbR134930;
        Wed, 2 Jun 2021 01:17:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 38uycru71c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 01:17:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQg5yZ8o35qamd2VdcT95IT8P5aUghju7uPUzK0Q2iVKwhj98hlsPN2TynwSyi+bmrw/vu9AumO8IEpwlk76/wYW8DIvR9Dpac2lWasPktIUg7DkD+7u2aDA91djupKCmiSfiSzeVomAs+hWvH5+eOx346RQ+s6Owt5TVxab86f5UmI2cd40L3p5Zj+O82mJbkC8Hpu0yH4VQ5c0EV0ZlscKORNtwybyO81C4YnK26hekDyopYyPgrMWNcCd1/3yZNt4FOpoI3bChBCpZAA96yv0scOZZjOYGRpi/Xe8att9TvSOiY+uFmbgBuhQUhM6FK8B0ZjPKdKXqi4re71IcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOpUSB9gbHIsvVsRPdwLbfNGUezEr64tyQ3KnDDoIGQ=;
 b=WtwZWKCIOXO8z+RorrbrjBf8zydMIIxmLNfc2dfLd8RwAG8CFsinje0oymExulsWcYY3ZBnLEiQJf4+4gDFk9221ULoTARRoY3OQ6LjPaiUOyTemZxMXGpZSa3F8BqtNwZV/7K+Dek+nu2c/+chJGBDyM96WducAPcy+JN4ajz+e9yWVqoscOOuCXHKTz/kSV7Y+fcTLU4d7FGUz8ZBIMpTq7VwlI7KyEi3AowOYuHWKOEGpleHMRpjjCraxklf2n8jhOIsVvY/ZArw/rInyXMyDm8uSAoKwrVZcgEoC+9CWptu37Xvh2AQqqlzD0hRSpkta+2r0HjdSn4DLtmEDgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOpUSB9gbHIsvVsRPdwLbfNGUezEr64tyQ3KnDDoIGQ=;
 b=cnqlTSwgx8vmeA/xPZfwHhGC6S6q3o/w4/Owx9P0lpDQtDBu0jBgiDUkivG9/+451FlPrYmpuzWC7CJ0kA/clJak+32a9hjlBjqPrJMkcB5dRmrJhl00h8kGpUAFPGXMjCwnvqa7b8hqmfmgtScdvkSmgCh8ojJSDQvGQRXEDpE=
Authentication-Results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4398.namprd10.prod.outlook.com (2603:10b6:208:1dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 01:17:08 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 01:17:08 +0000
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
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <9488c114-81ad-eb67-79c0-5ed319703d3e@oracle.com>
Date:   Tue, 1 Jun 2021 21:16:59 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <20210530150628.2063957-10-ltykernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [160.34.89.162]
X-ClientProxiedBy: SA0PR12CA0020.namprd12.prod.outlook.com
 (2603:10b6:806:6f::25) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.101.162] (160.34.89.162) by SA0PR12CA0020.namprd12.prod.outlook.com (2603:10b6:806:6f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 01:17:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68c80a36-c37e-4ff1-e9f8-08d9256423d2
X-MS-TrafficTypeDiagnostic: MN2PR10MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB439862B7639BFC28FDE1D56D8A3D9@MN2PR10MB4398.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:317;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zJfQJsHlld0qAhP0fn1gEZYyI9G7gck5zysRuZN6Y/16dKSiF8tvRNJSfIqrCfneu2ExH1dZpwMzmxdoqlFwQIes1M5ZtqeIAIiQReawU819xlfuRkh/Tn3k6YePPfMlMrfNsuKIED8zEdAkek97lp/VlBGZlf+tnkpBsCTAXnMN0wfceyCl3caYR5ho3baZn+QtIPEjemMyiP8XrIPmokwBJW3WQCsQT5o1Lb+AiXJEaTwV+feD1BV//5xDGytYmTVYoCHFLuaVZ24zHEzHRzdKAwncYe2GM1NuKtoLWK/qjIIEFcHNpv18oMAwQvKOZzusLlqjyZBibYZMjjhktBCxGlvtfGK9Xs7ZuH1EAWiOgSrhvbAA48ZXOyANurfKZad9rp4eZIxcBdbmkZwj+1jPXVw/uoLesIxqVeThdZqu41RbYMMfM1g913GNireu7DHoYcvGWM6UsGE1uT9VjLaRN0TKyXgmOkB/+xARqcvi/6nxP0XL+S8keK+A1rpUYAEfz6bOL0A1mOavMTFMBlV/XqcwoL89mwHsNLdwuPsPrUlnq/ZvsV34NX5+wz835THxKx6qH7H/UtIgdwXS7PBQg+vxN3swBmyOIdZaO534CEuJ72JRj9X55Iazvfqr71B9v/OGMcakxPhS9gWt80bJ1SJwaf1yBPMXOMzm6yOj3GBP8b20MPQyI110CZFUPbfbFgCDYRQq1666hMV8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(346002)(366004)(39850400004)(31686004)(6666004)(66476007)(2616005)(4326008)(26005)(66556008)(53546011)(16526019)(44832011)(186003)(7416002)(83380400001)(5660300002)(956004)(8676002)(6486002)(921005)(558084003)(478600001)(66946007)(16576012)(2906002)(86362001)(36756003)(316002)(31696002)(6636002)(7406005)(8936002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VlFtdjBKY1lXNDNVVmkxdEFlL1NoNmcreURpR3RTNGRZTXowQXdlbWg1LzZt?=
 =?utf-8?B?WjllVHFBa3lJc1hWakVaRHFRUC9nTS9qY2RpdUZnNHpmWHVpQ2c3TWdkWkV5?=
 =?utf-8?B?TXJtTDNDUTJPRXFXQkRXejBrWEJsaXMwOUZnTkZqNXhiL2pHN3F2S3M2NVI4?=
 =?utf-8?B?ZXV1QVd2MVU3SytqVkdhMUZhQlBFMDV0NndkV2dRTm95NlF5UGNwRnRnR0xL?=
 =?utf-8?B?L2l1T0JMVjFoakFiaS9uOEZuN2hiYWNNNzc1ajRWUjd1TURGUFNhaXRyWFdh?=
 =?utf-8?B?RjZIR3NXeCtGZnRqWVF3MUd5UlhDSzBsY2RpREFQTHJ6TXJ4SUNxWk5PYTJq?=
 =?utf-8?B?bTI0M3Foczlpekp4RTVVWm1TQUgwaGRIVk4zYnV3MTJPd1pwY3d0a3QwanBa?=
 =?utf-8?B?QUtKMGtjWTVqOEhDUUVzc3JqNmZSL1FEQ0hMcTRaa1VZcCtrRy8xSTdsS3lD?=
 =?utf-8?B?ajFWdDNnREFQd3E2MytuN1UzZXM5OUZrZThXY0JFWmRVM0FyazBidS9VZ243?=
 =?utf-8?B?L01vZ3ZIRy9jTE43ZG1FV2dPMDJ0QTNiQkJjejBBZzdkc2NpZFhNSmZtejA1?=
 =?utf-8?B?KzUyRHNZcEx2L3Q0QVVBVm1CYVJVWXRDVDUzaXFUdUlHTGV3MW81MkxGdFhF?=
 =?utf-8?B?L1IvZkRuR0dCUnhTbzJCRGhDTnpwenNqTlVvT0dLRW12eVBDMkdPOWl2SmNl?=
 =?utf-8?B?dTQvMGxVMEhSTEJ5cnZadFFEc2E5YVhWN1djbDE3N2FINXIyL2VaU0dSL3lP?=
 =?utf-8?B?REZuTDJrWlNRL3k2UURCeVZUTEJ4Zi9RYitMdDVub01CdzBGa3RJeHU4MUJk?=
 =?utf-8?B?eUQwVTM2VWc5U1lvbkwyUjI2bGJDWlpHSHVHZmZmSjRqUER1Y3BiRmQvYUVw?=
 =?utf-8?B?cjR6cklESGhEYy9uZXR5UFRiWFplamt6RzdpcGROUXd4czk4b2IrTlp3TkhQ?=
 =?utf-8?B?Qy9mbUc1dytvNHU2OURVYkx5NHd3N0YwcStDZXlVOG5lWTRBUTFDb3ZVUFRJ?=
 =?utf-8?B?Qmc1SzJWVTBBakJLWks5cm9sRHVVOWZsRWVrRnBCVmRtY2IyNXg1WFE5d08r?=
 =?utf-8?B?L3BESzZLTURBYTFmZmZET0Z3aU92UEE5dFY0VFdWcklSLzJDWW1HTFo4dEdJ?=
 =?utf-8?B?a1MweEliQWRIM2NrOXI2ZnIzcGhGYlIzbG1SUDQ1ZXArZ0FBSk1vYndLZU1l?=
 =?utf-8?B?NXppVE5mQ2Y0YTRreUpMaGk3QThFckVsWHppNFd0Y2dtQXZyUEFzQ0hCTVdX?=
 =?utf-8?B?ODlrMnNrNmJhc1NlbzBsOFJacHB0cit0eUQ5MDZ0U21tVmU1UXBhYnN1eEpO?=
 =?utf-8?B?UExNUStIellxUmZXcjY3cUhGNDR1OW8rcnNTSnBKQVM1MTdpY0Q5Snp3cWlj?=
 =?utf-8?B?K2VnenNLWUJtYjVvZmxZWEEwZnVVZ2VZcFhyYTBJOG1nU3B0REJFUWhTMjJp?=
 =?utf-8?B?b1JJR2o4QU43V3RKbFpYQS9FMGNJQmhIdVlQRDZFMFJTWTZFNkpySUlEZk4w?=
 =?utf-8?B?QmczNHdpU1laL2JVKzd6ZUEwL0EvbktwY2h0ZXdPbit0S2ZEbERLVkxURFpN?=
 =?utf-8?B?L094cWJwd3FMR1JSeGJENFlIbUphRTN1REd0eE9iKytqdUQ2bXJiN2dKQ004?=
 =?utf-8?B?WTcwQmNQdndXN0NMZ3JTcVlPSGlrTkRnR3BYMzZRRUJKN2ZTSCtNL3ppL2c2?=
 =?utf-8?B?TGFVRDE0OHBvTUpLWGN2NHVETkVKcXE1TU54T1U5WTdiMkxkTXRubkk4WUxr?=
 =?utf-8?Q?9HOLaLdyfhu3e/onhz1+Tb/Wqc2UJBoJeuHYjG2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c80a36-c37e-4ff1-e9f8-08d9256423d2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 01:17:08.1521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nz/6C1w+Vw9+pJ+4DpRQMclwPbiPzUU8BN0PTxVGTBS/2YSczBYCPFddCeQaRGBQj5M1sqZiq47Pue6LPS2ms+9X9ln9G+20lX843bMVn5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4398
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020007
X-Proofpoint-GUID: li0xUnJntxljGM1WLz_p6SOzZ7ywgiLv
X-Proofpoint-ORIG-GUID: li0xUnJntxljGM1WLz_p6SOzZ7ywgiLv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/30/21 11:06 AM, Tianyu Lan wrote:
> @@ -91,6 +92,6 @@ int pci_xen_swiotlb_init_late(void)
>  EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
>  
>  IOMMU_INIT_FINISH(2,
> -		  NULL,
> +		  hyperv_swiotlb_detect,
>  		  pci_xen_swiotlb_init,
>  		  NULL);


Could you explain this change?


-boris



