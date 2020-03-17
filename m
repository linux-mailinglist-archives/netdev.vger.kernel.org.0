Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF8F188DF9
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgCQT1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:27:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38000 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQT07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:26:59 -0400
Received: by mail-pf1-f194.google.com with SMTP id z5so12500077pfn.5
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 12:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Wv4yd6kR1QRFXmj2NzM07bN147FOh0EzFD89nDLwIg=;
        b=JbCimMAGYjEZ0zc+C4XcbauR6gn4y+fhcwZ36n+F9lR3NE7grLLeK4jW17f1cDHuvA
         uNYw6v/6rQIJkWO7z5BFAL3DjDBjXEPjbzmFku0JIhtUHJfiUkUpL0aRmNSe/TCcPkPi
         83I9syJIxdiHqnWg8pTJFbddKuuth0xQSrLMF2Q6PtSd5lfEZ2Hdz06UH8GBYKZEB/m+
         lV1QkWIUQal7U5bSiDgYNSUUPRcy5WelwP9nNQgNLz7Vgz/UVmc2SoryBjkcS/azCPz2
         SzJN1w/WwY9rleOcAuwAx6jn0Jb+dmqxPcX9hCBKQNEgGe46aFo16dphsdW6BfopgIV9
         lfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Wv4yd6kR1QRFXmj2NzM07bN147FOh0EzFD89nDLwIg=;
        b=XVGceNQIZEvsX9+GEwd/O67NNL7zzLenC5ulTQi/rt/6UHJnMumJljst3skKrwOnai
         9r18Sg63TfPpuIVp07BxhuN53XdanRxos/uz4GqlDmkTZ4MxWXLIKthrtNA1BwM8bKdv
         MDk3mSuzDSfHdCvBzfabg3R+dRLYXRhFHhv7VVd7kUqf5fydbD2alkhYVLWHHcqKD4TO
         qKxiYzly98iAV8KNU1ezNCKVbVmG7TxmjA6zFc35LGPbfaufvHpCtVu0wQhB9ew0MVA9
         FR7+RaIEQFrBDHstREt3RwNKuqfCt0rGZ3hGDf5ARM3pvkaP2XNDJTVtiDYD0FoKrDVK
         MFRw==
X-Gm-Message-State: ANhLgQ0knGnxT1i+ON59xzsoCcTcg1rD0VzbhK7wz/SmP+Gqzf9nQimM
        NEunBt6mlCJXx7S3ytsBsX0=
X-Google-Smtp-Source: ADFU+vu5MqXVG3sKiPSGLMIM6ccxiO2hIUIrFnK657jFPN+C662Qtk5zsBKUVpS+wQOQT5M44vOQBw==
X-Received: by 2002:a62:f20d:: with SMTP id m13mr320045pfh.314.1584473217801;
        Tue, 17 Mar 2020 12:26:57 -0700 (PDT)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:83ec:eccf:6871:57])
        by smtp.gmail.com with ESMTPSA id gn11sm173209pjb.42.2020.03.17.12.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 12:26:57 -0700 (PDT)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: [PATCH net-next 5/5] selftests: txtimestamp: print statistics for timestamp events.
Date:   Tue, 17 Mar 2020 12:25:09 -0700
Message-Id: <20200317192509.150725-6-jianyang.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200317192509.150725-1-jianyang.kernel@gmail.com>
References: <20200317192509.150725-1-jianyang.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang@google.com>

Statistics on timestamps is useful to quantify average and tail latency.

Print timestamp statistics in count/avg/min/max format.

Signed-off-by: Jian Yang <jianyang@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 .../networking/timestamping/txtimestamp.c     | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/networking/timestamping/txtimestamp.c b/tools/testing/selftests/networking/timestamping/txtimestamp.c
index f915f24db3fa..011b0da6b033 100644
--- a/tools/testing/selftests/networking/timestamping/txtimestamp.c
+++ b/tools/testing/selftests/networking/timestamping/txtimestamp.c
@@ -84,6 +84,17 @@ static struct timespec ts_usr;
 static int saved_tskey = -1;
 static int saved_tskey_type = -1;
 
