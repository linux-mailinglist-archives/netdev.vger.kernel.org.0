Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E2924924E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgHSBXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:23:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62942 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbgHSBXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:23:43 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J1KKXn017003;
        Tue, 18 Aug 2020 18:23:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gLWuLFuFkVxMRzRBn7WHGHqAbPdvbH65hdtG8TzMBTY=;
 b=htb4lvTzq27fsOPb4bMRxr/iM8xOdqhPHKb8czMPrjo0crzDmHMMTepRj6tVK/PxmT84
 QvIoJY4RF7YlVyW0h2cn1ZH2DVG2S7rv3eIULlZli9hGhM7SaBAEW32evE2bZwZ4Dc/O
 LyojJVNF9w5FCBykxYMy+WMIib5bG+NPdfs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304pax0pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 18:23:31 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 18:23:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1ayup4ymksTXmX+ZCzdXyYllEQjS2PFVOmLrpB4q41t8ryjRDkNLw9JfWtadOCV3KK1bV1DiSVNXpey1f/SAIqO9gY+8t2SGfWVi9xKER4ChN5kpqhmy7U8L/YPlK0l5oGzh2nn4ATRQdYZkEWj/49WQg0W7lu6RFnp7UBGH6oT2JDRm3YKPvSwIewX5W+SsQFa8iQcrvrHA9PHg9Lo/0od9dWB7NSiuxCr77LJohWZ34Jo1b/MaJXqPdB3OA7hF6q6gI02dhSX6z+9SVG28pbo/Qh37eIAwOesZWpkSLf0606+YAbt/dRtplKatcz+0lrwrEasxt6R2RH2973S5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLWuLFuFkVxMRzRBn7WHGHqAbPdvbH65hdtG8TzMBTY=;
 b=jWmVZSjMy6J9zZ4SE99XHNgZW0NSXydoqrSrHzOrJaFFkrdqP9A/V7Oz2inrd8X3PrayRrL9gq2igYuYwR6cSldH9GMW/jJZvwUcqjogoSJUHtr+u3P+FT26KOv8ae6Rg+FjetrF85sFXYA7voNuhb6lMXQLI3/twJk7In+xNnjl3zhZhX1o6xJ+Fa1srDMmd3zH6aJfjkfR1fNNP6k+iflWBo5U5foyMd3aySBWOLiT3hlrxX34k1PjDYzUBuA8irh48tKicRpJDZZGjWDpL2jLOd3187UPDU8TB3k2vD1yK0XSgT/8VWQS2vNfZe7sW80ZHiGVAB+NdSEwKCrKhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLWuLFuFkVxMRzRBn7WHGHqAbPdvbH65hdtG8TzMBTY=;
 b=i30PC3YpOunpkB+HV4wKY52pllzkc/C9Pgx0og9K/KjN4Qv8+XNT/Wkrtu7GY5ge4rpg5B9h8CF+kfjWlIU/+ciUNcjgl6Ko84142VEawkT9qePwsnRsniYwpmJK3G0mj5wVnhIjgLiPctRghgN2zMIxnleUzGo73BGZbzJw7pY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2584.namprd15.prod.outlook.com (2603:10b6:a03:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 01:23:28 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 01:23:28 +0000
Subject: Re: [PATCH bpf-next 1/7] libbpf: disable -Wswitch-enum compiler
 warning
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200818213356.2629020-1-andriin@fb.com>
 <20200818213356.2629020-2-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b26b5c66-f335-2e47-bf6c-f557853ce2d7@fb.com>
Date:   Tue, 18 Aug 2020 18:23:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200818213356.2629020-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0084.namprd02.prod.outlook.com
 (2603:10b6:208:51::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:a06c) by BL0PR02CA0084.namprd02.prod.outlook.com (2603:10b6:208:51::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 01:23:26 +0000
X-Originating-IP: [2620:10d:c091:480::1:a06c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65fc0b1f-8038-4ab5-8ae3-08d843de79fc
X-MS-TrafficTypeDiagnostic: BYAPR15MB2584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB25847E49C04A2B6A725EB7C2D35D0@BYAPR15MB2584.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8H2YApLRpxtpLOJHTSwV5J1cuAsw07cERzw2jE9yNmHRiKs4WU9nqW0euo32koh2iKsu6CoYtEtyt7oiGt30r5BUE8+bq6QtK0sdB95CMX2i/EVX2WFsQWis2Ago5q/y1eCsYWASwr3jYjpI++WmwTxotNYGlx72f53nmH61bFSeCeRhKDJn3qBRueENkbJTGNPJliB5LsOSBGS9HCV9cVwnVLzdRJzAHtUvyeAX7Fq4EFTyOFKKEzsDav+/G/IWuEU/l8c9u13FQxOVDShl1TxOC8Xk5cXvsud/RigXRWoZ3g81mTzBFbNdkXNF8CsSXgOCs+T+1Q3dwuUuqXHtTcSg/CnJWZNFlyPqRd9/15bjgywW2VpFUfFMTOvtXGY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(39860400002)(366004)(2906002)(8676002)(478600001)(53546011)(4744005)(6486002)(8936002)(4326008)(52116002)(31686004)(316002)(2616005)(5660300002)(66476007)(66946007)(16526019)(86362001)(66556008)(6666004)(186003)(36756003)(31696002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: YrfoobKhDo3EMEqGoi6Dpw6fYN3JRquDpLQKTn0uc7DkPe5jIvEZ21m1oWqyCz8niWU98LWrnsbFBqvwKUQn3S0B1JQiGHlhbiINuyNicKyBMxXTEOMyVcFqQyOUM9mJcGUWEHeZsWHzO9xi8Y8M9s9aVrC5Jv9BcXgl6V7XqnwJRbD0X10SMDuL5zUQGu8nuzd48ppW9ZY8yx8bFpeDE6/cxYr5GwZWAOW2zX/t1y171PBAEnPzxwBibRVno941W+b8FA+YdvrxBXRHtvkJ9L8fVXPUbY465GmJN9JnETgLgT2cB0FVgqpCV6Wk5+47t6iy1Z1sptDzI54NBz4ztPpdu47TEw3+m0mquXUPuCBDmFt4DdV4OZ6FfTzHhUMC5TlgzjttCngq79CsSJKI1OcWOsZkWHaegg68kwAXJbdQxiPdHQiSGcx+mhWfQhUBKpksZ6V6GtB/DIPyCwnngukPezHuHwETQwgKarKaV91RNwLMAwcGeZCQDlWDVSa8SGRjLSDjq6f6kgkK5XBn8+5Djiblv9bbA08nk8WMwhY2cOmBsyyulDtSF/xNaSIGMrnX+XQUTID5gidUgHw3nK6IMV17UdMeu+GhFNvDvoqE39w1ov3+tPGCFuXfvlgCXCQJY3e/1opagFd7FauPFcCpgyqwikw491hD+G/82iOcVd1wDQvmU9I0twqij1DF
X-MS-Exchange-CrossTenant-Network-Message-Id: 65fc0b1f-8038-4ab5-8ae3-08d843de79fc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 01:23:28.3238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v36a5eJ1Bypb2U2MVF8ikHgBPpOY92bqibfERjXvVg8ti7jDlzz04a/l36qPtedB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2584
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190011
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 2:33 PM, Andrii Nakryiko wrote:
> That compilation warning is more annoying, than helpful.

Curious which compiler and which version caused this issue?
I did not hit with gcc 8.2 or latest clang in my environment.

> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   tools/lib/bpf/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index bf8ed134cb8a..95c946e94ca5 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -107,7 +107,7 @@ ifeq ($(feature-reallocarray), 0)
>   endif
>   
>   # Append required CFLAGS
> -override CFLAGS += $(EXTRA_WARNINGS)
> +override CFLAGS += $(EXTRA_WARNINGS) -Wno-switch-enum
>   override CFLAGS += -Werror -Wall
>   override CFLAGS += -fPIC
>   override CFLAGS += $(INCLUDES)
> 
