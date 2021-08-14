Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65813EC1C7
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 11:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbhHNJzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 05:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237724AbhHNJzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 05:55:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB47C0613CF
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 02:55:22 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n12so14484167plf.4
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 02:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xkpSi38oXZami+XwnhE9QZye75VIwwT4zuGFKimZ9UQ=;
        b=UaqMohjFo+elS2MSyFLXBc3MzsxvlvD6ImWSWlbucthLsR94v+n37av1oNM05ulQtH
         y+EHYy53FoFRM3MmOlyFfA9JIHyAlklmQLlDI2LwGYtB6FJRAnItrSivI/XuUNQLe/AJ
         ncS0wmlc79EJzrsnnQ5ERFoUMEaoKSCkBoYiYCuu8SCZJm2Z2zbWiWEv6ax4AM55tqgA
         0xqrQlPQOyMrleV9COW9q1TPADur3pIudi95fwF4/J4+pE7wQd3F+VYz3eJgs3Zr8Z1h
         txHj6B5m2hNd3Px7zZfcX9fTm2gCfOv1d7d/5+lYDazzLvH526z+JHifPm3za3JsTiYQ
         v4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xkpSi38oXZami+XwnhE9QZye75VIwwT4zuGFKimZ9UQ=;
        b=chBBvsQzPf7xmnzCfrt40iRIJYYjagpkSImt7VSiVCfOUYaLxumklS0aYa4bN1t7WU
         EZrxJYS5WpPu772t9FcNzwxhGa1O4F8/4BcoyPtbgzVUrcR34qg7xmgH88CcAQjWusyx
         gmCET88732kw9hf2lrhuaQTsMpdvs92hMCnUp0undCslXClOolDeZKIa70fCa3ALVdAg
         Y8fJLfrqz45Mf1b95wo3MVpyk6SusIC5JKn/4+uhlebhtXUyyPpuSyFVCSqOtViUThjk
         LPebY/o7CR0MzVdIiv58ncDpBRpxvf/JpMLJaa6TMf2FfDxfq7MQx1PG7o2Ycyo1AfiV
         m5jA==
X-Gm-Message-State: AOAM533bu5MMTezzq0YBijWHxDPFS98M/PeGp2ruha0VMW1F6/16SosV
        pXbEKt+pFwKxvRTWnLBg1E1gUWFKH7aGEQ==
X-Google-Smtp-Source: ABdhPJwYNmY/heCuODfNr72E0yZ+5AXVv7t04nhChgrdaaPjjGjKltOo75IHivcQRYDHBBPuq1qq6w==
X-Received: by 2002:a17:90a:2ecb:: with SMTP id h11mr7013929pjs.159.1628934922234;
        Sat, 14 Aug 2021 02:55:22 -0700 (PDT)
Received: from lattitude.lan ([49.206.113.179])
        by smtp.googlemail.com with ESMTPSA id y7sm5220436pfp.102.2021.08.14.02.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 02:55:21 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2-next 1/3] bridge: reorder cmd line arg parsing to let "-c" detected as "color" option
Date:   Sat, 14 Aug 2021 15:24:37 +0530
Message-Id: <20210814095439.1736737-2-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814095439.1736737-1-gokulkumar792@gmail.com>
References: <20210814095439.1736737-1-gokulkumar792@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per the man/man8/bridge.8 page, the shorthand cmd line arg "-c" can be
used to colorize the bridge cmd output. But while parsing the args in while
loop, matches() detects "-c" as "-compressedvlans" instead of "-color", so
fix this by doing the check for "-color" option first before checking for
"-compressedvlans".

Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 bridge/bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bridge/bridge.c b/bridge/bridge.c
index f7bfe0b5..48b0e7f8 100644
--- a/bridge/bridge.c
+++ b/bridge/bridge.c
@@ -149,9 +149,9 @@ main(int argc, char **argv)
 			NEXT_ARG();
 			if (netns_switch(argv[1]))
 				exit(-1);
+		} else if (matches_color(opt, &color)) {
 		} else if (matches(opt, "-compressvlans") == 0) {
 			++compress_vlans;
-		} else if (matches_color(opt, &color)) {
 		} else if (matches(opt, "-force") == 0) {
 			++force;
 		} else if (matches(opt, "-json") == 0) {
-- 
2.25.1

