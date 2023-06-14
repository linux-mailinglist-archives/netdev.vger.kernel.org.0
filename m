Return-Path: <netdev+bounces-10949-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32CB9730BB8
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 638271C20DB5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D4718B1B;
	Wed, 14 Jun 2023 23:42:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D89918AF2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:42:04 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A751FD4;
	Wed, 14 Jun 2023 16:41:58 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EK7DQA011669;
	Wed, 14 Jun 2023 23:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=HCt11GXzkFpm95aaV/VoQfvRg8lBjaY3lbhSpF5ragU=;
 b=X0pJawOvn/TEQvkWTD81V5+zXYF6Ym+l5ZaN4jTvbCi2iIbAmub7/XE4yJ6oeeCxzEW2
 BfMjKLpsjxmCn56Oyb286p9BcGs41jva05e9vDZhaNULYKuVrMYeokBXf4kI580g+2Sn
 9oYdAE67zLI0R9KPRVLQZ/7UMKfi2eNySL7apTJtcga8gmEoUCoTiMj/B0GHuJCr4j7u
 ps33Vh+5CzC6kCkFmxDdNn6Kbn0GnByLTsgzb73ZXIBONdrEDtwD9fNKd7szD0ol+ct4
 eQ8aPCyTatAflAIeuEKJdqPjYfTA748D4bAYuI5ULxbiYNT4QmR516hUR6XWp37l42r6 +Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4gsu0pek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jun 2023 23:41:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35ENHBTi017707;
	Wed, 14 Jun 2023 23:41:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm5y0bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jun 2023 23:41:36 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35ENfUeZ023835;
	Wed, 14 Jun 2023 23:41:36 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r4fm5y09x-7;
	Wed, 14 Jun 2023 23:41:35 +0000
From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To: davem@davemloft.net
Cc: david@fries.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org, anjali.k.kulkarni@oracle.com
Subject: [PATCH v6 6/6] connector/cn_proc: Selftest for proc connector
Date: Wed, 14 Jun 2023 16:41:28 -0700
Message-ID: <20230614234129.3264175-7-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230614234129.3264175-1-anjali.k.kulkarni@oracle.com>
References: <20230614234129.3264175-1-anjali.k.kulkarni@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140207
X-Proofpoint-GUID: BUA8XGJD8zijwPmpjfr3oj9aBSjRaFFQ
X-Proofpoint-ORIG-GUID: BUA8XGJD8zijwPmpjfr3oj9aBSjRaFFQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Run as ./proc_filter -f to run new filter code. Run without "-f" to run
usual proc connector code without the new filtering code.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/connector/Makefile    |   6 +
 .../testing/selftests/connector/proc_filter.c | 308 ++++++++++++++++++
 3 files changed, 315 insertions(+)
 create mode 100644 tools/testing/selftests/connector/Makefile
 create mode 100644 tools/testing/selftests/connector/proc_filter.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 90a62cf75008..7c9673951f9a 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -7,6 +7,7 @@ TARGETS += breakpoints
 TARGETS += capabilities
 TARGETS += cgroup
 TARGETS += clone3
