Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56BC64B6B1A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbiBOLdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:33:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237294AbiBOLdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:33:20 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E371D201A1;
        Tue, 15 Feb 2022 03:32:41 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id u16so342997pfg.12;
        Tue, 15 Feb 2022 03:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YVR6bNBU9Pl8MoQNPuKiEG9Qqnb4IUp54CTPQEoDvoQ=;
        b=YQfJIKbxHLurxwQh9olo0G1j1ELpLXcq36hFomv9bxZDXotJyrJBRH2qtbjEd2uAn1
         +9DuY1MDCfucp8zpW10NCSAL3hnAgtrUMsZmzWXfqpL3EKN9AuEK8LJm5O2SH32gjcaj
         /iDQf4MWRA1SN21eL2L4j9+dZtNFrgCymkzBhKEhOUVZDssJAWMXH05fcoUlSX25k/yZ
         ydvTbrQ/9Qzx245O1tI+K5Xi/abT9ieZo8rctcOREYVTPvtvdav0FjWFJfDvbLG3H1Nq
         iPY7ATOV5CAnJsrOqTNM2ZJPCxU7rTQKbApbj9mqJeVki+W0EBvZhq3jIj79/K5ev9++
         oBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YVR6bNBU9Pl8MoQNPuKiEG9Qqnb4IUp54CTPQEoDvoQ=;
        b=n3zSIAvhcKGc9xjuXL2PEQOr0OKYXc7hT7/STaERw3Zy/TOFoBP+c/t4VNVKw1XrUL
         z7OHlXqOA8pFlUPLmKQyrW9x+Y6E7ap6wF4MDO3VGOsO06zZVgdHhb/A5rRo29ugKkXF
         BtDxJj5asS8f39igp5/gnmr7L8QvY02rzgVJ0qZiqabPSkCavJvcf1AZ0SmT5qI0HnWk
         GpL9l+r636z119MySNz2L2oOdDROk9Po0S+utVNZpTaee0zvHTWzOi4CXmaWS8oe7zzT
         SGVb0IG+waoxX9IrRavJhUXRaRaMbmCkq1HhE8bIFBWm73xl1LPc63+USz1zmEVe6nh1
         GtiA==
X-Gm-Message-State: AOAM532CoSH4WgnxO4u3/BlYxOnCme9iZbheTl5FneAHeuqVxeShpNs5
        jMN7m9yLVoAUibbJA2UFjhs=
X-Google-Smtp-Source: ABdhPJwngik4/NwdCkpUv8oH8h3TezojUzGLHnVVrSZml1YnfDLGiUFC8bikMe95Dm3ujYkpYghHbw==
X-Received: by 2002:aa7:8e44:: with SMTP id d4mr3891656pfr.4.1644924761506;
        Tue, 15 Feb 2022 03:32:41 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:32:40 -0800 (PST)
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
Subject: [PATCH net-next 17/19] net: dev: use kfree_skb_reason() for do_xdp_generic()
Date:   Tue, 15 Feb 2022 19:28:10 +0800
Message-Id: <20220215112812.2093852-18-imagedong@tencent.com>
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

Replace kfree_skb() used in do_xdp_generic() with kfree_skb_reason().
The drop reason SKB_DROP_REASON_XDP is introduced for this case.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d59fdcd98278..79b24d5f491d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -410,6 +410,7 @@ enum skb_drop_reason {
 					 * full (see netdev_max_backlog in
 					 * net.rst) or RPS flow limit
 					 */
+	SKB_DROP_REASON_XDP,		/* dropped by XDP in input path */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a1c235daf23b..7bc46414a81b 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -46,6 +46,7 @@
 	EM(SKB_DROP_REASON_QDISC_EGRESS, QDISC_EGRESS)		\
 	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
 	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
+	EM(SKB_DROP_REASON_XDP, XDP)				\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 8fee7adfca88..a2548b7f2708 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4783,7 +4783,7 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 	}
 	return XDP_PASS;
 out_redir:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_XDP);
 	return XDP_DROP;
 }
 EXPORT_SYMBOL_GPL(do_xdp_generic);
-- 
2.34.1

