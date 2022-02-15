Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0448F4B6B12
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbiBOLdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:33:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237324AbiBOLcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:32:25 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982D113FA8;
        Tue, 15 Feb 2022 03:32:14 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso1855322pjh.5;
        Tue, 15 Feb 2022 03:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IhNqtUiymJdJP2PFRV84KUeWXIpI5jZ1newpR0JSrRw=;
        b=U6LBQs22JEn6MCJRQHgPP0aJScUEu08steoCaMHRVWgEEYRnjoqlRv7okneMAFSzrl
         nWAVXZArFeO6Hn2+X7R8m3DJTNogTca7/AawIYm04ClmXIpVXJJ73Y3S2YMCkkxCxxKD
         WxrKOdZ95iIumwfK995iAejb91hq2/QEqIhOs6cSOJ2JPXm0m76I6ddG/jGUH4SxiCmF
         YnUCY4NfLPunNzIdtvkuVoS4KFd/bI9cBgZ+oz+XZD5A4zWRZFqkpNztpaDNDhSGGpfl
         YqykoF536hegz8MZgYNQL03/0w82esNRbDSqEM8JC+2H1GPMMGfcM5ecQDBY8t5Czfu+
         zJMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IhNqtUiymJdJP2PFRV84KUeWXIpI5jZ1newpR0JSrRw=;
        b=Y5PlTcJ1NJHsBsOVrcWjNUubyhEHF3MMM5YmDqsYNFOdXEv61tuLBasu0NGxo7wv0c
         kpb+/JKY55uxjTs5pH/VQal8isawhJouPrjvNUYTz9GVebbAK+6r+yEhrDYIGVrmRot6
         CiWwVi5K9lx9uE70FQnPjRSbRi5IEFXYNG3B6i5evjW4gfURmCl4HAC//SBb30sU46MZ
         rpQOOmTY59XuUPcQQtxiqoN5hryvNPythxRmX9/XydG7yTjdE/QIcSU63GBSAzedVbVJ
         thOJUKf/C6DJJRdzSKb4F4xqtdBanPfZ+UEZWBkrZmXCN7bpFvtOuUaOCh6Ig52DBmWl
         e2oQ==
X-Gm-Message-State: AOAM530ER1lTvRVqofQGql5pwnEuF2Fsgz3xxXVl7GSiHTHe4M2FLC8p
        DWzopj7oA07W9/WD6oA718E=
X-Google-Smtp-Source: ABdhPJxv/jNWEqzuXwYilVop3ZnjSaw/2f9/67mqeoDfVOf7SzrRT4uYkaUDB6fzSDYZ4wcC2K10pA==
X-Received: by 2002:a17:902:bd8b:: with SMTP id q11mr3620085pls.83.1644924734114;
        Tue, 15 Feb 2022 03:32:14 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:32:13 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next 13/19] net: dev: use kfree_skb_reason() for sch_handle_egress()
Date:   Tue, 15 Feb 2022 19:28:06 +0800
Message-Id: <20220215112812.2093852-14-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215112812.2093852-1-imagedong@tencent.com>
References: <20220215112812.2093852-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() used in sch_handle_egress() with kfree_skb_reason().
The drop reason SKB_DROP_REASON_QDISC_EGRESS is introduced. Considering
the code path of qdisc egress, we make it distinct with the drop reason
of SKB_DROP_REASON_QDISC_DROP in the next commit.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 4 ++++
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 136af29be256..9e19806d9818 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -396,6 +396,10 @@ enum skb_drop_reason {
 						 * full, and the skbs on the
 						 * tail will be dropped
 						 */
+	SKB_DROP_REASON_QDISC_EGRESS,	/* qdisc of type egress check
+					 * failed (maybe an eBPF program
+					 * is tricking?)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index dd06366ded4a..a79b64eace9e 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -43,6 +43,7 @@
 	EM(SKB_DROP_REASON_IPV6DSIABLED, IPV6DSIABLED)		\
 	EM(SKB_DROP_REASON_NEIGH_FAILED, NEIGH_FAILED)		\
 	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
+	EM(SKB_DROP_REASON_QDISC_EGRESS, QDISC_EGRESS)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 2c3b8744e00c..2a7b7c1b855a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3840,7 +3840,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
 		*ret = NET_XMIT_DROP;
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_QDISC_EGRESS);
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
-- 
2.34.1

