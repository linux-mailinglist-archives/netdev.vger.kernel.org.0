Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9182CAF8B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391820AbgLAWBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:01:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55574 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389374AbgLAV74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:59:56 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LntC4020479
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=59lEVuAseQxj/C1BmrBqY12rfG9DUXYgZTUCSdMOcuA=;
 b=iQAPBSLe6o8OW/Ops+iFUTqjeTW01qC6rq9CeeWPw7KXA8/gpztH6RYPd8bQ4TRb6mgk
 /PEzQfEHd8/FmqiO+DKQ2bSTrti0A5pUunV6ts1mrhekv3gBCwp2jnMfMgGqerMFtbTw
 Vqubrr5rKPWkRjAobRcvwX+jdffqV7XUc90= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355t7y1xaa-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:13 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:09 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id E2B1319702E2; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 34/34] bpf: samples: do not touch RLIMIT_MEMLOCK
Date:   Tue, 1 Dec 2020 13:59:00 -0800
Message-ID: <20201201215900.3569844-35-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 suspectscore=13 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since bpf is not using rlimit memlock for the memory accounting
and control, do not change the limit in sample applications.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 samples/bpf/map_perf_test_user.c    | 6 ------
 samples/bpf/offwaketime_user.c      | 6 ------
 samples/bpf/sockex2_user.c          | 2 --
 samples/bpf/sockex3_user.c          | 2 --
 samples/bpf/spintest_user.c         | 6 ------
 samples/bpf/syscall_tp_user.c       | 2 --
 samples/bpf/task_fd_query_user.c    | 6 ------
 samples/bpf/test_lru_dist.c         | 3 ---
 samples/bpf/test_map_in_map_user.c  | 6 ------
 samples/bpf/test_overhead_user.c    | 2 --
 samples/bpf/trace_event_user.c      | 2 --
 samples/bpf/tracex2_user.c          | 6 ------
 samples/bpf/tracex3_user.c          | 6 ------
 samples/bpf/tracex4_user.c          | 6 ------
 samples/bpf/tracex5_user.c          | 3 ---
 samples/bpf/tracex6_user.c          | 3 ---
 samples/bpf/xdp1_user.c             | 6 ------
 samples/bpf/xdp_adjust_tail_user.c  | 6 ------
 samples/bpf/xdp_monitor_user.c      | 5 -----
 samples/bpf/xdp_redirect_cpu_user.c | 6 ------
 samples/bpf/xdp_redirect_map_user.c | 6 ------
 samples/bpf/xdp_redirect_user.c     | 6 ------
 samples/bpf/xdp_router_ipv4_user.c  | 6 ------
 samples/bpf/xdp_rxq_info_user.c     | 6 ------
 samples/bpf/xdp_sample_pkts_user.c  | 6 ------
 samples/bpf/xdp_tx_iptunnel_user.c  | 6 ------
 samples/bpf/xdpsock_user.c          | 7 -------
 27 files changed, 133 deletions(-)

diff --git a/samples/bpf/map_perf_test_user.c b/samples/bpf/map_perf_test=
_user.c
index 8b13230b4c46..9db949290a78 100644
--- a/samples/bpf/map_perf_test_user.c
+++ b/samples/bpf/map_perf_test_user.c
@@ -421,7 +421,6 @@ static void fixup_map(struct bpf_object *obj)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	int nr_cpus =3D sysconf(_SC_NPROCESSORS_ONLN);
 	struct bpf_link *links[8];
 	struct bpf_program *prog;
@@ -430,11 +429,6 @@ int main(int argc, char **argv)
 	char filename[256];
 	int i =3D 0;
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	if (argc > 1)
 		test_flags =3D atoi(argv[1]) ? : test_flags;
