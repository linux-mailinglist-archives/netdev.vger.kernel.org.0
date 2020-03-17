Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E239187935
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 06:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgCQF1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 01:27:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35836 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgCQF1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 01:27:35 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02H5LFdR027189;
        Mon, 16 Mar 2020 22:27:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=x4u38VO9fwTl2TZnFe8oY04nk4r2b1BjDqnZ8L1L1tQ=;
 b=jdJaj8KH0UaWLD2Jl0swltZBCA6yUYiNtBTq/xcnEh6FXB786U0EeNJmLCC27Et4wmBm
 mrCpX43ABYF/f16V7xUG0ZkiUUYHTz5RRJYJYG9XPexch9FqiaI+t6vRSMWFfg9iMOzd
 YpJXB7tfBmDC3PJd4BXHkYVsj+qhFpKRVoc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf370gja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Mar 2020 22:27:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 22:27:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edupNR4endamJ15sj1tVWYVZO37G71KJa/QT78b48IBzYPmV22tQIcBz17CjAyWHNOgU0hYN8R/ikwUNXuUI1KSE3GA1WWfeZOyEVzI5H0xWKuI5Gd0bxdwwHek8Gq32qfolwSHsRpTS8tzkMmk7/Ft8ZgCCaB7r9yQJjCVjCCYxVeF4AFNBBgFfhWKVcLc1OQTxNVheM/O4tdMSwE9j/k+vysM82i5TeF8LXjHHggyVqL5vKc4TeW10MexRdWyNMYSX5/no7EvZ1LB9egN34ed7Q0lrUgAX7NhcQp3bJ+E/hNOIT0IbGpGRiNw/Yc8P/8sB6WQzQ/ibT+cr/sCorg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4u38VO9fwTl2TZnFe8oY04nk4r2b1BjDqnZ8L1L1tQ=;
 b=QbRRxMd/A9XqACvnPaEbQ4Wgk7Mh35EYNUNSYvCA6rTSxdPOQ1DAfVNJsIZyJZWY5r3R6ZBATCngXLaceDRDuFr1CMFnP3gC0YSn9f+3RQxjSXrY+QFEu2uMOfr+hGN0BHSe//0/RCufyN11jounlAEmxh/dp0p0HhcX7Mk8Qx5+QpPN06ujUTdllx05PByqf/6KqrpiaJjaSuRCTkCERgKioCVow9boHhK96THXFfJpyOc96oVrT1b2NmlDw58NZRMAPMT2c+nwU0ES5GqIuIQ8sBC2k0Ku12NHKwCV8X9Di92/V4X4i0AlbNCkeGF9F9oey7j/sewXVjvXfqLMkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4u38VO9fwTl2TZnFe8oY04nk4r2b1BjDqnZ8L1L1tQ=;
 b=kXUqWPV0MqiegF+FwoKXq/+ME/lvul6W0pEONe133+SYLkvRNnzDXf8myrTEINXfEH8azfbRTjxRxXr8+mFe3eZ0glzYiWr44IbwAzCcfvTNQjPUd065Yq68/1oe2+EtGTY5iAW/wSZhiO4NGkvxWjDfbCopsr8GVXSUFbLVBbE=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2664.namprd15.prod.outlook.com (2603:10b6:a03:15a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21; Tue, 17 Mar
 2020 05:27:18 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 05:27:18 +0000
Date:   Mon, 16 Mar 2020 22:27:15 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 1/3] selftests/bpf: fix race
 in tcp_rtt test
