Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E613234E0
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhBXBGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 20:06:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29080 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234202AbhBXBCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 20:02:21 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 11O0wPKN003128;
        Tue, 23 Feb 2021 17:00:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zEXuvjNRuzfts/sFbXCDoU2/y8w4M6rWyfZrT9g7/Y0=;
 b=AGN6sRIB3Ioc7lvPbaCIqliNyfWzu7Yowvst3o6vTzXhygHHGr6W0ELU4360QLmu0z3X
 RYXtvR9lDxOZOzTpJq6zUeiL/Bwi8p9STW4F+bwipLA6dmRsLMUch0UfijzN5cJo1kVz
 shqSIJQiTeyTVqKTk+4LZY/3ZVmSBiKt9W8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 36u0341xcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Feb 2021 17:00:42 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 17:00:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqPtGnh88dRqH/G80Rurepp9to10WnPeB5uHxKEMH0vOKlHlbhYFkTd5v5LGLopm37R+PjkdyspbhkNhP+4DiEFve7LSeDoBxZ1Drihh/04g1MZrAwnEKF+62eXcsBH2xGOrWORAlWIXB4cUcM3yxs3JtyytNeK2jeDw+pfPaZNcdE6zZd9kBl5wm0V6i87m5PzOs6vtP5tSHrC9OAHhHy9V9Cw9eda2823tE+7V7TTsqEXXDZF+pAAeayP+t0DnDzpUAwDgAMggMSB+V+KS04xepKeHM3z203mBsJy3RgIiJ/NfzW9WUyxViKay7SIP40ALwtMmXLHcBLImNDo8hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEXuvjNRuzfts/sFbXCDoU2/y8w4M6rWyfZrT9g7/Y0=;
 b=WsyP110y4FOXSsjnPvdN53Mrwn8WOXjVG6/NlfeIK0ZsaWHpAeaKGj7amoxiJ2zri+F38L/f4r6DyA/wMSw1KmyuxRpmwOI20LbCqtd2finQdTcsCh3XqVAhttSLq03LWXqKAuuof4pBujgqVN/ZS0UnfvXlt4pFOXp2XQEf74jN2rBa8IKgkp6KGmfIJvQkzFoI/SAfz0+Kn0kKem4ofVqFvoc0fvLi+jibDQmyqRIpkpsz8o7B4gcm7OA7fIwDS+URFbJ1cS7Yvy2Uzh0MZca81hHhTZaZ1S4stYt6Ov1EN+21B+zTy5Htgzefoj6KCSSfTVhWs6Lm+F/MLJfRWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3935.namprd15.prod.outlook.com (2603:10b6:806:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Wed, 24 Feb
 2021 01:00:40 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::e5af:7efb:8079:2c93]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::e5af:7efb:8079:2c93%6]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 01:00:40 +0000
Subject: Re: [PATCH v5 bpf-next 1/6] bpf: enable task local storage for
 tracing programs
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, kernel test robot <lkp@intel.com>,
        KP Singh <kpsingh@kernel.org>
References: <20210223222845.2866124-1-songliubraving@fb.com>
 <20210223222845.2866124-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a6779ede-f077-4c15-2c31-a7610cca1ecb@fb.com>
