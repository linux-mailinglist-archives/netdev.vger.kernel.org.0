Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E428529E108
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733139AbgJ2Bwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:52:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733086AbgJ2Bvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 21:51:43 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09T1maJm003034;
        Wed, 28 Oct 2020 18:51:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=6ur9s7wh+E3u9WblJqiRQgQdTVErLG3XJQVzdZVy7zc=;
 b=aA36Uu7gT2KdwqKSJjPi/k9AcUZqW70PDl7nTxULPWEE4jnCJgLwEJPEi3ij5rxKr9sE
 YKDsUneroLsApHdOoCbdIzpJYDaTD9B36DUlu5VwjPasLPxNPH7oudjuBTU4kO1jaGUS
 68g0cF24amlaWBvyzF7reaLJiy8p3EFV84E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34esepr99k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Oct 2020 18:51:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 28 Oct 2020 18:51:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVuf6l3nV23lbPCwuK7foY+ElL65o6cjIBaHCMLZI/FV5MGD4aHLz2zCMJxVGwRuaWLRIrmwT3YecJra/D2QmQjRg5PDO2aSYiEX19jStQhO4TVMF3antH7xRqdfnZLcZSeFQX7qvrHzvRSFioil7kqOqzN6kznnCfm7qgOE9Ry3XqwdaIdFqpJuCGPrbWbHddmBe07p7Ep7XNGcxJQPNsNYtL33sP6ubH6ZtlQxZH5n71YnxY/PaTNC2XCcgIoMGRv9D/To4WwifiMAnTtOcwvi+HgyNKR0y0EWQGLQy5/ezCfgSXr6lNkVM8/XOYAR22qNzfDvT8OdKvDmG/fPHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ur9s7wh+E3u9WblJqiRQgQdTVErLG3XJQVzdZVy7zc=;
 b=IQ4YBYswa0tqelFCjRrfIsL3lnFHHK6JhoPIh/wDiSbqhhnQwVYK+NE84Bw4I101NN3wytih5XlC67DXUQWM6165gIq5WaXfr0VZFo84oHuEzPSpRGzDoLWuU0pjsHujnMG2e8dUbOly9qcuaZ0g8+Sr1rZ8ZHdiTCHFKIfX8sk/m10veTO5+UjRYC2q+4Dv5AxtbIIAL0LbqLmVmdWv0xnTtADZooVJaGtmCTrR8Crwc2F0BlPM8wT2j3RS0o8gx2s401Bmuw0dNSLiswwIC6EZlCTeKRrRNNHmPUwgkIbBtgckw/pyXcEa78t3//4LzvvEQtOcp/9UMAsOveJUTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ur9s7wh+E3u9WblJqiRQgQdTVErLG3XJQVzdZVy7zc=;
 b=NFqOp05nTVJbmX+JK/MY1PdZvNbiF8W41peVKY3eZmuT5lPxxXQIzoMKMQ7aepgzdQ1pXuIMkItdgVcc3Eyi3NXj3BRVLgNZqu27QMI+sZy6hYCI5yjeeu+TxScQTlhxHgdFVkOa/7GHuqUibqJWgMiZN1r0YqQ6MOkDLjjX7eQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2727.namprd15.prod.outlook.com (2603:10b6:a03:15b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.24; Thu, 29 Oct
 2020 01:51:23 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 01:51:23 +0000
Date:   Wed, 28 Oct 2020 18:51:15 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, <edumazet@google.com>, <brakmo@fb.com>,
        <alexanderduyck@fb.com>
Subject: Re: [bpf-next PATCH 2/4] selftests/bpf: Drop python client/server in
 favor of threads
Message-ID: <20201029015115.jotej3wgi3p6yn6u@kafai-mbp>
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
 <160384963313.698509.13129692731727238158.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160384963313.698509.13129692731727238158.stgit@localhost.localdomain>
X-Originating-IP: [2620:10d:c090:400::4:c696]
X-ClientProxiedBy: MWHPR01CA0043.prod.exchangelabs.com (2603:10b6:300:101::29)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::4:c696) by MWHPR01CA0043.prod.exchangelabs.com (2603:10b6:300:101::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.22 via Frontend Transport; Thu, 29 Oct 2020 01:51:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0669fd3b-a53d-4a6e-fa1f-08d87bad23ac
X-MS-TrafficTypeDiagnostic: BYAPR15MB2727:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27273D4BBB12429ABE4572A5D5140@BYAPR15MB2727.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8hYGkapYgK/zIZ0qmMnfjoWFA6AEsZtthELIoiJyyJCrzxklqC1iGownHEHEbTDYkQQzDywpcjL/wXtbgugdUxrDjmLlcX0cUHP3vKZjclRE+qfpu0cSxOUsLhp8MFYzSU8cnmm1N27bzSFwVHGj4spw+23i4AAZ63zbEhBvsvWoW/yJaWtua9ZId6pEk6qt5WvWQRwKlpP35TjaW9PCDZY5dyjLlm3uodNZAWliAjsWo+5iQKp0Gvyf1zFg43hFLS9xAEH3C8RJVL430DDgEZOogyJjByk07+4rJyfyLcSiZOU9+PsNrTDo28DzTssZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(39860400002)(346002)(186003)(66556008)(33716001)(66476007)(16526019)(86362001)(66946007)(5660300002)(52116002)(2906002)(4326008)(6496006)(9686003)(8936002)(6916009)(55016002)(1076003)(478600001)(83380400001)(316002)(30864003)(6666004)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: NUqsntUbTpLeMhNUNw2eQ/B7a75wKbvJX7RysMICcD8yGgDNwphDNT+oThiaobnn+dDLCkNj4m2NeKqbM8ltz/+KS5CatYGmal2ggi8zB0h4sM4BA6f2oxcVXGz6zaB57JKdHF8Rn/e6tr6vCm1I4r/rq23b4tykLu9yD6Q9f7XRUtJXWRdqs5qNT7g/NGWcu5NVseBM2J4SE3jj5I6WNDlZsYRZlMo7br1N4iYL/Vf3DEKgqyvAcrmEUa6Vm1r+kbko2xDRT206Q3TcDc4PXbGZ06GbL1/R7QhDW6qejB/LYzfh1ZLia/gHHvxKEM6is46fm/JBZEzr4cZzkG+tgjB/kp/SJwKTQGgAEGwEbrVPOzTI3PVmcILXT00X9de5LC8NsURZLcySBhgeGeRTW2w0psEEoQmsbkXaUkUGdV8km0kYRE31Gc+Bm52B7UzkbCq5Sgh9hTnosXu/h07cKqH41/Fwkx83G7EQ2qTObjWDbv7e4Q3Pw4KnSEZFBLw9TDIAbTbW9SFL+QdPHS7JjvAuNoHhnTuRITRA7GXlMhqvFk2pBDz968/c8FphlUQ6An5XdOVD19F1GerLGNM1IL5IffHzXFIdd4ws0NAotOAIBO/+PnPnt2rFRBQgrWOhcy2tJdgtaPrD6KTSdTh41i7XRWHGzl0Db8xbZn3bJMQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0669fd3b-a53d-4a6e-fa1f-08d87bad23ac
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 01:51:23.4010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: roeiPFD1VKMFjRnLFS+W1iB25YSKlGlDjZnZEVqsHeXoezSYIkrCDeEB5CWiOFfl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_09:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 suspectscore=2 phishscore=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290009
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 06:47:13PM -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> Drop the tcp_client/server.py files in favor of using a client and server
> thread within the test case. Specifically we spawn a new thread to play the
> role of the server, and the main testing thread plays the role of client.
> 
> Doing this we are able to reduce overhead since we don't have two python
> workers possibly floating around. In addition we don't have to worry about
> synchronization issues and as such the retry loop waiting for the threads
> to close the sockets can be dropped as we will have already closed the
> sockets in the local executable and synchronized the server thread.
Thanks for working on this.

> 
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  125 +++++++++++++++++---
>  tools/testing/selftests/bpf/tcp_client.py          |   50 --------
>  tools/testing/selftests/bpf/tcp_server.py          |   80 -------------
>  3 files changed, 107 insertions(+), 148 deletions(-)
>  delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
>  delete mode 100755 tools/testing/selftests/bpf/tcp_server.py
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> index 5becab8b04e3..71ab82e37eb7 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> @@ -1,14 +1,65 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <inttypes.h>
>  #include <test_progs.h>
> +#include <network_helpers.h>
>  
>  #include "test_tcpbpf.h"
>  #include "cgroup_helpers.h"
>  
> +#define LO_ADDR6 "::1"
>  #define CG_NAME "/tcpbpf-user-test"
>  
> -/* 3 comes from one listening socket + both ends of the connection */
> -#define EXPECTED_CLOSE_EVENTS		3
> +static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
> +static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
> +
> +static void *server_thread(void *arg)
> +{
> +	struct sockaddr_storage addr;
> +	socklen_t len = sizeof(addr);
> +	int fd = *(int *)arg;
> +	char buf[1000];
> +	int client_fd;
> +	int err = 0;
> +	int i;
> +
> +	err = listen(fd, 1);
This is not needed.  start_server() has done it.

> +
> +	pthread_mutex_lock(&server_started_mtx);
> +	pthread_cond_signal(&server_started);
> +	pthread_mutex_unlock(&server_started_mtx);
> +
> +	if (err < 0) {
> +		perror("Failed to listen on socket");
> +		err = errno;
> +		goto err;
> +	}
> +
> +	client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> +	if (client_fd < 0) {
> +		perror("Failed to accept client");
> +		err = errno;
> +		goto err;
> +	}
> +
> +	if (recv(client_fd, buf, 1000, 0) < 1000) {
> +		perror("failed/partial recv");
> +		err = errno;
> +		goto out_clean;
> +	}
> +
> +	for (i = 0; i < 500; i++)
> +		buf[i] = '.';
> +
> +	if (send(client_fd, buf, 500, 0) < 500) {
> +		perror("failed/partial send");
> +		err = errno;
> +		goto out_clean;
> +	}
> +out_clean:
> +	close(client_fd);
> +err:
> +	return (void *)(long)err;
> +}
>  
>  #define EXPECT_EQ(expected, actual, fmt)			\
>  	do {							\
> @@ -43,7 +94,9 @@ int verify_result(const struct tcpbpf_globals *result)
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
> @@ -67,6 +120,52 @@ int verify_sockopt_result(int sock_map_fd)
>  	return ret;
>  }
>  
> +static int run_test(void)
> +{
> +	int server_fd, client_fd;
> +	void *server_err;
> +	char buf[1000];
> +	pthread_t tid;
> +	int err = -1;
> +	int i;
> +
> +	server_fd = start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
> +	if (CHECK_FAIL(server_fd < 0))
> +		return err;
> +
> +	pthread_mutex_lock(&server_started_mtx);
> +	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
> +				      (void *)&server_fd)))
> +		goto close_server_fd;
> +
> +	pthread_cond_wait(&server_started, &server_started_mtx);
> +	pthread_mutex_unlock(&server_started_mtx);
> +
> +	client_fd = connect_to_fd(server_fd, 0);
> +	if (client_fd < 0)
> +		goto close_server_fd;
> +
> +	for (i = 0; i < 1000; i++)
> +		buf[i] = '+';
> +
> +	if (CHECK_FAIL(send(client_fd, buf, 1000, 0) < 1000))
> +		goto close_client_fd;
> +
> +	if (CHECK_FAIL(recv(client_fd, buf, 500, 0) < 500))
> +		goto close_client_fd;
> +
> +	pthread_join(tid, &server_err);
I think this can be further simplified without starting thread
and do everything in run_test() instead.