=20
diff --git a/samples/bpf/offwaketime_user.c b/samples/bpf/offwaketime_use=
r.c
index 5734cfdaaacb..73a986876c1a 100644
--- a/samples/bpf/offwaketime_user.c
+++ b/samples/bpf/offwaketime_user.c
@@ -95,18 +95,12 @@ static void int_exit(int sig)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_object *obj =3D NULL;
 	struct bpf_link *links[2];
 	struct bpf_program *prog;
 	int delay =3D 1, i =3D 0;
 	char filename[256];
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	if (load_kallsyms()) {
 		printf("failed to process /proc/kallsyms\n");
 		return 2;
diff --git a/samples/bpf/sockex2_user.c b/samples/bpf/sockex2_user.c
index af925a5afd1d..bafa567b840c 100644
--- a/samples/bpf/sockex2_user.c
+++ b/samples/bpf/sockex2_user.c
@@ -16,7 +16,6 @@ struct pair {
=20
 int main(int ac, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_object *obj;
 	int map_fd, prog_fd;
 	char filename[256];
@@ -24,7 +23,6 @@ int main(int ac, char **argv)
 	FILE *f;
=20
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	setrlimit(RLIMIT_MEMLOCK, &r);
=20
 	if (bpf_prog_load(filename, BPF_PROG_TYPE_SOCKET_FILTER,
 			  &obj, &prog_fd))
diff --git a/samples/bpf/sockex3_user.c b/samples/bpf/sockex3_user.c
index 7793f6a6ae7e..6ae99ecc766c 100644
--- a/samples/bpf/sockex3_user.c
+++ b/samples/bpf/sockex3_user.c
@@ -26,7 +26,6 @@ struct pair {
 int main(int argc, char **argv)
 {
 	int i, sock, key, fd, main_prog_fd, jmp_table_fd, hash_map_fd;
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	const char *section;
@@ -34,7 +33,6 @@ int main(int argc, char **argv)
 	FILE *f;
=20
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	setrlimit(RLIMIT_MEMLOCK, &r);
=20
 	obj =3D bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
diff --git a/samples/bpf/spintest_user.c b/samples/bpf/spintest_user.c
index f090d0dc60d6..0d7e1e5a8658 100644
--- a/samples/bpf/spintest_user.c
+++ b/samples/bpf/spintest_user.c
@@ -10,7 +10,6 @@
=20
 int main(int ac, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	char filename[256], symbol[256];
 	struct bpf_object *obj =3D NULL;
 	struct bpf_link *links[20];
@@ -20,11 +19,6 @@ int main(int ac, char **argv)
 	const char *section;
 	struct ksym *sym;
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	if (load_kallsyms()) {
 		printf("failed to process /proc/kallsyms\n");
 		return 2;
diff --git a/samples/bpf/syscall_tp_user.c b/samples/bpf/syscall_tp_user.=
c
index 76a1d00128fb..a0ebf1833ed3 100644
--- a/samples/bpf/syscall_tp_user.c
+++ b/samples/bpf/syscall_tp_user.c
@@ -115,7 +115,6 @@ static int test(char *filename, int num_progs)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	int opt, num_progs =3D 1;
 	char filename[256];
=20
@@ -131,7 +130,6 @@ int main(int argc, char **argv)
 		}
 	}
=20
-	setrlimit(RLIMIT_MEMLOCK, &r);
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
=20
 	return test(filename, num_progs);
diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query=
_user.c
index f6b772faa348..a78025b0026b 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -310,7 +310,6 @@ static int test_debug_fs_uprobe(char *binary_path, lo=
ng offset, bool is_return)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	extern char __executable_start;
 	char filename[256], buf[256];
 	__u64 uprobe_file_offset;
@@ -318,11 +317,6 @@ int main(int argc, char **argv)
 	struct bpf_object *obj;
 	int i =3D 0, err =3D -1;
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return err;
-	}
-
 	if (load_kallsyms()) {
 		printf("failed to process /proc/kallsyms\n");
 		return err;
diff --git a/samples/bpf/test_lru_dist.c b/samples/bpf/test_lru_dist.c
index b313dba4111b..c92c5c06b965 100644
--- a/samples/bpf/test_lru_dist.c
+++ b/samples/bpf/test_lru_dist.c
@@ -489,7 +489,6 @@ static void test_parallel_lru_loss(int map_type, int =
map_flags, int nr_tasks)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	int map_flags[] =3D {0, BPF_F_NO_COMMON_LRU};
 	const char *dist_file;
 	int nr_tasks =3D 1;
@@ -508,8 +507,6 @@ int main(int argc, char **argv)
=20
 	setbuf(stdout, NULL);
=20
-	assert(!setrlimit(RLIMIT_MEMLOCK, &r));
-
 	srand(time(NULL));
=20
 	nr_cpus =3D bpf_num_possible_cpus();
diff --git a/samples/bpf/test_map_in_map_user.c b/samples/bpf/test_map_in=
_map_user.c
index 98656de56b83..472d65c70354 100644
--- a/samples/bpf/test_map_in_map_user.c
+++ b/samples/bpf/test_map_in_map_user.c
@@ -114,17 +114,11 @@ static void test_map_in_map(void)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_link *link =3D NULL;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char filename[256];
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj =3D bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
diff --git a/samples/bpf/test_overhead_user.c b/samples/bpf/test_overhead=
_user.c
index 819a6fe86f89..4821f9d99c1f 100644
--- a/samples/bpf/test_overhead_user.c
+++ b/samples/bpf/test_overhead_user.c
@@ -162,13 +162,11 @@ static void unload_progs(void)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	int num_cpu =3D sysconf(_SC_NPROCESSORS_ONLN);
 	int test_flags =3D ~0;
 	char filename[256];
 	int err =3D 0;
=20
-	setrlimit(RLIMIT_MEMLOCK, &r);
=20
 	if (argc > 1)
 		test_flags =3D atoi(argv[1]) ? : test_flags;
diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_use=
r.c
index ac1ba368195c..9664749bf618 100644
--- a/samples/bpf/trace_event_user.c
+++ b/samples/bpf/trace_event_user.c
@@ -294,13 +294,11 @@ static void test_bpf_perf_event(void)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_object *obj =3D NULL;
 	char filename[256];
 	int error =3D 1;
=20
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	setrlimit(RLIMIT_MEMLOCK, &r);
=20
 	signal(SIGINT, err_exit);
 	signal(SIGTERM, err_exit);
diff --git a/samples/bpf/tracex2_user.c b/samples/bpf/tracex2_user.c
index 3d6eab711d23..1626d51dfffd 100644
--- a/samples/bpf/tracex2_user.c
+++ b/samples/bpf/tracex2_user.c
@@ -116,7 +116,6 @@ static void int_exit(int sig)
=20
 int main(int ac, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	long key, next_key, value;
 	struct bpf_link *links[2];
 	struct bpf_program *prog;
@@ -125,11 +124,6 @@ int main(int ac, char **argv)
 	int i, j =3D 0;
 	FILE *f;
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj =3D bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
diff --git a/samples/bpf/tracex3_user.c b/samples/bpf/tracex3_user.c
index 83e0fecbb01a..33e16ba39f25 100644
--- a/samples/bpf/tracex3_user.c
+++ b/samples/bpf/tracex3_user.c
@@ -107,7 +107,6 @@ static void print_hist(int fd)
=20
 int main(int ac, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_link *links[2];
 	struct bpf_program *prog;
 	struct bpf_object *obj;
@@ -127,11 +126,6 @@ int main(int ac, char **argv)
 		}
 	}
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj =3D bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
diff --git a/samples/bpf/tracex4_user.c b/samples/bpf/tracex4_user.c
index e8faf8f184ae..cea399424bca 100644
--- a/samples/bpf/tracex4_user.c
+++ b/samples/bpf/tracex4_user.c
@@ -48,18 +48,12 @@ static void print_old_objects(int fd)
=20
 int main(int ac, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_link *links[2];
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char filename[256];
 	int map_fd, i, j =3D 0;
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK, RLIM_INFINITY)");
-		return 1;
-	}
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj =3D bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
diff --git a/samples/bpf/tracex5_user.c b/samples/bpf/tracex5_user.c
index c17d3fb5fd64..08dfdc77ad2a 100644
--- a/samples/bpf/tracex5_user.c
+++ b/samples/bpf/tracex5_user.c
@@ -34,7 +34,6 @@ static void install_accept_all_seccomp(void)
=20
 int main(int ac, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_link *link =3D NULL;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
@@ -43,8 +42,6 @@ int main(int ac, char **argv)
 	char filename[256];
 	FILE *f;
=20
-	setrlimit(RLIMIT_MEMLOCK, &r);
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj =3D bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
diff --git a/samples/bpf/tracex6_user.c b/samples/bpf/tracex6_user.c
index 33df9784775d..28296f40c133 100644
--- a/samples/bpf/tracex6_user.c
+++ b/samples/bpf/tracex6_user.c
@@ -175,15 +175,12 @@ static void test_bpf_perf_event(void)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_link *links[2];
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char filename[256];
 	int i =3D 0;
=20
-	setrlimit(RLIMIT_MEMLOCK, &r);
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj =3D bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index c447ad9e3a1d..116e39f6b666 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -79,7 +79,6 @@ static void usage(const char *prog)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_prog_load_attr prog_load_attr =3D {
 		.prog_type	=3D BPF_PROG_TYPE_XDP,
 	};
@@ -117,11 +116,6 @@ int main(int argc, char **argv)
 		return 1;
 	}
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	ifindex =3D if_nametoindex(argv[optind]);
 	if (!ifindex) {
 		perror("if_nametoindex");
diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_=
tail_user.c
index ba482dc3da33..a70b094c8ec5 100644
--- a/samples/bpf/xdp_adjust_tail_user.c
+++ b/samples/bpf/xdp_adjust_tail_user.c
@@ -82,7 +82,6 @@ static void usage(const char *cmd)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_prog_load_attr prog_load_attr =3D {
 		.prog_type	=3D BPF_PROG_TYPE_XDP,
 	};
@@ -143,11 +142,6 @@ int main(int argc, char **argv)
 		}
 	}
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK, RLIM_INFINITY)");
-		return 1;
-	}
-
 	if (!ifindex) {
 		fprintf(stderr, "Invalid ifname\n");
 		return 1;
diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_use=
r.c
index 03d0a182913f..49ebc49aefc3 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -687,7 +687,6 @@ static void print_bpf_prog_info(void)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_program *prog;
 	int longindex =3D 0, opt;
 	int ret =3D EXIT_FAILURE;
@@ -719,10 +718,6 @@ int main(int argc, char **argv)
 	}
=20
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return ret;
-	}
=20
 	/* Remove tracepoint program when program is interrupted or killed */
 	signal(SIGINT, int_exit);
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redire=
ct_cpu_user.c
index f78cb18319aa..576411612523 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -765,7 +765,6 @@ static int load_cpumap_prog(char *file_name, char *pr=
og_name,
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	char *prog_name =3D "xdp_cpu_map5_lb_hash_ip_pairs";
 	char *mprog_filename =3D "xdp_redirect_kern.o";
 	char *redir_interface =3D NULL, *redir_map =3D NULL;
@@ -804,11 +803,6 @@ int main(int argc, char **argv)
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file =3D filename;
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return err;
=20
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redire=
ct_map_user.c
index 35e16dee613e..31131b6e7782 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -96,7 +96,6 @@ static void usage(const char *prog)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_prog_load_attr prog_load_attr =3D {
 		.prog_type	=3D BPF_PROG_TYPE_XDP,
 	};
@@ -135,11 +134,6 @@ int main(int argc, char **argv)
 		return 1;
 	}
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	ifindex_in =3D if_nametoindex(argv[optind]);
 	if (!ifindex_in)
 		ifindex_in =3D strtoul(argv[optind], NULL, 0);
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_u=
ser.c
index 9ca2bf457cda..41d705c3a1f7 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -97,7 +97,6 @@ static void usage(const char *prog)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_prog_load_attr prog_load_attr =3D {
 		.prog_type	=3D BPF_PROG_TYPE_XDP,
 	};