Message-ID: <20200317052715.xnof2rdecrmkep7v@kafai-mbp>
References: <20200314013932.4035712-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314013932.4035712-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR1201CA0006.namprd12.prod.outlook.com
 (2603:10b6:301:4a::16) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e745) by MWHPR1201CA0006.namprd12.prod.outlook.com (2603:10b6:301:4a::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21 via Frontend Transport; Tue, 17 Mar 2020 05:27:17 +0000
X-Originating-IP: [2620:10d:c090:400::5:e745]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc9a2282-f889-45b3-3af9-08d7ca33dc21
X-MS-TrafficTypeDiagnostic: BYAPR15MB2664:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB26646B240E97F607CAD6CD86D5F60@BYAPR15MB2664.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(366004)(396003)(136003)(376002)(199004)(52116002)(16526019)(186003)(1076003)(5660300002)(6496006)(4326008)(66946007)(66476007)(66556008)(316002)(33716001)(8676002)(81156014)(81166006)(55016002)(86362001)(478600001)(2906002)(6636002)(8936002)(6862004)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2664;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmxtDggogPrfn6Y/PSzkmtLfTUFBqrCOv4CGvLxgKKJEaRHKnAOFo+lO5i5ysN8K6pDCd+kRURLBu02mb43F9Cpp4wAPiO/nJC8MwbMNHEjQaQ3M7oaaoR10QUCHYm5aGVub+9QLUbu8y7z6SQFXokm0quwtpDayHM9s7KEOxnhjsiAZZxnkdsKlzv0YffIhce7K8vBPUPWeWYQGwVmLWbUmlSj4bHQiHLb91Fkh6X9w06yLiUNYPZqT0mnhPsDkaqdhGpfFXLllVVAt6x2LkVJnYLuy4OuT3UpXRXux0ToMFBp9Vf+NIJG/SZjHJlPpZVIR0Jd0vGMgOFtZVkmAFmfabqIarwXs9+130yXrfCAUSclSLaSS0gldwkAEO2trd14n2/bGpwEYNU1LGGGerEVXMZC6PxUtm7m4iUbWn0TONqaZIM77pTC2r8WRS7I3
X-MS-Exchange-AntiSpam-MessageData: ljcV30xRlNw+AEnxNSf3BojcBcvLYdCqoSh0oJCU2xfoCnmPekTPepJ4Es5pBnPOs3mPCHhzuQGyyd2YGL21u2rjcpqX1CQ6FPAYfYiohdmt8TR2Gu3wob0R1TtvvD/07uQrthqPY3FZjN98lhK4UGIWoAQ+CT6pToW98DuB+wsCLxdI6/L4xXn834gRI/WO
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9a2282-f889-45b3-3af9-08d7ca33dc21
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 05:27:18.7999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZnDjamuU3PeTwXYc9bMFfZeK2FDLbLhTOU5xLoHObmUiLQ1Z62Ouw2gm4vQvWyb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2664
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_01:2020-03-12,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=897
 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170023
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 06:39:30PM -0700, Andrii Nakryiko wrote:
> Previous attempt to make tcp_rtt more robust introduced a new race, in which
> server_done might be set to true before server can actually accept any
> connection. Fix this by unconditionally waiting for accept(). Given socket is
> non-blocking, if there are any problems with client side, it should eventually
> close listening FD and let server thread exit with failure.
> 
> Fixes: 4cd729fa022c ("selftests/bpf: Make tcp_rtt test more robust to failures")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/tcp_rtt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> index e08f6bb17700..e56b52ab41da 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> @@ -226,7 +226,7 @@ static void *server_thread(void *arg)
>  		return ERR_PTR(err);
>  	}
>  
> -	while (!server_done) {
> +	while (true) {
>  		client_fd = accept(fd, (struct sockaddr *)&addr, &len);
>  		if (client_fd == -1 && errno == EAGAIN) {
>  			usleep(50);
> @@ -272,7 +272,7 @@ void test_tcp_rtt(void)
>  	CHECK_FAIL(run_test(cgroup_fd, server_fd));
>  
>  	server_done = true;
> -	pthread_join(tid, &server_res);
> +	CHECK_FAIL(pthread_join(tid, &server_res));
From looking at run_test(),
I suspect without accept and server_thread, this may also work:

listen(server_fd, 1);
run_test(cgroup_fd, server_fd);
close(server_fd);

This change lgtm since it is NONBLOCK.  Ideally, may be it should
also be time limited by epoll or setsockopt(SO_RCVTIMEO) in the future.

Acked-by: Martin KaFai Lau <kafai@fb.com>
