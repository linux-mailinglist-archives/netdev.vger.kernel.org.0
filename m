Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8BD445CA0
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 00:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhKDXbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 19:31:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30156 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230502AbhKDXbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 19:31:02 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1A4N43gs032543;
        Thu, 4 Nov 2021 16:28:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jfoA4QNtckE5AIZ472gMKnTz9MR4Z68QdvEBK/qriC0=;
 b=f1hvOSWr2N6aPBWDDx2d1r3t8n3b5GzhujH3dfnF11Fv/SMnC4toDfwaGrPSCS52lYbj
 aMgkHq82kVxz4MJz4Zk5OtOoh5+wnpohbpluGQuts5pspG88blG+8OYv5tDWyj0yWwVC
 NwgVDuoJRqBNoC/tNjUEbVWm8SEg6kzfNJs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3c45wqgeg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 16:28:09 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 16:28:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnrPWYhPItYgCQv8Z2uGdZJeGULzGUb4+f4EQTUGiBU5WX7bfJkcf0rlxlkhaZxBYnE+CwnV7zlImB/PyGMp1L+EZZh2uGOohfJ/xN1jNAuNDM9mD7qK1e7KUpTzbw9+XAWvuCUdR6qKb5+b6CU+xaC5dl6GXEUPnGAd275mLpWJSATmzuNIQxuGwhbnrgQzGNqfRV+PIRhcLUAasB7jflmw9rQ4NSvAWdG10l2Ooc5JmiZ7vdiHko42UAVXi3bqenaihFvKq5yiIGBUT/NapWodq/RKv+Wtq/LWbBHEDzUwRd3rfGi5vaXC3Wp0/EdDss/OrRQQVi8LxYjf1nLcog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfoA4QNtckE5AIZ472gMKnTz9MR4Z68QdvEBK/qriC0=;
 b=C9RB8PITO6wXjZCwRkiNJ/Kteh3Zu+jSkuwH2BKmKUma+L1D+LpMzOFD84CGjlY4+hOrKJFnx+LuwmtS5W9LzMsWYp3wLhUd5+JWVGKx6Rx0Bbtg1kXwht3jPUOh7kvdQ7jQVdSucuSPMyi/vw8ClmtclwC3rUpVPWVJSH+tm2pJ7JtRnKL2jzPyHg8FoxyycOLFBsm2It/4YLpt1Clh594m3gambsNr0iUo8d7ljau1hYOrPhv/Ox98BeiwtWDPQxXihZCjYXj2BQ1TlKN0gHElH514O0d6w0+8AKi9uGxoUNKBlAdWiuZSZ67L0o12kZvthV2vf+wf4E7ydkjMLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4918.namprd15.prod.outlook.com (2603:10b6:806:1d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Thu, 4 Nov
 2021 23:28:06 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 23:28:06 +0000
Message-ID: <46583fe9-ddb5-78c5-63c0-5338563b8ab1@fb.com>
Date:   Thu, 4 Nov 2021 16:28:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <kpsingh@kernel.org>,
        kernel test robot <lkp@intel.com>
References: <20211104213138.2779620-1-songliubraving@fb.com>
 <20211104213138.2779620-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211104213138.2779620-2-songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR2201CA0040.namprd22.prod.outlook.com
 (2603:10b6:301:16::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::14ee] (2620:10d:c090:400::5:1851) by MWHPR2201CA0040.namprd22.prod.outlook.com (2603:10b6:301:16::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 23:28:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7887fdf6-d356-4de9-c88e-08d99feac143
X-MS-TrafficTypeDiagnostic: SA1PR15MB4918:
X-Microsoft-Antispam-PRVS: <SA1PR15MB491861CD3CF377F9688A7083D38D9@SA1PR15MB4918.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UbZf9WkT3Z8xmGIHnsGd5LuXxP43oxDar4cC0621hJivuZFpc4RqDwdtcY/+EvNQQSJNaNqTJP6qZ+VW+qg4I31rd4etoJ1VlS3CeBHHeysjG5ozR4d7RKGxQdxWGLVy2W68NKOIjLFYdhpO8gQKyNUvl4G7uSk9XF69iFX0takSA76L/XC38hMyObCEPVOLoli6i/w4TX/LJ6HZgU94SpLm8zHSH8F+g2JytXO6Q+4s35DDQv09hEFI0k4ELss75zGWkcicsjCOuhj8LghEUOKkwQSeGPQKo9iVRqyF/MZjPTG92t0J9leK/2Y1vuaNMf6fSFtGOJv4WjQ/hM0wmTDPe/DObo9nal77b/D0vy7hNC7hiWCjAyEu3A9G/QmCDILIHZtvDfcJYtvoWW/ZCstZP314BG8lU5ymRV4iUtNdD8nKWE2ElfAzUPWOSHMgDMnCobqv73W1cHc1hAsIM5Rdfg/A+PAG0k69m0upiovrTEYWpcm2/zru1s+kVqsHtzN7Wx2OFuCI2cOUC8ugvx1dhNq1OnmVSo1hxMq7hCO88UKqTAK0vF+Un5L4rt2bAOX4AUjOue3HjvKwOOmlgcsiQxKCCR6LNDXt7zo4xLT/B0Qg1Eg7ubMX/M7mLvruUwCwbyLokNnbkA8TjyAMd617nojdqN4mki15zcK6oQIY77pngwI4NYiPSzKroxvzcd0IGltM9cpsnxDGtbZjLCgdmOBEmBRMKl248Sezytz8I6QQ9f9/aaYjvva1V+KH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(31696002)(36756003)(6486002)(2616005)(4744005)(8936002)(6666004)(38100700002)(8676002)(53546011)(316002)(52116002)(66946007)(66476007)(4326008)(186003)(2906002)(508600001)(31686004)(83380400001)(66556008)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0UraExkWW9uK1VHb2h4YWN1akZnYUEwODZLdy9NMWRQR1paTW9Jd0xVZTBn?=
 =?utf-8?B?V2hVR2g5cDF4Z1Nqb3RMUVJhMWY3STRWdmhyZUZLU3FvYldSSW9QNFM4YnFD?=
 =?utf-8?B?bGE3Y2RZUEQ0YmdBRWFaSXliUFNJaDlmWVRkdGwxKy9TcWtGWjdpaXlUaEFB?=
 =?utf-8?B?VUZSaFBQSThucjY1Qm9RNFY3RWNHdlhSM05qTmVKRzEvcEZwRDc3V3hIUXV0?=
 =?utf-8?B?WHdiU1RRV0RodEFaQkhKUldWYnpEVTRRWWMycWs5bHFpUzFyTGpiWDUzL25i?=
 =?utf-8?B?VkIwRkc1d1VyUUlRZVZhaG5XZmZoRGFPekZ6ekxPcDNibE83T08yaDVURHZa?=
 =?utf-8?B?cWVGcmxDdVJob1JMZDkyKzA4QldPRVQ3R2dYbjZRMDg5UzB2K3V6WWVCTFJP?=
 =?utf-8?B?WjAveUNPajVXaUxaU202S1hieEo3WWFORkh0Y0NDZGk0M2dvM1k5R2wxRW94?=
 =?utf-8?B?RzZpYkZGOXI4SlVEVWIwTWRycjVzOXZ3UmU3WU9yenRFa0JNVTF2QXVtcStn?=
 =?utf-8?B?YnZ4MEdWUlZwMzBLeUhVcmlrV2FMSzZLbjJQL0ZsOUE4ZEY5UmsrTk4zNlQr?=
 =?utf-8?B?d3pGWllFTURXU0V1MWVHQjgzVGp5dXMxTFRHRUNJcUdOd09FQjZ0bnZSaFpO?=
 =?utf-8?B?YzQrVHNjNCs0REhmeXBWR0FMdXQ3UXI2NjRsOTcwOTVIQ2JKNSt6SFhhK1hy?=
 =?utf-8?B?ZnBzRHR0bVYrZU9FT0EyRCsxdFNRRkhSRWtxU3pOVXJPbnNIeEdqRW5vbDlQ?=
 =?utf-8?B?Mlp5MkpidkZRUWVRSTdEb3RoTGt3YWVWZzBrZS9jank2UmVROWlKM040OTdX?=
 =?utf-8?B?WkNtMGxuMVNVN3cxLzBXR1Z6RWRYZEJWTFpwNWMxNjd6dmhxdXRxWkJBdzdq?=
 =?utf-8?B?KzhLRnR3VWkrV0twRys1S21vUEZnbkdIekZ5MVFzWDRpVDBEWDNORXlGZDBa?=
 =?utf-8?B?blBaSGg0aHpMOVhpU3lDMXU3M1pHUmpaUUp4Zmd1UUxIRHM4dVhmOXM5Zkwr?=
 =?utf-8?B?cXIwUm01eFRINlV5bzdjc3NGeWNZNUN5Uk93QmRiVGV3UCtpcTkwQmFRYTcv?=
 =?utf-8?B?cWNheWNuN1BnNjVOdSsxVzBSVVFIMjNUVVNzSEppYUZjRGN0ZmZGZ2NNdzBX?=
 =?utf-8?B?RTVaekY1YU5VUVZKcDI1TUN4b3dxZDZub0NOOGJvT2doWEJQNklRejl0MGNS?=
 =?utf-8?B?cXc5U2h2S1RsVUVzOGFHYVVnUm5VOUhURzZEbDQ0ZXA5dTdWWTZJT0pvSFBo?=
 =?utf-8?B?Nng1K3pEcGNtT29vb0hBVGo5NVJwZ1Z4cklHMGx5TURnZzdXa3ZXcGNUb09K?=
 =?utf-8?B?YTczNHRidUxjc1BIcDdhMENTTnRESWt0Z2M0WWpybmd0a3pxR2ZkMjdXWTUr?=
 =?utf-8?B?WGlQdW1uaTlNSWR0TEgwZ1F1V09nbkxFbnNjY0N0eEhncFQzME1tMEpmb05H?=
 =?utf-8?B?RWtrSHNjYUZ1d2xXZVpCVHA0ckNpeUh5d045bUtFeUlWV0l3WlYxeWdOdE40?=
 =?utf-8?B?UHFkOUx4RVROUlVROG5XMnpScDZjRHIvZ29UUW5ZVE1HbGpCWWhLeTYybWh6?=
 =?utf-8?B?ZVBZSndZR012ckY3akx5TlJLNjNycXhtRXc1aUE4VHBmWVBiSnhsM2lveVBy?=
 =?utf-8?B?aVVncUtUNUhmeHhGWUtWUnZEYU1nbit0dllxQ0dFVDcrT2VBZFFCNzNYSFZk?=
 =?utf-8?B?T2Fkem5Pc0krMzRMWTJLMFlkYXBESmxLdnFPcDI3Y1Jac1JLSXRJa1cxeXV6?=
 =?utf-8?B?aVNSZUc0TFY3M2xaVTA5VEFFN2Q2VExleFpYMStUVlJxRVU2dDR1TGZWKzBJ?=
 =?utf-8?B?QmlNamFrcUQ1a0h2Q1VIVnpONTRFWWRHc1B4UFg0aGdHazM1K2l1YUpmZmI5?=
 =?utf-8?B?aVZ5TG10N1VLa0lqMUE4WUczd1lCd21idWZzbFFJMVgzRXVCWW1HQ1F6SE1l?=
 =?utf-8?B?aS9BUzhONjl6SXZvVTNXeklGSWNXWFhzeG9DWDFYaDQ4UFltZU12YUt4NlJp?=
 =?utf-8?B?UUo5d01mS1BNenh3SUYzRTQxQm9JRFYvNGZJSFF5bk1yNnJ2cFFDZzB4YVhs?=
 =?utf-8?B?clhrbkJFNW1rb2lISjBtNW8yTEl6TXY3Z3B0VWppQW9SamJ5L1UvVUpLTUhj?=
 =?utf-8?B?MHI4UktRMkJFYTg2bmdpU0wyQmVOZW42MG5sWExVd2VUN1pXOXRGQ3cvbUJk?=
 =?utf-8?B?T0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7887fdf6-d356-4de9-c88e-08d99feac143
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 23:28:06.4393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ka0QMOHo4snRkHb+TSmKFYCOv1vwWVmtvSJmYRc8Po4tkwGlrwUXkWNlQ/LX6tSV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4918
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _1Zkz7kj3PQgGzLcyEqTcJKHEruLHCy5
X-Proofpoint-ORIG-GUID: _1Zkz7kj3PQgGzLcyEqTcJKHEruLHCy5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_07,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0
 mlxlogscore=948 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040091
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/21 2:31 PM, Song Liu wrote:
> In some profiler use cases, it is necessary to map an address to the
> backing file, e.g., a shared library. bpf_find_vma helper provides a
> flexible way to achieve this. bpf_find_vma maps an address of a task to
> the vma (vm_area_struct) for this address, and feed the vma to an callback
> BPF function. The callback function is necessary here, as we need to
> ensure mmap_sem is unlocked.
> 
> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
> safely when irqs are disable, we use the same mechanism as stackmap with
> build_id. Specifically, when irqs are disabled, the unlocked is postponed
> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
> bpf_find_vma and stackmap helpers.
> 
> Reported-by: kernel test robot <lkp@intel.com>

You don't need the above "Reported-by".

> Signed-off-by: Song Liu <songliubraving@fb.com>

LGTM.

Acked-by: Yonghong Song <yhs@fb.com>
