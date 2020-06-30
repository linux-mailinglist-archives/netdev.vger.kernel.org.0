Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E826220FB69
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390612AbgF3SJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:09:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61620 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390449AbgF3SJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:09:25 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UI5m6w018621;
        Tue, 30 Jun 2020 11:09:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sy7qQ1N0F88v8rzR9afKy8lnxPVblmTqa/ccS0U6KvQ=;
 b=lOQauAlnJxeqBWnjSgukkj2XPBltI4nJRzEmuizOwbJw16VKtGl6o+7f6XIDqNDuDKWq
 A9njhnHKzy7POFyZu5S2cJk741yZPASbpwXfNKTITuqvD5Nlr18G6Z+sj185BGFEDD34
 DQR9F1ehBjBZpC0h7FHTF9WFyQD8aqzWJfQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3upnq3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jun 2020 11:09:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 11:09:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGaROC5m3DQANSCSxO0ec2BCbOKxpek2wS9bO/lNzG+aGSDVogKg/WRbNu8aRxKCCQWED2PRg2CTDjMD9A/g04yFycZLHDLkYst20JC3Ja7gsTwbgQR/sAY3mponaFKbZJoaGKHpauzQuCnK+UIoAYHiyPm6lRBc7Jge0QwiXTBDRsnn67+6Du6uz2hb1/CKSD9k5tPso8D/Xr5gxqolCnfcTrzvESWGuILXnrMH4BvpENG4Jj/iwXpXVXPLE7ckoyW5gXRa9TE/Bi1w119EaBhkLzd96ACtoWi4EjqZE3XUEYBHWNDeEbtMVg2ocV//Ax3gjD/F7hV7tP99uedgWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sy7qQ1N0F88v8rzR9afKy8lnxPVblmTqa/ccS0U6KvQ=;
 b=nxSUKA3hxzV22SRbGBeShnL9x7vk9F9jtgf/3aNDuFdmhzjwv1LqW/4t6WWoxpVRgwYjH1xsg3JPU2SwJk9KOVA/83HaolU09B0mAQZ+7TrngDgAlnBUOsrXy+oy5s7Yn5x30yrbdXtjO2OdWARd5iJamJODzTWn7C92UD3m1snm8tbrSXVS9n+e6sFhmp1g9y3zp5qhsf5W8CrI7+pPTDwNZNxksbKxbXdpXbwNVEy7SzVt7xqTIuCoea++7Vo21tW6/xHkA/6fglcluCLwM55sKI/vgCKQQ/XzK3SbgsNhvLuX3FVEbS/a9nUVw2ebTw2+n5inyFLxmdVgMtIlTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sy7qQ1N0F88v8rzR9afKy8lnxPVblmTqa/ccS0U6KvQ=;
 b=Em5ksMaNprfguvcuPPcJnkoIF9VP29IoaO+Kf1OyVfaaKl8S2mH/iZYmf78thy6rSE/T38TGEIceuy0V9j2CJScsKhc/2XMm715WOBUcn4qKElEKE/TZyu4qrOiC4V3+iHTHTvXrf6wG4yWkwbFEwkxI2xzzIxJY/ccVna0l1DM=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2887.namprd15.prod.outlook.com (2603:10b6:a03:f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Tue, 30 Jun
 2020 18:09:10 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 18:09:09 +0000
Subject: Re: [PATCH v3 bpf-next 0/2] Make bpf_endian.h compatible with
 vmlinux.h
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200630152125.3631920-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <82291181-aa1d-c086-9df9-2a889b7967cc@fb.com>
Date:   Tue, 30 Jun 2020 11:09:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200630152125.3631920-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0035.namprd08.prod.outlook.com
 (2603:10b6:a03:100::48) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::15c2] (2620:10d:c090:400::5:c3b5) by BYAPR08CA0035.namprd08.prod.outlook.com (2603:10b6:a03:100::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 18:09:08 +0000
X-Originating-IP: [2620:10d:c090:400::5:c3b5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2021fd43-4fcd-4d46-a003-08d81d20af90
X-MS-TrafficTypeDiagnostic: BYAPR15MB2887:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28878BE8048DF8F122CAE0FBD36F0@BYAPR15MB2887.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hYGBeo9QrcRrEhhXnxN0aoM3dHx7cMj6wSgZtP0ejK4Q4BjC1p//xODwK8FOJnAQiCw58lduG/c+g06RBujEkN3n0GKt4J1aKxvMXmKaWHx2UcyjBVBBCV4dnl+9poexH58w9Ccfb8M0yYYrK+7DaIHQgMVz8mmB7FDyx2gsJ7SM1uyLedFpBTbWpq0Gt4ulJQ/M/cryjpFVfUplHK8vtzRaVhwNdN7Xnjs+ysHhrbuUxHQiURSFEOAtSqGo4nzbXqsYwo6ZZ4u9vBEOH+wq0saQzsVA04ManQOnaD+p+g+u7zAs2I195sThKDlUwUKQwDcsG5k8MPHO/Oea3EEjv3MbRXJkioDHPDi3ifEVkj/TE73ZiCM6Xz4WiFDEFqLN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(186003)(53546011)(31696002)(6486002)(5660300002)(478600001)(16526019)(83380400001)(8936002)(2616005)(4326008)(52116002)(66476007)(66556008)(66946007)(8676002)(31686004)(36756003)(316002)(2906002)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: YFHbaOqUJpkBmIgkPnhum1+YlmkYay/RYDj9O4tZ7co114O0E9MgzM60GLdcg5OdnY9rxEFGY6whBbwSJXr5rg74+WTYrbv3+6Y5jkup2bgfwH+dao3wS4AFLW2Z3r8ecoxWf08VKLkaKSkHECRylAbUHmY5ClTpbq0d7KiHQLebFwpY/3SBSM6CcrAt3tGvsQs7M645gHpwd+vRO9VOZ6XUjCxC40TA7WUHwGwOomGdmuJsFztjjf7JwhCi7/6j+HSUvsx8+FgUTar4UZJffiC/xyEpE8cELhVX+3z8BHnt+E4Vd64Foh9afYRf5fjn6SjoDJ8kh2O4Jrk3T4qPjOhK7BWQIFVIPag5oWE5fNwsWJsDce+dbhhC/HaJfxGSNDoY0uU3pUWXo4cLXCXI0DrEHRCWpjae2uN5mTwHxDYUIZ0ystDmKYyfmCdB+Z42vlYD8VTP1Y17pNuTfqFUDZd3gScmBRk407w6g1hOGDMeunuSyK0cOoyY9cbHOd/+RVqg0c6f1i0LSNW1p0JESg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2021fd43-4fcd-4d46-a003-08d81d20af90
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 18:09:09.7003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TaGROyeS45YouSHSmVu9lieVJNfQU1bJv4MJvVCV7VnqSRqjfq0qmVQJNcgFq6Gu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2887
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 cotscore=-2147483648
 suspectscore=0 mlxscore=0 malwarescore=0 clxscore=1015 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300125
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/20 8:21 AM, Andrii Nakryiko wrote:
> Change libbpf's bpf_endian.h header to be compatible when used with system
> headers and when using just vmlinux.h. This is a frequent request for users
> writing BPF CO-RE applications. Do this by re-implementing byte swap
> compile-time macros. Also add simple tests validating correct results both for
> byte-swapping built-ins and macros.
> 
> v2->v3:
> - explicit zero-initialization of global variables (Daniel);
> 
> v1->v2:
> - reimplement byte swapping macros (Alexei).
> 
> Andrii Nakryiko (2):
>    libbpf: make bpf_endian co-exist with vmlinux.h
>    selftests/bpf: add byte swapping selftest
> 
>   tools/lib/bpf/bpf_endian.h                    | 43 ++++++++++++---
>   .../testing/selftests/bpf/prog_tests/endian.c | 53 +++++++++++++++++++
>   .../testing/selftests/bpf/progs/test_endian.c | 37 +++++++++++++
>   3 files changed, 125 insertions(+), 8 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/endian.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_endian.c
Ack for the series:
Acked-by: Yonghong Song <yhs@fb.com>