+struct timing_event {
+	int64_t min;
+	int64_t max;
+	int64_t total;
+	int count;
+};
+
+static struct timing_event usr_enq;
+static struct timing_event usr_snd;
+static struct timing_event usr_ack;
+
 static bool test_failed;
 
 static int64_t timespec_to_ns64(struct timespec *ts)
@@ -96,6 +107,27 @@ static int64_t timespec_to_us64(struct timespec *ts)
 	return ts->tv_sec * USEC_PER_SEC + ts->tv_nsec / NSEC_PER_USEC;
 }
 
+static void init_timing_event(struct timing_event *te)
+{
+	te->min = INT64_MAX;
+	te->max = 0;
+	te->total = 0;
+	te->count = 0;
+}
+
+static void add_timing_event(struct timing_event *te,
+		struct timespec *t_start, struct timespec *t_end)
+{
+	int64_t ts_delta = timespec_to_ns64(t_end) - timespec_to_ns64(t_start);
+
+	te->count++;
+	if (ts_delta < te->min)
+		te->min = ts_delta;
+	if (ts_delta > te->max)
+		te->max = ts_delta;
+	te->total += ts_delta;
+}
+
 static void validate_key(int tskey, int tstype)
 {
 	int stepsize;
@@ -187,14 +219,17 @@ static void print_timestamp(struct scm_timestamping *tss, int tstype,
 	case SCM_TSTAMP_SCHED:
 		tsname = "  ENQ";
 		validate_timestamp(&tss->ts[0], 0);
+		add_timing_event(&usr_enq, &ts_usr, &tss->ts[0]);
 		break;
 	case SCM_TSTAMP_SND:
 		tsname = "  SND";
 		validate_timestamp(&tss->ts[0], cfg_delay_snd);
+		add_timing_event(&usr_snd, &ts_usr, &tss->ts[0]);
 		break;
 	case SCM_TSTAMP_ACK:
 		tsname = "  ACK";
 		validate_timestamp(&tss->ts[0], cfg_delay_ack);
+		add_timing_event(&usr_ack, &ts_usr, &tss->ts[0]);
 		break;
 	default:
 		error(1, 0, "unknown timestamp type: %u",
@@ -203,6 +238,21 @@ static void print_timestamp(struct scm_timestamping *tss, int tstype,
 	__print_timestamp(tsname, &tss->ts[0], tskey, payload_len);
 }
 
+static void print_timing_event(char *name, struct timing_event *te)
+{
+	if (!te->count)
+		return;
+
+	fprintf(stderr, "    %s: count=%d", name, te->count);
+	fprintf(stderr, ", avg=");
+	__print_ts_delta_formatted((int64_t)(te->total / te->count));
+	fprintf(stderr, ", min=");
+	__print_ts_delta_formatted(te->min);
+	fprintf(stderr, ", max=");
+	__print_ts_delta_formatted(te->max);
+	fprintf(stderr, "\n");
+}
+
 /* TODO: convert to check_and_print payload once API is stable */
 static void print_payload(char *data, int len)
 {
@@ -436,6 +486,10 @@ static void do_test(int family, unsigned int report_opt)
 	char *buf;
 	int fd, i, val = 1, total_len, epfd = 0;
 
+	init_timing_event(&usr_enq);
+	init_timing_event(&usr_snd);
+	init_timing_event(&usr_ack);
+
 	total_len = cfg_payload_len;
 	if (cfg_use_pf_packet || cfg_proto == SOCK_RAW) {
 		total_len += sizeof(struct udphdr);
@@ -595,6 +649,10 @@ static void do_test(int family, unsigned int report_opt)
 		while (!recv_errmsg(fd)) {}
 	}
 
+	print_timing_event("USR-ENQ", &usr_enq);
+	print_timing_event("USR-SND", &usr_snd);
+	print_timing_event("USR-ACK", &usr_ack);
+
 	if (close(fd))
 		error(1, errno, "close");
 
-- 
2.25.1.481.gfbce0eb801-goog

