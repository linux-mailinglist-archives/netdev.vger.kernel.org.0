Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E5431438F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 00:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhBHXOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 18:14:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhBHXNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 18:13:55 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 118N6W5R009147;
        Mon, 8 Feb 2021 15:13:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=V0aKH6E7ldm7UoNUrMwUBeIcZBypLWLJTCr1bsuHtTA=;
 b=jaJcaJGe/WDeDgc70F/QVNS/jdht9w2C8W3YeztuBEF5lqRtoCNhT5m5ycoRiPYyg35Q
 eD6ZAjKSWzNGn1q4dOpCrF3kWLX+SPvFVfr7rps1f8SUZUes99p1nC2WRLtAloHS3wi3
 +vv77yE+JXo0rSEorZmsse0cEXlOuzpFAl8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36jbnnypm8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 08 Feb 2021 15:13:00 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 8 Feb 2021 15:12:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3K+2+soqM49fogHg5mruTuCMPaR7iUHADuzMKQz3J3mhFgiXE6/JBuXpCvLajnBsOXqBQZEUFdTbzYg/emjdIceIM0Zgpxoy7U1bgTRcLni6L/LMCZLstN0TqIh0Mf7QsTnZo8JdBLzJMOD8Os24kI6vmKd/GsF2c9d/+SQ2rxYKDu1IAhcBImEKUHXLQCprboOyv7X+pvukYFqwjdlD5p6c/uPT5U8CFe19IZBNKbchNj/LAEWUmetsdTIk3sxn7oG3IuurCFwx2zPkWHpNRGzJPR1nz2zj0hN/iI4zap86QEDLBp20P+JJCORGzdiVKZgu/nucehcIBN7cmzpmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0aKH6E7ldm7UoNUrMwUBeIcZBypLWLJTCr1bsuHtTA=;
 b=GHe1YlFAU6VZMgwcqOP5vszCU2bP+DICRWDwo+Q4XD6vXGX/HwDXJL8ZMXLR+3eElZ3sOkB133Wj/qsFj5HClkqjsuG0GEzLI47b/dsC67EYNgR9aUszw+ZoKwl05qvM1mwCiY6gne9E4dJGvF9t6+ElPdB0YVcClOQD72hqdzL3Eq1Xk+JFkaESuwkC/xgCLFXIor86aI1uiHMCRl+UMkTzsbGlE9tXPEuERTvTU9NoxNy0rBwV6hiLeq8y4kGFqZSREHYjYXOFJSDehQhkD3a+3dGL06ecsjdmGgKJOYT/yicP8Qo37T4Rjm9VyNfDqAF+v4H/01gh6aOrJSmiPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0aKH6E7ldm7UoNUrMwUBeIcZBypLWLJTCr1bsuHtTA=;
 b=GD1U0Jv0CToXIfXEFpcf9dv0IxiHvE43NIxksZcFuE1+PmojAonKeBaEJZD9yagAxU5ydu3vW/jsIc4KYsmJBONTonPNs+EZi1vgm1IegVuQHZO+G55p+/PQYcus3EvACY0REACaffbbVdz09QgfDxGbaKdSdNwYrp91m5WAMs8=
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3254.namprd15.prod.outlook.com (2603:10b6:a03:110::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Mon, 8 Feb
 2021 23:12:41 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5%5]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 23:12:41 +0000
Subject: Re: [PATCH v5 bpf-next 4/4] selftests/bpf: add test for
 bpf_iter_task_vma
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>
References: <20210208225255.3089073-1-songliubraving@fb.com>
 <20210208225255.3089073-5-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <48d4707b-25ac-cf68-dc6f-2d0110a792a9@fb.com>
