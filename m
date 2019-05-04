Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B301398A
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfEDLrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:14 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40125 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbfEDLrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:11 -0400
Received: by mail-qt1-f195.google.com with SMTP id k24so5926370qtq.7
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0FmN1IvOzQdqB1BzI3W3JrFfwZDtEU0Z8ynQdAsMOFQ=;
        b=FS+8zJKLYi7KUpIC7YZUVv8I/aXkVjsBG4GyjRDhaUEHhbkn7Po9r1t/sFqdOjPiWU
         Ny/y3jgoZb3Bt3xLHAk+kZSXzwGQIR2cxsTvwtudti1IrZqqCojv3DRzSz9wRsf1FZFO
         VD5VnSmz64v1ibWMTU+CnDzl4jZRRmyeWGD16/FH5jchHCq2QlOX8BkIAwzZatAR96SG
         gt8uNgbneF0wE0Y79hx5DqURSQxKXDBw4eJRSYd0lHLQH9Yx26eImEaHS+elFe+lQGRz
         3QyWAl4dWbpsYTkG34izxS50AVFPmN7U+J6A1UF9cTK+C9mnQOJPwfm2276dascAzCTG
         qZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0FmN1IvOzQdqB1BzI3W3JrFfwZDtEU0Z8ynQdAsMOFQ=;
        b=mgV8Sq5F3U5Ruzp2R2Mm8XLSjwYXEdYITsuCPSOUb2D2L09PRLTzTZ4i5TsRgGlcVc
         AckMZDZF1JP/vd8jsqrfahqpCVYsXAyaew9nCtkedExg28jkLY/3wxjehcePIGkiTCmo
         lyaynDpIZk3Dy66/DFiMJ/0tYtjpA5lPWkyvzi3zaWeGIcYk8v+YSrWycR71IylJ093Z
         q6JzJda6u4hKsJbRpBU/9MVu0nUxGIYcjFdJ5VC2ybQvL2pCKX6ptor6dD1tzDPtuhF5
         K+/nZL5CMNpEzoQICUpumyn4GHB5u4KxbXc4jhGy4GCbc5mk8sLmrsIsM0eUYywJJOzb
         LV3A==
X-Gm-Message-State: APjAAAWxkZvMlKsmVC5HlsYTFLSTNWjomFkByHoAWpPhECSQlPsv9cqL
        afboC9XNwuzJ30Rd52FAk6Ra9g==
X-Google-Smtp-Source: APXvYqzn5X+nGiAw2L9Wb8GmdnyJQKX+t2kq1kTlRrL1+NG9BE40NupJ0AUHDuvhq9o0XKnxsj2VLQ==
X-Received: by 2002:aed:25f7:: with SMTP id y52mr13385866qtc.247.1556970430264;
        Sat, 04 May 2019 04:47:10 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:09 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 05/13] net/sched: remove unused functions for matchall offload
Date:   Sat,  4 May 2019 04:46:20 -0700
Message-Id: <20190504114628.14755-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Cleanup unused functions and variables after porting to the newer
intermediate representation.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/pkt_cls.h    | 25 -------------------------
 net/sched/cls_matchall.c |  2 --
 2 files changed, 27 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index c852ed502cc6..2d0470661277 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -371,30 +371,6 @@ static inline bool tcf_exts_has_actions(struct tcf_exts *exts)
 #endif
 }
 
-/**
- * tcf_exts_has_one_action - check if exactly one action is present
- * @exts: tc filter extensions handle
- *
- * Returns true if exactly one action is present.
- */
-static inline bool tcf_exts_has_one_action(struct tcf_exts *exts)
-{
-#ifdef CONFIG_NET_CLS_ACT
-	return exts->nr_actions == 1;
-#else
-	return false;
-#endif
-}
-
-static inline struct tc_action *tcf_exts_first_action(struct tcf_exts *exts)
-{
-#ifdef CONFIG_NET_CLS_ACT
-	return exts->actions[0];
-#else
-	return NULL;
-#endif
-}
-
 /**
  * tcf_exts_exec - execute tc filter extensions
  * @skb: socket buffer
@@ -790,7 +766,6 @@ struct tc_cls_matchall_offload {
 	struct tc_cls_common_offload common;
 	enum tc_matchall_command command;
 	struct flow_rule *rule;
-	struct tcf_exts *exts;
 	unsigned long cookie;
 };
 
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 8d135ecab098..87bff17ac782 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -95,7 +95,6 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 
 	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, extack);
 	cls_mall.command = TC_CLSMATCHALL_REPLACE;
-	cls_mall.exts = &head->exts;
 	cls_mall.cookie = cookie;
 
 	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
@@ -297,7 +296,6 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, extack);
 	cls_mall.command = add ?
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
-	cls_mall.exts = &head->exts;
 	cls_mall.cookie = (unsigned long)head;
 
 	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
-- 
2.21.0

