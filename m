Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103B76B88D5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 04:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjCNDGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 23:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjCNDGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 23:06:06 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7D07B98A;
        Mon, 13 Mar 2023 20:06:03 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id p6so15221370plf.0;
        Mon, 13 Mar 2023 20:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678763162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QMnMHWGI+QQmPd732o6xoqQE9KAk9SBU5515vgJD5J0=;
        b=iXVoGEfxqwaNVGV26EajhgquusIVcbpIlWLIhVGZ4F0VGtbRbc2a0KSAaT36hp0yEl
         A/nwBePWIo66HWBG7PNWaZjJck4SF2ODZL3d4QcAIvc2lhho3kWZvUO9yTKGyNvCGIIS
         3ZxTdtgQ1SbA08iVLVeHCCuH44/KDkX2gAzxIE7U/PfuIoYSviDyCMchCcCrqsSDBUd8
         qiY16BnIbUYlIlmJImzNxL6rX7qn4fhdDMrrMFJQEhxMWjdGoW6kq4HvvDMt1ZxZfHRP
         6EAFu0T85Gsz6XerT75UMjgK6HAylsc4HzvHNwXbqsqlJt2PYJWJv5U8cUHDrGlr/PNu
         HgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678763162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QMnMHWGI+QQmPd732o6xoqQE9KAk9SBU5515vgJD5J0=;
        b=NwlFGKOuPmHLvSaLz1S0manqmuu5JaFBcZ8ZpSqHpSBQxsiPmAn/ec2SQnZk9W8sbd
         6TDnHm/6pgTDIpzEbOJURbGyLbJi77FLLsYHpjz82qAEBkLqcDjURJCgpzBrEwpmyNG+
         vVn8NyW7g6ij59fcBLuFm/BxvtU90Pgl3zEb0J73g0a4CyQWWFKSobfSu2zPeYBe7XMV
         KLIEl7yZY5y0HQLkywB3pdTLp6iljmSCasCEHSiJxtQzt1TLND1g0Ecdf5hsRZjiALEs
         HW1ybDkpAqHtuzYn2ugmXKsDlaYnCQ2TydMuoihpDgbepyBfFgTniJNyaBLP4+MTV9BY
         SQEA==
X-Gm-Message-State: AO0yUKUHRR+rKHkum99Yb+sCHkTiFMDBdGOJN+2AkID73kwD83N5b820
        JlWbNifeEMDtBr0UJp+cUeQ=
X-Google-Smtp-Source: AK7set+WmAMu494alKCXS/l/BaLH8+eBmj9tGM8ANGA5Zy9Of3mG23kTUkmecvLJIQuDKN/Sn9lczA==
X-Received: by 2002:a05:6a20:a021:b0:d0:212d:ead0 with SMTP id p33-20020a056a20a02100b000d0212dead0mr10062481pzj.26.1678763162587;
        Mon, 13 Mar 2023 20:06:02 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id i17-20020aa787d1000000b005897f5436c0sm395433pfo.118.2023.03.13.20.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 20:06:02 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v2 net-next 1/2] net-sysfs: display two backlog queue len separately
Date:   Tue, 14 Mar 2023 11:05:31 +0800
Message-Id: <20230314030532.9238-2-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230314030532.9238-1-kerneljasonxing@gmail.com>
References: <20230314030532.9238-1-kerneljasonxing@gmail.com>
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
---
v2: keep the total len of backlog queues untouched as Eric said
Link: https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@gmail.com/
---
 net/core/net-procfs.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 1ec23bf8b05c..2809b663e78d 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -115,10 +115,19 @@ static int dev_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
+static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
+{
+	return skb_queue_len_lockless(&sd->input_pkt_queue);
+}
+
+static u32 softnet_process_queue_len(struct softnet_data *sd)
+{
+	return skb_queue_len_lockless(&sd->process_queue);
+}
+
 static u32 softnet_backlog_len(struct softnet_data *sd)
 {
-	return skb_queue_len_lockless(&sd->input_pkt_queue) +
-	       skb_queue_len_lockless(&sd->process_queue);
+	return softnet_input_pkt_queue_len(sd) + softnet_process_queue_len(sd);
 }
 
 static struct softnet_data *softnet_get_online(loff_t *pos)
@@ -169,12 +178,15 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
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
+		   softnet_backlog_len(sd),	/* keep it untouched */
+		   (int)seq->index,
+		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
 	return 0;
 }
 
-- 
2.37.3

