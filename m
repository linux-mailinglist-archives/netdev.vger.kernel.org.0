Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1300C4CCD85
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbiCDGDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbiCDGDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:03:00 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A5C180D1E;
        Thu,  3 Mar 2022 22:02:13 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id v1-20020a17090a088100b001bf25f97c6eso835389pjc.0;
        Thu, 03 Mar 2022 22:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ULoADH/G/w/GjzXvy9sGJIyoEGuMSEszufVomHB7uA=;
        b=bz2SH/N4U/Rx1gWGIr1xhDyrbbxaMEpULkXndj5gbwo6CRHugq43j09+Bj2POVoucU
         xjPWuFpQrOnpW9NlurPUHWZGVqm82+t4Gp/goX4qQiAWF4j+8Z3oCpyaCpl7Lfb1K/jE
         d8i5lAH26cEpgKOfCSq4LnIf7HfiBndcRtEDW11HXXfXmDg39ELXhiFmbcg+93gLSrNz
         +VdN4AcUzf8e+Rskekk2biMYNzm5SMmQXnjyEq4dG1x+blnRW0C8r+n1M/TSyXvL4D2X
         bfpC4721F+UdZGNDr7KpQEQytfeNVMDxTWhTMVaLVK9hOL3iKoJj/F1rbTTVX7Na/R4j
         J7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ULoADH/G/w/GjzXvy9sGJIyoEGuMSEszufVomHB7uA=;
        b=G7Gv9Zs4nZ14snOtpt9QZXbkFuE6+DgUe6/mlqO4LjycHEuGn5z48R9mDoi/Ny3CcN
         WClcq2qChuaTSLJ4gsyg4u0fz1zcIUgxna1v8M5OlqO3jOvEX3bLzJPDT8NR4bJ/nwXf
         AS19F0tht4dDlvjf71ogPh+TvVBu8Yc0z3D+Mps2dh6oRkcSQyv1epHNl5tf3vK7Rxsj
         +QZlWlSzxgzv7sUvsTLP3iqykDyjeys5MjLS+q2rWGxto63TTVD3WZNGJ2N2nLadSKRE
         jSNJvidqG4gJPAvjXTWCCMyIL9gi32s8DsMCoK685gUop4vIAPeg3Bs+KuvajUY18VyZ
         F2Tw==
X-Gm-Message-State: AOAM533fMwPQDr2HYARwHfNMqL1kwhTP+RcpaBVJnrs4jM+U6Rx5D/C+
        DgNlB9USvKeRh2b8O3EjakY=
X-Google-Smtp-Source: ABdhPJzhsX1xOnjhKTkwadwDJeFX8fWua5amWOWJcVyIqY/a8MXA7kUgitMl879r7HardqTehx+2gg==
X-Received: by 2002:a17:902:8d93:b0:14d:d2e9:37f with SMTP id v19-20020a1709028d9300b0014dd2e9037fmr39027415plo.83.1646373732883;
        Thu, 03 Mar 2022 22:02:12 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b004f104b5350fsm4569073pfi.93.2022.03.03.22.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 22:02:12 -0800 (PST)
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
Subject: [PATCH net-next v2 5/7] net: dev: use kfree_skb_reason() for do_xdp_generic()
Date:   Fri,  4 Mar 2022 14:00:44 +0800
Message-Id: <20220304060046.115414-6-imagedong@tencent.com>
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

Replace kfree_skb() used in do_xdp_generic() with kfree_skb_reason().
The drop reason SKB_DROP_REASON_XDP is introduced for this case.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index cf168f353338..e13ef6ca5470 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -405,6 +405,7 @@ enum skb_drop_reason {
 					 * full (see netdev_max_backlog in
 					 * net.rst) or RPS flow limit
 					 */
+	SKB_DROP_REASON_XDP,		/* dropped by XDP in input path */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 3bb90ca893ae..8c4c343c830f 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -48,6 +48,7 @@
 	EM(SKB_DROP_REASON_TC_EGRESS, TC_EGRESS)		\
 	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
 	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
+	EM(SKB_DROP_REASON_XDP, XDP)				\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 0d097d0e710f..5ad74a46452b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4796,7 +4796,7 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 	}
 	return XDP_PASS;
 out_redir:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_XDP);
 	return XDP_DROP;
 }
 EXPORT_SYMBOL_GPL(do_xdp_generic);
-- 
2.35.1

