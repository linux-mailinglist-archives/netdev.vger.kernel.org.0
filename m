Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7F831438C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 00:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhBHXNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 18:13:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64678 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229731AbhBHXNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 18:13:15 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 118N3V4Y019444;
        Mon, 8 Feb 2021 15:12:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zrijGBHNmWMNteFB7pXyHlDFeS0tPeN+LCSZcDN2jKY=;
 b=Dw8Xj3jTJiV7WITOMGTvg0DKl4IZ8ZTcjkWGenyVBtTNUeXo+I9qamjplTEznfdT7rP3
 TAiVndms7cDqqNvEhcLcVJ90I6HN4jrnUKAziT+j6Sz2W74dDWZh2flgXAEEsxouTWVx
 5nLTTVusPh91Z/ZnWyGf1Drpyz1BNTxU9vE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36jc1c7qdr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 08 Feb 2021 15:12:19 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 8 Feb 2021 15:12:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgbSxAYjNjoCPOELV9e2x3Roz3v8gXXmUAZxtyaF4uyVl5Vh1v68q3PdmeynPpPvmMwF+rV54itlp/dxE7vOZc+EmUmc2DG/xrfGyNeXSPAnfz1BppwxxnWjQJDhy27ZYkWh0HGVjW0Kz/4aEcpqnvOC2qf3gYuQ2hTY80hSacZnsnp9ZvTWvgExsvBKK69UgISY2kemMFhN26SLVWjxtwcAIqCkycFvEKwT8r6N9QcIi7D9k5cY4JzlwAGbZA6D10W8TPk3pPrUqlX88hOOv1nhkkt/PFpsOYL5geE/Kqoc0yyeKyyx7tJ1SksVwI3zkrachRVb9ap5qz5zLAFAyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrijGBHNmWMNteFB7pXyHlDFeS0tPeN+LCSZcDN2jKY=;
 b=C88158IzwbhBR30/ZjUofVdvJdiGWm5zJpZtxlzW5hUVhzq+p0RL2orBj3h7goxDR1ILczLrkK+vIoVdjPJppeREF8ol/ENjJqWeNpBXOGffkaU4UVZlOIKXLRjuEtrm6EiY4u8iiQ+Vg1+0hxQl6mcm1SchDS8Y/SKxL2S92mCio7ZaPyr4AhO10jJpdCXm+97hIfHCVdP0dG5452nv5FT4TmPdwfSWFaL32nubqpP1GHm0gJJmHGm8iH0WhNM8YhG6FN3of0KjSN3WvBicdU0P8CE6Olq2dtAJMSEPY6QS6Hb92boTJZ6g6P9HKIV+8YhWs4bU5LObzBYcAPW9Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrijGBHNmWMNteFB7pXyHlDFeS0tPeN+LCSZcDN2jKY=;
 b=GPW1rtbwSFa+w3ED5X3H5N6G1dQquCyZTS4rObEoAvPVIb31YpydC25cGdeyPqatDIUumI8moIqE4mfdUeDy0XwnOe5Rovz06sTd5o7AmzSV6sIsRvUIeH9t5BDYXG26m6VjSDa/LJM/iz1on6p8/YboNTsyI9+8MMtwL7mOMPQ=
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3254.namprd15.prod.outlook.com (2603:10b6:a03:110::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Mon, 8 Feb
 2021 23:12:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5%5]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 23:12:15 +0000
