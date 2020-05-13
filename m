Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5505D1D042D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731873AbgEMBJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:09:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35070 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728131AbgEMBJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 21:09:29 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04D18xT1023992;
        Tue, 12 May 2020 18:09:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=F+MDGLqR50spxlMpXDdmDMIiS58yh2WhKGf3PxxpvJo=;
 b=iF6SJaW2lYH5cAzHoHTES7f2RJl7lleVf87mGkIjU5bmLAbPi3V5iLObJSFez4MQjt/c
 4FILusXhV75aGRtrFPO3vPqP6I1xGJ0zpDKS7S1UPHg5gOrrrRelZy7K/pRIlFppXZQZ
 sPEUKuvZxMaMmFqMjlWYEEQN4XXH49Dsb10= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x21xkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 18:09:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 18:09:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhSuJMPxYOgM3/l3fiPwrXpRw60oJJUxwjfUP1MEnF9wc3w0Yd9lzOR/qBeBJLS+g6QMpkWkgB7msee731ZjDM3Jkb7aGxiYloknu/A7wb9dI75+wG1DvZm2o+Wieq7blILNC8Jj7XEnct40lqGVQJVeCtvgSGJTj95PPrfAzGEfn/CawtL67nQ88hc86C8A+bRK23lMkypCaJsSbm6Airp4svhhJlydfckCjLN4/FbjvQ0qXomNBSmAR2lQSieBk84zx/NUg+bYzOdugHtTZ9ymJAmlxcOGSLzAwfC6+ohV1ekloux0oqeaz8F4lOVeAQfIF4u2it53OHIjqz8Hsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+MDGLqR50spxlMpXDdmDMIiS58yh2WhKGf3PxxpvJo=;
 b=LZTcOAKKOPdG9eN8S8j4V1QnPip4xT7TgxobNhJNZ94GUg7KdFlVkUlTsxgybnvKcollCVRtFSKXTDNn+VpR+qX3it3l7T7EwJanGwCF1aeRwNJ3PYKPP23dTkJBRYE1tjITmtaWhMF+pAt95SloH0DjjrZTz0mDx82pxrjIXrMqXRfTuc0/sA393HuQ9MaXIY1rkzlYmA4vXMSXvSVs3U1fufSWoEcUsFh1w15RffJFIzg/22VPh0fU4F6W/fOjYnM0HbJirQfUBnoMw56TAGBJjSVPdhzQhuW/bDvbtz6jM4k5JO7MAs50km1Bv2v9QWU179NM5Alv0b/vncljGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+MDGLqR50spxlMpXDdmDMIiS58yh2WhKGf3PxxpvJo=;
 b=OwBgc/zK4zYnfFlFFCCdhMHZTztS9HGUUaNsnstIaWEHw++rlGiy0qwt3nWoLodR7QpimiF0DMKbodyMNUrI2z+JytTvuVuBwHTrEJP+fQkHC9i448rBzUjivcdOgSLSBcRqrFtDdTEo4q+jksUjHYECL8FLOSmDSud5f+5eqd8=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2757.namprd15.prod.outlook.com (2603:10b6:a03:156::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Wed, 13 May
 2020 01:09:13 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 01:09:13 +0000
Subject: Re: [PATCH v3 bpf-next 2/4] selftests/bpf: add benchmark runner
 infrastructure
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200512192445.2351848-1-andriin@fb.com>
 <20200512192445.2351848-3-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <65f234b5-0c97-2925-f440-d43a9a9afef2@fb.com>
Date:   Tue, 12 May 2020 18:09:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200512192445.2351848-3-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR16CA0001.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:dfef) by BY5PR16CA0001.namprd16.prod.outlook.com (2603:10b6:a03:1a0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 01:09:12 +0000
X-Originating-IP: [2620:10d:c090:400::5:dfef]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d24781d-eafa-44b2-59a6-08d7f6da3fbb
X-MS-TrafficTypeDiagnostic: BYAPR15MB2757:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB275779E6663D0055FF9C2969D3BF0@BYAPR15MB2757.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rjQb54wfWkCkBDQQdef0NiyUYZMw8vtAIOU4EyV19srsF+eIpslHAJVeT6kptNMpzvAfHRMFO01HLNxj542uD0vdV1hYoFFJ36+XB7YTXWVgXk4vJVfkgVzkKK2uBmEwE2i84vzvuxMYnECjSa92jK2EBK6jPW2XFFllokkDlV0lXTGH9mkwWBcLQbu6Nk5y410cJ8+9wVZn6jDDdFd5++x5TzPYxfjPAWhXrqUpfbQp/pYxkznqpf7ThGtHcKBrwITjE6l6nlcEQjWE8Vt/4LB22jQw1o8lOtRlW9y/Na7WLxyqdtxA2EYEwViydcMsIuO7mjBLvwQruXqKWb7mGgh1+uJ5r7MOIzy64Bfx89MBk3oOXAxK1/zaqzm+0P32P5IArDVSTZAIrsU6jEA6NS3qRdLylDr0BPyE1YqinQ5HRCg0mNb03zq+wHFnGBrmPHO1+TiGpjVWjN5A3lfOYuUCgFTxm+3V7Nfty3HtR4B92qwelA8cVc83CiwXIHHCpRrBgCEubnRhIXTXSeLPzihKGo7ZuhLKGzaacvEfgU8FyVALWN2vmAmioUXJ+iTt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(39860400002)(136003)(346002)(376002)(33430700001)(66946007)(31696002)(2906002)(33440700001)(31686004)(86362001)(2616005)(6486002)(66476007)(66556008)(5660300002)(6512007)(316002)(16526019)(8936002)(8676002)(186003)(53546011)(6506007)(478600001)(36756003)(4326008)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0FGLRkS8J+wsdRrHiuq472K5wtbrLG+03c+oPh6apAeykfaVTwS2vblah41LGAmtBZGruRUoogumgpPWHGEQy5Q+BvjGMQN6urDgSrmExTuvjEDhICocZmKwj2IIM6nHLZUFTNbCsHY6Df4p3u2azhlsehqTBcRisRgUnwcKCIby37RPjbjzjOig5WHLxafl5RMkUmHBUsUFWkk6YfzlVOIHBRMX7o44/eb7E7UoRaHi4Bnqka5qVnJFPWy60YJdwUBdtDr/eR1DCkkqwh1OlDwjJuTP/sA2n9tZaU4QFVigqU77UBKlWqWn7+xPukrjCVUL0XGoQmduHex7VG57nDDtZRyhstEFjbz9fUbrXjF2Trr8aKy8pwRNTOzpBUK2zQDO+MTY/52WxO4DPta3R4Ein3j/8+bV6WKmfJaiK9qLGtK4u6CwPyRszaz/8b2xDfl/veTmC0J8Ejql42GMlFw4kC02d2PRT6TqFo1c8zO90sDJvUbZ8dWT1MFYV/0wNqL2CqnFe/TO+uZJMe4OoQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d24781d-eafa-44b2-59a6-08d7f6da3fbb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 01:09:13.0279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lybvWRhLo1doTEjvncWrYuLvGkAUO9Zl4HeXgRoP4HM0+WeEKBpCcPe/5A8fmmWE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2757
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_08:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 12:24 PM, Andrii Nakryiko wrote:
> While working on BPF ringbuf implementation, testing, and benchmarking, I've
> developed a pretty generic and modular benchmark runner, which seems to be
> generically useful, as I've already used it for one more purpose (testing
> fastest way to trigger BPF program, to minimize overhead of in-kernel code).
> 
> This patch adds generic part of benchmark runner and sets up Makefile for
> extending it with more sets of benchmarks.
> 
> Benchmarker itself operates by spinning up specified number of producer and
> consumer threads, setting up interval timer sending SIGALARM signal to
> application once a second. Every second, current snapshot with hits/drops
> counters are collected and stored in an array. Drops are useful for
> producer/consumer benchmarks in which producer might overwhelm consumers.
> 
> Once test finishes after given amount of warm-up and testing seconds, mean and
> stddev are calculated (ignoring warm-up results) and is printed out to stdout.
> This setup seems to give consistent and accurate results.
> 
> To validate behavior, I added two atomic counting tests: global and local.
> For global one, all the producer threads are atomically incrementing same
> counter as fast as possible. This, of course, leads to huge drop of
> performance once there is more than one producer thread due to CPUs fighting
> for the same memory location.
> 
> Local counting, on the other hand, maintains one counter per each producer
> thread, incremented independently. Once per second, all counters are read and
> added together to form final "counting throughput" measurement. As expected,
> such setup demonstrates linear scalability with number of producers (as long
> as there are enough physical CPU cores, of course). See example output below.
> Also, this setup can nicely demonstrate disastrous effects of false sharing,
> if care is not taken to take those per-producer counters apart into
> independent cache lines.
> 
> Demo output shows global counter first with 1 producer, then with 4. Both
> total and per-producer performance significantly drop. The last run is local
> counter with 4 producers, demonstrating near-perfect scalability.
> 
> $ ./bench -a -w1 -d2 -p1 count-global
> Setting up benchmark 'count-global'...
> Benchmark 'count-global' started.
> Iter   0 ( 24.822us): hits  148.179M/s (148.179M/prod), drops    0.000M/s
> Iter   1 ( 37.939us): hits  149.308M/s (149.308M/prod), drops    0.000M/s
> Iter   2 (-10.774us): hits  150.717M/s (150.717M/prod), drops    0.000M/s
> Iter   3 (  3.807us): hits  151.435M/s (151.435M/prod), drops    0.000M/s
> Summary: hits  150.488 ± 1.079M/s (150.488M/prod), drops    0.000 ± 0.000M/s
> 
> $ ./bench -a -w1 -d2 -p4 count-global
> Setting up benchmark 'count-global'...
> Benchmark 'count-global' started.
> Iter   0 ( 60.659us): hits   53.910M/s ( 13.477M/prod), drops    0.000M/s
> Iter   1 (-17.658us): hits   53.722M/s ( 13.431M/prod), drops    0.000M/s
> Iter   2 (  5.865us): hits   53.495M/s ( 13.374M/prod), drops    0.000M/s
> Iter   3 (  0.104us): hits   53.606M/s ( 13.402M/prod), drops    0.000M/s
> Summary: hits   53.608 ± 0.113M/s ( 13.402M/prod), drops    0.000 ± 0.000M/s
> 
> $ ./bench -a -w1 -d2 -p4 count-local
> Setting up benchmark 'count-local'...
> Benchmark 'count-local' started.
> Iter   0 ( 23.388us): hits  640.450M/s (160.113M/prod), drops    0.000M/s
> Iter   1 (  2.291us): hits  605.661M/s (151.415M/prod), drops    0.000M/s
> Iter   2 ( -6.415us): hits  607.092M/s (151.773M/prod), drops    0.000M/s
> Iter   3 ( -1.361us): hits  601.796M/s (150.449M/prod), drops    0.000M/s
> Summary: hits  604.849 ± 2.739M/s (151.212M/prod), drops    0.000 ± 0.000M/s
> 
> Benchmark runner supports setting thread affinity for producer and consumer
> threads. You can use -a flag for default CPU selection scheme, where first
> consumer gets CPU #0, next one gets CPU #1, and so on. Then producer threads
> pick up next CPU and increment one-by-one as well. But user can also specify
> a set of CPUs independently for producers and consumers with --prod-affinity
> 1,2-10,15 and --cons-affinity <set-of-cpus>. The latter allows to force
> producers and consumers to share same set of CPUs, if necessary.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
