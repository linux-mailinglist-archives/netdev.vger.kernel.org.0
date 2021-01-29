Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480B43085A7
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhA2GWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:22:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35484 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232059AbhA2GWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 01:22:43 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10T6EGv3024760;
        Thu, 28 Jan 2021 22:21:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=rFUAEl42vHbSDhzYE/z1STAUuJ8Fzqw8SuNmtViDRwA=;
 b=CtBJPQabG8SyhkdK8vI7+uwsgqarhXmgh8k9hDsHr+qI6+xlv99sVdKeL8KY+/a3dPpI
 Wc1oY9+37KQxJLyT2wWwc36jDuO/hwfupbX/+HJfvtBo053IjHQJwXz2bgBD68qcutkP
 kVjN0SdHcb9EA6FzNpzXXNlRTruhc5mcNHg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36bb34ag7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 28 Jan 2021 22:21:41 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 28 Jan 2021 22:21:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXsicUOGfKqFGFc6CWKLKK2dCNWOY/QLhUSBZv2KtTenMskyUPx0y62NItffBr2prXCMmYduECXwd6AfT6SdGk48xwBGtXhwRY4MHMh8hfSPoqlVeeqW+flgW30Um3or759zs3nPpOL4Q/bpMBG3T7Hdlg5ZbpI6GqNKuJQKmAtfW17r/ITITOE8c0TIeIMOJPnU9ud7GEOtVC/yvu+p1aCjtlsZy/AjzC/Nadf72TfGieCxTaM11ESclRpcrHarhnUa97n9fjgacCMh0PuzmpBQS/HiJWC2RcxuGLi3qyCczsgboK4oXqhS56IX0jfVB6Auo4M7/9+SLj5VlfN5eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFUAEl42vHbSDhzYE/z1STAUuJ8Fzqw8SuNmtViDRwA=;
 b=DgNMriaJLchblLVQxXZ5ytj9r8kF8Yn48t7tdUzrZd5y99lGnCI4ic8co8yHYWKyfpAYVZoxMAD3uAfPBaQoNT16QsTF5K93aC+Js6sYcIUm+52esGO8pQlvThIK8TJUpGzWmtfCGMRzcgXnCQiSlfN0m02NaWVYlhY8x4mDIe4JH7G2LaX/EETYYEVoZZUojABYrkBzN5j/a7C606wCou9xoguPZiLi1AmWSsx55C6xpZ4rE5q5mVFvIVmZbuW+lvLWbvUheIZ386gs/qBMWROyJj14oLe1iEFW9L1axOMmgceNVXbSP1gTj13LvonkAH+OjSJ41CAII2REofumzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFUAEl42vHbSDhzYE/z1STAUuJ8Fzqw8SuNmtViDRwA=;
 b=cmoZdD2JYDzHhPe6ntfkx2qm647wJ7BighuNXDF9lo2rOzUd6Xmr9DFwLnlC/DAaswo9/mlRiN2EJO+axpS3s4Bf2PCNFFGLT3Y/6U5FeAmXVXVrop1uxsFaDXgkegc9kvGtIZ+mkV05gQ1TpWfc2hEjksmVJSdrfjI+TDMlaqw=
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3572.namprd15.prod.outlook.com (2603:10b6:a03:1b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Fri, 29 Jan
 2021 06:21:39 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5%5]) with mapi id 15.20.3805.020; Fri, 29 Jan 2021
 06:21:39 +0000
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com>
 <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
 <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com>
 <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com>
 <CAM_iQpXAQ7AMz34=o5E=81RFGFsQB5jCDTCCaVdHokU6kaJQsQ@mail.gmail.com>
 <20210129025435.a34ydsgmwzrnwjlg@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpU5XSgOjdkKbj01p+-QZ5vUof9eZTWR8c0O_cHkHXVkwg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <58649ca3-7a09-f73b-f8fb-0b8595a22b46@fb.com>