Date:   Mon, 8 Feb 2021 15:12:38 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210208225255.3089073-5-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:cb47]
X-ClientProxiedBy: MW3PR06CA0029.namprd06.prod.outlook.com
 (2603:10b6:303:2a::34) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1698] (2620:10d:c090:400::5:cb47) by MW3PR06CA0029.namprd06.prod.outlook.com (2603:10b6:303:2a::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 23:12:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5486eb4-0098-4da4-6a45-08d8cc8708a3
X-MS-TrafficTypeDiagnostic: BYAPR15MB3254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB32545F21030A4086557721D4D38F9@BYAPR15MB3254.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a5Vx9p1hblNQGURn1UpVsWLM5fcLdVdit2SEA3wJAdcAg/IYIv65ggLs80dM4SP/2OiAW6Q5WBamlYfhCVz1/DMQYqk7emAKD2Q9riLy0U3eA9/9Yi2d8GU7vZK14WjzDfqHNMoz5SyK255nMmOAvxk0GeDtztv8/Lxh2jkg703m5it4cHKVGTbkPOsJ+E1zu5e6GG7MSEfxAX7uu/n6k80GotPr2KUCqXREWOXmnqqXAD7zyA65a8oUqMzPn6y/WrsUL9LU0am35F/fwsMTskzkaxvxVdUs8zoj+1dKvIW/wxIjZb0D+ONt1dKWGXnis02yufiESApol3kR64+smsFI25neLSxqAPDsaZGthRSHTCXSvmbPt0h3SwnyORgQOyuLEYjBGHE6z/exgKNN8AyzlyrEKxy9OBvh016d1Bu45n44XwK1bor0war1hSuvdt1euKVeI/BdbiMfC/mO3CtKRJMAW0PCLEOVa+ZiA8l2bc1K3vy0wS8Gx4dY6iUHFYlJPuPOQWfUc7KWUJxXDLfyni4hwjdFj+gi6QPni7eg6mfSsFSxnx/Fbqi2ZuR2Lb4MIAMScKS8Va91DwksefbB2QdtK0Oh3oG5ddbkelw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(346002)(366004)(478600001)(86362001)(6486002)(66476007)(4326008)(16526019)(5660300002)(52116002)(8936002)(316002)(66946007)(31696002)(31686004)(186003)(53546011)(2906002)(558084003)(8676002)(36756003)(2616005)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OGV6K0QxWmZxVzgyNUNzQ0RxTXRkTTJ6OVBWRWdlcHB0VkFCNjNsTEdqQ2pY?=
 =?utf-8?B?SWRBbzBpWU9Qbk4xam1RWkNQV09RRzRidXd4OHgzaWZ2Wm9JSDBZdG9XUCtP?=
 =?utf-8?B?bklTWTEvcVFDOER4M2V1anhvUzFOaUNmMkM5SnVrT1FSQ3EydEt6ZDRZa1gz?=
 =?utf-8?B?ckhHd0xrY0J1RzFtdXloOHZSbFpITXhiVjhCWllZcWY3OTVoWWYyQUNJMGFP?=
 =?utf-8?B?VGVFNUt6VTdyM2xFYXVRajRUZ05PeWlrbTAxcWpNSnJralRUMDBtZXVmbzNL?=
 =?utf-8?B?MVVHNktHUGVNblY4ejgyN1ZRcUtxQ1J4MkdIRVN2T0VsNGlBRUdNU2JnYUVx?=
 =?utf-8?B?RUN0dERnN3o1bFBqTExkOFBjNG1TN2ozeEpjakdPYXowSGs3RWJ2QnlaNVpm?=
 =?utf-8?B?QW9aQ1BBSlhDSVNhcmo5VFBaZVIxWmZZakRZUEE2NjBYVDRXazJJRU5tcW1U?=
 =?utf-8?B?MUx2bFhSN2lMcnZkb1JVNmlqTXdqUG9CUTRFWWljQ2xkKzdGalIzc1hQSUdE?=
 =?utf-8?B?TkdCRVVUc1VVVXA0STZnVDBTWHhmZkJwK3pOWXNzVkNCQVZ5SXVVMXZnWGFa?=
 =?utf-8?B?OW1JNWpKQnhNMHRwQnh1dkljeE9QSy9tRWJ3NXFpWHR2M1BLOFpzZng3TFMz?=
 =?utf-8?B?Z2p1ejMzUy9LTi9BZXpXZEtMMHNrZkIxOTdCK3ByMXZUQXFEYnlYRlhEdHhp?=
 =?utf-8?B?dWZBRzExWnFaZDY0YkxkdWRUaDkrUFpOdzk5WW9yR1MxQVZvWVZSK3BLV1VD?=
 =?utf-8?B?R2syN1lXNWJtdVUvUXg3N21IbzJZcVFjdjdDNHgxTDV6dzVVdnFWbEJUUXMz?=
 =?utf-8?B?QnNra3hBUmNBNUFkcEliMXVSM0NMNDVqamdFaGJnVVJxUHF6dE9GemZmcEdI?=
 =?utf-8?B?WFJ3UXhLdVM3bGtHL2NLZGUrSWMzMHd1Q1MrQnNMWHBuR3dzL0QxNnZPQXhx?=
 =?utf-8?B?aVhEMmxBSWJnSndZRHEzVzFWZExrYzQ0L1h6Z3ZRYnFLamQ1THZtYTgwWEFP?=
 =?utf-8?B?NHdwVEJESXFvR2VqSXAvNysyNURCdTFnUXgzQkxjTyttUlo1MU9vc2ZjZUlo?=
 =?utf-8?B?VTJMRWdzOUxTM0svVlFGd21Bd2hudExZTm9ibGdzM29icUZJTWh5Qkw5YnIr?=
 =?utf-8?B?V1FYem4rMUpaWnY4T012WVBVc0loR3JTS2xFdlhiZllsaW00SDU1c3ZialdO?=
 =?utf-8?B?dHF5SjNiS29CY21rTUprd3BpU2ZmVXpuOTZIMUpiV3cxWkh3RlFOakluNGFB?=
 =?utf-8?B?eWtLQnRRS2Q3QkJpb3dwK3ZweGlCSy9ZbmFuQUtKbCthaE5FUW1jTy9rUFJY?=
 =?utf-8?B?V2MxdGZ5WWU1aStpaTIyMGFtQ1YwMlorTUw0c1RnTmE4dzhkaHFwM2JEeHBQ?=
 =?utf-8?B?b1JITktOR3daQ05zbW1NV1ZMb3ZIdDVBK3FiRU9DSHFQdko0K3Jsc1FFUS9T?=
 =?utf-8?B?TUVDMmJ1WVFPS3pCc3QvUGtlOGRnUU5XRVZCYVprRS9EMHBnWWhIbW92UWlX?=
 =?utf-8?B?aERXOWZuOXNQUno1ZjFzQmhVLzBnYUxkRXJUeVNLWUVDWmVYQjJNT25RclJP?=
 =?utf-8?B?eUlPb2l6SkxucE91QXRFL2twTko2TTk5MFdKblROZElTYnFzOU4vbDNDSjli?=
 =?utf-8?B?TzFPZ1dUajBlckZHaG5UUWFOVWgwWVcvb1I3a1hrYTBualhBMFJ1d2dHcTZ1?=
 =?utf-8?B?U0NGeHZvbXZKRXRuL1hmSVJyQ3dydU9pNVRwQlNPZFpScWJXdWNjUTQwNFUy?=
 =?utf-8?B?NzhzNmpoT1RnK2diRTQ5dlBqZ0tZUWhDWnBneVF0MVFVQURLOFoyNzV2Z2FM?=
 =?utf-8?Q?oWHMKXEa+lZliebY1v6QKYk2hZskdtYB+Zrxg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c5486eb4-0098-4da4-6a45-08d8cc8708a3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 23:12:41.1713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +gQZ9smzS/mRKceXWweFyEmAzMA5s1Se6sBKVIMDP/o6N/h6J3ZATJvprZ9te97o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3254
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-08_16:2021-02-08,2021-02-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=895 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080129
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/8/21 2:52 PM, Song Liu wrote:
> The test dumps information similar to /proc/pid/maps. The first line of
> the output is compared against the /proc file to make sure they match.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
