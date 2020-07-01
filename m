Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E909221163F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgGAWpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:45:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34918 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726114AbgGAWpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:45:20 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 061Me2AT008090;
        Wed, 1 Jul 2020 15:45:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=o++xjMJbc9eD2HAVAxhHsiN9Qb6SWF5viHUF0h7GXbg=;
 b=TuEuDaH5Xr0hzjzFjUzuTPG4qIUajDKaPI4jsXSVPeiyjlBk1dR4w97YKbEiEUdhERk6
 Hh5x3QAcBeKip8Sya9qjO/PndbD/uFNRg+rOZRY6CBzJIqcVU05d27F2mCisENKgyv3H
 6Nyh7GbrCMY21asKPI8bRvG8ETBdzQfcSRM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32120mre1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Jul 2020 15:45:05 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 15:45:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/g1w5l9VzScvapDSCJPpUXN/C1M7vyB1L/lMEVm+xehurvKxozh5E0Fq9xEuuAxpzYDjPlPFeA5AZBi96nwlfZEb5zn6Vir+aGuo9mX0WruZsKlDO7GNAJI9OF1WRZQe/+MlO7GhqUkvcqXpS2WJNMFEeIP/oFPtUXcP0pCnDxLZ2dR5toobsN+bb5Schowyxw09LJLmZF7RKlD062F2KzUBrd15cQ4nIjPVQbaR35tVY00jibUJ6jYk7MnbY/BRhw9P2u4NXzDvvXlSJk2uor7M9KyAO7FNDlHucjqWE1s9HdGKLBJ/77K/niUUwjhWMEaCz07U6tN8siLBUhaYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o++xjMJbc9eD2HAVAxhHsiN9Qb6SWF5viHUF0h7GXbg=;
 b=GibmgSKLlFL0mZX/ObNeX6DGwcXqO4XbnsNe+a7J2VTPAsK6N4J5WFp1Qx4um/t+QlYHXg0XeuEkIkvu7e6RXKwHtgPDUe10F746dgzaVQkNgBPzrfTUd+KWT4LvIyIO0LvgUxRw6to42t4xn5pjQqI/DlHyywe98mtXHlUSQsSuwMELj+QcTTvjMyv0Ky4rreYaEwtpVKNRb5mMWn1lr1AOP342/qx8t6KwYLvBLU9x4roYMQ9nl4JrXRbatf3rU+NNDWj9HPrYS32yG4Z8bLP2YjfgBKs0oeZPJ/rLrxnXg0DXUzxDNxAIcKabYjKBVmD3iE3Qy4F8BI4D3mH/aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o++xjMJbc9eD2HAVAxhHsiN9Qb6SWF5viHUF0h7GXbg=;
 b=JuuL7e3dVW+O3XbZDtyBopb3yrYKBnSwvLbnZ510V9WAZCxSkVfyPH3Bhz0fRz4iWnZsPQRMtdPn0pqnWMJuuYQ1hadeHQ6GGr1YS14zW8AhlyyJW1tfRNGCJ08uWWDwdP3dAiAkNDX98Yh+h5qsXYlF8zOgv/KZGWeKM4d3uHY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2374.namprd15.prod.outlook.com (2603:10b6:a02:8b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Wed, 1 Jul
 2020 22:45:02 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Wed, 1 Jul 2020
 22:45:02 +0000
Subject: Re: [PATCH bpf-next 1/2] bpf: selftests: A few improvements to
 network_helpers.c
To:     Martin KaFai Lau <kafai@fb.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
References: <20200701194600.948847-1-kafai@fb.com>
 <20200701194607.949186-1-kafai@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a59aef20-e788-0670-35da-351576168844@fb.com>
Date:   Wed, 1 Jul 2020 15:45:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200701194607.949186-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0070.namprd08.prod.outlook.com
 (2603:10b6:a03:117::47) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::15c2] (2620:10d:c090:400::5:ec05) by BYAPR08CA0070.namprd08.prod.outlook.com (2603:10b6:a03:117::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23 via Frontend Transport; Wed, 1 Jul 2020 22:45:01 +0000
X-Originating-IP: [2620:10d:c090:400::5:ec05]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b9d173b-1aa5-4f71-60ef-08d81e106430
X-MS-TrafficTypeDiagnostic: BYAPR15MB2374:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB23748A35B4E93F9C8D626188D36C0@BYAPR15MB2374.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9PEmtfGDUQEbbJsmOHLycaRgaG0K453eyzfni9jTglHnhk12utHUj8t6ipp3rs+bX75pQPJq8/GXB3yg9AdXDqgTof9iMIGP6JG8aMg2/o8coS97gP/kxtmmdM6aubKF1SauEpJLElHkOl7HBGL11oG/xkBlffxHJYJVlX3yNHEIRUTo1lFLe/Lle84XLbDfDEHHPJUqRecp7NhvBsBcDyA3b+dFppk/9Zw2fzay97ty6ngGEMXa34mwvkDb9D3otjgAvtHvEEnfr64dJ6sb3Leu0PvD2A9O7JGUUNcpdLIdukYb4WNFAARhY5+lF0ie3r9FoEwhmeLgKARqKkZk/QqxJR5hKS1NT08ebudV+zBmJnojGa/ex0dcSsEUs/+s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(136003)(396003)(39860400002)(16526019)(53546011)(186003)(31686004)(66556008)(66946007)(316002)(4326008)(66476007)(6486002)(8676002)(52116002)(2616005)(83380400001)(8936002)(31696002)(478600001)(54906003)(2906002)(5660300002)(36756003)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: xhXPNBd0ecHL5CHoUQ/YEVHKMhJAU4nu/ggQOcEcrxRIfeOtJxRHqxJV8h2U9w3xzoHY0eECCPSneLKyMuLPS2v7gdiS5ijWHnx2gfCLi2F5PMrqvSHE/2H8vmxU0hSUNiEOD7Ce71+epz6YKVV3BLhoP2fD87tWMzV/mqZ4OmQMzvcQKAnJ5QgChdLCE226GxZvYarfksVwUEzLaL0KB0i1MwvTUAVk3GGyY2iu1gqKy3JxBOPkL32/Oni3BCMp+Dl4RztepCgNsJMTYpYokwquUvWRyv+RIp7sQ7CB2Ld6AS+oXkQSxBENyNVbyeEPkg10seRXSbissXwso4r/KOP1t60ul6to4MmFFqS6EMw8XwZelezIyMl/+S1DwYrEmXldnmaFYu2kvfAa54WC4x63DiIfVrVmG7MSUW4uMRqp0VNbTGygXJNZTR2+NoaVzXiFKlkE0k7+KAd2/5qkJOnLXodvmXu4BpvmFqjo5Eg0W6tMEv/bNDI22/hmON1ifvaXf4iLnuCSViBhVF0KjQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9d173b-1aa5-4f71-60ef-08d81e106430
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 22:45:02.4286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dLqp9flwfmXA7DN0yAWRd6CFoMoC1tgurlvVFvcz1Bf7LnyvyVXLl7yYK3puljw9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2374
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_15:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 cotscore=-2147483648
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/20 12:46 PM, Martin KaFai Lau wrote:
> This patch makes a few changes to the network_helpers.c
> 
> 1) Enforce SO_RCVTIMEO and SO_SNDTIMEO
>     This patch enforces timeout to the network fds through setsockopt
>     SO_RCVTIMEO and SO_SNDTIMEO.
> 
>     It will remove the need for SOCK_NONBLOCK that requires a more demanding
>     timeout logic with epoll/select, e.g. epoll_create, epoll_ctrl, and
>     then epoll_wait for timeout.
> 
>     That removes the need for connect_wait() from the
>     cgroup_skb_sk_lookup.c. The needed change is made in
>     cgroup_skb_sk_lookup.c.
> 
> 2) start_server():
>     Add optional addr_str and port to start_server().
>     That removes the need of the start_server_with_port().  The caller
>     can pass addr_str==NULL and/or port==0.
> 
>     "int timeout_ms" is also added to control the timeout
>     on the "accept(listen_fd)".
> 
> 3) connect_to_fd(): Fully use the server_fd.
>     The server sock address has already been obtained from
>     getsockname(server_fd).  The sockaddr includes the family,
>     so the "int family" arg is redundant.
> 
>     Since the server address is obtained from server_fd,  there
>     is little reason not to get the server's socket type from the
>     server_fd also.  getsockopt(server_fd) can be used to do that,
>     so "int type" arg is also removed.
> 
>     "int timeout_ms" is added.
> 
> 4) connect_fd_to_fd():
>     "int timeout_ms" is added.
>     Some code is also refactored to connect_fd_to_addr() which is
>     shared with connect_to_fd().
> 
> 5) Preserve errno:
>     Some callers need to check errno, e.g. cgroup_skb_sk_lookup.c.
>     Make changes to do it more consistently in save_errno_close()
>     and log_err().
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

