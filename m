Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5CB7D25A
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 02:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfHAApV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 20:45:21 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:39010 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfHAApT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 20:45:19 -0400
Received: by mail-pf1-f171.google.com with SMTP id f17so28813693pfn.6
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 17:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+hV06qcFlmxz5uZuuR9W/9dOLaDohvC2wmeVr2MaT4=;
        b=T0Gs1++AVhbcHdLf9nx7pO2kXHG7idcoNrWJJQmAqObS8OraDmNvVZ0ET+e30+cc4B
         1gidHo8ogPXwms+6MIpd8DvMQef2gNZnpogQm9qq/nAXaUAVXUgJ1kIBTuW2PN5XRzHD
         rDslmWPXVP02guIKUDGXex2QZB5fCSWQDhE7ptMeh+vou6DOkmt0Nxh3ggLHyu4elLvl
         +3eij1s+t/SUKq6UCyKTKmbDlFZvjXOF1fuI+Vd6pHSI3DGEfmw460a8OByRYiNzzU9K
         xzLbbeWNf5nQiWianmd5Ssvkk/pv+F7LJcYbWNMdGmR/nlzJ/r+HXNZMLBDdYBPRnIFd
         CBlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+hV06qcFlmxz5uZuuR9W/9dOLaDohvC2wmeVr2MaT4=;
        b=aOhPWyWH6Y6JoSXbXzuctnObHghkERWnH8e3nIHC8iU9BzXEPlfEYH8aG7lKF/Hk64
         rJtnkkEQL2Z6LUgPLcYHS8WLXm8EPL2J6KllDfXI2Ovxpntkemi9YUqiVWzwi+fn9yT0
         DSJFAdkmcL2suTR1GAYMhnD72aF8McL5o3E1G7QWhdD27E3aokICp2WpLZe9aL8nFiEh
         dq/LODXrnv2txCZqcQonSIu0if4/kb+HB6S/ngA1/BksyqS4l5M1BmEQawow7UlsLeHM
         tOCW3ZVNlMrSpNsWtK+UwI5BOINMPW64S85MmyLPU8HN3wQxFKaVgRYMW9+fGEeIn4Hx
         V67g==
X-Gm-Message-State: APjAAAUrNLInfM1gUyMdRoVBVT/q5KdYVNckkO0FbFSnQdEC7FoYaS2J
        Mxf2JG7CSkx+2diN9KZN32c=
X-Google-Smtp-Source: APXvYqz/aVSjz9NkZX54OyJ3blnbIqE52gyPP5DDRGH9eptpzJ8YirPQBe/asIdXYVIdQ1i3PjEMuQ==
X-Received: by 2002:a17:90a:9f0b:: with SMTP id n11mr5441625pjp.98.1564620317484;
        Wed, 31 Jul 2019 17:45:17 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f32sm2435978pgb.21.2019.07.31.17.45.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 17:45:16 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     jiri@resnulli.us, chrism@mellanox.com
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2 4/4] Revert "tc: Add batchsize feature for filter and actions"
Date:   Wed, 31 Jul 2019 17:45:06 -0700
Message-Id: <20190801004506.9049-5-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190801004506.9049-1-stephen@networkplumber.org>
References: <20190801004506.9049-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 485d0c6001c4aa134b99c86913d6a7089b7b2ab0.
---
 tc/m_action.c  |  65 ++++++----------
 tc/tc.c        | 199 ++++---------------------------------------------
 tc/tc_common.h |   7 +-
 tc/tc_filter.c | 129 ++++++++++++--------------------
 4 files changed, 87 insertions(+), 313 deletions(-)

diff --git a/tc/m_action.c b/tc/m_action.c
index ab6bc0ad28ff..bdc62720879c 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -556,61 +556,40 @@ bad_val:
 	return ret;
 }
 
