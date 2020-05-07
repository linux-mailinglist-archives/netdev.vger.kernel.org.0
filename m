Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E6E1C8236
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 08:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgEGGJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 02:09:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30238 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgEGGJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 02:09:45 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04766ACf003355;
        Wed, 6 May 2020 23:09:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=UQTaJqdro7r7CC+rbPyJ/tuLlUWLeB9KPXfgzH/PKsE=;
 b=be7V8IUf5rwaFEBr7zKOKdOGdnim7LfFv8gn6xQ6+4+GeltvFY2rlRObgi4EIP+Z+7K2
 /Wq0AdQVXVU+miboYfZ6hQmHKQRQxqHK3ZhLFBW5cxgTcKTFUXyHjTQtQ/TUDrPvmw9B
 u3fNSrPcqpLbD6Wlds6KQ+VVSY6Y7oXCfx8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30uxuxm5w3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 23:09:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 23:09:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fogrvvioQyIy21BHRVlu+iSzOrWFQFCqGhd95AWM1uW5/7IyVZY9MkMezLOu2jlgxNzJzt/OilnQakNVIJ5itiEnRCzLcdEMQhcZxlFwXHbPn7ZTLum1ym1Slu/ELMrgzfLSHGxOmzUUU6VH6i+Sb9DqKLaK9pRY7NlEl23kaQYapM2Z5ZQPxD6oIKDwZ82CGXRBnGTKZpyGHKOiEwIv2A0NHbigjz0KSEntn9RbO9F8Jr9M3S2jjZ7n2J66Bkv2mZ/MDR+sc95u7Hz4Swo4HJzuTrIx5dPAlJyxVRD1w6nzwMtSS8LN4Kew3+liqopI3wvhHkLC9fX/9KRfJP12fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQTaJqdro7r7CC+rbPyJ/tuLlUWLeB9KPXfgzH/PKsE=;
 b=RDj7KOdmIWxvlmG25YQj4E0jJRXfzgN9Wh1uvE0BXaP4hsWCetiwDHW4/Slwm7X3bd894116FFxS/PqLGonCSIwu6tDs5bzcf46B3LukgVOj22h6eUK49IHqLKrJjJfV6WU0Gz9M4qLNcVE3mnhSKH/P3bP6NUqKn8cLzrirWV6/yENerp3t/Rlf6nJISrWMinhmVxjvZPpiuhekWb+xQzMssmK0xKsgdamYhv8H9Nq7XZsePeBYs/BVRAksacFegcQDlkPCW9f5kgaBtohJOi56b5tzVk+MHUN7kPPOk0t73vZQvuhizTgQPePqyC0+N6tGw4B0YEMdxPn2Uhb3Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQTaJqdro7r7CC+rbPyJ/tuLlUWLeB9KPXfgzH/PKsE=;
 b=Zwc708Q0umrAiX8popWAmD/1PkS00FVn/8GZ6ybwGMB9v1z4ckS0BgjyvrQif2FDtjQWKuO+RnT+LYfMa6itKcit2Lr2K8kAcSTa6y7QCJtgkNzgoNKkRHd7069CNQSb14K7FlD6bBXlBFSdGJY6cJWSdtmhskOvTnKrNeDz3h8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3915.namprd15.prod.outlook.com (2603:10b6:303:4a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30; Thu, 7 May
 2020 06:09:23 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Thu, 7 May 2020
 06:09:23 +0000
Date:   Wed, 6 May 2020 23:09:21 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 1/5] selftests/bpf: generalize helpers to
 control background listener
