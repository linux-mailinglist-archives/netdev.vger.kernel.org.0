Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FDC4CCD89
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbiCDGEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238281AbiCDGD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:03:29 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC23918A785;
        Thu,  3 Mar 2022 22:02:26 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id e6so6665771pgn.2;
        Thu, 03 Mar 2022 22:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YZbkpW2xKyTTQVG0byMXWAewCWAfEpaA/1L3B4lDmmY=;
        b=A7frI2uSydGO/1AMxE9wse0pRdmM6SCrTeiSC4ks2zdnKTOoh79K11ogjz+dYrzatF
         5SGOQG4TcrzA0vB0ZaFznZ9OL7oCYfF8OfDavaviKC3I3/jb4u8bZhdIu7Zxbi0viaiO
         dj7rdX0opfA2OhKzhmMp/BLJAqcUXVAgAqgaqfTa79bJ6Sg2WDQlHDVmLwcqJQzS1nFz
         yb/7EQ4+5yTyGXISzo0Of/SD4jKh+8rhYZfdO3DbYNHQD5f6Xr1yhhqWkJ5qMtEkZt76
         C6UBw7+HdANoaTOuEl8Lr6zvAbPmhgCHBxA/1agdVvzcFJTyIsPHDr4Gl4bj5Jopb99I
         fpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YZbkpW2xKyTTQVG0byMXWAewCWAfEpaA/1L3B4lDmmY=;
        b=KGEMiCIqlzZdz/YOQXuW6K35h3yjVWINy6xStTmH3Z0DTYvTHWGWycVKTs4BOXpa5X
         S/KGFZwvMfrO9IIYcnhO0j8AkCnMZ1VvcCWBHRGlLClNHye6A5fBZb0jMTuondV5Ml3M
         lHle7UATv5T7BkTf4GYFXt/d9x4kH96n89QPZeang3YLCy5lDSQ51EVRHtlCkZpe90MX
         rQfr9SeDalW+/r5B3XmFsff6XDyE+nFGWzjD8sd6iw2zxdmjaskIMYKUIRi2QBDQfXtu
         vxAqX1w2yJ95A9IXEEki3wilV46Froxnu02Jpua2mWq+EVkYSVfdWQFAME2k+fOevYce
         XQgQ==
X-Gm-Message-State: AOAM532TYftNmBv84resKbkKchGCVHuMXQ1qNClOytRRASe6ck9LD67I
        +mAx7e0zUMbaCPZeMFOrYPs=
X-Google-Smtp-Source: ABdhPJzmLM2E3rhp2SgsGu9pz4Do1FqlS0eTGN2KQSFic0NNqz1Z5lmft9TgfEh+k86XL63ysJGIsg==
X-Received: by 2002:a05:6a00:1889:b0:4f6:ae19:130d with SMTP id x9-20020a056a00188900b004f6ae19130dmr3034130pfh.28.1646373745719;
        Thu, 03 Mar 2022 22:02:25 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b004f104b5350fsm4569073pfi.93.2022.03.03.22.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 22:02:24 -0800 (PST)
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
Subject: [PATCH net-next v2 7/7] net: dev: use kfree_skb_reason() for __netif_receive_skb_core()
Date:   Fri,  4 Mar 2022 14:00:46 +0800
Message-Id: <20220304060046.115414-8-imagedong@tencent.com>
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

Add reason for skb drops to __netif_receive_skb_core() when packet_type
not found to handle the skb. For this purpose, the drop reason
SKB_DROP_REASON_PTYPE_ABSENT is introduced. Take ether packets for
example, this case mainly happens when L3 protocol is not supported.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 5 +++++
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 8 +++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d0a10fa477be..070111aecfd3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -407,6 +407,11 @@ enum skb_drop_reason {
 					 */
 	SKB_DROP_REASON_XDP,		/* dropped by XDP in input path */
 	SKB_DROP_REASON_TC_INGRESS,	/* dropped in TC ingress HOOK */
+	SKB_DROP_REASON_PTYPE_ABSENT,	/* not packet_type found to handle
+					 * the skb. For an etner packet,
+					 * this means that L3 protocol is
+					 * not supported
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 514dd2de8776..c0769d943f8e 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -50,6 +50,7 @@
 	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
 	EM(SKB_DROP_REASON_XDP, XDP)				\
 	EM(SKB_DROP_REASON_TC_INGRESS, TC_INGRESS)		\
+	EM(SKB_DROP_REASON_PTYPE_ABSENT, PTYPE_ABSENT)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 7eb293684871..c690c0f7b18c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5329,11 +5329,13 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 		*ppt_prev = pt_prev;
 	} else {
 drop:
-		if (!deliver_exact)
+		if (!deliver_exact) {
 			atomic_long_inc(&skb->dev->rx_dropped);
-		else
+			kfree_skb_reason(skb, SKB_DROP_REASON_PTYPE_ABSENT);
+		} else {
 			atomic_long_inc(&skb->dev->rx_nohandler);
-		kfree_skb(skb);
+			kfree_skb(skb);
+		}
 		/* Jamal, now you will not able to escape explaining
 		 * me how you were going to use this. :-)
 		 */
-- 
2.35.1

