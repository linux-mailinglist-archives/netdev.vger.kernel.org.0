Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E473EC49B
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 20:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbhHNSua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 14:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhHNSu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 14:50:29 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C8FC061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 11:50:00 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j1so20231215pjv.3
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 11:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xkpSi38oXZami+XwnhE9QZye75VIwwT4zuGFKimZ9UQ=;
        b=uIktSVbku+dadRzGT0NaiQI7zgB9CQ1M/2iBlb1NL7gwaI1/C6mag5mdYAHJJ+wOOb
         2PrD2W/hBqLE5nQMdmxXoIE7aVylJ9X1bcgPubMjtXINrHPdw7iSz0zmY2iV8BlqKsOG
         SbCqjNYVsTb6BoLBpNaQw41HgCmjihqChpysX+hz0IGfryrVwnjTIKc/LxvhdIsskHsZ
         Ss8mE/ONSen9y/r5PfWAceJN+DJLnS/z+2Kr8eastirA6EkacbQ/sBpyAUKEBgDS8ZtH
         /fmk+jXtB2fnApMtI+ZwVQiBxOgb8wE/Fs2vN31H8bGkuFwL6ryv/IMByTM3DEnVn3OV
         biYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xkpSi38oXZami+XwnhE9QZye75VIwwT4zuGFKimZ9UQ=;
        b=oEllU7hE5Vcu0z49FyDqcg1Bj4bQ/AXy1WJbZEUrFJzwusVip6mDEkuOT/0fQ70Gsa
         CFNhkJpILwknO7SsOqXHkenRMBYYpGQyKXWlnwldfJPeXBcUr1KEXA8opWm8qcLu/bGU
         YSX4g03RSpqhsg4195AywtEmBlnu3v31NuF5AQN+Ah6Q0xru6hcAULeudBMJ0RnXta5S
         6WzAvZQiVMAkmETrovAfhyAh1PBcedZ1lXC/scVXm9YeDdEJLoaf+aaAlB9dc4fzMVGv
         4pDY2YWFLNa4YAa8BxLjCuEiRX9NSCk+0sIolBzFZknRpdPKBnCPqLLXA8lMxDuJLtV8
         sNkA==
X-Gm-Message-State: AOAM530SvsEtDEZVSjAPMu0hqeREGIRGvVBaW9eCghEjQ5W+WE8+Wa2c
        wG5To6qz75INvDzdqkb73Xo+KV5MbtrG+h9Y
X-Google-Smtp-Source: ABdhPJweOte7VJ9qtzz7kA40uijDAZN9IKqz7TQeq8vfnkCOIpP8fWNUWYfQlx0a0oXnfzYSIZ9m6w==
X-Received: by 2002:a17:90b:104b:: with SMTP id gq11mr8493676pjb.64.1628967000386;
        Sat, 14 Aug 2021 11:50:00 -0700 (PDT)
Received: from lattitude.lan ([49.206.113.179])
        by smtp.googlemail.com with ESMTPSA id r16sm5294736pje.10.2021.08.14.11.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:50:00 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2-next v2 1/3] bridge: reorder cmd line arg parsing to let "-c" detected as "color" option
Date:   Sun, 15 Aug 2021 00:17:25 +0530
Message-Id: <20210814184727.2405108-2-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814184727.2405108-1-gokulkumar792@gmail.com>
References: <20210814184727.2405108-1-gokulkumar792@gmail.com>
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