LGTM. Ack with a few nits below.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/testing/selftests/bpf/network_helpers.c | 157 +++++++++++-------
>   tools/testing/selftests/bpf/network_helpers.h |   9 +-
>   .../bpf/prog_tests/cgroup_skb_sk_lookup.c     |  12 +-
>   .../bpf/prog_tests/connect_force_port.c       |  10 +-
>   .../bpf/prog_tests/load_bytes_relative.c      |   4 +-
>   .../selftests/bpf/prog_tests/tcp_rtt.c        |   4 +-
>   6 files changed, 110 insertions(+), 86 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
> index e36dd1a1780d..1a371d3eca7d 100644
> --- a/tools/testing/selftests/bpf/network_helpers.c
> +++ b/tools/testing/selftests/bpf/network_helpers.c
> @@ -7,8 +7,6 @@
>   
>   #include <arpa/inet.h>
>   
> -#include <sys/epoll.h>
> -
>   #include <linux/err.h>
>   #include <linux/in.h>
>   #include <linux/in6.h>
> @@ -17,8 +15,13 @@
>   #include "network_helpers.h"
>   
>   #define clean_errno() (errno == 0 ? "None" : strerror(errno))
> -#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
> -	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)
> +#define log_err(MSG, ...) ({						\
> +			int save = errno;				\

