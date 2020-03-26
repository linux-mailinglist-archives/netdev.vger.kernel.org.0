Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB47193851
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgCZGBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:01:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55982 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725775AbgCZGBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:01:43 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02Q5x4DB029425;
        Wed, 25 Mar 2020 23:01:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Or7TT+9W2DTvqoSuVTumbum+YVVlH0zBum7a1Ldlxzo=;
 b=Syme+Qh/Go2k3FcpF8SoXFeFCl1A5UDz17ORN3TKSLiWQ8kQ6zYxkHO44rPXFd3J7Zbq
 yujBlgcDbfFk9oBBhpIbxvTjcHbS8+k++bIEsd05oIkYrVBwQSASEmjDrYy+d75E+wla
 6mcaVYVkOAWd9/TXEpL/trS0sXKPhr+b3hE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yx2uedvpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Mar 2020 23:01:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 25 Mar 2020 23:01:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6HULbS/+UDnnfUQyJsiz1qaOifpY1sOkjUwsGYScsRj3iNtVMo/ullHT6ceEPpMxQ1XlTlBckg2RvSRIlUnmDE1Wu1eFjY+hiIoBy0ztdJa0rYO/qULzW1+TSz+4V3xO4ZYoIP/WHY9A4Y8UECuVhFjQFALws2tH50N0ovhFPyGbbcINmTruRAkSBdH65tmWkWBaTgAocNLvRVDnVHT1L5h25iUWlR6ma1TgUQj7BZVjko2q/DQUDzPoFeWYjX2XAAtNnXzcOPTcXU01T6FER0f+TzijfV2L0Y8r/0EGMWD6Uqsi6Bwlu9Y0jjSVHxsRmtOT+DoRY+InClEEQrJKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Or7TT+9W2DTvqoSuVTumbum+YVVlH0zBum7a1Ldlxzo=;
 b=Nei3ofWsG6iOcDLEj7OUTGtaaS990fYs1IPosB1hPltEX0XXZFN45whrKS2zdjCAsxOUSC8SBkR/2HwSiuZI8MkwehCYw8y7dXL4eZgeFKGxQGKdyUJqRPRTZPgZZIGnZfCdTUuJycIJTlok5HtxVULn2HTcRZVYSa6f4fJ3GBUWrzWl9wBMAETxeLQqkRLv+lOmcJm5kAj3Xu/CAK4uq3Y9Ai9UmT3PSAABaDPjfNGO8X5JzT/Y0vmBvtnEXSXtVvqXerQqqpvlSdWFgM0lP5hRqEuS617TeOETNaLS+tlcxDnQyaZJj9316UhYbF6BFyZyjs/041FQI8YS4frLyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Or7TT+9W2DTvqoSuVTumbum+YVVlH0zBum7a1Ldlxzo=;
 b=FRPFU9ZhJtGNdNN8a8ElwyAjSTrE7yFyTPIflNxMnpyG7hkHFcTw7s23Eb8sXMI9cf0X4kgdKMpn1ZHhGjEhkXJO28P2PJSmpUFXKoXE6g0VBN5w9Z7b64cfPrkIgimMO1w9PQON5hMYawYN6HXBCK/YnzqP0g2/5dcE43Owi8o=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB4012.namprd15.prod.outlook.com (2603:10b6:303:47::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Thu, 26 Mar
 2020 06:01:30 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:01:30 +0000
Subject: Re: [Fixes ebpf-selftests]: Fold test_current_pid_tgid_new_ns into
 test_progs
To:     Carlos Neira <cneirabustos@gmail.com>, <netdev@vger.kernel.org>
CC:     <quentin@isovalent.com>, <ebiederm@xmission.com>,
        <brouer@redhat.com>, <bpf@vger.kernel.org>
References: <20200326040105.24297-1-cneirabustos@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <df5a826f-cca5-5957-75d8-eded61ec4e4a@fb.com>
Date:   Wed, 25 Mar 2020 23:01:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200326040105.24297-1-cneirabustos@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0201.namprd04.prod.outlook.com
 (2603:10b6:104:5::31) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:9f87) by CO2PR04CA0201.namprd04.prod.outlook.com (2603:10b6:104:5::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 06:01:29 +0000
X-Originating-IP: [2620:10d:c090:400::5:9f87]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 261f5297-5665-4395-029b-08d7d14b2113
X-MS-TrafficTypeDiagnostic: MW3PR15MB4012:
X-Microsoft-Antispam-PRVS: <MW3PR15MB40126C44AEA32841CEA2192ED3CF0@MW3PR15MB4012.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(136003)(346002)(376002)(6512007)(6506007)(31696002)(81156014)(81166006)(30864003)(66946007)(66556008)(66476007)(478600001)(8936002)(52116002)(2906002)(31686004)(86362001)(4326008)(53546011)(5660300002)(8676002)(186003)(6486002)(2616005)(36756003)(16526019)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB4012;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OcZZXK9S8RoCgA18nyx1pxgc5YoObpax6ngVcia/dt9ZdGJInPT5in1NS3D5XLUkR2/nRn1ZWzc16NzLTFMrlwmuIxWBNWc0q5qI4zp6DE95YAWg8u+vPC5lag6bgrJwig8BK1A6HK4ThEJlt4naTM8Coi+FCi98TNjtfJkVJCPHjfI+6IzoM7ZuXhGRkbJj5mlwT+RXYdImjopqJmWiZE/s01KQybfDcL+XCbwe0WyAOuoGKsd72D6H0IPzyj+uSHr0DAiQ/lxdkVmnLZjAShC7/KpLPohBrWpK4ueH2dfZL4pvvSMZ1Pqr+w5t5Zq422p2oDAg7PvysKb8LY1BmH+IpSyOY1Rao0tXmXEsbqg3BntzSSbRuXWvev66sg+wWr+MnAHYY3bN3SqsagZ5e7w314eDs0WSSKRomqfOyXBh3v7bcxLD+YD8p8jCvlmk
X-MS-Exchange-AntiSpam-MessageData: yv5vjR6kSVVC1Pt5Txq/D/1wslX4MIh34+rEB0WwdXHUUau63m6xPx1XoGb2riqGZmKeHMp9C6h7c/9nT8ytlMwSVxo2TpAZ0QaTgiKKx+I6L/F7El5mKCcapr5GsmTkkDnDfKs8aezBhe+9WVM+PNY+Lk/v4e3O2GN9bBPPAhD+B1D0y+iLr302lt/Q7Tpu
X-MS-Exchange-CrossTenant-Network-Message-Id: 261f5297-5665-4395-029b-08d7d14b2113
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:01:30.6698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kt4HQFwC7A3KcO0FLR+TX6YXtjqjP52EiNkhANM51nCtNzL2N08ZluK96BWsth0e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4012
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_15:2020-03-24,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1011 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/20 9:01 PM, Carlos Neira wrote:
> Move tests from test_current_pid_tgid_new_ns into test_progs.

For the patch subject, please use [PATCH bpf-next] as the tag, something 
like
   [PATCH bpf-next] bpf/selftests : fold test_current_pid_tgid_new_ns 
into test_progs

> 
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>   tools/testing/selftests/bpf/Makefile          |   3 +-
>   .../bpf/prog_tests/ns_current_pid_tgid.c      | 134 ++++++++++++++-
>   .../bpf/test_current_pid_tgid_new_ns.c        | 159 ------------------
>   3 files changed, 134 insertions(+), 162 deletions(-)
>   delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 7729892e0b04..f04617382b7b 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -33,8 +33,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>   	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
>   	test_cgroup_storage \
>   	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
> -	test_progs-no_alu32 \
> -	test_current_pid_tgid_new_ns
> +	test_progs-no_alu32
>   
>   # Also test bpf-gcc, if present
>   ifneq ($(BPF_GCC),)
> diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
> index 542240e16564..2fb76c014ae2 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
> @@ -1,10 +1,14 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
> +#define _GNU_SOURCE
>   #include <test_progs.h>
>   #include <sys/stat.h>
>   #include <sys/types.h>
>   #include <unistd.h>
>   #include <sys/syscall.h>
> +#include <sched.h>
> +#include <sys/wait.h>
> +#include <sys/mount.h>
>   
>   struct bss {
>   	__u64 dev;
> @@ -13,7 +17,7 @@ struct bss {
>   	__u64 user_pid_tgid;
>   };
>   
> -void test_ns_current_pid_tgid(void)
> +static void test_ns_current_pid_tgid_global_ns(void)
>   {
>   	const char *probe_name = "raw_tracepoint/sys_enter";
>   	const char *file = "test_ns_current_pid_tgid.o";
> @@ -86,3 +90,131 @@ void test_ns_current_pid_tgid(void)
>   	}
>   	bpf_object__close(obj);
>   }
> +
> +static void test_ns_current_pid_tgid_new_ns(void)
> +{
> +	pid_t pid;
> +	int duration = 0;

reverse christmas tree?

> +
> +	if (CHECK(unshare(CLONE_NEWPID | CLONE_NEWNS),
> +				"unshare CLONE_NEWPID | CLONE_NEWNS",
> +				"error errno=%d\n", errno))

proper indentation for the above?

Also the pidns and mountns state should be restored at the end
of the test.

> +		return;
> +
> +	pid = fork();
> +	if (pid == -1) {
> +		perror("Fork() failed\n");

For consistency and convention, we should use CHECK in this file
instead of perror.

> +		return;
> +	}
> +
> +	if (pid > 0) {
> +		int status;
> +
> +		usleep(5);
> +		waitpid(pid, &status, 0);
> +		return;
> +	} else {
> +
> +		pid = fork();
> +		if (pid == -1) {
> +			perror("Fork() failed\n");
> +			return;
> +		}

Not 100% sure why we need to fork() again. Some comments will good.

> +
> +		if (pid > 0) {
> +			int status;
> +
> +			waitpid(pid, &status, 0);
> +			return;
> +		} else {
> +			if (CHECK(mount("none", "/proc", NULL, MS_PRIVATE|MS_REC, NULL),
> +					"Unmounting proc", "Cannot umount proc! errno=%d\n", errno))
> +				return;

line too long, you can have
	err = mount(...);
	if (CHECK(err, ...))
the same for below.

> +
> +			if (CHECK(mount("proc", "/proc", "proc", MS_NOSUID|MS_NOEXEC|MS_NODEV, NULL),
> +					"Mounting proc", "Cannot mount proc! errno=%d\n", errno))
> +				return;
> +
> +
> +			const char *probe_name = "raw_tracepoint/sys_enter";
> +			const char *file = "test_ns_current_pid_tgid.o";

the skeleton is recommended for test_progs selftest. See send_signal.c 
for an example.

> +			int err, key = 0, duration = 0;
> +			struct bpf_link *link = NULL;
> +			struct bpf_program *prog;
> +			struct bpf_map *bss_map;
> +			struct bpf_object *obj;
> +			struct bss bss;
> +			struct stat st;
> +			__u64 id;
> +
> +
> +			obj = bpf_object__open_file(file, NULL);
> +			if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
> +				return;
> +
> +			err = bpf_object__load(obj);
> +			if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
> +				goto cleanup;
> +
> +			bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
> +			if (CHECK(!bss_map, "find_bss_map", "failed\n"))
> +				goto cleanup;
> +
> +			prog = bpf_object__find_program_by_title(obj, probe_name);
> +			if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
> +						probe_name))
> +				goto cleanup;
> +
> +			memset(&bss, 0, sizeof(bss));
> +			pid_t tid = syscall(SYS_gettid);
> +			pid_t pid = getpid();
> +
> +			id = (__u64) tid << 32 | pid;
> +			bss.user_pid_tgid = id;
> +
> +			if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
> +				perror("Failed to stat /proc/self/ns/pid");
> +				goto cleanup;
> +			}
> +
> +			bss.dev = st.st_dev;
> +			bss.ino = st.st_ino;
> +
> +			err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
> +			if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
> +				goto cleanup;
> +
> +			link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
> +			if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
> +						PTR_ERR(link))) {
> +				link = NULL;
> +				goto cleanup;
> +			}
> +
> +			/* trigger some syscalls */
> +			usleep(1);
> +
> +			err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
> +			if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
> +				goto cleanup;
> +
> +			if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
> +						"User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
> +				goto cleanup;
> +cleanup:
> +			if (!link) {
> +				bpf_link__destroy(link);
> +				link = NULL;
> +			}
> +			bpf_object__close(obj);
> +		}
> +	}
> +}
> +
> +void test_ns_current_pid_tgid(void)
> +{
> +	if (test__start_subtest("ns_current_pid_tgid_global_ns"))
> +		test_ns_current_pid_tgid_global_ns();
> +	if (test__start_subtest("ns_current_pid_tgid_new_ns"))
> +		test_ns_current_pid_tgid_new_ns();
> +}
> diff --git a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c b/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
> deleted file mode 100644
> index ed253f252cd0..000000000000
> --- a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
> +++ /dev/null
> @@ -1,159 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
> -#define _GNU_SOURCE
> -#include <sys/stat.h>
> -#include <sys/types.h>
> -#include <unistd.h>
> -#include <sys/syscall.h>
> -#include <sched.h>
> -#include <sys/wait.h>
> -#include <sys/mount.h>
> -#include "test_progs.h"
> -
> -#define CHECK_NEWNS(condition, tag, format...) ({		\
> -	int __ret = !!(condition);			\
> -	if (__ret) {					\
> -		printf("%s:FAIL:%s ", __func__, tag);	\
> -		printf(format);				\
> -	} else {					\
> -		printf("%s:PASS:%s\n", __func__, tag);	\
> -	}						\
> -	__ret;						\
> -})
> -
> -struct bss {
> -	__u64 dev;
> -	__u64 ino;
> -	__u64 pid_tgid;
> -	__u64 user_pid_tgid;
> -};
> -
> -int main(int argc, char **argv)
> -{
> -	pid_t pid;
> -	int exit_code = 1;
> -	struct stat st;
> -
> -	printf("Testing bpf_get_ns_current_pid_tgid helper in new ns\n");
> -
> -	if (stat("/proc/self/ns/pid", &st)) {
> -		perror("stat failed on /proc/self/ns/pid ns\n");
> -		printf("%s:FAILED\n", argv[0]);
> -		return exit_code;
> -	}
> -
> -	if (CHECK_NEWNS(unshare(CLONE_NEWPID | CLONE_NEWNS),
> -			"unshare CLONE_NEWPID | CLONE_NEWNS", "error errno=%d\n", errno))
> -		return exit_code;
> -
> -	pid = fork();
> -	if (pid == -1) {
> -		perror("Fork() failed\n");
> -		printf("%s:FAILED\n", argv[0]);
> -		return exit_code;
> -	}
> -
> -	if (pid > 0) {
> -		int status;
> -
> -		usleep(5);
> -		waitpid(pid, &status, 0);
> -		return 0;
> -	} else {
> -
> -		pid = fork();
> -		if (pid == -1) {
> -			perror("Fork() failed\n");
> -			printf("%s:FAILED\n", argv[0]);
> -			return exit_code;
> -		}
> -
> -		if (pid > 0) {
> -			int status;
> -			waitpid(pid, &status, 0);
> -			return 0;
> -		} else {
> -			if (CHECK_NEWNS(mount("none", "/proc", NULL, MS_PRIVATE|MS_REC, NULL),
> -				"Unmounting proc", "Cannot umount proc! errno=%d\n", errno))
> -				return exit_code;
> -
> -			if (CHECK_NEWNS(mount("proc", "/proc", "proc", MS_NOSUID|MS_NOEXEC|MS_NODEV, NULL),
> -				"Mounting proc", "Cannot mount proc! errno=%d\n", errno))
> -				return exit_code;
> -
> -			const char *probe_name = "raw_tracepoint/sys_enter";
> -			const char *file = "test_ns_current_pid_tgid.o";
> -			struct bpf_link *link = NULL;
> -			struct bpf_program *prog;
> -			struct bpf_map *bss_map;
> -			struct bpf_object *obj;
> -			int exit_code = 1;
> -			int err, key = 0;
> -			struct bss bss;
> -			struct stat st;
> -			__u64 id;
> -
> -			obj = bpf_object__open_file(file, NULL);
> -			if (CHECK_NEWNS(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
> -				return exit_code;
> -
> -			err = bpf_object__load(obj);
> -			if (CHECK_NEWNS(err, "obj_load", "err %d errno %d\n", err, errno))
> -				goto cleanup;
> -
> -			bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
> -			if (CHECK_NEWNS(!bss_map, "find_bss_map", "failed\n"))
> -				goto cleanup;
> -
> -			prog = bpf_object__find_program_by_title(obj, probe_name);
> -			if (CHECK_NEWNS(!prog, "find_prog", "prog '%s' not found\n",
> -						probe_name))
> -				goto cleanup;
> -
> -			memset(&bss, 0, sizeof(bss));
> -			pid_t tid = syscall(SYS_gettid);
> -			pid_t pid = getpid();
> -
> -			id = (__u64) tid << 32 | pid;
> -			bss.user_pid_tgid = id;
> -
> -			if (CHECK_NEWNS(stat("/proc/self/ns/pid", &st),
> -				"stat new ns", "Failed to stat /proc/self/ns/pid errno=%d\n", errno))
> -				goto cleanup;
> -
> -			bss.dev = st.st_dev;
> -			bss.ino = st.st_ino;
> -
> -			err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
> -			if (CHECK_NEWNS(err, "setting_bss", "failed to set bss : %d\n", err))
> -				goto cleanup;
> -
> -			link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
> -			if (CHECK_NEWNS(IS_ERR(link), "attach_raw_tp", "err %ld\n",
> -						PTR_ERR(link))) {
> -				link = NULL;
> -				goto cleanup;
> -			}
> -
> -			/* trigger some syscalls */
> -			usleep(1);
> -
> -			err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
> -			if (CHECK_NEWNS(err, "set_bss", "failed to get bss : %d\n", err))
> -				goto cleanup;
> -
> -			if (CHECK_NEWNS(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
> -						"User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
> -				goto cleanup;
> -
> -			exit_code = 0;
> -			printf("%s:PASS\n", argv[0]);
> -cleanup:
> -			if (!link) {
> -				bpf_link__destroy(link);
> -				link = NULL;
> -			}
> -			bpf_object__close(obj);
> -		}
> -	}
> -}
> 
