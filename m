Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32606B5416
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjCJWQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjCJWQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:16:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4B513F54B;
        Fri, 10 Mar 2023 14:16:14 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32ALhxT1026800;
        Fri, 10 Mar 2023 22:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=qNitOfdyftQUtr/OK4KHEeLFBABIkHQ2N6q3MIkFuhs=;
 b=F7gUrThlexIh/9AAwj4bMKQZ3L+1mQkaQVUqKoqTOtNTd0K8O764s0Obu8+cCCOuWE4i
 iX78MMFH9+qBYYtIeKdGVhf8ytDZYzHqogXFqSEMEEpAxZ5QnJ8gsKO+EC66NTslGObg
 hvjfLxZsOl0Q97PTzVtBUcRlgNnMik6eVNrIymfQvS4yhctkAju96dvSOWQI6AgXCNY/
 mH7HrvakLfD1VpO1jS8aBabX8rC4rI3Ra48LV8SiRDG3oMa8qbU8Z+C66XdGrm5PtwVb
 Jej3FoKjZZR3cnPtYaKEQDTsvym0kVAWL2bL9NzIJ3Z7P8H61/uAeXUt1M99ZXtbF0pr jw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417cp9hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:15:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32AM3Xxu031713;
        Fri, 10 Mar 2023 22:15:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6feqs9t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:15:57 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32AMFrP1028711;
        Fri, 10 Mar 2023 22:15:56 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p6feqs9nh-4;
        Fri, 10 Mar 2023 22:15:56 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v1 3/5] connector/cn_proc: Test code for proc connector
Date:   Fri, 10 Mar 2023 14:15:45 -0800
Message-Id: <20230310221547.3656194-4-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_10,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100177
X-Proofpoint-GUID: 0T6jrbKdKirA9gnVy04BivXvtHhUm9BP
X-Proofpoint-ORIG-GUID: 0T6jrbKdKirA9gnVy04BivXvtHhUm9BP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test code for proc connector.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 samples/connector/proc_filter.c | 262 ++++++++++++++++++++++++++++++++
 1 file changed, 262 insertions(+)
 create mode 100644 samples/connector/proc_filter.c

diff --git a/samples/connector/proc_filter.c b/samples/connector/proc_filter.c
new file mode 100644
index 000000000000..25202f5bc126
--- /dev/null
+++ b/samples/connector/proc_filter.c
@@ -0,0 +1,262 @@
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
+
+#define NL_MESSAGE_SIZE (sizeof(struct nlmsghdr) + sizeof(struct cn_msg) + \
+			 sizeof(int))
+
+#define MAX_EVENTS 1
+
+#ifdef ENABLE_PRINTS
+#define Printf printf
+#else
+#define Printf
+#endif
+
+volatile static int interrupted;
+static int nl_sock, ret_errno, tcount;
+static struct epoll_event evn;
+
+int send_message(enum proc_cn_mcast_op mcast_op)
+{
+	char buff[NL_MESSAGE_SIZE];
+	struct nlmsghdr *hdr;
+	struct cn_msg *msg;
+
+	hdr = (struct nlmsghdr *)buff;
+	hdr->nlmsg_len = NL_MESSAGE_SIZE;
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
+	msg->len = sizeof(int);
+	*(int *)msg->data = mcast_op;
+
+	if (send(nl_sock, hdr, hdr->nlmsg_len, 0) == -1) {
+		ret_errno = errno;
+		perror("send failed");
+		return -3;
+	}
+	return 0;
+}
+
+int register_proc_netlink(int *efd, enum proc_cn_mcast_op mcast_op)
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
+	err = send_message(mcast_op);
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
+static void sigint(__attribute__((__always_unused)) int sig)
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
+
+	signal(SIGINT, sigint);
+
+	err = register_proc_netlink(&epoll_fd, PROC_CN_MCAST_LISTEN);
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
+	send_message(PROC_CN_MCAST_IGNORE);
+
+	close(epoll_fd);
+	close(nl_sock);
+
+	printf("Done total count: %d\n", tcount);
+	exit(0);
+}
-- 
2.31.1