Typicallty, the variables used inside macro started with __, e.g.,
__save, to avoie shadowing.

> +			fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
> +				__FILE__, __LINE__, clean_errno(),	\
> +				##__VA_ARGS__);				\
> +			errno = save;					\
> +})
>   
>   struct ipv4_packet pkt_v4 = {
>   	.eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> @@ -37,7 +40,34 @@ struct ipv6_packet pkt_v6 = {
>   	.tcp.doff = 5,
>   };
>   
> -int start_server_with_port(int family, int type, __u16 port)
> +static int settimeo(int fd, int timeout_ms)
> +{
> +	struct timeval timeout = { .tv_sec = 3 };
> +
> +	if (timeout_ms > 0) {
> +		timeout.tv_sec = timeout_ms / 1000;
> +		timeout.tv_usec = (timeout_ms % 1000) * 1000;
> +	}
> +
> +	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout,
> +		       sizeof(timeout))) {
> +		log_err("Failed to set SO_RCVTIMEO");
> +		return -1;
> +	}
> +
> +	if (setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeout,
> +		       sizeof(timeout))) {
> +		log_err("Failed to set SO_SNDTIMEO");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +#define save_errno_close(fd) ({ int save = errno; close(fd); errno = save; })
> +
> +int start_server(int family, int type, const char *addr_str, __u16 port,
> +		 int timeout_ms)

Looks like non-NULL addr_str is not passed in all existing cased.
I guess this is for your later use case. It would be good to clarify
in the commit message.

>   {
>   	struct sockaddr_storage addr = {};
>   	socklen_t len;
> @@ -48,120 +78,119 @@ int start_server_with_port(int family, int type, __u16 port)
>   
>   		sin->sin_family = AF_INET;
>   		sin->sin_port = htons(port);
> +		if (addr_str &&
> +		    inet_pton(AF_INET, addr_str, &sin->sin_addr) != 1) {
> +			log_err("inet_pton(AF_INET, %s)", addr_str);
> +			return -1;
> +		}
>   		len = sizeof(*sin);
>   	} else {
>   		struct sockaddr_in6 *sin6 = (void *)&addr;
>   
>   		sin6->sin6_family = AF_INET6;
>   		sin6->sin6_port = htons(port);
> +		if (addr_str &&
> +		    inet_pton(AF_INET6, addr_str, &sin6->sin6_addr) != 1) {
> +			log_err("inet_pton(AF_INET6, %s)", addr_str);
> +			return -1;
> +		}
>   		len = sizeof(*sin6);
>   	}
>   
> -	fd = socket(family, type | SOCK_NONBLOCK, 0);
> +	fd = socket(family, type, 0);
>   	if (fd < 0) {
>   		log_err("Failed to create server socket");
>   		return -1;
>   	}
>   
> +	if (settimeo(fd, timeout_ms))
> +		goto error_close;
> +
>   	if (bind(fd, (const struct sockaddr *)&addr, len) < 0) {
>   		log_err("Failed to bind socket");
> -		close(fd);
> -		return -1;
> +		goto error_close;
>   	}
>   
>   	if (type == SOCK_STREAM) {
>   		if (listen(fd, 1) < 0) {
>   			log_err("Failed to listed on socket");
> -			close(fd);
> -			return -1;
> +			goto error_close;
>   		}
>   	}
>   
>   	return fd;
> -}
>   
> -int start_server(int family, int type)
> -{
> -	return start_server_with_port(family, type, 0);
> +error_close:
> +	save_errno_close(fd);
> +	return -1;
>   }
>   
[...]
> diff --git a/tools/testing/selftests/bpf/prog_tests/connect_force_port.c b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
> index 17bbf76812ca..9229db2f5ca5 100644
> --- a/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
> +++ b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
> @@ -114,7 +114,7 @@ static int run_test(int cgroup_fd, int server_fd, int family, int type)
>   		goto close_bpf_object;
>   	}
>   
> -	fd = connect_to_fd(family, type, server_fd);
> +	fd = connect_to_fd(server_fd, 0);
>   	if (fd < 0) {
>   		err = -1;
>   		goto close_bpf_object;
> @@ -137,25 +137,25 @@ void test_connect_force_port(void)
>   	if (CHECK_FAIL(cgroup_fd < 0))
>   		return;
>   
> -	server_fd = start_server_with_port(AF_INET, SOCK_STREAM, 60123);
> +	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 60123, 0);
>   	if (CHECK_FAIL(server_fd < 0))
>   		goto close_cgroup_fd;
>   	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET, SOCK_STREAM));
>   	close(server_fd);
>   
> -	server_fd = start_server_with_port(AF_INET6, SOCK_STREAM, 60124);
> +	server_fd = start_server(AF_INET6, SOCK_STREAM, NULL, 60124, 0);
>   	if (CHECK_FAIL(server_fd < 0))
>   		goto close_cgroup_fd;
>   	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET6, SOCK_STREAM));
>   	close(server_fd);
>   
> -	server_fd = start_server_with_port(AF_INET, SOCK_DGRAM, 60123);
> +	server_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 60123, 0);
>   	if (CHECK_FAIL(server_fd < 0))
>   		goto close_cgroup_fd;
>   	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET, SOCK_DGRAM));
>   	close(server_fd);
>   
> -	server_fd = start_server_with_port(AF_INET6, SOCK_DGRAM, 60124);
> +	server_fd = start_server(AF_INET6, SOCK_DGRAM, NULL, 60124, 0);
>   	if (CHECK_FAIL(server_fd < 0))
>   		goto close_cgroup_fd;
>   	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET6, SOCK_DGRAM));
> diff --git a/tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c b/tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c
> index c1168e4a9036..5a2a689dbb68 100644
> --- a/tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c
> +++ b/tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c
> @@ -23,7 +23,7 @@ void test_load_bytes_relative(void)
>   	if (CHECK_FAIL(cgroup_fd < 0))
>   		return;
>   
> -	server_fd = start_server(AF_INET, SOCK_STREAM);
> +	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
>   	if (CHECK_FAIL(server_fd < 0))
>   		goto close_cgroup_fd;
>   
> @@ -49,7 +49,7 @@ void test_load_bytes_relative(void)
>   	if (CHECK_FAIL(err))
>   		goto close_bpf_object;
>   
> -	client_fd = connect_to_fd(AF_INET, SOCK_STREAM, server_fd);
> +	client_fd = connect_to_fd(server_fd, 0);
>   	if (CHECK_FAIL(client_fd < 0))
>   		goto close_bpf_object;
>   	close(client_fd);
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> index 9013a0c01eed..d207e968e6b1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> @@ -118,7 +118,7 @@ static int run_test(int cgroup_fd, int server_fd)
>   		goto close_bpf_object;
>   	}
>   
> -	client_fd = connect_to_fd(AF_INET, SOCK_STREAM, server_fd);
> +	client_fd = connect_to_fd(server_fd, 0);
>   	if (client_fd < 0) {
>   		err = -1;
>   		goto close_bpf_object;
> @@ -161,7 +161,7 @@ void test_tcp_rtt(void)
>   	if (CHECK_FAIL(cgroup_fd < 0))
>   		return;
>   
> -	server_fd = start_server(AF_INET, SOCK_STREAM);
> +	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
>   	if (CHECK_FAIL(server_fd < 0))
>   		goto close_cgroup_fd;
>   
> 
