Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424633D9900
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 00:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhG1Wnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 18:43:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40086 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232073AbhG1Wny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 18:43:54 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SMFeqQ004559;
        Wed, 28 Jul 2021 15:43:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EQT4i6w7NaRA4jeY67l4XgHfk97OavUeI9X7cCSVWTs=;
 b=KpFvTcMYyZ5oOKOy/OMuUjA0curtZaHKdjYeL3C4EKd+AN91B9A9Z1S8eBHQooqUxl12
 515zd8Dxxn/Hd0PmPTOOJISTi0PSrVECPnw3qAdCi4i8XbDvvJMIq47TIlaFdyD8w2QN
 FSBVnKUudjf0LkC2uM8H3zDgSzlAETa+iDw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a39fvjsm0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 15:43:39 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 15:43:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrjgfsSsQs10w6OBpaFNQgh7naOCL1WETuAsnaylC/F6QMIg8k1eb6ZZsmI5pO3QWG+hPjSPWI1kmE/BhGAuqhy6E5IioOtcsXAToWVB+tg1D4FIbl66h9cxYodps6xYe/HcqA7g5J/H/gPVxkhc0OHnkaU5tM6HW/9RsotxjsbRPAb0sQ+HkcmqYyMFzvStBuzt8s20b40EJT5QcjRWf5Cy577Wy2PFtxTzht7dSL8bIy75Qc26PGGFcWG7NYABYnPSQNiZ0DLzBwE8+6hNObGY8tu8RK6WTbG5j9e7vJIDolZTwuIEASmOxZSwOC0QZnnqhQuVUULP5CYU202WSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQT4i6w7NaRA4jeY67l4XgHfk97OavUeI9X7cCSVWTs=;
 b=QC8cJwtzwD9s8gHRC7Tk69LNwYBgFdzk7DZIinUWDsBfO6QsILyDfa2KypKsCKSCqRLi7YY0BovuWOEDmkwbg6nvZr0tRvhtzIXNbPRXyHpnJ72eHwjOZbtdqzEGg7tIqnW+D/34a/JKTqxCGI/Wd6Mown6LTV2CZzsIosxyDGmR7WcDSKCIm3zzqjeOp+HjTqulWMo6tSa1qftEKDhQS0D2A+F4S3dbQZ5tzvf1FV9E4FpYsxuoqIbZBJXZs6z5jHGk4hqgwTXURYfokCslxI8NfBoFZ/g0bPQ9C1WLkif5wSrV6iXPJlKqRAV2LbPdtQ2ducvwJQ5zx13ZrdAodQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by DM5PR15MB1770.namprd15.prod.outlook.com (2603:10b6:4:4e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 22:43:30 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::b0e1:ea29:ca0a:be9f]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::b0e1:ea29:ca0a:be9f%7]) with mapi id 15.20.4352.033; Wed, 28 Jul 2021
 22:43:30 +0000
