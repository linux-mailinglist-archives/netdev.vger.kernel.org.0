Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F911CF8A5
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgELPLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:11:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50396 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725888AbgELPLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:11:54 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CF4oi0026049;
        Tue, 12 May 2020 08:11:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gYbLCmeQlSIHNH7cV9xysahbwNS64PO9+yNHrRdxKKA=;
 b=cMVxbyytaYT+SWAkCxRjiErk0xTS2Pntr5dQnAm+s4egouBqjk6BBOdu4GzyKuDS7lSX
 jWGSC8lTJoghcT7w863GPJ4AVSa4ljFZ/WERH7tlgcIhKmi9zNKuyW7jqCS7Vu/r8ulP
 sojLWjKOZugqurbU02QsqmdizRPWLiyNXI0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcgscyuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 08:11:41 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 08:11:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2ewRldBfYdeUnNwg0E4nDTtCrs5of0VEk5P+hXSeIsow8GMDmJd7/1wAq5SXkwwx/XQf3dKZALHCpm2QIR2rC/b2eF1AQ+IX928RXbNofO8JA8qI7CxFY3wTrqM+2CauY80AapOzmyFeHcwJcVtvU0YlfiNupU5KRak/7h2BImJuD66RhI1IAzqR0aeIqm4sSGoYCRtVUTilwcFt3fGAKkeEPYZbFiZSD2ao/9WEjT/GEu/PDq0asIVkzgDzvboJwGcTEprFxSkuuTjWdpSsIX1+57KW2X/PWgIEjZfKdGXE+tkGltCsonJZ1b7F5/MjrKTTFgKgdrsquqMwCAgFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYbLCmeQlSIHNH7cV9xysahbwNS64PO9+yNHrRdxKKA=;
 b=O18ATnGsLsNoHm4CoGI81EDh/yzi4YnWwTy2gzmDMvk1yM+1EZmqoHrpIj1GugxuJJ+u3ZsUjnb3g9WKSWtoY7OAm2m6t8fzBtN9xOTr+HpTlE0VIF6zhOZwf9+9DxNhDEeMA9rKkSTKz093Wpa5YHbLpx/ry31miTasXHi32Ad1bSCp+ggE0T/KnTKae4d2T3TUexKS/uR/lSYqCMN2f8CKACMx74GmdS2p1UGWSaP9wLOkPKJWfuh8zTN/ECTejaNeohYF8+NuD0uwLGx/J5SN2M4r4RzX8jyCxJBKa4+Miwwr7W2p1R90JfmzG6rJTpnWu0Uq4eDqtiWTvone+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYbLCmeQlSIHNH7cV9xysahbwNS64PO9+yNHrRdxKKA=;
 b=ELyLCG9nBn6HFrHwrKsY+Pc38P3Aa0Bo3qNLY5Kpq76MxtILvcwvv/RxeSg3yl5Vdh0UA22gp41HgZgjyWR3L3IMqIxZ9Z3xGocQn72/eZbAFY8tRImJigAI47PJ9vOoJ2u+UO5EqLHhHQxGVWatlaoUFLyU1vRtBm94jqavYDw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3432.namprd15.prod.outlook.com (2603:10b6:a03:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.35; Tue, 12 May
 2020 15:11:36 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:11:36 +0000
Subject: Re: [PATCH v2 bpf-next 2/3] selftest/bpf: fmod_ret prog and implement
 test_overhead as part of bench
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <20200508232032.1974027-1-andriin@fb.com>
 <20200508232032.1974027-3-andriin@fb.com>
 <c2fbefd2-6137-712e-47d4-200ef4d74775@fb.com>
 <CAEf4BzaXUwgr70WteC=egTgii=si8OvVLCL9KCs-KwkPRPGQjQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b06ff0a8-2f44-522f-f071-141072d6f62b@fb.com>
Date:   Tue, 12 May 2020 08:11:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4BzaXUwgr70WteC=egTgii=si8OvVLCL9KCs-KwkPRPGQjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR21CA0008.namprd21.prod.outlook.com
 (2603:10b6:a03:114::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:d0f0) by BYAPR21CA0008.namprd21.prod.outlook.com (2603:10b6:a03:114::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Tue, 12 May 2020 15:11:35 +0000
X-Originating-IP: [2620:10d:c090:400::5:d0f0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f31b7cc6-77c5-4bd5-7dd1-08d7f686c377
X-MS-TrafficTypeDiagnostic: BYAPR15MB3432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3432E5BCCDD890D6A57E15B1D3BE0@BYAPR15MB3432.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLXln5IkPBlwgMqPd0GDDGeqO8u2c0ofGk3VPjsht2+oyBUrQQ1hros8WthRMSK2ZXuhS39SPwDg2pPLo/dG568tuPCAp+gehpgWc0K6cJeIeIpg3uUr0wScje1S6QlqDo7ZkxdaAhf6m5iojdL1OKS7Jbr7E/lpD2OVurMB9rs7WDElYE+8FL8+KKuQIeVPP5uIVCIIAMNZNc8NJbG0fsDi8AhAjPUtHSxipkvwIITgpobi0znM0INIIy9qfCElq4stYgPcT6vJ9QyhaAM/2M4mzJVXZA5JS8rMhUnLPDfo3Oomqxdo6zUF154xKOHjbzny/uip/7ieZOfOYV8TqbKy7D1R6grUqRY/FNnFAF+g9KUQouZnUpyfoCs9OJiXE0J1OeemNn1jagJT/e7+815OSqYaFKyHUHbu43r0/tjrpODfZR6YXvWXvlKTClL+haCbzOOgmCW/FpU3CrqcRVedCGiTAcHry4LiyfenqSEfmbDhSFfg8ADvfCv7pd61rrao7WflFc7Vti416WcYIQ1uTFLaEupBWezlGXSVMWcawxn23UAvRPmq1Zl7Or+E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(396003)(346002)(376002)(136003)(33430700001)(186003)(6506007)(6512007)(66946007)(5660300002)(66556008)(6486002)(4326008)(478600001)(316002)(66476007)(54906003)(52116002)(6916009)(8676002)(36756003)(2906002)(16526019)(8936002)(86362001)(33440700001)(2616005)(31686004)(31696002)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: MzbrHlkVkiZ/L7ffGhME0ymGXLR9laKk63dUjOrHCXic6YuDQD1SAZltFXaB42wSZ98tSpfOHz0RwW3XsA6nsuKq+K64ZOTeRx7EAhpa5jOn3HLN7lG5Zlti1KmzYVI3cdR0fJ5uGtxqr3Ive/yrvrQ9iLceR9ISNJaXx3a8HRTwuKhj63FZJ5bL2CFHQv3guIhhoUckAFRnCyzdvfH2Hw6ku8t5X+bN6SU/Mexi5g4cFjojCFMHNA5LRPwUlksNQmbAY7qaUpR/CPc+EvUSUoiDxCqanOEQhRiOMcO7aE89IQBR1MvBEd2LFEUT1lf1YEbAFKXv3Wh80nyrkF+ogOVLLKHMNQmXNhDdAjqn3cQY8eFAaFoo8xAVg6SrISPJssE9kSEZQPHK7RbOdHAqBo2ElIrnRfoRk+yt8fFyliiDFKwDY5AKgdPCFuN1ZGnw2XOsUAhZMy1st7bAkZuhTeLgwGvwksU27DRS1UL+LqbKgJpR0puXB9H2X+9qbFUjCE1rx8pqnMgBLcD1cKBDjw==
X-MS-Exchange-CrossTenant-Network-Message-Id: f31b7cc6-77c5-4bd5-7dd1-08d7f686c377
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:11:36.4711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrNPwiNhSaIINtGIHbln/rOi72eo5erBWNh2zYYcqmWyNssOysdDSRHkFP/vIaLr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3432
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_04:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 mlxlogscore=794
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005120115
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/20 9:22 PM, Andrii Nakryiko wrote:
> On Sat, May 9, 2020 at 10:24 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/8/20 4:20 PM, Andrii Nakryiko wrote:
>>> Add fmod_ret BPF program to existing test_overhead selftest. Also re-implement
>>> user-space benchmarking part into benchmark runner to compare results.  Results
>>> with ./bench are consistently somewhat lower than test_overhead's, but relative
>>> performance of various types of BPF programs stay consisten (e.g., kretprobe is
>>> noticeably slower).
>>>
>>> run_bench_rename.sh script (in benchs/ directory) was used to produce the
>>> following numbers:
>>>
>>>     base      :    3.975 ± 0.065M/s
>>>     kprobe    :    3.268 ± 0.095M/s
>>>     kretprobe :    2.496 ± 0.040M/s
>>>     rawtp     :    3.899 ± 0.078M/s
>>>     fentry    :    3.836 ± 0.049M/s
>>>     fexit     :    3.660 ± 0.082M/s
>>>     fmodret   :    3.776 ± 0.033M/s
>>>
>>> While running test_overhead gives:
>>>
>>>     task_rename base        4457K events per sec
>>>     task_rename kprobe      3849K events per sec
>>>     task_rename kretprobe   2729K events per sec
>>>     task_rename raw_tp      4506K events per sec
>>>     task_rename fentry      4381K events per sec
>>>     task_rename fexit       4349K events per sec
>>>     task_rename fmod_ret    4130K events per sec
>>
>> Do you where the overhead is and how we could provide options in
>> bench to reduce the overhead so we can achieve similar numbers?
>> For benchmarking, sometimes you really want to see "true"
>> potential of a particular implementation.
> 
> Alright, let's make it an official bench-off... :) And the reason for
> this discrepancy, turns out to be... not atomics at all! But rather a
> single-threaded vs multi-threaded process (well, at least task_rename
> happening from non-main thread, I didn't narrow it down further).

It would be good to find out why and have a scheme (e.g. some kind
of affinity binding) to close the gap.

> Atomics actually make very little difference, which gives me a good
> peace of mind :)
> 
> So, I've built and ran test_overhead (selftest) and bench both as
> multi-threaded and single-threaded apps. Corresponding results match
> almost perfectly. And that's while test_overhead doesn't use atomics
> at all, while bench still does. Then I also ran test_overhead with
> added generics to match bench implementation. There are barely any
> differences, see two last sets of results.
> 
> BTW, selftest results seems bit lower from the ones in original
> commit, probably because I made it run more iterations (like 40 times
> more) to have more stable results.
> 
> So here are the results:
> 
> Single-threaded implementations
> ===============================
> 
> /* bench: single-threaded, atomics */
> base      :    4.622 ± 0.049M/s
> kprobe    :    3.673 ± 0.052M/s
> kretprobe :    2.625 ± 0.052M/s
> rawtp     :    4.369 ± 0.089M/s
> fentry    :    4.201 ± 0.558M/s
> fexit     :    4.309 ± 0.148M/s
> fmodret   :    4.314 ± 0.203M/s
> 
> /* selftest: single-threaded, no atomics */
> task_rename base        4555K events per sec
> task_rename kprobe      3643K events per sec
> task_rename kretprobe   2506K events per sec
> task_rename raw_tp      4303K events per sec
> task_rename fentry      4307K events per sec
> task_rename fexit       4010K events per sec
> task_rename fmod_ret    3984K events per sec
> 
> 
> Multi-threaded implementations
> ==============================
> 
> /* bench: multi-threaded w/ atomics */
> base      :    3.910 ± 0.023M/s
> kprobe    :    3.048 ± 0.037M/s
> kretprobe :    2.300 ± 0.015M/s
> rawtp     :    3.687 ± 0.034M/s
> fentry    :    3.740 ± 0.087M/s
> fexit     :    3.510 ± 0.009M/s
> fmodret   :    3.485 ± 0.050M/s
> 
> /* selftest: multi-threaded w/ atomics */
> task_rename base        3872K events per sec
> task_rename kprobe      3068K events per sec
> task_rename kretprobe   2350K events per sec
> task_rename raw_tp      3731K events per sec
> task_rename fentry      3639K events per sec
> task_rename fexit       3558K events per sec
> task_rename fmod_ret    3511K events per sec
> 
> /* selftest: multi-threaded, no atomics */
> task_rename base        3945K events per sec
> task_rename kprobe      3298K events per sec
> task_rename kretprobe   2451K events per sec
> task_rename raw_tp      3718K events per sec
> task_rename fentry      3782K events per sec
> task_rename fexit       3543K events per sec
> task_rename fmod_ret    3526K events per sec
> 
> 
[...]