Message-ID: <20200507060921.bns5nfxuoy5c3tcu@kafai-mbp>
References: <20200506223210.93595-1-sdf@google.com>
 <20200506223210.93595-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506223210.93595-2-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR05CA0071.namprd05.prod.outlook.com
 (2603:10b6:a03:74::48) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:bdb8) by BYAPR05CA0071.namprd05.prod.outlook.com (2603:10b6:a03:74::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Thu, 7 May 2020 06:09:22 +0000
X-Originating-IP: [2620:10d:c090:400::5:bdb8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a74f7502-bb8a-4331-d1a3-08d7f24d3004
X-MS-TrafficTypeDiagnostic: MW3PR15MB3915:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3915A164A152F5E0789E03ABD5A50@MW3PR15MB3915.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1au0R5bP6iCOx+2/R6BwN4yEqhPsyNzyYXqUBYdsk10p12QY0PKpmFfTNboy/EljL+TSmowZNPAu7hgOyQOII3vUU0tsjt1FVgy22BFbfz/SdBvhxdjxTTQssmQGB+dY7DrkQNe4dXyBY9U0TGnS4hFnURW/nYjlOXJRMLfhkTrUtWcWCQNWtjkZw1ttncSwrbTln3v4PuUv4eBZdzLJ/MQ3v6o5FnDlPNr+pAPumW+jfb/sXEGJrsC0KpPCQXdrtPT+rVSiA3ynGCAb5HDio+2HJKeGw8k5h0h6o5ix9vtyZAy+zkJDPsJfPFFoUzwHUySJRUmoPyK3oHLORfG45UQNQZBq7q8QQCh5kj6SCNINgveGN7YQv7cYcH6/q+oRngDZbvjM6Y2WDayRX295MC4JbzasyI9rprqK31zwNDUbnJF0+HLqCu2jxlkoB7YVm4U2S1T+5q+aQ4FJgpIesfsS6L6/decQifnRXoUXxFR2HbgK/HoIrb2bzqTtDyjfW2p3g5IUP33AxACTkqg+/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(39860400002)(136003)(366004)(33430700001)(33440700001)(66556008)(478600001)(9686003)(1076003)(66476007)(8676002)(6496006)(55016002)(6916009)(66946007)(8936002)(316002)(30864003)(86362001)(5660300002)(52116002)(33716001)(2906002)(16526019)(4326008)(83320400001)(83280400001)(83300400001)(83310400001)(186003)(83290400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: njoj5K0vFmi+bLT8kb5yg+3+v0+OoGy1eXrZs4y7sfVPL2Ol4aVO8REQHUWX5dyW6gIrV/sFaW7e0+LpFH5Qn4FbdJnHAz7B4QLdL4HKlXyo9lywfoZ5XhXU6JKhV6INzVJIokDusTFwXyqstsMRo/s7HQdvKZIy0cgZO2J2f59ZIMdsHqW6JgAwrxrD/qNasvHYXj1wtwhq0DjyqFIspyICDj6Eh6kTPu/tn2svVd2ZwhoeBTak1CkXnPOPJq7/QzSlnZsdlpRxv1TjnFXySN58uA/X/Zs3xP82C/RwNECqLyaxMlsL1Jlo3DHMGT9fLRaX9gQ9ZMwXwawNZu0+U8pxD5Ih4XCDQvpXPS0E1E0S6ypKC06tXH2J2SljprVZZ8b9JKbAjMAfsu1A19lpFNEtOY4xNrDl+0tQb0ibb6dxAf/IgFlKgb9CFSBJPg485AtuPanXRpmDnTCC4mDYDRk/gwPahGWmY39iZBE3rTD01+933wacAdrpgdq2UwFOYVvOa1nGB6qHYNXEV3LXKvogzRda9/JLyzYerYwkiYnvVr2/CM04i6mSU80aStwVRpkozIf3H1SavwILEzPjfjHUBBFzi1eK3m3RiV+uX0WedkpoMvForzKQX8Ud8LtWDKiiqyG2Abx054ZsNMuPQwenFFWlel33TG5/4/hAPludOzmRYuVj8gqmH/WxcPp80i8iKqFu6Sy9LapuctsUTLJ4+VHNdpgYrGW9DY7B0K4/b2SdUv872rklHPg0rU1HA9NQegdBC3makihE2O8NEurGMMGjkQ17EC/1hXyCzloBP2FnOy+kjU1R9geDy8hCeNHPcA4S5cM6M8hcKLSbCQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: a74f7502-bb8a-4331-d1a3-08d7f24d3004
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 06:09:23.0500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z8OX9ocYQnStAuzg+Hf6AmDMZeW7J2uGqlXvYFILvQmfwjQg+riiuQpLTdRyGXzB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3915
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 03:32:06PM -0700, Stanislav Fomichev wrote:
> Move the following routines that let us start a background listener
> thread and connect to a server by fd to the test_prog:
> * start_server_thread - start background INADDR_ANY thread
> * stop_server_thread - stop the thread
> * connect_to_fd - connect to the server identified by fd
> 
> These will be used in the next commit.
> 
> Also, extend these helpers to support AF_INET6 and accept the family
> as an argument.
> 
> v3:
> * export extra helper to start server without a thread (Martin KaFai Lau)
> 
> v2:
> * put helpers into network_helpers.c (Andrii Nakryiko)
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |   2 +-
>  tools/testing/selftests/bpf/network_helpers.c | 164 ++++++++++++++++++
>  tools/testing/selftests/bpf/network_helpers.h |  12 ++
>  .../selftests/bpf/prog_tests/tcp_rtt.c        | 116 +------------
>  4 files changed, 181 insertions(+), 113 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/network_helpers.c
>  create mode 100644 tools/testing/selftests/bpf/network_helpers.h
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 3d942be23d09..8f25966b500b 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -354,7 +354,7 @@ endef
>  TRUNNER_TESTS_DIR := prog_tests
>  TRUNNER_BPF_PROGS_DIR := progs
>  TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
> -			 flow_dissector_load.h
> +			 network_helpers.c flow_dissector_load.h
>  TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
>  		       $(wildcard progs/btf_dump_test_case_*.c)
>  TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
> diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
> new file mode 100644
> index 000000000000..6ad16dfebfb2
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/network_helpers.c
> @@ -0,0 +1,164 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <errno.h>
> +#include <pthread.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <linux/err.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +
> +#include "network_helpers.h"
> +
> +#define CHECK_FAIL(condition) ({					\
> +	int __ret = !!(condition);					\
> +	int __save_errno = errno;					\
> +	if (__ret) {							\
> +		fprintf(stdout, "%s:FAIL:%d\n", __func__, __LINE__);	\
> +	}								\
> +	errno = __save_errno;						\
> +	__ret;								\
> +})
> +
> +#define clean_errno() (errno == 0 ? "None" : strerror(errno))
> +#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
> +	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)
> +
> +int start_server(int family, int type)
> +{
> +	struct sockaddr_storage addr = {};
> +	socklen_t len;
> +	int fd;
> +
> +	if (family == AF_INET) {
> +		struct sockaddr_in *sin = (void *)&addr;
> +
> +		sin->sin_family = AF_INET;
> +		len = sizeof(*sin);
> +	} else {
> +		struct sockaddr_in6 *sin6 = (void *)&addr;
> +
> +		sin6->sin6_family = AF_INET6;
> +		len = sizeof(*sin6);
> +	}
> +
> +	fd = socket(family, type | SOCK_NONBLOCK, 0);
> +	if (fd < 0) {
> +		log_err("Failed to create server socket");
> +		return -1;
> +	}
> +
> +	if (bind(fd, (const struct sockaddr *)&addr, len) < 0) {
> +		log_err("Failed to bind socket");
> +		close(fd);
> +		return -1;
> +	}
> +
> +	if (type == SOCK_STREAM) {
> +		if (listen(fd, 1) < 0) {
> +			log_err("Failed to listed on socket");
> +			close(fd);
> +			return -1;
> +		}
> +	}
> +
> +	return fd;
> +}
> +
> +static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
> +static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
> +static volatile bool server_done;
> +pthread_t server_tid;
> +
> +static void *server_thread(void *arg)
> +{
> +	struct sockaddr_storage addr;
> +	socklen_t len = sizeof(addr);
> +	int fd = *(int *)arg;
> +	int client_fd;
> +
> +	pthread_mutex_lock(&server_started_mtx);
> +	pthread_cond_signal(&server_started);
> +	pthread_mutex_unlock(&server_started_mtx);
> +
> +	while (true) {
> +		client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> +		if (client_fd == -1 && errno == EAGAIN) {
> +			usleep(50);
> +			continue;
> +		}
> +		break;
> +	}
> +	if (CHECK_FAIL(client_fd < 0)) {
> +		perror("Failed to accept client");
> +		return ERR_PTR(-1);
> +	}
> +
> +	while (!server_done)
> +		usleep(50);
> +
> +	close(client_fd);
> +
> +	return NULL;
> +}
> +
> +int start_server_thread(int family, int type)
> +{
> +	int fd = start_server(family, type);
> +
> +	if (fd < 0)
> +		return -1;
> +
> +	if (CHECK_FAIL(pthread_create(&server_tid, NULL, server_thread,
> +				      (void *)&fd)))
> +		goto err;
> +
> +	pthread_mutex_lock(&server_started_mtx);
> +	pthread_cond_wait(&server_started, &server_started_mtx);
> +	pthread_mutex_unlock(&server_started_mtx);
> +
> +	return fd;
> +err:
> +	close(fd);
> +	return -1;
> +}
> +
> +void stop_server_thread(int fd)
> +{
> +	void *server_res;
> +
> +	server_done = true;
> +	CHECK_FAIL(pthread_join(server_tid, &server_res));
> +	CHECK_FAIL(IS_ERR(server_res));
> +	close(fd);
> +}
> +
> +int connect_to_fd(int family, int type, int server_fd)
> +{
> +	struct sockaddr_storage addr;
> +	socklen_t len = sizeof(addr);
> +	int fd;
> +
> +	fd = socket(family, type, 0);
> +	if (fd < 0) {
> +		log_err("Failed to create client socket");
> +		return -1;
> +	}
> +
> +	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
> +		log_err("Failed to get server addr");
> +		goto out;
> +	}
> +
> +	if (connect(fd, (const struct sockaddr *)&addr, len) < 0) {
> +		log_err("Fail to connect to server with family %d", family);
> +		goto out;
> +	}
> +
> +	return fd;
> +
> +out:
> +	close(fd);
> +	return -1;
> +}
> diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
> new file mode 100644
> index 000000000000..4ed31706b7f4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/network_helpers.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __NETWORK_HELPERS_H
> +#define __NETWORK_HELPERS_H
> +#include <sys/socket.h>
> +#include <sys/types.h>
> +
> +int start_server(int family, int type);
> +int start_server_thread(int family, int type);
> +void stop_server_thread(int fd);
> +int connect_to_fd(int family, int type, int server_fd);
> +
> +#endif
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> index e56b52ab41da..4aaa1e6e33ad 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <test_progs.h>
>  #include "cgroup_helpers.h"
> +#include "network_helpers.h"
>  
>  struct tcp_rtt_storage {
>  	__u32 invoked;
> @@ -87,34 +88,6 @@ static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 invoked,
>  	return err;
>  }
>  
> -static int connect_to_server(int server_fd)
> -{
> -	struct sockaddr_storage addr;
> -	socklen_t len = sizeof(addr);
> -	int fd;
> -
> -	fd = socket(AF_INET, SOCK_STREAM, 0);
> -	if (fd < 0) {
> -		log_err("Failed to create client socket");
> -		return -1;
> -	}
> -
> -	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
> -		log_err("Failed to get server addr");
> -		goto out;
> -	}
> -
> -	if (connect(fd, (const struct sockaddr *)&addr, len) < 0) {
> -		log_err("Fail to connect to server");
> -		goto out;
> -	}
> -
> -	return fd;
> -
> -out:
> -	close(fd);
> -	return -1;
> -}
>  
>  static int run_test(int cgroup_fd, int server_fd)
>  {
> @@ -145,7 +118,7 @@ static int run_test(int cgroup_fd, int server_fd)
>  		goto close_bpf_object;
>  	}
>  
> -	client_fd = connect_to_server(server_fd);
> +	client_fd = connect_to_fd(AF_INET, SOCK_STREAM, server_fd);
>  	if (client_fd < 0) {
>  		err = -1;
>  		goto close_bpf_object;
> @@ -180,103 +153,22 @@ static int run_test(int cgroup_fd, int server_fd)
>  	return err;
>  }
>  
> -static int start_server(void)
> -{
> -	struct sockaddr_in addr = {
> -		.sin_family = AF_INET,
> -		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
> -	};
> -	int fd;
> -
> -	fd = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
> -	if (fd < 0) {
> -		log_err("Failed to create server socket");
> -		return -1;
> -	}
> -
> -	if (bind(fd, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
> -		log_err("Failed to bind socket");
> -		close(fd);
> -		return -1;
> -	}
> -
> -	return fd;
> -}
> -
> -static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
> -static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
> -static volatile bool server_done = false;
> -
> -static void *server_thread(void *arg)
> -{
> -	struct sockaddr_storage addr;
> -	socklen_t len = sizeof(addr);
> -	int fd = *(int *)arg;
> -	int client_fd;
> -	int err;
> -
> -	err = listen(fd, 1);
> -
> -	pthread_mutex_lock(&server_started_mtx);
> -	pthread_cond_signal(&server_started);
> -	pthread_mutex_unlock(&server_started_mtx);
> -
> -	if (CHECK_FAIL(err < 0)) {
> -		perror("Failed to listed on socket");
> -		return ERR_PTR(err);
> -	}
> -
> -	while (true) {
> -		client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> -		if (client_fd == -1 && errno == EAGAIN) {
> -			usleep(50);
> -			continue;
> -		}
> -		break;
> -	}
> -	if (CHECK_FAIL(client_fd < 0)) {
> -		perror("Failed to accept client");
> -		return ERR_PTR(err);
> -	}
> -
> -	while (!server_done)
> -		usleep(50);
> -
> -	close(client_fd);
> -
> -	return NULL;
> -}
> -
>  void test_tcp_rtt(void)
>  {
>  	int server_fd, cgroup_fd;
> -	pthread_t tid;
> -	void *server_res;
>  
>  	cgroup_fd = test__join_cgroup("/tcp_rtt");
>  	if (CHECK_FAIL(cgroup_fd < 0))
>  		return;
>  
> -	server_fd = start_server();
> +	server_fd = start_server_thread(AF_INET, SOCK_STREAM);
I still don't see a thread is needed in this existing test_tcp_rtt also.

I was hoping the start/stop_server_thread() helpers can be removed.
I am not positive the future tests will find start/stop_server_thread()
useful as is because it only does accept() and there is no easy way to
get the accept-ed() fd.

If this test needs to keep the thread, may be only keep the
start/stop_server_thread() in this test for now until
there is another use case that can benefit from them.

Keep the start_server() and connect_to_fd() in the new
network_helpers.c.  I think at least sk_assign.c (and likely
a few others) should be able to reuse them later.  They
are doing something very close to start_server() and
connect_to_fd().

Thoughts?