Subject: Re: [PATCH v5 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>
References: <20210208225255.3089073-1-songliubraving@fb.com>
 <20210208225255.3089073-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5286e70d-404d-f968-9694-f090eb8fd064@fb.com>
Date:   Mon, 8 Feb 2021 15:12:12 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210208225255.3089073-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:cb47]
X-ClientProxiedBy: CO2PR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:104:3::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1698] (2620:10d:c090:400::5:cb47) by CO2PR06CA0064.namprd06.prod.outlook.com (2603:10b6:104:3::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Mon, 8 Feb 2021 23:12:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1962c2c-a84f-4f21-d35e-08d8cc86f91a
X-MS-TrafficTypeDiagnostic: BYAPR15MB3254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3254C28FC6AEE52AAC5195B8D38F9@BYAPR15MB3254.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QdfK530u5GYYuAzs5ANmiwWs/gqMAp0OxWfo/iwLZTH4HNnBwmASeUyjuYSxlK5pIRTOSdLqVSGwuMdmAVCMLmy3iEMDJG9I5cP5rE344XHLrIDh/cjJXAfg0wfka1piv1LlLFn8TqpHcRAemvyDFNsb5LRamL4dwUjkdto9RsYBZbBXkF8v5sCj0uyRBerpMjvWJ6N/YLa1vTjzU3D2qdcB/v7oMYJxNSjZcfZwSdevm/AOt/wcc/hNxB2FhJull6gjWi53u8E13M2n8s0XSsgRcA3Bm1kBcuDkAyc08ZryXusecHZw/fiqHwZr1N2I6Yh6iaPUM2HhHwNYhEttytymat5+y/CMeHwQ1d2zSWZkT6sjGErWTaNOKnCf06+YOLXerboNh1j4R+T0BP1H2XNf4VUyluV1MZKqoFdO8rdu/LC/tsq4Z7RxqVkYg9XtS2XVQ7dAHK5iyrWFX/NGYoAejhNnlxDmAxSSe7QZOn3Kw9mZMA83U6ugN2G06EwM/0bPeK1P6OgY3gv4OPxbnjUjE0scm+troz+9ULpWTrabcx67EDHG6Y6HEqUvaiHtPU4NxOWbvxavB60SZSOjI6KL1fg2mOEtJ8c+AtjFeNg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(346002)(366004)(83380400001)(478600001)(86362001)(6486002)(66476007)(4326008)(16526019)(5660300002)(52116002)(8936002)(316002)(66946007)(31696002)(31686004)(186003)(53546011)(2906002)(8676002)(36756003)(2616005)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OGNtWllMMkt5QnFuUjRRUjRjQ2pabnF2cUhvSUgrREdvbUlLMTlscVlsYUJF?=
 =?utf-8?B?TFc2NC85YWZnU3FUMmxwQ3c0ZUM1LzljRDJ3Mk1qMUFsQjdwbm1uWXdXeW0v?=
 =?utf-8?B?eStMamlGN3ljdVdDWldYWTZpUDhPdENGdDZZTzBWR1FqWUEvTlFKNjIwd1NV?=
 =?utf-8?B?TkFleXl5bGhYYXVIdmY5UlhxQWFJTDZRTG8xS1ppeWRBZzJmZ3dJNUExSU1M?=
 =?utf-8?B?L0l4dzNnL3pyOElEUUhZYk9WWVlMVFdmRUlrUGFoZkhFbC9kSFdFQUM0Z1Zr?=
 =?utf-8?B?NmVwVTZxdzZOWkVzTFdpL1Q0WVdWcEVzeDVDVWRPWTdpNGlLSFpNNlVxd1Vo?=
 =?utf-8?B?NjI4bTl3QU1ZSkVvQVQ4bDZnQXVLeE5JdVV0TVFQcFFHd21UY3REWklqVEtp?=
 =?utf-8?B?WnVJc2M1M3BCR0IwREYvT2o2M29pZXdLdG01My84SEpJRklMc09mMlNDWGNG?=
 =?utf-8?B?QjR2UGJYZzBvSEIyTDU5RjRxWEw0b0pKTzlKeG9hNjBxak5nMEVvbklrVnBR?=
 =?utf-8?B?WFc3azVTMGZBUjF1M3FadEdYLzZjNWJ2Y0JaRnRpSzlZclphUHdCb2lZSVpZ?=
 =?utf-8?B?THZaMFBsY2M3QkNSREtrMWZRK1BxOGtQbFE5c0hkOEpjYlBqK1FKOVVpanBm?=
 =?utf-8?B?MlRzaURhZGpTUXVsM0JicmVISlNrMkdWaTI5aGF0K1Y3SzVGc3BibG4zVHZT?=
 =?utf-8?B?cnE4bXp1QkZPVGRkR0M3Tk53dzJEL3FYa0ZtK3BLY3dtdkVPbXFKUlQyY2xV?=
 =?utf-8?B?aUFXMk5CbHdKeEZYTXZqc29hZldYc25RWWNDeGN1elBHNzFRWWZ2UGYySmgx?=
 =?utf-8?B?bW1mc3dXQXA2WkxncHJEcXJBRi8zYU1OaVdJMUVSUTFuVFlQSnBQMGRtNTUz?=
 =?utf-8?B?WG5jTnBhVEdsMzV0NWtvK0NBUXh4K2tlaCtXZXA2R1dzSDhDVUU2Q1RoU3RS?=
 =?utf-8?B?dTNleVpoV29GNlNKN0FOdGlMQjJ2dmUxQVloeXZqeHowbnhDZzVOdGNDOWwr?=
 =?utf-8?B?R21RUEVnU0xYTXZ3ajZvUFpGNisvZ0hVbVNXV0JoMk1CbXZWa0FWOENuUDlL?=
 =?utf-8?B?SmpMVGY1SWZzd3I1aDhrOEpnbktqYnUwbFJUTTFtNldCc3ZudyszREFldEZh?=
 =?utf-8?B?UCtyS0V6K1AyUitGWUQ1VHdtU2h6U0tPcDZ2anpIVS8yWWlsaEMwZ254T2NV?=
 =?utf-8?B?clo0S2poRVRPbkkvTkgyeC96NGxpSDIyd1QwVUdzUkF3MFdtVUlCbldBYmtq?=
 =?utf-8?B?OEU3aVcxMXJoeFZPYkdOZjhDRjkxQnFuQ3QxRU1ic1EzaHk3MkhnRjNqbGpw?=
 =?utf-8?B?T2hmRHBQV1RVNUcvSDhjM2NPeFA1SWZYN1lUMzNHdXdpakcxNkJwY2R1S29u?=
 =?utf-8?B?ZTBjUC9EUm1abUs5K0FFZE96Sk1WdE0zSEdyZ2hibFR1dlU2ejViK2t3WDhz?=
 =?utf-8?B?K3lpV3lrL3ZydXoyNitiem4rSk0xQjVBcUtFaVNNQ2NlbVdZNDRveHRKMk01?=
 =?utf-8?B?MFQxUjIrVDFvcUNHZm9aSGVmV1ozeWxnT1VwWFo4NUJPM3kxMHVqS3VWd0ln?=
 =?utf-8?B?UCtpUFo0TlZOL1Q3dXlaNDdVV1B4dnQ4MVZlQ2JkQTJ2clJYanlINUs5V29w?=
 =?utf-8?B?YWlUcFp5WWVNL0tvOHdycFBRL01ROURNWHc5NHJ1UnZBSUNOVnJTYitHUVJD?=
 =?utf-8?B?VVFlVEtpMkxjOS9NN2xsSmU2NXZkZ2ZRS2ZBTWpwc2o4OGFrS2FKQWFFK2di?=
 =?utf-8?B?TzU0WjdQYXpudWcrZEpMM3hYY1Jwb0swbzNSaS84UUJna2h2OHIyS1F4OUZP?=
 =?utf-8?Q?h8TK92hmkAvuYM2ieNXnUgmoW+Msga4zKJs4g=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d1962c2c-a84f-4f21-d35e-08d8cc86f91a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 23:12:15.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrP6VW8aegSA2d5e4nGdtwIyWeBP1lEV7vCnqur3k0/862hoIW3soc7Wt4AlsNr+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3254
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-08_16:2021-02-08,2021-02-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080129
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/8/21 2:52 PM, Song Liu wrote:
> Introduce task_vma bpf_iter to print memory information of a process. It
> can be used to print customized information similar to /proc/<pid>/maps.
> 
> Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
> vma's of a process. However, these information are not flexible enough to
> cover all use cases. For example, if a vma cover mixed 2MB pages and 4kB
> pages (x86_64), there is no easy way to tell which address ranges are
> backed by 2MB pages. task_vma solves the problem by enabling the user to
> generate customize information based on the vma (and vma->vm_mm,
> vma->vm_file, etc.).
> 
> To access the vma safely in the BPF program, task_vma iterator holds
> target mmap_lock while calling the BPF program. If the mmap_lock is
> contended, task_vma unlocks mmap_lock between iterations to unblock the
> writer(s). This lock contention avoidance mechanism is similar to the one
> used in show_smaps_rollup().
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