-struct tc_action_req {
-	struct nlmsghdr		n;
-	struct tcamsg		t;
-	char			buf[MAX_MSG];
-};
-
 static int tc_action_modify(int cmd, unsigned int flags,
-			    int *argc_p, char ***argv_p,
-			    void *buf, size_t buflen)
+			    int *argc_p, char ***argv_p)
 {
-	struct tc_action_req *req, action_req;
-	char **argv = *argv_p;
-	struct rtattr *tail;
 	int argc = *argc_p;
-	struct iovec iov;
+	char **argv = *argv_p;
 	int ret = 0;
-
-	if (buf) {
-		req = buf;
-		if (buflen < sizeof (struct tc_action_req)) {
-			fprintf(stderr, "buffer is too small: %zu\n", buflen);
-			return -1;
-		}
-	} else {
-		memset(&action_req, 0, sizeof (struct tc_action_req));
-		req = &action_req;
-	}
-
-	req->n.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcamsg));
-	req->n.nlmsg_flags = NLM_F_REQUEST | flags;
-	req->n.nlmsg_type = cmd;
-	req->t.tca_family = AF_UNSPEC;
-	tail = NLMSG_TAIL(&req->n);
+	struct {
+		struct nlmsghdr         n;
+		struct tcamsg           t;
+		char                    buf[MAX_MSG];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcamsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST | flags,
+		.n.nlmsg_type = cmd,
+		.t.tca_family = AF_UNSPEC,
+	};
+	struct rtattr *tail = NLMSG_TAIL(&req.n);
 
 	argc -= 1;
 	argv += 1;
-	if (parse_action(&argc, &argv, TCA_ACT_TAB, &req->n)) {
+	if (parse_action(&argc, &argv, TCA_ACT_TAB, &req.n)) {
 		fprintf(stderr, "Illegal \"action\"\n");
 		return -1;
 	}
-	tail->rta_len = (void *) NLMSG_TAIL(&req->n) - (void *) tail;
+	tail->rta_len = (void *) NLMSG_TAIL(&req.n) - (void *) tail;
 
-	*argc_p = argc;
-	*argv_p = argv;
-
-	if (buf)
-		return 0;
-
-	iov.iov_base = &req->n;
-	iov.iov_len = req->n.nlmsg_len;
-	if (rtnl_talk_iov(&rth, &iov, 1, NULL) < 0) {
+	if (rtnl_talk(&rth, &req.n, NULL) < 0) {
 		fprintf(stderr, "We have an error talking to the kernel\n");
 		ret = -1;
 	}
 
+	*argc_p = argc;
+	*argv_p = argv;
+
 	return ret;
 }
 
@@ -711,7 +690,7 @@ bad_val:
 	return ret;
 }
 
-int do_action(int argc, char **argv, void *buf, size_t buflen)
+int do_action(int argc, char **argv)
 {
 
 	int ret = 0;
@@ -721,12 +700,12 @@ int do_action(int argc, char **argv, void *buf, size_t buflen)
 		if (matches(*argv, "add") == 0) {
 			ret =  tc_action_modify(RTM_NEWACTION,
 						NLM_F_EXCL | NLM_F_CREATE,
-						&argc, &argv, buf, buflen);
+						&argc, &argv);
 		} else if (matches(*argv, "change") == 0 ||
 			  matches(*argv, "replace") == 0) {
 			ret = tc_action_modify(RTM_NEWACTION,
 					       NLM_F_CREATE | NLM_F_REPLACE,
-					       &argc, &argv, buf, buflen);
+					       &argc, &argv);
 		} else if (matches(*argv, "delete") == 0) {
 			argc -= 1;
 			argv += 1;
diff --git a/tc/tc.c b/tc/tc.c
index b7b6bd288897..a0a18f380b46 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -205,18 +205,18 @@ static void usage(void)
 		"		     -nm | -nam[es] | { -cf | -conf } path }\n");
 }
 
-static int do_cmd(int argc, char **argv, void *buf, size_t buflen)
+static int do_cmd(int argc, char **argv)
 {
 	if (matches(*argv, "qdisc") == 0)
 		return do_qdisc(argc-1, argv+1);
 	if (matches(*argv, "class") == 0)
 		return do_class(argc-1, argv+1);
 	if (matches(*argv, "filter") == 0)
-		return do_filter(argc-1, argv+1, buf, buflen);
+		return do_filter(argc-1, argv+1);
 	if (matches(*argv, "chain") == 0)
-		return do_chain(argc-1, argv+1, buf, buflen);
+		return do_chain(argc-1, argv+1);
 	if (matches(*argv, "actions") == 0)
-		return do_action(argc-1, argv+1, buf, buflen);
+		return do_action(argc-1, argv+1);
 	if (matches(*argv, "monitor") == 0)
 		return do_tcmonitor(argc-1, argv+1);
 	if (matches(*argv, "exec") == 0)
@@ -231,110 +231,11 @@ static int do_cmd(int argc, char **argv, void *buf, size_t buflen)
 	return -1;
 }
 
