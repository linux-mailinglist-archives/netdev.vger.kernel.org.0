Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44911F7D38
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 20:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgFLSxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 14:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgFLSxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 14:53:39 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC73C03E96F;
        Fri, 12 Jun 2020 11:53:38 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l17so9979441qki.9;
        Fri, 12 Jun 2020 11:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Qh641OHejXpMoiaqdfORBCnk81oMMYKOpl7AmvDd/qw=;
        b=sK8ZIgksUWgBLZYVKp/MiKTt2re/4Di/h5B/xyVC8dkmzziuY/1cIkb85PITbY8PIb
         tctq/P+GJFegS9YkoMsx5AU5Lkq0Vp807deCfhElDIWcobZVOJs1/ZuHlsOKkF8G9zkE
         BJOiEv2iEzDEdYXf6FUInS3/M9IcdLnXz0qEToO38P8vkRJ/yG9CLjNGf8LOc2d9337m
         J8adFRGzHKTHcx8hehD+qK98MLstkTJniCMB1ANol4TlMV9yHc1dcgLrWKZhpCGQNOJn
         lMdL6ILIKqcZjxGJ/hpbGEp/bH/dip0vPKsgU+E/UMk+sSQ74ocESMuHuRV8D65ezGBS
         wG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Qh641OHejXpMoiaqdfORBCnk81oMMYKOpl7AmvDd/qw=;
        b=J7By8jCDCTpfSClplUMudggw4gKiHMCdFnsryJgoK4v/s6EvRsp3tARwFINzhnAKpO
         ZCOPCulwDL4BF5ERV4BzEJ2wYLSWpko+uS1K5wcIBp3tAKI0ffGAEGlxWIjIWvvSnL9w
         L2UYeHq97YXH4UwVDyslX8SyPRgi1JOdfW3/9XnsW2jxaT5EZGy+0+R92byoIvHJlTyT
         MNtYKMt1dvQuhPjaz7HSHHI60peRmDa4Q8fWK9/M3Ha2xNzcMOWLlPmAEEuzKz9yK+L1
         TYDpYQ9WVlKsq90XrlllmaxR8yC0XpOwML3mYT3YVxFhvI3vQq4T8+I8EVXaogmSSrep
         dAGw==
X-Gm-Message-State: AOAM533l7WPPsfs1X/YARdpJFkBiG7zxmTyHEQhUrDPZ+LSR37AZJlXf
        lxt7pLS+/DUarN8m4/zTD9o=
X-Google-Smtp-Source: ABdhPJxSKn+a0LGaP3g0JoZhdw2t7p0eQrGpXb5LV8ZhEXVn/bgcKifKQYF7hdJ9C/3U1fewbNzNig==
X-Received: by 2002:ae9:f80e:: with SMTP id x14mr4336586qkh.314.1591988017643;
        Fri, 12 Jun 2020 11:53:37 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:549b:4a8:a945:10b9])
        by smtp.googlemail.com with ESMTPSA id o6sm5079906qtd.59.2020.06.12.11.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 11:53:37 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP (eXpress Data Path)),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] xdp_rxq_info_user: Fix null pointer dereference. Replace malloc/memset with calloc.
Date:   Fri, 12 Jun 2020 14:53:27 -0400
Message-Id: <20200612185328.4671-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200611150221.15665-1-gaurav1086@gmail.com>
References: <20200611150221.15665-1-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memset on the pointer right after malloc can cause a
null pointer deference if it failed to allocate memory.
A simple fix is to replace malloc/memset with a calloc()

Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info")
Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 samples/bpf/xdp_rxq_info_user.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index 4fe47502ebed..caa4e7ffcfc7 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -198,11 +198,8 @@ static struct datarec *alloc_record_per_cpu(void)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	struct datarec *array;
-	size_t size;
 
-	size = sizeof(struct datarec) * nr_cpus;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_cpus, sizeof(struct datarec));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
 		exit(EXIT_FAIL_MEM);
@@ -214,11 +211,8 @@ static struct record *alloc_record_per_rxq(void)
 {
 	unsigned int nr_rxqs = bpf_map__def(rx_queue_index_map)->max_entries;
 	struct record *array;
-	size_t size;
 
-	size = sizeof(struct record) * nr_rxqs;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_rxqs, sizeof(struct record));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_rxqs:%u)\n", nr_rxqs);
 		exit(EXIT_FAIL_MEM);
@@ -232,8 +226,7 @@ static struct stats_record *alloc_stats_record(void)
 	struct stats_record *rec;
 	int i;
 
-	rec = malloc(sizeof(*rec));
-	memset(rec, 0, sizeof(*rec));
+	rec = calloc(1, sizeof(struct stats_record));
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
 		exit(EXIT_FAIL_MEM);
-- 
2.17.1

