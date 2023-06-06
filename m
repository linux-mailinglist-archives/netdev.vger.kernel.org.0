Return-Path: <netdev+bounces-8595-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89B57724AFC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF5DF1C20ADF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C6922E37;
	Tue,  6 Jun 2023 18:13:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB14C19915
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:13:06 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE681B5
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:13:05 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b02fddb908so6918925ad.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 11:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686075185; x=1688667185;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PvBd89GxTeguLjUzh8dEicRmm1f20khOqnMDSoGF/6k=;
        b=ObNtymrL+2tK46WnFdBi2j0ugisfk/viGZ0M66Fe8fKDbDyKEt+BAydaW+s/DjXrTc
         oEhViJ+DY23nTSwjdi2f/8c/gsPI+oU/Xl+3nOcUW+FKithiBmzBWdootNvx1vj5J5S0
         m24AeZZ4NStelV0LAj0SMR4TvWG0AGfmtGJ8hg/t41vMp3Ses+pHGx13tr/+wIiH7NhJ
         pm+I5Ad6zWIDhvdGR3slGq0WlfNmz45JxsScHYKwiSCuqJyu/Yj//CkpJsQTsoY8/GU8
         GkbRO4qSMn4ZjGbMxQ7cwADM1kIaMZdSccLp3sG/ec8uVrX++/ruaFOzoNWiB7CYIJoi
         r8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686075185; x=1688667185;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PvBd89GxTeguLjUzh8dEicRmm1f20khOqnMDSoGF/6k=;
        b=ZUsjeeSWZUOx8D+1eCZUwSTRd1FNK45xOn3rmMUKd5McVWS9l77m8TIGCYUEOeDlE8
         LWm0ivmARscwQXxKuHE5RQ4ipqwfAV+OJgjWf9IhlVUWdu6Ri7sQXDKbt6LXuXjqcPQQ
         M/eIyyw2xcWBLGVtYxY4XzWe3Z3J2JLHgTLXQ6HTp5dDzX78+/7UhovrYoiDEyEdtF/L
         xukerfVfS7W1dhb7RZJvQtk0KLVQYm9RIsckYA4y0Y5/5caaZCXeUB9A+LB2D3McZMg6
         b3T5oj0WyTSZptRuELnXBiJ/5oEtyDTOUDLbiNG6R/wVzPjvdsI/NIAsXWBT4rkT18JJ
         YsEg==
X-Gm-Message-State: AC+VfDyeoWEN3s2WQ+kOxzWriL70YSnPZuOZAxHZJVZSLPWlGZtflEdY
	SGe1PhZAR5jlvYvfW1IyTax/TpABpts=
X-Google-Smtp-Source: ACHHUZ58aWqJw4BwMQ2biuyUCD97+cblLW54UJz+ensoOADaEbtQmP9cI8v+kuF1PNPXPmziz1KyGQ==
X-Received: by 2002:a17:903:22cf:b0:1ae:3ff8:7fa7 with SMTP id y15-20020a17090322cf00b001ae3ff87fa7mr3202901plg.4.1686075184903;
        Tue, 06 Jun 2023 11:13:04 -0700 (PDT)
Received: from dmoe.c.googlers.com.com (25.11.145.34.bc.googleusercontent.com. [34.145.11.25])
        by smtp.gmail.com with ESMTPSA id f3-20020a170902ce8300b001ac7af58b66sm8848805plg.224.2023.06.06.11.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 11:13:04 -0700 (PDT)
From: David Morley <morleyd.kernel@gmail.com>
To: David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org,
	David Morley <morleyd@google.com>,
	Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next] tcp: fix formatting in sysctl_net_ipv4.c
Date: Tue,  6 Jun 2023 18:12:33 +0000
Message-ID: <20230606181233.373319-1-morleyd.kernel@gmail.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
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

From: David Morley <morleyd@google.com>

Fix incorrectly formatted tcp_syn_linear_timeouts sysctl in the
ipv4_net_table.

Fixes: ccce324dabfe ("tcp: make the first N SYN RTO backoffs linear")
Signed-off-by: David Morley <morleyd@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Tested-by: David Morley <morleyd@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/sysctl_net_ipv4.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 6ae3345a3bdf..ef26f9013a0f 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1472,13 +1472,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra2         = &tcp_plb_max_cong_thresh,
 	},
 	{
-		.procname = "tcp_syn_linear_timeouts",
-		.data = &init_net.ipv4.sysctl_tcp_syn_linear_timeouts,
-		.maxlen = sizeof(u8),
-		.mode = 0644,
-		.proc_handler = proc_dou8vec_minmax,
-		.extra1 = SYSCTL_ZERO,
-		.extra2 = &tcp_syn_linear_timeouts_max,
+		.procname	= "tcp_syn_linear_timeouts",
+		.data		= &init_net.ipv4.sysctl_tcp_syn_linear_timeouts,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &tcp_syn_linear_timeouts_max,
 	},
 	{ }
 };
-- 
2.41.0.rc0.172.g3f132b7071-goog


