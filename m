Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55062CF8D3
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731188AbgLEBvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 20:51:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54418 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727765AbgLEBvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 20:51:09 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0B51o8h3010233;
        Fri, 4 Dec 2020 17:50:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=OFW9XJKO27o+7GdY1oG2McYZGweNIhTi8Hebt30wdrI=;
 b=Rzn3p3AAFSh9zscDnFaU8m1DQuj5tg9x8fp2HdJsnIlWLvQDnQNqth7wYnJfhhQL3Tsm
 3YR8V+uN7TXeNO5LfVeskQaET8T0qx4br8TGVQwQ15OqC1NBn7jEZP06D09CvDiFi6N4
 V1LVXRZpolE3zOfqk6FHtz10NVV6VYTzH+8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 357y1r0eeq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Dec 2020 17:50:08 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 17:50:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYSMUl9BDVxUvF92LalopFNT6cCi3zeRgihQqcx04qbU2LLECLZvU9SWYikSa2GME78/HEzSpbWRTwpdkk0aplPQmqfmD2RoJMbt4grUkHCEDuOPwtqrFCBQqHEhvSvqHlKR5IJnI8N9Jv+uNRnehbX5n/w7LCNx6335Qt4s+qLkGnntCQ2SHuMf0HL6VzqKjJBtWJBWA6UBGBfC3m7mZnCpd+xOcgKAt469/spe0O35QF4iG6u2x5Hrx5JA0Luwe3cEo+GoMbhWm5rtBdid724DV3rdlPBw4rwmPf3Vt+RrKVAR/DLmyhLN0N3jMiilUv7izD5+Ql4VfCtVxLTS/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFW9XJKO27o+7GdY1oG2McYZGweNIhTi8Hebt30wdrI=;
 b=eaHTUqKbUuOUqsfULu8KdXwEEXtTSYNFuOtzJ4H1VCD+Oidi8NCvByqXt9XT5Kp/EEY+hwZXXOxhjE6hrnSNy3krbp9YG00t9NUWeTsso7nsxB6CrssKU56lDFnnEGHAh2Ly3s/lsc7516BRy5h77+mKj+F2IHcxA6kbIKf6CtBw3tMkSxNX47ae7E32cTqOs1uinvt7hEQ3N8E8H8Lyc4KgFYP72n/KkEdGDH3sWfgLIR1AGMmTeAFpOuHX7FzuU2xCRoq9tWHkLSZDMH6u4nRFR9ihRjSjPWYsSMngY6nLgtQShBVD10DS3edYlfmUOkJckJgvwo/QMmuUpBZ1+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFW9XJKO27o+7GdY1oG2McYZGweNIhTi8Hebt30wdrI=;
 b=iwLPADWV1O87cY/ticGqrBq4fO6EhafsPe9R6pR8mcVQVRaAGX3aaQiwYP6lN24OK6L/huqOyKr9Ddr0J5Za2Ti+AL+3KqcrNlWX3MY7HJCYI5P3PkQtEA/AnLp39QPJ7N768n+1/ew6qEB0rVG6rWTNOV6mxxpywfmaNLF7S98=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Sat, 5 Dec
 2020 01:50:07 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 01:50:07 +0000
Date:   Fri, 4 Dec 2020 17:50:00 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 11/11] bpf: Test
 BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
Message-ID: <20201205015000.duec3x4lydhrsq5f@kafai-mbp.dhcp.thefacebook.com>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
 <20201201144418.35045-12-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201144418.35045-12-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:4e20]