+TARGETS += connector
 TARGETS += core
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
diff --git a/tools/testing/selftests/connector/Makefile b/tools/testing/selftests/connector/Makefile
new file mode 100644
index 000000000000..21c9f3a973a0
--- /dev/null
+++ b/tools/testing/selftests/connector/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+CFLAGS += -Wall
+
+TEST_GEN_PROGS = proc_filter
+
+include ../lib.mk
diff --git a/tools/testing/selftests/connector/proc_filter.c b/tools/testing/selftests/connector/proc_filter.c
new file mode 100644
index 000000000000..99a382ea2544
--- /dev/null
+++ b/tools/testing/selftests/connector/proc_filter.c
@@ -0,0 +1,308 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <sys/types.h>
+#include <sys/epoll.h>
+#include <sys/socket.h>
+#include <linux/netlink.h>
+#include <linux/connector.h>
+#include <linux/cn_proc.h>
+
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <strings.h>
+#include <errno.h>
+#include <signal.h>
+#include <string.h>
+
+#include "../kselftest.h"
+
+#define NL_MESSAGE_SIZE (sizeof(struct nlmsghdr) + sizeof(struct cn_msg) + \
+			 sizeof(struct proc_input))
+#define NL_MESSAGE_SIZE_NF (sizeof(struct nlmsghdr) + sizeof(struct cn_msg) + \
+			 sizeof(int))
+
+#define MAX_EVENTS 1
+
+volatile static int interrupted;
+static int nl_sock, ret_errno, tcount;
+static struct epoll_event evn;
+
+static int filter;
+
+#ifdef ENABLE_PRINTS
+#define Printf printf
+#else
+#define Printf ksft_print_msg
+#endif
+
+int send_message(void *pinp)
+{
+	char buff[NL_MESSAGE_SIZE];
+	struct nlmsghdr *hdr;
+	struct cn_msg *msg;
+
+	hdr = (struct nlmsghdr *)buff;
+	if (filter)
+		hdr->nlmsg_len = NL_MESSAGE_SIZE;
+	else
+		hdr->nlmsg_len = NL_MESSAGE_SIZE_NF;
+	hdr->nlmsg_type = NLMSG_DONE;
+	hdr->nlmsg_flags = 0;
+	hdr->nlmsg_seq = 0;
+	hdr->nlmsg_pid = getpid();
+
+	msg = (struct cn_msg *)NLMSG_DATA(hdr);
+	msg->id.idx = CN_IDX_PROC;
+	msg->id.val = CN_VAL_PROC;
+	msg->seq = 0;
+	msg->ack = 0;
+	msg->flags = 0;
+
+	if (filter) {
+		msg->len = sizeof(struct proc_input);
+		((struct proc_input *)msg->data)->mcast_op = ((struct proc_input *)pinp)->mcast_op;
+		((struct proc_input *)msg->data)->event_type = ((struct proc_input *)pinp)->event_type;
+	} else {
+		msg->len = sizeof(int);
+		*(int *)msg->data = *(enum proc_cn_mcast_op *)pinp;
+	}
+
+	if (send(nl_sock, hdr, hdr->nlmsg_len, 0) == -1) {
+		ret_errno = errno;
+		perror("send failed");
+		return -3;
+	}
+	return 0;
+}
+
+int register_proc_netlink(int *efd, void *input)
+{
+	struct sockaddr_nl sa_nl;
+	int err = 0, epoll_fd;
+
+	nl_sock = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
+
+	if (nl_sock == -1) {
+		ret_errno = errno;
+		perror("socket failed");
+		return -1;
+	}
+
+	bzero(&sa_nl, sizeof(sa_nl));
+	sa_nl.nl_family = AF_NETLINK;
+	sa_nl.nl_groups = CN_IDX_PROC;
+	sa_nl.nl_pid    = getpid();
+
+	if (bind(nl_sock, (struct sockaddr *)&sa_nl, sizeof(sa_nl)) == -1) {
+		ret_errno = errno;
+		perror("bind failed");
+		return -2;
+	}
+
+	epoll_fd = epoll_create1(EPOLL_CLOEXEC);
+	if (epoll_fd < 0) {
+		ret_errno = errno;
+		perror("epoll_create1 failed");
+		return -2;
+	}
+
+	err = send_message(input);
+
+	if (err < 0)
+		return err;
+
+	evn.events = EPOLLIN;
+	evn.data.fd = nl_sock;
+	if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, nl_sock, &evn) < 0) {
+		ret_errno = errno;
+		perror("epoll_ctl failed");
+		return -3;
+	}
+	*efd = epoll_fd;
+	return 0;
+}
+
+static void sigint(int sig)
+{
+	interrupted = 1;
+}
+
+int handle_packet(char *buff, int fd, struct proc_event *event)
+{
+	struct nlmsghdr *hdr;
+
+	hdr = (struct nlmsghdr *)buff;
+
+	if (hdr->nlmsg_type == NLMSG_ERROR) {
+		perror("NLMSG_ERROR error\n");
+		return -3;
+	} else if (hdr->nlmsg_type == NLMSG_DONE) {
+		event = (struct proc_event *)
+			((struct cn_msg *)NLMSG_DATA(hdr))->data;
+		tcount++;
+		switch (event->what) {
+		case PROC_EVENT_EXIT:
+			Printf("Exit process %d (tgid %d) with code %d, signal %d\n",
+			       event->event_data.exit.process_pid,
+			       event->event_data.exit.process_tgid,
+			       event->event_data.exit.exit_code,
+			       event->event_data.exit.exit_signal);
+			break;
+		case PROC_EVENT_FORK:
+			Printf("Fork process %d (tgid %d), parent %d (tgid %d)\n",
+			       event->event_data.fork.child_pid,
+			       event->event_data.fork.child_tgid,
+			       event->event_data.fork.parent_pid,
+			       event->event_data.fork.parent_tgid);
+			break;
+		case PROC_EVENT_EXEC:
+			Printf("Exec process %d (tgid %d)\n",
+			       event->event_data.exec.process_pid,
+			       event->event_data.exec.process_tgid);
+			break;
+		case PROC_EVENT_UID:
+			Printf("UID process %d (tgid %d) uid %d euid %d\n",
+			       event->event_data.id.process_pid,
+			       event->event_data.id.process_tgid,
+			       event->event_data.id.r.ruid,
+			       event->event_data.id.e.euid);
+			break;
+		case PROC_EVENT_GID:
+			Printf("GID process %d (tgid %d) gid %d egid %d\n",
+			       event->event_data.id.process_pid,
+			       event->event_data.id.process_tgid,
+			       event->event_data.id.r.rgid,
+			       event->event_data.id.e.egid);
+			break;
+		case PROC_EVENT_SID:
+			Printf("SID process %d (tgid %d)\n",
+			       event->event_data.sid.process_pid,
+			       event->event_data.sid.process_tgid);
+			break;
+		case PROC_EVENT_PTRACE:
+			Printf("Ptrace process %d (tgid %d), Tracer %d (tgid %d)\n",
+			       event->event_data.ptrace.process_pid,
+			       event->event_data.ptrace.process_tgid,
+			       event->event_data.ptrace.tracer_pid,
+			       event->event_data.ptrace.tracer_tgid);
+			break;
+		case PROC_EVENT_COMM:
+			Printf("Comm process %d (tgid %d) comm %s\n",
+			       event->event_data.comm.process_pid,
+			       event->event_data.comm.process_tgid,
+			       event->event_data.comm.comm);
+			break;
+		case PROC_EVENT_COREDUMP:
+			Printf("Coredump process %d (tgid %d) parent %d, (tgid %d)\n",
+			       event->event_data.coredump.process_pid,
+			       event->event_data.coredump.process_tgid,
+			       event->event_data.coredump.parent_pid,
+			       event->event_data.coredump.parent_tgid);
+			break;
+		default:
+			break;
+		}
+	}
+	return 0;
+}
+
+int handle_events(int epoll_fd, struct proc_event *pev)
+{
+	char buff[CONNECTOR_MAX_MSG_SIZE];
+	struct epoll_event ev[MAX_EVENTS];
+	int i, event_count = 0, err = 0;
+
+	event_count = epoll_wait(epoll_fd, ev, MAX_EVENTS, -1);
+	if (event_count < 0) {
+		ret_errno = errno;
+		if (ret_errno != EINTR)
+			perror("epoll_wait failed");
+		return -3;
+	}
+	for (i = 0; i < event_count; i++) {
+		if (!(ev[i].events & EPOLLIN))
+			continue;
+		if (recv(ev[i].data.fd, buff, sizeof(buff), 0) == -1) {
+			ret_errno = errno;
+			perror("recv failed");
+			return -3;
+		}
+		err = handle_packet(buff, ev[i].data.fd, pev);
+		if (err < 0)
+			return err;
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int epoll_fd, err;
+	struct proc_event proc_ev;
+	struct proc_input input;
+
+	signal(SIGINT, sigint);
+
+	if (argc > 2) {
+		printf("Expected 0(assume no-filter) or 1 argument(-f)\n");
+		exit(1);
+	}
+
+	if (argc == 2) {
+		if (strcmp(argv[1], "-f") == 0) {
+			filter = 1;
+		} else {
+			printf("Valid option : -f (for filter feature)\n");
+			exit(1);
+		}
+	}
+
+	if (filter) {
+		input.event_type = PROC_EVENT_NONZERO_EXIT;
+		input.mcast_op = PROC_CN_MCAST_LISTEN;
+		err = register_proc_netlink(&epoll_fd, (void*)&input);
+	} else {
+		enum proc_cn_mcast_op op = PROC_CN_MCAST_LISTEN;
+		err = register_proc_netlink(&epoll_fd, (void*)&op);
+	}
+
+	if (err < 0) {
+		if (err == -2)
+			close(nl_sock);
+		if (err == -3) {
+			close(nl_sock);
+			close(epoll_fd);
+		}
+		exit(1);
+	}
+
+	while (!interrupted) {
+		err = handle_events(epoll_fd, &proc_ev);
+		if (err < 0) {
+			if (ret_errno == EINTR)
+				continue;
+			if (err == -2)
+				close(nl_sock);
+			if (err == -3) {
+				close(nl_sock);
+				close(epoll_fd);
+			}
+			exit(1);
+		}
+	}
+
+	if (filter) {
+		input.mcast_op = PROC_CN_MCAST_IGNORE;
+		send_message((void*)&input);
+	} else {
+		enum proc_cn_mcast_op op = PROC_CN_MCAST_IGNORE;
+		send_message((void*)&op);
+	}
+
+	close(epoll_fd);
+	close(nl_sock);
+
+	printf("Done total count: %d\n", tcount);
+	exit(0);
+}
-- 
2.41.0


