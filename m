Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4EB2B9F59
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgKTAcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:32:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25734 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbgKTAcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:32:46 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK0O4NT032585;
        Thu, 19 Nov 2020 16:32:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hpFzCHYDEPcQb6mMRNrcT+W5Htf6R5zEue1mTswdUqQ=;
 b=NMGs0vfXgjVpP7iLJyHNTxN2ELusMi3xObebUorLCCo69kSNYd69BZaMsGiX9pAi0hzK
 Q/uBVzJwjKoso5apnSbdHjCyq0EcFxeqN1Sli5H7Pcw623R7u1fz14zzRZELO9GrbVNf
 pabfBvGZxqNuThXfwJPIchC8fFZIyYPoLTg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34wdv01jqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 16:32:27 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 16:32:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmiJ0TLtZEhfkpki8KdQkP7EbvrSjEHHNlMZLFyGpdkHQHm/K4dmYWXzuJxQn/Oa5U2GMzL9QmH4wsYJaCBO03ofQvzMGSyqTu4cH/sr7WPp0wvEUgNKQpfuSugTpuBxzK2sCJDZBiws13C0Cbgjq+ltZWukEllp47PUE4U/u/zsakrno3hXI5i6rnoNDZuEBuQd4GZuC29LHr9la+FPJMSXxsz7mnxw5IRqbajTOtRZtQC7HhESVLH6IN25anI/Dx96dVSiCXs0XQnt8UmpvVy8Dmm8t6QKi8H28dtkZ/kLxUEDT1+VltC9/0AEH3Pms+pqgQvzB5vOgJOHgm9Myw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hpFzCHYDEPcQb6mMRNrcT+W5Htf6R5zEue1mTswdUqQ=;
 b=cs5oGly+Hq9bMU1A/s/acTUhQswiRt3kZ+TWlWSqHrYJluWVdBpFweWmTo+zNzoX60YhQ63wWiIlBvDeqHLkAjhc15sm1t/AmUJ3ZKiH9VpqIjFT6ctPKAjMeykf0pcIUEQtiWJkVtw5Ymc31iWvwq/xKJSYBlC2bpCEVZ2mNv4eDzHisPttvNA4a/jwfMxydZCvEnjjUDaGpm9y33ChpnG3rNfi0DLE10cmL5R9fXIxJRTFqM6E9D2zkfMZy6KzBm+49f5oK63B2crZGIdJJ4iRfOLMWsOMrHUdzKI5OQ2xmRYckj7AyKL20cpFI8mug02qoCKRaoRYttRmFRKGJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hpFzCHYDEPcQb6mMRNrcT+W5Htf6R5zEue1mTswdUqQ=;
 b=SAmbhGKORY1U9SQmpNNjmmhzhEEIOyuypdPuRiWxeMJN3lwF/UFQG0vktTBd3XdMYaYWyqPI6XVa6t16X9IoPfMMhRSJp4A/N+cOS1o4sXYdWKwWszQ7UGn2x9Bgnlx3PWhPLVcPnumYtj3a/QpcdqrY/6hMjd99VtltZEfq/rM=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3617.namprd15.prod.outlook.com (2603:10b6:a03:1fc::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 20 Nov
 2020 00:32:25 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 00:32:25 +0000
Date:   Thu, 19 Nov 2020 16:32:17 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Florent Revest <revest@chromium.org>
CC:     <bpf@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <yhs@fb.com>, <andrii@kernel.org>,
        <kpsingh@chromium.org>, <revest@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] bpf: Add an iterator selftest for
 bpf_sk_storage_get
