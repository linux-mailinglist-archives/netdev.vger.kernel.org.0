Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1ECE471A77
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 14:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhLLNrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 08:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhLLNrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 08:47:35 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5715C0613FE
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 05:47:34 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r25so43687369edq.7
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 05:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CiSpeKrc6xdYQkaSsrV1saCX+tLWJIyEe2AX2g4FsfY=;
        b=ulXWmXYH8stsLnZOejOmSZSyeTh0HECoohO+a4rGro7VxdhFGeTSbSpdkZiikNDQAa
         BJp/CtQQveMhJwiLLfiWtnjVT91BnXMuDq3W6dD/uiGOcYRj3DgsJICtCbRtDQqZ8v2A
         pooR5iHRk7nxRaylbwRV9wpCgx3rOtnmF6r31KHyp8l4oQKf6IrktXzathKEF08WX1o2
         9AX5b3TvOe9JlvTFhMQIObJg5d1fDCUxYh1Fhy0R3CqC5a0O+dfG3f9pLb8c+VH3CwTb
         tWvG70NjiHsK6M2Ea1d00xkeo+5XbhIIEZId81CW6346jHUlJ6LHjaXS9pJ+74FwI3vD
         Fwcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CiSpeKrc6xdYQkaSsrV1saCX+tLWJIyEe2AX2g4FsfY=;
        b=iBHh1wVAylRkMZlb1OljYtbEPYkBtOesuQnmjIGVp6q6X5u252xPgRbL7QRpdn5lSF
         TxFYsdLxhKjCq2r7dxv6jXpd0lQr8AMdDyPGB8Jm2zZ3OYLzIYSULXR2pB6ZuB7C+cKq
         51u5zwZ7+bw7QwHPi6WdZYbvZcd6gHuqwL4WiNpnOCSZBQDEvR8Qm1dc9I17vwMFIbdN
         QTlXHxMBvd8yUaXR/c7CrVgOQR6SxEM0dJf3Wr6hCRt1B9/BzqIaA8d4LtBCTrQ+ouk1
         VGrcgkIamD50Ibw9/gWI3wKUzr90tclyd3XJP2cWQDm3S9eBPR/WFgrR9rYXyy1z4uOx
         kHPg==
X-Gm-Message-State: AOAM531ggO1pHuTH4Dko4QgoQvNAsOavJ9hqkKPCgMEc5dwPVS0WCesS
        3NFXPO25H/CP6Ej+di6bAN4eEg==
X-Google-Smtp-Source: ABdhPJxbZDcMAGyCRfoQKuWsGxx685XQpDHyN9I0NfvgAcYf1nJUdb72Q3Ihv9iHIsidz8HWrql1mg==
X-Received: by 2002:a05:6402:3514:: with SMTP id b20mr55160604edd.169.1639316853318;
        Sun, 12 Dec 2021 05:47:33 -0800 (PST)
Received: from localhost ([104.245.96.202])
        by smtp.gmail.com with ESMTPSA id r13sm4669936edo.71.2021.12.12.05.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 05:47:33 -0800 (PST)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jin Yao <yao.jin@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v1 1/2] perf namespaces: Add helper nsinfo__is_in_root_namespace()
Date:   Sun, 12 Dec 2021 21:47:20 +0800
Message-Id: <20211212134721.1721245-2-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211212134721.1721245-1-leo.yan@linaro.org>
References: <20211212134721.1721245-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactors code for gathering PID infos, it creates the function
nsinfo__get_nspid() to parse process 'status' node in folder '/proc'.

Base on the refactoring, this patch introduces a new helper
nsinfo__is_in_root_namespace(), it returns true when the caller runs in
the root PID namespace.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 tools/perf/util/namespaces.c | 76 ++++++++++++++++++++++--------------
 tools/perf/util/namespaces.h |  2 +
 2 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/tools/perf/util/namespaces.c b/tools/perf/util/namespaces.c
index 608b20c72a5c..48aa3217300b 100644
--- a/tools/perf/util/namespaces.c
+++ b/tools/perf/util/namespaces.c
@@ -60,17 +60,49 @@ void namespaces__free(struct namespaces *namespaces)
 	free(namespaces);
 }
 