Date:   Tue, 23 Feb 2021 17:00:36 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210223222845.2866124-2-songliubraving@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:5f4c]
X-ClientProxiedBy: MW4PR03CA0370.namprd03.prod.outlook.com
 (2603:10b6:303:114::15) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::19ec] (2620:10d:c090:400::5:5f4c) by MW4PR03CA0370.namprd03.prod.outlook.com (2603:10b6:303:114::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 24 Feb 2021 01:00:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ecaa9be-e43d-4d64-0ea0-08d8d85f9a89
X-MS-TrafficTypeDiagnostic: SA0PR15MB3935:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB39358D8C53B98921E37730BCD39F9@SA0PR15MB3935.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LfjrzLbvHn1bSJGZ4zlKaSvPjag8Pp9Fur5dvpJUIDrrnnzcrnK1LcFJAt8YmS8I7HZqvAm7ZfQXYTpSqwcc94phnGVX7B+4pfpgvTLR+7XcfuMMPb29biwZiKhOfhQ+vgqsfAQhQh1l/1CDJkidQG9vTzGFqhgTmVNMCEUJnhetTnB8AmJ3w08BkFw4uCYFU10GO4lQLgpZcmIjFBAb2eHYdpYQfvi5jr0KbKy8/ZbPub8VFqHHcrgRpSWc2D9MNMZZZM9qGIToh8xYYTnxYV7IbyHdXU6K88roDFIxq4Het7ZW+gLLTUd+fcQkeoQkwdhDZ/zVnTjxUan9TWbsasgm16Mg2fPC82Zdl6HwreTlwjwsSyWtvklgM6rM9sIWxwdl908V160pwfOyizI/f3kGrXI6uyzwKwKrrWqJPbDu2OdGJbURSd4BBnn4+mH6w8Uc7HdBO39hUV80iWIUJwy0bgoEGtcI1mUZX9ET1RmYQggzhYlE1PuJTrC5IqNf7tRlcpeXMwFL76hnNRp05I3glFOHH/6tl9KRaMmTBrkUwI69FsyIVojffbx/87ParK4XYu/wdycV/S03v03pMyDNss2wElx8Xi/pUzYN9JU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(39860400002)(396003)(376002)(2906002)(316002)(53546011)(52116002)(8676002)(31696002)(8936002)(83380400001)(36756003)(31686004)(16526019)(2616005)(6486002)(66556008)(4326008)(66946007)(54906003)(86362001)(5660300002)(66476007)(186003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UlE2QmgvZGxCRHNtZGFTS2NmQ1pWZk5iR3dUSHNuUjhDaEZuY1pBRW84ajJu?=
 =?utf-8?B?bWVDS0NOOUFuTUhXTGxwOGFMalg3N3kvQW9lb0N3V0FvSWgzVmhwNmZ5dytG?=
 =?utf-8?B?K1dmRW1LZFVuQjNvYXpucG5lbWl3UXFuR1VRVkNDdGJEWndWMnBpdmlUNjZX?=
 =?utf-8?B?Q0VvMnhyd2NCOVRxMFRTaFVGRElvcXU5K1VhKzVQWEhwWnUzdWFhSEF2RW9V?=
 =?utf-8?B?YWd0dFUzOEtNT1BySlNZREVJYlh6QTAxY05mdHpqWVIwWjQvV2RTc3lSSWhy?=
 =?utf-8?B?ZEdaWURJZXEzTWJEVlQ2QVpLZnNtZ3NKRE9SOTV6ZW9Wc1BVcGhjbmhsa2RI?=
 =?utf-8?B?RldFbXB6UmtWVEJneHJrNkFQWmxBcFN4Q2lzL2VEQjY1U2o1OWdUczYzMG5D?=
 =?utf-8?B?bmR2N0tSWTVrb2RTaVdjWWFYTjNKTlJ5VUxhU0dBTEp0N2ZMSVdyOXFGOEpw?=
 =?utf-8?B?MFVVQldiMElheUVUd2RwbWozY1M4MVBVMTVSZ2tDZ0s5cmZ3NDM0NnpHZUpm?=
 =?utf-8?B?ZHg1MjcrN2I1UTlhRElYUmZkOTBVQXk1L01DeklYQWZrd0NBNUI1cDh0Q0kv?=
 =?utf-8?B?U0ltUUdiTEhId0w2VDgrNHp2dEFVelQ2ZWUrbkV0eW9vSG1XMVA0YkVsRm9T?=
 =?utf-8?B?N2tXci9vdGdSdUw5UEdJaVpaQThkdW9YTnpFOTR3WERRWUk4NjRSb2dFbSt2?=
 =?utf-8?B?WEpheFdLbkg4TjN1MGZYV2VVQ0N4cWhvUjFmem9neGNrVHVXbE5KZlZUUStW?=
 =?utf-8?B?d2hUaW8zMkNtVm9iU2pjVjNkTDJsT1c2ZWp5bmpzT2poSlRFeE9hU0xYTVZs?=
 =?utf-8?B?Q0xRRHk5TlhIUEFyWmJ6THh6MjVxUkIzN3VCVENrRGQ1YnZrS3ZCWWZaMS9t?=
 =?utf-8?B?R3ltVkJWZGVpMUlOVW9PQjhlOGVaZUljc0J2c1FjTDFCUElFc1dzS2hycWoz?=
 =?utf-8?B?SUNKNlhyT1B0dXM2TnN1SC85aGxFdjlHbFgyTnZIL1M1YzdBTVBBRDdQMnM1?=
 =?utf-8?B?WmFad2NPZmgrTnVCWHVOenR3MklXTXlqV3ArSlVGSitrNW9aaXk0d0diTUcw?=
 =?utf-8?B?dW9td3BaU3lSdlcyY2RUNHJCdGNiN3lXTXkxRjRJbW96eTR1ckxvRzc4RVBY?=
 =?utf-8?B?WGxuZSt1TDdodkZGcmlINit2TjNGWEVrNklNRXZhYmZSQjNlcnU5M0FoS0t0?=
 =?utf-8?B?aXdnWUhCeGRBb2I4YXEyUno1aDJDVm9ENnQ4c2NhVVExU3BkdEZZeVdneEM5?=
 =?utf-8?B?Q1pNYnJVclV2bW02aU5BbjNRQ0dIZVBYMXBkY1JUMUxVRjJieit5bHliSjVt?=
 =?utf-8?B?QTdzcGd1MW9mcEd1dG5KVmZEVVVIbStNS29rRVhRa2xBZWJoU3NJMzFTay9E?=
 =?utf-8?B?bmtoMWQveDlFQ3pJUUNNQjhOZXBpWjVFWWtmNEFhYnhNQkl5MkIwYW5LMzhC?=
 =?utf-8?B?bVBoNWM5c3Z3ZFRDT1VGektiZlpEQmVhWFdwTGpQV3Vaejd2MHBnU1ljNy9C?=
 =?utf-8?B?bWJiOWdrQklhVDBQT2ZTY2syazdHd09vLzBVanZsWnJNc09ia3RrYXJYQjcz?=
 =?utf-8?B?MVFRUXl6STdnSEV6eEl4Y3JqcnRFL1l5RE1TODZtM0VUbkc4RkgvaThLS2ZN?=
 =?utf-8?B?UFN2aWRaMjBRK2plQ0tGdjZ6N3FvT0JxR09BcHI3NW5xSmYvQWFSR0FhbzZk?=
 =?utf-8?B?MTAxZE94Yk10VW9kOW1SeFNNSkw3SStOM2FnMmVhY1F5NTJZMFd2V2ZTRXFa?=
 =?utf-8?B?aldVc2lmY2hjYTJiU0V1Nm9ZL1BybHlCQWZYbVJXbGF5cFNPTUxxMTZuSU5z?=
 =?utf-8?Q?2HhMvAj3pKNTmhQ10FHOJmJb76qO+QQ1HkufM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ecaa9be-e43d-4d64-0ea0-08d8d85f9a89
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 01:00:40.0030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1WfxIgKppq25RtNZC/gtoJqjjEyDpZbdVn+oEEbrGnElFdnXAkY6eFy+IhM/cBG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3935
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_12:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=923 clxscore=1015 lowpriorityscore=0 suspectscore=0
 adultscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102240004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/23/21 2:28 PM, Song Liu wrote:
> To access per-task data, BPF programs usually creates a hash table with
> pid as the key. This is not ideal because:
>   1. The user need to estimate the proper size of the hash table, which may
>      be inaccurate;
>   2. Big hash tables are slow;
>   3. To clean up the data properly during task terminations, the user need
>      to write extra logic.
> 
> Task local storage overcomes these issues and offers a better option for
> these per-task data. Task local storage is only available to BPF_LSM. Now
> enable it for tracing programs.
> 
> Unlike LSM programs, tracing programs can be called in IRQ contexts.
> Helpers that access task local storage are updated to use
> raw_spin_lock_irqsave() instead of raw_spin_lock_bh().
> 
> Tracing programs can attach to functions on the task free path, e.g.
> exit_creds(). To avoid allocating task local storage after
> bpf_task_storage_free(). bpf_task_storage_get() is updated to not allocate
> new storage when the task is not refcounted (task->usage == 0).
> 
> Reported-by: kernel test robot <lkp@intel.com>

For a patch like this, typically we do not put the above
Reported-by here as it is not really reported by the
kernel test robot. If no revision is required, maybe
maintainer can remove it before applying.

> Acked-by: KP Singh <kpsingh@kernel.org>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   include/linux/bpf.h            |  7 ++++++
>   include/linux/bpf_lsm.h        | 22 -----------------
>   include/linux/bpf_types.h      |  2 +-
>   include/linux/sched.h          |  5 ++++
>   kernel/bpf/Makefile            |  3 +--
>   kernel/bpf/bpf_local_storage.c | 28 +++++++++++++---------
>   kernel/bpf/bpf_lsm.c           |  4 ----
>   kernel/bpf/bpf_task_storage.c  | 43 +++++++++-------------------------
>   kernel/fork.c                  |  5 ++++
>   kernel/trace/bpf_trace.c       |  4 ++++
>   10 files changed, 51 insertions(+), 72 deletions(-)
> 
[...]
