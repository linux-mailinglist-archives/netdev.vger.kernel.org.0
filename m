Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4737D28E5AB
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 19:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgJNRpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 13:45:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4136 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbgJNRpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 13:45:14 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09EHZlpc010426;
        Wed, 14 Oct 2020 10:44:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : in-reply-to : content-type :
 mime-version; s=facebook; bh=sJ7WUhoMXlFD3lGX6xcyfW0YLCm8PkcQBpuvGJnt+no=;
 b=OVwZdJwOijZzrYODT1SPCpXo4qIgEdhQs8nY0O33FCTqlrwm9BHqOk3WoYix7OQP9axc
 eNajgMXzCFq6fWEH3PG1519k0Z4ZxOTc9B3azbPm9IwAVqrA6bcmjMRKI02XUKvSpigF
 0MTRZKMAIdac2UapGNlEZA2tGYLkcgbg88k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3458wu0p95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Oct 2020 10:44:59 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 14 Oct 2020 10:44:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFaFAzihUGxSzmMRhEs/P6svgraR6t6a1BvZxnNottOFar2erEfjF6WywN8JAMH08nqxgFf3sa/B+BMZyipsVqNqKUz/Kjlwmfw/OQrgO5mshACDgTBn67T/sx1uxNK81KWZdvPzu3k3I8oznNwB7dviQH/7sW+g8Q8ocCAa2W673XdfSNBpaFp1AKKpN46tx+2VLugPa9hyvgWTmP4Gp1T4W1IP7aCWu8IDtqa7VS5m72KCtR68LfNId8wv+ctWMFC3g87g51b84vBl+2DqERyMBNrK7BhSVUdV9s7zwQFs/8ZZw4BgeCOhHMmnn17ziaNWu5pmCOTRrfn8Mmldsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJ7WUhoMXlFD3lGX6xcyfW0YLCm8PkcQBpuvGJnt+no=;
 b=fFkBbggxj5PU0AGHm2+OZlJqCm3LcvPc0oaArVOQTjmWsMOj/4Qlktj4zga3JYo6LlOFVkjnn3L6g4CSWsXPmMr2jtYfdrYglIZtQ9cMvCjRrnBGFLQZHSoplfdrFM/B02fk8fu07ZBL2D3oQu6t5VZzQIOZnMWaoMcUUjdKd4Yy6yJ/b6JUZbFj2E5pYFHVmDODhEvc52C17+ZUxKy8/ZEHJjUxfqO/+1OOK8HGszJkdsLezPpeLNbMmmyaZIFSGT4nsRzNhUIMx9LcsqeCdYdC0pJnp7CFLzhhrVvshoncw7YyvWkALPmGZboS95F8drMOVM3bXsuBd/PL3+0mJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJ7WUhoMXlFD3lGX6xcyfW0YLCm8PkcQBpuvGJnt+no=;
 b=F0fnaL/MyxIvup/jJD7xzfwqnjnRrnY8XDa/mmhkZ9Qz2B4o01NnQ4VkAefwjbvM7aUiZvyO/A/riWfYKpI5rROHicLU/y5VIxYYYqS9fw8Oph0vskBEcKGDF24T/vXej5Xb4bVxuEO1+lIR/3C5i8HaAIf5P5hF2UayDM+Y2+0=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2565.namprd15.prod.outlook.com (2603:10b6:a03:14f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Wed, 14 Oct
 2020 17:29:17 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3477.020; Wed, 14 Oct 2020
 17:29:17 +0000
Date:   Wed, 14 Oct 2020 10:29:10 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH net v3] net: fix pos incrementment in ipv6_route_seq_next
Message-ID: <20201014172910.dunuzshlpknbl2wt@kafai-mbp.dhcp.thefacebook.com>
References: <20201014144612.2245396-1-yhs@fb.com>
In-Reply-To: <20201014144612.2245396-1-yhs@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:e734]
X-ClientProxiedBy: MW2PR16CA0023.namprd16.prod.outlook.com (2603:10b6:907::36)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e734) by MW2PR16CA0023.namprd16.prod.outlook.com (2603:10b6:907::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22 via Frontend Transport; Wed, 14 Oct 2020 17:29:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92436295-46a2-4362-5e37-08d87066acef
X-MS-TrafficTypeDiagnostic: BYAPR15MB2565:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2565DED6BC0F30ADB2BDF358D5050@BYAPR15MB2565.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGUpz+VlJhvc+iGpNeMg2iO8fTDrYJwDwekmnMfT0R0ppBaIoB68PbrWXkWuNqp2u1pYS/j4Yv8mi99es9tDWIz4XYkfbMcKeLLA+v2l3B7+ZCKhe5f8h1ZpZugglpUOUeCjPR+IGzrxjiOtTO5pWqDRcRZB/xzAxM9T5K8oriqyGJS/BDCmbihi1bgLNHKMtwb006/3iqV/Hs3FSB7rAwVIpoQ6Rtq2l0JBOShG+CQsJ2zZIg436XW1D6XEhyyW0l7+OoAlPCtKP8gmheOVYd3BOPCp06d2WY2vUI+RMG0cSNCYWVmqHI6UR1ttgwkOfd6KZeUWYn0T0JMk2Ira1PCEAdQbBzeeEoI/g0l7epm5r5CV6U11U1zsZS42aBHe0oQK7xXzikXF2yGdXETrjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(376002)(396003)(366004)(8936002)(86362001)(66476007)(66946007)(16526019)(66556008)(8676002)(966005)(6506007)(6636002)(186003)(2906002)(55016002)(5660300002)(1076003)(7696005)(478600001)(316002)(54906003)(52116002)(9686003)(6862004)(83380400001)(83080400001)(4326008)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Hfftb3LpmMB8XQgq/Ie2Qpi+y9drW1ZXGxwPeXhSAwSh2ry3l668PKrCuCoVxSLxYpX9F2gMDGzkPX65BpDjhqaMGidvma7WMykpH6S3l2EpZgWwhwu/gH4sXg3ORLwarlWzPV/LotT+YZbSsGoqRcQ7DqH4Y6nAtjj0+2GEguE+cONU+sRUi3ZtQ3xUrJG2k3StBofqJuEfTIEXf1h4OYIJFLv3m/FcIve3OifdTNlsn5WA/oJ/nDCbp2UUZ+41hblWr0drhOpcxGdIFX8IMsZ/7gAdEtNHpIEdCRwsNukVh41yIy8LoxhNudLfbIkiliBW26uVBEAy5eWzbs3zqjz2GS1k179ALclGYOvau+IjxsL6VlfwAzAV5pmdV9YWRVFkaFKRBr/j9aIVPKu3jK7X68vZiMEa3kD5vE7SZGyvdGn4iXA7V2mF8+WqmyTwp62RWwzVmeG/DtbyVrCywckdtK13sCf3jj5E5hHgKISAiXnspGc/8hoHL6hyj8hxbtpAr2MKLk0OVnXlgI/jDXxovhWIvJGzjOBqBEKdtnF2mmRk0GHcqXKyixUSdgMlUBOIMfOI9JdYgFLJzo6RgjW8YrTB1YR6owrPQm6Jek1FryB83s441pa2OyTC/yXCpCp0UtY5gP7HrPwiFUvrxr8qXv6XZcFqfMz4+s9IBgI=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92436295-46a2-4362-5e37-08d87066acef
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2020 17:29:16.8535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fvZSm2hABgqBpbkss9q3W29t4X/GAbuscE036yoeeuPBJ2yNqmaLbT9flMpnaoyy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2565
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-14_11:2020-10-14,2020-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 07:46:12AM -0700, Yonghong Song wrote:
> Commit 4fc427e05158 ("ipv6_route_seq_next should increase position index")
> tried to fix the issue where seq_file pos is not increased
> if a NULL element is returned with seq_ops->next(). See bug
>   https://bugzilla.kernel.org/show_bug.cgi?id=206283
> The commit effectively does:
>   - increase pos for all seq_ops->start()
>   - increase pos for all seq_ops->next()
> 
> For ipv6_route, increasing pos for all seq_ops->next() is correct.
> But increasing pos for seq_ops->start() is not correct
> since pos is used to determine how many items to skip during
> seq_ops->start():
>   iter->skip = *pos;
> seq_ops->start() just fetches the *current* pos item.
> The item can be skipped only after seq_ops->show() which essentially
> is the beginning of seq_ops->next().
> 
> For example, I have 7 ipv6 route entries,
>   root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=4096
>   00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>   fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>   fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000004 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   0+1 records in
>   0+1 records out
>   1050 bytes (1.0 kB, 1.0 KiB) copied, 0.00707908 s, 148 kB/s
>   root@arch-fb-vm1:~/net-next
> 
> In the above, I specify buffer size 4096, so all records can be returned
> to user space with a single trip to the kernel.
> 
> If I use buffer size 128, since each record size is 149, internally
> kernel seq_read() will read 149 into its internal buffer and return the data
> to user space in two read() syscalls. Then user read() syscall will trigger
> next seq_ops->start(). Since the current implementation increased pos even
> for seq_ops->start(), it will skip record #2, #4 and #6, assuming the first
> record is #1.
> 
>   root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=128
>   00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
> 4+1 records in
> 4+1 records out
> 600 bytes copied, 0.00127758 s, 470 kB/s
> 
> To fix the problem, create a fake pos pointer so seq_ops->start()
> won't actually increase seq_file pos. With this fix, the
> above `dd` command with `bs=128` will show correct result.
> 
> Fixes: 4fc427e05158 ("ipv6_route_seq_next should increase position index")
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Suggested-by: Vasily Averin <vvs@virtuozzo.com>
> Reviewed-by: Vasily Averin <vvs@virtuozzo.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  net/ipv6/ip6_fib.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Changelog:
>  v2 -> v3:
>   - initialize local variable "p" to avoid potential syzbot complaint. (Eric)
Acked-by: Martin KaFai Lau <kafai@fb.com>
