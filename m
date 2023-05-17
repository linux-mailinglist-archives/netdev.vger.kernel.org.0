Return-Path: <netdev+bounces-3347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B50870686C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57E3A2811AC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F72018B13;
	Wed, 17 May 2023 12:42:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C7D1549B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:42:14 +0000 (UTC)
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E462E7A;
	Wed, 17 May 2023 05:42:11 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-643ac91c51fso534320b3a.1;
        Wed, 17 May 2023 05:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684327331; x=1686919331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EPpBzc8U46icZRxTtg/C9J0WiKkv45MAA53fWrbYIQ0=;
        b=O60dhM/uIO2RqpUb7HUDbbNgTo94TW9EJxg6BGTAGlyvmhisydQeE0inp1u2RKYPvi
         bKCqR1opFS9yNdG42a5ozgD7QJ/s9VklocbsMdwNxDdiezOfaPBLGMoX0bcfofKwqhQQ
         sjR5ZG3PcopHSV41gHDVuwymYhNagQZQSRUpQ5aZhZiw7uLApDsO4jLVAOPQUKcz+OIh
         wrdaAxT22GLsKMoI9KTUG6yGNMdNWaYmsMH7lyrBu37rNkyhGm52tonO4O6B7ZRFDK/g
         IMRe9rJjQaJtjU+KXocNduhoNq9W/+hjKeyc0Ek52dkdRgAc7hwrHdn6aD8lq0U8gxkP
         qmPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684327331; x=1686919331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EPpBzc8U46icZRxTtg/C9J0WiKkv45MAA53fWrbYIQ0=;
        b=N5w7bQeZ0Vqr332K8n7XifxCNg5PECj5OZGaq8HKFtb4YxpcsJ4nzlvCzsE1NsKZ1/
         vHt7LuareLtI34gS1losRss44+5LiCvvDFj42ueIsUlvhSEQbl/A5tJqCkDxzEWd73JF
         rOOLaHDoh6meP/rDiKw3vvOv9SWayNJAQfIxLfjhRfsxtb7x+S88NJ5bOzPkrmHyTjJn
         wXRWQA2NjiQYu9C02NlzOZnshDQutnu+kIVyqokyMvzY0zKxEMen8dOOo/o1imwdinGH
         KLgBoalzpDsb/InyhivC7EC4NOPA1tI2PBb+KdWLYbiOVesGcfFwQZLMbmeYvlho2avf
         wP0A==
X-Gm-Message-State: AC+VfDy0fudbE9CEsyNNUDobSMRB1OH5Hop8/WVAnVVZVKwz4twqMlNm
	TXsdjBbgJEsLKleoqXS26H4=
X-Google-Smtp-Source: ACHHUZ5JkhPKg6y+ftOY75hoFRteYiVtRue48NakVXk5fALEe9HQFGwyEqQxmvlxq5iRTDd2mP8uwQ==
X-Received: by 2002:a05:6a21:6da4:b0:100:8258:169e with SMTP id wl36-20020a056a216da400b001008258169emr45051800pzb.24.1684327331107;
        Wed, 17 May 2023 05:42:11 -0700 (PDT)
Received: from localhost.localdomain ([81.70.217.19])
        by smtp.gmail.com with ESMTPSA id u23-20020aa78497000000b0064aea45b040sm9244224pfn.168.2023.05.17.05.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 05:42:10 -0700 (PDT)
From: menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To: kuba@kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	dsahern@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next 1/3] net: tcp: add sysctl for controling tcp window shrink
Date: Wed, 17 May 2023 20:41:59 +0800
Message-Id: <20230517124201.441634-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517124201.441634-1-imagedong@tencent.com>
References: <20230517124201.441634-1-imagedong@tencent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Menglong Dong <imagedong@tencent.com>

Introduce the sysctl 'tcp_wnd_shrink', which will be used in the
following patches.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/tcp.h          | 1 +
 net/ipv4/sysctl_net_ipv4.c | 9 +++++++++
 net/ipv4/tcp.c             | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a0a91a988272..a6cf6d823e34 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -247,6 +247,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 /* sysctl variables for tcp */
 extern int sysctl_tcp_max_orphans;
 extern long sysctl_tcp_mem[3];
+extern int sysctl_tcp_wnd_shrink;
 
 #define TCP_RACK_LOSS_DETECTION  0x1 /* Use RACK to detect losses */
 #define TCP_RACK_STATIC_REO_WND  0x2 /* Use static RACK reo wnd */
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 0d0cc4ef2b85..fd6cb5a5c2b9 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -577,6 +577,15 @@ static struct ctl_table ipv4_table[] = {
 		.extra1		= &sysctl_fib_sync_mem_min,
 		.extra2		= &sysctl_fib_sync_mem_max,
 	},
+	{
+		.procname       = "tcp_wnd_shrink",
+		.data           = &sysctl_tcp_wnd_shrink,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index fd68d49490f2..db0483b2159f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -297,6 +297,9 @@ EXPORT_SYMBOL(tcp_memory_allocated);
 DEFINE_PER_CPU(int, tcp_memory_per_cpu_fw_alloc);
 EXPORT_PER_CPU_SYMBOL_GPL(tcp_memory_per_cpu_fw_alloc);
 
+int sysctl_tcp_wnd_shrink __read_mostly;
+EXPORT_SYMBOL(sysctl_tcp_wnd_shrink);
+
 #if IS_ENABLED(CONFIG_SMC)
 DEFINE_STATIC_KEY_FALSE(tcp_have_smc);
 EXPORT_SYMBOL(tcp_have_smc);
-- 
2.40.1


