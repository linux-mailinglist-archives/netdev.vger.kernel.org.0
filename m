Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B4D6BABFD
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjCOJVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjCOJVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:21:11 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC522136F9;
        Wed, 15 Mar 2023 02:21:04 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so1233055pjt.5;
        Wed, 15 Mar 2023 02:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678872064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJFkHj2RxpR96gvbvk1aE/Eh3CSZgyvJVZ3ptNgD4Ng=;
        b=mZ7zqv0DAYSWQ4j85AsVt8pIuaUDOQeVcnzkuvb80Ye2uOFe5YRekt+lbnHLIOokC7
         nOU3IszU+Cn7JW7HKdxr+FbgwkVNq50AphOTClhq53oQiei4pjOB8oj3Jvy3GqsIf5hq
         dT47vMp+4TJv2Xt7crTHlh2jGGKay5VhhEFPkhO3oss/SEC7f6z4c56uEyI1mt6omlhS
         THl/UlAfYWSqFbya9q6wl0h87fSXgu6kKFqjdOFmJX3ju6BQoxrtOcP4qczEqjIAx5TF
         a/APdJD9BH/DLIZ1hM02B5nHf7J4KwDL8jFpCJ6DHmsIp3DPMkmomk5mWIeKmQ4mXvaS
         yrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678872064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJFkHj2RxpR96gvbvk1aE/Eh3CSZgyvJVZ3ptNgD4Ng=;
        b=q8/iFkv/P1uHQjtWFr1bQ1e4iw5ZauVbj1iNrHoxNU6VJeEB031AXgRCmSBT7CJMyR
         9h6wb3pKmUz3nd5NpGQKSL5iiqV3Jdgc+r0izOwLuDrTu4bVU3z0wP1Kt7y88YdoX11A
         a0UYn05YjaAZU8jPETl3Agbwazft+lJUTgjqzqX2OW1KK8bHn+FVNt9nAdUqTcWabAB2
         UpXbXWxZfR0V4PKT7iCBQptxH+ZifhKNdovSM1hXGTl4gFMl/TzDF3UVrPrzl1kUck9s
         ZPANictN2caAgkdLHaVNk5GzqES8YCdPMVkJ93yqH1v7NGLjqMd/7yHUI8CNxrRSiD9X
         pDFg==
X-Gm-Message-State: AO0yUKV3RO+OV24/V4rthkLCQ/AeNi7K/ablsyXEJxxYF2PajXVtanxw
        hVOOggdCZgM4JzY9cT2vumk=
X-Google-Smtp-Source: AK7set+MqYMXqNfcjYGxeTTTSrhzhqwejvkhh/3/zi6dYDOX9F3q1mt492BynQ/ypDXMafSN7VRCNQ==
X-Received: by 2002:a05:6a20:a121:b0:cd:87ef:3f1a with SMTP id q33-20020a056a20a12100b000cd87ef3f1amr45851572pzk.3.1678872064100;
        Wed, 15 Mar 2023 02:21:04 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id n3-20020aa79043000000b005ae02dc5b94sm2971815pfo.219.2023.03.15.02.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 02:21:03 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v4 net-next 1/2] net-sysfs: display two backlog queue len separately
Date:   Wed, 15 Mar 2023 17:20:40 +0800
Message-Id: <20230315092041.35482-2-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230315092041.35482-1-kerneljasonxing@gmail.com>
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Sometimes we need to know which one of backlog queue can be exactly
long enough to cause some latency when debugging this part is needed.
Thus, we can then separate the display of both.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v4:
1) avoid the inconsistency through caching variables suggested
by Eric.
Link: https://lore.kernel.org/lkml/20230314030532.9238-2-kerneljasonxing@gmail.com/
2) remove the unused function: softnet_backlog_len()

v3: drop the comment suggested by Simon
Link: https://lore.kernel.org/lkml/20230314030532.9238-2-kerneljasonxing@gmail.com/

v2: keep the total len of backlog queues untouched as Eric said
Link: https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@gmail.com/
---
 net/core/net-procfs.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 1ec23bf8b05c..09f7ed1a04e8 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -115,10 +115,14 @@ static int dev_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static u32 softnet_backlog_len(struct softnet_data *sd)
+static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
 {
-	return skb_queue_len_lockless(&sd->input_pkt_queue) +
-	       skb_queue_len_lockless(&sd->process_queue);
+	return skb_queue_len_lockless(&sd->input_pkt_queue);
+}
+
+static u32 softnet_process_queue_len(struct softnet_data *sd)
+{
+	return skb_queue_len_lockless(&sd->process_queue);
 }
 
 static struct softnet_data *softnet_get_online(loff_t *pos)
@@ -152,6 +156,8 @@ static void softnet_seq_stop(struct seq_file *seq, void *v)
 static int softnet_seq_show(struct seq_file *seq, void *v)
 {
 	struct softnet_data *sd = v;
+	u32 input_qlen = softnet_input_pkt_queue_len(sd);
+	u32 process_qlen = softnet_process_queue_len(sd);
 	unsigned int flow_limit_count = 0;
 
 #ifdef CONFIG_NET_FLOW_LIMIT
@@ -169,12 +175,14 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
 	 * mapping the data a specific CPU
 	 */
 	seq_printf(seq,
-		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x\n",
+		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
+		   "%08x %08x\n",
 		   sd->processed, sd->dropped, sd->time_squeeze, 0,
 		   0, 0, 0, 0, /* was fastroute */
 		   0,	/* was cpu_collision */
 		   sd->received_rps, flow_limit_count,
-		   softnet_backlog_len(sd), (int)seq->index);
+		   input_qlen + process_qlen, (int)seq->index,
+		   input_qlen, process_qlen);
 	return 0;
 }
 
-- 
2.37.3

