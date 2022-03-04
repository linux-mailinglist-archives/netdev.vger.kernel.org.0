Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0779E4CCD77
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbiCDGCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238264AbiCDGCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:02:45 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8DB187BB3;
        Thu,  3 Mar 2022 22:01:53 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id s8so2704117pfk.12;
        Thu, 03 Mar 2022 22:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tjhKldmhGAQAKgh1N5IQxYI+us242gVIaXzKgAhlpB4=;
        b=HtuTEnJ2wd9lCxrNLk5HQGdIgKm6ydkREnk7Fbin73qK0AS181fzvfDRlyo/i7DLU/
         3HJlN8+mVLRrfddY02FDoLEt1B0M+K3f5OxrvdGN7pLdZ2maBhCfGWHQFhoY35oF18cx
         1VXIEVEr+U+1AGdE+NsWF2882RkLDbJD2x1YYOzAPFLauMXd+cHvwQCVXgL12MB183vX
         zFx2xNHo523CMr5LcS1MxfhYE0Iz7b1QIl+j8dC9GWybtcgWvVm3+7Uc4vgpHCpzLGI+
         2vFa0a7vVoGUr2G75DBdGONf/DHEI0/v9pzzxJ33UBHV5LHxqbao0A5TGqGbL0UZ648q
         qInw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tjhKldmhGAQAKgh1N5IQxYI+us242gVIaXzKgAhlpB4=;
        b=pWu0ML+CdHzD+HW9ZrSGNnhR1nunVKvNuVGxUV7L2GMrhyk7VuIADW+1DZPYgJ3RDn
         /Z837lb3i5yUTX1vyP6TBzwZeeMr3fdCMLAjWd774G9BU0+1y0Wt6cypwqX8T+1jxUGY
         vQaPYGizMoObDS0ui2ffv2vlZzzN39DoSbSl07rXJgM8hQIZOqZ8RJBSdHGiWlLOGXO5
         6YBjzYcNNBZpbCo1aMkrNKPf/RX9BQqpf6G+NG2mIr2qex1jFfIyGHUNoze0O4zkE4gk
         GAeiOyxl85Z5nqlsp+HSN+pav0NzqP+CPuc/YFGudm3OV1kXwdBo1Wt31VNXwCfMbja0
         aNAQ==
X-Gm-Message-State: AOAM532zFT9fqBndZNlFtLIE793RvU0rpbHhjht6J67CYcNgmG03D4SG
        OcX2T+w0U8iWJWZ/zi1s6MA=
X-Google-Smtp-Source: ABdhPJzVdfO3qBUbuK9q3ei1i1cI197lrtsYkwOThyAy7Xhufbk4bao0s5MjPWsA5RcuSutnEC/UoA==
X-Received: by 2002:a62:3085:0:b0:4e0:1218:6d03 with SMTP id w127-20020a623085000000b004e012186d03mr41186844pfw.19.1646373713307;
        Thu, 03 Mar 2022 22:01:53 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b004f104b5350fsm4569073pfi.93.2022.03.03.22.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 22:01:52 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        edumazet@google.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, memxor@gmail.com, arnd@arndb.de,
        pabeni@redhat.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next v2 2/7] net: skb: introduce the function kfree_skb_list_reason()
Date:   Fri,  4 Mar 2022 14:00:41 +0800
Message-Id: <20220304060046.115414-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304060046.115414-1-imagedong@tencent.com>
References: <20220304060046.115414-1-imagedong@tencent.com>
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

To report reasons of skb drops, introduce the function
kfree_skb_list_reason() and make kfree_skb_list() an inline call to
it. This function will be used in the next commit in
__dev_xmit_skb().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 8 +++++++-
 net/core/skbuff.c      | 7 ++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4328dfc3281c..9d219e266dc7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1191,10 +1191,16 @@ static inline void kfree_skb(struct sk_buff *skb)
 }
 
 void skb_release_head_state(struct sk_buff *skb);
-void kfree_skb_list(struct sk_buff *segs);
+void kfree_skb_list_reason(struct sk_buff *segs,
+			   enum skb_drop_reason reason);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
 
+static inline void kfree_skb_list(struct sk_buff *segs)
+{
+	kfree_skb_list_reason(segs, SKB_DROP_REASON_NOT_SPECIFIED);
+}
+
 #ifdef CONFIG_TRACEPOINTS
 void consume_skb(struct sk_buff *skb);
 #else
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b32c5d782fe1..46d7dea78011 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -777,16 +777,17 @@ void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 }
 EXPORT_SYMBOL(kfree_skb_reason);
 
-void kfree_skb_list(struct sk_buff *segs)
+void kfree_skb_list_reason(struct sk_buff *segs,
+			   enum skb_drop_reason reason)
 {
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
-		kfree_skb(segs);
+		kfree_skb_reason(segs, reason);
 		segs = next;
 	}
 }
-EXPORT_SYMBOL(kfree_skb_list);
+EXPORT_SYMBOL(kfree_skb_list_reason);
 
 /* Dump skb information and contents.
  *
-- 
2.35.1