@@ -136,11 +135,6 @@ int main(int argc, char **argv)
 		return 1;
 	}
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	ifindex_in =3D if_nametoindex(argv[optind]);
 	if (!ifindex_in)
 		ifindex_in =3D strtoul(argv[optind], NULL, 0);
diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_=
ipv4_user.c
index c2da1b51ff95..b5f03cb17a3c 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -625,7 +625,6 @@ static void usage(const char *prog)
=20
 int main(int ac, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_prog_load_attr prog_load_attr =3D {
 		.prog_type	=3D BPF_PROG_TYPE_XDP,
 	};
@@ -670,11 +669,6 @@ int main(int ac, char **argv)
 		return 1;
 	}
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
=20
diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_u=
ser.c
index 93fa1bc54f13..74a2926eba08 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -450,7 +450,6 @@ static void stats_poll(int interval, int action, __u3=
2 cfg_opt)
 int main(int argc, char **argv)
 {
 	__u32 cfg_options=3D NO_TOUCH ; /* Default: Don't touch packet memory *=
/
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_prog_load_attr prog_load_attr =3D {
 		.prog_type	=3D BPF_PROG_TYPE_XDP,
 	};
@@ -474,11 +473,6 @@ int main(int argc, char **argv)
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file =3D filename;
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return EXIT_FAIL;
=20
diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_=
pkts_user.c
index 4b2a300c750c..706475e004cb 100644
--- a/samples/bpf/xdp_sample_pkts_user.c
+++ b/samples/bpf/xdp_sample_pkts_user.c
@@ -109,7 +109,6 @@ static void usage(const char *prog)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_prog_load_attr prog_load_attr =3D {
 		.prog_type	=3D BPF_PROG_TYPE_XDP,
 	};
@@ -143,11 +142,6 @@ int main(int argc, char **argv)
 		return 1;
 	}
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file =3D filename;
=20
diff --git a/samples/bpf/xdp_tx_iptunnel_user.c b/samples/bpf/xdp_tx_iptu=
nnel_user.c
index a419bee151a8..1d4f305d02aa 100644
--- a/samples/bpf/xdp_tx_iptunnel_user.c
+++ b/samples/bpf/xdp_tx_iptunnel_user.c
@@ -155,7 +155,6 @@ int main(int argc, char **argv)
 	struct bpf_prog_load_attr prog_load_attr =3D {
 		.prog_type	=3D BPF_PROG_TYPE_XDP,
 	};
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	int min_port =3D 0, max_port =3D 0, vip2tnl_map_fd;
 	const char *optstr =3D "i:a:p:s:d:m:T:P:FSNh";
 	unsigned char opt_flags[256] =3D {};
@@ -254,11 +253,6 @@ int main(int argc, char **argv)
 		}
 	}
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK, RLIM_INFINITY)");
-		return 1;
-	}
-
 	if (!ifindex) {
 		fprintf(stderr, "Invalid ifname\n");
 		return 1;
diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 036bd019e400..909f77647deb 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1489,7 +1489,6 @@ static void apply_setsockopt(struct xsk_socket_info=
 *xsk)
=20
 int main(int argc, char **argv)
 {
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	bool rx =3D false, tx =3D false;
 	struct xsk_umem_info *umem;
 	struct bpf_object *obj;
@@ -1499,12 +1498,6 @@ int main(int argc, char **argv)
=20
 	parse_command_line(argc, argv);
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
-			strerror(errno));
-		exit(EXIT_FAILURE);
-	}
-
 	if (opt_num_xsks > 1)
 		load_xdp_program(argv, &obj);
=20
--=20
2.26.2

