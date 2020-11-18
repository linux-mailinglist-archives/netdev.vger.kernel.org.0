Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C3C2B7633
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 07:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgKRGQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 01:16:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5960 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgKRGQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 01:16:33 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI69is7028257;
        Tue, 17 Nov 2020 22:16:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=lL5lFs1lZG3zBxaNvZDK7MzTP/K7KYbDPsQ7wFD0bVQ=;
 b=ND75TdCIaYVGSsk/n6FVyJApB1qz10P859Z8eOVI5cib+JI7CGAu6h2bg25Kid8jqXZX
 MNW4AAoSbARNom8nVPwggopmkxprxKoupk1auLB8ARTCVVn+EwXje7i6NlG3t9ZgSYPN
 Rb6a8AgoypfD/C7UvG0HKjWF2IdRI0JWgbQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34vhjpvsm6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Nov 2020 22:16:13 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 17 Nov 2020 22:16:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9Gb/WsgmurggL9DQxy6Jyc8UHyjSIcWMpc1mfQq3W2sVZ6GJ6u5E3TrO8DMRj9YL50navqYwpsVwMHSPht6YlB7CWitwdUBbNhTB/Y4Y5r9hvvdTnX10vWzzYGiPl0Qow3SsiqHI9EgCw64Nz1wp5akEdi5PPa3175DiZG93tOLAYihwk1eay87+BDH2+3vxehiEZ+KNsrqCNfzL++DpCS+o74ASauhJvbJxpMvDooCcvnFMF9eb6OF1JjV7IoVVgGhgwKBvrAuFW9EFDOwcO3+m91JH8KjyYKj1nMzwy+aURvLio2JjIzD0ZknLCZZsCe48T0A25Mvp1ZhZ9V+kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lL5lFs1lZG3zBxaNvZDK7MzTP/K7KYbDPsQ7wFD0bVQ=;
 b=CXIZ7b5Xbjy8NIe7F27ocxls902GR2rEbbicJXDkxzgiyeDJ0o0Te/jqRWFARsGP9P3qdwPZxBINGlQfIRA2fFlcBLtx1ZkrpNbwGI5hjTrIRw+7AsnD3qgdLJNet9C8wx0COQ7D59XRIB40tAaugAOSccbQUyUBp9SRVftQULol9WvAk4y01o/8qscJ91GyqQMO4hF15jDqIVMEiYfVf6/71TMNOMflgrz7m5AHbHvnDnMljGjIWWH68qYOW5LIcTAc1c5TgTqACYWsWGbQ2+eHhEdoeBxHN4/g4rajdJwxwkCFgTcZD/VBetoLnr0ihwLO62SPwIlB3tbJqNYGDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lL5lFs1lZG3zBxaNvZDK7MzTP/K7KYbDPsQ7wFD0bVQ=;
 b=WCBhDyiDlAIgZTsQlsB/MsBL4bDpiuPrvPAMiD3b8YtxM/TUFxDDOWd04n+04NCrSTqXHW4SsZAYY455+t9CdTE921Zu+gXwi/sxJp1EPsmZBWTxN223LsKa8efZ5IuYZOqGBtZkvQ8edRqsCcBFp+c6VqxWpvWfO+zLnW3snEo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4233.namprd15.prod.outlook.com (2603:10b6:a03:2ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Wed, 18 Nov
 2020 06:15:57 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 06:15:57 +0000
Date:   Tue, 17 Nov 2020 22:15:50 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/9] samples: bpf: refactor task_fd_query
 program with libbpf