Date:   Thu, 28 Jan 2021 22:21:36 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <CAM_iQpU5XSgOjdkKbj01p+-QZ5vUof9eZTWR8c0O_cHkHXVkwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:30b5]
X-ClientProxiedBy: MWHPR22CA0066.namprd22.prod.outlook.com
 (2603:10b6:300:12a::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1965] (2620:10d:c090:400::5:30b5) by MWHPR22CA0066.namprd22.prod.outlook.com (2603:10b6:300:12a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 06:21:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05e15045-874d-4617-e136-08d8c41e2341
X-MS-TrafficTypeDiagnostic: BY5PR15MB3572:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB357207A3644746AA6E908414D3B99@BY5PR15MB3572.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mum8GAFVeaJAbQ1Ix3g5+SnFue+FRrhK8+qFC2Rn5OX67F5FyLILd21FNYDDa3Z+DiMPfaDxiFeNd8P/wm2b6hIMedcVGOrm6Yr1W6d4Q5oGiAmP9WclG28Z2XH/X+2k8387VyJzka13nZYESF6PVPqHIw+U7pQhYvGiZwXRVrJzCpiWLpdOppcyV1O9ixamJ0WkSU/fqECcEzgGde+Juxl68DKhk7D3W8Zv8Cg0kOQAhOK7pY7w+4GZlPfEmCTXJ0jpYdarU4dKfoub2Kx6pvPWD4ofCMILTia033hrLZSQEMF/i8fCSFlrDEH7LLJUV/qwYPSdxn1hj11RUfnPt2CjLDQNDupptZLxtyvqUnP8TOz0Z4vFihtQcIF0EOfLIVEh+8l+s0GxqYuRA27nu1eW62xSnVxyxFGAaB8xHLlWoSbL05OX8SwvYm80LSKuJNlP0dLQbpHqFDUsPS1FCTnFbn+XuMzXPCxVNusygwHVtPNuR0C2XyYYrK5YeQgKfK1zzymnVjTkcElP3GfSSi/oxKbL/7cOdi1ORdmeeGx1bXM1Ppvw7IJEcI/fFBuPc4udjjqPWEywbdGBeRXpWeJluYWul/aeqHa2EHdhXbM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(136003)(366004)(396003)(16526019)(8936002)(53546011)(110136005)(186003)(7416002)(66476007)(31696002)(54906003)(31686004)(478600001)(8676002)(6486002)(83380400001)(52116002)(66946007)(4326008)(5660300002)(66556008)(316002)(2906002)(86362001)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SXo3UFAycUZ6NGU3ZnNBK0JqRGIzbU5abFEvQm91RVc4R1l1ZUd5NXQxZkhQ?=
 =?utf-8?B?b3dxY29PaTFzZ1RGbVZ0UmQrUmtseHE0bndxRDRyYzM4OE5mR3c4RC9MYzAx?=
 =?utf-8?B?eWEyUWlmNm45QXRmQWpYclFHbzBMckUwWHg2YzRmZnFiV2tSZ0lDWXVvaWhN?=
 =?utf-8?B?MnJab1RseW5CRTdQVzlYQ0FYTTM0SGlBUkFrMEhVRkIyK0tjNGRnaDg4V05X?=
 =?utf-8?B?Z283WWc5VmlLNFdwVHM5djVETGY4NUErYkpaM2FrdHRhNWFOcXB3eEM5Nzd2?=
 =?utf-8?B?aW5tRDkyQzlFS05abm1rdllUbUMvNmIvc3FxaXB3cCt3T212a3duRlVlcWpF?=
 =?utf-8?B?YmNVSFJSdThtVkZ3NVRnLzYrMkJQempPUnpONU5KWEUvYVpiUTJiVk4rT3g3?=
 =?utf-8?B?NU1GRHVkOG41bmIwSithSHlPcE1wNWZnb2VBK3ZaRlFuY3dCM1JpQUJsK1hm?=
 =?utf-8?B?djczU3ZSWi9wTTRSNFF1a3hWMXpjOFo5TGhlN1BxY1VQZjVxZE83Um5kZ3pN?=
 =?utf-8?B?L2pld2ZjNnExTXFQQit6S0JMUXNoYlN4UmMyWXZOcXF1aDgzaUh2N240MWlE?=
 =?utf-8?B?RXRaRDlaM1MzVm5jRFJ0a0xUSkcrZ05Ld3BIeUhWSldYR1M5TkZnYVlBdmd6?=
 =?utf-8?B?V1crd2RJRStDS0dtTXBkZVFWRmFaSm5TdERTL1UwaUhncVRaTXhhbTBFYkYy?=
 =?utf-8?B?NHRtVE95K0FwbGo5QkVpS3VPcXI2bGVGMWpuaTVoUW1QNWlwanc2M1JoV1pS?=
 =?utf-8?B?QUNiVkJpZ29oUHBQNUh0QjNUOW9sNG9pT0Vaa1d1Qy85VEc4N0VnSVVOZ3Bm?=
 =?utf-8?B?V2VjaE1zMkllQnlTN2NrMVlYWWFKZ041TVdBN1Njc0c5OWNYRnJiUzRVNUhy?=
 =?utf-8?B?SWQvOHJJZ04veDdaNSs0cmllakJDaHNnMFNoS1JpNklYNnpYS1hud1dGK3Nr?=
 =?utf-8?B?U0RkVGZIdnNzWWtCSFhBVUZaSTBsZEQzbVlNdERtemoxY3VMZWYrOFlNek0r?=
 =?utf-8?B?cko4ZFl2WU81R0tIY3hNZXNLMFB4b3lyeWNTbE4zRTJ5RkZNdGpwUEh2bXY3?=
 =?utf-8?B?a3ZUUHBDZDZidDFYYjFxUVl1cGpZNU5JUG9RWUFtWDZVVC93QXRRTDJ6MFFk?=
 =?utf-8?B?MjhkanlBR0FEY3JTM09jUFlUSkhCTVVtZUlyZUtpZDhqdUkra1BTb3oyRHI4?=
 =?utf-8?B?cEJZeHpxTkZZRWsvZWtpL01jTGZKMXhQTEp4bk9YdmZ1VGdzWkNzWmJlRTRW?=
 =?utf-8?B?TmswclRVRTVsNmNDQ2pHTGF1blowbk1vOEFod01ZbkZyMjVSdXU3akJPR3Nr?=
 =?utf-8?B?R1E0cGtsN0hWbUlOYzNQS3VESi80NVJLNnRxN3R2U3hZSno2T2N5SERQVWRq?=
 =?utf-8?B?Ykw5V0YyN2JQSThOTHNwZjJHMGk2azc3NXdacWgxVHIrRmRiUzFxcWlDRWVE?=
 =?utf-8?B?U0hTREdjeDh0UWs5VzBoUnNncE4vNERWRUcvWTZpcHQ3eml6cER0VE1NVGRV?=
 =?utf-8?Q?eMYzTk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e15045-874d-4617-e136-08d8c41e2341
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 06:21:39.4666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/mxv3DmUl2+UH1jOgqkcXHizwtAX0CUjw/KPSgY8eoGpi5GyMh3WvGBjdpI/PE8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3572
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-29_02:2021-01-28,2021-01-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101290033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/28/21 9:57 PM, Cong Wang wrote:
> On Thu, Jan 28, 2021 at 6:54 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> I meant it would look like:
>>
>> noinline per_elem_callback(map, key, value, ...)
>> {
>>    if (value->foo > ...)
>>      bpf_delete_map_elem(map, key);
>> }
>>
>> noinline timer_callback(timer, ctx)
>> {
>>    map = ctx->map;
>>    bpf_for_each_map_elem(map, per_elem_callback, ...);
>> }
>>
>> int main_bpf_prog(skb)
>> {
>>    bpf_timer_setup(my_timer, timer_callback, ...);
>>    bpf_mod_timer(my_timer, HZ);
>> }
>>
>> The bpf_for_each_map_elem() work is already in progress. Expect patches to hit
>> mailing list soon.
> 
> We don't want a per-element timer, we want a per-map timer but that
> requires a way to iterate the whole map. If you or other can provide
> bpf_for_each_map_elem(), we can certainly build our timeout map
> on top of it.

I am working on this. Still need a few weeks to post RFC. Will share
as soon as it is in reasonable shape. Thanks!

> 
>> If you can work on patches for bpf_timer_*() it would be awesome.
> 
> Yeah, I will work on this, not only for timeout map, but also possibly for
> the ebpf qdisc I plan to add soon.
> 
> Thanks.
> 
