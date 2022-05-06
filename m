Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702F151DFC1
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 21:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389522AbiEFTtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391394AbiEFTtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:49:22 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D971A061;
        Fri,  6 May 2022 12:45:38 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id eq14so6136177qvb.4;
        Fri, 06 May 2022 12:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=26UBhVESvjEt8vd9ljEpnrYxuM75PmMbuVfnsO+5kk8=;
        b=OideI0KaQlA/EguUnJr9tHJ2iTCxXXeRQbsI0HYlcM5BWN3ICtro3OItNuTLO68gC5
         /RNF9st81UpXgFXfKYZXUH+GcRs0TdlqUi2DjKVHPlkV25fFYKIYJEh4uRqBSE+LTxqT
         NhWFc6gAAlMuXDViZJcXxDuIwldYAZvia8CGYwj+CzoLweSwvmHhvbgfl1BViP7vcV3F
         l9AXA0fn02tY5AfKDo8mdqFGoAa+99t4TCRlLPzyEOiyJuuvznATLSYFAVQtMnA41a9J
         Ewfh2wnVnHKwtqAhnRb5Z5YYfITvogxZO4+EAw+Hk7PTci6nX3Z7zHo/rOMRYra00dZl
         OxfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=26UBhVESvjEt8vd9ljEpnrYxuM75PmMbuVfnsO+5kk8=;
        b=u7M2lJbqpjJ7Pj04TyfTuqlQml1YQ6LATBknpmaKbGvR4FxENbOm+P7A+ddKWo3utj
         HHt2bFJrx5sgR2QBG0I5ihB2usecDtB5fWpYHmrRrSI2Fhgi5vBkH4PofX0rVK3/+puc
         P6dMriqWFsy2Lnh2v2PTSLveQYjLBrwDrFWVmTLljnNp22SCKVsjjJmGnLCDT137L3Zx
         367ZhdUQ1Ix9R4jmqqmBQfr7I1LyCcjTSvoXZewK9xwqiEX0TE8Xt9J6uHNd3fub0yn9
         jqDzO/qz0dMrQU+puflg0qw3b3nl5DCvVI+CV4EZ4utEbqo6piCw32dk/CCeKi6/OiD3
         xTmQ==
X-Gm-Message-State: AOAM532jDPjW0UlKaXrCDNTFLlIKXolE9LmB2KM6qGujsCTBTU3crUPo
        K3AgnBKAjar8SdpVdR/KcweGxKQttLtx
X-Google-Smtp-Source: ABdhPJycrjIOghTy5gAFeYF4Lhjrq1tCpWl7yvNFArlYIg2141TlkqfJs+6F64I9fiNu3wUpk/0GgQ==
X-Received: by 2002:ad4:5c6e:0:b0:45a:aefd:f551 with SMTP id i14-20020ad45c6e000000b0045aaefdf551mr3930759qvh.95.1651866337093;
        Fri, 06 May 2022 12:45:37 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-72-174-210.compute-1.amazonaws.com. [52.72.174.210])
        by smtp.gmail.com with ESMTPSA id x68-20020a376347000000b0069fc13ce1e2sm2914541qkb.19.2022.05.06.12.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 12:45:36 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH RFC v1 net-next 3/4] net/sched: sch_htb: Use Qdisc backpressure infrastructure
Date:   Fri,  6 May 2022 12:45:24 -0700
Message-Id: <ffcde45d06d12def0b9c2c9238b0325db252a5cc.1651800598.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651800598.git.peilin.ye@bytedance.com>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we introduced a Qdisc backpressure infrastructure for TCP and
UDP sockets.  Use it in HTB.

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_htb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 23a9d6242429..21d78dff08e7 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -623,6 +623,7 @@ static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			__qdisc_enqueue_tail(skb, &q->direct_queue);
 			q->direct_pkts++;
 		} else {
+			qdisc_backpressure_overlimit(sch, skb);
 			return qdisc_drop(skb, sch, to_free);
 		}
 #ifdef CONFIG_NET_CLS_ACT
@@ -634,6 +635,7 @@ static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 #endif
 	} else if ((ret = qdisc_enqueue(skb, cl->leaf.q,
 					to_free)) != NET_XMIT_SUCCESS) {
+		qdisc_backpressure_overlimit(sch, skb);
 		if (net_xmit_drop_count(ret)) {
 			qdisc_qstats_drop(sch);
 			cl->drops++;
@@ -978,6 +980,9 @@ static struct sk_buff *htb_dequeue(struct Qdisc *sch)
 				goto ok;
 		}
 	}
+
+	qdisc_backpressure_throttle(sch);
+
 	if (likely(next_event > q->now))
 		qdisc_watchdog_schedule_ns(&q->watchdog, next_event);
 	else
-- 
2.20.1