Something like this (uncompiled code):

	accept_fd = accept(server_fd, NULL, 0);
	send(client_fd, plus_buf, 1000, 0);
	recv(accept_fd, recv_buf, 1000, 0);
	send(accept_fd, dot_buf, 500, 0);
	recv(client_fd, recv_buf, 500, 0);

> +
> +	err = (int)(long)server_err;
> +	CHECK_FAIL(err);
> +
> +close_client_fd:
> +	close(client_fd);
> +close_server_fd:
> +	close(server_fd);
> +	return err;
> +}
> +
>  void test_tcpbpf_user(void)
>  {
>  	const char *file = "test_tcpbpf_kern.o";
> @@ -74,7 +173,6 @@ void test_tcpbpf_user(void)
>  	struct tcpbpf_globals g = {0};
>  	struct bpf_object *obj;
>  	int cg_fd = -1;
> -	int retry = 10;
>  	__u32 key = 0;
>  	int rv;
>  
> @@ -94,11 +192,6 @@ void test_tcpbpf_user(void)
>  		goto err;
>  	}
>  
> -	if (CHECK_FAIL(system("./tcp_server.py"))) {
> -		fprintf(stderr, "FAILED: TCP server\n");
> -		goto err;
> -	}
> -
>  	map_fd = bpf_find_map(__func__, obj, "global_map");
>  	if (CHECK_FAIL(map_fd < 0))
>  		goto err;
> @@ -107,21 +200,17 @@ void test_tcpbpf_user(void)
>  	if (CHECK_FAIL(sock_map_fd < 0))
>  		goto err;
>  
> -retry_lookup:
> +	if (run_test()) {
> +		fprintf(stderr, "FAILED: TCP server\n");
> +		goto err;
> +	}
> +
>  	rv = bpf_map_lookup_elem(map_fd, &key, &g);
>  	if (CHECK_FAIL(rv != 0)) {
CHECK() is a better one here if it needs to output error message.
The same goes for similar usages in this patch set.

For the start_server() above which has already logged the error message,
CHECK_FAIL() is good enough.

>  		fprintf(stderr, "FAILED: bpf_map_lookup_elem returns %d\n", rv);
>  		goto err;
>  	}
>  
> -	if (g.num_close_events != EXPECTED_CLOSE_EVENTS && retry--) {
It is good to have a solution to avoid a test depending on some number
of retries.

After looking at BPF_SOCK_OPS_STATE_CB in test_tcpbpf_kern.c,
it is not clear to me removing python alone is enough to avoid the
race (so the retry--).  One of the sk might still be in TCP_LAST_ACK
instead of TCP_CLOSE.

Also, when looking closer at BPF_SOCK_OPS_STATE_CB in test_tcpbpf_kern.c,
it seems the map value "gp" is slapped together across multiple
TCP_CLOSE events which may be not easy to understand.

How about it checks different states: TCP_CLOSE, TCP_LAST_ACK,
and BPF_TCP_FIN_WAIT2.  Each of this state will update its own
values under "gp".  Something like this (only compiler tested on
top of patch 4):

diff --git i/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c w/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 7e92c37976ac..65b247b03dfc 100644
--- i/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ w/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -90,15 +90,14 @@ static void verify_result(int map_fd, int sock_map_fd)
 	      result.event_map, expected_events);
 
 	ASSERT_EQ(result.bytes_received, 501, "bytes_received");
