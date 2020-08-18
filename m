Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAF32490D2
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgHRW2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:28:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59106 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbgHRW2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:28:45 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IMDP0p006433;
        Tue, 18 Aug 2020 15:28:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=A99tmk0+7C3bCsJPeqjZp0hm6to33V9YMyY7aGNhlJI=;
 b=N3gJccXDUnqXeHqhpPkky8J2GX2dSPnk774gLbv0TgWj9OPonb1CY2Kjn8bT+o8Iek/Q
 M4vBISm4VmSdxxuDRwWhRjzVVfxe0B5x88M1bQGmlUOIM5DvHCFJa5tDH0GuLXqVxEDn
 bPWzMmHvuqpaoXC8GQSYabtnA3OAMBvNQPk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m2wevy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 15:28:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 15:28:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUDjY2jDG8RgBcRKOpAScS5tNrCRvdi6Yax5gPKOJCTWHXlXSz99LLmIn4rR8Al08BBeHrLIPVCe55nadhqRuo49SACkcNhPAQqcisEx+YbpvYWIdf1880mNw6Nffr7r7YdFKY+/7JvxkpupisjRo6IwHmJy+FsR9U9W+FDJ8D6SEefid8MwSi0Ke0DMVekoGjIIRitATNAnSJ2//sWDzlJctj8XHr+yc/mZaNiQApQDZEKBx7kHtI79EZuY8ud5ET40uR1F4hmAx0kL4Q1ue60etiLN34dpe3tDTHNbhNownaJtwx6wMbWBrY1VXfToPMKeMGM4QJMGFr78z3srng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A99tmk0+7C3bCsJPeqjZp0hm6to33V9YMyY7aGNhlJI=;
 b=lz4alZD8M0lX6rqjc4KSsCwdtTXQIf/l66W5V9ERVRVvw05gYefmQ9JrMUPX+qLz/Kx/4SASOHDXkcXNavfuHWIKeGvLZCb2TLGiK+43J1pxVYJ9eYT73BpVvEYdCbviGwVdVxx6/t1zt8IoPvq9dlLXUG2gRv7Jfn8kAUaR0Orp2pfcT5o8O7MKkyxrwwPZivNtqoAFerUliHtmyi6nhKKISxbuj01QazO8yEGecpc0k3RaMmOYh0xutoaxEh3iDt+zO3p7zV/kl6PAW0UFss4KGyeoK+j2P5amh7yrVzmGtxBbw+kW/ikaCA0PmuhqMGo13TmRKPhoLgrFZpqXog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A99tmk0+7C3bCsJPeqjZp0hm6to33V9YMyY7aGNhlJI=;
 b=MYD5HIw1pdNCqehspZ1guaA12OU9DXi/tDa5u8fLK7BKnDtUKssjhm9FXvnCdsQRI8PtVtB0+zXSfbmv0j8uLem+IG62kpUkV5JtxMOOdKUflVfQcTb1GO5I6BR7+mgx9F4PgReQcVf0a1XV44XgVb1Vog0F121pUtwkNwWJ+qY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2453.namprd15.prod.outlook.com (2603:10b6:a02:8d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Tue, 18 Aug
 2020 22:28:29 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 22:28:29 +0000
Subject: Re: [PATCH bpf v2 0/3] bpf: two fixes for bpf iterators
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200818222309.2181236-1-yhs@fb.com>
Message-ID: <b60af5e0-6f02-b0d1-9979-8a329a36541e@fb.com>
Date:   Tue, 18 Aug 2020 15:28:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200818222309.2181236-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::35) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:a06c) by MN2PR07CA0025.namprd07.prod.outlook.com (2603:10b6:208:1a0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Tue, 18 Aug 2020 22:28:28 +0000
X-Originating-IP: [2620:10d:c091:480::1:a06c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce392fec-bada-4a5d-3d79-08d843c60850
X-MS-TrafficTypeDiagnostic: BYAPR15MB2453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB24532B50FED384177944D027D35C0@BYAPR15MB2453.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4BYfVwUEX6FEc3WTG4BI6ON9WA0/8LRBre8aD652hGHymckkhVMf6rCWx40vNWFdSFuBzN/hboHt4EJhqPnhjKujO0RUEWv904w0wMU9XjCF32eUJV+TizgPHMJmKkxEoXEZrRTOkhiYjB6r2d5ufulWpdlHqN8E44iZehYGcQUfcKT658P4SOOYd/ahfT24LzF7L3eenjCvfzJjGPBeob8HBapKMGbVnrgfIQQfUQ8yV87oLzJ9hFUp4VHcMYmmgSa79hc0PvnTwDjbG49HtLoAJ1NviJ05PO3MpLBrkIDDDjQarNMx07QD1Lf32vojmhoAiCI2Hae3SkyYix6XdgYq2w/ZWiP1EXlDjmSd/13O253oILcAAK+BBDWM8fds
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(366004)(39860400002)(31696002)(186003)(8936002)(66946007)(478600001)(66556008)(66476007)(316002)(54906003)(83380400001)(4326008)(53546011)(16526019)(6666004)(2616005)(6486002)(86362001)(36756003)(8676002)(31686004)(5660300002)(2906002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0xruVUuqxZAAL31WIziJ/KroKtB+Om4Xpfoa2pPlJKZSAurujuxZypZ/rVj23+UKdUSx8ysA7W8k5t+PMHTvcjbbbwjYaE/Ov+TPYC+l6KfZTHWNMg6BaUjN0rtJv4+/pn7ibz+K5ebKHwkeqTcsN+J5AsjA5deySGSAx1Ksmg94AbA+7onczv4lBT/myfNYcIu9lZqp3ufJqrbk5r3HP4lctfZZSrCg9QGSUsiLd1PHZkS/RDJHXijRGIwifB6KMZqASLUkF05nNAxCxW5Qgdszzxua1hsycd9PX1M0TvWoZmDrjEKUd/BAt6orZqP6UKT/QOy/SG42/b/yl4NiCCg22nOBhm/6BjyDnmlL+c9cND8ncJWeDdFk6ZPbjez362FTQTLlCqFaUSBL1yhUkQj034UPdNjzxCJ6fwJbjcSl2rmkoD3ZSkA2MjS5JD/id9DLvUuDnaZN9vjzOGjW/mrXLEd2yKqdbsvhnWYqPMseW78BvSp4Sv1rbHio5vNLad+NoCpvxAzIB8uOXjUTb7YrtiSNQopCb5vOLpxj+7CUGHrGEmwOWQz1PAmULYtjGeu+eX8mI2Dkktj7W5UzUo5zx+iUv9I8gi1hsJJAfcC6OUSkkQVLbw2oulSGToq+qchpGL2Z8FZPvnCsFjmNk8+BuvMFNyYyI/cx0bziRMn+UUTTxl4cwUQzt702qdfn
X-MS-Exchange-CrossTenant-Network-Message-Id: ce392fec-bada-4a5d-3d79-08d843c60850
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 22:28:29.7355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DhvZUn71J14wszzI2J8BJ6Adghl3qN5ncn4j2CwYu6eOocKbAgZEYNm+et0ePTp+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2453
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=901
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=8 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 3:23 PM, Yonghong Song wrote:
> Patch #1 fixed a rcu stall warning when traversing large number
> of tasks/files without overflowing seq_file buffer. The method
> is to control the number of visited objects in bpf_seq_read()
> so all bpf iterators will benefit.
> 
> Patch #2 calculated tid properly in a namespace in order to avoid
> visiting the name task multiple times.
> 
> Patch #3 handled read() error code EAGAIN properly in bpftool
> bpf_iter userspace code to collect pids. The change is needed
> due to Patch #1.

Sorry. Missed the changelog below.

Changelogs:
   - v1 -> v2:
     . do ratelimiting in bpf_seq_read() with a counter.
       cond_resched() doesn't work as some iterators (e.g., tcp,
       netlink, etc.) has rcu read critical section across
       consecutive seq_ops->next() functions.

> 
> Yonghong Song (3):
>    bpf: fix a rcu_sched stall issue with bpf task/task_file iterator
>    bpf: avoid visit same object multiple times
>    bpftool: handle EAGAIN error code properly in pids collection
> 
>   kernel/bpf/bpf_iter.c    | 15 ++++++++++++++-
>   kernel/bpf/task_iter.c   |  3 ++-
>   tools/bpf/bpftool/pids.c |  2 ++
>   3 files changed, 18 insertions(+), 2 deletions(-)
> 
