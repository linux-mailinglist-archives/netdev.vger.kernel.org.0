Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8E439495B
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhE1Xz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhE1Xzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:54 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E94C061574;
        Fri, 28 May 2021 16:54:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z26so409488pfj.5;
        Fri, 28 May 2021 16:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N3RXRHLbKO0cZgpX4qTKu5VVb4lJzIqHv/hIzI5RO6o=;
        b=F0WYBCRl3MNTqym0+/AJL1FthpOcCxRCrLCfrmMlvDmVgptPbyzONJIgQrGif+90nI
         QUTBw+zDiHYuvRNEwyxOYJt6uOTu9O1Zb60TcKz19RDJG19WGoHDcOLZJnpQcx6X07Yc
         9AD8Z1KM+R3LZKkmEKAn4k2h9gXYrCiAtQWdkpoQYTBWGFNhUDjVrx3Vkz/uqYh0Ngip
         4aJoTRfLviJSEGm7JpPseWfO0arvGsJyWgqtL9IYb9ZbjiTU05gPBkWNpLX6al4JEVrN
         g/yp6gH3iN6RkxVvHsbXNbkTm5VQvrWWQvSPN8MZ/kIj6SL9jaIypQ9/PNGrW5+pOa9s
         b0qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N3RXRHLbKO0cZgpX4qTKu5VVb4lJzIqHv/hIzI5RO6o=;
        b=JE8p+I+wFWQfmRij5a12rfJtUcdosz68HcBHT3NwsN6tvZvwC3pUD6jaopBIWOninb
         /zH/AjVBMbOv6PtXAwhzstNz/W0aygIua7nSqbUMNGG9v8numz7g9/2+yGfMMj4fts1c
         0Y8C6U//v5Fs2l4YCk8IQm9JrjShBvNkp4CpEDsAr9sq6x22bm34M/+j4Ziv+pYKqF/u
         r7GVe0fZdiyPgjuAG5Cb/UC9M4uzqb6UnB9nhimTUUsEqeQu2VopWGDOjC+3DwTx8lCr
         UkGLvbR42q2THE50NY1lvRkVg2S90ZVk3yYMg8Ngw/Ja3RWOO8Kq6rvlrW+0MPe614ye
         Uosw==
X-Gm-Message-State: AOAM530bRBCeV3XXV9E3DMF3aSL8rEuOcL0Ccqsf/HMqBA5rc8i1F/4a
        Y+XNOaGjOpP+epSA+EOuEn5579YtIdg=
X-Google-Smtp-Source: ABdhPJyy/0drfdLol6vZ63ZQAW4Llj4q7VBGh3cpiTm1mPzc69cflY3lE4yhLQR1aSmdiJC/X8DiVw==
X-Received: by 2002:a63:5252:: with SMTP id s18mr11491055pgl.229.1622246058374;
        Fri, 28 May 2021 16:54:18 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id 30sm5092267pgo.7.2021.05.28.16.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:54:18 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 12/15] samples: bpf: subtract time spent in collection from polling interval
Date:   Sat, 29 May 2021 05:22:47 +0530
Message-Id: <20210528235250.2635167-13-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This improves sleeping precision and reduces the possibility of
reporting incorrect statistics to the user.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_redirect_cpu_user.c |  7 ++++++-
 samples/bpf/xdp_sample_user.c       | 27 ++++++++++++++++++++++++++-
 samples/bpf/xdp_sample_user.h       |  2 ++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 4c9f32229508..103ac5c24163 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -214,6 +214,9 @@ static void __stats_poll(int interval, bool use_separators, char *prog_name,
 		setlocale(LC_NUMERIC, "en_US");
 
 	for (;;) {
+		struct timespec ots, nts;
+
+		clock_gettime(CLOCK_MONOTONIC, &ots);
 		swap(&prev, &record);
 		sample_stats_collect(mask, record);
 		sample_stats_print(mask, record, prev, NULL, interval);
@@ -224,7 +227,9 @@ static void __stats_poll(int interval, bool use_separators, char *prog_name,
 		if (sample_log_level & LL_DEFAULT)
 			printf("\n");
 		fflush(stdout);
-		sleep(interval);
+		clock_gettime(CLOCK_MONOTONIC, &nts);
+		sample_calc_timediff(&nts, &ots, interval);
+		nanosleep(&nts, NULL);
 		if (stress_mode)
 			stress_cpumap(value);
 		sample_reset_mode();
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index 909257ffe54c..96d36c708ee3 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -923,6 +923,26 @@ void sample_stats_print(int mask, struct stats_record *cur,
 	stats_print(prog_name, mask, cur, prev, &out);
 }
 
+static void calc_timediff(struct timespec *cur, const struct timespec *prev)
+{
+	if (cur->tv_nsec - prev->tv_nsec < 0) {
+		cur->tv_sec = cur->tv_sec - prev->tv_sec - 1;
+		cur->tv_nsec = cur->tv_nsec - prev->tv_nsec + NANOSEC_PER_SEC;
+	} else {
+		cur->tv_sec -= prev->tv_sec;
+		cur->tv_nsec -= prev->tv_nsec;
+	}
+}
+
+void sample_calc_timediff(struct timespec *cur, const struct timespec *prev, int interval)
+{
+	struct timespec ts = { .tv_sec = interval };
+
+	calc_timediff(cur, prev);
+	calc_timediff(&ts, cur);
+	*cur = ts;
+}
+
 void sample_stats_poll(int interval, int mask, char *prog_name, int use_separators)
 {
 	struct stats_record *record, *prev;
@@ -936,11 +956,16 @@ void sample_stats_poll(int interval, int mask, char *prog_name, int use_separato
 		setlocale(LC_NUMERIC, "en_US");
 
 	for (;;) {
+		struct timespec ots, nts;
+
+		clock_gettime(CLOCK_MONOTONIC, &ots);
 		swap(&prev, &record);
 		sample_stats_collect(mask, record);
 		sample_stats_print(mask, record, prev, prog_name, interval);
 		fflush(stdout);
-		sleep(interval);
+		clock_gettime(CLOCK_MONOTONIC, &nts);
+		sample_calc_timediff(&nts, &ots, interval);
+		nanosleep(&nts, NULL);
 		sample_reset_mode();
 	}
 
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index abe4ec25c310..588bd2f15352 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -161,6 +161,8 @@ void sample_stats_print(int mask, struct stats_record *cur,
 void sample_stats_collect(int mask, struct stats_record *rec);
 void sample_summary_update(struct sample_output *out, int interval);
 void sample_summary_print(void);
+void sample_calc_timediff(struct timespec *cur, const struct timespec *prev,
+			  int interval);
 void sample_stats_poll(int interval, int mask, char *prog_name,
 		       int use_separators);
 void sample_stats_print_cpumap_remote(struct stats_record *stats_rec,
-- 
2.31.1