-	ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
+	ASSERT_EQ(result.bytes_acked, 1001, "bytes_acked");
 	ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
 	ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
 	ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
 	ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
-	ASSERT_EQ(result.num_listen, 1, "num_listen");
-
-	/* 3 comes from one listening socket + both ends of the connection */
-	ASSERT_EQ(result.num_close_events, 3, "num_close_events");
+	ASSERT_EQ(result.num_listen_close, 1, "num_listen");
+	ASSERT_EQ(result.num_last_ack, 1, "num_last_ack");
+	ASSERT_EQ(result.num_fin_wait2, 1, "num_fin_wait2");
 
 	/* check setsockopt for SAVE_SYN */
 	key = 0;
diff --git i/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c w/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index 3e6912e4df3d..2c5ffb50d6e0 100644
--- i/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ w/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -55,9 +55,11 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 {
 	char header[sizeof(struct ipv6hdr) + sizeof(struct tcphdr)];
 	struct bpf_sock_ops *reuse = skops;
+	struct tcpbpf_globals *gp;
 	struct tcphdr *thdr;
 	int good_call_rv = 0;
 	int bad_call_rv = 0;
+	__u32 key_zero = 0;
 	int save_syn = 1;
 	int rv = -1;
 	int v = 0;
@@ -155,26 +157,21 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 	case BPF_SOCK_OPS_RETRANS_CB:
 		break;
 	case BPF_SOCK_OPS_STATE_CB:
-		if (skops->args[1] == BPF_TCP_CLOSE) {
-			__u32 key = 0;
-			struct tcpbpf_globals g, *gp;
-
-			gp = bpf_map_lookup_elem(&global_map, &key);
-			if (!gp)
-				break;
-			g = *gp;
-			if (skops->args[0] == BPF_TCP_LISTEN) {
-				g.num_listen++;
-			} else {
-				g.total_retrans = skops->total_retrans;
-				g.data_segs_in = skops->data_segs_in;
-				g.data_segs_out = skops->data_segs_out;
-				g.bytes_received = skops->bytes_received;
-				g.bytes_acked = skops->bytes_acked;
-			}
-			g.num_close_events++;
-			bpf_map_update_elem(&global_map, &key, &g,
-					    BPF_ANY);
+		gp = bpf_map_lookup_elem(&global_map, &key_zero);
+		if (!gp)
+			break;
+		if (skops->args[1] == BPF_TCP_CLOSE &&
+		    skops->args[0] == BPF_TCP_LISTEN) {
+			gp->num_listen_close++;
+		} else if (skops->args[1] == BPF_TCP_LAST_ACK) {
+			gp->total_retrans = skops->total_retrans;
+			gp->data_segs_in = skops->data_segs_in;
+			gp->data_segs_out = skops->data_segs_out;
+			gp->bytes_received = skops->bytes_received;
+			gp->bytes_acked = skops->bytes_acked;
+			gp->num_last_ack++;
+		} else if (skops->args[1] == BPF_TCP_FIN_WAIT2) {
+			gp->num_fin_wait2++;
 		}
 		break;
 	case BPF_SOCK_OPS_TCP_LISTEN_CB:
diff --git i/tools/testing/selftests/bpf/test_tcpbpf.h w/tools/testing/selftests/bpf/test_tcpbpf.h
index 6220b95cbd02..0dec324ba4a6 100644
--- i/tools/testing/selftests/bpf/test_tcpbpf.h
+++ w/tools/testing/selftests/bpf/test_tcpbpf.h
@@ -12,7 +12,8 @@ struct tcpbpf_globals {
 	__u32 good_cb_test_rv;
 	__u64 bytes_received;
 	__u64 bytes_acked;
-	__u32 num_listen;
-	__u32 num_close_events;
+	__u32 num_listen_close;
+	__u32 num_last_ack;
+	__u32 num_fin_wait2;
 };
 #endif

I also noticed the bytes_received/acked depends on the order of close(),
i.e. always close the accepted fd first.  I think a comment
in the tcpbpf_user.c is good enough for now.

[ It does not have to be in this set and it can be done in another
  follow up effort.
  Instead of using a bpf map to store the result, using global
  variables in test_tcpbpf_kern.c will simplify the code further. ]