-#define TC_MAX_SUBC	10
-static bool batchsize_enabled(int argc, char *argv[])
-{
-	struct {
-		char *c;
-		char *subc[TC_MAX_SUBC];
-	} table[] = {
-		{ "filter", { "add", "delete", "change", "replace", NULL} },
-		{ "actions", { "add", "change", "replace", NULL} },
-		{ NULL },
-	}, *iter;
-	char *s;
-	int i;
-
-	if (argc < 2)
-		return false;
-
-	for (iter = table; iter->c; iter++) {
-		if (matches(argv[0], iter->c))
-			continue;
-		for (i = 0; i < TC_MAX_SUBC; i++) {
-			s = iter->subc[i];
-			if (s && matches(argv[1], s) == 0)
-				return true;
-		}
-	}
-
-	return false;
-}
-
-struct batch_buf {
-	struct batch_buf	*next;
-	char			buf[16420];	/* sizeof (struct nlmsghdr) +
-						   max(sizeof (struct tcmsg) +
-						   sizeof (struct tcamsg)) +
-						   MAX_MSG */
-};
-
-static struct batch_buf *get_batch_buf(struct batch_buf **pool,
-				       struct batch_buf **head,
-				       struct batch_buf **tail)
-{
-	struct batch_buf *buf;
-
-	if (*pool == NULL)
-		buf = calloc(1, sizeof(struct batch_buf));
-	else {
-		buf = *pool;
-		*pool = (*pool)->next;
-		memset(buf, 0, sizeof(struct batch_buf));
-	}
-
-	if (*head == NULL)
-		*head = *tail = buf;
-	else {
-		(*tail)->next = buf;
-		(*tail) = buf;
-	}
-
-	return buf;
-}
-
-static void put_batch_bufs(struct batch_buf **pool,
-			   struct batch_buf **head,
-			   struct batch_buf **tail)
-{
-	if (*head == NULL || *tail == NULL)
-		return;
-
-	if (*pool == NULL)
-		*pool = *head;
-	else {
-		(*tail)->next = *pool;
-		*pool = *head;
-	}
-	*head = NULL;
-	*tail = NULL;
-}
-
-static void free_batch_bufs(struct batch_buf **pool)
-{
-	struct batch_buf *buf;
-
-	for (buf = *pool; buf != NULL; buf = *pool) {
-		*pool = buf->next;
-		free(buf);
-	}
-	*pool = NULL;
-}
-
 static int batch(const char *name)
 {
-	struct batch_buf *head = NULL, *tail = NULL, *buf_pool = NULL;
-	char *largv[100], *largv_next[100];
-	char *line, *line_next = NULL;
-	bool bs_enabled_next = false;
-	bool bs_enabled = false;
-	bool lastline = false;
-	int largc, largc_next;
-	bool bs_enabled_saved;
-	int batchsize = 0;
+	char *line = NULL;
 	size_t len = 0;
 	int ret = 0;
-	bool send;
 
 	batch_mode = 1;
 	if (name && strcmp(name, "-") != 0) {
@@ -354,95 +255,25 @@ static int batch(const char *name)
 	}
 
 	cmdlineno = 0;
-	if (getcmdline(&line, &len, stdin) == -1)
-		goto Exit;
-	largc = makeargs(line, largv, 100);
-	bs_enabled = batchsize_enabled(largc, largv);
-	bs_enabled_saved = bs_enabled;
-	do {
-		if (getcmdline(&line_next, &len, stdin) == -1)
-			lastline = true;
-
-		largc_next = makeargs(line_next, largv_next, 100);
-		bs_enabled_next = batchsize_enabled(largc_next, largv_next);
-		if (bs_enabled) {
-			struct batch_buf *buf;
-
-			buf = get_batch_buf(&buf_pool, &head, &tail);
-			if (!buf) {
-				fprintf(stderr,
-					"failed to allocate batch_buf\n");
-				return -1;
-			}
-			++batchsize;
-		}
+	while (getcmdline(&line, &len, stdin) != -1) {
+		char *largv[100];
+		int largc;
 
-		/*
-		 * In batch mode, if we haven't accumulated enough commands
-		 * and this is not the last command and this command & next
-		 * command both support the batchsize feature, don't send the
-		 * message immediately.
-		 */
-		if (!lastline && bs_enabled && bs_enabled_next
-		    && batchsize != MSG_IOV_MAX)
-			send = false;
-		else
-			send = true;
-
-		line = line_next;
-		line_next = NULL;
-		len = 0;
-		bs_enabled_saved = bs_enabled;
-		bs_enabled = bs_enabled_next;
-		bs_enabled_next = false;
-
-		if (largc == 0) {
-			largc = largc_next;
-			memcpy(largv, largv_next, largc * sizeof(char *));
+		largc = makeargs(line, largv, 100);
+		if (largc == 0)
 			continue;	/* blank line */
-		}
 
-		ret = do_cmd(largc, largv, tail == NULL ? NULL : tail->buf,
-			     tail == NULL ? 0 : sizeof(tail->buf));
-		if (ret != 0) {
-			fprintf(stderr, "Command failed %s:%d\n", name,
-				cmdlineno - 1);
+		if (do_cmd(largc, largv)) {
+			fprintf(stderr, "Command failed %s:%d\n",
+				name, cmdlineno);
 			ret = 1;
 			if (!force)
 				break;
 		}
-		largc = largc_next;
-		memcpy(largv, largv_next, largc * sizeof(char *));
-
-		if (send && bs_enabled_saved) {
-			struct iovec *iov, *iovs;
-			struct batch_buf *buf;
-			struct nlmsghdr *n;
-
-			iov = iovs = malloc(batchsize * sizeof(struct iovec));
-			for (buf = head; buf != NULL; buf = buf->next, ++iov) {
-				n = (struct nlmsghdr *)&buf->buf;
-				iov->iov_base = n;
-				iov->iov_len = n->nlmsg_len;
-			}
-
-			ret = rtnl_talk_iov(&rth, iovs, batchsize, NULL);
-			if (ret < 0) {
-				fprintf(stderr, "Command failed %s:%d\n", name,
-					cmdlineno - (batchsize + ret) - 1);
-				return 2;
-			}
-			put_batch_bufs(&buf_pool, &head, &tail);
-			batchsize = 0;
-			free(iovs);
-		}
-	} while (!lastline);
+	}
 
-	free_batch_bufs(&buf_pool);
-Exit:
 	free(line);
 	rtnl_close(&rth);
-
 	return ret;
 }
 
@@ -536,7 +367,7 @@ int main(int argc, char **argv)
 		goto Exit;
 	}
 
