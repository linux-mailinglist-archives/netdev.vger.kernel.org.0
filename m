Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155A0193032
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgCYSSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:18:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727129AbgCYSSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:18:11 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PI8xWH023849;
        Wed, 25 Mar 2020 11:17:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=doatDUpo10CHfRgb0C/+2JcKNJ4rTzAhPv/tbX6UO4E=;
 b=rhNMWdHKblPxAS+MZ6z0qgtBO6TH8GuHzxdLArl/WtiMYJ57D/icdFFILHVlelJ5nR+Y
 3tBwZFJP5hMMtVc20fCbK6Qyv46FWfoGYvNgayNMiL+XdnpeTNiLCdiHPymMkqICRsG2
 bjLf4AuWQlkblnNbzcof9z48+jFUuf3kulA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yx2uea19m-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Mar 2020 11:17:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 25 Mar 2020 11:17:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PO26wsBxIecJeaCoK/6tqAO9P4Dw60eEaU/xOwpoDLzdetEsqncOLx0dZZrSAXAievag67KLTplMh9GDBEC4NDCWMCDBKd9GAqQ79xW4tBkQOMT2tE8cYpcRr/YxEv90L6r1s/+qiJaWEDFvYXUULGNST20xsxhVnO85ttanxwmapCK1eJmwNLgwx6AdtRCN3s6ofKpmtb+2rTKzpbTYeCw1kaRMtEuSKgwFdf1iD2sZdvCw6HTtYUCRgPJ1bNvkp0FpVTRcQ1ywFtZ6TbOcrKZUJtVtPlZZetc7h6VxW15Tw1WhL2u88uYXCIs1+HjDlLbEvLUGokgS7Jx8zFzvIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doatDUpo10CHfRgb0C/+2JcKNJ4rTzAhPv/tbX6UO4E=;
 b=KAfjORz43fn4QRwslOBroWn8E/+oEWGdKtuda6qPXDZitvI9g5TA1CJqq2FavhO4TH8mNOkxvXcAA/uVjXEievdG17sw+NRnVdDY1PO9sZ0bkRYBWdv2qKA3X9zTrvrKojRGi/sCPFYrnVsi33ycoK/QMQcwakiL9Ym12tdEOx+2PbqsAdw+LhNu+iaV6zzcr9IcfifFTIQnfX4hSMn62fiOm9DTV2syCBMydMbMOFqvq/QdbEdQwRjEejiTUE4toGJJPVvtD/LGAVLz+KupgHo3bCSbapKYgSBlCzK7NcOnzLTaGaHQyGlEN1DKpktfmOsXOxl13Jst3z0XDbyoUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doatDUpo10CHfRgb0C/+2JcKNJ4rTzAhPv/tbX6UO4E=;
 b=c4Yvqmp8GZfdeQXMojYKTw9+5QNVAVajMdd6AGrLFbqYpMFK7qroAvlUKCuBLhlVI/u3+4VoqlcAqK2JsIfrdHc8At12c3vL1LsfjFcsI8PnQPqLU+hYUjzf9BFE8Gs9MNZzxM28zugzNjKCY0FqsaA8Oyclb946zmqW7ZWcdFI=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3819.namprd15.prod.outlook.com (2603:10b6:303:43::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15; Wed, 25 Mar
 2020 18:17:49 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 18:17:49 +0000
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
To:     Joe Stringer <joe@wand.net.nz>, <bpf@vger.kernel.org>
CC:     Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <eric.dumazet@gmail.com>,
        <kafai@fb.com>
References: <20200325055745.10710-1-joe@wand.net.nz>
 <20200325055745.10710-6-joe@wand.net.nz>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com>
Date:   Wed, 25 Mar 2020 11:17:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200325055745.10710-6-joe@wand.net.nz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0006.namprd14.prod.outlook.com
 (2603:10b6:300:ae::16) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mdiab-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:694d) by MWHPR14CA0006.namprd14.prod.outlook.com (2603:10b6:300:ae::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Wed, 25 Mar 2020 18:17:48 +0000
X-Originating-IP: [2620:10d:c090:400::5:694d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf7c0f2c-0b10-4cbb-f541-08d7d0e8d388
X-MS-TrafficTypeDiagnostic: MW3PR15MB3819:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38197FAF107DB9A19E7585FAD3CE0@MW3PR15MB3819.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:133;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(376002)(396003)(39860400002)(31686004)(66946007)(66556008)(66476007)(5660300002)(316002)(36756003)(52116002)(6486002)(86362001)(30864003)(81156014)(53546011)(2616005)(4326008)(6506007)(31696002)(2906002)(6512007)(478600001)(186003)(16526019)(8676002)(8936002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3819;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /aA8MHxhJ65lD+clTv8KWmiNIngO2hE0U9b6DiqzVB5PrQPUavdnjgNrOmnXwHACUWLC+bKicqawXyHsclxYiaO5cHJQTQIPilTrcjsV9OKjMUn76nQLFrePByTQyOAkQ/0nOh8dsKzLrtaZARG7L9gYeQjXjZwTP9shLmgK/5x/OSRMdFAaTlaUOwg5eOj8NYZNAeWYSjPwjnSsfCnvJvZQjGRd8WhTQ4HCmyAxalJfzsYUU+ICO63PReawzpghw0F5xcMTivDXmw3uHL+Hk/4sB+C4QpjcXqS84AFE1zjz/8L9o2lQVL1J8+fJGb2+ewDo9sU0nABf6EitktB6KhGmoL47O8zY77lrPwMe92XDgfBsj0/l7q6rFZ4QRAPFs8K67/JW6s97nvAxe5Yp5VLlkcoYFJjfOcO8dOtkREldaewBET4Hb6glyc00fG7b
X-MS-Exchange-AntiSpam-MessageData: I2cxUHu9Z+4e9ZeJVs4ruW6Jb3MAhzOziOsOs9/W0y5yfITEcuqyTZL41lm9un8XzOBKAo8iwENi8zH7NFx2MzT8sfRoAZ0QzCGFmPXTiLPAIJXKcHqrt9UHC1DWduHqaCW61u1AkCgRHCXaz8E9MEUsVyBNwXiJUquGygsjjw/VzHFBwOUUM4F4Wtezov2R
X-MS-Exchange-CrossTenant-Network-Message-Id: bf7c0f2c-0b10-4cbb-f541-08d7d0e8d388
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 18:17:49.8821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gbJY3pWjL/XHM3+EhTAYT/udLE+vHKIdFyiCMkcO/aPJqrfuc4S2Hk3o8RPCZDj1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3819
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_09:2020-03-24,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1011 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/20 10:57 PM, Joe Stringer wrote:
> From: Lorenz Bauer <lmb@cloudflare.com>
> 
> Attach a tc direct-action classifier to lo in a fresh network
> namespace, and rewrite all connection attempts to localhost:4321
> to localhost:1234 (for port tests) and connections to unreachable
> IPv4/IPv6 IPs to the local socket (for address tests).
> 
> Keep in mind that both client to server and server to client traffic
> passes the classifier.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Co-authored-by: Joe Stringer <joe@wand.net.nz>
> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> ---
> v2: Rebase onto test_progs infrastructure
> v1: Initial commit
> ---
>   tools/testing/selftests/bpf/Makefile          |   2 +-
>   .../selftests/bpf/prog_tests/sk_assign.c      | 244 ++++++++++++++++++
>   .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++
>   3 files changed, 372 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 7729892e0b04..4f7f83d059ca 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -76,7 +76,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>   # Compile but not part of 'make run_tests'
>   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>   	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> -	test_lirc_mode2_user xdping test_cpp runqslower
> +	test_lirc_mode2_user xdping test_cpp runqslower test_sk_assign

No test_sk_assign any more as the test is integrated into test_progs, right?

>   
>   TEST_CUSTOM_PROGS = urandom_read
>   
> diff --git a/tools/testing/selftests/bpf/prog_tests/sk_assign.c b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
> new file mode 100644
> index 000000000000..1f0afcc20c48
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
> @@ -0,0 +1,244 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2018 Facebook
> +// Copyright (c) 2019 Cloudflare
> +// Copyright (c) 2020 Isovalent, Inc.
> +/*
> + * Test that the socket assign program is able to redirect traffic towards a
> + * socket, regardless of whether the port or address destination of the traffic
> + * matches the port.
> + */
> +
> +#define _GNU_SOURCE
> +#include <fcntl.h>
> +#include <signal.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +
> +#include "test_progs.h"
> +
> +#define TEST_DPORT 4321
> +#define TEST_DADDR (0xC0A80203)
> +#define NS_SELF "/proc/self/ns/net"
> +
> +static __u32 duration;
> +
> +static bool configure_stack(int self_net)

self_net parameter is not used.

> +{
> +	/* Move to a new networking namespace */
> +	if (CHECK_FAIL(unshare(CLONE_NEWNET)))
> +		return false;

You can use CHECK to encode better error messages. Thhis is what
most test_progs tests are using.

> +	/* Configure necessary links, routes */
> +	if (CHECK_FAIL(system("ip link set dev lo up")))
> +		return false;
> +	if (CHECK_FAIL(system("ip route add local default dev lo")))
> +		return false;
> +	if (CHECK_FAIL(system("ip -6 route add local default dev lo")))
> +		return false;
> +
> +	/* Load qdisc, BPF program */
> +	if (CHECK_FAIL(system("tc qdisc add dev lo clsact")))
> +		return false;
> +	if (CHECK_FAIL(system("tc filter add dev lo ingress bpf direct-action "
> +		     "object-file ./test_sk_assign.o section sk_assign_test")))
> +		return false;
> +
> +	return true;
> +}
> +
> +static int start_server(const struct sockaddr *addr, socklen_t len)
> +{
> +	int fd;
> +
> +	fd = socket(addr->sa_family, SOCK_STREAM, 0);
> +	if (CHECK_FAIL(fd == -1))
> +		goto out;
> +	if (CHECK_FAIL(bind(fd, addr, len) == -1))
> +		goto close_out;
> +	if (CHECK_FAIL(listen(fd, 128) == -1))
> +		goto close_out;
> +
> +	goto out;
> +
> +close_out:
> +	close(fd);
> +	fd = -1;
> +out:
> +	return fd;
> +}
> +
> +static void handle_timeout(int signum)
> +{
> +	if (signum == SIGALRM)
> +		fprintf(stderr, "Timed out while connecting to server\n");
> +	kill(0, SIGKILL);
> +}
> +
> +static struct sigaction timeout_action = {
> +	.sa_handler = handle_timeout,
> +};
> +
> +static int connect_to_server(const struct sockaddr *addr, socklen_t len)
> +{
> +	int fd = -1;
> +
> +	fd = socket(addr->sa_family, SOCK_STREAM, 0);
> +	if (CHECK_FAIL(fd == -1))
> +		goto out;
> +	if (CHECK_FAIL(sigaction(SIGALRM, &timeout_action, NULL)))
> +		goto out;

should this goto close_out?

> +	alarm(3);
> +	if (CHECK_FAIL(connect(fd, addr, len) == -1))
> +		goto close_out;
> +
> +	goto out;
> +
> +close_out:
> +	close(fd);
> +	fd = -1;
> +out:
> +	return fd;
> +}
> +
> +static in_port_t get_port(int fd)
> +{
> +	struct sockaddr_storage name;
> +	socklen_t len;
> +	in_port_t port = 0;
> +
> +	len = sizeof(name);
> +	if (CHECK_FAIL(getsockname(fd, (struct sockaddr *)&name, &len)))
> +		return port;
> +
> +	switch (name.ss_family) {
> +	case AF_INET:
> +		port = ((struct sockaddr_in *)&name)->sin_port;
> +		break;
> +	case AF_INET6:
> +		port = ((struct sockaddr_in6 *)&name)->sin6_port;
> +		break;
> +	default:
> +		CHECK(1, "Invalid address family", "%d\n", name.ss_family);
> +	}
> +	return port;
> +}
> +
> +static int run_test(int server_fd, const struct sockaddr *addr, socklen_t len)
> +{
> +	int client = -1, srv_client = -1;
> +	char buf[] = "testing";
> +	in_port_t port;
> +	int ret = 1;
> +
> +	client = connect_to_server(addr, len);
> +	if (client == -1) {
> +		perror("Cannot connect to server");
> +		goto out;
> +	}
> +
> +	srv_client = accept(server_fd, NULL, NULL);
> +	if (CHECK_FAIL(srv_client == -1)) {
> +		perror("Can't accept connection");
> +		goto out;
> +	}
> +	if (CHECK_FAIL(write(client, buf, sizeof(buf)) != sizeof(buf))) {
> +		perror("Can't write on client");
> +		goto out;
> +	}
> +	if (CHECK_FAIL(read(srv_client, buf, sizeof(buf)) != sizeof(buf))) {
> +		perror("Can't read on server");
> +		goto out;
> +	}
> +
> +	port = get_port(srv_client);
> +	if (CHECK_FAIL(!port))
> +		goto out;
> +	if (CHECK(port != htons(TEST_DPORT), "Expected", "port %u but got %u",
> +		  TEST_DPORT, ntohs(port)))
> +		goto out;
> +
> +	ret = 0;
> +out:
> +	close(client);
> +	close(srv_client);
> +	return ret;
> +}
> +
> +static int do_sk_assign(void)
> +{
> +	struct sockaddr_in addr4;
> +	struct sockaddr_in6 addr6;
> +	int server = -1;
> +	int server_v6 = -1;
> +	int err = 1;
> +
> +	memset(&addr4, 0, sizeof(addr4));
> +	addr4.sin_family = AF_INET;
> +	addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
> +	addr4.sin_port = htons(1234);
> +
> +	memset(&addr6, 0, sizeof(addr6));
> +	addr6.sin6_family = AF_INET6;
> +	addr6.sin6_addr = in6addr_loopback;
> +	addr6.sin6_port = htons(1234);
> +
> +	server = start_server((const struct sockaddr *)&addr4, sizeof(addr4));
> +	if (server == -1)
> +		goto out;
> +
> +	server_v6 = start_server((const struct sockaddr *)&addr6,
> +				 sizeof(addr6));
> +	if (server_v6 == -1)
> +		goto out;
> +
> +	/* Connect to unbound ports */
> +	addr4.sin_port = htons(TEST_DPORT);
> +	addr6.sin6_port = htons(TEST_DPORT);
> +
> +	test__start_subtest("ipv4 port redir");
> +	if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
> +		goto out;
> +
> +	test__start_subtest("ipv6 port redir");
> +	if (run_test(server_v6, (const struct sockaddr *)&addr6, sizeof(addr6)))
> +		goto out;
> +
> +	/* Connect to unbound addresses */
> +	addr4.sin_addr.s_addr = htonl(TEST_DADDR);
> +	addr6.sin6_addr.s6_addr32[3] = htonl(TEST_DADDR);
> +
> +	test__start_subtest("ipv4 addr redir");
> +	if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
> +		goto out;
> +
> +	test__start_subtest("ipv6 addr redir");
> +	if (run_test(server_v6, (const struct sockaddr *)&addr6, sizeof(addr6)))
> +		goto out;
> +
> +	err = 0;
> +out:
> +	close(server);
> +	close(server_v6);
> +	return err;
> +}
> +
> +void test_sk_assign(void)
> +{
> +	int self_net;
> +
> +	self_net = open(NS_SELF, O_RDONLY);
> +	if (CHECK_FAIL(self_net < 0)) {
> +		perror("Unable to open "NS_SELF);
> +		return;
> +	}
> +
> +	if (!configure_stack(self_net)) {
> +		perror("configure_stack");
> +		goto cleanup;
> +	}
> +
> +	do_sk_assign();
> +
> +cleanup:
> +	close(self_net);

Did we exit the newly unshared net namespace and restored the previous 
namespace?

> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_sk_assign.c b/tools/testing/selftests/bpf/progs/test_sk_assign.c
> new file mode 100644
> index 000000000000..7de30ad3f594
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_sk_assign.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Cloudflare Ltd.
> +
> +#include <stddef.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#include <linux/bpf.h>
> +#include <linux/if_ether.h>
> +#include <linux/in.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/pkt_cls.h>
> +#include <linux/tcp.h>
> +#include <sys/socket.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +int _version SEC("version") = 1;
> +char _license[] SEC("license") = "GPL";
> +
> +/* Fill 'tuple' with L3 info, and attempt to find L4. On fail, return NULL. */
> +static struct bpf_sock_tuple *get_tuple(void *data, __u64 nh_off,
> +					void *data_end, __u16 eth_proto,
> +					bool *ipv4)
> +{
> +	struct bpf_sock_tuple *result;
> +	__u8 proto = 0;
> +	__u64 ihl_len;
> +
> +	if (eth_proto == bpf_htons(ETH_P_IP)) {
> +		struct iphdr *iph = (struct iphdr *)(data + nh_off);
> +
> +		if (iph + 1 > data_end)
> +			return NULL;
> +		if (iph->ihl != 5)
> +			/* Options are not supported */
> +			return NULL;
> +		ihl_len = iph->ihl * 4;
> +		proto = iph->protocol;
> +		*ipv4 = true;
> +		result = (struct bpf_sock_tuple *)&iph->saddr;
> +	} else if (eth_proto == bpf_htons(ETH_P_IPV6)) {
> +		struct ipv6hdr *ip6h = (struct ipv6hdr *)(data + nh_off);
> +
> +		if (ip6h + 1 > data_end)
> +			return NULL;
> +		ihl_len = sizeof(*ip6h);
> +		proto = ip6h->nexthdr;
> +		*ipv4 = false;
> +		result = (struct bpf_sock_tuple *)&ip6h->saddr;
> +	} else {
> +		return NULL;
> +	}
> +
> +	if (result + 1 > data_end || proto != IPPROTO_TCP)
> +		return NULL;
> +
> +	return result;
> +}
> +
> +SEC("sk_assign_test")
> +int bpf_sk_assign_test(struct __sk_buff *skb)
> +{
> +	void *data_end = (void *)(long)skb->data_end;
> +	void *data = (void *)(long)skb->data;
> +	struct ethhdr *eth = (struct ethhdr *)(data);
> +	struct bpf_sock_tuple *tuple, ln = {0};
> +	struct bpf_sock *sk;
> +	int tuple_len;
> +	bool ipv4;
> +	int ret;
> +
> +	if (eth + 1 > data_end)
> +		return TC_ACT_SHOT;
> +
> +	tuple = get_tuple(data, sizeof(*eth), data_end, eth->h_proto, &ipv4);
> +	if (!tuple)
> +		return TC_ACT_SHOT;
> +
> +	tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
> +	sk = bpf_skc_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);

You can get rid of tuple_len with
	if (ipv4)
		sk = bpf_skc_lookup_tcp(..., sizeof(tuple->ipv4), ...);
	else
		sk = bpf_skc_lookup_tcp(..., sizeof(tuple->ipv6), ...);

and later on you can do common bpf_skc_lookup_tcp.
But it may not be worthwhile to do it, as you have two separate calls
in the above instead.

> +	if (sk) {
> +		if (sk->state != BPF_TCP_LISTEN)
> +			goto assign;
> +
> +		bpf_sk_release(sk);
> +	}
> +
> +	if (ipv4) {
> +		if (tuple->ipv4.dport != bpf_htons(4321))
> +			return TC_ACT_OK;
> +
> +		ln.ipv4.daddr = bpf_htonl(0x7f000001);
> +		ln.ipv4.dport = bpf_htons(1234);
> +
> +		sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv4),
> +					BPF_F_CURRENT_NETNS, 0);
> +	} else {
> +		if (tuple->ipv6.dport != bpf_htons(4321))
> +			return TC_ACT_OK;
> +
> +		/* Upper parts of daddr are already zero. */
> +		ln.ipv6.daddr[3] = bpf_htonl(0x1);
> +		ln.ipv6.dport = bpf_htons(1234);
> +
> +		sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv6),
> +					BPF_F_CURRENT_NETNS, 0);
> +	}
> +
> +	/* We can't do a single skc_lookup_tcp here, because then the compiler
> +	 * will likely spill tuple_len to the stack. This makes it lose all
> +	 * bounds information in the verifier, which then rejects the call as
> +	 * unsafe.
> +	 */

This is a known issue. For scalars, only constant is restored properly
in verifier at this moment. I did some hacking before to enable any
scalars. The fear is this will make pruning performs worse. More
study is needed here.

> +	if (!sk)
> +		return TC_ACT_SHOT;
> +
> +	if (sk->state != BPF_TCP_LISTEN) {
> +		bpf_sk_release(sk);
> +		return TC_ACT_SHOT;
> +	}
> +
> +assign:
> +	ret = bpf_sk_assign(skb, sk, 0);
> +	bpf_sk_release(sk);
> +	return ret == 0 ? TC_ACT_OK : TC_ACT_SHOT;
> +}
> 