Message-ID: <20201118061550.5wiwkdxyo4bf7bfy@kafai-mbp.dhcp.thefacebook.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-5-danieltimlee@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117145644.1166255-5-danieltimlee@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MW4PR03CA0160.namprd03.prod.outlook.com
 (2603:10b6:303:8d::15) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MW4PR03CA0160.namprd03.prod.outlook.com (2603:10b6:303:8d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 06:15:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88c16acc-4487-4db1-f6a8-08d88b8969dc
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4233:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB42339164D7AEAB920E636A96D5E10@SJ0PR15MB4233.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:168;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: di8rg47bOKcp4yP5vNL1QnV5AhFhWidf9uPhXnWyKnnXWtX0RBWPJAgP1Nd7o1l7FS91N9BQu+Sf/Mncv/iHJ16mCzpvTCmBXWHAHjp/f1kZzpS8gk31AajAJoD/8173J7si26IoCCHrP0Kfo6UF6pd4npNukcDybSQKzSA+8l4GO20swjC76Yu1MFJgpeabQab42/g71SmvNK5aL2Riux79JeEDbk1uhqK1WMUxvbmLGgEEKv27N8JFcHQBXiboTvB0ZQkD4MptYAgjrk4hv6sX5DHCYuw9VzaMM8ADWnSWWkbf2KMafVr21tM8uDQJF/+Nj2lRCcrRXQYgwhNTgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(366004)(346002)(376002)(9686003)(6666004)(55016002)(508600001)(83380400001)(54906003)(316002)(86362001)(186003)(1076003)(8936002)(16526019)(5660300002)(7696005)(2906002)(6916009)(52116002)(8676002)(6506007)(4326008)(66556008)(66476007)(7416002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mOxwqTSzrWlUCXKFIioMHube7IsLof80qwdq8aMhbP+J+1NdPr3/HPYKvH9pMRDxTtzm44d3iN6gvutFb5T+3hlZGhn8p8UQqlTye7Mkfw8PunxTZBANjCxqh3iJhqAs2xsuxyO1Y8QkqGti/XrGzauCZGxacNVvbAu4yzgusRQPB0vUCFr0QJ7ONA7+jsewd5GZ6H7noOOxBMGl50AqMgDoewagoz6ACGmR6lI0EKBHW1s5HE04z4+nReMIqICwcZR1psmVZ+yNPITirFCsyRh3/De4qCkTlQXCTR9iqDIzpmJBfMkczrh6yV5OE427fuzoyQXXsHi71eotY6gBdx/19+GbOTn4mE3ormi8zr/ZKUEEE4PXiZD0Z0F0hUOFRELmUUxhvYRvK0Ip0p/5vvDzZoM9zv1khpXnnB3/MMmdNzh0pMwC5yAqH3Cq1nFvAJz9pbOnf/4l8xYD2AT2ngcfpwRZVoCHA+Q1/HOqkAU6FVjacam04+5/L0jRoZKiefTZY3f41qTZSZyRq2ZXeHPZmqOC3QjTk3t+uWomi3vBN/JGMvRoVLz1WVpu6KKmB228jAPxnCO2mtYg/tqbYjX0bmfYfE9R4tLvWM88VTyg7dXboTiPfKsZlGh+NnCmJw0nZrrLPUWKz7KqwVngyMH3R0HoEHxkFHKzWFVy/NyUO7XprxvgXiy0dSiVPpCnvFgI7xmXk1m2M/KO2AlD1Wcmy0xpAbqYzG4vpRyqE2T02aEer3RhzTofk94YOrnzMq0JJL7UjPUkknLl7pUOalmnCybaYBRJilIoTjIccl4YHdYzv3nwX4FtNjOpz5glNQ98cfiLlhfL0AS7HKRaYhCH10Qc3GXailaQlYe+d5WNPF0Kumv/rwuSU2DjzYM2cviqiu7xYHrUOSMDWh3l/It1lzqW28QS1S/t91hxRew=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c16acc-4487-4db1-f6a8-08d88b8969dc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 06:15:57.6883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hsctq9Vqoszn2nGN4pmOkgl/6w5F4ckuSkz3bm+WRcdb+pwxyaDH9c4hE8k1zKvA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4233
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_01:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=1
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011180043
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 02:56:39PM +0000, Daniel T. Lee wrote:
> This commit refactors the existing kprobe program with libbpf bpf
> loader. To attach bpf program, this uses generic bpf_program__attach()
> approach rather than using bpf_load's load_bpf_file().
> 
> To attach bpf to perf_event, instead of using previous ioctl method,
> this commit uses bpf_program__attach_perf_event since it manages the
> enable of perf_event and attach of BPF programs to it, which is much
> more intuitive way to achieve.
> 
> Also, explicit close(fd) has been removed since event will be closed
> inside bpf_link__destroy() automatically.
> 
> DEBUGFS macro from trace_helpers has been used to control uprobe events.
> Furthermore, to prevent conflict of same named uprobe events, O_TRUNC
> flag has been used to clear 'uprobe_events' interface.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/Makefile             |   2 +-
>  samples/bpf/task_fd_query_user.c | 101 ++++++++++++++++++++++---------
>  2 files changed, 74 insertions(+), 29 deletions(-)
> 
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 7a643595ac6c..36b261c7afc7 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -107,7 +107,7 @@ xdp_adjust_tail-objs := xdp_adjust_tail_user.o
>  xdpsock-objs := xdpsock_user.o
>  xsk_fwd-objs := xsk_fwd.o
>  xdp_fwd-objs := xdp_fwd_user.o
> -task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
> +task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
>  xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
>  ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
>  hbm-objs := hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
> diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
> index b68bd2f8fdc9..0891ef3a4779 100644
> --- a/samples/bpf/task_fd_query_user.c
> +++ b/samples/bpf/task_fd_query_user.c
> @@ -15,12 +15,15 @@
>  #include <sys/stat.h>
>  #include <linux/perf_event.h>
>  
> +#include <bpf/bpf.h>
>  #include <bpf/libbpf.h>
> -#include "bpf_load.h"
>  #include "bpf_util.h"
>  #include "perf-sys.h"
>  #include "trace_helpers.h"
>  
> +struct bpf_program *progs[2];
> +struct bpf_link *links[2];
static