Message-ID: <20201120003217.pnqu66467punkjln@kafai-mbp.dhcp.thefacebook.com>
References: <20201119162654.2410685-1-revest@chromium.org>
 <20201119162654.2410685-5-revest@chromium.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119162654.2410685-5-revest@chromium.org>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR20CA0011.namprd20.prod.outlook.com
 (2603:10b6:300:13d::21) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR20CA0011.namprd20.prod.outlook.com (2603:10b6:300:13d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 00:32:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4981496-6923-44ab-45cf-08d88cebc0d4
X-MS-TrafficTypeDiagnostic: BY5PR15MB3617:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3617D5ED2BEE17CCBAC92161D5FF0@BY5PR15MB3617.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RXWFQwUYS/1WpEQw90KoxmA63nebT+wTnmXpcz7OQdeyX6LBlDZX+/OoSuwNgMck7fJ9eXghbLZsqxaQsoA0tMt85K41ttYKtKyhM8DV0iCiKfbT7w6M+UyqXd+wtK4ziqYafMhJkB9yWKEyHUxvP5b7SzieMtsORQtZud6iCZjFHE8PzFxGLHrR5ViEAnE1u8DG3p+kM93FZ7SPVSSmX3oPhFCGvRzffYc1QjLw+LwsL+9+MJfJGzbtL7w1aIAL2n0l+uEdXat5d1ATsznSWZvQVj7OeKnOUjist5xSbBTxP8OmyQ4igxCI7xTIAZeFE9mL8HyW0MWaTRPkwCfhzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(6506007)(316002)(2906002)(16526019)(7696005)(52116002)(83380400001)(186003)(86362001)(5660300002)(55016002)(6666004)(9686003)(7416002)(66556008)(66476007)(478600001)(66946007)(8676002)(8936002)(4326008)(6916009)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KNC1fy7F+5bxZlTteCT1Cc8LKsJVIHy2KU2tt5gaMcs0OsMbUKIi+ZFhrgv+CvlSt06LXHxPVTU3nthG0R7rBqncfpAziruNw+uhMafGk8ijgGHMhWZPxHOV5s6E1k9Hgc2Rm/0W5FeYmDmZb3t/xJ/y4OsebA/GiFo7cweIL21McT8Mg7zJVQ8MfGE7F26WEFnd3kvh+xq2800/lQbZ4L6ECqWWNhlvv8kb19ItXL3b4tgzxx996+7cgkN1IUQ/iWUqgyVl7bYz2HZIfOLbewAnZEudNSa6ZiTRukmUbrh69QtXjn36gg7cGkPxFNf3l7CkPceuZsebccs9YQpx+GcOYTykrkuWx2HEWshEp8Xv9hEcfmu9W8mQ43w5nyWi68sP0MyyJ+eNDA2MgsIiTM78ZuYRDQ9rxsy9gf2ZTDcEdr7+yi0s/2UmlGBqTFkZxwFQsG6m5aj03QC1khOUbFREvQXKF9+eNmRW0lx3lBogrA064f9ByKI4WMoOuUZIm4T484no0RrkP07KjMhNn7ZdKTEGGigqVmw6i9Z3Wn8NuIrHRr9TSU8BIH/hz4ipJKahCBII643hIgcLire6Us8POFIE268bd0yVipWSYaED33XCcH2ISsJYgljUXDtQjx+7TaHkzh6AoD40M9QNfmXZDJrAl0whIDcXCxqe/YI3zGYJUw31DzCTcY3ah3OfcVDWsQVy4I29wkzWJGXMBm+X1QkIRLhN3DccCzcTLqKWAksnEWhI9zYJuY1hFYZDRFhS5x7GJBVc0ejAbTlPBaZzbMGdr/kk0DZjWgBggRTv/m0MKYYpr+zsIwSrgBTJldaykfVhiUwdmwpkG//EU7C7ZwIbnWS2bFzt9znQWveMFvacf/nms/t+a1rqs+iWlvpoJkk17KnlGELrNqs9JEA40uzC43PAX41SBM0QTXM=
X-MS-Exchange-CrossTenant-Network-Message-Id: e4981496-6923-44ab-45cf-08d88cebc0d4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 00:32:25.6123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEjf0PW3FxmWzNC26Lf2CVNeQhwIgdhkNysQZjubkRsvHxhkb76qK9LHwpbH0Nyz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3617
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0 suspectscore=1
 impostorscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 05:26:54PM +0100, Florent Revest wrote:
> From: Florent Revest <revest@google.com>
> 
> The eBPF program iterates over all files and tasks. For all socket
> files, it stores the tgid of the last task it encountered with a handle
> to that socket. This is a heuristic for finding the "owner" of a socket
> similar to what's done by lsof, ss, netstat or fuser. Potentially, this
> information could be used from a cgroup_skb/*gress hook to try to
> associate network traffic with processes.
> 
> The test makes sure that a socket it created is tagged with prog_tests's
> pid.
> 
> Signed-off-by: Florent Revest <revest@google.com>
> ---
>  .../selftests/bpf/prog_tests/bpf_iter.c       | 35 +++++++++++++++++++
>  .../progs/bpf_iter_bpf_sk_storage_helpers.c   | 26 ++++++++++++++
>  2 files changed, 61 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index bb4a638f2e6f..4d0626003c03 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -975,6 +975,39 @@ static void test_bpf_sk_storage_delete(void)
>  	bpf_iter_bpf_sk_storage_helpers__destroy(skel);
>  }
>  
> +/* The BPF program stores in every socket the tgid of a task owning a handle to
> + * it. The test verifies that a locally-created socket is tagged with its pid
> + */
> +static void test_bpf_sk_storage_get(void)
> +{
> +	struct bpf_iter_bpf_sk_storage_helpers *skel;
> +	int err, map_fd, val = -1;
> +	int sock_fd = -1;
> +
> +	skel = bpf_iter_bpf_sk_storage_helpers__open_and_load();
> +	if (CHECK(!skel, "bpf_iter_bpf_sk_storage_helpers__open_and_load",
> +		  "skeleton open_and_load failed\n"))
> +		return;
> +
> +	sock_fd = socket(AF_INET6, SOCK_STREAM, 0);
> +	if (CHECK(sock_fd < 0, "socket", "errno: %d\n", errno))
> +		goto out;
> +
> +	do_dummy_read(skel->progs.fill_socket_owners);
> +
> +	map_fd = bpf_map__fd(skel->maps.sk_stg_map);
> +
> +	err = bpf_map_lookup_elem(map_fd, &sock_fd, &val);
> +	CHECK(err || val != getpid(), "bpf_map_lookup_elem",
> +	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
> +	      getpid(), val, err);
> +
> +	if (sock_fd >= 0)
> +		close(sock_fd);
> +out:
> +	bpf_iter_bpf_sk_storage_helpers__destroy(skel);
> +}
> +
>  static void test_bpf_sk_storage_map(void)
>  {
>  	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> @@ -1131,6 +1164,8 @@ void test_bpf_iter(void)
>  		test_bpf_sk_storage_map();
>  	if (test__start_subtest("bpf_sk_storage_delete"))
>  		test_bpf_sk_storage_delete();
> +	if (test__start_subtest("bpf_sk_storage_get"))
> +		test_bpf_sk_storage_get();
>  	if (test__start_subtest("rdonly-buf-out-of-bound"))
>  		test_rdonly_buf_out_of_bound();
>  	if (test__start_subtest("buf-neg-offset"))
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> index 01ff3235e413..7206fd6f09ab 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> @@ -21,3 +21,29 @@ int delete_bpf_sk_storage_map(struct bpf_iter__bpf_sk_storage_map *ctx)
>  
>  	return 0;
>  }
> +
> +SEC("iter/task_file")
> +int fill_socket_owners(struct bpf_iter__task_file *ctx)
> +{
> +	struct task_struct *task = ctx->task;
> +	struct file *file = ctx->file;
> +	struct socket *sock;
> +	int *sock_tgid;
> +
> +	if (!task || !file || task->tgid != task->pid)
> +		return 0;
> +
> +	sock = bpf_sock_from_file(file);
> +	if (!sock)
> +		return 0;
> +
> +	sock_tgid = bpf_sk_storage_get(&sk_stg_map, sock->sk, 0,
> +				       BPF_SK_STORAGE_GET_F_CREATE);
Does it affect all sk(s) in the system?  Can it be limited to
the sk that the test is testing?
