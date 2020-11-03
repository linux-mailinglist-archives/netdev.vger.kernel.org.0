Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62002A37EE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgKCAjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:39:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13470 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725921AbgKCAjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 19:39:03 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A30SC0d005148;
        Mon, 2 Nov 2020 16:38:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EWBl/WlH6yGa3ijJbAhGR+8qU8TNX0OLwYekVgfLpzQ=;
 b=AVTNCtiYV0K0N5znCn+n9FXcCOLrVYmvKJoh6cQBnOvvWW4p5yA1F6l/xKLmpuCMvkTg
 fuxxBOR9jmQMCFGxBwAUI6HC7ur5+bRP2G7VW7htEhhTuDvRpww8cj8+nc0EkfLrPt6S
 AMJUgw3/jKy59+xgMAAnwdREXBcQq5bG3Eo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34hr6p08h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 16:38:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 16:38:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ny86PZwkiPY74QgsbOdHMcvuPsoS8ZcIQp+UGdja2fw3tqxTvTFMi3qHjoL2B4FA8QwlE//SDikDN/suVKAB7/XFSGtUGKx/Q3zZxjXTGZ4PfNhyI6B8MOSqPHw+PMjYOb8uPLaQFWxmTnzc53bryOsWoPXOqz8UDA2CZBlF5qNP3NKwgdXSBb0PzpZx52TS2ETEj0j+noK278zwL/I/a1F7lWvQULCQ1NKVkpdELhsTRrzv7jJ842lDHL4VbSsj+SmZHcNUWS99ScXnvNjhAw/2ezC4CKCtnPmmk6Z7Utizn6OfWNrDvsuewi6LT3gJ+rz1gWXNZ9iCG8U4DmPl7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWBl/WlH6yGa3ijJbAhGR+8qU8TNX0OLwYekVgfLpzQ=;
 b=iNPxcwF0xLYOKMvrWykJMLKa2mdhbTCz+WPGUW+/2USieyPd11t2knNwZwb6TH8MxcGqEw3cY7HvL62tUG6VIhco2YvVlF/NYoxacuC8Q6DFQYcHvOBAVLzuNathpBrV3qR24zhrSeQuTpXDf+v6S6BFsN+JFKEAXhjFeo92v3rihkzGk0taGQH6CFPUzxkQxSw/klsgjy8RzZKP1JRuHKdxH1umKXtxdcRgC/1LzfnAtqaalYaA7v/+6fbv298eyowS6d0meZ+uDbG8LhCjiIkOXjHjNo+4RdFExXFlFG2Jki7YVdAKW2d5K/VlBmlEZDVbAok9puRZUwVF7fmhgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWBl/WlH6yGa3ijJbAhGR+8qU8TNX0OLwYekVgfLpzQ=;
 b=j/mTieB8aARntmIhxdXln7dfd/vNpypMZ5K3ViuMxv0bjR7c1MTa+PQDkYGJanKJXBaOiFl9HOAvuyzuROvVhOKSxTA+9SRUpKeETU8bjvLpx2VRJHx9KmZV1cp8gNdX8qsI48ZaC21aBA/JRrTewQ1jn+KDinY45Syg4viso/A=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3254.namprd15.prod.outlook.com (2603:10b6:a03:110::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 00:38:43 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 00:38:43 +0000
Date:   Mon, 2 Nov 2020 16:38:36 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, <edumazet@google.com>, <brakmo@fb.com>,
        <andrii.nakryiko@gmail.com>, <alexanderduyck@fb.com>
Subject: Re: [bpf-next PATCH v2 2/5] selftests/bpf: Drop python client/server
 in favor of threads
Message-ID: <20201103003836.2ngjz6yqewhn7aln@kafai-mbp.dhcp.thefacebook.com>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417033818.2823.4460428938483935516.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160417033818.2823.4460428938483935516.stgit@localhost.localdomain>
X-Originating-IP: [2620:10d:c090:400::5:8aa6]
X-ClientProxiedBy: MWHPR1201CA0022.namprd12.prod.outlook.com
 (2603:10b6:301:4a::32) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8aa6) by MWHPR1201CA0022.namprd12.prod.outlook.com (2603:10b6:301:4a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 00:38:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6d6e67b-e598-458f-481f-08d87f90d144
X-MS-TrafficTypeDiagnostic: BYAPR15MB3254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB32546ECD2A68187DB6FE1C60D5110@BYAPR15MB3254.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XofFRnnqEuI3aaxosURqWFMuGWzZL61aJ4Nyc+pDA/k4o6nXIx1OU2GKIWbDcfmAaAgzB/gEGz+BjdcHHMcM7gvTb+qRODYW/gtvXY9IXs/OjKUv3TM/pxXmdYmtseqWxmAvhwc+rjaL2kHJi769tf3IQMAOh6Cy+yD2fL2q0Jw8f8jH+BxAhnjGoaAgv7ZnllPL7TshU1RNXCLxr0X9hXRpU++4GJ03IOVDjcFPeJ3pTi4Dsjqwx0Kz7Nmzg7Ejfrn3HZdCyRrDco6BLb/NTXYPpkZtU439gZ77LKBfP/jsPUNZGA7N5rwtqkP8gsyJ/O8kGymJbbpmQ3x3Bh2sQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(55016002)(478600001)(5660300002)(6666004)(66476007)(2906002)(9686003)(1076003)(8676002)(8936002)(7696005)(52116002)(6506007)(66946007)(83380400001)(86362001)(4326008)(6916009)(66556008)(186003)(16526019)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Qvl5upRX+ibiILObBHNPKPG+QG0UQqP1nFUX7Wg0qD8rlVhXDTF5yzQ+KUrskQ1LhriMLjoWqiz2bMLow6IRvBsTxsqkNnkIKC3HxfgOcb1H7E5h8iIZDNIYRmGgZNgFjPrhwDgSwFQoBD5n6q2ZJ4XA+JBCW7qWF896cmxsxEGkbei9Zki+AsKA86dr3qJz5CUhp2wGI8KBu6OpiDPafZMeKeJnSzlpkbazKXrM59KoCtKtf4Epf2Dd41a6+UtiL+OBeqqQxv2mNbjkUw/khM7IAN81kX1FvzzwfdPfYz6qFhvHm08qczRAC0UEwKL5NpNw7+t2JzZVAoWvjDPPisio+9WJMMkSsHBgS3kIMJVWZDO3pL1XD8HOcK3DTNJrLlI20Z46nAuse6I+TyAQMduuBL+d28J7ghy6zpfnEITTZ3gQ8SZro/uRXQqdQu/t1uVN4l2Wuv9RRISGhhaIJpN0Be1PSQoqLZgsiQYuWp7z2R4Fa6Fv89miIxStv3iiY7A1+9MxBjT8fpP1gDmuIdMoVOVMr7ojyzixYnpfkwwa431hUHqtrc39Fw4OE5wZ75Kd54O4yPWBtbWptRgIfxN0qnFm0K5Re2bbNwnql4YtAgPya4vHXdPXaQS9srhEux/cnYpSpQOLrgP1NNbg70/N/Y/tLb89y54KD56C6yw=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d6e67b-e598-458f-481f-08d87f90d144
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 00:38:43.8434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oc8xFw0Owm96G3cMnY8ry6pUiSVUKJDuyYqR7yDuqO7Gpwl5aP1LA2B7fqK85wY4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3254
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=2 mlxlogscore=999 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 11:52:18AM -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> Drop the tcp_client/server.py files in favor of using a client and server
> thread within the test case. Specifically we spawn a new thread to play the
The thread comment may be outdated in v2.

> role of the server, and the main testing thread plays the role of client.
> 
> Add logic to the end of the run_test function to guarantee that the sockets
> are closed when we begin verifying results.
> 
> Doing this we are able to reduce overhead since we don't have two python
> workers possibly floating around. In addition we don't have to worry about
> synchronization issues and as such the retry loop waiting for the threads
> to close the sockets can be dropped as we will have already closed the
> sockets in the local executable and synchronized the server thread.
> 
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   96 ++++++++++++++++----
>  tools/testing/selftests/bpf/tcp_client.py          |   50 ----------
>  tools/testing/selftests/bpf/tcp_server.py          |   80 -----------------
>  3 files changed, 78 insertions(+), 148 deletions(-)
>  delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
>  delete mode 100755 tools/testing/selftests/bpf/tcp_server.py
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> index 54f1dce97729..17d4299435df 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> @@ -1,13 +1,14 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <inttypes.h>
>  #include <test_progs.h>
> +#include <network_helpers.h>
>  
>  #include "test_tcpbpf.h"
>  
> +#define LO_ADDR6 "::1"
>  #define CG_NAME "/tcpbpf-user-test"
>  
> -/* 3 comes from one listening socket + both ends of the connection */
> -#define EXPECTED_CLOSE_EVENTS		3
> +static __u32 duration;
>  
>  #define EXPECT_EQ(expected, actual, fmt)			\
>  	do {							\
> @@ -42,7 +43,9 @@ int verify_result(const struct tcpbpf_globals *result)
>  	EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
>  	EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
>  	EXPECT_EQ(1, result->num_listen, PRIu32);
> -	EXPECT_EQ(EXPECTED_CLOSE_EVENTS, result->num_close_events, PRIu32);
> +
> +	/* 3 comes from one listening socket + both ends of the connection */
> +	EXPECT_EQ(3, result->num_close_events, PRIu32);
>  
>  	return ret;
>  }
> @@ -66,6 +69,75 @@ int verify_sockopt_result(int sock_map_fd)
>  	return ret;
>  }
>  
> +static int run_test(void)
> +{
> +	int listen_fd = -1, cli_fd = -1, accept_fd = -1;
> +	char buf[1000];
> +	int err = -1;
> +	int i;
> +
> +	listen_fd = start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
> +	if (CHECK(listen_fd == -1, "start_server", "listen_fd:%d errno:%d\n",
> +		  listen_fd, errno))
> +		goto done;
> +
> +	cli_fd = connect_to_fd(listen_fd, 0);
> +	if (CHECK(cli_fd == -1, "connect_to_fd(listen_fd)",
> +		  "cli_fd:%d errno:%d\n", cli_fd, errno))
> +		goto done;
> +
> +	accept_fd = accept(listen_fd, NULL, NULL);
> +	if (CHECK(accept_fd == -1, "accept(listen_fd)",
> +		  "accept_fd:%d errno:%d\n", accept_fd, errno))
> +		goto done;
> +
> +	/* Send 1000B of '+'s from cli_fd -> accept_fd */
> +	for (i = 0; i < 1000; i++)
> +		buf[i] = '+';
> +
> +	err = send(cli_fd, buf, 1000, 0);
> +	if (CHECK(err != 1000, "send(cli_fd)", "err:%d errno:%d\n", err, errno))
> +		goto done;
> +
> +	err = recv(accept_fd, buf, 1000, 0);
> +	if (CHECK(err != 1000, "recv(accept_fd)", "err:%d errno:%d\n", err, errno))
> +		goto done;
> +
> +	/* Send 500B of '.'s from accept_fd ->cli_fd */
> +	for (i = 0; i < 500; i++)
> +		buf[i] = '.';
> +
> +	err = send(accept_fd, buf, 500, 0);
> +	if (CHECK(err != 500, "send(accept_fd)", "err:%d errno:%d\n", err, errno))
> +		goto done;
> +
> +	err = recv(cli_fd, buf, 500, 0);
Unlikely, but err from the above send()/recv() could be 0.


> +	if (CHECK(err != 500, "recv(cli_fd)", "err:%d errno:%d\n", err, errno))
> +		goto done;
> +
> +	/*
> +	 * shutdown accept first to guarantee correct ordering for
> +	 * bytes_received and bytes_acked when we go to verify the results.
> +	 */
> +	shutdown(accept_fd, SHUT_WR);
> +	err = recv(cli_fd, buf, 1, 0);
> +	if (CHECK(err, "recv(cli_fd) for fin", "err:%d errno:%d\n", err, errno))
> +		goto done;
> +
> +	shutdown(cli_fd, SHUT_WR);
> +	err = recv(accept_fd, buf, 1, 0);
hmm... I was thinking cli_fd may still be in TCP_LAST_ACK
but we can go with this version first and see if CI could
really hit this case before resurrecting the idea on testing
the TCP_LAST_ACK instead of TCP_CLOSE in test_tcpbpf_kern.c.

> +	CHECK(err, "recv(accept_fd) for fin", "err:%d errno:%d\n", err, errno);
> +done:
> +	if (accept_fd != -1)
> +		close(accept_fd);
> +	if (cli_fd != -1)
> +		close(cli_fd);

> +	if (listen_fd != -1)
> +		close(listen_fd);
> +
> +	return err;
> +}
> +
>  void test_tcpbpf_user(void)
>  {
>  	const char *file = "test_tcpbpf_kern.o";
> @@ -74,7 +146,6 @@ void test_tcpbpf_user(void)
>  	int error = EXIT_FAILURE;
>  	struct bpf_object *obj;
>  	int cg_fd = -1;
> -	int retry = 10;
>  	__u32 key = 0;
>  	int rv;
>  
> @@ -94,11 +165,6 @@ void test_tcpbpf_user(void)
>  		goto err;
>  	}
>  
> -	if (system("./tcp_server.py")) {
> -		fprintf(stderr, "FAILED: TCP server\n");
> -		goto err;
> -	}
> -
>  	map_fd = bpf_find_map(__func__, obj, "global_map");
>  	if (map_fd < 0)
>  		goto err;
> @@ -107,21 +173,15 @@ void test_tcpbpf_user(void)
>  	if (sock_map_fd < 0)
>  		goto err;
>  
> -retry_lookup:
> +	if (run_test())
> +		goto err;
> +
>  	rv = bpf_map_lookup_elem(map_fd, &key, &g);
>  	if (rv != 0) {
>  		fprintf(stderr, "FAILED: bpf_map_lookup_elem returns %d\n", rv);
>  		goto err;
>  	}
>  
> -	if (g.num_close_events != EXPECTED_CLOSE_EVENTS && retry--) {
> -		fprintf(stderr,
> -			"Unexpected number of close events (%d), retrying!\n",
> -			g.num_close_events);
> -		usleep(100);
> -		goto retry_lookup;
> -	}
> -
>  	if (verify_result(&g)) {
>  		fprintf(stderr, "FAILED: Wrong stats\n");
>  		goto err;