X-ClientProxiedBy: MWHPR1201CA0016.namprd12.prod.outlook.com
 (2603:10b6:301:4a::26) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:4e20) by MWHPR1201CA0016.namprd12.prod.outlook.com (2603:10b6:301:4a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 01:50:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eba829b8-783d-4ce7-cdc7-08d898c017b8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2999:
X-Microsoft-Antispam-PRVS: <BYAPR15MB29990B64AD05132F01D8DFDED5F00@BYAPR15MB2999.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RbBVPXLrgkUYELIsTU3gMlmZDmCBd4DxlnPW5lLtE1/s1DVQhC2NYXwJR//bm17tqIzQbiphh4ztdxMtJTIC3EEnXkybFUh1gQYBr1qEXR9mfaQrad34eQbttsxA/t2EdzgYeypu3v7TeTthQVUMD1KBHlfFZxzNKz+Dmwg9pfu6NMDWytNTBAbsQaVInew4LS4bcoWWnnwtrxZJtty7pPm/3cV+jmTvNauqP4wkZK4gsy4XomGZTGA90pF5ZSdy3qHh4YuAnJNq+kcCXWvqTVKvLFkWp/ACUI8izkPnXXjvPj7/pyc502mCC5IY7GPI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(39860400002)(376002)(396003)(9686003)(83380400001)(6506007)(7696005)(55016002)(4326008)(52116002)(478600001)(8676002)(6916009)(5660300002)(66476007)(7416002)(316002)(66946007)(54906003)(86362001)(66556008)(2906002)(8936002)(6666004)(186003)(1076003)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H9aGqt7MKJHBOM39lcV9qAES7BV3PC0pI0r07bdshwsrEIs/5Z44kakLieJ0?=
 =?us-ascii?Q?jZqo5fbev5s28QIQ+IrJKXYkOoYJTSKguDITmVlhxU2OE1EyeTCpRpEGKACw?=
 =?us-ascii?Q?Dz2REpW+8UXBmw2A4h3h7H//HjY+FInD1tlT1TWtnfWse7A5AUPgjZ9C8Iju?=
 =?us-ascii?Q?355G1LGVYlWka+hCBjdH9iEbKznyPv5cKbYMDKMfroCTW7fpSemGi0QD8u2z?=
 =?us-ascii?Q?F2x93eYNJM1sxhnT2mSa0mDIU4bBWxDtBJXpBupBlgpcTBEJM8ZGtgQ+V5Y+?=
 =?us-ascii?Q?VsfBbhgtq8i+A29hpUdQG2PoojKATQsdYaKMwDDG2Y7QNCv4FI7xiEoakQev?=
 =?us-ascii?Q?YJC0iB67olhwysBaHZYQvBkaDlzGhiJRNbIFW/ExBNImxqOGQFqVHSkeN5nS?=
 =?us-ascii?Q?6TxrGkOr7Q5iRXKRB/hknRHUPKx95EIXYYp6WZ6nA896rivm0130JBOrcU37?=
 =?us-ascii?Q?JEG9aZfTz058X3i9e66qLhIAKjP5rpqsS0xG2CraDSRL0b4Epx5ZkKdIPYXi?=
 =?us-ascii?Q?HW6GVq0FO1FjwQJ+mii53cC96BAzz230QxYi0jwW0GeMJOlnJcoxK72bNepr?=
 =?us-ascii?Q?AkJoyNdLz4zFrWqPNuo2qGkmgLgGgpDw7mHcVnEDZYIa1u7b7rOVQxBxPuw2?=
 =?us-ascii?Q?dRZTW4lX2hw0VDndMr2hBZQ29/cZ1RcAG4EEdEPW2UhMfhDuc9v+GXdIQ5j3?=
 =?us-ascii?Q?yy6fkkBMiwaUGBcN/ABYkzSr7wB7v8p5NlGI/PVGfaaQjPy3kb/AZc7jD3EV?=
 =?us-ascii?Q?pC7DwJTzk/llR4o7lGI4X5lUgWxKVG8h/Aef2lOuVwVOJYLzPmVxi9cGbAKt?=
 =?us-ascii?Q?V/+SB15PRmys+oqh1oMglo99GAvvqh3P7mr8fXpCxRxD/7xOWWHk8KEZSBI4?=
 =?us-ascii?Q?Y5LTxRMqRG7hyymZ3ghs2av+f3qgd0c1ezavHjvOjNLeQFHzHQRMVHFb/yA5?=
 =?us-ascii?Q?THkHuDdZKF5+ZHUHieyv3lTATOwLR331WNBBsO7rwyjZcAWePcSNOmcKVUes?=
 =?us-ascii?Q?2kLsUWjdwySKQXZz4GrO8EA7Tg=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 01:50:07.1225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: eba829b8-783d-4ce7-cdc7-08d898c017b8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VuGKGp5ytv3c60oJFa0bFRRT6lPgrfVIUyLXyRzdRv9ti0cgSR0eXyO29MvzVcSv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2999
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_13:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 mlxscore=0 suspectscore=1 adultscore=0 spamscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012050009
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 11:44:18PM +0900, Kuniyuki Iwashima wrote:
> This patch adds a test for BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
> 
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  .../bpf/prog_tests/migrate_reuseport.c        | 164 ++++++++++++++++++
>  .../bpf/progs/test_migrate_reuseport_kern.c   |  54 ++++++
>  2 files changed, 218 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
> new file mode 100644
> index 000000000000..87c72d9ccadd
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
> @@ -0,0 +1,164 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Check if we can migrate child sockets.
> + *
> + *   1. call listen() for 5 server sockets.
> + *   2. update a map to migrate all child socket
> + *        to the last server socket (migrate_map[cookie] = 4)
> + *   3. call connect() for 25 client sockets.
> + *   4. call close() for first 4 server sockets.
> + *   5. call accept() for the last server socket.
> + *
> + * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> + */
> +
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <netinet/in.h>
> +#include <arpa/inet.h>
> +#include <linux/bpf.h>
> +#include <sys/socket.h>
> +#include <sys/types.h>
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +
> +#define NUM_SOCKS 5
> +#define LOCALHOST "127.0.0.1"
> +#define err_exit(condition, message)			      \
> +	do {						      \
> +		if (condition) {			      \
> +			perror("ERROR: " message " ");	      \
> +			exit(1);			      \
> +		}					      \
> +	} while (0)
> +
> +__u64 server_fds[NUM_SOCKS];
> +int prog_fd, reuseport_map_fd, migrate_map_fd;
> +
> +
> +void setup_bpf(void)
> +{
> +	struct bpf_object *obj;
> +	struct bpf_program *prog;
> +	struct bpf_map *reuseport_map, *migrate_map;
> +	int err;
> +
> +	obj = bpf_object__open("test_migrate_reuseport_kern.o");
> +	err_exit(libbpf_get_error(obj), "opening BPF object file failed");
> +
> +	err = bpf_object__load(obj);
> +	err_exit(err, "loading BPF object failed");
> +
> +	prog = bpf_program__next(NULL, obj);
> +	err_exit(!prog, "loading BPF program failed");
> +
> +	reuseport_map = bpf_object__find_map_by_name(obj, "reuseport_map");
> +	err_exit(!reuseport_map, "loading BPF reuseport_map failed");
> +
> +	migrate_map = bpf_object__find_map_by_name(obj, "migrate_map");
> +	err_exit(!migrate_map, "loading BPF migrate_map failed");
> +
> +	prog_fd = bpf_program__fd(prog);
> +	reuseport_map_fd = bpf_map__fd(reuseport_map);
> +	migrate_map_fd = bpf_map__fd(migrate_map);
> +}
> +
> +void test_listen(void)
> +{
> +	struct sockaddr_in addr;
> +	socklen_t addr_len = sizeof(addr);
> +	int i, err, optval = 1, migrated_to = NUM_SOCKS - 1;
> +	__u64 value;
> +
> +	addr.sin_family = AF_INET;
> +	addr.sin_port = htons(80);
> +	inet_pton(AF_INET, LOCALHOST, &addr.sin_addr.s_addr);
> +
> +	for (i = 0; i < NUM_SOCKS; i++) {
> +		server_fds[i] = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
> +		err_exit(server_fds[i] == -1, "socket() for listener sockets failed");
> +
> +		err = setsockopt(server_fds[i], SOL_SOCKET, SO_REUSEPORT,
> +				 &optval, sizeof(optval));
> +		err_exit(err == -1, "setsockopt() for SO_REUSEPORT failed");
> +
> +		if (i == 0) {
> +			err = setsockopt(server_fds[i], SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF,
> +					 &prog_fd, sizeof(prog_fd));
> +			err_exit(err == -1, "setsockopt() for SO_ATTACH_REUSEPORT_EBPF failed");
> +		}
> +
> +		err = bind(server_fds[i], (struct sockaddr *)&addr, addr_len);
> +		err_exit(err == -1, "bind() failed");
> +
> +		err = listen(server_fds[i], 32);
> +		err_exit(err == -1, "listen() failed");
> +
> +		err = bpf_map_update_elem(reuseport_map_fd, &i, &server_fds[i], BPF_NOEXIST);
> +		err_exit(err == -1, "updating BPF reuseport_map failed");
> +
> +		err = bpf_map_lookup_elem(reuseport_map_fd, &i, &value);
> +		err_exit(err == -1, "looking up BPF reuseport_map failed");
> +
> +		printf("fd[%d] (cookie: %llu) -> fd[%d]\n", i, value, migrated_to);
> +		err = bpf_map_update_elem(migrate_map_fd, &value, &migrated_to, BPF_NOEXIST);
> +		err_exit(err == -1, "updating BPF migrate_map failed");
> +	}
> +}
> +
> +void test_connect(void)
> +{
> +	struct sockaddr_in addr;
> +	socklen_t addr_len = sizeof(addr);
> +	int i, err, client_fd;
> +
> +	addr.sin_family = AF_INET;
> +	addr.sin_port = htons(80);
> +	inet_pton(AF_INET, LOCALHOST, &addr.sin_addr.s_addr);
> +
> +	for (i = 0; i < NUM_SOCKS * 5; i++) {
> +		client_fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
> +		err_exit(client_fd == -1, "socket() for listener sockets failed");
> +
> +		err = connect(client_fd, (struct sockaddr *)&addr, addr_len);
> +		err_exit(err == -1, "connect() failed");
> +
> +		close(client_fd);
> +	}
> +}
> +
> +void test_close(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < NUM_SOCKS - 1; i++)
> +		close(server_fds[i]);
> +}
> +
> +void test_accept(void)
> +{
> +	struct sockaddr_in addr;
> +	socklen_t addr_len = sizeof(addr);
> +	int cnt, client_fd;
> +
> +	fcntl(server_fds[NUM_SOCKS - 1], F_SETFL, O_NONBLOCK);
> +
> +	for (cnt = 0; cnt < NUM_SOCKS * 5; cnt++) {
> +		client_fd = accept(server_fds[NUM_SOCKS - 1], (struct sockaddr *)&addr, &addr_len);
> +		err_exit(client_fd == -1, "accept() failed");
> +	}
> +
> +	printf("%d accepted, %d is expected\n", cnt, NUM_SOCKS * 5);
> +}
> +
> +int main(void)
I am pretty sure "make -C tools/testing/selftests/bpf"
will not compile here because of double main() with
the test_progs.c.

Please take a look at how other tests are written in
tools/testing/selftests/bpf/prog_tests/. e.g.
the test function in tcp_hdr_options.c is
test_tcp_hdr_options().

Also, instead of bpf_object__open(), please use skeleton
like most of the tests do.


> +{
> +	setup_bpf();
> +	test_listen();
> +	test_connect();
> +	test_close();
> +	test_accept();
> +	close(server_fds[NUM_SOCKS - 1]);
> +	return 0;
> +}
