Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDEA1D0431
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbgEMBKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:10:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6100 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728131AbgEMBKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 21:10:50 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04D18w8I023980;
        Tue, 12 May 2020 18:10:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8chVUxHR22Km1te/pKecLZbj2K0dFyqtXbD64ob93Gg=;
 b=hk5QyeHaLcG/JpX971fkfrWGVnaqTBJxBuNmW/TB7DJB/m5xmdy13mGXNbgrciosD3MX
 F8nu5eMHY0sET+oorPcOnUs9e7GBwGXlvvOJ/ft0vGKabnwoET9st9c1/FOMYjY1Liq/
 Um7TP5nLBoiD/INjU3jrvnxVS4vThz2+Lu8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x21xr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 18:10:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 18:10:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASy9/Xoe5GSvDRNFfnMMIgpMiNOUCB3fXeaQSeYw6mx9qX/zvNe8C6HwNlCbSPq7geLgHLEQyClAKUgvfaFGRc7xkCi3EV2xqCp6N4csX4Rilh2xIbIIAgWCrRI2FoSPERhb/UVHNcf9AYTWrLLz5/cYxhWtgkD6ibDOslVipGzTXULlfKgOW3kHVAUpbeqwu0sYWp4bSiCvXOpk9ika+MbtL7IFRccNHbXwS2cOnxYN9Uk9R1Cszta/Os5KA1XEK49IiA9u2Q6Rqf/kYieZgRy9yoNokIoKZwIJiTJsZBBvghK8qGRWLUO1chc6Zo2TXJs8qvpLEXcLHIBdnl9qZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8chVUxHR22Km1te/pKecLZbj2K0dFyqtXbD64ob93Gg=;
 b=Ji/7Bu0iJQEraqqNc88/caMMQB+zO8lmYwo+rcqmU0kmEQpoi/0FwduIbsfIMzSKCRxAzr1G6qAKgVs79rHNYWjUtxVieVt+fvvvJoTfdr1lVfhzi+tMJnPxg8eXwAUI7X0sb0+x8Bbjt9pfM3mVsG03G3yWveONv7VniW1vOOn8UPhGFtaQAUI/EpNiSEQtuxY1dzSq/e3NfTZfvNhZHJBNhYPeRTcBuP/YFthy6CgZcidO2cqopMpZ+nY+/PxaMoJcb+hMlmV6DEut1YnTIy4MDURjZPShjZzsZh7qjnbT3mys92j7r3ul5Mlb1tbOTR58XSO6sZKVeSNnm/UqRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8chVUxHR22Km1te/pKecLZbj2K0dFyqtXbD64ob93Gg=;
 b=E3MVjDz5fiWk147Gh5W1JHoDAFe3QZpHVfTXmN+ABvW0Er40rUDTqh5DX1BDj6MtV2XwZcDmjjIe+JCXII7S7tXh3m5WvBljXJ/S4BRAHK1iCBf92P94EnEkbs5CQZKazW9jV30wkCccysiEQFTKcoq0oUCRLEGpiCYMUF4nOiI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2903.namprd15.prod.outlook.com (2603:10b6:a03:f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Wed, 13 May
 2020 01:10:34 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 01:10:34 +0000
Subject: Re: [PATCH v3 bpf-next 3/4] selftest/bpf: fmod_ret prog and implement
 test_overhead as part of bench
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <20200512192445.2351848-1-andriin@fb.com>
 <20200512192445.2351848-4-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <33778f26-8381-8607-4e14-d59c6e5f320c@fb.com>
Date:   Tue, 12 May 2020 18:10:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200512192445.2351848-4-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR16CA0029.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::42) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:dfef) by BY5PR16CA0029.namprd16.prod.outlook.com (2603:10b6:a03:1a0::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 01:10:33 +0000
X-Originating-IP: [2620:10d:c090:400::5:dfef]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4496d601-80c3-4025-cce5-08d7f6da705a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2903:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29031EA36B53C187B5CE9E4DD3BF0@BYAPR15MB2903.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UAP5QuqCxgmwT+4M6s6FD+DGWIW30Fh5Q2JoCX0yt1rlWCcYp4Yo7f38ymPoKOEbgCObU92JmabHptQeDiCAmV8plX/77MfmJSUi/qx9VjAu5EsVpH6eS+ldspxKWn7I/Q5ReWKYxh9ZIvB1O7/ab4cGdBqoLns9YffJ4duLYwZJyzU28Wli2BKz8MFsmhkgrTT8X9z8+yIK6a3Cvn7D5GyiyyiR3N+reWv4aa6CtgsUY0P+jOjWZdNMOgL6+tHSShqPh8ryAJ4WfBuf76RE6nIta74dGJxYuNqKIbIhVSIerm4g6LsKe74vf4d+sju5wfmHbAS+GpS4kNxTbn03hzokx0NxcLTpOFtcMUPSbD8FQoUwm8kSa06Lb2d7/Bvj9Z72a8ATdfud6jEyN597YgPpdWa1YwNfx0gzIf1Yw9yTKsh1jmu+5NJkKV7GgcU39eom8SvAtVumvEj6uwma4FSwVg+C4N7Lrnqv+/Lqzw5zr6ZGmyQiBG4AVlhILvLoOszs8s4xYAJI80y0e0Q99udlRj0hEcP1T+60BQJK5oDqn2+P82COjAgzq5EdDzAH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(346002)(136003)(396003)(39860400002)(33430700001)(86362001)(66946007)(6486002)(6512007)(31686004)(8676002)(36756003)(66556008)(66476007)(33440700001)(5660300002)(8936002)(478600001)(316002)(2906002)(53546011)(186003)(52116002)(16526019)(6506007)(31696002)(4326008)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: go3u0fMRjiQxGpGb+7X6DhNZ/x26PNL4TPEDs7BG0pLui3zrZED0s277CsYQHnZOFxRpxtcOQ3wqfhBn9dUthV7oyElzk2BXQH7flo0KYY1GB7iWrV9UNbaqWX07BDoU1A2v/mDlpeEc3I04V3UDz5n+szCtBoUmfIaf1CgyO4t7Gt0VXUv9ktplL6V+Tl4yK8Mtw6cPkEXUQCaLyH/iBEkwVP85C91KYPZoipY6GXpJT7sriKdyBtTv8L49bbfJcBGzoPYB7Y2VAMHNImNXzEinXjwJA+sHAqhMKxQJSGCblL3/YjhCV7ZQ9QFS3YSfxuq1jGrA628ik9OnRxnDw48+sTMF0W3sf1nCcCubI9D58Gj4YCM1nxFLtfzIqUdbtqJG3wYm1M6k1mGPhmX9uLzlf3N7VQwAQKwtcIo6wNwKYdJbSK8zEVYlXQtj3am+CGop0Q1uxVaMcuUz95I4a2X2GBZJ1qyEF9BkeJamAw/FoPIr5pbEidRK5ym3n1nDmsbXLiqH4F8FOvghuZ4FSQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4496d601-80c3-4025-cce5-08d7f6da705a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 01:10:34.5796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8lDVI0GGSldTGZvlggkmXbUuUIDncds58gPQtqywGRI/0McG7CeZi/sKkKq6eKe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2903
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
> Add fmod_ret BPF program to existing test_overhead selftest. Also re-implement
> user-space benchmarking part into benchmark runner to compare results. Results
> with ./bench are consistently somewhat lower than test_overhead's, but relative
> performance of various types of BPF programs stay consisten (e.g., kretprobe is
> noticeably slower). This slowdown seems to be coming from the fact that
> test_overhead is single-threaded, while benchmark always spins off at least
> one thread for producer. This has been confirmed by hacking multi-threaded
> test_overhead variant and also single-threaded bench variant. Resutls are
> below. run_bench_rename.sh script from benchs/ subdirectory was used to
> produce results for ./bench.
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
> Note that the fact that ./bench benchmark always uses atomic increments for
> counting, while test_overhead doesn't, doesn't influence test results all that
> much.
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
