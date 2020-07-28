Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0EA22FEF4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 03:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgG1BfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 21:35:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28460 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726357AbgG1BfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 21:35:13 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06S1T05V007642;
        Mon, 27 Jul 2020 18:35:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RkJBFvJvLb64SbBlag5KGY4E9B+FRTUmybgy0T9dPKg=;
 b=LNrdjR7jn7PjuEnCWQzYGuT2jNl5+FfFeX1xcWA3gJmk6+xbOMOyB68utYxaCcOwCTIt
 kjIqonuldsBfsP92EeNQpCwPdwI7e/YAL1UQ/KFaquNio10rrYYfmj4KtcAODjqIS6kM
 Ghv9Re3d3t9OA4TiW2gCEn0RzZvqgoK36Qg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4q9fc0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Jul 2020 18:35:01 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 18:34:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWCQAZ2ueaIjy4OPJqZke96LMNBjak+neqpLWTzwjQPbWMWA7NKoIrTBjYsl7MwHxuBVBi/EU/m5LMhoqD1rPlZjJYsld9PUEDrpd7dmEI5XN0mg76/zNqVkbDHlXTuKA04VYnMAt5pEMHCM7W2LnKPlhfm4zRTa6L3xQcuM7lRX62F7CbmzMPuYk9Ej8xB7sXX9htVMngM0RQNN/Numzae84faOOigTrPN9YC9dchZzzGRGzQf9Yhd5XtmAI42cfZKJQjp8SJraQS0wx1h/pjvAv0+YiiBm5Y1M85BEv046pL6BJmjYf9Pdxbg3TMVblQFg/B8A6MF0u1bZJ0qHiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkJBFvJvLb64SbBlag5KGY4E9B+FRTUmybgy0T9dPKg=;
 b=nAMsHgBuJYuEzXKfY8PHuigOa5mQCddeJrkQLjZpcxuHZefjOQ4gNd7t/fLSMFpdRx2idtuLsHRS5svv40Gp4Y66bklW4W5Vu+U4Y7o/Cwok/DNjdPKBHNvOFcit068BPDqSu841/PZ5B7RJuCWb2OLQ/V6TcUaWWk1QYl4pALSRWgL/In/9XgLbDdflqzfz4L+9zKUUQmlkC5M5oT98ISDwEXB19mcGNgmrCHAa9VBGYudGV5JAd30OepZt5xXK0gXtJtYRYPf3q0fD7wcwVMUvM1KXsVKFRzf5MiopTHQ8KotbpVIwRAYaV1+VJFu3hB9BUzBYiW3pgJM5k4YPeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkJBFvJvLb64SbBlag5KGY4E9B+FRTUmybgy0T9dPKg=;
 b=KW5ISWWP/0UybmTPxATOtERLERh1BEQ0nuSKe4D5O5dB4poCboH91WD6t05tHb/ZHd4fQHP+TYT8ZzU0/Uxb+Rd9nzeV4uecL0Avrw+qT0TLnzvoNhzdW0+33NMcgj98RW1IuzGu4g7cChYDQGxX3bUvfrF157k+Fd3U3RSUM3Y=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2726.namprd15.prod.outlook.com (2603:10b6:a03:157::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 01:34:56 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 01:34:56 +0000
Subject: Re: [PATCH bpf-next] selftests/bpf: add new bpf_iter context structs
 to fix build on old kernels
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200727233345.1686358-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d2711516-9b26-459b-194d-5deb2f964e6d@fb.com>
Date:   Mon, 27 Jul 2020 18:34:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200727233345.1686358-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::38) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::11ef] (2620:10d:c090:400::5:402c) by BYAPR05CA0025.namprd05.prod.outlook.com (2603:10b6:a03:c0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.10 via Frontend Transport; Tue, 28 Jul 2020 01:34:56 +0000
X-Originating-IP: [2620:10d:c090:400::5:402c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc9d0697-d5a3-4694-e212-08d832966f2f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27267E5621104E16AD037023D3730@BYAPR15MB2726.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cDYWeZe4uX2TgQRDAELDJSTL3H35htu3XiJ8GpJXnNfzn38xcl96H7i6duHd/qzWT5MCX1dr78q+M5nwFApp8muzbk7j7r5oS1YoBLpZTXWaBP1hmrKmgLhlkW7MtVHjCmk1sd4k4KF46R5CSga5p9oGKr6xsoI4jFj4mcOKqECunre3INotXNxwI7WF73lge+OUgVEEyoLGsmG+6ocPCYoa2hRSoUspbRnSeIL2apsavtLGfJw3PSB9ofkuQ6UfvxgCTZicRrVRK9RVUoy8J8o7YDNzEYFJU1MB60/JHkQ/4prcm2NE2M/ajCT630BE1LMi68Qh0LGfmU15RPFIF5CjqpfLRDWrkjDPM3KJj3I0TUbmYHfPimGbL5bmlV77
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(136003)(366004)(39860400002)(8676002)(4326008)(5660300002)(316002)(36756003)(16526019)(31686004)(2616005)(186003)(4744005)(52116002)(8936002)(31696002)(6486002)(478600001)(66946007)(53546011)(86362001)(66476007)(66556008)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /BnKsbNQ2kwcxbUsA4OT5GSIdCi0qJ7+MEL8NHxEsfy6pNBMd4ynaLHCrO19NeUZvR/HuFb9+VIHjxQa9371g7M+NjXfNWIvCKsEZO+zkJXYNeo67YmKkMT75H2xlNoCAV7TtNGUnQk40DiDHhNIvNXojAZjX7Hx3fW460julzY8lEXmXqGAJ+RKgcAerxICP02BOPK9kFYvGlYslEYsVPG+prqC54G5FT15gn6nuT+eHjY2H/rig/NeUsZ7yT9VyraTWb9YOXNhr4LFbGFUroSovJ5ckkYiwqut1m7s67Ne6ydl0CIbEhnhVrQfnrXOYfY5JzuzPxANzZPD3WgbIQHL6WGD7msIBgsY3DYPWTDy6hod90J8YOJOxtII9JbnTuNccskqOfsmKzzJZOausz3vYFIqEkw0OzpZgLhBC83Bsuf49Dh9Qm8E3S4P+XTYyTApjF7TwDc9A1KrK3MUPNdK2ZBM4fwVezYKKE42Ifu+IH4Sc5ETh1OHmI/FLM3tYbbWoFITJV9dD6icKFgpjw==
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9d0697-d5a3-4694-e212-08d832966f2f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 01:34:56.6376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YgmtbcpuEVJaecwOqiGBwnZ3V/a4gTR5hHF8YduqZVd1Jmd6RrUtXZMzKkYF2hWt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2726
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_16:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=905
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007280009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/20 4:33 PM, Andrii Nakryiko wrote:
> Add bpf_iter__bpf_map_elem and bpf_iter__bpf_sk_storage_map to bpf_iter.h
> 
> Cc: Yonghong Song <yhs@fb.com>
> Fixes: 3b1c420bd882 ("selftests/bpf: Add a test for bpf sk_storage_map iterator")
> Fixes: 2a7c2fff7dd6 ("selftests/bpf: Add test for bpf hash map iterators")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