-	ret = do_cmd(argc-1, argv+1, NULL, 0);
+	ret = do_cmd(argc-1, argv+1);
 Exit:
 	rtnl_close(&rth);
 
diff --git a/tc/tc_common.h b/tc/tc_common.h
index d8a6dfdeabd4..802fb7f01fe4 100644
--- a/tc/tc_common.h
+++ b/tc/tc_common.h
@@ -1,15 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 #define TCA_BUF_MAX	(64*1024)
-#define MSG_IOV_MAX	128
 
 extern struct rtnl_handle rth;
 
 int do_qdisc(int argc, char **argv);
 int do_class(int argc, char **argv);
-int do_filter(int argc, char **argv, void *buf, size_t buflen);
-int do_chain(int argc, char **argv, void *buf, size_t buflen);
-int do_action(int argc, char **argv, void *buf, size_t buflen);
+int do_filter(int argc, char **argv);
+int do_chain(int argc, char **argv);
+int do_action(int argc, char **argv);
 int do_tcmonitor(int argc, char **argv);
 int do_exec(int argc, char **argv);
 
diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index cd78c2441efa..53759a7a8876 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -58,42 +58,30 @@ struct tc_filter_req {
 	char			buf[MAX_MSG];
 };
 
-static int tc_filter_modify(int cmd, unsigned int flags, int argc, char **argv,
-			    void *buf, size_t buflen)
+static int tc_filter_modify(int cmd, unsigned int flags, int argc, char **argv)
 {
-	struct tc_filter_req *req, filter_req;
+	struct {
+		struct nlmsghdr	n;
+		struct tcmsg		t;
+		char			buf[MAX_MSG];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST | flags,
+		.n.nlmsg_type = cmd,
+		.t.tcm_family = AF_UNSPEC,
+	};
 	struct filter_util *q = NULL;
-	struct tc_estimator est = {};
-	char k[FILTER_NAMESZ] = {};
-	int chain_index_set = 0;
-	char d[IFNAMSIZ] = {};
-	int protocol_set = 0;
-	__u32 block_index = 0;
-	char *fhandle = NULL;
+	__u32 prio = 0;
 	__u32 protocol = 0;
+	int protocol_set = 0;
 	__u32 chain_index;
-	struct iovec iov;
-	__u32 prio = 0;
-	int ret;
-
-	if (buf) {
-		req = buf;
-		if (buflen < sizeof (struct tc_filter_req)) {
-			fprintf(stderr, "buffer is too small: %zu\n", buflen);
-			return -1;
-		}
-	} else {
-		memset(&filter_req, 0, sizeof (struct tc_filter_req));
-		req = &filter_req;
-	}
-
-	req->n.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
-	req->n.nlmsg_flags = NLM_F_REQUEST | flags;
-	req->n.nlmsg_type = cmd;
-	req->t.tcm_family = AF_UNSPEC;
+	int chain_index_set = 0;
+	char *fhandle = NULL;
+	char  d[IFNAMSIZ] = {};
+	char  k[FILTER_NAMESZ] = {};
+	struct tc_estimator est = {};
 
-	if ((cmd == RTM_NEWTFILTER || cmd == RTM_NEWCHAIN) &&
-	    flags & NLM_F_CREATE)
+	if (cmd == RTM_NEWTFILTER && flags & NLM_F_CREATE)
 		protocol = htons(ETH_P_ALL);
 
 	while (argc > 0) {
@@ -101,53 +89,39 @@ static int tc_filter_modify(int cmd, unsigned int flags, int argc, char **argv,
 			NEXT_ARG();
 			if (d[0])
 				duparg("dev", *argv);
-			if (block_index) {
-				fprintf(stderr, "Error: \"dev\" and \"block\" are mutually exlusive\n");
-				return -1;
-			}
 			strncpy(d, *argv, sizeof(d)-1);
-		} else if (matches(*argv, "block") == 0) {
-			NEXT_ARG();
-			if (block_index)
-				duparg("block", *argv);
-			if (d[0]) {
-				fprintf(stderr, "Error: \"dev\" and \"block\" are mutually exlusive\n");
-				return -1;
-			}
-			if (get_u32(&block_index, *argv, 0) || !block_index)
-				invarg("invalid block index value", *argv);
 		} else if (strcmp(*argv, "root") == 0) {
-			if (req->t.tcm_parent) {
+			if (req.t.tcm_parent) {
 				fprintf(stderr,
 					"Error: \"root\" is duplicate parent ID\n");
 				return -1;
 			}
-			req->t.tcm_parent = TC_H_ROOT;
+			req.t.tcm_parent = TC_H_ROOT;
 		} else if (strcmp(*argv, "ingress") == 0) {
-			if (req->t.tcm_parent) {
+			if (req.t.tcm_parent) {
 				fprintf(stderr,
 					"Error: \"ingress\" is duplicate parent ID\n");
 				return -1;
 			}
-			req->t.tcm_parent = TC_H_MAKE(TC_H_CLSACT,
+			req.t.tcm_parent = TC_H_MAKE(TC_H_CLSACT,
 						     TC_H_MIN_INGRESS);
 		} else if (strcmp(*argv, "egress") == 0) {
-			if (req->t.tcm_parent) {
+			if (req.t.tcm_parent) {
 				fprintf(stderr,
 					"Error: \"egress\" is duplicate parent ID\n");
 				return -1;
 			}
-			req->t.tcm_parent = TC_H_MAKE(TC_H_CLSACT,
+			req.t.tcm_parent = TC_H_MAKE(TC_H_CLSACT,
 						     TC_H_MIN_EGRESS);
 		} else if (strcmp(*argv, "parent") == 0) {
 			__u32 handle;
 
 			NEXT_ARG();
-			if (req->t.tcm_parent)
+			if (req.t.tcm_parent)
 				duparg("parent", *argv);
 			if (get_tc_classid(&handle, *argv))
 				invarg("Invalid parent ID", *argv);
-			req->t.tcm_parent = handle;
+			req.t.tcm_parent = handle;
 		} else if (strcmp(*argv, "handle") == 0) {
 			NEXT_ARG();
 			if (fhandle)
@@ -194,27 +168,26 @@ static int tc_filter_modify(int cmd, unsigned int flags, int argc, char **argv,
 		argc--; argv++;
 	}
 
-	req->t.tcm_info = TC_H_MAKE(prio<<16, protocol);
+	req.t.tcm_info = TC_H_MAKE(prio<<16, protocol);
 
 	if (chain_index_set)
-		addattr32(&req->n, sizeof(*req), TCA_CHAIN, chain_index);
+		addattr32(&req.n, sizeof(req), TCA_CHAIN, chain_index);
 
 	if (k[0])
-		addattr_l(&req->n, sizeof(*req), TCA_KIND, k, strlen(k)+1);
+		addattr_l(&req.n, sizeof(req), TCA_KIND, k, strlen(k)+1);
 
 	if (d[0])  {
 		ll_init_map(&rth);
 
-		req->t.tcm_ifindex = ll_name_to_index(d);
-		if (!req->t.tcm_ifindex)
-			return -nodev(d);
-	} else if (block_index) {
-		req->t.tcm_ifindex = TCM_IFINDEX_MAGIC_BLOCK;
-		req->t.tcm_block_index = block_index;
+		req.t.tcm_ifindex = ll_name_to_index(d);
+		if (req.t.tcm_ifindex == 0) {
+			fprintf(stderr, "Cannot find device \"%s\"\n", d);
+			return 1;
+		}
 	}
 
 	if (q) {
-		if (q->parse_fopt(q, fhandle, argc, argv, &req->n))
+		if (q->parse_fopt(q, fhandle, argc, argv, &req.n))
 			return 1;
 	} else {
 		if (fhandle) {
@@ -233,16 +206,10 @@ static int tc_filter_modify(int cmd, unsigned int flags, int argc, char **argv,
 	}
 
 	if (est.ewma_log)
-		addattr_l(&req->n, sizeof(*req), TCA_RATE, &est, sizeof(est));
+		addattr_l(&req.n, sizeof(req), TCA_RATE, &est, sizeof(est));
 
-	if (buf)
-		return 0;
-
-	iov.iov_base = &req->n;
-	iov.iov_len = req->n.nlmsg_len;
-	ret = rtnl_talk_iov(&rth, &iov, 1, NULL);
-	if (ret < 0) {
-		fprintf(stderr, "We have an error talking to the kernel, %d\n", ret);
+	if (rtnl_talk(&rth, &req.n, NULL) < 0) {
+		fprintf(stderr, "We have an error talking to the kernel\n");
 		return 2;
 	}
 
@@ -751,22 +718,20 @@ static int tc_filter_list(int cmd, int argc, char **argv)
 	return 0;
 }
 
-int do_filter(int argc, char **argv, void *buf, size_t buflen)
+int do_filter(int argc, char **argv)
 {
 	if (argc < 1)
 		return tc_filter_list(RTM_GETTFILTER, 0, NULL);
 	if (matches(*argv, "add") == 0)
 		return tc_filter_modify(RTM_NEWTFILTER, NLM_F_EXCL|NLM_F_CREATE,
-					argc-1, argv+1, buf, buflen);
+					argc-1, argv+1);
 	if (matches(*argv, "change") == 0)
-		return tc_filter_modify(RTM_NEWTFILTER, 0, argc-1, argv+1,
-					buf, buflen);
+		return tc_filter_modify(RTM_NEWTFILTER, 0, argc-1, argv+1);
 	if (matches(*argv, "replace") == 0)
 		return tc_filter_modify(RTM_NEWTFILTER, NLM_F_CREATE, argc-1,
-					argv+1, buf, buflen);
+					argv+1);
 	if (matches(*argv, "delete") == 0)
-		return tc_filter_modify(RTM_DELTFILTER, 0, argc-1, argv+1,
-					buf, buflen);
+		return tc_filter_modify(RTM_DELTFILTER, 0,  argc-1, argv+1);
 	if (matches(*argv, "get") == 0)
 		return tc_filter_get(RTM_GETTFILTER, 0,  argc-1, argv+1);
 	if (matches(*argv, "list") == 0 || matches(*argv, "show") == 0
@@ -781,16 +746,16 @@ int do_filter(int argc, char **argv, void *buf, size_t buflen)
 	return -1;
 }
 
-int do_chain(int argc, char **argv, void *buf, size_t buflen)
+int do_chain(int argc, char **argv)
 {
 	if (argc < 1)
 		return tc_filter_list(RTM_GETCHAIN, 0, NULL);
 	if (matches(*argv, "add") == 0) {
 		return tc_filter_modify(RTM_NEWCHAIN, NLM_F_EXCL | NLM_F_CREATE,
-					argc - 1, argv + 1, buf, buflen);
+					argc - 1, argv + 1);
 	} else if (matches(*argv, "delete") == 0) {
 		return tc_filter_modify(RTM_DELCHAIN, 0,
-					argc - 1, argv + 1, buf, buflen);
+					argc - 1, argv + 1);
 	} else if (matches(*argv, "get") == 0) {
 		return tc_filter_get(RTM_GETCHAIN, 0,
 				     argc - 1, argv + 1);
-- 
2.20.1