+static int nsinfo__get_nspid(struct nsinfo *nsi, const char *path)
+{
+	FILE *f = NULL;
+	char *statln = NULL;
+	size_t linesz = 0;
+	char *nspid;
+
+	f = fopen(path, "r");
+	if (f == NULL)
+		return -1;
+
+	while (getline(&statln, &linesz, f) != -1) {
+		/* Use tgid if CONFIG_PID_NS is not defined. */
+		if (strstr(statln, "Tgid:") != NULL) {
+			nsi->tgid = (pid_t)strtol(strrchr(statln, '\t'),
+						     NULL, 10);
+			nsi->nstgid = nsi->tgid;
+		}
+
+		if (strstr(statln, "NStgid:") != NULL) {
+			nspid = strrchr(statln, '\t');
+			nsi->nstgid = (pid_t)strtol(nspid, NULL, 10);
+			/*
+			 * If innermost tgid is not the first, process is in a different
+			 * PID namespace.
+			 */
+			nsi->in_pidns = (statln + sizeof("NStgid:") - 1) != nspid;
+			break;
+		}
+	}
+
+	fclose(f);
+	free(statln);
+	return 0;
+}
+
 int nsinfo__init(struct nsinfo *nsi)
 {
 	char oldns[PATH_MAX];
 	char spath[PATH_MAX];
 	char *newns = NULL;
-	char *statln = NULL;
-	char *nspid;
 	struct stat old_stat;
 	struct stat new_stat;
-	FILE *f = NULL;
-	size_t linesz = 0;
 	int rv = -1;
 
 	if (snprintf(oldns, PATH_MAX, "/proc/self/ns/mnt") >= PATH_MAX)
@@ -100,34 +132,9 @@ int nsinfo__init(struct nsinfo *nsi)
 	if (snprintf(spath, PATH_MAX, "/proc/%d/status", nsi->pid) >= PATH_MAX)
 		goto out;
 
-	f = fopen(spath, "r");
-	if (f == NULL)
-		goto out;
-
-	while (getline(&statln, &linesz, f) != -1) {
-		/* Use tgid if CONFIG_PID_NS is not defined. */
-		if (strstr(statln, "Tgid:") != NULL) {
-			nsi->tgid = (pid_t)strtol(strrchr(statln, '\t'),
-						     NULL, 10);
-			nsi->nstgid = nsi->tgid;
-		}
-
-		if (strstr(statln, "NStgid:") != NULL) {
-			nspid = strrchr(statln, '\t');
-			nsi->nstgid = (pid_t)strtol(nspid, NULL, 10);
-			/* If innermost tgid is not the first, process is in a different
-			 * PID namespace.
-			 */
-			nsi->in_pidns = (statln + sizeof("NStgid:") - 1) != nspid;
-			break;
-		}
-	}
-	rv = 0;
+	rv = nsinfo__get_nspid(nsi, spath);
 
 out:
-	if (f != NULL)
-		(void) fclose(f);
-	free(statln);
 	free(newns);
 	return rv;
 }
@@ -299,3 +306,12 @@ int nsinfo__stat(const char *filename, struct stat *st, struct nsinfo *nsi)
 
 	return ret;
 }
+
+bool nsinfo__is_in_root_namespace(void)
+{
+	struct nsinfo nsi;
+
+	memset(&nsi, 0x0, sizeof(nsi));
+	nsinfo__get_nspid(&nsi, "/proc/self/status");
+	return !nsi.in_pidns;
+}
diff --git a/tools/perf/util/namespaces.h b/tools/perf/util/namespaces.h
index ad9775db7b9c..9ceea9643507 100644
--- a/tools/perf/util/namespaces.h
+++ b/tools/perf/util/namespaces.h
@@ -59,6 +59,8 @@ void nsinfo__mountns_exit(struct nscookie *nc);
 char *nsinfo__realpath(const char *path, struct nsinfo *nsi);
 int nsinfo__stat(const char *filename, struct stat *st, struct nsinfo *nsi);
 
+bool nsinfo__is_in_root_namespace(void);
+
 static inline void __nsinfo__zput(struct nsinfo **nsip)
 {
 	if (nsip) {
-- 
2.25.1