Subject: Re: [PATCH 03/14] bpf/tests: Fix typos in test case descriptions
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-4-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c4833129-bea0-d5bf-82d6-1c819a4ab301@fb.com>
Date:   Wed, 28 Jul 2021 15:43:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-4-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:300:117::33) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by MWHPR03CA0023.namprd03.prod.outlook.com (2603:10b6:300:117::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Wed, 28 Jul 2021 22:43:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f816e70-f67e-47da-3fad-08d952191f8a
X-MS-TrafficTypeDiagnostic: DM5PR15MB1770:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR15MB1770F585482F638AB23F3C10D3EA9@DM5PR15MB1770.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zAJ7bd2XTcNVFEubwu8tp8BZsnAPoFeOdTpoX3jqq7zPtUpF+5VL+EIjivbqgT+GpbomdbNAGXBcv1VKoYIfQ5VoP4jKxfB7C47EIhutyFR3fq1muCbCfXeVAOpe8Xg2ydWD8pbtGFr1zPuTM2xG7u/dr8URWuZM7TIxtY9oY30Upb5OnV2ajFWZx8Cik6x85RTxfqujUe3EO7+55hpvd8Hv8+n6rszHNs476hRU0SIZX0TNe7f4Lz3jPPpjyt+/SKJzmgVvKdiOa4h+ig+4kKPFQHgQCG1SaZ+dvPt26KbL8BY7h1NmEry88Wj0GlKVuB2vYnbIs8fwK3j1+jfyr71fI6Z5RfFGqNAn+B9xXVDoiOc9ufUWr5DkM56QiGF49xBOWRPc56w6Tz9vlCe/plp3EKgY7+ry79jiurhnfLacnbi9C66y9IC+z4bMwpll/wOVeKlgudCC2sgXUHt5IJQF4EXGX8a2HRJeofn2e00tRzTAdCw9n/RlCH5qnG1eKxJzV6/E2in66NBgjw5lpshm3C+VMeKAje0xPBuqm65dhsl6SrKkLZXXxy1VVMcoGAdpi7q1kRQ/PZjsNUUDLyoRjaWjZ6GHIaW28m5LO3YRfhJmnST7Ws3K3cfULpF+7P+jbL6KByHgHKIoAoDyN/gq35K3UwS9+gNx0YrmP+etgcUqBRPoU9ZnK08XNZUvTANCGEItxqt4528lA+6nuXOh3rFCMwOzwTJJZGSKKcI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(31696002)(53546011)(66946007)(2906002)(316002)(6486002)(8676002)(52116002)(8936002)(66476007)(4326008)(38100700002)(66556008)(558084003)(186003)(36756003)(478600001)(2616005)(31686004)(5660300002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXZnQ0p6V2U0MS9jT2tXVkpDa3hIOGxOTGR5MWoyZ1hKK2tNZzNEaVdzMWdt?=
 =?utf-8?B?T2FVV0JPd1FhaUdqcUlVT3YwMEtEY3dvUXFzRVVDejlQc3NZZy9mS1FOV1hq?=
 =?utf-8?B?by9oVVBDbFFjT081QmVCZEkrVU5KUVVCNHVUcEU0WEZOUzR0SjQva1RGamV2?=
 =?utf-8?B?dDlaYVc0S1IySit4K2M4MldTekdpYTRGNVpLa2JiNXY4R1pvRUZXcFRuRWR3?=
 =?utf-8?B?UDBOWEVuc05zQndsalREeVNCOVcyUEwxRmdWa2dzMXplbEx5TnFBcmxFd3Ex?=
 =?utf-8?B?YStOeE13ZXdiUlZYalZDWk5GV1lKUUtvS3BPaTNQOUxieDJNWjRZdWwrSFNQ?=
 =?utf-8?B?RGQwWnozZ2dpRFU1YjJCM3FrK25Vcm5QaWdYRzE3c2s5R3NaSDJoaktRYThP?=
 =?utf-8?B?ekhjRjBYSk9waUlhMEtEYnJpY3d6am5wRDRBL25YUjNHblBkczg0OVhQL3RZ?=
 =?utf-8?B?elBVWVJqWWZ6UGV5Q0RMSHZ6NkFDcExVVlV5UnVYbGJ6cGFqRzFNSWVHSHh1?=
 =?utf-8?B?L0p3U3djcnFJbEFUZlNSRTI1QVFqSWpRUDFwSk1LeVQ3dW5qbXpNekI1RWxC?=
 =?utf-8?B?SHNwajQvZWFtNG5OamxaODRCL3V4V2RyRkhlSGdqa3RIaWlueFNsQXNiV04z?=
 =?utf-8?B?WGMxN2NqaEk3VXRWcFpiVEY4NlRscmp3bTdqRVlpMHV5dWpKQ2dMd2dRT1JY?=
 =?utf-8?B?eWI3UmJCSlE4ekx5Q21pQktBRHpabHlNM1NJN0d1VllMNW1RRkkxWXQrVlYw?=
 =?utf-8?B?bk80QkN1QlBpSllzanVja1A0d2pBcTMzVktaNCs2RjhJNjlTSmk4b20ybTda?=
 =?utf-8?B?WkZEN3FaMGYrNkk0TkVNb2FPWEVrVWRHOHVtVTFQUGxVWGo2dEsrd0F6WVZM?=
 =?utf-8?B?Zm9tb3NEa0F6MS9jWmEvTVRuY3hnenlwd3RIRTduenppY2hrVnBZd3JGZzFK?=
 =?utf-8?B?OUhrLzR5dEljdU1EMnVKRkJPcEtHaCtWUTNrb0Z0WjUyVDVQV1VBcm1ranZV?=
 =?utf-8?B?VFhQWFdZc1lTU1RzRllTa1JmVUx5b2NFU3RWMU96akxZV092eTA3UVQ5eWVI?=
 =?utf-8?B?cjZKSlhxN0h1VDJ5ZnBNYjRFZjNWUFhTaEZoYnNOamtxYk4yUmZrWWJhelpQ?=
 =?utf-8?B?SHF3eTZxeGVHU3g1UHovZSt4TmpCY0I5eURROFA5OWF4MmJXME1iczdocnhO?=
 =?utf-8?B?YkxLc0lRL211akg0eDBZbmc3TnVMQ3Q0QmwwYWRheFVuc1RqWFBnMzNybHdz?=
 =?utf-8?B?bk9yN3hPRzNETm5KVmgwQW5WNHA1dXpsczR4K1lJNWRzdEQ3S28vVXQ5dmkr?=
 =?utf-8?B?VmM3Y2YvVWNZQTQzOUI3Q1pjV1NPaFFJNWw3U2U0cXBNQlJ5WStEZW1FcUVH?=
 =?utf-8?B?Mzc2OE9mejVjb2dDbHROSkNtYWZ6M1N4Rkt6TDNDeTVtbW5IdHRNb3Z6RTd2?=
 =?utf-8?B?dUVuVHBGdEtGdFlJbTR0MWZGN0t2Tlh1RFd3ZFBLVjRIeEhWTTVFRjJyNUdj?=
 =?utf-8?B?OVNrOEV4d1o2dHlBbGs4aFcxTTBQMmpFM1BkRUx4NVlnTkVtMkxjMWh2ZHEy?=
 =?utf-8?B?UmJxMDdqd1lSQk9NR1ZVam9wbkVrOURZVjE0Rk1LWkIvMzNOdGFvWGRPeWZH?=
 =?utf-8?B?UDJtclVIWWxRSzROakRHZWVIUGJHSjdnYTd6M0pRb2RSRjNQemdWR21YNE93?=
 =?utf-8?B?VE5TUWVqQnNFZjZOR0s1bVRBTVdsdGhrblZTTmlIM2VNeXdFMUVtNitEa1VM?=
 =?utf-8?B?bFV5cmJFMytVRUpKb1lHMllYOFdLT2YxN3pETXhqZWxtSEFWOHlWNmFIMnpY?=
 =?utf-8?B?bE9oV0gxdVlVWU96OTFrdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f816e70-f67e-47da-3fad-08d952191f8a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 22:43:30.7829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9zHR8sEvj1UQLCCv50JOGtkUVuG7stOkdxHp/dFGS3ILMM9D7KC1pnDF54z7DOQ+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1770
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: OOXZxsP2jOeZD6yHFX5dowcCeJ0IJetd
X-Proofpoint-ORIG-GUID: OOXZxsP2jOeZD6yHFX5dowcCeJ0IJetd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 mlxlogscore=970 spamscore=0
 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> This patch corrects the test description in a number of cases where
> the description differed from what was actually tested and expected.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>

Acked-by: Yonghong Song <yhs@fb.com>
