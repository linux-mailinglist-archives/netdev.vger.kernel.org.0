Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894653699E5
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243695AbhDWSl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:41:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243442AbhDWSl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:41:26 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13NIPd3S025193;
        Fri, 23 Apr 2021 11:40:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Mo68E+fPRR1yX4GJomSNTkTuZMWkQvFFBL5NMqypJiI=;
 b=F0ZogRThhp3+0aVm7tEthz74FTSKc3fYJW8V9V9uK8KRpMiX+J0mhqrDkgaweKr59dlj
 zUW6FIuV7Bw+GsCpZin/YI2NyL2YRaTfEOJBh/I/JnJBjei5pkfkKzDCyd1elJm0sNtm
 +Atec2fPsJAII4kQZYT9ZkULumFp75axTZA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 383h1unqpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 11:40:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:40:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmx2adeHMmoPR6LFWMv+X6FxiC5V0Sr4N5rMpL8F7rDOYQ7XmQo04wW3vX5QKlLjqjBKX+f6pKjlA+YcmUQ046QZjnoz1zwihq9abQQEE7jdt1tOT4BMqZx/BnjDv9ldaDSHHF1hUtaX+ov8bF7g6dLaW1R++XozVN6sNoJ0J8Q2cKteFaXJBqqWjBctlmwMF2dJKKDrfq1EkYSg0zLr87GTHsP0FlBWfDzWVFqvvfEdi7HLNYN46mC0y/KBP2yAqKCh3OJTVht12xEUpM3ADUhZliVXpIYxGuyDVBL9psnLLJOPlpGGldZ9go6Sal2H/nngZOuvfhuE6gxvmeZRUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mo68E+fPRR1yX4GJomSNTkTuZMWkQvFFBL5NMqypJiI=;
 b=efycjuioxdRyuGalGxqVIIz9zP0GWfbcR8QlZM3CzzKAWVjfdx9YUQOddsSGxsCrfNr9A+UV2UdQPKgzBoYJa9goieSI6/8ew7oagsXtIqaVzOm3C03jgDlcEwyB6899Anbcy2zGJKR5cClnSnMVtcnq6Wq7tuHq1e7ixT6EDJo5he/j5J3RHE3S5XCePSerOBNB+MmFILCAT4Pg7I13Dkv2ViQ9roaLBwovhk6zKYu8/jmTHC6nBzEQ1dAxFQ8i6Uov4A7Xx92o0uUljmnIfZt74X26K8wQsGkUGJHnk9EFq/DfPVlaTNy3WKF8x7iFnvEzYzISiiWLeQi02IyYLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4340.namprd15.prod.outlook.com (2603:10b6:806:1af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 23 Apr
 2021 18:40:33 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 18:40:33 +0000
Subject: Re: [PATCH v3 bpf-next 10/18] libbpf: tighten BTF type ID rewriting
 with error checking
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423181348.1801389-1-andrii@kernel.org>
 <20210423181348.1801389-11-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e6a92f39-11b4-86fd-b2d4-e1bf008ed4d0@fb.com>
Date:   Fri, 23 Apr 2021 11:40:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423181348.1801389-11-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MW4PR04CA0323.namprd04.prod.outlook.com
 (2603:10b6:303:82::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MW4PR04CA0323.namprd04.prod.outlook.com (2603:10b6:303:82::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 18:40:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5246b510-b1b1-4313-7ee1-08d90687473b
X-MS-TrafficTypeDiagnostic: SA1PR15MB4340:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4340710348830CB88F76FEA2D3459@SA1PR15MB4340.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PwGKEmcK/oTGlkvo8ct/lW6jxXobfNVW9G8tRnfOkuDsDckBxRlcFVg64B4M/95W6FIMfVzdK+mEVCRk1uyv1GrJwiv8jp6NPOfPjqoHgyTvDnDYHj23gtjyBdp6V0u22q8/0vUbo5zWGByCaB6cQ0Jb4VFW/AqQ468fkRzZxu7FMgt7kQHgN5g+cBzvcwQiNGP2aok7U4Lm2EQ9/5KM9nEZ3roG6NZCK2v6ZxP2PiF/IwS9cyxDs2xEm9etWgDJpwbPl3atm3PhSTBn//rt0zWMcy9LEY/VYgvtAndHfxaqvi2rmpqcgPPNS7tWb6/hDNS0uQ090rbjXj7kCOpDoPxEumwQ+NKOEN7pFGvCqnd20cOtgMBesOmEiqscAXVYHZs/LYx04/P52rwpv8o5hmCyARDjnn7toJVyKfhB05FnoW4IGLsKIOu2YtRVYIf0CQA1etmEZY/0kGYMYqtrlbJpbQXDB/+eKu+J9f9v+YB8DiqwGaB2gz+3qcMMe0+4yqXvOGZ6u3s7nVUD9JPA0DIvrlY4Chs0pcqFr9A9GwZEHgoacnhfBMqqExpNCuIgrlS6Q9Yl0G2tgLRCMXQD1OThu0lp3acVi3Dm1cgvfnZLOlMiNKF8uvje5F80iq+2Y8A1miE8fKQ38XgFjQKmgs4YyQVaO1B7BtmscLXtx3AKSgpqft8YU6fQFk6Qkuvc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(8936002)(5660300002)(186003)(36756003)(31696002)(52116002)(316002)(16526019)(6486002)(2906002)(4326008)(66946007)(478600001)(53546011)(66556008)(86362001)(31686004)(66476007)(558084003)(2616005)(38100700002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aS9WbXVxcHhTV3ZFdThEUHIxcFN3bkl6SlQ1R28yTm9SU3J6bHovQ1Q0bzk3?=
 =?utf-8?B?bjE2QXVCUnp3TFVLV0JkVVNlYzZIdkhEKzh4OXpDbHF4LzhGT0xPSG1NZEZt?=
 =?utf-8?B?UmlZYjkydFFyL2NheHlGeDhWRlFsYit0V0FhRm5EczlnbThrakdLR1E5cmds?=
 =?utf-8?B?OXAyYkY0R0R0dk9UZXZwUkhEQ2RrQnNsZlJOcDJoK2s5RDdyVEpaaHcrL3Zp?=
 =?utf-8?B?OWZWTXZZOFhYK25hTjdnemx6anFvenhnQVR1Wko0ZWg0ZDNWWEx3WHBmOGtt?=
 =?utf-8?B?WFcrVEpKSnp6Z01ZTmlNUnJPRUVjZFlZTDMzUzNoUzFFTkU0Q2hlV05nSGFy?=
 =?utf-8?B?UkJOQmJUaW5TalBkbU5HM1dhNi9NZmw0bDZxNTZPdzhyQlE2UFhvZW52bWZ4?=
 =?utf-8?B?LzFsaUxsNHYydmhHYWxjeW9HdGxjaGxvRjc4WVErTzBWZm9waFl3UW9jL2p1?=
 =?utf-8?B?M1loWlRQck5DZlFyaEUrZnpua0orWFlPN29Jd1VDTVlVaGhCUllWcmt0Skhp?=
 =?utf-8?B?T1V3ZjNNTlZIYk9VcU9jQWo0ZUVOMXprVC8rcTZodGljVmZiME9wOHZrR1lm?=
 =?utf-8?B?ZFd5MWZrZ0haRjVwQW5tQUpNb0pkUUNWUTRGWld3Y2VCNUt2WlduSmtMZSti?=
 =?utf-8?B?UExWVXV1Zm5lQ2tSMjAyNG1QazlhNTNhbGFOQkpaOWQxWWlXVFBCUm1ZcHBR?=
 =?utf-8?B?eVZpQWl4Qlo1ME5FSXZjR0pVSHdGMFcyL2JGOFhaamFibFgwS2tmT2ZKT1pI?=
 =?utf-8?B?SkhWQ3lEUnE2Vm9lb3hRZ2pRS3pvT2ErMjQ4VlRzM1loR2lLSTRsRTlJc3A0?=
 =?utf-8?B?bEV4SENKYlhuc1dQWXl1cVZDUXk5U3BCRUMzSzBrRGk5RDRpV1BBYnBJc2RS?=
 =?utf-8?B?Mkx2Z2g4dEtVemhUZmdpTmZoUXp5NU1yMFg1T3NQeXJvL0w2UStzZmxSN2xG?=
 =?utf-8?B?YXNQY3dqMHAwczNiZWJzd3ZsM3dJZ2R1andScUxNbkhxcGhvOFV2bkZjZnVI?=
 =?utf-8?B?S25xR08vWlg1K21LOTBDakVUZ0FPQldpWnZ4MnVHeDUrUkRwNWlRU1BrVTBL?=
 =?utf-8?B?WXhIMGVwQW5OeWg2NEJVMmxnR2tkYTdLdzVnMlFySXVSNk1nQzBsWkR3bVEz?=
 =?utf-8?B?Qlo4VlFQNDI2ZHF5ZFoyd1phZ096RytyVnJQSWFieTJOeWRzZ054cUt0cmZT?=
 =?utf-8?B?dVBzWHBtR3g1TFJhejhiSFdFb0Q1VVF0d0ZibmFMVDVRbHI0UEpyd1M2N0ZS?=
 =?utf-8?B?RnFkSHlnMU55VGw4eVRBUUN2YWpINlgzdEpPdXFocm5IWTRZSEU4QWd6WFI0?=
 =?utf-8?B?ZFQ0aTR4Q3ltdk5lZklsY2dGaW5zSHh6aEFpR0dxNzVPaVU2R080K2RaT3M4?=
 =?utf-8?B?VzBNY0dNY0tKM3l1anRWNW1OT2JRbUJxK3E4ZWRUcHlaSUc4T0c4K281QVRi?=
 =?utf-8?B?WWtJSVZHSVNtMVVMNVVHL3l0ZW92YjV2R2NFTW92ZXo4M3Izc3BCc0NjTFdL?=
 =?utf-8?B?SlQwVEg0UjBTZlQvTlo0RUtydTlkTEVBQmZVdzBxSjBuZWVXZWNxcCtMWnlF?=
 =?utf-8?B?SUY2MjRLekl0YjNMbXdSbXVsOEo2OXFwRXVwT082V3FGeFZ6RmNKK2dVRnFn?=
 =?utf-8?B?OWdxbGpBNEVEQ3hFY2RabkVSNlZUN0gvT1BKdmtoeEtGcWsyN2RzUkFnUVNW?=
 =?utf-8?B?RlZBeTBhS2NQL2dKang4Uk1BVktuY2xkUVBjTmJhVHgxcjlsSU91MlZra0Np?=
 =?utf-8?B?c3dkbHc4bzBqclYrY2FINTFnYk5keDFWR3dkT0hBY25OcStGM1R6VXFVNG9v?=
 =?utf-8?Q?bZ/lS11q05Vb7RCf7MFiTQv17zTXiL4jWfsE0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5246b510-b1b1-4313-7ee1-08d90687473b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 18:40:33.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyVU1vrqWeY3CPoSII2I/WqcVHune3rKgrl3xOzQqakfGOh1CXnNX3eMXqNp45mP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4340
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ZMnN5LjQJwPA1HuxhaD-hGiOEjRFVvun
X-Proofpoint-ORIG-GUID: ZMnN5LjQJwPA1HuxhaD-hGiOEjRFVvun
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=980 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:13 AM, Andrii Nakryiko wrote:
> It should never fail, but if it does, it's better to know about this rather
> than end up with nonsensical type IDs.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
